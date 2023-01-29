local function ShouldAcceptItem(inst, item)
    if not inst.ndnr_bountytasklist then return false end

    for k, v in pairs(inst.ndnr_bountytasklist) do
        if item.prefab == k then
            return true
        end
    end

    return false
end

local function OnGetItemFromPlayer(inst, giver, item)
    if inst.ndnr_bountytaskaccept == nil then
        inst.ndnr_bountytaskaccept = {}
    end
    for k, v in pairs(inst.ndnr_bountytasklist) do
        if item.prefab == k then
            local itemcount = inst.ndnr_bountytaskaccept[k] or 0
            inst.ndnr_bountytaskaccept[k] = itemcount + (item.components.stackable and item.components.stackable:StackSize() or 1)
            break
        end
    end
    local finish = true
    for k, v in pairs(inst.ndnr_bountytasklist) do
        if inst.ndnr_bountytaskaccept[k] == nil or inst.ndnr_bountytaskaccept[k] < v then
            finish = false
            break
        end
    end

    if finish then
        inst.components.trader:Disable()
        if inst.components.talker then
            inst.components.talker:Say(TUNING.NDNR_BOUNTYTASK_DELIVERYFINISH)
        end
        if inst.components.lootdropper then
            local reward = inst.ndnr_bountytaskreward
            for k, v in pairs(reward) do
                for i = 1, v do
                    inst.components.lootdropper:SpawnLootPrefab(k, inst:GetPosition())
                end
            end
        end
        inst.ndnr_bounty:Remove()
        inst:PushEvent("doerode", {
            time = 4.0,
            erodein = false,
            remove = true,
        })
    end
end

local function OnRefuseItem(inst, item)
    if inst.components.talker then
        inst.components.talker:Say(TUNING.NDNR_BOUNTYTASK_DELIVERYREFUSE)
    end
end

AddPrefabPostInit("wagstaff_npc_pstboss", function(inst)

    inst:AddTag("trader")

    if not TheWorld.ismastersim then
        return inst
    end

    if not inst.components.lootdropper then
        inst:AddComponent("lootdropper")
    end
    if not inst.components.trader then
        inst:AddComponent("trader")
    end
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
    inst.components.trader.deleteitemonaccept = true
    inst.components.trader.acceptnontradable = true

end)