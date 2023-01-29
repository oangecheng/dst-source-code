for i, v in ipairs(TUNING.CANBERUBBING_BUILDS) do
    AddPrefabPostInit(v, function(inst)

        inst:AddTag("ndnr_canberubbing")

        if not TheWorld.ismastersim then
            return inst
        end
    end)
end

