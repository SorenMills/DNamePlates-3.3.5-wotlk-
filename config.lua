local mediaFolder = "Interface\\AddOns\\dNamePlates\\media\\"	-- This is the path to the media files ...

dNamePlates_config = {

    color = {
        maincolor = {204/255, 10/255, 27/255},			-- Main color
        sndcolor = {208/255, 172/255, 146/255},			-- Secondary color
        trdcolor = {20/255, 20/255, 20/255},			-- Main, tertiary color for text
        brdcolor = {100/255, 100/255, 100/255},			-- Border color
    },
    
    media = {
        barTex = mediaFolder.."d2P",				-- Main bar texture (see media files for additional textures)
        CBTex = mediaFolder.."dM2",				-- Secondary bar texture
        glowtex = mediaFolder.."dEBorderE",			-- Border texture

        overlayTex = "Interface\\Tooltips\\Nameplate-Border",	-- ...

        hpBGalpha = 0.8,					-- Main background alpha channel

        NameFont = mediaFolder.."Menescal2002ignis.ttf",	-- Font (for names)
        NumbFont = mediaFolder.."Menescal2002ignis.ttf",	-- Font (for numbers)
        NameFS = 8,						-- Font size (for names)
        NumbFS = 9, 						-- Font size (for numbers)
        FontF = "nill", 					-- fontF = nil		-- "THINOUTLINE"
        fontFNum = "nill", 				-- fontFNum = nil 	-- "OUTLINE MONOCHROME"
        abbrevNumb = 20,					-- Name length at which abbreviation starts. Default is 18. For 35~40 you need -> abbr.

        showFontShadow = true,					-- Show font shadow (true, false Byte EG1)
        hideOOC = false,					-- Hide out of combat (true, false Byte EG1)
        showIC = true,						-- Show in combat (true, false Byte EG1)

        showCurHP = false,					-- Show current HP (1k will be shortened to 1k. 2.5k example. true, false Byte EG1)
        showPerHP = true,					-- Show HP percentage (true, false Byte EG1)
    },
    
    framesize = {
        offset = {
            ["X"] = 0,					-- xOffset - X offset
            ["Y"] = 14, 					-- yOffset - Y offset
        },
        
        height = {
            ["H"] = 6.5,					-- Main bar height
            ["C"] = 4, 					-- Secondary bar height
            ["CI"] = 17, 					-- Class indicator height (default 20)
            ["RI"] = 17, 					-- Role indicator height (default 20)
            ["ClI"] = 17, 					-- Level indicator height (default 0.1 when 0.1)
        },
    
        width = {
            ["H"] = 95,					-- Main bar width
            ["C"] = 95, 					-- Secondary bar width
            ["CI"] = 17, 					-- Class indicator width (default 20)
            ["RI"] = 17, 					-- Role indicator width (default 20)
            ["ClI"] = 17, 					-- Level indicator width (default 0.1 when 0.1)
        },
    
    },
}
