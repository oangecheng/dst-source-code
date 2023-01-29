--[[
    降雨
    TheWorld:PushEvent("ms_forceprecipitation", true)
    停止降雨
    TheWorld:PushEvent("ms_forceprecipitation", false)
    闪电
    TheWorld:PushEvent("ms_sendlightningstrike", Vector3(%s.Transform:GetWorldPosition()))
--]] local assets = {
    Asset("ANIM", "anim/weatherpole.zip"),
    Asset("ANIM", "anim/swap_weatherpole.zip"),
    Asset("IMAGE", "images/ndnr_blueweatherpole.tex"),
    Asset("ATLAS", "images/ndnr_blueweatherpole.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_blueweatherpole.xml", 256),
    Asset("IMAGE", "images/ndnr_redweatherpole.tex"),
    Asset("ATLAS", "images/ndnr_redweatherpole.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_redweatherpole.xml", 256),
    Asset("IMAGE", "images/ndnr_purpleweatherpole.tex"),
    Asset("ATLAS", "images/ndnr_purpleweatherpole.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_purpleweatherpole.xml", 256),
}

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    if inst.prefab == "ndnr_purpleweatherpole" then
        if inst._vfx_fx_inst ~= nil then
            inst._vfx_fx_inst:Remove()
            inst._vfx_fx_inst = nil
        end
    end
end

local function summonthunder(inst, target, pos)
    local caster = inst.components.inventoryitem.owner
    if caster then
        if caster.components.staffsanity then
            caster.components.staffsanity:DoCastingDelta(-TUNING.SANITY_MED)
        elseif caster.components.sanity ~= nil then
            caster.components.sanity:DoDelta(-TUNING.SANITY_MED)
        end

        local pt = caster:GetPosition()
        local num_lightnings = 16
        caster:StartThread(function()
            for k = 0, num_lightnings do
                local rad = math.random(3, 15)
                local angle = k * 4 * PI / num_lightnings
                local pos = pt + Vector3(rad * math.cos(angle), 0, rad * math.sin(angle))
                TheWorld:PushEvent("ms_sendlightningstrike", pos)
                Sleep(.3 + math.random() * .2)
            end
        end)
    end

    inst.components.finiteuses:Use(1)
end

local function summonrain(inst, target, pos)
    TheWorld:PushEvent("ms_forceprecipitation", not (TheWorld.state.israining or TheWorld.state.issnowing))

    local caster = inst.components.inventoryitem.owner
    if caster then
        if caster.components.staffsanity then
            caster.components.staffsanity:DoCastingDelta(-TUNING.SANITY_MED)
        elseif caster.components.sanity ~= nil then
            caster.components.sanity:DoDelta(-TUNING.SANITY_MED)
        end
    end

    inst.components.finiteuses:Use(1)
end

local function onblink(staff, pos, caster)
    if caster then
        if caster.components.staffsanity then
            caster.components.staffsanity:DoCastingDelta(-TUNING.SANITY_MED)
        elseif caster.components.sanity ~= nil then
            caster.components.sanity:DoDelta(-TUNING.SANITY_MED)
        end
    end

    staff.components.finiteuses:Use(1)
end

local function blinkstaff_reticuletargetfn(self)
end

local onfinished = function(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")

    local caster = inst.components.inventoryitem.owner
    if caster then
        local ndnr_weatherpole = SpawnPrefab("ndnr_weatherpole")
        caster.components.inventory:GiveItem(ndnr_weatherpole)
    end

    inst:Remove()
end

local function common_fn(colour, maxuses, uses)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("weatherpole")
    inst.AnimState:SetBank("weatherpole")
    inst.AnimState:PlayAnimation(colour)

    MakeInventoryFloatable(inst)

    inst:AddTag("nopunch")

    inst.entity:SetPristine()
    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    inst:AddComponent("inspectable")

    -- inst:AddComponent("weapon")
    -- inst.components.weapon:SetDamage(TUNING.CANE_DAMAGE)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable:SetOnEquip(function(inst, owner)
        inst._owner = owner
        owner.AnimState:OverrideSymbol("swap_object", "swap_weatherpole", "swap_" .. colour .. "weatherpole")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")

        if colour == "purple" then
            inst._vfx_fx_inst = SpawnPrefab("cane_victorian_fx")
            inst._vfx_fx_inst.entity:AddFollower()
            inst._vfx_fx_inst.entity:SetParent(inst.entity)
            inst._vfx_fx_inst.Follower:FollowSymbol(owner.GUID, "swap_object", 0, -105, 0)
        end
    end)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(maxuses)
    inst.components.finiteuses:SetUses(uses)
    inst.components.finiteuses:SetOnFinished(onfinished)

    MakeHauntableLaunch(inst)

    return inst
end

-- 制造功能天候棒
local function purple()
    local inst = common_fn("purple", TUNING.ORANGESTAFF_USES, TUNING.ORANGESTAFF_USES)

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_purpleweatherpole.xml"

    inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT

    inst:AddComponent("reticule")
    inst.components.reticule.targetfn = blinkstaff_reticuletargetfn
    inst.components.reticule.ease = true

    inst:AddComponent("blinkstaff")
    inst.components.blinkstaff:SetFX("sand_puff_large_front", "sand_puff_large_back")
    inst.components.blinkstaff.onblinkfn = onblink

    return inst
end

local function blue()
    local inst = common_fn("blue", 1, 1)

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_blueweatherpole.xml"

    inst:AddComponent("spellcaster")
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster:SetSpellFn(summonrain)

    return inst
end

local function red()
    local inst = common_fn("red", 1, 1)

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_redweatherpole.xml"

    inst:AddComponent("spellcaster")
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster:SetSpellFn(summonthunder)

    return inst
end

return Prefab("ndnr_purpleweatherpole", purple, assets),
    Prefab("ndnr_redweatherpole", red, assets),
    Prefab("ndnr_blueweatherpole", blue, assets)
