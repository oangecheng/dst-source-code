local assets = {
    Asset("ANIM", "anim/weatherpole.zip"),
    Asset("IMAGE", "images/ndnr_weatherpole.tex"),
    Asset("ATLAS", "images/ndnr_weatherpole.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_weatherpole.xml", 256),
}

local function ItemTradeTest(inst, item)
    return item.prefab == "bluegem" or item.prefab == "redgem" or item.prefab == "purplegem"
end

local function OnGemGiven(inst, giver, item)
    local mooneye = SpawnPrefab("ndnr_"..string.sub(item.prefab, 1, -4) .. "weatherpole")
    local container = inst.components.inventoryitem:GetContainer()
    if container ~= nil then
        local slot = inst.components.inventoryitem:GetSlotNum()
        inst:Remove()
        container:GiveItem(mooneye, slot)
    else
        local x, y, z = inst.Transform:GetWorldPosition()
        inst:Remove()
        mooneye.Transform:SetPosition(x, y, z)
    end
    mooneye.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("weatherpole")
    inst.AnimState:SetBank("weatherpole")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst:AddTag("gemsocket")
    inst:AddTag("give_dolongaction")
    inst.entity:SetPristine()
    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst.components.inventoryitem:SetSinks(true)
    inst.components.inventoryitem.atlasname = "images/ndnr_weatherpole.xml"

    inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(ItemTradeTest)
    inst.components.trader.onaccept = OnGemGiven

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("ndnr_weatherpole", fn, assets, prefabs)
