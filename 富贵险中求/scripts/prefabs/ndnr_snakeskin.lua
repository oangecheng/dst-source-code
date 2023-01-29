local assets=
{
	Asset("ANIM", "anim/ndnr_snakeskin.zip"),
	Asset("IMAGE", "images/ndnr_snakeskin.tex"),
    Asset("ATLAS", "images/ndnr_snakeskin.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_snakeskin.xml", 256),
}

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("snakeskin")
    inst.AnimState:SetBuild("ndnr_snakeskin")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)

    ---------------------

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_snakeskin.xml"

    -- inst:AddComponent("appeasement")
    -- inst.components.appeasement.appeasementvalue = TUNING.APPEASEMENT_TINY

	--inst:ListenForEvent("burnt", function(inst) inst.entity:Retire() end)

    return inst
end

return Prefab( "ndnr_snakeskin", fn, assets)

