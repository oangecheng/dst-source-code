
local easing = require("easing")

----------------------------------------公用函数------------------------------------------
--耐久用完移除施法组件
local function staff_onfinished(inst)
    if inst.components.spellcaster~=nil then
		inst:RemoveComponent("spellcaster")
	end
end

local staff_defs = {}
--------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------吞噬法杖----------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
--诱饵
local baits_list={
	powcake = true,--火药饼
	winter_food4 = true,--水果蛋糕
	mandrake = true,--曼德拉草
	tallbirdegg = true,--高脚鸟蛋
}
local Walls = nil--墙体列表(把检索到的墙体暂存在内，减少重复检索的操作，降低性能消耗)
local WALL_DIST = 2--墙距离
local wall_tags={"wall","_health"}
local notags={"INLIMBO"}
--判断诱饵是否围在墙内
local function isInsideWall(item,pos)
	if not baits_list[item.prefab] then return end
	if Walls == nil then
		Walls = TheSim:FindEntities(pos.x, pos.y, pos.z, TUNING_MEDAL.DEVOUR_STAFF_RADIUS + WALL_DIST, wall_tags, notags)
	end
	if Walls ~= nil then
		local wallNum = 0
		for i, v in ipairs(Walls) do
			if item:IsNear(v, WALL_DIST) then
				wallNum = wallNum + 1
				if wallNum >= 4 then return true end
			end
		end
	end
end
local Beeboxs = nil--蜂箱列表(把检索到的蜂箱暂存在内，减少重复检索的操作，降低性能消耗)
local BEEBOX_DIST = 6--蜂箱距离
local beebox_tags={"beebox"}
--是否是蜂箱边上的花
local function isHoneyFlower(item, pos)
	if not item:HasTag("flower") then return end
	if Beeboxs == nil then
		Beeboxs = TheSim:FindEntities(pos.x, pos.y, pos.z, TUNING_MEDAL.DEVOUR_STAFF_RADIUS + BEEBOX_DIST, beebox_tags, notags)
	end
	if Beeboxs ~= nil then
		for i, v in ipairs(Beeboxs) do
			if item:IsNear(v, BEEBOX_DIST) then
				return true
			end
		end
	end
end
--计算饱食消耗(玩家,物品,计数)
local function getHungerLoss(player,item,count)
	local distance=math.sqrt(player:GetDistanceSqToInst(item))--吞噬距离
	return (distance/4)*count*TUNING_MEDAL.DEVOUR_STAFF_SANITY_MULT--吞噬消耗
end

--批量拾取白名单物品
local NOPICK_LIST={
	mandrake_planted=true,--曼德拉草
	medal_wormwood_flower=true,--虫木花
	storage_robot=true,--瓦器人
	winona_storage_robot=true,--薇机人
	winona_telebrella=true,--传送伞
	winona_remote=true,--遥控器
	phonograph=true,--留声机
	singingshell_octave3=true,--贝壳钟
	singingshell_octave4=true,--贝壳钟
	singingshell_octave5=true,--贝壳钟
	voidcloth_umbrella=true,--暗影伞
}
--树桩产物表
local TREELIST={
	livingtree_halloween="livinglog",--万圣节活木树
	livingtree="livinglog",--活木树
	driftwood_tall="driftwood_log",--浮木树
	medal_fruit_tree_stump="medaldug_fruit_tree_stump",--砧木桩
}

--拾取物品(inst,物品,玩家,中心坐标)
local function pickitem(inst,item,player,pos)
	local hungerLoss=0--饱食消耗
	if pos ~= nil then--范围拾取时,满足以下条件的物品直接跳过
		if NOPICK_LIST[item.prefab] or--白名单物品
			isInsideWall(item,pos) or--围在墙内的诱饵
			(item:HasTag("trap") and item.components.inventoryitem and item.components.inventoryitem.nobounce) or--部署好的陷阱
			(item.components.trap and item.components.trap.isset) then--安置好的陷阱
			return hungerLoss
		end
	end
	if player == nil or player.components.inventory==nil then return hungerLoss end
	---------------挖取木桩----------------
	if player.large_chop and inst.space_target == nil and item:HasTag("stump") then
		local logname = TREELIST[item.prefab] or "log"
		if item.prefab=="deciduoustree" and item.monster then
			logname="livinglog"--桦木树精的树桩应该产活木
		end
		hungerLoss = getHungerLoss(player,item,TUNING_MEDAL.DEVOUR_STAFF_HARVEST_COUNT)
		-- SpawnMedalFX("spawn_fx_tiny",item)
		local logitem = SpawnPrefab(logname)
		if (item.prefab=="moon_tree" or item.prefab=="palmconetree") and item.size ~= "short" then
			if logitem.components.stackable then
				logitem.components.stackable:SetStackSize(2)
			end
		end
		player.components.inventory:GiveItem(logitem,nil,item:GetPosition())
		item:Remove()
		return hungerLoss
	end
	-----------------------丰收勋章采集、收获资源-------------------------
	if player.quickpickmedal and inst.space_target == nil then
		--采集
		if item:HasTag("pickable") and item.components.pickable then
			--范围采集的时候不采集蜂箱边上的花
			if pos ~= nil and isHoneyFlower(item, pos) then
				return hungerLoss
			end
			hungerLoss = getHungerLoss(player,item,TUNING_MEDAL.DEVOUR_STAFF_HARVEST_COUNT)
			-- SpawnMedalFX("spawn_fx_tiny",item)
			if item.prefab=="tumbleweed" and player.components.lucky~=nil then
				player.components.lucky:DoDelta(-(TUNING.GAME_LEVEL or 1))--额外扣除幸运值
			end
			item.components.pickable:Pick(player)
			return hungerLoss
		end
		--蘑菇农场、蜂箱等
		if item.components.harvestable then
			hungerLoss = getHungerLoss(player,item,TUNING_MEDAL.DEVOUR_STAFF_HARVEST_COUNT)
			-- SpawnMedalFX("spawn_fx_tiny",item)
			--配方蜂王勋章且育王蜂箱满时,采收的为凋零蜂王浆
			if item:HasTag("medal_beebox_full") and player:HasTag("is_bee_king") then
				item.components.harvestable:HarvestMedalBeeBox(player)
			else
				item.components.harvestable:Harvest(player)
			end
			return hungerLoss
		end
		--农作物
		if item.components.crop then
			hungerLoss=getHungerLoss(player,item,TUNING_MEDAL.DEVOUR_STAFF_HARVEST_COUNT)
			-- SpawnMedalFX("spawn_fx_tiny",item)
			item.components.crop:Harvest(player)
			return hungerLoss
		end
		--锅
		if item.components.stewer then
			hungerLoss=getHungerLoss(player,item,TUNING_MEDAL.DEVOUR_STAFF_HARVEST_COUNT)
			-- SpawnMedalFX("spawn_fx_small_high",item)
			item.components.stewer:Harvest(player)
			return hungerLoss
		end
		--晒肉架
		if item.components.dryer then
			hungerLoss=getHungerLoss(player,item,TUNING_MEDAL.DEVOUR_STAFF_HARVEST_COUNT)
			-- SpawnMedalFX("spawn_fx_small_high",item)
			item.components.dryer:Harvest(player)
			return hungerLoss
		end
		--眼球草
		if item.components.shelf then
			hungerLoss=getHungerLoss(player,item,TUNING_MEDAL.DEVOUR_STAFF_HARVEST_COUNT)
			-- SpawnMedalFX("spawn_fx_small_high",item)
			item.components.shelf:TakeItem(player)
			return hungerLoss
		end
	end
	---------------拾取道具-------------------
	if item.components.inventoryitem and item.components.inventoryitem.canbepickedup and item.components.inventoryitem.cangoincontainer and not item.components.inventoryitem:IsHeld() then
		local stacknum = item.components.stackable and item.components.stackable:StackSize() or 1--堆叠数量
		--如果是触发后的陷阱则拾取
		if item.components.trap and item.components.trap:IsSprung() then
			if not inst.space_target then
				hungerLoss=getHungerLoss(player,item,1)
				-- SpawnMedalFX("spawn_fx_tiny",item)
				item.components.trap:Harvest(player)
			end
			return hungerLoss
		end
		--消耗计算
		hungerLoss=getHungerLoss(player,item,math.ceil(stacknum/5))--堆叠的减少消耗,每5个按1个算
		-- SpawnMedalFX("spawn_fx_tiny",item)
		if inst.space_target and inst.space_target:IsValid() and inst.space_target.components.container and inst.spacevalue>0 and inst.space_target:HasTag("isspacechest") then
			--拾取到容器里不会自动执行onpickup方法，需要自己手动对玩家执行一下，附加的特殊效果也只能作用到玩家身上了
			if not (item.components.inventoryitem.onpickupfn and item.components.inventoryitem.onpickupfn(item,player,item:GetPosition())) then
				inst.space_target.components.container:GiveItem(item)
			end
			inst.spacevalue=inst.spacevalue-1--消耗空间之力
		else
			if inst.space_target and inst.changeTarget then
				inst:changeTarget(nil)--清除绑定的目标
				if inst.spacevalue>0 then
					MedalSay(player,STRINGS.DELIVERYSPEECH.CANTFINDTARGET)
				else
					MedalSay(player,STRINGS.DELIVERYSPEECH.NOCONSUME)
				end
			end
			player.components.inventory:GiveItem(item,nil,item:GetPosition())
		end
	end
	return hungerLoss
end

local pick_must_tags = {"_inventoryitem"}--拾取必备标签
local harvest_must_tags = {"_inventoryitem","pickable","harvestable","readyforharvest","donecooking","dried","takeshelfitem","stump"}--丰收必备标签
local chop_must_tags = {"_inventoryitem", "stump"}--伐木必备标签
local pick_no_tags = {"INLIMBO", "NOCLICK", "catchable", "fire","notdevourable"}--需跳过的标签

--施法拾取物品函数
local function pickup_func(inst,target,pos,doer,single)
	local caster = doer or inst.components.inventoryitem.owner--施法者
	local hungerLoss = 0--饱食度消耗
	local findList = caster and (caster.quickpickmedal and harvest_must_tags or caster.large_chop and chop_must_tags) or pick_must_tags--必需标签组
	local castRadius = TUNING_MEDAL.DEVOUR_STAFF_RADIUS--施法范围
	local scalefx = "medal_reticule_scale_fx"--范围圈特效
	--对点使用
	if pos ~= nil then
		local x,y,z = pos:Get()
		local ents = TheSim:FindEntities(x, y, z, castRadius ,nil , pick_no_tags, findList)
		SpawnMedalFX(scalefx,nil,pos,castRadius)--生成范围圈
		if #ents>0 then
			for i,v in ipairs(ents) do
				hungerLoss = hungerLoss + pickitem(inst,v,caster,pos)
			end
		end
	--对单个目标使用
	elseif target then
		local canpick=true
		if inst.spacevalue then
			--分解坎普斯背包
			if target.prefab=="krampus_sack" and not target:HasTag("isimmortal") then
				if inst.spacevalue>=50 then
					local spawnnum=math.random(2,4)
					for i = 1, spawnnum do
						LaunchAt(SpawnPrefab("medal_spacetime_lingshi"), target, caster, 0.5, 1, 0.5)
					end
					if target.components.container ~= nil then
						target.components.container:DropEverything()
					end
					target:Remove()
					inst.spacevalue = inst.spacevalue - 50
				else
					MedalSay(caster,STRINGS.DELIVERYSPEECH.NOCONSUME)
				end
				canpick=false
			--对自己施法
			elseif caster and caster==target then
				local needuses = TUNING_MEDAL.MEDAL_SPACE_STAFF_ADDVALUE--需要消耗空间之力(一颗砂之石的量)
				--有连接目标就直接传送到目标处
				if inst.space_target then
					if inst.space_target:IsValid() and inst.space_target:HasTag("isspacechest") then
						if inst.spacevalue>=needuses then
							local x,y,z=inst.space_target.Transform:GetWorldPosition()
							caster.sg:GoToState("pocketwatch_warpback",{warpback={dest_x = x, dest_y = 0, dest_z = z}})
							inst.spacevalue = inst.spacevalue - needuses
						else
							MedalSay(caster,STRINGS.DELIVERYSPEECH.NOCONSUME)
						end
					elseif inst.changeTarget then
						inst:changeTarget(nil)--清除绑定的目标
						MedalSay(caster,STRINGS.DELIVERYSPEECH.CANTFINDTARGET)
					end
				else--没有就直接吞噬周围物品
					pos = caster:GetPosition()
					local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, castRadius ,nil , pick_no_tags, findList)
					SpawnMedalFX(scalefx,caster,nil,castRadius)--生成范围圈
					if #ents>0 then
						for i,v in ipairs(ents) do
							hungerLoss=hungerLoss+pickitem(inst,v,caster,pos)
						end
					end
				end
				canpick=false
			end
		end
		if canpick and caster ~= nil and caster.components.inventory~=nil then
			--单目标拾取
			if single then
				hungerLoss=hungerLoss+pickitem(inst,target,caster)
			else--拾取同种物品
				pos = target:GetPosition()
				SpawnMedalFX(scalefx,target,nil,castRadius)--生成范围圈
				local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, castRadius ,nil , pick_no_tags, findList)
				local targetname=target.prefab--这里要先记录下预置物名，不然会出现中途被拾走导致无法比对的情况
				local pickall = caster == target--对着自己用的话，就拾取周围全部物品
				for i,v in ipairs(ents) do
					if pickall or v.prefab==targetname then
						hungerLoss=hungerLoss+pickitem(inst,v,caster,pos)
					end
				end
			end
		end
	--在装备栏使用
	elseif caster then
		pos = caster:GetPosition()
		local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, castRadius ,nil , pick_no_tags, findList)
		SpawnMedalFX(scalefx,caster,nil,castRadius)--生成范围圈
		for i,v in ipairs(ents) do
			hungerLoss=hungerLoss+pickitem(inst,v,caster,pos)
		end
	end
	
	if hungerLoss>0 then
		Walls = nil--清空墙的记录
		Beeboxs = nil--清空蜂箱记录
		local hungerLoss=math.min(math.ceil(hungerLoss),TUNING_MEDAL.DEVOUR_STAFF_SANITY_MAX)
		-- print("本次消耗"..hungerLoss)
		--扣除法杖耐久
		if inst.components.finiteuses then
			local use=inst.components.finiteuses:GetUses()
			inst.components.finiteuses:Use(hungerLoss)
			hungerLoss=hungerLoss-use
		end
		--扣除玩家饱食度
		if hungerLoss>0 and caster and caster.components.hunger then
			caster.components.hunger:DoDelta(-hungerLoss)
		end
	end
end

--可吞噬的标签列表
local can_devour_tags={
	"pickable",--可采集的
	"harvestable",--可收获的
	"readyforharvest",--可收获的(农作物)
	"donecooking",--烹饪好的料理
	"dried",--晒好的东西
	"takeshelfitem",--架子(眼球草)
}

--判断是否为有效施法目标
local function devour_can_cast_fn(doer, target, pos)
	if target==nil or doer==target then
		return true
	end
	--可库存的
	if target.components.inventoryitem ~= nil then
		return true
	end
	
	--如果玩家戴了丰收勋章
	if doer.quickpickmedal and target:HasOneOfTags(can_devour_tags) then
		return true
	end
	--如果玩家有高级伐木勋章标签
	if doer.large_chop then
		--树桩
		if target:HasTag("stump") then
			return true
		end
	end
	
    return false
end

staff_defs.devour_staff={
	name="devour_staff",
	animname="devour_staff",
	taglist={
		"medalquickcastleft",--单目标左键快速施法
		"allow_action_on_impassable",--不可通行区域施法
		"medal_eatfood",--可喂食料理
		"cangivespacegem",--可以赋予空间之力
		"immortalable",--可以赋予不朽之力
		"medal_skinable",--可换皮肤
	},
	maxuse=TUNING_MEDAL.DEVOUR_STAFF_USES,--最大耐久
	onfinishedfn=staff_onfinished,--耐久用完函数
	fxcolour={73/255,120/255,81/255},--施法颜色
	radius=TUNING_MEDAL.DEVOUR_STAFF_RADIUS,--作用范围
	spellfn=function(inst)--施法函数
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(pickup_func)--捡东西
		inst.components.spellcaster.canuseontargets = true--对某一个目标使用
		inst.components.spellcaster.canuseonpoint = true--对坐标点使用
		inst.components.spellcaster.canuseonpoint_water = true--船上使用
		inst.components.spellcaster.canusefrominventory = true--在装备栏右键使用
		inst.components.spellcaster:SetCanCastFn(devour_can_cast_fn)--有效目标函数
	end,
	extrafn=function(inst)--扩展函数
		inst:AddComponent("medal_skinable")
	end,
}

--------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------时空法杖----------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
staff_defs.medal_space_staff={
	name="medal_space_staff",
	animname="medal_space_staff",
	taglist={
		"medalquickcastleft",--单目标左键快速施法
		"allow_action_on_impassable",--不可通行区域施法
		"showmedalinfo",--显示勋章信息
		"medal_eatfood",--可喂食料理
		"medal_skinable",--可换皮肤
	},
	maxuse=TUNING_MEDAL.MEDAL_SPACE_STAFF_MAXUSES,--最大耐久
	onfinishedfn=staff_onfinished,--耐久用完函数
	fxcolour={66/255,52/255,132/255},--施法颜色
	radius=TUNING_MEDAL.DEVOUR_STAFF_RADIUS,--作用范围
	spellfn=function(inst)--施法函数
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(pickup_func)--捡东西
		inst.components.spellcaster.canuseontargets = true--对某一个目标使用
		inst.components.spellcaster.canuseonpoint = true--对坐标点使用
		inst.components.spellcaster.canuseonpoint_water = true--船上使用
		-- inst.components.spellcaster.canusefrominventory = true--在装备栏右键使用
		inst.components.spellcaster:SetCanCastFn(devour_can_cast_fn)--有效目标函数
	end,
	client_extrafn=function(inst)--客户端扩展函数
		inst.deliverylist = net_string(inst.GUID, "deliverylist")--传送列表
	end,
	extrafn=function(inst)--扩展函数
		inst:AddComponent("medal_skinable")--可换皮肤
		inst:AddComponent("medal_delivery")--自由传送组件
		inst.spacevalue=TUNING_MEDAL.MEDAL_SPACE_STAFF_MAXVALUE--空间之力
		inst.addSpaceValue=function(inst,material)
			local uses = inst.spacevalue--当前空间之力
			local total = TUNING_MEDAL.MEDAL_SPACE_STAFF_MAXVALUE--空间之力上限
			local adduse=TUNING_MEDAL.MEDAL_SPACE_STAFF_ADDVALUE
			if uses>=total then
				return--空间之力达上限了
			end
			
			local neednum=math.max(math.floor((total-uses)/adduse),1)--需要消耗的材料数量
			local fuelnum = material.components.stackable and material.components.stackable.stacksize or 1--材料数量
			--消耗材料变更空间之力
			if fuelnum>neednum then
				material.components.stackable:SetStackSize(fuelnum-neednum)
				inst.spacevalue=math.min(uses+neednum*adduse,total)
			else
				inst.spacevalue=math.min(uses+fuelnum*adduse,total)
				material:Remove()
			end
			return true
		end
		inst.changeTarget=function(inst,target)
			inst.space_target=target
			if inst.components.inventoryitem then
				if inst.space_target then
					inst.components.inventoryitem:ChangeImageName(GetMedalSkinData(inst,"medal_space_staff","image").."_bind")
				else
					inst.components.inventoryitem:ChangeImageName(GetMedalSkinData(inst,"medal_space_staff","image"))
				end
			end
		end
		inst.OnSave = function(inst,data)
			if inst.spacevalue then
				data.spacevalue=inst.spacevalue
			end
		end
		inst.OnLoad = function(inst,data)
			if data and data.spacevalue then
				inst.spacevalue=data.spacevalue
			end
		end
		inst.getMedalInfo = function(inst)--显示时空法杖绑定的目标和空间之力
			local targetText=STRINGS.DELIVERYSPEECH.NOSPACETARGET
			if inst.space_target and inst.space_target.components.writeable then
				targetText=inst.space_target.components.writeable:GetText() or STRINGS.DELIVERYSPEECH.NOSPACETARGET
			end
			local str = STRINGS.MEDAL_INFO.BINDTARGET..targetText
			if inst.spacevalue then
				str = str.."\n"..STRINGS.MEDAL_INFO.SPACEVALUE..inst.spacevalue.."/"..TUNING_MEDAL.MEDAL_SPACE_STAFF_MAXVALUE
			end
			return str
		end
	end,
	equipfn=function(inst,owner)--装备扩展函数
		inst:AddTag("changespacetarget")--可切换传送目标
	end,
	unequipfn=function(inst,owner)--卸下扩展函数
		inst:RemoveTag("changespacetarget")
	end,
}

--------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------不朽法杖----------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
--各阶段石化树数据
local STAGE_PETRIFY_DATA =
{
	normal={
		{--小树
			consume=2,--耐久消耗
			prefab="rock_petrified_tree_short",--对应的石化树
			fx="petrified_tree_fx_short",--对应的石化特效
		},
		{--中树
			consume=3,
			prefab="rock_petrified_tree_med",
			fx="petrified_tree_fx_normal",
		},
		{--大树
			consume=4,
			prefab="rock_petrified_tree_tall",
			fx="petrified_tree_fx_tall",
		},
		{--枯树
			consume=2,
			prefab="rock_petrified_tree_old",
			fx="petrified_tree_fx_old",
		},
	},
	--大理石树
	marble={
		{--小树
			consume=3,--耐久消耗
			prefab="marbleshrub_short",--对应的石化树
			fx="petrified_tree_fx_short",--对应的石化特效
		},
		{--中树
			consume=3,
			prefab="marbleshrub_normal",
			fx="petrified_tree_fx_normal",
		},
		{--大树
			consume=3,
			prefab="marbleshrub_tall",
			fx="petrified_tree_fx_tall",
		},
	},
	--硝化树
	nitrify={
		{--小树
			consume=3,--耐久消耗
			prefab="medal_nitrify_tree_short",--对应的石化树
			fx="petrified_tree_fx_short",--对应的石化特效
		},
		{--中树
			consume=4,
			prefab="medal_nitrify_tree_med",
			fx="petrified_tree_fx_normal",
		},
		{--大树
			consume=5,
			prefab="medal_nitrify_tree_tall",
			fx="petrified_tree_fx_tall",
		},
		{--枯树
			consume=3,
			prefab="medal_nitrify_tree_old",
			fx="petrified_tree_fx_old",
		},
	},
}

local immortal_fn_loot={
	{--石化
		testfn=function(target) return (target:HasTag("petrifiable") or target:HasTag("deciduoustree")) and target.components.growable ~= nil and not target:HasTag("stump") end,
		im_spellfn=function(staff,target)
			local stage = target.components.growable.stage or 1--树的级别
			local petrify_loot = target:HasTag("deciduoustree") and STAGE_PETRIFY_DATA.marble or STAGE_PETRIFY_DATA.normal--石化树信息表
			if staff.components.finiteuses and staff.components.finiteuses:GetUses()>=petrify_loot[stage].consume then
				local rock = SpawnPrefab(petrify_loot[stage].prefab)
				if rock then
					local r, g, b = target.AnimState:GetMultColour()
					rock.AnimState:SetMultColour(r, g, b, 1)
					rock.Transform:SetPosition(target.Transform:GetWorldPosition())
					local fx = SpawnPrefab(petrify_loot[stage].fx)
					fx.Transform:SetPosition(target.Transform:GetWorldPosition())
					fx:InheritColour(r, g, b)
					target:Remove()
					staff.components.finiteuses:Use(petrify_loot[stage].consume)
				end
				return true
			end
			return false
		end,
	},
	{--硝化
		testfn=function(target) return target.prefab=="rock_petrified_tree" end,
		im_spellfn=function(staff,target)
			local stage = target.treeSize or 1--树的级别
			local petrify_loot = STAGE_PETRIFY_DATA.nitrify--石化树信息表
			if staff.components.finiteuses and staff.components.finiteuses:GetUses()>=petrify_loot[stage].consume then
				local rock = SpawnPrefab(petrify_loot[stage].prefab)
				if rock then
					-- local r, g, b = target.AnimState:GetMultColour()
					-- rock.AnimState:SetMultColour(r, g, b, 1)
					rock.Transform:SetPosition(target.Transform:GetWorldPosition())
					local fx = SpawnPrefab(petrify_loot[stage].fx)
					fx.Transform:SetPosition(target.Transform:GetWorldPosition())
					-- fx:InheritColour(r, g, b)
					target:Remove()
					staff.components.finiteuses:Use(petrify_loot[stage].consume)
				end
				return true
			end
			return false
		end,
	},
	{--腐烂作物回春术
		testfn=function(target) return target:HasTag("pickable_harvest_str") or target:HasTag("weed") end,
		im_spellfn=function(staff,target)
			local consume=(target.is_oversized or not target:HasTag("farm_plant")) and 10 or 4
			if staff.components.finiteuses and staff.components.finiteuses:GetUses()>=consume then
				if target.components.growable then
					--巨型腐烂作物(长地里的)
					if target.is_oversized then
						local bigPlant=SpawnPrefab(target.prefab)
						if bigPlant then
							bigPlant.Transform:SetPosition(target.Transform:GetWorldPosition())
							bigPlant.force_oversized=true
							for i = 1, 4 do
								bigPlant.components.growable:DoGrowth()
							end
							target:Remove()
							staff.components.finiteuses:Use(consume)
						end
						return true
					--杂草
					elseif target:HasTag("weed") then
						if target.components.growable:GetStage()==4 then
							local newweed=SpawnPrefab(target.prefab)
							if newweed then
								newweed.Transform:SetPosition(target.Transform:GetWorldPosition())
								if newweed.components.growable and newweed.components.growable.domagicgrowthfn then
									newweed.components.growable:DoMagicGrowth()
								end
								target:Remove()
								staff.components.finiteuses:Use(consume)
							end
						end
						return true
					else--普通作物
						if target.components.growable.domagicgrowthfn ~= nil then
							target.components.growable:DoMagicGrowth()
						else
							target.components.growable:DoGrowth()
						end
						staff.components.finiteuses:Use(consume)
						return true
					end
				--巨型腐烂作物(已经采摘过的)
				elseif string.sub(target.prefab,-16,-1)=="oversized_rotten" then
					local bigPlant=SpawnPrefab(string.sub(target.prefab,1,-8))
					if bigPlant then
						bigPlant.Transform:SetPosition(target.Transform:GetWorldPosition())
						SpawnMedalFX("halloween_firepuff_1",target)
						target:Remove()
						staff.components.finiteuses:Use(consume)
					end
					return true
				end
			end
			return false
		end,
	},
	{--时空之塔晶体化
		testfn=function(target) return target.prefab=="medal_block" end,
		im_spellfn=function(staff,target)
			if staff.components.finiteuses and staff.components.finiteuses:GetUses()>=5 then
				if target.OnImmortal then
					target:OnImmortal()
					staff.components.finiteuses:Use(5)
				end
				return true
			end
			return false
		end,
	},
	{--智能陷阱不朽化
		testfn=function(target) return target:HasTag("autoTrap") and not target:HasTag("isimmortal") end,
		im_spellfn=function(staff,target)
			if staff.components.finiteuses and staff.components.finiteuses:GetUses()>=10 then
				if target.setImmortalTrap then
					target:setImmortalTrap()
					SpawnMedalFX("farm_plant_happy",target)
					staff.components.finiteuses:Use(10)
				end
				return true
			end
			return false
		end,
	},
	{--打蜡
		testfn=function(target) return target:HasTag("waxable") end,
		im_spellfn=function(staff,target,caster)
			if staff.components.finiteuses and staff.components.finiteuses:GetUses()>=10 and target.components.waxable and target.components.waxable.waxfn then
				local result, reason = target.components.waxable.waxfn(target,caster,staff)
				if result then
					staff.components.finiteuses:Use(10)
				end
				return result
				-- local waxedveggie = SpawnPrefab(target.prefab.."_waxed")
				-- if waxedveggie then
				-- 	waxedveggie.Transform:SetPosition(target.Transform:GetWorldPosition())
				-- 	waxedveggie.AnimState:PlayAnimation("wax_oversized", false)
				-- 	waxedveggie.AnimState:PushAnimation("idle_oversized")
				-- 	target:Remove()
				-- 	staff.components.finiteuses:Use(10)
				-- end
				-- return true
			end
			return false
		end,
	},
}

--不朽法杖作用目标所需标签
local IMMORTAL_NEED_TAG_LIST={
	"petrifiable",--可石化
	"deciduoustree",--桦树
	"waxable",--可打蜡
	"nitrifyable",--可硝化
	"pickable_harvest_str",--腐烂农作物
	"weed",--杂草
	"canbeglass",--可被晶体化
	"autoTrap",--智能陷阱
}
local IMMORTAL_NO_TAGS = {"INLIMBO", "NOCLICK", "isimmortal"}
--施法函数
local function immortal_func(inst,target,pos,doer,single)
	local caster = doer or inst.components.inventoryitem.owner--施法者
	--对点使用
	if pos then
		local x,y,z = pos:Get()
		local ents = TheSim:FindEntities(x, y, z, TUNING_MEDAL.IMMORTAL_STAFF_RADIUS ,nil, IMMORTAL_NO_TAGS, IMMORTAL_NEED_TAG_LIST)
		SpawnMedalFX("medal_reticule_scale_fx",nil,pos,TUNING_MEDAL.IMMORTAL_STAFF_RADIUS)
		if #ents>0 then
			local need_sigh=true--是否发出感叹词
			for i,v in ipairs(ents) do
				for _,imfn in ipairs(immortal_fn_loot) do
					if imfn.testfn==nil or imfn.testfn(v) then
						if imfn.im_spellfn and imfn.im_spellfn(inst,v,caster) then
							need_sigh=false
							break
						end
					end
				end
			end
			if need_sigh then--发出不朽之力不够了的感叹词
				MedalSay(caster,STRINGS.IMMORTALSPEECH.POWERNOTENOUGH)
			end
		end
	--对单个目标使用
	elseif target then
		local ents
		local targetname=target.prefab--这里要先记录下预置物名，不然会出现中途被捡走导致无法比对的情况
		local need_sigh=true--是否发出感叹词
		--对单个目标施法
		if single then
			ents = {target}
		else--对同种目标施法
			local x,y,z = target.Transform:GetWorldPosition()
			SpawnMedalFX("medal_reticule_scale_fx",target,nil,TUNING_MEDAL.IMMORTAL_STAFF_RADIUS)
			ents = TheSim:FindEntities(x, y, z, TUNING_MEDAL.IMMORTAL_STAFF_RADIUS ,nil, IMMORTAL_NO_TAGS, IMMORTAL_NEED_TAG_LIST)
		end
		--施法
		for i,v in ipairs(ents) do
			if v.prefab == targetname then
				for _,imfn in ipairs(immortal_fn_loot) do
					if imfn.testfn==nil or imfn.testfn(v) then
						if imfn.im_spellfn and imfn.im_spellfn(inst,v,caster) then
							need_sigh=false
							break
						end
					end
				end
			end
		end
		if need_sigh then--发出不朽之力不够了的感叹词
			MedalSay(caster,STRINGS.IMMORTALSPEECH.POWERNOTENOUGH)
		end
	--在装备栏使用
	elseif caster then
		local x,y,z = caster.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, TUNING_MEDAL.IMMORTAL_STAFF_RADIUS ,nil, IMMORTAL_NO_TAGS,IMMORTAL_NEED_TAG_LIST)
		SpawnMedalFX("medal_reticule_scale_fx",caster,nil,TUNING_MEDAL.IMMORTAL_STAFF_RADIUS)
		if #ents>0 then
			local need_sigh=true--是否发出感叹词
			for i,v in ipairs(ents) do
				for _,imfn in ipairs(immortal_fn_loot) do
					if imfn.testfn==nil or imfn.testfn(v) then
						if imfn.im_spellfn and imfn.im_spellfn(inst,v,caster) then
							need_sigh=false
							break
						end
					end
				end
			end
			if need_sigh then--发出不朽之力不够了的感叹词
				MedalSay(caster,STRINGS.IMMORTALSPEECH.POWERNOTENOUGH)
			end
		end
	end
end

--判断是否为有效施法目标
local function immortal_can_cast_fn(doer, target, pos)
	if target==nil then return true end
	for k,v in ipairs(IMMORTAL_NEED_TAG_LIST) do
		if target:HasTag(v) and not target:HasTag("isimmortal") then
			return true
		end
	end
    return false
end

staff_defs.immortal_staff={
	name="immortal_staff",
	animname="immortal_staff",
	taglist={
		"medalquickcastleft",--单目标左键快速施法
		"allow_action_on_impassable"--不可通行区域施法
	},
	medal_repair_common={--可补充耐久
		immortal_essence=TUNING_MEDAL.IMMORTAL_ESSENCE_ADDUSE,--不朽精华
		immortal_fruit=TUNING_MEDAL.IMMORTAL_FRUIT_ADDUSE,--不朽果实
	},
	maxuse=TUNING_MEDAL.IMMORTAL_STAFF_USES,--最大耐久
	onfinishedfn=staff_onfinished,--耐久用完函数
	fxcolour={200/255,132/255,133/255},--施法颜色
	radius=TUNING_MEDAL.IMMORTAL_STAFF_RADIUS,--作用范围
	spellfn=function(inst)--施法函数
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(immortal_func)--石化
		inst.components.spellcaster.canuseontargets = true--对某一个目标使用
		inst.components.spellcaster.canuseonpoint = true--对坐标点使用
		inst.components.spellcaster.canuseonpoint_water = true--船上使用
		inst.components.spellcaster.canusefrominventory = true--在装备栏右键使用
		inst.components.spellcaster:SetCanCastFn(immortal_can_cast_fn)--有效目标函数
	end,
}

--------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------流星法杖----------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
--生成流星(是否为时空矿，召唤者)
local function spawnmet(isglass,caster)
	local met = SpawnPrefab(isglass and "medal_spacetime_lightning" or "shadowmeteor")
	met.METEOR_STAFF_CASTER=caster--给流星挂载召唤者
	return met
end
--判断是否在时空风暴内
local function IsInSpaceTimeStorm(pt)
	return TheWorld.net.components.medal_spacetimestorms ~= nil and TheWorld.net.components.medal_spacetimestorms:IsPointInSpacetimestorm(pt)
end
--流星攻击
local function meteor_onattack(inst, attacker, target, skipsanity)
	if not target:IsValid() then
        return
    end
	if inst.components.finiteuses and inst.components.finiteuses:GetUses() > 0 then
		inst.components.finiteuses:Use(1)
		local met = spawnmet(false,attacker)
		met.Transform:SetPosition(target.Transform:GetWorldPosition())
	end
	
end

--召唤单颗流星
local function call_a_meteor(px,py,pz,caster)
	local theta = math.random() * 2 * PI
	local radius = easing.outSine(math.random(), math.random() * TUNING_MEDAL.METEOR_STAFF_RADIUS, TUNING_MEDAL.METEOR_STAFF_RADIUS, 1)
	local fan_offset = FindValidPositionByFan(theta, radius, 30,
		function(offset)
			return TheWorld.Map:IsPassableAtPoint(px + offset.x, py + offset.y, pz + offset.z)
		end) or Vector3(0,0,0)
	local met = spawnmet(false,caster)
	met.Transform:SetPosition(px + fan_offset.x, py + fan_offset.y, pz + fan_offset.z)
end

--召唤流星雨
local function call_meteor_func(inst,target,pos,doer)
	local caster = doer or inst.components.inventoryitem.owner--施法者
	local num_meteor = math.random(15,30)--流星数量
	--对点使用
	if pos then
		local isglass = IsInSpaceTimeStorm(pos)
		if isglass and inst.components.finiteuses:GetUses() < 20 then
			MedalSay(caster,STRINGS.MEDALMETEORSTAFFSPEECH.POWERNOTENOUGH)
			return
		end
		local met = spawnmet(isglass,caster)
		met.Transform:SetPosition(pos:Get())
		inst.components.finiteuses:Use(math.min(inst.components.finiteuses:GetUses(),isglass and 20 or 1))
	--对单个目标使用
	elseif target then
		local pt = Vector3(target.Transform:GetWorldPosition())
		local isglass = IsInSpaceTimeStorm(pt)
		if isglass and inst.components.finiteuses:GetUses() < 20 then
			MedalSay(caster,STRINGS.MEDALMETEORSTAFFSPEECH.POWERNOTENOUGH)
			return
		end
		local met = spawnmet(isglass,caster)
		met.Transform:SetPosition(pt:Get())
		inst.components.finiteuses:Use(math.min(inst.components.finiteuses:GetUses(),isglass and 20 or 1))
	--在装备栏使用
	elseif caster then
		if inst.components.finiteuses:GetUses() < 20 then
			MedalSay(caster,STRINGS.MEDALMETEORSTAFFSPEECH.POWERNOTENOUGH)
			return
		end
		local px,py,pz = caster.Transform:GetWorldPosition()
		local isglass = IsInSpaceTimeStorm(Vector3(px,py,pz))
		if isglass then
			local met = spawnmet(true,caster)
			met.Transform:SetPosition(px,py,pz)
		else
			caster:StartThread(function()
				for k = 0, num_meteor-1 do
					call_a_meteor(px,py,pz,caster)
					Sleep(.3 + math.random() * .2)
				end
			end)
		end
		inst.components.finiteuses:Use(math.min(inst.components.finiteuses:GetUses(),20))
	end
end

staff_defs.meteor_staff={
	name="meteor_staff",
	animname="meteor_staff",
	taglist={
		"meteor_protection",--不会被流星砸坏
		"medalposquickcast",--对目标点快速施法
		"medal_skinable",--可换皮肤
	},
	medal_repair_common={--可补充耐久
		moonrocknugget=TUNING_MEDAL.METEOR_MEDAL_ADDUSE,--月岩
	},
	maxuse=TUNING_MEDAL.METEOR_STAFF_USES,--最大耐久
	onfinishedfn=staff_onfinished,--耐久用完函数
	fxcolour={200/255,132/255,133/255},--施法颜色
	spellfn=function(inst)--施法函数
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(call_meteor_func)--召唤流星雨
		inst.components.spellcaster.canuseonpoint = true--对坐标点使用
		inst.components.spellcaster.canusefrominventory = true--在装备栏右键使用
	end,
	extrafn=function(inst)--扩展函数
		inst.components.weapon:SetDamage(0)
		inst.components.weapon:SetRange(15, 16)
		inst.components.weapon:SetOnAttack(meteor_onattack)
		inst.components.weapon.attackwear=0--攻击消耗耐久
		-- inst.components.weapon:SetProjectile("fire_projectile")
		inst:AddComponent("medal_skinable")
	end,
}

--------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------风花雪月----------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------

---------撒币---------
--更新影子尺寸
local UpdateShadowSize = function(shadow, height)
    local scaleFactor = Lerp(.5, 1.5, height / 35)
    shadow.Transform:SetScale(scaleFactor, scaleFactor, scaleFactor)
end
--移除的时候顺便移除阴影
local OnRemoveDebris = function(debris)
    debris.shadow:Remove()
end
--血汗钱炸裂
local _BreakDebris = function(debris)
    local x, y, z = debris.Transform:GetWorldPosition()
    -- SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(x, 0, z)
    SpawnPrefab("fx_dock_pop").Transform:SetPosition(x, y, z)
    debris:Remove()
end

local SMASHABLE_TAGS = { "smashable", "_combat" }
local NON_SMASHABLE_TAGS = { "INLIMBO", "playerghost", "irreplaceable", "outofreach" }
--更新高度状态
local _GroundDetectionUpdate = function(debris)
    local x, y, z = debris.Transform:GetWorldPosition()
    if y <= .2 then
        if not debris:IsOnValidGround() then
            debris:PushEvent("detachchild")
            debris:Remove()
        elseif TheWorld.Map:IsPointNearHole(Vector3(x, 0, z)) then
            _BreakDebris(debris)
        else
            local softbounce = false
            local ents = TheSim:FindEntities(x, 0, z, 2, nil, NON_SMASHABLE_TAGS, SMASHABLE_TAGS)
            for i, v in ipairs(ents) do
                if v ~= debris and v:IsValid() and not v:IsInLimbo() then
                    softbounce = true
					if v.components.combat ~= nil and not v:HasTag("wall") then
                        v.components.combat:GetAttacked(debris, TUNING_MEDAL.MEDAL_SKIN_STAFF_DAMAGE, nil)
						v:AddDebuff("buff_medal_malaise","buff_medal_malaise")
                    end
                end
            end

            debris.Physics:SetDamping(.9)

            if softbounce then
                local speed = 3.2 + math.random()
                local angle = math.random() * 2 * PI
                debris.Physics:SetMotorVel(0, 0, 0)
                debris.Physics:SetVel(
                    speed * math.cos(angle),
                    speed * 2.3,
                    speed * math.sin(angle)
                )
            end

            debris.shadow:Remove()
            debris.shadow = nil

            debris.updatetask:Cancel()
            debris.updatetask = nil

            if debris:GetTimeAlive() < 1.5 then
                debris:DoTaskInTime(softbounce and 0 or .1, _BreakDebris)
            else
                _BreakDebris(debris)
            end
        end
    elseif debris:GetTimeAlive() < 3 then
        if y < 2 then
            debris.Physics:SetMotorVel(0, 0, 0)
        end
		if y==debris._lasty then
			_BreakDebris(debris)
		else
			debris._lasty=y
       		UpdateShadowSize(debris.shadow, y)
		end
    elseif debris:IsInLimbo() then
        --failsafe, but maybe we got trapped or picked up somehow, so keep it
        debris.persists = true
        debris.entity:SetCanSleep(true)
        debris.shadow:Remove()
        debris.shadow = nil
        debris.updatetask:Cancel()
        debris.updatetask = nil
        if debris._restorepickup then
            debris._restorepickup = nil
            if debris.components.inventoryitem ~= nil then
                debris.components.inventoryitem.canbepickedup = true
            end
        end
        debris:PushEvent("stopfalling")
    else
        --failsafe
        _BreakDebris(debris)
    end
end
--撒币(坐标)
local function SpawnMoney(spawn_point)
    local debris = SpawnPrefab("toil_money")
	local height = 20
    if debris ~= nil then
        debris.entity:SetCanSleep(false)
        debris.persists = false
        if debris.components.inventoryitem ~= nil and debris.components.inventoryitem.canbepickedup then
            debris.components.inventoryitem.canbepickedup = false
            debris._restorepickup = true
        end
        -- if math.random() < .5 then
        --     debris.Transform:SetRotation(180)
        -- end
		debris.AnimState:PlayAnimation("drop")
        debris.Physics:Teleport(spawn_point.x, height, spawn_point.z)

        debris.shadow = SpawnPrefab("warningshadow")
        debris.shadow:ListenForEvent("onremove", OnRemoveDebris, debris)
        debris.shadow.Transform:SetPosition(spawn_point.x, 0, spawn_point.z)
        UpdateShadowSize(debris.shadow, height)

        debris.updatetask = debris:DoPeriodicTask(FRAMES, _GroundDetectionUpdate)
        debris:PushEvent("startfalling")
    end
    return debris
end

--血汗钱攻击
local function skin_onattack(inst, attacker, target, skipsanity)
	if not target:IsValid() then
        return
    end
	if inst.components.finiteuses and inst.components.finiteuses:GetUses() >= 10 then
		inst.components.finiteuses:Use(10)
		SpawnMoney(target:GetPosition())
	end
end

staff_defs.medal_skin_staff={
	name="medal_skin_staff",
	animname="medal_skin_staff",
	taglist={
		"medalquickcast",--单目标快速施法
		"medal_skinable",--可换皮肤
	},
	maxuse=TUNING_MEDAL.MEDAL_SKIN_STAFF_USES,--最大耐久
	onfinishedfn=staff_onfinished,--耐久用完函数
	fxcolour={73/255,120/255,81/255},--施法颜色
	spellfn=function(inst)--施法函数
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(function(inst,target,pos,doer)
			local caster = doer or inst.components.inventoryitem.owner--施法者
			local change_target = (target and target == caster) and inst or target--如果是对玩家自己使用，则是给风花雪月换皮肤
			if change_target and change_target.components.medal_skinable then
				local result,nouse = change_target.components.medal_skinable:ChangeSkin(inst, caster, inst.skin_target==change_target)
				if result then
					inst.skin_target = change_target
					if inst.components.rechargeable then
						inst.components.rechargeable:Discharge(TUNING_MEDAL.MEDAL_SKIN_STAFF_CD)--免费换肤CD
					end
					if change_target == inst then--切换下手持动画
						caster.AnimState:OverrideSymbol("swap_object", GetMedalSkinData(inst,"medal_skin_staff"), "swap_medal_skin_staff")
					end
				else
					MedalSay(caster, STRINGS.MEDALSKINSTAFFSPEECH[nouse and "RUNOUT" or "NOSKIN"])
				end
			end
		end)--换皮肤
		inst.components.spellcaster.canuseontargets = true--对某一个目标使用
		inst.components.spellcaster:SetCanCastFn(function(doer, target, pos)
			if target and (target:HasTag("medal_skinable") or target==doer) then
				return true
			end
			return false
		end)--有效目标函数
	end,
	client_extrafn=function(inst)--客户端扩展函数
		inst.skin_money = net_shortint(inst.GUID, "skin_money")--皮肤币
		inst.skin_str = net_string(inst.GUID, "skin_str")--已解锁的皮肤数据
		--购买皮肤函数(inst,预制物名,皮肤ID,价格)
		inst.buy_skin_client = function(inst,skinname,skinid,price)
			if TheWorld.ismastersim then
				if inst.buy_skin then
					inst:buy_skin(skinname,skinid,price)
				end
			else
				SendModRPCToServer(MOD_RPC.functional_medal.BuySkin, inst, skinname, skinid, price)
			end
		end
	end,
	extrafn=function(inst)--扩展函数
		inst:AddComponent("medal_skinable")--可换皮肤
		inst.components.weapon:SetDamage(0)
		inst.components.weapon:SetRange(15, 16)
		inst.components.weapon:SetOnAttack(skin_onattack)
		inst.components.weapon.attackwear=0--攻击消耗耐久
		inst.skin_data={--已解锁的皮肤数据
			--medal_statue_marble_gugugu={1},--格式
		}
		inst.buy_skin=function(inst,skinname,skinid,price)
			if inst.components.finiteuses and inst.components.finiteuses:GetUses()>= price then
				if inst.skin_data then
					local result=false--购买结果
					if inst.skin_data[skinname] then
						if not table.contains(inst.skin_data[skinname],skinid) then
							inst.skin_data[skinname][#inst.skin_data[skinname]+1]=skinid
							result=true
						end
					else
						inst.skin_data[skinname]={skinid}
						result=true
					end
					if result then
						inst.components.finiteuses:Use(price)
						--给客户端同步皮肤解锁数据
						if inst.skin_data and inst.skin_str then
							local info_str=json.encode(inst.skin_data)
							inst.skin_str:set(info_str)
						end
					end
					return result
				end
			end
		end
		inst:AddComponent("rechargeable")
		--防止别的mod用覆盖法导致函数调用不到炸档
		if inst.components.rechargeable.SetOnChargedFn then
			inst.components.rechargeable:SetOnChargedFn(function(inst)
				--结束CD
				inst.skin_target=nil--移除绑定的目标
			end)
		end
		inst.OnBuilt=function(inst)
			if inst.components.finiteuses then
				inst.components.finiteuses:SetUses(TUNING_MEDAL.MEDAL_SKIN_STAFF_ADDUSE*6)--设定初始耐久(首充的钱)
			end
		end
		inst:DoTaskInTime(0,function()
			--同步货币数据
			if inst.components.finiteuses and inst.skin_money then
				inst.skin_money:set(inst.components.finiteuses:GetUses())
			end
			--同步皮肤解锁数据
			if inst.skin_data and inst.skin_str then
				local info_str=json.encode(inst.skin_data)
				inst.skin_str:set(info_str)
			end
		end)
		inst.OnSave = function(inst,data)
			if inst.skin_data then
				data.skin_data=deepcopy(inst.skin_data)
			end
		end
		inst.OnLoad = function(inst,data)
			if data and data.skin_data then
				inst.skin_data=deepcopy(data.skin_data)
			end
		end
		--监听耐久(货币)变化
		inst.percentusedchangefn = function(inst,data)
			--同步货币数据
			if inst.components.finiteuses and inst.skin_money then
				inst.skin_money:set(inst.components.finiteuses:GetUses())
			end
		end
		inst:ListenForEvent("percentusedchange", inst.percentusedchangefn)
	end,
	equipfn=function(inst,owner)--装备扩展函数
		inst:AddTag("openskinpage")--可打开皮肤界面
	end,
	unequipfn=function(inst,owner)--卸下扩展函数
		inst:RemoveTag("openskinpage")
	end,
}

--------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------月光法杖----------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
--装饰性变异
local decor_change_loot = {
	--树枝
	sapling="sapling_moon",
	sapling_moon="sapling",
	--浆果丛
	berrybush="berrybush2",
	berrybush2="berrybush",
	--仙人掌
	cactus="oasis_cactus",
	oasis_cactus="cactus",
	--花、恶魔花、月石花
	flower="flower",
	flower_evil="flower_evil",
	moonrock_pieces="moonrock_pieces",
	--常青树、粗壮常青树
	evergreen="evergreen_sparse",
	evergreen_sparse="evergreen",
	--大理石树
	marbletree="marbletree",
	marbletree_1="marbletree_2",
	marbletree_2="marbletree_3",
	marbletree_3="marbletree_4",
	marbletree_4="marbletree_1",
	--多肉、蕨类盆栽
	succulent_potted="succulent_potted",
	pottedfern="pottedfern",
	--打蜡作物
	farm_plant_asparagus_waxed="farm_plant_garlic_waxed",
	farm_plant_garlic_waxed="farm_plant_pumpkin_waxed",
	farm_plant_pumpkin_waxed="farm_plant_corn_waxed",
	farm_plant_corn_waxed="farm_plant_onion_waxed",
	farm_plant_onion_waxed="farm_plant_potato_waxed",
	farm_plant_potato_waxed="farm_plant_dragonfruit_waxed",
	farm_plant_dragonfruit_waxed="farm_plant_pomegranate_waxed",
	farm_plant_pomegranate_waxed="farm_plant_eggplant_waxed",
	farm_plant_eggplant_waxed="farm_plant_tomato_waxed",
	farm_plant_tomato_waxed="farm_plant_watermelon_waxed",
	farm_plant_watermelon_waxed="farm_plant_pepper_waxed",
	farm_plant_pepper_waxed="farm_plant_durian_waxed",
	farm_plant_durian_waxed="farm_plant_carrot_waxed",
	farm_plant_carrot_waxed="farm_plant_immortal_fruit_waxed",
	farm_plant_immortal_fruit_waxed="farm_plant_medal_gift_fruit_waxed",
	farm_plant_medal_gift_fruit_waxed="farm_plant_asparagus_waxed",
	--巨型打蜡作物
	asparagus_oversized_waxed="garlic_oversized_waxed",
	garlic_oversized_waxed="pumpkin_oversized_waxed",
	pumpkin_oversized_waxed="corn_oversized_waxed",
	corn_oversized_waxed="onion_oversized_waxed",
	onion_oversized_waxed="potato_oversized_waxed",
	potato_oversized_waxed="dragonfruit_oversized_waxed",
	dragonfruit_oversized_waxed="pomegranate_oversized_waxed",
	pomegranate_oversized_waxed="eggplant_oversized_waxed",
	eggplant_oversized_waxed="tomato_oversized_waxed",
	tomato_oversized_waxed="watermelon_oversized_waxed",
	watermelon_oversized_waxed="pepper_oversized_waxed",
	pepper_oversized_waxed="durian_oversized_waxed",
	durian_oversized_waxed="carrot_oversized_waxed",
	carrot_oversized_waxed="immortal_fruit_oversized_waxed",
	immortal_fruit_oversized_waxed="medal_gift_fruit_oversized_waxed",
	medal_gift_fruit_oversized_waxed="asparagus_oversized_waxed",
	--前辈
	skeleton="skeleton",
	--贝壳钟
	singingshell_octave3="singingshell_octave4",
	singingshell_octave4="singingshell_octave5",
	singingshell_octave5="singingshell_octave3",
	--恶液箱,变透明
	gelblob_storage = function(inst)
		inst.medal_invisible = not inst.medal_invisible
		if inst.medal_SetInvisible then
			inst:medal_SetInvisible()
		end
	end,
}

--功能性变异
local function_change_loot = {
	--多枝树变树枝
	twiggytree="sapling",
	sapling="twiggytree",
	sapling_moon="twiggytree",
	--松果、多枝树果
	pinecone="twiggy_nut",
	twiggy_nut="pinecone",
	--浆果丛
	berrybush_juicy="berrybush",
	berrybush="berrybush_juicy",
	berrybush2="berrybush_juicy",
	--月蛾、蝴蝶
	butterfly="moonbutterfly",
	moonbutterfly="butterfly",
	--蜜蜂、杀人蜂
	bee="killerbee",
	killerbee="bee",
	--花、恶魔花、月石花
	flower="flower_evil",
	flower_evil="moonrock_pieces",
	moonrock_pieces="flower",
	--企鹅、月石企鹅
	penguin="mutated_penguin",
	mutated_penguin="penguin",
	--芦苇、猴尾草
	reeds="monkeytail",
	monkeytail="reeds",
	--鸟
	robin="robin_winter",
	robin_winter="crow",
	crow="puffin",
	puffin="canary",
	canary="bird_mutant",
	bird_mutant="bird_mutant_spitter",
	bird_mutant_spitter="robin",
	--四种狗
	hound="firehound",
	firehound="icehound",
	icehound="mutatedhound",
	mutatedhound="hound",
	--火龙果、沙拉蝾螈
	fruitdragon="dragonfruit",
	dragonfruit="fruitdragon",
	--草、草蜥蜴
	grassgekko="grass",
	grass="grassgekko",
	--胡萝卜、胡萝卜鼠
	carrot="carrat",
	carrat="carrot",
	carrot_planted="carrat_planted",
	carrat_planted="carrot_planted",
	--多肉、蕨类盆栽
	succulent_potted="pottedfern",
	pottedfern="succulent_potted",
}
--随机变异列表
local random_change_loot = {
	--巨型果实
	--常见100%
	carrot_oversized="medal_fruit_tree_carrot_scion",
	corn_oversized="medal_fruit_tree_corn_scion",
	potato_oversized="medal_fruit_tree_potato_scion",
	tomato_oversized="medal_fruit_tree_tomato_scion",
	--不常见75%
	asparagus_oversized=function(inst)
		return math.random()<.75 and "medal_fruit_tree_asparagus_scion" or "asparagus_oversized_rotten"
	end,
	pumpkin_oversized=function(inst)
		return math.random()<.75 and "medal_fruit_tree_pumpkin_scion" or "pumpkin_oversized_rotten"
	end,
	eggplant_oversized=function(inst)
		return math.random()<.75 and "medal_fruit_tree_eggplant_scion" or "eggplant_oversized_rotten"
	end,
	watermelon_oversized=function(inst)
		return math.random()<.75 and "medal_fruit_tree_watermelon_scion" or "watermelon_oversized_rotten"
	end,
	--稀有50%
	garlic_oversized=function(inst)
		return math.random()<.5 and "medal_fruit_tree_garlic_scion" or "garlic_oversized_rotten"
	end,
	onion_oversized=function(inst)
		return math.random()<.5 and "medal_fruit_tree_onion_scion" or "onion_oversized_rotten"
	end,
	dragonfruit_oversized=function(inst)
		return math.random()<.5 and "medal_fruit_tree_dragonfruit_scion" or "dragonfruit_oversized_rotten"
	end,
	pomegranate_oversized=function(inst)
		return math.random()<.5 and "medal_fruit_tree_pomegranate_scion" or "pomegranate_oversized_rotten"
	end,
	pepper_oversized=function(inst)
		return math.random()<.5 and "medal_fruit_tree_pepper_scion" or "pepper_oversized_rotten"
	end,
	durian_oversized=function(inst)
		return math.random()<.5 and "medal_fruit_tree_durian_scion" or "durian_oversized_rotten"
	end,
	lucky_fruit_oversized=function(inst)
		return math.random()<.5 and "medal_fruit_tree_lucky_fruit_scion" or "lucky_fruit_oversized_rotten"
	end,
	--不朽果实
	immortal_fruit_oversized=function(inst)
		return GetMedalRandomItem(TUNING_MEDAL.IMMORTAL_FRUIT_VARIATION_ROOT,inst)--冥冥之中已有定数
	end,
}

--施法函数
local function moonlight_func(inst,target,pos,doer,left)
	if target == nil then return end--仅对单个目标使用
	local caster = doer or inst.components.inventoryitem.owner--施法者
	local newitem_code = nil
	local consume_value = 2--耐久消耗
	
	--左键施法(装饰性变异)
	if left then
		newitem_code = decor_change_loot[target.prefab]
	else--右键施法(功能性变异)
		consume_value = 5
		--各种巨型作物
		if random_change_loot[target.prefab] then
			newitem_code=FunctionOrValue(random_change_loot[target.prefab],target)
			consume_value = TUNING_MEDAL.MEDAL_MOONLIGHT_STAFF_ADDUSE
		elseif function_change_loot[target.prefab] then
			newitem_code = function_change_loot[target.prefab]
		end
	end
	--无法生成
	if newitem_code == nil then
		MedalSay(caster,STRINGS.MEDAL_MOONLIGHT_SPEECH.CANT)
		return
	end
	--CD期间换同一个目标不消耗耐久
	if inst.change_target == target and inst.medal_spell_left == left then
		consume_value=0
	end
	--耐久不够
	if inst.components.finiteuses == nil or inst.components.finiteuses:GetUses() < consume_value then
		MedalSay(caster,STRINGS.MEDAL_MOONLIGHT_SPEECH.NOTENOUGH)
		return 
	end

	if type(newitem_code) == "function" then
		newitem_code(target)
		if inst.components.rechargeable then--进入CD
			inst.change_target = target--绑定新目标
			inst.medal_spell_left = left--左键施法记录
			inst.components.rechargeable:Discharge(TUNING_MEDAL.MEDAL_SKIN_STAFF_CD)
		end
		inst.components.finiteuses:Use(consume_value)
		SpawnMedalFX("halloween_moonpuff",target)--特效
	else
		local newitem = SpawnPrefab(newitem_code)
		if newitem ~= nil then
			if inst.components.rechargeable then--进入CD
				inst.change_target = newitem--绑定新目标
				inst.medal_spell_left = left--左键施法记录
				inst.components.rechargeable:Discharge(TUNING_MEDAL.MEDAL_SKIN_STAFF_CD)
			end
			inst.components.finiteuses:Use(consume_value)
			newitem.Transform:SetPosition(target.Transform:GetWorldPosition())
			SpawnMedalFX("halloween_moonpuff",target)--特效
			--让植物状态保持一致性
			if target.components.pickable and newitem.components.pickable then
				--失肥
				if target.components.pickable:CanBeFertilized() and newitem.prefab~="reeds" then
					newitem.components.pickable:MakeBarren()
				--置空
				elseif not target.components.pickable.canbepicked then
					newitem.components.pickable:MakeEmpty()
				end
				--保留移植标记
				if target.components.pickable.transplanted then
					newitem.components.pickable.transplanted=true
					if newitem.prefab~="monkeytail" and (target:HasTag("medal_transplant") or target.prefab=="monkeytail") then
						newitem.components.pickable.cycles_left=nil--取消采摘次数上限
						if newitem.components.workable then
							newitem.components.workable:SetWorkAction(ACTIONS.MEDALNORMALTRANSPLANT)
						end
						newitem:RemoveTag("cantdestroy")
					end
				end
			end
			--成长状态保持原状
			if target.components.growable and newitem.components.growable then
				if target.components.growable.stage and newitem.components.growable.stage then
					newitem.components.growable:SetStage(target.components.growable.stage)
				end
			end
			--让生物的血量百分比保持一致性
			if target.components.health ~= nil and newitem.components.health ~= nil then
				newitem.components.health:SetPercent(target.components.health:GetPercent())
			end
			--打蜡作物继承变异前的阶段
			if target:HasTag("waxedplant") and target.savedata and newitem.Configure then
				newitem:Configure({anim = target.savedata.anim})
			end
			
			if target.components.stackable ~= nil and target.components.stackable:IsStack() then
				target.components.stackable:Get():Remove()
			else
				target:Remove()
			end
		end
	end
end

--判断是否为有效施法目标
local function moonlight_can_cast_fn(doer, target, pos)
	if target == nil
		or (not target:HasTag("flying") and not TheWorld.Map:IsPassableAtPoint(target.Transform:GetWorldPosition()))
		or (target.components.burnable ~= nil and (target.components.burnable:IsBurning() or target.components.burnable:IsSmoldering()))
		or (target.components.freezable ~= nil and target.components.freezable:IsFrozen())
		or (target.components.equippable ~= nil and target.components.equippable:IsEquipped()) then
		return false
	end
	return decor_change_loot[target.prefab] ~= nil or function_change_loot[target.prefab] ~= nil or random_change_loot[target.prefab] ~= nil
    -- return true
end

staff_defs.medal_moonlight_staff={
	name="medal_moonlight_staff",
	animname="medal_moonlight_staff",
	taglist={
		"medalquickcast",--单目标快速施法
		"medalquickcastleft",--单目标左键快速施法
	},
	medal_repair_common={--可补充耐久
		medal_moonglass_potion=TUNING_MEDAL.MEDAL_MOONLIGHT_STAFF_ADDUSE,--月光药水
	},
	maxuse=TUNING_MEDAL.MEDAL_MOONLIGHT_STAFF_MAXUSES,--最大耐久
	onfinishedfn=staff_onfinished,--耐久用完函数
	fxcolour={200/255,132/255,133/255},--施法颜色
	radius=TUNING_MEDAL.IMMORTAL_STAFF_RADIUS,--作用范围
	spellfn=function(inst)--施法函数
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(moonlight_func)--变异
		inst.components.spellcaster.canuseontargets = true--对某一个目标使用
		-- inst.components.spellcaster.canuseonpoint = true--对坐标点使用
		-- inst.components.spellcaster.canuseonpoint_water = true--船上使用
		-- inst.components.spellcaster.canusefrominventory = true--在装备栏右键使用
		inst.components.spellcaster:SetCanCastFn(moonlight_can_cast_fn)--有效目标函数
	end,
	extrafn=function(inst)--扩展函数
		inst:AddComponent("rechargeable")
		if inst.components.rechargeable.SetOnChargedFn then--防止别的mod用覆盖法导致函数调用不到炸档
			inst.components.rechargeable:SetOnChargedFn(function(inst)
				--结束CD
				inst.change_target = nil--移除绑定的目标
				inst.medal_spell_left = nil--清空左键施法记录
			end)
		end
		inst.OnBuilt=function(inst)
			if inst.components.finiteuses then
				inst.components.finiteuses:SetUses(TUNING_MEDAL.MEDAL_MOONLIGHT_STAFF_ADDUSE)--设定初始耐久
			end
		end
	end,
}


--定义法杖
local function MakeStaff(def)
	local assets ={
		Asset("ANIM", "anim/"..def.animname..".zip"),
		Asset("ANIM", "anim/floating_items.zip"),
		Asset("ATLAS", "images/"..def.name..".xml"),
		Asset("ATLAS_BUILD", "images/"..def.name..".xml",256),
	}
	
	--装备
	local function onequip(inst, owner)
		owner.AnimState:OverrideSymbol("swap_object", GetMedalSkinData(inst,def.animname), "swap_"..def.animname)
		owner.AnimState:Show("ARM_carry")
		owner.AnimState:Hide("ARM_normal")
		if def.equipfn then
			def.equipfn(inst,owner)
		end
	end
	--卸下
	local function onunequip(inst, owner)
		owner.AnimState:Hide("ARM_carry")
		owner.AnimState:Show("ARM_normal")
		if def.unequipfn then
			def.unequipfn(inst,owner)
		end
	end
	--初始化
	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)

		inst.AnimState:SetBank(def.animname)
		inst.AnimState:SetBuild(def.animname)
		inst.AnimState:PlayAnimation(def.animname)

		inst:AddTag("weapon")
		
		if def.taglist and #def.taglist>0 then
			for _,v in ipairs(def.taglist) do
				inst:AddTag(v)
			end
		end

		local floater_swap_data =
		{
			sym_build = def.animname,
			sym_name = "swap_"..def.animname,
			bank = def.animname,
			anim = def.animname
		}
		MakeInventoryFloatable(inst, "med", 0.1, {0.9, 0.4, 0.9}, true, -13, floater_swap_data)
		
		inst.medal_show_radius = def.radius
		inst.medal_repair_common = def.medal_repair_common
		
		inst.entity:SetPristine()

		--客户端扩展函数
		if def.client_extrafn then
			def.client_extrafn(inst)
		end

		if not TheWorld.ismastersim then
			return inst
		end
		
		inst:AddComponent("weapon")
		inst.components.weapon:SetDamage(TUNING.CANE_DAMAGE)

		inst:AddComponent("inspectable")

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = def.name
		inst.components.inventoryitem.atlasname = "images/"..def.name..".xml"

		inst:AddComponent("equippable")
		inst.components.equippable:SetOnEquip(onequip)
		inst.components.equippable:SetOnUnequip(onunequip)
		
		inst.fxcolour = def.fxcolour or {73/255,120/255,81/255}
		--施法函数
		if def.spellfn then
			def.spellfn(inst)
			inst.OnSpellCasterFn=def.spellfn--挂载施法函数，方便后续调用
		end
		--耐久组件
		if def.maxuse then
			inst:AddComponent("finiteuses")
			inst.components.finiteuses:SetOnFinished(def.onfinishedfn or inst.Remove)
			inst.components.finiteuses:SetMaxUses(def.maxuse)
			inst.components.finiteuses:SetUses(def.maxuse)
			inst.maxuse=def.maxuse
			inst:ListenForEvent("percentusedchange", function(inst,data)
				if data and data.percent then
					--耐久用完后补充耐久
					if data.percent>0 and inst.components.spellcaster==nil then
						def.spellfn(inst)
					end
				end
			end)
		end
		--扩展函数
		if def.extrafn then
			def.extrafn(inst)
		end

		MakeHauntableLaunch(inst)

		return inst
	end

	return Prefab(def.name, fn, assets)
end

local medal_staffs={}
for i, v in pairs(staff_defs) do
    table.insert(medal_staffs, MakeStaff(v))
end
return unpack(medal_staffs)
