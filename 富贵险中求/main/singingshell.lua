local catcoons = {"singingshell_octave3", "singingshell_octave4", "singingshell_octave5"}
for i,v in pairs(catcoons) do
    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then
            return inst
        end

        if inst.components.lootdropper then
            inst.components.lootdropper:AddChanceLoot("ndnr_scallop", 0.5)
        end

    end)
end