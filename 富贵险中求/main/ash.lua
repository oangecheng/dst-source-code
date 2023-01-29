local FERTILIZER_DEFS = require("prefabs/fertilizer_nutrient_defs").FERTILIZER_DEFS

AddPrefabPostInit("ash", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    if not inst.components.fertilizer then
        inst:AddComponent("fertilizer")
    end
    inst.components.fertilizer.fertilizervalue = TUNING.POOP_FERTILIZE
    inst.components.fertilizer.soil_cycles = TUNING.POOP_SOILCYCLES
    inst.components.fertilizer.withered_cycles = TUNING.POOP_WITHEREDCYCLES
    inst.components.fertilizer:SetNutrients(FERTILIZER_DEFS.poop.nutrients)
end)