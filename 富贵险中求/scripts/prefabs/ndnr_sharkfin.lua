local assets = {
    Asset("ANIM", "anim/ndnr_sharkfin.zip"),
    Asset("ANIM", "anim/meat_rack_food.zip"),
    Asset("ANIM", "anim/meat_rack_food_tot.zip"),
    Asset("IMAGE", "images/ndnr_sharkfin.tex"),
    Asset("ATLAS", "images/ndnr_sharkfin.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_sharkfin.xml", 256),
}

local function item_oneaten(inst, eater)

end

local function OnSpawnedFromHaunt(inst, data)
    Launch(inst, data.haunter, TUNING.LAUNCH_SPEED_SMALL)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("ndnr_sharkfin")
    inst.AnimState:SetBuild("ndnr_sharkfin")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst:AddTag("meat")
    inst:AddTag("dryable")
    inst:AddTag("lureplant_bait")
    inst:AddTag("cookable")
    inst:AddTag("rawmeat")
    inst:AddTag("catfood")
    inst:AddTag("fishmeat")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst:AddComponent("inspectable")
    inst:AddComponent("bait")

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    -- inst:AddComponent("dryable")
    -- inst.components.dryable:SetProduct("meat_dried")
    -- inst.components.dryable:SetDryTime(TUNING.DRY_FAST)
    -- inst.components.dryable:SetBuildFile("ndnr_sharkfin")
    -- inst.components.dryable:SetDriedBuildFile("meat_rack_food")

    inst:AddComponent("cookable")
    inst.components.cookable.product = "fishmeat_cooked"

    inst:AddComponent("edible")
    inst.components.edible.ismeat = true
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.healthvalue = TUNING.HEALING_MEDSMALL
    inst.components.edible.hungervalue = TUNING.CALORIES_MED
    inst.components.edible:SetOnEatenFn(item_oneaten)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_sharkfin.xml"

    MakeHauntableLaunchAndPerish(inst)
    inst:ListenForEvent("spawnedfromhaunt", OnSpawnedFromHaunt)

    return inst
end
return Prefab("ndnr_sharkfin", fn, assets)
