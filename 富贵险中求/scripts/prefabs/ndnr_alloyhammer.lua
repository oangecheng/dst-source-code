local assets =
{
    Asset("ANIM", "anim/ndnr_alloyhammer.zip"),
    Asset("ANIM", "anim/swap_ndnr_alloyhammer.zip"),
    Asset("IMAGE", "images/ndnr_alloyhammer.tex"),
    Asset("ATLAS", "images/ndnr_alloyhammer.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_alloyhammer.xml", 256),
}

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_ndnr_alloyhammer", inst.GUID, "swap_hammer")
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_ndnr_alloyhammer", "swap_hammer")
    end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("ndnr_alloyhammer")
    inst.AnimState:SetBuild("ndnr_alloyhammer")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("hammer")

    -- MakeInventoryFloatable(inst, "med", 0.05, {0.7, 0.4, 0.7}, true, -13, {sym_build = "swap_ndnr_alloyhammer"})
    MakeInventoryFloatable(inst)

    --tool (from tool component) added to pristine state for optimization
    inst:AddTag("tool")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    -- inst:AddTag("canrepairbyndnr_iron")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.HAMMER_DAMAGE)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_alloyhammer.xml"
    -----
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.HAMMER)
    -------
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.HAMMER_USES)
    inst.components.finiteuses:SetUses(TUNING.HAMMER_USES)

    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetConsumption(ACTIONS.HAMMER, 1/3)
    -------

    MakeHauntableLaunch(inst)

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    return inst
end

return Prefab("ndnr_alloyhammer", fn, assets)
