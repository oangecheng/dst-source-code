for k, v in pairs(require("prefabs/oceanfishdef").fish) do
    AddPrefabPostInit(v.prefab .. "_inv", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end

        if inst.components.lootdropper then
            inst.components.lootdropper:AddChanceLoot("ndnr_roe_"..v.prefab, 0.5)
        end
    end)
end