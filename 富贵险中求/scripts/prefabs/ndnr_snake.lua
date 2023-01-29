local assets = {
    -- Asset("ANIM", "anim/snake_build.zip"),
    Asset("ANIM", "anim/snake_yellow_build.zip"),
    Asset("ANIM", "anim/snake_basic.zip"),
    Asset("ATLAS", "images/ndnr_snake.xml"),
    Asset("IMAGE", "images/ndnr_snake.tex"),
    Asset("ATLAS_BUILD", "images/ndnr_snake.xml", 256),
}

local WAKE_TO_FOLLOW_DISTANCE = 8
local SLEEP_NEAR_HOME_DISTANCE = 10
local SHARE_TARGET_DIST = 30
local HOME_TELEPORT_DIST = 30
local SNAKE_KEEP_TARGET_DIST = 15

local brain = require "brains/ndnr_snakebrain"

local function keeptargetfn(inst, target)
    return target ~= nil and target.components.combat ~= nil and target.components.health ~= nil and
               not target.components.health:IsDead()
end

local function NormalRetarget(inst)
    local dist = 8
    local notags = {"FX", "NOCLICK", "INLIMBO", "wall", "snake", "structure", "aquatic", "ndnr_snakefriend"}
    return FindEntity(inst, dist, function(guy)
        return inst.components.combat:CanTarget(guy)
    end, nil, notags)
end

local function KeepTarget(inst, target)
    return inst.components.combat:CanTarget(target) and inst:GetDistanceSqToInst(target) <=
               (SNAKE_KEEP_TARGET_DIST * SNAKE_KEEP_TARGET_DIST) and not target:HasTag("aquatic")
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, SHARE_TARGET_DIST, function(dude)
        return dude:HasTag("snake") and not dude.components.health:IsDead()
    end, 5)
end

local function OnAttackOther(inst, data)
    inst.components.combat:ShareTarget(data.target, SHARE_TARGET_DIST, function(dude)
        return dude:HasTag("snake") and not dude.components.health:IsDead()
    end, 5)
end

local function SanityAura(inst, observer)
    if observer.prefab == "webber" then
        return 0
    end
    return -TUNING.SANITYAURA_SMALL
end

local function OnNewTarget(inst, data)
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local function DoReturn(inst)
    if inst.components.homeseeker then
        inst.components.homeseeker:GoHome(inst)
    end
end

local function OnDay(inst)
    if inst:IsAsleep() then
        DoReturn(inst)
    end
end

-- local function OnIsCaveDay(inst, iscaveday)
--     if not iscaveday then
--         inst.components.sleeper:WakeUp()
--     elseif inst:IsAsleep() then
--         DoReturn(inst)
--     end
-- end

local function OnEntitySleep(inst)
    if TheWorld.state.iscaveday then
        DoReturn(inst)
    end
end

local function OnSave(inst, data)
end

local function OnLoad(inst, data)
end

local function onhitother(inst, other, damage)
    if other:HasTag("player") and not other:HasTag("playerghost") and other.prefab ~= "wx78" then
        if not other:HasTag("ndnr_poisoning") and math.random() < .5 and not (other.components.rider ~= nil and other.components.rider:IsRiding()) then
            if other.components.debuffable then
                other.components.debuffable:AddDebuff("ndnr_poisondebuff", "ndnr_poisondebuff")
            end
        end
    end
end

local function GetCookProductFn(inst, cooker, chef)
    return "cookedmonstermeat"
end

local function OnCookedFn(inst, cooker, chef)
    inst.SoundEmitter:PlaySound(inst.sounds.hurt)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 1, .3)

    inst.DynamicShadow:SetSize(1.5, .75)
    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("snake")
    inst.AnimState:SetBuild("snake_yellow_build")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("cavedweller")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("scarytoprey")
    inst:AddTag("canbetrapped")
    inst:AddTag("smallcreature")
    inst:AddTag("snake")
    inst:AddTag("drop_inventory_onpickup")
    inst:AddTag("drop_inventory_onmurder")

    MakeFeedableSmallLivestockPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = 3

    inst:SetStateGraph("SGndnr_snake")

    inst:AddComponent("lootdropper")
	inst.components.lootdropper:AddRandomLoot("monstermeat", 1.00)
	inst.components.lootdropper:AddRandomLoot("ndnr_snakeoil", 0.05)
	inst.components.lootdropper:AddRandomLoot("ndnr_venomgland", 0.1)
	inst.components.lootdropper:AddRandomLoot("ndnr_snakeskin", 0.2)
	inst.components.lootdropper.numrandomloot = math.random(0, 1) -- 随机0或1

    MakeMediumBurnableCharacter(inst, "body")
    MakeMediumFreezableCharacter(inst, "body")
    inst.components.burnable.flammability = .33

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT }) -- only eat meat
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater:SetStrongStomach(true) -- can eat monster meat!
    inst.components.eater:SetCanEatRawMeat(true)

    inst:AddComponent("health")
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(20)
    inst.components.combat:SetAttackPeriod(3)
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)
    inst.components.combat:SetRetargetFunction(3, NormalRetarget)
    -- inst.components.combat:SetHurtSound("dontstarve_DLC002/creatures/snake/hurt")
    inst.components.combat:SetRange(2, 3)
    inst.components.combat.onhitotherfn = onhitother

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = SanityAura

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem.canbepickedupalive = true
    inst.components.inventoryitem:SetSinks(true)
    inst.components.inventoryitem.atlasname = "images/ndnr_snake.xml"

    inst:AddComponent("cookable")
    inst.components.cookable.product = GetCookProductFn
    inst.components.cookable:SetOnCookedFn(OnCookedFn)

    inst:AddComponent("knownlocations")
    inst:AddComponent("inspectable")

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetNocturnal(true)

    inst:SetBrain(brain)

    inst:ListenForEvent("newcombattarget", OnNewTarget)

    inst.OnEntitySleep = OnEntitySleep

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    MakeFeedableSmallLivestock(inst, TUNING.SPIDER_PERISH_TIME)
    MakeHauntablePanic(inst)

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("onattackother", OnAttackOther)

    -- inst:WatchWorldState("isnight", OnIsCaveDay)
    -- inst:WatchWorldState("iscaveday", OnIsCaveDay)
    inst:WatchWorldState("isday", OnDay)

    return inst
end

return Prefab("ndnr_snake", fn, assets)
