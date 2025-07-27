require "behaviours/wander"
require "behaviours/leash"
require "behaviours/follow"

local MIN_FOLLOW = 1--最小跟随距离，太近了就后退
local MAX_FOLLOW = 4--最大跟随距离，太远了就跟随
local MED_FOLLOW = 2--跟随临界值

local TornadoBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local wanderTimes =
{
    minwalktime = .25,
    randwalktime = .25,
    minwaittime = .25,
    randwaittime = .25,
}

function TornadoBrain:OnStart()
    local root =
    PriorityNode(
    {
        Leash(self.inst, function() return self.inst.components.knownlocations:GetLocation("target") end, 5, 3, true),
        Follow(self.inst, function() return self.inst.mytarget end, MIN_FOLLOW, MED_FOLLOW, MAX_FOLLOW), 
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("target") end, 2, wanderTimes),
    }, .25)
    self.bt = BT(self.inst, root)
end

return TornadoBrain