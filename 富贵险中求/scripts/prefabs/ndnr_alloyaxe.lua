local assets =
{
    Asset("ANIM", "anim/ndnr_alloyaxe.zip"),
    Asset("ANIM", "anim/swap_ndnr_alloyaxe.zip"),
    Asset("IMAGE", "images/ndnr_alloyaxe.tex"),
    Asset("ATLAS", "images/ndnr_alloyaxe.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_alloyaxe.xml", 256),
}

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_ndnr_alloyaxe", inst.GUID, "swap_axe")
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_ndnr_alloyaxe", "swap_axe")
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

local function common_fn(bank, build, effectiveness, imagename)
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
    inst:AddTag("possessable_axe")
    -- inst:AddTag("canrepairbyndnr_iron")

    --tool (from tool component) added to pristine state for optimization
    inst:AddTag("tool")

    if TheNet:GetServerGameMode() ~= "quagmire" then
        --weapon (from weapon component) added to pristine state for optimization
        inst:AddTag("weapon")
    end

    -- MakeInventoryFloatable(inst, "small", 0.05, {1.2, 0.75, 1.2})
    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/"..imagename..".xml"
    -----
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, effectiveness or 1)

    if TheNet:GetServerGameMode() ~= "quagmire" then
        -------
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(TUNING.AXE_USES)
        inst.components.finiteuses:SetUses(TUNING.AXE_USES)
        inst.components.finiteuses:SetOnFinished(inst.Remove)
        inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)

        -------
        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(TUNING.AXE_DAMAGE)
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")

    inst.components.equippable:SetOnEquip(onequip)

    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

local function normal()
    local inst = common_fn("ndnr_alloyaxe", "ndnr_alloyaxe", 2.5, "ndnr_alloyaxe")

    if not TheWorld.ismastersim then
        return inst
    end

    if inst.components.finiteuses ~= nil then
		inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1 / (TUNING.MULTIPLAYER_GOLDENTOOL_MODIFIER*5))
	end

    if inst.components.weapon ~= nil then
	    inst.components.weapon.attackwear = 1 / (TUNING.MULTIPLAYER_GOLDENTOOL_MODIFIER*5)
	end

    -- inst.components.floater:SetBankSwapOnFloat(true, -11, {sym_build = "swap_ndnr_alloyaxe"})

    return inst
end

return Prefab("ndnr_alloyaxe", normal, assets)