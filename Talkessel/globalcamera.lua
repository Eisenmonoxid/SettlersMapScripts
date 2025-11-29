GlobalCameraSystem = {}
GlobalCameraSystem.ShowStartBriefing = function()
	local ID = Logic.GetEntitiesOfType(Entities.D_ME_Grave01)[1]
    local Briefing = {};
    local AP, ASP = API.AddBriefingPages(Briefing);
	AP{
        Name         = "Page0",
		Title        = "",
		Text         = "",
        Position     = Logic.GetKnightID(1),
        Duration     = 8,
        DialogCamera = false,
        Rotation     = 0,
        Zoom         = 6500,
        Angle        = 90,
		FadeIn       = 6,
		BarOpacity   = 1,
		FarClipPlane = 15000,
		BigBars 	 = false,
	};
    AP{
        Name         = "Page1",
		Title        = "",
		Text         = API.Localize({de = "Hier ruht, in seinem ewig eisigen Grab und bewacht von geisterhaften Türmen, der vergangene Tyrann. Nach seinem Tod entwickelte sich der Ort zu einer Pilgerstätte.", 
									 en = "Here, in his eternally icy grave and guarded by ghostly towers, the past tyrant rests. After his death, the place developed into a place of pilgrimage."}),
        Position     = ID,
        Duration     = 55,
        DialogCamera = false,
        Rotation     = 270,
        Zoom         = 2000,
        Angle        = 5,
		BarOpacity   = 1,
		FarClipPlane = 35000,
		BigBars 	 = true,
	};
	AP{
        Name         = "Page2",
		Title        = "",
		Text         = API.Localize({de = "Doch die Pilgerstätte wurde von dunklen Mächten in Form zweier machthungriger Kastellane eingenommen.", 
									 en = "However, the site was taken over by dark forces in the form of two powerhungry castellans."}),
        Position     = Logic.GetStoreHouse(3),
        Duration     = 25,
        DialogCamera = false,
        Rotation     = 270,
        Zoom         = 12000,
        Angle        = 25,
		BarOpacity   = 1,
		FarClipPlane = 35000,
		BigBars 	 = true,
	};
	AP{
        Name         = "Page3",
		Title        = "",
		Text         = API.Localize({de = "Ihr wurdet vom König entsandt, die Pilgerstätte zu befreien und wieder den Pilgern zugänglich zu machen!", 
									 en = "You were selected by the king to free the site and make it accessible for pilgrims again!"}),
        Position     = Logic.GetKnightID(1),
        Duration     = 20,
        DialogCamera = false,
        Rotation     = 270,
        Zoom         = 12000,
        Angle        = 25,
		BarOpacity   = 1,
		FadeOut      = 5,
		FarClipPlane = 35000,
		BigBars 	 = false,
	};
	
	Briefing.PageAnimations = {
		["Page0"] = {
			-- Animationsdauer, Position1, Rotation1, Zoom1, Angle1, Position2, Rotation2, Zoom2, Angle2
			{8, Logic.GetKnightID(1), 0, 1000, 60, Logic.GetKnightID(1), 50, 5500, 25},
		},
		["Page1"] = {
			{20, "ghosttower06", 0, 3500, 25, ID, 30, 3500, 25},
			{35, ID, 30, 3500, 25, ID, 359, 15000, 60},
		},
		["Page2"] = {
			{25, Logic.GetMarketplace(3), 270, 4500, 25, Logic.GetMarketplace(3), 160, 9500, 75},
		},
		["Page3"] = {
			{15, Logic.GetKnightID(1), 0, 4500, 25, Logic.GetKnightID(1), 160, 16000, 55},
		},
	};
	
    Briefing.Starting = function(_Data)
		API.SendCart(Logic.GetStoreHouse(1), 1, Goods.G_Sausage, 25)
    end
    Briefing.Finished = function(_Data)
		Logic.ExecuteInLuaLocalState([[
			local posX, posY = Logic.EntityGetPos(Logic.GetKnightID(1))
			Camera.RTS_SetZoomFactor(0.2)
			Camera.RTS_SetLookAtPosition(posX, posY)
			AddTowerButton()
		]])
    end

    API.StartBriefing(Briefing, "Startbriefing", 1);
end
GlobalCameraSystem.ShowEndBriefing = function()
    local Briefing = {};
    local AP, ASP = API.AddBriefingPages(Briefing);
	AP{
        Name         = "Page0",
		Title        = "",
		Text         = "",
        Position     = Logic.GetMarketplace(1),
        Duration     = 15,
        DialogCamera = false,
        Rotation     = 0,
        Zoom         = 6500,
        Angle        = 90,
		FadeIn       = 6,
		BarOpacity   = 0,
		BigBars 	 = false,
	};
    AP{
        Name         = "Page1",
		Title        = "",
		Text         = "",
        Position     = Logic.GetMarketplace(1),
        Duration     = 45,
        DialogCamera = false,
        Rotation     = 270,
        Zoom         = 2000,
        Angle        = 5,
		FadeOut      = 8,
		BarOpacity   = 0,
		BigBars 	 = false,
	};
	
	Briefing.PageAnimations = {
		["Page0"] = {
			{15, Logic.GetKnightID(1), 0, 3000, 35, Logic.GetKnightID(1), 120, 4000, 15},
		},
		["Page1"] = {
			{30, Logic.GetKnightID(1), 120, 4000, 25, Logic.GetKnightID(1), 360, 20000, 45},
		},
	};
	
    Briefing.Starting = function(_Data)
		local posX, posY, posZ = Logic.EntityGetPos(Logic.GetMarketplace(1))
		Logic.DEBUG_SetSettlerPosition(Logic.GetKnightID(1), posX + 420, posY + 30);
		
		Logic.ExecuteInLuaLocalState([[
			MainBuildingPlacement.RemoveBuildingButton("StartAttack")
			Display.PlayEnvironmentSettingsSequence(Display.AddEnvironmentSettingsSequence("ME_Special_SunDawn.xml"), 45)
		]])
		
		API.StartDelay(3,
			function()
				Logic.StartFestival(1, 0)
				API.StartEventPlaylist(gvMission.PlaylistRootPath .. "PlaylistEventGameWon.xml", 1)
			end)
    end
    Briefing.Finished = function(_Data)
		Victory(0)
    end

    API.StartBriefing(Briefing, "Endbriefing", 1);
end
-- #EOF