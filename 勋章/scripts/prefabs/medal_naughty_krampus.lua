local assets =
{
    Asset("ANIM", "anim/krampus_basic.zip"),
    Asset("ANIM", "anim/medal_naughty_krampus.zip"),
    Asset("SOUND", "sound/krampus.fsb"),
}

local prefabs =
{
    "monstermeat",
    "krampus_sack",
	-- "medal_loss_treasure_map_scraps",
	"toil_money",
	"krampus_soul",
}

local brain = require "brains/krampusbrain"

local INFO = TUNING_MEDAL.MEDAL_NAUGHTY_KRAMPUS--获取淘气坎普斯的数据

SetSharedLootTable( 'medal_naughty_krampus',
{
    {'monstermeat',  1.0},
    {'charcoal',     1.0},
    {'charcoal',     1.0},
	-- {'medal_loss_treasure_map_scraps', .2},
	{'krampus_soul', TUNING_MEDAL.KRAMPUS_SOUL_DROP_RATE},
	{'toil_money', .2},
    {'krampus_sack', .01},
})

local function NotifyBrainOfTarget(inst, target)
    if inst.brain and inst.brain.SetTarget then
        inst.brain:SetTarget(target)
    end
end

local function makebagfull(inst)
    inst.AnimState:Show("SACK")
    inst.AnimState:Hide("ARM")
end

local function makebagempty(inst)
    inst.AnimState:Hide("SACK")
    inst.AnimState:Show("ARM")
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
end

local function OnNewCombatTarget(inst, data)
    NotifyBrainOfTarget(inst, data.target)
end

--存储函数
local function OnSave(inst, data)
    if inst.call_times then
		data.call_times = inst.call_times
	end
end
--加载
local function OnLoad(inst, data)
    if data ~= nil then
		inst.call_times=data.call_times
		if inst.InitInfo then
			inst:InitInfo(true)
		end
	end
end
--初始化各数据(inst,不更新血量数据)
local function InitInfo(inst,nohealth)
	-- inst.call_times=1--召唤次数，需要记录,一切数据用这个作为基础来计算,保存也只需要存这个就好了
	local calltimes = inst.call_times or 0
	if not nohealth then
		local health = math.min(INFO.HEALTH + INFO.HEALTH_ADD * calltimes,INFO.HEALTH_MAX)--血量
		inst.components.health:SetMaxHealth(health)
		inst.components.health.save_maxhealth = health--存储血量上限
	end
	inst.components.combat:SetDefaultDamage(math.min(INFO.DAMAGE + INFO.DAMAGE_ADD * math.floor(calltimes/5),INFO.DAMAGE_MAX))--伤害
	inst.components.health:SetAbsorptionAmount(math.min(math.floor(calltimes/10) * INFO.ABSORPTION_ADD,INFO.ABSORPTION_MAX))--减伤
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 10, .5)

    inst.DynamicShadow:SetSize(3, 1)
    inst.Transform:SetFourFaced()

    inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("deergemresistance")

    inst.AnimState:Hide("ARM")
    inst.AnimState:SetBank("krampus")
    inst.AnimState:SetBuild("medal_naughty_krampus")
    inst.AnimState:PlayAnimation("run_loop", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventory")
    inst.components.inventory.ignorescangoincontainer = true

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = INFO.SPEED
    inst:SetStateGraph("SGkrampus")

    inst:SetBrain(brain)

    MakeLargeBurnableCharacter(inst, "krampus_torso")
    MakeLargeFreezableCharacter(inst, "krampus_torso")

 --[[   inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater:SetStrongStomach(true) -- can eat monster meat!--]]

    inst:AddComponent("sleeper")
    inst.components.sleeper.watchlight = true
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(INFO.HEALTH)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "krampus_torso"
    inst.components.combat:SetDefaultDamage(INFO.DAMAGE)
    inst.components.combat:SetAttackPeriod(INFO.ATTACK_PERIOD)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('medal_naughty_krampus')

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("newcombattarget", OnNewCombatTarget)

	inst.InitInfo = InitInfo
	inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    MakeHauntablePanic(inst)

    return inst
end

return Prefab("medal_naughty_krampus", fn, assets, prefabs)