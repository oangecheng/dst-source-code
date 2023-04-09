require "prefabutil"

local assets =
{
	Asset("MINIMAP_IMAGE", "archive_resonator"),
    Asset("ANIM", "anim/archive_resonator.zip"),
    Asset("ANIM", "anim/medal_resonator.zip"),
    Asset("ATLAS", "images/medal_resonator_item.xml"),
	Asset("ATLAS_BUILD", "images/medal_resonator_item.xml",256),
}

local prefabs =
{

}
--光照参数组
local light_params =
{
    on =
    {
        radius = 2,
        intensity = .4,
        falloff = .6,
        colour = {237/255, 237/255, 209/255},
        time = 0.2,
    },

    off =
    {
        radius = 0,
        intensity = 0,
        falloff = 0.6,
        colour = { 0, 0, 0 },
        time = 1,
    },

    beam =
    {
        radius = 4,
        intensity = .8,
        falloff = .6,
        colour = { 237/255, 237/255, 209/255 },
        time = 0.4,
    },

    idle =
    {
        radius = 1,
        intensity = .4,
        falloff = .6,
        colour = {237/255, 237/255, 209/255},
        time = 0.2,
    },
}
--根据参数设定光照
local function pushparams(inst, params)
    inst.Light:SetRadius(params.radius * inst.widthscale)
    inst.Light:SetIntensity(params.intensity)
    inst.Light:SetFalloff(params.falloff)
    inst.Light:SetColour(unpack(params.colour))

    if params.intensity > 0 then
        inst.Light:Enable(true)
    else
        inst.Light:Enable(false)
    end

end

--复制参数表(这里不用deepcopy，因为是直接覆盖现有的表)
local function copyparams(dest, src)
    for k, v in pairs(src) do
        if type(v) == "table" then
            dest[k] = dest[k] or {}
            copyparams(dest[k], v)
        else
            dest[k] = v
        end
    end
end
--光照过渡参数计算
local function lerpparams(pout, pstart, pend, lerpk)
    for k, v in pairs(pend) do
        if type(v) == "table" then
            lerpparams(pout[k], pstart[k], v, lerpk)
        else
            pout[k] = pstart[k] * (1 - lerpk) + v * lerpk
        end
    end
end
--更新光照
local function OnUpdateLight(inst, dt)
    inst._currentlight.time = inst._currentlight.time + dt
    if inst._currentlight.time >= inst._endlight.time then
        inst._currentlight.time = inst._endlight.time
        inst._lighttask:Cancel()
        inst._lighttask = nil
    end
    lerpparams(inst._currentlight, inst._startlight, inst._endlight, inst._endlight.time > 0 and inst._currentlight.time / inst._endlight.time or 1)
    pushparams(inst, inst._currentlight)
    inst.AnimState:SetLightOverride(Remap(inst._currentlight.intensity, light_params.off.intensity,light_params.beam.intensity, 0,1))
end
--光照开始渐变
local function beginfade(inst)
    copyparams(inst._startlight, inst._currentlight)
    inst._currentlight.time = 0
    inst._startlight.time = 0

    if inst._lighttask == nil then
        inst._lighttask = inst:DoPeriodicTask(FRAMES, OnUpdateLight, nil, FRAMES)
    end
end
--转移容器内藏宝图
local function transferTreasureMap(inst,obj)
	if inst.components.container and obj.components.container then
		local item = inst.components.container:RemoveItemBySlot(1)
		if item then
			obj.components.container:GiveItem(item)
		end
	end
end
--切换回道具形态
local function ChangeToItem(inst)
    local item = SpawnPrefab("medal_resonator_item")
    item.Transform:SetPosition(inst.Transform:GetWorldPosition())
    --
    item.components.finiteuses:SetPercent(inst.components.finiteuses:GetPercent())
	transferTreasureMap(inst,item)--转移藏宝图
    return item
end

local MOON_ALTAR_ASTRAL_MARKER_MUST_TAG =  {"moon_altar_astral_marker"}
local MOON_ALTAR_ASTRAL_MARKER_NOT_TAG =  {"marker_found"}
local MOON_RELIC_MUST_TAG =  {"moon_relic"}
local CRAB_KING_MUST_TAG =  {"crabking"}
--扫描
local function scanfordevice(inst)
	local hasresult=false--是否有结果
	if inst.components.container and not inst.components.container:IsEmpty() then
		local treasureMap = inst.components.container:GetItemInSlot(1)
		if treasureMap and treasureMap.getTreasurePoint then
			local treasure_data=treasureMap:getTreasurePoint(inst)--获取藏宝点信息
			if treasure_data then
				-- print("宝藏世界ID为"..treasure_data.worldid..",坐标为:"..treasure_data.x..","..treasure_data.z)
				--不在一个世界
				if treasure_data.worldid ~= TheShard:GetShardId() then
                    MedalSay(inst,STRINGS.READMEDALTREASUREMAP_SPEECH.OTHERWORLD)
				--在很近的范围内，挖掘(1格地皮距离是4)
				elseif inst:GetDistanceSqToPoint(treasure_data.x,0,treasure_data.z) < 6*6 then
					inst.SoundEmitter:KillSound("locating")
					inst.AnimState:PlayAnimation("drill")
					inst.SoundEmitter:PlaySound("grotto/common/archive_resonator/drill")
					-- inst.AnimState:OverrideSymbol("swap_body", "swap_altar_wardpiece", "swap_body")
					inst:ListenForEvent("animover", function()
						--挖掘动画结束后
						if inst.AnimState:IsCurrentAnimation("drill") then
							--生成宝藏
                            if treasureMap.spawnTreasure then
                                treasureMap:spawnTreasure(inst)
                            end
							inst.components.container:DestroyContents()--销毁藏宝图
							inst.components.finiteuses:Use(1)--消耗耐久
							local item = ChangeToItem(inst)--切换回道具形态
							local pt = Vector3(inst.Transform:GetWorldPosition())
							pt.y = pt.y + 3
							inst.components.lootdropper:FlingItem(item,pt)
							inst:Remove()
						end
					end)
					hasresult=true
				else--比较远，指路
					local x,y,z = inst.Transform:GetWorldPosition()
					local angle = inst:GetAngleToPoint(treasure_data.x,0,treasure_data.z)--获取当前坐标点和目标点的角度
					local radius = -3
					local theta = (angle)*DEGREES
					local offset = Vector3(radius * math.cos( theta ), 0, -radius * math.sin( theta ))
					inst.task3 = inst:DoTaskInTime(30/30, function()
						local base = SpawnPrefab("medal_resonator_base")--生成箭头
						base.Transform:SetPosition(x-offset.x,y,z-offset.z)--设定坐标
						base.Transform:SetRotation(angle-90)--设定朝向
						base.AnimState:PlayAnimation("beam_marker")--箭头射出的动画
						base.AnimState:PushAnimation("idle_marker",true)--进入循环
					
						inst.SoundEmitter:PlaySound("grotto/common/archive_resonator/beam")
					end)
					inst.task4 = inst:DoTaskInTime(20/30, function()
						copyparams( inst._endlight, light_params.beam)
						beginfade(inst)
					end)
					
					inst.task5 = inst:DoTaskInTime(44/30, function()
						copyparams( inst._endlight, light_params.on)
						beginfade(inst)
					end)
					inst.Transform:SetRotation(angle)--+180)
					inst.AnimState:PlayAnimation("beam")
					inst.SoundEmitter:KillSound("locating")
					hasresult=true
                    RewardToiler(inst.doer)--天道酬勤
				end
			end
		end
	end
	--没结果的话就直接收回去吧
	if not hasresult then
		inst.task3 = inst:DoTaskInTime(3, function()
			MedalSay(inst,STRINGS.READMEDALTREASUREMAP_SPEECH.NOPOS)
			inst.SoundEmitter:KillSound("locating")
			copyparams( inst._endlight, light_params.idle)
			beginfade(inst)
			inst.OnDismantle(inst)
			inst.components.finiteuses:Use(1)
		end)
	end
	--标记完收回去
	inst:ListenForEvent("animover", function()
		if inst.AnimState:IsCurrentAnimation("beam") then
			inst.OnDismantle(inst)
			inst.components.finiteuses:Use(1)
		end
	end)
end
--部署
local function ondeploy(inst, pt, deployer)
    local at = SpawnPrefab("medal_resonator")--生成工作站
    if at ~= nil then
        at.Physics:SetCollides(false)
        at.Physics:Teleport(pt.x, 0, pt.z)
        at.Physics:SetCollides(true)
        at.AnimState:PlayAnimation("place")
        at.doer = deployer--标记使用者

        at.SoundEmitter:PlaySound("grotto/common/archive_resonator/place")
        at.SoundEmitter:PlaySound("grotto/common/archive_resonator/idle_LP", "idle_loop")

        at:ListenForEvent("animover", function()
            if at.AnimState:IsCurrentAnimation("place") then
                at.AnimState:PlayAnimation("locating", true)
                at.SoundEmitter:PlaySound("grotto/common/archive_resonator/locating_LP", "locating")
            end
        end)
        if at._lighttask then
            at._lighttask:Cancel()
            at._lighttask = nil
        end
        copyparams(at._currentlight, light_params.off)
        pushparams(at, at._currentlight)
        at.task1 = at:DoTaskInTime(83/30,function()
                copyparams( at._endlight, light_params.on)
                beginfade(at)
            end)
        at.task2 = at:DoTaskInTime(5,function()
        		scanfordevice(at)
    		end)
        at.components.finiteuses:SetPercent(inst.components.finiteuses:GetPercent())
		transferTreasureMap(inst,at)--转移藏宝图
        inst:Remove()
    end
end
--拆除
local function OnDismantle(inst)--, doer)
    inst.SoundEmitter:KillSound("idle_loop")
    inst.AnimState:PlayAnimation("pack")--播放收拢动画
    inst.SoundEmitter:PlaySound("grotto/common/archive_resonator/pack")
    copyparams( inst._endlight, light_params.off)
    beginfade(inst)
    inst:ListenForEvent("animover", function()
    -- inst.SoundEmitter:PlaySound("grotto/common/archive_resonator/pack") Jason (doesn't work)
        --收拢动画结束后切回道具形态
		if inst.AnimState:IsCurrentAnimation("pack") then
            ChangeToItem(inst)
            inst:Remove()
        end
    end)
end
--耐久用完
local function onfinisheduses(inst)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
	local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("stone")
    inst:Remove()
end
--锤掉
local function onhammered(inst)
	
    inst.components.lootdropper:DropLoot()
    --close it
    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("stone")

    if inst.task1 then
        inst.task1:Cancel()
        inst.task1 = nil
    end

    if inst.task2 then
        inst.task2:Cancel()
        inst.task2 = nil
    end

    if inst.task3 then
        inst.task3:Cancel()
        inst.task3 = nil
    end

    if inst.task4 then
        inst.task4:Cancel()
        inst.task4 = nil
    end

    if inst.task5 then
        inst.task5:Cancel()
        inst.task5 = nil
    end

    inst:Remove()
end
--被锤
local function onhit(inst)
	if inst.components.container ~= nil then
	    inst.components.container:DropEverything()
	end
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
end
--注册装置
local function RegisterDevice(inst,device)
    table.insert(inst.registered_devices,device)
end

local function getstatus(inst)
    return inst.AnimState:IsCurrentAnimation("idle_loop") and "IDLE"
        or nil
end

local function onloadpostpass_main(inst, ents, data)
    OnDismantle(inst)--加载时拆除
end
--工作站定义
local function mainfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddLight()

    inst.Light:SetFalloff(0.6)
    inst.Light:SetIntensity(.4)
    inst.Light:SetRadius(2)
    inst.Light:SetColour(237/255, 237/255, 209/255)

    inst.Light:EnableClientModulation(true)

    inst.widthscale = 1
    inst._endlight = {}
    inst._startlight = {}
    inst._currentlight = {}

    copyparams(inst._endlight, light_params.idle)
    copyparams(inst._startlight, inst._endlight)
    copyparams(inst._currentlight, inst._endlight)

    pushparams(inst, inst._currentlight)

  --  inst._lightphase = OFF

    inst._lighttask = nil

    inst.DynamicShadow:SetSize(1, .33)

    MakeObstaclePhysics(inst, 0.5)
    inst.Transform:SetEightFaced()

    inst.AnimState:SetBank("archive_resonator")
    inst.AnimState:SetBuild("medal_resonator")
    inst.AnimState:PlayAnimation("idle_loop",true)

    inst.candismantle = function()
        if inst.AnimState:IsCurrentAnimation("idle_loop") then
            return true
        end
    end

    inst.entity:SetPristine()
	
	inst:AddComponent("talker")--可对话组件

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("container")
	inst.components.container:WidgetSetup("medal_resonator")--设置容器
	inst.components.container.canbeopened = false

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(onfinisheduses)
    inst.components.finiteuses:SetMaxUses(TUNING_MEDAL.MEDAL_RESONATOR_USES)
    inst.components.finiteuses:SetUses(TUNING_MEDAL.MEDAL_RESONATOR_USES)
    inst.OnDismantle = OnDismantle--拆除

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("portablestructure")
    inst.components.portablestructure:SetOnDismantleFn(OnDismantle)
    inst.components.portablestructure.candismantle = function()
        if inst.AnimState:IsCurrentAnimation("idle_loop") then
            return true
        end
    end

    -- inst.OnSave = onsave_main
    inst.OnLoadPostPass = onloadpostpass_main

    inst:AddComponent("lootdropper")
    inst.RegisterDevice = RegisterDevice

    return inst
end


local function OnTimerDone(inst, data)
    if data.name == "expire" then
        inst:Remove()
    end
end


local function onsave(inst, data)
   data.rotation = inst.Transform:GetRotation()
end

local function onload(inst, data, newents)
    if data ~= nil then
        if data.rotation then
           inst.Transform:SetRotation(data.rotation)
        end
    end
end
--箭头定义
local function basefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.entity:AddLight()

    inst.Light:SetFalloff(0.7)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(0.5)
    inst.Light:SetColour(237/255, 237/255, 209/255)
    inst.Light:Enable(true)

    inst.AnimState:SetBuild("medal_resonator")
    inst.AnimState:SetBank("archive_resonator")
    inst.AnimState:PlayAnimation("idle_marker", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.entity:SetPristine()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.OnSave = onsave
    inst.OnLoad = onload

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone)
    inst.components.timer:StartTimer("expire",TUNING_MEDAL.MEDAL_RESONATOR_BASE_TIME)

    return inst
end
--物品栏道具定义
local function itemfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst:AddTag("usedeploystring")

    inst.AnimState:SetBank("archive_resonator")
    inst.AnimState:SetBuild("medal_resonator")
    inst.AnimState:PlayAnimation("pack_loop")

    inst.medal_repair_common={--可补充耐久
        charcoal=TUNING_MEDAL.MEDAL_RESONATOR_ADDUSE,--木炭
	}

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
        	inst.replica.container:WidgetSetup("medal_resonator") 
        end
		return inst
    end
	
	inst:AddComponent("container")
	inst.components.container:WidgetSetup("medal_resonator")--设置容器

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "medal_resonator_item"
    inst.components.inventoryitem.atlasname = "images/medal_resonator_item.xml"
    inst.components.inventoryitem:SetSinks(true)

    MakeHauntableLaunch(inst)

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy--部署

	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetMaxUses(TUNING_MEDAL.MEDAL_RESONATOR_USES)
    inst.components.finiteuses:SetUses(TUNING_MEDAL.MEDAL_RESONATOR_USES)


    return inst
end

return  Prefab("medal_resonator", mainfn, assets,prefabs),
		Prefab("medal_resonator_item", itemfn, assets, prefabs),
		MakePlacer("medal_resonator_item_placer", "archive_resonator", "medal_resonator", "idle_place"),
        Prefab("medal_resonator_base", basefn, assets,prefabs)

