local BALLOONS = require "prefabs/balloons_common"

local assets =
{
    Asset("ANIM", "anim/balloon.zip"),
    Asset("ANIM", "anim/balloon_shapes.zip"),
    Asset("ANIM", "anim/balloon2.zip"),
    Asset("ANIM", "anim/balloon_shapes2.zip"),
    Asset("SCRIPT", "scripts/prefabs/balloons_common.lua"),
    -- Asset("ATLAS", "images/medal_balloon.xml"),
    -- Asset("ATLAS", "images/shadow_balloon.xml"),
}

local NUM_BALLOON_SHAPES = 9--气球形状数量
for i = 1, NUM_BALLOON_SHAPES do
	table.insert(assets, Asset("INV_IMAGE", "balloon_"..tostring(i)))
end

local prefabs =
{
    "balloon_held_child", -- used in balloons_common.OnEquip_Hand
}
--设置气球形状
local function SetBalloonShape(inst, num)
    inst.balloon_num = num
    inst.AnimState:OverrideSymbol("swap_balloon", "balloon_shapes2", "balloon_"..tostring(num))
	inst.components.inventoryitem:ChangeImageName("balloon_"..tostring(num))
end
--存储气球数据
local function onsave(inst, data)
    data.num = inst.balloon_num
    data.colour_idx = inst.colour_idx
end
--加载气球数据
local function onload(inst, data)
    if data ~= nil then
        if data.num ~= nil and inst.balloon_num ~= data.num then
			SetBalloonShape(inst, data.num)
        end
        if data.colour_idx ~= nil then
			inst.colour_idx = BALLOONS.SetColour(inst, data.colour_idx)
        end
    end
end

--[[
local colours =
{
    { 198/255,  43/255,  43/255, 1 },
    {  79/255, 153/255,  68/255, 1 },
    {  35/255, 105/255, 235/255, 1 },
    { 233/255, 208/255,  69/255, 1 },
    { 109/255,  50/255, 163/255, 1 },
    { 222/255, 126/255,  39/255, 1 },
    { 0/255, 0/255,  0/255, 1 },--暗影气球
}

--保存函数
local function onsave(inst, data)
    data.num = inst.balloon_num--形状编号
    data.colour_idx = inst.colour_idx--色彩编号
end
--读取函数
local function onload(inst, data)
    if data ~= nil then
        if data.num ~= nil and inst.balloon_num ~= data.num then
            inst.balloon_num = data.num
            inst.AnimState:OverrideSymbol("swap_balloon", "balloon_shapes", "balloon_"..tostring(inst.balloon_num))
        end
        if data.colour_idx ~= nil and inst.colour_idx ~= data.colour_idx then
            inst.colour_idx = math.clamp(data.colour_idx, 1, #colours)
            inst.AnimState:SetMultColour(unpack(colours[inst.colour_idx]))
        end
    end
end
]]

--不造成伤害清单
local ignoreList={
	"INLIMBO",--在容器里的
	"notarget",--无法选中目标的
	"noattack",--无法攻击的
	"flight",--飞行中的
	"invisible",--看不见的
	"playerghost",--玩家变成的鬼
	"has_silence_certificate",--沉默勋章装备者
	"abigail",--阿比盖尔
	"glommer",--格罗姆
	"companion"--同伴
}

--进行范围攻击
local function DoAreaAttack(inst,chain_num)
	local searchTarget=nil--设定目标函数
	local attackRange=math.clamp(chain_num/4+2, 3, 8)--攻击距离
	if inst.prefab=="shadow_balloon" then
		searchTarget=function(target,inst)
			return target:HasTag("shadow")
		end
		attackRange=math.clamp(chain_num/2+2, 3, 8)
	end
    inst.components.combat:DoAreaAttack(inst, attackRange, nil, searchTarget, chain_num, ignoreList)
end
--受到攻击时执行
local function OnAttacked(inst,data)
	BALLOONS.DeactiveBalloon(inst)
	
	inst.AnimState:PlayAnimation("pop")
	inst.SoundEmitter:PlaySound("dontstarve/common/balloon_pop")
	
	local chain_num=1--连锁次数
	if data then
		if data.attacker then
			--沉默气球
			if data.attacker.prefab=="medal_balloon" then
				if data.stimuli and type(data.stimuli)=="number" then
					-- print("继承次数"..data.stimuli)
					chain_num=data.stimuli+1
					inst.components.combat:SetDefaultDamage(math.min(TUNING.BALLOON_DAMAGE*(0.3*chain_num+1),50))--重设伤害
				end
			--暗影气球
			elseif data.attacker.prefab=="shadow_balloon" then
				if data.stimuli and type(data.stimuli)=="number" then
					-- print("继承次数"..data.stimuli)
					chain_num=data.stimuli+1
					inst.components.combat:SetDefaultDamage(math.min(TUNING.BALLOON_DAMAGE*6*(0.1*chain_num+1),60))--重设伤害
				end
			end
		end
		-- if data.damage then
			-- print("伤害"..data.damage)
		-- end
	end
	
	local time_mult = 0.7 + math.random() * 0.4
	inst.AnimState:SetDeltaTimeMultiplier(time_mult)
	
	local attack_delay = (.1 + math.random() * .2)*time_mult
	inst:DoTaskInTime(attack_delay, DoAreaAttack,chain_num)
	
	local remove_delay = math.max(attack_delay, inst.AnimState:GetCurrentAnimationLength() * time_mult) + FRAMES
	inst:DoTaskInTime(remove_delay, inst.Remove)
end

--定义气球(名字，是否为暗影气球)
local function MakeBalloon(name,isshadow)
	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddDynamicShadow()
		inst.entity:AddNetwork()

		MakeCharacterPhysics(inst, 10, .25)
		inst.Physics:SetFriction(.3)--摩擦力
		inst.Physics:SetDamping(0)--阻力
		inst.Physics:SetRestitution(1)

		inst.AnimState:SetBank("balloon2")
		inst.AnimState:SetBuild("balloon2")
		inst.AnimState:PlayAnimation("idle", true)
		inst.AnimState:SetRayTestOnBB(true)

		inst.DynamicShadow:SetSize(1, .5)

		inst:AddTag("nopunch")
		inst:AddTag("cattoyairborne")--空中猫玩具
		inst:AddTag("balloon")
		inst:AddTag("noepicmusic")
		
		if isshadow then
			inst:AddTag("crazy")--可对影怪造成伤害
			inst:AddTag("shadow")--暗影属性
		end

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		-- inst.Physics:SetCollisionCallback(oncollide)--碰撞回调函数
		inst:AddComponent("inspectable")
		
		inst:AddComponent("poppable")
		inst.components.poppable.onpopfn = OnAttacked
		
		inst:AddComponent("combat")
		inst.components.combat:SetDefaultDamage(TUNING.BALLOON_DAMAGE*(isshadow and 6 or 1))--默认伤害5，暗影气球30
		
		inst:AddComponent("health")
		inst.components.health:SetMaxHealth(1)
		inst.components.health.nofadeout = true
		inst.components.health.canmurder = false
		-- inst:ListenForEvent("death", ondeath)
		
		inst:AddComponent("inventoryitem")
			
		MakeHauntableLaunch(inst)
		
		inst.AnimState:SetTime(math.random() * 2)
		
		SetBalloonShape(inst, math.random(NUM_BALLOON_SHAPES))
		BALLOONS.SetRopeShape(inst)
		
		inst.colour_idx = BALLOONS.SetColour(inst)
		
		inst:AddComponent("equippable")
		inst.components.equippable:SetOnEquip(BALLOONS.OnEquip_Hand)
		inst.components.equippable:SetOnUnequip(BALLOONS.OnUnequip_Hand)
		
		if isshadow then
			inst:AddComponent("sanityaura")--暗影气球有降san光环
			inst.components.sanityaura.aura = -TUNING.SANITYAURA_SMALL_TINY
		end
		
		inst:ListenForEvent("attacked",OnAttacked)--收到攻击触发的函数

		inst.OnSave = onsave
		inst.OnLoad = onload

		return inst
	end

	return Prefab(name, fn, assets, prefabs)
end

return MakeBalloon("medal_balloon",false),
	MakeBalloon("shadow_balloon",true)