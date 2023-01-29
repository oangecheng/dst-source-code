require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/ndnr_quacken_drill.zip"),
	Asset("SOUND", "sound/common.fsb"),
	Asset("IMAGE", "images/ndnr_quackendrill_item.tex"),
    Asset("ATLAS", "images/ndnr_quackendrill_item.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_quackendrill_item.xml", 256),
}

local function spawnoil(inst)
	local oil = SpawnPrefab("ndnr_tar_pool")
	if oil then
		local pt = inst:GetPosition()
		oil.Transform:SetPosition(pt.x, pt.y, pt.z)
		oil.AnimState:PlayAnimation("place")
		oil.AnimState:PushAnimation("idle",true)
	end
	inst.deploy_item_save_record = nil
	inst:Remove()
end

local function DoDrilling(inst,pt)
	if not inst.drillstage then
		inst.AnimState:PlayAnimation("idle",true)
		inst.drillstage = 1
		inst:DoTaskInTime(2,function(inst) DoDrilling(inst)  end)

	elseif inst.drillstage == 1 then
		-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/quacken_drill/drill")
		inst.AnimState:PlayAnimation("drill")
		inst:ListenForEvent("animover", function(inst) DoDrilling(inst)  end)
		inst.drillstage = 2
	else
		-- local SHAKE_DIST = 40
		-- local player = GetClosestInstWithTag("player", inst, SHAKE_DIST)
		-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/quacken_drill/underwater_hit")
		-- player:ShakeCamera("FULL", 0.7, 0.02, 3, SHAKE_DIST)
		inst:Hide()
		inst:DoTaskInTime(2,function(inst) spawnoil(inst)  end)
	end
end

local function StartUp(inst)
    inst.AnimState:PlayAnimation("place")
	inst:ListenForEvent("animover", DoDrilling)
	-- inst.SoundEmitter:PlaySound("farming/common/farm/plow/drill_pre")
end

local function OnSave(inst, data)
	data.deploy_item = inst.deploy_item_save_record
end

local function OnLoadPostPass(inst, newents, data)
	if data ~= nil then
		inst.deploy_item_save_record = data.deploy_item
	end

	if inst.deploy_item_save_record then
		DoDrilling(inst)
	end
end

local function main_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeObstaclePhysics(inst, 0.5)

	inst.AnimState:SetBank("ndnr_quacken_drill")
	inst.AnimState:SetBuild("ndnr_quacken_drill")

    inst:AddTag("scarytoprey")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    MakeMediumBurnable(inst, nil, nil, true)
    MakeLargePropagator(inst)

	inst.deploy_item_save_record = nil

	inst.startup_task = inst:DoTaskInTime(0, StartUp)

	inst.OnSave = OnSave
	inst.OnLoadPostPass = OnLoadPostPass

    return inst
end

local function item_ondeploy(inst, pt, deployer)
    local cx, cy, cz = TheWorld.Map:GetTileCenterPoint(pt:Get())

    local obj = SpawnPrefab("ndnr_quackendrill")
	obj.Transform:SetPosition(cx, cy, cz)

	if inst:IsValid() then
		obj.deploy_item_save_record = inst:GetSaveRecord()
		inst:Remove()
	end
end

local function can_plow_tile(inst, pt, mouseover, deployer)
	local tile = TheWorld.Map:GetTileAtPoint(pt.x, 0, pt.z)
	return tile >= GROUND.OCEAN_SWELL and tile < GROUND.OCEAN_END
end

local function item_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("ndnr_quacken_drill")
	inst.AnimState:SetBuild("ndnr_quacken_drill")
	inst.AnimState:PlayAnimation("dropped")

    inst:AddTag("usedeploystring")
    inst:AddTag("tile_deploy")

	MakeInventoryFloatable(inst, "small", 0.1, 0.8)

	inst._custom_candeploy_fn = can_plow_tile -- for DEPLOYMODE.CUSTOM

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/ndnr_quackendrill_item.xml"

    inst:AddComponent("deployable")
	inst.components.deployable:SetDeployMode(DEPLOYMODE.CUSTOM)
    inst.components.deployable.ondeploy = item_ondeploy

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    MakeHauntableLaunch(inst)

    return inst
end

local function placer_fn()
    local inst = CreateEntity()

    inst:AddTag("CLASSIFIED")
    inst:AddTag("NOCLICK")
    inst:AddTag("placer")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.AnimState:SetBank("ndnr_quacken_drill")
    inst.AnimState:SetBuild("ndnr_quacken_drill")
    inst.AnimState:PlayAnimation("placer")
    inst.AnimState:SetLightOverride(1)

    inst:AddComponent("placer")
    inst.components.placer.snap_to_tile = true

	inst.outline = SpawnPrefab("tile_outline")
	inst.outline.entity:SetParent(inst.entity)

	inst.components.placer:LinkEntity(inst.outline)

    return inst
end

return Prefab( "ndnr_quackendrill", main_fn, assets),
		Prefab( "ndnr_quackendrill_item", item_fn, assets),
		Prefab( "ndnr_quackendrill_item_placer", placer_fn)


