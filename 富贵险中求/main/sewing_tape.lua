AddPrefabPostInit("sewing_tape", function(inst)
    inst:AddTag("stopbleeding")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("ndnr_stopbleeding")
end)