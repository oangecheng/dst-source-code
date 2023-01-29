require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/dragonfly_chest.zip"),
    Asset("ANIM", "anim/ndnr_toadstoolchest.zip"),
    Asset("ANIM", "anim/swap_ndnr_toadstoolchest.zip"),
    Asset("ANIM", "anim/ui_chester_shadow_3x4.zip"),

    Asset("IMAGE", "images/ndnr_toadstoolchest.tex"),
    Asset("ATLAS", "images/ndnr_toadstoolchest.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_toadstoolchest.xml", 256),
}

local prefabs =
{
    "collapse_small",
}

local function onopen(inst)
    inst.AnimState:PlayAnimation("open")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
end

local function onclose(inst)
    inst.AnimState:PlayAnimation("close")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
end

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("closed", false)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("closed", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/dragonfly_chest_craft")
end

-------------------------------------------------------------------------------------------------
local containers = require("containers")
local params = containers.params
params.ndnr_toadstoolchest =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_tacklecontainer_3x5",
        animbuild = "ui_tacklecontainer_3x5",
        pos = Vector3(0, 280, 0),
        side_align_tip = 160,
    },
    type = "chest",
}

for y = 1, -3, -1 do
    for x = 0, 2 do
        table.insert(params.ndnr_toadstoolchest.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 45, 0))
    end
end
-------------------------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("ndnr_toadstoolchest.tex")

    inst.AnimState:SetBank("dragonfly_chest")
    inst.AnimState:SetBuild("dragonfly_chest")
    inst.AnimState:PlayAnimation("closed")

    inst.AnimState:OverrideSymbol("chest01", "swap_ndnr_toadstoolchest", "ndnr_toadstoolchest")

    inst:AddTag("structure")
    inst:AddTag("chest")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("ndnr_toadstoolchest")
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true

    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(TUNING.PERISH_GLOBAL_MULT*10)

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(2)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:ListenForEvent("onbuilt", onbuilt)
    MakeSnowCovered(inst)

    AddHauntableDropItemOrWork(inst)

    return inst
end

return Prefab("ndnr_toadstoolchest", fn, assets),
    MakePlacer("ndnr_toadstoolchest_placer", "ndnr_toadstoolchest", "ndnr_toadstoolchest", "closed")
