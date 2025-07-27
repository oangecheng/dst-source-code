require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/brightmare_gestalt.zip"),
    Asset("ANIM", "anim/medal_gestalt.zip"),
}

local prefabs =
{
	"medal_gestalt_head",
	"gestalt_trail",
}

local assets_trail =
{
    Asset("ANIM", "anim/brightmare_gestalt_trail.zip"),
    Asset("ANIM", "anim/medal_gestalt_trail.zip"),
}

local assets_head =
{
    Asset("ANIM", "anim/brightmare_gestalt_head.zip"),
    Asset("ANIM", "anim/medal_gestalt_head.zip"),
}

local brain = require "brains/medal_gestaltbrain"

local function FindRelocatePoint(inst)
	return TheWorld and TheWorld.components.medal_spacetimestormmanager and TheWorld.components.medal_spacetimestormmanager:FindRelocatePoint() or nil 
end

local function Retarget(inst)
    local player, distsq = inst:GetNearestPlayer()--薅一个最近的玩家
    return distsq ~= nil and distsq < TUNING.GESTALT_AGGRESSIVE_RANGE*TUNING.GESTALT_AGGRESSIVE_RANGE and player or nil--和玩家间的距离小于6，则将这个玩家作为攻击对象
end

local function fn()
    local inst = CreateEntity()

    --Core components
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    --Initialize physics
    local phys = inst.entity:AddPhysics()
    phys:SetMass(1)
    phys:SetFriction(0)
    phys:SetDamping(5)
    phys:SetCollisionGroup(COLLISION.FLYERS)
    phys:ClearCollisionMask()
    phys:CollidesWith(COLLISION.GROUND)
    phys:SetCapsule(0.5, 1)

	inst:AddTag("brightmare")
	inst:AddTag("brightmare_gestalt")
	inst:AddTag("NOBLOCK")
	inst:AddTag("scarytoprey")

    inst.Transform:SetFourFaced()

    inst.AnimState:SetBuild("medal_gestalt")
    inst.AnimState:SetBank("brightmare_gestalt")
    inst.AnimState:PlayAnimation("idle", true)

	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.AnimState:SetMultColour(1, 1, 1, 0.75)

	if not TheNet:IsDedicated() then
		inst.blobhead = SpawnPrefab("medal_gestalt_head")
		inst.blobhead.entity:SetParent(inst.entity) --prevent 1st frame sleep on clients
		inst.blobhead.Follower:FollowSymbol(inst.GUID, "head_fx", 0, 0, 0)

		inst.blobhead.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.blobhead.AnimState:SetMultColour(1, 1, 1, 0.75)

	    inst.highlightchildren = { inst.blobhead }
	end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	-- inst.persists = false

	inst.FindRelocatePoint = FindRelocatePoint

    inst:AddComponent("sanityaura")
	inst.components.sanityaura.aura = TUNING.SANITYAURA_MED

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = TUNING.GESTALT_WALK_SPEED
    inst.components.locomotor.runspeed = TUNING.GESTALT_WALK_SPEED
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }

	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(TUNING_MEDAL.MEDAL_GESTALT_DAMAGE)
	inst.components.combat:SetAttackPeriod(TUNING_MEDAL.MEDAL_GESTALT_ATTACK_COOLDOWN)--攻击频率
	inst.components.combat:SetRange(TUNING_MEDAL.MEDAL_GESTALT_ATTACK_RANGE)--攻击距离
    inst.components.combat:SetRetargetFunction(1, Retarget)

	inst:AddComponent("medal_chaosdamage")--混沌伤害
	inst.components.medal_chaosdamage:SetBaseDamage(TUNING_MEDAL.MEDAL_GESTALT_CHAOS_DAMAGE)

    inst:AddComponent("inspectable")

    inst:SetStateGraph("SGmedal_gestalt")
    inst:SetBrain(brain)

    return inst
end

local function gestalt_trail_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.AnimState:SetBank("brightmare_gestalt_trail")
    inst.AnimState:SetBuild("medal_gestalt_trail")
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetSortOrder(2)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.AnimState:PlayAnimation("trail1")

	inst.Transform:SetScale(1.2, 1.2, 1.2)

	if not TheNet:IsDedicated() then
	end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	local anim = math.random(8)
	if anim > 1 then
	    inst.AnimState:PlayAnimation("trail"..anim)
	end

    inst.persists = false
    inst:DoTaskInTime(40 * FRAMES, inst.Remove)

    return inst
end

local function gestalt_head_fn()

    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddFollower()

    inst.AnimState:SetBank("brightmare_gestalt_head")
    inst.AnimState:SetBuild("medal_gestalt_head")
    inst.AnimState:PlayAnimation("idle", true)

    inst.Transform:SetFourFaced()

	inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.persists = false

    return inst
end

return Prefab("medal_gestalt", fn, assets, prefabs),
	Prefab("medal_gestalt_trail", gestalt_trail_fn, assets_trail),
	Prefab("medal_gestalt_head", gestalt_head_fn, assets_head)
