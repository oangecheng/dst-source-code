require "behaviours/chaseandattack"
require "behaviours/faceentity"
require "behaviours/wander"
require "behaviours/leash"

local FLEE_DELAY = 15--逃跑的延迟秒数
local DODGE_DELAY = 5--闪避的延迟秒数
local MAX_DODGE_TIME = 3--最大闪避时间
local SEE_PLAYER_DIST = 20--发现玩家的距离(目前没啥用)

local MedalBeeQueenBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
    self._act = nil--特殊动作
    self._lastengaged = 0--最近一次交战时间
    self._lastdisengaged = 0--最近一次停战时间
    self._engaged = false--是否处于交战状态
    self._shouldchase = false--是否追击
    self._dodgedest = nil--闪避坐标点
    self._dodgetime = nil--最近闪避时间
end)
--获取出生点坐标
local function GetHomePos(inst)
    return inst.components.knownlocations:GetLocation("spawnpoint")
end
--获取攻击目标
local function GetFaceTargetFn(inst)
    return inst.components.combat.target
end
--判断当前目标是否为攻击目标
local function KeepFaceTargetFn(inst, target)
    return inst.components.combat:TargetIs(target)
end
--尝试触发尖叫
local function TryScreech(self)
	--身上着火了
	if self.inst.components.health.takingfiredamage then
		-- return "screech"--无视CD直接尖叫
		self.inst.withered_num = math.min(self.inst.withered_num+1,90)--凋零值+1
	end
	--当前有攻击目标(简单来说就是重新进入交战状态的时候会触发一次尖叫)
	if self.inst.components.combat:HasTarget() then
        self._lastengaged = GetTime()--将交战时间设为当前时间
        --如果不处于交战状态并且交战时间和停战时间之间差了2秒以上，则触发尖叫
		if not self._engaged and self._lastengaged - self._lastdisengaged > 2 then
            self._engaged = true--将当前状态设为交战状态
            self.inst.sg.mem.wantstoalert = nil--把想要触发警告的状态取消
            return "screech"
        end
    else--当前没有攻击目标
        self._lastdisengaged = GetTime()--将停战时间设为当前时间
		--如果处于交战状态并且停战时间和交战时间差超过5秒，则将当前状态设为停战状态
        if self._engaged and self._lastdisengaged - self._lastengaged > 5 then
            self._engaged = false
        end
    end
	--处于想发出警告的状态(蜂后解除冰冻和睡醒后会处于这种状态)
    if self.inst.sg.mem.wantstoalert then
        self.inst.sg.mem.wantstoalert = nil
		--此时如果有士兵处于睡着或者冰冻状态，则立刻发出尖叫
        return self.inst.components.commander:IsAnySoldierNotAlert()
            and "screech"
            or nil
    end
end
--尝试生成士兵(当前不处于产兵CD中，并且士兵数量小于阈值(如果蜂后没目标则这里的阈值默认为1)，则生成士兵)
local function TrySpawnGuards(inst)
	return not inst.components.timer:TimerExists("spawnguards_cd")
        and inst.components.commander:GetNumSoldiers() < (inst.components.combat:HasTarget() and inst.spawnguards_threshold or 1)
        and "spawnguards"
        or nil
end
--尝试集中攻击目标
local function TryFocusTarget(inst)
    return inst.focustarget_cd > 0--集火CD大于0(等于0的时候不能集火)
        and inst.components.combat:HasTarget()--当前有攻击目标
        and inst.components.commander:GetNumSoldiers() >= TUNING_MEDAL.MEDAL_BEEQUEEN_MIN_GUARDS_PER_SPAWN--士兵数量>=单次士兵最小生成数量
        and not inst.components.timer:TimerExists("focustarget_cd")--不处于集火CD中
        and "focustarget"
        or nil
end
--是否触发特殊动作
local function ShouldUseSpecialMove(self)
	if self.inst.UpdateState then
		self.inst:UpdateState()--更新自身状态
	end
	--尝试尖叫、生成士兵、集火目标
	self._act = TryScreech(self) or TrySpawnGuards(self.inst) or TryFocusTarget(self.inst)
    --如果有特殊动作，则返回true，并且停止追击
	if self._act ~= nil then
        self._shouldchase = false
        return true
    end
    return false
end
--是否进行追击
local function ShouldChase(self)
    local target = self.inst.components.combat.target--获取攻击目标
    --如果处于无集火状态(集火CD为0不能集火)
	if self.inst.focustarget_cd <= 0 then
        return not (self.inst.components.combat:InCooldown() and--不处于(攻击冷却完毕并且目标在攻击范围内)的状态则追击
                    target ~= nil and
                    target:IsValid() and
                    target:IsNear(self.inst, TUNING.BEEQUEEN_ATTACK_RANGE + target:GetPhysicsRadius(0)))
    --若无目标或者目标已失效，则取消追击状态
	elseif target == nil or not target:IsValid() then
        self._shouldchase = false
        return false
    end
    local distsq = self.inst:GetDistanceSqToInst(target)--获取蜂后与目标间的距离(这里是取sq,也就是距离的平方,因为没必要开方)
    --(ps:这里的TUNING变量感觉和下面的写反了,正常逻辑来说应该是超出攻击范围则追击；否则不追击；超出追击范围不追击才对)
	-- local range = TUNING.BEEQUEEN_CHASE_TO_RANGE + (self._shouldchase and 0 or 3)--追击范围=追击距离+(处于追击状态 and 0 or 3)
	local range = TUNING.BEEQUEEN_ATTACK_RANGE + (self._shouldchase and 0 or 3)--追击范围=攻击距离+(处于追击状态 and 0 or 3)(修正版)
    self._shouldchase = distsq >= range * range--如果离目标的距离超过追击范围，则追击
    if self._shouldchase then
        return true
    --不在追击状态并且攻击已经冷却完毕了，则取消追击
	elseif self.inst.components.combat:InCooldown() then
        return false
    end
    -- range = TUNING.BEEQUEEN_ATTACK_RANGE + target:GetPhysicsRadius(0) + 1--追击范围=攻击距离+1
    range = TUNING.BEEQUEEN_CHASE_TO_RANGE + target:GetPhysicsRadius(0) + 1--追击范围=追击距离+1(修正版)
    return distsq <= range * range--如果离目标的距离小于攻击范围，则追击
end
--计算闪避时间倍率(蜂后的攻击距离内有两个及以上玩家，则返回0.5，否则返回1)
local function CalcDodgeMult(self)
    local found = false
    for k, v in pairs(self.inst.components.grouptargeter:GetTargets()) do
        if self.inst:IsNear(k, TUNING.BEEQUEEN_ATTACK_RANGE + k:GetPhysicsRadius(0)) then
            if found then
                return .5
            end
            found = true
        end
    end
    return 1
end
--是否闪避
local function ShouldDodge(self)
    --闪避目标点不为空，则进行闪避
	if self._dodgedest ~= nil then
        return true
    end
    local t = GetTime()
    if self.inst.sg.mem.wantstododge then
        --Override dodge timer once
        self.inst.sg.mem.wantstododge = nil
    --最近攻击时间+闪避延迟时间<当前时间，则取消闪避
	elseif self.inst.components.combat:GetLastAttackedTime() + DODGE_DELAY < t then
        --Reset dodge timer
        self._dodgetime = nil
        return false
    --闪避时间为nil,则将当前时间设为闪避时间，但不进行闪避
	elseif self._dodgetime == nil then
        --Start dodge timer
        self._dodgetime = t
        return false
    --最近闪避时间+闪避延迟时间*闪避时间倍率(攻击距离内有超过1个玩家，则cd减半)>=当前时间,则不闪避，等待闪避cd结束
	elseif self._dodgetime + DODGE_DELAY * CalcDodgeMult(self) >= t then
        --Wait dodge timer
        return false
    end
    --寻找新的闪避目标点
    local homepos = GetHomePos(self.inst)--出生点坐标
    local pos = self.inst:GetPosition()--获取蜂后坐标
    local dangerrangesq = TUNING.BEEQUEEN_CHASE_TO_RANGE * TUNING.BEEQUEEN_CHASE_TO_RANGE--危险范围=蜂后的追击距离(这边为了方便计算都用平方来算)
    local maxrangesq = TUNING.BEEQUEEN_DEAGGRO_DIST * TUNING.BEEQUEEN_DEAGGRO_DIST--最大旋转范围(60,超过了就相当于离出生点太远了)
    local mindanger = math.huge--最小危险系数(初始为无限大)
    local bestdest = Vector3()--最佳坐标点
    local tests = {}--侦测坐标点数组
    for i = 2, 6 do
        table.insert(tests, { rsq = i * i })
    end
    for i = 10, 20, 5 do
        local r = i + math.random() * 5--随机半径
        local theta = 2 * PI * math.random()--随机角度
        local dtheta = PI * .25--旋转角度，45度
        --尝试8次
		for attempt = 1, 8 do
            -- local offset = FindWalkableOffset(pos, theta, r, 1, true, true)--坐标偏移值(看对应角度、半径的坐标点能不能通行(无视墙))
            local offset = FindWalkableOffset(pos, theta, r, 1, true, true, nil, true, true)--坐标偏移值(看对应角度、半径的坐标点能不能通行(无视墙))
            if offset ~= nil then
                local x, z = offset.x + pos.x, offset.z + pos.z--目标坐标点
                --确保目标距离在出生点60范围内
				if distsq(homepos.x, homepos.z, x, z) < maxrangesq then
                    local nx, nz = offset.x / r, offset.z / r--把偏移值按照半径n等分，最小单位为1(比如半径为12，那就是12等分)
                    --再将n等分后的偏移值进行2等分，将最近的前5个点加入侦测坐标点数组中
					for j, test in ipairs(tests) do
                        test.x = nx * (j - .5) + pos.x
                        test.z = nz * (j - .5) + pos.z
                    end
                    local danger = 0--危险系数
                    --遍历当前世界所有玩家
					for _, v in ipairs(AllPlayers) do
                        --确保玩家不是鬼并且是可见的
						if not v:HasTag("playerghost") and v.entity:IsVisible() then
                            local vx, vy, vz = v.Transform:GetWorldPosition()--获取玩家坐标
                            --如果玩家和蜂后的距离在危险范围内，则危险系数+1
							if distsq(vx, vz, x, z) < dangerrangesq then
                                danger = danger + 1
                            end
							--遍历侦测坐标点数组，玩家和坐标点距离小于对应范围，则危险系数+1
                            for j, test in ipairs(tests) do
                                if distsq(vx, vz, test.x, test.z) < test.rsq then
                                    danger = danger + 1
                                end
                            end
                        end
                    end
					--如果危险系数低于当前最小危险系数(简单来说就是找一个危险系数最低的坐标点作为最终目标点)
                    if danger < mindanger then
                        mindanger = danger--最小危险系数重新赋值
                        bestdest.x, bestdest.z = x, z--将当前目标坐标点设为最佳坐标点
                        --危险系数为0的话直接返回了，已经是最安全的了
						if danger <= 0 then
                            break
                        end
                    end
                end
            end
            theta = theta + dtheta--转45度继续尝试
        end
		--最小危险系数为0直接返回，已经是最安全的了
        if mindanger <= 0 then
            break
        end
    end
	--最小危险系数不为无穷大，则说明找到安全闪避点了
    if mindanger < math.huge then
        self._dodgedest = bestdest--闪避坐标点=最佳坐标点
        self._dodgetime = nil
        self.inst.components.locomotor.walkspeed = TUNING_MEDAL.MEDAL_BEEQUEEN_DODGE_SPEED--将移速设置为闪避速度
        self.inst.hit_recovery = TUNING_MEDAL.MEDAL_BEEQUEEN_DODGE_HIT_RECOVERY--延长攻击冷却时间
        self.inst.sg.mem.last_hit_time = t--把最近攻击时间标记为当前时间
        return true
    end
    --Reset dodge timer to retry in half the time
    self._dodgetime = t - DODGE_DELAY * .5
    return false
end
--停止闪避
function MedalBeeQueenBrain:OnStop()
    self._dodgedest = nil--移除闪避坐标点
    self.inst.components.locomotor.walkspeed = TUNING_MEDAL.MEDAL_BEEQUEEN_SPEED--移速重置
    self.inst.hit_recovery = TUNING_MEDAL.MEDAL_BEEQUEEN_HIT_RECOVERY--攻击冷却时间重置
end

function MedalBeeQueenBrain:OnStart()
    local root = PriorityNode(
    {
        --尝试闪避
		WhileNode(function() return ShouldDodge(self) end, "Dodge",
            SequenceNode{
                ParallelNodeAny{
                    WaitNode(MAX_DODGE_TIME),--等待3秒后直接返回(停止闪避)
                    NotDecorator(FailIfSuccessDecorator(
                        Leash(self.inst, function() return self._dodgedest end, 2, 2))),--"狗链"，把蜂后拴在出生点附近
                },
                ActionNode(function() self:OnStop() end),--停止闪避
            }),
        --尝试做特殊动作(尖叫、产崽、集火)
		WhileNode(function() return ShouldUseSpecialMove(self) end, "SpecialMoves",
            ActionNode(function() self.inst:PushEvent(self._act) end)),
        --尝试追击
		WhileNode(function() return ShouldChase(self) end, "Chase",
            ChaseAndAttack(self.inst)),
        FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
        ParallelNode{
            SequenceNode{
                WaitNode(FLEE_DELAY),
                ActionNode(function() self.inst:PushEvent("flee") end),
            },
            Wander(self.inst, GetHomePos, 5),
        },
    }, .5)

    self.bt = BT(self.inst, root)
end

function MedalBeeQueenBrain:OnInitializationComplete()
    local pos = self.inst:GetPosition()
    pos.y = 0
    self.inst.components.knownlocations:RememberLocation("spawnpoint", pos, true)
end

return MedalBeeQueenBrain
