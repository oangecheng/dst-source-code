local function electrictask(inst, player)
    inst.ndnr_electrictask = inst:DoPeriodicTask(1, function(inst)
        local chance = 0.1
        if TheWorld.state.israining then
            chance = 0.5
        end
        if not player:HasTag("playerghost") and not player.components.inventory:IsInsulated() and
            (inst.components.fueled and not inst.components.fueled:IsEmpty()) and
            math.random() < chance then
            
            if not player.sg:HasStateTag("dead") then
                player.sg:GoToState("electrocute")
            end
            
            if player.components.health then
                player.components.health:DoDelta(player.prefab == "wx78" and 20 or -20, nil, "ndnr_battery", nil, nil, true)
            end
            if player.components.batteryuser then
                player.components.batteryuser:ChargeFrom(inst)
            end
            if player.components.talker then
                player.components.talker:Say(NDNR_ELECTRIC_LEAKAGE)
            end
        end
    end)
end

local function cancelelectrictask(inst)
    if inst.ndnr_electrictask ~= nil then
        inst.ndnr_electrictask:Cancel()
        inst.ndnr_electrictask = nil
    end
end

local batteries = {"winona_battery_low", "winona_battery_high"}
for i, v in pairs(batteries) do
    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("playerprox")
        inst.components.playerprox:SetDist(1.7, 1.7)
        inst.components.playerprox:SetOnPlayerNear(function(inst, player)
            if not player then return end
            electrictask(inst, player)
        end)
        inst.components.playerprox:SetOnPlayerFar(function(inst)
            cancelelectrictask(inst)
        end)

    end)
end