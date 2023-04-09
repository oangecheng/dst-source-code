local assets =
{
    Asset("ANIM", "anim/tourmalinecore.zip"),
	Asset("ATLAS", "images/inventoryimages/tourmalinecore.xml"),
    Asset("IMAGE", "images/inventoryimages/tourmalinecore.tex"),
}

local function storeincontainer(inst, container)
    if container ~= nil and container.components.container ~= nil then
        inst:ListenForEvent("onputininventory", inst._oncontainerownerchanged, container)
        inst:ListenForEvent("ondropped", inst._oncontainerownerchanged, container)
        inst:ListenForEvent("onremove", inst._oncontainerremoved, container)
        inst._container = container
    end
end

local function unstore(inst)
    if inst._container ~= nil then
        inst:RemoveEventCallback("onputininventory", inst._oncontainerownerchanged, inst._container)
        inst:RemoveEventCallback("ondropped", inst._oncontainerownerchanged, inst._container)
        inst:RemoveEventCallback("onremove", inst._oncontainerremoved, inst._container)
        inst._container = nil
    end
end

local function topocket(inst, owner)    --放进物品栏时，拿在鼠标上时，都会触发一次这个函数
    if inst._container ~= owner then
        unstore(inst)
        storeincontainer(inst, owner)
    end

    owner = owner.components.inventoryitem ~= nil and owner.components.inventoryitem:GetGrandOwner() or owner
    if inst._owner ~= owner then    --易主了
        inst._owner = owner

        if inst.updatetask ~= nil then
            inst.updatetask:Cancel()
            inst.updatetask = nil
        end

        if owner ~= nil and owner:HasTag("player") and owner.components.playerlightningtarget ~= nil then
            inst.updatetask = inst:DoPeriodicTask(480, function()
                owner.components.playerlightningtarget:DoStrike()
            end)
        end
    end
end

local function toground(inst)
    unstore(inst)
    inst._owner = nil

    if inst.updatetask ~= nil then
        inst.updatetask:Cancel()
        inst.updatetask = nil
    end
end

local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tourmalinecore")
    inst.AnimState:SetBuild("tourmalinecore")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "tourmalinecore"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tourmalinecore.xml"
    inst.components.inventoryitem:SetSinks(true) --它是石头，应该要沉入水底

    MakeHauntableLaunch(inst)

    ------

    inst._owner = nil
    inst._container = nil

    inst._oncontainerownerchanged = function(container)
        topocket(inst, container)
    end
    inst._oncontainerremoved = function()
        unstore(inst)
    end

    inst:ListenForEvent("onputininventory", topocket)
    inst:ListenForEvent("ondropped", toground)

    return inst
end

return Prefab("tourmalinecore", fn, assets, nil)
