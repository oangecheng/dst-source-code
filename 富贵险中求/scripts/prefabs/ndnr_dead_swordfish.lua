local assets = {
    Asset("ANIM", "anim/fish_swordfish.zip"),
    Asset("IMAGE", "images/ndnr_dead_swordfish.tex"),
    Asset("ATLAS", "images/ndnr_dead_swordfish.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_dead_swordfish.xml", 256),
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("fish_swordfish")
    inst.AnimState:SetBank("swordfish")
    inst.AnimState:PlayAnimation("dead")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()
    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst.components.inventoryitem.atlasname = "images/ndnr_dead_swordfish.xml"

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.MEAT

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_fish"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    MakeHauntableLaunch(inst)

    return inst
end
return Prefab("ndnr_dead_swordfish", fn, assets)
