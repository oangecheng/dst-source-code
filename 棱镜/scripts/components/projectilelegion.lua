local ProjectileLegion = Class(function(self, inst)
    self.inst = inst
	self.shootrange = nil --最远抛射距离
	self.isgoback = nil --是否为返回玩家
	self.bulletradius = 1.2 --子弹半径(影响击中的最小距离)
	self.speed = 20 --抛射速度
	self.stimuli = nil
	self.hittargets = {} --把已经被攻击过的对象记下来，防止重复攻击
	self.exclude_tags = { "INLIMBO", "NOCLICK", "wall", "structure" }
	if not TheNet:GetPVPEnabled() then
		table.insert(self.exclude_tags, "player")
		table.insert(self.exclude_tags, "abigail")
	end

	self.onthrown = nil
	self.onprehit = nil
    self.onhit = nil
    self.onmiss = nil
end)

function ProjectileLegion:RotateToTarget(dest, angle)
	if angle == nil then
		local direction = (dest - self.inst:GetPosition()):GetNormalized()
    	angle = math.acos(direction:Dot(Vector3(1, 0, 0))) / DEGREES
	end
    self.inst.Transform:SetRotation(angle)
    self.inst:FacePoint(dest)
end

local function PositionFix(pos)
	return Vector3(pos.x, 0, pos.z)
end

function ProjectileLegion:Throw(owner, targetpos, attacker, angle)
	self.owner = owner --由武器产生的投射物，或者本身就是个远程投射物
	self.attacker = attacker --真正发起攻击的对象
	self.start = owner:GetPosition()

	if self.isgoback then --StartUpdatingComponent会在下一帧执行，但是很可能在这一帧就飞远了
		self.dest = PositionFix(targetpos)
		if distsq(self.dest, self.start) <= (self.bulletradius*self.bulletradius + 0.8) then
			self:Miss()
			return
		end
	else
		self.dest = targetpos
	end

	if attacker ~= nil and self.launchoffset ~= nil then
		local x, y, z = self.inst.Transform:GetWorldPosition()
		local facing_angle = attacker.Transform:GetRotation() * DEGREES
		self.inst.Transform:SetPosition(x + self.launchoffset.x * math.cos(facing_angle), y + self.launchoffset.y, z - self.launchoffset.x * math.sin(facing_angle))
	end

	self.hittargets = {}
	self.inst.Physics:ClearCollidesWith(COLLISION.LIMITS)
	self:RotateToTarget(self.dest, angle)
	self.inst.Physics:SetMotorVel(self.speed, 0, 0)
	self.inst:StartUpdatingComponent(self)
	self.inst:PushEvent("onthrown", { thrower = attacker, dest = targetpos })
	if self.onthrown ~= nil then
		self.onthrown(self.inst, owner, targetpos, attacker)
	end
end

function ProjectileLegion:Stop()
	self.inst.Physics:Stop()
	self.inst.Physics:CollidesWith(COLLISION.LIMITS)
    self.inst:StopUpdatingComponent(self)
	self.attacker = nil
    self.owner = nil
	self.dest = nil
	self.start = nil
	self.hittargets = {}
end

function ProjectileLegion:Miss()
    if self.onmiss ~= nil then
        self.onmiss(self.inst, self.dest, self.attacker)
    end
	self:Stop()
end

function ProjectileLegion:Hit(target)
	-- self.inst.Physics:Stop()

	if self.onprehit ~= nil then
        self.onprehit(self.inst, self.dest, self.attacker, target)
    end
    if self.attacker ~= nil and self.attacker.components.combat ~= nil then
		local weapon = self.inst.components.weapon ~= nil and self.inst or nil
		if self.attacker.components.combat.ignorehitrange then
	        self.attacker.components.combat:DoAttack(target, weapon, self.inst, self.stimuli)
		else
			self.attacker.components.combat.ignorehitrange = true
			self.attacker.components.combat:DoAttack(target, weapon, self.inst, self.stimuli)
			self.attacker.components.combat.ignorehitrange = false
		end
    end
    if self.onhit ~= nil then
        self.onhit(self.inst, self.dest, self.attacker, target)
    end

	-- self:Stop()
end

function ProjectileLegion:OnEntitySleep()
	if self.inst:IsValid() then
		self:Miss()
	end
end
-- function ProjectileLegion:OnEntityWake()end

function ProjectileLegion:OnUpdate(dt)
	local current = self.inst:GetPosition()

	local x, y, z = current:Get()

	--检测目前所在地皮，如果进入虚空领地，就直接停止
	if
		not self.isgoback and --防止飞回来时被卡住
		not TheWorld.Map:IsAboveGroundAtPoint(x, 0, z) and
		not TheWorld.Map:IsOceanTileAtPoint(x, 0, z)
	then
		self:Miss()
		return
	end

	local ents = TheSim:FindEntities(x, y, z, 7, { "_combat" }, self.exclude_tags)
	for _,ent in ipairs(ents) do
		if
			ent ~= self.attacker and not self.hittargets[ent] and ent.entity:IsVisible() and --有效
			ent.components.health ~= nil and not ent.components.health:IsDead() and --还活着
			( --sg非无敌状态
				ent.sg == nil or
				not (ent.sg:HasStateTag("flight") or ent.sg:HasStateTag("invisible"))
			) and
			(self.bulletradius+ent:GetPhysicsRadius(0))^2 >= distsq(current, ent:GetPosition()) and --范围内
			(
				(ent.components.combat ~= nil and ent.components.combat.target == self.attacker) or
				(
					(ent.components.domesticatable == nil or not ent.components.domesticatable:IsDomesticated()) and
					(self.attacker.components.leader == nil or not self.attacker.components.leader:IsFollower(ent))
				)
			)
		then
			self:Hit(ent)
			if not self.inst:IsValid() then
				return
			end
			self.hittargets[ent] = true
		end
	end

	if not self.inst:IsValid() then
		return
	end
	if self.isgoback then
		if distsq(self.dest, current) <= (self.bulletradius*self.bulletradius + 0.8) then
			self:Miss()
		end
	elseif self.shootrange ~= nil and distsq(self.start, current) >= self.shootrange*self.shootrange then
		self:Miss()
	end
end

local function OnShow(inst, self)
    self.delaytask = nil
    inst:Show()
end
function ProjectileLegion:DelayVisibility(duration)
    if self.delaytask ~= nil then
        self.delaytask:Cancel()
    end
    self.inst:Hide()
    self.delaytask = self.inst:DoTaskInTime(duration or FRAMES, OnShow, self)
end

return ProjectileLegion
