local FishHomingBait = Class(function(self, inst)
	self.inst = inst
	self.times = 1
	self.prefabs = nil
	self.type_eat = "veggie"
	self.type_shape = "dusty"
	self.type_special = nil
	self.isbaiting = false

	self.onmakefn = nil
	self.oninitfn = nil
	self.ongetpreysfn = nil
	self.spawnbaitedfn = nil
	self.onspawnchumsfn = nil

	self.task_baiting = nil
	self.preys = nil
	self.eviled = nil

	self.task_chums = nil
end)

function FishHomingBait:InitSelf()
	if self.oninitfn ~= nil then
		self.oninitfn(self.inst)
	end

	if self.isbaiting then
		return
	end

	for k,_ in pairs(STRINGS.FISHHOMING2_LEGION) do
		if self.type_eat == string.lower(k) then
			self.inst:AddTag("FH_"..k)
		else
			self.inst:RemoveTag("FH_"..k)
		end
	end

	for k,_ in pairs(STRINGS.FISHHOMING1_LEGION) do
		if self.type_shape == string.lower(k) then
			self.inst:AddTag("FH_"..k)
		else
			self.inst:RemoveTag("FH_"..k)
		end
	end

	if self.type_special == nil then
		for k,_ in pairs(STRINGS.FISHHOMING3_LEGION) do
			self.inst:RemoveTag("FH_"..k)
		end
	else
		for k,_ in pairs(STRINGS.FISHHOMING3_LEGION) do
			if self.type_special[string.lower(k)] then
				self.inst:AddTag("FH_"..k)
			else
				self.inst:RemoveTag("FH_"..k)
			end
		end
	end
end

local function FindMaxKey(details, k1, k2, k3)
	if details[k1] > details[k2] then
		if details[k1] > details[k3] then
			return k1
		elseif details[k1] == details[k3] then
			return math.random() > 0.5 and k1 or k2
		else
			return k3
		end
	elseif details[k1] == details[k2] then
		if details[k1] > details[k3] then
			return math.random() > 0.5 and k1 or k2
		elseif details[k1] == details[k3] then
			if details[k1] <= 0 then
				return k1
			end
			local rand = math.random()
			if rand <= 0.33 then
				return k1
			elseif rand <= 0.66 then
				return k2
			else
				return k3
			end
		else
			return k3
		end
	else
		if details[k2] > details[k3] then
			return k2
		elseif details[k2] == details[k3] then
			return math.random() > 0.5 and k2 or k3
		else
			return k3
		end
	end
end
local function FindOtherKeys(other)
	local key_max = {}
	local num_max = 0
	local key_max2 = {}
	local num_max2 = 0

	--找出最大值
	for k,num in pairs(other) do
		if num then
			if num > num_max then
				num_max = num
				key_max = {}
				table.insert(key_max, k)
			elseif num == num_max then
				table.insert(key_max, k)
			end
		end
	end

	--找出第二最大值
	for k,num in pairs(other) do
		if num and num < num_max then
			if num > num_max2 then
				num_max2 = num
				key_max2 = {}
				table.insert(key_max2, k)
			elseif num == num_max2 then
				table.insert(key_max2, k)
			end
		end
	end

	if num_max <= 0 and num_max2 <= 0 then
		return nil
	end

	local res = {}

	if num_max > 0 then
		local max_count = #key_max
		if max_count == 1 then
			res[key_max[1]] = true
		elseif max_count == 2 then
			res[key_max[1]] = true
			res[key_max[2]] = true
			return res
		elseif max_count >= 3 then
			res[table.remove(key_max, math.random(max_count))] = true
			res[key_max[math.random(max_count-1)]] = true
			return res
		end
	end
	if num_max2 > 0 then
		res[ key_max2[math.random(#key_max2)] ] = true
	end
	-- print("zehshi:"..tostring(key_max[1]).."-"..tostring(key_max2[1]))
	return res
end
function FishHomingBait:Make(container, doer)
	local details = {
		hardy = 0, pasty = 0, dusty = 0,
		meat = 0, veggie = 0, monster = 0
	}
	local details_other = {}
	self.times = 0
	self.prefabs = {}

	for i = 1, container:GetNumSlots() do
		local item = container:GetItemInSlot(i)
		if item ~= nil then
			local mult = item.components.stackable ~= nil and item.components.stackable:StackSize() or 5

			if FISHHOMING_INGREDIENTS_L[item.prefab] ~= nil then
				local idata = FISHHOMING_INGREDIENTS_L[item.prefab]
				for k,num in pairs(idata) do
					if num then
						if details[k] == nil then
							if details_other[k] == nil then
								details_other[k] = num*mult
							else
								details_other[k] = details_other[k] + num*mult
							end
						else
							details[k] = details[k] + num*mult
						end
					end
				end
			elseif item.components.edible ~= nil then
				if item.components.edible.foodtype == FOODTYPE.MEAT then
					details.meat = details.meat + mult
				elseif item.components.edible.foodtype == FOODTYPE.VEGGIE or item.components.edible.foodtype == FOODTYPE.SEEDS then
					details.veggie = details.veggie + mult
				elseif item.components.edible.foodtype == FOODTYPE.MONSTER then
					details.monster = details.monster + mult
				end
			end

			self.times = self.times + mult
			self.prefabs[item.prefab] = true

			item:Remove()
		end
	end

	if self.onmakefn ~= nil then
		self.onmakefn(self, container, doer, details, details_other)
	end

	self.type_eat = FindMaxKey(details, "veggie", "meat", "monster")
	self.type_shape = FindMaxKey(details, "dusty", "pasty", "hardy")
	self.type_special = FindOtherKeys(details_other)

	self.times = math.ceil(self.times/2) --根据总数量确定释放功能的次数(最多 4格*40叠加/2=80次)

	self:InitSelf()
end

function FishHomingBait:OnSave()
    local data = {}

	if self.times > 1 then
		data.times = self.times
	end

	if self.type_special ~= nil then
		data.type_special = {}
		for name,bo in pairs(self.type_special) do
			if bo then
				table.insert(data.type_special, name)
			end
		end
	end

	if self.type_eat ~= "veggie" then
		data.type_eat = self.type_eat
	end
	if self.type_shape ~= "dusty" then
		data.type_shape = self.type_shape
	end

    if self.prefabs ~= nil then
		data.prefabs = {}
		for name,bo in pairs(self.prefabs) do
			if bo then
				table.insert(data.prefabs, name)
			end
		end
	end

	if self.eviled then
		data.eviled = true
	end

    return data
end

function FishHomingBait:OnLoad(data)
    if data ~= nil then
        if data.times ~= nil then
			self.times = data.times
		end

		if data.type_special ~= nil then
			self.type_special = {}
			for _,name in pairs(data.type_special) do
				self.type_special[name] = true
			end
		end

		if data.type_eat ~= nil then
			self.type_eat = data.type_eat
		end
		if data.type_shape ~= nil then
			self.type_shape = data.type_shape
		end

		if data.prefabs ~= nil then
			self.prefabs = {}
			for _,name in pairs(data.prefabs) do
				self.prefabs[name] = true
			end
		end

		if data.eviled then
			self.eviled = true
		end

		self:InitSelf()
    end
end

function FishHomingBait:Handover(baiting)
    local baitcpt = baiting.components.fishhomingbait
	baitcpt.times = self.times
	baitcpt.prefabs = self.prefabs
	baitcpt.type_eat = self.type_eat
	baitcpt.type_shape = self.type_shape
	baitcpt.type_special = self.type_special
	baitcpt:InitSelf()
end

function FishHomingBait:GetPreys()
	local preys = { normal = nil, special = nil, allweight = nil }
	local chance_lit = 1
	local chance_low = 3
	local chance_med = 5
	local chance_high = 8
	local list = {
		oceanfish_small_1 = { --小孔雀鱼
			hardy = nil, pasty = nil, dusty = chance_high,
			meat = chance_med, veggie = chance_med, monster = chance_low
		},
		oceanfish_small_2 = { --针鼻喷墨鱼
			hardy = nil, pasty = chance_med, dusty = chance_high,
			meat = chance_med, veggie = chance_med, monster = chance_low
		},
		oceanfish_small_3 = { --小饵鱼
			hardy = chance_low, pasty = chance_med, dusty = chance_high,
			meat = chance_high, veggie = nil, monster = nil
		},
		oceanfish_small_4 = { --三文鱼苗
			hardy = chance_med, pasty = nil, dusty = chance_high,
			meat = chance_med, veggie = chance_med, monster = chance_low
		},
		oceanfish_small_5 = { --爆米花鱼
			hardy = nil, pasty = chance_lit, dusty = chance_lit,
			meat = nil, veggie = chance_lit, monster = nil,
			comical = 0.2
		},
		oceanfish_small_6 = { --落叶比目鱼
			hardy = 0, pasty = nil, dusty = nil,
			meat = nil, veggie = 0, monster = nil,
			wrinkled = 0.01
		},
		oceanfish_small_7 = { --花朵金枪鱼
			hardy = 0, pasty = 0, dusty = nil,
			meat = nil, veggie = 0, monster = nil,
			fragrant = 0.01
		},
		oceanfish_small_8 = { --炽热太阳鱼
			hardy = nil, pasty = nil, dusty = 0,
			meat = 0, veggie = nil, monster = nil,
			hot = 0.01
		},
		oceanfish_small_9 = { --口水鱼
			hardy = nil, pasty = 0, dusty = 0,
			meat = nil, veggie = 0, monster = nil,
			slippery = 0.1
		},
		oceanfish_medium_1 = { --泥鱼
			hardy = chance_high, pasty = nil, dusty = nil,
			meat = chance_med, veggie = chance_med, monster = chance_med
		},
		oceanfish_medium_2 = { --斑鱼
			hardy = chance_high, pasty = chance_high, dusty = nil,
			meat = chance_high, veggie = nil, monster = nil
		},
		oceanfish_medium_3 = { --浮夸狮子鱼
			hardy = chance_high, pasty = chance_med, dusty = nil,
			meat = chance_high, veggie = nil, monster = chance_med
		},
		oceanfish_medium_4 = { --黑鲶鱼
			hardy = chance_high, pasty = nil, dusty = nil,
			meat = chance_high, veggie = nil, monster = chance_high
		},
		oceanfish_medium_5 = { --玉米鳕鱼
			hardy = chance_low, pasty = chance_lit, dusty = nil,
			meat = nil, veggie = chance_lit, monster = nil,
			comical = 0.2
		},
		oceanfish_medium_6 = { --花锦鲤
			hardy = nil, pasty = nil, dusty = 0,
			meat = 0, veggie = 0, monster = nil,
			lucky = 0.1
		},
		oceanfish_medium_7 = { --金锦鲤
			hardy = nil, pasty = nil, dusty = 0,
			meat = 0, veggie = 0, monster = nil,
			lucky = 0.1
		},
		oceanfish_medium_8 = { --冰鲷鱼
			hardy = nil, pasty = 0, dusty = nil,
			meat = 0, veggie = 0, monster = 0,
			frozen = 0.01
		},
		oceanfish_medium_9 = { --甜味鱼
			hardy = nil, pasty = nil, dusty = 0,
			meat = nil, veggie = 0, monster = nil,
			sticky = 0.1
		},
		squid = { --鱿鱼
			hardy = 0, pasty = 0, dusty = 0,
			meat = 0, veggie = nil, monster = 0,
			shiny = 0.02
		},
		shark = { --岩石大白鲨
			hardy = nil, pasty = 0, dusty = 0,
			meat = 0, veggie = nil, monster = 0,
			bloody = 0.02
		},
		gnarwail = { --一角鲸
			hardy = 0, pasty = nil, dusty = nil,
			meat = 0, veggie = nil, monster = nil,
			whispering = 0.04
		},
		wobster_sheller = { --龙虾
			hardy = nil, pasty = nil, dusty = 0,
			meat = nil, veggie = nil, monster = 0,
			rotten = 0.1
		},
		wobster_moonglass = { --月光龙虾
			hardy = nil, pasty = 0, dusty = nil,
			meat = nil, veggie = nil, monster = nil,
			rusty = 0.1
		},
		spider_water = { --海黾
			hardy = nil, pasty = nil, dusty = 0,
			meat = 0, veggie = nil, monster = 0,
			shaking = 0.1
		},
		grassgator = { --草鳄鱼
			hardy = nil, pasty = nil, dusty = 0,
			meat = nil, veggie = 0, monster = nil,
			grassy = 0.04
		},
		puffin = { --海鹦鹉
			hardy = nil, pasty = nil, dusty = 0,
			meat = nil, veggie = nil, monster = nil,
			frizzy = 0.06
		},
		malbatross = { --邪天翁
			hardy = nil, pasty = nil, dusty = nil,
			meat = nil, veggie = nil, monster = 0,
			evil = 0.09
		},
		cookiecutter = { --饼干切割机
			hardy = 0, pasty = nil, dusty = nil,
			meat = nil, veggie = 0, monster = 0,
			salty = 0.09
		}
	}

	if TheWorld.state.isspring then
		list.oceanfish_small_7.fragrant = 0.1
	elseif TheWorld.state.issummer then
		list.oceanfish_small_8.hot = 0.1
	elseif TheWorld.state.isautumn then
		list.oceanfish_small_6.wrinkled = 0.1
	else
		list.oceanfish_medium_8.frozen = 0.1
	end

	if self.ongetpreysfn ~= nil then
		self.ongetpreysfn(self.inst, preys, list)
	end

	local allweight = 0
	local weight = 0
	local specialchance = 0
	local specialmult = 1
	for prefab,data in pairs(list) do
		if data ~= nil then
			if self.type_special ~= nil then
				for k,bo in pairs(self.type_special) do
					if bo and data[k] ~= nil then
						specialchance = specialchance + data[k]
					end
				end
			end

			if specialchance > 0 then --说明是特殊对象
				if data[self.type_eat] ~= nil then
					specialmult = specialmult + 0.25
				end
				if data[self.type_shape] ~= nil then
					specialmult = specialmult + 0.25
				end

				if preys.special == nil then
					preys.special = {}
				end
				preys.special[prefab] = specialchance*specialmult
			else
				if data[self.type_eat] ~= nil then
					weight = weight + data[self.type_eat]
				end
				if data[self.type_shape] ~= nil then
					weight = weight + data[self.type_shape]
				end
				if weight > 0 then
					if preys.normal == nil then
						preys.normal = {}
					end
					preys.normal[prefab] = { min = allweight, max = allweight+weight }
					allweight = allweight+weight
				end
			end

			weight = 0
			specialchance = 0
			specialmult = 1
		end
	end

	if preys.normal ~= nil or preys.special ~= nil then
		if allweight > 0 then
			preys.allweight = allweight
		end
		self.preys = preys
	else
		self.preys =  nil
	end
end

local function GetRandomPoint(x, y, z, radius, forceradius)
    local rad = forceradius or math.random()*(radius or 1)
    local angle = math.random() * 2 * PI

    return x + rad * math.cos(angle), y, z - rad * math.sin(angle)
end
function FishHomingBait:GetSpawnPoint(x, y, z, radius)
	local x2, y2, z2 = GetRandomPoint(x, y, z, radius, nil)
	local offset = FindSwimmableOffset(Vector3(x2, y2, z2), math.random()*2*PI, 2, 8, false, nil, nil, true)
	if offset then
		return x2+offset.x, y2+offset.y, z2+offset.z
	end
end

function FishHomingBait:SpawnBaited(prefab, x,y,z)
	if self.spawnbaitedfn ~= nil and self.spawnbaitedfn(self.inst, prefab, x,y,z) then
		return true
	end

	---------------鱿鱼

	if prefab == "squid" then
		local x2, y2, z2 = self:GetSpawnPoint(x, y, z, math.random()*8+10)
		if x2 == nil then return end
		local herds = TheSim:FindEntities(x, y, z, TUNING.SCHOOL_SPAWNER_FISH_CHECK_RADIUS,
							{ "herd" }, nil, nil)
		local herdtoadd = nil

		for _,v in ipairs(herds) do
			if
				v.components.herd ~= nil and
				v.components.herd.membertag == prefab and
				not v.components.herd:IsFull()
			then
				herdtoadd = v
				break
			end
		end
		if herdtoadd == nil then
			herdtoadd = SpawnPrefab("squidherd")
			if herdtoadd ~= nil then
				herdtoadd.Transform:SetPosition(x2, y2, z2)
			end
		end
		if herdtoadd ~= nil then
			local squid = SpawnPrefab(prefab)
			squid.Transform:SetPosition(x2, y2, z2)
			squid:PushEvent("spawn")
			squid:AddTag("baited")
			herdtoadd.components.herd:AddMember(squid)
		end

		return true
	end

	---------------岩石大白鲨

	if prefab == "shark" then
		local x2, y2, z2 = self:GetSpawnPoint(x, y, z, math.random()*8+10)
		if x2 == nil then return end
		if TheWorld.Map:GetPlatformAtPoint(x2, z2) == nil then
			local shark = SpawnPrefab(prefab)
			shark.Transform:SetPosition(x2, 0, z2)
			shark.components.amphibiouscreature:OnEnterOcean()
			shark.sg:GoToState("eat_pre")
			shark:AddTag("baited")
			local player = FindClosestPlayerInRangeSq(x2, 0, z2, 20*20, true)
			if player then
				shark:ForceFacePoint(player.Transform:GetWorldPosition())
			end
			return true
		end

		return
	end

	---------------一角鲸

	if prefab == "gnarwail" then
		local x2, y2, z2 = self:GetSpawnPoint(x, y, z, math.random()*8+6)
		if x2 == nil then return end
		if TheWorld.Map:GetPlatformAtPoint(x2, z2) == nil then
			local gnarwail = SpawnPrefab(prefab)
			gnarwail.Transform:SetPosition(x2, 0, z2)
			gnarwail.sg:GoToState("emerge")
			gnarwail:AddTag("baited")
			return true
		end

		return
	end

	---------------龙虾、月光龙虾、海黾、草鳄鱼

	if
		prefab == "wobster_sheller" or prefab == "wobster_moonglass" or
		prefab == "spider_water" or
		prefab == "grassgator" or
		prefab == "cookiecutter"
	then
		local x2, y2, z2
		if prefab == "grassgator" or prefab == "cookiecutter" then
			x2, y2, z2 = self:GetSpawnPoint(x, y, z, math.random()*10+8)
		else
			x2, y2, z2 = self:GetSpawnPoint(x, y, z, 10)
		end
		if x2 == nil then return end
		local baited = SpawnPrefab(prefab)
		baited.Transform:SetPosition(x2, 0, z2)
		baited:AddTag("baited")

		return true
	end

	---------------海鹦鹉

	if prefab == "puffin" then
		local birdspawner = TheWorld.components.birdspawner
		if birdspawner == nil then return end

		local x2, y2, z2 = GetRandomPoint(x, y, z, 12, nil)
		if x2 == nil then return end
		local bird = birdspawner:SpawnBird(Vector3(x2, y2, z2), true)
		if bird ~= nil then
			bird:AddTag("baited")
		end

		return true
	end

	---------------邪天翁

	if prefab == "malbatross" and not self.eviled then
		local x2, y2, z2 = self:GetSpawnPoint(x, y, z, math.random()*10+10)
		if x2 == nil then return end
		local the_malbatross = TheSim:FindFirstEntityWithTag("malbatross") or SpawnPrefab("malbatross")
		if the_malbatross ~= nil then
			the_malbatross.Physics:Teleport(x2, y2, z2)
			the_malbatross.components.knownlocations:RememberLocation("home", Vector3(x2, y2, z2))
			-- the_malbatross.components.entitytracker:TrackEntity("feedingshoal", target_shoal)
			the_malbatross.sg:GoToState("arrive")
			the_malbatross:AddTag("baited")
			self.eviled = true
		end

		return true
	end

	---------------其他鱼类

	local x2, y2, z2 = self:GetSpawnPoint(x, y, z, 12)
	if x2 == nil then return end
	local herdtag = "herd_"..prefab
	local herds = TheSim:FindEntities(x, y, z, TUNING.SCHOOL_SPAWNER_FISH_CHECK_RADIUS,
						{ "herd" }, nil, nil)
	local herdtoadd = nil

	for _,v in ipairs(herds) do --寻找附近一个群体自动加入
		if
			v.components.herd ~= nil and
			v.components.herd.membertag == herdtag and
			not v.components.herd:IsFull()
		then
			herdtoadd = v
			break
		end
	end
	if herdtoadd == nil then
		herdtoadd = SpawnPrefab("schoolherd_"..prefab)
		if herdtoadd ~= nil then
			herdtoadd.Transform:SetPosition(x2, y2, z2)
		end
	end
	if herdtoadd ~= nil then
		local fish = SpawnPrefab(prefab)
		if fish ~= nil then
			fish.Physics:Teleport(x2, y2, z2)
			fish.Transform:SetRotation(math.random()*360)
			fish.components.herdmember:Enable(true)
			fish.components.herdmember.herdprefab = herdtoadd.prefab
			fish.sg:GoToState("arrive")
			fish:AddTag("baited")
			herdtoadd.components.herd:AddMember(fish)
		end
	end

	return true
end

local function SpawnChumPieces(inst)
    if inst._num_chumpieces < 8 then
        local x, y, z = inst.Transform:GetWorldPosition()
        local x2, y2, z2 = GetRandomPoint(x, y, z, 3, nil)
        if TheWorld.Map:IsOceanAtPoint(x2, 0, z2, false) then
            local piece = SpawnPrefab("chumpiece")

            piece.Transform:SetPosition(x2, 0, z2)
            piece._source = inst

			if piece.components.edible ~= nil then
				local rand = math.random()
				if rand < 0.25 then
					piece.components.edible.secondaryfoodtype = FOODTYPE.BERRY
				elseif rand < 0.5 then
					piece.components.edible.secondaryfoodtype = FOODTYPE.VEGGIE
				end
			end

            inst._chumpieces[piece] = true
            inst._num_chumpieces = inst._num_chumpieces + 1

            piece:ListenForEvent("onremove", function(piece)
				local chum_aoe = piece._source
				if chum_aoe ~= nil then
					chum_aoe._chumpieces[piece] = nil
					chum_aoe._num_chumpieces = chum_aoe._num_chumpieces - 1
					if chum_aoe.persists then
						chum_aoe:_spawn_chum_piece_fn()
					end
				end
			end)
        end
    end
end
function FishHomingBait:SpawnChums()
	if self.task_chums ~= nil then
		return
	end

	self.inst._chumpieces = {}
    self.inst._num_chumpieces = 0
	self.inst._spawn_chum_piece_fn = SpawnChumPieces
	if self.onspawnchumsfn ~= nil then
		self.onspawnchumsfn(self.inst)
	end
	self.task_chums = self.inst:DoPeriodicTask(0.6, self.inst._spawn_chum_piece_fn)
	self.inst:ListenForEvent("onremove", function(inst)
		for k,_ in pairs(inst._chumpieces) do
			if k:IsValid() then
				k:Remove()
			end
		end
	end)
end

function FishHomingBait:Baiting(periodtime)
	if self.times <= 0 then
		self:RemoveSelf()
		return
	end

	if periodtime == nil then
		if self.type_shape == "hardy" then
			periodtime = 16
		elseif self.type_shape == "pasty" then
			periodtime = 10
		else
			periodtime = 6
		end
		self:GetPreys()
	end

	if self.preys == nil then
		self:RemoveSelf()
		return
	end

	self.task_baiting = self.inst:DoTaskInTime(periodtime+math.random()*2.5-1, function(inst)
		self.task_baiting = nil
		if self.preys == nil then
			self:RemoveSelf()
			return
		end

		local x, y, z = inst.Transform:GetWorldPosition()
		local numbaited = #TheSim:FindEntities(x, y, z, 20,
						{ "baited" }, { "INLIMBO" }, nil)
		if numbaited < 20 then
			if self.preys.special ~= nil then
				local rand = nil
				local hasspecial = false
				for prefab,chance in pairs(self.preys.special) do
					if chance ~= nil then
						rand = math.random()
						if rand < chance then
							if self:SpawnBaited(prefab, x,y,z) then --吸引到才减少次数
								self.times = self.times - 1
							end
							hasspecial = true
						end
					end
				end
				if hasspecial then
					self:Baiting(periodtime)
					return
				end
			end
			if self.preys.normal ~= nil then
				local rand = math.random()*self.preys.allweight
				for prefab,data in pairs(self.preys.normal) do
					if data and rand >= data.min and rand < data.max then
						if self:SpawnBaited(prefab, x,y,z) then --吸引到才减少次数
							self.times = self.times - 1
						end
						break
					end
				end
			end
		else
			if math.random() < 0.25 then
				self.times = self.times - 1
			end
		end

		self:Baiting(periodtime)
	end)
	self:SpawnChums()
end

function FishHomingBait:RemoveSelf()
	if self.task_baiting ~= nil then
		self.task_baiting:Cancel()
		self.task_baiting = nil
	end
	if self.task_chums ~= nil then
		self.task_chums:Cancel()
		self.task_chums = nil
	end
	-- self.inst._chumpieces = nil
    -- self.inst._num_chumpieces = nil
	-- self.inst._spawn_chum_piece_fn = nil

	self.inst.SoundEmitter:KillSound("spore_loop")
    self.inst.persists = false
    -- self.inst:RemoveTag("chum")
    self.inst:DoTaskInTime(2, self.inst.Remove) --anim len + 0.5 sec
    self.inst.AnimState:PlayAnimation("fish_chum_base_pst")
end

return FishHomingBait
