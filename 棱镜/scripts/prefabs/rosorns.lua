local assets = {
    Asset("ANIM", "anim/rosorns.zip"),
    Asset("ANIM", "anim/swap_rosorns.zip"),
    Asset("ATLAS", "images/inventoryimages/rosorns.xml"),
    Asset("IMAGE", "images/inventoryimages/rosorns.tex"),
}

local function OnEquip(inst, owner)
    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.equip ~= nil then
        owner.AnimState:OverrideSymbol("swap_object", skindata.equip.build, skindata.equip.file)
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_rosorns", "swap_rosorns")
    end

    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if owner:HasTag("equipmentmodel") then --假人！
        return
    end

    --TIP: "onattackother"事件在 targ.components.combat:GetAttacked 之前，所以能提前改攻击配置
    owner:ListenForEvent("onattackother", UndefendedATK_legion)
end
local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    owner:RemoveEventCallback("onattackother", UndefendedATK_legion)
end

local function onattack(inst, owner, target)
    if target ~= nil and target:IsValid() then
        local skindata = inst.components.skinedlegion:GetSkinedData()
        if skindata ~= nil and skindata.fn_onAttack ~= nil then
            skindata.fn_onAttack(inst, owner, target)
        end
    end

    --[[
    if
        target ~= nil and target:IsValid()
        and not target:HasTag("alwaysblock")    --有了这个标签，什么天神都伤害不了
        and target.prefab ~= "laozi"        --无法伤害神话书说里的太上老君
        and target.components.combat ~= nil --档案馆的哨兵蜈蚣壳可能会没有战斗组件
        and target.components.health ~= nil and not target.components.health:IsDead() --已经死亡则不再攻击
    then
        --获取电击buff攻击加成
        local multiplier =
            owner.components.electricattacks ~= nil
            and not (
                    target:HasTag("electricdamageimmune") or
                    (target.components.inventory ~= nil and target.components.inventory:IsInsulated())
                )
            and TUNING.ELECTRIC_DAMAGE_MULT + TUNING.ELECTRIC_WET_DAMAGE_MULT * (target.components.moisture ~= nil and target.components.moisture:GetMoisturePercent() or (target:GetIsWet() and 1 or 0))
            or 1

        ------------------------------------

        --计算最终数值
        local self = owner.components.combat
        local pvpmultiplier = target:HasTag("player") and self.inst:HasTag("player") and self.pvp_damagemod or 1

        local resultDamage = 51
            * (self.damagemultiplier or 1)
            * self.externaldamagemultipliers:Get()
            * multiplier
            * pvpmultiplier
            * (self.customdamagemultfn ~= nil and self.customdamagemultfn(self.inst, target, inst, multiplier) or 1) --温蒂的加成
            + (self.damagebonus or 0)

        ------------------------------------

        local damageNum = resultDamage > 0 and resultDamage or 0 --保证伤害值不为负数

        --最后的参数为无视防御，倒数第二个参数为攻击者
        target.components.health:DoDelta(-damageNum, nil, (inst.nameoverride or inst.prefab), true, owner, true)

        --推出事件，让被攻击者能播放被攻击动画，并标记仇恨，武器攻击力为0时才需要这句话，后面代码也是如此
        target:PushEvent("attacked", { attacker = owner, damage = damageNum, damageresolved = damageNum, weapon = inst, noimpactsound = target.components.combat.noimpactsound })
        if target.components.combat.onhitfn ~= nil then
            target.components.combat.onhitfn(target, owner, damageNum)
        end

        owner:PushEvent("onhitother", { target = target, damage = damageNum, damageresolved = damageNum, weapon = inst })
        if self ~= nil and self.onhitotherfn ~= nil then
            self.onhitotherfn(owner, target, damageNum, nil)
        end

        if target.components.health:IsDead() then
            owner:PushEvent("killed", { victim = target })

            if target.components.combat ~= nil and target.components.combat.onkilledbyother ~= nil then
                target.components.combat.onkilledbyother(target, owner)
            end
        end

        --由于女武神的攻击时歌唱值加点与武器攻击力直接挂钩(不想改动SingingInspiration组件)
        --所以这边主动给歌唱值补充没加上的点数
        if owner.components.singinginspiration ~= nil then
            local singing = owner.components.singinginspiration
            if singing.validvictimfn ~= nil and not singing.validvictimfn(target) then
                return
            end
            singing:DoDelta(
                (51 * TUNING.INSPIRATION_GAIN_RATE)
                * (1 - singing:GetPercent())
                * (target:HasTag("epic") and TUNING.INSPIRATION_GAIN_EPIC_BONUS or 1)
            )
        end

        local skindata = inst.components.skinedlegion:GetSkinedData()
        if skindata ~= nil and skindata.fn_onAttack ~= nil then
            skindata.fn_onAttack(inst, owner, target)
        end
    end
    ]]--
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("rosorns")
    inst.AnimState:SetBuild("rosorns")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")
    inst:AddTag("show_spoilage")
    inst:AddTag("icebox_valid")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("rosorns")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "rosorns"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/rosorns.xml"

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(51)
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FASTISH)   --8*total_day_time*perish_warp,
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

return Prefab("rosorns", fn, assets)
