-- local function canrespawn(inst)
--     local pt = inst:GetPosition()
--     local trees = TheSim:FindEntities(pt.x, pt.y, pt.z, 20)
--     local count = 0
--     for k, v in pairs(trees) do
--         if v:HasTag("ndnr_palmtree") or v.prefab == "ndnr_coconut_sapling" then
--             count = count + 1
--         end
--     end
--     return count < 12
-- end

-- local function tryrespawnpalmtree(inst)
--     if not canrespawn(inst) then return end

--     local pt = inst:GetPosition()
--     local wantcount = math.random(1, 2)
--     local count = 0

--     for i = 1, 10 do
--         local theta = math.random() * 2 * PI
--         local radius = math.random(10,12)
--         pt.x = pt.x + math.cos(theta)*radius
--         pt.z = pt.z + math.sin(theta)*radius
--         local ent = SpawnPrefab("ndnr_coconut")
--         if TheWorld.Map:CanDeployPlantAtPoint(pt, ent) then
--             local tree = SpawnPrefab("ndnr_coconut_sapling")
--             tree.Transform:SetPosition(pt.x, pt.y, pt.z)
--             count = count + 1
--         end
--         ent:Remove()

--         if count >= wantcount then
--             break
--         end
--     end
-- end

-- local NDNR_RESPAWNPALMTREETIME = TUNING.TOTAL_DAY_TIME * 2 + math.random(0, TUNING.TOTAL_DAY_TIME)
-- AddPrefabPostInit("oasislake", function(inst)
--     if not TheWorld.ismastersim then
--         return inst
--     end

    -- if inst.components.timer == nil then
    --     inst:AddComponent("timer")
    -- end

    -- inst:DoTaskInTime(FRAMES, function(inst)
    --     if not inst.components.timer:TimerExists("ndnr_respawnpalmtreetimer") then
    --         inst.components.timer:StartTimer("ndnr_respawnpalmtreetimer", NDNR_RESPAWNPALMTREETIME)
    --     end
    -- end)

    -- inst:ListenForEvent("timerdone", function(inst, data)
    --     if data.name == "ndnr_respawnpalmtreetimer" then
    --         tryrespawnpalmtree(inst)
    --         inst.components.timer:StartTimer("ndnr_respawnpalmtreetimer", NDNR_RESPAWNPALMTREETIME)
    --     end
    -- end)

-- end)