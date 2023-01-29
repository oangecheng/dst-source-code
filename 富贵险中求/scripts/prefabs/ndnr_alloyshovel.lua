local assets =
{
    Asset("ANIM", "anim/ndnr_alloyshovel.zip"),
    Asset("ANIM", "anim/swap_ndnr_alloyshovel.zip"),
    Asset("IMAGE", "images/ndnr_alloyshovel.tex"),
    Asset("ATLAS", "images/ndnr_alloyshovel.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_alloyshovel.xml", 256),
}

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_ndnr_alloyshovel", inst.GUID, "swap_shovel")
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_ndnr_alloyshovel", "swap_shovel")
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

local function common_fn(bank, build, atlasname)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("idle")

    --tool (from tool component) added to pristine state for optimization
    inst:AddTag("tool")
    -- inst:AddTag("canrepairbyndnr_iron")

    if TheNet:GetServerGameMode() ~= "quagmire" then
        --weapon (from weapon component) added to pristine state for optimization
        inst:AddTag("weapon")
    end

    -- MakeInventoryFloatable(inst, "med", 0.05, {0.8, 0.4, 0.8})
    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -----
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.DIG)

    if TheNet:GetServerGameMode() ~= "quagmire" then
        -------
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(TUNING.SHOVEL_USES)
        inst.components.finiteuses:SetUses(TUNING.SHOVEL_USES)
        inst.components.finiteuses:SetOnFinished(inst.Remove)
        inst.components.finiteuses:SetConsumption(ACTIONS.DIG, 1)

        -------
        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(TUNING.SHOVEL_DAMAGE)
    end

    inst:AddInherentAction(ACTIONS.DIG)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/"..atlasname..".xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

local function normal()
    local inst = common_fn("ndnr_alloyshovel", "ndnr_alloyshovel", "ndnr_alloyshovel")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.finiteuses:SetConsumption(ACTIONS.DIG, 1 / (TUNING.MULTIPLAYER_GOLDENTOOL_MODIFIER*8))
    inst.components.weapon.attackwear = 1 / (TUNING.MULTIPLAYER_GOLDENTOOL_MODIFIER*8)

    -- inst.components.floater:SetBankSwapOnFloat(true, 7, {sym_build = "swap_ndnr_alloyshovel"})

    return inst
end

return Prefab("ndnr_alloyshovel", normal, assets)
