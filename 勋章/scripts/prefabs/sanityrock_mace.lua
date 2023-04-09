------------------方尖锏--------------------
local assets =
{
    Asset("ANIM", "anim/sanityrock_mace.zip"),
    Asset("ANIM", "anim/sanityrock_mace_skin1.zip"),
    Asset("ANIM", "anim/sanityrock_mace_skin2.zip"),
    Asset("ANIM", "anim/floating_items.zip"),
	Asset("ATLAS", "images/sanityrock_mace.xml"),
	Asset("ATLAS_BUILD", "images/sanityrock_mace.xml",256),
}
--更新伤害
local function UpdateDamage(inst,owner)
	local dmg=TUNING.SPEAR_DAMAGE*TUNING_MEDAL.SANITYROCK_MACE_MIN_DAMAGE_MULT--默认最低伤害17
	--没耐久的话默认最低伤害
	if inst.components.finiteuses and inst.components.finiteuses:GetUses()>0 then
		if owner and owner.components.sanity then
			if owner.components.sanity:IsInsanityMode() then
				dmg = math.max(TUNING.SPEAR_DAMAGE * TUNING_MEDAL.SANITYROCK_MACE_MAX_DAMAGE_MULT * owner.components.sanity:GetPercent(),TUNING.SPEAR_DAMAGE*TUNING_MEDAL.SANITYROCK_MACE_MIN_DAMAGE_MULT)
			else
				dmg=TUNING.SPEAR_DAMAGE*TUNING_MEDAL.SANITYROCK_MACE_MOON_DAMAGE_MULT
			end
		end
	end
	if inst.components.weapon then
		inst.components.weapon:SetDamage(dmg)
	end
end

local function onequip(inst, owner)
	UpdateDamage(inst,owner)
	owner.AnimState:OverrideSymbol("swap_object", GetMedalSkinData(inst,"sanityrock_mace"), "swap_sanityrock_mace")
    
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	if inst.addusetask~=nil then
		inst.addusetask:Cancel()
	end
	--每秒更新一下伤害
	inst.addusetask=inst:DoPeriodicTask(.5, function(inst)
		--耐久没满并且玩家为精神值状态
		if inst.components.finiteuses and inst.components.finiteuses:GetPercent()<1 then
			if owner and owner.components.sanity and owner.components.sanity:IsInsanityMode() then
				--玩家san值满足扣除条件
				if owner.components.sanity.current>= TUNING_MEDAL.SANITYROCK_MACE_SANITYLOSS then
					owner.components.sanity:DoDelta(-TUNING_MEDAL.SANITYROCK_MACE_SANITYLOSS)
					inst.components.finiteuses:Use(-TUNING_MEDAL.SANITYROCK_MACE_ADDUSES)--恢复耐久
					-- UpdateDamage(inst,owner)
				end
			end
		end
		UpdateDamage(inst,owner)
	end)
end

local function onunequip(inst, owner)
    UpdateDamage(inst,owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	if inst.addusetask~=nil then
		inst.addusetask:Cancel()
		inst.addusetask=nil
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("sanityrock_mace")
    inst.AnimState:SetBuild("sanityrock_mace")
    inst.AnimState:PlayAnimation("sanityrock_mace")

    inst:AddTag("show_spoilage")
    inst:AddTag("icebox_valid")
	inst:AddTag("medal_skinable")--可换皮肤

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

	local swap_data =
	{
		sym_build = "sanityrock_mace",
		sym_name = "swap_sanityrock_mace",
		bank = "sanityrock_mace",
		anim = "sanityrock_mace"
	}
    MakeInventoryFloatable(inst, "med", nil, {1.0, 0.5, 1.0}, true, -13, swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.SPEAR_DAMAGE*TUNING_MEDAL.SANITYROCK_MACE_MIN_DAMAGE_MULT)
    inst.components.weapon:SetOnAttack(UpdateDamage)
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING_MEDAL.SANITYROCK_MACE_USES)
	inst.components.finiteuses:SetUses(TUNING_MEDAL.SANITYROCK_MACE_USES)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "sanityrock_mace"
	inst.components.inventoryitem.atlasname = "images/sanityrock_mace.xml"

    MakeHauntableLaunchAndPerish(inst)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

	inst:AddComponent("medal_skinable")

    return inst
end

return Prefab("sanityrock_mace", fn, assets)