local assets =
{
    Asset("ANIM", "anim/giantsfoot.zip"),
    Asset("ATLAS", "images/inventoryimages/giantsfoot.xml"),
    Asset("IMAGE", "images/inventoryimages/giantsfoot.tex"),
}

local function UpdateNeed(owner, object)
    if object.components.equippable ~= nil and object.components.equippable.walkspeedmult ~= nil and object.components.equippable.walkspeedmult > 1 then
        owner.needrun = false
    else
        owner.needrun = true
    end

    if object.components.weapon ~= nil then
        local dmg = object.components.weapon:GetDamage(owner, nil)
        if dmg > 17 or dmg <= 0 then
            owner.needcombat = false
        else
            owner.needcombat = true
        end
    else
        owner.needcombat = true
    end
end

local function BackpackOnEquip(owner, data) --装备道具时设定开关值
    if data ~= nil and data.eslot == EQUIPSLOTS.HANDS then
        local item = data.item

        --这种手持道具就强制让功能失效
        --之所以不让船桨也生效，是因为官方没有在ACTIONS.ROW.fn中判断oar组件是否存在
        if item:HasTag("propweapon") or item.components.oar ~= nil then
            owner.needrun = false
            owner.needcombat = false
            return
        end

        UpdateNeed(owner, item)
    end
end

local function BackpackOnUnEquip(owner, data) --卸下手持道具时设定开关值
    if data ~= nil and data.eslot == EQUIPSLOTS.HANDS then
        owner.needrun = true
        owner.needcombat = true
    end
end

local function BackpackOnMounted(owner, data)   --骑牛时
    owner:RemoveEventCallback("equip", BackpackOnEquip)
    owner:RemoveEventCallback("unequip", BackpackOnUnEquip)

    owner.needrun = false
    owner.needcombat = false
end

local function BackpackOnDismounted(owner, data)    --下牛时
    owner:ListenForEvent("equip", BackpackOnEquip)
    owner:ListenForEvent("unequip", BackpackOnUnEquip)

    if owner.components.inventory ~= nil then
        local hand = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil

        if hand == nil then
            owner.needrun = true
            owner.needcombat = true
        elseif hand:HasTag("propweapon") or hand.components.oar ~= nil then   --这种手持道具就强制让功能失效
            owner.needrun = false
            owner.needcombat = false
        else
            UpdateNeed(owner, hand)
        end
    end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("backpack", "giantsfoot", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "giantsfoot", "swap_body")

    if owner:HasTag("equipmentmodel") then --假人！
        return
    end

    if inst.components.container ~= nil then
        inst.components.container:Open(owner)
    end

    owner:ListenForEvent("mounted", BackpackOnMounted)
    owner:ListenForEvent("dismounted", BackpackOnDismounted)
    owner:ListenForEvent("equip", BackpackOnEquip)
    owner:ListenForEvent("unequip", BackpackOnUnEquip)

    if owner.components.rider ~= nil and not owner.components.rider:IsRiding() then --没有骑牛
        if owner.components.inventory ~= nil then
            local hand = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil

            if hand == nil then
                owner.needrun = true
                owner.needcombat = true
            elseif hand:HasTag("propweapon") or hand.components.oar ~= nil then   --这种手持道具就强制让功能失效
                owner.needrun = false
                owner.needcombat = false
            else
                UpdateNeed(owner, hand)
            end
        end
    else
        owner.needrun = false
        owner.needcombat = false
    end
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")

    if inst.components.container ~= nil then
        inst.components.container:Close(owner)
    end

    owner:RemoveEventCallback("mounted", BackpackOnMounted)
    owner:RemoveEventCallback("dismounted", BackpackOnDismounted)
    owner:RemoveEventCallback("equip", BackpackOnEquip)
    owner:RemoveEventCallback("unequip", BackpackOnUnEquip)

    owner.needrun = nil
    owner.needcombat = nil
end

local function onburnt(inst)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end

    SpawnPrefab("ash").Transform:SetPosition(inst.Transform:GetWorldPosition())

    inst:Remove()
end

local function onignite(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = false
    end
end

local function onextinguish(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = true
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("giantsfoot")
    inst.AnimState:SetBuild("giantsfoot")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("backpack")

    inst.MiniMapEntity:SetIcon("giantsfoot.tex")

    inst.foleysound = "dontstarve/creatures/together/deer/chain"

    MakeInventoryFloatable(inst, "small", 0.2)
    local OnLandedClient_old = inst.components.floater.OnLandedClient
    inst.components.floater.OnLandedClient = function(self)
        OnLandedClient_old(self)
        self.inst.AnimState:SetFloatParams(0.02, 1, self.bob_percent)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("giantsfoot") end
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "giantsfoot"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/giantsfoot.xml"
    inst.components.inventoryitem.cangoincontainer = false

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("giantsfoot")

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    inst.components.burnable:SetOnBurntFn(onburnt)
    inst.components.burnable:SetOnIgniteFn(onignite)
    inst.components.burnable:SetOnExtinguishFn(onextinguish)

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab("giantsfoot", fn, assets)
