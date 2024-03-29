require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/ndnr_sprinkler.zip"),

	Asset("ANIM", "anim/ndnr_sprinkler_meter.zip"),
	-- Asset("MINIMAP_IMAGE", "firesuppressor"),
    Asset("IMAGE", "images/ndnr_sprinkler.tex"),
    Asset("ATLAS", "images/ndnr_sprinkler.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_sprinkler.xml", 256),
}

local projectile_assets =
{
	Asset("ANIM", "anim/firefighter_projectile.zip")
}

local RANGE = 10

local function spawndrop(inst)
	local drop = SpawnPrefab("ndnr_raindrop")
	local pt = Vector3(inst.Transform:GetWorldPosition())
	local angle = math.random()*2*PI
	local dist = math.random()*RANGE
	local offset = Vector3(dist * math.cos( angle ), 0, -dist * math.sin( angle ))
	drop.Transform:SetPosition(pt.x+offset.x,0,pt.z+offset.z)

	drop.components.complexprojectile:SetHorizontalSpeed(0)
	drop.components.complexprojectile:SetGravity(-25)
	drop.components.complexprojectile:Launch(pt, inst, inst)
end

local function initWaterSpray(inst)
	if inst.pipes and #inst.pipes > 0 then
		if not inst.waterSpray then
			inst.waterSpray = SpawnPrefab("ndnr_water_spray")
			local follower = inst.waterSpray.entity:AddFollower()
			follower:FollowSymbol(inst.GUID, "top", 0, -100, 0)
		end
		inst.droptask = inst:DoPeriodicTask(0.2,function() spawndrop(inst) end)
	end
end

local function TurnOn(inst)
	inst.components.fueled:StartConsuming()
	initWaterSpray(inst)
	inst.sg:GoToState("turn_on")
end

local function TurnOff(inst)
	inst.components.fueled:StopConsuming()

	if inst.waterSpray then
		inst.waterSpray:Remove()
		inst.waterSpray = nil
	end

	if inst.droptask then
		inst.droptask:Cancel()
		inst.droptask = nil
	end

	-- if inst.spraytask then
	-- 	inst.spraytask:Cancel()
	-- 	inst.spraytask = nil
	-- end


	-- if inst.moisture_targets then
	-- 	for GUID, i in pairs(inst.moisture_targets)do
	-- 		print("TURN OFF",i.prefab)
	-- 		if i.components.moisture then
	-- 			i.components.moisture.moisture_sources[inst.GUID] = nil
	-- 		end
	-- 		if i.growwithsprinkler then
	-- 			i:RemoveTag("sprinkled")
	-- 			i.testForGrowth(i)
	-- 		end
	-- 	end
	-- end

	inst.sg:GoToState("turn_off")
end

local function OnFuelEmpty(inst)
	inst.components.machine:TurnOff()
end

local function OnAddFuel(inst)
	inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/machine_fuel")
    if not inst.components.machine:IsOn() then
        inst.components.machine:TurnOn()
    end
end

local function OnFuelSectionChange(new, old, inst)
	inst.AnimState:OverrideSymbol("swap_meter", "ndnr_sprinkler_meter", tostring(new))
end

local function CanInteract(inst)
	local nopipes = not inst.pipes or #inst.pipes == 0
	return not inst.components.fueled:IsEmpty() and not nopipes
end

local function GetStatus(inst, viewer)
	if inst.components.machine:IsOn() then
		return "ON"
	else
		return "OFF"
	end
end

local function OnBuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle_off")
	inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_craft")
end

-- local function UpdateSpray(inst)
--     local x, y, z = inst.Transform:GetWorldPosition()
--     local ents = TheSim:FindEntities(x, y, z, RANGE)

-- 	if not inst.moisture_targets then
-- 		inst.moisture_targets = {}
-- 	end
-- 	inst.moisture_targets_old = {}
-- 	for GUID,v in pairs(inst.moisture_targets) do
--     	inst.moisture_targets_old[GUID] = v
-- 	end
--     inst.moisture_targets = {}

--     for k,v in pairs(ents) do
--     	inst.moisture_targets[v.GUID] = v
-- 		if v.components.moisture then
-- 			if not v.components.moisture.moisture_sources then
-- 				v.components.moisture.moisture_sources = {}
-- 			end
-- 			v.components.moisture.moisture_sources[inst.GUID] = inst.moisturizing
-- 		end

-- 		if v.components.moisturelistener and not (v.components.inventoryitem and v.components.inventoryitem.owner) then

-- 			v.components.moisturelistener:AddMoisture(TUNING.NDNR_MOISTURE_SPRINKLER_PERCENT_INCREASE_PER_SPRAY)
-- --[[
-- 			local moisture = v.components.moisturelistener:GetMoisture() --/ TUNING.MOISTURE_MAX_WETNESS
-- 			print("moisture",moisture)
-- 			--print(v.components.moisturelistener:GetMoisture(),TUNING.MOISTURE_MAX_WETNESS,"moisture_percent",moisture_percent)
-- 			moisture = math.min(100,moisture + (TUNING.MOISTURE_SPRINKLER_PERCENT_INCREASE_PER_SPRAY / 100))
-- 			print("moisture_percent",moisture/100)
-- 			v.components.moisturelistener:Soak(moisture/100)
-- 	]]
-- 		end


-- 		if v.components.crop and v.components.crop.task then

-- 			v.components.crop.growthpercent = v.components.crop.growthpercent + (0.001)
-- 		end

-- 		if v.components.burnable and not (v.components.inventoryitem and v.components.inventoryitem.owner) then
-- 			v.components.burnable:Extinguish()
-- 		end

-- 		if v.growwithsprinkler then
-- 			v:AddTag("sprinkled")
-- 			v.testForGrowth(v)
-- 		end
-- 	end

-- 	for GUID,v in pairs(inst.moisture_targets_old)do
-- 		local still_affected = false
-- 		for iGUID, i in pairs(inst.moisture_targets)do
-- 			if GUID == iGUID then
-- 				still_affected = true
-- 				break
-- 			end
-- 		end
-- 		if not still_affected then
-- 			if v.components.moisture then
-- 				v.components.moisture.moisture_sources[inst.GUID] = nil
-- 			end
-- 			--dumptable(v.components.moisture.moisture_sources,1,1,1)

-- 			if v.growwithsprinkler then
-- 				v:RemoveTag("sprinkled")
-- 				v.testForGrowth(v)
-- 			end
-- 		end
-- 	end
-- end

local function IsWater(tile)
	return false
	-- return GetWorld().Map:IsWater(tile)
--[[
	return tile == GROUND.OCEAN_MEDIUM or
		tile == GROUND.OCEAN_DEEP or
		tile == GROUND.OCEAN_SHALLOW or
		tile == GROUND.OCEAN_SHORE or
		tile == GROUND.OCEAN_CORAL or
		tile == GROUND.OCEAN_CORAL_SHORE or
		tile == GROUND.OCEAN_SHIPGRAVEYARD or
		tile == GROUND.MANGROVE or
		tile == GROUND.MANGROVE_SHORE or
		tile == GROUND.LILYPOND
		]]
end

local function IsValidSprinklerTile(tile)
	return not IsWater(tile) and (tile ~= GROUND.INVALID) and (tile ~= GROUND.IMPASSIBLE)
end

local function GetValidWaterPointNearby(pt)
	local range = 20

	local min_sq_dist = 999999999999
	local best_point = nil

	for x = pt.x - range, pt.x + range, 1 do
		for z = pt.z - range, pt.z + range, 1 do
			-- local tx, ty = GetWorld().Map:GetTileCoordsAtPoint(x, 0, z)
			local tile = TheWorld.Map:GetTileAtPoint(x, 0, z)

			if IsOceanTile(tile) then
				local cur_point = Vector3(x, 0, z)
				local cur_sq_dist = cur_point:DistSq(pt)

				if cur_sq_dist < min_sq_dist then
					min_sq_dist = cur_sq_dist
					best_point = cur_point
				end
			end
		end
	end

	return best_point
end

local function PlaceTestFn(inst, pt)
	return GetValidWaterPointNearby(pt) ~= nil
end

local function RotateToTarget(inst, dest)
    local px, py, pz = inst.Transform:GetWorldPosition()
    local dz = pz - dest.z
    local dx = dest.x - px
    local angle = math.atan2(dz, dx) / DEGREES

    -- Offset angle to account for pipe orientation in file.sa
    local OFFSET_ANGLE = 90
	inst.Transform:SetRotation(angle - OFFSET_ANGLE)
end

local function CreatePipes(inst)

	local P0 = Vector3(inst.Transform:GetWorldPosition())
	local P1 = GetValidWaterPointNearby(P0)

	inst.pipes = {}

	if P1 then
		local x, y, z = TheWorld.Map:GetTileCenterPoint(P1.x, 0, P1.z)
		P1 = Vector3(x,y,z)
		local totalDist = P1:Dist(P0)
		local pipeLength = 2
		local metricPipeLength = pipeLength / totalDist

		for t = 0.0, 1.0, metricPipeLength do
			local Pt = (P1 - P0)*t + P0
			local pipe = SpawnPrefab("ndnr_water_pipe")
			pipe.Transform:SetPosition(Pt.x, 0, Pt.z)
			pipe.pipelineOwner = inst

			RotateToTarget(pipe, P1)

			table.insert(inst.pipes, pipe)
		end
	end
end

local function DestroyPipes(inst)
	for i, pipe in ipairs(inst.pipes) do
		pipe:Remove()
	end
end

local function ConnectPipes(inst)
	local numPipes = #inst.pipes

	if numPipes > 2 then
		for i = 2, numPipes, 1 do
			inst.pipes[i - 1].nextPipe = inst.pipes[i]
			inst.pipes[i].prevPipe = inst.pipes[i - 1]
		end
	end
end

local function ExtendPipes(inst)
	if inst.loadedPipesFromFile then
		for i, pipe in ipairs(inst.pipes) do
			pipe.sg:GoToState("idle")
		end
	else
		if #inst.pipes > 0 then
			inst.pipes[1].sg:GoToState("extend",1)
		end
	end
end

local function RetractPipes(inst)
	if inst.pipes and #inst.pipes > 0 then
		inst.pipes[#inst.pipes].sg:GoToState("retract",#inst.pipes)
	end
end

local function OnHit(inst, worker)
	if not inst:HasTag("burnt") then
		if not inst.sg:HasStateTag("busy") then
			inst.sg:GoToState("hit")
		end
	end
end

local function OnHammered(inst, worker)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end

	inst.SoundEmitter:KillSound("idleloop")
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	TurnOff(inst)
	RetractPipes(inst)
	inst:Remove()
end


local function OnEntitySleep(inst)
    inst.SoundEmitter:KillSound("firesuppressor_idle")
end

local function OnSave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end

    data.pipes = {}
    data.pipeAngles = {}

    local refs = {}

    for i, pipe in ipairs(inst.pipes) do
    	table.insert(refs, pipe.GUID)
    	table.insert(data.pipes, pipe.GUID)
    	table.insert(data.pipeAngles, pipe.Transform:GetRotation())
    end

    -- if inst.waterSpray then
	--     data.waterSpray = inst.waterSpray.GUID
	--     table.insert(refs, inst.waterSpray.GUID)
	-- end

    return refs
end

local function OnLoad(inst, data)
	if data and data.burnt and inst.components.burnable and inst.components.burnable.onburnt then
        inst.components.burnable.onburnt(inst)
    end
end

--[[
	OnLoadPostPass 方法在所有Prefab都加载完后会执行
	但在Prefab初创时，是不会执行这个方法的
	它只会在保存游戏重新加载时才会执行
]]
local function OnLoadPostPass(inst, newents, data)
	inst.pipes = {}
	inst.loadedPipesFromFile = false

	-- if data and data.waterSpray then
	-- 	inst.waterSpray = newents[data.waterSpray] and newents[data.waterSpray].entity
	-- end

    if data and data.pipes then
        for i, pipe in ipairs(data.pipes) do
        	local newpipe = newents[pipe].entity

        	if newpipe then
				newpipe.pipelineOwner = inst
        		table.insert(inst.pipes, newpipe)
        		inst.pipes[i].Transform:SetRotation(data.pipeAngles[i])
        		inst.loadedPipesFromFile = true
        	end
        end
    end
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.entity:AddMiniMapEntity()
	inst.MiniMapEntity:SetPriority(5)
	inst.MiniMapEntity:SetIcon("ndnr_sprinkler.tex")

	MakeObstaclePhysics(inst, 1)

	inst.AnimState:SetBank("sprinkler")
	inst.AnimState:SetBuild("ndnr_sprinkler")
	inst.AnimState:PlayAnimation("idle_off")

	inst.entity:SetPristine()
	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("machine")
	inst.components.machine.turnonfn = TurnOn
	inst.components.machine.turnofffn = TurnOff
	inst.components.machine.caninteractfn = CanInteract
	inst.components.machine.cooldowntime = 0.5

	inst:AddComponent("fueled")
	inst.components.fueled:SetDepletedFn(OnFuelEmpty)
	inst.components.fueled.accepting = true
	inst.components.fueled:SetSections(10)
	inst.components.fueled:SetTakeFuelFn(OnAddFuel)
	inst.components.fueled:SetSectionCallback(OnFuelSectionChange)
	inst.components.fueled:InitializeFuelLevel(TUNING.TOTAL_DAY_TIME*3)
	inst.components.fueled.bonusmult = 5
	inst.components.fueled.secondaryfueltype = FUELTYPE.CHEMICAL

	inst.AnimState:OverrideSymbol("swap_meter", "ndnr_sprinkler_meter", "10")

	inst:AddComponent("lootdropper")
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetOnWorkCallback(OnHit)

	inst:SetStateGraph("SGndnr_sprinkler")

	-- inst.moisturizing = 2
	-- inst.UpdateSpray = UpdateSpray

	inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnLoadPostPass = OnLoadPostPass
    inst.OnEntitySleep = OnEntitySleep

    MakeHauntableWork(inst)
	MakeSnowCovered(inst)

	inst:ListenForEvent("onbuilt", OnBuilt)

	inst:DoTaskInTime(0.1,
		function()
			if not inst.pipes or (#inst.pipes < 1) then
				CreatePipes(inst)
			end

			ConnectPipes(inst)
			ExtendPipes(inst)

			if inst.components.machine:IsOn() then
				initWaterSpray(inst)
			end
		end)

	-- inst.waterSpray = nil

	return inst
end

local function OnHit(inst, dist)
	-- inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_impact")
	SpawnPrefab("splash_snow_fx").Transform:SetPosition(inst:GetPosition():Get())
	inst:Remove()
end

local PLACER_SCALE = 1.32

local function placer_postinit_fn(inst)
    --Show the flingo placer on top of the flingo range ground placer

    local placer2 = CreateEntity()

    --[[Non-networked entity]]
    placer2.entity:SetCanSleep(false)
    placer2.persists = false

    placer2.entity:AddTransform()
    placer2.entity:AddAnimState()

    placer2:AddTag("CLASSIFIED")
    placer2:AddTag("NOCLICK")
    placer2:AddTag("placer")

    local s = 1 / PLACER_SCALE
    placer2.Transform:SetScale(s, s, s)

    placer2.AnimState:SetBank("sprinkler")
    placer2.AnimState:SetBuild("ndnr_sprinkler")
    placer2.AnimState:PlayAnimation("idle_off")
    placer2.AnimState:SetLightOverride(1)

    placer2.entity:SetParent(inst.entity)

    inst.components.placer:LinkEntity(placer2)
end

return Prefab("ndnr_sprinkler", fn, assets),
	MakePlacer("ndnr_sprinkler_placer", "firefighter_placement", "firefighter_placement", "idle", true, nil, nil, PLACER_SCALE, nil, nil, placer_postinit_fn)
