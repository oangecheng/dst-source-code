local assets = {
    Asset("ANIM", "anim/ndnr_soybeanmeal.zip"),
    Asset("IMAGE", "images/ndnr_soybeanmeal.tex"),
    Asset("ATLAS", "images/ndnr_soybeanmeal.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_soybeanmeal.xml", 256),
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("ndnr_soybeanmeal")
    inst.AnimState:SetBank("ndnr_soybeanmeal")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()
    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_soybeanmeal.xml"

    inst:AddComponent("tradable")

    -- inst:AddComponent("edible")
    -- inst.components.edible.foodtype = FOODTYPE.VEGGIE
    -- inst.components.edible.hungervalue = TUNING.CALORIES_LARGE
    -- inst.components.edible.healthvalue = TUNING.HEALING_MEDSMALL
    -- inst.components.edible.sanityvalue = TUNING.SANITY_LARGE

    -- inst:AddComponent("perishable")
    -- inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED)
    -- inst.components.perishable:StartPerishing()
    -- inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("ndnr_soybeanmeal", fn, assets)
