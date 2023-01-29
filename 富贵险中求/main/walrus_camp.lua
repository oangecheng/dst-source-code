local function OnSeason(inst, season)
    if inst.components.ndnr_pluckable then
        if (season and season == "winter") then
            inst.components.ndnr_pluckable:SetActCondition(true)
            inst.components.ndnr_pluckable:ActionEnable()
        else
            inst.components.ndnr_pluckable:SetActCondition(false)
            inst.components.ndnr_pluckable:ActionEnable()
        end
    end
end

AddPrefabPostInit("walrus_camp", function(inst)
    if not TheWorld.ismastersim then return inst end

    inst:DoTaskInTime(FRAMES, function(inst) OnSeason(inst, TheWorld.state.season) end)
    inst:WatchWorldState("season", OnSeason)
end)