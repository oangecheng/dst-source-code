local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS

PLANT_DEFS.ndnr_soybean		= {data_only = false}

local function MakeGrowTimes(germination_min, germination_max, full_grow_min, full_grow_max)
	local grow_time = {}

	-- germination time
	grow_time.seed		= {germination_min, germination_max}

	-- grow time
	grow_time.sprout	= {full_grow_min * 0.5, full_grow_max * 0.5}
	grow_time.small		= {full_grow_min * 0.3, full_grow_max * 0.3}
	grow_time.med		= {full_grow_min * 0.2, full_grow_max * 0.2}

	-- harvestable perish time
	grow_time.full		= 4 * TUNING.TOTAL_DAY_TIME
	grow_time.oversized	= 6 * TUNING.TOTAL_DAY_TIME
	grow_time.regrow	= {4 * TUNING.TOTAL_DAY_TIME, 5 * TUNING.TOTAL_DAY_TIME} -- min, max

	return grow_time
end
														-- germination min / max						full grow time min / max (will be devided between the growth stages)
PLANT_DEFS.ndnr_soybean.grow_time				= MakeGrowTimes(12 * TUNING.SEG_TIME, 16 * TUNING.SEG_TIME,		4 * TUNING.TOTAL_DAY_TIME, 7 * TUNING.TOTAL_DAY_TIME)

-- moisture
local drink_low = TUNING.FARM_PLANT_DRINK_LOW
local drink_med = TUNING.FARM_PLANT_DRINK_MED
local drink_high = TUNING.FARM_PLANT_DRINK_HIGH

PLANT_DEFS.ndnr_soybean.moisture				= {drink_rate = drink_low, min_percent = TUNING.FARM_PLANT_DROUGHT_TOLERANCE}

-- season preferences
--
PLANT_DEFS.ndnr_soybean.good_seasons			= {autumn = true, summer = true}

-- Nutrients
local S = TUNING.FARM_PLANT_CONSUME_NUTRIENT_LOW
local M = TUNING.FARM_PLANT_CONSUME_NUTRIENT_MED
local L = TUNING.FARM_PLANT_CONSUME_NUTRIENT_HIGH

PLANT_DEFS.ndnr_soybean.nutrient_consumption			= {0, M, M}

for _, data in pairs(PLANT_DEFS) do
	data.nutrient_restoration = {}
	for i = 1, #data.nutrient_consumption do
		data.nutrient_restoration[i] = data.nutrient_consumption[i] == 0 or nil
	end
end

-- Killjoys
PLANT_DEFS.ndnr_soybean.max_killjoys_tolerance		= TUNING.FARM_PLANT_KILLJOY_TOLERANCE

-- Misc
-- PLANT_DEFS.dragonfruit.fireproof = true

-- Weight data							min			max			sigmoid%
PLANT_DEFS.ndnr_soybean.weight_data		= { 328.14,     455.31,     .22 }

PLANT_DEFS.ndnr_soybean.pictureframeanim = {anim = "emote_strikepose", time = 23*FRAMES}

-- Sounds
PLANT_DEFS.ndnr_soybean.sounds =
{
	grow_oversized = "farming/common/farm/tomato/grow_oversized",
	grow_full = "farming/common/farm/grow_full",
	grow_rot = "farming/common/farm/rot",
}

------------------------------------------------
for veggie, data in pairs(PLANT_DEFS) do
	data.prefab = "farm_plant_"..veggie

	if data.bank == nil then data.bank = "farm_plant_"..veggie end
	if data.build == nil then data.build = "farm_plant_"..veggie end

	-- data.swap_body_build = data.build.."_swap_body"
	-- data.swap_body_rotten_build = data.build.."_swap_body_rotten"

	if data.is_randomseed then
		data.seed = "seeds"
		data.plant_type_tag = "farm_plant_randomseed"
		data.family_min_count = 0
	else
		data.product = veggie
		data.product_oversized = veggie.."_oversized"
		data.seed = veggie.."_seeds"
		data.plant_type_tag = "farm_plant_"..veggie -- note: this is used for pollin_sources stress

		data.loot_oversized_rot = {"spoiled_food", "spoiled_food", "spoiled_food", data.seed, "fruitfly", "fruitfly"}

		-- all plants are going to use the same settings for now, maybe some will have special cases
		if data.family_min_count == nil then data.family_min_count = TUNING.FARM_PLANT_SAME_FAMILY_MIN end
		if data.family_check_dist == nil then data.family_check_dist = TUNING.FARM_PLANT_SAME_FAMILY_RADIUS end

		if data.stage_netvar == nil then
			data.stage_netvar = net_tinybyte
		end

		if data.plantregistryinfo == nil then
			data.plantregistryinfo = {
				{
					text = "seed",
					anim = "crop_seed",
					grow_anim = "grow_seed",
					learnseed = true,
					growing = true,
				},
				{
					text = "sprout",
					anim = "crop_sprout",
					grow_anim = "grow_sprout",
					growing = true,
				},
				{
					text = "small",
					anim = "crop_small",
					grow_anim = "grow_small",
					growing = true,
				},
				{
					text = "medium",
					anim = "crop_med",
					grow_anim = "grow_med",
					growing = true,
				},
				{
					text = "grown",
					anim = "crop_full",
					grow_anim = "grow_full",
					revealplantname = true,
					fullgrown = true,
				},
				{
					text = "oversized",
					anim = "crop_oversized",
					grow_anim = "grow_oversized",
					revealplantname = true,
					fullgrown = true,
					hidden = true,
				},
				{
					text = "rotting",
					anim = "crop_rot",
					grow_anim = "grow_rot",
					stagepriority = -100,
					is_rotten = true,
					hidden = true,
				},
				{
					text = "oversized_rotting",
					anim = "crop_rot_oversized",
					grow_anim = "grow_rot_oversized",
					stagepriority = -100,
					is_rotten = true,
					hidden = true,
				},
			}
		end
		if data.plantregistrywidget == nil then
			--the path to the widget
			data.plantregistrywidget = "widgets/redux/farmplantpage"
		end
		if data.plantregistrysummarywidget == nil then
			data.plantregistrysummarywidget = "widgets/redux/farmplantsummarywidget"
		end
		if data.pictureframeanim == nil then
			data.pictureframeanim = {anim = "emoteXL_happycheer", time = 0.5} --fallback data
		end
	end
end

-- setmetatable(PLANT_DEFS, {
-- 	__newindex = function(t, k, v)
-- 		v.modded = true
-- 		rawset(t, k, v)
-- 	end,
-- })


return {PLANT_DEFS = PLANT_DEFS}