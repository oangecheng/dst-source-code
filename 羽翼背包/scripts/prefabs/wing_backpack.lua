local assets = {
    Asset("IMAGE", "images/inventoryimages/cbdz0.tex"),
    Asset("ATLAS", "images/inventoryimages/cbdz0.xml"),
    Asset("IMAGE", "images/inventoryimages/cbdz1.tex"),
    Asset("ATLAS", "images/inventoryimages/cbdz1.xml"),
    Asset("IMAGE", "images/inventoryimages/cbdz2.tex"),
    Asset("ATLAS", "images/inventoryimages/cbdz2.xml"),
    Asset("IMAGE", "images/inventoryimages/cbdz3.tex"),
    Asset("ATLAS", "images/inventoryimages/cbdz3.xml"),
    Asset("IMAGE", "images/inventoryimages/cbdz4.tex"),
    Asset("ATLAS", "images/inventoryimages/cbdz4.xml"),
    Asset("IMAGE", "images/inventoryimages/cbdz5.tex"),
    Asset("ATLAS", "images/inventoryimages/cbdz5.xml"),
    Asset("IMAGE", "images/inventoryimages/cbdz6.tex"),
    Asset("ATLAS", "images/inventoryimages/cbdz6.xml"),
    Asset("IMAGE", "images/inventoryimages/cbdz7.tex"),
    Asset("ATLAS", "images/inventoryimages/cbdz7.xml"),
    Asset("IMAGE", "images/inventoryimages/cbdz8.tex"),
    Asset("ATLAS", "images/inventoryimages/cbdz8.xml"),
    Asset("ANIM", "anim/cbdz0.zip"),
    Asset("ANIM", "anim/ui_cbdz0.zip"),
    Asset("ANIM", "anim/cbdz1.zip"),
    Asset("ANIM", "anim/ui_cbdz1.zip"),
    Asset("ANIM", "anim/cbdz2.zip"),
    Asset("ANIM", "anim/ui_cbdz2.zip"),
    Asset("ANIM", "anim/cbdz3.zip"),
    Asset("ANIM", "anim/ui_cbdz3.zip"),
    Asset("ANIM", "anim/cbdz4.zip"),
    Asset("ANIM", "anim/ui_cbdz4.zip"),
    Asset("ANIM", "anim/cbdz5.zip"),
    Asset("ANIM", "anim/ui_cbdz5.zip"),
    Asset("ANIM", "anim/cbdz6.zip"),
    Asset("ANIM", "anim/ui_cbdz6.zip"),
    Asset("ANIM", "anim/cbdz7.zip"),
    Asset("ANIM", "anim/ui_cbdz7.zip"),
    Asset("ANIM", "anim/cbdz8.zip"),
    Asset("ANIM", "anim/ui_cbdz8.zip")
}

local function cbdz(name)
    local function onequip(inst, owner)
        owner.AnimState:OverrideSymbol("swap_body", "cbdz" .. name, "swap_body")
        if inst.components.container ~= nil then
            inst.components.container:Open(owner)
        end
    end

    local function onunequip(inst, owner)
        owner.AnimState:ClearOverrideSymbol("swap_body")
        if inst.components.container ~= nil then
            inst.components.container:Close(owner)
        end
    end

    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("cbdz" .. name)
        inst.AnimState:SetBuild("cbdz" .. name)
        inst.AnimState:PlayAnimation("anim")

        inst.foleysound = "dontstarve/movement/foley/backpack"

        inst:AddTag("backpack")
        inst:AddTag("fridge")
        inst:AddTag("nocool")
        inst:AddTag("waterproofer")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/cbdz" .. name .. ".xml"
        inst.components.inventoryitem.imagename = "cbdz" .. name
        inst.components.inventoryitem.cangoincontainer = false

        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
        inst.components.equippable.walkspeedmult = 1.1
        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(0.5)

        inst:AddComponent("container")
        inst.components.container:WidgetSetup("cbdz" .. name)

        MakeHauntableLaunch(inst)

        return inst
    end
    return Prefab("cbdz" .. name, fn, assets)
end

return cbdz("0"), cbdz("1"), cbdz("2"), cbdz("3"), cbdz("4"), cbdz("5"), cbdz("6"), cbdz("7"), cbdz("8")
