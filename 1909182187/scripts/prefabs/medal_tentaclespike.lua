local assets =
{
    -- Asset("ANIM", "anim/tentacle_spike.zip"),
    -- Asset("ANIM", "anim/swap_spike.zip"),
	Asset("ANIM", "anim/whip.zip"),
    Asset("ANIM", "anim/swap_whip.zip"),
    Asset("ANIM", "anim/medal_tentaclespike.zip"),
    Asset("ANIM", "anim/floating_items.zip"),
    Asset("ATLAS", "images/medal_tentaclespike.xml"),
	Asset("ATLAS_BUILD", "images/medal_tentaclespike.xml",256),
}
--变更攻击距离
local function changeAttackRange(inst,owner)
    local medal = owner and owner.components.inventory and owner.components.inventory:EquipMedalWithgroupTag("tentacle_certificate")
    if medal and medal.medal_level and medal.medal_level>0 then
        inst.components.weapon:SetRange(TUNING_MEDAL.MEDAL_TENTACLESPIKE.ACCTACK_RANGE+medal.medal_level*TUNING_MEDAL.MEDAL_TENTACLESPIKE.ADD_ACCTACK_RANGE)
    else
        inst.components.weapon:SetRange(TUNING_MEDAL.MEDAL_TENTACLESPIKE.ACCTACK_RANGE)
    end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "medal_tentaclespike", "swap_medal_tentaclespike")
	
	-- owner.AnimState:OverrideSymbol("swap_object", "swap_whip", "swap_whip")
	owner.AnimState:OverrideSymbol("whipline", "swap_whip", "whipline")
	
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    changeAttackRange(inst,owner)
    inst.changeAttackRange = function()
        changeAttackRange(inst,owner)
    end
    inst:ListenForEvent("changetentaclemedal", inst.changeAttackRange, owner)
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    inst.components.weapon:SetRange(TUNING_MEDAL.MEDAL_TENTACLESPIKE.ACCTACK_RANGE)
    inst:RemoveEventCallback("changetentaclemedal", inst.changeAttackRange, owner)
end

local function onattack(inst, attacker, target)
	if target ~= nil and target:IsValid() then
		local snap = SpawnPrefab("impact")

		local x, y, z = inst.Transform:GetWorldPosition()
		local x1, y1, z1 = target.Transform:GetWorldPosition()
		local angle = -math.atan2(z1 - z, x1 - x)
		snap.Transform:SetPosition(x1, y1, z1)
		snap.Transform:SetRotation(angle * RADIANS)
		
		if target.SoundEmitter ~= nil then
			target.SoundEmitter:PlaySound("dontstarve/common/whip_small")
		end
	end
end

local function onsavefn(inst,data)
	if inst.components.finiteuses and inst.components.finiteuses:GetUses()==TUNING_MEDAL.MEDAL_TENTACLESPIKE.MAXUSES then
		data.uses=inst.components.finiteuses:GetUses()
	end
end

local function onloadfn(inst,data)
	if data~=nil and data.uses then
		inst.components.finiteuses:SetUses(data.uses)
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("medal_tentaclespike")
    inst.AnimState:SetBuild("medal_tentaclespike")
    inst.AnimState:PlayAnimation("medal_tentaclespike")

    inst:AddTag("sharp")
	inst:AddTag("whip")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryPhysics(inst)

    -- local swap_data = {sym_build = "medal_tentaclespike", bank = "medal_tentaclespike"}
	local swap_data =
	{
		sym_build = "medal_tentaclespike",
		sym_name = "swap_medal_tentaclespike",
		bank = "medal_tentaclespike",
		anim = "medal_tentaclespike"
	}
    MakeInventoryFloatable(inst, "med", 0.05, {0.9, 0.5, 0.9}, true, -17, swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.SPIKE_DAMAGE)
    inst.components.weapon:SetRange(TUNING_MEDAL.MEDAL_TENTACLESPIKE.ACCTACK_RANGE)
	inst.components.weapon:SetOnAttack(onattack)

    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING_MEDAL.MEDAL_TENTACLESPIKE.MAXUSES)
    inst.components.finiteuses:SetUses(TUNING_MEDAL.MEDAL_TENTACLESPIKE.USES)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "medal_tentaclespike"
    inst.components.inventoryitem.atlasname = "images/medal_tentaclespike.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)
	
	inst.OnSave = onsavefn
	inst.OnLoad = onloadfn

    return inst
end

return Prefab("medal_tentaclespike", fn, assets)
