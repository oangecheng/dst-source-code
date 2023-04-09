local assets =
{
    Asset("ANIM", "anim/bee_queen_basic.zip"),
    Asset("ANIM", "anim/bee_queen_actions.zip"),
    Asset("ANIM", "anim/medal_bee_queen_build.zip"),
}

local prefabs =
{
    "medal_beeguard",
    "medal_honey_trail",
    "splash_sink",
    "royal_jelly",
    "honeycomb",
    "honey",
    "stinger",
    "hivehat",
    "bundlewrap_blueprint",
	"chesspiece_beequeen_sketch",
	"bee_king_certificate",
    "medal_withered_royaljelly",
}

SetSharedLootTable('medal_beequeen',
{
    {'royal_jelly',			1.00},
    {'royal_jelly',			1.00},
    {'royal_jelly',			1.00},
    {'medal_withered_royaljelly',			1.00},
    {'medal_withered_royaljelly',			1.00},
    {'medal_withered_royaljelly',			1.00},
    -- {'royal_jelly',			1.00},
    -- {'royal_jelly',			1.00},
    {'honeycomb',			1.00},
    {'honeycomb',			1.00},
    {'honey',				1.00},
    {'honey',				1.00},
    {'honey',				1.00},
    {'stinger',				1.00},
    {'medal_withered_heart',1.00},
 --    {'hivehat',          1.00},
 --    {'bundlewrap_blueprint', 1.00},
	-- {'chesspiece_beequeen_sketch', 1.00},
})

--------------------------------------------------------------------------

local brain = require("brains/medal_beequeenbrain")

--------------------------------------------------------------------------

local MAX_HONEY_VARIATIONS = 7--蜂蜜小径形状数量
local MAX_RECENT_HONEY = 4
local HONEY_PERIOD = .2
local HONEY_LEVELS =
{
    {
        min_scale = .5,--最小比例
        max_scale = .8,--最大比例
        threshold = 8,--产蜜阈值，每0.2秒加1，达到阈值则产蜜，相当于就是1.6秒产一次
        duration = 1.2,--蜂蜜小径存在时间
    },
    {
        min_scale = .5,
        max_scale = 1.1,
        threshold = 2,
        duration = 2,
    },
    {
        min_scale = 1,
        max_scale = 1.3,
        threshold = 1,
        duration = 4,
    },
}
--选择蜂蜜形状
local function PickHoney(inst)
    local rand = table.remove(inst.availablehoney, math.random(#inst.availablehoney))--在可用蜂蜜形状列表中随机挑选一种并从列表中移除
    table.insert(inst.usedhoney, rand)--移除后加入已使用列表
    --如果已使用列表内蜂蜜数量大于4,则把最前面使用的蜂蜜移除并加回到可用蜂蜜形状列表中
	if #inst.usedhoney > MAX_RECENT_HONEY then
        table.insert(inst.availablehoney, table.remove(inst.usedhoney, 1))
    end
    return rand
end
--灭火
local function Extinguish(x,y,z,dist)
	local ents = TheSim:FindEntities(x, y, z, dist or 2, nil, { "FX", "DECOR", "INLIMBO", "burnt" })
	for i, v in ipairs(ents) do
		if v.components.burnable ~= nil then
			if v.components.burnable:IsBurning() then
				v.components.burnable:Extinguish(true, TUNING.FIRESUPPRESSOR_EXTINGUISH_HEAT_PERCENT)
			elseif v.components.burnable:IsSmoldering() then
				v.components.burnable:Extinguish(true)
			end
		--矮星直接灭掉
		elseif v.prefab=="stafflight" then
			if v.components.hauntable and v.components.hauntable.onhaunt then
				v.components.hauntable.onhaunt(v)
			end
		end
	end
end
--生成蜂蜜小径
local function DoHoneyTrail(inst)
    --生成的小径等级,静止时1级,移速低于正常移速时2级,否则3级
	local level = HONEY_LEVELS[
        (not inst.sg:HasStateTag("moving") and 1) or
        (inst.components.locomotor.walkspeed <= TUNING_MEDAL.MEDAL_BEEQUEEN_SPEED and 2) or
        3
    ]
	--蜂蜜计数加1
    inst.honeycount = inst.honeycount + 1
	--如果产蜜阈值不超过当前蜂蜜小径等级对应的阈值
    if inst.honeythreshold > level.threshold then
        inst.honeythreshold = level.threshold
    end
	--计数大于阈值则生成蜂蜜小径
    if inst.honeycount >= inst.honeythreshold then
        local hx, hy, hz = inst.Transform:GetWorldPosition()
        inst.honeycount = 0--蜂蜜计数归零
        --产蜜阈值低于等级阈值，则产蜜阈值=(产蜜阈值+等级阈值)/2向上取整
		if inst.honeythreshold < level.threshold then
            inst.honeythreshold = math.ceil((inst.honeythreshold + level.threshold) * .5)
        end
		--在陆地则根据当前等级生成相应的小径,在水里则生成水花
        local fx = nil
        if TheWorld.Map:IsPassableAtPoint(hx, hy, hz) then
            fx = SpawnPrefab("medal_honey_trail")
            local scale=GetRandomMinMax(level.min_scale, level.max_scale)--小径尺寸
			Extinguish(hx,hy,hz)--灭火
			--设置小径变量(形状,尺寸比例,持续时间)
			fx:SetVariation(PickHoney(inst), scale, level.duration + math.random() * .5)
        else
            fx = SpawnPrefab("splash_sink")
        end
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    end
end
--开始流蜜
local function StartHoney(inst)
    if inst.honeytask == nil then
        inst.honeythreshold = HONEY_LEVELS[1].threshold--产蜜阈值
        inst.honeycount = math.ceil(inst.honeythreshold * .5)--蜂蜜计数=阈值的一半向上取整(计数大于阈值则生成蜂蜜小径)
        inst.honeytask = inst:DoPeriodicTask(HONEY_PERIOD, DoHoneyTrail, 0)--定时生成蜂蜜小径(0.2秒加一次计数)
    end
end
--停止流蜜
local function StopHoney(inst)
    if inst.honeytask ~= nil then
        inst.honeytask:Cancel()
        inst.honeytask = nil
    end
end

--开始恢复体力(睡觉、冰冻休眠的时候回血)
local function StartRecovery(inst)
	if inst.medal_recovery_task == nil then
		inst.medal_recovery_task = inst:DoPeriodicTask(0.5, function(inst)
			--每0.5秒恢复233点血
			if inst.components.health ~= nil and not inst.components.health:IsDead() then
				inst.components.health:DoDelta(233)
			end
			--每0.5秒减少1点凋零值
			if inst.withered_num > 0 then
				inst.withered_num = math.max(inst.withered_num - 1,0)
			end
		end)--定时生成蜂蜜小径(0.2秒加一次计数)
	end
end

--停止恢复体力
local function StopRecovery(inst)
    if inst.medal_recovery_task ~= nil then
        inst.medal_recovery_task:Cancel()
        inst.medal_recovery_task = nil
    end
end

--------------------------------------------------------------------------
--更新玩家目标组
local function UpdatePlayerTargets(inst)
    local toadd = {}
    local toremove = {}
    local pos = inst.components.knownlocations:GetLocation("spawnpoint")--获取出生点
	--获取蜂后的目标组，给他们添加到toremove数组里
    for k, v in pairs(inst.components.grouptargeter:GetTargets()) do
        toremove[k] = true
    end
	--寻找脱战范围内的玩家(距离蜂后出生点60以内)
    for i, v in ipairs(FindPlayersInRange(pos.x, pos.y, pos.z, TUNING.BEEQUEEN_DEAGGRO_DIST, true)) do
        --如果是原本就有的目标，则从toremove数组里移除
		if toremove[v] then
            toremove[v] = nil
        else--否则就加入toadd数组里
            table.insert(toadd, v)
        end
    end
	--如果在toremove数组里，则从目标组中移除该目标
    for k, v in pairs(toremove) do
        inst.components.grouptargeter:RemoveTarget(k)
    end
	--如果在toadd数组里，则将目标加入到目标组内
    for i, v in ipairs(toadd) do
        inst.components.grouptargeter:AddTarget(v)
    end
end
--重选目标函数
local function RetargetFn(inst)
    UpdatePlayerTargets(inst)--更新玩家目标组(就是获取蜂后出生点60距离以内的玩家)

    local target = inst.components.combat.target--当前攻击目标
    local inrange = target ~= nil and inst:IsNear(target, TUNING.BEEQUEEN_ATTACK_RANGE + target:GetPhysicsRadius(0))--目标是否在攻击范围内
	--当前目标是玩家,则尝试更换目标为出生点附近的其他玩家(优先找在攻击范围内的，其次是仇恨范围内)
    if target ~= nil and target:HasTag("player") then
        local newplayer = inst.components.grouptargeter:TryGetNewTarget()--尝试更换新目标
        return newplayer ~= nil
            and newplayer:IsNear(inst, inrange and TUNING.BEEQUEEN_ATTACK_RANGE + newplayer:GetPhysicsRadius(0) or TUNING.BEEQUEEN_AGGRO_DIST)
            and newplayer
            or nil,
            true
    end
	--当前目标不是玩家，则寻找出生点附近的玩家(优先找在攻击范围内的，其次是仇恨范围内)
    local nearplayers = {}
    for k, v in pairs(inst.components.grouptargeter:GetTargets()) do
        if inst:IsNear(k, inrange and TUNING.BEEQUEEN_ATTACK_RANGE + k:GetPhysicsRadius(0) or TUNING.BEEQUEEN_AGGRO_DIST) then
            table.insert(nearplayers, k)
        end
    end
    return #nearplayers > 0 and nearplayers[math.random(#nearplayers)] or nil, true
end
--保持目标函数(目标还持续存在并且没脱离出生点太远)
local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
        and target:GetDistanceSqToPoint(inst.components.knownlocations:GetLocation("spawnpoint")) < TUNING.BEEQUEEN_DEAGGRO_DIST * TUNING.BEEQUEEN_DEAGGRO_DIST
end
--额外伤害
local function bonus_damage_via_allergy(inst, target, damage, weapon)
	--对有蜜蜂过敏的目标额外造成10点伤害
	local extra_damage = target:HasTag("allergictobees") and TUNING.BEE_ALLERGY_EXTRADAMAGE or 0
    local blood_mark = target.blood_honey_mark or 0--血蜜标记层数
	--对中了蜂毒的目标造成额外伤害=(max(蜂毒层数-3,0)/5+向下取整(凋零值/10)+1)*蜂毒层数*(0.005*血蜜标记层数²+1)*难度系数
	if target.injured_damage then
		local withered_num=inst.GetWithereNum and inst:GetWithereNum() or 0
		extra_damage = extra_damage+(math.max(target.injured_damage-3,0)/5+math.floor(withered_num/10)+1)*target.injured_damage*(0.005*math.pow(blood_mark,2)+1)*TUNING_MEDAL.MEDAL_BEEQUEEN_EXTRA_DAMAGE_MULT
	end
	-- print("蜂王额外伤害:"..extra_damage)
	return extra_damage
end
--会引起尖叫的物品清单
local screech_loot={
	"winona_catapult_projectile",--投石机
	-- "eyeturret",--眼球塔
}
--被攻击时
local function OnAttacked(inst, data)
    if data.attacker ~=nil then
        local x,y,z=data.attacker.Transform:GetWorldPosition()
        local tile = TheWorld.Map:GetTileAtPoint(x, y, z)
        if data.attacker:HasTag("eyeofterror") or data.attacker:HasTag("shadowchesspiece")  then
            inst:PushEvent("flee")--我他妈直接避战.jpg
        elseif tile and (tile == GROUND.IMPASSABLE or tile == GROUND.INVALID) then
            inst:PushEvent("flee")--我他妈直接避战.jpg
        else
            local target = inst.components.combat.target--原攻击目标
            local screeched = nil--是否已经发出过尖叫
            --如果原来的攻击目标是玩家并且在蜂后的仇恨范围内，则保留原目标，否则切换攻击目标为最新的攻击者
            if not (target ~= nil and
                    target:HasTag("player") and
                    
                    target:IsNear(inst, inst.focustarget_cd > 0 and TUNING.BEEQUEEN_ATTACK_RANGE + target:GetPhysicsRadius(0) or TUNING.BEEQUEEN_AGGRO_DIST)) then
                inst.components.combat:SetTarget(data.attacker)
            end
            --命令蜜蜂守卫去攻击 攻击者
            inst.components.commander:ShareTargetToAllSoldiers(data.attacker)
            --如果是被玩家攻击了，去获取玩家的坐标，看看有没有违反万有引力
            if data.attacker:HasTag("player") and y>=1 then
                --上天了？把你黏在地上摩擦
                -- inst:PushEvent("screech")
                data.attacker.Transform:SetPosition(x,0,z)
                if data.attacker.components.pinnable then
                    data.attacker.components.pinnable:Stick("medal_blood_honey_goo")
                end
            --被特殊建筑攻击了，直接发出尖叫
            elseif data.attacker.prefab and table.contains(screech_loot,data.attacker.prefab) then
                inst:PushEvent("screech")
            end
        end
    end

    -- if data.weapon ~=nil then
    --     if data.weapon.components.perishable then
    --         --有保鲜度的武器打一下烂10%
    --         data.weapon.components.perishable:ReducePercent(0.1)
    --     end
    -- end
end
--在攻击其他目标时，在目标脚底生成一滩蜂蜜
local function OnAttackOther(inst, data)
    if data.target ~= nil then
        local fx = SpawnPrefab("medal_honey_trail")
        fx.Transform:SetPosition(data.target.Transform:GetWorldPosition())
        fx:SetVariation(PickHoney(inst), GetRandomMinMax(1, 1.3), 4 + math.random() * .5)
		--添加流血debuff
		if data.target.components.debuffable ~= nil and data.target.components.debuffable:IsEnabled() and
			not (data.target.components.health ~= nil and data.target.components.health:IsDead()) and
			not data.target:HasTag("playerghost") then
			data.target.components.debuffable:AddDebuff("buff_medal_injured","buff_medal_injured")
		end
    end
end
--没攻击到目标时，往前面射一坨粘液，试图黏住玩家
local function OnMissOther(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local angle = -inst.Transform:GetRotation() * DEGREES
	local is_splat = false--是否是粘液
	x, y, z = x + TUNING.BEEQUEEN_HIT_RANGE * math.cos(angle), 0, z + TUNING.BEEQUEEN_HIT_RANGE * math.sin(angle)
	--尝试生成粘液
	local ents=TheSim:FindEntities(x, y, z, 2 ,nil , {"INLIMBO", "NOCLICK", "catchable", "notdevourable"},{"player"})
	if #ents>0 then
		for i,v in ipairs(ents) do
			if v.components.pinnable ~= nil then
				if not is_splat then
					SpawnPrefab("medal_blood_honey_splat").Transform:SetPosition(v.Transform:GetWorldPosition())
				end
                --有黑暗血糖
                if v.components.debuffable and v.components.debuffable:HasDebuff("buff_medal_suckingblood") then
                    --暗影盾
                    local fx=SpawnPrefab("medal_shield_player")
                    if fx then fx.entity:SetParent(v.entity) end
                    --抵消buff时长
                    v.components.debuffable:AddDebuff("buff_medal_suckingblood", "buff_medal_suckingblood",{extend_durationfn=function(timer_left)
                        return math.max(0,timer_left - TUNING_MEDAL.MEDAL_BUFF_SUCKINGBLOOD_GOO_CONSUME)
                    end})
                else
                    v.components.pinnable:Stick("medal_blood_honey_goo")
                end
				is_splat=true
			end
		end
	end
	--没有粘液就生成血蜜
	if not is_splat then
		local fx = SpawnPrefab("medal_honey_trail")
		fx.Transform:SetPosition(x, 0, z)
		fx:SetVariation(PickHoney(inst), GetRandomMinMax(1, 1.3), 4 + math.random() * .5)
	end
end
--掉血时
local function OnHealthDelta(inst,data)
	if data then
		-- if data.afflicter and data.afflicter:HasTag("player") then
			if data.amount and data.amount<0 then
				-- print("受到伤害:"..(-data.amount))
				inst.withered_num = inst.withered_num + math.ceil(math.max(-data.amount/TUNING_MEDAL.MEDAL_BEEQUEEN_HEALTH-0.006,0)*500)
				if inst.UpdateState then
					inst:UpdateState()
				end
			end
		-- end
	end
end

--------------------------------------------------------------------------
local upvaluehelper = require "medal_upvaluehelper"--出自 风铃草大佬
--嘶吼、恐吓
local function scareFn(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	local taunt_must_tags={"_sanity","catapult","mosquito"}--,"eyeturret"}--需检测的标签
	--这里范围用投石机的范围
	local ents=TheSim:FindEntities(x, y, z, TUNING.WINONA_CATAPULT_MAX_RANGE ,nil , {"INLIMBO", "NOCLICK", "catchable", "notdevourable"},taunt_must_tags)
	if #ents>0 then
		for i,v in ipairs(ents) do
			if v:HasTag("mosquito") then
				if v.drinks then
					local TakeDrink = upvaluehelper.GetEventHandle(v,"onattackother","prefabs/mosquito")--获取蚊子的吸血函数
					TakeDrink(v)--吸血
				end
			elseif v:HasTag("catapult") then-- or v:HasTag("eyeturret") then
				--直接远程导弹打击
				SpawnPrefab("fossilspike2").Transform:SetPosition(v.Transform:GetWorldPosition())
			--有san值,则san值发生改变
			elseif v.components.sanity then 
				local sanityNum=30--精神变化
				--月岛加启蒙值
				if v.components.sanity:IsInsanityMode() then
					sanityNum=-sanityNum
				end
				v.components.sanity:DoDelta(sanityNum)
				local should_spooked=true--是否应该被恐惧
				if v.components.inventory then
					local medal=v.components.inventory:EquipMedalWithName("justice_certificate")--获取玩家的正义勋章
					if medal and medal.components.finiteuses then
						if medal.components.finiteuses:GetUses() >= TUNING_MEDAL.MEDAL_BEEQUEEN_SCARE_JUSTICE_VALUE then
							medal.components.finiteuses:Use(TUNING_MEDAL.MEDAL_BEEQUEEN_SCARE_JUSTICE_VALUE)--消耗正义值
							should_spooked=false--不应该被恐惧了
						end
					end
				end
				--恐惧sg
				-- if should_spooked and not (v.sg:HasStateTag("busy") or v.components.health:IsDead() or v.components.rider:IsRiding()) then
                if should_spooked and not (v.sg:HasStateTag("busy") or v.components.health:IsDead()) then
					if v.components.rider and v.components.rider:IsRiding() then
                        local mount=v.components.rider:GetMount()
                        if mount and mount.components.rideable then
                            mount.components.rideable:Buck()
                        end
                    else
                        v.sg:GoToState("medal_spooked")
                    end
				end
				--上天了？把你黏在地上摩擦
				local vx,vy,vz=v.Transform:GetWorldPosition()
				if vy>=1 then
					v.Transform:SetPosition(vx,0,vz)
					if v.components.pinnable then
						v.components.pinnable:Stick("medal_blood_honey_goo")
					end
				end
			end
		end
	end
end

--获取凋零值
local function getWithereNum(inst)
	local withered_num=inst.withered_num or 0--凋零值
	--士气加成，守卫的数量越多，减伤越高、对玩家的伤害倍率也越高
	if inst.components.commander then
		local soldiers_num = inst.components.commander:GetNumSoldiers()--获取守卫数量
		--凋零值=凋零值+max(守卫数量-最小阈值,0)*2.5
		withered_num = math.min(withered_num + math.max(soldiers_num-TUNING_MEDAL.MEDAL_BEEQUEEN_TOTAL_GUARDS,0)*2.5,90)
	end
	-- print("凋零值:"..withered_num)
	return withered_num
end

--更新自身状态
local function updateState(inst)
	local withered_num=inst.GetWithereNum and inst:GetWithereNum() or 0
	-- print("凋零值:"..withered_num..",减伤:"..(withered_num/100)..",伤害倍率:"..(withered_num*0.005+0.5))
	inst.components.health:SetAbsorptionAmount(withered_num/100)--减伤=凋零值/100
	inst.components.combat.playerdamagepercent = withered_num*0.005+0.5--对玩家伤害倍率=凋零值*0.005+0.5
	
	--守卫数量上限=(周围玩家数量+1)*4+玩家跟随者数量*1
	if inst.components.grouptargeter then
		-- local player_num = GetTableSize(inst.components.grouptargeter:GetTargets())--获取周围玩家数量
        local player_num = 0
        local target_num = 0
        for k, v in pairs(inst.components.grouptargeter:GetTargets()) do
            player_num = player_num+1
            if k.components.leader then
                target_num = target_num + k.components.leader:CountFollowers()
            end
        end
		inst.spawnguards_threshold = math.max(TUNING_MEDAL.MEDAL_BEEQUEEN_MIN_GUARDS_PER_SPAWN*(player_num + 1) + target_num,TUNING_MEDAL.MEDAL_BEEQUEEN_TOTAL_GUARDS)--守卫数量阈值
        -- print(inst.spawnguards_threshold)
	end
end

--------------------------------------------------------------------------

local DEFAULT_COMMANDER_RANGE = 40--默认指挥距离
local BOOSTED_COMMANDER_RANGE = 80--增强指挥距离
--更新指挥距离
local function UpdateCommanderRange(inst)
    local range = inst.components.commander.trackingdist - 4
    --指挥距离大于40则每秒降低4距离，直到降到40为止(降到40停止周期任务)
	if range > DEFAULT_COMMANDER_RANGE then
        inst.components.commander:SetTrackingDistance(range)
    else
        inst.components.commander:SetTrackingDistance(DEFAULT_COMMANDER_RANGE)
        inst.commandertask:Cancel()
        inst.commandertask = nil
    end
end
--提升指挥距离
local function BoostCommanderRange(inst, boost)
    inst.commanderboost = boost--是否增强(这里是数值不是布尔值)
    --如果增强，则设置指挥距离为增强版距离
	if boost then
        if inst.commandertask ~= nil then
            inst.commandertask:Cancel()
            inst.commandertask = nil
        end
        inst.components.commander:SetTrackingDistance(BOOSTED_COMMANDER_RANGE)
    --未增强并且指挥距离大于默认指挥距离，则添加周期任务，每秒更新一次指挥距离
	elseif inst.components.commander.trackingdist > DEFAULT_COMMANDER_RANGE
        and inst.commandertask == nil
        and not inst:IsAsleep() then
        inst.commandertask = inst:DoPeriodicTask(1, UpdateCommanderRange)
    end
end

--------------------------------------------------------------------------

local PHASE2_HEALTH = .75--第二阶段血量比例
local PHASE3_HEALTH = .5--第三阶段血量比例
local PHASE4_HEALTH = .25--第四阶段血量比例
--设置不同阶段参数
local function SetPhaseLevel(inst, phase)
    inst.focustarget_cd = TUNING_MEDAL.MEDAL_BEEQUEEN_FOCUSTARGET_CD[phase]--集中攻击目标的CD(等于0的时候不能集火)
    inst.spawnguards_cd = TUNING_MEDAL.MEDAL_BEEQUEEN_SPAWNGUARDS_CD[phase]--生成蜜蜂守卫的CD
    inst.spawnguards_maxchain = TUNING_MEDAL.MEDAL_BEEQUEEN_SPAWNGUARDS_CHAIN[phase]--可连续生成守卫的次数(为0的时候生成一波守卫就开始CD了，为1则可以生成两波才开始CD)
    --蜜蜂守卫阈值，第一阶段小于1只才会继续生成蜜蜂守卫，第二阶段开始小于阈值就会生成
	-- inst.spawnguards_threshold = phase > 1 and TUNING_MEDAL.MEDAL_BEEQUEEN_TOTAL_GUARDS or 1
end
--第二阶段
local function EnterPhase2Trigger(inst)
    SetPhaseLevel(inst, 2)
    inst:PushEvent("screech")--尖叫
end
--第三阶段
local function EnterPhase3Trigger(inst)
    SetPhaseLevel(inst, 3)
    inst:PushEvent("screech")
end
--第四阶段
local function EnterPhase4Trigger(inst)
    SetPhaseLevel(inst, 4)
    inst:PushEvent("screech")
end
--存储函数
local function OnSave(inst, data)
    --增强距离=指挥距离>默认指挥距离 and 指挥距离 or nil
	data.boost = inst.components.commander.trackingdist > DEFAULT_COMMANDER_RANGE and math.ceil(inst.components.commander.trackingdist) or nil
	data.withered_num=inst.withered_num--凋零值
end
--加载
local function OnLoad(inst, data)
    local healthpct = inst.components.health:GetPercent()--获取血量百分比
    --设置阶段参数
	SetPhaseLevel(
        inst,
        (healthpct > PHASE2_HEALTH and 1) or
        (healthpct > PHASE3_HEALTH and 2) or
        (healthpct > PHASE4_HEALTH and 3) or
        4
    )
	
    if data ~= nil then
        --读取存储的指挥距离
		if data.boost ~= nil and data.boost > inst.components.commander.trackingdist then
			inst.components.commander:SetTrackingDistance(data.boost)
			if not (inst.commanderboost or inst:IsAsleep()) then
				BoostCommanderRange(inst, false)
			end
		end
		--读取凋零值
		inst.withered_num=data.withered_num or 0
		if inst.UpdateState then
			inst:UpdateState()
		end
	end
end

--------------------------------------------------------------------------

local function ShouldSleep(inst)
    return false
end

local function ShouldWake(inst)
    return true
end

--------------------------------------------------------------------------
--预置物休眠函数
local function OnEntitySleep(inst)
    if inst._sleeptask ~= nil then
        inst._sleeptask:Cancel()
    end
	--如果进入休眠状态时蜂后没死亡的话，10秒后移除蜂后
    inst._sleeptask = not inst.components.health:IsDead() and inst:DoTaskInTime(10, inst.Remove) or nil

    if inst.commandertask ~= nil then
        inst.commandertask:Cancel()
        inst.commandertask = nil
    end
end
--预置物唤醒函数
local function OnEntityWake(inst)
    if inst._sleeptask ~= nil then
        inst._sleeptask:Cancel()
        inst._sleeptask = nil
    end
	--设置指挥距离
    BoostCommanderRange(inst, inst.commanderboost)
end

--------------------------------------------------------------------------

local function PushMusic(inst)
    if ThePlayer == nil or inst:HasTag("flight") then
        inst._playingmusic = false
    elseif ThePlayer:IsNear(inst, inst._playingmusic and 40 or 20) then
        inst._playingmusic = true
        ThePlayer:PushEvent("triggeredevent", { name = "beequeen" })
    elseif inst._playingmusic and not ThePlayer:IsNear(inst, 50) then
        inst._playingmusic = false
    end
end

--------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddDynamicShadow()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetSixFaced()
    inst.Transform:SetScale(1.4, 1.4, 1.4)

    inst.DynamicShadow:SetSize(4, 2)

    -- MakeFlyingGiantCharacterPhysics(inst, 500, 1.4)
    -- MakeFlyingGiantCharacterPhysics(inst, 1.5, 1.4)
	MakeFlyingCharacterPhysics(inst, 500, .75)--算了，还是无视生物墙吧

    inst.AnimState:SetBank("bee_queen")
    inst.AnimState:SetBuild("medal_bee_queen_build")
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst:AddTag("epic")--史诗级生物
    inst:AddTag("noepicmusic")--无史诗音乐
    inst:AddTag("bee")--蜜蜂
    inst:AddTag("insect")--昆虫
    inst:AddTag("monster")--怪物
    inst:AddTag("hostile")--敌对生物
    inst:AddTag("scarytoprey")--可怕的捕食者
    inst:AddTag("largecreature")--巨型生物
    inst:AddTag("flying")--飞行生物
    inst:AddTag("ignorewalkableplatformdrowning")--无视炸船溺水
	inst:AddTag("medal_beequeen")--凋零之蜂标签(用来确认世界唯一性)
	inst:AddTag("senior_tentaclemedal")--不会被触手主动攻击
	-- inst.senior_tentaclemedal=true--不会被触手主动攻击

    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/wings_LP", "flying")

    MakeInventoryFloatable(inst, "large", 0.1, {0.6, 1.0, 0.6})

    inst.entity:SetPristine()

    --Dedicated server does not need to trigger music
    if not TheNet:IsDedicated() then
        inst._playingmusic = false
        inst:DoPeriodicTask(1, PushMusic, 0)
    end

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.withered_num=0--凋零值

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('medal_beequeen')

    inst:AddComponent("sleeper")--睡眠组件
    inst.components.sleeper:SetResistance(4)--睡眠抗性
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)
    inst.components.sleeper.diminishingreturns = true--睡眠收益递减(就是越来越抗催眠)

    inst:AddComponent("locomotor")
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)--不受地皮速度影响
    inst.components.locomotor:SetTriggersCreep(false)--不受蜘蛛丝影响
    inst.components.locomotor.pathcaps = { ignorewalls = true, allowocean = true }--无视墙和海
    inst.components.locomotor.walkspeed = TUNING_MEDAL.MEDAL_BEEQUEEN_SPEED--移速

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING_MEDAL.MEDAL_BEEQUEEN_HEALTH)--血量上限
    inst.components.health.nofadeout = true--死的时候不执行remove函数，就要用这个参数来使尸体不可被交互并缓慢腐坏(这里主要是因为蜂王会牵扯到绑定的地块以及守卫)

    inst:AddComponent("healthtrigger")--生命触发器,不同比例血的时候触发，设定不同阶段属性
    inst.components.healthtrigger:AddTrigger(PHASE2_HEALTH, EnterPhase2Trigger)--75%
    inst.components.healthtrigger:AddTrigger(PHASE3_HEALTH, EnterPhase3Trigger)--50%
    inst.components.healthtrigger:AddTrigger(PHASE4_HEALTH, EnterPhase4Trigger)--25%

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING_MEDAL.MEDAL_BEEQUEEN_DAMAGE)--伤害
    inst.components.combat:SetAttackPeriod(TUNING_MEDAL.MEDAL_BEEQUEEN_ATTACK_PERIOD)--攻击频率，几秒一下
    inst.components.combat.playerdamagepercent = .5--对玩家伤害为默认伤害的一半
    inst.components.combat:SetRange(TUNING.BEEQUEEN_ATTACK_RANGE, TUNING.BEEQUEEN_HIT_RANGE)--攻击距离4，命中距离6
    inst.components.combat:SetRetargetFunction(3, RetargetFn)--设定重选目标函数(3秒1次)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)--保持目标函数
    inst.components.combat.battlecryenabled = false--取消战斗呐喊设定(战斗呐喊就是指进入战斗的时候会播一次taunt动画，比如巨鹿发现目标会挥一下手)
    inst.components.combat.hiteffectsymbol = "hive_body"--命中效果部位
    inst.components.combat.bonusdamagefn = bonus_damage_via_allergy--额外伤害

    inst:AddComponent("explosiveresist")--抗爆炸伤害组件

    inst:AddComponent("grouptargeter")--目标组
    inst:AddComponent("commander")--指挥官
    inst.components.commander:SetTrackingDistance(DEFAULT_COMMANDER_RANGE)--指挥距离40

    inst:AddComponent("timer")--定时器

    inst:AddComponent("sanityaura")--精神光环

    inst:AddComponent("epicscare")--恐吓
    inst.components.epicscare:SetRange(TUNING.BEEQUEEN_EPICSCARE_RANGE)--恐吓距离10

    inst:AddComponent("knownlocations")--记录坐标点组件

    MakeLargeBurnableCharacter(inst, "swap_fire")--可点燃
    MakeHugeFreezableCharacter(inst, "hive_body")--可冰冻
    inst.components.freezable.diminishingreturns = true--冰冻效果递减

    inst:SetStateGraph("SGmedal_beequeen")
    inst:SetBrain(brain)

    inst.hit_recovery = TUNING_MEDAL.MEDAL_BEEQUEEN_HIT_RECOVERY--攻击冷却时间
    inst.spawnguards_chain = 0--默认连续生成守卫次数为0
    SetPhaseLevel(inst, 1)--初始阶段参数
	inst.spawnguards_threshold = TUNING_MEDAL.MEDAL_BEEQUEEN_TOTAL_GUARDS--守卫数量阈值

    inst.BoostCommanderRange = BoostCommanderRange--提升指挥距离函数
    inst.commanderboost = false--是否是强化的指挥官
    inst.commandertask = nil--指挥距离变更周期任务

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnEntitySleep = OnEntitySleep--预置物休眠
    inst.OnEntityWake = OnEntityWake--预置物唤醒

    inst.UpdateState = updateState--更新自身状态
	inst.ScareFn=scareFn--嘶吼函数
	inst.GetWithereNum=getWithereNum--获取凋零值
	
	inst.StartHoney = StartHoney--开始流蜜
    inst.StopHoney = StopHoney--停止流蜜
	inst.StartRecovery = StartRecovery--开始恢复体力(睡觉、冰冻休眠的时候恢复体力)
	inst.StopRecovery = StopRecovery--停止恢复体力
    inst.honeytask = nil
    inst.honeycount = 0--蜂蜜计数
    inst.honeythreshold = 0--产蜜阈值
    inst.usedhoney = {}--已使用的蜂蜜形状列表
    inst.availablehoney = {}--可使用的蜂蜜形状列表
    for i = 1, MAX_HONEY_VARIATIONS do--给蜂蜜形状列表添加数据
        table.insert(inst.availablehoney, i)
    end
    inst:StartHoney()--开始生成蜜蜂小径

    inst:ListenForEvent("attacked", OnAttacked)--被攻击时
    inst:ListenForEvent("onattackother", OnAttackOther)--攻击到目标时
    inst:ListenForEvent("onmissother", OnMissOther)--没攻击到目标时
	inst:ListenForEvent("healthdelta", OnHealthDelta)--掉血时

    return inst
end

return Prefab("medal_beequeen", fn, assets, prefabs)
