local assets = {
    Asset("ANIM", "anim/ndnr_iceball.zip"),
    Asset("IMAGE", "images/ndnr_iceball.tex"),
    Asset("ATLAS", "images/ndnr_iceball.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_iceball.xml", 256),
}

local function onfiremelt(inst)
    inst.components.perishable.frozenfiremult = true
end

local function onstopfiremelt(inst)
    inst.components.perishable.frozenfiremult = false
end

local function onuseaswatersource(inst)
    if inst.components.stackable:IsStack() then
        inst.components.stackable:Get():Remove()
    else
        inst:Remove()
    end
end

local function onperish(inst)
    local owner = inst.components.inventoryitem.owner
    if owner ~= nil then
        local stacksize = inst.components.stackable:StackSize()
        if owner.components.moisture ~= nil then
            owner.components.moisture:DoDelta(2 * stacksize)
        elseif owner.components.inventoryitem ~= nil then
            owner.components.inventoryitem:AddMoisture(4 * stacksize)
        end
        inst:Remove()
    else
        local stacksize = inst.components.stackable:StackSize()
		local x, y, z = inst.Transform:GetWorldPosition()
        TheWorld.components.farming_manager:AddSoilMoistureAtPoint(x, y, z, stacksize * TUNING.ICE_MELT_GROUND_MOISTURE_AMOUNT*2)

		inst.persists = false
        inst.components.inventoryitem.canbepickedup = false
        inst.AnimState:PlayAnimation("melt")
        inst:ListenForEvent("animover", inst.Remove)
    end
end

local function on_mine(inst, miner, workleft, workdone)
    local num_fruits_worked = math.clamp(math.ceil(workdone / TUNING.ROCK_FRUIT_MINES), 1, TUNING.ROCK_FRUIT_LOOT.MAX_SPAWNS)
    num_fruits_worked = math.min(num_fruits_worked, inst.components.stackable:StackSize())

    if inst.components.stackable:StackSize() > num_fruits_worked then
        -- inst.AnimState:PlayAnimation("mined")
        -- inst.AnimState:PlayAnimation("idle", false)

        if num_fruits_worked == TUNING.ROCK_FRUIT_LOOT.MAX_SPAWNS then
            -- If we got hit hard, also launch the remaining fruit stack.
            LaunchAt(inst, inst, miner, TUNING.ROCK_FRUIT_LOOT.SPEED, TUNING.ROCK_FRUIT_LOOT.HEIGHT, nil, TUNING.ROCK_FRUIT_LOOT.ANGLE)
        end
    end

    for _ = 1, num_fruits_worked do
        LaunchAt(SpawnPrefab("ice"), inst, miner, TUNING.ROCK_FRUIT_LOOT.SPEED, TUNING.ROCK_FRUIT_LOOT.HEIGHT, nil, TUNING.ROCK_FRUIT_LOOT.ANGLE)
        LaunchAt(SpawnPrefab("ice"), inst, miner, TUNING.ROCK_FRUIT_LOOT.SPEED, TUNING.ROCK_FRUIT_LOOT.HEIGHT, nil, TUNING.ROCK_FRUIT_LOOT.ANGLE)
        if math.random() < 0.5 then
            LaunchAt(SpawnPrefab("ice"), inst, miner, TUNING.ROCK_FRUIT_LOOT.SPEED, TUNING.ROCK_FRUIT_LOOT.HEIGHT, nil, TUNING.ROCK_FRUIT_LOOT.ANGLE)
        end
    end

    -- Finally, remove the actual stack items we just consumed
    local top_stack_item = inst.components.stackable:Get(num_fruits_worked)
    top_stack_item:Remove()
end

local function stack_size_changed(inst, data)
    if data ~= nil and data.stacksize ~= nil and inst.components.workable ~= nil then
        inst.components.workable:SetWorkLeft(data.stacksize * TUNING.ROCK_FRUIT_MINES)
    end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("ndnr_iceball")
    inst.AnimState:SetBank("ndnr_iceball")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst:AddTag("frozen")
    -- From watersource component
    inst:AddTag("watersource")
    inst:AddTag("molebait")

    inst.entity:SetPristine()
    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------

    inst:AddComponent("tradable")
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "GENERIC"
    inst.components.edible.healthvalue = TUNING.HEALING_TINY/2
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY/4
    inst.components.edible.degrades_with_spoilage = false
    inst.components.edible.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
    inst.components.edible.temperatureduration = TUNING.FOOD_TEMP_BRIEF * 1.5

    inst:AddComponent("smotherer")

    inst:ListenForEvent("firemelt", onfiremelt)
    inst:ListenForEvent("stopfiremelt", onstopfiremelt)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_iceball.xml"
    inst.components.inventoryitem:SetOnPickupFn(onstopfiremelt)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERFAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable:SetOnPerishFn(onperish)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.ROCK_FRUIT_MINES * inst.components.stackable.stacksize)
    --inst.components.workable:SetOnFinishCallback(on_mine)
    inst.components.workable:SetOnWorkCallback(on_mine)

    -- The amount of work needs to be updated whenever the size of the stack changes
    inst:ListenForEvent("stacksizechange", stack_size_changed)

    inst:AddComponent("repairer")
    inst.components.repairer.repairmaterial = MATERIALS.ICE
    inst.components.repairer.perishrepairpercent = .1

    inst:AddComponent("watersource")
    inst.components.watersource.onusefn = onuseaswatersource
    inst.components.watersource.override_fill_uses = 1

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("ndnr_iceball", fn, assets)
