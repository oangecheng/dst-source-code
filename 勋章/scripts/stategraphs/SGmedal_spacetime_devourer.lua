require("stategraphs/commonstates")
local medal_sinkholes_fn = require("prefabs/medal_sinkholes_fn")

local ENTERWORLD_TARGET_CANT_TAGS = { "INLIMBO" }
local ENTERWORLD_TARGET_ONEOF_TAGS = { "CHOP_workable", "DIG_workable", "HAMMER_workable", "MINE_workable" }
local ENTERWORLD_TOSS_MUST_TAGS = { "_inventoryitem" }
local ENTERWORLD_TOSS_CANT_TAGS = { "locomotor", "INLIMBO" }
local ENTERWORLD_TOSSFLOWERS_MUST_TAGS = { "flower", "pickable" }

local function SproutLaunch(inst, launcher, basespeed)
    local x0, y0, z0 = launcher.Transform:GetWorldPosition()
    local x1, y1, z1 = inst.Transform:GetWorldPosition()
    local dx, dz = x1 - x0, z1 - z0
    local dsq = dx * dx + dz * dz
    local angle
    if dsq > 0 then
        local dist = math.sqrt(dsq)
        angle = math.atan2(dz / dist, dx / dist) + (math.random() * 20 - 10) * DEGREES
    else
        angle = 2 * PI * math.random()
    end
    local speed = basespeed + math.random()
    inst.Physics:Teleport(x1, .1, z1)
    inst.Physics:SetVel(math.cos(angle) * speed, speed * 4 + math.random() * 2, math.sin(angle) * speed)
end

--------------------------------------------------------------------------

local function ShakeIfClose(inst)
    ShakeAllCameras(CAMERASHAKE.FULL, .5, .02, .15, inst, 30)
end

local function ShakeCasting(inst)
    ShakeAllCameras(CAMERASHAKE.VERTICAL, .3, .02, 1, inst, 30)
end

local function ShakeRaising(inst)
    ShakeAllCameras(CAMERASHAKE.FULL, 1, .02, 1, inst, 30)
end

--------------------------------------------------------------------------
--选择攻击目标
local function ChooseAttack(inst)
    local targets = {}
    -- local candidates = (TheWorld and TheWorld.components.medal_spacetimestormmanager and TheWorld.components.medal_spacetimestormmanager:GetLostPlayer()) or {}
    local candidates = AllPlayers
    if #candidates>0 then
        for _, target in ipairs(candidates) do
            if target ~= nil and target:IsNear(inst, TUNING_MEDAL.MEDAL_SPACETIME_DEVOURER_CAST_RANGE) and not target:HasTag("playerghost") then
                table.insert(targets,target)
            end
        end
    end
    if #targets>0 then
        if inst.components.worldsettingstimer:ActiveTimerExists("wall_cd") then
            inst.sg:GoToState("summonspikes",targets)
        else
            inst.sg:GoToState("summonwall",targets)
        end
        return true
    end
    return false
end

--召唤迷失在时空风暴中的玩家
local function CallBack(inst)
    if inst.components.worldsettingstimer:ActiveTimerExists("call_cd") then return end
    inst.components.medal_sinkholespawner:UpdateTeleportPos()
    local pos = inst.components.medal_sinkholespawner.teleportpos
    local posdata = {
        x = pos and pos.x or nil,
        z = pos and pos.z or nil,
    }
    local candidates = (TheWorld and TheWorld.components.medal_spacetimestormmanager and TheWorld.components.medal_spacetimestormmanager:GetLostPlayer()) or {}
    local targets = {}
    if #candidates>0 then
        for _, target in ipairs(candidates) do
            if target ~= nil and not target:IsNear(inst, TUNING_MEDAL.MEDAL_SPACETIME_DEVOURER_CAST_RANGE) and not target:HasTag("playerghost") then
                medal_sinkholes_fn.DoTargetWarning(target)--警告
                table.insert(targets,target)
                
            end
        end
    end
    if #targets>0 then
        inst:DoTaskInTime(3,function()
            for _, target in ipairs(targets) do
                medal_sinkholes_fn.SpawnSinkhole(target,posdata)--生成地陷
            end
        end)
    end
    inst.components.worldsettingstimer:StartTimer("call_cd", TUNING_MEDAL.MEDAL_SPACETIME_DEVOURER_CALL_CD)
end

--------------------------------------------------------------------------

--See sand_spike.lua
local SPIKE_SIZES =
{
    "short",
    "med",
    "tall",
}

local SPIKE_RADIUS =
{
    ["short"] = .2,
    ["med"] = .4,
    ["tall"] = .6,
    ["block"] = 1.1,
}
--是否可生成尖刺
local function CanSpawnSpikeAt(pos, size)
    local radius = SPIKE_RADIUS[size]
    -- for i, v in ipairs(TheSim:FindEntities(pos.x, 0, pos.z, radius + 1.5, nil, { "antlion_sinkhole" }, { "groundspike", "antlion_sinkhole_blocker" })) do
    for i, v in ipairs(TheSim:FindEntities(pos.x, 0, pos.z, radius + 0.5, nil, { "antlion_sinkhole" }, { "groundspike", "antlion_sinkhole_blocker" })) do
        if v.Physics == nil then
            return false
        end
        local spacing = radius + v:GetPhysicsRadius(0)
        if v:GetDistanceSqToPoint(pos) < spacing * spacing then
            return false
        end
    end
    return true
end
--生成尖刺
local function SpawnSpikes(inst, pos, count)
    for i = #SPIKE_SIZES, 1, -1 do
        local size = SPIKE_SIZES[i]
        if CanSpawnSpikeAt(pos, size) then
            SpawnPrefab("medal_spike_"..size).Transform:SetPosition(pos:Get())
            count = count - 1
            break
        end
    end
    if count > 0 then
        local dtheta = PI * 2 / count
        for theta = math.random() * dtheta, PI * 2, dtheta do
            local size = SPIKE_SIZES[math.random(#SPIKE_SIZES)]
            -- local offset = FindWalkableOffset(pos, theta, 2 + math.random() * 2, 3, false, true,
            local offset = FindWalkableOffset(pos, theta, 1 + math.random() * 2, 3, false, true,
                function(pt)
                    return CanSpawnSpikeAt(pt, size)
                end,
                true, true)
            if offset ~= nil then
                SpawnPrefab("medal_spike_"..size).Transform:SetPosition(pos.x + offset.x, 0, pos.z + offset.z)
            end
        end
    end
end
--攻击目标
local function AttackTargets(inst)
    if inst.sg.statemem.targets~=nil then
        for _, target in ipairs(inst.sg.statemem.targets) do
            if target~=nil and target:IsValid() then
                local pos = Vector3(target.Transform:GetWorldPosition())
                SpawnSpikes(inst, pos, math.random(6, 7))--召唤时空之刺
            end
        end
    end
    inst.sg.statemem.targets=nil
end
--生成时空之塔
local function SpawnBlock(inst, x, z)
    SpawnPrefab("medal_block").Transform:SetPosition(x, 0, z)
    -- SpawnPrefab("medal_spike_tall").Transform:SetPosition(x, 0, z)
end
-- 生成塔圈
local function SpawnBlocks(inst, pos, count,dist)
    if count > 0 then
        -- inst.walltimes = inst.walltimes or 0
        local dtheta = PI * 2 / count
        local thetaoffset = math.random() * PI * 2
        for theta = math.random() * dtheta, PI * 2, dtheta do
            -- local dist = inst.walltimes>0 and (9 + math.random()*7) or 8
            -- local offset = FindWalkableOffset(pos, theta + thetaoffset, 8 + math.random(), 3, false, true,
            local offset = FindWalkableOffset(pos, theta + thetaoffset, dist or 8, 1, false, true,
                function(pt)
                    return CanSpawnSpikeAt(pt, "block")
                end,true,true)
            if offset ~= nil then
                if theta < dtheta then
                    SpawnBlock(inst, pos.x + offset.x, pos.z + offset.z)
                else
                    inst:DoTaskInTime(math.random() * .5, SpawnBlock, pos.x + offset.x, pos.z + offset.z)
                end
            end
        end
        -- inst.walltimes = (inst.walltimes+1)%3
    end
end
--困住目标
local function TrapTargets(inst)
    inst.walltimes = inst.walltimes or 0--生成塔墙的次数
    --单人墙
    if inst.walltimes>0 then
        if inst.sg.statemem.targets~=nil then
            for _, target in ipairs(inst.sg.statemem.targets) do
                if target~=nil and target:IsValid() then
                    local pos = Vector3(target.Transform:GetWorldPosition())
                    SpawnBlocks(inst, pos, 9, 4)
                end
            end
        end
    else--总墙
        SpawnBlocks(inst, inst:GetPosition(), 17, 8)
        SpawnBlocks(inst, inst:GetPosition(), 35, 16)
    end
    inst.components.worldsettingstimer:StartTimer("wall_cd", TUNING_MEDAL.MEDAL_SPACETIME_DEVOURER_WALL_CD)
    inst.walltimes = (inst.walltimes+1)%3
    inst.sg.statemem.targets=nil
end

local function CanGoToActionState(inst)
    if not inst.sg:HasStateTag("busy") or
        inst.sg:HasStateTag("caninterrupt") or
        inst.sg:HasStateTag("frozen") or
        inst.sg:HasStateTag("thawing") then
            if inst.components.freezable then
                inst.components.freezable:Unfreeze()--解冻
            end
        return true
    end
    --强制唤醒
    if inst.components.sleeper then
        inst.components.sleeper:WakeUp()
    end
    return false
end

local function TryActionState(inst)
    if inst.sg.mem.queueleaveworld then
        inst.sg:GoToState("leaveworld")
    elseif inst.sg.mem.queuegobackstorm then
        inst.sg:GoToState("gobackstorm")
    elseif inst.sg.mem.causingsinkholes then
        inst.sg:GoToState("sinkhole_pre")
    else
        return false
    end
    return true
end

local function _OnNoSleepEvent(event, nextstate)
    return EventHandler(event, function(inst)
        if inst.AnimState:AnimDone() then
            if TryActionState(inst) then
                return
            elseif inst.sg.mem.sleeping then
                inst.sg:GoToState("sleep")
            elseif type(nextstate) == "string" then
                inst.sg:GoToState(nextstate)
            elseif nextstate ~= nil then
                nextstate(inst)
            end
        end
    end)
end

local function _OnNoSleepAnimOver(nextstate)
    return _OnNoSleepEvent("animover", nextstate)
end

local function _OnNoSleepAnimQueueOver(nextstate)
    return _OnNoSleepEvent("animqueueover", nextstate)
end

local function _OnNoSleepTimeEvent(t, fn)
    return TimeEvent(t, function(inst)
        if TryActionState(inst) then
            return
        elseif inst.sg.mem.sleeping then
            inst.sg:GoToState("sleep")
        elseif fn ~= nil then
            fn(inst)
        end
    end)
end

--------------------------------------------------------------------------

local events =
{
    CommonHandlers.OnDeath(),
    -- CommonHandlers.OnFreezeEx(),
    -- CommonHandlers.OnSleepEx(),
    -- CommonHandlers.OnWakeEx(),
    EventHandler("doattack", function(inst)
        if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
            ChooseAttack(inst)
        end
    end),
    EventHandler("callback", function(inst)--召唤玩家
        if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
            inst.sg:GoToState("callback")
        end
    end),
    EventHandler("attacked", function(inst)
        -- inst.sg.mem.wantstoeat = nil
        if not inst.components.health:IsDead() and
            (not inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("caninterrupt")) and
            not CommonHandlers.HitRecoveryDelay(inst, TUNING.ANTLION_HIT_RECOVERY) then
            inst.sg:GoToState("hit")
        end
    end),
    EventHandler("leaveworld", function(inst, data)--离开这个世界了
        if not inst.sg:HasStateTag("busy") then
            inst.sg:GoToState("leaveworld", data)
        else
            inst.sg.mem.queueleaveworld = true
        end
    end),
    EventHandler("onaccepttribute", function(inst, data)--接受大自然的馈赠
        if CanGoToActionState(inst) then
            inst.sg:GoToState("rocktribute", data)
        end
    end),
    EventHandler("onrefusetribute", function(inst, data)--拒绝
        if CanGoToActionState(inst) then
            inst.sg:GoToState("refusetribute", data)
        end
    end),
    EventHandler("satisfy", function(inst, data)
        inst.sg:GoToState("satisfy", data)
    end),
    EventHandler("gohome", function(inst, data)--肥家！
        if not inst.sg:HasStateTag("busy") then
            inst.sg:GoToState("gobackstorm", data)--当前世界上有时空风暴的话，回风暴里去
        else
            inst.sg.mem.queuegobackstorm = true
        end
    end),
    EventHandler("onsinkholesstarted", function(inst, data)
        inst.sg.mem.causingsinkholes = true
        if CanGoToActionState(inst) then
            inst.sg:GoToState("sinkhole_pre", data)
        end
    end),
    EventHandler("onsinkholesfinished", function(inst, data)
        inst.sg.mem.causingsinkholes = false
    end),
}

local states =
{
    State{
        name = "idle",
        tags = { "idle" },

        onenter = function(inst, loopcount)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{--受击(用不上)
        name = "hit",
        tags = { "hit", "busy" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("hit")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/hit")
			CommonHandlers.UpdateHitRecoveryDelay(inst)
        end,

        timeline =
        {
            TimeEvent(14 * FRAMES, function(inst)
                if inst.sg.statemem.doattack then
                    if not inst.components.health:IsDead() and
                        not inst.sg.mem.wantstostopfighting and
                        ChooseAttack(inst) then
                        return
                    end
                    inst.sg.statemem.doattack = nil
                end
                inst.sg:RemoveStateTag("busy")
            end),
        },

        events =
        {
            EventHandler("doattack", function(inst)
                inst.sg.statemem.doattack = true
            end),
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    if inst.sg.statemem.doattack and
                        not inst.components.health:IsDead() and
                        not inst.sg.mem.wantstostopfighting and
                        ChooseAttack(inst) then
                        return
                    end
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{--死亡(这个用不上，反正不会死)
        name = "death",
        tags = { "busy" },

        onenter = function(inst)
            -- inst.AnimState:PlayAnimation("death")
            inst.AnimState:PlayAnimation("out")--永远不会死，只是离开了这个时空
            inst:AddTag("NOCLICK")
        end,

        timeline =
        {
            TimeEvent(28 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/break_spike") end),
            TimeEvent(35 * FRAMES, function(inst)
                inst.Physics:SetActive(false)
                inst.components.sanityaura.aura = 0
                ShakeIfClose(inst)
                if inst.persists then
                    inst.persists = false
                    --万一真被什么方法打死了，也不掉东西
                end
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst:Remove()
                    if TheWorld and TheWorld.components.medal_spacetimestormmanager then
                        TheWorld.components.medal_spacetimestormmanager:StopCurrentSpacetimestorm()
                    end
                end
            end),
        },

        onexit = function(inst)
            --Should NOT happen!
            inst.Physics:SetActive(true)
            inst.components.sanityaura.aura = -TUNING.SANITYAURA_SUPERHUGE
            inst:RemoveTag("NOCLICK")
        end,
    },

    State{--吃饱喝足了,跑路跑路
        name = "satisfy",
        tags = { "busy" },

        onenter = function(inst)
            -- inst.AnimState:PlayAnimation("death")
            inst.AnimState:PlayAnimation("full_pre")
            inst.AnimState:PushAnimation("full_loop", false)
            inst.AnimState:PushAnimation("full_pst", false)
            inst.AnimState:PushAnimation("out")--离开这个时空
            inst:AddTag("NOCLICK")
        end,

        timeline =
        {
            TimeEvent(0, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/purr")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/rub")
            end),
            TimeEvent(16 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/rub") end),
            TimeEvent(30 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/rub") end),
            TimeEvent(46 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/rub") end),
            TimeEvent(104 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/break_spike") end),
            TimeEvent(111 * FRAMES, function(inst)
                inst.Physics:SetActive(false)
                inst.components.sanityaura.aura = 0
                ShakeIfClose(inst)
                if inst.persists then
                    inst.persists = false
                end
            end),
            TimeEvent(120 * FRAMES, function(inst)
                local treasure = SpawnPrefab("medal_spacetime_treasure")
                if treasure then
                    treasure.snacks_num = inst.snacks_num or 0
                    treasure.Transform:SetPosition(inst.Transform:GetWorldPosition())
                end
                inst:Hide()
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    -- inst.components.lootdropper:DropLoot(inst:GetPosition())
                    inst:Remove()
                    if TheWorld and TheWorld.components.medal_spacetimestormmanager then
                        TheWorld.components.medal_spacetimestormmanager:StopCurrentSpacetimestorm()
                    end
                end
            end),
        },

        onexit = function(inst)
            --Should NOT happen!
            inst.Physics:SetActive(true)
            inst.components.sanityaura.aura = -TUNING.SANITYAURA_SUPERHUGE
            inst:RemoveTag("NOCLICK")
        end,
    },

    State{--吃嗨了
        name = "hightributeresponse",
        tags = { "busy" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("full_pre")
            inst.AnimState:PushAnimation("full_loop", false)
            inst.AnimState:PushAnimation("full_pst", false)
        end,

        timeline =
        {
            TimeEvent(0, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/purr")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/rub")
            end),
            TimeEvent(16 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/rub") end),
            TimeEvent(30 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/rub") end),
            TimeEvent(46 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/rub") end),
            TimeEvent(76 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },
    -- State{
    --     name = "trinkettribute",
    --     tags = { "busy", "nosleep", "nofreeze" },

    --     onenter = function(inst)
    --         inst.AnimState:PlayAnimation("eat_talisman")
    --         inst.AnimState:PushAnimation("spit_talisman", false)
    --     end,

    --     timeline =
    --     {
    --         TimeEvent(21 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/swallow") end),
    --         TimeEvent(44 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/unimpressed") end),
    --         TimeEvent(80 * FRAMES, function(inst)
    --             inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/spit")
    --             inst:EatFood()
    --         end),
    --         _OnNoSleepTimeEvent(98 * FRAMES, function(inst)
    --             inst.sg:RemoveStateTag("busy")
    --             inst.sg:RemoveStateTag("nosleep")
    --             inst.sg:RemoveStateTag("nofreeze")
    --         end),
    --     },

    --     events =
    --     {
    --         _OnNoSleepAnimQueueOver("idle"),
    --     },
    -- },

    State{
        name = "rocktribute",--吃零食啦~
        tags = { "busy", "nosleep", "nofreeze" },

        onenter = function(inst, data)
            inst.AnimState:PlayAnimation("eat")
            -- inst.sg.statemem.tributepercent = data ~= nil and data.tributepercent or 0
        end,

        timeline =
        {
            TimeEvent(12 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/eat") end),
            TimeEvent(36 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/eat") end),
            TimeEvent(71 * FRAMES, function(inst) 
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/swallow")
                inst:EatFood()
            end),
            _OnNoSleepTimeEvent(85 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
                inst.sg:RemoveStateTag("nosleep")
                inst.sg:RemoveStateTag("nofreeze")
            end),
        },

        events =
        {
            _OnNoSleepAnimOver(function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

    State{--召唤时空之刃
        name = "summonspikes",
        tags = { "attack", "busy" },

        onenter = function(inst,targets)
            inst.AnimState:PlayAnimation("cast_pre")
            --每次攻击都会提升攻速
            inst.components.combat:SetAttackPeriod(math.max(TUNING_MEDAL.MEDAL_SPACETIME_MIN_ATTACK_PERIOD, inst.components.combat.min_attack_period + TUNING_MEDAL.MEDAL_SPACETIME_SPEED_UP))
            inst.components.combat:StartAttack()
            if targets~=nil then
                inst.sg.statemem.targets=targets
            end
        end,

        timeline =
        {
            TimeEvent(3 * FRAMES, function(inst)
                if inst.sg.statemem.targets ~= nil then 
                    AttackTargets(inst)
                end
            end),
            TimeEvent(6 * FRAMES, function(inst)
                inst.sg:AddStateTag("nosleep")
                inst.sg:AddStateTag("nofreeze")
            end),
            TimeEvent(8 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/cast_pre") end),
            TimeEvent(25.5 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/cast_post") end),
            TimeEvent(29 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/ground_break") end),
            TimeEvent(32 * FRAMES, ShakeCasting),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("summonspikes_pst")
                end
            end),
        },
    },

    State{
        name = "summonspikes_pst",
        tags = { "attack", "busy", "nosleep", "nofreeze" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("cast_pst")
        end,

        timeline =
        {
            CommonHandlers.OnNoSleepTimeEvent(10 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
                inst.sg:RemoveStateTag("nosleep")
                inst.sg:RemoveStateTag("nofreeze")
            end),
        },

        events =
        {
            CommonHandlers.OnNoSleepAnimOver("idle"),
        },
    },

    State{--召唤外墙
        name = "summonwall",
        tags = { "attack", "busy" },

        onenter = function(inst,targets)
            inst.AnimState:PlayAnimation("cast_sandcastle")
            --V2C: don't trigger attack cooldown
            --inst.components.combat:StartAttack()
            if targets~=nil then
                inst.sg.statemem.targets=targets
            end
        end,

        timeline =
        {
            TimeEvent(9 * FRAMES, function(inst)
                inst.sg:AddStateTag("nosleep")
                inst.sg:AddStateTag("nofreeze")
            end),
            TimeEvent(9 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/attack_pre") end),
            TimeEvent(14 * FRAMES, function(inst)
                --NOTE: sandblock has 10 frames lead in time
                -- SpawnBlocks(inst, inst:GetPosition(), 19)
                TrapTargets(inst)
            end),
            TimeEvent(25 * FRAMES, ShakeRaising),
            CommonHandlers.OnNoSleepTimeEvent(56 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
                inst.sg:RemoveStateTag("nosleep")
                inst.sg:RemoveStateTag("nofreeze")
            end),
        },

        events =
        {
            CommonHandlers.OnNoSleepAnimOver("idle"),
        },
    },

    State{--召唤玩家
        name = "callback",
        tags = { "busy" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("taunt")
        end,

        timeline =
        {
            TimeEvent(5 * FRAMES, function(inst)
                inst.sg:AddStateTag("nosleep")
                inst.sg:AddStateTag("nofreeze")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/taunt")
                CallBack(inst)
            end),
            CommonHandlers.OnNoSleepTimeEvent(28 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
                inst.sg:RemoveStateTag("nosleep")
                inst.sg:RemoveStateTag("nofreeze")
            end),
        },

        events =
        {
            CommonHandlers.OnNoSleepAnimOver("idle"),
        },
    },

    State{--嘲讽
        name = "taunt",
        tags = { "busy" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("taunt")
        end,

        timeline =
        {
            TimeEvent(5 * FRAMES, function(inst)
                inst.sg:AddStateTag("nosleep")
                inst.sg:AddStateTag("nofreeze")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/taunt")
            end),
            CommonHandlers.OnNoSleepTimeEvent(28 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
                inst.sg:RemoveStateTag("nosleep")
                inst.sg:RemoveStateTag("nofreeze")
            end),
        },

        events =
        {
            CommonHandlers.OnNoSleepAnimOver("idle"),
        },
    },

    State{--拒绝
        name = "refusetribute",
        tags = { "busy", "nosleep", "nofreeze" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("unimpressed")
        end,

        timeline =
        {
            _OnNoSleepTimeEvent(48 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
                inst.sg:RemoveStateTag("nosleep")
                inst.sg:RemoveStateTag("nofreeze")
            end),
            TimeEvent(54 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/unimpressed") end),
        },

        events =
        {
            _OnNoSleepAnimOver("idle"),
        },
    },

    State{--你的小可爱突然出现
        name = "enterworld",
        tags = { "busy", "nosleep", "nofreeze" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("enter")
            inst.sg.statemem.spawnpos = inst:GetPosition()

            for i, v in ipairs(TheSim:FindEntities(inst.sg.statemem.spawnpos.x, 0, inst.sg.statemem.spawnpos.z, 2, nil, ENTERWORLD_TARGET_CANT_TAGS, ENTERWORLD_TARGET_ONEOF_TAGS )) do
                v.components.workable:Destroy(inst)
                if v:IsValid() and v:HasTag("stump") then
                    v:Remove()
                end
            end

            local totoss = TheSim:FindEntities(inst.sg.statemem.spawnpos.x, 0, inst.sg.statemem.spawnpos.z, 1.5, ENTERWORLD_TOSS_MUST_TAGS, ENTERWORLD_TOSS_CANT_TAGS)

            --toss flowers out of the way
            for i, v in ipairs(TheSim:FindEntities(inst.sg.statemem.spawnpos.x, 0, inst.sg.statemem.spawnpos.z, 1.5, ENTERWORLD_TOSSFLOWERS_MUST_TAGS)) do
                local loot = v.components.pickable.product ~= nil and SpawnPrefab(v.components.pickable.product) or nil
                if loot ~= nil then
                    loot.Transform:SetPosition(v.Transform:GetWorldPosition())
                    table.insert(totoss, loot)
                end
                v:Remove()
            end

            --toss stuff out of the way
            for i, v in ipairs(totoss) do
                if v:IsValid() then
                    if v.components.mine ~= nil then
                        v.components.mine:Deactivate()
                    end
                    if not v.components.inventoryitem.nobounce and v.Physics ~= nil and v.Physics:IsActive() then
                        SproutLaunch(v, inst, 1.5)
                    end
                end
            end

            inst.Physics:SetMass(999999)
            inst.Physics:CollidesWith(COLLISION.WORLD)
        end,

        timeline =
        {
            TimeEvent(0 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/break_spike") end),
        },

        events =
        {
            _OnNoSleepAnimOver("idle"),
        },

        onexit = function(inst)
            inst.Physics:SetMass(0)
            inst.Physics:ClearCollisionMask()
            inst.Physics:CollidesWith(COLLISION.ITEMS)
            inst.Physics:CollidesWith(COLLISION.CHARACTERS)
            inst.Physics:CollidesWith(COLLISION.GIANTS)
            inst.Physics:Teleport(inst.sg.statemem.spawnpos:Get())
            --入场先来一波塌陷
            -- if inst.components.medal_sinkholespawner then
            --     inst.components.medal_sinkholespawner:StartSinkholes()
            -- end
        end,
    },

    State{--回风暴里去
        name = "gobackstorm",
        tags = { "busy", "nosleep", "nofreeze" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("out")
            inst.walltimes=0--墙的计数清空
        end,

        timeline =
        {
            TimeEvent(28 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/break_spike") end),
            TimeEvent(35 * FRAMES, function(inst)
                if inst.worldpos then--设置坐标
                    inst.Transform:SetPosition(inst.worldpos.x,inst.worldpos.y,inst.worldpos.z)
                    inst.sg.mem.queuegobackstorm=nil
                    inst.worldpos=nil
                end
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("enterworld")
                end
            end),
        },
    },

    State{--离开这个世界
        name = "leaveworld",
        tags = { "busy", "nosleep", "nofreeze" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("out")
        end,

        timeline =
        {
            TimeEvent(28 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/break_spike") end),
            TimeEvent(35 * FRAMES, function(inst)
                inst.Physics:SetActive(false)
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst:Remove()
                end
            end),
        },

        onexit = function(inst)
            --Should NOT reach here, but just in case
            inst.Physics:SetActive(true)
        end,
    },

    State{
        name = "sinkhole_pre",
        tags = { "busy", "attack", "nosleep", "nofreeze" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("cast_pre")
        end,

        timeline =
        {
            TimeEvent(8 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/cast_pre") end),
            TimeEvent(25.5 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/cast_post") end),
            TimeEvent(29 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/ground_break") end),
            TimeEvent(32 * FRAMES, ShakeCasting),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState(inst.sg.mem.causingsinkholes and "sinkhole_loop" or "sinkhole_pst")
                end
            end),
        },
    },

    State{
        name = "sinkhole_loop",
        tags = { "busy", "attack", "nosleep", "nofreeze" },

        onenter = function(inst, lastloop)
            inst.AnimState:PlayAnimation("cast_loop_active")
            inst.sg.statemem.lastloop = lastloop
        end,

        timeline =
        {
            TimeEvent(28 * FRAMES, function(inst)
                ShakeCasting(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/cast_pre")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/ground_break")
            end),
            TimeEvent(69 * FRAMES, function(inst)
                ShakeCasting(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/cast_pre")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/ground_break")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    if inst.sg.statemem.lastloop then
                        inst.sg:GoToState("sinkhole_pst")
                    else
                        inst.sg:GoToState("sinkhole_loop", not inst.sg.mem.causingsinkholes)
                    end
                end
            end),
        },
    },

    State{
        name = "sinkhole_pst",
        tags = { "busy", "attack", "nosleep", "nofreeze" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("cast_pst")
        end,

        timeline =
        {
            _OnNoSleepTimeEvent(10 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
                inst.sg:RemoveStateTag("nosleep")
                inst.sg:RemoveStateTag("nofreeze")
            end),
        },

        events =
        {
            _OnNoSleepAnimOver("idle"),
        },
    },
}

-- CommonStates.AddSleepExStates(states,
-- {
--     starttimeline =
--     {
--         TimeEvent(45 * FRAMES, function(inst)
--             inst.sg:RemoveStateTag("caninterrupt")
--         end),
--         TimeEvent(46 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/bodyfall_death") end),
--         TimeEvent(48 * FRAMES, ShakeIfClose),
--     },
--     sleeptimeline =
--     {
--         TimeEvent(7 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sleep_in") end),
--         TimeEvent(40 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sleep_out") end),
--     },
--     waketimeline =
--     {
--         CommonHandlers.OnNoSleepTimeEvent(23 * FRAMES, function(inst)
--             inst.sg:RemoveStateTag("busy")
--             inst.sg:RemoveStateTag("nosleep")
--         end),
--     },
-- },
-- {
--     onsleep = function(inst)
--         inst.sg:AddStateTag("caninterrupt")
--     end,
-- })

-- CommonStates.AddFrozenStates(states)

return StateGraph("SGmedal_spacetime_devourer", states, events, "idle")
