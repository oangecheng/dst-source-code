require("worldsettingsutil")

local assets =
{
    Asset("ANIM", "anim/lunarthrall_plant_front.zip"),
    Asset("ANIM", "anim/lunarthrall_plant_back.zip"),
    Asset("MINIMAP_IMAGE", "lunarthrall_plant"),
}

local vineassets =
{
    Asset("ANIM", "anim/lunarthrall_plant_vine.zip"),
    Asset("ANIM", "anim/lunarthrall_plant_vine_big.zip"),
}

local prefabs =
{
    "lunarthrall_plant_back",
    "lunarthrall_plant_gestalt",
    "lunarplant_husk",
    "lunarthrall_plant_vine",
    "lunarthrall_plant_vine_end",
}


local function customPlayAnimation(inst,anim,loop)
    inst.AnimState:PlayAnimation(anim,loop)
    if inst.back then
        inst.back.AnimState:PlayAnimation(anim,loop)
    end
end

local function customPushAnimation(inst,anim,loop)
    inst.AnimState:PushAnimation(anim,loop)
    if inst.back then
        inst.back.AnimState:PushAnimation(anim,loop)
    end
end

local function customSetRandomFrame(inst)
    local frame = math.random(inst.AnimState:GetCurrentAnimationNumFrames()) -1
    inst.AnimState:SetFrame(frame)
    
    if inst.back then
        inst.back.AnimState:SetFrame(frame)
    end
end

---------------------------------茎叶(底部)------------------------------------

local function back_onentityreplicated(inst)
	local parent = inst.entity:GetParent()
	if parent ~= nil and parent.prefab == "lunarthrall_plant" then
		table.insert(parent.highlightchildren, inst)
	end
end

local function back_onremoveentity(inst)
	local parent = inst.entity:GetParent()
	if parent ~= nil and parent.highlightchildren ~= nil then
		table.removearrayvalue(parent.highlightchildren, inst)
	end
end

local function backfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("lunarthrall_plant_back")
    inst.AnimState:SetBuild("lunarthrall_plant_back")
    inst.AnimState:PlayAnimation("idle_med", true)

    inst:AddTag("fx")

	inst.OnRemovedEntity = back_onremoveentity

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		inst.OnEntityReplicated = back_onentityreplicated

        return inst
    end

    inst.persists = false

    return inst
end

---------------------------------主体------------------------------------
local loot = {
    "lunarplant_husk",
    "lunarplant_husk",
    "plantmeat",
    "plantmeat",
}

--生成底部茎叶
local function spawnback(inst)
    local back = SpawnPrefab("medal_origin_tree_guard_back")
    back.AnimState:SetFinalOffset(-1)
    inst.back = back
	table.insert(inst.highlightchildren, back)

    back:ListenForEvent("death", function()
        local self = inst.components.burnable
        if self ~= nil and self:IsBurning() and not self.nocharring then
            back.AnimState:SetMultColour(.2, .2, .2, 1)
        end
    end, inst)

    if math.random() < 0.5 then
        inst.AnimState:SetScale(-1,1)
        back.AnimState:SetScale(-1,1)
    end
    local color = .6 + math.random() * .4
    inst.tintcolor = color
    inst.AnimState:SetMultColour(color, color, color, 1)
    back.AnimState:SetMultColour(color, color, color, 1)

	back.entity:SetParent(inst.entity)
    inst.components.colouradder:AttachChild(back)
end

--寄生
local function infest(inst,target)
    if target then
        
        if target.components.pickable then
            target.components.pickable.caninteractwith = false
        end

        if target.components.growable then
            target.components.growable:Pause("lunarthrall_plant")
        end
        
        target:AddTag("NOCLICK")

        inst.components.entitytracker:TrackEntity("targetplant", target)
        target.lunarthrall_plant = inst
        inst.Transform:SetPosition(target.Transform:GetWorldPosition())
        local bbx1, bby1, bbx2, bby2 = target.AnimState:GetVisualBB()
        local bby = bby2 - bby1
        if bby < 2 then
            inst.targetsize = "short"
        elseif bby < 4 then
            inst.targetsize = "med"
        else
            inst.targetsize = "tall"
        end
        inst:customPlayAnimation("idle_"..inst.targetsize )
        inst.AnimState:SetFrame(math.random(inst.AnimState:GetCurrentAnimationNumFrames()) - 1)
        TheWorld:PushEvent("lunarthrallplant_infested",target)
    end
end
--解除寄生
local function deinfest(inst)
    local target = inst.components.entitytracker:GetEntity("targetplant")
    if target then
        if target.components.pickable then
            target.components.pickable.caninteractwith = true
        end
        if target.components.growable then
            target.components.growable:Resume("lunarthrall_plant")
        end            
        target:RemoveTag("NOCLICK")
    end
end
--播放生成动画
local function playSpawnAnimation(inst)
    inst.sg:GoToState("spawn")
end

-- local function OnFreeze(inst)
-- 	if inst.waketask ~= nil then
-- 		inst.waketask:Cancel()
-- 		inst.waketask = nil
-- 	end
-- 	if inst.resttask ~= nil then
-- 		inst.resttask:Cancel()
-- 		inst.resttask = nil
-- 	end
-- 	if inst.tired or inst.wake then
-- 		inst.wake = nil
-- 		inst.tired = nil
-- 		inst.vinelimit = TUNING.LUNARTHRALL_PLANT_VINE_LIMIT
-- 	end
-- end
--移除单条藤蔓
local function vineremoved(inst,vine,killed)
    for i,localvine in ipairs(inst.vines)do
        if localvine == vine then
            table.remove(inst.vines,i)--从藤蔓列表中移除该藤蔓
            if not killed then--如果藤蔓不是被击杀的，那么说明是特殊移除的，守卫藤蔓数量+1，方便继续生成藤蔓
                inst.vinelimit = inst.vinelimit + 1
            end
			break
        end
    end
end
--苏醒，斩杀时刻！
local function OnWakeTask(inst)
	inst.waketask = nil
	inst.wake = nil
	inst.tired = nil
	inst.vinelimit = TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_VINE_LIMIT--重置藤蔓数量
	inst.sg:GoToState("attack")
end
--休眠结束,开始准备苏醒
local function OnRestTask(inst)
	inst.resttask = nil

	if not inst.components.health:IsDead() then
		inst.sg:GoToState("tired_wake")--做快苏醒的动作,提醒玩家远离

		if inst.waketask ~= nil then
			inst.waketask:Cancel()
		end
		inst.waketask = inst:DoTaskInTime(TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_WAKE_TIME, OnWakeTask)
	end
end
--藤蔓被击杀
local function vinekilled(inst,vine)
    for i,localvine in ipairs(inst.vines)do
        if localvine == vine then
            vineremoved(inst,vine, true)--移除该藤蔓
            --如果守卫的藤蔓数量清零了，进入透支休眠状态，任人宰割
            if inst.vinelimit <= 0 and #inst.vines <= 0 then
                if not inst.components.health:IsDead() then
                    inst.sg:GoToState("tired_pre")
                end
				if inst.waketask ~= nil then
					inst.waketask:Cancel()
					inst.waketask = nil
				end
				if inst.resttask ~= nil then
					inst.resttask:Cancel()
				end
				inst.resttask = inst:DoTaskInTime(TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_REST_TIME + (math.random()*1), OnRestTask)
            end
        end
    end  
end
--移除所有藤蔓
local function killvines(inst)
    for i,localvine in ipairs(inst.vines)do
        if localvine:IsValid() then
            localvine.components.health:Kill()
        end
    end
end
--挨打
local function OnAttacked(inst,data)
    if data.attacker then
        if (
                not inst.components.combat.target 
                or (inst.components.combat.target ~= data.attacker and not inst.components.timer:TimerExists("targetswitched"))
            ) 
            and not data.attacker.components.complexprojectile
            and not data.attacker.components.projectile then

			inst.components.timer:StopTimer("targetswitched")
            inst.components.timer:StartTimer("targetswitched",20)--20秒内挨打不会切换仇恨目标
            inst.components.combat:SetTarget(data.attacker)
        end
    end
end

-- local function vine_addcoldness(vine, ...)
-- 	local inst = vine.parentplant
-- 	if inst ~= nil and inst:IsValid() then
-- 		inst.components.freezable:AddColdness(...)
-- 		return true
-- 	end
-- 	return false
-- end


-- local PLANT_MUST = {"lunarthrall_plant"}
local TARGET_MUST_TAGS = { "_combat", "character" }
local TARGET_CANT_TAGS = { "INLIMBO","lunarthrall_plant", "lunarthrall_plant_end","chaos_creature" }
--寻找合适的攻击对象
local function Retarget(inst)
    if inst.no_targeting or inst.tired or inst.vinelimit<=0 then return end
    local guards = TheWorld and TheWorld.medal_origin_tree ~= nil and TheWorld.medal_origin_tree.origin_guards or nil--本源之树的守卫列表
    local target = FindEntity(
        inst,
        TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_RANGE,
        function(guy)
            if guards == nil then
                return inst.components.combat:CanTarget(guy)
            end
            local total = 0
            --遍历守卫列表,如果目标被过多的守卫盯上了就算了
            for i, guard in pairs(guards)do
                if guard ~= inst and guard:HasTag("origin_guard") then
                    if guard.components.combat and guard.components.combat.target and guard.components.combat.target == guy then
                        total = total + 1
                    end
                end
            end
            if total < 3 then
                return inst.components.combat:CanTarget(guy)
            end
        end,
        TARGET_MUST_TAGS,
        TARGET_CANT_TAGS
    )

    if target then
        local pos = inst:GetPosition()
        local theta = math.random()*TWOPI
        local radius = TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_VINE_MOVEDIST
        local offset = Vector3(radius * math.cos( theta ), 0, -radius * math.sin( theta ))
        pos = pos + offset
        --找到合适的目标后，确认目标位置可以正常生成藤蔓
        if TheWorld.Map:IsVisualGroundAtPoint(pos.x,pos.y,pos.z) then
            local vine = SpawnPrefab("medal_origin_tree_guard_vine_end")
            vine.Transform:SetPosition(pos.x,pos.y,pos.z)
            vine.Transform:SetRotation(inst:GetAngleToPoint(pos.x, pos.y, pos.z))
            vine.sg:RemoveStateTag("nub")
            if inst.tintcolor then
                vine.AnimState:SetMultColour(inst.tintcolor, inst.tintcolor, inst.tintcolor, 1)
                vine.tintcolor = inst.tintcolor
            end

            inst.components.colouradder:AttachChild(vine)

            vine.parentplant = inst--标记为藤蔓的母体
            table.insert(inst.vines,vine)--将藤蔓加入藤蔓列表,方便后续处理
            inst.vinelimit = inst.vinelimit -1--可生成的藤蔓数量减1
            inst:DoTaskInTime(0,function() vine:ChooseAction() end)

            return target
        end
    end
    
    --print("RETARGET")
    -- if not inst.no_targeting then
    --     local target = FindEntity(
    --         inst,
    --         TUNING.LUNARTHRALL_PLANT_RANGE,
    --         function(guy)
    --             local total = 0
    --             local x,y,z = inst.Transform:GetWorldPosition()

    --             if inst.tired then
    --                 return nil
    --             end

    --             local plants = TheSim:FindEntities(x,y,z, 15, PLANT_MUST)
    --             for i, plant in ipairs(plants)do
    --                 if plant ~= inst then
    --                     if plant.components.combat.target and plant.components.combat.target == guy then
    --                         total = total +1
    --                     end
    --                 end
    --             end
    --             if total < 3 then
    --                 return inst.components.combat:CanTarget(guy)
    --             end
    --         end,
    --         TARGET_MUST_TAGS,
    --         TARGET_CANT_TAGS
    --     )

    --     if inst.vinelimit > 0 then
    --         if target then-- and ( not inst.components.freezable or not inst.components.freezable:IsFrozen()) then

    --             local pos = inst:GetPosition()

    --             local theta = math.random()*TWOPI
    --             local radius = TUNING.LUNARTHRALL_PLANT_MOVEDIST
    --             local offset = Vector3(radius * math.cos( theta ), 0, -radius * math.sin( theta ))
    --             pos = pos + offset

    --             if TheWorld.Map:IsVisualGroundAtPoint(pos.x,pos.y,pos.z) then

    --                 local vine = SpawnPrefab("medal_origin_tree_guard_vine_end")
    --                 vine.Transform:SetPosition(pos.x,pos.y,pos.z)
    --                 vine.Transform:SetRotation(inst:GetAngleToPoint(pos.x, pos.y, pos.z))
    -- 				-- vine.components.freezable:SetRedirectFn(vine_addcoldness)
    --                 vine.sg:RemoveStateTag("nub")
    --                 if inst.tintcolor then
    --                     vine.AnimState:SetMultColour(inst.tintcolor, inst.tintcolor, inst.tintcolor, 1)
    --                     vine.tintcolor = inst.tintcolor
    --                 end

    -- 				inst.components.colouradder:AttachChild(vine)

    --                 vine.parentplant = inst
    --                 table.insert(inst.vines,vine)
    --                 inst.vinelimit = inst.vinelimit -1
    --                 inst:DoTaskInTime(0,function() vine:ChooseAction() end)

    --                 return target
    --             end
    --         end
    --     end
    -- end
end
--保持仇恨目标
local function keeptargetfn(inst, target)
   return target ~= nil
        and target:GetDistanceSqToInst(inst) < TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_GIVEUPRANGE* TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_GIVEUPRANGE
        and target.components.combat ~= nil
        and target.components.health ~= nil
        and not target.components.health:IsDead()
        and not (inst.components.follower ~= nil and
                (inst.components.follower.leader == target or inst.components.follower:IsLeaderSame(target)))
end

--月焰特效
local function CreateFlame()
    local inst = CreateEntity()

    inst:AddTag("FX")
    --[[Non-networked entity]]
    if not TheWorld.ismastersim then
        inst.entity:SetCanSleep(false)
    end
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddFollower()

    inst.AnimState:SetBank("lunarthrall_plant")
    inst.AnimState:SetBuild("lunarthrall_plant_front")
    inst.AnimState:PlayAnimation("gestalt_fx", true)
	inst.AnimState:SetMultColour(1, 1, 1, 0.6)
	inst.AnimState:SetLightOverride(0.1)
    inst.AnimState:SetFrame( math.random(inst.AnimState:GetCurrentAnimationNumFrames()) -1)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    return inst
end

--打人
local function AttackOther(inst,data)
    if data ~= nil and data.target ~= nil and data.target:IsValid() and not IsEntityDeadOrGhost(data.target)  then
        --添加寄生值
        if data.target.components.health ~= nil then
            data.target.components.health:DoDeltaMedalParasitic(TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_PARASITIC)
        end
        --混乱
        data.target:AddDebuff("buff_medal_confusion","buff_medal_confusion",{add_duration = TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_CONFUSION_TIME})
    end
end

--死亡
local function OnDeath(inst)
    inst:killvines()--连带藤蔓一起挂了
    local target = inst.components.entitytracker:GetEntity("targetplant")
    if target then
        target.lunarthrall_plant = nil
    end    
    if inst.waketask then
        inst.waketask:Cancel()
        inst.waketask = nil
    end
    if inst.resttask then
        inst.resttask:Cancel()
        inst.resttask = nil
    end    
    inst.components.lootdropper:DropLoot()
    inst:customPlayAnimation("death_"..inst.targetsize )
    inst:ListenForEvent("animover", function()
        if inst.AnimState:IsCurrentAnimation("death_"..inst.targetsize) then
            inst:Remove()
        end
    end)
end
--移除时执行
local function OnRemove(inst)
    inst:deinfest()
    inst:killvines()
    if TheWorld and TheWorld.medal_origin_tree ~= nil and TheWorld.medal_origin_tree.RemoveGuard ~= nil then
        TheWorld.medal_origin_tree:RemoveGuard(inst)--从本源之树列表中移除
    end
end


--初始化
-- local function guard_oninit(inst)
--     if TheWorld and TheWorld.medal_origin_tree ~= nil and TheWorld.medal_origin_tree.AddGuard ~= nil then
--         TheWorld.medal_origin_tree:AddGuard(inst)--加入本源之树列表
--     end
-- end

local function OnGuardSave(inst, data)
    if inst.guard_idx then
        data.guard_idx = inst.guard_idx
    end
end

local function OnLoadPostPass(inst, newents, data)
    if data ~= nil and data.guard_idx ~= nil then
        if TheWorld and TheWorld.medal_origin_tree ~= nil and TheWorld.medal_origin_tree.AddGuard ~= nil then
            TheWorld.medal_origin_tree:AddGuard(inst,data.guard_idx)--加入本源之树列表
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, .8)
	inst:SetPhysicsRadiusOverride(.4) --V2C: WARNING intentionally reducing range for incoming attacks; make sure everyone can still reach!

    inst.MiniMapEntity:SetIcon("lunarthrall_plant.png")
    inst.MiniMapEntity:SetPriority(5)

    inst.AnimState:SetBank("lunarthrall_plant")
    inst.AnimState:SetBuild("lunarthrall_plant_front")
    inst.AnimState:PlayAnimation("idle_med", true)
    inst.AnimState:SetFinalOffset(1)
    -- inst.scrapbook_anim = "scrapbook"
    -- inst.scrapbook_specialinfo = "LUNARTHRALLPLANT"
    -- inst.scrapbook_planardamage = TUNING.LUNARTHRALL_PLANT_PLANAR_DAMAGE


    inst.customPlayAnimation = customPlayAnimation
    inst.customPushAnimation = customPushAnimation
    inst.customSetRandomFrame = customSetRandomFrame

    inst:AddTag("plant")
    -- inst:AddTag("lunar_aligned")
    inst:AddTag("hostile")
    inst:AddTag("lunarthrall_plant")
    inst:AddTag("retaliates")
    inst:AddTag("NPCcanaggro")--伯尼会主动打的
    inst:AddTag("chaos_creature")--混沌生物
    inst:AddTag("origin_guard")--本源守卫

	inst.highlightchildren = {}

    inst.entity:SetPristine()

    inst.targetsize = "med"

    if not TheNet:IsDedicated() then
        inst.flame = CreateFlame()
        inst.flame.entity:SetParent(inst.entity)
        inst.flame.Follower:FollowSymbol(inst.GUID, "follow_gestalt_fx", nil, nil, nil, true)
    end

    if not TheWorld.ismastersim then
        return inst
    end

    inst:customSetRandomFrame()

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_HEALTH)

    inst:AddComponent("combat")
    inst.components.combat:SetRetargetFunction(1, Retarget)
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)
    inst.components.combat:SetDefaultDamage(TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_DAMAGE)

	inst:AddComponent("planarentity")--实体抵抗
    inst.ChaosDeathTimesKey = "medal_origin_tree"--死亡次数以本源之树的为准
    inst:AddComponent("medal_chaosdamage")--混沌伤害
    inst.components.medal_chaosdamage:SetBaseDamage(TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_CHAOS_DAMAGE)
	-- inst:AddComponent("planardamage")
	-- inst.components.planardamage:SetBaseDamage(TUNING.LUNARTHRALL_PLANT_PLANAR_DAMAGE)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)

    inst:AddComponent("inspectable")
    inst:AddComponent("entitytracker")

    inst:AddComponent("colouradder")
    inst:AddComponent("timer")

    inst:ListenForEvent("death", OnDeath)
	-- inst:ListenForEvent("freeze", OnFreeze)
    inst:ListenForEvent("onremove",OnRemove)
    inst:ListenForEvent("attacked",OnAttacked)
    inst:ListenForEvent("onareaattackother", AttackOther)

    inst.vines = {}--藤蔓列表
    inst.vinekilled = vinekilled
    inst.vineremoved = vineremoved
    inst.killvines = killvines
    inst.vinelimit = TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_VINE_LIMIT--藤蔓数量上限

    inst.infest = infest
    inst.deinfest = deinfest
    inst.playSpawnAnimation = playSpawnAnimation
    inst.OnSave = OnGuardSave
    inst.OnLoadPostPass = OnLoadPostPass

    -- MakeMediumFreezableCharacter(inst)
    -- inst.components.freezable:SetResistance(6)
    -- MakeLargeBurnableCharacter(inst,"follow_gestalt_fx")

    inst:SetStateGraph("SGmedal_origin_tree_guard")

	spawnback(inst)

    -- inst:DoTaskInTime(0,guard_oninit)--初始化

    return inst
end

---------------------------------钻地藤蔓(中段)------------------------------------

-- local function OnWeakVineAttacked(inst)
-- 	if inst.headplant ~= nil and inst.headplant:IsValid() then
-- 		local parent = inst.headplant.parentplant
-- 		if parent ~= nil and parent:IsValid() and parent.components.freezable:IsFrozen() then
-- 			parent.components.freezable:Unfreeze()
-- 		end
-- 	end
-- end
--设为脆弱(可攻击)的藤蔓
local function makeweak(inst, headplant)
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_VINE_HEALTH)
    --伤害让尖端承受
    inst.components.health.redirect = function(target, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
        if inst.headplant and inst.headplant:IsValid() then
            inst.headplant.indirectdamage = inst.GUID
            local result = inst.headplant.components.health:DoDelta(amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
            if not inst.headplant.components.health:IsDead() then
                inst.headplant.indirectdamage = nil
            end
            return result
        end
    end
    inst:AddComponent("combat")
    inst:AddComponent("planarentity")
    inst.ChaosDeathTimesKey = "medal_origin_tree"--死亡次数以本源之树的为准

	-- inst:ListenForEvent("attacked", OnWeakVineAttacked)
    --同步仇恨目标
	if headplant ~= nil then
		local target = headplant.components.combat.target
		if target ~= nil then
			inst.components.combat:SetTarget(target)
		end
		inst:ListenForEvent("newcombattarget", function(headplant, data)
			inst.components.combat:SetTarget(data.target)
		end, headplant)
		inst:ListenForEvent("droppedtarget", function(headplant, data)
			inst.components.combat:DropTarget()
		end, headplant)
	end

    inst:AddTag("weakvine")
    inst.AnimState:SetBank("lunarthrall_plant_vine_big")
    inst.AnimState:SetBuild("lunarthrall_plant_vine_big")

    inst:RemoveTag("fx")
    inst:RemoveTag("NOCLICK")
    inst:AddTag("hostile")
    inst:AddTag("lunarthrall_plant_segment")
    inst:AddTag("chaos_creature")--混沌生物
    -- inst:AddTag("lunar_aligned")
end

local function vine_onremoveentity(inst)
	if inst.headplant ~= nil and inst.headplant.tails ~= nil then
		table.removearrayvalue(inst.headplant.tails, inst)
	end
end

local function vinefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("lunarthrall_plant_vine")
    inst.AnimState:SetBuild("lunarthrall_plant_vine")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetFinalOffset(1)
    inst.Transform:SetSixFaced()

    inst.AnimState:SetScale(1.2,1.2,1.2)

    inst:AddTag("fx")
    inst:AddTag("NOCLICK")
    inst:AddTag("soulless")

    inst:SetPrefabNameOverride("medal_origin_tree_guard_vine_end")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("colouradder")

    -- MakeMediumFreezableCharacter(inst)
    -- inst.components.freezable:SetResistance(6)
    -- MakeMediumBurnableCharacter(inst)

    inst.persists = false
    inst.makeweak = makeweak--设为脆弱(可攻击)的藤蔓

    inst:SetStateGraph("SGmedal_origin_tree_guard_vine")

	inst.OnRemoveEntity = vine_onremoveentity

    return inst
end

---------------------------------钻地藤蔓(尖端)------------------------------------
--行为树
local function ChooseAction(inst)
    --print("===== CHOSE ACTION")
    inst.target = inst.parentplant and inst.parentplant.components.combat.target--同步母体仇恨目标
    if inst.target then
        inst.components.combat:SetTarget(inst.target)
    end
    --如果当前是"撤退模式"，保持住即可
    if inst.mode == "retreat" then
        -- just keep going
    --否则如果当前没目标了或者目标挂了，那就切状态为"返回模式"
    elseif not inst.target or not inst.target:IsValid() or not inst.target.components.health or inst.target.components.health:IsDead() then
        inst.target = nil
        inst.mode = "return"
        --print("vine: NO TARGET, GO HOME")
    --否则只要当前不处于"回避模式"，就一律切换为"进攻模式"
    elseif inst.mode ~= "avoid" then
        inst.mode = "attack"
    end
    --如果有目标并且当前是"进攻模式"
    if inst.target and inst.mode == "attack" then
        --print("vine: in ATTACK mode")
        local dist = inst:GetDistanceSqToInst(inst.target)--计算和目标间的距离
        --如果已经贴近目标,那么直接发起攻击！
        if dist < TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_VINE_INITIATE_ATTACK * TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_VINE_INITIATE_ATTACK then
            --print("vine: ATTACK")
            if not inst.components.timer:TimerExists("attack_cooldown") then
                inst:PushEvent("doattack")
            end
        else--否则尝试接近目标
            local pos = Vector3(inst.target.Transform:GetWorldPosition())
            local theta = inst:GetAngleToPoint(pos)*DEGREES
            local radius = math.sqrt(dist) - TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_VINE_CLOSEDIST--控制好最近距离，不至于直接在目标脚底下钻出来
            local ITERATIONS = 5--试探次数
            local offset = Vector3(radius * math.cos( theta ), 0, -radius * math.sin( theta ))

            local newpos = Vector3(inst.Transform:GetWorldPosition())

            --通过多次试探确认自己和目标的直线路线中是否包括水域
            local onwater = false
            for i = 1, ITERATIONS do
                local testpos = newpos + offset * (i / ITERATIONS)
                if not TheWorld.Map:IsVisualGroundAtPoint(testpos.x, testpos.y, testpos.z) then
                    onwater = true
                    break
                end
            end
            --遍历自己的藤蔓列表确认是否有距离目标点更近的藤蔓,有的话可以直接后退
            newpos = newpos + offset
            dist = inst:GetDistanceSqToPoint(newpos)
            local moveback = nil
            for i,nub in ipairs(inst.tails)do
                local nubdist = nub:GetDistanceSqToPoint(newpos)
                if nubdist < dist then
                    dist = nubdist
                    moveback = true
                    break
                end
            end
            --确认可以后退并且不在水上，那就后退
            if moveback and not onwater then
                --print("vine: MOVEBACK")
                inst:PushEvent("moveback")
            else--否则判断下自己藤蔓数量是不是小于7，并且前方不是水域，是的话就向新目标点前进
                if #inst.tails < 7 and not onwater then
                    --print("vine: MOVE FORWARD")
                    inst:PushEvent("moveforward", {newpos=newpos})
                else--否则就直接钻出来
                    --print("EMERGE")
                    inst:PushEvent("emerge")
                end
            end
        end
    --如果当前处于"回避模式",过程和进攻差不多,只不过目标坐标点从目标位置换成了自己身后的一段距离
    elseif inst.mode == "avoid" then
        --print("vine: in AVOID mode")
        local pos = Vector3(inst.Transform:GetWorldPosition())
        local theta = (inst:GetAngleToPoint(pos)*DEGREES) - PI
        local radius = 4 * TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_VINE_MOVEDIST--闪避距离
        local offset = Vector3(radius * math.cos( theta ), 0, -radius * math.sin( theta ))

        local newpos = pos + offset

        local dist = inst:GetDistanceSqToPoint(newpos)
        local moveback = nil
        for i,nub in ipairs(inst.tails)do
            local nubdist = nub:GetDistanceSqToPoint(newpos)
            if nubdist < dist then
                dist = nubdist
                moveback = true
                break
            end
        end
        if moveback then
            --print("MOVE BACKWARD")
            inst:PushEvent("moveback")
        else
            if #inst.tails < 7 then
                --print("MOVE FOREWARD")
                inst:PushEvent("moveforward", {newpos=newpos})
            else
                --print("EMERGE")
                inst:PushEvent("emerge")
            end
        end
        -- move away from target and wait.
    --"撤退模式"或"返回模式"就直接后退
    elseif inst.mode == "return" or inst.mode == "retreat" then
       -- print("vine: in RETURN mode")
        inst:PushEvent("moveback")
    end
end
--移除后端藤蔓
local function removetail(inst)
    if #inst.tails > 0 then
        local time = 0
        for i=#inst.tails,1,-1 do
            time = time + 0.1
            local tail = inst.tails[i]
            --从新到旧依次遍历藤蔓然后挨个移除
            if not tail.errodetask then
                if tail:HasTag("weakvine") and inst.indirectdamage == tail.GUID then
                    tail.sg:GoToState("death")
                end
				if tail.components.combat ~= nil then
					tail:AddTag("NOCLICK")
					tail:AddTag("notarget")
				end
                tail.errodetask = tail:DoTaskInTime(time,ErodeAway)
            end
        end
    end
end
--标识为脆弱(可攻击)的藤蔓
local function setweakstate(inst, weak )
    if weak then
        inst:AddTag("weakvine")
        inst.AnimState:SetBank("lunarthrall_plant_vine_big")
        inst.AnimState:SetBuild("lunarthrall_plant_vine_big")
    else
        inst:RemoveTag("weakvine")
        inst.AnimState:SetBank("lunarthrall_plant_vine")
        inst.AnimState:SetBuild("lunarthrall_plant_vine")
    end
end

--揍人
local function OnAttackOther(inst, data)
    if data ~= nil and data.target ~= nil and data.target:IsValid() and not IsEntityDeadOrGhost(data.target)  then
        --混乱
        data.target:AddDebuff("buff_medal_confusion","buff_medal_confusion",{add_duration = TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_VINE_CONFUSION_TIME})
    end
end

local function vineendfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("plant")
    -- inst:AddTag("lunar_aligned")
    inst:AddTag("lunarthrall_plant_end")
    inst:AddTag("hostile")
    inst:AddTag("soulless")
    inst:AddTag("NPCcanaggro")
    inst:AddTag("chaos_creature")--混沌生物

    inst.AnimState:SetBank("lunarthrall_plant_vine")
    inst.AnimState:SetBuild("lunarthrall_plant_vine")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetFinalOffset(1)
    inst.Transform:SetSixFaced()

    inst.AnimState:SetScale(1.2,1.2,1.2)

    inst.customPlayAnimation = customPlayAnimation
    inst.customPushAnimation = customPushAnimation

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_VINE_HEALTH)

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_VINE_DAMAGE)

	inst:AddComponent("planarentity")
    inst.ChaosDeathTimesKey = "medal_origin_tree"--死亡次数以本源之树的为准
    inst:AddComponent("medal_chaosdamage")--混沌伤害
	inst.components.medal_chaosdamage:SetBaseDamage(TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_VINE_CHAOS_DAMAGE)
	-- inst:AddComponent("planardamage")
	-- inst.components.planardamage:SetBaseDamage(TUNING.LUNARTHRALL_PLANT_END_PLANAR_DAMAGE)

	inst:AddComponent("colouradder")
    inst:AddComponent("timer")

    inst:AddComponent("inspectable")
    inst.tails = {}--藤蔓列表
    inst.mode = "attack"
    inst.ChooseAction = ChooseAction
    inst.persists = false
    inst.setweakstate = setweakstate
    inst:ListenForEvent("attacked", function()
        if inst.mode == "attack" then
            inst.mode = "avoid"
            inst:DoTaskInTime(math.random()*3 + 1, function()
                inst.mode = "attack"
            end)
        end
		-- if inst.parentplant ~= nil and inst.parentplant:IsValid() and inst.parentplant.components.freezable:IsFrozen() then
		-- 	inst.parentplant.components.freezable:Unfreeze()
		-- end
    end)
    inst:ListenForEvent("timerdone", function(inst,data)
        if data.name == "idletimer" then
            inst.mode = "retreat"
        end
    end)
    inst:ListenForEvent("death", function() 
        removetail(inst)
        if inst.parentplant and inst.parentplant:IsValid() then
            inst.parentplant:vinekilled(inst)
        end
    end)
    inst:ListenForEvent("onremove", function() 
        removetail(inst)
        --vine.parentplant do something
        if inst.parentplant and inst.parentplant:IsValid() then
            inst.parentplant:vineremoved(inst)
        end
    end)
    
    inst:ListenForEvent("onattackother", OnAttackOther)--攻击到目标时

    -- MakeMediumFreezableCharacter(inst)
    -- inst.components.freezable:SetResistance(6)
    -- MakeMediumBurnableCharacter(inst)

    inst:SetStateGraph("SGmedal_origin_tree_guard_vine")

    return inst
end

---------------------------------幼苗------------------------------------
local baseassets =
{
    Asset("ANIM", "anim/medal_wormwood_flower.zip"),
}
--
local function OnDigUp(inst, worker)
    if inst._growtask ~= nil then
        inst._growtask:Cancel()
        inst._growtask = nil
    end
    -- if inst.components.lootdropper ~= nil then
    --     inst.components.lootdropper:SpawnLootPrefab("greengem")
    -- end
    inst:Remove()
end
--成为守卫
local function BecomeGuard(inst)
    inst.is_grew = true--标记为已长大,防止被重复调用
    inst.Declining = nil
    inst:RemoveTag("origin_pollinationable")
    if inst._growtask ~= nil then
        inst._growtask:Cancel()
        inst._growtask = nil
    end

    local guard = SpawnPrefab("medal_origin_tree_guard")
    guard.Transform:SetPosition(inst.Transform:GetWorldPosition())
    -- moonplant:infest(target)
    guard:playSpawnAnimation()

    if inst.guard_idx ~= nil and TheWorld and TheWorld.medal_origin_tree ~= nil and TheWorld.medal_origin_tree.ChangeGuard ~= nil then
        TheWorld.medal_origin_tree:ChangeGuard(inst)--替换守卫对象
    end
    
    inst:Remove()
end
--生长
local function Growing(inst,value)
    if inst.is_grew then return end
    inst.decay_value = (inst.decay_value or TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_SAPLING_GROW_TIME[TheWorld and TheWorld.medal_origin_tree and TheWorld.medal_origin_tree.phase or 1]) - (value or 1)
    if inst.decay_value <= 0 then
        BecomeGuard(inst)
    end
end

--初始化
-- local function base_oninit(inst)
--     if TheWorld and TheWorld.medal_origin_tree ~= nil and TheWorld.medal_origin_tree.AddGuard ~= nil then
--         TheWorld.medal_origin_tree:AddGuard(inst)--加入本源之树列表
--     end
-- end
--移除
local function base_onremoveentity(inst)
    if inst.guard_idx ~= nil and TheWorld and TheWorld.medal_origin_tree ~= nil and TheWorld.medal_origin_tree.RemoveGuard ~= nil then
        TheWorld.medal_origin_tree:RemoveGuard(inst)--从本源之树列表中移除
    end
end

local function OnSaplingSave(inst, data)
    if inst.guard_idx then
        data.guard_idx = inst.guard_idx
    end
end

local function OnSaplingLoadPostPass(inst, newents, data)
    if data ~= nil and data.guard_idx ~= nil then
        if TheWorld and TheWorld.medal_origin_tree ~= nil and TheWorld.medal_origin_tree.AddGuard ~= nil then
            TheWorld.medal_origin_tree:AddGuard(inst,data.guard_idx)--加入本源之树列表
        end
    end
end

local function basefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("medal_wormwood_flower")
    inst.AnimState:SetBuild("medal_wormwood_flower")
	inst.AnimState:PlayAnimation("medal_buried_greengem")

    inst:AddTag("origin_pollinationable")--可授粉

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	-- inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(OnDigUp)
	inst.components.workable:SetWorkLeft(TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_SAPLING_WORKLEFT)
    inst.components.workable:SetRequiresToughWork(true)--需要高强度工作

    inst.Declining = Growing

    inst._growtask = inst:DoPeriodicTask(1,Growing)

    -- inst:DoTaskInTime(0,base_oninit)

    inst.OnSave = OnSaplingSave
    inst.OnLoadPostPass = OnSaplingLoadPostPass
    inst.OnRemoveEntity = base_onremoveentity

    return inst
end

return Prefab("medal_origin_tree_guard", fn, assets, prefabs),
       Prefab("medal_origin_tree_guard_back", backfn, assets),
       Prefab("medal_origin_tree_guard_vine", vinefn, vineassets ),
       Prefab("medal_origin_tree_guard_vine_end", vineendfn, vineassets ),
       Prefab("medal_origin_tree_guard_sapling", basefn, baseassets )