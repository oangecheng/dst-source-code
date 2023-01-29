
local assets =
{
    Asset("ANIM", "anim/ui_lg_granary_4x4.zip"),	
    Asset("ANIM", "anim/lg_granary.zip"),	
    Asset("ATLAS", "images/inventoryimages/lg_granary.xml"),
    Asset("IMAGE", "images/inventoryimages/lg_granary.tex")
}

local prefabs =
{
    "collapse_small",
}

local function onopen(inst)
    inst.SoundEmitter:PlaySound("saltydog/common/saltbox/open")
end

local function onclose(inst)
    inst.SoundEmitter:PlaySound("saltydog/common/saltbox/close")
end

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    inst.components.container:DropEverything()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
    inst.components.container:DropEverything()
    inst.components.container:Close()
end

local function onburnt(inst)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end
	local x,y,z = inst.Transform:GetWorldPosition()
	for k = 1 ,math.random(3,6) do
		SpawnPrefab("ash").Transform:SetPosition(x+math.random()*2*( math.random() < 0.5 and 1 or -1),0,z+math.random()*2*( math.random() < 0.5 and 1 or -1))
	end
    inst:Remove()
end

local function onignite(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = false
    end
end

local function onextinguish(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = true
    end
end

local function fn()
    local inst = CreateEntity()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState() 
    inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("lg_granary.tex")
	
    inst:AddTag("structure")
	inst:AddTag("wildfirepriority")

	MakeObstaclePhysics(inst, 1.5)
	
    inst.AnimState:SetBank("lg_granary") 
    inst.AnimState:SetBuild("lg_granary")
    inst.AnimState:PlayAnimation("idle")
	
	MakeSnowCoveredPristine(inst)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("lg_granary")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true
	
    inst:AddComponent("lootdropper")
	
    inst:AddComponent("workable") 
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit) 

	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(0.15)
	
    AddHauntableDropItemOrWork(inst)
	
    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)
    inst.components.burnable:SetOnBurntFn(onburnt)
    inst.components.burnable:SetOnIgniteFn(onignite)
    inst.components.burnable:SetOnExtinguishFn(onextinguish)
	
	MakeSnowCovered(inst)
	
    return inst
end

return Prefab("lg_granary", fn, assets, prefabs),
	MakePlacer("lg_granary_placer", "lg_granary", "lg_granary", "idle")