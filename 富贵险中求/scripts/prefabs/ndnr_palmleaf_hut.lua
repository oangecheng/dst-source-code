require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/ndnr_palmleaf_hut.zip"),
	Asset("ANIM", "anim/ndnr_palmleaf_hut_shdw.zip"),
    Asset("IMAGE", "images/ndnr_palmleaf_hut.tex"),
    Asset("ATLAS", "images/ndnr_palmleaf_hut.xml"),
}

local prefabs =
{
	"ndnr_palmleaf_hut_shadow",
}

local function onhammered(inst, worker)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("idle", true)

		if inst.shadow then
			inst.shadow.AnimState:PlayAnimation("hit")
			inst.shadow.AnimState:PushAnimation("idle", true)
		end
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle", true)

	if inst.shadow then
		inst.shadow.AnimState:PlayAnimation("place")
		inst.shadow.AnimState:PushAnimation("idle", true)
	end

	inst.SoundEmitter:PlaySound("dontstarve/common/lean_to_craft")
end

local function onsave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
		data.burnt = true
	end
end

local function onload(inst, data)
	if data and data.burnt then
		inst.components.burnable.onburnt(inst)
	end
end

local function onremove(inst)
	if inst.shadow then
		inst.shadow:Remove()
	end
end

local function onnear(inst, player)
	if player ~= nil and player:HasTag("player") and not player:HasTag("playerghost") and player.components.moisture ~= nil then
		player.components.moisture.waterproofnessmodifiers:SetModifier(inst, 1)
	end
end

local function onfar(inst, player)
	if player ~= nil and player:HasTag("player") and not player:HasTag("playerghost") and player.components.moisture ~= nil then
		player.components.moisture.waterproofnessmodifiers:RemoveModifier(inst)
	end
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()

	inst:AddTag("shelter")
	inst:AddTag("dryshelter")

	inst:AddTag("structure")

	inst.AnimState:SetBank("hut")
	inst.AnimState:SetBuild("ndnr_palmleaf_hut")
	inst.AnimState:PlayAnimation("idle", true)

	inst.MiniMapEntity:SetIcon( "ndnr_palmleaf_hut.tex" )

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")

	inst:AddComponent("lootdropper")
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)

	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(2, 3)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
    inst.components.playerprox:SetTargetMode(inst.components.playerprox.TargetModes.AllPlayers)

	inst.shadow = SpawnPrefab("ndnr_palmleaf_hut_shadow")
	inst:DoTaskInTime(0, function()
		inst.shadow.Transform:SetPosition(inst:GetPosition():Get())
	end)
	--inst:AddChild(inst.shadow)

	MakeSnowCovered(inst)
	inst:ListenForEvent( "onbuilt", onbuilt)

	MakeLargeBurnable(inst, nil, nil, true)
	MakeLargePropagator(inst)

	inst.OnSave = onsave
	inst.OnLoad = onload

	inst.OnRemoveEntity = onremove

	return inst
end

local function shadowfn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()

	inst.AnimState:SetBank("palmleaf_hut_shdw")
	inst.AnimState:SetBuild("ndnr_palmleaf_hut_shdw")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("NOCLICK")
	inst:AddTag("FX")

	inst.persists = false

	return inst
end

return Prefab( "ndnr_palmleaf_hut", fn, assets, prefabs),
	Prefab("ndnr_palmleaf_hut_shadow", shadowfn, assets),
	MakePlacer( "ndnr_palmleaf_hut_placer", "hut", "ndnr_palmleaf_hut", "idle" )