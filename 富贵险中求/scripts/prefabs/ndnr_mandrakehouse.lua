local assets = {
    Asset("ANIM", "anim/ndnr_elderdrake_house.zip"),
    -- Asset("MINIMAP_IMAGE", "elderdrake_house"),

    Asset("ATLAS", "images/ndnr_mandrakehouse.xml"),
    Asset("IMAGE", "images/ndnr_mandrakehouse.tex"),
}

local prefabs = {"ndnr_mandrakeman"}

local function getstatus(inst)
    if inst:HasTag("burnt") then
        return "BURNT"
    elseif inst.components.spawner and inst.components.spawner:IsOccupied() then
        if inst.lightson then
            return "FULL"
        end
    end
end

local function onoccupied(inst, child)
    -- inst.SoundEmitter:PlaySound("dontstarve/pig/pig_in_hut", "pigsound")
    -- inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
end

local function onvacate(inst, child)
    -- inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
    -- inst.SoundEmitter:KillSound("pigsound")
    if not inst:HasTag("burnt") then
        if child then
            if child.components.health then
                child.components.health:SetPercent(1)
            end
        end
    end
end

local function onhammered(inst, worker)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end
    if inst.components.spawner then
        inst.components.spawner:ReleaseChild()
    end
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle")
    end
end

local function Empty(inst)
    if not inst:HasTag("burnt") then
        if inst.components.spawner:IsOccupied() then
            if inst.doortask then
                inst.doortask:Cancel()
                inst.doortask = nil
            end
            inst.doortask = inst:DoTaskInTime(1 + math.random() * 2, function(inst)
                inst.components.spawner:ReleaseChild()
            end)
        end
    end
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle")
    inst.SoundEmitter:PlaySound("dontstarve/common/rabbit_hutch_craft")
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("ndnr_mandrakehouse.tex")

    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(1)
    inst.Light:Enable(false)
    inst.Light:SetColour(180 / 255, 195 / 255, 50 / 255)

    MakeObstaclePhysics(inst, 1)

    inst.AnimState:SetBank("elderdrake_house")
    inst.AnimState:SetBuild("ndnr_elderdrake_house")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("structure")

    MakeSnowCoveredPristine(inst)
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("spawner")
    WorldSettings_Spawner_SpawnDelay(inst, TUNING.TOTAL_DAY_TIME, true)
    inst.components.spawner:Configure("ndnr_mandrakeman", TUNING.TOTAL_DAY_TIME)
    inst.components.spawner.onoccupied = onoccupied
    inst.components.spawner.onvacate = onvacate
    inst.components.spawner:SetWaterSpawning(false, true)
    -- inst.components.spawner:CancelSpawning()

    inst:WatchWorldState("iscaveday", Empty)
    inst:WatchWorldState("isnight", Empty)

    inst:AddComponent("inspectable")

    inst.components.inspectable.getstatus = getstatus

    inst:ListenForEvent("burntup", function(inst)
        if inst.doortask then
            inst.doortask:Cancel()
            inst.doortask = nil
        end
    end)
    inst:ListenForEvent("onignite", function(inst)
        if inst.components.spawner then
            inst.components.spawner:ReleaseChild()
        end
    end)

    MakeSnowCovered(inst)

    inst.OnSave = onsave
    inst.OnLoad = onload

    inst:ListenForEvent("onbuilt", onbuilt)
    inst:DoTaskInTime(math.random(), function()
        if not TheWorld.state.isday then
            Empty(inst)
        end
    end)

    return inst
end

return Prefab("ndnr_mandrakehouse", fn, assets, prefabs),
    MakePlacer("ndnr_mandrakehouse_placer", "elderdrake_house", "ndnr_elderdrake_house", "idle")
