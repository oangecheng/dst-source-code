local ShouldAcceptItem = function(inst, item)
    return item.prefab == "godtoken"
end

local OnGetItemFromPlayer = function(inst, giver, item)
    local x, y, z = giver.Transform:GetWorldPosition()
    local bp = SpawnPrefab("godtoken_blueprint")
    bp.Transform:SetPosition(x, y, z)
end

AddPrefabPostInit("moonrockseed", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    if not inst.components.trader then
        inst:AddTag("trader")
        inst:AddComponent("trader")
        inst.components.trader:SetAcceptTest(ShouldAcceptItem)
        inst.components.trader.onaccept = OnGetItemFromPlayer
        inst.components.trader.deleteitemonaccept = true
    end
end)
