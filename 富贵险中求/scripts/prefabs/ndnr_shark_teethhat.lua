local assets = {
    Asset("ANIM", "anim/hat_ndnr_shark_teeth.zip"),
    Asset("IMAGE", "images/ndnr_shark_teethhat.tex"),
    Asset("ATLAS", "images/ndnr_shark_teethhat.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_shark_teethhat.xml", 256),
}

local function shark_teeth_disable(inst)
    if inst.updatetask then
        inst.updatetask:Cancel()
        inst.updatetask = nil
    end
    local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
    if owner and owner.components.leader then
        owner:RemoveTag("warg")
        owner:RemoveTag("houndfriend")

        for k,v in pairs(owner.components.leader.followers) do
            if k:HasTag("hound") and k.components.combat then
                k.components.combat:SuggestTarget(owner)
            end
        end
        owner.components.leader:RemoveFollowersByTag("hound")
    end
end

local function shark_teeth_update(inst)
    local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
    if owner and owner.components.leader then
        owner.components.leader:RemoveFollowersByTag("pig")
        local x,y,z = owner.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x,y,z, TUNING.SPIDERHAT_RANGE, {"hound"})
        for k,v in pairs(ents) do
            if v.components.follower and not v.components.follower.leader and not owner.components.leader:IsFollower(v) and owner.components.leader.numfollowers < 8 then
                owner.components.leader:AddFollower(v)
            end
        end
    end
end

local function shark_teeth_enable(inst)
    local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
    if owner and owner.components.leader then
        owner.components.leader:RemoveFollowersByTag("pig")
        owner:AddTag("warg")
        owner:AddTag("houndfriend")
    end
    inst.updatetask = inst:DoPeriodicTask(0.5, shark_teeth_update, 1)
end

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_hat", skin_build, "swap_hat", inst.GUID, "hat_ndnr_shark_teeth")
    else
        owner.AnimState:OverrideSymbol("swap_hat", "hat_ndnr_shark_teeth", "swap_hat")
    end
    owner.AnimState:Show("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    owner.AnimState:Show("HEAD")
    owner.AnimState:Hide("HEAD_HAT")

    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end

    shark_teeth_enable(inst)
end

local function onunequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end

    owner.AnimState:ClearOverrideSymbol("swap_hat")
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
    end

    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end

    shark_teeth_disable(inst)
end

local function shark_teeth_perish(inst)
    shark_teeth_disable(inst)
    inst:Remove()--generic_perish(inst)
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBuild("hat_ndnr_shark_teeth")
    inst.AnimState:SetBank("ndnr_shark_teethhat")
    inst.AnimState:PlayAnimation("anim")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst:AddTag("hat")
    inst:AddTag("waterproofer")

    inst.entity:SetPristine()
    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    inst:AddComponent("inspectable")
    inst:AddComponent("tradable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_shark_teethhat.xml"

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.TOTAL_DAY_TIME * 9)
    inst.components.fueled:SetDepletedFn(shark_teeth_perish)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )

    MakeHauntableLaunch(inst)

    return inst
end
return Prefab("ndnr_shark_teethhat", fn, assets)
