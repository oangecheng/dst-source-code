local assets =
{
    Asset("ANIM", "anim/dustmoth.zip"),
    Asset("ANIM", "anim/medal_dustmoth.zip"),
}

SetSharedLootTable('medal_dustmoth',
{
    {'smallmeat',  1.0},
})

local sounds =
{
    slide_in = "grotto/creatures/dust_moth/slide_in",
    slide_out = "grotto/creatures/dust_moth/slide_out",
    pickup = "grotto/creatures/dust_moth/mumble",
    hit = "grotto/creatures/dust_moth/hit",
    death = "grotto/creatures/dust_moth/death",
    sneeze = "grotto/creatures/dust_moth/sneeze",
    dustoff = "grotto/creatures/dust_moth/dustoff",
    mumble = "grotto/creatures/dust_moth/mumble",
    clean = "grotto/creatures/dust_moth/clean",
    eat = "grotto/creatures/dust_moth/eat",
    fall = "grotto/creatures/dust_moth/bodyfall",
    eat_slide = "grotto/creatures/dust_moth/eat_slide",
}

local CHECK_STUCK_FREQUENCY = 0.5--检查卡位的周期
local STUCK_DISTANCE_THRESHOLD_SQ = 0.25*0.25--判定是否卡位的距离

local brain = require "brains/medal_dustmothbrain"
--挨打掉落身上所有物品
local function OnAttacked(inst, data)
    inst.components.inventory:DropEverything()
end
--吃东西
local function OnEat(inst, data)
    if data.food ~= nil and data.food:HasTag("medaldustmothfood") then
        inst._charged = true--吃饱了
    end
end
--修复完巢穴了
local function OnFinishRepairingDen(inst, den)
    inst._charged = false--扫完就饿了
end
--是否可接受道具
local function ShouldAcceptItem(inst, item)
    return not inst._charged--不处于吃饱状态
        and inst.components.inventory:GetItemInSlot(1) == nil--身上有空位
        and item:HasTag("medaldustmothfood")--给的道具有时空尘蛾食物的标签
end
--拒绝接受
local function OnRefuseItem(inst, giver, item)
    if giver ~= nil and giver:IsValid() then
        inst:PushEvent("onrefuseitem", giver)
    end
end
--进入打扫CD
local function StartDustoffCooldown(inst)
    inst._find_dustables = false--CD期间不能进行打扫

    if inst._dustoff_cooldown_task ~= nil then
        inst._dustoff_cooldown_task:Cancel()
    end

    inst._dustoff_cooldown_task = inst:DoTaskInTime(TUNING_MEDAL.MEDAL_DUSTMOTH.DUSTOFF_COOLDOWN + math.random() * TUNING_MEDAL.MEDAL_DUSTMOTH.DUSTOFF_COOLDOWN_VARIANCE,
        function(inst)
            inst._find_dustables = true
        end)
end
--初始化位置
local function PostInit(inst)
    inst._previous_position = inst:GetPosition()
end
--检查卡位情况
local function CheckIsStuck(inst)
    if not inst.sg:HasStateTag("busy") then
        local delta = inst:GetPosition() - inst._previous_position
        --当前位置和上一次记录的位置太近，计时增加
        if VecUtil_LengthSq(delta.x, delta.z) <= STUCK_DISTANCE_THRESHOLD_SQ then
            inst._time_spent_stuck = inst._time_spent_stuck + CHECK_STUCK_FREQUENCY
        else--否则清空计时
            inst._time_spent_stuck = 0
        end

        inst._previous_position = inst:GetPosition()
    end
end

local function OnEntitySleep(inst)
    if inst._check_stuck_task ~= nil then
        inst._check_stuck_task:Cancel()
        inst._check_stuck_task = nil
    end
end
--每0.5秒检查一下看看是不是卡位了
local function StartCheckStuckTask(inst)
    if not inst._check_stuck_task then
        inst._check_stuck_task = inst:DoPeriodicTask(CHECK_STUCK_FREQUENCY, CheckIsStuck, 0.25)
    end
end

local function OnEntityWake(inst)
    StartCheckStuckTask(inst)
end

local function OnSave(inst, data)
    if inst._charged then
        data.charged = true
    end
end

local function OnLoad(inst, data)
    if data ~= nil and data.charged ~= nil then
        inst._charged = data.charged
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    inst.Transform:SetSixFaced()

    inst.DynamicShadow:SetSize(2.8, 2.5)

    MakeCharacterPhysics(inst, 50, .75)

    inst.AnimState:SetBank("dustmoth")
    inst.AnimState:SetBuild("medal_dustmoth")
    inst.AnimState:PlayAnimation("idle")

    -- inst:AddTag("cavedweller")--洞穴居民
    inst:AddTag("animal")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst._sounds = sounds

    inst._charged = false

    inst._previous_position = Vector3(0,0,0)
    inst._time_spent_stuck = 0--卡住的时间
    inst:DoTaskInTime(0, PostInit)
    StartCheckStuckTask(inst)
    -- inst._force_unstuck_wander = nil

    inst._find_dustables = true--是否处于可打扫状态
    inst.StartDustoffCooldown = StartDustoffCooldown -- Called from stategraph
    -- inst._dustoff_cooldown_task = nil

    inst._last_played_search_anim_time = -TUNING_MEDAL.MEDAL_DUSTMOTH.SEARCH_ANIM_COOLDOWN * math.random()--上一次播放搜索动画的时间

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING_MEDAL.MEDAL_DUSTMOTH.WALK_SPEED

    inst:SetStateGraph("SGmedal_dustmoth")

    inst:SetBrain(brain)

    inst:AddComponent("inspectable")

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "dm_body"

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING_MEDAL.MEDAL_DUSTMOTH.HEALTH)
    inst.components.health:StartRegen(TUNING_MEDAL.MEDAL_DUSTMOTH.HEALTH_REGEN, 1)--每秒恢复血量

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onrefuse = OnRefuseItem
    inst.components.trader.deleteitemonaccept = false

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.ELEMENTAL }, { FOODTYPE.ELEMENTAL })

    inst:AddComponent("sleeper")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('medal_dustmoth')

    inst:AddComponent("knownlocations")
    inst:AddComponent("homeseeker")--探亲者组件(常回家看看回家看看~)

    inst:AddComponent("inventory")
    inst.components.inventory.maxslots = 1

    inst:AddComponent("timer")

    MakeMediumFreezableCharacter(inst, "dm_body")
    MakeMediumBurnableCharacter(inst, "dm_body")

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("oneat", OnEat)
    inst:ListenForEvent("dustmothden_repaired", OnFinishRepairingDen)

    MakeHauntablePanic(inst)

    inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("medal_dustmoth", fn, assets)
