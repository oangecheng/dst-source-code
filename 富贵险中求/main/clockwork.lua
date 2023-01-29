local clockworks = {"knight", "bishop", "rook", "knight_nightmare", "rook_nightmare", "bishop_nightmare"}

for i, v in ipairs(clockworks) do
    AddPrefabPostInit(v, function(inst)
        if not inst.components.talker then
            inst:AddComponent("talker")
        end
        if not TheWorld.ismastersim then return inst end

        inst:AddComponent("playerprox")
        inst.components.playerprox:SetTargetMode(inst.components.playerprox.TargetModes.AllPlayers)
        inst.components.playerprox:SetDist(10, 13)
        inst.components.playerprox:SetOnPlayerNear(function(inst, player)
            if not player then return end
            local gender = GetGender(player.prefab)
            if gender and gender == "ROBOT" and inst.components.talker then
                inst.components.talker:Say(NDNR_CLOCKWORK_HELLO[math.random(#NDNR_CLOCKWORK_HELLO)])
            end
        end)
        inst.components.playerprox:SetOnPlayerFar(function(inst, player)
            if not player then return end
            local gender = GetGender(player.prefab)
            if gender and gender == "ROBOT" and inst.components.talker then
                inst.components.talker:Say(NDNR_CLOCKWORK_BYE[math.random(#NDNR_CLOCKWORK_BYE)])
            end
        end)

    end)
end