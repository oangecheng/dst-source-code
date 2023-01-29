AddPrefabPostInit("gnarwail_horn", function(inst)
    inst._actionstr = "GNARWAIL_HORN"

    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("ndnr_repair")
    inst.components.ndnr_repair:SetAmount(1)
end)