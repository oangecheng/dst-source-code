local assets = {
    Asset("ANIM", "anim/snakeoil.zip"),
    Asset("IMAGE", "images/ndnr_snakeoil.tex"),
    Asset("ATLAS", "images/ndnr_snakeoil.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_snakeoil.xml", 256),
}

local function ondofn(inst, doer)
    if doer.components.debuffable then
        doer.components.debuffable:AddDebuff("ndnr_snakeoildebuff", "ndnr_snakeoildebuff")
    end
    if doer.components.talker ~= nil then
        doer.components.talker:Say(TUNING.NDNR_SMEAR_SNAKEOIL)
    end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("snakeoil")
    inst.AnimState:SetBank("snakeoil")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("smearable")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()
    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst.components.inventoryitem.atlasname = "images/ndnr_snakeoil.xml"

    inst:AddComponent("ndnr_smearable")
    inst.components.ndnr_smearable:OnDo(ondofn)

    MakeHauntableLaunch(inst)

    return inst
end
return Prefab("ndnr_snakeoil", fn, assets, prefabs)
