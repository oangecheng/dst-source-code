for i, v in ipairs(TUNING.NDNR_SMELTER_INGREDIENT) do
    AddPrefabPostInit(v, function(inst)
        inst:AddTag("ndnr_canrefine")

        if not TheWorld.ismastersim then return inst end
    end)
end