--[[
如果你想增加其它模组中boss或者生物的可薅动作，可以通过下面方式添加
table.insert(TUNING.NDNR_PLUCKABLE_PREFABS, {
    prefab = "beefalo",                     --被薅对象
    product = {"ndnr_milk"},                --产物
    respawntime = TUNING.TOTAL_DAY_TIME,    --刷新时间
    chance = 1/16,                          --几率
    actcondition = false,                   --初始条件为false即为不可薅动作,为true即为可薅动作,默认是true
    right = true,                           --是否是右键动作
    max = 1,                                --最大可薅几个
    count = 1,                              --每次薅几个
    spawncountonce = 5,                     --每次刷新几个
    sound = "ndnr/ndnr/pour_water",         --薅动作音效
    soundname = "ndnr_milk",                --薅动作音效名称
    sgtimeout = 1.7,                        --薅动作超时时间
    _actionstr = "MILK",                    --薅动作字符串
    cb = function(inst, doer) end,          --薅动作回调
    actionfailfn = function(inst, doer) end --薅动作失败回调
})
]]
TUNING.NDNR_PLUCKABLE_PREFABS = {{
    prefab = "beefalo",
    product = {"ndnr_milk"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    sound = "ndnr/ndnr/pour_water",
    soundname = "ndnr_milk",
    sgtimeout = 1.7,
    _actionstr = "MILK",
    cb = function(inst)
        if TheWorld.state.isnight then
            inst.sg:GoToState("shaved")
        else
            inst.sg:GoToState("pleased")
        end
        inst:RestartBrain()
    end
}, {
    prefab = "beequeen",
    product = {"royal_jelly"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 3,
    count = 1,
    sound = "ndnr/ndnr/pour_water",
    soundname = "ndnr_jelly",
    sgtimeout = 1.5,
    _actionstr = "MILK_JELLY",
    cb = function(inst, doer)
        inst.components.combat:SetTarget(doer)
        inst.sg:GoToState("screech")
        inst:RestartBrain()
    end
}, {
    prefab = "dragonfly",
    product = {"ndnr_magma_milk"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 3,
    count = 1,
    sound = "ndnr/ndnr/pour_water",
    soundname = "ndnr_magma",
    sgtimeout = 1.7,
    _actionstr = "MAGMA",
    cb = function(inst, doer)
        -- if inst.TransformFire then inst.TransformFire(inst) end
        inst.components.combat:SetTarget(doer)
        inst.sg:GoToState("pound")
        inst:RestartBrain()
    end
}, {
    prefab = "deer",
    product = {"ndnr_ice_milk"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    sound = "ndnr/ndnr/pour_water",
    soundname = "ndnr_deer_milk",
    sgtimeout = 1.7,
    _actionstr = "MILK",
    cb = function(inst, doer)
        inst.components.combat:SetTarget(doer)
        inst.sg:GoToState("attack")
        inst:RestartBrain()
    end
}, {
    prefab = "bearger",
    product = {"furtuft"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 15,
    count = 5,
    spawncountonce = 5,
    _actionstr = "HAIR",
    cb = function(inst)
        if inst.components.talker ~= nil then
            inst.components.talker:Say(BEARGER_BOTHER)
        end
        local sgs = {"attack", "pound", "yawn"}
        inst.sg:GoToState(sgs[math.random(1, 3)])
        inst:RestartBrain()
    end
}, {
    prefab = "moose",
    product = {"goose_feather"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 2,
    count = 2,
    spawncountonce = 2,
    _actionstr = "HAIR",
    cb = function(inst)
        inst.sg:GoToState("taunt")
        inst:RestartBrain()
    end
}, {
    prefab = "malbatross",
    product = {"ndnr_dead_swordfish"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    _actionstr = "FISHOUT",
    cb = function(inst)
        local sgs = {"wavesplash", "taunt", "combatdive"}
        inst.sg:GoToState(sgs[math.random(1, 3)])
        inst:RestartBrain()
    end
}, {
    prefab = "warg",
    product = {"ndnr_bigtooth"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    evil = 2,
    _actionstr = "TOOTH",
    cb = function(inst)
        inst.AnimState:OverrideSymbol("warg_mouth", "wound_warg", "warg_mouth")
        inst.sg:GoToState("howl")
        inst:RestartBrain()
    end
}, {
    prefab = "hermitcrab",
    product = {"messagebottleempty", "messagebottle"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    evil = -1,
    _actionstr = "MASSAGE",
    cb = function(inst, doer)
        if inst.components.talker ~= nil then
            inst.components.talker:Say(TUNING.NDNR_MASSAGE_TALKER[math.random(1, #TUNING.NDNR_MASSAGE_TALKER)])

            --[[if doer.components.ndnr_emo then
                doer.components.ndnr_emo:DoDelta(10)
            end]]
        end
        inst.sg:GoToState("funnyidle_tango")
        inst:RestartBrain()
    end
}, {
    prefab = "pigking",
    product = {"pigskin"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    evil = 2,
    _actionstr = "CUT",
    cb = function(inst, doer)
        if inst.components.talker ~= nil then
            local gender = GetGender(doer.prefab)
            inst.components.talker:Say(string.format(PIGKING_CUTED, gender == "FEMALE" and TUNING.NDNR_CHARACTER_HER or gender == "MALE" and TUNING.NDNR_CHARACTER_HIM or TUNING.NDNR_CHARACTER_IT))
        end
        inst.AnimState:OverrideSymbol("pigking_torso", "wound_pig_king", "wound_pigking_torso")
        inst.sg:GoToState("sleep")

        local x, y, z = doer.Transform:GetWorldPosition()
        local radius = 4
        for i = 1, 4 do
            local xr = x + math.floor(radius*math.cos(math.rad(i*90)))
            local zr = z + math.floor(radius*math.sin(math.rad(i*90)))
            local elite = SpawnPrefab("pigelitefighter" .. math.random(4))
            elite.components.follower:SetLeader(inst)
            elite.Transform:SetPosition(xr, y, zr)
            local theta = math.random() * 2 * PI
            local offset = FindWalkableOffset(Vector3(xr, y, zr), theta, 2.5, 16, true, true, nil, false, true) or
                               FindWalkableOffset(Vector3(xr, y, zr), theta, 2.5, 16, false, false, nil, false, true) or
                               Vector3(0, 0, 0)
            elite.sg:GoToState("spawnin", {
                dest = Vector3(x + offset.x, 0, z + offset.z)
            })

            elite.components.combat:SetTarget(doer)
        end
    end
}, {
    prefab = "klaus_sack",
    product = {"krampus_sack"},
    chance = 1/16, -- 冬天16天，一天一次，概率上可以出一个
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    _actionstr = "PRY",
    cb = function(inst, doer)
        local x, y, z = doer.Transform:GetWorldPosition()
        SpawnCreature("krampus", 3, 4, doer:GetPosition(), nil, doer, "attack")

        local spell = SpawnPrefab("deer_ice_circle")
        spell.Transform:SetPosition(x, y, z)
        spell:DoTaskInTime(6, spell.KillFX)
    end,
    actionfailfn = function(inst, doer)
        doer.components.talker:Say(PLAYER_PRY_NOTHING)
    end
}, {
    prefab = "beequeenhivegrown",
    product = {"bundlewrap_blueprint"},
    chance = 0.1,
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    _actionstr = "STEAL_BLUEPRINT",
    cb = function(inst, doer)
        local x, y, z = doer.Transform:GetWorldPosition()

        for i = 1, 6 do
            local beeguard = SpawnPrefab("beeguard")
            beeguard.Transform:SetPosition(x, y, z)
            beeguard.components.combat:SetTarget(doer)
            beeguard.sg:GoToState("attack")
        end

        local x, y, z = doer.Transform:GetWorldPosition()
        -- local angle = -doer.Transform:GetRotation() * DEGREES
        local fx = SpawnPrefab("honey_trail")
        fx.Transform:SetPosition(x, y, z)
        fx:DoTaskInTime(4, fx.KillFX)
        fx:SetVariation(6, GetRandomMinMax(1, 1.3), 4 + math.random() * .5)
        local radius = 3
        for i = 1, 6 do
            local xr = x + math.floor(radius*math.cos(math.rad(i*60)))
            local zr = z + math.floor(radius*math.sin(math.rad(i*60)))
            local fxr = SpawnPrefab("honey_trail")
            fxr.Transform:SetPosition(xr, y, zr)
            fxr:DoTaskInTime(4, fxr.KillFX)
            fxr:SetVariation(6, GetRandomMinMax(1, 1.3), 4 + math.random() * .5)
        end
    end,
    actionfailfn = function(inst, doer)
        doer.components.talker:Say(PLAYER_PRY_NOTHING)
    end
}, {
    prefab = "sculpture_rookbody", -- prefab位置：sculptures.lua
    product = {"chesspiece_rook_sketch"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    _actionstr = "COPY",
    cb = function(inst, doer)
        inst.ndnr_copied = true
        local x, y, z = doer.Transform:GetWorldPosition()

        local sp = SpawnPrefab("shadow_rook")  -- prefab位置：shadowchesspieces.lua
        sp.ndnr_copied = true
        sp.Transform:SetPosition(x + math.random(-7, 7), y + math.random(-7, 7), z)
        sp.level = 2
        sp.sg:GoToState("levelup")
        sp:DoTaskInTime(60 * FRAMES, sp.LevelUp)

        sp:DoTaskInTime(70 * FRAMES, function(inst)
            if inst.components.talker ~= nil then
                inst.components.talker:Say(SCULPTURE_SPAWN)
            end
        end)

        sp.components.lootdropper.DropLoot = function(pt)
        end

        sp.components.combat:SetTarget(doer)
    end,
    actionfailfn = function(inst, doer)
        doer.components.talker:Say(PLAYER_PRY_NOTHING)
    end
}, {
    prefab = "sculpture_knightbody",
    product = {"chesspiece_knight_sketch"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    _actionstr = "COPY",
    cb = function(inst, doer)
        inst.ndnr_copied = true
        local x, y, z = doer.Transform:GetWorldPosition()

        local sp = SpawnPrefab("shadow_knight")
        sp.ndnr_copied = true
        sp.Transform:SetPosition(x + math.random(-7, 7), y + math.random(-7, 7), z)
        sp.level = 2
        sp.sg:GoToState("levelup")
        sp:DoTaskInTime(61 * FRAMES, sp.LevelUp)

        sp:DoTaskInTime(71 * FRAMES, function(inst)
            if inst.components.talker ~= nil then
                inst.components.talker:Say(SCULPTURE_SPAWN)
            end
        end)

        sp.components.lootdropper.DropLoot = function(pt)
        end

        sp.components.combat:SetTarget(doer)
    end,
    actionfailfn = function(inst, doer)
        doer.components.talker:Say(PLAYER_PRY_NOTHING)
    end
}, {
    prefab = "sculpture_bishopbody",
    product = {"chesspiece_bishop_sketch"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    _actionstr = "COPY",
    cb = function(inst, doer)
        inst.ndnr_copied = true
        local x, y, z = doer.Transform:GetWorldPosition()

        local sp = SpawnPrefab("shadow_bishop")
        sp.ndnr_copied = true
        sp.Transform:SetPosition(x + math.random(-7, 7), y + math.random(-7, 7), z)
        sp.level = 2
        sp.sg:GoToState("levelup")
        sp:DoTaskInTime(58 * FRAMES, sp.LevelUp)

        sp:DoTaskInTime(68 * FRAMES, function(inst)
            if inst.components.talker ~= nil then
                inst.components.talker:Say(SCULPTURE_SPAWN)
            end
        end)

        sp.components.lootdropper.DropLoot = function(pt)
        end

        sp.components.combat:SetTarget(doer)
    end,
    actionfailfn = function(inst, doer)
        doer.components.talker:Say(PLAYER_PRY_NOTHING)
    end
}, {
    prefab = "minotaur",
    product = {"minotaurhorn"},
    respawntime = TUNING.TOTAL_DAY_TIME * 5,
    max = 1,
    count = 1,
    evil = 2,
    _actionstr = "CUTHORN",
    cb = function(inst, doer)
        local minotaurloots = LootTables["minotaur"]
        if minotaurloots ~= nil then
            for i, v in ipairs(minotaurloots) do
                if v[1] == "minotaurhorn" then
                    table.remove(LootTables["minotaur"], i)
                    break
                end
            end
        end
        inst:AddTag("woundedminotaur")
        inst.AnimState:OverrideSymbol("horn", "wound_rhino", "wound_horn")
        inst.components.combat:SetAttackPeriod(TUNING.MINOTAUR_ATTACK_PERIOD/2)
        inst.components.combat:SetDefaultDamage(TUNING.MINOTAUR_DAMAGE/2)
        inst.components.combat:SetRange(4, 4)

        local pt = doer:GetPosition()
        for i = 0, 17, 1 do
            local wall = SpawnPrefab("ndnr_wall_ruins")
            local x = math.floor(pt.x-9+i) + .5
            local z = math.floor(pt.z+9) + .5
            wall.Transform:SetPosition(x, 0, z)

            local wall1 = SpawnPrefab("ndnr_wall_ruins")
            local x1 = math.floor(pt.x+9) + .5
            local z1 = math.floor(pt.z+9-i) + .5
            wall1.Transform:SetPosition(x1, 0, z1)

            local wall2 = SpawnPrefab("ndnr_wall_ruins")
            local x2 = math.floor(pt.x+9-i) + .5
            local z2 = math.floor(pt.z-9) + .5
            wall2.Transform:SetPosition(x2, 0, z2)

            local wall3 = SpawnPrefab("ndnr_wall_ruins")
            local x3 = math.floor(pt.x-9) + .5
            local z3 = math.floor(pt.z-9+i) + .5
            wall3.Transform:SetPosition(x3, 0, z3)
        end
        TheWorld:PushEvent("ms_miniquake", {
            rad = 4,
            minrad = 2,
            num = 70,
            duration = 7,
            pos = doer:GetPosition(),
            target = doer,
            debrisfn = function() return "cavein_boulder", 0 end,
        })

        inst.sg:GoToState("attack")
        inst:RestartBrain()
    end
}, {
    prefab = "leif",
    product = {"livinglog"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    evil = 2,
    _actionstr = "SAWN",
    cb = function(inst, doer)
        inst.components.combat:SetTarget(doer)
        inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/livinglog_burn")
        inst.sg:GoToState("attack")
    end
}, {
    prefab = "leif_sparse",
    product = {"livinglog"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    evil = 2,
    _actionstr = "SAWN",
    cb = function(inst, doer)
        inst.components.combat:SetTarget(doer)
        inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/livinglog_burn")
        inst.sg:GoToState("attack")
    end
}, {
    prefab = "spat",
    product = {"steelwool"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    evil = 2,
    _actionstr = "PEELSKIN",
    cb = function(inst, doer)
        inst.components.combat:SetTarget(doer)
        inst.sg:GoToState("launchprojectile")
    end
}, {
    prefab = "bunnyman",
    product = {"manrabbit_tail"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    _actionstr = "HAIR",
    cb = function(inst, doer)
        inst.components.combat:SetTarget(doer)
        inst.sg:GoToState("attack")
    end
}, {
    prefab = "monkey",
    product = {"cave_banana"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    _actionstr = "STEAL_BANANA",
    cb = function(inst, doer)
        inst.components.combat:SetTarget(doer)
        inst.sg:GoToState("taunt")
    end
}, {
    prefab = "archive_centipede_husk",
    product = {"ndnr_godtoken"},
    respawntime = TUNING.TOTAL_DAY_TIME * 70,
    max = 1,
    count = 1,
    evil = 0,
    _actionstr = "STEAL_GODTOKEN",
    cb = function(inst, doer)
        local x, y, z = doer.Transform:GetWorldPosition()

        SpawnCreature("gestalt", 3, 3, doer:GetPosition(), nil, doer, "attack")

        local x1, y1, z1 = inst.Transform:GetWorldPosition()
        local cp = SpawnPrefab("archive_centipede")
        inst:Remove()
        cp.Transform:SetPosition(x1, y1, z1)
        cp.components.combat:SetTarget(doer)
        cp.sg:GoToState("atk_aoe")
    end
}, {
    prefab = "bullkelp_plant",
    product = {"bullkelp_root"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    right = true,
    evil = 0,
    _actionstr = "PLUCK",
    cb = function(inst, doer)
        inst:Remove()
    end
}, {
    prefab = "antlion",
    product = {"ndnr_weatherpole"},
    respawntime = TUNING.TOTAL_DAY_TIME * 70,
    max = 1,
    count = 1,
    evil = 2,
    _actionstr = "BORROW_WEATHER_POLE",
    cb = function(inst, doer)
        if inst.components.talker ~= nil then
            inst.components.talker:Say(ANTLION_BORROWED)
        end
        inst.StartCombat(inst)
        inst.components.combat:SetTarget(doer)
        inst.components.combat:SetAttackPeriod(TUNING.ANTLION_MIN_ATTACK_PERIOD)
    end
}, {
    prefab = "catcoon",
    product = {"coontail"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    chance = 0.5,
    max = 1,
    count = 1,
    evil = 2,
    _actionstr = "CAT_TAIL",
    cb = function(inst, doer)
        inst.AnimState:HideSymbol("catcoon_tail")
        inst.AnimState:HideSymbol("catcoon_tail_flick")
        -- inst.AnimState:OverrideSymbol("catcoon_tail", "ndnr_nobody_build", "catcoon_tail")
        -- inst.AnimState:OverrideSymbol("catcoon_tail_flick", "ndnr_nobody_build", "catcoon_tail_flick")
        inst.components.combat.onhitotherfn = function(inst, other, damage)
            if other:HasTag("player") and not other:HasTag("playerghost") then
                other.components.debuffable:AddDebuff("ndnr_bloodoverdebuff", "ndnr_bloodoverdebuff")
            end
        end
        inst.components.combat:SetTarget(doer)
        inst.sg:GoToState("attack")
    end,
    actionfailfn = function(inst, doer)
        doer.components.talker:Say(CATTAIL_NOTHING)

        inst.components.combat.onhitotherfn = function(inst, other, damage)
            if other:HasTag("player") and not other:HasTag("playerghost") then
                other.components.debuffable:AddDebuff("ndnr_bloodoverdebuff", "ndnr_bloodoverdebuff")
            end
        end
        inst.components.combat:SetTarget(doer)
        inst.sg:GoToState("attack")
    end
}, {
    prefab = "lightninggoat",
    product = {"lightninggoathorn"},
    respawntime = TUNING.TOTAL_DAY_TIME * 2,
    chance = 0.5,
    max = 1,
    count = 1,
    evil = 2,
    _actionstr = "BREAK_GOAT_HORN",
    cb = function(inst, doer)
        inst.AnimState:OverrideSymbol("lightning_goat_horn", "nohornlightninggoat", "lightning_goat_horn")
        inst.components.combat:SetTarget(doer)
        inst.sg:GoToState("attack")
    end,
    actionfailfn = function(inst, doer)
        doer.components.talker:Say(GOAT_HORN_SO_HARD)

        inst.components.combat:SetTarget(doer)
        inst.sg:GoToState("attack")
    end
}, {
    prefab = "toadstool",
    product = {"ndnr_blue_sporeseed", "ndnr_red_sporeseed", "ndnr_green_sporeseed"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 3,
    count = 1,
    _actionstr = "PICK_SPORE",
    cb = function(inst, doer)
        inst.components.combat:SetTarget(doer)
        inst.sg:GoToState("pound_pre")
        inst:RestartBrain()
    end
}, {
    prefab = "toadstool_dark",
    product = {"ndnr_blue_sporeseed", "ndnr_red_sporeseed", "ndnr_green_sporeseed"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 3,
    count = 1,
    _actionstr = "PICK_SPORE",
    cb = function(inst, doer)
        inst.components.combat:SetTarget(doer)
        inst.sg:GoToState("pound_pre")
        inst:RestartBrain()
    end
}, {
    prefab = "tentacle",
    product = {"tentaclespots"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    _actionstr = "PEELSKIN",
    cb = function(inst, doer)
        inst.components.combat:SetTarget(doer)
        inst.sg:GoToState("attack")
    end
}, {
    prefab = "deerclops",
    product = {"deerclops_eyeball"},
    respawntime = TUNING.TOTAL_DAY_TIME * 5,
    max = 1,
    count = 1,
    evil = 2,
    _actionstr = "DIG_EYE",
    cb = function(inst, doer)
        if inst.components.lootdropper then
            local deerclops_loots = inst.components.lootdropper.loot
            if deerclops_loots ~= nil then
                for i, v in ipairs(deerclops_loots) do
                    if v == "deerclops_eyeball" then
                        table.remove(inst.components.lootdropper.loot, i)
                        break
                    end
                end
            end
        end

        inst.AnimState:OverrideSymbol("deerclops_head", IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) and "deerclops_noeye_yule" or "deerclops_noeye", "deerclops_head")

        inst.components.combat:SetTarget(doer)
        inst.sg:GoToState("taunt")
        local x, y, z = doer.Transform:GetWorldPosition()
        local fx = SpawnPrefab("deer_ice_circle")
        fx.Transform:SetPosition(x, y, z)
        fx.Transform:SetScale(1.2, 1.2, 1.2)
        fx:DoTaskInTime(7, fx.KillFX)
        SpawnCreature("ndnr_rock_ice", 7, 18, doer:GetPosition())
    end
}, {
    prefab = "lordfruitfly",
    product = {"asparagus_seeds", "garlic_seeds", "pumpkin_seeds", "corn_seeds", "onion_seeds", "potato_seeds", "dragonfruit_seeds", "pomegranate_seeds", "eggplant_seeds", "tomato_seeds", "watermelon_seeds", "pepper_seeds", "durian_seeds", "carrot_seeds", "ndnr_soybean_seeds"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 3,
    count = 1,
    _actionstr = "TURN_SEED",
    cb = function(inst, doer)
        SpawnCreature("fruitfly", 4, 6, doer:GetPosition(), nil, doer, "attack")

        inst.components.combat:SetTarget(doer)
        inst.sg:GoToState("plant_attack")
    end
}, {
    prefab = "grotto_pool_big",
    product = {"ndnr_waterdrop"},
    respawntime = TUNING.TOTAL_DAY_TIME * 70,
    max = 1,
    count = 1,
    evil = 0,
    _actionstr = "PICK",
    cb = function(inst, doer)
        inst:AddTag("nowaterdrop")
        if inst._children then
            for i, v in ipairs(inst._children) do
                if v.prefab == "grotto_waterfall_big" then
                    v:Remove()
                    inst._children[i] = nil
                    break
                end
            end
        end
        local x, y, z = doer.Transform:GetWorldPosition()
        SpawnCreature("molebat", 4, 6, doer:GetPosition(), nil, doer, "attack")
        SpawnCreature("gestalt", 3, 2, doer:GetPosition(), nil, doer, "attack")
    end
}, {
    prefab = "tallbirdnest",
    product = {"dug_ndnr_coffeebush", "flint", "cutgrass", "twigs", "rocks", "goldnugget", "moonglass", "moonrocknugget", "nitre"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    _actionstr = "DIGOUT_TALLBIRD_NEST",
    cb = function(inst, doer)
        local tallbird = SpawnPrefab("tallbird")
        local x, y, z = doer.Transform:GetWorldPosition()
        tallbird.ndnr_danger = true
        tallbird.components.lootdropper:SetLoot(nil)

        tallbird.Transform:SetPosition(x,y,z)
        tallbird.components.combat:SetTarget(doer)
        -- tallbird.sg:GoToState("attack")
    end
}, {
    prefab = "smallghost",
    product = {"trinket_1","trinket_2","trinket_7","trinket_10","trinket_11","trinket_14","trinket_18","trinket_19","trinket_42","trinket_43"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    evil = 2,
    _actionstr = "WANT_TONYS",
    cb = function(inst, doer)
        local ghost = SpawnPrefab("ghost")
        local x, y, z = doer.Transform:GetWorldPosition()

        ghost.Transform:SetPosition(x,y,z)
        ghost.components.combat:SetTarget(doer)
        ghost.sg:GoToState("attack")
    end
}, {
    prefab = "worm",
    product = {"wormlight"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    mute = true,
    _actionstr = "PICK_WORMLIGHT",
    cb = function(inst, doer)
        if inst.components.lootdropper then
            inst.components.lootdropper:SetLoot({ "monstermeat", "monstermeat", "monstermeat", "monstermeat" })
        end
        inst.AnimState:HideSymbol("wormlure")
        -- inst.AnimState:OverrideSymbol("wormlure", "ndnr_nobody_build", "wormlure")

        if doer ~= nil and doer:IsValid() then
            inst.components.combat:SetTarget(doer)
            inst:FacePoint(doer:GetPosition())
            inst.components.combat:TryAttack(doer)
        end
    end
}, {
    prefab = "pigguard",
    product = {"pig_token"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    evil = -1,
    _actionstr = "UNDRESS",
    cb = function(inst, doer)
        local fx = SpawnPrefab("collapse_small")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())

        local pigman = SpawnPrefab("pigman")
        pigman.Transform:SetPosition(inst.Transform:GetWorldPosition())

        if doer.components.leader ~= nil and not (pigman:HasTag("guard") or doer:HasTag("monster") or doer:HasTag("merm")) then
            if doer.components.minigame_participator == nil then
                doer:PushEvent("makefriend")
                doer.components.leader:AddFollower(pigman)
            end
            pigman.components.follower:AddLoyaltyTime(TUNING.CALORIES_MED * TUNING.PIG_LOYALTY_PER_HUNGER)
            pigman.components.follower.maxfollowtime =
                doer:HasTag("polite")
                and TUNING.PIG_LOYALTY_MAXTIME + TUNING.PIG_LOYALTY_POLITENESS_MAXTIME_BONUS
                or TUNING.PIG_LOYALTY_MAXTIME

            pigman:DoTaskInTime(FRAMES*30, function(inst)
                if pigman.components.talker ~= nil then
                    pigman.components.talker:Say(NDNR_UR_GOODMAN)
                end
            end)
        end

        inst:Remove()
    end
}, {
    prefab = "pond",
    product = {"pondfish"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    _actionstr = "MOFISH",
    cb = function(inst, doer)
        SpawnCreature("frog", 2, 1, doer:GetPosition(), nil, doer, "attack")
    end
}, {
    prefab = "pond_mos",
    product = {"pondfish"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    _actionstr = "MOFISH",
    cb = function(inst, doer)
        SpawnCreature("mosquito", 2, 3, doer:GetPosition(), nil, doer, "attack")
    end
}, {
    prefab = "pond_cave",
    product = {"pondeel"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    _actionstr = "MOFISH",
    cb = function(inst, doer)
        SpawnCreature("worm", 1, 1, doer:GetPosition(), nil, doer, "attack")
    end
}, {
    prefab = "catcoonden",
    product = {"wetgoop","spoiled_food","cutgrass","rocks","petals_evil","flint","petals","ice","pinecone","feather_robin","mole","acorn"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    _actionstr = "DIGOUT_CATCOONDEN",
    cb = function(inst, doer)
        SpawnCreature("catcoon", 1, 1, doer:GetPosition(), nil, doer, "attack")
    end
}, {
    prefab = "penguin",
    product = {"goldnugget","goldnugget",TUNING.FUNCTIONAL_MEDAL_IS_OPEN == true and "toil_money" or "goldnugget"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    evil = 0,
    _actionstr = "GIVEBACK_TOILMONEY",
    cb = function(inst, doer)
        if inst.components.combat then
            inst:PushEvent("attacked", {attacker = doer, damage = 0})
        end
    end
}, {
    prefab = "wobster_den",
    product = {"wobster_sheller_land", "wobster_sheller_land", "wobster_sheller_land", "bullkelp_root", "dug_trap_starfish"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    chance = 0.5,
    _actionstr = "CATCH_WOBSTERDEN",
    cb = function(inst, doer, product)
        if product.prefab == "wobster_sheller_land" then
            doer.components.combat:GetAttacked(inst, 10)
            doer:PushEvent("thorns")
        elseif product.prefab == "dug_trap_starfish" then
            doer.components.combat:GetAttacked(inst, 60)
            doer:PushEvent("thorns")
            if doer.components.talker ~= nil then
                doer.components.talker:Say(CATCH_WOBSTER_SHELLER_STARFISH)
            end
        end
    end,
    actionfailfn = function(inst, doer)
        doer.components.talker:Say(CATCH_WOBSTER_SHELLER_FAIL)
    end
}, {
    prefab = "moonglass_wobster_den",
    product = {"wobster_moonglass_land", "wobster_moonglass_land", "wobster_moonglass_land", "bullkelp_root", "dug_trap_starfish"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    chance = 0.5,
    _actionstr = "CATCH_WOBSTERDEN",
    cb = function(inst, doer, product)
        if product.prefab == "wobster_moonglass_land" then
            doer.components.combat:GetAttacked(inst, 10)
            doer:PushEvent("thorns")
        elseif product.prefab == "dug_trap_starfish" then
            doer.components.combat:GetAttacked(inst, 60)
            doer:PushEvent("thorns")
            if doer.components.talker ~= nil then
                doer.components.talker:Say(CATCH_WOBSTER_SHELLER_STARFISH)
            end
        end
    end,
    actionfailfn = function(inst, doer)
        doer.components.talker:Say(CATCH_WOBSTER_SHELLER_FAIL)
    end
}, {
    prefab = "evergreen",
    product = {"pinecone"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    actcondition = false,
    _actionstr = "PICK_PINECONE",
    cb = function(inst, doer)
        if not inst:HasTag("burnt") then
            inst.AnimState:PlayAnimation("chop_tall")
            inst.AnimState:PushAnimation("sway1_loop_tall", true)
            if math.random() < 1/40 then
                local leif = SpawnPrefab("leif")
                if leif.components.talker ~= nil then
                    leif.components.talker:Say(PICK_PINECONE)
                end
                local pt = doer:GetPosition()
                leif:SetLeifScale(1.25)
                leif.Transform:SetPosition(pt.x, pt.y, pt.z)
                leif.components.combat:SuggestTarget(doer)

                leif.sg:GoToState("spawn")
                inst:Remove()
            end
        end
    end
}, {
    prefab = "twiggytree",
    product = {"twiggy_nut"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    actcondition = false,
    _actionstr = "PICK_TWIGGY_NUT",
    cb = function(inst, doer)
        if not inst:HasTag("burnt") then
            inst.AnimState:PlayAnimation("chop_tall")
            inst.AnimState:PushAnimation("sway1_loop_tall", true)
            if doer.components.combat ~= nil and not (doer.components.inventory ~= nil and doer.components.inventory:EquipHasTag("bramble_resistant")) then
                doer.components.combat:GetAttacked(inst, TUNING.MARSHBUSH_DAMAGE)
                doer:PushEvent("thorns")
            end
        end
    end
}, {
    prefab = "deciduoustree",
    product = {"acorn"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    actcondition = false,
    _actionstr = "PICK_ACORN",
    cb = function(inst, doer)
        if not inst:HasTag("burnt") then
            inst.AnimState:PlayAnimation("chop_tall")
            inst.AnimState:PushAnimation("sway1_loop_tall", true)
            if math.random() < 1/40 then
                inst:StartMonster(true)
                if inst.components.talker ~= nil then
                    inst.components.talker:Say(PICK_PICK_PINECONE)
                end
            end
        end
    end
}, {
    prefab = "moon_tree",
    product = {"moonbutterfly"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    actcondition = false,
    _actionstr = "PICK_MOON_TREE_BLOSSOM",
    cb = function(inst, doer)
        if not inst:HasTag("burnt") then
            inst.AnimState:PlayAnimation("chop_tall")
            inst.AnimState:PushAnimation("sway1_loop_tall", true)
            if math.random() < 1/7 then
                local spider = SpawnPrefab("spider_moon")
                local pt = doer:GetPosition()
                spider.Transform:SetPosition(pt.x, pt.y, pt.z)
                spider.components.combat:SetTarget(doer)
            end
        end
    end
}, {
    prefab = "ndnr_palmtree",
    product = {"ndnr_coconut"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    chance = 7/10,
    actcondition = false,
    _actionstr = "PICK_COCONUT",
    cb = function(inst, doer)
        if not inst:HasTag("burnt") then
            inst.AnimState:PlayAnimation("chop_tall")
            inst.AnimState:PushAnimation("sway1_loop_tall", true)
            if math.random() < 1/40 then
                local leif = SpawnPrefab("ndnr_treeguard")
                if leif.components.talker ~= nil then
                    leif.components.talker:Say(PICK_PINECONE)
                end
                local pt = doer:GetPosition()
                leif:SetTreeGuardScale(1.25)
                leif.Transform:SetPosition(pt.x, pt.y, pt.z)
                leif.components.combat:SuggestTarget(doer)

                leif.sg:GoToState("spawn")
                inst:Remove()
            end
        end
    end,
    actionfailfn = function(inst, doer)
        if inst.ndnr_grounddetection_update ~= nil then
            local coconut = SpawnPrefab("ndnr_coconut")
	        local rad = doer:GetPosition():Dist(inst:GetPosition())
	        local vec = (doer:GetPosition() - inst:GetPosition()):Normalize()
	        local offset = Vector3(vec.x * rad, 4, vec.z * rad)

			coconut.Transform:SetPosition((inst:GetPosition() + offset):Get())
			coconut.updatetask = coconut:DoPeriodicTask(0.1, inst.ndnr_grounddetection_update, 0.05)
        end
    end
}, {
    prefab = "alterguardian_phase1",
    product = {"ndnr_energy_core"},
    respawntime = TUNING.TOTAL_DAY_TIME/480,
    max = 1,
    count = 1,
    chance = 1/20,
    evil = 0,
    actcondition = false,
    sound = "ndnr_forging/mod_ndnr_music/ndnr_forging",
    soundname = "ndnr_forging",
    sgtimeout = 2,
    _actionstr = "DISMANTLE_ENERGY_CORE",
    cb = function(inst, doer)
        TheWorld:PushEvent("ndnr_moonboss_dismantled")
        inst.components.health:Kill()
    end,
    actionfailfn = function(inst, doer)
        inst.sg:GoToState("tantrum_pre")
        inst:RestartBrain()
    end
}, {
    prefab = "alterguardian_phase2",
    product = {"ndnr_energy_core"},
    respawntime = TUNING.TOTAL_DAY_TIME/480,
    max = 1,
    count = 1,
    chance = 1/20,
    evil = 0,
    actcondition = false,
    sound = "ndnr_forging/mod_ndnr_music/ndnr_forging",
    soundname = "ndnr_forging",
    sgtimeout = 2,
    _actionstr = "DISMANTLE_ENERGY_CORE",
    cb = function(inst, doer)
        TheWorld:PushEvent("ndnr_moonboss_dismantled")
        inst.components.health:Kill()
    end,
    actionfailfn = function(inst, doer)
        inst.sg:GoToState("spin_pre", doer)
        inst:RestartBrain()
    end
}, {
    prefab = "alterguardian_phase3",
    product = {"ndnr_energy_core"},
    respawntime = TUNING.TOTAL_DAY_TIME/480,
    max = 1,
    count = 1,
    chance = 1/20,
    evil = 0,
    actcondition = false,
    sound = "ndnr_forging/mod_ndnr_music/ndnr_forging",
    soundname = "ndnr_forging",
    sgtimeout = 2,
    _actionstr = "DISMANTLE_ENERGY_CORE",
    cb = function(inst, doer)
        TheWorld:PushEvent("ndnr_moonboss_dismantled")
        inst.components.health:Kill()
    end,
    actionfailfn = function(inst, doer)
        inst.sg:GoToState(math.random() < 1/2 and "atk_beam" or "atk_sweep", doer)
        inst:RestartBrain()
    end
}, {
    prefab = "tentacle_pillar",
    product = {"ndnr_tentacleblood"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    evil = 2,
    _actionstr = "EXSANGUINATE",
    cb = function(inst, doer)
        if inst.components.combat ~= nil then
            inst.components.combat.onhitfn(inst, doer, 0)
        end
    end
}, {
    prefab = "mermking",
    product = {"trident"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    chance = 1/3,
    evil = 2,
    _actionstr = "PRINCE_FORCE_KING_ABDICATE",
    cb = function(inst, doer)
        if inst.components.health ~= nil then
            inst.components.health:Kill()
        end
    end,
    actionfailfn = function(inst, doer)
        SpawnCreature("mermguard", 2, 4, doer:GetPosition(), 24, doer, "attack")
        SpawnCreature("mermguard", 12, 8, doer:GetPosition(), 24, doer)
    end
}, {
    prefab = "shark",
    product = {"ndnr_sharkfin"},
    respawntime = TUNING.TOTAL_DAY_TIME * 2,
    max = 1,
    count = 1,
    evil = 2,
    _actionstr = "CUT_SHARKFIN",
    cb = function(inst, doer)
        -- inst.AnimState:OverrideSymbol("shark_parts", "ndnr_nobody_build", "shark_parts")
        inst.AnimState:HideSymbol("shark_parts")
        inst.components.combat:SetTarget(doer)
        inst.sg:GoToState("attack")
        inst:RestartBrain()
    end
}, {
    prefab = "walrus_camp",
    product = function()
        local item = {"walrushat", "walrushat", "walrushat"}
        local tusk_count = 1

        local camp_count = c_countprefabs("walrus_camp")
        local walrus_regen_period = TUNING.WALRUS_REGEN_PERIOD/TUNING.TOTAL_DAY_TIME


        -- 令tusk_count与再生时间成正比，与海象营地数量成反比，且海象营地大于4个则不添加海象牙为掉落物
        -- 参照：默认速度下，4个海象营地将使海象牙有1/4的权重，1个海象营地对应一半的权重
        if camp_count > 4 then
            return item
        end
        if camp_count > 0 then
            tusk_count = tusk_count / camp_count
        end
        if walrus_regen_period then
            tusk_count = tusk_count * walrus_regen_period
        end
        tusk_count = math.ceil(tusk_count)

        for i = 1,tusk_count do
            table.insert(item, "walrus_tusk")
        end

        return item
    end,
    -- product = {"walrushat"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    chance = 1/4,
    actcondition = false,
    _actionstr = "CAMP_RANSACK",
    cb = function(inst, doer)
        SpawnCreature("icehound", 2, 3, doer:GetPosition(), nil, doer, "attack")
    end,
    actionfailfn = function(inst, doer)
        doer.components.talker:Say(RANSACK_FAILSTR)
    end
}, {
    prefab = "mound",
    product = {"fossil_piece", "nightmarefuel", "amulet", "gears", "redgem", "redgem", "redgem", "redgem", "redgem", "bluegem", "bluegem", "bluegem", "bluegem", "bluegem"},
    respawntime = TUNING.TOTAL_DAY_TIME * 10,
    max = 1,
    count = 1,
    chance = 1/3,
    evil = 2,
    actcondition = false,
    _actionstr = "TOMB_ROBBING",
    cb = function(inst, doer, product)
        if doer.components.sanity ~= nil then
            doer.components.sanity:DoDelta(product.prefab == "fossil_piece" and -TUNING.SANITY_LARGE or -TUNING.SANITY_SMALL)
        end
        SpawnCreature("ghost", 1, product.prefab == "fossil_piece" and 3 or 1, doer:GetPosition(), nil, doer, "attack")
        if product.prefab == "fossil_piece" then
            doer:StartThread(function()
                for k = 0, 3 do
                    local pos = FindNearbyLand(doer:GetPosition(), 1)
                    TheWorld:PushEvent("ms_sendlightningstrike", pos)
                    Sleep(.3 + math.random() * .2)
                end
            end)
        end
    end,
    actionfailfn = function(inst, doer)
        if doer.components.talker ~= nil then
            doer.components.talker:Say(TOMB_ROBBING_FAILSTR)
        end
        if doer.components.sanity ~= nil then
            doer.components.sanity:DoDelta(-TUNING.SANITY_SMALL)
        end
    end
}, {
    prefab = "beehive",
    product = {"honey"},
    respawntime = TUNING.TOTAL_DAY_TIME,
    max = 1,
    count = 1,
    _actionstr = "POUND_BEEHIVE",
    cb = function(inst, doer, product)
        if math.random() < 0.01 then
            local honeycomb = SpawnPrefab("honeycomb")
            if honeycomb ~= nil then
                doer.components.inventory:GiveItem(honeycomb, nil, doer:GetPosition())
            end
        end
        if inst.components.childspawner ~= nil then
            local killerbee = inst.components.childspawner:ReleaseAllChildren(doer, "killerbee")
        end
    end
}}

for k, v in ipairs(TUNING.NDNR_PLUCKABLE_PREFABS) do
    AddPrefabPostInit(v.prefab, function(inst)
        inst._actionstr = v._actionstr
        if v.right and v.right == true then
            inst:AddTag("ndnr_rightaction")
        end

        if v.prefab ~= "worm" then
            if not inst.components.talker then inst:AddComponent("talker") end
            if inst:HasTag("epic") then
                inst.components.talker.fontsize = 40
                inst.components.talker.font = TALKINGFONT
                inst.components.talker.colour = Vector3(238 / 255, 69 / 255, 105 / 255)
                inst.components.talker.offset = Vector3(0, -700, 0)
                inst.components.talker.symbol = "fossil_chest"
                inst.components.talker:MakeChatter()
            end
        end

        if not TheWorld.ismastersim then
            return inst
        end

        if inst.components.timer == nil then
            inst:AddComponent("timer")
        end

        local timername = v.prefab .. "pluckabletimer"
        if inst.components.ndnr_pluckable == nil then
            inst:AddComponent("ndnr_pluckable")
            inst.components.ndnr_pluckable:SetUp(v.product, v.count, v.actcondition == nil and true or v.actcondition, v.sound, v.soundname, v.sgtimeout)
            inst.components.ndnr_pluckable:SetRespawnTime(v.respawntime)
            inst.components.ndnr_pluckable:SetTimerName(timername)
            inst.components.ndnr_pluckable:SetSpawnCountOnce(v.spawncountonce or 1)
            inst.components.ndnr_pluckable:SetMaxHair(v.max)
            inst.components.ndnr_pluckable:SetHairLeft(v.max)
            inst.components.ndnr_pluckable:SetChance(v.chance or 1)
            inst.components.ndnr_pluckable:SetActionFail(v.actionfailfn)
            inst.components.ndnr_pluckable:OnPlucked(v.cb)
            inst.components.ndnr_pluckable.evil = v.evil or 1

            inst.components.ndnr_pluckable:ActionEnable()
        end
        ------------------------------------定时结束时处理---------------------------------------
        inst:ListenForEvent("timerdone", function(inst, data)
            if data.name == timername then
                inst.components.ndnr_pluckable:RespawnHair()
            end
            if data.name == "minotaurpluckabletimer" then
                local minotaurloots = LootTables["minotaur"]
                if minotaurloots ~= nil then
                    local has_minotaurhorn = false
                    for k, v in pairs(minotaurloots) do
                        if v[1] == "minotaurhorn" then
                            has_minotaurhorn = true
                            break
                        end
                    end
                    if has_minotaurhorn == false then
                        table.insert(LootTables["minotaur"], {"minotaurhorn",1.00})
                    end
                end
                inst:RemoveTag("woundedminotaur")
                inst.AnimState:ClearOverrideSymbol("horn")
                inst.components.combat:SetAttackPeriod(TUNING.MINOTAUR_ATTACK_PERIOD)
                inst.components.combat:SetDefaultDamage(TUNING.MINOTAUR_DAMAGE)
                inst.components.combat:SetRange(3, 4)
            end
            if data.name == "pigkingpluckabletimer" then
                inst.AnimState:ClearOverrideSymbol("pigking_torso")
            end
            if data.name == "wargpluckabletimer" then
                inst.AnimState:ClearOverrideSymbol("warg_mouth")
            end
            if data.name == "lightninggoatpluckabletimer" then
                inst.AnimState:ClearOverrideSymbol("lightning_goat_horn")
            end
            if data.name == "catcoonpluckabletimer" then
                inst.AnimState:ShowSymbol("catcoon_tail")
                inst.AnimState:ShowSymbol("catcoon_tail_flick")
            end
            if data.name == "deerclopspluckabletimer" then
                if inst.components.lootdropper then
                    local deerclops_loots = inst.components.lootdropper.loot
                    if deerclops_loots ~= nil then
                        local has_deerclops_eyeball = false
                        for i, v in ipairs(deerclops_loots) do
                            if v == "deerclops_eyeball" then
                                has_deerclops_eyeball = true
                                break
                            end
                        end
                        if has_deerclops_eyeball == false then
                            table.insert(inst.components.lootdropper.loot, "deerclops_eyeball")
                        end
                    end
                end
                if inst:IsSated() then
                    inst.AnimState:OverrideSymbol("deerclops_head", IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) and "deerclops_yule" or "deerclops_build", "deerclops_head_neutral")
                else
                    inst.AnimState:OverrideSymbol("deerclops_head", IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) and "deerclops_yule" or "deerclops_build", "deerclops_head")
                end
            end
            if data.name == "grotto_pool_bigpluckabletimer" then
                inst:RemoveTag("nowaterdrop")
                if inst._children then
                    local ix, iy, iz = inst.Transform:GetWorldPosition()
                    local p = SpawnPrefab("grotto_waterfall_big")
                    p.Transform:SetPosition(ix, iy, iz)
                    table.insert(inst._children, p)
                    p:ListenForEvent("onremove", function() p = nil end)
                end
            end
            if data.name == "wormpluckabletimer" then
                inst.AnimState:ShowSymbol("wormlure")
                if inst.components.lootdropper then
                    inst.components.lootdropper:SetLoot({ "monstermeat", "monstermeat", "monstermeat", "monstermeat", "wormlight" })
                end
            end
            if data.name == "sharkpluckabletimer" then
                inst.AnimState:ShowSymbol("shark_parts")
            end
        end)
        ------------------------------------定时结束时处理---------------------------------------

        ------------------------------------加载时处理---------------------------------------
        inst:DoTaskInTime(FRAMES, function(inst)
            if v.prefab == "minotaur" then
                --先恢复掉落
                local minotaurloots = LootTables["minotaur"]
                if minotaurloots ~= nil then
                    local has_minotaurhorn = false
                    for k, v in pairs(minotaurloots) do
                        if v[1] == "minotaurhorn" then
                            has_minotaurhorn = true
                            break
                        end
                    end
                    if has_minotaurhorn == false then
                        table.insert(LootTables["minotaur"], {"minotaurhorn",1.00})
                    end
                end
                --再判断定时存在再去掉
                if inst.components.timer:TimerExists("minotaurpluckabletimer") then
                    local minotaurloots = LootTables["minotaur"]
                    if minotaurloots ~= nil then
                        for i, v in ipairs(minotaurloots) do
                            if v[1] == "minotaurhorn" then
                                table.remove(LootTables["minotaur"], i)
                                break
                            end
                        end
                    end
                    inst:AddTag("woundedminotaur")
                    inst.AnimState:OverrideSymbol("horn", "wound_rhino", "wound_horn")
                    inst.components.combat:SetAttackPeriod(TUNING.MINOTAUR_ATTACK_PERIOD/2)
                    inst.components.combat:SetDefaultDamage(TUNING.MINOTAUR_DAMAGE/2)
                    inst.components.combat:SetRange(4, 4)
                end
            end
            if v.prefab == "pigking" then
                if inst.components.timer:TimerExists("pigkingpluckabletimer") then
                    inst.AnimState:OverrideSymbol("pigking_torso", "wound_pig_king", "wound_pigking_torso")
                end
            end
            if v.prefab == "warg" then
                if inst.components.timer:TimerExists("wargpluckabletimer") then
                    inst.AnimState:OverrideSymbol("warg_mouth", "wound_warg", "warg_mouth")
                end
            end
            if v.prefab == "lightninggoat" then
                if inst.components.timer:TimerExists("lightninggoatpluckabletimer") then
                    inst.AnimState:OverrideSymbol("lightning_goat_horn", "nohornlightninggoat", "lightning_goat_horn")
                end
            end
            if v.prefab == "catcoon" then
                if inst.components.timer:TimerExists("catcoonpluckabletimer") then
                    inst.AnimState:HideSymbol("catcoon_tail")
                    inst.AnimState:HideSymbol("catcoon_tail_flick")
                    -- inst.AnimState:OverrideSymbol("catcoon_tail", "ndnr_nobody_build", "catcoon_tail")
                    -- inst.AnimState:OverrideSymbol("catcoon_tail_flick", "ndnr_nobody_build", "catcoon_tail_flick")
                end
            end
            if v.prefab == "deerclops" then
                if inst.components.lootdropper then
                    local deerclops_loots = inst.components.lootdropper.loot
                    if deerclops_loots ~= nil then
                        local has_deerclops_eyeball = false
                        for i, v in ipairs(deerclops_loots) do
                            if v == "deerclops_eyeball" then
                                has_deerclops_eyeball = true
                                break
                            end
                        end
                        if has_deerclops_eyeball == false then
                            table.insert(inst.components.lootdropper.loot, "deerclops_eyeball")
                        end
                    end
                end
                if inst.components.timer:TimerExists("deerclopspluckabletimer") then
                    if inst.components.lootdropper then
                        local deerclops_loots = inst.components.lootdropper.loot
                        if deerclops_loots ~= nil then
                            for i, v in ipairs(deerclops_loots) do
                                if v == "deerclops_eyeball" then
                                    table.remove(inst.components.lootdropper.loot, i)
                                    break
                                end
                            end
                        end
                    end
                    inst.AnimState:OverrideSymbol("deerclops_head", IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) and "deerclops_noeye_yule" or "deerclops_noeye", inst:IsSated() and "deerclops_head_neutral" or "deerclops_head")
                end
            end
            if v.prefab == "grotto_pool_big" then
                if inst.components.timer:TimerExists("grotto_pool_bigpluckabletimer") then
                    inst:AddTag("nowaterdrop")
                    if inst._children then
                        for i, v in ipairs(inst._children) do
                            if v.prefab == "grotto_waterfall_big" then
                                v:Remove()
                                inst._children[i] = nil
                                break
                            end
                        end
                    end
                end
            end
            if v.prefab == "worm" then
                if inst.components.timer:TimerExists("wormpluckabletimer") then
                    if inst.components.lootdropper then
                        inst.components.lootdropper:SetLoot({ "monstermeat", "monstermeat", "monstermeat", "monstermeat" })
                    end
                    inst.AnimState:HideSymbol("wormlure")
                    -- inst.AnimState:OverrideSymbol("wormlure", "ndnr_nobody_build", "wormlure")
                end
            end
            if v.prefab == "shark" then
                if inst.components.timer:TimerExists("sharkpluckabletimer") then
                    inst.AnimState:HideSymbol("shark_parts")
                    -- inst.AnimState:OverrideSymbol("shark_parts", "ndnr_nobody_build", "shark_parts")
                end
            end
        end)

        local onsave = inst.OnSave
        inst.OnSave = function(inst, data)
            if onsave then
                onsave(inst, data)
            end
            data.mod_pluckable_hairleft = inst.components.ndnr_pluckable.hairleft
        end

        local onload = inst.OnLoad
        inst.OnLoad = function(inst, data)
            if onload then
                onload(inst, data)
            end
            if data and data.mod_pluckable_hairleft then
                inst.components.ndnr_pluckable.hairleft = data.mod_pluckable_hairleft
            end
            inst.components.ndnr_pluckable:ActionEnable()
        end
    end)
    ------------------------------------加载时处理---------------------------------------
end