local function dofn(inst, doer, target)
    if target.ndnr_experimentfn ~= nil then
        if doer.prefab == "waxwell" or doer.prefab == "wanda" or math.random() < 1/3 then
            local a, b = target.ndnr_experimentfn(target, doer)
            if a then
                -- if target.SoundEmitter ~= nil then
                --     target.SoundEmitter:PlaySound("dontstarve/common/ghost_spawn")
                -- end
                if doer.components.talker ~= nil then
                    if doer.prefab == "wanda" then
                        doer.components.talker:Say(TUNING.NDNR_EXPERIMENT_WANDA_SUCCESS)
                    else
                        doer.components.talker:Say(TUNING.NDNR_EXPERIMENT_SUCCESS)
                    end
                end
            end
            return a, b
        else
            if doer.components.talker ~= nil then
                doer.components.talker:Say(TUNING.NDNR_EXPERIMENT_FAILURE)
            end
            return true
        end
    end
    return false
end

AddPrefabPostInit("shadowheart", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("ndnr_experimentstaff")
    inst.components.ndnr_experimentstaff:SetDoFn(dofn)
end)