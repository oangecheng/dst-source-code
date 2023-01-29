for i, v in ipairs(TUNING.NDNR_CANUPGRADE_BOXES) do
    local function ndnr_makeforeverfresh(inst, doer)
        if inst.ndnr_forever_fresh and inst.ndnr_forever_fresh == true then
            if inst.prefab == "icebox" then
                if inst.components.container then
                    inst.components.container:ForEachItem(function(item)
                        if item.components.perishable then
                            item:AddTag("ndnr_frozen")
                            item:AddTag("frozen")
                        end
                    end)
                end
            else
                if inst.components.preserver == nil then
                    inst:AddComponent("preserver")
                end
                inst.components.preserver:SetPerishRateMultiplier(0)
            end

            inst:RemoveTag("ndnr_canupgrade")

            if inst.components.named ~= nil then
                local name = STRINGS.NAMES[string.upper(inst.prefab)] or ""
                inst.components.named:SetName(TUNING.NDNR_NAME_PREFIX_FOREVER_ICEBOX .. " " .. name)
            end
        end
    end
    AddPrefabPostInit(v, function(inst)
        inst:AddTag("ndnr_canupgrade")
        inst:AddTag("ndnr_forgingsound")

        if not TheWorld.ismastersim then
            return inst
        end

        if not inst.components.named then
            inst:AddComponent("named")
        end

        if inst.components.workable then
            local _onfinish = inst.components.workable.onfinish
            inst.components.workable:SetOnFinishCallback(function(inst, worker)
                if inst.ndnr_forever_fresh and inst.ndnr_forever_fresh == true then
                    if inst.components.lootdropper then
                        inst.components.lootdropper:SpawnLootPrefab("ndnr_energy_core", inst:GetPosition())
                    end
                end
                if _onfinish then
                    _onfinish(inst, worker)
                end
            end)
        end

        inst.ndnr_makeforeverfresh = ndnr_makeforeverfresh
        inst:DoTaskInTime(FRAMES, ndnr_makeforeverfresh)

        local onsave = inst.OnSave
        inst.OnSave = function(inst, data)
            if onsave then
                onsave(inst, data)
            end
            data.ndnr_forever_fresh = inst.ndnr_forever_fresh
        end

        local onload = inst.OnLoad
        inst.OnLoad = function(inst, data)
            if onload then
                onload(inst, data)
            end
            if data and data.ndnr_forever_fresh then
                inst.ndnr_forever_fresh = data.ndnr_forever_fresh
            end
        end
    end)
end

AddPrefabPostInit("icebox", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("itemget", function(inst, data)
        local item = data.item
        if inst.ndnr_forever_fresh and inst.ndnr_forever_fresh == true and item.prefab ~= "ice" and item.components.perishable then
            item:AddTag("ndnr_frozen")
            item:AddTag("frozen")
        end
    end)
    inst:ListenForEvent("itemlose", function(inst, data)
        local item = data.prev_item
        if item:HasTag("ndnr_frozen") then
            item:RemoveTag("ndnr_frozen")
            if item.prefab ~= "ice" then
                item:RemoveTag("frozen")
            end
        end
    end)
end)
