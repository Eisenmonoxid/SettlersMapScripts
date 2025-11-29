GlobalCameraSystem = {}
GlobalCameraSystem.ShowEndBriefing = function()
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
		Zoom         = 3500,
		Angle        = 60,
		FadeIn       = 3,
		BarOpacity   = 1,
		BigBars 	 = false,
	};
	AP{
		Name         = "Page1",
		Title        = "",
		Text         = "",
		Position     = Logic.GetKnightID(1),
		Duration     = 55,
		DialogCamera = false,
		Rotation     = 270,
		Zoom         = 2000,
		Angle        = 5,
		FadeOut      = 10,
		BarOpacity   = 0,
		BigBars 	 = false,
	};
	
	Briefing.PageAnimations = {
		["Page0"] = {
			{8, Logic.GetKnightID(1), 0, 4500, 55, Logic.GetKnightID(1), 120, 3300, 35},
		},
		["Page1"] = {
			{35, "leaving_ship", 120, 2300, 20, "leaving_ship", 360, 6500, 60},
		},
	};
	
	Briefing.Starting = function(_Data)
		local posX, posY, posZ = Logic.EntityGetPos(GetID("Hafenmeister"))
		Logic.DEBUG_SetSettlerPosition(Logic.GetKnightID(1), posX, posY - 60);
		
		Logic.ExecuteInLuaLocalState([[
			Display.StopAllEnvironmentSettingsSequences();
			Display.StopUsingExplicitEnvironmentSettings();
			Display.PlayEnvironmentSettingsSequence(Display.AddEnvironmentSettingsSequence("ME_Special_SunDawn.xml"), 200)
		]])
		
		API.StartDelay(3,
			function()
				Logic.SetVisible(Logic.GetKnightID(1), false)
				API.StopEventPlaylist(gvMission.PlaylistRootPath .. "start_theme.xml");
				API.SoundRestore();
				API.StartEventPlaylist(gvMission.PlaylistRootPath .. "PlaylistEventGameWon.xml", 1);
			end)
	end
	Briefing.Finished = function(_Data)
		Victory(0)
	end

	API.StartBriefing(Briefing, "Endbriefing", 1);
end

GlobalCameraSystem.ShowCastleCutscene = function()
	local Cutscene = {EnableFoW = false};
	local AP = API.AddCutscenePages(Cutscene);
	AP{
		Flight       = "ch03",
		FarClipPlane = 25000,
		Title        = "",
		Text         = "",
		BarOpacity	 = 0,
	};
	
	Cutscene.Starting = function(_Data)
	end
	Cutscene.Finished = function(_Data)
		API.InteractiveObjectActivate("BloodMoonObject");
	end
	
	API.StartCutscene(Cutscene, "CastleScene", 1);
end

GlobalCameraSystem.ShowMainTerritoryCutscene = function()
	API.StopEventPlaylist(gvMission.PlaylistRootPath .. "start_theme.xml");
	API.SoundRestore();
	
	local Cutscene = {EnableFoW = true};
	local AP = API.AddCutscenePages(Cutscene);
	AP{
		Flight       = "ch02",
		FarClipPlane = 30000,
		Title        = "",
		Text         = "",
		BarOpacity	 = 0,
	};
	
	Cutscene.Starting = function(_Data)
		Logic.ExecuteInLuaLocalState([[
			Display.StopAllEnvironmentSettingsSequences();
			Display.StopUsingExplicitEnvironmentSettings();
		]]);
		GlobalBloodMoonActivated = false;
	end
	Cutscene.Finished = function(_Data)	
		Logic.ExecuteInLuaLocalState([[
			local posX, posY = Logic.EntityGetPos(Logic.GetKnightID(1));
			Camera.RTS_SetZoomFactor(0.2)
			Camera.RTS_SetLookAtPosition(posX, posY)
		]]);
		
		API.StartDelay(3,
			function()
				API.HideBuildMenu(false);
				API.SpeedLimitActivate(false);
				API.HideMinimap(false);
				API.DisableSaving(false);
			end);
			
		API.AddScriptEventListener(QSB.ScriptEvents.SaveGameLoaded, function() -- Crappy coding of the QSB makes this necessary (sadly)
			API.HideBuildMenu(false);
			API.SpeedLimitActivate(false);
			API.HideMinimap(false);
			API.DisableSaving(false);
		end);
	end
	
	API.StartCutscene(Cutscene, "TerritoryScene", 1);
end

GlobalCameraSystem.ShowStartCutscene = function()
	local Cutscene = {EnableFoW = false};
	local AP = API.AddCutscenePages(Cutscene);
	
	AP{
		Flight       = "ch01",
		FarClipPlane = 25000,
		Title        = "",
		Text         = "",
		BarOpacity	 = 0,
	};
	
	Cutscene.Starting = function(_Data)
		Logic.ExecuteInLuaLocalState([[
			Display.StopAllEnvironmentSettingsSequences();
			Display.StopUsingExplicitEnvironmentSettings();
			Display.SetExplicitEnvironmentSettings("dark_blue_night.xml");
		]]);
	end
	Cutscene.Finished = function(_Data)
		local posX, posY = Logic.EntityGetPos(Logic.GetStoreHouse(6));
		Logic.DEBUG_SetSettlerPosition(Logic.GetKnightID(1), posX, posY - 800);
	end
	
	API.StartCutscene(Cutscene, "StartScene", 1);
end
-- #EOF