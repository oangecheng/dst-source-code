--[[
    “借鉴” 自 永不妥协
]]
-- STRINGS.UI.LOADING_SCREEN_NDNR_TIPS = {}
function setup_custom_loading_tips()

    -- LOADING_SCREEN_TIP_CATEGORIES["NDNR"] = 6

    for i,v in pairs(TUNING.NDNR_LOADINGTIPS) do
	    AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, v.id, v.tipstring[TUNING.NDNR_LANGUAGE])
    end
	local tipcategorystartweights =
	{
		CONTROLS = 0.2,
		SURVIVAL = 0.2,
		LORE = 0.2,
		LOADING_SCREEN = 0.2,
		OTHER = 0.2,
		-- NDNR = 0.2,
	}

	SetLoadingTipCategoryWeights(GLOBAL.LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_START, tipcategorystartweights)

	local tipcategoryendweights =
	{
		CONTROLS = 0,
		SURVIVAL = 0,
		LORE = 0,
		LOADING_SCREEN = 0,
		OTHER = 1,
		-- NDNR = 0.5,
	}
    --UM tips are guaranteed on the second tip during the loading screen.
	SetLoadingTipCategoryWeights(GLOBAL.LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_END, tipcategoryendweights)

	-- Loading tip icon
	-- SetLoadingTipCategoryIcon("OTHER", "images/loading_screen_icons.xml", "icon_survival.tex")

	GLOBAL.TheLoadingTips = require("loadingtipsdata")()

	-- Recalculate loading tip & category weights.
	local TheLoadingTips = GLOBAL.TheLoadingTips
	TheLoadingTips.loadingtipweights = TheLoadingTips:CalculateLoadingTipWeights()
    TheLoadingTips.categoryweights = TheLoadingTips:CalculateCategoryWeights()

	GLOBAL.TheLoadingTips:Load()
end

-- We need to call this directly instead of in AddGamePostInit() because the loading screen appears before calling that function.
setup_custom_loading_tips()









