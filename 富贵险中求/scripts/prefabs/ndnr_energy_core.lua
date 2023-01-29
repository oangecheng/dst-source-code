local assets=
{
	Asset("ANIM", "anim/ndnr_energy_core.zip"),
    Asset("IMAGE", "images/ndnr_energy_core.tex"),
    Asset("ATLAS", "images/ndnr_energy_core.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_energy_core.xml", 256),
}

local function UpgradeDo(inst, doer, target)
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(target.Transform:GetWorldPosition())

    if target.ndnr_makeforeverfresh ~= nil then
        target.ndnr_makeforeverfresh(target, doer)
    end

    if target.ndnr_upgradecb ~= nil then
        target.ndnr_upgradecb(target, doer)
    end
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	inst.entity:AddPhysics()
    inst.entity:AddLight()
    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("ndnr_energy_core")
    inst.AnimState:SetBuild("ndnr_energy_core")
    inst.AnimState:PlayAnimation("idle")

    inst.Light:SetRadius(2)
    inst.Light:SetFalloff(.6)
    inst.Light:SetIntensity(.8)
    inst.Light:SetColour(126/255, 236/255, 249/255)
    inst.Light:Enable(true)

    inst:AddTag("fulllighter")
    inst:AddTag("lightcontainer")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_energy_core.xml"

    inst:AddComponent("ndnr_upgradestaff")
    inst.components.ndnr_upgradestaff:SetDoFn(UpgradeDo)

    return inst
end

return Prefab("ndnr_energy_core", fn, assets)
