local assets =
{
	Asset("ANIM", "anim/medal_monster_symbol.zip"),
	Asset("ATLAS", "images/medal_monster_symbol.xml"),
	Asset("ATLAS_BUILD", "images/medal_monster_symbol.xml",256),
}

SetSharedLootTable('medal_monster_1',--默认掉落
{
    {'medal_gift_fruit',  1},
})

-- SetSharedLootTable('medal_monster_2',--彩蛋掉落，额外掉落种子
-- {
--     {'medal_gift_fruit',  1},
--     {'medal_gift_fruit',  1},
--     {'medal_gift_fruit_seed',  0.25},
-- })

-- for i=4,12 do
-- 	local newloot={}
-- 	local seedNum = math.floor(i/4)--种子数量
--     local fruitNum = i%4--果实数量

--     for n = 1, seedNum do
-- 		table.insert(newloot,{'medal_gift_fruit_seed', 1})
-- 	end
-- 	for m = 1, fruitNum do
-- 		table.insert(newloot,{'medal_gift_fruit', 1})
-- 	end

-- 	SetSharedLootTable("medal_monster_"..i,newloot)
-- end

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

local monster_loot={--怪物列表
	{key="frog",weight=1},--青蛙
	{key="bishop",weight=1},--发条主教
	{key="knight",weight=1},--发条骑士
	{key="walrus",weight=1},--海象
	{key="spat",weight=1},--钢羊
	{key="tallbird",weight=1},--高脚鸟
	{key="mushgnome",weight=1},--蘑菇地精
	{key="monkey",weight=1},--猴子
	{key="krampus",weight=1},--坎普斯
	-- {key="powder_monkey",weight=1},--火药猴
}

--生成一只暗影生物
local function spawnOne(player,monstername,gift_value)
	local spawn_dist = 10--生成距离
	local pt = player:GetPosition()
	local spawn_pt = GetSpawnPoint(pt,spawn_dist)
    if spawn_pt ~= nil then
		local monster = SpawnPrefab(monstername)
		if monster then
			monster.Physics:Teleport(spawn_pt:Get())
			monster.AnimState:SetMultColour(0/255, 0/255, 0/255, 0.75)
			monster.persists = false--重置后消失
			monster:FacePoint(pt)
			if monster.components.health then
				monster.components.health:SetMaxHealth(gift_value*TUNING_MEDAL.MEDAL_MONSTER_BASE_HEALTH)--血量上限
			end
			if monster.components.combat then
				monster.components.combat:SetTarget(player)
			end
			if monster.components.lootdropper then
				monster.components.lootdropper:SetLoot(nil)
				monster.components.lootdropper:SetChanceLootTable('medal_monster_1')
				-- monster.components.lootdropper:SetChanceLootTable('medal_monster_'..gift_value)
			end
			if monster:HasTag("canbetrapped") then--移除可用陷阱抓捕标记
				monster:RemoveTag("canbetrapped")
			end
			monster:AddTag("engineering")--不可被投石机、眼球塔攻击
			monster:AddTag("norewardtoiler")--不可触发天道酬勤
			monster:AddTag("shadow_aligned")--加入暗影阵营
			monster:RemoveTag("lunar_aligned")--移出月亮阵营
			monster.OnEntitySleep = function(inst)--脱离加载范围后直接移除
				inst:Remove()
			end
			monster.gift_value = gift_value
			return true
		end
    end
end

--生成暗影生物(inst,召唤者)
local function SpawnMonster(inst,player)
	local destiny = GetMedalDestiny(inst)--宿命
	local monstername = GetMedalRandomItem(monster_loot,destiny)
    local gift_value = math.floor((destiny*10000%1)*9)+4--包果价值
	local more_rand = destiny*100%1--变成多个怪物的概率
	if gift_value%2==0 and more_rand<.2 then
		local spawnnum = 0
		for i = 1, gift_value/2 do
			if spawnOne(player,monstername,2) then
				spawnnum = spawnnum + 1
			end
		end
		return spawnnum>0
	else
		return spawnOne(player,monstername,gift_value)
	end
end
	
local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("medal_monster_symbol")
	inst.AnimState:SetBuild("medal_monster_symbol")
	inst.AnimState:PlayAnimation("medal_monster_symbol")

	inst:AddTag("medal_tradeable")--可和雕像交易
		
	MakeInventoryFloatable(inst,"med",0.1,0.65)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
		
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "medal_monster_symbol"
	inst.components.inventoryitem.atlasname = "images/medal_monster_symbol.xml"
			
	inst:AddComponent("inspectable")

	inst:AddComponent("medal_itemdestiny")--宿命

	inst.SpawnMonster = SpawnMonster

	MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
	MakeSmallPropagator(inst)

	MakeHauntableLaunchAndSmash(inst)
	
	return inst
end
	
return Prefab("medal_monster_symbol", fn, assets)