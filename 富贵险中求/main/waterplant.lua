local function respawntask(inst)
    if not inst.components.timer:TimerExists("ndnr_waterplantrespawntimer") then
        inst.components.timer:StartTimer("ndnr_waterplantrespawntimer", TUNING.TOTAL_DAY_TIME * 20 + math.random(TUNING.TOTAL_DAY_TIME))
    end
end

local function ontimerdone(inst, data)
    if data.name == "ndnr_waterplantrespawntimer" then
        local x,y,z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 16, {"waterplant"})
        for i, v in ipairs(ents) do
            if v.prefab == "waterplant_rock" then
                local waterplant_planter = SpawnPrefab("waterplant_planter")
                if waterplant_planter and v.components.upgradeable then
                    v.components.upgradeable:Upgrade(waterplant_planter)
                end
                break
            end
        end
        respawntask(inst)
    end
end

AddPrefabPostInit("waterplant", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    if inst.components.timer == nil then
        inst:AddComponent("timer")
    end

    inst:DoTaskInTime(FRAMES, respawntask)

    inst:ListenForEvent("timerdone", ontimerdone)
end)