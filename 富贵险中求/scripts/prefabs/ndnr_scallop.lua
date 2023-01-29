local assets = {
    Asset("ANIM", "anim/ndnr_scallop.zip"),
    Asset("IMAGE", "images/ndnr_scallop.tex"),
    Asset("ATLAS", "images/ndnr_scallop.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_scallop.xml", 256),
}

local cooked_assets = {
    Asset("ANIM", "anim/ndnr_scallop_cooked.zip"),
    Asset("IMAGE", "images/ndnr_scallop_cooked.tex"),
    Asset("ATLAS", "images/ndnr_scallop_cooked.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_scallop_cooked.xml", 256),
}

local function item_oneaten(inst, eater)

end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("ndnr_scallop")
    inst.AnimState:SetBuild("ndnr_scallop")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst:AddTag("meat")
    inst:AddTag("lureplant_bait")
    inst:AddTag("cookable")
    inst:AddTag("rawmeat")
    inst:AddTag("catfood")
    inst:AddTag("fishmeat")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst:AddComponent("inspectable")
    inst:AddComponent("bait")

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("cookable")
    inst.components.cookable.product = "ndnr_scallop_cooked"

    inst:AddComponent("edible")
    inst.components.edible.ismeat = true
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.healthvalue = TUNING.HEALING_MEDSMALL
    inst.components.edible.hungervalue = TUNING.CALORIES_MED
    inst.components.edible:SetOnEatenFn(item_oneaten)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_scallop.xml"

    MakeHauntableLaunchAndPerish(inst)

    return inst
end

local function fn_cooked()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("ndnr_scallop_cooked")
    inst.AnimState:SetBuild("ndnr_scallop_cooked")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst:AddTag("meat")
    inst:AddTag("lureplant_bait")
    inst:AddTag("catfood")
    inst:AddTag("fishmeat")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst:AddComponent("inspectable")
    inst:AddComponent("bait")

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("edible")
    inst.components.edible.ismeat = true
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.healthvalue = TUNING.HEALING_MEDSMALL
    inst.components.edible.hungervalue = TUNING.CALORIES_MED
    inst.components.edible:SetOnEatenFn(item_oneaten)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_scallop_cooked.xml"

    MakeHauntableLaunchAndPerish(inst)

    return inst
end


return Prefab("ndnr_scallop", fn, assets),
    Prefab("ndnr_scallop_cooked", fn_cooked, cooked_assets)
