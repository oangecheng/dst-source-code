require "prefabutil"

local assets =
{    
    Asset("ANIM", "anim/farm_plow.zip"),
	Asset("ANIM", "anim/medal_farm_plow.zip"),
	Asset("ANIM", "anim/ui_chest_3x3.zip"),
	Asset("ATLAS", "images/medal_farm_plow_item.xml"),
	Asset("ATLAS_BUILD", "images/medal_farm_plow_item.xml",256),
}

local prefabs =
{
	"medal_farm_plow_item",
	"medal_farm_plow_item_placer",
	"tile_outline",
    -- "farm_soil_debris",
    "farm_soil",
	"dirt_puff",
}
--转移容器内种子(原容器,新容器)
local function transferSeeds(inst,obj)
	if inst.components.container and not inst.components.container:IsEmpty() then
		if obj.components.container then
			-- local allseeds=inst.components.container:RemoveAllItems()
			local allseeds=inst.components.container:RemoveAllItemsWithSlot()
			if allseeds then
				for k,v in pairs(allseeds) do
					obj.components.container:GiveItem(v,k)
				end
			end
		end
	end
end

--被锤
local function onhammered(inst)
	local x, y, z = inst.Transform:GetWorldPosition()

	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(x, y, z)
	if inst.components.container ~= nil then
	    inst.components.container:DropEverything()
	end

	if inst.deploy_item_save_record ~= nil then
        local item = SpawnSaveRecord(inst.deploy_item_save_record)
		item.Transform:SetPosition(x, y, z)
	end

    inst:Remove()
end

--清除地陷
local function clearhole(inst)
	if inst.remainingrepairs then
		for i=1,inst.remainingrepairs do
			inst:PushEvent("timerdone", {name = "nextrepair"})
		end
	else
		inst.remainingrepairs=1
		inst:PushEvent("timerdone", {name = "nextrepair"})
	end
end
--耕地时需要排除的标签
local TILLSOIL_IGNORE_TAGS = { "NOBLOCK", "player", "FX", "INLIMBO", "DECOR", "WALKABLEPLATFORM", "soil", "medal_farm_plow","flying","companion","_inventoryitem" }
--生成土堆
local function spawn_farm_soil(inst, x,y,z)
	local cx, cy, cz = TheWorld.Map:GetTileCenterPoint(x,y,z)--获取地皮中心坐标点
	local spacing=1.3--土堆间距
	local farm_plant_pos={}--农场作物坐标
	--清除这块地皮上多余的土堆
	local ents = TheWorld.Map:GetEntitiesOnTileAtPoint(cx, 0, cz)
	for _, ent in ipairs(ents) do
		if ent ~= inst and ent:HasTag("soil") then--是土堆，则清除
			ent:PushEvent("collapsesoil")
		elseif ent:HasTag("antlion_sinkhole") then--地陷，清除
			clearhole(ent)
		end
	end
	--生成整齐的土堆
	for i=0,2 do
		for j=0,2 do
			local nx=cx+spacing*i-spacing
			local nz=cz+spacing*j-spacing
			--根据视角方向调整生成坐标位置，视角方向需要根据之前记录的方向来获取
			local direction = inst.medal_direction or (TheCamera and TheCamera:GetHeadingTarget())
			-- if i==0 and j==0 then TheNet:Announce("使用视角:"..(direction or "不存在")) end
			if direction then
				direction=direction%360
				if direction>=270 then
					nx=cx+spacing*j-spacing
					nz=cz+spacing-spacing*i
				elseif direction>=180 then
					nx=cx+spacing-spacing*i
					nz=cz+spacing-spacing*j
				elseif direction>=90 then
					nx=cx+spacing-spacing*j
					nz=cz+spacing*i-spacing
				end
			end
			
			local spawnItem="farm_soil"--生成的预置物名,默认为土堆
			local removeItem=nil--移除的种子
			if inst.components.container then
				-- slotItem = inst.components.container:GetItemInSlot(i*3+j+1)
				--在对应格子取一颗种子
				removeItem= inst.components.container:RemoveItem(inst.components.container:GetItemInSlot(i*3+j+1))
				if removeItem and removeItem.components.farmplantable then
					--获取植株名称
					spawnItem=FunctionOrValue(removeItem.components.farmplantable.plant,removeItem)
				end
			end
			--生成预制物并移除消耗的种子
			if TheWorld.Map:IsDeployPointClear(Vector3(nx, 0, nz), nil, GetFarmTillSpacing(), nil, nil, nil, TILLSOIL_IGNORE_TAGS) then
				local plant = SpawnPrefab(spawnItem)
    			plant.Transform:SetPosition(nx, 0, nz)
    			plant:PushEvent("on_planted", {in_soil = true, doer = inst.bindeployer, seed = removeItem})
				-- SpawnPrefab(spawnItem).Transform:SetPosition(nx, 0, nz)
				if removeItem and spawnItem~="farm_soil" then
					removeItem:Remove()
					spawnItem=nil
				end
			end
			--返还未消耗的种子
			if spawnItem then
				inst.components.container:GiveItem(removeItem,i*3+j+1)
			end
		end
	end
	
	-- if inst ~= nil and inst.SoundEmitter ~= nil then
	-- 	inst.SoundEmitter:PlaySound("dontstarve/common/plant")
	-- end
end

--耕地机折叠完毕
local function item_foldup_finished(inst)
	inst:RemoveEventCallback("animqueueover", item_foldup_finished)
	inst.AnimState:PlayAnimation("idle_packed")
	inst.components.inventoryitem.canbepickedup = true
	if inst.bindeployer and inst:IsNear(inst.bindeployer,5) then
		if inst.bindeployer.components.inventory then
			inst.bindeployer.components.inventory:GiveItem(inst,nil,inst:GetPosition())
		end
	end
end

--工作完成
local function Finished(inst, force_fx)
	local x, y, z = inst.Transform:GetWorldPosition()
	--如果有耕地机的道具记录，则在原地生成对应预置物，否则播放崩坏特效
	if inst.deploy_item_save_record ~= nil then
        local item = SpawnSaveRecord(inst.deploy_item_save_record)--生成耕地机
		item.Transform:SetPosition(x, y, z)
		item.components.inventoryitem.canbepickedup = false--暂时不可捡起来，因为还在播动画
		transferSeeds(inst,item)--转移容器种子

		item.bindeployer=inst.bindeployer--绑定使用者
		item.AnimState:PlayAnimation("collapse", false)--播放耕地机折叠的动画
		item:ListenForEvent("animqueueover", item_foldup_finished)--折叠完毕

	    item.SoundEmitter:PlaySound("farming/common/farm/plow/collapse")
		--生成烟尘特效
		SpawnPrefab("dirt_puff").Transform:SetPosition(x, y, z)
	    item.SoundEmitter:PlaySound("farming/common/farm/plow/dirt_puff")
	else
		SpawnPrefab("collapse_small").Transform:SetPosition(x, y, z)--生成崩坏特效
		if inst.components.container ~= nil then
		    inst.components.container:DropEverything()
		end
	end

    inst:Remove()
end
--钻地
local function DoDrilling(inst)
	inst:RemoveEventCallback("animover", DoDrilling)--移除动画结束监听
	--循环播放钻地动画
	inst.AnimState:PlayAnimation("drill_loop", true)
    inst.SoundEmitter:PlaySound("farming/common/farm/plow/LP", "loop")
	
	--添加钻地定时器
	if not inst.components.timer:TimerExists("drilling") then
		inst.components.timer:StartTimer("drilling", 1)
	end
	
	local x, y, z = inst.Transform:GetWorldPosition()
	--是耕地地皮则进行耕地
	if TheWorld.Map:GetTileAtPoint(x, 0, z) == GROUND.FARMING_SOIL then
		inst:DoTaskInTime(0.5,spawn_farm_soil,x,y,z)--延迟0.5秒生成土堆，为了契合动画播放速度
	else--非耕地则清除周围地陷
		for i, v in ipairs(TheSim:FindEntities(x, 0, z, 3, {"antlion_sinkhole"})) do
		    v:DoTaskInTime(0.5,clearhole)
		end
	end
end
--监听定时器结束
local function timerdone(inst, data)
	if data ~= nil and data.name == "drilling" then
		Finished(inst)
	end
end
--开始工作
local function StartUp(inst)
    inst.AnimState:PlayAnimation("drill_pre")--先播放准备动画
	inst:ListenForEvent("animover", DoDrilling)--准备动画播放完毕后开始钻地
	inst.SoundEmitter:PlaySound("farming/common/farm/plow/drill_pre")--播放准备动画音效

	inst.startup_task = nil--清除开始工作的延时任务
end
--存储
local function OnSave(inst, data)
	data.deploy_item = inst.deploy_item_save_record--存储耕地机道具的数据
end
--通过后加载
local function OnLoadPostPass(inst, newents, data)
	if data ~= nil then
		inst.deploy_item_save_record = data.deploy_item--读取耕地机道具的数据
	end
	--如果钻地定时器存在，就取消掉开始工作的延时任务，并执行钻地函数
	if inst.components.timer:TimerExists("drilling") then
		if inst.startup_task ~= nil then
			inst.startup_task:Cancel()
			inst.startup_task = nil
		end
		DoDrilling(inst)
	end
end

local function main_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeObstaclePhysics(inst, 0.5)

    inst.AnimState:SetBank("farm_plow")
    inst.AnimState:SetBuild("medal_farm_plow")

    inst:AddTag("scarytoprey")
	inst:AddTag("medal_farm_plow")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	
	inst:AddComponent("container")
	inst.components.container:WidgetSetup("medal_farm_plow")--设置容器
	inst.components.container.canbeopened = false

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(onhammered)

    inst:AddComponent("timer")

    MakeMediumBurnable(inst, nil, nil, true)
    MakeLargePropagator(inst)

	inst.deploy_item_save_record = nil--耕地机道具记录器，方便完成工作后返还给玩家

	inst.startup_task = inst:DoTaskInTime(0, StartUp)--加载完毕后开始工作

	inst:ListenForEvent("timerdone", timerdone)--监听定时器结束


	inst.OnSave = OnSave
	inst.OnLoadPostPass = OnLoadPostPass

    return inst
end

--部署时执行函数
local function item_ondeploy(inst, pt, deployer)
    local cx, cy, cz = TheWorld.Map:GetTileCenterPoint(pt:Get())

    local obj = SpawnPrefab("medal_farm_plow")
	obj.Transform:SetPosition(cx, cy, cz)
	transferSeeds(inst,obj)--转移容器种子
	--这里记录一下玩家的摄像头方向
	if deployer and deployer.player_classified then
		obj.medal_direction=deployer.player_classified.medalcameraheading and deployer.player_classified.medalcameraheading:value() or 45
		-- print(obj.medal_direction)
	end
	
	inst.components.finiteuses:Use(1)
	if inst:IsValid() then
		obj.deploy_item_save_record = inst:GetSaveRecord()--把耕地机道具的数据记录下来
		obj.bindeployer=deployer--绑定使用者
		inst:Remove()
	end
end

--可以部署的地皮
local function can_plow_tile(inst, pt, mouseover, deployer)
	local x, z = pt.x, pt.z
	--是农场地皮
	if TheWorld.Map:GetTileAtPoint(x, 0, z) == GROUND.FARMING_SOIL then
		--获取这块地皮上的预置物，不能有农作物
		-- local ents = TheWorld.Map:GetEntitiesOnTileAtPoint(x, 0, z)
		-- for _, ent in ipairs(ents) do
		-- 	if ent ~= inst and ent:HasTag("farm_plant") then
		-- 		return false
		-- 	end
		-- end
		return true
	end
	--地皮中心点在地陷周围
	local cx, cy, cz = TheWorld.Map:GetTileCenterPoint(pt:Get())
	for _, v in ipairs(TheSim:FindEntities(cx, 0, cz, 3, {"antlion_sinkhole"})) do
	    return true
	end

	return false
end
--耐久用完
local function onFinishedFn(inst)
	if inst.components.deployable then
		inst:RemoveComponent("deployable")
	end
end

--设置可部署函数
local function setDeployable(inst)
	inst:AddComponent("deployable")
	inst.components.deployable:SetDeployMode(DEPLOYMODE.CUSTOM)--自定义部署模式
	inst.components.deployable.ondeploy = item_ondeploy
end

local function item_fn()
    local inst = CreateEntity()
   
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("farm_plow")
    inst.AnimState:SetBuild("medal_farm_plow")
    inst.AnimState:PlayAnimation("idle_packed")

    inst:AddTag("usedeploystring")
    inst:AddTag("tile_deploy")

	MakeInventoryFloatable(inst, "small", 0.1, 0.8)

	inst._custom_candeploy_fn = can_plow_tile --部署许可判断函数

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst)
			inst.replica.container:WidgetSetup("medal_farm_plow") 
		end
		return inst
    end

    inst:AddComponent("inspectable")
	
	inst:AddComponent("container")
	inst.components.container:WidgetSetup("medal_farm_plow")--设置容器

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "medal_farm_plow_item"
    inst.components.inventoryitem.atlasname = "images/medal_farm_plow_item.xml"

	-- inst:AddComponent("deployable")
	-- inst.components.deployable:SetDeployMode(DEPLOYMODE.CUSTOM)--自定义部署模式
	-- inst.components.deployable.ondeploy = item_ondeploy
	setDeployable(inst)

	inst:AddComponent("finiteuses")
    -- inst.components.finiteuses:SetOnFinished(inst.Remove)
	inst.components.finiteuses:SetOnFinished(onFinishedFn)
    inst.components.finiteuses:SetMaxUses(TUNING_MEDAL.MEDAL_FARM_PLOW_USES)
    inst.components.finiteuses:SetUses(TUNING_MEDAL.MEDAL_FARM_PLOW_USES)
	inst:ListenForEvent("percentusedchange", function(inst,data)
		if data and data.percent then
			--耐久用完后补充耐久
			if data.percent>0 and inst.components.deployable==nil then
				setDeployable(inst)
			end
		end
	end)

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    MakeHauntableLaunch(inst)

    return inst
end

local function placer_invalid_fn(player, placer)
    if player then
        MedalSay(player,GetString(player, "ANNOUNCE_CANTBUILDHERE_THRONE"))
    end
end

local function placer_fn()
    local inst = CreateEntity()

    inst:AddTag("CLASSIFIED")
    inst:AddTag("NOCLICK")
    inst:AddTag("placer")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.AnimState:SetBank("farm_plow")
    inst.AnimState:SetBuild("medal_farm_plow")
    inst.AnimState:PlayAnimation("idle_place")
    inst.AnimState:SetLightOverride(1)

    inst:AddComponent("placer")
    inst.components.placer.snap_to_tile = true

	inst.outline = SpawnPrefab("tile_outline")
	inst.outline.entity:SetParent(inst.entity)

	inst.components.placer:LinkEntity(inst.outline)

    return inst
end

return  Prefab("medal_farm_plow", main_fn, assets),
		Prefab("medal_farm_plow_item", item_fn, assets, prefabs),
		Prefab("medal_farm_plow_item_placer", placer_fn)
		
