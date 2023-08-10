local assets =
{
    Asset("ANIM", "anim/pinkstaff.zip"),
    Asset("ANIM", "anim/swap_pinkstaff.zip"),
    Asset("ATLAS", "images/inventoryimages/pinkstaff.xml"),
    Asset("IMAGE", "images/inventoryimages/pinkstaff.tex"),
}

local function OnFinished(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
    inst:Remove()
end

local function OnEquip(inst, owner)
    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil then
        if skindata.equip ~= nil then
            owner.AnimState:OverrideSymbol("swap_object", skindata.equip.build, skindata.equip.file)
        else
            owner.AnimState:OverrideSymbol("swap_object", "swap_pinkstaff", "swap_pinkstaff")
        end
        if skindata.equipfx ~= nil then
            skindata.equipfx.start(inst, owner)
        end
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_pinkstaff", "swap_pinkstaff")
    end

    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end
local function OnUnequip(inst, owner)
    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.equipfx ~= nil then
        skindata.equipfx.stop(inst, owner)
    end

    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

------

local function DressUpItem(staff, target)
    local caster = staff.components.inventoryitem.owner
    if caster ~= nil and caster.components.dressup ~= nil then
        if target == nil then --解除幻化（右键装备栏的法杖）
            caster.components.dressup:TakeOffAll()
        elseif target == caster then --解除幻化（右键玩家自己）
            caster.components.dressup:TakeOffAll()
        else                  --添加幻化
            local didit = caster.components.dressup:PutOn(target)
            if didit then
                caster.SoundEmitter:PlaySound("dontstarve/common/staff_dissassemble")
                if caster.components.sanity ~= nil then
                    caster.components.sanity:DoDelta(-10)
                end
                staff.components.finiteuses:Use(1)
            end
        end
    end
end

local function DressUpTest(doer, target, pos)
    if target == nil then --解除幻化，也是可以生效的
        return true
    elseif target == doer then --对自己施法：解除幻化
        return true
    elseif DRESSUP_DATA_LEGION[target.prefab] ~= nil then
        return true
    end

    return false
end

local function Fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("pinkstaff")
    inst.AnimState:SetBuild("pinkstaff")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("nopunch")  --这个标签的作用应该是让本身没有武器组件的道具用武器攻击的动作，而不是用拳头攻击的动作

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("pinkstaff")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.fxcolour = {255/255, 80/255, 173/255}

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(30)
    inst.components.finiteuses:SetUses(30)
    inst.components.finiteuses:SetOnFinished(OnFinished)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "pinkstaff"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/pinkstaff.xml"

    inst:AddComponent("tradable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst:AddComponent("spellcaster")
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canusefrominventory = true
    -- inst.components.spellcaster.canonlyuseonrecipes = true
    inst.components.spellcaster:SetSpellFn(DressUpItem)
    inst.components.spellcaster:SetCanCastFn(DressUpTest)

    MakeHauntableLaunch(inst)

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

return Prefab("pinkstaff", Fn, assets)
