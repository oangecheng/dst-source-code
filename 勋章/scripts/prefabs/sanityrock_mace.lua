------------------方尖锏--------------------
local assets =
{
    Asset("ANIM", "anim/sanityrock_mace.zip"),
    Asset("ANIM", "anim/floating_items.zip"),
	Asset("ATLAS", "images/sanityrock_mace.xml"),
	Asset("ATLAS_BUILD", "images/sanityrock_mace.xml",256),
}
--更新伤害
local function UpdateDamage(inst,owner)
	local dmg = TUNING_MEDAL.SANITYROCK_MACE_MIN_DAMAGE--默认最低伤害17
	--没耐久的话默认最低伤害
	if inst.components.finiteuses and inst.components.finiteuses:GetUses()>0 then
		if owner and owner.components.sanity then
			local level = inst.components.medal_immortal and inst.components.medal_immortal.level or 0--不朽等级
			local sanity_mult = owner.components.sanity:IsInsanityMode() and owner.components.sanity:GetPercent() or (1 - owner.components.sanity:GetPercent())
			local damage_mult = level*.1 + (1 - level * .1) * sanity_mult
			if owner.components.sanity:IsInsanityMode() or level>0 then
				dmg = math.max(TUNING_MEDAL.SANITYROCK_MACE_MAX_DAMAGE * damage_mult,TUNING_MEDAL.SANITYROCK_MACE_MIN_DAMAGE)
			else
				dmg = TUNING_MEDAL.SANITYROCK_MACE_MOON_DAMAGE
			end

			if level>0 and inst.components.medal_chaosdamage then
				inst.components.medal_chaosdamage:SetBaseDamage(17*.5*(level + 1)*damage_mult)
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
			if owner and owner.components.sanity then
				local sanity_loss = TUNING_MEDAL.SANITYROCK_MACE_SANITYLOSS or 2--san值消耗
				if HasOriginMedal(owner,"has_shadowmagic_medal") then--本源减耗
					sanity_loss = sanity_loss * TUNING_MEDAL.SANITYROCK_MACE_SANITYLOSS_ORIGIN_MULT
				end
				if owner.components.sanity:IsInsanityMode() then
					--玩家san值满足扣除条件
					if owner.components.sanity.current>= sanity_loss then
						owner.components.sanity:DoDelta(-sanity_loss)
						inst.components.finiteuses:Repair(TUNING_MEDAL.SANITYROCK_MACE_ADDUSES)--恢复耐久
					end
				elseif inst:HasTag("isimmortal") then
					if owner.components.sanity.max - owner.components.sanity.current >= sanity_loss then
						owner.components.sanity:DoDelta(sanity_loss)
						inst.components.finiteuses:Repair(TUNING_MEDAL.SANITYROCK_MACE_ADDUSES)--恢复耐久
					end
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

--添加不朽之力
local function onimmortal(inst,level,isadd)
    local owner = inst.components.inventoryitem and inst.components.inventoryitem:GetGrandOwner()
	if owner then
		UpdateDamage(inst,owner)
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

	inst:AddTag("shadowlevel")--暗影装备加成等级

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
    inst.components.weapon:SetDamage(TUNING_MEDAL.SANITYROCK_MACE_MIN_DAMAGE)
    inst.components.weapon:SetOnAttack(UpdateDamage)

	inst:AddComponent("medal_chaosdamage")--混沌伤害
	
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

	inst:AddComponent("shadowlevel")--暗影装备加成等级
	inst.components.shadowlevel:SetDefaultLevel(TUNING_MEDAL.SANITYROCK_MACE_SHADOW_LEVEL)
	
	inst:AddComponent("medal_immortal")--不朽组件
    inst.components.medal_immortal:SetMaxLevel(5)
    inst.components.medal_immortal:SetOnImmortal(onimmortal)

	inst:AddComponent("medal_skinable")

    return inst
end

return Prefab("sanityrock_mace", fn, assets)