--首次交易掉落
local first_loot = {
	medal_statue_marble_gugugu = {--大帅鸽
		prefab = "messagebottleempty",--空瓶子
		num = 2,
	},
	medal_statue_marble_saltfish = {--咸鱼
		prefab = "oceanfish_small_9_inv",--口水鱼
		num = 1,
	},
	medal_statue_marble_stupidcat = {--猫猫
		prefab = "medal_weed_seeds",--杂草种子
		num = 5,
	},
}
--专有掉落
local gift_loot = {
	--大帅鸽
	medal_statue_marble_gugugu = {
		"glommerfuel",--格罗姆黏液
		"glommerwings",--格罗姆翅膀
		"medal_glommer_essence",--格罗姆精华
	},
	--咸鱼
	medal_statue_marble_saltfish = {
		"spice_salt",--盐粉
		"saltrock",--盐晶
		"oceanfish_small_1_inv",--小孔雀鱼
		"oceanfish_small_2_inv",--针鼻喷墨鱼
		"oceanfish_small_3_inv",--小饵鱼
		"oceanfish_small_4_inv",--三文鱼
	},
	--猫猫
	medal_statue_marble_stupidcat = {
		"medal_fishbones",--鱼骨
		"fishtacos",--鱼肉玉米卷
		"ceviche",--酸橘汁腌鱼
		"barnaclestuffedfishhead",--酿鱼头
		"seafoodgumbo",--海鲜鱼汤
		"fishsticks",--炸鱼排
	},
}
--填充掉落
local nomal_loot = {
	"livinglog",--活木
	"nitre",--硝石
	"mosquitosack",--蚊子血囊
	"compostwrap",--肥料包
	"moonglass",--玻璃碎片
}
--任务掉落
local task_loot = {
	medal_statue_marble_gugugu = "mission_certificate",--大帅鸽,使命勋章
	medal_statue_marble_saltfish = "medal_tribute_symbol",--咸鱼,奉纳符
	medal_statue_marble_stupidcat = "medal_gift_fruit_seed",--猫猫,包果种子
}
--生成任务物品
local function spawnTask(prefab,doer)
	local item = SpawnPrefab(prefab)
	if item then
		if item.InitMission then
			item:InitMission(nil,nil,doer)--一切都是为了宿命
		end
		-- if prefab=="medal_gift_fruit_seed" and item.components.stackable then
		-- 	item.components.stackable.stacksize=2
		-- end
	end
	return item
end

--py交易礼物(inst,是不是第一个交易的人,是不是第一次交易,交易者)
local function pyGift(inst, thefirst, isfirst, doer)
	--是第一次交易,给特殊礼包
	if isfirst then
		local bundleitems = {}
		--第一个py的人有好东西
		if thefirst then
			local firstItem=SpawnPrefab(first_loot[inst.prefab].prefab)
			if firstItem.components.stackable and first_loot[inst.prefab].num>1 then
				firstItem.components.stackable.stacksize = first_loot[inst.prefab].num
			end
			table.insert(bundleitems, firstItem)
		end
		--专有掉落
		table.insert(bundleitems, spawnTask(task_loot[inst.prefab],doer))
		table.insert(bundleitems, SpawnPrefab(GetRandomItem(gift_loot[inst.prefab])))
		--填充掉落
		for i=#bundleitems,3 do
			table.insert(bundleitems, SpawnPrefab(GetRandomItem(nomal_loot)))
		end
		
		local bundle = SpawnPrefab("gift")
		bundle.components.unwrappable:WrapItems(bundleitems)
		for i, v in ipairs(bundleitems) do
			v:Remove()
		end
		if inst.components.lootdropper then
			inst.components.lootdropper:FlingItem(bundle)
		end
	elseif inst.components.lootdropper then
		inst.components.lootdropper:FlingItem(spawnTask(task_loot[inst.prefab],doer))
	end
end

--回收列表
local junk_loot = {
	mission_certificate = "glommerfuel",--使命勋章-格罗姆黏液
	medal_loss_treasure_map = function(inst)--遗失藏宝图--对应的奖励道具
		return task_loot[inst.prefab] or "medal_gift_fruit_seed"
	end,
}

--收破烂
local function recyclingJunk(inst,junk)
	local gift = junk and FunctionOrValue(junk_loot[junk.prefab],inst)
	if gift and inst.components.lootdropper then
		inst.components.lootdropper:SpawnLootPrefab(gift)
		return true
	end
end

--直接破坏掉
local function destory(inst, worker, workleft)
	if workleft <= 0 then
		local pos = inst:GetPosition()
		SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
		inst.components.lootdropper:DropLoot(pos)
		inst:Remove()
	end
end

local medal_statue_defs={
	{--缪斯1
		assets={
			Asset("ANIM", "anim/statue_small_type1_build.zip"),
			Asset("ANIM", "anim/statue_small.zip"),
			Asset("MINIMAP_IMAGE", "statue_small"),
			Asset("ATLAS", "images/medal_statue_marble_muse1.xml"),
			Asset("IMAGE", "images/medal_statue_marble_muse1.tex"),
		},
		name="medal_statue_marble_muse1",
		bank="statue_small",
		build="statue_small",
		anim="full",
		minimap="statue_small.png",
		symbol="statue_small_type1_build",
	},
	{--缪斯2
		assets={
			Asset("ANIM", "anim/statue_small_type2_build.zip"),
			Asset("ANIM", "anim/statue_small.zip"),
			Asset("MINIMAP_IMAGE", "statue_small"),
			Asset("ATLAS", "images/medal_statue_marble_muse2.xml"),
			Asset("IMAGE", "images/medal_statue_marble_muse2.tex"),
		},
		name="medal_statue_marble_muse2",
		bank="statue_small",
		build="statue_small",
		anim="full",
		minimap="statue_small.png",
		symbol="statue_small_type2_build",
	},
	{--瓷瓶
		assets={
			Asset("ANIM", "anim/statue_small_type3_build.zip"),
			Asset("ANIM", "anim/statue_small.zip"),
			Asset("MINIMAP_IMAGE", "statue_small"),
			Asset("ATLAS", "images/medal_statue_marble_urn.xml"),
			Asset("IMAGE", "images/medal_statue_marble_urn.tex"),
		},
		name="medal_statue_marble_urn",
		bank="statue_small",
		build="statue_small",
		anim="full",
		minimap="statue_small.png",
		symbol="statue_small_type3_build",
	},
	{--兵卒
		assets={
			Asset("ANIM", "anim/statue_small_type4_build.zip"),
			Asset("ANIM", "anim/statue_small.zip"),
			Asset("MINIMAP_IMAGE", "statue_small"),
			Asset("ATLAS", "images/medal_statue_marble_pawn.xml"),
			Asset("IMAGE", "images/medal_statue_marble_pawn.tex"),
		},
		name="medal_statue_marble_pawn",
		bank="statue_small",
		build="statue_small",
		anim="full",
		minimap="statue_small.png",
		symbol="statue_small_type4_build",
	},
	{--丘比特
		assets={
			Asset("ANIM", "anim/statue_small_harp_build.zip"),
			Asset("ANIM", "anim/statue_small.zip"),
			Asset("MINIMAP_IMAGE", "statue_small"),
			Asset("ATLAS", "images/medal_statue_marble_harp.xml"),
			Asset("IMAGE", "images/medal_statue_marble_harp.tex"),
		},
		name="medal_statue_marble_harp",
		bank="statue_small",
		build="statue_small",
		anim="full",
		minimap="statue_small.png",
		symbol="statue_small_harp_build",
	},
	{--老麦
		assets={
			Asset("ANIM", "anim/statue_maxwell.zip"),
            Asset("ANIM", "anim/statue_maxwell_build.zip"),
            Asset("ANIM", "anim/statue_maxwell_vine_build.zip"),
			Asset("MINIMAP_IMAGE", "statue"),
			Asset("ATLAS", "images/medal_statue_marble_maxwell.xml"),
			Asset("IMAGE", "images/medal_statue_marble_maxwell.tex"),
		},
		name="medal_statue_marble_maxwell",
		bank="statue_maxwell",
		build="statue_maxwell_build",
		anim="idle_full",
		minimap="statue.png",
		onworkfn=function(inst, worker, workleft)
			if workleft <= 0 then
				local pos = inst:GetPosition()
				SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
				TheWorld:PushEvent("ms_unlockchesspiece", "formal")
				inst.components.lootdropper:DropLoot(pos)
				inst:Remove()
			elseif workleft < TUNING.MARBLEPILLAR_MINE / 3 then
				inst.AnimState:PlayAnimation("hit_low")
				inst.AnimState:PushAnimation("idle_low")
			elseif workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 then
				inst.AnimState:PlayAnimation("hit_med")
				inst.AnimState:PushAnimation("idle_med")
			else
				inst.AnimState:PlayAnimation("hit_full")
				inst.AnimState:PushAnimation("idle_full")
			end
		end,
	},
	{--格罗姆
		assets={
			Asset("ANIM", "anim/glommer_statue.zip"),
			-- Asset("MINIMAP_IMAGE", "statueglommer"),
			Asset("ATLAS", "images/medal_statue_marble_glommer.xml"),
			Asset("IMAGE", "images/medal_statue_marble_glommer.tex"),
		},
		name="medal_statue_marble_glommer",
		bank="glommer_statue",
		build="glommer_statue",
		anim="full",
		minimap="statueglommer.png",
	},
	{--咕咕咕
		assets={
			Asset("ANIM", "anim/medal_statue_gugugu.zip"),
			Asset("ANIM", "anim/medal_statue_gugugu_skin1.zip"),
			Asset("ANIM", "anim/medal_statue_gugugu_skin2.zip"),
			Asset("ANIM", "anim/medal_statue_gugugu_skin3.zip"),
			Asset("ANIM", "anim/statue_small.zip"),
			Asset("MINIMAP_IMAGE", "statue_small"),
			Asset("ATLAS", "images/medal_statue_marble_gugugu.xml"),
			Asset("IMAGE", "images/medal_statue_marble_gugugu.tex"),
		},
		name="medal_statue_marble_gugugu",
		bank="statue_small",
		build="statue_small",
		anim="full",
		minimap="statue_small.png",
		symbol="medal_statue_gugugu",
		taglist={
			"medal_skinable",--可换皮肤
			"medal_trade",--可交易
		},
		onworkfn=destory,--直接破坏掉
		masterfn = function(inst)
			inst:AddComponent("medal_skinable")--可换皮肤
			inst.pyTradeFn = pyGift--PY交易
			inst.recyclingJunk = recyclingJunk--收破烂
		end,
	},
	{--咸鱼
		assets={
			Asset("ANIM", "anim/medal_statue_saltfish.zip"),
			Asset("ANIM", "anim/medal_statue_saltfish_skin1.zip"),
			Asset("ANIM", "anim/medal_statue_saltfish_skin2.zip"),
			Asset("ANIM", "anim/medal_statue_saltfish_skin3.zip"),
			Asset("ANIM", "anim/statue_small.zip"),
			Asset("MINIMAP_IMAGE", "statue_small"),
			Asset("ATLAS", "images/medal_statue_marble_saltfish.xml"),
			Asset("IMAGE", "images/medal_statue_marble_saltfish.tex"),
		},
		name="medal_statue_marble_saltfish",
		bank="statue_small",
		build="statue_small",
		anim="full",
		minimap="statue_small.png",
		symbol="medal_statue_saltfish",
		taglist={
			"medal_skinable",--可换皮肤
			"medal_trade",--可交易
		},
		onworkfn=destory,--直接破坏掉
		masterfn = function(inst)
			inst:AddComponent("medal_skinable")--可换皮肤
			inst.pyTradeFn = pyGift--PY交易
			inst.recyclingJunk = recyclingJunk--收破烂
		end,
	},
	{--沙雕猫
		assets={
			Asset("ANIM", "anim/medal_statue_stupidcat.zip"),
			Asset("ANIM", "anim/medal_statue_stupidcat_skin1.zip"),
			Asset("ANIM", "anim/medal_statue_stupidcat_skin2.zip"),
			Asset("ANIM", "anim/statue_small.zip"),
			Asset("MINIMAP_IMAGE", "statue_small"),
			Asset("ATLAS", "images/medal_statue_marble_stupidcat.xml"),
			Asset("IMAGE", "images/medal_statue_marble_stupidcat.tex"),
		},
		name="medal_statue_marble_stupidcat",
		bank="statue_small",
		build="statue_small",
		anim="full",
		minimap="statue_small.png",
		symbol="medal_statue_stupidcat",
		taglist={
			"medal_skinable",--可换皮肤
			"medal_trade",--可交易
		},
		onworkfn=destory,--直接破坏掉
		masterfn = function(inst)
			inst:AddComponent("medal_skinable")--可换皮肤
			inst.pyTradeFn = pyGift--PY交易
			inst.recyclingJunk = recyclingJunk--收破烂
		end,
	},
	{--大黑蛋子
		assets={
			Asset("ANIM", "anim/medal_statue_blackegg.zip"),
			Asset("ANIM", "anim/medal_statue_blackegg_skin1.zip"),
			Asset("ANIM", "anim/medal_statue_blackegg_skin2.zip"),
			Asset("ANIM", "anim/statue_small.zip"),
			Asset("MINIMAP_IMAGE", "statue_small"),
			Asset("ATLAS", "images/medal_statue_marble_blackegg.xml"),
			Asset("IMAGE", "images/medal_statue_marble_blackegg.tex"),
		},
		name="medal_statue_marble_blackegg",
		bank="statue_small",
		build="statue_small",
		anim="full",
		minimap="statue_small.png",
		symbol="medal_statue_blackegg",
		taglist={
			"medal_skinable",--可换皮肤
		},
		masterfn = function(inst)
			inst:AddComponent("medal_skinable")--可换皮肤
		end,
	},
	{--百变雕像
		assets={
			Asset("ANIM", "anim/medal_statue_changeable.zip"),
			Asset("ANIM", "anim/medal_statue_changeable_skin1.zip"),
			Asset("ANIM", "anim/medal_statue_changeable_skin2.zip"),
			Asset("ANIM", "anim/medal_statue_changeable_skin3.zip"),
			Asset("ANIM", "anim/medal_statue_changeable_skin4.zip"),
			Asset("ANIM", "anim/medal_statue_changeable_skin5.zip"),
			Asset("ANIM", "anim/medal_statue_changeable_skin6.zip"),
			Asset("ANIM", "anim/statue_small.zip"),
			Asset("MINIMAP_IMAGE", "statue_small"),
			Asset("ATLAS", "images/medal_statue_marble_changeable.xml"),
			Asset("IMAGE", "images/medal_statue_marble_changeable.tex"),
		},
		name="medal_statue_marble_changeable",
		bank="statue_small",
		build="statue_small",
		anim="full",
		minimap="statue_small.png",
		symbol="medal_statue_changeable",
		taglist={
			"medal_skinable",--可换皮肤
		},
		onworkfn=destory,--直接破坏掉
		masterfn = function(inst)
			inst:AddComponent("medal_skinable")--可换皮肤
		end,
	},
	{--百花盆栽
		assets={
			Asset("ANIM", "anim/medal_statue_potting.zip"),
			Asset("ANIM", "anim/medal_statue_potting_skin1.zip"),
			Asset("ANIM", "anim/medal_statue_potting_skin2.zip"),
			Asset("ANIM", "anim/medal_statue_potting_skin3.zip"),
			Asset("ANIM", "anim/medal_statue_potting_skin4.zip"),
			Asset("ANIM", "anim/medal_statue_potting_skin5.zip"),
			Asset("ANIM", "anim/medal_statue_potting_skin6.zip"),
			Asset("MINIMAP_IMAGE", "statue_small"),
			Asset("ATLAS", "images/medal_statue_marble_potting.xml"),
			Asset("IMAGE", "images/medal_statue_marble_potting.tex"),
		},
		name="medal_statue_marble_potting",
		bank="medal_statue_potting",
		build="medal_statue_potting",
		anim="full",
		minimap="statue_small.png",
		taglist={
			"medal_skinable",--可换皮肤
		},
		workleft=3,--镐击次数
		onworkfn=destory,--直接破坏掉
		masterfn = function(inst)
			inst:AddComponent("medal_skinable")--可换皮肤
		end,
		nophysics=true,--无碰撞体积
	},
}

return medal_statue_defs
