local assets=
{
    Asset("ANIM", "anim/ndnr_quackenbeak.zip"),
	Asset("IMAGE", "images/ndnr_quackenbeak.tex"),
    Asset("ATLAS", "images/ndnr_quackenbeak.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_quackenbeak.xml", 256),
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBuild("ndnr_quackenbeak")
    inst.AnimState:SetBank("quackenbeak")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_quackenbeak.xml"

    inst:AddComponent("inspectable")

    return inst
end

return Prefab( "ndnr_quackenbeak", fn, assets)
