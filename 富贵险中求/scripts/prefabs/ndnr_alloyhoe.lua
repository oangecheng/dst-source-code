local assets =
{
    Asset("ANIM", "anim/ndnr_alloyhoe.zip"),
    Asset("ANIM", "anim/swap_ndnr_alloyhoe.zip"),
    Asset("IMAGE", "images/ndnr_alloyhoe.tex"),
    Asset("ATLAS", "images/ndnr_alloyhoe.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_alloyhoe.xml", 256),
}

local prefabs =
{
    "farm_soil",
}

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_quagmire_hoe", inst.GUID, "quagmire_hoe")
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_ndnr_alloyhoe", "swap_quagmire_hoe")
    end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onfiniteusesfinished(inst)
    if inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner ~= nil then
        inst.components.inventoryitem.owner:PushEvent("toolbroke", { tool = inst })
    end

    inst:Remove()
end

local function common_fn(build)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(build)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", 0.05, {0.8, 0.4, 0.8})

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.FARM_HOE_USES)
    inst.components.finiteuses:SetUses(TUNING.FARM_HOE_USES)
    inst.components.finiteuses:SetOnFinished(onfiniteusesfinished)
    inst.components.finiteuses:SetConsumption(ACTIONS.TILL, 1)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.FARM_HOE_DAMAGE)

    inst:AddInherentAction(ACTIONS.TILL)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/"..build..".xml"

    inst:AddComponent("farmtiller")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

local function fn()
    local inst = common_fn("ndnr_alloyhoe")

    if not TheWorld.ismastersim then
        return inst
    end

    -- inst.components.finiteuses:SetConsumption(ACTIONS.TILL, 1 / TUNING.GOLDENTOOLFACTOR)
    -- inst.components.weapon.attackwear = 1 / TUNING.GOLDENTOOLFACTOR

    -- inst.components.floater:SetBankSwapOnFloat(true, -7, {bank  = "quagmire_hoe", sym_build = "quagmire_hoe", sym_name = "swap_quagmire_hoe"})

	return inst
end

return Prefab("ndnr_alloyhoe", fn, assets, prefabs)
