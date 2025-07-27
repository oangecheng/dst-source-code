local assets =
{
    -- Asset("ANIM", "anim/shovel.zip"),
    Asset("ANIM", "anim/medal_moonglass_shovel.zip"),
    Asset("ANIM", "anim/swap_medal_moonglass_shovel.zip"),
	-- Asset("ANIM", "anim/swap_shovel.zip"),
    Asset("ANIM", "anim/floating_items.zip"),
	Asset("ATLAS", "images/medal_moonglass_shovel.xml"),
	Asset("ATLAS_BUILD", "images/medal_moonglass_shovel.xml",256),
}

--切换移植状态标签
local function changeTransplantTag(inst,owner)
	if TheWorld.state.isfullmoon or owner:HasTag("inmoonlight") then
		inst:AddTag("MEDALTRANSPLANT_tool")--移植工具标签
		owner.medal_transplantman = true--月光移植者(可铲出砧木桩)
	else
		inst:RemoveTag("MEDALTRANSPLANT_tool")
		owner.medal_transplantman = nil
	end
end

--装备
local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_medal_moonglass_shovel", "swap_shovel")
	-- owner.AnimState:OverrideSymbol("swap_object", "medal_moonglass_shovel", "swap_shovel")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	owner.medal_has_moon_shovel = true--手持月光玻璃铲
	inst.changetooltag = function(source,isfullmoon)
		changeTransplantTag(inst,owner)
	end
	inst:WatchWorldState("isfullmoon", inst.changetooltag)--监听月圆
	inst:ListenForEvent("change_medal_moonlinght", inst.changetooltag, owner)--监听玩家可移植状态变化
	
	changeTransplantTag(inst,owner)
end
--卸下
local function onunequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	owner.medal_has_moon_shovel = nil

	inst:StopWatchingWorldState("isfullmoon", inst.changetooltag)--取消监听月圆事件
	inst:RemoveEventCallback("change_medal_moonlinght", inst.changetooltag,owner)--取消监听玩家状态
	inst.changetooltag = nil
	inst:RemoveTag("MEDALTRANSPLANT_tool")--清除移植工具标签
	owner.medal_transplantman = nil--清除移植者标签
end
--添加可装备组件相关内容
local function SetupEquippable(inst)
	inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("shovel")
    inst.AnimState:SetBuild("medal_moonglass_shovel")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("sharp")
    -- inst:AddTag("possessable_axe")

    --tool (from tool component) added to pristine state for optimization
    inst:AddTag("tool")

    if TheNet:GetServerGameMode() ~= "quagmire" then
        --weapon (from weapon component) added to pristine state for optimization
        inst:AddTag("weapon")
    end

	inst.medal_repair_immortal = {--修补列表
		moonglass = TUNING_MEDAL.MOONGLASS_TOOL.ADDUSE,--月光玻璃
		immortal_essence = TUNING_MEDAL.MOONGLASS_TOOL.MAXUSES,--不朽精华
		immortal_fruit = TUNING_MEDAL.MOONGLASS_TOOL.MAXUSES,--不朽果实
	}

    -- MakeInventoryFloatable(inst, "small", 0.05, {1.2, 0.75, 1.2})
	MakeInventoryFloatable(inst, "med", 0.05, {0.8, 0.4, 0.8})

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "medal_moonglass_shovel"
	inst.components.inventoryitem.atlasname = "images/medal_moonglass_shovel.xml"
    -----
    inst:AddComponent("tool")
	inst.components.tool:SetAction(ACTIONS.MEDALTRANSPLANT, 1)--设置月光移植动作
	inst.components.tool:SetAction(ACTIONS.DIG, TUNING_MEDAL.MOONGLASS_TOOL.EFFICIENCY)--可挖掘
	inst.components.tool:SetAction(ACTIONS.MEDALNORMALTRANSPLANT, 1)--设置普通移植动作
	
	--清除移植工具标签
	if inst:HasTag("MEDALTRANSPLANT_tool") then
		inst:RemoveTag("MEDALTRANSPLANT_tool")
	end
	
	-- setTransplantTag(inst)--设置移植标签

	-------
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING_MEDAL.MOONGLASS_TOOL.MAXUSES)
	inst.components.finiteuses:SetUses(TUNING_MEDAL.MOONGLASS_TOOL.MAXUSES)
	inst.components.finiteuses:SetConsumption(ACTIONS.MEDALTRANSPLANT, 1)--月光移植
	inst.components.finiteuses:SetConsumption(ACTIONS.DIG, 1)--挖掘
	inst.components.finiteuses:SetConsumption(ACTIONS.MEDALNORMALTRANSPLANT, 1)--普通移植

	-------
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(TUNING.SHOVEL_DAMAGE)

    inst:AddComponent("inspectable")

    MakeHauntableLaunch(inst)
	
	inst.components.floater:SetBankSwapOnFloat(true, -11, {sym_build = "swap_medal_moonglass_shovel",sym_name = "swap_shovel"})

	SetImmortalTool(inst,SetupEquippable,TUNING_MEDAL.MOONGLASS_TOOL.MAXUSES,true)

    return inst
end

return Prefab("medal_moonglass_shovel", fn, assets)
