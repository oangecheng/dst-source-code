AddPrefabPostInit("gravestone", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    if not inst.components.ndnr_hoverer then
        inst:AddComponent("ndnr_hoverer")
    end
end)