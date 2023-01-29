local assets = {
    Asset("ANIM", "anim/cutlass.zip"),
    Asset("ANIM", "anim/swap_cutlass.zip"),
    Asset("IMAGE", "images/ndnr_cutlass.tex"),
    Asset("ATLAS", "images/ndnr_cutlass.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_cutlass.xml", 256),
}

local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_cutlass", "swap_cutlass")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onattack(inst, attacker, target)
    -- if target.prefab == "twister" then
    --     target.components.health:DoDelta(-TUNING.CUTLASS_BONUS_DAMAGE)
    -- end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst:AddTag("canrepairbyfishmeat_small")
    inst:AddTag("canrepairbyfishmeat")
    inst:AddTag("canrepairbyeel")

    inst.AnimState:SetBank("cutlass")
    inst.AnimState:SetBuild("cutlass")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("cutlass")

    inst.entity:SetPristine()

    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.NIGHTSWORD_DAMAGE)
    inst.components.weapon:SetOnAttack(onattack)

    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.WATHGRITHR_SPEAR_USES)
    inst.components.finiteuses:SetUses(TUNING.WATHGRITHR_SPEAR_USES)

    inst.components.finiteuses:SetOnFinished(onfinished)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_cutlass.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    return inst
end

return Prefab("ndnr_cutlass", fn, assets)
