require("stategraphs/commonstates")

local function ValidTarget(target)
    if target and target:IsValid() then
        if target.components.health ~= nil and not target.components.health:IsDead() then   --有生命对象还没死
            return true
        elseif target.components.workable ~= nil and target.components.workable.action ~= ACTIONS.DIG then   --对象能被破坏
            return true
        end
    end

    return false
end

local function GetDistance(inst, target)    --得到的是距离的平方
    return target:GetDistanceSqToPoint(inst.Transform:GetWorldPosition())
end

local function FindTarget(inst, radius)
    return FindEntity(inst, radius, function(item) return ValidTarget(item) end, nil, {"NOCLICK", "FX", "shadow", "playerghost", "INLIMBO"}, nil)
end

local function TestRange(inst, target, radius_min, radius_max)  --最大范围与最小范围的数值都是平方值
    local distsq = GetDistance(inst, target)
    return distsq > radius_min and distsq <= radius_max
end

local function TestSkill(inst)    --测试是否需要进行特殊攻击的判断
    local last = inst.last_skilltest
    inst.last_skilltest = GetTime() --更新技能测试时间
    return inst.components.combat.target ~= nil and not inst.components.health:IsDead() and (GetTime() - last) >= 0.5
end

local function ChooseAttack(inst)    --判断使用哪种特殊攻击
    if inst.wantstotaunt then
        inst.wantstotaunt = false
        inst.sg:GoToState("taunt")
        return true
    else
        --逻辑版的判断方式，根据逻辑来判断，易理解，但会有多余且不必要的函数运行
        -- --激怒状态的技能
        -- if inst.irritated then
        --     if not inst.components.timer:TimerExists("flashwhirl_cd") then
        --         if FindTarget(inst, inst.flashwhirl_radius) ~= nil then
        --             inst.sg:GoToState("flashwhirl")
        --             return true
        --         end
        --     elseif not inst.components.timer:TimerExists("rangesplash_cd") then
        --         if ValidTarget(inst.components.combat.target) and TestRange(inst, inst.components.combat.target, inst.rangesplash_radius_min_sq, inst.rangesplash_radius_max_sq) then
        --             inst.sg:GoToState("rangesplash", inst.components.combat.target)
        --             return true
        --         end
        --     end
        -- end
        
        -- --普通状态的技能
        -- if not inst.components.timer:TimerExists("axeuppercut_cd") then
        --     local target = FindTarget(inst, inst.hit_range)
        --     if target ~= nil then
        --         inst.sg:GoToState("axeuppercut", target)
        --         return true
        --     end
        -- elseif not inst.components.timer:TimerExists("callforlightning_cd") then
        --     inst.sg:GoToState("callforlightning")
        --     return true
        -- elseif not inst.components.timer:TimerExists("heavyhack_cd") then
        --     if ValidTarget(inst.components.combat.target) and GetDistance(inst, inst.components.combat.target) > inst.heavyhack_radius_sq then
        --         inst.sg:GoToState("dashhack2", inst.components.combat.target)
        --         return true
        --     end
        -- end

        --优化版的判断方式，麻烦的函数只需要运行1次
        if not inst.components.timer:TimerExists("callforlightning_cd") then
            inst.sg:GoToState("callforlightning")
            return true
        end

        local rangesplash_done = inst.irritated and not inst.components.timer:TimerExists("rangesplash_cd")
        local heavyhack_done = not inst.components.timer:TimerExists("heavyhack_cd")
        if rangesplash_done or heavyhack_done then
            if ValidTarget(inst.components.combat.target) then
                local dis = GetDistance(inst, inst.components.combat.target)
                if dis <= inst.rangesplash_radius_max_sq then
                    if rangesplash_done and dis > inst.rangesplash_radius_min_sq then
                        inst.sg:GoToState("rangesplash", inst.components.combat.target)
                        return true
                    end

                    if heavyhack_done and dis > inst.heavyhack_radius_sq then
                        inst.sg:GoToState("dashhack2", inst.components.combat.target)
                        return true
                    end
                end
            end
        end

        local flashwhirl_done = inst.irritated and not inst.components.timer:TimerExists("flashwhirl_cd")
        local axeuppercut_done = not inst.components.timer:TimerExists("axeuppercut_cd")
        if flashwhirl_done or axeuppercut_done then
            local rad = flashwhirl_done and inst.flashwhirl_radius or inst.hit_range
            local target = FindTarget(inst, rad)
            if target ~= nil then
                if flashwhirl_done then
                    inst.sg:GoToState("flashwhirl")
                    return true
                else
                    inst.sg:GoToState("axeuppercut", target)
                    return true
                end
            end
        end
    end

    return false
end

-- local actionhandlers =
-- {
--     --nothing
-- }

local events =
{
    CommonHandlers.OnSleep(),
    CommonHandlers.OnLocomote(false, true),
    CommonHandlers.OnDeath(),
    -- CommonHandlers.OnFreeze(),
    --CommonHandlers.OnAttacked(),

    EventHandler("attacked", function(inst) 
        if
            inst.components.health ~= nil and not inst.components.health:IsDead()
            and not inst.sg:HasStateTag("hit")
            and not inst.sg:HasStateTag("busy")
        then
            inst.sg:GoToState("hit")
        end
    end),

    EventHandler("doattack", function(inst)   --可以进行普通攻击时，收到这个事件
        if not inst.sg:HasStateTag("busy") and inst.components.health ~= nil and not inst.components.health:IsDead() then
            if not ChooseAttack(inst) then
                inst.sg:GoToState("axewave_first", inst.components.combat.target)
            end
        end
    end),
}

local states =
{

    State{
        name = "idle",
        tags = { "idle", "canrotate" },
        onenter = function(inst)
            -- inst.Physics:Stop()
            inst.components.locomotor:StopMoving()

            if TestSkill(inst) then
                if not ChooseAttack(inst) then
                    inst.AnimState:PlayAnimation("idle_loop", true)
                end
            else
                inst.AnimState:PlayAnimation("idle_loop", true)
            end
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

    State{  --被打
        name = "hit",
        tags = { "hit" },

        onenter = function(inst)
            -- inst.Physics:Stop()
            inst.components.locomotor:StopMoving()
            inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/boarrior/bonehit2")
            inst.SoundEmitter:PlaySound("dontstarve/forge2/beetletaur/chain_hit")
            inst.AnimState:PlayAnimation("hit")
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

    State{  --死亡
        name = "death",
        tags = { "busy" },

        onenter = function(inst)
            -- inst.Physics:Stop()
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("death2")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/boarrior/bonehit2")
            inst.SoundEmitter:PlaySound("dontstarve/common/together/celestial_orb/active")
            inst:AddTag("NOCLICK")
            RemovePhysicsColliders(inst)
        end,

        timeline =
        {
            TimeEvent(30 * FRAMES, function(inst) 
                inst.SoundEmitter:PlaySound("dontstarve/forge2/beetletaur/chain_hit")
            end),
            TimeEvent(50 * FRAMES, function(inst) 
                inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/boarrior/bonehit1")
                inst.SoundEmitter:PlaySound("dontstarve/forge2/beetletaur/chain_hit")
            end),
            TimeEvent(55 * FRAMES, function(inst) 
                inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/boarrior/death_bodyfall")
            end),
            TimeEvent(70 * FRAMES, function(inst)  
                inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/boarrior/bonehit2")
                inst.SoundEmitter:PlaySound("dontstarve/forge2/beetletaur/chain_hit")
                inst.components.lootdropper:DropLoot(inst:GetPosition())
            end),
        },
    },

    State{  --挥击1
        name = "axewave_first",
        tags = { "attack", "busy" },

        onenter = function(inst, target)
            -- inst.Physics:Stop()
            inst.components.locomotor:StopMoving()

            inst.components.combat:StartAttack()    --准备攻击，面朝敌人
            inst.sg.statemem.target = target

            inst.AnimState:PlayAnimation("attack1")
            if not inst.irritated then
                inst.AnimState:PushAnimation("attack1_pst", false)
            end
        end,

        timeline =
        {
            TimeEvent(8 * FRAMES, function(inst) 
                inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/boarrior/swipe")
                inst.SoundEmitter:PlaySound("dontstarve/forge2/beetletaur/chain_hit")
            end),
            TimeEvent(12 * FRAMES, function(inst)  
                inst.components.combat:DoAttack(inst.sg.statemem.target)    --实施攻击，伤害计算

                if not inst.irritated then  --非暴怒状态时，这时就提前删除被打无反应标签
                    inst.sg:RemoveStateTag("attack")
                    inst.sg:RemoveStateTag("busy")
                end
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    if inst.irritated and ValidTarget(inst.sg.statemem.target) then  --暴怒状态+敌方没死进入第二下攻击
                        inst.sg:GoToState("axewave_second", inst.sg.statemem.target)
                    else
                        inst.sg:GoToState("idle")
                    end
                end
			end),
        },
    },
    
    State{  --挥击2
        name = "axewave_second",
        tags = { "busy", "attack" },
        onenter = function(inst, target)
            inst.sg.statemem.target = target
            -- inst.Physics:Stop()
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("attack2")
            inst.AnimState:PushAnimation("attack2_pst", false)
        end,
        
        timeline =
        {
            TimeEvent(3 * FRAMES, function(inst) -- 9 frames total
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/boarrior/swipe")
                inst.SoundEmitter:PlaySound("dontstarve/forge2/beetletaur/chain_hit")

                inst.sg:RemoveStateTag("attack")
                inst.sg:RemoveStateTag("busy")
            end), 
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    -- State{  --重锤，方式1
    --     name = "heavyhack",
    --     tags = { "attack", "busy" },

    --     onenter = function(inst, target)            
    --         -- inst.Physics:Stop()
    --         inst.components.locomotor:StopMoving()

    --         inst:ForceFacePoint(target.Transform:GetWorldPosition())
    --         -- inst.sg.statemem.target = target
    --         inst.sg.statemem.tpos = target:GetPosition()

    --         inst.AnimState:PlayAnimation("attack5", false)
    --     end,

    --     timeline =
    --     {
    --         TimeEvent(10 * FRAMES, function(inst)
    --             SpawnPrefab("fimbul_cracklebase_fx").Transform:SetPosition(inst.sg.statemem.tpos:Get())
    --             -- inst.HeavyHack(inst, inst.sg.statemem.tpos)
    --             inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/boarrior/bonehit2")
    --         end),
    --         TimeEvent(40 * FRAMES, function(inst)
    --             SpawnPrefab("fimbul_cracklebase_fx").Transform:SetPosition(inst.sg.statemem.tpos:Get())
    --             -- inst.HeavyHack(inst, inst.sg.statemem.tpos)
    --             inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/boarrior/bonehit2")
    --         end),
    --     },

    --     events =
    --     {
    --         EventHandler("animover", function(inst)
    --             if inst.AnimState:AnimDone() then
    --                 inst.sg:GoToState("idle")
    --             end
    --         end),
    --     },

    --     onexit = function(inst)
    --         if not inst.components.timer:TimerExists("heavyhack_cd") then
    --             inst.components.timer:StartTimer("heavyhack_cd", inst.heavyhack_cd)
    --         end
    --     end,
    -- },

    -- State{  --重锤，方式2
    --     name = "dashhack",
    --     tags = { "attack", "busy" },

    --     onenter = function(inst, target)   
    --         inst.components.locomotor:StopMoving()

    --         inst.sg.statemem.target = target
    --         inst.sg.statemem.tpos = target:GetPosition()

    --         inst.AnimState:PlayAnimation("dash")

    --         local x, y, z = target.Transform:GetWorldPosition()
    --         local distsq = inst:GetDistanceSqToPoint(x, y, z)
    --         local rangesq = inst.heavyhack_radius_dash * inst.heavyhack_radius_dash
    --         local rot = inst.Transform:GetRotation()
    --         local rot1 = distsq > 0 and inst:GetAngleToPoint(x, y, z) or target.Transform:GetRotation() + 180
    --         local drot = math.abs(rot - rot1)
    --         while drot > 180 do
    --             drot = math.abs(drot - 360)
    --         end
    --         local k = distsq < rangesq and .3 * distsq / rangesq - 1 or -.7
    --         inst.sg.statemem.speed = 1 * 8 * k * 2
    --         inst.sg.statemem.dspeed = 0
    --         if drot > 90 then
    --             inst.sg.statemem.reverse = true
    --             inst.Transform:SetRotation(rot1 + 180)
    --             inst.Physics:SetMotorVel(-inst.sg.statemem.speed, 0, 0)
    --         else
    --             inst.Transform:SetRotation(rot1)
    --             inst.Physics:SetMotorVel(inst.sg.statemem.speed, 0, 0)
    --         end

    --         if not inst.components.timer:TimerExists("heavyhack_cd") then
    --             inst.components.timer:StartTimer("heavyhack_cd", inst.heavyhack_cd)
    --         end
    --     end,

    --     onupdate = function(inst)
    --         if inst.sg.statemem.speed ~= nil then
    --             inst.sg.statemem.speed = inst.sg.statemem.speed + inst.sg.statemem.dspeed
    --             if inst.sg.statemem.speed < 0 then
    --                 inst.sg.statemem.dspeed = inst.sg.statemem.dspeed + .075
    --                 inst.Physics:SetMotorVel(inst.sg.statemem.reverse and -inst.sg.statemem.speed or inst.sg.statemem.speed, 0, 0)
    --             else
    --                 inst.sg.statemem.speed = nil
    --                 inst.sg.statemem.dspeed = nil
    --                 inst.Physics:Stop()
    --             end
    --         end
    --     end,

    --     timeline =
    --     {
    --         TimeEvent(15 * FRAMES, function(inst)
    --             inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
    --             inst.AnimState:PlayAnimation("attack5", false)
    --         end),

    --         TimeEvent(25 * FRAMES, function(inst)
    --             inst.HeavyHack(inst, inst.sg.statemem.tpos, false)
    --             inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/boarrior/bonehit2")
    --         end),

    --         TimeEvent(55 * FRAMES, function(inst)
    --             inst.HeavyHack(inst, inst.sg.statemem.tpos, true)
    --             inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/boarrior/bonehit2")
    --         end),
    --     },

    --     events =
    --     {
    --         EventHandler("animover", function(inst)
    --             if inst.AnimState:AnimDone() then
    --                 if inst.AnimState:IsCurrentAnimation("attack5") then
    --                     inst.sg:GoToState("idle")
    --                 end
    --             end
    --         end),
    --     },

    --     onexit = function(inst)
    --         if inst.sg.statemem.speed ~= nil then
    --             inst.Physics:Stop()
    --         end
    --     end,
    -- },

    State{  --重锤，方式3
        name = "dashhack2",
        tags = { "attack", "busy" },

        onenter = function(inst, target)   
            -- inst.Physics:Stop()
            inst.components.locomotor:StopMoving()

            local x, y, z = inst.Transform:GetWorldPosition()
            local xt, yt, zt = target.Transform:GetWorldPosition()
            local ang = inst:GetAngleToPoint(xt, yt, zt)
            inst.sg.statemem.target = target
            inst.sg.statemem.atkangle = math.deg(math.atan2(z - zt, xt - x))
            inst.sg.statemem.teleangle = ang * DEGREES --DEGREES = PI/180
            inst:ForceFacePoint(xt, yt, zt)

            inst.AnimState:PlayAnimation("dash") 
            inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/boarrior/bonehit1")
            inst.SoundEmitter:PlaySound("dontstarve/forge2/beetletaur/chain_hit")

            if not inst.components.timer:TimerExists("heavyhack_cd") then
                inst.components.timer:StartTimer("heavyhack_cd", inst.heavyhack_cd)
            end
        end,

        timeline =
        {
            TimeEvent(1*FRAMES, function(inst)
                SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(inst.Transform:GetWorldPosition())
                inst.HeavyHack(inst, inst.sg.statemem.atkangle)
            end),
            TimeEvent(2 * FRAMES, function(inst) 
                inst.DashStep(inst, inst.sg.statemem.teleangle)
            end),
            TimeEvent(3 * FRAMES, function(inst) 
                inst.DashStep(inst, inst.sg.statemem.teleangle)
            end),
            TimeEvent(4 * FRAMES, function(inst) 
                inst.DashStep(inst, inst.sg.statemem.teleangle)
            end),
            TimeEvent(5 * FRAMES, function(inst) 
                inst.DashStep(inst, inst.sg.statemem.teleangle)
                inst.SoundEmitter:PlaySound("dontstarve/forge2/beetletaur/chain_hit")
            end),
            TimeEvent(6 * FRAMES, function(inst) 
                inst.DashStep(inst, inst.sg.statemem.teleangle)
            end),
            TimeEvent(7 * FRAMES, function(inst) 
                inst.DashStep(inst, inst.sg.statemem.teleangle)
            end),
            TimeEvent(8 * FRAMES, function(inst) 
                inst.DashStep(inst, inst.sg.statemem.teleangle)
            end),
            TimeEvent(9 * FRAMES, function(inst)
                inst.DashStep(inst, inst.sg.statemem.teleangle)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/boarrior/bonehit2")
                inst.SoundEmitter:PlaySound("dontstarve/forge2/beetletaur/chain_hit")
            end),
            TimeEvent(10 * FRAMES, function(inst)
                inst.DashStep(inst, inst.sg.statemem.teleangle)
                inst.sg:GoToState("axewave_first", inst.sg.statemem.target)
            end),
        },
    },

    State{  --飞溅
        name = "rangesplash",
        tags = { "attack", "busy" },

        onenter = function(inst, target)
            -- inst.Physics:Stop()
            inst.components.locomotor:StopMoving()

            inst:ForceFacePoint(target.Transform:GetWorldPosition())
            inst.sg.statemem.target = target

            inst.AnimState:PlayAnimation("attack1")
            inst.AnimState:PushAnimation("attack1_pst", false)

            if not inst.components.timer:TimerExists("rangesplash_cd") then
                inst.components.timer:StartTimer("rangesplash_cd", inst.rangesplash_cd)
            end
        end,

        timeline =
        {
            TimeEvent(8 * FRAMES, function(inst) 
                inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/boarrior/swipe")
                inst.SoundEmitter:PlaySound("dontstarve/forge2/beetletaur/chain_hit")
            end),
            TimeEvent(12 * FRAMES, function(inst)
                if ValidTarget(inst.sg.statemem.target) then
                    inst:RangeSplash(inst.sg.statemem.target)
                end
                inst.sg:RemoveStateTag("attack")
                inst.sg:RemoveStateTag("busy")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        -- onexit = function(inst)
        --     if not inst.components.timer:TimerExists("rangesplash_cd") then
        --         inst.components.timer:StartTimer("rangesplash_cd", inst.rangesplash_cd)
        --     end
        -- end,
    },

    State{  --战吼自爆
        name = "taunt",
        tags = { "attack", "busy" },

        onenter = function(inst)
            -- inst.Physics:Stop()
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("taunt")
        end,

        timeline =
        {
            TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/forge2/beetletaur/chain_hit") end),
            TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/forge2/beetletaur/chain_hit") end),
            TimeEvent(13 * FRAMES, function(inst)
                inst.BattleCry(inst)

                if inst.irritated and not inst.hasirritatedskin then --确保只执行一次这个函数
                    inst.OnIrritated(inst)
                end

                inst.SoundEmitter:PlaySound("dontstarve/forge2/beetletaur/chain_hit")
                inst.SoundEmitter:PlaySound("dontstarve/common/together/celestial_orb/active")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{  --上挥
        name = "axeuppercut",
        tags = { "busy", "attack" },
        onenter = function(inst, target)
            -- inst.Physics:Stop()
            inst.components.locomotor:StopMoving()
            
            inst:ForceFacePoint(target.Transform:GetWorldPosition())
            inst.sg.statemem.target = target

            inst.AnimState:PlayAnimation("attack3")

            if not inst.components.timer:TimerExists("axeuppercut_cd") then
                inst.components.timer:StartTimer("axeuppercut_cd", inst.axeuppercut_cd)
            end
        end,
        
        timeline =
        {
            TimeEvent(6*FRAMES, function(inst) 
                inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/boarrior/swipe")
                inst.SoundEmitter:PlaySound("dontstarve/forge2/beetletaur/chain_hit")
            end),
            TimeEvent(7 * FRAMES, function(inst) --25 frames total
                if ValidTarget(inst.sg.statemem.target) and inst:IsNear(inst.sg.statemem.target, inst.hit_range) then
                    inst.AxeUppercut(inst, inst.sg.statemem.target)
                end
            end),

            TimeEvent(13 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("attack")
                inst.sg:RemoveStateTag("busy")
            end), 
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        -- onexit = function(inst)
        --     if not inst.components.timer:TimerExists("axeuppercut_cd") then
        --         inst.components.timer:StartTimer("axeuppercut_cd", inst.axeuppercut_cd)
        --     end
        -- end,
    },

    State{  --旋风
        name = "flashwhirl",
        tags = { "attack", "busy" },
        onenter = function(inst)
            -- inst.Physics:Stop()
            inst.components.locomotor:StopMoving()

            inst.AnimState:PlayAnimation("attack4") 

            if not inst.components.timer:TimerExists("flashwhirl_cd") then
                inst.components.timer:StartTimer("flashwhirl_cd", inst.flashwhirl_cd)
            end
        end,
        
        timeline =
        {
            TimeEvent(9 * FRAMES, function(inst) 
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado", "spinLoop") 
            end),
            TimeEvent(13 * FRAMES, function(inst) 
                inst.FlashWhirl(inst)
            end),
            TimeEvent(24 * FRAMES, function(inst) 
                inst.SoundEmitter:KillSound("spinLoop")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/boarrior/spin")
                inst.FlashWhirl(inst)
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        -- onexit = function(inst)
        --     if not inst.components.timer:TimerExists("flashwhirl_cd") then
        --         inst.components.timer:StartTimer("flashwhirl_cd", inst.flashwhirl_cd)
        --     end
        -- end,
    },

    State{  --招雷
        name = "callforlightning",
        tags = { "busy", "casting" },
        onenter = function(inst)
            -- inst.Physics:Stop()
            inst.components.locomotor:StopMoving()

            inst.AnimState:PlayAnimation("banner_pre")
            inst.AnimState:PushAnimation("banner_loop", false)
            inst.sg.statemem.loops = 0

            if not inst.components.timer:TimerExists("callforlightning_cd") then
                inst.components.timer:StartTimer("callforlightning_cd", inst.callforlightning_cd)
            end
        end,

        events = {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    if inst.AnimState:IsCurrentAnimation("banner_pst") then
                        inst.sg:GoToState("idle")
                    elseif inst.AnimState:IsCurrentAnimation("banner_loop") and inst.sg.statemem.loops <= 15 then
                        inst.AnimState:PlayAnimation("banner_loop", false)
                        inst.SoundEmitter:PlaySound("dontstarve/forge2/beetletaur/chain_hit")
                        inst.CallForLightning(inst)
                        inst.sg.statemem.loops = inst.sg.statemem.loops + 1
                    else
                        inst.AnimState:PlayAnimation("banner_pst", false)
                    end
                elseif inst.AnimState:IsCurrentAnimation("banner_pre") or inst.AnimState:IsCurrentAnimation("banner_loop") then
                    inst.SoundEmitter:PlaySound("dontstarve/forge2/beetletaur/chain_hit")
                end
            end),
        },

        -- onexit = function(inst)
        --     if not inst.components.timer:TimerExists("callforlightning_cd") then
        --         inst.components.timer:StartTimer("callforlightning_cd", inst.callforlightning_cd)
        --     end
        -- end,
    },

    State{
        name = "forcesleep",
        tags = { "busy", "sleeping" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("sleep_loop", true)
        end,
    },
}

CommonStates.AddSleepStates(states,
{
    sleeptimeline = {
        TimeEvent(0, function(inst) 
            inst.SoundEmitter:PlaySound("dontstarve/ghost/ghost_howl") 
        end),
        TimeEvent(15 * FRAMES, function(inst) 
            inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/boarrior/bonehit1") 
        end),
    },
})

CommonStates.AddWalkStates(states,
{
    walktimeline =
    {
        TimeEvent(0, function(inst) 
            -- ShakeAllCameras(CAMERASHAKE.VERTICAL, .5, .03, 1, inst, 30)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/boarrior/bonehit1")
            inst.SoundEmitter:PlaySound("dontstarve/forge2/beetletaur/chain_hit")
        end),
        TimeEvent(18, function(inst) 
            -- ShakeAllCameras(CAMERASHAKE.VERTICAL, .5, .03, 1, inst, 30)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/boarrior/bonehit1")
            inst.SoundEmitter:PlaySound("dontstarve/forge2/beetletaur/chain_hit")
        end),
    },
})

CommonStates.AddFrozenStates(states)

return StateGraph("elecarmet", states, events, "idle", nil)
