require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/follow"

-- local RUN_AWAY_DIST = 1
-- local STOP_RUN_AWAY_DIST = 2

local MAX_WANDER_DIST = 3

local MIN_FOLLOW = 0
local MAX_FOLLOW = 4
local MED_FOLLOW = 2

local function LeaderPos(inst)
    local leader = inst.components.follower.leader
    if leader == nil then
        leader = inst --如果没有领导者就以自己为中心徘徊
    end

    if leader and leader:IsValid() then
        return Vector3(leader.Transform:GetWorldPosition())
    end
end

local function GoHomeAction(inst)
    local flower = inst --原地消失
    if flower and flower:IsValid() then
        return BufferedAction(inst, flower, ACTIONS.GOHOME, nil, Vector3(flower.Transform:GetWorldPosition()))
    end
end

local Neverfade_ButterflyBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function Neverfade_ButterflyBrain:OnStart()

    local root =
        PriorityNode(
        {
            -- RunAway(self.inst, "gettooclose", RUN_AWAY_DIST, STOP_RUN_AWAY_DIST),   --互相之间不离得太近
            IfNode(function() return self.inst.dead or self.inst.components.follower.leader == nil or self.inst.components.follower.leader:HasTag("playerghost") end, "ShouldDie",
                DoAction(self.inst, GoHomeAction, "go home", true )),
            Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW, MED_FOLLOW, MAX_FOLLOW, true),
            Wander(self.inst, LeaderPos, MAX_WANDER_DIST),
        },1)

    self.bt = BT(self.inst, root)

end

return Neverfade_ButterflyBrain
