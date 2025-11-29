HookLibHandler = HookLibHandler or {}
HookLibHandler.Mappings = HookLibHandler.Mappings or {}

HookLibHandler.Mappings.StoreHouseLimits = {890, 1730, 2980, 4385};
HookLibHandler.Mappings.SettlerLimits = {50, 50, 125, 185, 300, 300};
HookLibHandler.Mappings.SermonSettlerLimits = {25, 45, 65, 120};
HookLibHandler.Mappings.SoldierLimits = {36, 60, 91, 126};
HookLibHandler.Mappings.OutStockLimits = {8, 16, 20};
HookLibHandler.Mappings.BarracksOutStockLimits = {12, 18, 30};

HookLibHandler.Mappings.EntityTypeBuildingCostsMapping = {
	-- Food
	[Entities.B_SmokeHouse] = {Goods.G_Wood, 4, Goods.G_RawFish, 3},
	[Entities.B_Bakery] = {Goods.G_Wood, 4, Goods.G_Grain, 3},
	[Entities.B_Butcher] = {Goods.G_Wood, 4, Goods.G_Carcass, 3},
	[Entities.B_Dairy] = {Goods.G_Wood, 4, Goods.G_Milk, 3},
	-- Clothes
	[Entities.B_Tanner] = {Goods.G_Wood, 4, Goods.G_Carcass, 3},
	[Entities.B_Weaver] = {Goods.G_Wood, 4, Goods.G_Wool, 3},
	-- Hygiene
	[Entities.B_BroomMaker] = {Goods.G_Wood, 5, Goods.G_Iron, 4},
	[Entities.B_Soapmaker] = {Goods.G_Wood, 5, Goods.G_Carcass, 4},
	[Entities.B_Pharmacy] = {Goods.G_Wood, 5, Goods.G_Herb, 4},
	-- Entertainment
	[Entities.B_Tavern] = {Goods.G_Wood, 6, Goods.G_Honeycomb, 8},
	[Entities.B_Baths] = {Goods.G_Wood, 6, Goods.G_Olibanum, 5},
	[Entities.B_Theatre] = {Goods.G_Wood, 12, Goods.G_MusicalInstrument, 12},
	-- Military
	[Entities.B_SwordSmith] = {Goods.G_Wood, 8, Goods.G_Stone, 5},
	[Entities.B_BowMaker] = {Goods.G_Wood, 8, Goods.G_Stone, 5},
	[Entities.B_Barracks] = {Goods.G_Wood, 12, Goods.G_Iron, 8},
	[Entities.B_BarracksArchers] = {Goods.G_Wood, 12, Goods.G_Iron, 8},
	[Entities.B_SiegeEngineWorkshop] = {Goods.G_Stone, 12, Goods.G_Iron, 8},
	-- Decoration
	[Entities.B_BannerMaker] = {Goods.G_Wood, 12, Goods.G_Wool, 6},
	[Entities.B_CandleMaker] = {Goods.G_Wood, 12, Goods.G_Honeycomb, 6},
	[Entities.B_Carpenter] = {Goods.G_Wood, 12, Goods.G_Stone, 6},
	[Entities.B_Blacksmith] = {Goods.G_Wood, 12, Goods.G_Iron, 6},
	-- Walls & Special
	[Entities.B_PalisadeGate] = {Goods.G_Gold, 65, Goods.G_Wood, 12},
	[Entities.B_WallGate_ME] = {Goods.G_Gold, 150, Goods.G_Stone, 20},
	[Entities.B_Cistern] = {Goods.G_Gold, 125, Goods.G_Stone, 12},
	-- Farms
	[Entities.B_Beehive] = {Goods.G_Gold, 15, Goods.G_Herb, 5},
	[Entities.B_CattlePasture] = {Goods.G_Gold, 25, Goods.G_Grain, 5},
	[Entities.B_GrainField_ME] = {Goods.G_Gold, 20, Goods.G_Wood, 4},
	[Entities.B_SheepPasture] = {Goods.G_Gold, 25, Goods.G_Grain, 5},
	-- Units
	[Entities.U_Thief] = {Goods.G_Gold, 230, Goods.G_Gems, 12},
	[Entities.U_AmmunitionCart] = {Goods.G_Gold, 150, Goods.G_Stone, 10},
};

HookLibHandler.Mappings.GoodRequiredResourcesMapping = {
	-- Food
	[Goods.G_SmokedFish] = {{Goods.G_RawFish, 2, EntityCategories.Storehouse}, {Goods.G_Salt, 1, EntityCategories.Storehouse}},
	[Goods.G_Sausage] = {{Goods.G_Carcass, 2, EntityCategories.Storehouse}, {Goods.G_Salt, 1, EntityCategories.Storehouse}},
	[Goods.G_Cheese] = {{Goods.G_Milk, 2, EntityCategories.Storehouse}, {Goods.G_Wood, 1, EntityCategories.Storehouse}},
	[Goods.G_Bread] = {{Goods.G_Grain, 2, EntityCategories.Storehouse}, {Goods.G_Water, 1, EntityCategories.G_Water_Supplier}},
	-- Clothes
	[Goods.G_Clothes] = {{Goods.G_Wool, 1, EntityCategories.Storehouse}, {Goods.G_Dye, 1, EntityCategories.Storehouse}},
	[Goods.G_Leather] = {{Goods.G_Carcass, 1, EntityCategories.Storehouse}, {Goods.G_Dye, 1, EntityCategories.Storehouse}},
	-- Hygiene
	[Goods.G_Broom] = {{Goods.G_Wood, 2, EntityCategories.Storehouse}, {Goods.G_Iron, 1, EntityCategories.Storehouse}},
	[Goods.G_Soap] = {{Goods.G_Carcass, 1, EntityCategories.Storehouse}, {Goods.G_Milk, 1, EntityCategories.Storehouse}},
	[Goods.G_Medicine] = {{Goods.G_Herb, 2, EntityCategories.Storehouse}, {Goods.G_Honeycomb, 1, EntityCategories.Storehouse}},
	-- Entertainment
	[Goods.G_Beer] = {{Goods.G_Honeycomb, 2, EntityCategories.Storehouse}, {Goods.G_Herb, 2, EntityCategories.Storehouse}},
	[Goods.G_EntBaths] = {{Goods.G_Water, 2, EntityCategories.G_Water_Supplier}, {Goods.G_Soap, 1, EntityCategories.GC_Hygiene_Supplier}},
	[Goods.G_PlayMaterial] = {{Goods.G_Wool, 2, EntityCategories.Storehouse}, {Goods.G_Wood, 2, EntityCategories.Storehouse}},
	-- Military
	[Goods.G_PoorSword] = {{Goods.G_Iron, 2, EntityCategories.Storehouse}, {Goods.G_Wood, 1, EntityCategories.Storehouse}},
	[Goods.G_PoorBow] = {{Goods.G_Iron, 2, EntityCategories.Storehouse}, {Goods.G_Wood, 1, EntityCategories.Storehouse}}, 
	[Goods.G_SiegeEnginePart] = {{Goods.G_PoorSword, 1, EntityCategories.CityBuilding}, {Goods.G_PoorBow, 1, EntityCategories.CityBuilding}},
	-- Decoration
	[Goods.G_Banner] = {{Goods.G_Wool, 1, EntityCategories.Storehouse}, {Goods.G_Dye, 1, EntityCategories.Storehouse}},
	[Goods.G_Candle] = {{Goods.G_Honeycomb, 1, EntityCategories.Storehouse}, {Goods.G_Olibanum, 1, EntityCategories.Storehouse}},
	[Goods.G_Ornament] = {{Goods.G_Iron, 2, EntityCategories.Storehouse}, {Goods.G_Wood, 1, EntityCategories.Storehouse}},
	[Goods.G_Sign] = {{Goods.G_Wood, 1, EntityCategories.Storehouse}, {Goods.G_MusicalInstrument, 1, EntityCategories.Storehouse}},
};
-- #EOF