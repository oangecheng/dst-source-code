local assets = {
    Asset("ANIM", "anim/obsidian.zip"),
    Asset("IMAGE", "images/ndnr_obsidian.tex"),
    Asset("ATLAS", "images/ndnr_obsidian.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_obsidian.xml", 256),
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("obsidian")
    inst.AnimState:SetBuild("obsidian")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    inst:AddTag("molebait")

    inst._actionstr = "OBSIDIAN"

    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("ndnr_repair")
    inst.components.ndnr_repair:SetAmount(1/3)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_obsidian.xml"

    inst:AddComponent("bait")

    return inst
end

return Prefab("ndnr_obsidian", fn, assets)
