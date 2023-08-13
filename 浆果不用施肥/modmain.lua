TUNING.SUPERFERTILIZER_FERTILIZE = 300 * 6
TUNING.SUPERFERTILIZER_SOILCYCLES = 50
TUNING.SUPERFERTILIZER_WITHEREDCYCLES = 5

PrefabFiles = {
    "superfertilizer",
}

local STRINGS = GLOBAL.STRINGS
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH
local Ingredient = GLOBAL.Ingredient

STRINGS.NAMES.SUPERFERTILIZER = "Super Fertilizer"
STRINGS.RECIPE_DESC.SUPERFERTILIZER = "Never have to fertilize your plants again!"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SUPERFERTILIZER = "Deluxe food for plants."

if GetModConfigData("Recipe") == "caves" then
	AddRecipe("superfertilizer", {Ingredient("slurtle_shellpieces", 1), Ingredient("nitre", 1), Ingredient("guano", 2)}, RECIPETABS.FARM, TECH.SCIENCE_TWO, nil, nil, nil, GetModConfigData("Batch Size"), nil, "images/inventoryimages/superfertilizer.xml", "superfertilizer.tex")
else
	AddRecipe("superfertilizer", {Ingredient("ash", 4), Ingredient("nitre", 2), Ingredient("guano", 2)}, RECIPETABS.FARM, TECH.SCIENCE_TWO, nil, nil, nil, GetModConfigData("Batch Size"), nil, "images/inventoryimages/superfertilizer.xml", "superfertilizer.tex")
end

AddComponentPostInit("pickable", function(inst)
	local OldFertilize = inst.Fertilize
	inst.Fertilize = function(fertilizer, doer)
		OldFertilize(fertilizer, doer)
		if doer.components.superfert then
			inst.cycles_left = nil
			inst.transplanted = nil
		end
	end
end)