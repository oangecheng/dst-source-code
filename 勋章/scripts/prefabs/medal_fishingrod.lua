local assets =
{
    Asset("ANIM", "anim/fishingrod.zip"),
    Asset("ANIM", "anim/swap_fishingrod.zip"),
	Asset("ANIM", "anim/medal_fishingrod.zip"),
	Asset("ANIM", "anim/swap_medal_fishingrod.zip"),
    Asset("ATLAS", "images/medal_fishingrod.xml"),
	Asset("ATLAS_BUILD", "images/medal_fishingrod.xml",256),
}

local function onequip (inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", GetMedalSkinData(inst,"swap_medal_fishingrod"), "swap_fishingrod")
    owner.AnimState:OverrideSymbol("fishingline", GetMedalSkinData(inst,"swap_medal_fishingrod"), "fishingline")
    owner.AnimState:OverrideSymbol("FX_fishing", GetMedalSkinData(inst,"swap_medal_fishingrod"), "FX_fishing")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	
	owner:AddTag("medal_fishingrod")--岩浆钓鱼
	if inst.components.container ~= nil then
	    inst.components.container:Open(owner)
	end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    owner.AnimState:ClearOverrideSymbol("fishingline")
    owner.AnimState:ClearOverrideSymbol("FX_fishing")
	
	owner:RemoveTag("medal_fishingrod")--岩浆钓鱼
	if inst.components.container ~= nil then
	    inst.components.container:Close()
	end
end

local function setFishingrod(inst)
	if inst.components.fishingrod==nil then
		inst:AddComponent("fishingrod")
		inst.components.fishingrod:SetWaitTimes(2, 38)--钓鱼等待时间缩短2秒
		inst.components.fishingrod:SetStrainTimes(1, 5)--鱼竿被拖下水的等待时间,等待时间=min+耐久比例*(max-min)
	end
end

local function onFinished(inst)
	--延迟移除钓竿组件，防止最后一下钓不到鱼
	inst:DoTaskInTime(1,function(inst)
		if inst.components.fishingrod then
			inst:RemoveComponent("fishingrod")
		end
	end)
end

--耐久发生变化
local function onPercentUsedChange(inst,data)
	if data and data.percent>0 then
		setFishingrod(inst)
	end
end

local function onfished(inst)
    if inst.components.finiteuses then
        inst.components.finiteuses:Use(1)
    end
end
--鱼竿被拖走
local function onloserod(inst)
	if inst.components.container ~= nil then
		inst.components.container:DropEverything()
	end
end

local pond_loot={
	pond={--池塘
		oceanfishinglure_spoon_red = { chance=0.1, consume=1, product="medal_losswetpouch1", },
		oceanfishinglure_spinner_red = { chance=0.15, consume=0.8, product="medal_losswetpouch1", },
	},
	pond_mos={--沼泽池塘
		oceanfishinglure_spoon_green = { chance=0.1, consume=1, product="medal_losswetpouch2", },
		oceanfishinglure_spinner_green = { chance=0.15, consume=0.8, product="medal_losswetpouch2", },
	},
	pond_cave={--洞穴池塘
		oceanfishinglure_spoon_blue = { chance=0.1, consume=1, product="medal_losswetpouch3", },
		oceanfishinglure_spinner_blue = { chance=0.15, consume=0.8, product="medal_losswetpouch3", },
	},
	lava_pond={--岩浆池
		oceanfishinglure_hermit_heavy = { chance=0.1, consume=0.5, product="medal_losswetpouch5", },
	},
	medal_seapond={--船上钓鱼池
		--匙形鱼饵
		oceanfishinglure_spoon_red = { chance=0.12, consume=0.9, product="medal_losswetpouch4", },
		oceanfishinglure_spoon_green = { chance=0.12, consume=0.9, product="medal_losswetpouch4", },
		oceanfishinglure_spoon_blue = { chance=0.12, consume=0.9, product="medal_losswetpouch4", },
		--旋转亮片
		oceanfishinglure_spinner_red = { chance=0.14, consume=0.7, product="medal_losswetpouch4", },
		oceanfishinglure_spinner_green = { chance=0.14, consume=0.7, product="medal_losswetpouch4", },
		oceanfishinglure_spinner_blue = { chance=0.14, consume=0.7, product="medal_losswetpouch4", },
		--季节鱼饵
		oceanfishinglure_hermit_rain = { chance=0.16, consume=0.5, product="medal_losswetpouch4", },
		oceanfishinglure_hermit_snow = { chance=0.16, consume=0.5, product="medal_losswetpouch4", },
		oceanfishinglure_hermit_drowsy = { chance=0.16, consume=0.5, product="medal_losswetpouch4", },
		oceanfishinglure_hermit_heavy = { chance=0.16, consume=0.5, product="medal_losswetpouch4", },
	},
	oasislake={--湖泊
		--匙形鱼饵
		oceanfishinglure_spoon_red = { chance=0.14, consume=0.9, product="medal_losswetpouch6", },
		oceanfishinglure_spoon_green = { chance=0.14, consume=0.9, product="medal_losswetpouch6", },
		oceanfishinglure_spoon_blue = { chance=0.14, consume=0.9, product="medal_losswetpouch6", },
		--旋转亮片
		oceanfishinglure_spinner_red = { chance=0.16, consume=0.7, product="medal_losswetpouch6", },
		oceanfishinglure_spinner_green = { chance=0.16, consume=0.7, product="medal_losswetpouch6", },
		oceanfishinglure_spinner_blue = { chance=0.16, consume=0.7, product="medal_losswetpouch6", },
		--季节鱼饵
		oceanfishinglure_hermit_rain = { chance=0.2, consume=0.5, product="medal_losswetpouch6", },
		oceanfishinglure_hermit_snow = { chance=0.2, consume=0.5, product="medal_losswetpouch6", },
		oceanfishinglure_hermit_drowsy = { chance=0.2, consume=0.5, product="medal_losswetpouch6", },
		oceanfishinglure_hermit_heavy = { chance=0.2, consume=0.5, product="medal_losswetpouch6", },
		--弯曲的叉子
		trinket_17 = { chance=0.08, consume=1, product="medal_losswetpouch7", },
	},
	medal_spacetime_pond={--虚空钓鱼池
		--匙形鱼饵
		oceanfishinglure_spoon_red = { chance=0.15, consume=1, product="medal_losswetpouch1", },
		oceanfishinglure_spoon_green = { chance=0.15, consume=1, product="medal_losswetpouch2", },
		oceanfishinglure_spoon_blue = { chance=0.15, consume=1, product="medal_losswetpouch3", },
		--旋转亮片
		oceanfishinglure_spinner_red = { chance=0.2, consume=0.8, product="medal_losswetpouch1", },
		oceanfishinglure_spinner_green = { chance=0.2, consume=0.8, product="medal_losswetpouch2", },
		oceanfishinglure_spinner_blue = { chance=0.2, consume=0.8, product="medal_losswetpouch3", },
		--季节鱼饵
		oceanfishinglure_hermit_rain = { chance=0.2, consume=0.7, product="medal_losswetpouch6", },
		oceanfishinglure_hermit_snow = { chance=0.2, consume=0.7, product="medal_losswetpouch4", },
		oceanfishinglure_hermit_drowsy = { chance=0.2, consume=0.7, product="medal_losswetpouch6", },
		oceanfishinglure_hermit_heavy = { chance=0.2, consume=0.7, product="medal_losswetpouch5", },
		--弯曲的叉子
		trinket_17 = { chance=0.08, consume=1, product="medal_losswetpouch7", },
	},
}

--钓取遗失塑料袋(鱼竿,池塘,钓友)
local function getLossPouch(inst,pond,fisher)
	if pond==nil then return end
	if fisher==nil then return end
	-- print("进来了,池塘:"..pond.prefab..",渔夫:"..fisher.prefab..",钓竿:"..inst.prefab)
	local lure=inst.components.container and inst.components.container.slots[1]--获取鱼饵
	if lure then
		--食饵
		if lure.components.oceanfishingtackle and lure.components.oceanfishingtackle.lure_setup ~= nil and lure.components.oceanfishingtackle.lure_setup.single_use then
			if pond.prefab=="medal_seapond" or pond.prefab=="medal_spacetime_pond" then
				--船上钓鱼池、虚空钓鱼池有食饵才有概率钓到时令鱼
				local chance_mult = fisher.medal_fishing_chance_mult or 1--概率加成
				local chance = TUNING_MEDAL.SEAPOND_SEASON_FISH_CHANCE*chance_mult
				inst.components.container:RemoveItem(lure):Remove()--必定消耗鱼饵
				if math.random() < chance then
					if TheWorld.state.isspring then
						return "oceanfish_small_7_inv"
					end
					if TheWorld.state.issummer then
						return "oceanfish_small_8_inv"
					end
					if TheWorld.state.isautumn then
						return "oceanfish_small_6_inv"
					end
					if TheWorld.state.iswinter then
						return "oceanfish_medium_8_inv"
					end
				end
			end
		else
			local lure_loot = pond_loot[pond.prefab]
			if lure_loot ~= nil and lure_loot[lure.prefab] then
				local chance = lure_loot[lure.prefab].chance
				local reward_chance = chance*0.3--天道酬勤概率
				local chance_mult = fisher.medal_fishing_chance_mult or 1--概率加成
				local consume_mult = fisher.medal_fishing_consume_mult or 1--消耗减免
				local product=lure_loot[lure.prefab].product
				chance=chance*chance_mult
				reward_chance = reward_chance*chance_mult
				-- print("塑料袋概率:"..chance..",鱼饵消耗概率:"..lure_loot[lure.prefab].consume*consume_mult)
				--保底掉落
				if GuaranteedRandom(fisher,chance,product) then
					--消耗鱼饵
					if math.random() < lure_loot[lure.prefab].consume*consume_mult then
						inst.components.container:RemoveItem(lure):Remove()
					end
					--提前初始化一下遗失塑料袋宿命池
					if TheWorld and TheWorld.components.medal_serverdestiny ~= nil then
						TheWorld.components.medal_serverdestiny:InitDestinyKey("medal_losswetpouch")
					end
					return product
				else
					RewardToiler(fisher,reward_chance)--天道酬勤
				end
			end
		end
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fishingrod")
    inst.AnimState:SetBuild("medal_fishingrod")
    inst.AnimState:PlayAnimation("idle")

    --fishingrod (from fishingrod component) added to pristine state for optimization
    inst:AddTag("fishingrod")
    inst:AddTag("accepts_oceanfishingtackle")

	inst:AddTag("allow_action_on_impassable")

    inst:AddTag("weapon")
	inst:AddTag("medal_skinable")--可换皮肤

	inst.medal_repair_common={--可补充耐久
		silk=TUNING_MEDAL.MEDAL_FISHINGROD.ADDUSE,--蜘蛛丝
	}

	local floater_swap_data =
	{
	    sym_build = "swap_medal_fishingrod",
	    sym_name = "swap_fishingrod",
	    bank = "fishingrod",
	    anim = "fishingrod"
	}
    -- MakeInventoryFloatable(inst, "med", 0.05, {0.8, 0.4, 0.8}, true, -12, floater_swap_data)
	MakeInventoryFloatable(inst, "med", 0.05, {0.8, 0.4, 0.8})

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    setFishingrod(inst)
    inst:ListenForEvent("fishingloserod", onloserod)--鱼竿被拖走
    -----
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.FISHINGROD_DAMAGE)
    inst.components.weapon.attackwear = 4
    -----
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING_MEDAL.MEDAL_FISHINGROD.MAXUSES)
    inst.components.finiteuses:SetUses(TUNING_MEDAL.MEDAL_FISHINGROD.MAXUSES)
    inst.components.finiteuses:SetOnFinished(onFinished)
	-- inst:ListenForEvent("fishingcollect", onfished)
    inst:ListenForEvent("fishingcatch", onfished)
	inst:ListenForEvent("percentusedchange", onPercentUsedChange)
	
	inst:AddComponent("container")
	inst.components.container:WidgetSetup("medal_fishingrod")
	inst.components.container.canbeopened = false

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "medal_fishingrod"
    inst.components.inventoryitem.atlasname = "images/medal_fishingrod.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

	inst:AddComponent("medal_skinable")
	
	inst.GetLossPouch=getLossPouch

    MakeHauntableLaunch(inst)

	inst.components.floater:SetBankSwapOnFloat(true, -11, {sym_build = "swap_medal_fishingrod",sym_name = "swap_fishingrod"})

    return inst
end

return Prefab("medal_fishingrod", fn, assets)
