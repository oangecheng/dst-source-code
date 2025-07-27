--吃食物时的发言
local function speechFood(inst, data)
	if data.food ~= nil and data.food.components.edible ~= nil then
		if data.food.prefab == "spoiled_food" then
			MedalSay(inst,GetString(inst, "ANNOUNCE_EAT", "SPOILED"))
		elseif data.food.components.edible:GetHealth(inst) < 0 and
			data.food.components.edible:GetSanity(inst) <= 0 and
			not (inst.components.eater ~= nil and (
			inst.components.eater.strongstomach and
			data.food:HasTag("monstermeat") or
			inst.components.eater.healthabsorption == 0
			)) and not (inst.components.foodaffinity and inst.components.foodaffinity:HasPrefabAffinity(data.food)) then
				MedalSay(inst,GetString(inst, "ANNOUNCE_EAT", "PAINFUL"))
		elseif data.food.components.perishable ~= nil then
			if data.food.components.perishable:IsFresh() then
				MedalSay(inst,GetString(inst, "ANNOUNCE_EAT", "GENERIC"))
			elseif data.food.components.edible.degrades_with_spoilage then
				if data.food.components.perishable:IsStale() then
					MedalSay(inst,GetString(inst, "ANNOUNCE_EAT", "STALE"))
				elseif data.food.components.perishable:IsSpoiled() then
					MedalSay(inst,GetString(inst, "ANNOUNCE_EAT", "SPOILED"))
				end
			end
		else
			local count = inst.components.foodmemory ~= nil and inst.components.foodmemory:GetMemoryCount(data.food.prefab) or 0
			if count > 0 then
				MedalSay(inst,GetString(inst, "ANNOUNCE_EAT", "SAME_OLD_"..tostring(math.min(5, count))))
			end
		end
	end
end
--返还新勋章(勋章,新勋章名,对新勋章执行的函数)
local function returnNewMedal(inst,newmedalname,medalfn)
	local newmedal = SpawnPrefab(newmedalname)--新勋章
	if newmedal then
		if medalfn then--执行回调
			medalfn(inst,newmedal)
		end
		local owner = inst.components.inventoryitem and inst.components.inventoryitem:GetGrandOwner()--获取拥有者
		if owner then
			local isequipped = inst.components.equippable and inst.components.equippable:IsEquipped()--是否处于装备状态
			local oldmedal = inst.components.inventoryitem:RemoveFromOwner() or inst--从原位置移除
			--物归原主
			if oldmedal.prevcontainer ~= nil and oldmedal.prevcontainer.inst.components.container:CanTakeItemInSlot(newmedal, oldmedal.prevslot) then
				oldmedal.prevcontainer.inst.components.container:GiveItem(newmedal, oldmedal.prevslot)
			elseif owner.components.inventory then
				if isequipped and newmedal.components.equippable then
					owner.components.inventory:Equip(newmedal)
				else
					owner.components.inventory:GiveItem(newmedal, oldmedal.prevslot)
				end
			elseif owner.components.container then
				owner.components.container:GiveItem(newmedal)
			end
		else--否则放在原地
			local x, y, z = inst.Transform:GetWorldPosition()
			newmedal.Transform:SetPosition(x, y, z)
		end
	end
	inst:Remove()
end
--主客同步料理列表(食谱显示用)
local function setFoodList(inst,owner)
	if inst.foodlist and #inst.foodlist>0 then
		if owner and owner.medal_food_list then
			local foodstr=""
			for k,v in ipairs(inst.foodlist) do
				foodstr = foodstr..v..","
			end
			owner.medal_food_list:set(foodstr)
		end
	end
end
-------------------------------------------------记录攻击者,确保非亲手击杀的目标也能计数-------------------------------------------------
--当目标死亡或被击败时进行事件推送
local function OnMedalDeath(inst,data)
	if inst.medal_killer_list == nil then
		return
	end
	--克劳斯需要二阶段死了才算
	if inst.prefab~="klaus" or (inst.IsUnchained ~= nil and inst:IsUnchained()) then
		--遍历推送列表
		for k, v in pairs(inst.medal_killer_list) do
			local medal = data and data.afflicter and data.afflicter.components.inventory ~= nil and data.afflicter.components.inventory:EquipMedalWithName(k) or nil
			--若击杀者没有佩戴对应勋章组的勋章,并且有标记的攻击者,则进行推送
			if medal == nil and v ~= nil then
				v:PushEvent("medal_killed",{victim=inst,prefab=k})
				inst.medal_killer_list[k] = nil
			end
		end
		if inst.RemoveMedalDeathListener then
			inst:RemoveMedalDeathListener()--推送后移除监听，防止多次触发
		end
	end
end
--移除监听
local function RemoveMedalDeathListener(inst)
	inst:RemoveEventCallback("death", OnMedalDeath)--死亡
	inst:RemoveEventCallback("minhealth", OnMedalDeath)--被打败
	inst.medal_killer_list = nil--清空击杀列表
	inst.RemoveMedalDeathListener = nil
end
--设定勋章击杀事件(怪物,玩家,勋章)
local function setMedalKillFn(inst,player,medal)
	if player == nil or medal == nil then
		return
	end
	local key = medal.prefab
	if inst.medal_killer_list == nil then
		inst.medal_killer_list = {}--初始化推送列表
	end
	if inst.RemoveMedalDeathListener == nil then
		inst.RemoveMedalDeathListener = RemoveMedalDeathListener--移除监听
		--监听目标死亡
		inst:ListenForEvent("death",OnMedalDeath)
		inst:ListenForEvent("minhealth",OnMedalDeath)
	end
	
	if inst.medal_killer_list[key] == nil or inst.medal_killer_list[key].player ~= player then
		inst.medal_killer_list[key] = player--添加推送列表
	end
end
--攻击目标(玩家,怪物,勋章)
local function MedalHitOther(player,target,medal)
	if target.medal_killer_list ~= nil 
		and target.medal_killer_list[medal.prefab] ~= nil 
		and target.medal_killer_list[medal.prefab] == player then
		return
	end
	--直接砍死了，那就直接算击杀
	if (target.components.health and target.components.health:IsDead()) or target.defeated then
		if target.prefab == "klaus" and target.IsUnchained ~= nil and not target:IsUnchained() then return end--克劳斯需要二阶段死了才算
		if target["medal_kill_sign_"..medal.prefab] ~= nil then return end
		target["medal_kill_sign_"..medal.prefab] = true--添加标记防多次触发
		if medal.medalKilled then
			medal.medalKilled(player,{victim=target,prefab=medal.prefab})
		end
	else--揍了一拳，标记！
		setMedalKillFn(target,player,medal)
	end
end

-------------------------------------------------勋章定义-------------------------------------------------
local medal_defs ={}--勋章列表

-------------------------------------------------烹饪勋章-------------------------------------------------
medal_defs.cook_certificate={
	name="cook_certificate",
	animname="cook_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"showmedalinfo",--显示勋章信息
	-- "eatfoodable",--可吃东西
	},
	grouptag="chefMedal",
	maxuses=TUNING_MEDAL.COOK_MEDAL.MAXUSES,--次数耐久
	onfinishedfn=function(inst)--耐久用完执行的函数
		returnNewMedal(inst,"chef_certificate")
	end,
	onequipfn=function(inst,owner)
		setFoodList(inst,owner)--同步料理列表
		inst:AddTag("medal_cookbook")--查看食谱书
	end,
	onunequipfn=function(inst,owner)
		--清空料理列表
		if owner and owner.medal_food_list then
			owner.medal_food_list:set("")
		end
		inst:RemoveTag("medal_cookbook")
	end,
	extrafn=function(inst)--额外扩展函数
		inst.foodlist={}--料理列表
		inst.HarvestFoodFn=function(inst,foodname,harvester,cookpotname)
			if foodname and IsNativeCookingProduct(foodname) and not table.contains(inst.foodlist,foodname) then
				local fuelnum = TUNING_MEDAL.COOK_MEDAL.CONSUME*(IsNativeCookingProduct(foodname,true) and 2 or 1)--消耗耐久(大厨料理翻倍)
				--消耗耐久
				if inst.components.finiteuses then
					inst.components.finiteuses:Use(fuelnum)
					inst.foodlist[#inst.foodlist+1]=foodname
					setFoodList(inst,harvester)--同步料理列表
					if not RewardToiler(harvester,0.1) then--天道酬勤
						SpawnMedalTips(harvester,fuelnum,10)--弹幕提示
					end
				end
			end
		end
		inst.getMedalInfo = function(inst)--显示当前已记录数量
			if inst.foodlist then
				return STRINGS.MEDAL_INFO.FOODLOG..#inst.foodlist
			end
		end
	end,
	onsavefn=function(inst,data)--扩展存储函数
		--料理列表
		if inst.foodlist and #inst.foodlist>0 then
			data.foodlist=shallowcopy(inst.foodlist)
		end
	end,
	onloadfn=function(inst,data)--扩展加载函数
		--料理列表
		if data and data.foodlist and #data.foodlist>0 then
			inst.foodlist=shallowcopy(data.foodlist)
		end
	end,
}
-------------------------------------------------大厨勋章-------------------------------------------------
--大厨勋章装备函数(勋章,玩家,是否为主厨勋章)
local function chef_onequipfn(inst,owner,isheadchef)
	--去除沃利的食物记忆影响(这里不删组件是为了正常记录沃利吃过的食物)
	if owner.prefab == "warly" then
		if owner.components.foodmemory then
			owner.components.foodmemory:SetMultipliers(TUNING_MEDAL.MEDAL_SAME_OLD_MULTIPLIERS)
		end
		--主厨勋章
		if isheadchef then
			--沃利可吃非料理食物
			if owner.components.eater and  owner.components.eater.preferseatingtags then
				owner.components.eater.preferseatingtags=nil
			end
		end
	end
	--添加标签
	AddMedalTag(owner,"masterchef")--大厨标签
	AddMedalTag(owner,"professionalchef")--调料站
	AddMedalTag(owner,"expertchef")--熟练烹饪标签
	inst:AddTag("medal_cookbook")--查看食谱书
	--监听玩家进食
	owner:ListenForEvent("oneat",speechFood)
end
--大厨勋章卸下函数(勋章,玩家,是否为主厨勋章)
local function chef_onunequipfn(inst,owner,isheadchef)
	--恢复沃利食物记忆
	if owner.prefab == "warly" then
		if owner.components.foodmemory then
			owner.components.foodmemory:SetMultipliers(TUNING.WARLY_SAME_OLD_MULTIPLIERS)
		end
		--主厨勋章
		if isheadchef then
			--取消沃利可吃非料理食物
			if owner.components.eater ~= nil then
				owner.components.eater:SetPrefersEatingTag("preparedfood")
				owner.components.eater:SetPrefersEatingTag("pre-preparedfood")
			end
		end
	end
	--移除标签
	RemoveMedalTag(owner,"masterchef")--大厨
	RemoveMedalTag(owner,"professionalchef")--调料
	RemoveMedalTag(owner,"expertchef")--熟练烹饪标签
	inst:RemoveTag("medal_cookbook")
	--移除监听
	owner:RemoveEventCallback("oneat", speechFood)
	
	--清空料理列表
	if owner and owner.medal_food_list then
		owner.medal_food_list:set("")
	end
end
--大厨勋章
medal_defs.chef_certificate={
	name="chef_certificate",--勋章名
	animname="chef_certificate",--动画名
	--标签列表
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	"showmedalinfo",--显示勋章信息
	-- "eatfoodable",--可吃东西
	},
	grouptag="chefMedal",--勋章组，相同勋章组的勋章不能同时装备
	maxuses=TUNING_MEDAL.CHEF_MEDAL.MAXUSES,--次数耐久
	onfinishedfn=function(inst)--耐久用完执行的函数
		returnNewMedal(inst,"headchef_certificate")
	end,
	--装备勋章函数
	onequipfn=function(inst,owner)
		chef_onequipfn(inst,owner,false)
		setFoodList(inst,owner)--同步料理列表
		if inst.builditemfn then
			owner:ListenForEvent("builditem", inst.builditemfn)
		end
	end,
	--卸下勋章函数
	onunequipfn=function(inst,owner)
		chef_onunequipfn(inst,owner,false)
		if inst.builditemfn then
			owner:RemoveEventCallback("builditem", inst.builditemfn)
		end
	end,
	extrafn=function(inst)--额外扩展函数
		inst.foodlist={}--料理列表
		inst.spiceconsume = 0--调味料理消耗
		--收获料理
		inst.HarvestFoodFn=function(inst,foodname,harvester,cookpotname)
			local fuelnum=nil--消耗耐久
			--调味料理
			if cookpotname=="portablespicer" then
				if inst.spiceconsume < TUNING_MEDAL.CHEF_MEDAL.SPICE_CONSUME_MAX then
					fuelnum = TUNING_MEDAL.CHEF_MEDAL.SPICE_CONSUME
					inst.spiceconsume = inst.spiceconsume + fuelnum
				end
			elseif foodname and IsNativeCookingProduct(foodname,true) and not table.contains(inst.foodlist,foodname) then
				fuelnum=TUNING_MEDAL.CHEF_MEDAL.CONSUME
				inst.foodlist[#inst.foodlist+1]=foodname
				setFoodList(inst,harvester)--同步料理列表
			end
			--消耗耐久
			if fuelnum and inst.components.finiteuses then
				inst.components.finiteuses:Use(fuelnum)
				SpawnMedalTips(harvester,fuelnum,10)--弹幕提示
			end
			RewardToiler(harvester)--天道酬勤
		end
		--制作调料
		inst.builditemfn = function(self,data)
			if inst.spiceconsume ~= nil and inst.spiceconsume >= TUNING_MEDAL.CHEF_MEDAL.SPICE_CONSUME_MAX then
				return
			end
			if inst.components.finiteuses == nil then return end
			if data and data.item and data.item:HasTag("spice") then
				inst.spiceconsume = inst.spiceconsume + TUNING_MEDAL.CHEF_MEDAL.SPICE_CONSUME
				inst.components.finiteuses:Use(TUNING_MEDAL.CHEF_MEDAL.SPICE_CONSUME)
				SpawnMedalTips(self,TUNING_MEDAL.CHEF_MEDAL.SPICE_CONSUME,10)--弹幕提示
			end
		end
		inst.getMedalInfo = function(inst)--显示当前收集进度
			return STRINGS.MEDAL_INFO.FOODLOG2..#inst.foodlist.."\n"..STRINGS.MEDAL_INFO.FOODLOG3..inst.spiceconsume
		end
	end,
	onsavefn=function(inst,data)--扩展存储函数
		--料理列表
		if inst.foodlist and #inst.foodlist>0 then
			data.foodlist=shallowcopy(inst.foodlist)
		end
		--调料消耗耐久
		if inst.spiceconsume > 0 then
			data.spiceconsume = inst.spiceconsume
		end
	end,
	onloadfn=function(inst,data)--扩展加载函数
		--料理列表
		if data and data.foodlist and #data.foodlist>0 then
			inst.foodlist=shallowcopy(data.foodlist)
		end
		--调料消耗耐久
		if data and data.spiceconsume then
			inst.spiceconsume = data.spiceconsume
		end
	end,
}
--主厨勋章
medal_defs.headchef_certificate={
	name="headchef_certificate",--勋章名
	animname="headchef_certificate",--动画名
	--标签列表
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	},
	isfinal=true,--是最终勋章
	grouptag="chefMedal",--勋章组，相同勋章组的勋章不能同时装备
	--装备勋章函数
	onequipfn=function(inst,owner)
		chef_onequipfn(inst,owner,true)
		owner:AddTag("seasoningchef")--主厨标签
	end,
	--卸下勋章函数
	onunequipfn=function(inst,owner)
		chef_onunequipfn(inst,owner,true)
		owner:RemoveTag("seasoningchef")--主厨标签
	end,
	extrafn=function(inst)--额外扩展函数
		inst.HarvestFoodFn=function(inst,foodname,harvester,cookpotname)
			--在红晶锅收获大厨料理可获得红晶锅蓝图
			if cookpotname and cookpotname=="medal_cookpot" and foodname and IsNativeCookingProduct(foodname,true) then
				if harvester and not harvester.learned_medal_cookpot and harvester.components.builder and not harvester.components.builder:KnowsRecipe("medal_cookpot") and harvester.components.inventory then
					local blueprint=SpawnPrefab("medal_cookpot_blueprint")
					if blueprint then
						harvester.learned_medal_cookpot = true--标记一下防止多拿蓝图刷纸
						harvester.components.inventory:GiveItem(blueprint)
					end
				end
			end
			RewardToiler(harvester)--天道酬勤
		end
	end,
}
-------------------------------------------------蒙昧勋章-------------------------------------------------
medal_defs.wisdom_test_certificate={
	name="wisdom_test_certificate",
	animname="wisdom_test_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	},
	grouptag="wisdomMedal",
	maxuses=TUNING_MEDAL.WISDOM_TEST.MAXUSES,--次数耐久
	onfinishedfn=function(inst)--耐久用完执行的函数
		returnNewMedal(inst,"wisdom_certificate")
	end,
	onequipfn=function(inst,owner)
		inst:AddTag("examable")--可答题的
	end,
	onunequipfn=function(inst,owner)
		inst:RemoveTag("examable")
	end,
	--客户端扩展函数
	client_extrafn=function(inst)--额外扩展函数
		--做出选择
		inst.MakeChoice = function(inst,answer,answerer)
			if TheWorld.ismastersim then
				if inst.components.medal_examable then
					inst.components.medal_examable:MakeChoice(answer,answerer)
				end
			else
				SendModRPCToServer(MOD_RPC.functional_medal.MakeChoice, inst, answer)
			end
		end
	end,
	extrafn=function(inst)--额外扩展函数
		inst:AddComponent("medal_examable")--答题组件
	end,
}
-------------------------------------------------智慧勋章-------------------------------------------------
medal_defs.wisdom_certificate={
	name="wisdom_certificate",
	animname="wisdom_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	-- "copyfunctional",--可印刻
	},
	isfinal=true,--是最终勋章
	grouptag="wisdomMedal",
	maxuses=TUNING_MEDAL.WISDOM_MEDAL.MAXUSES,--次数耐久
	onfinishedfn=function(inst)--耐久用完执行的函数
		
	end,
	medal_repair_common={--可补充耐久
		mandrakeberry = TUNING_MEDAL.WISDOM_MEDAL.ADDUSES_TINY,--曼德拉果
		toil_money = TUNING_MEDAL.WISDOM_MEDAL.ADDUSES_LESS,--血汗钱
		xinhua_dictionary = TUNING_MEDAL.WISDOM_MEDAL.ADDUSES_MORE,--新华字典
	},
	onequipfn=function(inst,owner)
		AddMedalComponent(owner,"reader")--添加读者组件
		AddMedalTag(owner,"bookbuilder")--图书制作者
		owner:AddTag("wisdombuilder")--智慧作者
		
		--小鱼人正常读书
		if owner:HasTag("aspiring_bookworm") then
			owner.components.reader:SetAspiringBookworm(false)
			owner.temporary_nomalreader=true--临时正常读者
		end
		--科技加一级
		if owner.components.builder and owner.components.builder.science_bonus then
			-- if owner.components.builder.science_bonus<1 then
			if owner.components.builder.science_bonus<1 and owner.replica.builder and owner.replica.builder.classified~=nil then
				owner.components.builder.science_bonus = 1
				owner.temporary_wisdom=true--临时智慧
			end
		end
		--原本不会读书的角色增加消耗(包括小鱼妹)
		if IsMedalTempCom(owner,"reader") or owner.temporary_nomalreader then
			owner.components.reader:SetSanityPenaltyMultiplier(owner.components.reader:GetSanityPenaltyMultiplier()*(HasOriginMedal(owner) and 1 or 1.5))
		else--原本会读书的角色减少消耗
			owner.components.reader:SetSanityPenaltyMultiplier(owner.components.reader:GetSanityPenaltyMultiplier()*(HasOriginMedal(owner) and 0.5 or 0.8))
		end

		owner:PushEvent("refreshcrafting")--更新制作栏
	end,
	onunequipfn=function(inst,owner)
		--精神消耗还原
		if owner.components.reader then
			if IsMedalTempCom(owner,"reader") or owner.temporary_nomalreader then
				owner.components.reader:SetSanityPenaltyMultiplier(owner.components.reader:GetSanityPenaltyMultiplier()/(HasOriginMedal(owner) and 1 or 1.5))
			else
				owner.components.reader:SetSanityPenaltyMultiplier(owner.components.reader:GetSanityPenaltyMultiplier()/(HasOriginMedal(owner) and 0.5 or 0.8))
			end
		end
		RemoveMedalComponent(owner,"reader")--移除读者组件
		RemoveMedalTag(owner,"bookbuilder")--移除图书制作者
		owner:RemoveTag("wisdombuilder")
		--小鱼人变回原来的读书方式
		if owner.temporary_nomalreader then
			owner.components.reader:SetAspiringBookworm(true)
			owner:AddTag("aspiring_bookworm")
		end
		--还原智慧
		if owner.temporary_wisdom then
			if owner.components.builder and owner.components.builder.science_bonus then
				if owner.components.builder.science_bonus >0 and owner.replica.builder and owner.replica.builder.classified~=nil then
					owner.components.builder.science_bonus=0
				end
			end
			owner.temporary_wisdom=nil
		end
		owner:PushEvent("refreshcrafting")--更新制作栏
	end,
}
-------------------------------------------------巧手考验勋章-------------------------------------------------
--主客同步建造列表(制作栏显示用)
local function setBuildList(inst,owner)
	if inst.buildlist then
		if owner and owner.medal_build_list then
			local buildstr = inst:HasTag("usesdepleted") and "" or json.encode(inst.buildlist)--耐久没了的时候要把数据清掉
			owner.medal_build_list:set(buildstr)
		end
	end
end
--巧手考验勋章消耗耐久(勋章,事件数据,玩家,基础扣除点数)
local function handyTestCount(inst,data,player,basenum)
	local MEDAL_MULT = TUNING_MEDAL.HANDY_TEST.CONSUME_MULT
	if data and data.item then-- and data.item.OnBuiltFn==nil then
		--消耗耐久
		if inst.components.finiteuses and inst.buildlist then
			local consume = 0
			if inst.buildlist[data.item.prefab] == nil then
				consume = 5*MEDAL_MULT--第一次做消耗更多
				inst.buildlist[data.item.prefab] = consume
			elseif inst.buildlist[data.item.prefab]<TUNING_MEDAL.HANDY_TEST.SINGLE_MAX then
				consume = basenum*MEDAL_MULT--之后没达到上限就每次都扣
				inst.buildlist[data.item.prefab] = inst.buildlist[data.item.prefab] + consume
			end
			if consume>0 then
				inst.components.finiteuses:Use(consume)
				setBuildList(inst,player)--同步建造列表
				--天道酬勤
				if not RewardToiler(player,0.04) then
					SpawnMedalTips(player,consume,3)--弹幕提示
				end
			end
		end
	end
end

medal_defs.handy_test_certificate={
	name="handy_test_certificate",
	animname="handy_test_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	},
	maxuses=TUNING_MEDAL.HANDY_TEST.MAXUSES,--次数耐久
	onfinishedfn=function(inst)--耐久用完执行的函数
		returnNewMedal(inst,"handy_certificate")
	end,
	onequipfn=function(inst,owner)
		owner:ListenForEvent("builditem", inst.builditemfn)
		owner:ListenForEvent("buildstructure", inst.buildstructurefn)
		setBuildList(inst,owner)--同步建造列表
	end,
	onunequipfn=function(inst,owner)
		owner:RemoveEventCallback("builditem", inst.builditemfn)
		owner:RemoveEventCallback("buildstructure", inst.buildstructurefn)
		if owner and owner.medal_build_list then
			owner.medal_build_list:set("")
		end
	end,
	extrafn=function(inst)
		inst.buildlist={}--建造列表
		--监听玩家制作物品
		inst.builditemfn = function(self,data)
			handyTestCount(inst,data,self,1)
		end
		--监听玩家制作建筑
		inst.buildstructurefn = function(self,data)
			handyTestCount(inst,data,self,2)
		end
	end,
	onsavefn=function(inst,data)--扩展存储函数
		--建造列表
		if inst.buildlist then
			data.buildlist=shallowcopy(inst.buildlist)
		end
	end,
	onloadfn=function(inst,data)--扩展加载函数
		--建造列表
		if data and data.buildlist then
			inst.buildlist=shallowcopy(data.buildlist)
		end
	end,
}
-------------------------------------------------巧手勋章-------------------------------------------------
--天道酬勤
local function handy_build(player,data)
	if data and data.item and not data.item.OnBuiltFn then
		RewardToiler(player)
	end
end
medal_defs.handy_certificate={
	name="handy_certificate",
	animname="handy_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	},
	isfinal=true,--是最终勋章
	onequipfn=function(inst,owner)
		AddMedalTag(owner,"handyperson")--女工科技
		if not owner:HasTag("portableengineer") then
			AddMedalTag(owner,"basicengineer")--女工科技
		end
		owner:AddTag("has_handy_medal")--拥有巧手勋章，制作专属道具
		owner:PushEvent("refreshcrafting")--更新制作栏
		owner:ListenForEvent("builditem", handy_build)
		owner:ListenForEvent("buildstructure", handy_build)
	end,
	onunequipfn=function(inst,owner)
		RemoveMedalTag(owner,"handyperson")--女工科技
		if owner:HasTag("portableengineer") then
			if owner.medal_tag and owner.medal_tag["basicengineer"] and not owner:HasTag("basicengineer") then
				owner.medal_tag["basicengineer"] = nil
			end
		else
			RemoveMedalTag(owner,"basicengineer")--女工科技
		end
		owner:RemoveTag("has_handy_medal")
		owner:PushEvent("refreshcrafting")--更新制作栏
		owner:RemoveEventCallback("builditem", handy_build)
		owner:RemoveEventCallback("buildstructure", handy_build)
	end,
}
-------------------------------------------------虫木勋章-------------------------------------------------
local PLANTS_RANGE = 1--生成小花的范围
local MAX_PLANTS = 18--最多允许周围有多少朵小花
local PLANTFX_TAGS = { "wormwood_plant_fx" }
--随机花朵列表
local plantpool = { 1, 2, 3, 4 }
for i = #plantpool, 1, -1 do
	table.insert(plantpool, table.remove(plantpool, math.random(i)))
end
--生成小花
local function PlantTick(inst,owner)
    if not owner.entity:IsVisible() then
        return
    end
    local x, y, z = owner.Transform:GetWorldPosition()
	--生成小花
    if #TheSim:FindEntities(x, y, z, PLANTS_RANGE, PLANTFX_TAGS) < MAX_PLANTS then
        local map = TheWorld.Map
        local pt = Vector3(0, 0, 0)
        local offset = FindValidPositionByFan(
            math.random() * 2 * PI,
            math.random() * PLANTS_RANGE,
            3,
            function(offset)
                pt.x = x + offset.x
                pt.z = z + offset.z
                local tile = map:GetTileAtPoint(pt:Get())
                return tile ~= GROUND.ROCKY
                    and tile ~= GROUND.ROAD
                    and tile ~= GROUND.WOODFLOOR
                    and tile ~= GROUND.CARPET
                    and tile ~= GROUND.IMPASSABLE
                    and tile ~= GROUND.INVALID
                    and #TheSim:FindEntities(pt.x, 0, pt.z, .5, PLANTFX_TAGS) < 3
                    and map:IsDeployPointClear(pt, nil, .5)
                    and not map:IsPointNearHole(pt, .4)
            end
        )
        if offset ~= nil then
            local plant = SpawnPrefab("wormwood_plant_fx")
            plant.Transform:SetPosition(x + offset.x, 0, z + offset.z)
            --randomize, favoring ones that haven't been used recently
            local rnd = math.random()
            rnd = table.remove(plantpool, math.clamp(math.ceil(rnd * rnd * #plantpool), 1, #plantpool))
            table.insert(plantpool, rnd)
            plant:SetVariation(rnd)
        end
    end
end

--抚摸
local function strokeFn(inst,player)
	if inst.medal_fertility and inst.medal_fertility>0 then
		inst.medal_fertility=inst.medal_fertility-1--消耗肥料值
		--范围照料
		local x, y, z = inst.Transform:GetWorldPosition()
		for _, v in pairs(TheSim:FindEntities(x, y, z, TUNING_MEDAL.PLANT_MEDAL.INTERACT_RANGE, {"tendable_farmplant"},{ "FX", "DECOR", "INLIMBO" })) do
			if v.components.farmplanttendable ~= nil then
				v.components.farmplanttendable:TendTo(player)
			end
		end
		--开花(一朵)
		PlantTick(inst,player)
		--安抚跟随玩家的曼德拉草
        if player and player.components.leader then
            player.components.leader:RemoveFollowersByTag("character",function(follower)
                if follower and follower.prefab=="mandrake_active" and follower.components.health then
                    local planted = SpawnPrefab("mandrake_planted")
                    planted.Transform:SetPosition(follower.Transform:GetWorldPosition())
                    planted:replant(follower)
                    follower:Remove()
                    return true
                end
            end)
        end
	else
		MedalSay(player,STRINGS.MEDAL_WORMWOOD_FLOWER_SPEECH.NOFERTILITY)
	end
end

medal_defs.plant_certificate={
	name="plant_certificate",
	animname="plant_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	"showmedalinfo",--显示勋章信息
	"needfertilize",--可施肥
	},
	grouptag="plantMedal",
	maxuses=TUNING_MEDAL.PLANT_MEDAL.MAXUSES,--次数耐久
	onfinishedfn=function(inst)--耐久用完执行的函数
		returnNewMedal(inst,"transplant_certificate",function(inst,newmedal)
			if inst.medal_fertility then
				newmedal.medal_fertility = inst.medal_fertility--继承肥料值
			end
		end)
	end,
	onequipfn=function(inst,owner)
		AddMedalTag(owner,"plantkin")--植物人
		owner:AddTag("has_plant_medal")--拥有虫木勋章
		owner:PushEvent("refreshcrafting")--更新制作栏
		--复制的勋章不需要监听
		if not inst:HasTag("blank_certificate") then
			inst:AddTag("canstrokemedal")--可被抚摸
			--监听玩家采摘事件
			inst.picksomething = function(self,data)
				if data and data.loot then
					--采摘的是农场作物
					if data.object and data.object:HasTag("farm_plant") then
						local prefab=data.loot[1] and data.loot[1].prefab--获取采摘的预置物名
						if prefab and inst.picklist then
							--从巨型作物列表里寻找对应作物，如果有则移除，并扣除耐久
							local product=table.removearrayvalue(inst.picklist,prefab)
							if product and inst.components.finiteuses then
								inst.components.finiteuses:Use(TUNING_MEDAL.PLANT_MEDAL.CONSUME)
								SpawnMedalTips(self,TUNING_MEDAL.PLANT_MEDAL.CONSUME,4)--弹幕提示
							end
						end
					end
				end
			end
			owner:ListenForEvent("picksomething", inst.picksomething)
		end
		--潮湿不掉san
		if owner.components.sanity and not owner.components.sanity.no_moisture_penalty then
			owner.components.sanity.no_moisture_penalty = true
			owner.temporary_no_moisture=true
		end
	end,
	onunequipfn=function(inst,owner)
		RemoveMedalTag(owner,"plantkin")--植物人
		owner:RemoveTag("has_plant_medal")
		owner:PushEvent("refreshcrafting")--更新制作栏
		if owner.components.sanity and owner.temporary_no_moisture and not owner:HasTag("merm_builder") then
			owner.components.sanity.no_moisture_penalty = nil
			owner.temporary_no_moisture=nil
		end
		--复制的勋章不需要监听
		if not inst:HasTag("blank_certificate") then
			inst:RemoveTag("canstrokemedal")
			owner:RemoveEventCallback("picksomething", inst.picksomething)
		end
	end,
	extrafn=function(inst)--额外扩展函数
		inst.picklist={--巨型作物列表
			"asparagus_oversized",
			"garlic_oversized",
			"pumpkin_oversized",
			"corn_oversized",
			"onion_oversized",
			"potato_oversized",
			"dragonfruit_oversized",
			"pomegranate_oversized",
			"eggplant_oversized",
			"tomato_oversized",
			"watermelon_oversized",
			"pepper_oversized",
			"durian_oversized",
			"carrot_oversized",
			"immortal_fruit_oversized",
			"medal_gift_fruit_oversized",
		}
		inst:AddComponent("deployable")
		inst.components.deployable.ondeploy = function(inst, pt, deployer)
			local tree = SpawnPrefab("medal_wormwood_flower")
			if tree ~= nil then
				tree.Transform:SetPosition(pt:Get())
				--附加采摘列表
				if inst.picklist then
					tree.picklist=shallowcopy(inst.picklist)
				end
				if deployer ~= nil and deployer.SoundEmitter ~= nil then
					deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
				end
				tree.medal_fertility=inst.medal_fertility--转移肥料值
				tree.medal_finiteuses=inst.components.finiteuses and inst.components.finiteuses:GetUses()--继承耐久
				inst:Remove()
			end
		end
		inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
		inst.strokeFn=strokeFn--抚摸函数
		inst.getMedalInfo = function(inst)--显示采摘目标、肥力
			local str
			if inst.medal_fertility then
				str = STRINGS.MEDAL_INFO.FERTILITY..inst.medal_fertility
			end
			
			if inst.picklist and #inst.picklist>0 then
				local medalstr=""
				local count=0
				for _,v in ipairs(inst.picklist) do
					local prefabname= STRINGS.NAMES[string.upper(v)] or v
					count=count+1
					medalstr=medalstr..prefabname..(count>=5 and "\n" or ",")
					count=count%5
				end
				str = (str or "").."\n"..STRINGS.MEDAL_INFO.NEEDPICK.."\n"..string.sub(medalstr,1,-2)
			end
			return str
		end
	end,
	placer={
		name="plant_certificate_placer",
		bank_placer="medal_wormwood_flower",
		build_placer="medal_wormwood_flower",
		anim_placer="medal_wormwood_flower",
	},
	onsavefn=function(inst,data)--扩展存储函数
		--肥力
		if inst.medal_fertility and inst.medal_fertility>0 then
			data.medal_fertility=inst.medal_fertility
		end
		--采摘列表
		if inst.picklist and #inst.picklist>0 then
			data.picklist=shallowcopy(inst.picklist)
		end
	end,
	onloadfn=function(inst,data)--扩展加载函数
		--肥力
		if data and data.medal_fertility then
			inst.medal_fertility=data.medal_fertility
		end
		--采摘列表
		if data and data.picklist and #data.picklist>0 then
			inst.picklist=shallowcopy(data.picklist)
		end
	end,
}
-------------------------------------------------植物勋章-------------------------------------------------
medal_defs.transplant_certificate={
	name="transplant_certificate",
	animname="transplant_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	"showmedalinfo",--显示勋章信息
	"needfertilize",--可施肥
	},
	isfinal=true,--是最终勋章
	grouptag="plantMedal",
	onequipfn=function(inst,owner)
		AddMedalTag(owner,"plantkin")--植物人
		owner:AddTag("has_plant_medal")--拥有虫木勋章
		owner:AddTag("has_transplant_medal")--植物勋章
		owner:PushEvent("refreshcrafting")--更新制作栏
		--潮湿不掉san
		if owner.components.sanity and not owner.components.sanity.no_moisture_penalty then
			owner.components.sanity.no_moisture_penalty = true
			owner.temporary_no_moisture=true
		end
		--复制的勋章不可抚摸
		if not inst:HasTag("blank_certificate") then
			inst:AddTag("canstrokemedal")--可被抚摸
		end
		if HasOriginMedal(owner) then
			inst:AddTag("bramble_resistant")--免收尖刺伤害
		end
	end,
	onunequipfn=function(inst,owner)
		RemoveMedalTag(owner,"plantkin")--植物人
		owner:RemoveTag("has_plant_medal")
		owner:RemoveTag("has_transplant_medal")
		owner:PushEvent("refreshcrafting")--更新制作栏
		if owner.components.sanity and owner.temporary_no_moisture and not owner:HasTag("merm_builder") then
			owner.components.sanity.no_moisture_penalty = nil
			owner.temporary_no_moisture=nil
		end
		--复制的勋章不可抚摸
		if not inst:HasTag("blank_certificate") then
			inst:RemoveTag("canstrokemedal")--可被抚摸
		end
		inst:RemoveTag("bramble_resistant")--免收尖刺伤害
	end,
	extrafn=function(inst)--额外扩展函数
		inst:AddComponent("deployable")
		inst.components.deployable.ondeploy = function(inst, pt, deployer)
			local tree = SpawnPrefab("medal_wormwood_flower")
			if tree ~= nil then
				tree.Transform:SetPosition(pt:Get())
				if deployer ~= nil and deployer.SoundEmitter ~= nil then
					deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
				end
				tree.is_transplant=true--是植物勋章
				tree.medal_fertility=inst.medal_fertility--转移肥料值
				inst:Remove()
			end
		end
		inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
		inst.strokeFn=strokeFn--抚摸函数
		inst.getMedalInfo = function(inst)--显示肥力
			if inst.medal_fertility then
				return STRINGS.MEDAL_INFO.FERTILITY..inst.medal_fertility
			end
		end
	end,
	placer={
		name="transplant_certificate_placer",
		bank_placer="medal_wormwood_flower",
		build_placer="medal_wormwood_flower",
		anim_placer="medal_wormwood_flower",
	},
	onsavefn=function(inst,data)--扩展存储函数
		--肥力
		if inst.medal_fertility and inst.medal_fertility>0 then
			data.medal_fertility=inst.medal_fertility
		end
	end,
	onloadfn=function(inst,data)--扩展加载函数
		--肥力
		if data and data.medal_fertility then
			inst.medal_fertility=data.medal_fertility
		end
	end,
}
-------------------------------------------------丰收勋章-------------------------------------------------
local function picksomething(player,data)
	--采摘田里的农作物或嫁接树
	if data and data.object then
		if data.object:HasTag("medal_fruit_tree") then
			RewardToiler(player)--天道酬勤
		elseif data.object:HasTag("farm_plant") then
			RewardToiler(player,0.01)--天道酬勤
		end
	end
end
medal_defs.harvest_certificate={
	name="harvest_certificate",
	animname="harvest_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	},
	isfinal=true,--是最终勋章
	onequipfn=function(inst,owner)
		owner:AddTag("medal_fastpicker")--特殊快采动作
		owner.quickpickmedal=true--快采勋章
		owner:ListenForEvent("picksomething", picksomething)--采摘
	end,
	onunequipfn=function(inst,owner)
		owner:RemoveTag("medal_fastpicker")
		owner.quickpickmedal=nil--快采勋章
		owner:RemoveEventCallback("picksomething", picksomething)
	end,
}
-------------------------------------------------伐木勋章-------------------------------------------------
--伐木勋章耐久消耗计算
local function finishedchop(inst,player,data)
	if data ~= nil and data.action ~= nil then
		if data.action.id and data.action.id=="CHOP" and data.target and not data.target:HasTag("burnt") then
			local consume=1--消耗耐久
			if data.target.prefab=="deciduoustree" and data.target.monster then
				consume=20--桦木精
			elseif data.target.prefab=="livingtree_halloween" then
				consume=6--万圣节活木树
			elseif data.target.prefab=="livingtree" then
				consume=10--完全正常的树
			elseif data.target.components.growable then
				consume=math.fmod(data.target.components.growable.stage,4)--大于3级就枯萎了，枯萎的没经验
			end
			--伍迪耐久消耗减半
			if player.prefab=="woodie" then
				consume=consume/2
			end
			if consume>0 then
				consume=consume*TUNING_MEDAL.CHOP_MEDAL.CONSUME_MULT--根据难度计算消耗
				--消耗耐久
				if inst.components.finiteuses then
					inst.components.finiteuses:Use(consume)
					--天道酬勤
					if not RewardToiler(player, 0.01) then
						SpawnMedalTips(player,consume,1)--弹幕提示
					end
				end
			end
		end
	end
end
--初级伐木勋章
medal_defs.smallchop_certificate={
	name="smallchop_certificate",
	animname="smallchop_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	},
	grouptag="chopMedal",
	maxuses=TUNING_MEDAL.CHOP_MEDAL.SMALL_MAXUSES,--次数耐久
	onfinishedfn=function(inst)--耐久用完执行的函数
		returnNewMedal(inst,"mediumchop_certificate")
	end,
	medal_addexp_loot = {log=TUNING_MEDAL.CHOP_MEDAL.CONSUME},--可给勋章增加熟练度
	onequipfn=function(inst,owner)
		owner.small_chop=true
		owner:PushEvent("changechopmedal")
		--复制的勋章不需要监听
		if inst.finishedwork ~= nil then
			owner:ListenForEvent("finishedwork", inst.finishedwork)
		end
	end,
	onunequipfn=function(inst,owner)
		owner.small_chop=nil
		owner:PushEvent("changechopmedal")
		--复制的勋章不需要监听
		if inst.finishedwork ~= nil then
			owner:RemoveEventCallback("finishedwork", inst.finishedwork)
		end
	end,
	extrafn=function(inst)
		inst.finishedwork=function(player,data)
			finishedchop(inst,player,data)
		end
	end,
}
--中级伐木勋章
medal_defs.mediumchop_certificate={
	name="mediumchop_certificate",
	animname="mediumchop_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	},
	grouptag="chopMedal",
	maxuses=TUNING_MEDAL.CHOP_MEDAL.MEDIUM_MAXUSES,--次数耐久
	onfinishedfn=function(inst)--耐久用完执行的函数
		returnNewMedal(inst,"largechop_certificate")
	end,
	medal_addexp_loot = {log=TUNING_MEDAL.CHOP_MEDAL.CONSUME},--可给勋章增加熟练度
	onequipfn=function(inst,owner)
		owner.medium_chop=true
		owner:PushEvent("changechopmedal")
		AddMedalTag(owner,"woodcutter")--伐木工标签
		if owner.components.workmultiplier and owner.prefab=="woodie" then 
			owner.components.workmultiplier:AddMultiplier(ACTIONS.CHOP,2,inst)--砍树效率翻倍
		end
		--复制的勋章不需要监听
		if inst.finishedwork ~= nil then
			owner:ListenForEvent("finishedwork", inst.finishedwork)
		end
	end,
	onunequipfn=function(inst,owner)
		owner.medium_chop=nil
		owner:PushEvent("changechopmedal")
		RemoveMedalTag(owner,"woodcutter")--伐木工标签
		if owner.components.workmultiplier and owner.prefab=="woodie" then 
			owner.components.workmultiplier:RemoveMultiplier(ACTIONS.CHOP,inst)
		end
		--复制的勋章不需要监听
		if inst.finishedwork ~= nil then
			owner:RemoveEventCallback("finishedwork", inst.finishedwork)
		end
	end,
	extrafn=function(inst)
		inst.finishedwork=function(player,data)
			finishedchop(inst,player,data)
		end
	end,
}
--伐木后可能触发天道酬勤奇遇
local function largechop_finishwork(player,data)
	if data ~= nil and data.action ~= nil and data.action.id and data.action.id=="CHOP" then
		RewardToiler(player)--天道酬勤
	end
end
--高级伐木勋章
medal_defs.largechop_certificate={
	name="largechop_certificate",
	animname="largechop_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	},
	isfinal=true,--是最终勋章
	grouptag="chopMedal",
	onequipfn=function(inst,owner)
		owner.large_chop=true
		owner:PushEvent("changechopmedal")
		AddMedalTag(owner,"woodcutter")--伐木工标签
		if owner.components.workmultiplier then 
			local added = HasOriginMedal(owner) and 1 or 0--本源勋章额外增加效率
			if owner.prefab=="woodie" then
				owner.components.workmultiplier:AddMultiplier(ACTIONS.CHOP,3 + added,inst)--砍树效率翻倍
			else
				owner.components.workmultiplier:AddMultiplier(ACTIONS.CHOP,2 + added,inst)--砍树效率翻倍
			end
		end
		owner:ListenForEvent("finishedwork", largechop_finishwork)
	end,
	onunequipfn=function(inst,owner)
		owner.large_chop=nil
		owner:PushEvent("changechopmedal")
		RemoveMedalTag(owner,"woodcutter")--伐木工标签
		if owner.components.workmultiplier then 
			owner.components.workmultiplier:RemoveMultiplier(ACTIONS.CHOP,inst)
		end
		owner:RemoveEventCallback("finishedwork", largechop_finishwork)
	end,
}
-------------------------------------------------矿工勋章-------------------------------------------------
--矿工勋章耐久消耗计算
local function finishedmine(inst,player,data)
	if data ~= nil and data.action ~= nil then
		if data.action.id and data.action.id=="MINE" then
			local consume=1--消耗耐久
			local consumeList={
				rock_moon_shell=10,--巨型月石
				statueglommer=10,--格罗姆雕像
				saltstack=5,--盐矿
				ruins_statue_mage=5,--远古雕像
				ruins_statue_mage_nogem=5,--没宝石的远古雕像
				ruins_statue_head=5,--远古头部雕像
				ruins_statue_head_nogem=5,--没宝石的远古头部雕像
				statueharp=5,--丘比特雕像
				statuemaxwell=5,--老麦雕像
				statue_marble=5,--大理石雕像
				rock_avocado_fruit=0,--石果
				rock_petrified_tree=2,--石化树
			}
			--计算需要消耗的耐久
			if data.target then
				if consumeList[data.target.prefab]~=nil then
					consume=consumeList[data.target.prefab]
				elseif data.target.components.growable then
					consume=data.target.components.growable.stage
				end
			end
			if consume>0 then
				consume=consume*TUNING_MEDAL.MINER_MEDAL.CONSUME_MULT--根据难度计算消耗
				--消耗耐久
				if inst.components.finiteuses then
					inst.components.finiteuses:Use(consume)
					--天道酬勤
					if not RewardToiler(player, 0.01) then
						SpawnMedalTips(player,consume,2)--弹幕提示
					end
				end
			end
		end
	end
end
--初级矿工勋章
medal_defs.smallminer_certificate={
	name="smallminer_certificate",
	animname="smallminer_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	"minedoingold",--矿石做旧
	},
	grouptag="minerMedal",
	maxuses=TUNING_MEDAL.MINER_MEDAL.SMALL_MAXUSES,--次数耐久
	onfinishedfn=function(inst)--耐久用完执行的函数
		returnNewMedal(inst,"mediumminer_certificate")
	end,
	medal_addexp_loot = {rocks=TUNING_MEDAL.MINER_MEDAL.CONSUME,nitre=TUNING_MEDAL.MINER_MEDAL.CONSUME,flint=TUNING_MEDAL.MINER_MEDAL.CONSUME},--可给勋章增加熟练度
	onequipfn=function(inst,owner)
		owner.small_mine=true
		owner:PushEvent("changeminermedal")
		--复制的勋章不需要监听
		if inst.finishedwork ~= nil then
			owner:ListenForEvent("finishedwork", inst.finishedwork)
		end
	end,
	onunequipfn=function(inst,owner)
		owner.small_mine=nil
		owner:PushEvent("changeminermedal")
		--复制的勋章不需要监听
		if inst.finishedwork ~= nil then
			owner:RemoveEventCallback("finishedwork", inst.finishedwork)
		end
	end,
	extrafn=function(inst)
		inst.finishedwork=function(player,data)
			finishedmine(inst,player,data)
		end
	end,
}
--中级矿工勋章
medal_defs.mediumminer_certificate={
	name="mediumminer_certificate",
	animname="mediumminer_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	"minedoingold",--矿石做旧
	},
	grouptag="minerMedal",
	maxuses=TUNING_MEDAL.MINER_MEDAL.MEDIUM_MAXUSES,--次数耐久
	onfinishedfn=function(inst)--耐久用完执行的函数
		returnNewMedal(inst,"largeminer_certificate")
	end,
	medal_addexp_loot = {rocks=TUNING_MEDAL.MINER_MEDAL.CONSUME,nitre=TUNING_MEDAL.MINER_MEDAL.CONSUME,flint=TUNING_MEDAL.MINER_MEDAL.CONSUME},--可给勋章增加熟练度
	onequipfn=function(inst,owner)
		owner.medium_mine=true
		owner:PushEvent("changeminermedal")
		if owner.components.workmultiplier then 
			owner.components.workmultiplier:AddMultiplier(ACTIONS.MINE,1.5,inst)--挖矿效率翻倍
		end
		--复制的勋章不需要监听
		if inst.finishedwork ~= nil then
			owner:ListenForEvent("finishedwork", inst.finishedwork)
		end
	end,
	onunequipfn=function(inst,owner)
		owner.medium_mine=nil
		owner:PushEvent("changeminermedal")
		if owner.components.workmultiplier then 
			owner.components.workmultiplier:RemoveMultiplier(ACTIONS.MINE,inst)
		end
		--复制的勋章不需要监听
		if inst.finishedwork ~= nil then
			owner:RemoveEventCallback("finishedwork", inst.finishedwork)
		end
	end,
	extrafn=function(inst)
		inst.finishedwork=function(player,data)
			finishedmine(inst,player,data)
		end
	end,
}
--挖矿后可能触发天道酬勤奇遇
local function largeminer_finishwork(player,data)
	if data ~= nil and data.action ~= nil and data.action.id and data.action.id=="MINE" then
		RewardToiler(player)--天道酬勤
	end
end
--高级矿工勋章
medal_defs.largeminer_certificate={
	name="largeminer_certificate",
	animname="largeminer_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	},
	isfinal=true,--是最终勋章
	grouptag="minerMedal",
	onequipfn=function(inst,owner)
		owner.large_mine=true
		owner:PushEvent("changeminermedal")
		if owner.components.workmultiplier then
			local added = HasOriginMedal(owner) and 1 or 0--本源勋章额外增加效率
			owner.components.workmultiplier:AddMultiplier(ACTIONS.MINE,3 + added,inst)--挖矿效率翻倍
		end
		owner:ListenForEvent("finishedwork", largeminer_finishwork)
	end,
	onunequipfn=function(inst,owner)
		owner.large_mine=nil
		owner:PushEvent("changeminermedal")
		if owner.components.workmultiplier then 
			owner.components.workmultiplier:RemoveMultiplier(ACTIONS.MINE,inst)
		end
		owner:RemoveEventCallback("finishedwork", largeminer_finishwork)
	end,
}
-------------------------------------------------友善勋章-------------------------------------------------
medal_defs.friendly_certificate={
	name="friendly_certificate",
	animname="friendly_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	},
	-- isfinal=true,--是最终勋章
	grouptag="friendlyMedal",
	maxuses=TUNING_MEDAL.FRIENDLY_MEDAL.MAXUSES,--次数耐久
	onfinishedfn=function(inst)--耐久用完执行的函数
		returnNewMedal(inst,"bosom_friend_certificate")
	end,
	onequipfn=function(inst,owner)
		--移除怪物标签
		if owner:HasTag("monster") then
			owner:RemoveTag("monster")
			owner.friendlymonster=true--友好怪物
		end
		owner:ListenForEvent("onhitother", inst.losefriendfn)
		owner:ListenForEvent("gainfriendship", inst.gainfriendshipfn)
	end,
	onunequipfn=function(inst,owner)
		if owner.friendlymonster then
			owner:AddTag("monster")
			owner.friendlymonster=nil
		end
		owner:RemoveEventCallback("onhitother", inst.losefriendfn)
		owner:RemoveEventCallback("gainfriendship", inst.gainfriendshipfn)
	end,
	extrafn=function(inst)
		--友善勋章监听函数
		inst.losefriendfn = function(self, data)
			if data and data.target then
				--装备友善勋章打猪人和兔人会失去勋章
				if data.target.prefab=="pigman" or data.target.prefab=="bunnyman" or data.target.prefab=="catcoon" then
					if not data.target:HasTag("werepig") and not data.target:HasTag("guard") then
						self.SoundEmitter:PlaySound("dontstarve/wilson/use_armour_break")
						inst:Remove()
					end
				end
			end
		end
		inst.gainfriendshipfn = function(self)
			--消耗耐久
			if inst.components.finiteuses then
				inst.components.finiteuses:Use(1*TUNING_MEDAL.FRIENDLY_MEDAL.CONSUME_MULT)
				SpawnMedalTips(self,1*TUNING_MEDAL.FRIENDLY_MEDAL.CONSUME_MULT,12)--弹幕提示
			end
		end
	end,
}
-------------------------------------------------挚友勋章-------------------------------------------------
medal_defs.bosom_friend_certificate={
	name="bosom_friend_certificate",
	animname="bosom_friend_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	},
	isfinal=true,--是最终勋章
	grouptag="friendlyMedal",
	onequipfn=function(inst,owner)
		--移除怪物标签
		if owner:HasTag("monster") then
			owner:RemoveTag("monster")
			owner.friendlymonster=true--友好怪物
		end
	end,
	onunequipfn=function(inst,owner)
		if owner.friendlymonster then
			owner:AddTag("monster")
			owner.friendlymonster=nil
		end
	end,
}
-------------------------------------------------传承勋章-------------------------------------------------
medal_defs.inherit_certificate={
	name="inherit_certificate",
	animname="inherit_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	"washfunctionalable",--能力可被擦除
	},
	isfinal=true,--是最终勋章
	upgradable=true,--可升级
	maxlevel=TUNING_MEDAL.INHERIT_MEDAL.MAX_LEVEL,--最高等级
	onequipfn=function(inst,owner)
		-- print(inst.medal_level)
		if inst.medal_level then
			for i=1,inst.medal_level do
				owner:AddTag("traditionalbearer"..i)
			end
		end
	end,
	onunequipfn=function(inst,owner)
		for i=1,TUNING_MEDAL.INHERIT_MEDAL.MAX_LEVEL do
			owner:RemoveTag("traditionalbearer"..i)
		end
	end,
}
-------------------------------------------------复眼勋章-------------------------------------------------
medal_defs.ommateum_certificate={
	name="ommateum_certificate",
	animname="ommateum_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	-- "copyfunctional",--可印刻
	"washfunctionalable",--能力可被擦除
	},
	isfinal=true,--是最终勋章
	fuellevel=TUNING_MEDAL.OMMATEUM_MEDAL.PERISHTIME,--耐久
	deletefn=function(inst)--耐久用完执行的函数
		
	end,
	medal_repair_common = TUNING_MEDAL.OMMATEUM_MEDAL.REPAIR_LOOT,--补充耐久
	onequipfn=function(inst,owner)
		if owner.medalnightvision then
			owner.medalnightvision:set(true)
		end
		--开始消耗耐久
		if inst.components.fueled then
			inst.components.fueled:StartConsuming()
		end
		if inst.medal_losehealth_task then
			inst.medal_losehealth_task:Cancel()
			inst.medal_losehealth_task = nil
		end
		--耐久为空时每秒扣血
		inst.medal_losehealth_task = inst:DoPeriodicTask(1,function()
			if inst.components.fueled then
				if HasOriginMedal(owner) then--本源降低消耗速度
					inst.components.fueled.rate_modifiers:SetModifier("origin_medal", .25)
				end
				--在任何风暴中加速消耗
				if owner and owner.components.stormwatcher ~= nil and owner.components.stormwatcher:GetCurrentStorm() > 0 then
					inst.components.fueled.rate_modifiers:SetModifier("storm", 2)
					inst.components.fueled:StartConsuming()
				--在夜晚或洞穴中正常消耗
				elseif TheWorld.state.isnight then
					inst.components.fueled.rate_modifiers:RemoveModifier("storm")
					inst.components.fueled:StartConsuming()
				else--否则停止消耗
					inst.components.fueled.rate_modifiers:RemoveModifier("storm")
					inst.components.fueled:StopConsuming()
				end
			end
			if inst.components.fueled == nil or inst.components.fueled:IsEmpty() then
				if owner.components.health and not owner.components.health:IsDead() then
					inst.damage_count = inst.damage_count and inst.damage_count + 1 or 1--扣血次数累计
					owner.components.health:DoDelta(-math.ceil(inst.damage_count/5)*TUNING_MEDAL.OMMATEUM_MEDAL.DAMAGE_MULT)--扣血量=math.ceil(累计扣血次数/5)*难度倍率
				else
					inst.damage_count=nil--清空扣血计数
				end
			elseif inst.damage_count ~= nil then
				inst.damage_count=nil--清空扣血计数
			end
		end)
	end,
	onunequipfn=function(inst,owner)
		if owner.medalnightvision then
			owner.medalnightvision:set(false)
		end
		--停止消耗耐久
		if inst.components.fueled then
			inst.components.fueled.rate_modifiers:RemoveModifier("origin_medal")
			inst.components.fueled.rate_modifiers:RemoveModifier("storm")
			inst.components.fueled:StopConsuming()
		end
		--取消扣血任务
		if inst.medal_losehealth_task then
			inst.medal_losehealth_task:Cancel()
			inst.medal_losehealth_task=nil
		end
	end,
	extrafn=function(inst)
		--补充耐久前
		inst.medal_before_repairfn=function(inst,item,num)
			if inst.components.fueled ~= nil then
				--夜莓增加耐久上限
				if item ~= nil and item.prefab == "ancientfruit_nightvision" and inst.components.fueled.maxfuel < TUNING_MEDAL.OMMATEUM_MEDAL.MAX_PERISHTIME then
					inst.components.fueled.maxfuel = math.min(inst.components.fueled.maxfuel + TUNING_MEDAL.OMMATEUM_MEDAL.ADD_PERISHTIME * (num or 1) , TUNING_MEDAL.OMMATEUM_MEDAL.MAX_PERISHTIME)
				end
			end
		end
		--补充耐久
		inst.medal_onrepairfn=function(inst,item,num)
			if inst.isequipped and inst.components.fueled ~= nil then
				--处于装备中则开始掉耐久
				inst.components.fueled:StartConsuming()
			end
		end
	end,
	onsavefn=function(inst,data)--扩展存储函数
		if inst.components.fueled ~= nil then
			data.maxfuel = inst.components.fueled.maxfuel
			data.currentfuel = inst.components.fueled.currentfuel
		end
	end,
	onloadfn=function(inst,data)--扩展加载函数
		if data and inst.components.fueled ~= nil then
			if data.maxfuel then
				inst.components.fueled.maxfuel = data.maxfuel
			end
			if data.currentfuel then
				inst.components.fueled.currentfuel = data.currentfuel
			end
		end
	end,
}
-------------------------------------------------逮捕勋章-------------------------------------------------
medal_defs.arrest_certificate={
	name="arrest_certificate",
	animname="arrest_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	-- "copyfunctional",--可印刻
	},
	grouptag="justiceMedal",
	maxuses=TUNING_MEDAL.ARREST_MEDAL.MAXUSES,--次数耐久
	onfinishedfn=function(inst)--耐久用完执行的函数
		returnNewMedal(inst,"justice_certificate",function(inst,newmedal)
			if newmedal.components.finiteuses then
				newmedal.components.finiteuses:SetUses(0)--正义勋章初始耐久设为0
			end
		end)
	end,
	onequipfn=function(inst,owner)
		owner:ListenForEvent("medal_killed", inst.medalKilled)
		owner:ListenForEvent("onhitother", inst.onMedalHitOther)
	end,
	onunequipfn=function(inst,owner)
		owner:RemoveEventCallback("medal_killed", inst.medalKilled)
		owner:RemoveEventCallback("onhitother", inst.onMedalHitOther)
	end,
	extrafn=function(inst)
		--逮捕勋章监听函数
		inst.medalKilled = function(self,data)
			if data ~= nil and data.prefab == inst.prefab and data.victim then
				--小偷
				if data.victim.prefab=="krampus" or data.victim.prefab=="medal_naughty_krampus" then
					if inst.components.finiteuses then
						inst.components.finiteuses:Use(1*TUNING_MEDAL.ARREST_MEDAL.CONSUME_MULT)
						SpawnMedalTips(self,1*TUNING_MEDAL.ARREST_MEDAL.CONSUME_MULT,6)--弹幕提示
					end
				end
			end
		end
		--给目标绑定正义攻击者
		inst.onMedalHitOther = function(self,data)
			--攻击目标符合要求,且攻击目标绑定的玩家不是佩戴者则继续
			if data ~= nil and data.target and (data.target.prefab=="krampus" or data.target.prefab=="medal_naughty_krampus") then
				MedalHitOther(self,data.target,inst)
			end
		end
	end
}
-------------------------------------------------正义勋章-------------------------------------------------
--目标正义值消耗表
local justice_targetlist={
	krampus = {--坎普斯
		consume = 5,
		fn = function(inst,player,victim)
			local chance = TUNING_MEDAL.LOST_BAG_DROP_RATE*(player:HasTag("naughtymedal") and 2 or 1)--掉包果概率(装备淘气勋章出包果的概率翻倍)
			--记录荣誉
			if inst.medal_honor then
				inst.medal_honor[1]=inst.medal_honor[1]+1
			end
			--保底掉落
			if GuaranteedRandom(player,chance,"krampus") then
				if victim.components.lootdropper then
					victim.components.lootdropper:SpawnLootPrefab("medal_gift_fruit")
				end
				if inst.medal_honor then
					inst.medal_honor[6]=inst.medal_honor[6]+1
				end
			end
		end,
	},
	medal_naughty_krampus = {--复仇坎普斯
		consume = 5,
		fn = function(inst,player,victim)
			local chance=TUNING_MEDAL.LOST_BAG_DROP_RATE*(player:HasTag("naughtymedal") and 2 or 1)--掉包裹概率(装备淘气勋章出包裹的概率翻倍)
			--记录荣誉
			if inst.medal_honor then
				inst.medal_honor[5]=inst.medal_honor[5]+1
			end
			--保底掉落
			if GuaranteedRandom(player,chance,"medal_naughty_krampus") then
				DropLossBundle(victim,player)
				if inst.medal_honor then
					inst.medal_honor[3]=inst.medal_honor[3]+1
				end
			else
				local calltimes = victim.call_times or 0
				RewardToiler(player,math.min(calltimes*0.002+0.05,0.2))--天道酬勤
			end
		end,
	},
	klaus = {--克劳斯
		consume = 50,
		fn = function(inst,player,victim)
			DropLossBundle(victim,player,3)
			if inst.medal_honor then
				inst.medal_honor[2]=inst.medal_honor[2]+1
				inst.medal_honor[3]=inst.medal_honor[3]+3
			end
		end,
	},
	bat = {--蝙蝠
		consume = 1,
		testfn = function(inst,player,victim)
			return player.components.builder and not player.components.builder:KnowsRecipe("trap_bat")
		end,
		fn = function(inst,player,victim)
			if GuaranteedRandom(player, TUNING_MEDAL.TRAP_BAT_BLUEPRINT_RATE, "bat") then
				victim.components.lootdropper:SpawnLootPrefab("trap_bat_blueprint")
			end
		end,
	},
	lightninggoat = {--闪电羊
		consume = 5,
		testfn = function(inst,player,victim)
			return player.components.builder and not player.components.builder:KnowsRecipe("medal_goathat")
		end,
		fn = function(inst,player,victim)
			if math.random() < (victim.charged and TUNING_MEDAL.GOATHAT_BULEPRINT_CHANCE_CHARGED or TUNING_MEDAL.GOATHAT_BULEPRINT_CHANCE_NOMAL) then
				victim.components.lootdropper:SpawnLootPrefab("medal_goathat_blueprint")
			end
		end,
	},
	tentacle = {--触手
		consume = 5,
		fn = function(inst,player,victim)
			if GuaranteedRandom(player, TUNING_MEDAL.TENTACLE_MEDAL.DROP_CHANCE, "tentacle") then
				victim.components.lootdropper:SpawnLootPrefab("tentacle_certificate")
			end
		end,
	},
	tentacle_pillar = {--巨型触手
		consume = 5,
		fn = function(inst,player,victim)
			if math.random() < TUNING_MEDAL.TENTACLE_MEDAL.DROP_CHANCE*2 then
				victim.components.lootdropper:SpawnLootPrefab("tentacle_certificate")
			end
		end,
	},
	medal_rage_krampus = {--暗夜坎普斯
		consume = 50,
		fn = function(inst,player,victim)
			victim.components.lootdropper:SpawnLootPrefab("medal_treasure_map")
		end,
	},
}
--正义勋章
medal_defs.justice_certificate={
	name="justice_certificate",
	animname="justice_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	-- "copyfunctional",--可印刻
	"showmedalinfo",--显示勋章信息
	},
	grouptag="justiceMedal",
	maxuses=TUNING_MEDAL.JUSTICE_MEDAL.MAX_VALUE,--正义勋章耐久(正义值)
	medal_repair_common={--可补充耐久(正义值)
		monstermeat=2,--怪物肉
		cookedmonstermeat=2,--烤怪物肉
		monstermeat_dried=4,--怪物肉干
		durian=4,--榴莲
		durian_cooked=4,--烤榴莲
		monsterlasagna=6,--怪物千层饼
		monstertartare=8,--怪物鞑靼
		medal_monster_essence=25,--怪物精华
	},
	onfinishedfn=function(inst)--耐久用完执行的函数
		
	end,
	isfinal=true,--是最终勋章
	onequipfn=function(inst,owner)
		owner:AddTag("addjustice")--可增加正义值
		owner:ListenForEvent("medal_killed", inst.medalKilled)
		owner:ListenForEvent("onhitother", inst.onMedalHitOther)
	end,
	onunequipfn=function(inst,owner)
		owner:RemoveTag("addjustice")
		owner:RemoveEventCallback("medal_killed", inst.medalKilled)
		owner:RemoveEventCallback("onhitother", inst.onMedalHitOther)
	end,
	extrafn=function(inst)--额外扩展函数
		inst.medal_honor={0,0,0,0,0,0}--荣誉:1坎普斯数量,2克劳斯数量,3遗失包裹数量,4怪物精华数量,5淘气坎普斯数量,6包果数量
		inst.medal_before_repairfn=function(inst,consumables,usenum)--补充耐久时执行(正义勋章,消耗材料,消耗数量)
			if consumables and consumables.prefab=="medal_monster_essence" then
				--记录怪物精华数量
				if inst.medal_honor then
					inst.medal_honor[4]=inst.medal_honor[4]+(usenum or 0)
					--根据怪物精华数量变更耐久上限
					if inst.medal_honor[4]>0 then
						if inst.components.finiteuses and inst.components.finiteuses.total<TUNING_MEDAL.JUSTICE_MEDAL.MAX_VALUE_MORE then
							--每5个怪物精华增加10点耐久上限
							inst.components.finiteuses:SetMaxUses(math.min((TUNING_MEDAL.JUSTICE_MEDAL.MAX_VALUE+math.floor(inst.medal_honor[4]/TUNING_MEDAL.JUSTICE_MEDAL.UPLEVEL_NEEDNUM)*TUNING_MEDAL.JUSTICE_MEDAL.UPLEVEL_VALUE),TUNING_MEDAL.JUSTICE_MEDAL.MAX_VALUE_MORE))
							inst.components.finiteuses:Use(0)
						end
					end
				end
			end
		end
		inst.getMedalInfo = function(inst)--显示正义勋章荣誉
			if inst.medal_honor then
				local medalstr=STRINGS.MEDAL_INFO.JUSTICE_VALUE..(inst.components.finiteuses and inst.components.finiteuses:GetUses() or 0).."\n"--正义值
				medalstr=medalstr..STRINGS.MEDAL_INFO.HONOR
				medalstr=medalstr..STRINGS.NAMES.KRAMPUS.."*"..inst.medal_honor[1]..","--坎普斯
				medalstr=medalstr..STRINGS.NAMES.KLAUS.."*"..inst.medal_honor[2]..","--克劳斯
				medalstr=medalstr..STRINGS.NAMES.MEDAL_NAUGHTY_KRAMPUS.."*"..inst.medal_honor[5].."\n"--淘气坎普斯
				medalstr=medalstr..STRINGS.NAMES.MEDAL_GIFT_FRUIT.."*"..inst.medal_honor[6]..","--包果
				medalstr=medalstr..STRINGS.MEDAL_INFO.LOSSPACK.."*"..inst.medal_honor[3]..","--遗失包裹
				medalstr=medalstr..STRINGS.NAMES.MEDAL_MONSTER_ESSENCE.."*"..inst.medal_honor[4]--怪物精华
				return medalstr
			end
		end
		--正义勋章监听函数
		inst.medalKilled = function(self,data)
			if data ~= nil and data.prefab == inst.prefab and data.victim then-- and not data.victim.medal_kill then
				--克劳斯要第二形态才算
				if data.victim.prefab == "klaus" and data.victim.IsUnchained ~= nil and not data.victim:IsUnchained() then return end
				local has_origin = HasOriginMedal(self)--是否有本源勋章
				local justice_value= inst.components.finiteuses and inst.components.finiteuses:GetUses() or 0--正义值
				local justice_data = justice_targetlist[data.victim.prefab]
				local addjustice = true--是否增加正义值
				--暗影挑战券召唤的生物
				if data.victim:HasTag("norewardtoiler") then
					addjustice = false
					local gift_value = data.victim.gift_value or 1--包果价值
					local justice_consume = gift_value*TUNING_MEDAL.JUSTICE_MEDAL.GIFT_VALUE_MULT--正义值消耗
					if has_origin then--本源减耗
						justice_consume = math.ceil(justice_consume * TUNING_MEDAL.JUSTICE_MEDAL.ORIGIN_MULT)
					end
					--正义值要充足
					if justice_value >= justice_consume then
						local seedNum = gift_value==2 and math.random()<.25 and 1 or math.floor(gift_value/4)--种子数量
						local fruitNum = gift_value%4--果实数量
						if data.victim.components.lootdropper then
							--掉落包果和包果种子
							for i = 1, seedNum do
								data.victim.components.lootdropper:SpawnLootPrefab("medal_gift_fruit_seed")
							end
							for i = 1, fruitNum do
								data.victim.components.lootdropper:SpawnLootPrefab("medal_gift_fruit")
							end
						end
						inst.components.finiteuses:Use(justice_consume)--消耗正义值
					elseif has_origin then
						addjustice = true
					end
					-- data.victim.medal_kill=true--对受害者进行标记，防止多次生成掉落物
				--目标列表内的生物
				elseif justice_data ~= nil and (justice_data.testfn == nil or justice_data.testfn(inst,self,data.victim)) then
					addjustice = false
					local justice_consume = justice_data.consume
					if has_origin then--本源减耗
						justice_consume = math.ceil(justice_consume * TUNING_MEDAL.JUSTICE_MEDAL.ORIGIN_MULT)
					end
					--正义值要充足
					if justice_data.fn ~= nil and justice_value >= justice_consume then
						justice_data.fn(inst,self,data.victim)
						if justice_consume > 0 then
							inst.components.finiteuses:Use(justice_consume)--消耗正义值
						end
						-- data.victim.medal_kill=true--对受害者进行标记，防止多次生成掉落物
					elseif has_origin then
						addjustice = true
					end
				end
				--其他怪物
				if addjustice and data.victim:HasOneOfTags({"epic","monster"}) and data.victim.components.health and inst.components.finiteuses:GetPercent()<1 then
					--正义值增值=math.floor(目标血量上限/250)+1
					local need_add = math.floor(data.victim.components.health:GetMaxWithPenalty() / 250) + 1
					SpawnMedalTips(self, need_add, 13)--弹幕提示
					inst.components.finiteuses:Repair(need_add)
				end
			end
		end
		--给目标绑定正义勋章攻击者
		inst.onMedalHitOther = function(self,data)
			--攻击目标是怪物或者在目标列表里
			if data ~= nil and data.target and (data.target:HasOneOfTags({"epic","monster","norewardtoiler"}) or justice_targetlist[data.target.prefab]~=nil) then
				local justice_value= inst.components.finiteuses and inst.components.finiteuses:GetUses() or 0--正义值
				local has_origin = HasOriginMedal(self)--是否有本源勋章
				--暗影生物要正义值足够才行
				if data.target.gift_value and justice_value < data.target.gift_value * TUNING_MEDAL.JUSTICE_MEDAL.GIFT_VALUE_MULT and not has_origin then
					MedalSay(self,STRINGS.JUSTICEMEDALSPEECH.NOVALUE)
					return
				end
				local justice_data = justice_targetlist[data.target.prefab]
				--目标列表内的生物要满足正义值才行，不然就要提示玩家正义值不足
				if justice_data ~= nil and justice_data.consume ~=nil and justice_value < justice_data.consume and not has_origin then
					MedalSay(self,STRINGS.JUSTICEMEDALSPEECH.NOVALUE)
					return
				end
				MedalHitOther(self,data.target,inst)
			end
		end
	end,
	onsavefn=function(inst,data)--扩展存储函数
		if inst.medal_honor then
			data.medal_honor=shallowcopy(inst.medal_honor)
		end
	end,
	onloadfn=function(inst,data)--扩展加载函数
		if data and data.medal_honor then
			-- inst.medal_honor=shallowcopy(data.medal_honor)
			--不直接shallowcopy，防止在加新数据的时候导致旧数据和新数据数量冲突
			for i = 1, #data.medal_honor do
				inst.medal_honor[i] = data.medal_honor[i]
			end
			--根据怪物精华数量变更耐久上限
			if inst.medal_honor[4]>0 then
				if inst.components.finiteuses then
					local ismax=inst.components.finiteuses:GetPercent()==1--是否满耐久
					--每5个怪物精华增加10点耐久上限
					inst.components.finiteuses:SetMaxUses(math.min((TUNING_MEDAL.JUSTICE_MEDAL.MAX_VALUE+math.floor(inst.medal_honor[4]/TUNING_MEDAL.JUSTICE_MEDAL.UPLEVEL_NEEDNUM)*TUNING_MEDAL.JUSTICE_MEDAL.UPLEVEL_VALUE),TUNING_MEDAL.JUSTICE_MEDAL.MAX_VALUE_MORE))
					--满耐久则把耐久填满(因为官方不会存储满耐久数据)
					if ismax then
						inst.components.finiteuses:SetPercent(1)
					end
				end
			end
		end
	end,
}
-------------------------------------------------速度勋章-------------------------------------------------
medal_defs.speed_certificate={
	name="speed_certificate",
	animname="speed_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	"washfunctionalable",--能力可被擦除
	},
	grouptag="speedMedal",
	--需要对载体生效的部分装备函数(inst是融合勋章,item是勋章本身,owner是佩戴者)
	onequipwithrhfn=function(inst,item,owner)
		inst.components.equippable.walkspeedmult = TUNING_MEDAL.SPEED_MEDAL.SPEED_MULT
	end,
	--需要对载体生效的部分卸下函数(inst是融合勋章,item是勋章本身,owner是佩戴者)
	onunequipwithrhfn=function(inst,item,owner)
		inst.components.equippable.walkspeedmult = nil
	end,
	onequipfn=function(inst,owner)
		inst.components.equippable.walkspeedmult = TUNING_MEDAL.SPEED_MEDAL.SPEED_MULT
	end,
	onunequipfn=function(inst,owner)
		inst.components.equippable.walkspeedmult = nil
	end,
}
-------------------------------------------------空间勋章-------------------------------------------------
medal_defs.space_certificate={
	name="space_certificate",
	animname="space_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	-- "copyfunctional",--可印刻
	"showmedalinfo",--显示勋章信息
	"washfunctionalable",--能力可被擦除
	"cangivespacegem",--可以赋予空间之力
	},
	grouptag="speedMedal",
	maxuses=TUNING_MEDAL.SPEED_MEDAL.MAXUSES,--次数耐久
	medal_repair_common={--可补充耐久
		townportaltalisman=TUNING_MEDAL.SPEED_MEDAL.ADDUSES,--沙之石
	},
	onfinishedfn=function(inst)--耐久用完执行的函数
		
	end,
	--需要对载体生效的部分装备函数(inst是融合勋章,item是勋章本身,owner是佩戴者)
	onequipwithrhfn=function(inst,item,owner)
		inst.components.equippable.walkspeedmult = TUNING_MEDAL.SPEED_MEDAL.SPEED_MULT
	end,
	--需要对载体生效的部分卸下函数(inst是融合勋章,item是勋章本身,owner是佩戴者)
	onunequipwithrhfn=function(inst,item,owner)
		inst.components.equippable.walkspeedmult = nil
	end,
	onequipfn=function(inst,owner)
		inst.components.equippable.walkspeedmult = TUNING_MEDAL.SPEED_MEDAL.SPEED_MULT
		owner:AddTag("space_medal")
		inst:AddTag("candelivery")--装备的时候才能传送
	end,
	onunequipfn=function(inst,owner)
		inst.components.equippable.walkspeedmult = nil
		owner:RemoveTag("space_medal")
		inst:RemoveTag("candelivery")
	end,
	onsavefn=function(inst,data)--扩展存储函数
		--地上坐标点
		if inst.targetpos then
			data.targetpos=shallowcopy(inst.targetpos)
		end
		--洞穴坐标点
		if inst.cave_targetpos then
			data.cave_targetpos=shallowcopy(inst.cave_targetpos)
		end
		
		--如果有目标传送塔，则保存目标传送塔的坐标点
		if inst.targetTeleporter ~=nil then
			local tx,ty,tz = inst.targetTeleporter.Transform:GetWorldPosition()
			--洞穴和地上坐标存在不同变量表里
			if TheWorld and TheWorld:HasTag("cave") then
				data.cave_targetpos={x=tx or 0,y=ty or 0,z=tz or 0}
			else
				data.targetpos={x=tx or 0,y=ty or 0,z=tz or 0}
			end
		end
	end,
	onloadfn=function(inst,data)--扩展加载函数
		if data and inst.targetTeleporter==nil then
			inst.targetpos = shallowcopy(data.targetpos) or {x=0,y=0,z=0}
			inst.cave_targetpos = shallowcopy(data.cave_targetpos) or {x=0,y=0,z=0}
			local tx,ty,tz
			--洞穴
			if TheWorld and TheWorld:HasTag("cave") then
				tx,ty,tz=inst.cave_targetpos.x,inst.cave_targetpos.y,inst.cave_targetpos.z
			else--地上
				tx,ty,tz=inst.targetpos.x,inst.targetpos.y,inst.targetpos.z
			end
			--根据坐标点获取传送塔
			local ents = TheSim:FindEntities(tx,ty,tz,2,nil,{"INLIMBO"},{"townportal"})
			for i, v in ipairs(ents) do
				if v.prefab=="townportal" then
					inst.targetTeleporter=v
					inst:AddTag("canbacktotower")
					break
				end 
			end
		end
	end,
	extrafn=function(inst)
		inst.getMedalInfo = function(inst)--显示空间勋章绑定的目标
			if inst.targetTeleporter and inst.targetTeleporter.components.writeable then
				local targetText=inst.targetTeleporter.components.writeable:GetText() or STRINGS.DELIVERYSPEECH.NONAME
				return STRINGS.MEDAL_INFO.BINDTARGET..(targetText=="" and STRINGS.DELIVERYSPEECH.NONAME or targetText)
			end
		end
	end,
}
-------------------------------------------------时空勋章-------------------------------------------------
medal_defs.space_time_certificate={
	name="space_time_certificate",
	animname="space_time_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"showmedalinfo",--显示勋章信息
	"washfunctionalable",--能力可被擦除
	},
	grouptag="speedMedal",
	isfinal=true,--是最终勋章
	maxuses=TUNING_MEDAL.SPEED_MEDAL.MORE_MAXUSES,--次数耐久
	medal_repair_common={--可补充耐久
		townportaltalisman=TUNING_MEDAL.SPEED_MEDAL.ADDUSES,--沙之石
	},
	onfinishedfn=function(inst)--耐久用完执行的函数
		
	end,
	--需要对载体生效的部分装备函数(inst是融合勋章,item是勋章本身,owner是佩戴者)
	onequipwithrhfn=function(inst,item,owner)
		inst.components.equippable.walkspeedmult = TUNING_MEDAL.SPEED_MEDAL.FAST_SPEED_MULT
	end,
	--需要对载体生效的部分卸下函数(inst是融合勋章,item是勋章本身,owner是佩戴者)
	onunequipwithrhfn=function(inst,item,owner)
		inst.components.equippable.walkspeedmult = nil
	end,
	onequipfn=function(inst,owner)
		inst.components.equippable.walkspeedmult = TUNING_MEDAL.SPEED_MEDAL.FAST_SPEED_MULT
		owner:AddTag("space_medal")--摸塔
		owner:AddTag("spacetime_medal")--时空道具制作
		inst:AddTag("candelivery")--装备的时候才能传送
	end,
	onunequipfn=function(inst,owner)
		inst.components.equippable.walkspeedmult = nil
		owner:RemoveTag("space_medal")
		owner:RemoveTag("spacetime_medal")
		inst:RemoveTag("candelivery")
	end,
	--客户端扩展函数
	client_extrafn=function(inst)--额外扩展函数
		inst.deliverylist = net_string(inst.GUID, "deliverylist")--传送列表
	end,
	extrafn=function(inst)--额外扩展函数
		inst:AddComponent("medal_delivery")--自由传送组件
		inst:AddComponent("writeable")--可书写组件
		inst.components.writeable:SetOnWritingEndedFn(function(inst)
			if inst.components.medal_delivery then
				inst.components.medal_delivery:AddMarkPos()
			end
			inst.components.writeable:SetText(STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPACE_TIME_CERTIFICATE)
		end)
	end,
}
-------------------------------------------------踏水勋章-------------------------------------------------
--踏水勋章
medal_defs.treadwater_certificate={
	name="treadwater_certificate",
	animname="treadwater_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"washfunctionalable",--能力可被擦除
	},
	isfinal=true,--是最终勋章
	fuellevel=TUNING_MEDAL.TREADWATER_MEDAL.PERISHTIME,--燃料耐久
	deletefn=function(inst)--耐久用完执行的函数
		
	end,
	medal_repair_common = {malbatross_feather=TUNING_MEDAL.TREADWATER_MEDAL.ADDUSE},--可用邪天翁羽毛修复
	onequipfn=function(inst,owner)
		inst.isequipped = true--处于装备状态
		inst.delay_count=0--延迟计数
		inst.fast_consume=false--是否快速消耗
		if inst.medal_moving_task then
			inst.medal_moving_task:Cancel()
			inst.medal_moving_task=nil
		end
		--周期生成水花、判定勋章耐久消耗速度
		inst.medal_moving_task=inst:DoPeriodicTask(0.1,function()
			local needfaseuse=true--快速消耗
			--如果玩家在水上移动
			if owner.components.drownable ~= nil and owner.components.drownable:IsOverWater() then
				local is_moving = owner.sg:HasStateTag("moving")--在移动
				local is_running = owner.sg:HasStateTag("running")--在跑步
				if is_running or is_moving then 
					inst.delay_count = inst.delay_count + 1
					--生成水花(延迟为5)
					if inst.delay_count >= 5 then
						SpawnPrefab("weregoose_splash_less"..tostring(math.random(2))).entity:SetParent(owner.entity)
						inst.delay_count=0
					end
					needfaseuse=false
				end
				--本源在水面上均慢速消耗
				if needfaseuse and HasOriginMedal(owner) then
					needfaseuse = false
				end
			end
			if inst.fast_consume~=needfaseuse then
				inst.fast_consume=needfaseuse
				if inst.fast_consume then
					--切换贴图
					if inst.components.inventoryitem then
						inst.components.inventoryitem:ChangeImageName("treadwater_certificate_fast")
					end
					--快速消耗耐久
					if inst.components.fueled then
						inst.components.fueled.rate_modifiers:SetModifier("treadwater_certificate", TUNING_MEDAL.TREADWATER_MEDAL.FAST_CONSUME_MULT)
					end
				else
					--切换贴图
					if inst.components.inventoryitem then
						inst.components.inventoryitem:ChangeImageName("treadwater_certificate")
					end
					if inst.components.fueled then
						inst.components.fueled.rate_modifiers:RemoveModifier("treadwater_certificate")
					end
				end
			end
		end)
		--踏水
		if owner.components.drownable~=nil and owner.components.drownable.enabled ~= false then
			owner.components.drownable.enabled = false
		end
		SetMedalTreadWaterCollides(owner,true)
		
		if inst.medal_losehealth_task then
			inst.medal_losehealth_task:Cancel()
			inst.medal_losehealth_task=nil
		end
		--耐久为空时每秒扣血
		inst.medal_losehealth_task = inst:DoPeriodicTask(1,function()
			if inst.components.fueled and inst.components.fueled:IsEmpty() then
				if owner.components.health and not owner.components.health:IsDead() then
					inst.damage_count=inst.damage_count and inst.damage_count+1 or 1--扣血次数累计
					owner.components.health:DoDelta(-math.ceil(inst.damage_count/5)*TUNING_MEDAL.TREADWATER_MEDAL.DAMAGE_MULT)--扣血量=math.ceil(累计扣血次数/5)*难度倍率
				else
					inst.damage_count=nil--清空扣血计数
				end
			elseif inst.damage_count then
				inst.damage_count=nil--清空扣血计数
			end
		end)
		if inst.components.fueled then
			inst.components.fueled:StartConsuming()
		end
		if not HasOriginMedal(owner) then--非本源
			owner:ListenForEvent("onhitother", inst.onhitotherfn)--在水面攻击掉耐久
		end
	end,
	onunequipfn=function(inst,owner)
		inst.isequipped = nil
		--切换贴图
		if inst.components.inventoryitem then
			inst.components.inventoryitem:ChangeImageName("treadwater_certificate")
		end
		if owner.components.drownable~=nil and owner.components.drownable.enabled == false then
			owner.components.drownable.enabled = true
		end
		SetMedalTreadWaterCollides(owner,false)
		--取消耐久消耗计算，取消水花生成效果
		if inst.medal_moving_task then
			inst.medal_moving_task:Cancel()
			inst.medal_moving_task=nil
		end
		--取消扣血任务
		if inst.medal_losehealth_task then
			inst.medal_losehealth_task:Cancel()
			inst.medal_losehealth_task=nil
		end
		--停止消耗耐久
		if inst.components.fueled then
			inst.components.fueled:StopConsuming()
		end
		if not HasOriginMedal(owner) then
			owner:RemoveEventCallback("onhitother", inst.onhitotherfn)
		end
	end,
	extrafn=function(inst)
		--添加燃料
		inst.medal_onrepairfn=function(inst)
			if inst.isequipped and inst.components.fueled ~= nil then
				inst.components.fueled:StartConsuming()
			end
		end

		--监听玩家攻击事件，根据目标血量扣除勋章耐久
		inst.onhitotherfn = function(self,data)
			if inst.components.fueled and not inst.components.fueled:IsEmpty() then
				if self.components.drownable ~= nil and self.components.drownable:IsOverWater() then
					if data.target and data.target.components.health then
						local maxhealth = data.target.components.health:GetMaxWithPenalty()--获取目标血量上限
						local consume=math.min(12*math.floor(maxhealth/500)+12*math.floor(maxhealth/1000),TUNING_MEDAL.TREADWATER_MEDAL.PERISHTIME*TUNING_MEDAL.TREADWATER_MEDAL.MAX_CONSUME)*TUNING_MEDAL.TREADWATER_MEDAL.CONSUME_MULT
						if consume>0 then
							inst.components.fueled:DoDelta(-consume)
						end
					end
				end
			end
		end
	end,
}
-------------------------------------------------触手勋章-------------------------------------------------
medal_defs.tentacle_certificate={
	name="tentacle_certificate",
	animname="tentacle_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	"washfunctionalable",--能力可被擦除
	},
	isfinal=true,--是最终勋章
	upgradable=true,--可升级
	maxlevel=TUNING_MEDAL.TENTACLE_MEDAL.MAX_LEVEL,--最高等级
	onequipfn=function(inst,owner)
		owner:AddTag("tentaclemedal")--触手勋章标签，可解锁狼牙棒制作
		owner:PushEvent("changetentaclemedal")--推送触手勋章变更事件
		if inst.medal_level and inst.medal_level>=TUNING_MEDAL.TENTACLE_MEDAL.SENIOR_LEVEL then
			owner:AddTag("senior_tentaclemedal")--高级触手勋章标签，装备时不会被触手主动攻击
		end
		--监听玩家攻击事件，概率召唤小触手
		inst.onattackotherfn=function(self,data)
			local tentacle_chance=0--召唤触手概率
			if data and data.weapon and inst.medal_level and inst.medal_level>0 then
				--活性触手棒概率=触手勋章等级*0.1
				if data.weapon.prefab=="medal_tentaclespike" then
					tentacle_chance=inst.medal_level*TUNING_MEDAL.TENTACLE_MEDAL.CALL_CHANCE
				--普通触手棒概率=(触手勋章等级-1)*0.05
				elseif data.weapon.prefab=="tentaclespike" then
					tentacle_chance=(inst.medal_level-1)*TUNING_MEDAL.TENTACLE_MEDAL.NORMAL_CHANCE*2
				else--普通武器概率=(触手勋章等级-1)*0.025
					tentacle_chance=(inst.medal_level-1)*TUNING_MEDAL.TENTACLE_MEDAL.NORMAL_CHANCE
				end
				if math.random() < tentacle_chance then
					local pt
					local target=data.target
					if target and target:IsValid() then
						pt = target:GetPosition()
					else
						pt = owner:GetPosition()
						target = nil
					end
					local offset = FindWalkableOffset(pt, math.random() * 2 * PI, 2, 3, false, true, function(pt) return not TheWorld.Map:IsPointNearHole(pt) end, false, true)
					if offset ~= nil then
						if owner.SoundEmitter then
							owner.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_1")
							owner.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_2")
						end
						--本源召唤暗影大触手,否则召唤小触手
						local tentacle = SpawnPrefab(HasOriginMedal(owner,"tentaclemedal") and "bigshadowtentacle" or "shadowtentacle")
						if tentacle ~= nil then
							if tentacle.prefab == "bigshadowtentacle" then
								tentacle.from_tentaclemedal = true--大触手要标记一下方便移除
							end
							tentacle.Transform:SetPosition(pt.x + offset.x, 0, pt.z + offset.z)
							tentacle.components.combat:SetTarget(target)
						end
					end
				end
			end
		end
		owner:ListenForEvent("onattackother", inst.onattackotherfn)
	end,
	onunequipfn=function(inst,owner)
		owner:RemoveTag("tentaclemedal")
		owner:RemoveTag("senior_tentaclemedal")
		owner:RemoveEventCallback("onattackother", inst.onattackotherfn)
		owner:PushEvent("changetentaclemedal")--推送触手勋章变更事件
	end,
}
-------------------------------------------------女武神的检验-------------------------------------------------
medal_defs.valkyrie_examine_certificate={
	name="valkyrie_examine_certificate",
	animname="valkyrie_examine_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"showmedalinfo",--显示勋章信息
	},
	grouptag="valkyrieMedal",
	maxuses=1,--次数耐久
	onfinishedfn=function(inst)--耐久用完执行的函数
		returnNewMedal(inst,"valkyrie_test_certificate")
	end,
	onequipfn=function(inst,owner)
		owner:ListenForEvent("medal_killed", inst.medalKilled)
		owner:ListenForEvent("onhitother", inst.onMedalHitOther)
	end,
	onunequipfn=function(inst,owner)
		owner:RemoveEventCallback("medal_killed", inst.medalKilled)
		owner:RemoveEventCallback("onhitother", inst.onMedalHitOther)
	end,
	extrafn=function(inst)
		--女武神的检验击杀监听函数
		inst.medalKilled = function(self,data)
			--装备时候击杀巨型怪物耐久减1
			if data ~= nil and data.prefab == inst.prefab and data.victim ~= nil and (data.victim:HasTags({"largecreature","monster"}) or data.victim:HasTag("epic")) then
				inst.components.finiteuses:Use(1)--消耗耐久
				--成功的喜悦
				MedalSay(self,STRINGS.VALKYRIETESTSPEECH.SUCCESS)
			end
		end
		--给目标绑定处于女武神测验中的攻击者
		inst.onMedalHitOther = function(self,data)
			--攻击目标符合条件，则进行相关处理
			if data ~= nil and data.target and (data.target:HasTags({"largecreature","monster"}) or data.target:HasTag("epic")) then
				MedalHitOther(self,data.target,inst)
			else--否则提醒玩家换个目标
				MedalSay(self,STRINGS.VALKYRIETESTSPEECH.REPEAT)
			end
		end
	end,
}
-------------------------------------------------女武神的考验-------------------------------------------------
medal_defs.valkyrie_test_certificate={
	name="valkyrie_test_certificate",
	animname="valkyrie_test_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"showmedalinfo",--显示勋章信息
	},
	grouptag="valkyrieMedal",
	maxuses=TUNING_MEDAL.VALKYRIE_TEST.MAXUSES,--次数耐久
	onfinishedfn=function(inst)--耐久用完执行的函数
		returnNewMedal(inst,"valkyrie_certificate")
	end,
	onequipfn=function(inst,owner)
		owner:ListenForEvent("medal_killed", inst.medalKilled)
		owner:ListenForEvent("onhitother", inst.onMedalHitOther)
	end,
	onunequipfn=function(inst,owner)
		owner:RemoveEventCallback("medal_killed", inst.medalKilled)
		owner:RemoveEventCallback("onhitother", inst.onMedalHitOther)
	end,
	extrafn=function(inst)--额外扩展函数
		inst.getMedalInfo = function(inst)--显示考验记录
			--上次考验目标
			if inst.lasttarget then
				local prefabname= STRINGS.NAMES[string.upper(inst.lasttarget)] or inst.lasttarget
				return STRINGS.MEDAL_INFO.LASTTARGET..prefabname
			end
		end
		--女武神的考验击杀监听函数
		inst.medalKilled = function(self,data)
			if inst.components.finiteuses ~= nil and data ~= nil and data.prefab == inst.prefab and data.victim ~= nil and data.victim:HasOneOfTags({"epic","monster"}) and not data.victim:HasTag("smallcreature") then
				if inst.lasttarget and inst.lasttarget == data.victim.prefab then
					MedalSay(self,STRINGS.VALKYRIETESTSPEECH.REPEAT)--提醒玩家换个目标
				elseif data.victim.components.health then
					local victim_health=data.victim.components.health:GetMaxWithPenalty()
					local consume=0--耐久消耗
					--血量超过双倍消耗条件,则掉2点耐久
					if victim_health>=TUNING_MEDAL.VALKYRIE_TEST.DOUBLE_CONSUME_HEALTH then
						consume=2
					--血量超过必消耗条件，必掉1点耐久
					elseif victim_health>=TUNING_MEDAL.VALKYRIE_TEST.MUST_CONSUME_HEALTH then
						consume=1
					--否则概率掉耐久
					elseif math.random() < math.min(victim_health/1000,TUNING_MEDAL.VALKYRIE_TEST.MAX_CONSUME_RATE) then
						consume=1
					end
					if consume>0 then
						inst.lasttarget=data.victim.prefab--记录上一次战绩
						consume=consume*TUNING_MEDAL.VALKYRIE_TEST.CONSUME_MULT--计算耐久掉落倍率
						inst.components.finiteuses:Use(consume)--消耗耐久
						SpawnMedalTips(self,consume,7)--弹幕提示
					end
				end
			end
		end
		--女武神的考验攻击监听函数
		inst.onMedalHitOther = function(self,data)
			if data and data.target then
				--攻击小动物会被警告
				if data.target:HasTag("smallcreature") then
					if (data.target.components.health and data.target.components.health:IsDead()) or data.target.defeated then
						if inst.components.finiteuses ~= nil then
							inst.components.finiteuses:Repair(1)--恢复1点耐久
							if self.SoundEmitter then--播放炸掉的声音
								self.SoundEmitter:PlaySound("dontstarve/wilson/use_armour_break")
							end
						end
					end
					MedalSay(self,STRINGS.VALKYRIETESTSPEECH.BEDISQUALIFIED)--不能欺负小动物
				elseif data.target:HasOneOfTags({"epic","monster"}) then
					--目标重复了，提醒玩家换个目标
					if inst.lasttarget and inst.lasttarget==data.target.prefab then
						MedalSay(self,STRINGS.VALKYRIETESTSPEECH.REPEAT)
						return
					end
					MedalHitOther(self,data.target,inst)
				else--非怪物或史诗生物,提醒玩家换个怪物目标
					MedalSay(self,STRINGS.VALKYRIETESTSPEECH.NOMONSTER)
				end
			end
		end
	end,
	onsavefn=function(inst,data)--扩展存储函数
		--最后目标
		if inst.lasttarget then
			data.lasttarget=inst.lasttarget
		end
	end,
	onloadfn=function(inst,data)--扩展加载函数
		--最后目标
		if data and data.lasttarget then
			inst.lasttarget=data.lasttarget
		end
	end,
}
-------------------------------------------------女武神勋章-------------------------------------------------
--伤害系数变更函数
local function ChangeCombatModifier(owner)
	if owner == nil or owner.components.combat == nil then return end
	local equipped = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)--获取玩家武器
	local addtions = equipped ~= nil and TUNING_MEDAL.VALKYRIE_MEDAL.COMBAT_ADDITION[equipped.prefab] or TUNING_MEDAL.VALKYRIE_MEDAL.COMBAT_ADDITION.DEFAULT--加成表
	local idx = HasOriginMedal(owner) and 2 or 1--本源加成更高
	if addtions ~= nil then
		owner.components.combat.externaldamagemultipliers:SetModifier("valkyrie_certificate", addtions[idx])
	end
end
--减伤系数变更函数
local function ChangeAbsorbModifier(inst,owner)
	local mult=inst.valkyrie_power and inst.valkyrie_power/10 or 0--减伤比例=女武神之力/10
	if owner.components.health ~= nil then
		owner.components.health.externalabsorbmodifiers:SetModifier("valkyrie_certificate", owner.components.health.absorb>0 and TUNING.WATHGRITHR_ABSORPTION*mult*.5 or TUNING.WATHGRITHR_ABSORPTION*mult)
	end
end

--是否为有效目标
local function IsValidVictim(victim)
    return victim ~= nil
        and not ((victim:HasTag("prey") and not victim:HasTag("hostile")) or
                victim:HasTag("veggie") or
                victim:HasTag("structure") or
                victim:HasTag("wall") or
                victim:HasTag("balloon") or
                victim:HasTag("groundspike") or
                victim:HasTag("smashable") or
                victim:HasTag("abigail") or
                victim:HasTag("shadowminion") or
                victim:HasTag("companion"))
        and victim.components.health ~= nil
        and victim.components.combat ~= nil
end

--可以添加女武神之力的图纸
local valkyrie_sketchLoot={
	chesspiece_deerclops_sketch = true,--巨鹿
	chesspiece_bearger_sketch = true,--熊大
	chesspiece_moosegoose_sketch = true,--鸭子
	chesspiece_dragonfly_sketch = true,--龙蝇
	chesspiece_malbatross_sketch = true,--邪天翁
	chesspiece_crabking_sketch = true,--帝王蟹
	chesspiece_toadstool_sketch = true,--蛤蟆
	chesspiece_stalker_sketch = true,--暗影编织者
	chesspiece_klaus_sketch = true,--克劳斯
	chesspiece_beequeen_sketch = true,--蜂后
	chesspiece_antlion_sketch = true,--蚁狮
	chesspiece_minotaur_sketch = true,--犀牛
	chesspiece_guardianphase3_sketch = true,--天体英雄
	chesspiece_eyeofterror_sketch = true,--恐怖之眼
	chesspiece_twinsofterror_sketch = true,--双子魔眼
	chesspiece_daywalker_sketch = true,--梦魇疯猪
	chesspiece_deerclops_mutated_sketch = true,--变异巨鹿
	chesspiece_warg_mutated_sketch = true,--变异座狼
	chesspiece_bearger_mutated_sketch = true,--变异熊大
	chesspiece_sharkboi_sketch = true,--大霜鲨
	chesspiece_wormboss_sketch = true,--巨大洞穴蠕虫
	chesspiece_daywalker2_sketch = true,--拾荒疯猪
}

medal_defs.valkyrie_certificate={
	name="valkyrie_certificate",
	animname="valkyrie_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	"showmedalinfo",--显示勋章信息
	},
	grouptag="valkyrieMedal",
	isfinal=true,--是最终勋章
	onequipfn=function(inst,owner)
		AddMedalTag(owner,"valkyrie")--女武神标签
		ChangeCombatModifier(owner)
		ChangeAbsorbModifier(inst,owner)--减伤，普通玩家最高25%，原本有减伤的角色最高12.5%
		owner:ListenForEvent("equip", ChangeCombatModifier)--穿装备
		owner:ListenForEvent("unequip", ChangeCombatModifier)--脱装备
		if inst.medalKilled then
			owner:ListenForEvent("medal_killed", inst.medalKilled)
		end
		if inst.onMedalHitOther then
			owner:ListenForEvent("onhitother", inst.onMedalHitOther)
		end
		if inst.collectsketchfn then
			inst:ListenForEvent("collectsketch", inst.collectsketchfn)
		end
	end,
	onunequipfn=function(inst,owner)
		RemoveMedalTag(owner,"valkyrie")--女武神标签
		if owner.components.combat ~= nil then
			owner.components.combat.externaldamagemultipliers:RemoveModifier("valkyrie_certificate")
		end
		if owner.components.health ~= nil then
			owner.components.health.externalabsorbmodifiers:RemoveModifier("valkyrie_certificate")
		end
		owner:RemoveEventCallback("equip", ChangeCombatModifier)
		owner:RemoveEventCallback("unequip", ChangeCombatModifier)
		if inst.medalKilled then
			owner:RemoveEventCallback("medal_killed", inst.medalKilled)
		end
		if inst.onMedalHitOther then
			owner:RemoveEventCallback("onhitother", inst.onMedalHitOther)
		end
		if inst.collectsketchfn then
			inst:RemoveEventCallback("collectsketch", inst.collectsketchfn)
		end
	end,
	extrafn=function(inst)--额外扩展函数
		inst.valkyrie_power=0--女武神之力
		inst.getMedalInfo = function(inst)--显示女武神之力
			if inst.valkyrie_power then
				return STRINGS.MEDAL_INFO.VALKYRIEPOWER..inst.valkyrie_power
			end
		end
		inst.valkyrie_sketchLoot = valkyrie_sketchLoot
		--女武神之力变更
		inst.collectsketchfn=function(self)
			ChangeAbsorbModifier(inst,self)--减伤，普通玩家最高25%，原本有减伤的角色最高12.5%
		end
		--监听击杀
		inst.medalKilled = function(self,data)
			local victim = data and data.victim
			if data ~= nil and data.prefab == inst.prefab and IsValidVictim(victim) then
				--击杀目标获得血量、精神，增值=目标伤害*系数*女武神之力/10，女武神系数为0.1，其他玩家为0.2
				local delta = (victim.components.combat.defaultdamage) * (self.prefab=="wathgrithr" and 0.1 or 0.2)
				delta = inst.valkyrie_power and delta*inst.valkyrie_power/10 or 0
				if delta>0 then
					if self.components.health ~= nil then self.components.health:DoDelta(delta, false, "medal_battleborn") end
					if self.components.sanity ~= nil then self.components.sanity:DoDelta(delta) end
				end
				--天道酬勤
				local total_health = victim.components.health and victim.components.health:GetMaxWithPenalty() or 0--获取攻击目标最大血量
				if not victim:HasTag("norewardtoiler") then
					RewardToiler(self,math.max(total_health-400,0)*0.0001)
				end
			end
		end
		--绑定攻击目标
		inst.onMedalHitOther = function(self,data)
			--攻击目标符合条件，则进行相关处理
			if data ~= nil and data.target and IsValidVictim(data.target) then
				MedalHitOther(self,data.target,inst)
			end
		end
	end,
	onsavefn=function(inst,data)--扩展存储函数
		if inst.valkyrie_power and inst.valkyrie_power>0 then
			data.valkyrie_power=inst.valkyrie_power
		end
	end,
	onloadfn=function(inst,data)--扩展加载函数
		if data and data.valkyrie_power then
			inst.valkyrie_power=data.valkyrie_power
		end
	end,
}
-------------------------------------------------鱼人勋章-------------------------------------------------
medal_defs.merm_certificate={
	name="merm_certificate",
	animname="merm_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	},
	isfinal=true,--是最终勋章
	onequipfn=function(inst,owner)
		AddMedalTag(owner,"merm_builder")--鱼人制造者
		AddMedalTag(owner,"merm")--鱼人
		AddMedalTag(owner,"playermerm")--鱼人角色
		AddMedalTag(owner,"stronggrip")--工具不脱手
		AddMedalTag(owner,"mermfluent")--鱼语十级
		owner.has_merm_medal = true--有鱼人勋章
		--沼泽加速
		if owner.components.locomotor~=nil and not owner.components.locomotor:IsFasterOnGroundTile(GROUND.MARSH) then
			owner.components.locomotor:SetFasterOnGroundTile(GROUND.MARSH, true)
			inst.fasteronmarsh=true
		else
			inst.fasteronmarsh=false
		end
		--潮湿不掉san
		if owner.components.sanity and not owner.components.sanity.no_moisture_penalty then
			owner.components.sanity.no_moisture_penalty = true
			owner.temporary_no_moisture=true
		end
	end,
	onunequipfn=function(inst,owner)
		RemoveMedalTag(owner,"merm_builder")--鱼人制造者
		RemoveMedalTag(owner,"merm")--鱼人
		RemoveMedalTag(owner,"playermerm")--鱼人角色
		RemoveMedalTag(owner,"stronggrip")--工具不脱手
		RemoveMedalTag(owner,"mermfluent")--鱼语十级
		owner.has_merm_medal = nil
		if inst.fasteronmarsh then
			owner.components.locomotor:SetFasterOnGroundTile(GROUND.MARSH, false)
			inst.fasteronmarsh=false
		end
		if owner.components.sanity and owner.temporary_no_moisture and not owner:HasTag("plantkin") then
			owner.components.sanity.no_moisture_penalty = nil
			owner.temporary_no_moisture=nil
		end
	end,
}
-------------------------------------------------淘气勋章-------------------------------------------------
medal_defs.naughty_certificate={
	name="naughty_certificate",
	animname="naughty_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	"washfunctionalable",--能力可被擦除
	},
	isfinal=true,--是最终勋章
	onequipfn=function(inst,owner)
		owner:AddTag("naughtymedal")
	end,
	onunequipfn=function(inst,owner)
		owner:RemoveTag("naughtymedal")
	end,
}
-------------------------------------------------蜘蛛勋章-------------------------------------------------
medal_defs.spider_certificate={
	name="spider_certificate",
	animname="spider_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	"washfunctionalable",--能力可被擦除
	},
	isfinal=true,--是最终勋章
	grouptag="spiderMedal",--组标签，额外添加一个组标签，用于同类型勋章
	onequipfn=function(inst,owner)
		AddMedalTag(owner,"spiderwhisperer")--蜘蛛语
		AddMedalTag(owner,UPGRADETYPES.SPIDER.."_upgradeuser")--蜘蛛巢升级
		--在蜘蛛网上走路不减速
		if owner.components.locomotor and owner.components.locomotor.triggerscreep==true then
			--延迟补偿情况下，移速组件在客机上单独计算，所以主客机都需要调整
			if owner.medaltriggerscreep then
				owner.medaltriggerscreep:set(true)
			end
			owner.temporary_remove_triggerscreep=true
		end
		owner:PushEvent("refreshcrafting")--更新制作栏
	end,
	onunequipfn=function(inst,owner)
		RemoveMedalTag(owner,"spiderwhisperer")--蜘蛛语
		RemoveMedalTag(owner,UPGRADETYPES.SPIDER.."_upgradeuser")--蜘蛛巢升级
		if owner.temporary_remove_triggerscreep then
			if owner.medaltriggerscreep then
				owner.medaltriggerscreep:set(false)
			end
			owner.temporary_remove_triggerscreep=nil
		end
		owner:PushEvent("refreshcrafting")--更新制作栏
	end,
}
--蜘蛛战士勋章
--[[
medal_defs.spider_warrior_certificate=shallowcopy(medal_defs.spider_certificate)
medal_defs.spider_warrior_certificate.name="spider_warrior_certificate"
medal_defs.spider_warrior_certificate.animname="spider_warrior_certificate"
medal_defs.spider_warrior_certificate.isfinal=false--防止gm指令刷出
--洞穴蜘蛛勋章
medal_defs.spider_hider_certificate=shallowcopy(medal_defs.spider_certificate)
medal_defs.spider_hider_certificate.name="spider_hider_certificate"
medal_defs.spider_hider_certificate.animname="spider_hider_certificate"
medal_defs.spider_hider_certificate.isfinal=false--防止gm指令刷出
--喷吐蜘蛛勋章
medal_defs.spider_spitter_certificate=shallowcopy(medal_defs.spider_certificate)
medal_defs.spider_spitter_certificate.name="spider_spitter_certificate"
medal_defs.spider_spitter_certificate.animname="spider_spitter_certificate"
medal_defs.spider_spitter_certificate.isfinal=false--防止gm指令刷出
--悬挂蜘蛛勋章
medal_defs.spider_dropper_certificate=shallowcopy(medal_defs.spider_certificate)
medal_defs.spider_dropper_certificate.name="spider_dropper_certificate"
medal_defs.spider_dropper_certificate.animname="spider_dropper_certificate"
medal_defs.spider_dropper_certificate.isfinal=false--防止gm指令刷出
--破碎蜘蛛勋章
medal_defs.spider_moon_certificate=shallowcopy(medal_defs.spider_certificate)
medal_defs.spider_moon_certificate.name="spider_moon_certificate"
medal_defs.spider_moon_certificate.animname="spider_moon_certificate"
medal_defs.spider_moon_certificate.isfinal=false--防止gm指令刷出
--蜘蛛女王勋章
medal_defs.spiderqueen_certificate=shallowcopy(medal_defs.spider_certificate)
medal_defs.spiderqueen_certificate.name="spiderqueen_certificate"
medal_defs.spiderqueen_certificate.animname="spiderqueen_certificate"
medal_defs.spiderqueen_certificate.isfinal=false--防止gm指令刷出
]]--
-------------------------------------------------浴火勋章-------------------------------------------------
medal_defs.bathingfire_certificate={
	name="bathingfire_certificate",
	animname="bathingfire_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	"washfunctionalable",--能力可被擦除
	},
	isfinal=true,--是最终勋章
	onequipfn=function(inst,owner)
		owner:AddTag("has_bathfire_medal")--浴火勋章拥有者
		AddMedalTag(owner,"pyromaniac")--纵火狂标签
		AddMedalTag(owner,"bernieowner")--伯尼熊主人标签
		AddMedalTag(owner,"expertchef")--熟练烹饪标签
		--不受火焰伤害
		if owner.components.health then
			if owner.components.health.fire_damage_scale ~=nil then
				inst.firedamage=owner.components.health.fire_damage_scale
			end
			owner.components.health.fire_damage_scale = TUNING.WILLOW_FIRE_DAMAGE
		end
		--加燃料的燃烧效率更高
		if owner.components.fuelmaster==nil then
			owner.temporary_fuelmaster=true
			owner:AddComponent("fuelmaster")
			owner.components.fuelmaster:SetBonusFn(function(inst, item, target)
				return (target:HasTag("campfire") or target.prefab == "nightlight") and TUNING.WILLOW_CAMPFIRE_FUEL_MULT or 1
			end)
		end
		
	end,
	onunequipfn=function(inst,owner)
		owner:RemoveTag("has_bathfire_medal")
		RemoveMedalTag(owner,"pyromaniac")--纵火狂标签
		RemoveMedalTag(owner,"bernieowner")--伯尼熊主人标签
		RemoveMedalTag(owner,"expertchef")--熟练烹饪标签
		owner.components.health.fire_damage_scale = inst.firedamage or 1
		if owner.temporary_fuelmaster and owner.components.fuelmaster then
			owner:RemoveComponent("fuelmaster")
			owner.temporary_fuelmaster=nil
		end
	end,
}
-------------------------------------------------沉默勋章-------------------------------------------------
medal_defs.silence_certificate={
	name="silence_certificate",
	animname="silence_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	"washfunctionalable",--能力可被擦除
	},
	isfinal=true,--是最终勋章
	onequipfn=function(inst,owner)
		AddMedalTag(owner,"mime")--哑剧标签
		AddMedalTag(owner,"balloonomancer")--气球制造者标签
		owner:PushEvent("refreshcrafting")--更新制作栏
		if HasOriginMedal(owner) then--本源
			owner.medal_silence_damage = 0--沉默的力量,不在沉默中爆发,就在沉默中灭亡
			owner:ListenForEvent("attacked", inst.onattackedfn)--挨打
		end
	end,
	onunequipfn=function(inst,owner)
		RemoveMedalTag(owner,"mime")--哑剧标签
		RemoveMedalTag(owner,"balloonomancer")--气球制造者标签
		owner:PushEvent("refreshcrafting")--更新制作栏
		if HasOriginMedal(owner) then--本源
			owner:RemoveEventCallback("attacked", inst.onattackedfn)--挨打
			owner.medal_silence_damage = nil
		end
	end,
	extrafn=function(inst)
		--监听玩家攻击事件，根据目标血量扣除勋章耐久
		inst.onattackedfn = function(self,data)
			if HasOriginMedal(self) and data and data.original_damage then
				self.medal_silence_damage = (self.medal_silence_damage or 0) + data.original_damage*.6
			end
		end
	end,
}
-------------------------------------------------噬灵勋章-------------------------------------------------
local devour_soul_medal_fn = require("prefabs/devour_soul_medal_fn")

--噬灵勋章装备函数(勋章,玩家)
local function devour_soul_onequipfn(inst,owner)
	inst:AddTag("canreleasesoul")--可释放灵魂
	--初始化玩家标签
	owner.medal_soulstealer=1--勋章灵魂吞噬者
	AddMedalTag(owner,"soulstealer")--吞噬者标签
	--耐久大于0则添加勋章跳跃标签
	if inst.components.finiteuses and inst.components.finiteuses:GetPercent()>0 then
		owner:AddTag("medal_blinker")
	end
	--监听灵魂跳跃
	owner:ListenForEvent("medal_blink", inst.medalblink)
	--监听勋章耐久变化
	inst.percentusedchangefn = function(inst,data)
		if data and data.percent then
			--耐久用完
			if data.percent<=0 then
				owner:RemoveTag("medal_blinker")
			else
				owner:AddTag("medal_blinker")
			end
			if inst.SyncMedalSouls then
				inst:SyncMedalSouls(owner)
			end
		end
	end
	inst:ListenForEvent("percentusedchange", inst.percentusedchangefn)
	--玩家原本没有监听掉落函数，则添加监听
	if owner.medal_onentitydroplootfn == nil then
		owner.medal_onentitydroplootfn = function(src, data)	
			devour_soul_medal_fn.OnEntityDropLoot(owner, data)
		end
		owner:ListenForEvent("entity_droploot", owner.medal_onentitydroplootfn, TheWorld)
	end
	--玩家原本没有监听死亡函数，则添加监听
	if owner.medal_onentitydeathfn == nil then
		owner.medal_onentitydeathfn = function(src, data)
			devour_soul_medal_fn.OnEntityDeath(owner, data)
		end
		owner:ListenForEvent("entity_death", owner.medal_onentitydeathfn, TheWorld)
	end
	--玩家原本没有监听陷阱采集函数，则添加监听
	if owner.medal_onstarvedtrapsoulsfn == nil then
		owner.medal_onstarvedtrapsoulsfn = function(src, data) 
			devour_soul_medal_fn.OnStarvedTrapSouls(owner, data)
		end
		owner:ListenForEvent("starvedtrapsouls", owner.medal_onstarvedtrapsoulsfn, TheWorld)
	end
	--监听谋杀事件
	if owner.medal_onmurderedsoulsfn == nil then
		owner.medal_onmurderedsoulsfn = function(src, data) 
			devour_soul_medal_fn.OnMurdered(owner, data)
		end
		owner:ListenForEvent("murdered", owner.medal_onmurderedsoulsfn)
	end
	if owner.prefab~="wortox" then
		owner:ListenForEvent("harvesttrapsouls", devour_soul_medal_fn.OnHarvestTrapSouls)
	end
	--伍迪变身回来玩家跳跃函数会被挪掉，需要重设
	if (owner.prefab=="woodie" or owner.prefab=="wolfgang") and owner.medalblinkable then
		if owner.medalblinkable:value() then
			owner.medalblinkable:set_local(false)
			owner.medalblinkable:set(true)
		else
			owner.medalblinkable:set(true)
		end
	end
end

--噬灵勋章卸下函数(勋章,玩家)
local function devour_soul_onunequipfn(inst,owner)
	inst:RemoveTag("canreleasesoul")--可释放灵魂
	owner.medal_soulstealer=nil--勋章灵魂吞噬者
	owner:RemoveTag("medal_blinker")
	RemoveMedalTag(owner,"soulstealer")--吞噬者标签
	--移除相关监听
	owner:RemoveEventCallback("medal_blink", inst.medalblink)
	inst:RemoveEventCallback("percentusedchange", inst.percentusedchangefn)
		
	if owner.medal_onentitydroplootfn ~= nil then
		owner:RemoveEventCallback("entity_droploot", owner.medal_onentitydroplootfn, TheWorld)
		owner.medal_onentitydroplootfn = nil
	end
	if owner.medal_onentitydeathfn ~= nil then
		owner:RemoveEventCallback("entity_death", owner.medal_onentitydeathfn, TheWorld)
		owner.medal_onentitydeathfn = nil
	end
	if owner.medal_onstarvedtrapsoulsfn ~= nil then
		owner:RemoveEventCallback("starvedtrapsouls", owner.medal_onstarvedtrapsoulsfn, TheWorld)
		owner.medal_onstarvedtrapsoulsfn = nil
	end
	if owner.medal_onmurderedsoulsfn ~= nil then
		owner:RemoveEventCallback("murdered", owner.medal_onmurderedsoulsfn)
		owner.medal_onmurderedsoulsfn = nil
	end
	if owner.prefab~="wortox" then
		owner:RemoveEventCallback("harvesttrapsouls", devour_soul_medal_fn.OnHarvestTrapSouls)
	end
end

medal_defs.devour_soul_certificate={
	name="devour_soul_certificate",
	animname="devour_soul_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"washfunctionalable",--能力可被擦除
	},
	grouptag="devoursoulMedal",
	-- isfinal=true,--是最终勋章
	maxuses=TUNING_MEDAL.DEVOUR_SOUL_MEDAL.MAXUSES,--次数耐久
	medal_repair_common={--可补充耐久
		wortox_soul=1,--灵魂
		spice_soul=1,--灵魂佐料
	},
	onfinishedfn=function(inst) end,--耐久用完执行的函数
	onequipfn=function(inst,owner)
		devour_soul_onequipfn(inst,owner)
	end,
	onunequipfn=function(inst,owner)
		devour_soul_onunequipfn(inst,owner)
	end,
	extrafn=function(inst)
		--监听玩家用勋章灵魂跳跃
		inst.medalblink = function(self,data)
			if self.components.inventory and self.components.inventory:Has("wortox_soul", 1) then
				--优先执行TryToPortalHop,不满足条件才走勋章消耗
				if not (self.TryToPortalHop and self:TryToPortalHop()) then
					self.components.inventory:ConsumeByName("wortox_soul", 1)
				end
			elseif inst.components.finiteuses then
				inst.components.finiteuses:Use(1)--跳跃后掉一点耐久
			end
		end
	end,
}
-------------------------------------------------噬魂勋章-------------------------------------------------
local function OnCharged(inst)--灵魂跳跃CD结束
	local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem:GetGrandOwner() or nil
	--身上有灵魂就消耗灵魂
	if owner and owner.components.inventory ~= nil and owner.components.inventory:Has("wortox_soul", 1) then
		owner.components.inventory:ConsumeByName("wortox_soul", 1)
	--没灵魂就消耗耐久
	elseif inst.components.finiteuses then
		inst.components.finiteuses:Use(1)
	end
end
medal_defs.medium_devour_soul_certificate={
	name="medium_devour_soul_certificate",
	animname="medium_devour_soul_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"washfunctionalable",--能力可被擦除
	"cangivespacegem",--可以赋予空间之力
	},
	grouptag="devoursoulMedal",
	maxuses=TUNING_MEDAL.DEVOUR_SOUL_MEDAL.MEDIUM_MAXUSES,--次数耐久
	medal_repair_common={--可补充耐久
		wortox_soul=1,--灵魂
		spice_soul=1,--灵魂佐料
	},
	onfinishedfn=function(inst) end,--耐久用完执行的函数
	onequipfn=function(inst,owner)
		devour_soul_onequipfn(inst,owner)
		owner.medal_soulstealer=2--噬魂勋章拥有者(也是灵魂的可携带倍数)
	end,
	onunequipfn=function(inst,owner)
		devour_soul_onunequipfn(inst,owner)
	end,
	extrafn=function(inst)
		inst:AddComponent("rechargeable")
		inst.components.rechargeable:SetOnChargedFn(OnCharged)--CD结束
		--监听玩家用勋章灵魂跳跃
		inst.medalblink = function(self,data)
			if not (self.TryToPortalHop and self:TryToPortalHop()) then
				if inst.components.rechargeable ~= nil then
					--不在CD中，则开始CD
					if inst.components.rechargeable:IsCharged() then
						inst.components.rechargeable:Discharge(TUNING.WORTOX_FREEHOP_TIMELIMIT)
					else--已经在CD中，则停止CD并立即消耗
						inst.components.rechargeable:SetPercent(1)
					end
				end
			end
		end
	end,
}
-------------------------------------------------噬空勋章-------------------------------------------------
medal_defs.large_devour_soul_certificate={
	name="large_devour_soul_certificate",
	animname="large_devour_soul_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"washfunctionalable",--能力可被擦除
	},
	grouptag="devoursoulMedal",
	isfinal=true,--是最终勋章
	maxuses=TUNING_MEDAL.DEVOUR_SOUL_MEDAL.LARGE_MAXUSES,--次数耐久
	medal_repair_common={--可补充耐久
		wortox_soul=1,--灵魂
		spice_soul=1,--灵魂佐料
	},
	onfinishedfn=function(inst) end,--耐久用完执行的函数
	onequipfn=function(inst,owner)
		owner:AddTag("medal_map_blinker")--地图灵魂跳跃者
		devour_soul_onequipfn(inst,owner)
		owner.medal_soulstealer=2--噬魂勋章拥有者(也是灵魂的可携带倍数)
		if inst.SyncMedalSouls then
			inst:SyncMedalSouls(owner)
		end
	end,
	onunequipfn=function(inst,owner)
		owner:RemoveTag("medal_map_blinker")
		devour_soul_onunequipfn(inst,owner)
		--耐久变量置零
		if owner.medal_souls_num and owner.medal_souls_num:value() ~= 0 then
			owner.medal_souls_num:set(0)
		end
	end,
	extrafn=function(inst)
		inst:AddComponent("rechargeable")
		inst.components.rechargeable:SetOnChargedFn(OnCharged)--CD结束
		--监听玩家用勋章灵魂跳跃
		inst.medalblink = function(self,data)
			if data and data.mapuse and self.components.inventory then
				local result, num = self.components.inventory:Has("wortox_soul", data.mapuse)
				self.components.inventory:ConsumeByName("wortox_soul", data.mapuse)
				--身上的灵魂数量不够,用勋章耐久抵扣,能到这步的肯定已经满足本源这个前置条件了
				if not result and inst.components.finiteuses then
					inst.components.finiteuses:Use(data.mapuse - num)
				end
			elseif not (self.TryToPortalHop and self:TryToPortalHop()) then
				if inst.components.rechargeable ~= nil then
					--不在CD中，则开始CD
					if inst.components.rechargeable:IsCharged() then
						inst.components.rechargeable:Discharge(TUNING.WORTOX_FREEHOP_TIMELIMIT)
					else--已经在CD中，则重置CD
						local mult = HasOriginMedal(self) and 2 or 1--本源勋章CD翻倍
						inst.components.rechargeable:Discharge(TUNING_MEDAL.DEVOUR_SOUL_MEDAL.RESET_FREEHOP_TIMELIMIT * mult)
					end
				end
			end
		end
		--同步勋章耐久至网络变量
		inst.SyncMedalSouls = function(inst,owner)
			if HasOriginMedal(owner) and owner.medal_souls_num ~= nil then
				local uses = inst.components.finiteuses and inst.components.finiteuses:GetUses() or 0
				if owner.medal_souls_num:value() ~= uses then
					owner.medal_souls_num:set(uses)
				end
			end
		end
	end,
}

-------------------------------------------------钓鱼勋章-------------------------------------------------
medal_defs.smallfishing_certificate={
	name="smallfishing_certificate",
	animname="smallfishing_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	"showmedalinfo",--显示勋章信息
	},
	grouptag="fishingMedal",
	maxuses=TUNING_MEDAL.FISHING_MEDAL.MAXUSES,--次数耐久
	onfinishedfn=function(inst)--耐久用完执行的函数
		returnNewMedal(inst,"mediumfishing_certificate")
	end,
	onequipfn=function(inst,owner)
		owner.medal_fishing_time_mult = TUNING_MEDAL.FISHING_MEDAL.SMALL_TIME_MULT--钓鱼时间倍率
		--复制的勋章不需要监听
		if not inst:HasTag("blank_certificate") then
			owner:ListenForEvent("medal_fishingcollect", inst.fishingcollect)--监听钓鱼
		end
	end,
	onunequipfn=function(inst,owner)
		owner.medal_fishing_time_mult=nil
		--复制的勋章不需要监听
		if not inst:HasTag("blank_certificate") then
			owner:RemoveEventCallback("medal_fishingcollect", inst.fishingcollect)
		end
	end,
	extrafn=function(inst)--额外扩展函数
		inst.pondlist={--水池列表
			--pond = 1,--格式
		}
		inst.getMedalInfo = function(inst)--显示池塘列表
			local str = STRINGS.MEDAL_INFO.FISHINGPONDTIP
			if inst.pondlist and GetTableSize(inst.pondlist)>0 then
				local medalstr=STRINGS.MEDAL_INFO.FISHINGPOND
				for k,v in pairs(inst.pondlist) do
					medalstr=medalstr..(STRINGS.MEDAL_INFO[string.upper(k)] or STRINGS.NAMES[string.upper(k)] or k)..":"..v..","
				end
				return str .."\n".. string.sub(medalstr,1,-2)
			end
			return str
		end
		--监听钓鱼事件
		inst.fishingcollect = function(self,data)
			if data and data.pond and inst.pondlist then
				local consume=0--消耗耐久
				if inst.pondlist[data.pond.prefab] then
					if inst.pondlist[data.pond.prefab] < 10 then
						inst.pondlist[data.pond.prefab] = inst.pondlist[data.pond.prefab]+1
						consume=1
					end
				else
					inst.pondlist[data.pond.prefab] = 1
					consume=1
				end
				--消耗耐久
				if inst.components.finiteuses and consume>0 then
					consume=consume*TUNING_MEDAL.FISHING_MEDAL.CONSUME_MULT
					inst.components.finiteuses:Use(consume)
					if not RewardToiler(self,0.05) then--天道酬勤
						SpawnMedalTips(self,consume,8)--弹幕提示
					end
				end
				-- print(data.pond.prefab)
			end
		end
	end,
	onsavefn=function(inst,data)--扩展存储函数
		--水池列表
		if inst.pondlist and GetTableSize(inst.pondlist)>0 then
			data.pondlist=shallowcopy(inst.pondlist)
		end
	end,
	onloadfn=function(inst,data)--扩展加载函数
		--垂钓列表
		if data and data.pondlist and GetTableSize(data.pondlist)>0 then
			inst.pondlist=shallowcopy(data.pondlist)
		end
	end,
}
-------------------------------------------------垂钓勋章-------------------------------------------------
medal_defs.mediumfishing_certificate={
	name="mediumfishing_certificate",
	animname="mediumfishing_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	"showmedalinfo",--显示勋章信息
	},
	grouptag="fishingMedal",
	maxuses=TUNING_MEDAL.FISHING_MEDAL.MEDIUM_MAXUSES,--次数耐久
	onfinishedfn=function(inst)--耐久用完执行的函数
		returnNewMedal(inst,"largefishing_certificate")
	end,
	onequipfn=function(inst,owner)
		AddMedalTag(owner,"fast_kill_fish")--快速杀鱼
		owner.medal_fishing_time_mult = TUNING_MEDAL.FISHING_MEDAL.MEDAL_TIME_MULT--钓鱼时间倍率
		owner.medal_fishing_chance_mult = TUNING_MEDAL.FISHING_MEDAL.MEDIUM_CHANCE_MULT--遗失塑料袋概率加成
		owner.medal_fishing_consume_mult = TUNING_MEDAL.FISHING_MEDAL.MEDIUM_CONSUME_MULT--钓鱼消耗减免
		--复制的勋章不需要监听
		if not inst:HasTag("blank_certificate") then
			owner:ListenForEvent("medal_fishingcollect", inst.fishingcollect)--监听钓鱼
		end
	end,
	onunequipfn=function(inst,owner)
		RemoveMedalTag(owner,"fast_kill_fish")--快速杀鱼
		owner.medal_fishing_time_mult=nil
		owner.medal_fishing_chance_mult = nil
		owner.medal_fishing_consume_mult = nil
		--复制的勋章不需要监听
		if not inst:HasTag("blank_certificate") then
			owner:RemoveEventCallback("medal_fishingcollect", inst.fishingcollect)
		end
	end,
	extrafn=function(inst)--额外扩展函数
		inst.fishlist={}--海鱼记录表
		inst.getMedalInfo = function(inst)--显示海鱼记录
			local str = STRINGS.MEDAL_INFO.NEEDFISHINGTIP
			if inst.fishlist and #inst.fishlist>0 then
				local medalstr=STRINGS.MEDAL_INFO.NEEDFISHING
				local count=0
				for _,v in ipairs(inst.fishlist) do
					local prefabname= STRINGS.NAMES[string.upper(v)] or v
					count=count+1
					medalstr=medalstr..prefabname..(count>=5 and "\n" or ",")
					count=count%5
				end
				return str .."\n".. string.sub(medalstr,1,-2)
			end
			return str
		end
		--监听钓鱼事件
		inst.fishingcollect = function(self,data)
			if data and data.fish and inst.fishlist then
				local consume = 0--消耗
				local consume_mutl = data.pond and 1 or 2--经验倍率,海钓经验更多
				local prefabname = (data.pond or not data.fish:HasTag("oceanfish")) and data.fish.prefab or (data.fish.prefab.."_inv")
				if data.fish:HasTag("canbetrapped") then--龙虾
					prefabname = string.sub(data.fish.prefab,1,-6)
				end
				-- print(prefabname)
				if table.contains(inst.fishlist, prefabname) then return end--不能钓重复的
				local specialFish={--特殊海鱼
					wobster_sheller=1,--龙虾
					wobster_moonglass=1,--月光龙虾
					oceanfish_small_9_inv=3,--口水鱼
					oceanfish_medium_9_inv=3,--甜味鱼
					oceanfish_medium_6_inv=5,--花锦鲤
					oceanfish_medium_7_inv=5,--金锦鲤
				}
				local seasonFish={--时令鱼列表
					oceanfish_small_7_inv=20,--花朵金枪鱼
					oceanfish_small_8_inv=20,--太阳鱼
					oceanfish_small_6_inv=20,--比目鱼
					oceanfish_medium_8_inv=20,--冰鲷鱼
				}
				
				--计算需要消耗的耐久
				if specialFish[prefabname]~=nil then--特殊海鱼
					consume=specialFish[prefabname]*consume_mutl
				elseif seasonFish[prefabname]~=nil then--时令鱼
					consume_mutl = consume_mutl>1 and 1.5 or 1--时令鱼经验倍率低点
					consume=seasonFish[prefabname]*consume_mutl
				elseif data.fish:HasTag("oceanfish") then--其他海鱼
					consume=2*consume_mutl
				end
				
				--消耗耐久
				if inst.components.finiteuses and consume>0 then
					inst.fishlist[#inst.fishlist+1] = prefabname--记录到海鱼表
					consume=consume*TUNING_MEDAL.FISHING_MEDAL.CONSUME_MULT
					inst.components.finiteuses:Use(consume)
					if not RewardToiler(self,0.1) then--天道酬勤
						SpawnMedalTips(self,consume,8)--弹幕提示
					end
				end
			end
		end
	end,
	onsavefn=function(inst,data)--扩展存储函数
		if inst.fishlist and #inst.fishlist>0 then
			data.fishlist=shallowcopy(inst.fishlist)
		end
	end,
	onloadfn=function(inst,data)--扩展加载函数
		if data and data.fishlist and #data.fishlist>0 then
			inst.fishlist=shallowcopy(data.fishlist)
		end
	end,
}
-------------------------------------------------渔翁勋章-------------------------------------------------
local function large_fishing_collect(player,data)
	if data and data.fish and data.pond==nil then--仅限海钓
		RewardToiler(player,0.05)
	end
end
medal_defs.largefishing_certificate={
	name="largefishing_certificate",
	animname="largefishing_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	},
	isfinal=true,--是最终勋章
	grouptag="fishingMedal",
	onequipfn=function(inst,owner)
		AddMedalTag(owner,"fast_kill_fish")--快速杀鱼
		owner:AddTag("has_largefishing_medal")--渔翁
		local has_origin = HasOriginMedal(owner)
		owner.medal_fishing_time_mult = TUNING_MEDAL.FISHING_MEDAL[has_origin and "ORIGIN_TIME_MULT" or "LARGE_TIME_MULT"]--钓鱼时间倍率
		owner.medal_fishing_chance_mult = TUNING_MEDAL.FISHING_MEDAL[has_origin and "ORIGIN_CHANCE_MULT" or "LARGE_CHANCE_MULT"]--遗失塑料袋概率加成
		owner.medal_fishing_consume_mult = TUNING_MEDAL.FISHING_MEDAL[has_origin and "ORIGIN_CONSUME_MULT" or "LARGE_CONSUME_MULT"]--钓鱼消耗减免
		owner:ListenForEvent("medal_fishingcollect", large_fishing_collect)--监听钓鱼
	end,
	onunequipfn=function(inst,owner)
		RemoveMedalTag(owner,"fast_kill_fish")--快速杀鱼
		owner:RemoveTag("has_largefishing_medal")
		owner.medal_fishing_time_mult = nil
		owner.medal_fishing_chance_mult = nil
		owner.medal_fishing_consume_mult = nil
		owner:RemoveEventCallback("medal_fishingcollect", large_fishing_collect)
	end,
}
-------------------------------------------------羽绒勋章-------------------------------------------------
medal_defs.down_filled_coat_certificate={
	name="down_filled_coat_certificate",
	animname="down_filled_coat_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"nofreezing",--不会过冷
	"washfunctionalable",--能力可被擦除
	},
	isfinal=true,--是最终勋章
	fuellevel=TUNING_MEDAL.DOWN_FILLED_COAT_MEDAL_PERISHTIME,--燃料耐久
	deletefn=function(inst)--耐久用完执行的函数
		returnNewMedal(inst,"blank_certificate")--返还空白勋章
	end,
	medal_repair_common = {goose_feather=TUNING_MEDAL.DOWN_FILLED_COAT_ADDUSE},--可用鸭毛修复
	--需要对载体生效的部分装备函数(inst是融合勋章,item是勋章本身,owner是佩戴者)
	onequipwithrhfn=function(inst,item,owner)
		if inst.components.insulator==nil then
			inst:AddComponent("insulator")
		end
		inst.components.insulator:SetInsulation(TUNING_MEDAL.DOWN_FILLED_COAT_INSULATION)
	end,
	--需要对载体生效的部分卸下函数(inst是融合勋章,item是勋章本身,owner是佩戴者)
	onunequipwithrhfn=function(inst,item,owner)
		if inst.components.insulator~=nil then
			inst:RemoveComponent("insulator")
		end
	end,
	onequipfn=function(inst,owner)
		if inst.components.fueled then
			local has_origin = HasOriginMedal(owner)
			if has_origin then--本源降低消耗速度
				inst.components.fueled.rate_modifiers:SetModifier("origin_medal", .25)
			end
			inst.components.fueled:StartConsuming()
			if owner.components.temperature then
				local current=owner.components.temperature:GetCurrent()
				if current<6 then--当前体温低于6度时，额外消耗耐久回温，消耗量=温差*每度消耗
					owner.components.temperature:SetTemperature(6)
					-- inst.components.fueled:DoDelta(-math.ceil(TUNING_MEDAL.DOWN_FILLED_COAT_CONSUME*(6-current)))
					inst:DoTaskInTime(0,function(inst)
						inst.components.fueled:DoDelta(-math.ceil(TUNING_MEDAL.DOWN_FILLED_COAT_CONSUME*(6-current)*(has_origin and .25 or 1)))
					end)
				end
			end
		end
		if inst.components.insulator==nil then
			inst:AddComponent("insulator")
		end
		inst.components.insulator:SetInsulation(TUNING_MEDAL.DOWN_FILLED_COAT_INSULATION)
	end,
	onunequipfn=function(inst,owner)
		if inst.components.fueled then
			inst.components.fueled.rate_modifiers:RemoveModifier("origin_medal")
			inst.components.fueled:StopConsuming()
		end
		if inst.components.insulator~=nil then
			inst:RemoveComponent("insulator")
		end
	end,
}
-------------------------------------------------蓝晶勋章-------------------------------------------------
medal_defs.blue_crystal_certificate={
	name="blue_crystal_certificate",
	animname="blue_crystal_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"nooverheat",--不会过热
	"washfunctionalable",--能力可被擦除
	},
	isfinal=true,--是最终勋章
	fuellevel=TUNING_MEDAL.HAT_BLUE_CRYSTAL_MEDAL_PERISHTIME,--耐久
	deletefn=function(inst)--耐久用完执行的函数
		returnNewMedal(inst,"blank_certificate")--返还空白勋章
	end,
	medal_repair_common = {medal_blue_obsidian=TUNING_MEDAL.HAT_BLUE_CRYSTAL_ADDUSE},--可用蓝曜石修复
	--需要对载体生效的部分装备函数(inst是融合勋章,item是勋章本身,owner是佩戴者)
	onequipwithrhfn=function(inst,item,owner)
		if inst.components.insulator==nil then
			inst:AddComponent("insulator")
		end
		inst.components.insulator:SetInsulation(TUNING_MEDAL.HAT_BLUE_CRYSTAL_INSULATION)
		inst.components.insulator:SetSummer()
	end,
	--需要对载体生效的部分卸下函数(inst是融合勋章,item是勋章本身,owner是佩戴者)
	onunequipwithrhfn=function(inst,item,owner)
		if inst.components.insulator~=nil then
			inst:RemoveComponent("insulator")
		end
	end,
	onequipfn=function(inst,owner)
		if inst.components.fueled then
			local has_origin = HasOriginMedal(owner)
			if has_origin then--本源降低消耗速度
				inst.components.fueled.rate_modifiers:SetModifier("origin_medal", .25)
			end
			inst.components.fueled:StartConsuming()
			if owner.components.temperature then
				local current=owner.components.temperature:GetCurrent()
				if current>64 then--当前体温高于64度时，额外消耗耐久降温，消耗量=温差*每度消耗
					owner.components.temperature:SetTemperature(64)
					inst:DoTaskInTime(0,function(inst)
						inst.components.fueled:DoDelta(-math.ceil(TUNING_MEDAL.HAT_BLUE_CRYSTAL_CONSUME*(current-64)*(has_origin and .25 or 1)))
					end)
				end
			end
		end
		if inst.components.insulator==nil then
			inst:AddComponent("insulator")
		end
		inst.components.insulator:SetInsulation(TUNING_MEDAL.HAT_BLUE_CRYSTAL_INSULATION)
		inst.components.insulator:SetSummer()
		--不怕火
		if owner.components.health ~= nil then
			owner.components.health.externalfiredamagemultipliers:SetModifier(inst, 0)
		end
	end,
	onunequipfn=function(inst,owner)
		if inst.components.fueled then
			inst.components.fueled.rate_modifiers:RemoveModifier("origin_medal")
			inst.components.fueled:StopConsuming()
		end
		if inst.components.insulator~=nil then
			inst:RemoveComponent("insulator")
		end
		if owner.components.health ~= nil then
			owner.components.health.externalfiredamagemultipliers:RemoveModifier(inst)
		end
	end,
}
-------------------------------------------------童心勋章-------------------------------------------------
local function StoryTellingDone(inst, story)
	if inst._story_proxy ~= nil and inst._story_proxy:IsValid() then
		inst._story_proxy:Remove()
		inst._story_proxy = nil
	end
end

local function StoryToTellFn(inst, story_prop)
	if not TheWorld.state.isnight then
		return "NOT_NIGHT"
	end

	local fueled = story_prop ~= nil and story_prop.components.fueled or nil
	if fueled ~= nil and story_prop:HasTag("campfire") then
		if fueled:IsEmpty() then
			return "NO_FIRE"
		end

		local campfire_stories = STRINGS.STORYTELLER.WALTER["CAMPFIRE"]
		if campfire_stories ~= nil then
			if inst._story_proxy ~= nil then
				inst._story_proxy:Remove()
				inst._story_proxy = nil
			end
			inst._story_proxy = SpawnPrefab("walter_campfire_story_proxy")
			inst._story_proxy:Setup(inst, story_prop)

			local story_id = GetRandomKey(campfire_stories)
			return { style = "CAMPFIRE", id = story_id, lines = campfire_stories[story_id].lines }
		end
	end

	return nil
end
--弹药消耗表
local ammo_consume_list={
	slingshotammo_rock=1,--石头弹
	slingshotammo_gold=1,--金弹
	slingshotammo_marble=2,--大理石弹
	slingshotammo_thulecite=2,--诅咒弹
	slingshotammo_honey=2,--蜂蜜弹
	slingshotammo_freeze=3,--冰弹
	slingshotammo_slow=3,--减速弹
	slingshotammo_poop=1,--便便弹
	slingshotammo_moonglass=2,--月亮碎片弹
	slingshotammo_dreadstone=3,--绝望石弹
	slingshotammo_gunpowder=3,--火药弹
	slingshotammo_lunarplanthusk=3,--亮茄弹
	slingshotammo_purebrilliance=3,--纯粹辉煌弹
	slingshotammo_horrorfuel=3,--纯粹恐惧弹
	slingshotammo_gelblob=3,--恶液弹
	slingshotammo_scrapfeather=3,--闪电弹
	slingshotammo_stinger=2,--针刺弹
	trinket_1=10,--融化的大理石
	medalslingshotammo_sanityrock=10,--方尖弹
	medalslingshotammo_sandspike=10,--沙刺弹
	medalslingshotammo_water=10,--落水弹
	medalslingshotammo_devoursoul=10,--噬魂弹
	medalslingshotammo_taunt=10,--痰蛋弹
	medalslingshotammo_spines=10,--尖刺弹
	mandrakeberry=3,--曼德拉果
}

--截取弹药名称
local function GetProjStr(str)
    if str:sub(-5)=="_proj" then
       return str:sub(1,-6)
    end
    return str
end

--童心勋章
medal_defs.childishness_certificate={
	name="childishness_certificate",
	animname="childishness_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	"showmedalinfo",--显示勋章信息
	},
	grouptag="childMedal",
	maxuses=TUNING_MEDAL.CHILDISHNESS_MEDAL.MAXUSES,--次数耐久
	onfinishedfn=function(inst)--耐久用完执行的函数
		returnNewMedal(inst,"childlike_certificate")
	end,
	onequipfn=function(inst,owner)
		AddMedalTag(owner,"pebblemaker")--弹药制作者
		AddMedalTag(owner,"slingshot_sharpshooter")--弹弓使用者
		AddMedalTag(owner,"pinetreepioneer")--松树先锋(做帽子、帐篷)
		owner:AddTag("has_childishness")--拥有童心
		AddMedalComponent(owner,"storyteller")--讲故事组件
		owner.components.storyteller:SetStoryToTellFn(StoryToTellFn)
		owner.components.storyteller:SetOnStoryOverFn(StoryTellingDone)
		--复制的勋章不需要监听
		if not inst:HasTag("blank_certificate") then
			owner:ListenForEvent("medal_shoot", inst.medal_shoot)--监听射击事件
		end
		owner:PushEvent("refreshcrafting")--更新制作栏
	end,
	onunequipfn=function(inst,owner)
		RemoveMedalTag(owner,"pebblemaker")--弹药制作者
		RemoveMedalTag(owner,"slingshot_sharpshooter")--弹弓使用者
		RemoveMedalTag(owner,"pinetreepioneer")--松树先锋(做帽子、帐篷)
		owner:RemoveTag("has_childishness")--失去童心
		--停止讲故事
		if owner.components.storyteller and owner.components.storyteller:IsTellingStory() then
			-- owner.components.storyteller:OnDone()
			if owner.sg then
				owner.sg:GoToState("idle")
			end
		end
		RemoveMedalComponent(owner,"storyteller")
		--复制的勋章不需要监听
		if not inst:HasTag("blank_certificate") then
			owner:RemoveEventCallback("medal_shoot", inst.medal_shoot)--移除射击事件监听
		end
		owner:PushEvent("refreshcrafting")--更新制作栏
	end,
	extrafn=function(inst)--额外扩展函数
		inst.ammolist={--弹药列表
			--xx = 1,--格式
		}
		inst.getMedalInfo=function(inst)--显示弹药列表
			local str = STRINGS.MEDAL_INFO.CHILDISHNESSTIP
			if inst.ammolist and GetTableSize(inst.ammolist)>0 then
				local medalstr=STRINGS.MEDAL_INFO.CHILDISHNESSAMMO
				local count=0
				for k,v in pairs(inst.ammolist) do
					count=count+1
					medalstr=medalstr..(STRINGS.NAMES[string.upper(k)] or k)..":"..v..(count>=4 and "\n" or ",")
					count=count%4
				end
				return str.."\n"..string.sub(medalstr,1,-2)
			end
			return str
		end
		--监听射击事件
		inst.medal_shoot = function(self,data)
			if data and data.ammo and inst.ammolist then
				local consume=0--消耗耐久
				local ammo_prefab = GetProjStr(data.ammo.prefab)
				if inst.ammolist[ammo_prefab] == nil then
					inst.ammolist[ammo_prefab] = 0
				end
				if inst.ammolist[ammo_prefab] < 60 then
					inst.ammolist[ammo_prefab] = inst.ammolist[ammo_prefab]+1
					consume = ammo_consume_list[ammo_prefab] or 1
				end
				--沃尔特消耗耐久翻倍
				if self.prefab=="walter" then
					consume=consume*2
				end
				--消耗耐久
				if inst.components.finiteuses then
					consume=consume*TUNING_MEDAL.CHILDISHNESS_MEDAL.CONSUME_MULT
					inst.components.finiteuses:Use(consume)
					SpawnMedalTips(self,consume,11)--弹幕提示
				end
			end
		end
	end,
	onsavefn=function(inst,data)--扩展存储函数
		if inst.ammolist and GetTableSize(inst.ammolist)>0 then
			data.ammolist=shallowcopy(inst.ammolist)
		end
	end,
	onloadfn=function(inst,data)--扩展加载函数
		if data and data.ammolist and GetTableSize(data.ammolist)>0 then
			inst.ammolist=shallowcopy(data.ammolist)
		end
	end,
}
--童真勋章
medal_defs.childlike_certificate={
	name="childlike_certificate",
	animname="childlike_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"copyfunctional",--可印刻
	},
	grouptag="childMedal",
	isfinal=true,--是最终勋章
	onequipfn=function(inst,owner)
		AddMedalTag(owner,"pebblemaker")--弹药制作者
		AddMedalTag(owner,"slingshot_sharpshooter")--弹弓使用者
		AddMedalTag(owner,"pinetreepioneer")--松树先锋(做帽子、帐篷)
		owner:AddTag("has_childishness")--拥有童心
		owner:AddTag("senior_childishness")--童真勋章，装备时可制作特殊弹药、快速射击
		AddMedalComponent(owner,"storyteller")--讲故事组件
		owner.components.storyteller:SetStoryToTellFn(StoryToTellFn)
		owner.components.storyteller:SetOnStoryOverFn(StoryTellingDone)
		owner:PushEvent("refreshcrafting")--更新制作栏
	end,
	onunequipfn=function(inst,owner)
		RemoveMedalTag(owner,"pebblemaker")--弹药制作者
		RemoveMedalTag(owner,"slingshot_sharpshooter")--弹弓使用者
		RemoveMedalTag(owner,"pinetreepioneer")--松树先锋(做帽子、帐篷)
		owner:RemoveTag("has_childishness")--失去童心
		owner:RemoveTag("senior_childishness")--失去童真
		--停止讲故事
		if owner.components.storyteller and owner.components.storyteller:IsTellingStory() then
			-- owner.components.storyteller:OnDone()
			if owner.sg then
				owner.sg:GoToState("idle")
			end
		end
		RemoveMedalComponent(owner,"storyteller")
		owner:PushEvent("refreshcrafting")--更新制作栏
	end,
}
-------------------------------------------------蜂王勋章-------------------------------------------------
medal_defs.bee_king_certificate={
	name="bee_king_certificate",
	animname="bee_king_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"washfunctionalable",--能力可被擦除
	},
	isfinal=true,--是最终勋章
	maxuses=TUNING_MEDAL.BEE_KING_MEDAL.MAXUSES,--次数耐久
	medal_repair_common={--可补充耐久
		royal_jelly=TUNING_MEDAL.BEE_KING_MEDAL.ADDUSE,--蜂王浆
		medal_withered_royaljelly=TUNING_MEDAL.BEE_KING_MEDAL.ADDUSE_MORE,--凋零蜂王浆
	},
	onfinishedfn=function(inst)--耐久用完执行的函数
		--耐久耗光把群攻状态切成毒伤状态
		if inst.changeState then
			inst:changeState(false)
		end
	end,
	onequipfn=function(inst,owner)
		inst.medal_owner=owner--标记佩戴者
		owner.isbeeking=true
		owner:AddTag("is_bee_king")--是蜂王
		AddMedalTag(owner,"insect")--昆虫标签，防止被蜜蜂主动叮咬
		owner:PushEvent("refreshcrafting")--更新制作栏
		owner:ListenForEvent("onattackother", inst.onattackotherfn)--监听攻击目标
		owner.medal_extra_health_delta = inst.medal_extra_health_delta--毒伤(真实伤害部分)
		if owner.components.medal_chaosdamage then
			owner.components.medal_chaosdamage:SetCalcBonusDamageFn(inst.medal_CalcChaosDamage,"bee_king_certificate")--毒伤(混沌伤害部分)
		end
	end,
	onunequipfn=function(inst,owner)
		owner.isbeeking=nil
		owner:RemoveTag("is_bee_king")
		RemoveMedalTag(owner,"insect")--昆虫标签
		owner:PushEvent("refreshcrafting")--更新制作栏
		
		if inst.changeState then
			inst:changeState(false)
		end
		inst.medal_owner=nil
		owner:RemoveEventCallback("onattackother", inst.onattackotherfn)
		owner.medal_extra_health_delta = nil
		if owner.components.medal_chaosdamage then
			owner.components.medal_chaosdamage:SetCalcBonusDamageFn(nil,"bee_king_certificate")--额外混沌伤害
		end
	end,
	--客户端扩展函数
	client_extrafn=function(inst)--额外扩展函数
		--展示名
		inst.displaynamefn = function(inst)
			if inst:HasTag("medal_aoe") then
				return STRINGS.NAMES.BEE_KING_CERTIFICATE_ISAOE
			else
				return STRINGS.NAMES.BEE_KING_CERTIFICATE
			end
		end
	end,
	extrafn=function(inst)--额外扩展函数
		inst:AddComponent("rechargeable")
		--切换勋章模式
		inst.changeState=function(inst,isaoe)
			local owner=inst.medal_owner
			--群攻模式
			if isaoe then
				inst:AddTag("medal_aoe")--勋章群攻标记
				--如果玩家有aoe buff,吸收其层数转化为耐久
				if owner and owner.medal_aoecombat_value then
					if owner.medal_aoecombat_value>0 and inst.components.finiteuses then
						inst.components.finiteuses:SetUses(math.min(inst.components.finiteuses:GetUses()+math.ceil(owner.medal_aoecombat_value*.5),inst.components.finiteuses.total))
					end
					owner:RemoveDebuff("buff_medal_aoecombat")--取消aoe Buff
				end
				if owner and owner.components.combat then
					if not HasOriginMedal(owner) then--本源不降低
						owner.components.combat.externaldamagemultipliers:SetModifier("bee_king_certificate", TUNING_MEDAL.BEE_KING_MEDAL.AOE_MULT)--降低伤害系数
					end
					--设置AOE伤害
					if owner.components.combat.areahitrange==nil then
						owner.components.combat:SetAreaDamage(TUNING_MEDAL.BEE_KING_MEDAL.AOE_DIST,1,function(victim,player)
							if IsValidVictim(victim) then
								-- SpawnPrefab("disease_puff").Transform:SetPosition(victim.Transform:GetWorldPosition())
								return true
							end
						end)
						owner.medal_aoecombat=true--aoe伤害标记
					end
				end
				--切换贴图
				if inst.components.inventoryitem then
					inst.components.inventoryitem:ChangeImageName("bee_king_certificate_aoe")
				end
			else--毒伤模式
				inst:RemoveTag("medal_aoe")--取消勋章群攻标记
				if owner and owner.components.combat then
					owner.components.combat.externaldamagemultipliers:RemoveModifier("bee_king_certificate")--伤害系数恢复正常
				end
				--取消aoe伤害
				if owner and owner.medal_aoecombat then
					owner.medal_aoecombat=nil
					if owner.components.combat then
						owner.components.combat:SetAreaDamage(nil)
					end
				end
				--切换贴图
				if inst.components.inventoryitem then
					inst.components.inventoryitem:ChangeImageName("bee_king_certificate")
				end
			end
		end
		--监听玩家攻击目标的事件
		inst.onattackotherfn = function(self,data)
			--远程射击武器会推两次消息，以第一次消耗为准
			if inst:HasTag("medal_aoe") and data.projectile==nil then
				local distance=math.sqrt(self:GetDistanceSqToInst(data.target))--距离
				local consume = math.ceil(math.max(distance-3,0)/3) + 1--消耗
				--群攻模式每次攻击根据命中距离消耗耐久
				if inst.components.finiteuses then
					inst.components.finiteuses:Use(consume)
				end
			end
		end
		--毒伤(混沌伤害)
		inst.medal_CalcChaosDamage = function(owner, target)
			local chaos_damage = 0
			if target and not inst:HasTag("medal_aoe") then--仅限毒伤模式
				target:AddDebuff("buff_medal_poisonmark","buff_medal_poisonmark",{marknum = HasOriginMedal(owner) and 2 or 1})
				local poison_count = math.min(target.medal_poison_mark or 1,TUNING_MEDAL.BEE_KING_MEDAL.POISON_MAX_NOCONSUME)--蜂毒层数
				if inst.components.rechargeable then--勋章进入冷却CD
					inst.components.rechargeable:Discharge(TUNING_MEDAL.BEE_KING_MEDAL.POISON_CD)
				end
				chaos_damage = chaos_damage + poison_count * TUNING_MEDAL.BEE_KING_MEDAL.POISON_DAMAGE
			end
			return chaos_damage
		end
		--毒伤(真实伤害)
		inst.medal_extra_health_delta = function(target, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
			local poison_count = target and target.medal_poison_mark or 0--蜂毒层数
			--蜂毒层数超过阈值,需额外消耗耐久,超出部分为真伤
			if poison_count > TUNING_MEDAL.BEE_KING_MEDAL.POISON_MAX_NOCONSUME and not inst:HasTag("medal_aoe") then
				local true_damage = (TUNING_MEDAL.BEE_KING_MEDAL.POISON_MAX_NOCONSUME - poison_count) * TUNING_MEDAL.BEE_KING_MEDAL.POISON_DAMAGE
				--本源勋章不需要消耗耐久
				if HasOriginMedal(afflicter,"is_bee_king") then
					return true_damage, true
				end
				local uses = inst.components.finiteuses and inst.components.finiteuses:GetUses() or 0--剩余耐久
				if uses and uses>0 then
					inst.components.finiteuses:Use(1)
					return true_damage, true
				end
			end
			return 0, ignore_absorb
		end
	end,
}
-------------------------------------------------使命勋章-------------------------------------------------
local medal_missions = require("medal_defs/medal_mission_defs")
--初始化任务数据(inst,任务ID,剩余次数,玩家)
local function InitMission(inst,id,use,doer)
	if inst.init_task then
		inst.init_task:Cancel()
		inst.init_task = nil
	end
	local randomnum = math.random()--GetMedalDestiny(inst)--已经废弃的东西就别整宿命了，别浪费资源
	inst.medal_task_id = id or math.floor(randomnum*(#medal_missions)+1)
	local missiondata = medal_missions[inst.medal_task_id]
	if missiondata then
		if missiondata.Init then
			missiondata.Init(inst)
		end
		inst.getMedalInfo = missiondata.getMedalInfo
		if missiondata.mission_times then
			inst.components.finiteuses:SetMaxUses(missiondata.mission_times)
			inst.components.finiteuses:SetUses(use or missiondata.mission_times)
		end
	end
end

medal_defs.mission_certificate={
	name="mission_certificate",
	animname="mission_certificate",
	hassound=true,--需要播声音
	nodebug=true,--dm_allmedal()不自动生成
	taglist={
	"addfunctional",--可放入融合勋章
	"showmedalinfo",--显示勋章信息
	"medal_tradeable",--可和雕像交易
	},
	maxuses=100,--次数耐久(默认,会根据不同任务而改变)
	onfinishedfn=function(inst)--耐久用完执行的函数
		local x,y,z = inst.Transform:GetWorldPosition()
		local num = inst.mission_data and inst.mission_data.reward_num or TUNING_MEDAL.MISSION_MEDAL.REWARD_NUM--获取奖励数量
		for i = 1, num do--掉落包果
			inst.components.lootdropper:SpawnLootPrefab("medal_gift_fruit")
		end
		inst.SoundEmitter:PlaySound("dontstarve/wilson/use_armour_break")
		inst:Remove()
	end,
	onequipfn=function(inst,owner)
		owner.in_medal_mission = true--表示处于使命任务中
		if inst.medal_task_id and medal_missions[inst.medal_task_id] and medal_missions[inst.medal_task_id].onEquip then
			medal_missions[inst.medal_task_id].onEquip(inst,owner)
		end
	end,
	onunequipfn=function(inst,owner)
		owner.in_medal_mission = nil--结束使命任务状态
		if inst.medal_task_id and medal_missions[inst.medal_task_id] and medal_missions[inst.medal_task_id].onUnEquip then
			medal_missions[inst.medal_task_id].onUnEquip(inst,owner)
		end
	end,
	client_extrafn=function(inst)
		
	end,
	extrafn=function(inst)
		inst:AddComponent("lootdropper")
		inst.InitMission = InitMission
		-- InitMission(inst)
		--延迟初始化，可以通过主动调用Init函数的方式取消延迟任务，免于多次定义任务浪费资源
		inst.init_task = inst:DoTaskInTime(0.1,function(inst)
			InitMission(inst)
		end)
	end,
	onsavefn=function(inst,data)--扩展存储函数
		data.medal_task_id = inst.medal_task_id
		data.last_use = inst.components.finiteuses:GetUses()
	end,
	onloadfn=function(inst,data)--扩展加载函数
		if data then
			InitMission(inst,data.medal_task_id,data.last_use)
		end
	end,
}
-------------------------------------------------暗影勋章-------------------------------------------------
--杀死仆从
local function KillPet(pet)
	if pet.components.health then
		if pet.components.health:IsInvincible() then
			pet._killtask = pet:DoTaskInTime(.5, KillPet)
		else
			pet.components.health:Kill()
		end
	end
end
--移除所有仆从
local function KillAllPets(inst)
    for k, v in pairs(inst.components.petleash:GetPets()) do
        if v:HasTag("shadowminion") and v._killtask == nil and v.ismedalshadowpet then
            -- v._killtask = v:DoTaskInTime(math.random(), KillPet)
			KillPet(v)
        end
    end
end
--生成仆从
local function OnSpawnPet(inst, pet)
    local medal = inst and inst.components.inventory:EquipMedalWithName("shadowmagic_certificate")--获取玩家的暗影勋章
	--暗影勋章有足够耐久才走这块逻辑
	if medal and medal.components.finiteuses and medal.components.finiteuses:GetUses() > 0 and pet:HasTag("shadowminion") then
		if not (inst.components.health:IsDead() or inst:HasTag("playerghost")) then
			medal.components.finiteuses:Use(1)--消耗1点耐久
            inst:ListenForEvent("onremove", medal.medal_onpetlost, pet)
            pet.components.skinner:CopySkinsFromPlayer(inst)
			pet.ismedalshadowpet=true--是勋章特有仆从
        elseif pet._killtask == nil then
            pet._killtask = pet:DoTaskInTime(math.random(), KillPet)
        end
	elseif inst.medal_OnSpawnPet ~= nil then
		inst:medal_OnSpawnPet(pet)
	end
end
--移除仆从
local function OnDespawnPet(inst, pet)
	if pet:HasTag("shadowminion") and pet.ismedalshadowpet then
		if not inst.is_snapshot_user_session and pet.sg ~= nil then
			pet.sg:GoToState("quickdespawn")
		else
			pet:Remove()
		end
    elseif inst.medal_OnDespawnPet ~= nil then
        inst:medal_OnDespawnPet(pet)
    end
end
medal_defs.shadowmagic_certificate={
	name="shadowmagic_certificate",
	animname="shadowmagic_certificate",
	taglist={
	"addfunctional",--可放入融合勋章
	"washfunctionalable",--能力可被擦除
	"shadowlevel",--暗影装备加成等级
	},
	isfinal=true,--是最终勋章
	upgradable=true,--可升级
	maxlevel=TUNING_MEDAL.SHADOWMAGIC_MEDAL.MAX_LEVEL,--最高等级
	maxuses=TUNING_MEDAL.SHADOWMAGIC_MEDAL.MAXUSES[1],--次数耐久
	onfinishedfn=function(inst)--耐久用完执行的函数
		
	end,
	--需要对载体生效的部分装备函数(inst是融合勋章,item是勋章本身,owner是佩戴者)
	onequipwithrhfn=function(inst,item,owner)
		if inst.components.shadowlevel==nil then
			inst:AddComponent("shadowlevel")
		end
		inst.components.shadowlevel:SetLevelFn(function(inst)
			return item and item.medal_level or 1
		end)
	end,
	--需要对载体生效的部分卸下函数(inst是融合勋章,item是勋章本身,owner是佩戴者)
	onunequipwithrhfn=function(inst,item,owner)
		if inst.components.shadowlevel~=nil then
			inst:RemoveComponent("shadowlevel")
		end
	end,
	onequipfn=function(inst,owner)
		AddMedalTag(owner,"shadowmagic")--暗影魔术师标签
		AddMedalComponent(owner,"magician")--魔术师组件
		owner:AddTag("has_shadowmagic_medal")
		owner:PushEvent("refreshcrafting")--更新制作栏
		inst.components.finiteuses:SetPercent(1)--装备的时候回满耐久
		--仆从组件
		if owner.components.petleash ~= nil then
			owner.medal_OnSpawnPet = owner.components.petleash.onspawnfn
			owner.medal_OnDespawnPet = owner.components.petleash.ondespawnfn
			owner.components.petleash:SetMaxPets(owner.components.petleash:GetMaxPets() + inst.maxuses_level[inst.medal_level])
		else--正常情况下不会没有这个组件
			AddMedalComponent(owner,"petleash")
			owner.components.petleash:SetMaxPets(inst.maxuses_level[inst.medal_level])
		end
		owner.components.petleash:SetOnSpawnFn(OnSpawnPet)
		owner.components.petleash:SetOnDespawnFn(OnDespawnPet)
	end,
	onunequipfn=function(inst,owner)
		RemoveMedalTag(owner,"shadowmagic")--暗影魔术师标签
		RemoveMedalComponent(owner,"magician")--魔术师组件
		owner:RemoveTag("has_shadowmagic_medal")
		owner:PushEvent("refreshcrafting")--更新制作栏

		KillAllPets(owner)

		if owner.medal_OnSpawnPet ~= nil then
			owner.components.petleash:SetMaxPets(owner.components.petleash:GetMaxPets() - inst.maxuses_level[inst.medal_level])
			owner.components.petleash:SetOnSpawnFn(owner.medal_OnSpawnPet)
    		owner.components.petleash:SetOnDespawnFn(owner.medal_OnDespawnPet)
			owner.medal_OnSpawnPet = nil
			owner.medal_OnDespawnPet = nil
		else
			RemoveMedalComponent(owner,"petleash")
		end
	end,
	extrafn=function(inst)--额外扩展函数
		inst:AddComponent("shadowlevel")--暗影装备加成等级
		inst.components.shadowlevel:SetLevelFn(function(inst)
			return inst.medal_level or 1
		end)
		inst.maxuses_level = TUNING_MEDAL.SHADOWMAGIC_MEDAL.MAXUSES--不同等级耐久上限
		inst.LevelUpFn = function(inst)--升级时执行
			if inst.medal_level and inst.components.finiteuses and inst.maxuses_level then
				inst.components.finiteuses:SetMaxUses(inst.maxuses_level[inst.medal_level])
				inst.components.finiteuses:SetPercent(1)
			end
		end
		--监听仆从死亡
		inst.medal_onpetlost = function(self,data)
			if inst.components.finiteuses:GetPercent()<1 then
				inst.components.finiteuses:Use(-1)--恢复1点耐久
			end
		end
	end,
	onloadfn=function(inst,data)--扩展加载函数
		inst:LevelUpFn()
	end,
}
-------------------------------------------------空白勋章-------------------------------------------------
local function TeachBlackMedal(inst)
	local order = {1,2,3,4,5,6,7,8}
	inst.puzzle = {}
	inst.product_orchestrina=true
	for i=1,8 do
		local num = math.random(1,#order)
		table.insert(inst.puzzle,order[num])
		table.remove(order,num)
	end
	inst:ListenForEvent("onteach", function(inst)
		--生成特效
		SpawnPrefab("lavaarena_player_revive_from_corpse_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
		--禁止拾取
		if inst.components.inventoryitem then
			inst.components.inventoryitem.canbepickedup=false
		end
		inst:DoTaskInTime(2, function() 
			local newmedal=SpawnPrefab("inherit_certificate")
			if newmedal then
				local x, y, z = inst.Transform:GetWorldPosition()
				local main = TheSim:FindEntities(x,y,z, 10, {"archive_orchestrina_main"})
				if main then
					for i,ent in ipairs(main)do
						ent.busy = false--解除法阵的占用状态
					end
				end
				newmedal.Transform:SetPosition(x, y, z)
				inst:Remove()
			end
		end)
	end)
end

--材料(无功能)
medal_defs.blank_certificate={
	name="blank_certificate",
	animname="blank_certificate",
	isfinal=true,--是最终勋章
	taglist={
	-- "addfunctional",--可放入融合勋章
	"archive_lockbox",--遗忘的知识(方便被识别，用来解锁传承)
	},
	onequipfn=function(inst,owner)
		
	end,
	onunequipfn=function(inst,owner)
		
	end,
	extrafn=function(inst)--额外扩展函数
		TeachBlackMedal(inst)--变成传承勋章
	end,
}
--印刻后
medal_defs.copy_blank_certificate={
	name="copy_blank_certificate",
	animname="blank_certificate",
	atlas="blank_certificate",--共用图集所以要用这个
	taglist={
	"addfunctional",--可放入融合勋章
	"blank_certificate",--空白勋章标签
	"archive_lockbox",--遗忘的知识(方便被识别，用来解锁传承)
	"washfunctionalable",--能力可被擦除
	},
	-- isfinal=true,--是最终勋章
	nodebug=true,--dm_allmedal()不自动生成
	onequipfn=function(inst,owner)
		local medalname = inst.medalname or "copy_blank_certificate"--空白勋章不能重复调用自己的装备函数，防止栈溢出
		if medalname ~= "copy_blank_certificate" and medal_defs[medalname]~=nil then
			medal_defs[medalname].onequipfn(inst,owner)
		end
	end,
	onunequipfn=function(inst,owner)
		local medalname = inst.medalname or "copy_blank_certificate"
		if medalname ~= "copy_blank_certificate" and medal_defs[medalname]~=nil then
			medal_defs[medalname].onunequipfn(inst,owner)
		end
	end,
	--需要对载体生效的部分装备函数(inst是融合勋章,item是勋章本身,owner是佩戴者)
	onequipwithrhfn=function(inst,item,owner)
		local medalname = inst.medalname or "copy_blank_certificate"
		if medalname ~= "copy_blank_certificate" and medal_defs[medalname] and medal_defs[medalname].onequipwithrhfn then
			medal_defs[medalname].onequipwithrhfn(inst,item,owner)
		end
	end,
	--需要对载体生效的部分卸下函数(inst是融合勋章,item是勋章本身,owner是佩戴者)
	onunequipwithrhfn=function(inst,item,owner)
		local medalname = inst.medalname or "copy_blank_certificate"
		if medalname ~= "copy_blank_certificate" and medal_defs[medalname] and medal_defs[medalname].onunequipwithrhfn then
			medal_defs[medalname].onunequipwithrhfn(inst,item,owner)
		end
	end,
	--客户端扩展函数
	client_extrafn=function(inst)--额外扩展函数
		inst.grouptag="copy_blank_certificate"--默认勋章组
		--印刻勋章名网络变量
		inst.blankmedalchangename = net_string(inst.GUID, "blankmedalchangename", "blankmedalchangenamedirty")
		inst.blankmedalchangename:set("copy_blank_certificate")
		inst:ListenForEvent("blankmedalchangenamedirty", function(inst)
			local displayname = inst.blankmedalchangename:value() or "copy_blank_certificate"--勋章名
			local medalinfo = string.split(displayname, "&")
			local medalname = medalinfo[1]
			inst.medal_displayname = medalname--展示名
			inst.medal_displaylevel = medalinfo[2] and medalinfo[2] + 0--展示等级
			inst.grouptag = medal_defs[medalname] and medal_defs[medalname].grouptag or medalname--勋章组
		end)
		--展示名
		inst.displaynamefn = function(inst)
			local medallevel = inst.medal_displaylevel or 0
			local displayname = inst.medal_displayname or "copy_blank_certificate"
			if medallevel > 1 then
				return subfmt(STRINGS.NAMES.BLANK_CERTIFICATE_LEVEL, { level = medallevel,medal = STRINGS.NAMES[string.upper(displayname)] })
			end
			return subfmt(STRINGS.NAMES.BLANK_CERTIFICATE_COPY, {medal = STRINGS.NAMES[string.upper(displayname)] })
		end
	end,
	extrafn=function(inst)--额外扩展函数
		TeachBlackMedal(inst)--变成传承勋章
		--能力印刻
		inst.PowerPrint = function(inst,target_medal)
			local medalname = target_medal.prefab
			local level = target_medal.medal_level
			local medalstr = medalname
			if level and level > 0 then
				medalstr = medalname.."&"..level
			end
			if inst.blankmedalchangename == nil or medalstr == inst.blankmedalchangename:value() then
				return false--,"ALREADY"--已经有这个能力了
			end
			--切换贴图
			if inst.components.inventoryitem then
				inst.components.inventoryitem:ChangeImageName("copy_"..medalname)
			end
			inst.medalname = medalname--记录印刻的勋章名
			inst.medal_level = level--覆盖勋章等级
			inst.grouptag = medal_defs[medalname] and medal_defs[medalname].grouptag or medalname--勋章组
			inst.blankmedalchangename:set(medalstr)--换名
			return true
		end
	end,
	onsavefn=function(inst,data)--扩展存储函数
		--空白勋章名字保存
		data.functional_tag=inst.blankmedalchangename and inst.blankmedalchangename:value() or "copy_blank_certificate"
	end,
	onloadfn=function(inst,data)--扩展加载函数
		--空白勋章换名
		if data and data.functional_tag then
			local medalinfo = string.split(data.functional_tag, "&")
			local medalname = medalinfo[1]
			local level = medalinfo[2]
			--确保原本印刻的勋章现在也还是可印刻的
			if medalname and medal_defs[medalname]~=nil and medal_defs[medalname].taglist and table.contains(medal_defs[medalname].taglist,"copyfunctional") then
				local maxlevel = medal_defs[medalname].maxlevel
				--切换贴图
				if inst.components.inventoryitem then
					inst.components.inventoryitem:ChangeImageName("copy_"..medalname)
				end
				inst.medalname = medalname--记录印刻的勋章名
				inst.grouptag = medal_defs[medalname] and medal_defs[medalname].grouptag or medalname--勋章组
				if maxlevel then--有最大等级意味着可升级,所以至少也应该有1级
					inst.medal_level = math.min(level and level + 0 or 1, maxlevel)--继承勋章等级
					medalname = medalname.."&"..inst.medal_level
				end
				inst.blankmedalchangename:set(medalname)
			end
		end
	end,
}

return {MEDAL_DEFS = medal_defs}

