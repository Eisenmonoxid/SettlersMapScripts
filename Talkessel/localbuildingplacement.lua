MainBuildingPlacement = {}
MainBuildingPlacement.RootPath = "/InGame/Root/Normal/AlignTopLeft/KnightCommands/"
MainBuildingPlacement.ButtonWidgets = {{"StartAttack", "MissionSpecific_StartAttack", false}, {"Bless", "MissionSpecific_Bless", false}, {"Trebuchet", "MissionSpecific_Trebuchet", false}}
MainBuildingPlacement.ButtonsInUse = {}

MainBuildingPlacement.ShowButtonWidget = function(Value)
	local WidgetName = MainBuildingPlacement.RootPath .. Value[1]
	local WidgetTimeName = WidgetName .. "/Time"
		
	XGUIEng.ShowWidget(WidgetName, 1)
	XGUIEng.ShowWidget(WidgetTimeName, 0)
end

MainBuildingPlacement.Init = function()
	MainBuildingPlacement.OverrideTooltip()
	
	API.AddScriptEventListener(QSB.ScriptEvents.SaveGameLoaded, function()
		local WidgetName, WidgetTimeName
		for Key, Value in pairs(MainBuildingPlacement.ButtonWidgets) do
			if Value[3] then
				MainBuildingPlacement.ShowButtonWidget(Value)
			end
		end
	end);
end
MainBuildingPlacement.AddBuildingButton = function(_tooltipText, _tooltipTitle, _functionCall, _iconTable)
	for Key, Value in pairs(MainBuildingPlacement.ButtonWidgets) do
		if not Value[3] then 
			MainBuildingPlacement.ShowButtonWidget(Value)
			Value[3] = true
			MainBuildingPlacement.ButtonsInUse[Value[1]] = {_tooltipText, _tooltipTitle, _functionCall, _iconTable}
			return Value[1];
		end
	end
end
MainBuildingPlacement.RemoveBuildingButton = function(_indexString)
	local WidgetName, WidgetTimeName
	for Key, Value in pairs(MainBuildingPlacement.ButtonWidgets) do
		if Value[1] == _indexString and Value[3] then
			WidgetName = MainBuildingPlacement.RootPath .. Value[1]
			XGUIEng.ShowWidget(WidgetName, 0)
			
			Value[3] = false
			return;
		end
	end
end
MainBuildingPlacement.OverrideTooltip = function()
	MainBuildingPlacement.GUI_Tooltip_SetNameAndDescription_ORIG = GUI_Tooltip.SetNameAndDescription
	function GUI_Tooltip.SetNameAndDescription(_TooltipNameWidget, _TooltipDescriptionWidget, _OptionalTextKeyName, _OptionalDisabledTextKeyName,
		_OptionalMissionTextFileBoolean)

		for i = 1, #MainBuildingPlacement.ButtonWidgets do
			if _OptionalTextKeyName == MainBuildingPlacement.ButtonWidgets[i][2] then
				local Button = MainBuildingPlacement.ButtonsInUse[MainBuildingPlacement.ButtonWidgets[i][1]]
				MainBuildingPlacement.SetUserToolTip(Button[1], Button[2], _TooltipNameWidget, _TooltipDescriptionWidget)
				return;
			end
		end
		
		if _OptionalTextKeyName == "G_Regalia" then -- Yep, this shouldn't be here
			MainBuildingPlacement.SetUserToolTip("Regalia", API.Localize({de = "- Wird von Gerbereien verwendet", en = "- Is used by tanneries"}), _TooltipNameWidget, _TooltipDescriptionWidget)
			return;
		end

		MainBuildingPlacement.GUI_Tooltip_SetNameAndDescription_ORIG(_TooltipNameWidget, _TooltipDescriptionWidget, _OptionalTextKeyName, _OptionalDisabledTextKeyName, _OptionalMissionTextFileBoolean)
	end
end

function Mission_SupportButtonClicked(_AttackType)
	MainBuildingPlacement.ButtonsInUse[MainBuildingPlacement.ButtonWidgets[_AttackType + 1][1]][3]()
end
function Mission_SupportUpdateTimer(_AttackType)
	return true
end
function Mission_SupportUpdateButton(_AttackType)
	local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
	SetIcon(CurrentWidgetID, MainBuildingPlacement.ButtonsInUse[MainBuildingPlacement.ButtonWidgets[_AttackType + 1][1]][4])
end

MainBuildingPlacement.SetUserToolTip = function(_Name, _Description, _TooltipNameWidget, _TooltipDescriptionWidget)
	XGUIEng.SetText(_TooltipNameWidget, "{center}" .. _Name)
	XGUIEng.SetText(_TooltipDescriptionWidget, "{center}" .. _Description)
    
	local Height = XGUIEng.GetTextHeight(_TooltipDescriptionWidget, true)
	local W, H = XGUIEng.GetWidgetSize(_TooltipDescriptionWidget)
    
	XGUIEng.SetWidgetSize(_TooltipDescriptionWidget, W, Height)
end

MainBuildingPlacement.ActivateBuildingMode = function(_BuildingType)
    PlacementState = 0
    XGUIEng.UnHighLightGroup("/InGame", "Construction")
    Sound.FXPlay2DSound("ui\\menu_select")
    GUI.CancelState()
    GUI.ActivatePlaceBuildingState(_BuildingType)
	g_LastPlacedParam = _BuildingType

    XGUIEng.ShowWidget("/Ingame/Root/Normal/PlacementStatus",1)
    GUI_Construction.CloseContextSensitiveMenu()
end
-- #EOF