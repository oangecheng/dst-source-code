local assets =
{
    Asset("ANIM", "anim/medal_moonglass_hammer.zip"),
    Asset("ANIM", "anim/swap_medal_moonglass_hammer.zip"),
    Asset("ANIM", "anim/floating_items.zip"),
	Asset("ATLAS", "images/medal_moonglass_hammer.xml"),
	Asset("ATLAS_BUILD", "images/medal_moonglass_hammer.xml",256),
}

--切换月光破坏标签
local function changeHammerTag(inst,owner)
	if TheWorld.state.isfullmoon or owner:HasTag("inmoonlight") then
		inst:AddTag("MEDALHAMMER_tool")--月光破坏标签
	else
		inst:RemoveTag("MEDALHAMMER_tool")
	end
end

--装备
local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_medal_moonglass_hammer", "swap_hammer")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	owner.medal_has_moon_hammer = true--手持月光玻璃锤

	inst.changetooltag = function(source,isfullmoon)
		changeHammerTag(inst,owner)
	end
	inst:WatchWorldState("isfullmoon", inst.changetooltag)--监听月圆
	inst:ListenForEvent("change_medal_moonlinght", inst.changetooltag, owner)--监听玩家月光环境变化
	
	changeHammerTag(inst,owner)
end
--卸下
local function onunequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	owner.medal_has_moon_hammer = nil
	
	inst:StopWatchingWorldState("isfullmoon", inst.changetooltag)--取消监听月圆事件
	inst:RemoveEventCallback("change_medal_moonlinght", inst.changetooltag,owner)--取消监听玩家状态
	inst.changetooltag = nil
	inst:RemoveTag("MEDALHAMMER_tool")--清除月光破坏工具标签
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

    inst.AnimState:SetBank("medal_moonglass_hammer")
    inst.AnimState:SetBuild("medal_moonglass_hammer")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("hammer")

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
	inst.components.inventoryitem.imagename = "medal_moonglass_hammer"
	inst.components.inventoryitem.atlasname = "images/medal_moonglass_hammer.xml"
    -----
    inst:AddComponent("tool")
	inst.components.tool:SetAction(ACTIONS.MEDALHAMMER, 1)--设置破坏动作
	inst.components.tool:SetAction(ACTIONS.HAMMER, TUNING_MEDAL.MOONGLASS_TOOL.EFFICIENCY)--可敲打
	
	--清除破坏工具标签
	if inst:HasTag("MEDALHAMMER_tool") then
		inst:RemoveTag("MEDALHAMMER_tool")
	end
	
	-- setTransplantTag(inst)--设置移植标签

	-------
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING_MEDAL.MOONGLASS_TOOL.MAXUSES)
	inst.components.finiteuses:SetUses(TUNING_MEDAL.MOONGLASS_TOOL.MAXUSES)
	inst.components.finiteuses:SetConsumption(ACTIONS.MEDALHAMMER, 1)
	inst.components.finiteuses:SetConsumption(ACTIONS.HAMMER, 1)

	-------
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(TUNING.HAMMER_DAMAGE)

    inst:AddComponent("inspectable")

    MakeHauntableLaunch(inst)
	
	inst.components.floater:SetBankSwapOnFloat(true, -11, {sym_build = "swap_medal_moonglass_hammer",sym_name = "swap_hammer"})

	SetImmortalTool(inst,SetupEquippable,TUNING_MEDAL.MOONGLASS_TOOL.MAXUSES,true)

    return inst
end

return Prefab("medal_moonglass_hammer", fn, assets)
