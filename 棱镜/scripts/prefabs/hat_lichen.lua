local assets =
{
    Asset("ANIM", "anim/hat_lichen.zip"),
	Asset("ATLAS", "images/inventoryimages/hat_lichen.xml"),
    Asset("IMAGE", "images/inventoryimages/hat_lichen.tex"),
}

local prefabs =
{
    "lichenhatlight"
}

local function lichen_equip(inst, owner)    --装备时
    if inst._light == nil or not inst._light:IsValid() then
        inst._light = SpawnPrefab("lichenhatlight") --生成光源
        inst._light.entity:SetParent(owner.entity)  --给光源设置父节点
    end

    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.equip ~= nil then
        if skindata.equip.isopenhat then
            HAT_OPENTOP_ONEQUIP_L(inst, owner, skindata.equip.build, skindata.equip.file)
        else
            HAT_ONEQUIP_L(inst, owner, skindata.equip.build, skindata.equip.file)
        end
        if skindata.equip.lightcolor ~= nil then
            local rgb = skindata.equip.lightcolor
            inst._light.Light:SetColour(rgb.r, rgb.g, rgb.b)
        end
    else
        HAT_OPENTOP_ONEQUIP_L(inst, owner, "hat_lichen", "swap_hat")
    end

    -- owner:AddTag("ignoreMeat")  --添加忽略带着肉的标签

    local soundemitter = owner ~= nil and owner.SoundEmitter or inst.SoundEmitter
    soundemitter:PlaySound("dontstarve/common/minerhatAddFuel") --添加装备时的音效
end

local function lichen_unequip(inst, owner)  --卸下时
    HAT_ONUNEQUIP_L(inst, owner)

    -- owner:RemoveTag("ignoreMeat")    --移除忽略带肉的标签

    if inst._light ~= nil then
        if inst._light:IsValid() then
            inst._light:Remove()    --把光源去掉
        end
        inst._light = nil
    end

    local soundemitter = owner ~= nil and owner.SoundEmitter or inst.SoundEmitter
    soundemitter:PlaySound("dontstarve/common/minerhatOut") --添加卸下时的音效
end

-----------------------------------

local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hat_lichen")
    inst.AnimState:SetBuild("hat_lichen")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("hat")
    inst:AddTag("show_spoilage") --显示新鲜度的背景
    inst:AddTag("icebox_valid")
    inst:AddTag("open_top_hat")
    inst:AddTag("ignoreMeat")

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("hat_lichen")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst._light = nil

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY*5)   --5天新鲜度
    inst.components.perishable:StartPerishing()
    inst.components.perishable:SetOnPerishFn(inst.Remove)

    inst:AddComponent("inspectable") --可检查

    inst:AddComponent("inventoryitem") --物品组件
    inst.components.inventoryitem.imagename = "hat_lichen"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hat_lichen.xml"

    inst:AddComponent("equippable") --装备组件
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD --装在头上
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED  --添加增加精神值效果，和高礼帽一样
    inst.components.equippable:SetOnEquip(lichen_equip)
    inst.components.equippable:SetOnUnequip(lichen_unequip)

    inst:AddComponent("tradable") --可交易组件  有了这个就可以给猪猪

    MakeHauntableLaunchAndPerish(inst)

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

local function lichenhatlightfn()   --设置苔衣发卡的光源
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetFalloff(0.55)  --衰减
    inst.Light:SetIntensity(.7) --亮度
    inst.Light:SetRadius(2)     --半径
    inst.Light:SetColour(237/255, 237/255, 209/255) --颜色，和灯泡花一样

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

return Prefab("hat_lichen", fn, assets, prefabs),
        Prefab("lichenhatlight", lichenhatlightfn)
