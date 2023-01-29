
local function MakeWeedSeed(prefabname)
    local seedname = string.sub(prefabname, 6, -1)
    local assets =
    {
        Asset("ANIM", "anim/ndnr_weed_seeds.zip"),
        Asset("IMAGE", "images/"..prefabname.."_seeds.tex"),
        Asset("ATLAS", "images/"..prefabname.."_seeds.xml"),
        Asset("ATLAS_BUILD", "images/"..prefabname.."_seeds.xml", 256),
    }

    local function OnDeploy(inst, pt, deployer) --, rot)
        local plant = SpawnPrefab("weed_"..seedname)
        plant.Transform:SetPosition(pt.x, 0, pt.z)
        plant:PushEvent("on_planted", {in_soil = false, doer = deployer, seed = inst})
        TheWorld.Map:CollapseSoilAtPoint(pt.x, 0, pt.z)
        -- plant.SoundEmitter:PlaySound("dontstarve/wilson/plant_seeds")
        inst:Remove()
    end

    local function can_plant_seed(inst, pt, mouseover, deployer)
        local x, z = pt.x, pt.z
        return TheWorld.Map:CanTillSoilAtPoint(x, 0, z, true)
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.AnimState:SetBank("ndnr_weed_seeds")
        inst.AnimState:SetBuild("ndnr_weed_seeds")
        inst.AnimState:PlayAnimation(seedname.."_seed")
        inst.AnimState:SetRayTestOnBB(true)

        inst:AddTag("deployedplant")
        inst:AddTag("deployedfarmplant")
        inst:AddTag("cookable")
        inst:AddTag("oceanfishing_lure")

        MakeInventoryPhysics(inst)
        MakeInventoryFloatable(inst)

        inst.entity:SetPristine()

        inst._custom_candeploy_fn = can_plant_seed -- for DEPLOYMODE.CUSTOM
        inst.overridedeployplacername = "seeds_placer"

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/"..prefabname.."_seeds.xml"

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("edible")
        inst.components.edible.foodtype = FOODTYPE.SEEDS
        inst.components.edible.healthvalue = 0
        inst.components.edible.hungervalue = TUNING.CALORIES_TINY/2

        inst:AddComponent("cookable")
        inst.components.cookable.product = "seeds_cooked"

        inst:AddComponent("tradable")
        inst:AddComponent("inspectable")

        MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
        MakeSmallPropagator(inst)
        MakeHauntableLaunchAndPerish(inst)

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food"

        inst:AddComponent("bait")

        inst:AddComponent("farmplantable")
        inst.components.farmplantable.plant = "weed_"..seedname --"farm_plant_watermelon"

        inst:AddComponent("oceanfishingtackle")
        inst.components.oceanfishingtackle:SetupLure({build = "oceanfishing_lure_mis", symbol = "hook_seeds", single_use = true, lure_data = TUNING.OCEANFISHING_LURE.SEED})

        inst:AddComponent("deployable")
        inst.components.deployable:SetDeployMode(DEPLOYMODE.CUSTOM) -- use inst._custom_candeploy_fn
        inst.components.deployable.restrictedtag = "plantkin"
        inst.components.deployable.ondeploy = OnDeploy
        -- inst.components.deployable.spacing = DEPLOYSPACING.MEDIUM

        return inst
    end

    return Prefab(prefabname.."_seeds", fn, assets)
end

local function update_seed_placer_outline(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	if TheWorld.Map:CanTillSoilAtPoint(x, y, z) then
		local cx, cy, cz = TheWorld.Map:GetTileCenterPoint(x, y, z)
		inst.outline.Transform:SetPosition(cx, cy, cz)
		inst.outline:Show()
	else
		inst.outline:Hide()
	end
end

local function seed_placer_postinit(inst)
	inst.outline = SpawnPrefab("tile_outline")

	inst.outline.Transform:SetPosition(2, 0, 0)
	inst.outline:ListenForEvent("onremove", function() inst.outline:Remove() end, inst)
	inst.outline.AnimState:SetAddColour(.25, .75, .25, 0)
	inst.outline:Hide()

	inst.components.placer.onupdatetransform = update_seed_placer_outline
end

return MakeWeedSeed("ndnr_firenettle"),
    MakeWeedSeed("ndnr_forgetmelots"),
    MakeWeedSeed("ndnr_tillweed"),
    MakePlacer("ndnr_firenettle_seeds_placer", "farm_soil", "farm_soil", "till_idle", nil, nil, nil, nil, nil, nil, seed_placer_postinit),
    MakePlacer("ndnr_forgetmelots_seeds_placer", "farm_soil", "farm_soil", "till_idle", nil, nil, nil, nil, nil, nil, seed_placer_postinit),
    MakePlacer("ndnr_tillweed_seeds_placer", "farm_soil", "farm_soil", "till_idle", nil, nil, nil, nil, nil, nil, seed_placer_postinit)