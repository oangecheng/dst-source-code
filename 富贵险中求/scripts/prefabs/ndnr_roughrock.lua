local assets =
{
    Asset("ANIM", "anim/ndnr_roughrock.zip"),
    Asset("IMAGE", "images/ndnr_roughrock.tex"),
    Asset("ATLAS", "images/ndnr_roughrock.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_roughrock.xml", 256),
}

--[[
    marble

    redgem
    bluegem
    purplegem

    orangegem
    yellowgem
    greengem

    opalpreciousgem
]]
local function on_mine(inst, worker)
    local loots = {}
    local rare = {"orangegem", "yellowgem", "greengem"}
    local normal = {"purplegem"}
    local common = {"redgem", "bluegem"}
    if math.random() < 0.05 then
        table.insert(loots, "opalpreciousgem")
    end
    if math.random() < 0.2 then
        table.insert(loots, rare[math.random(#rare)])
    end
    if math.random() < 0.3 then
        table.insert(loots, normal[math.random(#normal)])
    end
    for i = 1, 2 do
        if math.random() < 0.4 then
            table.insert(loots, common[math.random(#common)])
        end
    end
    if #loots < 3 then
        table.insert(loots, "marble")
        table.insert(loots, "marble")
    end
    if #loots < 4 and math.random() < 0.5 then
        table.insert(loots, common[math.random(#common)])
    end

    for i, v in ipairs(loots) do
        LaunchAt(SpawnPrefab(v), inst, worker, TUNING.ROCK_FRUIT_LOOT.SPEED, TUNING.ROCK_FRUIT_LOOT.HEIGHT, nil, TUNING.ROCK_FRUIT_LOOT.ANGLE)
    end
    inst.components.stackable:Get():Remove()
end

local function stack_size_changed(inst, data)
    if data ~= nil and data.stacksize ~= nil and inst.components.workable ~= nil then
        inst.components.workable:SetWorkLeft(9)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("ndnr_roughrock")
    inst.AnimState:SetBuild("ndnr_roughrock")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    inst:AddTag("molebait")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("tradable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    -- The amount of work needs to be updated whenever the size of the stack changes
    inst:ListenForEvent("stacksizechange", stack_size_changed)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(9)
    inst.components.workable:SetOnFinishCallback(on_mine)
    -- inst.components.workable:SetOnWorkCallback(on_mine)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_roughrock.xml"

    inst:AddComponent("bait")
    inst:AddTag("molebait")

    return inst
end

return Prefab("ndnr_roughrock", fn, assets)