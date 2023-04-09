require "prefabutil"

local easing = require("easing")

local assets =
{
    Asset("ANIM", "anim/firefighter_placement.zip"),
    Asset("ANIM", "anim/boat_waterpump.zip"),
    Asset("ANIM", "anim/medal_waterpump.zip"),
    Asset("ANIM", "anim/medal_waterpump_skin1.zip"),
	Asset("ATLAS", "images/medal_waterpump.xml"),
}

local item_assets =
{
	Asset("ANIM", "anim/medal_waterpump_item.zip"),
	Asset("ATLAS", "images/medal_waterpump_item.xml"),
	Asset("ATLAS_BUILD", "images/medal_waterpump_item.xml",256),
}

local prefabs =
{
    "waterstreak_projectile",
    "collapse_small",
}

local item_prefabs = 
{
	"medal_waterpump",
}

local RANDOM_OFFSET_MAX = TUNING.WATERPUMP.MAXRANGE

local function onhammered(inst, worker)
    local x, y, z = inst.Transform:GetWorldPosition()

    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end

	local boat = inst:GetCurrentPlatform()
	if boat ~= nil then
		boat:PushEvent("spawnnewboatleak", { pt = Vector3(x, y, z), leak_size = "med_leak", playsoundfx = true })
	end

    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(x, y, z)
    fx:SetMaterial("wood")
    inst:Remove()
end

local function cancel_channeling(inst)
    if inst.channeler ~= nil and inst.channeler:IsValid() then
        inst.channeler:PushEvent("cancel_channel_longaction")
    end
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") and not inst.channeler then
         inst.AnimState:PlayAnimation("use_pst")
    end
end

local function CancelLaunchProjectileTask(inst)
    if inst._launch_projectile_task ~= nil then
        inst._launch_projectile_task:Cancel()
        inst._launch_projectile_task = nil
    end
end

--获取地皮信息函数
local GetTileDataAtPoint
--生成水弹
local function spawnProjectile(inst,targetpos)
	local x, y, z = inst.Transform:GetWorldPosition()
	local projectile = SpawnPrefab("waterstreak_projectile")
	if projectile.components.wateryprotection then
		projectile.components.wateryprotection.addwetness = TUNING.WATERBALLOON_ADD_WETNESS*2--一个加50水分
	end
	projectile.Transform:SetPosition(x, 5, z)

	local dx = targetpos.x - x
	local dz = targetpos.z - z
	local rangesq = dx * dx + dz * dz
	local maxrange = TUNING.WATERPUMP.MAXRANGE
	local speed = easing.linear(rangesq, 8, 3, maxrange * maxrange)
	projectile.components.complexprojectile:SetHorizontalSpeed(speed)
	projectile.components.complexprojectile:SetGravity(-25)
	projectile.components.complexprojectile:Launch(targetpos, inst, inst)
end

local MAX_SOIL_MOISTURE = TUNING.SOIL_MAX_MOISTURE_VALUE--土壤最大水分值
-- local NOTAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO", "burnt", "player", "monster" }
local NOTAGS = { "FX", "INLIMBO", "burnt", "player", "monster" }
local ONEOFTAGS = { "fire", "smolder", "needwater", "wateringcan", "medalicemachine"}
local function LaunchProjectile(inst)
    CancelLaunchProjectileTask(inst)
    local _moisturegrid--地皮湿度信息
    if TheWorld and TheWorld.components.farming_manager and TheWorld.components.farming_manager.IsSoilMoistAtPoint then
        _moisturegrid=MedalGetLocalFn(TheWorld.components.farming_manager.IsSoilMoistAtPoint,"_moisturegrid",true)
    end
    local x, y, z = inst.Transform:GetWorldPosition()

	local ents = TheSim:FindEntities(x, y, z, 15, nil, NOTAGS, ONEOFTAGS)
	local targetpos
	if #ents > 0 then
		local projectile_count=0--水弹数量
		local projectile_max=3--math.random(4)--水弹数量上限
		for _,v in ipairs(ents) do
			local pos=v:GetPosition()
			--灭火
			if v:HasTag("fire") or v:HasTag("smolder") then
				targetpos=pos
				projectile_count=projectile_count+1
			--给田浇水
			elseif v:HasTag("needwater") and _moisturegrid then
				local soilmoisture = _moisturegrid:GetDataAtPoint(TheWorld.Map:GetTileCoordsAtPoint(pos.x, pos.y, pos.z))
                -- print("湿度"..soilmoisture)
                if soilmoisture and soilmoisture<MAX_SOIL_MOISTURE*.8 then
                    targetpos=pos
                    projectile_count=projectile_count+1
                end
			--给水壶灌水
			elseif v:HasTag("wateringcan") then
				if v.components.finiteuses and v.components.finiteuses:GetPercent()<1 then
					targetpos=pos
					projectile_count=projectile_count+1
					v.components.finiteuses:SetPercent(1)
				end
			--给制冰机加水
			elseif v:HasTag("medalicemachine") then
				if v.store_up_water and v.store_up_water<8 then
					if v.AddWater then
						v:AddWater(5)
						targetpos=pos
						projectile_count=projectile_count+1
					end
				end
			end
			if targetpos then
				spawnProjectile(inst,targetpos)
			end
			--单次最多3发水弹
			if projectile_count>=projectile_max then
				break
			end
		end
	end
	--随便乱射
	if targetpos==nil then
		local theta = math.random() * 2 * PI
		local offset = math.random() * RANDOM_OFFSET_MAX
		targetpos = Point(x + math.cos(theta) * offset, 0, z + math.sin(theta) * offset)
		spawnProjectile(inst,targetpos)
	end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.SoundEmitter:PlaySound("dangerous_sea/common/water_pump/place")
    if inst.candrewwater then
		inst.AnimState:Show("fx")
	else
		inst.AnimState:Hide("fx")
	end
end

local PLACER_SCALE = 1.55--1.26

local function OnEnableHelper(inst, enabled)
    if enabled then
        if inst.helper == nil then
            inst.helper = CreateEntity()

            --[[Non-networked entity]]
            inst.helper.entity:SetCanSleep(false)
            inst.helper.persists = false

            inst.helper.entity:AddTransform()
            inst.helper.entity:AddAnimState()


            inst.helper:AddTag("CLASSIFIED")
            inst.helper:AddTag("NOCLICK")
            inst.helper:AddTag("placer")

            inst.helper.Transform:SetScale(PLACER_SCALE, PLACER_SCALE, PLACER_SCALE)

            inst.helper.AnimState:SetBank("firefighter_placement")
            inst.helper.AnimState:SetBuild("firefighter_placement")
            inst.helper.AnimState:PlayAnimation("idle")
            inst.helper.AnimState:SetLightOverride(1)
            inst.helper.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
            inst.helper.AnimState:SetLayer(LAYER_BACKGROUND)
            inst.helper.AnimState:SetSortOrder(1)
            inst.helper.AnimState:SetAddColour(0, .2, .5, 0)
            inst.helper.AnimState:Hide("inner")

            inst.helper.entity:SetParent(inst.entity)
        end
    elseif inst.helper ~= nil then
        inst.helper:Remove()
        inst.helper = nil
    end
end

local function startprojectilelaunch(inst)
    local channeler = inst.channeler

    inst.AnimState:PlayAnimation("use_loop")
    inst.SoundEmitter:PlaySound("dangerous_sea/common/water_pump/LP","pump")
	--灌了水的才能正常抽水
	if inst.candrewwater then
		inst._launch_projectile_task = inst:DoTaskInTime(7*FRAMES, LaunchProjectile)
	end
end
--开始抽水
local function OnStartChanneling(inst, channeler)
    inst.channeler = channeler
    inst.AnimState:PlayAnimation("use_pre")
    inst:ListenForEvent("animover", startprojectilelaunch)
	if inst.candrewwater then
		inst.AnimState:Show("fx")
        if inst.waterloss_task ~= nil then
			inst.waterloss_task:Cancel()
			inst.waterloss_task = nil
		end
	else
		inst.AnimState:Hide("fx")
		MedalSay(channeler,STRINGS.MEDALREMOULD_SPEECH.NEEDWATER)
	end
end
--停止抽水
local function OnStopChanneling(inst)
    inst:RemoveEventCallback("animover", startprojectilelaunch)
    inst.channeler = nil
    if inst._launch_projectile_task then
        inst._launch_projectile_task:Cancel()
        inst._launch_projectile_task = nil
    end
    inst.SoundEmitter:KillSound("pump")
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("use_pst",false)
        inst.AnimState:PushAnimation("idle")
    end
	if inst.candrewwater then
		-- inst.candrewwater=nil
        if inst.waterloss_task ~= nil then
			inst.waterloss_task:Cancel()
			inst.waterloss_task = nil
		end
        inst.waterloss_task = inst:DoTaskInTime(TUNING_MEDAL.WATERPUMP_WATERLOSS_TIME, function(inst)
            inst.candrewwater=nil
        end)
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    --MakeObstaclePhysics(inst, .25)
    inst:SetPhysicsRadiusOverride(0.25)

    inst.AnimState:SetBank("boat_waterpump")
    inst.AnimState:SetBuild("medal_waterpump")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("structure")
    inst:AddTag("pump")
	inst:AddTag("canpourwater")--可以加水
	inst:AddTag("medal_skinable")--可换皮肤

    --Dedicated server does not need deployhelper
    if not TheNet:IsDedicated() then
        inst:AddComponent("deployhelper")
        inst.components.deployhelper.onenablehelper = OnEnableHelper
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("channelable")
    inst.components.channelable:SetChannelingFn(OnStartChanneling, OnStopChanneling)
    inst.components.channelable.use_channel_longaction = true
    inst.components.channelable.skip_state_channeling = true
    inst.components.channelable.skip_state_stopchanneling = true
    inst.components.channelable.ignore_prechannel = true

    inst:ListenForEvent("channel_finished", OnStopChanneling)

    inst.OnStopChanneling = OnStopChanneling

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("medal_skinable")

    MakeHauntableWork(inst)

    inst:ListenForEvent("onbuilt", onbuilt)
    inst:ListenForEvent("onremove", cancel_channeling)

    return inst
end

local function itemfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("medal_waterpump_item")
	inst.AnimState:SetBuild("medal_waterpump_item")
	inst.AnimState:PlayAnimation("idle")
		
	MakeInventoryFloatable(inst,"med",0.1,0.65)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "medal_waterpump_item"
	inst.components.inventoryitem.atlasname = "images/medal_waterpump_item.xml"
		
	inst:AddComponent("inspectable")
	
	MakeHauntableLaunchAndSmash(inst)

	return inst
end

local function placer_postinit_fn(inst)
    --Show the waterpump placer on top of the range ground placer

    inst.AnimState:Hide("inner")

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

    placer2.AnimState:SetBank("boat_waterpump")
    placer2.AnimState:SetBuild("medal_waterpump")
    placer2.AnimState:PlayAnimation("idle")
    placer2.AnimState:SetLightOverride(1)

    placer2.entity:SetParent(inst.entity)

    inst.components.placer:LinkEntity(placer2)
end

return Prefab("medal_waterpump", fn, assets, prefabs),
	Prefab("medal_waterpump_item", itemfn, item_assets, item_prefabs),
    MakePlacer("medal_waterpump_placer", "firefighter_placement", "firefighter_placement", "idle", true, nil, nil, PLACER_SCALE, nil, nil, placer_postinit_fn)
