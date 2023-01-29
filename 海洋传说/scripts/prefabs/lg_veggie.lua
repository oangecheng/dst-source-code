
local litichiassets =
{
    Asset("ANIM", "anim/lg_litichi.zip"),
    Asset("ATLAS", "images/inventoryimages/lg_litichi.xml"),
    Asset("ATLAS", "images/inventoryimages/lg_litichi_cooked.xml"),
}

local lemonassets =
{
    Asset("ANIM", "anim/lg_lemon.zip"),
    Asset("ATLAS", "images/inventoryimages/lg_lemon.xml"),
    Asset("ATLAS", "images/inventoryimages/lg_lemon_cooked.xml"),
}

local actinineassets =
{
    Asset("ANIM", "anim/lg_actinine.zip"),
    Asset("ATLAS", "images/inventoryimages/lg_actinine.xml"),
    Asset("ATLAS", "images/inventoryimages/lg_actinine_cooked.xml"),
}


local function common(data)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
    inst.AnimState:SetBank(data.bank)
    inst.AnimState:SetBuild(data.build)
    inst.AnimState:PlayAnimation(data.anim)

    if data.tags ~= nil then
        for i, v in ipairs(data.tags) do
            inst:AddTag(v)
        end
    end
    if data.dryable ~= nil then
        inst:AddTag("dryable")
        inst:AddTag("lureplant_bait")
    end

    if data.cookable ~= nil then
        inst:AddTag("cookable")
    end

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.foodtype = data.FOODTYPE or  FOODTYPE.MEAT

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("tradable")

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(data.perishtime or TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    if data.dryable ~= nil and data.dryable.product ~= nil then
        inst:AddComponent("dryable")
        inst.components.dryable:SetProduct(data.dryable.product)
        inst.components.dryable:SetDryTime(data.dryable.time)
		inst.components.dryable:SetBuildFile(data.dryable.build)
        inst.components.dryable:SetDriedBuildFile(data.dryable.dried_build)
    end

    if data.cookable ~= nil then
        inst:AddComponent("cookable")
        inst.components.cookable.product = data.cookable.product
    end
    MakeHauntableLaunchAndPerish(inst)

    return inst
end

local function litichi()
    local inst = common({
        bank = "lg_litichi",
        build = "lg_litichi",
        anim = "idle",
        FOODTYPE  = FOODTYPE.VEGGIE,
        perishtime = TUNING.PERISH_FASTISH,
        cookable = {product = "lg_litichi_cooked"}
    }
    )
    if not TheWorld.ismastersim then
        return inst
    end
    inst.components.edible.healthvalue = 1
    inst.components.edible.hungervalue = 9.4
    inst.components.edible.sanityvalue = 2
    inst.components.inventoryitem.atlasname = "images/inventoryimages/lg_litichi.xml"
    return inst
end
local function litichi_cooked()
    local inst = common({
        bank = "lg_litichi",
        build = "lg_litichi",
        anim = "cooked",
        FOODTYPE  = FOODTYPE.VEGGIE,
        perishtime = TUNING.PERISH_MED/2,
    }
    )
    if not TheWorld.ismastersim then
        return inst
    end
    inst.components.edible.healthvalue = 1
    inst.components.edible.hungervalue = 6
    inst.components.edible.sanityvalue = 3
    inst.components.inventoryitem.atlasname = "images/inventoryimages/lg_litichi_cooked.xml"
    return inst
end
local function lemon()
    local inst = common({
        bank = "lg_lemon",
        build = "lg_lemon",
        anim = "idle",
        FOODTYPE  = FOODTYPE.VEGGIE,
        perishtime = TUNING.PERISH_FAST,
        cookable = {product = "lg_lemon_cooked"}
    }
    )
    if not TheWorld.ismastersim then
        return inst
    end
    inst.components.edible.healthvalue = -5
    inst.components.edible.hungervalue = 12.5
    inst.components.edible.sanityvalue = 5
    inst.components.inventoryitem.atlasname = "images/inventoryimages/lg_lemon.xml"
    return inst
end
local function lemon_cooked()
    local inst = common({
        bank = "lg_lemon",
        build = "lg_lemon",
        anim = "cooked",
        FOODTYPE  = FOODTYPE.VEGGIE,
        perishtime = TUNING.PERISH_MED/2,
    }
    )
    if not TheWorld.ismastersim then
        return inst
    end
    inst.components.edible.healthvalue = 1
    inst.components.edible.hungervalue = 2
    inst.components.edible.sanityvalue = -1
    inst.components.inventoryitem.atlasname = "images/inventoryimages/lg_lemon_cooked.xml"
    return inst
end
local function actinine()
    local inst = common({
        bank = "lg_actinine",
        build = "lg_actinine",
        anim = "idle",
        FOODTYPE  = FOODTYPE.VEGGIE,
        perishtime = TUNING.PERISH_FAST, --保质期
        cookable = {product = "lg_actinine_cooked"}
    }
    )
    if not TheWorld.ismastersim then
        return inst
    end
    inst.components.edible.healthvalue = -5 --三维
    inst.components.edible.hungervalue = 25
    inst.components.edible.sanityvalue = -5
    inst.components.inventoryitem.atlasname = "images/inventoryimages/lg_actinine.xml"
    return inst
end
local function actinine_cooked()
    local inst = common({
        bank = "lg_actinine",
        build = "lg_actinine",
        anim = "cooked",
        FOODTYPE  = FOODTYPE.VEGGIE,
        perishtime = TUNING.PERISH_MED/2, --保质期
    }
    )
    if not TheWorld.ismastersim then
        return inst
    end
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 30
    inst.components.edible.sanityvalue = 5
    inst.components.inventoryitem.atlasname = "images/inventoryimages/lg_actinine_cooked.xml"
    return inst
end
return Prefab("lg_litichi", litichi, litichiassets),
    Prefab("lg_litichi_cooked", litichi_cooked),
    Prefab("lg_lemon", lemon, lemonassets),
    Prefab("lg_lemon_cooked", lemon_cooked),
    Prefab("lg_actinine", actinine, actinineassets),
    Prefab("lg_actinine_cooked", actinine_cooked)