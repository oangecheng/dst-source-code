local assets =
{
    Asset("ANIM", "anim/reticuleaoe.zip"),
}

local function SetRadius(inst, radius)
	local scale = radius/3 or 1
	inst.AnimState:SetScale(scale, scale)
end

local function Attach(inst, to)
	inst.attached_to = to
	inst.entity:SetParent(to.entity)
end

local function medal_scale_fn()
	local inst = CreateEntity()
	inst.entity:SetCanSleep(false)
	inst.persists = false
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	
	-- inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("CLASSIFIED")
	
	inst.AnimState:SetBank("reticuleaoe")
	inst.AnimState:SetBuild("reticuleaoe")
	inst.AnimState:PlayAnimation("idle_target")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGroundFixed)
	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	-- inst.AnimState:SetScale(scale, scale)
	
	inst.SetRadius = SetRadius
	inst.Attach = Attach
	
	return inst
end

return Prefab("medal_show_range", medal_scale_fn, assets)