require "prefabutil"

local assets=
{
	Asset("ANIM", "anim/ndnr_tar_extractor.zip"),
	-- Asset("MINIMAP_IMAGE", "tar_extractor"),
	Asset("ANIM", "anim/ndnr_tar_extractor_meter.zip"),
	Asset("IMAGE", "images/ndnr_tar_extractor.tex"),
    Asset("ATLAS", "images/ndnr_tar_extractor.xml"),
}

local RESOURSE_TIME = TUNING.SEG_TIME*4
local POOP_ANIMATION_LENGTH = 70

local function spawnTarProp(inst)
	inst.task_spawn = nil
	local tar = SpawnPrefab("ndnr_tar")

 	local pt = Vector3(inst.Transform:GetWorldPosition()) + Vector3(0,4.5,0)

	local right = TheCamera:GetRightVec()
	local offset = 1.3
	local variation = 0.2
	tar.Transform:SetPosition(pt.x + (right.x*offset) +(math.random()*variation),0, pt.z + (right.z*offset)+(math.random()*variation) )

	tar.AnimState:PlayAnimation("drop")
	tar.AnimState:PushAnimation("idle",true)
	--inst:RemoveEventCallback("animover", spawnTarProp )
	if inst.components.machine:IsOn() and not inst.components.fueled:IsEmpty() then
		inst.startTar(inst)
		inst.AnimState:PlayAnimation("active",true)
	else
		inst.AnimState:PlayAnimation("idle", true)
	end
end

local function makeTar(inst)
	-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/tar_extractor/poop")
	inst.AnimState:PlayAnimation("poop")
	inst.task_spawn = inst:DoTaskInTime(POOP_ANIMATION_LENGTH/30,spawnTarProp)
	inst.task_spawn_time = GetTime()
	inst.task_tar = nil
	--inst:ListenForEvent("animover", spawnTarProp )
end

local function startTar(inst)
	inst.task_tar = inst:DoTaskInTime(RESOURSE_TIME, makeTar )
	inst.task_tar_time = GetTime()
end

local function onBuilt(inst)
	-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/tar_extractor/craft")
	-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/seacreature_movement/splash_medium")
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle",true)

	-- local range = 1
	-- local pt = Vector3(inst.Transform:GetWorldPosition())
	-- local tarpits = TheSim:FindEntities(pt.x, pt.y, pt.z, range, {"tar_source"}, nil)
	-- for i,tarpit in ipairs(tarpits)do
	-- 	if tarpit.components.inspectable then
	-- 		tarpit.components.inspectable.inspectdisabled = true
	-- 	end
	-- end

	local x,y,z = inst.Transform:GetWorldPosition()
	x, y, z = TheWorld.Map:GetTileCenterPoint(x, 0, z)
	inst.Transform:SetPosition(x,0, z)
end

-- local function placeTestFn(inst, pt)
-- 	local range = 1
-- 	local canbuild = false

-- 	local tarpits = TheSim:FindEntities(pt.x, pt.y, pt.z, range, {"tar_source"}, nil)

-- 	if #tarpits > 0 then
-- 		local pt2 = Vector3(tarpits[1].Transform:GetWorldPosition())
-- 		local structures = TheSim:FindEntities(pt2.x, pt2.y, pt2.z, range, {"structure"}, nil)
-- 		if #structures == 0 then
-- 			if inst.parent then
-- 				inst.parent:RemoveChild(inst)
-- 			end
-- 			canbuild = true
-- 			inst.Transform:SetPosition(tarpits[1].Transform:GetWorldPosition())
-- 		end
-- 	end
-- 	return canbuild
-- end

local function onhammered(inst, worker)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")

	inst:Remove()
end


local function onRemove(inst, worker)
	local range = 1
	local pt = Vector3(inst.Transform:GetWorldPosition())
	local tarpits = TheSim:FindEntities(pt.x, pt.y, pt.z, range, {"ndnr_tar_source"}, nil)
	for i,tarpit in ipairs(tarpits)do
		if tarpit.components.inspectable and tarpit.components.inspectable.inspectdisabled == true then
			tarpit.components.inspectable.inspectdisabled = false
		end
	end
end


local function onhit(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("hit")
		if inst.components.machine:IsOn() then
			inst.AnimState:PushAnimation("active",true)
		else
			inst.AnimState:PushAnimation("idle", true)
		end
	end
end

local function onsave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end

    local nowTime = GetTime()

    if inst.task_tar then
		data.task_tar_time = RESOURSE_TIME - (nowTime - inst.task_tar_time)
    end
	if inst.task_spawn then
		data.task_spawn_time = (POOP_ANIMATION_LENGTH/30) - (nowTime - inst.task_spawn_time)
    end
end

local function onload(inst, data)
	if data and data.burnt then
        inst.components.burnable.onburnt(inst)
    end

    inst:DoTaskInTime(0, function()
	    if data.task_tar_time then
	    	if inst.task_tar then
	    		inst.task_tar:Cancel()
	    		inst.task_tar = nil
	    	end
			inst.task_tar = inst:DoTaskInTime(data.task_tar_time, makeTar )
			inst.task_tar_time = GetTime()
	    end
	    if data.task_spawn_time then
	    	if inst.task_spawn then
	    		inst.task_spawn:Cancel()
	    		inst.task_spawn = nil
	    	end
	    	inst.task_spawn = inst:DoTaskInTime(data.task_spawn_time,spawnTarProp)
			inst.task_spawn_time = GetTime()
	    end
	end)
end

local function OnFuelEmpty(inst)
	inst.components.machine:TurnOff()
end

local function TurnOff(inst)
	inst.on = false
	if inst.task_tar then
		inst.task_tar:Cancel()
		inst.task_tar = nil
	end
	inst.components.fueled:StopConsuming()
	inst.AnimState:PlayAnimation("idle")
	inst.SoundEmitter:KillSound("suck")
end

local function TurnOn(inst, instant)
	inst.on = true
	-- local randomizedStartTime = POPULATING
	inst.startTar(inst)
	inst.components.fueled:StartConsuming()
	inst.AnimState:PlayAnimation("active",true)
	-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/tar_extractor/active_LP", "suck")
end

local function CanInteract(inst)
	return  not inst.components.fueled:IsEmpty()
end

local function OnFuelSectionChange(old, new, inst)
	local fuelAnim = inst.components.fueled:GetCurrentSection()
	inst.AnimState:OverrideSymbol("swap_meter", "ndnr_tar_extractor_meter", tostring(fuelAnim))
end

local function ontakefuelfn(inst)
	inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/machine_fuel")
end

local function getstatus(inst, viewer)
	if inst.on then
		if inst.components.fueled and (inst.components.fueled.currentfuel / inst.components.fueled.maxfuel) <= .25 then
			return "LOWFUEL"
		else
			return "ON"
		end
	else
		return "OFF"
	end
end

local function OnCollide(inst, data)
    local boat_physics = data.other.components.boatphysics
    if boat_physics ~= nil then
        local damage_scale = 0.5
        local hit_velocity = math.floor(math.abs(boat_physics:GetVelocity() * data.hit_dot_velocity) * damage_scale / boat_physics.max_velocity + 0.5)
		if hit_velocity > 0 then
			inst.components.workable:WorkedBy(data.other, hit_velocity * 4)
		end
    end
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeWaterObstaclePhysics(inst, 1, 2, 0.75)

	inst.entity:AddMiniMapEntity()
	inst.MiniMapEntity:SetPriority( 5 )
	inst.MiniMapEntity:SetIcon( "ndnr_tar_extractor.tex" )

	inst.AnimState:SetBank("tar_extractor")
	inst.AnimState:SetBuild("ndnr_tar_extractor")
	inst.AnimState:PlayAnimation("idle",true)

	inst:AddTag("ignorewalkableplatforms")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)

	MakeSnowCovered(inst)

	inst:AddComponent("machine")
	inst.components.machine.turnonfn = TurnOn
	inst.components.machine.turnofffn = TurnOff
	inst.components.machine.caninteractfn = CanInteract
	inst.components.machine.cooldowntime = 0.5

	inst:AddComponent("fueled")
	inst.components.fueled:SetDepletedFn(OnFuelEmpty)
	inst.components.fueled.accepting = true
	inst.components.fueled:SetSections(10)
	inst.components.fueled.ontakefuelfn = ontakefuelfn
	inst.components.fueled:SetSectionCallback(OnFuelSectionChange)
	inst.components.fueled:InitializeFuelLevel(TUNING.TOTAL_DAY_TIME*2)
	inst.components.fueled.bonusmult = 5
	inst.components.fueled.secondaryfueltype = "CHEMICAL"

	inst.AnimState:OverrideSymbol("swap_meter", "ndnr_tar_extractor_meter", "10")

	inst:AddTag("structure")
	--MakeLargeBurnable(inst, nil, nil, true)
	--MakeLargePropagator(inst)
	inst.OnSave = onsave
    inst.OnLoad = onload

	inst:ListenForEvent( "onbuilt", function()
		onBuilt(inst)
	end)
	inst:ListenForEvent("on_collide", OnCollide)

	inst.startTar = startTar
	inst.OnRemoveEntity = onRemove

	return inst
end

local function placerfn(inst)
    inst.components.placer.snap_to_tile = true
end

return Prefab( "ndnr_tar_extractor", fn, assets ),
	   MakePlacer( "ndnr_tar_extractor_placer", "tar_extractor", "ndnr_tar_extractor", "idle", nil, nil, nil, nil, nil, nil, placerfn)
