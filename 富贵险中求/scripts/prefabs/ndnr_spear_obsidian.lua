local assets = {
    Asset("ANIM", "anim/spear_obsidian.zip"),
    Asset("ANIM", "anim/swap_spear_obsidian.zip"),
    Asset("IMAGE", "images/ndnr_spear_obsidian.tex"),
    Asset("ATLAS", "images/ndnr_spear_obsidian.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_spear_obsidian.xml", 256),
}

local function isOnWater(inst)
    return not inst:GetCurrentPlatform() and not TheWorld.Map:IsVisualGroundAtPoint(inst.Transform:GetWorldPosition())
end

local function onfinished(inst)
    inst:Remove()
end

local function onequipobsidian(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_spear_obsidian", "swap_spear")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if inst.components.ndnr_obsidiantool then
        inst.components.ndnr_obsidiantool.owner = owner
    end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    if inst.components.ndnr_obsidiantool then
        inst.components.ndnr_obsidiantool.owner = nil
    end
end

local function GetObsidianHeat(inst, observer)
    local charge, maxcharge = inst.components.ndnr_obsidiantool:GetCharge()
    local heat = Lerp(0, TUNING.NDNR_OBSIDIAN_TOOL_MAXHEAT, charge/maxcharge)
    return heat
end

local function ChangeObsidianLight(inst, old, new)
    local percentage = new/inst.components.ndnr_obsidiantool.maxcharge
    local rad = Lerp(1, 2.5, percentage)

    if percentage >= inst.components.ndnr_obsidiantool.red_threshold then
        inst.Light:Enable(true)
        inst.Light:SetColour(254/255,98/255,75/255)
        inst.Light:SetRadius(rad)
    elseif percentage >= inst.components.ndnr_obsidiantool.orange_threshold then
        inst.Light:Enable(true)
        inst.Light:SetColour(255/255,159/255,102/255)
        inst.Light:SetRadius(rad)
    elseif percentage >= inst.components.ndnr_obsidiantool.yellow_threshold then
        inst.Light:Enable(true)
        inst.Light:SetColour(255/255,223/255,125/255)
        inst.Light:SetRadius(rad)
    else
        inst.Light:Enable(false)
    end
end

local function ManageObsidianLight(inst)
    local cur, max = inst.components.ndnr_obsidiantool:GetCharge()
    if cur/max >= inst.components.ndnr_obsidiantool.yellow_threshold then
        inst.Light:Enable(true)
    else
        inst.Light:Enable(false)
    end

    if isOnWater(inst) and inst.components.ndnr_obsidiantool then
        inst.components.ndnr_obsidiantool:SetCharge(0)
    end
end

local function ObsidianToolAttack(inst, attacker, target)
    --deal bonus damage to the target based on the original damage of the spear.
    local charge, maxcharge = inst.components.ndnr_obsidiantool:GetCharge()

    --light target on fire if at maximum heat.
    if charge == maxcharge then
        if target.components.burnable then
            target.components.burnable:Ignite()
        end
    end

    inst.components.ndnr_obsidiantool:Use(attacker, target)
end

local function UpdateDamage(inst, data)
    local charge = data.new
    local maxcharge = data.max
    local damage_mod = Lerp(0, 1, charge/maxcharge) --Deal up to double damage based on charge.
    inst.components.weapon:SetDamage((1+damage_mod)*TUNING.NDNR_OBSIDIAN_SPEAR_DAMAGE)
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(0.75)
    inst.Light:Enable(false)

    inst.AnimState:SetBuild("spear_obsidian")
    inst.AnimState:SetBank("spear_obsidian")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("spear")
    inst:AddTag("sharp")
    inst:AddTag("canrepairbyndnr_obsidian")

    inst.entity:SetPristine()

    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_spear_obsidian.xml"

    inst:AddComponent("ndnr_obsidiantool")
    inst.components.ndnr_obsidiantool.tool_type = "spear"
    inst.components.ndnr_obsidiantool.onchargedelta = ChangeObsidianLight
    inst.components.ndnr_obsidiantool.maxcharge = TUNING.NDNR_OBSIDIAN_WEAPON_MAXCHARGES
    inst.components.ndnr_obsidiantool.cooldowntime = TUNING.TOTAL_DAY_TIME / TUNING.NDNR_OBSIDIAN_WEAPON_MAXCHARGES

    inst:AddComponent("heater")
    inst.components.heater.heatfn = GetObsidianHeat
    inst.components.heater.carriedheatfn = GetObsidianHeat
    inst.components.heater:SetThermics(true, false)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.NDNR_OBSIDIAN_SPEAR_DAMAGE)
    inst.components.weapon.attackwear = 1 / TUNING.NDNR_OBSIDIANTOOLFACTOR
    inst.components.weapon:SetOnAttack(ObsidianToolAttack)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.SPEAR_USES)
    inst.components.finiteuses:SetUses(TUNING.SPEAR_USES)

    inst.components.finiteuses:SetOnFinished(onfinished)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequipobsidian)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:ListenForEvent("equipped", ManageObsidianLight)
    inst:ListenForEvent("onputininventory", ManageObsidianLight)
    inst:ListenForEvent("ondropped", ManageObsidianLight)
    inst:ListenForEvent("obsidian_charge_delta", UpdateDamage)

    return inst
end

return Prefab("ndnr_spear_obsidian", fn, assets, prefabs)
