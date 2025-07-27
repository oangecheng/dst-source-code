require "behaviours/wander"
require "behaviours/chaseandattack"
local BrainCommon = require("brains/braincommon")

local MAX_WANDER_DIST = 15
local GO_HOME_DIST = 30--离家距离
local SEE_DIST = 20--可视距离
local RUN_AWAY_DIST = 2--逃跑距离
local STOP_RUN_AWAY_DIST = 4--停止逃跑距离

--获取"老家"坐标
local function GetHomePos(inst)
    if inst.components.knownlocations then
        --优先以本源之树为家，否则就以出生点为家
        return inst.components.knownlocations:GetLocation("homepoint") or inst.components.knownlocations:GetLocation("spawnpoint")
    end
    return inst:GetPosition()
end
--执行回家动作
local function GoHomeAction(inst)
    if inst.components.combat.target ~= nil then
        return
    end
    local homePos = GetHomePos(inst)
    return homePos ~= nil
        and BufferedAction(inst, nil, ACTIONS.WALKTO, nil, homePos, nil, .2)
        or nil
end
--该回家了
local function ShouldGoHome(inst)
    local homePos = GetHomePos(inst)
    return homePos ~= nil and inst:GetDistanceSqToPoint(homePos:Get()) > GO_HOME_DIST * GO_HOME_DIST
end
--目标是否在家附近
local function IsNearHomePos(inst, target)
    local homePos = GetHomePos(inst)
    local targetPos = target:GetPosition()
    return distsq(homePos.x, homePos.z, targetPos.x, targetPos.z) < SEE_DIST * SEE_DIST
end
local ORIGIN_MUSTTAGS = { "origin_pollinationable" }
local ORIGIN_CANTTAGS = { "NOCLICK" }
--是否要授粉
local function ShouldPollination(inst)
    inst.pollination_target = FindEntity(inst, SEE_DIST, function(target)
        return IsNearHomePos(inst, target) and target ~= inst.last_pollination_target--不能对同一目标连续授粉
    end, ORIGIN_MUSTTAGS, ORIGIN_CANTTAGS)
    return inst.pollination_target ~= nil
end
--授粉(催长)
local function PollinationAction(inst)
    return inst.pollination_target and BufferedAction(inst, inst.pollination_target, ACTIONS.MEDAL_ORIGIN_POLLINATION, nil, nil, nil, 0.1) or nil
end

local MedalOriginFruitFlyBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function MedalOriginFruitFlyBrain:OnStart()
    local brain =
    {
		BrainCommon.PanicTrigger(self.inst),
        --攻击
        WhileNode(function() return self.inst:CanTargetAndAttack() and not self.inst.components.combat:InCooldown() end, "AttackMomentarily", ChaseAndAttack(self.inst)),
        --闪避
        WhileNode(function() return self.inst.components.combat.target ~= nil and self.inst.components.combat:InCooldown() end, "Dodge",
            RunAway(self.inst, function() return self.inst.components.combat.target end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST)),
        --回家
        WhileNode(function() return ShouldGoHome(self.inst) end, "ShouldGoHome",
            DoAction(self.inst, GoHomeAction, "Go Home", true )),
        --授粉
        WhileNode(function() return ShouldPollination(self.inst) end, "Should Pollination",
            DoAction(self.inst, PollinationAction, "Pollination", true )),
        --闲逛
        Wander(self.inst, GetHomePos, MAX_WANDER_DIST),
    }
    local root = PriorityNode(brain, .25)
    self.bt = BT(self.inst, root)
end

--初始化记录坐标
function MedalOriginFruitFlyBrain:OnInitializationComplete()
    --本源之树坐标点
    if TheWorld and TheWorld.medal_origin_tree ~= nil then
        self.inst.components.knownlocations:RememberLocation("homepoint", TheWorld.medal_origin_tree:GetPosition(), true)
    end
    --自己生成的坐标点
    local pos = self.inst:GetPosition()
    pos.y = 0
    self.inst.components.knownlocations:RememberLocation("spawnpoint", pos, true)
end

return MedalOriginFruitFlyBrain