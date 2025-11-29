HookLibHandler = HookLibHandler or {}
HookLibHandler.CameFromSavegame = false;
HookLibHandler.Initialize = function(_cameFromSavegame)
	-- Loader
	local Result = EMXHookLibrary.Initialize(true, 2000);
	if Result ~= true then
		Game.LevelStop() -- Does this even do something?
		Framework.ExitGame()
		return;
	end
	
	HookLibHandler.CameFromSavegame = _cameFromSavegame;
	HookLibHandler.SetupMainHookValues();
	HookLibHandler.SetupEntityCostsAndStocks();
	HookLibHandler.CreateGoodTypeRequirements();
	HookLibHandler.SetupColorSetEntities();
	HookLibHandler.ReplaceModelParams();
end
EMXHookLibrary_ResetValues = function(_source, _stringParam) Framework.ExitGame(); return true end;

HookLibHandler.SetupMainHookValues = function()
	EMXHookLibrary.SetPlayerColorRGB(1, {127, 0, 0, 255, 255})
	EMXHookLibrary.SetPlayerColorRGB(2, {127, 34, 155, 0, 0})
	EMXHookLibrary.SetPlayerColorRGB(4, {127, 125, 56, 116})
	EMXHookLibrary.SetPlayerColorRGB(5, {127, 25, 156, 116})
	EMXHookLibrary.SetPlayerColorRGB(6, {127, 25, 56, 116})
	EMXHookLibrary.SetPlayerColorRGB(7, {127, 25, 156, 16})
	EMXHookLibrary.SetPlayerColorRGB(8, {127, 125, 156, 134})
	
	EMXHookLibrary.SetMaxBuildingTaxAmount(250)
	EMXHookLibrary.SetBuildingKnockDownCompensation(50)
	EMXHookLibrary.EditFestivalProperties(90, 15, 15, 35)
	EMXHookLibrary.SetCathedralCollectAmount(15)
	EMXHookLibrary.SetAmountOfTaxCollectors(8)
	EMXHookLibrary.SetFogOfWarVisibilityFactor(1)
	EMXHookLibrary.SetKnightResurrectionTime(25000)
	EMXHookLibrary.SetSettlerIllnessCount(125)

	for i = 0, #HookLibHandler.Mappings.SettlerLimits do
		EMXHookLibrary.SetSettlerLimit(i, HookLibHandler.Mappings.SettlerLimits[i + 1])
	end
	for i = 0, #HookLibHandler.Mappings.SermonSettlerLimits do
		EMXHookLibrary.SetSermonSettlerLimit(Entities.B_Cathedral, i, HookLibHandler.Mappings.SermonSettlerLimits[i + 1]) 
	end
	for i = 0, #HookLibHandler.Mappings.SoldierLimits do
		EMXHookLibrary.SetSoldierLimit(Entities.B_Castle_ME, i, HookLibHandler.Mappings.SoldierLimits[i + 1])	
	end
	
	EMXHookLibrary.SetTerritoryGoldCostByIndex(1, 85);
end

HookLibHandler.SetupEntityCostsAndStocks = function()
	for i = 0, (#HookLibHandler.Mappings.StoreHouseLimits - 1), 1 do
		EMXHookLibrary.SetEntityTypeOutStockCapacity(Entities.B_StoreHouse, i, HookLibHandler.Mappings.StoreHouseLimits[i + 1]);
	end
	if (not HookLibHandler.CameFromSavegame) and (Logic.GetMaxAmountOnStock(Logic.GetStoreHouse(1)) ~= HookLibHandler.Mappings.StoreHouseLimits[1]) then -- Better check Upgradelevel?
		EMXHookLibrary.SetMaxStorehouseStockSize(Logic.GetStoreHouse(1), HookLibHandler.Mappings.StoreHouseLimits[1]);
	end
	
	for Key, Value in pairs(HookLibHandler.Mappings.EntityTypeBuildingCostsMapping) do
		EMXHookLibrary.SetEntityTypeFullCost(Key, Value, true);
		
		if Logic.IsEntityTypeInCategory(Key, EntityCategories.CityBuilding) == 1 then
			EMXHookLibrary.SetEntityTypeUpgradeCost(Key, 0, {Goods.G_Gold, math.random(35, 45), Goods.G_Wood, 6}, true, true);
			EMXHookLibrary.SetEntityTypeUpgradeCost(Key, 1, {Goods.G_Gold, math.random(45, 55), Goods.G_Stone, 8}, true, true);

			EMXHookLibrary.SetEntityTypeOutStockCapacity(Key, 0, HookLibHandler.Mappings.OutStockLimits[1])
			EMXHookLibrary.SetEntityTypeOutStockCapacity(Key, 1, HookLibHandler.Mappings.OutStockLimits[2])
			EMXHookLibrary.SetEntityTypeOutStockCapacity(Key, 2, HookLibHandler.Mappings.OutStockLimits[3])

			EMXHookLibrary.SetEntityTypeSpouseProbabilityFactor(Key, 0.3)
		end
	end
	
	if (not HookLibHandler.CameFromSavegame) then
		local ID = {Logic.GetPlayerEntities(1, Entities.B_Bakery, 1, 0)};
		if ID[2] ~= nil then
			EMXHookLibrary.SetMaxBuildingStockSize(ID[2], HookLibHandler.Mappings.OutStockLimits[1]);
		end
		Logic.DestroyEntity(GetID("ModelTesting"));
	end

	local EntityTypes = {Logic.GetEntityTypesInCategory(EntityCategories.OuterRimBuilding)};
	for Key, Value in pairs(EntityTypes) do
		local Name = Logic.GetEntityTypeName(Value);
		if (Value ~= 0 and Value ~= nil) and (not string.find(Name, "Supplier")) then
			EMXHookLibrary.SetEntityTypeFullCost(Value, {Goods.G_Wood, 5});
			EMXHookLibrary.SetEntityTypeUpgradeCost(Value, 0, {Goods.G_Gold, math.random(15, 25), Goods.G_Wood, 4}, true, true);
			EMXHookLibrary.SetEntityTypeUpgradeCost(Value, 1, {Goods.G_Gold, math.random(25, 35), Goods.G_Stone, 4}, true, true);
			
			EMXHookLibrary.SetEntityTypeOutStockCapacity(Value, 0, HookLibHandler.Mappings.OutStockLimits[1])
			EMXHookLibrary.SetEntityTypeOutStockCapacity(Value, 1, HookLibHandler.Mappings.OutStockLimits[2])
			EMXHookLibrary.SetEntityTypeOutStockCapacity(Value, 2, HookLibHandler.Mappings.OutStockLimits[3])

			EMXHookLibrary.SetEntityTypeSpouseProbabilityFactor(Value, 0.3)
		end
	end
	
	EMXHookLibrary.SetEntityTypeFullCost(Entities.B_Outpost_ME, {Goods.G_Stone, 20});
	EMXHookLibrary.SetEntityTypeUpgradeCost(Entities.B_Outpost_ME, 0, {Goods.G_Wood, 10, Goods.G_Stone, 10});
	
	for i = 0, 2, 1 do
		--EMXHookLibrary.SetEntityTypeUpgradeCost(Entities.B_Castle_ME, i, {Goods.G_Gold, ((i + 1) * 250), Goods.G_Stone, ((i + 1) * 25)}) -- Crash
		--EMXHookLibrary.SetEntityTypeUpgradeCost(Entities.B_Cathedral, i, {Goods.G_Gold, ((i + 1) * 200), Goods.G_Stone, ((i + 1) * 20)}) -- Crash
		EMXHookLibrary.SetEntityTypeUpgradeCost(Entities.B_StoreHouse, i, {Goods.G_Wood, ((i + 1) * 20), Goods.G_Stone, ((i + 1) * 20)})
	end

	for i = 0, #HookLibHandler.Mappings.BarracksOutStockLimits - 1, 1 do
		EMXHookLibrary.SetEntityTypeOutStockCapacity(Entities.B_Barracks, i, HookLibHandler.Mappings.BarracksOutStockLimits[i + 1]);
		EMXHookLibrary.SetEntityTypeOutStockCapacity(Entities.B_BarracksArchers, i, HookLibHandler.Mappings.BarracksOutStockLimits[i + 1]);
	end
end

HookLibHandler.SetupColorSetEntities = function()
	local ColorSetEntryIndex = EMXHookLibrary.Internal.GetColorSetEntryIndexByName("SE_Set_Grass01")
	EMXHookLibrary.SetEntityDisplayProperties(Entities.R_ME_Tree_Broadleaf_Yellow01, "SeasonColorSet", ColorSetEntryIndex); -- purple trees
end

HookLibHandler.InitializeColorSetEntries = function() -- Has to be done after forced camera update on entity to force game to load ColorSet
	EMXHookLibrary.SetColorSetColorRGB("ME_FOW", 1, {0.32, 0.135, 0.4, 1}); -- FoW color
	EMXHookLibrary.SetColorSetColorRGB("ME_FOW", 2, {0.265, 0.1, 0.3, 1}); -- FoW color
	EMXHookLibrary.SetColorSetColorRGB("ME_FOW", 3, {0.375, 0.28, 0.4, 1}); -- FoW color
	EMXHookLibrary.SetColorSetColorRGB("ME_FOW", 4, {0.68, 0.645, 0.39, 1}); -- FoW color
	
	EMXHookLibrary.SetColorSetColorRGB("SE_Set_Grass01", 1, {210/255, 105/255, 165/255, 1}); -- purple trees
	EMXHookLibrary.SetColorSetColorRGB("SE_Set_Grass01", 2, {210/255, 105/255, 165/255, 1}); -- purple trees
	EMXHookLibrary.SetColorSetColorRGB("SE_Set_Grass01", 3, {210/255, 105/255, 165/255, 1}); -- purple trees
	EMXHookLibrary.SetColorSetColorRGB("SE_Set_Grass01", 4, {220/255, 180/255, 180/255, 1}); -- white trees
end

HookLibHandler.ReplaceModelParams = function()
	local WealthModel = Models.Doodads_D_X_Godrays;
	EMXHookLibrary.SetAndReloadModelSpecificShader(WealthModel, "WealthLightObject")
	EMXHookLibrary.SetEntityDisplayModelParameters(Entities.B_NPC_Tent_Information, nil, nil, {Models.Buildings_B_Castle_NE_04})	
	-- "portrait" Shader -> Works for HEAD_Models
	if HookLibHandler.MovingObjectID ~= 0 then
		local CEntity = Entities.D_X_Dragonboat02;
		local TowerModel = Models.Buildings_B_Outpost_2;
	
		EMXHookLibrary.SetEntityDisplayModelParameters(CEntity, nil, nil, {TowerModel});
		EMXHookLibrary.SetAndReloadModelSpecificShader(TowerModel, "Waterfall");
		EMXHookLibrary.AddBehaviorToEntityType(CEntity, "CInteractiveObjectBehavior"); 
	end
end

HookLibHandler.CreateGoodTypeRequirements = function()
	for Key, Value in pairs(HookLibHandler.Mappings.GoodRequiredResourcesMapping) do
		EMXHookLibrary.CreateGoodTypeRequiredResources(Key, Value);
	end
end

HookLibHandler.GameCallback_SettlerSpawned_ORIG = GameCallback_SettlerSpawned;
GameCallback_SettlerSpawned = function(_PlayerID, _EntityID)
	HookLibHandler.GameCallback_SettlerSpawned_ORIG(_PlayerID, _EntityID)	
	
	if _PlayerID == 1 and Logic.IsEntityInCategory(_EntityID, EntityCategories.Worker) == 1 then
		API.StartHiResJob(function(_settlerID) -- Execute next tick, otherwise WorkplaceID is 0
			local WorkplaceID = Logic.GetSettlersWorkBuilding(_settlerID)
			if WorkplaceID ~= 0 and WorkplaceID ~= nil then
				local Good = Logic.GetGoodTypeOnOutStockByIndex(WorkplaceID, 0)
				local InStock01 = Logic.GetGoodTypeOnInStockByIndex(WorkplaceID, 0)
				local InStock02 = Logic.GetGoodTypeOnInStockByIndex(WorkplaceID, 1)
				local GoodEntry = HookLibHandler.Mappings.GoodRequiredResourcesMapping[Good] 
				if GoodEntry ~= nil and (InStock01 ~= GoodEntry[1][1] or InStock02 ~= GoodEntry[2][1]) then
					Logic.AddGoodToStock(WorkplaceID, GoodEntry[2][1], 0, true, true, true)
					EMXHookLibrary.SetBuildingInStockGood(WorkplaceID, GoodEntry[1][1])
				end

				return true;
			end
		end, _EntityID);
	end
end

HookLibHandler.MovingObjectID = 0;
HookLibHandler.CreateMovingObject = function()
	local CEntity = Entities.D_X_Dragonboat02;
	local TowerModel = Models.Buildings_B_Outpost_2;
	
	EMXHookLibrary.SetEntityDisplayModelParameters(CEntity, nil, nil, {TowerModel});
	EMXHookLibrary.SetAndReloadModelSpecificShader(TowerModel, "Waterfall");
	EMXHookLibrary.AddBehaviorToEntityType(CEntity, "CInteractiveObjectBehavior"); 
	
	local posX, posY = Logic.EntityGetPos(Logic.GetKnightID(1));
	local ID = Logic.CreateEntity(CEntity, posX, posY, 0, 1);
	HookLibHandler.MovingObjectID = ID;
	Logic.SetSpeedFactor(ID, 1.6);
	
	Logic.InteractiveObjectClearCosts(ID);
	Logic.InteractiveObjectSetInteractionDistance(ID, 1000);
	Logic.InteractiveObjectSetTimeToOpen(ID, 1);
	Logic.SetEntityInvulnerabilityFlag(ID, true);
	
	HookLibHandler.OverrideCallback();
	StartSimpleHiResJobEx(HookLibHandler.ObjectFollowKnight, ID)
end

HookLibHandler.OverrideCallback = function()
	if HookLibHandler.OnObjectInteraction == nil then
		HookLibHandler.OnObjectInteraction = GameCallback_OnObjectInteraction;
	end
	GameCallback_OnObjectInteraction = function(_EntityID, _PlayerID)
		HookLibHandler.OnObjectInteraction(_EntityID, _PlayerID);
        if _EntityID ~= 0 and _EntityID == HookLibHandler.MovingObjectID then
			HookLibHandler.ObjectFollowing = true;
			API.InteractiveObjectDeactivate(_EntityID);
		end
	end
end

HookLibHandler.JobRunning = true;
HookLibHandler.ToggleObjectFollowing = function()
	HookLibHandler.ObjectFollowing = not HookLibHandler.ObjectFollowing;
	API.InteractiveObjectDeactivate(HookLibHandler.MovingObjectID);
	HookLibHandler.JobRunning = false;
end

HookLibHandler.ObjectFollowing = false;
HookLibHandler.ObjectFollowKnight = function(_objectID)
	HookLibHandler.ObjectFollowTimer = HookLibHandler.ObjectFollowTimer or 0
	HookLibHandler.ObjectFollowTimer = HookLibHandler.ObjectFollowTimer + 1
	
	-- Every 500 ms should be enough -> not wasting performance!
	if HookLibHandler.ObjectFollowTimer >= 5 and HookLibHandler.ObjectFollowing then
		-- Is Knight in Castle?
		local KnightID = Logic.GetKnightID(1);
		if Logic.KnightGetResurrectionProgress(KnightID) ~= 1 then
			HookLibHandler.ObjectFollowing = false;
			API.InteractiveObjectActivate(_objectID);
			local posX, posY = Logic.EntityGetPos(_objectID);
			Logic.MoveEntity(_objectID, posX, posY);
		else
			local posX, posY = Logic.EntityGetPos(KnightID);
			Logic.MoveEntity(_objectID, posX, posY);
			HookLibHandler.CheckForWallsInRange(_objectID);
		end
	
		HookLibHandler.ObjectFollowTimer = 0
	end
	
	if not HookLibHandler.JobRunning then
		return true;
	end
end

HookLibHandler.CheckForWallsInRange = function(_objectID)
	local Walls = {Logic.GetPlayerEntitiesInCategory(2, EntityCategories.Wall)};
	for i = 1, #Walls do
		if IsNear(Walls[i], _objectID, 2000) then
			Logic.HurtEntity(Walls[i], 5000);
		end
	end
end
-- #EOF