local assets =
{
    Asset("ANIM", "anim/marbleaxe.zip"),
    Asset("ANIM", "anim/swap_marbleaxe.zip"),
    Asset("ANIM", "anim/floating_items.zip"),
	Asset("ATLAS", "images/marbleaxe.xml"),
	Asset("ATLAS_BUILD", "images/marbleaxe.xml",256),
}
--清除快速饥饿标签
local function emptyQuickHungerTag(owner)
	--移除快速饥饿标签
	--小箭头
	if owner:HasTag("quickhunger_marbleaxe") then
		owner:RemoveTag("quickhunger_marbleaxe")
	end
	--中箭头
	if owner:HasTag("quickhunger_marbleaxe_more") then
		owner:RemoveTag("quickhunger_marbleaxe_more")
	end
	--大箭头
	if owner:HasTag("quickhunger_marbleaxe_most") then
		owner:RemoveTag("quickhunger_marbleaxe_most")
	end
end
--设置饱食下降速度和移速
local function setHungerModifier(inst,owner)
	if owner.components.hunger ~= nil then
		--初级伐木勋章
		if owner.small_chop then
			owner.components.hunger.burnratemodifiers:SetModifier(inst, TUNING_MEDAL.MARBLEAXE.HUNGER_RATE_SMALL)--饱食下降速度
			inst.components.equippable.walkspeedmult = TUNING_MEDAL.MARBLEAXE.SPEED_MULT_SMALL--移速
		--中级伐木勋章
		elseif owner.medium_chop then
			owner.components.hunger.burnratemodifiers:SetModifier(inst, TUNING_MEDAL.MARBLEAXE.HUNGER_RATE_MEDIUM)
			inst.components.equippable.walkspeedmult = TUNING_MEDAL.MARBLEAXE.SPEED_MULT_MEDIUM
		--高级伐木勋章
		elseif owner.large_chop then
			owner.components.hunger.burnratemodifiers:SetModifier(inst, TUNING_MEDAL.MARBLEAXE.HUNGER_RATE_LARGE)
			inst.components.equippable.walkspeedmult = TUNING_MEDAL.MARBLEAXE.SPEED_MULT_LARGE
		else--无伐木勋章
			owner.components.hunger.burnratemodifiers:SetModifier(inst, TUNING_MEDAL.MARBLEAXE.HUNGER_RATE)
			inst.components.equippable.walkspeedmult = TUNING_MEDAL.MARBLEAXE.SPEED_MULT
			inst.components.tool:SetAction(ACTIONS.CHOP, TUNING_MEDAL.MARBLEAXE.EFFICIENCY)
		end
    end
end

--装备
local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_marbleaxe", "swap_marbleaxe")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	
	setHungerModifier(inst,owner)--设置移速、饱食下降速度
	
	inst.changechop=function()
		setHungerModifier(inst,owner)
	end
	
	inst:ListenForEvent("changechopmedal", inst.changechop, owner)
end
--卸下
local function onunequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	--取消饥饿加速
	if owner.components.hunger ~= nil then
        owner.components.hunger.burnratemodifiers:RemoveModifier(inst)
    end
	--移除快速饥饿标签
	-- emptyQuickHungerTag(owner)
	--恢复初始速度设定
	inst.components.equippable.walkspeedmult = TUNING_MEDAL.MARBLEAXE.SPEED_MULT
	inst:RemoveEventCallback("changechopmedal", inst.changechop, owner)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("marbleaxe")
    inst.AnimState:SetBuild("marbleaxe")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("possessable_axe")

    --tool (from tool component) added to pristine state for optimization
    inst:AddTag("tool")

    if TheNet:GetServerGameMode() ~= "quagmire" then
        --weapon (from weapon component) added to pristine state for optimization
        inst:AddTag("weapon")
    end

    MakeInventoryFloatable(inst, "small", 0.05, {1.2, 0.75, 1.2})

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "marbleaxe"
	inst.components.inventoryitem.atlasname = "images/marbleaxe.xml"
    -----
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, TUNING_MEDAL.MARBLEAXE.EFFICIENCY)

	-------
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING_MEDAL.MARBLEAXE.MAXUSES)
	inst.components.finiteuses:SetUses(TUNING_MEDAL.MARBLEAXE.MAXUSES)
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)

	-------
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(TUNING.AXE_DAMAGE)

    inst:AddComponent("inspectable")
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	inst.components.equippable.walkspeedmult = TUNING_MEDAL.MARBLEAXE.SPEED_MULT--设置移动速度

    MakeHauntableLaunch(inst)
	
	inst.components.floater:SetBankSwapOnFloat(true, -11, {sym_build = "swap_marbleaxe"})

    return inst
end

return Prefab("marbleaxe", fn, assets)
