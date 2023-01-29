local PLANT_DEFS = require("prefabs/ndnr_farm_plant_defs").PLANT_DEFS

for k,v in pairs(PLANT_DEFS) do
    AddPrefabPostInit(v.prefab, function(inst)

        inst:AddTag("ndnr_canpluckplant")

        if not TheWorld.ismastersim then
            return inst
        end

        if not inst.components.ndnr_pluckplant then
            inst:AddComponent("ndnr_pluckplant")
        end

        inst:DoTaskInTime(FRAMES, function(inst)
            if inst.components.ndnr_pluckplant then
                if not inst.components.ndnr_pluckplant.canpluck then
                    inst:RemoveTag("ndnr_canpluckplant")
                end
            end
        end)

    end)
end