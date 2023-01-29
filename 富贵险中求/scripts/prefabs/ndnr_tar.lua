local itemassets =
{
	Asset("ANIM", "anim/ndnr_tar.zip"),
	Asset("IMAGE", "images/ndnr_tar.tex"),
    Asset("ATLAS", "images/ndnr_tar.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_tar.xml", 256),
}

local function itemfn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("tar")
    inst.AnimState:SetBuild("ndnr_tar")
    inst.AnimState:PlayAnimation("idle")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
    inst.components.fuel.secondaryfueltype = "TAR"

	MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_tar.xml"

    return inst
end

return Prefab( "ndnr_tar", itemfn, itemassets)

