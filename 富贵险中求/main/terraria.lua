local eyes = {"shieldofterror", "eyemaskhat"}
for i, v in ipairs(eyes) do
    local function ndnrrefine(inst)
        if inst.ndnr_refine_status ~= nil and inst.ndnr_refine_status == true then
            inst:AddTag("ndnr_refine")
            inst:RemoveTag("ndnr_canrefine")

            local name = STRINGS.NAMES[string.upper(v)] or ""
            inst.components.named:SetName(TUNING.NDNR_NAME_PREFIX_REFINE .. " " .. name)

            if inst.components.armor ~= nil then
                inst.components.armor.condition = inst.components.armor.condition * 2
                inst.components.armor.maxcondition = inst.components.armor.maxcondition * 2
                inst.components.armor:SetPercent(inst.components.armor.condition/inst.components.armor.maxcondition)
            end
        end
    end
    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then
            return inst
        end

        if not inst.components.named then inst:AddComponent("named") end

        inst.ndnrrefine = ndnrrefine
        inst:DoTaskInTime(FRAMES, ndnrrefine)

        -- load save
        local onsave = inst.OnSave
        inst.OnSave = function(inst, data)
            if onsave then
                onsave(inst, data)
            end
            data.ndnr_refine_status = inst.ndnr_refine_status
        end

        local onload = inst.OnPreLoad
        inst.OnPreLoad = function(inst, data)
            if onload then
                onload(inst, data)
            end
            if data and data.ndnr_refine_status then
                inst.ndnr_refine_status = data.ndnr_refine_status
                if inst.ndnr_refine_status == true then
                    inst:AddTag("ndnr_refine")
                    inst:RemoveTag("ndnr_canrefine")
                end
            end
        end
    end)
end