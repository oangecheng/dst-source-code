local spores = {"spore_small", "spore_medium", "spore_tall"}
for i, v in ipairs(spores) do
    AddPrefabPostInit(v, function(inst)
        inst:AddTag(v.."_fuel")
        if not TheWorld.ismastersim then return inst end

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = .5
        inst.components.fuel.fueltype = TUNING.NDNR_FUELTYPE.SPORE
    end)
end