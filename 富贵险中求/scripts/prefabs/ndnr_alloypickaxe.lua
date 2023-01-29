local assets =
{
    Asset("ANIM", "anim/ndnr_alloypickaxe.zip"),
    Asset("ANIM", "anim/swap_ndnr_alloypickaxe.zip"),
    Asset("IMAGE", "images/ndnr_alloypickaxe.tex"),
    Asset("ATLAS", "images/ndnr_alloypickaxe.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_alloypickaxe.xml", 256),
}

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_ndnr_alloypickaxe", inst.GUID, "swap_pickaxe")
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_ndnr_alloypickaxe", "swap_pickaxe")
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

local function common_fn(bank, build, effectiveness, atlasname)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")

    --tool (from tool component) added to pristine state for optimization
    inst:AddTag("tool")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    -- inst:AddTag("canrepairbyndnr_iron")

    -- MakeInventoryFloatable(inst, "med", 0.05, {0.75, 0.4, 0.75})
    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -----
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.MINE, effectiveness)

    -------
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.PICKAXE_USES)
    inst.components.finiteuses:SetUses(TUNING.PICKAXE_USES)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetConsumption(ACTIONS.MINE, effectiveness or 1)

    -------
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.PICK_DAMAGE)

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
    local inst = common_fn("ndnr_alloypickaxe", "ndnr_alloypickaxe", 2.5, "ndnr_alloypickaxe")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 1 / (TUNING.MULTIPLAYER_GOLDENTOOL_MODIFIER*5))
    inst.components.weapon.attackwear = 1 / (TUNING.MULTIPLAYER_GOLDENTOOL_MODIFIER*5)

    -- inst.components.floater:SetBankSwapOnFloat(true, -11, {sym_build = "swap_ndnr_alloypickaxe"})

    return inst
end

return Prefab("ndnr_alloypickaxe", normal, assets)