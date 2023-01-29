require "prefabutil"

local assets = {
    Asset("ANIM", "anim/ndnr_lifeplant.zip"),
    Asset("ANIM", "anim/ndnr_lifeplant_fx.zip"),
    -- Asset("MINIMAP_IMAGE", "lifeplant"),
    Asset("IMAGE", "images/ndnr_lifeplant.tex"),
    Asset("ATLAS", "images/ndnr_lifeplant.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_lifeplant.xml", 256),
}

local prefabs = {"collapse_small"}

local INTENSITY = .5

local function fadein(inst)
    inst.components.fader:StopAll()
    inst.Light:Enable(true)
    if inst:IsAsleep() then
        inst.Light:SetIntensity(INTENSITY)
    else
        inst.Light:SetIntensity(0)
        inst.components.fader:Fade(0, INTENSITY, 3 + math.random() * 2, function(v) inst.Light:SetIntensity(v) end)
    end
end

local function fadeout(inst)
    inst.components.fader:StopAll()
    if inst:IsAsleep() then
        inst.Light:SetIntensity(0)
    else
        inst.components.fader:Fade(INTENSITY, 0, .75 + math.random() * 1, function(v) inst.Light:SetIntensity(v) end)
    end
end

local function onburnt(inst)
    local ash = SpawnPrefab("ash")
    ash.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function onplanted(inst, fountain)
    
    inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("idle_loop", true)
    if fountain then inst.fountain = fountain end
    -- inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/flower_of_life/plant")
    -- inst.components.resurrector:OnBuilt(GetPlayer())

    -- 种下后立即进入作祟CD状态
    if inst.components.hauntable and inst:IsValid() then
        local hauntable = inst.components.hauntable
        hauntable.haunted = true
        hauntable.cooldowntimer = hauntable.cooldown or TUNING.HAUNT_COOLDOWN_SMALL
        hauntable:StartFX(true)
        hauntable:StartShaderFx()
        hauntable.inst:StartUpdatingComponent(hauntable)
    end
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or inst:HasTag("fire") then data.burnt = true end
    return
end

local function onload(inst, data)
    if data and data.burnt then inst.components.burnable.onburnt(inst) end
end

local function OnLoadPostPass(inst, newents, data) end

local function OnRemoved(inst)
    if inst._sparkle then inst._sparkle:Remove() end
end

local function CalcSanityAura(inst, observer) return TUNING.SANITYAURA_MED end

local function TrySpawnFlower(inst)
    local pt = inst:GetPosition()
    local theta = math.random() * 2 * PI
    local radius = math.floor(math.random(1,8))
    pt.x = pt.x + math.cos(theta)*radius
    pt.z = pt.z + math.sin(theta)*radius
    local butterfly = SpawnPrefab("butterfly")
    if TheWorld.Map:CanDeployPlantAtPoint(pt, butterfly) then
        local flower = SpawnPrefab("flower")
        flower.Transform:SetPosition(pt.x, pt.y, pt.z)
    end
    butterfly:Remove()
end

local function onnear(inst, player)
    if not inst.reserrecting and not player:HasTag("playerghost")  and player:IsValid() then
        inst.starvetask = inst:DoPeriodicTask(0.5, function()
            if player:IsValid() then
                local sparkle = SpawnPrefab("ndnr_lifeplant_sparkle")
                inst._sparkle = sparkle
                sparkle.Transform:SetPosition(player.Transform:GetWorldPosition())
            end
        end)
        inst.starvetask2 = inst:DoPeriodicTask(2, function() player.components.hunger:DoDelta(-1) end)

        if inst.spawnflowertask == nil then
            inst.spawnflowertask = inst:DoPeriodicTask(3, TrySpawnFlower)
        end
    end
end

local function onfar(inst)
    if inst.starvetask then
        inst.starvetask:Cancel()
        inst.starvetask = nil

        inst.starvetask2:Cancel()
        inst.starvetask2 = nil

        if inst._sparkle then inst._sparkle:Remove() end

        if inst.spawnflowertask then
            inst.spawnflowertask:Cancel()
            inst.spawnflowertask = nil
        end
    end
end

local function dig_up(inst, chopper)
    local drop = inst.components.lootdropper:SpawnLootPrefab("ndnr_waterdrop")
    local fx = SpawnPrefab("collapse_small")
    fx:SetMaterial("none")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function manageidle(inst)
    local anim = "idle_gargle"
    if math.random() < 0.5 then anim = "idle_vanity" end

    inst.AnimState:PlayAnimation(anim)
    inst.AnimState:PushAnimation("idle_loop", true)

    inst:DoTaskInTime(8 + (math.random() * 20), function() inst.manageidle(inst) end)
end

local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddSoundEmitter()

    MakeObstaclePhysics(inst, .3)

    inst.MiniMapEntity:SetIcon("ndnr_lifeplant.tex")

    inst.AnimState:SetBank("lifeplant")
    inst.AnimState:SetBuild("ndnr_lifeplant")
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst:AddTag("lifeplant")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("inspectable")
    -- inst:AddComponent("resurrector")
    -- inst.components.resurrector.active = true
    -- inst.components.resurrector.doresurrect = doresurrect
    -- inst.components.resurrector.makeusedfn = makeused
    -- inst.components.resurrector.penalty = 1

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(dig_up)

    MakeSnowCovered(inst)

    inst:AddComponent("burnable")
    inst.components.burnable:SetFXLevel(3)
    inst.components.burnable:SetBurnTime(10)
    inst.components.burnable:AddBurnFX("fire", Vector3(0, 0, 0))
    inst.components.burnable:SetOnBurntFn(onburnt)
    MakeLargePropagator(inst)

    inst:AddComponent("fader")

    local light = inst.entity:AddLight()
    inst.Light:SetIntensity(INTENSITY)
    inst.Light:SetColour(180 / 255, 195 / 255, 150 / 255)
    inst.Light:SetFalloff(0.9)
    inst.Light:SetRadius(2)

    inst.Light:Enable(true)

    fadein(inst)

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    inst:AddComponent("playerprox")

    inst.components.playerprox:SetDist(6, 7)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)

    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.OnSave = onsave
    inst.OnLoad = onload
    inst.OnLoadPostPass = OnLoadPostPass
    inst.onplanted = onplanted

    inst:ListenForEvent("onremove", OnRemoved)
    inst.manageidle = manageidle
    inst:DoTaskInTime(8 + (math.random() * 20), function() inst.manageidle(inst) end)

    inst.AnimState:SetMultColour(0.9, 0.9, 0.9, 1)

    MakeHauntable(inst, TUNING.TOTAL_DAY_TIME)
    inst.components.hauntable:SetOnHauntFn(function(inst, haunter)
        if haunter:HasTag("player") and haunter:HasTag("playerghost") then
            haunter:PushEvent("respawnfromghost", { source = inst })
            -- haunter.components.health:DeltaPenalty(-TUNING.MAX_HEALING_NORMAL)

            -- 魔力花被作祟时，令半径30距离内所有魔力花也进入被作祟的状态
            local x, y, z = inst.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x, y, z, 30, {"lifeplant"}, {"haunted"}) -- or we could include a flag to the search?
            for i, v in ipairs(ents) do
                if v.prefab == "ndnr_lifeplant" and v.components.hauntable and v:IsValid() then
                    local hauntable = v.components.hauntable
                    hauntable.haunted = true
                    hauntable.cooldowntimer = hauntable.cooldown or TUNING.HAUNT_COOLDOWN_SMALL
                    hauntable:StartFX(true)
                    hauntable:StartShaderFx()
                    hauntable.inst:StartUpdatingComponent(hauntable)
                end
            end
        end
    end)
    return inst
end

local function testforplant(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	local ent = TheSim:FindFirstEntityWithTag("lifeplant")

	if ent and ent:GetDistanceSqToInst(inst) < 1 then
		inst:Remove()
	end
end

local function onspawn(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	local ent = TheSim:FindFirstEntityWithTag("lifeplant")
	if ent then
		local x2,y2,z2 = ent.Transform:GetWorldPosition()
    	local angle = inst:GetAngleToPoint(x2, y2, z2)
    	inst.Transform:SetRotation(angle)

		inst.components.locomotor:WalkForward()
		inst:DoPeriodicTask(0.1,function() testforplant(inst) end)
	else
		inst:Remove()
	end
end

local function sparklefn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    local physics = inst.entity:AddPhysics()
    physics:SetMass(1)
    physics:SetCapsule(0.3, 1)
    inst.Physics:SetFriction(0)
    inst.Physics:SetDamping(5)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)

    inst.AnimState:SetBank("lifeplant_fx")
    inst.AnimState:SetBuild("ndnr_lifeplant_fx")
    inst.AnimState:PlayAnimation("single" .. math.random(1, 3), true)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst:AddTag("flying")
    inst:AddTag("NOCLICK")
    inst:AddTag("FX")
    -- inst:AddTag("DELETE_ON_INTERIOR")
    inst.persists = false

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 2
    inst.components.locomotor:SetTriggersCreep(false)

    inst:DoTaskInTime(0, function(inst) onspawn(inst) end)
    inst.OnEntitySleep = function(inst) inst:Remove() end

    return inst
end

return Prefab("ndnr_lifeplant", fn, assets, prefabs),
       Prefab("ndnr_lifeplant_sparkle", sparklefn, assets, prefabs)
