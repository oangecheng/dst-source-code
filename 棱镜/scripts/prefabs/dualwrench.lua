local assets = {
    Asset("ANIM", "anim/dualwrench.zip"),
    Asset("ANIM", "anim/swap_dualwrench.zip"),
    Asset("ATLAS", "images/inventoryimages/dualwrench.xml"),
    Asset("IMAGE", "images/inventoryimages/dualwrench.tex")
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_dualwrench", "swap_dualwrench")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end
local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("dualwrench")
    inst.AnimState:SetBuild("dualwrench")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("hammer")

    --tool (from tool component) added to pristine state for optimization
    inst:AddTag("tool")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", 0.1, {1.1, 0.5, 1.1}, true, -9, {
        sym_build = "swap_dualwrench",
        sym_name = "swap_dualwrench",
        bank = "dualwrench",
        anim = "idle"
    })

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.HAMMER_DAMAGE)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "dualwrench"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/dualwrench.xml"

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.HAMMER)  --添加锤子功能

    --添加草叉功能
    inst:AddInherentAction(ACTIONS.TERRAFORM)
    inst:AddComponent("terraformer")

    inst:AddComponent("carpetpullerlegion")

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.HAMMER_USES)   --总共75次，可攻击75次
    inst.components.finiteuses:SetUses(TUNING.HAMMER_USES)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    --设置每种功能的消耗量
    inst.components.finiteuses:SetConsumption(ACTIONS.HAMMER, 0.3)  --可以使用75/0.3=250次
    inst.components.finiteuses:SetConsumption(ACTIONS.TERRAFORM, 0.3)

    MakeHauntableLaunch(inst)

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    return inst
end

return Prefab("dualwrench", fn, assets)
