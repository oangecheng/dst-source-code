local assets =
{
    Asset("ANIM", "anim/rain_flower_stone.zip"),
	Asset("ATLAS", "images/inventoryimages/rain_flower_stone.xml"),
    Asset("IMAGE", "images/inventoryimages/rain_flower_stone.tex")
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("rain_flower_stone")
    inst.AnimState:SetBuild("rain_flower_stone")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/rain_flower_stone.xml"
    inst.components.inventoryitem:SetSinks(true)

    inst:AddComponent("tradable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("repair_lg")

    MakeHauntableLaunch(inst)
    return inst
end

return Prefab("rain_flower_stone", fn, assets)
