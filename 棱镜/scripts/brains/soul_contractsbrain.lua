require "behaviours/wander"
require "behaviours/standstill"
require "behaviours/follow"

local Soul_ContractsBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

----------
----------

local function GetValid(target)
    if target ~= nil and target:IsValid() then
        return target
    end

    return nil
end

-----

local function StandStart(inst)
    return inst.components.finiteuses ~= nil and inst.components.finiteuses:GetUses() <= 0
end

local function StandKeep(inst)
	return inst.components.finiteuses ~= nil and inst.components.finiteuses:GetUses() <= 0
end

-----

-- local function CanWanderWithOwner(inst)
--     return GetValid(inst.components.follower.leader) ~= nil and
--         inst:GetDistanceSqToInst(inst.components.follower.leader) <= 1
-- end

-- local function GetOwnerPos(inst)
-- 	return GetValid(inst.components.follower.leader) ~= nil and
-- 		Vector3(inst.components.follower.leader.Transform:GetWorldPosition()) or nil
-- end

----------
----------

function Soul_ContractsBrain:OnStart()  
    local root = PriorityNode(
    {
        --用光了灵魂，失去行动力
        StandStill(self.inst, StandStart, StandKeep),

		--在契约拥有者附近徘徊
		-- WhileNode(function() return CanWanderWithOwner(self.inst) end, "WanderAroundOwner",
		-- 	Wander(self.inst, GetOwnerPos, 1)
		-- ),

		--跟随契约拥有者
		Follow(self.inst, function() return self.inst.components.follower.leader end, 0, 3, 6, true),

		--失去契约拥有者后，原地不动
		StandStill(self.inst)
    }, 1)

    self.bt = BT(self.inst, root)
end

function Soul_ContractsBrain:OnInitializationComplete()
end

return Soul_ContractsBrain
