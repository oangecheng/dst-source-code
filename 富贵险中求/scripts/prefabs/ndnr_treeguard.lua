local brain = require "brains/ndnr_treeguardbrain"
local easing = require("easing")

local assets =
{
	Asset("ANIM", "anim/treeguard_walking.zip"),
	Asset("ANIM", "anim/treeguard_actions.zip"),
	Asset("ANIM", "anim/treeguard_attacks.zip"),
	Asset("ANIM", "anim/treeguard_idles.zip"),
	Asset("ANIM", "anim/ndnr_treeguard_build.zip"),
}

-- local prefabs =
-- {
-- 	"meat",
-- 	"log",
-- 	"character_fire",
--     "livinglog",
--     "treeguard_coconut",
-- }

SetSharedLootTable( 'ndnr_treeguard',
{
    {"livinglog",   1.0},
    {"livinglog",   1.0},
    {"livinglog",   1.0},
    {"livinglog",   1.0},
    {"livinglog",   1.0},
    {"livinglog",   1.0},
    {"monstermeat", 1.0},
    {"ndnr_coconut",     1.0},
    {"ndnr_coconut",     1.0},
})

local function SetTreeGuardScale(inst, scale)
    inst._scale = scale ~= nil and scale or 1

    inst.Transform:SetScale(inst._scale, inst._scale, inst._scale)
    inst.Physics:SetCapsule(.5 * inst._scale, 1)
    inst.DynamicShadow:SetSize(4 * inst._scale, 1.5 * inst._scale)

    inst.components.locomotor.walkspeed = 1.5 * inst._scale

    inst.components.combat:SetDefaultDamage(TUNING.LEIF_DAMAGE * inst._scale)
    inst.components.combat:SetRange(3 * inst._scale)

    local health_percent = inst.components.health:GetPercent()
    inst.components.health:SetMaxHealth(TUNING.LEIF_HEALTH * inst._scale)
    inst.components.health:SetPercent(health_percent, true)
end

local function onpreloadfn(inst, data)
    if data ~= nil and data.treeguardscale ~= nil then
        SetTreeGuardScale(inst, data.treeguardscale)
    end
end

local function OnLoad(inst, data)
    if data and data.hibernate then
        inst.components.sleeper.hibernate = true
    end
    if data and data.sleep_time then
         inst.components.sleeper.testtime = data.sleep_time
    end
    if data and data.sleeping then
         inst.components.sleeper:GoToSleep()
    end
end

local function OnSave(inst, data)
    data.treeguardscale = inst._scale
    if inst.components.sleeper:IsAsleep() then
        data.sleeping = true
        data.sleep_time = inst.components.sleeper.testtime
    end

    if inst.components.sleeper:IsHibernating() then
        data.hibernate = true
    end
end

local function CalcSanityAura(inst, observer)

	if inst.components.combat.target then
		return -TUNING.SANITYAURA_LARGE
	else
		return -TUNING.SANITYAURA_MED
	end

	return 0
end

local function OnBurnt(inst)
    if inst.components.propagator and inst.components.health and not inst.components.health:IsDead() then
        inst.components.propagator.acceptsheat = true
    end
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
end

-- local function OnAttack(inst, data)
--     local numshots = 3
--     if data.target then
--         for i = 0, numshots - 1 do
--             local offset = Vector3(math.random(-5, 5), math.random(-5, 5), math.random(-5, 5))
--             inst.components.ndnr_thrower:Throw(data.target:GetPosition() + offset)
--         end
--     end
-- end

local function SetRangeMode(inst)
    if inst.combatmode == "RANGE" then
        return
    end

    inst.combatmode = "RANGE"
    inst.components.combat:SetDefaultDamage(0)
    inst.components.combat:SetAttackPeriod(6)
    inst.components.combat:SetRange(20, 25)
    -- inst:ListenForEvent("onattackother", OnAttack)
end

local function SetMeleeMode(inst)
    if inst.combatmode == "MELEE" then
        return
    end

    inst.combatmode = "MELEE"
    inst.components.combat:SetDefaultDamage(TUNING.LEIF_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.LEIF_ATTACK_PERIOD)
    inst.components.combat:SetRange(20, 3)
    -- inst:RemoveEventCallback("onattackother", OnAttack)
end

local function MakeWeapon(inst)
    if inst.components.inventory ~= nil then
        local weapon = CreateEntity()
        weapon.entity:AddTransform()

        MakeInventoryPhysics(weapon)

        weapon:AddComponent("weapon")
        weapon.components.weapon:SetDamage(50)
        weapon.components.weapon:SetRange(inst.components.combat.attackrange, inst.components.combat.attackrange + 4)
        weapon.components.weapon:SetProjectile("ndnr_treeguard_coconut")

        weapon:AddComponent("inventoryitem")
        weapon.persists = false
        weapon.components.inventoryitem:SetOnDroppedFn(weapon.Remove)

        weapon:AddComponent("equippable")
        inst.weapon = weapon
        inst.components.inventory:Equip(inst.weapon)
        inst.components.inventory:Unequip(EQUIPSLOTS.HANDS)
    end
end

--Called from stategraph
local function LaunchProjectile(inst, targetpos)
    local x, y, z = inst.Transform:GetWorldPosition()

    local projectile = SpawnPrefab("ndnr_treeguard_coconut")
    projectile.Transform:SetPosition(x, y, z)

    --V2C: scale the launch speed based on distance
    --     because 15 does not reach our max range.
    local dx = targetpos.x - x
    local dz = targetpos.z - z
    local rangesq = dx * dx + dz * dz
    local maxrange = 25
    local speed = easing.linear(rangesq, 15, 3, maxrange * maxrange)
    projectile.components.complexprojectile:SetHorizontalSpeed(speed)
    projectile.components.complexprojectile:SetGravity(-15)
    projectile.components.complexprojectile:Launch(targetpos, inst, inst)
end

local function fn()

	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

	inst.DynamicShadow:SetSize( 4, 1.5 )
    inst.Transform:SetFourFaced()

    MakeCharacterPhysics(inst, 1000, .5)

    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("ndnr_treeguard")
    inst:AddTag("tree")
    inst:AddTag("largecreature")
	inst:AddTag("epic")

    inst.AnimState:SetBank("treeguard")
    inst.AnimState:SetBuild("ndnr_treeguard_build")
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst:AddComponent("talker")
    inst.components.talker.fontsize = 40
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.colour = Vector3(238 / 255, 69 / 255, 105 / 255)
    inst.components.talker.offset = Vector3(0, -700, 0)
    inst.components.talker.symbol = "fossil_chest"
    inst.components.talker:MakeChatter()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 1.5

    ------------------------------------------
    inst:SetStateGraph("SGndnr_treeguard")

    ------------------------------------------

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    MakeLargeBurnableCharacter(inst, "marker")
    inst.components.burnable.flammability = TUNING.LEIF_FLAMMABILITY
    inst.components.burnable:SetOnBurntFn(OnBurnt)
    inst.components.propagator.acceptsheat = true

    MakeHugeFreezableCharacter(inst, "marker")

    inst:AddComponent("inventory")
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.LEIF_HEALTH)

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.LEIF_DAMAGE)
    inst.components.combat.playerdamagepercent = TUNING.LEIF_DAMAGE_PLAYER_PERCENT
    inst.components.combat.hiteffectsymbol = "marker"
    inst.components.combat:SetRange(20, 25)
    inst.components.combat:SetAttackPeriod(TUNING.LEIF_ATTACK_PERIOD)
    -- inst.components.combat:SetRetargetFunction(2, WarriorRetarget)

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('ndnr_treeguard')

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()

    MakeWeapon(inst)

    inst:SetBrain(brain)

    inst.OnPreLoad = onpreloadfn
    inst.OnLoad = OnLoad
    inst.OnSave = OnSave

    inst.SetRange = SetRangeMode
    inst.SetMelee = SetMeleeMode
    inst.LaunchProjectile = LaunchProjectile
    inst.SetTreeGuardScale = SetTreeGuardScale

    inst:ListenForEvent("attacked", OnAttacked)

    return inst
end

return Prefab( "ndnr_treeguard", fn, assets)
