local assets =
{
    Asset("ANIM", "anim/hat_cowboy.zip"),
	Asset("ATLAS", "images/inventoryimages/hat_cowboy.xml"),   --物品栏图片
    Asset("IMAGE", "images/inventoryimages/hat_cowboy.tex"),
}

local function CowboyOnMounted(owner, data)
    local hat = owner.components.inventory ~= nil and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil --获取帽子

    if hat == nil or (hat ~= nil and hat.prefab ~= "hat_cowboy") then
        return
    end

    if data ~= nil and data.target ~= nil then
        local mymount = data.target     --获取牛
        local Domestication = mymount.components.domesticatable or nil

        if Domestication ~= nil and hat.cowboytask == nil then
            hat.cowboytask = hat:DoPeriodicTask(10, function()
                Domestication:DeltaDomestication(TUNING.BEEFALO_DOMESTICATION_GAIN_DOMESTICATION * 6)
            end)
        end
    end
end

local function CowboyOnDismounted(owner, data)
    local hat = owner.components.inventory ~= nil and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil --获取帽子

    if hat == nil or (hat ~= nil and hat.prefab ~= "hat_cowboy") then
        return
    end

    if hat.cowboytask ~= nil then
        hat.cowboytask:Cancel()
        hat.cowboytask = nil
    end
end

local function CowboyOnUnEquip(owner, data)
    if data ~= nil and data.eslot == EQUIPSLOTS.BODY and owner.components.inventory ~= nil then
        owner.AnimState:OverrideSymbol("swap_body", owner.scarf_skin_l or "hat_cowboy", "swap_body")
    end
end

local function onequip(inst, owner) --佩戴
    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.equip ~= nil then
        HAT_L_ON(inst, owner, skindata.equip.build, skindata.equip.file)
        owner.scarf_skin_l = skindata.equip.build
    else
        HAT_L_ON(inst, owner, "hat_cowboy", "swap_hat")
        owner.scarf_skin_l = nil
    end

    if owner:HasTag("equipmentmodel") then --假人！
        return
    end

    if owner:HasTag("player") then
        if owner.components.inventory ~= nil then
            local equippedArmor = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) or nil --获取衣服
            if equippedArmor == nil then    --没有穿啥衣服时，换上牛仔围巾
                --与传统帽子不同的是，这个帽子会有红色牛仔围巾的套装效果
                owner.AnimState:OverrideSymbol("swap_body", owner.scarf_skin_l or "hat_cowboy", "swap_body")
            end
        end

        if owner.components.rider ~= nil then
            if owner.components.rider:IsRiding() then --正在骑牛
                local mymount = owner.components.rider:GetMount() or nil --获取牛

                if mymount ~= nil then
                    local Domestication = mymount.components.domesticatable or nil   --获取牛的驯化组件

                    if Domestication ~= nil and inst.cowboytask == nil then
                        inst.cowboytask = inst:DoPeriodicTask(10, function()
                            Domestication:DeltaDomestication(TUNING.BEEFALO_DOMESTICATION_GAIN_DOMESTICATION * 6)
                        end)
                    end
                end
            end
        end

        owner:ListenForEvent("mounted", CowboyOnMounted)
        owner:ListenForEvent("dismounted", CowboyOnDismounted)
        owner:ListenForEvent("unequip", CowboyOnUnEquip)
    end

    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end

    owner:AddTag("beefalo") --牛牛的标签，加入后不会被发情牛主动攻击
end

local function onunequip(inst, owner)   --卸下
    HAT_L_OFF(inst, owner)
    owner.scarf_skin_l = nil

    if owner:HasTag("player") then
        if owner.components.inventory ~= nil then
            local equippedArmor = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) or nil --获取衣服
            if equippedArmor == nil then    --没有穿啥衣服时，去除牛仔围巾
                owner.AnimState:ClearOverrideSymbol("swap_body")
            end
        end

        if inst.cowboytask ~= nil then
            inst.cowboytask:Cancel()
            inst.cowboytask = nil
        end

        owner:RemoveEventCallback("mounted", CowboyOnMounted)
        owner:RemoveEventCallback("dismounted", CowboyOnDismounted)
        owner:RemoveEventCallback("unequip", CowboyOnUnEquip)
    end

    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end

    owner:RemoveTag("beefalo")
end

-----------------------------------

local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hat_cowboy")
    inst.AnimState:SetBuild("hat_cowboy")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("hat")

    --waterproofer (from waterproofer component) added to pristine state for optimization
    inst:AddTag("waterproofer")

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("hat_cowboy")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable") --可检查

    inst:AddComponent("inventoryitem") --物品组件
    inst.components.inventoryitem.imagename = "hat_cowboy"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hat_cowboy.xml"

    inst:AddComponent("equippable") --装备组件
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD --装在头上
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED  --和高礼帽一样的精神恢复
    inst.components.equippable.insulated = true --防电
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_HUGE)   --0.9的防水系数

    inst:AddComponent("insulator")  --隔热组件
    inst.components.insulator:SetInsulation(TUNING.INSULATION_MED)    --西瓜帽一样的效果
    inst.components.insulator:SetSummer()   --设置为夏季后，就是延缓温度上升的效果了

    inst:AddComponent("fueled") --耐久组件
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.TOPHAT_PERISHTIME)    --8天的佩戴时间
    inst.components.fueled:SetDepletedFn(inst.Remove)

    inst:AddComponent("tradable") --可交易组件，有了这个就可以给猪猪

    MakeHauntableLaunch(inst)

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

return Prefab("hat_cowboy", fn, assets)
