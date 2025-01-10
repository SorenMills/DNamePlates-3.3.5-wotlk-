local mediaFolder = "Interface\\AddOns\\dNamePlates\\media\\"	-- ������������ ...

dNamePlates_config = {

	color = {
		maincolor = {204/255, 10/255, 27/255},			-- ü�¹� ��
		sndcolor = {208/255, 172/255, 146/255},				-- ��Ʈ ��
		trdcolor = {20/255, 20/255, 20/255},				-- ü�¹�, ������ ����
		brdcolor = {100/255, 100/255, 100/255},				-- �׵θ���
    },
	
	media = {
		barTex = mediaFolder.."d2P",					-- ü�¹� �ؽ���(���� media������ �ؽ������� ����)
		CBTex = mediaFolder.."dM2",					-- ������ �ؽ���
		glowtex = mediaFolder.."dEBorderE",				-- �׵θ� �ؽ���
		
		overlayTex = "Interface\\Tooltips\\Nameplate-Border",		-- ...

		hpBGalpha = 0.8,						-- ü�¹� ��� alpha

		NameFont = mediaFolder.."Menescal2002ignis.ttf",		-- ��Ʈ (��� �̸�)	
		NumbFont = mediaFolder.."Menescal2002ignis.ttf",		-- ��Ʈ (���� ����)	
		NameFS = 8,							-- ��Ʈ������ (��� �̸�)
		NumbFS = 9, 							-- ��Ʈ������ (���� ����)
		FontF = "nill", 						-- fontF = nil		-- "THINOUTLINE"
		fontFNum = "nill", 					-- fontFNum = nil 	-- "OUTLINE MONOCHROME"
		abbrevNumb = 20,						-- ��� �̸��� �� �ͺ��� �� ��� ���������� ǥ�õ˴ϴ�. �⺻���� 18. �ѱۿ��� 35~40 ��õ ��) �������� ������ ����=> ��.��.����
		
		showFontShadow = true,						-- ���ڵ� �׸��� �����(true, false �� ��1)
		hideOOC = false,						-- ������ Ǯ���� �̸�ǥ �ڵ� ���� �ѱ� (true, false �� ��1)
		showIC = true,							-- �������̸� �̸�ǥ �ڵ� ǥ�� �ѱ� (true, false �� ��1)

		showCurHP = false,						-- ���� ü�°� ���̱� (1õ�̻��� ��������� ���Դϴ�. 2.5k ��.true, false �� ��1)
		showPerHP = true,						-- ���� ü�� �ۼ�Ʈ ���̱� (true, false �� ��1) 
    },
	
	framesize = {
		offset = {
			["X"] = 0,						-- xOffset - ������ ���ΰ�
			["Y"] = 14, 						-- yOffset - ������ ���ΰ�
		},
		
		height = {
			["H"] = 6.5,						-- ü�¹� ����
			["C"] = 4, 						-- ������ ����
			["CI"] = 18, 						-- �������� ��ų ������ ����(�⺻�� 20)				
			["RI"] = 18, 						-- ���̵� ¡ǥ ����(�⺻�� 20)
			["ClI"] = 18, 						-- Ŭ���� ������ ũ��(�������� ������� 0.1)		
		},
	
		width = {
			["H"] = 100,						-- ü�¹� ����
			["C"] = 100, 						-- ������ ����
			["CI"] = 18, 						-- �������� ��ų ������ ����(�⺻�� 20)				
			["RI"] = 18, 						-- ���̵� ¡ǥ ����(�⺻�� 20)		
			["ClI"] = 18, 						-- Ŭ���� ������ ����(�������� ������� 0.1)		
		},
	
	},
}