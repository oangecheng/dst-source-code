require("stategraphs/commonstates")

local actionhandlers =
{
}

local events =
{
    CommonHandlers.OnLocomote(false, true),

    EventHandler("death", function(inst)
		inst.sg:GoToState("death", "death")
	end),

    EventHandler("doattack", function(inst)
        if not (inst.sg:HasStateTag("busy")) then
            inst.sg:GoToState("attack")
        end
    end),
}

local function FindBestAttackTarget(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
    local closestPlayer = nil
	local rangesq = TUNING_MEDAL.MEDAL_GESTALT_ATTACK_HIT_RANGE_SQ
    for i, v in ipairs(AllPlayers) do
        if not IsEntityDeadOrGhost(v) and v.entity:IsVisible() then
            local distsq = v:GetDistanceSqToPoint(x, y, z)
            if distsq < rangesq then
                rangesq = distsq
                closestPlayer = v
            end
        end
    end
    return closestPlayer
end

local function NoHoles(pt)
    return not TheWorld.Map:IsPointNearHole(pt)
end

local function DoSpecialAttack(inst, target)
	if target.components.health and not target.components.health:IsDead() and not target:HasTag("playerghost") then
        --有黑暗血糖
        if target.components.debuffable and target.components.debuffable:HasDebuff("buff_medal_suckingblood") then
            --时之伤还是会加
            target.components.health:DoDeltaMedalDelayDamage(TUNING_MEDAL.MEDAL_GESTALT_DELAY_DAMAGE)
            --暗影盾
            local fx=SpawnPrefab("medal_shield_player")
			if fx then fx.entity:SetParent(target.entity) end
            --抵消buff时长
            target.components.debuffable:AddDebuff("buff_medal_suckingblood", "buff_medal_suckingblood",{extend_durationfn=function(timer_left)
                return math.max(0,timer_left - TUNING_MEDAL.MEDAL_BUFF_SUCKINGBLOOD_GESTALT_CONSUME)
            end})
        else
            inst.components.combat:DoAttack(target)
            --时之伤
            target.components.health:DoDeltaMedalDelayDamage(TUNING_MEDAL.MEDAL_GESTALT_DELAY_DAMAGE)
            local pt = Vector3(target.Transform:GetWorldPosition())
            local offset = FindWalkableOffset(pt, math.random() * 2 * PI, math.random()*7+3, 8, true, false, NoHoles)
            if offset then
                local newpt = pt + offset
                SpawnPrefab("medal_spark_shock_fx").Transform:SetPosition(pt.x, 0, pt.z)
                if target.Physics ~= nil then
                    target.Physics:Teleport(newpt.x, 0, newpt.z)
                elseif target.Transform ~= nil then
                    target.Transform:SetPosition(newpt.x, 0, newpt.z)
                end
                SpawnPrefab("medal_spark_shock_fx").Transform:SetPosition(newpt.x, 0, newpt.z)
            end
        end
    end
end

local states=
{
    State{
        name = "idle",
        tags = {"idle", "canrotate"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("idle")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "emerge",
        tags = {"busy", "noattack", "canrotate"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("emerge")
        end,

        timeline=
        {
            --TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/rabbit/hop") end ),
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "death",
        tags = {"busy", "noattack"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("melt")
            inst.persists = false
        end,

        events =
        {
            EventHandler("animover", function(inst) inst:Remove() end),
        },

        onexit = function(inst)
        end,
    },

    State{
        name = "relocate",
        tags = {"busy", "noattack", "canrotate"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("melt")
        end,

        timeline=
        {
            --TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/rabbit/hop") end ),
        },

        events =
        {
            EventHandler("animover", function(inst)
				inst.sg:GoToState("relocating")
			end),
        },
    },

    State{
        name = "relocating",
        tags = {"busy", "noattack", "hidden"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
			inst:Hide()
            inst.sg:SetTimeout(math.random() * 0.5 + 0.25)
        end,

        ontimeout = function(inst)
			if inst.needremove then
                inst:Remove()
            else
                inst.sg.statemem.dest = inst:FindRelocatePoint()
                if inst.sg.statemem.dest ~= nil then
                    inst.sg:GoToState("emerge")
                else
                    inst:Remove()
                end
            end
		end,

		onexit = function(inst)
			if inst.sg.statemem.dest ~= nil then
				inst.Transform:SetPosition(inst.sg.statemem.dest:Get())
				inst:Show()
			else
				inst:Remove()
			end
		end
    },

    State{
        name = "attack",
        tags = { "busy", "noattack", "attack", "jumping" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("attack")

			inst.components.locomotor:Stop()
			if inst.components.combat.target ~= nil then
				inst:ForceFacePoint(inst.components.combat.target.Transform:GetWorldPosition())
			end
	        inst.components.combat:StartAttack()
		end,

        timeline=
        {
            TimeEvent(15*FRAMES, function(inst)
					inst.Physics:SetMotorVelOverride(20, 0, 0)
					inst.sg.statemem.enable_attack = true
				end ),
            TimeEvent(25*FRAMES, function(inst)
					inst.Physics:ClearMotorVelOverride()
					inst.components.locomotor:Stop()
					inst.sg.statemem.enable_attack = false
					inst.components.combat:DropTarget()
				end ),
        },

        onupdate = function(inst)
			if inst.sg.statemem.enable_attack then
				local target = FindBestAttackTarget(inst)
				if target ~= nil then
					DoSpecialAttack(inst, target)
					inst.sg.statemem.attack_landed = true
					inst.components.combat:DropTarget()
					inst.sg:GoToState("mutate_pre")
                end
			end
        end,

        events =
        {
            EventHandler("animover", function(inst)
				if math.random() < .2 and not inst.sg.statemem.attack_landed then
                    inst.needremove=true
                    inst.sg:GoToState("mutate_pre")
                else
                    inst.sg:GoToState("idle")
                end
			end),
        },

        onexit = function(inst)
			inst.Physics:ClearMotorVelOverride()
			inst.components.locomotor:Stop()
			if not inst.sg.statemem.attack_landed then
				inst.components.combat:DropTarget()
			end
		end,
    },

    State{
        name = "mutate_pre",
        tags = {"busy", "noattack", "jumping"},

        onenter = function(inst, speed)
			inst.Physics:SetMotorVelOverride(speed or 2, 0, 0)
            inst.AnimState:PlayAnimation("mutate")
			inst.persists = false
        end,

        timeline=
        {
            --TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/rabbit/hop") end ),
        },

        events =
        {
            EventHandler("animover", function(inst)
				inst:Remove()
			end),
        },

    },
}

local function SpawnTrail(inst)
	if not inst._notrail then
		local trail = SpawnPrefab("medal_gestalt_trail")
		trail.Transform:SetPosition(inst.Transform:GetWorldPosition())
		trail.Transform:SetRotation(inst.Transform:GetRotation())
	end
end

CommonStates.AddWalkStates(states,
{
    starttimeline =
    {
    },
    walktimeline =
    {
        TimeEvent(0*FRAMES, SpawnTrail),
        --TimeEvent(5*FRAMES, SpawnTrail),
    },
    endtimeline =
    {
    },
}
, nil, nil, true)


return StateGraph("SGmedal_gestalt", states, events, "idle", actionhandlers)
