local function TemperatureChange(inst, data)
    local cur_temp = inst.components.temperature:GetCurrent()

    if cur_temp <= 0 then
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
        local holder = owner ~= nil and (owner.components.inventory or owner.components.container) or nil
        if holder ~= nil then
            local slot = holder:GetItemSlot(inst)
            local goop = SpawnPrefab("ndnr_iceball")
            if goop.components.stackable ~= nil and inst.components.stackable ~= nil then
                goop.components.stackable:SetStackSize(inst.components.stackable.stacksize)
            end
            local x, y, z = inst.Transform:GetWorldPosition()
            goop.Transform:SetPosition(x, y, z)
            holder:GiveItem(goop, slot)

            inst:Remove()
        end
    end
end

AddPrefabPostInit("waterballoon", function(inst)

    inst:AddTag("icebox_valid")
    inst:AddTag("ndnr_waterballoon")

    if not TheWorld.ismastersim then
        return inst
    end

    if inst.components.wateryprotection then
        inst.components.wateryprotection:AddIgnoreTag("ndnr_waterballoon")
    end

    if not inst.components.temperature then
        inst:AddComponent("temperature")
    end
    inst.components.temperature.current = 20
    inst.components.temperature.inherentinsulation = TUNING.INSULATION_SMALL
    inst.components.temperature.inherentsummerinsulation = TUNING.INSULATION_SMALL
    inst.components.temperature:IgnoreTags("ndnr_waterballoon")

    inst:ListenForEvent("temperaturedelta", TemperatureChange)

    if inst.components.complexprojectile then
        local old_onlaunchfn = inst.components.complexprojectile.onlaunchfn
        inst.components.complexprojectile:SetOnLaunch(function(inst)
            old_onlaunchfn(inst)

            if inst.components.temperature then
                inst:RemoveComponent("temperature")
            end
        end)
    end
end)
