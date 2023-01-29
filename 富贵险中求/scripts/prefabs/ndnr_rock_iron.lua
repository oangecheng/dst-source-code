local ndnr_rock_iron_assets = {
    Asset("ANIM", "anim/ndnr_rock_iron.zip"),
    Asset("IMAGE", "images/ndnr_rock_iron.tex"),
    Asset("ATLAS", "images/ndnr_rock_iron.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_rock_iron.xml", 256),
}

local prefabs =
{
    "ndnr_iron",
    "rock_break_fx",
    "collapse_small",
}

SetSharedLootTable( 'ndnr_rock_iron',
{
    {'ndnr_iron',   1.0},
    {'ndnr_iron',   1.0},
    {'ndnr_iron',   1.0},
    {'ndnr_iron',   1.0},
    {'ndnr_iron',   0.6},
})

SetSharedLootTable( 'ndnr_rock_iron_med',
{
    {'ndnr_iron', 1.0},
    {'ndnr_iron', 1.0},
    {'ndnr_iron', 1.0},
    {'ndnr_iron', 0.4},
})

SetSharedLootTable( 'ndnr_rock_iron_low',
{
    {'ndnr_iron', 1.0},
    {'ndnr_iron', 1.0},
    {'ndnr_iron', 0.2},
})

local function OnWork(inst, worker, workleft)
    if workleft <= 0 then
        local pt = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pt:Get())
        inst.components.lootdropper:DropLoot(pt)

        if inst.showCloudFXwhenRemoved then
            local fx = SpawnPrefab("collapse_small")
            fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        end

		if not inst.doNotRemoveOnWorkDone then
	        inst:Remove()
		end
    else
        inst.AnimState:PlayAnimation(
            (workleft < TUNING.ROCKS_MINE / 3 and "low") or
            (workleft < TUNING.ROCKS_MINE * 2 / 3 and "med") or
            "full"
        )
    end
end

local function baserock_fn(bank, build, anim, icon, tag, multcolour)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)

    if icon ~= nil then
        inst.MiniMapEntity:SetIcon(icon)
    end

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)

    if type(anim) == "table" then
        for i, v in ipairs(anim) do
            if i == 1 then
                inst.AnimState:PlayAnimation(v)
            else
                inst.AnimState:PushAnimation(v, false)
            end
        end
    else
        inst.AnimState:PlayAnimation(anim)
    end

    MakeSnowCoveredPristine(inst)

    inst:AddTag("boulder")
    if tag ~= nil then
        inst:AddTag(tag)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
    inst.components.workable:SetOnWorkCallback(OnWork)

    -- if multcolour == nil or (0 <= multcolour and multcolour < 1) then
    --     if multcolour == nil then
    --         multcolour = 0.5
    --     end

    --     local color = multcolour + math.random() * (1.0 - multcolour)
    --     inst.AnimState:SetMultColour(color, color, color, 1)
    -- end

    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "ROCK"
    MakeSnowCovered(inst)

    MakeHauntableWork(inst)

    return inst
end

local function rock_iron_fn()
    local inst = baserock_fn("ndnr_rock_iron", "ndnr_rock_iron", "full", "ndnr_rock_iron.tex")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetChanceLootTable('ndnr_rock_iron')

    return inst
end

local function rock_iron_med()
    local inst = baserock_fn("ndnr_rock_iron", "ndnr_rock_iron", "med", "ndnr_rock_iron.tex")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE_MED)

    inst.components.lootdropper:SetChanceLootTable('ndnr_rock_iron_med')

    return inst
end

local function rock_iron_low()
    local inst = baserock_fn("ndnr_rock_iron", "ndnr_rock_iron", "low", "ndnr_rock_iron.tex")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetChanceLootTable('ndnr_rock_iron_low')
    inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE_LOW)

    return inst
end

return Prefab("ndnr_rock_iron", rock_iron_fn, ndnr_rock_iron_assets, prefabs),
    Prefab("ndnr_rock_iron_med", rock_iron_med, ndnr_rock_iron_assets, prefabs),
    Prefab("ndnr_rock_iron_low", rock_iron_low, ndnr_rock_iron_assets, prefabs)