for i,v in ipairs(TUNING.NDNR_CANUPGRADE_BACKPACKS) do
    local function ndnr_makeforeverfresh(inst, doer)
        if inst.ndnr_forever_fresh and inst.ndnr_forever_fresh == true then
            if inst.components.preserver == nil then
                inst:AddComponent("preserver")
            end
            inst.components.preserver:SetPerishRateMultiplier(0)

            inst:RemoveTag("ndnr_canupgrade")

            if inst.components.named ~= nil then
                local name = STRINGS.NAMES[string.upper(inst.prefab)] or ""
                inst.components.named:SetName(TUNING.NDNR_NAME_PREFIX_FOREVER_ICEBOX .. " " .. name)
            end
        end
    end

    AddPrefabPostInit(v, function(inst)
        inst:AddTag("ndnr_canupgrade")
        if not TheWorld.ismastersim then
            return inst
        end

        if not inst.components.named then
            inst:AddComponent("named")
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
