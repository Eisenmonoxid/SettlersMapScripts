function SetMyBuildingCosts()
	LoadBuildingCostSystem()
	--Gatherer - Farms
	BCS.EditBuildingCosts(UpgradeCategories.CattleFarm, 85, Goods.G_SmokedFish, 6)
	BCS.EditBuildingCosts(UpgradeCategories.GrainFarm, 85, Goods.G_Sausage, 6)
	BCS.EditBuildingCosts(UpgradeCategories.SheepFarm, 85, Goods.G_Bread, 6)
	BCS.EditBuildingCosts(UpgradeCategories.Beekeeper, 85, Goods.G_Cheese, 6)
	--Gatherer - Normal
	BCS.EditBuildingCosts(UpgradeCategories.Woodcutter, 25, Goods.G_Sausage, 5)
	BCS.EditBuildingCosts(UpgradeCategories.HuntersHut, 35, Goods.G_Wood, 5)
	BCS.EditBuildingCosts(UpgradeCategories.FishingHut, 35, Goods.G_Wood, 5)
	BCS.EditBuildingCosts(UpgradeCategories.StoneQuarry, 25, Goods.G_SmokedFish, 5)
	BCS.EditBuildingCosts(UpgradeCategories.HerbGatherer, 45, Goods.G_RawFish, 8)
	BCS.EditBuildingCosts(UpgradeCategories.IronMine, 45, Goods.G_Medicine, 8)
	--CityBuildings - Food
	BCS.EditBuildingCosts(UpgradeCategories.Butcher, 50, Goods.G_Carcass, 8)
	BCS.EditBuildingCosts(UpgradeCategories.Bakery, 50, Goods.G_Grain, 8)
	BCS.EditBuildingCosts(UpgradeCategories.Dairy, 50, Goods.G_Milk, 8)
	BCS.EditBuildingCosts(UpgradeCategories.SmokeHouse, 50, Goods.G_RawFish, 8)
	--CityBuildings - Clothing
	BCS.EditBuildingCosts(UpgradeCategories.Weaver, 85, Goods.G_Stone, 8)
	BCS.EditBuildingCosts(UpgradeCategories.Tanner, 85, Goods.G_Stone, 8)
	--CityBuildings - Hygiene	
	BCS.EditBuildingCosts(UpgradeCategories.BroomMaker, 120, Goods.G_Clothes, 6)
	BCS.EditBuildingCosts(UpgradeCategories.Soapmaker, 120, Goods.G_Leather, 6)
	BCS.EditBuildingCosts(UpgradeCategories.Pharmacy, 100, Goods.G_Soap, 5)
	--CityBuildings - Entertainment
	BCS.EditBuildingCosts(UpgradeCategories.Tavern, 110, Goods.G_Broom, 8)
	BCS.EditBuildingCosts(UpgradeCategories.Theatre, 150, Goods.G_Soap, 8)
	BCS.EditBuildingCosts(UpgradeCategories.Baths, 110, Goods.G_Beer, 6)
	--CityBuildings - Decoration
	BCS.EditBuildingCosts(UpgradeCategories.Blacksmith, 150, Goods.G_Milk, 12)
	BCS.EditBuildingCosts(UpgradeCategories.CandleMaker, 150, Goods.G_Herb, 12)
	BCS.EditBuildingCosts(UpgradeCategories.Carpenter, 150, Goods.G_Wool, 12)
	BCS.EditBuildingCosts(UpgradeCategories.BannerMaker, 150, Goods.G_Honeycomb, 12)
	--Military
	BCS.EditBuildingCosts(UpgradeCategories.Barracks, 120, Goods.G_Bread, 6)
	BCS.EditBuildingCosts(UpgradeCategories.BarracksBow, 120, Goods.G_Bread, 6)
	BCS.EditBuildingCosts(UpgradeCategories.SwordSmith, 100, Goods.G_Sausage, 8)
	BCS.EditBuildingCosts(UpgradeCategories.BowMaker, 100, Goods.G_Sausage, 8)
	BCS.EditBuildingCosts(UpgradeCategories.SiegeEngineWorkshop, 350, Goods.G_Beer, 12)
	--Other
	BCS.EditBuildingCosts(UpgradeCategories.Cistern, 120, Goods.G_Stone, 8)
	--Fields
	BCS.EditBuildingCosts(GetUpgradeCategoryForClimatezone("GrainField"), 80, Goods.G_SmokedFish, 3)
	BCS.EditBuildingCosts(UpgradeCategories.CattlePasture, 80, Goods.G_Sausage, 5)
	BCS.EditBuildingCosts(UpgradeCategories.SheepPasture, 80, Goods.G_Honeycomb, 6)
	BCS.EditBuildingCosts(UpgradeCategories.BeeHive, 80, Goods.G_Herb, 5)
	--Palisade/Wall - Gates
	BCS.EditBuildingCosts(UpgradeCategories.PalisadeGate, 260, Goods.G_Herb, 8)
	BCS.EditBuildingCosts(GetUpgradeCategoryForClimatezone("WallGate"), 370, Goods.G_Grain, 8)
	--Buildings without fixed cost (Wall, Palisade, Road, Trail)
	--BCS.EditWallCosts(1.1, Goods.G_Beer, 1.1) --Wallcosts/Mauerkosten (!NO REFUND)
	--BCS.EditPalisadeCosts(1.1, Goods.G_Wood, 1.1) --Palisadecosts/Palisadenkosten (!NO REFUND)
	--BCS.EditRoadCosts(3.5, Goods.G_Stone, 1.2) --Roadcosts/Straßenkosten
	--BCS.EditTrailCosts(Goods.G_Sausage, 1.1) --Streetcosts/Wegkosten
	--Festival
	BCS.EditFestivalCosts(1.2, Goods.G_Cheese, 15) --Festivalcosts/Festkosten

	BCS.SetKnockDownFactor(0.0, 0.0)
	BCS.SetRefundCityGoods(false)
	BCS.SetCountGoodsOnMarketplace(true)
end
function LoadBuildingCostSystem()
	-- Initialize BCS --
	if BCS ~= nil then
		-- Init System
		BCS.InitializeBuildingCostSystem()
		-- Add Savegame when QSB is present
		if (API and QSB) then
			-- Register Savegame
			if API.AddSaveGameAction then -- QSB-S 2.x
				GUI.SendScriptCommand([[
					API.AddSaveGameAction(function()
						Logic.ExecuteInLuaLocalState('BCS.InitializeBuildingCostSystem()')
					end)
				]])
				Framework.WriteToLog("BCS: QSB-S 2.x found! AddSaveGameAction for Savegame registered!")
			elseif API.AddScriptEventListener and QSB.ScriptEvents ~= nil then -- QSB-S 3.x
				API.AddScriptEventListener(QSB.ScriptEvents.SaveGameLoaded, BCS.InitializeBuildingCostSystem)
				API.AddScriptEventListener(QSB.ScriptEvents.BriefingEnded, BCS.OverwriteEndScreenCallback)
				Framework.WriteToLog("BCS: QSB-S 3.x found! ScriptEventListener for Savegame and BriefingEnded registered!")
			else
				Framework.WriteToLog("BCS: QSB-S found, but no Savegame registered. Has to be done manually!")
			end
		else
			Framework.WriteToLog("BCS: QSB-S NOT found! Savegamehandling has to be done manually!")
		end
	else
		local ErrorMessage = "ERROR: Could not load BuildingCostSystem!"
		Framework.WriteToLog(ErrorMessage)
		assert(false, ErrorMessage)
		return;
	end
	-- Done --
end
--#EOF