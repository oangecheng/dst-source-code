local assets = {
    Asset("ANIM", "anim/ndnr_antibiotic.zip"),
    Asset("ATLAS", "images/ndnr_antibiotic.xml"),
    Asset("IMAGE", "images/ndnr_antibiotic.tex"),
    Asset("ATLAS_BUILD", "images/ndnr_antibiotic.xml", 256),
}

local function oninjection(inst, invobj, doer)
    if doer:HasTag("ndnr_plague") then
        doer:AddTag("ndnr_recoverybyantibiotic")
        doer.components.debuffable:RemoveDebuff("ndnr_plaguedebuff")
        doer.components.debuffable:RemoveDebuff("ndnr_plague_seriousdebuff")
        return true
    end
    return false
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("ndnr_caninjection")

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("ndnr_antibiotic")
    inst.AnimState:SetBuild("ndnr_antibiotic")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("ndnr_injection")
    inst.components.ndnr_injection:Injection(oninjection)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_antibiotic.xml"

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("ndnr_antibiotic", fn, assets)
