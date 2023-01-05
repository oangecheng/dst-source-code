local assets =
{
    Asset("ATLAS", "minimap/medal_spacetimestormmarker.xml"),
}

local prefabs =
{
    "globalmapicon",
}

local function do_marker_minimap_swap(inst)
    inst.marker_index = inst.marker_index == nil and 0 or ((inst.marker_index + 1) % 8)

    local marker_image = "medal_spacetimestormmarker"..inst.marker_index..".tex"

    inst.MiniMapEntity:SetIcon(marker_image)
    inst.icon.MiniMapEntity:SetIcon(marker_image)
end

local function show_minimap(inst)
    -- Create a global map icon so the minimap icon is visible to other players as well.
    inst.icon = SpawnPrefab("globalmapicon")
    inst.icon:TrackEntity(inst)
    inst.icon.MiniMapEntity:SetPriority(21)

    inst:DoPeriodicTask(TUNING.STORM_SWAP_TIME, do_marker_minimap_swap)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetCanUseCache(false)
    inst.MiniMapEntity:SetDrawOverFogOfWar(true)
    inst.MiniMapEntity:SetIcon("medal_spacetimestormmarker0.tex")
    inst.MiniMapEntity:SetPriority(21)

    inst.entity:SetCanSleep(false)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst.marker_index = 1
    inst:DoTaskInTime(0, show_minimap)

    return inst
end

return Prefab("medal_spacetimestormmarker", fn, assets, prefabs)