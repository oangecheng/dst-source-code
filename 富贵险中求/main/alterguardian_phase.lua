
local alterguardian_phase = {"alterguardian_phase1", "alterguardian_phase2", "alterguardian_phase3"}
for i, v in ipairs(alterguardian_phase) do
    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        inst:ListenForEvent("healthdelta", function(inst, data)
            if data.newpercent <= 0 then
                inst.components.ndnr_pluckable:SetActCondition(false)
                inst.components.ndnr_pluckable:ActionEnable()
            end
        end)

        if v == "alterguardian_phase1" then
            inst:DoTaskInTime(6, function(inst)
                inst.components.ndnr_pluckable:SetActCondition(true)
                inst.components.ndnr_pluckable:ActionEnable()
            end)
        elseif v == "alterguardian_phase2" then
            inst:DoTaskInTime(88*FRAMES, function(inst)
                inst.components.ndnr_pluckable:SetActCondition(true)
                inst.components.ndnr_pluckable:ActionEnable()
            end)
        elseif v == "alterguardian_phase3" then
            inst:DoTaskInTime(125*FRAMES, function(inst)
                inst.components.ndnr_pluckable:SetActCondition(true)
                inst.components.ndnr_pluckable:ActionEnable()
            end)
        end

    end)
end

AddPrefabPostInit("alterguardian_phase3dead", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("onremove", function(inst)
        if TheWorld.net.mod_ndnr ~= nil then
            TheWorld.net.mod_ndnr.moonboss_dismantled = false
            local loots = LootTables["alterguardian_phase3dead"]
            if loots ~= nil then
                local has_hat = false
                for k, v in pairs(loots) do
                    if v[1] == "alterguardianhat" then
                        has_hat = true
                        break
                    end
                end
                if has_hat == false then
                    table.insert(LootTables["alterguardian_phase3dead"], {"alterguardianhat",1.00})
                end
            end
        end
    end)

    inst:DoTaskInTime(FRAMES, function()
        if TheWorld.net.mod_ndnr ~= nil then
            if TheWorld.net.mod_ndnr.moonboss_dismantled == true then
                local loots = LootTables["alterguardian_phase3dead"]
                if loots ~= nil then
                    for i, v in ipairs(loots) do
                        if v[1] == "alterguardianhat" then
                            table.remove(LootTables["alterguardian_phase3dead"], i)
                            break
                        end
                    end
                end
            end
        end
    end)
end)

-- AddPrefabPostInit("wagstaff_npc", function(inst)
--     if not TheWorld.ismastersim then
--         return inst
--     end

--     inst:ListenForEvent("ndnr_moonboss_defeated", function()
--         inst.busy = inst.busy and inst.busy + 1 or 1
--         inst:PushEvent("talk")
--         inst.components.talker:Say(getline(STRINGS.WAGSTAFF_GOTTAGO1))
--         local msm = TheWorld.components.moonstormmanager
--         if inst.hunt_stage == "experiment" and msm then
--             inst.failtasks = true
--             msm:StopExperimentTasks()
--             if msm.spawn_wagstaff_test_task then
--                 msm.spawn_wagstaff_test_task:Cancel()
--                 msm.spawn_wagstaff_test_task = nil
--             end
--             inst.static:DoTaskInTime(5,function() inst.static.components.health:Kill() end)
--         end

--         inst:DoTaskInTime(4,function()
--             inst:PushEvent("talk")
--             inst.components.talker:Say(getline(STRINGS.WAGSTAFF_GOTTAGO2))
--             inst:erode(3,nil,true)
--         end)
--     end, TheWorld)
-- end)