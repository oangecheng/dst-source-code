local assets = {
    Asset("ANIM", "anim/milk.zip"),
    Asset("IMAGE", "images/ndnr_magma_milk_0.tex"), --high
    Asset("ATLAS", "images/ndnr_magma_milk_0.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_magma_milk_0.xml", 256),
    Asset("IMAGE", "images/ndnr_magma_milk_1.tex"), --middle
    Asset("ATLAS", "images/ndnr_magma_milk_1.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_magma_milk_1.xml", 256),
    Asset("IMAGE", "images/ndnr_magma_milk_2.tex"), --low
    Asset("ATLAS", "images/ndnr_magma_milk_2.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_magma_milk_2.xml", 256),
}

local function isOnWater(inst)
    local x,y,z = inst.Transform:GetWorldPosition()
    return TheWorld.Map:IsOceanAtPoint(x,y,z, false)
end

-- local relative_temperature_thresholds = { -30, -10, 10, 30 }
local emitted_temperatures = {20, 40, 60}
local animation_idles = {"low", "medium", "high"}
local function GetRangeForTemperature(temp, ambient)
    -- local range = 1
    -- for i, v in ipairs(relative_temperature_thresholds) do
    --     if temp > ambient + v then
    --         range = range + 1
    --     end
    -- end
    -- return range
    if temp >= 50 then
        return 3
    elseif temp >= 20 and temp < 50 then
        return 2
    elseif temp < 20 then
        return 1
    end
end
local function HeatFn(inst, observer)
    local range = GetRangeForTemperature(inst.components.temperature:GetCurrent(), TheWorld.state.temperature)
    return emitted_temperatures[range]
end

local function UpdateImages(inst, range)
    inst.currentTempRange = range
    inst.AnimState:PlayAnimation(animation_idles[range])
    local invimage = "ndnr_magma_milk_0"
    if range == 1 then
        invimage = "ndnr_magma_milk_2"
    elseif range == 2 then
        invimage = "ndnr_magma_milk_1"
    elseif range == 3 then
        invimage = "ndnr_magma_milk_0"
    end
    inst.components.inventoryitem.atlasname = "images/" .. invimage .. ".xml"
    inst.components.inventoryitem:ChangeImageName(invimage)
end

local function AdjustLighting(inst, range, ambient)
    if inst._light ~= nil and range ~= nil then
        inst._light.Light:SetIntensity( math.clamp(0.8*range/3, 0, 0.8 ) )
        inst._light.Light:SetRadius( math.clamp(3*range/3, 1.5, 3 ) )
    end
end

local function TemperatureChange(inst, data)
    local ambient_temp = TheWorld.state.temperature
    local cur_temp = inst.components.temperature:GetCurrent()
    local range = GetRangeForTemperature(cur_temp, ambient_temp)

    AdjustLighting(inst, range, ambient_temp)

    if cur_temp < 0 and not inst.ndnr_converting then
        inst.ndnr_converting = true
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
        local holder = owner ~= nil and (owner.components.inventory or owner.components.container) or nil

        if holder ~= nil then
            local goop = SpawnPrefab("ndnr_obsidian")
            if goop.components.stackable ~= nil then
                goop.components.stackable:SetStackSize(math.random(1, 2))
            end
            local x, y, z = inst.Transform:GetWorldPosition()
            goop.Transform:SetPosition(x, y, z)

            local slot = holder:GetItemSlot(inst)
            holder:GiveItem(goop, slot)
        else
            if inst.components.lootdropper then
                inst.components.lootdropper:DropLoot(inst:GetPosition())
            end
        end
        inst:Remove()
    end

    if range ~= inst.currentTempRange then
        UpdateImages(inst, range)
    end
end

local function OnSave(inst, data)
    data.currentTempRange = inst.currentTempRange
end

local function OnLoad(inst, data)
    if data ~= nil then
        inst.currentTempRange = data.currentTempRange
    end
end

local function OnRemove(inst)
    inst._light:Remove()
end

local function topocket(inst)
	if inst.components.propagator ~= nil then
	    inst.components.propagator:StopSpreading()
	end
end

local function toground(inst)
	if inst.components.propagator ~= nil then
	    inst.components.propagator:StartSpreading()
	end
    if isOnWater(inst) then
        if inst.components.lootdropper then
            inst.components.lootdropper:DropLoot(inst:GetPosition())
        end
        inst:Remove()
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
            inst:ListenForEvent("onputininventory", topocket)
            inst:ListenForEvent("ondropped", toground)
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
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("milk")
    inst.AnimState:SetBank("magma_milk")
    inst.AnimState:PlayAnimation("high")

    MakeInventoryFloatable(inst)

    inst:AddTag("cooker")
    inst:AddTag("magma_milk")

    inst.entity:SetPristine()
    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("cooker")
    inst:AddComponent("propagator")
    inst.components.propagator.heatoutput = 15
    inst.components.propagator.spreading = true
    inst.components.propagator:StartUpdating()

    inst.components.inventoryitem.atlasname = "images/ndnr_magma_milk_0.xml"
    inst.components.inventoryitem.imagename = "ndnr_magma_milk_0"

    inst:AddComponent("temperature")
    inst.components.temperature.current = 90
    inst.components.temperature.inherentinsulation = TUNING.INSULATION_MED * 2
    inst.components.temperature.inherentsummerinsulation = TUNING.INSULATION_MED * 2
    inst.components.temperature:IgnoreTags("magma_milk")

    inst:AddComponent("heater")
    inst.components.heater.heatfn = HeatFn
    inst.components.heater.carriedheatfn = HeatFn
    inst.components.heater.carriedheatmultiplier = TUNING.HEAT_ROCK_CARRIED_BONUS_HEAT_FACTOR
    inst.components.heater:SetThermics(true, false)

    inst:AddComponent("lootdropper")
	inst.components.lootdropper:AddRandomLoot("ndnr_obsidian", 1.00)
	inst.components.lootdropper.numrandomloot = math.random(2, 3)

    inst:ListenForEvent("temperaturedelta", TemperatureChange)
    inst.currentTempRange = 1

    -- Create light
    inst._light = SpawnPrefab("ndnr_magma_milk_light")
    inst._owners = {}
    inst._onownerchange = function()
        OnOwnerChange(inst)
    end
    --

    UpdateImages(inst, 3)
    OnOwnerChange(inst)

    MakeHauntableLaunch(inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnRemoveEntity = OnRemove

    return inst
end

local function lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    -- heatrock
    inst.Light:SetRadius(2)
    inst.Light:SetFalloff(0.6)
    inst.Light:SetIntensity(0.8)
    inst.Light:SetColour(235/255, 165/255, 12/255)

    -- minerhat
    -- inst.Light:SetFalloff(0.4)
    -- inst.Light:SetIntensity(0.7)
    -- inst.Light:SetRadius(2.5)
    -- inst.Light:SetColour(180 / 255, 195 / 255, 150 / 255)

    inst.Light:Enable(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = true

    return inst
end

return Prefab("ndnr_magma_milk", fn, assets, prefabs),
    Prefab("ndnr_magma_milk_light", lightfn)
