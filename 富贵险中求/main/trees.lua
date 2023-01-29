local trees = {"evergreen", "twiggytree", "deciduoustree", "moon_tree", "ndnr_palmtree"}
for i, v in ipairs(trees) do
    local function updateactcondition(inst, stage)
        local actcondition = false
        if inst.components.growable == nil then
            actcondition = false
        else
            local stage = stage ~= nil and stage or inst.components.growable:GetStage()
            if stage == 3 and not inst:HasTag("stump") and not inst:HasTag("burnt")
                and (inst.prefab ~= "deciduoustree" or (inst.prefab == "deciduoustree" and not inst.monster and not TheWorld.state.iswinter)) then
                actcondition = true
            else
                actcondition = false
            end
        end
        if inst.components.ndnr_pluckable ~= nil then
            inst.components.ndnr_pluckable:SetActCondition(actcondition)
            inst.components.ndnr_pluckable:ActionEnable()
        end
    end
    local function stageupdate(inst, stage)
        if inst.components.ndnr_pluckable ~= nil then
            updateactcondition(inst, stage)
        end
    end

    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then return inst end

        if inst.components.growable then
            inst.components.growable.stageupdatefn = stageupdate
        end

        if inst.components.workable then
            local _onfinish = inst.components.workable.onfinish
            inst.components.workable.onfinish = function(inst, worker)
                _onfinish(inst, worker)
                updateactcondition(inst)
            end
        end

        if v == "deciduoustree" then
            inst:WatchWorldState("iswinter", function(inst, iswinter)
                inst:DoTaskInTime(FRAMES, updateactcondition)
            end)
        end

        inst:DoTaskInTime(FRAMES, updateactcondition)

        inst:ListenForEvent("onburnt", function(inst)
            if inst.components.ndnr_pluckable ~= nil then
                inst.components.ndnr_pluckable:SetActCondition(false)
                inst.components.ndnr_pluckable:ActionEnable()
            end
        end)
    end)
end