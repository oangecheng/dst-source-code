local assets =
{
    Asset("ANIM", "anim/charged_particle.zip"),
    Asset("ANIM", "anim/medal_spacetime_spark.zip"),
}

local prefabs =
{
    "medal_spark_shock_fx",
    "medal_time_slider",
}

local brain = require "brains/sporebrain"

--移除
local function depleted(inst)
    if inst:IsInLimbo() then
        inst:Remove()
    else
        inst.components.workable:SetWorkable(false)
        inst:PushEvent("death")
        inst:RemoveTag("spore") -- so crowding no longer detects it
        inst.persists = false
        -- clean up when offscreen, because the death event is handled by the SG
        inst:DoTaskInTime(3, inst.Remove)
    end
end
--电疗
local function DoElectric(inst,ent)
    --反复确认防遍历的时候发生变故
    if ent and ent.components.combat ~= nil and not ent:HasTag("playerghost") and ent.components.health and not ent.components.health:IsDead() then
        --抱歉，时空乱流可不是绝缘能抵挡的，能抵挡一半就不错了
        local damame_mult=(ent.components.inventory ~= nil and ent.components.inventory:IsInsulated()) and 0.5 or 1
        ent.components.combat:GetAttacked(inst, TUNING_MEDAL.MEDAL_SPACETIME_SPARK_DAMAGE*damame_mult, nil, "electric")
        if ent.components.hauntable ~= nil and ent.components.hauntable.panicable then
            ent.components.hauntable:Panic(2)
        end
        --时之伤
        ent.components.health:DoDeltaMedalDelayDamage(TUNING_MEDAL.MEDAL_SPACETIME_SPARK_DELAY_DAMAGE*damame_mult)
    end
end

--放电间隙(有规律地连续放电)
local function sparktime(inst)
    inst.sparkcount = inst.sparkcount or 0
    local sparktime = inst.sparkcount < math.floor(inst.sparktimeseed/2) and 1 or (2+math.random()* 3)
    inst.sparkcount = (inst.sparkcount+1)%inst.sparktimeseed
    return sparktime
end
local SPARK_CANT_TAGS = { "playerghost", "INLIMBO", "moonstorm_static","wall","structure","groundspike","noattack"}
--放电
local function dospark(inst)
    local pos = Vector3(inst.Transform:GetWorldPosition())
    if not (TheWorld.net.components.medal_spacetimestorms ~= nil and TheWorld.net.components.medal_spacetimestorms:IsPointInSpacetimestorm(pos)) then
        if inst.sparktask then
            inst.sparktask:Cancel()
            inst.sparktask = nil
        end
        depleted(inst)
    else
        local fx = inst:SpawnChild("medal_spark_shock_fx")
        --延迟伤害
        inst.sparktask = inst:DoTaskInTime(5/30, function()
            inst.Light:SetRadius(2)
            -- local pos = Vector3(inst.Transform:GetWorldPosition())
            local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 4, nil, SPARK_CANT_TAGS)
            if #ents > 0 then
                for i, ent in ipairs(ents)do
                    DoElectric(inst,ent)
                end
            end
            inst:DoTaskInTime(0.5,function()
                inst.Light:SetRadius(1.5)
            end)
            inst.sparktask = inst:DoTaskInTime(sparktime(inst), dospark)
        end)
    end
end

local function onload(inst)
    -- If we loaded, then just turn the light on
    inst.Light:Enable(true)
    inst.DynamicShadow:Enable(true)
end
--捕捉过程(概率成功)
local function onworked(inst, worker, workleft)
    if workleft and workleft>0 then
        if math.random() < (TUNING_MEDAL.MEDAL_SPACETIME_SPARK_WORKLEFT-workleft)/TUNING_MEDAL.MEDAL_SPACETIME_SPARK_WORKLEFT then
            inst.components.workable.workleft=0
        else
            DoElectric(inst,worker)
        end
    end
end
--捕捉结果(保底)
local function onfinished(inst, worker)
    if worker.components.inventory ~= nil then
        local snacks = SpawnPrefab("medal_spacetime_lingshi")--时空灵石
        if snacks then
            if snacks.components.stackable and math.random() < 0.5 then
                snacks.components.stackable:SetStackSize(2)--50%概率额外获得一个时空灵石
            end
            worker.components.inventory:GiveItem(snacks, nil, inst:GetPosition())
            worker.SoundEmitter:PlaySound("dontstarve/common/butterfly_trap")
            inst.SoundEmitter:KillSound("idle_LP")
            inst:Remove()
            -- depleted(inst)
        end
    end
end

local function OnWake(inst)
    if not inst.sparktask and not inst:IsInLimbo() then
        inst.sparktask = inst:DoTaskInTime(sparktime(inst), dospark)
    end
end

local function OnSleep(inst)
    if inst.sparktask then
        inst.sparktask:Cancel()
        inst.sparktask = nil
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

	--MakeCharacterPhysics(inst, 1, .5)
    MakeFlyingCharacterPhysics(inst, 1, .5)

    inst.AnimState:SetBuild("medal_spacetime_spark")
    inst.AnimState:SetBank("charged_particle")
    inst.AnimState:PlayAnimation("idle_flight_loop", true)

    inst.DynamicShadow:Enable(false)

    inst.Light:SetColour(119/255, 56/255, 255/255)
    inst.Light:SetIntensity(0.75)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetRadius(1.5)
    inst.Light:Enable(true)

    inst.DynamicShadow:SetSize(.8, .5)

    inst:AddTag("show_spoilage")
    inst:AddTag("medal_spacetime_spark")

    inst.SoundEmitter:PlaySound("moonstorm/common/moonstorm/spark_LP","idle_LP")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.sparktimeseed=math.random(3,5)--放电间隙计数种子

    inst:AddComponent("inspectable")

    inst:AddComponent("knownlocations")
	-- inst:AddComponent("tradable")

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.walkspeed = 3

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.NET)
    inst.components.workable:SetWorkLeft(TUNING_MEDAL.MEDAL_SPACETIME_SPARK_WORKLEFT)
    inst.components.workable:SetOnWorkCallback(onworked)
    inst.components.workable:SetOnFinishCallback(onfinished)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING_MEDAL.MEDAL_SPACETIME_SPARK_PERISH_TIME)
    inst.components.perishable:StartPerishing()
    inst.components.perishable:SetOnPerishFn(depleted)

    MakeHauntablePerish(inst, .5)

    inst.OnEntityWake = OnWake
    inst.OnEntitySleep = OnSleep

    inst:SetStateGraph("SGspore")
    inst:SetBrain(brain)

    inst.sparktask = inst:DoTaskInTime(1, dospark)

    inst.OnLoad = onload

    return inst
end

return Prefab("medal_spacetime_spark", fn, assets, prefabs)
