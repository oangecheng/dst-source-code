require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/wander"

local SEE_THREAT_DIST = 3.5--发现威胁的距离
local STOP_RUN_DIST = 6--停止逃跑的距离

local EAT_FOOD_DIST = 32--寻找吃的东西的距离
local DUSTOFF_DIST = 14--勋章可打扫的目标的距离

local STUCK_MAX_TIME = 6--被卡住的时间上限，超过上限就开始强制游荡
local UNSTUCK_WANDER_DURATION = 4--解除防卡位状态的周期，进入防卡位状态后一定时间解除该状态

local SEARCH_ANIM_CHANCE = .35--播放搜索动画的概率

local NOTAGS = { "INLIMBO" }

local HUNTERPARAMS_NOPLAYER =
{
    tags = { "scarytoprey" },
    notags = { "player", "NOCLICK" },
}

local Medal_DustMothBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)
--尝试播放搜索动画
local function AttemptPlaySearchAnim(inst, target)
    local time = GetTime()
    --当前不处于搜索动画CD中
    if time - inst._last_played_search_anim_time > TUNING_MEDAL.MEDAL_DUSTMOTH.SEARCH_ANIM_COOLDOWN and math.random() < SEARCH_ANIM_CHANCE then
        inst._last_played_search_anim_time = time

        if target ~= nil and target:IsValid() then
            inst.Transform:SetRotation(inst:GetAngleToPoint(target:GetPosition():Get()))
        end

        inst:PushEvent("dustmothsearch")
    end
end
--尝试修复巢穴
local function RepairDenAction(inst)
    if inst.sg:HasStateTag("busy") then
        return
    end

    if inst._charged and inst.components.homeseeker ~= nil--如果已经吃饱了
        and inst.components.homeseeker.home ~= nil and inst.components.homeseeker.home:IsValid()--并且自己的老巢尚在
        and not inst.components.homeseeker.home.components.workable.workable then--并且老巢属于空巢状态(不可挖掘)

        return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.REPAIR)--开始修复老巢
    end
end

local EATFOOD_TAGS = { "medaldustmothfood" }
local EATFOOD_CANT_TAGS = { "outofreach", "INLIMBO" }
--尝试吃东西
local function EatFoodAction(inst)
    --不应该处于忙碌或者已吃饱的状态
    if inst.sg:HasStateTag("busy") or inst._charged then
        return
    end

    local target = inst.components.inventory:GetItemInSlot(1)--获取身上的道具
    local attempt_play_search_anim = false--是否尝试播放搜索动画
    --如果身上没有道具，或者不能吃，就寻找附近的食物
    if target == nil or not target:HasTag("medaldustmothfood") then
        attempt_play_search_anim = true--找来的吃的当然要播搜索动画了

        target = FindEntity(inst,
            EAT_FOOD_DIST,
            function(item)
                return item:GetTimeAlive() >= 1 and item:IsOnValidGround()
            end,
            EATFOOD_TAGS,
            EATFOOD_CANT_TAGS
        )
    end
    --找到吃的了，开吃！
    if target ~= nil then
        if attempt_play_search_anim then
            AttemptPlaySearchAnim(inst, target)
        end

        local ba = BufferedAction(inst, target, ACTIONS.EAT)
        return ba
    end
end

local DUSTOFF_TAGS = { "dustable" }
--尝试打扫(远古档案馆里的各种乱七八糟的东西都可以被打扫)
local function DustOffAction(inst)
    --当前不在忙碌状态且不处于打扫CD中
    if inst.sg:HasStateTag("busy") or not inst._find_dustables then
        return
    end
    --寻找可打扫的目标
    local target = FindEntity(inst, DUSTOFF_DIST, nil, DUSTOFF_TAGS, NOTAGS)

    if target ~= nil then
        AttemptPlaySearchAnim(inst, target)

        --这是让尘蛾进入特定sg的hack，实际执行前会清掉这个动作
        local ba = BufferedAction(inst, target, ACTIONS.PET)
        ba.distance = target.Physics ~= nil and (target.Physics:GetRadius() + 1) or 1.5
        return ba
    end
end

function Medal_DustMothBrain:OnStart()
    local root = PriorityNode(
    {
        WhileNode(function() return self.inst.components.health.takingfiredamage or self.inst.components.burnable:IsBurning() end, "OnFire",
            Panic(self.inst)),--如果身上起火了，开始恐慌
        --被作祟了也恐慌
        WhileNode(function() return self.inst.components.hauntable and self.inst.components.hauntable.panic end, "PanicHaunted", Panic(self.inst)),
        WhileNode(function() return self.inst.components.inventory:GetItemInSlot(1) == nil end, "RunAwayAll",
            RunAway(self.inst, "scarytoprey", SEE_THREAT_DIST, STOP_RUN_DIST)),--身上没东西的话，看到任何带有scarytoprey标签的东西都会跑
        RunAway(self.inst, HUNTERPARAMS_NOPLAYER, SEE_THREAT_DIST, STOP_RUN_DIST),--身上有东西则看到玩家不会跑
        --如果在一个地方被卡住太久了，就选择
        WhileNode(function() return self.inst:GetBufferedAction() ~= nil and self.inst._time_spent_stuck >= STUCK_MAX_TIME and not self.inst.sg:HasStateTag("busy") end, "CheckStuck",
            ActionNode(function()
                self.inst._time_spent_stuck = 0
                self.inst._force_unstuck_wander = true--强制脱离卡位的标记
                self.inst:DoTaskInTime(UNSTUCK_WANDER_DURATION, function(inst) inst._force_unstuck_wander = nil end)--一定时间后移除该标记
                self.inst:ClearBufferedAction()
            end)),
        --进行防卡位游荡
        WhileNode(function() return self.inst._force_unstuck_wander end, "UndoStuck", Wander(self.inst, function() return self.inst:GetPosition() end, 10)),

        DoAction(self.inst, RepairDenAction, "RepairDen"),--修复老巢
        DoAction(self.inst, EatFoodAction, "EatFood"),--吃东西
        DoAction(self.inst, DustOffAction, "DustOff"),--打扫各种物品
        --在家周围游荡
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, 40),
    }, .25)

    self.bt = BT(self.inst, root)
end

return Medal_DustMothBrain
