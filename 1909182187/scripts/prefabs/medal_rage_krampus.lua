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
    if inst.UpdateState then
		inst:UpdateState()
	end

	inst.components.combat:SetTarget(data.attacker)--将攻击者设为目标

	if data.attacker ~=nil then
        local x,y,z=data.attacker.Transform:GetWorldPosition()
        local tile = TheWorld.Map:GetTileAtPoint(x, y, z)
        if tile and (tile == GROUND.IMPASSABLE or tile == GROUND.INVALID) then
            if inst.sg then
				inst.sg:GoToState("exit")--我他妈直接跑路.jpg
			end
		end
	end
end
--新的攻击目标
local function OnNewCombatTarget(inst, data)
    NotifyBrainOfTarget(inst, data.target)
end

local STEAL_CANT_TAGS = { "INLIMBO", "catchable", "fire", "irreplaceable", "heavy", "prey", "bird", "outofreach", "_container" }
--踢掉东西的时候给它偷走
local function OnStolen(inst,victim,item,consume)
	if item and not (inst.components.inventory:IsFull() or item:HasOneOfTags(STEAL_CANT_TAGS)) then
		local act=BufferedAction(inst, item, ACTIONS.PICKUP)
		inst:PushBufferedAction(act)
		if consume then--消耗灵魂之力
			inst.soul_power=math.max(inst.soul_power-5,0)
		end
	end
end

--攻击效果权重
local effect_list={
	knockback=1,--击飞
	steal=2,--掉落第一个道具
	drop=1,--卸甲
}
local effect_fn_list={
	knockback={
		fn=function(inst, other)
			if other:HasTag("player") and other.components.health ~= nil and not other.components.health:IsDead() then
				other:PushEvent("knockback", {knocker = inst, radius = math.random(3,8)})
			end
		end,
	},
	steal={
		fn=function(inst, other)
			inst.components.thief:StealItem(other)
		end,
	},
	drop={
		fn=function(inst, other, devour)
			if other ~= nil and other.components.inventory ~= nil then
				--装备掉光的概率
				--远程只和暗影坎普斯被卡位的时间有关，概率=(卡位秒数-5)*0.1
				--踢中装备全掉概率=min(灵魂之力*0.02,0.5)
				local allchance = devour and (inst._time_spent_stuck-5)*0.1 or math.min((inst.soul_power or 0)*0.02,0.5)
				--概率掉落全部装备
				if math.random() < allchance then
					other.components.inventory:DropEverything()
					inst.soul_power=math.max(inst.soul_power-10,0)
				else--否则只踢掉1件装备
					local item = other.components.inventory:DropOneEquipped()
					if item and not devour and math.random() < math.min((inst.soul_power or 0)*0.02,0.5) then
						OnStolen(inst, other, item, true)--近战的话，不仅踢掉，还有概率偷走
					end
				end
			end
		end,
	},
}

--攻击到生物时执行函数
local function OnHitOther(inst, other, damage)
	local effect_key=weighted_random_choice(effect_list)
	if effect_key and effect_fn_list[effect_key] then
		effect_fn_list[effect_key].fn(inst, other)
	end
end

--打乱物品
local function DisruptionItem(v)
	if v.Physics ~= nil and v.Physics:IsActive() then
		local vx, vy, vz = v.Transform:GetWorldPosition()
		local dx, dz = vx - x, vz - z
		local spd = math.sqrt(dx * dx + dz * dz)
		local angle =
			spd > 0 and
			math.atan2(dz / spd, dx / spd) + (math.random() * 20 - 10) * DEGREES or
			math.random() * 2 * PI
		spd = 3 + math.random() * 1.5
		v.Physics:Teleport(vx, 0, vz)
		v.Physics:SetVel(math.cos(angle) * spd, 0, math.sin(angle) * spd)
	end
end

--生成万物之灵
local function spawnSoul(inst,num)
	devour_soul_medal_fn.SpawnSoulsAt(inst, num or 1, nil, true)--生成万物之灵
end

--黑名单物品
local BLACKLIST={
	fossil_stalker=true,--化石碎片
	endtable=true,--茶几
	table_winters_feast=true,--冬季盛宴桌子
	-- lureplant=true,--食人花
	homesign=true,--木牌
	arrowsign_post=true--方向牌
}

--嘲讽敌人
local function OnTaunt(inst)
    local x,y,z = inst.Transform:GetWorldPosition()
	local devour_health=0--吸收血量
	local treatmultiple=0--治疗倍数
	local taunt_must_tags={"_combat","_health","trap","structure","burnt","explosive"}
	local ents=TheSim:FindEntities(x, y, z, 10 ,nil , {"INLIMBO", "NOCLICK", "catchable", "notdevourable"},taunt_must_tags)
	if #ents>0 then
		for i,v in ipairs(ents) do
			--是玩家，则吸血
			if v:HasTag("player") then 
				if v.components.health and not v.components.health:IsDead() then
					local chance=math.clamp((inst.soul_power or 0)*0.025,0,0.5)
					if math.random()<chance then
						effect_fn_list.drop.fn(inst,v,true)--卸甲
					end
					--玩家吃了血糖则减少吸血量
					local losshealthvalue=25
					spawnSoul(v)--生成万物之灵
					v.components.health:DoDelta(-losshealthvalue)
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
			inst:GetPosition()
		end
		local delta = inst:GetPosition() - inst._previous_position
        --当前位置和上一次记录的位置太近，计时增加
        if VecUtil_LengthSq(delta.x, delta.z) <= 0.5*0.5 then
            inst._time_spent_stuck = inst._time_spent_stuck + 0.5
        else--否则清空计时
            inst._time_spent_stuck = 0
        end

        inst._previous_position = inst:GetPosition()
		--卡位超过15秒，跑路
		if inst._time_spent_stuck >= 15 then
			inst.sg:GoToState("exit")
		--否则每5秒嘲讽一下
		elseif inst._time_spent_stuck>0 and inst._time_spent_stuck%5==0 then
			inst.sg:GoToState("taunt")
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
	local ents=TheSim:FindEntities(x, y, z, 10 ,nil , {"INLIMBO"},{"FX"})
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
	CheckIsStuck(inst)
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
		-- print("清空计数")
		inst.recentlycharged = {}
	end)
end

--更新自身状态
local function updateState(inst)
	-- print("暗夜值:"..inst.darknight_num)
	inst.components.health:SetAbsorptionAmount(inst.darknight_num/100)--减伤=暗夜值/100
end

--存储函数
local function OnSave(inst, data)
    data.darknight_num=inst.darknight_num--暗夜值
    data.soul_power=inst.soul_power--灵魂之力
end
--加载
local function OnLoad(inst, data)
    if data ~= nil then
		inst.darknight_num=data.darknight_num or 0--读取暗夜值
		inst.soul_power=data.soul_power or 0--读取灵魂之力
		if inst.UpdateState then
			inst:UpdateState()
		end
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
	inst:AddTag("senior_tentaclemedal")--不会被触手主动攻击
	inst:AddTag("rage_krampus")
    inst:AddTag("ignorewalkableplatformdrowning")--无视炸船溺水
    inst:AddTag("medal_dist_absorb")--远程减伤
	-- inst.senior_tentaclemedal=true--不会被触手主动攻击

    inst.AnimState:Hide("ARM")
    inst.AnimState:SetBank("krampus")
    inst.AnimState:SetBuild("medal_rage_krampus")
    inst.AnimState:PlayAnimation("run_loop", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.recentlycharged = {}--撞击记录
	inst.darknight_num=0--暗夜值
	inst.soul_power=0--灵魂之力
	inst.Physics:SetCollisionCallback(oncollide)
	inst._previous_position = Vector3(0,0,0)--上一次检测的位置
    inst._time_spent_stuck = 0--卡住的时间
	
	inst:AddComponent("inventory")
    inst.components.inventory.ignorescangoincontainer = true

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = TUNING_MEDAL.MEDAL_RAGE_KRAMPUS_SPEED--移动速度
    inst:SetStateGraph("SGkrampus")

    inst:SetBrain(brain)

    MakeLargeBurnableCharacter(inst, "krampus_torso")
    -- MakeLargeFreezableCharacter(inst, "krampus_torso")--可被冰冻

    -- inst:AddComponent("sleeper")--可睡觉
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING_MEDAL.MEDAL_RAGE_KRAMPUS_HEALTH)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "krampus_torso"
    inst.components.combat:SetDefaultDamage(TUNING_MEDAL.MEDAL_RAGE_KRAMPUS_DAMAGE)--伤害
    inst.components.combat:SetAttackPeriod(TUNING_MEDAL.MEDAL_RAGE_KRAMPUS_ATTACK_PERIOD)--攻击频率
	inst.components.combat.onhitotherfn = OnHitOther--攻击到生物时执行函数
	--精神光环
	inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_HUGE
	
	inst:AddComponent("thief")--小偷，踢飞玩家身上东西用
	inst.components.thief:SetOnStolenFn(OnStolen)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('medal_rage_krampus')

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("newcombattarget", OnNewCombatTarget)
	inst:ListenForEvent("krampustaunt",OnTaunt)

	inst:ListenForEvent("entity_droploot", function(src,data)
		devour_soul_medal_fn.OnEntityDropLoot(inst, data)
	end, TheWorld)
	inst:ListenForEvent("entity_death", function(src,data)
		devour_soul_medal_fn.OnEntityDeath(inst, data)
	end, TheWorld)
	
	StartSpawnFootPrint(inst)--暗影脚气、防卡位

	inst.UpdateState = updateState--更新自身状态
	inst.SpawnHealFx = spawnHealFx--吸收灵魂特效

	inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake

	inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    MakeHauntablePanic(inst)

    return inst
end

return Prefab("medal_rage_krampus", fn, assets, prefabs)
