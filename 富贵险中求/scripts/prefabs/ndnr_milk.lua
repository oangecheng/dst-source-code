local assets = {
    Asset("ANIM", "anim/milk.zip"),
    Asset("IMAGE", "images/ndnr_milk.tex"),
    Asset("ATLAS", "images/ndnr_milk.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_milk.xml", 256),
}

local function item_oneaten(inst, eater)
    if eater.components.debuffable and eater.prefab ~= "wx78" and math.random() < .2 then
        eater.components.debuffable:AddDebuff("ndnr_badmilkdebuff", "ndnr_badmilkdebuff")
    end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("milk")
    inst.AnimState:SetBank("milk")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    -- inst:AddTag("cookable")
    inst:AddTag("ndnr_milk")

    inst.entity:SetPristine()
    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_milk.xml"

    inst:AddComponent("tradable")

    inst:AddComponent("edible")
    -- inst.components.edible.foodtype = FOODTYPE.GOODIES
    inst.components.edible.hungervalue = 5
    inst.components.edible.healthvalue = 20
    inst.components.edible.sanityvalue = 5
    inst.components.edible:SetOnEatenFn(item_oneaten)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    -- inst:AddComponent("cookable")
    -- inst.components.cookable.product = "ndnr_milk_cooked"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    MakeHauntableLaunch(inst)

    return inst
end


local function cookedfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("milk")
    inst.AnimState:SetBank("milk")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()
    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_milk.xml"
    inst.components.inventoryitem:ChangeImageName("ndnr_milk")

    inst:AddComponent("edible")
    -- inst.components.edible.foodtype = FOODTYPE.GOODIES
    inst.components.edible.hungervalue = 5
    inst.components.edible.healthvalue = 20
    inst.components.edible.sanityvalue = 5
    -- inst.components.edible:SetOnEatenFn(item_oneaten)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERFAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("ndnr_milk", fn, assets)
    -- Prefab("ndnr_milk_cooked", cookedfn, assets)
