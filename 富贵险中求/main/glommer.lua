local function GlommerShouldAcceptItem(inst, item)
    return item:HasTag("ndnr_milk") and not TheWorld.state.isnight
end

local function GlommerHungry(inst)
    inst.ndnr_diarrhea = false

    if inst.components.periodicspawner then
        inst.components.periodicspawner:Stop()
        inst.components.periodicspawner.basetime = TUNING.TOTAL_DAY_TIME * 2
        inst.components.periodicspawner.randtime = TUNING.TOTAL_DAY_TIME * 2
        inst.components.periodicspawner:Start()
    end

    if inst.components.trader then
        inst.components.trader:Enable()
    end

    if inst.components.sanityaura then
        inst.components.sanityaura.aura = TUNING.SANITYAURA_TINY
    end

    return true
end

local function GlommerStartDiarrhea(inst)
    if inst.components.periodicspawner and inst.ndnr_diarrhea then
        inst.components.periodicspawner:Stop()
        inst.components.periodicspawner.basetime = TUNING.TOTAL_DAY_TIME / 8
        inst.components.periodicspawner.randtime = TUNING.TOTAL_DAY_TIME / 8
        inst.components.periodicspawner:Start()
    end
    return true
end

-- local function GlommerOnGetItemFromPlayer(inst, giver, item)
--     inst.ndnr_diarrhea = item:HasTag("ndnr_ice_milk")
--     local startdiarrhea = GlommerStartDiarrhea(inst)

--     if inst.components.trader then
--         inst.components.trader:Disable()
--     end

--     if inst.components.sanityaura then
--         inst.components.sanityaura.aura = TUNING.SANITYAURA_MED
--     end

--     if inst.components.timer then
--         inst.components.timer:StartTimer("ndnr_nexteatfoodtimer", TUNING.TOTAL_DAY_TIME)
--     end

--     inst.sg:GoToState("bored")
-- end

AddPrefabPostInit("glommer", function(inst)
    inst:AddTag("trader")

    if not TheWorld.ismastersim then
        return inst
    end

    if not inst.components.timer then
        inst:AddComponent("timer")
    end

    if not inst.components.trader then
        inst:AddComponent("trader")
    end
    local _abletoaccepttest = inst.components.trader.abletoaccepttest
    inst.components.trader:SetAbleToAcceptTest(function(inst, item)
        return (_abletoaccepttest and _abletoaccepttest(inst, item)) or (item:HasTag("ndnr_milk") and not TheWorld.state.isnight)
    end)
    local _test = inst.components.trader.test
    inst.components.trader:SetAcceptTest(function(inst, item, giver)
        return (_test and _test(inst, item, giver)) or (item:HasTag("ndnr_milk") and not TheWorld.state.isnight)
    end)
    local _onaccept = inst.components.trader.onaccept
    inst.components.trader.onaccept = function(inst, giver, item)
        if _onaccept then
            _onaccept(inst, giver, item)
        end
        inst.ndnr_diarrhea = item:HasTag("ndnr_ice_milk")
        local startdiarrhea = GlommerStartDiarrhea(inst)

        if inst.components.trader then
            inst.components.trader:Disable()
        end

        if inst.components.sanityaura then
            inst.components.sanityaura.aura = TUNING.SANITYAURA_MED
        end

        if inst.components.timer then
            inst.components.timer:StartTimer("ndnr_nexteatfoodtimer", TUNING.TOTAL_DAY_TIME)
        end

        inst.sg:GoToState("bored")
    end
    -- inst.components.trader.onrefuse = OnRefuseItem
    inst.components.trader.deleteitemonaccept = true

    inst:DoTaskInTime(FRAMES, function(inst)
        if inst.components.timer and inst.components.timer:TimerExists("ndnr_nexteatfoodtimer") then
            GlommerStartDiarrhea(inst)
        end
    end)

    inst:ListenForEvent("timerdone", function(inst, data)
        if data.name == "ndnr_nexteatfoodtimer" then
            GlommerHungry(inst)
        end
    end)

    local onsave = inst.OnSave
    inst.OnSave = function(inst, data)
        if onsave then
            onsave(inst, data)
        end
        data.ndnr_diarrhea = inst.ndnr_diarrhea == nil and false or inst.ndnr_diarrhea
    end

    local onload = inst.OnLoad
    inst.OnLoad = function(inst, data)
        if onload then
            onload(inst, data)
        end
        if data then
            inst.ndnr_diarrhea = data.ndnr_diarrhea == nil and false or data.ndnr_diarrhea
        end
    end

end)