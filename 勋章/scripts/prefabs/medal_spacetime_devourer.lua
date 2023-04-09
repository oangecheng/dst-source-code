require("worldsettingsutil")

local assets =
{
    -- Asset("ANIM", "anim/antlion_build.zip"),
    Asset("ANIM", "anim/medal_spacetime_devourer_build.zip"),
    Asset("ANIM", "anim/antlion_basic.zip"),
    Asset("ANIM", "anim/antlion_action.zip"),
    Asset("ANIM", "anim/sand_splash_fx.zip"),
    Asset("ANIM", "anim/medal_spacetime_splash_fx.zip"),
	Asset("ATLAS", "minimap/medal_spacetime_devourer.xml"),
}

local prefabs =
{
    "medal_sinkhole",
    "medal_spike",
    "medal_block",
    "medal_spacetime_treasure",
}

-- SetSharedLootTable('medal_spacetime_devourer',
-- {
--     {'medal_spacetime_treasure',    1.00},
-- })

--------------------------------------------------------------------------
--检查物品是否可被接受
local function AcceptTest(inst, item, giver)
    local x,y,z = giver.Transform:GetWorldPosition()
	if y > 0 then return false end--做人要脚踏实地啊
    return item.components.tradable and item.components.tradable.spacetime_value ~= nil and item.components.tradable.spacetime_value > 0 and inst.components.combat:CanTarget(giver)
end

local function OnGivenItem(inst, giver, item)
    inst.food_value = item.components.tradable and item.components.tradable.spacetime_value
    if item.prefab=="medal_spacetime_snacks" then
        inst.snacks_num = inst.snacks_num + 1--记录吃掉的时空零食数量
    end
    inst:PushEvent("onaccepttribute")
    --重置生气时间
    local timeleft = inst.components.worldsettingstimer:GetTimeLeft("rage_cd")
    if timeleft ~= nil then
        inst.components.worldsettingstimer:SetTimeLeft("rage_cd", TUNING_MEDAL.MEDAL_SPACETIME_DEVOURER_RAGE_TIME_INITIAL)
        inst.components.worldsettingstimer:ResumeTimer("rage_cd")
    else
        inst.components.worldsettingstimer:StartTimer("rage_cd", TUNING_MEDAL.MEDAL_SPACETIME_DEVOURER_RAGE_TIME_INITIAL)
    end

    --重置召回时间
    local calltimeleft = inst.components.worldsettingstimer:GetTimeLeft("rage_cd")
    if calltimeleft ~= nil then
        inst.components.worldsettingstimer:SetTimeLeft("call_cd", TUNING_MEDAL.MEDAL_SPACETIME_DEVOURER_CALL_CD)
        inst.components.worldsettingstimer:ResumeTimer("call_cd")
    else
        inst.components.worldsettingstimer:StartTimer("call_cd", TUNING_MEDAL.MEDAL_SPACETIME_DEVOURER_CALL_CD)
    end
end
--拒绝
local function OnRefuseItem(inst, giver, item)
    inst:PushEvent("onrefusetribute")
end

local function ontimerdone(inst, data)
    if data.name == "rage_cd" then
        inst.components.medal_sinkholespawner:StartSinkholes()
        inst.components.worldsettingstimer:StartTimer("rage_cd", TUNING_MEDAL.MEDAL_SPACETIME_DEVOURER_RAGE_TIME_INITIAL)--开始循环
        inst.max_hungerrate = math.max(0,inst.max_hungerrate-6)
        -- if inst.components.hunger then
        --     inst.components.hunger:SetRate(inst.max_hungerrate)
        -- end
    end
end

--进食
local function EatFood(inst)
    local hunger=inst.components.hunger
    local addnum = inst.food_value or 0
    if addnum > 0 and hunger and not (hunger:GetPercent()>=1) then
        --无敌的时候饱食度变更还得自己算
        hunger.current = math.clamp(hunger.current + addnum, 0, hunger.max)
        if hunger:GetPercent()>=1 then
            inst:PushEvent("satisfy")--吃饱喝足了跑路咯
        else--吃零食减攻速
            inst.components.combat:SetAttackPeriod(math.min(TUNING_MEDAL.MEDAL_SPACETIME_MAX_ATTACK_PERIOD, inst.components.combat.min_attack_period + TUNING_MEDAL.MEDAL_SPACETIME_SLOW_DOWN*math.floor(addnum/50)))
        end
    end
end
--随时准备回家
local function GoHome(inst)
    local pt=inst:GetPosition()
    --当前世界上有时空风暴
    if TheWorld.net.components.medal_spacetimestorms ~= nil and next(TheWorld.net.components.medal_spacetimestorms._spacetimestorm_nodes:value()) ~= nil then
        --时空吞噬者不在风暴中,则返回风暴
        if not TheWorld.net.components.medal_spacetimestorms:IsPointInSpacetimestorm(pt) then
            if inst.worldpos==nil then
                inst.worldpos = TheWorld and TheWorld.components.medal_spacetimestormmanager and TheWorld.components.medal_spacetimestormmanager:FindStormCenterPos()
            end
            if inst:IsAsleep() then
                inst.Transform:SetPosition(inst.worldpos.x,inst.worldpos.y,inst.worldpos.z)
                inst.worldpos=nil
            else
                inst:PushEvent("gohome")
            end
        end
    else--没时空风暴？那跑路了呀
        if inst.persists then
            inst.persists = false
            -- if inst.gohome_task then
            --     inst.gohome_task:Cancel()
            --     inst.gohome_task = nil
            -- end
            if inst:IsAsleep() then
                inst:Remove()
            else
                inst.components.medal_sinkholespawner:StopSinkholes()
                inst:PushEvent("leaveworld")
            end
        end
    end
end
--初始化
local function OnInit(inst)
    inst.inittask = nil
    --监听风暴变化，风暴没了就准备回家
    -- inst.onsandstormchanged = function(src, data)
    --     if data.stormtype == STORM_TYPES.MEDAL_SPACETIMESTORM then
    --         inst:DoTaskInTime(1,GoHome)
    --     end
    -- end
    -- inst:ListenForEvent("ms_stormchanged", inst.onsandstormchanged, TheWorld)
    inst.gohome_task=inst:DoPeriodicTask(3,GoHome)
    -- inst:DoTaskInTime(1,GoHome)--看看是不是满足回家的条件,满足的话回家了
end

--更新饥饿速度
local function UpdateHungerRate(inst)
    local lostplayers = TheWorld and TheWorld.components.medal_spacetimestormmanager and TheWorld.components.medal_spacetimestormmanager:GetLostPlayer()
    local player_num = lostplayers and #lostplayers or 1
    inst.max_hungerrate = math.max(math.ceil(math.pow(player_num - 1,0.5)*8),inst.max_hungerrate)
    -- print(inst.max_hungerrate)
    if inst.components.hunger and inst.max_hungerrate>0 then
        -- inst.components.hunger:SetRate(inst.max_hungerrate)
        inst.components.hunger.current = math.clamp(inst.components.hunger.current - inst.max_hungerrate, 0, inst.components.hunger.max)
    end
end

--------------------------------------------------------------------------

local function ShouldSleep(inst)
    return false
end

local function ShouldWake(inst)
    return true
end

--------------------------------------------------------------------------

local brain = require("brains/medal_spacetime_devourerbrain")

--重新寻找攻击目标
local function RetargetFn(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local newplayer = FindClosestPlayerInRange(x, y, z, TUNING_MEDAL.MEDAL_SPACETIME_DEVOURER_CAST_RANGE, true)
    return newplayer, true
end
--保持攻击目标
local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
        and inst:IsNear(target, TUNING_MEDAL.MEDAL_SPACETIME_DEVOURER_CAST_RANGE)
end

local function OnAttacked(inst, data)
    if data.attacker ~= nil and data.attacker:IsNear(inst, TUNING_MEDAL.MEDAL_SPACETIME_DEVOURER_CAST_RANGE) then
        local target = inst.components.combat.target
        if not (target ~= nil and
                target:IsNear(inst, TUNING_MEDAL.MEDAL_SPACETIME_DEVOURER_CAST_RANGE) and
                target.components.combat:IsRecentTarget(inst) and
                (target.components.combat.laststartattacktime or 0) + 3 >= GetTime()) then
            inst.components.combat:SetTarget(data.attacker)
        end
    end
end

local function OnSave(inst,data)
    if inst.snacks_num and inst.snacks_num>0 then
        data.snacks_num = inst.snacks_num
    end
    if inst.slider_num and inst.slider_num>0 then
        data.slider_num = inst.slider_num
    end
end

local function OnLoad(inst,data)
    inst.components.worldsettingstimer:StopTimer("wall_cd")
    if TheWorld and TheWorld.components.medal_spacetimestormmanager then
        TheWorld.components.medal_spacetimestormmanager.st_devourer=inst
    end
    if data and data.snacks_num then
        inst.snacks_num = data.snacks_num
    end
    if data and data.slider_num then
        inst.slider_num = data.slider_num
    end
end

local function PushMusic(inst)
    if ThePlayer == nil then
        inst._playingmusic = false
    elseif ThePlayer:IsNear(inst, inst._playingmusic and 40 or 20) then
        inst._playingmusic = true
        ThePlayer:PushEvent("triggeredevent", { name = "antlion" })
    elseif inst._playingmusic and not ThePlayer:IsNear(inst, 50) then
        inst._playingmusic = false
    end
end

--------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("antlion")
    inst.AnimState:SetBuild("medal_spacetime_devourer_build")
    inst.AnimState:OverrideSymbol("sand_splash", "medal_spacetime_splash_fx", "sand_splash")
    inst.AnimState:PlayAnimation("idle", true)

    inst.MiniMapEntity:SetIcon("medal_spacetime_devourer.tex")
    inst.MiniMapEntity:SetPriority(1)

    MakeObstaclePhysics(inst, 1.5)

    inst:AddTag("epic")
    inst:AddTag("noepicmusic")
    inst:AddTag("medal_spacetime_devourer")
    -- inst:AddTag("antlion")
    inst:AddTag("largecreature")
    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("scarytoprey")
    inst:AddTag("hostile")
    inst:AddTag("noattack")--不可被攻击
    inst:AddTag("notarget")--不可被当成攻击目标

    --trader (from trader component) added to pristine state for optimization
    inst:AddTag("trader")

    inst.entity:SetPristine()

    --Dedicated server does not need to trigger music
    if not TheNet:IsDedicated() then
        inst._playingmusic = false
        inst:DoPeriodicTask(1, PushMusic, 0)
    end

    if not TheWorld.ismastersim then
        return inst
    end

    inst.snacks_num = 0--吃过的时空零食数量
    inst.slider_num = 0--掉落的时空碎片数量

    inst:AddComponent("inspectable")
    -- inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(AcceptTest)
    inst.components.trader.onaccept = OnGivenItem
    inst.components.trader.onrefuse = OnRefuseItem

    inst:AddComponent("combat")
    inst.components.combat:SetAttackPeriod(TUNING_MEDAL.MEDAL_SPACETIME_MAX_ATTACK_PERIOD)
    inst.components.combat:SetRange(TUNING_MEDAL.MEDAL_SPACETIME_DEVOURER_CAST_RANGE)
    inst.components.combat:SetRetargetFunction(2, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst.components.combat.hiteffectsymbol = "body"

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING_MEDAL.MEDAL_SPACETIME_DEVOURER_HEALTH)
    inst.components.health.nofadeout = true
    inst.components.health:SetInvincible(true)
    --饱食度
    inst.max_hungerrate = 0--最大饥饿速度
    inst:AddComponent("hunger")
    inst.components.hunger:SetMax(TUNING_MEDAL.MEDAL_SPACETIME_DEVOURER_HEALTH)
    inst.components.hunger.current=0--初始饱食度为0
    -- inst.components.hunger:SetRate(0)--饥饿速度
    -- inst.components.hunger:SetKillRate(0)--饥饿时的掉血速度
    inst.components.hunger:Pause()--反正无敌不能正常计算饱食度，直接暂停得了

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_SUPERHUGE--贼夸张的减san光环

    inst:SetStateGraph("SGmedal_spacetime_devourer")
    inst:SetBrain(brain)

    inst:ListenForEvent("attacked", OnAttacked)

    inst:AddComponent("worldsettingstimer")
    inst:ListenForEvent("timerdone", ontimerdone)
    inst.components.worldsettingstimer:AddTimer("wall_cd", TUNING_MEDAL.MEDAL_SPACETIME_DEVOURER_WALL_CD, true)
    inst.components.worldsettingstimer:AddTimer("call_cd", TUNING_MEDAL.MEDAL_SPACETIME_DEVOURER_CALL_CD, true)--召集玩家CD
    inst.components.worldsettingstimer:StartTimer("call_cd", TUNING_MEDAL.MEDAL_SPACETIME_DEVOURER_CALL_CD)
    inst.components.worldsettingstimer:AddTimer("rage_cd",TUNING_MEDAL.MEDAL_SPACETIME_DEVOURER_RAGE_TIME_INITIAL, true)--地陷定时器,最大不喂食时长(超过了就生气气)
    inst.components.worldsettingstimer:StartTimer("rage_cd", TUNING_MEDAL.MEDAL_SPACETIME_DEVOURER_RAGE_TIME_INITIAL)

    inst:AddComponent("medal_sinkholespawner")
    -- inst:AddComponent("lootdropper")
    -- inst.components.lootdropper:SetChanceLootTable("medal_spacetime_devourer")
    inst.GoHome = GoHome--回家
    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.EatFood = EatFood--进食

    inst.inittask = inst:DoTaskInTime(0, OnInit)
    inst.hunger_task = inst:DoPeriodicTask(1, UpdateHungerRate)

    return inst
end

return Prefab("medal_spacetime_devourer", fn, assets, prefabs)
