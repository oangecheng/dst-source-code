local assets =
{
    Asset("ANIM", "anim/swap_parasol_palmleaf.zip"),
    Asset("ANIM", "anim/parasol_palmleaf.zip"),
    Asset("IMAGE", "images/ndnr_palmleaf_umbrella.tex"),
    Asset("ATLAS", "images/ndnr_palmleaf_umbrella.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_palmleaf_umbrella.xml", 256),
}

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_parasol_palmleaf", inst.GUID, "swap_parasol_palmleaf")
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_parasol_palmleaf", "swap_parasol_palmleaf")
    end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    owner.DynamicShadow:SetSize(1.7, 1)
end

local function onunequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end

    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    owner.DynamicShadow:SetSize(1.3, 0.6)
end

local function onperish(inst)
    local equippable = inst.components.equippable
    if equippable ~= nil and equippable:IsEquipped() then
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
        if owner ~= nil then
            local data =
            {
                prefab = inst.prefab,
                equipslot = equippable.equipslot,
            }
            inst:Remove()
            owner:PushEvent("umbrellaranout", data)
            return
        end
    end
    inst:Remove()
end

local function common_fn(name)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(name)
    inst.AnimState:SetBuild(name)
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("nopunch")
    inst:AddTag("umbrella")


    --waterproofer (from waterproofer component) added to pristine state for optimization
    inst:AddTag("waterproofer")

    MakeInventoryFloatable(inst, "large")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("tradable")

    inst:AddComponent("waterproofer")
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_palmleaf_umbrella.xml"

    inst:AddComponent("equippable")

    inst:AddComponent("insulator")
    inst.components.insulator:SetSummer()

    MakeHauntableLaunch(inst)

    return inst
end

local function palmleaf()
    local inst = common_fn("parasol_palmleaf")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.GRASS_UMBRELLA_PERISHTIME)
    inst.components.perishable:StartPerishing()
    inst.components.perishable:SetOnPerishFn(onperish)
    inst:AddTag("show_spoilage")

    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_MED)

    inst.components.insulator:SetInsulation(TUNING.INSULATION_MED)

    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL

    local swap_data = {sym_build = "swap_parasol_palmleaf", bank = "swap_parasol_palmleaf"}
    inst.components.floater:SetBankSwapOnFloat(true, -40, swap_data)
    inst.components.floater:SetVerticalOffset(0.05)
    inst.components.floater:SetScale({0.9, 0.4, 0.9})

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    return inst
end

return Prefab("ndnr_palmleaf_umbrella", palmleaf, assets)
