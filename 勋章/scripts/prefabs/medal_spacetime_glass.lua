require("worldsettingsutil")

local assets =
{
    Asset("ANIM", "anim/moonglass_charged_tile.zip"),
    Asset("ANIM", "anim/medal_spacetime_charged_tile.zip"),
}

local prefabs =
{
    "medal_spacetime_lingshi",
    "medal_gestalt",
    "moonstorm_glass_ground_fx",
    "moonstorm_glass_fx",
    "moonstorm_glass_nub",
}

SetSharedLootTable( 'medal_spacetime_glass_infused',
{
    {'medal_spacetime_lingshi',       1.00},
    {'medal_spacetime_lingshi',       0.50},
    {'medal_gestalt',       1.00},
})
--爆炸
local function explode(inst)
    inst.AnimState:PlayAnimation("crack")
    inst:ListenForEvent("animover", function()

        inst.AnimState:SetBloomEffectHandle("")
        inst.defused = true
        -- inst.components.named:SetName(STRINGS.NAMES.MOONSTORM_GLASS_DEFUSED)

        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 4)

        SpawnPrefab("medal_spacetime_glass_ground_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
        SpawnPrefab("medal_spacetime_glass_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())

        inst.SoundEmitter:PlaySound("moonstorm/common/moonstorm/glass_break")

        for i, v in ipairs(ents) do
            if v ~= inst and v:IsValid() and not v:IsInLimbo() then
                if v:IsValid() and not v:IsInLimbo() then
                    if v.components.combat ~= nil and v.components.health ~= nil and not v.components.health:IsDead() then
                        v.components.combat:GetAttacked(inst, TUNING_MEDAL.MEDAL_SPACETIME_GLASS_DAMAGE, nil, nil, {medal_chaos = TUNING_MEDAL.MEDAL_SPACETIME_GLASS_CHAOS_DAMAGE})
                        v.components.health:DoDeltaMedalDelayDamage(TUNING_MEDAL.MEDAL_SPACETIME_GLASS_DELAY_DAMAGE)--时之伤
                    end
                end
            end
        end
        inst:Remove()
    end)
end

local function OnWork(inst, worker, workleft)
    if inst.nub then
        inst.nub.components.workable:SetWorkLeft(workleft)
        inst.nub.setanim(inst.nub, workleft)
    end

    if workleft <= 0 then
        local pt = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pt:Get())
        --抱歉,只有玩家挖的才有灵石哦
        if worker and worker:HasTag("player") then
            inst.components.lootdropper:DropLoot(pt)
        end

        if inst.showCloudFXwhenRemoved then
            local fx = SpawnPrefab("collapse_small")
            fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        end
        inst:Remove()
    end
end

local function on_save(inst, data)
    data.defused = inst.defused or nil
end

local function on_load(inst, data)
    if data and data.defused then
        inst.components.timer:StopTimer("defusetime")
        explode(inst)
    end
end

local function ontimedone(inst,data)
    if data.name == "defusetime" then
        explode(inst)
    end
end

local function getstatus(inst)
    if not inst.defused then
        return "INFUSED"
    end
end

local function spawnin(inst)
    inst.AnimState:PlayAnimation("spawn")
    inst.AnimState:PushAnimation("idle1",true)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.AnimState:SetBuild("medal_spacetime_charged_tile")
    inst.AnimState:SetBank("moonglass_charged")
    inst.AnimState:PlayAnimation("idle1", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    inst.Light:SetColour(111/255, 111/255, 227/255)
    inst.Light:SetIntensity(0.5)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetRadius(2)
    inst.Light:Enable(true)

    inst:AddTag("moonglass")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- inst:AddComponent("named")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('medal_spacetime_glass_infused')

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING_MEDAL.MEDAL_SPACETIME_GLASS_MINE)
    inst.components.workable:SetOnWorkCallback(OnWork)

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    local TIME = math.random(TUNING_MEDAL.MEDAL_SPACETIME_GLASS_TIME_MIN,TUNING_MEDAL.MEDAL_SPACETIME_GLASS_TIME_MAX)--存在时间

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("defusetime", TIME)
    inst:ListenForEvent("timerdone", ontimedone)

    inst:AddComponent("updatelooper")
    inst.components.updatelooper:AddOnUpdateFn(function()
        local time = inst.components.timer:GetTimeLeft("defusetime")
        if time then
            if time/TIME > 0.1 and time/TIME < 0.3 then
                if not inst.AnimState:IsCurrentAnimation("idle2_loop") then
                    inst.AnimState:PlayAnimation("idle2_loop",true)
                end
            elseif time/TIME < 0.5 then
                if not inst.AnimState:IsCurrentAnimation("idle1_loop") then
                    inst.AnimState:PlayAnimation("idle1_loop",true)
                end
            elseif time/TIME < 0.9 then
                if not inst.AnimState:IsCurrentAnimation("idle1") then
                    inst.AnimState:PlayAnimation("idle1",true)
                end
            end
        end
    end)
    
    --生成时空虚影
    -- inst:AddComponent("periodicspawner")
    -- inst.components.periodicspawner.prefab = "medal_gestalt"
    -- inst.components.periodicspawner.basetime = TUNING_MEDAL.MEDAL_GESTALT_SPAWN_TIME
    -- inst.components.periodicspawner.randtime = TUNING_MEDAL.MEDAL_GESTALT_SPAWN_TIME_RAND
    -- inst.components.periodicspawner:Start()

    inst.OnSave = on_save
    inst.OnLoad = on_load
    inst.spawnin = spawnin

    inst:ListenForEvent("onremove", function()
        if inst.nub then
            inst.nub:Remove()
        end
    end)

    inst:DoTaskInTime(0,function()
        local nub = SpawnPrefab("medal_spacetime_glass_nub")
        nub.Transform:SetPosition(inst.Transform:GetWorldPosition())
        nub.glass = inst
        inst.nub = nub
    end)

    return inst
end

local function setanim(inst, workleft)
    if workleft then
        inst.AnimState:PlayAnimation(
                (workleft < TUNING.ROCKS_MINE / 3 and "centre_idle3") or
                (workleft < TUNING.ROCKS_MINE * 2 / 3 and "centre_idle2") or
                "centre_idle1"
            )
    end
end

local function OnWorkNub(inst, worker, workleft, numworks)
    if inst.glass then
        inst.glass.components.workable:WorkedBy(worker, numworks)
        setanim(inst, workleft)
    end
end

local function nubfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBuild("medal_spacetime_charged_tile")
    inst.AnimState:SetBank("moonglass_charged")
    inst.AnimState:PlayAnimation("centre_idle1", true)

    inst:AddTag("moonglass")

    inst.entity:SetPristine()

    inst:SetPrefabNameOverride("medal_spacetime_glass")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING_MEDAL.MEDAL_SPACETIME_GLASS_MINE)
    inst.components.workable:SetOnWorkCallback(OnWorkNub)


    inst.setanim = setanim

    return inst
end

return Prefab("medal_spacetime_glass", fn, assets, prefabs),
       Prefab("medal_spacetime_glass_nub", nubfn, assets)