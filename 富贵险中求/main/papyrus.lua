AddPrefabPostInit("papyrus", function(inst)
    inst:AddTag("ndnr_paper")

    if not TheWorld.ismastersim then
        return inst
    end

    if not inst.components.ndnr_rubbing then
        inst:AddComponent("ndnr_rubbing")
    end
end)
