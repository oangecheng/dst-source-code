require "behaviours/follow"
require "behaviours/wander"
require "behaviours/standstill"

local BRIGHTMARE_AVOID_DIST = 2
local BRIGHTMARE_AVOID_STOP = 4

local AVOID_SHADOW_DIST = 5
local AVOID_SHADOW_STOP = 8

local ATTACK_CHASE_DIST = 15--追击距离
local ATTACK_CHASE_TIME = 10--追击时间
local AVOID_PLAYER_DIST = 6.1--攻击间隙躲玩家的距离
local AVOID_PLAYER_STOP = 8--躲到这个距离后停止

local SHADOW_TAGS = {oneoftags = {"nightmarecreature", "shadowcreature", "shadow", "shadowminion", "stalker", "stalkerminion", "nightmare", "shadow_fire"}}

local MedalGestaltBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)
--离玩家太远了，准备转移阵地了
local function ShouldRelocate(inst)
    return not inst.sg:HasStateTag("busy")
		and not inst:IsNearPlayer(TUNING_MEDAL.MEDAL_GESTALT_RELOCATED_FAR_DIST, true)
end

local function Relocate(inst)
	inst.sg:GoToState("relocate")
end

local function onrunaway(target, inst)
	inst.components.combat:DropTarget()
	return true
end

function MedalGestaltBrain:OnStart()
    local root = PriorityNode({
		WhileNode(function() return not self.inst.sg:HasStateTag("jumping") end, "AttackAndWander",
			PriorityNode({
				WhileNode( function() return ShouldRelocate(self.inst) end, "relocate",
					SequenceNode{
						ActionNode(function() Relocate(self.inst) end),
						StandStill(self.inst),
					}),
				-- RunAway(self.inst, SHADOW_TAGS, AVOID_SHADOW_DIST, AVOID_SHADOW_STOP, onrunaway),

				PriorityNode({
					ChaseAndAttack(self.inst, ATTACK_CHASE_TIME, ATTACK_CHASE_DIST, nil, nil, true),
					IfNode(function() return self.inst.components.combat:InCooldown() end, "combat_pst",
						RunAway(self.inst, "player", AVOID_PLAYER_DIST, AVOID_PLAYER_STOP)),
				}, 0.1),

				RunAway(self.inst, "brightmare", BRIGHTMARE_AVOID_DIST, BRIGHTMARE_AVOID_STOP),
				Wander(self.inst, nil, nil, { minwaittime = 0, randwaittime = 0 }),
			}, 0.1)),
		}, 0.1)

    self.bt = BT(self.inst, root)
end

return MedalGestaltBrain