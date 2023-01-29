for i, v in ipairs(TUNING.NDNR_PARASITEFOODS) do
    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then return inst end

        inst:ListenForEvent("oneaten", function(inst, data)
            local eater = data.eater
            if math.random() < 1/3 and not table.contains(TUNING.NDNR_NOT_PARASITEPLAYERS, eater.prefab) and eater:HasTag("player") then
                eater.ndnr_parasite = true
            end
            if eater.ndnr_parasite ~= nil and eater.ndnr_parasite == true then
                if eater.components.talker then
                    eater.components.talker:Say(TUNING.NDNR_PARASITE_EAT_FOODS)
                end
            end
        end)

    end)
end