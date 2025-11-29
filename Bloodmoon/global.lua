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
function Mission_SetStartingMonth() Logic.SetMonthOffset(3) end
function Mission_InitMerchants() end
function Mission_LoadFiles() return {}; end

-- -------------------------------------------------------------------------- --
-- Diese Funktion wird nach Spielstart aufgerufen.
--
function Mission_OnQsbLoaded()
	API.ActivateDebugMode(false, false, false, false);
	API.ToggleDisplayScriptErrors(false);

	local Path = (ISDEBUG == true) and "C:\\Siedler\\" or "maps/externalmap/" ..Framework.GetCurrentMapName().. "/";
	-- Load Hook
	Script.Load(Path .. "emxhooklib.bin");
	Script.Load(Path .. "globalhooklibhandler.lua");
	Script.Load(Path .. "globalhookmappings.lua");
	HookLibHandler.Initialize(false); -- Potential Exit Point
	
	API.AddScriptEventListener(QSB.ScriptEvents.SaveGameLoaded, function()
		HookLibHandler.Initialize(true) -- Potential Exit Point
		API.ActivateDebugMode(false, false, false, false);
		API.ToggleDisplayScriptErrors(false);
	end);

	SetupGameParameters();
	
	Script.Load(Path .. "globalcamerasystem.lua");
	Script.Load(Path .. "globalquestsystem.lua");
	GlobalQuestSystem.Init() -- Start Quests
	
	API.SoundSetAtmoVolume(0);
	API.StartEventPlaylist(gvMission.PlaylistRootPath .. "start_theme.xml");
end

-- -------------------------------------------------------------------------- --
SetupGameParameters = function()
	-- No hook stuff, that should be in its own table externally
	local Walls = {Logic.GetPlayerEntitiesInCategory(8, EntityCategories.Wall)};
	for i = 1, #Walls do
		Logic.SetVisible(Walls[i], false);
	end
	
	API.UseSingleStop(true)
	API.UseDowngrade(true)
	API.SetDowngradeCosts(50)
	API.DisableAutoSave(false)
	API.AllowExtendedZoom(false) -- Complete garbage, the only real solution for higher zoom is the S6Patcher
	API.HideBuildMenu(true)
	API.SpeedLimitActivate(true)
	API.HideMinimap(true)
	API.DisableSaving(true)

	SetDiplomacyState(1, 2, DiplomacyStates.Undecided); -- Stadt 2
	SetDiplomacyState(1, 3, DiplomacyStates.Enemy); -- Unused ID
	SetDiplomacyState(1, 4, DiplomacyStates.Undecided); -- Dorf
	SetDiplomacyState(1, 5, DiplomacyStates.Enemy); -- Banditen
	SetDiplomacyState(1, 6, DiplomacyStates.TradeContact); -- Hafen
	SetDiplomacyState(1, 7, DiplomacyStates.Undecided); -- Kloster
	SetDiplomacyState(1, 8, DiplomacyStates.Undecided); -- Pumpenwart
	
	API.SetPlayerName(1, "Thordal")
	API.SetPlayerName(2, API.Localize({de = "Kastellan Praphat", en = "Castellan Praphat"}))
	API.SetPlayerName(3, API.Localize({de = "Kastellan Praphat", en = "Castellan Praphat"}))
	API.SetPlayerName(4, API.Localize({de = "Dorf", en = "Village"}))
	API.SetPlayerName(5, API.Localize({de = "Banditen", en = "Bandits"}))
	API.SetPlayerName(6, API.Localize({de = "Hafenmeister Elias", en = "Harbourmaster Elias"}))
	API.SetPlayerName(7, API.Localize({de = "Kloster", en = "Cloister"}))
	API.SetPlayerName(8, API.Localize({de = "Pumpenwart", en = "Pump maintainer"}))
	
	for i = 1, 8 do
		API.SetPlayerColor(i, i);
	end
	API.SetPlayerColor(3, 2)

	API.SetPlayerPortrait(1, "H_Knight_Song");
	API.SetPlayerPortrait(2, "H_Knight_Praphat");
	API.SetPlayerPortrait(4, "H_NPC_Villager01_ME");
	API.SetPlayerPortrait(5, "H_NPC_Mercenary_NA");
	API.SetPlayerPortrait(6, "H_Knight_Trading");
	API.SetPlayerPortrait(7, "H_NPC_Monk_ME");
	API.SetPlayerPortrait(8, "H_NPC_Villager01_NE");

	API.AddGoodOffer(2, Goods.G_Wool, 3, 65);
	API.AddGoodOffer(2, Goods.G_Grain, 4, 45);
	API.AddGoodOffer(2, Goods.G_Stone, 4, 45);
	API.AddGoodOffer(2, Goods.G_Iron, 4, 45);
	
	API.AddGoodOffer(4, Goods.G_Gems, 4, 25);
	API.AddGoodOffer(4, Goods.G_Dye, 4, 25);
	API.AddGoodOffer(4, Goods.G_Salt, 4, 25);
	API.AddGoodOffer(4, Goods.G_Olibanum, 4, 25);
	
	API.AddGoodOffer(6, Goods.G_Salt, 4, 45);
	API.AddGoodOffer(6, Goods.G_Dye, 4, 45);
	API.AddGoodOffer(6, Goods.G_MusicalInstrument, 4, 45);
	API.AddGoodOffer(6, Goods.G_Cheese, 2, 45);
	
	API.AddGoodOffer(7, Goods.G_Sheep, 2, 85);
	API.AddGoodOffer(7, Goods.G_Olibanum, 4, 45);
	API.AddGoodOffer(7, Goods.G_Cow, 2, 85);
	API.AddGoodOffer(7, Goods.G_Gems, 4, 45);
	
	API.AddMercenaryOffer(8, Entities.U_AmmunitionCart, 1, 45);
	API.AddGoodOffer(8, Goods.G_Medicine, 3, 45);
	API.AddGoodOffer(8, Goods.G_Broom, 3, 45);
	API.AddGoodOffer(8, Goods.G_Leather, 3, 45);
	
	InitializeTradeposts()
	SetupMinesAndQuarries()
	CreateInformationTent()

	AIPlayer:new(2, AIProfile_Skirmish)
	OrderWallCatapultsForAI(2)
	
	SetPlayerMoral(2, 2.5)
	SetPlayerMoral(5, 2.1)
	
	Logic.SetTerritoryPrice(GetTerritoryIDByName("Riverdale"), 0);
	Logic.SetVisible(GetID("leaving_ship"), false);
	
	local LuxuryGoods = {Goods.G_Salt, Goods.G_Dye, Goods.G_Gems, Goods.G_Olibanum, Goods.G_MusicalInstrument};
	for i = 1, #LuxuryGoods do
		MerchantSystem.BasePrices[LuxuryGoods[i]] = math.random(15, 20);
		MerchantSystem.RefreshRates[LuxuryGoods[i]] = math.random(10, 15);
	end

	GlobalCallbackOverrides()
	API.AddScriptEventListener(QSB.ScriptEvents.SaveGameLoaded, GlobalCallbackOverrides);
	
	StartSimpleJob("CheatGoodsForEnemyPlayer");
end

CreateInformationTent = function()
	local Type = Entities.B_NPC_Tent_Information;
	local posX, posY = Logic.EntityGetPos(Logic.GetHeadquarters(2));
	local orientation = Logic.GetEntityOrientation(Logic.GetHeadquarters(2));
	local ID = Logic.CreateEntity(Type, posX, posY, orientation, 3);
	Logic.SetEntityName(ID, "EnemyTent")
	
	Logic.SetVisible(Logic.GetHeadquarters(2), false)
end

SetupMinesAndQuarries = function()
	local StoneEntities = Logic.GetEntitiesOfType(Entities.R_StoneMine);
	local IronEntities = Logic.GetEntitiesOfType(Entities.R_IronMine);
	
	for i = 1, #StoneEntities do
		if Logic.GetTerritoryPlayerID(GetTerritoryUnderEntity(StoneEntities[i])) == 2 then
			Logic.SetResourceDoodadGoodAmount(StoneEntities[i], math.random(12000, 18000));
		else
			Logic.SetResourceDoodadGoodAmount(StoneEntities[i], math.random(145, 185));
		end
	end
	for i = 1, #IronEntities do
		if Logic.GetTerritoryPlayerID(GetTerritoryUnderEntity(IronEntities[i])) == 2 then
			Logic.SetResourceDoodadGoodAmount(IronEntities[i], math.random(18000, 25000));
		else
			Logic.SetResourceDoodadGoodAmount(IronEntities[i], math.random(185, 345));
		end
	end
end

InitializeTradeposts = function()
	local TradepostID = GetID("tradepost_03") -- Hafen
    Logic.TradePost_SetTradePartnerGenerateGoodsFlag(TradepostID, true)
    Logic.TradePost_SetTradePartnerPlayerID(TradepostID, 6)
    Logic.TradePost_SetTradeDefinition(TradepostID, 0, Goods.G_Wood, 8, Goods.G_Salt, 25)
	Logic.TradePost_SetTradeDefinition(TradepostID, 1, Goods.G_Grain, 8, Goods.G_Dye, 25)
	Logic.TradePost_SetTradeDefinition(TradepostID, 2, Goods.G_Carcass, 12, Goods.G_Cheese, 12)
	Logic.TradePost_SetTradeDefinition(TradepostID, 3, Goods.G_Grain, 12, Goods.G_Salt, 28)
	--Logic.TradePost_SetActiveTradeSlot(TradepostID, 0)	
	SetupInteractiveObject(TradepostID, 6, {Goods.G_Gold, 225, Goods.G_Dye, 8}, {Entities.U_GoldCart, Entities.U_ResourceMerchant})
	API.InteractiveObjectDeactivate("tradepost_03")
	
	TradepostID = GetID("tradepost_02") -- Kloster
	Logic.TradePost_SetTradePartnerGenerateGoodsFlag(TradepostID, true)
    Logic.TradePost_SetTradePartnerPlayerID(TradepostID, 7)
    Logic.TradePost_SetTradeDefinition(TradepostID, 0, Goods.G_Wood, 8, Goods.G_Gems, 25)
	Logic.TradePost_SetTradeDefinition(TradepostID, 1, Goods.G_Iron, 6, Goods.G_Dye, 25)
	Logic.TradePost_SetTradeDefinition(TradepostID, 2, Goods.G_Stone, 6, Goods.G_Salt, 25)
	Logic.TradePost_SetTradeDefinition(TradepostID, 3, Goods.G_Grain, 15, Goods.G_Soap, 12)
	--Logic.TradePost_SetActiveTradeSlot(TradepostID, 0)	
	SetupInteractiveObject(TradepostID, 6, {Goods.G_Gold, 225, Goods.G_Olibanum, 8}, {Entities.U_GoldCart, Entities.U_ResourceMerchant})
	API.InteractiveObjectDeactivate("tradepost_02")
	
	TradepostID = GetID("tradepost_01") -- Dorf
	Logic.TradePost_SetTradePartnerGenerateGoodsFlag(TradepostID, true)
    Logic.TradePost_SetTradePartnerPlayerID(TradepostID, 4)
    Logic.TradePost_SetTradeDefinition(TradepostID, 0, Goods.G_Milk, 8, Goods.G_Gems, 25)
	Logic.TradePost_SetTradeDefinition(TradepostID, 1, Goods.G_Wool, 6, Goods.G_Dye, 25)
	Logic.TradePost_SetTradeDefinition(TradepostID, 2, Goods.G_Herb, 6, Goods.G_MusicalInstrument, 25)
	Logic.TradePost_SetTradeDefinition(TradepostID, 3, Goods.G_Herb, 8, Goods.G_Olibanum, 25)
	--Logic.TradePost_SetActiveTradeSlot(TradepostID, 0)	
	SetupInteractiveObject(TradepostID, 6, {Goods.G_Gold, 225, Goods.G_MusicalInstrument, 8}, {Entities.U_GoldCart, Entities.U_ResourceMerchant})
	API.InteractiveObjectDeactivate("tradepost_01")
end

SetupInteractiveObject = function(_entityID, _time, _costs, _carts)
	Logic.InteractiveObjectClearCosts(_entityID)
	Logic.InteractiveObjectSetTimeToOpen(_entityID, _time)
	Logic.InteractiveObjectAddCosts(_entityID, _costs[1], _costs[2])
	Logic.InteractiveObjectAddCosts(_entityID, _costs[3], _costs[4])
	Logic.InteractiveObjectSetCostGoldCartType(_entityID, _carts[1])
	Logic.InteractiveObjectSetCostResourceCartType(_entityID, _carts[2])
	Logic.InteractiveObjectSetAvailability(_entityID, true);
end

GlobalBloodMoonActivated = true;
GlobalCallbackOverrides = function()
	if GameCallback_KnightTitleChanged_ORIG == nil then
		GameCallback_KnightTitleChanged_ORIG = GameCallback_KnightTitleChanged;
	end
	function GameCallback_KnightTitleChanged(_PlayerID, _NewTitle, _OldTitle)
		GameCallback_KnightTitleChanged_ORIG(_PlayerID, _NewTitle, _OldTitle)
		
		Logic.ExecuteInLuaLocalState([[
			local Index = ]].._NewTitle..[[;
			local Costs = {
				[KnightTitles.Mayor] = {Goods.G_Wood, 12},
				[KnightTitles.Baron] = {Goods.G_Cheese, 12},
				[KnightTitles.Earl] = {Goods.G_Broom, 12},
				[KnightTitles.Marquees] = {Goods.G_Beer, 12},
				[KnightTitles.Duke] = {Goods.G_Clothes, 8},
				[KnightTitles.Archduke] = {Goods.G_Gems, 8},
			};
			BCS.CurrentFestivalCosts = {Goods.G_Gold, 1.1,  Costs[Index][1], Costs[Index][2]};
			Game.GameTimeSetFactor(GUI.GetPlayerID(), 1);
		]]);
	end
	
	if GameCallback_EndOfMonth_ORIG == nil then
		GameCallback_EndOfMonth_ORIG = GameCallback_EndOfMonth;
	end
	function GameCallback_EndOfMonth(_LastMonth, _CurrentMonth)
		GameCallback_EndOfMonth_ORIG(_LastMonth, _CurrentMonth)
	
		if _CurrentMonth == 5 and not GlobalBloodMoonActivated then
			Logic.ExecuteInLuaLocalState([[
				Display.PlayEnvironmentSettingsSequence(Display.AddEnvironmentSettingsSequence("ME_Special_Sundawn.xml"), 180)
			]])
			ToggleGodrayVisibility(false);
		end
		if _CurrentMonth == 6 and not GlobalBloodMoonActivated then
			ToggleGodrayVisibility(true);
		end
		
		StartEnemyAIAttack();
	end
end

ToggleGodrayVisibility = function(_hide) -- We don't need sunshafts in the night
	local Godrays = Logic.GetEntitiesOfType(Entities.D_X_Godrays);
	for i = 1, #Godrays do
		Logic.SetVisible(Godrays[i], _hide);
	end
end

CheatGoodsForEnemyPlayer = function()
	GlobalCheatCounter = GlobalCheatCounter or 0
	GlobalCheatCounter = GlobalCheatCounter + 1
	
	if GlobalCheatCounter >= 30 then
		local Buildings = {}
		local PossibleEntityTypes = {Entities.B_Pharmacy, Entities.B_Butcher, Entities.B_Bakery, Entities.B_SmokeHouse, Entities.B_Dairy}
		for i = 1, #PossibleEntityTypes do
			Buildings = Array_Append(Buildings, {Logic.GetPlayerEntities(2, PossibleEntityTypes[i], 3, 0)})
		end

		for i = 1, #Buildings do
			local GoodType = Logic.GetGoodTypeOnOutStockByIndex(Buildings[i], 0)
			Logic.AddGoodToStock(Buildings[i], GoodType, Logic.GetMaxAmountOnStock(Buildings[i]))
		end
		
		GlobalCheatCounter = 0
	end
end

CurrentAliveArmyID = -1
GlobalAttacksActive = false
StartEnemyAIAttack = function()
	if not GlobalAttacksActive or not Logic.IsEntityAlive(Logic.GetStoreHouse(2)) then
		return;
	end

	if CurrentAliveArmyID ~= -1 then
		AICore.DisbandUnusedArmy(CurrentAliveArmyID)
	end
	
	local ArmyID, SpawnedTroops = AIScript_SpawnAndCreateArmy(2, Logic.GetStoreHouse(2), 3, 3, 1, 1, 1, 1, true, true)
	CurrentAliveArmyID = ArmyID;
	
	local WhatToAttack = math.random(1, 3)
	if WhatToAttack == 1 then
		AICore.StartAttackWithPlanDestroyHomebase(2, CurrentAliveArmyID, AIScriptHelper_GetEntityID(Logic.GetCathedral(1)))
	elseif WhatToAttack == 2 then
		local AreaID = AICore.CreateAD()
		AICore.AD_AddEntity(AreaID, Logic.GetCathedral(1), 1500)
		AICore.StartAttackWithPlanRaidSettlement(2, CurrentAliveArmyID, AreaID, 0)
	elseif WhatToAttack == 3 then
		local PlayerID = 1
		local Posts = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.Outpost)}
		if #Posts >= 1 then
			local SelectedOutPost = Posts[math.random(#Posts)]
			if (SelectedOutPost ~= nil and SelectedOutPost ~= 0) then
				AICore.StartAttackWithPlanDestroyOutpost(2, CurrentAliveArmyID, SelectedOutPost)
			end
		end
	end
end

OrderWallCatapultsForAI = function(_playerID)
	local Towers = {Logic.GetPlayerEntities(_playerID, Entities.B_WallTurret_NE, 32, 0)};
	Logic.AddGoodToStock(Logic.GetStoreHouse(_playerID), Goods.G_Iron, #Towers * 5)
	Logic.AddGoodToStock(Logic.GetHeadquarters(_playerID), Goods.G_Gold, #Towers * 200)
	for i = 1, #Towers do Logic.ExecuteInLuaLocalState('GUI.OrderDefenseWeapon('.._playerID..', '..Towers[i]..', 0, 406)') end
end
-- #EOF