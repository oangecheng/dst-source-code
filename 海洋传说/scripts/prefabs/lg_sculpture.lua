local easing = require("easing")

local assets =
{
    Asset("ANIM", "anim/lg_sculpture.zip"),
	Asset("ATLAS", "images/inventoryimages/lg_sculpture.xml"),	
    Asset("ATLAS", "images/tab/lg_sculpture.xml"),
}


local prefabs =
{
}

local prefabs_icon =
{
}

local function onturnon(inst)
    --inst.AnimState:PlayAnimation("near", true)
    if not inst.SoundEmitter:PlayingSound("idlesound") then
        inst.SoundEmitter:PlaySound("dontstarve/common/ancienttable_LP", "idlesound")
    end
end

local function onturnoff(inst)
    inst.SoundEmitter:KillSound("idlesound")
	--inst.AnimState:PlayAnimation("idle", true)
end

local function onactivate(inst)   
	--inst.AnimState:PlayAnimation("use")
	--inst.AnimState:PushAnimation("near")
	--local fx = SpawnPrefab("staff_castinglight")
	--fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	--fx:SetUp({ 162/255, 230/255, 218/255 }, 2)
	--inst._fx:push()
end

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)
end

local function onbuilt(inst)
    --inst.AnimState:PlayAnimation("build")
	--inst.AnimState:PushAnimation("idle")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
	--inst.entity:AddDynamicShadow()
    --inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .4)
--	print(DebugSpawn"lg_sculpture":GetDebugString())
    inst.MiniMapEntity:SetPriority(5)
    inst.MiniMapEntity:SetIcon("lg_sculpture.tex")

    inst.AnimState:SetBank("lg_sculpture")
    inst.AnimState:SetBuild("lg_sculpture")
    inst.AnimState:PlayAnimation("idle",true)

	--inst.DynamicShadow:SetSize(1.3, .6)
	
    inst:AddTag("structure")
    inst:AddTag("nonpotatable")
	inst:AddTag("prototyper")

    --inst.Light:Enable(false)
    --inst.Light:SetFalloff(.7)
    --inst.Light:SetIntensity(0.6)
    --inst.Light:SetColour(15 / 255, 160 / 255, 180 / 255)
    
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("prototyper")
    inst.components.prototyper.onturnon = onturnon
    inst.components.prototyper.onturnoff = onturnoff
    inst.components.prototyper.onactivate = onactivate
    inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.LG_TECH_ONE

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

return Prefab("lg_sculpture", fn, assets, prefabs),
    MakePlacer("lg_sculpture_placer", "lg_sculpture", "lg_sculpture", "idle")
