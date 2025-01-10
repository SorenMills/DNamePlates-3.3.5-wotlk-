local mediaFolder = "Interface\\AddOns\\dNamePlates\\media\\"	-- 만지지마세요 ...

dNamePlates_config = {

	color = {
		maincolor = {204/255, 10/255, 27/255},			-- 체력바 색
		sndcolor = {208/255, 172/255, 146/255},				-- 폰트 색
		trdcolor = {20/255, 20/255, 20/255},				-- 체력바, 시전바 배경색
		brdcolor = {100/255, 100/255, 100/255},				-- 테두리색
    },
	
	media = {
		barTex = mediaFolder.."d2P",					-- 체력바 텍스쳐(이하 media폴더에 텍스쳐파일 있음)
		CBTex = mediaFolder.."dM2",					-- 시전바 텍스쳐
		glowtex = mediaFolder.."dEBorderE",				-- 테두리 텍스쳐
		
		overlayTex = "Interface\\Tooltips\\Nameplate-Border",		-- ...

		hpBGalpha = 0.8,						-- 체력바 배경 alpha

		NameFont = mediaFolder.."Menescal2002ignis.ttf",		-- 폰트 (대상 이름)	
		NumbFont = mediaFolder.."Menescal2002ignis.ttf",		-- 폰트 (레벨 숫자)	
		NameFS = 8,							-- 폰트사이즈 (대상 이름)
		NumbFS = 9, 							-- 폰트사이즈 (레벨 숫자)
		FontF = "nill", 						-- fontF = nil		-- "THINOUTLINE"
		fontFNum = "nill", 					-- fontFNum = nil 	-- "OUTLINE MONOCHROME"
		abbrevNumb = 20,						-- 대상 이름이 이 것보다 길 경우 간략형으로 표시됩니다. 기본값은 18. 한글에선 35~40 추천 예) 으스러진 전당의 투사=> 으.전.투사
		
		showFontShadow = true,						-- 글자뒤 그림자 숨기기(true, false 중 택1)
		hideOOC = false,						-- 전투가 풀리면 이름표 자동 숨김 켜기 (true, false 중 택1)
		showIC = true,							-- 전투중이면 이름표 자동 표시 켜기 (true, false 중 택1)

		showCurHP = false,						-- 현재 체력값 보이기 (1천이상은 축약형으로 보입니다. 2.5k 등.true, false 중 택1)
		showPerHP = true,						-- 현재 체력 퍼센트 보이기 (true, false 중 택1) 
    },
	
	framesize = {
		offset = {
			["X"] = 0,						-- xOffset - 오프셋 가로값
			["Y"] = 14, 						-- yOffset - 오프셋 세로값
		},
		
		height = {
			["H"] = 6.5,						-- 체력바 높이
			["C"] = 4, 						-- 시전바 높이
			["CI"] = 18, 						-- 시전중인 스킬 아이콘 높이(기본값 20)				
			["RI"] = 18, 						-- 레이드 징표 높이(기본값 20)
			["ClI"] = 18, 						-- 클래스 아이콘 크기(아이콘을 숨기려면 0.1)		
		},
	
		width = {
			["H"] = 100,						-- 체력바 넓이
			["C"] = 100, 						-- 시전바 넓이
			["CI"] = 18, 						-- 시전중인 스킬 아이콘 넓이(기본값 20)				
			["RI"] = 18, 						-- 레이드 징표 넓이(기본값 20)		
			["ClI"] = 18, 						-- 클래스 아이콘 넓이(아이콘을 숨기려면 0.1)		
		},
	
	},
}