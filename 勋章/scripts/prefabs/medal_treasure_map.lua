local sign_assets =
{
	Asset("MINIMAP_IMAGE", "messagebottletreasure_marker"),
}

local prefabs =
{
    "medal_toy_chest",
	"treasurechest",
}

--接穗列表
local scion_loot={}

--获取果树数据
local MEDAL_FRUIT_TREE_DEFS = require("medal_defs/medal_fruit_tree_defs").MEDAL_FRUIT_TREE_DEFS
if MEDAL_FRUIT_TREE_DEFS then
	for k, v in pairs(MEDAL_FRUIT_TREE_DEFS) do
		if v.switch and not v.nomagic then
			table.insert(scion_loot, v.name.."_scion")
		end
	end
end
--稀有道具列表
local good_loot={
	medal_plant_book = 12,--植物图鉴
	mandrake_seeds = 20,--曼德拉种子
	medaldug_fruit_tree_stump = 20,--砧木桩
	immortal_book = 8,--不朽之谜
	monster_book = 6,--怪物图鉴
	unsolved_book = 10,--未解之谜
	medal_moonglass_potion = 18,--月光药水
	medal_dustmothden_base = 1,--尘蛾巢台
	medal_skin_coupon = 5,--皮肤券
}
--其他填充物列表
local normal_loot={
	thulecite = 6,--铥矿
	thulecite_pieces = 8,--铥矿碎片
	fossil_piece = 7,--化石碎片
	medal_obsidian = 5,--红晶
	medal_blue_obsidian = 2,--蓝晶
	glommerfuel = 12,--格罗姆粘液
	goldnugget = 12,--金块
	nitre = 8,--硝石
	mosquitosack = 8,--蚊子血囊
	medal_weed_seeds = 6,--杂草种子
	moonrocknugget=10,--月岩
	townportaltalisman=8,--砂之石
	moonglass=8,--玻璃碎片
}

--将道具加入奖励表(奖励表,预制物名,数量)
local function addRewardToLoot(rewardloot,prefab,num)
	if rewardloot and rewardloot[prefab] then
		rewardloot[prefab] = rewardloot[prefab] + (num or 1)
	else
		rewardloot[prefab] = num or 1
	end
end

--获取宝藏奖励表
local function getTreasureLoot(inst)
	local treasureitems={}
	local randnum=math.random()--神秘宝藏随机值
	--神秘宝藏
	if randnum<TUNING_MEDAL.SURPRISE_TREASURE_CHANCE then
		treasureitems={
			redgem = 1,--红宝石
			bluegem = 1,--蓝宝石
			purplegem = 1,--紫宝石
			orangegem = 1,--橙宝石
			yellowgem = 1,--黄宝石
			greengem = 1,--绿宝石
			opalpreciousgem = 1,--彩虹宝石
		}
		--不朽宝石
		if randnum<TUNING_MEDAL.SURPRISE_TREASURE_BETTER_CHANCE then
			treasureitems["immortal_gem"] = 1
		end
		--时空宝石
		if randnum<TUNING_MEDAL.SURPRISE_TREASURE_BEST_CHANCE then
			treasureitems["medal_space_gem"] = 1
		end
	else--普通宝藏
		addRewardToLoot(treasureitems,weighted_random_choice(good_loot),1)--随机稀有道具
		addRewardToLoot(treasureitems,GetRandomItem(scion_loot),1)--随机接穗
		addRewardToLoot(treasureitems,PickRandomTrinket(),1)--随机玩具
		addRewardToLoot(treasureitems,PickRandomTrinket(),1)--随机玩具
		addRewardToLoot(treasureitems,"medal_spacetime_lingshi",math.random(2,4))--2~4个时空灵石
		if math.random()<.3 then--概率额外获得一个弯曲的叉子
			addRewardToLoot(treasureitems,"trinket_17",1)
		end
		--加入其它填充物
		for i = 1, 3 do
			addRewardToLoot(treasureitems,weighted_random_choice(normal_loot),1)
		end
	end
	return treasureitems
end

local function onfinishcallback(inst, worker)
	local x,y,z=inst.Transform:GetWorldPosition()
	if inst.ischild then
		local chest=SpawnPrefab("medal_toy_chest")
		chest.Transform:SetPosition(x,y,z)
	else
		local chest=SpawnPrefab("treasurechest")
		chest.Transform:SetPosition(x,y,z)
		local treasureitems = inst.treasurechloot or getTreasureLoot(inst)
		
		if chest.components.container then
			for k, v in pairs(treasureitems) do
				local treasureitem=SpawnPrefab(k)
				if treasureitem then 
					if v>1 and treasureitem.components.stackable then
						treasureitem.components.stackable:SetStackSize(v)
					end
					chest.components.container:GiveItem(treasureitem)
				end
			end
		end
	end
	
	SpawnPrefab("sand_puff_large_front").Transform:SetPosition(x,y,z)
	inst:Remove()
end
--时空宝藏
local function onfinishspacetime(inst,worker)
	local x,y,z=inst.Transform:GetWorldPosition()
	local chest=SpawnPrefab("medal_spacetime_chest")
	chest.Transform:SetPosition(x,y,z)
	local treasureitems={
		medal_space_gem = 1,--时空宝石
		medal_time_slider = math.random(8,12),--时空碎片
		medal_spacetime_runes = 5,--时空符文
		medal_spacetime_potion = 10,--改命药水
	}
	treasureitems[weighted_random_choice(good_loot)]=1--随机稀有道具
	treasureitems[GetRandomItem(scion_loot)]=1--随机接穗
	treasureitems[PickRandomTrinket()]=1--随机玩具
	-- treasureitems[GetRandomItem(normal_loot)] = math.random(1,3)--随机填充物
	if inst.snacks_num then
		-- print(inst.snacks_num)
		local num = math.floor(inst.snacks_num*2/3)
		if num > 0 then
			treasureitems.medal_spacetime_snacks_packet = math.min(num,40)--零食包装袋
		end
	end
	--没有包装袋的话，赏你一个尘蛾巢台
	if treasureitems.medal_spacetime_snacks_packet==nil then
		treasureitems["medal_dustmothden_base"]=1
	end
		
	if chest.components.container then
		for k, v in pairs(treasureitems) do
			local treasureitem=SpawnPrefab(k)
			if treasureitem then 
				if v>1 and treasureitem.components.stackable then
					treasureitem.components.stackable:SetStackSize(v)
				end
				chest.components.container:GiveItem(treasureitem)
			end
		end
		--生成时空吞噬者雕像皮肤券
		local skin_coupon = SpawnPrefab("medal_skin_coupon")
		if skin_coupon then
			if skin_coupon.setSkinData then
				skin_coupon:setSkinData("medal_statue_marble_changeable",6)
			end
			chest.components.container:GiveItem(skin_coupon)
		end
	end
	
	SpawnPrefab("medal_spacetime_puff").Transform:SetPosition(x,y,z)
	inst:Remove()
end

local function ondig(inst, worker, workleft)
	if worker and workleft>0 then
		local x,y,z=worker.Transform:GetWorldPosition()
		local root = inst.prefab=="medal_treasure" and SpawnPrefab("deciduous_root") or SpawnPrefab("medal_gestalt")
		if root then
			root.Transform:SetPosition(x,y,z)
		end
	end
end
--添加萤火虫
local function addFireflies(inst)
	inst.ischild=true
	inst.Light:Enable(true)
    inst.AnimState:PlayAnimation("idle_1",true)
end

--定义宝藏
local function MakeTreasure(def)
	local treasure_assets =
	{
		Asset("ANIM", "anim/"..def.build..".zip"),
		Asset("MINIMAP_IMAGE", "messagebottletreasure_marker"),
	}

	local function onsavefn(inst,data)
		if inst.ischild then
			data.ischild=true
		end
		if inst.snacks_num and inst.snacks_num>0 then
			data.snacks_num = inst.snacks_num
		end
		--保存宝藏信息
		if inst.treasurechloot then
			data.treasurechloot = shallowcopy(inst.treasurechloot)
		end
	end
	
	local function onloadfn(inst,data)
		if data then
			if data.ischild then
				addFireflies(inst)
			end
			if data.snacks_num then
				inst.snacks_num = data.snacks_num
			end
			if data.treasurechloot then
				inst.treasurechloot=shallowcopy(data.treasurechloot)
			end
		end
	end
	
	local function treasure_fn()
		local inst = CreateEntity()
	
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddMiniMapEntity()
		inst.entity:AddNetwork()

		if def.isnormal then
			inst.entity:AddLight()
			inst.Light:SetFalloff(0.7)
			inst.Light:SetIntensity(.5)
			inst.Light:SetRadius(0.5)
			inst.Light:SetColour(180/255, 195/255, 150/255)
			inst.Light:Enable(false)
			inst.Light:EnableClientModulation(true)
		end
		
		inst.MiniMapEntity:SetIcon("messagebottletreasure_marker.png")
		inst.MiniMapEntity:SetPriority(6)
		
		inst.AnimState:SetBank(def.build)
		inst.AnimState:SetBuild(def.build)
		inst.AnimState:PlayAnimation("idle_3",true)
		
		inst:AddTag("medal_treasure")
	
		inst.entity:SetPristine()
	
		if not TheWorld.ismastersim then
			return inst
		end
	
		inst:AddComponent("inspectable")
		
		inst:AddComponent("lootdropper")
	
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.DIG)
		inst.components.workable:SetWorkLeft(10)--需要挖十下
		inst.components.workable:SetOnFinishCallback(def.isnormal and onfinishcallback or onfinishspacetime)
		inst.components.workable:SetOnWorkCallback(ondig)
		
		if def.isnormal then
			inst.addFireflies=addFireflies
			inst.getTreasureLoot = getTreasureLoot--获取宝藏内容
		end

		inst.OnSave = onsavefn
		inst.OnLoad = onloadfn
	
		return inst
	end
	return Prefab(def.name, treasure_fn, treasure_assets, prefabs)
end

--获取藏宝点(藏宝图,探测仪)
local function getTreasurePoint(inst,resonator)
	if inst.treasure_data then
		return inst.treasure_data--有坐标点信息了就直接return
	end
	
	local MAXTRIES = 100--最大尝试生成次数
	local max_tries=MAXTRIES--最大尝试生成次数
	local radius=50--两个宝藏的最小距离
	local w, h = TheWorld.Map:GetSize()
	w = (w - w/2) * TILE_SCALE
	h = (h - h/2) * TILE_SCALE
	local ix,iy,iz=inst.Transform:GetWorldPosition()--获取探测仪坐标
	local prior_radius = TILE_SCALE*40--宝藏优先生成半径(40格地皮)
	local min_spacing = TILE_SCALE*20--宝藏生成点和当前探测仪至少间隔20地皮
	local is_vicinity = math.random() < TUNING_MEDAL.TREASURE_POS_NEARBY_CHANCE--是否尽量尝试在附近生成
	while (max_tries > 0) do
		local x, z
		if is_vicinity then
			local try_radius = prior_radius+(MAXTRIES-max_tries)*TILE_SCALE--尝试生成范围,每次尝试半径增加1格地皮
			x, z = (math.random()*2-1)*math.min(try_radius,w)+ix, (math.random()*2-1)*math.min(try_radius,h)+iz
		else
			x, z = (math.random()*2-1)*w, (math.random()*2-1)*h
		end
		x, z = x-x%0.01, z-z%0.01--保留两位小数
		max_tries = max_tries - 1
		
		if distsq(x, z, ix, iz) > min_spacing * min_spacing--距离不能太近
		and TheWorld.Map:IsAboveGroundAtPoint(x, 0, z, false)
		and TheWorld.Map:GetTileAtPoint(x, 0, z) <= GROUND.SCALE 
		and not TheWorld.Map:NodeAtPointHasTag(x, 0, z, "not_mainland")--只能在主大陆生成
		and (resonator == nil or TheWorld.Map:CanDeployAtPoint(Vector3(x, 0, z), resonator)) then--坐标点必需可以部署探测仪
			inst.treasure_data={ worldid = TheShard:GetShardId(), x = x, z = z}--记录藏宝点信息
			-- print(x,z,max_tries)
			return inst.treasure_data
		end
	end

end

--物品触发天道酬勤后执行
local function doRewardToiler(inst)
	inst.toiler_sign = (inst.toiler_sign or 0) + 1
end

--定义藏宝图
local function MakeTreasureMap(def)
	local map_assets =
	{
		Asset("ANIM", "anim/"..def.name..".zip"),
		Asset("ATLAS", "images/"..def.name..".xml"),
		Asset("ATLAS_BUILD", "images/"..def.name..".xml",256),
	}

	local function mapsavefn(inst,data)
		--保存藏宝点信息
		if inst.treasure_data then
			data.treasure_data=shallowcopy(inst.treasure_data)
		end
		--保存宝藏信息
		if inst.treasurechloot then
			data.treasurechloot = shallowcopy(inst.treasurechloot)
		end
		--包果价值
		if inst.gift_fruit_value then
			data.gift_fruit_value = inst.gift_fruit_value
		end
		--已预言标记
		if inst.isprophesied then
			data.isprophesied = inst.isprophesied
		end
		--天道酬勤标记
		if inst.toiler_sign then
			data.toiler_sign = inst.toiler_sign
		end
	end
	
	local function maploadfn(inst,data)
		--读取藏宝点信息
		if data then
			if data.treasure_data then
				inst.treasure_data=shallowcopy(data.treasure_data)
			end
			if data.treasurechloot then
				inst.treasurechloot=shallowcopy(data.treasurechloot)
			end
			if data.gift_fruit_value then
				inst.gift_fruit_value=data.gift_fruit_value
			end
			if data.isprophesied then
				inst.isprophesied=data.isprophesied
			end
			if data.toiler_sign then
				inst.toiler_sign=data.toiler_sign
			end
		end
	end
	
	local function map_fn()
		local inst = CreateEntity()
	
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
		
		MakeInventoryPhysics(inst)
		
		inst.AnimState:SetBank(def.bank)
		inst.AnimState:SetBuild(def.build)
		inst.AnimState:PlayAnimation(def.anim)
		
		MakeInventoryFloatable(inst,"med",nil, 0.75)
		inst.entity:SetPristine()
		
		inst:AddTag("medal_treasure_map")--勋章的藏宝图
		inst:AddTag("medal_predictable")--可被预言
		if def.taglist then
			for _,v in ipairs(def.taglist) do
				inst:AddTag(v)
			end
		end
		
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst:AddComponent("inspectable")
	
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = def.name
		inst.components.inventoryitem.atlasname = "images/"..def.name..".xml"

		inst:AddComponent("fuel")
    	inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

		MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    	MakeSmallPropagator(inst)
		
		inst.spawnTreasure = def.spawnTreasure--生成宝藏
		inst.getTreasurePoint = getTreasurePoint--获取藏宝点
		inst.reward_toiler_fn = doRewardToiler--天道酬勤
		
		inst.OnSave = mapsavefn
		inst.OnLoad = maploadfn
		if def.masterfn then
			def.masterfn(inst)
		end
	
		return inst
	end
	return Prefab(def.name, map_fn, map_assets)
end

--地图标记
local function sign_fn()
	local inst = CreateEntity()
	inst.entity:SetCanSleep(false)
	inst.persists = false
	
	inst.entity:AddTransform()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()

	inst.MiniMapEntity:SetIcon("messagebottletreasure_marker.png")
	inst.MiniMapEntity:SetPriority(6)
	
	-- inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("CLASSIFIED")

	if not TheWorld.ismastersim then
        return inst
	end

	inst:DoTaskInTime(TUNING_MEDAL.MEDAL_TREASURE_SIGN_TIME, inst.Remove)
	
	return inst
end

local treasure_map_loot={
	medal_treasure_map={--普通藏宝图
		name="medal_treasure_map",
		build="medal_treasure_map",
		bank="medal_treasure_map",
		anim="medal_treasure_map",
		spawnTreasure=function(inst,resonator)--生成宝藏
			local treasure = SpawnPrefab("medal_treasure")
			treasure.Transform:SetPosition(resonator.Transform:GetWorldPosition())
            --获取宝藏数据,宿命
            if inst.treasurechloot then
                treasure.treasurechloot = shallowcopy(inst.treasurechloot)
            elseif treasure.getTreasureLoot then
                treasure:getTreasureLoot()
            end
		end,
		masterfn=function(inst)
			inst.treasurechloot = getTreasureLoot(inst)--获取宝藏奖励表
			inst.runesSpawnTreasure = function(inst,doer)--时空符文快速挖宝
				local x,y,z = doer.Transform:GetWorldPosition()
				local chest = SpawnPrefab("medal_treasure_chest")
				if chest ~= nil then
					chest.Transform:SetPosition(x,y,z)
					if chest.components.container then
						local treasureitems = inst.treasurechloot or getTreasureLoot(inst)
						for k, v in pairs(treasureitems) do
							local treasureitem = SpawnPrefab(k)
							if treasureitem then 
								if v>1 and treasureitem.components.stackable then
									treasureitem.components.stackable:SetStackSize(v)
								end
								chest.components.container:GiveItem(treasureitem)
							end
						end
						chest.components.container:Open(doer)--直接打开
					end
				end
			end
		end,
	},
	medal_loss_treasure_map={--遗失藏宝图
		name="medal_loss_treasure_map",
		build="medal_loss_treasure_map",
		bank="medal_loss_treasure_map",
		anim="medal_loss_treasure_map",
		taglist={"medal_tradeable"},--可和雕像交易
		spawnTreasure=function(inst,resonator)--生成宝藏
			if resonator then
				local gift_value = math.clamp(inst.gift_fruit_value,TUNING_MEDAL.GIFT_FRUIT_VALUE_MIN,TUNING_MEDAL.GIFT_FRUIT_VALUE_MAX)
				local loot = {
					medal_gift_fruit_seed = math.floor(gift_value/4),--种子数量
					medal_gift_fruit = gift_value%4,--果实数量
				}
				local pt = resonator:GetPosition()

				for k, v in pairs(loot) do
					if v>0 then
						local item = SpawnPrefab(k)
						if item then
							if item.components.stackable then
								item.components.stackable:SetStackSize(v)
							end
							if resonator.components.lootdropper then
								resonator.components.lootdropper:FlingItem(item,pt)
							else
								item.Transform:SetPosition(pt.x,pt.y,pt.z)
							end
						end
					end
				end
			end
		end,
		masterfn=function(inst)
			inst.gift_fruit_value = TUNING_MEDAL.GIFT_FRUIT_VALUE_MAX--包果价值
			inst.nofindfn=function(inst)--没找到宝藏
				inst.gift_fruit_value = math.max(inst.gift_fruit_value-1,TUNING_MEDAL.GIFT_FRUIT_VALUE_MIN)
			end
			inst.ProphesyFn=function(inst)--预言
				if not inst.isprophesied then
					inst.isprophesied = true--被预言过的标记
					inst.gift_fruit_value = math.max(inst.gift_fruit_value-3,TUNING_MEDAL.GIFT_FRUIT_VALUE_MIN)
				end
			end
			inst.runesSpawnTreasure = function(inst,doer)--时空符文快速挖宝
				local x,y,z = doer.Transform:GetWorldPosition()
				local chest = SpawnPrefab("medal_treasure_chest")
				if chest ~= nil then
					chest.Transform:SetPosition(x,y,z)
					if chest.components.container then
						local gift_value = math.clamp(inst.gift_fruit_value,TUNING_MEDAL.GIFT_FRUIT_VALUE_MIN,TUNING_MEDAL.GIFT_FRUIT_VALUE_MAX)
						local loot = {
							medal_gift_fruit_seed = math.floor(gift_value/4),--种子数量
							medal_gift_fruit = gift_value%4,--果实数量
						}

						for k, v in pairs(loot) do
							if v>0 then
								local item = SpawnPrefab(k)
								if item then
									if item.components.stackable then
										item.components.stackable:SetStackSize(v)
									end
									chest.components.container:GiveItem(item)
								end
							end
						end
						chest.components.container:Open(doer)--直接打开
					end
				end
			end
		end,
	},
}

return MakeTreasureMap(treasure_map_loot["medal_treasure_map"]),
	MakeTreasureMap(treasure_map_loot["medal_loss_treasure_map"]),
	Prefab("medal_treasure_sign", sign_fn, sign_assets),
	MakeTreasure({name="medal_treasure",build="medal_treasure",isnormal=true}),
	MakeTreasure({name="medal_spacetime_treasure",build="medal_spacetime_treasure"})