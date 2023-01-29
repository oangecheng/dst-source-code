AddPrefabPostInit("dragonflychest", function(inst)
    inst:AddTag("ndnr_dragonflychest")

    if not TheWorld.ismastersim then return inst end
end)