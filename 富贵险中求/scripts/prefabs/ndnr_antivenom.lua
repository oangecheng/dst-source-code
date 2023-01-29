local assets =
{
    Asset("ANIM", "anim/poison_antidote.zip"),
    Asset("IMAGE", "images/ndnr_antivenom.tex"),
    Asset("ATLAS", "images/ndnr_antivenom.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_antivenom.xml", 256),
}

local function OnPoisonHeal(inst, target)
    if target.components.debuffable then
        target.components.debuffable:RemoveDebuff("ndnr_poisondebuff")
        target.components.talker:Say(TUNING.NDNR_MUCHMORECOMFORTABLE)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("poison_antidote")
    inst.AnimState:SetBuild("poison_antidote")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_antivenom.xml"

    inst:AddComponent("ndnr_poisonhealer")
    inst.components.ndnr_poisonhealer:SetHealthAmount(0)
    inst.components.ndnr_poisonhealer.onpoisonhealfn = OnPoisonHeal

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("ndnr_antivenom", fn, assets)