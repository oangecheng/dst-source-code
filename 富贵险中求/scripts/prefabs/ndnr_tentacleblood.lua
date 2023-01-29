local assets = {
    Asset("ANIM", "anim/ndnr_tentacleblood.zip"),
    Asset("ATLAS", "images/ndnr_tentacleblood.xml"),
    Asset("IMAGE", "images/ndnr_tentacleblood.tex"),
    Asset("ATLAS_BUILD", "images/ndnr_tentacleblood.xml", 256),
}

local function oninjection(inst, invobj, doer)
    if doer.components.debuffable ~= nil then
        doer.components.debuffable:AddDebuff("ndnr_tentacleblooddebuff", "ndnr_tentacleblooddebuff")
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

    inst.AnimState:SetBank("ndnr_tentacleblood")
    inst.AnimState:SetBuild("ndnr_tentacleblood")
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
    inst.components.inventoryitem.atlasname = "images/ndnr_tentacleblood.xml"

    MakeHauntableLaunch(inst)

    return inst
end
return Prefab("ndnr_tentacleblood", fn, assets)
