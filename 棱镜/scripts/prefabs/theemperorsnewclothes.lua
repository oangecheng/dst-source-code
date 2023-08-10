local function OnUnequip_crown(inst, owner)
    HAT_L_OFF(inst, owner)
end

------------

local function OnUnequip_mantle(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body_tall")
end

------------

local function OnUnequip_pendant(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
end

------------

local function OnEquip_scepter(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function OnUnequip_scepter(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

------------
------------

local function MakeClothes(namepst, slot, fn_equip, fn_unequip)
    local name  = "theemperors"..namepst
    local assets =
    {
        Asset("ANIM", "anim/theemperorsnewclothes.zip"),
        Asset("ATLAS", "images/inventoryimages/"..name..".xml"),
        Asset("IMAGE", "images/inventoryimages/"..name..".tex"),
    }

    local function Fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("theemperorsnewclothes")
        inst.AnimState:SetBuild("theemperorsnewclothes")
        inst.AnimState:PlayAnimation("anim_"..namepst)

        if slot == EQUIPSLOTS.HEAD then
            inst:AddTag("hat")
        elseif slot == EQUIPSLOTS.HANDS then
            inst:AddTag("nopunch")
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = name
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"
        inst.components.inventoryitem:SetSinks(true)

        inst:AddComponent("inspectable")

        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = slot
        inst.components.equippable:SetOnEquip(fn_equip)
        inst.components.equippable:SetOnUnequip(fn_unequip)

        if slot == EQUIPSLOTS.HEAD then
            inst:AddComponent("tradable")
        end

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.MED_FUEL

        MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
        MakeSmallPropagator(inst)

        MakeHauntableLaunch(inst)

        return inst
    end

    return Prefab(name, Fn, assets)
end

return MakeClothes("crown", EQUIPSLOTS.HEAD, OnUnequip_crown, OnUnequip_crown),
        MakeClothes("mantle", EQUIPSLOTS.BACK or EQUIPSLOTS.BODY, OnUnequip_mantle, OnUnequip_mantle),
        MakeClothes("scepter", EQUIPSLOTS.HANDS, OnEquip_scepter, OnUnequip_scepter),
        MakeClothes("pendant", EQUIPSLOTS.NECK or EQUIPSLOTS.BODY, OnUnequip_pendant, OnUnequip_pendant)
