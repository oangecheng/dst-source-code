AddPrefabPostInit("mound", function(inst)
    if not TheWorld.ismastersim then return inst end

    if inst.components.workable ~= nil then
        local _onfinish = inst.components.workable.onfinish
        inst.components.workable.onfinish = function(inst, worker)
            _onfinish(inst, worker)
            inst.components.ndnr_pluckable:SetActCondition(false)
            inst.components.ndnr_pluckable:ActionEnable()
        end
    end

    inst:DoTaskInTime(1, function(inst)
        if inst.components.ndnr_pluckable ~= nil then
            inst.components.ndnr_pluckable:SetActCondition(inst.components.workable ~= nil)
            inst.components.ndnr_pluckable:ActionEnable()
        end
    end)

end)