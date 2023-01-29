local function ShouldAcceptItem(inst, item)
    return item.prefab == "royal_jelly"
end

local function OnGetItemFromPlayer(inst, giver, item)
    if inst.components.timer then
        inst.components.timer:StartTimer("ndnr_happyfriendlyfruitflytimer", TUNING.TOTAL_DAY_TIME*3)
        inst.sg:GoToState("plant_dance")
    end
end

AddPrefabPostInit("friendlyfruitfly", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    if not inst.components.timer then
        inst:AddComponent("timer")
    end

    if not inst.components.trader then
        inst:AddComponent("trader")
    end

    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.deleteitemonaccept = true

end)