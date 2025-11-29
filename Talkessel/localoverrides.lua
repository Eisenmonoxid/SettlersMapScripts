OverrideLocalFunctions = function()
	GameCallback_LocalRecreateGameLogic_ORIG = GameCallback_LocalRecreateGameLogic;
	GameCallback_LocalRecreateGameLogic = function()
		LocalMapLoadedSetup()
		GameCallback_LocalRecreateGameLogic_ORIG()
	end
	HideLoadScreen_ORIG = HideLoadScreen;
	HideLoadScreen = function()
		HideLoadScreen_ORIG();
		GUI.SendScriptCommand([[HookLibHandler.InitializeColorSetEntries()]])
	end
	if BCS then
		BCS.GetEntityIDToAddToOutStock = function(_goodType)
			if _goodType == nil then 
				return nil;
			end
	
			if _goodType == Goods.G_Gold then 
				return Logic.GetHeadquarters(BCS.CurrentPlayerID);
			end
			
			return false;
		end
	end
	function GameCallback_Feedback_DepotLimitReached(_PlayerID, _EntityID)
		return true;
	end
	function GameCallback_Feedback_NewCouplesAfterFestival(_PlayerID, _NewCouples, _FestivalAbilityIsActive, _NewCouplesByThordal)
		local PlayerID = GUI.GetPlayerID()
		StopEventMusic(MusicSystem.EventFestivalMusic, PlayerID)
		
		if _PlayerID == PlayerID then
			GUI.SendScriptCommand([[CustomFestivalHandler(]]..PlayerID..[[)]]);
		end

		if _PlayerID == PlayerID and Logic.GetCurrentTurn() > 10 and _NewCouples > 0 then	
			GUI_FeedbackWidgets.CityAdd(_NewCouples - _NewCouplesByThordal, nil, {4, 15})
			if _NewCouplesByThordal > 0 then
				GUI_FeedbackWidgets.CityAdd(_NewCouplesByThordal, nil, {6, 7})
			end 
		end
	end

	function GUI_BuildingInfo.BuildingNameUpdate()
		local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
		local EntityID = GUI.GetSelectedEntity()

		if EntityID == 0 or EntityID == nil then
			return;
		end
    
		local EntityType = Logic.GetEntityType(EntityID)
		if EntityType == Entities.B_NPC_Bakery_ME then
			XGUIEng.SetText(CurrentWidgetID, "{center}" .. API.Localize({de = "Turm", en = "Tower"}))
			return;
		end
    
		if Logic.IsLeader(EntityID) == 1 then
			EntityType = Logic.LeaderGetSoldiersType(EntityID)        
		end

		local EntityName = Logic.GetEntityTypeName(EntityType)
		local BuildingName = XGUIEng.GetStringTableText("UI_ObjectNames/" .. EntityName)

		if BuildingName == "" then
			BuildingName = EntityName
		end
		
		if string.find(BuildingName, 'U_NPC') then
			local Text = {de = "Arbeiter", en = "Worker"}
			BuildingName = API.Localize(Text)
		end

		XGUIEng.SetText(CurrentWidgetID, "{center}" .. BuildingName)
	end
	
	function GameCallBack_GUI_BuildRoadCostChanged(_Length)
		local Meters = _Length / 100
		local MetersPerUnit = Logic.GetRoadMetersPerRoadUnit()
		local Costs = {Logic.GetRoadCostPerRoadUnit()}

		for i = 2, table.getn(Costs), 2 do
			Costs[i] = math.ceil(Costs[i] * (Meters / MetersPerUnit))

			if Costs[i] == 0 then
				Costs[i] = 1
			end
		end
		
		Costs[1] = Goods.G_Gold

		GUI_Tooltip.TooltipCostsOnly(Costs)
		XGUIEng.ShowWidget("/InGame/Root/Normal/TooltipCostsOnly", 1)
	end

	function GUI_Tooltip.TooltipBuild(_OptionalPositionTooltipAboveBoolean, _OptionalNoProductionBoolean, _TechnologyType)
		local TooltipContainerPath = "/InGame/Root/Normal/AlignBottomRight/BuildMenu/TooltipBuild"
		local TooltipContainer = XGUIEng.GetWidgetID(TooltipContainerPath)
		local TooltipNameWidget = XGUIEng.GetWidgetID(TooltipContainerPath .. "/Name")
		local TooltipDescriptionWidget = XGUIEng.GetWidgetID(TooltipContainerPath .. "/Text")
		local TooltipDescriptionAnchorBottom = XGUIEng.GetWidgetID(TooltipContainerPath .. "/TextAnchorBottom")
		local TooltipDescriptionAnchorTop = XGUIEng.GetWidgetID(TooltipContainerPath .. "/TextAnchorTop")
		local TooltipCostsContainer = XGUIEng.GetWidgetID(TooltipContainerPath .. "/Costs")
		local TooltipProductionContainer = XGUIEng.GetWidgetID(TooltipContainerPath .. "/Production")
    
		local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
		local PositionWidget = XGUIEng.GetWidgetsMotherID(CurrentWidgetID)
		local WidgetName = XGUIEng.GetWidgetNameByID(CurrentWidgetID)
		local BuildingType
    
		if WidgetName == "B_WallGate" then
			BuildingType = GetEntityTypeForClimatezone("B_WallGate")
		else
			BuildingType = Entities[WidgetName]
		end

		local Costs

		if BuildingType ~= nil then
			Costs = {Logic.GetEntityTypeFullCost(BuildingType)}
		else
			if WidgetName == "Trail" then
				Costs = {0, 0}
			elseif WidgetName == "Street" then
				Costs = {Goods.G_Gold, -1}
			elseif WidgetName == "Palisade" then
				Costs = {Goods.G_Gold, -1}
			elseif WidgetName == "Wall" then
				Costs = {Goods.G_Gold, -1}
			end
		end

		XGUIEng.ShowWidget(TooltipProductionContainer, 0)
		local X, Y = XGUIEng.GetWidgetLocalPosition(TooltipDescriptionAnchorTop)
		XGUIEng.SetWidgetLocalPosition(TooltipDescriptionWidget, X, Y)

		local DisabledTextKeyName   
		if _TechnologyType ~= nil then
			DisabledTextKeyName = GUI_Tooltip.GetDisabledKeyForTechnologyType(_TechnologyType)
		end

		GUI_Tooltip.SetNameAndDescription(TooltipNameWidget, TooltipDescriptionWidget, nil, DisabledTextKeyName)
		GUI_Tooltip.SetCosts(TooltipCostsContainer, Costs)
		local TooltipContainerSizeWidgets = {TooltipContainer}
		GUI_Tooltip.SetPosition(TooltipContainer, TooltipContainerSizeWidgets, PositionWidget, _OptionalPositionTooltipAboveBoolean)
		GUI_Tooltip.FadeInTooltip()
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
end
-- #EOF