local assets =
{
    Asset("ANIM", "anim/lg_king_mace.zip"),
    Asset("ANIM", "anim/swap_lg_king_mace.zip"),
    Asset("ANIM", "anim/lg_king_mace_fx.zip"),
    Asset("ATLAS", "images/inventoryimages/lg_king_mace.xml"),
    Asset("IMAGE", "images/inventoryimages/lg_king_mace.tex")
}
local TRAIL_FLAGS = { "shadowtrail" }
local function cane_do_trail(inst)
    local owner = inst.components.inventoryitem:GetGrandOwner() or inst
    if not owner.entity:IsVisible() then
        return
    end

    local x, y, z = owner.Transform:GetWorldPosition()
    if owner.sg ~= nil and owner.sg:HasStateTag("moving") then
        local theta = -owner.Transform:GetRotation() * DEGREES
        local speed = owner.components.locomotor:GetRunSpeed() * .1
        x = x + speed * math.cos(theta)
        z = z + speed * math.sin(theta)
    end
    local mounted = owner.components.rider ~= nil and owner.components.rider:IsRiding()
    local map = TheWorld.Map
    local offset = FindValidPositionByFan(
        math.random() * 2 * PI,
        (mounted and 1 or .5) + math.random() * .5,
        4,
        function(offset)
            local pt = Vector3(x + offset.x, 0, z + offset.z)
            return map:IsPassableAtPoint(pt:Get())
                and not map:IsPointNearHole(pt)
                and #TheSim:FindEntities(pt.x, 0, pt.z, .7, TRAIL_FLAGS) <= 0
        end
    )

    if offset ~= nil then
        SpawnPrefab(inst.trail_fx).Transform:SetPosition(x + offset.x, 0, z + offset.z)
    end
end

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_lg_king_mace", inst.GUID, "swap_lg_king_mace")
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_lg_king_mace", "swap_lg_king_mace")
    end
    if inst._light == nil or not inst._light:IsValid() then
        inst._light = SpawnPrefab("lg_king_macelight")
    end
    if owner ~= nil then
        inst._light.entity:SetParent(owner.entity)
    end
    if inst.trail_fx ~= nil and inst._trailtask == nil then
        inst._trailtask = inst:DoPeriodicTask(6 * FRAMES, cane_do_trail, 2 * FRAMES)
    end
    if owner.components.sanity then
        owner.components.sanity.neg_aura_modifiers:SetModifier(inst, 0)
    end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
    if inst._light ~= nil then
        if inst._light:IsValid() then
            inst._light:Remove()
        end
        inst._light = nil
    end
    if inst._trailtask ~= nil then
        inst._trailtask:Cancel()
        inst._trailtask = nil
    end
    if owner.components.sanity ~= nil then
        owner.components.sanity.neg_aura_modifiers:RemoveModifier(inst)
    end
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("lg_king_mace")
    inst.AnimState:SetBuild("lg_king_mace")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("weapon")

    local swap_data = {sym_build = "swap_lg_king_mace"}
    MakeInventoryFloatable(inst, "med", 0.05, {0.85, 0.45, 0.85}, true, 1, swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.trail_fx = "lg_king_mace_fx"
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.CANE_DAMAGE)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/lg_king_mace.xml"

    inst:AddComponent("equippable")

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT

    MakeHauntableLaunch(inst)

    return inst
end

local function lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetRadius(1.0)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(235 / 255, 165 / 255, 12 / 255)
    inst.Light:Enable(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end


local NUM_VARIATIONS = 3
local MIN_SCALE = 1
local MAX_SCALE = 1.8

local function PlayShadowAnim(proxy, anim, scale, flip)
    local inst = CreateEntity()

    inst:AddTag("FX")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.Transform:SetFromProxy(proxy.GUID)

    inst.AnimState:SetBank("cane_shadow_fx")
    inst.AnimState:SetBuild("lg_king_mace_fx")
    inst.AnimState:SetScale(flip and -scale or scale, scale)
    inst.AnimState:SetMultColour(1, 1, 1, .5)
    inst.AnimState:PlayAnimation(anim)

    inst:ListenForEvent("animover", inst.Remove)
end

local function OnRandDirty(inst)
    if inst._complete or inst._rand:value() <= 0 then
        return
    end

    --Delay one frame in case we are about to be removed
    local flip = inst._rand:value() > 31
    local scale = MIN_SCALE + (MAX_SCALE - MIN_SCALE) * (flip and inst._rand:value() - 32 or inst._rand:value() - 1) / 30
    inst:DoTaskInTime(0, PlayShadowAnim, "shad"..inst.variation, scale, flip)
end

local function DisableNetwork(inst)
    inst.Network:SetClassifiedTarget(inst)
end

local function MakeShadowFX(name, num, prefabs)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddNetwork()

        inst:AddTag("FX")
        inst:AddTag("shadowtrail")

        inst.variation = tostring(num or math.random(NUM_VARIATIONS))

        inst._rand = net_smallbyte(inst.GUID, "lg_king_mace._rand", "randdirty")

        --Dedicated server does not need to spawn the local fx
        if not TheNet:IsDedicated() then
            inst._complete = false
            inst:ListenForEvent("randdirty", OnRandDirty)
        end

        if num == nil then
            inst:SetPrefabName(name..inst.variation)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false
        inst:DoTaskInTime(.5, DisableNetwork)
        inst:DoTaskInTime(1.5, inst.Remove)

        inst._rand:set(math.random(62))

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

local ret = {}
local prefs = {}
for i = 1, NUM_VARIATIONS do
    local name = "lg_king_mace_fx"..tostring(i)
    table.insert(prefs, name)
    table.insert(ret, MakeShadowFX(name, i))
end
table.insert(ret, MakeShadowFX("lg_king_mace_fx", nil, prefs))
prefs = nil

return Prefab("lg_king_mace", fn, assets),
    Prefab("lg_king_macelight", lightfn),
    unpack(ret)
