require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/dragonfly_chest.zip"),
	Asset("ANIM", "anim/medal_toy_chest.zip"),
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
	{key="medalslingshotammo_sanityrock",weight=1},--方尖弹
	{key="medalslingshotammo_sandspike",weight=1},--沙刺弹
	{key="medalslingshotammo_water",weight=1},--落水弹
	{key="medalslingshotammo_taunt",weight=1},--痰蛋弹
	{key="medalslingshotammo_spines",weight=1},--尖刺弹
}
--遗失物品包
local book_loot={
	{key="immortal_book",weight=1},--不朽之谜
	{key="monster_book",weight=1},--怪物图鉴
	{key="unsolved_book",weight=1},--未解之谜
	{key="medal_treasure_map_scraps1",weight=1},--藏宝图碎片·日出
	{key="medal_treasure_map_scraps2",weight=1},--藏宝图碎片·黄昏
	{key="medal_treasure_map_scraps3",weight=1},--藏宝图碎片·夜晚
}
--宝石礼包
local gem_loot={
	{key="redgem",weight=1},--红宝石
	{key="bluegem",weight=1},--蓝宝石
	{key="purplegem",weight=0.75},--紫宝石
	{key="orangegem",weight=0.5},--橙宝石
	{key="greengem",weight=0.25},--绿宝石
	{key="yellowgem",weight=0.5},--黄宝石
	{key="opalpreciousgem",weight=0.05},--彩虹宝石
}

--掉落礼物(inst,是否为万圣节掉落,空白勋章数量,本源加成)
local function DropGifts(inst,ishalloween,blank_medal_num,has_origin)
	local bundleitems = {}
	local destiny_num = GetMedalDestiny(inst)--宿命
	if ishalloween then
		--万圣节糖果
		for i=1,4 do
			local candy = SpawnPrefab("halloweencandy_"..GetMedalRandomNum(destiny_num,NUM_HALLOWEENCANDY or 2))
			if candy and candy.components.stackable then
				destiny_num = destiny_num*10%1
				candy.components.stackable.stacksize = GetMedalRandomNum(destiny_num,20)
			end
			table.insert(bundleitems, candy)
		end
	else
		local ammo_mult = has_origin and 1.2 or 1--有本源童真的话弹药数量增加20%
		--噬魂弹
		local devoursoulammo=SpawnPrefab("medalslingshotammo_devoursoul")
		if devoursoulammo and devoursoulammo.components.stackable then
			local ammo_num= destiny_num < .9 and 5 or 10
			--根据空白勋章数量额外给 勋章数量*4~勋章数量*8 个噬魂弹
			if blank_medal_num and blank_medal_num>0 then
				destiny_num = destiny_num*10%1
				ammo_num = ammo_num + GetMedalRandomNum(destiny_num,blank_medal_num*8,blank_medal_num*4)
			end
			devoursoulammo.components.stackable.stacksize = math.min(math.floor(ammo_num * ammo_mult),60)
		end
		table.insert(bundleitems, devoursoulammo)
		--随机弹药
		destiny_num = destiny_num*10%1
		local ammo = SpawnPrefab(GetMedalRandomItem(ammo_loot,destiny_num))
		if ammo and ammo.components.stackable then
			ammo.components.stackable.stacksize = math.floor(20 * ammo_mult)
		end
		table.insert(bundleitems, ammo)
		--特制鱼食
		-- local chum=SpawnPrefab("medal_chum")
		-- if chum and chum.components.stackable then
		-- 	chum.components.stackable.stacksize = 2
		-- end
		-- table.insert(bundleitems, chum)
		destiny_num = destiny_num*10%1
		if destiny_num<.5 then
			--随机书籍
			destiny_num = destiny_num*10%1
			table.insert(bundleitems, SpawnPrefab(GetMedalRandomItem(book_loot,destiny_num)))
		else
			--随机宝石
			destiny_num = destiny_num*10%1
			table.insert(bundleitems, SpawnPrefab(GetMedalRandomItem(gem_loot,destiny_num)))
		end
		
	end
	
	
    local bundle = SpawnPrefab("gift")
    bundle.components.unwrappable:WrapItems(bundleitems)
    for i, v in ipairs(bundleitems) do
        v:Remove()
    end
    inst.components.lootdropper:FlingItem(bundle)
end

--兑换礼物
local function exchangeGift(inst,player)
	local itemlist=inst.components.container:GetAllItems()
	local trinket_list={}--玩具种类表
	local halloween_toy_num=0--万圣节玩具数量
	local blank_medal_num=0--空白勋章数量
	for k,v in ipairs(itemlist) do
		--不能有玩具、空白勋章之外的东西
		if not (IsTrinket(v.prefab) or v:HasTag("blank_certificate")) then
			MedalSay(player,STRINGS.EXCHANGEGIFT_SPEECH.FAIL2)
			return false
		end
		--不能有堆叠的物品
		if v.components.stackable and v.components.stackable:IsStack() then
			MedalSay(player,STRINGS.EXCHANGEGIFT_SPEECH.FAIL1)
			return false
		end
		if (not v:HasTag("blank_certificate")) and not table.contains(trinket_list,v.prefab) then 
			table.insert(trinket_list,v.prefab)
		end
		--统计万圣节玩具数量
		if IsTrinket(v.prefab,true) then
			halloween_toy_num=halloween_toy_num+1
		end
		--统计空白勋章数量
		if v:HasTag("blank_certificate") then
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
	DropGifts(inst,halloween_toy_num>1,blank_medal_num,HasOriginMedal(player,"senior_childishness"))--掉落礼物
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
			inst:AddComponent("medal_itemdestiny")--宿命
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
