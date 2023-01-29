local assets =
{
    Asset("ANIM", "anim/ndnr_waterballoon.zip")
}

local function PlaySound(inst, sound)
    inst.SoundEmitter:PlaySound(sound)
end

local function startfx(proxy)
    local inst = CreateEntity("ndnr_waterballoon_splash")

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    local parent = proxy.entity:GetParent()
    if parent ~= nil then
        inst.entity:SetParent(parent.entity)
    end

    inst:AddTag("FX")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.Transform:SetFromProxy(proxy.GUID)

    inst.entity:AddSoundEmitter()
    inst:DoTaskInTime(0, PlaySound, "dontstarve/creatures/pengull/splash")

    inst.AnimState:SetBank("waterballoon")
    inst.AnimState:SetBuild("ndnr_waterballoon")
    inst.AnimState:PlayAnimation(FunctionOrValue("used")) -- THIS IS A CLIENT SIDE FUNCTION
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    --Dedicated server does not need to spawn the local fx
    if not TheNet:IsDedicated() then
        --Delay one frame so that we are positioned properly before starting the effect
        --or in case we are about to be removed
        inst:DoTaskInTime(0, startfx, inst)
    end

    inst:AddTag("FX")
    inst.persists = false
    inst:ListenForEvent("animover", function()
        if inst.bloom then inst.AnimState:ClearBloomEffectHandle() end
        inst:Remove()
    end)

    return inst
end

return Prefab("ndnr_waterballoon_splash", fn, assets)