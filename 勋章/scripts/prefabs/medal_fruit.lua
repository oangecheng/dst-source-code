require "tuning"
local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS

local OVERSIZED_PHYSICS_RADIUS = 0.1--碰撞体积大小
local OVERSIZED_MAXWORK = 1--敲击次数

local gift_loot={
    --稀有物品
    {key="immortal_book",weight=10},--不朽之谜
    {key="monster_book",weight=8},--怪物图鉴
    {key="unsolved_book",weight=12},--未解之谜
    {key="blank_certificate",weight=35},--空白勋章
    {key="medal_moonglass_potion",weight=20},--月光药水
    {key="medal_skin_coupon",weight=5},--皮肤券
    {key="medal_plant_book",weight=5},--植物图鉴
    {key="medal_treasure_map",weight=5},--藏宝图
    --普通
    -- {key="trinket_17",weight=6},--弯曲的叉子
    {key="medal_glommer_essence",weight=20},--格罗姆精华
    {key="medal_treasure_map_scraps1",weight=30},--藏宝图碎片·日出
    {key="medal_treasure_map_scraps2",weight=30},--藏宝图碎片·黄昏
    {key="medal_treasure_map_scraps3",weight=30},--藏宝图碎片·夜晚
    {key="waterplant_bomb",weight=16},--种壳
    {key="mosquitosack",weight=16},--蚊子血囊
    {key="medal_weed_seeds",weight=24},--杂草种子
    {key="medaldug_livingtree_root",weight=10},--活木树苗
    {key="medal_gift_fruit_seed",weight=24},--包果种子
    --填充
    {key="thulecite",weight=45},--铥矿
    {key="nitre",weight=30},--硝石
    {key="townportaltalisman",weight=45},--砂之石
    {key="moonrocknugget",weight=45},--月岩
    {key="goldnugget",weight=45},--金块
    {key="saltrock",weight=45},--盐晶
    {key="moonglass",weight=45},--玻璃碎片
}

local fruit_def =
{
    immortal_fruit = {--不朽果实
		-- health = TUNING_MEDAL.IMMORTAL_FRUIT_HEALTHVALUE,
		hunger = TUNING_MEDAL.IMMORTAL_FRUIT_HUNGERVALUE,
		sanity = TUNING_MEDAL.IMMORTAL_FRUIT_SANITYVALUE,
		float_settings = {"small", 0.1, 0.8},
        hasdestiny = true,--有宿命
		eatfn=function(inst,eater)
			local health = eater.components.health
			if health ~= nil and not health:IsDead() then
                local healthvalue = TUNING_MEDAL.IMMORTAL_FRUIT_HEALTHVALUE--回血量
                --抵扣时之伤
                if health.medal_delay_damage and health.medal_delay_damage>0 then
                    healthvalue = healthvalue - math.min(health.medal_delay_damage*TUNING_MEDAL.IMMORTAL_FRUIT_DALAYDAMAGE_MULT,healthvalue)
                    health:DoDeltaMedalDelayDamage(-TUNING_MEDAL.IMMORTAL_FRUIT_HEALTHVALUE/TUNING_MEDAL.IMMORTAL_FRUIT_DALAYDAMAGE_MULT)
                end
                if healthvalue > 0 then
                    --在这里来给旺达加生命吧
                    if eater.components.oldager then
                        eater.components.oldager:StopDamageOverTime()
                        health:DoDelta(healthvalue, true, "debug_key")
                        local fx = SpawnPrefab((eater.components.rider ~= nil and eater.components.rider:IsRiding()) and "pocketwatch_heal_fx_mount" or "pocketwatch_heal_fx")
                        fx.entity:SetParent(eater.entity)
                    else
                        health:DoDelta(healthvalue)
                    end
                end
			end
		end,
	},
    medal_gift_fruit = {--包果
        canteat = true,--不可食用
        float_settings = {"small", 0.1, 0.8},
        seed_perish = TUNING.PERISH_SUPERSLOW,--种子腐烂时间
        seed_cookable = true,--种子可烹饪
        master_fn = function(inst)
            inst.GetGift = function(inst,doer)
                local prefab = GetMedalRandomItem(gift_loot, doer and doer.components.medal_destiny and doer.components.medal_destiny:GetDestiny())
                if prefab=="randomtrinket" then
                    prefab = PickRandomTrinket()
                end
                return prefab
            end
        end,
    },
}

local function can_plant_seed(inst, pt, mouseover, deployer)
	local x, z = pt.x, pt.z
	return TheWorld.Map:CanTillSoilAtPoint(x, 0, z, true)
end

local function OnDeploy(inst, pt, deployer) --, rot)
    local plant = SpawnPrefab(inst.components.farmplantable.plant)
    plant.Transform:SetPosition(pt.x, 0, pt.z)
	plant:PushEvent("on_planted", {in_soil = false, doer = deployer, seed = inst})
    if deployer and deployer.components.medal_destiny then
        plant.medal_destiny_num = deployer.components.medal_destiny:GetDestiny() or plant.medal_destiny_num or math.random()
    end
    TheWorld.Map:CollapseSoilAtPoint(pt.x, 0, pt.z)
    --plant.SoundEmitter:PlaySound("dontstarve/wilson/plant_seeds")
    inst:Remove()
end

local function oversized_calcweightcoefficient(name)
    if PLANT_DEFS[name].weight_data[3] ~= nil and math.random() < PLANT_DEFS[name].weight_data[3] then
        return (math.random() + math.random()) / 2
    else
        return math.random()
    end
end

-- local function oversized_onequip(inst, owner)
--     if PLANT_DEFS[inst._base_name].build ~= nil then
--         owner.AnimState:OverrideSymbol("swap_body", PLANT_DEFS[inst._base_name].build, "swap_body")
--     else
--         owner.AnimState:OverrideSymbol("swap_body", "farm_plant_"..inst._base_name, "swap_body")
--     end
-- end
local function oversized_onequip(inst, owner)
	local swap = inst.components.symbolswapdata
    owner.AnimState:OverrideSymbol("swap_body", swap.build, swap.symbol)
end

local function oversized_onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
end

local function oversized_onfinishwork(inst, chopper)
    if inst.GetGift then--巨型包果直接敲出礼物
        for i = 1, 5 do
            inst.components.lootdropper:SpawnLootPrefab(inst:GetGift(chopper))
        end
    else    
        inst.components.lootdropper:DropLoot()
    end
    inst:Remove()
end

local function Seed_GetDisplayName(inst)
	local registry_key = inst.plant_def.product

	local plantregistryinfo = inst.plant_def.plantregistryinfo
	return (ThePlantRegistry:KnowsSeed(registry_key, plantregistryinfo) and ThePlantRegistry:KnowsPlantName(registry_key, plantregistryinfo)) and STRINGS.NAMES["KNOWN_"..string.upper(inst.prefab)] 
			or nil
end

local function OnSave(inst, data)
	data.from_plant = inst.from_plant
end

local function OnPreLoad(inst, data)
	if data ~= nil then
		inst.from_plant = data.from_plant
	end
end

local function Oversized_OnSave(inst, data)
    data.from_plant = inst.from_plant
    data.harvested_on_day = inst.harvested_on_day
    data.medal_destiny_num = inst.medal_destiny_num--宿命
end

local function Oversized_OnPreLoad(inst, data)
	if data ~= nil then
        inst.from_plant = data.from_plant
        inst.harvested_on_day = data.harvested_on_day
        inst.medal_destiny_num = data.medal_destiny_num--宿命
	end
end

local function MakeVeggie(name, has_seeds)
    local assets =
    {
        Asset("ANIM", "anim/"..name..".zip"),
		Asset("ATLAS", "images/"..name..".xml"),
		Asset("ATLAS_BUILD", "images/"..name..".xml",256),
    }
	if has_seeds then
		table.insert(assets, Asset("ANIM", "anim/oceanfishing_lure_mis.zip"))
	end

    local prefabs =
    {
        "spoiled_food",
    }
	-- table.insert(prefabs, name.."_seeds")

	local assets_seeds =
    {
        Asset("ANIM", "anim/seeds.zip"),
        Asset("ANIM", "anim/"..name.."_seed.zip"),
        Asset("ATLAS", "images/"..name.."_seed.xml"),
		Asset("ATLAS_BUILD", "images/"..name.."_seed.xml",256),
    }
    
    -- local seeds_prefabs = { "farm_plant_"..name }
    local seeds_prefabs = {}
    
    local assets_oversized = {
		Asset("ANIM", "anim/"..PLANT_DEFS[name].build..".zip"),
		Asset("ANIM", "anim/"..PLANT_DEFS[name].bank..".zip"),
		Asset("ATLAS", "images/"..name.."_oversized.xml"),
		Asset("ATLAS_BUILD", "images/"..name.."_oversized.xml",256),
	}
    
	table.insert(prefabs, name.."_oversized")
	-- table.insert(prefabs, name.."_oversized_waxed")
	-- table.insert(prefabs, name.."_oversized_rotten")
	table.insert(prefabs, "splash_green")
	------------------------------------------------------种子定义------------------------------------------------
    local function fn_seeds()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(name.."_seed")
        inst.AnimState:SetBuild(name.."_seed")
        inst.AnimState:PlayAnimation(name.."_seed")
        inst.AnimState:SetRayTestOnBB(true)

        --cookable (from cookable component) added to pristine state for optimization
        if fruit_def[name].seed_cookable then
            inst:AddTag("cookable")
        end
        inst:AddTag("deployedplant")
        inst:AddTag("deployedfarmplant")
		inst:AddTag("oceanfishing_lure")

        inst.overridedeployplacername = "seeds_placer"

		inst.plant_def = PLANT_DEFS[name]
		inst.displaynamefn = Seed_GetDisplayName

		inst._custom_candeploy_fn = can_plant_seed -- for DEPLOYMODE.CUSTOM

        MakeInventoryFloatable(inst)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("edible")
        inst.components.edible.foodtype = FOODTYPE.SEEDS

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("tradable")
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = name.."_seed"
		inst.components.inventoryitem.atlasname = "images/"..name.."_seed.xml"

        inst.components.edible.healthvalue = TUNING.HEALING_TINY / 2
        inst.components.edible.hungervalue = TUNING.CALORIES_TINY

        if fruit_def[name].seed_perish then
            inst:AddComponent("perishable")
            inst.components.perishable:SetPerishTime(fruit_def[name].seed_perish)
            inst.components.perishable:StartPerishing()
            inst.components.perishable.onperishreplacement = "spoiled_food"
        end

        if fruit_def[name].seed_cookable then
            inst:AddComponent("cookable")
            inst.components.cookable.product = "seeds_cooked"
        end

        inst:AddComponent("bait")

	    inst:AddComponent("farmplantable")
	    inst.components.farmplantable.plant = "farm_plant_"..name

         -- deprecated (used for crafted farm structures)
        inst:AddComponent("plantable")
        inst.components.plantable.growtime = TUNING.SEEDS_GROW_TIME
        inst.components.plantable.product = name

         -- deprecated (used for wormwood)
        inst:AddComponent("deployable")
        inst.components.deployable:SetDeployMode(DEPLOYMODE.CUSTOM) -- use inst._custom_candeploy_fn
        inst.components.deployable.restrictedtag = "plantkin"
        inst.components.deployable.ondeploy = OnDeploy

		inst:AddComponent("oceanfishingtackle")
        inst.components.oceanfishingtackle:SetupLure({build = "oceanfishing_lure_mis", symbol = "hook_seeds", single_use = true, lure_data = TUNING.OCEANFISHING_LURE.SEED})
        

        MakeHauntableLaunchAndPerish(inst)

        return inst
    end
	------------------------------------------------------果实定义------------------------------------------------
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(name)
        inst.AnimState:SetBuild(name)
        inst.AnimState:PlayAnimation("idle")
        
		--weighable (from weighable component) added to pristine state for optimization
		inst:AddTag("weighable_OVERSIZEDVEGGIES")--可称重

        local float = fruit_def[name].float_settings
        if float ~= nil then
            MakeInventoryFloatable(inst, float[1], float[2], float[3])
        else
            MakeInventoryFloatable(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        if not fruit_def[name].canteat then
            inst:AddComponent("edible")
            inst.components.edible.healthvalue = fruit_def[name].health or 0
            inst.components.edible.hungervalue = fruit_def[name].hunger or 0
            inst.components.edible.sanityvalue = fruit_def[name].sanity or 0
            inst.components.edible.foodtype = FOODTYPE.GOODIES
            if fruit_def[name].eatfn then
                inst.components.edible:SetOnEatenFn(fruit_def[name].eatfn)
            end
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = name
		inst.components.inventoryitem.atlasname = "images/"..name..".xml"

        --可称重
		inst:AddComponent("weighable")
		inst.components.weighable.type = TROPHYSCALE_TYPES.OVERSIZEDVEGGIES

        ------------------------------------------------
        inst:AddComponent("tradable")

        MakeHauntableLaunchAndPerish(inst)

        if has_seeds then
            inst.OnSave = OnSave
            inst.OnPreLoad = OnPreLoad
        end

        if fruit_def[name].master_fn then
            fruit_def[name].master_fn(inst)
        end

        return inst
    end
	------------------------------------------------------巨型作物定义------------------------------------------------
    local function fn_oversized()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        local plant_def = PLANT_DEFS[name]

        inst.AnimState:SetBank(plant_def.bank)
        inst.AnimState:SetBuild(plant_def.build)
        inst.AnimState:PlayAnimation("idle_oversized")

        inst:AddTag("heavy")
	    inst:AddTag("show_spoilage")
        if fruit_def[name].hasdestiny then
            inst:AddTag("fate_rewriteable")--可改命
	        inst:AddTag("medal_predictable")--可被预言
        end

        MakeHeavyObstaclePhysics(inst, OVERSIZED_PHYSICS_RADIUS)
        inst:SetPhysicsRadiusOverride(OVERSIZED_PHYSICS_RADIUS)

        inst._base_name = name

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.harvested_on_day = inst.harvested_on_day or (TheWorld.state.cycles + 1)

        inst:AddComponent("heavyobstaclephysics")
        inst.components.heavyobstaclephysics:SetRadius(OVERSIZED_PHYSICS_RADIUS)
        inst.components.heavyobstaclephysics:MakeSmallObstacle()

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.cangoincontainer = false
        inst.components.inventoryitem:SetSinks(true)
		inst.components.inventoryitem.imagename = name.."_oversized"
		inst.components.inventoryitem.atlasname = "images/"..name.."_oversized.xml"

        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.BODY
        inst.components.equippable:SetOnEquip(oversized_onequip)
        inst.components.equippable:SetOnUnequip(oversized_onunequip)
        inst.components.equippable.walkspeedmult = TUNING.HEAVY_SPEED_MULT

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetOnFinishCallback(oversized_onfinishwork)
        inst.components.workable:SetWorkLeft(OVERSIZED_MAXWORK)

        inst:AddComponent("submersible")
        inst:AddComponent("symbolswapdata")
        inst.components.symbolswapdata:SetData(plant_def.build, "swap_body")

        local weight_data = plant_def.weight_data
        inst:AddComponent("weighable")
        inst.components.weighable.type = TROPHYSCALE_TYPES.OVERSIZEDVEGGIES
        inst.components.weighable:Initialize(weight_data.min, weight_data.max)
        local coefficient = oversized_calcweightcoefficient(name)
        inst.components.weighable:SetWeight(Lerp(weight_data[1], weight_data[2], coefficient))

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot({name, name, name, name, name})--没错全是果实
        
        if fruit_def[name].hasdestiny then
            inst.medal_destiny_num = math.random()--宿命
            inst:ListenForEvent("on_loot_dropped", function(inst,data)
                --继承宿命
                if data and data.dropper and data.dropper.medal_destiny_num then
                    inst.medal_destiny_num = data.dropper.medal_destiny_num
                end
            end)
        end

        MakeHauntableWork(inst)

		inst.OnSave = Oversized_OnSave
		inst.OnPreLoad = Oversized_OnPreLoad

        if fruit_def[name].master_fn then
            fruit_def[name].master_fn(inst)
        end

        return inst
    end

    local exported_prefabs = {}
	table.insert(exported_prefabs, Prefab(name.."_seed", fn_seeds, assets_seeds, seeds_prefabs))
	table.insert(exported_prefabs, Prefab(name.."_oversized", fn_oversized, assets_oversized))
    table.insert(exported_prefabs, Prefab(name, fn, assets, prefabs))

    return exported_prefabs
end

local prefs = {}
for veggiename,veggiedata in pairs(fruit_def) do
    local veggies = MakeVeggie(veggiename, true)
	for _, v in ipairs(veggies) do
		table.insert(prefs, v)
	end
end

return unpack(prefs)