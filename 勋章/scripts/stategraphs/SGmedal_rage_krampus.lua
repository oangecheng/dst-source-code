require("stategraphs/commonstates")

local actionhandlers =
{
	ActionHandler(ACTIONS.PICKUP, "steal"),
	ActionHandler(ACTIONS.HAMMER, "hammer"),
}

local events=
{
    EventHandler("attacked", function(inst) if not inst.components.health:IsDead() and not inst.sg:HasStateTag("nointerrupt") and not inst.sg:HasStateTag("attack") and not CommonHandlers.HitRecoveryDelay(inst) then inst.sg:GoToState("hit") end end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    EventHandler("doattack", function(inst) if not inst.components.health:IsDead() and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then inst.sg:GoToState("attack") end end),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnLocomote(true,false),
    CommonHandlers.OnFreeze(),
}

local states=
{

    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst, playanim)
            if math.random() < .333 then inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/growlshort") end
            inst.Physics:Stop()
			inst.AnimState:PlayAnimation("idle", true)
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "attack",
        tags = {"attack"},

        onenter = function(inst, cb)
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PushAnimation("atk", false)
        end,

        timeline=
        {
            TimeEvent(0*FRAMES, function(inst) inst:PerformBufferedAction() inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/attack") end),
            TimeEvent(14*FRAMES, function(inst) inst:PerformBufferedAction() inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/kick_whoosh") end),
            TimeEvent(18*FRAMES, function(inst) inst.components.combat:DoAttack() end),
        },

        events=
        {
            EventHandler("animqueueover", function(inst)inst.sg:GoToState("idle") end),
        },
    },

   State{
        name = "hammer",
        tags = {"busy"},

        onenter = function(inst, cb)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PushAnimation("atk", false)
        end,

        timeline=
        {

            TimeEvent(0*FRAMES, function(inst)  inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/attack") end),
            TimeEvent(14*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/kick_whoosh") end),
            TimeEvent(18*FRAMES, function(inst) inst:PerformBufferedAction() inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/kick_impact") end),

        },

        events=
        {
            EventHandler("animqueueover", function(inst)inst.sg:GoToState("idle") end),
        },
    },

	State{
		name = "hit",
        tags = {"busy", "hit"},

        onenter = function(inst, cb)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("hit")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/hurt")
			CommonHandlers.UpdateHitRecoveryDelay(inst)
        end,

        events=
        {
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

	State{
		name = "devour",--灵魂吞噬
        tags = {"busy"},

        onenter = function(inst, cb)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/taunt")
            if inst.OnDevourSoul then
                inst:OnDevourSoul()
            end
        end,

        events=
        {
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

	State{
        name = "death",
        tags = {"busy"},

        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/death")
            inst.AnimState:PlayAnimation("death")
            inst.components.locomotor:StopMoving()
            --死过一次的就别再死了
			if not inst.died_once then
				inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
				inst.died_once=true
				--生成雕像皮肤券
                local skin_coupon = SpawnPrefab("medal_skin_coupon")
                if skin_coupon then
                    if skin_coupon.setSkinData then
                        skin_coupon:setSkinData("medal_statue_marble_changeable",4)
                    end
                    inst.components.lootdropper:FlingItem(skin_coupon)
                end
                --统计死亡次数
                if TheWorld and TheWorld.components.medal_infosave then
                    TheWorld.components.medal_infosave:CountChaosCreatureDeathTimes(inst)
                end
			end
        end,

    },


    State{
        name = "exit",
        tags = {"busy", "nointerrupt"},

        onenter = function(inst)
			--inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/death")
			inst.components.health:SetInvincible(true)
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)
            inst.AnimState:PlayAnimation("exit")
            inst:SetBrain(nil)
        end,

		timeline=
        {
            TimeEvent(11*FRAMES, function(inst) inst:PerformBufferedAction() inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/bag_drop") end),
            TimeEvent(30*FRAMES, function(inst) inst:PerformBufferedAction() inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/bag_jumpinto") end),
            TimeEvent(40*FRAMES, function(inst) inst:PerformBufferedAction() inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/bag_dissappear") end),

        },

		events=
        {
			EventHandler("animover", function(inst) inst:Remove() end),
        },


    },

	State{
        name = "steal",
        tags = {"busy"},

        onenter = function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/growllong")

            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("steal_pre")
            inst.AnimState:PushAnimation("steal", false)
        end,

		timeline=
        {

			TimeEvent(18*FRAMES, function(inst) inst:PerformBufferedAction() end),
			TimeEvent(14*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/bag_swing") end),
        },


		events=
        {
			EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{--跳到目标边上去
        name = "jumptotarget",
        tags = {"busy", "nointerrupt"},

        onenter = function(inst)
			inst.components.health:SetInvincible(true)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("exit")
        end,

		timeline=
        {
            TimeEvent(11*FRAMES, function(inst) inst:PerformBufferedAction() inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/bag_drop") end),
            TimeEvent(30*FRAMES, function(inst) inst:PerformBufferedAction() inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/bag_jumpinto") end),
            TimeEvent(40*FRAMES, function(inst) inst:PerformBufferedAction() inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/bag_dissappear") end),
            TimeEvent(48*FRAMES, function(inst) 
                local lenghth = inst.AnimState:GetCurrentAnimationLength()
                inst.AnimState:SetTime((lenghth or 2.3) - FRAMES)
            end),

        },

		events=
        {
			EventHandler("animover", function(inst)
                inst.components.health:SetInvincible(false)
                if inst.components.combat and inst.components.combat.target ~= nil then
                    local pt = inst.components.combat.target:GetPosition()
                    local offset = FindWalkableOffset(pt, math.random() * 2 * PI, 2, 3, false, true, function(pt) return not TheWorld.Map:IsPointNearHole(pt) end, false, true)
					if offset ~= nil then
                        inst.Transform:SetPosition(pt.x + offset.x, 0, pt.z + offset.z)
                        -- SpawnPrefab("statue_transition").Transform:SetPosition(x, 0, z)
                        SpawnPrefab("dreadstone_spawn_fx").Transform:SetPosition(pt.x + offset.x, 0, pt.z + offset.z)
                    end
                end
                inst.sg:GoToState("idle")
                inst.components.combat:TryAttack(inst.components.combat.target)
            end),
        },
    },
}

CommonStates.AddSleepStates(states,
{
	sleeptimeline = {
        TimeEvent(30*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/sleep") end),
	},
})


CommonStates.AddRunStates(states,
{
	runtimeline = {
		TimeEvent(0, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/growlshort")
									PlayFootstep(inst)
								end),
		TimeEvent(2*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/bag_foley") end),
		TimeEvent(4*FRAMES, function(inst) PlayFootstep(inst) end),
		TimeEvent(6*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/bag_foley") end),

	},
})
CommonStates.AddFrozenStates(states)



return StateGraph("SGmedal_rage_krampus", states, events, "devour", actionhandlers)

