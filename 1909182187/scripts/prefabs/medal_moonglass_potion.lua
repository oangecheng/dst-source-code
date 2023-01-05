local PotionCommon = require "prefabs/halloweenpotion_common"

local assets =
{
    Asset("ANIM", "anim/medal_moonglass_potion.zip"),
	Asset("ATLAS", "images/medal_moonglass_potion.xml"),
	Asset("ATLAS_BUILD", "images/medal_moonglass_potion.xml",256),
}

local prefabs =
{
	"halloween_moonpuff",
}
local easy_offset=TUNING.IS_LOW_COST and 1 or 0--简易模式补偿
--变异关系表
local changeList={
	--树枝
	sapling={sapling_moon=1},
	sapling_moon={sapling=1},
	--多枝树变树枝
	twiggytree={sapling=1},
	--松果、多枝树果
	pinecone={twiggy_nut=1},
	twiggy_nut={pinecone=1},
	--浆果丛
	berrybush={berrybush2=1,berrybush_juicy=1},
	berrybush2={berrybush=1,berrybush_juicy=1},
	berrybush_juicy={berrybush=1,berrybush2=1},
	--仙人掌
	cactus={oasis_cactus=1},
	oasis_cactus={cactus=1},
	--月蛾、蝴蝶
	butterfly={moonbutterfly=1},
	moonbutterfly={butterfly=1},
	--蜜蜂、杀人蜂
	bee={killerbee=1},
	killerbee={bee=1},
	--花、月石花
	flower={moonrock_pieces=1},
	moonrock_pieces={flower=1},
	--常青树、粗壮常青树
	evergreen={evergreen_sparse=1},
	evergreen_sparse={evergreen=1},
	--企鹅、月石企鹅
	penguin={mutated_penguin=1},
	mutated_penguin={penguin=1},
	--芦苇、猴尾草
	reeds={monkeytail=1},
	monkeytail={reeds=1},
	--鸟
	robin={robin_winter=1,crow=1,puffin=1,canary=1,bird_mutant=1,bird_mutant_spitter=1},
	robin_winter={robin=1,crow=1,puffin=1,canary=1,bird_mutant=1,bird_mutant_spitter=1},
	crow={robin=1,robin_winter=1,puffin=1,canary=1,bird_mutant=1,bird_mutant_spitter=1},
	puffin={robin=1,robin_winter=1,crow=1,canary=1,bird_mutant=1,bird_mutant_spitter=1},
	canary={robin=1,robin_winter=1,crow=1,puffin=1,bird_mutant=1,bird_mutant_spitter=1},
	bird_mutant={robin=1,robin_winter=1,crow=1,puffin=1,canary=1,bird_mutant_spitter=1},
	bird_mutant_spitter={robin=1,robin_winter=1,crow=1,puffin=1,canary=1,bird_mutant=1},
	--四种狗
	hound={firehound=1,icehound=1,mutatedhound=1},
	firehound={hound=1,icehound=1,mutatedhound=1},
	icehound={hound=1,firehound=1,mutatedhound=1},
	mutatedhound={hound=1,firehound=1,icehound=1},
	--火龙果、沙拉蝾螈
	fruitdragon={dragonfruit=1},
	dragonfruit={fruitdragon=1},
	--草、草蜥蜴
	grassgekko={grass=1},
	grass={grassgekko=1},
	--胡萝卜、胡萝卜鼠
	carrot={carrat=1},
	carrat={carrot=1},
	carrot_planted={carrat_planted=1},
	carrat_planted={carrot_planted=1},
	--巨型果实
	--常见100%
	carrot_oversized={medal_fruit_tree_carrot_scion=1},
	corn_oversized={medal_fruit_tree_corn_scion=1},
	potato_oversized={medal_fruit_tree_potato_scion=1},
	tomato_oversized={medal_fruit_tree_tomato_scion=1},
	--不常见75%
	asparagus_oversized={medal_fruit_tree_asparagus_scion=3,asparagus_oversized_rotten=1},
	pumpkin_oversized={medal_fruit_tree_pumpkin_scion=3,pumpkin_oversized_rotten=1},
	eggplant_oversized={medal_fruit_tree_eggplant_scion=3,eggplant_oversized_rotten=1},
	watermelon_oversized={medal_fruit_tree_watermelon_scion=3,watermelon_oversized_rotten=1},
	--稀有50%
	garlic_oversized={medal_fruit_tree_garlic_scion=1,garlic_oversized_rotten=1},
	onion_oversized={medal_fruit_tree_onion_scion=1,onion_oversized_rotten=1},
	dragonfruit_oversized={medal_fruit_tree_dragonfruit_scion=1,dragonfruit_oversized_rotten=1},
	pomegranate_oversized={medal_fruit_tree_pomegranate_scion=1,pomegranate_oversized_rotten=1},
	pepper_oversized={medal_fruit_tree_pepper_scion=1,pepper_oversized_rotten=1},
	durian_oversized={medal_fruit_tree_durian_scion=1,durian_oversized_rotten=1},
	lucky_fruit_oversized={medal_fruit_tree_lucky_fruit_scion=1,lucky_fruit_oversized_rotten=1},
	--不朽果实12.5%
	immortal_fruit_oversized={medal_fruit_tree_immortal_fruit_scion=1+easy_offset,immortal_fruit=1,immortal_fruit_seed=6-easy_offset},
}

--变异函数
local function makeVariation(inst,target,doer)
	local newitem_name=nil
	if target.prefab == "immortal_fruit_oversized" and target.medal_destiny_num then
		newitem_name = GetMedalRandomItem(TUNING_MEDAL.IMMORTAL_FRUIT_VARIATION_ROOT,target.medal_destiny_num)--冥冥之中已有定数
	elseif changeList[target.prefab] then
		newitem_name=weighted_random_choice(changeList[target.prefab])
	end
	if newitem_name then
		local container = target.components.inventoryitem ~= nil and target.components.inventoryitem:GetContainer() or nil--目标所在容器
		local spawn_fx_at = (container ~= nil and container.inst) or target or doer--特效生成点
		local remove_potion = doer.components.inventory:RemoveItem(inst)--待移除的药水
		if remove_potion then
			local newitem = SpawnPrefab(newitem_name)
			if newitem then
				newitem.Transform:SetPosition(spawn_fx_at.Transform:GetWorldPosition())
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
							newitem.components.workable:SetWorkAction(ACTIONS.MEDALNORMALTRANSPLANT)
							newitem:RemoveTag("cantdestroy")
						end
					end
				end
				if target.components.growable and newitem.components.growable then
					if target.components.growable.stage and newitem.components.growable.stage then
						newitem.components.growable:SetStage(target.components.growable.stage)
					end
				end
				--让生物的血量百分比保持一致性
				if target.components.health ~= nil and newitem.components.health ~= nil then
					newitem.components.health:SetPercent(target.components.health:GetPercent())
				end
				--目标在容器里，则返还给容器
				if container ~= nil then
					container:GiveItem(newitem, nil, newitem:GetPosition())
				end
				--特效
				SpawnPrefab("halloween_moonpuff").Transform:SetPosition(spawn_fx_at.Transform:GetWorldPosition())
				remove_potion:Remove()
				if target.components.stackable ~= nil and target.components.stackable:IsStack() then
					target.components.stackable:Get():Remove()
				else
					target:Remove()
				end
				return true
			else
				doer.components.inventory:GiveItem(remove_potion)
			end
		end
	end
	return false
end

--放入火堆时的特效
local function onputinfirefn(inst, target)
	if target:HasTag("campfire") then
		PotionCommon.SpawnPuffFx(inst, target)
	end
end
--播放随机动画
local function PlayRandomIdle(inst)
	local r = math.random(3)
	inst.AnimState:PlayAnimation("idle_"..r)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("medal_moonglass_potion")
    inst.AnimState:SetBuild("medal_moonglass_potion")
	PlayRandomIdle(inst)

	MakeInventoryFloatable(inst, "small", 0.15, 0.65)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "medal_moonglass_potion"
	inst.components.inventoryitem.atlasname = "images/medal_moonglass_potion.xml"

    inst:AddComponent("stackable")

    MakeHauntableLaunch(inst)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL
	inst.components.fuel.ontaken = onputinfirefn

	inst:ListenForEvent("animqueueover", PlayRandomIdle)
	
	inst.makeVariation=makeVariation

    return inst
end

return Prefab("medal_moonglass_potion", fn, assets, prefabs)
