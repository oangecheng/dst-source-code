-- 代码作者：ti_Tout

local _G = GLOBAL

--------------------------------------------------------------------------
--[[ 修改默认的科技树生成方式 ]]
--------------------------------------------------------------------------

local TechTree = require("techtree")

table.insert(TechTree.AVAILABLE_TECH, "ELECOURMALINE")	--其实就是加个自己的科技树名称

TechTree.Create = function(t)
	t = t or {}
	for i, v in ipairs(TechTree.AVAILABLE_TECH) do
	    t[v] = t[v] or 0
	end
	return t
end

--------------------------------------------------------------------------
--[[ 新制作栏兼容 ]]
--------------------------------------------------------------------------

AddPrototyperDef("elecourmaline", { --第一个参数是指玩家靠近时会解锁科技的prefab名
	icon_atlas = "images/station_recast.xml", icon_image = "station_recast.tex",
	is_crafting_station = true,
	action_str = "RECAST", --台词已在语言文件中
	filter_text = STRINGS.UI.CRAFTING_STATION_FILTERS.RECAST --台词已在语言文件中
})

AddRecipeFilter({
	name = "RECAST",
	atlas = "images/station_recast.xml", image = "station_recast.tex",
	custom_pos = true
})

--------------------------------------------------------------------------
--[[ 制作等级中加入自己的部分 ]]
--------------------------------------------------------------------------

_G.TECH.NONE.ELECOURMALINE = 0
_G.TECH.ELECOURMALINE_ONE = { ELECOURMALINE = 1 }
-- _G.TECH.ELECOURMALINE_TWO = { ELECOURMALINE = 2 }
_G.TECH.ELECOURMALINE_THREE = { ELECOURMALINE = 3 }

--------------------------------------------------------------------------
--[[ 解锁等级中加入自己的部分 ]]
--------------------------------------------------------------------------

for k,v in pairs(TUNING.PROTOTYPER_TREES) do
    v.ELECOURMALINE = 0
end

--ELECOURMALINE_ONE可以改成任意的名字，这里和TECH.ELECOURMALINE_ONE名字相同只是懒得改了
TUNING.PROTOTYPER_TREES.ELECOURMALINE_ONE = TechTree.Create({
    ELECOURMALINE = 1,
})
-- TUNING.PROTOTYPER_TREES.ELECOURMALINE_TWO = TechTree.Create({
--     ELECOURMALINE = 2,
-- })
TUNING.PROTOTYPER_TREES.ELECOURMALINE_THREE = TechTree.Create({
    ELECOURMALINE = 3,
})

--------------------------------------------------------------------------
--[[ 修改全部制作配方，对缺失的值进行补充 ]]
--------------------------------------------------------------------------

-- AddPrefabPostInit("player_classified", function(inst)
-- 	inst.techtrees = deepcopy(TECH.NONE)
-- end)

for i, v in pairs(AllRecipes) do
	if v.level.ELECOURMALINE == nil then
		v.level.ELECOURMALINE = 0
	end
end
