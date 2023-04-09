local assets = {
    Asset("ANIM", "anim/fimbul_axe.zip"),
    Asset("ATLAS", "images/inventoryimages/fimbul_axe.xml"),
    Asset("IMAGE", "images/inventoryimages/fimbul_axe.tex"),
    Asset("ANIM", "anim/boomerang.zip"), --官方回旋镖动画模板
}

local prefabs = {
    "fimbul_lightning",
    "fimbul_cracklebase_fx",
}

local isPVP = false

local function OnFinished(inst)
    inst.AnimState:PlayAnimation("used")
    inst:ListenForEvent("animover", inst.Remove)

    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.fn_onThrownEnd ~= nil then
        skindata.fn_onThrownEnd(inst)
    end

    if inst.returntask ~= nil then
        inst.returntask:Cancel()
        inst.returntask = nil
    end
end

local function OnEquip(inst, owner)
    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.equip ~= nil then
        owner.AnimState:OverrideSymbol("swap_object", skindata.equip.build, skindata.equip.file)
    else
        owner.AnimState:OverrideSymbol("swap_object", "fimbul_axe", "swap_base")
    end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function OnDropped(inst)
    inst.AnimState:PlayAnimation("idle")
    inst.components.inventoryitem.pushlandedevents = true
    inst.components.inventoryitem.canbepickedup = true
    inst:PushEvent("on_landed")

    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.fn_onThrownEnd ~= nil then
        skindata.fn_onThrownEnd(inst)
    end
end

local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function OnThrown(inst, owner, target)
    if owner and owner.SoundEmitter ~= nil then
        owner.SoundEmitter:PlaySound("dontstarve/wilson/boomerang_throw")
    end
    inst.AnimState:PlayAnimation("spin_loop", true)
    inst.components.inventoryitem.pushlandedevents = false
    inst.components.inventoryitem.canbepickedup = false

    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.fn_onThrown ~= nil then
        skindata.fn_onThrown(inst, owner, target)
    end
end

local function ReturnToOwner(inst, owner)
    if owner ~= nil and owner:IsValid() then
        -- owner.SoundEmitter:PlaySound("dontstarve/wilson/boomerang_return")
        -- inst.components.projectile:Throw(owner, owner)

        if not (owner.components.health ~= nil and owner.components.health:IsDead()) then --玩家还活着，自动接住
            local skindata = inst.components.skinedlegion:GetSkinedData()
            if skindata ~= nil and skindata.fn_onThrownEnd ~= nil then
                skindata.fn_onThrownEnd(inst)
            end
            inst.components.inventoryitem.canbepickedup = true

            --如果使用者已装备手持武器，就放进物品栏，没有的话就直接装备上
            if not owner.components.inventory:GetEquippedItem(inst.components.equippable.equipslot) then
                owner.components.inventory:Equip(inst)
            else
                owner.components.inventory:GiveItem(inst)
            end
            return
        end
    end
    OnDropped(inst)
end
local function DelayReturnToOwner(inst, owner)
    -- inst:Hide()
    inst.returntask = inst:DoTaskInTime(1, function()
        -- inst:Show()
        ReturnToOwner(inst, owner)
        inst.returntask = nil
    end)
end

local function GiveSomeShock(inst, owner, target)  --击中时的特殊效果
    local x, y, z = target.Transform:GetWorldPosition()
    local givelightning = false

    local ents = TheSim:FindEntities(x, y, z, 3, nil, {"playerghost", "INLIMBO"}, {"shockable", "CHOP_workable"})
    for k, v in pairs(ents) do
        if v ~= owner then
            if v.components.workable ~= nil and v.components.workable:CanBeWorked() then --直接破坏可以砍的物体
                v.components.workable:Destroy(inst)
            elseif v.components.shockable ~= nil and math.random() < 0.3 then --有几率对生物造成触电
                givelightning = true

                if isPVP or not v:HasTag("player") then --只要是pvp模式就直接生效，若不是则只让非玩家生物触电
                    v.components.shockable:Shock(6)
                end
            end
        end
    end

    if givelightning then
        local skindata = inst.components.skinedlegion:GetSkinedData()
        if skindata ~= nil and skindata.fn_onLightning ~= nil then
            skindata.fn_onLightning(inst, owner, target)
            return
        end

        if not TheWorld:HasTag("cave") then
            local lightning = SpawnPrefab("fimbul_lightning")
            lightning.Transform:SetPosition(x, y, z)
        end

        local cracklebase = SpawnPrefab("fimbul_cracklebase_fx")
        cracklebase.Transform:SetPosition(x, y, z)
    end
end

local function OnHit(inst, owner, target)
    GiveSomeShock(inst, owner, target)
    DelayReturnToOwner(inst, owner)
end
local function OnMiss(inst, owner, target)
    if owner == target then
        OnDropped(inst)
    else
        DelayReturnToOwner(inst, owner)
    end
end

local function OnLightning(inst)    --因为拿在手上会有"INLIMBO"标签，所以装备时并不会吸引闪电，只有放在地上时才会
    GiveSomeShock(inst, nil, inst)

    if inst.components.finiteuses ~= nil and inst.components.finiteuses:GetUses() < 250 then
        local uses = inst.components.finiteuses:GetUses() + 10

        if uses > 250 then uses = 250 end
        inst.components.finiteuses:SetUses(uses)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank("boomerang")
    inst.AnimState:SetBuild("fimbul_axe")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetRayTestOnBB(true)

    inst:AddTag("thrown")
    inst:AddTag("lightningrod") --避雷针标签，会吸引闪电

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    --projectile (from projectile component) added to pristine state for optimization
    inst:AddTag("projectile")

    -- MakeInventoryFloatable(inst, "med", 0.1, {1.3, 0.6, 1.3}, true, -9, {
    --     sym_build = "swap_fimbul_axe",
    --     sym_name = "swap_fimbul_axe",
    --     bank = "fimbul_axe",
    --     anim = "idle"
    -- })
    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("fimbul_axe")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.returntask = nil

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(22.5)    --22.5伤害, 由于带电武器自带1.5倍攻击加成，所以实际攻击力为22.5x1.5=33.75
    inst.components.weapon:SetRange(TUNING.BOOMERANG_DISTANCE, TUNING.BOOMERANG_DISTANCE + 2)
    inst.components.weapon:SetElectric()    --设置为带电的武器

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(250)
    inst.components.finiteuses:SetUses(250)
    inst.components.finiteuses:SetOnFinished(OnFinished)

    inst:AddComponent("inspectable")

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(15)
    --inst.components.projectile:SetCanCatch(true)      --默认，不能被主动抓住
    inst.components.projectile:SetOnThrownFn(OnThrown)  --扔出时
    inst.components.projectile:SetOnHitFn(OnHit)        --敌方或者自己被击中时
    inst.components.projectile:SetOnMissFn(OnMiss)      --丢失目标时？
    --inst.components.projectile:SetOnCaughtFn(OnCaught)--被抓住时

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "fimbul_axe"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fimbul_axe.xml"
    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst:ListenForEvent("lightningstrike", OnLightning)

    MakeHauntableLaunch(inst)

    if TheNet:GetPVPEnabled() then
        isPVP = true
    end

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

return Prefab("fimbul_axe", fn, assets, prefabs)
