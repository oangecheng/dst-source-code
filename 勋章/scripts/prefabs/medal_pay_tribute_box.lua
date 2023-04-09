local medal_tribute_plans = require("medal_defs/medal_tribute_defs")--奉纳贡品列表
local PLANS_NUM = medal_tribute_plans and #medal_tribute_plans or 1
local EASY_NUM = 30--难度较简单的任务数量
local prefabs =
{
    "medal_gift_fruit",
}

local assets =
{
    Asset("ANIM", "anim/dragonfly_chest.zip"),
	Asset("ANIM", "anim/medal_pay_tribute_box.zip"),
	Asset("ATLAS", "minimap/medal_pay_tribute_box.xml"),
}

--获取贡品表
local function getTributePlan(inst)
	local tribute_id = inst and inst.medal_tribute_id and inst.medal_tribute_id:value()
	if tribute_id ~= nil and medal_tribute_plans ~= nil then
		return medal_tribute_plans[tribute_id]
	end
end
--掉落奖励
local function dropReward(inst,count)
    count = count or 1
    if count > 0 and inst.components.lootdropper then
        for i = 1, count do
            inst.components.lootdropper:SpawnLootPrefab("medal_gift_fruit")
        end
    end
end

--锤爆
local function onhammered(inst, worker)
    local finish_count = 0
    for i, v in ipairs(getTributePlan(inst) or {}) do
		if inst.components.constructionsite:GetMaterialCount(v.type) >= v.amount then
			finish_count = finish_count + 1
		end
	end
    dropReward(inst,math.ceil(finish_count/2))
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

--锤
local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("closed", false)
end
--升级
local function OnConstructed(inst, doer)
	local concluded = true
	for i, v in ipairs(getTributePlan(inst) or {}) do
		if inst.components.constructionsite:GetMaterialCount(v.type) < v.amount then
			concluded = false
			break
		end
	end

	if concluded then
		SpawnPrefab("lucy_ground_transform_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
		dropReward(inst,4)
        inst.components.lootdropper:SpawnLootPrefab("medal_gift_fruit_seed")
        inst:Remove()
	end
end
--设定奉纳ID(inst,指定ID,召唤者)
local function SetTributeId(inst,id,doer)
    if id==nil then
        local randomnum = doer and doer.components.medal_destiny and doer.components.medal_destiny:GetDestiny() or math.random()
        local cycles = TheWorld and TheWorld.state.cycles or 1
        id = math.floor(randomnum*((cycles >80 and PLANS_NUM or EASY_NUM)))+1--80天内刷的任务相对简单
    end
    if inst and id and inst.medal_tribute_id then
        inst.medal_tribute_id:set(id)
    end
end


local function onsave(inst, data)
    if inst.medal_tribute_id then
        data.medal_tribute_id =inst.medal_tribute_id:value()
    end
end

local function onload(inst, data)
    if data and data.medal_tribute_id then
        SetTributeId(inst,data.medal_tribute_id)
    end
end

--获取当前目标列表
local function getMedalInfo(inst)
	local str = STRINGS.MEDAL_INFO.TRIBUTE_TIP1
    for i, v in ipairs(getTributePlan(inst) or {}) do
		str = str .. (STRINGS.NAMES[string.upper(v.type)] or STRINGS.PROPHESYNAMESPEECH[string.upper(v.type)] or v.type) .."*".. v.amount..","
	end
    return str..STRINGS.MEDAL_INFO.TRIBUTE_TIP2
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.5)

    inst.MiniMapEntity:SetIcon("medal_pay_tribute_box.tex")

    inst.AnimState:SetBank("dragonfly_chest")--用龙鳞箱的bank
    inst.AnimState:SetBuild("medal_pay_tribute_box")
    inst.AnimState:PlayAnimation("closed",true)

    inst:AddTag("structure")
	inst:AddTag("showmedalinfo")--显示详细信息

    -- inst.medal_tribute_id = 9--奉纳任务ID
    inst.medal_tribute_id = net_byte(inst.GUID, "medal_tribute_id", "medal_tribute_iddirty")
    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -------------------------
    inst:AddComponent("lootdropper")
	
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

    inst.SetTributeId = SetTributeId
    SetTributeId(inst)

    inst.OnSave = onsave
	inst.OnLoad = onload

    inst.getMedalInfo = getMedalInfo

    return inst
end

return Prefab("medal_pay_tribute_box", fn, assets, prefabs)
