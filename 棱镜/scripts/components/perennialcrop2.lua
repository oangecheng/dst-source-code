local function onflower(self)
    if self.isflower then
        self.inst:AddTag("flower")
    else
        self.inst:RemoveTag("flower")
    end
end
local function onrotten(self)
    if self.isrotten then
        self.inst:AddTag("nognatinfest")
    else
        self.inst:RemoveTag("nognatinfest")
    end
end
local function onmoisture(self)
    if self.donemoisture then
        self.inst:RemoveTag("needwater")
    else
        self.inst:AddTag("needwater")
    end
end
local function onnutrient(self)
    if self.donenutrient then
        self.inst:RemoveTag("fertableall")
    else
        self.inst:AddTag("fertableall")
    end
end

local PerennialCrop2 = Class(function(self, inst)
	self.inst = inst

	self.cropprefab = "corn" --果实名字，也是数据的key
	self.stage_max = 3 --最大生长阶段
	self.regrowstage = 1 --采摘后重新开始生长的阶段（枯萎后采摘必定从第1阶段开始）
	self.growthmults = { 1, 1, 1, 0 } --四个季节的生长速度
	self.leveldata = nil --该植物生长有几个阶段，每个阶段的动画，以及是否处在花期、是否能采集

	self.pollinated_max = 3 --被授粉次数大于等于该值就能增加产量
	self.infested_max = 10 --被骚扰次数大于等于该值就会立即进入腐烂/枯萎阶段
	self.getsickchance = CONFIGS_LEGION.X_PESTRISK or 0.007 --产生病虫害几率
	self.cangrowindrak = false --能否在黑暗中生长

	self.stage = 1 --当前生长阶段
	self.isflower = false --当前阶段是否开花
	self.isrotten = false --当前阶段是否枯萎
	self.donemoisture = false --当前阶段是否已经浇水
	self.donenutrient = false --当前阶段是否已经施肥
	self.donetendable = false --当前阶段是否已经照顾
	self.level = nil --当前阶段的数据

	self.numfruit = nil --随机果实数量
	self.pollinated = 0 --被授粉次数
	self.infested = 0 --被骚扰次数

	self.taskgrow = nil
	self.timedata = {
		start = nil, --开始进行生长的时间点
		left = nil, --剩余生长时间（不包括缩减或增加的时间）。为 nil 代表停止生长
		mult = nil --当前生长时间系数。为 nil 代表停止生长
	}

	self.cluster_size = { 1, 1.8 } --体型变化范围
	self.cluster_max = 99 --最大簇栽等级
	self.cluster = 0 --簇栽等级
	self.lootothers = nil --{ { israndom=false, factor=0.02, name="log", name_rot="xxx" } } 副产物表

	self.ctls = {} --管理者
	self.onctlchange = nil

	self.fn_growth = nil --成长时触发：fn(self, nextstagedata)
	self.fn_overripe = nil --过熟时触发：fn(self, numloot)
	self.fn_loot = nil --计算收获物时触发：fn(self, doer, ispicked, isburnt, lootprefabs)
	self.fn_pick = nil --收获时触发：fn(self, doer, loot)
	self.fn_stage = nil --每次设定生长阶段时额外触发的函数：fn(self)

	self.fn_defend = nil --作物被采集/破坏时会寻求庇护的函数：fn(inst, target)
	self.fn_cluster = nil --簇栽等级变化时触发：fn(self, nowvalue)
end,
nil,
{
    isflower = onflower,
	isrotten = onrotten,
	donemoisture = onmoisture,
	donenutrient = onnutrient
})

local function CancelTaskGrow(self)
	if self.taskgrow ~= nil then
		self.taskgrow:Cancel()
		self.taskgrow = nil
	end
end
local function GetFruitNum(self)
	if self.pollinated >= self.pollinated_max then
		return (self.numfruit or 1) + 1
	else
		return self.numfruit or 1
	end
end

function PerennialCrop2:SetUp(cropprefab, data)
	self.cropprefab = cropprefab
	self.stage_max = #data.leveldata
	self.leveldata = data.leveldata
	if data.growthmults then
		self.growthmults = data.growthmults
	end
	if data.regrowstage then
		self.regrowstage = data.regrowstage
	end
	if data.cangrowindrak == true then
		self.cangrowindrak = true
	end
	self.fn_growth = data.fn_growth
	self.fn_overripe = data.fn_overripe
	self.fn_loot = data.fn_loot
	self.fn_pick = data.fn_pick
	self.fn_stage = data.fn_stage

	if data.cluster_max then
		self.cluster_max = data.cluster_max
	end
	if data.cluster_size then
		self.cluster_size = data.cluster_size
	end
	self:OnClusterChange() --这里写是为了动态更新大小
	self.lootothers = data.lootothers

	if data.getsickchance and self.getsickchance > 0 then
		self.getsickchance = data.getsickchance
	end
end

function PerennialCrop2:GetNextStage() --判定下一个阶段
	local data = {
		stage = 1,
		justgrown = false, --是否是正常生长到下一阶段
		overripe = false, --是否是过熟
		level = nil
	}

	if self.isrotten then --枯萎阶段->1阶段
		data.stage = 1
	elseif self.level.time == nil or self.level.time == 0 then --永恒阶段
		data.stage = self.stage
	elseif self.stage >= self.stage_max then --成熟阶段->再生阶段（过熟）
		data.stage = self.regrowstage
		data.overripe = true
	else --生长阶段->下一个生长阶段（不管是否成熟）
		data.stage = self.stage + 1
		data.justgrown = true
	end
	data.level = self.leveldata[data.stage]

	return data
end

local function OnPicked(inst, doer, loot)
	local crop = inst.components.perennialcrop2
	local regrowstage = crop.isrotten and 1 or crop.regrowstage --枯萎之后，只能从第一阶段开始

	if crop.fn_defend ~= nil then
		crop.fn_defend(inst, doer)
	end
	crop:GenerateLoot(doer, true, false)

	if not inst:IsValid() then --inst 在 crop:GenerateLoot() 里可能会被删除
		return
	end

	crop.infested = 0
	crop.pollinated = 0
	crop.numfruit = nil
	crop.donenutrient = false
	crop.donetendable = false
	crop.donemoisture = false
	crop:CostNutrition()
	crop:SetStage(regrowstage, false, false)
	crop:StartGrowing()
end
function PerennialCrop2:SetStage(stage, isrotten, skip) --设置为某阶段
	if stage == nil or stage < 1 then
		stage = 1
	elseif stage > self.stage_max then
		stage = self.stage_max
	end

	--确定当前的阶段
	local rotten = false
	local level = self.leveldata[stage]
	if isrotten then
		if level.deadanim == nil then --枯萎了，但是没有枯萎状态，回到第一个阶段
			level = self.leveldata[1]
			stage = 1
		else
			rotten = true
		end
	end

	--修改当前阶段数据
	self.stage = stage
	self.level = level
	self.isrotten = rotten

	if skip then --如果跳过，就不设置接下来的操作
		return
	end

	self.isflower = not rotten and level.bloom == true --花期跳过不影响流程

	--设置动画
	if rotten then
		self.inst.AnimState:PlayAnimation(level.deadanim, false)
	elseif stage == self.stage_max or level.pickable == 1 then
		if type(level.anim) == 'table' then
			local minnum = #level.anim
			minnum = math.min(minnum, GetFruitNum(self))
			self.inst.AnimState:PlayAnimation(level.anim[minnum], true)
		else
			self.inst.AnimState:PlayAnimation(level.anim, true)
		end
		self.inst.AnimState:SetTime(math.random() * self.inst.AnimState:GetCurrentAnimationLength())
	else
		if type(level.anim) == 'table' then
			self.inst.AnimState:PlayAnimation(level.anim[ math.random(#level.anim) ], true)
		else
			self.inst.AnimState:PlayAnimation(level.anim, true)
		end
		self.inst.AnimState:SetTime(math.random() * self.inst.AnimState:GetCurrentAnimationLength())
	end

	--设置是否可采摘
	if
		rotten or --枯萎了，必定能采集
		level.pickable == 1 or -- 1 代表必定能采集
		(level.pickable ~= -1 and stage == self.stage_max) -- -1 代表不能采集
	then
		if self.inst.components.pickable == nil then
			self.inst:AddComponent("pickable")
		end
		self.inst.components.pickable.onpickedfn = OnPicked
		self.inst.components.pickable:SetUp(nil)
		-- self.inst.components.pickable.use_lootdropper_for_product = true
		self.inst.components.pickable.picksound = rotten and "dontstarve/wilson/harvest_berries"
																or "dontstarve/wilson/pickup_plants"
	else
		self.inst:RemoveComponent("pickable")
	end

	--基础三样操作
	if rotten or stage == self.stage_max then
		self.donemoisture = true
		self.donenutrient = true
		self.donetendable = true
	end

	--设置是否可照顾
	if self.inst.components.farmplanttendable ~= nil then
		self.inst.components.farmplanttendable:SetTendable(not self.donetendable)
	end

	--额外设置
	if self.fn_stage ~= nil then
		self.fn_stage(self)
	end
end

function PerennialCrop2:GetGrowTime(time) --获取生长基础时间、生长速度
	local data = {
		mult = 1,
		time = nil
	}

	if self.isrotten then --枯萎了的话，2天后重生
		data.time = time or (2*TUNING.TOTAL_DAY_TIME)
		return data
	else
		data.time = time or self.level.time
	end
	if data.time == nil or data.time <= 0 then --永恒阶段，后面就不用看了
		return data
	end
	if self.stage == self.stage_max then --成熟了的话，过熟时间不进行加成
		return data
	end

	if TheWorld.state.season == "winter" then
		data.mult = self.growthmults[4]
	elseif TheWorld.state.season == "summer" then
		data.mult = self.growthmults[2]
	elseif TheWorld.state.season == "spring" then
		data.mult = self.growthmults[1]
	else --默认为秋，其他mod的特殊季节默认都为秋季
		data.mult = self.growthmults[3]
	end
	if data.mult == nil or data.mult <= 0 then --说明在某季节停止生长
		data.mult = 0
		return data
	end

	--浇水、施肥、照顾，能加快生长
	local mulmul = 1.0
	if self.donemoisture then
		mulmul = mulmul - 0.15
	end
	if self.donenutrient then
		mulmul = mulmul - 0.2
	end
	if self.donetendable then
		mulmul = mulmul - 0.15
	end
	data.mult = data.mult * mulmul

	return data
end

function PerennialCrop2:CostFromLand() --从耕地吸取所需养料、水分
	local x, y, z = self.inst.Transform:GetWorldPosition()
	local tile = TheWorld.Map:GetTileAtPoint(x, 0, z)
	if tile == GROUND.FARMING_SOIL then
		local farmmgr = TheWorld.components.farming_manager
		local tile_x, tile_z = TheWorld.Map:GetTileCoordsAtPoint(x, y, z)
    	local _n1, _n2, _n3 = farmmgr:GetTileNutrients(tile_x, tile_z)
		local clusterplus = math.max( math.floor(self.cluster*0.5), 1 )

		--加水
		if not self.donemoisture then
			if farmmgr:IsSoilMoistAtPoint(x, y, z) then
				self.donemoisture = true
				farmmgr:AddSoilMoistureAtPoint(x, y, z, -2.5*clusterplus)
			end
		end

		--施肥
		if not self.donenutrient then
			if _n3 > 0 then
				_n3 = -3*clusterplus
				_n2 = 0
				_n1 = 0
			elseif _n2 > 0 then
				_n3 = 0
				_n2 = -3*clusterplus
				_n1 = 0
			elseif _n1 > 0 then
				_n3 = 0
				_n2 = 0
				_n1 = -3*clusterplus
			end
			if _n3 < 0 or _n2 < 0 or _n1 < 0 then
				self.donenutrient = true
				farmmgr:AddTileNutrients(tile_x, tile_z, _n1, _n2, _n3)
			end
		end
	end
end
function PerennialCrop2:CostController() --从管理器拿取养料、水分、照顾
	-- if self.isrotten or self.stage == self.stage_max then
	-- 	return
	-- end
	if self.donemoisture and self.donenutrient and self.donetendable then
		return
	end

	local clusterplus = math.max( math.floor(self.cluster*0.5), 1 )
	for _,ctl in pairs(self.ctls) do
		if ctl and ctl:IsValid() and ctl.components.botanycontroller ~= nil then
			local botanyctl = ctl.components.botanycontroller
			local change = false
			if not self.donemoisture and (botanyctl.type == 1 or botanyctl.type == 3) and botanyctl.moisture > 0 then
				botanyctl.moisture = math.max(botanyctl.moisture - 2.5*clusterplus, 0)
				self.donemoisture = true
				change = true
			end

			if not self.donenutrient and (botanyctl.type == 2 or botanyctl.type == 3) then
				if botanyctl.nutrients[3] > 0 then
					botanyctl.nutrients[3] = math.max(botanyctl.nutrients[3] - 3*clusterplus, 0)
					self.donenutrient = true
					change = true
				elseif botanyctl.nutrients[2] > 0 then
					botanyctl.nutrients[2] = math.max(botanyctl.nutrients[2] - 3*clusterplus, 0)
					self.donenutrient = true
					change = true
				elseif botanyctl.nutrients[1] > 0 then
					botanyctl.nutrients[1] = math.max(botanyctl.nutrients[1] - 3*clusterplus, 0)
					self.donenutrient = true
					change = true
				end
			end

			if not self.donetendable and botanyctl.type == 3 then
				self.donetendable = true
				-- change = true --这种不算消耗的
				if not self.inst:IsAsleep() then
					self.inst:DoTaskInTime(0.5 + math.random() * 0.5, function()
						local fx = SpawnPrefab("farm_plant_happy")
						if fx ~= nil then
							fx.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
						end
					end)
				end
			end

			if change then
				botanyctl:SetBars()
			end

			if self.donemoisture and self.donenutrient and self.donetendable then
				break
			end
		end
	end
end
function PerennialCrop2:CostNutrition() --养料水分索取
	if TheWorld.state.israining or TheWorld.state.issnowing then --如果此时在下雨/雪
		self.donemoisture = true
	end
	self:CostController() --从管理器拿取资源
	if not self.donemoisture or not self.donenutrient then --还需要水分或养料，从耕地里汲取
		self:CostFromLand()
	end
end
function PerennialCrop2:TriggerController(ctl, isadd, noupdate)
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

local function CanAcceptNutrients(botanyctl, test)
	if test ~= nil and (botanyctl.type == 2 or botanyctl.type == 3) then
		if test[1] ~= nil and test[1] ~= 0 and botanyctl.nutrients[1] < botanyctl.nutrient_max then
			return true
		elseif test[2] ~= nil and test[2] ~= 0 and botanyctl.nutrients[2] < botanyctl.nutrient_max then
			return true
		elseif test[3] ~= nil and test[3] ~= 0 and botanyctl.nutrients[3] < botanyctl.nutrient_max then
			return true
		else
			return false
		end
	end
	return nil
end
function PerennialCrop2:DoGrowth(skip) --生长到下一阶段
	local data = self:GetNextStage()

	if data.justgrown or data.overripe then --生长和过熟时都会产生虫群
		if self.getsickchance > 0 then
			local clusterplus = math.max( math.floor(self.cluster*0.1), 1 )
			if math.random() < self.getsickchance*clusterplus then
				local bugs = SpawnPrefab(math.random()<0.7 and "cropgnat" or "cropgnat_infester")
				if bugs ~= nil then
					bugs.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
				end
			end
		end
	end

	if data.justgrown then
		if data.stage == self.stage_max or data.level.pickable == 1 then --如果能采集了，开始计算果子数量
			if self.numfruit == nil or self.numfruit <= 1 then --如果只有1个，有机会继续变多
				local num = 1
				local rand = math.random()
				if rand < 0.35 then --35%几率2果实
					num = num + 1
				elseif rand < 0.5 then --15%几率3果实
					num = num + 2
				end
				self.numfruit = num
			end
		end
	elseif data.stage == self.regrowstage or data.stage == 1 then --重新开始生长时，清空某些数据
		--如果过熟了，掉落果子，给周围植物、土地和子圭管理者施肥
		if data.overripe then
			local num = self.cluster + GetFruitNum(self)
			local numpoop = math.ceil( num*(0.5 + math.random()*0.5) )
			local numloot = num - numpoop
			local pos = self.inst:GetPosition()

			if numpoop > 0 then
				local gnum = 20
				local costplus = numpoop >= gnum and gnum or numpoop

				for _,ctl in pairs(self.ctls) do
					if ctl and ctl:IsValid() and ctl.components.botanycontroller ~= nil then
						local botanyctl = ctl.components.botanycontroller
						local nutrients = { 16*costplus, 16*costplus, 16*costplus }
						if CanAcceptNutrients(botanyctl, nutrients) then
							for i = 1, 5, 1 do
								botanyctl:SetValue(nil, nutrients, true)
								numpoop = numpoop - costplus
								if numpoop <= 0 or not CanAcceptNutrients(botanyctl, nutrients) then
									break
								end
								if costplus == gnum and numpoop < gnum then
									costplus = numpoop
									nutrients = {16*costplus,16*costplus,16*costplus}
								end
							end
						end

						if numpoop <= 0 then
							break
						end
					end
				end

				local x = pos.x
				local y = pos.y
				local z = pos.z
				if numpoop > 0 then
					for i = 1, 5, 1 do
						local hastile = false
						for k1 = -4, 4, 4 do --只影响周围半径一格的地皮，但感觉最多可涉及到3格地皮
							for k2 = -4, 4, 4 do
								local tile = TheWorld.Map:GetTileAtPoint(x+k1, 0, z+k2)
								if tile == GROUND.FARMING_SOIL then
									hastile = true
									local tile_x, tile_z = TheWorld.Map:GetTileCoordsAtPoint(x+k1, 0, z+k2)
									TheWorld.components.farming_manager:AddTileNutrients(tile_x, tile_z, 4*costplus,4*costplus,4*costplus)
								end
							end
						end
						if hastile then
							numpoop = numpoop - costplus
							if numpoop <= 0 then
								break
							end
							if costplus == gnum and numpoop < gnum then
								costplus = numpoop
							end
						else
							break
						end
					end
				end

				if numpoop > 0 then
					local hasset = false
					local ents = TheSim:FindEntities(x, y, z, 5,
						nil,
						{ "NOCLICK", "FX", "INLIMBO" },
						{ "crop_legion", "withered", "barren" }
					)
					for _,v in pairs(ents) do
						local cpt = nil
						if v.components.pickable ~= nil then
							if v.components.pickable:CanBeFertilized() then
								cpt = v.components.pickable
							end
						elseif v.components.perennialcrop ~= nil then
							cpt = v.components.perennialcrop
						-- elseif v.components.perennialcrop2 ~= nil then
						-- 	cpt = v.components.perennialcrop2
						end

						if cpt ~= nil then
							local poop = SpawnPrefab("glommerfuel")
							if poop ~= nil then
								if hasset then
									cpt:Fertilize(poop, nil)
								else
									hasset = cpt:Fertilize(poop, nil)
								end
								poop:Remove()
							end
						end
					end

					if hasset then
						numpoop = numpoop - costplus
					end
				end

				if numpoop > 0 then
					self:SpawnStackDrop(nil, "spoiled_food", numpoop, pos)
				end
			end

			if self.fn_overripe ~= nil then
				self.fn_overripe(self, numloot)
			elseif numloot > 0 then
				self:SpawnStackDrop(nil, self.cropprefab, numloot, pos)
			end
		end

		self.infested = 0
		self.pollinated = 0
		self.numfruit = nil
	end

	if self.fn_growth ~= nil then
		self.fn_growth(self, data)
		if not self.inst:IsValid() then --巨食草需要的，fn_growth 里会移除自己
			return
		end
	end

	if data.stage ~= self.stage_max then --生长阶段，就可以三样操作
		self.donemoisture = false
		self.donenutrient = false
		self.donetendable = false
		self:CostNutrition() --是生长，肯定要消耗肥料
	end

	self:SetStage(data.stage, false, skip)
	self:StartGrowing(nil, skip)
end

function PerennialCrop2:StartGrowing(lefttime, skip) --尝试生长计时
	if self.taskgrow ~= nil then
		self.taskgrow:Cancel()
		self.taskgrow = nil
	end

	local data = self:GetGrowTime()
	if data.time == nil or data.time <= 0 then --永恒阶段
		self.timedata.mult = nil
		self.timedata.start = nil
		self.timedata.left = nil
		return
	else
		if data.mult <= 0 then --生长暂停
			self.timedata.mult = nil
			self.timedata.start = nil
			self.timedata.left = lefttime or data.time
			return
		else
			self.timedata.mult = data.mult
			self.timedata.start = GetTime()
			self.timedata.left = lefttime or data.time
		end
	end

	if not skip and not self.inst:IsAsleep() then
		--实际任务时间是剩余时间*生长系数
		self.taskgrow = self.inst:DoTaskInTime(self.timedata.left*data.mult, function(inst, self)
			-- self.timedata.all = nil
			self.timedata.mult = nil
			self.timedata.start = nil
			self.timedata.left = nil
			self:DoGrowth(false)
		end, self)
	end
end

function PerennialCrop2:LongUpdate(dt, isloop, ismagic)
	if self.timedata.mult == nil or self.timedata.left == nil then --生长停滞、或是永恒阶段
		return
	end

    local alltime = self.timedata.left*self.timedata.mult --将时间转化为带mult的
	if dt > alltime then --经过的时间可以让作物长到下一阶段，并且有多余的
		if ismagic and not self.isrotten and (self.stage+1) == self.stage_max then --防止魔法催熟导致过熟
			self:DoGrowth(false)
			return
		end
		self:DoGrowth(true)
		if not self.inst:IsValid() then --生长时可能会移除实体
			return
		end
		if self.timedata.mult ~= nil and self.timedata.left ~= nil then --生长没有停滞
			self:LongUpdate(dt - alltime, true, ismagic) --经过这次成长，由于经过时间dt还没完，继续下一次判定
		else
			self:SetStage(self.stage, self.isrotten, false) --由于不再继续生长，把没有改变的动画和可采摘性补上
		end
	elseif dt == alltime then
		self:DoGrowth(false)
	else --经过的时间不足以让作物长到下一个阶段
		if isloop then
			self:SetStage(self.stage, self.isrotten, false) --把没有改变的动画和可采摘性补上
			if self.timedata.mult ~= nil then
				self:StartGrowing((alltime - dt)/self.timedata.mult, false)
			end
		else
			self:StartGrowing((alltime - dt)/self.timedata.mult, false)
		end
	end
end

function PerennialCrop2:OnEntitySleep()
    CancelTaskGrow(self)
end

function PerennialCrop2:OnEntityWake()
	if self.timedata.mult == nil or self.timedata.left == nil then --生长停滞、或是永恒阶段
		return
	end

    if self.timedata.start ~= nil then
		--把目前已经经过的时间归入生长中去
		local dt = GetTime() - self.timedata.start
		if dt >= 0 then
			CancelTaskGrow(self)
			self:LongUpdate(dt, false)
			return
		end
	end
	self:StartGrowing(self.timedata.left) --数据丢失的话，就只能重新开始了
end

function PerennialCrop2:Pause() --中止生长
	if self.timedata.mult == nil or self.timedata.left == nil then --生长停滞、或是永恒阶段
		return
	end

	self:OnEntityWake() --先更新已生长的数据
	if not self.inst:IsValid() then --生长时可能会移除实体
		return
	end

	CancelTaskGrow(self)
	-- self.timedata.left =
	self.timedata.start = nil
	self.timedata.mult = nil
end

function PerennialCrop2:Resume() --继续生长
	if self.timedata.start ~= nil then --start 不为空，代表已经在生长了，就不要继续重新刷新了
		return
	end

	self:StartGrowing(self.timedata.left)
end

function PerennialCrop2:OnSave()
    local data = {
        donemoisture = self.donemoisture == true or nil,
        donenutrient = self.donenutrient == true or nil,
		donetendable = self.donetendable == true or nil,
        stage = self.stage > 1 and self.stage or nil,
		isrotten = self.isrotten == true or nil,
		numfruit = self.numfruit ~= nil and self.numfruit or nil,
		pollinated = self.pollinated > 0 and self.pollinated or nil,
		infested = self.infested > 0 and self.infested or nil,
		cluster = self.cluster > 0 and self.cluster or nil
    }

	if self.timedata.left ~= nil then --说明要生长
		data.time_left = self.timedata.left
		if self.timedata.start ~= nil then
			data.time_dt = GetTime() - self.timedata.start
		end
	end

    return data
end

function PerennialCrop2:OnLoad(data)
    if data == nil then
        return
    end

	self.donemoisture = data.donemoisture ~= nil
	self.donenutrient = data.donenutrient ~= nil
	self.donetendable = data.donetendable ~= nil
	if data.stage ~= nil then
		self.stage = data.stage
	end
	self.isrotten = data.isrotten ~= nil
	self.numfruit = data.numfruit
	self.pollinated = data.pollinated or 0
	self.infested = data.infested or 0

	if data.cluster ~= nil then
		self.cluster = math.min(data.cluster, self.cluster_max)
		self:OnClusterChange()
	end

	self:SetStage(self.stage, self.isrotten, false)
	if data.time_left ~= nil then --说明能生长
		if data.time_dt ~= nil then
			self:StartGrowing(data.time_left, true)
			self:LongUpdate(data.time_dt, false)
		else
			self:StartGrowing(data.time_left, false)
		end
	else
		self:StartGrowing()
	end
end

function PerennialCrop2:CanGrowInDark() --是否能在黑暗中生长
	--枯萎、成熟时(要算过熟)，在黑暗中也要计算时间了
	return self.isrotten or self.stage == self.stage_max or self.cangrowindrak
end

function PerennialCrop2:SpawnStackDrop(loot, name, num, pos) --生成整组的物品，并丢下
	local item = SpawnPrefab(name)
	if item ~= nil then
		if num > 1 and item.components.stackable ~= nil then
			local maxsize = item.components.stackable.maxsize
			if num <= maxsize then
				item.components.stackable:SetStackSize(num)
				num = 0
			else
				item.components.stackable:SetStackSize(maxsize)
				num = num - maxsize
			end
		else
			num = num - 1
        end

        item.Transform:SetPosition(pos:Get())
        if item.components.inventoryitem ~= nil then
            item.components.inventoryitem:OnDropped(true)
        end
		if loot ~= nil then
			table.insert(loot, item)
		end

		if num >= 1 then
			self:SpawnStackDrop(loot, name, num, pos)
		end
	end
end
function PerennialCrop2:AddLoot(loot, name, number)
	if loot[name] == nil then
		loot[name] = number
	else
		loot[name] = loot[name] + number
	end
end
function PerennialCrop2:GetBaseLoot(lootprefabs, sets) --判定基础收获物
	--先算主
	local num = self.cluster + (self.numfruit or 1)
	local ispollinated = self.pollinated >= self.pollinated_max --授粉成功，提高产量
	if ispollinated then
		num = num + math.max( math.floor(self.cluster*0.1), 1 ) --保证肯定多1个
	end
	self:AddLoot(lootprefabs, self.isrotten and (sets.crop_rot or "spoiled_food") or sets.crop, num)

	--后算副
	if sets.lootothers ~= nil then
		for _, data in pairs(sets.lootothers) do
			if data.israndom then
				if ispollinated then
					num = math.random() < (data.factor+0.2) and 1 or 0
				else
					num = math.random() < data.factor and 1 or 0
				end
			else
				num = math.floor(self.cluster*data.factor)
				if ispollinated then
					num = num + math.max( math.floor(num*0.2), 1 ) --保证肯定多1个
				end
			end
			if num > 0 then
				local name
				if self.isrotten then
					name = data.name_rot or "spoiled_food"
				else
					name = data.name
				end
				self:AddLoot(lootprefabs, name, num)
			end
		end
	end
end
function PerennialCrop2:GenerateLoot(doer, ispicked, isburnt) --生成收获物
	local loot = {}
	local lootprefabs = {}
	local pos = self.inst:GetPosition()

	if self.fn_loot ~= nil then
		self.fn_loot(self, doer, ispicked, isburnt, lootprefabs)
	elseif self.stage == self.stage_max or self.level.pickable == 1 then
		self:GetBaseLoot(lootprefabs, {
			doer = doer, ispicked = ispicked, isburnt = isburnt,
			crop = self.cropprefab, crop_rot = "spoiled_food",
			lootothers = self.lootothers
		})
	end

	if not ispicked then --非采集时，多半是破坏
		if self.level.witheredprefab then
			for _, prefab in ipairs(self.level.witheredprefab) do
				self:AddLoot(lootprefabs, prefab, 1)
			end
		end
	end

	if self.isflower and not self.isrotten then
		self:AddLoot(lootprefabs, "petals", 3)
	elseif self.stage > 1 then
		local hasprefab = false
		for _, num in pairs(lootprefabs) do
			if num > 0 then
				hasprefab = true
				break
			end
		end
		if not hasprefab then
			if self.isrotten then
				self:AddLoot(lootprefabs, "spoiled_food", 1)
			else
				self:AddLoot(lootprefabs, "cutgrass", 1)
			end
		end
	end

	if isburnt then
		local lootprefabs2 = {}
		for name, num in pairs(lootprefabs) do
			if TUNING.BURNED_LOOT_OVERRIDES[name] ~= nil then
				self:AddLoot(lootprefabs2, TUNING.BURNED_LOOT_OVERRIDES[name], num)
			elseif PrefabExists(name.."_cooked") then
				self:AddLoot(lootprefabs2, name.."_cooked", num)
			elseif PrefabExists("cooked"..name) then
				self:AddLoot(lootprefabs2, "cooked"..name, num)
			else
				self:AddLoot(lootprefabs2, "ash", num)
			end
		end
		lootprefabs = lootprefabs2
	end
	if not ispicked then --异种也要完全返还，写在后面，防止变成灰烬
		self:AddLoot(lootprefabs, "seeds_"..self.cropprefab.."_l", 1+self.cluster)
	end

	for name, num in pairs(lootprefabs) do --生成实体并设置物理掉落
		if num > 0 then
			self:SpawnStackDrop(loot, name, num, pos)
		end
	end

	if ispicked then
		if self.fn_pick ~= nil then
			self.fn_pick(self, doer, loot)
		end
		if doer then
			doer:PushEvent("picksomething", { object = self.inst, loot = loot })
			if doer.components.inventory ~= nil then --给予采摘者
				for _, item in ipairs(loot) do
					if item.components.inventoryitem ~= nil then
						doer.components.inventory:GiveItem(item, nil, pos)
					end
				end
			end
		end
	end
end

function PerennialCrop2:Pollinate(doer, value) --授粉
    if self.isrotten or self.stage == self.stage_max or self.pollinated >= self.pollinated_max then
		return
	end
	self.pollinated = self.pollinated + (value or 1)
end

function PerennialCrop2:Infest(doer, value) --侵害
	if self.isrotten then
		return false
	end

	self.infested = self.infested + (value or 1)
	if self.infested >= self.infested_max then
		self.infested = 0
		self:SetStage(self.stage, true, false)
		if not self.inst:IsValid() then --巨食草需要的，枯萎时会移除自己
			return true
		end
		self:StartGrowing() --开始枯萎计时
	end

	return true
end

function PerennialCrop2:Cure(doer) --治疗
	self.infested = 0
end

function PerennialCrop2:Tendable(doer, wish) --是否能照顾
	if self.isrotten or self.stage == self.stage_max then
		return false
	end

	if wish == nil or wish then --希望是照顾
		return not self.donetendable
	else --希望是取消照顾
		return self.donetendable
	end
end

local function CarePlant(self, key, val)
	self:OnEntityWake() --1、先把以前的生长时间纳入生长
	if not self.inst:IsValid() then --生长时可能会移除实体
		return
	end
	self[key] = val
	if self.timedata.mult == nil or self.timedata.left == nil then --生长停滞、或是永恒阶段
		return
	end
	self:StartGrowing(self.timedata.left) --2、再按照新的状态，重新计算生长时间
end
function PerennialCrop2:TendTo(doer, wish) --照顾
	if not self:Tendable(doer, wish) then
		return false
	end

	local tended
	if wish == nil or wish then --希望是照顾
		tended = true
	else --希望是取消照顾
		tended = false
	end
	if self.inst.components.farmplanttendable ~= nil then
		self.inst.components.farmplanttendable:SetTendable(not tended)
	end
	if not self.inst:IsAsleep() then
		-- local tended = self.donetendable --记下此时状态，因为0.5秒后状态可能已经发生改变
		self.inst:DoTaskInTime(0.5 + math.random() * 0.5, function()
			local fx = SpawnPrefab(tended and "farm_plant_happy" or "farm_plant_unhappy")
			if fx ~= nil then
				fx.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
			end
		end)
	end

	CarePlant(self, "donetendable", tended)

	return true
end
function PerennialCrop2:Fertilize(item, doer) --施肥
	if self.isrotten or self.donenutrient or self.stage == self.stage_max then
		return false
	end

	if item.components.fertilizer ~= nil and item.components.fertilizer.nutrients ~= nil then
		if self.inst.components.burnable ~= nil then --快着火时能阻止着火
			self.inst.components.burnable:StopSmoldering()
		end
		if item.components.fertilizer.fertilize_sound ~= nil then
			self.inst.SoundEmitter:PlaySound(item.components.fertilizer.fertilize_sound)
		end
		CarePlant(self, "donenutrient", true)

		return true
	end

	return false
end
function PerennialCrop2:PourWater(item, doer, value) --浇水
	if self.isrotten or self.donemoisture or self.stage == self.stage_max then
		return false
	end

	CarePlant(self, "donemoisture", true)

	return true
end

function PerennialCrop2:DoMagicGrowth(doer, dt, ignorelvl) --催熟
	--着火时无法被催熟
	if self.inst.components.burnable ~= nil and self.inst.components.burnable:IsBurning() then
		return false
	end

	--暂停生长时无法被催熟
	if self.timedata.mult == nil or self.timedata.left == nil then
		return false
	end

	--成熟状态是无法被催熟的（枯萎时可以催熟）
	if not self.isrotten and self.stage == self.stage_max then
		return true
	end

	if dt == nil then
		self:DoGrowth(false)
	else
		self:OnEntityWake() --更新已经经过的时间
		if not self.inst:IsValid() then --生长时可能会移除实体
			return false
		end

		--催熟时间会受到簇栽等级影响
		if not ignorelvl then
			dt = dt*Remap(self.cluster, 0, self.cluster_max, 1, 1/6)
		end
		self:LongUpdate(dt, false, true)
	end
	return true
end

function PerennialCrop2:OnClusterChange() --簇栽等级变化时
	local now = self.cluster or 0
	self.inst._cluster_l:set(now)
	if self.fn_cluster ~= nil then
		self.fn_cluster(self, now)
	end
	now = Remap(now, 0, self.cluster_max, self.cluster_size[1], self.cluster_size[2])
	self.inst.AnimState:SetScale(now, now, now)
end
function PerennialCrop2:ClusteredPlant(seeds, doer) --簇栽
	local plantable = seeds.components.plantablelegion
	if plantable == nil then
		return false
	end
	if
		plantable.plant ~= self.inst.prefab and
		(plantable.plant2 == nil or plantable.plant2 ~= self.inst.prefab)
	then
		return false, "NOTMATCH_C"
	end
	if self.cluster >= self.cluster_max then
		return false, "ISMAXED_C"
	end

	--升级前，先采摘了，防止玩家骚操作
	if doer ~= nil and self.inst.components.pickable ~= nil then
        self.inst.components.pickable:Pick(doer)
		if not self.inst:IsValid() then --采摘时可能会移除实体
			return true --如果移除实体，就只能不进行接下来的操作了
		end
    end

	if seeds.components.stackable ~= nil then
		local need = self.cluster_max - self.cluster
		local num = seeds.components.stackable:StackSize()
		if need > num then
			self.cluster = self.cluster + num
		else
			self.cluster = self.cluster_max
			seeds = seeds.components.stackable:Get(need)
		end
	else
		self.cluster = self.cluster + 1
	end
	self:OnClusterChange()
	seeds:Remove()

	if self.inst.SoundEmitter ~= nil then
		self.inst.SoundEmitter:PlaySound("dontstarve/common/plant")
	end

	return true
end
function PerennialCrop2:DoCluster(num) --单纯的簇栽升级，也可以降级
	if self.cluster >= self.cluster_max then
		return false
	end

	local newvalue = self.cluster + (num or 1)
	if newvalue > self.cluster_max then
		newvalue = self.cluster_max
	elseif newvalue < 0 then
		newvalue = 0
	else
		newvalue = math.floor(newvalue) --保证是整数
	end
	self.cluster = newvalue
	self:OnClusterChange()

	return newvalue < self.cluster_max
end

return PerennialCrop2
