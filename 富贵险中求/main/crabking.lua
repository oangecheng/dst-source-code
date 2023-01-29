AddPrefabPostInit("crabking", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    if inst.components.lootdropper then
        inst.components.lootdropper:AddChanceLoot("ndnr_quackenbeak", 1)
    end
end)