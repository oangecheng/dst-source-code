require "behaviours/chaseandattack"
require "behaviours/leash"
local BrainCommon = require("brains/braincommon")

local MedalOriginElfBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local MAX_WANDER_DIST = 5

--获取家(本源之树)的坐标
local function GetHomePos(inst)
    return inst.components.knownlocations:GetLocation("homepoint")
end

function MedalOriginElfBrain:OnStart()
    local root = PriorityNode(
    {
		BrainCommon.PanicTrigger(self.inst),
        Leash(self.inst, GetHomePos, 5, 4),--出生第一件事，回家！
        -- ChaseAndAttack(self.inst, 12, 21),
        ActionNode(function() self.inst:PushEvent("exit", { force = true, idleanim = true }) end),
    }, .25)

    self.bt = BT(self.inst, root)
end

--初始化记录坐标
function MedalOriginElfBrain:OnInitializationComplete()
    --本源之树坐标点
    if TheWorld and TheWorld.medal_origin_tree ~= nil then
        self.inst.components.knownlocations:RememberLocation("homepoint", TheWorld.medal_origin_tree:GetPosition(), true)
    end
    --自己生成的坐标点
    self.inst.components.knownlocations:RememberLocation("spawnpoint", self.inst:GetPosition())
end

return MedalOriginElfBrain
