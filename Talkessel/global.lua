function Mission_FirstMapAction()
    Script.Load("maps/externalmap/" ..Framework.GetCurrentMapName().. "/questsystembehavior.lua");

    if Framework.IsNetworkGame() ~= true then
        Startup_Player();
        Startup_StartGoods();
        Startup_Diplomacy();
    end
	
    Mission_OnQsbLoaded();
end

function Mission_InitPlayers() end
function Mission_SetStartingMonth() Logic.SetMonthOffset(5) end
function Mission_InitMerchants() end
function Mission_LoadFiles() return {}; end

-- -------------------------------------------------------------------------- --
-- Diese Funktion wird nach Spielstart aufgerufen.
--
function Mission_OnQsbLoaded()
    API.ActivateDebugMode(false, false, false, false);
	API.ToggleDisplayScriptErrors(false);
	SetupGameParameters()
	
	local Path = (ISDEBUG == true) and "C:\\Siedler\\" or "maps/externalmap/" ..Framework.GetCurrentMapName().. "/";
	-- Load Hook
	Script.Load(Path .. "emxhooklib.bin");
	Script.Load(Path .. "globalhooklibhandler.lua");
	HookLibHandler.Init() -- Potential Exit Point
	
	API.AddScriptEventListener(QSB.ScriptEvents.SaveGameLoaded, function()
		HookLibHandler.Init() -- Potential Exit Point
		API.ActivateDebugMode(false, false, false, false);
		API.ToggleDisplayScriptErrors(false);
	end);
	
	Script.Load(Path .. "globalquestsystem.lua");
	GlobalQuestSystem.Init() -- Start Quests
	
	Script.Load(Path .. "globalcamera.lua");
	GlobalCameraSystem.ShowStartBriefing()
end

-- -------------------------------------------------------------------------- --
SetupGameParameters = function()
	-- No hook stuff, that should be in its own table externally
	SetDiplomacyState(1, 2, DiplomacyStates.Enemy); -- Stadt 2
	SetDiplomacyState(1, 3, DiplomacyStates.Enemy); -- Stadt 3
	SetDiplomacyState(1, 6, DiplomacyStates.Enemy); -- Banditen
	SetDiplomacyState(1, 7, DiplomacyStates.TradeContact); -- Kloster
	SetDiplomacyState(1, 8, DiplomacyStates.TradeContact); -- Hafen
	
	API.SetPlayerName(1, API.Localize({de = "Ritter", en = "Knight"}))
	API.SetPlayerName(2, API.Localize({de = "Kastellan", en = "Castellan"}))
	API.SetPlayerName(3, API.Localize({de = "Kastellan", en = "Castellan"}))
	API.SetPlayerName(6, API.Localize({de = "Banditen", en = "Bandits"}))
	API.SetPlayerName(7, API.Localize({de = "Kloster", en = "Cloister"}))
	API.SetPlayerName(8, API.Localize({de = "Berghafen", en = "Mountain harbour"}))
	
	API.SetPlayerColor(1, 1)
	API.SetPlayerColor(2, 2)
	API.SetPlayerColor(3, 3)
	API.SetPlayerColor(7, 5)
	API.SetPlayerColor(8, 7)
	
	--API.SetPlayerPortrait(1, "H_NPC_Castellan_AS");
	API.SetPlayerPortrait(2, "H_NPC_Castellan_NE");
	API.SetPlayerPortrait(3, "H_NPC_Castellan_NA");
	API.SetPlayerPortrait(6, "H_NPC_Mercenary_NA");
	API.SetPlayerPortrait(7, "H_NPC_Monk_AS");
	API.SetPlayerPortrait(8, "H_NPC_Generic_Trader");
	
	API.AddMercenaryOffer(8, Entities.U_AmmunitionCart, 2, 15);
	API.AddGoodOffer(8, Goods.G_Medicine, 2, 12);
	API.AddGoodOffer(8, Goods.G_PoorSword, 2, 12);
	API.AddGoodOffer(8, Goods.G_PoorBow, 2, 12);
	
	API.AddGoodOffer(7, Goods.G_Bread, 2, 10);
	API.AddGoodOffer(7, Goods.G_Clothes, 2, 10);
	API.AddGoodOffer(7, Goods.G_Broom, 2, 10);
	API.AddGoodOffer(7, Goods.G_Beer, 2, 10);
	
	API.ActivateSheepBreeding(true)
	API.ActivateCattleBreeding(true)
	API.UseSingleStop(true)
	API.UseDowngrade(true)
	API.SetDowngradeCosts(50)
	API.DisableAutoSave(false)
	API.AllowExtendedZoom(false) -- why the ... is this even existing???
	
	MakeInvulnerable(Logic.GetHeadquarters(1))
	MakeInvulnerable(Logic.GetStoreHouse(1))
	MakeInvulnerable(Logic.GetCathedral(1))
	
	Logic.AddGoodToStock(Logic.GetHeadquarters(1), Goods.G_Gold, 3000)
	Logic.SetVisible(Logic.GetStoreHouse(1), false)
	
	AIPlayer:new(2, AIProfile_Skirmish)
	AIPlayer:new(3, AIProfile_Skirmish)
	
	SetPlayerMoral(2, 2.4)
	SetPlayerMoral(3, 2.4)
	SetPlayerMoral(3, 1.5)
	
	GlobalCallbackOverrides()
	API.AddScriptEventListener(QSB.ScriptEvents.SaveGameLoaded, function()
		GlobalCallbackOverrides()
	end);
	
	for Key, Value in pairs(Logic.GetEntitiesOfType(Entities.B_Castle_Rubble_NE)) do
		Logic.SetVisible(Value, false);
    end
end

GlobalCallbackOverrides = function()
	if GameCallback_KnightTitleChanged_ORIG == nil then
		GameCallback_KnightTitleChanged_ORIG = GameCallback_KnightTitleChanged;
	end
	function GameCallback_KnightTitleChanged(_PlayerID, _NewTitle, _OldTitle)
		GameCallback_KnightTitleChanged_ORIG(_PlayerID, _NewTitle, _OldTitle)
	
		Logic.ExecuteInLuaLocalState([[Game.GameTimeSetFactor(GUI.GetPlayerID(), 1)]])
		if _PlayerID == 1 and _NewTitle == KnightTitles.Earl then
			GlobalAttacksActive = true;
		end
	end
	
	if GameCallback_EndOfMonth_ORIG == nil then
		GameCallback_EndOfMonth_ORIG = GameCallback_EndOfMonth;
	end
	function GameCallback_EndOfMonth(_LastMonth, _CurrentMonth)
		GameCallback_EndOfMonth_ORIG(_LastMonth, _CurrentMonth)
	
		if _CurrentMonth == 5 then
			Logic.ExecuteInLuaLocalState([[
				Display.PlayEnvironmentSettingsSequence(Display.AddEnvironmentSettingsSequence("ME_Special_Sundawn.xml"), 180)
			]])
		elseif _CurrentMonth % 2 == 0 then
			CustomTaxCollection()
			CheckStoreHouseGoodsAvailability()
		elseif _CurrentMonth == 9 then
			StartAttack()
		end
	end
end

CheckStoreHouseGoodsAvailability = function()
	local GoodsInCategory = {Logic.GetGoodTypesInGoodCategory(GoodCategories.GC_Resource)};
	local StorehouseID = Logic.GetStoreHouse(1);
	
	local Amount = 0
	for i = 1, #GoodsInCategory do
		if (GoodsInCategory[i] ~= Goods.G_Salt and GoodsInCategory[i] ~= Goods.G_Dye) and Logic.GetIndexOnOutStockByGoodType(StorehouseID, GoodsInCategory[i]) ~= -1 then
			Amount = Logic.GetAmountOnOutStockByGoodType(StorehouseID, GoodsInCategory[i])
			if Amount > 1 then
				Logic.RemoveGoodFromStock(StorehouseID, GoodsInCategory[i], Amount - 1)
			end
			if Amount < 1 then
				Logic.AddGoodToStock(StorehouseID, GoodsInCategory[i], 1);
			end
		end
    end
end

CustomTaxCollection = function()
	local Entities = {Logic.GetPlayerEntitiesInCategory(1, EntityCategories.CityBuilding)}
	local Amount = 0
	for i = 1, #Entities do
		local TaxAmount = math.ceil(Logic.GetBuildingProductEarnings(Entities[i]) * (Logic.GetTaxationLevel(1) * 0.5))
		Amount = Amount + TaxAmount
		
		if TaxAmount ~= 0 then
			Logic.SetBuildingEarnings(Entities[i], math.max(Logic.GetBuildingProductEarnings(Entities[i]) - TaxAmount, 0));
		end
	end
	
	Logic.AddGoodToStock(Logic.GetHeadquarters(1), Goods.G_Gold, Amount)

	local Text = API.Localize({de = "Die monatlichen Steuereinnahmen belaufen sich auf " .. tostring(Amount) .. " Goldmünzen!", 
							   en = "The monthly taxes amounted to " .. tostring(Amount) .. " gold!"})
	
	if not API.IsCinematicEventActive(1) then
		Logic.ExecuteInLuaLocalState("Message(\""..Text.."\", 0, 0)")
	end
	
	Logic.ExecuteInLuaLocalState([[
		GameCallback_Feedback_TaxCollectionFinished(1, ]]..Amount..[[, 0)
	]])
end
CustomFestivalHandler = function(_PlayerID)
	local Entities = {Logic.GetPlayerEntitiesInCategory(_PlayerID, EntityCategories.CityBuilding)}
	local PossibleSpouses = math.random(0, math.max(#Entities - 4, 1))

	for i = 1, #Entities do
		local AmountOfSpouses = 0
		local Inhabitants = {Logic.GetWorkersAndSpousesForBuilding(Entities[i])}
		for j = 1, #Inhabitants do
			if Logic.IsSpouse(Inhabitants[j]) then
				AmountOfSpouses = AmountOfSpouses + 1
			end
		end

		if AmountOfSpouses == 0 then
			local Workers = {Logic.GetWorkersForBuilding(Entities[i])}
			Logic.DEBUG_CreateSpouseForWorker(Workers[1])
						
			PossibleSpouses = PossibleSpouses - 1
		end
					
		if PossibleSpouses == 0 then
			break;
		end
	end
end

CurrentAliveArmyID = -1
GlobalAttacksActive = false
StartAttack = function()
	if not GlobalAttacksActive or not Logic.IsEntityAlive(Logic.GetStoreHouse(3)) then
		return;
	end

	if CurrentAliveArmyID ~= -1 then
		AICore.DisbandUnusedArmy(CurrentAliveArmyID)
	end
	
	local ArmyID, SpawnedTroops = AIScript_SpawnAndCreateArmy(3, Logic.GetStoreHouse(3), 3, 4, 1, 1, 1, 1, true, true)
	CurrentAliveArmyID = ArmyID;
	
	local WhatToAttack = math.random(1, 3)
	if WhatToAttack == 2 then
		AICore.StartAttackWithPlanDestroyHomebase(3, CurrentAliveArmyID, AIScriptHelper_GetEntityID(Logic.GetCathedral(1)))
	elseif WhatToAttack == 1 then
		local AreaID = AICore.CreateAD()
		AICore.AD_AddEntity(AreaID, Logic.GetCathedral(1), 1000)
		AICore.StartAttackWithPlanRaidSettlement(3, CurrentAliveArmyID, AreaID, 0)
	elseif WhatToAttack == 3 then
		local PlayerID = 1
		local Posts = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.Outpost)}
		if #Posts >= 1 then
			local SelectedOutPost = Posts[math.random(#Posts)]
			if (SelectedOutPost ~= nil and SelectedOutPost ~= 0) then
				AICore.StartAttackWithPlanDestroyOutpost(3, CurrentAliveArmyID, SelectedOutPost)
			end
		end
	end
end
-- #EOF