--------------------------------------------------公用函数--------------------------------------------------
--是否为有效目标(inst,目标,其他数据)
local function IsVaild(inst,target,data)
	if inst.mission_data.pre_vaildfn then
		return inst.mission_data.pre_vaildfn(inst,target,data)
	end
	if (inst.mission_data.mission_tag and target:HasTag(inst.mission_data.mission_tag))--有对应的标签
		or (inst.mission_data.mission_target_loot and table.contains(inst.mission_data.mission_target_loot,target.prefab))--在目标组内
		or (inst.mission_data.mission_target and target.prefab == inst.mission_data.mission_target) then--预制物名相等
		return inst.mission_data.vaildfn == nil or inst.mission_data.vaildfn(inst,target,data)--有效性判定
	end
end
--获取任务信息
local function GetInfo(inst)
	local neednum = inst.components.finiteuses and inst.components.finiteuses:GetUses() or 0
	local missiondata = inst.mission_data--使命信息
	local target_str
	local rewardnum
	if missiondata then
		target_str = missiondata.mission_tips--如果有特定描述，则显示特定描述
			or (missiondata.mission_tag and STRINGS.MISSION_TAGINFO[string.upper(missiondata.mission_tag)])--否则根据标签读取描述
			or (missiondata.mission_target and STRINGS.NAMES[string.upper(missiondata.mission_target)])--否则读取特定预制物名称
			or (missiondata.mission_target_loot and missiondata.mission_target_loot[1] and STRINGS.NAMES[string.upper(missiondata.mission_target_loot[1])])--否则读取目标组内第一个目标的名称
			or missiondata.mission_target--否则显示预制物代码
			or (missiondata.mission_target_loot and missiondata.mission_target_loot[1])--否则读取目标组内第一个目标的代码
		rewardnum = missiondata.reward_num
	end
	return neednum, target_str or STRINGS.MISSION_TAGINFO.UNKNOWN, rewardnum or TUNING_MEDAL.MISSION_MEDAL.REWARD_NUM
end
--初始化勋章数据
local function InitData(inst,data)
	if inst and data then
		inst.mission_data = {
			mission_tag = data.tag,--带有该标签的一类目标
			mission_target = data.target,--具体目标
			mission_tips = data.tips,--特定描述
			mission_target_loot = data.target_loot,--目标组
			reward_num = data.rewardnum or TUNING_MEDAL.MISSION_MEDAL.REWARD_NUM,--奖励数量(默认为4)
			vaildfn = data.vaildfn,--有效性判定函数,确定是符合条件的目标后再进行有效性判断
			pre_vaildfn = data.pre_vaildfn,--有效目标预判定，如果满足则直接通过
		}
		inst.vaildTarget = IsVaild
	end
end

--------------------------------------------------击杀类任务--------------------------------------------------
--给有效目标设置死亡监听
local function setMissionKillFn(inst)
	--监听目标死亡
	inst:ListenForEvent("death",function(inst,data)
		--克劳斯需要二阶段死了才算
		if inst.prefab~="klaus" or inst:IsUnchained() then
			--如果是处于使命任务过程中的玩家杀死的，则给这个玩家推事件
			if data and data.afflicter and data.afflicter.in_medal_mission then
				data.afflicter:PushEvent("missionkilled",{victim=inst})
			--否则给绑定的玩家推
			elseif inst.mission_bind_player then
				inst.mission_bind_player:PushEvent("missionkilled",{victim=inst})
				inst.mission_bind_player=nil
			end
		end
	end)
end
--有效击杀(击杀者,击杀信息)
local function missionKilled(owner,data)
	if owner and data and data.victim ~= nil then
		local medal = owner.components.inventory and owner.components.inventory:EquipMedalWithName("mission_certificate")--获取勋章
		if medal and medal.vaildTarget and medal:vaildTarget(data.victim,data) then
			medal.components.finiteuses:Use(1)--消耗耐久
			SpawnMedalTips(owner,1,16)--弹幕提示
		end
	end
end
--攻击事件,给目标绑定攻击者
local function missionHit(owner,data)
	if owner and data and data.target ~= nil then
		local medal = owner.components.inventory and owner.components.inventory:EquipMedalWithName("mission_certificate")--获取勋章
		--攻击目标符合条件，则进行相关处理
		if medal and medal.vaildTarget and medal:vaildTarget(data.target,data) then
			--攻击目标绑定的玩家不是佩戴者，才需要进行下一步，否则说明已经绑定过了，直接跳过
			if data.target.mission_bind_player~=owner  then
				--目标直接死了，那就直接算击杀
				if data.target.components.health and data.target.components.health:IsDead() then
					missionKilled(owner,{victim=data.target})
				else
					--目标没绑定玩家，给它添加推送事件
					if data.target.mission_bind_player==nil then
						setMissionKillFn(data.target)
					end
					data.target.mission_bind_player=owner--和佩戴者进行绑定
				end
			end
		end
	end
end

--------------------------------------------------采集类任务--------------------------------------------------
--有效采集
local function pickSomething(owner,data)
	if owner and data and data.object ~= nil then
		print(data.object.prefab)
		local medal = owner.components.inventory and owner.components.inventory:EquipMedalWithName("mission_certificate")--获取勋章
		if medal and medal.vaildTarget and medal:vaildTarget(data.object,data) then
			medal.components.finiteuses:Use(1)--消耗耐久
			SpawnMedalTips(owner,1,16)--弹幕提示
		end
	end
end

--------------------------------------------------伐木类任务--------------------------------------------------
local function finishedChop(owner,data)
	--挖树根也算伐木了(为了蘑菇树)
	if owner and data and data.target ~= nil and data.action ~= nil and data.action.id and (data.action.id=="CHOP" or data.action.id=="DIG") then
		local medal = owner.components.inventory and owner.components.inventory:EquipMedalWithName("mission_certificate")--获取勋章
		if medal and medal.vaildTarget and medal:vaildTarget(data.target,data) then
			medal.components.finiteuses:Use(1)--消耗耐久
			SpawnMedalTips(owner,1,16)--弹幕提示
		end
	end
end

--------------------------------------------------镐击类任务--------------------------------------------------
local function finishedMine(owner,data)
	if owner and data and data.target ~= nil and data.action ~= nil and data.action.id and data.action.id=="MINE" then
		local medal = owner.components.inventory and owner.components.inventory:EquipMedalWithName("mission_certificate")--获取勋章
		if medal and medal.vaildTarget and medal:vaildTarget(data.target,data) then
			medal.components.finiteuses:Use(1)--消耗耐久
			SpawnMedalTips(owner,1,16)--弹幕提示
		end
	end
end

--------------------------------------------------钓鱼类任务--------------------------------------------------
local function fishingCollect(owner,data)
	if owner and data and data.fish ~= nil then
		print(data.fish.prefab)
		local medal = owner.components.inventory and owner.components.inventory:EquipMedalWithName("mission_certificate")--获取勋章
		if medal and medal.vaildTarget and medal:vaildTarget(data.fish,data) then
			medal.components.finiteuses:Use(1)--消耗耐久
			SpawnMedalTips(owner,1,16)--弹幕提示
		end
	end
end

--任务初始化函数列表
local missionInitFnLoot={
	{--1,击杀类任务
		onEquip = function(inst,owner)--佩戴
			owner:ListenForEvent("missionkilled", missionKilled)--监听有效击杀事件
			owner:ListenForEvent("onhitother", missionHit)--监听攻击目标事件
		end,
		onUnEquip = function(inst,owner)--卸下
			owner:RemoveEventCallback("missionkilled", missionKilled)
			owner:RemoveEventCallback("onhitother", missionHit)
		end,
		getInfo = function(inst)
			local neednum,target_str,rewardnum = GetInfo(inst)
			return subfmt(STRINGS.MISSION_TAGINFO.KILLTIP,{target = target_str, neednum = neednum, rewardnum = rewardnum})
		end,
	},
	{--2,采集类任务
		onEquip = function(inst,owner)--佩戴
			owner:ListenForEvent("picksomething", pickSomething)--采摘
			owner:ListenForEvent("medal_picksomething", pickSomething)--采摘(多汁浆果)
			owner:ListenForEvent("harvestsomething", pickSomething)--收获
			owner:ListenForEvent("takesomething", pickSomething)--拿取(食人花)
		end,
		onUnEquip = function(inst,owner)--卸下
			owner:RemoveEventCallback("picksomething", pickSomething)
			owner:RemoveEventCallback("medal_picksomething", pickSomething)
			owner:RemoveEventCallback("harvestsomething", pickSomething)
			owner:RemoveEventCallback("takesomething", pickSomething)
		end,
		getInfo = function(inst)
			local neednum,target_str,rewardnum = GetInfo(inst)
			return subfmt(STRINGS.MISSION_TAGINFO.PICKTIP,{target = target_str, neednum = neednum, rewardnum = rewardnum})
		end,
	},
	{--3,伐木类任务
		onEquip = function(inst,owner)--佩戴
			owner:ListenForEvent("finishedwork", finishedChop)
		end,
		onUnEquip = function(inst,owner)--卸下
			owner:RemoveEventCallback("finishedwork", finishedChop)
		end,
		getInfo = function(inst)
			local neednum,target_str,rewardnum = GetInfo(inst)
			return subfmt(STRINGS.MISSION_TAGINFO.CHOPTIP,{target = target_str, neednum = neednum, rewardnum = rewardnum})
		end,
	},
	{--4,镐击类任务
		onEquip = function(inst,owner)--佩戴
			owner:ListenForEvent("finishedwork", finishedMine)
		end,
		onUnEquip = function(inst,owner)--卸下
			owner:RemoveEventCallback("finishedwork", finishedMine)
		end,
		getInfo = function(inst)
			local neednum,target_str,rewardnum = GetInfo(inst)
			return subfmt(STRINGS.MISSION_TAGINFO.MINETIP,{target = target_str, neednum = neednum, rewardnum = rewardnum})
		end,
	},
	{--5,钓鱼类任务
		onEquip = function(inst,owner)--佩戴
			owner:ListenForEvent("medal_fishingcollect", fishingCollect)
		end,
		onUnEquip = function(inst,owner)--卸下
			owner:RemoveEventCallback("medal_fishingcollect", fishingCollect)
		end,
		getInfo = function(inst)
			local str = STRINGS.MISSION_TAGINFO.FISHTIP1
			local neednum,target_str,rewardnum = GetInfo(inst)
			--池塘特殊读取
			if inst.mission_data and inst.mission_data.pond then
				neednum = inst.components.finiteuses and inst.components.finiteuses:GetUses() or 0
				rewardnum = inst.mission_data.reward_num or 4
				target_str = STRINGS.MEDAL_INFO[string.upper(inst.mission_data.pond)] or STRINGS.NAMES[string.upper(inst.mission_data.pond)] or inst.mission_data.pond
				str = STRINGS.MISSION_TAGINFO.FISHTIP2
			--海钓或者陆钓形式
			elseif inst.mission_data and inst.mission_data.specail then
				target_str = inst.mission_data.mission_tips
				str = STRINGS.MISSION_TAGINFO.FISHTIP3
			end
			return subfmt(str,{target = target_str, neednum = neednum, rewardnum = rewardnum})
		end,
		Init = function(inst,data)
			inst.mission_data.pond = data.pond
		end,
	},
}

--生成任务数据
local function MakeMissionData(data)
	local mission_data={}
	local missionInitFn = missionInitFnLoot[data.type or 1]
	if missionInitFn then
		mission_data.mission_times = data.num or 1--任务目标数量
		mission_data.onEquip = missionInitFn.onEquip--佩戴函数
		mission_data.onUnEquip = missionInitFn.onUnEquip--卸下函数
		mission_data.getMedalInfo = missionInitFn.getInfo--获取任务信息函数
		mission_data.Init = function(inst)--初始化
			InitData(inst,data)
			if missionInitFn.Init then--额外的附加函数
				missionInitFn.Init(inst,data)
			end
		end
	end
	return mission_data
end

--任务数据,不可轻易更改数据顺序,因为和ID是相对应的！要加任务只能往最后面加！
local missions_data = {
	--------------------击杀类任务--------------------
	{type=1, target = "deerclops", num = 1},--巨鹿
	{type=1, target = "bearger", num = 1},--熊大
	{type=1, target = "moose", num = 1, tips = STRINGS.MISSION_TAGINFO.MOOSE},--鹿鸭
	{type=1, target = "dragonfly", num = 1},--龙蝇
	{type=1, target = "spiderqueen", num = 1},--蜘蛛女王
	{type=1, target = "spat", num = 1},--钢羊
	{type=1, target = "warg", num = 1},--座狼
	{type=1, target = "tentacle", num = 30},--触手
	{type=1, target = "rocky", num = 5},--石虾
	{type=1, target = "bunnyman", num = 10},--兔人
	{type=1, target = "waterplant", num = 3, rewardnum = 8},--海草
	{type=1, target = "shark", num = 1},--岩鲨
	{type=1, target = "gnarwail", num = 2},--一角鲸

	{type=1, tag = "hound", num = 20},--任意猎犬
	{type=1, tag = "spider", num = 50},--任意蜘蛛
	{type=1, tag = "smallcreature", num = 50},--任意小动物
	{type=1, tag = "monster", num = 50},--任意怪物
	{type=1, tag = "largecreature", num = 2},--任意巨型生物
	{type=1, tag = "epic", num = 1},--任意boss
	{type=1, tag = "insect", num = 40},--任意昆虫
	{type=1, tag = "bee", num = 40},--任意蜜蜂
	{type=1, tag = "flying", num = 40},--飞行生物
	{type=1, tag = "cavedweller", num = 40},--洞穴生物
	{type=1, tag = "monkey", num = 15},--任意猴子
	{type=1, tag = "bird", num = 15},--任意小鸟
	{type=1, tag = "shadowcreature", num = 15},--任意影怪
	{type=1, tag = "chess", num = 6},--任意发条生物
	{type=1, tag = "leif", num = 1},--任意树精

	{type=1, target_loot = {"koalefant_summer","koalefant_winter"}, num = 2},--任意大象
	{type=1, target_loot = {"slurtle","snurtle"}, num = 5},--任意蜗牛

	--------------------采集类任务--------------------
	{type=2, target = "grass", num = 40},--草
	{type=2, target = "mandrake_berry", num = 40, rewardnum = 8},--曼德拉果
	{type=2, target = "tumbleweed", num = 20},--风滚草
	{type=2, target = "flower_evil", num = 10},--噩梦花
	{type=2, target = "cave_fern", num = 40},--蕨叶
	{type=2, target = "succulent_plant", num = 15},--多肉植物
	{type=2, target = "rock_avocado_bush", num = 30},--石果
	{type=2, target = "bullkelp_plant", num = 30},--海带
	{type=2, target = "medal_fruit_tree_immortal_fruit", num = 5, rewardnum = 20},--不朽果实嫁接树

	{type=2, tag = "silviculture", num = 40},--任意可被《应用造林学》催熟的作物
	{type=2, tag = "farm_plant", num = 20},--任意农作物
	{type=2, tag = "weed", num = 20},--任意杂草
	{type=2, tag = "bush", num = 30},--任意浆果丛
	{type=2, tag = "medal_fruit_tree", num = 15, rewardnum = 8},--任意嫁接树
	{type=2, tag = "beebox", num = 15},--任意蜂箱

	{type=2, target_loot = {"sapling","sapling_moon"}, num = 40},--树枝
	{type=2, target_loot = {"flower_cave","flower_cave_double","flower_cave_triple","lightflier_flower"}, num = 40},--荧光花
	{type=2, target_loot = {"red_mushroom","green_mushroom","blue_mushroom"}, num = 20, tips = STRINGS.MISSION_TAGINFO.ANYMUSHROOM},--任意蘑菇
	{type=2, target_loot = {"meatrack","meatrack_hermit"}, num = 20, tips = STRINGS.MISSION_TAGINFO.ANYMEATRACK},--任意晾制食品

	{type=2, tag = "farm_plant", num = 10, tips = STRINGS.MISSION_TAGINFO.SEASONAL_FARM_PLANT, vaildfn = function(inst,target,data)--应季作物
		return target and target.plant_def and target.plant_def.good_seasons and target.plant_def.good_seasons[TheWorld.state.season]
	end},
	{type=2, tag = "farm_plant", num = 10, tips = STRINGS.MISSION_TAGINFO.OUVERSIZED_FARM_PLANT, vaildfn = function(inst,target,data)--巨型作物
		return target and target.is_oversized
	end},
	{type=2, tag = "farm_plant", num = 10, tips = STRINGS.MISSION_TAGINFO.NUTRIENT_CONSUME_FARM_PLANT1, vaildfn = function(inst,target,data)--会消耗催长剂的作物
		return target and target.plant_def and target.plant_def.nutrient_consumption and target.plant_def.nutrient_consumption[1] ~= 0
	end},
	{type=2, tag = "farm_plant", num = 10, tips = STRINGS.MISSION_TAGINFO.NUTRIENT_CONSUME_FARM_PLANT2, vaildfn = function(inst,target,data)--会消耗堆肥的作物
		return target and target.plant_def and target.plant_def.nutrient_consumption and target.plant_def.nutrient_consumption[2] ~= 0
	end},
	{type=2, tag = "farm_plant", num = 10, tips = STRINGS.MISSION_TAGINFO.NUTRIENT_CONSUME_FARM_PLANT3, vaildfn = function(inst,target,data)--会消耗粪肥的作物
		return target and target.plant_def and target.plant_def.nutrient_consumption and target.plant_def.nutrient_consumption[3] ~= 0
	end},
	{type=2, tag = "farm_plant", num = 10, tips = STRINGS.MISSION_TAGINFO.NUTRIENT_RESTORATION_FARM_PLANT1, vaildfn = function(inst,target,data)--会增长催长剂的作物
		return target and target.plant_def and target.plant_def.nutrient_restoration and target.plant_def.nutrient_restoration[1]
	end},
	{type=2, tag = "farm_plant", num = 10, tips = STRINGS.MISSION_TAGINFO.NUTRIENT_RESTORATION_FARM_PLANT2, vaildfn = function(inst,target,data)--会增长堆肥的作物
		return target and target.plant_def and target.plant_def.nutrient_restoration and target.plant_def.nutrient_restoration[2]
	end},
	{type=2, tag = "farm_plant", num = 10, tips = STRINGS.MISSION_TAGINFO.NUTRIENT_RESTORATION_FARM_PLANT3, vaildfn = function(inst,target,data)--会增长粪肥的作物
		return target and target.plant_def and target.plant_def.nutrient_restoration and target.plant_def.nutrient_restoration[3]
	end},

	--------------------伐木类任务--------------------
	{type=3, target = "deciduoustree", num = 40},--桦栗树
	{type=3, target = "evergreen", num = 40},--常青树
	{type=3, target = "evergreen_sparse", num = 40},--粗壮常青树
	{type=3, target = "moon_tree", num = 20},--月树
	{type=3, target = "palmconetree", num = 20},--棕榈松果树
	{type=3, target = "cave_banana_tree", num = 10},--洞穴香蕉树
	{type=3, target = "mushtree_moon", num = 15},--月亮蘑菇树

	{type=3, tag = "mushtree", num = 15},--任意蘑菇树

	{type=3, target_loot = {"livingtree","livingtree_halloween"}, num = 20, rewardnum = 8},--完全正常的树
	{type=3, target_loot = {"driftwood_tree","driftwood_tall","driftwood_small1","driftwood_small2"}, num = 10, rewardnum = 10},--浮木

	{type=3, tag = "tree", num = 40, vaildfn = function(inst,target,data)--任意未枯萎并且未烧焦的树
		return target and (target.components.growable==nil or target.components.growable.stage<4) and not target:HasTag("burnt")
	end},

	--------------------镐击类任务--------------------
	{type=4, target = "rock_petrified_tree", num = 30},--石化树
	{type=4, target = "saltstack", num = 20},--盐矿
	{type=4, target_loot = {"marbletree","marbleshrub"}, num = 30},--大理石树
	{type=4, target = "medal_nitrify_tree", num = 20},--硝化树
	{type=4, target = "medal_spacetime_glass", num = 20,rewardnum = 20},--时空晶矿
	{type=4, target = "rock_ice", num = 10},--冰矿
	{type=4, target = "medal_dustmothden", num = 10,rewardnum = 20},--时空尘蛾窝

	{type=4, tag = "statue", num = 10},--任意雕像
	{type=4, tag = "boulder", num = 40},--任意矿石

	{type=4, target_loot = {"dustmothden","medal_dustmothden"}, num = 6, tips = STRINGS.MISSION_TAGINFO.ANYDUSTMOTHDEN},--任意尘蛾窝
	{type=4, target_loot = {"stalagmite_tall","stalagmite_tall_low","stalagmite_tall_med","stalagmite_tall_full"}, num = 30},--石笋
	{type=4, target_loot = {"ancient_statue","ruins_statue_mage","ruins_statue_mage_nogem","ruins_statue_head","ruins_statue_head_nogem"}, num = 6},--远古雕像

	--------------------钓鱼类任务--------------------
	{type=5, target_loot = {"oceanfish_small_7_inv","oceanfish_small_7"}, num = 3, rewardnum = 8},--花朵金枪鱼
	{type=5, target_loot = {"oceanfish_small_8_inv","oceanfish_small_8"}, num = 3, rewardnum = 8},--太阳鱼
	{type=5, target_loot = {"oceanfish_small_6_inv","oceanfish_small_6"}, num = 3, rewardnum = 8},--落叶比目鱼
	{type=5, target_loot = {"oceanfish_medium_8_inv","oceanfish_medium_8"}, num = 3, rewardnum = 8},--冰鲷鱼
	{type=5, target_loot = {"oceanfish_small_9_inv","oceanfish_small_9"}, num = 10, rewardnum = 8},--口水鱼

	{type=5, tag = "oceanfish", num = 20},--任意海鱼
	{type=5, tag = "canbetrapped", num = 20},--任意龙虾

	{type=5, target_loot = {
		"oceanfish_small_7_inv",
		"oceanfish_small_8_inv",
		"oceanfish_small_6_inv",
		"oceanfish_medium_8_inv",
		"oceanfish_small_7",
		"oceanfish_small_8",
		"oceanfish_small_6",
		"oceanfish_medium_8",
	},
	tips = STRINGS.MISSION_TAGINFO.SEASONFISH, num = 5, rewardnum = 8},--任意时令鱼
	{type=5, target_loot = {"medal_losswetpouch1","medal_losswetpouch2","medal_losswetpouch3","medal_losswetpouch4","medal_losswetpouch5","medal_losswetpouch6","medal_losswetpouch7"},
	tips = STRINGS.MISSION_TAGINFO.LOSSWETPOUCH, num = 5},--任意遗失塑料袋

	{type=5, tag = "oceanfish", num = 10, tips = STRINGS.MISSION_TAGINFO.WEIGHTOCEANFISH, vaildfn = function(inst,target,data)--足够重的海鱼
		return target and target.components.weighable and target.components.weighable:GetWeightPercent() >= TUNING.HERMITCRAB.HEAVY_FISH_THRESHHOLD
	end},
	{type=5, tag = "oceanfish", num = 10, tips = STRINGS.MISSION_TAGINFO.MEATOCEANFISH, vaildfn = function(inst,target,data)--肉味海鱼
		return target and target.components.edible and target.components.edible.foodtype == FOODTYPE.MEAT
	end},
	{type=5, tag = "oceanfish", num = 10, tips = STRINGS.MISSION_TAGINFO.VEGGIEOCEANFISH, vaildfn = function(inst,target,data)--素味海鱼
		return target and target.components.edible and target.components.edible.foodtype == FOODTYPE.VEGGIE
	end},

	{type=5, num = 10, pond="lava_pond", pre_vaildfn=function(inst,target,data)--岩浆池
		return data.pond and inst.mission_data and data.pond.prefab == inst.mission_data.pond
	end},
	{type=5, num = 10, pond="medal_seapond", pre_vaildfn=function(inst,target,data)--船上钓鱼池
		return data.pond and inst.mission_data and data.pond.prefab == inst.mission_data.pond
	end},
	{type=5, num = 10, pond="oasislake", pre_vaildfn=function(inst,target,data)--湖泊
		return data.pond and inst.mission_data and data.pond.prefab == inst.mission_data.pond
	end},
	{type=5, num = 20, pond="pond", pre_vaildfn=function(inst,target,data)--池塘
		return data.pond and inst.mission_data and data.pond.prefab == inst.mission_data.pond
	end},
	{type=5, num = 20, pond="pond_mos", pre_vaildfn=function(inst,target,data)--沼泽池塘
		return data.pond and inst.mission_data and data.pond.prefab == inst.mission_data.pond
	end},
	{type=5, num = 20, pond="pond_cave", pre_vaildfn=function(inst,target,data)--洞穴池塘
		return data.pond and inst.mission_data and data.pond.prefab == inst.mission_data.pond
	end},

	{type=5, num = 20, specail=true, tips = STRINGS.MISSION_TAGINFO.ANYLANDFISH, pre_vaildfn=function(inst,target,data)--陆钓
		return data.pond~=nil
	end},
	{type=5, num = 20, specail=true, tips = STRINGS.MISSION_TAGINFO.ANYOCEANFISH, pre_vaildfn=function(inst,target,data)--海钓
		return data.pond==nil
	end},

	--------------------新补充任务--------------------
}


local medal_missions={}

for i, v in ipairs(missions_data) do
	table.insert(medal_missions,MakeMissionData(v))
end

return medal_missions