local assets =
{
    Asset("ANIM", "anim/marblepickaxe.zip"),
    -- Asset("ANIM", "anim/swap_marbleaxe.zip"),
    Asset("ANIM", "anim/floating_items.zip"),
	Asset("ATLAS", "images/marblepickaxe.xml"),
	Asset("ATLAS_BUILD", "images/marblepickaxe.xml",256),
}
--设置饱食下降速度和移速
local function setHungerModifier(inst,owner)
	if owner.components.hunger ~= nil then
		--初级矿工勋章
		if owner.small_mine then
			owner.components.hunger.burnratemodifiers:SetModifier(inst, TUNING_MEDAL.MARBLEPICKAXE.HUNGER_RATE_SMALL)--饱食下降速度
			inst.components.equippable.walkspeedmult = TUNING_MEDAL.MARBLEPICKAXE.SPEED_MULT_SMALL--移速
		--中级矿工勋章
		elseif owner.medium_mine then
			owner.components.hunger.burnratemodifiers:SetModifier(inst, TUNING_MEDAL.MARBLEPICKAXE.HUNGER_RATE_MEDIUM)
			inst.components.equippable.walkspeedmult = TUNING_MEDAL.MARBLEPICKAXE.SPEED_MULT_MEDIUM
		--高级矿工勋章
		elseif owner.large_mine then
			owner.components.hunger.burnratemodifiers:SetModifier(inst, TUNING_MEDAL.MARBLEPICKAXE.HUNGER_RATE_LARGE)
			inst.components.equippable.walkspeedmult = TUNING_MEDAL.MARBLEPICKAXE.SPEED_MULT_LARGE
		else--无矿工勋章
			owner.components.hunger.burnratemodifiers:SetModifier(inst, TUNING_MEDAL.MARBLEPICKAXE.HUNGER_RATE)
			inst.components.equippable.walkspeedmult = TUNING_MEDAL.MARBLEPICKAXE.SPEED_MULT
		end
    end
end
--装备
local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "marblepickaxe", "swap_marblepickaxe")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	
	setHungerModifier(inst,owner)
	
	inst.changemine=function()
		setHungerModifier(inst,owner)
	end
	inst:ListenForEvent("changeminermedal", inst.changemine, owner)
end
--卸下
local function onunequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	--取消饥饿加速
	if owner.components.hunger ~= nil then
        owner.components.hunger.burnratemodifiers:RemoveModifier(inst)
    end
	--恢复初始速度设定
	inst.components.equippable.walkspeedmult = TUNING_MEDAL.MARBLEPICKAXE.SPEED_MULT
	inst:RemoveEventCallback("changeminermedal", inst.changemine, owner)
end

--添加可装备组件相关内容
local function SetupEquippable(inst)
	inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	inst.components.equippable.walkspeedmult = TUNING_MEDAL.MARBLEPICKAXE.SPEED_MULT--设置移动速度
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("marblepickaxe")
    inst.AnimState:SetBuild("marblepickaxe")
    inst.AnimState:PlayAnimation("marblepickaxe")

    inst:AddTag("sharp")

    --tool (from tool component) added to pristine state for optimization
    inst:AddTag("tool")

    if TheNet:GetServerGameMode() ~= "quagmire" then
        --weapon (from weapon component) added to pristine state for optimization
        inst:AddTag("weapon")
    end

	inst.medal_repair_immortal = {--修补列表
		marble = TUNING_MEDAL.MARBLEPICKAXE.ADDUSE,--大理石
		immortal_essence = TUNING_MEDAL.MARBLEPICKAXE.MAXUSES,--不朽精华
		immortal_fruit = TUNING_MEDAL.MARBLEPICKAXE.MAXUSES,--不朽果实
	}

    MakeInventoryFloatable(inst, "small", 0.05, {1.2, 0.75, 1.2})

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "marblepickaxe"
	inst.components.inventoryitem.atlasname = "images/marblepickaxe.xml"
    -----
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.MINE, TUNING_MEDAL.MARBLEPICKAXE.EFFICIENCY)

	-------
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING_MEDAL.MARBLEPICKAXE.MAXUSES)
	inst.components.finiteuses:SetUses(TUNING_MEDAL.MARBLEPICKAXE.MAXUSES)
	inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 1)

	-------
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(TUNING.AXE_DAMAGE)

    inst:AddComponent("inspectable")

    MakeHauntableLaunch(inst)
	
	inst.components.floater:SetBankSwapOnFloat(true, -11, {sym_build = "marblepickaxe",sym_name = "swap_marblepickaxe",bank = "marblepickaxe",anim = "marblepickaxe"})

	SetImmortalTool(inst,SetupEquippable,TUNING_MEDAL.MARBLEPICKAXE.MAXUSES,true)

    return inst
end

return Prefab("marblepickaxe", fn, assets)
