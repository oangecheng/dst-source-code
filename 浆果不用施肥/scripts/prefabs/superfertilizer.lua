local assets =
{
    Asset("ANIM", "anim/superfertilizer.zip"),
	Asset("ATLAS", "images/inventoryimages/superfertilizer.xml"),
	Asset("IMAGE", "images/inventoryimages/superfertilizer.tex")
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("superfertilizer")
    inst.AnimState:SetBuild("superfertilizer")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("fertilizer")
    inst.components.fertilizer.fertilizervalue = TUNING.SUPERFERTILIZER_FERTILIZE
    inst.components.fertilizer.soil_cycles = TUNING.SUPERFERTILIZER_SOILCYCLES
    inst.components.fertilizer.withered_cycles = TUNING.SUPERFERTILIZER_WITHEREDCYCLES
	
	inst:AddComponent("superfert")

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/superfertilizer.xml"
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("superfertilizer", fn, assets)