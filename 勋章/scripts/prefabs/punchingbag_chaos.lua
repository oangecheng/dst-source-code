require "prefabutil" -- for MakePlacer

local chaos_assets =
{
    Asset("ANIM", "anim/punchingbag.zip"),
    Asset("ANIM", "anim/punchingbag_chaos.zip"),

	Asset("ATLAS", "minimap/punchingbag_chaos.xml" ),
	Asset("ATLAS", "images/punchingbag_chaos.xml"),
	Asset("IMAGE", "images/punchingbag_chaos.tex"),
}

local prefabs =
{
    "collapse_big",
}

--------------------------------------------------------------------------------
local NUM_DIGITS, MAX_NUM = 4, 9999
local function do_digits(inst, number, afflicter)
    number = math.min(MAX_NUM, number or 0)
    --打出幸运数字爆金币喽~
    if number == 88 and afflicter ~= nil then
        local call_times = TheWorld and TheWorld.components.medal_infosave and TheWorld.components.medal_infosave:CountLuckyNumberTimes(afflicter) or 0
        local moneynum = call_times==100 and 5 or call_times==10 and 2 or call_times==1 and 1 or 0
        if moneynum > 0 then
            for i = 1, moneynum do
                inst.components.lootdropper:SpawnLootPrefab("toil_money")
            end
        end
    end
    for digit_index = NUM_DIGITS, 1, -1 do
        local digit = number % 10
        number = math.floor(number / 10)
        inst.AnimState:OverrideSymbol("column"..digit_index, "punchingbag", "number"..digit.."_black")
    end

    if not (inst.components.burnable and inst.components.burnable:IsBurning()) then
        inst.SoundEmitter:PlaySound("farming/common/farm/veggie_scale/place")
    end
end

--------------------------------------------------------------------------------
local function on_health_delta(inst, data)
    if data.amount <= 0 then
        do_digits(inst, math.floor(math.abs(data.amount)),data.afflicter)
    end
end

local function on_blocked(inst, data)
    do_digits(inst, 0)
end

local function do_hit_presentation(inst)
    if not inst:HasTag("burnt") then
		if not (inst.AnimState:IsCurrentAnimation("hit") and inst.AnimState:GetCurrentAnimationFrame() < 4) then
			inst.AnimState:PlayAnimation("hit")
			inst.AnimState:PushAnimation("idle", false)
		end
        inst.SoundEmitter:PlaySound("stageplay_set/mannequin/hit")
    end
end

local function onhit(inst, data)
    do_hit_presentation(inst)
end
--------------------------------------------------------------------------------
local function should_accept_item(inst, item, doer)
    return item.components.equippable ~= nil
        and (item.components.equippable.equipslot == EQUIPSLOTS.HEAD
            or item.components.equippable.equipslot == EQUIPSLOTS.BODY),
        "GENERIC"
end

local function on_get_item(inst, giver, item)
    local equipslot = item.components.equippable.equipslot
    local current = inst.components.inventory:GetEquippedItem(equipslot)
    if current then
        inst.components.inventory:DropItem(current, true, true)
    end

    inst.components.inventory:Equip(item)
end

--------------------------------------------------------------------------------
local function on_finished_hammering(inst)
    local position = inst:GetPosition()
    inst.components.lootdropper:DropLoot(position)

    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(position:Get())
    fx:SetMaterial("wood")

    inst:Remove()
end

local function on_hammered(inst)
    do_hit_presentation(inst)

    inst.components.inventory:DropEverything(true)
end

--------------------------------------------------------------------------------
local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.SoundEmitter:PlaySound("stageplay_set/mannequin/place")
    inst.AnimState:PushAnimation("idle", false)
end

local function onequipped(inst, data)
    inst.SoundEmitter:PlaySound("stageplay_set/mannequin/swap")
end

--------------------------------------------------------------------------------
local function on_burnt(inst)
    if inst.components.trader then
        inst:RemoveComponent("trader")
    end
    if inst.components.activatable then
        inst:RemoveComponent("activatable")
    end
    if inst.components.inventory then
        inst.components.inventory:DropEverything()
    end
	if inst.components.combat ~= nil then
		inst:RemoveComponent("combat")
	end
	if inst.components.health ~= nil then
		inst:RemoveComponent("health")
	end
	inst:RemoveEventCallback("attacked", onhit)
	inst:RemoveEventCallback("onbuilt", onbuilt)
	inst:RemoveEventCallback("healthdelta", on_health_delta)
	inst:RemoveEventCallback("equip", onequipped)
    DefaultBurntStructureFn(inst)
end

local function on_save(inst, data)
    if (inst.components.burnable and inst.components.burnable:IsBurning())
            or inst:HasTag("burnt") then
        data.burnt = true
    end
end

local function on_load(inst, data)
    if data then
        if data.burnt then
            inst.components.burnable.onburnt(inst)
        end
    end
end

--------------------------------------------------------------------------------
local function basefn(build, tags)
    build = build or "punchingbag"

    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeSmallObstaclePhysics(inst, 0.25)

    inst:AddTag("structure")
    inst:AddTag("equipmentmodel")
    inst:AddTag("wooden")

    inst.DynamicShadow:SetSize(1.3, 0.6)

    inst.MiniMapEntity:SetIcon(build..".tex")

    inst.AnimState:SetBank("punchingbag")
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("idle")

    do_digits(inst, 0)

    if tags then
        for _, tag in ipairs(tags) do
            inst:AddTag(tag)
        end
    end

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.scrapbook_hidehealth = true

    --
    inst:AddComponent("combat")

    --
    inst:AddComponent("debuffable")

	--
	inst:AddComponent("colouradder")
	inst:AddComponent("bloomer")

    --
    local health = inst:AddComponent("health")
    health:SetMaxHealth(MAX_NUM + 10)
    health:SetMinHealth(1)
    health:StartRegen(MAX_NUM + 10, 0.1)

    --
    inst:AddComponent("inspectable")

    --
    inst:AddComponent("lootdropper")

    --
    inst:AddComponent("inventory")
    inst.components.inventory.maxslots = 0

    --
    local trader = inst:AddComponent("trader")
    trader:SetAbleToAcceptTest(should_accept_item)
    trader.onaccept = on_get_item
    trader.deleteitemonaccept = false
    trader.acceptnontradable = true

    --
    local workable = inst:AddComponent("workable")
    workable:SetWorkAction(ACTIONS.HAMMER)
    workable:SetWorkLeft(6)
    workable:SetOnFinishCallback(on_finished_hammering)
    workable:SetOnWorkCallback(on_hammered)

    --
    MakeHauntable(inst)
	MakeMediumBurnable(inst, nil, nil, true)
	inst.components.burnable:SetOnBurntFn(on_burnt)
	MakeMediumPropagator(inst)

    --
    inst:ListenForEvent("attacked", onhit)
    inst:ListenForEvent("onbuilt", onbuilt)
    inst:ListenForEvent("healthdelta", on_health_delta)
    inst:ListenForEvent("blocked", on_blocked)
    inst:ListenForEvent("equip", onequipped)

    --
    inst.OnSave = on_save
    inst.OnLoad = on_load
 
    return inst
end

----------------------------------------------
local CHAOS_BAG_TAGS = {"chaos_creature"}
local function chaosfn()
    local inst = basefn("punchingbag_chaos", CHAOS_BAG_TAGS)

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("planarentity")

    inst.components.inspectable.nameoverride = "punchingbag"

    return inst
end

return Prefab("punchingbag_chaos", chaosfn, chaos_assets, prefabs),
    MakePlacer("punchingbag_chaos_placer", "punchingbag", "punchingbag_chaos", "placer")