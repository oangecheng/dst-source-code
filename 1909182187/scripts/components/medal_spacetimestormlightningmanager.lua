local function SpawnLightning(inst,x,y,z)
	local spark = SpawnPrefab("moonstorm_ground_lightning_fx")
	spark.Transform:SetRotation(math.random()*360)
	spark.Transform:SetPosition(x,y,z)
end

local function checkground(inst, map, x, y, z)
	if TheWorld.Map:IsVisualGroundAtPoint(x, y, z) then
		local node_index = map:GetNodeIdAtPoint(x, 0, z)
		local nodes = TheWorld.net.components.medal_spacetimestorms._spacetimestorm_nodes:value()
		for i, node in pairs(nodes) do
			if node == node_index  then
				return true
			end
		end
	end
end

local Medal_SpacetimestormLightningManager = Class(function(self, inst)
	self.inst = inst
	--电流数据
	self.spark = {per_sec = 5, spawn_rate = 0, checkfn = checkground, spawnfn = SpawnLightning}

	self.sparks_per_sec = 1
	self.sparks_idle_time = 5

	self.sparks_per_sec_mod = 1.0
	--监听时空风暴节点的变化
	self.inst:ListenForEvent("spacetimestorm_nodes_dirty_relay", function(w,data)
		if TheWorld.net.components.medal_spacetimestorms._spacetimestorm_nodes:value() then
			self.inst:StartUpdatingComponent(self)--风暴存在则刷帧更新组件
		else
			self.inst:StopUpdatingComponent(self)--风暴消失则停止更新组件
		end
	end, TheWorld)
end)
--计算可视半径
local function calcVisibleRadius()
	local percent = (math.clamp(TheCamera:GetDistance(), 30, 100) - 30) / (70)
	local radius = (75 - 30) * percent + 30
	return radius
end
--计算每秒倍率
local function calcPerSecMult(min, max)
	local percent = (math.clamp(TheCamera:GetDistance(), 30, 100) - 30) / (70)
	local mult = (1.5 - 1) * percent + 1
	return mult
end

function Medal_SpacetimestormLightningManager:OnUpdate(dt)

	if ThePlayer == nil then return end


	local map = TheWorld.Map
	if map == nil then return end

	local px, py, pz = ThePlayer.Transform:GetWorldPosition()
	local mult = calcPerSecMult()

	local radius = calcVisibleRadius()

	self.spark.spawn_rate = self.spark.spawn_rate + self.spark.per_sec * self.sparks_per_sec_mod * mult * dt
	while self.spark.spawn_rate > 1.0 do
		local dx, dz = radius * UnitRand(), radius * UnitRand()
		local x, y, z = px + dx, py, pz + dz
		if self.spark.checkfn(self, map, x, y, z) then
			self.spark.spawnfn(self, x, y, z)
		end
		self.spark.spawn_rate = self.spark.spawn_rate - 1.0
	end

	if self.sparks_per_sec_mod <= 0.0 then
		self.inst:StopUpdatingComponent(self)
	end
end

return Medal_SpacetimestormLightningManager
