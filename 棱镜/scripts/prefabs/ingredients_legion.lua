--------------------------------------------------------------------------
--[[ 该文件只实现新食材的prefab，包括肉类与菜类等 ]]
--------------------------------------------------------------------------

require "prefabutil"
local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
local prefs = {}

local ingredients_legion = {
    ------
    --花香四溢
    ------
    petals_rose = {
        base = {
            floatable = {nil, "small", 0.08, 0.95},
            edible = { hunger = 9.375, sanity = 1, health = 8, foodtype = nil, foodtype_secondary = nil },
            perishable = { product = nil, time = TUNING.PERISH_FAST },
            stackable = { size = nil },
            fuel = { value = nil },
            burnable = {},
        },
    },
    petals_lily = {
        base = {
            floatable = {nil, "small", 0.08, 0.95},
            edible = { hunger = 9.375, sanity = 10, health = -3, foodtype = nil, foodtype_secondary = nil },
            perishable = { product = nil, time = TUNING.PERISH_FAST },
            stackable = { size = nil },
            fuel = { value = nil },
            burnable = {},
        },
    },
    petals_orchid = {
        base = {
            floatable = {nil, "small", 0.08, 0.95},
            edible = { hunger = 12.5, sanity = 5, health = 0, foodtype = nil, foodtype_secondary = nil },
            perishable = { product = nil, time = TUNING.PERISH_FAST },
            stackable = { size = nil },
            fuel = { value = nil },
            burnable = {},
        },
    },
    ------
    --祈雨祭
    ------
    monstrain_leaf = {
        base = {
            floatable = {nil, "small", 0.05, 1.1},
            edible = { hunger = 12.5, sanity = -15, health = -30, foodtype = nil, foodtype_secondary = FOODTYPE.MONSTER },
            perishable = { product = nil, time = TUNING.PERISH_MED },
            stackable = { size = nil },
            fuel = { value = nil },
            burnable = {},
        },
    },
    squamousfruit = {
        base = {
            floatable = {0.05, "small", 0.2, 0.7},
            edible = { hunger = 25, sanity = -5, health = -3, foodtype = nil, foodtype_secondary = nil },
            stackable = { size = nil },
            burnable = {},
            fn_server = function(inst)
                inst.components.edible:SetOnEatenFn(function(food, eater)
                    if eater.components.moisture ~= nil then
                        eater.components.moisture:DoDelta(-100)
                    end
                end)
            end,
        },
    },
    ------
    --尘世蜃楼
    ------
    shyerry = {
        base = {
            prefabs = {"buff_healthstorage", "shyerrytree1_planted", "shyerrytree3_planted"},
            cookable = { product = nil },
            floatable = {0.04, "small", 0.25, 0.9},
            edible = { hunger = 18.75, sanity = 0, health = 8, foodtype = nil, foodtype_secondary = nil },
            perishable = { product = nil, time = TUNING.PERISH_MED },
            stackable = { size = nil },
            burnable = {},
            fn_common = function(inst)
                inst:AddTag("deployedplant")
            end,
            fn_server = function(inst)
                inst.components.edible:SetOnEatenFn(function(food, eater)
                    eater.buff_healthstorage_times = 20 --因为buff相关组件不支持相同buff叠加时的数据传输，所以这里自己定义了一个传输方式
                    eater:AddDebuff("buff_healthstorage", "buff_healthstorage")
                end)

                inst:AddComponent("deployable")
                inst.components.deployable.ondeploy = function(me, pt, deployer, rot)
                    local names = {"shyerrytree1_planted", "shyerrytree3_planted"}
                    local tree = SpawnPrefab(names[math.random(#names)])
                    if tree ~= nil then
                        tree.Transform:SetPosition(pt:Get())
                        me.components.stackable:Get():Remove()
                        -- tree.components.pickable:OnTransplant()
                        if deployer ~= nil and deployer.SoundEmitter ~= nil then
                            --V2C: WHY?!! because many of the plantables don't
                            --     have SoundEmitter, and we don't want to add
                            --     one just for this sound!
                            deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
                        end
                    end
                end
                inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
            end,
        },
        cooked = {
            floatable = {0.02, "small", 0.2, 0.9},
            edible = { hunger = 12.5, sanity = 1, health = 0, foodtype = nil, foodtype_secondary = nil },
            perishable = { product = nil, time = TUNING.PERISH_FAST },
            stackable = { size = nil },
            fuel = { value = nil },
            burnable = {},
        },
    },
    ------
    --电闪雷鸣
    ------
    albicans_cap = {
        base = {
            floatable = {0.01, "small", 0.15, 1},
            edible = { hunger = 15, sanity = 15, health = 15, foodtype = nil, foodtype_secondary = nil },
            perishable = { product = nil, time = TUNING.PERISH_FASTISH },
            stackable = { size = nil },
            fuel = { value = nil },
            burnable = {},
            fn_common = function(inst)
                inst:AddTag("mushroom")
            end,
        },
    },
    ------
    --丰饶传说
    ------
    pineananas = {
        base = {
            cookable = { product = nil },
            floatable = {nil, "small", 0.2, 0.9},
            edible = { hunger = 12, sanity = -10, health = 8, foodtype = nil, foodtype_secondary = nil },
            perishable = { product = nil, time = TUNING.PERISH_MED },
            stackable = { size = nil },
            burnable = {}
        },
        cooked = {
            floatable = {nil, "small", 0.2, 1},
            edible = { hunger = 18.5, sanity = 5, health = 16, foodtype = nil, foodtype_secondary = nil },
            perishable = { product = nil, time = TUNING.PERISH_SUPERFAST },
            stackable = { size = nil },
            fuel = { value = nil },
            burnable = {},
        },
        seeds = {
            cookable = { product = "seeds_cooked" },
            floatable = {-0.1, "small", nil, nil},
            lure = {lure_data = TUNING.OCEANFISHING_LURE.SEED, single_use = true, build = "oceanfishing_lure_mis", symbol = "hook_seeds"},
            edible = { hunger = 9.375, sanity = 0, health = 0.5, foodtype = FOODTYPE.SEEDS, foodtype_secondary = nil },
            perishable = { product = nil, time = TUNING.PERISH_SUPERSLOW },
            stackable = { size = nil },
            fuel = { value = nil },
            burnable = {},
        },
        oversized = {
            perishable = { product = nil, time = TUNING.PERISH_MED * 4 },
            fn_server = function(inst)
                local newLoot = inst.components.lootdropper.loot or {}
                table.insert(newLoot, "pinecone")
                inst.components.lootdropper:SetLoot(newLoot)
            end
        },
        oversized_waxed = {},
        oversized_rotten = {},
    },
    mint_l = {
        base = {
            floatable = {nil, "small", 0.08, 0.95},
            edible = { hunger = 6, sanity = 8, health = 0, foodtype = nil, foodtype_secondary = nil },
            perishable = { product = nil, time = TUNING.PERISH_MED },
            stackable = { size = nil },
            fuel = { value = nil },
            burnable = {},
            fn_common = function(inst)
                inst:AddTag("catfood")
                inst:AddTag("cattoy")
                inst:AddTag("catmint")
            end,
        },
    }
}

--------------------------------------------------------------------------
--------------------------------------------------------------------------

local function MakePrefab(name, info)
    -- 参数示例
    --[[
        {
            base = {
                animstate = { bank = nil, build = nil, anim = nil },
                assets = nil,
                prefabs = nil,
                cookable = { product = nil },
                dryable = { product = nil, time = nil, build = nil, build_dried = nil }, --build文件中需要以原料prefab名为通道名的文件夹
                floatable = {nil, "small", 0.2, 0.9},
                lure = {lure_data = TUNING.OCEANFISHING_LURE.BERRY, single_use = true, build = "oceanfishing_lure_mis", symbol = "hook_berries"},
                edible = { hunger = 0, sanity = 0, health = 0, foodtype = nil, foodtype_secondary = nil },
                perishable = { product = nil, time = nil },
                stackable = { size = nil },
                fuel = { value = nil },
                burnable = {},
                has_seeds = false, --这个不用主动加，设置seeds时自动添加
                nohauntable = false, --这个不用主动加，设置时自动添加
                fn_common = nil,
                fn_server = nil,
            },
            cooked = {},
            dried = {},
            rotten = {},
            seeds = {},
            oversized = {
                workable = { action = nil, left_max = nil }, --必有的属性
                physicsradius = nil,    --必有的属性
                nohauntable = true, --这个不用主动加，设置时自动添加
            },
            oversized_waxed = {
                workable = { action = nil, left_max = nil },
                physicsradius = nil,
                nohauntable = true,
            },
            oversized_rotten = {
                workable = { action = nil, left_max = nil },
                physicsradius = nil,
                nohauntable = true,
            },
        }
    ]]--

    local function Fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(info.animstate.bank)
        inst.AnimState:SetBuild(info.animstate.build)
        inst.AnimState:PlayAnimation(info.animstate.anim)

        -- inst:AddTag("meat")

        if info.cookable ~= nil then
            inst:AddTag("cookable")
        end

        if info.dryable ~= nil then
            inst:AddTag("dryable")
            inst:AddTag("lureplant_bait")
        end

        if info.has_seeds then
            --weighable (from weighable component) added to pristine state for optimization
            inst:AddTag("weighable_OVERSIZEDVEGGIES")
        end

        if info.floatable ~= nil then
            MakeInventoryFloatable(inst, info.floatable[2], info.floatable[3], info.floatable[4])
            if info.floatable[1] ~= nil then
                local OnLandedClient_old = inst.components.floater.OnLandedClient
                inst.components.floater.OnLandedClient = function(self)
                    OnLandedClient_old(self)
                    self.inst.AnimState:SetFloatParams(info.floatable[1], 1, self.bob_percent)
                end
            end
        end

        if info.lure ~= nil then
            inst:AddTag("oceanfishing_lure")
        end

        if info.fn_common ~= nil then
            info.fn_common(inst)
        end

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = name
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

        if info.edible ~= nil then
            inst:AddComponent("bait")

            inst:AddComponent("tradable")

            inst:AddComponent("edible")
            inst.components.edible.healthvalue = info.edible.health or 0
            inst.components.edible.hungervalue = info.edible.hunger or 0
            inst.components.edible.sanityvalue = info.edible.sanity or 0
            inst.components.edible.foodtype = info.edible.foodtype or FOODTYPE.VEGGIE
            inst.components.edible.secondaryfoodtype = info.edible.foodtype_secondary
        end

        if info.perishable ~= nil then
            inst:AddComponent("perishable")
            inst.components.perishable:SetPerishTime(info.perishable.time)
            inst.components.perishable:StartPerishing()
            inst.components.perishable.onperishreplacement = info.perishable.product
        end

        if info.stackable ~= nil then
            inst:AddComponent("stackable")
            inst.components.stackable.maxsize = info.stackable.size or TUNING.STACK_SIZE_SMALLITEM
        end

        if info.fuel ~= nil then
            inst:AddComponent("fuel")
            inst.components.fuel.fuelvalue = info.fuel.value or TUNING.TINY_FUEL
        end

        if info.dryable ~= nil then
            inst:AddComponent("dryable")
            inst.components.dryable:SetProduct(info.dryable.product)
            inst.components.dryable:SetDryTime(info.dryable.time)
            inst.components.dryable:SetBuildFile(info.dryable.build)
            inst.components.dryable:SetDriedBuildFile(info.dryable.build_dried)
        end

        if info.cookable ~= nil then
            inst:AddComponent("cookable")
            inst.components.cookable.product = info.cookable.product
        end

        if info.burnable ~= nil then
            MakeSmallBurnable(inst)
            MakeSmallPropagator(inst)
        end

        if info.lure ~= nil then
            inst:AddComponent("oceanfishingtackle")
            inst.components.oceanfishingtackle:SetupLure(info.lure)
        end

        if info.has_seeds then
            --TIP: 要想能在作物秤上显示，需要自己的build里有个 build名..01 的通道
            inst:AddComponent("weighable")
            inst.components.weighable.type = TROPHYSCALE_TYPES.OVERSIZEDVEGGIES
        end

        if info.nohauntable ~= true then
            MakeHauntableLaunchAndIgnite(inst)
        end

        if info.fn_server ~= nil then
            info.fn_server(inst)
        end

        return inst
    end

    table.insert(prefs, Prefab(name, Fn, info.assets, info.prefabs))
end

local function MadePrefab(name, info)
    if info.assets == nil then info.assets = {} end
    table.insert(info.assets, Asset("ANIM", "anim/"..info.animstate.build..".zip"))
    table.insert(info.assets, Asset("ATLAS", "images/inventoryimages/"..name..".xml"))
    table.insert(info.assets, Asset("IMAGE", "images/inventoryimages/"..name..".tex"))

    if info.prefabs == nil then info.prefabs = {} end
    -- if info.cookable ~= nil then
    --     table.insert(info.prefabs, info.cookable.product)
    -- end
    -- if info.dryable ~= nil then
    --     table.insert(info.prefabs, info.dryable.product)
    -- end
    if info.perishable ~= nil then
        local product = info.perishable.product or "spoiled_food"
        -- table.insert(info.prefabs, product)
        info.perishable.product = product
    end

    MakePrefab(name, info)
end

---

local function OnUnequip_oversized(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
end

local function OnFinishWork_oversized(inst, chopper)
    inst.components.lootdropper:DropLoot()
    inst:Remove()
end

local function CalcWeightCoefficient_oversized(weight_data)
    if weight_data[3] ~= nil and math.random() < weight_data[3] then
        return (math.random() + math.random()) / 2
    else
        return math.random()
    end
end

local function MakeLoots_oversized(inst, name)
	local seeds = name.."_seeds"
    return {name, name, seeds, seeds, math.random() < 0.75 and name or seeds}
end

local function OnBurnt_oversized(inst)
    inst.components.lootdropper:DropLoot()
    inst:Remove()
end

local PlayWaxAnimation = function(inst)
    inst.AnimState:PlayAnimation("wax_oversized", false)
    inst.AnimState:PushAnimation("idle_oversized")
end

local function CancelWaxTask(inst)
	if inst._waxtask ~= nil then
		inst._waxtask:Cancel()
		inst._waxtask = nil
	end
end

local function StartWaxTask(inst)
	if not inst.inlimbo and inst._waxtask == nil then
		inst._waxtask = inst:DoTaskInTime(GetRandomMinMax(20, 40), PlayWaxAnimation)
	end
end

---

local function MakeIngredient(name, data)
    if data.base ~= nil then
        local info = data.base
        if info.animstate == nil then info.animstate = {} end
        if info.animstate.bank == nil then
            info.animstate.bank = name
        end
        if info.animstate.build == nil then
            info.animstate.build = name
        end
        if info.animstate.anim == nil then
            info.animstate.anim = "idle"
        end

        if info.assets == nil then info.assets = {} end
        if data.seeds ~= nil then
            table.insert(info.assets, Asset("ANIM", "anim/oceanfishing_lure_mis.zip"))
            info.has_seeds = true
        end

        if info.prefabs == nil then info.prefabs = {} end
        if info.cookable ~= nil then
            local product = data.cooked ~= nil and name.."_cooked" or info.cookable.product
            -- table.insert(info.prefabs, product)
            info.cookable.product = product
        end
        if info.dryable ~= nil then
            local product = data.dried ~= nil and name.."_dried" or info.dryable.product
            -- table.insert(info.prefabs, product)
            info.dryable.product = product
        end
        if info.perishable ~= nil then
            local product = data.rotten ~= nil and name.."_rotten" or (info.perishable.product or "spoiled_food")
            -- table.insert(info.prefabs, product)
            info.perishable.product = product
        end
        if data.seeds ~= nil then
            -- table.insert(info.prefabs, name.."_seeds")
            -- table.insert(info.prefabs, name.."_oversized")
            -- table.insert(info.prefabs, name.."_oversized_waxed")
            -- table.insert(info.prefabs, name.."_oversized_rotten")
            -- table.insert(info.prefabs, "splash_green")
        end

        MadePrefab(name, info)
    end

    if data.cooked ~= nil then
        local info = data.cooked
        if info.animstate == nil then info.animstate = {} end
        if info.animstate.bank == nil then
            info.animstate.bank = name
        end
        if info.animstate.build == nil then
            info.animstate.build = name
        end
        if info.animstate.anim == nil then
            info.animstate.anim = "cooked"
        end

        MadePrefab(name.."_cooked", info)
    end

    if data.dried ~= nil then
        local info = data.dried
        if info.animstate == nil then info.animstate = {} end
        if info.animstate.bank == nil then
            info.animstate.bank = name
        end
        if info.animstate.build == nil then
            info.animstate.build = name
        end
        if info.animstate.anim == nil then
            info.animstate.anim = "dried"
        end

        MadePrefab(name.."_dried", info)
    end

    if data.rotten ~= nil then
        local info = data.rotten
        if info.animstate == nil then info.animstate = {} end
        if info.animstate.bank == nil then
            info.animstate.bank = name
        end
        if info.animstate.build == nil then
            info.animstate.build = name
        end
        if info.animstate.anim == nil then
            info.animstate.anim = "rotten"
        end

        MadePrefab(name.."_rotten", info)
    end

    if data.seeds ~= nil then
        local info = data.seeds
        if info.animstate == nil then info.animstate = {} end
        if info.animstate.bank == nil then
            info.animstate.bank = name
        end
        if info.animstate.build == nil then
            info.animstate.build = name
        end
        if info.animstate.anim == nil then
            info.animstate.anim = "seeds"
        end

        --不知道为什么，和作物有关联的话会导致巨型作物动画不显示
        -- if info.prefabs ~= nil then
        --     table.insert(info.prefabs, "farm_plant_"..name)
        -- else
        --     info.prefabs = { "farm_plant_"..name }
        -- end

        local fn_common = info.fn_common
        info.fn_common = function(inst)
            inst.AnimState:SetRayTestOnBB(true)

            inst:AddTag("deployedplant")
            inst:AddTag("deployedfarmplant")

            inst.overridedeployplacername = "seeds_placer"

            inst.plant_def = PLANT_DEFS[name]
            inst.displaynamefn = function(inst)
                local registry_key = inst.plant_def.product
                local plantregistryinfo = inst.plant_def.plantregistryinfo
                return (ThePlantRegistry:KnowsSeed(registry_key, plantregistryinfo) and ThePlantRegistry:KnowsPlantName(registry_key, plantregistryinfo))
                        and STRINGS.NAMES["KNOWN_"..string.upper(inst.prefab)]
                        or nil
            end
            inst._custom_candeploy_fn = function(inst, pt, mouseover, deployer) -- for DEPLOYMODE.CUSTOM
                local x, z = pt.x, pt.z
                return TheWorld.Map:CanTillSoilAtPoint(x, 0, z, true)
            end

            if fn_common ~= nil then fn_common(inst) end
        end

        local fn_server = info.fn_server
        info.fn_server = function(inst)
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
            inst.components.deployable.ondeploy = function(inst, pt, deployer, rot)
                local plant = SpawnPrefab(inst.components.farmplantable.plant)
                plant.Transform:SetPosition(pt.x, 0, pt.z)
                plant:PushEvent("on_planted", {in_soil = false, doer = deployer, seed = inst})
                TheWorld.Map:CollapseSoilAtPoint(pt.x, 0, pt.z)
                --plant.SoundEmitter:PlaySound("dontstarve/wilson/plant_seeds")
                inst:Remove()
            end

            if fn_server ~= nil then fn_server(inst) end
        end

        MadePrefab(name.."_seeds", info)
    end

    if data.oversized ~= nil then
        local info = data.oversized
        if info.animstate == nil then info.animstate = {} end
        if info.animstate.bank == nil then
            info.animstate.bank = PLANT_DEFS[name].bank
        end
        if info.animstate.build == nil then
            info.animstate.build = PLANT_DEFS[name].build
        end
        if info.animstate.anim == nil then
            info.animstate.anim = "idle_oversized"
        end

        if info.workable ~= nil then
            if info.workable.action == nil then
                info.workable.action = ACTIONS.HAMMER
            end
            if info.workable.left_max == nil then
                info.workable.left_max = 1
            end
        else
            info.workable = { action = ACTIONS.HAMMER, left_max = 1 }
        end
        if info.physicsradius == nil then
            info.physicsradius = 0.1
        end
        if info.nohauntable ~= false then
            info.nohauntable = true
        end

        local fn_common = info.fn_common
        info.fn_common = function(inst)
            inst:AddTag("heavy")
            inst:AddTag("waxable")
            inst:AddTag("oversized_veggie")
            inst:AddTag("show_spoilage")
            inst.gymweight = 4

            MakeHeavyObstaclePhysics(inst, info.physicsradius)
            inst:SetPhysicsRadiusOverride(info.physicsradius)

            inst._base_name = name

            if fn_common ~= nil then fn_common(inst) end
        end

        local fn_server = info.fn_server
        info.fn_server = function(inst)
            inst.harvested_on_day = inst.harvested_on_day or (TheWorld.state.cycles + 1)

            inst:AddComponent("heavyobstaclephysics")
            inst.components.heavyobstaclephysics:SetRadius(info.physicsradius)
            -- inst.components.heavyobstaclephysics:MakeSmallObstacle()

            inst.components.perishable.onperishreplacement = nil
            inst.components.perishable:SetOnPerishFn(function(inst)
                -- vars for rotting on a gym
                local gym = nil
                local rot = nil
                local slot = nil

                if
                    inst.components.inventoryitem:GetGrandOwner() ~= nil and
                    not inst.components.inventoryitem:GetGrandOwner():HasTag("gym")
                then
                    local loots = {}
                    for i=1, #inst.components.lootdropper.loot do
                        table.insert(loots, "spoiled_food")
                    end
                    inst.components.lootdropper:SetLoot(loots)
                    inst.components.lootdropper:DropLoot()
                else
                    rot = SpawnPrefab(inst.prefab.."_rotten")
                    rot.Transform:SetPosition(inst.Transform:GetWorldPosition())
                    if
                        inst.components.inventoryitem:GetGrandOwner() and
                        inst.components.inventoryitem:GetGrandOwner():HasTag("gym")
                    then
                        gym = inst.components.inventoryitem:GetGrandOwner()
                        slot = gym.components.inventory:GetItemSlot(inst)
                    end
                end

                inst:Remove()

                if gym and rot then
                    gym.components.mightygym:LoadWeight(rot, slot)
                end
            end)

            inst.components.inventoryitem.cangoincontainer = false
            inst.components.inventoryitem:SetSinks(true)

            inst:AddComponent("equippable")
            inst.components.equippable.equipslot = EQUIPSLOTS.BODY
            inst.components.equippable:SetOnEquip(function(inst, owner)
                owner.AnimState:OverrideSymbol("swap_body", info.animstate.build, "swap_body")
            end)
            inst.components.equippable:SetOnUnequip(OnUnequip_oversized)
            inst.components.equippable.walkspeedmult = TUNING.HEAVY_SPEED_MULT

            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(info.workable.action)
            inst.components.workable:SetOnFinishCallback(OnFinishWork_oversized)
            inst.components.workable:SetWorkLeft(info.workable.left_max)

            inst:AddComponent("waxable")
            inst.components.waxable:SetWaxfn(function(inst, doer, waxitem)
                local waxedveggie = SpawnPrefab(inst.prefab.."_waxed")
                if doer.components.inventory and doer.components.inventory:IsHeavyLifting() and doer.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) == inst then
                    doer.components.inventory:Unequip(EQUIPSLOTS.BODY)
                    doer.components.inventory:Equip(waxedveggie)
                else
                    waxedveggie.Transform:SetPosition(inst.Transform:GetWorldPosition())
                    waxedveggie.AnimState:PlayAnimation("wax_oversized", false)
                    waxedveggie.AnimState:PushAnimation("idle_oversized")
                end
                inst:Remove()
                return true
            end)

            inst:AddComponent("submersible")
            inst:AddComponent("symbolswapdata")
            inst.components.symbolswapdata:SetData(info.animstate.build, "swap_body")

            local weight_data = PLANT_DEFS[name].weight_data
            inst:AddComponent("weighable")
            inst.components.weighable.type = TROPHYSCALE_TYPES.OVERSIZEDVEGGIES
            inst.components.weighable:Initialize(weight_data[1], weight_data[2])
            local coefficient = CalcWeightCoefficient_oversized(weight_data)
            inst.components.weighable:SetWeight(Lerp(weight_data[1], weight_data[2], coefficient))

            inst:AddComponent("lootdropper")
            inst.components.lootdropper:SetLoot(MakeLoots_oversized(inst, name))

            MakeMediumBurnable(inst)
            inst.components.burnable:SetOnBurntFn(OnBurnt_oversized)
            MakeMediumPropagator(inst)

            MakeHauntableWork(inst)

            inst.from_plant = false
            inst.OnSave = function(inst, data)
                data.from_plant = inst.from_plant or false
                data.harvested_on_day = inst.harvested_on_day
            end
            inst.OnPreLoad = function(inst, data)
                inst.from_plant = (data and data.from_plant) ~= false
                if data ~= nil then
                    inst.harvested_on_day = data.harvested_on_day
                end
            end

            if fn_server ~= nil then fn_server(inst) end
        end

        MadePrefab(name.."_oversized", info)
    end

    if data.oversized_waxed ~= nil then
        local info = data.oversized_waxed
        if info.animstate == nil then info.animstate = {} end
        if info.animstate.bank == nil then
            info.animstate.bank = PLANT_DEFS[name].bank
        end
        if info.animstate.build == nil then
            info.animstate.build = PLANT_DEFS[name].build
        end
        if info.animstate.anim == nil then
            info.animstate.anim = "idle_oversized"
        end

        if info.workable ~= nil then
            if info.workable.action == nil then
                info.workable.action = ACTIONS.HAMMER
            end
            if info.workable.left_max == nil then
                info.workable.left_max = 1
            end
        else
            info.workable = { action = ACTIONS.HAMMER, left_max = 1 }
        end
        if info.physicsradius == nil then
            info.physicsradius = 0.1
        end
        if info.nohauntable ~= false then
            info.nohauntable = true
        end

        local fn_common = info.fn_common
        info.fn_common = function(inst)
            inst:AddTag("heavy")
            inst:AddTag("oversized_veggie")
            inst.gymweight = 4

            inst.displayadjectivefn = function(inst)
                return STRINGS.UI.HUD.WAXED
            end
            inst:SetPrefabNameOverride(name.."_oversized")

            MakeHeavyObstaclePhysics(inst, info.physicsradius)
            inst:SetPhysicsRadiusOverride(info.physicsradius)

            inst._base_name = name

            if fn_common ~= nil then fn_common(inst) end
        end

        local fn_server = info.fn_server
        info.fn_server = function(inst)
            inst:AddComponent("heavyobstaclephysics")
            inst.components.heavyobstaclephysics:SetRadius(info.physicsradius)
            -- inst.components.heavyobstaclephysics:MakeSmallObstacle()

            inst.components.inventoryitem.cangoincontainer = false
            inst.components.inventoryitem:SetSinks(true)

            inst:AddComponent("equippable")
            inst.components.equippable.equipslot = EQUIPSLOTS.BODY
            inst.components.equippable:SetOnEquip(function(inst, owner)
                owner.AnimState:OverrideSymbol("swap_body", info.animstate.build, "swap_body")
            end)
            inst.components.equippable:SetOnUnequip(OnUnequip_oversized)
            inst.components.equippable.walkspeedmult = TUNING.HEAVY_SPEED_MULT

            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(info.workable.action)
            inst.components.workable:SetOnFinishCallback(OnFinishWork_oversized)
            inst.components.workable:SetWorkLeft(info.workable.left_max)

            inst:AddComponent("submersible")
            inst:AddComponent("symbolswapdata")
            inst.components.symbolswapdata:SetData(info.animstate.build, "swap_body")

            inst:AddComponent("lootdropper")
            inst.components.lootdropper:SetLoot({"spoiled_food"})

            MakeMediumBurnable(inst)
            inst.components.burnable:SetOnBurntFn(OnBurnt_oversized)
            MakeMediumPropagator(inst)

            MakeHauntableWork(inst)

            inst:ListenForEvent("onputininventory", CancelWaxTask)
            inst:ListenForEvent("ondropped", StartWaxTask)

            inst.OnEntitySleep = CancelWaxTask
            inst.OnEntityWake = StartWaxTask

            StartWaxTask(inst)

            if fn_server ~= nil then fn_server(inst) end
        end

        MadePrefab(name.."_oversized_waxed", info)
    end

    if data.oversized_rotten ~= nil then
        local info = data.oversized_rotten
        if info.animstate == nil then info.animstate = {} end
        if info.animstate.bank == nil then
            info.animstate.bank = PLANT_DEFS[name].bank
        end
        if info.animstate.build == nil then
            info.animstate.build = PLANT_DEFS[name].build
        end
        if info.animstate.anim == nil then
            info.animstate.anim = "idle_rot_oversized"
        end

        if info.workable ~= nil then
            if info.workable.action == nil then
                info.workable.action = ACTIONS.HAMMER
            end
            if info.workable.left_max == nil then
                info.workable.left_max = 1
            end
        else
            info.workable = { action = ACTIONS.HAMMER, left_max = 1 }
        end
        if info.physicsradius == nil then
            info.physicsradius = 0.1
        end
        if info.nohauntable ~= false then
            info.nohauntable = true
        end

        local fn_common = info.fn_common
        info.fn_common = function(inst)
            inst:AddTag("heavy")
            inst:AddTag("farm_plant_killjoy")
            inst:AddTag("pickable_harvest_str")
            inst:AddTag("pickable")
            inst:AddTag("oversized_veggie")
            inst.gymweight = 3

            MakeHeavyObstaclePhysics(inst, info.physicsradius)
            inst:SetPhysicsRadiusOverride(info.physicsradius)

		    inst._base_name = name

            if fn_common ~= nil then fn_common(inst) end
        end

        local fn_server = info.fn_server
        info.fn_server = function(inst)
            inst:AddComponent("heavyobstaclephysics")
            inst.components.heavyobstaclephysics:SetRadius(info.physicsradius)

            inst.components.inspectable.nameoverride = "VEGGIE_OVERSIZED_ROTTEN"

            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(info.workable.action)
            inst.components.workable:SetOnFinishCallback(OnFinishWork_oversized)
            inst.components.workable:SetWorkLeft(info.workable.left_max)

            inst:AddComponent("pickable")
            inst.components.pickable.onpickedfn = inst.Remove
            inst.components.pickable:SetUp(nil)
            inst.components.pickable.use_lootdropper_for_product = true
            inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"

            inst.components.inventoryitem.cangoincontainer = false
            inst.components.inventoryitem:SetSinks(true)

            inst:AddComponent("equippable")
            inst.components.equippable.equipslot = EQUIPSLOTS.BODY
            inst.components.equippable:SetOnEquip(function(inst, owner)
                owner.AnimState:OverrideSymbol("swap_body", info.animstate.build, "swap_body_rotten")
            end)
            inst.components.equippable:SetOnUnequip(OnUnequip_oversized)
            inst.components.equippable.walkspeedmult = TUNING.HEAVY_SPEED_MULT

            inst:AddComponent("submersible")
            inst:AddComponent("symbolswapdata")
            inst.components.symbolswapdata:SetData(info.animstate.build, "swap_body_rotten")

            inst:AddComponent("lootdropper")
            inst.components.lootdropper:SetLoot(PLANT_DEFS[name].loot_oversized_rot)

            MakeMediumBurnable(inst)
            inst.components.burnable:SetOnBurntFn(OnBurnt_oversized)
            MakeMediumPropagator(inst)

            MakeHauntableWork(inst)

            if fn_server ~= nil then fn_server(inst) end
        end

        MadePrefab(name.."_oversized_rotten", info)
    end
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

for name,data in pairs(ingredients_legion) do
    MakeIngredient(name, data)
end

return unpack(prefs)
