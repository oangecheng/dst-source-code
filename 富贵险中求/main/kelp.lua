AddPrefabPostInit("kelp", function(inst)
    inst._actionstr = "KELP"

    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("ndnr_repair")
    inst.components.ndnr_repair:SetAmount(1/10)
end)