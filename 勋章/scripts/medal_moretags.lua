------------------------------------------------------------------------------------------
------------------这个文件出自风铃草大佬之手~感谢风铃草大佬~--------------------------------
------------------------------------------------------------------------------------------
local Tags = {}
local key = "medal_fixtag" -- 默认用modname 做key 防止冲突

function RegTag(tag) -- 必须先注册 主客机一起注册 注册后的tag会被截留
    Tags[tag] = string.lower(tag)
end

local tag_list={
	--------------------原版标签--------------------
	-- "slingshot_sharpshooter",--弹弓使用者
	
	-------------------勋章原创标签-----------------
	"seasoningchef",--主厨勋章(解锁相应配方、整组烹饪、快速撒调料、污染血糖)
	"wisdombuilder",--智慧勋章(解锁相应配方)
	"has_handy_medal",--巧手勋章(解锁相应配方、查看沃格斯塔夫工具名)
	"has_plant_medal",--虫木勋章(解锁相应配方、复苏树根宝箱)
	"has_transplant_medal",--植物勋章(解锁相应配方、嫁接、种蘑菇树、种曼德拉草、塞种子)
	"tentaclemedal",--触手勋章(解锁相应配方、活性触手棒融合)
	"naughtymedal",--淘气勋章(解锁相应配方、摇铃铛额外加成、遗失包裹概率加成)
	"has_bathfire_medal",--浴火勋章(解锁相应配方)
	"medal_blinker",--噬灵勋章(灵魂跳跃、释放勋章灵魂)
	"has_childishness",--童心勋章(解锁相应配方、藏宝图不出玩具箱、监听射击)
	"senior_childishness",--童真勋章(解锁相应配方、快速射击)
	"is_bee_king",--蜂王勋章(解锁相应配方、切换勋章模式)
	"lureplant_rod",--食人花手杖(特殊快采动作)
	"medal_fishingrod",--玻璃钓竿(岩浆池钓鱼、钓遗失塑料袋)
	"space_medal",--空间勋章(可摸塔、快速回城)
    "addjustice",--正义勋章(可快速补充正义值)
    "fast_kill_fish",--快速杀鱼
    "spacetime_medal",--时空勋章(解锁时空相关道具配方)
    "nostiff",--霸体效果(免疫僵直)
    "medal_strong",--强壮效果(搬重物不减速)
    -- "senior_tentaclemedal",--高级触手勋章(免疫触手主动攻击)这种范围获取的不能用这个方法
}
--传承勋章分级标签
for i=1,TUNING_MEDAL.INHERIT_MEDAL.MAX_LEVEL do
	RegTag("traditionalbearer"..i)
end
for _,v in ipairs(tag_list) do
	RegTag(v)
end

local function AddTag(inst, stag, ...)
    if not inst or not stag then return end
    tag = string.lower(stag)
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
    tag = string.lower(stag)
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
    tag = string.lower(stag)
    if Tags[tag] and inst[key].Tags and inst[key].Tags[tag] then
        return inst[key].Tags[tag]:value()
    else
        return inst[key].HasTag(inst, stag, ...)
    end
end

function FixTag(inst) -- 传入实体 主客机一起调用
    inst[key] = {
        AddTag = inst.AddTag,
        HasTag = inst.HasTag,
        RemoveTag = inst.RemoveTag,
        Tags = {}
    }
    inst.AddTag = AddTag
    inst.HasTag = HasTag
    inst.RemoveTag = RemoveTag
    for k, v in pairs(Tags) do
        inst[key].Tags[k] = net_bool(inst.GUID, key .. "." .. k, GUID,
                                     key .. "." .. k .. "dirty")
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
