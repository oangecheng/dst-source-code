local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "ndnr_lucky_goldnugget", "ndnr_lucky_goldnugget")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    if owner.components.combat ~= nil then
        owner.components.combat:SetAttackPeriod(TUNING.WILSON_ATTACK_PERIOD*2)
    end
end

local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    if owner.components.combat ~= nil then
        owner.components.combat:SetAttackPeriod(TUNING.WILSON_ATTACK_PERIOD)
    end
end

local function onhit(inst, attacker, target)
    local impactfx = SpawnPrefab("impact")
    if impactfx ~= nil and target.components.combat then
        local follower = impactfx.entity:AddFollower()
        follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0)
        if attacker ~= nil and attacker:IsValid() then
            impactfx:FacePoint(attacker.Transform:GetWorldPosition())
        end
    end
    inst:Remove()
end

local function onthrown(inst, data)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.components.inventoryitem.pushlandedevents = false
end

AddPrefabPostInit("lucky_goldnugget", function(inst)

    if not TheWorld.ismastersim then return inst end

    if inst.components.weapon == nil then
        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(100)
        inst.components.weapon:SetRange(8, 10)
    end

    if inst.components.projectile == nil then
        inst:AddComponent("projectile")
        inst.components.projectile:SetSpeed(30)
        inst.components.projectile:SetOnHitFn(onhit)
        inst:ListenForEvent("onthrown", onthrown)
    end

    if inst.components.equippable == nil then
        inst:AddComponent("equippable")
        inst.components.equippable:SetOnEquip(OnEquip)
        inst.components.equippable:SetOnUnequip(OnUnequip)
        inst.components.equippable.equipstack = true
    end

end)