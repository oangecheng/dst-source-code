local assets =
{
    Asset("ANIM", "anim/refractedmoonlight.zip"),    --地面的动画
    Asset("ANIM", "anim/swap_refractedmoonlight.zip"),   --手上的动画
    Asset("ATLAS", "images/inventoryimages/refractedmoonlight.xml"),
    Asset("IMAGE", "images/inventoryimages/refractedmoonlight.tex"),
}

local prefabs =
{
    "refractedmoonlight_fx",
}

local damage_mega = 85    --34x2.5
local damage_unhealthy = 3.4

local function radicalhealth(owner, data)
    local sword = owner.components.inventory ~= nil and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil

    if sword ~= nil and sword.prefab == "refractedmoonlight" and sword.components.weapon ~= nil and owner.components.health ~= nil then
        if owner.components.health:GetPercent() < 1 then
            sword.components.weapon:SetDamage(damage_unhealthy)    --血量一旦不是满的，武器攻击力变很低
        else
            sword.components.weapon:SetDamage(damage_mega)
        end
    end
end

local function onequip(inst, owner) --装备武器时
    owner.AnimState:OverrideSymbol("swap_object", "swap_refractedmoonlight", "swap_refractedmoonlight")
    owner.AnimState:Show("ARM_carry") --显示持物手
    owner.AnimState:Hide("ARM_normal") --隐藏普通的手

    if owner:HasTag("equipmentmodel") then --假人！
        return
    end

    owner:ListenForEvent("healthdelta", radicalhealth)

    --在这里直接调用radicalhealth()并不能识别到手中的武器，所以这里才这样写
    if inst.components.weapon ~= nil and owner.components.health ~= nil then
        if owner.components.health:GetPercent() < 1 then
            inst.components.weapon:SetDamage(damage_unhealthy)    --血量一旦不是满的，武器攻击力变很低
        else
            inst.components.weapon:SetDamage(damage_mega)
        end
    end
end

local function onunequip(inst, owner)   --放下武器时
    owner.AnimState:Hide("ARM_carry") --隐藏持物手
    owner.AnimState:Show("ARM_normal") --显示普通的手

    owner:RemoveEventCallback("healthdelta", radicalhealth)

    inst.components.weapon:SetDamage(damage_mega) --卸下时，恢复武器默认攻击力，为了让巨人之脚识别到
end

local function onattack(inst, owner, target)
    if not TheWorld.state.isday and not TheWorld.state.isnewmoon then --非新月、非白天
        if owner.components.health and owner.components.health:GetPercent() < 1 then
            owner.components.health:DoDelta(1.5, false, "refractedmoonlight")

            local fx = SpawnPrefab("refractedmoonlight_fx")    --加血特效
            fx.Transform:SetPosition(owner.Transform:GetWorldPosition())
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()  --要在小地图上显示的话，记得加这句
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("refractedmoonlight")
    inst.AnimState:SetBuild("refractedmoonlight")
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst:AddTag("sharp") --武器的标签跟攻击方式跟攻击音效有关 没有特殊的话就用这两个
    inst:AddTag("pointy")
    inst:AddTag("irreplaceable") --防止被猴子、食人花、坎普斯等拿走，防止被流星破坏，并使其下线时会自动掉落
    inst:AddTag("nonpotatable") --这个貌似是？
    inst:AddTag("NORATCHECK") --mod兼容：永不妥协。该道具不算鼠潮分

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    inst.MiniMapEntity:SetIcon("refractedmoonlight.tex")

    -- MakeInventoryFloatable(inst, "small", 0.15, 0.3)
    -- local OnLandedClient_old = inst.components.floater.OnLandedClient
    -- inst.components.floater.OnLandedClient = function(self)
    --     OnLandedClient_old(self)
    --     self.inst.AnimState:SetFloatParams(0.04, 1, 0)
    -- end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then 
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "refractedmoonlight"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/refractedmoonlight.xml"
    inst.components.inventoryitem:SetSinks(true) --落水时会下沉，但是因为标签的关系会回到绚丽大门

    inst:AddComponent("inspectable")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(damage_mega)
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("refractedmoonlight", fn, assets, prefabs)