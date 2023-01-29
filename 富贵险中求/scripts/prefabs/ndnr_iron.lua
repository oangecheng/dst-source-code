local assets =
{
    Asset("ANIM", "anim/ndnr_iron.zip"),
    Asset("IMAGE", "images/ndnr_iron.tex"),
    Asset("ATLAS", "images/ndnr_iron.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_iron.xml", 256),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("ndnr_iron")
    inst.AnimState:SetBuild("ndnr_iron")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    inst:AddTag("molebait")
    -- inst:AddTag("ndnr_repair_ndnr_iron")

    inst._actionstr = "IRON"

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
    inst.components.edible.hungervalue = 1
    inst:AddComponent("tradable")

    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_iron.xml"

    -- inst:AddComponent("ndnr_repair")
    -- inst.components.ndnr_repair:SetAmount(1/3)

    inst:AddComponent("bait")
    inst:AddTag("molebait")

    return inst
end

return Prefab("ndnr_iron", fn, assets)