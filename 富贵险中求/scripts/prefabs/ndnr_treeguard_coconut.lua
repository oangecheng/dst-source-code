local assets=
{
	Asset("ANIM", "anim/ndnr_coconut_cannon.zip"),
}

-- local prefabs =
-- {
-- 	"small_puff_light",
-- 	"coconut_chunks",
-- 	"bombsplash",
-- }

local function onthrown(inst, thrower, pt, time_to_target)
    inst.Physics:SetFriction(.2)
	inst.Transform:SetFourFaced()
	inst:FacePoint(pt:Get())
    inst.AnimState:PlayAnimation("throw", true)

    -- local shadow = SpawnPrefab("warningshadow")
    -- shadow.Transform:SetPosition(pt:Get())
    -- shadow:shrink(time_to_target, 1.75, 0.5)

end

local function onhit(inst, attacker, target)
	local scale = (attacker and attacker._scale) and attacker._scale or 1
	local pos = inst:GetPosition()

	local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 1.5)

	for k,v in pairs(ents) do
		if v.components.combat and v ~= inst and v.prefab ~= "ndnr_treeguard" then
			v.components.combat:GetAttacked(attacker, 50 * scale)
		end
	end

	local pt = inst:GetPosition()
	-- if inst:GetIsOnWater() then
	-- 	local splash = SpawnPrefab("ndnr_bombsplash")
	-- 	splash.Transform:SetPosition(pos.x, pos.y, pos.z)

		-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/cannonball_impact")
		-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/seacreature_movement/splash_large")

	-- else
		local smoke = SpawnPrefab("small_puff")

		local other = nil

		if math.random() < 0.01 then
			other = SpawnPrefab("ndnr_coconut")
		else
			other = SpawnPrefab("ground_chunks_breaking")
		end
		smoke.Transform:SetPosition(pt:Get())
		other.Transform:SetPosition(pt:Get())
	-- end
	inst:Remove()
end

local function onremove(inst)
	if inst.TrackHeight then
		inst.TrackHeight:Cancel()
		inst.TrackHeight = nil
	end
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("ndnr_coconut_cannon")
	inst.AnimState:SetBuild("ndnr_coconut_cannon")
	inst.AnimState:PlayAnimation("throw", true)

	inst:AddTag("NOCLICK")
	inst:AddTag("projectile")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.persists = false

	inst:AddComponent("complexprojectile")
	inst.components.complexprojectile:SetHorizontalSpeed(25)
    inst.components.complexprojectile:SetGravity(-15)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(2, 5, 0))
    inst.components.complexprojectile:SetOnHit(onhit)

	inst.OnRemoveEntity = onremove

	return inst
end

return Prefab("ndnr_treeguard_coconut", fn, assets)