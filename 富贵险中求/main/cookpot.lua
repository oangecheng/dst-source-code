AddPrefabPostInit("archive_cookpot", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    if inst.components.stewer then
        inst.components.stewer.cooktimemult = TUNING.PORTABLE_COOK_POT_TIME_MULTIPLIER
    end
end)