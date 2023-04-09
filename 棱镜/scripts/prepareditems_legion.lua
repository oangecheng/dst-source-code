require("constants")
local cookbookui_legion = require "widgets/cookbookui_legion"

------

local foods_legion = {
    dish_tomahawksteak = {
        test = function(cooker, names, tags)
            return names.horn and names.mint_l and (names.garlic or names.garlic_cooked)
                and (tags.meat and tags.meat >= 1)
        end,
        priority = 20,
        perishtime = TUNING.PERISH_MED, --10天
        -- cookpot_perishtime = 0, --在烹饪锅上的新鲜度时间，能替换perishtime
        cooktime = 1.75, --【Tip】基础时间20秒，最终用时= cooktime*20
        potlevel = "low",
        overridebuild = "dish_tomahawksteak", --替换料理build，这样所有料理都可以共享一个build了
        overridesymbolname = "base", --替换烹饪锅的料理贴图的symbol
        oneat_desc = STRINGS.UI.COOKBOOK.DISH_TOMAHAWKSTEAK,
        notinitprefab = true, --兼容勋章的机制，此配方，不以通用方式生成预制物

        cook_need = "牛角 猫薄荷 (烤)大蒜 肉度≥1",
        cook_cant = nil,
        recipe_count = 4,

        --这一截是不起效的代码
        float = { nil, "small", 0.2, 0.75 },
        foodtype = FOODTYPE.MEAT,
        -- secondaryfoodtype = nil,
        health = 0,
        hunger = 0,
        sanity = 0,
    },

	--[[
        CALORIES_TINY = calories_per_day/8, -- berries --9.375
        CALORIES_SMALL = calories_per_day/6, -- veggies --12.5
        CALORIES_MEDSMALL = calories_per_day/4, --18.75
        CALORIES_MED = calories_per_day/3, -- meat --25
        CALORIES_LARGE = calories_per_day/2, -- cooked meat --37.5
        CALORIES_HUGE = calories_per_day, -- crockpot foods? --75
        CALORIES_SUPERHUGE = calories_per_day*2, -- crockpot foods? --150

        HEALING_TINY = 1,
        HEALING_SMALL = 3,
        HEALING_MEDSMALL = 8,
        HEALING_MED = 20,
        HEALING_MEDLARGE = 30,
        HEALING_LARGE = 40,
        HEALING_HUGE = 60,
        HEALING_SUPERHUGE = 100,

        SANITY_SUPERTINY = 1,
        SANITY_TINY = 5,
        SANITY_SMALL = 10,
        SANITY_MED = 15,
        SANITY_MEDLARGE = 20,
        SANITY_LARGE = 33,
        SANITY_HUGE = 50,

        PERISH_ONE_DAY = 1*total_day_time*perish_warp, --1天
        PERISH_TWO_DAY = 2*total_day_time*perish_warp, --2天
        PERISH_SUPERFAST = 3*total_day_time*perish_warp,
        PERISH_FAST = 6*total_day_time*perish_warp,
        PERISH_FASTISH = 8*total_day_time*perish_warp,
        PERISH_MED = 10*total_day_time*perish_warp,
        PERISH_SLOW = 15*total_day_time*perish_warp,
        PERISH_PRESERVED = 20*total_day_time*perish_warp,
        PERISH_SUPERSLOW = 40*total_day_time*perish_warp, --40天
	]]--
}

------
------

if CONFIGS_LEGION.BETTERCOOKBOOK then
    for k,v in pairs(foods_legion) do
        v.name = k
        v.weight = v.weight or 1
        v.priority = v.priority or 0
        if v.overridebuild == nil then
            v.overridebuild = "dishes_legion"
        end

        -- v.cookbook_category = "portablecookpot" --如果要设置为便携烹饪锅专属，可以写这个
        -- v.cookbook_category = "cookpot"
        -- v.cookbook_category = "mod" --官方在AddCookerRecipe时就设置好了，所以，cookbook_category字段不需要自己写
        v.recipe_count = v.recipe_count or 1
        v.custom_cookbook_details_fn = function(data, self, top, left) --不用给英语环境的使用这个，因为文本太长，不可能装得下
            local root = cookbookui_legion(data, self, top, left)
            return root
        end
    end
else
    for k,v in pairs(foods_legion) do
        v.name = k
        v.weight = v.weight or 1
        v.priority = v.priority or 0
        if v.overridebuild == nil then
            v.overridebuild = "dishes_legion"
        end
    end
end

return foods_legion
