local prefs = {}
local birdbrain = require("brains/siving_phoenixbrain")

--------------------------------------------------------------------------
--[[ 通用 ]]
--------------------------------------------------------------------------

local LineMap = {
    silk = 2,
    beardhair = 4,
    steelwool = 20,
    cattenball = 15
}

local BossSounds = {
    step = "dontstarve_DLC001/creatures/buzzard/hurt",
    death = "dontstarve_DLC001/creatures/buzzard/death",
    flyaway = "dontstarve_DLC001/creatures/buzzard/flyout",
    flap = "dontstarve_DLC001/creatures/buzzard/flap",
    atk = "dontstarve_DLC001/creatures/buzzard/attack",
    taunt = "dontstarve_DLC001/creatures/buzzard/taunt",
    caw = "dontstarve_DLC001/creatures/buzzard/squack",
    hurt = "dontstarve_DLC001/creatures/buzzard/hurt"
}

local DIST_MATE = 15 --离伴侣的最远距离
local DIST_REMOTE = 25 --最大活动范围
local DIST_ATK = 3.5 --普通攻击范围
local DIST_SPAWN = DIST_REMOTE + DIST_ATK --距离神木的最大距离
local DIST_FLAP = 8 --羽乱舞射程
local DIST_FEA_EXPLODE = 2.5 --精致子圭翎羽的爆炸半径
local DIST_ROOT_ATK = 1.5 --子圭突触的攻击半径

local TIME_BUFF_WARBLE = 6 --魔音绕耳debuff 持续时间
local TIME_FLAP = 40 --羽乱舞 冷却时间
local TIME_FEA_EXPLODE = 30 --精致子圭翎羽爆炸时间
local TIME_TAUNT = 50 --魔音绕梁 冷却时间 50
local TIME_CAW = 50 --花寄语 冷却时间 50

local ATK_NORMAL = 15 --啄击攻击力
local ATK_GRIEF = 10 --悲愤状态额外攻击力
local ATK_FEA = 45 --子圭翎羽攻击力
local ATK_FEA_REAL = 75 --精致子圭翎羽攻击力
local ATK_FEA_EXPLODE = 100 --精致子圭翎羽的爆炸伤害
local ATK_ROOT = 80 --子圭突触攻击力
local ATK_HUTR = 130 --反伤上限

local COUNT_FLAP = 3 --羽乱舞次数
local COUNT_FLAP_GRIEF = 4 --羽乱舞次数（悲愤状态）
local COUNT_FLAP_DT = 4 --每次羽乱舞的间隔攻击次数

local TIME_EYE_DT = 1.5
local TIME_EYE_DT_GRIEF = 0.6
local COUNT_EYE = 8 --8
local COUNT_EYE_GRIEF = 11 --11

local TAGS_CANT = { "NOCLICK", "shadow", "shadowminion", "playerghost", "ghost",
                    "INLIMBO", "wall", "structure", "balloon", "siving", "boat", "boatbumper" }

if CONFIGS_LEGION.PHOENIXBATTLEDIFFICULTY == 1 then
    DIST_FLAP = 7
    TIME_BUFF_WARBLE = 0
    TIME_FLAP = 45
    TIME_TAUNT = 70
    TIME_CAW = 70
    ATK_NORMAL = 10
    ATK_GRIEF = 8
    ATK_FEA = 30
    ATK_FEA_REAL = 60
    ATK_FEA_EXPLODE = 80
    ATK_ROOT = 50
    ATK_HUTR = 0
    COUNT_FLAP = 2
    COUNT_FLAP_GRIEF = 3
    COUNT_FLAP_DT = 5
    TIME_EYE_DT = 1.8
    TIME_EYE_DT_GRIEF = 0.9
    COUNT_EYE = 6
    COUNT_EYE_GRIEF = 9
elseif CONFIGS_LEGION.PHOENIXBATTLEDIFFICULTY == 3 then
    DIST_FLAP = 10
    TIME_BUFF_WARBLE = 10
    TIME_FLAP = 35
    TIME_TAUNT = 30
    TIME_CAW = 30
    ATK_NORMAL = 25
    ATK_GRIEF = 15
    ATK_FEA = 50
    ATK_FEA_REAL = 80
    ATK_FEA_EXPLODE = 150
    ATK_ROOT = 100
    ATK_HUTR = 80
    COUNT_FLAP = 4
    COUNT_FLAP_GRIEF = 5
    COUNT_FLAP_DT = 3
    TIME_EYE_DT = 1.3
    TIME_EYE_DT_GRIEF = 0.5
    COUNT_EYE = 10
    COUNT_EYE_GRIEF = 13
end

local function IsValid(one)
    return one:IsValid() and
        one.components.health ~= nil and not one.components.health:IsDead()
end
local function CheckMate(inst)
    if inst.mate ~= nil then
        if not IsValid(inst.mate) then
            inst.mate = nil
        end
    end
end
local function GetDamage(inst, target, basedamage)
    if inst.isgrief then
        basedamage = basedamage + ATK_GRIEF
    end
    if target:HasTag("player") then
        return basedamage
    else
        return basedamage*3
    end
end
local function GetDamage2(target, basedamage)
    if target:HasTag("player") then
        return basedamage
    else
        return basedamage*3
    end
end
local function SpawnFlower(inst, target)
    local flower = SpawnPrefab("siving_boss_flowerfx")
    if flower ~= nil then
        flower.Transform:SetPosition(target.Transform:GetWorldPosition())
        flower:fn_onBind(inst, target)
    end
end
local function SpawnRoot(bird, x, z, delaytime)
    if TheWorld.Map:IsAboveGroundAtPoint(x, 0, z) then
        local root = SpawnPrefab("siving_boss_root")
        if root ~= nil then
            root.Transform:SetPosition(x, 0, z)
            root.OnTreeLive(root, bird.tree and bird.tree.treeState or 0)
            root.fn_onAttack(root, bird, delaytime or 0.3)
        end
    end
end
local function SetTreeBuff(inst, value)
    value = inst.sign_l_treehalo + value
    if value > 3 then
        value = 3
    elseif value < 0 then
        value = 0
    end
    if inst.sign_l_treehalo == value then
        return
    end
    if inst.sign_l_treehalo <= 0 then --第一次加buff时
        inst.count_toolatk = 0
    end
    inst.sign_l_treehalo = value

    if value == 0 then --说明要清除buff了
        inst.count_toolatk = 0
        if not inst.components.debuffable:HasDebuff("buff_treehalo") then
            return --既然还没有buff，那就不用做什么
        end
    end

    --即使是清除buff，也是通过赋值 sign_l_treehalo=0 后 AddDebuff 来解除buff
    inst:AddDebuff("buff_treehalo", "buff_treehalo")
end
local function SetBehaviorTree(inst, done)
    if done == "atk" then
        inst._count_atk = inst._count_atk + 1
        if inst._count_atk >= COUNT_FLAP_DT then --每啄击几下，进行一次羽乱舞
            inst.components.timer:StopTimer("flap")
            inst.sg.mem.to_flap = true --不用事件，回到idle时自己检查吧
        end
    elseif done == "flap" then
        inst._count_atk = 0
        inst.components.timer:StopTimer("flap")
        inst.components.timer:StartTimer("flap", TIME_FLAP)
    elseif done == "taunt" then
        inst._count_atk = 0
        inst.components.timer:StopTimer("taunt")
        inst.components.timer:StartTimer("taunt", TIME_TAUNT)
    elseif done == "caw" then
        inst._count_atk = 0
        inst.components.timer:StopTimer("caw")
        inst.components.timer:StartTimer("caw", TIME_CAW)
    end
end

local function MagicWarble(inst) --魔音绕梁
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, 0, z, DIST_REMOTE, { "_combat", "_inventory" }, { "INLIMBO", "siving", "l_noears" })
    for _, v in ipairs(ents) do
        if
            (v.components.health == nil or not v.components.health:IsDead()) and
            v.components.inventory ~= nil and
            v.components.locomotor ~= nil
        then
            local inv = v.components.inventory
            local hasprotect = false
            for slot, item in pairs(inv.equipslots) do
                if slot ~= EQUIPSLOTS.BEARD then --可不能把威尔逊的“胡子”给吼下来了
                    if item.prefab == "earmuffshat" or item.protect_l_magicwarble then
                        hasprotect = true
                    else
                        inv:DropItem(item, true, true)
                    end
                end
            end

            --装备了兔耳罩就能避免后续的debuff
            if not hasprotect and TIME_BUFF_WARBLE > 0 then
                v.time_l_magicwarble = { replace_min = TIME_BUFF_WARBLE }
                v:AddDebuff("debuff_magicwarble", "debuff_magicwarble")

                if inst.isgrief then --悲愤状态：附加睡醒的移速缓慢状态
                    if v.task_groggy_warble ~= nil then
                        v.task_groggy_warble:Cancel()
                    end
                    v:AddTag("groggy") --添加标签，走路会摇摇晃晃
                    v.components.locomotor:SetExternalSpeedMultiplier(v, "magicwarble", 0.4)
                    v.task_groggy_warble = v:DoTaskInTime(TIME_BUFF_WARBLE, function(v)
                        if v.components.locomotor ~= nil then
                            v.components.locomotor:RemoveExternalSpeedMultiplier(v, "magicwarble")
                        end
                        v:RemoveTag("groggy")
                        v.task_groggy_warble = nil
                    end)
                end
            end
        end
    end
    SetBehaviorTree(inst, "taunt")
end
local function DiscerningPeck(inst, target) --啄击
    if target == nil then
        target = inst.components.combat.target
    end
    if target ~= nil then
        if inst.components.combat:CanHitTarget(target, nil) then
            --能命中时，才会开始破防改造
            UndefendedATK_legion(inst, { target = target })
        end
        inst.components.combat:DoAttack(target)
    end
    SetBehaviorTree(inst, "atk")
end
local function ReleaseFlowers(inst) --花寄语
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, 0, z, DIST_REMOTE, { "_combat", "_health" }, TAGS_CANT)

    for _, v in ipairs(ents) do
        if
            not v.hassivflower and --防止重复寄生
            v.components.health ~= nil and not v.components.health:IsDead() and
            (v.components.inventory == nil or not v.components.inventory:EquipHasTag("siv_BFF")) and
            (inst.isgrief or math.random() < 0.33)
        then
            SpawnFlower(inst, v)
        end
    end
    SetBehaviorTree(inst, "caw")
end
local function BeTreeEye(inst) --同目同心
    if inst:fn_canBeEye() then
        local eye = SpawnPrefab("siving_boss_eye")
        if eye ~= nil then
            eye:fn_onBind(inst.tree, inst)
            return true
        end
    end
    return false
end
local function FeathersFlap(inst) --羽乱舞
    local x, y, z = inst.Transform:GetWorldPosition()
    local num = math.random(2, 3)
    for i = 1, num, 1 do
        local fea = SpawnPrefab(math.random() < 0.2 and "siving_bossfea_real" or "siving_bossfea_fake")
        if fea ~= nil then
            fea.Transform:SetPosition(x, 0, z)
            fea.components.projectilelegion:Throw(fea, Vector3(GetCalculatedPos_legion(x, 0, z, 2)), inst, nil)
            fea.components.projectilelegion:DelayVisibility(fea.projectiledelay)
        end
    end
    SetBehaviorTree(inst, "flap")
end

local function MakeBoss(data)
    table.insert(prefs, Prefab(
        data.name,
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddSoundEmitter()
            inst.entity:AddDynamicShadow()
            inst.entity:AddLight()
            inst.entity:AddNetwork()

            inst.DynamicShadow:SetSize(2.5, 1.5)
            inst.Transform:SetScale(2.1, 2.1, 2.1)
            inst.Transform:SetFourFaced()

            MakeGhostPhysics(inst, 1500, 1.2) --鬼魂类物理，主要是为了不对子圭羽毛产生碰撞

            inst:AddTag("epic")
            -- inst:AddTag("noepicmusic")
            inst:AddTag("scarytoprey")
            inst:AddTag("hostile")
            inst:AddTag("largecreature")
            inst:AddTag("siving")
            inst:AddTag("siving_boss")
            -- inst:AddTag("flying")
            inst:AddTag("ignorewalkableplatformdrowning")

            --trader (from trader component) added to pristine state for optimization
            inst:AddTag("trader")

            inst.Light:Enable(true)
            inst.Light:SetRadius(2)
            inst.Light:SetFalloff(1)
            inst.Light:SetIntensity(.5)
            inst.Light:SetColour(15/255, 180/255, 132/255)
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

            inst.AnimState:SetBank("buzzard")
            inst.AnimState:SetBuild(data.name)
            inst.AnimState:PlayAnimation("idle", true)

            inst:SetPrefabNameOverride("siving_phoenix")

            -- if data.fn_common ~= nil then
            --     data.fn_common(inst)
            -- end

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst._count_atk = 0 --啄击次数
            inst._count_rock = 0 --喂食后需要掉落的子圭石数量

            inst.sounds = BossSounds
            inst.sign_l_treehalo = 0
            inst.count_toolatk = 0 --被镐子类工具攻击次数
            inst.tree = nil
            inst.mate = nil --另一个伴侣
            inst.isgrief = false --是否处于悲愤状态
            inst.iseye = false --是否是木之眼状态
            inst.eyefx = nil --木之眼实体
            inst.fn_onGrief = function(inst, tree, dotaunt)
                inst.isgrief = true
                inst.AnimState:OverrideSymbol("buzzard_eye", data.name, "buzzard_angryeye")
                inst.Light:SetColour(255/255, 127/255, 82/255)
                inst.components.combat:SetDefaultDamage(ATK_NORMAL+ATK_GRIEF)
                if dotaunt then
                    inst:PushEvent("dotaunt")
                end
            end
            inst.fn_leave = function(inst)
                inst.tree = nil
                inst.mate = nil
                if inst.eyefx ~= nil and inst.eyefx:IsValid() then
                    inst.eyefx:Remove()
                end
                if inst:IsAsleep() or inst.iseye then
                    inst:Remove()
                else
                    inst:PushEvent("dotakeoff")
                end
            end
            inst.fn_canBeEye = function(inst)
                if
                    inst.tree ~= nil and inst.tree:IsValid()
                then
                    if inst.tree.myEye == nil then
                        return true
                    end
                    if inst.tree.myEye == inst then --因为提前占用了，所以是自己很正常
                        return true
                    end
                    if not IsValid(inst.tree.myEye) then
                        inst.tree.myEye = nil
                        return true
                    end
                    if not inst.tree.myEye.iseye then --木眼对象没有木眼标志(猜测可能正在进入木眼状态)
                        if not inst.tree.myEye.sg:HasStateTag("flyaway") then --然而并没有在进入木眼状态
                            inst.tree.myEye = nil
                            return true
                        end
                    end
                end
                return false
            end
            inst.fn_onFly = function(inst, params)
                if params ~= nil then
                    if params.x and params.z then
                        inst.Transform:SetPosition(params.x, params.y or 30, params.z)
                        inst.sg:GoToState("glide")
                        return
                    elseif params.beeye then --同目同心
                        if not inst:fn_beTreeEye() then
                            if inst.tree then
                                inst.tree.myEye = nil
                            end
                            local x, y, z = inst.Transform:GetWorldPosition()
                            inst.Transform:SetPosition(x, 30, z)
                            inst.sg:GoToState("glide")
                        end
                        return
                    end
                end
                inst:Remove() --飞上天就消失啦
            end

            inst.COUNT_FLAP = COUNT_FLAP
            inst.COUNT_FLAP_GRIEF = COUNT_FLAP_GRIEF
            inst.DIST_FLAP = DIST_FLAP
            inst.DIST_REMOTE = DIST_REMOTE
            inst.DIST_MATE = DIST_MATE
            inst.DIST_ATK = DIST_ATK
            inst.DIST_SPAWN = DIST_SPAWN
            inst.TIME_FLAP = TIME_FLAP

            inst.fn_magicWarble = MagicWarble
            inst.fn_discerningPeck = DiscerningPeck
            inst.fn_releaseFlowers = ReleaseFlowers
            inst.fn_beTreeEye = BeTreeEye
            inst.fn_feathersFlap = FeathersFlap

            inst:AddComponent("locomotor") --locomotor must be constructed before the stategraph
            inst.components.locomotor.walkspeed = 4
            inst.components.locomotor.runspeed = 5
            inst.components.locomotor:EnableGroundSpeedMultiplier(true)
            inst.components.locomotor:SetTriggersCreep(true)
            inst.components.locomotor.pathcaps = { ignorewalls = true, allowocean = true }

            inst:AddComponent("health")
            inst.components.health:SetMaxHealth(9000)
            inst.components.health.destroytime = 3

            inst:AddComponent("combat")
            inst.components.combat:SetDefaultDamage(ATK_NORMAL)
            -- inst.components.combat.playerdamagepercent = 0.5
            inst.components.combat.hiteffectsymbol = "buzzard_body"
            inst.components.combat.battlecryenabled = false
            inst.components.combat:SetRange(DIST_ATK)
            inst.components.combat:SetAttackPeriod(3)
            inst.components.combat:SetRetargetFunction(1.5, function(inst)
                CheckMate(inst)
                return FindEntity(inst.tree or inst, DIST_SPAWN,
                        inst.mate == nil and function(guy) --对自己有仇恨就行
                            return (inst.isgrief or guy.components.combat.target == inst)
                                and inst.components.combat:CanTarget(guy)
                        end or function(guy) --对自己有仇恨并且不能和伴侣的目标相同
                            return (inst.isgrief or guy.components.combat.target == inst)
                                and inst.components.combat:CanTarget(guy)
                                and inst.mate.components.combat.target ~= guy
                        end,
                        { "_combat" },
                        { "INLIMBO", "siving" }
                    )
            end)
            inst.components.combat:SetKeepTargetFunction(function(inst, target)
                CheckMate(inst)
                if inst.components.combat:CanTarget(target) then
                    if inst.mate == nil then --只需要不跑出神木范围就行
                        return target:GetDistanceSqToPoint(
                                inst.components.knownlocations:GetLocation("tree") or
                                inst.components.knownlocations:GetLocation("spawnpoint")
                            ) < DIST_SPAWN^2
                    else --不跑得离伴侣以及神木范围太远就行
                        return (
                                target:GetDistanceSqToPoint(
                                    inst.components.knownlocations:GetLocation("tree") or
                                    inst.components.knownlocations:GetLocation("spawnpoint")
                                ) < DIST_SPAWN^2
                            ) and (
                                inst.mate.iseye or
                                inst:GetDistanceSqToPoint(inst.mate:GetPosition()) < (DIST_MATE+DIST_ATK)^2
                            )
                    end
                end
            end)
            inst.components.combat:SetHurtSound(BossSounds.hurt) --undo

            --攻击时针对于被攻击对象的额外伤害值
            inst.components.combat.bonusdamagefn = function(inst, target, damage, weapon)
                if not target:HasTag("player") then
                    return inst.components.combat.defaultdamage*2 --加上已有的伤害，就是3倍伤害啦
                end
                return 0
            end

            inst:AddComponent("trader")
            inst.components.trader.acceptnontradable = true
            inst.components.trader:SetAcceptTest(function(inst, item, giver)
                if inst.components.combat.target ~= nil or inst.sg:HasStateTag("busy") then
                    return false
                end
                local loveditems = {
                    myth_lotus_flower = 1,
                    aip_veggie_sunflower = 1,
                    cutted_rosebush = 1,
                    cutted_lilybush = 1,
                    cutted_orchidbush = 1
                }
                if loveditems[item.prefab] ~= nil or item.sivbird_l_food ~= nil then
                    --由于一次只给一个太慢了，这里手动从玩家身上全部拿下来
                    local num = item.components.stackable ~= nil and item.components.stackable.stacksize or 1
                    if num > 1 then
                        --拿走只剩1个，以供剩下的逻辑调用
                        local itemlast = item.components.stackable:Get(num - 1)
                        itemlast:Remove()
                    end
                    inst._count_rock = inst._count_rock + num*(loveditems[item.prefab] or item.sivbird_l_food)
                    return true
                else
                    return false
                end
            end)
            inst.components.trader.onaccept = function(inst, giver, item)
                inst:PushEvent("dofeeded")
            end
            inst.components.trader.onrefuse = function(inst, giver, item)
                inst:PushEvent("dorefuse")
            end

            inst:AddComponent("debuffable")
            inst.components.debuffable:SetFollowSymbol("buzzard_body", 0, -200, 0)

            inst:AddComponent("inspectable")
            inst.components.inspectable.getstatus = function(inst)
                return inst.isgrief and "GRIEF" or "GENERIC"
            end

            inst:AddComponent("explosiveresist")

            inst:AddComponent("sleeper")
            inst.components.sleeper:SetResistance(4)
            inst.components.sleeper:SetSleepTest(function(inst)
                return false
            end)
            inst.components.sleeper:SetWakeTest(function(inst)
                return true
            end)

            inst:AddComponent("knownlocations")

            inst:AddComponent("timer")
            inst.components.timer:StartTimer("flap", TIME_FLAP)
            inst.components.timer:StartTimer("taunt", TIME_TAUNT)
            inst.components.timer:StartTimer("caw", TIME_CAW)

            inst:AddComponent("lootdropper")

            MakeMediumFreezableCharacter(inst, "buzzard_body")

            inst:AddComponent("hauntable")

            inst:SetStateGraph("SGsiving_phoenix") --这个应该是指文件的名字，而不是数据的名字
            inst:SetBrain(birdbrain)

            inst:ListenForEvent("attacked", function(inst, data)
                if data.attacker and IsValid(data.attacker) then
                    if ATK_HUTR > 0 and data.damage and data.attacker.components.combat ~= nil then
                        --将单次伤害超过伤害上限的部分反弹给攻击者
                        if data.damage > ATK_HUTR then
                            --为了不受到盾反伤害，不设定玄鸟为攻击者
                            data.attacker.components.combat:GetAttacked(nil, data.damage-ATK_HUTR)
                            --反击特效 undo
                            if not IsValid(data.attacker) then --攻击者死亡，就结束
                                return
                            end
                        end

                        --受到远程攻击，神木会帮忙做出惩罚
                        if --远程武器分为两类，一类是有projectile组件、一类是weapon组件中有projectile属性
                            data.attacker:HasTag("structure") or --针对建筑型攻击者
                            (data.weapon ~= nil and (
                                data.weapon.components.projectile ~= nil or
                                data.weapon.components.projectilelegion ~= nil or
                                data.weapon:HasTag("rangedweapon") or
                                (data.weapon.components.weapon ~= nil and data.weapon.components.weapon.projectile ~= nil)
                            ))
                        then
                            local x, y, z = data.attacker.Transform:GetWorldPosition()
                            SpawnRoot(inst, x, z)
                        end
                    end

                    CheckMate(inst)
                    if inst.components.health:IsDead() then
                        if inst.mate ~= nil then --自己被打死，伴侣仇恨攻击者
                            inst.mate.components.combat:SetTarget(data.attacker)
                        end
                        return
                    end

                    if
                        inst.sign_l_treehalo > 0 and
                        data.weapon ~= nil and
                        data.weapon.components.tool ~= nil and
                        data.weapon.components.tool:CanDoAction(ACTIONS.MINE)
                    then
                        inst.count_toolatk = inst.count_toolatk + 1
                        if inst.count_toolatk >= 4 then --达到4次就减少一层buff
                            SetTreeBuff(inst, -1)
                            inst.count_toolatk = 0
                        end
                    end

                    --现在是雌雄双打
                    local lasttarget = inst.components.combat.target
                    --谁离得近打谁
                    if lasttarget ~= nil and IsValid(lasttarget) then
                        if
                            inst:GetDistanceSqToPoint(lasttarget:GetPosition())
                            > inst:GetDistanceSqToPoint(data.attacker:GetPosition())
                        then
                            inst.components.combat:SetTarget(data.attacker)
                        end
                    else
                        inst.components.combat:SetTarget(data.attacker)
                    end
                    lasttarget = inst.components.combat.target
                    if lasttarget and inst.mate ~= nil and inst.mate.components.combat.target == nil then
                        inst.mate.components.combat:SetTarget(lasttarget)
                    end

                    --[[
                    local lasttarget = inst.components.combat.target

                    --保持伴侣和自己同时仇恨不同的对象
                    if inst.mate == nil then
                        if data.attacker == lasttarget then
                            return
                        end

                        --谁离得近打谁
                        if lasttarget ~= nil and IsValid(lasttarget) then
                            if
                                inst:GetDistanceSqToPoint(lasttarget:GetPosition())
                                > inst:GetDistanceSqToPoint(data.attacker:GetPosition())
                            then
                                inst.components.combat:SetTarget(data.attacker)
                            end
                        else
                            inst.components.combat:SetTarget(data.attacker)
                        end
                    else
                        local matetarget = inst.mate.components.combat.target

                        if data.attacker == lasttarget then
                            if lasttarget == matetarget then
                                inst.mate.components.combat:SetTarget(nil)
                            end
                            return
                        end

                        --谁离得近打谁
                        if lasttarget ~= nil and IsValid(lasttarget) then
                            if
                                inst:GetDistanceSqToPoint(lasttarget:GetPosition())
                                > inst:GetDistanceSqToPoint(data.attacker:GetPosition())
                            then
                                inst.components.combat:SetTarget(data.attacker)
                                if data.attacker == matetarget then
                                    inst.mate.components.combat:SetTarget(nil)
                                end
                            end
                        else
                            inst.components.combat:SetTarget(data.attacker)
                            if data.attacker == matetarget then
                                inst.mate.components.combat:SetTarget(nil)
                            end
                        end
                    end
                    ]]--
                end
            end)
            inst:ListenForEvent("timerdone", function(inst, data)
                if data.name == "flap" then
                    inst:PushEvent("doflap")
                elseif data.name == "taunt" then
                    inst:PushEvent("dotaunt")
                elseif data.name == "caw" then
                    inst:PushEvent("docaw")
                end
            end)

            inst.OnSave = function(inst, data)
                if inst.sign_l_treehalo > 0 then
                    data.sign_l_treehalo = inst.sign_l_treehalo
                end
            end
            inst.OnPreLoad = function(inst, data) --防止保存时正在飞起或降落导致重载时位置不对
                local x, y, z = inst.Transform:GetWorldPosition()
                if y > 0 then
                    inst.Transform:SetPosition(x, 0, z)
                end
            end
            inst.OnLoad = function(inst, data)
                if data ~= nil and data.sign_l_treehalo ~= nil then
                    inst:DoTaskInTime(0.2, function(inst)
                        SetTreeBuff(inst, data.sign_l_treehalo)
                    end)
                end
            end
            inst.OnEntitySleep = function(inst)
                inst.components.combat:SetTarget(nil)
            end
            -- inst.OnRemoveEntity = function(inst)end

            if data.fn_server ~= nil then
                data.fn_server(inst)
            end

            return inst
        end,
        {
            Asset("ANIM", "anim/buzzard_basic.zip"), --官方秃鹫动画模板
            Asset("ANIM", "anim/"..data.name..".zip"),
        },
        {
            "debuff_magicwarble",
            "siving_boss_flowerfx",
            "siving_boss_eye",
            "siving_bossfea_real",
            "siving_bossfea_fake",
            "siving_boss_taunt_fx",
            "siving_boss_caw_fx",
            "siving_boss_root",
            "buff_treehalo"
        }
    ))
end

------
------

local function OnEquip(inst, owner)
    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.equip ~= nil then
        owner.AnimState:OverrideSymbol(skindata.equip.symbol, skindata.equip.build, skindata.equip.file)
        if skindata.equip.isshield then
            owner.AnimState:Show("LANTERN_OVERLAY")
            owner.AnimState:HideSymbol("swap_object")
            owner.AnimState:ClearOverrideSymbol("swap_object")
        end
        if skindata.equip.startfn then
            skindata.equip.startfn(inst, owner)
        end
    else
        owner.AnimState:OverrideSymbol("swap_object", inst.prefab, "swap")
    end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if owner:HasTag("equipmentmodel") then --假人！
        return
    end

    owner:AddTag("s_l_throw") --skill_legion_throw
    owner:AddTag("siv_feather")
end
local function OnUnequip(inst, owner)
    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.equip ~= nil then
        owner.AnimState:ClearOverrideSymbol(skindata.equip.symbol)
        if skindata.equip.isshield then
            owner.AnimState:Hide("LANTERN_OVERLAY")
            owner.AnimState:ShowSymbol("swap_object")
        end
        if skindata.equip.endfn then
            skindata.equip.endfn(inst, owner)
        end
    else
        owner.AnimState:ClearOverrideSymbol("swap_object")
    end
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    owner:RemoveTag("s_l_throw") --skill_legion_throw
    owner:RemoveTag("siv_feather")
end
local function OnPickedUp_fea(inst, pickupguy, src_pos)
    if pickupguy and pickupguy.Transform then
        inst.Transform:SetRotation(pickupguy.Transform:GetRotation())
    end
end

local function OnThrown_fly(inst, owner, targetpos, attacker)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/swipe", nil, 0.2)
end
local function OnMiss_fly(inst, targetpos, attacker)
    if inst.components.projectilelegion.isgoback then
        inst.components.projectilelegion.isgoback = nil
        if attacker and attacker.sivfeathers_l ~= nil then
            local num = 0
            for _,v in ipairs(attacker.sivfeathers_l) do
                if v and v:IsValid() then
                    num = num + 1
                    v:Remove() --一旦有羽毛到达就把所有羽毛删了，防止残留
                end
            end
            attacker.sivfeathers_l = nil
            if num > 0 then
                local fea = SpawnPrefab(inst.feather_name, inst.feather_skin)
                fea.Transform:SetRotation(inst.Transform:GetRotation())
                fea.Transform:SetPosition(inst.Transform:GetWorldPosition())
                if num > 1 then
                    fea.components.stackable:SetStackSize(num)
                end
                if IsValid(attacker) then
                    if not attacker.components.inventory:Equip(fea) then
                        attacker.components.inventory:GiveItem(fea)
                    end
                end
            end
        end
        if inst:IsValid() then
            inst:Remove()
        end
    else
        if --有线，那就先以滞留体形式存在
            inst.hasline and
            inst.caster ~= nil and IsValid(inst.caster) and
            inst.caster.sivfeathers_l ~= nil
        then
            local fea = SpawnPrefab((inst.feather_skin or inst.feather_name).."_blk")
            fea.shootidx = inst.shootidx
            fea.caster = inst.caster
            inst.caster.sivfeathers_l[inst.shootidx] = fea
            fea.Transform:SetRotation(inst.Transform:GetRotation())
            fea.Transform:SetPosition(inst.Transform:GetWorldPosition())
            fea:PushEvent("on_landed")
        else --没有线的话，立即变回正常的羽毛
            local fea = SpawnPrefab(inst.feather_name, inst.feather_skin)
            fea.Transform:SetRotation(inst.Transform:GetRotation())
            fea.Transform:SetPosition(inst.Transform:GetWorldPosition())
        end
        inst:Remove()
    end
end
local function OnHit_fly_fake(inst, targetpos, doer, target)
    if math.random() < 0.05 then
        inst:Remove()
    end
end
local function OnThrown_fly_collector(inst, owner, targetpos, attacker)
    local rand = math.random()
    if rand < 0.33 then
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/catcoon/hiss_pre", nil, 0.5)
    elseif rand < 0.66 then
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/catcoon/attack", nil, 0.5)
    else
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/catcoon/pounce", nil, 0.5)
    end
end
local function SpawnFx_collector(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    for i = 1, math.random(2), 1 do
        local fx = SpawnPrefab(inst.feather_skin.."_flyfx")
        if fx ~= nil then
            local x1, y1, z1 = GetCalculatedPos_legion(x, y, z, math.random()*2, nil)
            fx.Transform:SetPosition(x1, y1, z1)
        end
    end
end

--[[
local function ReticuleTargetFn()
    return Vector3(ThePlayer.entity:LocalToWorldSpace(6.5, 0, 0))
end
local function ReticuleMouseTargetFn(inst, mousepos)
    if mousepos ~= nil then
        local x, y, z = inst.Transform:GetWorldPosition()
        local dx = mousepos.x - x
        local dz = mousepos.z - z
        local l = dx * dx + dz * dz
        if l <= 0 then
            return inst.components.reticule.targetpos
        end
        l = 6.5 / math.sqrt(l)
        return Vector3(x + dx * l, 0, z + dz * l)
    end
end
local function ReticuleUpdatePositionFn(inst, pos, reticule, ease, smoothing, dt)
    local x, y, z = inst.Transform:GetWorldPosition()
    reticule.Transform:SetPosition(x, 0, z)
    local rot = -math.atan2(pos.z - z, pos.x - x) / DEGREES
    if ease and dt ~= nil then
        local rot0 = reticule.Transform:GetRotation()
        local drot = rot - rot0
        rot = Lerp((drot > 180 and rot0 + 360) or (drot < -180 and rot0 - 360) or rot0, rot, dt * smoothing)
    end
    reticule.Transform:SetRotation(rot)
end
]]--

local sivfea_attack = 34
local sivfea_hpcost = 2

if CONFIGS_LEGION.SIVFEASTRENGTH == 3 then
    --nothing
elseif CONFIGS_LEGION.SIVFEASTRENGTH == 1 then
    sivfea_attack = 17
    sivfea_hpcost = 0.5
elseif CONFIGS_LEGION.SIVFEASTRENGTH == 2 then
    sivfea_attack = 23.8
    sivfea_hpcost = 1
elseif CONFIGS_LEGION.SIVFEASTRENGTH == 4 then
    sivfea_attack = 42.5
    sivfea_hpcost = 2.5
elseif CONFIGS_LEGION.SIVFEASTRENGTH == 5 then
    sivfea_attack = 51
    sivfea_hpcost = 3
elseif CONFIGS_LEGION.SIVFEASTRENGTH == 6 then
    sivfea_attack = 61.2
    sivfea_hpcost = 4
elseif CONFIGS_LEGION.SIVFEASTRENGTH == 7 then
    sivfea_attack = 68
    sivfea_hpcost = 4.5
end

local function SetAnim_fly_collector(inst)
    if math.random() < 0.4 then
        inst.AnimState:PlayAnimation("jump_loop")
        inst.AnimState:PushAnimation("jump_pst", false)
    else
        inst.AnimState:PlayAnimation("jump_out")
        inst.AnimState:PushAnimation("idle_loop", true)
    end
end
local function SetAnim_blk_collector(inst)
    local ran = math.random()
    if ran < 0.25 then
        inst.AnimState:PlayAnimation("emote_lick")
        inst.AnimState:PushAnimation("idle_loop", true)
    elseif ran < 0.5 then
        inst.AnimState:PlayAnimation("emote_stretch")
        inst.AnimState:PushAnimation("idle_loop", true)
    else
        inst.AnimState:PlayAnimation("idle_loop", true)
    end
end

local function InitFeaFx(inst)
    inst.OnLoad = function(inst, dataa)
        inst:DoTaskInTime(0.37, function(inst) --如果是加载时，应该恢复为正常的羽毛
            local fea = SpawnPrefab(inst.feather_name, inst.feather_skin)
            fea.Transform:SetPosition(inst.Transform:GetWorldPosition())
            inst:Remove()
        end)
    end
    inst.OnEntitySleep = function(inst) --inst.OnEntitySleep() 比组件的 OnEntitySleep() 先执行
        --玩家收回时若站得很近，会导致有两个会飞远，所以这里需要阻止其变回正常羽毛
        if inst.components.projectilelegion ~= nil then
            if inst.components.projectilelegion.isgoback then
                inst:Remove()
                return
            end
        end

        local fea = SpawnPrefab(inst.feather_name, inst.feather_skin)
        fea.Transform:SetRotation(inst.Transform:GetRotation())
        fea.Transform:SetPosition(inst.Transform:GetWorldPosition())
        inst:Remove()
    end
end
local function InitFloatable(inst, data)
    MakeInventoryFloatable(inst, data.size, data.offset_y, data.scale)
    if data.cut ~= nil then
        local OnLandedClient_old = inst.components.floater.OnLandedClient
        inst.components.floater.OnLandedClient = function(self)
            OnLandedClient_old(self)
            self.inst.AnimState:SetFloatParams(data.cut, 1, self.bob_percent)
        end
    end
end
local function MakeWeapon_replace(data)
    table.insert(prefs, Prefab( --飞行体
        data.name.."_fly",
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddSoundEmitter()
            inst.entity:AddNetwork()

            MakeInventoryPhysics(inst)
            RemovePhysicsColliders(inst)

            inst.AnimState:SetBank(data.name)
            inst.AnimState:SetBuild(data.name)

            inst:AddTag("sharp")
            inst:AddTag("nosteal")
            inst:AddTag("NOCLICK")
            inst:AddTag("moistureimmunity") --禁止潮湿：EntityScript:GetIsWet()

            --weapon (from weapon component) added to pristine state for optimization
            inst:AddTag("weapon")

            if data.fn_common_fly ~= nil then
                data.fn_common_fly(inst)
            end

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst.hasline = false
            inst.shootidx = 1
            inst.caster = nil

            --因为大力士攻击时会在不判空的情况下直接使用 inventoryitem，为了不崩溃，只能加个这个
            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem:EnableMoisture(false) --禁止潮湿：官方的代码有问题，会导致潮湿攻击滑落时叠加数变为1
            inst.components.inventoryitem.pushlandedevents = false
            inst.components.inventoryitem.canbepickedup = false

            inst:AddComponent("weapon")

            inst:AddComponent("projectilelegion")
            inst.components.projectilelegion.speed = 45
            inst.components.projectilelegion.onthrown = OnThrown_fly
            inst.components.projectilelegion.onmiss = OnMiss_fly
            if not data.isreal then
                inst.components.projectilelegion.onhit = OnHit_fly_fake
            end

            InitFeaFx(inst)

            if data.fn_server_fly ~= nil then
                data.fn_server_fly(inst)
            end

            return inst
        end,
        nil,
        nil
    ))

    table.insert(prefs, Prefab( --滞留体
        data.name.."_blk",
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddNetwork()

            MakeInventoryPhysics(inst)
            RemovePhysicsColliders(inst)

            inst.AnimState:SetBank(data.name)
            inst.AnimState:SetBuild(data.name)
            inst.Transform:SetEightFaced()

            inst:AddTag("NOCLICK")

            if data.fn_common_blk ~= nil then
                data.fn_common_blk(inst)
            end

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst.hasline = false
            inst.shootidx = 1
            inst.caster = nil
            inst.isblk = true

            InitFeaFx(inst)

            if data.fn_server_blk ~= nil then
                data.fn_server_blk(inst)
            end

            return inst
        end,
        nil,
        nil
    ))
end
local function MakeWeapon(data)
    local fea_damage
    local fea_range
    local fea_hpcost
    if data.isreal then
        fea_damage = sivfea_attack
        fea_range = 13
        fea_hpcost = sivfea_hpcost
    else
        fea_damage = 30.6 --34*0.9
        fea_range = 10
        fea_hpcost = 3
    end

    table.insert(prefs, Prefab( --手持物品
        data.name,
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddNetwork()

            MakeInventoryPhysics(inst)

            inst:AddTag("sharp")
            inst:AddTag("s_l_throw") --skill_legion_throw
            inst:AddTag("allow_action_on_impassable")
            inst:AddTag("moistureimmunity") --禁止潮湿：EntityScript:GetIsWet()

            --weapon (from weapon component) added to pristine state for optimization
            inst:AddTag("weapon")

            inst.AnimState:SetBank(data.name)
            inst.AnimState:SetBuild(data.name)
            inst.AnimState:PlayAnimation("idle", false)
            inst.Transform:SetEightFaced()

            inst:AddComponent("skinedlegion")
            inst.components.skinedlegion:InitWithFloater(data.name)

            inst.projectiledelay = 2 * FRAMES --不能大于7帧

            --Tip：官方的战斗辅助组件。加上后就能右键先瞄准再触发攻击。缺点是会导致其他对象的右键动作全部不起作用
            -- inst:AddComponent("aoetargeting")
            -- inst.components.aoetargeting:SetAlwaysValid(true)
            -- inst.components.aoetargeting.reticule.reticuleprefab = "reticulelongmulti"
            -- inst.components.aoetargeting.reticule.pingprefab = "reticulelongmultiping"
            -- inst.components.aoetargeting.reticule.targetfn = ReticuleTargetFn
            -- inst.components.aoetargeting.reticule.mousetargetfn = ReticuleMouseTargetFn
            -- inst.components.aoetargeting.reticule.updatepositionfn = ReticuleUpdatePositionFn
            -- inst.components.aoetargeting.reticule.validcolour = { 117/255, 1, 1, 1 }
            -- inst.components.aoetargeting.reticule.invalidcolour = { 0, 72/255, 72/255, 1 }
            -- inst.components.aoetargeting.reticule.ease = true
            -- inst.components.aoetargeting.reticule.mouseenabled = true

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst:AddComponent("inspectable")

            inst:AddComponent("stackable")
            inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem.imagename = data.name
            inst.components.inventoryitem.atlasname = "images/inventoryimages/"..data.name..".xml"
            inst.components.inventoryitem.TryToSink = function(self, ...)end --防止在虚空里消失
            inst.components.inventoryitem:EnableMoisture(false) --禁止潮湿：官方的代码有问题，会导致潮湿攻击滑落时叠加数变为1
            inst.components.inventoryitem:SetOnPickupFn(OnPickedUp_fea) --被捡起时，修改自己的旋转角度

            inst:AddComponent("savedrotation") --保存旋转角度的组件

            inst:AddComponent("equippable")
            inst.components.equippable:SetOnEquip(OnEquip)
            inst.components.equippable:SetOnUnequip(OnUnequip)
            inst.components.equippable.equipstack = true --装备时可以叠加装备

            inst:AddComponent("weapon")
            inst.components.weapon:SetRange(-1, -1) --人物默认攻击距离为3、3
            inst.components.weapon:SetDamage(fea_damage)

            inst:AddComponent("skillspelllegion")
            inst.components.skillspelllegion.fn_spell = function(inst, caster, pos, options)
                if caster.components.inventory == nil then
                    return false
                end

                local doerpos = caster:GetPosition()
                local angles = {}
                local poss = {}
                local direction = (pos - doerpos):GetNormalized() --单位向量
                local angle = math.acos(direction:Dot(Vector3(1, 0, 0))) / DEGREES --这个角度是动画的，不能用来做物理的角度
                local ang_lag = 2.5

                --查询是否有能拉回的材料
                local lines = caster.components.inventory:FindItems(function(i)
                    if i.line_l_value ~= nil or LineMap[i.prefab] then
                        return true
                    end
                end)
                if #lines <= 0 then
                    lines = false
                else
                    lines = true
                end

                local items = nil --需要丢出去的羽毛
                local num = inst.components.stackable:StackSize()
                if num <= 5 then
                    items = caster.components.inventory:RemoveItem(inst, true)
                else
                    items = inst.components.stackable:Get(5)
                    -- items.components.inventoryitem:OnRemoved() --由于此时还处于物品栏状态，需要恢复为非物品栏状态
                    num = 5
                end

                if num == 1 then
                    angles = { 0 }
                    poss[1] = pos
                else
                    if num == 2 then
                        angles = { -ang_lag, ang_lag }
                    elseif num == 3 then
                        angles = { -2*ang_lag, 0, 2*ang_lag }
                    elseif num == 4 then
                        angles = { -3*ang_lag, -ang_lag, ang_lag, 3*ang_lag }
                    else --最多5个
                        angles = { -4*ang_lag, -2*ang_lag, 0, 2*ang_lag, 4*ang_lag }
                    end

                    local ang = caster:GetAngleToPoint(pos.x, pos.y, pos.z) --原始角度，单位:度，比如33
                    for i,v in ipairs(angles) do
                        v = v + math.random()*2 - 1
                        angles[i] = v
                        local an = (ang+v)*DEGREES
                        poss[i] = Vector3(doerpos.x+math.cos(an), 0, doerpos.z-math.sin(an))
                    end
                end

                local feathers = {}
                for i,v in ipairs(angles) do
                    local fly = SpawnPrefab((inst.skinname or data.name).."_fly")
                    fly.hasline = lines
                    fly.shootidx = i
                    fly.caster = caster

                    fly.Transform:SetPosition(doerpos:Get())
                    feathers[i] = fly

                    fly.components.projectilelegion:Throw(fly, poss[i], caster, angle+v)
                    fly.components.projectilelegion:DelayVisibility(inst.projectiledelay)
                end

                if caster.components.health ~= nil and not caster.components.health:IsDead() then
                    local costt = fea_hpcost
                    if caster.feather_l_reducer ~= nil then
                        for _,v in pairs(caster.feather_l_reducer) do
                            if v then
                                costt = costt - v
                            end
                        end
                    end
                    caster.sivfeathers_l = nil
                    if costt > 0 then
                        caster.components.health:DoDelta(-costt*num, true, data.name, false, nil, true)
                    end
                    if not caster.components.health:IsDead() and lines then
                        local line = SpawnPrefab("siving_feather_line")
                        caster.sivfeathers_l = feathers
                        line.linedoer = caster
                        if not caster.components.inventory:Equip(line) then
                            line:Remove()
                            caster.sivfeathers_l = nil
                        end
                    end
                end

                items:Remove() --全部删了吧，到时候重新生成，懒得保存以及恢复了

                return true
            end

            MakeHauntableLaunch(inst)

            inst.components.skinedlegion:SetOnPreLoad()

            return inst
        end,
        {
            Asset("ANIM", "anim/"..data.name..".zip"),
            Asset("ATLAS", "images/inventoryimages/"..data.name..".xml"),
            Asset("IMAGE", "images/inventoryimages/"..data.name..".tex"),
        }, {
            -- "reticulelongmulti", --Tip：官方的战斗辅助组件
            -- "reticulelongmultiping",
            data.name.."_fly",
            data.name.."_blk",
            "siving_feather_line"
        }
    ))

    MakeWeapon_replace({
        name = data.name, isreal = data.isreal,
        fn_common_fly = function(inst)
            inst.AnimState:PlayAnimation("shoot", false)
            inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        end,
        fn_server_fly = function(inst)
            inst.feather_name = data.name
            inst.feather_skin = nil
            inst.components.weapon:SetDamage(fea_damage)
            inst.components.projectilelegion.shootrange = fea_range
        end,
        fn_common_blk = function(inst)
            inst.AnimState:PlayAnimation("idle", false)
            InitFloatable(inst, { cut = 0.04, size = "small", offset_y = 0.2, scale = 0.5 })
        end,
        fn_server_blk = function(inst)
            inst.feather_name = data.name
            inst.feather_skin = nil
        end
    })

    local skinname = data.name.."_paper"
    MakeWeapon_replace({
        name = skinname, isreal = data.isreal,
        fn_common_fly = function(inst)
            inst.Transform:SetFourFaced()
            inst.AnimState:PlayAnimation("shoot", true)
        end,
        fn_server_fly = function(inst)
            inst.feather_name = data.name
            inst.feather_skin = skinname
            inst.components.weapon:SetDamage(fea_damage)
            inst.components.projectilelegion.shootrange = fea_range
        end,
        fn_common_blk = function(inst)
            inst.AnimState:PlayAnimation("idle", false)
            InitFloatable(inst, SKINS_LEGION[skinname].floater)
        end,
        fn_server_blk = function(inst)
            inst.feather_name = data.name
            inst.feather_skin = skinname
        end
    })

    local skinname2 = data.name.."_collector"
    MakeWeapon_replace({
        name = skinname2, isreal = data.isreal,
        fn_common_fly = function(inst)
            inst.AnimState:SetBank("kitcoon")
            inst.Transform:SetSixFaced()
            inst.AnimState:SetScale(0.9, 0.9)
            SetAnim_fly_collector(inst)
        end,
        fn_server_fly = function(inst)
            inst.feather_name = data.name
            inst.feather_skin = skinname2
            inst.components.weapon:SetDamage(fea_damage)
            inst.components.projectilelegion.shootrange = fea_range
            inst.components.projectilelegion.onthrown = OnThrown_fly_collector
            inst.task_skinfx = inst:DoPeriodicTask(0.1, SpawnFx_collector, 0)
        end,
        fn_common_blk = function(inst)
            inst.AnimState:SetBank("kitcoon")
            inst.Transform:SetSixFaced()
            inst.AnimState:SetScale(0.9, 0.9)
            SetAnim_blk_collector(inst)
            InitFloatable(inst, SKINS_LEGION[skinname2].floater)
        end,
        fn_server_blk = function(inst)
            inst.feather_name = data.name
            inst.feather_skin = skinname2
        end
    })
end

------
------

local function MakeBossWeapon(data)
    local scale = 1.2
    table.insert(prefs, Prefab(
        data.name,
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddSoundEmitter()
            inst.entity:AddNetwork()

            MakeInventoryPhysics(inst)
            RemovePhysicsColliders(inst)

            inst.Transform:SetScale(scale, scale, scale)
            inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)

            inst:AddTag("sharp")

            --weapon (from weapon component) added to pristine state for optimization
            inst:AddTag("weapon")

            inst.projectiledelay = 3 * FRAMES

            if data.fn_common ~= nil then
                data.fn_common(inst)
            end

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst.persists = false

            inst:AddComponent("weapon")

            inst:AddComponent("projectilelegion")
            inst.components.projectilelegion.speed = 45
            inst.components.projectilelegion.shootrange = DIST_FLAP
            inst.components.projectilelegion.onthrown = function(inst, owner, targetpos, attacker)
                inst.AnimState:PlayAnimation("shoot3", false)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/swipe", nil, 0.2)
            end
            inst.components.projectilelegion.onmiss = function(inst, targetpos, attacker)
                local x, y, z = inst.Transform:GetWorldPosition()
                -- if TheWorld.Map:IsVisualGroundAtPoint(x, 0, z) then --仅限陆地
                if TheWorld.Map:IsAboveGroundAtPoint(x, 0, z) or TheWorld.Map:IsOceanTileAtPoint(x, 0, z) then
                    local block = SpawnPrefab(data.name.."_block")
                    if block ~= nil then
                        block.Transform:SetRotation(inst.Transform:GetRotation())
                        block.Transform:SetPosition(x, y, z)
                    end
                end
                inst:Remove()
            end
            inst.components.projectilelegion.exclude_tags = { "INLIMBO", "NOCLICK", "siving" }

            if data.fn_server ~= nil then
                data.fn_server(inst)
            end

            return inst
        end,
        data.assets,
        data.prefabs
    ))
    table.insert(prefs, Prefab(
        data.name.."_block",
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddSoundEmitter()
            inst.entity:AddNetwork()

            inst:SetPhysicsRadiusOverride(0.15)
            MakeWaterObstaclePhysics(inst, 0.15, 2, 0.75)

            inst:AddTag("siv_boss_block") --用来被清场
            inst:AddTag("ignorewalkableplatforms")

            inst.Transform:SetScale(scale, scale, scale)
            inst.Transform:SetEightFaced()

            inst:SetPrefabNameOverride(data.name)

            MakeInventoryFloatable(inst, "small", 0.2, 0.5)
            -- local OnLandedClient_old = inst.components.floater.OnLandedClient
            -- inst.components.floater.OnLandedClient = function(self)
            --     OnLandedClient_old(self)
            --     self.inst.AnimState:SetFloatParams(0.04, 1, self.bob_percent)
            -- end

            if data.fn_common2 ~= nil then
                data.fn_common2(inst)
            end

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            --加载水面特效
            inst:DoTaskInTime(POPULATING and math.random()*5*FRAMES or 0, function(inst)
                inst.components.floater:OnLandedServer()
            end)

            inst:AddComponent("inspectable")

            inst:AddComponent("lootdropper")

            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.MINE)
            inst.components.workable:SetWorkLeft(1)

            inst:AddComponent("savedrotation") --保存旋转角度的组件

            MakeHauntableWork(inst)

            inst:ListenForEvent("on_collide", function(inst, data) --被船撞时
                local boat_physics = data.other.components.boatphysics
                if boat_physics ~= nil then
                    inst.components.workable:WorkedBy(data.other, 1)
                end
            end)

            if data.fn_server2 ~= nil then
                data.fn_server2(inst)
            end

            return inst
        end,
        data.assets,
        data.prefabs2
    ))
end

--------------------------------------------------------------------------
--[[ 子圭玄鸟（雌） ]]
--------------------------------------------------------------------------

SetSharedLootTable('siving_foenix', {
    {'siving_rocks',        0.50},
    {'siving_rocks',        0.50},
    {'siving_rocks',        0.50},
    {'siving_derivant_item',    1.00},
    {'siving_derivant_item',    1.00},
    {'siving_mask_blueprint',   1.00},
    -- {'chesspiece_moosegoose_sketch', 1.00},
})

MakeBoss({
    name = "siving_foenix",
    -- assets = nil,
    -- prefabs = nil,
    -- fn_common = function(inst)end,
    fn_server = function(inst)
        inst.components.lootdropper:SetChanceLootTable('siving_foenix')
    end
})

--------------------------------------------------------------------------
--[[ 子圭玄鸟（雄） ]]
--------------------------------------------------------------------------

SetSharedLootTable('siving_moenix', {
    {'siving_rocks',        0.50},
    {'siving_rocks',        0.50},
    {'siving_rocks',        0.50},
    {'siving_feather_fake',     1.00},
    {'siving_feather_fake',     1.00},
    {'siving_feather_fake',     1.00},
    {'siving_feather_fake',     1.00},
    {'siving_feather_fake',     0.50},
    {'siving_feather_fake',     0.50},
    {'siving_feather_fake',     0.50},
    {'siving_feather_fake',     0.50},
    {'siving_feather_real_blueprint',   1.00},
    -- {'chesspiece_moosegoose_sketch', 1.00},
})

MakeBoss({
    name = "siving_moenix",
    -- assets = nil,
    -- prefabs = nil,
    -- fn_common = function(inst)end,
    fn_server = function(inst)
        inst.ismale = true
        inst.components.lootdropper:SetChanceLootTable('siving_moenix')
    end
})

--------------------------------------------------------------------------
--[[ 子圭石子 ]]
--------------------------------------------------------------------------

local TIME_EGG = 30 --孵化时间

local function SetEggState(inst, state)
    inst.state = state
    if state == 2 then
        inst.AnimState:OverrideSymbol("eggbase", "siving_egg", "egg2")
        inst.AnimState:PushAnimation("idle2", true)
    elseif state == 3 then
        inst.AnimState:OverrideSymbol("eggbase", "siving_egg", "egg3")
        inst.AnimState:PushAnimation("idle3", true)
    elseif state == 4 then
        inst.AnimState:OverrideSymbol("eggbase", "siving_egg", "egg4")
        inst.AnimState:PushAnimation("idle4", true)
    else
        inst.AnimState:ClearOverrideSymbol("eggbase")
        inst.AnimState:PushAnimation("idle1", true)
    end
end
local function OnTimerDone_egg(inst, data)
    if data.name == "state1" then
        SetEggState(inst, 2)
        inst.components.timer:StartTimer("state2", TIME_EGG*0.35)
        inst.SoundEmitter:PlaySound("dontstarve/creatures/egg/egg_hatch_crack")
    elseif data.name == "state2" then
        SetEggState(inst, 3)
        inst.components.timer:StartTimer("state3", TIME_EGG*0.35)
        inst.SoundEmitter:PlaySound("dontstarve/creatures/egg/egg_hatch_crack")
    elseif data.name == "state3" then
        SetEggState(inst, 4)
        inst.components.timer:StartTimer("birth", 2.5)
        inst.task_sound = inst:DoPeriodicTask(0.2, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/egg/egg_hatch_crack")
        end, 0)
    elseif data.name == "birth" then
        if inst.tree == nil or not inst.tree:IsValid() then --生成一个非BOSS战的玄鸟
            local bird = SpawnPrefab(inst.ismale and "siving_moenix" or "siving_foenix")
            if bird ~= nil then
                bird.Transform:SetPosition(inst.Transform:GetWorldPosition())
                bird.components.knownlocations:RememberLocation("spawnpoint", inst:GetPosition(), false)
            end
        else --BOSS战的玄鸟由神木在管理
            inst.ishatched = true
        end
        if inst.task_sound ~= nil then
            inst.task_sound:Cancel()
            inst.task_sound = nil
        end
        local fx = SpawnPrefab("siving_egg_hatched_fx")
        if fx ~= nil then
            fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        end
        inst:Remove()
    end
end

table.insert(prefs, Prefab(
    "siving_egg",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeObstaclePhysics(inst, 0.4)

        inst:AddTag("hostile")
        inst:AddTag("siving")

        inst.AnimState:SetBank("siving_egg")
        inst.AnimState:SetBuild("siving_egg")
        inst.AnimState:PlayAnimation("idle1", true)

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.ismale = false
        inst.ishatched = nil --是否正常孵化
        inst.tree = nil
        inst.state = 1

        inst.DIST_SPAWN = DIST_SPAWN

        inst:AddComponent("inspectable")

        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(300)
        inst.components.health:SetInvincible(true)

        inst:AddComponent("combat")

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot({ "siving_rocks", "siving_rocks", "siving_rocks",
            "siving_rocks", "siving_rocks", "siving_rocks" })

        inst:AddComponent("timer")
        inst.components.timer:StartTimer("state1", TIME_EGG*0.3)

        inst:ListenForEvent("timerdone", OnTimerDone_egg)
        inst:ListenForEvent("attacked", function(inst, data)
            if not inst.components.health:IsDead() then
                inst.AnimState:PlayAnimation("hit")
                SetEggState(inst, inst.state)
            end
        end)
        inst:ListenForEvent("death", function(inst, data)
            inst:RemoveEventCallback("timerdone", OnTimerDone_egg)
            inst.components.lootdropper:DropLoot()
            inst.AnimState:PlayAnimation("break", false)
        end)

        inst.OnLoad = function(inst, data)
            if inst.components.timer:TimerExists("state2") then
                inst.components.timer:StopTimer("state1")
                SetEggState(inst, 2)
            elseif inst.components.timer:TimerExists("state3") then
                inst.components.timer:StopTimer("state1")
                SetEggState(inst, 3)
            elseif inst.components.timer:TimerExists("birth") then
                inst.components.timer:StopTimer("state1")
                SetEggState(inst, 4)
            end
        end

        inst:DoTaskInTime(2, function(inst) --防止产生瞬间暴毙
            inst.components.health:SetInvincible(false)
        end)

        return inst
    end,
    {
        Asset("ANIM", "anim/siving_egg.zip")
    },
    {
        "siving_foenix",
        "siving_moenix",
        "siving_egg_hatched_fx"
    }
))

--------------------------------------------------------------------------
--[[ 子圭寄生花 ]]
--------------------------------------------------------------------------

local HEALTH_FLOWER = 480
local TIME_FLOWER = 11 --治疗玄鸟的延迟时间

local function SetFlowerState(inst, value, pushanim)
    local name = nil
    if value <= HEALTH_FLOWER*0.33 then
        if inst.state ~= 1 then
            inst.state = 1
            name = "idle1"
            pushanim = false --没有to_idle1这个动画
        end
    elseif value <= HEALTH_FLOWER*0.66 then
        if inst.state ~= 2 then
            inst.state = 2
            name = "idle2"
        end
    else
        if inst.state ~= 3 then
            inst.state = 3
            name = "idle3"
        end
    end
    if name ~= nil then
        if pushanim then
            inst.AnimState:PlayAnimation("to_"..name)
            inst.AnimState:PushAnimation(name, true)
        else
            inst.AnimState:PlayAnimation(name, true)
        end
    end
end
local function GiveLife(target, value)
    local health = target.components.health
    if health:IsHurt() then
        local need = health.maxhealth - health.currenthealth
        if need >= value then
            health:DoDelta(value)
            return 0
        else
            health:DoDelta(need)
            return value-need
        end
    end
    return value
end

table.insert(prefs, Prefab( --特效
    "siving_boss_flowerfx",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddFollower()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst:AddTag("NOCLICK")
        inst:AddTag("FX")

        inst.AnimState:SetBank("siving_boss_flower")
        inst.AnimState:SetBuild("siving_boss_flower")
        inst.AnimState:PlayAnimation("idle1", true)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetFinalOffset(3)

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false
        inst.tree = nil
        inst.bird = nil
        inst.target = nil
        inst.countHealth = 0
        inst.state = 1

        inst.fn_onUnbind = function(target) --落地
            inst:RemoveEventCallback("death", inst.fn_onUnbind, target)
            inst:RemoveEventCallback("onremove", inst.fn_onUnbind, target)
            target.hassivflower = nil

            if inst.task_bind ~= nil then
                inst.task_bind:Cancel()
                inst.task_bind = nil
            end
            if inst.countHealth > 0 then
                local flower = SpawnPrefab("siving_boss_flower")
                if flower ~= nil then
                    flower.tree = inst.tree
                    flower.bird = inst.bird
                    if inst.countHealth < HEALTH_FLOWER then
                        flower.components.health:SetCurrentHealth(inst.countHealth)
                    end
                    SetFlowerState(flower, inst.countHealth, false)
                    flower.Transform:SetRotation(target.Transform:GetRotation())

                    local x, y, z = target.Transform:GetWorldPosition()
                    flower.Transform:SetPosition(x, 0.5, z)
                end
            end
            inst:Remove()
        end
        inst.fn_onBind = function(inst, bird, target) --寄生
            inst.tree = bird.tree
            inst.bird = bird
            inst.target = target
            target.hassivflower = true
            inst.entity:SetParent(target.entity)

            --获取能跟随的symbol
            local symbol = target.components.debuffable and target.components.debuffable.followsymbol or nil
            if symbol == nil or symbol == "" then
                if target.components.combat ~= nil then
                    symbol = target.components.combat.hiteffectsymbol
                end
            end
            if symbol == nil or symbol == "" then
                if target.components.freezable ~= nil then
                    for _, v in pairs(target.components.freezable.fxdata) do
                        if v.follow ~= nil then
                            symbol = v.follow
                            break
                        end
                    end
                end
                if symbol == nil or symbol == "" then
                    if target.components.burnable ~= nil then
                        for _, v in pairs(target.components.burnable.fxdata) do
                            if v.follow ~= nil then
                                symbol = v.follow
                                break
                            end
                        end
                    end
                end
            end
            if symbol ~= nil then
                local ox, oy, oz = 0, 0, 0
                if target.components.debuffable ~= nil then
                    local debuffable = target.components.debuffable
                    ox = debuffable.followoffset.x
                    oy = debuffable.followoffset.y
                    oz = debuffable.followoffset.z
                end
                if oy == 0 then
                    oy = -140
                end
                inst.Follower:FollowSymbol(target.GUID, symbol, ox, oy, oz)
            end

            inst:ListenForEvent("death", inst.fn_onUnbind, target)
            inst:ListenForEvent("onremove", inst.fn_onUnbind, target)

            if inst._task_re ~= nil then
                inst._task_re:Cancel()
                inst._task_re = nil
            end

            inst.task_bind = inst:DoPeriodicTask(2, function(inst)
                if IsValid(inst.target) then
                    inst.target.components.health:DoDelta(-4, true, inst.prefab, false, inst, true)
                    inst.countHealth = inst.countHealth + 40

                    --宿主还没死，并且也没有达到吸血上限，就更新自己的动画
                    if not inst.target.components.health:IsDead() and inst.countHealth < HEALTH_FLOWER then
                        SetFlowerState(inst, inst.countHealth, true)
                        return
                    end
                end
                inst.fn_onUnbind(inst.target)
            end, 2)
        end

        inst._task_re = inst:DoTaskInTime(1, inst.Remove)

        return inst
    end,
    {
        Asset("ANIM", "anim/siving_boss_flower.zip")
    },
    {
        "siving_boss_flower"
    }
))

table.insert(prefs, Prefab( --实体
    "siving_boss_flower",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        inst.entity:AddLight()

        inst:AddTag("hostile")
        inst:AddTag("siving")
        inst:AddTag("soulless") --没有灵魂

        inst.Transform:SetTwoFaced()

        inst.AnimState:SetBank("siving_boss_flower")
        inst.AnimState:SetBuild("siving_boss_flower")
        inst.AnimState:PlayAnimation("idle3", true)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

        inst.Light:Enable(true)
        inst.Light:SetRadius(.6)
        inst.Light:SetFalloff(1)
        inst.Light:SetIntensity(.5)
        inst.Light:SetColour(15/255, 180/255, 132/255)

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false
        inst.tree = nil
        inst.bird = nil
        inst.state = 3

        inst:AddComponent("inspectable")

        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(HEALTH_FLOWER)

        inst:AddComponent("combat")

        inst:ListenForEvent("attacked", function(inst, data)
            if not inst.components.health:IsDead() then
                inst.AnimState:PlayAnimation("hit"..tostring(inst.state))
                inst.AnimState:PushAnimation("idle"..tostring(inst.state), true)
            end
        end)
        inst:ListenForEvent("death", function(inst, data)
            if inst._task_health ~= nil then
                inst._task_health:Cancel()
                inst._task_health = nil
            end
            inst.Light:Enable(false)
            inst.AnimState:ClearBloomEffectHandle()
            inst.AnimState:PlayAnimation("dead"..tostring(inst.state), false)
        end)

        inst._task_health = inst:DoTaskInTime(TIME_FLOWER, function(inst)
            if inst.tree ~= nil and inst.tree:IsValid() then
                local value = inst.components.health.currenthealth
                local valuelast = 0
                if inst.tree.bossBirds ~= nil then --优先直接给玄鸟加血(我嫌给神木再转给玄鸟的话太慢了)
                    local female = inst.tree.bossBirds.female
                    local male = inst.tree.bossBirds.male
                    if female ~= nil and not IsValid(female) then
                        female = nil
                    end
                    if male ~= nil and not IsValid(male) then
                        male = nil
                    end
                    if female ~= nil or male ~= nil then
                        if female ~= nil and male ~= nil then
                            value = value/2
                        end
                        if female ~= nil then
                            valuelast = valuelast + GiveLife(female, value)
                        end
                        if male ~= nil then
                            valuelast = valuelast + GiveLife(male, value)
                        end
                    else
                        valuelast = value
                    end
                else
                    valuelast = value
                end

                if valuelast > 0 then --然后才是给神木增加生命计数器
                    inst.tree.countHealth = inst.tree.countHealth + valuelast
                end
            elseif inst.bird ~= nil and IsValid(inst.bird) then
                GiveLife(inst.bird, inst.components.health.currenthealth)
            end

            local fx = SpawnPrefab("siving_boss_flower_fx")
            if fx ~= nil then
                local x, y, z = inst.Transform:GetWorldPosition()
                fx.Transform:SetPosition(x, 0, z)
            end

            inst._task_health = nil
            inst:Remove()
        end)

        return inst
    end,
    {
        Asset("ANIM", "anim/siving_boss_flower.zip")
    },
    { "siving_boss_flower_fx" }
))

--------------------------------------------------------------------------
--[[ 子圭之眼 ]]
--------------------------------------------------------------------------

local function UnbindBird(inst, landpos)
    inst.bird.iseye = false
    inst.bird.eyefx = nil
    if IsValid(inst.bird) then
        if landpos == nil then
            landpos = inst.bird.components.knownlocations:GetLocation("spawnpoint") or inst.tree:GetPosition()
        end
        inst.bird.Transform:SetPosition(landpos.x, 30, landpos.z)
        inst.bird:ReturnToScene()
        inst.bird.sg:GoToState("glide")
        inst.bird._count_atk = 0
    end
end
local function EyeATK1(inst)
    if inst.task_eye2 ~= nil then
        return
    end
    inst.task_eye2 = inst:DoPeriodicTask(1.5, function(inst)
        if inst:IsAsleep() or inst.target == nil or not IsValid(inst.target) then
            return
        end
        local xx, yy, zz = inst.target.Transform:GetWorldPosition()
        local numpot = inst.bird.isgrief and 7 or 5
        local the = math.random()*2*PI
        local the_dt = 2*PI/numpot
        local emptykey = math.random(numpot)
        local x2, y2, z2
        for i = 1, numpot, 1 do
            if emptykey ~= i then
                x2, y2, z2 = GetCalculatedPos_legion(xx, 0, zz, 3.5, the+the_dt*(i-1))
                SpawnRoot(inst.bird, x2, z2, 0.4)
            end
        end
    end, 0.5)
end
local function EyeAttack(inst, dt, countnow, countmax, x, z, counthalo)
    inst.task_eye = inst:DoTaskInTime(dt, function(inst)
        --确定攻击者
        local tar = nil
        if inst.bird.mate ~= nil and inst.bird.mate.components.combat.target ~= nil then
            tar = inst.bird.mate.components.combat.target
        else
            local ents = TheSim:FindEntities(x, 0, z, DIST_SPAWN, { "_combat", "_health" }, TAGS_CANT)
            for _, v in ipairs(ents) do
                if v.components.health ~= nil and not v.components.health:IsDead() then
                    if v:HasTag("player") then
                        tar = v
                        break
                    elseif tar == nil then
                        tar = v
                    end
                end
            end
        end

        --判定是否结束
        if countnow >= countmax then
            inst.task_eye = nil
            inst:fn_onUnbind(tar and tar:GetPosition() or nil)
            return
        end

        --预备施法
        inst.AnimState:PlayAnimation("spell", true)
        countnow = countnow + 1
        inst.target = tar

        --玩家逃避
        if tar == nil then
            counthalo = counthalo + 1
        end

        ------攻击方式1
        EyeATK1(inst)

        ------加护盾
        if countnow == 1 then --第一次循环，给伴侣加1层buff
            if inst.bird.mate ~= nil and IsValid(inst.bird.mate) then
                inst.task_eye = inst:DoTaskInTime(1, function(inst)
                    if inst.bird.mate ~= nil and IsValid(inst.bird.mate) then
                        SetTreeBuff(inst.bird.mate, 1)
                    end
                    if not inst.bird.isgrief then
                        inst.target = nil
                    end
                    inst.task_eye = nil
                    inst.AnimState:PlayAnimation("idle", true)
                    EyeAttack(inst, dt, countnow, countmax, x, z, counthalo)
                end)
                return
            end
        elseif countnow >= countmax and counthalo > 0 then ----最后一次循环，给伴侣和自己加buff
            inst.task_eye = inst:DoTaskInTime(1, function(inst)
                if IsValid(inst.bird) then
                    SetTreeBuff(inst.bird, counthalo)
                    counthalo = counthalo - 3
                end
                if counthalo > 0 and inst.bird.mate ~= nil and IsValid(inst.bird.mate) then
                    SetTreeBuff(inst.bird.mate, counthalo)
                end
                if not inst.bird.isgrief then
                    inst.target = nil
                end
                inst.task_eye = nil
                inst.AnimState:PlayAnimation("idle", true)
                EyeAttack(inst, dt, countnow, countmax, x, z, counthalo)
            end)
            return
        end

        ------攻击方式2
        local theta = nil
        local xx, yy, zz
        if tar ~= nil then
            xx, yy, zz = tar.Transform:GetWorldPosition()
            theta = math.atan2(z - zz, xx - x)
        else
            theta = math.random()*2*PI
        end
        --开始突袭！
        local num = 0
        local nummax = math.random(15, 19)
        local the = theta
        inst.task_eye = inst:DoPeriodicTask(0.12, function(inst)
            num = num + 1
            if not inst:IsAsleep() then
                if inst.bird.isgrief then
                    if num%2 == 1 then
                        the = theta + 2*DEGREES
                    else
                        the = theta - 2*DEGREES
                    end
                end
                xx, yy, zz = GetCalculatedPos_legion(x, 0, z, 3+num*1.2, the)
                SpawnRoot(inst.bird, xx, zz, 0.3)
            end
            if num >= nummax then
                if inst.task_eye ~= nil then
                    inst.task_eye:Cancel()
                    inst.task_eye = nil
                end
                if not inst.bird.isgrief then
                    inst.target = nil
                end
                inst.AnimState:PlayAnimation("idle", true)
                EyeAttack(inst, dt, countnow, countmax, x, z, counthalo)
            end
        end, 1)
    end)
end

table.insert(prefs, Prefab(
    "siving_boss_eye",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddFollower()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        -- inst:AddTag("NOCLICK")
        inst:AddTag("FX")

        inst.AnimState:SetBank("siving_boss_eye")
        inst.AnimState:SetBuild("siving_boss_eye")
        inst.AnimState:PlayAnimation("bind")
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetScale(1.3, 1.3)
        inst.AnimState:SetFinalOffset(3)
        inst.AnimState:SetSortOrder(3)

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false
        inst.tree = nil
        inst.bird = nil
        inst.target = nil

        inst.fn_onUnbind = function(inst, landpos) --解除
            if inst.task_eye ~= nil then
                inst.task_eye:Cancel()
                inst.task_eye = nil
            end
            if inst.task_eye2 ~= nil then
                inst.task_eye2:Cancel()
                inst.task_eye2 = nil
            end

            if inst.tree:IsValid() then
                inst.tree.components.timer:StopTimer("eye")
                inst.tree.components.timer:StartTimer("eye", inst.tree.TIME_EYE)
                if inst:IsAsleep() then
                    UnbindBird(inst, landpos)
                    inst.tree.myEye = nil
                    inst:Remove()
                else
                    inst.AnimState:PlayAnimation("unbind")
                    inst:ListenForEvent("animover", function(inst) --如果离玩家太远，动画会暂停
                        UnbindBird(inst, landpos)
                        inst.tree.myEye = nil
                        inst:Remove()
                    end)
                end
            else
                UnbindBird(inst, landpos)
                inst.tree.myEye = nil
                inst:Remove()
            end
        end
        inst.fn_onBind = function(inst, tree, bird) --化作
            if inst._task_re ~= nil then
                inst._task_re:Cancel()
                inst._task_re = nil
            end

            if bird.components.combat.target ~= nil then --把仇恨对象交给伴侣，不然仇恨就断了
                CheckMate(bird)
                if bird.mate ~= nil and bird.mate.components.combat.target == nil then
                    bird.mate.components.combat:SetTarget(bird.components.combat.target)
                end
                bird.components.combat:SetTarget(nil)
            end

            bird:RemoveFromScene()
            bird.iseye = true
            bird.eyefx = inst
            tree.myEye = bird
            inst.tree = tree
            inst.bird = bird

            local x, y, z = tree.Transform:GetWorldPosition()
            inst.Transform:SetPosition(x, y, z)
            bird.Transform:SetPosition(x, 0, z)

            inst.entity:SetParent(tree.entity)
            inst.Follower:FollowSymbol(tree.GUID, "trunk", 0, -760, 0)

            inst.AnimState:PlayAnimation("bind")
            inst.AnimState:PushAnimation("idle", true)

            if bird.isgrief then
                inst.AnimState:OverrideSymbol("eye", "siving_boss_eye", "griefeye")
                EyeAttack(inst, TIME_EYE_DT_GRIEF, 0, COUNT_EYE_GRIEF, x, z, 0)
            else
                EyeAttack(inst, TIME_EYE_DT, 0, COUNT_EYE, x, z, 0)
            end
        end

        inst._task_re = inst:DoTaskInTime(1, inst.Remove)

        return inst
    end,
    {
        Asset("ANIM", "anim/siving_boss_eye.zip")
    },
    {
        "siving_boss_root"
    }
))

--------------------------------------------------------------------------
--[[ 子圭突触 ]]
--------------------------------------------------------------------------

local function SetClosedPhysics(inst)
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.ITEMS)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
end
local function SetOpenedPhysics(inst)
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.ITEMS)
end

table.insert(prefs, Prefab(
    "siving_boss_root",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
        inst.entity:AddLight()

        inst:AddTag("siv_boss_block") --用来被清场
        inst:AddTag("siving_derivant")
        inst:AddTag("trapdamage") --让骨甲能生效

        inst.AnimState:SetBank("atrium_fence")
        if CONFIGS_LEGION.SIVINGROOTTEX == 1 then
            inst.AnimState:SetBuild("siving_boss_root")
        else
            inst.AnimState:SetBuild("atrium_fence")
            inst.AnimState:SetMultColour(80/255, 147/255, 150/255, 1)
        end
        inst.AnimState:PlayAnimation("shrunk")
        -- inst.AnimState:SetScale(1.3, 1.3)

        inst.Light:Enable(false)
        inst.Light:SetRadius(1.5)
        inst.Light:SetFalloff(1)
        inst.Light:SetIntensity(.6)
        inst.Light:SetColour(15/255, 180/255, 132/255)

        MakeObstaclePhysics(inst, 0.15)
        SetOpenedPhysics(inst)

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.fenceid = math.random(5)
        inst.treeState = 0

        if CONFIGS_LEGION.SIVINGROOTTEX == 1 then
            inst.OnTreeLive = function(inst, state)
                inst.treeState = state
                if state == 2 then
                    inst.AnimState:SetBuild("siving_boss_root2")
                    inst.components.bloomer:PushBloom("activetree", "shaders/anim.ksh", 1)
                    inst.Light:SetRadius(1.5)
                    inst.Light:Enable(true)
                elseif state == 1 then
                    inst.AnimState:SetBuild("siving_boss_root")
                    inst.components.bloomer:PushBloom("activetree", "shaders/anim.ksh", 1)
                    inst.Light:SetRadius(0.8)
                    inst.Light:Enable(true)
                else
                    inst.AnimState:SetBuild("siving_boss_root")
                    inst.components.bloomer:PopBloom("activetree")
                    inst.Light:Enable(false)
                end
            end
        else
            inst.OnTreeLive = function(inst, state)
                inst.treeState = state
                if state == 2 then
                    inst.components.bloomer:PushBloom("activetree", "shaders/anim.ksh", 1)
                    inst.Light:SetRadius(1.5)
                    inst.Light:Enable(true)
                elseif state == 1 then
                    inst.components.bloomer:PushBloom("activetree", "shaders/anim.ksh", 1)
                    inst.Light:SetRadius(0.8)
                    inst.Light:Enable(true)
                else
                    inst.components.bloomer:PopBloom("activetree")
                    inst.Light:Enable(false)
                end
            end
        end

        inst.fn_onAttack = function(inst, bird, delaytime)
            inst.AnimState:PlayAnimation("grow"..tostring(inst.fenceid))
            inst.AnimState:PushAnimation("idle"..tostring(inst.fenceid), false)
            inst.SoundEmitter:PlaySound("dontstarve/common/together/atrium/gate_spike")
            inst.components.workable:SetWorkable(false)
            inst._task_atk = inst:DoTaskInTime(delaytime, function(inst)
                inst._task_atk = nil

                --攻击！破坏！
                local x, y, z = inst.Transform:GetWorldPosition()
                local ents = TheSim:FindEntities(x, 0, z, DIST_ROOT_ATK,
                    nil, { "INLIMBO", "NOCLICK", "siving", "shadow", "ghost" },
                    { "_combat", "CHOP_workable", "DIG_workable", "HAMMER_workable", "MINE_workable" }
                )
                for _, v in ipairs(ents) do
                    if v.components.combat ~= nil then
                        if v.components.health ~= nil and not v.components.health:IsDead() then
                            if v.components.locomotor == nil then --可以秒杀触手等没有移动组件但有战斗组件的实体
                                v.components.health:Kill()
                            elseif v.components.combat:CanBeAttacked() then
                                v.components.combat:GetAttacked(inst, GetDamage(bird or inst, v, ATK_ROOT))
                            end
                        end
                    elseif v.components.workable ~= nil then
                        if v.components.workable:CanBeWorked() then
                            v.components.workable:WorkedBy(inst, 3)
                        end
                    end
                end

                SetClosedPhysics(inst)
            end)
            inst._task_work = inst:DoTaskInTime(delaytime+3, function(inst)
                inst._task_work = nil
                inst.components.workable:SetWorkable(true)
            end)
        end
        inst.fn_onClear = function(inst)
            if inst._task_atk ~= nil then
                inst._task_atk:Cancel()
                inst._task_atk = nil
            end
            if inst._task_work ~= nil then
                inst._task_work:Cancel()
                inst._task_work = nil
            end

            inst.persists = false
            if inst:IsAsleep() then
                inst:Remove()
                return
            end

            inst:AddTag("NOCLICK")
            inst.components.bloomer:PopBloom("activetree")
            inst.Light:Enable(false)
            inst.AnimState:PlayAnimation("shrink"..tostring(inst.fenceid))
            inst:DoTaskInTime(0.6, inst.Remove) --我嫌动画末尾太拖了，提前结束！
            inst.SoundEmitter:PlaySound("dontstarve/common/together/atrium/retract")
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("bloomer")

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.MINE)
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnFinishCallback(function(inst, worker)
            SetOpenedPhysics(inst)
            inst.components.lootdropper:DropLoot()
            inst:fn_onClear()
        end)

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:AddChanceLoot("siving_rocks", 0.001)

        MakeHauntableWork(inst)

        inst.OnSave = function(inst, data)
            data.fenceid = inst.fenceid
        end
        inst.OnLoad = function(inst, data)
            if data ~= nil and data.fenceid ~= nil then
                inst.fenceid = data.fenceid
            end
            inst.AnimState:PushAnimation("idle"..tostring(inst.fenceid), false)
            SetClosedPhysics(inst)
        end

        return inst
    end,
    {
        Asset("ANIM", "anim/siving_boss_root.zip"),
        Asset("ANIM", "anim/siving_boss_root2.zip"),
        Asset("ANIM", "anim/atrium_fence.zip")
    },
    nil
))

--------------------------------------------------------------------------
--[[ 子圭·翰 ]]
--------------------------------------------------------------------------

--玩家武器
MakeWeapon({
    name = "siving_feather_real",
    isreal = true
})

--BOSS产物：精致子圭翎羽
local function AddWeaponLight(inst)
    inst.entity:AddLight()
    inst.Light:Enable(true)
    inst.Light:SetRadius(.6)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(15/255, 180/255, 132/255)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
end
local function ExplodeFeather(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, DIST_FEA_EXPLODE, nil, { "INLIMBO", "NOCLICK", "FX", "siving" })
    for _, v in ipairs(ents) do
        if v ~= inst and v:IsValid() then
            if v.components.workable ~= nil then
                if v.components.workable:CanBeWorked() then
                    if v:HasTag("siv_boss_block") then
                        v.explode_chain_l = true --连锁爆炸
                    end
                    v.components.workable:WorkedBy(inst, 3)
                end
            elseif
                v.components.combat ~= nil and
                not (v.components.health ~= nil and v.components.health:IsDead())
            then
                v.components.combat:GetAttacked(inst, GetDamage2(v, ATK_FEA_EXPLODE), nil)
            end
            v:PushEvent("explosion", { explosive = inst })
        end
    end

    --爆炸特效(声音也在里面)
    SpawnPrefab("explode_small_slurtle").Transform:SetPosition(x, y, z)

    inst.components.lootdropper:DropLoot()
    inst:Remove()
end

MakeBossWeapon({
    name = "siving_bossfea_real",
    assets = {
        Asset("ANIM", "anim/siving_feather_real.zip")
    },
    prefabs = { "siving_bossfea_real_block" },
    fn_common = function(inst)
        AddWeaponLight(inst)
        inst.AnimState:SetBank("siving_feather_real")
        inst.AnimState:SetBuild("siving_feather_real")
    end,
    fn_server = function(inst)
        inst.components.weapon:SetDamage(ATK_FEA_REAL)
    end,
    prefabs2 = { "explode_small_slurtle" },
    fn_common2 = function(inst)
        AddWeaponLight(inst)
        inst.AnimState:SetBank("siving_feather_real")
        inst.AnimState:SetBuild("siving_feather_real")
        inst.AnimState:PlayAnimation("idle", false)
    end,
    fn_server2 = function(inst)
        inst.components.lootdropper:AddChanceLoot("siving_rocks", 0.1)
        inst.components.workable:SetOnFinishCallback(function(inst, worker)
            if inst.task_explode ~= nil then
                inst.task_explode:Cancel()
                inst.task_explode = nil
            end
            ExplodeFeather(inst)
        end)

        inst.task_explode = inst:DoTaskInTime(TIME_FEA_EXPLODE, function(inst)
            inst.task_explode = nil
            ExplodeFeather(inst)
        end)

        inst.fn_onClear = function(inst)
            if inst.task_explode ~= nil then
                inst.task_explode:Cancel()
                inst.task_explode = nil
            end

            inst.persists = false
            if inst:IsAsleep() then
                inst:Remove()
                return
            end

            inst:AddTag("NOCLICK")
            inst.Light:Enable(false)
            inst.AnimState:ClearBloomEffectHandle()
            ErodeAway(inst)
        end
    end,
})

--------------------------------------------------------------------------
--[[ 子圭玄鸟绒羽 ]]
--------------------------------------------------------------------------

--玩家武器
MakeWeapon({
    name = "siving_feather_fake",
    isreal = nil
})

--BOSS产物：子圭翎羽
MakeBossWeapon({
    name = "siving_bossfea_fake",
    assets = {
        Asset("ANIM", "anim/siving_feather_fake.zip")
    },
    prefabs = { "siving_bossfea_fake_block" },
    fn_common = function(inst)
        inst.AnimState:SetBank("siving_feather_fake")
        inst.AnimState:SetBuild("siving_feather_fake")
    end,
    fn_server = function(inst)
        inst.components.weapon:SetDamage(ATK_FEA)
    end,
    prefabs2 = { "explode_small_slurtle" },
    fn_common2 = function(inst)
        inst.AnimState:SetBank("siving_feather_fake")
        inst.AnimState:SetBuild("siving_feather_fake")
        inst.AnimState:PlayAnimation("idle", false)
    end,
    fn_server2 = function(inst)
        inst.components.lootdropper:AddChanceLoot("siving_rocks", 0.02)
        inst.components.workable:SetOnFinishCallback(function(inst, worker)
            if inst.explode_chain_l then --被连锁爆炸
                ExplodeFeather(inst)
                return
            end
            inst.components.lootdropper:DropLoot()
            --特效 undo
            inst:Remove()
        end)

        inst.fn_onClear = function(inst)
            inst.persists = false
            if inst:IsAsleep() then
                inst:Remove()
                return
            end

            inst:AddTag("NOCLICK")
            ErodeAway(inst)
        end
    end,
})

--------------------------------------------------------------------------
--[[ 临时的羽刃拉扯器 ]]
--------------------------------------------------------------------------

local function RemoveFromOnwer(inst)
    if inst.components.inventoryitem ~= nil then
        local owner = inst.components.inventoryitem:GetGrandOwner()
        if owner then
            local cpt = owner.components.inventory or owner.components.container
            if cpt then
                local reomveditem = cpt:RemoveItem(inst, true, true)
                if reomveditem then
                    reomveditem:Remove()
                    return
                end
            end
        end
    end
    inst:Remove()
end
local function RemoveLine(inst)
    if inst.linedoer ~= nil then
        if inst.linedoer.sivfeathers_l ~= nil then --非法移除时，将飞行体或者滞留体都恢复为正常羽毛
            for _,v in ipairs(inst.linedoer.sivfeathers_l) do
                if v and v:IsValid() then
                    if v.OnEntitySleep then
                        v:OnEntitySleep()
                    end
                end
            end
            inst.linedoer.sivfeathers_l = nil
        end
    end
    inst:DoTaskInTime(0, function()
        RemoveFromOnwer(inst)
    end)
end

table.insert(prefs, Prefab(
    "siving_feather_line",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform() --Tip：AddAnimState 组件 必需在该组件之后，否则会崩溃

        --这个prefab我本来不准备加动画机制的，但是【Super Wall】mod 里会因此崩溃：它的机制默认装备物品是有这个组件的
        inst.entity:AddAnimState()

        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst:AddTag("s_l_pull") --skill_legion_pull
        inst:AddTag("siv_line")
        inst:AddTag("allow_action_on_impassable")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false
        inst.linedoer = nil --指发起这个动作的玩家

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = "siving_feather_line"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/siving_feather_line.xml"
        inst.components.inventoryitem:SetOnDroppedFn(RemoveLine)

        inst:AddComponent("equippable")
        inst.components.equippable:SetOnEquip(function(inst, owner)
            owner:AddTag("s_l_pull") --skill_legion_pull
            owner:AddTag("siv_line")
        end)
        inst.components.equippable:SetOnUnequip(function(inst, owner)
            owner:RemoveTag("s_l_pull")
            owner:RemoveTag("siv_line")
            RemoveLine(inst)
        end)

        inst:AddComponent("skillspelllegion")
        inst.components.skillspelllegion.fn_spell = function(inst, doer, pos, options)
            if doer.sivfeathers_l ~= nil then
                ----查询能拉回的材料
                local lines = doer.components.inventory:FindItems(function(i)
                    if i.line_l_value ~= nil or LineMap[i.prefab] then
                        return true
                    end
                end)
                if #lines <= 0 then --没有能拉回的材料，直接结束
                    doer.sivfeathers_l = nil
                    return
                end

                ----消耗材料
                local cost = nil
                if doer.feather_l_value == nil then --提前加1，用来消耗
                    cost = 1
                else
                    cost = doer.feather_l_value + 1
                end
                for _,v in ipairs(lines) do
                    local value = v.line_l_value or LineMap[v.prefab]
                    if cost < value then --还未到消耗之时
                        break
                    end

                    if v.components.stackable == nil then
                        local costitem = doer.components.inventory:RemoveItem(v, nil, true)
                        if costitem then
                            costitem:Remove()
                        end
                        cost = cost - value
                    else
                        local num = v.components.stackable:StackSize()
                        for i = 1, num, 1 do
                            local costitem = doer.components.inventory:RemoveItem(v, nil, true)
                            if costitem then
                                costitem:Remove()
                            end
                            cost = cost - value
                            if cost < value then
                                break
                            end
                        end
                    end
                    if cost < value then
                        break
                    end
                end
                if cost <= 0 then
                    doer.feather_l_value = nil
                else
                    doer.feather_l_value = cost
                end

                ----检查是否有能拉回的羽毛
                local throwed = false
                local doerpos = doer:GetPosition()
                for _,v in ipairs(doer.sivfeathers_l) do
                    if v and v:IsValid() then
                        -- if fea_name == nil then
                        --     fea_name = string.sub(v.prefab, 1, -5)
                        -- end
                        throwed = true
                        break
                    end
                end

                inst.linedoer = nil --拉回触发时，得提前把这个数据清除
                RemoveLine(inst)
                if throwed then
                    for _,v in ipairs(doer.sivfeathers_l) do
                        if v and v:IsValid() then
                            local fly
                            if v.isblk then --是滞留体，需要重新生成飞行体
                                fly = SpawnPrefab((v.feather_skin or v.feather_name).."_fly")
                                fly.shootidx = v.shootidx
                                fly.caster = doer
                                if doer.sivfeathers_l then --projectilelegion:Throw() 可能会清理 sivfeathers_l
                                    doer.sivfeathers_l[v.shootidx] = fly
                                end
                                fly.Transform:SetPosition(v.Transform:GetWorldPosition())
                                v:Remove()
                            else
                                fly = v
                            end
                            fly.components.projectilelegion.isgoback = true
                            fly.components.projectilelegion:Throw(v, doerpos, doer)
                        end
                    end
                else
                    doer.sivfeathers_l = nil
                end
            end
        end

        inst.task_remove = inst:DoTaskInTime(3.5, RemoveLine)

        return inst
    end,
    {
        Asset("ATLAS", "images/inventoryimages/siving_feather_line.xml"),
        Asset("IMAGE", "images/inventoryimages/siving_feather_line.tex"),
    },
    nil
))

--------------------
--------------------

return unpack(prefs)
