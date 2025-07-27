local assets =
{
	Asset("ANIM", "anim/shadow_thrall_wings.zip"),
	Asset("ANIM", "anim/medal_shadowthrall_screamer.zip"),
}

local prefabs =
{
	"shadowthrall_projectile_fx",
	"dreadstone",
	"horrorfuel",
	"nightmarefuel",
	"medal_shadow_magic_stone",
}

local brain = require("brains/medal_shadowthrall_screamerbrain")

SetSharedLootTable("medal_shadowthrall_screamer",
{
	{ "dreadstone",		1.00 },
	{ "dreadstone",		1.00 },
	{ "dreadstone",		0.67 },
	{ "horrorfuel",		1.00 },
	{ "horrorfuel",		1.00 },
	{ "horrorfuel",		0.33 },
	{ "nightmarefuel",	1.00 },
	{ "nightmarefuel",	0.67 },
	{ "fossil_piece",	1.00 },
	{ "fossil_piece",	1.00 },
	{ "fossil_piece",	1.00 },
	{ "fossil_piece",	1.00 },
	{ "medal_shadow_magic_stone",	1.00 },
})

local function RetargetFn(inst)
	if inst.sg:HasStateTag("appearing") or inst.sg:HasStateTag("invisible") then
		return
	end

	local x, y, z = inst.Transform:GetWorldPosition()
	local target = inst.components.combat.target
	if target ~= nil then
		local attack_range = inst.components.combat.attackrange or TUNING_MEDAL.MEDAL_SHADOWTHRALL_SCREAMER_ATTACK_RANGE[1]
		local range = attack_range + target:GetPhysicsRadius(0)
		if target:HasTag("player") and target:GetDistanceSqToPoint(x, y, z) < range * range then
			--Keep target
			return
		end
	end
	--这边特意给player赋值是防止返回第二个参数
	local player = FindClosestPlayerInRange(x, y, z, TUNING.SHADOWTHRALL_AGGRO_RANGE, true)
	return player
end

local function KeepTargetFn(inst, target)
	if not inst.components.combat:CanTarget(target) then
		return false
	end
	local x, y, z = inst.Transform:GetWorldPosition()
	local rangesq = TUNING.SHADOWTHRALL_DEAGGRO_RANGE * TUNING.SHADOWTHRALL_DEAGGRO_RANGE
	if target:GetDistanceSqToPoint(x, y, z) < rangesq then
		return true
	end
	return false
end

local function OnAttacked(inst, data)
	if data.attacker ~= nil then
		local target = inst.components.combat.target
		local attack_range = inst.components.combat.attackrange or TUNING_MEDAL.MEDAL_SHADOWTHRALL_SCREAMER_ATTACK_RANGE[1]
		if inst.components.combat:CanAttack(data.attacker) and
			not (target ~= nil and
				target:HasTag("player") and
				inst:IsNear(target, attack_range + target:GetPhysicsRadius(0))) then
			inst.components.combat:SetTarget(data.attacker)
		end
		if not inst.components.combat:HasTarget() then
			--没目标就找个附近的玩家当目标
			local player = FindClosestPlayerToInst(inst,attack_range*2.5,true)
			if player ~= nil then
				inst.components.combat:SetTarget(player)
			--玩家都没有？那我不玩了
			elseif inst.sg and not (inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("attack")) then
				inst.sg:GoToState("exit")
			end
		end
	end
end

--攻击目标后
local function OnHitOther(inst,data)
	--如果在第三阶段用嗜血箭射中了目标，则吸血
	if data and data.damage and data.damage>0 and data.weapon and data.weapon.prefab == "medal_shadowthrall_arrow_blood" then
        if inst ~= nil and inst ~= data.target and inst:IsValid() and inst.PhaseLevel>=3 then
			local x, y, z = inst.Transform:GetWorldPosition()
			local proj = SpawnPrefab("medal_shadowthrall_arrow_blood")--反射治疗箭
			local offset = 1
			--有黑暗血糖
			if data.target and data.target.medal_dark_ningxue then
				--抵消buff时长
				ConsumeMedalBuff(data.target,"buff_medal_suckingblood",TUNING_MEDAL.MEDAL_BUFF_SUCKINGBLOOD_ARROW_CONSUME)
				offset = 0.5--黑暗血糖吸血减半
			end
			proj.treatment_value = math.ceil((data.damage + 5)*1.5^inst.PhaseLevel)*offset--回血量=math.ceil((造成的伤害+5)*1.5^阶段数)
			-- print(data.damage,proj.treatment_value)
			proj.Physics:Teleport(x, y, z)
			proj.components.projectile:Throw(inst, inst, inst)
		end
    end
end

--------------------------------------------------------------------------

local PHASE2_HEALTH = .85--第二阶段血量比例
local PHASE3_HEALTH = .5--第三阶段血量比例
local PHASE4_HEALTH = .25--第四阶段血量比例
--设置不同阶段参数(inst,阶段,是否为刚加载)
local function SetPhaseLevel(inst, phase, starting)
	if not starting then--刚加载的时候不需要做这些处理
		if phase > inst.PhaseLevel then--播放升阶特效
			local x,y,z = inst.Transform:GetWorldPosition()
			SpawnPrefab("medal_shadowthrall_screamer_spawn_fx").Transform:SetPosition(x,y+3,z)
		else--阶段只增不减
			return 
		end
	end

	inst.PhaseLevel = phase
	local scale = TUNING_MEDAL.MEDAL_SHADOWTHRALL_SCREAMER_SCALE[phase]--放大比例
	inst.AnimState:SetScale(scale, scale)
	inst.components.locomotor.walkspeed = TUNING_MEDAL.MEDAL_SHADOWTHRALL_SCREAMER_WALKSPEED[phase]--移速
	inst.components.combat:SetAttackPeriod(TUNING_MEDAL.MEDAL_SHADOWTHRALL_SCREAMER_ATTACK_PERIOD[phase])--攻击频率
	inst.components.combat:SetRange(TUNING_MEDAL.MEDAL_SHADOWTHRALL_SCREAMER_ATTACK_RANGE[phase])--攻击范围
	inst.skill_count = 1--清空技能计数
end
--第二阶段
local function EnterPhase2Trigger(inst)
    SetPhaseLevel(inst, 2)
end
--第三阶段
local function EnterPhase3Trigger(inst)
    SetPhaseLevel(inst, 3)
end
--第四阶段
local function EnterPhase4Trigger(inst)
    SetPhaseLevel(inst, 4)
end

--统计瘴气数量
local function CountMiasma(inst)
	inst.miasma = inst.miasma and inst.miasma +1 or 1
	if inst.miasma >= 50 and inst.PhaseLevel < 2 then
		SetPhaseLevel(inst, 2)--生成的瘴气数量达到50个直接升阶，免得长时间停留在1阶段生成过多瘴气
	end
end

--后加载
local function OnLoadPostPass(inst)
	local healthpct = inst.components.health:GetPercent()--获取血量百分比
    --设置阶段参数
	SetPhaseLevel(
        inst,
        math.max(inst.PhaseLevel,(healthpct > PHASE2_HEALTH and 1) or
        (healthpct > PHASE3_HEALTH and 2) or
        (healthpct > PHASE4_HEALTH and 3) or
        4),
		true
    )
end

--存储函数
local function OnSave(inst, data)
	data.PhaseLevel=inst.PhaseLevel--阶段
end
--加载
local function OnLoad(inst, data)
    if data ~= nil then
		--读取阶段
		inst.PhaseLevel=data.PhaseLevel or 1
	end
end

--预置物休眠函数
local function OnEntitySleep(inst)
    if inst._sleeptask ~= nil then
        inst._sleeptask:Cancel()
    end
	--如果进入休眠状态时没死亡的话，10秒后移除
    inst._sleeptask = not inst.components.health:IsDead() and inst:DoTaskInTime(10, inst.Remove) or nil
end
--预置物唤醒函数
local function OnEntityWake(inst)
    if inst._sleeptask ~= nil then
        inst._sleeptask:Cancel()
        inst._sleeptask = nil
    end
end
--------------------------------------------------------------------------

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()

	inst:SetPhysicsRadiusOverride(.5)
	MakeGhostPhysics(inst, 25, inst.physicsradiusoverride)
	inst.DynamicShadow:SetSize(1.7, .9)
	inst.Transform:SetFourFaced()

	inst:AddTag("monster")
	inst:AddTag("hostile")
	inst:AddTag("scarytoprey")
	inst:AddTag("flying")
	inst:AddTag("epic")--史诗级生物
	-- inst:AddTag("shadowthrall")
	-- inst:AddTag("shadow_aligned")
	inst:AddTag("chaos_creature")--混沌生物

	inst.AnimState:SetBank("shadow_thrall_wings")
	inst.AnimState:SetBuild("medal_shadowthrall_screamer")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetSymbolLightOverride("fx_red", 1)
	inst.AnimState:SetSymbolLightOverride("fx_red_particle", 1)
	inst.AnimState:SetSymbolLightOverride("wingend_red", 1)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.PhaseLevel = 1--阶段等级

	inst:AddComponent("inspectable")

	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED

	inst:AddComponent("locomotor")
	inst.components.locomotor:EnableGroundSpeedMultiplier(false)
	inst.components.locomotor:SetTriggersCreep(false)
	inst.components.locomotor.walkspeed = TUNING_MEDAL.MEDAL_SHADOWTHRALL_SCREAMER_WALKSPEED[1]

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING_MEDAL.MEDAL_SHADOWTHRALL_SCREAMER_HEALTH)
	inst.components.health.nofadeout = true

	inst:AddComponent("healthtrigger")--生命触发器,不同比例血的时候触发，设定不同阶段属性
    inst.components.healthtrigger:AddTrigger(PHASE2_HEALTH, EnterPhase2Trigger)--85%
    inst.components.healthtrigger:AddTrigger(PHASE3_HEALTH, EnterPhase3Trigger)--50%
    inst.components.healthtrigger:AddTrigger(PHASE4_HEALTH, EnterPhase4Trigger)--25%

	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(TUNING_MEDAL.MEDAL_SHADOWTHRALL_SCREAMER_DAMAGE)
	inst.components.combat:SetAttackPeriod(TUNING_MEDAL.MEDAL_SHADOWTHRALL_SCREAMER_ATTACK_PERIOD[1])--攻击频率
	inst.components.combat:SetRange(TUNING_MEDAL.MEDAL_SHADOWTHRALL_SCREAMER_ATTACK_RANGE[1])--攻击范围
	inst.components.combat:SetRetargetFunction(3, RetargetFn)
	inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
	inst.components.combat.forcefacing = false
	inst.components.combat.hiteffectsymbol = "shad"
	inst:ListenForEvent("attacked", OnAttacked)
	-- inst:ListenForEvent("newcombattarget", OnNewCombatTarget)
	inst:ListenForEvent("onhitother", OnHitOther)--攻击目标后(可以拿到伤害)

	SetPhaseLevel(inst, 1, true)--基础参数初始化

	inst:AddComponent("planarentity")--实体抵抗
	inst:AddComponent("medal_chaosdamage")--混沌伤害
	inst.components.medal_chaosdamage:SetBaseDamage(TUNING_MEDAL.MEDAL_SHADOWTHRALL_SCREAMER_CHAOS_DAMAGE)

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable("medal_shadowthrall_screamer")
	inst.components.lootdropper.y_speed = 4
	inst.components.lootdropper.y_speed_variance = 3
	inst.components.lootdropper.spawn_loot_inside_prefab = true

	inst:AddComponent("colouradder")
	inst:AddComponent("knownlocations")

	inst:SetStateGraph("SGmedal_shadowthrall_screamer")
	inst:SetBrain(brain)
	
	inst.CountMiasma = CountMiasma
	inst.OnSave = OnSave
    inst.OnLoad = OnLoad
	inst.OnLoadPostPass = OnLoadPostPass
    inst.OnEntitySleep = OnEntitySleep--预置物休眠
    inst.OnEntityWake = OnEntityWake--预置物唤醒

	return inst
end

return Prefab("medal_shadowthrall_screamer", fn, assets, prefabs)
