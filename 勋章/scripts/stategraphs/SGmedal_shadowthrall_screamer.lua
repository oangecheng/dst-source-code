require("stategraphs/commonstates")

local MAXTARGET = 6--最大目标数量
local FOCUSTARGET_MUST_TAGS = { "_combat", "_health" }
local FOCUSTARGET_CANT_TAGS = { "INLIMBO", "player", "notarget" }
--获取附近玩家列表
local function GetTargets(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local attack_range = inst.components.combat and inst.components.combat.attackrange or TUNING_MEDAL.MEDAL_SHADOWTHRALL_SCREAMER_ATTACK_RANGE[1]
	return FindPlayersInRange(x, y, z, attack_range, true)
end

--攻击多个目标(inst,目标,回调,嗜血箭?)
local function attackMultiTargets(inst,target,fn,blood)
	--射周围玩家
	local count = 1--攻击目标数量统计
	local players = GetTargets(inst)
	for i, v in pairs(players) do
		if v ~= target then
			fn(inst,v,blood)
			count = count + 1
		end
		if count >= MAXTARGET then 
			return
		end
	end
	--玩家数量不够，其他仇恨生物来凑
	local x, y, z = inst.Transform:GetWorldPosition()
	local attack_range = inst.components.combat and inst.components.combat.attackrange or TUNING_MEDAL.MEDAL_SHADOWTHRALL_SCREAMER_ATTACK_RANGE[1]
	for i, v in ipairs(TheSim:FindEntities(x, y, z, attack_range, FOCUSTARGET_MUST_TAGS, FOCUSTARGET_CANT_TAGS)) do
		if v ~= target and v:IsValid() and v.components.combat.target == inst and not v.components.health:IsDead()  then
			fn(inst,v,blood)
			count = count + 1
		end
		if count >= MAXTARGET then 
			return
		end
	end
end

--选择攻击技能
local function ChooseAttackSkill(inst)
	--技能类型：1瘴气孢子、2虚空箭、3血色飓风、4嗜血三连箭、5嗜血箭
	inst.skill_count = inst.skill_count or 1
	--一阶段：瘴气孢子
	if inst.PhaseLevel == 1 then
		return 1
	--二阶段：虚空箭*3+瘴气孢子*1
	elseif inst.PhaseLevel == 2 then
		return inst.skill_count % 4 == 0 and 1 or 2
	--三阶段：瘴气孢子*1+虚空箭*3+血色飓风*1+虚空箭*2
	--改版后：瘴气孢子*1+虚空箭*3+血色飓风*1+嗜血箭*2
	elseif inst.PhaseLevel == 3 then
		local remainder = inst.skill_count % 7
		return remainder == 1 and 1 or remainder==5 and 3 or (remainder==6 or remainder==0) and 5 or 2
	--四阶段：瘴气孢子*1+虚空箭*2+虚空三连箭*1+血色飓风*1+虚空三连箭*1
	--改版后：瘴气孢子*1+虚空箭*2+嗜血三连箭*1+血色飓风*1+嗜血三连箭*1+虚空箭*1+嗜血箭*1
	else
		local remainder = inst.skill_count % 8
		return remainder==1 and 1 or remainder==5 and 3 or (remainder==4 or remainder==6) and 4 or remainder==7 and 5 or 2
	end
end

local function ChooseAttack(inst, data)
	if data ~= nil and data.target ~= nil and data.target:IsValid() then
		-- inst.sg:GoToState("cast", data.target)
		inst.skillid = ChooseAttackSkill(inst)
		inst.sg:GoToState(inst.skillid%2 == 0 and "cast" or "castfaster", data.target)--虚空箭有前摇
		return true
	end
	return false
end

local events =
{
	EventHandler("doattack", function(inst, data)
		if not inst.sg:HasStateTag("busy") then
			ChooseAttack(inst, data)
		end
	end),
	CommonHandlers.OnLocomote(false, true),
	CommonHandlers.OnAttacked(),
	CommonHandlers.OnDeath(),
}

local function SetShadowScale(inst, scale)
	inst.DynamicShadow:SetSize(1.7 * scale, .9 * scale)
end

local function SetSpawnShadowScale(inst, scale)
	inst.DynamicShadow:SetSize(1.5 * scale, scale)
end

--生成孢子
local function SpawnSpore(inst,targets,sfx,pos,target)
	local x, y, z = inst.Transform:GetWorldPosition()
	local proj = SpawnPrefab("medal_shadowthrall_projectile_fx")
	proj.Physics:Teleport(x, y, z)
	proj.targets = targets
	proj.sfx = sfx
	proj.spawn_miasma = inst.PhaseLevel == 1 or target ~= nil--生成瘴气(1阶段必然有瘴气，否则只有有打击目标的时候有瘴气)
	proj.shooter = inst--绑定射击者
	proj.components.complexprojectile:Launch(pos, inst)
	--生成绝望螨
	if inst.PhaseLevel >=2 then
		proj.parasitic_target = target--设定寄生目标
		proj.divisionable = inst.PhaseLevel == 4--可分裂
		proj.bomb_speed = inst.components.locomotor and inst.components.locomotor.walkspeed - 1--移速
	end
end

--发射瘴气孢子(inst)
local function LaunchMiasmaSpores(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local pos = inst.sg.statemem.targetpos
	local target = inst.sg.statemem.target
	inst.sg.statemem.target = nil
	if target ~= nil and target:IsValid() then
		pos.x, pos.y, pos.z = target.Transform:GetWorldPosition()
	end
	local dir
	if pos ~= nil then
		inst:ForceFacePoint(pos)
		dir = inst.Transform:GetRotation() * DEGREES
	else
		dir = inst.Transform:GetRotation() * DEGREES
		pos = Vector3(x + 8 * math.cos(dir), 0, z - 8 * math.sin(dir))
	end

	local targets = {} --共享目标，防止对同一目标造成多次伤害
	local sfx = {} --只播一次sfx

	SpawnSpore(inst,targets,sfx,pos,target)

	dir = dir + PI
	local pos1 = Vector3(0, 0, 0)
	for i = 0, 4 do
		local theta = dir + TWOPI / 5 * i
		local offset = 5
		pos1.x = pos.x + offset * math.cos(theta)
		pos1.z = pos.z - offset * math.sin(theta)
		SpawnSpore(inst,targets,sfx,pos1)
	end
	--对周围玩家释放孢子
	local players = GetTargets(inst)
	for i, v in pairs(players) do
		if v ~= target and v ~= nil and v:IsValid() then
			local pos2 = v:GetPosition()
			SpawnSpore(inst,targets,sfx,pos2,v)
		end
	end
end

--虚空箭(inst,目标,是否是嗜血箭,重复次数)
local function shooting(inst,target,blood,times)
	if inst ~= nil and inst:IsValid() and target ~= nil and target:IsValid() then
		local x, y, z = inst.Transform:GetWorldPosition()
		local offset_y = 0
		if not target:IsNear(inst, 4) then
			offset_y = 1.2--只要站得高，就没有越不过的界
		end
		local proj = SpawnPrefab(blood and "medal_shadowthrall_arrow_blood" or "medal_shadowthrall_arrow")
		proj.Physics:Teleport(x, y + offset_y, z)
		proj.components.projectile:Throw(inst, target, inst)
		times = (times or 1) - 1
		if times > 0 then
			inst:DoTaskInTime(.2,function(inst)
				shooting(inst,target,true,times)
			end)
		end
	end
end

--生成血色飓风
local function spawnTornado(inst, target)
    local x1, y1, z1 = inst.Transform:GetWorldPosition()
    local x2, y2, z2 = target.Transform:GetWorldPosition()
	local tornado = SpawnPrefab("medal_red_tornado")
    tornado.WINDSTAFF_CASTER = inst
    tornado.Transform:SetPosition(x1 + .15 * (x2 - x1), 0, z1 + .15 * (z2 - z1))
	tornado.mytarget = target
    tornado.components.knownlocations:RememberLocation("target", target:GetPosition())
end

local skill_loot={--技能列表
	[1]=function(inst)--瘴气孢子
		LaunchMiasmaSpores(inst)
	end,
	[2]=function(inst)--虚空箭
		local target = inst.sg.statemem.target
		inst.sg.statemem.target = nil
		shooting(inst,target)
		--对其他同伙进行打击
		attackMultiTargets(inst,target,shooting)
	end,
	[3]=function(inst)--血色飓风
		local target = inst.sg.statemem.target
		inst.sg.statemem.target = nil
		spawnTornado(inst,target)
		--对其他同伙进行打击
		attackMultiTargets(inst,target,spawnTornado)
	end,
	[4]=function(inst)--嗜血三连箭
		local target = inst.sg.statemem.target
		inst.sg.statemem.target = nil
		shooting(inst,target,true,3)
		--对其他同伙进行打击
		attackMultiTargets(inst,target,shooting,true)
	end,
	[5]=function(inst)--嗜血箭
		local target = inst.sg.statemem.target
		inst.sg.statemem.target = nil
		shooting(inst,target,true)
		--对其他同伙进行打击
		attackMultiTargets(inst,target,shooting,true)
	end,
}

local states =
{
	State{
		name = "idle",
		tags = { "idle", "canrotate" },

		onenter = function(inst)
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("idle", true)
		end,
	},

	State{
		name = "spawndelay",
		tags = { "busy", "noattack", "temp_invincible", "invisible" },

		onenter = function(inst, delay)
			inst.components.locomotor:Stop()
			inst.DynamicShadow:Enable(false)
			inst.Physics:SetActive(false)
			inst:Hide()
			inst:AddTag("NOCLICK")
			inst.sg:SetTimeout(delay or 0)
		end,

		ontimeout = function(inst)
			inst.sg.statemem.spawning = true
			inst.sg:GoToState("spawn")
		end,

		onexit = function(inst)
			if not inst.sg.statemem.spawning then
				inst.DynamicShadow:Enable(true)
			end
			inst.Physics:SetActive(true)
			inst:Show()
			inst:RemoveTag("NOCLICK")
		end,
	},

	State{
		name = "spawn",
		tags = { "appearing", "busy", "noattack", "temp_invincible" },

		onenter = function(inst)
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("appear")
			inst.SoundEmitter:PlaySound("rifts2/thrall_generic/appear_cloth")
			inst.DynamicShadow:Enable(false)
			ToggleOffCharacterCollisions(inst)
		end,

		timeline =
		{
			FrameEvent(7, function(inst)
				SetSpawnShadowScale(inst, .25)
				inst.DynamicShadow:Enable(true)
			end),
			FrameEvent(8, function(inst) SetSpawnShadowScale(inst, .5) end),
			FrameEvent(9, function(inst) SetSpawnShadowScale(inst, .75) end),
			FrameEvent(10, function(inst) SetSpawnShadowScale(inst, 1) end),
			FrameEvent(40, function(inst)
				SetSpawnShadowScale(inst, .93)
				inst.SoundEmitter:PlaySound("rifts2/thrall_wings/appear")
			end),
			FrameEvent(42, function(inst) SetSpawnShadowScale(inst, .9) end),
			FrameEvent(44, function(inst) SetShadowScale(inst, .93) end),
			FrameEvent(45, function(inst)
				inst.sg:RemoveStateTag("temp_invincible")
				inst.sg:RemoveStateTag("noattack")
				inst.sg:RemoveStateTag("appearing")
				SetShadowScale(inst, 1)
				ToggleOnCharacterCollisions(inst)
				local x,y,z = inst.Transform:GetWorldPosition()
				SpawnPrefab("medal_shadowthrall_screamer_spawn_fx").Transform:SetPosition(x,y+3,z)
			end),
			FrameEvent(48, function(inst)
				inst.sg:AddStateTag("caninterrupt")
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

		onexit = function(inst)
			if inst.sg:HasStateTag("noattack") then
				SetShadowScale(inst, 1)
				inst.DynamicShadow:Enable(true)
				ToggleOnCharacterCollisions(inst)
			end
		end,
	},

	State{
		name = "death",
		tags = { "busy" },

		onenter = function(inst)
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("death")
			inst.SoundEmitter:PlaySound("rifts2/thrall_generic/vocalization_death")
			inst.SoundEmitter:PlaySound("rifts2/thrall_generic/death_cloth")
		end,

		timeline =
		{
			FrameEvent(13, function(inst)
				RemovePhysicsColliders(inst)
				SetSpawnShadowScale(inst, 1)
			end),
			FrameEvent(25, function(inst) inst.SoundEmitter:PlaySound("rifts2/thrall_generic/death_pop") end),
			FrameEvent(30, function(inst) SetSpawnShadowScale(inst, .5) end),
			FrameEvent(31, function(inst) inst.DynamicShadow:Enable(false) end),
			FrameEvent(32, function(inst)
				local pos = inst:GetPosition()
				pos.y = 3
				inst.components.lootdropper:DropLoot(pos)
				--生成雕像皮肤券
				local skin_coupon = SpawnPrefab("medal_skin_coupon")
				if skin_coupon then
					if skin_coupon.setSkinData then
						skin_coupon:setSkinData("medal_statue_marble_changeable",7)
					end
					inst.components.lootdropper:FlingItem(skin_coupon)
				end
				--统计死亡次数
				if TheWorld and TheWorld.components.medal_infosave then
					TheWorld.components.medal_infosave:CountChaosCreatureDeathTimes(inst)
				end
				inst:AddTag("NOCLICK")
				inst.persists = false
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
	},

	State{
		name = "exit",--跑路了
		tags = { "busy" },

		onenter = function(inst)
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("death")
			inst.SoundEmitter:PlaySound("rifts2/thrall_generic/vocalization_death")
			inst.SoundEmitter:PlaySound("rifts2/thrall_generic/death_cloth")
		end,

		timeline =
		{
			FrameEvent(13, function(inst)
				RemovePhysicsColliders(inst)
				SetSpawnShadowScale(inst, 1)
			end),
			FrameEvent(25, function(inst) inst.SoundEmitter:PlaySound("rifts2/thrall_generic/death_pop") end),
			FrameEvent(30, function(inst) SetSpawnShadowScale(inst, .5) end),
			FrameEvent(31, function(inst) inst.DynamicShadow:Enable(false) end),
			FrameEvent(32, function(inst)
				inst:AddTag("NOCLICK")
				inst.persists = false
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
	},

	State{
		name = "hit",
		tags = { "hit", "busy" },

		onenter = function(inst)
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("hit")
			inst.SoundEmitter:PlaySound("rifts2/thrall_generic/vocalization_hit")
		end,

		timeline =
		{
			FrameEvent(11, function(inst)
				if inst.sg.statemem.doattack == nil then
					inst.sg:AddStateTag("caninterrupt")
				end
			end),
			FrameEvent(12, function(inst)
				if inst.sg.statemem.doattack ~= nil then
					if ChooseAttack(inst, inst.sg.statemem.doattack) then
						return
					end
					inst.sg.statemem.doattack = nil
				end
				inst.sg:RemoveStateTag("busy")
			end),
		},

		events =
		{
			EventHandler("doattack", function(inst, data)
				if inst.sg:HasStateTag("busy") then
					inst.sg.statemem.doattack = data
					inst.sg:RemoveStateTag("caninterrupt")
					return true
				end
			end),
			EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
			end),
		},
	},

	State{
		name = "cast",
		tags = { "attack", "busy" },

		onenter = function(inst, target)
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("cast")
			inst.SoundEmitter:PlaySound("rifts2/thrall_wings/cast_f0")
			inst.SoundEmitter:PlaySound("rifts2/thrall_generic/vocalization_big")
			if target ~= nil and target:IsValid() then
				inst.sg.statemem.target = target
				inst.sg.statemem.targetpos = target:GetPosition()
				inst:ForceFacePoint(inst.sg.statemem.targetpos)
			end
		end,

		onupdate = function(inst)
			if inst.sg.statemem.target ~= nil then
				if inst.sg.statemem.target:IsValid() then
					local pos = inst.sg.statemem.targetpos
					pos.x, pos.y, pos.z = inst.sg.statemem.target.Transform:GetWorldPosition()
				else
					inst.sg.statemem.target = nil
				end
			end
			inst:ForceFacePoint(inst.sg.statemem.targetpos)
		end,

		timeline =
		{
			FrameEvent(23, function(inst)
				inst.SoundEmitter:PlaySound("rifts2/thrall_wings/cast_f25")
				inst.components.combat:StartAttack()
				local skill_type = inst.skillid or ChooseAttackSkill(inst)
				inst.skill_count = inst.skill_count + 1
				skill_loot[skill_type](inst)
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

	State{--快速施法
		name = "castfaster",
		tags = { "attack", "busy" },

		onenter = function(inst, target)
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("cast")
			inst.AnimState:SetTime(0.7)
			-- inst.SoundEmitter:PlaySound("rifts2/thrall_wings/cast_f0")
			-- inst.SoundEmitter:PlaySound("rifts2/thrall_generic/vocalization_big")
			if target ~= nil and target:IsValid() then
				inst.sg.statemem.target = target
				inst.sg.statemem.targetpos = target:GetPosition()
				inst:ForceFacePoint(inst.sg.statemem.targetpos)
			end
		end,

		onupdate = function(inst)
			if inst.sg.statemem.target ~= nil then
				if inst.sg.statemem.target:IsValid() then
					local pos = inst.sg.statemem.targetpos
					pos.x, pos.y, pos.z = inst.sg.statemem.target.Transform:GetWorldPosition()
				else
					inst.sg.statemem.target = nil
				end
			end
			inst:ForceFacePoint(inst.sg.statemem.targetpos)
		end,

		timeline =
		{
			FrameEvent(1, function(inst)
				inst.SoundEmitter:PlaySound("rifts2/thrall_wings/cast_f25")
				inst.components.combat:StartAttack()
				local skill_type = inst.skillid or ChooseAttackSkill(inst)
				inst.skill_count = inst.skill_count + 1
				skill_loot[skill_type](inst)
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
}

CommonStates.AddWalkStates(states,
nil, --timeline
nil, nil, nil,
{
	walkonenter = function(inst)
		local t = GetTime()
		if t > (inst.sg.mem.nextwalkvocal or 0) then
			inst.SoundEmitter:PlaySound("rifts2/thrall_generic/vocalization_small")
			inst.sg.mem.nextwalkvocal = t + .5 + math.random()
		end
		inst.SoundEmitter:PlaySound("rifts2/thrall_wings/flap_walk")
		inst.sg.mem.lastflap = t
	end,
	endonenter = function(inst)
		if (inst.sg.mem.lastflap or 0) + 0.5 < GetTime() then
			inst.SoundEmitter:PlaySound("rifts2/thrall_wings/flap_walk", nil, .5)
		end
	end,
})

return StateGraph("SGmedal_shadowthrall_screamer", states, events, "idle")
