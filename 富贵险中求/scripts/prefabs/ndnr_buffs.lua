local BUFFS = {
    ndnr_poisondebuff = {
        duration = TUNING.TOTAL_DAY_TIME * 3,
        frequency = TUNING.JELLYBEAN_TICK_RATE * 5,
        onattachedfn = function(inst, target)
            target:AddTag("ndnr_poisoning")
        end,
        ontick = function(inst, target)
            if target.components.health ~= nil and not target.components.health:IsDead() and target.components.sanity ~= nil and not target:HasTag("playerghost") then
                target.components.health:DoDelta(-TUNING.JELLYBEAN_TICK_VALUE, nil, "ndnr_snake_poisoning", nil, nil, true)
                target.components.sanity:DoDelta(-TUNING.JELLYBEAN_TICK_VALUE / 2)
                if target._ispoisonover then
                    target._ispoisonover:set(true)
                    target:DoTaskInTime(0.5, function(inst)
                        inst._ispoisonover:set(false)
                    end)
                end
                if math.random() < 1 / 5 then
                    target.components.talker:Say(TUNING.NDNR_POISONHEADACHE)
                end
            else
                inst.components.debuff:Stop()
            end
        end,
        ondetachedfn = function(inst, target)
            target:RemoveTag("ndnr_poisoning")
        end,
    },
    ndnr_bloodoverdebuff = {
        duration = 40,
        frequency = TUNING.JELLYBEAN_TICK_RATE,
        ontick = function(inst, target)
            if target.components.health ~= nil and not target.components.health:IsDead() and not target:HasTag("playerghost") then
                target.components.health:DoDelta(-TUNING.JELLYBEAN_TICK_VALUE/2, nil, "ndnr_cat_attack", nil, nil, true)
                if target._isbloodoverbycat then
                    target._isbloodoverbycat:set(true)
                    target:DoTaskInTime(0.5, function(inst)
                        inst._isbloodoverbycat:set(false)
                    end)
                end
                if math.random() < 1 / 5 then
                    target.components.talker:Say(TUNING.NDNR_CATATTACKBLOODOVER)
                end
            else
                inst.components.debuff:Stop()
            end
        end
    },
    ndnr_dragoonpowerdebuff = {
        duration = 30,
        frequency = 1,
        ontick = function(inst, target, data)
            if target.components.health ~= nil and not target.components.health:IsDead() and not target:HasTag("playerghost") then
                local timeleft = inst.components.timer:GetTimeLeft("buffover")
                if timeleft >= 20 then
                    target.components.health:DoDelta(-3, nil, "ndnr_dragoonpower", nil, nil, true)
                elseif timeleft >= 10 and timeleft < 20 then
                    target.components.health:DoDelta(-2, nil, "ndnr_dragoonpower", nil, nil, true)
                else
                    target.components.health:DoDelta(-1, nil, "ndnr_dragoonpower", nil, nil, true)
                end
                if target._isbloodoverbycat then
                    target._isbloodoverbycat:set(true)
                    target:DoTaskInTime(0.5, function(inst)
                        inst._isbloodoverbycat:set(false)
                    end)
                end
            else
                inst.components.debuff:Stop()
            end
        end
    },
    ndnr_monsterpoisondebuff = {
        duration = TUNING.TOTAL_DAY_TIME * 70,
        frequency = TUNING.JELLYBEAN_TICK_RATE,
        ontick = function(inst, target)
            if target.components.health ~= nil and not target.components.health:IsDead() and not target:HasTag("player") then
                target.components.health:DoDelta(-4, nil, "monsterpoisoning")
                if math.random() < 1 / 5 then
                    if target.components.talker then
                        target.components.talker:Say(TUNING.NDNR_MONSTERPOISONHEADACHE)
                    end
                end
            else
                inst.components.debuff:Stop()
            end
        end
    },
    ndnr_coffeedebuff = {
        duration = TUNING.TOTAL_DAY_TIME/2,
        onattachedfn = function(inst, target)
            target.components.locomotor:SetExternalSpeedMultiplier(target, "ndnr_coffee", 11/6)
        end,
        ondetachedfn = function(inst, target)
            target.components.locomotor:RemoveExternalSpeedMultiplier(target, "ndnr_coffee")
        end
    },
    ndnr_dragoonheartdebuff = {
        duration = TUNING.TOTAL_DAY_TIME/2,
        onattachedfn = function(inst, target)
            target.components.combat.externaldamagemultipliers:SetModifier("ndnr_dragoonheartattack", 1.2)
            if target.components.talker then
                target.components.talker:Say(TUNING.NDNR_STRONGFROMDRAGONHEART)
            end
        end,
        ondetachedfn = function(inst, target)
            target.components.combat.externaldamagemultipliers:RemoveModifier("ndnr_dragoonheartattack")
            target.components.talker:Say(TUNING.NDNR_STRONGOVERFROMDRAGONHEART)
        end
    },
    ndnr_dragoonheartlavaeggdebuff = {
        duration = TUNING.TOTAL_DAY_TIME/2,
        onattachedfn = function(inst, target)
            target.components.combat.externaldamagemultipliers:SetModifier("ndnr_dragoonheartlavaeeggbuff", 2)
            if target.components.talker then
                target.components.talker:Say(TUNING.NDNR_STRONGFROMDRAGONHEARTLAVAE)
            end
        end,
        ondetachedfn = function(inst, target)
            target.components.combat.externaldamagemultipliers:RemoveModifier("ndnr_dragoonheartlavaeeggbuff")
            target.components.talker:Say(TUNING.NDNR_STRONGOVERFROMDRAGONHEARTLAVAE)
            target.components.debuffable:AddDebuff("ndnr_dragoonpowerdebuff", "ndnr_dragoonpowerdebuff")
        end
    },
    ndnr_snakeoildebuff = {
        duration = TUNING.TOTAL_DAY_TIME,
        onattachedfn = function(inst, target)
            target:AddTag("poisonresist")
        end,
        ondetachedfn = function(inst, target)
            target:RemoveTag("poisonresist")
        end
    },
    ndnr_butterdebuff = {
        duration = TUNING.TOTAL_DAY_TIME,
        onattachedfn = function(inst, target)
            target.components.locomotor:SetExternalSpeedMultiplier(target, "ndnr_butter", 1.25)
        end,
        ondetachedfn = function(inst, target)
            target.components.locomotor:RemoveExternalSpeedMultiplier(target, "ndnr_butter")
        end
    },
    ndnr_badmilkdebuff = {
        duration = TUNING.TOTAL_DAY_TIME,
        frequency = TUNING.JELLYBEAN_TICK_RATE,
        ontick = function(inst, target)
            if target:HasTag("player") and not target:HasTag("playerghost") then
                if math.random() < 1/15 then
                    if target.components.lootdropper == nil then
                        target:AddComponent("lootdropper")
                    end
                    target.components.lootdropper:SpawnLootPrefab("poop", target:GetPosition())
                    target.components.hunger:DoDelta(-10, nil, "badmilk")
                    target.components.sanity:DoDelta(-5, nil, "badmilk")
                    if target.components.talker and math.random() < .5 then
                        target.components.talker:Say(TUNING.NDNR_BAD_MILK)
                    end
                end
            else
                inst.components.debuff:Stop()
            end
        end
    },
    ndnr_plaguedebuff = {
        duration = TUNING.TOTAL_DAY_TIME * 3,
        frequency = TUNING.JELLYBEAN_TICK_RATE * 2,
        onattachedfn = function(inst, target)
            if not target:HasTag("ndnr_plague") then
                target:AddTag("ndnr_plague")
            end

            target.components.workmultiplier:AddMultiplier(ACTIONS.CHOP,   1/2, inst)
            target.components.workmultiplier:AddMultiplier(ACTIONS.MINE,   1/2, inst)
            target.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER, 1/2, inst)

            target.components.locomotor:SetExternalSpeedMultiplier(target, "ndnr_plague", 1/2)
        end,
        ontick = function(inst, target)
            if target:HasTag("player") and not target:HasTag("playerghost")
                and target.components.sanity then
                target.components.sanity:DoDelta(-1, nil, "ndnr_plague")
                if not target:HasTag("groggy") then target:AddTag("groggy") end
                if target.components.talker and math.random() < 1/5 then
                    target.components.talker:Say(TUNING.NDNR_PLAGUE)
                end

                -- 1/100概率会严重，掉半天血直到死亡
                if math.random() < 1/360 then
                    target:AddTag("ndnr_plagueserious")
                    target.components.debuffable:RemoveDebuff("ndnr_plaguedebuff")
                    target.components.debuffable:AddDebuff("ndnr_plague_seriousdebuff", "ndnr_plague_seriousdebuff")

                    if target.components.talker then
                        target.components.talker:Say(TUNING.NDNR_INFECTED_PLAGUE_SERIOUS)
                    end
                end
            else
                inst.components.debuff:Stop()
            end
        end,
        ondetachedfn = function(inst, target)
            if target:HasTag("ndnr_plagueserious") then

            else
                if not target:HasTag("ndnr_recoverybyantibiotic") then
                    if target.ndnr_antibody == nil then target.ndnr_antibody = 0 end
                    target.ndnr_antibody = target.ndnr_antibody + 1
                    target:PushEvent("ndnr_plague_recovery")
                end

                target:RemoveTag("ndnr_plague")
                target:RemoveTag("groggy")

                if target.components.workmultiplier ~= nil then
                    target.components.workmultiplier:RemoveMultiplier(ACTIONS.CHOP,   inst)
                    target.components.workmultiplier:RemoveMultiplier(ACTIONS.MINE,   inst)
                    target.components.workmultiplier:RemoveMultiplier(ACTIONS.HAMMER, inst)
                end

                if target.components.locomotor then
                    target.components.locomotor:RemoveExternalSpeedMultiplier(target, "ndnr_plague")
                end

                if target.components.timer then
                    target.components.timer:StartTimer("ndnr_plagueantibody", TUNING.TOTAL_DAY_TIME * 20)
                end

            end
        end
    },
    ndnr_plague_seriousdebuff = {
        duration = TUNING.TOTAL_DAY_TIME / 2,
        frequency = TUNING.JELLYBEAN_TICK_RATE / 2,
        ontick = function(inst, target)
            if target:HasTag("player") and not target:HasTag("playerghost") and target.components.health then
                target.components.health:DoDelta(-TUNING.JELLYBEAN_TICK_VALUE, nil, "ndnr_plague", nil, nil, true)
                if target.components.talker and math.random() < 1/5 then
                    target.components.talker:Say(TUNING.NDNR_PLAGUE)
                end
            else
                inst.components.debuff:Stop()
            end
        end,
        ondetachedfn = function(inst, target)
            if not target:HasTag("ndnr_recoverybyantibiotic") and
                not target:HasTag("playerghost") and
                target.components.health and
                target.components.health:GetPercent() > 0 then
                target.components.health:Kill()
            end

            target:RemoveTag("ndnr_plague")
            target:RemoveTag("groggy")
            target:RemoveTag("ndnr_recoverybyantibiotic")
            target:RemoveTag("ndnr_plagueserious")

            if target.components.workmultiplier ~= nil then
                target.components.workmultiplier:RemoveMultiplier(ACTIONS.CHOP,   inst)
                target.components.workmultiplier:RemoveMultiplier(ACTIONS.MINE,   inst)
                target.components.workmultiplier:RemoveMultiplier(ACTIONS.HAMMER, inst)
            end

            if target.components.locomotor then
                target.components.locomotor:RemoveExternalSpeedMultiplier(target, "ndnr_plague")
            end

            if target.components.timer then
                target.components.timer:StartTimer("ndnr_plagueantibody", TUNING.TOTAL_DAY_TIME * 20)
            end

        end
    },
    ndnr_tentacleblooddebuff = {
        duration = TUNING.TOTAL_DAY_TIME,
        onattachedfn = function(inst, target)
            target:AddTag("ndnr_tentacleking")
        end,
        ondetachedfn = function(inst, target)
            target:RemoveTag("ndnr_tentacleking")
        end
    },
    -- 棱镜的药酒buff
    buff_strengthenhancerdebuff = {
        duration = TUNING.TOTAL_DAY_TIME,
        onattachedfn = function(inst, target)
            if target.components.combat ~= nil then
                target.components.combat.externaldamagemultipliers:SetModifier("dish_medicinalliquor", 1.5) --攻击力系数乘以1.5倍
            end
        end,
        ondetachedfn = function(inst, target)
            if target.components.combat ~= nil then
                target.components.combat.externaldamagemultipliers:RemoveModifier("dish_medicinalliquor")
            end
        end
    },
    ndnr_snakewinedebuff = {
        duration = TUNING.TOTAL_DAY_TIME/2,
        onattachedfn = function(inst, target)
            if target.components.health ~= nil then
                target.components.health.externalabsorbmodifiers:SetModifier(inst, 1/3)
            end
        end,
        ondetachedfn = function(inst, target)
            if target.components.health ~= nil then
                target.components.health.externalabsorbmodifiers:RemoveModifier(inst)
            end
        end
    },
    ndnr_beepoisondebuff = {
        duration = 40,
        frequency = TUNING.JELLYBEAN_TICK_RATE,
        ontick = function(inst, target)
            if target.components.health ~= nil and not target.components.health:IsDead() and not target:HasTag("playerghost") then
                target.components.health:DoDelta(-TUNING.JELLYBEAN_TICK_VALUE/2, nil, "ndnr_killerbee_attack", nil, nil, true)
                if target._isbloodoverbycat then
                    target._isbloodoverbycat:set(true)
                    target:DoTaskInTime(0.5, function(inst)
                        inst._isbloodoverbycat:set(false)
                    end)
                end
                if math.random() < 1 / 5 then
                    target.components.talker:Say(TUNING.NDNR_BEEATTACKBLOODOVER)
                end
            else
                inst.components.debuff:Stop()
            end
        end
    },
    ndnr_repairgravedebuff1 = {
        duration = 50,
        frequency = TUNING.JELLYBEAN_TICK_RATE,
        ontick = function(inst, target)
            if target.components.sanity ~= nil and not target:HasTag("playerghost") then
                target.components.sanity:DoDelta(TUNING.JELLYBEAN_TICK_VALUE, nil, "ndnr_repairgrave")
                if math.random() < 1 / 13 then
                    target.components.talker:Say(TUNING.NDNR_REPAIRGRAVE)
                end
            else
                inst.components.debuff:Stop()
            end
        end
    },
    ndnr_repairgravedebuff2 = {
        duration = 25,
        frequency = TUNING.JELLYBEAN_TICK_RATE,
        ontick = function(inst, target)
            if target.components.sanity ~= nil and not target:HasTag("playerghost") then
                target.components.sanity:DoDelta(TUNING.JELLYBEAN_TICK_VALUE, nil, "ndnr_repairgrave")
                if math.random() < 1 / 7 then
                    target.components.talker:Say(TUNING.NDNR_REPAIRGRAVE)
                end
            else
                inst.components.debuff:Stop()
            end
        end
    },
    ndnr_albumenpowderdebuff = {
        duration = TUNING.TOTAL_DAY_TIME/2,
        onattachedfn = function(inst, target)
            if target.components.mightiness ~= nil then
                target:AddTag("ndnr_albumenpowder")

                target.components.talker:Say(TUNING.NDNR_ALBUMENPOWDER_START)
            end
        end,
        ondetachedfn = function(inst, target)
            if target.components.mightiness ~= nil then
                target:RemoveTag("ndnr_albumenpowder")

                target.components.talker:Say(TUNING.NDNR_ALBUMENPOWDER_END)
            end
        end
    },
    --[[
    ndnr_playerdeathdebuff = {
        duration = TUNING.TOTAL_DAY_TIME,
        onattachedfn = function(inst, target)
            target.components.ndnr_emo:AddEmorate("playerdeath", -1)
        end,
        ondetachedfn = function(inst, target)
            target.components.ndnr_emo:RemoveEmorate("playerdeath")
        end
    },
    ]]
}

local function MakeNdnrBuff(name, data)
    local function OnAttached(inst, target)
        inst.entity:SetParent(target.entity)
        inst.Transform:SetPosition(0, 0, 0) -- in case of loading
        if data.ontick then
            inst.task = inst:DoPeriodicTask(data.frequency, data.ontick, nil, target, data)
        end
        inst:ListenForEvent("death", function()
            inst.components.debuff:Stop()
        end, target)
        if data.onattachedfn then data.onattachedfn(inst, target) end

        if inst.prefab == "ndnr_bloodoverdebuff" then
            if not target:HasTag("attacked_bleeding") then
                target:AddTag("attacked_bleeding")
            end
        end
    end

    local function OnTimerDone(inst, d)
        if d.name == "buffover" then
            inst.components.debuff:Stop()
        end
    end

    local function OnExtended(inst, target)
        inst.components.timer:StopTimer("buffover")
        inst.components.timer:StartTimer("buffover", data.duration)
        if data.ontick then
            inst.task:Cancel()
            inst.task = inst:DoPeriodicTask(data.frequency, data.ontick, nil, target, data)
        end
    end

    local function OnDetached(inst, target)
        if target:HasTag("attacked_bleeding") then
            target:RemoveTag("attacked_bleeding")
        end
        if data.ondetachedfn then data.ondetachedfn(inst, target) end
        inst:Remove()
    end

    local function fn()
        local inst = CreateEntity()

        if not TheWorld.ismastersim then
            -- Not meant for client!
            inst:DoTaskInTime(0, inst.Remove)

            return inst
        end
        inst.entity:AddTransform()

        --[[Non-networked entity]]
        -- inst.entity:SetCanSleep(false)
        inst.entity:Hide()
        inst.persists = false

        inst:AddTag("CLASSIFIED")

        inst:AddComponent("debuff")
        inst.components.debuff:SetAttachedFn(OnAttached)
        inst.components.debuff:SetDetachedFn(OnDetached)
        inst.components.debuff:SetExtendedFn(OnExtended)
        inst.components.debuff.keepondespawn = true

        inst:AddComponent("timer")
        inst.components.timer:StartTimer("buffover", data.duration)
        inst:ListenForEvent("timerdone", OnTimerDone)

        return inst
    end

    return Prefab(name, fn)
end

local prefs = {}

for k, v in pairs(BUFFS) do
    table.insert(prefs, MakeNdnrBuff(k, v))
end

return unpack(prefs)