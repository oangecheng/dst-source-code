local assets =
{
    Asset("ANIM", "anim/bigtooth.zip"),
    Asset("IMAGE", "images/ndnr_bigtooth.tex"),
    Asset("ATLAS", "images/ndnr_bigtooth.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_bigtooth.xml", 256),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(1.7,1.7,1.7)

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("houndstooth")
    inst.AnimState:SetBuild("hounds_tooth")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_bigtooth.xml"

    inst:AddComponent("selfstacker")

    MakeHauntableLaunchAndSmash(inst)

    return inst
end

return Prefab("ndnr_bigtooth", fn, assets)