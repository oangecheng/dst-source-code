AddPrefabPostInit("tallbird", function(inst)
    if not TheWorld.ismastersim then return inst end
    
    local old_CanMakeNewHome = inst.CanMakeNewHome
    inst.CanMakeNewHome = function (inst)
        return not inst.ndnr_danger and old_CanMakeNewHome(inst)
    end

    -- load save
    local onsave = inst.OnSave
    inst.OnSave = function(inst, data)
        if onsave then
            onsave(inst, data)
        end
        data.ndnr_danger = inst.ndnr_danger
    end

    local onload = inst.OnPreLoad
    inst.OnPreLoad = function(inst, data)
        if onload then
            onload(inst, data)
        end
        if data and data.ndnr_danger then
            inst.ndnr_danger = data.ndnr_danger
        end
    end
end)