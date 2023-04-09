local assets = {
    Asset("ANIM", "anim/moondungeon.zip"),
}

local prefabs = {
    "staff_castinglight",   --释放怪物时的自身的发光特效
    --"rock_break_fx",    --虽说是特效，其实只是个用来播放声音(矿石破碎时)的载体
    "collapse_big", --建筑物损坏时的灰尘特效
    "chesterlight", --召唤怪物时的光效
    "deer_ice_circle",
    "moonbutterfly",

    "refractedmoonlight",
    "moonrockseed",
    "rocks",
    "flint",
    "nitre",
    "moonrocknugget",
    "ice",

    "deerclops",
    "bearger",
    "stalker_forest",
    "moose",

    "bishop",
    "rook",
    "knight",
    "walrus",
    "bat",
    "spider",
    "spider_warrior",
    "spiderqueen",
    "spider_hider",
    "spider_spitter",
    "spider_moon",
    "merm",
    "pigguard",
    "bunnyman",
    "icehound",
    "hound",
    "beefalo",
    "killerbee",
    "beeguard",
    "mosquito",
    "krampus",
    "ghost",
    "lightninggoat",
    "leif",
    "leif_sparse",
    "tallbird",
}

SetSharedLootTable( 'dungeon_loot_1',
{
    {'rocks', 1.0},
    {'rocks', 0.2},
})
SetSharedLootTable( 'dungeon_loot_2',
{
    {'nitre',  0.25},
    {'flint',  1.0},
})
SetSharedLootTable( 'dungeon_loot_3',
{
    {'moonrocknugget',  1.0},
    {'moonrocknugget',  0.3},
})
SetSharedLootTable( 'dungeon_loot_4',
{
    {'ice',  1.0},
    {'ice',  0.6},
})
SetSharedLootTable( 'dungeon_loot_5',
{
    {'moonglass',               0.200},
    {'moonrocknugget',          0.100},
    --{'redgem',               0.005},   --月的地下城属于带冰禁火类型的建筑，没有任何与火有关的东西
    {'bluegem',                 0.005},
    {'purplegem',               0.002},
    {'orangegem',               0.001},
    {'yellowgem',               0.001},
    {'greengem',                0.001},
    {'gears',                   0.005},
})

-----

local dungeon_protector = { --普通级保护者
    "bishop",
    "rook",
    "knight",
    "walrus",
    "bat",
    "spider",
    "spider_warrior",
    "spiderqueen",
    "spider_hider",
    "spider_spitter",
    "spider_moon",
    "merm",
    "pigguard",
    "bunnyman",
    "icehound",
    "hound",
    "beefalo",
    "killerbee",
    "beeguard",
    "mosquito",
    "krampus",
    "ghost",
    "lightninggoat",
    "leif",
    "leif_sparse",
    "tallbird",

    "icecircle",
    "iceexplosion",
    "lighting",
    "goodnight",
}

local dungeon_protector_boss = { --boss级保护者
    "deerclops",
    "bearger",
    "stalker_forest",
    "moose",
}

local protector_data = { --每种保护者的详细数据
    --boss级别的保护者
    deerclops = {
        num = 0,            --出现数量的基数
        stage = "staycool",        --登场方式
        realLootOdds = 1.1  --得到正常掉落的几率
    },
    bearger = {
        num = 0,
        stage = "lookaround",
        realLootOdds = 1.1
    },
    stalker_forest = {
        num = 0,
        stage = "baddream",
        realLootOdds = 0
    },
    moose = {
        num = 0,
        stage = "baddream",
        realLootOdds = 1.1
    },

    --小怪级别的保护者
    spiderqueen = {
        num = 0,
        stage = "starsky",
        realLootOdds = 0.7
    },
    leif = {
        num = 1,
        stage = "greenhouse",
        realLootOdds = 0.7
    },
    leif_sparse = {
        num = 1,
        stage = "greenhouse",
        realLootOdds = 0.7
    },
    beefalo = {
        num = 2,
        stage = "starsky",
        realLootOdds = 0.2
    },
    tallbird = {
        num = 2,
        stage = "lookaround",
        realLootOdds = 0.2
    },
    krampus = {
        num = 3,
        stage = "starsky",
        realLootOdds = 1.1
    },
    bishop = {
        num = 2,
        stage = "lookaround",
        realLootOdds = 0.1
    },
    rook = {
        num = 1,
        stage = "lookaround",
        realLootOdds = 0.1
    },
    knight = {
        num = 2,
        stage = "lookaround",
        realLootOdds = 0.1
    },
    walrus = {
        num = 1,
        stage = "lookaround",
        realLootOdds = 0.1
    },
    bat = {
        num = 5,
        stage = "starsky",
        realLootOdds = 0.03
    },
    spider = {
        num = 5,
        stage = "myhome",
        realLootOdds = 0.03
    },
    spider_warrior = {
        num = 2,
        stage = "myhome",
        realLootOdds = 0.03
    },
    spider_hider = {
        num = 3,
        stage = "myhome",
        realLootOdds = 0.03
    },
    spider_spitter = {
        num = 2,
        stage = "lookaround",
        realLootOdds = 0.03
    },
    spider_moon = {
        num = 2,
        stage = "starsky",
        realLootOdds = 0.1
    },
    merm = {
        num = 1,
        stage = "myhome",
        realLootOdds = 0.1
    },
    pigguard = {
        num = 1,
        stage = "myhome",
        realLootOdds = 0.1
    },
    bunnyman = {
        num = 1,
        stage = "myhome",
        realLootOdds = 0.1
    },
    icehound = {
        num = 3,
        stage = "staycool",
        realLootOdds = 0.03
    },
    hound = {
        num = 5,
        stage = "lookaround",
        realLootOdds = 0.03
    },
    killerbee = {
        num = 6,
        stage = "myhome",
        realLootOdds = 0.02
    },
    beeguard = {
        num = 3,
        stage = "lookaround",
        realLootOdds = 0
    },
    mosquito = {
        num = 6,
        stage = "myhome",
        realLootOdds = 0.02
    },
    ghost = {
        num = 2,
        stage = "lookaround",
        realLootOdds = 0
    },
    lightninggoat = {
        num = 2,
        stage = "lighthouse",
        realLootOdds = 0.1
    },
    mutated_penguin = {
        num = 5,
        stage = "staycool",
        realLootOdds = 0.03
    },

    --特殊类型的保护
    iceexplosion = { 
        num = 0,
        stage = "iceexplosion",
        realLootOdds = 0
    },
    icecircle = {
        num = 0,
        stage = "icecircle",
        realLootOdds = 0
    },
    lighting = {
        num = 16,
        stage = "lighting",
        realLootOdds = 0
    },
    goodnight = {
        num = 0,
        stage = "goodnight",
        realLootOdds = 0
    },
}

local function GetStatus(inst)
    if not inst.dungeonState then
        return "SLEEP"
    end
end

local function GetSpawnPoint(inst, radius)
    local x, y, z = inst.Transform:GetWorldPosition()
    local rad = radius or math.random(4, 12)
    local angle = math.random() * 2 * PI
    return x + rad * math.cos(angle), y, z - rad * math.sin(angle)
end

local function GetDungeonProtector(inst, protector, protdata)
    local monster = SpawnPrefab(protector)

    monster.AnimState:SetMultColour(49/255, 82/255, 156/255, 0.35) --前三个是颜色值，第四个是透明度

    if monster.components.lootdropper ~= nil then
        if protector == "stalker_forest" then --森林影织者还是掉落一些关键物品吧，不然好没用
            monster.components.lootdropper:SetLoot(nil)
            monster.fn_l_onDead = function(monster) --官方检查了 persists 变量，所以这里换个写法
                local lootdropper = monster.components.lootdropper
                local mypos = monster:GetPosition()
                lootdropper:SpawnLootPrefab("fossil_piece", mypos)
                lootdropper:SpawnLootPrefab("fossil_piece", mypos)
                lootdropper:SpawnLootPrefab("fossil_piece", mypos)
                lootdropper:SpawnLootPrefab("fossil_piece", mypos)
                if math.random() < 0.5 then
                    lootdropper:SpawnLootPrefab("fossil_piece", mypos)
                end
                if math.random() < 0.25 then
                    lootdropper:SpawnLootPrefab("fossil_piece", mypos)
                end
                if math.random() < 0.125 then
                    lootdropper:SpawnLootPrefab("fossil_piece", mypos)
                end
                if math.random() < 0.0225 then
                    lootdropper:SpawnLootPrefab("hiddenmoonlight_item_blueprint", mypos)
                end
                if math.random() < 0.0225 then
                    lootdropper:SpawnLootPrefab("revolvedmoonlight_item_blueprint", mypos)
                end
            end
            monster:ListenForEvent("death", monster.fn_l_onDead)
        elseif math.random() >= protdata.realLootOdds then --代替它原本的掉落物
            monster.components.lootdropper:SetLoot(nil)
            monster.components.lootdropper:SetChanceLootTable('dungeon_loot_5')
        end
        monster.components.lootdropper:AddChanceLoot("hiddenmoonlight_item_blueprint", 0.0225)
        monster.components.lootdropper:AddChanceLoot("revolvedmoonlight_item_blueprint", 0.0225)
    end
    monster.persists = false    --这个变量用于退出游戏时，如果为false，就不进行自身的保存，默认为true

    return monster
end

local function GetSpawnNumber(num)
    local result = math.random(-1, 1) + num
    return (result > 0 and result) or 1
end

local protector_stage = { --各种保护者的生成方式
    --圆的阵势在月光中产生
    starsky = function(inst, worker, protector, protdata)
        local timetime = 0
        local allnum = GetSpawnNumber(protdata.num)

        for i = 1, allnum do
            local x, y, z = GetSpawnPoint(inst, 10)

            local fx = SpawnPrefab("chesterlight")
            fx.Transform:SetPosition(x, y, z)
            fx:TurnOn()
            inst.SoundEmitter:PlaySound("dontstarve/creatures/chester/raise")

            inst:DoTaskInTime(timetime, function()
                local monster = GetDungeonProtector(inst, protector, protdata)
                monster.Transform:SetPosition(x, y, z)
                monster.components.combat:SetTarget(worker)

                if fx ~= nil then
                    inst:DoTaskInTime(1, function()
                        if fx then
                            fx:TurnOff()
                        end
                    end)
                end
            end)

            timetime = timetime + 0.3
        end
    end,

    --随机范围阵势产生
    lookaround = function(inst, worker, protector, protdata)
        local timetime = 0
        local allnum = GetSpawnNumber(protdata.num)

        for i = 1, allnum do
            local x, y, z = GetSpawnPoint(inst)

            -- local fx = SpawnPrefab("chesterlight")
            -- fx.Transform:SetPosition(x, y, z)
            -- fx:TurnOn()
            -- inst.SoundEmitter:PlaySound("dontstarve/creatures/chester/raise")

            inst:DoTaskInTime(timetime, function()
                local monster = GetDungeonProtector(inst, protector, protdata)
                monster.Transform:SetPosition(x, y, z)
                monster.components.combat:SetTarget(worker)
            end)

            timetime = timetime + 0.3
        end
    end,

    --在基地圆的阵势产生
    myhome = function(inst, worker, protector, protdata)
        local timetime = 0
        local allnum = GetSpawnNumber(protdata.num)

        for i = 1, allnum do
            local x, y, z = GetSpawnPoint(inst, 4)

            inst:DoTaskInTime(timetime, function()
                local monster = GetDungeonProtector(inst, protector, protdata)
                monster.Transform:SetPosition(x, y, z)
                monster.components.combat:SetTarget(worker)
            end)

            timetime = timetime + 0.3
        end
    end,

    --先冰控，后圆的阵势产生
    staycool = function(inst, worker, protector, protdata)
        --先冻住入侵者
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 10, { "freezable" }, { "FX", "NOCLICK", "INLIMBO" })
        for i, v in pairs(ents) do
            if v.components.freezable ~= nil then
                v.components.freezable:AddColdness(10)
            end
        end

        inst.SoundEmitter:PlaySound("dontstarve/creatures/hound/icehound_explo")

        --再召唤保护者
        local timetime = 1.3
        local allnum = GetSpawnNumber(protdata.num)

        for i = 1, allnum do
            local x, y, z = GetSpawnPoint(inst, 8)

            inst:DoTaskInTime(timetime, function()
                local monster = GetDungeonProtector(inst, protector, protdata)
                monster.Transform:SetPosition(x, y, z)
                monster.components.combat:SetTarget(worker)
            end)

            timetime = timetime + 0.3
        end
    end,

    --范围型冰控
    iceexplosion = function(inst, worker, protector, protdata)
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 10, { "freezable" }, { "FX", "NOCLICK", "INLIMBO" })
        for i, v in pairs(ents) do
            if v.components.freezable ~= nil then
                v.components.freezable:AddColdness(10)
            end
        end

        inst.SoundEmitter:PlaySound("dontstarve/creatures/hound/icehound_explo")
    end,

    --强力点式冰控
    icecircle = function(inst, worker, protector, protdata)
        local x, y, z = worker.Transform:GetWorldPosition()

        local spell = SpawnPrefab("deer_ice_circle")
        spell.Transform:SetPosition(x, 0, z)
        spell:DoTaskInTime(6, spell.KillFX)
    end,

    --召唤闪电
    lighting = function(inst, worker, protector, protdata)
        local pt = inst:GetPosition()
        local num_lightnings = GetSpawnNumber(protdata.num)
        local timetime = 0

        for k = 0, num_lightnings do
            inst:DoTaskInTime(timetime, function()
                local rad = math.random(4, 12)
                local angle = k * 4 * PI / num_lightnings
                local pos = pt + Vector3(rad * math.cos(angle), 0, rad * math.sin(angle))
                TheWorld:PushEvent("ms_sendlightningstrike", pos)
            end)

            timetime = timetime + 0.4
        end
    end,

    --召唤闪电，在基地圆的阵势产生
    lighthouse = function(inst, worker, protector, protdata)
        local pt = inst:GetPosition()
        local num_lightnings = math.random(3, 8)
        local num_protectors = GetSpawnNumber(protdata.num)
        local timetime = 0

        for i = 1, num_protectors do
            local x, y, z = GetSpawnPoint(inst, 4)

            inst:DoTaskInTime(timetime, function()
                local monster = GetDungeonProtector(inst, protector, protdata)
                monster.Transform:SetPosition(x, y, z)
                monster.components.combat:SetTarget(worker)
            end)

            timetime = timetime + 0.3
        end

        timetime = timetime + 1

        for k = 0, num_lightnings do
            inst:DoTaskInTime(timetime, function()
                local rad = math.random(4, 12)
                local angle = k * 4 * PI / num_lightnings
                local pos = pt + Vector3(rad * math.cos(angle), 0, rad * math.sin(angle))
                TheWorld:PushEvent("ms_sendlightningstrike", pos)
            end)

            timetime = timetime + 0.4
        end
    end,

    --范围式催眠
    goodnight = function(inst, worker, protector, protdata)
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 20, nil, { "playerghost", "FX", "INLIMBO" }, { "sleeper", "player" })
        for i, v in ipairs(ents) do
            if not (v.components.freezable ~= nil and v.components.freezable:IsFrozen()) and
                not (v.components.pinnable ~= nil and v.components.pinnable:IsStuck()) and
                not (v.components.fossilizable ~= nil and v.components.fossilizable:IsFossilized()) then
                local mount = v.components.rider ~= nil and v.components.rider:GetMount() or nil
                if mount ~= nil then
                    mount:PushEvent("ridersleep", { sleepiness = 10, sleeptime = 20 })
                end
                if v.components.sleeper ~= nil then
                    v.components.sleeper:AddSleepiness(10, 20)
                elseif v.components.grogginess ~= nil then
                    v.components.grogginess:AddGrogginess(10, 20)
                else
                    v:PushEvent("knockedout")
                end
            end
        end
    end,

    --先范围式催眠，后范围随机阵势产生
    baddream = function(inst, worker, protector, protdata)
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 20, nil, { "playerghost", "FX", "INLIMBO" }, { "sleeper", "player" })
        for i, v in ipairs(ents) do
            if not (v.components.freezable ~= nil and v.components.freezable:IsFrozen()) and
                not (v.components.pinnable ~= nil and v.components.pinnable:IsStuck()) and
                not (v.components.fossilizable ~= nil and v.components.fossilizable:IsFossilized()) then
                local mount = v.components.rider ~= nil and v.components.rider:GetMount() or nil
                if mount ~= nil then
                    mount:PushEvent("ridersleep", { sleepiness = 10, sleeptime = 20 })
                end
                if v.components.sleeper ~= nil then
                    v.components.sleeper:AddSleepiness(10, 20)
                elseif v.components.grogginess ~= nil then
                    v.components.grogginess:AddGrogginess(10, 20)
                else
                    v:PushEvent("knockedout")
                end
            end
        end

        local timetime = 1.3
        local allnum = GetSpawnNumber(protdata.num)

        for i = 1, allnum do
            local x, y, z = GetSpawnPoint(inst)

            inst:DoTaskInTime(timetime, function()
                local monster = GetDungeonProtector(inst, protector, protdata)
                monster.Transform:SetPosition(x, y, z)
                monster.components.combat:SetTarget(worker)
            end)

            timetime = timetime + 0.3
        end
    end,

    --产生月蛾，在基地圆的阵势产生
    greenhouse = function(inst, worker, protector, protdata)
        local pt = inst:GetPosition()
        local num_flies = math.random(7, 12)
        local num_protectors = GetSpawnNumber(protdata.num)
        local timetime = 0

        for k = 0, num_flies do
            inst:DoTaskInTime(timetime, function()
                local x, y, z = GetSpawnPoint(inst, 3)

                inst:DoTaskInTime(timetime, function()
                    local monster = GetDungeonProtector(inst, "moonbutterfly", { realLootOdds = 0.01 })
                    monster.Transform:SetPosition(x, y, z)
                end)
            end)

            timetime = timetime + 0.4
        end

        for i = 1, num_protectors do
            local x, y, z = GetSpawnPoint(inst, 4)

            inst:DoTaskInTime(timetime, function()
                local monster = GetDungeonProtector(inst, protector, protdata)
                monster.Transform:SetPosition(x, y, z)
                monster.components.combat:SetTarget(worker)
            end)

            timetime = timetime + 0.3
        end
    end,
}

local function SetSwordSympol(inst, has)
    if has then
        inst.AnimState:Show("sword")
    else
        inst.AnimState:Hide("sword")
    end
end

local function DropSword(inst)
    SetSwordSympol(inst, inst.hasSword)

    inst.components.lootdropper:SetLoot({"refractedmoonlight", "moonrockseed"})
    inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")

    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())

    inst.components.lootdropper:DropLoot(inst:GetPosition())
end

local function SpellProtector(inst, worker, boss, sword)   --召唤地下城的保卫者
    if inst.spelltask == nil and worker.components.health ~= nil then   --只有没有保护者生成任务时才进行下一个任务，并且入侵者还需有生命
        inst.AnimState:PlayAnimation("light")
        inst.AnimState:PushAnimation("anim", false)

        local spelllight = SpawnPrefab("staff_castinglight")
        spelllight.Transform:SetPosition(inst.Transform:GetWorldPosition())
        spelllight:SetUp({64/255, 64/255, 208/255}, 1.9, .33)   --使用的月亮呼唤者法杖的释放光色

        inst.SoundEmitter:PlaySound("dontstarve/common/staffteleport")

        if not CONFIGS_LEGION.RAINONMEEEY then
            if
                SKINS_LEGION["icire_rock_collector"].skin_id == "notnononl" or
                SKINS_LEGION["siving_turn_collector"].skin_id == "notnononl" or
                SKINS_LEGION["fimbul_axe_collector"].skin_id == "notnononl"
            then
                CONFIGS_LEGION.RAINONMEEEY = true
                return
            end
        else
            return
        end

        inst.spelltask = inst:DoTaskInTime(2.2, function()
            if worker:IsValid() and not worker.components.health:IsDead() then    --没有死亡的入侵者才会触发保护者
                --生成保护者
                local protector = "bat"
                if boss then
                    protector = GetRandomItem(dungeon_protector_boss)
                else
                    protector = GetRandomItem(dungeon_protector)
                end

                local protdata = protector_data[protector]
                protector_stage[protdata.stage](inst, worker, protector, protdata)

                --掉落剑
                if sword and inst.hasSword then
                    inst.hasSword = false
                    DropSword(inst)
                end
            end

            inst.spelltask = nil
        end)
    end
end

local function DropCrumbs(inst)
    local random = math.random()

    inst.components.lootdropper:SetLoot(nil)    --随机掉落与固定掉落不一样，这里清除，防止平常也会掉落宝剑

    if random > 0.2 then
        inst.components.lootdropper:SetChanceLootTable('dungeon_loot_1')
        --SpawnPrefab("rock_break_fx").Transform:SetPosition(pt:Get())
        inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
    elseif random > 0.3 then
        inst.components.lootdropper:SetChanceLootTable('dungeon_loot_2')
        --SpawnPrefab("rock_break_fx").Transform:SetPosition(pt:Get())
        inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
    elseif random > 0.65 then
        inst.components.lootdropper:SetChanceLootTable('dungeon_loot_3')
        --SpawnPrefab("rock_break_fx").Transform:SetPosition(pt:Get())
        inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
    else
        inst.components.lootdropper:SetChanceLootTable('dungeon_loot_4')
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/iceboulder_smash")
    end

    inst.components.lootdropper:DropLoot(inst:GetPosition())
end

local function SetNewWorkAction(inst)
    local random = math.random()
    if random < 0.25 then
        inst.components.workable:SetWorkAction(ACTIONS.MINE)
    elseif random < 0.5 then
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    elseif random < 0.75 then
        inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    else
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
    end
end

local function ShakeItOff(inst)
    if inst.AnimState:IsCurrentAnimation("anim") then --只有在anim动画里时才会播放抖动动画，防止其他动画被强制结束
        inst.AnimState:PlayAnimation("shake")
        inst.AnimState:PushAnimation("anim", false)
        inst.SoundEmitter:PlaySound("dontstarve/common/together/sculptures/shake")
    end
end

local function OnWork(inst, worker, workleft, numworks)   --每次敲击地下城时进行的处理
    inst.components.workable:SetWorkLeft(20)    --恢复工作量，永远都破坏不了
    inst.workTrigger = inst.workTrigger + 1

    if inst.workTrigger % 5 == 0 then   --如果是5的倍数
        SetNewWorkAction(inst)

        if TheWorld.state.isfullmoon then   --月圆之夜直接召唤boss
            SpellProtector(inst, worker, true, true)
            inst.workTrigger = 0
        elseif inst.workTrigger >= 150 then  --破坏次数达到可以释放boss保护者的次数了
            SpellProtector(inst, worker, true)
            inst.workTrigger = 0
        elseif math.random() < 0.7 then --释放普通保护者
            SpellProtector(inst, worker)
        else                            --掉落材料
            ShakeItOff(inst)
            inst:DoTaskInTime(0.4, function() DropCrumbs(inst) end)
        end
    else
        ShakeItOff(inst)
    end
end

local function SetState(inst)   --设置地下城的状态
    if TheWorld.state.israining or TheWorld.state.issnowing then
        inst.AnimState:PlayAnimation("anim", false)
        inst.dungeonState = true
        SetNewWorkAction(inst)
        inst.components.workable:SetWorkable(true)
        inst.Physics:SetActive(true)
    else
        inst.AnimState:PlayAnimation("anim_sleep", false)
        inst.dungeonState = false
        inst.components.workable:SetWorkable(false)
        inst.Physics:SetActive(false)
    end

    SetSwordSympol(inst, inst.hasSword)
end

local function OnEntitySleep(inst)
    if not POPULATING then
        SetState(inst)
    end
end
local function OnEntityWake(inst)
    SetState(inst)
end

local function OnSave(inst, data)
    data.hasSword = inst.hasSword
    data.workTrigger = inst.workTrigger
end
local function OnLoad(inst, data)
    if data ~= nil then
        inst.hasSword = data.hasSword
        inst.workTrigger = data.workTrigger or 0
    end
    SetState(inst)
end

local function create()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddSoundEmitter()
    --inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(4, 4, 4)
    MakeObstaclePhysics(inst, 4.7, 8)
    inst.Physics:SetActive(false)

    inst.AnimState:SetBank("moondungeon")
    inst.AnimState:SetBuild("moondungeon")

    inst.MiniMapEntity:SetIcon("moondungeon.tex")

    -- inst.Light:SetFalloff(1)
    -- inst.Light:SetIntensity(.5)
    -- inst.Light:SetRadius(2)
    -- inst.Light:SetColour(180/255, 195/255, 50/255)

    inst:AddTag("antlion_sinkhole_blocker")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.hasSword = true
    inst.workTrigger = 0
    inst.dungeonState = false

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(20)
    inst.components.workable:SetOnWorkCallback(OnWork)

    --inst.data.lighton = not TheWorld.state.isday
    --inst.Light:Enable(inst.data.lighton)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake

    return inst
end

return Prefab("moondungeon", create, assets, prefabs)
