local assets =
{
    Asset("ANIM", "anim/medal_withered_royaljelly.zip"),
    Asset("ATLAS", "images/medal_withered_royaljelly.xml"),
	Asset("ATLAS_BUILD", "images/medal_withered_royaljelly.xml",256),
}

local prefabs =
{
    "spoiled_food",
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("medal_withered_royaljelly")
    inst.AnimState:SetBank("medal_withered_royaljelly")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("honeyed")

    MakeInventoryFloatable(inst, "small", nil, 0.8)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")--蜂王浆的三倍属性
    inst.components.edible.healthvalue = TUNING.HEALING_LARGE*2
    inst.components.edible.hungervalue = TUNING.CALORIES_SMALL*3
    inst.components.edible.sanityvalue = TUNING.SANITY_MED*3

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("tradable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "medal_withered_royaljelly"
	inst.components.inventoryitem.atlasname = "images/medal_withered_royaljelly.xml"

    inst:AddComponent("inspectable")

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("medal_withered_royaljelly", fn, assets, prefabs)