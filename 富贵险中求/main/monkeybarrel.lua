AddPrefabPostInit("monkeybarrel", function(inst)
    if not TheWorld.ismastersim then return inst end

    if inst.components.lootdropper then
        inst:RemoveComponent("lootdropper")
        inst:AddComponent("lootdropper")
    end
end)