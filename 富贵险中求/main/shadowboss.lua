-- def file: shadowchesspieces.lua
local shadows = {"shadow_rook", "shadow_knight", "shadow_bishop"}
for i, v in ipairs(shadows) do
    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then
            return inst
        end

        inst:DoTaskInTime(FRAMES, function(inst)
            if inst.ndnr_copied ~= nil and inst.ndnr_copied == true then
                if inst.components.lootdropper ~= nil and inst.components.lootdropper.DropLoot ~= nil then
                    inst.components.lootdropper.DropLoot = function(pt)
                    end
                end
            end
        end)

        inst:ListenForEvent("attacked", function(inst, data)
            -- print(inst.prefab.." is attacked, and the original damage is ", data.original_damage)
            if not inst.components.health:IsDead() or not inst.ndnr_copied then return end
            -- print("the copied "..inst.prefab.." is dead!!!")

            local onehitkilled = false
            if data.original_damage >= inst.components.health.maxhealth then
                -- print(inst.prefab.." is killed by one hit")
                onehitkilled = true
                return
            end

            if inst.ndnr_copieddeathcount == nil then inst.ndnr_copieddeathcount = {} end
            inst.ndnr_copieddeathcount[inst.prefab] = 1

            local candrop = true
            for i, vv in ipairs(shadows) do
                if inst.ndnr_copieddeathcount[vv] == nil then
                    candrop = false
                    break
                end
            end
            -- if candrop then print(inst.prefab.." has enough shadow power!!!") end

            if not onehitkilled then
                if candrop == false then
                    -- print(inst.prefab.." transfered it's shadow power")
                    local pt = inst:GetPosition()
                    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 20, {"epic"})
                    if ents then
                        for k, v in pairs(ents) do
                            if table.contains(shadows, v.prefab) and v.ndnr_copied then
                                if v.ndnr_copieddeathcount == nil then v.ndnr_copieddeathcount = {} end
                                v.ndnr_copieddeathcount[inst.prefab] = 1
                            end
                        end
                    end
                else
                    -- print(inst.prefab.." droped")
                    if inst.components.lootdropper then
                        inst:DoTaskInTime(FRAMES * 30, function(inst)
                            inst.components.lootdropper:SpawnLootPrefab("ndnr_armorvortexcloak", inst:GetPosition())
                        end)
                    end
                end
            end
        end)

        local onsave = inst.OnSave
        inst.OnSave = function(inst, data)
            if onsave then
                onsave(inst, data)
            end
            data.ndnr_copied = inst.ndnr_copied
            data.ndnr_copieddeathcount = inst.ndnr_copieddeathcount
        end

        local onload = inst.OnLoad
        inst.OnLoad = function(inst, data)
            if onload then
                onload(inst, data)
            end
            if data and data.ndnr_copied then
                inst.ndnr_copied = data.ndnr_copied
            end
            if data and data.ndnr_copieddeathcount then
                inst.ndnr_copieddeathcount = data.ndnr_copieddeathcount
            end
        end
    end)
end