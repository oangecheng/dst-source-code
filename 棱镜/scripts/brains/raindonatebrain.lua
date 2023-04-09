require "behaviours/wander"
require "behaviours/leash"
require "behaviours/doaction"
require "behaviours/chaseandattack"
require "behaviours/runaway"

local MAX_LEASH_DIST = 20
local MAX_WANDER_DIST = 10
local RUN_AWAY_DIST = 4
local STOP_RUN_AWAY_DIST = 8

local MAX_CHASE_DIST = 8
local MAX_CHASE_TIME = 10

local STOP_RUN_DIST = 10
local SEE_PLAYER_DIST = 5

local AVOID_PLAYER_DIST = 3
local AVOID_PLAYER_STOP = 6

local function GoHomeAction(inst)
    if inst.components.homeseeker and
       inst.components.homeseeker.home and
       inst.components.homeseeker.home:IsValid()
    then
        return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
    end
end

local function GetWanderPos(inst)
	if inst.components.combat:ValidateTarget() then
		return Point(inst.components.combat.target.Transform:GetWorldPosition())
	end
	return inst.components.knownlocations:GetLocation("home")
end

local function ShouldGoHome(inst) --夜晚或者冬季时回家
    return TheWorld.state.isnight or TheWorld.state.iswinter
end

local RaindonateBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function RaindonateBrain:OnStart()
    local root = PriorityNode(
    {
        WhileNode( function() return self.inst.components.hauntable and self.inst.components.hauntable.panic end, "PanicHaunted", Panic(self.inst)),
		WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),

        --主动回家
        WhileNode(function() return ShouldGoHome(self.inst) end, "ItsTooLate",
            DoAction(self.inst, GoHomeAction, "go home", true)
        ),

        --会被吓跑
        RunAway(self.inst, "scarytoprey", AVOID_PLAYER_DIST, AVOID_PLAYER_STOP),
        RunAway(self.inst, "scarytoprey", SEE_PLAYER_DIST, STOP_RUN_DIST, nil, false),  --设定为false，表示受到惊吓不会直接回home

		Leash(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_LEASH_DIST, MAX_WANDER_DIST),

        --走位攻击
        WhileNode( function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
            ChaseAndAttack(self.inst, SpringCombatMod(MAX_CHASE_TIME), SpringCombatMod(MAX_CHASE_DIST))
        ),
        WhileNode( function() return self.inst.components.combat.target ~= nil and self.inst.components.combat:InCooldown() end, "Dodge",
            RunAway(self.inst, function() return self.inst.components.combat.target end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST)
        ),

        --徘徊
        Wander(self.inst, function() return GetWanderPos(self.inst) end, MAX_WANDER_DIST, {minwalktime=0.1,randwalktime=0.1,minwaittime=0.0,randwaittime=0.0})
    }, .25)

    self.bt = BT(self.inst, root)
end

function RaindonateBrain:OnInitializationComplete()
    ------------------------------------------------------
    --知识点----------------------------------------------
    --[[
        这里会在是脑子初始化时就执行，大多数生物在这里进行home地点的记录，
        也就导致，每次生物睡觉、被冰冻等会导致脑子停止，在脑子再次启动后，
        就会记录新的home地点，所以原本的home地点就会被替代
        如果想要最初的home不能被替代，可以设置RememberLocation()第三个参数为true
    ]]----------------------------------------------------
    ------------------------------------------------------

    self.inst.components.knownlocations:RememberLocation("home", self.inst:GetPosition(), true)
end

return RaindonateBrain
