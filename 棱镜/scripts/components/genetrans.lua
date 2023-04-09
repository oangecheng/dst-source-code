local GeneTrans = Class(function(self, inst)
	self.inst = inst

	self.energytime = TUNING.TOTAL_DAY_TIME*40 --当前能量时间
	self.energytime_max = self.energytime --最大能量时间

	self.seed = nil --播下的种子的prefab名
	self.seednum = 0 --已放入的种子数量
	self.seeddata = nil --该异种的配置参数
	self.fruitnum = 0 --转化完成的异种数量

	self.genepool = { --基因池
		--种子名 = true
	}

	self.taskgrow = nil
	self.timedata = {
		start = nil, --当前task开始的时间点
		pass = nil, --单个的已经生长的时间
		all = nil --单个的总体生长时间
	}

	self.fxdata = {
		prefab = "siving_turn_fruit", symbol = "followed", x = 0, y = 0, z = 0,
		skinname = "siving_turn", bloom = true, unlockfx = "siving_turn_unlock_fx"
	}
	self.fx = nil
end)

local function SetLight(self, islight)
	if islight then
		self.inst.Light:Enable(true)
		if self.fxdata.bloom then
			self.inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
		end
		-- if self.fx ~= nil then --太亮了，还是别弄这个
		-- 	self.fx.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
		-- end
	else
		self.inst.Light:Enable(false)
		self.inst.AnimState:ClearBloomEffectHandle()
		-- if self.fx ~= nil then
		-- 	self.fx.AnimState:ClearBloomEffectHandle()
		-- end
	end
end
local function SpawnFx(self)
	self.fx = SpawnPrefab(self.fxdata.prefab)

	local skindata = self.inst.components.skinedlegion:GetSkinedData()
	if skindata ~= nil and skindata.fn_fruit ~= nil then
		skindata.fn_fruit(self)
	end

	self.fx.entity:SetParent(self.inst.entity)
	-- self.fx.entity:AddFollower()
	self.fx.Follower:FollowSymbol(
		self.inst.GUID, self.fxdata.symbol, --TIP: 跟随通道时，默认跟随通道文件夹里ID=0的
		self.fxdata.x, self.fxdata.y, self.fxdata.z
	)
end
local function SetAnims(self) --有果子时设置各种动画
	--设置本体的动画
	if self.energytime > 0 then
		if self.inst:IsAsleep() then
			self.inst.AnimState:PlayAnimation("on", true)
		else
			self.inst.AnimState:PlayAnimation("idle_to_on")
			self.inst.AnimState:PushAnimation("on", true)
		end
	else
		self.inst.AnimState:PlayAnimation("idle", false)
	end

	--设置果实的动画
	if self.fx == nil or not self.fx:IsValid() then
		SpawnFx(self)
	end
	self.fx.AnimState:OverrideSymbol("swap", self.seeddata.swap.build, self.seeddata.swap.file)
	if self.seeddata.swap.symboltype == "3" then
		self.fx.AnimState:Show("SWAPFRUIT-3")
		self.fx.AnimState:Hide("SWAPFRUIT-2")
		self.fx.AnimState:Hide("SWAPFRUIT-1")
	elseif self.seeddata.swap.symboltype == "2" then
		self.fx.AnimState:Hide("SWAPFRUIT-3")
		self.fx.AnimState:Show("SWAPFRUIT-2")
		self.fx.AnimState:Hide("SWAPFRUIT-1")
	else
		self.fx.AnimState:Hide("SWAPFRUIT-3")
		self.fx.AnimState:Hide("SWAPFRUIT-2")
		self.fx.AnimState:Show("SWAPFRUIT-1")
	end
end
local function GetLootFruit(self, doer, loot)
	if self.fruitnum > 0 then
		local num = 0
		if self.seeddata.fruitnum_min ~= nil then
			if self.seeddata.fruitnum_min >= self.seeddata.fruitnum_max then
				num = num + self.fruitnum*self.seeddata.fruitnum_min
			else
				for i = 1, self.fruitnum, 1 do
					num = num + math.random(self.seeddata.fruitnum_min, self.seeddata.fruitnum_max)
				end
			end
		else
			for i = 1, self.fruitnum, 1 do
				num = num + math.random(1, 2)
			end
		end
		self:SpawnStackDrop(self.seeddata.fruit, num, self.inst:GetPosition(), doer, loot)
	end
end
local function OnPickedFn(inst, doer)
	local cpt = inst.components.genetrans
	local loot = {}
	GetLootFruit(cpt, doer, loot)
	if doer ~= nil then
		doer:PushEvent("picksomething", { object = inst, loot = loot })
	end
	cpt.fruitnum = 0
	if cpt.seednum <= 0 then --没有在转化的了
		cpt.seed = nil
		cpt.seeddata = nil
		cpt.seednum = 0
		cpt.timedata.start = nil
		cpt.timedata.all = nil
		cpt.timedata.pass = nil
		if cpt.fx ~= nil then
			cpt.fx:Remove()
			cpt.fx = nil
		end
		if cpt.energytime <= 0 then
			inst.AnimState:PlayAnimation("idle", false)
		else
			inst.AnimState:PlayAnimation("on_to_idle")
			inst.AnimState:PushAnimation("idle", false)
		end
		SetLight(cpt, false)
	else
		cpt:UpdateFxProgress()
	end
	cpt:TriggerPickable(false)
end

function GeneTrans:SpawnStackDrop(name, num, pos, doer, items)
	local item = SpawnPrefab(name)
	if item == nil then
		item = SpawnPrefab("siving_rocks")
	end
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

		if items ~= nil then
			table.insert(items, item)
		end
        item.Transform:SetPosition(pos:Get())
        if item.components.inventoryitem ~= nil then
			if doer ~= nil and doer.components.inventory ~= nil then
				doer.components.inventory:GiveItem(item, nil, pos)
			else
				if not item:HasTag("heavy") then --巨大作物不知道为啥不能弹射
					item.components.inventoryitem:OnDropped(true)
				end
			end
        end

		if num >= 1 then
			self:SpawnStackDrop(name, num, pos, doer)
		end
	end
end

function GeneTrans:DropLoot(needrecipe)
	local lootmap = {}
	local pos = self.inst:GetPosition()
	--原始物品
	if self.seednum > 0 then
		lootmap[self.seed] = self.seednum
	end
	--转化产物
	GetLootFruit(self, nil, nil)
	--建筑材料
	if needrecipe then
		local recipe = AllRecipes[self.inst.prefab]
		if recipe then
			local recipeloot = self.inst.components.lootdropper:GetRecipeLoot(recipe)
			for _,v in ipairs(recipeloot) do
				lootmap[v] = (lootmap[v] or 0) + 1
			end
		end
	end
	--基因池物品
	for seedname, isfull in pairs(self.genepool) do
		if isfull then
			local keyname = TRANS_DATA_LEGION[seedname].genekey
			if keyname ~= nil then
				lootmap[keyname] = (lootmap[keyname] or 0) + 1
			end
		end
	end
	--最终产生
	for name, num in pairs(lootmap) do
		self:SpawnStackDrop(name, num, pos, nil, nil)
	end
end

function GeneTrans:UpdateFxProgress() --更新果实进度动画
	if self.fx == nil then
		return
	end

	local percent = 1
	if self.timedata.all ~= nil then
		local alltime = (self.fruitnum + self.seednum) * self.timedata.all
		if alltime > 0 then
			percent = ( self.fruitnum*self.timedata.all + (self.timedata.pass or 0) ) / alltime
		end
	end
	if percent >= 1 then
		self.fx.AnimState:PlayAnimation(self.energytime <= 0 and "fruit_max" or "fruit_max_on", false)
	else --无语子，动画末尾的呈现状态总是不对，缺了最后一块，怎么调都不行，只能单独做个满的动画
		self.fx.AnimState:SetPercent(self.energytime <= 0 and "fruit" or "fruit_on", percent)
	end
end

function GeneTrans:SetUp(seeds, doer)
	if doer ~= nil and self.inst.components.pickable ~= nil then --先把已完成的拿下来
        self.inst.components.pickable:Pick(doer)
    end

	if TRANS_DATA_LEGION[seeds.prefab] == nil then --不能转化
		return false, "WRONGITEM"
	end
	if TRANS_DATA_LEGION[seeds.prefab].genekey ~= nil and not self.genepool[seeds.prefab] then --基因池未解锁
		return false, "NOGENE"
	end
	if self.energytime <= 0 then --没能量了
		return false, "ENERGYOUT"
	end
	if self.seed ~= nil then --已有种子
		if self.seednum > 0 then --还有在转化的
			if self.seed ~= seeds.prefab then --正在转化的和要放入的不一样
				--拿下已有的种子，准备放入新种子了
				self:SpawnStackDrop(self.seed, self.seednum, self.inst:GetPosition(), doer, nil)
				self.seed = nil
				self.seeddata = nil
				self.seednum = 0
				self.timedata.start = nil
				self.timedata.all = nil
				self.timedata.pass = nil
				-- return false, "GROWING"
			end
		end
	end

	--基础数据
	self.seeddata = TRANS_DATA_LEGION[seeds.prefab]
	self.seed = seeds.prefab
	if seeds.components.stackable ~= nil then
		self.seednum = self.seednum + seeds.components.stackable:StackSize()
	else
		self.seednum = self.seednum + 1
	end

	--设置动画
	SetAnims(self)

	--undo 声音
	-- inst.SoundEmitter:PlaySound("dontstarve/halloween_2018/madscience_machine/idle_LP", "loop")

	--删除种子实体
	-- if doer ~= nil and doer.components.inventory ~= nil then
	-- 	local item = doer.components.inventory:RemoveItem(seeds, true, false)
	-- 	item:Remove()
	-- else
	-- 	seeds:Remove()
	-- end
	seeds:Remove()

	--开始基因转化
	self.timedata.all = self.seeddata.time or TUNING.TOTAL_DAY_TIME
	self:StartTransing()
	self:UpdateFxProgress()
	if self.energytime > 0 then
		SetLight(self, true)
	end

    return true
end

function GeneTrans:CostEnergy(cost)
	local old = self.energytime
	cost = old - cost
	if cost <= 0 then
		self.energytime = 0
		if self.taskgrow ~= nil then
			self.taskgrow:Cancel()
			self.taskgrow = nil
		end
		self.timedata.start = nil
	else
		self.energytime = math.min(self.energytime_max, cost)
	end

	if self.energytime <= 0 then --没有能量
		SetLight(self, false)
		if old > 0 and self.seed ~= nil then
			if self.inst:IsAsleep() then
				self.inst.AnimState:PlayAnimation("idle", false)
			else
				self.inst.AnimState:PlayAnimation("on_to_idle")
				self.inst.AnimState:PushAnimation("idle", false)
			end
		elseif not self.inst.AnimState:IsCurrentAnimation("on_to_idle") then
			self.inst.AnimState:PlayAnimation("idle", false)
		end
	else
		if self.seed ~= nil then
			SetLight(self, true)
			if old <= 0 then
				if self.inst:IsAsleep() then
					self.inst.AnimState:PlayAnimation("on", true)
				else
					self.inst.AnimState:PlayAnimation("idle_to_on")
					self.inst.AnimState:PushAnimation("on", true)
				end
			elseif not (self.inst.AnimState:IsCurrentAnimation("on") or self.inst.AnimState:IsCurrentAnimation("idle_to_on")) then
				self.inst.AnimState:PlayAnimation("on", true)
			end
		else
			SetLight(self, false)
			self.inst.AnimState:PlayAnimation("idle", false)
		end
	end
end

function GeneTrans:TriggerPickable(can)
	if can == nil then
		can = self.fruitnum > 0
	end
    if can then
		if self.inst.components.pickable == nil then
			self.inst:AddComponent("pickable")
			self.inst.components.pickable.onpickedfn = OnPickedFn
			self.inst.components.pickable:SetUp(nil)
			-- self.inst.components.pickable.use_lootdropper_for_product = true
			self.inst.components.pickable.picksound = "dontstarve/common/destroy_magic"
		end
	elseif self.inst.components.pickable ~= nil then
		self.inst:RemoveComponent("pickable")
	end
end

function GeneTrans:StartTransing()
	if self.taskgrow ~= nil then
		self.taskgrow:Cancel()
		self.taskgrow = nil
	end

	if self.seednum <= 0 or self.seed == nil then
		return
	end

	if self.timedata.pass == nil then
		self.timedata.pass = 0
	end
	if self.energytime <= 0 then
		self.timedata.start = nil
		return
	else
		self.timedata.start = GetTime()
	end

	if not self.inst:IsAsleep() then
		self.taskgrow = self.inst:DoTaskInTime(9+math.random()*2, function(inst, self)
			self.taskgrow = nil
			self:LongUpdate(GetTime()-self.timedata.start)
		end, self)
	end
end

function GeneTrans:LongUpdate(dt, costtime)
	if self.timedata.all == nil or self.energytime <= 0 then
		return
	end
	if dt == nil or dt < 0 then
		return
	end

	if self.timedata.pass == nil then
		self.timedata.pass = 0
	elseif self.timedata.pass >= self.timedata.all then --确保 all 比 pass 大
		self.seednum = math.max(0, self.seednum - 1)
		self.fruitnum = self.fruitnum + 1
		self:TriggerPickable()
		if self.seednum <= 0 then --全部完成
			self.timedata.start = nil
			self.timedata.pass = nil
			self.timedata.all = nil
			if self.taskgrow ~= nil then
				self.taskgrow:Cancel()
				self.taskgrow = nil
			end
			self:UpdateFxProgress()
			return
		else
			self.timedata.pass = self.timedata.pass - self.timedata.all
			if self.timedata.pass >= self.timedata.all then
				self:LongUpdate(dt, costtime)
				return
			end
		end
	end

	dt = math.min(self.energytime, dt) --得到能量范围内最大的经过时间
	local needtime = self.timedata.all - self.timedata.pass --单个的剩余需求时间
	if needtime <= dt then --完成了单个
		self.seednum = math.max(0, self.seednum - 1)
		self.fruitnum = self.fruitnum + 1
		self:TriggerPickable()
		costtime = (costtime or 0) + needtime
		if self.seednum <= 0 then --全部完成
			self.timedata.start = nil
			self.timedata.pass = nil
			self.timedata.all = nil
			if self.taskgrow ~= nil then
				self.taskgrow:Cancel()
				self.taskgrow = nil
			end
			self:CostEnergy(costtime)
			self:UpdateFxProgress()
			return
		else
			self.timedata.pass = 0
			dt = dt - needtime
		end
	else
		costtime = (costtime or 0) + dt
		self.timedata.pass = self.timedata.pass + dt
		dt = 0
	end

	if dt > 0 then --还有时间可以经过
		self:LongUpdate(dt, costtime)
	else
		self:CostEnergy(costtime)
		self:StartTransing()
		self:UpdateFxProgress()
	end
end

function GeneTrans:OnEntitySleep()
    if self.taskgrow ~= nil then
		self.taskgrow:Cancel()
		self.taskgrow = nil
	end
end

function GeneTrans:OnEntityWake()
	if self.timedata.start == nil or self.energytime <= 0 then
		return
	end

	self:LongUpdate(GetTime()-self.timedata.start)
end

function GeneTrans:OnSave()
    local data = {}

	if self.seed ~= nil then
		data.seed = self.seed
		if self.seednum > 0 then
			data.seednum = self.seednum
		end
		if self.fruitnum > 0 then
			data.fruitnum = self.fruitnum
		end
		if self.timedata.all ~= nil then
			if self.timedata.start ~= nil then
				data.time_dt = GetTime() - self.timedata.start
			end
			if self.timedata.pass ~= nil and self.timedata.pass > 0 then
				data.time_pass = self.timedata.pass
			end
		end
	end
	if self.energytime < self.energytime_max then
		data.energytime = self.energytime
	end

	local genepool = nil
	for seedname, isfull in pairs(self.genepool) do
		if isfull then
			if genepool == nil then
				genepool = {}
			end
			table.insert(genepool, seedname)
		end
	end
	if genepool ~= nil then
		data.genepool = genepool
	end

    return data
end

function GeneTrans:OnLoad(data, newents)
	if data.energytime ~= nil then
		self.energytime = math.min(data.energytime, self.energytime_max)
	end
	if data.genepool ~= nil then
		for _, value in ipairs(data.genepool) do
			if TRANS_DATA_LEGION[value] ~= nil then
				self.genepool[value] = true
			end
		end
	end

	local seedname = nil
	if data.seed ~= nil then
		if type(data.seed) == "table" then --兼容以前的数据格式
			seedname = data.seed.prefab
		else
			seedname = data.seed
		end
	end
	if data.fruit ~= nil then --兼容以前的数据格式
		for name, value in pairs(TRANS_DATA_LEGION) do
			if value.fruit == data.fruit then
				seedname = name
				break
			end
		end
	end
	if seedname ~= nil and seedname ~= "" then
		if TRANS_DATA_LEGION[seedname] == nil then
			self:CostEnergy(0)
			return
		end
		if data.seednum ~= nil and data.seednum > 0 then
			self.seednum = data.seednum
		end
		if data.fruitnum ~= nil and data.fruitnum > 0 then
			self.fruitnum = data.fruitnum
			self:TriggerPickable()
		elseif data.fruit ~= nil then --旧数据格式有果子，说明已经成功了1个
			self.fruitnum = 1
			self:TriggerPickable()
		end
		if self.fruitnum <= 0 and self.seednum <= 0 then --什么都没有？那就是默认带有1个未转化的
			self.seednum = 1
		end

		self.seeddata = TRANS_DATA_LEGION[seedname]
		self.seed = seedname
		SetAnims(self)

		if self.seednum > 0 then --还有需要转化的，所以继续判定时间
			local dt = data.time_dt or 0
			self.timedata.all = self.seeddata.time or TUNING.TOTAL_DAY_TIME
			self.timedata.pass = data.time_pass or 0
			if dt > 0 or self.timedata.pass > 0 then --有多余的时间：循环更新
				self:LongUpdate(dt, 0)
			else --无多余时间：更新能量状态、继续转化、更新进度
				self:CostEnergy(0)
				self:StartTransing()
				self:UpdateFxProgress()
			end
		else --转化完成：更新能量状态、更新进度
			self:CostEnergy(0)
			self:UpdateFxProgress()
		end
	else --无种子：需要更新能量状态
		self:CostEnergy(0)
	end
end

function GeneTrans:Charge(items, doer)
    if self.energytime >= self.energytime_max then
		return false, "ENERGYMAX"
	end

	local addtime = items.sivturnenergy or TUNING.TOTAL_DAY_TIME
	local needtime = self.energytime_max - self.energytime
	local itemtime = 0

	if items.components.stackable ~= nil then
		local num = items.components.stackable:StackSize() or 1
		local numused = 0
		for i = 1, num, 1 do
			numused = i
			itemtime = itemtime + addtime
			if itemtime >= needtime then
				break
			end
		end
		items.components.stackable:Get(numused):Remove()
	else
		itemtime = addtime
		items:Remove()
	end

	self:CostEnergy(-itemtime)
	self:StartTransing()
	self:UpdateFxProgress()

	return true
end

function GeneTrans:UnlockGene(items, doer)
	local seed = nil
    for seedname, data in pairs(TRANS_DATA_LEGION) do
		if items.prefab == data.genekey then
			seed = seedname
			break
		end
	end
	if seed == nil then
		return false, "WRONGKEY"
	elseif self.genepool[seed] then
		return false, "HASKEY"
	else
		self.genepool[seed] = true
		if items.components.stackable ~= nil then
			items.components.stackable:Get(1):Remove()
		else
			items:Remove()
		end

		local fx = SpawnPrefab(self.fxdata.unlockfx)
		if fx ~= nil then
			fx.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
		end
		self.inst.SoundEmitter:PlaySound("wintersfeast2019/winters_feast/table/fx")
	end

	return true
end

return GeneTrans
