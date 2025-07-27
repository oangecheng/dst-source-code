local upvaluehelper = require "medal_upvaluehelper"--出自 风铃草大佬
local medal_spicedfoods = require("medal_spicedfoods")--勋章调味料理
local cooking = require("cooking")
--勋章特有容器列表(封装在表里方便做兼容)
local special_medal_box={
	medal_box=true,--勋章盒
	spices_box=true,--调料盒
	medal_ammo_box=true,--弹药盒
	medal_krampus_chest_item=true,--坎普斯之匣
}
---------------------------------------------------------------------------------------------------------
----------------------------------------------复用函数---------------------------------------------------
---------------------------------------------------------------------------------------------------------
--获取堆叠数量
local function GetStackSize(item)
    return item.components.stackable ~= nil and item.components.stackable:StackSize() or 1
end
---------------------------------------------------------------------------------------------------------
--------------------------------------------不朽之力相关--------------------------------------------------
---------------------------------------------------------------------------------------------------------
--[[致其他moder：
如果你想给自己Mod的内容或者原版内容添加可不朽的功能，可以参考下面的示例添加
如果你的mod比勋章加载早，这么写：
TUNING.MEDAL_IMMORTAL_LOOT = TUNING.MEDAL_IMMORTAL_LOOT or {}
local xxx={
	--格式一：对于普通的容器，直接这么写就行，1级不朽保鲜食物，大于1级可以保鲜生物
	treasurechest = 2,--箱子可以赋予不朽之力，最大不朽等级2级
	--格式二：对于有特殊需求的容器，则可以添加自定义方法
	chestname = {
		maxlevel = 1,--最大不朽等级，不填默认为1
		immortalfn = function(inst,level)--level是不朽等级
			--拥有不朽之力时调用
		end,
		clientfn = function(inst)
			--主客机都有用的自定义方法，你爱写啥写啥
		end,
		serverfn = function(inst)
			--只有主机调用的方法，你爱写啥写啥
		end,
	},
}
table.insert(TUNING.MEDAL_IMMORTAL_LOOT,xxx)
如果你的mod比勋章晚加载，可以直接调用SetImmortalable函数，定义在medal_globalfn.lua文件内
ps：觉得不够灵活的话可以自己添加medal_immortal组件
]]--

--更新蘑菇灯保鲜状态
local function UpdateLightState(inst)
	if inst:HasTag("isimmortal") and inst.components.preserver then
		inst.components.preserver:SetPerishRateMultiplier(function(inst, item)
			return (item ~= nil and not (item:HasTag("fish") or item.components.health~=nil)) and 0 or nil
		end)
	end
end
--蘑菇灯server方法
local function mushroomLightServerFn(inst)
	inst:ListenForEvent("itemget", UpdateLightState)
    inst:ListenForEvent("itemlose", UpdateLightState)
end

local ApplySkillModifiers = nil

--可添加不朽之力的容器列表(预制物名 = 最大不朽等级)
local medal_immortal_loot={
	icebox = 1,--冰箱
	saltbox = 1,--盐盒
	medal_farm_plow_item = 1,--高效耕地机
	sisturn = {--骨灰盒
		serverfn = function(inst)
			if ApplySkillModifiers == nil then
				if inst.OnLoad ~= nil then
					ApplySkillModifiers = upvaluehelper.Get(inst.OnLoad, "ApplySkillModifiers")
					if ApplySkillModifiers ~= nil then
						upvaluehelper.Set(inst.OnLoad,"ApplySkillModifiers",function(inst)
							ApplySkillModifiers(inst)
							UpdateLightState(inst)
						end)
					end
				end
			end
		end,
	},
	mushroom_light = {--蘑菇灯
		serverfn = mushroomLightServerFn,
	},
	mushroom_light2 = {--菌伞灯
		serverfn = mushroomLightServerFn,
	},
	endtable = {--茶几
		serverfn=function(inst)
			local oldondecorate = inst.components.vase and inst.components.vase.ondecorate
			if oldondecorate then
				inst.components.vase.ondecorate = function(inst, ...)
					oldondecorate(inst, ...)
					--取消不朽茶几的腐烂计时器
					if inst:HasTag("isimmortal") then
						if inst.task ~= nil then
							inst.task:Cancel()
							inst.task = nil
						end
					end
				end
			end
			local oldSaveFn=inst.OnSave
			inst.OnSave = function(inst,data)
				if oldSaveFn~=nil then
					oldSaveFn(inst,data)
				end
				--给不朽茶几一个初始腐烂时长，反正后续会移除掉
				if inst:HasTag("isimmortal") and inst.flowerid ~= nil then
					data.wilttime = TUNING.ENDTABLE_FLOWER_WILTTIME
				end
			end
		end,
		immortalfn=function(inst)
			if inst.task ~= nil then
				inst.task:Cancel()
				inst.task = nil
			end
		end,
	},
}

TUNING.MEDAL_IMMORTAL_LOOT = TUNING.MEDAL_IMMORTAL_LOOT or {}
table.insert(TUNING.MEDAL_IMMORTAL_LOOT,medal_immortal_loot)
--添加不朽之力
for _, tb in pairs(TUNING.MEDAL_IMMORTAL_LOOT) do
	for k,v in pairs(tb) do
		AddPrefabPostInit(k,function(inst)
			local maxlevel, info
			if type(v) == "table" then
				maxlevel = v.maxlevel
				info = v
			else
				maxlevel = v
			end
			SetImmortalable(inst,maxlevel,info)
		end)
	end
end

---------------------------------------------------------------------------------------------------------
--------------------------------------------新掉落物相关-------------------------------------------------
---------------------------------------------------------------------------------------------------------
--需添加掉落物的预置物列表
local lootdropper_loot={
	-- krampus={--坎普斯:坎普斯之灵
	-- 	krampus_soul=TUNING_MEDAL.KRAMPUS_SOUL_DROP_RATE,
	-- },
	spoiled_fish={--腐烂的鱼:鱼骨
		medal_fishbones=0.75,
	},
	spoiled_fish_small={--腐烂的小鱼:鱼骨
		medal_fishbones=0.5,
	},
}
for k,v in pairs(lootdropper_loot) do
	AddPrefabPostInit(k,function(inst)
		if TheWorld.ismastersim then
			if inst.components.lootdropper then
				for ik,iv in pairs(v) do
					inst.components.lootdropper:AddChanceLoot(ik, iv)
				end
			end
		end
	end)
end

---------------------------------------------------------------------------------------------------------
---------------------------------------------月光移植相关-------------------------------------------------
---------------------------------------------------------------------------------------------------------
local FERTILIZER_DEFS = require("prefabs/fertilizer_nutrient_defs").FERTILIZER_DEFS
local SORTED_FERTILIZERS = require("prefabs/fertilizer_nutrient_defs").SORTED_FERTILIZERS
FERTILIZER_DEFS.spice_poop = {--秘制酱料肥料
	nutrients = {8,16,8},
	inventoryimage="spice_poop.tex",
	atlas="images/spice_poop.xml",
	name="SPICE_POOP",
	uses=1,
}
table.insert(SORTED_FERTILIZERS,"spice_poop")

--挖掘
local function OnMedalTransplantFinish(inst,work)
	if inst.components.pickable ~= nil and inst.components.lootdropper ~= nil then
		if inst.components.pickable:CanBePicked() then
			--如果可采摘，则多掉落对应数量的产物
			if inst.medal_transplant_product_num ~= nil and inst.medal_transplant_product_num > 0 then
				for i = 1, inst.medal_transplant_product_num do
					inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
				end
			elseif inst.components.childspawner and inst.components.childspawner.childname then
				inst.components.lootdropper:SpawnLootPrefab(inst.components.childspawner.childname)
			end
			--如果有花，则产物里多一个仙人掌花
			if inst.has_flower then
				inst.components.lootdropper:SpawnLootPrefab("cactus_flower")--仙人掌花
			end
		end
		inst.components.lootdropper:SpawnLootPrefab("medaldug_"..inst.prefab)--生成移植树苗
	end
	inst:Remove()
end
--移植后可直接用铲子挖
local function OnMedalTransplant(inst)
	inst.components.workable:SetWorkAction(ACTIONS.MEDALNORMALTRANSPLANT)--不需要月光的移植动作
	inst:RemoveTag("cantdestroy")
	inst.components.pickable.cycles_left=nil--取消采摘次数上限
	if inst.NeedFertilizeFn then
		inst:NeedFertilizeFn()
	end
end


--可进行月光移植的植物(key作物名,value产物数量)
local transplant_loot={
	-- reeds = 1,--芦苇
	flower_cave = 1,--荧光果
	cactus = 1,--仙人掌
	oasis_cactus = 1,--沙漠仙人掌
	lichen = 1,--洞穴苔藓
	wormlight_plant = 1,--神秘植物
	flower_cave_double = 2,--双果荧光果
	flower_cave_triple = 3,--三果荧光果
	lightflier_flower = 0,--荧光虫花
}
--设置移植函数
local function setTransplantFn(inst,numproduct)
	inst.medal_transplant_product_num = numproduct
	if inst.components.workable == nil then
		inst:AddComponent("workable")
	end
	if inst.components.lootdropper == nil then
		inst:AddComponent("lootdropper")
	end
	inst.components.workable:SetWorkAction(ACTIONS.MEDALTRANSPLANT)--月光移植动作
	inst.components.workable:SetWorkLeft(1)--需要铲1下
	local oldOnFinishFn=inst.components.workable.onfinish
	inst.components.workable:SetOnFinishCallback(function(inst,worker, ...)--移植回调
		--原本没OnFinishFn回调，或者拿着月光玻璃铲，则走勋章产出，否则就原本的回调(其他mod可能会加)
		if (worker and worker.medal_has_moon_shovel) or oldOnFinishFn == nil then
			OnMedalTransplantFinish(inst,worker)
		else
			oldOnFinishFn(inst,worker, ...)
		end
	end)
	
	if inst.components.pickable then
		--设置移植函数,移植后可直接用铲子挖
		inst.components.pickable.ontransplantfn = OnMedalTransplant
		--双果荧光花的缺肥动画缺失，这里强行给它修一波
		if inst.prefab=="flower_cave_double" then
			local oldonpickedfn=inst.components.pickable.onpickedfn
			inst.components.pickable.onpickedfn = function(inst, ...)
				if oldonpickedfn then
					oldonpickedfn(inst, ...)
				end
				if inst.components.pickable:IsBarren() then
					inst.AnimState:PlayAnimation("picking")
					inst.AnimState:PushAnimation("picked")
				end
			end
		end
	end
	--需施肥函数
	inst.NeedFertilizeFn=function(inst)
		inst:AddTag("needfertilize")--需施肥
		inst.components.pickable:Pause()--暂停生长
		inst.AnimState:SetMultColour(0.5, 0.45, 0.3, 1)
	end
	--施肥函数
	inst.AddFertilizeFn=function(inst)
		inst:RemoveTag("needfertilize")
		if inst.prefab=="reeds" or inst.prefab=="lichen" then
			--芦苇和洞穴苔藓冬天不要生长
			if not TheWorld.state.iswinter then
				inst.components.pickable:Resume()--继续生长
			end
		else
			inst.components.pickable:Resume()--继续生长
		end
		inst.AnimState:SetMultColour(1, 1, 1, 1)
	end
	
	--加载时判断是否是移植过的植物
	local oldPreLoadFn=inst.OnPreLoad
	inst.OnPreLoad=function(inst, data)
		if data ~= nil and data.pickable ~= nil and data.pickable.transplanted then
			inst.components.pickable.cycles_left=nil--取消采摘次数上限
			inst.components.workable:SetWorkAction(ACTIONS.MEDALNORMALTRANSPLANT)
			inst:RemoveTag("cantdestroy")
		end
		if oldPreLoadFn then
			oldPreLoadFn(inst,data)
		end
	end
	
	local oldSaveFn=inst.OnSave
	inst.OnSave=function(inst,data)
		if inst:HasTag("needfertilize") then
			data.needfertilize=true
		end
		if oldSaveFn then
			oldSaveFn(inst,data)
		end
	end
	local oldLoadFn=inst.OnLoad
	inst.OnLoad=function(inst,data)
		if data and data.needfertilize then
			if inst.NeedFertilizeFn then
				inst:NeedFertilizeFn()--需施肥
			end
			-- inst:AddTag("needfertilize")--需施肥
		end
		if oldLoadFn then
			oldLoadFn(inst,data)
		end
	end
end

--如果开启了移植功能
if TUNING.TRANSPLANT_OPEN then
	--调整再生功能，只在被烧了后触发
	if GLOBAL.AddToRegrowthManager then
		local function OnStartRegrowth(inst, data)
			TheWorld:PushEvent("beginregrowth", inst)
		end
		GLOBAL.AddToRegrowthManager = function(inst)
			inst:ListenForEvent("onburnt", OnStartRegrowth)
			inst.OnStartRegrowth = OnStartRegrowth
		end
	end
	
	for k,v in pairs(transplant_loot) do
		AddPrefabPostInit(k,function(inst)
			inst:AddTag("cantdestroy")--不可破坏(防止熊大、地震等对其造成破坏)
			inst:AddTag("medal_transplant")--特殊移植作物
			if TheWorld.ismastersim then
				setTransplantFn(inst,v)--设置移植函数
			end
		end)
	end
	--芦苇移植
	AddPrefabPostInit("reeds",function(inst)
		inst:AddTag("cantdestroy")--不可破坏(防止熊大、地震等对其造成破坏)
		inst:AddTag("medal_transplant")--特殊移植作物
		if TheWorld.ismastersim then
			if inst.components.workable == nil then
				inst:AddComponent("workable")
			end
			if inst.components.lootdropper == nil then
				inst:AddComponent("lootdropper")
			end
			inst.components.workable:SetWorkAction(ACTIONS.MEDALTRANSPLANT)--月光移植动作
			inst.components.workable:SetWorkLeft(1)--需要铲1下
			local oldOnFinishFn=inst.components.workable.onfinish
			inst.components.workable:SetOnFinishCallback(function(inst,worker, ...)--移植回调
				--原本没OnFinishFn回调，或者拿着月光玻璃铲，则走勋章产出，否则就原本的回调(其他mod可能会加)
				if (worker and worker.medal_has_moon_shovel) or oldOnFinishFn == nil then
					if inst.components.pickable ~= nil and inst.components.lootdropper ~= nil then
						if inst.components.pickable:CanBePicked() then
							inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
						end
						inst.components.lootdropper:SpawnLootPrefab("dug_monkeytail")--生成猴尾草
					end
					inst:Remove()
				else
					oldOnFinishFn(inst,worker, ...)
				end
			end)
			if inst.components.pickable then
				inst.components.pickable.ontransplantfn = OnMedalTransplant--设置移植函数,移植后可直接用铲子挖
			end
			--加载时判断是否是移植过的植物
			local oldPreLoadFn=inst.OnPreLoad
			inst.OnPreLoad=function(inst, data)
				if data ~= nil and data.pickable ~= nil and data.pickable.transplanted then
					inst.components.pickable.cycles_left=nil--取消采摘次数上限
					inst.components.workable:SetWorkAction(ACTIONS.MEDALNORMALTRANSPLANT)
					inst:RemoveTag("cantdestroy")
				end
				if oldPreLoadFn then
					oldPreLoadFn(inst,data)
				end
			end
		end
	end)
end

---------------------------------------------------------------------------------------------------------
--------------------------------------------月光破坏相关-------------------------------------------------
---------------------------------------------------------------------------------------------------------
--可破坏建筑(key预置物名,value破坏后的产物)
local medalhammer_loot={
	minotaurchest = {"boards","boards","boards","goldnugget","goldnugget"},--远古守卫者箱子
	insanityrock = {"sanityrock_fragment","marble","nightmarefuel"},--方尖碑
	sanityrock = {"sanityrock_fragment","marble","nightmarefuel"},--反向方尖碑
	gravestone = {"marble","marble"},--墓碑
	basalt = {"marble","marble","marble","marble"},--玄武岩
	basalt_pillar = {"marble","marble","marble"},--高玄武岩
	resurrectionstone = {"sanityrock_fragment"},--试金石
	-- saltstack = {"saltrock"},--盐堆
	archive_cookpot = {"moonrocknugget","moonrocknugget","moonrocknugget","thulecite","thulecite","charcoal","charcoal","charcoal","twigs","twigs","twigs"},--远古窑
	meatrack_hermit = {"moon_tree_blossom","driftwood_log","rope"},--隐士晾肉架
	beebox_hermit = {"ash","ash","twigs","cookiecuttershell","honeycomb","bee","bee"},--隐士蜂箱
}

--设置敲打函数
local function setHammerFn(inst,droplist)
	if inst.components.workable == nil then
		inst:AddComponent("workable")
	end
	if inst.components.lootdropper == nil then
		inst:AddComponent("lootdropper")
	end
	inst.components.workable:SetWorkAction(ACTIONS.MEDALHAMMER)--专属敲击动作
	--设置敲破时执行的函数
	local oldOnFinishFn=inst.components.workable.onfinish
	inst.components.workable:SetOnFinishCallback(function(inst,worker, ...)
		--原本没OnFinishFn回调，或者拿着月光玻璃锤，则走勋章产出，否则就原本的回调(其他mod可能会加)
		if (worker and worker.medal_has_moon_hammer) or oldOnFinishFn == nil then
			if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
				inst.components.burnable:Extinguish()
			end
			if inst.components.lootdropper then
				if droplist and #droplist>0 then
					for i, v in ipairs(droplist) do
						inst.components.lootdropper:SpawnLootPrefab(v)
					end
				end
				inst.components.lootdropper:DropLoot()
			end
			if inst.components.container ~= nil then
				inst.components.container:DropEverything()
			end
			local fx = SpawnPrefab("collapse_small")
			fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
			fx:SetMaterial("wood")
			--如果是墓碑，有对应的墓地，则保留墓地只破坏墓碑
			if inst.mound and inst.mound.Transform:GetWorldPosition() then
				local newmound=SpawnPrefab(inst.mound.prefab)
				newmound.Transform:SetPosition(inst.mound.Transform:GetWorldPosition())
				if not inst.mound.components.workable then
					newmound.AnimState:PlayAnimation("dug")
					newmound:RemoveComponent("workable")
				end
			end
			--移除墓碑绑定的小惊吓
			if inst.ghost then
				inst.ghost:Remove()
			end
			inst:Remove()
		else
			oldOnFinishFn(inst,worker, ...)
		end
		
	end)
	--设置敲击时执行的函数
	local oldOnWorkFn=inst.components.workable.onwork
	inst.components.workable:SetOnWorkCallback(function(inst,worker, ...)
		if oldOnWorkFn then
			oldOnWorkFn(inst,worker, ...)
		elseif not inst:HasTag("burnt") then
			inst.AnimState:PlayAnimation("hit")
			inst.AnimState:PushAnimation("closed", false)
			if inst.components.container ~= nil then
				inst.components.container:DropEverything()
				inst.components.container:Close()
			end
		end
	end)
	inst.components.workable:SetWorkLeft(1)--需要敲1下

	--建造
	local oldOnBuilt = inst.OnBuilt
	inst.OnBuilt = function(inst, ...)
		inst:RemoveTag("cantdestroy")--人为建造的就可以破坏了
		if oldOnBuilt then
			oldOnBuilt(inst, ...)
		end
	end
	
	--状态存储
	local oldSaveFn=inst.OnSave
	inst.OnSave=function(inst,data)
		--修改墓碑的存储函数，防止被挖过的坟再次生成
		if inst.prefab=="gravestone" and inst.mound==nil then
			data.nomound=true
		end
		--可破坏的
		if not inst:HasTag("cantdestroy") then
			data.candestroy = true
		end
		if oldSaveFn then
			return oldSaveFn(inst,data)
		end
	end
	local oldLoadFn=inst.OnLoad
	inst.OnLoad=function(inst,data)
		if data then
			if data.nomound and inst.mound then
				inst.mound:Remove()
				inst.mound=nil
			end
			if data.candestroy then
				inst:RemoveTag("cantdestroy")
			end
		end
		if oldLoadFn then
			oldLoadFn(inst,data)
		end
	end
end 

for k,v in pairs(medalhammer_loot) do
	AddPrefabPostInit(k,function(inst)
		inst:AddTag("cantdestroy")--不可破坏(防止熊大、地震等对其造成破坏)
		if TheWorld.ismastersim then
			setHammerFn(inst,v)--设置敲打函数
		end
	end)
end

---------------------------------------------------------------------------------------------------------
--------------------------------------------修改世界相关-------------------------------------------------
---------------------------------------------------------------------------------------------------------
--给地上世界添加月黑监听
AddPrefabPostInit("forest",function(inst)
	if TheWorld.ismastersim then
		inst:WatchWorldState("isnewmoon", function(inst)
			if TheWorld.state.isnewmoon then
				TheNet:Announce(STRINGS.MEDAL_ANNOUNCE.NEWMOON)
			end
		end)
	end
end)

--给世界添加传送塔注册组件
AddPrefabPostInit("world",function(inst)
	if TheWorld.ismastersim then
		inst:AddComponent("medal_townportalregistry")--传送塔注册组件
		inst:AddComponent("medal_spacetimestormmanager")--时空风暴管理组件
		inst:AddComponent("medal_spacetimestormlightningmanager")--时空电流组件
		inst:AddComponent("medal_infosave")--数据存储
		inst:AddComponent("medal_sinkholessync")--时空塌陷同步组件
		inst:AddComponent("medal_serverdestiny")--宿命将至
	end
end)

--给世界添加时空风暴组件
AddPrefabPostInit("forest_network",function(inst)
	inst:AddComponent("medal_spacetimestorms")--时空风暴
end)

--给服务器网络添加时空塌陷同步组件
if TUNING.MEDAL_SHARDSKINHOLES_SWITCH then
	AddPrefabPostInit("shard_network",function(inst)
		inst:AddComponent("shard_medalsinkholes")--时空塌陷同步组件
	end)
end
---------------------------------------------------------------------------------------------------------
--------------------------------------------修改玩家相关-------------------------------------------------
---------------------------------------------------------------------------------------------------------

--复眼滤镜
local OMMATEUM_COLOURCUBES ={
	-- day = "images/colour_cubes/purple_moon_cc.tex",
	-- dusk = "images/colour_cubes/purple_moon_cc.tex",
	-- night = "images/colour_cubes/purple_moon_cc.tex",
	-- full_moon = "images/colour_cubes/purple_moon_cc.tex",

	day = "images/colour_cubes/spring_day_cc.tex",
	dusk = "images/colour_cubes/spring_dusk_cc.tex",
	night = "images/colour_cubes/purple_moon_cc.tex",
	full_moon = "images/colour_cubes/purple_moon_cc.tex",
}
local ORIGIN_COLOURCUBES ={
	day = "images/colour_cubes/identity_colourcube.tex",
	dusk = "images/colour_cubes/identity_colourcube.tex",
	night = "images/colour_cubes/identity_colourcube.tex",
	full_moon = "images/colour_cubes/identity_colourcube.tex",
}
--复眼函数
local function SetOmmateumVision(inst)
	if inst.components.playervision then
		if inst.medalnightvision and inst.medalnightvision:value() then
			local isorigin = HasOriginMedal(inst)
			inst.components.playervision:ForceGoggleVision(true)
			inst.components.playervision:PushForcedNightVision("ommateum_certificate", isorigin and 10 or 1, isorigin and ORIGIN_COLOURCUBES or OMMATEUM_COLOURCUBES, true)
		else
			inst.components.playervision:ForceGoggleVision(false)
			inst.components.playervision:PopForcedNightVision("ommateum_certificate")
		end
	end
end

--谋杀鱼函数
local function OnMurderedFish(inst, data)
    local victim = data.victim
    if victim ~= nil and victim:IsValid() then
		--海鱼
		if victim:HasTag("oceanfish") then
			--时令鱼
			if victim.prefab=="oceanfish_small_7_inv" or victim.prefab=="oceanfish_small_6_inv" or victim.prefab=="oceanfish_small_8_inv" or victim.prefab=="oceanfish_medium_8_inv" then
				--判断玩家是否已经学习过船上钓鱼池蓝图
				if inst.components.builder and not inst.components.builder:KnowsRecipe("medal_seapond") then
					victim.components.lootdropper:SpawnLootPrefab("medal_seapond_blueprint")
					MedalSay(inst,STRINGS.PLACECHUMSPEECH.GETBLUEPRINT)
				end
			else--其他海鱼
				if math.random()<TUNING_MEDAL.SEAPOND_BLUEPRINT_CHANCE then
					--判断玩家是否已经学习过船上钓鱼池蓝图
					if inst.components.builder and not inst.components.builder:KnowsRecipe("medal_seapond") then
						victim.components.lootdropper:SpawnLootPrefab("medal_seapond_blueprint")
						MedalSay(inst,STRINGS.PLACECHUMSPEECH.GETBLUEPRINT)
					end
				end
			end
		--熔岩鳗鱼
		elseif victim.prefab=="lavaeel" then
			if victim.components.lootdropper then
				for k=1,3 do
					victim.components.lootdropper:FlingItem(SpawnPrefab("houndfire"), victim:GetPosition())
				end
			end
		end
		--戴鱼人勋章杀鱼会解雇鱼人
		if inst:HasTag("merm_builder") and inst.components.leader and victim:HasTag("fish") then
			--原本就有相关组件了就不管了
			if inst.components.repellent and table.contains(inst.components.repellent.repel_tags,"merm") then
				return
			end
			--解雇鱼人
			for follower, v in pairs(inst.components.leader.followers) do
				if follower:HasTag("merm") then
					follower.components.follower:StopFollowing()
					if follower.DoDisapproval then
						follower:DoDisapproval()
					end
				end
			end
		end
    end
end
--该坐标是否可以通过灵魂跳跃到达
local function CanBlinkTo(pt)
    return (TheWorld.Map:IsAboveGroundAtPoint(pt.x, pt.y, pt.z) or TheWorld.Map:GetPlatformAtPoint(pt.x, pt.z) ~= nil) and not TheWorld.Map:IsGroundTargetBlocked(pt)
end

--设置灵魂跳跃函数
local function setBlinkFn(player)
	if player.components.playeractionpicker ~= nil then
		local old_pointspecialactionsfn = player.components.playeractionpicker.pointspecialactionsfn
		if old_pointspecialactionsfn then
			--有老函数的需要判断是不是第一次调用，只有第一次调用生效
			if not player.setBlink_flag then
				player.setBlink_flag=true--设置pointspecialactionsfn的标记，防止多次套用
				player.components.playeractionpicker.pointspecialactionsfn=function(inst, pos, useitem, right, ...)
					--拥有临时穿梭者、自由穿梭者、勋章穿梭者标签
					if right and useitem == nil and (inst.replica.rider == nil or not inst.replica.rider:IsRiding()) and CanBlinkTo(pos) then
						local equipitem = inst.replica.inventory and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
						--手持右键释放技能的武器时灵魂跳跃不生效
						if equipitem == nil or equipitem.components.aoetargeting == nil or not equipitem.components.aoetargeting:IsEnabled() then
							if inst:HasTag("temporaryblinker") or inst:HasTag("freeblinker") or inst:HasTag("medal_blinker") then
								return { ACTIONS.BLINK }
							end
						end
					end
					return old_pointspecialactionsfn(inst, pos, useitem, right, ...)
				end
			end
		else--没老函数的直接赋值新函数，伍迪这种每次被清空的就是nil，直接套就完事了(不需要考虑鸭子状态)
			player.setBlink_flag=true--设置pointspecialactionsfn的标记，防止多次套用
			player.components.playeractionpicker.pointspecialactionsfn=function(inst, pos, useitem, right)
				--拥有临时穿梭者、自由穿梭者、勋章穿梭者标签
				if right and useitem == nil and (inst.replica.rider == nil or not inst.replica.rider:IsRiding()) and CanBlinkTo(pos) then
					local equipitem = inst.replica.inventory and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
					--手持右键释放技能的武器时灵魂跳跃不生效
					if equipitem == nil or equipitem.components.aoetargeting == nil or not equipitem.components.aoetargeting:IsEnabled() then
						if inst:HasTag("temporaryblinker") or inst:HasTag("freeblinker") or inst:HasTag("medal_blinker") then
							return { ACTIONS.BLINK }
						end
					end
				end
				return {}
			end
		end
	end
end
--设置玩家减速触发器(蜘蛛网)
local function setTriggerscreepFn(player)
	if player.medaltriggerscreep:value() then
		--在蜘蛛网上走路不减速
		if player.components.locomotor and player.components.locomotor.triggerscreep==true then
			player.components.locomotor:SetTriggersCreep(false)
		end
	elseif player.components.locomotor then
		player.components.locomotor:SetTriggersCreep(true)
	end
end
--移除暗影勋章召唤的仆从
local function ForceDespawnMedalShadowMinions(inst)
	local medal = inst and inst.components.inventory:EquipMedalWithName("shadowmagic_certificate")--获取玩家的暗影勋章
	if medal and inst.components.petleash then
		for k, v in pairs(inst.components.petleash:GetPets()) do
			if v:HasTag("shadowminion") and v.ismedalshadowpet then
				inst.components.petleash:DespawnPet(v)
			end
		end
	end
end
--暗影仆从换皮
local function ReskinPet(pet, player, nofx)
    pet._dressuptask = nil
    if player:IsValid() then
        if not nofx then
            local x, y, z = pet.Transform:GetWorldPosition()
            local fx = SpawnPrefab("slurper_respawn")
            fx.Transform:SetPosition(x, y, z)
        end
        pet.components.skinner:CopySkinsFromPlayer(player)
    end
end
--玩家换皮肤
local function OnSkinsChanged(inst, data)
    local medal = inst and inst.components.inventory:EquipMedalWithName("shadowmagic_certificate")--获取玩家的暗影勋章
	if medal == nil then return end
	for k, v in pairs(inst.components.petleash:GetPets()) do
        if v:HasTag("shadowminion") and v.ismedalshadowpet then
            if v._dressuptask ~= nil then
                v._dressuptask:Cancel()
                v._dressuptask = nil
            end
            if data and data.nofx then
                ReskinPet(v, inst, data.nofx)
            else
                v._dressuptask = v:DoTaskInTime(math.random()*0.5 + 0.25, ReskinPet, inst)
            end
        end
    end
end
--玩家初始化
AddPlayerPostInit(function(inst)
	inst.medalnightvision = GLOBAL.net_bool(inst.GUID, "medalnightvision", "medalnightvisiondirty")
	inst:ListenForEvent("medalnightvisiondirty", SetOmmateumVision)--复眼勋章
	inst:AddTag("trap_immunity")--免疫陷阱标签
	inst.AnimState:AddOverrideBuild("player_transform_merm")
	inst.medalblinkable = GLOBAL.net_bool(inst.GUID, "medalblinkable", "medalblinkabledirty")
	inst:ListenForEvent("medalblinkabledirty", setBlinkFn)--灵魂跳跃
	inst.medalblinkable:set(true)
	inst.medaltriggerscreep = GLOBAL.net_bool(inst.GUID, "medaltriggerscreep", "medaltriggerscreepdirty")
	inst:ListenForEvent("medaltriggerscreepdirty", setTriggerscreepFn)--设置玩家减速触发器
	--饱食额外下降速率
	inst.medal_hungerrate = GLOBAL.net_float(inst.GUID, "medal_hungerrate","medal_hungerratedirty")
	--食物列表
	inst.medal_food_list = GLOBAL.net_string(inst.GUID, "medal_food_list", "medal_food_listdirty")
	--建造列表
	inst.medal_build_list = GLOBAL.net_string(inst.GUID, "medal_build_list", "medal_build_listdirty")
	--噬空勋章耐久
	inst.medal_souls_num = GLOBAL.net_smallbyte(inst.GUID, "medal_souls_num","medal_souls_numdirty")
	--地图灵魂跳跃
	local oldCanSoulhop = inst.CanSoulhop
	inst.CanSoulhop = function(inst, souls, ...)
		if oldCanSoulhop and oldCanSoulhop(inst, souls, ...) then return true end
		local rider = inst.replica.rider
		--有噬空勋章 且 不在骑行
		if inst:HasTag("medal_map_blinker") and (rider == nil or not rider:IsRiding()) then
			souls = souls or 1
			local result, num = inst.replica.inventory:Has("wortox_soul", souls)
			if result then return true end--如果身上有足够的灵魂就直接可以跳了
			local souls_num = inst.medal_souls_num and inst.medal_souls_num:value() or 0
			if souls_num + num >= souls then--灵魂不够就把勋章耐久也算上
				return true
			end
		end
		return false
	end
	inst:AddTag(UPGRADETYPES.MEDAL_CHEST.."_upgradeuser")--勋章箱子升级标签
	--戴了复眼勋章就算作处于光亮中了
	local oldIsInLight = inst.IsInLight
	if oldIsInLight ~= nil then
		inst.IsInLight = function(inst, ...)
			if inst.medalnightvision and inst.medalnightvision:value() then
				return true
			end
			return oldIsInLight(inst, ...)
		end
	end
	if TheWorld.ismastersim then
		inst:AddComponent("medal_showbufftime")--buff信息显示
        inst:AddComponent("medal_spacetimestormwatcher")--时空风暴观测者
        -- inst:AddComponent("medal_destiny")--宿命
		inst:AddComponent("medal_chaosdamage")--混沌伤害
		inst:ListenForEvent("murdered", OnMurderedFish)--谋杀鱼
		--变身前
		inst:ListenForEvent("ms_playerreroll", function(inst)
			if inst.userid and inst.components.health and inst.components.health.medal_delay_damage ~= nil then
				if TheWorld and TheWorld.components.medal_infosave and TheWorld.components.medal_infosave.medal_delay_damage_data then
					TheWorld.components.medal_infosave.medal_delay_damage_data[inst.userid] = inst.components.health.medal_delay_damage
				end
			end
			ForceDespawnMedalShadowMinions(inst)--移除勋章的暗影仆从
		end)
		--变身后
		inst:ListenForEvent("ms_playerseamlessswaped", function(inst)
			if inst.userid and inst.components.health then
				if TheWorld and TheWorld.components.medal_infosave and TheWorld.components.medal_infosave.medal_delay_damage_data then
					inst.components.health.medal_delay_damage = TheWorld.components.medal_infosave.medal_delay_damage_data[inst.userid] or 0
				end
			end
		end)
		inst:ListenForEvent("onskinschanged", OnSkinsChanged)--换皮肤(顺便给暗影仆从换)
		--不可治疗的角色吃太妃糖可解蜂毒
		inst:ListenForEvent("oneat", function(inst,data)
			if data and data.food and data.feeder then
				local basename = medal_spicedfoods and medal_spicedfoods.spicedfoods and  medal_spicedfoods.spicedfoods[data.food.prefab] and medal_spicedfoods.spicedfoods[data.food.prefab].basename
				if data.food.prefab == "taffy" or basename == "taffy" then
					if data.feeder.components.health and not data.feeder.components.health.canheal then
						data.feeder:RemoveDebuff("buff_medal_injured")--移除蜂毒BUFF
					end
				--吃蘑菇蛋糕消除迷糊层数
				elseif data.food.prefab == "shroomcake" or basename == "shroomcake" then
					if data.feeder.medal_confused_mark and data.feeder.medal_confused_mark>0 then
						data.feeder:RemoveDebuff("buff_medal_confused")--移除迷糊状态
					end
				end
			end
		end)
		--鱼人诅咒吃荤收益下降
		if inst.components.eater then
			local old_custom_stats_mod_fn = inst.components.eater.custom_stats_mod_fn
			inst.components.eater.custom_stats_mod_fn = function(inst, health_delta, hunger_delta, sanity_delta, food, feeder, ...)
				local absorption = 1
				if feeder and feeder.medal_merm_curse then
					if food and food.components.edible and food.components.edible.foodtype == FOODTYPE.MEAT then
						absorption = 1-feeder.medal_merm_curse*.1
					end
				end
				health_delta = health_delta>0 and health_delta*absorption or health_delta
				hunger_delta = hunger_delta>0 and hunger_delta*absorption or hunger_delta
				sanity_delta = sanity_delta>0 and sanity_delta*absorption or sanity_delta
				if old_custom_stats_mod_fn then
					return old_custom_stats_mod_fn(inst, health_delta, hunger_delta, sanity_delta, food, feeder, ...)
				else
					return health_delta, hunger_delta, sanity_delta
				end
			end
		end

		--存储buff数据
		local oldSaveFn=inst.OnSave
		local oldLoadFn=inst.OnLoad
		inst.OnSave = function(inst,data)
			if oldSaveFn~=nil then
				oldSaveFn(inst,data)
			end
			data.medal_aoecombat_value=inst.medal_aoecombat_value--群伤层数
			data.blood_honey_mark=inst.blood_honey_mark--血蜜标记层数
			data.medal_poison_mark=inst.medal_poison_mark--毒伤层数
			data.injured_damage=inst.injured_damage--蜂毒层数
			data.medal_merm_curse=inst.medal_merm_curse--鱼人诅咒
			data.medal_rewardtoiler_mark=inst.medal_rewardtoiler_mark--天道酬勤
			data.medal_confused_mark=inst.medal_confused_mark--迷糊标记
		end
		inst.OnLoad = function(inst,data)
			if oldLoadFn~=nil then
				oldLoadFn(inst,data)
			end
			if data~=nil then
				inst.medal_aoecombat_value = data.medal_aoecombat_value or inst.medal_aoecombat_value
				inst.blood_honey_mark = data.blood_honey_mark or inst.blood_honey_mark
				inst.medal_poison_mark = data.medal_poison_mark or inst.medal_poison_mark
				inst.injured_damage = data.injured_damage or inst.injured_damage
				inst.medal_merm_curse = data.medal_merm_curse or inst.medal_merm_curse
				inst.medal_rewardtoiler_mark = data.medal_rewardtoiler_mark or inst.medal_rewardtoiler_mark
				inst.medal_confused_mark = data.medal_confused_mark or inst.medal_confused_mark
			end
		end
		--移除玩家身上的暗影仆从
		local oldOnDespawn = inst.OnDespawn
		inst.OnDespawn = function(inst, migrationdata, ...)
			if migrationdata ~= nil then
				ForceDespawnMedalShadowMinions(inst)
			end
			if oldOnDespawn then
				oldOnDespawn(inst,migrationdata, ...)
			end
		end
	end
end)

AddPrefabPostInit("player_classified",function(inst)
	--添加物品详细信息
	inst.medal_info = ""--详细信息
	inst.net_medal_info = _G.net_string(inst.GUID, "medal_info", "medal_infodirty")
	--获取玩家视角方向
	inst.medalcameraheading = _G.net_shortint(inst.GUID, "medalcameraheading", "medalcameraheadingdirty")
	inst.medalcameraheading:set(45)--默认视角方向
	--玩家是否受到蜂毒伤害
	inst.medal_injured = _G.net_bool(inst.GUID, "medal_injured", "medal_injureddirty")
	
	if TheNet:GetIsClient() or (TheNet:GetIsServer() and not TheNet:IsDedicated()) then
		--添加物品详细信息
		inst:ListenForEvent("medal_infodirty",function(inst)
			inst.medal_info = inst.net_medal_info:value()
		end)
		--玩家中蜂毒后的受伤界面显示
		inst:ListenForEvent("medal_injureddirty",function(inst)
			if inst._parent and inst._parent.HUD then
				if inst.medal_injured:value() then
					inst._parent.HUD.medal_injured:Flash()
				end
			end
		end)
	end
end)

---------------------------------------------------------------------------------------------------------
---------------------------------------------修改预制物--------------------------------------------------
---------------------------------------------------------------------------------------------------------
--给植物人增加一个活木制作者标签
AddPrefabPostInit("wormwood",function(inst)
	inst:AddTag("livinglogbuilder")
end)

--机器人吃带电料理充电
AddPrefabPostInit("wx78",function(inst)
	if TheWorld.ismastersim then
		if inst.components.eater ~= nil then
			local old_oneatfn = inst.components.eater.oneatfn
			inst.components.eater:SetOnEatFn(function(inst,food, ...)
				if old_oneatfn then
					old_oneatfn(inst,food, ...)
				end
				--确保原本这个食物是不能充电的,不然就重复充电了
				if TUNING.WX78_CHARGING_FOODS[food.prefab]==nil then
					local fooddata = medal_spicedfoods and medal_spicedfoods.spicedfoods and  medal_spicedfoods.spicedfoods[food.prefab]
					--撒了勋章调料的羊角冻或者撒了带电果冻粉的任意料理，都能给机器人充一格电
					if fooddata and (fooddata.basename=="voltgoatjelly" or fooddata.spice=="SPICE_VOLTJELLY") then
						if inst.components.upgrademoduleowner then
							inst.components.upgrademoduleowner:AddCharge(1)
						end
					end
				end
			end)
		end
	end
end)

--统计玩家可携带灵魂上限
local function GetSoulMaxCount(inst)
    local max_count = TUNING.WORTOX_MAX_SOULS -- 最大灵魂上限
    local souljars = 0 -- 灵魂罐子数量
    local souljar_souls = 0 -- 所有灵魂罐子里的灵魂总数量
	local already_soulstealer = inst.medal_tag and inst.medal_tag.soulstealer and inst.medal_tag.soulstealer > 1--原本就是灵魂吞噬者
    -- 统计玩家身上的灵魂罐子
    inst.components.inventory:ForEachItemSlot(function(item)
        if item.prefab == "wortox_souljar" then
            souljars = souljars + 1
            souljar_souls = souljar_souls + item.soulcount
        end
    end)
    -- 获取玩家手持的灵魂罐子
    local activeitem = inst.components.inventory:GetActiveItem()
    if activeitem and activeitem.prefab == "wortox_souljar" then
        souljars = souljars + 1
        souljar_souls = souljar_souls + activeitem.soulcount
    end
    -- 点了技能树那么灵魂罐子会加灵魂携带上限
    if inst.components.skilltreeupdater and inst.components.skilltreeupdater:IsActivated("wortox_souljar_2") then
        max_count = max_count + souljars * TUNING.SKILLS.WORTOX.FILLED_SOULJAR_SOULCAP_INCREASE_PER
    end
	--非原本会灵魂吞噬的角色，戴噬灵勋章时上限为一半，佩戴噬魂、噬空勋章时则相等
	max_count = max_count * (already_soulstealer and 1 or .5 *inst.medal_soulstealer)
	return max_count,souljars,souljar_souls
end

--小恶魔佩戴噬灵勋章时谋杀小动物不会爆魂
AddPrefabPostInit("wortox",function(inst)
	local oldCheckForOverload = inst.CheckForOverload
	if oldCheckForOverload ~= nil then
		inst.CheckForOverload = function(inst, souls, count, ...)
			if inst.medal_soulstealer ~= nil then
				local max_count, souljars, souljar_souls = GetSoulMaxCount(inst)
				--身上的灵魂数量超了
				if count > max_count then
					local medal=inst.components.inventory:EquipMedalWithgroupTag("devoursoulMedal")--获取玩家的噬灵系列勋章
					local neednum = 0--恢复勋章耐久所需数量
					local superfluous_num = count - max_count--溢出的灵魂数量
					if medal and medal.components.finiteuses then
						neednum = math.min(medal.components.finiteuses.total - medal.components.finiteuses:GetUses(), superfluous_num)
					end
					count = max_count

					local pos = inst:GetPosition()
					for _, v in ipairs(souls) do
						local vcount = GetStackSize(v)--统计单个堆叠数量
						if neednum>0 then--优先给勋章加耐久
							local usenum = math.min(vcount, neednum, superfluous_num)
							v.components.stackable:Get(usenum):Remove()
							medal.components.finiteuses:Repair(usenum)--加耐久
							superfluous_num = superfluous_num - usenum
							neednum = neednum - usenum
							vcount = vcount - usenum
						end
						--补完耐久还有剩
						if vcount > 0 and superfluous_num > 0 then
							if vcount <= superfluous_num then--掉落多余的灵魂
								inst.components.inventory:DropItem(v, true, true, pos)
								superfluous_num = superfluous_num - vcount
							else
								v = v.components.stackable:Get(superfluous_num)
								v.Transform:SetPosition(pos:Get())
								v.components.inventoryitem:OnDropped(true)
								superfluous_num = 0
							end
						end
						if superfluous_num <= 0 then break end
					end
				end
				inst.soulcount = count + souljar_souls--更新玩家当前拥有的灵魂数量
			else
				oldCheckForOverload(inst, souls, count, ...)
			end
		end
	end
end)

--------------------------------------修改灵魂碰撞玩家时函数----------------------------------------------
--玩家获取到灵魂时执行的函数(灵魂,玩家,是否有效)
local function medalGetSoul(inst, target, isvaild)
	--获取噬灵勋章
	-- local medal=target.components.inventory:GetEquippedItem(EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY)
	local medal=target.components.inventory:EquipMedalWithgroupTag("devoursoulMedal")--获取玩家的噬灵系列勋章
	local adduses=false--是否添加耐久
	local x, y, z = inst.Transform:GetWorldPosition()
	local fx = SpawnPrefab("wortox_soul_in_fx")
	fx.Transform:SetPosition(x, y, z)
	fx:Setup(target)
	if isvaild and medal then
		if medal.components.finiteuses then
			local uses=medal.components.finiteuses:GetUses()
			if uses<medal.components.finiteuses.total then
				medal.components.finiteuses:SetUses(uses+1)--设置耐久
				adduses=true
			end
		end
	end
	--如果没添加为耐久并且是沃拓克斯，则直接原地掉落
	if (target.prefab=="wortox" or HasOriginMedal(target,"medal_map_blinker")) and not adduses then
		fx = SpawnPrefab("wortox_soul")
		fx.Transform:SetPosition(x, y, z)
		fx.components.inventoryitem:OnDropped(true)
	end
	inst:Remove()
end

--修改灵魂碰撞玩家时的函数
--是否是灵魂
local function IsSoul(item)
    return item.prefab == "wortox_soul"
end
AddPrefabPostInit("wortox_soul_spawn",function(inst)
	if TheWorld.ismastersim then
		if inst.components.projectile then
			local oldHitFn=inst.components.projectile.onhit
			inst.components.projectile:SetOnHitFn(function(inst, attacker, target, ...)
				if target~=nil and target.components.inventory ~= nil then
					--暗夜坎普斯
					if target.prefab=="medal_rage_krampus" then
						if target.components.health and not target.components.health:IsDead() then
							target.components.health:DoDelta(50)
						end
						if target.SpawnHealFx then
							target:SpawnHealFx()--生成吸收灵魂特效
						end
						inst:Remove()
						return
					end
					
					if target.medal_soulstealer~=nil then
						local souls = target.components.inventory:FindItems(IsSoul)--获取玩家身上灵魂
						local count = 0--灵魂数量
						local maxsoulsnum = GetSoulMaxCount(target)--灵魂上限
						for i, v in ipairs(souls) do
							count = count + GetStackSize(v)
						end
						--灵魂超标了才给勋章加耐久
						if count >= maxsoulsnum then
							medalGetSoul(inst, target, true)
							return
						end
					elseif not target:HasTag("soulstealer") then--没勋章的话不是原本就有吞噬能力的角色就别获得灵魂了(防止玩家重复戴/摘勋章来摆脱灵魂上限)
						medalGetSoul(inst, target)
						return
					end
				end
				if oldHitFn ~= nil then
					oldHitFn(inst, attacker, target, ...)
				end
			end)
		end

		local SeekSoulStealer=nil
		if inst._seektask then
			SeekSoulStealer=inst._seektask.fn
			inst._seektask:Cancel()
			inst._seektask=nil
		end
		inst._seektask=inst:DoPeriodicTask(.5, function(inst)
			local x, y, z = inst.Transform:GetWorldPosition()
			local closestRageKrampus = nil
			local rangesq = 100
			local ents=TheSim:FindEntities(x, y, z, 10 ,nil , {"INLIMBO", "NOCLICK", "catchable", "notdevourable"},{"rage_krampus"})
			if #ents>0 then
				for i,v in ipairs(ents) do
					if v.prefab=="medal_rage_krampus" and v.components.health and not v.components.health:IsDead() and v.entity:IsVisible() then
						local distsq = v:GetDistanceSqToPoint(x, y, z)
						if distsq < rangesq then
							rangesq = distsq
							closestRageKrampus = v
						end
					end
				end
			end
			if closestRageKrampus ~= nil then
				--确保不会因为缺少初始速度报错
				if inst.components.projectile.speed == nil  then
					inst.components.projectile:SetSpeed(TUNING.WORTOX_SOUL_PROJECTILE_SPEED)
				end
				inst.components.projectile:Throw(inst, closestRageKrampus, inst)
			elseif SeekSoulStealer then
				SeekSoulStealer(inst)
			end
		end, 1)
	end
end)

--删除蝙蝠飞行标签
AddPrefabPostInit("bat",function(inst)
	if inst:HasTag("flying") then
		inst:RemoveTag("flying")
	end
	inst:AddTag("trap_immunity")--免疫陷阱标签
end)

--给猪人增加友情勋章的获取
AddPrefabPostInit("pigman",function(inst)
	if TheWorld.ismastersim then
		if inst.components.trader then
			local oldOnacceptFn=inst.components.trader.onaccept
			inst.components.trader.onaccept = function(inst, giver, item, ...)
				if item.prefab=="taffy" then
					if giver.friendlymonster then
						giver:PushEvent("gainfriendship")
						item:Remove()--拿到糖果直接删掉，防止利用一颗糖果重复刷勋章
					end
				end
				if oldOnacceptFn~=nil then
					oldOnacceptFn(inst, giver, item, ...)
				end
			end
		end
	end
end)

--眼球草吃下食物后推送事件
AddPrefabPostInit("eyeplant",function(inst)
	if TheWorld.ismastersim then
		inst:ListenForEvent("gotnewitem", function(inst,data)
			if data and data.item and data.item.prefab=="medal_spacetime_snacks" then
				if inst.minionlord then
					inst.minionlord:PushEvent("hidebait")
				end
			end
		end)
	end
end)

--修改食人花选择诱饵函数
AddPrefabPostInit("lureplant",function(inst)
	if TheWorld.ismastersim then
		local oldlurefn = inst.lurefn
		inst.lurefn = function(inst, ...)    
			if inst.components.inventory ~= nil then
				--遍历食人花的容器
				for k = 1, inst.components.inventory.maxslots do
					local item = inst.components.inventory.itemslots[k]
					if item then
						--有零食的话就转换成吞噬法杖
						if item.prefab == "medal_spacetime_snacks" then
							local getitem=inst.components.inventory:RemoveItem(item)
							local staff=SpawnPrefab("devour_staff")
							inst.components.inventory:GiveItem(staff)
							getitem:Remove()
							return staff
						--有吞噬法杖就直接长出来
						elseif item.prefab=="devour_staff" then
							return item
						end
					end
				end
			end

			if oldlurefn then
				return oldlurefn(inst, ...)
			end
		end
		--hook食人花的采摘函数，采摘时推送事件给玩家(食人花手杖用)
		if inst.components.shelf then
			local oldontakeitemfn=inst.components.shelf.ontakeitemfn
			inst.components.shelf.ontakeitemfn=function(inst,taker)
				--如果有诱饵，并且诱饵是叶肉，则给玩家推送拿取叶肉事件
				if inst.lure and inst.lure.prefab and inst.lure.prefab=="plantmeat" then
					taker:PushEvent("takesomething", { object = inst })
				end
				if oldontakeitemfn then
					oldontakeitemfn(inst,taker)
				end 
			end
		end
	end
end)

--给岩浆池添加钓鱼组件
AddPrefabPostInit("lava_pond",function(inst)
	if TheWorld.ismastersim then
		if inst.components.fishable==nil then
			inst:AddComponent("fishable")
		end
		inst.components.fishable:SetRespawnTime(TUNING_MEDAL.LAVAEEL_RESPAWN_TIME)--重生时间
		inst.components.fishable:AddFish("lavaeel")--设置鱼的品种
		inst.components.fishable.maxfish=TUNING_MEDAL.LAVAEEL_MAX_NUM--设置最大容量
		inst.components.fishable.fishleft=TUNING_MEDAL.LAVAEEL_MAX_NUM--/2--设置初始数量
	end
end)

--给格罗姆添加可喂食功能及分泌格罗姆精华，吃诱人香蕉冰后多拉粑粑
AddPrefabPostInit("glommer",function(inst)
	if TheWorld.ismastersim then
		if inst.components.periodicspawner then
			-- inst.components.periodicspawner:SetRandomTimes(10,5)--加快吐粘液速度，测试用
			local oldonspawn = inst.components.periodicspawner.onspawn
			inst.components.periodicspawner:SetOnSpawnFn(function(inst,fuel, ...)
				if oldonspawn then
					oldonspawn(inst,fuel, ...)
				end
				--额外掉落格罗姆精华
				local essence_num = inst.is_diarrhea and math.random(3,4) or 1
				if inst.components.lootdropper then
					for i = 1, essence_num do
						inst.components.lootdropper:SpawnLootPrefab("medal_glommer_essence")
					end
				end
				inst.is_diarrhea=nil
			end)
		end
		local oldSaveFn=inst.OnSave
		local oldLoadFn=inst.OnLoad
		inst.OnSave = function(inst,data)
			if oldSaveFn~=nil then
				oldSaveFn(inst,data)
			end
			if inst.is_diarrhea then
				data.is_diarrhea=true
			end
		end
		inst.OnLoad = function(inst,data)
			if oldLoadFn~=nil then
				oldLoadFn(inst,data)
			end
			if data~=nil and data.is_diarrhea then
				inst.is_diarrhea=data.is_diarrhea
			end
		end
	end
end)

--给月相盘加个标记
local function moondialInFullmoon(inst,isfullmoon)
	if isfullmoon and not TheWorld.state.isalterawake then
		inst:AddTag("cansalvage")--可打捞标记
	else
		inst:RemoveTag("cansalvage")
	end
end

AddPrefabPostInit("moondial",function(inst)
	if TheWorld.ismastersim then
		inst:WatchWorldState("isfullmoon", moondialInFullmoon)--监听月圆
		--月圆并且处于非结冰状态则可捞月
		moondialInFullmoon(inst,TheWorld.state.isfullmoon)
	end
end)

--------------------------------------给曼德拉草加入曼德拉果产出----------------------------------------------
--开始掉落
local function StartSpawnPollen(inst)
	if inst.components.periodicspawner then
		inst.components.periodicspawner:Start()
	end
end
--停止掉落
local function StopSpawnPollen(inst)
	if inst.components.periodicspawner then
		inst.components.periodicspawner:Stop()
	end
end

AddPrefabPostInit("mandrake_active",function(inst)
	if TheWorld.ismastersim then
		inst:AddComponent("periodicspawner")
        inst.components.periodicspawner:SetPrefab("mandrake_berry")--设置掉落物
        inst.components.periodicspawner:SetRandomTimes(TUNING_MEDAL.MANDARK_BERRY_SPAWNER_TIME, TUNING_MEDAL.MANDARK_BERRY_SPAWNER_TIME_VARIANCE, false)--掉落周期
		inst:ListenForEvent("startfollowing", StartSpawnPollen)
		inst:ListenForEvent("stopfollowing", StopSpawnPollen)
	end
end)

---------------------------------------------智能陷阱-------------------------------------------------
--升级成自动陷阱(inst,是否为加载触发)
local function setAutoTrap(inst,isload)
	inst:AddTag("autoTrap")
	--自动重置
	local oldOnExplode=inst.components.mine and inst.components.mine.onexplode
	if oldOnExplode then
		inst.components.mine:SetOnExplodeFn(function(inst, ...)
			oldOnExplode(inst, ...)
			--在水里不自动重置
			if not inst:IsOnOcean() then
				if inst.auto_task then
					inst.auto_task:Cancel()
					inst.auto_task=nil
				end
				inst.auto_task = inst:DoTaskInTime(TUNING_MEDAL.AUTOTRAP_RESET_TIME, function(inst)
					if inst.components.mine and inst.components.mine.issprung then
						inst.components.mine:Reset()
					end
					inst.auto_task=nil
				end)
			end
		end)
	end
	--加载时如果处于触发后状态，则直接重置
	if inst.components.mine and inst.components.mine.issprung then
		inst.components.mine:Reset()
	end
	if inst.components.finiteuses and not isload then
		inst.components.finiteuses:SetPercent(1)--重置耐久
	end
end
--升级成不朽陷阱
local function setImmortalTrap(inst)
	inst:AddTag("isimmortal")
	if inst.components.finiteuses then
		inst:RemoveComponent("finiteuses")--移除耐久组件
	end
end
--hook陷阱
local function medalHookTrap(inst,alignment)
	--加上智能前缀
	local olddisplaynamefn = inst.displaynamefn
	inst.displaynamefn = function(inst, ...)
		local str = GetMedalDisplayName(inst,olddisplaynamefn, ...)
		-- local str = olddisplaynamefn and olddisplaynamefn(inst) or STRINGS.NAMES[string.upper(inst.prefab)]
		if inst:HasTag("autoTrap") then
			str = subfmt(STRINGS.NAMES.MEDAL_AUTO_TRAP, { trap = str })
		end
		if inst:HasTag("isimmortal") then
			str = subfmt(STRINGS.NAMES.IMMORTAL_ITEM, {item = str})
		end
		return str
	end
	if TheWorld.ismastersim then
		local oldSaveFn=inst.OnSave
		local oldLoadFn=inst.OnLoad
		inst.setAutoTrap = setAutoTrap--升级为智能陷阱函数
		inst.setImmortalTrap = setImmortalTrap--升级为不朽陷阱
		if alignment and inst.components.mine then
			inst.components.mine:SetAlignment(alignment)--不会被带有这个标签的生物触发
		end 
		inst.OnSave = function(inst,data)
			if oldSaveFn~=nil then
				oldSaveFn(inst,data)
			end
			data.autovalue = inst:HasTag("autoTrap")
			data.isimmortal = inst:HasTag("isimmortal")
		end
		inst.OnLoad = function(inst,data)
			if oldLoadFn~=nil then
				oldLoadFn(inst,data)
			end
			if data~=nil then
				if data.autovalue then
					setAutoTrap(inst,true)
				end
				if data.isimmortal then
					setImmortalTrap(inst)
				end
			end
		end
	end
end
AddPrefabPostInit("trap_bramble",function(inst) medalHookTrap(inst,"trap_immunity") end)--荆棘陷阱
AddPrefabPostInit("trap_teeth",function(inst) medalHookTrap(inst,"trap_immunity") end)--狗牙陷阱
AddPrefabPostInit("trap_bat",function(inst) medalHookTrap(inst) end)--蝙蝠陷阱

---------------------------------------------触手不主动攻击拥有触手勋章的玩家-------------------------------------------------
local function tentacleRetarget(inst)
	if TheWorld.ismastersim then
		--修改搜寻目标函数
		if inst.components.combat then
			local targetfn=inst.components.combat.targetfn
			if targetfn then
				local RETARGET_CANT_TAGS = upvaluehelper.Get(targetfn,"RETARGET_CANT_TAGS")
				if RETARGET_CANT_TAGS then
					--不主动攻击拥有高级触手勋章的玩家
					if not table.contains(RETARGET_CANT_TAGS,"senior_tentaclemedal") then
						table.insert(RETARGET_CANT_TAGS,"senior_tentaclemedal")
					end
					--不主动攻击混沌生物
					if not table.contains(RETARGET_CANT_TAGS,"chaos_creature") then
						table.insert(RETARGET_CANT_TAGS,"chaos_creature")
					end
				end
			end
		end
	end
end

AddPrefabPostInit("tentacle",tentacleRetarget)--触手
AddPrefabPostInit("tentacle_pillar_arm",tentacleRetarget)--小触手
AddPrefabPostInit("bigshadowtentacle",tentacleRetarget)--大暗影触手
--暗影触手不会让佩戴了触手勋章的玩家掉san
AddPrefabPostInit("shadowtentacle",function(inst)
	if TheWorld.ismastersim then
		if inst.components.sanityaura then
			inst.components.sanityaura.aurafn = function(inst,observer)
				return observer:HasTag("tentaclemedal") and 0  or inst.components.sanityaura.aura
			end
		end
	end
end)

---------------------------------------------给传送塔添加自由传送功能-------------------------------------------------
AddPrefabPostInit("townportal", function(inst)
	inst.deliverylist = net_string(inst.GUID, "deliverylist")--传送列表
	-- inst:AddTag("_writeable")
	inst:AddComponent("talker")--可对话组件
	if TheWorld.ismastersim then
		-- inst:RemoveTag("_writeable")
		if inst.components.writeable == nil then
			inst:AddComponent("writeable")--可书写组件
		end
		inst:AddComponent("medal_delivery")--自由传送组件
		TheWorld:PushEvent("ms_medal_registertownportal", inst)--注册传送塔
		--修改传送组件消耗函数
		if inst.components.teleporter then
			local oldOnActivate=inst.components.teleporter.onActivate
			inst.components.teleporter.onActivate=function(inst, doer, ...)
				-- if doer:HasTag("has_speed_certificate") then
				if doer.components.inventory and doer.components.inventory:EquipHasTag("speed_certificate") then
					if doer.components.talker ~= nil then
						doer.components.talker:ShutUp()
					end
				elseif oldOnActivate then
					oldOnActivate(inst,doer, ...)
				end
			end
		end
	end
end)

---------------------------------------------蚁狮可以返还等价于打包好的物品价值的石头-------------------------------------------------
--发射奖励
local function LaunchRewards(inst,prefab)
	local rewardnum = inst.medal_rewardnum
	for i=1,inst.medal_rewardnum do
		local reward = SpawnPrefab(prefab or inst.pendingrewarditem)
		if reward then
			local maxsize = reward.components.stackable and reward.components.stackable.maxsize or 1
			if maxsize > 1 and rewardnum > 1 then
				reward.components.stackable:SetStackSize(math.min(rewardnum,maxsize))--可堆叠的话优先堆叠了，不然射出一堆来影响性能
			end
			LaunchAt(reward, inst, (inst.tributer ~= nil and inst.tributer:IsValid()) and inst.tributer or nil, 1, 2, 1)
			rewardnum = rewardnum - maxsize
			if rewardnum <= 0 then
				break
			end
		end
	end
end
AddPrefabPostInit("antlion", function(inst)
	if TheWorld.ismastersim then
		--接收
		local oldonacceptfn = inst.components.trader and inst.components.trader.onaccept
		if oldonacceptfn ~= nil then
			inst.components.trader.onaccept=function(inst,giver,item, ...)
				--如果献祭品有打包组件，则记录奖励数量为献祭品的石头值
				if item.components.unwrappable then
					inst.medal_rewardnum=item.components.tradable.rocktribute
					--如果是包装袋则返还蜡纸
					if item.prefab=="bundle" then
						inst.returnitem="waxpaper"
					end
				end
				oldonacceptfn(inst,giver,item, ...)
			end
		end
		--给予奖励
		local oldGiveReward=inst.GiveReward
		inst.GiveReward=function(inst, ...)
			if inst.medal_rewardnum then
				if inst.pendingrewarditem ~= nil then
					--按照奖励数量发放
					-- for i=1,inst.medal_rewardnum do
					-- 	if type(inst.pendingrewarditem) == "table" then
					-- 		for _, item in ipairs(inst.pendingrewarditem) do
					-- 			LaunchAt(SpawnPrefab(item), inst, (inst.tributer ~= nil and inst.tributer:IsValid()) and inst.tributer or nil, 1, 2, 1)
					-- 		end
					-- 	else
					-- 		LaunchAt(SpawnPrefab(inst.pendingrewarditem), inst, (inst.tributer ~= nil and inst.tributer:IsValid()) and inst.tributer or nil, 1, 2, 1)
					-- 	end
					-- end

					--发射奖励
					if type(inst.pendingrewarditem) == "table" then
						for _, item in ipairs(inst.pendingrewarditem) do
							LaunchRewards(inst,item)
						end
					else
						LaunchRewards(inst)
					end
				end
				--返还蜡纸
				if inst.returnitem then
					LaunchAt(SpawnPrefab(inst.returnitem), inst, (inst.tributer ~= nil and inst.tributer:IsValid()) and inst.tributer or nil, 1, 2, 1)
					inst.returnitem=nil
				end
				inst.medal_rewardnum = nil
				inst.pendingrewarditem = nil
				inst.tributer = nil
			elseif oldGiveReward then
				oldGiveReward(inst, ...)
			end
		end
	end
end)

---------------------------------------------猪王可以返还蜡纸-------------------------------------------------
AddPrefabPostInit("pigking", function(inst)
	if TheWorld.ismastersim then
		if inst.components.trader and inst.components.trader.onaccept then
			local oldonacceptfn=inst.components.trader.onaccept
			inst.components.trader.onaccept=function(inst,giver,item, ...)
				--如果是包装袋则返还蜡纸
				if item.prefab=="bundle" then
					inst:DoTaskInTime(2 / 3, function(item,giver)
						LaunchAt(SpawnPrefab("waxpaper"), inst, giver, 1, 5, 1)
					end)
				end
				oldonacceptfn(inst,giver,item, ...)
			end
			--小鱼妹佩戴鱼人勋章可以和猪王交易
			local oldtest = inst.components.trader.test
			inst.components.trader:SetAcceptTest(function(inst, item, giver, ...)
				if giver:HasTag("merm") and HasOriginMedal(giver,nil,"has_merm_medal") then
					giver = inst--懒得把里面的代码复制一遍了，这边直接用猪王自己代替小鱼妹进行验证,反正猪王不可能会有merm标签吧
				end
				return oldtest and oldtest(inst, item, giver, ...)
			end)
		end
	end
end)

---------------------------------------------月亮孢子可捕捉-------------------------------------------------
AddPrefabPostInit("spore_moon", function(inst)
	if TheWorld.ismastersim then
		if inst.components.workable then
			local oldOnWorkedFn=inst.components.workable.onfinish
			inst.components.workable:SetOnFinishCallback(function(inst, worker, ...)
				local medal_spore_moon=SpawnPrefab("medal_spore_moon")--月亮孢子
				--确保玩家身上还能装月亮孢子，溢出会导致主客机数据不同步报错
				if medal_spore_moon and worker.spore_moon_catcher and worker.components.inventory ~= nil and worker.components.inventory:CanAcceptCount(medal_spore_moon, 1) > 0 then
					worker.components.inventory:GiveItem(medal_spore_moon, nil, inst:GetPosition())
					worker.SoundEmitter:PlaySound("dontstarve/common/butterfly_trap")
					inst:Remove()
				else
					--玩家不能接受月亮孢子就把月亮孢子移除
					if medal_spore_moon then
						medal_spore_moon:Remove()
					end
					if oldOnWorkedFn then
						oldOnWorkedFn(inst,worker, ...)
					end
				end
			end)
		end
	end
end)

---------------------------------------------修改香蕉树桩、月亮蘑菇树桩产物-------------------------------------------------
--香蕉树桩
AddPrefabPostInit("cave_banana_stump",function(inst)
	if TheWorld.ismastersim then
		if inst.components.workable then
			local oldOnWorkFn=inst.components.workable.onwork
			inst.components.workable:SetOnWorkCallback(function(inst,worker, ...)
				--玩家处于可移植状态，则移植，否则给木头
				if worker and worker.medal_transplantman then
					inst.components.lootdropper:SpawnLootPrefab("medaldug_fruit_tree_stump")
					inst:Remove()
				elseif oldOnWorkFn then
					oldOnWorkFn(inst,worker, ...)
				end
			end)
		end
	end
end)
--修改蘑菇树桩挖掘函数
local function mushtree_moon_stump_onfinish(inst)
	if inst.components.workable then
		local oldOnFinishFn=inst.components.workable.onfinish
		inst.components.workable:SetOnFinishCallback(function(inst,worker, ...)
			--玩家处于可移植状态，则移植，否则给木头
			if worker and worker.medal_transplantman and math.random()<TUNING_MEDAL.MEDALDUG_FRUIT_TREE_STUMP_CHANCE then
				inst.components.lootdropper:SpawnLootPrefab("medaldug_fruit_tree_stump")
				inst:Remove()
			elseif oldOnFinishFn then
				oldOnFinishFn(inst,worker, ...)
			end
		end)
	end
end
--hook蘑菇树
AddPrefabPostInit("mushtree_moon",function(inst)
	if TheWorld.ismastersim then
		--蘑菇树桩是先生成蘑菇树再加载成树桩的，所以需要先等它加载完再动手
		inst:DoTaskInTime(0,function(inst)
			--如果本来就是树桩，就直接改造挖掘函数
			if inst:HasTag("stump") then
				mushtree_moon_stump_onfinish(inst)
			else--如果不是树桩，则在它变成树桩的时候改造挖掘函数
				if inst.components.workable then
					local oldOnFinishFn=inst.components.workable.onfinish
					inst.components.workable:SetOnFinishCallback(function(inst,worker, ...)
						oldOnFinishFn(inst,worker, ...)
						mushtree_moon_stump_onfinish(inst)
					end)
				end
			end
		end)
	end
end)

--统一发光浆果方向，治疗强迫症
AddPrefabPostInit("wormlight_plant",function(inst)
	inst.Transform:SetNoFaced()
	if TheWorld.ismastersim then
		inst.Transform:SetRotation(0)
	end
end)

--给耕地加needwater的标签，用于自动浇水
AddPrefabPostInit("nutrients_overlay",function(inst)
	inst:AddTag("needwater")
end)

--hook杀人蜂巢，佩戴蜂王勋章的玩家靠近时不会出杀人蜂
AddPrefabPostInit("wasphive",function(inst)
	if TheWorld.ismastersim then
		if inst.components.playerprox then
			local oldonnear=inst.components.playerprox.onnear
			inst.components.playerprox:SetOnPlayerNear(function(inst, target, ...)
				if target and not target.isbeeking then
					if oldonnear then
						oldonnear(inst, target, ...)
					end
				end
			end)
		end
	end
end)

--修改沃格斯塔夫工具的名字读取规则，佩戴巧手勋章也能读
local function showRealPrefabName(inst)
	local olddisplaynamefn=inst.displaynamefn
	inst.displaynamefn=function(inst, ...)
		if ThePlayer and ThePlayer:HasTag("has_handy_medal") then
			return STRINGS.NAMES[string.upper(inst.prefab)]
		elseif olddisplaynamefn then
			return olddisplaynamefn(inst, ...)
		end
	end
end

AddPrefabPostInit("wagstaff_tool_1",showRealPrefabName)
AddPrefabPostInit("wagstaff_tool_2",showRealPrefabName)
AddPrefabPostInit("wagstaff_tool_3",showRealPrefabName)
AddPrefabPostInit("wagstaff_tool_4",showRealPrefabName)
AddPrefabPostInit("wagstaff_tool_5",showRealPrefabName)

--给石化树添加可硝化标签
AddPrefabPostInit("rock_petrified_tree",function(inst)
	inst:AddTag("nitrifyable")--可硝化
end)

-------------------------------------修改农作物产出--------------------------------------------
local function SetupLoot(lootdropper)
	local inst = lootdropper.inst

	if inst:HasTag("farm_plant_killjoy") then -- if rotten
		lootdropper:SetLoot(inst.is_oversized and inst.plant_def.loot_oversized_rot or {"immortal_essence"})
	elseif inst.components.pickable ~= nil then
		local plant_stress = inst.components.farmplantstress ~= nil and inst.components.farmplantstress:GetFinalStressState() or FARM_PLANT_STRESS.HIGH
		local product=inst.plant_def.product
		if inst.is_oversized then
			lootdropper:SetLoot({inst.plant_def.product_oversized})
		elseif plant_stress == FARM_PLANT_STRESS.LOW or plant_stress == FARM_PLANT_STRESS.NONE then
			lootdropper:SetLoot({product, product, product})--3
		elseif plant_stress == FARM_PLANT_STRESS.MODERATE then
			lootdropper:SetLoot({product, product})--2
		else
			lootdropper:SetLoot({product})--1
		end
	end
end

--对勋章特有作物进行调整(inst,是否具有宿命)
local special_stages = nil
local function MakeMedalFarmPlant(inst,hasdestiny)
	if not TheWorld.ismastersim then return end
	if inst.components.lootdropper then
		inst.components.lootdropper.lootsetupfn = SetupLoot
	end

	if inst.components.growable then
		if special_stages == nil and inst.components.growable.stages ~= nil then
			special_stages = deepcopy(inst.components.growable.stages)
			for i, v in ipairs(special_stages) do
				if v and v.name then
					--移除腐烂时间
					if v.name=="full" then
						v.time=function(inst)
							return nil
						end
					end
					--移除腐烂状态
					if v.name=="rotten" then
						special_stages[i]=nil
					end
				end
			end
		end
		if special_stages ~= nil then
			inst.components.growable.stages = special_stages
		end
	end
	--长成最大状态了就不应该继续生长了
	inst:DoTaskInTime(0,function(inst)
		local growable = inst.components.growable
		if growable then
			local stage = growable:GetStage()
			if growable.stages and growable.stages[stage] and growable.stages[stage].name=="full" then
				growable:StopGrowing()
			end
		end
	end)
end

AddPrefabPostInit("farm_plant_immortal_fruit",function(inst)
	MakeMedalFarmPlant(inst)
end)--不朽果实
AddPrefabPostInit("farm_plant_medal_gift_fruit",function(inst)
	MakeMedalFarmPlant(inst)
end)--包果

--hook随机作物，杂草种子种下的必为杂草
AddPrefabPostInit("farm_plant_randomseed",function(inst)
	if TheWorld.ismastersim then
		inst:ListenForEvent("on_planted",function(inst,data)
			if data and data.seed and data.seed.prefab=="medal_weed_seeds" then
				if inst.components.growable then
					inst.components.growable.is_weed_seed = true
				end
			end
		end)
	end
end)

--hook刺针旋花，能挖出旋花藤
AddPrefabPostInit("weed_ivy",function(inst)
	if TheWorld.ismastersim then
		if inst.components.workable then
			local oldfn = inst.components.workable.onfinish
			inst.components.workable:SetOnFinishCallback(function(inst, ...)
				if inst:HasTag("farm_plant_defender") and inst.components.lootdropper then
					inst.components.lootdropper:SpawnLootPrefab("medal_ivy")
				end
				if oldfn then
					oldfn(inst, ...)
				end
			end)
		end
	end
end)

--农产品秤继承宿命
AddPrefabPostInit("trophyscale_oversizedveggies",function(inst)
	if TheWorld.ismastersim then
		if inst.components.trophyscale then
			--放上去的时候记录宿命
			local oldcomparepostfn = inst.components.trophyscale.compare_postfn
			inst.components.trophyscale:SetComparePostFn(function(item_data, new_inst, ...)
				if oldcomparepostfn then
					oldcomparepostfn(item_data, new_inst, ...)
				end
				if new_inst and new_inst.components.medal_itemdestiny ~= nil then
					item_data.medal_destiny_num = new_inst.components.medal_itemdestiny:GetDestiny()--继承宿命
				end
			end)
			--取下来的时候继承宿命
			local oldonspawnitemfromdatafn = inst.components.trophyscale.onspawnitemfromdatafn
			inst.components.trophyscale:SetOnSpawnItemFromDataFn(function(item, data, ...)
				if oldonspawnitemfromdatafn then
					oldonspawnitemfromdatafn(item, data, ...)
				end
				if data.medal_destiny_num and item.components.medal_itemdestiny ~= nil then
					item.components.medal_itemdestiny:InheritDestiny(nil,data.medal_destiny_num)--继承宿命
				end
			end)
		end
	end
end)

--多汁浆果采摘推送
AddPrefabPostInit("berrybush_juicy",function(inst)
	if TheWorld.ismastersim then
		if inst.components.pickable then
			local oldpickfn=inst.components.pickable.onpickedfn
			inst.components.pickable.onpickedfn=function(inst, picker, ...)
				picker:PushEvent("medal_picksomething", { object = inst})
				if oldpickfn then
					oldpickfn(inst, picker, ...)
				end
			end
		end
	end
end)

--月蛾
AddPrefabPostInit("moonbutterfly",function(inst)
	if TheWorld.ismastersim then
		if inst.components.workable then
			local oldonwork=inst.components.workable.onwork
			inst.components.workable.onwork=function(inst, worker, ...)
				if worker and worker.components.inventory then
					local handitem = worker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
					--可以让月光玻璃网消耗减半
					if handitem and handitem.prefab=="medal_moonglass_bugnet" then
						if handitem.components.finiteuses then
							handitem.components.finiteuses:Use(-1)
						end
					end
				end
				if oldonwork then
					oldonwork(inst, worker, ...)
				end
			end
		end
	end
end)

--鱼人头
AddPrefabPostInit("mermhead",function(inst)
	if TheWorld.ismastersim then
		if inst.components.workable then
			local oldonfinish=inst.components.workable.onfinish
			inst.components.workable.onfinish=function(inst, worker, ...)
				local x,y,z = inst.Transform:GetWorldPosition()
				local players = FindPlayersInRange(x, y, z, 2, true)
				for i, v in ipairs(players) do
					if not worker:HasTag("merm") then--小鱼人或佩戴鱼人勋章的玩家不会受到诅咒
						v:AddDebuff("buff_medal_mermcurse","buff_medal_mermcurse",{curse=inst.awake and 2 or 1})--被破坏了给边上的玩家添加一层鱼人诅咒(月圆额外增加一层)
					end
				end
				if oldonfinish then
					oldonfinish(inst, worker, ...)
				end
			end
		end
	end
end)

--风滚草采摘推送
AddPrefabPostInit("tumbleweed",function(inst)
	if TheWorld.ismastersim then
		if inst.components.pickable then
			local old_onpickedfn = inst.components.pickable.onpickedfn
			inst.components.pickable.onpickedfn=function(inst, picker, ...)
				picker:PushEvent("medal_picksomething", { object = inst})
				return old_onpickedfn and old_onpickedfn(inst, picker, ...)
			end
		end
	end
end)

--暗影高鸟不应该做窝
AddPrefabPostInit("tallbird",function(inst)
	if TheWorld.ismastersim then
		local oldCanMakeNewHome = inst.CanMakeNewHome
		inst.CanMakeNewHome = function(inst, ...)
			if inst.gift_value then return false end
			if oldCanMakeNewHome then
				return oldCanMakeNewHome(inst, ...)
			end
		end
	end
end)

--绝望螨分裂
local function new_do_quickfuse_bomb_toss(inst, ix, iy, iz, angle)
	if inst and inst.divisionable then
		local bomb = SpawnPrefab("fused_shadeling_bomb")
    	bomb.Transform:SetPosition(ix, iy, iz)
		local target = inst.components.entitytracker and inst.components.entitytracker:GetEntity("target")
		if target ~= nil then
			bomb:PushEvent("setexplosiontarget", target)
		end
		--减少孵化时间
		local lefttime = bomb.components.timer and bomb.components.timer:GetTimeLeft("spawn_delay")
		if lefttime then
			bomb.components.timer:SetTimeLeft("spawn_delay", math.clamp(lefttime-2,0.5,1))
		end
		--移速调整
		if inst.components.locomotor and bomb.components.locomotor then
			bomb.components.locomotor.walkspeed = inst.components.locomotor.walkspeed
		end
		bomb.chaos_creature = true--混沌生物
	else
		local quickfuse_bomb = SpawnPrefab("fused_shadeling_quickfuse_bomb")
		quickfuse_bomb.Transform:SetPosition(ix, iy, iz)
		quickfuse_bomb.chaos_creature = inst and inst.chaos_creature--混沌生物
		angle = angle or TWOPI * math.random()
		local speed = 4 + math.random()
		quickfuse_bomb.Physics:Teleport(ix, 0.1, iz)
		quickfuse_bomb.Physics:SetVel(
			speed * math.cos(angle),
			8 + 2 * math.random(),
			speed * math.sin(angle))
	end
end

local old_on_timer_done
local do_quickfuse_bomb_toss
AddPrefabPostInit("fused_shadeling_bomb",function(inst)
	old_on_timer_done = old_on_timer_done or upvaluehelper.GetEventHandle(inst,"timerdone","prefabs/fused_shadeling_bomb")
	if old_on_timer_done then
		do_quickfuse_bomb_toss = do_quickfuse_bomb_toss or upvaluehelper.Get(old_on_timer_done, "do_quickfuse_bomb_toss")
		if do_quickfuse_bomb_toss then
			upvaluehelper.Set(old_on_timer_done,"do_quickfuse_bomb_toss",new_do_quickfuse_bomb_toss)
		end
	end
end)

--暗影秘典召唤暗影仆从的判定条件hook
local CheckMaxSanity
AddPrefabPostInit("waxwelljournal",function(inst)
	if CheckMaxSanity == nil then
		local onselect = inst.components.spellbook and inst.components.spellbook.items and inst.components.spellbook.items[1] and inst.components.spellbook.items[1].onselect
		if onselect then
			CheckMaxSanity = upvaluehelper.Get(onselect, "CheckMaxSanity")
			if CheckMaxSanity then
				upvaluehelper.Set(onselect,"CheckMaxSanity",function(doer, minionprefab)
					local medal = doer and doer.components.inventory:EquipMedalWithName("shadowmagic_certificate")--获取玩家的暗影勋章
					if medal then
						--耐久足够必定能召唤
						if medal.components.finiteuses and medal.components.finiteuses:GetUses() > 0 then
							return true
						--耐久不够并且是临时魔法师，那别召唤了
						elseif IsMedalTempCom(doer,"magician") then
							return false
						end
					end
					return CheckMaxSanity(doer, minionprefab)
				end)
			end
		end
	end
end)

--格罗姆之花只有在枯萎后才能被消耗
AddPrefabPostInit("glommerflower",function(inst)
	inst:AddTag("nocrafting")
	if TheWorld.ismastersim then
		local oldonremovefollower = inst.components.leader and inst.components.leader.onremovefollower
		inst.components.leader.onremovefollower = function(inst, ...)
			if oldonremovefollower ~= nil then
				oldonremovefollower(inst, ...)
			end
			inst:RemoveTag("nocrafting")
		end
		local oldOnPreLoad = inst.OnPreLoad
		inst.OnPreLoad = function(inst, data)
			if oldOnPreLoad ~= nil then
				oldOnPreLoad(inst, data)
			end
			if data ~= nil and data.deadchild then
				inst:RemoveTag("nocrafting")
			end
		end
	end
end)

--拼骨架时若玩家身上有怪物图鉴和暗影碎布，则优先拼出驱光遗骸所需的骨架形状
AddPrefabPostInit("fossil_stalker",function(inst)
	if TheWorld.ismastersim then
		local oldonrepaired = inst.components.repairable and inst.components.repairable.onrepaired
		inst.components.repairable.onrepaired = function(inst, doer, ...)
			if oldonrepaired ~= nil then
				oldonrepaired(inst, doer, ...)
			end
			if inst.moundsize and inst.moundsize == 5 and inst.form ~= 2
			and doer ~= nil and doer.components.inventory and doer.components.inventory:Has("monster_book", 1) and doer.components.inventory:Has("voidcloth", 1) then
				inst.form = 2
				inst.AnimState:PlayAnimation(tostring(inst.form).."_"..tostring(inst.moundsize))
			end
		end
	end
end)

--月树最大状态时可采摘
local moontree_stages = nil
AddPrefabPostInit("moon_tree",function(inst)
	if not TheWorld.ismastersim then return end
	if inst.components.growable then
		if moontree_stages == nil and inst.components.growable.stages ~= nil then
			moontree_stages = deepcopy(inst.components.growable.stages)
			
			for i, v in ipairs(moontree_stages) do
				if v and v.name == "tall" then
					local oldfn = v.fn
					v.fn = function(inst, ...)
						if oldfn then
							oldfn(inst, ...)
						end
						inst:AddTag("medal_harvestable")--最大形态可采摘
					end
				else
					local oldfn = v.fn
					v.fn = function(inst, ...)
						if oldfn then
							oldfn(inst, ...)
						end
						inst:RemoveTag("medal_harvestable")--非最大形态不可采摘
					end
				end
			end
		end
		if moontree_stages ~= nil then
			inst.components.growable.stages = moontree_stages
		end
	end
end)

--整组消化食物
local function DigestAllFood(inst, food)
    local prefab = nil
	if food.components.edible.foodtype == FOODTYPE.MEAT then
        if inst.components.occupiable and inst.components.occupiable:GetOccupant() and inst.components.occupiable:GetOccupant():HasTag("bird_mutant") then
            prefab = "rottenegg"
        else
            prefab = "bird_egg"
        end
    else
        if inst.components.occupiable and inst.components.occupiable:GetOccupant() and inst.components.occupiable:GetOccupant():HasTag("bird_mutant") then
            prefab = "spoiled_food"
        else
            local seed_name = string.lower(food.prefab .. "_seeds")
            if PREFABDEFINITIONS[seed_name] ~= nil then
    			prefab = seed_name
            else
                prefab = "guano"--鸟粪
            end
        end
    end

	if prefab ~= nil then
		local rewardnum = food.components.stackable and food.components.stackable:StackSize() or 1
		for i=1,rewardnum do
			local loot = SpawnPrefab(prefab)
			if loot ~= nil then
				local maxsize = loot.components.stackable and loot.components.stackable.maxsize or 1
				if maxsize > 1 and rewardnum > 1 then
					loot.components.stackable:SetStackSize(math.min(rewardnum,maxsize))--可堆叠的话优先堆叠了，不然射出一堆来影响性能
				end
				inst.components.lootdropper:FlingItem(loot)
				if prefab == "guano" then
					loot.Transform:SetScale(.33, .33, .33)
				end
				rewardnum = rewardnum - maxsize
				if rewardnum <= 0 then
					break
				end
			end
		end
	end

    --鸟的饱食度回满
    local bird = (inst.components.occupiable and inst.components.occupiable:GetOccupant()) or nil
    if bird and bird:IsValid() and bird.components.perishable then
        bird.components.perishable:SetPercent(1)
    end
end

--整组喂鸟
AddPrefabPostInit("birdcage",function(inst)
	if not TheWorld.ismastersim then return end
	inst.Medal_OnGetAllItem = function(inst, giver, item)
		--睡着了？给我醒！
		if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
			inst.components.sleeper:WakeUp()
		end
		if item.components.edible ~= nil and
			(   item.components.edible.foodtype == FOODTYPE.MEAT
				or item.prefab == "seeds"
				or string.match(item.prefab, "_seeds")
				or PREFABDEFINITIONS[string.lower(item.prefab .. "_seeds")] ~= nil
			) then
			inst.AnimState:PlayAnimation("peck")
			inst.AnimState:PushAnimation("peck")
			inst.AnimState:PushAnimation("peck")
			inst.AnimState:PushAnimation("hop")
			inst.AnimState:PushAnimation("idle"..inst.CAGE_STATE, true)
			inst:DoTaskInTime(60 * FRAMES, DigestAllFood, item)
		end
	end
end)

--灵液箱透明化
AddPrefabPostInit("gelblob_storage",function(inst)
	if not TheWorld.ismastersim then return end
	if inst.components.inventoryitemholder == nil then return end
	--设置透明状态
	inst.medal_SetInvisible = function(inst,needshow)
		local need_hide = not needshow and inst.medal_invisible and inst.components.inventoryitemholder and inst.components.inventoryitemholder:IsHolding() or false
		if inst.medal_hide_symbol ~= need_hide then
			inst.medal_hide_symbol = need_hide--记录下状态,下次如果是一样的就没必要再执行一遍了
			if need_hide then
				inst.AnimState:HideSymbol("goop_parts")
				inst.AnimState:HideSymbol("red")
				inst.AnimState:HideSymbol("gelbolob_storage01")
				inst.AnimState:HideSymbol("shine")
				inst.AnimState:HideSymbol("goo_part")
			else
				inst.AnimState:ShowSymbol("goop_parts")
				inst.AnimState:ShowSymbol("red")
				inst.AnimState:ShowSymbol("gelbolob_storage01")
				inst.AnimState:ShowSymbol("shine")
				inst.AnimState:ShowSymbol("goo_part")
			end
		end
	end
	--放入
	local oldonitemgivenfn = inst.components.inventoryitemholder.onitemgivenfn
	inst.components.inventoryitemholder:SetOnItemGivenFn(function(inst, ...)
		if oldonitemgivenfn ~= nil then oldonitemgivenfn(inst, ...) end
		inst:medal_SetInvisible()
	end)
	--取出
	local oldonitemtakenfn = inst.components.inventoryitemholder.onitemtakenfn
	inst.components.inventoryitemholder:SetOnItemTakenFn(function(inst, ...)
		if oldonitemtakenfn ~= nil then oldonitemtakenfn(inst, ...) end
		inst:medal_SetInvisible(true)--这时候Holding状态还没解除，所以要强制显示
	end)
	local oldSaveFn=inst.OnSave
	local oldLoadFn=inst.OnLoad
	inst.OnSave = function(inst,data)
		if oldSaveFn~=nil then
			oldSaveFn(inst,data)
		end
		if inst.medal_invisible then
			data.medal_invisible = inst.medal_invisible
		end
	end
	inst.OnLoad = function(inst,data)
		if oldLoadFn~=nil then
			oldLoadFn(inst,data)
		end
		if data~=nil and data.medal_invisible then
			inst.medal_invisible = data.medal_invisible
			inst:medal_SetInvisible()
		end
	end
end)

---------------------------------------------------------------------------------------------------------
-------------------------------------------批量修改预制物------------------------------------------------
---------------------------------------------------------------------------------------------------------
--给弹弓添加射击事件推送
local function SetMedalSlingShot(inst)
	if not TheWorld.ismastersim then return end
	if inst.components.weapon then
		local old_onprojectilelaunched = inst.components.weapon.onprojectilelaunched
		inst.components.weapon:SetOnProjectileLaunched(function(inst, attacker, target, proj, ...)
			if attacker and attacker:HasTag("has_childishness") then
				attacker:PushEvent("medal_shoot",{ammo = proj})--给玩家推送射击事件，获取子弹信息
			end
			if old_onprojectilelaunched then
				old_onprojectilelaunched(inst, attacker, target, proj, ...)
			end
		end)
	end
end

AddPrefabPostInitAny(function(inst)
	--给背包增加不朽功能
	if inst:HasTag("backpack") then
		SetImmortalable(inst)
	end

	--给弹弓添加射击事件推送
	if inst:HasTag("slingshot") then
		SetMedalSlingShot(inst)
	end
	
	--给海洋鱼加build参数，防止钓鱼时报错
	if inst:HasTag("oceanfish") and not inst:HasTag("swimming") then
		if TheWorld.ismastersim then
			inst.build = inst.prefab
		end
	end
	
	--给龙虾加build参数，防止钓鱼时报错
	if inst.prefab=="wobster_sheller_land" or inst.prefab=="wobster_moonglass_land" then
		if TheWorld.ismastersim then
			inst.build = inst.prefab
		end
	end
end)

---------------------------------------------------------------------------------------------------------
----------------------------------------------修改组件---------------------------------------------------
---------------------------------------------------------------------------------------------------------

--修改workable组件中的破坏函数、workedby函数，防止熊大、火药等因素破坏原本不可移植的植物
AddComponentPostInit("workable", function(self,inst)
	-- self.medal_work_limit = 10--单次工作次数上限
	local oldDestroyFn=self.Destroy
	self.Destroy=function (self,destroyer, ...)
		if self.inst:HasTag("cantdestroy") and self:CanBeWorked() then
			self:WorkedBy(destroyer, 0)
		elseif oldDestroyFn then
			oldDestroyFn(self,destroyer, ...)
		end
	end
	local oldWorkedByFn = self.WorkedBy
	self.WorkedBy=function(self,worker,numworks, ...)
		--伍迪变成海狸也会有groundpounder组件，所以，return！
		if self.inst:HasTag("cantdestroy") and (worker.components.groundpounder ~= nil or not worker:HasTag("player")) then
			numworks = 0
		end
		if oldWorkedByFn then
			oldWorkedByFn(self,worker,numworks, ...)
		end
	end
	local oldWorkedBy_Internal = self.WorkedBy_Internal
	self.WorkedBy_Internal = function(self, worker, numworks, ...)
		if self.medal_work_limit ~= nil then--限制单次工作次数上限,防止大力士秒杀技能或者别的原因一次性给锤爆了
			numworks = math.min(numworks,self.medal_work_limit)
		end
		if oldWorkedBy_Internal ~= nil then
			oldWorkedBy_Internal(self, worker, numworks, ...)
		end
	end
end)


--新增沉默气球、暗影气球制作函数
--[[
AddComponentPostInit("balloonmaker", function(self)
	function self:MakeMedalBalloon(x,y,z,isshadow)
		local balloon = isshadow and SpawnPrefab("shadow_balloon") or SpawnPrefab("medal_balloon")
		if balloon then
			balloon.Transform:SetPosition(x,y,z)
		end
	end
end)
]]


--上钩函数
local function DoNibble(inst)
	local fishingrod = inst.components.fishingrod
	if fishingrod and fishingrod.fisherman then
		inst:PushEvent("fishingnibble")
		fishingrod.fisherman:PushEvent("fishingnibble")
		fishingrod.fishtask = nil
	end
end
--修改普通鱼竿等待上钩函数，让垂钓勋章钓鱼更迅速
AddComponentPostInit("fishingrod", function(fishingrod,inst)
	local oldWaitForFishFn=fishingrod.WaitForFish
	fishingrod.WaitForFish=function(self, ...)
		local fishingrodinst = self.inst and self.inst.components.fishingrod
		--是否需要加速钓鱼
		if fishingrodinst and fishingrodinst.fisherman and fishingrodinst.fisherman.medal_fishing_time_mult then
			--如果目标存在且目标有可钓鱼组件
			if self.target and self.target.components.fishable then
				local fishleft = self.target.components.fishable:GetFishPercent()--目标池塘鱼的剩余百分比
				local nibbletime = nil--上钩时间
				if fishleft > 0 then
					local time_mult = fishingrodinst.fisherman.medal_fishing_time_mult or 1--咬钩时间倍率
					--上钩时间=math.max((最小等待时间+(1-剩余百分比)*(最大等待时间-最小等待时间))*咬钩时间倍率,1)
					nibbletime = math.max((self.minwaittime + (1.0 - fishleft)*(self.maxwaittime - self.minwaittime))*time_mult,1)
				end
				self:CancelFishTask()
				if nibbletime then
					self.fishtask = self.inst:DoTaskInTime(nibbletime, DoNibble)
				end
			end
		else
			oldWaitForFishFn(self, ...)
		end
	end
	--hook收集函数，给玩家推送钓鱼的池塘
	local oldCollect=fishingrod.Collect
	fishingrod.Collect=function(self, ...)
		--必须在收集完之前推，不然数据就被清掉了
		if self.caughtfish and self.fisherman and self.target then
			self.fisherman:PushEvent("medal_fishingcollect", {fish = self.caughtfish, pond = self.target} )
			self.target:PushEvent("medal_fishingcollect")--给钓鱼池也推一下，更新状态用
		end
		if oldCollect then
			oldCollect(self, ...)
		end
	end
end)


--容器组件
AddComponentPostInit("container", function(self)
	local oldGetSpecificSlotForItem = self.GetSpecificSlotForItem
	self.GetSpecificSlotForItem = function(self,item, ...)
		--勋章直接往融合勋章里塞的时候也要判断下位置
		if self.inst and self.inst:HasTag("multivariate_certificate") and self.GetSpecificMedalSlotForItem then
			return self:GetSpecificMedalSlotForItem(item)
		end
		if oldGetSpecificSlotForItem then
			return oldGetSpecificSlotForItem(self,item, ...)
		end
	end
	
	--新增函数用于获取可装备勋章的格子，优先取空，满则取最后一个
	function self:GetSpecificMedalSlotForItem(item)
		if self.usespecificslotsforitems and self.itemtestfn ~= nil then
			for i = 1, self:GetNumSlots() do
				--如果这个勋章可以装备到格子里
				if self:itemtestfn(item, i) then
					--如果i是最后一格了，直接返回i
					if i>=self:GetNumSlots() then
						return i
					end
					--如果格子为空则返回空格子
					if self:GetItemInSlot(i)==nil then
						return i
					end
				--如果这个勋章有勋章组
				elseif item.grouptag then
					local olditem=self:GetItemInSlot(i)
					if olditem~=nil and olditem.grouptag then
						--替换勋章组相同的勋章
						if item.grouptag == olditem.grouptag then
							return i
						end
					end
				end
			end
		end
	end
	--移除容器内所有物品，并按容器格子编号返回数组
	function self:RemoveAllItemsWithSlot()
		local collected_items = {}
		for i = 1, self.numslots do
		    local item = self:RemoveItemBySlot(i)
		    collected_items[i]=item
		end
			
		return collected_items
	end
	--获取制作材料道具
	-- local oldGetCraftingIngredient = self.GetCraftingIngredient
	-- if oldGetCraftingIngredient then
	-- 	local crafting_priority_fn = upvaluehelper.Get(oldGetCraftingIngredient,"crafting_priority_fn")
	-- 	if crafting_priority_fn then
	-- 		local function new_crafting_priority_fn(a, b)
	-- 			--空白勋章优先消耗没印刻能力的
	-- 			if a.item.prefab == "blank_certificate" and b.item.prefab == "blank_certificate"  then
	-- 				local aisblank = a.item.grouptag and a.item.grouptag=="blank_certificate"
	-- 				local bisblank = b.item.grouptag and a.item.grouptag=="blank_certificate"
	-- 				if aisblank and not bisblank then
	-- 					return true
	-- 				end
	-- 				return false
	-- 			end
	-- 			if a.stacksize == b.stacksize then
	-- 				return a.slot < b.slot
	-- 			end
	-- 			return a.stacksize < b.stacksize --smaller stacks first
	-- 		end
	-- 		upvaluehelper.Set(oldGetCraftingIngredient,"crafting_priority_fn",new_crafting_priority_fn)
	-- 	end
	-- end
	--转移单个道具
	function self:MoveItemFromOneOfSlot(slot, container, opener)
		local item = self:GetItemInSlot(slot)
		if item ~= nil and container ~= nil then
			container = container.components.container
			if container ~= nil and container:IsOpenedBy(opener) then-- and item.components.stackable ~= nil and item.components.stackable:IsStack() then

				self.currentuser = opener
				container.currentuser = opener
				--寻找空位
				local targetslot = nil
				for i = 1, container.numslots do
					if container.slots[i] == nil then
						targetslot = i
						break
					end
				end
				-- print(targetslot)

				--没空位的话就不往里放了
				if targetslot ~= nil and container:CanTakeItemInSlot(item, targetslot) then
					-- local onestack = item.components.stackable:Get(1)
					local onestack = item.components.stackable and item.components.stackable:IsStack() and item.components.stackable:Get(1) or self:RemoveItemBySlot(slot)
					onestack.prevcontainer = nil
					onestack.prevslot = nil

					--Hacks for altering normal inventory:GiveItem() behaviour
					if container.ignoreoverflow ~= nil and container:GetOverflowContainer() == self then
						container.ignoreoverflow = true
					end
					if container.ignorefull ~= nil then
						container.ignorefull = true
					end

					if not container:GiveItem(onestack, targetslot) then
						self.ignoresound = true
						self:GiveItem(onestack, slot, nil, true)
						self.ignoresound = false
					end

					--Hacks for altering normal inventory:GiveItem() behaviour
					if container.ignoreoverflow then
						container.ignoreoverflow = false
					end
					if container.ignorefull then
						container.ignorefull = false
					end
				elseif TheFocalPoint and TheFocalPoint.SoundEmitter then
					TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/click_negative")
				end

				self.currentuser = nil
				container.currentuser = nil
			end
		end
	end
	--没戴本源主厨往红晶锅里丢食材的时候只放单个
	local oldMoveItemFromAllOfSlot = self.MoveItemFromAllOfSlot
	self.MoveItemFromAllOfSlot = function(self, slot, container, opener, ...)
		if container ~= nil and container.prefab == "medal_cookpot" and not HasOriginMedal(opener,"seasoningchef") then
			self:MoveItemFromOneOfSlot(slot, container, opener)
		elseif oldMoveItemFromAllOfSlot then
			--勋章特殊容器的转移位置的时候屏蔽自身,防止左脚踩右脚
			if special_medal_box[self.inst.prefab] ~= nil and container ~= nil and container:HasTag("player") then
				local item = self:GetItemInSlot(slot)
				if item ~= nil then
					item.medal_box_name = self.inst.prefab
				end
			end
			oldMoveItemFromAllOfSlot(self, slot, container, opener, ...)
		end
	end
	--没戴本源主厨往红晶锅里丢食材的时候只放单个
	local oldMoveItemFromHalfOfSlot = self.MoveItemFromHalfOfSlot
	self.MoveItemFromHalfOfSlot = function(self, slot, container, opener, ...)
		if container ~= nil and container.prefab == "medal_cookpot" and not HasOriginMedal(opener,"seasoningchef") then
			self:MoveItemFromOneOfSlot(slot, container, opener)
		elseif oldMoveItemFromHalfOfSlot then
			--勋章特殊容器的转移位置的时候屏蔽自身,防止左脚踩右脚
			-- if special_medal_box[self.inst.prefab] ~= nil and container ~= nil and container:HasTag("player") then
			-- 	local item = self:GetItemInSlot(slot)
			-- 	if item ~= nil then
			-- 		item.medal_box_name = self.inst.prefab
			-- 	end
			-- end
			oldMoveItemFromHalfOfSlot(self, slot, container, opener, ...)
		end
	end
end)
--客机也要处理,不然会有落差
AddPrefabPostInit("container_classified",function(inst)
	if TheWorld.ismastersim then return end
	local oldMoveItemFromAllOfSlot = inst.MoveItemFromAllOfSlot
	inst.MoveItemFromAllOfSlot = function(inst, slot, container, ...)
		if container ~= nil and container.prefab == "medal_cookpot" and not HasOriginMedal(ThePlayer,"seasoningchef") then
			local container_classified = container ~= nil and container.replica.container ~= nil and container.replica.container.classified or nil
			if container_classified ~= nil and container_classified.IsFull and not container_classified:IsFull() then
				SendRPCToServer(RPC.MoveItemFromAllOfSlot, slot, inst._parent, container.replica.container ~= nil and container or nil)
				return
			end
			if TheFocalPoint and TheFocalPoint.SoundEmitter then
				TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/click_negative")
			end
		elseif oldMoveItemFromAllOfSlot then
			oldMoveItemFromAllOfSlot(inst, slot, container, ...)
		end
	end
	local oldMoveItemFromHalfOfSlot = inst.MoveItemFromHalfOfSlot
	inst.MoveItemFromHalfOfSlot = function(inst, slot, container, ...)
		if container ~= nil and container.prefab == "medal_cookpot" and not HasOriginMedal(ThePlayer,"seasoningchef") then
			local container_classified = container ~= nil and container.replica.container ~= nil and container.replica.container.classified or nil
			if container_classified ~= nil and container_classified.IsFull and not container_classified:IsFull() then
				SendRPCToServer(RPC.MoveItemFromHalfOfSlot, slot, inst._parent, container.replica.container ~= nil and container or nil)
				return
			end
			if TheFocalPoint and TheFocalPoint.SoundEmitter then
				TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/click_negative")
			end
		elseif oldMoveItemFromHalfOfSlot then
			oldMoveItemFromHalfOfSlot(inst, slot, container, ...)
		end
	end
end)

--修改解锁配方的读取方式，方便隐藏特殊制作栏
AddComponentPostInit("builder", function(self)
	--黏住了就别做东西了吧？
	local oldCanBuild=self.CanBuild
	self.CanBuild = function(self, ...)
		if self.inst and self.inst:HasTag("pinned") then
			return false
		elseif oldCanBuild then
			return oldCanBuild(self, ...)
		end
	end
end)
--replica也要Hook
AddClassPostConstruct("components/builder_replica", function(self)
    --黏住了就别做东西了吧？
	local oldCanBuild=self.CanBuild
	self.CanBuild = function(self, ...)
		if self.inst and self.inst:HasTag("pinned") then
			return false
		elseif oldCanBuild then
			return oldCanBuild(self, ...)
		end
	end
end)

--修改道具持有者函数，防止勋章盒、调料盒在黑暗中关闭
AddComponentPostInit("inventoryitem", function(self)
	local oldIsHeldBy=self.IsHeldBy
	self.IsHeldBy = function(self,guy, ...)
		if self.owner and self.owner.components.container then
			if self.owner.components.inventoryitem and self.owner.components.inventoryitem.owner == guy then
				return true
			end
		end
		if oldIsHeldBy then
			return oldIsHeldBy(self,guy, ...)
		end
	end
end)

--玩家是否装备了拥有xx标签的勋章
local function isEquipMedalHasTag(player,tag)
	local hastag=false--是否拥有标签
	if player then
		local medal=player.components.inventory and player.components.inventory:GetEquippedItem(EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY)--获取玩家身上勋章
		if medal then
			if medal:HasTag(tag) then
				return true
			end
			--如果是融合勋章则从融合勋章里取对应勋章
			if medal:HasTag("multivariate_certificate") and medal.components.container then
				hastag=medal.components.container:HasItemWithTag(tag,1)
			end
		end
	end
	return hastag
end
--Hook库存组件
AddComponentPostInit("inventory", function(self)
	--玩家是否装备了拥有xx标签的装备(装备融合勋章时也顺带检索融合勋章内的勋章)
	local oldEquipHasTag=self.EquipHasTag
	self.EquipHasTag = function(self,tag, ...)
		return oldEquipHasTag(self,tag, ...) or isEquipMedalHasTag(self.inst,tag)
	end
	--掉落一件装备
	function self:DropOneEquipped()
		for k, v in pairs(self.equipslots) do
			if not (v == nil or v.components.inventoryitem == nil or k=="beard") then
				self:DropItem(v, true, true)
				return v
			end
		end
	end
	--获取玩家装备的指定名字的勋章
	function self:EquipMedalWithName(name)
		local medal=self:GetEquippedItem(EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY)
		if medal then
			if medal.prefab == name then
				return medal
			elseif medal:HasTag("multivariate_certificate") then
				if medal.components.container then
					local medal=medal.components.container:FindItem(function(inst) return inst.prefab==name end)
					if medal then
						return medal
					end
				end
			end
		end
	end
	--获取玩家装备的拥有指定勋章组的勋章
	function self:EquipMedalWithgroupTag(tag)
		local medal=self:GetEquippedItem(EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY)
		if medal then
			if medal:HasTag("multivariate_certificate") then
				if medal.components.container then
					local medal=medal.components.container:FindItem(function(inst) return inst.grouptag and inst.grouptag==tag end)
					if medal then
						return medal
					end
				end
			elseif medal.grouptag and medal.grouptag==tag then
				return medal
			end
		end
	end
	--获取玩家装备的拥有指定标签的勋章
	function self:EquipMedalWithTag(tag)
		local medal=self:GetEquippedItem(EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY)
		if medal then
			if medal:HasTag("multivariate_certificate") then
				if medal.components.container then
					local medal=medal.components.container:FindItem(function(inst) return inst:HasTag(tag) end)
					if medal then
						return medal
					end
				end
			elseif medal:HasTag(tag)then
				return medal
			end
		end
	end
	--融合勋章、勋章盒等不自动关闭
	local oldHide=self.Hide
	self.Hide = function(self, ...)
		local medal_loot={}
		for k, v in pairs(self.opencontainers) do
			if k:HasTag("multivariate_certificate") or special_medal_box[k.prefab] or k.prefab=="slingshot" then
				if k.components.container then
					for opener, _ in pairs(k.components.container.openlist) do
					    if k.components.inventoryitem and k.components.inventoryitem:IsHeldBy(opener) then
							table.insert(medal_loot,{medal=k,doer=opener})
						end
					end
				end
			end
		end
		
		if oldHide then
			oldHide(self, ...)
		end
		
		if #medal_loot>0 then
			for k,v in ipairs(medal_loot) do
				if v.doer and v.medal and not v.medal.components.container:IsOpen() then
					v.medal.components.container:Open(v.doer)
				end
			end
		end
	end

	--优先入盒逻辑
	local oldGiveItem=self.GiveItem
	self.GiveItem = function(self, inst, slot, src_pos, ...)
		local medal_box_name = inst.medal_box_name
		inst.medal_box_name = nil

		if inst.components.inventoryitem == nil or not inst:IsValid() then
			print("Warning: Can't give item because it's not an inventory item.")
			return
		end
		
		local eslot = self:IsItemEquipped(inst)
		
		if eslot then
			self:Unequip(eslot)
		end
		
		local new_item = inst ~= self.activeitem
		if new_item then
			for k, v in pairs(self.equipslots) do
				if v == inst then
					new_item = false
					break
				end
			end
		end
		
		if inst.components.inventoryitem.owner and inst.components.inventoryitem.owner ~= self.inst then
			inst.components.inventoryitem:RemoveFromOwner(true)
		end
		
		local objectDestroyed = inst.components.inventoryitem:OnPickup(self.inst, src_pos)
		if objectDestroyed then
			return
		end

		
		--优先入盒
		local krampus_chest_container
		if not slot and self.opencontainers then
			--特定物品优先进入专属容器
			for k, v in pairs(self.opencontainers) do
				if medal_box_name ~= k.prefab then--确保不是从同名容器中移出来的,防止自己往自己里移动
					if k.prefab == "medal_krampus_chest_item" then
						krampus_chest_container = k.components.container
					elseif special_medal_box[k.prefab] and k.components.container and k.components.container:ShouldPrioritizeContainer(inst) then
						if k.components.container:GiveItem(inst, nil, src_pos) then
							self.inst:PushEvent("gotnewitem", { item = inst, slot = 1})
							return true
						end
					end
				end
			end
			--坎普斯宝匣里有的东西先进入坎普斯宝匣
			if krampus_chest_container ~= nil then
				for k, v in pairs(krampus_chest_container.slots) do
					if v.prefab == inst.prefab and krampus_chest_container:GiveItem(inst, nil, src_pos) then
						self.inst:PushEvent("gotnewitem", { item = inst, slot = 1})
						return true
					end
				end
			end
		end

		local returnvalue = oldGiveItem and oldGiveItem(self, inst, slot, src_pos, ...)
		--装不下了，就试试看往坎普斯宝匣里塞吧
		if not returnvalue and krampus_chest_container ~= nil then
			return krampus_chest_container:GiveItem(inst, nil, src_pos)
		end
		return returnvalue
	end
	--丢弃
	local oldDropItem = self.DropItem
	self.DropItem = function(self,item, wholestack, randomdir, pos, ...)
		if item == nil or item.components.inventoryitem == nil then
			return
		end
		if wholestack and item.components.stackable and item.components.stackable.drop_single_in_ocean then
			if pos and TheWorld.Map:IsOceanAtPoint(pos.x, pos.y, pos.z) then
				wholestack = false--在海上强制丢弃单个
			end
		end
		if oldDropItem then
			return oldDropItem(self,item, wholestack, randomdir, pos, ...)
		end
	end

	--转移单个道具
	function self:MoveItemFromOneOfSlot(slot, container)
		local item = self:GetItemInSlot(slot)
		if item ~= nil and container ~= nil then
			container = container.components.container
			if container ~= nil and container:IsOpenedBy(self.inst) then-- and item.components.stackable ~= nil and item.components.stackable:IsStack() then
				container.currentuser = self.inst
				--寻找空位
				local targetslot = nil
				for i = 1, container.numslots do
					if container.slots[i] == nil then
						targetslot = i
						break
					end
				end
				--没空位就不往里放了
				if targetslot ~= nil and container:CanTakeItemInSlot(item, targetslot) then
					local onestack = item.components.stackable and item.components.stackable:IsStack() and item.components.stackable:Get(1) or self:RemoveItemBySlot(slot)
					onestack.prevcontainer = nil
					onestack.prevslot = nil
					if not container:GiveItem(onestack, targetslot) then
						self.ignoresound = true
						self:GiveItem(onestack, slot)
						self.ignoresound = false
					end
				elseif TheFocalPoint and TheFocalPoint.SoundEmitter then
					TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/click_negative")
				end

				container.currentuser = nil
			end
		end
	end
	--没戴本源主厨往红晶锅里丢食材的时候只放单个
	local oldMoveItemFromAllOfSlot = self.MoveItemFromAllOfSlot
	self.MoveItemFromAllOfSlot = function(self, slot, container, ...)
		if container ~= nil and container.prefab == "medal_cookpot" and not HasOriginMedal(self.inst,"seasoningchef") then
			self:MoveItemFromOneOfSlot(slot, container)
		elseif oldMoveItemFromAllOfSlot then
			oldMoveItemFromAllOfSlot(self, slot, container, ...)
		end
	end
	--没戴本源主厨往红晶锅里丢食材的时候只放单个
	local oldMoveItemFromHalfOfSlot = self.MoveItemFromHalfOfSlot
	self.MoveItemFromHalfOfSlot = function(self, slot, container, ...)
		if container ~= nil and container.prefab == "medal_cookpot" and not HasOriginMedal(self.inst,"seasoningchef") then
			self:MoveItemFromOneOfSlot(slot, container)
		elseif oldMoveItemFromHalfOfSlot then
			oldMoveItemFromHalfOfSlot(self, slot, container, ...)
		end
	end
end)
--客机也要处理,不然会有落差
AddPrefabPostInit("inventory_classified",function(inst)
	if TheWorld.ismastersim then return end
	local oldMoveItemFromAllOfSlot = inst.MoveItemFromAllOfSlot
	inst.MoveItemFromAllOfSlot = function(inst, slot, container, ...)
		if container ~= nil and container.prefab == "medal_cookpot" and not HasOriginMedal(ThePlayer,"seasoningchef") then
			local container_classified = container ~= nil and container.replica.container ~= nil and container.replica.container.classified or nil
			if container_classified ~= nil and container_classified.IsFull and not container_classified:IsFull() then
				SendRPCToServer(RPC.MoveInvItemFromAllOfSlot, slot, container)
				return
			end
			if TheFocalPoint and TheFocalPoint.SoundEmitter then
				TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/click_negative")
			end
		elseif oldMoveItemFromAllOfSlot then
			oldMoveItemFromAllOfSlot(inst, slot, container, ...)
		end
	end
	local oldMoveItemFromHalfOfSlot = inst.MoveItemFromHalfOfSlot
	inst.MoveItemFromHalfOfSlot = function(inst, slot, container, ...)
		if container ~= nil and container.prefab == "medal_cookpot" and not HasOriginMedal(ThePlayer,"seasoningchef") then
			local container_classified = container ~= nil and container.replica.container ~= nil and container.replica.container.classified or nil
			if container_classified ~= nil and container_classified.IsFull and not container_classified:IsFull() then
				SendRPCToServer(RPC.MoveItemFromHalfOfSlot, slot, container)
				return
			end
			if TheFocalPoint and TheFocalPoint.SoundEmitter then
				TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/click_negative")
			end
		elseif oldMoveItemFromHalfOfSlot then
			oldMoveItemFromHalfOfSlot(inst, slot, container, ...)
		end
	end
end)

--修改玩家体温调整函数，使玩家在特定情况下不会过冷过热
AddComponentPostInit("temperature", function(self)
	local oldSetTemperature=self.SetTemperature
	self.SetTemperature = function(self,value, ...)
		local inventory=self.inst.components.inventory
		if inventory and inventory:EquipHasTag("nooverheat") then
			value=math.min(value,64)
		end
		if inventory and inventory:EquipHasTag("nofreezing") then
			value=math.max(value,6)
		end
		oldSetTemperature(self,value, ...)
	end
end)

--修改包装组件的打包函数，如果打包后的包裹里有可以献祭的物品则给包裹赋予同等价值
AddComponentPostInit("unwrappable", function(self)
	local oldWrapItems=self.WrapItems
	self.WrapItems = function(self,items, ...)
		if #items > 0 then
			local gold=0
			local rock=0

			for k,v in ipairs(items) do
				is_string = (type(v) == "string")
				item = (is_string and SpawnPrefab(v)) or v
				if item.components.tradable then
					local count = item.components.stackable and item.components.stackable.stacksize or 1
					if item.components.tradable.goldvalue then
						gold = gold + item.components.tradable.goldvalue * count
					end
					if item.components.tradable.rocktribute then
						rock = rock + item.components.tradable.rocktribute * count
					end
				end
				if is_string then
					item:Remove()
				end
			end
			if gold+rock>0 then
				if self.inst.components.tradable==nil then
					self.inst:AddComponent("tradable")
				end
				--价值继承=clamp(floor(总价值*继承倍率),1,200)
				self.inst.components.tradable.goldvalue=math.clamp(math.floor(gold*TUNING_MEDAL.BUNDLE_VALUE_DISCOUNT), 1, 200)
				self.inst.components.tradable.rocktribute=math.clamp(math.floor(rock*TUNING_MEDAL.BUNDLE_VALUE_DISCOUNT), 1, 200)
			end
		end
		oldWrapItems(self,items, ...)
	end
	--存储价值
	local oldOnSave=self.OnSave
	self.OnSave = function(self)
		local savedata=nil
		if oldOnSave then
			savedata=oldOnSave(self)
		end
		if savedata then
			if self.inst.components.tradable then
				if self.inst.components.tradable.goldvalue and self.inst.components.tradable.goldvalue>0 then
					savedata.goldvalue = self.inst.components.tradable.goldvalue
				end
				if self.inst.components.tradable.rocktribute and self.inst.components.tradable.rocktribute>0 then
					savedata.rocktribute = self.inst.components.tradable.rocktribute
				end
			end
		end
		return savedata
	end
	--读取价值
	local oldOnLoad=self.OnLoad
	self.OnLoad = function(self,data)
		if oldOnLoad then
			oldOnLoad(self,data)
		end
		if data.goldvalue or data.rocktribute then
			if self.inst.components.tradable==nil then
				self.inst:AddComponent("tradable")
			end
			self.inst.components.tradable.goldvalue = data.goldvalue or 0
			self.inst.components.tradable.rocktribute = data.rocktribute or 0
		end
	end
end)

--修改san值计算函数，支持月树花buff
AddComponentPostInit("sanity", function(self)
	local oldDoDelta=self.DoDelta
	self.DoDelta = function(self, delta, ...)
		if self.yueshubuff then
			if self:IsInsanityMode() then
				if delta<0 then
					delta=delta*TUNING_MEDAL.MEDAL_BUFF_SANITYREGEN_ABSORB
				end
			else
				if delta>0 then
					delta=delta*TUNING_MEDAL.MEDAL_BUFF_SANITYREGEN_ABSORB
				end
			end
		end
		if oldDoDelta then
			oldDoDelta(self, delta, ...)
		end
	end
end)

--轮回公告
local function DoMedalReincarnationAnnounce(inst,afflicter,cause)
	if inst == nil then return end
	local deathpkname = nil--主谋名字(比如召唤的龙卷风、跟班之类的杀死的，实际上的主使者就是召唤、收买它们的人)
	local deathbypet = nil--是否是被跟班杀死的
	if afflicter == nil then
		deathpkname = nil
	elseif afflicter.overridepkname ~= nil then
		deathpkname = afflicter.overridepkname
		deathbypet =afflicter.overridepkpet
	else
		local killer = afflicter.components.follower ~= nil and afflicter.components.follower:GetLeader() or nil
		if killer ~= nil and
			killer.components.petleash ~= nil and
			killer.components.petleash:IsPet(afflicter) then
			deathbypet = true
		else
			killer = afflicter
		end
		deathpkname = killer:HasTag("player") and killer:GetDisplayName() or nil
	end
	local source = cause or "unknown"--死因
	local announcement_string = ""
	if deathpkname ~= nil then
		local petname = deathbypet and STRINGS.NAMES[string.upper(source)] or nil
		if petname ~= nil then
			source = string.format(STRINGS.UI.HUD.DEATH_PET_NAME, deathpkname, petname)
		else
			source = deathpkname
		end
	elseif table.contains(GetActiveCharacterList(), source) then
		source = FirstToUpper(source)
	else
		source = string.upper(source)
		if source == "NIL" then
			if inst == "WAXWELL" then
				source = "CHARLIE"
			else
				source = "DARKNESS"
			end
		elseif source == "UNKNOWN" then
			source = "SHENANIGANS"
		elseif source == "MOOSE" then
			if math.random() < .5 then
				source = "MOOSE1"
			else
				source = "MOOSE2"
			end
		end
		source = STRINGS.NAMES[source] or STRINGS.NAMES.SHENANIGANS
	end
	announcement_string = inst:GetDisplayName()..STRINGS.MEDAL_ANNOUNCE.REINCARNATION1..source..STRINGS.MEDAL_ANNOUNCE.REINCARNATION2
	TheNet:Announce(announcement_string)
end

--修改health计算函数，支持凝血buff
AddComponentPostInit("health", function(self)
	self.medal_delay_damage = 0--时之伤
	self.medal_parasitic_value = 0--寄生值
	--增减时之伤
	self.DoDeltaMedalDelayDamage = function(self,amount)
		if amount ~= nil then
			--增值的时候做个延迟，防止时之伤和伤害同时被触发
			self.inst:DoTaskInTime(amount>0 and 0.1 or 0, function()
				self.medal_delay_damage = self.medal_delay_damage or 0
				self.medal_delay_damage = math.max(0,math.ceil(self.medal_delay_damage + amount))
				if self.inst and self.inst:HasTag("player") and self.inst.userid then
					if TheWorld and TheWorld.components.medal_infosave and TheWorld.components.medal_infosave.medal_delay_damage_data then
						TheWorld.components.medal_infosave.medal_delay_damage_data[self.inst.userid] = self.medal_delay_damage
					end
				end
			end)
		end
	end
	--消耗时之伤
	self.ConsumeMedalDelayDamage = function(self,cause,amount)
		self.inst:DoTaskInTime(0, function()
			if amount and amount<0 and cause~="medal_delay_damage" and self.medal_delay_damage and self.medal_delay_damage>0 then
				if self.inst.components.health and not self.inst.components.health:IsDead() then
					if self.inst.components.timer==nil or not self.inst.components.timer:TimerExists("medal_delay_damage_cd") then
						--时之伤CD,防止短时间内掉血过快(时间流逝3秒，其他1秒)
						if self.inst.components.timer then
							self.inst.components.timer:StartTimer("medal_delay_damage_cd", cause == "oldager_component" and 3 or 1)
						end
						local damage=math.min(math.clamp(math.ceil(self.medal_delay_damage/10),TUNING_MEDAL.MEDAL_DELAY_DAMAGE_MIN,TUNING_MEDAL.MEDAL_DELAY_DAMAGE_MAX),self.medal_delay_damage,self.inst.components.health.currenthealth)
						self.inst.components.health:DoDelta(-damage, false, "medal_delay_damage", true, nil, true)
						self:DoDeltaMedalDelayDamage(-damage)
						-- self.medal_delay_damage=self.medal_delay_damage-math.ceil(damage)
					end
				end
			end
		end)
	end
	--存储时之伤
	local oldOnSave=self.OnSave
	self.OnSave = function(self)
		local savedata=nil
		if oldOnSave then
			savedata=oldOnSave(self)
		end
		if self.medal_delay_damage and self.medal_delay_damage>0 then
			if savedata == nil then savedata = {} end
			savedata.medal_delay_damage=self.medal_delay_damage
		end
		if self.medal_parasitic_value and self.medal_parasitic_value>0 then
			if savedata == nil then savedata = {} end
			savedata.medal_parasitic_value=self.medal_parasitic_value 
		end
		return savedata
	end
	--加载时之伤
	local oldOnLoad=self.OnLoad
	self.OnLoad = function(self,data)
		if data ~= nil then
			if data.medal_delay_damage then
				self.medal_delay_damage = data.medal_delay_damage
			end
			if data.medal_parasitic_value then
				self.medal_parasitic_value = data.medal_parasitic_value
			end
		end
		if oldOnLoad then
			oldOnLoad(self,data)
		end
	end
	--增减寄生值
	self.DoDeltaMedalParasitic = function(self,amount)
		if amount ~= nil then
			self.medal_parasitic_value = self.medal_parasitic_value or 0
			self.medal_parasitic_value = math.max(0,math.ceil(self.medal_parasitic_value + amount))
			if self.inst and self.inst:HasTag("player") and self.inst.userid then
				if TheWorld and TheWorld.components.medal_infosave and TheWorld.components.medal_infosave.medal_parasitic_value_data then
					TheWorld.components.medal_infosave.medal_parasitic_value_data[self.inst.userid] = self.medal_parasitic_value
				end
			end
		end
	end
	local oldDoDelta=self.DoDelta
	self.DoDelta = function(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb, ...)
		--回血的时候会被寄生值截断
		if amount > 0 and self.medal_parasitic_value > 0 then
			local parasitic = math.min(self.medal_parasitic_value , math.ceil(amount * .9))--寄生值消耗
			amount = amount - parasitic
			self.medal_parasitic_value = self.medal_parasitic_value - parasitic
			--给本源之树回血
			if TheWorld and TheWorld.medal_origin_tree ~= nil and TheWorld.medal_origin_tree.DoRecovery then
				TheWorld.medal_origin_tree:DoRecovery(parasitic)--回血
			end
		end
		
		--血糖减伤(时间流逝的伤害不计入减伤范围)
		if amount<0 and cause ~= "oldager_component" then
			--黑暗血糖,减伤拉满
			if self.inst.medal_dark_ningxue then
				amount = amount * TUNING_MEDAL.MEDAL_BUFF_BLOODSUCKING_ABSORB
			--只有血糖,减伤灵活变动
			elseif self.inst.medal_ningxue then
				local chaos_damage = self.inst.medal_chaos_damage or 0--混沌伤害
				--真伤减伤较低
				if ignore_absorb then
					amount = amount * TUNING_MEDAL.MEDAL_BUFF_BLOODSUCKING_ABSORB_LESS
				--混沌伤害减伤较低
				elseif chaos_damage > 0 then
					amount = amount + chaos_damage
					amount = amount * TUNING_MEDAL.MEDAL_BUFF_BLOODSUCKING_ABSORB - chaos_damage * TUNING_MEDAL.MEDAL_BUFF_BLOODSUCKING_ABSORB_LESS
				else
					amount = amount * TUNING_MEDAL.MEDAL_BUFF_BLOODSUCKING_ABSORB
				end
			end
		end
		if self.inst.medal_chaos_damage then
			self.inst.medal_chaos_damage = nil--清空混沌伤害记录
		end
		--实际扣血前对扣血量进行重运算
		if amount<0 and afflicter ~= nil and (self.predelta or afflicter.medal_extra_health_delta) then
			local old_percent = self:GetPercent()

			if old_percent <= self.nonlethal_pct and
				(((cause == "cold" or cause == "hot") and self.nonlethal_temperature) or
				(cause == "hunger" and self.nonlethal_hunger)) then

				return 0
			end

			--额外血量扣除计算
			local extra_amount = 0--额外扣除的血量
			local extra_ignore_absorb--额外伤害是否为真伤
			if afflicter.medal_extra_health_delta then
				extra_amount, extra_ignore_absorb = afflicter.medal_extra_health_delta(self.inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
				if extra_amount < 0 then
					if self.redirect == nil or not self.redirect(self.inst, extra_amount, overtime, cause, ignore_invincible, afflicter, extra_ignore_absorb) then
						if not extra_ignore_absorb then
							extra_amount = extra_amount * math.clamp(1 - (self.playerabsorb ~= 0 and afflicter ~= nil and afflicter:HasTag("player") and self.playerabsorb + self.absorb or self.absorb), 0, 1) * math.clamp(1 - self.externalabsorbmodifiers:Get(), 0, 1)
						end
					end
				end
			end
			
			if self.redirect ~= nil and self.redirect(self.inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb) then
				return 0
			elseif not ignore_invincible and (self:IsInvincible() or self.inst.is_teleporting) then
				return 0
			elseif amount < 0 and not ignore_absorb then
				amount = amount * math.clamp(1 - (self.playerabsorb ~= 0 and afflicter ~= nil and afflicter:HasTag("player") and self.playerabsorb + self.absorb or self.absorb), 0, 1) * math.clamp(1 - self.externalabsorbmodifiers:Get(), 0, 1)
			end
			
			amount = amount + extra_amount--需要加上额外扣除的血量

			--实际扣血前对扣血量重计算
			if self.predelta ~= nil then
				amount = self.predelta(self.inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
			end
		
			self:SetVal(self.currenthealth + amount, cause, afflicter)
		
			self.inst:PushEvent("healthdelta", { oldpercent = old_percent, newpercent = self:GetPercent(), overtime = overtime, cause = cause, afflicter = afflicter, amount = amount })
		
			if self.ondelta ~= nil then
				self.ondelta(self.inst, old_percent, self:GetPercent(), overtime, cause, afflicter, amount)
			end

			self:ConsumeMedalDelayDamage(cause,amount)--消耗时之伤

			return amount
		end
		if oldDoDelta then
			local amount = oldDoDelta(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb, ...)
			self:ConsumeMedalDelayDamage(cause,amount)--消耗时之伤
			return amount
		end
	end
	--濒死轮回
	local oldSetVal = self.SetVal
	self.SetVal = function(self, val, cause, afflicter, ...)
		if val <= 0 and self.currenthealth >0 and self.inst and HasOriginMedal(self.inst,"spacetime_medal") then
			local medal = self.inst.components.inventory and self.inst.components.inventory:EquipMedalWithName("space_time_certificate")--获取玩家的时空勋章
			if medal and medal.components.finiteuses and medal.components.finiteuses:GetUses() >= TUNING_MEDAL.SPEED_MEDAL.REINCARNATION_CONSUME then
				medal.components.finiteuses:Use(TUNING_MEDAL.SPEED_MEDAL.REINCARNATION_CONSUME)
				local old_health = self.currenthealth
				-- local max_health = self:GetMaxWithPenalty()
				self.currenthealth = 0
				--坠入时空塌陷
				if self.inst.sg~=nil and not (self.inst.sg:HasStateTag("fallhole") or self.inst.sg:HasStateTag("dead") or self.inst:HasTag("playerghost")) then
					local x,y,z = self.inst.Transform:GetWorldPosition()
					local sinkhole = SpawnPrefab("medal_sinkhole")--时空塌陷
					if sinkhole then
						sinkhole.no_destructive = true--无破坏效果，只做个表现
						sinkhole.Transform:SetPosition(x,y,z)
						sinkhole:PushEvent("startcollapse")
					end
					self.inst.sg:GoToState("fall_into_black_hole",{pos={x=x,y=0,z=z}, savehealth = old_health})
				else--无法正常进入时空塌陷的话，直接给玩家添加重生buff
					if self.inst.components.oldager then--旺达需要特殊回复血量,不过也就续个40秒了，趁着没死赶紧跑吧
						self.inst.components.oldager:StopDamageOverTime()
					end
					self.currenthealth = old_health
					self.inst:AddDebuff("spawnprotectionbuff", "spawnprotectionbuff")
				end
				-- self.currenthealth = max_health
				DoMedalReincarnationAnnounce(self.inst,afflicter,cause)--公告
				
				return 
			end
		end
		if oldSetVal then
			oldSetVal(self, val, cause, afflicter, ...)
		end
	end
end)

--饱食度组件新增饱食度下降函数方便箭头显示
AddComponentPostInit("hunger", function(self)
	self.GetBurnrateModifiers = function(self)
		if self.inst.medal_hungerrate then
			local burnrate = self.burnrate*self.burnratemodifiers:Get()
			if self.inst.medal_hungerrate:value() and self.inst.medal_hungerrate:value()~=burnrate then
				self.inst.medal_hungerrate:set(self.burnrate*self.burnratemodifiers:Get())
			end
		end
	end
	local oldDoDelta=self.DoDelta
	self.DoDelta = function(self, amount, ...)
		if self.GetBurnrateModifiers then
			self:GetBurnrateModifiers()
		end
		if oldDoDelta then
			oldDoDelta(self, amount, ...)
		end
	end
end)

--修改海钓竿组件,钓到鱼时推送对应事件
AddComponentPostInit("oceanfishingrod", function(self)
	local oldCatchFish=self.CatchFish
	self.CatchFish = function(self, ...)
		if self.target ~= nil and self.target.components.oceanfishable ~= nil then
			-- print(self.fisher.prefab.."钓到了"..self.target.prefab)
			-- self.fisher:PushEvent("medal_oceanfishingcollect",{fish=self.target})
			self.fisher:PushEvent("medal_fishingcollect", {fish = self.target} )
		end
		if oldCatchFish then
			oldCatchFish(self, ...)
		end
	end
end)

--修改可钓鱼组件，让玩家可钓到遗失塑料袋
AddComponentPostInit("fishable", function(self)
	local oldHookFish=self.HookFish
	self.HookFish = function(self,fisherman, ...)
		if fisherman and fisherman:HasTag("medal_fishingrod") then
			local rod = fisherman.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)--钓竿
			if rod.GetLossPouch then
				local product = rod:GetLossPouch(self.inst,fisherman)
				if product then
					local fish=SpawnPrefab(product)
					if fish ~= nil then
						self.hookedfish[fish] = fish
						self.inst:AddChild(fish)
						fish.entity:Hide()
						fish.persists = false
						if fish.DynamicShadow ~= nil then
							fish.DynamicShadow:Enable(false)
						end
						if fish.Physics ~= nil then
							fish.Physics:SetActive(false)
						end
						if fisherman ~= nil and fish.components.weighable ~= nil then
							fish.components.weighable:SetPlayerAsOwner(fisherman)
						end
						if self.fishleft > 0 then
							self.fishleft = self.fishleft - 1
						end
					end
					return fish
				end
			end
		end
		if oldHookFish then
			return oldHookFish(self,fisherman, ...)
		end
	end
	
	--鱼刷新函数
	local oldRefreshFish=self.RefreshFish
	self.RefreshFish = function(self, ...)
		if self.bait_force then
			--饵力值空了，则清除刷新时间
			if self.bait_force<=0 then
				self.fishrespawntime=nil
			end
			if self.fishrespawntime then
				self.respawntask = self.inst:DoTaskInTime(self.fishrespawntime, function(inst)
					local fishable = inst.components.fishable
					if fishable then
					    fishable.respawntask = nil
					    if fishable.fishleft < fishable.maxfish then
					        fishable.fishleft = fishable.fishleft + 1
					        --消耗饵力值
					        if fishable.bait_force then
					        	fishable.bait_force=math.max(fishable.bait_force-1,0)
					        end
					        if fishable.fishleft < fishable.maxfish then
					        	fishable:RefreshFish()
					        end
					    end
					end
				end)
			end
		elseif oldRefreshFish then
			oldRefreshFish(self, ...)
		end
	end
	
	--存储饵力值
	local oldOnSave=self.OnSave
	self.OnSave = function(self)
		local savedata=nil
		if oldOnSave then
			savedata=oldOnSave(self)
		end
		if self.bait_force then
			if savedata then
				savedata.bait_force=self.bait_force 
			else
				savedata={bait_force = self.bait_force}
			end
		end
		return savedata
	end
	--加载饵力值
	local oldOnLoad=self.OnLoad
	self.OnLoad = function(self,data)
		if data and data.bait_force then
			self.bait_force = data.bait_force
		end
		local fishleft=self.fishleft
		if oldOnLoad then
			oldOnLoad(self,data)
		end
		--擦屁股，防止Load的时候赋空值(无语了，这种东西还要擦屁股)
		if not self.fishleft then self.fishleft=fishleft end
	end
end)

--不可堆叠料理
local unStackCook = {
	batnosehat = true,--牛奶帽
}
local dostew=nil
--修改烹饪组件,在锅中收获自己做的料理的时候提升勋章
AddComponentPostInit("stewer", function(self)
	local oldStartCooking = self.StartCooking
	if dostew == nil and oldStartCooking then
		dostew = MedalGetLocalFn(oldStartCooking,"dostew")
	end
	self.StartCooking = function(self,doer, ...)
		if dostew ~= nil and self.inst.prefab == "medal_cookpot" then
			if self.targettime == nil and self.inst.components.container ~= nil then
				local cook_num = HasOriginMedal(doer,"seasoningchef") and 40 or 1--单次最大烹饪数量
				self.chef_id = (doer ~= nil and doer.player_classified ~= nil) and doer.userid
				self.ingredient_prefabs = {}
		
				self.done = nil
				self.spoiltime = nil
		
				if self.onstartcooking ~= nil then
					self.onstartcooking(self.inst)
				end
				--遍历容器
				for k, v in pairs (self.inst.components.container.slots) do
					table.insert(self.ingredient_prefabs, v.prefab)
					local num = v.components.stackable and v.components.stackable:StackSize() or 1
					cook_num = math.min(cook_num,num)
				end
		
				local cooktime = 1
				self.product, cooktime = cooking.CalculateRecipe(self.inst.prefab, self.ingredient_prefabs)
				local recipe = cooking.GetRecipe(self.inst.prefab, self.product)
				local productperishtime = recipe and recipe.perishtime or 0
				local stacksize = recipe and recipe.stacksize or 1--料理一次性可烹饪的数量
				local maxsize = unStackCook[self.product] and 1 or TUNING.STACK_SIZE_SMALLITEM
				cook_num = math.min(math.floor(maxsize/stacksize),cook_num)--烹饪数量不能超过料理的堆叠上限了
				self.cook_num = cook_num--记录烹饪数量
		
				if productperishtime > 0 then
					local spoilage_total = 0
					local spoilage_n = 0
					for k, v in pairs (self.inst.components.container.slots) do
						if v.components.perishable ~= nil then
							spoilage_n = spoilage_n + 1
							spoilage_total = spoilage_total + v.components.perishable:GetPercent()
						end
					end
					self.product_spoilage =
						(spoilage_n <= 0 and 1) or
						(self.keepspoilage and spoilage_total / spoilage_n) or
						1 - (1 - spoilage_total / spoilage_n) * .5
				else
					self.product_spoilage = nil
				end
		
				cooktime = TUNING.BASE_COOK_TIME * cooktime * self.cooktimemult
				--计算堆叠耗时
				if cook_num > 1 then
					cooktime = math.ceil((80-cook_num)/80*cooktime*cook_num)
				end
				self.targettime = GetTime() + cooktime
				if self.task ~= nil then
					self.task:Cancel()
				end
				self.task = self.inst:DoTaskInTime(cooktime, dostew, self)
		
				self.inst.components.container:Close()
				--返还多余的食材
				for k, v in pairs (self.inst.components.container.slots) do
					local num = v.components.stackable and v.components.stackable:StackSize() or 1
					if num > cook_num then
						local item = v.components.stackable:Get(num - cook_num)
						if doer ~= nil and doer.components.inventory then
							doer.components.inventory:GiveItem(item)
						else
							LaunchAt(item, self.inst, nil, 1, 1)
							-- item.components.inventoryitem:OnDropped(true,.5)
						end
					end
				end
				self.inst.components.container:DestroyContents()
				self.inst.components.container.canbeopened = false
			end
		elseif oldStartCooking then
			oldStartCooking(self,doer, ...)
		end
	end

	local oldHarvest=self.Harvest
	self.Harvest = function(self,harvester, ...)
		--在锅中收获自己做的料理的时候执行大厨系列勋章的方法
		if self.done and harvester ~= nil and self.chef_id == harvester.userid and self.product then
			local cook_medal = harvester.components.inventory and harvester.components.inventory:EquipMedalWithgroupTag("chefMedal")
			if cook_medal and cook_medal.HarvestFoodFn then
				cook_medal.HarvestFoodFn(cook_medal,self.product,harvester,self.inst.prefab)
			end
		end
		
		if self.done and self.inst.prefab=="medal_cookpot" then
			if self.onharvest ~= nil then
				self.onharvest(self.inst)
			end
	
			if self.product ~= nil then
				local loot = SpawnPrefab(self.product)
				if loot ~= nil then
					local recipe = cooking.GetRecipe(self.inst.prefab, self.product)
	
					--红晶锅也能正常解锁食谱书
					if harvester ~= nil and self.chef_id == harvester.userid and recipe ~= nil then
						local cookbook_category = IsNativeCookingProduct(self.product,true) and "portablecookpot" 
							or (IsNativeCookingProduct(self.product) and "cookpot") 
							or "mod"--食谱书分类
						if cooking.cookbook_recipes[cookbook_category] ~= nil and cooking.cookbook_recipes[cookbook_category][self.product] ~= nil then
							harvester:PushEvent("learncookbookrecipe", {product = self.product, ingredients = self.ingredient_prefabs})
						end
					end
	
					local stacksize = recipe and recipe.stacksize or 1
					stacksize = stacksize * (self.cook_num or 1)--计算堆叠数量
					if stacksize > 1 and loot.components.stackable then
						loot.components.stackable:SetStackSize(stacksize)
					end
	
					if self.spoiltime ~= nil and loot.components.perishable ~= nil then
						local spoilpercent = self:GetTimeToSpoil() / self.spoiltime
						loot.components.perishable:SetPercent(self.product_spoilage * spoilpercent)
						loot.components.perishable:StartPerishing()
					end
					if harvester ~= nil and harvester.components.inventory ~= nil then
						harvester.components.inventory:GiveItem(loot, nil, self.inst:GetPosition())
					else
						LaunchAt(loot, self.inst, nil, 1, 1)
					end
				end
				self.product = nil
			end
	
			if self.task ~= nil then
				self.task:Cancel()
				self.task = nil
			end
			self.targettime = nil
			self.done = nil
			self.spoiltime = nil
			self.product_spoilage = nil
			self.cook_num = nil
	
			if self.inst.components.container ~= nil then
				self.inst.components.container.canbeopened = true
			end
	
			return true
		elseif oldHarvest then
			return oldHarvest(self,harvester, ...)
		end
	end

	local oldOnSave = self.OnSave
	self.OnSave = function(self)
		local data = oldOnSave and oldOnSave(self) or {}
		data.cook_num = self.cook_num
		return data
	end

	local oldOnLoad = self.OnLoad
	self.OnLoad = function(self, data)
		if data ~= nil and data.product ~= nil and data.cook_num ~= nil then
			self.cook_num = data.cook_num
		end
		if oldOnLoad then
			oldOnLoad(self, data)
		end
	end
end)

--修改pickable组件，特定植物需要施肥了才能继续生长
AddComponentPostInit("pickable", function(self)
	--继续生长函数(没施肥你生长个毛线)
	local oldResume=self.Resume
	self.Resume = function(self, ...)
		if not self.inst:HasTag("needfertilize") then
			if oldResume then
				oldResume(self, ...)
			end
		end
	end
	--只有在催熟的时候会被调用
	local oldFinishGrowing=self.FinishGrowing
	self.FinishGrowing = function(self, ...)
		if self.nomagic then
			return false--禁止催熟
		end
		if oldFinishGrowing then
			return oldFinishGrowing(self, ...)
		end
	end
end)

--修改晒肉架组件,收获时给玩家推送事件(食人花手杖用)
AddComponentPostInit("dryer", function(self)
	local oldHarvest=self.Harvest
	self.Harvest = function(self,harvester, ...)
		if oldHarvest and oldHarvest(self,harvester, ...) then
			harvester:PushEvent("takesomething",{object = self.inst})
			return true
		else
			return false
		end
	end
end)

--修改治疗组件,使用蜂蜜药膏治疗可解蜂毒
AddComponentPostInit("healer", function(self)
	local oldHeal=self.Heal
	self.Heal = function(self,target, ...)
		if oldHeal then
			if self.inst.prefab=="bandage" and target.injured_damage and oldHeal then
				target:RemoveDebuff("buff_medal_injured")--移除蜂毒BUFF
			end
			return oldHeal(self,target, ...)
		end
	end
end)

--修改传粉者组件，让育王蜂只能采摘虫木花
AddComponentPostInit("pollinator", function(self)
	--只能采摘虫木花
	local oldCanPollinate=self.CanPollinate
	self.CanPollinate = function(self,flower, ...)
		if self.inst and self.inst:HasTag("medal_bee") then
			return flower ~= nil and flower:HasTag("flower") and flower.prefab=="medal_wormwood_flower" and not table.contains(self.flowers, flower)
		elseif oldCanPollinate then
			return oldCanPollinate(self,flower, ...)
		end
	end
	--生成花(可不能让你生成虫木花啊)
	local oldCreateFlower=self.CreateFlower
	self.CreateFlower = function(self, ...)
		local has_wormwood=false--虫木花标记
		--遍历采花列表
		for k,v in pairs(self.flowers) do
			if v.prefab=="medal_wormwood_flower" then
				has_wormwood=true--采过虫木花
			end
		end
		if has_wormwood then
			if self:HasCollectedEnough() and self.inst:IsOnValidGround() then
				local parentFlower = GetRandomItem(self.flowers)
				--把虫木花换成玫瑰
				local flower = SpawnPrefab(parentFlower.prefab=="medal_wormwood_flower" and "flower_rose" or parentFlower.prefab)
				flower.planted = true
				flower.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
				self.flowers = {}
			end
		elseif oldCreateFlower then
			oldCreateFlower(self, ...)
		end
	end
end)


--hook食物记忆组件，勋章调料的食物也应该只取基础食物来算
AddComponentPostInit("foodmemory", function(self)
	local oldGetBaseFood=self.GetBaseFood
	self.GetBaseFood = function(self,prefab, ...)
		if medal_spicedfoods and medal_spicedfoods.spicedfoods and  medal_spicedfoods.spicedfoods[prefab] then
			return medal_spicedfoods.spicedfoods[prefab].basename
		elseif oldGetBaseFood then
			return oldGetBaseFood(self,prefab, ...)
		end
	end
end)
--hook喜爱食物组件，勋章调料的食物也应该只取基础食物来算
AddComponentPostInit("foodaffinity", function(self)
	local oldGetFoodBasePrefab=self.GetFoodBasePrefab
	self.GetFoodBasePrefab = function(self,food, ...)
		if medal_spicedfoods and medal_spicedfoods.spicedfoods and  medal_spicedfoods.spicedfoods[food.prefab] and medal_spicedfoods.spicedfoods[food.prefab].basename then
			return medal_spicedfoods.spicedfoods[food.prefab].basename
		elseif oldGetFoodBasePrefab then
			return oldGetFoodBasePrefab(self,food, ...)
		end
	end
end)

--玩家控制组件Hook
local GetWorldControllerVector = nil
AddComponentPostInit("playercontroller", function(self)
	--旋转视角时给玩家同步方向信息
	local oldRotLeft=self.RotLeft
	self.RotLeft = function(self, ...)
		if oldRotLeft then
			oldRotLeft(self, ...)
		end
		if TheCamera then
			SendModRPCToServer(MOD_RPC.functional_medal.SetCameraHeading, TheCamera:GetHeadingTarget())
		end
	end

	local oldRotRight=self.RotRight
	self.RotRight = function(self, ...)
		if oldRotRight then
			oldRotRight(self, ...)
		end
		if TheCamera then
			SendModRPCToServer(MOD_RPC.functional_medal.SetCameraHeading, TheCamera:GetHeadingTarget())
		end
	end
	--混乱时反向操作
	if GetWorldControllerVector == nil then
		if self.DoBoatSteering ~= nil then
			GetWorldControllerVector = upvaluehelper.Get(self.DoBoatSteering, "GetWorldControllerVector")
			if GetWorldControllerVector ~= nil then
				upvaluehelper.Set(self.DoBoatSteering,"GetWorldControllerVector",function()
					if ThePlayer and ThePlayer:HasTag("medal_confusion") then
						local xdir = TheInput:GetAnalogControlValue(CONTROL_MOVE_LEFT) - TheInput:GetAnalogControlValue(CONTROL_MOVE_RIGHT)
						local ydir = TheInput:GetAnalogControlValue(CONTROL_MOVE_DOWN) - TheInput:GetAnalogControlValue(CONTROL_MOVE_UP)
						local deadzone = TUNING.CONTROLLER_DEADZONE_RADIUS
						if math.abs(xdir) >= deadzone or math.abs(ydir) >= deadzone then
							local dir = TheCamera:GetRightVec() * xdir - TheCamera:GetDownVec() * ydir
							return dir:GetNormalized()
						end
					end
					return GetWorldControllerVector()
				end)
			end
		end
	end
	--弹弓索敌
	local oldGetAttackTarget = self.GetAttackTarget
	self.GetAttackTarget = function(self, force_attack, force_target, ...)
		--佩戴童真、童心勋章时，使用弹弓优先锁定最后一个攻击过的目标
		if TUNING.MEDAL_LOCK_TARGET_RANGE_MULT > 0 and force_target == nil and self.inst:HasTag("has_childishness") then
			local combat = self.inst.replica.combat
			if combat == nil then return end
			local weapon = combat:GetWeapon()
			if weapon ~= nil and weapon:HasTag("slingshot") then
				local lasttarget = combat.classified ~= nil and combat.classified.lastcombattarget:value()
				if lasttarget and not IsEntityDead(lasttarget) and CanEntitySeeTarget(self.inst, lasttarget) and combat:CanTarget(lasttarget) then
					local attackrange = combat:GetAttackRangeWithWeapon()
					local rad = attackrange * TUNING.MEDAL_LOCK_TARGET_RANGE_MULT--self.directwalking and attackrange or attackrange + 6
					local reach = self.inst:GetPhysicsRadius(0) + rad + .1 + lasttarget:GetPhysicsRadius(0)
					if self.inst:IsNear(lasttarget, reach) then
						-- print(rad,reach)
						force_target = lasttarget
					end
				end
			end
		end
		
		if oldGetAttackTarget then
			return oldGetAttackTarget(self, force_attack, force_target, ...)
		end
	end
end)

--修改攻击组件
AddComponentPostInit("combat", function(self)
	local can_extinguish_list={
		stafflight = true,--矮星
		staffcoldlight = true,--冷星
		emberlight = true,--火女火球
	}
	--让落水弹也能射矮星
	local oldCanExtinguishTarget=self.CanExtinguishTarget
	self.CanExtinguishTarget = function(self, target, weapon, ...)
		if weapon and weapon:HasTag("stafflight_killer") and can_extinguish_list[target.prefab] then
			return true
		end
		if oldCanExtinguishTarget then
			return oldCanExtinguishTarget(self, target, weapon, ...)
		end
	end
	--嗜血箭不造成伤害，只回血
	local oldDoAttack = self.DoAttack
	self.DoAttack = function(self, targ, weapon,...)
		if weapon and weapon.prefab == "medal_shadowthrall_arrow_blood" and weapon.treatment_value then
			if targ and targ:IsValid() and targ.components.health and not targ.components.health:IsDead() then
				targ.components.health:DoDelta(weapon.treatment_value)
			end
			return
		end
		oldDoAttack(self, targ, weapon,...)
	end
	local oldGetAttacked = self.GetAttacked
	self.GetAttacked = function(self, attacker, damage, weapon, stimuli, spdamage, ...)
		if oldGetAttacked then
			--本源沉默的爆发伤害
			if attacker and attacker.medal_silence_damage ~= nil then
				damage = damage + attacker.medal_silence_damage
				attacker.medal_silence_damage = 0
			end
			--绝望螨混沌伤害
			if attacker and (attacker.prefab=="fused_shadeling_bomb" or attacker.prefab=="fused_shadeling_quickfuse_bomb") and attacker.chaos_creature then
				if self.inst:HasTag("chaos_creature") then return end--混沌生物不会被有混沌伤害的绝望螨打到
				return oldGetAttacked(self, attacker, TUNING_MEDAL.MEDAL_SHADOWTHRALL_SCREAMER_DAMAGE, nil, nil, {medal_chaos = TUNING_MEDAL.MEDAL_SHADOWTHRALL_SCREAMER_CHAOS_DAMAGE})
			end
			--本源孢子云添加寄生值
			if attacker and attacker.prefab == "medal_sporecloud" and self.inst.components.health and not self.inst.components.health:IsDead() then
				self.inst.components.health:DoDeltaMedalParasitic(TUNING_MEDAL.MEDAL_SPORECLOUD_PARASITIC)
			end
			--强行给只有特殊伤害的攻击手段加1点点物理伤害，防止绕过混沌实体的计算
			if self.inst.components.planarentity and self.inst:HasTag("chaos_creature") and damage and damage <= 0 and spdamage ~= nil then
				damage = 0.01
			end
			return oldGetAttacked(self, attacker, damage, weapon, stimuli, spdamage, ...)
		end
	end
	--额外计算混沌伤害
	local oldCalcDamage = self.CalcDamage
	self.CalcDamage = function(self, target, weapon, multiplier,...)
		local damage
		local spdamage
		if oldCalcDamage ~= nil then
			if weapon and weapon.components.weapon == nil then
				weapon = nil--这里要强行擦下屁股，鸽雷做亮茄法杖的时候没考虑到aoe伤害触发时武器的weapon组件被移除的情况
			end
			damage, spdamage = oldCalcDamage(self, target, weapon, multiplier,...)
		end
		if self.inst and self.inst.components.medal_chaosdamage then
			damage, spdamage = self.inst.components.medal_chaosdamage:CalcBonusChaosDamage(target, damage, spdamage)
		end
		return damage, spdamage
	end

	local oldDoAreaAttack = self.DoAreaAttack
	self.DoAreaAttack = function(self, target, range, weapon, ...)
		--哑铃这种奇葩投掷物不应该触发蜂王勋章的aoe
		if (self.inst.medal_aoecombat or self.inst.medal_aoecombat_value) and weapon ~= nil and weapon:HasTag("keep_equip_toss") and not weapon:HasTag("INLIMBO") then
			return 0
		end
		if oldDoAreaAttack~=nil then
			return oldDoAreaAttack(self, target, range, weapon, ...)
		end
	end
end)

--replica也要Hook
AddClassPostConstruct("components/combat_replica", function(self)
    local oldCanExtinguishTarget=self.CanExtinguishTarget
    self.CanExtinguishTarget = function(self, target, weapon, ...)
		if weapon and weapon:HasTag("stafflight_killer") and (target.prefab=="stafflight" or target.prefab=="staffcoldlight") then
			return true
		end
		if oldCanExtinguishTarget then
			return oldCanExtinguishTarget(self, target, weapon, ...)
		end
	end
end)

--风暴监测组件,监听时空风暴情况
AddComponentPostInit("stormwatcher", function(self)
	if TheWorld.net.components.medal_spacetimestorms ~= nil and
            next(TheWorld.net.components.medal_spacetimestorms:GetSpacetimestormNodes()) then
        self:UpdateStorms({stormtype= STORM_TYPES.MEDAL_SPACETIMESTORM, setting = true})
    end
	--获取当前风暴类型
	local oldGetCurrentStorm=self.GetCurrentStorm
	self.GetCurrentStorm = function(self, ...)
		local currentstorm = STORM_TYPES.NONE
		if oldGetCurrentStorm then
			currentstorm = oldGetCurrentStorm(self, ...)
		end
		if TheWorld.net.components.medal_spacetimestorms ~= nil then
			if TheWorld.net.components.medal_spacetimestorms:IsInSpacetimestorm(self.inst) then
				assert(currentstorm == STORM_TYPES.NONE,"人啊，不能脚踏两…个风暴")
				currentstorm = STORM_TYPES.MEDAL_SPACETIMESTORM
			end
		end
		return currentstorm
	end
	--更新风暴等级
	local oldUpdateStormLevel=self.UpdateStormLevel
	self.UpdateStormLevel = function(self, ...)
		local laststorm=self.laststorm
		if oldUpdateStormLevel then
			oldUpdateStormLevel(self, ...)
		end
		if self.currentstorm ~= STORM_TYPES.NONE then
			local level = self.stormlevel
	
			if self.currentstorm == STORM_TYPES.MEDAL_SPACETIMESTORM then
				level = math.floor(TheWorld.net.components.medal_spacetimestorms:GetSpacetimestormLevel(self.inst) * 7 + .5) / 7
				self.inst.components.medal_spacetimestormwatcher:UpdateSpacetimestormLevel()
			end
	
			if self.stormlevel ~= level then
				self.stormlevel = level
			end
		else
			if laststorm == STORM_TYPES.MEDAL_SPACETIMESTORM then
				self.inst.components.locomotor:RemoveExternalSpeedMultiplier(self.inst, "spacetimestorm")
			end
			self.stormlevel = 0
		end
	end
end)

--hook月亮风暴控制器，生成点不能和时空风暴重合了
AddComponentPostInit("moonstormmanager", function(self)
	--修改搜寻目标函数
	local oldCalcNewMoonstormBaseNodeIndex = self.CalcNewMoonstormBaseNodeIndex
	if oldCalcNewMoonstormBaseNodeIndex then
		local NodeCanHaveMoonstorm = upvaluehelper.Get(oldCalcNewMoonstormBaseNodeIndex,"NodeCanHaveMoonstorm")
		if NodeCanHaveMoonstorm then
			local function NewNodeCanHaveMoonstorm(node)
				--目标节点不能和时空风暴重叠
				return NodeCanHaveMoonstorm(node) 
					and not (TheWorld.net.components.medal_spacetimestorms and TheWorld.net.components.medal_spacetimestorms:IsPointInSpacetimestorm(Vector3(node.cent[1], 0, node.cent[2])))
			end
			upvaluehelper.Set(oldCalcNewMoonstormBaseNodeIndex,"NodeCanHaveMoonstorm",NewNodeCanHaveMoonstorm)
		end
	end
end)

--hook移速组件,山力叶酱搬重物不掉速
AddComponentPostInit("locomotor", function(self)
	local oldGetSpeedMultiplier = self.GetSpeedMultiplier
	if TheWorld.ismastersim then
		self.GetSpeedMultiplier = function(self, ...)
			if self.inst:HasTag("medal_strong") and not (self.inst.components.rider ~= nil and self.inst.components.rider:IsRiding()) then
				local mult = self:ExternalSpeedMultiplier()
				if self.inst.components.inventory ~= nil then
					for k, v in pairs(self.inst.components.inventory.equipslots) do
						if v.components.equippable ~= nil then
							local item_speed_mult = v.components.equippable:GetWalkSpeedMult()
							mult = mult * math.max(item_speed_mult,1)
						end
					end
				end
				return mult * (self:TempGroundSpeedMultiplier() or self.groundspeedmultiplier) * self.throttle
			elseif oldGetSpeedMultiplier then
				return oldGetSpeedMultiplier(self, ...)
			end
		end
	else
		self.GetSpeedMultiplier = function(self, ...)
			if self.inst:HasTag("medal_strong") and not (self.inst.replica.rider and self.inst.replica.rider:IsRiding()) then
				local mult = self:ExternalSpeedMultiplier()
				local inventory = self.inst.replica.inventory
				if inventory ~= nil then
					for k, v in pairs(inventory:GetEquips()) do
						local inventoryitem = v.replica.inventoryitem
						if inventoryitem ~= nil then
							local item_speed_mult = inventoryitem:GetWalkSpeedMult()
							mult = mult * math.max(item_speed_mult,1)
						end
					end
				end
				return mult * (self:TempGroundSpeedMultiplier() or self.groundspeedmultiplier) * self.throttle
			elseif oldGetSpeedMultiplier then
				return oldGetSpeedMultiplier(self, ...)
			end
		end
	end
end)

--修改灭火器组件，防止灭红/蓝晶火坑
local NOTAGS = nil
AddComponentPostInit("firedetector", function(self)
	if NOTAGS == nil then
		if self.ActivateEmergencyMode ~= nil then
			NOTAGS = upvaluehelper.Get(self.ActivateEmergencyMode, "NOTAGS")
			if NOTAGS ~= nil and not table.contains(NOTAGS,"medal_campfire") then
				table.insert(NOTAGS,"medal_campfire")
			end
		end
	end
end)

--修改产崽组件，玩家佩戴蜂王勋章时收蜂箱不会出蜂
AddComponentPostInit("childspawner", function(self)
	local oldReleaseAllChildren = self.ReleaseAllChildren
	if oldReleaseAllChildren then
		self.ReleaseAllChildren=function(self, target, prefab, ...)
			if self.inst and (self.inst.prefab=="beebox" or self.inst.prefab=="beebox_hermit") and target and target.isbeeking then
				return
			end
			return oldReleaseAllChildren(self, target, prefab, ...)
		end
	end
end)

--读书消耗智慧勋章耐久
--原版书籍消耗列表
local dst_book_used_loot={
	book_gardening=50,--老版园艺学
	book_horticulture=4,--园艺学简编
	book_horticulture_upgraded=6,--园艺学扩展
	book_silviculture=8,--造林学
	book_research_station=5,--科技书
	book_birds=5,--鸟书
	book_fish=20,--鱼书
	book_bees=10,--蜂书
	book_sleep=5,--睡书
	book_brimstone=10,--末日将至
	book_fire=5,--灭火书
	book_tentacles=10,--触手书
	book_web=5,--蛛网书
	book_moon=20,--月书
	book_light=4,--小光书
	book_light_upgraded=8,--大光书
	book_rain=10,--雨书
	book_temperature=5,--控温书
}
--勋章特有书籍消耗列表
local medal_book_used_loot={
	trapreset_book=5,--陷阱重置册
	immortal_book=5,--不朽之谜
	monster_book=20,--怪物图鉴
	unsolved_book=40,--未解之谜
	autotrap_book=30,--智能陷阱制作手册
	medal_plant_book=20,--植物图鉴
	closed_book=-1,--无字天书
}
--致其他moder：
--如果你的mod里有书籍，原本无阅读能力的角色在佩戴智慧勋章时阅读该书籍时若san值不够则会默认消耗10点耐久；耐久不足则本次阅读不生效
--如果需要设定特殊值或取消该消耗，可按以下方式进行兼容：
--inst.components.book.medal_consume_all=n --若n大于0，表示无论在什么情况下都必需在佩戴智慧勋章且耐久超过n点时才可阅读该书籍
--inst.components.book.medal_consume_temp=n --若n大于0，表示原本无阅读能力的角色在san值不够消耗时必需佩戴智慧勋章且耐久超过n点时才可阅读该书籍；原本有阅读能力的角色则不受影响；n<=0可取消该消耗
AddComponentPostInit("book", function(self)
	local oldOnRead = self.OnRead
	if oldOnRead then
		self.OnRead=function(self, reader, ...)
			if self.inst and reader and reader.components.inventory then
				local consume = self.medal_consume_all or medal_book_used_loot[self.inst.prefab] or 0--勋章特有书籍必须消耗智慧值
				local medal_book_added_value = consume>0 and 20 or 0--勋章特有书籍酬勤附加值
				local istemporary = IsMedalTempCom(reader,"reader") or reader.temporary_nomalreader--是否是临时读者(小鱼妹也是临时读者)
				if istemporary and consume==0 then
					local sanity_mult = reader.components.sanity and reader.components.sanity:IsInsanityMode() and reader.components.sanity.yueshubuff and TUNING_MEDAL.MEDAL_BUFF_SANITYREGEN_ABSORB or 1--月树花粉倍率
					local read_sanity = -(self.read_sanity or 0) * reader.components.reader:GetSanityPenaltyMultiplier() * sanity_mult--阅读消耗
					local sanity_current = reader.components.sanity and reader.components.sanity.current or 0--没有san值？那也乖乖扣智慧值吧
					--san值不够了原版书籍也照样要消耗智慧值
					if read_sanity > sanity_current then
						consume = self.medal_consume_temp or dst_book_used_loot[self.inst.prefab] or 10
					end
				end
				local medal=reader.components.inventory:EquipMedalWithName("wisdom_certificate")--获取玩家的智慧勋章
				if medal ~= nil and HasOriginMedal(reader) then
					consume = consume * .6--本源勋章消耗降低
				end
				if consume>0 then
					if medal and medal.components.finiteuses then
						--智慧值足够
						if medal.components.finiteuses:GetUses() >= consume then
							local success, reason = oldOnRead(self, reader, ...)
							if success then
								medal.components.finiteuses:Use(consume)--消耗智慧值
								RewardToiler(reader,math.min((consume + medal_book_added_value)*0.005,0.2))--天道酬勤
							end
							return success, reason
						else
							return false,"NOWISDOMVALUE"--智慧值不足
						end
					else
						return false,"TOOCOMPLEX"--玩家没佩戴智慧勋章就别读了
					end
				elseif medal then
					local success, reason = oldOnRead(self, reader, ...)
					if success then
						RewardToiler(reader,0.01)--天道酬勤
					end
					return success, reason
				end
			end
			return oldOnRead(self, reader, ...)
		end
	end
end)

--修改收获组件，采摘凋零蜂箱最大状态时产物为凋零蜂王浆
AddComponentPostInit("harvestable", function(self)
	self.HarvestMedalBeeBox=function(self, picker)
		if self:CanBeHarvested() and self.inst.prefab=="medal_beebox" and self.inst:HasTag("medal_beebox_full") then
			if self.can_harvest_fn ~= nil then
				local can_harvest, fail_reason = self.can_harvest_fn(self.inst, picker)
				if not can_harvest then
					return false, fail_reason
				end
			end
	
			self.produce = 0
	
			local pos = self.inst:GetPosition()
	
			if self.onharvestfn ~= nil then
				self.onharvestfn(self.inst, picker, 1)
			end
	
			if picker ~= nil and picker.components.inventory ~= nil then
				picker:PushEvent("harvestsomething", { object = self.inst })
			end

			local loot = SpawnPrefab("medal_withered_royaljelly")
			if loot ~= nil then
				if loot.components.inventoryitem ~= nil then
					loot.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
				end
				if picker ~= nil and picker.components.inventory ~= nil then
					picker.components.inventory:GiveItem(loot, nil, pos)
				else
					LaunchAt(loot, self.inst, nil, 1, 1)
				end
			end
			self:StartGrowing()
			return true
		end
	end
	local oldOnLoad = self.OnLoad
	self.OnLoad = function(self,data)
		if oldOnLoad then
			oldOnLoad(self,data)
			if self.inst.prefab=="medal_beebox" and self.enabled and self.produce >= self.maxproduce then
				self.inst:AddTag("medal_beebox_full")
			end
		end
	end
	local oldStopGrowing = self.StopGrowing
	self.StopGrowing = function(self, ...)
		if self.inst.prefab=="medal_beebox" then
			if self.enabled and self.produce >= self.maxproduce then
				self.inst:AddTag("medal_beebox_full")
			else
				self.inst:RemoveTag("medal_beebox_full")
			end
		end
		if oldStopGrowing then
			oldStopGrowing(self, ...)
		end
	end
end)

--修改成长组件，让杂草种子只能种出杂草
local random_weed_loot={
	weed_forgetmelots=2,--必忘我
	weed_tillweed=1,--犁地草
	weed_firenettle=1,--火荨麻
	weed_ivy=1,--刺针旋花
}
AddComponentPostInit("growable", function(self)
	local oldSetStage = self.SetStage
	self.SetStage=function(self, stage, ...)
		if self.inst and self.inst.prefab=="farm_plant_randomseed" and self.is_weed_seed then
			if self.stages[stage] ~= nil and self.stages[stage].name=="sprout" then
				local plant = SpawnPrefab(weighted_random_choice(random_weed_loot))
				plant.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
				self.inst.grew_into = plant
				self.inst:Remove()
				return
			end
		end
		if oldSetStage then
			oldSetStage(self,stage, ...)
		end
	end
	--本源之树不能强制催长
	local oldDoGrowth = self.DoGrowth
	self.DoGrowth = function(self,...)
		if self.need_medal_growth ~= nil then
			--need_medal_growth为false意味着可以临时通过
			if self.need_medal_growth then
				--确保是自然生长到这个时间,催长的肯定是不满足这个条件的
				if self.targettime == nil or (self.targettime - GetTime()>0) then
					return false
				end
			else
				self.need_medal_growth = true
			end
		end
		if oldDoGrowth then
			 return oldDoGrowth(self,...)
		end
	end
	--存储函数
	local oldOnSave=self.OnSave
	self.OnSave = function(self)
		local savedata=nil
		if oldOnSave then
			savedata=oldOnSave(self)
		end
		--保存杂草种子状态
		if self.is_weed_seed then
			savedata = savedata or {}
			savedata.is_weed_seed=self.is_weed_seed
		end
		return savedata
	end
	--加载函数
	local oldOnLoad=self.OnLoad
	self.OnLoad = function(self,data)
		if data and data.is_weed_seed then
			self.is_weed_seed = data.is_weed_seed
		end
		if oldOnLoad then
			oldOnLoad(self,data)
		end
	end
end)

--修改工具组件，不朽工具没耐久的时候不能使用
AddComponentPostInit("tool", function(self)
	local oldCanDoAction = self.CanDoAction
	self.CanDoAction=function(self, ...)
		if self.inst and self.inst:HasTag("isimmortal") and self.inst:HasTag("usesdepleted") then return end
		if oldCanDoAction then
			return oldCanDoAction(self, ...)
		end
	end
end)

--暗影魔法工具只有装备的时候才能切换状态
AddComponentPostInit("spellbook", function(self)
	local oldCanBeUsedBy = self.CanBeUsedBy
	self.CanBeUsedBy=function(self, ...)
		if self.inst and self.inst.prefab=="medal_shadow_tool" and self.inst.replica.equippable then
			return self.inst.replica.equippable:IsEquipped() and self.items ~= nil and #self.items > 0
		end
		if oldCanBeUsedBy then
			return oldCanBeUsedBy(self, ...)
		end
	end
end)

--目标解冻时移除蓝晶易伤状态
AddComponentPostInit("freezable", function(self)
	local oldUnfreeze = self.Unfreeze
	self.Unfreeze=function(self, ...)
		if self.inst and self.inst.components.combat and self.inst.components.combat.externaldamagetakenmultipliers then
			self.inst.components.combat.externaldamagetakenmultipliers:RemoveModifier("buff_medal_bluemark")
		end
		if oldUnfreeze then
			oldUnfreeze(self, ...)
		end
	end
end)

--本源复眼亮度增强
local UpdateSummerBloom = nil
AddComponentPostInit("worldtemperature", function(self)
	local oldOnUpdate = self.OnUpdate
	if oldOnUpdate and UpdateSummerBloom == nil then
		UpdateSummerBloom = upvaluehelper.Get(oldOnUpdate,"UpdateSummerBloom")
		if UpdateSummerBloom ~= nil then
			upvaluehelper.Set(oldOnUpdate,"UpdateSummerBloom",function(dt)
				if TheWorld and ThePlayer and ThePlayer.medalnightvision and ThePlayer.medalnightvision:value() and HasOriginMedal(ThePlayer) then
					TheWorld:PushEvent("overridecolourmodifier", 1.5)
				else
					UpdateSummerBloom(dt)
				end
			end)
		end
	end
end)

--暗影装备加成等级
AddComponentPostInit("shadowlevel", function(self)
	local oldGetCurrentLevel = self.GetCurrentLevel
	self.GetCurrentLevel=function(self, ...)
		local level = oldGetCurrentLevel and oldGetCurrentLevel(self, ...) or 0
		if self.inst.components.inventoryitem then
            local owner = self.inst.components.inventoryitem:GetGrandOwner()
			--本源暗影勋章对所有暗影装备等级进行加成
			if HasOriginMedal(owner,"has_shadowmagic_medal") then
				level = level +1
			end
		end
		return level
	end
end)

------------------------------------------------------------------------------------------------------
----------------------------------------------混沌伤害-------------------------------------------------
------------------------------------------------------------------------------------------------------
--修改位面实体组件
AddComponentPostInit("planarentity", function(self)
	local oldAbsorbDamage = self.AbsorbDamage
	self.AbsorbDamage=function(self, damage, attacker, weapon, spdmg, ...)
		if self.inst:HasTag("chaos_creature") then
			--混沌生物会将其他特殊伤害转化为物理伤害
			if spdmg ~= nil then
				for k, v in pairs(spdmg) do
					if k ~= "medal_chaos" and v > 0 then
						damage = damage + v
						spdmg[k]=nil
					end
				end
			end
			--获取混沌生物死亡次数,死亡次数越多抵抗越强
			local death_times = self.chaos_times--配了chaos_times的直接用chaos_times
				or (self.ignore_chaos_times and 3)--配了ignore_chaos_times的则无视死亡次数，统一按最高规格来
				or (TheWorld and TheWorld.components.medal_infosave and TheWorld.components.medal_infosave:GetChaosCreatureDeathTimes(self.inst)) 
				or 0
			local offset_num = 2^math.max(5-death_times,2)
			--修正值=2^max(5-击败次数,2)
			--受到的伤害=(√((物理伤害+非混沌特殊伤害总和)×修正值 + 修正值^2×4)-修正值×2)×4+混沌伤害
			damage = (math.sqrt(damage * offset_num + offset_num^2*4) - offset_num*2) * 4
			return damage, spdmg
		end
		if oldAbsorbDamage then
			return oldAbsorbDamage(self, damage, attacker, weapon, spdmg, ...)
		end
	end
end)
--混沌伤害计算
local SpDamageUtil = require("components/spdamageutil")
if SpDamageUtil.DefineSpType then
	SpDamageUtil.DefineSpType("medal_chaos", {
		GetDamage = function(ent)
			return ent.components.medal_chaosdamage ~= nil and ent.components.medal_chaosdamage:GetDamage() or 0
		end,
		GetDefense = function(ent)
			return ent.components.medal_chaosdefense ~= nil and ent.components.medal_chaosdefense:GetDefense() or 0
		end,
	})
end
--混沌防御对其他特殊伤害也生效
if SpDamageUtil.ApplySpDefense then
	local oldApplySpDefense = SpDamageUtil.ApplySpDefense
	SpDamageUtil.ApplySpDefense = function(ent, tbl, ...)
		tbl = oldApplySpDefense and oldApplySpDefense(ent,tbl, ...) or tbl
		if tbl ~= nil then
			--获取目标自身的混沌防御
			local chaosdefense = SpDamageUtil.GetSpDefenseForType(ent, "medal_chaos")
			--获取目标身上的装备带来的混沌防御
			if ent.components.inventory then
				for eslot, equip in pairs(ent.components.inventory.equipslots) do
					local def = SpDamageUtil.GetSpDefenseForType(equip, "medal_chaos")
					if def > 0 then
						chaosdefense = chaosdefense + def
					end
				end
			end
			if chaosdefense and chaosdefense>0 then
				chaosdefense = chaosdefense * .5--对其他特殊伤害的防御只有50%
				for k, v in pairs(tbl) do
					if k ~= "medal_chaos" then--对其他特殊伤害生效
						tbl[k] = v > chaosdefense and v - chaosdefense or nil
					end
				end
			end
			if ent ~= nil and tbl["medal_chaos"] ~= nil then
				ent.medal_chaos_damage = tbl["medal_chaos"]--记录混沌伤害,在伤害结算的时候有用
			end
		end
		return tbl
	end
end


---------------------------------------------------------------------------------------------------------
----------------------------------------------修改其他文件---------------------------------------------------
---------------------------------------------------------------------------------------------------------
AddIngredientValues({"medal_withered_royaljelly"}, {sweetener=3}, true)--凋零蜂王浆有3点甜蜜度

--修改容器界面，勋章盒、调料盒兼容融合模式
AddClassPostConstruct("screens/playerhud", function(self)
    local ContainerWidget = require("widgets/containerwidget")
	local oldOpenContainer=self.OpenContainer
	local oldCloseContainer=self.CloseContainer
	
	--勋章栏容器
	local function OpenMedalWidget(self, container,side)
		local containerwidget = ContainerWidget(self.owner)
		--开了勋章栏的话融合勋章栏放勋章栏的位置，否则默认位置
		local parent = side and self.controls.containerroot_side or (TUNING.ADD_MEDAL_EQUIPSLOTS and TUNING.MEDAL_INV_SWITCH) and self.controls.inv.medal_inv or self.controls.containerroot

		parent:AddChild(containerwidget)
		
		containerwidget:MoveToBack()
		containerwidget:Open(container, self.owner)
		self.controls.containers[container] = containerwidget
	end
	--打开容器
    self.OpenContainer = function(self,container, side, ...)
		if container == nil then
			return
		end
		--融合勋章、勋章盒、调料盒走自己的容器逻辑
		if container:HasTag("multivariate_certificate") or special_medal_box[container.prefab] then
			OpenMedalWidget(self,container,side)
			return
		end
		oldOpenContainer(self,container, side, ...)
    end
	--关闭容器
    self.CloseContainer = function(self,container, side, ...)
		if container == nil then
			return
		end
		--如果是勋章盒、料理盒就把side参数设为false，让盒子正常关闭
		if side and special_medal_box[container.prefab] then
			side=false
		end
		
		oldCloseContainer(self,container, side, ...)
    end
end)

--返回物品详细信息
local function CheckUserHint(inst)
	local classified = ThePlayer and ThePlayer.player_classified
	if classified == nil then
		return ""
	end
	local i = string.find(classified.medal_info,';',1,true)
	if i == nil then
		return ""
	end
	local guid = tonumber(classified.medal_info:sub(1,i-1))
	if guid ~= inst.GUID then
		return ""
	end
	return classified.medal_info:sub(i+1)
end
--显示范围圈
local function showMedalRange(oldtarget,newtarget)
	if oldtarget and oldtarget.medal_show_range then
		oldtarget.medal_show_range:Remove()
		oldtarget.medal_show_range = nil
	end
	if not newtarget then
		return
	end
	if newtarget.medal_show_radius then
		newtarget.medal_show_range=SpawnPrefab("medal_show_range")
		if newtarget:HasTag("INLIMBO") and ThePlayer then
			newtarget.medal_show_range:Attach(ThePlayer)
		else
			newtarget.medal_show_range:Attach(newtarget)
		end
		local radius=newtarget.medal_show_radius
		if ThePlayer then
			--防止玩家的缩放影响范围圈
			local scalex,scaley,scalez=ThePlayer.Transform:GetScale()
			if scalex and scalex>0 then
				radius=radius/(scalex*scalex)
			end
		end
		newtarget.medal_show_range:SetRadius(radius)
	end
end

local save_target--暂存目标
local last_rangetarget--暂存范围显示目标
local last_check_time = 0--上一次检查时间
--hook玩家鼠标停留函数
AddClassPostConstruct("widgets/hoverer",function(hoverer)
	local oldHide = hoverer.text.Hide
	local oldSetString = hoverer.text.SetString
	hoverer.text.SetString = function(text,str, ...)
		--获取目标
		local target = GLOBAL.TheInput:GetHUDEntityUnderMouse()
		target = (target and target.widget and target.widget.parent ~= nil and target.widget.parent.item) or TheInput:GetWorldEntityUnderMouse() or nil
		--测试模式显示预置物代码
		if TUNING.MEDAL_TEST_SWITCH and target and target.prefab then
			str=str.."\n"..target.prefab
		end
		--一些提示性信息(不重要)
		if TUNING.MEDAL_SHOW_INFO > 1 and target and target.prefab and STRINGS.MEDAL_HOVER_TIPS and STRINGS.MEDAL_HOVER_TIPS[target.prefab] ~= nil then
			str = str.."\n"..STRINGS.MEDAL_HOVER_TIPS[target.prefab]
		end
		--获取需显示信息
		if TUNING.MEDAL_SHOW_INFO > 0 and target and target.GUID and (target:HasTag("fishable") or target:HasTag("showmedalinfo") ) then
			local str2 = CheckUserHint(target)
			if str2 and str2 ~= "" then
				str=str..str2
			end
			--目标变了或者时间间隔1秒，则发送rpc
			if target ~= save_target or last_check_time + 1 < GetTime() then
				save_target = target
				last_check_time = GetTime()
				SendModRPCToServer(MOD_RPC.functional_medal.Showinfo, save_target.GUID, save_target)
			end
		end
		--显示范围圈
		if TUNING.MEDAL_SHOW_INFO > 0 then
			if target and target.GUID then
				if last_rangetarget~=target then
					showMedalRange(last_rangetarget,target)
					last_rangetarget = target
				end
			elseif last_rangetarget then
				showMedalRange(last_rangetarget,nil)
				last_rangetarget = nil
			end
		end
			
		if oldSetString then
			return oldSetString(text,str, ...)
		end
	end
		
	hoverer.text.Hide = function(text, ...)
		if text.shown then
			if TUNING.MEDAL_SHOW_INFO > 0 and last_rangetarget then
				showMedalRange(last_rangetarget,nil)
				last_rangetarget = nil
			end
			oldHide(text, ...)
		end
	end
end)

--坎普斯宝匣容器优先级(0最高,1中等(高于背包和物品栏),2最低)
AddClassPostConstruct("widgets/invslot", function(self)
	local oldTradeItem=self.TradeItem
	local FindBestContainer=nil
	if oldTradeItem then
		FindBestContainer = MedalGetLocalFn(oldTradeItem,"FindBestContainer")
		--这个函数用于寻找最合适转移道具的容器位置(self,道具,要检索的容器列表,排除的容器列表)
	end
	if FindBestContainer then
		self.TradeItem=function(self,stack_mod, ...)
			if TUNING.MEDAL_KRAMPUS_CHEST_PRIORITY>0 then
				local slot_number = self.num
				local character = ThePlayer--玩家
				local inventory = character and character.replica.inventory or nil--物品栏
				local container = self.container--当前容器
				local container_item = container and container:GetItemInSlot(slot_number) or nil--需转移位置的道具

				if character ~= nil and inventory ~= nil and container_item ~= nil then
					local opencontainers = inventory:GetOpenContainers()--玩家打开的容器列表
					if next(opencontainers) == nil then
						return--没有打开的容器直接return
					end

					local overflow = inventory:GetOverflowContainer()--获取玩家的外挂容器(一般也就是背包了,可能还有带格子的护甲之类的)
					local backpack = nil--玩家的背包
					if overflow ~= nil and overflow:IsOpenedBy(character) then
						backpack = overflow.inst
						overflow = backpack.replica.container
						if overflow == nil then
							backpack = nil
						end
					else
						overflow = nil
					end

					local krampus_chest = nil--坎普斯宝匣
					for k, v in pairs(opencontainers) do
						if k.prefab=="medal_krampus_chest_item" or k.prefab=="medal_krampus_chest" then
							krampus_chest=k--记录坎普斯宝匣
							break
						end
					end

					--find our destination container
					local dest_inst = nil
					--如果当前容器是物品栏
					if container == inventory then
						--优先级最高的是玩家打开的容器(排除优先级中等的容器)
						local medium_containers = backpack ~= nil and { [backpack] = true } or nil--优先级中等的容器(排除优先级最低的容器)
						local lowest_containers = nil--优先级最低的容器
						if krampus_chest ~= nil and medium_containers ~= nil then
							medium_containers[krampus_chest] = true
						end
						--坎普斯宝匣优先级最低
						if TUNING.MEDAL_KRAMPUS_CHEST_PRIORITY>1 then
							lowest_containers = krampus_chest ~= nil and {[krampus_chest] = true} or nil
						else--坎普斯宝匣优先级中等
							lowest_containers = backpack ~= nil and { [backpack] = true } or nil
						end

						--按优先级由高到低的顺序挨个找最适合的容器
						dest_inst = FindBestContainer(self, container_item, opencontainers, medium_containers)
							or FindBestContainer(self, container_item, medium_containers, lowest_containers)
							or FindBestContainer(self, container_item, lowest_containers)
					--当前容器是外挂容器(背包)
					elseif container == overflow then
						local playercontainers = { [backpack] = true }--背包
						local krampus_chests = krampus_chest ~= nil and {[krampus_chest] = true} or nil--坎普斯宝匣
						if krampus_chest ~= nil then
							playercontainers[krampus_chest] = true
						end
						--坎普斯宝匣优先级最低
						if TUNING.MEDAL_KRAMPUS_CHEST_PRIORITY>1 then
							--先从玩家打开的容器列表里找合适的容器(背包、坎普斯宝匣除外)，找不到就看看玩家的物品栏行不行，不行再看坎普斯宝匣
							dest_inst = FindBestContainer(self, container_item, opencontainers, playercontainers)
							or (inventory:IsOpenedBy(character)
								and FindBestContainer(self, container_item, { [character] = true })
								or nil)
							or FindBestContainer(self, container_item, krampus_chests)
						else--坎普斯宝匣优先级中等
							--先从玩家打开的容器列表里找合适的容器(背包、坎普斯宝匣除外)，找不到就看看坎普斯宝匣行不行，不行再看玩家的物品栏
							dest_inst = FindBestContainer(self, container_item, opencontainers, playercontainers)
							or FindBestContainer(self, container_item, krampus_chests)
							or (inventory:IsOpenedBy(character)
								and FindBestContainer(self, container_item, { [character] = true })
								or nil)
						end
					else
						local exclude_containers = { [container.inst] = true }
						if backpack ~= nil then
							exclude_containers[backpack] = true
						end
						if krampus_chest ~= nil then
							exclude_containers[krampus_chest] = true
						end
						--坎普斯宝匣优先级最低
						if TUNING.MEDAL_KRAMPUS_CHEST_PRIORITY>1 then
							--先从玩家打开的容器列表里找合适的容器(背包和当前容器除外),其次物品栏，然后是背包,最后坎普斯宝匣
							dest_inst = FindBestContainer(self, container_item, opencontainers, exclude_containers)
							or (inventory:IsOpenedBy(character)
								and FindBestContainer(self, container_item, { [character] = true })
								or nil)
							or FindBestContainer(self, container_item, backpack ~= nil and { [backpack] = true } or nil)
							or krampus_chest
						else--坎普斯宝匣优先级中等
							--先从玩家打开的容器列表里找合适的容器(背包和当前容器除外),其次坎普斯宝匣，然后是物品栏,最后背包
							dest_inst = FindBestContainer(self, container_item, opencontainers, exclude_containers)
							or FindBestContainer(self, container_item, krampus_chest ~= nil and { [krampus_chest] = true } or nil,{ [container.inst] = true })
							or (inventory:IsOpenedBy(character)
								and FindBestContainer(self, container_item, { [character] = true })
								or nil)
							or FindBestContainer(self, container_item, backpack ~= nil and { [backpack] = true } or nil)
						end
					end

					--if a destination container/inv is found...
					if dest_inst ~= nil then
						if stack_mod and
							container_item.replica.stackable ~= nil and
							container_item.replica.stackable:IsStack() then
							container:MoveItemFromHalfOfSlot(slot_number, dest_inst)
						else
							container:MoveItemFromAllOfSlot(slot_number, dest_inst)
						end
						TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/click_object")
					else
						TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/click_negative")
					end
				end
			elseif oldTradeItem then
				oldTradeItem(self,stack_mod, ...)
			end
		end
	end
end)

------------------------------------------------------------------------------------------------------
-------------------------------------------补充调味料理-----------------------------------------------
------------------------------------------------------------------------------------------------------

--Mod加载完后给所有食谱添加一遍新调料的料理，以下代码参考了风铃大佬的小穹，风铃大佬牛逼！
local oldRegisterPrefabs = GLOBAL.ModManager.RegisterPrefabs 

GLOBAL.ModManager.RegisterPrefabs = function(self,...)
    --这个时候 PrefabFiles文件还没有被加载
	
	--所有的菜谱都过一遍，把需要添加新料理的食谱都记下来
    for k,v in pairs(cooking.recipes) do
        if k and v and k ~= "portablespicer" then
			medal_spicedfoods.MedalGenerateSpicedFoods(v)
			--添加菜谱到红晶锅里
			for a,b in pairs(v) do
				--hook彩虹糖豆配方，让凋零蜂王浆可以做糖豆
				if a=="jellybean" then
					local oldtest = b.test
					b.test = function(cooker, names, tags) return (names.medal_withered_royaljelly and not tags.inedible and not tags.monster) or oldtest(cooker, names, tags) end
				end

				if not (b.spice or b.platetype) then--要把调味料理排除掉,把有盘子的料理排除掉(暴食的)
					local newrecipe=shallowcopy(b)--浅拷贝一份料理数据
					newrecipe.no_cookbook=true--不应该显示到食谱书里去
					AddCookerRecipe("medal_cookpot",newrecipe)
				end
			end
        end
    end
	--添加新的调味料理食谱
    for k,v in pairs(medal_spicedfoods.MedalGetNewRecipes()) do
        AddCookerRecipe("portablespicer",v)
    end
    oldRegisterPrefabs(self,...)
end

--水中木资源替换
-- local ocean_tree_loot={
-- 	"oceantree_pillar",
--     "oceantree_pillar_ripples",
--     "oceantree_pillar_roots",
--     "oceantree_pillar_leaves",
-- }
-- for k, v in ipairs(ocean_tree_loot) do
-- 	AddPrefabPostInit(v,function(inst)
-- 		inst.AnimState:SetBuild("medal_oceantree_pillar_small_build1")
--     	inst.AnimState:AddOverrideBuild("medal_oceantree_pillar_small_build2")
-- 	end)
-- end