-- require("stategraphs/commonstates")

local events =
{
    -- CommonHandlers.OnLocomote(true, true),
    EventHandler("locomote", function(inst) 
        if not inst.sg:HasStateTag("busy") and not inst.sg:HasStateTag("moving") and
            inst.components.locomotor:WantsToMoveForward()
        then
            inst.sg:GoToState("moving")
        end
    end),
}

local states =
{
    State{
        name = "powerdown_pre",
        tags = {"busy"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()

            inst.AnimState:PlayAnimation("proximity_pst")
            inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
        end,

        timeline =
        {
            TimeEvent(5 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/common/together/book_maxwell/close")
            end),
            -- TimeEvent(6 * FRAMES, function(inst)
            --     inst.SoundEmitter:KillSound("idlesound")
            -- end),
            TimeEvent(15 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/common/together/book_maxwell/drop")
            end),
        },

        ontimeout = function(inst)
            inst.sg:GoToState("powerdown")
        end,
    },
    State{
        name = "powerdown",
        tags = {"busy"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()

            inst.AnimState:PlayAnimation("idle")
            inst.sg:SetTimeout(0.8)
        end,

        ontimeout = function(inst)
            if inst.components.finiteuses:GetUses() > 0 then
                inst.sg:GoToState("powerdown_pst")
            else
                inst.sg:GoToState("powerdown")
            end
        end,
    },
    State{
        name = "powerdown_pst",
        tags = {"busy"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()

            inst.AnimState:PlayAnimation("proximity_pre")
            inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("idle")
        end,
    },

    State{
        name = "moving",
        tags = { "moving", "canrotate" },

        onenter = function(inst)
            if inst.components.finiteuses:GetUses() <= 0 then
                inst.sg:GoToState("powerdown_pre")
            elseif inst._needheal then
                inst.sg:GoToState("castspell")
            elseif inst.components.follower:GetLeader() == nil then
                inst.sg:GoToState("idle")
            else
                inst.components.locomotor:WalkForward()

                if not inst.AnimState:IsCurrentAnimation("proximity_loop") then
                    inst.AnimState:PlayAnimation("proximity_loop", true)
                end

                -- inst.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/spawn", nil, .2)

                inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
            end
        end,

        ontimeout = function(inst)
            if inst.components.locomotor:WantsToMoveForward() then
                inst.sg:GoToState("moving")
            else
                inst.sg:GoToState("idle")
            end
        end,
    },

    State{
        name = "idle",
        tags = {"idle"},

        onenter = function(inst)
            if inst.components.finiteuses:GetUses() <= 0 then
                inst.sg:GoToState("powerdown_pre")
            elseif inst._needheal then
                inst.sg:GoToState("castspell")
            else
                inst.components.locomotor:StopMoving()

                if not inst.AnimState:IsCurrentAnimation("proximity_loop") then
                    inst.AnimState:PlayAnimation("proximity_loop", true)
                end

                --暗影秘典的声音不太符合契约
                -- if not inst.SoundEmitter:PlayingSound("idlesound") then
                --     inst.SoundEmitter:PlaySound("dontstarve/common/together/book_maxwell/active_LP", "idlesound", 0.5)
                -- end
                --灵魂的挣扎声
                if math.random() <= 0.25 then
                    inst.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/spawn", nil, .2)
                end

                inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
            end
        end,

        TimeEvent(12 * FRAMES, function(inst)
            if math.random() <= 0.3 then
                inst.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/spawn", nil, .2)
            end
        end),

        ontimeout = function(inst)
            inst.sg:GoToState("idle")
        end,
    },

    State{
        name = "castspell",
        tags = {"busy", "doing"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()

            inst.AnimState:PlayAnimation("use")
            inst.AnimState:Hide("FX")

            inst.SoundEmitter:PlaySound("dontstarve/common/together/book_maxwell/use")

            inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
        end,

        timeline =
        {
            TimeEvent(0.3, function(inst)
                if not inst.components.inventoryitem:IsHeld() then
                    inst._SoulHealing(inst)
                    inst.components.finiteuses:Use(1)
                    inst._needheal = false

                    local fx = SpawnPrefab(inst._dd and inst._dd.fx or "wortox_soul_in_fx")
                    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
                    fx:Setup(inst)
                end
            end),
        },

        ontimeout = function(inst)
            inst.sg:GoToState("idle")
        end,
    },
}

-- CommonStates.AddSimpleWalkStates(states, "proximity_loop")
-- CommonStates.AddSimpleRunStates(states, "proximity_loop")

return StateGraph("soul_contracts", states, events, "powerdown")
