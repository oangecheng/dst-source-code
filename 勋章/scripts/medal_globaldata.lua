if GLOBAL.TOOLACTIONS then
	GLOBAL.TOOLACTIONS["MEDALTRANSPLANT"] = true--定义月光移植动作
	GLOBAL.TOOLACTIONS["MEDALNORMALTRANSPLANT"] = true--定义普通移植动作
	GLOBAL.TOOLACTIONS["MEDALHAMMER"] = true--定义月光锤动作
end

if TUNING.WOLFGANG_MIGHTINESS_WORK_GAIN then--大力士使用月光工具也能加力量
	TUNING.WOLFGANG_MIGHTINESS_WORK_GAIN.MEDALTRANSPLANT = 2
	TUNING.WOLFGANG_MIGHTINESS_WORK_GAIN.MEDALNORMALTRANSPLANT = 2
	TUNING.WOLFGANG_MIGHTINESS_WORK_GAIN.MEDALHAMMER = 0.25
end

local function MedalIngredient(ingredienttype,amount)
	local atlas=resolvefilepath_soft("images/"..ingredienttype..".xml")
	return Ingredient(ingredienttype,amount,atlas)
end

if GLOBAL.CONSTRUCTION_PLANS then
	--凋零蜂巢升级材料
	GLOBAL.CONSTRUCTION_PLANS["medal_rose_terrace"]={ Ingredient("sewing_tape", 6),Ingredient("reviver", 1),Ingredient("honeycomb", 3),Ingredient("royal_jelly", 6)}
	--熊皮宝箱废墟
	GLOBAL.CONSTRUCTION_PLANS["collapsed_bearger_chest"] =	TUNING.IS_LOW_COST and {
		Ingredient("bearger_fur", 1), Ingredient("bundlewrap", 4),MedalIngredient("immortal_essence", 3),MedalIngredient("medal_space_gem", 1),
	} or {
		Ingredient("bearger_fur", 1), Ingredient("bundlewrap", 8),MedalIngredient("immortal_essence", 6),MedalIngredient("medal_space_gem", 1),
	}
end

--时空风暴类型定义
if GLOBAL.STORM_TYPES then
	local idx = GetTableSize(GLOBAL.STORM_TYPES)
	GLOBAL.STORM_TYPES["MEDAL_SPACETIMESTORM"] = idx
else
	GLOBAL.STORM_TYPES=
	{
		NONE = 0,
		SANDSTORM = 1,
		MOONSTORM = 2,
		MEDAL_SPACETIMESTORM = 3,
	}
end
if GLOBAL.NAUGHTY_VALUE then
	GLOBAL.NAUGHTY_VALUE.medal_dustmoth = 4--打死时空尘蛾加淘气值
end

--勋章箱子升级标签
if GLOBAL.UPGRADETYPES then
	GLOBAL.UPGRADETYPES.MEDAL_CHEST = "medal_chest"
end