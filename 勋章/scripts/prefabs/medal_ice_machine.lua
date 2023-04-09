require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/medal_ice_machine.zip"),
	Asset("ATLAS", "minimap/medal_ice_machine.xml"),
	Asset("ATLAS", "images/medal_ice_machine.xml"),
	Asset("IMAGE", "images/medal_ice_machine.tex"),
}

local prefabs =
{
    "collapse_small",
	"ice",
}

local MAX_STORE_UP_WATER = 10--最大储水量
local ICE_SPAWN_TIME = 30--产冰周期

--容器是否已满
local function containerIsFull(inst)
	if inst and inst.components.container then
		local numslots=inst.components.container:GetNumSlots()--容器格子数
		for i=1,numslots do
			if inst.components.container.slots[i] then
				--堆叠数量没满就返回flase
				if inst.components.container.slots[i].components.stackable and not inst.components.container.slots[i].components.stackable:IsFull() then
					return false
				end
			else--格子是空的就返回false
				return false
			end
		end
	end
	return true
end

--刷新动画
local function refreshAnim(inst)
	if inst.store_up_water>0 and not containerIsFull(inst) then
		inst.AnimState:PushAnimation("im_off")
	else
		inst.AnimState:PushAnimation("idle1")
	end
end
--锤烂
local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
	inst.components.container:DropEverything()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end
--挨锤
local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
	if inst.store_up_water>0 then
		inst.AnimState:PlayAnimation("hit2")
	else
		inst.AnimState:PlayAnimation("hit1")
	end
	refreshAnim(inst)
	inst.components.container:DropEverything()
	inst.components.container:Close()
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    refreshAnim(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/icebox_craft")
end

--取消定时任务
local function cancelTask(inst)
	-- print("停止运行")
	if inst.spawnice_task then
	    inst.spawnice_task:Cancel()
	    inst.spawnice_task = nil
	end
	inst.AnimState:PlayAnimation("add_water3",false)
	refreshAnim(inst)
end

--产冰
local function spawnIce(inst)
	if inst.store_up_water>0 then
		inst.store_up_water=inst.store_up_water-1
		local ice=SpawnPrefab("ice")
		if ice and inst.components.container then
			inst.components.container:GiveItem(ice)
		end
		-- if inst.components.lootdropper then
		-- 	inst.components.lootdropper:SpawnLootPrefab("ice")
		-- end
		inst.AnimState:PlayAnimation("done",false)
		refreshAnim(inst)
	end
	--水量不足或者容器满了就停止制冰
	if inst.store_up_water<=0 or containerIsFull(inst) then
		cancelTask(inst)
	end
end

--开始运行
local function startRunning(inst)
	--容器满了就停止制冰
	if containerIsFull(inst) then
		cancelTask(inst)
	--水量超过0开始制冰
	elseif inst.store_up_water >0 then
		if inst.spawnice_task==nil then
			-- print("开始运行")
			refreshAnim(inst)
			inst.spawnice_task = inst:DoPeriodicTask(ICE_SPAWN_TIME, spawnIce)
		end
	else--停止运行
		cancelTask(inst)
	end
end
--加水
local function addWater(inst,num)
	if num then
		local oldwaternum=inst.store_up_water
		inst.store_up_water=math.min(inst.store_up_water+num,MAX_STORE_UP_WATER)
		if oldwaternum>0 then
			if oldwaternum<10 then
				inst.AnimState:PlayAnimation("add_water2",false)
			end
		else
			inst.AnimState:PlayAnimation("add_water1",false)
		end
		-- print("剩余水量"..inst.store_up_water)
		startRunning(inst)
		refreshAnim(inst)
	end
end

--失去物品
local function onitemlose(inst,data)
	startRunning(inst)
end

local function onopen(inst)
	inst.SoundEmitter:PlaySound("dontstarve/common/icebox_open")
end

local function onclose(inst)
	inst.SoundEmitter:PlaySound("dontstarve/common/icebox_close")
end

--存储函数
local function onsave(inst, data)
    if inst.store_up_water>0 then
		data.store_up_water = inst.store_up_water
	end
end
--加载函数
local function onload(inst, data)
    if data ~= nil and data.store_up_water then
        inst.store_up_water=data.store_up_water
		startRunning(inst)
    end
end

--显示制冰机剩余水量
local function getMedalInfo(inst)
	if inst.store_up_water then
		return STRINGS.MEDAL_INFO.STOREUPWATER..inst.store_up_water
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, .25)
	inst:SetPhysicsRadiusOverride(.25)

    inst.MiniMapEntity:SetIcon("medal_ice_machine.tex")

    inst.AnimState:SetBank("medal_ice_machine")
    inst.AnimState:SetBuild("medal_ice_machine")
    inst.AnimState:PlayAnimation("idle1",true)

    inst:AddTag("structure")
	inst:AddTag("fridge")--冰箱
	inst:AddTag("canpourwater")--可以加水
	inst:AddTag("medalicemachine")--制冰机
	inst:AddTag("showmedalinfo")--显示详细信息

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("container")
	inst.components.container:WidgetSetup("medal_ice_machine")
	inst.components.container.onopenfn = onopen
	inst.components.container.onclosefn = onclose

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)
	
	inst.store_up_water=0--储水量
	inst.AddWater=addWater--加水函数

    inst:ListenForEvent("onbuilt", onbuilt)
	inst:ListenForEvent("itemlose",onitemlose)
	
	inst.OnSave = onsave
	inst.OnLoad = onload
	
    MakeSnowCovered(inst)
	AddHauntableDropItemOrWork(inst)

	inst.getMedalInfo = getMedalInfo

    return inst
end

return Prefab("medal_ice_machine", fn, assets,prefabs),
    MakePlacer("medal_ice_machine_placer", "medal_ice_machine", "medal_ice_machine", "idle1")
