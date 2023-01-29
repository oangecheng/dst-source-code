--[[
    合并到housesleep.lua
]]

-- local function PlaySleepLoopSoundTask(inst, stopfn)
--     inst.SoundEmitter:PlaySound("dontstarve/common/tent_sleep")
-- end

-- local function stopsleepsound(inst)
--     if inst.sleep_tasks ~= nil then
--         for i, v in ipairs(inst.sleep_tasks) do
--             v:Cancel()
--         end
--         inst.sleep_tasks = nil
--     end
-- end

-- local function startsleepsound(inst, len)
--     stopsleepsound(inst)
--     inst.sleep_tasks =
--     {
--         inst:DoPeriodicTask(len, PlaySleepLoopSoundTask, 33 * FRAMES),
--         inst:DoPeriodicTask(len, PlaySleepLoopSoundTask, 47 * FRAMES),
--     }
-- end

-- local function onignite(inst)
--     inst.components.sleepingbag:DoWakeUp()
-- end

-- local function onwake(inst, sleeper, nostatechange)
--     sleeper:RemoveEventCallback("onignite", onignite, inst)

--     if inst.sleep_anim ~= nil then
--         inst.AnimState:PushAnimation("idle", true)
--         stopsleepsound(inst)
--     end

--     if sleeper.components.talker ~= nil then
--         sleeper:DoTaskInTime(2, function()
--             sleeper.components.talker:Say(TUNING.NDNR_HERMITHOUSE_SLEEPING_COMFORTABLE)
--         end)
--     end
-- end

-- local function onsleep(inst, sleeper)
--     sleeper:ListenForEvent("onignite", onignite, inst)

--     -- if inst.sleep_anim ~= nil then
--     --     inst.AnimState:PlayAnimation(inst.sleep_anim, true)
--     --     startsleepsound(inst, inst.AnimState:GetCurrentAnimationLength())
--     -- end
-- end

-- local function temperaturetick(inst, sleeper)
--     if sleeper.components.temperature ~= nil then
--         if inst.is_cooling then
--             if sleeper.components.temperature:GetCurrent() > TUNING.SLEEP_TARGET_TEMP_TENT then
--                 sleeper.components.temperature:SetTemperature(sleeper.components.temperature:GetCurrent() - TUNING.SLEEP_TEMP_PER_TICK)
--             end
--         elseif sleeper.components.temperature:GetCurrent() < TUNING.SLEEP_TARGET_TEMP_TENT then
--             sleeper.components.temperature:SetTemperature(sleeper.components.temperature:GetCurrent() + TUNING.SLEEP_TEMP_PER_TICK)
--         end
--     end
-- end

-- AddPrefabPostInit("hermithouse", function(inst)

--     inst:AddTag("tent")
--     inst:AddTag("ndnr_sleepbuild_hermit")

--     if not TheWorld.ismastersim then
--         return inst
--     end

--     if inst.components.sleepingbag == nil then
--         inst:AddComponent("sleepingbag")
--         inst.components.sleepingbag.onsleep = onsleep
--         inst.components.sleepingbag.onwake = onwake
--         inst.components.sleepingbag.health_tick = TUNING.SLEEP_HEALTH_PER_TICK * 2
--         inst.components.sleepingbag.sanity_tick = TUNING.SLEEP_HEALTH_PER_TICK * 2
--         --convert wetness delta to drying rate
--         inst.components.sleepingbag.dryingrate = math.max(0, -TUNING.SLEEP_WETNESS_PER_TICK / TUNING.SLEEP_TICK_PERIOD)
--         inst.components.sleepingbag:SetTemperatureTickFn(temperaturetick)
--     end
-- end)