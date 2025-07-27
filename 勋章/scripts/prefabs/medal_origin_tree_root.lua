local easing = require("easing")

local assets =
{
    Asset("ANIM", "anim/tree_leaf_spike.zip"),
}

local function GiveTarget(inst, data)
    if data ~= nil then
        if data.owner then inst.owner = data.owner end
        if data.target then inst.target = data.target end
        if data.targetangle then inst.targetangle = data.targetangle end
        if data.targetpos and inst.targetangle then
            inst.targetpos = data.targetpos
            inst.dist_to_cover = math.sqrt(distsq(inst:GetPosition(), inst.targetpos))
            inst.origin = inst:GetPosition()
            inst.vector = Vector3(math.cos(inst.targetangle) * inst.dist_to_cover, 0, -math.sin(inst.targetangle) * inst.dist_to_cover)
        end

        if inst.vector and inst.origin then
            inst.step = 0
            inst.movetask = inst:DoPeriodicTask(1*FRAMES, function(inst)
                inst.step = inst.step + 1
                local x_dist = easing.inQuad(inst.step, 0, inst.vector.x, 29)
                local z_dist = easing.inQuad(inst.step, 0, inst.vector.z, 29)
                local x,y,z = inst.Transform:GetWorldPosition()
                inst.Transform:SetPosition(inst.origin.x + x_dist, y, inst.origin.z + z_dist)
            end)
            inst:DoTaskInTime(29*FRAMES, function(inst) inst.movetask:Cancel() inst.movetask = nil end)
        end
    end
end

local function task1(inst)
    inst.SoundEmitter:KillSound("rumble")
    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/deciduous/whip_pop")
    if inst.target then
        inst:FacePoint(inst.target.Transform:GetWorldPosition())
    end
end

local function task2(inst)
    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/deciduous/whip")
end

local AURA_EXCLUDE_TAGS = { "INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost", "chaos_creature"}

local function task3(inst)
    -- inst.components.combat:DoAttack()
    inst.components.combat:DoAreaAttack(inst, TUNING_MEDAL.MEDAL_ORIGIN_TREE_ROOT_ATTACK_RADIUS, nil, nil, nil, AURA_EXCLUDE_TAGS)
end

local function AttackOther(inst,data)
    if data ~= nil and data.target ~= nil and data.target:IsValid() and not IsEntityDeadOrGhost(data.target)  then
        --添加寄生值
        -- if data.target.components.health ~= nil then
        --     data.target.components.health:DoDeltaMedalParasitic(TUNING_MEDAL.MEDAL_ORIGIN_TREE_ROOT_PARASITIC)
        -- end
        --击飞
        -- data.target:PushEvent("knockback", {knocker = inst, radius = 3})
        --打落斧头
        if data.target.components.inventory then-- and not data.target:HasTag("stronggrip") then
            local item = data.target.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if item ~= nil and data.target.components.inventory.DropItem then
                data.target.components.inventory:DropItem(item,true,true)
            end
        end
        --混乱
        data.target:AddDebuff("buff_medal_confusion","buff_medal_confusion",{add_duration = TUNING_MEDAL.MEDAL_ORIGIN_TREE_ROOT_CONFUSION_TIME})
    end
end

local function doAttack(inst)
    inst:ListenForEvent("onareaattackother", AttackOther)
    inst:DoTaskInTime(29*FRAMES, task1)
    inst:DoTaskInTime(50*FRAMES, task2)
    inst:DoTaskInTime(55*FRAMES, task3)
    inst:DoTaskInTime(59*FRAMES, task2)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()

    inst.Physics:SetCylinder(0.25, 2)

    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("tree_leaf_spike")
    inst.AnimState:SetBuild("tree_leaf_spike")
    inst.AnimState:PlayAnimation("ground_loop")

    inst:AddTag("birchnutroot")
    inst:AddTag("notarget")

    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/deciduous/whip_move", "rumble")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:PushAnimation("up", false)
    inst.AnimState:PushAnimation("idle", false)
    inst.AnimState:PushAnimation("atk", false)
    inst.AnimState:PushAnimation("down", false)

    inst.target = nil
    inst:ListenForEvent("givetarget", GiveTarget)

    inst:AddComponent("combat")
    -- inst.components.combat:SetAreaDamage(TUNING_MEDAL.MEDAL_ORIGIN_TREE_ROOT_ATTACK_RADIUS)
    inst.components.combat:SetDefaultDamage(TUNING_MEDAL.MEDAL_ORIGIN_TREE_ROOT_DAMAGE)

    inst:AddComponent("medal_chaosdamage")--混沌伤害
	inst.components.medal_chaosdamage:SetBaseDamage(TUNING_MEDAL.MEDAL_ORIGIN_TREE_ROOT_CHAOS_DAMAGE)

    doAttack(inst)

    inst:ListenForEvent("animqueueover", inst.Remove)

    return inst
end

return Prefab("medal_origin_tree_root", fn, assets)
