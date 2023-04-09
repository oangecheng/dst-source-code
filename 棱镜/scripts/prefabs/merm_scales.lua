local assets =
{
    Asset("ANIM", "anim/merm_scales.zip"),
    Asset("ATLAS", "images/inventoryimages/merm_scales.xml"),
    Asset("IMAGE", "images/inventoryimages/merm_scales.tex"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("merm_scales")
    inst.AnimState:SetBuild("merm_scales")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "med", 0.1, 0.77)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    MakeHauntableLaunchAndIgnite(inst)

    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT * 2

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "merm_scales"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/merm_scales.xml"

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.HORRIBLE

    return inst
end

return Prefab("merm_scales", fn, assets)