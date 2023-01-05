local assets =
{
    Asset("ANIM", "anim/bee_guard.zip"),
    Asset("ANIM", "anim/medal_bee_guard_build.zip"),
    Asset("ANIM", "anim/medal_bee_guard_puffy_build.zip"),
}

local prefabs =
{
    "bee_poof_big",
    "bee_poof_small",
    "stinger",
}

--------------------------------------------------------------------------

local brain = require("brains/medal_beeguardbrain")

--------------------------------------------------------------------------
--正常模式的声音
local normalsounds =
{
    attack = "dontstarve/bee/killerbee_attack",
    --attack = "dontstarve/creatures/together/bee_queen/beeguard/attack",
    buzz = "dontstarve/bee/bee_fly_LP",
    hit = "dontstarve/creatures/together/bee_queen/beeguard/hurt",
    death = "dontstarve/creatures/together/bee_queen/beeguard/death",
}
--炸毛后的声音
local poofysounds =
{
    attack = "dontstarve/bee/killerbee_attack",
    --attack = "dontstarve/creatures/together/bee_queen/beeguard/attack",
    buzz = "dontstarve/bee/killerbee_fly_LP",
    hit = "dontstarve/creatures/together/bee_queen/beeguard/hurt",
    death = "dontstarve/creatures/together/bee_queen/beeguard/death",
}
--是否允许发出嗡嗡声
local function EnableBuzz(inst, enable)
    if enable then
        if not inst.buzzing then
            inst.buzzing = true
            if not inst:IsAsleep() then
                inst.SoundEmitter:PlaySound(inst.sounds.buzz, "buzz")
            end
        end
    elseif inst.buzzing then
        inst.buzzing = false
        inst.SoundEmitter:KillSound("buzz")
    end
end
--预置物唤醒
local function OnEntityWake(inst)
    if inst._sleeptask ~= nil then
        inst._sleeptask:Cancel()
        inst._sleeptask = nil
    end

    if inst.buzzing then
        inst.SoundEmitter:PlaySound(inst.sounds.buzz, "buzz")
    end
end
--预置物休眠
local function OnEntitySleep(inst)
    if inst._sleeptask ~= nil then
        inst._sleeptask:Cancel()
    end
	--如果进入休眠状态时没死亡的话，10秒后移除
    inst._sleeptask = not inst.components.health:IsDead() and inst:DoTaskInTime(10, inst.Remove) or nil
	--移除声音播放器
    inst.SoundEmitter:KillSound("buzz")
end

--------------------------------------------------------------------------
--检查目标是否有效
local function CheckFocusTarget(inst)
    --如果之前集火的目标无效了、挂了、在鬼魂状态，就移除该目标
	if inst._focustarget ~= nil and (
            not inst._focustarget:IsValid() or
            (inst._focustarget.components.health ~= nil and inst._focustarget.components.health:IsDead()) or
            inst._focustarget:HasTag("playerghost")
        ) then
        inst._focustarget = nil
        inst:RemoveTag("notaunt")
    end
    return inst._focustarget
end
--重选目标函数
local function RetargetFn(inst)
    local focustarget = CheckFocusTarget(inst)
    if focustarget ~= nil then
        --集火目标存在，则继续干他！第二个参数表示是否切换攻击对象了
		return focustarget, not inst.components.combat:TargetIs(focustarget)
    end
    local player, distsq = inst:GetNearestPlayer()--否则就薅一个最近的玩家
    return distsq ~= nil and distsq < 225 and player or nil--和玩家间的距离小于25，则将这个玩家作为攻击对象
end
--保持目标函数
local function KeepTargetFn(inst, target)
    local focustarget = CheckFocusTarget(inst)
    return (focustarget ~= nil and
            inst.components.combat:TargetIs(focustarget))
        or (inst.components.combat:CanTarget(target) and
            inst:IsNear(target, 40))
end
--额外伤害(对有蜜蜂过敏的目标额外造成10点伤害)
local function bonus_damage_via_allergy(inst, target, damage, weapon)
	--对有蜜蜂过敏的目标额外造成10点伤害
	local extra_damage = target:HasTag("allergictobees") and TUNING.BEE_ALLERGY_EXTRADAMAGE or 0
    local blood_mark = target.blood_honey_mark or 0--血蜜标记层数
	--对中了蜂毒的目标造成额外伤害=(max(蜂毒层数-5,0)/10+向下取整(凋零值/20)*0.5+0.5)*蜂毒层数*(0.005*血蜜标记层数²+1)*难度系数
	if target.injured_damage then
		local withered_num = 0--凋零值
		local queen = inst.components.entitytracker:GetEntity("queen")--获取实体跟踪器绑定的蜂王
		if queen and queen.components.health and not queen.components.health:IsDead() then
			withered_num=queen.GetWithereNum and queen:GetWithereNum() or 0--获取凋零值
		end
		extra_damage = extra_damage+(math.max(target.injured_damage-5,0)/10+math.floor(withered_num/20)*0.5+0.5)*target.injured_damage*(0.005*math.pow(blood_mark,2)+1)*TUNING_MEDAL.MEDAL_BEEGUARD_EXTRA_DAMAGE_MULT
	end
	-- print("小蜂额外伤害:"..extra_damage)
	return extra_damage
end
--判断是否可以把攻击目标共享给对方
local function CanShareTarget(dude)
    --对方必须是蜂类，并且不在容器里，也没死，也不能是蜂后这种级别的
	return dude:HasTag("bee") and not (dude:IsInLimbo() or dude.components.health:IsDead() or dude:HasTag("epic"))
end
--被攻击时
local function OnAttacked(inst, data)
    if data.attacker and not data.attacker:HasTag("shadowchesspiece") then
		inst.components.combat:SetTarget(CheckFocusTarget(inst) or data.attacker)--尽量保持原来的集火目标，除非集火目标失效
		inst.components.combat:ShareTarget(data.attacker, 20, CanShareTarget, 6)--共享目标(集体仇恨)
	end
end
local function OnAttackOther(inst, data)
--攻击目标时
    --如果目标穿了防蜂的护甲的话，受击动画会更简短一点
	if data.target ~= nil and data.target.components.inventory ~= nil then
        for k, eslot in pairs(EQUIPSLOTS) do
            local equip = data.target.components.inventory:GetEquippedItem(eslot)
            if equip ~= nil and equip.components.armor ~= nil and equip.components.armor.tags ~= nil then
                for i, tag in ipairs(equip.components.armor.tags) do
                    if tag == "bee" then
                        inst.components.combat:SetPlayerStunlock(PLAYERSTUNLOCK.OFTEN)
                        return
                    end
                end
            end
        end
    end
    inst.components.combat:SetPlayerStunlock(PLAYERSTUNLOCK.ALWAYS)
end
--攻击目标后
local function OnHitOther(inst,data)
	if data and data.target then
        local blood_mark = data.target and data.target.blood_honey_mark or 0--血蜜标记层数
        --炸毛状态记录总吸血量
        if inst.puffy_drink_blood then
            local queen = inst.components.entitytracker:GetEntity("queen")--获取实体跟踪器绑定的蜂王
            local drink_blood_mult=1--吸血倍率
            
			if queen and queen.components.health and not queen.components.health:IsDead() then
                local withered_num=queen.GetWithereNum and queen:GetWithereNum() or 0--获取凋零值(包含守卫数量带来的凋零值加成)
                local soldiers_num = queen.components.commander and queen.components.commander:GetNumSoldiers() or 0--获取守卫数量
                --吸血倍率=max(凋零值,堕落之蜂数量)*(3.5-向下取整(arctan(凋零值/2.5+1)*20)/10)*(0.01*血蜜标记层数²+1)*难度系数
                drink_blood_mult=math.max(withered_num,soldiers_num)*(3.5-math.floor(math.atan(withered_num/2.5+1)*20)/10)*(0.01*math.pow(blood_mark,2)+1)*TUNING_MEDAL.MEDAL_BEEGUARD_DRINK_BLOOD_MULT
            end

            if data.damage then
                inst.puffy_drink_blood=inst.puffy_drink_blood+data.damage*drink_blood_mult
                -- print("伤害:"..data.damage..",吸血量:"..inst.puffy_drink_blood)
                if blood_mark>0 then
                    data.target.blood_honey_mark = data.target.blood_honey_mark-1--减少一层血蜜标记
                    if data.target.blood_honey_mark<=0 then
                        data.target:RemoveDebuff("buff_medal_bloodhoneymark")--移除血蜜标记
                    end
                end
            end
        --非炸毛状态
        -- elseif data.target.components.debuffable ~= nil and data.target.components.debuffable:IsEnabled() and
        --     not (data.target.components.health ~= nil and data.target.components.health:IsDead()) and
        --     not data.target:HasTag("playerghost") then
        --         data.target.components.debuffable:AddDebuff("buff_medal_bloodhoneymark","buff_medal_bloodhoneymark")--添加血蜜标记
        --         --血蜜标记层数超标了,概率叠毒
        --         if blood_mark>=TUNING_MEDAL.MEDAL_BUFF_BLOODHONEYMARK_MAX and math.random()<.25 then
        --             data.target.components.debuffable:AddDebuff("buff_medal_injured","buff_medal_injured")--蜂毒
        --         end
        -- end
        else
            data.target:AddDebuff("buff_medal_bloodhoneymark","buff_medal_bloodhoneymark")--添加血蜜标记
            --血蜜标记层数超标了,概率叠毒
            if blood_mark>=TUNING_MEDAL.MEDAL_BUFF_BLOODHONEYMARK_MAX and math.random()<.25 then
                data.target.components.debuffable:AddDebuff("buff_medal_injured","buff_medal_injured")--蜂毒
            end
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
--加载函数
local function OnLoadPostPass(inst)
    local queen = inst.components.entitytracker:GetEntity("queen")
    if queen ~= nil and queen.components.commander ~= nil then
        queen.components.commander:AddSoldier(inst)--载入游戏后重新绑定蜂王
    end
end
--出生后成为蜂王的士兵
local function OnSpawnedGuard(inst, queen)
    inst.sg:GoToState("spawnin", queen)
    if queen.components.commander ~= nil then
        queen.components.commander:AddSoldier(inst)
    end
end
--死亡，炸它丫的！
local function OnDeath(inst)
	SpawnPrefab("medal_blood_honey_splat").Transform:SetPosition(inst.Transform:GetWorldPosition())
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents=TheSim:FindEntities(x, y, z, 2.5 ,nil , {"INLIMBO", "NOCLICK", "catchable", "notdevourable","bee"},{"player","_combat"})
	local damage=inst.puffy_drink_blood or 0--爆炸伤害=自身吸血量
	if #ents>0 then
		for i,v in ipairs(ents) do
            local blood_mark = v.blood_honey_mark or 0--血蜜标记层数
            if blood_mark < TUNING_MEDAL.MEDAL_BEEGUARD_MARK_CONSUME then
                if v.components.debuffable ~= nil and v.components.debuffable:IsEnabled() and
                not (v.components.health ~= nil and v.components.health:IsDead()) and
                not v:HasTag("playerghost") then
                    v.components.debuffable:AddDebuff("buff_medal_bloodhoneymark","buff_medal_bloodhoneymark")
                end
            elseif v.components.pinnable then
                -- v.components.pinnable:Stick("medal_blood_honey_goo")--黏他
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
                    v.components.pinnable:Stick("medal_blood_honey_goo")--黏他
                end
                v.blood_honey_mark = v.blood_honey_mark-TUNING_MEDAL.MEDAL_BEEGUARD_MARK_CONSUME--消耗血蜜标记
                if v.blood_honey_mark<=0 then
                    v:RemoveDebuff("buff_medal_bloodhoneymark")--移除血蜜标记
                end
            end
			--造成自身吸血量的aoe伤害
			if v.components.combat and damage>0 then
				v.components.combat:GetAttacked(inst, damage/5, nil)
			end
		end
	end
	inst.puffy_drink_blood=nil
end

--------------------------------------------------------------------------
--集火目标
local function FocusTarget(inst, target)
    inst._focustarget = target
    inst:AddTag("notaunt")
	--目标不为空，则炸毛
    if target ~= nil then
        if inst.components.locomotor.walkspeed ~= TUNING_MEDAL.MEDAL_BEEGUARD_DASH_SPEED then
            inst.AnimState:SetBuild("medal_bee_guard_puffy_build")--炸毛状态贴图
			inst.puffy_drink_blood=0--标记为炸毛状态,开始记录炸毛状态吸血量
            inst.components.locomotor.walkspeed = TUNING_MEDAL.MEDAL_BEEGUARD_DASH_SPEED--加快移速
            inst.components.combat:SetDefaultDamage(TUNING_MEDAL.MEDAL_BEEGUARD_PUFFY_DAMAGE)--提高伤害
            inst.components.combat:SetAttackPeriod(TUNING_MEDAL.MEDAL_BEEGUARD_PUFFY_ATTACK_PERIOD)--攻击频率变快
            inst.sounds = poofysounds--切换声音文件
            if inst.SoundEmitter:PlayingSound("buzz") then
                inst.SoundEmitter:KillSound("buzz")
                inst.SoundEmitter:PlaySound(inst.sounds.buzz, "buzz")
            end
            SpawnPrefab("bee_poof_big").Transform:SetPosition(inst.Transform:GetWorldPosition())--炸毛特效
        end
        inst.components.combat:SetTarget(target)
    --目标为空，则取消炸毛
	elseif inst.components.locomotor.walkspeed ~= TUNING_MEDAL.MEDAL_BEEGUARD_SPEED then
        if inst.puffy_drink_blood then
			local queen = inst.components.entitytracker:GetEntity("queen")--获取实体跟踪器绑定的蜂王
			if queen and queen.components.health and not queen.components.health:IsDead() then
				if inst.puffy_drink_blood>0 then
					-- print("吸血:"..inst.puffy_drink_blood)
					queen.components.health:DoDelta(inst.puffy_drink_blood)--将吸来的血献祭给蜂王,献祭血量=吸血量*蜂王凋零值
					if queen.withered_num>0 then
						--降低凋零值，降低量=math.clamp(math.floor(吸血量/40),0.5,4)
						queen.withered_num=math.max(queen.withered_num-math.clamp(math.floor(inst.puffy_drink_blood/40),0.5,4),0)
					end
				end
			end
			inst.puffy_drink_blood=nil--取消炸毛状态标记
		end
		inst.AnimState:SetBuild("medal_bee_guard_build")--普通状态贴图
        inst.components.locomotor.walkspeed = TUNING_MEDAL.MEDAL_BEEGUARD_SPEED--移速变慢
        inst.components.combat:SetDefaultDamage(TUNING_MEDAL.MEDAL_BEEGUARD_PUFFY_DAMAGE)--伤害保持为炸毛后伤害
        inst.components.combat:SetAttackPeriod(TUNING_MEDAL.MEDAL_BEEGUARD_PUFFY_ATTACK_PERIOD)--保持加快的攻击频率
        inst.sounds = normalsounds--切换声音文件
        if inst.SoundEmitter:PlayingSound("buzz") then
            inst.SoundEmitter:KillSound("buzz")
            inst.SoundEmitter:PlaySound(inst.sounds.buzz, "buzz")
        end
        SpawnPrefab("bee_poof_small").Transform:SetPosition(inst.Transform:GetWorldPosition())--炸毛特效
    end
end
--绑定蜂王
local function OnGotCommander(inst, data)
    local queen = inst.components.entitytracker:GetEntity("queen")--获取实体跟踪器绑定的蜂王
    if queen ~= data.commander then--如果之前绑定的蜂王和现在的不同(或者未绑定)，则绑定当前的蜂王
        inst.components.entitytracker:ForgetEntity("queen")--遗忘之前的蜂王
        inst.components.entitytracker:TrackEntity("queen", data.commander)--绑定新蜂王

        local angle = -inst.Transform:GetRotation() * DEGREES
        inst.components.knownlocations:RememberLocation("queenoffset", Vector3(TUNING_MEDAL.MEDAL_BEEGUARD_GUARD_RANGE * math.cos(angle), 0, TUNING_MEDAL.MEDAL_BEEGUARD_GUARD_RANGE * math.sin(angle)), false)--标记护卫点
    end
end
--失去指挥者
local function OnLostCommander(inst, data)
    local queen = inst.components.entitytracker:GetEntity("queen")
    if queen == data.commander then
        inst.components.entitytracker:ForgetEntity("queen")--遗忘之前的指挥者
        inst.components.knownlocations:ForgetLocation("queenoffset")--遗忘护卫坐标点
        FocusTarget(inst, nil)
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

    inst.DynamicShadow:SetSize(1.2, .75)

    MakeFlyingCharacterPhysics(inst, 1.5, .75)

    inst.AnimState:SetBank("bee_guard")
    inst.AnimState:SetBuild("medal_bee_guard_build")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("insect")--昆虫
    inst:AddTag("bee")--蜜蜂
    inst:AddTag("monster")--怪物
    inst:AddTag("hostile")--敌对生物
    inst:AddTag("scarytoprey")--可怕的捕食者
    inst:AddTag("flying")--飞行生物
    inst:AddTag("ignorewalkableplatformdrowning")--无视炸船溺水
	inst:AddTag("senior_tentaclemedal")--不会被触手主动攻击
	-- inst.senior_tentaclemedal=true--不会被触手主动攻击

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.recentlycharged = {}

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:AddChanceLoot("royal_jelly", 0.02)--蜂王浆
    inst.components.lootdropper:AddChanceLoot("medal_bee_larva", 0.1)--育王蜂种

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(4)--睡眠抗性
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)
    inst.components.sleeper.diminishingreturns = true--睡眠收益递减(就是越来越抗催眠)

    inst:AddComponent("locomotor")
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)--不受地皮速度影响
    inst.components.locomotor:SetTriggersCreep(false)--不受蜘蛛丝影响
    inst.components.locomotor.walkspeed = TUNING_MEDAL.MEDAL_BEEGUARD_SPEED--初始移速
    inst.components.locomotor.pathcaps = {ignorewalls = true, allowocean = true }--无视墙和海

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING_MEDAL.MEDAL_BEEGUARD_HEALTH)--血量

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING_MEDAL.MEDAL_BEEGUARD_DAMAGE)--初始伤害
    inst.components.combat:SetAttackPeriod(TUNING_MEDAL.MEDAL_BEEGUARD_ATTACK_PERIOD)--初始攻击频率
    inst.components.combat.playerdamagepercent = .5--对玩家的伤害减半
    inst.components.combat:SetRange(TUNING_MEDAL.MEDAL_BEEGUARD_ATTACK_RANGE)--伤害范围1.5
    inst.components.combat:SetRetargetFunction(2, RetargetFn)--设定重选目标函数(2秒1次)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)--保持目标函数
    inst.components.combat.battlecryenabled = false--取消战斗呐喊设定(战斗呐喊就是指进入战斗的时候会播一次taunt动画，比如巨鹿发现目标会挥一下手)
    inst.components.combat.hiteffectsymbol = "mane"--命中效果部位
    inst.components.combat.bonusdamagefn = bonus_damage_via_allergy--额外伤害

    inst:AddComponent("entitytracker")--实体跟踪器
    inst:AddComponent("knownlocations")

    MakeSmallBurnableCharacter(inst, "mane")--可点燃
    MakeSmallFreezableCharacter(inst, "mane")--可冰冻
    inst.components.freezable:SetResistance(2)--冰冻抗性
    inst.components.freezable.diminishingreturns = true--冰冻效益递减

    inst:SetStateGraph("SGmedal_beeguard")--绑定sg动画
    inst:SetBrain(brain)--绑定行为树

    MakeHauntablePanic(inst)--可作祟

    inst.hit_recovery = 1--攻击冷却时间

    inst:ListenForEvent("gotcommander", OnGotCommander)--监听绑定指挥者事件(出生的时候就被绑定到蜂王身上去了，会推送该事件)
    inst:ListenForEvent("lostcommander", OnLostCommander)--监听失去指挥者事件
    inst:ListenForEvent("attacked", OnAttacked)--被攻击
    inst:ListenForEvent("onattackother", OnAttackOther)--攻击目标
    inst:ListenForEvent("onhitother", OnHitOther)--攻击目标后(可以拿到伤害)

    inst.buzzing = true
    inst.sounds = normalsounds--声音文件
    inst.EnableBuzz = EnableBuzz--是否允许发出嗡嗡声
    inst.OnEntitySleep = OnEntitySleep--预置物休眠(脱离加载范围休眠)
    inst.OnEntityWake = OnEntityWake--预置物唤醒
    inst.OnLoadPostPass = OnLoadPostPass
    inst.OnSpawnedGuard = OnSpawnedGuard--出生的时候执行
	inst.OnDeath=OnDeath--死亡的时候执行

    inst._focustarget = nil--集火目标
    inst.FocusTarget = FocusTarget--变更集火目标函数

    return inst
end

return Prefab("medal_beeguard", fn, assets, prefabs)
