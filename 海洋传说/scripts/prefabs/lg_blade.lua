local assets =
{
    Asset("ANIM", "anim/lg_blade.zip"),
    Asset("ANIM", "anim/swap_lg_blade.zip"),
    Asset("ANIM", "anim/lg_blade_fx.zip"),
    Asset("ATLAS", "images/inventoryimages/lg_blade.xml"),
    Asset("IMAGE", "images/inventoryimages/lg_blade.tex"),
}

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_lg_blade", inst.GUID, "swap_lg_blade")
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_lg_blade", "swap_lg_blade")
    end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function percentchanged(inst,data)
    if data and data.percent then
        if data.percent >= 1 then
            inst:RemoveTag("repairable_lg")
        else
            inst:AddTag("repairable_lg")
        end
    end
end

local function onattack(inst, owner, target)
    if target ~= nil  and target:IsValid() then
        local fx = SpawnPrefab("lg_blade_fx")
        if fx ~= nil then
            fx.Transform:SetPosition(target.Transform:GetWorldPosition())
            --fx.entity:SetParent(target.entity)
            --fx.entity:AddFollower():FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0)
        end
    end
end

local function onraining(inst)
    if TheWorld.state.israining then
        inst.components.equippable.walkspeedmult = 1.1
    else
        inst.components.equippable.walkspeedmult = nil
    end
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("lg_blade")
    inst.AnimState:SetBuild("lg_blade")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("weapon")

    local swap_data = {sym_build = "swap_lg_blade"}
    MakeInventoryFloatable(inst, "med", 0.05, {0.85, 0.45, 0.85}, true, 1, swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(54)
    inst.components.weapon.onattack = onattack
    inst.components.weapon.GetDamage = function(self,...)
        if TheWorld.state.israining then
            local chance = math.random()
            if chance > 0.82 then
                return 2*self.damage
            elseif chance > 0.77 then
                return 3*self.damage
            end
        end
        return self.damage
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(250)
    inst.components.finiteuses:SetUses(250)
	inst.components.finiteuses.repairnum = -40
    inst.components.finiteuses:SetOnFinished(inst.Remove)
	local old_SetUses = inst.components.finiteuses.SetUses
	inst.components.finiteuses.SetUses =function(self,val)
		if val > self.total then
			val = self.total
		end	
		old_SetUses(self,val)
	end
    inst:ListenForEvent("percentusedchange", percentchanged)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/lg_blade.xml"

    inst:AddComponent("equippable")

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:WatchWorldState("israining", onraining)
    onraining(inst)
    MakeHauntableLaunch(inst)

    return inst
end

local function fxfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.AnimState:SetBank("lg_blade_fx")
    inst.AnimState:SetBuild("lg_blade_fx")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetFinalOffset(3)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

return Prefab("lg_blade", fn, assets),
    Prefab("lg_blade_fx", fxfn)