


local function OnPlayerJoined(world)
    local clientObjs = TheNet:GetClientTable() or {}
    -- for i, client in pairs(clientObjs) do
    --     -- client: {"base_skin":"wilson_none","eventlevel":0,"muted":false,"admin":true,"playerage":23,"userid":"OU_760565","friend":true,"performance":0,"vanity":[],"userflags":1,"name":"朋也","colour":[0.80392158031464,0.3098039329052,0.22352941334248,1],"netid":"76560565","equip":[],"prefab":"wilson","lobbycharacter":""}

    -- end

    local count = 0
    local hasdeathplayer = false
    for i, v in ipairs(AllPlayers) do
        if not v:HasTag("playerghost") then
            count = count + 1
        else
            hasdeathplayer = true
        end
    end
    for i, v in ipairs(AllPlayers) do
        if v.components.ndnr_emo and not v:HasTag("playerghost") and hasdeathplayer then
            v.components.debuffable:AddDebuff("ndnr_playerdeathdebuff", "ndnr_playerdeathdebuff")
        end
    end
    if count > 1 then
        for i, v in ipairs(AllPlayers) do
            if v.components.ndnr_emo then
                v.components.ndnr_emo:AddEmorate("friend", (count-1)/2)
            end
        end
    else
        for i, v in ipairs(AllPlayers) do
            if v.components.ndnr_emo then
                v.components.ndnr_emo:RemoveEmorate("friend")
            end
        end
    end
end

local function EmorateWithPet(inst)
    if inst.components.ndnr_emo then
        if inst.components.petleash then
            local count = inst.components.petleash:GetNumPets()
            if count > 0 then
                inst.components.ndnr_emo:AddEmorate("pet", 0.5)
            else
                inst.components.ndnr_emo:RemoveEmorate("pet")
            end
        end
    end
end

local function ChangeEmoRate(inst)
    if not inst.components.ndnr_emo then return end
    if TheWorld.state.iswinter then
        inst.components.ndnr_emo:AddEmorate("winter", -0.25)
    else
        inst.components.ndnr_emo:RemoveEmorate("winter")
    end
    if TheWorld.state.israining or TheWorld.state.issnowing then
        inst.components.ndnr_emo:AddEmorate("rain", -0.25)
    else
        inst.components.ndnr_emo:RemoveEmorate("rain")
    end
    if TheWorld.state.isnight then
        inst.components.ndnr_emo:AddEmorate("night", -0.25)
    else
        inst.components.ndnr_emo:RemoveEmorate("night")
    end
    if TheWorld.state.isdusk then
        inst.components.ndnr_emo:AddEmorate("dusk", -0.125)
    else
        inst.components.ndnr_emo:RemoveEmorate("dusk")
    end

    -- EmorateWithPet(inst)
end

local function oneat(inst, data)
    local food = data.food
    if not table.contains(TUNING.NDNR_NOT_GOUT_PLAYER, inst.prefab) then
        if table.containskey(TUNING.NDNR_GOUT_FOODS, food.prefab) then
            if inst.ndnr_gout == nil then
                inst.ndnr_gout = 0
            end
            inst.ndnr_gout = inst.ndnr_gout + TUNING.NDNR_GOUT_FOODS[food.prefab]
        end
    end

    if food.prefab == "ndnr_yogurt" then
        inst.ndnr_gout = inst.ndnr_gout == nil and 0 or math.max(0, inst.ndnr_gout - 10)
    end

    --[[
    if inst.components.ndnr_emo and inst.components.foodaffinity then
        if inst.components.foodaffinity:HasAffinity(food) and not inst.components.timer:TimerExists("ndnr_affinityfood") then
            inst.components.ndnr_emo:DoDelta(5)
            inst.components.timer:StartTimer("ndnr_affinityfood", TUNING.TOTAL_DAY_TIME)
        end
    end
    ]]

end

local function OnPoisonover(inst)
    if ThePlayer and not TheNet:IsDedicated() then
        inst:PushEvent(inst._ispoisonover:value() and "startpoisonover" or "stoppoisonover", {target = inst})
    end
end

local function OnBloodoverByCat(inst)
    if ThePlayer and not TheNet:IsDedicated() then
        inst:PushEvent(inst._isbloodoverbycat:value() and "startbloodover_cat" or "stopbloodover_cat", {target = inst})
    end
end

local function OnChineseFestival(inst)
    if ThePlayer and not TheNet:IsDedicated() then
        inst:PushEvent(inst._chinesefestival:value() and "startchinesefestival" or "stopchinesefestival", {target = inst, festival = inst._chinesefestivalvalue:value()})
    end
end

-- local function calchealth(inst)
--     if inst.prefab ~= "wx78" then
--         local origin_maxhealth = inst.origin_maxhealth or inst.components.health.maxhealth
--         local health_percent = inst.components.health:GetPercent()
--         inst.components.health.maxhealth = math.min(500, math.ceil(origin_maxhealth * (1+inst.ndnr_antibody/10)))
--         inst.components.health:SetPercent(health_percent)
--     end
-- end

local function init_player_data(inst)
    -- if inst.origin_maxhealth == nil and inst.components.health then
    --     inst.origin_maxhealth = inst.components.health.maxhealth
    -- end

    -- if inst.ndnr_antibody == nil then
    --     inst.ndnr_antibody = 0
    -- end

    -- 被感染寄生虫时吃食物的逻辑-----------------
    if inst.ndnr_parasite == nil then
        inst.ndnr_parasite = false
    end
    if inst.components.eater ~= nil then
        local custom_stats_mod_fn = inst.components.eater.custom_stats_mod_fn
        inst.components.eater.custom_stats_mod_fn = function(inst, health_delta, hunger_delta, sanity_delta, food, feeder)
            if custom_stats_mod_fn ~= nil then
                health_delta, hunger_delta, sanity_delta = custom_stats_mod_fn(inst, health_delta, hunger_delta, sanity_delta, food, feeder)
            end
            if TheWorld.net and TheWorld.net.mod_ndnr and TheWorld.net.mod_ndnr.isdongzhi then
                health_delta = health_delta * 2
            end
            --[[
            if inst.components.ndnr_emo then
                local emopercent = inst.components.ndnr_emo:GetPercent()
                if emopercent >= 0.4 and emopercent < 0.7 then
                    health_delta = health_delta * 0.75
                elseif emopercent >= 0.1 and emopercent < 0.4 then
                    health_delta = health_delta * 0.5
                elseif emopercent < 0.1 xthen
                    health_delta = health_delta * 0.25
                end
            end
            ]]
            return health_delta, inst.ndnr_parasite == true and hunger_delta/2 or hunger_delta, sanity_delta
        end
    end
    -------------------------------------------

    -- calchealth(inst)

    -- festival: qixi, dongzhi
    if TheWorld.net and TheWorld.net.mod_ndnr and TheWorld.net.mod_ndnr.current_date then
        if TheWorld.net.mod_ndnr.isqixi then
            if inst._chinesefestival ~= nil then
                inst._chinesefestival:set(true)
                inst._chinesefestivalvalue:set("qixi")
                inst:DoTaskInTime(TUNING.TOTAL_DAY_TIME, function(inst)
                    inst._chinesefestival:set(false)
                end)
            end
        end

        if TheWorld.net.mod_ndnr.isdongzhi then
            if inst._chinesefestival ~= nil then
                inst._chinesefestival:set(true)
                inst._chinesefestivalvalue:set("dongzhi")
                inst:DoTaskInTime(TUNING.TOTAL_DAY_TIME, function(inst)
                    inst._chinesefestival:set(false)
                end)
            end
        end
    end

    if inst.ndnr_gout == nil then
        inst.ndnr_gout = 0
    end

    if inst.ndnr_evilvalue == nil then
        inst.ndnr_evilvalue = 0
    end

    --[[
    if inst.components.ndnr_emo then
        inst.player_defaultdamagemultiplier = inst.components.combat.damagemultiplier
        ChangeEmoRate(inst)
        OnPlayerJoined()
    end
    ]]
end

local function zhongyuantask(inst)
    if inst.ndnr_zhongyuantask == nil then
        inst.ndnr_zhongyuantask = inst:DoPeriodicTask(3, function(inst)
            local pt = inst:GetPosition()
            local theta = math.random() * 2 * PI
            local radius = math.random(8,16)
            pt.x = pt.x + math.cos(theta)*radius
            pt.z = pt.z + math.sin(theta)*radius
            local ent = SpawnPrefab("ghost")
            -- ent.ndnr_zhongyuan = true
            ent.Transform:SetPosition(pt.x, pt.y, pt.z)
            if ent.sg ~= nil then
                ent.sg:GoToState("appear")
            end
        end)
    end
end

local function onnight(inst)
    if TheWorld.net and TheWorld.net.mod_ndnr and TheWorld.net.mod_ndnr.current_date then
        if TheWorld.net.mod_ndnr.iszhongyuan and TheWorld.state.isnight then
            if inst.mod_ndnr == nil or inst.mod_ndnr.zhongyuan == nil then inst.mod_ndnr = {zhongyuan = {}} end
            if not inst.mod_ndnr.zhongyuan["ndnr_"..TheWorld.net.mod_ndnr.current_date] then

                if inst._chinesefestival ~= nil then
                    inst._chinesefestival:set(true)
                    inst._chinesefestivalvalue:set("zhongyuan")
                    inst:DoTaskInTime(TUNING.TOTAL_DAY_TIME, function(inst)
                        inst._chinesefestival:set(false)
                    end)
                end

                inst.mod_ndnr.zhongyuan["ndnr_"..TheWorld.net.mod_ndnr.current_date] = true
                zhongyuantask(inst)
            end
        end
    end

    -- 触发痛风
    if TheWorld.state.isnight then
        if inst.ndnr_gout and inst.ndnr_gout >= 100 then
            if inst.components.locomotor then
                inst.components.locomotor:SetExternalSpeedMultiplier(inst, "ndnr_gout", 0.5)
                inst.ndnr_gouting = true

                inst.ndnr_gouttalkertask = inst:DoPeriodicTask(2, function(inst)
                    if inst.components.talker and math.random() < 1/5 then
                        inst.components.talker:Say(NDNR_GOUTSTART[math.random(#NDNR_GOUTSTART)])
                    end
                end)
            end
        end
    end

    -- ChangeEmoRate(inst)
end

local function onday(inst)
    if TheWorld.state.isday then
        -- canel zhongyuan task
        if inst.ndnr_zhongyuantask ~= nil then
            inst.ndnr_zhongyuantask:Cancel()
            inst.ndnr_zhongyuantask = nil
        end

        -- 解除痛风
        if inst.components.locomotor then
            inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "ndnr_gout")

            if inst.ndnr_gouting then
                inst:DoTaskInTime(3, function(inst)
                    if inst.components.talker then
                        inst.components.talker:Say(NDNR_GOUTOVER)
                    end
                end)
            end
        end

        if inst.ndnr_gouttalkertask ~= nil then
            inst.ndnr_gouttalkertask:Cancel();
            inst.ndnr_gouttalkertask = nil
        end

        inst.ndnr_gout =  inst.ndnr_gout == nil and 0 or math.max(0, inst.ndnr_gout - 7)
    end
end

local function onplucked(inst, data)
    local days_survived = inst.components.age ~= nil and inst.components.age:GetAgeInDays() or TheWorld.state.cycles
    if days_survived < 3 then return end

    local doer = data.doer
    local target = data.target
    doer.ndnr_evilvalue = (doer.ndnr_evilvalue == nil and 0 or doer.ndnr_evilvalue) + (target.components.ndnr_pluckable.evil or 1)

    if (TUNING.NDNR_EVILVALUEDAMAGE[doer.ndnr_evilvalue] and math.random() < TUNING.NDNR_EVILVALUEDAMAGE[doer.ndnr_evilvalue]) or doer.ndnr_evilvalue >= 100 then
        local x, y, z = doer.Transform:GetWorldPosition()
        local angle = math.random() * 2 * PI
        local offset = 12 + math.random() * 8
        local spawn_x = x + offset * math.cos(angle)
        local spawn_z = z - offset * math.sin(angle)

        local fissure = SpawnPrefab("ndnr_fissure")
        fissure.Transform:SetPosition(spawn_x, 0, spawn_z)
        fissure.ndnr_combattarget = doer
        if fissure.ndnr_spawnchild ~= nil then
            fissure.ndnr_spawnchild(fissure)
        end

        doer.ndnr_evilvalue = 0
    end
end

local function onemodelta(inst, data)
    local newpercent = data.newpercent

    if inst.prefab ~= "wes" then
        if inst.components.efficientuser == nil then
            inst:AddComponent("efficientuser")
        end
        if inst.components.workmultiplier == nil then
            inst:AddComponent("workmultiplier")
        end
        if newpercent >= 0.7 then
            inst.components.workmultiplier:RemoveMultiplier(ACTIONS.CHOP, inst)
            inst.components.workmultiplier:RemoveMultiplier(ACTIONS.MINE, inst)
            inst.components.workmultiplier:RemoveMultiplier(ACTIONS.HAMMER, inst)

            inst.components.efficientuser:RemoveMultiplier(ACTIONS.CHOP, inst)
            inst.components.efficientuser:RemoveMultiplier(ACTIONS.MINE, inst)
            inst.components.efficientuser:RemoveMultiplier(ACTIONS.HAMMER, inst)
            inst.components.efficientuser:RemoveMultiplier(ACTIONS.ATTACK, inst)
            inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "ndnr_emo")

            inst.components.combat.damagemultiplier = inst.player_defaultdamagemultiplier or 1
        elseif newpercent >= 0.4 and newpercent < 0.7 then
            inst.components.workmultiplier:AddMultiplier(ACTIONS.CHOP,   0.75, inst)
            inst.components.workmultiplier:AddMultiplier(ACTIONS.MINE,   0.75, inst)
            inst.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER, 0.75, inst)

            inst.components.efficientuser:AddMultiplier(ACTIONS.CHOP,   0.75, inst)
            inst.components.efficientuser:AddMultiplier(ACTIONS.MINE,   0.75, inst)
            inst.components.efficientuser:AddMultiplier(ACTIONS.HAMMER, 0.75, inst)
            -- inst.components.efficientuser:AddMultiplier(ACTIONS.ATTACK, 0.75, inst)
            inst.components.locomotor:SetExternalSpeedMultiplier(inst, "ndnr_emo", 0.9)
        elseif newpercent >= 0.1 and newpercent < 0.4 then
            inst.components.workmultiplier:AddMultiplier(ACTIONS.CHOP, 0.5, inst)
            inst.components.workmultiplier:AddMultiplier(ACTIONS.MINE, 0.5, inst)
            inst.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER, 0.5, inst)

            inst.components.efficientuser:AddMultiplier(ACTIONS.CHOP,   0.5, inst)
            inst.components.efficientuser:AddMultiplier(ACTIONS.MINE,   0.5, inst)
            inst.components.efficientuser:AddMultiplier(ACTIONS.HAMMER, 0.5, inst)
            inst.components.efficientuser:AddMultiplier(ACTIONS.ATTACK, 0.5, inst)
            inst.components.locomotor:SetExternalSpeedMultiplier(inst, "ndnr_emo", 0.75)

            inst.components.combat.damagemultiplier = 0.75
        elseif newpercent < 0.1 then
            inst.components.workmultiplier:AddMultiplier(ACTIONS.CHOP,   0.25, inst)
            inst.components.workmultiplier:AddMultiplier(ACTIONS.MINE,   0.25, inst)
            inst.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER, 0.25, inst)

            inst.components.efficientuser:AddMultiplier(ACTIONS.CHOP,   0.25, inst)
            inst.components.efficientuser:AddMultiplier(ACTIONS.MINE,   0.25, inst)
            inst.components.efficientuser:AddMultiplier(ACTIONS.HAMMER, 0.25, inst)
            inst.components.efficientuser:AddMultiplier(ACTIONS.ATTACK, 0.25, inst)
            inst.components.locomotor:SetExternalSpeedMultiplier(inst, "ndnr_emo", 0.5)

            inst.components.combat.damagemultiplier = 0.5
        end
    end
end


AddPlayerPostInit(function(inst)
    inst:AddTag("self_smearable")
    inst._actionstr = "SMEAR"

    if table.contains(TUNING.NDNR_NOSLEEPER, inst.prefab) then
        inst:AddTag("ndnr_nosleeper")
    end

    local gender = GetGender(inst.prefab)
    if gender == "ROBOT" then
        inst:AddTag("ndnr_robot")
    end

    inst._ispoisonover = net_bool(inst.GUID, "poisonover._ispoisonover", "poisonover")
    inst._isbloodoverbycat = net_bool(inst.GUID, "catattack._isbloodoverbycat", "bloodoverbycat")
    inst._chinesefestival = net_bool(inst.GUID, "chinesefestival._chinesefestival", "chinesefestival")
    inst._chinesefestivalvalue = net_string(inst.GUID, "chinesefestival._chinesefestivalvalue", "chinesefestivalvalue")

    inst:ListenForEvent("poisonover", OnPoisonover, inst)
    inst:ListenForEvent("bloodoverbycat", OnBloodoverByCat, inst)
    inst:ListenForEvent("chinesefestival", OnChineseFestival, inst)

    if not TheWorld.ismastersim then
        return inst
    end

    if not inst.components.timer then
        inst:AddComponent("timer")
    end

    if not inst.components.ndnr_bufftime then
        inst:AddComponent("ndnr_bufftime")
    end
    --[[
    if not inst.components.ndnr_emo and not table.contains(TUNING.NDNR_NO_EMOSTATUS_PLAYER, inst.prefab) then
        inst:AddComponent("ndnr_emo")
    end
    

    if inst.components.petleash then
        local old_onspawnfn = inst.components.petleash.onspawnfn
        inst.components.petleash.onspawnfn = function(inst, pet)
            old_onspawnfn(inst, pet)
            EmorateWithPet(inst)
        end
        local old_ondespawnfn = inst.components.petleash.ondespawnfn
        inst.components.petleash.ondespawnfn = function(inst, pet)
            old_ondespawnfn(inst, pet)
            EmorateWithPet(inst)
        end
    end
    ]]
    

    ----------------------------------------------------------------------------------------------------

    -- inst:ListenForEvent("ndnr_plague_recovery", calchealth)
    inst:ListenForEvent("ms_becameghost", function(inst)
        if not table.contains(TUNING.NDNR_NOT_PARASITEPLAYERS, inst.prefab) then
            -- inst:AddTag("ndnr_recoverybyantibiotic")
            -- inst.components.debuffable:RemoveDebuff("ndnr_plaguedebuff")
            -- inst.components.debuffable:RemoveDebuff("ndnr_plague_seriousdebuff")

            -- inst.ndnr_antibody = 0
            -- calchealth(inst)

            inst.ndnr_parasite = false
        end

        --[[
        if inst.components.ndnr_emo then
            inst.components.ndnr_emo.current = 100
            inst.components.ndnr_emo:RemoveAllEmorate()
            inst.components.debuffable:RemoveDebuff("ndnr_playerdeathdebuff")
            OnPlayerJoined()
        end
        ]]
    end)

    -- 惊蜇打雷事件
    inst:ListenForEvent("ndnr_chinese_festival_thunder", function(world)
        if TheWorld.net and TheWorld.net.mod_ndnr and TheWorld.net.mod_ndnr.current_date then
            if inst.mod_ndnr == nil or inst.mod_ndnr.jingzhe == nil then inst.mod_ndnr = {jingzhe = {}} end
            if not inst.mod_ndnr.jingzhe["ndnr_"..TheWorld.net.mod_ndnr.current_date] then

                inst.mod_ndnr.jingzhe["ndnr_"..TheWorld.net.mod_ndnr.current_date] = true

                if inst._chinesefestival ~= nil then
                    inst._chinesefestival:set(true)
                    inst._chinesefestivalvalue:set("jingzhe")
                    inst:DoTaskInTime(TUNING.TOTAL_DAY_TIME, function(inst)
                        inst._chinesefestival:set(false)
                    end)
                end

                local pt = inst:GetPosition()
                local num_lightnings = 9
                inst:StartThread(function()
                    for k = 0, num_lightnings do
                        local rad = math.random(3, 15)
                        local angle = k * 4 * PI / num_lightnings
                        local pos = pt + Vector3(rad * math.cos(angle), 0, rad * math.sin(angle))
                        TheWorld:PushEvent("ms_sendlightningstrike", pos)
                        Sleep(3 + math.random() * .2)
                    end
                end)
            end
        end
    end, TheWorld)

    -- 清明下雨事件
    inst:ListenForEvent("ndnr_chinese_festival_rain", function(world)
        if TheWorld.net and TheWorld.net.mod_ndnr and TheWorld.net.mod_ndnr.current_date then
            if inst.mod_ndnr == nil or inst.mod_ndnr.qingming == nil then inst.mod_ndnr = {qingming = {}} end
            if not inst.mod_ndnr.qingming["ndnr_"..TheWorld.net.mod_ndnr.current_date] then
                inst.mod_ndnr.qingming["ndnr_"..TheWorld.net.mod_ndnr.current_date] = true

                TheWorld:PushEvent("ms_forceprecipitation", true)

                if inst._chinesefestival ~= nil then
                    inst._chinesefestival:set(true)
                    inst._chinesefestivalvalue:set("qingming")
                    inst:DoTaskInTime(TUNING.TOTAL_DAY_TIME, function(inst)
                        inst._chinesefestival:set(false)
                    end)
                end
            end
        end
    end, TheWorld)

    inst:WatchWorldState("isnight", onnight)
    inst:WatchWorldState("isday", onday)
    inst:ListenForEvent("oneat", oneat)
    inst:ListenForEvent("ndnr_plucked", onplucked)

    --[[
    inst:WatchWorldState("season", ChangeEmoRate)
    inst:WatchWorldState("israining", ChangeEmoRate)
    inst:WatchWorldState("issnowing", ChangeEmoRate)
    inst:WatchWorldState("isdusk", ChangeEmoRate)
    inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, TheWorld)
    inst:ListenForEvent("ms_playerleft", OnPlayerJoined, TheWorld)
    inst:ListenForEvent("ms_respawnedfromghost", OnPlayerJoined)
    ]]

    inst:DoTaskInTime(0, init_player_data)

    inst:ListenForEvent("timerdone", function(inst, data)
        if data.name == "ndnr_stewedmushroom" then
            if inst.components.sanity ~= nil then
                inst.components.sanity:SetInducedInsanity("ndnr_stewedmushroom", false)
            end
        end
        --[[
        if data.name == "ndnr_emo_timer" then
            if inst.components.health.currenthealth > 0 then
                inst.components.health:DoDelta(-inst.components.health.currenthealth, nil, "ndnr_emo", nil, nil, true)
            end
        end
        ]]
    end)

    inst:ListenForEvent("attacked", function(world, data)
        --[[
            3333	attacked	original_damage	100.05
            3333	attacked	stimuli	darkness
            3333	attacked	damageresolved	15.0075
            3333	attacked	damage	20.01
        ]]
        if inst.components.ndnr_emo and data.stimuli == "darkness" then
            inst.components.ndnr_emo:DoDelta(20)
            TheNet:Announce(string.format(NDNR_CHARLIE_SAY_HELLO, inst:GetDisplayName()))
        end
    end)

    -- inst:ListenForEvent("emodelta", onemodelta)


    ----------------------------------------------------------------------------------------------------

    local onsave = inst.OnSave
    inst.OnSave = function(inst, data)
        if onsave then
            onsave(inst, data)
        end
        -- data.ndnr_antibody = inst.ndnr_antibody
        -- data.origin_maxhealth = inst.origin_maxhealth
        data.ndnr_parasite = inst.ndnr_parasite
        data.mod_ndnr = inst.mod_ndnr
        data.ndnr_gout = inst.ndnr_gout == nil and 0 or inst.ndnr_gout
        data.ndnr_evilvalue = inst.ndnr_evilvalue == nil and 0 or inst.ndnr_evilvalue
    end

    local onload = inst.OnLoad
    inst.OnLoad = function(inst, data)
        if onload then
            onload(inst, data)
        end
        -- if data and data.ndnr_antibody then
        --     inst.ndnr_antibody = data.ndnr_antibody
        -- end
        -- if data and data.origin_maxhealth then
        --     inst.origin_maxhealth = data.origin_maxhealth
        -- end
        if data then
            if data.ndnr_parasite then
                inst.ndnr_parasite = data.ndnr_parasite
            end
            if data.mod_ndnr then
                inst.mod_ndnr = data.mod_ndnr
            end
            inst.ndnr_gout = data.ndnr_gout == nil and 0 or data.ndnr_gout
            inst.ndnr_evilvalue = data.ndnr_evilvalue == nil and 0 or data.ndnr_evilvalue
        end
    end
end)
