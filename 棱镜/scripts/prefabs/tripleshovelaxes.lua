--------------------------------------------------------------------------
--[[ 斧铲-三用型 ]]
--------------------------------------------------------------------------

local assets = {
    Asset("ANIM", "anim/tripleshovelaxe.zip"),
    Asset("ATLAS", "images/inventoryimages/tripleshovelaxe.xml"),
    Asset("IMAGE", "images/inventoryimages/tripleshovelaxe.tex"),
}

local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function Fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tripleshovelaxe")
    inst.AnimState:SetBuild("tripleshovelaxe")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")

    --tool (from tool component) added to pristine state for optimization
    inst:AddTag("tool")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("tripleshovelaxe")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.AXE_DAMAGE)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "tripleshovelaxe"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tripleshovelaxe.xml"

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 1)
    inst.components.tool:SetAction(ACTIONS.MINE, 1)
    inst.components.tool:SetAction(ACTIONS.DIG,  1)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(108)   --总共108次，可攻击108次
    inst.components.finiteuses:SetUses(108)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    --设置每种功能的消耗量
    inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 0.6)  --可以使用108/0.6=180次
    inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 0.6)
    inst.components.finiteuses:SetConsumption(ACTIONS.DIG,  0.6)

    MakeHauntableLaunch(inst)

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(function(inst, owner)
        local skindata = inst.components.skinedlegion:GetSkinedData()
        if skindata ~= nil and skindata.equip ~= nil then
            owner.AnimState:OverrideSymbol("swap_object", skindata.equip.build, skindata.equip.file)
        else
            owner.AnimState:OverrideSymbol("swap_object", "tripleshovelaxe", "swap")
        end
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
    end)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

--------------------------------------------------------------------------
--[[ 斧铲-黄金三用型 ]]
--------------------------------------------------------------------------

local assets_gold = {
    Asset("ANIM", "anim/triplegoldenshovelaxe.zip"),
    Asset("ATLAS", "images/inventoryimages/triplegoldenshovelaxe.xml"),
    Asset("IMAGE", "images/inventoryimages/triplegoldenshovelaxe.tex"),
}

local function Fn_gold()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("triplegoldenshovelaxe")
    inst.AnimState:SetBuild("triplegoldenshovelaxe")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")

    --tool (from tool component) added to pristine state for optimization
    inst:AddTag("tool")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("triplegoldenshovelaxe")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.AXE_DAMAGE)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "triplegoldenshovelaxe"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/triplegoldenshovelaxe.xml"

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 1.1)
    inst.components.tool:SetAction(ACTIONS.MINE, 1.1)
    inst.components.tool:SetAction(ACTIONS.DIG,  1.1)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(180)
    inst.components.finiteuses:SetUses(180)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    --设置每种功能的消耗量
    inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 0.1)  --可以使用180/0.1=1800次
    inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 0.1)
    inst.components.finiteuses:SetConsumption(ACTIONS.DIG,  0.1)
    inst.components.weapon.attackwear = 0.1

    MakeHauntableLaunch(inst)

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(function(inst, owner)
        local skindata = inst.components.skinedlegion:GetSkinedData()
        if skindata ~= nil and skindata.equip ~= nil then
            owner.AnimState:OverrideSymbol("swap_object", skindata.equip.build, skindata.equip.file)
        else
            owner.AnimState:OverrideSymbol("swap_object", "triplegoldenshovelaxe", "swap")
        end
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
    end)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

------

return Prefab("tripleshovelaxe", Fn, assets),
        Prefab("triplegoldenshovelaxe", Fn_gold, assets_gold)
