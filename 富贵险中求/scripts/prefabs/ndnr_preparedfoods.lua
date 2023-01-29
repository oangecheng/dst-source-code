
local prefabs =
{
    "spoiled_food",
}

local function MakePreparedFood(data)
    local realname = data.basename or data.name
	local foodassets =
	{
        Asset("ANIM", "anim/cook_pot_food.zip"),
		Asset("ANIM", "anim/ndnr_cook_pot_food.zip"),
	}
    if data.ndnr_food then
        table.insert(foodassets, Asset("ATLAS", "images/"..realname..".xml"))
        table.insert(foodassets, Asset("IMAGE", "images/"..realname..".tex"))
        table.insert(foodassets, Asset("ATLAS_BUILD", "images/"..realname..".xml", 256))
    end

	if data.overridebuild then
        table.insert(foodassets, Asset("ANIM", "anim/"..data.overridebuild..".zip"))
	end

	local ndnrspiceoverridebuildname = data.ndnrspiceoverridebuildname == nil and "spices" or "ndnr_spices"
	local spicename = data.spice ~= nil and string.lower(data.spice) or nil
    if spicename ~= nil then
        table.insert(foodassets, Asset("ANIM", "anim/spices.zip"))
        table.insert(foodassets, Asset("ANIM", "anim/ndnr_spices.zip"))
        table.insert(foodassets, Asset("ANIM", "anim/plate_food.zip"))
        if string.sub(spicename, 1, 4) == "ndnr" then
            table.insert(foodassets, Asset("ATLAS", "images/"..spicename.."_over.xml"))
            table.insert(foodassets, Asset("IMAGE", "images/"..spicename.."_over.tex"))
        end
        table.insert(foodassets, Asset("INV_IMAGE", spicename.."_over"))
    end

    local foodprefabs = prefabs
    if data.prefabs ~= nil then
        foodprefabs = shallowcopy(prefabs)
        for i, v in ipairs(data.prefabs) do
            if not table.contains(foodprefabs, v) then
                table.insert(foodprefabs, v)
            end
        end
    end

    local function DisplayNameFn(inst)
        return subfmt(STRINGS.NAMES[data.spice.."_FOOD"], { food = STRINGS.NAMES[string.upper(data.basename)] })
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

		-- local food_symbol_build = nil
        if spicename ~= nil then
            inst.AnimState:SetBuild("plate_food")
            inst.AnimState:SetBank("plate_food")
            inst.AnimState:OverrideSymbol("swap_garnish", ndnrspiceoverridebuildname, spicename)

            inst:AddTag("spicedfood")

            inst.inv_image_bg = { image = realname..".tex" }
            inst.inv_image_bg.atlas = GetInventoryItemAtlas(inst.inv_image_bg.image) or "images/"..realname..".xml"

			-- food_symbol_build = data.overridebuild or "ndnr_cook_pot_food"
        else
			inst.AnimState:SetBuild(data.overridebuild or "cook_pot_food")
			inst.AnimState:SetBank("cook_pot_food")
        end

        if data.ndnr_light then
            inst.entity:AddLight()
            inst.Light:SetRadius(data.ndnr_light.radius)
            inst.Light:SetFalloff(data.ndnr_light.falloff or 0.6)
            inst.Light:SetIntensity(data.ndnr_light.intensity or 0.8)
            inst.Light:SetColour(data.ndnr_light.color[1], data.ndnr_light.color[2], data.ndnr_light.color[3])
            inst.Light:Enable(true)
        end

        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:OverrideSymbol("swap_food", data.overridebuild or data.ndnr_food and "ndnr_cook_pot_food" or "cook_pot_food", realname)

        inst:AddTag("preparedfood")
        if data.tags ~= nil then
            for i,v in pairs(data.tags) do
                inst:AddTag(v)
            end
        end

        if data.basename ~= nil then
            inst:SetPrefabNameOverride(data.basename)
            if data.spice ~= nil then
                inst.displaynamefn = DisplayNameFn
            end
        end

        if data.floater ~= nil then
            MakeInventoryFloatable(inst, data.floater[1], data.floater[2], data.floater[3])
        else
            MakeInventoryFloatable(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

		inst.food_symbol_build = data.overridebuild or realname

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = data.health
        inst.components.edible.hungervalue = data.hunger
        inst.components.edible.foodtype = data.foodtype or FOODTYPE.GENERIC
        inst.components.edible.secondaryfoodtype = data.secondaryfoodtype or nil
        inst.components.edible.sanityvalue = data.sanity or 0
        inst.components.edible.temperaturedelta = data.temperature or 0
        inst.components.edible.temperatureduration = data.temperatureduration or 0
        inst.components.edible.nochill = data.nochill or nil
        inst.components.edible.spice = data.spice
        inst.components.edible:SetOnEatenFn(data.oneatenfn)

        inst:AddComponent("inspectable")
        inst.wet_prefix = data.wet_prefix

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = realname

        if spicename ~= nil then
            if string.sub(spicename, 1, 4) == "ndnr" then
                inst.components.inventoryitem.atlasname = "images/"..spicename.."_over.xml"
            end
            inst.components.inventoryitem:ChangeImageName(spicename.."_over")
        elseif data.basename ~= nil then
            inst.components.inventoryitem:ChangeImageName(data.basename)
        else
            inst.components.inventoryitem.atlasname = "images/"..realname..".xml"
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        if data.perishtime ~= nil and data.perishtime > 0 then
            inst:AddComponent("perishable")
            inst.components.perishable:SetPerishTime(data.perishtime)
            inst.components.perishable:StartPerishing()
            inst.components.perishable.onperishreplacement = data.perishreplacement or "spoiled_food"
        end

        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)
        MakeHauntableLaunchAndPerish(inst)
        ---------------------

        inst:AddComponent("bait")

        ------------------------------------------------
        inst:AddComponent("tradable")

        ------------------------------------------------

        return inst
    end

    return Prefab(data.name, fn, foodassets, foodprefabs)
end

local prefs = {}

for k, v in pairs(require("ndnr_preparedfoods")) do
    if v.notinitprefab == nil then
        table.insert(prefs, MakePreparedFood(v))
    end
end

for k, v in pairs(require("ndnr_spicedfoods")) do
    table.insert(prefs, MakePreparedFood(v))
end

return unpack(prefs)
