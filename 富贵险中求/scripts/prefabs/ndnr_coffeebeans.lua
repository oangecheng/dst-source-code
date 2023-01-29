local assets = {
    Asset("ANIM", "anim/coffeebeans.zip"),
    Asset("IMAGE", "images/ndnr_coffeebeans.tex"),
    Asset("ATLAS", "images/ndnr_coffeebeans.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_coffeebeans.xml", 256),
}

local cooked_assets = {
    Asset("ANIM", "anim/coffeebeans.zip"),
    Asset("IMAGE", "images/ndnr_coffeebeans_cooked.tex"),
    Asset("ATLAS", "images/ndnr_coffeebeans_cooked.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_coffeebeans_cooked.xml", 256),
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryFloatable(inst)
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("coffeebeans")
    inst.AnimState:SetBank("coffeebeans")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("cookable")
    inst:AddTag("catfood")

    inst.entity:SetPristine()

    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then return inst end
    --------------------------------------------------------------------------
    inst:AddComponent("tradable")
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_coffeebeans.xml"
    inst.components.inventoryitem.imagename = "ndnr_coffeebeans"

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.SEEDS
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY
    inst.components.edible.healthvalue = 0
    inst.components.edible.sanityvalue = 0

    inst:AddComponent("cookable")
    inst.components.cookable.product = "ndnr_coffeebeans_cooked"

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    MakeHauntableLaunch(inst)

    return inst
end

local function fn_cooked()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBuild("coffeebeans")
    inst.AnimState:SetBank("coffeebeans")
    inst.AnimState:PlayAnimation("cooked")

    inst.entity:SetPristine()

    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then return inst end
    --------------------------------------------------------------------------
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_coffeebeans_cooked.xml"
    inst.components.inventoryitem.imagename = "ndnr_coffeebeans_cooked"

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.SEEDS
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY
    inst.components.edible.healthvalue = 0
    inst.components.edible.sanityvalue = -TUNING.SANITY_TINY

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    MakeHauntableLaunch(inst)

    return inst
end
return Prefab("ndnr_coffeebeans", fn, assets),
    Prefab("ndnr_coffeebeans_cooked", fn_cooked, cooked_assets)
