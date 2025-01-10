local dNamePlates = CreateFrame("Frame", nil, UIParent)
dNamePlates:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

local cfgm = dNamePlates_config.media
local cfgc = dNamePlates_config.color
local cfgfs = dNamePlates_config.framesize

local select = select

-- string format
local utf8sub = function(string, i, dots)
	local bytes = string:len()
	if (bytes <= i) then
		return string
	else
		local len, pos = 0, 1
		while(pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)
			if (c > 0 and c <= 127) then
				pos = pos + 1
			elseif (c >= 192 and c <= 223) then
				pos = pos + 2
			elseif (c >= 224 and c <= 239) then
				pos = pos + 3
			elseif (c >= 240 and c <= 247) then
				pos = pos + 4
			end
			if (len == i) then break end
		end

		if (len == i and pos <= bytes) then
			return string:sub(1, pos - 1)..(dots and '...' or '')
		else
			return string
		end
	end
end

local IsValidFrame = function(frame)
	if frame:GetName() then
		return
	end

	overlayRegion = select(2, frame:GetRegions())

	return overlayRegion and overlayRegion:GetObjectType() == "Texture" and overlayRegion:GetTexture() == cfgm.overlayTex
end

local UpdateTime = function(self, curValue)
	local minValue, maxValue = self:GetMinMaxValues()
	if self.channeling then
		self.time:SetFormattedText("%.1f ", curValue)
	else
		self.time:SetFormattedText("%.1f ", maxValue - curValue)
	end
end

-- format numbers
function round(num, idp)
  if idp and idp > 0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function CoolNumber(num)
	if(num >= 1e6) then
		return round(num/1e6,1).."m"
	elseif(num >= 1e3) then
		return round(num/1e3,1).."k"
	else
		return num
	end
end

-- update function
local ThreatUpdate = function(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	if self.elapsed >= 0.2 then
		if not self.oldglow:IsShown() then
			self.healthBar.hpGlow:SetBackdropBorderColor(unpack(cfgc.brdcolor))
		else
			self.healthBar.hpGlow:SetBackdropBorderColor(self.oldglow:GetVertexColor())
		end

		self.healthBar:SetStatusBarColor(self.r, self.g, self.b)

		self.elapsed = 0
	end
	
    local minHealth, maxHealth = self.healthOriginal:GetMinMaxValues()
    local valueHealth = self.healthOriginal:GetValue()
	local d =(valueHealth/maxHealth)*100

		if(d < 100) and valueHealth > 1 then
			if cfgm.showPerHP == true and cfgm.showCurHP == false then
				self.healthBar.percent:SetText(string.format("%d%%", math.ceil((valueHealth/maxHealth)*100)))
			elseif cfgm.showCurHP == true and cfgm.showPerHP == false then
				self.healthBar.percent:SetText(CoolNumber(valueHealth))
			elseif cfgm.showCurHP == true and cfgm.showPerHP == true then
				self.healthBar.percent:SetText(CoolNumber(valueHealth).." . "..(string.format("%d%%", math.ceil((valueHealth/maxHealth)*100))))
			end
		else
			self.healthBar.percent:SetText("")
		end
		
		if(d <= 35 and d >= 20) then
			self.healthBar.percent:SetTextColor(253/255, 238/255, 0/255)
		elseif(d < 20) then
			self.healthBar.percent:SetTextColor(200/255, 20/255, 40/255)
		else		
			self.healthBar.percent:SetTextColor(unpack(cfgc.sndcolor))
		end
end

local UnitType
local UpdateFrame = function(self)
	self.healthBar.UnitType = nil
	local r, g, b = self.healthBar:GetStatusBarColor()
	-- save the original colors for PlateBuffs support
		self.originalR = r
		self.originalG = g
		self.originalB = b
	-- and move on
	local newr, newg, newb
	if g + b == 0 then
		-- Hostile unit
		newr, newg, newb = unpack(cfgc.maincolor)
		self.healthBar:SetStatusBarColor(unpack(cfgc.maincolor))
		if self.boss:IsShown() or self.elite:IsShown() then
			self.healthBar.UnitType = "Hostile"
		end
	elseif r + b == 0 then
		-- Friendly unit
		newr, newg, newb = 0.35, 0.65, 0.35
		self.healthBar:SetStatusBarColor(0.35, 0.65, 0.35)
	elseif r + g == 0 then
		-- Friendly player
		newr, newg, newb = 0.31, 0.45, 0.63
		self.healthBar:SetStatusBarColor(0.31, 0.45, 0.63)
	elseif 2 - (r + g) < 0.05 and b == 0 then
		-- Neutral unit
		newr, newg, newb = 0.7, 0.7, 0.4
		self.healthBar:SetStatusBarColor(0.7, 0.7, 0.4)
	else
		-- Hostile player - class colored.
		newr, newg, newb = r, g, b
	end

	self.r, self.g, self.b = newr, newg, newb

	self.healthBar:ClearAllPoints()
	self.healthBar:SetPoint("CENTER", self.healthBar:GetParent(), cfgfs.offset.X, cfgfs.offset.Y)
	self.healthBar:SetHeight(cfgfs.height.H)
	self.healthBar:SetWidth(cfgfs.width.H)

	self.castBar:ClearAllPoints()
	self.castBar:SetPoint("TOP", self.healthBar, "BOTTOM", 0, -4)
	self.castBar:SetHeight(cfgfs.height.C)
	self.castBar:SetWidth(cfgfs.width.C)

	self.highlight:ClearAllPoints()
	self.highlight:SetAllPoints(self.healthBar)

	local oldName = self.oldname:GetText()
	local newName = (string.len(oldName) > cfgm.abbrevNumb) and string.gsub(oldName, "%s?(.[\128-\191]*)%S+%s", "%1. ") or oldName -- "%s?(.)%S+%s"
	self.name:SetText(newName)
		
	local level, elite, mylevel = tonumber(self.level:GetText()), self.elite:IsShown(), UnitLevel("player")
	self.level:ClearAllPoints()
	self.level:SetPoint("BOTTOMLEFT", self.healthBar, "TOPLEFT", 0, 2)
	if self.boss:IsShown() then
		self.level:SetText("BOSS")
		self.level:SetTextColor(0.8, 0.05, 0)
		self.level:Show()
	else
		self.level:SetText(level..(elite and "+" or ""))
	end
end

local FixCastbar = function(self)
	self.castbarOverlay:Hide()

	self:SetHeight(cfgfs.height.C)
	self:ClearAllPoints()
	self:SetPoint("TOP", self.healthBar, "BOTTOM", 0, -4)
end

local ColorCastBar = function(self, shielded)
	if shielded then
		self:SetStatusBarColor(0.8, 0.05, 0)
		self.cbGlow:SetBackdropBorderColor(0.75, 0.75, 0.8)
	else
		self.cbGlow:SetBackdropBorderColor(unpack(cfgc.brdcolor))
	end
end

local OnSizeChanged = function(self)
	self.needFix = true
end

local OnValueChanged = function(self, curValue)
	UpdateTime(self, curValue)
	if self.needFix then
		FixCastbar(self)
		self.needFix = nil
	end
end

local OnShow = function(self)
	self.channeling  = UnitChannelInfo("target") 
	FixCastbar(self)
	ColorCastBar(self, self.shieldedRegion:IsShown())
	self.cbIcon:Show()		
end

local OnHide = function(self)
	self.highlight:Hide()	
	self.healthBar.hpGlow:SetBackdropBorderColor(unpack(cfgc.brdcolor))
end

local HideSpellIcon = function(self)
	self.cbIcon:Hide()	
end

local OnEvent = function(self, event, unit)
	if unit == "target" then
		if self:IsShown() then
			ColorCastBar(self, event == "UNIT_SPELLCAST_NOT_INTERRUPTIBLE")
		end
	end
end

-- style
local CreateFrame = function(frame)
	if frame.done then
		return
	end

	frame.nameplate = true

	frame.healthBar, frame.castBar = frame:GetChildren()
	local healthBar, castBar = frame.healthBar, frame.castBar
	local glowRegion, overlayRegion, castbarOverlay, shieldedRegion, spellIconRegion, highlightRegion, nameTextRegion, levelTextRegion, bossIconRegion, raidIconRegion, stateIconRegion = frame:GetRegions()
    frame.healthOriginal = healthBar
	
	frame.level = levelTextRegion
	levelTextRegion:SetFont(cfgm.NumbFont, cfgm.NumbFS, cfgm.fontFNum)
	frame.level:SetShadowOffset(0,0)
	
	frame.oldname = nameTextRegion
	nameTextRegion:Hide()
	
	local newNameRegion = frame:CreateFontString()
	newNameRegion:SetPoint("LEFT", frame.level, "RIGHT", 2, 0)
	newNameRegion:SetFont(cfgm.NameFont, cfgm.NameFS, cfgm.FontF)
	newNameRegion:SetTextColor(unpack(cfgc.sndcolor))
	frame.name = newNameRegion		
	
	healthBar:SetStatusBarTexture(cfgm.barTex)
	healthBar:SetStatusBarTexture(cfgm.barTex)
	
	healthBar.hpBackground = healthBar:CreateTexture(nil, "BORDER")
	healthBar.hpBackground:SetAllPoints(healthBar)
	healthBar.hpBackground:SetTexture(cfgm.barTex)
	healthBar.hpBackground:SetVertexColor(unpack(cfgc.trdcolor))
	healthBar.hpBackground:SetAlpha(cfgm.hpBGalpha)
	
	healthBar.hpGlow = CreateFrame("Frame", nil, healthBar)
	healthBar.hpGlow:SetPoint("TOPLEFT", healthBar, "TOPLEFT", -1.75, 2)
	healthBar.hpGlow:SetPoint("BOTTOMRIGHT", healthBar, "BOTTOMRIGHT", 2, -1.75)
	healthBar.hpGlow:SetBackdrop{edgeFile = cfgm.glowtex, edgeSize = 6, insets = {left = 0, right = 0, top = 0, bottom = 0}}
	healthBar.hpGlow:SetBackdropColor(0, 0, 0)
	healthBar.hpGlow:SetBackdropBorderColor(unpack(cfgc.brdcolor))

	healthBar.percent = healthBar.hpGlow:CreateFontString(nil, "OVERLAY")	
	healthBar.percent:SetFont(cfgm.NumbFont, cfgm.NumbFS, cfgm.fontFNum)
	healthBar.percent:SetPoint("LEFT", healthBar, "RIGHT", 5, 0)
	healthBar.percent:SetTextColor(unpack(cfgc.sndcolor))
	healthBar.percent:SetJustifyH("RIGHT")	

	castBar.castbarOverlay = castbarOverlay
	castBar.healthBar = healthBar
	castBar.shieldedRegion = shieldedRegion
	castBar:SetStatusBarTexture(cfgm.CBTex)

	castBar:HookScript("OnShow", OnShow)
	castBar:HookScript("OnHide", HideSpellIcon)	
	castBar:HookScript("OnSizeChanged", OnSizeChanged)
	castBar:HookScript("OnValueChanged", OnValueChanged)
	castBar:HookScript("OnEvent", OnEvent)
	castBar:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE")
	castBar:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE")

	castBar.time = castBar:CreateFontString(nil, "ARTWORK")
	castBar.time:SetPoint("LEFT", castBar, "RIGHT", 5, -1)
	castBar.time:SetFont(cfgm.NumbFont, cfgm.NumbFS, cfgm.fontFNum)
	castBar.time:SetTextColor(unpack(cfgc.sndcolor))
	
	castBar.cbBackground = castBar:CreateTexture(nil, "BORDER")
	castBar.cbBackground:SetAllPoints(castBar)
	castBar.cbBackground:SetTexture(cfgm.barTex)
	castBar.cbBackground:SetVertexColor(unpack(cfgc.trdcolor))
	
	castBar.cbGlow = CreateFrame("Frame", nil, castBar)
	castBar.cbGlow:SetPoint("TOPLEFT", castBar, "TOPLEFT",  -1.75, 2)
	castBar.cbGlow:SetPoint("BOTTOMRIGHT", castBar, "BOTTOMRIGHT", 2, -1.75)
	castBar.cbGlow:SetBackdrop{edgeFile = cfgm.glowtex, edgeSize = 6, insets = {left = -2, right = -2, top = -2, bottom = -2}}
	castBar.cbGlow:SetBackdropColor(0, 0, 0)
	castBar.cbGlow:SetBackdropBorderColor(unpack(cfgc.brdcolor))
	
	-- some frame strata dancing
	castBar.Hold = CreateFrame("Frame", nil, healthBar)
	castBar.Hold:SetPoint("TOPLEFT", healthBar, "TOPLEFT", 0, 0)
	castBar.Hold:SetPoint("BOTTOMRIGHT", healthBar, "BOTTOMRIGHT", 0, 0)	
	castBar.Hold:SetFrameLevel(10)
	castBar.Hold:SetFrameStrata("MEDIUM")	

	local cIconTex = castBar.Hold:CreateTexture(nil, "OVERLAY")
	cIconTex:SetPoint("BOTTOMRIGHT", healthBar, "BOTTOMLEFT", -4, 0)
	cIconTex:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
	cIconTex:SetHeight(cfgfs.height.ClI)
	cIconTex:SetWidth(cfgfs.width.ClI)	
	frame.icon = cIconTex	
	
	frame.icon.Glow = CreateFrame("Frame", nil, frame)
	frame.icon.Glow:SetPoint("TOPLEFT", frame.icon, "TOPLEFT", -1.75, 2)
	frame.icon.Glow:SetPoint("BOTTOMRIGHT", frame.icon, "BOTTOMRIGHT", 2, -1.75)
	frame.icon.Glow:SetBackdrop{bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = cfgm.glowtex, edgeSize = 6, insets = {left = 0, right = 0, top = 0, bottom = 0}}
	frame.icon.Glow:SetBackdropColor(0, 0, 0)
	frame.icon.Glow:SetBackdropBorderColor(unpack(cfgc.brdcolor))
	frame.icon.Glow:SetFrameLevel(0)
	frame.icon.Glow:SetFrameStrata("BACKGROUND")
	frame.icon.Glow:Hide()		

	spellIconRegion:ClearAllPoints()
	spellIconRegion:SetParent(castBar.Hold)
	spellIconRegion:SetPoint("LEFT", castBar, "LEFT", 8, 0)		
	spellIconRegion:SetHeight(cfgfs.height.CI)
	spellIconRegion:SetWidth(cfgfs.width.CI)
	
	-- some more frame strata dancing ...
	castBar.Hold2 = CreateFrame("Frame", nil, healthBar)
	castBar.Hold2:SetAllPoints(spellIconRegion)
	castBar.Hold2:SetFrameLevel(12)
	castBar.Hold2:SetFrameStrata("MEDIUM")		

	castBar.cbIcon = castBar.Hold2:CreateTexture(nil, "OVERLAY")
	castBar.cbIcon:SetPoint("TOPLEFT", spellIconRegion, "TOPLEFT", -0, 0)
	castBar.cbIcon:SetPoint("BOTTOMRIGHT", spellIconRegion, "BOTTOMRIGHT", 0, -0)		
	castBar.cbIcon:SetTexture("Interface\\AddOns\\dNamePlates\\media\\dBBorderJ")
	castBar.cbIcon:SetVertexColor(unpack(cfgc.maincolor))
	castBar.cbIcon:Hide()
	
	highlightRegion:SetTexture("Interface\\AddOns\\dNamePlates\\media\\mouseover")
	highlightRegion:SetVertexColor(0.75, 0.55, 0.55, 0.8)
	frame.highlight = highlightRegion

	raidIconRegion:ClearAllPoints()
	raidIconRegion:SetParent(castBar.Hold)	
	raidIconRegion:SetPoint("BOTTOMRIGHT", healthBar, "TOPRIGHT", -2, -4)
	raidIconRegion:SetHeight(cfgfs.height.RI)
	raidIconRegion:SetWidth(cfgfs.width.RI)
	raidIconRegion:SetTexture("Interface\\AddOns\\dNamePlates\\media\\raidicons")	
	
	if cfgm.showFontShadow == true then	
		castBar.time:SetShadowOffset(1.25, -1.25)
		healthBar.percent:SetShadowOffset(1.25, -1.25)
		levelTextRegion:SetShadowOffset(1.25, -1.25)
		newNameRegion:SetShadowOffset(1.25, -1.25)
		frame.level:SetShadowOffset(1.25, -1.25)	
	end
	
	frame.oldglow = glowRegion
	frame.elite = stateIconRegion
	frame.boss = bossIconRegion

	frame.done = true

	glowRegion:SetTexture(nil)
	overlayRegion:SetTexture(nil)
	shieldedRegion:SetTexture(nil)
	castbarOverlay:SetTexture(nil)
	stateIconRegion:SetTexture(nil)
	bossIconRegion:SetTexture(nil)

	UpdateFrame(frame)
	frame:HookScript("OnShow", UpdateFrame)
	frame:HookScript("OnHide", OnHide)

	frame.elapsed = 0
	frame:HookScript("OnUpdate", ThreatUpdate)
	frame:HookScript("OnUpdate", UpdateClass)	
end

-- update class func
function UpdateClass(frame)
		local r, g, b = frame.healthBar:GetStatusBarColor();
		local r, g, b = floor(r*100+.5)/100, floor(g*100+.5)/100, floor(b*100+.5)/100;
		local classname = "";
		local hasclass = 0;
		for class, color in pairs(RAID_CLASS_COLORS) do
			if RAID_CLASS_COLORS[class].r == r and RAID_CLASS_COLORS[class].g == g and RAID_CLASS_COLORS[class].b == b then
				classname = class;
			end
		end
		if (classname) then
			texcoord = CLASS_BUTTONS[classname];
			if texcoord then
				hasclass = 1;
			else
				texcoord = {0.5, 0.75, 0.5, 0.75};
				hasclass = 0;
			end
		else
			texcoord = {0.5, 0.75, 0.5, 0.75};
			hasclass = 0;
		end
		frame.icon:SetTexCoord(texcoord[1],texcoord[2],texcoord[3],texcoord[4]);
		if hasclass == 1 then
			frame.icon.Glow:Show()
		else
			frame.icon.Glow:Hide()
		end
end		

local numKids = 0
local lastUpdate = 0
local OnUpdate = function(self, elapsed)
	lastUpdate = lastUpdate + elapsed

	if lastUpdate > 0.1 then
		lastUpdate = 0

		local newNumKids = WorldFrame:GetNumChildren()
		if newNumKids ~= numKids then
			for i = numKids+1, newNumKids do
				frame = select(i, WorldFrame:GetChildren())

				if IsValidFrame(frame) then
					CreateFrame(frame)
				end
			end
			numKids = newNumKids
		end
	end
end

dNamePlates:SetScript("OnUpdate", OnUpdate)

if cfgm.hideOOC == true then
	dNamePlates:RegisterEvent("PLAYER_REGEN_ENABLED")
	function dNamePlates:PLAYER_REGEN_ENABLED()
		SetCVar("nameplateShowEnemies", 0)
	end
end

if cfgm.showIC == true then
	dNamePlates:RegisterEvent("PLAYER_REGEN_DISABLED")
	function dNamePlates.PLAYER_REGEN_DISABLED()
		SetCVar("nameplateShowEnemies", 1)
	end
end