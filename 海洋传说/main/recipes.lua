
AddRecipeFilter({
	name = "LG_TEACH",
	atlas = "images/tab/lg_tech.xml",
	image = "lg_tech.tex"
})

AddRecipe2("rain_flower_stone",
{Ingredient("petals", 2),Ingredient("ice", 3),Ingredient("rocks", 4),},
TECH.SCIENCE_TWO,{image = "rain_flower_stone.tex",atlas = "images/inventoryimages/rain_flower_stone.xml",},
{"REFINE"})

AddRecipe2("lg_sculpture",
{Ingredient("rain_flower_stone", 5,"images/inventoryimages/rain_flower_stone.xml"),Ingredient("moonrocknugget", 5),Ingredient("bluegem", 3),},
TECH.SCIENCE_TWO,{placer = "lg_sculpture_placer",image = "lg_sculpture.tex",atlas = "images/inventoryimages/lg_sculpture.xml",},
{"PROTOTYPERS"})

AddRecipe2("lg_granary",
{Ingredient("rain_flower_stone", 5,"images/inventoryimages/rain_flower_stone.xml"),Ingredient("cutreeds", 10),Ingredient("boards", 5),},
TECH.SCIENCE_TWO,{placer = "lg_granary_placer",min_spacing = 3 ,image = "lg_granary.tex",atlas = "images/inventoryimages/lg_granary.xml",},
{"GARDENING"})

AddRecipe2("lg_king_mace",
{Ingredient("rain_flower_stone", 5,"images/inventoryimages/rain_flower_stone.xml"),Ingredient("yellowgem", 2),Ingredient("walrus_tusk", 1),},
TECH.LG_TECH_ONE,{image = "lg_king_mace.tex",atlas = "images/inventoryimages/lg_king_mace.xml",},
{"LG_TEACH"})

AddRecipe2("lg_blade",
{Ingredient("rain_flower_stone", 4,"images/inventoryimages/rain_flower_stone.xml"),Ingredient("bluegem", 3)},
TECH.LG_TECH_ONE,{image = "lg_blade.tex",atlas = "images/inventoryimages/lg_blade.xml",},
{"LG_TEACH"})

AddRecipe2("lg_fruit_rack",
{Ingredient("twigs", 6),Ingredient("cutreeds", 6),Ingredient("rope", 3),},
TECH.SCIENCE_TWO,{placer = "lg_fruit_rack_placer",min_spacing = 3 ,image = "lg_fruit_rack.tex",atlas = "images/inventoryimages/lg_fruit_rack.xml",},
{"GARDENING"})
