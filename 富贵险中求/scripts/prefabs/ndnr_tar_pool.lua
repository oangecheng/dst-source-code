local assets=
{
	Asset("ANIM", "anim/ndnr_tar_pit.zip"),
    -- Asset("MINIMAP_IMAGE", "tar_pit"),
	Asset("IMAGE", "images/ndnr_tar_pool.tex"),
    Asset("ATLAS", "images/ndnr_tar_pool.xml"),
}

local function onsave(inst, data)
    if inst.components.inspectable and inst.components.inspectable.inspectdisabled then
        data.inspectdisabled = true
    end
end

local function onload(inst, data)
    if data and data.inspectdisabled then
        if inst.components.inspectable then
            inst.components.inspectable.inspectdisabled = data.inspectdisabled
        end
    end
end

local function fn()
	local inst = CreateEntity()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()

    inst.MiniMapEntity:SetIcon("ndnr_tar_pool.tex")

    inst:AddTag("aquatic")
    inst:AddTag("ndnr_tar_source")
    inst:AddTag("ignorewalkableplatforms")

    inst.AnimState:SetBank("tar_pit")
    inst.AnimState:SetBuild("ndnr_tar_pit")
    inst.AnimState:PlayAnimation("idle", true)
    --inst.AnimState:SetRayTestOnBB(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- This looping sound seems to show up at 0,0,0.. so waiting a frame to start it when the tarpool will be in the world at it's location.
    -- inst:DoTaskInTime(0, function() inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/tar_LP","burble") end)

    inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetSortOrder( 3 )

    inst:AddComponent("inspectable")

	--MakeSmallBurnable(inst)
    --MakeSmallPropagator(inst)

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

return Prefab( "ndnr_tar_pool", fn, assets)
