local easing = require("easing")

--设置随机皮肤
local function setRandomSkinMedal(item,player)
	--生成皮肤
	local skin_list={}--皮肤列表
	if item:IsValid() and PREFAB_SKINS[item.prefab] ~= nil then
		if player~=nil and player:HasTag("player") then
			for _,item_type in pairs(PREFAB_SKINS[item.prefab]) do
				--如果玩家能使用皮肤，插入皮肤列表
				if TheInventory:CheckClientOwnership(player.userid, item_type) then
					table.insert(skin_list,item_type)
				end
			end
			if #skin_list>0 then
				--更改目标皮肤（目标全局标识符，原皮肤名，新皮肤名，xxx，玩家ID）
				TheSim:ReskinEntity(item.GUID, item.skinname, skin_list[math.random(#skin_list)], nil, player.userid )
			end
		end
	end
end

--打乱算法
local function disorganize(loot,key)
	local new_loot={}
	key = key or math.random()
	for k,v in ipairs(loot) do
		-- if key == 0 then key = math.random() end--虽然loot数量有上限,但是后面多余的部分固定也无所谓
		table.insert(new_loot,math.max(math.ceil(k*key),1),v)
		key = key*10%1
	end
	return new_loot
end

------------------------献祭加成函数(书本,玩家,献祭品表,召唤物表,是否不消耗)-----------------------------
local function doSacrifice(inst,player,itemlist,summonedlist,noconsume)
	local weight_list=deepcopy(summonedlist)--权重统计表
	local weight_add_list={}--权重加成表
	local chance_list={}--概率统计表(优先级高于权重,可叠加,适合做保底)
	--获取玩家坐标并对周围献祭品进行统计
	local x, y, z = player.Transform:GetWorldPosition()
	local ents=TheSim:FindEntities(x, y, z, TUNING_MEDAL.BOOK_SACRIFICE_RADIUS,nil, { "INLIMBO","player","fx"})
	--显示范围圈
	if #ents>0 then
		for i,v in ipairs(ents) do
			--如果献祭品列表里有对应献祭品，则对权重进行增值
			local sdata = itemlist[v.prefab]
			if sdata ~= nil then
				--需要通过特殊检查才能进行献祭
				if sdata.testfn==nil or sdata.testfn(player) then
					--不能有特定标签才能献祭
					if not sdata.notag or not v:HasTag(sdata.notag) then
						local itemnum= v.components.stackable and v.components.stackable:StackSize() or 1--献祭品数量
						local consumenum=itemnum--祭品需消耗数量
						if sdata.chance then--概率增值
							chance_list[sdata.key] = math.min((chance_list[sdata.key] or 0) + sdata.chance * consumenum,(sdata.maxchance or 1))
						elseif sdata.weight then--权重增值登记
							if weight_add_list[sdata.key] == nil then
								weight_add_list[sdata.key]={
									num=0,
									weight=0
								}
							end
							local wdata = weight_add_list[sdata.key]
							if sdata.maxnum then
								consumenum=math.min(itemnum,sdata.maxnum-wdata.num)
							end
							if consumenum>0 then
								wdata.num=wdata.num+consumenum
								wdata.weight=wdata.weight+sdata.weight*consumenum
							end
						end

						if consumenum>0 and not noconsume then
							--播放献祭动画
							if not sdata.nofx then
								SpawnMedalFX(sdata.fx or "spawn_fx_tiny",v)
							end
							--移除献祭品
							if v.components.stackable then
								v.components.stackable:Get(consumenum):Remove()
							else
								v:Remove()
							end
						end
					end
				end
			end
		end
	end

	local destiny = GetMedalDestiny(inst)--宿命
	--优先在概率池中获取key
	for k, v in pairs(chance_list) do
		if destiny < v then
			return k
		end
	end
	--权重增值
	for k, v in ipairs(weight_list) do
		if weight_add_list[v.key] then
			v.weight=v.weight+weight_add_list[v.key].weight
		end
	end
	weight_list = disorganize(weight_list,destiny)--打乱
	return GetMedalRandomItem(weight_list,destiny)--返回权重增值后的随机key
end

--高礼帽函数(预置物,是否是特殊的)
local function setTopHatFn(item,isspecial)
	item:AddTag("notdevourable")--不可吞噬
	if item.components.equippable then
		item:RemoveComponent("equippable")
	end
	--设置检查语句
	if item.components.inspectable then
		if isspecial or math.random()<.5 then
			item.components.inspectable:SetDescription(STRINGS.UNSOLVEDSPEECH.HATTRICK_RABBIT)
		else
			item.components.inspectable:SetDescription(STRINGS.UNSOLVEDSPEECH.HATTRICK_MEDAL)
		end
	end
	if item.components.inventoryitem then
		local x,y,z=item.Transform:GetWorldPosition()
		item.components.inventoryitem:SetOnPickupFn(function(inst, pickupguy, src_pos)
			if src_pos then 
				x,y,z=src_pos:Get()
			end
			local ents = TheSim:FindEntities(x, y, z, 6,{"notdevourable"} , { "INLIMBO" })
			inst:Remove()--移除帽子
			SpawnPrefab("explode_reskin").Transform:SetPosition(x,y,z)
			local magic_prop = SpawnPrefab(isspecial and "silence_certificate" or "rabbit")--生成勋章或者兔子
			magic_prop.Transform:SetPosition(x,y,z)
			--掀开一个帽子后移除周围其他的帽子
			if #ents>0 then
				for i,v in ipairs(ents) do
					if v.prefab=="tophat" then
						SpawnPrefab("explode_reskin").Transform:SetPosition(v.Transform:GetWorldPosition())
						v:Remove()
					end
				end
			end
			return true
		end)
	end
end

--获取陆地生成点
local function GetSpawnPoint(pt,spawn_dist)
	if not TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) then
        pt = FindNearbyLand(pt, 1) or pt
    end
    local offset = FindWalkableOffset(pt, math.random() * 2 * PI, spawn_dist, 12, true, true, function(pt) return not TheWorld.Map:IsPointNearHole(pt) end)
    if offset ~= nil then
        offset.x = offset.x + pt.x
        offset.z = offset.z + pt.z
        return offset
    end
	return pt
end
--获取海洋生成点
local function GetSpawnWaterPoint(pt,spawn_dist)
	local offset = FindSwimmableOffset(pt, math.random() * 2 * PI, spawn_dist, 12, true, true, function(pt) return not TheWorld.Map:IsPointNearHole(pt) end,true)
    if offset ~= nil then
        offset.x = offset.x + pt.x
        offset.z = offset.z + pt.z
        return offset
    end
	return pt
end

--在玩家附近生成一个怪物
local function SpawnMonster(player,monstername,iswater,monster_data)
    local pt = player:GetPosition()
	local spawn_dist = monster_data and monster_data.spawn_dist or 20--生成距离,鹿鸭近一点,其他远一点
    local spawn_pt = iswater and GetSpawnWaterPoint(pt,spawn_dist) or GetSpawnPoint(pt,spawn_dist)
    if spawn_pt ~= nil then
		local monster = SpawnPrefab(monstername)
		if monster then
			monster.Physics:Teleport(spawn_pt:Get())
			monster:FacePoint(pt)
			if monster.components.combat then
				monster.components.combat:SetTarget(player)
				-- monster.components.combat:SuggestTarget(player)
			end
		end
        
        return monster
    end
end

--祭品列表,chance概率增值(优先级高于权重),weight权重增值,key召唤物名,fx动画特效
local chesspiece_list={
	land={
		chesspiece_deerclops={weight=12,key="deerclops",fx="collapse_small"},--巨鹿
		chesspiece_bearger={weight=12,key="bearger",fx="collapse_small"},--熊大
		chesspiece_moosegoose={weight=12,key="moose",fx="collapse_small"},--鹿鸭
		chesspiece_dragonfly={weight=12,key="dragonfly",fx="collapse_small"},--蜻蜓
		chesspiece_beequeen={weight=12,key="beequeen",fx="collapse_small"},--蜂后
		chesspiece_toadstool={weight=12,key="toadstool",fx="collapse_small"},--蛤蟆
		chesspiece_minotaur={weight=6,maxnum=10,key="minotaur",fx="collapse_small"},--犀牛
		bottled_soul={weight=35,key="medal_rage_krampus",fx="messagebottle_break_fx"},--瓶装灵魂--暗夜坎普斯
		fruitflyfruit={weight=35,key="lordfruitfly",notag="fruitflyfruit",fx="collapse_small"},--友好果蝇果--果蝇王
		medal_spacetime_snacks={weight=50,key="medal_spacetime_devourer",fx="pocketwatch_heal_fx",testfn=function(inst)
			return TheWorld and TheWorld:HasTag("forest") and not TheSim:FindFirstEntityWithTag("medal_spacetime_devourer")
		end},--时空碎片--时空吞噬者
		voidcloth={weight=6,key="medal_shadowthrall_screamer",fx="collapse_small",testfn=function(inst)
			local fossil_stalker = FindEntity(inst, TUNING_MEDAL.BOOK_SACRIFICE_RADIUS, function(inst)
				return inst.prefab=="fossil_stalker" and inst.form == 2 and inst.moundsize == 8 
			end, {"structure","trader"}, nil, nil)
			return fossil_stalker ~= nil
		end},--暗影碎布--驱光遗骸
	},
	water={
		chesspiece_malbatross={weight=2,key="malbatross",fx="collapse_small"},--邪天翁
	}
}
--怪物列表(key怪物名,value权重)
local monster_loot={
	land={
		{key="deerclops",weight=2},--巨鹿
		{key="bearger",weight=2},--熊大
		{key="moose",weight=2},--鹿鸭
		{key="dragonfly",weight=2},--蜻蜓
		{key="leif",weight=5},--树精
		{key="spiderqueen",weight=5},--蜘蛛女王
		{key="warg",weight=5},--座狼
		{key="spat",weight=5},--钢羊
		{key="minotaur",weight=1},--远古守卫
		{key="beequeen",weight=1},--蜂后
		{key="toadstool",weight=1},--蛤蟆
		{key="medal_rage_krampus",weight=0},--暗夜坎普斯
		{key="lordfruitfly",weight=0},--果蝇王
		{key="medal_spacetime_devourer",weight=0},--时空吞噬者
		{key="medal_shadowthrall_screamer",weight=0},--驱光遗骸
	},
	water={
		{key="malbatross",weight=1},--邪天翁
		{key="shark",weight=2},--岩鲨
		{key="grassgator",weight=1},--草鳄鱼
		{key="gnarwail",weight=1},--一角鲸
	}
}
--怪物数据(需要特殊写的列进去就好了)
local monster_data={
	moose={--鹿鸭
		spawn_dist=5,
	},
	toadstool={--蛤蟆
		spawn_dist=10,
	},
	malbatross={--邪天翁
		spawn_dist=5,
	},
	shark={--岩鲨
		spawn_dist=5,
	},
	grassgator={--草鳄鱼
		spawn_dist=5,
	},
	gnarwail={--一角鲸
		spawn_dist=5,
	},
	medal_spacetime_devourer={--时空吞噬者,召唤时空迷雾
		special_spawn=function(reader)
			local pt = reader:GetPosition()
			if TheWorld and TheWorld.components.medal_spacetimestormmanager then
				if not TheWorld.components.medal_spacetimestormmanager:StartSpacetimestorm(TheWorld.Map:GetNodeIdAtPoint(pt.x, pt.y, pt.z)) then
					TheWorld.components.medal_spacetimestormmanager:StartSpacetimestorm()
				end
			end
		end
	},
	medal_shadowthrall_screamer={--驱光遗骸,特殊出场动画
		special_spawn=function(reader)
			local fossil_stalker = FindEntity(reader, TUNING_MEDAL.BOOK_SACRIFICE_RADIUS, function(inst)
				return inst.prefab=="fossil_stalker" and inst.form == 2 and inst.moundsize == 8 
			end, {"structure","trader"}, nil, nil)
			if fossil_stalker ~= nil then
				SpawnPrefab("medal_shadowthrall_revive_from_bones_fx").Transform:SetPosition(fossil_stalker.Transform:GetWorldPosition())
				fossil_stalker:DoTaskInTime(2, function() 
					if fossil_stalker and fossil_stalker:IsValid() then
						local monster = SpawnPrefab("medal_shadowthrall_screamer")
						if monster then
							monster.Transform:SetPosition(fossil_stalker.Transform:GetWorldPosition())
							monster.sg:GoToState("spawndelay")
							if monster.components.combat then
								monster.components.combat:SetTarget(reader)
							end
							SpawnPrefab("dreadstone_spawn_fx").Transform:SetPosition(fossil_stalker.Transform:GetWorldPosition())
							fossil_stalker:Remove()
						end
					end
				end)
			end
		end
	},
}

local un_mult = TUNING_MEDAL.UNSOLVED_ITEM_WEIGHT_MULT or 1--献祭品权重增值倍数
--未解之谜献祭品列表
local unsolved_item_list={
	land={
		atrium_key={weight=15*un_mult,key="yuangu",testfn=function(inst)
			return not (TheWorld and TheWorld:HasTag("cave"))--不能在洞穴献祭
		end},--远古钥匙--远古祭坛
		minotaurhorn={weight=15*un_mult,key="yuangu",testfn=function(inst)
			return TheWorld and TheWorld:HasTag("cave")--只能在洞穴献祭
		end},--守护者之角--远古祭坛
		spicepack={weight=4*un_mult,key="dachu"},--厨师包--大厨套装
		spiderhat={weight=5*un_mult,key="mudi"},--蜘蛛帽--蜘蛛墓碑
		lavaeel={weight=4*un_mult,key="ranshao"},--熔岩鳗鱼--浴火重生
		tentaclespots={weight=4*un_mult,key="chushou"},--触手皮--困兽之斗
		honeycomb={weight=5*un_mult,key="sharenfeng"},--蜂巢--杀人蜂窝
		beeswax={weight=5*un_mult,key="sharenfeng"},--蜂蜡--杀人蜂窝
		tophat={weight=5*un_mult,key="hattrick"},--高礼帽--帽子戏法
		moonrocknugget={weight=2*un_mult,key="liuxingyu"},--月石--流星雨
		medal_blue_obsidian={weight=5*un_mult,key="bingshan"},--蓝曜石--冰天雪地
		-- bottled_moonlight={weight=6*un_mult,key="fullmoon",testfn=function(inst)
		-- 	return not (TheWorld and TheWorld:HasTag("cave"))--不能在洞穴献祭
		-- end},--瓶装月光--月圆
		medal_chum={weight=10*un_mult,key="fishpond"},--特制鱼食--虚空钓鱼池
		barnaclestuffedfishhead={weight=2*un_mult,key="mermhead"},--酿鱼头--鱼人头
	},
	water={
		saltrock={weight=2*un_mult,key="yankuang"},--盐晶--盐矿
		kelp={weight=1*un_mult,key="kelprevenge"},--海带--复仇海带
	}
}

--未解之谜索引列表
local unsolved_index={
	land={
		{key="yuangu",weight=0},--远古祭坛
		{key="dachu",weight=1},--美味佳肴
		{key="jushi",weight=1},--方尖碑
		{key="jushier",weight=1},--反向方尖碑
		{key="mudi",weight=1},--蜘蛛墓碑
		{key="ranshao",weight=1},--浴火重生
		{key="chushou",weight=1},--困兽之斗
		{key="bingshan",weight=1},--冰天雪地
		{key="turen",weight=1},--愤怒的兔人
		{key="sharenfeng",weight=0},--杀人蜂阵
		{key="hattrick",weight=1},--帽子戏法
		{key="liuxingyu",weight=1},--昆阳之战
		-- {key="banana_forest",weight=1},--香蕉林
		-- {key="fullmoon",weight=0},--心如明月
		{key="lovekiss",weight=1},--真爱之吻
		{key="fishpond",weight=1},--虚空钓鱼池
		{key="mermhead",weight=1},--鱼人头
	},
	water={
		{key="yankuang",weight=0},--盐矿雕像
		{key="kelprevenge",weight=0},--不一样的海草
		{key="waterballet",weight=1},--水上芭蕾
		{key="haiguai",weight=1},--海上影怪
		{key="titanic",weight=1},--泰坦尼克号
	}
}

--未解之谜列表
local unsolved_loot={
	yuangu={--远古祭坛
		{item="ancient_altar",canoverlap=true},--祭坛
		{item="ruins_statue_mage",num=6,radius=4},--远古雕像
	},
	dachu={--美味佳肴
		--冰箱
		{item="icebox",itemfn=function(inst,player)
			setRandomSkinMedal(inst,player)--设置皮肤
			--放入食材
			local foodlist={
				"ice",--冰
				"berries",--浆果
				"red_cap",--红蘑菇
				"green_cap",--绿蘑菇
				"blue_cap",--蓝蘑菇
				"butterflywings",--蝴蝶翅膀
				"carrot",--胡萝卜
				"pumpkin",--南瓜
				"dragonfruit",--火龙果
				"pomegranate",--石榴
				"corn",--玉米
				"eggplant",--茄子
				"watermelon",--西瓜
				"potato",--土豆
				"kelp",--海带
				"cave_banana",--洞穴香蕉
				"smallmeat",--小肉
				"meat",--大肉
				"drumstick",--鸡腿
				"monstermeat",--怪物肉
				"plantmeat",--食人花肉
				"bird_egg",--鸡蛋
				"fishmeat",--鱼肉
				"froglegs",--蛙腿
				"honey",--蜂蜜
			}
			--随机选5-9种食材(可重复)
			for i=1,math.random(5,9) do
				local food=SpawnPrefab(GetRandomItem(foodlist))
				if food then
					--每种1-3个
					if food.components.stackable then
						food.components.stackable.stacksize = math.random(3)
					end
					if inst.components.container then
						inst.components.container:GiveItem(food)
					else
						food:Remove()
					end
				end
			end
		end},
		--锅
		{item="cookpot",num=3,radius=3,itemfn=function(inst,player)
			setRandomSkinMedal(inst,player)--设置皮肤
		end},
		--远古锅
		{item="medal_cookpot",num=3,radius=3,angle_offset=0.5,itemfn=function(inst,player)
			setRandomSkinMedal(inst,player)--设置皮肤
		end},
	},
	jushi={--方尖碑
		{item="insanityrock",num=6,radius=2},--正向方尖碑
		{playerfn=function(player)--玩家状态函数
			if player.components.sanity~=nil then
				player.components.sanity:SetPercent(0)--精神扣完
			end
		end},
	},
	jushier={--反向方尖碑
		{item="sanityrock",num=6,radius=2},--反向方尖碑
		{playerfn=function(player)--玩家状态函数
			if player.components.sanity~=nil then
				player.components.sanity:SetPercent(1)--精神回满
			end
		end},
	},
	mudi={--蜘蛛墓碑
		{item="gravestone",num=6,radius=4},--墓碑
		--花
		{item="flower",canoverlap=true,itemfn=function(item,player)
			local spiderLoot={
				"spider_warrior",--蜘蛛战士
				"spider_hider",--洞穴蜘蛛
				"spider_spitter",--喷吐蜘蛛
				"spider_dropper",--悬挂蜘蛛
				"spider_moon",--破碎蜘蛛
				"spiderqueen"--蜘蛛女王
			}
			if item.components.pickable then
				local oldonpickedfn=item.components.pickable.onpickedfn
				--设置采摘函数
				item.components.pickable.onpickedfn = function(inst, picker)
					local pos = inst:GetPosition()
					local canDugMoundCount=0--可挖的坟墓数量
					local spiderMound=nil
					local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 6,{"grave"} , { "INLIMBO" })
					--寻找周围的坟墓
					if #ents>0 then
						for i,v in ipairs(ents) do
							if v.prefab=="mound" then
								if v.components.workable~=nil then
									--如果有没挖过的坟，则计数+1，并生成对应的蜘蛛
									canDugMoundCount=math.min(canDugMoundCount+1,6)
									local spider=SpawnPrefab(spiderLoot[canDugMoundCount])
									v:RemoveComponent("workable")
									v.AnimState:PlayAnimation("dug")
									if spider.components.combat then 
										spider.components.combat:SuggestTarget(picker)
									end
									spider.Transform:SetPosition(v.Transform:GetWorldPosition())
									MedalSay(picker,STRINGS.SPIDERMEDALSPEECH.FINDSPIDER)
								end
							end
						end
					end
					--如果周围没有未挖过的坟堆，则新生成一个蜘蛛坟堆
					if canDugMoundCount==0 then
						spiderMound=SpawnPrefab("mound")
						if spiderMound~= nil then
							spiderMound.Transform:SetPosition(pos.x, pos.y, pos.z)
							MedalSay(picker,STRINGS.SPIDERMEDALSPEECH.FINDMOUND)
							if spiderMound.components.workable then
								spiderMound.components.workable:SetOnFinishCallback(function(inst, worker)
									inst.AnimState:PlayAnimation("dug")
									inst:RemoveComponent("workable")
									if worker ~= nil then
										MedalSay(worker,STRINGS.SPIDERMEDALSPEECH.GETMEDAL)
										if worker.components.sanity ~= nil then
											worker.components.sanity:DoDelta(-TUNING.SANITY_SMALL)
										end
										inst.components.lootdropper:SpawnLootPrefab("spider_certificate")
									end
								end)
							end
						end
					end
					if oldonpickedfn then
						oldonpickedfn(inst, picker)
					end 
				end
			end
		end},
	},
	ranshao={--浴火重生
		--重生护符
		{item="amulet",canoverlap=true,itemfn=function(item,player)
			setRandomSkinMedal(item,player)--设置皮肤
			item:AddTag("powerabsorbable")--可吸收能力
			local function onHauntfn(inst)
				if not inst.medal_used then
					local x, y, z = inst.Transform:GetWorldPosition()
					local newmedal = SpawnPrefab("bathingfire_certificate")
					if newmedal then
						newmedal.Transform:SetPosition(x, y, z)
						inst.medal_used=true--添加标记，防止多次生成浴火
					end
				end
			end
			--设置作祟函数
			AddHauntableCustomReaction(item, onHauntfn, false, true, false)
		end},
		--燃烧的木墙
		{item="wall_wood",num=8,radius=2,itemfn=function(item,player)
			if item.components.burnable then
				item.components.burnable:Ignite(true)
			end
		end},
	},
	chushou={--困兽之斗
		--触手
		{item="tentacle",num=6,radius=5,specialfn=function(item,player)
			if item.components.lootdropper then
				item.components.lootdropper:AddChanceLoot("tentacle_certificate", 1)
			end
		end},
		{playerfn=function(player)--玩家状态函数
			--给玩家一个大理石甲
			if player.components.inventory then
				player.components.inventory:GiveItem(SpawnPrefab("armormarble"))
			end
		end},
		--月墙
		{item="wall_moonrock",num=8,radius=2},
	},
	lovekiss={--真爱之吻
		--蚊子
		{item="mosquito",num=6,radius=5,noaggro=true,canoverlap=true,itemfn=function(item,player)
			if item.drinks then
				item.drinks=4
				item.AnimState:Show("body_4")
			end
			if item.components.lootdropper then
				item.components.lootdropper:AddChanceLoot("spice_blood_sugar", 0.5)
			end
		end},
		--月墙
		{item="wall_moonrock",num=8,radius=2},
	},
	bingshan={--冰天雪地
		{playerfn=function(player)--玩家状态函数
			--冻住玩家
			if player.components.freezable~=nil then
				player.components.freezable:AddColdness(12,10)--冰冻
			end
		end},
		{item="coldfire",num=8,radius=2,itemfn=function(item,player)
			if item.components.burnable then
				--火灭了出蓝曜石
				item.components.burnable:SetOnExtinguishFn(function(inst)
					if inst.components.lootdropper then
						inst.components.lootdropper:SpawnLootPrefab("medal_blue_obsidian")
					end
				end)
				--2分钟内火不灭就没机会了
				item:DoTaskInTime(120,function()
					item.components.burnable:SetOnExtinguishFn(nil)
				end)
			end
		end,
		specialfn=function(item,player)
			local builder = player and player.components.builder or nil
			--没学过蓝曜石制冰机则给制冰机蓝图
			local specialitem = (builder and not builder:KnowsRecipe("medal_ice_machine")) and "medal_ice_machine_blueprint" or "medal_blue_obsidian"
			if item.components.burnable then
				item.components.burnable:SetOnExtinguishFn(function(inst)
					if inst.components.lootdropper then
						inst.components.lootdropper:SpawnLootPrefab(specialitem)
					end
				end)
				item:DoTaskInTime(120,function()
					item.components.burnable:SetOnExtinguishFn(nil)
				end)
			end
		end},--冷火堆
	},
	turen={--兔人房
		{playerfn=function(player)--玩家状态函数
			--给玩家塞一块肉
			if player.components.inventory then
				player.components.inventory:GiveItem(SpawnPrefab("meat"))
			end
		end},
		{item="rabbithouse",num=6,radius=4},--兔人房
	},
	sharenfeng={--杀人蜂窝
		{item="wasphive",num=6,radius=6,specialfn=function(item,player)
			--只能在地上世界召唤凋零之蜂，并且世界上只能同时存在一个凋零之蜂(包括凋零蜂巢、蔷薇花台、血坑)
			if TheWorld and TheWorld:HasTag("forest") and not TheSim:FindFirstEntityWithTag("medal_beequeen") then
				local x,y,z=item.Transform:GetWorldPosition()
				item:ListenForEvent("death", function(inst)
					if not TheSim:FindFirstEntityWithTag("medal_beequeen") then
						SpawnPrefab("lucy_transform_fx").Transform:SetPosition(x,y,z)
						SpawnPrefab("medal_rose_terrace").Transform:SetPosition(x,y,z)
					end
				end)
			end
		end},--杀人蜂窝
	},
	hattrick={--帽子戏法
		--高礼帽
		{item="tophat",num=3,radius=3,canoverlap=true,itemfn=function(item,player)
			setRandomSkinMedal(item,player)--设置皮肤
			setTopHatFn(item,false)--普通高礼帽
		end,
		specialfn=function(item,player)
			setRandomSkinMedal(item,player)--设置皮肤
			setTopHatFn(item,true)--特殊高礼帽
		end},
	},
	liuxingyu={--流星雨
		{playerfn=function(player)--玩家状态函数
			local num_meteor = 20--流星数量
			if player~=nil then
				local px,py,pz= player.Transform:GetWorldPosition()
				player:StartThread(function()
					local hasstaff=false--是否生成了流星法杖(确保不重复生成)
					for k = 1, num_meteor do
						local theta = math.random() * 2 * PI
						local radius = easing.outSine(math.random(), math.random() * 5, 5, 1)
						local fan_offset = FindValidPositionByFan(theta, radius, 30,
							function(offset)
								return TheWorld.Map:IsPassableAtPoint(px + offset.x, py + offset.y, pz + offset.z)
							end)
						local met = SpawnPrefab("shadowmeteor")
						if not hasstaff then
							met:DoTaskInTime(0.1, function(inst)
								--如果是大流星，则有概率生成流星法杖
								if inst.size and inst.size>1 then
									if math.random()<TUNING_MEDAL.METEOR_STAFF_CHANCE then
										hasstaff=true
										inst.OnRemoveEntity=function(inst)
											local x, y, z = inst.Transform:GetWorldPosition()
											local drop=SpawnPrefab("meteor_staff")
											if drop ~= nil then
												drop.Transform:SetPosition(x, y, z)
												if drop.components.inventoryitem ~= nil then
													drop.components.inventoryitem:OnDropped(true)
												end
											end
										end
									end
								end
							end)
						end
						met.Transform:SetPosition(px + fan_offset.x, py + fan_offset.y, pz + fan_offset.z)
						Sleep(.3 + math.random() * .2)
					end
				end)
			end
		end},
	},
	fishpond={--虚空钓鱼池
		{item="medal_spacetime_pond",canoverlap=true}
	},
	mermhead={--鱼人头
		--猪人头
		{item="pighead",canoverlap=true,itemfn=function(inst,player)
			inst:ListenForEvent("medal_rebirth",function(inst,data)
				--寻找附近的鱼人头
				local mermhead = FindEntity(inst, 4, function(inst)
					return inst.prefab=="mermhead"
				end, {"beaverchewable"}, nil, nil)
				if mermhead==nil then--没有鱼人头了，解放疯猪！
					local x,y,z = inst.Transform:GetWorldPosition()
					local pigman = SpawnPrefab("pigman")
					if pigman then
						pigman.Transform:SetPosition(x, y, z)
						if pigman.components.werebeast then
							pigman.components.werebeast:TriggerDelta(4)
						end
						if inst.components.workable then
							inst.components.workable:Destroy(inst)
						end
					end
				end
			end)
		end},
		--鱼人头
		{item="mermhead",num=6,radius=3,itemfn=function(inst,player)
			if inst.components.workable then
				local oldonfinish=inst.components.workable.onfinish
				inst.components.workable.onfinish=function(inst, worker)
					--给最近的猪人头推复活事件
					local pighead = FindClosestEntity(inst, 4, true, {"beaverchewable"}, nil, nil, function(inst)
						return inst.prefab=="pighead"
					end)
					if oldonfinish then
						oldonfinish(inst, worker)
					end
					if pighead then
						pighead:PushEvent("medal_rebirth")
					end
				end
			end
		end},
	},
	yankuang={--盐矿
		{item="saltstack",num=6,radius=6,iswater=true},--盐矿
		{item="cookiecutter",num=6,radius=6,angle_offset=0.5,iswater=true},--饼干切割机
	},
	kelprevenge={--复仇海带
		--海带
		{item="bullkelp_plant",num=6,radius=5,angle_offset=0.5,iswater=true,itemfn=function(item,player)
			item:AddTag("notdevourable")--不可吞噬
			if item.components.pickable then
				local oldonpickedfn = item.components.pickable.onpickedfn
				item.components.pickable.onpickedfn=function(inst,picker)
					if oldonpickedfn then
						oldonpickedfn(inst,picker)
					end
					local x,y,z=inst.Transform:GetWorldPosition()
					local ents = TheSim:FindEntities(x, y, z, 12,{"notdevourable"} , { "INLIMBO" })
					local needtalk=false;
					-- inst:Remove()
					if #ents>0 then
						for i,v in ipairs(ents) do
							if v.prefab=="bullkelp_plant" then
								local newitem=SpawnPrefab("waterplant")
								if newitem then
									newitem.Transform:SetPosition(v.Transform:GetWorldPosition())
									if newitem.components.combat and picker then
										newitem.components.combat:SuggestTarget(picker)
									end
								end
								v:Remove()
								needtalk=true
							end
						end
					end
					if needtalk and picker then
						MedalSay(picker,STRINGS.UNSOLVEDSPEECH.BUJIANGWUDE)
					end
				end
			end
		end},
	},
	waterballet={--水上芭蕾
		{item="gnarwail",num=4,radius=6,angle_offset=0.5,iswater=true,noaggro=true},--一角鲸
		{item="squid",num=4,radius=6,iswater=true},--鱿鱼
	},
	haiguai={--海上影怪
		{item="oceanhorror",num=6,radius=5,iswater=true},
		{playerfn=function(player)--玩家状态函数
			if player.components.sanity~=nil then
				player.components.sanity:SetPercent(0)--精神扣完
			end
		end},
	},
	titanic={--泰坦尼克号
		{item="seastack",num=6,radius=6,iswater=true},--礁石
		{item="seastack",num=6,radius=7,angle_offset=0.5,iswater=true},--礁石
		{item="seastack",num=6,radius=8,iswater=true},--礁石
		{item="mast",num=4,radius=3,itemfn=function(item,player)
			setRandomSkinMedal(item,player)--设置皮肤
			if item.components.mast then
				item.components.mast:UnfurlSail()
			end
		end,
		specialfn=function(item,player)--特殊函数
			setRandomSkinMedal(item,player)--设置皮肤
			if item.components.mast then
				item.components.mast:UnfurlSail()
			end
			--额外掉落蓝宝石(海洋之心)
			if item.components.workable then
				local oldOnFinishFn = item.components.workable.onfinish
				item.components.workable:SetOnFinishCallback(function(inst, hammerer)
					if inst.components.lootdropper then
						inst.components.lootdropper:AddChanceLoot("bluegem", 1)
					end
					if oldOnFinishFn then
						oldOnFinishFn(inst,hammerer)
					end
				end)
			end
		end},
	},
}


--不朽之谜列表
local immortal_loot={
	loot1={--初始
		{key="bundlewrap",weight=4},--捆绑包装纸
		{key="beeswax",weight=1},--蜂蜡
		{key="bearger_chest_blueprint",weight=5},--熊皮宝箱蓝图
	},
	loot2={--学过熊皮宝箱
		{key="bundlewrap",weight=3},--捆绑包装纸
		{key="beeswax",weight=1},--蜂蜡
		{key="immortal_gem_blueprint",weight=3},--不朽宝石蓝图
		{key="immortal_essence",weight=1},--不朽精华
		{key="immortal_fruit",weight=2},--不朽果实
	},
	loot3={--学过不朽宝石
		{key="bundlewrap",weight=3},--捆绑包装纸
		{key="beeswax",weight=1},--蜂蜡
		{key="immortal_fruit_seed",weight=2},--不朽种子
		{key="immortal_essence",weight=1},--不朽精华
		{key="immortal_fruit",weight=3},--不朽果实
	},
}
local function GetImmortalItem(inst,reader)
	if reader then
		--学过熊皮宝箱蓝图
		if reader.components.builder and reader.components.builder:KnowsRecipe("bearger_chest") then
			--学过不朽宝石蓝图
			if reader.components.builder:KnowsRecipe("immortal_gem") then
				return GetMedalRandomItem(immortal_loot.loot3,inst)
			else
				return GetMedalRandomItem(immortal_loot.loot2,inst)
			end
		else--没学过熊皮宝箱蓝图
			return GetMedalRandomItem(immortal_loot.loot1,inst)
		end
	end
end

--植物图鉴献祭品列表
local plant_item_list={
	cave_banana={weight=1*un_mult,key="bananabush"},--香蕉--香蕉丛
	blue_cap={weight=1*un_mult,key="mushroom"},--蓝蘑菇--蘑菇怪圈
	red_cap={weight=1*un_mult,key="mushroom"},--红蘑菇--蘑菇怪圈
	green_cap={weight=1*un_mult,key="mushroom"},--绿蘑菇--蘑菇怪圈
	moonbutterflywings={weight=3*un_mult,key="moon_tree"},--月蛾翅膀--月树林
	driftwood_log={weight=6*un_mult,key="driftwood_tree"},--浮木--浮木树林
	livinglog={weight=2*un_mult,key="livingtree"},--活木--活木树林
	pinecone={weight=2*un_mult,key="evergreen_sparse"},--松果--粗壮常青树
	petals={weight=1*un_mult,key="flower_evil"},--花瓣--恶魔花园
	petals_evil={weight=1*un_mult,key="flower_evil"},--恶魔花瓣--恶魔花园
	lightbulb={weight=1*un_mult,key="flower_cave"},--荧光果--希望之光
	cactus_meat={weight=2*un_mult,key="cactus"},--仙人掌肉--沙漠绿洲
	wormlight={weight=2*un_mult,key="wormlight_plant"},--发光浆果--蓝莓果园
	berries={weight=1*un_mult,key="berrybush"},--浆果--农夫果园
	berries_juicy={weight=1*un_mult,key="berrybush"},--多汁浆果--农夫果园
	moon_cap={weight=4*un_mult,key="mushtree_moon"},--月亮蘑菇--月亮蘑菇树
	cutreeds={weight=1*un_mult,key="reeds"},--采下的芦苇--芦苇奇遇
	foliage={weight=2*un_mult,key="cave_fern"},--蕨叶--蕨叶宴
	succulent_picked={weight=2*un_mult,key="succulent_plant"},--多肉植物--多肉宴
	cutlichen={weight=3*un_mult,key="lichen"},--苔藓--洞穴苔藓

	carrot_oversized={weight=6*un_mult,key="medal_fruit_tree_carrot"},--巨型胡萝卜--胡萝卜嫁接树
	corn_oversized={weight=6*un_mult,key="medal_fruit_tree_corn"},--巨型玉米--玉米嫁接树
	potato_oversized={weight=6*un_mult,key="medal_fruit_tree_potato"},--巨型土豆--土豆嫁接树
	tomato_oversized={weight=6*un_mult,key="medal_fruit_tree_tomato"},--巨型番茄--番茄嫁接树

	asparagus_oversized={weight=4*un_mult,key="medal_fruit_tree_asparagus"},--巨型芦笋--芦笋嫁接树
	pumpkin_oversized={weight=4*un_mult,key="medal_fruit_tree_pumpkin"},--巨型南瓜--南瓜嫁接树
	eggplant_oversized={weight=4*un_mult,key="medal_fruit_tree_eggplant"},--巨型茄子--茄子嫁接树
	watermelon_oversized={weight=4*un_mult,key="medal_fruit_tree_watermelon"},--巨型西瓜--西瓜嫁接树

	garlic_oversized={weight=2*un_mult,key="medal_fruit_tree_garlic"},--巨型大蒜--大蒜嫁接树
	onion_oversized={weight=2*un_mult,key="medal_fruit_tree_onion"},--巨型洋葱--洋葱嫁接树
	dragonfruit_oversized={weight=2*un_mult,key="medal_fruit_tree_dragonfruit"},--巨型火龙果--火龙果嫁接树
	pomegranate_oversized={weight=2*un_mult,key="medal_fruit_tree_pomegranate"},--巨型石榴--石榴嫁接树
	pepper_oversized={weight=2*un_mult,key="medal_fruit_tree_pepper"},--巨型辣椒--辣椒嫁接树
	durian_oversized={weight=2*un_mult,key="medal_fruit_tree_durian"},--巨型榴莲--榴莲嫁接树

	-- medal_origin_essence={chance=.25,key="medal_origin_small_tree",fx="collapse_small",testfn=function(inst)
	-- 	local flower = FindEntity(inst, TUNING_MEDAL.BOOK_SACRIFICE_RADIUS, nil, {"medal_flower"}, nil, nil)
	-- 	return flower ~= nil
	-- end},--本源精华--本源之树
}
--植物图鉴索引列表
local plant_index={
	{key="mushroom",weight=1},--蘑菇怪圈
	{key="bananabush",weight=1},--香蕉林
	{key="moon_tree",weight=1},--月树林
	{key="driftwood_tree",weight=1},--浮木树林
	{key="livingtree",weight=1},--活木树林
	{key="evergreen_sparse",weight=1},--粗壮常青树
	{key="flower_evil",weight=1},--恶魔花园
	{key="flower_cave",weight=1},--希望之光
	{key="cactus",weight=1},--沙漠绿洲
	{key="wormlight_plant",weight=1},--蓝莓果园
	{key="berrybush",weight=1},--农夫果园
	{key="mushtree_moon",weight=1},--月亮蘑菇树
	{key="reeds",weight=1},--芦苇奇遇
	{key="cave_fern",weight=1},--蕨叶宴
	{key="succulent_plant",weight=1},--多肉宴
	{key="lichen",weight=1},--洞穴苔藓
	{key="medal_fruit_tree_carrot",weight=0},--胡萝卜嫁接树
	{key="medal_fruit_tree_pomegranate",weight=0},--石榴卜嫁接树
	{key="medal_fruit_tree_pepper",weight=0},--辣椒嫁接树
	{key="medal_fruit_tree_garlic",weight=0},--大蒜嫁接树
	{key="medal_fruit_tree_dragonfruit",weight=0},--火龙果嫁接树
	{key="medal_fruit_tree_asparagus",weight=0},--芦笋嫁接树
	{key="medal_fruit_tree_potato",weight=0},--土豆嫁接树
	{key="medal_fruit_tree_onion",weight=0},--洋葱嫁接树
	{key="medal_fruit_tree_tomato",weight=0},--番茄嫁接树
	{key="medal_fruit_tree_watermelon",weight=0},--西瓜嫁接树
	{key="medal_fruit_tree_pumpkin",weight=0},--南瓜嫁接树
	{key="medal_fruit_tree_eggplant",weight=0},--茄子嫁接树
	{key="medal_fruit_tree_corn",weight=0},--玉米嫁接树
	{key="medal_fruit_tree_durian",weight=0},--榴莲嫁接树
	-- {key="medal_origin_small_tree",weight=0},--本源之树
}

--特殊植物
local special_plant_data={
	medal_origin_small_tree = function(reader)--本源之树
		local flower = FindEntity(reader, TUNING_MEDAL.BOOK_SACRIFICE_RADIUS, nil, {"medal_flower"}, nil, nil)
		if flower ~= nil then
			local origin_tree = SpawnPrefab("medal_origin_small_tree_short")
			if origin_tree then
				origin_tree.Transform:SetPosition(flower.Transform:GetWorldPosition())
				if origin_tree.sproutfn then
					origin_tree:sproutfn()
				end
				flower:Remove()
			end
		end
	end,
}

--植物图鉴列表
local plant_loot={
	mushroom={--蘑菇怪圈
		{randomlist={
			red_mushroom = 1,--红蘑菇
			green_mushroom = 1,--绿蘑菇
			blue_mushroom = 1,--蓝蘑菇
		},num=10,radius=4},
	},
	bananabush={--香蕉之林
		--香蕉丛
		{item="bananabush",num=6,radius=5,angle_offset=0.5,itemfn=function(item,player)
			if item.components.growable then
				item.components.growable:SetStage(4)--直接变成最大阶段
			end
			item:AddTag("notdevourable")--不可吞噬
			if item.components.pickable then
				local oldonpickedfn = item.components.pickable.onpickedfn
				item.components.pickable.onpickedfn=function(inst,picker)
					local x,y,z=inst.Transform:GetWorldPosition()
					local ents = TheSim:FindEntities(x, y, z, 12,{"notdevourable"} , { "INLIMBO" })
					local needtalk=false;--是否要说感叹词
					-- inst:Remove()
					if #ents>0 then
						for i,v in ipairs(ents) do
							if v.prefab=="bananabush" then
								--每棵香蕉丛出一只猴子
								local monkey=SpawnPrefab("monkey")
								if monkey then
									monkey.Transform:SetPosition(v.Transform:GetWorldPosition())
									SpawnPrefab("small_puff").Transform:SetPosition(v.Transform:GetWorldPosition())
									if monkey.components.combat and picker then
										monkey.components.combat:SuggestTarget(picker)
									end
								end
								needtalk=true
								--重置采摘函数，免得一直出猴子
								if v.components.pickable then
									v.components.pickable.onpickedfn=oldonpickedfn
								end
								v:RemoveTag("notdevourable")
							end
						end
					end
					if needtalk and picker then
						MedalSay(picker,STRINGS.UNSOLVEDSPEECH.MONKEY_NEST)
					end
					if oldonpickedfn then
						oldonpickedfn(inst,picker)
					end
				end
			end
			if item.components.workable then
				local oldOnfinishFn=item.components.workable.onfinish
				item.components.workable:SetOnFinishCallback(function(inst,worker)
					--玩家处于可移植状态，则可获得砧木桩
					if worker and worker.medal_transplantman then
						inst.components.lootdropper:SpawnLootPrefab("medaldug_fruit_tree_stump")
						inst:Remove()
					elseif oldOnfinishFn then
						oldOnfinishFn(inst,worker)
					end
				end)
			end
		end},
	},
	moon_tree={--月树林
		{item ="moon_tree",num=8,radius=4},
	},
	driftwood_tree={--浮木树林
		{randomlist={
			driftwood_tall = 1,
			driftwood_small1 = 1,
			driftwood_small2 = 1,
		},num=6,radius=4},
	},
	livingtree={--活木树林
		{item ="livingtree",num=6,radius=4},
	},
	evergreen_sparse={--粗壮常青树
		{item ="evergreen_sparse",num=8,radius=4},
	},
	flower_evil={--恶魔花园
		{item="flower",num=1,canoverlap=true,itemfn=function(item,player)
			item:AddTag("notdevourable")--不可吞噬
			if item.components.pickable then
				local oldonpickedfn = item.components.pickable.onpickedfn
				item.components.pickable.onpickedfn=function(inst,picker)
					local x,y,z=inst.Transform:GetWorldPosition()
					local ents = TheSim:FindEntities(x, y, z, 4,{"qiyu_flower"} , { "INLIMBO" })
					--踩了中间那朵，就把周围的花变成恶魔花
					for i,v in ipairs(ents) do
						if v.prefab=="flower" and v ~= inst then
							local flower_evil=SpawnPrefab("flower_evil")
							if flower_evil then
								flower_evil.Transform:SetPosition(v.Transform:GetWorldPosition())
								v:Remove()
							end
						end
					end
					if oldonpickedfn then
						oldonpickedfn(inst,picker)
					end
				end
			end
		end},
		{item="flower",num=6,radius=2,angle_offset=0.5,itemfn=function(item,player)
			item:AddTag("qiyu_flower")
		end},
		{item="flower",num=6,radius=3,itemfn=function(item,player)
			item:AddTag("qiyu_flower")
		end},
	},
	flower_cave={--希望之光
		{randomlist={
			flower_cave = 1,--单果荧光果
			flower_cave_double = 1,--双果荧光果
			flower_cave_triple = 1,--三果荧光果
			lightflier_flower = 1,--荧光虫
		},num=9,radius=4},
	},
	cactus={--沙漠绿洲
		{randomlist={
			cactus=1,--仙人掌
			oasis_cactus=1,--沙漠仙人掌
		},num=6,radius=4},
	},
	wormlight_plant={--蓝莓果园
		{item ="wormlight_plant",num=6,radius=4},--发光蓝莓
	},
	berrybush={--农夫果园
		{randomlist={
			berrybush = 1,--浆果丛
			berrybush2 = 1,--三叶浆果丛
			berrybush_juicy = 1,--多汁浆果丛
		},num=9,radius=4},
	},
	mushtree_moon={--月亮蘑菇树
		{item ="mushtree_moon",num=6,radius=4},
	},
	reeds={--芦苇奇遇
		{item="reeds",num=5,offset=3},--芦苇
		{item="monkeytail",num=5,offset=3},--猴尾草
		{item="tentacle",num=5,offset=3,noaggro=true},--触手
	},
	cave_fern={--蕨叶宴
		{item="cave_fern",num=1,canoverlap=true},
		{item="cave_fern",num=6,radius=2,angle_offset=0.5},
		{item="cave_fern",num=6,radius=3},
		{item="cave_fern",num=8,radius=4,angle_offset=0.5},
	},
	succulent_plant={--多肉宴
		{item="succulent_plant",num=1,canoverlap=true},
		{item="succulent_plant",num=6,radius=2,angle_offset=0.5},
		{item="succulent_plant",num=6,radius=3},
		{item="succulent_plant",num=8,radius=4,angle_offset=0.5},
	},
	lichen={--洞穴苔藓
		{item ="lichen",num=8,radius=4},
	},
	medal_fruit_tree_carrot={--胡萝卜嫁接树
		{item ="medal_fruit_tree_carrot",canoverlap=true},
	},
	medal_fruit_tree_pomegranate={--石榴卜嫁接树
		{item ="medal_fruit_tree_pomegranate",canoverlap=true},
	},
	medal_fruit_tree_pepper={--辣椒嫁接树
		{item ="medal_fruit_tree_pepper",canoverlap=true},
	},
	medal_fruit_tree_garlic={--大蒜嫁接树
		{item ="medal_fruit_tree_garlic",canoverlap=true},
	},
	medal_fruit_tree_dragonfruit={--火龙果嫁接树
		{item ="medal_fruit_tree_dragonfruit",canoverlap=true},
	},
	medal_fruit_tree_asparagus={--芦笋嫁接树
		{item ="medal_fruit_tree_asparagus",canoverlap=true},
	},
	medal_fruit_tree_potato={--土豆嫁接树
		{item ="medal_fruit_tree_potato",canoverlap=true},
	},
	medal_fruit_tree_onion={--洋葱嫁接树
		{item ="medal_fruit_tree_onion",canoverlap=true},
	},
	medal_fruit_tree_tomato={--番茄嫁接树
		{item ="medal_fruit_tree_tomato",canoverlap=true},
	},
	medal_fruit_tree_watermelon={--西瓜嫁接树
		{item ="medal_fruit_tree_watermelon",canoverlap=true},
	},
	medal_fruit_tree_pumpkin={--南瓜嫁接树
		{item ="medal_fruit_tree_pumpkin",canoverlap=true},
	},
	medal_fruit_tree_eggplant={--茄子嫁接树
		{item ="medal_fruit_tree_eggplant",canoverlap=true},
	},
	medal_fruit_tree_corn={--玉米嫁接树
		{item ="medal_fruit_tree_corn",canoverlap=true},
	},
	medal_fruit_tree_durian={--榴莲嫁接树
		{item ="medal_fruit_tree_durian",canoverlap=true},
	},
}

local book_defs={
	{
		-- hide=true,--隐藏
		name="closed_book",--无字天书
		anim="closed_book",
		uses=TUNING_MEDAL.BOOK_MAXUSES.CLOSED,
        read_sanity = -TUNING.SANITY_MEDLARGE,
        peruse_sanity = -TUNING.SANITY_MEDLARGE,
		readfn=function(inst,reader)
			-- if reader.components.inventory and reader.components.inventory:EquipHasTag("xinhua_dictionary") then
			--手持新华字典有小概率触发奇遇
			if reader:HasTag("medal_canstudy") then
				--消耗新华字典耐久
				local dictionary = reader.components.inventory and reader.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
				if dictionary and dictionary.prefab=="xinhua_dictionary" and dictionary.components.finiteuses then
					dictionary.components.finiteuses:Use(1)
					if math.random() < TUNING_MEDAL.CLOSED_BOOK_SPECIAL_RATE then
						local qiyu_id=math.random(4)--奇遇编号
						local talkstr=nil--感叹词
						if qiyu_id==1 then
							--黄金屋
							talkstr=STRINGS.CLOSEDBOOKSPEECH.HUANGJINWU
							--生成黄金
							for k=1,TUNING_MEDAL.CLOSED_BOOK_GOLDNUGGET_NUM do
								inst.components.lootdropper:SpawnLootPrefab("goldnugget")
							end
						elseif qiyu_id==2 then
							--颜如玉
							talkstr=STRINGS.CLOSEDBOOKSPEECH.YANRUYU
							local x, y, z = reader.Transform:GetWorldPosition()
							local pigman = SpawnPrefab("merm")
							pigman.Transform:SetPosition(x, y, z)
						elseif qiyu_id==3 then
							--千钟粟
							talkstr=STRINGS.CLOSEDBOOKSPEECH.QIANZHONGSU
							for k=1,TUNING_MEDAL.CLOSED_BOOK_SEEDS_NUM do
								inst.components.lootdropper:SpawnLootPrefab("seeds")
							end
						else
							--车马簇
							talkstr=STRINGS.CLOSEDBOOKSPEECH.CHEMACU
							inst.components.lootdropper:SpawnLootPrefab("chesspiece_knight_marble")
							inst.components.lootdropper:SpawnLootPrefab("chesspiece_knight_stone")
							inst.components.lootdropper:SpawnLootPrefab("chesspiece_knight_moonglass")
							inst.components.lootdropper:SpawnLootPrefab("chesspiece_rook_marble")
							inst.components.lootdropper:SpawnLootPrefab("chesspiece_rook_stone")
							inst.components.lootdropper:SpawnLootPrefab("chesspiece_rook_moonglass")
						end
						MedalSay(reader,talkstr)
					end
				end
			end
			
			return true
		end,
		perusefn = function(inst,reader)
			MedalSay(reader,STRINGS.SHUDAIZISPEECH.CLOSED)
            return true
        end, 
	},
	{
		name="immortal_book",--不朽之谜
		anim="immortal_book",
		uses=TUNING_MEDAL.BOOK_MAXUSES.IMMORTAL,
		radius=TUNING_MEDAL.BOOK_NORMAL_RADIUS,--作用范围
        read_sanity = -TUNING.SANITY_HUGE,
        peruse_sanity = -TUNING.SANITY_LARGE,
		taglist={
			"fate_rewriteable",--可改命
			"medal_predictable",--可被预言
		},
		readfn=function(inst,reader)
			if reader then
				local itemcode = GetImmortalItem(inst,reader)
				if itemcode then
					inst.components.lootdropper:SpawnLootPrefab(itemcode)
				end
				--额外作用
				local x, y, z = reader.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x, y, z, TUNING_MEDAL.BOOK_NORMAL_RADIUS,nil , { "INLIMBO"},{"ignorewalkableplatforms","diseased"})
				if #ents>0 then
					for i,v in ipairs(ents) do
						--加速盐矿生长
						if v.prefab=="saltstack" and math.random()<0.5 then
							v:PushEvent("timerdone", { name = "growth" })
						end
					end
				end
			end
			return true
		end,
		perusefn = function(inst,reader)
            MedalSay(reader,STRINGS.SHUDAIZISPEECH.IMMORTAL)
            return true
        end,
		prophesyfn = function(inst,reader)
			return GetImmortalItem(inst,reader)
		end,
		extrafn = function(inst)--主机额外扩展函数
			inst:AddComponent("medal_itemdestiny")--宿命
		end,
	},
	{
		name="monster_book",--怪物图鉴
		anim="monster_book",
		uses=TUNING_MEDAL.BOOK_MAXUSES.MONSTER,
		radius=TUNING_MEDAL.BOOK_SACRIFICE_RADIUS,--作用范围
        read_sanity = -TUNING.SANITY_HUGE,
        peruse_sanity = -TUNING.SANITY_HUGE,
		taglist={
			"fate_rewriteable",--可改命
			"medal_predictable",--可被预言
			"washfunctionalable",--可清洗
		},
		readfn=function(inst,reader)
			local monster=nil
			--判断玩家在船上或者在水面上
			if reader:GetCurrentPlatform() ~= nil or (reader.components.drownable~= nil and reader.components.drownable:IsOverWater()) then
				-- monster=SpawnPrefab("malbatross")
				local monster_code = doSacrifice(inst,reader,chesspiece_list.water,monster_loot.water)--进行献祭并获取随机怪物ID
				monster = SpawnMonster(reader,monster_code,true,monster_data[monster_code])--生成怪物
			else
				local monster_code = doSacrifice(inst,reader,chesspiece_list.land,monster_loot.land)--进行献祭并获取随机怪物ID
				if monster_data[monster_code] and monster_data[monster_code].special_spawn then--特殊生成物
					monster_data[monster_code].special_spawn(reader)
				else
					monster = SpawnMonster(reader,monster_code,false,monster_data[monster_code])--生成怪物
					if monster then
						monster:AddTag("ignorewalkableplatformdrowning")--无视炸船溺水
					end
				end
			end
			return true
		end,
		perusefn = function(inst,reader)
            MedalSay(reader,STRINGS.SHUDAIZISPEECH.MONSTER)
            return true
        end,
		prophesyfn = function(inst,reader)
			--判断玩家在船上或者在水面上
			if reader:GetCurrentPlatform() ~= nil or (reader.components.drownable~= nil and reader.components.drownable:IsOverWater()) then
				return doSacrifice(inst,reader,chesspiece_list.water,monster_loot.water,true)--获取献祭结果
			else
				return doSacrifice(inst,reader,chesspiece_list.land,monster_loot.land,true)--获取献祭结果
			end
		end,
		extrafn = function(inst)--主机额外扩展函数
			inst:AddComponent("medal_itemdestiny")--宿命
		end,
	},
	{
		name="unsolved_book",--未解之谜
		anim="unsolved_book",
		uses=TUNING_MEDAL.BOOK_MAXUSES.UNSOLVED,
		radius=TUNING_MEDAL.BOOK_SACRIFICE_RADIUS,--作用范围
        read_sanity = -TUNING.SANITY_HUGE,
        peruse_sanity = -TUNING.SANITY_LARGE,
		taglist={
			"fate_rewriteable",--可改命
			"medal_predictable",--可被预言
			"washfunctionalable",--可清洗
		},
		readfn=function(inst,reader)
			--在船上或者水里，则生成水上奇遇
			if reader:GetCurrentPlatform() ~= nil or (reader.components.drownable~= nil and reader.components.drownable:IsOverWater()) then
				local qiyu_id = doSacrifice(inst,reader,unsolved_item_list.water,unsolved_index.water)--进行献祭并获取随机奇遇ID
				MedalSpawnCircleItem(reader,unsolved_loot[qiyu_id],STRINGS.UNSOLVEDSPEECH[string.upper(qiyu_id)])--生成水上奇遇
			else--否则生成陆地奇遇
				local qiyu_id = doSacrifice(inst,reader,unsolved_item_list.land,unsolved_index.land)--进行献祭并获取随机奇遇ID
				MedalSpawnCircleItem(reader,unsolved_loot[qiyu_id],STRINGS.UNSOLVEDSPEECH[string.upper(qiyu_id)])--生成陆地奇遇
			end
			return true
		end,
		perusefn = function(inst,reader)
            MedalSay(reader,STRINGS.SHUDAIZISPEECH.UNSOLVED)
            return true
        end,
		prophesyfn = function(inst,reader)
			--判断玩家在船上或者在水面上
			if reader:GetCurrentPlatform() ~= nil or (reader.components.drownable~= nil and reader.components.drownable:IsOverWater()) then
				return doSacrifice(inst,reader,unsolved_item_list.water,unsolved_index.water,true)--水上奇遇ID
			else
				return doSacrifice(inst,reader,unsolved_item_list.land,unsolved_index.land,true)--陆地奇遇ID
			end
		end,
		extrafn = function(inst)--主机额外扩展函数
			inst:AddComponent("medal_itemdestiny")--宿命
		end,
	},
	{
		name="trapreset_book",--陷阱重置册
		anim="trapreset_book",
		uses=TUNING_MEDAL.BOOK_MAXUSES.TRAPRESET,
		radius=TUNING_MEDAL.BOOK_NORMAL_RADIUS,--作用范围
        read_sanity = -TUNING.SANITY_SMALL,
        peruse_sanity = -TUNING.SANITY_SMALL,
		readfn=function(inst,reader)
			local x, y, z = reader.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, TUNING_MEDAL.BOOK_NORMAL_RADIUS,nil , { "INLIMBO"})
			if #ents>0 then
				for i,v in ipairs(ents) do
					if v.prefab=="trap_teeth" then
						if v.components.mine and v.components.mine.issprung then 
							v.components.mine:Reset()
						end
					elseif v.prefab=="trap_bramble" then
						if v.components.mine and v.components.mine.issprung then 
							v.components.mine:Reset()
						end
					elseif v.prefab=="trap_bat" then
						if v.components.mine and v.components.mine.issprung then 
							v.components.mine:Reset()
						end
					end
				end
			end
			return true
		end,
		perusefn = function(inst,reader)
            MedalSay(reader,STRINGS.SHUDAIZISPEECH.TRAPRESET)
            return true
        end, 
	},
	{
		name="autotrap_book",--智能陷阱制作手册
		anim="autotrap_book",
		uses=TUNING_MEDAL.BOOK_MAXUSES.AUTOTRAP,
		radius=TUNING_MEDAL.BOOK_NORMAL_RADIUS,--作用范围
        read_sanity = -TUNING.SANITY_LARGE,
        peruse_sanity = -TUNING.SANITY_SMALL,
		readfn=function(inst,reader)
			local x, y, z = reader.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, TUNING_MEDAL.BOOK_NORMAL_RADIUS,{"trap"} , { "INLIMBO"})
			if #ents>0 then
				local autovalue=30--升级点数
				for i,v in ipairs(ents) do
					if v.setAutoTrap and not v:HasTag("autoTrap") then
						v:setAutoTrap()
						SpawnMedalFX("collapse_small",v)
						--升级荆棘陷阱消耗2点点数，其他消耗1点
						if v.prefab=="trap_bramble" then
							autovalue=autovalue-2
						else
							autovalue=autovalue-1
						end
						if autovalue<=0 then
							break
						end
					end
				end
			end
			return true
		end,
		perusefn = function(inst,reader)
            MedalSay(reader,STRINGS.SHUDAIZISPEECH.AUTOTRAP)
            return true
        end,  
	},
	{
		name="medal_plant_book",--植物图鉴
		anim="medal_plant_book",
		uses=TUNING_MEDAL.BOOK_MAXUSES.PLANT,
		radius=TUNING_MEDAL.BOOK_SACRIFICE_RADIUS,--作用范围
        read_sanity = -TUNING.SANITY_HUGE,
        peruse_sanity = TUNING.SANITY_LARGE,
		taglist={
			"fate_rewriteable",--可改命
			"medal_predictable",--可被预言
			"washfunctionalable",--可清洗
		},
		readfn=function(inst,reader)
			--不能在水里生成奇遇
			if reader:GetCurrentPlatform() ~= nil or (reader.components.drownable~= nil and reader.components.drownable:IsOverWater()) then
				return false,"MUSTLAND"
			end
			--复活周围的曼德拉草、催长本源之树
			local x, y, z = reader.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, TUNING_MEDAL.BOOK_SACRIFICE_RADIUS, nil, nil, {"cookable","small_origin_tree"})
			local count = 0
			for i, v in ipairs(ents) do
				--催熟本源之树
				if v.prefab == "medal_origin_small_tree" and v.DoMedalMagicGrowth and v:DoMedalMagicGrowth() then
					return true
				--堆叠的不能复活
				elseif v.prefab == "mandrake" and (v.components.stackable == nil or not v.components.stackable:IsStack()) then
					local planted = SpawnPrefab("mandrake_planted")
					planted.Transform:SetPosition(v.Transform:GetWorldPosition())
					planted:replant(reader)
					v:Remove()
					count = count + 1
				end
				if count >= 10 then--单次最多复活10棵
					break
				end
			end
			--如果复活过曼德拉草了就不能生成奇遇了
			if count <= 0 then
				local qiyu_id = doSacrifice(inst,reader,plant_item_list,plant_index)--进行献祭并获取随机奇遇ID
				local specialfn = special_plant_data[qiyu_id]
				if specialfn ~= nil then
					specialfn(reader)
					return true
				end
				MedalSpawnCircleItem(reader,plant_loot[qiyu_id],STRINGS.UNSOLVEDSPEECH[string.upper(qiyu_id)])--生成陆地奇遇
			end
			return true
		end,
		perusefn = function(inst,reader)
            MedalSay(reader,STRINGS.SHUDAIZISPEECH.UNSOLVED)
            return true
        end,
		prophesyfn = function(inst,reader)
			--判断玩家在船上或者在水面上
			if reader:GetCurrentPlatform() ~= nil or (reader.components.drownable~= nil and reader.components.drownable:IsOverWater()) then
				return "cantspawn"
			else
				return doSacrifice(inst,reader,plant_item_list,plant_index,true)--奇遇ID
			end
		end,
		extrafn = function(inst)--主机额外扩展函数
			inst:AddComponent("medal_itemdestiny")--宿命
		end,
	},
}

return book_defs