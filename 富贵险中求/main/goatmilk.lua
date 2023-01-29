AddPrefabPostInit("goatmilk", function(inst)

    inst:AddTag("ndnr_milk")

    if not TheWorld.ismastersim then
        return inst
    end

end)