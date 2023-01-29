
local TechTree = require("techtree")
table.insert(TechTree.AVAILABLE_TECH, "LG_TECH")
for k,v in pairs(TUNING.PROTOTYPER_TREES) do
    v.LG_TECH = 0
end
TUNING.PROTOTYPER_TREES.LG_TECH_ONE = TechTree.Create({LG_TECH = 2})
TUNING.PROTOTYPER_TREES.LG_TECH_TWO = TechTree.Create({LG_TECH = 4})
STRINGS.UI.CRAFTING.NEEDSLG_TECH_ONE = "靠近雨花石雕刻台制造一个原型！"
STRINGS.UI.CRAFTING.NEEDSLG_TECH_TWO = "靠近雨花石雕刻台制造一个原型！"
TECH.NONE.LG_TECH_ONE = 0
TECH.LG_TECH_ONE = {LG_TECH = 2}
TECH.LG_TECH_TWO = {LG_TECH = 4}
AddPrototyperDef("lg_sculpture", {
	icon_atlas = "images/tab/lg_sculpture.xml",
	icon_image = "lg_sculpture.tex",
	is_crafting_station = false,
})

AddSimPostInit(function()
	for i, v in pairs(AllRecipes) do
		if v.level.LG_TECH == nil then
			v.level.LG_TECH = 0
		end
	end
end)
