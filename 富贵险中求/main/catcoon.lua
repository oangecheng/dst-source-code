local catcoons = {"catcoon", "ticoon"}
for i,v in pairs(catcoons) do
    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then
            return inst
        end

        if not inst.components.timer then
            inst:AddComponent("timer")
        end

        if inst.components.trader then
            local _test = inst.components.trader.test
            inst.components.trader:SetAcceptTest(function(inst, item)
                if item.prefab == "ndnr_coffeebeans" and inst.components.timer:TimerExists("ndnr_catconstipation") then
                    return false
                end
                return _test(inst, item)
            end)

            local _onaccept = inst.components.trader.onaccept
            inst.components.trader.onaccept = function(inst, giver, item)
                if item.prefab == "ndnr_coffeebeans" then
                    if inst.components.sleeper:IsAsleep() then
                        inst.components.sleeper:WakeUp()
                    end
                    if inst.components.combat.target == giver then
                        inst.components.combat:SetTarget(nil)
                        inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/catcoon/pickup")
                    end
                    if giver.components.leader ~= nil then
                        if giver.components.minigame_participator == nil then
                            giver:PushEvent("makefriend")
                            giver.components.leader:AddFollower(inst)
                            if inst.components.follower then
                                inst.components.follower:AddLoyaltyTime(TUNING.CATCOON_LOYALTY_PER_ITEM)
                            end
                        end
                    end

                    inst.components.timer:StartTimer("ndnr_catconstipation", math.random(TUNING.TOTAL_DAY_TIME/2))
                else
                    _onaccept(inst, giver, item)
                end
            end
            inst.components.trader.deleteitemonaccept = true
        end

        inst:ListenForEvent("timerdone", function(inst, data)
            if data.name == "ndnr_catconstipation" then
                if inst.components.lootdropper then
                    inst.components.lootdropper:SpawnLootPrefab("ndnr_catpoop", inst:GetPosition())
                end
            end
        end)

    end)
end