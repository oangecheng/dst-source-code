PrefabFiles = 
{
    "make_placer",
}

Assets = 
{
    Asset("ATLAS", "images/inventoryimages/rare_blueprint.xml"),
    Asset("IMAGE", "images/inventoryimages/rare_blueprint.tex"),
	Asset("ATLAS", "images/inventoryimages/mandrake_planted.xml"),
    Asset("IMAGE", "images/inventoryimages/mandrake_planted.tex"),
    Asset("ATLAS", "images/inventoryimages/catcoonden.xml"),
    Asset("IMAGE", "images/inventoryimages/catcoonden.tex"),
	Asset("ATLAS", "images/inventoryimages/walrus_camp.xml"),
    Asset("IMAGE", "images/inventoryimages/walrus_camp.tex"),
	Asset("ATLAS", "images/inventoryimages/ancient_altar.xml"),
    Asset("IMAGE", "images/inventoryimages/ancient_altar.tex"),
	Asset("ATLAS", "images/inventoryimages/ancient_altar_broken.xml"),
    Asset("IMAGE", "images/inventoryimages/ancient_altar_broken.tex"),
	Asset("ATLAS", "images/inventoryimages/pond.xml"),
    Asset("IMAGE", "images/inventoryimages/pond.tex"),
	Asset("ATLAS", "images/inventoryimages/pond_mos.xml"),
    Asset("IMAGE", "images/inventoryimages/pond_mos.tex"),
	Asset("ATLAS", "images/inventoryimages/lava_pond.xml"),
    Asset("IMAGE", "images/inventoryimages/lava_pond.tex"),
	Asset("ATLAS", "images/inventoryimages/pond_cave.xml"),
    Asset("IMAGE", "images/inventoryimages/pond_cave.tex"),
	Asset("ATLAS", "images/inventoryimages/mermhouse.xml"),
    Asset("IMAGE", "images/inventoryimages/mermhouse.tex"),
	Asset("ATLAS", "images/inventoryimages/resurrectionstone.xml"),
    Asset("IMAGE", "images/inventoryimages/resurrectionstone.tex"),
	Asset("ATLAS", "images/inventoryimages/beehive.xml"),
    Asset("IMAGE", "images/inventoryimages/beehive.tex"),
	Asset("ATLAS", "images/inventoryimages/wasphive.xml"),
    Asset("IMAGE", "images/inventoryimages/wasphive.tex"),
	Asset("ATLAS", "images/inventoryimages/spiderhole.xml"),
    Asset("IMAGE", "images/inventoryimages/spiderhole.tex"),
	Asset("ATLAS", "images/inventoryimages/slurtlehole.xml"),
    Asset("IMAGE", "images/inventoryimages/slurtlehole.tex"),
	Asset("ATLAS", "images/inventoryimages/batcave.xml"),
    Asset("IMAGE", "images/inventoryimages/batcave.tex"),
	Asset("ATLAS", "images/inventoryimages/monkeybarrel.xml"),
    Asset("IMAGE", "images/inventoryimages/monkeybarrel.tex"),
	Asset("ATLAS", "images/inventoryimages/tallbirdnest.xml"),
    Asset("IMAGE", "images/inventoryimages/tallbirdnest.tex"),
	Asset("ATLAS", "images/inventoryimages/houndmound.xml"),
    Asset("IMAGE", "images/inventoryimages/houndmound.tex"),
	Asset("ATLAS", "images/inventoryimages/cave_banana_tree.xml"),
    Asset("IMAGE", "images/inventoryimages/cave_banana_tree.tex"),
	Asset("ATLAS", "images/inventoryimages/statueglommer.xml"),
    Asset("IMAGE", "images/inventoryimages/statueglommer.tex"),
	Asset("ATLAS", "images/inventoryimages/babybeefalo.xml"),
    Asset("IMAGE", "images/inventoryimages/babybeefalo.tex"),
	Asset("ATLAS", "images/inventoryimages/cave_entrance_open.xml"),
    Asset("IMAGE", "images/inventoryimages/cave_entrance_open.tex"),
	Asset("ATLAS", "images/inventoryimages/cave_exit.xml"),
    Asset("IMAGE", "images/inventoryimages/cave_exit.tex"),
	Asset("ATLAS", "images/inventoryimages/wormlight_plant.xml"),
    Asset("IMAGE", "images/inventoryimages/wormlight_plant.tex"),
	Asset("ATLAS", "images/inventoryimages/flower_cave.xml"),
    Asset("IMAGE", "images/inventoryimages/flower_cave.tex"),
	Asset("ATLAS", "images/inventoryimages/flower_cave_double.xml"),
    Asset("IMAGE", "images/inventoryimages/flower_cave_double.tex"),
	Asset("ATLAS", "images/inventoryimages/flower_cave_triple.xml"),
    Asset("IMAGE", "images/inventoryimages/flower_cave_triple.tex"),
	Asset("ATLAS", "images/inventoryimages/cactus.xml"),
    Asset("IMAGE", "images/inventoryimages/cactus.tex"),
	Asset("ATLAS", "images/inventoryimages/oasis_cactus.xml"),
    Asset("IMAGE", "images/inventoryimages/oasis_cactus.tex"),
	Asset("ATLAS", "images/inventoryimages/reeds.xml"),
    Asset("IMAGE", "images/inventoryimages/reeds.tex"),
	Asset("ATLAS", "images/inventoryimages/klaus_sack.xml"),
    Asset("IMAGE", "images/inventoryimages/klaus_sack.tex"),
	Asset("ATLAS", "images/inventoryimages/sacred_chest.xml"),
    Asset("IMAGE", "images/inventoryimages/sacred_chest.tex"),
	Asset("ATLAS", "images/inventoryimages/sketch.xml"),
    Asset("IMAGE", "images/inventoryimages/sketch.tex"),
	Asset("ATLAS", "images/inventoryimages/rabbithole.xml"),
    Asset("IMAGE", "images/inventoryimages/rabbithole.tex"),
	Asset("ATLAS", "images/inventoryimages/pigtorch.xml"),
    Asset("IMAGE", "images/inventoryimages/pigtorch.tex"),
	Asset("ATLAS", "images/inventoryimages/oasislake.xml"),
    Asset("IMAGE", "images/inventoryimages/oasislake.tex"),
}

local STRINGS = GLOBAL.STRINGS
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local Recipe = GLOBAL.Recipe
local TECH = GLOBAL.TECH

local Ccave = GetModConfigData("cave")
local Cchestereyebone = GetModConfigData("chestereyebone")
local Chutchfishbowl = GetModConfigData("hutchfishbowl")
local Cbutter = GetModConfigData("butter")
local Cbeardhair = GetModConfigData("beardhair")
local Clureplantbulb = GetModConfigData("lureplantbulb")
local Cspidereggsack = GetModConfigData("spidereggsack")
local Cspiderhat = GetModConfigData("spiderhat")
local Cgem = GetModConfigData("gem")
local Cwalrushat = GetModConfigData("walrushat")
local Ckrampussack = GetModConfigData("krampussack")
local Cgears = GetModConfigData("gears")
local Csteelwool = GetModConfigData("steelwool")
local Cmoonrocknugget = GetModConfigData("moonrocknugget")
local Cthulecitepieces = GetModConfigData("thulecitepieces")
local Cminotaurhorn = GetModConfigData("minotaurhorn")
local Carmorsnurtleshell = GetModConfigData("armorsnurtleshell")
local Cslurtlehat = GetModConfigData("slurtlehat")
local Cwormlight = GetModConfigData("wormlight")
local Cgoosefeather = GetModConfigData("goosefeather")
local Cfurtuft = GetModConfigData("furtuft")
local Cdragonscales = GetModConfigData("dragonscales")
local Cdeerclopseyeball = GetModConfigData("deerclopseyeball")
local Cblueprint = GetModConfigData("blueprint")
local Clivinglog = GetModConfigData("livinglog")
local Cmandrakesoup = GetModConfigData("mandrakesoup")
local Cpetalsevil = GetModConfigData("petalsevil")
local Cmarble = GetModConfigData("marble")
local Crareblueprint = GetModConfigData("rareblueprint")
local Cshroomskin = GetModConfigData("shroomskin")
local Chivehat = GetModConfigData("hivehat")
local Croyaljelly = GetModConfigData("royaljelly")
local Chumanmeat = GetModConfigData("humanmeat")
local Copalstaff = GetModConfigData("opalstaff")
local Copalpreciousgem = GetModConfigData("opalpreciousgem")
local Cshadowheart = GetModConfigData("shadowheart")
local Cantlers = GetModConfigData("antlers")
local Clavaeegg = GetModConfigData("lavaeegg")
local Cmanrabbittail = GetModConfigData("manrabbittail")
local Cfossilpiece = GetModConfigData("fossilpiece")
local Catriumkey = GetModConfigData("atriumkey")
local Cthurible = GetModConfigData("thurible")
local Cskeletonhat = GetModConfigData("skeletonhat")
local Carmorskeleton = GetModConfigData("armorskeleton")
local Csketch = GetModConfigData("sketch")
local Choneycomb = GetModConfigData("honeycomb")
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local Cmandrake = GetModConfigData("mandrake")
local Ccatcoonden = GetModConfigData("catcoonden")
local Cwalruscamp = GetModConfigData("walruscamp")
local Cancientaltar = GetModConfigData("ancientaltar")
local Cpond = GetModConfigData("pond")
local Cmermhouse = GetModConfigData("mermhouse")
local Cresurrectionstone = GetModConfigData("resurrectionstone")
local Cbeehive = GetModConfigData("beehive")
local Cwasphive = GetModConfigData("wasphive")
local Cspiderhole = GetModConfigData("spiderhole")
local Cslurtlehole = GetModConfigData("slurtlehole")
local Cbatcave = GetModConfigData("batcave")
local Cmonkeybarrel = GetModConfigData("monkeybarrel")
local Ctallbirdnest = GetModConfigData("tallbirdnest")
local Choundmound = GetModConfigData("houndmound")
local Ccavebananatree = GetModConfigData("cavebananatree")
local Cstatueglommer = GetModConfigData("statueglommer")
local Cbabybeefalo = GetModConfigData("babybeefalo")
local Csinkholesandstairs = GetModConfigData("sinkholesandstairs")
local Cwormlightplant = GetModConfigData("wormlightplant")
local Cflowercave = GetModConfigData("flowercave")
local Ccactus = GetModConfigData("cactus")
local Coasiscactus = GetModConfigData("oasiscactus")
local Creeds = GetModConfigData("reeds")
local Cklaussack = GetModConfigData("klaussack")
local Csacredchest = GetModConfigData("sacredchest")
local Crabbithole = GetModConfigData("rabbithole")
local Cpigtorch = GetModConfigData("pigtorch")
local Coasislake = GetModConfigData("oasislake")

if Ccave == "no" then

if Cchestereyebone ~= "disabled" then
    STRINGS.RECIPE_DESC.CHESTER_EYEBONE = "Summons chester."
	if Cchestereyebone == "enabled" then
		AddRecipe("chester_eyebone", { Ingredient("monstermeat", 4), Ingredient("houndstooth", 2)}, RECIPETABS.SURVIVAL,  TECH.SCIENCE_ONE) --切斯特眼骨
	end
end
if Chutchfishbowl ~= "disabled" then
    STRINGS.RECIPE_DESC.HUTCH_FISHBOWL = "Summons hutch."
	if Chutchfishbowl == "enabled" then
		AddRecipe("hutch_fishbowl", { Ingredient("pondfish", 4), Ingredient("ice", 8)}, RECIPETABS.SURVIVAL,  TECH.SCIENCE_ONE) --星-空
	end
end
if Cbutter ~= "disabled" then
    STRINGS.RECIPE_DESC.BUTTER = "butter."
	if Cbutter == "enabled" then
		AddRecipe("butter", { Ingredient("butterflywings", 2), Ingredient("petals", 2), Ingredient("honey", 1)}, RECIPETABS.FARM,  TECH.SCIENCE_TWO) --黄油
	end
end
if Cbeardhair ~= "disabled" then
    STRINGS.RECIPE_DESC.BEARDHAIR = "What's the use?"
	if Cbeardhair == "enabled" then
		AddRecipe("beardhair", { Ingredient("nightmarefuel", 1), Ingredient("ash", 1)}, RECIPETABS.SURVIVAL,  TECH.MAGIC_TWO) --胡须
	end
end
if Clureplantbulb ~= "disabled" then
    STRINGS.RECIPE_DESC.LUREPLANTBULB = "Good place for waste disposal."
	if Clureplantbulb == "enabled" then
		AddRecipe("lureplantbulb", { Ingredient("meat", 2), Ingredient("monstermeat", 4)}, RECIPETABS.SURVIVAL,  TECH.SCIENCE_TWO) --多肉的球茎
	end
end
if Cspidereggsack ~= "disabled" then
	if Cspidereggsack == "enabled" then
		AddRecipe("spidereggsack", { Ingredient("silk", 8), Ingredient("spidergland", 5), Ingredient("papyrus", 4)}, RECIPETABS.SURVIVAL,  TECH.SCIENCE_TWO) --蜘蛛卵
	end
end
if Cspiderhat ~= "disabled" then
	if Cspiderhat == "enabled" then
		AddRecipe("spiderhat", { Ingredient("spidereggsack", 1), Ingredient("tophat", 1), Ingredient("spidergland", 3)}, RECIPETABS.DRESS,  TECH.MAGIC_TWO) --蜘蛛帽
	end
end
if Cgem ~= "disabled" then
    STRINGS.RECIPE_DESC.REDGEM = "Colored stone."
	STRINGS.RECIPE_DESC.BLUEGEM = "Colored stone."
	STRINGS.RECIPE_DESC.GREENGEM = "Colored stone."
	STRINGS.RECIPE_DESC.ORANGEGEM = "Colored stone."
	STRINGS.RECIPE_DESC.YELLOWGEM = "Colored stone."
	if Cgem == "enabled" then
		AddRecipe("redgem", { Ingredient("goldnugget", 2), Ingredient("feather_robin", 1), Ingredient("nightmarefuel", 2)}, RECIPETABS.REFINE,  TECH.MAGIC_TWO) --红宝石
		AddRecipe("bluegem", { Ingredient("goldnugget", 2), Ingredient("feather_robin_winter", 1), Ingredient("nightmarefuel", 2)}, RECIPETABS.REFINE,  TECH.MAGIC_TWO) --蓝宝石
		AddRecipe("greengem", { Ingredient("cactus_meat", 2), Ingredient("froglegs", 2), Ingredient("nightmarefuel", 2)}, RECIPETABS.REFINE,  TECH.MAGIC_TWO) --绿宝石
		AddRecipe("orangegem", { Ingredient("transistor", 1), Ingredient("pumpkin", 1), Ingredient("nightmarefuel", 2)}, RECIPETABS.REFINE,  TECH.MAGIC_TWO) --橙宝石
		AddRecipe("yellowgem", { Ingredient("transistor", 1), Ingredient("honey", 2), Ingredient("nightmarefuel", 2)}, RECIPETABS.REFINE,  TECH.MAGIC_TWO) --黄宝石
	end
end
if Cwalrushat ~= "disabled" then
    STRINGS.RECIPE_DESC.WALRUSHAT = "Nice hat."
	if Cwalrushat == "enabled" then
		AddRecipe("walrushat", { Ingredient("flowerhat", 1), Ingredient("walrus_tusk", 2), Ingredient("beefalowool", 4)}, RECIPETABS.DRESS,  TECH.MAGIC_TWO) --贝雷帽
	end
end
if Ckrampussack ~= "disabled" then
    STRINGS.RECIPE_DESC.KRAMPUS_SACK = "A big backpack."
	if Ckrampussack == "enabled" then
		AddRecipe("krampus_sack", { Ingredient("bearger_fur", 1), Ingredient("gears", 3), Ingredient("pigskin", 4)}, RECIPETABS.SURVIVAL,  TECH.MAGIC_THREE) --坎普斯背包
	end
end
if Cgears ~= "disabled" then
    STRINGS.RECIPE_DESC.GEARS = "Very practical stuff."
	if Cgears == "enabled" then
		AddRecipe("gears", { Ingredient("cutstone", 4), Ingredient("goldnugget", 4), Ingredient("transistor", 2)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_ONE) --齿轮
	end
end
if Csteelwool ~= "disabled" then
    STRINGS.RECIPE_DESC.STEELWOOL = "Disgusting animal.\nrarely seen."
	if Csteelwool == "enabled" then
		AddRecipe("steelwool", { Ingredient("trunk_summer", 1), Ingredient("trunk_winter", 1), Ingredient("goose_feather", 1)}, RECIPETABS.REFINE,  TECH.MAGIC_THREE) --钢丝绒
	end
end
if Cmoonrocknugget ~= "disabled" then
    STRINGS.RECIPE_DESC.MOONROCKNUGGET = "Stone from the sky."
	if Cmoonrocknugget == "enabled" then
		AddRecipe("moonrocknugget", { Ingredient("transistor", 1), Ingredient("livinglog", 1), Ingredient("rocks", 4)}, RECIPETABS.REFINE,  TECH.MAGIC_TWO) --月之石
	end
end
if Cthulecitepieces ~= "disabled" then
    STRINGS.RECIPE_DESC.THULECITE_PIECES = "Use it to build more technology."
	if Cthulecitepieces == "enabled" then
		AddRecipe("thulecite_pieces", { Ingredient("transistor", 1), Ingredient("nightmarefuel", 1)}, RECIPETABS.REFINE,  TECH.MAGIC_THREE) --铥矿石碎片
	end
end
if Cminotaurhorn ~= "disabled" then
    STRINGS.RECIPE_DESC.MINOTAURHORN = "Seemingly useless."
	if Cminotaurhorn == "enabled" then
		AddRecipe("minotaurhorn", { Ingredient("dragon_scales", 1), Ingredient("lightninggoathorn", 1), Ingredient("horn", 1)}, RECIPETABS.REFINE,  TECH.MAGIC_THREE) --守卫者的角
	end
end
if Carmorsnurtleshell ~= "disabled" then
    STRINGS.RECIPE_DESC.ARMORSNURTLESHELL = "Feeling very strange."
	if Carmorsnurtleshell == "enabled" then
		AddRecipe("armorsnurtleshell", { Ingredient("phlegm", 1), Ingredient("armormarble", 1)}, RECIPETABS.WAR,  TECH.MAGIC_TWO) --黏糊虫壳甲
	end
end
if Cslurtlehat ~= "disabled" then
    STRINGS.RECIPE_DESC.SLURTLEHAT = "Cool."
	if Cslurtlehat == "enabled" then
		AddRecipe("slurtlehat", { Ingredient("tentaclespots", 1), Ingredient("footballhat", 1)}, RECIPETABS.WAR,  TECH.MAGIC_TWO) --贝壳头盔
	end
end
if Cwormlight ~= "disabled" then
    STRINGS.RECIPE_DESC.WORMLIGHT = "Light."
	if Cwormlight == "enabled" then
		AddRecipe("wormlight", { Ingredient("fireflies", 2), Ingredient("plantmeat", 3), Ingredient("berries", 4)}, RECIPETABS.REFINE,  TECH.MAGIC_TWO) --发光浆果
	end
end
if Cgoosefeather ~= "disabled" then
    STRINGS.RECIPE_DESC.GOOSE_FEATHER = "Soft feathers."
	if Cgoosefeather == "enabled" then
		AddRecipe("goose_feather", { Ingredient("feather_robin", 1), Ingredient("feather_robin_winter", 1), Ingredient("feather_crow", 1)}, RECIPETABS.REFINE,  TECH.MAGIC_THREE) --掉落的羽毛
	end
end
if Cfurtuft ~= "disabled" then
    STRINGS.RECIPE_DESC.FURTUFT = "furtuft*30."
	if Cfurtuft == "enabled" then
		AddRecipe("furtuft", { Ingredient("goose_feather", 8), Ingredient("beefalowool", 12), Ingredient("coontail", 1)}, RECIPETABS.REFINE,  TECH.MAGIC_THREE,nil,nil,nil,30) --毛簇
	end
end
if Cdragonscales ~= "disabled" then
    STRINGS.RECIPE_DESC.DRAGON_SCALES = "Look hard."
	if Cdragonscales == "enabled" then
		AddRecipe("dragon_scales", { Ingredient("goose_feather", 12), Ingredient("bearger_fur", 3), Ingredient("deerclops_eyeball", 1)}, RECIPETABS.REFINE,  TECH.MAGIC_THREE) --鳞片
	end
end
if Cdeerclopseyeball ~= "disabled" then
    STRINGS.RECIPE_DESC.DEERCLOPS_EYEBALL = "A part of an organism."
	if Cdeerclopseyeball == "enabled" then
		AddRecipe("deerclops_eyeball", { Ingredient("steelwool", 1), Ingredient("mole", 2), Ingredient("tallbirdegg", 1)}, RECIPETABS.REFINE,  TECH.MAGIC_THREE) --巨鹿眼球
	end
end
if Cblueprint ~= "disabled" then
    STRINGS.RECIPE_DESC.BLUEPRINT = "Random."
	if Cblueprint == "enabled" then
		AddRecipe("blueprint", { Ingredient("orangegem", 1), Ingredient("yellowgem", 1), Ingredient("purplegem", 1)}, RECIPETABS.SCIENCE,  TECH.NONE) --蓝图
	end
end
if Clivinglog ~= "disabled" then
    STRINGS.RECIPE_DESC.LIVINGLOG = "Live wood."
	if Clivinglog == "enabled" then
		AddRecipe("livinglog", { Ingredient("log", 8), Ingredient("nightmarefuel", 3)}, RECIPETABS.REFINE,  TECH.MAGIC_TWO) --活木
	end
end
if Cmandrakesoup ~= "disabled" then
    STRINGS.RECIPE_DESC.MANDRAKESOUP = "Delicious ah."
	if Cmandrakesoup == "enabled" then
		AddRecipe("mandrakesoup", { Ingredient("bonestew", 1), Ingredient("carrot", 3), Ingredient("waffles", 1)}, RECIPETABS.FARM,  TECH.SCIENCE_TWO) --曼德拉草汤
	end
end
if Cpetalsevil ~= "disabled" then
    STRINGS.RECIPE_DESC.PETALS_EVIL = "Province of mischief."
	if Cpetalsevil == "enabled" then
		AddRecipe("petals_evil", { Ingredient("petals", 1)}, RECIPETABS.REFINE,  TECH.SCIENCE_TWO) --恶魔花瓣
	end
end
if Cmarble ~= "disabled" then
    STRINGS.RECIPE_DESC.MARBLE = "Hard stone."
	if Cmarble == "enabled" then
		AddRecipe("marble", { Ingredient("flint", 3), Ingredient("rocks", 1)}, RECIPETABS.REFINE,  TECH.SCIENCE_TWO) --大理石
	end
end
if Crareblueprint ~= "disabled" then
    GLOBAL.STRINGS.NAMES.RED_MUSHROOMHAT_BLUEPRINT = "Red Funcap Blueprint"
	GLOBAL.STRINGS.NAMES.GREEN_MUSHROOMHAT_BLUEPRINT = "Green Funcap Blueprint"
	GLOBAL.STRINGS.NAMES.BLUE_MUSHROOMHAT_BLUEPRINT = "Blue Funcap Blueprint"
	GLOBAL.STRINGS.NAMES.MUSHROOM_LIGHT_BLUEPRINT = "Mushlight Blueprint"
	GLOBAL.STRINGS.NAMES.MUSHROOM_LIGHT2_BLUEPRINT = "Glowcap Blueprint"
	GLOBAL.STRINGS.NAMES.DRAGONFLYFURNACE_BLUEPRINT = "Scaled Furnace Blueprint"
	GLOBAL.STRINGS.NAMES.SLEEPBOMB_BLUEPRINT = "Napsack Blueprint"
	GLOBAL.STRINGS.NAMES.TOWNPORTAL_BLUEPRINT = "The Lazy Deserter Blueprint"
	GLOBAL.STRINGS.NAMES.BUNDLEWRAP_BLUEPRINT = "Bundling Wrap Blueprint"
	GLOBAL.STRINGS.NAMES.ENDTABLE_BLUEPRINT = "End Table Blueprint"
	GLOBAL.STRINGS.NAMES.SUCCULENT_POTTED_BLUEPRINT = "Potted Succulent Blueprint"
	GLOBAL.STRINGS.NAMES.GOGGLESHAT_BLUEPRINT = "Fashion Goggles Blueprint"
	GLOBAL.STRINGS.NAMES.DESERTHAT_BLUEPRINT = "Desert Goggles Blueprint"
    STRINGS.RECIPE_DESC.RED_MUSHROOMHAT_BLUEPRINT = "Knowledge."
	STRINGS.RECIPE_DESC.GREEN_MUSHROOMHAT_BLUEPRINT = "Knowledge."
	STRINGS.RECIPE_DESC.BLUE_MUSHROOMHAT_BLUEPRINT = "Knowledge."
	STRINGS.RECIPE_DESC.MUSHROOM_LIGHT_BLUEPRINT = "Knowledge."
	STRINGS.RECIPE_DESC.MUSHROOM_LIGHT2_BLUEPRINT = "Knowledge."
	STRINGS.RECIPE_DESC.DRAGONFLYFURNACE_BLUEPRINT = "Knowledge."
	STRINGS.RECIPE_DESC.SLEEPBOMB_BLUEPRINT = "Knowledge."
	STRINGS.RECIPE_DESC.TOWNPORTAL_BLUEPRINT = "Knowledge."
	STRINGS.RECIPE_DESC.BUNDLEWRAP_BLUEPRINT = "Knowledge."
	STRINGS.RECIPE_DESC.ENDTABLE_BLUEPRINT = "Knowledge."
	STRINGS.RECIPE_DESC.SUCCULENT_POTTED_BLUEPRINT = "Knowledge."
	STRINGS.RECIPE_DESC.GOGGLESHAT_BLUEPRINT = "Knowledge."
	STRINGS.RECIPE_DESC.DESERTHAT_BLUEPRINT = "Knowledge."
	if Crareblueprint == "enabled" then
		AddRecipe("red_mushroomhat_blueprint", { Ingredient("blueprint", 1), Ingredient("red_cap", 4), Ingredient("fireflies", 4)}, RECIPETABS.SCIENCE,  TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --红菇帽蓝图
		AddRecipe("green_mushroomhat_blueprint", { Ingredient("blueprint", 1), Ingredient("green_cap", 4), Ingredient("fireflies", 4)}, RECIPETABS.SCIENCE,  TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --绿菇帽蓝图
		AddRecipe("blue_mushroomhat_blueprint", { Ingredient("blueprint", 1), Ingredient("blue_cap", 4), Ingredient("fireflies", 4)}, RECIPETABS.SCIENCE,  TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --蓝菇帽蓝图
		AddRecipe("mushroom_light_blueprint", { Ingredient("blueprint", 1), Ingredient("bearger_fur", 1), Ingredient("fireflies", 8)}, RECIPETABS.SCIENCE,  TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --荧菇灯蓝图
		AddRecipe("mushroom_light2_blueprint", { Ingredient("blueprint", 1), Ingredient("bearger_fur", 1), Ingredient("fireflies", 8)}, RECIPETABS.SCIENCE,  TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --炽菇灯蓝图
		AddRecipe("dragonflyfurnace_blueprint", { Ingredient("blueprint", 1), Ingredient("dragon_scales", 1), Ingredient("charcoal", 12)}, RECIPETABS.SCIENCE,  TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --龙蝇火炉蓝图
		AddRecipe("sleepbomb_blueprint", { Ingredient("blueprint", 1), Ingredient("dragon_scales", 1), Ingredient("canary", 1), Ingredient("mandrake", 2)}, RECIPETABS.SCIENCE,  TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --Napsack蓝图
		AddRecipe("townportal_blueprint", { Ingredient("blueprint", 1), Ingredient("townportaltalisman", 6), Ingredient("heatrock", 1)}, RECIPETABS.SCIENCE,  TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --怠惰的逃亡者蓝图
		AddRecipe("bundlewrap_blueprint", { Ingredient("blueprint", 1), Ingredient("waxpaper", 1), Ingredient("rope", 2)}, RECIPETABS.SCIENCE,  TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --空包裹蓝图
		AddRecipe("endtable_blueprint", { Ingredient("blueprint", 1), Ingredient("petals", 4), Ingredient("hammer", 2)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --茶几蓝图
		AddRecipe("succulent_potted_blueprint", { Ingredient("blueprint", 1), Ingredient("wetpouch", 1)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --盆栽蓝图
		AddRecipe("goggleshat_blueprint", { Ingredient("blueprint", 1), Ingredient("wetpouch", 1)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --时尚眼镜蓝图
		AddRecipe("deserthat_blueprint", { Ingredient("blueprint", 1), Ingredient("wetpouch", 1)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --风镜蓝图
	end
end
if Cshroomskin ~= "disabled" then
    STRINGS.RECIPE_DESC.SHROOM_SKIN = "The skin of a creature."
	if Cshroomskin == "enabled" then
		AddRecipe("shroom_skin", { Ingredient("green_cap", 2), Ingredient("greengem", 1), Ingredient("feather_canary", 1)}, RECIPETABS.REFINE,  TECH.MAGIC_THREE) --蕈蟾酥
	end
end
if Chivehat ~= "disabled" then
    STRINGS.RECIPE_DESC.HIVEHAT = "The throne."
	if Chivehat == "enabled" then
		AddRecipe("hivehat", { Ingredient("spiderhat", 1), Ingredient("honeycomb", 1), Ingredient("horn", 2)}, RECIPETABS.WAR,  TECH.MAGIC_THREE) --蜂王冠
	end
end
if Croyaljelly ~= "disabled" then
    STRINGS.RECIPE_DESC.ROYAL_JELLY = "Looks sweet."
	if Croyaljelly == "enabled" then
		AddRecipe("royal_jelly", { Ingredient("butter", 2), Ingredient("honey", 4), Ingredient("ice", 8)}, RECIPETABS.FARM,  TECH.MAGIC_TWO) --蜂王浆
	end
end
if Chumanmeat ~= "disabled" then
    STRINGS.RECIPE_DESC.HUMANMEAT = "Horrible."
	if Chumanmeat == "enabled" then
		AddRecipe("humanmeat", { Ingredient("meat", 1), Ingredient("smallmeat", 2)}, RECIPETABS.FARM,  TECH.SCIENCE_TWO) --人肉
	end
end
if Copalstaff ~= "disabled" then
    STRINGS.RECIPE_DESC.OPALSTAFF = "It makes me cool."
	if Copalstaff == "enabled" then
		AddRecipe("opalstaff", { Ingredient("nightmarefuel", 4), Ingredient("livinglog", 2), Ingredient("opalpreciousgem", 1)}, RECIPETABS.MAGIC,  TECH.MAGIC_THREE) --呼月之杖
	end
end
if Copalpreciousgem ~= "disabled" then
    STRINGS.RECIPE_DESC.OPALPRECIOUSGEM = "Beautiful gem."
	if Copalpreciousgem == "enabled" then
		AddRecipe("opalpreciousgem", { Ingredient("moonrocknugget", 4), Ingredient("yellowgem", 2), Ingredient("glommerflower", 1)}, RECIPETABS.MAGIC,  TECH.MAGIC_THREE) --彩色宝石
	end
end
if Cshadowheart ~= "disabled" then
    STRINGS.RECIPE_DESC.SHADOWHEART = "Black heart."
	if Cshadowheart == "enabled" then
		AddRecipe("shadowheart", { Ingredient("nightmarefuel", 40), Ingredient("decrease_sanity", 50)}, RECIPETABS.REFINE,  TECH.MAGIC_THREE) --暗影之心
	end
end
if Cantlers ~= "disabled" then
    GLOBAL.STRINGS.NAMES.DEER_ANTLER1 = "Deer Antler"
	GLOBAL.STRINGS.NAMES.DEER_ANTLER2 = "Deer Antler"
	GLOBAL.STRINGS.NAMES.DEER_ANTLER3 = "Deer Antler"
    STRINGS.RECIPE_DESC.DEER_ANTLER1 = "Antlers."
	STRINGS.RECIPE_DESC.DEER_ANTLER2 = "Antlers."
	STRINGS.RECIPE_DESC.DEER_ANTLER3 = "Antlers."
	STRINGS.RECIPE_DESC.KLAUSSACKKEY = "The key to the treasure."
	if Cantlers == "enabled" then
		AddRecipe("deer_antler1", { Ingredient("boneshard", 20)}, RECIPETABS.SURVIVAL,  TECH.MAGIC_THREE) --鹿之匙1
		AddRecipe("deer_antler2", { Ingredient("boneshard", 20)}, RECIPETABS.SURVIVAL,  TECH.MAGIC_THREE) --鹿之匙2
		AddRecipe("deer_antler3", { Ingredient("boneshard", 20)}, RECIPETABS.SURVIVAL,  TECH.MAGIC_THREE) --鹿之匙3
		AddRecipe("klaussackkey", { Ingredient("deer_antler1", 3), Ingredient("deer_antler2", 2), Ingredient("deer_antler3", 1)}, RECIPETABS.SURVIVAL,  TECH.MAGIC_THREE) --牡鹿之匙
	end
end
if Clavaeegg ~= "disabled" then
    STRINGS.RECIPE_DESC.LAVAE_EGG = "There is a little cute."
	if Clavaeegg == "enabled" then
		AddRecipe("lavae_egg", { Ingredient("tallbirdegg", 1), Ingredient("ash", 8), Ingredient("charcoal", 12)}, RECIPETABS.SURVIVAL,  TECH.MAGIC_TWO) --熔岩虫卵
	end
end
if Cmanrabbittail ~= "disabled" then
    STRINGS.RECIPE_DESC.MANRABBIT_TAIL = "Maybe good taste."
	if Cmanrabbittail == "enabled" then
		AddRecipe("manrabbit_tail", { Ingredient("rabbit", 2), Ingredient("carrot", 4)}, RECIPETABS.REFINE,  TECH.SCIENCE_TWO) --兔毛
	end
end
if Cfossilpiece ~= "disabled" then
    STRINGS.RECIPE_DESC.FOSSIL_PIECE = "Maybe I can use it to assemble something."
	if Cfossilpiece == "enabled" then
		AddRecipe("fossil_piece", { Ingredient("rocks", 4), Ingredient("flint", 8)}, RECIPETABS.REFINE,  TECH.MAGIC_TWO) --化石碎片
	end
end
if Catriumkey ~= "disabled" then
    STRINGS.RECIPE_DESC.ATRIUM_KEY = "It should not be here."
	if Catriumkey == "enabled" then
		AddRecipe("atrium_key", { Ingredient("thulecite_pieces", 6), Ingredient("gears", 3), Ingredient("nightmarefuel", 6)}, RECIPETABS.REFINE,  TECH.MAGIC_THREE) --古老的钥匙
	end
end
if Cthurible ~= "disabled" then
    STRINGS.RECIPE_DESC.THURIBLE = "Attracting certain creatures."
	if Cthurible == "enabled" then
		AddRecipe("thurible", { Ingredient("townportaltalisman", 4), Ingredient("nightmarefuel", 6), Ingredient("decrease_sanity", 40)}, RECIPETABS.MAGIC,  TECH.MAGIC_THREE) --暗影香炉
	end
end
if Cskeletonhat ~= "disabled" then
    STRINGS.RECIPE_DESC.SKELETONHAT = "Experience the effects of 0 sanity."
	if Cskeletonhat == "enabled" then
		AddRecipe("skeletonhat", { Ingredient("townportaltalisman", 6), Ingredient("purpleamulet", 2), Ingredient("decrease_sanity", 80)}, RECIPETABS.WAR,  TECH.MAGIC_THREE) --骨头头盔
	end
end
if Carmorskeleton ~= "disabled" then
    STRINGS.RECIPE_DESC.ARMORSKELETON = "Strong protection."
	if Carmorskeleton == "enabled" then
		AddRecipe("armorskeleton", { Ingredient("townportaltalisman", 6), Ingredient("shadowheart", 1), Ingredient("decrease_sanity", 100)}, RECIPETABS.WAR,  TECH.MAGIC_THREE) --骨质盔甲
	end
end
if Csketch ~= "disabled" then
    GLOBAL.STRINGS.NAMES.CHESSPIECE_PAWN_SKETCH = "Pawn Figure Sketch"
	GLOBAL.STRINGS.NAMES.CHESSPIECE_ROOK_SKETCH = "Rook Figure Sketch"
	GLOBAL.STRINGS.NAMES.CHESSPIECE_KNIGHT_SKETCH = "Knight Figure Sketch"
	GLOBAL.STRINGS.NAMES.CHESSPIECE_BISHOP_SKETCH = "Bishop Figure Sketch"
	GLOBAL.STRINGS.NAMES.CHESSPIECE_MUSE_SKETCH = "Queenly Figure Sketch"
	GLOBAL.STRINGS.NAMES.CHESSPIECE_FORMAL_SKETCH = "Kingly Figure Sketch"
	GLOBAL.STRINGS.NAMES.CHESSPIECE_DEERCLOPS_SKETCH = "Deerclops Figure Sketch"
	GLOBAL.STRINGS.NAMES.CHESSPIECE_BEARGER_SKETCH = "Bearger Figure Sketch"
	GLOBAL.STRINGS.NAMES.CHESSPIECE_MOOSEGOOSE_SKETCH = "Moose/Goose Figure Sketch"
	GLOBAL.STRINGS.NAMES.CHESSPIECE_DRAGONFLY_SKETCH = "Dragonfly Figure Sketch"
    STRINGS.RECIPE_DESC.CHESSPIECE_PAWN_SKETCH = "A picture of a sculpture. We'll need somewhere to make it."
	STRINGS.RECIPE_DESC.CHESSPIECE_ROOK_SKETCH = "A picture of a sculpture. We'll need somewhere to make it."
	STRINGS.RECIPE_DESC.CHESSPIECE_KNIGHT_SKETCH = "A picture of a sculpture. We'll need somewhere to make it."
	STRINGS.RECIPE_DESC.CHESSPIECE_BISHOP_SKETCH = "A picture of a sculpture. We'll need somewhere to make it."
	STRINGS.RECIPE_DESC.CHESSPIECE_MUSE_SKETCH = "A picture of a sculpture. We'll need somewhere to make it."
	STRINGS.RECIPE_DESC.CHESSPIECE_FORMAL_SKETCH = "A picture of a sculpture. We'll need somewhere to make it."
	STRINGS.RECIPE_DESC.CHESSPIECE_DEERCLOPS_SKETCH = "A picture of a sculpture. We'll need somewhere to make it."
	STRINGS.RECIPE_DESC.CHESSPIECE_BEARGER_SKETCH = "A picture of a sculpture. We'll need somewhere to make it."
	STRINGS.RECIPE_DESC.CHESSPIECE_MOOSEGOOSE_SKETCH = "A picture of a sculpture. We'll need somewhere to make it."
	STRINGS.RECIPE_DESC.CHESSPIECE_DRAGONFLY_SKETCH = "A picture of a sculpture. We'll need somewhere to make it."
	if Csketch == "enabled" then
		AddRecipe("chesspiece_pawn_sketch", { Ingredient("sketch", 1), Ingredient("marble", 4), Ingredient("papyrus", 2)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/sketch.xml", "sketch.tex" ) --禁卫草图
		AddRecipe("chesspiece_rook_sketch", { Ingredient("sketch", 1), Ingredient("marble", 4), Ingredient("papyrus", 2)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/sketch.xml", "sketch.tex" ) --战车草图
		AddRecipe("chesspiece_knight_sketch", { Ingredient("sketch", 1), Ingredient("marble", 4), Ingredient("papyrus", 2)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/sketch.xml", "sketch.tex" ) --骑士草图
		AddRecipe("chesspiece_bishop_sketch", { Ingredient("sketch", 1), Ingredient("marble", 4), Ingredient("papyrus", 2)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/sketch.xml", "sketch.tex" ) --主教草图
		AddRecipe("chesspiece_muse_sketch", { Ingredient("sketch", 1), Ingredient("marble", 4), Ingredient("papyrus", 2)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/sketch.xml", "sketch.tex" ) --皇后草图
		AddRecipe("chesspiece_formal_sketch", { Ingredient("sketch", 1), Ingredient("marble", 4), Ingredient("papyrus", 2)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/sketch.xml", "sketch.tex" ) --国王草图
		AddRecipe("chesspiece_deerclops_sketch", { Ingredient("sketch", 1), Ingredient("marble", 4), Ingredient("papyrus", 2)}, RECIPETABS.SCIENCE,  TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/sketch.xml", "sketch.tex" ) --巨鹿草图
		AddRecipe("chesspiece_bearger_sketch", { Ingredient("sketch", 1), Ingredient("marble", 4), Ingredient("papyrus", 2)}, RECIPETABS.SCIENCE,  TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/sketch.xml", "sketch.tex" ) --熊草图
		AddRecipe("chesspiece_moosegoose_sketch", { Ingredient("sketch", 1), Ingredient("marble", 4), Ingredient("papyrus", 2)}, RECIPETABS.SCIENCE,  TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/sketch.xml", "sketch.tex" ) --鸭子草图
		AddRecipe("chesspiece_dragonfly_sketch", { Ingredient("sketch", 1), Ingredient("marble", 4), Ingredient("papyrus", 2)}, RECIPETABS.SCIENCE,  TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/sketch.xml", "sketch.tex" ) --苍蝇草图
	end
end
if Choneycomb ~= "disabled" then
    STRINGS.RECIPE_DESC.HONEYCOMB = "Bees used to live in this."
	if Choneycomb == "enabled" then
		AddRecipe("honeycomb", { Ingredient("honey", 4), Ingredient("stinger", 2)}, RECIPETABS.REFINE,  TECH.SCIENCE_ONE) --蜂巢
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if Cmandrake ~= "disabled" then
    STRINGS.RECIPE_DESC.MANDRAKE_PLANTED = "Strange grass,Tastes delicious."
	if Cmandrake == "enabled" then
		AddRecipe("mandrake_planted", { Ingredient("dragonfruit", 1), Ingredient("eggplant", 2), Ingredient("corn", 3)}, RECIPETABS.FARM,  TECH.MAGIC_TWO, "mandrake_planted_placer", --曼德拉草
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/mandrake_planted.xml",
		"mandrake_planted.tex")
	end
end
if Ccatcoonden ~= "disabled" then
    STRINGS.RECIPE_DESC.CATCOONDEN = "A cat's home."
	if Ccatcoonden == "enabled" then
		AddRecipe("catcoonden", {Ingredient("log", 4),Ingredient("twigs", 4)}, RECIPETABS.TOWN, TECH.SCIENCE_ONE, "catcoonden_placer", --猫窝_22
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/catcoonden.xml",
		"catcoonden.tex")
	end
end
if Cwalruscamp ~= "disabled" then
    STRINGS.RECIPE_DESC.WALRUS_CAMP = "There lived a walrus and his son."
	if Cwalruscamp == "enabled" then
		AddRecipe("walrus_camp", {Ingredient("ice", 8),Ingredient("houndstooth", 4),Ingredient("bluegem", 3)}, RECIPETABS.TOWN, TECH.SCIENCE_ONE, "walrus_camp_placer", --海象巢穴
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/walrus_camp.xml",
		"walrus_camp.tex")
	end
end
if Cancientaltar ~= "disabled" then
	STRINGS.RECIPE_DESC.ANCIENT_ALTAR_BROKEN = "Unlock more technology."
	STRINGS.RECIPE_DESC.ANCIENT_ALTAR = "Unlock more technology."
	if Cancientaltar == "altar broken" then
		AddRecipe("ancient_altar_broken", {Ingredient("moonrocknugget", 4),Ingredient("purplegem", 2),Ingredient("thulecite_pieces", 6)}, RECIPETABS.SCIENCE, TECH.MAGIC_THREE, "ancient_altar_broken_placer", --损坏的远古遗迹
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/ancient_altar_broken.xml",
		"ancient_altar_broken.tex")
		else
		if Cancientaltar == "ancient altar" then
		AddRecipe("ancient_altar", {Ingredient("moonrocknugget", 6),Ingredient("purplegem", 4),Ingredient("thulecite", 2)}, RECIPETABS.SCIENCE, TECH.MAGIC_THREE, "ancient_altar_placer", --远古遗迹
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/ancient_altar.xml",
		"ancient_altar.tex")
		end
	end
end
if Cpond ~= "disabled" then
    STRINGS.RECIPE_DESC.POND = "just a pond"
	STRINGS.RECIPE_DESC.POND_MOS = "just a pond"
	STRINGS.RECIPE_DESC.LAVA_POND = "Hot pond"
	STRINGS.RECIPE_DESC.POND_CAVE = "just a pond"
	if Cpond == "enabled" then
		AddRecipe("pond", {Ingredient("pondfish", 8),Ingredient("fishingrod", 1),Ingredient("froglegs", 4)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, "pond_placer", --池塘
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/pond.xml",
		"pond.tex")
		AddRecipe("pond_mos", {Ingredient("pondfish", 8),Ingredient("fishingrod", 1),Ingredient("mosquito", 4)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, "pond_mos_placer", --沼泽池塘
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/pond_mos.xml",
		"pond_mos.tex")
		AddRecipe("lava_pond", {Ingredient("ash", 8),Ingredient("heatrock", 1),Ingredient("charcoal", 4)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, "lava_pond_placer", --岩浆
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/lava_pond.xml",
		"lava_pond.tex")
		AddRecipe("pond_cave", {Ingredient("pondfish", 8),Ingredient("fishingrod", 1),Ingredient("ice", 4)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, "pond_cave_placer", --地下池塘
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/pond_cave.xml",
		"pond_cave.tex")
	end
end
if Cmermhouse ~= "disabled" then
    STRINGS.RECIPE_DESC.MERMHOUSE = "Fish house."
	if Cmermhouse == "enabled" then
		AddRecipe("mermhouse", {Ingredient("pondfish", 4),Ingredient("rocks", 1),Ingredient("boards", 2)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, "mermhouse_placer", --鱼人房_111
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/mermhouse.xml",
		"mermhouse.tex")
	end
end
if Cresurrectionstone ~= "disabled" then
    STRINGS.RECIPE_DESC.RESURRECTIONSTONE = "resurrection."
	if Cresurrectionstone == "enabled" then
		AddRecipe("resurrectionstone", {Ingredient("decrease_health", 60),Ingredient("rocks", 2),Ingredient("nightmarefuel", 1),Ingredient("marble", 2)}, RECIPETABS.SURVIVAL, TECH.MAGIC_THREE, "resurrectionstone_placer", --试金石_212
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/resurrectionstone.xml",
		"resurrectionstone.tex")
	end
end
if Cbeehive ~= "disabled" then
    STRINGS.RECIPE_DESC.BEEHIVE = "Swarm of bees."
	if Cbeehive == "enabled" then
		AddRecipe("beehive", {Ingredient("honeycomb", 1),Ingredient("honey", 3)}, RECIPETABS.TOWN, TECH.MAGIC_TWO, "beehive_placer", --蜂窝_13
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/beehive.xml",
		"beehive.tex")
	end
end
if Cwasphive ~= "disabled" then
    STRINGS.RECIPE_DESC.WASPHIVE = "Swarm of killer bees."
	if Cwasphive == "enabled" then
		AddRecipe("wasphive", {Ingredient("honeycomb", 1),Ingredient("honey", 3)}, RECIPETABS.TOWN, TECH.MAGIC_TWO, "wasphive_placer", --杀人蜂窝_13
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/wasphive.xml",
		"wasphive.tex")
	end
end
if Cspiderhole ~= "disabled" then
    STRINGS.RECIPE_DESC.SPIDERHOLE = "Underground spider nest."
	if Cspiderhole == "enabled" then
		AddRecipe("spiderhole", {Ingredient("spidergland", 2),Ingredient("silk", 2),Ingredient("rocks", 4)}, RECIPETABS.TOWN, TECH.MAGIC_TWO, "spiderhole_placer", --地下蜘蛛洞_25% 25% 2 1fossil_piece
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/spiderhole.xml",
		"spiderhole.tex")
	end
end
if Cslurtlehole ~= "disabled" then
    STRINGS.RECIPE_DESC.SLURTLEHOLE = "Snail nest."
	if Cslurtlehole == "enabled" then
		AddRecipe("slurtlehole", {Ingredient("phlegm", 2),Ingredient("rocks", 4)}, RECIPETABS.TOWN, TECH.MAGIC_TWO, "slurtlehole_placer", --蜗牛窝
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/slurtlehole.xml",
		"slurtlehole.tex")
	end
end
if Cbatcave ~= "disabled" then
    STRINGS.RECIPE_DESC.BATCAVE = "Nasty guy."
	if Cbatcave == "enabled" then
		AddRecipe("batcave", {Ingredient("butterflywings", 2),Ingredient("guano", 3),Ingredient("rocks", 4)}, RECIPETABS.TOWN, TECH.MAGIC_TWO, "batcave_placer", --蝙蝠洞
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/batcave.xml",
		"batcave.tex")
	end
end
if Cmonkeybarrel ~= "disabled" then
    STRINGS.RECIPE_DESC.MONKEYBARREL = "Monkey stay."
	if Cmonkeybarrel == "enabled" then
		AddRecipe("monkeybarrel", {Ingredient("boards", 2),Ingredient("poop", 2)}, RECIPETABS.TOWN, TECH.MAGIC_TWO, "monkeybarrel_placer", --猴子桶_22 1%trinket_13
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/monkeybarrel.xml",
		"monkeybarrel.tex")
	end
end
if Ctallbirdnest ~= "disabled" then
    STRINGS.RECIPE_DESC.TALLBIRDNEST = "A long-legged bird's nest."
	if Ctallbirdnest == "enabled" then
		AddRecipe("tallbirdnest", {Ingredient("tallbirdegg", 1),Ingredient("cutgrass", 5),Ingredient("meat", 3)}, RECIPETABS.SURVIVAL, TECH.MAGIC_TWO, "tallbirdnest_placer", --高脚鸟窝
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/tallbirdnest.xml",
		"tallbirdnest.tex")
	end
end
if Choundmound ~= "disabled" then
    STRINGS.RECIPE_DESC.HOUNDMOUND = "Hound's birthplace."
	if Choundmound == "enabled" then
		AddRecipe("houndmound", {Ingredient("redgem", 1),Ingredient("bluegem", 1),Ingredient("houndstooth", 3)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, "houndmound_placer", --猎犬丘_1%1%32boneshard
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/houndmound.xml",
		"houndmound.tex")
	end
end
if Ccavebananatree ~= "disabled" then
    STRINGS.RECIPE_DESC.CAVE_BANANA_TREE = "Banana."
	if Ccavebananatree == "enabled" then
		AddRecipe("cave_banana_tree", {Ingredient("durian", 1),Ingredient("twigs", 3),Ingredient("log", 2)}, RECIPETABS.SURVIVAL, TECH.MAGIC_TWO, "cave_banana_tree_placer", --香蕉树
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/cave_banana_tree.xml",
		"cave_banana_tree.tex")
	end
end
if Cstatueglommer ~= "disabled" then
    STRINGS.RECIPE_DESC.STATUEGLOMMER = "Strange statue."
	if Cstatueglommer == "enabled" then
		AddRecipe("statueglommer", {Ingredient("marble", 4)}, RECIPETABS.TOWN, TECH.MAGIC_THREE, "statueglommer_placer", --格罗姆雕像_3
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/statueglommer.xml",
		"statueglommer.tex")
	end
end
if Cbabybeefalo ~= "disabled" then
    STRINGS.RECIPE_DESC.BABYBEEFALO = "baby beefalo."
	if Cbabybeefalo == "enabled" then
		AddRecipe("babybeefalo", {Ingredient("beefalowool", 1),Ingredient("smallmeat", 2)}, RECIPETABS.FARM, TECH.MAGIC_TWO, "babybeefalo_placer", --牛宝宝_13
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/babybeefalo.xml",
		"babybeefalo.tex")
	end
end
if Csinkholesandstairs ~= "disabled" then
    STRINGS.RECIPE_DESC.CAVE_ENTRANCE_OPEN = "The entrance to the cave."
	STRINGS.RECIPE_DESC.CAVE_EXIT = "Exit the cave."
	if Csinkholesandstairs == "enabled" then
		AddRecipe("cave_entrance_open", {Ingredient("flint", 4),Ingredient("rocks", 3)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, "cave_entrance_open_placer", --落水洞
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/cave_entrance_open.xml",
		"cave_entrance_open.tex")
		AddRecipe("cave_exit", {Ingredient("flint", 8),Ingredient("rocks", 6)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, "cave_exit_placer", --洞穴出口
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/cave_exit.xml",
		"cave_exit.tex")
	end
end
if Cwormlightplant ~= "disabled" then
    STRINGS.RECIPE_DESC.WORMLIGHT_PLANT = "Strange plant."
	if Cwormlightplant == "enabled" then
		AddRecipe("wormlight_plant", {Ingredient("fireflies", 2),Ingredient("cactus_meat", 1),Ingredient("berries", 4)}, RECIPETABS.SURVIVAL, TECH.MAGIC_TWO, "wormlight_plant_placer", --小发光浆果树
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/wormlight_plant.xml",
		"wormlight_plant.tex")
	end
end
if Cflowercave ~= "disabled" then
    GLOBAL.STRINGS.NAMES.FLOWER_CAVE_DOUBLE = "Light Flower"
	GLOBAL.STRINGS.NAMES.FLOWER_CAVE_TRIPLE = "Light Flower"
	STRINGS.RECIPE_DESC.FLOWER_CAVE = "It can give me light."
	STRINGS.RECIPE_DESC.FLOWER_CAVE_DOUBLE = "It can give me light."
	STRINGS.RECIPE_DESC.FLOWER_CAVE_TRIPLE = "It can give me light."
	if Cflowercave == "enabled" then
		AddRecipe("flower_cave", {Ingredient("fireflies", 1),Ingredient("cutreeds", 1),Ingredient("cutgrass", 1)}, RECIPETABS.SURVIVAL, TECH.MAGIC_TWO, "flower_cave_placer", --荧光草1
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/flower_cave.xml",
		"flower_cave.tex")
		AddRecipe("flower_cave_double", {Ingredient("fireflies", 2),Ingredient("cutreeds", 2),Ingredient("cutgrass", 2)}, RECIPETABS.SURVIVAL, TECH.MAGIC_TWO, "flower_cave_double_placer", --荧光草2
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/flower_cave_double.xml",
		"flower_cave_double.tex")
		AddRecipe("flower_cave_triple", {Ingredient("fireflies", 3),Ingredient("cutreeds", 3),Ingredient("cutgrass", 3)}, RECIPETABS.SURVIVAL, TECH.MAGIC_TWO, "flower_cave_triple_placer", --荧光草3
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/flower_cave_triple.xml",
		"flower_cave_triple.tex")
	end
end
if Ccactus ~= "disabled" then
    STRINGS.RECIPE_DESC.CACTUS = "Rude plants."
	if Ccactus == "enabled" then
		AddRecipe("cactus", {Ingredient("cactus_meat", 3),Ingredient("cactus_flower", 3)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, "cactus_placer", --仙人球
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/cactus.xml",
		"cactus.tex")
	end
end
if Coasiscactus ~= "disabled" then
    GLOBAL.STRINGS.NAMES.OASIS_CACTUS = "Oasis Cactus"
    STRINGS.RECIPE_DESC.OASIS_CACTUS = "Rude plants."
	if Coasiscactus == "enabled" then
		AddRecipe("oasis_cactus", {Ingredient("cactus_meat", 3),Ingredient("cactus_flower", 3)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, "oasis_cactus_placer", --仙人掌
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/oasis_cactus.xml",
		"oasis_cactus.tex")
	end
end
if Creeds ~= "disabled" then
    STRINGS.RECIPE_DESC.REEDS = "What it can do."
	if Creeds == "enabled" then
		AddRecipe("reeds", {Ingredient("cutreeds", 3),Ingredient("cutgrass", 4)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, "reeds_placer", --芦苇
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/reeds.xml",
		"reeds.tex")
	end
end
if Cklaussack ~= "disabled" then
    STRINGS.RECIPE_DESC.KLAUS_SACK = "Come again a spree."
	if Cklaussack == "enabled" then
		AddRecipe("klaus_sack", {Ingredient("charcoal", 12),Ingredient("boneshard", 20)}, RECIPETABS.SURVIVAL, TECH.MAGIC_TWO, "klaus_sack_placer", --精确补给
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/klaus_sack.xml",
		"klaus_sack.tex")
	end
end
if Csacredchest ~= "disabled" then
    STRINGS.RECIPE_DESC.SACRED_CHEST = "Magical box."
	if Csacredchest == "enabled" then
		AddRecipe("sacred_chest", {Ingredient("thulecite_pieces", 2),Ingredient("nightmarefuel", 4)}, RECIPETABS.TOWN, TECH.MAGIC_TWO, "sacred_chest_placer", --远古箱子
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/sacred_chest.xml",
		"sacred_chest.tex")
	end
end
if Crabbithole ~= "disabled" then
    STRINGS.RECIPE_DESC.RABBITHOLE = "A small animal's burrow."
	if Crabbithole == "enabled" then
		AddRecipe("rabbithole", {Ingredient("rabbit", 1)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_ONE, "rabbithole_placer", --兔子洞
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/rabbithole.xml",
		"rabbithole.tex")
	end
end
if Cpigtorch ~= "disabled" then
    STRINGS.RECIPE_DESC.PIGTORCH = "Light the torch."
	if Cpigtorch == "enabled" then
		AddRecipe("pigtorch", {Ingredient("log", 3), Ingredient("poop", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_ONE, "pigtorch_placer", --猪人火炬
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/pigtorch.xml",
		"pigtorch.tex")
	end
end
if Coasislake ~= "disabled" then
    STRINGS.RECIPE_DESC.OASISLAKE = "A lake."
	if Coasislake == "enabled" then
		AddRecipe("oasislake", {Ingredient("pondfish", 4), Ingredient("wetpouch", 4), Ingredient("fireflies", 4)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, "oasislake_placer", --湖泊
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/oasislake.xml",
		"oasislake.tex")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
else
if Ccave == "yes" then

if Cchestereyebone ~= "disabled" then
    STRINGS.RECIPE_DESC.CHESTER_EYEBONE = "Summons chester."
	if Cchestereyebone == "enabled" then
		AddRecipe("chester_eyebone", { Ingredient("monstermeat", 4), Ingredient("houndstooth", 2)}, RECIPETABS.SURVIVAL,  TECH.SCIENCE_ONE) --切斯特眼骨
	end
end
if Chutchfishbowl ~= "disabled" then
    STRINGS.RECIPE_DESC.HUTCH_FISHBOWL = "Summons hutch."
	if Chutchfishbowl == "enabled" then
		AddRecipe("hutch_fishbowl", { Ingredient("pondeel", 4), Ingredient("ice", 2)}, RECIPETABS.SURVIVAL,  TECH.SCIENCE_ONE) --星-空
	end
end
if Cbutter ~= "disabled" then
    STRINGS.RECIPE_DESC.BUTTER = "butter."
	if Cbutter == "enabled" then
		AddRecipe("butter", { Ingredient("butterflywings", 2), Ingredient("petals", 2), Ingredient("honey", 1)}, RECIPETABS.FARM,  TECH.SCIENCE_TWO) --黄油
	end
end
if Cbeardhair ~= "disabled" then
    STRINGS.RECIPE_DESC.BEARDHAIR = "What's the use?"
	if Cbeardhair == "enabled" then
		AddRecipe("beardhair", { Ingredient("nightmarefuel", 1), Ingredient("ash", 1)}, RECIPETABS.SURVIVAL,  TECH.MAGIC_TWO) --胡须
	end
end
if Clureplantbulb ~= "disabled" then
    STRINGS.RECIPE_DESC.LUREPLANTBULB = "Good place for waste disposal."
	if Clureplantbulb == "enabled" then
		AddRecipe("lureplantbulb", { Ingredient("meat", 2), Ingredient("monstermeat", 4)}, RECIPETABS.SURVIVAL,  TECH.SCIENCE_TWO) --多肉的球茎
	end
end
if Cspidereggsack ~= "disabled" then
	if Cspidereggsack == "enabled" then
		AddRecipe("spidereggsack", { Ingredient("silk", 8), Ingredient("spidergland", 5), Ingredient("papyrus", 4)}, RECIPETABS.SURVIVAL,  TECH.SCIENCE_TWO) --蜘蛛卵
	end
end
if Cspiderhat ~= "disabled" then
	if Cspiderhat == "enabled" then
		AddRecipe("spiderhat", { Ingredient("spidereggsack", 1), Ingredient("tophat", 1), Ingredient("spidergland", 3)}, RECIPETABS.DRESS,  TECH.MAGIC_TWO) --蜘蛛帽
	end
end
if Cgem ~= "disabled" then
    STRINGS.RECIPE_DESC.REDGEM = "Colored stone."
	STRINGS.RECIPE_DESC.BLUEGEM = "Colored stone."
	STRINGS.RECIPE_DESC.GREENGEM = "Colored stone."
	STRINGS.RECIPE_DESC.ORANGEGEM = "Colored stone."
	STRINGS.RECIPE_DESC.YELLOWGEM = "Colored stone."
	if Cgem == "enabled" then
		AddRecipe("redgem", { Ingredient("goldnugget", 2), Ingredient("feather_robin", 1), Ingredient("nightmarefuel", 2)}, RECIPETABS.REFINE,  TECH.MAGIC_TWO) --红宝石
		AddRecipe("bluegem", { Ingredient("goldnugget", 2), Ingredient("feather_robin_winter", 1), Ingredient("nightmarefuel", 2)}, RECIPETABS.REFINE,  TECH.MAGIC_TWO) --蓝宝石
		AddRecipe("greengem", { Ingredient("lightbulb", 2), Ingredient("froglegs", 2), Ingredient("nightmarefuel", 2)}, RECIPETABS.REFINE,  TECH.MAGIC_TWO) --绿宝石
		AddRecipe("orangegem", { Ingredient("transistor", 1), Ingredient("pumpkin", 1), Ingredient("nightmarefuel", 2)}, RECIPETABS.REFINE,  TECH.MAGIC_TWO) --橙宝石
		AddRecipe("yellowgem", { Ingredient("transistor", 1), Ingredient("honey", 2), Ingredient("nightmarefuel", 2)}, RECIPETABS.REFINE,  TECH.MAGIC_TWO) --黄宝石
	end
end
if Cwalrushat ~= "disabled" then
    STRINGS.RECIPE_DESC.WALRUSHAT = "Nice hat."
	if Cwalrushat == "enabled" then
		AddRecipe("walrushat", { Ingredient("flowerhat", 1), Ingredient("walrus_tusk", 2), Ingredient("beefalowool", 4)}, RECIPETABS.DRESS,  TECH.MAGIC_TWO) --贝雷帽
	end
end
if Ckrampussack ~= "disabled" then
    STRINGS.RECIPE_DESC.KRAMPUS_SACK = "A big backpack."
	if Ckrampussack == "enabled" then
		AddRecipe("krampus_sack", { Ingredient("bearger_fur", 1), Ingredient("gears", 3), Ingredient("pigskin", 4)}, RECIPETABS.SURVIVAL,  TECH.MAGIC_THREE) --坎普斯背包
	end
end
if Cgears ~= "disabled" then
    STRINGS.RECIPE_DESC.GEARS = "Very practical stuff."
	if Cgears == "enabled" then
		AddRecipe("gears", { Ingredient("cutstone", 4), Ingredient("goldnugget", 4), Ingredient("transistor", 2)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_ONE) --齿轮
	end
end
if Csteelwool ~= "disabled" then
    STRINGS.RECIPE_DESC.STEELWOOL = "Disgusting animal.\nrarely seen."
	if Csteelwool == "enabled" then
		AddRecipe("steelwool", { Ingredient("trunk_summer", 1), Ingredient("trunk_winter", 1), Ingredient("goose_feather", 1)}, RECIPETABS.REFINE,  TECH.MAGIC_THREE) --钢丝绒
	end
end
if Cmoonrocknugget ~= "disabled" then
    STRINGS.RECIPE_DESC.MOONROCKNUGGET = "Stone from the sky."
	if Cmoonrocknugget == "enabled" then
		AddRecipe("moonrocknugget", { Ingredient("transistor", 1), Ingredient("livinglog", 1), Ingredient("rocks", 4)}, RECIPETABS.REFINE,  TECH.MAGIC_TWO) --月之石
	end
end
if Cthulecitepieces ~= "disabled" then
    STRINGS.RECIPE_DESC.THULECITE_PIECES = "Use it to build more technology."
	if Cthulecitepieces == "enabled" then
		AddRecipe("thulecite_pieces", { Ingredient("transistor", 1), Ingredient("nightmarefuel", 1)}, RECIPETABS.REFINE,  TECH.MAGIC_THREE) --铥矿石碎片
	end
end
if Cminotaurhorn ~= "disabled" then
    STRINGS.RECIPE_DESC.MINOTAURHORN = "Seemingly useless."
	if Cminotaurhorn == "enabled" then
		AddRecipe("minotaurhorn", { Ingredient("dragon_scales", 1), Ingredient("lightninggoathorn", 1), Ingredient("horn", 1)}, RECIPETABS.REFINE,  TECH.MAGIC_THREE) --守卫者的角
	end
end
if Carmorsnurtleshell ~= "disabled" then
    STRINGS.RECIPE_DESC.ARMORSNURTLESHELL = "Feeling very strange."
	if Carmorsnurtleshell == "enabled" then
		AddRecipe("armorsnurtleshell", { Ingredient("slurtleslime", 2), Ingredient("armorwood", 1)}, RECIPETABS.WAR,  TECH.MAGIC_TWO) --黏糊虫壳甲
	end
end
if Cslurtlehat ~= "disabled" then
    STRINGS.RECIPE_DESC.SLURTLEHAT = "Cool."
	if Cslurtlehat == "enabled" then
		AddRecipe("slurtlehat", { Ingredient("slurtle_shellpieces", 1), Ingredient("footballhat", 1)}, RECIPETABS.WAR,  TECH.MAGIC_TWO) --贝壳头盔
	end
end
if Cwormlight ~= "disabled" then
    STRINGS.RECIPE_DESC.WORMLIGHT = "Light."
	if Cwormlight == "enabled" then
		AddRecipe("wormlight", { Ingredient("lightbulb", 2), Ingredient("wormlight_lesser", 3), Ingredient("berries", 4)}, RECIPETABS.REFINE,  TECH.MAGIC_TWO) --发光浆果
	end
end
if Cgoosefeather ~= "disabled" then
    STRINGS.RECIPE_DESC.GOOSE_FEATHER = "Soft feathers."
	if Cgoosefeather == "enabled" then
		AddRecipe("goose_feather", { Ingredient("feather_robin", 1), Ingredient("feather_robin_winter", 1), Ingredient("feather_crow", 1)}, RECIPETABS.REFINE,  TECH.MAGIC_THREE) --掉落的羽毛
	end
end
if Cfurtuft ~= "disabled" then
    STRINGS.RECIPE_DESC.FURTUFT = "furtuft*30."
	if Cfurtuft == "enabled" then
		AddRecipe("furtuft", { Ingredient("goose_feather", 8), Ingredient("beefalowool", 12), Ingredient("coontail", 1)}, RECIPETABS.REFINE,  TECH.MAGIC_THREE,nil,nil,nil,30) --毛簇
	end
end
if Cdragonscales ~= "disabled" then
    STRINGS.RECIPE_DESC.DRAGON_SCALES = "Look hard."
	if Cdragonscales == "enabled" then
		AddRecipe("dragon_scales", { Ingredient("goose_feather", 12), Ingredient("bearger_fur", 3), Ingredient("deerclops_eyeball", 1)}, RECIPETABS.REFINE,  TECH.MAGIC_THREE) --鳞片
	end
end
if Cdeerclopseyeball ~= "disabled" then
    STRINGS.RECIPE_DESC.DEERCLOPS_EYEBALL = "A part of an organism."
	if Cdeerclopseyeball == "enabled" then
		AddRecipe("deerclops_eyeball", { Ingredient("steelwool", 1), Ingredient("mole", 2), Ingredient("tallbirdegg", 1)}, RECIPETABS.REFINE,  TECH.MAGIC_THREE) --巨鹿眼球
	end
end
if Cblueprint ~= "disabled" then
    STRINGS.RECIPE_DESC.BLUEPRINT = "Random."
	if Cblueprint == "enabled" then
		AddRecipe("blueprint", { Ingredient("orangegem", 1), Ingredient("yellowgem", 1), Ingredient("purplegem", 1)}, RECIPETABS.SCIENCE,  TECH.NONE) --蓝图
	end
end
if Clivinglog ~= "disabled" then
    STRINGS.RECIPE_DESC.LIVINGLOG = "Live wood."
	if Clivinglog == "enabled" then
		AddRecipe("livinglog", { Ingredient("log", 8), Ingredient("nightmarefuel", 3)}, RECIPETABS.REFINE,  TECH.MAGIC_TWO) --活木
	end
end
if Cmandrakesoup ~= "disabled" then
    STRINGS.RECIPE_DESC.MANDRAKESOUP = "Delicious ah."
	if Cmandrakesoup == "enabled" then
		AddRecipe("mandrakesoup", { Ingredient("bonestew", 1), Ingredient("carrot", 3), Ingredient("waffles", 1)}, RECIPETABS.FARM,  TECH.SCIENCE_TWO) --曼德拉草汤
	end
end
if Cpetalsevil ~= "disabled" then
    STRINGS.RECIPE_DESC.PETALS_EVIL = "Province of mischief."
	if Cpetalsevil == "enabled" then
		AddRecipe("petals_evil", { Ingredient("petals", 1)}, RECIPETABS.REFINE,  TECH.SCIENCE_TWO) --恶魔花瓣
	end
end
if Cmarble ~= "disabled" then
    STRINGS.RECIPE_DESC.MARBLE = "Hard stone."
	if Cmarble == "enabled" then
		AddRecipe("marble", { Ingredient("flint", 3), Ingredient("rocks", 1)}, RECIPETABS.REFINE,  TECH.SCIENCE_TWO) --大理石
	end
end
if Crareblueprint ~= "disabled" then
    GLOBAL.STRINGS.NAMES.RED_MUSHROOMHAT_BLUEPRINT = "Red Funcap Blueprint"
	GLOBAL.STRINGS.NAMES.GREEN_MUSHROOMHAT_BLUEPRINT = "Green Funcap Blueprint"
	GLOBAL.STRINGS.NAMES.BLUE_MUSHROOMHAT_BLUEPRINT = "Blue Funcap Blueprint"
	GLOBAL.STRINGS.NAMES.MUSHROOM_LIGHT_BLUEPRINT = "Mushlight Blueprint"
	GLOBAL.STRINGS.NAMES.MUSHROOM_LIGHT2_BLUEPRINT = "Glowcap Blueprint"
	GLOBAL.STRINGS.NAMES.DRAGONFLYFURNACE_BLUEPRINT = "Scaled Furnace Blueprint"
	GLOBAL.STRINGS.NAMES.SLEEPBOMB_BLUEPRINT = "Napsack Blueprint"
	GLOBAL.STRINGS.NAMES.TOWNPORTAL_BLUEPRINT = "The Lazy Deserter Blueprint"
	GLOBAL.STRINGS.NAMES.BUNDLEWRAP_BLUEPRINT = "Bundling Wrap Blueprint"
	GLOBAL.STRINGS.NAMES.ENDTABLE_BLUEPRINT = "End Table Blueprint"
	GLOBAL.STRINGS.NAMES.SUCCULENT_POTTED_BLUEPRINT = "Potted Succulent Blueprint"
	GLOBAL.STRINGS.NAMES.GOGGLESHAT_BLUEPRINT = "Fashion Goggles Blueprint"
	GLOBAL.STRINGS.NAMES.DESERTHAT_BLUEPRINT = "Desert Goggles Blueprint"
    STRINGS.RECIPE_DESC.RED_MUSHROOMHAT_BLUEPRINT = "Knowledge."
	STRINGS.RECIPE_DESC.GREEN_MUSHROOMHAT_BLUEPRINT = "Knowledge."
	STRINGS.RECIPE_DESC.BLUE_MUSHROOMHAT_BLUEPRINT = "Knowledge."
	STRINGS.RECIPE_DESC.MUSHROOM_LIGHT_BLUEPRINT = "Knowledge."
	STRINGS.RECIPE_DESC.MUSHROOM_LIGHT2_BLUEPRINT = "Knowledge."
	STRINGS.RECIPE_DESC.DRAGONFLYFURNACE_BLUEPRINT = "Knowledge."
	STRINGS.RECIPE_DESC.SLEEPBOMB_BLUEPRINT = "Knowledge."
	STRINGS.RECIPE_DESC.TOWNPORTAL_BLUEPRINT = "Knowledge."
	STRINGS.RECIPE_DESC.BUNDLEWRAP_BLUEPRINT = "Knowledge."
	STRINGS.RECIPE_DESC.ENDTABLE_BLUEPRINT = "Knowledge."
	STRINGS.RECIPE_DESC.SUCCULENT_POTTED_BLUEPRINT = "Knowledge."
	STRINGS.RECIPE_DESC.GOGGLESHAT_BLUEPRINT = "Knowledge."
	STRINGS.RECIPE_DESC.DESERTHAT_BLUEPRINT = "Knowledge."
	if Crareblueprint == "enabled" then
		AddRecipe("red_mushroomhat_blueprint", { Ingredient("blueprint", 1), Ingredient("spore_medium", 20), Ingredient("lightbulb", 4)}, RECIPETABS.SCIENCE,  TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --红菇帽蓝图
		AddRecipe("green_mushroomhat_blueprint", { Ingredient("blueprint", 1), Ingredient("spore_small", 20), Ingredient("lightbulb", 4)}, RECIPETABS.SCIENCE,  TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --绿菇帽蓝图
		AddRecipe("blue_mushroomhat_blueprint", { Ingredient("blueprint", 1), Ingredient("spore_tall", 20), Ingredient("lightbulb", 4)}, RECIPETABS.SCIENCE,  TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --蓝菇帽蓝图
		AddRecipe("mushroom_light_blueprint", { Ingredient("blueprint", 1), Ingredient("shroom_skin", 1), Ingredient("lightbulb", 8)}, RECIPETABS.SCIENCE,  TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --荧菇灯蓝图
		AddRecipe("mushroom_light2_blueprint", { Ingredient("blueprint", 1), Ingredient("shroom_skin", 1), Ingredient("lightbulb", 8)}, RECIPETABS.SCIENCE,  TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --炽菇灯蓝图
		AddRecipe("dragonflyfurnace_blueprint", { Ingredient("blueprint", 1), Ingredient("dragon_scales", 1), Ingredient("charcoal", 12)}, RECIPETABS.SCIENCE,  TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --龙蝇火炉蓝图
		AddRecipe("sleepbomb_blueprint", { Ingredient("blueprint", 1), Ingredient("shroom_skin", 1), Ingredient("canary", 1), Ingredient("mandrake", 3)}, RECIPETABS.SCIENCE,  TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --Napsack蓝图
		AddRecipe("townportal_blueprint", { Ingredient("blueprint", 1), Ingredient("townportaltalisman", 6), Ingredient("heatrock", 1)}, RECIPETABS.SCIENCE,  TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --怠惰的逃亡者蓝图
		AddRecipe("bundlewrap_blueprint", { Ingredient("blueprint", 1), Ingredient("waxpaper", 1), Ingredient("rope", 2)}, RECIPETABS.SCIENCE,  TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --空包裹蓝图
		AddRecipe("endtable_blueprint", { Ingredient("blueprint", 1), Ingredient("petals", 4), Ingredient("hammer", 2)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --茶几蓝图
		AddRecipe("succulent_potted_blueprint", { Ingredient("blueprint", 1), Ingredient("wetpouch", 1)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --盆栽蓝图
		AddRecipe("goggleshat_blueprint", { Ingredient("blueprint", 1), Ingredient("wetpouch", 1)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --时尚眼镜蓝图
		AddRecipe("deserthat_blueprint", { Ingredient("blueprint", 1), Ingredient("wetpouch", 1)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/rare_blueprint.xml", "rare_blueprint.tex" ) --风镜蓝图
	end
end
if Cshroomskin ~= "disabled" then
    STRINGS.RECIPE_DESC.SHROOM_SKIN = "The skin of a creature."
	if Cshroomskin == "enabled" then
		AddRecipe("shroom_skin", { Ingredient("green_cap", 2), Ingredient("greengem", 1), Ingredient("feather_canary", 1)}, RECIPETABS.REFINE,  TECH.MAGIC_THREE) --蕈蟾酥
	end
end
if Chivehat ~= "disabled" then
    STRINGS.RECIPE_DESC.HIVEHAT = "The throne."
	if Chivehat == "enabled" then
		AddRecipe("hivehat", { Ingredient("spiderhat", 1), Ingredient("honeycomb", 1), Ingredient("horn", 2)}, RECIPETABS.WAR,  TECH.MAGIC_THREE) --蜂王冠
	end
end
if Croyaljelly ~= "disabled" then
    STRINGS.RECIPE_DESC.ROYAL_JELLY = "Looks sweet."
	if Croyaljelly == "enabled" then
		AddRecipe("royal_jelly", { Ingredient("butter", 2), Ingredient("honey", 4), Ingredient("ice", 8)}, RECIPETABS.FARM,  TECH.MAGIC_TWO) --蜂王浆
	end
end
if Chumanmeat ~= "disabled" then
    STRINGS.RECIPE_DESC.HUMANMEAT = "Horrible."
	if Chumanmeat == "enabled" then
		AddRecipe("humanmeat", { Ingredient("meat", 1), Ingredient("smallmeat", 2)}, RECIPETABS.FARM,  TECH.SCIENCE_TWO) --人肉
	end
end
if Copalstaff ~= "disabled" then
    STRINGS.RECIPE_DESC.OPALSTAFF = "It makes me cool."
	if Copalstaff == "enabled" then
		AddRecipe("opalstaff", { Ingredient("nightmarefuel", 4), Ingredient("livinglog", 2), Ingredient("opalpreciousgem", 1)}, RECIPETABS.MAGIC,  TECH.MAGIC_THREE) --呼月之杖
	end
end
if Copalpreciousgem ~= "disabled" then
    STRINGS.RECIPE_DESC.OPALPRECIOUSGEM = "Beautiful gem."
	if Copalpreciousgem == "enabled" then
		AddRecipe("opalpreciousgem", { Ingredient("moonrocknugget", 4), Ingredient("yellowgem", 2), Ingredient("glommerflower", 1)}, RECIPETABS.MAGIC,  TECH.MAGIC_THREE) --彩色宝石
	end
end
if Cshadowheart ~= "disabled" then
    STRINGS.RECIPE_DESC.SHADOWHEART = "Black heart."
	if Cshadowheart == "enabled" then
		AddRecipe("shadowheart", { Ingredient("nightmarefuel", 40), Ingredient("decrease_sanity", 50)}, RECIPETABS.REFINE,  TECH.MAGIC_THREE) --暗影之心
	end
end
if Cantlers ~= "disabled" then
    GLOBAL.STRINGS.NAMES.DEER_ANTLER1 = "Deer Antler"
	GLOBAL.STRINGS.NAMES.DEER_ANTLER2 = "Deer Antler"
	GLOBAL.STRINGS.NAMES.DEER_ANTLER3 = "Deer Antler"
    STRINGS.RECIPE_DESC.DEER_ANTLER1 = "Antlers."
	STRINGS.RECIPE_DESC.DEER_ANTLER2 = "Antlers."
	STRINGS.RECIPE_DESC.DEER_ANTLER3 = "Antlers."
	STRINGS.RECIPE_DESC.KLAUSSACKKEY = "The key to the treasure."
	if Cantlers == "enabled" then
		AddRecipe("deer_antler1", { Ingredient("boneshard", 20)}, RECIPETABS.SURVIVAL,  TECH.MAGIC_THREE) --鹿之匙1
		AddRecipe("deer_antler2", { Ingredient("boneshard", 20)}, RECIPETABS.SURVIVAL,  TECH.MAGIC_THREE) --鹿之匙2
		AddRecipe("deer_antler3", { Ingredient("boneshard", 20)}, RECIPETABS.SURVIVAL,  TECH.MAGIC_THREE) --鹿之匙3
		AddRecipe("klaussackkey", { Ingredient("deer_antler1", 3), Ingredient("deer_antler2", 2), Ingredient("deer_antler3", 1)}, RECIPETABS.SURVIVAL,  TECH.MAGIC_THREE) --牡鹿之匙
	end
end
if Clavaeegg ~= "disabled" then
    STRINGS.RECIPE_DESC.LAVAE_EGG = "There is a little cute."
	if Clavaeegg == "enabled" then
		AddRecipe("lavae_egg", { Ingredient("tallbirdegg", 1), Ingredient("ash", 8), Ingredient("charcoal", 12)}, RECIPETABS.SURVIVAL,  TECH.MAGIC_TWO) --熔岩虫卵
	end
end
if Cmanrabbittail ~= "disabled" then
    STRINGS.RECIPE_DESC.MANRABBIT_TAIL = "Maybe good taste."
	if Cmanrabbittail == "enabled" then
		AddRecipe("manrabbit_tail", { Ingredient("rabbit", 2), Ingredient("lightbulb", 4)}, RECIPETABS.REFINE,  TECH.SCIENCE_TWO) --兔毛
	end
end
if Cfossilpiece ~= "disabled" then
    STRINGS.RECIPE_DESC.FOSSIL_PIECE = "Maybe I can use it to assemble something."
	if Cfossilpiece == "enabled" then
		AddRecipe("fossil_piece", { Ingredient("rocks", 4), Ingredient("flint", 4), Ingredient("nightmarefuel", 4)}, RECIPETABS.REFINE,  TECH.MAGIC_TWO) --化石碎片
	end
end
if Catriumkey ~= "disabled" then
    STRINGS.RECIPE_DESC.ATRIUM_KEY = "It should not be here."
	if Catriumkey == "enabled" then
		AddRecipe("atrium_key", { Ingredient("thulecite", 4), Ingredient("gears", 2), Ingredient("nightmarefuel", 6)}, RECIPETABS.REFINE,  TECH.MAGIC_THREE) --古老的钥匙
	end
end
if Cthurible ~= "disabled" then
    STRINGS.RECIPE_DESC.THURIBLE = "Attracting certain creatures."
	if Cthurible == "enabled" then
		AddRecipe("thurible", { Ingredient("fossil_piece", 3), Ingredient("nightmarefuel", 6), Ingredient("decrease_sanity", 40)}, RECIPETABS.MAGIC,  TECH.MAGIC_THREE) --暗影香炉
	end
end
if Cskeletonhat ~= "disabled" then
    STRINGS.RECIPE_DESC.SKELETONHAT = "Experience the effects of 0 sanity."
	if Cskeletonhat == "enabled" then
		AddRecipe("skeletonhat", { Ingredient("fossil_piece", 6), Ingredient("purpleamulet", 2), Ingredient("decrease_sanity", 80)}, RECIPETABS.WAR,  TECH.MAGIC_THREE) --骨头头盔
	end
end
if Carmorskeleton ~= "disabled" then
    STRINGS.RECIPE_DESC.ARMORSKELETON = "Strong protection."
	if Carmorskeleton == "enabled" then
		AddRecipe("armorskeleton", { Ingredient("fossil_piece", 9), Ingredient("shadowheart", 1), Ingredient("decrease_sanity", 100)}, RECIPETABS.WAR,  TECH.MAGIC_THREE) --骨质盔甲
	end
end
if Csketch ~= "disabled" then
    GLOBAL.STRINGS.NAMES.CHESSPIECE_PAWN_SKETCH = "Pawn Figure Sketch"
	GLOBAL.STRINGS.NAMES.CHESSPIECE_ROOK_SKETCH = "Rook Figure Sketch"
	GLOBAL.STRINGS.NAMES.CHESSPIECE_KNIGHT_SKETCH = "Knight Figure Sketch"
	GLOBAL.STRINGS.NAMES.CHESSPIECE_BISHOP_SKETCH = "Bishop Figure Sketch"
	GLOBAL.STRINGS.NAMES.CHESSPIECE_MUSE_SKETCH = "Queenly Figure Sketch"
	GLOBAL.STRINGS.NAMES.CHESSPIECE_FORMAL_SKETCH = "Kingly Figure Sketch"
	GLOBAL.STRINGS.NAMES.CHESSPIECE_DEERCLOPS_SKETCH = "Deerclops Figure Sketch"
	GLOBAL.STRINGS.NAMES.CHESSPIECE_BEARGER_SKETCH = "Bearger Figure Sketch"
	GLOBAL.STRINGS.NAMES.CHESSPIECE_MOOSEGOOSE_SKETCH = "Moose/Goose Figure Sketch"
	GLOBAL.STRINGS.NAMES.CHESSPIECE_DRAGONFLY_SKETCH = "Dragonfly Figure Sketch"
    STRINGS.RECIPE_DESC.CHESSPIECE_PAWN_SKETCH = "A picture of a sculpture. We'll need somewhere to make it."
	STRINGS.RECIPE_DESC.CHESSPIECE_ROOK_SKETCH = "A picture of a sculpture. We'll need somewhere to make it."
	STRINGS.RECIPE_DESC.CHESSPIECE_KNIGHT_SKETCH = "A picture of a sculpture. We'll need somewhere to make it."
	STRINGS.RECIPE_DESC.CHESSPIECE_BISHOP_SKETCH = "A picture of a sculpture. We'll need somewhere to make it."
	STRINGS.RECIPE_DESC.CHESSPIECE_MUSE_SKETCH = "A picture of a sculpture. We'll need somewhere to make it."
	STRINGS.RECIPE_DESC.CHESSPIECE_FORMAL_SKETCH = "A picture of a sculpture. We'll need somewhere to make it."
	STRINGS.RECIPE_DESC.CHESSPIECE_DEERCLOPS_SKETCH = "A picture of a sculpture. We'll need somewhere to make it."
	STRINGS.RECIPE_DESC.CHESSPIECE_BEARGER_SKETCH = "A picture of a sculpture. We'll need somewhere to make it."
	STRINGS.RECIPE_DESC.CHESSPIECE_MOOSEGOOSE_SKETCH = "A picture of a sculpture. We'll need somewhere to make it."
	STRINGS.RECIPE_DESC.CHESSPIECE_DRAGONFLY_SKETCH = "A picture of a sculpture. We'll need somewhere to make it."
	if Csketch == "enabled" then
		AddRecipe("chesspiece_pawn_sketch", { Ingredient("sketch", 1), Ingredient("marble", 4), Ingredient("papyrus", 2)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/sketch.xml", "sketch.tex" ) --禁卫草图
		AddRecipe("chesspiece_rook_sketch", { Ingredient("sketch", 1), Ingredient("marble", 4), Ingredient("papyrus", 2)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/sketch.xml", "sketch.tex" ) --战车草图
		AddRecipe("chesspiece_knight_sketch", { Ingredient("sketch", 1), Ingredient("marble", 4), Ingredient("papyrus", 2)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/sketch.xml", "sketch.tex" ) --骑士草图
		AddRecipe("chesspiece_bishop_sketch", { Ingredient("sketch", 1), Ingredient("marble", 4), Ingredient("papyrus", 2)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/sketch.xml", "sketch.tex" ) --主教草图
		AddRecipe("chesspiece_muse_sketch", { Ingredient("sketch", 1), Ingredient("marble", 4), Ingredient("papyrus", 2)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/sketch.xml", "sketch.tex" ) --皇后草图
		AddRecipe("chesspiece_formal_sketch", { Ingredient("sketch", 1), Ingredient("marble", 4), Ingredient("papyrus", 2)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/sketch.xml", "sketch.tex" ) --国王草图
		AddRecipe("chesspiece_deerclops_sketch", { Ingredient("sketch", 1), Ingredient("marble", 4), Ingredient("papyrus", 2)}, RECIPETABS.SCIENCE,  TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/sketch.xml", "sketch.tex" ) --巨鹿草图
		AddRecipe("chesspiece_bearger_sketch", { Ingredient("sketch", 1), Ingredient("marble", 4), Ingredient("papyrus", 2)}, RECIPETABS.SCIENCE,  TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/sketch.xml", "sketch.tex" ) --熊草图
		AddRecipe("chesspiece_moosegoose_sketch", { Ingredient("sketch", 1), Ingredient("marble", 4), Ingredient("papyrus", 2)}, RECIPETABS.SCIENCE,  TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/sketch.xml", "sketch.tex" ) --鸭子草图
		AddRecipe("chesspiece_dragonfly_sketch", { Ingredient("sketch", 1), Ingredient("marble", 4), Ingredient("papyrus", 2)}, RECIPETABS.SCIENCE,  TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/sketch.xml", "sketch.tex" ) --苍蝇草图
	end
end
if Choneycomb ~= "disabled" then
    STRINGS.RECIPE_DESC.HONEYCOMB = "Bees used to live in this."
	if Choneycomb == "enabled" then
		AddRecipe("honeycomb", { Ingredient("honey", 4), Ingredient("stinger", 2)}, RECIPETABS.REFINE,  TECH.SCIENCE_ONE) --蜂巢
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if Cmandrake ~= "disabled" then
    STRINGS.RECIPE_DESC.MANDRAKE_PLANTED = "Strange grass,Tastes delicious."
	if Cmandrake == "enabled" then
		AddRecipe("mandrake_planted", { Ingredient("dragonfruit", 1), Ingredient("eggplant", 2), Ingredient("corn", 3)}, RECIPETABS.FARM,  TECH.MAGIC_TWO, "mandrake_planted_placer", --曼德拉草
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/mandrake_planted.xml",
		"mandrake_planted.tex")
	end
end
if Ccatcoonden ~= "disabled" then
    STRINGS.RECIPE_DESC.CATCOONDEN = "A cat's home."
	if Ccatcoonden == "enabled" then
		AddRecipe("catcoonden", {Ingredient("log", 4),Ingredient("twigs", 4)}, RECIPETABS.TOWN, TECH.SCIENCE_ONE, "catcoonden_placer", --猫窝_22
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/catcoonden.xml",
		"catcoonden.tex")
	end
end
if Cwalruscamp ~= "disabled" then
    STRINGS.RECIPE_DESC.WALRUS_CAMP = "There lived a walrus and his son."
	if Cwalruscamp == "enabled" then
		AddRecipe("walrus_camp", {Ingredient("ice", 8),Ingredient("houndstooth", 4),Ingredient("bluegem", 3)}, RECIPETABS.TOWN, TECH.SCIENCE_ONE, "walrus_camp_placer", --海象巢穴
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/walrus_camp.xml",
		"walrus_camp.tex")
	end
end
if Cancientaltar ~= "disabled" then
	STRINGS.RECIPE_DESC.ANCIENT_ALTAR_BROKEN = "Unlock more technology."
	STRINGS.RECIPE_DESC.ANCIENT_ALTAR = "Unlock more technology."
	if Cancientaltar == "altar broken" then
		AddRecipe("ancient_altar_broken", {Ingredient("moonrocknugget", 4),Ingredient("purplegem", 2),Ingredient("thulecite_pieces", 6)}, RECIPETABS.SCIENCE, TECH.MAGIC_THREE, "ancient_altar_broken_placer", --损坏的远古遗迹
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/ancient_altar_broken.xml",
		"ancient_altar_broken.tex")
		else
		if Cancientaltar == "ancient altar" then
		AddRecipe("ancient_altar", {Ingredient("moonrocknugget", 6),Ingredient("purplegem", 4),Ingredient("thulecite", 2)}, RECIPETABS.SCIENCE, TECH.MAGIC_THREE, "ancient_altar_placer", --远古遗迹
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/ancient_altar.xml",
		"ancient_altar.tex")
		end
	end
end
if Cpond ~= "disabled" then
    STRINGS.RECIPE_DESC.POND = "just a pond"
	STRINGS.RECIPE_DESC.POND_MOS = "just a pond"
	STRINGS.RECIPE_DESC.LAVA_POND = "Hot pond"
	STRINGS.RECIPE_DESC.POND_CAVE = "just a pond"
	if Cpond == "enabled" then
		AddRecipe("pond", {Ingredient("pondfish", 8),Ingredient("fishingrod", 1),Ingredient("froglegs", 4)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, "pond_placer", --池塘
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/pond.xml",
		"pond.tex")
		AddRecipe("pond_mos", {Ingredient("pondfish", 8),Ingredient("fishingrod", 1),Ingredient("mosquito", 4)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, "pond_mos_placer", --沼泽池塘
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/pond_mos.xml",
		"pond_mos.tex")
		AddRecipe("lava_pond", {Ingredient("ash", 8),Ingredient("heatrock", 1),Ingredient("charcoal", 4)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, "lava_pond_placer", --岩浆
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/lava_pond.xml",
		"lava_pond.tex")
		AddRecipe("pond_cave", {Ingredient("pondeel", 8),Ingredient("fishingrod", 1),Ingredient("cutgrass", 4)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, "pond_cave_placer", --地下池塘
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/pond_cave.xml",
		"pond_cave.tex")
	end
end
if Cmermhouse ~= "disabled" then
    STRINGS.RECIPE_DESC.MERMHOUSE = "Fish house."
	if Cmermhouse == "enabled" then
		AddRecipe("mermhouse", {Ingredient("pondfish", 4),Ingredient("rocks", 1),Ingredient("boards", 2)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, "mermhouse_placer", --鱼人房_111
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/mermhouse.xml",
		"mermhouse.tex")
	end
end
if Cresurrectionstone ~= "disabled" then
    STRINGS.RECIPE_DESC.RESURRECTIONSTONE = "resurrection."
	if Cresurrectionstone == "enabled" then
		AddRecipe("resurrectionstone", {Ingredient("decrease_health", 60),Ingredient("rocks", 2),Ingredient("nightmarefuel", 1),Ingredient("marble", 2)}, RECIPETABS.SURVIVAL, TECH.MAGIC_THREE, "resurrectionstone_placer", --试金石_212
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/resurrectionstone.xml",
		"resurrectionstone.tex")
	end
end
if Cbeehive ~= "disabled" then
    STRINGS.RECIPE_DESC.BEEHIVE = "Swarm of bees."
	if Cbeehive == "enabled" then
		AddRecipe("beehive", {Ingredient("honeycomb", 1),Ingredient("honey", 3)}, RECIPETABS.TOWN, TECH.MAGIC_TWO, "beehive_placer", --蜂窝_13
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/beehive.xml",
		"beehive.tex")
	end
end
if Cwasphive ~= "disabled" then
    STRINGS.RECIPE_DESC.WASPHIVE = "Swarm of killer bees."
	if Cwasphive == "enabled" then
		AddRecipe("wasphive", {Ingredient("honeycomb", 1),Ingredient("honey", 3)}, RECIPETABS.TOWN, TECH.MAGIC_TWO, "wasphive_placer", --杀人蜂窝_13
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/wasphive.xml",
		"wasphive.tex")
	end
end
if Cspiderhole ~= "disabled" then
    STRINGS.RECIPE_DESC.SPIDERHOLE = "Underground spider nest."
	if Cspiderhole == "enabled" then
		AddRecipe("spiderhole", {Ingredient("spidergland", 2),Ingredient("silk", 2),Ingredient("rocks", 4)}, RECIPETABS.TOWN, TECH.MAGIC_TWO, "spiderhole_placer", --地下蜘蛛洞_25% 25% 2 1fossil_piece
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/spiderhole.xml",
		"spiderhole.tex")
	end
end
if Cslurtlehole ~= "disabled" then
    STRINGS.RECIPE_DESC.SLURTLEHOLE = "Snail nest."
	if Cslurtlehole == "enabled" then
		AddRecipe("slurtlehole", {Ingredient("slurtleslime", 3),Ingredient("slurtle_shellpieces", 1)}, RECIPETABS.TOWN, TECH.MAGIC_TWO, "slurtlehole_placer", --蜗牛窝_31
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/slurtlehole.xml",
		"slurtlehole.tex")
	end
end
if Cbatcave ~= "disabled" then
    STRINGS.RECIPE_DESC.BATCAVE = "Nasty guy."
	if Cbatcave == "enabled" then
		AddRecipe("batcave", {Ingredient("batwing", 2),Ingredient("guano", 3),Ingredient("rocks", 4)}, RECIPETABS.TOWN, TECH.MAGIC_TWO, "batcave_placer", --蝙蝠洞
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/batcave.xml",
		"batcave.tex")
	end
end
if Cmonkeybarrel ~= "disabled" then
    STRINGS.RECIPE_DESC.MONKEYBARREL = "Monkey stay."
	if Cmonkeybarrel == "enabled" then
		AddRecipe("monkeybarrel", {Ingredient("cave_banana", 2),Ingredient("poop", 2)}, RECIPETABS.TOWN, TECH.MAGIC_TWO, "monkeybarrel_placer", --猴子桶_22 1%trinket_13
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/monkeybarrel.xml",
		"monkeybarrel.tex")
	end
end
if Ctallbirdnest ~= "disabled" then
    STRINGS.RECIPE_DESC.TALLBIRDNEST = "A long-legged bird's nest."
	if Ctallbirdnest == "enabled" then
		AddRecipe("tallbirdnest", {Ingredient("tallbirdegg", 1),Ingredient("cutgrass", 5),Ingredient("meat", 3)}, RECIPETABS.SURVIVAL, TECH.MAGIC_TWO, "tallbirdnest_placer", --高脚鸟窝
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/tallbirdnest.xml",
		"tallbirdnest.tex")
	end
end
if Choundmound ~= "disabled" then
    STRINGS.RECIPE_DESC.HOUNDMOUND = "Hound's birthplace."
	if Choundmound == "enabled" then
		AddRecipe("houndmound", {Ingredient("redgem", 1),Ingredient("bluegem", 1),Ingredient("houndstooth", 1)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, "houndmound_placer", --猎犬丘_1%1%3
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/houndmound.xml",
		"houndmound.tex")
	end
end
if Ccavebananatree ~= "disabled" then
    STRINGS.RECIPE_DESC.CAVE_BANANA_TREE = "Banana."
	if Ccavebananatree == "enabled" then
		AddRecipe("cave_banana_tree", {Ingredient("cave_banana", 2),Ingredient("twigs", 3),Ingredient("log", 2)}, RECIPETABS.SURVIVAL, TECH.MAGIC_TWO, "cave_banana_tree_placer", --香蕉树_122
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/cave_banana_tree.xml",
		"cave_banana_tree.tex")
	end
end
if Cstatueglommer ~= "disabled" then
    STRINGS.RECIPE_DESC.STATUEGLOMMER = "Strange statue."
	if Cstatueglommer == "enabled" then
		AddRecipe("statueglommer", {Ingredient("marble", 4)}, RECIPETABS.TOWN, TECH.MAGIC_THREE, "statueglommer_placer", --格罗姆雕像_3
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/statueglommer.xml",
		"statueglommer.tex")
	end
end
if Cbabybeefalo ~= "disabled" then
    STRINGS.RECIPE_DESC.BABYBEEFALO = "baby beefalo."
	if Cbabybeefalo == "enabled" then
		AddRecipe("babybeefalo", {Ingredient("beefalowool", 1),Ingredient("smallmeat", 2)}, RECIPETABS.FARM, TECH.MAGIC_TWO, "babybeefalo_placer", --牛宝宝_13
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/babybeefalo.xml",
		"babybeefalo.tex")
	end
end
if Csinkholesandstairs ~= "disabled" then
    STRINGS.RECIPE_DESC.CAVE_ENTRANCE_OPEN = "The entrance to the cave."
	STRINGS.RECIPE_DESC.CAVE_EXIT = "Exit the cave."
	if Csinkholesandstairs == "enabled" then
		AddRecipe("cave_entrance_open", {Ingredient("flint", 4),Ingredient("rocks", 3)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, "cave_entrance_open_placer", --落水洞
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/cave_entrance_open.xml",
		"cave_entrance_open.tex")
		AddRecipe("cave_exit", {Ingredient("flint", 8),Ingredient("rocks", 6)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, "cave_exit_placer", --洞穴出口
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/cave_exit.xml",
		"cave_exit.tex")
	end
end
if Cwormlightplant ~= "disabled" then
    STRINGS.RECIPE_DESC.WORMLIGHT_PLANT = "Strange plant."
	if Cwormlightplant == "enabled" then
		AddRecipe("wormlight_plant", {Ingredient("wormlight_lesser", 2),Ingredient("lightbulb", 4)}, RECIPETABS.SURVIVAL, TECH.MAGIC_TWO, "wormlight_plant_placer", --小发光浆果树
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/wormlight_plant.xml",
		"wormlight_plant.tex")
	end
end
if Cflowercave ~= "disabled" then
    GLOBAL.STRINGS.NAMES.FLOWER_CAVE_DOUBLE = "Light Flower"
	GLOBAL.STRINGS.NAMES.FLOWER_CAVE_TRIPLE = "Light Flower"
	STRINGS.RECIPE_DESC.FLOWER_CAVE = "It can give me light."
	STRINGS.RECIPE_DESC.FLOWER_CAVE_DOUBLE = "It can give me light."
	STRINGS.RECIPE_DESC.FLOWER_CAVE_TRIPLE = "It can give me light."
	if Cflowercave == "enabled" then
		AddRecipe("flower_cave", {Ingredient("lightbulb", 2),Ingredient("cutreeds", 1),Ingredient("cutgrass", 1)}, RECIPETABS.SURVIVAL, TECH.MAGIC_TWO, "flower_cave_placer", --荧光草1
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/flower_cave.xml",
		"flower_cave.tex")
		AddRecipe("flower_cave_double", {Ingredient("lightbulb", 4),Ingredient("cutreeds", 2),Ingredient("cutgrass", 2)}, RECIPETABS.SURVIVAL, TECH.MAGIC_TWO, "flower_cave_double_placer", --荧光草2
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/flower_cave_double.xml",
		"flower_cave_double.tex")
		AddRecipe("flower_cave_triple", {Ingredient("lightbulb", 6),Ingredient("cutreeds", 3),Ingredient("cutgrass", 3)}, RECIPETABS.SURVIVAL, TECH.MAGIC_TWO, "flower_cave_triple_placer", --荧光草3
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/flower_cave_triple.xml",
		"flower_cave_triple.tex")
	end
end
if Ccactus ~= "disabled" then
    STRINGS.RECIPE_DESC.CACTUS = "Rude plants."
	if Ccactus == "enabled" then
		AddRecipe("cactus", {Ingredient("cactus_meat", 3),Ingredient("cactus_flower", 3)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, "cactus_placer", --仙人球
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/cactus.xml",
		"cactus.tex")
	end
end
if Coasiscactus ~= "disabled" then
    GLOBAL.STRINGS.NAMES.OASIS_CACTUS = "Oasis Cactus"
    STRINGS.RECIPE_DESC.OASIS_CACTUS = "Rude plants."
	if Coasiscactus == "enabled" then
		AddRecipe("oasis_cactus", {Ingredient("cactus_meat", 3),Ingredient("cactus_flower", 3)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, "oasis_cactus_placer", --仙人掌
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/oasis_cactus.xml",
		"oasis_cactus.tex")
	end
end
if Creeds ~= "disabled" then
    STRINGS.RECIPE_DESC.REEDS = "What it can do."
	if Creeds == "enabled" then
		AddRecipe("reeds", {Ingredient("cutreeds", 3),Ingredient("cutgrass", 4)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, "reeds_placer", --芦苇
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/reeds.xml",
		"reeds.tex")
	end
end
if Cklaussack ~= "disabled" then
    STRINGS.RECIPE_DESC.KLAUS_SACK = "Come again a spree."
	if Cklaussack == "enabled" then
		AddRecipe("klaus_sack", {Ingredient("charcoal", 12),Ingredient("boneshard", 20)}, RECIPETABS.SURVIVAL, TECH.MAGIC_TWO, "klaus_sack_placer", --精确补给
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/klaus_sack.xml",
		"klaus_sack.tex")
	end
end
if Csacredchest ~= "disabled" then
    STRINGS.RECIPE_DESC.SACRED_CHEST = "Magical box."
	if Csacredchest == "enabled" then
		AddRecipe("sacred_chest", {Ingredient("thulecite_pieces", 4),Ingredient("nightmarefuel", 4)}, RECIPETABS.TOWN, TECH.MAGIC_TWO, "sacred_chest_placer", --远古箱子
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/sacred_chest.xml",
		"sacred_chest.tex")
	end
end
if Crabbithole ~= "disabled" then
    STRINGS.RECIPE_DESC.RABBITHOLE = "A small animal's burrow."
	if Crabbithole == "enabled" then
		AddRecipe("rabbithole", {Ingredient("rabbit", 1)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_ONE, "rabbithole_placer", --兔子洞
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/rabbithole.xml",
		"rabbithole.tex")
	end
end
if Cpigtorch ~= "disabled" then
    STRINGS.RECIPE_DESC.PIGTORCH = "Light the torch."
	if Cpigtorch == "enabled" then
		AddRecipe("pigtorch", {Ingredient("log", 3), Ingredient("poop", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_ONE, "pigtorch_placer", --猪人火炬
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/pigtorch.xml",
		"pigtorch.tex")
	end
end
if Coasislake ~= "disabled" then
    STRINGS.RECIPE_DESC.OASISLAKE = "A lake."
	if Coasislake == "enabled" then
		AddRecipe("oasislake", {Ingredient("pondfish", 4), Ingredient("wetpouch", 4), Ingredient("fireflies", 4)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, "oasislake_placer", --湖泊
		nil,
		nil,
		nil,
		nil,
		"images/inventoryimages/oasislake.xml",
		"oasislake.tex")
	end
end

end
end
