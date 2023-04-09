local easing = require("easing")

----------------------------------------公用函数------------------------------------------
--耐久用完移除施法组件
local function staff_onfinished(inst)
    if inst.components.spellcaster~=nil then
		inst:RemoveComponent("spellcaster")
	end
end
--播放特效
local function spawnFX(fx,target,x,y,z)
	if TUNING.SHOW_MEDAL_FX then
		if target then
			SpawnPrefab(fx).Transform:SetPosition(target.Transform:GetWorldPosition())
		else
			SpawnPrefab(fx).Transform:SetPosition(x,y,z)
		end
	end
end

----------------------------------------吞噬法杖------------------------------------------
--诱饵
local baits_list={
	"powcake",--火药饼
	"winter_food4",--水果蛋糕
	"mandrake",--曼德拉草
}
--判断诱饵是否围在墙内
local function isInsideWall(item)
	if not table.contains(baits_list,item.prefab) then
		return false
	end
	local x,y,z = item.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x,y,z,2,{"wall"},{"INLIMBO"})
	local wallNum = 0
	for i, v in ipairs(ents) do
		if v.components.health then
			wallNum = wallNum + 1 
		end 
	end
	return wallNum>=5
end
--是否是蜂箱边上的花
local function isHoneyFlower(item)
	if item:HasTag("flower") then
		local x,y,z = item.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x,y,z,6,{"beebox"},{"INLIMBO"})
		if ents and #ents>0 then
			return true
		end
	end
	return false
end
--计算饱食消耗(玩家,物品,计数)
local function getHungerLoss(player,item,count)
	local distance=math.sqrt(player:GetDistanceSqToInst(item))--吞噬距离
	return (distance/4)*count*TUNING_MEDAL.DEVOUR_STAFF_SANITY_MULT--吞噬消耗
end

--拾取物品(物品,玩家,是否针对单个目标)
local function pickitem(inst,item,player,single)
	local hungerLoss=0--饱食消耗
	if not single then
		local nopick_list={--白名单物品
			mandrake_planted=true,--曼德拉草
			medal_wormwood_flower=true,--虫木花
		}
		--如果是白名单物品，不捡
		if nopick_list[item.prefab] then
			return hungerLoss
		end
		--如果是围在墙内的诱饵就不捡
		if isInsideWall(item) then
			return hungerLoss
		end
		--如果是部署好的陷阱则不捡
		if item:HasTag("trap") and item.components.inventoryitem and item.components.inventoryitem.nobounce then
			return hungerLoss
		end
		--如果是布置类的陷阱，在布置好的情况下不捡
		if item.components.trap and item.components.trap.isset then
			return hungerLoss
		end
	end
	if player~=nil and player.components.inventory~=nil then
		---------------挖取木桩----------------
		if player.large_chop and item:HasTag("stump") and not inst.space_target then
			--树桩产物表
			local treelist={
				livingtree_halloween="livinglog",--万圣节活木树
				livingtree="livinglog",--活木树
				driftwood_tall="driftwood_log",--浮木树
				medal_fruit_tree_stump="medaldug_fruit_tree_stump",--砧木桩
			}
			local logname="log"
			--根据不同树桩给不同木头，桦木树比较特殊需要特殊判断
			if item.prefab=="deciduoustree" and item.monster then
				logname="livinglog"
			elseif treelist[item.prefab] then
				logname=treelist[item.prefab]
			end
			hungerLoss=getHungerLoss(player,item,TUNING_MEDAL.DEVOUR_STAFF_HARVEST_COUNT)
			spawnFX("spawn_fx_tiny",item)
			local logitem=SpawnPrefab(logname)
			if (item.prefab=="moon_tree" or item.prefab=="palmconetree") and item.size ~= "short" then
				if logitem.components.stackable then
					logitem.components.stackable:SetStackSize(2)
				end
			end
			player.components.inventory:GiveItem(logitem)
			item:Remove()
			--植物人额外多消耗2点精神值
			-- if player.prefab=="wormwood" then
			-- 	hungerLoss = hungerLoss+2
			-- end
			return hungerLoss
		end
		-----------------------丰收勋章采集、收获资源-------------------------
		if player.quickpickmedal and not inst.space_target then
			--采集
			if item:HasTag("pickable") and item.components.pickable then
				--范围采集的时候不采集蜂箱边上的花
				if isHoneyFlower(item) and not single then
					return hungerLoss
				end
				hungerLoss=getHungerLoss(player,item,TUNING_MEDAL.DEVOUR_STAFF_HARVEST_COUNT)
				spawnFX("spawn_fx_tiny",item)
				if item.prefab=="tumbleweed" and player.components.lucky~=nil then
					player.components.lucky:DoDelta(-(TUNING.GAME_LEVEL or 1))--额外扣除幸运值
				end
				item.components.pickable:Pick(player)
				return hungerLoss
			end
			--蘑菇农场、蜂箱等
			if item.components.harvestable then
				hungerLoss=getHungerLoss(player,item,TUNING_MEDAL.DEVOUR_STAFF_HARVEST_COUNT)
				spawnFX("spawn_fx_small",item)
				item.components.harvestable:Harvest(player)
				return hungerLoss
			end
			--农作物
			if item.components.crop then
				hungerLoss=getHungerLoss(player,item,TUNING_MEDAL.DEVOUR_STAFF_HARVEST_COUNT)
				spawnFX("spawn_fx_tiny",item)
				item.components.crop:Harvest(player)
				return hungerLoss
			end
			--锅
			if item.components.stewer then
				hungerLoss=getHungerLoss(player,item,TUNING_MEDAL.DEVOUR_STAFF_HARVEST_COUNT)
				spawnFX("spawn_fx_small_high",item)
				item.components.stewer:Harvest(player)
				return hungerLoss
			end
			--晒肉架
			if item.components.dryer then
				hungerLoss=getHungerLoss(player,item,TUNING_MEDAL.DEVOUR_STAFF_HARVEST_COUNT)
				spawnFX("spawn_fx_small_high",item)
				item.components.dryer:Harvest(player)
				return hungerLoss
			end
			--眼球草
			if item.components.shelf then
				hungerLoss=getHungerLoss(player,item,TUNING_MEDAL.DEVOUR_STAFF_HARVEST_COUNT)
				spawnFX("spawn_fx_small_high",item)
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
					spawnFX("spawn_fx_tiny",item)
					item.components.trap:Harvest(player)
				end
				return hungerLoss
			end
			--消耗计算
			hungerLoss=getHungerLoss(player,item,math.ceil(stacknum/5))--堆叠的减少消耗,每5个按1个算
			spawnFX("spawn_fx_tiny",item)
			if inst.space_target and inst.space_target:IsValid() and inst.space_target.components.container and inst.spacevalue>0 and not inst.space_target:HasTag("addspaceposable") then
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
			return hungerLoss
		end
	end
	return hungerLoss
end

--施法拾取物品函数
local function pickup_func(inst,target,pos,doer,single)
	local caster = doer or inst.components.inventoryitem.owner--施法者
	local hungerLoss=0--饱食度消耗
	local findList={"_inventoryitem"}--需检索的标签列表
	local canttags={"INLIMBO", "NOCLICK", "catchable", "fire","notdevourable"}--不该检索的标签列表
	local bigradius=false--大范围施法
	if caster then
		--丰收勋章
		if caster.quickpickmedal then 
			findList={"_inventoryitem","pickable","harvestable","readyforharvest","donecooking","dried","takeshelfitem"}
			bigradius=true
		end
		--高级伐木勋章
		if caster.large_chop then 
			-- findList={"_inventoryitem","stump"}
			table.insert(findList,"stump")
			bigradius=true
		end
	end
	
	local castRadius=bigradius and TUNING_MEDAL.IMMORTAL_STAFF_RADIUS or TUNING_MEDAL.DEVOUR_STAFF_RADIUS--施法范围
	local scalefx=bigradius and "immortal_staff_scale_fx" or "devour_staff_scale_fx"--范围圈特效
	--对点使用
	if pos then
		local x,y,z = pos:Get()
		local ents = TheSim:FindEntities(x, y, z, castRadius ,nil , canttags,findList)
		spawnFX(scalefx,nil,x,y,z)
		if #ents>0 then
			for i,v in ipairs(ents) do
				hungerLoss=hungerLoss+pickitem(inst,v,caster,false)
			end
		end
	--对单个目标使用
	elseif target then
		local canpick=true
		if inst.spacevalue then
			--分解坎普斯背包
			if target.prefab=="krampus_sack" and not target:HasTag("keepfresh") then
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
					if inst.space_target:IsValid() and not inst.space_target:HasTag("addspaceposable") then
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
					local x,y,z = caster.Transform:GetWorldPosition()
					local ents = TheSim:FindEntities(x, y, z, castRadius ,nil , canttags,findList)
					spawnFX(scalefx,nil,x,y,z)
					if #ents>0 then
						for i,v in ipairs(ents) do
							hungerLoss=hungerLoss+pickitem(inst,v,caster,false)
						end
					end
				end
				canpick=false
			end
		end
		if canpick and caster ~= nil and caster.components.inventory~=nil then
			--单目标拾取
			if single then
				hungerLoss=hungerLoss+pickitem(inst,target,caster,true)
			else--拾取同种物品
				local x,y,z = target.Transform:GetWorldPosition()
				spawnFX(scalefx,nil,x,y,z)
				local ents = TheSim:FindEntities(x, y, z, castRadius ,nil , canttags,findList)
				local targetname=target.prefab--这里要先记录下预置物名，不然会出现中途被拾走导致无法比对的情况
				for i,v in ipairs(ents) do
					if v.prefab==targetname then
						hungerLoss=hungerLoss+pickitem(inst,v,caster,false)
					end
				end
			end
		end
	--在装备栏使用
	elseif caster then
		local x,y,z = caster.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, castRadius ,nil , canttags,findList)
		spawnFX(scalefx,nil,x,y,z)
		for i,v in ipairs(ents) do
			hungerLoss=hungerLoss+pickitem(inst,v,caster,false)
		end
	end
	
	if hungerLoss>0 then
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

--判断是否为有效施法目标
local function devour_can_cast_fn(doer, target, pos)
	if doer==target then
		return true
	end
	--可库存的
	if target.components.inventoryitem ~= nil then
		return true
	end
	local taglist={
		"pickable",--可采集的
		"harvestable",--可收获的
		"readyforharvest",--可收获的(农作物)
		"donecooking",--烹饪好的料理
		"dried",--晒好的东西
		"takeshelfitem",--架子(眼球草)
	}
	--如果玩家戴了丰收勋章
	if doer.quickpickmedal then
		for k,v in ipairs(taglist) do
			if target:HasTag(v) then
				return true
			end
		end
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

----------------------------------------不朽法杖------------------------------------------
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

--转移容器内物品(原容器,新容器)
local function transferEverything(inst,obj)
	if inst.components.container and not inst.components.container:IsEmpty() then
		if obj.components.container then
			local allitems=inst.components.container:RemoveAllItemsWithSlot()
			if allitems then
				for k,v in pairs(allitems) do
					obj.components.container:GiveItem(v,k)
				end
			end
		end
	end
end

local immortal_fn_loot={
	{--打蜡
		testfn=function(target) return target:HasTag("waxable") end,
		spellfn=function(staff,target)
			if staff.components.finiteuses and staff.components.finiteuses:GetUses()>=10 then
				local waxedveggie = SpawnPrefab(target.prefab.."_waxed")
				if waxedveggie then
					waxedveggie.Transform:SetPosition(target.Transform:GetWorldPosition())
					waxedveggie.AnimState:PlayAnimation("wax_oversized", false)
					waxedveggie.AnimState:PushAnimation("idle_oversized")
					target:Remove()
					staff.components.finiteuses:Use(10)
				end
				return true
			end
			return false
		end,
	},
	--[[
	{--生成坎普斯宝匣
		testfn=function(target) return target.prefab=="krampus_sack" and target:HasTag("keepfresh") end,
		spellfn=function(staff,target)
			if staff.components.finiteuses and staff.components.finiteuses:GetUses()>=100 then
				local newbox = SpawnPrefab("medal_krampus_chest_item")
				if newbox then
					newbox.Transform:SetPosition(target.Transform:GetWorldPosition())
					spawnFX("halloween_firepuff_1",target)
					transferEverything(target,newbox)
					target:Remove()
					staff.components.finiteuses:Use(100)
				end
				return true
			end
			return false
		end,
	},
	]]
	{--石化
		testfn=function(target) return (target:HasTag("petrifiable") or target:HasTag("deciduoustree")) and target.components.growable ~= nil and not target:HasTag("stump") end,
		spellfn=function(staff,target)
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
		spellfn=function(staff,target)
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
		spellfn=function(staff,target)
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
						spawnFX("halloween_firepuff_1",target)
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
		spellfn=function(staff,target)
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
}

--不朽法杖作用目标所需标签
local IMMORTAL_NEED_TAG_LIST={
	"petrifiable",--可石化
	"deciduoustree",--桦树
	"waxable",--可打蜡
	-- "keepfresh",--不朽背包
	"nitrifyable",--可硝化
	"pickable_harvest_str",--腐烂农作物
	"weed",--杂草
	"canbeglass",--可被晶体化
}
--施法函数
local function immortal_func(inst,target,pos,doer,single)
	local caster = doer or inst.components.inventoryitem.owner--施法者
	--对点使用
	if pos then
		local x,y,z = pos:Get()
		local ents = TheSim:FindEntities(x, y, z, TUNING_MEDAL.IMMORTAL_STAFF_RADIUS ,nil, {"INLIMBO", "NOCLICK"},IMMORTAL_NEED_TAG_LIST)
		spawnFX("immortal_staff_scale_fx",nil,x,y,z)
		if #ents>0 then
			local need_sigh=true--是否发出感叹词
			for i,v in ipairs(ents) do
				for _,imfn in ipairs(immortal_fn_loot) do
					if imfn.testfn==nil or imfn.testfn(v) then
						if imfn.spellfn and imfn.spellfn(inst,v) then
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
			spawnFX("immortal_staff_scale_fx",nil,x,y,z)
			ents = TheSim:FindEntities(x, y, z, TUNING_MEDAL.IMMORTAL_STAFF_RADIUS ,nil, {"INLIMBO", "NOCLICK"},IMMORTAL_NEED_TAG_LIST)
		end
		--施法
		for i,v in ipairs(ents) do
			if v.prefab == targetname then
				for _,imfn in ipairs(immortal_fn_loot) do
					if imfn.testfn==nil or imfn.testfn(v) then
						if imfn.spellfn and imfn.spellfn(inst,v) then
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
		local ents = TheSim:FindEntities(x, y, z, TUNING_MEDAL.IMMORTAL_STAFF_RADIUS ,nil, {"INLIMBO", "NOCLICK"},IMMORTAL_NEED_TAG_LIST)
		spawnFX("immortal_staff_scale_fx",nil,x,y,z)
		if #ents>0 then
			local need_sigh=true--是否发出感叹词
			for i,v in ipairs(ents) do
				for _,imfn in ipairs(immortal_fn_loot) do
					if imfn.testfn==nil or imfn.testfn(v) then
						if imfn.spellfn and imfn.spellfn(inst,v) then
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
	for k,v in ipairs(IMMORTAL_NEED_TAG_LIST) do
		if target:HasTag(v) then
			return true
		end
	end
    return false
end

----------------------------------------流星法杖------------------------------------------
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
		SpawnPrefab("shadowmeteor").Transform:SetPosition(target.Transform:GetWorldPosition())
	end
	
end

--召唤单颗流星
local function call_a_meteor(px,py,pz)
	local theta = math.random() * 2 * PI
	local radius = easing.outSine(math.random(), math.random() * TUNING_MEDAL.METEOR_STAFF_RADIUS, TUNING_MEDAL.METEOR_STAFF_RADIUS, 1)
	local fan_offset = FindValidPositionByFan(theta, radius, 30,
		function(offset)
			return TheWorld.Map:IsPassableAtPoint(px + offset.x, py + offset.y, pz + offset.z)
		end) or Vector3(0,0,0)
	local met = SpawnPrefab("shadowmeteor")
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
		SpawnPrefab(isglass and "medal_spacetime_lightning" or "shadowmeteor").Transform:SetPosition(pos:Get())
		inst.components.finiteuses:Use(math.min(inst.components.finiteuses:GetUses(),isglass and 20 or 1))
	--对单个目标使用
	elseif target then
		local pt = Vector3(target.Transform:GetWorldPosition())
		local isglass = IsInSpaceTimeStorm(pt)
		if isglass and inst.components.finiteuses:GetUses() < 20 then
			MedalSay(caster,STRINGS.MEDALMETEORSTAFFSPEECH.POWERNOTENOUGH)
			return
		end
		SpawnPrefab(isglass and "medal_spacetime_lightning" or "shadowmeteor").Transform:SetPosition(pt:Get())
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
			SpawnPrefab("medal_spacetime_lightning").Transform:SetPosition(px,py,pz)
		else
			caster:StartThread(function()
				for k = 0, num_meteor-1 do
					call_a_meteor(px,py,pz)
					Sleep(.3 + math.random() * .2)
				end
			end)
		end
		inst.components.finiteuses:Use(math.min(inst.components.finiteuses:GetUses(),20))
	end
end

------------------------------------------撒币--------------------------------------------
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

----------------------------------------法杖列表------------------------------------------
local staff_defs={
	--吞噬法杖
	devour_staff={
		name="devour_staff",
		animname="devour_staff",
		skinname="devour_staff_skin1",--皮肤
		taglist={
			"medalquickcastleft",--单目标左键快速施法
			"allow_action_on_impassable",--不可通行区域施法
			"medal_eatfood",--可喂食料理
			"cangivespacegem",--可以赋予空间之力
			"canbeimmortal",--可以赋予不朽之力
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
	},
	--不朽法杖
	immortal_staff={
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
	},
	--流星法杖
	meteor_staff={
		name="meteor_staff",
		animname="meteor_staff",
		skinname="meteor_staff_skin1",--皮肤
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
	},
	--风花雪月
	medal_skin_staff={
		name="medal_skin_staff",
		animname="medal_skin_staff",
		skinname="medal_skin_staff_skin1",--皮肤
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
				local talkstr = nil
				local change_target = (target and target == caster) and inst or target--如果是对玩家自己使用，则是给风花雪月换皮肤
				if change_target and change_target.components.medal_skinable then
					if inst.skin_target==change_target then
						if change_target.components.medal_skinable:ChangeSkin(inst) then
							if inst.components.rechargeable then
								inst.components.rechargeable:Discharge(TUNING_MEDAL.MEDAL_SKIN_STAFF_CD)--免费换肤CD
							end
							if change_target == inst then--切换下手持动画
								caster.AnimState:OverrideSymbol("swap_object", GetMedalSkinData(inst,"medal_skin_staff"), "swap_medal_skin_staff")
							end
						else
							talkstr=STRINGS.MEDALSKINSTAFFSPEECH.NOSKIN
						end
					elseif inst.components.finiteuses and inst.components.finiteuses:GetUses()>=2 then
						if change_target.components.medal_skinable:ChangeSkin(inst) then
							inst.components.finiteuses:Use(2)
							inst.skin_target=change_target
							if inst.components.rechargeable then
								inst.components.rechargeable:Discharge(TUNING_MEDAL.MEDAL_SKIN_STAFF_CD)--免费换肤CD
							end
							if change_target == inst then--切换下手持动画
								caster.AnimState:OverrideSymbol("swap_object", GetMedalSkinData(inst,"medal_skin_staff"), "swap_medal_skin_staff")
							end
						else
							talkstr=STRINGS.MEDALSKINSTAFFSPEECH.NOSKIN
						end
					else
						talkstr=STRINGS.MEDALSKINSTAFFSPEECH.RUNOUT
					end
				end
				MedalSay(caster,talkstr)
			end)--换皮肤
			inst.components.spellcaster.canuseontargets = true--对某一个目标使用
			inst.components.spellcaster:SetCanCastFn(function(doer, target, pos)
				if target:HasTag("medal_skinable") or target==doer then
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
	},
	--时空法杖
	medal_space_staff={
		name="medal_space_staff",
		animname="medal_space_staff",
		skinname="medal_space_staff_skin1",--皮肤
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
	},
}

--定义法杖
local function MakeStaff(def)
	local assets ={
		Asset("ANIM", "anim/"..def.animname..".zip"),
		Asset("ANIM", "anim/floating_items.zip"),
		Asset("ATLAS", "images/"..def.name..".xml"),
		Asset("ATLAS_BUILD", "images/"..def.name..".xml",256),
	}
	if def.skinname then
		table.insert(assets,Asset("ANIM", "anim/"..def.skinname..".zip"))
	end
	
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
