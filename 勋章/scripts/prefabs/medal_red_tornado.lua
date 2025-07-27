local assets =
{
    Asset("ANIM", "anim/tornado.zip"),
    Asset("ANIM", "anim/medal_red_tornado.zip"),
}

local brain = require("brains/medal_red_tornadobrain")

local function ontornadolifetime(inst)
    inst.task = nil
    inst.sg:GoToState("despawn")
end

local function SetDuration(inst, duration)
    if inst.task ~= nil then
        inst.task:Cancel()
    end
    inst.task = inst:DoTaskInTime(duration, ontornadolifetime)
end
--打乱物品
local function DisruptionItem(inst,v)
	if v == nil or not v:IsValid() then return end
    local vx, vy, vz = v.Transform:GetWorldPosition()
	if v.Physics ~= nil and v.Physics:IsActive() and vy<.1 then
        local x,y,z = inst.Transform:GetWorldPosition()
        local angle = TWOPI * math.random()
		local speed = math.random(4,8) + math.random()
		v.Physics:Teleport(x, 0.5, z)
		v.Physics:SetVel(
			speed * math.cos(angle),
			8 + 2 * math.random(),
			speed * math.sin(angle))
    end
end
--击飞的东西直接甩飞
local function OnStolen(inst,victim,item)
    DisruptionItem(inst,item)
end

local function tornado_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetFinalOffset(2)
    inst.AnimState:SetBank("tornado")
    inst.AnimState:SetBuild("medal_red_tornado")
    inst.AnimState:PlayAnimation("tornado_pre")
    inst.AnimState:PushAnimation("tornado_loop")

    inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado", "spinLoop")

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("knownlocations")

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING.TORNADO_WALK_SPEED * .33
    inst.components.locomotor.runspeed = TUNING.TORNADO_WALK_SPEED

    inst:AddComponent("thief")--击飞玩家身上东西用
    inst.components.thief:SetOnStolenFn(OnStolen)
    
	inst:AddComponent("medal_chaosdamage")--混沌伤害
	inst.components.medal_chaosdamage:SetBaseDamage(TUNING_MEDAL.MEDAL_RED_TORNADO_CHAOS_DAMAGE)

    inst.DisruptionItem = DisruptionItem

    inst:SetStateGraph("SGmedal_red_tornado")
    inst:SetBrain(brain)

    inst.WINDSTAFF_CASTER = nil
    inst.persists = false

    inst.SetDuration = SetDuration
    inst:SetDuration(TUNING_MEDAL.MEDAL_RED_TORNADO_LIFETIME)

    return inst
end

return Prefab("medal_red_tornado", tornado_fn, assets)
