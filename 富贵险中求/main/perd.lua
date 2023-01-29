AddPrefabPostInit("perd", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    if inst.components.timer == nil then
        inst:AddComponent("timer")
    end

    inst.components.timer:StartTimer("ndnr_perdspawneggtimer", TUNING.TOTAL_DAY_TIME + math.random(240))
    inst:ListenForEvent("timerdone", function(inst, data)
        if data.name == "ndnr_perdspawneggtimer" then
            inst.components.lootdropper:SpawnLootPrefab("bird_egg", inst:GetPosition())
            inst.components.timer:StartTimer("ndnr_perdspawneggtimer", TUNING.TOTAL_DAY_TIME + math.random(240))
        end
    end)
end)