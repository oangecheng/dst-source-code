AddPrefabPostInit("dragonfly", function(inst)
    if inst.components.lootdropper then
        inst.components.lootdropper:AddChanceLoot("ndnr_dragoonheart", 1.0)
    end
end)

AddPrefabPostInit("lavae", function(inst)
    if inst.components.lootdropper then
        inst.components.lootdropper:AddChanceLoot("ndnr_dragoonheart", 0.1)
    end
end)
