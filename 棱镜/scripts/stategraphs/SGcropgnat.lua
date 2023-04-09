require("stategraphs/commonstates")

local function IsTargetAround(inst)
    local target = inst.lighttarget or inst.infesttarget
    if target ~= nil and target:IsValid() then
        if inst:GetDistanceSqToPoint(target.Transform:GetWorldPosition()) <= 144 then
            inst.components.locomotor.runspeed = 6
            return true
        else
            inst.components.locomotor.runspeed = 10
            return false
        end
    else --对象不合法的话则默认在附近
        inst.components.locomotor.runspeed = 6
        return true
    end
end

local actionhandlers =
{
    --nothing
}

local events=
{
    EventHandler("locomote", function(inst) 
        if not inst.sg:HasStateTag("busy") then
            local is_moving = inst.sg:HasStateTag("moving")
            -- local is_running = inst.sg:HasStateTag("running")
            local wants_to_move = inst.components.locomotor:WantsToMoveForward()
            if is_moving ~= wants_to_move then
                if wants_to_move then
                    inst.sg.statemem.wantstomove = true
                else
                    inst.sg:GoToState("idle", inst.sg:HasStateTag("runrunrun"))
                end
            end
        end
    end),
    EventHandler("doattack", function(inst, data) 
        if not inst.components.health:IsDead() then
            inst.sg:GoToState("attack", data.target)
        end
    end),
    EventHandler("blocked", function(inst)
        if
            not inst.components.health:IsDead() and
            (inst.components.freezable == nil or not inst.components.freezable:IsFrozen())
        then
            inst.sg:GoToState("hit")
        end
    end),
    EventHandler("attacked", function(inst)
        if
            not inst.components.health:IsDead() and
            (inst.components.freezable == nil or not inst.components.freezable:IsFrozen())
        then
            inst.sg:GoToState("hit")
        end
    end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    EventHandler("knockedout", function(inst)
        if
            not inst.components.health:IsDead() and --没死
            not (inst.components.hauntable and inst.components.hauntable.panic) and --没有被作祟
            not inst.components.health.takingfiredamage --没有着火
        then
            if inst.sg:HasStateTag("landed") then --已经在睡觉了，重新进入，重载状态
                inst.sg:GoToState("land")
            elseif not inst.sg:HasStateTag("landing") then --没有正准备睡觉，进入睡觉状态
                inst.sg:GoToState("land_pre")
            end
        end
    end),
    EventHandler("doinfest", function(inst)
        if not inst.sg:HasStateTag("busy") and not inst.components.health:IsDead() then
            inst.sg:GoToState("doinfest")
        end
    end),
    CommonHandlers.OnFreeze(),
}


local states=
{
    State{
        name = "moving",
        tags = {"moving", "canrotate"},

        onenter = function(inst, pst)
            if inst.components.locomotor:WantsToRun() then
                inst.sg:GoToState("running", true)
            else
                if pst and not inst.AnimState:IsCurrentAnimation("idle_loop") then
                    inst.AnimState:PlayAnimation("run_pst")
                    inst.AnimState:PushAnimation("idle_loop")
                else
                    inst.AnimState:PlayAnimation("idle_loop")
                end
                inst.components.locomotor:WalkForward()
            end
        end,

        events =
        {
            ------------------------------------------------------
            --知识点----------------------------------------------
            --[[
                play的动画和push的动画结束之后都会发出animover事件，但是只有push的会发出animqueueover事件
                一旦push的动画结束，就没有动画播放了(循环播放除外)，所以animqueueover事件就代表了所有动画的播放结束
                另一个判断整个动画播放流程是否结束的方法是使用inst.AnimState:AnimDone()函数，和animqueueover事件相似
                所以如果不确定动画播放是否为播放序列或者单个动画，可以animover事件与AnimDone()函数一起使用来判断
            ]]----------------------------------------------------
            ------------------------------------------------------

            -- EventHandler("animqueueover", function(inst) inst.sg:GoToState("moving") end),
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("moving")
                end
            end),
        },
    },

    State{
        name = "running",
        tags = {"moving", "runrunrun", "canrotate"},

        onenter = function(inst, pre)
            if not inst.components.locomotor:WantsToRun() then
                inst.sg:GoToState("moving", true)
            else
                if IsTargetAround(inst) then --跟随对象在附近时使用idle动画而不是run动画，因为官方的run动画方向转换时破绽太大
                    if inst.AnimState:IsCurrentAnimation("run_loop") or inst.AnimState:IsCurrentAnimation("run_pre") then
                        inst.AnimState:PlayAnimation("run_pst")
                        inst.AnimState:PushAnimation("idle_loop")
                    else
                        inst.AnimState:PlayAnimation("idle_loop")
                    end
                elseif pre or inst.AnimState:IsCurrentAnimation("idle_loop") then --需要pre或者才从idle动画转换过来，则需要pre动画
                    inst.AnimState:PlayAnimation("run_pre")
                    inst.AnimState:PushAnimation("run_loop")
                else
                    inst.AnimState:PlayAnimation("run_loop")
                end
                inst.components.locomotor:RunForward()
            end
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("running")
                end
            end),
        },

        onexit = function(inst)
            if inst.components.locomotor.runspeed == 10 then --退出时更新一下速度状态，只有速度变化过了才会更新，不然更新啥
                IsTargetAround(inst)
            end
        end,
    },

    State{
        name = "death",
        tags = {"busy"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)
            inst.components.lootdropper:DropLoot(inst:GetPosition())
            inst.SoundEmitter:KillSound("buzz")
            inst.SoundEmitter:PlaySound(inst.sounds.death)
            LandFlyingCreature(inst)
        end,
    },

    State{
        name = "idle",
        tags = {"idle", "canrotate"},

        onenter = function(inst, pst)
            inst.Physics:Stop()
            if pst and not inst.AnimState:IsCurrentAnimation("idle_loop") then
                inst.AnimState:PlayAnimation("run_pst")
                inst.AnimState:PushAnimation("idle_loop")
            else
                inst.AnimState:PlayAnimation("idle_loop")
            end
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.sg.statemem.wantstomove then
                    inst.sg:GoToState("moving")
                else
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{ --被产生出来
        name = "spawn",
        tags = {"busy"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("spawn")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "attack",
        tags = {"busy"},

        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.sg.statemem.target = target
            inst.AnimState:PlayAnimation("attack_pre")
            inst.AnimState:PushAnimation("attack_pst", false)

            inst.components.combat.laststartattacktime = GetTime() --更新攻击时间，不然一直为nil，导致无时间周期的攻击
        end,

        timeline=
        {
            TimeEvent(18*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.attack) end),
            TimeEvent(20*FRAMES, function(inst)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
            end),
        },

        events=
        {
            EventHandler("animqueueover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

    State{
        name = "doinfest",
        tags = {"busy"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("attack_pre")
            inst.AnimState:PushAnimation("attack_pst", false)
        end,

        timeline=
        {
            TimeEvent(18*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.attack) end),
            TimeEvent(20*FRAMES, function(inst)
                if inst.infesttarget ~= nil and inst.infesttarget:IsValid() and inst:GetDistanceSqToInst(inst.infesttarget) <= 0.25 then
                    if inst.OnInfestPlant ~= nil then
                        inst.OnInfestPlant(inst, inst.infesttarget)
                    end
                end
            end),
        },

        events=
        {
            EventHandler("animqueueover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

    State{
        name = "hit",
        tags = {"busy"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("hit")
            inst.SoundEmitter:PlaySound(inst.sounds.hit)
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{ --从地上飞起来
        name = "takeoff",
        tags = {"busy"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("sleep_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{ --准备着地
        name = "land_pre",
        tags = {"busy", "landing"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("sleep_pre")
        end,

        events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("land")
            end),
        },
    },

    State{ --完全落地
        name = "land",
        tags = {"busy", "landing", "landed"},

        onenter = function(inst)
            inst.Physics:Stop()
            if not inst.AnimState:IsCurrentAnimation("sleep_loop") then
                inst.AnimState:PlayAnimation("sleep_loop", true)
            end
            inst.sg:SetTimeout(10)

            --睡觉时清除对象
            if inst.infesttarget ~= nil then
                inst.infesttarget.infester = nil --清除以前的标记
                inst.infesttarget = nil
            end
            inst.lighttarget = nil
            inst.components.combat:SetTarget(nil)

            --睡觉时解除无敌状态
            inst.components.health.invincible = false
            inst.components.combat.noimpactsound = nil

            LandFlyingCreature(inst)
        end,

        events=
        {
            EventHandler("takeoff", function(inst)
                if not inst.components.health:IsDead() then
                    inst.sg:GoToState("takeoff")
                end
            end),
            EventHandler("attacked", function(inst)
                if not inst.components.health:IsDead() then
                    inst.sg:GoToState("hit")
                end
            end),
        },

        ontimeout = function(inst)
            inst.sg:GoToState("takeoff")
        end,

        onexit = function(inst)
            --醒来时恢复无敌状态
            inst.components.health.invincible = true
            inst.components.combat.noimpactsound = true
            RaiseFlyingCreature(inst)
        end,
    },
}
CommonStates.AddFrozenStates(states, LandFlyingCreature, RaiseFlyingCreature)

return StateGraph("cropgnat", states, events, "spawn", actionhandlers)
