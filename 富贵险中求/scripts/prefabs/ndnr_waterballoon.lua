local assets = {
    Asset("ANIM", "anim/ndnr_waterballoon.zip"),
    Asset("ANIM", "anim/swap_ndnr_waterballoon.zip"),
    Asset("IMAGE", "images/ndnr_waterballoon.tex"),
    Asset("ATLAS", "images/ndnr_waterballoon.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_waterballoon.xml", 256),
    Asset("SOUND", "sound/pengull.fsb"),
}

local NO_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO", "burnt" }

local function ReticuleTargetFn()
    local player = ThePlayer
    local ground = TheWorld.Map
    local pos = Vector3()
    --Attack range is 8, leave room for error
    --Min range was chosen to not hit yourself (2 is the hit range)
    for r = 6.5, 3.5, -.25 do
        pos.x, pos.y, pos.z = player.entity:LocalToWorldSpace(r, 0, 0)
        if ground:IsPassableAtPoint(pos:Get()) and not ground:IsGroundTargetBlocked(pos) then
            return pos
        end
    end
    return pos
end

local function onthrown(inst)
    inst:AddTag("NOCLICK")
    inst.persists = false

    inst.AnimState:PlayAnimation("spin_loop", true)

    inst.Physics:SetMass(1)
    inst.Physics:SetCapsule(0.2, 0.2)
    inst.Physics:SetFriction(0)
    inst.Physics:SetDamping(0)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.ITEMS)
end

local function OnHitWater(inst, attacker, target)
    local x,y,z = inst.Transform:GetWorldPosition()
    SpawnPrefab("waterballoon_splash").Transform:SetPosition(x,y,z)
    inst.components.wateryprotection:SpreadProtection(inst)
    inst:Remove()

    local ents = TheSim:FindEntities(x,y,z, 5, nil, NO_TAGS)
    if ents ~= nil then
        for k, v in pairs(ents) do
            local x1, y1, z1 = v.Transform:GetWorldPosition()
            if table.contains(TUNING.CANBESPROUTING_SEEDS, v.prefab) then
                local seed = v.prefab
                if string.find(v.prefab, "_seed") then
                    seed = string.sub(seed, 1, -6)
                end

                if TheWorld.Map:CanDeployPlantAtPoint(Vector3(x1, y1, z1), v) then
                    local count = 1
                    if v.components.stackable ~= nil then
                        count = v.components.stackable:StackSize()
                    end
                    for i = 1, count do
                        SpawnPrefab(seed.."_sapling").Transform:SetPosition(x1, y1, z1)
                    end
                    v.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
                    v:Remove()
                end
            end
            if v:HasTag("epic") and v.components.health ~= nil then
                local currenthealth = v.components.health.currenthealth
                local maxhealth = v.components.health.maxhealth
                v.components.health:DoDelta(maxhealth - currenthealth, nil, "ndnr_waterballoon")
            end
        end
    end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_ndnr_waterballoon", "swap_waterballoon")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

-- local function onuseaswatersource(inst)
--     if inst.components.stackable:IsStack() then
--         inst.components.stackable:Get():Remove()
--     else
--         inst:Remove()
--     end
-- end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("ndnr_waterballoon")
    inst.AnimState:SetBank("waterballoon")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "med", 0.05, 0.65)

    inst:AddTag("weapon")
    inst:AddTag("projectile")
    -- inst:AddTag("watersource")
    inst:AddTag("ndnr_waterballoon")

    inst.entity:SetPristine()

    inst:AddComponent("reticule")
    inst.components.reticule.targetfn = ReticuleTargetFn
    inst.components.reticule.ease = true
    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_waterballoon.xml"

    inst:AddComponent("locomotor")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(8, 10)

    inst:AddComponent("wateryprotection")
    inst.components.wateryprotection.extinguishheatpercent = TUNING.WATERBALLOON_EXTINGUISH_HEAT_PERCENT
    inst.components.wateryprotection.temperaturereduction = TUNING.WATERBALLOON_TEMP_REDUCTION
    inst.components.wateryprotection.witherprotectiontime = TUNING.WATERBALLOON_PROTECTION_TIME
    inst.components.wateryprotection.addwetness = TUNING.WATERBALLOON_ADD_WETNESS
    inst.components.wateryprotection:AddIgnoreTag("ndnr_waterballoon")

    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetHorizontalSpeed(15)
    inst.components.complexprojectile:SetGravity(-35)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(.25, 1, 0))
    inst.components.complexprojectile:SetOnLaunch(onthrown)
    inst.components.complexprojectile:SetOnHit(OnHitWater)

    inst:AddComponent("stackable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.equipstack = true

    -- inst:AddComponent("watersource")
    -- inst.components.watersource.onusefn = onuseaswatersource
    -- inst.components.watersource.override_fill_uses = 1

    MakeHauntableLaunch(inst)

    return inst
end
return Prefab("ndnr_waterballoon", fn, assets)
