local assets=
{
	Asset("ANIM", "anim/alloy.zip"),
    Asset("IMAGE", "images/ndnr_alloy.tex"),
    Asset("ATLAS", "images/ndnr_alloy.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_alloy.xml", 256),
}

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	inst.entity:AddPhysics()
    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

	inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )

    inst.AnimState:SetBank("alloy")
    inst.AnimState:SetBuild("alloy")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("ndnr_canrefine")
    inst:AddTag("molebait")
    inst:AddTag("scarerbait")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "ELEMENTAL"
    inst.components.edible.hungervalue = 2
    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    inst:AddComponent("stackable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_alloy.xml"

    inst:AddComponent("bait")

    return inst
end

return Prefab("ndnr_alloy", fn, assets)
