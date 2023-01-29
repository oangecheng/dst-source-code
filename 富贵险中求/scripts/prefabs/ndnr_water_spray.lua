local assets =
{
	Asset("ANIM", "anim/ndnr_sprinkler_fx.zip")
}

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("sprinkler_fx")
	inst.AnimState:SetBuild("ndnr_sprinkler_fx")
	inst.AnimState:PlayAnimation("spray_loop", true)

	inst.entity:SetPristine()
	if not TheWorld.ismastersim then
		return inst
	end
	inst.persists = false

	return inst
end

return Prefab("ndnr_water_spray", fn, assets)