local assets =
{
    Asset("ANIM", "anim/bee_queen_hive.zip"),
    Asset("ANIM", "anim/medal_bee_queen_hive.zip"),
	Asset("ATLAS", "minimap/medal_beequeenhivegrown.xml"),
	Asset("ATLAS", "minimap/medal_beequeenhive.xml"),
}

local base_prefabs =
{
    "medal_beequeenhivegrown",
}

local prefabs =
{
    "beequeen",
    -- "honey",
    -- "honeycomb",
    "medal_honey_splash",
	"medal_blood_honey_splat",
}

local PHYS_RAD_LRG = 1.9
local PHYS_RAD_MED = 1.5
local PHYS_RAD_SML = .9

local function CreatePhysicsEntity(rad)
    local inst = CreateEntity()

    inst:AddTag("FX")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddPhysics()
    inst.Physics:SetMass(999999)
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.ITEMS)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
    inst.Physics:SetCapsule(rad, 2)

    inst:DoTaskInTime(0, inst.Remove)

    return inst
end

local function OnPhysRadDirty(inst)
    if inst.physrad:value() >= 1 and inst.physrad:value() <= 3 then
        CreatePhysicsEntity(
            (inst.physrad:value() >= 3 and PHYS_RAD_LRG) or
            (inst.physrad:value() == 2 and PHYS_RAD_MED) or
            PHYS_RAD_SML
        ).Transform:SetPosition(inst.Transform:GetWorldPosition())
    end
end

local function OnCleanupPhysTask(inst)
    inst.phystask = nil
    inst.physrad:set_local(0)
end
--更新碰撞体积
local function PushPhysRad(inst, rad)
    if inst.phystask ~= nil then
        inst.phystask:Cancel()
        inst.physrad:set_local(0)
    end
    inst.phystask = inst:DoTaskInTime(.5, OnCleanupPhysTask)
    inst.physrad:set(rad)
    OnPhysRadDirty(inst)
end

-------------------------------------------------------------------
--分泌蜂蜜(显示不同数量的蜂蜜贴图)
local function OnHoneyTask(inst, honeylevel)
    inst._honeytask = nil
    honeylevel = math.clamp(honeylevel, 0, 3)
    for i = 0, 3 do
        if i == honeylevel then
            inst.AnimState:Show("honey"..tostring(i))
        else
            inst.AnimState:Hide("honey"..tostring(i))
        end
    end
end
--设置蜂蜜等级(蜂巢,蜂蜜等级,延时)
local function SetHoneyLevel(inst, honeylevel, delay)
    if inst._honeytask ~= nil then
        inst._honeytask:Cancel()
    end

    if delay ~= nil then
        OnHoneyTask(inst, honeylevel - 1)
        inst._honeytask = inst:DoTaskInTime(delay, OnHoneyTask, honeylevel)
    else
        inst._honeytask = nil
        OnHoneyTask(inst, honeylevel)
    end
end
--停止所有的再生定时器
local function StopHiveGrowthTimer(inst)
    inst.components.timer:StopTimer("shorthivegrowth")
    inst.components.timer:StopTimer("firsthivegrowth")
    inst.AnimState:PlayAnimation("hole_idle")
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    SetHoneyLevel(inst, 0)
end
--开始再生蜂巢
local function StartHiveGrowthTimer(inst)
	StopHiveGrowthTimer(inst)
	inst.components.timer:StartTimer("shorthivegrowth", 10)
end
--当凋零之蜂被移除
local function OnQueenRemoved(queen)
    if queen.hivebase ~= nil then
        local otherqueen = queen.hivebase.components.entitytracker:GetEntity("queen")--获取血坑对应的凋零之蜂
        --如果(血坑没有对应的凋零之蜂或者血坑对应的凋零之蜂就是当前这只凋零之蜂)并且血坑目前没有对应的凋零蜂巢，血坑就开始再生蜂巢
		if (otherqueen == nil or otherqueen == queen) and
            queen.hivebase.components.entitytracker:GetEntity("hive") == nil then
            StartHiveGrowthTimer(queen.hivebase)
        end
    end
end
--生成蜂王
local function DoSpawnQueen(inst, worker, x1, y1, z1)
    local x, y, z = inst.Transform:GetWorldPosition()
    local hivebase = inst.hivebase--获取蜂巢对应的血坑
    inst:Remove()--移除蜂巢

    local queen = SpawnPrefab("medal_beequeen")
    queen.Transform:SetPosition(x, y, z)
    queen:ForceFacePoint(x1, y1, z1)
	--把蜂巢破坏者作为仇视目标
    if worker:IsValid() and
        worker.components.health ~= nil and
        not worker.components.health:IsDead() and
        not worker:HasTag("playerghost") then
        queen.components.combat:SetTarget(worker)
    end

    queen.sg:GoToState("emerge")--播放钻出巢穴的动画
	if hivebase ~= nil then
		--召唤次数超过两次了，直接移除血坑
		if hivebase.spawncount and hivebase.spawncount>=2 then
			StopHiveGrowthTimer(hivebase)
			hivebase:Remove()
		else
			queen.hivebase = hivebase--绑定血坑
			StopHiveGrowthTimer(hivebase)
			hivebase.components.entitytracker:TrackEntity("queen", queen)--把血坑和凋零之蜂绑定
			hivebase:ListenForEvent("onremove", OnQueenRemoved, queen)--监听凋零之蜂的移除事件
			hivebase.spawncount=hivebase.spawncount and hivebase.spawncount+1 or 1--凋零之蜂的召唤次数统计+1
		end
    end
end
--计算蜂蜜等级(每敲两下降1级,最低0级,最高3级)
local function CalcHoneyLevel(workleft)
    return math.clamp(3 + math.ceil((workleft - TUNING.BEEQUEEN_SPAWN_MAX_WORK) * .5), 0, 3)
end
--更新蜂巢上的蜂蜜形状
local function RefreshHoneyState(inst)
    SetHoneyLevel(inst, CalcHoneyLevel(inst.components.workable.workleft))
end
--锤凋零蜂巢
local function OnWorked(inst, worker, workleft)
    if not inst.components.workable.workable then
        return
    end
	--停止再生计时器
    inst.components.timer:StopTimer("hiveregen")
	--如果蜂后的生成阈值大于0，那么蜂巢是不会被破坏的
    if workleft < 1 then
        inst.components.workable:SetWorkLeft(TUNING.BEEQUEEN_SPAWN_WORK_THRESHOLD > 0 and 1 or 0)
    end

    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/hive_hit")
    inst.AnimState:PlayAnimation("large_hit")
    SpawnPrefab("medal_honey_splash").Transform:SetPosition(inst.Transform:GetWorldPosition())--血蜜四溅的特效

    if worker ~= nil and worker:IsValid() and
        worker.components.health ~= nil and not worker.components.health:IsDead() and
        worker:HasTag("player") and not worker:HasTag("playerghost") then

        if TUNING.BEEQUEEN_SPAWN_WORK_THRESHOLD > 0 then
            --蜂王的生成几率=math.min(0.8,1-剩余锤击次数/12) ps:锤击次数>=12则几率为0
			local spawnchance = workleft < TUNING.BEEQUEEN_SPAWN_WORK_THRESHOLD and math.min(.8, 1 - workleft / TUNING.BEEQUEEN_SPAWN_WORK_THRESHOLD) or 0
            if math.random() < spawnchance then
                inst.components.workable:SetWorkable(false)
                SetHoneyLevel(inst, 0)--清空蜂蜜等级
                local x, y, z = worker.Transform:GetWorldPosition()
				--生成蜂王
                inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength(), DoSpawnQueen, worker, x, y, z)
                return
            end
        end

        local lootscale = workleft / TUNING.BEEQUEEN_SPAWN_MAX_WORK--战利品级别(敲的次数越多,敲出战利品的概率越小)
        local rnd = lootscale > 0 and math.random() / lootscale or 1
        --概率黏住玩家
		if rnd<.2 then
			SpawnPrefab("medal_blood_honey_splat").Transform:SetPosition(worker.Transform:GetWorldPosition())
			if worker.components.pinnable ~= nil then
				-- worker.components.pinnable:Stick("medal_blood_honey_goo")
                --有黑暗血糖
                if worker.medal_dark_ningxue then
                    --抵消buff时长
                    ConsumeMedalBuff(worker,"buff_medal_suckingblood",TUNING_MEDAL.MEDAL_BUFF_SUCKINGBLOOD_GOO_CONSUME)
                else
                    worker.components.pinnable:Stick("medal_blood_honey_goo")--黏他
                end
			end
		end
		
		--[[
		local loot =
            (rnd < .01 and "honeycomb") or--蜂巢
            (rnd < .5 and "honey") or--蜂蜜
            nil

        if loot ~= nil then
            LaunchAt(SpawnPrefab(loot), inst, worker, 1, 3.5, 1)--射出战利品
        end
        ]]
    end

    inst.AnimState:PushAnimation("large", false)
    RefreshHoneyState(inst)--更新蜂巢上的蜂蜜形状

    inst.components.timer:StartTimer("hiveregen", 4 * TUNING.SEG_TIME)--4个时段后开始再生
end
--蜂巢再生计时器
local function OnHiveRegenTimer(inst, data)
    if data.name == "hiveregen" and
        inst.components.workable.workable and
        inst.components.workable.workleft < TUNING.BEEQUEEN_SPAWN_MAX_WORK then
        local oldhoneylevel = CalcHoneyLevel(inst.components.workable.workleft)--计算原等级
        inst.components.workable:SetWorkLeft(inst.components.workable.workleft + 1)--锤击次数恢复1次
        local newhoneylevel = CalcHoneyLevel(inst.components.workable.workleft)--计算新等级
        if inst.components.workable.workleft < TUNING.BEEQUEEN_SPAWN_MAX_WORK then
            inst.components.timer:StartTimer("hiveregen", TUNING.SEG_TIME)--锤击次数没恢复满，1个时段后继续恢复
        end
        --预置物不处于休眠状态并且原等级和新等级有出入，则播放对应的蜂蜜生长动画
		if oldhoneylevel ~= newhoneylevel and not inst:IsAsleep() then
            inst.AnimState:PlayAnimation("transition")
            inst.AnimState:PushAnimation("large", false)
            SetHoneyLevel(inst, newhoneylevel, 10.5 * FRAMES)
        else--否则直接设个蜂蜜等级就完事了
            SetHoneyLevel(inst, newhoneylevel)
        end
    end
end
--控制血坑是否显示
local function EnableBase(inst, enable)
    inst.Physics:SetCapsule(PHYS_RAD_SML, 2)
    inst.Physics:SetActive(enable)
    inst.MiniMapEntity:SetEnabled(enable)
    inst.AnimState:PlayAnimation("hole_idle")
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    SetHoneyLevel(inst, 0)--设置蜂蜜等级为0
    if enable then
        inst:Show()
    else
        inst:Hide()
    end
end

local function OnHiveRemoved(hive)
    if hive.hivebase ~= nil then
        local otherhive = hive.hivebase.components.entitytracker:GetEntity("hive")
        if otherhive == nil or otherhive == hive then
            EnableBase(hive.hivebase, true)

            if hive.hivebase.components.entitytracker:GetEntity("queen") == nil then
                StartHiveGrowthTimer(hive.hivebase)
            end
        end
    end
end

local function OnHiveShortGrowAnimOver(inst)
    if inst.AnimState:IsCurrentAnimation("grow_hole_to_small") then
        inst.Physics:SetCapsule(PHYS_RAD_MED, 2)
        PushPhysRad(inst, 2)
        inst.AnimState:PlayAnimation("grow_small_to_medium")
        inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/hive_grow")
        return
    elseif inst.AnimState:IsCurrentAnimation("grow_small_to_medium") then
        inst.Physics:SetCapsule(PHYS_RAD_LRG, 2)
        PushPhysRad(inst, 3)
        inst.AnimState:PlayAnimation("grow_medium_to_large")
        inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/hive_grow")
        return
    elseif inst.AnimState:IsCurrentAnimation("grow_medium_to_large") then
        inst.AnimState:PlayAnimation("large")
    end
    inst.components.workable:SetWorkable(true)
    inst:RemoveEventCallback("animover", OnHiveShortGrowAnimOver)
end

local function OnHiveLongGrowAnimOver(inst)
    if inst.AnimState:IsCurrentAnimation("grow_hole_to_small") then
        inst.Physics:SetCapsule(PHYS_RAD_MED, 2)
        PushPhysRad(inst, 2)
        inst.AnimState:PlayAnimation("grow_small_to_medium")
        inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/hive_grow")
        SetHoneyLevel(inst, 2, 4 * FRAMES)
        return
    elseif inst.AnimState:IsCurrentAnimation("grow_small_to_medium") then
        inst.Physics:SetCapsule(PHYS_RAD_LRG, 2)
        PushPhysRad(inst, 3)
        inst.AnimState:PlayAnimation("grow_medium_to_large")
        inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/hive_grow")
        SetHoneyLevel(inst, 3, 7 * FRAMES)
        return
    elseif inst.AnimState:IsCurrentAnimation("grow_medium_to_large") then
        inst.AnimState:PlayAnimation("large")
        SetHoneyLevel(inst, 3)
    end
    inst.components.workable:SetWorkable(true)
    inst:RemoveEventCallback("animover", OnHiveLongGrowAnimOver)
end
--蜂巢生长
local function OnHiveGrowthTimer(inst, data)
    if data.name == "shorthivegrowth" or
		data.name == "firsthivegrowth" then

        EnableBase(inst, false)--隐藏血坑

        local hive = SpawnPrefab("medal_beequeenhivegrown")--生成凋零蜂巢
        hive.Transform:SetPosition(inst.Transform:GetWorldPosition())
        --预置物处于休眠状态
		if inst:IsAsleep() then
            PushPhysRad(hive, 3)--更新碰撞体积
            if data.name == "shorthivegrowth" then
                hive.components.workable:SetWorkLeft(1)--设置蜂巢的初始敲击次数为1
                hive.components.timer:StartTimer("hiveregen", 8 * TUNING.SEG_TIME)--蜂巢开始缓慢恢复敲击次数
                SetHoneyLevel(hive, 0)
            end
        else
			if data.name == "shorthivegrowth" then
                hive.Physics:SetCapsule(PHYS_RAD_SML, 2)
                hive.AnimState:PlayAnimation("grow_hole_to_small")
                hive:ListenForEvent("animover", OnHiveShortGrowAnimOver)
                hive.components.workable:SetWorkLeft(1)
                hive.components.timer:StartTimer("hiveregen", 8 * TUNING.SEG_TIME)
                SetHoneyLevel(hive, 0)
            else--if data.name == "firsthivegrowth" then
                hive.Physics:SetCapsule(PHYS_RAD_SML, 2)
                hive.AnimState:PlayAnimation("grow_hole_to_small")
                hive:ListenForEvent("animover", OnHiveLongGrowAnimOver)
                SetHoneyLevel(hive, 1)
            end
            hive.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/hive_grow")
            hive.components.workable:SetWorkable(false)
        end

        hive.hivebase = inst
        inst.components.entitytracker:TrackEntity("hive", hive)
        inst:ListenForEvent("onremove", OnHiveRemoved, hive)
    end
end

local function OnBaseLoadPostPass(inst, newents, data)
    local hive = inst.components.entitytracker:GetEntity("hive")
    if hive ~= nil then
        hive.hivebase = inst
        StopHiveGrowthTimer(inst)
        EnableBase(inst, false)
        inst:ListenForEvent("onremove", OnHiveRemoved, hive)
    end

    local queen = inst.components.entitytracker:GetEntity("queen")
    if queen ~= nil then
        queen.hivebase = inst
        StopHiveGrowthTimer(inst)
        inst:ListenForEvent("onremove", OnQueenRemoved, queen)
    end
end

local function OnBaseLoad(inst, data)
    if data and data.spawncount then
		inst.spawncount=data.spawncount--读取召唤次数计数
	end
	
	if inst.components.timer:TimerExists("shorthivegrowth") then
		inst.components.timer:StopTimer("firsthivegrowth")
	end
end

local function OnBaseSave(inst, data)
	data.spawncount = inst.spawncount or nil--存储召唤次数计数
end

local function BaseGetStatus(inst)
    return not inst.AnimState:IsCurrentAnimation("hole_idle") and "GROWING" or nil
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, PHYS_RAD_LRG)

    inst:AddTag("event_trigger")
    inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("medal_beequeen")--凋零之蜂标签(用来确认世界唯一性)

    inst.AnimState:SetBank("bee_queen_hive")
    inst.AnimState:SetBuild("medal_bee_queen_hive")
    inst.AnimState:PlayAnimation("large")
    inst.AnimState:Hide("honey0")
    inst.AnimState:Hide("honey1")
    inst.AnimState:Hide("honey2")

    inst.Transform:SetScale(1.4, 1.4, 1.4)

    inst.MiniMapEntity:SetIcon("medal_beequeenhivegrown.tex")

    inst.physrad = net_tinybyte(inst.GUID, "beequeenhivegrown.physrad", "physraddirty")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("physraddirty", OnPhysRadDirty)

        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnHiveRegenTimer)--监听蜂巢再生计时器

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnWorkCallback(OnWorked)
    inst.components.workable:SetMaxWork(TUNING.BEEQUEEN_SPAWN_MAX_WORK)--要锤16下
    inst.components.workable:SetWorkLeft(TUNING.BEEQUEEN_SPAWN_MAX_WORK)
    inst.components.workable.savestate = true

    MakeHauntableWork(inst)

    inst.OnLoad = RefreshHoneyState

    return inst
end

local function base_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    --MakeObstaclePhysics(inst, 1)
    ----------------------------------------------------
    inst:AddTag("blocker")
	inst:AddTag("medal_beequeen")--凋零之蜂标签(用来确认世界唯一性)
    inst.entity:AddPhysics()
    inst.Physics:SetMass(0)
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.ITEMS)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    --inst.Physics:CollidesWith(COLLISION.GIANTS)
    inst.Physics:SetCapsule(PHYS_RAD_SML, 2)
    ----------------------------------------------------

    inst.AnimState:SetBank("bee_queen_hive")
    inst.AnimState:SetBuild("medal_bee_queen_hive")
    inst.AnimState:PlayAnimation("hole_idle")
    inst.AnimState:Hide("honey1")
    inst.AnimState:Hide("honey2")
    inst.AnimState:Hide("honey3")
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    inst.Transform:SetScale(1.4, 1.4, 1.4)

    inst.MiniMapEntity:SetIcon("medal_beequeenhive.tex")

    inst.physrad = net_tinybyte(inst.GUID, "beequeenhive.physrad", "physraddirty")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("physraddirty", OnPhysRadDirty)

        return inst
    end

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = BaseGetStatus

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("firsthivegrowth", 10)--10秒后从血坑内钻出凋零蜂巢
    inst:ListenForEvent("timerdone", OnHiveGrowthTimer)

    inst:AddComponent("entitytracker")

    inst.OnLoadPostPass = OnBaseLoadPostPass
    inst.OnLoad = OnBaseLoad
    inst.OnSave = OnBaseSave

    return inst
end

return Prefab("medal_beequeenhive", base_fn, assets, base_prefabs),--蔷薇血池
    Prefab("medal_beequeenhivegrown", fn, assets, prefabs)--凋零蜂巢
