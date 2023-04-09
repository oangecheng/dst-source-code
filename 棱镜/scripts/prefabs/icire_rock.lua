local assets =
{
    Asset("ANIM", "anim/icire_rock.zip"),
    Asset("ATLAS", "images/inventoryimages/icire_rock.xml"),
    Asset("IMAGE", "images/inventoryimages/icire_rock.tex"),
    Asset("ATLAS", "images/inventoryimages/icire_rock1.xml"),
    Asset("IMAGE", "images/inventoryimages/icire_rock1.tex"),
    Asset("ATLAS", "images/inventoryimages/icire_rock2.xml"),
    Asset("IMAGE", "images/inventoryimages/icire_rock2.tex"),
    Asset("ATLAS", "images/inventoryimages/icire_rock3.xml"),
    Asset("IMAGE", "images/inventoryimages/icire_rock3.tex"),
    Asset("ATLAS", "images/inventoryimages/icire_rock4.xml"),
    Asset("IMAGE", "images/inventoryimages/icire_rock4.tex"),
    Asset("ATLAS", "images/inventoryimages/icire_rock5.xml"),
    Asset("IMAGE", "images/inventoryimages/icire_rock5.tex"),
    Asset("ANIM", "anim/heat_rock.zip"), --官方热能石动画模板
}

local prefabs =
{
    "heatrocklight",
}

local function OnRemove(inst)
    inst._light:Remove()
end

-- These represent the boundaries between the ranges (relative to ambient, so ambient is always "0")
local relative_temperature_thresholds = { -30, -10, 10, 30 }

local function GetRangeForTemperature(temp, ambient)
    local range = 1
    for i,v in ipairs(relative_temperature_thresholds) do
        if temp > ambient + v then
            range = range + 1
        end
    end
    return range
end

-- Heatrock emits constant temperatures depending on the temperature range it's in
local emitted_temperatures = { -10, 10, 25, 40, 60 }

local function HeatFn(inst, observer)
    local range = GetRangeForTemperature(inst.components.temperature:GetCurrent(), TheWorld.state.temperature)
    if range <= 2 then
        inst.components.heater:SetThermics(false, true)
    elseif range >= 4 then
        inst.components.heater:SetThermics(true, false)
    else
        inst.components.heater:SetThermics(false, false)
    end
    return emitted_temperatures[range]
end

local function GetStatus(inst)
    if inst.currentTempRange == 1 then
        return "FROZEN"
    elseif inst.currentTempRange == 2 then
        return "COLD"
    elseif inst.currentTempRange == 4 then
        return "WARM"
    elseif inst.currentTempRange == 5 then
        return "HOT"
    end
end

local function UpdateImages(inst, range)
    inst.currentTempRange = range
    inst.AnimState:PlayAnimation(tostring(range), true)

    local canbloom = true
    local newname = "icire_rock"..tostring(range)
    if inst._dd then
        newname = newname..inst._dd.img_pst
        inst.components.inventoryitem.atlasname = "images/inventoryimages_skin/"..newname..".xml"
        inst.components.inventoryitem:ChangeImageName(newname)
        canbloom = inst._dd.canbloom
        if inst._dd.fn_temp then
            inst._dd.fn_temp(inst, range)
        end
    else
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..newname..".xml"
        inst.components.inventoryitem:ChangeImageName(newname)
    end

    --最冷与最热都会发光
    if range == 1 then
        inst._light.Light:SetColour(64/255, 64/255, 208/255)
        inst._light.Light:Enable(true)
    elseif range == 5 then
        inst._light.Light:SetColour(235/255, 165/255, 12/255)
        inst._light.Light:Enable(true)
    else
        canbloom = false
        inst._light.Light:Enable(false)
    end
    if canbloom then
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    else
        inst.AnimState:ClearBloomEffectHandle()
    end
end

local function AdjustLighting(inst, range, ambient)
    if range == 1 then
        local relativetemp = ambient - inst.components.temperature:GetCurrent() --目前的温差
        local baseline = relativetemp - relative_temperature_thresholds[4]      --温差与30度的差距
        local brightline = relative_temperature_thresholds[4] + 20
        inst._light.Light:SetIntensity(math.clamp(0.5 * baseline / brightline, 0, 0.5)) --clamp()函数用于控制结果在0到0.5之间
    elseif range == 5 then
        local relativetemp = inst.components.temperature:GetCurrent() - ambient --目前的温差
        local baseline = relativetemp - relative_temperature_thresholds[4]      --温差与30度的差距
        local brightline = relative_temperature_thresholds[4] + 20
        inst._light.Light:SetIntensity(math.clamp(0.5 * baseline / brightline, 0, 0.5))
    else
        inst._light.Light:SetIntensity(0)
    end
end

local function TemperatureChange(inst, data)
    local ambient_temp = TheWorld.state.temperature
    local range = GetRangeForTemperature(inst.components.temperature:GetCurrent(), ambient_temp)

    AdjustLighting(inst, range, ambient_temp)

    if range ~= inst.currentTempRange then
        UpdateImages(inst, range)
    end
end

local function OnOwnerChange(inst)
    local newowners = {}
    local owner = inst
    while owner.components.inventoryitem ~= nil do
        newowners[owner] = true

        if inst._owners[owner] then
            inst._owners[owner] = nil
        else
            inst:ListenForEvent("onputininventory", inst._onownerchange, owner)
            inst:ListenForEvent("ondropped", inst._onownerchange, owner)
        end

        local nextowner = owner.components.inventoryitem.owner
        if nextowner == nil then
            break
        end

        owner = nextowner
    end

    inst._light.entity:SetParent(owner.entity)

    for k, v in pairs(inst._owners) do
        if k:IsValid() then
            inst:RemoveEventCallback("onputininventory", inst._onownerchange, k)
            inst:RemoveEventCallback("ondropped", inst._onownerchange, k)
        end
    end

    inst._owners = newowners
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("heat_rock")
    inst.AnimState:SetBuild("heat_rock")
    inst.AnimState:OverrideSymbol("rock", "icire_rock", "rock")
    inst.AnimState:OverrideSymbol("shadow", "icire_rock", "shadow")

    inst:AddTag("heatrock")
    inst:AddTag("icebox_valid")
    inst:AddTag("bait")
    inst:AddTag("molebait") --吸引鼹鼠
    inst:AddTag("NORATCHECK") --mod兼容：永不妥协。该道具不算鼠潮分

    --HASHEATER (from heater component) added to pristine state for optimization
    inst:AddTag("HASHEATER")

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:Init("icire_rock")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "icire_rock"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/icire_rock.xml"
    inst.components.inventoryitem:SetSinks(true) --它是热能石的浓缩版，应该要沉入水底

    inst:AddComponent("tradable")
    inst.components.tradable.rocktribute = 10 --延缓 0.33x10 天地震
    inst.components.tradable.goldvalue = 7 --换1个砂之石或7金块

    inst:AddComponent("temperature")
    inst.components.temperature.current = TheWorld.state.temperature
    inst.components.temperature.inherentinsulation = TUNING.INSULATION_MED
    inst.components.temperature.inherentsummerinsulation = TUNING.INSULATION_MED
    inst.components.temperature:IgnoreTags("heatrock")

    inst:AddComponent("heater")
    inst.components.heater.heatfn = HeatFn
    inst.components.heater.carriedheatfn = HeatFn
    inst.components.heater.carriedheatmultiplier = TUNING.HEAT_ROCK_CARRIED_BONUS_HEAT_FACTOR
    inst.components.heater:SetThermics(false, false)

    -- inst:AddComponent("fueled")
    -- inst.components.fueled.fueltype = FUELTYPE.USAGE
    -- inst.components.fueled:InitializeFuelLevel(100)
    -- inst.components.fueled:SetDepletedFn(inst.Remove)

    inst:ListenForEvent("temperaturedelta", TemperatureChange)
    inst.currentTempRange = 0

    --Create light
    inst._light = SpawnPrefab("heatrocklight")
    inst._owners = {}
    inst._onownerchange = function() OnOwnerChange(inst) end

    inst.fn_temp = function(inst)
        UpdateImages(inst, inst.currentTempRange or 3)
    end
    UpdateImages(inst, 1)
    OnOwnerChange(inst)

    MakeHauntableLaunchAndSmash(inst)

    -- inst.OnSave = OnSave
    -- inst.OnLoad = OnLoad
    inst.OnRemoveEntity = OnRemove

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

return Prefab("icire_rock", fn, assets, prefabs)
