local function spawnsnake(inst, target)
    if math.random() < 1/3 and inst.components.pickable and inst.components.pickable:CanBePicked() then
        local snake = inst.components.childspawner:SpawnChild()
        if snake then
            local spawnpos = Vector3(inst.Transform:GetWorldPosition())
            spawnpos = spawnpos + TheCamera:GetDownVec()
            snake.Transform:SetPosition(spawnpos:Get())
            if snake and target and snake.components.combat then
                snake.components.combat:SetTarget(target)
            end
        end
    end
end

local function onplayernear(inst, player)
    spawnsnake(inst, player)
end

local function IsCaveDay(inst)
    if not TheWorld.state.isday then
        spawnsnake(inst)
    end
end

AddPrefabPostInit("marsh_bush", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    -------------------
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "ndnr_snake"
    inst.components.childspawner:SetRegenPeriod(TUNING.SPIDERDEN_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.SPIDERDEN_RELEASE_TIME)

    -- inst.components.childspawner:SetSpawnedFn(onspawnsnake)
    inst.components.childspawner:SetMaxChildren(1)

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(2, 8)
    inst.components.playerprox:SetOnPlayerNear(onplayernear)
    -- inst.components.playerprox:SetOnPlayerFar(onplayerfar)
    inst.components.playerprox.period = math.random() * 0.16 + 0.32 -- mix it up a little

    inst:WatchWorldState("isnight", IsCaveDay)
    inst:WatchWorldState("iscaveday", IsCaveDay)

end)
