require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"
-- require "behaviours/attackwall"
-- require "behaviours/panic"
require "behaviours/minperiod"
require "behaviours/standstill"
require "giantutils"
require "behaviours/leash"
-- require "behaviours/runaway"

local ElecarmetBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local CHASE_DIST = 20
local CHASE_TIME = 10

local function GetHomePos(inst)
    return inst.components.knownlocations:GetLocation("spawnpoint")
end

local function GetDistance(inst, target)    --得到的是距离的平方
    return target:GetDistanceSqToPoint(inst.Transform:GetWorldPosition())
end

local function ValidTarget(target)
    if target and target:IsValid() then
        if target.components.health ~= nil and not target.components.health:IsDead() then   --有生命对象还没死
            return true
        elseif target.components.workable ~= nil and target.components.workable.action ~= ACTIONS.DIG then   --对象能被破坏(除了挖)
            return true
        end
    end

    return false
end

local function FindTarget(inst, radius)
    return FindEntity(inst, radius, function(item) return ValidTarget(item) end, nil, {"NOCLICK", "FX", "shadow", "playerghost", "INLIMBO"}, nil)
end

local function StandStart(inst)
	--防止一直呆着
	if not ValidTarget(inst.components.combat.target) then
		return false
	end
	if GetDistance(inst, inst.components.combat.target) <= inst.hit_range_sq then
		return false
	end

	if inst.standstill_target == nil then	--如果以前的目标没了就重新找
		local target = FindTarget(inst, 3)

		if target ~= nil and target ~= inst.components.combat.target then
			inst.standstill_target = target
			return true
		end
	else
		return true
	end

	return false
end

local function StandKeep(inst)
	if not ValidTarget(inst.components.combat.target) then
		return false
	end
	if GetDistance(inst, inst.components.combat.target) <= inst.hit_range_sq then
		return false
	end

	if inst.standstill_target ~= nil then
		if ValidTarget(inst.standstill_target) and GetDistance(inst, inst.standstill_target) <= 36 then
			return true
		else
			inst.standstill_target = nil
		end
	end

	return false
end

function ElecarmetBrain:OnStart()  
    local root = PriorityNode(
    {
		StandStill(self.inst, StandStart, StandKeep),	--如果周围有对象，就会站着不动，这是为了提供一种攻击方式，或者防止被卡位
		ChaseAndAttack(self.inst, CHASE_TIME, CHASE_DIST),
		Leash(self.inst, GetHomePos, 25, 15),	--最大牵制距离，最大随机步伐距离
		Wander(self.inst, GetHomePos, 5),
    }, .25)

    self.bt = BT(self.inst, root)
end

function ElecarmetBrain:OnInitializationComplete()
    local pos = self.inst:GetPosition()
    pos.y = 0
    self.inst.components.knownlocations:RememberLocation("spawnpoint", pos, true)
end

return ElecarmetBrain
