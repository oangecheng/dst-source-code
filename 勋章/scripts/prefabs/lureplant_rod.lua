local assets =
{
    Asset("ANIM", "anim/lureplant_rod.zip"),
    Asset("ANIM", "anim/floating_items.zip"),
	Asset("ATLAS", "images/lureplant_rod.xml"),
	Asset("ATLAS_BUILD", "images/lureplant_rod.xml",256),
}

local MAXUSES=TUNING_MEDAL.LUREPLANT_ROD.MAXUSES
--目标索引表
local targetMappingLoot={
	sapling={"sapling","sapling_moon"},--树枝
	grass={"grass"},--草
	reeds={"reeds","monkeytail"},--芦苇
	beebox={"beebox","beebox_hermit","medal_beebox"},--蜂蜜
	cactus={"cactus","oasis_cactus"},--仙人掌
	berrybush={"berrybush","berrybush2","berrybush_juicy"},--浆果
	flower_cave={"flower_cave","flower_cave_double","flower_cave_triple"},--荧光果
	lichen={"lichen"},--苔藓
	marsh_bush={"marsh_bush"},--荆棘丛
	meatrack={"meatrack","meatrack_hermit"},--晒肉架
	lureplant={"lureplant"},--食人花叶肉
	bullkelp_plant={"bullkelp_plant"},--海带
	rock_avocado_bush={"rock_avocado_bush"},--石果
	medal_fruit_tree_all={--嫁接树
		"medal_fruit_tree_carrot",
		"medal_fruit_tree_pomegranate",
		"medal_fruit_tree_pepper",
		"medal_fruit_tree_garlic",
		"medal_fruit_tree_dragonfruit",
		"medal_fruit_tree_banana",
		"medal_fruit_tree_asparagus",
		"medal_fruit_tree_potato",
		"medal_fruit_tree_onion",
		"medal_fruit_tree_tomato",
		"medal_fruit_tree_watermelon",
		"medal_fruit_tree_pumpkin",
		"medal_fruit_tree_eggplant",
		"medal_fruit_tree_corn",
		"medal_fruit_tree_durian",
		"medal_fruit_tree_immortal_fruit",
		"medal_fruit_tree_lucky_fruit",
	},
}
--目标预制物列表
local targetList={
	{num=MAXUSES*40/300,lootkey="sapling"},--树枝
	{num=MAXUSES*40/300,lootkey="grass"},--草
	{num=MAXUSES*20/300,lootkey="reeds"},--芦苇
	{num=MAXUSES*10/300,lootkey="beebox"},--蜂蜜
	{num=MAXUSES*20/300,lootkey="cactus"},--仙人掌
	{num=MAXUSES*40/300,lootkey="berrybush"},--浆果
	{num=MAXUSES*20/300,lootkey="flower_cave"},--荧光果
	{num=MAXUSES*20/300,lootkey="lichen"},--苔藓
	{num=MAXUSES*20/300,lootkey="marsh_bush"},--荆棘丛
	{num=MAXUSES*20/300,lootkey="meatrack"},--晒肉架
	{num=MAXUSES*10/300,lootkey="lureplant"},--食人花叶肉
	{num=MAXUSES*20/300,lootkey="bullkelp_plant"},--海带
	{num=MAXUSES*20/300,lootkey="rock_avocado_bush"},--石果
	{num=MAXUSES*50/300,lootkey="medal_fruit_tree_all"},--嫁接树
}
--采摘事件
local function picksomething(inst,doer,data)
	if inst and doer and data then
		if data.object and inst.target_loot and #inst.target_loot>0 then
			for k, v in ipairs(inst.target_loot) do
				--if v.num>0 and table.contains(v.prefablist,data.object.prefab) then
				if v.num>0 and table.contains(targetMappingLoot[v.lootkey],data.object.prefab) then
					v.num=v.num-1
					if inst.components.finiteuses then
						inst.components.finiteuses:Use(1*TUNING_MEDAL.LUREPLANT_ROD.CONSUME_MULT)
						--天道酬勤
						if not RewardToiler(doer, 0.05) then
							SpawnMedalTips(doer,1*TUNING_MEDAL.LUREPLANT_ROD.CONSUME_MULT,9)--弹幕提示
						end
					end
				end
			end
		end
	end
end

local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", GetMedalSkinData(inst,"lureplant_rod"), "swap_lureplant_rod")
	--设置饥饿速度为1.5倍
	if owner.components.hunger ~= nil then
        owner.components.hunger.burnratemodifiers:SetModifier(inst, TUNING_MEDAL.LUREPLANT_ROD.HUNGER_RATE)
    end

	owner:AddTag("rod_fastpicker")--特殊快采动作
	
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	
	owner:ListenForEvent("picksomething", inst.picksomething)--采摘
	owner:ListenForEvent("medal_picksomething", inst.picksomething)--采摘(多汁浆果)
	owner:ListenForEvent("harvestsomething", inst.picksomething)--收获
	owner:ListenForEvent("takesomething", inst.picksomething)--拿取(食人花)
end

local function onunequip(inst, owner)
	--取消饥饿加速
	if owner.components.hunger ~= nil then
        owner.components.hunger.burnratemodifiers:RemoveModifier(inst)
    end
	owner:RemoveTag("rod_fastpicker")--快采手杖，用特殊动作

    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	owner:RemoveEventCallback("picksomething", inst.picksomething)
	owner:RemoveEventCallback("medal_picksomething", inst.picksomething)
	owner:RemoveEventCallback("harvestsomething", inst.picksomething)
	owner:RemoveEventCallback("takesomething", inst.picksomething)
end
--返还新勋章
local function returnNewMedal(inst,newmedalname)
	--获取拥有者
	local owner=inst.components.inventoryitem and inst.components.inventoryitem:GetGrandOwner()
	--有拥有者则直接给拥有者
	if owner then
		if owner.components.inventory then
			owner.components.inventory:GiveItem(SpawnPrefab(newmedalname))
		elseif owner.components.container then
			owner.components.container:GiveItem(SpawnPrefab(newmedalname))
		end
	else--否则原地掉落
		if inst.components.lootdropper==nil then
			inst:AddComponent("lootdropper")
		end
		inst.components.lootdropper:SpawnLootPrefab(newmedalname)
	end
	inst:Remove()
end
--耐久用完时执行
local function onfinishedfn(inst)
	returnNewMedal(inst,"harvest_certificate")
end

local function onsave(inst,data)
	if inst.target_loot then
		data.target_loot=deepcopy(inst.target_loot)
	end
end

local function onload(inst,data)
	if data and data.target_loot then
		inst.target_loot=deepcopy(data.target_loot)
		--这里处理下老版本导致的冗余数据
		if inst.target_loot and inst.target_loot[1] and inst.target_loot[1].lootkey==nil then
			for k, v in ipairs(inst.target_loot) do
				if v.prefablist then
					v.lootkey=v.prefablist[1]
					v.prefablist=nil
				end
			end
		end
	end
end

--获取当前目标列表
local function getMedalInfo(inst)
	if inst.target_loot and #inst.target_loot>0 then
		local medalstr=STRINGS.MEDAL_INFO.PICKTARGET
		local count=0
		for k, v in ipairs(inst.target_loot) do
			if v.num>0 then
				local prefabname= STRINGS.NAMES[string.upper(v.lootkey)] or v.lootkey
				count=count+1
				medalstr=medalstr..prefabname..v.num..(count>=4 and "\n" or ",")
				count=count%4
			end
		end
		return string.sub(medalstr,1,-2)
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("lureplant_rod")
    inst.AnimState:SetBuild("lureplant_rod")
    inst.AnimState:PlayAnimation("lureplant_rod")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
	inst:AddTag("showmedalinfo")--显示详细信息
	--inst:AddTag("quickpickrod")--添加快速采集标签
	inst:AddTag("medal_skinable")--可换皮肤

	local floater_swap_data =
    {
        sym_build = "lureplant_rod",
        sym_name = "lureplant_rod",
        bank = "lureplant_rod",
        anim = "lureplant_rod"
    }
    MakeInventoryFloatable(inst, "med", 0.1, {0.9, 0.4, 0.9}, true, -13, floater_swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
	inst.components.weapon.attackwear=0
    inst.components.weapon:SetDamage(TUNING.CANE_DAMAGE)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "lureplant_rod"
	inst.components.inventoryitem.atlasname = "images/lureplant_rod.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	inst.components.equippable.dapperness = TUNING_MEDAL.LUREPLANT_ROD.SANITY_AURA--san -15/min
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(MAXUSES)
	inst.components.finiteuses:SetUses(MAXUSES)
	inst.components.finiteuses:SetOnFinished(onfinishedfn)

	inst:AddComponent("medal_skinable")

	inst.picksomething = function(self,data)
		picksomething(inst, self, data)
	end

	inst.target_loot=deepcopy(targetList)--这里必须拷贝，不然直接影响原表了
	inst.OnSave = onsave
	inst.OnLoad = onload
	inst.getMedalInfo = getMedalInfo

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("lureplant_rod", fn, assets)
