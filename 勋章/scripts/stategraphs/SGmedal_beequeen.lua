require("stategraphs/commonstates")

--------------------------------------------------------------------------
local FOCUSTARGET_MUST_TAGS = { "_combat", "_health" }
local FOCUSTARGET_CANT_TAGS = { "INLIMBO", "player", "bee" }

local function ShakeIfClose(inst)
    ShakeAllCameras(CAMERASHAKE.FULL, .5, .02, .15, inst, 30)
end

local function StartFlapping(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/wings_LP", "flying")
end

local function RestoreFlapping(inst)
    if not inst.SoundEmitter:PlayingSound("flying") then
        StartFlapping(inst)
    end
end

local function StopFlapping(inst)
    inst.SoundEmitter:KillSound("flying")
end
--尖叫(这个函数主要负责表现效果)
local function DoScreech(inst)
    ShakeAllCameras(CAMERASHAKE.FULL, 1, .015, .3, inst, 30)--摄像机振动
    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/taunt")--发出尖叫声音
end
--发出尖叫警告
local function DoScreechAlert(inst)
    inst.components.epicscare:Scare(5)--使有攻击或者移动组件的生物陷入恐慌(会丢失目标)
    inst.components.commander:AlertAllSoldiers()--唤醒所有手下(解除冰冻、睡觉状态)
	--引起玩家恐慌掉san
	if inst.ScareFn then
		inst:ScareFn()
	end
end

--------------------------------------------------------------------------

local function ChooseAttack(inst)
    inst.sg:GoToState("attack")
    return true
end
--面向目标
local function FaceTarget(inst)
    local target = inst.components.combat.target
    if inst.sg.mem.focustargets ~= nil then
        local mindistsq = math.huge
        for i = #inst.sg.mem.focustargets, 1, -1 do
            local v = inst.sg.mem.focustargets[i]
            if v:IsValid() and v.components.health ~= nil and not v.components.health:IsDead() and not v:HasTag("playerghost") then
                local distsq = inst:GetDistanceSqToInst(v)
                if distsq < mindistsq then
                    mindistsq = distsq
                    target = v
                end
            else
                table.remove(inst.sg.mem.focustargets, i)
                if #inst.sg.mem.focustargets <= 0 then
                    inst.sg.mem.focustargets = nil
                    break
                end
            end
        end
    end
    if target ~= nil and target:IsValid() then
        inst:ForceFacePoint(target.Transform:GetWorldPosition())
    end
end

--------------------------------------------------------------------------

local events =
{
    CommonHandlers.OnLocomote(false, true),
    CommonHandlers.OnDeath(),
    CommonHandlers.OnFreeze(),
    CommonHandlers.OnSleepEx(),
    CommonHandlers.OnWakeEx(),
    EventHandler("doattack", function(inst)
        if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
            ChooseAttack(inst)
        end
    end),
    EventHandler("attacked", function(inst)
        if not inst.components.health:IsDead() and
            (not inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("caninterrupt")) and
            (inst.sg.mem.last_hit_time or 0) + inst.hit_recovery < GetTime() then
            inst.sg:GoToState("hit")
        end
    end),
    EventHandler("screech", function(inst)
        if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
            inst.sg:GoToState("screech")
        elseif not inst.sg:HasStateTag("screech") then
            inst.sg.mem.wantstoscreech = true
        end
    end),
    EventHandler("spawnguards", function(inst)
        if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
            inst.sg:GoToState("spawnguards")
        elseif not inst.sg:HasStateTag("spawnguards") then
            inst.sg.mem.wantstospawnguards = true
        end
    end),
    EventHandler("focustarget", function(inst)
        if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
            inst.sg:GoToState("focustarget")
        elseif not inst.sg:HasStateTag("focustarget") then
            inst.sg.mem.wantstofocustarget = true
        end
    end),
    EventHandler("flee", function(inst)
        if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
            inst.sg:GoToState("flyaway")
        else
            inst.sg.mem.wantstoflyaway = true
        end
    end),
}

local states =
{
    State{
        name = "idle",
        tags = { "idle", "canrotate" },

        onenter = function(inst)
            if inst.sg.mem.wantstoscreech then
                inst.sg:GoToState("screech")
            elseif inst.sg.mem.wantstoflyaway then
                inst.sg:GoToState("flyaway")
            elseif inst.sg.mem.sleeping then
                inst.sg:GoToState("sleep")
            elseif inst.sg.mem.focuscount ~= nil then
                inst.sg:GoToState("focustarget_loop")
            elseif inst.sg.mem.wantstospawnguards then
                inst.sg:GoToState("spawnguards")
            elseif inst.sg.mem.wantstofocustarget then
                inst.sg:GoToState("focustarget")
            else
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("idle_loop")
            end
        end,

        timeline =
        {
            TimeEvent(0, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/breath")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{
        name = "walk_start",
        tags = { "moving", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("walk_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("walk")
                end
            end),
        },
    },

    State{
        name = "walk",
        tags = { "moving", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("walk_loop")
        end,

        timeline =
        {
            TimeEvent(0, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/breath")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("walk")
                end
            end),
        },
    },

    State{
        name = "walk_stop",
        tags = { "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("walk_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{--浮现出来
        name = "emerge",
        tags = { "busy", "nosleep", "nofreeze", "noattack" },

        onenter = function(inst)
            StopFlapping(inst)
            inst.Transform:SetNoFaced()
            inst.components.locomotor:StopMoving()
            inst.components.health:SetInvincible(true)
            inst.AnimState:PlayAnimation("enter")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/enter")
            inst.sg.mem.wantstoscreech = true
        end,

        timeline =
        {
            TimeEvent(4 * FRAMES, ShakeIfClose),
            TimeEvent(31 * FRAMES, DoScreech),
            TimeEvent(32 * FRAMES, DoScreechAlert),
            TimeEvent(35 * FRAMES, StartFlapping),
            CommonHandlers.OnNoSleepTimeEvent(54 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
                inst.sg:RemoveStateTag("nosleep")
                inst.sg:RemoveStateTag("nofreeze")
                inst.sg:RemoveStateTag("noattack")
            end),
        },

        events =
        {
            CommonHandlers.OnNoSleepAnimOver("screech"),
        },

        onexit = function(inst)
            RestoreFlapping(inst)
            inst.Transform:SetSixFaced()
            inst.components.health:SetInvincible(false)
        end,
    },

    State{
        name = "flyaway",
        tags = { "busy", "nosleep", "nofreeze", "flight" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.components.health:SetInvincible(true)
            inst.AnimState:PlayAnimation("walk_pre")
            inst.AnimState:PushAnimation("walk_loop")
            inst.DynamicShadow:Enable(false)
            inst:StopHoney()
            inst.sg.statemem.vel = Vector3(math.random() * 4, 7 + math.random() * 2, 0)
        end,

        onupdate = function(inst)
            inst.Physics:SetMotorVel(inst.sg.statemem.vel:Get())
        end,

        timeline =
        {
            TimeEvent(.3, function(inst)
                if inst.sg.mem.focuscount ~= nil then
                    inst.sg.mem.focuscount = nil
                    inst.sg.mem.focustargets = nil
                    inst.components.sanityaura.aura = 0
                    for i, v in ipairs(inst.components.commander:GetAllSoldiers()) do
                        v:FocusTarget(nil)
                    end
                    inst:BoostCommanderRange(false)
                end
                inst.components.commander:PushEventToAllSoldiers("flee")
            end),
            TimeEvent(3.5, function(inst)
                inst:Remove()
            end),
        },

        onexit = function(inst)
            --Should NOT happen!
            if inst.sg.mem.focuscount ~= nil then
                inst.components.sanityaura.aura = -TUNING.SANITYAURA_HUGE
            end
            inst.components.health:SetInvincible(false)
            inst.DynamicShadow:Enable(true)
            inst:StartHoney()
        end,
    },

    State{
        name = "hit",
        tags = { "hit", "busy" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("hit")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/hit")
            inst.sg.mem.last_hit_time = GetTime()
        end,

        timeline =
        {
            TimeEvent(10 * FRAMES, function(inst)
                if inst.sg.statemem.doattack then
                    if not inst.components.health:IsDead() and ChooseAttack(inst) then
                        return
                    end
                    inst.sg.statemem.doattack = nil
                end
                inst.sg:RemoveStateTag("busy")
            end),
        },

        events =
        {
            EventHandler("doattack", function(inst)
                inst.sg.statemem.doattack = true
            end),
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    if inst.sg.statemem.doattack and ChooseAttack(inst) then
                        return
                    end
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },
	--嘲讽
	State{
		name = "taunt",
        tags = {"busy"},

        onenter = function(inst, cb)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/taunt")
        end,

        events=
        {
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{--死亡
        name = "death",
        tags = { "busy" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("death")
            inst:AddTag("NOCLICK")
            inst.SoundEmitter:KillSound("flying")
            inst:StopHoney()
        end,

        timeline =
        {
            TimeEvent(14 * FRAMES, DoScreech),
            TimeEvent(15 * FRAMES, DoScreechAlert),
            TimeEvent(28 * FRAMES, function(inst)
                LandFlyingCreature(inst)
                inst.components.sanityaura.aura = 0
                inst.SoundEmitter:PlaySound("dontstarve/bee/beehive_hit")
                ShakeIfClose(inst)
                if inst.persists then
                    inst.persists = false
                    if inst._sleeptask==nil then--休眠状态死亡可不掉东西
                        inst.components.lootdropper:DropLoot(inst:GetPosition())
                        --生成雕像皮肤券
                        local skin_coupon = SpawnPrefab("medal_skin_coupon")
                        if skin_coupon then
                            if skin_coupon.setSkinData then
                                skin_coupon:setSkinData("medal_statue_marble_changeable",5)
                            end
                            inst.components.lootdropper:FlingItem(skin_coupon)
                        end
                    end
                    --统计死亡次数
                    if TheWorld and TheWorld.components.medal_infosave then
                        TheWorld.components.medal_infosave:CountChaosCreatureDeathTimes(inst)
                    end
                    if inst.hivebase ~= nil then
						inst.hivebase:Remove()--如果有对应的血坑，进行移除
                    end
                end
            end),
            TimeEvent(3, function(inst)
                if inst.sg.mem.focuscount ~= nil then
                    inst.sg.mem.focuscount = nil
                    inst.sg.mem.focustargets = nil
                    for i, v in ipairs(inst.components.commander:GetAllSoldiers()) do
                        v:FocusTarget(nil)
                    end
                    inst:BoostCommanderRange(false)
                end
            end),
            TimeEvent(5, function(inst)
                ErodeAway(inst)
                RaiseFlyingCreature(inst)
            end),
        },

        onexit = function(inst)
            --Should NOT happen!
            if inst.sg.mem.focuscount ~= nil then
                inst.components.sanityaura.aura = -TUNING.SANITYAURA_HUGE
            end
            inst:RemoveTag("NOCLICK")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/wings_LP", "flying")
            inst:StartHoney()
        end,
    },
	--尖叫
    State{
        name = "screech",
        tags = { "screech", "busy", "nosleep", "nofreeze" },

        onenter = function(inst)
            FaceTarget(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("screech")
            inst.sg.mem.wantstoscreech = nil
        end,

        timeline =
        {
            TimeEvent(8 * FRAMES, DoScreech),
            TimeEvent(9 * FRAMES, DoScreechAlert),
            TimeEvent(33 * FRAMES, DoScreech),
            TimeEvent(34 * FRAMES, DoScreechAlert),
            CommonHandlers.OnNoSleepTimeEvent(57 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
                inst.sg:RemoveStateTag("nosleep")
                inst.sg:RemoveStateTag("nofreeze")
            end),
        },

        events =
        {
            CommonHandlers.OnNoSleepAnimOver("idle"),
        },
    },

    State{
        name = "attack",
        tags = { "attack", "busy", "nosleep", "nofreeze" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("atk")
            inst.components.combat:StartAttack()
            inst.sg.statemem.target = inst.components.combat.target
        end,

        timeline =
        {
            TimeEvent(0, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/attack_pre")
            end),
            TimeEvent(14 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/attack")
                inst.components.combat:DoAttack(inst.sg.statemem.target)
            end),
            CommonHandlers.OnNoSleepTimeEvent(23 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
                inst.sg:RemoveStateTag("nosleep")
                inst.sg:RemoveStateTag("nofreeze")
            end),
        },

        events =
        {
            CommonHandlers.OnNoSleepAnimOver("idle"),
        },
    },

    State{--生成守卫
        name = "spawnguards",
        tags = { "spawnguards", "busy", "nosleep", "nofreeze" },

        onenter = function(inst)
            FaceTarget(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("spawn")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/spawn")
        end,

        timeline =
        {
            TimeEvent(16 * FRAMES, function(inst)
                inst.sg.mem.wantstospawnguards = nil
                if inst.spawnguards_chain < inst.spawnguards_maxchain then
                    inst.spawnguards_chain = inst.spawnguards_chain + 1
                else
                    inst.spawnguards_chain = 0
                    inst.components.timer:StartTimer("spawnguards_cd", inst.spawnguards_cd)
                end

                local oldnum = inst.components.commander:GetNumSoldiers()
                local x, y, z = inst.Transform:GetWorldPosition()
                local rot = inst.Transform:GetRotation()
                -- local num = math.random(TUNING_MEDAL.MEDAL_BEEQUEEN_MIN_GUARDS_PER_SPAWN, TUNING_MEDAL.MEDAL_BEEQUEEN_MAX_GUARDS_PER_SPAWN)
                -- if num + oldnum > TUNING_MEDAL.MEDAL_BEEQUEEN_TOTAL_GUARDS then
                --     num = math.max(TUNING_MEDAL.MEDAL_BEEQUEEN_MIN_GUARDS_PER_SPAWN, TUNING_MEDAL.MEDAL_BEEQUEEN_TOTAL_GUARDS - oldnum)
                -- end
                local spawnguards_threshold = inst.spawnguards_threshold or TUNING_MEDAL.MEDAL_BEEQUEEN_TOTAL_GUARDS--阈值
                --单次生成数量 = math.clamp(阈值/2,4,10)
                local num = math.clamp(math.ceil(spawnguards_threshold/2),TUNING_MEDAL.MEDAL_BEEQUEEN_MIN_GUARDS_PER_SPAWN,TUNING_MEDAL.MEDAL_BEEQUEEN_MAX_GUARDS_PER_SPAWN)
                --总量大于阈值，则数量=math.max(4,阈值-原数量)
                if num + oldnum > spawnguards_threshold then
                    num = math.max(TUNING_MEDAL.MEDAL_BEEQUEEN_MIN_GUARDS_PER_SPAWN, spawnguards_threshold - oldnum)
                end
                -- print("这波生了"..num)
                local drot = 360 / num
                for i = 1, num do
                    local minion = SpawnPrefab("medal_beeguard")
                    local angle = rot + i * drot
                    local radius = minion:GetPhysicsRadius(0)
                    minion.Transform:SetRotation(angle)
                    angle = -angle * DEGREES
                    minion.Transform:SetPosition(x + radius * math.cos(angle), 0, z + radius * math.sin(angle))
                    minion:OnSpawnedGuard(inst)
                end

                if oldnum > 0 then
                    local soldiers = inst.components.commander:GetAllSoldiers()
                    num = #soldiers
                    drot = 360 / num
                    for i = 1, num do
                        local angle = -(rot + i * drot) * DEGREES
                        local xoffs = TUNING.BEEGUARD_GUARD_RANGE * math.cos(angle)
                        local zoffs = TUNING.BEEGUARD_GUARD_RANGE * math.sin(angle)
                        local mindistsq = math.huge
                        local closest = 1
                        for i2, v in ipairs(soldiers) do
                            local offset = v.components.knownlocations:GetLocation("queenoffset")
                            if offset ~= nil then
                                local distsq = distsq(xoffs, zoffs, offset.x, offset.z)
                                if distsq < mindistsq then
                                    mindistsq = distsq
                                    closest = i2
                                end
                            end
                        end
                        table.remove(soldiers, closest).components.knownlocations:RememberLocation("queenoffset", Vector3(xoffs, 0, zoffs), false)
                    end
                end
            end),
            CommonHandlers.OnNoSleepTimeEvent(32 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
                inst.sg:RemoveStateTag("nosleep")
                inst.sg:RemoveStateTag("nofreeze")
            end),
        },

        events =
        {
            CommonHandlers.OnNoSleepAnimOver("idle"),
        },
    },

    State{--对目标集火攻击
        name = "focustarget",
        tags = { "focustarget", "busy", "nosleep", "nofreeze" },

        onenter = function(inst)
            FaceTarget(inst)
            inst.components.sanityaura.aura = -TUNING.SANITYAURA_HUGE
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("command2")
        end,

        timeline =
        {
            TimeEvent(8 * FRAMES, DoScreech),
            TimeEvent(9 * FRAMES, DoScreechAlert),
            TimeEvent(11 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/attack_pre")
            end),
            TimeEvent(18 * FRAMES, function(inst)
                inst.sg.mem.wantstofocustarget = nil
                inst.sg.mem.focuscount = 0
                inst.sg.mem.focustargets = nil
                inst.components.timer:StartTimer("focustarget_cd", inst.focustarget_cd)

                local soldiers = inst.components.commander:GetAllSoldiers()--获取绑定的守卫
                if #soldiers > 0 then
                    local players = {}--获取附近的玩家列表
                    for k, v in pairs(inst.components.grouptargeter:GetTargets()) do
                        if inst:IsNear(k, TUNING.BEEQUEEN_FOCUSTARGET_RANGE) then
                            table.insert(players, k)
                        end
                    end
					--根据守卫数量确定同时攻击的最大目标数量(至少要3只蜂组成一小队)
                    local maxtargets = math.max(1, math.floor(#soldiers / TUNING.BEEGUARD_SQUAD_SIZE))
                    local targets = {}--攻击目标列表
                    for i = 1, maxtargets do
                        if #players > 0 then
                            --从附近玩家里随便挑一个插入目标列表
							table.insert(targets, table.remove(players, math.random(#players)))
                        else--人不够了，如果当前攻击目标不是人也行，拿来凑数
							if inst.components.combat.target ~= nil and not inst.components.combat.target:HasTag("player") then
                                table.insert(targets, inst.components.combat.target)
                            end
                            break
                        end
                    end
					--攻击目标数量小于最大目标数量的话，把附近仇恨在蜂王身上的其他生物也拉来凑数了
                    if #targets < maxtargets then
                        local x, y, z = inst.Transform:GetWorldPosition()
                        for i, v in ipairs(TheSim:FindEntities(x, y, z, TUNING.BEEQUEEN_FOCUSTARGET_RANGE, FOCUSTARGET_MUST_TAGS, FOCUSTARGET_CANT_TAGS)) do
                            if v.components.combat.target == inst and not v.components.health:IsDead() then
                                table.insert(targets, v)
                                if #targets >= maxtargets then
                                    break
                                end
                            end
                        end
                    end
					--目标数量大于1
                    if #targets > 1 then
                        local sorted = {}--守卫距离排序表
                        --遍历守卫，把它们和每个距离的分数都算出来并录入排序表
						for i, v in ipairs(soldiers) do
                            local dists = {}--守卫和每个目标之间的距离登记表
                            local totaldist = 0--守卫和所有目标之间的总距离
                            for i1, v1 in ipairs(targets) do
                                local distsq = v:GetDistanceSqToInst(v1)
                                table.insert(dists, distsq)
                                totaldist = totaldist + distsq
                            end
							--计算守卫和每个目标之间的距离分数，分数=距离/总距离
                            for i1, v1 in ipairs(dists) do
                                dists[i1] = v1 / totaldist
                            end
							--录入守卫距离排序表
                            table.insert(sorted, { inst = v, scores = dists })
                        end
                        --遍历目标
						for i, v in ipairs(targets) do
                            --根据每个守卫和目标之间的距离进行升序排序
							table.sort(sorted, function(a, b) return a.scores[i] < b.scores[i] end)
                            local squadsize = math.max(#sorted / (#targets - i + 1))--小队规模=剩余守卫数量/(目标数量-i+1)
                            --根据小队规模，把距离目标最近的几只守卫调度出来集火目标
							for i1 = 1, squadsize do
                                table.remove(sorted, 1).inst:FocusTarget(v)
                            end
                        end
                        inst.sg.mem.focustargets = targets
                        inst:BoostCommanderRange(true)--指挥距离提升
                    --就一个目标，那就好办了，全去干他
					elseif #targets > 0 then
                        for i, v in ipairs(soldiers) do
                            v:FocusTarget(targets[1])
                        end
                        inst.sg.mem.focustargets = targets
                        inst:BoostCommanderRange(true)--指挥距离提升
                    end
                end
            end),
            CommonHandlers.OnNoSleepTimeEvent(25 * FRAMES, function(inst)
                inst.sg:AddStateTag("caninterrupt")
                inst.sg:RemoveStateTag("nosleep")
                inst.sg:RemoveStateTag("nofreeze")
            end),
        },

        events =
        {
            CommonHandlers.OnNoSleepAnimOver("focustarget_loop"),
        },

        onexit = function(inst)
            if inst.sg.mem.focuscount == nil then
                inst.components.sanityaura.aura = 0
            end
        end,
    },

    State{
        name = "focustarget_loop",
        tags = { "focustarget", "busy", "nosleep", "nofreeze" },

        onenter = function(inst)
            FaceTarget(inst)
            inst.components.sanityaura.aura = -TUNING.SANITYAURA_HUGE
            if inst.sg.mem.focuscount >= 3 or
                inst.sg.mem.focustargets == nil or
                inst.components.commander:GetNumSoldiers() <= 0 then
                inst.sg:GoToState("focustarget_pst")
            else
                inst.sg.statemem.variation = (inst.sg.mem.focuscount % 2) + 1
                inst.sg.mem.focuscount = inst.sg.mem.focuscount + 1
                inst.components.locomotor:StopMoving()
                if inst.sg.statemem.variation > 1 then
                    inst.sg:GoToState("focustarget_loop2")
                else
                    inst.AnimState:PlayAnimation("command1")
                end
            end
        end,

        timeline =
        {
            TimeEvent(6 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/attack_pre")
            end),
            TimeEvent(7 * FRAMES, DoScreech),
            TimeEvent(8 * FRAMES, DoScreechAlert),
            TimeEvent(20 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/attack_pre")
            end),
            TimeEvent(22 * FRAMES, DoScreech),
            TimeEvent(23 * FRAMES, DoScreechAlert),
            CommonHandlers.OnNoSleepTimeEvent(35 * FRAMES, function(inst)
                inst.sg:AddStateTag("caninterrupt")
                inst.sg:RemoveStateTag("nosleep")
                inst.sg:RemoveStateTag("nofreeze")
            end),
        },

        events =
        {
            CommonHandlers.OnNoSleepAnimOver("focustarget_loop"),
        },
    },

    State{
        name = "focustarget_loop2",
        tags = { "focustarget", "busy", "nosleep", "nofreeze" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("command2")
        end,

        timeline =
        {
            TimeEvent(8 * FRAMES, DoScreech),
            TimeEvent(9 * FRAMES, DoScreechAlert),
            TimeEvent(11 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/attack_pre")
            end),
            CommonHandlers.OnNoSleepTimeEvent(25 * FRAMES, function(inst)
                inst.sg:AddStateTag("caninterrupt")
                inst.sg:RemoveStateTag("nosleep")
                inst.sg:RemoveStateTag("nofreeze")
            end),
        },

        events =
        {
            CommonHandlers.OnNoSleepAnimOver("focustarget_loop"),
        },
    },

    State{
        name = "focustarget_pst",
        tags = { "focustarget", "busy", "nosleep", "nofreeze" },

        onenter = function(inst)
            inst.sg.mem.focuscount = nil
            inst.sg.mem.focustargets = nil
            if inst.components.commander:GetNumSoldiers() <= 0 then
                inst.sg.statemem.ended = true
                inst.components.sanityaura.aura = 0
                inst:BoostCommanderRange(false)
                inst.sg:GoToState("idle")
            else
                inst.components.locomotor:StopMoving()
                inst.AnimState:PlayAnimation("command3")
            end
        end,

        timeline =
        {
            TimeEvent(8 * FRAMES, DoScreech),
            TimeEvent(9 * FRAMES, DoScreechAlert),
            TimeEvent(19 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/attack_pre")
            end),
            TimeEvent(23 * FRAMES, function(inst)
                inst.sg.statemem.ended = true
                inst.components.sanityaura.aura = 0
                for i, v in ipairs(inst.components.commander:GetAllSoldiers()) do
                    v:FocusTarget(nil)
                end
                inst:BoostCommanderRange(false)
            end),
            CommonHandlers.OnNoSleepTimeEvent(32 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
                inst.sg:RemoveStateTag("nosleep")
                inst.sg:RemoveStateTag("nofreeze")
            end),
        },

        events =
        {
            CommonHandlers.OnNoSleepAnimOver("idle"),
        },

        onexit = function(inst)
            if not inst.sg.statemem.ended then
                inst.components.sanityaura.aura = 0
                for i, v in ipairs(inst.components.commander:GetAllSoldiers()) do
                    v:FocusTarget(nil)
                end
                inst:BoostCommanderRange(false)
            end
        end,
    },
}

local function CleanupIfSleepInterrupted(inst)
    if not inst.sg.statemem.continuesleeping then
        RestoreFlapping(inst)
        inst:StartHoney()
		inst:StopRecovery()--停止恢复体力
    end
    RaiseFlyingCreature(inst)
end
CommonStates.AddSleepExStates(states,
{
    starttimeline =
    {
        TimeEvent(8 * FRAMES, StopFlapping),
        TimeEvent(28 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("caninterrupt")
            inst.components.sanityaura.aura = 0
            LandFlyingCreature(inst)
        end),
        TimeEvent(31 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/bee/beehive_hit")
            inst:StopHoney()
			inst:StartRecovery()--开始恢复体力
            ShakeIfClose(inst)
        end),
    },
    waketimeline =
    {
        TimeEvent(19 * FRAMES, StartFlapping),
        CommonHandlers.OnNoSleepTimeEvent(24 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("busy")
            inst.sg:RemoveStateTag("nosleep")
            RaiseFlyingCreature(inst)
        end),
    },
},
{
    onsleep = function(inst)
        inst.sg:AddStateTag("caninterrupt")
        inst.sg.mem.wantstododge = true
        inst.sg.mem.wantstoalert = true
    end,
    onexitsleep = CleanupIfSleepInterrupted,
    onsleeping = function(inst)
        inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/sleep")
        LandFlyingCreature(inst)
    end,
    onexitsleeping = CleanupIfSleepInterrupted,
    onwake = function(inst)
        StopFlapping(inst)
        inst:StartHoney()
		inst:StopRecovery()--停止恢复体力
        LandFlyingCreature(inst)
    end,
    onexitwake = function(inst)
        RestoreFlapping(inst)
        RaiseFlyingCreature(inst)
    end,
})

local function OnOverrideFrozenSymbols(inst)
	inst.components.sanityaura.aura = 0
	StopFlapping(inst)
	inst:StopHoney()
	inst:StartRecovery()--开始恢复体力
	inst.sg.mem.wantstododge = true
	inst.sg.mem.wantstoalert = true
	LandFlyingCreature(inst)
end
local function OnClearFrozenSymbols(inst)
    StartFlapping(inst)
    inst:StartHoney()
	inst:StopRecovery()--停止恢复体力
    RaiseFlyingCreature(inst)
end
CommonStates.AddFrozenStates(states, OnOverrideFrozenSymbols, OnClearFrozenSymbols)

return StateGraph("SGmedal_beequeen", states, events, "idle")
