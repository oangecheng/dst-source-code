
local function ondiscarded(inst)
    inst.components.finiteuses:Use()
end

local function onusedup(inst)
    SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local assets = {
    Asset("ANIM", "anim/saddle_baggage.zip"),
    Asset("ATLAS", "images/inventoryimages/saddle_baggage.xml"),
    Asset("IMAGE", "images/inventoryimages/saddle_baggage.tex"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("saddlebasic")
    inst.AnimState:SetBuild("saddle_baggage")
    inst.AnimState:PlayAnimation("idle")

    inst.mounted_foleysound = "dontstarve/movement/foley/krampuspack"

    inst:AddTag("containersaddle")

    MakeInventoryFloatable(inst, "med", 0.2, 0.9)
    local OnLandedClient_old = inst.components.floater.OnLandedClient
    inst.components.floater.OnLandedClient = function(self)
        OnLandedClient_old(self)
        self.inst.AnimState:SetFloatParams(0.016, 1, self.bob_percent)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "saddle_baggage"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/saddle_baggage.xml"

    inst:AddComponent("saddler")
    inst.components.saddler:SetBonusDamage(TUNING.SADDLE_BASIC_BONUS_DAMAGE)
    inst.components.saddler:SetBonusSpeedMult(TUNING.SADDLE_BASIC_SPEEDMULT)
    inst.components.saddler:SetSwaps("saddle_baggage", "swap_saddle")
    inst.components.saddler:SetDiscardedCallback(ondiscarded)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(8)
    inst.components.finiteuses:SetUses(8)
    inst.components.finiteuses:SetOnFinished(onusedup)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("saddle_baggage", fn, assets)
