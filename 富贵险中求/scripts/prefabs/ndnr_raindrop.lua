local assets =
{
	Asset("ANIM", "anim/raindrop.zip"),
}

local function OnHitWaterstreak(inst, attacker, target)
    -- local hpx, hpy, hpz = inst.Transform:GetWorldPosition()

    -- SpawnPrefab("waterstreak_burst").Transform:SetPosition(hpx, hpy, hpz)

    -- if not TheWorld.Map:IsPassableAtPoint(hpx, hpy, hpz) then
    --     SpawnPrefab("ocean_splash_small2").Transform:SetPosition(hpx, hpy, hpz)
    -- end

    inst.components.wateryprotection:SpreadProtection(inst, TUNING.WATERSTREAK_AOE_DIST)
    inst:Remove()
end

local function fn()
	local inst = CreateEntity()

    inst.entity:SetCanSleep(false)
    inst.entity:AddNetwork()
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddPhysics()

    inst.Physics:SetMass(1)
    inst.Physics:SetFriction(0)
    inst.Physics:SetDamping(0)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
    inst.Physics:SetCapsule(0.2, 0.2)
    inst.Physics:SetDontRemoveOnSleep(true)

    inst.AnimState:SetBuild("raindrop")
    inst.AnimState:SetBank("raindrop")
	inst.AnimState:PlayAnimation("anim")

    inst:AddTag("projectile")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst:AddComponent("locomotor")
    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetOnHit(OnHitWaterstreak)

    inst:AddComponent("wateryprotection")
    inst.components.wateryprotection.extinguishheatpercent = TUNING.FIRESUPPRESSOR_EXTINGUISH_HEAT_PERCENT
    inst.components.wateryprotection.addwetness = 5 -- TUNING.WATERBALLOON_ADD_WETNESS
    inst.components.wateryprotection:AddIgnoreTag("player")

	-- inst:ListenForEvent("animover", inst.Remove)

    return inst
end

return Prefab("ndnr_raindrop", fn, assets)