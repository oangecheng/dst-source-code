local assets =
{
    Asset("ANIM", "anim/down_filled_coat.zip"),
    Asset("ANIM", "anim/down_filled_coat_skin1.zip"),
	Asset("ATLAS", "images/down_filled_coat.xml"),
	Asset("ATLAS_BUILD", "images/down_filled_coat.xml",256),
}

local function onequip_winter(inst, owner)
    -- owner.AnimState:OverrideSymbol("swap_body", "down_filled_coat", "swap_body")
    owner.AnimState:OverrideSymbol("swap_body", GetMedalSkinData(inst,"down_filled_coat"), "swap_body")
    if owner:HasTag("equipmentmodel") then return end--假人就不往下走了
    inst.components.fueled:StartConsuming()
    if owner.components.temperature then
        local current=owner.components.temperature:GetCurrent()
        if current<6 then--当前体温低于6度时，额外消耗耐久回温，消耗量=温差*每度消耗
            owner.components.temperature:SetTemperature(6)
            inst.components.fueled:DoDelta(-math.ceil(TUNING_MEDAL.DOWN_FILLED_COAT_CONSUME*(6-current)))
        end
    end
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    if owner:HasTag("equipmentmodel") then return end--假人就不往下走了
    inst.components.fueled:StopConsuming()
end

local function create_common()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("down_filled_coat")
    inst.AnimState:SetBuild("down_filled_coat")
    inst.AnimState:PlayAnimation("anim")

    inst.foleysound = "dontstarve/movement/foley/trunksuit"

	inst:AddTag("powerabsorbable")--可吸收能力
	inst:AddTag("nofreezing")--不会过冷
    inst:AddTag("medal_skinable")--可换皮肤
	inst.medal_repair_loot = {goose_feather=TUNING_MEDAL.DOWN_FILLED_COAT_ADDUSE}--可用鸭毛修复10%
	
	MakeInventoryFloatable(inst, "small", 0.1, 0.8)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "down_filled_coat"
	inst.components.inventoryitem.atlasname = "images/down_filled_coat.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
	
	inst.components.equippable:SetOnEquip(onequip_winter)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("insulator")
	inst.components.insulator:SetInsulation(TUNING_MEDAL.DOWN_FILLED_COAT_INSULATION)

    inst:AddComponent("fueled")
    inst.components.fueled:InitializeFuelLevel(TUNING_MEDAL.DOWN_FILLED_COAT_PERISHTIME)
    inst.components.fueled:SetDepletedFn(inst.Remove)

    MakeHauntableLaunch(inst)

    inst:AddComponent("medal_skinable")--可换皮肤

    return inst
end

return Prefab("down_filled_coat", create_common, assets)
