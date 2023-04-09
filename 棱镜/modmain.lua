--------------------------------------------------------------------------
--[[ Update Logs ]]--[[ 更新说明 ]]
--------------------------------------------------------------------------

--[[

]]

--------------------------------------------------------------------------
--[[ Globals ]]--[[ 全局 ]]
--------------------------------------------------------------------------

--下行代码只代表查值时自动查global，增加global的变量或者修改global的变量时还是需要带"GLOBAL."
GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })
local _G = GLOBAL

--------------------------------------------------------------------------
--[[ Main ]]--[[ 主要 ]]
--------------------------------------------------------------------------

PrefabFiles = {
    "hat_lichen",               --苔衣发卡
    "backcub",                  --靠背熊
    "ingredients_legion",       --食材
    "plantables_legion",        --新种植根
    "turfs_legion",             --新地皮
    "wants_sandwitch",          --沙之女巫所欲之物
    -- "guitar_greenery",
    -- "aatest_anim",
    "fx_legion",                --特效
    "buffs_legion",             --buff
    "shield_legion",            --盾类武器
    "carpet_legion",            --地毯
    "foods_cookpot",            --料理
}

Assets = {
    Asset("ANIM", "anim/images_minisign1.zip"),  --专门为小木牌上的图画准备的文件(真是奢侈0.0)
    Asset("ANIM", "anim/images_minisign2.zip"),
    Asset("ANIM", "anim/images_minisign3.zip"),
    Asset("ANIM", "anim/images_minisign4.zip"),
    Asset("ANIM", "anim/images_minisign5.zip"),
    Asset("ANIM", "anim/images_minisign6.zip"),

    Asset("ANIM", "anim/playguitar.zip"),   --弹吉他动画模板
    Asset("SOUNDPACKAGE", "sound/legion.fev"),   --吉他的声音
    Asset("SOUND", "sound/legion.fsb"),

    --预加载，给科技栏用的
    Asset("ATLAS", "images/inventoryimages/hat_lichen.xml"),
    Asset("IMAGE", "images/inventoryimages/hat_lichen.tex"),

    --为工艺锅mod加的（此时并不明确是否启用了该mod）
    Asset("ATLAS", "images/foodtags/foodtag_gel.xml"),
    Asset("IMAGE", "images/foodtags/foodtag_gel.tex"),
    Asset("ATLAS", "images/foodtags/foodtag_petals.xml"),
    Asset("IMAGE", "images/foodtags/foodtag_petals.tex"),
    Asset("ATLAS", "images/foodtags/foodtag_fallfullmoon.xml"),
    Asset("IMAGE", "images/foodtags/foodtag_fallfullmoon.tex"),
    Asset("ATLAS", "images/foodtags/foodtag_winterfeast.xml"),
    Asset("IMAGE", "images/foodtags/foodtag_winterfeast.tex"),
    Asset("ATLAS", "images/foodtags/foodtag_hallowednights.xml"),
    Asset("IMAGE", "images/foodtags/foodtag_hallowednights.tex"),
    Asset("ATLAS", "images/foodtags/foodtag_newmoon.xml"),
    Asset("IMAGE", "images/foodtags/foodtag_newmoon.tex"),

    --为了在菜谱和农谱里显示材料的图片，所以不管玩家设置，还是要注册一遍
    Asset("ATLAS", "images/inventoryimages/monstrain_leaf.xml"),
    Asset("IMAGE", "images/inventoryimages/monstrain_leaf.tex"),
    Asset("ATLAS", "images/inventoryimages/shyerry.xml"),
    Asset("IMAGE", "images/inventoryimages/shyerry.tex"),
    Asset("ATLAS", "images/inventoryimages/shyerry_cooked.xml"),
    Asset("IMAGE", "images/inventoryimages/shyerry_cooked.tex"),
    Asset("ATLAS", "images/inventoryimages/petals_rose.xml"),
    Asset("IMAGE", "images/inventoryimages/petals_rose.tex"),
    Asset("ATLAS", "images/inventoryimages/petals_lily.xml"),
    Asset("IMAGE", "images/inventoryimages/petals_lily.tex"),
    Asset("ATLAS", "images/inventoryimages/petals_orchid.xml"),
    Asset("IMAGE", "images/inventoryimages/petals_orchid.tex"),
    Asset("ATLAS", "images/inventoryimages/pineananas.xml"),
    Asset("IMAGE", "images/inventoryimages/pineananas.tex"),
    Asset("ATLAS", "images/inventoryimages/pineananas_cooked.xml"),
    Asset("IMAGE", "images/inventoryimages/pineananas_cooked.tex"),
    Asset("ATLAS", "images/inventoryimages/pineananas_seeds.xml"),
    Asset("IMAGE", "images/inventoryimages/pineananas_seeds.tex"),
    Asset("ATLAS", "images/inventoryimages/mint_l.xml"),
    Asset("IMAGE", "images/inventoryimages/mint_l.tex"),
    Asset("ATLAS", "images/inventoryimages/albicans_cap.xml"),
    Asset("IMAGE", "images/inventoryimages/albicans_cap.tex"),
    Asset("ATLAS", "images/inventoryimages/shield_l_log.xml"),
    Asset("IMAGE", "images/inventoryimages/shield_l_log.tex"),
}

--为了在菜谱和农谱里显示材料的图片，所以不管玩家设置，还是要注册一遍
RegisterInventoryItemAtlas("images/inventoryimages/monstrain_leaf.xml", "monstrain_leaf.tex")
RegisterInventoryItemAtlas("images/inventoryimages/shyerry.xml", "shyerry.tex")
RegisterInventoryItemAtlas("images/inventoryimages/shyerry_cooked.xml", "shyerry_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/petals_rose.xml", "petals_rose.tex")
RegisterInventoryItemAtlas("images/inventoryimages/petals_lily.xml", "petals_lily.tex")
RegisterInventoryItemAtlas("images/inventoryimages/petals_orchid.xml", "petals_orchid.tex")
RegisterInventoryItemAtlas("images/inventoryimages/pineananas.xml", "pineananas.tex")
RegisterInventoryItemAtlas("images/inventoryimages/pineananas_cooked.xml", "pineananas_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/pineananas_seeds.xml", "pineananas_seeds.tex")
RegisterInventoryItemAtlas("images/inventoryimages/mint_l.xml", "mint_l.tex")
RegisterInventoryItemAtlas("images/inventoryimages/albicans_cap.xml", "albicans_cap.tex")

local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()

--------------------------------------------------------------------------
--[[ Test ]]--[[ test ]]
--------------------------------------------------------------------------

-- TheInput:AddKeyUpHandler(KEY_V, function()
--     ThePlayer.sg:GoToState("gosg")
-- end)

--------------------------------------------------------------------------
--[[ Options ]]--[[ 各项设置 ]]
--------------------------------------------------------------------------

_G.CONFIGS_LEGION = {
    ENABLEDMODS = {},
    PEPEPEPEPEY = false,
    FOOOODDDERY = false,
    RAINONMEEEY = false,
    GGGGRREEANY = false,
    THEFASTESTY = false,
    DUSTTODUSTY = false
}

_G.CONFIGS_LEGION.FLOWERWEAPONSCHANCE = GetModConfigData("FlowerWeaponsChance")
_G.CONFIGS_LEGION.FOLIAGEATHCHANCE = GetModConfigData("FoliageathChance")

_G.CONFIGS_LEGION.BETTERCOOKBOOK = false
_G.CONFIGS_LEGION.FESTIVALRECIPES = GetModConfigData("FestivalRecipes")

_G.CONFIGS_LEGION.BOOKRECIPETABS = GetModConfigData("BookRecipetabs") --设置多变的云的制作栏 "bookbuilder" "magic"
_G.CONFIGS_LEGION.HIDDENUPDATETIMES = GetModConfigData("HiddenUpdateTimes") --月藏宝匣最大升级次数
_G.CONFIGS_LEGION.REVOLVEDUPDATETIMES = GetModConfigData("RevolvedUpdateTimes") --月轮宝盘最大升级次数

-- TUNING.LEGION_GROWTHRATE = GetModConfigData("GrowthRate") --设置生长速度 int 0.7 1 1.5 2
-- TUNING.LEGION_CROPYIELDS = GetModConfigData("CropYields") --设置果实数量 int 0 1 2 3
_G.CONFIGS_LEGION.X_OVERRIPETIME = GetModConfigData("OverripeTime") --设置过熟的时间倍数 int 1 2 0
_G.CONFIGS_LEGION.X_PESTRISK = GetModConfigData("PestRisk") --设置虫害几率 double 0.007 0.012
_G.CONFIGS_LEGION.PHOENIXREBIRTHCYCLE = GetModConfigData("PhoenixRebirthCycle") --设置玄鸟重生时间
_G.CONFIGS_LEGION.SIVINGROOTTEX = GetModConfigData("SivingRootTex") --设置子圭突触贴图
_G.CONFIGS_LEGION.PHOENIXBATTLEDIFFICULTY = GetModConfigData("PhoenixBattleDifficulty") --设置玄鸟战斗难度
_G.CONFIGS_LEGION.SIVFEASTRENGTH = GetModConfigData("SivFeaStrength") --设置子圭·翰强度
_G.CONFIGS_LEGION.DIGESTEDITEMMSG = GetModConfigData("DigestedItemMsg") --巨食草消化提醒

_G.CONFIGS_LEGION.TECHUNLOCK = GetModConfigData("TechUnlock") --设置新道具的科技解锁方式 "lootdropper" "prototyper"

if GetModConfigData("DressUp") then --启用幻化机制 bool
    _G.CONFIGS_LEGION.DRESSUP = true
else
    _G.CONFIGS_LEGION.DRESSUP = false
end

_G.CONFIGS_LEGION.CLEANINGUPSTENCH = GetModConfigData("CleaningUpStench") --自动清除地上的臭臭 bool
_G.CONFIGS_LEGION.BACKCUBCHANCE = GetModConfigData("BackCubChance") --靠背熊掉落几率

----------
--语言设置
----------

local language_legion = GetModConfigData("Language")    --获取设置里"语言"的选项值

if language_legion == "english" then
    modimport("scripts/languages/strings_english.lua")
elseif language_legion == "chinese" then
    modimport("scripts/languages/strings_chinese.lua")

    _G.CONFIGS_LEGION.BETTERCOOKBOOK = GetModConfigData("BetterCookBook")
else
    modimport("scripts/languages/strings_english.lua")
end

--------------------------------------------------------------------------
--[[ hot reload ]]--[[ 热更新机制 ]]
--------------------------------------------------------------------------

-- modimport("scripts/hotreload_legion.lua")

--------------------------------------------------------------------------
--[[ compatibility enhancement ]]--[[ 兼容性修改 ]]
--------------------------------------------------------------------------

modimport("scripts/apublicsupporter.lua")
modimport("scripts/widgetcreation_legion.lua")

--------------------------------------------------------------------------
--[[ the power of flowers ]]--[[ 花香四溢 ]]
--------------------------------------------------------------------------

modimport("scripts/flowerspower_legion.lua")

--------------------------------------------------------------------------
--[[ superb cuisine ]]--[[ 美味佳肴 ]]
--------------------------------------------------------------------------

-- -- AddIngredientValues({"batwing"}, {meat=.5}, true, false) --蝙蝠翅膀，虽然可以晾晒，但是得到的不是蝙蝠翅膀干，而是小肉干，所以candry不能填true
-- AddIngredientValues({"ash"}, {inedible=1}, false, false) --灰烬
-- AddIngredientValues({"slurtleslime"}, {gel=1}, false, false) --蜗牛黏液
-- AddIngredientValues({"glommerfuel"}, {gel=1}, false, false) --格罗姆黏液
-- AddIngredientValues({"phlegm"}, {gel=1}, false, false) --钢羊黏痰
-- AddIngredientValues({"furtuft"}, {inedible=1}, false, false) --熊毛屑(非熊皮)
-- AddIngredientValues({"twiggy_nut"}, {inedible=1}, false, false) --添加树枝树种作为新的料理原材料
-- AddIngredientValues({"moon_tree_blossom"}, {veggie=.5, petals_legion=1}, false, false) --月树花
-- AddIngredientValues({"foliage"}, {decoration=1}, false, false) --蕨叶
-- AddIngredientValues({"horn"}, {inedible=1, decoration=2}, false, false) --牛角

for k, recipe in pairs(require("preparedfoods_legion")) do
    table.insert(Assets, Asset("ATLAS", "images/cookbookimages/"..recipe.name..".xml"))
    table.insert(Assets, Asset("IMAGE", "images/cookbookimages/"..recipe.name..".tex"))

    AddCookerRecipe("cookpot", recipe)
    AddCookerRecipe("portablecookpot", recipe)
    AddCookerRecipe("archive_cookpot", recipe)
    RegisterInventoryItemAtlas("images/cookbookimages/"..recipe.name..".xml", recipe.name..".tex")
end
for k, recipe in pairs(require("prepareditems_legion")) do
    table.insert(Assets, Asset("ATLAS", "images/cookbookimages/"..recipe.name..".xml"))
    table.insert(Assets, Asset("IMAGE", "images/cookbookimages/"..recipe.name..".tex"))

    AddCookerRecipe("cookpot", recipe)
    AddCookerRecipe("portablecookpot", recipe)
    AddCookerRecipe("archive_cookpot", recipe)
    RegisterInventoryItemAtlas("images/cookbookimages/"..recipe.name..".xml", recipe.name..".tex")
end

local foodrecipes_spice = require("preparedfoods_l_spiced")
for k, recipe in pairs(foodrecipes_spice) do
    AddCookerRecipe("portablespicer", recipe)
end
local itemrecipes_spice = require("prepareditems_l_spiced")
for k, recipe in pairs(itemrecipes_spice) do
    AddCookerRecipe("portablespicer", recipe)
end

--已经修复了，好耶！
--官方的便携香料站代码没改新机制，这里用另类方式手动改一下。等官方修复了我就删除。相关文件 prefabs\portablespicer.lua
-- local IsModCookingProduct_old = IsModCookingProduct
-- _G.IsModCookingProduct = function(cooker, name)
--     if foodrecipes_spice[name] ~= nil or itemrecipes_spice[name] ~= nil then
--         return false
--     end
--     if IsModCookingProduct_old ~= nil then
--         return IsModCookingProduct_old(cooker, name)
--     end
--     return false
-- end

--食谱中官方料理的修改
if CONFIGS_LEGION.BETTERCOOKBOOK then
    local cookbookui_legion = require("widgets/cookbookui_legion")
    local fooduidata_legion = require("languages/recipedesc_legion_chinese")

    local function SetNewCookBookUI(recipe, uidata)
        if uidata ~= nil then
            recipe.cook_need = uidata.cook_need
            recipe.cook_cant = uidata.cook_cant
            recipe.recipe_count = uidata.recipe_count or 1
            recipe.custom_cookbook_details_fn = function(data, self, top, left)
                local root = cookbookui_legion(data, self, top, left)
                return root
            end
        end
    end

    for k,v in pairs(require("preparedfoods")) do
        SetNewCookBookUI(v, fooduidata_legion.klei[k])
    end
    for k,v in pairs(require("preparedfoods_warly")) do
        SetNewCookBookUI(v, fooduidata_legion.warly[k])
    end
    for k,v in pairs(require("preparednonfoods")) do
        SetNewCookBookUI(v, fooduidata_legion.nofood[k])
    end
end

local cooking = require("cooking")
local ingredients_l = {
    { {"ash", "furtuft", "twiggy_nut"}, {inedible=1}, false, false }, --灰烬、熊毛屑(非熊皮)、树枝树种
    { {"slurtleslime", "glommerfuel", "phlegm"}, {gel=1}, false, false }, --蜗牛黏液、格罗姆黏液、钢羊黏痰
    { {"moon_tree_blossom"}, {veggie=.5, petals_legion=1}, false, false }, --月树花
    { {"foliage"}, {decoration=1}, false, false }, --蕨叶
    { {"horn"}, {inedible=1, decoration=2}, false, false }, --牛角
    { {"forgetmelots", "cactus_flower", "myth_lotus_flower", "aip_veggie_sunflower"}, {petals_legion=1}, false, false }, --必忘我、仙人掌花、【神话书说】莲花、【额外物品包】向日葵
    { {"reviver"}, {meat=1.5, magic=1}, false, false }, --告密的心

    { {"shyerry"}, {fruit=4}, true, false }, --颤栗果
    { {"albicans_cap"}, {veggie=2}, false, false }, --素白菇
    { {"petals_rose", "petals_lily", "petals_orchid"}, {veggie=.5, petals_legion=1}, false, false }, --三花
    { {"pineananas"}, {veggie=1, fruit=1}, true, false }, --松萝
    { {"mint_l"}, {veggie=.5}, false, false }, --猫薄荷
    { {"monstrain_leaf"}, {monster=1, veggie=.5}, false, false }, --雨竹叶
}
local ingredients_map = {}
for _,ing in ipairs(ingredients_l) do
    for _,name in pairs(ing[1]) do
        ingredients_map[name] = true
    end
end

--因为有的料理我只需要部分香料能调，兼容原因，其他香料制作时会崩溃，所以这里设置默认的返回值
local CalculateRecipe_old = cooking.CalculateRecipe
cooking.CalculateRecipe = function(cooker, names, ...)
    local product, cooktime = CalculateRecipe_old(cooker, names, ...)
    if product == nil then
        local count_name = 0
        local spice_name = nil
        for _,name in pairs(names) do
            if name then
                count_name = count_name + 1
                if spice_name == nil and string.sub(name, 1, 6) == "spice_" then
                    spice_name = name
                end
            end
        end
        if count_name == 2 then --香料站只有两格
            if spice_name and PrefabExists("wetgoop_"..spice_name) then
                product = "wetgoop_"..spice_name
            else
                product = "wetgoop_spice_chili" --实在不行，只能弄一个官方的了
            end
            cooktime = 0.12
        else --这个情况按理来说是不可能的，不过这里也完善吧
            product = "wetgoop"
            cooktime = 0.25
        end
    end
    return product, cooktime
end

--因为食材配置在 AddSimPostInit 时才会加入，所以得优化这个函数
local IsCookingIngredient_old = cooking.IsCookingIngredient
cooking.IsCookingIngredient = function(prefabname, ...)
    if ingredients_map[prefabname] then
        return true
    end
    return IsCookingIngredient_old(prefabname, ...)
end

--------------------------------------------------------------------------
--[[ desert secret ]]--[[ 尘市蜃楼 ]]
--------------------------------------------------------------------------

if CONFIGS_LEGION.DRESSUP then
    modimport("scripts/fengl_userdatahook.lua")
    modimport("scripts/dressup_legion.lua")
end
modimport("scripts/desertsecret_legion.lua")

--------------------------------------------------------------------------
--[[ the sacrifice of rain ]]--[[ 祈雨祭 ]]
--------------------------------------------------------------------------

modimport("scripts/prayforrain_legion.lua")

--------------------------------------------------------------------------
--[[ legends of the fall ]]--[[ 丰饶传说 ]]
--------------------------------------------------------------------------

modimport("scripts/legendoffall_legion.lua")

--------------------------------------------------------------------------
--[[ flash and crush ]]--[[ 电闪雷鸣 ]]
--------------------------------------------------------------------------

if _G.CONFIGS_LEGION.TECHUNLOCK == "prototyper" then
    modimport("scripts/new_techtree_legion.lua")    --新增制作栏的所需代码
end
modimport("scripts/flashandcrush_legion.lua")

--------------------------------------------------------------------------
--[[ other ]]--[[ 其他补充 ]]
--------------------------------------------------------------------------

_G.RegistMiniMapImage_legion("backcub")

AddRecipe2(
    "shield_l_log", {
        Ingredient("boards", 2),
        Ingredient("rope", 2),
    }, TECH.SCIENCE_ONE, {
        atlas = "images/inventoryimages/shield_l_log.xml", image = "shield_l_log.tex"
    }, { "WEAPONS", "ARMOUR" }
)

----------
--苔衣发卡的作用
----------

AddRecipe2(
    "hat_lichen", {
        Ingredient("lightbulb", 6),
        Ingredient("cutlichen", 4),
    }, TECH.NONE, {
        atlas = "images/inventoryimages/hat_lichen.xml", image = "hat_lichen.tex"
    }, { "CLOTHING", "LIGHT" }
)

if IsServer then
    AddPrefabPostInit("bunnyman", function(inst)    --通过api重写兔人的识别敌人函数
        local targetfn_old = inst.components.combat.targetfn
        inst.components.combat:SetRetargetFunction(3, function(inst)
            local target = targetfn_old(inst)
            if
                target == nil or
                (
                    not target:HasTag("monster") and --可不会保护怪物
                    (
                        (target.components.inventory ~= nil and target.components.inventory:EquipHasTag("ignoreMeat")) or
                        target:HasTag("ignoreMeat")
                    )
                )
            then
                return nil
            else
                return target
            end
        end)
    end)
end

----------
--增加新的周期性怪物
----------

-- AddPrefabPostInit("forest", function(inst)
--     if TheWorld.ismastersim then
--         local houndspawn =
--         {
--             base_prefab = "bishop",
--             winter_prefab = "killerbee",
--             summer_prefab = "killerbee",

--             attack_levels =
--             {
--                 intro   = { warnduration = function() return 120 end, numspawns = function() return 2 end },
--                 light   = { warnduration = function() return 60 end, numspawns = function() return 2 + math.random(2) end },
--                 med     = { warnduration = function() return 45 end, numspawns = function() return 3 + math.random(3) end },
--                 heavy   = { warnduration = function() return 30 end, numspawns = function() return 4 + math.random(3) end },
--                 crazy   = { warnduration = function() return 30 end, numspawns = function() return 6 + math.random(4) end },
--             },

--             attack_delays =
--             {
--                 rare        = function() return TUNING.TOTAL_DAY_TIME * 3, math.random() * TUNING.TOTAL_DAY_TIME * 1 end,
--                 occasional  = function() return TUNING.TOTAL_DAY_TIME * 2, math.random() * TUNING.TOTAL_DAY_TIME * 1 end,
--                 frequent    = function() return TUNING.TOTAL_DAY_TIME * 1, math.random() * TUNING.TOTAL_DAY_TIME * 1 end,
--             },

--             warning_speech = "ANNOUNCE_HOUNDS",

--             --Key = time, Value = sound prefab
--             warning_sound_thresholds =
--             {
--                 { time = 30, sound =  "LVL4" },
--                 { time = 60, sound =  "LVL3" },
--                 { time = 90, sound =  "LVL2" },
--                 { time = 500, sound = "LVL1" },
--             },
--         }

--         inst.components.hounded:SetSpawnData(houndspawn)
--     end
-- end)

--------------------------------------------------------------------------
--[[ 皮肤 ]]
--------------------------------------------------------------------------

modimport("scripts/skin_legion.lua") --skined_legion

--------------------------------------------------------------------------
--[[ mod之间的兼容 ]]
--------------------------------------------------------------------------

----------
--黑化排队论2(有好几个版本，但组件好像是相同的)
----------
AddComponentPostInit("actionqueuer", function(self)
	if self.AddAction then
		self.AddAction("leftclick", "PLANTSOIL_LEGION", true)
        self.AddAction("rightclick", "POUR_WATER_LEGION", true)
        self.AddAction("leftclick", "FERTILIZE_LEGION", true)
        self.AddAction("leftclick", "FEED_BEEF_L", true)
	end
end)

--AddSimPostInit()在所有mod加载完毕后才执行，这时能更准确判定是否启用某mod，不用考虑优先级
AddSimPostInit(function()
	--table.insert(Assets, Asset("ANIM", "anim/player_actions_roll.zip")) --这个函数里没法再注册动画数据了
    --注意：运行这里时，所有mod的prefab已经注册完成了

    ----------
    --丰饶传说
    ----------
    _G.VEGGIES.pineananas = { --新增作物收获物与种子设定（只是为了种子几率，并不会主动生成prefab）
        health = 8,
        hunger = 12,
        sanity = -10,
        perishtime = TUNING.PERISH_MED,
        float_settings = {"small", 0.2, 0.9},

        cooked_health = 16,
        cooked_hunger = 18.5,
        cooked_sanity = 5,
        cooked_perishtime = TUNING.PERISH_SUPERFAST,
        cooked_float_settings = {"small", 0.2, 1},

        seed_weight = TUNING.SEED_CHANCE_RARE, --大概只有这里起作用了
        dryable = nil,
        halloweenmoonmutable_settings = nil,
        secondary_foodtype = nil,
        lure_data = nil
    }

    ----------
    --神话书说
    ----------
    _G.CONFIGS_LEGION.ENABLEDMODS.MythWords = TUNING.MYTH_WORDS_MOD_OPEN
    if TUNING.MYTH_WORDS_MOD_OPEN then
        if CONFIGS_LEGION.DRESSUP then
            local DRESSUP_DATA = _G.DRESSUP_DATA_LEGION

            DRESSUP_DATA["xzhat_mk"] = { --行者帽
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}

                    local mythskin = item.components.myth_itemskin
                    local skinname = mythskin.skin:value()
                    local skindata = mythskin.swap or mythskin.data.default.swap
                    if skinname == "ear" then
                        itemswap["swap_hat"] = dressup:GetDressData(
                            nil, skindata.build, skindata.folder, item.GUID, "swap"
                        )
                        dressup:SetDressOpenTop(itemswap)
                        itemswap["swap_face"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                        itemswap["hair"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                    elseif skinname == "horse" then
                        itemswap["hair"] = dressup:GetDressData(
                            nil, skindata.build, skindata.folder, item.GUID, "swap"
                        )
                        dressup:SetDressOpenTop(itemswap)
                        itemswap["swap_face"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                        itemswap["swap_hat"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                        itemswap["HAT"] = dressup:GetDressData(nil, nil, nil, nil, "show")
                        itemswap["HAIR_HAT"] = dressup:GetDressData(nil, nil, nil, nil, "show")
                    elseif skinname == "wine" then
                        itemswap["swap_face"] = dressup:GetDressData(
                            nil, skindata.build, skindata.folder, item.GUID, "swap"
                        )
                        dressup:SetDressOpenTop(itemswap)
                        itemswap["hair"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                        itemswap["swap_hat"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                    else
                        skindata = mythskin.data.default.swap
                        itemswap["swap_hat"] = dressup:GetDressData(
                            nil, skindata.build, skindata.folder, item.GUID, "swap"
                        )
                        dressup:SetDressTop(itemswap)
                        itemswap["swap_face"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                        itemswap["hair"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                    end

                    return itemswap
                end,
                unbuildfn = function(dressup, item)
                    dressup:InitGroupHead()
                    dressup:InitClear("hair")
                    dressup:InitClear("swap_face")
                end
            }
            DRESSUP_DATA["cassock"] = { --袈裟
                isnoskin = true, buildfile = "cassock", buildsymbol = "swap_body",
            }
            DRESSUP_DATA["kam_lan_cassock"] = { --锦斓袈裟
                isnoskin = true, buildfile = "kam_Lan_cassock", buildsymbol = "swap_body",
            }
            DRESSUP_DATA["myth_lotusleaf"] = { --莲叶
                isnoskin = true, buildfile = "myth_lotusleaf_umbrella", buildsymbol = "swap_leaves",
            }
            DRESSUP_DATA["myth_lotusleaf_hat"] = { --莲叶帽
                isnoskin = true, buildfile = "myth_lotusleaf_hat", buildsymbol = "swap_hat",
            }
            DRESSUP_DATA["bone_blade"] = { --骨刃
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}

                    local mythskin = item.components.myth_itemskin
                    local skindata = mythskin.swap or mythskin.data.default.swap
                    itemswap["swap_object"] = dressup:GetDressData(
                        nil, skindata.build, skindata.folder, item.GUID, "swap"
                    )
                    itemswap["whipline"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                    itemswap["lantern_overlay"] = dressup:GetDressData(nil, nil, nil, nil, "clear")

                    return itemswap
                end,
            }
            DRESSUP_DATA["bone_wand"] = { --骨杖
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}

                    local mythskin = item.components.myth_itemskin
                    local skindata = mythskin.swap or mythskin.data.default.swap
                    itemswap["swap_object"] = dressup:GetDressData(
                        nil, skindata.build, skindata.folder, item.GUID, "swap"
                    )
                    itemswap["whipline"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                    itemswap["lantern_overlay"] = dressup:GetDressData(nil, nil, nil, nil, "clear")

                    return itemswap
                end,
            }
            DRESSUP_DATA["bone_whip"] = { --骨鞭
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}

                    local key = item.components.myth_itemskin.skin:value()
                    if key == nil or key == "" or key == 'default' then
                        key = 'none'
                    end
                    itemswap["swap_object"] = dressup:GetDressData(
                        nil, "bone_whip", "swap_whip_"..key, item.GUID, "swap"
                    )
                    itemswap["whipline"] = dressup:GetDressData(
                        nil, "bone_whip", "whipline_"..key, item.GUID, "swap"
                    )
                    itemswap["lantern_overlay"] = dressup:GetDressData(nil, nil, nil, nil, "clear")

                    return itemswap
                end,
            }
            DRESSUP_DATA["pigsy_hat"] = { --墨兰帽
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}

                    local mythskin = item.components.myth_itemskin
                    local skindata = mythskin.swap or mythskin.data.default.swap
                    itemswap["swap_hat"] = dressup:GetDressData(
                        nil, skindata.build, skindata.folder, item.GUID, "swap"
                    )
                    dressup:SetDressOpenTop(itemswap)

                    return itemswap
                end
            }
            DRESSUP_DATA["myth_bamboo_basket"] = { --竹药篓
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}

                    local mythskin = item.components.myth_itemskin
                    local skinname = mythskin.skin:value()
                    local skindata = mythskin.swap or mythskin.data.default.swap
                    if skinname == "apricot" then
                        itemswap["swap_body_tall"] = dressup:GetDressData(
                            nil, skindata.build, "swap_none", item.GUID, "swap"
                        )
                    else
                        itemswap["backpack"] = dressup:GetDressData(
                            nil, skindata.build, skindata.folder, item.GUID, "swap"
                        )
                        itemswap["swap_body"] = dressup:GetDressData(
                            nil, skindata.build, skindata.folder, item.GUID, "swap"
                        )
                    end

                    return itemswap
                end,
                unbuildfn = function(dressup, item)
                    dressup:InitClear("swap_body_tall")
                    dressup:InitClear("backpack")
                    dressup:InitClear("swap_body")
                end,
            }
            DRESSUP_DATA["bananafan_big"] = { --芭蕉宝扇
                isnoskin = true, buildfile = "swap_bananafan_big", buildsymbol = "swap_fan"
            }
            DRESSUP_DATA["myth_ruyi"] = { --莹月如意
                isnoskin = true, buildfile = "myth_ruyi", buildsymbol = "swap_ruyi",
            }
            DRESSUP_DATA["siving_hat"] = { --子圭战盔
                isnoskin = true, buildfile = "siving_hat", buildsymbol = "swap_hat",
            }
            DRESSUP_DATA["armorsiving"] = { --子圭战甲
                isnoskin = true, buildfile = "armor_siving", buildsymbol = "swap_body",
            }
            DRESSUP_DATA["myth_qxj"] = { --七星剑
                isnoskin = true, buildfile = "myth_qxj", buildsymbol = "swap_qxj",
            }
            DRESSUP_DATA["wb_armorbone"] = { --坚骨披
                isnoskin = true, dressslot = EQUIPSLOTS.BODY, buildfile = "wb_armorbone", buildsymbol = "swap_body",
            }
            DRESSUP_DATA["wb_armorblood"] = { --血色霓
                isnoskin = true, dressslot = EQUIPSLOTS.BODY, buildfile = "wb_armorblood", buildsymbol = "swap_body",
            }
            DRESSUP_DATA["wb_armorfog"] = { --雾隐裳
                isnoskin = true, dressslot = EQUIPSLOTS.BODY, buildfile = "wb_armorfog", buildsymbol = "swap_body",
            }
            DRESSUP_DATA["wb_armorgreed"] = { --不魇衣
                isnoskin = true, dressslot = EQUIPSLOTS.BODY, buildfile = "wb_armorgreed", buildsymbol = "swap_body",
            }
            DRESSUP_DATA["wb_armorlight"] = { --盈风绸
                isnoskin = true, dressslot = EQUIPSLOTS.BODY, buildfile = "wb_armorlight", buildsymbol = "swap_body",
            }
            DRESSUP_DATA["wb_armorstorage"] = { --蕴玄袍
                isnoskin = true, dressslot = EQUIPSLOTS.BODY, buildfile = "wb_armorstorage", buildsymbol = "swap_body",
            }
            DRESSUP_DATA["purple_gourd"] = { --紫金红葫芦
                isnoskin = true, buildfile = "purple_gourd", buildsymbol = "swap_2",
            }
            DRESSUP_DATA["myth_fuchen"] = { --拂尘
                isnoskin = true, iswhip = true, buildfile = "swap_myth_fuchen", buildsymbol = "swap_whip",
            }
            DRESSUP_DATA["myth_weapon_syf"] = { --霜钺斧
                isnoskin = true, buildfile = "myth_weapon_syf", buildsymbol = "swap",
            }
            DRESSUP_DATA["myth_weapon_gtt"] = { --扢挞藤
                isnoskin = true, buildfile = "myth_weapon_gtt", buildsymbol = "swap",
            }
            DRESSUP_DATA["myth_weapon_syd"] = { --暑熠刀
                isnoskin = true, buildfile = "myth_weapon_syd", buildsymbol = "swap",
            }
            DRESSUP_DATA["myth_iron_helmet"] = { --铸铁头盔
                isnoskin = true, buildfile = "myth_iron_helmet", buildsymbol = "swap_hat"
            }
            DRESSUP_DATA["myth_iron_broadsword"] = { --铸铁大刀
                isnoskin = true, buildfile = "myth_iron_broadsword", buildsymbol = "swap_object"
            }
            DRESSUP_DATA["myth_iron_battlegear"] = { --铸铁战甲
                isnoskin = true, buildfile = "myth_iron_battlegear", buildsymbol = "swap_body"
            }
            DRESSUP_DATA["myth_food_tr"] = { --糖人
                isnoskin = true, buildfile = "swap_myth_food_tr", buildsymbol = "image"
            }
            DRESSUP_DATA["cane_peach"] = { --桃木手杖
                isnoskin = true, buildfile = "cane_peach", buildsymbol = "swap"
            }
            DRESSUP_DATA["myth_gold_staff"] = { --金击子
                isnoskin = true, buildfile = "myth_gold_staff", buildsymbol = "swap_spear"
            }
        end

        if _G.rawget(_G, "AddBambooShopItems") then
            local chancemap = { 1, 3, 7, 10, 15 }
            _G.AddBambooShopItems("rareitem", {
                tourmalinecore = {
                    img_tex = "tourmalinecore.tex", img_atlas = "images/inventoryimages/tourmalinecore.xml",
                    buy = { value = 320, chance = chancemap[1], count_min = 1, count_max = 1, stacksize = 5, },
                    sell = { value = 180, chance = chancemap[1], count_min = 1, count_max = 1, stacksize = 5, }
                },
            })
            _G.AddBambooShopItems("ingredient", {
                pineananas = {
                    img_tex = "pineananas.tex", img_atlas = "images/inventoryimages/pineananas.xml",
                    buy = { value = 5, chance = chancemap[2], count_min = 3, count_max = 5, stacksize = 20, },
                    sell = { value = 2, chance = chancemap[2], count_min = 3, count_max = 5, stacksize = 20, },
                },
            })
            _G.AddBambooShopItems("plants", {
                pineananas_seeds = {
                    img_tex = "pineananas_seeds.tex", img_atlas = "images/inventoryimages/pineananas_seeds.xml",
                    buy = { value = 12, chance = chancemap[3], count_min = 2, count_max = 3, stacksize = 10, num_mix = 4, },
                    sell = { value = nil, chance = chancemap[3], count_min = 2, count_max = 3, stacksize = 10, num_mix = 4, }
                },
                pineananas_oversized = {
                    img_tex = "pineananas_oversized.tex", img_atlas = "images/inventoryimages/pineananas_oversized.xml",
                    buy = { value = nil, chance = chancemap[5], count_min = 1, count_max = 2, stacksize = 5, },
                    sell = { value = 10, chance = chancemap[5], count_min = 1, count_max = 2, stacksize = 5, }
                },
                dug_rosebush = {
                    img_tex = "dug_rosebush.tex", img_atlas = "images/inventoryimages/dug_rosebush.xml",
                    buy = { value = 15, chance = chancemap[2], count_min = 1, count_max = 3, stacksize = 10, },
                    sell = { value = nil, chance = chancemap[2], count_min = 1, count_max = 3, stacksize = 10, },
                },
                dug_lilybush = {
                    img_tex = "dug_lilybush.tex", img_atlas = "images/inventoryimages/dug_lilybush.xml",
                    buy = { value = 15, chance = chancemap[2], count_min = 1, count_max = 3, stacksize = 10, },
                    sell = { value = nil, chance = chancemap[2], count_min = 1, count_max = 3, stacksize = 10, },
                },
                dug_orchidbush = {
                    img_tex = "dug_orchidbush.tex", img_atlas = "images/inventoryimages/dug_orchidbush.xml",
                    buy = { value = 15, chance = chancemap[2], count_min = 1, count_max = 3, stacksize = 10, },
                    sell = { value = nil, chance = chancemap[2], count_min = 1, count_max = 3, stacksize = 10, },
                },
                cutted_rosebush = {
                    img_tex = "cutted_rosebush.tex", img_atlas = "images/inventoryimages/cutted_rosebush.xml",
                    buy = { value = 15, chance = chancemap[2], count_min = 1, count_max = 3, stacksize = 20, },
                    sell = { value = 6, chance = chancemap[2], count_min = 2, count_max = 4, stacksize = 20, },
                },
                cutted_lilybush = {
                    img_tex = "cutted_lilybush.tex", img_atlas = "images/inventoryimages/cutted_lilybush.xml",
                    buy = { value = 15, chance = chancemap[2], count_min = 1, count_max = 3, stacksize = 20, },
                    sell = { value = 6, chance = chancemap[2], count_min = 2, count_max = 4, stacksize = 20, },
                },
                cutted_orchidbush = {
                    img_tex = "cutted_orchidbush.tex", img_atlas = "images/inventoryimages/cutted_orchidbush.xml",
                    buy = { value = 15, chance = chancemap[2], count_min = 1, count_max = 3, stacksize = 20, },
                    sell = { value = 6, chance = chancemap[2], count_min = 2, count_max = 4, stacksize = 20, },
                },
                dug_monstrain = {
                    img_tex = "dug_monstrain.tex", img_atlas = "images/inventoryimages/dug_monstrain.xml",
                    buy = { value = 10, chance = chancemap[2], count_min = 1, count_max = 3, stacksize = 20, },
                    sell = { value = 5, chance = chancemap[2], count_min = 2, count_max = 4, stacksize = 20, },
                },
            })
            _G.AddBambooShopItems("animals", {
                raindonate = {
                    img_tex = "raindonate.tex", img_atlas = "images/inventoryimages/raindonate.xml",
                    buy = { value = 10, chance = chancemap[3], count_min = 2, count_max = 4, stacksize = 10, },
                    sell = { value = 5, chance = chancemap[3], count_min = 2, count_max = 4, stacksize = 10, },
                },
            })
            _G.AddBambooShopItems("construct", {
                shyerrylog = {
                    img_tex = "shyerrylog.tex", img_atlas = "images/inventoryimages/shyerrylog.xml",
                    buy = { value = 4, chance = chancemap[4], count_min = 3, count_max = 5, stacksize = 20, },
                    sell = { value = 2, chance = chancemap[4], count_min = 3, count_max = 5, stacksize = 20, },
                },
            })
        end
    end

    ----------
    --额外物品包
    ----------
    if CONFIGS_LEGION.DRESSUP and _G.rawget(_G, "aipCountTable") then
        local DRESSUP_DATA = _G.DRESSUP_DATA_LEGION
        DRESSUP_DATA["aip_armor_gambler"] = { --赌徒护甲
            isnoskin = true, buildfile = "aip_armor_gambler", buildsymbol = "swap_body"
        }
        DRESSUP_DATA["aip_beehave"] = { --蜂语
            isnoskin = true, buildfile = "aip_beehave_swap", buildsymbol = "aip_beehave_swap"
        }
        DRESSUP_DATA["aip_dou_scepter"] = { --神秘权杖1
            isnoskin = true, buildfile = "aip_dou_scepter_swap", buildsymbol = "aip_dou_scepter_swap"
        }
        DRESSUP_DATA["aip_dou_empower_scepter"] = { --神秘权杖2
            isnoskin = true, buildfile = "aip_dou_empower_scepter_swap", buildsymbol = "aip_dou_empower_scepter_swap"
        }
        DRESSUP_DATA["aip_dou_huge_scepter"] = DRESSUP_DATA["aip_dou_empower_scepter"] --神秘权杖3
        DRESSUP_DATA["aip_dou_scepter_lock"] = DRESSUP_DATA["aip_dou_empower_scepter"] --神秘权杖4
        DRESSUP_DATA["aip_fish_sword"] = { --鱼刀
            isnoskin = true, buildfile = "aip_fish_sword_swap", buildsymbol = "aip_fish_sword_swap"
        }
        DRESSUP_DATA["aip_krampus_plus"] = { --守财奴的背包
            isnoskin = true, isbackpack = true,
            buildfile = "aip_krampus_plus", buildsymbol = "swap_body"
        }
        DRESSUP_DATA["aip_oar_woodead"] = { --树精木浆
            isnoskin = true, buildfile = "aip_oar_woodead_swap", buildsymbol = "aip_oar_woodead_swap"
        }
        -- DRESSUP_DATA["aip_oldone_marble_head_lock"] = { --捆绑的头颅
        --     isnoskin = true, istallbody = true,
        --     buildfile = "aip_oldone_marble_head_lock", buildsymbol = "swap_body"
        -- }
        -- DRESSUP_DATA["aip_oldone_marble_head"] = { --头颅部件
        --     isnoskin = true, istallbody = true,
        --     buildfile = "aip_oldone_marble_head", buildsymbol = "swap_body"
        -- }
        -- DRESSUP_DATA["aip_oldone_snowball"] = { --雪球（有bug不敢加了）
        --     isnoskin = true, istallbody = true,
        --     buildfile = "aip_oldone_snowball", buildsymbol = "swap_body"
        -- }
        DRESSUP_DATA["aip_suwu"] = { --子卿
            isnoskin = true, buildfile = "aip_suwu_swap", buildsymbol = "aip_suwu_swap"
        }
        DRESSUP_DATA["aip_track_tool"] = { --月轨测量仪
            isnoskin = true, buildfile = "aip_track_tool_swap", buildsymbol = "aip_track_tool_swap"
        }
        DRESSUP_DATA["aip_xinyue_hoe"] = { --心悦锄
            isnoskin = true, buildfile = "aip_xinyue_hoe_swap", buildsymbol = "aip_xinyue_hoe_swap"
        }
        DRESSUP_DATA["popcorngun"] = { --玉米枪
            isnoskin = true, buildfile = "swap_popcorn_gun", buildsymbol = "swap_popcorn_gun"
        }
        DRESSUP_DATA["aip_wizard_hat"] = { --闹鬼巫师帽
            isnoskin = true, buildfile = "aip_wizard_hat", buildsymbol = "swap_hat"
        }
        DRESSUP_DATA["aip_horse_head"] = { --马头
            isnoskin = true,
            buildfn = function(dressup, item, buildskin)
                local itemswap = {}

                itemswap["swap_hat"] = dressup:GetDressData(
                    buildskin, "aip_horse_head", "swap_hat", item.GUID, "swap"
                )
                dressup:SetDressTopCover(itemswap)

                return itemswap
            end
        }
        DRESSUP_DATA["aip_som"] = { --谜之声
            isnoskin = true,
            buildfn = function(dressup, item, buildskin)
                local itemswap = {}

                itemswap["swap_hat"] = dressup:GetDressData(
                    buildskin, "aip_som", "swap_hat", item.GUID, "swap"
                )
                dressup:SetDressTopCover(itemswap)

                return itemswap
            end
        }
        DRESSUP_DATA["aip_blue_glasses"] = { --岚色眼镜
            isnoskin = true, isopentop = true,
            buildfile = "aip_blue_glasses", buildsymbol = "swap_hat"
        }
        DRESSUP_DATA["aip_oldone_fisher"] = { --鱼仔帽
            isnoskin = true, buildfile = "aip_oldone_fisher", buildsymbol = "swap_hat"
        }
        DRESSUP_DATA["aip_joker_face"] = { --诙谐面具
            isnoskin = true, isopentop = true,
            buildfile = "aip_joker_face", buildsymbol = "swap_hat"
        }

        --各种雕像
        local pieces = {
            "aip_moon",
            "aip_doujiang",
            "aip_deer",
            "aip_mouth",
            "aip_octupus",
            "aip_fish"
        }
        local materials = {
            "marble", "stone", "moonglass",
        }
        for k,v in pairs(pieces) do
            _G.DRESSUP_DATA_LEGION["chesspiece_"..v] = {
                isnoskin = true,
                istallbody = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}

                    if item.materialid ~= nil and materials[item.materialid] ~= nil then
                        itemswap["swap_body_tall"] = dressup:GetDressData(
                            buildskin, "swap_chesspiece_"..v.."_"..materials[item.materialid], "swap_body", item.GUID, "swap"
                        )
                    end

                    return itemswap
                end
            }
        end
    end

    ----------
    --工艺锅（Craft Pot）
    ----------
    _G.CONFIGS_LEGION.ENABLEDMODS.CraftPot = AddFoodTag ~= nil --AddFoodTag()是该mod里的全局函数
    if CONFIGS_LEGION.ENABLEDMODS.CraftPot then
        --写这个是为了注册特殊烹饪条件(craft pot的机制)
        AddIngredientValues({"craftpot"}, {
            fallfullmoon = 1,
            winterfeast = 1,
            hallowednights = 1,
            newmoon = 1,
        }, false, false)

        if _G.CONFIGS_LEGION.LANGUAGES == "chinese" then
            STRINGS.NAMES_LEGION = {
                GEL = "黏液度",
                PETALS_LEGION = "花度",
                FALLFULLMOON = "秋季月圆天专属",
                WINTERSFEAST = "冬季盛宴专属",
                HALLOWEDNIGHTS = "疯狂万圣专属",
                NEWMOON = "新月天专属",
            }

            --帮craft pot翻译下吧
            STRINGS.NAMES.FROZEN = "冰度"
            STRINGS.NAMES.VEGGIE = "菜度"
            STRINGS.NAMES.SWEETENER = "甜度"
            -- STRINGS.NAMES.MEAT = "肉度" --和大肉重名了，不能这样改
            -- STRINGS.NAMES.FISH = "鱼度" --和鱼重名了，不能这样改
            STRINGS.NAMES.MONSTER = "怪物度"
            STRINGS.NAMES.FRUIT = "果度"
            STRINGS.NAMES.EGG = "蛋度"
            STRINGS.NAMES.INEDIBLE = "非食"
            STRINGS.NAMES.MAGIC = "魔法度"
            STRINGS.NAMES.DECORATION = "装饰度"
            STRINGS.NAMES.SEED = "种子度"
            STRINGS.NAMES.DAIRY = "乳度"
            STRINGS.NAMES.FAT = "脂度"
        else
            STRINGS.NAMES_LEGION = {
                GEL = "Gel",
                PETALS_LEGION = "Petals",
                FALLFULLMOON = "specific to Fall FullMoon Day",
                WINTERSFEAST = "specific to Winter Feast",
                HALLOWEDNIGHTS = "specific to Hallowed Nights",
                NEWMOON = "specific to NewMoon Day",
            }
        end

        AddFoodTag('gel', {
            name = STRINGS.NAMES_LEGION.GEL,
            tex = "foodtag_gel.tex",
            atlas = "images/foodtags/foodtag_gel.xml"
        })
        AddFoodTag('petals_legion', {
            name = STRINGS.NAMES_LEGION.PETALS_LEGION,
            tex = "foodtag_petals.tex",
            atlas = "images/foodtags/foodtag_petals.xml"
        })
        AddFoodTag('fallfullmoon', {
            name = STRINGS.NAMES_LEGION.FALLFULLMOON,
            tex = "foodtag_fallfullmoon.tex",
            atlas = "images/foodtags/foodtag_fallfullmoon.xml"
        })
        AddFoodTag('winterfeast', {
            name = STRINGS.NAMES_LEGION.WINTERSFEAST,
            tex = "foodtag_winterfeast.tex",
            atlas = "images/foodtags/foodtag_winterfeast.xml"
        })
        AddFoodTag('hallowednights', {
            name = STRINGS.NAMES_LEGION.HALLOWEDNIGHTS,
            tex = "foodtag_hallowednights.tex",
            atlas = "images/foodtags/foodtag_hallowednights.xml"
        })
        AddFoodTag('newmoon', {
            name = STRINGS.NAMES_LEGION.NEWMOON,
            tex = "foodtag_newmoon.tex",
            atlas = "images/foodtags/foodtag_newmoon.xml"
        })
        --这里本来想把冰度、菜度等图标都改为自己的图标，但是原mod里的图标其实更简单直接，适合新手，所以就不弄啦
    end

    ----------
    --能力勋章
    ----------
    -- _G.CONFIGS_LEGION.ENABLEDMODS.FunctionalMedal = TUNING.FUNCTIONAL_MEDAL_IS_OPEN
    if TUNING.FUNCTIONAL_MEDAL_IS_OPEN then
        if CONFIGS_LEGION.DRESSUP then
            local DRESSUP_DATA = _G.DRESSUP_DATA_LEGION
            local function Fn_medal_staff(dressup, item, itemswap, name)
                itemswap["swap_object"] = dressup:GetDressData(
                    nil, GetMedalSkinData(item, name), "swap_"..name, item.GUID, "swap"
                )
                dressup:SetDressHand(itemswap)
            end

            DRESSUP_DATA["marbleaxe"] = { --大理石斧头
                isnoskin = true, buildfile = "swap_marbleaxe", buildsymbol = "swap_marbleaxe"
            }
            DRESSUP_DATA["marblepickaxe"] = { --大理石镐
                isnoskin = true, buildfile = "marblepickaxe", buildsymbol = "swap_marblepickaxe"
            }
            DRESSUP_DATA["medal_moonglass_shovel"] = { --月光玻璃铲
                isnoskin = true, buildfile = "swap_medal_moonglass_shovel", buildsymbol = "swap_shovel"
            }
            DRESSUP_DATA["medal_moonglass_hammer"] = { --月光玻璃锤
                isnoskin = true, buildfile = "swap_medal_moonglass_hammer", buildsymbol = "swap_hammer"
            }
            DRESSUP_DATA["medal_moonglass_bugnet"] = { --月光玻璃网
                isnoskin = true, buildfile = "swap_medal_moonglass_bugnet", buildsymbol = "swap_bugnet"
            }
            DRESSUP_DATA["lureplant_rod"] = { --食人花手杖
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}
                    Fn_medal_staff(dressup, item, itemswap, "lureplant_rod")
                    return itemswap
                end
            }
            DRESSUP_DATA["immortal_staff"] = { --不朽法杖
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}
                    Fn_medal_staff(dressup, item, itemswap, "immortal_staff")
                    return itemswap
                end
            }
            DRESSUP_DATA["devour_staff"] = { --吞噬法杖
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}
                    Fn_medal_staff(dressup, item, itemswap, "devour_staff")
                    return itemswap
                end
            }
            DRESSUP_DATA["meteor_staff"] = { --流星法杖
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}
                    Fn_medal_staff(dressup, item, itemswap, "meteor_staff")
                    return itemswap
                end
            }
            DRESSUP_DATA["medal_skin_staff"] = { --风花雪月
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}
                    Fn_medal_staff(dressup, item, itemswap, "medal_skin_staff")
                    return itemswap
                end
            }
            DRESSUP_DATA["medal_space_staff"] = { --时空法杖
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}
                    Fn_medal_staff(dressup, item, itemswap, "medal_space_staff")
                    return itemswap
                end
            }
            DRESSUP_DATA["medal_goathat"] = { --羊角帽
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}
                    itemswap["swap_hat"] = dressup:GetDressData(
                        nil, GetMedalSkinData(item, "medal_goathat"), "swap_hat", item.GUID, "swap"
                    )
                    dressup:SetDressTop(itemswap)
                    return itemswap
                end
            }
            DRESSUP_DATA["down_filled_coat"] = { --羽绒服
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}
                    itemswap["swap_body"] = dressup:GetDressData(
                        nil, GetMedalSkinData(item, "down_filled_coat"), "swap_body", item.GUID, "swap"
                    )
                    itemswap["backpack"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                    return itemswap
                end
            }
            DRESSUP_DATA["hat_blue_crystal"] = { --蓝晶帽
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}
                    itemswap["swap_hat"] = dressup:GetDressData(
                        nil, "hat_blue_crystal", "swap_hat", item.GUID, "swap"
                    )
                    dressup:SetDressTopCover(itemswap)
                    return itemswap
                end
            }
            DRESSUP_DATA["medal_tentaclespike"] = { --活性触手尖刺
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}
                    itemswap["swap_object"] = dressup:GetDressData(
                        nil, "medal_tentaclespike", "swap_medal_tentaclespike", item.GUID, "swap"
                    )
                    itemswap["whipline"] = dressup:GetDressData(
                        nil, "swap_whip", "whipline", item.GUID, "swap"
                    )
                    return itemswap
                end
            }
            DRESSUP_DATA["sanityrock_mace"] = { --方尖锏
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}
                    Fn_medal_staff(dressup, item, itemswap, "sanityrock_mace")
                    return itemswap
                end
            }
            DRESSUP_DATA["armor_medal_obsidian"] = { --红晶甲
                isnoskin = true, buildfile = "armor_medal_obsidian", buildsymbol = "swap_body"
            }
            DRESSUP_DATA["armor_blue_crystal"] = { --蓝晶甲
                isnoskin = true, buildfile = "armor_blue_crystal", buildsymbol = "swap_body"
            }
            DRESSUP_DATA["medal_fishingrod"] = { --玻璃钓竿
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}

                    local sbuild = GetMedalSkinData(item, "swap_medal_fishingrod")
                    itemswap["swap_object"] = dressup:GetDressData(
                        nil, sbuild, "swap_fishingrod", item.GUID, "swap"
                    )
                    itemswap["fishingline"] = dressup:GetDressData(
                        nil, sbuild, "fishingline", item.GUID, "swap"
                    )
                    itemswap["FX_fishing"] = dressup:GetDressData(
                        nil, sbuild, "FX_fishing", item.GUID, "swap"
                    )
                    dressup:SetDressHand(itemswap)

                    return itemswap
                end,
                unbuildfn = function(dressup, item)
                    dressup:InitClear("swap_object")
                    dressup:InitClear("whipline")
                    dressup:InitClear("lantern_overlay")
                    dressup:InitHide("LANTERN_OVERLAY")

                    dressup:InitClear("fishingline")
                    dressup:InitClear("FX_fishing")
                end
            }
            DRESSUP_DATA["medal_glassblock"] = { --不朽晶柱
                isnoskin = true, istallbody = true, buildfile = "swap_medal_glass_block", buildsymbol = "swap_body"
            }
        end
    end

    ----------
    --奇幻降临：永恒终焉
    ----------
    if TUNING.ABIGAIL_WILLIAMS_KEY_CALLMYWEAPON ~= nil or TUNING.AB_YZJXQ_SET ~= nil then
        if CONFIGS_LEGION.DRESSUP then
            local DRESSUP_DATA = _G.DRESSUP_DATA_LEGION

            DRESSUP_DATA["abigail_williams_moon_hat"] = { --月之皇冠(仅限该mod角色才能穿戴)
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}

                    local owner = dressup.inst
                    local skin_build = item:GetSkinBuild()
                    local ownerskin  = owner.components.skinner ~= nil and owner.components.skinner.skin_name or ""

                    if skin_build == "abigail_williams_moon_hat_summer" then --这个皮肤贴图性质只适合她自己
                        if ownerskin == "abigail_williams_summer" then
                            itemswap["headbase"] = dressup:GetDressData(
                                nil, skin_build, "headbase", item.GUID, "swap"
                            )
                            itemswap["hair"] = dressup:GetDressData(
                                nil, skin_build, "hair", item.GUID, "swap"
                            )
                        end
                        dressup:SetDressOpenTop(itemswap)
                    elseif skin_build == "abigail_williams_moon_hat_season" then
                        itemswap["swap_hat"] = dressup:GetDressData(
                            nil, skin_build, owner.prefab == "abigail_williams" and "swap_hat" or "swap_hat_other", item.GUID, "swap"
                        )
                        dressup:SetDressTop(itemswap)
                    elseif skin_build ~= nil then
                        itemswap["swap_hat"] = dressup:GetDressData(
                            nil, skin_build, "swap_hat", item.GUID, "swap"
                        )
                        dressup:SetDressTop(itemswap)
                    elseif skin_build == nil then
                        itemswap["swap_hat"] = dressup:GetDressData(
                            nil, item.prefab, "swap_hat", item.GUID, "swap"
                        )
                        dressup:SetDressOpenTop(itemswap)
                    end

                    return itemswap
                end,
                unbuildfn = function(dressup, item)
                    local owner = dressup.inst
                    local skin_build = item:GetSkinBuild()
                    local ownerskin  = owner.components.skinner ~= nil and owner.components.skinner.skin_name or ""
                    dressup:InitGroupHead()
                    if skin_build == "abigail_williams_moon_hat_summer" and ownerskin == "abigail_williams_summer" then
                        dressup:InitClear("headbase")
                        dressup:InitClear("hair")
                    end
                end
            }
            DRESSUP_DATA["ab_tianming"] = { --扭结：天命(仅限该mod角色才能穿戴)
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}

                    -- local owner = dressup.inst
                    local skin_build = item:GetSkinBuild()
                    -- local ownerskin  = owner.components.skinner ~= nil and owner.components.skinner.skin_name or ""

                    if skin_build == nil then --原皮没贴图
                        itemswap["backpack"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                        itemswap["swap_body"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                    else
                        itemswap["backpack"] = dressup:GetDressData(
                            nil, skin_build, "backpack", item.GUID, "swap"
                        )
                        itemswap["swap_body"] = dressup:GetDressData(
                            nil, skin_build, "swap_body", item.GUID, "swap"
                        )
                    end

                    return itemswap
                end
            }
            DRESSUP_DATA["ab_yzjxq"] = { --月之交响曲
                isnoskin = true, buildfile = "abigail_williams_wand_full", buildsymbol = "swap_object"
            }
        end
    end

    ----------
    --烹饪食材属性 兼容性修改(官方逻辑没有兼容性，只能自己写个有兼容性的啦)
    ----------
    cooking = require("cooking")
    local ingredients_base = cooking.ingredients
    if ingredients_base then
        for _,ing in ipairs(ingredients_l) do
            for _,name in pairs(ing[1]) do
                local cancook = ing[3]
                local candry = ing[4]

                if ingredients_base[name] == nil then
                    ingredients_base[name] = { tags={} }
                end
                if cancook then
                    if ingredients_base[name.."_cooked"] == nil then
                        ingredients_base[name.."_cooked"] = { tags={} }
                    end
                end
                if candry then
                    if ingredients_base[name.."_dried"] == nil then
                        ingredients_base[name.."_dried"] = { tags={} }
                    end
                end

                for tagname,tagval in pairs(ing[2]) do
                    ingredients_base[name].tags[tagname] = tagval
                    if cancook then
                        ingredients_base[name.."_cooked"].tags.precook = 1
                        ingredients_base[name.."_cooked"].tags[tagname] = tagval
                    end
                    if candry then
                        ingredients_base[name.."_dried"].tags.dried = 1
                        ingredients_base[name.."_dried"].tags[tagname] = tagval
                    end
                end
            end
        end
    end
    ingredients_l = nil

end)
