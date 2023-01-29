local containers = require("containers")
local params = containers.params
params.ndnr_treehole =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_chest_3x3",
        animbuild = "ui_chest_3x3",
        pos = Vector3(0, 200, 0),
        side_align_tip = 160,
    },
    type = "chest",
    itemtestfn = function(container, item, slot)
        return not item:HasTag("irreplaceable")
    end
}

for y = 2, 0, -1 do
    for x = 0, 2 do
        table.insert(params.ndnr_treehole.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
    end
end

local function onopen(inst)
    if not inst:HasTag("burnt") then
        -- inst.AnimState:PlayAnimation("open")
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
    end
end

local function onclose(inst)
    if not inst:HasTag("burnt") then
        -- inst.AnimState:PlayAnimation("close")
        -- inst.AnimState:PushAnimation("closed", false)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")

        if inst.components.container ~= nil then
            inst.components.container:DestroyContents()
        end
    end
end

AddPrefabPostInit("oceantree_pillar", function(inst)
    inst:AddTag("ndnr_treehole")

    if not TheWorld.ismastersim then
        -- 直接用官方的slot需要主客机都声明一下 by 梧大
        inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("ndnr_treehole") end
        return inst
    end

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("ndnr_treehole")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true
end)