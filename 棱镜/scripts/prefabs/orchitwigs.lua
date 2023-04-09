local assets =
{
    Asset("ANIM", "anim/orchitwigs.zip"),--这个是放在地上的动画文件
    Asset("ANIM", "anim/swap_orchitwigs.zip"), --这个是手上动画
    Asset("ATLAS", "images/inventoryimages/orchitwigs.xml"),
    Asset("IMAGE", "images/inventoryimages/orchitwigs.tex"),
}

local prefabs =
{
    "impact_orchid_fx",
}

local exclude_tags = { "INLIMBO", "companion", "wall", "abigail", "shadowminion" }
if not TheNet:GetPVPEnabled() then
    table.insert(exclude_tags, "player")
end

local function OnEquip(inst, owner) --装备武器时
    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.equip ~= nil then
        owner.AnimState:OverrideSymbol("swap_object", skindata.equip.build, skindata.equip.file)
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_orchitwigs", "swap_orchitwigs")
    end

    owner.AnimState:Show("ARM_carry") --显示持物手
    owner.AnimState:Hide("ARM_normal") --隐藏普通的手
end

local function OnUnequip(inst, owner)   --放下武器时
    owner.AnimState:Hide("ARM_carry") --隐藏持物手
    owner.AnimState:Show("ARM_normal") --显示普通的手
end

local function onattack(inst, owner, target)
    if target ~= nil and target:IsValid() then
        local skindata = inst.components.skinedlegion:GetSkinedData()
        local snap = nil
        if skindata ~= nil and skindata.equip ~= nil then
            snap = skindata.equip.atkfx
        end
        snap = SpawnPrefab(snap or "impact_orchid_fx")
        if snap ~= nil then
            local x, y, z = inst.Transform:GetWorldPosition()
            local x1, y1, z1 = target.Transform:GetWorldPosition()
            local angle = -math.atan2(z1 - z, x1 - x)
            snap.Transform:SetPosition(x1, y1, z1)
            snap.Transform:SetRotation(angle * RADIANS)
        end

        local x2, y2, z2 = target.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x2, y2, z2, 3, { "_combat" }, exclude_tags) --3的攻击范围
        for i, ent in ipairs(ents) do
            if ent ~= target and ent ~= owner and owner.components.combat:IsValidTarget(ent) and
                (owner.components.leader ~= nil and not owner.components.leader:IsFollower(ent)) then
                    owner:PushEvent("onareaattackother", { target = ent, weapon = inst, stimuli = nil })
                    ent.components.combat:GetAttacked(owner, 30.6, inst, nil)
            end
        end
    end
end

local function fn()
    local inst = CreateEntity()--创建一个实体，常见的各种inst，根源就是在这里。

    inst.entity:AddTransform()--给实体添加转换组件，这主要涉及的是空间位置的转换和获取
    inst.entity:AddAnimState()--给实体添加动画组件，从而实体能在游戏上显示出来。
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("orchitwigs")--设置实体的bank，此处是指放在地上的时候，下同
    inst.AnimState:SetBuild("orchitwigs")--设置实体的build
    inst.AnimState:PlayAnimation("idle")--设置实体播放的动画

    inst:AddTag("sharp") --武器的标签跟攻击方式跟攻击音效有关 没有特殊的话就用这两个
    inst:AddTag("pointy")
    inst:AddTag("show_spoilage")    --显示新鲜度
    inst:AddTag("icebox_valid")     --能装进冰箱

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("orchitwigs") --客户端才初始化时居然获取不了inst.prefab

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")--添加物品栏物品组件，只有有了这个组件，你才能把这个物品捡起放到物品栏里。
    inst.components.inventoryitem.imagename = "orchitwigs"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/orchitwigs.xml"

    inst:AddComponent("inspectable") --可检查组件

    inst:AddComponent("equippable")--添加可装备组件，有了这个组件，你才能装备物品
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )

    inst:AddComponent("weapon") --增加武器组件 有了这个才可以打人
    inst.components.weapon:SetDamage(30.6) --设置伤害，如果为0会吸引不了仇恨、不触发被攻击动画
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("perishable") --会腐烂
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FASTISH)   --8天新鲜度
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)  --作祟相关函数

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

return Prefab("orchitwigs", fn, assets, prefabs)