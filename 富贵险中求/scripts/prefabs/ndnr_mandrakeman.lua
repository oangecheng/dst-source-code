local brain = require "brains/bunnymanbrain"

local assets =
{
    Asset("ANIM", "anim/ndnr_elderdrake_build.zip"),
	Asset("ANIM", "anim/elderdrake_basic.zip"),
	Asset("ANIM", "anim/elderdrake_actions.zip"),
	Asset("ANIM", "anim/elderdrake_attacks.zip"),

	Asset("SOUND", "sound/bunnyman.fsb"),
}

local prefabs =
{
    "meat",
    "monstermeat",
    "manrabbit_tail",
}

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 30

local function ontalk(inst, script)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/idle_med")
end

local function CalcSanityAura(inst, observer)

	if inst.beardlord then
        return -TUNING.SANITYAURA_MED
    end

    if inst.components.follower and inst.components.follower.leader == observer then
		return TUNING.SANITYAURA_SMALL
	end

	return 0
end


local function ShouldAcceptItem(inst, item)
    if inst:HasTag("grumpy") then
        return false
    end
    if item.components.equippable and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
        return true
    end

    if item.components.edible then

        if inst.components.eater:CanEat(item)
           and inst.components.follower.leader
           and inst.components.follower:GetLoyaltyPercent() > 0.9 then
            return false
        end

        return true
    end

end

local function OnGetItemFromPlayer(inst, giver, item)
    --I eat food
    if item.components.edible then
        if inst.components.eater:CanEat(item) then
            if inst.components.combat.target and inst.components.combat.target == giver then
                inst.components.combat:SetTarget(nil)
            elseif giver.components.leader then
				inst.SoundEmitter:PlaySound("dontstarve/common/makeFriend")
				giver.components.leader:AddFollower(inst)
                inst.components.follower:AddLoyaltyTime(TUNING.RABBIT_CARROT_LOYALTY)
            end
        end

        if inst.components.sleeper:IsAsleep() then
            inst.components.sleeper:WakeUp()
        end
    end


    --I wear hats
    if item.components.equippable and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
        local current = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
        if current then
            inst.components.inventory:DropItem(current)
        end

        inst.components.inventory:Equip(item)
        inst.AnimState:Show("hat")
    end
end

local function OnRefuseItem(inst, item)
    inst.sg:GoToState("refuse")
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end


local function OnAttacked(inst, data)
    local attacker = data.attacker
    inst.components.combat:SetTarget(attacker)
    inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, function(dude) return dude.prefab == inst.prefab end, MAX_TARGET_SHARES)
end

local function OnNewTarget(inst, data)
    inst.components.combat:ShareTarget(data.target, SHARE_TARGET_DIST, function(dude) return dude.prefab == inst.prefab end, MAX_TARGET_SHARES)
end

local function is_mandrake(item)
    return item:HasTag("mandrake")
end

local function RetargetFn(inst)
    local defenseTarget = inst
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    if home and inst:GetDistanceSqToInst(home) < TUNING.NDNR_MANDRAKEMAN_DEFEND_DIST*TUNING.NDNR_MANDRAKEMAN_DEFEND_DIST then
        defenseTarget = home
    end
    local dist = TUNING.NDNR_MANDRAKEMAN_TARGET_DIST
    local invader = FindEntity(defenseTarget or inst, dist, function(guy)
        return guy:HasTag("player")
                and not guy:HasTag("playerghost")
                and not guy:HasTag("mandrakeman")
                and not guy:HasTag("plantkin")
                and (guy:HasTag("player") and inst:HasTag("grumpy"))
    end)
    return invader
end

local function KeepTargetFn(inst, target)
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    if home then
        return home:GetDistanceSqToInst(target) < TUNING.NDNR_MANDRAKEMAN_DEFEND_DIST*TUNING.NDNR_MANDRAKEMAN_DEFEND_DIST
               and home:GetDistanceSqToInst(inst) < TUNING.NDNR_MANDRAKEMAN_DEFEND_DIST*TUNING.NDNR_MANDRAKEMAN_DEFEND_DIST
    end
    return inst.components.combat:CanTarget(target)
end


local function giveupstring(combatcmp, target)
    return STRINGS.NDNR_MANDRAKEMAN_GIVEUP[math.random(#STRINGS.NDNR_MANDRAKEMAN_GIVEUP)]
end

local function battlecry(combatcmp, target)
    if target and target.components.inventory then
        local item = target.components.inventory:FindItem(function(item) return item:HasTag("mandrake") end )
        if item then
            return STRINGS.NDNR_MANDRAKEMAN_MANDRAKE_BATTLECRY[math.random(#STRINGS.NDNR_MANDRAKEMAN_MANDRAKE_BATTLECRY)]
        end
    end
    return STRINGS.NDNR_MANDRAKEMAN_BATTLECRY[math.random(#STRINGS.NDNR_MANDRAKEMAN_BATTLECRY)]
end

local function DoAreaEffect(inst, knockout)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/death")
    local pos = Vector3(inst.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, TUNING.MANDRAKE_SLEEP_RANGE)
    for k,v in pairs(ents) do
        if v.components.sleeper then
            v.components.sleeper:AddSleepiness(10, TUNING.MANDRAKE_SLEEP_TIME)
        elseif v:HasTag("player") and knockout then
            v.sg:GoToState("wakeup")
            v.components.talker:Say(GetString(inst.prefab, "ANNOUNCE_KNOCKEDOUT") )
        end
    end
end

local function deathscream(inst)
    if TheWorld.state.moonphase == "full" and TheWorld.state.isnight then
        local x, y, z = inst.Transform:GetWorldPosition()

        local ent = SpawnPrefab("mandrake_planted")
        ent.Transform:SetPosition(x, y, z)
    end

    DoAreaEffect(inst)
end

local function transform(inst,grumpy)
    local anim = inst.AnimState
    if grumpy then
        inst.AnimState:Show("head_angry")
        inst.AnimState:Hide("head_happy")
        inst:AddTag("grumpy")
    else
        inst.AnimState:Hide("head_angry")
        inst.AnimState:Show("head_happy")
        inst.sg:GoToState("happy")
        inst:RemoveTag("grumpy")
    end
end

local function transformtest(inst)
    if TheWorld.state.moonphase == "full" and TheWorld.state.isnight then
        if inst:HasTag("grumpy") then
            inst:DoTaskInTime(1+(math.random()*1) , function() transform(inst) end )
        end
    else
        if not inst:HasTag("grumpy") then
            inst:DoTaskInTime(1+(math.random()*1) , function() transform(inst,true) end )
        end
    end
end

local function OnWake(inst)
     transformtest(inst)
end

local function OnSleep(inst)
	 if inst.checktask then
	 	inst.checktask:Cancel()
	 	inst.checktask = nil
	 end
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddNetwork()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.DynamicShadow:SetSize(1.5, .75)
    inst.Transform:SetFourFaced()
    inst.Transform:SetScale(1, 1, 1)

    inst.entity:AddLightWatcher()

    inst.AnimState:SetBuild("ndnr_elderdrake_build")
    inst.AnimState:SetBank("elderdrake")

    MakeCharacterPhysics(inst, 50, .5)
    -- MakePoisonableCharacter(inst)

    inst:AddTag("character")
    inst:AddTag("pig")
    inst:AddTag("mandrakeman")
    inst:AddTag("scarytoprey")

    inst:AddTag("grumpy")

    inst.AnimState:PlayAnimation("idle_loop")
    inst.AnimState:Hide("hat")
    inst.AnimState:Hide("head_happy")

    inst:AddComponent("talker")
    inst.components.talker.ontalk = ontalk
    inst.components.talker.fontsize = 24
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.offset = Vector3(0,-500,0)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = TUNING.NDNR_MANDRAKEMAN_RUN_SPEED --5
    inst.components.locomotor.walkspeed = TUNING.NDNR_MANDRAKEMAN_WALK_SPEED --3

    ------------------------------------------
    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODGROUP.VEGETARIAN }, { FOODGROUP.VEGETARIAN })
    inst.components.eater:SetCanEatRaw()

    ------------------------------------------
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "elderdrake_torso"
    inst.components.combat.panic_thresh = TUNING.NDNR_MANDRAKEMAN_PANIC_THRESH

    inst.components.combat.GetBattleCryString = battlecry
    inst.components.combat.GetGiveUpString = giveupstring

    MakeMediumBurnableCharacter(inst, "elderdrake_torso")

    inst:AddComponent("named")
    inst.components.named.possiblenames = STRINGS.NDNR_MANDRAKEMANNAMES
    inst.components.named:PickNewName()

    ------------------------------------------
    inst:AddComponent("follower")
    inst.components.follower.maxfollowtime = TUNING.PIG_LOYALTY_MAXTIME
    ------------------------------------------
    inst:AddComponent("health")
    inst.components.health:StartRegen(TUNING.NDNR_MANDRAKEMAN_HEALTH_REGEN_AMOUNT, TUNING.NDNR_MANDRAKEMAN_HEALTH_REGEN_PERIOD)

    ------------------------------------------

    inst:AddComponent("inventory")

    ------------------------------------------

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"livinglog","livinglog"})
    --inst.components.lootdropper.numrandomloot = 1

    ------------------------------------------

    inst:AddComponent("knownlocations")

    ------------------------------------------

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem

    ------------------------------------------

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    ------------------------------------------

    inst:AddComponent("sleeper")

    ------------------------------------------
    MakeMediumFreezableCharacter(inst, "pig_torso")

    ------------------------------------------

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = function(inst)
        if inst.components.follower.leader ~= nil then
            return "FOLLOWER"
        end
    end
    ------------------------------------------

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("newcombattarget", OnNewTarget)

	--inst.components.werebeast:SetOnWereFn(SetBeardlord)
	--inst.components.werebeast:SetOnNormaleFn(SetNormalRabbit)

    --CheckTransformState(inst)
	inst.OnEntityWake = OnWake
	inst.OnEntitySleep = OnSleep


    inst.components.sleeper:SetResistance(2)
    inst.components.sleeper.nocturnal = true

    inst.components.combat:SetDefaultDamage(TUNING.NDNR_MANDRAKEMAN_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.NDNR_MANDRAKEMAN_ATTACK_PERIOD)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst.components.combat:SetRetargetFunction(3, RetargetFn)

    inst.components.locomotor.runspeed = TUNING.NDNR_MANDRAKEMAN_RUN_SPEED
    inst.components.locomotor.walkspeed = TUNING.NDNR_MANDRAKEMAN_WALK_SPEED

    inst.components.health:SetMaxHealth(TUNING.NDNR_MANDRAKEMAN_HEALTH)

    inst:ListenForEvent("death", deathscream)

    inst:WatchWorldState("isnight", function(world, data) transformtest(inst) end)
    inst:WatchWorldState("isday", function(world, data) transformtest(inst) end)


    inst.components.trader:Enable()
    --inst.Label:Enable(true)
    --inst.components.talker:StopIgnoringAll()

    inst:SetBrain(brain)
    inst:SetStateGraph("SGndnr_mandrakeman")

    transformtest(inst)

    return inst
end


return Prefab("ndnr_mandrakeman", fn, assets, prefabs)
