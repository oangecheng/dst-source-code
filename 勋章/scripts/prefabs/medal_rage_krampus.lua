local devour_soul_medal_fn = require("prefabs/devour_soul_medal_fn")
local assets =
{
    Asset("ANIM", "anim/krampus_basic.zip"),
    -- Asset("ANIM", "anim/krampus_build.zip"),
    Asset("ANIM", "anim/medal_rage_krampus.zip"),
    Asset("SOUND", "sound/krampus.fsb"),
}

local prefabs =
{
    "rage_krampus_soul",
    -- "krampus_sack",
    -- "klaus_sack",
    "nightmarefuel",
    "unsolved_book",
    "monstermeat",
}

local brain = require "brains/medalragekrampusbrain"

SetSharedLootTable( 'medal_rage_krampus',
{
    -- {'klaus_sack', 0.5},
    {'nightmarefuel', 1},
    {'nightmarefuel', 1},
    {'nightmarefuel', 1},
    {'nightmarefuel', 1},
    {'nightmarefuel', 1},
    {'nightmarefuel', 1},
    {'unsolved_book', 1},
    {'monstermeat', 1},
    {'monstermeat', 1},
	{'rage_krampus_soul', 1},
    {'krampus_sack', .02},
})
--设定新目标
local function NotifyBrainOfTarget(inst, target)
    if inst.brain and inst.brain.SetTarget then
        inst.brain:SetTarget(target)
    end
end
--背包满(目前好像没用到)
local function makebagfull(inst)
    inst.AnimState:Show("SACK")
    inst.AnimState:Hide("ARM")
end
--背包空(目前好像没用到)
local function makebagempty(inst)
    inst.AnimState:Hide("SACK")
    inst.AnimState:Show("ARM")
end
--被攻击时
local function OnAttacked(inst, data)
	if data.attacker ~=nil then
        inst.components.combat:SetTarget(data.attacker)--将攻击者设为目标
		local x,y,z=data.attacker.Transform:GetWorldPosition()
        local tile = TheWorld.Map:GetTileAtPoint(x, y, z)
        --在奇怪的地形上攻击，直接跑路
		if tile and (tile == GROUND.IMPASSABLE or tile == GROUND.INVALID) then
            if inst.sg then
				inst.sg:GoToState("exit")--我他妈直接跑路.jpg
			end
		--来自非玩家的攻击(不能被攻击的除外)，计数，准备灵魂吞噬
		elseif not (data.attacker:HasTag("player") or data.attacker:HasTag("notarget"))then
			inst.non_player_count = (inst.non_player_count or 0) + 1
			if inst.non_player_count >= 8 then
				if inst.sg and not inst.sg:HasStateTag("busy") then
					inst.sg:GoToState("devour")--我他妈直接吞噬
					inst.non_player_count = 0--清空计数
				end
			end
		end
	end
end

--远程减伤
local function HealthPreDelta(target, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
	local distance=math.sqrt(target:GetDistanceSqToInst(afflicter))--计算距离
	if distance>2.5 then--生成暗影盾
		local fx=SpawnPrefab("medal_shield")
		if fx then
			fx.entity:SetParent(target.entity)
		end
	end
	--减伤=min(arctan(max(攻击距离-2.2,0)/4),0.9)
	return amount*(1-math.min(math.atan(math.max(distance-2.2,0)/4),0.9))
end

--新的攻击目标
local function OnNewCombatTarget(inst, data)
    NotifyBrainOfTarget(inst, data.target)
end

--生成万物之灵
local function spawnSoul(inst,num)
	devour_soul_medal_fn.SpawnSoulsAt(inst, num or 1, nil, true)--生成万物之灵
end

--特殊效果抵抗(inst,效果类型)
local function ResistEffect(inst,type)
	--有黑暗血糖
	if inst and inst.medal_dark_ningxue then
		--抵消buff时长
		ConsumeMedalBuff(inst,"buff_medal_suckingblood",TUNING_MEDAL.MEDAL_BUFF_SUCKINGBLOOD_EFFECT_CONSUME[type or 1])
		return true
	end
	return false
end

local STEAL_CANT_TAGS = { "INLIMBO", "catchable", "fire", "irreplaceable", "heavy", "prey", "bird", "outofreach", "_container" }
--踢掉东西的时候给它偷走
local function OnStolen(inst,victim,item)
	if item and not (inst.components.inventory:IsFull() or item:HasOneOfTags(STEAL_CANT_TAGS)) then
		local act=BufferedAction(inst, item, ACTIONS.PICKUP)
		inst:PushBufferedAction(act)
	end
end

--攻击效果
local effect_fn_list={}
--顺手牵羊
effect_fn_list.steal = function(inst, other)
	if ResistEffect(other,1) then return end
	inst.components.thief:StealItem(other)
end
--缴械
effect_fn_list.drop = function(inst, other, devour)
	if other ~= nil and other.components.inventory ~= nil then
		if ResistEffect(other,3) then return end
		local item = other.components.inventory:DropOneEquipped()
		--近战的话，不仅踢掉，如果灵魂之力超过10点，还会偷走
		if item and inst.soul_power >= 10 and not devour then
			OnStolen(inst, other, item, true)
			inst.soul_power = inst.soul_power - 10--消耗灵魂之力
		end
	end
end
--击飞
effect_fn_list.knockback = function(inst, other)
	if other.components.health ~= nil and not other.components.health:IsDead() then
		if ResistEffect(other,2) then return end
		other:PushEvent("knockback", {knocker = inst, radius = math.random(3,8)})
		--踹飞你还不爆点装备？
		if inst.PhaseLevel >= 3 and math.random() <.2 then
			effect_fn_list.drop(inst, other)
		--连踢带拿
		elseif inst.PhaseLevel >= 2 then
			effect_fn_list.steal(inst, other)
		end
	end
end

--攻击效果权重
local effect_list={
	{steal=3, knockback=1, drop=1,},--1阶段
	{knockback=4, drop=1,},--2阶段
	{knockback=1,},--3阶段
}
--攻击到目标时执行函数
local function OnHitOther(inst, other, damage)
	if other:HasTag("player") then
		--灵魂之力超过20点，则可踢掉玩家全身物品
		if inst.soul_power >= 20 and other.components.inventory ~= nil then
			if ResistEffect(other,4) then
				inst.soul_power = inst.soul_power - 10--消耗灵魂之力
			else
				other.components.inventory:DropEverything()
				inst.soul_power = inst.soul_power - 20--消耗灵魂之力
			end
		else--否则就根据当前阶段选取技能效果
			local effect_key = weighted_random_choice(effect_list[inst.PhaseLevel])
			if effect_key and effect_fn_list[effect_key] then
				effect_fn_list[effect_key](inst, other)
			end
		end
	--非玩家则掉落万物之灵
	elseif other.components.health and not other.components.health:IsDead() then
		spawnSoul(other)--生成万物之灵
		other.components.health:DoDelta(-50)
	end
end

--黑名单物品
local BLACKLIST={
	fossil_stalker=true,--化石碎片
	endtable=true,--茶几
	table_winters_feast=true,--冬季盛宴桌子
	lureplant=true,--食人花
	homesign=true,--木牌
	arrowsign_post=true,--方向牌
	boat_cannon=true,--大炮
}

local devour_must_tags = {"_combat", "_health", "trap", "structure", "burnt", "explosive", "boatcannon"}--灵魂吞噬需要检查的标签
local devour_no_tags = {"INLIMBO", "NOCLICK", "catchable", "notdevourable", "chaos_creature", "notarget"}--灵魂吞噬需要排除的标签

--是否需要立即进行灵魂吞噬
local function ShouldDevour(inst)
	local black_num = 0--黑名单物品数量
	local x,y,z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 5 ,nil , devour_no_tags, devour_must_tags)
	if #ents>0 then
		for i,v in ipairs(ents) do
			--是火药直接嘲讽
			if v.prefab=="gunpowder" then
				return true
			end
			if v:HasTag("wall")--墙
				or BLACKLIST[v.prefab]--黑名单物品 
				or (v:HasTag("trap") and v.components.inventoryitem and v.components.inventoryitem.nobounce)--未触发过的陷阱 
				or (v:HasTag("tree") and v:HasTag("burnt")) then--烧焦的树
				black_num=black_num+1
				if black_num>=6 then
					return true
				end
			end
		end
	end
	return false
end
--尝试进行灵魂吞噬
local function TryDevour(inst)
	inst.try_devour_count = (inst.try_devour_count or 0) + 1--尝试次数
	if inst.try_devour_count >= 8 then
		if inst.sg and not (inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("attack")) then
			if ShouldDevour(inst) then
				inst.sg:GoToState("devour")
			end
			inst.try_devour_count = 0--清空计数
		end
	end
end

--灵魂吞噬
local function OnDevourSoul(inst)
    if inst.components.timer:TimerExists("devour_cd") then
		inst.components.timer:SetTimeLeft("devour_cd", inst.devour_cd)--吞噬CD
	else
		inst.components.timer:StartTimer("devour_cd", inst.devour_cd)--吞噬CD
	end
	inst.try_devour_count = 0--清空吞噬尝试次数
	local x,y,z = inst.Transform:GetWorldPosition()
	local devour_health=0--吸收血量
	local treatmultiple=0--治疗倍数
	local ents=TheSim:FindEntities(x, y, z, TUNING_MEDAL.MEDAL_RAGE_KRAMPUS_DEVOUR_RADIUS , nil, devour_no_tags, devour_must_tags)
	SpawnMedalFX("medal_reticule_scale_fx",inst,nil,TUNING_MEDAL.MEDAL_RAGE_KRAMPUS_DEVOUR_RADIUS)--生成大范围圈
	SpawnMedalFX("medal_reticule_scale_fx",inst,nil,TUNING_MEDAL.MEDAL_RAGE_KRAMPUS_DEVOUR_SAFE_RADIUS)--生成小范围圈
	if #ents>0 then
		for i,v in ipairs(ents) do
			--玩家
			if v:HasTag("player") then 
				--玩家没死亡，并且需要在小圈外才会被吞噬
				if v.components.health and not v.components.health:IsDead() and not inst:IsNear(v, TUNING_MEDAL.MEDAL_RAGE_KRAMPUS_DEVOUR_SAFE_RADIUS) then
					if inst.soul_power and inst.soul_power >= 5 then
						effect_fn_list.drop(inst,v,true)--缴械
						inst.soul_power = inst.soul_power - 5
					end
					spawnSoul(v)--生成万物之灵
					v.components.health:DoDelta(-50)
				end
			--火药
			elseif v.prefab=="gunpowder" then
				local ash=SpawnPrefab("ash")
				if ash then
					v:Remove()
					ash.Transform:SetPosition(v.Transform:GetWorldPosition())
					if ash.components.disappears then
						ash.components.disappears:Disappear()
					end
				end
			--食人花
			elseif v.prefab=="lureplant" then -- or v.prefab=="tentacle" then
				if v.components.health and not v.components.health:IsDead() then
					local losshealth=v.components.health.currenthealth
					local soulnum=math.ceil(losshealth/50)
					spawnSoul(v,soulnum)
					v.components.health:DoDelta(-losshealth)
					-- devour_health=devour_health+losshealth
				end
			--是陷阱，则破坏陷阱
			elseif v:HasTag("trap") then
				if v.components.inventoryitem and v.components.inventoryitem.nobounce then
					v.components.inventoryitem:OnDropped(true)--陷阱失效
				end
			--是烧焦的树，破坏
			elseif v:HasTag("tree") and v:HasTag("burnt") then
				if v.components.workable then
					v.components.workable:Destroy(inst)
				end
			--大炮
			elseif v.prefab == "boat_cannon" then
				if v.components.workable then
					v.components.workable:Destroy(inst)
				end
			--是建筑或墙
			elseif v:HasTag("structure") or v:HasTag("wall") then
				--有血则吸血
				if v.components.health and not v.components.health:IsDead() then
					if v.components.health.currenthealth<=100 then
						spawnSoul(v,v.components.health.currenthealth>50 and 2 or 1)
						if v.components.workable then
							v.components.workable:Destroy(inst)
						end
					else
						spawnSoul(v,2)
						v.components.health:DoDelta(-100)
					end
				--黑名单物品则破坏
				elseif BLACKLIST[v.prefab] then
					if v.components.workable then
						v.components.workable:Destroy(inst)
					end
				end
			else
				--目标是自己的生物，则吸血
				if v.components.combat and v.components.combat:TargetIs(inst) then
					if v.components.health and not v.components.health:IsDead() then
						spawnSoul(v)--生成万物之灵
						v.components.health:DoDelta(-50)
					end
				end
			end
		end
	end
end



--生成灵魂治疗特效
local function spawnHealFx(inst)
	local fx = SpawnPrefab("wortox_soul_heal_fx")
	fx.AnimState:SetMultColour(0.1, 0.1, 0.1, 0.3)
	-- fx:AddTag("noragekrampus")
	fx.noragekrampus=true
	if inst.components.combat then
		fx.entity:AddFollower():FollowSymbol(inst.GUID, inst.components.combat.hiteffectsymbol, 0, -50, 0)
	end
	fx:Setup(inst)
end

--检查卡位情况,卡位太久了要跑路的
local function CheckIsStuck(inst)
    if inst.sg and not (inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("attack")) then
		if inst._previous_position == nil then
			inst._previous_position = inst:GetPosition()
		end
		local delta = inst:GetPosition() - inst._previous_position
        --当前位置和上一次记录的位置太近，计时增加
        if VecUtil_LengthSq(delta.x, delta.z) <= 0.5*0.5 then
            inst._time_spent_stuck = inst._time_spent_stuck + 0.5
        else--否则清空计时
            inst._time_spent_stuck = 0
        end

        inst._previous_position = inst:GetPosition()
		
		local sgstate = nil
		--卡位超过15秒，跑路
		if inst._time_spent_stuck >= 15 then
			sgstate = "exit"
		--每卡位3秒尝试跳跃一次
		elseif inst._time_spent_stuck > 0 and inst._time_spent_stuck % 3 == 0 then
			sgstate = "devour"
			local target = inst.components.combat and inst.components.combat.target
			if target ~= nil then
				local x,y,z = target.Transform:GetWorldPosition()
				if TheWorld.Map:IsPassableAtPoint(x, 0, z, false, true) then
					sgstate = "jumptotarget"--目标点合适就跳跃
				end
			end
		end

		if sgstate then
			inst.sg:GoToState(sgstate)
		end
    end
end

--生成暗影脚气
local function spawnFootPrint(inst)
	if inst.components.health and inst.components.health:IsDead() then return end
	local x,y,z = inst.Transform:GetWorldPosition()
	local footprint = SpawnPrefab("cane_ancient_fx")
	footprint.Transform:SetPosition(x, y, z)
	local soultarget=0--灵魂回血目标
	local ents=TheSim:FindEntities(x, y, z, TUNING_MEDAL.MEDAL_RAGE_KRAMPUS_DEVOUR_RADIUS ,nil , {"INLIMBO"},{"FX"})
	if #ents>0 then
		for i,v in ipairs(ents) do
			if v.prefab=="wortox_soul_heal_fx" and not v.noragekrampus then
				soultarget=soultarget+1
				v.noragekrampus=true
			end
		end
		if soultarget>0 then
			if inst.components.health then
				local amt = TUNING.HEALING_MED - math.min(8, soultarget) + 1
				inst.components.health:DoDelta(amt*soultarget)
				if inst.SpawnHealFx then
					inst:SpawnHealFx()--生成吸收灵魂特效
				end
			end
		end
	end
	CheckIsStuck(inst)--检查卡位
	TryDevour(inst)--尝试进行灵魂吞噬
end
--开始生成暗影脚气以及防卡位(每0.5秒判定一次)
local function StartSpawnFootPrint(inst)
	if not inst._foot_print_task then
        inst._foot_print_task = inst:DoPeriodicTask(.5, spawnFootPrint, 0.25)
    end
end
--离开加载范围
local function OnEntitySleep(inst)
    if inst._foot_print_task ~= nil then
        inst._foot_print_task:Cancel()
        inst._foot_print_task = nil
    end
end
--进入加载范围时
local function OnEntityWake(inst)
    StartSpawnFootPrint(inst)
end

local COLLIDETIEMS=30--需要碰撞的次数
--清除碰撞计数
local function ClearRecentlyCharged(inst, other)
    inst.recentlycharged[other] = nil
end
--进行计数并判断计数是否已满
local function recordCharged(inst,other)
	inst.recentlycharged[other] = inst.recentlycharged[other] and inst.recentlycharged[other]+1 or 1
	return inst.recentlycharged[other] and inst.recentlycharged[other]>COLLIDETIEMS
end
--执行碰撞操作
local function onothercollide(inst, other)
	if not other:IsValid() then
	    return
	elseif other:HasTag("smashable") and other.components.health ~= nil then
		if recordCharged(inst,other) then
			ClearRecentlyCharged(inst, other)
			other.components.health:Kill()
		end
	elseif other.components.workable ~= nil
	    and other.components.workable:CanBeWorked()
	    and other.components.workable.action ~= ACTIONS.NET then
		--计数达标后对目标进行破坏
		if recordCharged(inst,other) then
			ClearRecentlyCharged(inst, other)
			SpawnPrefab("collapse_small").Transform:SetPosition(other.Transform:GetWorldPosition())
			other.components.workable:Destroy(inst)
		end
	end
end
--碰撞函数
local function oncollide(inst, other)
    if not (other ~= nil and other:IsValid() and inst:IsValid())
        or (inst.recentlycharged[other] and inst.recentlycharged[other]>COLLIDETIEMS)
        or other:HasTag("player")
        or Vector3(inst.Physics:GetVelocity()):LengthSq() < 42 then
        return
    end
    -- ShakeAllCameras(CAMERASHAKE.SIDE, .5, .05, .1, inst, 40)
    inst:DoTaskInTime(2 * FRAMES, onothercollide, other)
	
	--定时任务，5秒内没发生碰撞清空计数列表
	if inst.cleartask ~= nil then
		inst.cleartask:Cancel()
		inst.cleartask = nil
	end
	inst.cleartask = inst:DoTaskInTime(5, function(i)
		inst.recentlycharged = {}
	end)
end

local PHASE2_HEALTH = 5/6--第二阶段血量比例
local PHASE3_HEALTH = .5--第三阶段血量比例
--设置不同阶段参数(inst,阶段,是否为刚加载)
local function SetPhaseLevel(inst, phase, starting)
	if not starting then--刚加载的时候不需要做这些处理
		if phase <= inst.PhaseLevel then return end
	end

	inst.PhaseLevel = phase
    inst.components.combat:SetDefaultDamage(TUNING_MEDAL.MEDAL_RAGE_KRAMPUS_DAMAGE[phase])--伤害
	inst.components.medal_chaosdamage:SetBaseDamage(TUNING_MEDAL.MEDAL_RAGE_KRAMPUS_CHAOS_DAMAGE[phase])--混沌伤害
	inst.devour_cd = TUNING_MEDAL.MEDAL_RAGE_KRAMPUS_DEVOUR_CD[phase]--灵魂吞噬CD
end
--第二阶段
local function EnterPhase2Trigger(inst)
    SetPhaseLevel(inst, 2)
end
--第三阶段
local function EnterPhase3Trigger(inst)
    SetPhaseLevel(inst, 3)
end

--后加载
local function OnLoadPostPass(inst)
	local healthpct = inst.components.health:GetPercent()--获取血量百分比
    --设置阶段参数
	SetPhaseLevel(
        inst,
        math.max(inst.PhaseLevel,(healthpct > PHASE2_HEALTH and 1) or
        (healthpct > PHASE3_HEALTH and 2) or
        3),
		true
    )
end

--存储函数
local function OnSave(inst, data)
    data.soul_power=inst.soul_power--灵魂之力
	data.PhaseLevel=inst.PhaseLevel--阶段
end
--加载
local function OnLoad(inst, data)
    if data ~= nil then
		inst.soul_power=data.soul_power or 0--读取灵魂之力
		inst.PhaseLevel=data.PhaseLevel or 1--阶段
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()

    MakeCharacterPhysics(inst, 10, .5)

    inst.DynamicShadow:SetSize(3, 1)
    inst.Transform:SetFourFaced()

    inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("deergemresistance")
	inst:AddTag("rage_krampus")
	inst:AddTag("epic")--史诗级生物
    inst:AddTag("ignorewalkableplatformdrowning")--无视炸船溺水
	inst:AddTag("wildfireprotected")--不自燃
	inst:AddTag("chaos_creature")--混沌生物

    inst.AnimState:Hide("ARM")
    inst.AnimState:SetBank("krampus")
    inst.AnimState:SetBuild("medal_rage_krampus")
    inst.AnimState:PlayAnimation("run_loop", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.PhaseLevel = 1--阶段等级
	inst.soul_power = 0--灵魂之力
	inst.devour_cd = TUNING_MEDAL.MEDAL_RAGE_KRAMPUS_DEVOUR_CD[1]--灵魂吞噬CD

    inst.recentlycharged = {}--撞击记录
	inst.Physics:SetCollisionCallback(oncollide)
	inst._previous_position = Vector3(0,0,0)--上一次检测的位置
    inst._time_spent_stuck = 0--卡住的时间
	
	inst:AddComponent("inventory")
    inst.components.inventory.ignorescangoincontainer = true

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = TUNING_MEDAL.MEDAL_RAGE_KRAMPUS_SPEED--移动速度
    inst:SetStateGraph("SGmedal_rage_krampus")

    inst:SetBrain(brain)

    -- MakeLargeBurnableCharacter(inst, "krampus_torso")
    -- MakeLargeFreezableCharacter(inst, "krampus_torso")--可被冰冻

    -- inst:AddComponent("sleeper")--可睡觉
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING_MEDAL.MEDAL_RAGE_KRAMPUS_HEALTH)
	inst.components.health.predelta = HealthPreDelta

	inst:AddComponent("healthtrigger")--生命触发器,不同比例血的时候触发，设定不同阶段属性
    inst.components.healthtrigger:AddTrigger(PHASE2_HEALTH, EnterPhase2Trigger)--5/6
    inst.components.healthtrigger:AddTrigger(PHASE3_HEALTH, EnterPhase3Trigger)--50%

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "krampus_torso"
    inst.components.combat:SetDefaultDamage(TUNING_MEDAL.MEDAL_RAGE_KRAMPUS_DAMAGE[1])--伤害
    inst.components.combat:SetAttackPeriod(TUNING_MEDAL.MEDAL_RAGE_KRAMPUS_ATTACK_PERIOD)--攻击频率
	inst.components.combat.onhitotherfn = OnHitOther--攻击到生物时执行函数

	inst:AddComponent("timer")--定时器
	
	--精神光环
	inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_HUGE
	
	inst:AddComponent("thief")--小偷，踢飞玩家身上东西用
	inst.components.thief:SetOnStolenFn(OnStolen)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('medal_rage_krampus')

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()

	inst:AddComponent("planarentity")--实体抵抗
	inst:AddComponent("medal_chaosdamage")--混沌伤害
	inst.components.medal_chaosdamage:SetBaseDamage(TUNING_MEDAL.MEDAL_RAGE_KRAMPUS_CHAOS_DAMAGE[1])

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("newcombattarget", OnNewCombatTarget)

	inst:ListenForEvent("entity_droploot", function(src,data)
		devour_soul_medal_fn.OnEntityDropLoot(inst, data)
	end, TheWorld)
	inst:ListenForEvent("entity_death", function(src,data)
		devour_soul_medal_fn.OnEntityDeath(inst, data)
	end, TheWorld)
	
	StartSpawnFootPrint(inst)--暗影脚气、防卡位

	inst.SpawnHealFx = spawnHealFx--吸收灵魂特效
	inst.OnDevourSoul = OnDevourSoul

	inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake

	inst.OnSave = OnSave
    inst.OnLoad = OnLoad
	inst.OnLoadPostPass = OnLoadPostPass

    MakeHauntablePanic(inst)

    return inst
end

return Prefab("medal_rage_krampus", fn, assets, prefabs)
