-- require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/elecourmaline.zip"),
    Asset("ANIM", "anim/elecourmaline_keystone.zip"),
}

local prefabs =
{
    "collapse_big",
    "elecarmet",
    "elecourmaline_keystone",
    "tourmalinecore",
    "rocks",
    "flint",
    "nitre",
}

SetSharedLootTable( 'elecourmaline',
{
    {"tourmalinecore",   0.05},
    {'rocks',   1.0},
    {'rocks',   1.0},
    {'rocks',   1.0},
    {'rocks',   0.5},
    {'nitre',   0.2},
    {'flint',   1.0},
    {'flint',   1.0},
    {'flint',   0.5},
})

local function SpawnRocks(inst)
    inst.keytask = nil

    if inst.keystone ~= nil then
        return
    end

    local symplename = {
        [1] = "keystone1",
        [2] = nil,
        [3] = "keystone2",
        [4] = "keystone3",
        [5] = "keystone4",
        [6] = nil,
        [7] = "keystone5",
    }

    local x1, y1, z1 = inst.Transform:GetWorldPosition()
    local pos = {}
    local inte = 0.143 * 2 * PI
    local twopi = 2 * PI
    for i = 1, 7 do
        local theta = inte * i
        if theta > twopi then
            theta = theta - twopi
        end

        table.insert(pos,
        {
            x = x1 + 4.7 * math.cos(theta),
            y = 0,
            z = z1 - 4.7 * math.sin(theta),
            symple = symplename[i],
            index = i,
        })
    end

    inst.keystone = {}

    for i, v in pairs(pos) do
        local rock = SpawnPrefab("elecourmaline_keystone")
        
        if v.symple ~= nil then
            rock.AnimState:OverrideSymbol("keystone", "elecourmaline_keystone", v.symple)
        end

        -- rock.entity:SetParent(inst.entity)   --添加了父实体会导致物理体积和动画缩放不起作用
        rock.Transform:SetPosition(v.x, v.y, v.z)
        rock.persists = false
        inst.keystone[v.index] = rock
    end
end

local function DespawnRocks(inst)
    if inst.keystone ~= nil then
        for i, v in ipairs(inst.keystone) do
            if v:IsValid() then
                v:Remove()
            end
        end

        inst.keystone = nil
    end
end

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()

    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("stone")

    local boss = SpawnPrefab("elecarmet")
    boss.deathcounter = inst.deathcounter
    boss.UpdateDeathCounter(boss)
    boss.Transform:SetPosition(inst.Transform:GetWorldPosition())

    DespawnRocks(inst)
    inst:Remove()
end

local function onhit(inst, worker, workleft, numworks)
    if worker and not worker:HasTag("player") then --只有玩家才可以破坏重铸台
        inst.components.workable:SetWorkLeft(workleft + numworks)
    end

    if inst.components.prototyper.on then
        if inst.activated > 0 then
            inst.AnimState:PlayAnimation("active_hit")
            inst.AnimState:PushAnimation("active_loop", true)
        else
            inst.AnimState:PlayAnimation("hit")
            inst.AnimState:PushAnimation("loop", true)
        end
    else
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle", false)
    end
end

local LIGHT_RADIUS = 2
local LIGHT_RADIUS_ACTIVATED = 3.5
local SPEED_ON = LIGHT_RADIUS_ACTIVATED / 15
local SPEED_OFF = -(LIGHT_RADIUS_ACTIVATED / 30)

local function OnUpdateLight(inst)
    local lighton = inst._islighton         --是否关灯
    local maxradius = inst._lightmaxradius  --目标值
    local radius = inst._lightradius        --当前值
    local speed = SPEED_ON                  --变化值
    local isup = true                       --变化趋势

    if radius > maxradius then  --超过目标值则设为负的值，为了减小
        speed = SPEED_OFF
        isup = false
    end

    radius = radius + speed
    if isup then
        if radius >= maxradius then
            inst._lighttask:Cancel()
            inst._lighttask = nil

            inst.Light:SetRadius(maxradius)
            inst.Light:Enable(lighton)
            inst._lightradius = radius

            return --直接结束
        end
    else
        if radius <= maxradius then
            inst._lighttask:Cancel()
            inst._lighttask = nil

            inst.Light:SetRadius(maxradius)
            inst.Light:Enable(lighton)
            inst._lightradius = radius

            return --直接结束
        end
    end

    inst.Light:SetRadius(radius)
    inst.Light:Enable(true)
    inst._lightradius = radius
end
local function OnLightDirty(inst, shouldon, maxradius)
    inst._islighton = shouldon
    inst._lightmaxradius = maxradius

    if inst._lightradius == nil then
        inst._lightradius = 0
    end

    if inst._lighttask == nil then
        inst._lighttask = inst:DoPeriodicTask(FRAMES, OnUpdateLight)
    end
end
local function onturnon(inst)
    if inst._activetask == nil then
        if inst.activated > 0 then            
            if inst.AnimState:IsCurrentAnimation("active_loop") then    --如果当前就是激活后的循环动画
                inst.AnimState:PlayAnimation("active_loop", true)    --重新设定播放，来清除以前的动画push序列
            else
                inst.AnimState:PlayAnimation("idle_to_active")
                inst.AnimState:PushAnimation("active_loop", true)
            end

            if inst.keystone ~= nil then
                for i, v in pairs(inst.keystone) do
                    if i <= inst.activated then
                        if v.AnimState:IsCurrentAnimation("kidle_active") then    --如果当前就是激活后的循环动画
                            v.AnimState:PlayAnimation("kidle_active", false)    --重新设定播放，来清除以前的动画push序列
                        else
                            v.AnimState:PlayAnimation("kidle_to_active")
                            v.AnimState:PushAnimation("kidle_active", false)
                        end

                        v.Light:Enable(true)
                    end
                end
            end

            OnLightDirty(inst, true, LIGHT_RADIUS_ACTIVATED)
        else
            if inst.AnimState:IsCurrentAnimation("loop") then
                inst.AnimState:PushAnimation("loop", true)
            else
                inst.AnimState:PlayAnimation("loop", true)
            end

            OnLightDirty(inst, true, LIGHT_RADIUS)
        end

        if not inst.SoundEmitter:PlayingSound("idlesound") then
            inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl3_idle_LP", "idlesound")
        end
    end
end
local function onturnoff(inst)
    if inst._activetask == nil then 
        if inst.activated > 0 then                
            inst.AnimState:PushAnimation("active_to_idle", false)

            if inst.keystone ~= nil then
                for i, v in pairs(inst.keystone) do
                    if i <= inst.activated then
                        v.AnimState:PlayAnimation("active_to_kidle")    --这个动画单独播放会有有问题，再push一个就看不出来了
                        v.AnimState:PushAnimation("kidle", false)
                        v.Light:Enable(false)
                    end
                end
            end
        end
        inst.AnimState:PushAnimation("idle", false)

        OnLightDirty(inst, false, 0)

        inst.SoundEmitter:KillSound("idlesound")
    end
end

local function doneact(inst)
    inst._activetask = nil

    if inst.components.prototyper.on then
        onturnon(inst)
    else
        onturnoff(inst)
    end
end
local function doonact(inst)
    if inst._activecount > 1 then
        inst._activecount = inst._activecount - 1
    else
        inst._activecount = 0
        inst.SoundEmitter:KillSound("sound")
    end
    -- inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl3_ding")
    inst.SoundEmitter:PlaySound("dontstarve/common/together/celestial_orb/active")
end

local function onactivate(inst, doer, recipe)
    if inst.activated > 0 then
        if
            recipe and recipe.level and recipe.level.ELECOURMALINE ~= nil and
            recipe.level.ELECOURMALINE == 3 --高阶重铸科技才减少次数
        then
            inst.activated = inst.activated - 1
            if inst.keystone ~= nil then
                local usedkey = inst.activated + 1
                for i, v in pairs(inst.keystone) do
                    if i == usedkey then
                        v.AnimState:PlayAnimation("kidle_use")
                        v.AnimState:PushAnimation("kidle", false)
                        v.Light:Enable(false)
                        break
                    end
                end
            end
        end

        inst.AnimState:PlayAnimation("active_use")
        if inst.activated > 0 then
            inst.AnimState:PushAnimation("active_loop", true)
        else
            -- inst.AnimState:PushAnimation("active_to_idle", false)
            inst.AnimState:PushAnimation("loop", true)
            OnLightDirty(inst, true, LIGHT_RADIUS)
            inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.ELECOURMALINE_ONE or TUNING.PROTOTYPER_TREES.SCIENCEMACHINE
        end
    else
        inst.AnimState:PlayAnimation("use")
        inst.AnimState:PushAnimation("loop", true)
    end

    if not inst.SoundEmitter:PlayingSound("sound") then
        inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl3_run", "sound")
    end

    inst._activecount = inst._activecount + 1
    inst:DoTaskInTime(1.5, doonact)

    if inst._activetask ~= nil then
        inst._activetask:Cancel()
    end
    inst._activetask = inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() + 2 * FRAMES, doneact)
end

local function ActivateRocks(inst)
    inst.activated = 7
    inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.ELECOURMALINE_THREE or TUNING.PROTOTYPER_TREES.ALCHEMYMACHINE
end

local function onsave(inst, data)
    if inst.activated > 0 then
        data.activated = inst.activated
    end
    if inst.deathcounter > 0 then
        data.deathcounter = inst.deathcounter
    end
end

local function onload(inst, data)
    if data ~= nil then
        if data.activated ~= nil then
            inst.activated = data.activated
            inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.ELECOURMALINE_THREE or TUNING.PROTOTYPER_TREES.ALCHEMYMACHINE
        end
        if data.deathcounter ~= nil then
            inst.deathcounter = data.deathcounter
        else
            inst.deathcounter = 0
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddLight()

    inst.Transform:SetScale(1.5, 1.5, 1.5)
    MakeObstaclePhysics(inst, 0.8)

    -- inst.MiniMapEntity:SetPriority(5)
    inst.MiniMapEntity:SetIcon("elecourmaline.tex")

    inst.AnimState:SetBank("elecourmaline")
    inst.AnimState:SetBuild("elecourmaline")
    inst.AnimState:PlayAnimation("idle")

    inst.Light:Enable(false)
    inst.Light:SetRadius(0)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.6) --光强
    inst.Light:SetColour(15/255, 160/255, 180/255)
    -- inst.Light:EnableClientModulation(true)

    -- inst:AddTag("structure")
    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("prototyper")   --prototyper (from prototyper component) added to pristine state for optimization

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst._activecount = 0
    inst._activetask = nil
    inst.keystone = nil
    inst.activated = 0
    inst.ActivateRocks = ActivateRocks
    inst._islighton = nil
    inst._lightradius = 0
    inst._lightmaxradius = nil
    inst._lighttask = nil
    inst.deathcounter = 0

    inst:AddComponent("inspectable")

    inst:AddComponent("prototyper")
    inst.components.prototyper.onturnon = onturnon
    inst.components.prototyper.onturnoff = onturnoff
    inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.ELECOURMALINE_ONE or TUNING.PROTOTYPER_TREES.SCIENCEMACHINE
    inst.components.prototyper.onactivate = onactivate

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('elecourmaline')

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(15)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst.OnSave = onsave
    inst.OnLoad = onload

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst.keytask = inst:DoTaskInTime(0, SpawnRocks)

    return inst
end

---------------------------------------
---------------------------------------

local assets_key =
{
    Asset("ANIM", "anim/elecourmaline.zip"),
}

local function fn_key()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    -- inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddLight()

    inst.Transform:SetScale(2, 2, 2)
    MakeObstaclePhysics(inst, 0.2)

    inst.Light:Enable(false)
    inst.Light:SetRadius(0.7)
    inst.Light:SetFalloff(0.7)
    inst.Light:SetIntensity(0.6) --光强
    inst.Light:SetColour(15 / 255, 160 / 255, 180 / 255)

    inst.AnimState:SetBank("elecourmaline")
    inst.AnimState:SetBuild("elecourmaline")
    inst.AnimState:PlayAnimation("kidle")

    -- inst:AddTag("structure")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    -- inst:ListenForEvent("startfollowing", OnStartFollowing)

    return inst
end

---------------------------------------
---------------------------------------

return Prefab("elecourmaline_keystone", fn_key, assets_key, nil),
        Prefab("elecourmaline", fn, assets, prefabs)
