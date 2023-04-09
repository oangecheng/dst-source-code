require "behaviours/standandattack"
-- require "behaviours/chaseandattack"

local CALM_DELAY = 10

local SpaceTimeDevourBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)
--该找玩家玩玩了
local function ShouldCallPlayer(inst)
    return not inst.components.worldsettingstimer:ActiveTimerExists("call_cd")--不处于召唤CD中
end

function SpaceTimeDevourBrain:OnStart()
    local root = PriorityNode({
        StandAndAttack(self.inst),
        WhileNode(function() return ShouldCallPlayer(self.inst) end, "CallBack",
            ActionNode(function() self.inst:PushEvent("callback") end)),
        SequenceNode{
            ActionNode(function() self.inst.components.combat:SetAttackPeriod(TUNING.ANTLION_MAX_ATTACK_PERIOD) end),
            WaitNode(CALM_DELAY),
            ActionNode(function() self.inst:PushEvent("antlionstopfighting") end),
        },
    }, .5)

    self.bt = BT(self.inst, root)
end

return SpaceTimeDevourBrain
