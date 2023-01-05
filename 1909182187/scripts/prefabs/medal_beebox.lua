require "prefabutil"
require("worldsettingsutil")

local assets =
{
    -- Asset("ANIM", "anim/bee_box.zip"),
    Asset("ANIM", "anim/medal_beebox.zip"),
	Asset("ATLAS", "minimap/medal_beebox.xml"),
	Asset("ATLAS", "images/medal_beebox.xml"),
	Asset("IMAGE", "images/medal_beebox.tex"),
}

local prefabs =
{
    -- "bee",
    "medal_bee",
    -- "honey",
    "honeycomb",
    "collapse_small",
	"royal_jelly",
}

FLOWER_TEST_RADIUS = 30

local levels =
{
    { amount=3, idle="honey3", hit="hit_honey3" },
    { amount=2, idle="honey2", hit="hit_honey2" },
    { amount=1, idle="honey1", hit="hit_honey1" },
    { amount=0, idle="bees_loop", hit="hit_idle" },
}

local FLOWER_MUST_TAG = {"medal_flower"}--不好意思，必须是虫木花
--可增长蜂王浆
local function CanStartGrowing(inst)
    return not inst:HasTag("burnt") and--不能是被烧毁的
        inst.components.harvestable and--有可收获组件
        not TheWorld.state.iswinter and--非冬天
        (inst.components.childspawner and inst.components.childspawner:NumChildren() > 0) and--育王蜂数量不为0
        FindEntity(inst, FLOWER_TEST_RADIUS, nil, FLOWER_MUST_TAG)--周围有虫木花
end
--蜂箱停止工作
local function Stop(inst)
    if inst.components.harvestable ~= nil and inst.components.harvestable.growtime ~= nil then
        inst.components.harvestable:PauseGrowing()
    end
    if inst.components.childspawner ~= nil then
        inst.components.childspawner:StopSpawning()
    end
end

local function Start(inst)
    if CanStartGrowing(inst) and inst.components.harvestable.growtime then
        inst.components.harvestable:StartGrowing()
    end
    if inst.components.childspawner ~= nil then
        inst.components.childspawner:StartSpawning()
    end
end

local function OnIsCaveDay(inst, isday)
    if not isday then
        Stop(inst)
    elseif not (TheWorld.state.iswinter or inst:HasTag("burnt"))
        and inst:IsInLight() then
        Start(inst)
    end
end
--
local function OnEnterLight(inst)
    if not (TheWorld.state.iswinter or inst:HasTag("burnt"))
        and TheWorld.state.iscaveday then
        Start(inst)
    end
end
--陷入黑暗
local function OnEnterDark(inst)
    Stop(inst)
end

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.SoundEmitter:KillSound("loop")
    if inst.components.harvestable ~= nil then
        inst.components.harvestable:Harvest()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation(inst.anims.hit)
        inst.AnimState:PushAnimation(inst.anims.idle, false)
    end
end
--设置蜂箱等级
local function setlevel(inst, level)
    if not inst:HasTag("burnt") then
        if inst.anims == nil then
            inst.anims = { idle = level.idle, hit = level.hit }
        else
            inst.anims.idle = level.idle
            inst.anims.hit = level.hit
        end
        inst.AnimState:PlayAnimation(inst.anims.idle)
    end
end
--更新蜂箱产蜜等级
local function updatelevel(inst)
    if not inst:HasTag("burnt") then
        for k, v in pairs(levels) do
            if inst.components.harvestable.produce >= v.amount then
                setlevel(inst, v)
                break
            end
        end
    end
end
--收获
local function onharvest(inst, picker, produce)
    --print(inst, "onharvest")
    if not inst:HasTag("burnt") then
        if inst.components.harvestable then
            inst.components.harvestable:SetGrowTime(nil)
            inst.components.harvestable.pausetime = nil
            inst.components.harvestable:StopGrowing()
        end
		--[[
		if produce == levels[1].amount then
			AwardPlayerAchievement("honey_harvester", picker)
		end
		]]
        updatelevel(inst)
		if picker and not picker.isbeeking then
			if inst.components.childspawner ~= nil and not TheWorld.state.iswinter then
				inst.components.childspawner:ReleaseAllChildren(picker)
			end
		end
    end
end

local function onchildgoinghome(inst, data)
    if not inst:HasTag("burnt") and
        data.child ~= nil and
        data.child.components.pollinator ~= nil and
        data.child.components.pollinator:HasCollectedEnough() and
        inst.components.harvestable ~= nil then
        inst.components.harvestable:Grow()
    end
end

local function OnSave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end
--离开加载范围
local function onsleep(inst)
    if CanStartGrowing(inst) then--离开加载范围的时候就要尝试自动增长蜂王浆了
        inst.components.harvestable:SetGrowTime(TUNING.BEEBOX_HONEY_TIME)
        inst.components.harvestable:StartGrowing()
    end
end
--进入加载范围
local function stopsleep(inst)
    if not inst:HasTag("burnt") and inst.components.harvestable ~= nil then
        inst.components.harvestable:SetGrowTime(nil)
        inst.components.harvestable:PauseGrowing()
    end
end

local function OnLoad(inst, data)
    --print(inst, "OnLoad")
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
    else
        updatelevel(inst)
    end
end
--建筑
local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle", false)
	inst.SoundEmitter:PlaySound("dontstarve/common/bee_box_craft")
end
--着火
local function onignite(inst)
	--[[
	if inst.components.childspawner ~= nil then
		inst.components.childspawner:ReleaseAllChildren()--倾巢而出
		inst.components.childspawner:StopSpawning()--停止再生
	end
	]]
	--自动灭火
	inst:DoTaskInTime(1, function(inst)
		SpawnPrefab("livingroot_chest_extinguish_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
	end)
end
--预置物唤醒
local function OnEntityWake(inst)
	inst.SoundEmitter:PlaySound("dontstarve/bee/bee_box_LP", "loop")
end
--预置物休眠
local function OnEntitySleep(inst)
	inst.SoundEmitter:KillSound("loop")
end

local function GetStatus(inst)
	return inst.components.harvestable ~= nil
		and (   (inst.components.harvestable.produce >= inst.components.harvestable.maxproduce and "READY") or
				(inst.components.harvestable:CanBeHarvested() and "SOMEHONEY") or
				((inst.components.childspawner == nil or inst.components.childspawner:NumChildren() <= 0) and "NOHONEY")
			)
		or nil
end
--季节更替
local function SeasonalSpawnChanges(inst, season)
	if inst.components.childspawner then
		--春天出蜜蜂更快
		if season == SEASONS.SPRING then
			inst.components.childspawner:SetSpawnPeriod(TUNING.BEEBOX_RELEASE_TIME / TUNING.SPRING_COMBAT_MOD)
		else
			inst.components.childspawner:SetSpawnPeriod(TUNING.BEEBOX_RELEASE_TIME)
		end
	end
end

local function OnPreLoad(inst, data)
    WorldSettings_ChildSpawner_PreLoad(inst, data, TUNING.BEEBOX_RELEASE_TIME, TUNING.BEEBOX_REGEN_TIME)
end

local function MakeBeebox(name)

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()
        inst.entity:AddLightWatcher()

        MakeObstaclePhysics(inst, .5)

        -- inst.MiniMapEntity:SetIcon("beebox.png")
		inst.MiniMapEntity:SetIcon("medal_beebox.tex")

        inst.AnimState:SetBank("medal_beebox")
        inst.AnimState:SetBuild("medal_beebox")
        inst.AnimState:PlayAnimation("idle")
		

        inst:AddTag("structure")
        inst:AddTag("playerowned")
        inst:AddTag("beebox")

        MakeSnowCoveredPristine(inst)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        ---------------------

        inst:AddComponent("harvestable")--可收获组件
        inst.components.harvestable:SetUp("royal_jelly", 3, nil, onharvest, updatelevel)
        inst:ListenForEvent("childgoinghome", onchildgoinghome)
        -------------------

        inst:AddComponent("childspawner")
        inst.components.childspawner.childname = "medal_bee"--"bee"
        inst.components.childspawner.allowwater = true
        SeasonalSpawnChanges(inst, TheWorld.state.season)--根据季节调整蜂箱再生情况
        inst:WatchWorldState("season", SeasonalSpawnChanges)--监听季节变化
		inst.components.childspawner:SetMaxChildren(TUNING_MEDAL.MEDAL_BEEBOX_BEES)--设置蜂巢最大容量
		inst.components.childspawner:SetRegenPeriod(TUNING.BEEBOX_REGEN_TIME)--蜜蜂再生时间
        WorldSettings_ChildSpawner_SpawnPeriod(inst, TUNING.BEEBOX_RELEASE_TIME, TUNING.BEEBOX_ENABLED)
        WorldSettings_ChildSpawner_RegenPeriod(inst, TUNING.BEEBOX_REGEN_TIME, TUNING.BEEBOX_ENABLED)
		inst.components.childspawner:StopRegen()--停止再生
		inst.components.childspawner.childreninside = 0--初始蜜蜂数量
		
		if TheWorld.state.isday and not TheWorld.state.iswinter then
			inst.components.childspawner:StartSpawning()--非冬季的白天蜜蜂开始出巢活动
		end

        inst:WatchWorldState("iscaveday", OnIsCaveDay)
        inst:ListenForEvent("enterlight", OnEnterLight)--处于光照范围
        inst:ListenForEvent("enterdark", OnEnterDark)--陷入黑暗

        inst:AddComponent("inspectable")
        inst.components.inspectable.getstatus = GetStatus

        inst:ListenForEvent("entitysleep", onsleep)
        inst:ListenForEvent("entitywake", stopsleep)

        updatelevel(inst)

        MakeHauntableWork(inst)

        MakeSnowCovered(inst)
        inst:ListenForEvent("onbuilt", onbuilt)

        inst.OnSave = OnSave
        inst.OnLoad = OnLoad
        inst.OnEntitySleep = OnEntitySleep
        inst.OnEntityWake = OnEntityWake

        inst:AddComponent("lootdropper")
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(4)
        inst.components.workable:SetOnFinishCallback(onhammered)
        inst.components.workable:SetOnWorkCallback(onhit)
        
		--可燃烧
		inst:AddComponent("burnable")
		inst.components.burnable:SetFXLevel(2)
		inst.components.burnable:SetBurnTime(1.5)
		inst.components.burnable:AddBurnFX("campfirefire", Vector3(0, 0.5, 0), nil,true)
		inst:ListenForEvent("onignite", onignite)
		-- MakeMediumBurnable(inst, nil, nil, true)
		-- MakeLargePropagator(inst)

		inst.OnPreLoad = OnPreLoad

		return inst
	end

	return Prefab(name, fn, assets, prefabs)
end

return	MakeBeebox("medal_beebox"),
	MakePlacer("medal_beebox_placer", "medal_beebox", "medal_beebox", "idle")