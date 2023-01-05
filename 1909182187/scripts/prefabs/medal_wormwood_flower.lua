local assets =
{
    Asset("ANIM", "anim/medal_wormwood_flower.zip"),
}

local prefabs =
{
    "plant_certificate",
	"wormwood_plant_fx",
}

-----------------------------------------------虫木花---------------------------------------------------

local PLANTS_RANGE = 1--生成小花的范围
local MAX_PLANTS = 18--最多允许周围有多少朵小花

local PLANTFX_TAGS = { "wormwood_plant_fx" }
--周期生成小花
local function PlantTick(inst)
    if not inst.entity:IsVisible() then
        return
    end
    local x, y, z = inst.Transform:GetWorldPosition()
	--生成小花
    if #TheSim:FindEntities(x, y, z, PLANTS_RANGE, PLANTFX_TAGS) < MAX_PLANTS then
        local map = TheWorld.Map
        local pt = Vector3(0, 0, 0)
        local offset = FindValidPositionByFan(
            math.random() * 2 * PI,
            math.random() * PLANTS_RANGE,
            3,
            function(offset)
                pt.x = x + offset.x
                pt.z = z + offset.z
                local tile = map:GetTileAtPoint(pt:Get())
                return tile ~= GROUND.ROCKY
                    and tile ~= GROUND.ROAD
                    and tile ~= GROUND.WOODFLOOR
                    and tile ~= GROUND.CARPET
                    and tile ~= GROUND.IMPASSABLE
                    and tile ~= GROUND.INVALID
                    and #TheSim:FindEntities(pt.x, 0, pt.z, .5, PLANTFX_TAGS) < 3
                    and map:IsDeployPointClear(pt, nil, .5)
                    and not map:IsPointNearHole(pt, .4)
            end
        )
        if offset ~= nil then
            local plant = SpawnPrefab("wormwood_plant_fx")
            plant.Transform:SetPosition(x + offset.x, 0, z + offset.z)
            --randomize, favoring ones that haven't been used recently
            local rnd = math.random()
            rnd = table.remove(inst.plantpool, math.clamp(math.ceil(rnd * rnd * #inst.plantpool), 1, #inst.plantpool))
            table.insert(inst.plantpool, rnd)
            plant:SetVariation(rnd)
        end
    end
end
--采摘
local function onpickedfn(inst, picker,loot)
    -- if picker and picker.components.sanity then
    --     picker.components.sanity:DoDelta(-TUNING.SANITY_TINY)
    -- end
	if loot and loot.prefab then
		--复制采摘列表
		if inst.picklist then
			loot.picklist=shallowcopy(inst.picklist)
			--设置耐久
			if loot.components.finiteuses then
                if inst.medal_finiteuses then
                    loot.components.finiteuses:SetUses(inst.medal_finiteuses)
                else--老版本会出现没有medal_finiteuses的情况，处理一下
                    loot.components.finiteuses:SetUses(TUNING_MEDAL.PLANT_MEDAL.MAXUSES-(15-#loot.picklist)*TUNING_MEDAL.PLANT_MEDAL.CONSUME)
                end
			end
		end
		--是植物勋章
		if inst.is_transplant then
			loot:Remove()
			loot=SpawnPrefab("transplant_certificate")
			if picker and picker.components.inventory then
				picker.components.inventory:GiveItem(loot, nil, inst:GetPosition())
			else
				loot.Transform:SetPosition(inst.Transform:GetWorldPosition())
			end
		end
		--转移肥料值
		if inst.medal_fertility then
			loot.medal_fertility=inst.medal_fertility
		end
	end
    inst:Remove()
end
--抚摸
local function strokeFn(inst,player)
	if inst.medal_fertility and inst.medal_fertility>0 then
		inst.medal_fertility=inst.medal_fertility-1--消耗肥料值
		--范围照料
		local x, y, z = inst.Transform:GetWorldPosition()
		for _, v in pairs(TheSim:FindEntities(x, y, z, TUNING_MEDAL.PLANT_MEDAL.INTERACT_RANGE, {"tendable_farmplant"},{ "FX", "DECOR", "INLIMBO" })) do
			if v.components.farmplanttendable ~= nil then
				v.components.farmplanttendable:TendTo(player)
			end
		end
		--打招呼
		local speech=STRINGS.MEDAL_WORMWOOD_FLOWER_SPEECH.SAYHELLO--默认打招呼
		if player then
			local playerstr=STRINGS.NAMES[string.upper(player.prefab)]--玩家角色名称
			--调用沃姆伍德对应的检查语句
			if STRINGS.CHARACTERS.WORMWOOD.DESCRIBE[string.upper(player.prefab)] then
				speech=string.format(STRINGS.CHARACTERS.WORMWOOD.DESCRIBE[string.upper(player.prefab)].GENERIC,playerstr or "")
			elseif playerstr then--没有则用默认打招呼语句
				speech=string.format(STRINGS.MEDAL_WORMWOOD_FLOWER_SPEECH.SAYHELLOWITHNAME,playerstr)
			end
		end
        MedalSay(inst,speech)
		--开花(持续2秒)
		if inst.planttask==nil then
			inst.planttask = inst:DoPeriodicTask(.25, PlantTick)--周期生成小花
		end
		if inst.plantimetask~=nil then
			inst.plantimetask:Cancel()
			inst.plantimetask=nil
		end
		inst.plantimetask=inst:DoTaskInTime(2,function(inst)
			if inst.planttask~=nil then
				inst.planttask:Cancel()
				inst.planttask=nil
			end
		end)
        --安抚跟随玩家的曼德拉草
        if player and player.components.leader then
            player.components.leader:RemoveFollowersByTag("character",function(follower)
                if follower and follower.prefab=="mandrake_active" then
                    local planted = SpawnPrefab("mandrake_planted")
                    planted.Transform:SetPosition(follower.Transform:GetWorldPosition())
                    planted:replant(follower)
                    follower:Remove()
                    return true
                end
            end)
        end
	else
        MedalSay(player,STRINGS.MEDAL_WORMWOOD_FLOWER_SPEECH.NOFERTILITY)
	end
end
--显示肥力
local function getMedalInfo(inst)
    if inst.medal_fertility then
        return STRINGS.MEDAL_INFO.FERTILITY..inst.medal_fertility
    end
end

local function onsavefn(inst,data)
	--采摘列表
	if inst.picklist and #inst.picklist>0 then
		data.picklist=shallowcopy(inst.picklist)
	end
	--是否是植物勋章
	if inst.is_transplant then
		data.is_transplant=true
	end
	--肥料值
	if inst.medal_fertility and inst.medal_fertility>0 then
		data.medal_fertility=inst.medal_fertility
	end
    --耐久
    if inst.medal_finiteuses then
        data.medal_finiteuses = inst.medal_finiteuses
    end
end

local function onloadfn(inst,data)
	if data then
        --采摘列表
        if data.picklist and #data.picklist>0 then
            inst.picklist=shallowcopy(data.picklist)
        end
        inst.is_transplant=data.is_transplant--是否是植物勋章
        inst.medal_fertility=data.medal_fertility--肥料值
        inst.medal_finiteuses=data.medal_finiteuses--耐久
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("medal_wormwood_flower")
    inst.AnimState:SetBuild("medal_wormwood_flower")
	inst.AnimState:PlayAnimation("medal_wormwood_flower")

    inst.entity:SetPristine()
	
	inst:AddTag("flower")--花
	inst:AddTag("showmedalinfo")--显示详细信息
	inst:AddTag("needfertilize")--可施肥
	inst:AddTag("medal_flower")--虫木花
	
	inst:AddComponent("talker")

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.planttask = nil
	inst.plantpool = { 1, 2, 3, 4 }
	for i = #inst.plantpool, 1, -1 do
	    --randomize in place
	    table.insert(inst.plantpool, table.remove(inst.plantpool, math.random(i)))
	end

    inst:AddComponent("inspectable")

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("plant_certificate", 10)
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.quickpick = true
    inst.components.pickable.wildfirestarter = true
	
	inst.strokeFn = strokeFn
    inst.getMedalInfo = getMedalInfo
	
	inst.OnSave = onsavefn
	inst.OnLoad = onloadfn

    --inst:AddComponent("transformer")

    -- MakeSmallBurnable(inst)
    -- MakeSmallPropagator(inst)

    MakeHauntableIgnite(inst)

    return inst
end

-----------------------------------------------埋着的绿宝石---------------------------------------------------
local gemprefabs =
{
    "greengem",
	"positronpulse",
	"positronbeam_front",
	"positronbeam_back",
	"medal_wormwood_flower",
}

local function StopLight(inst)
    inst._stoplighttask = nil
    inst.Light:Enable(false)
end

local function StopFX(inst)
    if inst._fxpulse ~= nil then
        inst._fxpulse:KillFX()
        inst._fxpulse = nil
    end
    if inst._fxfront ~= nil or inst._fxback ~= nil then
        if inst._fxback ~= nil then
            inst._fxfront:KillFX()
            inst._fxfront = nil
        end
        if inst._fxback ~= nil then
            inst._fxback:KillFX()
            inst._fxback = nil
        end
        if inst._stoplighttask ~= nil then
            inst._stoplighttask:Cancel()
        end
        inst._stoplighttask = inst:DoTaskInTime(9 * FRAMES, StopLight)
    end
    if inst._startlighttask ~= nil then
        inst._startlighttask:Cancel()
        inst._startlighttask = nil
    end
end

local function StartLight(inst)
    inst._startlighttask = nil
    inst.Light:Enable(true)
end

local function StartFX(inst)
    if inst._fxfront == nil or inst._fxback == nil then
        local x, y, z = inst.Transform:GetWorldPosition()

        if inst._fxpulse ~= nil then
            inst._fxpulse:Remove()
        end
        inst._fxpulse = SpawnPrefab("positronpulse")
        inst._fxpulse.Transform:SetPosition(x, y, z)

        if inst._fxfront ~= nil then
            inst._fxfront:Remove()
        end
        inst._fxfront = SpawnPrefab("positronbeam_front")
        inst._fxfront.Transform:SetPosition(x, y-0.4, z)

        if inst._fxback ~= nil then
            inst._fxback:Remove()
        end
        inst._fxback = SpawnPrefab("positronbeam_back")
        inst._fxback.Transform:SetPosition(x, y-0.4, z)

        if inst._startlighttask ~= nil then
            inst._startlighttask:Cancel()
        end
        inst._startlighttask = inst:DoTaskInTime(3 * FRAMES, StartLight)
    end
    if inst._stoplighttask ~= nil then
        inst._stoplighttask:Cancel()
        inst._stoplighttask = nil
    end
end

local function OnRemoveEntity(inst)
    if inst._fxpulse ~= nil then
        inst._fxpulse:Remove()
        inst._fxpulse = nil
    end
    if inst._fxfront ~= nil then
        inst._fxfront:Remove()
        inst._fxfront = nil
    end
    if inst._fxback ~= nil then
        inst._fxback:Remove()
        inst._fxback = nil
    end
end

local function ToggleMoonCharge(inst)
	if TheWorld.state.isfullmoon then
		StartFX(inst)
	else
		StopFX(inst)
	end
end

local function OnFullmoon(inst, isfullmoon)
    -- if not isfullmoon then
    --     inst.components.timer:StopTimer("fullmoonstartdelay")
    --     StopMusic(inst)
    -- elseif not inst.components.timer:TimerExists("fullmoonstartdelay") then
    --     inst.components.timer:StartTimer("fullmoonstartdelay", TUNING.MOONBASE_CHARGE_DELAY)
    -- end
    ToggleMoonCharge(inst)
end

local function init(inst)
    inst._loading = nil
    inst:WatchWorldState("isfullmoon", OnFullmoon)
    ToggleMoonCharge(inst)
end

local function dig_up(inst, worker)
    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:SpawnLootPrefab("greengem")
    end
    inst:Remove()
end

local function gemfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("medal_wormwood_flower")
    inst.AnimState:SetBuild("medal_wormwood_flower")
	inst.AnimState:PlayAnimation("medal_buried_greengem")
	
	inst.Light:SetRadius(2)
	inst.Light:SetIntensity(.75)
	inst.Light:SetFalloff(.75)
	inst.Light:SetColour(128 / 255, 128 / 255, 255 / 255)
	inst.Light:Enable(false)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst._fxpulse = nil
	inst._fxfront = nil
	inst._fxback = nil
	inst._startlighttask = nil
	inst._stoplighttask = nil
	inst.OnRemoveEntity = OnRemoveEntity

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)

    --inst:AddComponent("transformer")

    MakeHauntableIgnite(inst)
	
	inst._loading = inst:DoTaskInTime(0, init)

    return inst
end

return Prefab("medal_wormwood_flower", fn, assets, prefabs),
	Prefab("medal_buried_greengem", gemfn, assets, gemprefabs)