require("behaviours/chaseandattack")
require("behaviours/faceentity")
require("behaviours/leash")
require("behaviours/wander")

local WANDER_DIST = 6
local FORMATION_DIST = 8

local MedalShadowThrallScreamerBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

local function GetHome(inst)
	return inst.components.knownlocations:GetLocation("spawnpoint")
end

local function GetTarget(inst)
	local target = inst.components.combat.target
	if target ~= nil then
		return target
	end
end

local function IsTarget(inst, target)
	if inst.components.combat:TargetIs(target) then
		return true
	end
end

local function GetTargetPos(inst)
	local target = GetTarget(inst)
	return target ~= nil and target:GetPosition() or nil
end

local function GetFormationPos(inst)
	if inst.formation ~= nil then
		local pos = GetTargetPos(inst)
		if pos ~= nil then
			local angle = inst.formation * DEGREES
			pos.x = pos.x + math.cos(angle) * FORMATION_DIST
			pos.z = pos.z - math.sin(angle) * FORMATION_DIST
			return pos
		end
	end
end

local function IsMyTurnToAttack(inst)
	-- if inst.components.combat:InCooldown() then
	-- 	return false
	-- end
	-- return true
	return not inst.components.combat:InCooldown()
end

function MedalShadowThrallScreamerBrain:OnStart()
	local root = PriorityNode({
		WhileNode(function() return not IsMyTurnToAttack(self.inst) end, "WaitingTurn",
			PriorityNode({
				FailIfSuccessDecorator(
					Leash(self.inst, GetFormationPos, 2, 0.5)),
				FailIfSuccessDecorator(
					Leash(self.inst, GetTargetPos, TUNING.SHADOWTHRALL_WINGS_ATTACK_RANGE + 2, TUNING.SHADOWTHRALL_WINGS_ATTACK_RANGE - 2)),
				FaceEntity(self.inst, GetTarget, IsTarget),
			}, 0.5)),
		ParallelNode{
			ChaseAndAttack(self.inst),
			SequenceNode{
				WaitNode(1),
				ConditionWaitNode(function()
					if not self.inst.sg:HasStateTag("attack") and IsMyTurnToAttack(self.inst) then
						self.inst:PushEvent("doattack", { target = self.inst.components.combat.target })
					end
					return false
				end, "ForceAttack"),
			},
		},
		Wander(self.inst, GetHome, WANDER_DIST),
	}, 0.5)

	self.bt = BT(self.inst, root)
end

return MedalShadowThrallScreamerBrain
