local assets = {
    Asset("ANIM", "anim/ndnr_pagodasugar.zip"),
    Asset("IMAGE", "images/ndnr_pagodasugar.tex"),
    Asset("ATLAS", "images/ndnr_pagodasugar.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_pagodasugar.xml", 256),
}

local function item_oneaten(inst, eater)
    if eater.ndnr_parasite == true then
        if eater.components.lootdropper == nil then
            eater:AddComponent("lootdropper")
        end
        eater.components.lootdropper:SpawnLootPrefab("poop", eater:GetPosition())
        if eater.components.hunger ~= nil then
            eater.components.hunger:DoDelta(-75/3, nil, "ndnr_pagodasugar")
        end

        if eater.components.talker then
            eater.components.talker:Say(TUNING.NDNR_PARASITE_GONE)
        end
    else
        -- 宝塔糖吃了伤神经
        if eater.components.sanity ~= nil then
            eater.components.sanity:DoDelta(-15, nil, "ndnr_pagodasugar")
        end
        if eater.components.talker then
            eater.components.talker:Say(TUNING.NDNR_NOPARASITE_EATPAGODASUGAR)
        end
    end

    eater.ndnr_parasite = false
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("ndnr_pagodasugar")

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("ndnr_pagodasugar")
    inst.AnimState:SetBuild("ndnr_pagodasugar")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.GOODIES
    inst.components.edible.hungervalue = 0
    inst.components.edible.healthvalue = 0
    inst.components.edible.sanityvalue = 0
    inst.components.edible:SetOnEatenFn(item_oneaten)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_pagodasugar.xml"

    MakeHauntableLaunch(inst)

    return inst
end
return Prefab("ndnr_pagodasugar", fn, assets)
