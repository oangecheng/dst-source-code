require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/dragonfly_chest.zip"),
	Asset("ANIM", "anim/medal_toy_chest.zip"),
	Asset("ANIM", "anim/medal_toy_chest_skin1.zip"),
    Asset("ANIM", "anim/ui_chester_shadow_3x4.zip"),
    Asset("ANIM", "anim/ui_tacklecontainer_3x5.zip"),
	Asset("ATLAS", "minimap/medal_childishness_chest.xml" ),
	Asset("ATLAS", "images/medal_childishness_chest.xml"),
	Asset("IMAGE", "images/medal_childishness_chest.tex"),
}

local prefabs =
{
    "collapse_small",
	"medal_treasure_map_scraps1",
	"medal_treasure_map_scraps2",
	"medal_treasure_map_scraps3",
}

local function onopen(inst)
    inst.AnimState:PlayAnimation("open")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
end

local function onclose(inst)
    inst.AnimState:PlayAnimation("closed")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
	--关闭箱子时如果满了则掉落童心勋章并移除箱子
	if inst.prefab=="medal_toy_chest" and inst.components.container and inst.components.container:IsFull() then
		inst.components.lootdropper:SpawnLootPrefab("childishness_certificate")
		local fx = SpawnPrefab("collapse_small")
		fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		fx:SetMaterial("wood")
		inst.components.container:DestroyContents()--销毁里面的物品
		inst:Remove()
	end
end

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("closed", false)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end
end

--子弹包
local ammo_loot={
	"medalslingshotammo_sanityrock",--方尖弹
	"medalslingshotammo_sandspike",--沙刺弹
	"medalslingshotammo_water",--落水弹
	"medalslingshotammo_taunt",--痰蛋弹
	"medalslingshotammo_spines",--尖刺弹
}
--糖果包
local candy_loot={
	"jellybean",--彩虹糖豆
	"taffy",--太妃糖
	"spice_blood_sugar",--血糖
	"spice_rage_blood_sugar",--黑暗血糖
}
--遗失物品包
local book_loot={
	-- "trapreset_book",--陷阱重置册
	-- "autotrap_book",--智能陷阱重置册
	"immortal_book",--不朽之谜
	"monster_book",--怪物图鉴
	"unsolved_book",--未解之谜
	-- "book_tentacles",--触手书
	-- "book_brimstone",--末日将至
	-- "book_gardening",--应用园艺学
	"medal_treasure_map_scraps1",--藏宝图碎片·日出
	"medal_treasure_map_scraps2",--藏宝图碎片·黄昏
	"medal_treasure_map_scraps3",--藏宝图碎片·夜晚
}
--宝石礼包
local gem_loot={
	redgem=1,--红宝石
	bluegem=1,--蓝宝石
	purplegem=0.75,--紫宝石
	orangegem=0.5,--橙宝石
	greengem=0.25,--绿宝石
	yellowgem=0.5,--黄宝石
	opalpreciousgem=0.05,--彩虹宝石
}

--掉落礼物(inst,是否为万圣节掉落,空白勋章数量)
local function DropGifts(inst,ishalloween,blank_medal_num)
	local bundleitems = {}
	if ishalloween then
		--万圣节糖果
		for i=1,4 do
			local candy=SpawnPrefab("halloweencandy_"..math.random(NUM_HALLOWEENCANDY or 2))
			if candy and candy.components.stackable then
				candy.components.stackable.stacksize = math.random(20)
			end
			table.insert(bundleitems, candy)
		end
	else
		--噬魂弹
		local devoursoulammo=SpawnPrefab("medalslingshotammo_devoursoul")
		if devoursoulammo and devoursoulammo.components.stackable then
			local ammo_num= math.random()<.9 and 5 or 10
			--根据空白勋章数量额外给 勋章数量*4~勋章数量*8 个噬魂弹
			if blank_medal_num and blank_medal_num>0 then
				ammo_num=ammo_num+math.random(blank_medal_num*4,blank_medal_num*8)
			end
			devoursoulammo.components.stackable.stacksize = math.min(ammo_num,60)
		end
		table.insert(bundleitems, devoursoulammo)
		--随机弹药
		local ammo=SpawnPrefab(GetRandomItem(ammo_loot))
		if ammo and ammo.components.stackable then
			ammo.components.stackable.stacksize = 20
		end
		table.insert(bundleitems, ammo)
		--随机糖果
		-- local candy=SpawnPrefab(GetRandomItem(candy_loot))
		-- if candy and candy.components.stackable then
		-- 	candy.components.stackable.stacksize = math.random(5)
		-- end
		-- table.insert(bundleitems, candy)
		--特制鱼食
		local chum=SpawnPrefab("medal_chum")
		if chum and chum.components.stackable then
			chum.components.stackable.stacksize = 2
		end
		table.insert(bundleitems, chum)

		if math.random()<.5 then
			--随机书籍
			table.insert(bundleitems, SpawnPrefab(GetRandomItem(book_loot)))
		else
			--随机宝石
			table.insert(bundleitems, SpawnPrefab(weighted_random_choice(gem_loot)))
		end
		
	end
	
	
    local bundle = SpawnPrefab("gift")
    bundle.components.unwrappable:WrapItems(bundleitems)
    for i, v in ipairs(bundleitems) do
        v:Remove()
    end
    inst.components.lootdropper:FlingItem(bundle)
end
--万圣节玩具列表
local halloween_toy_list={}
if HALLOWEDNIGHTS_TINKET_START and HALLOWEDNIGHTS_TINKET_END then
	for i=HALLOWEDNIGHTS_TINKET_START,HALLOWEDNIGHTS_TINKET_END do
		table.insert(halloween_toy_list,"trinket_"..i)
	end
end

--兑换礼物
local function exchangeGift(inst,player)
	local itemlist=inst.components.container:GetAllItems()
	local trinket_list={}--玩具种类表
	local halloween_toy_num=0--万圣节玩具数量
	local blank_medal_num=0--空白勋章数量
	for k,v in ipairs(itemlist) do
		--不能有玩具、空白勋章之外的东西
		if string.sub(v.prefab,1,8)~="trinket_" and v.prefab~="antliontrinket" and v.prefab~="blank_certificate" then
			MedalSay(player,STRINGS.EXCHANGEGIFT_SPEECH.FAIL2)
			return false
		end
		--不能有堆叠的物品
		if v.components.stackable and v.components.stackable:IsStack() then
			MedalSay(player,STRINGS.EXCHANGEGIFT_SPEECH.FAIL1)
			return false
		end
		if v.prefab~="blank_certificate" and not table.contains(trinket_list,v.prefab) then 
			table.insert(trinket_list,v.prefab)
		end
		--统计万圣节玩具数量
		if table.contains(halloween_toy_list,v.prefab) then
			halloween_toy_num=halloween_toy_num+1
		end
		--统计空白勋章数量
		if v.prefab=="blank_certificate" then
			blank_medal_num=blank_medal_num+1
		end
	end
	--种类太少
	if #trinket_list<5 then
		MedalSay(player,STRINGS.EXCHANGEGIFT_SPEECH.FAIL3)
		return false
	end
	--兑换成功
	MedalSay(player,halloween_toy_num>1 and STRINGS.EXCHANGEGIFT_SPEECH.HALLOWEEN or STRINGS.EXCHANGEGIFT_SPEECH.SUCCESS)
	inst.components.container:DestroyContents()--销毁里面的物品
	inst.components.container:Close()--关闭容器
	DropGifts(inst,halloween_toy_num>1,blank_medal_num)--掉落礼物
	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("wood")
	inst:Remove()
end

--定义箱子(预置物名,是否是玩具箱)
local function MakeChest(name,istoychest)
	local function fn()
	    local inst = CreateEntity()
	
	    inst.entity:AddTransform()
	    inst.entity:AddAnimState()
	    inst.entity:AddSoundEmitter()
	    inst.entity:AddMiniMapEntity()
	    inst.entity:AddNetwork()
	
	    inst.MiniMapEntity:SetIcon("medal_childishness_chest.tex")
	
	    inst.AnimState:SetBank("dragonfly_chest")--用龙鳞箱的bank
	    inst.AnimState:SetBuild("medal_toy_chest")
	    inst.AnimState:PlayAnimation("closed",true)
	
	    inst:AddTag("structure")
	    inst:AddTag("chest")
		if not istoychest then
			inst:AddTag("medal_skinable")--可换皮肤
		end
		-- if istoychest then
		-- 	inst:AddTag("cantdestroy")--不可破坏
		-- 	inst:AddTag("medal_toy_chest")--玩具箱标签(世界唯一标记)
		-- end
	
	    MakeSnowCoveredPristine(inst)
	
	    inst.entity:SetPristine()
	
	    if not TheWorld.ismastersim then
			-- inst.OnEntityReplicated = function(inst) 
				-- inst.replica.container:WidgetSetup("dragonflychest") 
			-- end
			return inst
	    end
	
	    inst:AddComponent("inspectable")
	    inst:AddComponent("container")
	    inst.components.container:WidgetSetup(name)
	    -- inst.components.container:WidgetSetup("dragonflychest")
	    inst.components.container.onopenfn = onopen
	    inst.components.container.onclosefn = onclose
	
	    inst:AddComponent("lootdropper")
		if istoychest then--玩具箱锤了掉藏宝图碎片
			inst.components.lootdropper:AddChanceLoot("medal_treasure_map_scraps1", 1)
			inst.components.lootdropper:AddChanceLoot("medal_treasure_map_scraps2", 1)
			inst.components.lootdropper:AddChanceLoot("medal_treasure_map_scraps3", 1)
		end
	    inst:AddComponent("workable")
	    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	    inst.components.workable:SetWorkLeft(10)
	    inst.components.workable:SetOnFinishCallback(onhammered)
	    inst.components.workable:SetOnWorkCallback(onhit)
		
	    MakeSnowCovered(inst)
		--兼容智能木牌
		if TUNING.SMART_SIGN_DRAW_ENABLE then
			SMART_SIGN_DRAW(inst)
		end
		
		if not istoychest then
			inst.exchangeGift=exchangeGift--兑换礼物函数
			MakeMediumBurnable(inst, nil, nil, false)--可燃
			local onburnt=inst.components.burnable.onburnt
			inst.components.burnable:SetOnBurntFn(function(inst)
				if inst.components.container then
					inst.components.container:DropEverything()
					inst.components.container:Close()
					inst:RemoveComponent("container")
				end
				if onburnt then
					onburnt(inst)
				end
			end)
			MakeMediumPropagator(inst)--可引燃
			inst:AddComponent("medal_skinable")
		end
		
		AddHauntableDropItemOrWork(inst)
	
	    return inst
	end
	
	return Prefab(name, fn, assets)
end

return MakeChest("medal_toy_chest",true),
	MakeChest("medal_childishness_chest",false),
	MakePlacer("medal_childishness_chest_placer", "dragonfly_chest", "medal_toy_chest", "closed")
