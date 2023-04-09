--------------------------------------------------------------------------
--[[ moon storm manager class definition ]]
--------------------------------------------------------------------------

return Class(function(self, inst)

assert(TheWorld.ismastersim, "客机不应该有这个组件")

--------------------------------------------------------------------------
--[[ Dependencies ]]
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--[[ Constants ]]
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--[[ Member variables ]]
--------------------------------------------------------------------------

--Public
self.inst = inst
self.metplayers = {}

--Private
-- local _alterguardian_defeated_count = 0--天体守卫死亡记数

local _activeplayers = {}--玩家登记表
local _currentbasenodeindex = nil--当前的初始节点索引
local _currentnodes = nil--当前的节点列表

-- local _moonstyle_altar = nil--天体祭坛

local _numspacetimestormpropagationsteps = 3--时空风暴传播尝试次数

local _basenodemindistancefromprevious = 50--新风暴的基础节点和上一个风暴的最小距离

--------------------------------------------------------------------------
--[[ Private member functions ]]
--------------------------------------------------------------------------
--获取闪电生成的时间(10~40秒)
local function getlightningtime()
	return math.random()*30+10
end

local MIN_NODES = 4--最小节点数
local MAX_NODES = 8--最大节点数

local BIRDBLOCKER_TAGS = {"birdblocker"}
--常规检查函数
local function customcheckfn(pt)
	--坐标点处于时空风暴中
	return TheWorld.Map:IsPassableAtPoint(pt.x, 0, pt.z) and TheWorld.net.components.medal_spacetimestorms ~= nil and TheWorld.net.components.medal_spacetimestorms:IsPointInSpacetimestorm(pt)
end

--节点可生成时空风暴
local function NodeCanHaveSpacetimestorm(node)
	return node ~= nil
		and (not self.lastnodes or not table.contains(self.lastnodes, node.area))--不存在上一次风暴节点 或者 目标节点不在上一次风暴的节点中
		and not table.contains(node.tags, "lunacyarea")--并且目标节点不能是月岛环境
		and not table.contains(node.tags, "sandstorm")--并且目标节点不能和沙尘暴重叠
		and not TheWorld.Map:IsOceanAtPoint(node.cent[1], 0, node.cent[2])--并且目标节点的中心不能在海洋上
		and not (TheWorld.net.components.moonstorms and TheWorld.net.components.moonstorms:IsPointInMoonstorm(Vector3(node.cent[1], 0, node.cent[2])))--目标节点不能和月亮风暴重叠
end
--------------------------------------------------------------------------
--[[ Private event handlers ]]
--------------------------------------------------------------------------
--玩家加入游戏
local function OnPlayerJoined(src, player)
	--玩家没在登记表内的话，就进行登记
	for i, v in ipairs(_activeplayers) do
        if v == player then
            return
        end
    end
    table.insert(_activeplayers, player)
	--如果时空风暴的节点不为空，就同步玩家在时空风暴中的移速
	if TheWorld.net.components.medal_spacetimestorms and next(TheWorld.net.components.medal_spacetimestorms._spacetimestorm_nodes:value()) ~= nil then
		player.components.medal_spacetimestormwatcher:ToggleSpacetimestorms({setting=true})
	end
end
--玩家离开游戏
local function OnPlayerLeft(src, player)
    for i, v in ipairs(_activeplayers) do
        if v == player then
            table.remove(_activeplayers, i)--从玩家登记表中移除
            return
        end
    end
end
--开始时空风暴
local function StartTheSpacetimestorms()
    self:StartSpacetimestorm()
end
--停止时空风暴
local function StopTheSpacetimestorms()
	self:StopCurrentSpacetimestorm()--停止当前的时空风暴
end
--天数变更
local function on_day_change()
	local lostplayers = self:GetLostPlayer()
	if #lostplayers > 0 then return end--有玩家在风暴里,就先不考虑转移了
	if TheWorld.net.components.medal_spacetimestorms and next(TheWorld.net.components.medal_spacetimestorms:GetSpacetimestormNodes()) then
		self.stormdays = self.stormdays + 1--风暴天数+1
		if self.stormdays >= TUNING.MOONSTORM_MOVE_TIME then--风暴天数超过风暴转移天数(4天),就可以准备转移了
			--这里理解成第4天10%概率,第5天55%,第6天100%即可
			if math.random() < Remap(self.stormdays, TUNING.MOONSTORM_MOVE_TIME, TUNING.MOONSTORM_MOVE_MAX,0.1,1) then
				-- self:StopCurrentSpacetimestorm(true)--停止当前的时空风暴
				--新的风暴已经出现，怎么能够停滞不前
				self.startstormtask = inst:DoTaskInTime(0,function() self:StartSpacetimestorm() end)
			end
		end
	end
end
--------------------------------------------------------------------------
--[[ Initialization ]]
--------------------------------------------------------------------------

--Initialize variables
--初始化的时候就把所有玩家存入登记表
for i, v in ipairs(AllPlayers) do
    table.insert(_activeplayers, v)
end
inst:ListenForEvent("ms_playerjoined", OnPlayerJoined)--监听玩家加入游戏
--Register events

inst:ListenForEvent("ms_playerleft", OnPlayerLeft)--监听玩家离开游戏
inst:ListenForEvent("ms_startthemedal_spacetimestorms", StartTheSpacetimestorms)
inst:ListenForEvent("ms_stopthemedal_spacetimestorms", StopTheSpacetimestorms)
-- inst:WatchWorldState("cycles", on_day_change)--监听天数变更


inst.spacetimestormwindowovertask = inst:DoTaskInTime(0,function()  TheWorld:PushEvent("ms_spacetimestormwindowover") end)
--------------------------------------------------------------------------
--[[ Public getters and setters ]]
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--[[ Public member functions ]]
--------------------------------------------------------------------------


-- STORM FUNCTIONS
--计算新的时空风暴的基础节点索引位置
function self:CalcNewSpacetimestormBaseNodeIndex()
	local num_nodes = #TheWorld.topology.nodes--统计当前世界的所有节点数量
	local index_offset = math.random(1, num_nodes)--开始遍历的节点(随机从里面挑一个开始往下遍历)
	local mindistsq = _basenodemindistancefromprevious * _basenodemindistancefromprevious--和上一个风暴的最小距离

	for i = 1, num_nodes do
		local ind = math.fmod(i + index_offset, num_nodes) + 1--节点索引
		local new_node = TheWorld.topology.nodes[ind]--当前遍历到的节点

		if ind ~= _currentbasenodeindex then--节点索引不能和当前的基础节点相同
			--如果当前有风暴了，那就要考虑不能和原来的风暴太近
			if _currentbasenodeindex ~= nil then
				local current_node = TheWorld.topology.nodes[_currentbasenodeindex]--当前的基础节点
				local new_x, new_z = new_node.cent[1], new_node.cent[2]
				local current_x, current_z = current_node.cent[1], current_node.cent[2]
				
				if NodeCanHaveSpacetimestorm(new_node) and VecUtil_LengthSq(new_x - current_x, new_z - current_z) > mindistsq then
					return ind
				end
			--当前没风暴，但是以前有过，那也不能和以前的风暴太近
			elseif self.lastbasenodeindex ~= nil then
				local current_node = TheWorld.topology.nodes[self.lastbasenodeindex]--当前的基础节点
				local new_x, new_z = new_node.cent[1], new_node.cent[2]
				local current_x, current_z = current_node.cent[1], current_node.cent[2]
				
				if NodeCanHaveSpacetimestorm(new_node) and VecUtil_LengthSq(new_x - current_x, new_z - current_z) > mindistsq then
					return ind
				end
			else--否则只要确保能生成就完事了
				if NodeCanHaveSpacetimestorm(new_node) then
					return ind
				end
			end
		end
	end

	print("SpacetimestormManager failed to find a valid spacetimestorm base node")
end
--开始时空风暴(初始节点索引,节点列表)
function self:StartSpacetimestorm(set_first_node_index,nodes)
	local unaffectedplayers = self:GetUnaffectedPlayer()--没被时空风暴影响到的玩家
	self:StopCurrentSpacetimestorm(true)--停止当前的时空风暴
	--移除延时任务
	if self.startstormtask then
		self.startstormtask:Cancel()
		self.startstormtask = nil
	end
	--时空风暴组件不存在，return掉
	if not TheWorld.net or not TheWorld.net.components.medal_spacetimestorms == nil then
		print("medal_spacetimestorms组件不存在")
		return
	end

	local checked_nodes = {}--检查过的节点
	local new_storm_nodes = nodes or {}--新的风暴节点
	local first_node_index = set_first_node_index or nil--初始节点索引

	--传播风暴(节点)
	local function propagatestorm(node, steps, nodelist)
		--确保节点可生成风暴
		if not checked_nodes[node] and NodeCanHaveSpacetimestorm(TheWorld.topology.nodes[node]) then
			checked_nodes[node] = true--给节点标记下免得重复检查了

			table.insert(nodelist, node)--把符合条件的节点插入新的风暴节点列表

			local node_edges = TheWorld.topology.nodes[node].validedges--节点边界
			-- print("		adding node:", node, "		steps remaining:", steps)

			-- print("iterating", #node_edges, "node edges")
			for _, edge_index in ipairs(node_edges) do
				local edge_nodes = TheWorld.topology.edgeToNodes[edge_index]
				local other_node_index = edge_nodes[1] ~= node and edge_nodes[1] or edge_nodes[2]

				if steps > 0 and #nodelist < MAX_NODES then
					propagatestorm(other_node_index, steps - 1, nodelist)
				end
			end
		else
			return
		end
	end
	local trial = 1--试用标记
	--没有新的风暴节点或者新的风暴节点数量小于最小节点数,就继续传播风暴
	if not new_storm_nodes or #new_storm_nodes < MIN_NODES then
		--如果已经有初始节点了，先尝试用初始节点生成
		if set_first_node_index and set_first_node_index ~= self.lastbasenodeindex then
			propagatestorm(first_node_index, _numspacetimestormpropagationsteps, new_storm_nodes)
			trial = trial + 1
		end
		--风暴节点数量不够,那就尝试在玩家附近生成
		if #new_storm_nodes < MIN_NODES and #unaffectedplayers>0 then
			for _, player in ipairs(unaffectedplayers) do
				if trial>1 then print("没生成足够数量的节点，第"..trial.."次尝试") end
				trial = trial + 1
				new_storm_nodes = {}
				local x,y,z = player.Transform:GetWorldPosition()
				first_node_index = TheWorld.Map:GetNodeIdAtPoint(x, y, z)
				if first_node_index and first_node_index ~= self.lastbasenodeindex then
					propagatestorm(first_node_index, _numspacetimestormpropagationsteps, new_storm_nodes)
				end
			end
		end
		--风暴节点数量不够就一直尝试，直到成功生成为止
		while #new_storm_nodes < MIN_NODES do
			if trial>1 then print("没生成足够数量的节点，第"..trial.."次尝试") end
			trial = trial + 1
			new_storm_nodes = {}
			first_node_index = self:CalcNewSpacetimestormBaseNodeIndex()--计算获取新的时空风暴的基础节点索引位置
			if first_node_index == nil then
				--初始节点都生成不了了,跑路吧
				print("时空风暴的初始节点生成不了，玩毛线")
				return
			end
			--来吧，传播风暴吧
			propagatestorm(first_node_index, _numspacetimestormpropagationsteps, new_storm_nodes)
		end
	end
	_currentbasenodeindex = first_node_index--记录当前的初始节点索引
	_currentnodes = new_storm_nodes--记录当前的风暴节点列表

	TheWorld.net.components.medal_spacetimestorms:ClearSpacetimestormNodes()--清除原来的时空风暴节点
	TheWorld.net.components.medal_spacetimestorms:AddSpacetimestormNodes(new_storm_nodes, _currentbasenodeindex)--添加新的时空风暴节点

	--记录节点
	self.lastnodes = TheWorld.net.components.medal_spacetimestorms.convertlist(TheWorld.net.components.medal_spacetimestorms:GetSpacetimestormNodes()) or {}
	self.lastbasenodeindex = _currentbasenodeindex

	-- self.spawn_devourer_test_task = self.inst:DoPeriodicTask(10,function() self:DoTestForSpacetimeDevourer() end)--每10秒尝试一次生成时空吞噬者
	self.spacetimestorm_spark_task = self.inst:DoPeriodicTask(20,function() self:DoTestForSparks() end)--每20秒尝试生成一次时空乱流
	self.spacetimestorm_gestalt_task = self.inst:DoPeriodicTask(40,function() self:DoTestForGestalts() end)--每40秒尝试生成一次时空虚影
	self.spacetimestorm_lightning_task = self.inst:DoTaskInTime(getlightningtime(),function() self:DoTestForLightning() end)--每10~40秒来一道闪电(用的延时任务)

	self.stormdays = 0--风暴持续天数清零
	self:DoTestForSpacetimeDevourer()--尝试生成时空吞噬者
	return true
end
--停止当前的时空风暴(是否是迁移状态)
function self:StopCurrentSpacetimestorm(is_relocating)
	--记录一下最后一次时空风暴的节点
	-- self.lastnodes = TheWorld.net.components.medal_spacetimestorms.convertlist(TheWorld.net.components.medal_spacetimestorms:GetSpacetimestormNodes()) or {}
	-- self.lastbasenodeindex = _currentbasenodeindex
	--取消生成时空吞噬者的定时器
	-- if self.spawn_devourer_test_task then
	-- 	self.spawn_devourer_test_task:Cancel()
	-- 	self.spawn_devourer_test_task = nil
	-- end
	--取消生成时空乱流的定时器
	if self.spacetimestorm_spark_task then
		self.spacetimestorm_spark_task:Cancel()
		self.spacetimestorm_spark_task = nil
	end
	--取消生成时空虚影的定时器
	if self.spacetimestorm_gestalt_task then
		self.spacetimestorm_gestalt_task:Cancel()
		self.spacetimestorm_gestalt_task = nil
	end
	--取消闪电定时器
	if self.spacetimestorm_lightning_task then
		self.spacetimestorm_lightning_task:Cancel()
		self.spacetimestorm_lightning_task = nil
	end

	if TheWorld.net.components.medal_spacetimestorms ~= nil then
		-- local is_relocating = self.st_devourer ~= nil--是否是迁移状态(时空吞噬者还在说明只是风暴转移位置了，不是彻底消失了)
		TheWorld.net.components.medal_spacetimestorms:StopSpacetimestorm(is_relocating)
	end
	--清除相关的风暴临时数据
	_currentbasenodeindex = nil
	_currentnodes = nil
	self.MoonStorm_Ending = true--标记时空风暴的结束状态
	if not is_relocating then
		self.st_devourer = nil
	end
end

--寻找比较靠近风暴中心的可通行区域(目前只用来生成时空吞噬者)
function self:FindStormCenterPos()
	local center = TheWorld.net.components.medal_spacetimestorms and TheWorld.net.components.medal_spacetimestorms:GetSpacetimestormCenter()--风暴中心
	local currentpos=center
	local pos=nil
	local min_dist=5--最小距离
	local max_dist=40--最大距离
	local add_dist=5--距离步进
	--优先尝试直接在中心点附近生成，逐渐放大生成范围
	if center then
		-- if customcheckfn(center) then
		-- 	return center
		-- end
		for i = 1, math.ceil((max_dist-min_dist)/add_dist)+1 do
			pos = FindWalkableOffset(center, math.random()*2*PI, min_dist+i*add_dist, 16, true, nil, customcheckfn, nil, nil)
			if pos then
				pos = center + pos
				return pos
			end
		end
	end
end

--移除时空吞噬者
local function onremovedevourer()
	if self.st_devourer then
		self.st_devourer = nil
	end
end

--尝试生成时空吞噬者
function self:DoTestForSpacetimeDevourer()
	local pos = self:FindStormCenterPos()
	if pos then
		-- print(pos.x,pos.y,pos.z)
		if self.st_devourer~=nil then
			-- self.st_devourer.Transform:SetPosition(pos.x,pos.y,pos.z)
			self.st_devourer.worldpos = pos--记录坐标点
		else
			local st_devourer = SpawnPrefab("medal_spacetime_devourer")--生成时空吞噬者
			st_devourer.Transform:SetPosition(pos.x,pos.y,pos.z)
			st_devourer:ListenForEvent("onremove", onremovedevourer)
			self.st_devourer = st_devourer
			-- self.st_devourer.worldpos = pos--记录坐标点
			st_devourer.sg:GoToState("enterworld")
			TheNet:Announce(STRINGS.PROPHESYSPEECH.MEDAL_SPACETIME_DEVOURER)
		end
		--取消生成时空吞噬者的定时器
		-- if self.spawn_devourer_test_task then
		-- 	self.spawn_devourer_test_task:Cancel()
		-- 	self.spawn_devourer_test_task = nil
		-- end
	else--生成不了就转移风暴
		self:StartSpacetimestorm()
	end
end
--获取迷失在时空风暴中的玩家
function self:GetLostPlayer()
	local lostplayers={}--迷失玩家
	for i, v in ipairs(_activeplayers) do
		local pt = Vector3(v.Transform:GetWorldPosition())
		--遍历玩家列表，在风暴里的玩家都是迷路人
		if TheWorld.net.components.medal_spacetimestorms and TheWorld.net.components.medal_spacetimestorms:IsPointInSpacetimestorm(pt) then
			table.insert(lostplayers,v)
		end
	end
	return lostplayers
end
--获取没受到时空风暴影响的玩家
function self:GetUnaffectedPlayer()
	local unaffectedplayers={}--没受到影响的玩家
	for i, v in ipairs(_activeplayers) do
		local pt = Vector3(v.Transform:GetWorldPosition())
		--遍历玩家列表，在风暴里的玩家都是迷路人
		if not (TheWorld.net.components.medal_spacetimestorms and TheWorld.net.components.medal_spacetimestorms:IsPointInSpacetimestorm(pt)) then
			table.insert(unaffectedplayers,v)
		end
	end
	return unaffectedplayers
end

local SPACETIME_SPARKS_MUST_HAVE= {"medal_spacetime_spark"}
local SPACETIME_SPARKS_CANT_HAVE= {"INLIMBO"}
--尝试生成时空乱流
function self:DoTestForSparks()
	local candidates = self:GetLostPlayer()--候选人列表
	if #candidates > 0 and self.st_devourer then
		for _, player in ipairs(candidates) do
			--只能在时空吞噬者附近才会生成哦
			if player:IsNear(self.st_devourer, TUNING_MEDAL.MEDAL_SPACETIME_SPARK_SPAWN_RANGE) then
				local pt = Vector3(player.Transform:GetWorldPosition())
				local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 30, SPACETIME_SPARKS_MUST_HAVE,SPACETIME_SPARKS_CANT_HAVE)
				--30范围内的时空乱流数量不能超过5个
				if #ents < 5 then
					--玩家附近5~25的范围内随机生成时空乱流
					local pos = FindWalkableOffset(pt, math.random()*2*PI, 5 + math.random()* 20, 16, nil, nil, customcheckfn, nil, nil)
					if pos then
						local spark = SpawnPrefab("medal_spacetime_spark")
						spark.Transform:SetPosition(pt.x + pos.x,0,pt.z + pos.z)
					end
				end
			end
		end
	end
end
--时空虚影重生点
function self:FindRelocatePoint()
	local candidates = self:GetLostPlayer()--候选人列表
	if #candidates > 0 then
		local candidate = candidates[math.random(1,#candidates)]--随机挑选一位幸运儿,lucky dog!
		local pt = Vector3(candidate.Transform:GetWorldPosition())
		local pos = FindWalkableOffset(pt, math.random()*2*PI, 5 + math.random()* 10, 16, nil, nil, customcheckfn, nil, nil)
		if pos then
			return pos+pt
		end
	end
end
--尝试生成时空虚影
function self:DoTestForGestalts()
	local candidates = self:GetLostPlayer()--候选人列表
	if #candidates > 0 then
		for _, player in ipairs(candidates) do
			local pt = Vector3(player.Transform:GetWorldPosition())
			--玩家附近5~25的范围内随机生成时空虚影
			local pos = FindWalkableOffset(pt, math.random()*2*PI, 5 + math.random()* 20, 16, nil, nil, customcheckfn, nil, nil)
			if pos then
				local spark = SpawnPrefab("medal_gestalt")
				spark.Transform:SetPosition(pt.x + pos.x,0,pt.z + pos.z)
			end
		end
	end
end
--尝试生成闪电
function self:DoTestForLightning()
	local candidates = self:GetLostPlayer()--候选人列表
	if #candidates > 0 then
		local candidate = candidates[math.random(1,#candidates)]--随机挑选一位幸运儿,lucky dog!
		local pt = Vector3(candidate.Transform:GetWorldPosition())
		local pos = FindWalkableOffset(pt, math.random()*2*PI, 5 + math.random()* 10, 16, nil, nil, customcheckfn, nil, nil)
		if pos then--在他边上5~15的范围内生成一道时空裂隙
			local spark = SpawnPrefab("medal_spacetime_lightning")
			spark.Transform:SetPosition(pt.x + pos.x,0,pt.z + pos.z)
		end
	end
	--每10~40秒来一道
	self.spacetimestorm_lightning_task = self.inst:DoTaskInTime(getlightningtime(),function() self:DoTestForLightning() end)
end

self.LongUpdate = self.OnUpdate

--------------------------------------------------------------------------
--[[ Save/Load ]]
--------------------------------------------------------------------------
--存储数据
function self:OnSave()
	local data = {}
	data.stormdays = self.stormdays--当前风暴已持续天数
	data.currentbasenodeindex = self.currentbasenodeindextemp or _currentbasenodeindex--当前的风暴基础节点
	data.currentnodes = _currentnodes--当前的风暴节点列表
	data.metplayers = self.metplayers
	data.startstormtask = self.startstormtask and true or nil
	data.lastbasenodeindex = self.lastbasenodeindex--上一次风暴的基础节点
	-- data._alterguardian_defeated_count = _alterguardian_defeated_count--天体守卫死亡计数
	-- data.moonstyle_altar = _moonstyle_altar

	return data
end

function self:OnLoad(data)
	if data ~= nil then
		if data.metplayers then
			self.metplayers = data.metplayers
		end
		if data.stormdays then
			self.stormdays = data.stormdays
		end
		if data.lastbasenodeindex then
			self.lastbasenodeindex = data.lastbasenodeindex
		end

		if data.startstormtask or data.currentbasenodeindex ~= nil then
			if inst.spacetimestormwindowovertask then
				inst.spacetimestormwindowovertask:Cancel()
				inst.spacetimestormwindowovertask = nil
			end
			if data.currentbasenodeindex ~= nil then
				self.currentbasenodeindextemp = data.currentbasenodeindex
				self.inst:DoTaskInTime(1,function()
						self:StartSpacetimestorm(data.currentbasenodeindex, data.currentnodes)
						self.currentbasenodeindextemp = nil
					end)
			else
				self.startstormtask = self.inst:DoTaskInTime(1,function() self:StartSpacetimestorm() end)
			end
		end
	end
end

--------------------------------------------------------------------------
--[[ Debug ]]
--------------------------------------------------------------------------

function self:GetDebugString()

	if true then
		return nil
	end

end

end)

