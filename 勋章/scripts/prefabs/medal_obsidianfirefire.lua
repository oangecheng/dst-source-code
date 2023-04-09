local assets =
{
    Asset("ANIM", "anim/campfire_fire.zip"),
	Asset("ANIM", "anim/coldfire_fire.zip"),
    Asset("SOUND", "sound/common.fsb"),
}

local prefabs =
{
    "firefx_light",
}

--热火
local heats = { 70, 85, 100, 115 }

local function GetHeatFn(inst)
    return heats[inst.components.firefx.level] or 20
end

local firelevels =
{
    {anim="level1", sound="dontstarve/common/campfire", radius=TUNING_MEDAL.OBSIDIANLIGHT_RADIUS_1, intensity=.8, falloff=.33, colour = {255/255,255/255,192/255}, soundintensity=.1},
    {anim="level2", sound="dontstarve/common/campfire", radius=TUNING_MEDAL.OBSIDIANLIGHT_RADIUS_2, intensity=.8, falloff=.33, colour = {255/255,255/255,192/255}, soundintensity=.3},
    {anim="level3", sound="dontstarve/common/campfire", radius=TUNING_MEDAL.OBSIDIANLIGHT_RADIUS_3, intensity=.8, falloff=.33, colour = {255/255,255/255,192/255}, soundintensity=.6},
    {anim="level4", sound="dontstarve/common/campfire", radius=TUNING_MEDAL.OBSIDIANLIGHT_RADIUS_4, intensity=.8, falloff=.33, colour = {255/255,255/255,192/255}, soundintensity=1},
}

--冷火
local cold_heats = { -10, -20, -30, -40 }
local function GetColdHeatFn(inst)
    return cold_heats[inst.components.firefx.level] or -20
end

local firelevels_cold=
{
	{ anim = "level1", sound = "dontstarve_DLC001/common/coldfire", radius = TUNING_MEDAL.OBSIDIANLIGHT_RADIUS_1, intensity = .8, falloff = .33, colour = { 0, 183 / 255, 1 }, soundintensity = .1 },
	{ anim = "level2", sound = "dontstarve_DLC001/common/coldfire", radius = TUNING_MEDAL.OBSIDIANLIGHT_RADIUS_2, intensity = .8, falloff = .33, colour = { 0, 183 / 255, 1 }, soundintensity = .3 },
	{ anim = "level3", sound = "dontstarve_DLC001/common/coldfire", radius = TUNING_MEDAL.OBSIDIANLIGHT_RADIUS_3, intensity = .8, falloff = .33, colour = { 0, 183 / 255, 1 }, soundintensity = .6 },
	{ anim = "level4", sound = "dontstarve_DLC001/common/coldfire", radius = TUNING_MEDAL.OBSIDIANLIGHT_RADIUS_4, intensity = .8, falloff = .33, colour = { 0, 183 / 255, 1 }, soundintensity = 1 },
}

local function normal_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("campfire_fire")
    inst.AnimState:SetBuild("campfire_fire")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetFinalOffset(-1)

    inst:AddTag("FX")

    --HASHEATER (from heater component) added to pristine state for optimization
    inst:AddTag("HASHEATER")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("heater")
    inst.components.heater.heatfn = GetHeatFn

    inst:AddComponent("firefx")
    inst.components.firefx.levels = firelevels
    inst.components.firefx:SetLevel(1)
    inst.components.firefx.usedayparamforsound = true

    return inst
end

local function cold_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("coldfire_fire")
    inst.AnimState:SetBuild("coldfire_fire")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetFinalOffset(-1)

    inst:AddTag("FX")

    --HASHEATER (from heater component) added to pristine state for optimization
    inst:AddTag("HASHEATER")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("heater")
    inst.components.heater.heatfn = GetColdHeatFn
    inst.components.heater:SetThermics(false, true)

    inst:AddComponent("firefx")
    inst.components.firefx.levels =firelevels_cold
    inst.components.firefx:SetLevel(1)
    inst.components.firefx.usedayparamforsound = true

    return inst
end

return Prefab("medal_obsidianfirefire", normal_fn, assets, prefabs),
	Prefab("medal_obsidiancoldfirefire", cold_fn, assets, prefabs)
