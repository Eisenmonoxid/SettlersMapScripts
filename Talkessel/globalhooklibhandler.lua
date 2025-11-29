HookLibHandler = {}
HookLibHandler.Init = function()
	-- Loader
	local Result = EMXHookLibrary.Initialize(true)
	if Result ~= true then
		Game.LevelStop() -- Does this even do something?
		Framework.ExitGame()
		return;
	end
	
	HookLibHandler.SetupGlobalHookFuncs()
	HookLibHandler.SetupEntityCostsAndStocks()
	HookLibHandler.GlobalModifications()
	HookLibHandler.CreateGoodTypeRequirements()
	HookLibHandler.SetupColorSetHandling()
	HookLibHandler.ReplaceModelParams()
end
EMXHookLibrary_ResetValues = function(_source, _stringParam) Framework.ExitGame(); return true end;

HookLibHandler.SetupEntityCostsAndStocks = function()
	local EntityTypes = {Logic.GetEntityTypesInCategory(EntityCategories.OuterRimBuilding)};
	EntityTypes = Array_Append(EntityTypes, {Logic.GetEntityTypesInCategory(EntityCategories.CityBuilding)})

	for Key, Value in pairs(EntityTypes) do
		local Name = Logic.GetEntityTypeName(Value)
		if (Value ~= 0 and Value ~= nil)
		and (not string.find(Name, "NPC"))
		and (not string.find(Name, "Khana"))
		and (not string.find(Name, "Prince"))
		and (not string.find(Name, "Supplier"))
		then
			EMXHookLibrary.SetEntityTypeFullCost(Value, {Goods.G_Gold, 5})
			EMXHookLibrary.SetEntityTypeUpgradeCost(Value, 0, {Goods.G_Gold, math.random(35, 45)})	
			EMXHookLibrary.SetEntityTypeUpgradeCost(Value, 1, {Goods.G_Gold, math.random(45, 65)})
			
			EMXHookLibrary.SetEntityTypeOutStockCapacity(Value, 0, 8)
			EMXHookLibrary.SetEntityTypeOutStockCapacity(Value, 1, 16)
			EMXHookLibrary.SetEntityTypeOutStockCapacity(Value, 2, 20)

			EMXHookLibrary.SetEntityTypeSpouseProbabilityFactor(Value, 0.3)
		end
	end
	
	EMXHookLibrary.SetEntityTypeOutStockCapacity(Entities.B_NPC_Bakery_ME, 0, 12)
	EMXHookLibrary.SetEntityTypeSpouseProbabilityFactor(Entities.B_NPC_Bakery_ME, 0.3)
	
	EntityTypes = {Logic.GetEntityTypesInCategory(EntityCategories.AttackableBuilding)};
	for Key, Value in pairs(EntityTypes) do
		local Name = Logic.GetEntityTypeName(Value)
		if (Value ~= 0 and Value ~= nil) and (string.find(Name, "SpecialEdition") or string.find(Name, "Beautification")) then
			EMXHookLibrary.SetEntityTypeFullCost(Value, {Goods.G_Gold, math.random(120, 150), Goods.G_Stone, 0})
		end
	end

	EMXHookLibrary.SetEntityTypeFullCost(Entities.B_Outpost_NA, {Goods.G_Wood, 0})
	EMXHookLibrary.SetEntityTypeUpgradeCost(Entities.B_Outpost_NA, 0, {Goods.G_Gold, 550})
	
	for i = 0, 2, 1 do
		EMXHookLibrary.SetEntityTypeUpgradeCost(Entities.B_Castle_NA, i, {Goods.G_Gold, ((i + 1) * 200), Goods.G_Stone, 0})
		EMXHookLibrary.SetEntityTypeUpgradeCost(Entities.B_Cathedral, i, {Goods.G_Gold, ((i + 1) * 250), Goods.G_Stone, 0})
	end
	
	EMXHookLibrary.SetEntityTypeFullCost(Entities.B_PalisadeGate, {Goods.G_Gold, 150, Goods.G_Wood, 0})
	EMXHookLibrary.SetEntityTypeFullCost(Entities.B_WallGate_NA, {Goods.G_Gold, 250, Goods.G_Stone, 0})
	EMXHookLibrary.SetEntityTypeFullCost(Entities.B_PalisadeSegment, {Goods.G_Gold, 12})
	EMXHookLibrary.SetEntityTypeFullCost(Entities.B_WallSegment_NA, {Goods.G_Gold, 15})

	EMXHookLibrary.SetEntityTypeFullCost(Entities.B_Cistern, {Goods.G_Gold, 80})
	EMXHookLibrary.SetEntityTypeFullCost(Entities.B_TradePost, {Goods.G_Gold, 285, Goods.G_Wood, 0})
	
	EMXHookLibrary.SetEntityTypeFullCost(Entities.B_Beehive, {Goods.G_Gold, 50})
	EMXHookLibrary.SetEntityTypeFullCost(Entities.B_CattlePasture, {Goods.G_Gold, 50})
	EMXHookLibrary.SetEntityTypeFullCost(Entities.B_GrainField_NA, {Goods.G_Gold, 50})
	EMXHookLibrary.SetEntityTypeFullCost(Entities.B_SheepPasture, {Goods.G_Gold, 50})
	
	EMXHookLibrary.SetEntityTypeFullCost(Entities.U_MilitaryBallista, {Goods.G_Gold, 250, Goods.G_Iron, 0})
	EMXHookLibrary.SetEntityTypeFullCost(Entities.U_MilitaryTrap, {Goods.G_Gold, 250, Goods.G_Stone, 0})
end

HookLibHandler.GlobalModifications = function()
	local Offset = (EMXHookLibrary.IsHistoryEdition and 140) or 160 -- Road Cost
	EMXHookLibrary.Internal.GetLogicPropertiesEx()[Offset](0, Goods.G_Gold)(4, 12)
	--Offset = (EMXHookLibrary.IsHistoryEdition and 268) or 288 -- RepairAlarmGood
	--EMXHookLibrary.Internal.GetLogicPropertiesEx()(Offset, Goods.G_Gold)
	--Offset = (EMXHookLibrary.IsHistoryEdition and 276) or 296 -- RepairAlarmGoodProviderCategory
	--EMXHookLibrary.Internal.GetLogicPropertiesEx()(Offset, EntityCategories.Headquarters)
end

HookLibHandler.SetupGlobalHookFuncs = function()
	EMXHookLibrary.SetPlayerColorRGB(1, {127, 0, 0, 255, 255})
	EMXHookLibrary.SetPlayerColorRGB(2, {127, 253, 112, 0, 0})
	EMXHookLibrary.SetPlayerColorRGB(3, {127, 25, 56, 116})
	
	if Logic.GetMaxAmountOnStock(Logic.GetStoreHouse(1)) ~= 10 then
		EMXHookLibrary.SetMaxStorehouseStockSize(Logic.GetStoreHouse(1), 10)
	end

	if Network.GetDesiredLanguage() == "de" then
		EMXHookLibrary.EditStringTableText(4863, "Turm", true)
	elseif Network.GetDesiredLanguage() == "en" then
		EMXHookLibrary.EditStringTableText(5091, "Tower")
	end
	
	EMXHookLibrary.SetMaxBuildingTaxAmount(1000)
	EMXHookLibrary.SetBuildingKnockDownCompensation(0)
	EMXHookLibrary.EditFestivalProperties(175, 15, 15, 90)
	EMXHookLibrary.SetCathedralCollectAmount(12)
	EMXHookLibrary.SetAmountOfTaxCollectors(0)
	EMXHookLibrary.SetFogOfWarVisibilityFactor(0)
	EMXHookLibrary.SetKnightResurrectionTime(25000)
	EMXHookLibrary.SetWealthGoodDecayPerSecond(0.3)
	
	local SettlerLimits = {65, 65, 95, 185, 300, 300}
	local SermonSettlerLimits = {25, 45, 65, 90}
	local SoldierLimits = {36, 60, 91, 126}
	
	for i = 0, #SettlerLimits do
		EMXHookLibrary.SetSettlerLimit(i, SettlerLimits[i + 1])
	end
	for i = 0, #SermonSettlerLimits do
		EMXHookLibrary.SetSermonSettlerLimit(Entities.B_Cathedral, i, SermonSettlerLimits[i + 1]) 
	end
	for i = 0, #SoldierLimits do
		EMXHookLibrary.SetSoldierLimit(Entities.B_Castle_NA, i, SoldierLimits[i + 1])	
	end

	local GoodsInCategory = {Logic.GetGoodTypesInGoodCategory(GoodCategories.GC_Resource)};
	local StorehouseID = Logic.GetStoreHouse(1)
	for i = 1, #GoodsInCategory do
		if (GoodsInCategory[i] ~= Goods.G_Salt and GoodsInCategory[i] ~= Goods.G_Dye) and Logic.GetIndexOnOutStockByGoodType(StorehouseID, GoodsInCategory[i]) ~= -1 then
			Logic.AddGoodToStock(StorehouseID, GoodsInCategory[i], 1);
		end
    end
end

HookLibHandler.SetupColorSetHandling = function()
	EMXHookLibrary.SetEntityDisplayProperties(Entities.R_NA_Tree_Arcacia02, "SeasonColorSet", 17)
	EMXHookLibrary.SetEntityDisplayProperties(Entities.R_NA_Tree_Arcacia01, "SeasonColorSet", 17)
end

HookLibHandler.InitializeColorSetEntries = function()
	EMXHookLibrary.SetColorSetColorRGB(86, 1, {10/255, 10/255, 35/255, 1})
	EMXHookLibrary.SetColorSetColorRGB(86, 2, {12/255, 89/255, 138/255, 1})
	EMXHookLibrary.SetColorSetColorRGB(86, 3, {10/255, 25/255, 50/255, 1})
	EMXHookLibrary.SetColorSetColorRGB(86, 4, {20/255, 98/255, 12/255, 1})
	
	for i = 1, 4 do	
		EMXHookLibrary.SetColorSetColorRGB(2, i, {0.7, 0.3, 0.2, 1});
		EMXHookLibrary.SetColorSetColorRGB(17, i, {210/255, 105/255, 165/255, 1});
	end	
	
	Logic.DestroyEntity(GetID("tree01"))
	Logic.DestroyEntity(GetID("tree02"))
end

HookLibHandler.ReplaceModelParams = function()
	EMXHookLibrary.SetEntityDisplayModelParameters(Entities.B_NPC_Bakery_ME, nil, nil, {Models.Buildings_B_Outpost_2})
	EMXHookLibrary.ReplaceUpgradeCategoryEntityType(UpgradeCategories.Dummy_00, Entities.B_NPC_Bakery_ME)
	
	local ReferenceModel = Models.Doodads_D_NE_Cliff_Set03_Sheet02;
	local WealthModel = Models.Buildings_B_WallGateTurret_ME;
	local ShipMovementModel = Models.Doodads_D_X_ChestOpenEmpty;
	
	local Models = {Models.Doodads_D_SE_PortalTomb02, Models.Doodads_D_ME_PortalTomb01, Models.Doodads_D_ME_Grave01, Models.Doodads_D_X_Grave01, Models.Doodads_D_X_Grave03}
	for i = 1, #Models do
		EMXHookLibrary.ModifyModelPropertiesByReferenceType(Models[i], ReferenceModel, 0, true)
	end

	EMXHookLibrary.SetAndReloadModelSpecificShader(WealthModel, "WealthLightObject")
	EMXHookLibrary.SetAndReloadModelSpecificShader(ShipMovementModel, "ShipMovementEx")
	
	for i = 1, 6 do
		Logic.SetModel("ghosttower0" .. i, WealthModel);
	end
end

HookLibHandler.GoodRequiredResourcesMapping = { -- Reference to table in local state by function!
	-- Food
	[Goods.G_SmokedFish] = {{Goods.G_RawFish, 3, EntityCategories.GathererBuilding}, {Goods.G_Wood, 2, EntityCategories.GathererBuilding}},
	[Goods.G_Sausage] = {{Goods.G_Carcass, 3, EntityCategories.GathererBuilding}, {Goods.G_Wood, 2, EntityCategories.GathererBuilding}},
	[Goods.G_Cheese] = {{Goods.G_Milk, 3, EntityCategories.FarmerBuilding}, {Goods.G_Wood, 2, EntityCategories.GathererBuilding}},
	[Goods.G_Bread] = {{Goods.G_Grain, 3, EntityCategories.FarmerBuilding}, {Goods.G_Wood, 2, EntityCategories.GathererBuilding}},
	-- Clothes
	[Goods.G_Clothes] = {{Goods.G_Wool, 3, EntityCategories.FarmerBuilding}, {Goods.G_Carcass, 2, EntityCategories.GathererBuilding}},
	[Goods.G_Leather] = {{Goods.G_Carcass, 3, EntityCategories.GathererBuilding}, {Goods.G_Regalia, 2, EntityCategories.GC_Food_Supplier}},
	-- Hygiene
	[Goods.G_Broom] = {{Goods.G_Wood, 3, EntityCategories.GathererBuilding}, {Goods.G_Iron, 2, EntityCategories.GathererBuilding}},
	[Goods.G_Soap] = {{Goods.G_Carcass, 3, EntityCategories.GathererBuilding}, {Goods.G_Wood, 2, EntityCategories.GathererBuilding}},
	[Goods.G_Medicine] = {{Goods.G_Herb, 3, EntityCategories.GathererBuilding}, {Goods.G_Honeycomb, 2, EntityCategories.FarmerBuilding}},
	-- Entertainment
	[Goods.G_Beer] = {{Goods.G_Honeycomb, 3, EntityCategories.FarmerBuilding}, {Goods.G_Herb, 2, EntityCategories.GathererBuilding}},
	[Goods.G_EntBaths] = {{Goods.G_Water, 3, EntityCategories.G_Water_Supplier}, {Goods.G_Soap, 2, EntityCategories.CityBuilding}}, -- Water not in Gatherer
	[Goods.G_EntTheatre] = {{Goods.G_Wool, 3, EntityCategories.FarmerBuilding}, {Goods.G_Wood, 2, EntityCategories.GathererBuilding}}, -- Does not work?
	-- Military
	[Goods.G_PoorSword] = {{Goods.G_Iron, 3, EntityCategories.GathererBuilding}, {Goods.G_Wood, 2, EntityCategories.GathererBuilding}},
	[Goods.G_PoorBow] = {{Goods.G_Iron, 3, EntityCategories.GathererBuilding}, {Goods.G_Wood, 2, EntityCategories.GathererBuilding}}, 
	[Goods.G_SiegeEnginePart] = {{Goods.G_PoorSword, 3, EntityCategories.CityBuilding}, {Goods.G_PoorBow, 3, EntityCategories.CityBuilding}},
	-- Decoration
	[Goods.G_Banner] = {{Goods.G_Wool, 3, EntityCategories.FarmerBuilding}, {Goods.G_SmokedFish, 2, EntityCategories.CityBuilding}},
	[Goods.G_Candle] = {{Goods.G_Honeycomb, 3, EntityCategories.FarmerBuilding}, {Goods.G_Sausage, 2, EntityCategories.CityBuilding}},
	[Goods.G_Ornament] = {{Goods.G_Wood, 3, EntityCategories.GathererBuilding}, {Goods.G_Cheese, 2, EntityCategories.CityBuilding}},
	[Goods.G_Sign] = {{Goods.G_Iron, 3, EntityCategories.GathererBuilding}, {Goods.G_Bread, 2, EntityCategories.CityBuilding}},
	-- Special
	[Goods.G_Regalia] = {{Goods.G_Wood, 2, EntityCategories.GathererBuilding}, {Goods.G_Carcass, 2, EntityCategories.GathererBuilding}},
};
GlobalGoodRequiredResourcesMapping = HookLibHandler.GoodRequiredResourcesMapping; -- To reference table in local state

HookLibHandler.CreateGoodTypeRequirements = function()
	local Create = EMXHookLibrary.CreateGoodTypeRequiredResources;
	for Key, Value in pairs(HookLibHandler.GoodRequiredResourcesMapping) do
		Create(Key, Value)
	end
end

HookLibHandler.GameCallback_SettlerSpawned_ORIG = GameCallback_SettlerSpawned;
GameCallback_SettlerSpawned = function(_PlayerID, _EntityID)
	HookLibHandler.GameCallback_SettlerSpawned_ORIG(_PlayerID, _EntityID)	
	
	if _PlayerID == 1 and Logic.IsEntityInCategory(_EntityID, EntityCategories.Worker) == 1 then
		API.StartHiResJob(function(_settlerID) -- Execute next tick, otherwise WorkplaceID is 0
			Framework.WriteToLog("Job " .. _EntityID .. " started!")
			local WorkplaceID = Logic.GetSettlersWorkBuilding(_settlerID)
			if WorkplaceID ~= 0 and WorkplaceID ~= nil then
				if Logic.GetEntityType(WorkplaceID) == Entities.B_NPC_Bakery_ME then
					EMXHookLibrary.SetBuildingTypeOutStockGood(WorkplaceID, Goods.G_Regalia, true)
				end
			
				local Good = Logic.GetGoodTypeOnOutStockByIndex(WorkplaceID, 0)
				local InStock01 = Logic.GetGoodTypeOnInStockByIndex(WorkplaceID, 0)
				local InStock02 = Logic.GetGoodTypeOnInStockByIndex(WorkplaceID, 1)
				local GoodEntry = HookLibHandler.GoodRequiredResourcesMapping[Good] 
				if GoodEntry ~= nil and (InStock01 ~= GoodEntry[1][1] or InStock02 ~= GoodEntry[2][1]) then
					Logic.AddGoodToStock(WorkplaceID, GoodEntry[2][1], 0, true, true, true)
					EMXHookLibrary.SetBuildingInStockGood(WorkplaceID, GoodEntry[1][1])
				end
				
				Framework.WriteToLog("Job " .. _EntityID .. " finished! -> OutStock: " .. tostring(Good) .. ", InStock01: " .. tostring(InStock01) .. ", InStock02: " .. tostring(InStock02))
				return true;
			end
		end, _EntityID);
	end
end

HookLibHandler.ConsumeGoodORIG = GameCallback_ConsumeGood;
GameCallback_ConsumeGood = function(_Consumer, _Good, _Building)
	HookLibHandler.ConsumeGoodORIG(_Consumer, _Good, _Building)
	
	local Earnings = Logic.GetBuildingProductEarnings(_Building);
	if Earnings ~= nil then
		Logic.SetBuildingEarnings(_Building, Earnings + 25);
	end
end
-- #EOF