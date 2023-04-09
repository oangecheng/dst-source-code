local devour_soul_medal_fn = require("prefabs/devour_soul_medal_fn")
local assets =
{
    Asset("ANIM", "anim/wortox_soul_ball.zip"),
    -- Asset("SCRIPT", "scripts/prefabs/wortox_soul_common.lua"),
}

local prefabs =
{
    "wortox_soul_heal_fx",
}

--灵魂消亡
local function KillSoul(inst)
    inst:ListenForEvent("animover", inst.Remove)
    inst.AnimState:PlayAnimation("idle_pst")
    inst.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/spawn", nil, .5)
end

--在地上
local function toground(inst)
    -- inst.persists = false
    if inst._task == nil then
        --十秒后消失
		inst._task = inst:DoTaskInTime(TUNING_MEDAL.KRAMPUS_SOUL_LIFETIME, KillSoul)
    end
    if inst.AnimState:IsCurrentAnimation("idle_loop") then
        inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank("wortox_soul_ball")
    inst.AnimState:SetBuild("wortox_soul_ball")
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:SetScale(0.8, 0.8)
    inst.AnimState:SetMultColour(0.4, 0.4, 0.4, 0.8)
    -- inst.AnimState:SetScale(0.5, 0.5)
    -- inst.AnimState:SetMultColour(0.9, 0.9, 0.9, 0.3)
    -- inst.AnimState:SetMultColour(0.1, 0.1, 0.1, 0.3)

    inst:AddTag("nosteal")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst._task = nil
    toground(inst)

    return inst
end

--暴怒之灵在地上
local function toground_big(inst)
    -- inst.persists = false
    if inst._task == nil then
        --六十秒后消失
		inst._task = inst:DoTaskInTime(TUNING_MEDAL.RAGE_KRAMPUS_SOUL_LIFETIME, KillSoul)
    end
    if inst.AnimState:IsCurrentAnimation("idle_loop") then
        inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
    end
end
--掉落灵魂
local function dropSoul(inst)
	local soulnum=math.random(3)
	devour_soul_medal_fn.SpawnSoulsAt(inst,soulnum,true)
	--随机位移，防止被克劳斯包卡位了
	local x, y, z = inst.Transform:GetWorldPosition()
	local theta = math.random() * 2 * PI
	local offset = math.random() * 2
	inst.Transform:SetPosition(x + math.cos(theta) * offset, 0, z + math.sin(theta) * offset)
end

local function onloadfn(inst,data)
	if inst._task then
		inst._task:Cancel()
		inst._task=nil
	end
	inst._task = inst:DoTaskInTime(1, KillSoul)--重载后一秒就消失，免得玩家可以反复sl刷时长
end

local function bigfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank("wortox_soul_ball")
    inst.AnimState:SetBuild("wortox_soul_ball")
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:SetScale(1.2, 1.2)
    inst.AnimState:SetMultColour(0.1, 0.1, 0.1, 0.8)

    inst:AddTag("nosteal")
    inst:AddTag("powerabsorbable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aura = TUNING.SANITYAURA_SMALL--精神光环
	
	inst:DoPeriodicTask(3, dropSoul)--每隔3秒掉几个灵魂

    inst:AddComponent("inspectable")
    inst._task = nil
    toground_big(inst)
	
	inst.OnLoad = onloadfn

    return inst
end

return Prefab("krampus_soul", fn, assets, prefabs),
	Prefab("rage_krampus_soul", bigfn, assets, prefabs)
