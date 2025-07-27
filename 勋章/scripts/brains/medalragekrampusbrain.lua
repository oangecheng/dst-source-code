require "behaviours/wander"
require "behaviours/chaseandattack"
require "behaviours/follow"
require "behaviours/doaction"
require "behaviours/minperiod"
require "behaviours/panic"
require "behaviours/runaway"

local SEE_DIST = 30--可视距离(用于找可以偷的东西)
local TOOCLOSE = 6--太靠近玩家的距离

local CHASE_DIST = 30--最大追击距离，超过就不追了
local CHASE_TIME = 10--最大追击时间

local MIN_FOLLOW = 10--最小跟随距离，太近了就后退
local MAX_FOLLOW = 20--最大跟随距离，太远了就跟随
local MED_FOLLOW = 15--跟随临界值

local MIN_RUNAWAY = 8--最小逃跑距离，在这个距离内就跑
local MAX_RUNAWAY = MED_FOLLOW--逃跑安全距离，超过了就不跑了

--投石机射程外
local OUTSIDE_CATAPULT_RANGE = TUNING.WINONA_CATAPULT_MAX_RANGE + TUNING.WINONA_CATAPULT_KEEP_TARGET_BUFFER + TUNING.MAX_WALKABLE_PLATFORM_RADIUS + 1
--检查玩家航海距离
local function OceanChaseWaryDistance(inst, target)
    --目标在水上，如果能打到就打，打不到就跑路
    return (CanProbablyReachTargetFromShore(inst, target, 2.75) and 0) or OUTSIDE_CATAPULT_RANGE
end
--可以偷的物品
local function CanSteal(item)
    return item.components.inventoryitem ~= nil--目标可库存
        and item.components.inventoryitem.canbepickedup--并且目标可被捡起
        and item:IsOnValidGround()--并且目标在陆地上
        and not item:IsNearPlayer(TOOCLOSE)--并且目标没有离玩家太近
end

local STEAL_MUST_TAGS = { "_inventoryitem" }
local STEAL_CANT_TAGS = { "INLIMBO", "catchable", "fire", "irreplaceable", "heavy", "prey", "bird", "outofreach", "_container" }
--偷东西
local function StealAction(inst)
    --如果自己库存没满
	if not inst.components.inventory:IsFull() then
        --寻找可视范围内可以偷的东西
		local target = FindEntity(inst, SEE_DIST,
            CanSteal,
            STEAL_MUST_TAGS, --see entityreplica.lua
            STEAL_CANT_TAGS)
        return target ~= nil
            and BufferedAction(inst, target, ACTIONS.PICKUP)
            or nil
    end
end
--可以锤的物品
local function CanHammer(item)
    return item.prefab == "treasurechest"--目标是箱子
        and item.components.container ~= nil--并且有容器组件
        and not item.components.container:IsEmpty()--并且容器不为空
        and not item:IsNearPlayer(TOOCLOSE)--并且箱子没有离玩家太近
        and item:IsOnValidGround()--在陆地上
	--如果以后坎普斯学会跳船、或者在水上移动，这里要包括水
end

local EMPTYCHEST_MUST_TAGS = { "structure", "_container", "HAMMER_workable" }
-- local EMPTYCHEST_MUST_TAGS = { "structure", "HAMMER_workable" }
--清空箱子
local function EmptyChest(inst)
    --如果自己库存没满
	if not inst.components.inventory:IsFull() then
        --寻找可视范围内的可锤物品
		local target = FindEntity(inst, SEE_DIST, CanHammer, EMPTYCHEST_MUST_TAGS)
        --如果目标不为空，则锤了它
		return target ~= nil
            and BufferedAction(inst, target, ACTIONS.HAMMER)
            or nil
    end
end

--需要开始吞噬
local function shouldDevour(inst)
	return inst.devour_cd > 0 and not (inst.components.timer:TimerExists("devour_cd") or inst.sg:HasStateTag("busy"))--不处于CD中
end

--定义暴怒坎普斯大脑
local MedalRageKrampusBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
    self.mytarget = nil--原目标
    self.greed = 2 + math.random(3)--贪婪度，想偷的东西的数量，偷够就跑路了
end)
--设定目标
function MedalRageKrampusBrain:SetTarget(target)
    --如果目标不为空
	if target ~= nil then
        if not target:IsValid() then
            target = nil--目标无效则移除
        elseif self.listenerfunc == nil then--目标有效则设置监听函数
            self.listenerfunc = function() self.mytarget = nil end
        end
    end
	--如果目标不是原目标
    if target ~= self.mytarget then
        --如果原目标不为空，则移除原目标的监听函数
		if self.mytarget ~= nil then
            self.inst:RemoveEventCallback("onremove", self.listenerfunc, self.mytarget)
        end
		--如果新目标不为空，则给它设置监听函数
        if target ~= nil then
            --当目标被移除时，原目标设为空
			self.inst:ListenForEvent("onremove", self.listenerfunc, target)
        end
        self.mytarget = target--原目标设为当前目标
    end
end
--停止
function MedalRageKrampusBrain:OnStop()
    self:SetTarget(nil)--目标设为空
end
--开始
function MedalRageKrampusBrain:OnStart()
    self:SetTarget(self.inst.spawnedforplayer)--初始目标定为召唤它的玩家

    local stealnode = PriorityNode(
    {
		DoAction(self.inst, function() return StealAction(self.inst) end, "steal", true ),
		DoAction(self.inst, function() return EmptyChest(self.inst) end, "emptychest", true )
    }, 2)

    local root = PriorityNode(
    {
        --如果被鬼作祟了或者身上着火了，进入恐慌状态
		-- WhileNode(function() return self.inst.components.hauntable ~= nil and self.inst.components.hauntable.panic or self.inst.components.health.takingfiredamage end, "Panic", Panic(self.inst)),
		--如果被鬼作祟了或者身上着火了，就跳袋子逃跑
		WhileNode(function() return self.inst.components.hauntable ~= nil and self.inst.components.hauntable.panic or self.inst.components.health.takingfiredamage end, "Panic", ActionNode(function() self.inst.sg:GoToState("exit") return SUCCESS end)),
        --需要吞噬就进行吞噬
		WhileNode( function() return shouldDevour(self.inst) end, "devouring",
            ActionNode(function() self.inst.sg:GoToState("devour") end)),
		--追击敌人
		ChaseAndAttack(self.inst, CHASE_TIME,CHASE_DIST, nil, nil, nil, OceanChaseWaryDistance),
        --如果身上的物品数量大于等于贪婪度 并且自己没有处于繁忙的状态，就跳袋子逃跑
		IfNode( function() return self.inst.components.inventory:NumItems() >= self.greed and not self.inst.sg:HasStateTag("busy") end, "donestealing",
            ActionNode(function() self.inst.sg:GoToState("exit") return SUCCESS end, "leave" )),
        --周期执行
		MinPeriod(self.inst, 5, true,
            stealnode),
		--逃跑，看到带有xx标签的物品就跑路
        RunAway(self.inst, {"player","largecreature"}, MIN_RUNAWAY, MAX_RUNAWAY),
        --跟随，保持安全距离猥琐地跟着
		Follow(self.inst, function() return self.mytarget end, MIN_FOLLOW, MED_FOLLOW, MAX_FOLLOW), 
		--游荡，如果有目标，就以目标为原点，进行不超过20距离的游荡
        Wander(self.inst, function() local player = self.mytarget if player then return Vector3(player.Transform:GetWorldPosition()) end end, 20)
    }, 2)

    self.bt = BT(self.inst, root)
end

return MedalRageKrampusBrain
