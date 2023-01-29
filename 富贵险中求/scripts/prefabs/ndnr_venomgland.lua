local assets = {
    Asset("ANIM", "anim/venom_gland.zip"),
    Asset("IMAGE", "images/ndnr_venomgland.tex"),
    Asset("ATLAS", "images/ndnr_venomgland.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_venomgland.xml", 256),
}

local function item_oneaten(inst, eater)
    if eater.components.health then
        local reducehealth = -75
        if eater.components.health.currenthealth <= 75 then
            reducehealth = -eater.components.health.currenthealth + 1
        end
        eater.components.health:DoDelta(reducehealth, nil, "venomgland", nil, nil, true)
    end
    if eater.components.debuffable then
        eater.components.debuffable:RemoveDebuff("ndnr_poisondebuff")
    end
end

local function smearstaff_do(self, doer, target)
    target:AddTag("poison")

    local name = STRINGS.NAMES[string.upper(target.prefab)] or ""
    target.components.named:SetName(TUNING.NDNR_NAME_PREFIX_POISONOUS .. " " .. name)

    if self.inst.components.stackable then
        local item = self.inst.components.stackable:Get()
        item:Remove()
    end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("venom_gland")
    inst.AnimState:SetBank("venom_gland")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst._actionstr = "SMEARPOISON"

    inst.entity:SetPristine()
    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst.components.inventoryitem.atlasname = "images/ndnr_venomgland.xml"

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.GOODIES
    inst.components.edible.hungervalue = 0
    inst.components.edible.healthvalue = 0
    inst.components.edible.sanityvalue = 0
    inst.components.edible:SetOnEatenFn(item_oneaten)

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("ndnr_smearstaff")
    inst.components.ndnr_smearstaff:SetDoFn(smearstaff_do)

    MakeHauntableLaunch(inst)

    return inst
end
return Prefab("ndnr_venomgland", fn, assets, prefabs)
