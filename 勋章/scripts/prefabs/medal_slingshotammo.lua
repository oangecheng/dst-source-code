--弹弓的临时仇恨系统，目标在打其他玩家或生物时，使用弹弓攻击不会吸引走目标的仇恨
local function no_aggro(attacker, target)
	local targets_target = target.components.combat ~= nil and target.components.combat.target or nil
	return targets_target ~= nil and targets_target:IsValid() and targets_target ~= attacker and attacker:IsValid()
			and (GetTime() - target.components.combat.lastwasattackedbytargettime) < 4
			and (targets_target.components.health ~= nil and not targets_target.components.health:IsDead())
end
--命中特效
local function ImpactFx(inst, attacker, target)
    if target ~= nil and target:IsValid() then
		local impactfx = SpawnPrefab(inst.ammo_def.impactfx)
		impactfx.Transform:SetPosition(target.Transform:GetWorldPosition())
				
		if inst.ammo_def.hit_sound ~= nil then
			inst.SoundEmitter:PlaySound(inst.ammo_def.hit_sound)
		end
    end
end
--命中后执行函数
local function OnAttack(inst, attacker, target)
	if target ~= nil and target:IsValid() and attacker ~= nil and attacker:IsValid() then
		if inst.ammo_def ~= nil and inst.ammo_def.onhit ~= nil then
			inst.ammo_def.onhit(inst, attacker, target)
		end
		ImpactFx(inst, attacker, target)
	end
end
--计算伤害前的击中函数，不抢仇恨
local function OnPreHit(inst, attacker, target)
	if target ~= nil and target.components.combat and attacker ~= nil then
		target.components.combat.temp_disable_aggro = no_aggro(attacker, target)
	end
end
--计算伤害后的击中函数，目标被标记为可
local function OnHit(inst, attacker, target)
    if target ~= nil and target:IsValid() and target.components.combat ~= nil then
		target.components.combat.temp_disable_aggro = false
	end
    inst:Remove()
end
--未命中函数
local function OnMiss(inst, owner, target)
    inst:Remove()
end
--定义射出的子弹实体
local function projectile_fn(ammo_def)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetFourFaced()

    MakeProjectilePhysics(inst)

    inst.AnimState:SetBank("slingshotammo")
    inst.AnimState:SetBuild("medalslingshotammo")
    inst.AnimState:PlayAnimation("spin_loop", true)
	if ammo_def.symbol ~= nil then
		inst.AnimState:OverrideSymbol("rock", "medalslingshotammo", ammo_def.symbol)
	end

    --projectile (from projectile component) added to pristine state for optimization
    inst:AddTag("projectile")

	if ammo_def.tags then
		for _, tag in pairs(ammo_def.tags) do
			inst:AddTag(tag)
		end
	end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

	inst.ammo_def = ammo_def

	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(ammo_def.damage)
	inst.components.weapon:SetOnAttack(OnAttack)
	

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(25)
    inst.components.projectile:SetHoming(false)
    inst.components.projectile:SetHitDist(1.5)
    -- inst.components.projectile:SetOnHitFn(OnPreHit)--鸽雷写的错误代码
	inst.components.projectile.onprehit=OnPreHit--这才是正确赋值
    inst.components.projectile:SetOnHitFn(OnHit)
    inst.components.projectile:SetOnMissFn(OnMiss)
    inst.components.projectile.range = 30
	inst.components.projectile.has_damage_set = true
	
	if ammo_def.extrafn then
		ammo_def.extrafn(inst)
	end

    return inst
end
--定义子弹道具实体
local function inv_fn(name,ammo_def)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetBank("slingshotammo")
    inst.AnimState:SetBuild("medalslingshotammo")
    inst.AnimState:PlayAnimation("idle")
	if ammo_def.symbol ~= nil then
		inst.AnimState:OverrideSymbol("rock", "medalslingshotammo", ammo_def.symbol)
	end

    inst:AddTag("molebait")
	inst:AddTag("slingshotammo")
	inst:AddTag("reloaditem_ammo")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("reloaditem")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
    inst.components.edible.hungervalue = 1
    inst:AddComponent("tradable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_TINYITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetSinks(true)
	inst.components.inventoryitem.imagename = name
	inst.components.inventoryitem.atlasname = "images/"..name..".xml"

    inst:AddComponent("bait")
    MakeHauntableLaunch(inst)

	if ammo_def.fuelvalue ~= nil then
		inst:AddComponent("fuel")
		inst.components.fuel.fuelvalue = ammo_def.fuelvalue
	end

	if ammo_def.onloadammo ~= nil and ammo_def.onunloadammo ~= nil then
		inst:ListenForEvent("ammoloaded", ammo_def.onloadammo)
		inst:ListenForEvent("ammounloaded", ammo_def.onunloadammo)
		inst:ListenForEvent("onremove", ammo_def.onunloadammo)
	end

    return inst
end


local ammo_prefabs = {}
for k, v in pairs(require("medal_defs/medal_slingshotammo_defs")) do
	if v.switch then
		local assets =
		{
		    Asset("ANIM", "anim/slingshotammo.zip"),
		    Asset("ANIM", "anim/medalslingshotammo.zip"),
			Asset("ATLAS", "images/"..k..".xml"),
			Asset("ATLAS_BUILD", "images/"..k..".xml",256),
		}
		
		v.impactfx = v.impactfx or "slingshotammo_hitfx_" .. (v.symbol or "rocks")

		if not v.no_inv_item then
			table.insert(ammo_prefabs, Prefab(k, function() return inv_fn(k,v) end, assets))
		end

		local prefabs =
		{
			"shatter",
		}
		table.insert(prefabs, v.impactfx)
		table.insert(ammo_prefabs, Prefab(k.."_proj", function() return projectile_fn(v) end, assets, prefabs))
	end
end


return unpack(ammo_prefabs)