local cooked_assets = {
    Asset("ANIM", "anim/ndnr_roe.zip"),
    Asset("IMAGE", "images/ndnr_roe_cooked.tex"),
    Asset("ATLAS", "images/ndnr_roe_cooked.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_roe_cooked.xml", 256),
}

local function MakeRoe(fish)
    local name = "ndnr_roe_"..fish.prefab
    local assets = {
        Asset("ANIM", "anim/ndnr_roe.zip"),
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

        inst.AnimState:SetBuild("ndnr_roe")
        inst.AnimState:SetBank("roe")
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:SetRayTestOnBB(true)

        MakeInventoryFloatable(inst)

        inst:AddTag("meat")
        inst:AddTag("lureplant_bait")
        inst:AddTag("cookable")
        inst:AddTag("ndnr_roe")

        inst.entity:SetPristine()
        --------------------------------------------------------------------------
        if not TheWorld.ismastersim then
            return inst
        end
        --------------------------------------------------------------------------
        inst:AddComponent("inspectable")
        inst:AddComponent("tradable")
        inst:AddComponent("ndnr_roe")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/"..name..".xml"

        inst:AddComponent("edible")
        inst.components.edible.foodtype = FOODTYPE.MEAT
        inst.components.edible.hungervalue = TUNING.CALORIES_TINY/2
        inst.components.edible.healthvalue = 1
        inst.components.edible.sanityvalue = 0

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERFAST)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food"

        inst:AddComponent("cookable")
        inst.components.cookable.product = "ndnr_roe_cooked"

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        MakeHauntableLaunch(inst)

        return inst
    end

    return Prefab(name, fn, assets)
end


local function cookedfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("ndnr_roe")
    inst.AnimState:SetBank("roe")
    inst.AnimState:PlayAnimation("cooked")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()
    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_roe_cooked.xml"

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY/2
    inst.components.edible.healthvalue = 0
    inst.components.edible.sanityvalue = 0

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    MakeHauntableLaunch(inst)

    return inst
end

local roes = {}
for k, v in pairs(require("prefabs/oceanfishdef").fish) do
    table.insert(roes, MakeRoe(v))
end
table.insert(roes, Prefab("ndnr_roe_cooked", cookedfn, cooked_assets))

return unpack(roes)
