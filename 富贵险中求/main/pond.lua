local ponds = {"pond", "pond_mos"}
for i, v in ipairs(ponds) do
    local function OnSnowLevel(inst, snowlevel)
        if inst.components.ndnr_pluckable ~= nil then
            if inst.frozen then
                inst.components.ndnr_pluckable:SetActCondition(false)
            else
                inst.components.ndnr_pluckable:SetActCondition(true)
            end
            inst.components.ndnr_pluckable:ActionEnable()
        end
    end
    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then return inst end

        inst:DoTaskInTime(FRAMES, function(inst)
            inst:WatchWorldState("snowlevel", OnSnowLevel)
        end)
        inst:DoTaskInTime(1, OnSnowLevel)
    end)
end

------------------------------------------------------------------------------

local function dofn(inst, doer, target)
    -- if target.SoundEmitter ~= nil then
    --     target.SoundEmitter:PlaySound("terraria1/eyemask/eat")
    -- end
end

local fish = {fishmeat_small = 1/6, fishmeat = 1/3, eel = 1/3}
for k, v in pairs(fish) do
    AddPrefabPostInit(k, function(inst)
        inst._actionstr = "FISH"

        if not TheWorld.ismastersim then return inst end

        inst:AddComponent("ndnr_repair")
        inst.components.ndnr_repair:SetAmount(v)
        inst.components.ndnr_repair:SetDoFn(dofn)

    end)
end

------------------------------------------------------------------------------

-- local easing = require("easing")
-- local NOTAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO", "burnt", "player", "monster" }
-- local ONEOFTAGS = { "fire", "smolder" }
-- local RANDOM_OFFSET_MAX = TUNING.WATERPUMP.MAXRANGE
-- local function LaunchProjectile(inst)
--     -- CancelLaunchProjectileTask(inst)

--     local x, y, z = inst.Transform:GetWorldPosition()

--     -- if not TheWorld.Map:IsVisualGroundAtPoint(x,y,z) then
--         local ents = TheSim:FindEntities(x, y, z, TUNING.WATERPUMP.MAXRANGE, nil, NOTAGS, ONEOFTAGS)
--         local targetpos
--         if #ents > 0 then
--             targetpos = ents[1]:GetPosition()
--         else
--             local theta = math.random() * 2 * PI
--             local offset = math.random() * RANDOM_OFFSET_MAX
--             targetpos = Point(x + math.cos(theta) * offset, 0, z + math.sin(theta) * offset)
--         end

--         local projectile = SpawnPrefab("waterstreak_projectile")
--         projectile.Transform:SetPosition(x, 2, z)
--         projectile.AnimState:SetAddColour(202/255, 74/255, 11/255, 1)

--         local dx = targetpos.x - x
--         local dz = targetpos.z - z
--         local rangesq = dx * dx + dz * dz
--         local maxrange = TUNING.WATERPUMP.MAXRANGE
--         local speed = easing.linear(rangesq, 15, 3, maxrange * maxrange)
--         projectile.components.complexprojectile:SetHorizontalSpeed(speed)
--         projectile.components.complexprojectile:SetGravity(-25)
--         projectile.components.complexprojectile:Launch(targetpos, inst, inst)
--     -- end
-- end
-- AddPrefabPostInit("lava_pond", function(inst)
--     if not TheWorld.ismastersim then return inst end

--     inst:DoPeriodicTask(1, function(inst)
--         LaunchProjectile(inst)
--     end)
-- end)

------------------------------------------------------------------------------