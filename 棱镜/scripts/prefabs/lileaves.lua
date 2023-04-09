local assets =
{
    Asset("ANIM", "anim/lileaves.zip"),--这个是放在地上的动画文件
    Asset("ANIM", "anim/swap_lileaves.zip"), --这个是手上动画
    Asset("ATLAS", "images/inventoryimages/lileaves.xml"),
    Asset("IMAGE", "images/inventoryimages/lileaves.tex"),
}

local function OnEquip(inst, owner) --装备武器时
    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.equip ~= nil then
        owner.AnimState:OverrideSymbol("swap_object", skindata.equip.build, skindata.equip.file)
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_lileaves", "swap_lileaves")
    end
    owner.AnimState:Show("ARM_carry") --显示持物手
    owner.AnimState:Hide("ARM_normal") --隐藏普通的手
end

local function OnUnequip(inst, owner)   --放下武器时
    owner.AnimState:Hide("ARM_carry") --隐藏持物手
    owner.AnimState:Show("ARM_normal") --显示普通的手
end

local function onattack(inst, owner, target)
    if target ~= nil and target:IsValid() and not target:HasTag("player") and not target:HasTag("debuffdamage") then  --不能让玩家减少攻击力
        if target.components.combat ~= nil then
            target:AddTag("debuffdamage")   --攻击时给对象添加减益光环标签，其实是为了防止重复减少敌方攻击系数

            local damagemult = (target.components.combat.damagemultiplier or 1) * 0.7
            target.components.combat.damagemultiplier = damagemult
        end
    end
end

local function fn()
    local inst = CreateEntity()--创建一个实体，常见的各种inst，根源就是在这里。

    inst.entity:AddTransform()--给实体添加转换组件，这主要涉及的是空间位置的转换和获取
    inst.entity:AddAnimState()--给实体添加动画组件，从而实体能在游戏上显示出来。
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("lileaves")--设置实体的bank，此处是指放在地上的时候，下同
    inst.AnimState:SetBuild("lileaves")--设置实体的build
    inst.AnimState:PlayAnimation("idle")--设置实体播放的动画

    inst:AddTag("sharp") --武器的标签跟攻击方式跟攻击音效有关 没有特殊的话就用这两个
    inst:AddTag("pointy")
    inst:AddTag("show_spoilage")    --显示新鲜度
    inst:AddTag("icebox_valid")     --能装进冰箱

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("lileaves")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")--添加物品栏物品组件，只有有了这个组件，你才能把这个物品捡起放到物品栏里
    inst.components.inventoryitem.imagename = "lileaves"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/lileaves.xml"

    inst:AddComponent("inspectable") --可检查组件

    inst:AddComponent("equippable")--添加可装备组件，有了这个组件，你才能装备物品  
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst:AddComponent("weapon") --增加武器组件 有了这个才可以打人
    inst.components.weapon:SetDamage(51) --设置伤害，如果为0会吸引不了仇恨、不触发被攻击动画
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("perishable") --会腐烂
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FASTISH)   --8天新鲜度
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)  --作祟相关函数

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

return Prefab("lileaves", fn, assets)