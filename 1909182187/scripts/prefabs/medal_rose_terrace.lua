local prefabs =
{
    "honey",
	"honeycomb",
}

local assets =
{
    Asset("ANIM", "anim/medal_rose_terrace.zip"),
    Asset("SOUND", "sound/bee.fsb"), --replace with wasp
	Asset("ATLAS", "minimap/medal_rose_terrace.xml"),
}

--锤爆
local function onhammered(inst, worker)
    inst.AnimState:PlayAnimation("cocoon_dead", true)
    -- RemovePhysicsColliders(inst)
    inst.SoundEmitter:PlaySound("dontstarve/bee/beehive_destroy")
    inst.components.lootdropper:DropLoot(inst:GetPosition())
    inst:Remove()
end

--锤
local function onhit(inst, worker)
    inst.SoundEmitter:PlaySound("dontstarve/bee/beehive_hit")
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", true)
end
--升级
local function OnConstructed(inst, doer)
	local concluded = true
	for i, v in ipairs(CONSTRUCTION_PLANS[inst.prefab] or {}) do
		if inst.components.constructionsite:GetMaterialCount(v.type) < v.amount then
			concluded = false
			break
		end
	end

	if concluded then
		SpawnPrefab("lucy_ground_transform_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
		ReplacePrefab(inst, "medal_beequeenhive")
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.5)

    inst.MiniMapEntity:SetIcon("medal_rose_terrace.tex")

    inst.AnimState:SetBank("medal_rose_terrace")
    inst.AnimState:SetBuild("medal_rose_terrace")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("structure")
    inst:AddTag("hive")
    inst:AddTag("WORM_DANGER")
	inst:AddTag("medal_beequeen")--凋零之蜂标签(用来确认世界唯一性)

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -------------------------
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "honey", "honey", "honey", "honeycomb" })
	
	inst:AddComponent("constructionsite")
	inst.components.constructionsite:SetConstructionPrefab("construction_container")
	inst.components.constructionsite:SetOnConstructedFn(OnConstructed)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)--需要锤多少下
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)
	
    MakeLargeBurnable(inst)
    MakeMediumPropagator(inst)
    MakeSnowCovered(inst)
	
    inst:AddComponent("inspectable")

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_MEDIUM)

    return inst
end

return Prefab("medal_rose_terrace", fn, assets, prefabs)
