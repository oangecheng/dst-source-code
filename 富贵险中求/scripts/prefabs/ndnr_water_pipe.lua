local assets =
{
	Asset("ANIM", "anim/ndnr_sprinkler_pipes.zip")
}

local function HideLayers(inst)
    local rays = {1, 2, 3}
    for i = 1, #rays, 1 do
        inst.AnimState:Hide("joint"..i)
        inst.AnimState:Hide("pipe"..i)
    end
end

local function ShowRandomLayers(inst)
	if not inst.jointLayerShown then
		inst.jointLayerShown = "joint"..math.random(1, 3)
	end

	if not inst.pipeLayerShown then
		inst.pipeLayerShown = "pipe"..math.random(1, 3)
	end

	inst.AnimState:Show(inst.jointLayerShown)
	inst.AnimState:Show(inst.pipeLayerShown)
end

local function OnSave(inst, data)
	data.jointLayerShown = inst.jointLayerShown
	data.pipeLayerShown = inst.pipeLayerShown
end

local function OnLoad(inst, data)
	inst.jointLayerShown = data.jointLayerShown
	inst.pipeLayerShown = data.pipeLayerShown
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("sprinkler_pipes")
	inst.AnimState:SetBuild("ndnr_sprinkler_pipes")
	inst.AnimState:PlayAnimation("place")

	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)

	inst.entity:SetPristine()
	if not TheWorld.ismastersim then
		return inst
	end

	inst.OnSave = OnSave
    inst.OnLoad = OnLoad

	HideLayers(inst)
	ShowRandomLayers(inst)

    --inst.Transform:SetScale(1.5, 1.5, 1.5)
	inst:SetStateGraph("SGndnr_water_pipe")

	return inst
end

return Prefab("ndnr_water_pipe", fn, assets)