local assets = {
    Asset("ANIM", "anim/ndnr_stinkytofu.zip"),
    Asset("IMAGE", "images/ndnr_stinkytofu.tex"),
    Asset("ATLAS", "images/ndnr_stinkytofu.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_stinkytofu.xml", 256),
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("ndnr_stinkytofu")
    inst.AnimState:SetBank("ndnr_stinkytofu")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst:AddTag("ndnr_darkcuisine")

    inst.entity:SetPristine()
    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_stinkytofu.xml"

    inst:AddComponent("tradable")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.VEGGIE
    inst.components.edible.hungervalue = TUNING.CALORIES_LARGE
    inst.components.edible.healthvalue = TUNING.HEALING_MEDSMALL
    inst.components.edible.sanityvalue = TUNING.SANITY_LARGE

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("ndnr_stinkytofu", fn, assets)
