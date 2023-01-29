local containers = require("containers")
local params = containers.params

local assets=
{
	Asset("ANIM", "anim/ndnr_thatchpack.zip"),
    Asset("IMAGE", "images/ndnr_thatchpack.tex"),
    Asset("ATLAS", "images/ndnr_thatchpack.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_thatchpack.xml", 256),
}

local function onopen(inst)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/backpack_open", "open")
end

local function onclose(inst)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/backpack_close", "open")
end

params.ndnr_thatchpack =
{
    widget =
    {
        slotpos =
        {
            Vector3(-37.5, 32 + 4, 0),
            Vector3(37.5, 32 + 4, 0),
            Vector3(-37.5, -(32 + 4), 0),
            Vector3(37.5, -(32 + 4), 0),
        },
        animbank = "ui_chest_2x2",
        animbuild = "ui_chest_2x2",
        pos = Vector3(200, 0, 0),
        side_align_tip = 120,
    },
    type = "cooker",
}

function params.ndnr_thatchpack.itemtestfn(container, item, slot)
    return not (item:HasTag("irreplaceable") or item:HasTag("_container") or item:HasTag("bundle") or item:HasTag("nobundling") or item:HasTag("ndnr_thatchpack"))
end

local function onburnt(inst)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end

    SpawnPrefab("ash").Transform:SetPosition(inst.Transform:GetWorldPosition())

    inst:Remove()
end

local function onignite(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = false
    end
end

local function onextinguish(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = true
    end
end

local function onfinished(inst)
    if inst.components.container then
        inst.components.container:DropEverything(inst:GetPosition())
    end
    inst:Remove()
end

local function initfiniteuses(inst)
    if inst.components.timer then
        if not inst.components.timer:TimerExists("ndnr_thatchpack_uses") then
            inst.components.timer:StartTimer("ndnr_thatchpack_uses", TUNING.TOTAL_DAY_TIME)
        end
    end
end

local function ontimerdone(inst, data)
    if data.name == "ndnr_thatchpack_uses" then
        if inst.components.finiteuses then
            if inst.components.finiteuses:GetUses() > 0 then
                inst.components.timer:StartTimer("ndnr_thatchpack_uses", TUNING.TOTAL_DAY_TIME)
            end
            inst.components.finiteuses:Use(1)
        end
    end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("ndnr_thatchpack")
    inst.AnimState:SetBuild("ndnr_thatchpack")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("ndnr_thatchpack")

	inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("ndnr_thatchpack.tex")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()
    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------

    inst:AddComponent("timer")
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_thatchpack.xml"

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("ndnr_thatchpack")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(10)
    inst.components.finiteuses:SetUses(10)
    inst.components.finiteuses:SetOnFinished(onfinished)

    inst:DoTaskInTime(FRAMES, initfiniteuses)

    inst:ListenForEvent("timerdone", ontimerdone)

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    inst.components.burnable:SetOnBurntFn(onburnt)
    inst.components.burnable:SetOnIgniteFn(onignite)
    inst.components.burnable:SetOnExtinguishFn(onextinguish)

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab( "ndnr_thatchpack", fn, assets)
