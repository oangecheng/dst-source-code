local assets=
{
	Asset("ANIM", "anim/ndnr_armor_snakeskin.zip"),
	Asset("IMAGE", "images/ndnr_armor_snakeskin.tex"),
    Asset("ATLAS", "images/ndnr_armor_snakeskin.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_armor_snakeskin.xml", 256),
}

local function onequip(inst, owner)
    owner:AddTag("ndnr_snakefriend")
    owner:AddTag("ndnr_snakeprotect")

    owner.AnimState:OverrideSymbol("swap_body", "ndnr_armor_snakeskin", "swap_body")
    inst.components.fueled:StartConsuming()
end

local function onunequip(inst, owner)
    owner:RemoveTag("ndnr_snakefriend")
    owner:RemoveTag("ndnr_snakeprotect")

    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst.components.fueled:StopConsuming()
end

local function onperish(inst)
	inst:Remove()
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("armor_snakeskin")
    inst.AnimState:SetBuild("ndnr_armor_snakeskin")
    inst.AnimState:PlayAnimation("anim")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_armor_snakeskin.xml"
    -- inst.components.inventoryitem.foleysound = "dontstarve_DLC002/common/foley/snakeskin_jacket"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.ARMOR or EQUIPSLOTS.BODY
    inst.components.equippable.insulated = true

    inst:AddComponent("waterproofer")
    inst.components.waterproofer.effectiveness = TUNING.WATERPROOFNESS_LARGE

    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.TOTAL_DAY_TIME*8)
    inst.components.fueled:SetDepletedFn(onperish)


	inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(TUNING.INSULATION_SMALL)


    return inst
end

return Prefab( "ndnr_armor_snakeskin", fn, assets)
