require("stategraphs/commonstates")
require("behaviours/wander")
require "behaviours/chaseandattack"
require "behaviours/leash"

local CHASE_TIME = 10

local function GetMatePos(inst)
    if
        inst.components.combat.target == nil and --没有仇恨时才需要跟着伴侣
        inst.mate ~= nil and
        not inst.mate.iseye and
        not inst.mate.sg:HasStateTag("flight")
    then
        return inst.mate:GetPosition()
    end
end
local function GetHomePos(inst)
    return inst.components.knownlocations:GetLocation("tree") or
        inst.components.knownlocations:GetLocation("spawnpoint")
end

------

local Siving_PhoenixBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function Siving_PhoenixBrain:OnStart()
    local root = PriorityNode({
        WhileNode(function() return not self.inst.sg:HasStateTag("flight") end, "Not Flying", --飞行时脑子停运
            PriorityNode{
                Leash(self.inst, GetMatePos, self.inst.DIST_MATE, self.inst.DIST_MATE/2), --被伴侣牵制
                ChaseAndAttack(self.inst, CHASE_TIME, self.inst.DIST_REMOTE), --追着攻击
                Leash(self.inst, GetHomePos, self.inst.DIST_REMOTE, self.inst.DIST_REMOTE/2), --被神木或出生点牵制
                -- DoAction(self.inst, EatFoodAction),
                Wander(self.inst, GetHomePos, self.inst.DIST_REMOTE) --神木或出生点周围徘徊
            }
        )
    }, .75)

    self.bt = BT(self.inst, root)
end

function Siving_PhoenixBrain:OnInitializationComplete()
    self.inst.components.knownlocations:RememberLocation("spawnpoint", self.inst:GetPosition(), true)
end

return Siving_PhoenixBrain
