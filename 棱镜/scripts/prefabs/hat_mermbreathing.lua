local assets =
{
    Asset("ANIM", "anim/hat_mermbreathing.zip"),
	Asset("ATLAS", "images/inventoryimages/hat_mermbreathing.xml"),   --物品栏图片
    Asset("IMAGE", "images/inventoryimages/hat_mermbreathing.tex"),
}

-- local prefabs =
-- {
--     --nothing
-- }

local function onPretendingMerm(owner, data)
    if owner.components.moisture then
        local hat = owner.components.inventory ~= nil and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil --获取帽子

        if hat ~= nil and hat.prefab == "hat_mermbreathing" then
            if hat.components.equippable then
                if owner.components.moisture:IsWet() then --潮湿了之后速度提升多一些
                    hat.components.equippable.walkspeedmult = 1.5
                elseif owner.components.moisture:GetMoisture() > 0 then
                    hat.components.equippable.walkspeedmult = 1.2
                else
                    hat.components.equippable.walkspeedmult = nil
                end
            end
        end
    end
end

local function onequip(inst, owner) --佩戴
    HAT_L_ON_OPENTOP(inst, owner, "hat_mermbreathing", "swap_hat")

    if owner:HasTag("equipmentmodel") then --假人！
        return
    end

    if owner.components.moisture then
        owner:ListenForEvent("moisturedelta", onPretendingMerm)
        onPretendingMerm(owner, nil)
    end

    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end
end

local function onunequip(inst, owner)   --卸下
    HAT_L_OFF(inst, owner)

    if owner.components.moisture then
        owner:RemoveEventCallback("moisturedelta", onPretendingMerm)
    end

    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
end

-----------------------------------

local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hat_mermbreathing")
    inst.AnimState:SetBuild("hat_mermbreathing")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("hat")
    inst:AddTag("open_top_hat")
    -- inst:AddTag("merm") --加入这个标签之后，不会被鱼人主动攻击

    MakeInventoryFloatable(inst, "med", 0.25, 0.8)
    local OnLandedClient_old = inst.components.floater.OnLandedClient
    inst.components.floater.OnLandedClient = function(self)
        OnLandedClient_old(self)
        self.inst.AnimState:SetFloatParams(0.045, 1, self.bob_percent)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "hat_mermbreathing"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hat_mermbreathing.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD --装在头上
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    -- inst.components.equippable.walkspeedmult = 1.35   --速度系数

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.FEATHERHAT_PERISHTIME)    --8天的佩戴时间
    inst.components.fueled:SetDepletedFn(inst.Remove)

    inst:AddComponent("tradable")

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab( "hat_mermbreathing", fn, assets, nil)
