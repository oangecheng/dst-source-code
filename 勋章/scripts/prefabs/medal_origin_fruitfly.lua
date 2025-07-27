local assets =
{
    Asset("ANIM", "anim/fruitfly.zip"),
    Asset("ANIM", "anim/fruitfly_evil_minion.zip"),
}

local prefabs =
{
    "medal_weed_seeds",
    "seeds",
}

local brain = require("brains/medal_origin_fruitflybrain")

local sounds = {
    flap = "farming/creatures/minion_fruitfly/LP",
    hurt = "farming/creatures/minion_fruitfly/hit",
    attack = "farming/creatures/minion_fruitfly/attack",
    die = "farming/creatures/minion_fruitfly/die",
    die_ground = "farming/creatures/minion_fruitfly/hit",
    sleep = "farming/creatures/minion_fruitfly/sleep",
    buzz = "farming/creatures/minion_fruitfly/hit",
    spin = "farming/creatures/minion_fruitfly/spin",
    plant_attack = "farming/creatures/minion_fruitfly/plant_attack"
}

local function OnLoad(inst, data)
    if data then
        inst.pollination_times = data.pollination_times
    end
end

local function OnSave(inst)
    local data = {}
    data.pollination_times = inst.pollination_times
    return data
end

--可以攻击
local function CanTargetAndAttack(inst)
    return inst.pollination_times and inst.pollination_times >=2--授粉两次后才可攻击
end
--保持攻击目标
local function ShouldKeepTarget(inst, target)
    return inst:CanTargetAndAttack() and inst:IsNear(target, TUNING_MEDAL.MEDAL_ORIGIN_FRUITFLY_DEAGGRO_DIST) or false
end
--重新选择攻击目标
local RETARGET_MUSTTAGS = { "player" }
local RETARGET_CANTTAGS = { "playerghost" }
local function RetargetFn(inst)
    return inst:CanTargetAndAttack() and FindEntity(inst, TUNING_MEDAL.MEDAL_ORIGIN_FRUITFLY_TARGETRANGE, function(guy) return inst.components.combat:CanTarget(guy) end, RETARGET_MUSTTAGS, RETARGET_CANTTAGS) or nil
end
--挨揍
local function OnAttacked(inst, data)
    if not inst:CanTargetAndAttack() then return end--如果还没授够粉，就先忍了！
    local attacker = data ~= nil and data.attacker or nil
    if attacker == nil then return end
    inst.pollination_target = nil
    inst.components.combat:SetTarget(attacker)
end
--揍人
local function OnAttackOther(inst, data)
    if data ~= nil and data.target ~= nil and data.target:IsValid() and not IsEntityDeadOrGhost(data.target)  then
        --添加寄生值
        if data.target.components.health ~= nil then
            data.target.components.health:DoDeltaMedalParasitic(TUNING_MEDAL.MEDAL_ORIGIN_FRUITFLY_PARASITIC)
        end
    end
end
--授粉
local function OnPollination(inst,target)
    if target and target.Declining ~= nil then
        target:Declining(TUNING_MEDAL.MEDAL_ORIGIN_FRUITFLY_DECAYTIME[target.prefab == "medal_origin_tree_guard_sapling" and "SAPLING" or "DEFAULT"])
        if inst.pollination_times then--授粉次数+1
            inst.pollination_times = inst.pollination_times + 1
        end
        inst.last_pollination_target = target--记录最近授粉的目标,防止对同一目标连续重复授粉
        return true
    end
end

--捕捉(概率成功)
local function onworked(inst, worker, workleft)
    if workleft and workleft>0 then
        if math.random() < (TUNING_MEDAL.MEDAL_ORIGIN_FRUITFLY_WORKLEFT-workleft)/TUNING_MEDAL.MEDAL_ORIGIN_FRUITFLY_WORKLEFT then
            inst.components.workable.workleft=0
        end
    end
end
--成功捕捉
local function onfinished(inst, worker)
    if worker and worker.components.inventory ~= nil and inst.components.lootdropper then
        local prefabs = inst.components.lootdropper:GenerateLoot()
        for k, v in pairs(prefabs) do
            local item = SpawnPrefab(v)
            if item then
                worker.components.inventory:GiveItem(item, nil, inst:GetPosition())
            end
        end
        -- worker.SoundEmitter:PlaySound("dontstarve/common/butterfly_trap")
        inst:Remove()
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
    inst.Transform:SetFourFaced()

    MakeGhostPhysics(inst, 1, 0.5)

    inst.DynamicShadow:SetSize(1 * 0.5, 0.375 * 0.5)

    inst.sounds = sounds

    inst.AnimState:SetBank("fruitfly")
    inst.AnimState:SetBuild("fruitfly_evil_minion")
    inst.AnimState:PlayAnimation("idle")

    inst.Transform:SetScale(0.5, 0.5, 0.5)

    inst:AddTag("flying")
    inst:AddTag("ignorewalkableplatformdrowning")
    inst:AddTag("insect")
    inst:AddTag("small")
    inst:AddTag("fruitfly")
    inst:AddTag("hostile")
    inst:AddTag("chaos_creature")--混沌生物

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.pollination_times = 0--授粉次数

    inst:AddComponent("inspectable")

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 6
    inst.components.locomotor.pathcaps = {allowocean = true}
    inst.components.locomotor.walkspeed = TUNING_MEDAL.MEDAL_ORIGIN_FRUITFLY_WALKSPEED

    inst:AddComponent("follower")

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "fruit2"
    inst.components.combat.battlecryenabled = false
    inst.components.combat:SetAttackPeriod(TUNING_MEDAL.MEDAL_ORIGIN_FRUITFLY_ATTACK_PERIOD)
    inst.components.combat:SetDefaultDamage(TUNING_MEDAL.MEDAL_ORIGIN_FRUITFLY_DAMAGE)
    inst.components.combat:SetRange(TUNING_MEDAL.MEDAL_ORIGIN_FRUITFLY_ATTACK_DIST)
    inst.components.combat:SetRetargetFunction(3, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(ShouldKeepTarget)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING_MEDAL.MEDAL_ORIGIN_FRUITFLY_HEALTH)

    inst:AddComponent("planarentity")--实体抵抗
    inst.ChaosDeathTimesKey = "medal_origin_tree"--死亡次数以本源之树的为准
    inst:AddComponent("medal_chaosdamage")--混沌伤害
    inst.components.medal_chaosdamage:SetBaseDamage(TUNING_MEDAL.MEDAL_ORIGIN_FRUITFLY_CHAOS_DAMAGE)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:AddChanceLoot("medal_weed_seeds", 0.1)--杂草种子
    inst.components.lootdropper:AddChanceLoot("seeds", 0.2)--种子

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.NET)
    inst.components.workable:SetWorkLeft(TUNING_MEDAL.MEDAL_ORIGIN_FRUITFLY_WORKLEFT)--捕捉次数
    inst.components.workable:SetOnWorkCallback(onworked)
    inst.components.workable:SetOnFinishCallback(onfinished)

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED

    inst:AddComponent("knownlocations")--记录坐标点组件

    inst:SetBrain(brain)
    inst:SetStateGraph("SGmedal_origin_fruitfly")

    inst:ListenForEvent("attacked", OnAttacked)--被攻击
    inst:ListenForEvent("onattackother", OnAttackOther)--攻击到目标时

    inst.CanTargetAndAttack = CanTargetAndAttack
    inst.OnPollination = OnPollination

    MakeHauntablePanic(inst)

    inst.OnLoad = OnLoad
    inst.OnSave = OnSave

    return inst
end

return Prefab("medal_origin_fruitfly", fn, assets, prefabs)