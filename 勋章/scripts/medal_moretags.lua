---------------------------------------------------------------------------------------------------------------------
------------------这个文件出自风铃草大佬之手,在此基础上勋章做出了一定的修改,感谢风铃草大佬~--------------------------------
---------------------------------------------------------------------------------------------------------------------
--这种方式对FindEntity等地方的调用无效,仅适用于解锁配方、标签判断等比较常规的场景
local Tags = {}--强制覆盖原标签及对应方法
local Hash_To_Tags = {}--哈希对照表(把哈希值转化回对应的tag)
local key = "medal_fixtag" -- 默认用modname 做key 防止冲突

if TUNING.MoreTagsReg == nil then
    TUNING.MoreTagsReg = {}
end
function RegTag(tag) -- 必须先注册 主客机一起注册 注册后的tag会被截留
    tag = string.lower(tag)
    if not TUNING.MoreTagsReg[tag] then--全局判断，如果别的mod注册过了就没必要继续了
        TUNING.MoreTagsReg[tag] = key
        Tags[tag] = true
        Hash_To_Tags[hash(tag)] = tag--存入哈希对照表
    end
end

-------------------勋章特有标签-----------------
local medal_unique_tags={
	"seasoningchef",--主厨勋章(解锁相应配方、整组烹饪、快速撒调料、污染血糖)
	"wisdombuilder",--智慧勋章(解锁相应配方)
	"has_handy_medal",--巧手勋章(解锁相应配方、查看沃格斯塔夫工具名、快速建造)
	"has_plant_medal",--虫木勋章(解锁相应配方、复苏树根宝箱)
	"has_transplant_medal",--植物勋章(解锁相应配方、嫁接、种蘑菇树、种曼德拉草、塞种子)
	"tentaclemedal",--触手勋章(解锁相应配方、活性触手棒融合)
	"naughtymedal",--淘气勋章(解锁相应配方、摇铃铛额外加成、遗失包裹概率加成)
	"has_bathfire_medal",--浴火勋章(解锁相应配方)
	"medal_blinker",--噬灵勋章(灵魂跳跃、释放勋章灵魂)
	"temporaryblinker",--灵魂佐料(1次免费跳跃)
	"freeblinker",--瓶装灵魂(限时无限跳跃)
    "medal_map_blinker",--噬空勋章(地图灵魂跳跃)
	"has_childishness",--童心勋章(解锁相应配方、藏宝图不出玩具箱、监听射击)
	"senior_childishness",--童真勋章(解锁相应配方、快速射击)
	"is_bee_king",--蜂王勋章(解锁相应配方、切换勋章模式)
    "medal_fastpicker",--快采标签(丰收勋章)
	"rod_fastpicker",--特殊快采动作(食人花手杖)
	"medal_fishingrod",--玻璃钓竿(岩浆池钓鱼、钓遗失塑料袋)
	"space_medal",--空间勋章(可摸塔、快速回城)
    "addjustice",--正义勋章(可快速补充正义值)
    "fast_kill_fish",--快速杀鱼
    "has_largefishing_medal",--渔翁勋章(解锁相关道具配方)
    "spacetime_medal",--时空勋章(解锁时空相关道具配方)
    "nostiff",--霸体效果(免疫僵直)
    "medal_strong",--强壮效果(搬重物不减速)
    "inmoonlight",--处于月光环境中
    -- "senior_tentaclemedal",--高级触手勋章(免疫触手主动攻击)这种范围获取的不能用这个方法
    "medal_canstudy",--新华字典(可以阅读无字天书)
    "medal_confusion",--混乱(操作反向)
    "has_shadowmagic_medal",--暗影魔法勋章(解锁相应配方)
    "medal_shadow_tool_user",--切换暗影魔法工具
    "livinglogbuilder",--活木制作者(专门给沃姆伍德用的)
    "medal_chest_upgradeuser",--勋章箱子升级者(熊皮宝箱升级)
    "has_origin_medal",--拥有本源勋章
    "under_origin_tree",--处于本源之树下
}
for _,v in ipairs(medal_unique_tags) do
	RegTag(v)
end
--传承勋章分级标签
for i=1,TUNING_MEDAL.INHERIT_MEDAL.MAX_LEVEL do
	RegTag("traditionalbearer"..i)
end

--------------------佩戴勋章时会用到的原版标签--------------------
local medal_equip_tags = {
    "masterchef",--大厨标签
	"professionalchef",--调料站
	"expertchef",--熟练烹饪标签
    "bookbuilder",--图书制作者
    "handyperson",--女工科技
    "basicengineer",--女工科技(投石机等器械)
    -- "plantkin",--植物人
    "woodcutter",--伐木工标签
    "valkyrie",--女武神标签
    "merm_builder",--鱼人制造者
	-- "merm",--鱼人
    "playermerm",--鱼人角色
    "mermfluent",--鱼语十级
	"stronggrip",--工具不脱手
    -- "spiderwhisperer",--蜘蛛语
	"spider_upgradeuser",--蜘蛛巢升级
    "pyromaniac",--纵火狂标签
	"bernieowner",--伯尼熊主人标签
    "mime",--哑剧标签
	-- "balloonomancer",--气球制造者标签
    "soulstealer",--吞噬者标签
    "pebblemaker",--弹药制作者
	"slingshot_sharpshooter",--弹弓使用者
	"pinetreepioneer",--松树先锋(做帽子、帐篷)
    -- "insect",--昆虫标签，防止被蜜蜂主动叮咬
    -- "shadowmagic",--暗影魔术师标签
}
if TUNING.MEDAL_TAG_OPTIMIZATION > 0 then
    for _,v in ipairs(medal_equip_tags) do
        RegTag(v)
    end
end

--------------------原版标签--------------------
local dst_tags = {
    --威屌技能树
    -- "alchemist",
    -- "gem_alchemistI",
    -- "gem_alchemistII",
    -- "gem_alchemistIII",
    -- "ore_alchemistI",
    -- "ore_alchemistII",
    -- "ore_alchemistIII",
    -- "ick_alchemistI",
    -- "ick_alchemistII",
    -- "ick_alchemistIII",
    -- "skill_wilson_allegiance_shadow",
    -- "skill_wilson_allegiance_lunar",
    --火女技能树
    "controlled_burner",
    "ember_master",
    --植物人技能树
    "farmplantidentifier",
    -- "saplingcrafter",
    -- "berrybushcrafter",
    -- "juicyberrybushcrafter",
    -- "reedscrafter",
    -- "lureplantcrafter",
    -- "syrupcrafter",
    -- "lunarplant_husk_crafter",
    "farmplantfastpicker",
    -- "carratcrafter",
    -- "lightfliercrafter",
    -- "fruitdragoncrafter",
    --大力士技能树
    "wolfgang_coach",
    -- "wolfgang_dumbbell_crafting",
    "wolfgang_overbuff_1",
    "wolfgang_overbuff_2",
    "wolfgang_overbuff_3",
    "wolfgang_overbuff_4",
    "wolfgang_overbuff_5",
    --伍迪技能树
    "toughworker",
    "weremoosecombo",
    --女工技能树
    "portableengineer",
    -- "charliet1maker",
    -- "wagstafft1maker",
    -- "wagstafft2maker",
    --女武神技能树
    -- "battlesongshadowalignedmaker",
    -- "battlesonglunaralignedmaker",
    --小鱼妹技能树
    -- "mosquitocraft_1",
    -- "mosquitocraft_2",
    -- "merm_swampmaster_fertilizer",--根本没用到
    -- "merm_swampmaster_offeringpot",
    -- "merm_swampmaster_offeringpot_upgraded",
    -- "merm_swampmaster_mermtoolshed",
    -- "merm_swampmaster_mermtoolshed_upgraded",
    -- "merm_swampmaster_mermarmory",
    -- "merm_swampmaster_mermarmory_upgraded",
    -- "wurt_shadow_spelluser",
    -- "wurt_lunar_spelluser",
    -- "shadow_swamp_bomb_spelluser",
    -- "lunar_swamp_bomb_spelluser",
    --公共
    "player_shadow_aligned",--暗影阵营玩家
    "player_lunar_aligned",--月亮阵营玩家
}
if TUNING.MEDAL_TAG_OPTIMIZATION > 1 then
    for _,v in ipairs(dst_tags) do
        RegTag(v)
    end
end

-------------------------------------------------------相关方法-------------------------------------------------------
local function AddTag(inst, stag, ...)
    if not inst or not stag then return end
    local tag = type(stag)=="number" and Hash_To_Tags[stag] or string.lower(stag)--如果是哈希值则从哈希值转回字母tag
    if Tags[tag] then
        if inst[key].Tags and inst[key].Tags[tag] then
            inst[key].Tags[tag]:set_local(false)
            inst[key].Tags[tag]:set(true)
        end
    else
        return inst[key].AddTag(inst, stag, ...)
    end
end

local function RemoveTag(inst, stag, ...)
    if not inst or not stag then return end
    local tag = type(stag)=="number" and Hash_To_Tags[stag] or string.lower(stag)--如果是哈希值则从哈希值转回字母tag
    if Tags[tag] then
        if inst[key].Tags and inst[key].Tags[tag] then
            inst[key].Tags[tag]:set_local(true)
            inst[key].Tags[tag]:set(false)
        end
    else
        return inst[key].RemoveTag(inst, stag, ...)
    end
end

local function HasTag(inst, stag, ...)
    if not inst or not stag then return end
    local tag = type(stag)=="number" and Hash_To_Tags[stag] or string.lower(stag)--如果是哈希值则从哈希值转回字母tag
    if Tags[tag] and inst[key].Tags and inst[key].Tags[tag] then
        return inst[key].Tags[tag]:value()
    else
        return inst[key].HasTag(inst, stag, ...)
    end
end

local function HasTags(inst,...)
    local tags = select(1, ...)
    if type(tags) ~= "table" then
        tags = {...}
    end
    for _,v in ipairs(tags) do
        if not HasTag(inst, v) then return false end
    end
    return true
end

local function HasOneOfTags(inst,...)
    local tags = select(1, ...)
    if type(tags) ~= "table" then
        tags = {...}
    end
    for _,v in ipairs(tags) do
        if HasTag(inst, v) then return true end
    end
    return false
end

local function AddOrRemoveTag(inst,stag,condition,...)
    if not inst or not stag then return end
    local ltag = type(stag)=="number" and Hash_To_Tags[stag] or string.lower(stag)--如果是哈希值则从哈希值转回字母tag
    if Tags[ltag] then 
        if condition then 
            AddTag(inst,ltag,...)
        else
            RemoveTag(inst,ltag,...)
        end
    else
        return inst[key].AddOrRemoveTag(inst,stag,condition,...)
    end
end

function FixTag(inst) -- 传入实体 主客机一起调用
    inst[key] = {
        AddTag = inst.AddTag,
        HasTag = inst.HasTag,
        RemoveTag = inst.RemoveTag,
        HasTags = inst.HasTags,
        HasOneOfTags = inst.HasOneOfTags,
        AddOrRemoveTag = inst.AddOrRemoveTag,
        Tags = {}
    }
    inst.AddTag = AddTag
    inst.HasTag = HasTag
    inst.RemoveTag = RemoveTag
    inst.HasTags = HasTags
    inst.HasOneOfTags = HasOneOfTags
    inst.HasAllTags = HasTags
    inst.HasAnyTag = HasOneOfTags
    inst.AddOrRemoveTag = AddOrRemoveTag

    for k, _ in pairs(Tags) do
        inst[key].Tags[k] = net_bool(inst.GUID, key .. "." .. k, GUID, key .. "." .. k .. "dirty")
        if inst[key].HasTag(inst, k) then
            inst[key].RemoveTag(inst, k)
            inst[key].Tags[k]:set_local(false)
            inst[key].Tags[k]:set(true)
        else
            inst[key].Tags[k]:set(false)
        end
    end

end

AddPlayerPostInit(function(inst) -- 默认只扩展人物的
    FixTag(inst)
end)

-- return {
-- RegTag = RegTag, -- 用于注册tag   --需要主客机一起调用 注册后的tag会被截留
-- FixTag = FixTag -- 用来扩展实体的tag槽位
-- }