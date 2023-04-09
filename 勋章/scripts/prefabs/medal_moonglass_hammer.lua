local assets =
{
    Asset("ANIM", "anim/medal_moonglass_hammer.zip"),
    Asset("ANIM", "anim/swap_medal_moonglass_hammer.zip"),
    Asset("ANIM", "anim/floating_items.zip"),
	Asset("ATLAS", "images/medal_moonglass_hammer.xml"),
	Asset("ATLAS_BUILD", "images/medal_moonglass_hammer.xml",256),
}

--切换移植状态标签
local function changeHammerTag(inst,owner)
	--清除破坏工具标签
	if inst:HasTag("MEDALHAMMER_tool") then
		inst:RemoveTag("MEDALHAMMER_tool")
	end
	if TheWorld.state.isfullmoon or owner:HasTag("inmoonlight") then
		inst:AddTag("MEDALHAMMER_tool")--破坏工具标签
	end
end

--装备
local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_medal_moonglass_hammer", "swap_hammer")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	
	--监听是否月圆
	inst.onfullmoonfn=function(inst,isfullmoon)
		changeHammerTag(inst,owner)
	end 
	inst:WatchWorldState("isfullmoon", inst.onfullmoonfn)--监听月圆
	
	--监听玩家可移植状态变化
	inst.changestatefn=function(self)
		changeHammerTag(inst,owner)
	end
	inst:ListenForEvent("changehammerstate", inst.changestatefn, owner)--监听玩家可移植状态变化
	
	changeHammerTag(inst,owner)
end
--卸下
local function onunequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	
	--取消监听月圆事件
	inst:StopWatchingWorldState("isfullmoon", inst.onfullmoonfn)
	--取消监听玩家状态
	inst:RemoveEventCallback("changehammerstate", inst.changestatefn,owner)
	--取消监听玩家敲东西
	-- owner:RemoveEventCallback("finishedwork", inst.finishedwork)
	--清除破坏工具标签
	if inst:HasTag("MEDALHAMMER_tool") then
		inst:RemoveTag("MEDALHAMMER_tool")
	end
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

    -- MakeInventoryFloatable(inst, "small", 0.05, {1.2, 0.75, 1.2})
	MakeInventoryFloatable(inst, "med", 0.05, {0.8, 0.4, 0.8})

	inst.special_hammer_loot={--特殊破坏产出表
		saltstack = {"saltrock"},--盐矿
		dustmothden = {"medal_dustmothden_base","thulecite","thulecite","moonrocknugget","moonrocknugget"},--尘蛾窝
		medal_dustmothden = {},--时空尘蛾窝
	}

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
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	inst.components.finiteuses:SetConsumption(ACTIONS.MEDALHAMMER, 1)
	inst.components.finiteuses:SetConsumption(ACTIONS.HAMMER, 1)

	-------
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(TUNING.HAMMER_DAMAGE)

    inst:AddComponent("inspectable")
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)
	
	inst.components.floater:SetBankSwapOnFloat(true, -11, {sym_build = "swap_medal_moonglass_hammer",sym_name = "swap_hammer"})

    return inst
end

return Prefab("medal_moonglass_hammer", fn, assets)
