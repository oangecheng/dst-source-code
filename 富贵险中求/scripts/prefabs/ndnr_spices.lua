
local function MakeSpice(name)
    local assets =
    {
        Asset("ANIM", "anim/spices.zip"),
        Asset("ANIM", "anim/ndnr_spices.zip"),
        Asset("IMAGE", "images/"..name..".tex"),
        Asset("ATLAS", "images/"..name..".xml"),
        Asset("ATLAS_BUILD", "images/"..name..".xml", 256),
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("spices")
        inst.AnimState:SetBuild("spices")
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:OverrideSymbol("swap_spice", "ndnr_spices", name)

        inst:AddTag("spice")

        MakeInventoryFloatable(inst, "med", nil, (name == "spice_garlic" and 0.85) or 0.7)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/"..name..".xml"

        MakeHauntableLaunch(inst)

        return inst
    end

    return Prefab(name, fn, assets)
end

return MakeSpice("ndnr_spice_smelly")
