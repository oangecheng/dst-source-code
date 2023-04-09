---
--- @author zsh in 2023/1/11 2:56
---

-- 兼容之前的内容
local name_structure = "_big_box";
local name_inventoryitem = "_big_box_chest";

local API = require("huge_box.API");

local containers = require("containers");
local params = containers.params;

local function fn(inst, doer)
    if inst.components.container ~= nil then
        API.arrangeContainer(inst);
    elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
        SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
    end
end

local function validfn(inst)
    return inst.replica.container ~= nil and not inst.replica.container:IsEmpty();
end

params.hb_huge_box = {
    widget = {
        slotpos = {},
        animbank = "big_box_ui_120",
        animbuild = "big_box_ui_120",
        pos = Vector3(0, 0 + 100, 0),
        buttoninfo = {
            text = "一键整理",
            position = Vector3(-5, 193, 0), --数字诡异因为背景图调的不好
            fn = fn,
            validfn = validfn
        }
    },
    type = "chest",
    itemtestfn = function(container, item, slot)
        if item:HasTag("_container") then
            return false;
        end
        return true;
    end
}

local spacer = 30 --间距
local posX = nil --x
local posY = nil --y
for z = 0, 2 do
    for y = 7, 0, -1 do
        for x = 0, 4 do
            posX = 80 * x - 600 + 80 * 5 * z + spacer * z
            posY = 80 * y - 100

            if y > 3 then
                posY = posY + spacer
            end

            table.insert(params.hb_huge_box.widget.slotpos, Vector3(posX, posY, 0))
        end
    end
end

for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end

local function ondropped(inst)
    if inst.components.container then
        inst.components.container:Close()
    end
end

--local function onbuilt(inst)
--    inst.AnimState:PlayAnimation("place")
--    inst.AnimState:PushAnimation("closed", true)
--    inst.SoundEmitter:PlaySound("dontstarve/common/craftable/chest")
--end

local function ondeploy(inst, pt, deployer)
    local chest = SpawnPrefab(name_structure);
    chest.Transform:SetPosition(pt:Get())

    chest.AnimState:PlayAnimation("place")
    chest.AnimState:PushAnimation("closed", true)
    --chest.SoundEmitter:PlaySound("dontstarve/common/craftable/chest")
    chest.SoundEmitter:PlaySound("dontstarve/common/dragonfly_chest_craft")

    API.transferContainerAllItems(inst, chest);
    inst:Remove()
end

local function onhammered(inst, worker)
    local item = inst.components.lootdropper:SpawnLootPrefab(name_inventoryitem);
    API.transferContainerAllItems(inst, item);

    item.AnimState:PlayAnimation("place")
    item.AnimState:PushAnimation("closed", true)
    item.SoundEmitter:PlaySound("dontstarve/common/dragonfly_chest_craft")

    inst:Remove()
end

local assets = {
    Asset("ANIM", "anim/water_chest.zip"),
}

local function commonfn()

    local inst = CreateEntity();

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("waterchest.tex")

    inst.AnimState:SetBank("water_chest")
    inst.AnimState:SetBuild("water_chest")
    inst.AnimState:PlayAnimation("closed", false)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        local old_OnEntityReplicated = inst.OnEntityReplicated

        inst.OnEntityReplicated = function(inst)

            if old_OnEntityReplicated then
                old_OnEntityReplicated(inst)
            end
            if inst.replica.container then
                inst.replica.container:WidgetSetup("hb_huge_box");
            end
        end
        return inst
    end

    inst.onhammered = onhammered;

    --兼容智能小木牌
    if TUNING.HUGE_BOX.smart_sign_draw then
        if TUNING.SMART_SIGN_DRAW_ENABLE then
            SMART_SIGN_DRAW(inst);
        end
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("hb_huge_box");

    if TUNING.HUGE_BOX.SET_PRESERVER_VALUE ~= -1 then
        inst:AddComponent("preserver")
        inst.components.preserver:SetPerishRateMultiplier(TUNING.HUGE_BOX.SET_PRESERVER_VALUE)
    end

    return inst;
end

local structure_scale = 1.5;
structure_scale = 1;

local function structure()
    local inst = commonfn();

    inst:AddTag("structure")
    inst:AddTag("chest")
    inst:AddTag("huge_box")

    local scale = structure_scale;
    inst.Transform:SetScale(scale, scale, scale);

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("huge_box_cmp")

    inst.components.container.onopenfn = function(inst)
        inst.AnimState:PlayAnimation("open")
        inst.AnimState:PushAnimation("opened", true)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
    end
    inst.components.container.onclosefn = function(inst)
        inst.AnimState:PlayAnimation("close")
        inst.AnimState:PushAnimation("closed", true)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
    end

    inst:AddComponent("lootdropper")
    --inst:AddComponent("workable")
    --inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    --inst.components.workable:SetWorkLeft(2)
    --inst.components.workable:SetOnFinishCallback(onhammered)
    --inst.components.workable:SetOnWorkCallback(onhit)

    -- TEMP
    --if inst.components.workable then
    --    local old_Destroy = inst.components.workable.Destroy
    --    function inst.components.workable:Destroy(destroyer)
    --        if destroyer.components.playercontroller == nil then
    --            return
    --        end
    --        return old_Destroy(self, destroyer)
    --    end
    --end

    --inst:ListenForEvent("onbuilt", onbuilt)
    MakeSnowCovered(inst, .01)

    return inst;
end

local function inventoryitem()

    local inst = commonfn();

    MakeInventoryPhysics(inst)

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.container.onopenfn = function(inst)
        inst.AnimState:PlayAnimation("open")
        inst.AnimState:PushAnimation("opened", true)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")

        if inst.components.inventoryitem then
            inst.components.inventoryitem.atlasname = "images/inventoryitems/huge_box/open.xml"
            inst.components.inventoryitem:ChangeImageName("open")
        end
    end
    inst.components.container.onclosefn = function(inst)
        inst.AnimState:PlayAnimation("close")
        inst.AnimState:PushAnimation("closed", true)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")

        if inst.components.inventoryitem then
            inst.components.inventoryitem.atlasname = "images/inventoryitems/huge_box/close.xml"
            inst.components.inventoryitem:ChangeImageName("close")
        end
    end

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem.canonlygoinpocket = true;
    inst.components.inventoryitem.atlasname = "images/inventoryitems/huge_box/close.xml"
    inst.components.inventoryitem:ChangeImageName("close")
    --inst.components.inventoryitem.imagename = "waterchest"
    --inst.components.inventoryitem.atlasname = "images/DLC0002/inventoryimages.xml"

    inst.components.inventoryitem:SetOnDroppedFn(ondropped)

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.DEFAULT)

    MakeHauntableLaunch(inst)

    return inst;
end

return Prefab(name_structure, structure, assets), Prefab(name_inventoryitem, inventoryitem, assets),
MakePlacer(name_inventoryitem .. "_placer", "water_chest", "water_chest", "closed", nil, nil, nil, nil);
