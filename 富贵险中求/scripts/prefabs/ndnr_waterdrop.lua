local assets =
{
	Asset("ANIM", "anim/ndnr_waterdrop.zip"),
    Asset("IMAGE", "images/ndnr_waterdrop.tex"),
    Asset("ATLAS", "images/ndnr_waterdrop.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_waterdrop.xml", 256),
}

local function OnSave(inst, data)

end

local function OnLoadPostPass(inst, newents, data)

end

local function OnRemoved(inst)
    -- if inst.fountain and not inst.planted then
    --     inst.fountain.deactivate(inst.fountain)
    -- end
end

local function ondeploy(inst, pt)
    local plant = SpawnPrefab("ndnr_lifeplant")
    plant.Transform:SetPosition(pt:Get() )

    -- 种下后立即进入作祟CD状态
    if plant.components.hauntable and plant:IsValid() then
        local hauntable = plant.components.hauntable
        hauntable.haunted = true
        hauntable.cooldowntimer = hauntable.cooldown or TUNING.HAUNT_COOLDOWN_SMALL
        hauntable:StartFX(true)
        hauntable:StartShaderFx()
        hauntable.inst:StartUpdatingComponent(hauntable)
    end

    inst:Remove()
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("waterdrop")
    inst.AnimState:SetBuild("ndnr_waterdrop")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("waterdrop")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.VEGGIE
    inst.components.edible.healthvalue = TUNING.HEALING_SUPERHUGE * 3
    inst.components.edible.hungervalue = TUNING.CALORIES_SUPERHUGE * 3
    inst.components.edible.sanityvalue = TUNING.SANITY_HUGE * 3

    inst:AddComponent("ndnr_poisonhealer")

    inst:AddComponent("inspectable")

    inst.OnSave = OnSave
    inst.OnLoadPostPass = OnLoadPostPass

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_waterdrop.xml"

    inst:ListenForEvent("onremove", OnRemoved)

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy

    return inst
end

return Prefab("ndnr_waterdrop", fn, assets),
       MakePlacer("ndnr_waterdrop_placer", "lifeplant", "ndnr_lifeplant", "idle_loop" )