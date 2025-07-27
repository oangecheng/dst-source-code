local SpDamageUtil = require("components/spdamageutil")

local assets =
{
	Asset("ANIM", "anim/shadow_thrall_projectile_fx.zip"),
}

local prefabs =
{
	"fused_shadeling_bomb_scorch",
}

local AOE_RANGE = 1
local AOE_RANGE_PADDING = 3
local AOE_TARGET_MUSTHAVE_TAGS = { "_combat" }
local AOE_TARGET_CANT_TAGS = { "INLIMBO", "flight", "invisible", "notarget", "noattack", "chaos_creature"}

local MIASMA_RADIUS = math.ceil(SQRT2 * TUNING.MIASMA_SPACING * TILE_SCALE / 2)--瘴气范围

--生成瘴气
local function SpawnMiasma(inst,x, y, z)
	local miasa = SpawnPrefab("miasma_cloud")
	if miasa then
		miasa.Transform:SetPosition(x, 0, z)
		miasa.persists = false--重载后消失
		if inst and inst.shooter then
			miasa:ListenForEvent("onremove", function()
				miasa:Remove()
			end, inst.shooter)--驱光遗骸消失则瘴气同步消失
			if inst.shooter.CountMiasma then
				inst.shooter:CountMiasma()--统计瘴气数量
			end
		end
	end
end

local function OnHit(inst)--, attacker, target)
	inst:RemoveComponent("complexprojectile")
	inst:ListenForEvent("animover", inst.Remove)
	inst.AnimState:PlayAnimation("projectile_impact")
	inst.DynamicShadow:Enable(false)
	local playsfx = true
	if inst.sfx ~= nil then
		if inst.sfx.played then
			playsfx = false
		else
			inst.sfx.played = true
		end
	end
	if playsfx then
		inst.SoundEmitter:PlaySound("rifts2/thrall_wings/projectile")
	end

	local x, y, z = inst.Transform:GetWorldPosition()
	for i, v in ipairs(TheSim:FindEntities(x, y, z, AOE_RANGE + AOE_RANGE_PADDING, AOE_TARGET_MUSTHAVE_TAGS, AOE_TARGET_CANT_TAGS)) do
		if not (inst.targets ~= nil and inst.targets[v]) and
			v:IsValid() and not v:IsInLimbo() and
			not (v.components.health ~= nil and v.components.health:IsDead())
			then
			local range = AOE_RANGE + v:GetPhysicsRadius(0)
			if v:GetDistanceSqToPoint(x, y, z) < range * range then
				local spdmg = SpDamageUtil.CollectSpDamage(inst)
				local attacker = inst.owner ~= nil and inst.owner:IsValid() and inst.owner or inst
				v.components.combat:GetAttacked(attacker, TUNING_MEDAL.MEDAL_SHADOWTHRALL_SCREAMER_DAMAGE, nil, nil, spdmg)
				if inst.targets ~= nil then
					inst.targets[v] = true
				end
			end
		end
	end
	--生成瘴气
	if inst.spawn_miasma then
		local x, y, z = inst.Transform:GetWorldPosition()
		--防止在同一位置生成过多，保持相对均匀的密度
		if TheWorld and TheWorld.components.miasmamanager and TheWorld.components.miasmamanager:GetMiasmaAtPoint(x, 0, z) == nil then
			SpawnMiasma(inst,x, y, z)
		elseif FindEntity(inst, MIASMA_RADIUS, nil, {"miasma"}, nil, nil) == nil then
			SpawnMiasma(inst,x, y, z)
		end
	end
	--生成绝望螨
	if inst.parasitic_target and inst.parasitic_target:IsValid() then
		for i=1,2 do
			local bomb = SpawnPrefab("fused_shadeling_bomb")
			if bomb then
				bomb.Transform:SetPosition(x, y, z)
				bomb:PushEvent("setexplosiontarget", inst.parasitic_target)
				bomb.divisionable = inst.divisionable--可分裂
				--减少孵化时间
				local lefttime = bomb.components.timer and bomb.components.timer:GetTimeLeft("spawn_delay")
				if lefttime then
					bomb.components.timer:SetTimeLeft("spawn_delay", math.clamp(lefttime-2,0.5,1))
				end
				--移速调整
				if inst.bomb_speed and bomb.components.locomotor then
					bomb.components.locomotor.walkspeed = inst.bomb_speed
				end
				bomb.chaos_creature = true--混沌生物
			end
		end
	end

	local scorch = SpawnPrefab("fused_shadeling_bomb_scorch")
	scorch.Transform:SetPosition(x, 0, z)
	scorch.Transform:SetScale(.9, .9, .9)
end

local function OnLaunch(inst, attacker)
	inst.owner = attacker
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()

	inst.DynamicShadow:SetSize(.8, .8)

	inst.entity:AddPhysics()
	inst.Physics:SetMass(1)
	inst.Physics:SetFriction(0)
	inst.Physics:SetDamping(0)
	inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
	inst.Physics:ClearCollisionMask()
	inst.Physics:CollidesWith(COLLISION.GROUND)
	inst.Physics:SetCapsule(.2, .2)

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("shadow_aligned")

	inst.Transform:SetSixFaced()

	inst.AnimState:SetBank("shadow_thrall_projectile_fx")
	inst.AnimState:SetBuild("shadow_thrall_projectile_fx")
	inst.AnimState:PlayAnimation("projectile_pre")
	inst.AnimState:SetLightOverride(1)

	--projectile (from complexprojectile component) added to pristine state for optimization
	inst:AddTag("projectile")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.AnimState:PushAnimation("projectile_loop")
	inst.AnimState:PushAnimation("idle_loop")

	inst:AddComponent("complexprojectile")
	inst.components.complexprojectile:SetHorizontalSpeed(15)
	inst.components.complexprojectile:SetGravity(-35)
	inst.components.complexprojectile:SetLaunchOffset(Vector3(.25, 3, 0))
	inst.components.complexprojectile:SetOnLaunch(OnLaunch)
	inst.components.complexprojectile:SetOnHit(OnHit)

	inst:AddComponent("medal_chaosdamage")--混沌伤害
	inst.components.medal_chaosdamage:SetBaseDamage(TUNING_MEDAL.MEDAL_SHADOWTHRALL_SCREAMER_CHAOS_DAMAGE)

	--inst.targets = nil
	--inst.sfx = nil
	inst.persists = false

	return inst
end

return Prefab("medal_shadowthrall_projectile_fx", fn, assets, prefabs)
