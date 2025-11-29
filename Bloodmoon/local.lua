function Mission_LocalOnMapStart() GlobalCameFromSave = false; LocalMapLoadedSetup(); end
function Mission_LocalVictory() end
function Mission_LoadFiles() return {} end
function Mission_LocalOnQsbLoaded() 
	LoadBCS();

	-- Fix "Meldungsstau"
	if not S6Patcher then
		if (g_FeedbackSpeechFixC == nil) or (not Trigger.IsTriggerEnabled(g_FeedbackSpeechFixC)) then
			g_FeedbackSpeechFixC = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "FeedbackSpeechEndTimeFixCustom", 1)
			Framework.WriteToLog("Meldungsstau fix is enabled!")
		end
		
		local Text = API.Localize({de = "Es wird empfohlen, das Zoomlimit mit dem S6Patcher auf 12000 zu erhöhen für diese Karte.", en = "It is recommended to increase the zoom distance with the S6Patcher to 12000 for this map."})
		API.DialogInfoBox("Information", Text);
	end
end

LoadBCS = function()
	local Path = (ISDEBUG == true) and "C:\\Siedler\\" or "maps/externalmap/" ..Framework.GetCurrentMapName().. "/";
	Script.Load(Path .. "bcs.bin");
	Script.Load(Path .. "bcs_costs.lua");
	
	SetMyBuildingCosts();
end

OverrideFunctions = function()
	GUI_Construction.BuildClicked = function(_upgradeCategory)
		BCS.CustomBuildClicked(_upgradeCategory, false)
		g_LastPlacedFunction = GUI_Construction.BuildClicked
	end
end

FeedbackSpeechEndTimeFixCustom = function()
	local CurrentTime = Framework.GetTimeMs()
	
    if g_FeedbackSpeech ~= nil and g_FeedbackSpeech.LastSpeechEndTime ~= nil and ((CurrentTime + 6000) < g_FeedbackSpeech.LastSpeechEndTime) then
        g_FeedbackSpeech.LastSpeechEndTime = nil
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/MapFrame/FeedbackSpeechText", 0)
		
		if Framework ~= nil and Framework.WriteToLog ~= nil then
			Framework.WriteToLog("Caught Meldungsstau at " .. tostring(CurrentTime))
		end
    end
end

DEBUGButtons = function()
    XGUIEng.SetText("/InGame/InGame/MainMenu/Container/QuickSave", "{@color:255, 0, 0, 255}" .. XGUIEng.GetStringTableText("UI_Texts/MainMenuExitProgram_center"))
    function GUI_Window.MainMenuSaveClicked() Framework.ExitGameAndCurrentGame() end
end

PreloadAssetsIntoMemory = function()
	Display.SetFarClipPlaneMinAndMax(0, 0)
	Camera.SwitchCameraBehaviour(0)
	Camera.RTS_ToggleMapMode(1)
	Camera.RTS_SetMapModeFOV(90)
	Camera.RTS_SetMapModeZoomDistance(50000)
	Camera.RTS_SetMapModeZoomAngle(90)
    local WorldSizeX, WorldSizeY = Logic.WorldGetSize() 	
	Camera.RTS_SetLookAtPosition(WorldSizeX * 0.5, WorldSizeX * 0.5)
	Display.SetRenderFogOfWar(0)
end

GameCallback_LocalRecreateGameLogic_ORIG = GameCallback_LocalRecreateGameLogic;
GameCallback_LocalRecreateGameLogic = function()
	GlobalCameFromSave = true;
	LocalMapLoadedSetup();
	GameCallback_LocalRecreateGameLogic_ORIG();
end

LocalMapLoadedSetup = function()
	local EntityID = Logic.GetEntitiesOfType(Entities.R_ME_Tree_Broadleaf_Yellow01)[1]
	if EntityID ~= nil then
		Display.SetRenderFogOfWar(0);
		
		local posX, posY = Logic.EntityGetPos(EntityID)
		Camera.RTS_SetZoomFactor(0.3)
		Camera.RTS_SetLookAtPosition(posX, posY)
	end

	local Path = (ISDEBUG == true) and "C:\\Siedler\\" or "maps/externalmap/" ..Framework.GetCurrentMapName().. "/";
	XGUIEng.SetText("/LoadScreen/LoadScreen/ButtonStart", "{darkshadow}{center}{@color:64,0,255,255}Blutmond")
	XGUIEng.SetMaterialTexture("/LoadScreen/LoadScreen/LoadScreenBgd", 0, Path .. "loadscreen.png")

	function GameCallback_HideLoadScreen()
		Framework.SetLoadScreenNeedButton(2)
	end
	if GUI_BuildingInfo.StockWidgetPositions ~= nil then
		GUI_BuildingInfo.StockWidgetPositions = {0, 0} -- Yes, this shouldn't be here ...
	end
	
	HideLoadScreen = function()
		local posX, posY = 0, 0;
		if not GlobalCameFromSave then
			posX, posY = Logic.EntityGetPos(Logic.GetStoreHouse(6));
		else
			posX, posY = Logic.EntityGetPos(Logic.GetKnightID(1));
		end
		Camera.RTS_SetZoomFactor(0.2000);
		Camera.RTS_SetLookAtPosition(posX, posY);

		Sound.StopVoice("ImportantStuff")
		Game.GameTimeSetFactor(GUI.GetPlayerID(), 1)
		XGUIEng.PopPage()
		Input.GameMode()
		Input.KeyBindDown(Keys.ModifierAlt + Keys.F4, "g_MainMenu.OpenExitRequester()", 30)
		GUI_Window.CameFromLoad = 1
		Display.SetRenderFogOfWar(1);
		OverrideFunctions();

		GUI.SendScriptCommand([[
			HookLibHandler.InitializeColorSetEntries();
			if not ]]..tostring(GlobalCameFromSave)..[[ then
				GlobalCameraSystem.ShowStartCutscene() -- Start Scene
			end
		]])
	end
	
	function GUI_Window.ToggleEndScreen()
		local WindowName = "/InGame/InGame/MissionEndScreen"
		if XGUIEng.IsWidgetShown(WindowName) == 0 then
			XGUIEng.PushPage("/InGame/InGame", false)
		end

		XGUIEng.ShowWidget("/InGame/Root/3dWorldView", 0)
		FetchAndSetCursorType()

		XGUIEng.ShowAllSubWidgets("/InGame/InGame", 0)
		XGUIEng.ShowWidget("/InGame/InGame", 1)
		XGUIEng.ShowWidget("/InGame/InGame/Backdrop", 1)
		XGUIEng.ShowWidget(WindowName, 1)
		XGUIEng.ShowAllSubWidgets(WindowName, 0)
		XGUIEng.ShowWidget(WindowName .. "/CurrentStatus", 1)
		XGUIEng.ShowWidget(WindowName .. "/Next", 1)
		XGUIEng.SetText(WindowName .. "/Next", XGUIEng.GetStringTableText("UI_Texts/MissionEndScreenNext_center"))
	
		if g_Victory == true then
			XGUIEng.ShowWidget(WindowName .. "/ContinuePlaying", 0)
			XGUIEng.ShowWidget(WindowName .. "/BGDouble", 1)
		else
			XGUIEng.ShowWidget(WindowName .. "/BG", 1)
		end
	
		XGUIEng.ShowWidget(WindowName .. "/ContinueSpectator", 0)
	end

	function GUI_Window.MissionEndScreenSetVictoryText(_Victory, _VictoryAndDefeatType)
		if _Victory == true then
			local Text = API.Localize({de = "Ihr habt Gewonnen! Danke für's Spielen, "..Profile.GetProfileData(1).."! Sam", en = "You won! Thanks for Playing, "..Profile.GetProfileData(1).."! Sam"});
			XGUIEng.DisableButton("/InGame/InGame/MissionEndScreen/ContinuePlaying", 1)
			XGUIEng.SetTextAlpha("/InGame/InGame/MissionEndScreen/ContinuePlaying", 128)
			XGUIEng.SetText("/InGame/InGame/MissionEndScreen/CurrentStatus/CurrentStatus_Reason", "{darkshadow}{center}{@color:0,100,0,255}" ..Text.. "!")
			XGUIEng.SetText("/InGame/InGame/MissionEndScreen/CurrentStatus/CurrentStatus_HeadLine", "{darkshadow}{center}{@color:0,100,0,255}" ..API.Localize({de = "SIEG", en = "VICTORY"}).. "")
		
			Display.SetRenderFogOfWar(0)
			Display.SetRenderSky(1)
			
			Options.SetIntValue("Eisenmonoxid", "WonBlutmond", 1)
		end
	end
	
	function GUI_Window.ToggleInGameMenu()
		if Framework.IsNetworkGame() == false and Game.GameTimeGetFactor() ~= 0 then --not in multiplayer mode
			KeyBindings_TogglePause()
		end

		local WindowName = "/InGame/InGame/MainMenu"
		if XGUIEng.IsWidgetShownEx(WindowName) == 1 and GUI_Window.CameFromLoad == 0 then
			Sound.FXPlay2DSound("ui\\mini_option_close")
			GUI_Window.CloseInGameMenu()
		else
			GUI_Window.CameFromLoad = 0
			XGUIEng.ShowWidget("/InGame/Root/3dWorldView",0)
        
			Camera.RTS_ResetKeyboardMovement()
			FetchAndSetCursorType()
			Sound.FXPlay2DSound("ui\\mini_option_open")
			XGUIEng.PushPage( "/InGame/InGame", false )

			XGUIEng.ShowAllSubWidgets("/InGame/InGame",0)
			XGUIEng.ShowWidget("/InGame/InGame",1)
			XGUIEng.ShowWidget("/InGame/InGame/Backdrop",1)
			XGUIEng.ShowWidget(WindowName,1)
			XGUIEng.ShowAllSubWidgets(WindowName,1)
			
			XGUIEng.ShowWidget("/InGame/InGame/MainMenu/Container/QuickLoad", 0)
			XGUIEng.ShowWidget("/InGame/InGame/MainMenu/Container/LoadGame", 0)

			GUI_Window.DisplayBottomButtons("/InGame/InGame/MainMenu/ContainerBottom/BacktoGame")
		end
	end
	function GUI_MissionStatistic.SetBG()
		local Path = (ISDEBUG == true) and "C:\\Siedler\\" or "maps/externalmap/" ..Framework.GetCurrentMapName().. "/";
		XGUIEng.SetMaterialTexture("/InGame/MissionStatistic/BG", 0, Path .. "loadscreen.png")
	end
	function GUI_MissionStatistic.InitBottomButtons()
		local ContainerBottomWidget = "/InGame/MissionStatistic/ContainerBottom"
		XGUIEng.ShowAllSubWidgets(ContainerBottomWidget, 0)

		XGUIEng.ShowWidget(ContainerBottomWidget .. "/BackMenu", 1)
		XGUIEng.SetText(ContainerBottomWidget .. "/BackMenu", "{@color:255, 0, 0, 255}" .. XGUIEng.GetStringTableText("UI_Texts/MainMenuExitProgram_center"))
        XGUIEng.ShowWidget(ContainerBottomWidget .. "/RestartMap", 0)
		XGUIEng.ShowWidget(ContainerBottomWidget .. "/LoadGame", 0)

        if g_Victory == true then
            XGUIEng.ShowWidget(ContainerBottomWidget .. "/BGDouble",1)
        else
            XGUIEng.ShowWidget(ContainerBottomWidget .. "/BGTriple",1)
        end
	end
	function GUI_MissionStatistic.Close()
		Framework.ExitGameAndCurrentGame()
	end
	function GUI_Window.MainMenuExit()
		Framework.ExitGameAndCurrentGame()
	end
	
	function KeyBindings_LoadGame()
		if true then return true end;
	end
	
	GUI_BuildingInfo.StockWidgetPositions = {0, 0}
	function GUI_BuildingInfo.InStockTypeUpdate(_index)
		local EntityID = GetBuildingIDAlsoWhenWorkerIsSelected()
		local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
		local MotherContainer = XGUIEng.GetWidgetsMotherID(CurrentWidgetID)
		local AmountWidgetName = XGUIEng.GetWidgetPathByID(MotherContainer) .. "/Amount"

		if EntityID == 0 or EntityID == nil then
			return;
		end

		local NumGoodTypes = Logic.GetNumberOfGoodTypesOnInStock(EntityID)

		if NumGoodTypes == nil or NumGoodTypes == 0 or _index + 1 > NumGoodTypes then
			XGUIEng.ShowWidget(MotherContainer, 0)
			return;
		else
			XGUIEng.ShowWidget(MotherContainer, 1)
		end

		local GoodAmount = Logic.GetAmountOnInStockByIndex(EntityID, _index)
		local GoodType = Logic.GetGoodTypeOnInStockByIndex(EntityID, _index)
			
		local Size = {GUI.GetScreenSize()};
		if _index == 0 then
			if GUI_BuildingInfo.StockWidgetPositions[1] == 0 then
				local posX, posY = XGUIEng.GetWidgetScreenPosition(CurrentWidgetID)
				GUI_BuildingInfo.StockWidgetPositions[1] = posX
				GUI_BuildingInfo.StockWidgetPositions[2] = posY
			end
				
			XGUIEng.SetWidgetScreenPosition(CurrentWidgetID, GUI_BuildingInfo.StockWidgetPositions[1] - ((Size[2] / 1080) * 10), GUI_BuildingInfo.StockWidgetPositions[2] - ((Size[2] / 1080) * 15));
		else
			if GUI_BuildingInfo.StockWidgetPositions[1] == 0 then
				local posX, posY = XGUIEng.GetWidgetScreenPosition(CurrentWidgetID)
				GUI_BuildingInfo.StockWidgetPositions[1] = posX
				GUI_BuildingInfo.StockWidgetPositions[2] = posY
			end
				
			XGUIEng.SetWidgetScreenPosition(CurrentWidgetID, GUI_BuildingInfo.StockWidgetPositions[1] - ((Size[2] / 1080) * 10), GUI_BuildingInfo.StockWidgetPositions[2] + ((Size[2] / 1080) * 25));
		end
		
		SetIcon(CurrentWidgetID, g_TexturePositions.Goods[GoodType])
		XGUIEng.SetText(AmountWidgetName, "{center}" .. GoodAmount)
	end
	
	if GUI_BuildingButtons_ContinueWallUpdate_ORIG == nil then
		GUI_BuildingButtons_ContinueWallUpdate_ORIG = GUI_BuildingButtons.ContinueWallUpdate;
	end
	GUI_BuildingButtons.ContinueWallUpdate = function()
		local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
		local EntityType = Logic.GetEntityType(GUI.GetSelectedEntity());
		if EntityType == Entities.B_FenceTurret then
			XGUIEng.ShowWidget(CurrentWidgetID, 0); -- General game bug fix
			return;
		else
			GUI_BuildingButtons_ContinueWallUpdate_ORIG();
		end
	end
	
	if GetCityReputation_ORIG == nil then
		GetCityReputation_ORIG = Logic.GetCityReputation;
	end
	Logic.GetCityReputation = function(_playerID)
		if _playerID == 2 then
			return 0.9;
		else
			return GetCityReputation_ORIG(_playerID);
		end
	end
	
	DEBUGButtons();
end
-- #EOF