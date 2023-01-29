local house = {
    pighouse = {
        health = TUNING.SLEEP_HEALTH_PER_TICK * 2,
        sanity = 0,
        tag = "ndnr_sleepbuild_pig",
        debuff = function(inst, sleeper)
            if math.random() < 1/2 then
                if sleeper.components.sanity ~= nil then
                    sleeper.components.sanity:DoDelta(-TUNING.SANITY_MEDLARGE)
                    if sleeper.components.talker ~= nil then
                        sleeper:DoTaskInTime(2, function()
                            sleeper.components.talker:Say(TUNING.NDNR_PIGHOUSE_SLEEPING_DIRTY)
                        end)
                    end
                end
            else
                if sleeper.components.talker ~= nil then
                    sleeper:DoTaskInTime(2, function()
                        sleeper.components.talker:Say(TUNING.NDNR_PIGHOUSE_SLEEPING_COMFORTABLE)
                    end)
                end
            end
        end
    },
    mermhouse = {
        health = TUNING.SLEEP_HEALTH_PER_TICK,
        sanity = TUNING.SLEEP_SANITY_PER_TICK,
        tag = "ndnr_sleepbuild_fishman",
    },
    mermhouse_crafted = {
        health = TUNING.SLEEP_HEALTH_PER_TICK,
        sanity = TUNING.SLEEP_SANITY_PER_TICK,
        tag = "ndnr_sleepbuild_fishman",
    },
    hermithouse = {
        health = TUNING.SLEEP_HEALTH_PER_TICK * 2,
        sanity = TUNING.SLEEP_SANITY_PER_TICK * 2,
        emo = TUNING.SLEEP_SANITY_PER_TICK * 0.5,
        tag = "ndnr_sleepbuild_hermit",
    },
}

for k, v in pairs(house) do
    local function PlaySleepLoopSoundTask(inst, stopfn)
        inst.SoundEmitter:PlaySound("dontstarve/common/tent_sleep")
    end

    local function stopsleepsound(inst)
        if inst.sleep_tasks ~= nil then
            for i, v in ipairs(inst.sleep_tasks) do
                v:Cancel()
            end
            inst.sleep_tasks = nil
        end
    end

    local function startsleepsound(inst, len)
        stopsleepsound(inst)
        inst.sleep_tasks =
        {
            inst:DoPeriodicTask(len, PlaySleepLoopSoundTask, 33 * FRAMES),
            inst:DoPeriodicTask(len, PlaySleepLoopSoundTask, 47 * FRAMES),
        }
    end

    local function onignite(inst)
        inst.components.sleepingbag:DoWakeUp()
    end

    local function onwake(inst, sleeper, nostatechange)
        sleeper:RemoveEventCallback("onignite", onignite, inst)

        if inst.sleep_anim ~= nil then
            inst.AnimState:PushAnimation("idle", true)
            stopsleepsound(inst)
        end

        if v.debuff ~= nil then
            v.debuff(inst, sleeper)
        end
    end

    local function onsleep(inst, sleeper)
        sleeper:ListenForEvent("onignite", onignite, inst)

        -- if inst.sleep_anim ~= nil then
        --     inst.AnimState:PlayAnimation(inst.sleep_anim, true)
        --     startsleepsound(inst, inst.AnimState:GetCurrentAnimationLength())
        -- end
    end

    local function temperaturetick(inst, sleeper)
        if sleeper.components.temperature ~= nil then
            if inst.is_cooling then
                if sleeper.components.temperature:GetCurrent() > TUNING.SLEEP_TARGET_TEMP_TENT then
                    sleeper.components.temperature:SetTemperature(sleeper.components.temperature:GetCurrent() - TUNING.SLEEP_TEMP_PER_TICK)
                end
            elseif sleeper.components.temperature:GetCurrent() < TUNING.SLEEP_TARGET_TEMP_TENT then
                sleeper.components.temperature:SetTemperature(sleeper.components.temperature:GetCurrent() + TUNING.SLEEP_TEMP_PER_TICK)
            end
        end
    end

    AddPrefabPostInit(k, function(inst)

        inst:AddTag("tent")
        inst:AddTag(v.tag)

        if not TheWorld.ismastersim then
            return inst
        end

        if inst.components.sleepingbag == nil then
            inst:AddComponent("sleepingbag")
            inst.components.sleepingbag.onsleep = onsleep
            inst.components.sleepingbag.onwake = onwake
            inst.components.sleepingbag.health_tick = v.health
            inst.components.sleepingbag.sanity_tick = v.sanity
            --convert wetness delta to drying rate
            inst.components.sleepingbag.dryingrate = math.max(0, -TUNING.SLEEP_WETNESS_PER_TICK / TUNING.SLEEP_TICK_PERIOD)
            inst.components.sleepingbag:SetTemperatureTickFn(temperaturetick)
        end
    end)
end
