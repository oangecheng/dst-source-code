local medal_nitrify_tree_assets =
{
	Asset("ANIM", "anim/petrified_tree.zip"),
	Asset("ANIM", "anim/petrified_tree_tall.zip"),
	Asset("ANIM", "anim/petrified_tree_short.zip"),
	Asset("ANIM", "anim/petrified_tree_old.zip"),
	Asset("ANIM", "anim/medal_nitrify_tree.zip"),
	Asset("ANIM", "anim/medal_nitrify_tree_tall.zip"),
	Asset("ANIM", "anim/medal_nitrify_tree_short.zip"),
	Asset("ANIM", "anim/medal_nitrify_tree_old.zip"),
	-- Asset("MINIMAP_IMAGE", "petrified_tree"),
	Asset("ATLAS", "minimap/medal_nitrify_tree.xml"),
}

local prefabs =
{
	"nitre",
	"rock_break_fx",
	"collapse_small",
}

SetSharedLootTable( 'medal_nitrify_tree',
{
	{'nitre',  1.00},
	{'nitre',  1.00},
	{'nitre',  0.15},
})
SetSharedLootTable( 'medal_nitrify_tree_tall',
{
	{'nitre',  1.00},
	{'nitre',  1.00},
	{'nitre',  1.00},
	{'nitre',  0.45},
})
SetSharedLootTable( 'medal_nitrify_tree_short',
{
	{'nitre',  1.00},
	{'nitre',  0.15},
})
SetSharedLootTable( 'medal_nitrify_tree_old',
{
	{'nitre',  1.00},
	{'nitre',  0.15},
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

local function setnitrifyTreeSize(inst)
    if inst.treeSize == 4 then
        inst.AnimState:SetBuild("medal_nitrify_tree_old")
        inst.AnimState:SetBank("petrified_tree_old")
        inst.components.lootdropper:SetChanceLootTable('medal_nitrify_tree_old')
        inst.components.workable:SetWorkLeft(TUNING.PETRIFIED_TREE_OLD)
        inst.Physics:SetCapsule(.25, 2)
    elseif inst.treeSize == 3 then
        inst.AnimState:SetBuild("medal_nitrify_tree_tall")
        inst.AnimState:SetBank("petrified_tree_tall")
        inst.components.lootdropper:SetChanceLootTable('medal_nitrify_tree_tall')
        inst.components.workable:SetWorkLeft(TUNING.PETRIFIED_TREE_TALL)
        inst.Physics:SetCapsule(1, 2)
    elseif inst.treeSize == 1 then
        inst.AnimState:SetBuild("medal_nitrify_tree_short")
        inst.AnimState:SetBank("petrified_tree_short")
        inst.components.lootdropper:SetChanceLootTable('medal_nitrify_tree_short')
        inst.components.workable:SetWorkLeft(TUNING.PETRIFIED_TREE_SMALL)
        inst.Physics:SetCapsule(.25, 2)
    else
        inst.AnimState:SetBuild("medal_nitrify_tree")
        inst.AnimState:SetBank("petrified_tree")
        inst.components.lootdropper:SetChanceLootTable('medal_nitrify_tree')
        inst.components.workable:SetWorkLeft(TUNING.PETRIFIED_TREE_NORMAL)
        inst.Physics:SetCapsule(.65, 2)
    end
end

local function onsave(inst, data)
    data.treeSize = inst.treeSize
end

local function onload(inst, data)
    if data ~= nil and data.treeSize ~= nil then
        inst.treeSize = data.treeSize
        setnitrifyTreeSize(inst)
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

    --[[
    if multcolour == nil or (0 <= multcolour and multcolour < 1) then
        if multcolour == nil then
            multcolour = 0.5
        end

        local color = multcolour + math.random() * (1.0 - multcolour)
        inst.AnimState:SetMultColour(color, color, color, 1)
    end
    ]]
	-- inst.AnimState:SetMultColour(color, color, color, 1)

    inst:AddComponent("inspectable")
    -- inst.components.inspectable.nameoverride = "ROCK"
    MakeSnowCovered(inst)

    MakeHauntableWork(inst)

    return inst
end

local function medal_nitrify_tree_common(size)
    local inst = baserock_fn("medal_nitrify_tree", "petrified_tree", { "petrify_in", "full" }, "medal_nitrify_tree.tex", "shelter")

    inst:SetPrefabName("medal_nitrify_tree")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.showCloudFXwhenRemoved = true

    if not size then
        local rand = math.random()
        if rand > 0.90 then
            size = 4
        elseif rand > 0.60 then
            size = 1
        elseif rand < 0.30 then
            size = 2
        else
            size = 3
        end
    end

    inst.treeSize = size

    setnitrifyTreeSize(inst)

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

local function medal_nitrify_tree()
    return medal_nitrify_tree_common()
end

local function medal_nitrify_tree_short()
    return medal_nitrify_tree_common(1)
end

local function medal_nitrify_tree_med()
    return medal_nitrify_tree_common(2)
end

local function medal_nitrify_tree_tall()
    return medal_nitrify_tree_common(3)
end

local function medal_nitrify_tree_old()
    return medal_nitrify_tree_common(4)
end

return Prefab("medal_nitrify_tree", medal_nitrify_tree, medal_nitrify_tree_assets, prefabs),
    Prefab("medal_nitrify_tree_med", medal_nitrify_tree_med, medal_nitrify_tree_assets, prefabs),
    Prefab("medal_nitrify_tree_tall", medal_nitrify_tree_tall, medal_nitrify_tree_assets, prefabs),
    Prefab("medal_nitrify_tree_short", medal_nitrify_tree_short, medal_nitrify_tree_assets, prefabs),
    Prefab("medal_nitrify_tree_old", medal_nitrify_tree_old, medal_nitrify_tree_assets, prefabs)
    
