--------------------------------------------------------------------------
--[[ 孢子云相关特效 ]]
--------------------------------------------------------------------------

local assets_cloud =
{
    Asset("ANIM", "anim/sleepcloud.zip"),
    Asset("ANIM", "anim/sporecloud_base.zip"),
    Asset("ANIM", "anim/albicanscloud_fx.zip"),
}

local prefabs_cloud =
{
    "albicanscloud_overlay_fx",
}

local OVERLAY_COORDS =
{
    { 0,0,0,               1 },
    { 5/2,0,0,             0.8, 0 },
    { 2.5/2,0,-4.330/2,    0.8 , 5/3*180 },
    { -2.5/2,0,-4.330/2,   0.8, 4/3*180 },
    { -5/2,0,0,            0.8, 3/3*180 },
    { 2.5/2,0,4.330/2,     0.8, 1/3*180 },
    { -2.5/2,0,4.330/2,    0.8, 2/3*180 },
}

local function SpawnOverlayFX(inst, i, set, isnew)
    if i ~= nil then
        inst._overlaytasks[i] = nil
        if next(inst._overlaytasks) == nil then
            inst._overlaytasks = nil
        end
    end

    local fx = SpawnPrefab("albicanscloud_overlay_fx")
    fx.entity:SetParent(inst.entity)
    fx.Transform:SetPosition(set[1] * .85, 0, set[3] * .85)
    fx.Transform:SetScale(set[4], set[4], set[4])
    if set[5] ~= nil then
        fx.Transform:SetRotation(set[4])
    end

    if inst.specialcolor ~= nil then
        fx.AnimState:SetMultColour(inst.specialcolor.r, inst.specialcolor.g, inst.specialcolor.b, 1)
    end
    if not isnew then
        fx.AnimState:PlayAnimation("sleepcloud_overlay_loop")
        fx.AnimState:SetTime(math.random() * .7)
    end

    if inst._overlayfx == nil then
        inst._overlayfx = { fx }
    else
        table.insert(inst._overlayfx, fx)
    end
end

local function CreateBase(isnew)
    local inst = CreateEntity()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.AnimState:SetBank("sporecloud_base")
    inst.AnimState:SetBuild("sporecloud_base")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetFinalOffset(-1)
    inst.AnimState:SetMultColour(0.45, 0.45, 0.45, 0.6)

    if isnew then
        inst.AnimState:PlayAnimation("sporecloud_base_pre")
        inst.AnimState:SetTime(12 * FRAMES)
        inst.AnimState:PushAnimation("sporecloud_base_idle", false)
    else
        inst.AnimState:PlayAnimation("sporecloud_base_idle")
    end

    return inst
end

local function OnStateDirty(inst)
    if inst._state:value() > 0 then
        if inst._inittask ~= nil then
            inst._inittask:Cancel()
            inst._inittask = nil
        end
        if inst._state:value() == 1 then
            if inst._basefx == nil then
                inst._basefx = CreateBase(false)
                inst._basefx.entity:SetParent(inst.entity)
            end
        elseif inst._basefx ~= nil then
            inst._basefx.AnimState:PlayAnimation("sporecloud_base_pst")
        end
    end
end

local function OnAnimOver(inst)
    inst:RemoveEventCallback("animover", OnAnimOver)
    inst._state:set(1)
end

local function OnOverlayAnimOver(fx)
    fx.AnimState:PlayAnimation("sleepcloud_overlay_loop")
end

local function KillOverlayFX(fx)
    fx:RemoveEventCallback("animover", OnOverlayAnimOver)
    fx.AnimState:PlayAnimation("sleepcloud_overlay_pst")
end

local function DoDisperse(inst)
    if inst._inittask ~= nil then
        inst._inittask:Cancel()
        inst._inittask = nil
    end

    inst:RemoveEventCallback("animover", OnAnimOver)
    inst._state:set(2)

    inst.AnimState:PlayAnimation("sleepcloud_pst")
    inst.SoundEmitter:KillSound("spore_loop")
    inst:DoTaskInTime(3, inst.Remove) --anim len + 1.5 sec

    if inst._basefx ~= nil then
        inst._basefx.AnimState:PlayAnimation("sporecloud_base_pst")
    end

    if inst._overlaytasks ~= nil then
        for k, v in pairs(inst._overlaytasks) do
            v:Cancel()
        end
        inst._overlaytasks = nil
    end
    if inst._overlayfx ~= nil then
        for i, v in ipairs(inst._overlayfx) do
            v:DoTaskInTime(i == 1 and 0 or math.random() * .5, KillOverlayFX)
        end
    end
end

local function OnTimerDone(inst, data)
    if data.name == "disperse" then
        DoDisperse(inst)
    end
end

local function InitFX(inst)
    inst._inittask = nil

    --Dedicated server does not need to spawn the local fx
    if not TheNet:IsDedicated() then
        inst._basefx = CreateBase(true)
        inst._basefx.entity:SetParent(inst.entity)
    end
end

local function CloudFn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("sleepcloud")
    inst.AnimState:SetBuild("albicanscloud_fx")
    inst.AnimState:PlayAnimation("sleepcloud_pre")

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("notarget")

    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/spore_cloud_LP", "spore_loop")

    inst._state = net_tinybyte(inst.GUID, "sleepcloud._state", "statedirty")

    inst._inittask = inst:DoTaskInTime(0, InitFX)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("statedirty", OnStateDirty)

        return inst
    end

    inst.specialcolor = nil
    local rand = math.random()
    if rand < 0.1 then
        inst.specialcolor = { r = 237/255, g = 170/255, b = 165/255 }
    elseif rand < 0.2 then
        inst.specialcolor = { r = 172/255, g = 237/255, b = 165/255 }
    elseif rand < 0.3 then
        inst.specialcolor = { r = 165/255, g = 187/255, b = 237/255 }
    end
    if inst.specialcolor ~= nil then
        inst.AnimState:SetMultColour(inst.specialcolor.r, inst.specialcolor.g, inst.specialcolor.b, 1)
    end

    inst.AnimState:PushAnimation("sleepcloud_loop", true)
    inst:ListenForEvent("animover", OnAnimOver)

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("disperse", TUNING.SLEEPBOMB_DURATION)
    inst:ListenForEvent("timerdone", OnTimerDone)

    inst._overlaytasks = {}
    for i, v in ipairs(OVERLAY_COORDS) do
        inst._overlaytasks[i] = inst:DoTaskInTime(i == 1 and 0 or math.random() * .7, SpawnOverlayFX, i, v, true)
    end

    inst.persists = false

    return inst
end

local function CloudOverlayFn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.Transform:SetTwoFaced()

    inst.AnimState:SetBank("sleepcloud")
    inst.AnimState:SetBuild("albicanscloud_fx")
    inst.AnimState:PlayAnimation("sleepcloud_overlay_pre")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("animover", OnOverlayAnimOver)

    inst.persists = false

    return inst
end

---------------

return Prefab("albicanscloud_fx", CloudFn, assets_cloud, prefabs_cloud),
    Prefab("albicanscloud_overlay_fx", CloudOverlayFn, assets_cloud, nil)
