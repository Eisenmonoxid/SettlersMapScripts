function Mission_LocalOnMapStart() LocalMapLoadedSetup() end
function Mission_LocalVictory() end
function Mission_LoadFiles() return {} end
function Mission_LocalOnQsbLoaded() 
	local Path = (ISDEBUG == true) and "C:\\Siedler\\" or "maps/externalmap/" ..Framework.GetCurrentMapName().. "/";
	Script.Load(Path .. "bcs.bin");
	Script.Load(Path .. "bcs_costs.lua");
	SetMyBuildingCosts()
	
	Script.Load(Path .. "localbuildingplacement.lua");
	MainBuildingPlacement.Init()
	
	Script.Load(Path .. "localoverrides.lua");
	OverrideLocalFunctions()
	
	-- Fix "Meldungsstau"
	if (g_FeedbackSpeechFixC == nil) or (not Trigger.IsTriggerEnabled(g_FeedbackSpeechFixC)) then
		g_FeedbackSpeechFixC = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "FeedbackSpeechEndTimeFixCustom", 1)
		Framework.WriteToLog("Meldungsstau fix is enabled!")
	end
end

FeedbackSpeechEndTimeFixCustom = function()
	local CurrentTime = Framework.GetTimeMs()
	
    if g_FeedbackSpeech ~= nil and g_FeedbackSpeech.LastSpeechEndTime ~= nil and ((CurrentTime + 6000) < g_FeedbackSpeech.LastSpeechEndTime) then
        g_FeedbackSpeech.LastSpeechEndTime = nil
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/MapFrame/FeedbackSpeechText", 0)
		
		if Framework ~= nil and Framework.WriteToLog ~= nil then
			Framework.WriteToLog("Catched Meldungsstau at " .. tostring(CurrentTime))
		end
    end
end

LocalMapLoadedSetup = function()
	local posX, posY = Logic.EntityGetPos(GetID("volcano_effects"))
	Camera.RTS_SetZoomFactor(0.5)
	Camera.RTS_SetLookAtPosition(posX, posY)
		
	local Path = (ISDEBUG == true) and "C:\\Siedler\\" or "maps/externalmap/" ..Framework.GetCurrentMapName().. "/";
	XGUIEng.SetText("/LoadScreen/LoadScreen/ButtonStart", "{darkshadow}{center}{@color:64,0,255,255}Talkessel")
	XGUIEng.SetMaterialTexture("/LoadScreen/LoadScreen/LoadScreenBgd", 0, Path .. "loadscreen.png")

	function GameCallback_HideLoadScreen()
		Framework.SetLoadScreenNeedButton(2)
	end
	if GUI_BuildingInfo.StockWidgetPositions ~= nil then
		GUI_BuildingInfo.StockWidgetPositions = {0, 0} -- Yes, this shouldn't be here ...
	end
	
	DEBUGButtons()
end

DEBUGButtons = function()
    XGUIEng.SetText("/InGame/InGame/MainMenu/Container/QuickSave", "{@color:255, 0, 0, 255}" .. XGUIEng.GetStringTableText("UI_Texts/MainMenuExitProgram_center"))
    function GUI_Window.MainMenuSaveClicked() Framework.ExitGameAndCurrentGame() end
end

AddTowerButton = function()
	MainBuildingPlacement.AddBuildingButton(API.Localize({de = "Turm Bauen", en = "Build Tower"}), API.Localize({de = "Baut einen Turm!", en = "Build a tower!"}), 
	function() MainBuildingPlacement.ActivateBuildingMode(UpgradeCategories.Dummy_00) end, {16, 4})
end
-- #EOF