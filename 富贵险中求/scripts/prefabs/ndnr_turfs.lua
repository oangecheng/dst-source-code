local WORLD_TILES = CurrentRelease.GreaterOrEqualTo("R22_PIRATEMONKEYS") and WORLD_TILES or GROUND
 
local prefabs =
{
    "gridplacer",
}

local function make_turf(tile, data)
    local name = "turf_"..data.name
    local function ondeploy(inst, pt, deployer)
        if deployer ~= nil and deployer.SoundEmitter ~= nil then
            deployer.SoundEmitter:PlaySound("dontstarve/wilson/dig")
        end

        local map = TheWorld.Map
        local original_tile_type = map:GetTileAtPoint(pt:Get())
        local x, y = map:GetTileCoordsAtPoint(pt:Get())
        if x ~= nil and y ~= nil then
            map:SetTile(x, y, tile)
            map:RebuildLayer(original_tile_type, x, y)
            map:RebuildLayer(tile, x, y)
        end

        local minimap = TheWorld.minimap.MiniMap
        minimap:RebuildLayer(original_tile_type, x, y)
        minimap:RebuildLayer(tile, x, y)

        inst.components.stackable:Get():Remove()
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(data.bank_build)
        inst.AnimState:SetBuild(data.bank_build)
        inst.AnimState:PlayAnimation(data.anim)

        inst.tile = tile

        inst:AddTag("groundtile")
        inst:AddTag("molebait")

        MakeInventoryFloatable(inst, "med", nil, 0.65)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/"..name..".xml"

        inst:AddComponent("bait")

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.TINY_FUEL
        MakeMediumBurnable(inst, TUNING.MED_BURNTIME)
        MakeSmallPropagator(inst)
        MakeHauntableLaunchAndIgnite(inst)

        inst:AddComponent("deployable")
        inst.components.deployable:SetDeployMode(DEPLOYMODE.TURF)
        inst.components.deployable.ondeploy = ondeploy
        inst.components.deployable:SetUseGridPlacer(true)

        ---------------------
        return inst
    end

    local assets =
    {
        Asset("ANIM", "anim/"..data.bank_build..".zip"),
        -- Asset("INV_IMAGE", "turf_"..data.name),
        Asset("ATLAS", "images/"..name..".xml"),
        Asset("IMAGE", "images/"..name..".tex"),
        Asset("ATLAS_BUILD", "images/"..name..".xml"),
    }
    return Prefab(name, fn, assets, prefabs)
end

local TURF_PROPERTIES =
{
    [WORLD_TILES.NDNR_ASPHALT]      = { name = "ndnr_asphalt",          anim = "asphalt",       bank_build = "ndnr_turf" },
    [WORLD_TILES.NDNR_SNAKESKIN]    = { name = "ndnr_snakeskinfloor",   anim = "snakeskin",     bank_build = "ndnr_turf" },
}

local ret = {}
for k, v in pairs(TURF_PROPERTIES) do
    table.insert(ret, make_turf(k, v))
end
return unpack(ret)
