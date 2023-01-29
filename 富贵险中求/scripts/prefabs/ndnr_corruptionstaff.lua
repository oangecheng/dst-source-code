local assets = {
    Asset("ANIM", "anim/ndnr_corruptionstaff.zip"),
    Asset("ANIM", "anim/swap_ndnr_corruptionstaff.zip"),
    Asset("IMAGE", "images/ndnr_corruptionstaff.tex"),
    Asset("ATLAS", "images/ndnr_corruptionstaff.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_corruptionstaff.xml", 256),
}

local function updatefuel(inst)
    if inst.components.fueled:GetPercent() >= .1 then
        inst:RemoveTag("ndnr_nomagic")
    else
        inst:AddTag("ndnr_nomagic")
    end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function summonsporecloud(inst, target, pos)
    if not inst.components.fueled:IsEmpty() then
        local sporecloud = SpawnPrefab("sporecloud")
        sporecloud.Transform:SetPosition(pos:Get())
        inst.components.fueled:DoDelta(-1)

        local caster = inst.components.inventoryitem.owner
        if caster ~= nil then
            if caster.components.staffsanity then
                caster.components.staffsanity:DoCastingDelta(-TUNING.SANITY_MEDLARGE)
            elseif caster.components.sanity ~= nil then
                caster.components.sanity:DoDelta(-TUNING.SANITY_MEDLARGE)
            end
        end

        updatefuel(inst)
    end
end

local function nofuel(inst)
    updatefuel(inst)
end

local function ontakefuel(inst)
    updatefuel(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("ndnr_corruptionstaff")
    inst.AnimState:SetBank("ndnr_corruptionstaff")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst:AddTag("spore_fueled")

    inst.entity:SetPristine()
    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst.components.inventoryitem:SetSinks(true)
    inst.components.inventoryitem.atlasname = "images/ndnr_corruptionstaff.xml"

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = TUNING.NDNR_FUELTYPE.SPORE
    inst.components.fueled:InitializeFuelLevel(10)
    inst.components.fueled:SetDepletedFn(nofuel)
    inst.components.fueled:SetTakeFuelFn(ontakefuel)
    inst.components.fueled.accepting = true

    inst:DoTaskInTime(FRAMES, updatefuel)

    inst:AddComponent("spellcaster")
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster:SetSpellFn(summonsporecloud)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable:SetOnEquip(function(inst, owner)
        inst._owner = owner
        owner.AnimState:OverrideSymbol("swap_object", "swap_ndnr_corruptionstaff", "swap_ndnr_corruptionstaff")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
    end)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("ndnr_corruptionstaff", fn, assets)
