

local function makeemptyfn(inst)
    if POPULATING then
        inst.AnimState:PlayAnimation("2idle", true)
        inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
    elseif inst:HasTag("withered") or inst.AnimState:IsCurrentAnimation("1idle") then
        inst.AnimState:PlayAnimation("1to2")
        inst.AnimState:PushAnimation("2idle")
    else
        inst.AnimState:PushAnimation("2idle")
    end
end

local function makebarrenfn(inst)--, wasempty)
    inst.AnimState:PlayAnimation("1idle",true)
end

local function onpickedfn(inst, picker)
    if inst.components.pickable ~= nil then
        if inst.components.pickable:IsBarren() then
            inst.AnimState:PlayAnimation("3to1")
            inst.AnimState:PushAnimation("1idle")
        else
            inst.AnimState:PlayAnimation("2idle",true)
        end
        if math.random() < 0.05 then
            inst.components.lootdropper:SpawnLootPrefab("dug_"..inst.prefab)
        end
    end
end

local function makefullfn(inst)
    local anim = "3idle"
    if inst.components.pickable ~= nil then 
        if inst.components.pickable:IsBarren() then
            anim = "1idle"
        end
    end
    if anim ~= "3idle" then
        inst.AnimState:PlayAnimation(anim)
    elseif POPULATING then
        inst.AnimState:PlayAnimation("3idle", true)
        inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
    else
        inst.AnimState:PlayAnimation("2to3")
        inst.AnimState:PushAnimation("3idle")
    end
end

local function dig_up_common(inst, worker, numberries)
    if inst.components.pickable ~= nil and inst.components.lootdropper ~= nil then
        local withered = inst.components.witherable ~= nil and inst.components.witherable:IsWithered()
        if withered or inst.components.pickable:IsBarren() then
            inst.components.lootdropper:SpawnLootPrefab("twigs")
            inst.components.lootdropper:SpawnLootPrefab("twigs")
        else
            if inst.components.pickable:CanBePicked() then
                local pt = inst:GetPosition()
                pt.y = pt.y + (inst.components.pickable.dropheight or 0)
                for i = 1, numberries do
                    inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product, pt)
                end
            end
            inst.components.lootdropper:SpawnLootPrefab("dug_"..inst.prefab)
        end
    end
    inst:Remove()
end

local function dig_up_normal(inst, worker)
    dig_up_common(inst, worker, 1)
end
local function ontransplantfn(inst)
    inst.AnimState:PlayAnimation("1idle",true)
    inst.components.pickable:MakeBarren()
end

local function OnHaunt(inst)
    return false
end

local function createbush(name, master_postinit)
    local assets =
    {
        Asset("ANIM", "anim/"..name..".zip"),
    }

    local prefabs =
    {
        "dug_"..name,
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()

        MakeSmallObstaclePhysics(inst, .1)

        inst:AddTag("bush")
        inst:AddTag("plant")
        inst:AddTag("renewable")

        inst:AddTag("witherable")
        inst:AddTag(name)

        inst.MiniMapEntity:SetIcon(name..".tex")

        inst.AnimState:SetBank(name)
        inst.AnimState:SetBuild(name)
        inst.AnimState:PlayAnimation("3idle", true)

        MakeSnowCoveredPristine(inst)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())

        inst:AddComponent("pickable")
        inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"
        inst.components.pickable.onpickedfn = onpickedfn
        inst.components.pickable.makeemptyfn = makeemptyfn
        inst.components.pickable.makebarrenfn = makebarrenfn
        inst.components.pickable.makefullfn = makefullfn
        inst.components.pickable.ontransplantfn = ontransplantfn

        inst:AddComponent("witherable")

        MakeLargeBurnable(inst)
        MakeMediumPropagator(inst)

        MakeHauntableIgnite(inst)
        AddHauntableCustomReaction(inst, OnHaunt, false, false, true)

        inst:AddComponent("lootdropper")

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetWorkLeft(1)

        inst:AddComponent("inspectable")

        MakeSnowCovered(inst)
        MakeNoGrowInWinter(inst)

        master_postinit(inst)

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

local function normal_postinit(inst)
    inst.components.pickable:SetUp("lg_lemon", 4*480,2)
    inst.components.pickable.max_cycles = 5
    inst.components.pickable.cycles_left = inst.components.pickable.max_cycles

    if inst.components.workable ~= nil then
        inst.components.workable:SetOnFinishCallback(dig_up_normal)
    end
end

local function make_plantable(data)
    local bank = data.bank or data.name
    local assets =
    {
        Asset("ANIM", "anim/"..bank..".zip"),
        Asset("ATLAS", "images/inventoryimages/dug_"..data.name..".xml"),
    }

    local function ondeploy(inst, pt, deployer)
        local tree = SpawnPrefab(data.name)
        if tree ~= nil then
            tree.Transform:SetPosition(pt:Get())
            inst.components.stackable:Get():Remove()
            if tree.components.pickable ~= nil then
                tree.components.pickable:OnTransplant()
            end
            if deployer ~= nil and deployer.SoundEmitter ~= nil then
                deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
            end
        end
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        --inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst:AddTag("deployedplant")

        inst.AnimState:SetBank(data.bank or data.name)
        inst.AnimState:SetBuild(data.build or data.name)
        inst.AnimState:PlayAnimation("dropped")

        if data.floater ~= nil then
            MakeInventoryFloatable(inst, data.floater[1], data.floater[2], data.floater[3])
        else
            MakeInventoryFloatable(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

        inst:AddComponent("inspectable")
        inst.components.inspectable.nameoverride = data.inspectoverride or ("dug_"..data.name)
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/dug_"..data.name..".xml"

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

        MakeMediumBurnable(inst, TUNING.LARGE_BURNTIME)
        MakeSmallPropagator(inst)

        MakeHauntableLaunchAndIgnite(inst)

        inst:AddComponent("deployable")
        --inst.components.deployable:SetDeployMode(DEPLOYMODE.ANYWHERE)
        inst.components.deployable.ondeploy = ondeploy
        inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
        if data.mediumspacing then
            inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)
        end
        return inst
    end

    return Prefab("dug_"..data.name, fn, assets)
end
return createbush("lg_lemon_tree",  normal_postinit),
        make_plantable({name = "lg_lemon_tree"}),
        MakePlacer("dug_lg_lemon_tree_placer", "lg_lemon_tree", "lg_lemon_tree", "1idle")
