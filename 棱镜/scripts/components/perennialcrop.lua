local function onflower(self)
    if self.isflower then
        self.inst:AddTag("flower")
    else
        self.inst:RemoveTag("flower")
    end
end

local function onsick(self)
	if self.sickness <= 0 then
		self.inst.AnimState:SetMultColour(1, 1, 1, 1)
	elseif self.sickness >= 0.3 then
		self.inst.AnimState:SetMultColour(0.6, 0.6, 0.6, 1)
	else
		local color = 1 - self.sickness/0.3 * 0.4
		self.inst.AnimState:SetMultColour(color, color, color, 1)
	end
end

local function onrotten(self)
    if self.isrotten then
        self.inst:AddTag("nognatinfest")
    else
        self.inst:RemoveTag("nognatinfest")
    end
end

local PerennialCrop = Class(function(self, inst)
	self.inst = inst

	self.moisture = 0 --当前水量
	self.nutrient = 0 --当前肥量（生长必需）
	self.nutrientgrow = 0 --当前肥量（生长加速）
	self.nutrientsick = 0 --当前肥量（预防疾病）
	self.sickness = 0 --当前病害程度
	self.stage = 1	--当前生长阶段
	self.stagedata = {} --当前阶段的数据
	self.isflower = false --当前阶段是否开花
	self.isrotten = false --当前阶段是否腐烂/枯萎
	self.ishuge = false --是否是巨型成熟
	self.infested = 0 --被骚扰次数
	self.taskgrow = nil
	self.tendable = false --当前阶段是否能被照顾
	self.tended = false --当前阶段是否已经照顾过了
	self.timedata = {
		start = nil, --开始进行生长的时间点
		left = nil, --当暂停生长时，达到下一个阶段的剩余时间
		paused = false, --是否暂停生长
		all = nil, --到下一个阶段的全局时间（包含缩减与增加的时间）
	}
	self.pollinated = 0 --被授粉次数
	self.num_nutrient = 0 --吸收肥料次数
	self.num_moisture = 0 --吸收水分次数
	self.num_tended = 0 --被照顾次数
	self.num_perfect = nil --成熟时结算出的：完美指数（决定果实数量或者是否巨型）
	self.ctls = {}
	self.onctlchange = nil

	self.moisture_max = 8 --最大蓄水量
	self.nutrient_max = 32 --最大蓄肥量（生长必需）
	self.nutrientgrow_max = 32 --最大蓄肥量（生长加速）
	self.nutrientsick_max = 32 --最大蓄肥量（预防疾病）
	self.stage_max = 2 --最大生长阶段
	self.pollinated_max = 6 --被授粉次数大于等于该值就能增加产量
	self.infested_max = 10 --被骚扰次数大于等于该值就会立即进入腐烂/枯萎阶段

	self.weights = nil --重量范围
	self.sounds = {} --音效
	self.cost_moisture = 1 --需水量
	self.cost_nutrient = 2 --需肥类型(这里只需要一个量即可，不需要关注肥料类型)
	self.can_getsick = true --是否能产生病虫害（原创）
	self.stages = nil --该植物生长有几个阶段，每个阶段的动画,以及是否处在花期（原创）
	self.stages_other = nil --巨大化阶段、巨大化枯萎、枯萎等阶段的数据
	self.regrowstage = 1 --枯萎或者采摘后重新开始生长的阶段（原创）
	self.eternalstage = nil --长到这个阶段后，就不再往下生长（原创）
	self.goodseasons = {} --喜好季节：{autumn = true, winter = true, spring = true, summer = true}
	self.killjoystolerance = 0 --扫兴容忍度：一般都为0
	self.fn_stage = nil --每次设定生长阶段时额外触发的函数：fn(inst, isfull)
	self.fn_defend = nil --作物被采集/破坏时会寻求庇护的函数：fn(inst, target)
end,
nil,
{
    isflower = onflower,
	sickness = onsick,
	isrotten = onrotten,
})

local function TriggerNutrient(self)
	if self.nutrient >= self.nutrient_max then
		self.inst:RemoveTag("fertable3")
	else
		self.inst:AddTag("fertable3")
	end

	if self.nutrientgrow >= self.nutrientgrow_max then
		self.inst:RemoveTag("fertable1")
	else
		self.inst:AddTag("fertable1")
	end

	if self.nutrientsick >= self.nutrientsick_max then
		self.inst:RemoveTag("fertable2")
	else
		self.inst:AddTag("fertable2")
	end
end
local function TriggerMoisture(self)
	if self.moisture >= self.moisture_max then
		if self.inst:HasTag("needwater") then
			self.inst:RemoveTag("needwater")
		end
	else
		if not self.inst:HasTag("needwater") then
			self.inst:AddTag("needwater")
		end
	end
end
local function GetDetailString(self, doer, type)
	local titles = CONFIGS_LEGION.LANGUAGES == "chinese" and {
		nutrients = "肥力",
		moisture = "水分",
		sickness = "疾病",
		num_tended = "照料",
		pollinated = "授粉",
	} or {
		nutrients = "Nutr ",
		moisture = "Mois ",
		sickness = "Sick ",
		num_tended = "Tend ",
		pollinated = "Pollinat ",
	}

	if type == 2 then
		return titles.nutrients..tostring(self.nutrientgrow).."/"..tostring(self.nutrientsick).."/"..tostring(self.nutrient)
			..", "..titles.moisture..tostring(self.moisture)
			..", "..titles.sickness..tostring(self.sickness)
			..", "..titles.num_tended..tostring(self.num_tended)
			..", "..titles.pollinated..tostring(self.pollinated)
	else
		return titles.nutrients..tostring(self.nutrientgrow).."/"..tostring(self.nutrientsick).."/"..tostring(self.nutrient)
			..", "..titles.moisture..tostring(self.moisture)
	end
end

function PerennialCrop:SetUp(data)
	self.weights = data.weights
	self.sounds = data.sounds or {}
	self.cost_moisture = data.costMoisture or 1
	self.cost_nutrient = data.costNutrient or 2
	self.can_getsick = data.canGetSick
	self.stages = data.stages
	self.stages_other = data.stages_other
	self.regrowstage = data.regrowStage or 1
	self.eternalstage = data.eternalStage
	self.goodseasons = data.goodSeasons or {}
	self.killjoystolerance = data.killjoysTolerance or 0
	self.fn_stage = data.fn_stage

	self.stage_max = #data.stages
end

function PerennialCrop:SetStage(stage, ishuge, isrotten, pushanim, skip)
	if stage == nil or stage < 1 then
		stage = 1
	elseif stage > self.stage_max then
		stage = self.stage_max
	end

	--确定当前的阶段
	local rotten = false
	local huge = false
	local stage_data = nil
	local soundkey = nil
	local tendable = false

	if isrotten then
		if ishuge then
			if self.stages_other.huge_rot ~= nil then --腐烂、巨型状态
				stage = self.stage_max
				stage_data = self.stages_other.huge_rot
				rotten = true
				huge = true
			end
		end

		if stage_data == nil then
			if self.stages_other.rot ~= nil then --腐烂状态
				stage_data = self.stages_other.rot
				rotten = true
			else --如果没有腐烂状态就进入重新生长的阶段
				stage = self.regrowstage
				stage_data = self.stages[stage]
				tendable = true
			end
		end
		soundkey = "grow_rot"
	elseif ishuge then
		stage = self.stage_max
		if self.stages_other.huge ~= nil then --巨型状态
			stage_data = self.stages_other.huge
			huge = true
			soundkey = "grow_oversized"
		else --如果没有巨型状态就进入成熟阶段
			stage_data = self.stages[stage]
			soundkey = "grow_full"
		end
	else
		stage_data = self.stages[stage]
		if stage == self.stage_max then
			soundkey = "grow_full"
		else
			tendable = true
		end
	end

	--修改当前阶段数据
	self.stage = stage
	self.stagedata = stage_data
	self.isflower = stage_data.isflower
	self.isrotten = rotten
	self.ishuge = huge

	if skip then --如果跳过，就不设置接下来的操作
		return
	end

	--设置动画与声音
	if POPULATING or self.inst:IsAsleep() or not pushanim then
		self.inst.AnimState:PlayAnimation(stage_data.anim, true)
		self.inst.AnimState:SetTime(math.random() * self.inst.AnimState:GetCurrentAnimationLength())
	else
		self.inst.AnimState:PlayAnimation(stage_data.anim_grow)
		self.inst.AnimState:PushAnimation(stage_data.anim, true)

		if soundkey ~= nil and self.sounds[soundkey] ~= nil then
			self.inst.SoundEmitter:PlaySound(self.sounds[soundkey])
		end
	end

	--设置是否可采摘
	if rotten or stage == self.stage_max then --腐烂、巨型、成熟阶段都是可采摘的
		if self.inst.components.pickable == nil then
            self.inst:AddComponent("pickable")
        end
		self.inst.components.pickable.onpickedfn = function(inst, doer)
			local crop = inst.components.perennialcrop
			crop:SetStage(crop.regrowstage, false, false, true, false)
			crop:StartGrowing()
			crop.num_nutrient = 0
			crop.num_moisture = 0
			crop.num_tended = 0
			crop.infested = 0
			crop.pollinated = 0
			crop.num_perfect = nil

			if crop.fn_defend ~= nil then
				crop.fn_defend(inst, doer)
			end
		end
	    self.inst.components.pickable:SetUp(nil)
		self.inst.components.pickable.use_lootdropper_for_product = true
		self.inst.components.pickable.picksound = rotten and "dontstarve/wilson/harvest_berries" or "dontstarve/wilson/pickup_plants"
	else
		self.inst:RemoveComponent("pickable")
	end

	--设置是否可照顾
	if self.inst.components.farmplanttendable ~= nil then
		self.inst.components.farmplanttendable:SetTendable(tendable)
	end
	self.tendable = tendable
	self.tended = false

	--额外设置
	if self.fn_stage ~= nil then
		self.fn_stage(self.inst, not self.isrotten and self.stage == self.stage_max) --第二个参数为：是否成熟/巨型成熟
	end

	TriggerNutrient(self)
	TriggerMoisture(self)
end

function PerennialCrop:GetNextStage()
	local data = {
		stage = 1,
		ishuge = false,
		isrotten = false,
		justgrown = false,
		stagedata = nil,
	}

	if self.isrotten then --枯萎阶段->重生阶段
		data.stage = self.regrowstage
		data.stagedata = self.stages[data.stage]
	elseif self.stage == self.eternalstage then --永恒阶段
		data.stage = self.stage
		data.stagedata = self.stages[data.stage]
		data.ishuge = self.ishuge --如果永恒的话，也得维持巨大化吧
	elseif self.stage >= self.stage_max then --成熟阶段->枯萎/巨型枯萎阶段
		if self.ishuge and self.stages_other.huge_rot ~= nil then
			data.stage = self.stage_max
			data.ishuge = true
			data.isrotten = true
			data.stagedata = self.stages_other.huge_rot
		elseif self.stages_other.rot ~= nil then
			data.stage = self.stage_max
			data.isrotten = true
			data.stagedata = self.stages_other.rot
		else --没有枯萎状态的话，只能回到重生阶段了
			data.stage = self.regrowstage
			data.stagedata = self.stages[data.stage]
		end
	else --生长阶段->下一个生长阶段（不管是否成熟）
		data.stage = self.stage + 1
		data.stagedata = self.stages[data.stage]
		data.justgrown = true
	end

	return data
end

function PerennialCrop:GetGrowTime(time)
	if time == nil then
		time = self.stagedata.time or 60
	end

	return time * (
		(TheWorld.state.season == "winter" and 1.4 or 1) --冬季的减速
		- (
			self.stage ~= self.stage_max and ( --没成熟时才应用加速效果
				(self.nutrientgrow > 0 and 1/7 or 0) --肥料的加速
				+ (self.goodseasons[TheWorld.state.season] and 1/7 or 0) --季节的加速
			) or 0
		)
	)
end

local function ComputNutrient(self, nowkey, maxkey, have)
	if self[nowkey] < self[maxkey] and have > 0 then
		have = math.min(have, self[maxkey] - self[nowkey])
		self[nowkey] = self[nowkey] + have
		return -have
	end
	return 0
end
function PerennialCrop:CostFromLand() --从耕地吸取所需养料、水分
	local x, y, z = self.inst.Transform:GetWorldPosition()
	local tile = TheWorld.Map:GetTileAtPoint(x, 0, z)
	if tile == GROUND.FARMING_SOIL then
		local farmmgr = TheWorld.components.farming_manager
		local tile_x, tile_z = TheWorld.Map:GetTileCoordsAtPoint(x, y, z)
    	local _n1, _n2, _n3 = farmmgr:GetTileNutrients(tile_x, tile_z)

		--加水
		if self.moisture < self.moisture_max then
			if farmmgr:IsSoilMoistAtPoint(x, y, z) then
				local n = self.moisture_max - self.moisture
				self:PourWater(nil, nil, n)
				farmmgr:AddSoilMoistureAtPoint(x, y, z, -n)
			end
		end

		_n3 = ComputNutrient(self, "nutrient", "nutrient_max", _n3)
		_n2 = ComputNutrient(self, "nutrientgrow", "nutrientgrow_max", _n2)
		_n1 = ComputNutrient(self, "nutrientsick", "nutrientsick_max", _n1)
		if _n3 < 0 or _n2 < 0 or _n1 < 0 then
			farmmgr:AddTileNutrients(tile_x, tile_z, _n1, _n2, _n3)
			TriggerNutrient(self)
		end
	end
end
function PerennialCrop:DoGrowth(skip)
	local data = self:GetNextStage()

	--如果此时在下雨/雪，蓄水量直接加满
	if TheWorld.state.israining or TheWorld.state.issnowing then
		self:PourWater(nil, nil, self.moisture_max)
	end

	if data.justgrown then
		--因为提前施肥和浇水不产生什么影响，所以种子播种时不需要消耗养料水分，于是逻辑就不需要单独提取出来
		self:CostController() --计算消耗之前，先从管理器拿取资源
		if
			self.moisture < self.moisture_max or
			self.nutrient < self.nutrient_max or
			self.nutrientgrow < self.nutrientgrow_max or
			self.nutrientsick < self.nutrientsick_max
		then --还需要水分或养料，从耕地里汲取
			self:CostFromLand()
		end

		if self.nutrient >= self.cost_nutrient then --生长必需肥料的积累
			self.nutrient = self.nutrient - self.cost_nutrient
			self.num_nutrient = self.num_nutrient + 1
			if self.infested > 0 then
				self.infested = math.max(0, self.infested-3)
			end
		end
		if self.nutrientgrow >= self.cost_nutrient then --加速生长肥料的消耗
			self.nutrientgrow = self.nutrientgrow - self.cost_nutrient
		end
		if self.can_getsick then
			if self.nutrientsick >= self.cost_nutrient then --预防疾病肥料的消耗
				self.nutrientsick = self.nutrientsick - self.cost_nutrient
				if self.sickness > 0 then
					self.sickness = math.max(0, self.sickness-0.06)
				end
			else
				if self.sickness < 1 then
					self.sickness = math.min(1, self.sickness+0.02)
				end
			end
			if self.sickness > 0 and math.random() < (self.sickness/10) then --产生虫群（避免生成太多，这里还需要减少几率）
				local bugs = SpawnPrefab(math.random()<0.7 and "cropgnat" or "cropgnat_infester")
				if bugs ~= nil then
					bugs.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
				end
			end
		elseif self.sickness > 0 then
			self.sickness = 0
		end
		if TheWorld.state.israining or TheWorld.state.issnowing then --如果此时在下雨/雪，积累而不会耗自身水分
			self.num_moisture = self.num_moisture + 1
		elseif self.moisture >= self.cost_moisture then --水分的积累
			self.moisture = self.moisture - self.cost_moisture
			self.num_moisture = self.num_moisture + 1
		end

		if data.stage == self.stage_max then --如果成熟了
			local stagegrow = self.stage_max - self.regrowstage
			local countgrow = self.killjoystolerance

			if self.num_moisture >= stagegrow then --生长必需浇水
				countgrow = countgrow + 1
			end
			if self.num_nutrient >= stagegrow then --生长必需施肥
				countgrow = countgrow + 1
			end
			if self.goodseasons[TheWorld.state.season] then --在喜好的季节
				countgrow = countgrow + 1
			end
			if self.sickness <= 0.1 then --病害程度很低
				countgrow = countgrow + 1
			end
			if self.num_tended >= 1 and self.num_tended >= (stagegrow-1) then --被照顾次数至少得是生长阶段总数的-1次
				countgrow = countgrow + 1
			end

			self.num_perfect = countgrow
			if countgrow >= 5 and self.stages_other.huge ~= nil then --判断是否巨型
				data.ishuge = true
			end

			--结算完成，清空某些数据
			self.num_nutrient = 0
			self.num_moisture = 0
			self.num_tended = 0
		end
	elseif data.stage == self.regrowstage then --重新开始生长时，清空某些数据
		self.infested = 0
		self.pollinated = 0
		self.num_perfect = nil
	end

	if skip then
		self:SetStage(data.stage, data.ishuge, data.isrotten, false, true)
	else
		self:SetStage(data.stage, data.ishuge, data.isrotten, true, false)
		self:StartGrowing()
	end
end

function PerennialCrop:StartGrowing(time)
	self.timedata.start = GetTime()
	self.timedata.paused = false
	self.timedata.left = nil
	self.timedata.all = time or self:GetGrowTime()

	if self.taskgrow ~= nil then
		self.taskgrow:Cancel()
		self.taskgrow = nil
	end
	if not self.inst:IsAsleep() then
		self.taskgrow = self.inst:DoTaskInTime(self.timedata.all, function(inst, self)
			self.taskgrow = nil
			self.timedata.start = nil
			self.timedata.all = nil
			self:DoGrowth(false)
		end, self)
	end
end

function PerennialCrop:LongUpdate(dt, isloop, ismagic)
	if self.timedata.paused then
		return
	end

    if self.timedata.start ~= nil and self.timedata.all ~= nil then
		if dt > self.timedata.all then --经过的时间可以让作物长到下一阶段，并且有多余的
			if ismagic and not self.isrotten and (self.stage+1) == self.stage_max then --防止魔法催熟导致过熟
				self:DoGrowth(false)
				return
			end
			self:DoGrowth(true)
			self.timedata.start = GetTime()
			self.timedata.all = self:GetGrowTime()
			self:LongUpdate(dt-self.timedata.all, true) --经过这次成长，由于经过时间dt还没完，继续下一次判定
		elseif dt == self.timedata.all then
			self:DoGrowth(false)
		else --经过的时间不足以让作物长到下一个阶段
			self:StartGrowing(self.timedata.all - dt)
			if isloop then
				--把没有改变的动画和可采摘性补上
				self:SetStage(self.stage, self.ishuge, self.isrotten, true, false)
			end
		end
	else
		self:StartGrowing() --数据丢失的话，就只能重新开始了
	end
end

function PerennialCrop:OnEntitySleep()
    if self.taskgrow ~= nil then
		self.taskgrow:Cancel()
		self.taskgrow = nil
	end
end

function PerennialCrop:OnEntityWake()
	if self.timedata.paused then
		return
	end

    if self.timedata.start ~= nil and self.timedata.all ~= nil then
		--把目前已经经过的时间归入生长中去
		local dt = GetTime() - self.timedata.start
		if dt >= 0 then
			self:LongUpdate(dt, false)
			return
		end
	end
	self:StartGrowing() --数据丢失的话，就只能重新开始了
end

function PerennialCrop:OnSave()
    local data =
    {
        moisture = self.moisture > 0 and self.moisture or nil,
        nutrient = self.nutrient > 0 and self.nutrient or nil,
		nutrientgrow = self.nutrientgrow > 0 and self.nutrientgrow or nil,
        nutrientsick = self.nutrientsick > 0 and self.nutrientsick or nil,
		sickness = self.sickness > 0 and self.sickness or nil,
		stage = self.stage ~= 1 and self.stage or nil,
		isrotten = self.isrotten or nil,
		ishuge = self.ishuge or nil,
		infested = self.infested > 0 and self.infested or nil,
		pollinated = self.pollinated > 0 and self.pollinated or nil,
		num_nutrient = self.num_nutrient > 0 and self.num_nutrient or nil,
		num_moisture = self.num_moisture > 0 and self.num_moisture or nil,
		num_tended = self.num_tended > 0 and self.num_tended or nil,
		num_perfect = self.num_perfect ~= nil and self.num_perfect or nil,
		tended = self.tended or nil,
    }

	if self.timedata.paused then
		data.time_paused = true
		data.time_left = self.timedata.left
	elseif self.timedata.start ~= nil and self.timedata.all ~= nil then
		data.time_all = self.timedata.all
		data.time_dt = GetTime() - self.timedata.start
	end

    return data
end

function PerennialCrop:OnLoad(data)
    if data == nil then
        return
    end

	self.moisture = data.moisture or 0
	self.nutrient = data.nutrient or 0
	self.nutrientgrow = data.nutrientgrow or 0
	self.nutrientsick = data.nutrientsick or 0
	self.sickness = data.sickness or 0
	self.stage = data.stage or 1
	self.isrotten = data.isrotten and true or false
	self.ishuge = data.ishuge and true or false
	self.infested = data.infested or 0
	self.pollinated = data.pollinated or 0
	self.num_nutrient = data.num_nutrient or 0
	self.num_moisture = data.num_moisture or 0
	self.num_tended = data.num_tended or 0
	self.num_perfect = data.num_perfect or nil

	self:SetStage(self.stage, self.ishuge, self.isrotten, false, false)

	--恢复当前阶段的照顾情况
	self.tended = data.tended and true or false
	if self.tended and self.tendable then --若已经照顾过，且当前阶段可被照顾，则不能再被照顾
		if self.inst.components.farmplanttendable ~= nil then
			self.inst.components.farmplanttendable:SetTendable(false)
		end
	end

	self:OnEntitySleep() --把task取消，根据情况继续
	if data.time_paused then
		self.timedata.paused = true
		self.timedata.left = data.time_left
		self.timedata.start = nil
		self.timedata.all = nil
	elseif data.time_dt ~= nil and data.time_all ~= nil then
		self.timedata.paused = false
		self.timedata.left = nil
		self.timedata.start = GetTime()
		self.timedata.all = data.time_all
		self:LongUpdate(data.time_dt, false)
	else
		self:StartGrowing() --数据丢失的话，就只能重新开始了
	end
end

function PerennialCrop:Pause()
	if self.timedata.paused then
		return
	end

	self:OnEntityWake() --先更新已生长的数据
	self:OnEntitySleep()
	self.timedata.paused = true
	self.timedata.left = self.timedata.all --更新数据后，self.timedata.start就是当前时间，所以不必再判断
	self.timedata.start = nil
	self.timedata.all = nil
end

function PerennialCrop:Resume()
    if not self.timedata.paused then
		return
	end

	self:StartGrowing(self.timedata.left)
end

function PerennialCrop:CanGrowInDark()
	--腐烂、巨型、成熟时，在黑暗中也要计算时间了
	return self.isrotten or self.ishuge or self.stage == self.stage_max
end

function PerennialCrop:OnRemoveFromEntity()
    self.inst:RemoveTag("flower")
	-- self.inst:RemoveTag("fertilizable")
	self.inst:RemoveTag("fertable1")
	self.inst:RemoveTag("fertable2")
	self.inst:RemoveTag("fertable3")
	self.inst:RemoveTag("needwater")
	self.inst:AddTag("nognatinfest")
    if self.taskgrow ~= nil then
		self.taskgrow:Cancel()
		self.taskgrow = nil
	end
end

function PerennialCrop:Pollinate(doer, value) --授粉
    if self.isrotten or self.stage == self.stage_max or self.pollinated >= self.pollinated_max then
		return
	end
	self.pollinated = self.pollinated + (value or 1)
end

function PerennialCrop:Infest(doer, value) --侵害
	if self.isrotten then
		return false
	end

	self.infested = self.infested + (value or 1)
	if self.infested >= self.infested_max then
		self.infested = 0
		self:SetStage(self.stage, self.ishuge, true, true, false)
		if self.timedata.paused then
			self.timedata.left = nil --不用管，StartGrowing()时会自动设置的
			self.timedata.start = nil
			self.timedata.all = nil
		else
			self:StartGrowing()
		end
	end

	return true
end

function PerennialCrop:Cure(doer) --治疗
	self.infested = 0
	self.sickness = 0
end

function PerennialCrop:Tendable(doer, wish) --是否能照顾
	if not self.tendable then
		return false
	end

	if wish == nil or wish then --希望是照顾
		return not self.tended
	else --希望是取消照顾
		return self.tended
	end
end

function PerennialCrop:TendTo(doer, wish) --照顾
	if not self:Tendable(doer, wish) then
		return false
	end

	if wish == nil or wish then --希望是照顾
		self.num_tended = self.num_tended + 1
		self.tended = true
	else --希望是取消照顾
		self.num_tended = self.num_tended - 1
		self.tended = false
	end
	if self.inst.components.farmplanttendable ~= nil then
		self.inst.components.farmplanttendable:SetTendable(not self.tended)
	end
	if not self.inst:IsAsleep() then
		local tended = self.tended --记下此时状态，因为0.5秒后状态可能已经发生改变
		self.inst:DoTaskInTime(0.5 + math.random() * 0.5, function()
			local fx = SpawnPrefab(tended and "farm_plant_happy" or "farm_plant_unhappy")
			if fx ~= nil then
				fx.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
			end
		end)
	end

	return true
end

function PerennialCrop:DoMagicGrowth(doer, dt) -- 催熟
	--着火时无法被催熟
	if self.inst.components.burnable ~= nil and self.inst.components.burnable:IsBurning() then
		return false
	end

	--暂停生长时无法被催熟
	if self.timedata.paused then
		return false
	end

	--成熟状态是无法被催熟的
	if not self.isrotten and self.stage == self.stage_max then
		return true
	end

	if dt == nil then
		self:DoGrowth(false)
	else
		self:LongUpdate(dt, false, true)
	end
	return true
end

function PerennialCrop:Fertilize(item, doer) --施肥
	if item.components.fertilizer ~= nil and item.components.fertilizer.nutrients ~= nil then
		local nutrients = item.components.fertilizer.nutrients
		local isdone = false

		--1号肥：加速生长
		if nutrients[1] ~= nil and nutrients[1] > 0 and self.nutrientgrow < self.nutrientgrow_max then
			self.nutrientgrow = math.min(self.nutrientgrow_max, self.nutrientgrow+nutrients[1])
			isdone = true
		end
		--2号肥：预防疾病
		if nutrients[2] ~= nil and nutrients[2] > 0 and self.nutrientsick < self.nutrientsick_max then
			self.nutrientsick = math.min(self.nutrientsick_max, self.nutrientsick+nutrients[2])
			isdone = true
		end
		--3号肥：生长必需
		if nutrients[3] ~= nil and nutrients[3] > 0 and self.nutrient < self.nutrient_max then
			self.nutrient = math.min(self.nutrient_max, self.nutrient+nutrients[3])
			isdone = true
		end

		if isdone then
			if self.inst.components.burnable ~= nil then --快着火时能阻止着火
				self.inst.components.burnable:StopSmoldering()
			end
			if item.components.fertilizer.fertilize_sound ~= nil then
				self.inst.SoundEmitter:PlaySound(item.components.fertilizer.fertilize_sound)
			end
			TriggerNutrient(self)
			return true
		end
	end

	return false
end

function PerennialCrop:PourWater(item, doer, value) --浇水
	if self.moisture < self.moisture_max then
		self.moisture = math.min(self.moisture_max, self.moisture+(value or 6))
		TriggerMoisture(self)
	end
end

function PerennialCrop:SayDetail(doer, dotalk) --介绍细节
	if
		doer ~= nil and doer:HasTag("player") and not doer:HasTag("mime") and doer.components.inventory ~= nil
	then
		local str = nil
		local hat = doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)

		if hat == nil then
			if doer:HasTag("plantkin") then
				str = GetDetailString(self, doer, 1)
			end
		elseif hat:HasTag("detailedplanthappiness") then
			str = GetDetailString(self, doer, 2)
		elseif hat:HasTag("plantinspector") then
			str = GetDetailString(self, doer, 1)
		end

		if dotalk and str ~= nil and doer.components.talker ~= nil then
			doer.components.talker:Say(str)
		end

		return str
	end
	return nil
end

local function ComputValue(valuectl, valueneed)
	local _mo = 0
	if valuectl >= valueneed then
		_mo = valueneed
		valueneed = 0
	else
		_mo = valuectl
		valueneed = valueneed - valuectl
	end
	return valueneed, _mo
end
function PerennialCrop:CostController()
	local need_mo = math.max(0, self.moisture_max - self.moisture)
	local need_n1 = math.max(0, self.nutrientgrow_max - self.nutrientgrow)
	local need_n2 = math.max(0, self.nutrientsick_max - self.nutrientsick)
	local need_n3 = math.max(0, self.nutrient_max - self.nutrient)
	local tendable = self:Tendable()

	if need_mo == 0 and need_n1 == 0 and need_n2 == 0 and need_n3 == 0 and not tendable then
		return
	end

	local _mo = 0
	for _,ctl in pairs(self.ctls) do
		if ctl and ctl:IsValid() and ctl.components.botanycontroller ~= nil then
			local botanyctl = ctl.components.botanycontroller
			local change = false
			if need_mo > 0 and (botanyctl.type == 1 or botanyctl.type == 3) and botanyctl.moisture > 0 then
				need_mo, _mo = ComputValue(botanyctl.moisture, need_mo)
				botanyctl.moisture = botanyctl.moisture - _mo
				self.moisture = self.moisture + _mo
				change = true
			end
			if botanyctl.type == 2 or botanyctl.type == 3 then
				if need_n1 > 0 and botanyctl.nutrients[1] > 0 then
					need_n1, _mo = ComputValue(botanyctl.nutrients[1], need_n1)
					botanyctl.nutrients[1] = botanyctl.nutrients[1] - _mo
					self.nutrientgrow = self.nutrientgrow + _mo
					change = true
				end
				if need_n2 > 0 and botanyctl.nutrients[2] > 0 then
					need_n2, _mo = ComputValue(botanyctl.nutrients[2], need_n2)
					botanyctl.nutrients[2] = botanyctl.nutrients[2] - _mo
					self.nutrientsick = self.nutrientsick + _mo
					change = true
				end
				if need_n3 > 0 and botanyctl.nutrients[3] > 0 then
					need_n3, _mo = ComputValue(botanyctl.nutrients[3], need_n3)
					botanyctl.nutrients[3] = botanyctl.nutrients[3] - _mo
					self.nutrient = self.nutrient + _mo
					change = true
				end
			end

			if tendable and botanyctl.type == 3 then
				self:TendTo(ctl)
				tendable = false
			end

			if change then
				botanyctl:SetBars()
			end

			if need_mo <= 0 and need_n1 <= 0 and need_n2 <= 0 and need_n3 <= 0 and not tendable then
				break
			end
		end
	end
end

function PerennialCrop:TriggerController(ctl, isadd, noupdate)
	if ctl.GUID == nil then
		return
	end

	if isadd then
		self.ctls[ctl.GUID] = ctl
	else
		self.ctls[ctl.GUID] = nil
	end

	--更新一下已有的管理器
	if not noupdate then
		local newctls = {}
		for _,c in pairs(self.ctls) do
			if c ~= nil and c:IsValid() and c.GUID ~= nil and c.components.botanycontroller ~= nil then
				newctls[c.GUID] = c
			end
		end
		self.ctls = newctls
	end

	if self.onctlchange ~= nil then
		self.onctlchange(self.inst, self.ctls)
	end
end

function PerennialCrop:DisplayCrop(oldcrop, doer) --替换作物：把它的养料占为己有
	local oldcpt = oldcrop.components.perennialcrop

	self.nutrientgrow = math.min(self.nutrientgrow_max, self.nutrientgrow+oldcpt.nutrientgrow)
	self.nutrientsick = math.min(self.nutrientsick_max, self.nutrientsick+oldcpt.nutrientsick)
	self.nutrient = math.min(self.nutrient_max, self.nutrient+oldcpt.nutrient)
	TriggerNutrient(self)

	self:PourWater(nil, nil, oldcpt.moisture)

	oldcrop.components.lootdropper:DropLoot()

	if oldcpt.fn_defend ~= nil and doer then
		oldcpt.fn_defend(oldcrop, doer)
	end
	local x, y, z = oldcrop.Transform:GetWorldPosition()
	SpawnPrefab("dirt_puff").Transform:SetPosition(x, y, z)
end

return PerennialCrop
