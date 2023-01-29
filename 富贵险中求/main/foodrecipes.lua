AddIngredientValues({"ndnr_coconut", "cutreeds", "furtuft", "ndnr_snake", "ndnr_catpoop", "ash", "ndnr_soybeanmeal"}, {inedible = 1})
AddIngredientValues({"ndnr_milk", "ndnr_ice_milk"}, {dairy = 1})
-- AddIngredientValues({"ndnr_milk_cooked", "ndnr_ice_milk_cooked"}, {dairy = 1})
AddIngredientValues({"lavae_egg"}, {egg = 4})
AddIngredientValues({"ndnr_dragoonheart"}, {meat = 1})
AddIngredientValues({"ndnr_coffeebeans"}, {fruit = .5}, true)
AddIngredientValues({"ndnr_coffeebeans_cooked"}, {fruit = 1})
AddIngredientValues({"ndnr_sharkfin"}, {meat = 1, fish=1}, true)
AddIngredientValues({"ndnr_coconut_halved"}, {fruit=1,fat=1}, true)
AddIngredientValues({"ndnr_coconut_cooked"}, {fruit=1,fat=1})
AddIngredientValues({"wobster_moonglass_land"}, {meat=1.0, fish=1.0})
AddIngredientValues({"ndnr_scallop"}, {meat=0.5, fish=0.5}, true)
AddIngredientValues({"ndnr_scallop_cooked"}, {meat=0.5, fish=0.5})
AddIngredientValues({"tallbirdegg_cracked"}, {egg=4.0, meat=0.5}, true)
AddIngredientValues({"ndnr_soybean"}, {veggie=1, ndnr_soybean=1})

---------------------------------------------------------------------------------
local roe_cooking = {}
for k, v in pairs(require("prefabs/oceanfishdef").fish) do
    table.insert(roe_cooking, "ndnr_roe_"..v.prefab)
end
AddIngredientValues(roe_cooking, {meat=0.5,fish=1,ndnr_roe=1}, true)
AddIngredientValues({"ndnr_roe_cooked"}, {meat=0.5,fish=1,ndnr_roe=1})

---------------------------------------------------------------------------------

for k, v in pairs(require("preparedfoods")) do
    for k1, v1 in pairs(TUNING.NDNR_GOUT_FOODS) do
        if k == k1 then
            v.oneat_desc = STRINGS.UI.COOKBOOK.NDNR_SEATREASURE
        end
    end
end

for k, v in pairs(require("ndnr_preparedfoods")) do
    AddCookerRecipe("cookpot", v)
    AddCookerRecipe("archive_cookpot", v)
    AddCookerRecipe("portablecookpot", v)
    if v.notinitprefab == nil then
        RegisterInventoryItemAtlas("images/"..v.name..".xml", v.name..".tex")
    end
end

local foodorigin = {
    "ndnr_coconut",
    "ndnr_snake",
    "ndnr_milk",
    "ndnr_ice_milk",
    "ndnr_dragoonheart",
    "ndnr_coffeebeans",
    "ndnr_coffeebeans_cooked",
    "ndnr_sharkfin",
    "ndnr_coconut_halved",
    "ndnr_coconut_cooked",
    "ndnr_catpoop",
    "ndnr_scallop",
    "ndnr_scallop_cooked",
    "ndnr_roe_cooked",
    ------------------------------------------------
    "ndnr_soybean_seeds",
    "ndnr_soybean",
    "ndnr_soybeanmeal",
}

for k, v in pairs(require("prefabs/oceanfishdef").fish) do
    RegisterInventoryItemAtlas("images/ndnr_roe_"..v.prefab..".xml", "ndnr_roe_"..v.prefab..".tex")
end
for i, v in ipairs(foodorigin) do
    RegisterInventoryItemAtlas("images/"..v..".xml", v..".tex")
end

local ndnr_spicedfoods = require("ndnr_spicedfoods")
for k, v in pairs(ndnr_spicedfoods) do
    AddCookerRecipe("portablespicer", v)
end

if AddFoodTag ~= nil then
    AddFoodTag("ndnr_roe", { name="Roe", atlas="images/ndnr_roe.xml" })
    AddFoodTag("ndnr_soybean", { name="SoyBean", atlas="images/ndnr_soybean.xml" })
end

local IsModCookingProduct_old = GLOBAL.IsModCookingProduct
GLOBAL.IsModCookingProduct = function(cooker, name)
    if ndnr_spicedfoods[name] ~= nil then
        return false
    end
    if IsModCookingProduct_old ~= nil then
        return IsModCookingProduct_old(cooker, name)
    end
    return false
end
