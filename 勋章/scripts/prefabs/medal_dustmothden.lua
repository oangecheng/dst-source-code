require("worldsettingsutil")

local assets =
{
    Asset("ANIM", "anim/dustmothden.zip"),
    Asset("ANIM", "anim/medal_dustmothden.zip"),
	Asset("ATLAS", "images/medal_dustmothden.xml"),
	Asset("IMAGE", "images/medal_dustmothden.tex"),
	Asset("ATLAS", "minimap/medal_dustmothden.xml"),
}

local prefabs =
{
    "dustmoth",
}

-- SetSharedLootTable('medal_dustmothden',
-- {
--     {'medal_spacetime_lingshi',  1.0},
--     {'medal_spacetime_lingshi',  1.0},
--     {'medal_spacetime_lingshi',  1.0},
--     {'medal_spacetime_lingshi',  0.75},
--     {'medal_spacetime_lingshi',  0.25},
--     {'medal_time_slider',  0.02},
-- })
--开始修复(inst,尘蛾)
local function StartRepairing(inst, repairer)
    -- Usually called from SGdustmoth
    --开始/继续 修复计时器
    if inst.components.timer:TimerExists("repair") then
        if inst.components.timer:IsPaused("repair") then
            inst.components.timer:ResumeTimer("repair")
        end
    else
        inst.components.timer:StartTimer("repair", TUNING_MEDAL.MEDAL_DUSTMOTHDEN_REPAIR_TIME)
    end
    --实体跟踪器记录修复中的尘蛾
    inst.components.entitytracker:TrackEntity("repairer", repairer)
    --播放修复动画
    inst.AnimState:PlayAnimation("repair", true)
end
--暂停修复
local function PauseRepairing(inst)
    inst.components.timer:PauseTimer("repair")

    if not inst.components.workable.workable then
        inst.AnimState:PlayAnimation("idle")
    end

    inst.components.entitytracker:ForgetEntity("repairer")
end
--恢复完整(inst,是否播放生长动画)
local function MakeWhole(inst, play_growth_anim)
    if play_growth_anim then
        inst.AnimState:PlayAnimation("growth")
        inst.AnimState:PushAnimation("idle_thulecite", false)
    else
        inst.AnimState:PlayAnimation("idle_thulecite")
    end
    --恢复可挖掘次数
    inst.components.workable.workleft = inst.components.workable.workleft <= 0 and inst.components.workable.maxwork or inst.components.workable.workleft
    inst.components.workable.workable = true
    --获取尘蛾，给它推送已修复事件
    local repairer = inst.components.entitytracker:GetEntity("repairer")
    if repairer ~= nil and repairer:IsValid() then
        inst.has_slider = repairer.eat_snack--尘蛾吃了时空零食后修的，则必然会出时空碎片
        repairer:PushEvent("dustmothden_repaired", inst)
    end
    --遗忘修复的尘蛾
    inst.components.entitytracker:ForgetEntity("repairer")
end
--计时器结束
local function OnTimerDone(inst, data)
    if data ~= nil and data.name == "repair" then
        MakeWhole(inst, true)
    end
end
--挖掘完毕
local function OnFinishWork(inst, worker)
    -- inst.components.lootdropper:DropLoot()
    --这里要特殊处理掉落，不然用月光玻璃锤就无限刷了
    local chance = 0.05
    if inst.has_slider then
        chance = 1
        inst.has_slider = nil
    end
    if math.random() < chance then
        inst.components.lootdropper:SpawnLootPrefab("medal_time_slider")
    else
        for i = 1, math.random(3,6) do
            inst.components.lootdropper:SpawnLootPrefab("medal_spacetime_lingshi")
        end
    end
    
    inst.components.workable.workable = false

    inst.AnimState:PlayAnimation("idle")

    inst.SoundEmitter:PlaySoundWithParams("dontstarve/creatures/together/antlion/sfx/ground_break", { size = 1 })
end

local function OnSave(inst, data)
    if inst.has_slider then
        data.has_slider = true
    end
end

--后加载,也就是加载完数据后执行
local function OnLoadPostPass(inst, ents, data)
    --更新巢穴当前的挖掘状态
    if inst.components.workable.workleft <= 0 then
        inst.components.workable.workable = false
        inst.AnimState:PlayAnimation("idle")
    else
        MakeWhole(inst, false)
    end
    --暂停修复定时器
    if inst.components.timer:TimerExists("repair") then
        PauseRepairing(inst)
    end
    if data and data.has_slider then
        inst.has_slider = data.has_slider
    end
end
--预加载
local function OnPreLoad(inst, data)
    WorldSettings_ChildSpawner_PreLoad(inst, data, TUNING_MEDAL.MEDAL_DUSTMOTHDEN_RELEASE_TIME, TUNING_MEDAL.MEDAL_DUSTMOTHDEN_REGEN_TIME)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeSmallObstaclePhysics(inst, .5)

    inst.MiniMapEntity:SetIcon("medal_dustmothden.tex")

    inst.AnimState:SetBank("dustmothden")
    inst.AnimState:SetBuild("medal_dustmothden")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("structure")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst._start_repairing_fn = StartRepairing--开始修复
    inst._pause_repairing_fn = PauseRepairing--暂停修复

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "medal_dustmoth"
    inst.components.childspawner:SetRegenPeriod(TUNING_MEDAL.MEDAL_DUSTMOTHDEN_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING_MEDAL.MEDAL_DUSTMOTHDEN_RELEASE_TIME)
    inst.components.childspawner:SetMaxChildren(TUNING_MEDAL.MEDAL_DUSTMOTHDEN_MAX_CHILDREN)
    WorldSettings_ChildSpawner_SpawnPeriod(inst, TUNING_MEDAL.MEDAL_DUSTMOTHDEN_RELEASE_TIME, true)
    WorldSettings_ChildSpawner_RegenPeriod(inst, TUNING_MEDAL.MEDAL_DUSTMOTHDEN_REGEN_TIME, true)
    inst.components.childspawner:StartRegen()
    inst.components.childspawner:StartSpawning()

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetMaxWork(TUNING_MEDAL.MEDAL_DUSTMOTHDEN_MAXWORK)
    inst.components.workable:SetWorkLeft(TUNING_MEDAL.MEDAL_DUSTMOTHDEN_MAXWORK)
    inst.components.workable:SetOnFinishCallback(OnFinishWork)
    inst.components.workable.savestate = true

    inst.components.workable.workleft = 0
    inst.components.workable.workable = false

    inst:AddComponent("timer")
    inst:AddComponent("entitytracker")

    inst:AddComponent("lootdropper")
    -- inst.components.lootdropper:SetChanceLootTable('medal_dustmothden')

    inst:AddComponent("inspectable")

    inst:ListenForEvent("timerdone", OnTimerDone)

    MakeSnowCovered(inst)

    MakeHauntableWork(inst)

    inst.OnLoadPostPass = OnLoadPostPass
    inst.OnPreLoad = OnPreLoad
    inst.OnSave = OnSave

    return inst
end

return Prefab("medal_dustmothden", fn, assets, prefabs),
    MakePlacer("medal_dustmothden_placer", "dustmothden", "medal_dustmothden", "idle")
