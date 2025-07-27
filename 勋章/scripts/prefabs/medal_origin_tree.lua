local assets =
{
    Asset("ANIM", "anim/oceantree_pillar_build1.zip"),
    Asset("ANIM", "anim/oceantree_pillar_build2.zip"),
    Asset("ANIM", "anim/oceantree_pillar.zip"),
    Asset("ANIM", "anim/oceantree_pillar_small.zip"),
    Asset("ANIM", "anim/medal_oceantree_pillar_small_build1.zip"),
    Asset("ANIM", "anim/medal_oceantree_pillar_small_build2.zip"),
    Asset("SOUND", "sound/tentacle.fsb"),
    Asset("MINIMAP_IMAGE", "oceantree_pillar"),
    Asset("SCRIPT", "scripts/prefabs/canopyshadows.lua")
}

local prefabs = 
{
    "oceantreenut",
    "oceanvine_cocoon",
}
--小型掉落物列表
local small_ram_products =
{
    "twigs",
    "cutgrass",
    "oceantree_leaf_fx_fall",
    "oceantree_leaf_fx_fall",
}

for _, v in ipairs(small_ram_products) do
    table.insert(prefabs, v)
end

local LEAF_FALL_FX_OFFSET_MIN = 3.5--落叶生成位置偏移
local LEAF_FALL_FX_OFFSET_VARIANCE = 2--落叶生成偏移值方差

local DROP_ITEMS_DIST_MIN = 8--掉落物最小生成距离
local DROP_ITEMS_DIST_VARIANCE = 12--距离方差

local NUM_DROP_SMALL_ITEMS_MIN = 10--小型掉落物数量最小值
local NUM_DROP_SMALL_ITEMS_MAX = 14--小型掉落物数量最大值

local DROPPED_ITEMS_SPAWN_HEIGHT = 10--掉落物生成高度

--判断坐标是否可以生成植物(不能离本源之树太近了)
local function isPosCanSpawnPlant(x,z)
    if TheWorld and TheWorld.medal_origin_tree ~= nil then
        return TheWorld.medal_origin_tree:GetDistanceSqToPoint(x,0,z) > 16
    end
end

--本源之花列表
local FLOWER_LOOT={
    {--1阶段
        {
            randomlist={
                medal_origin_flower1 = 0,--形态1
                medal_origin_flower2 = 25,--形态2
                medal_origin_flower3 = 25,--形态3
                medal_origin_flower4 = 0,--形态4
                medal_origin_flower5 = 50,--形态5
                -- medal_origin_tree_guard_sapling=1,--本源守卫幼苗
            },
            num=10,
            offset=8,
            canoverlap=true,--无视坐标点占用
            posvailfn = isPosCanSpawnPlant,--生成点不能离本源之树太近
        },
    },
    {--2阶段
        {
            randomlist={
                medal_origin_flower1 = 5,--形态1
                medal_origin_flower2 = 30,--形态2
                medal_origin_flower3 = 30,--形态3
                medal_origin_flower4 = 0,--形态4
                medal_origin_flower5 = 35,--形态5
            },
            num=12,
            offset=8,
            canoverlap=true,
            posvailfn = isPosCanSpawnPlant,
        },
    },
    {--3阶段
        {
            randomlist={
                medal_origin_flower1 = 10,--形态1
                medal_origin_flower2 = 30,--形态2
                medal_origin_flower3 = 30,--形态3
                medal_origin_flower4 = 20,--形态4
                medal_origin_flower5 = 10,--形态5
            },
            num=16,
            offset=10,
            canoverlap=true,
            posvailfn = isPosCanSpawnPlant,
        },
    },
    {--4阶段
        {
            randomlist={
                medal_origin_flower1 = 10,--形态1
                medal_origin_flower2 = 30,--形态2
                medal_origin_flower3 = 30,--形态3
                medal_origin_flower4 = 30,--形态4
                medal_origin_flower5 = 0,--形态5
            },
            num=20,
            offset=10,
            canoverlap=true,
            posvailfn = isPosCanSpawnPlant,
        },
    },
}

--生成本源之花
local function SpawnFlowers(inst)
    --在玩家附近集中生成
    for player in pairs(inst.players) do
        if player:IsValid() then
            MedalSpawnCircleItem(player,FLOWER_LOOT[inst.phase])
        end
    end
    if inst.spawn_flower_task ~= nil then
        inst.spawn_flower_task:Cancel()
        inst.spawn_flower_task = nil
    end
    --继续下一轮
    if inst.player_num > 0 then
        local spawn_cycle = TUNING_MEDAL.MEDAL_ORIGIN_FLOWER_SPAWN_CYCLE[inst.phase]
        spawn_cycle = spawn_cycle + math.random(spawn_cycle*-0.1,spawn_cycle*.1)
        inst.spawn_flower_task = inst:DoTaskInTime(spawn_cycle,SpawnFlowers)
    end
end

--根据ID获取守卫的位置,x是圈数,y是排序
local function GetGuardPos(idx)
    local x = 1
    local y = 1
    for i=1,5 do
        y = idx
        idx = idx - (4 + i*2)
        if idx<=0 then
            x = i
            break
        end
    end
    return x,y
end

--改变守卫目标
local function ChangeGuard(inst,old,new)
    if old.guard_idx ~= nil then
        inst.origin_guards[old.guard_idx] = new
        old.guard_idx = nil
    end
end

--添加本源守卫
local function AddGuard(inst,guard,idx)
    if idx ~= nil and inst.origin_guards[idx] == nil then
        inst.origin_guards[idx] = guard
        guard.guard_idx = idx
    end
end

--移除本源守卫
local function RemoveGuard(inst,guard,idx)
    idx = idx or guard.guard_idx
    if idx ~= nil and inst.origin_guards[idx] == guard then
        inst.origin_guards[idx] = nil
    else
        guard.guard_idx = nil
    end
end

--砍伐收益倍率
local function chop_multiplierfn(inst, worker, numworks)
    if inst.is_monster then return 1 end--没魔化不需要降低倍率
    local value = 0
    for k, v in pairs(inst.origin_guards) do
        value = value + (v:HasTag("origin_guard") and .1 or .02)
    end
    return 1 - math.clamp(value, 0, .9)
end

--生成本源守卫幼苗
local function SpawnGuardSapling(inst)
    -- local x,y,z = inst.Transform:GetWorldPosition()
    -- for i = 1, 50 do
    --     local circle_idx, circle_idy = GetGuardPos(i)
    --     -- local angle = ((circle_idy - 1) * 2 + circle_idx%2) * PI / (circle_idx*2 + 4)--根据圈数和序号来计算角度
    --     local angle = (circle_idy - 1) * 2 * PI / (circle_idx*2 + 4)--根据圈数和序号来计算角度
    --     local radius = 4 * (circle_idx + 1)--半径
    --     local sapling = SpawnPrefab("medal_origin_tree_guard_sapling")
    --     sapling.Transform:SetPosition(x + radius*math.cos(angle), 0, z + radius*math.sin(angle))
    -- end

    local x,y,z = inst.Transform:GetWorldPosition()
    for i = 1, 50 do
        if inst.origin_guards[i] == nil then
            local circle_idx, circle_idy = GetGuardPos(i)
            local angle = (circle_idy - 1) * 2 * PI / (circle_idx*2 + 4)--根据圈数和序号来计算角度
            local radius = 4 * (circle_idx + 1)--半径
            local sapling = SpawnPrefab("medal_origin_tree_guard_sapling")
            sapling.Transform:SetPosition(x + radius*math.cos(angle), 0, z + radius*math.sin(angle))
            AddGuard(inst,sapling,i)--记录守卫
            return true
        end
    end
end
--尝试生成本源守卫幼苗
local function TrySpawnGuardSaplings(inst)
    if inst.spawn_guard_sapling_task ~= nil then
        inst.spawn_guard_sapling_task:Cancel()
        inst.spawn_guard_sapling_task = nil
    end
    
    if inst.phase <= 1 then return end--阶段不对说明回退阶段了,直接终止任务

    local num = TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_SAPLING_SPAWN_NUM[inst.phase]
    for i = 1, num do
        if not SpawnGuardSapling(inst) then
            break--没生成成功说明已经满了，没必要继续生成了
        end
    end
    
    --继续下一轮
    if inst.player_num > 0 then
        local spawn_cycle = TUNING_MEDAL.MEDAL_ORIGIN_TREE_GUARD_SAPLING_SPAWN_CYCLE[inst.phase]
        spawn_cycle = spawn_cycle + math.random(spawn_cycle*-0.05,spawn_cycle*.05)
        inst.spawn_guard_sapling_task = inst:DoTaskInTime(spawn_cycle,TrySpawnGuardSaplings)
    end
end

--开始生成本源植物
local function StartSpawnPlant(inst)
    if not inst.is_monster then return end
    --生成本源之花
    if inst.spawn_flower_task == nil and inst.player_num > 0 then
        SpawnFlowers(inst)
    end
    --生成本源守卫幼苗
    if inst.spawn_guard_sapling_task == nil and inst.phase > 1 and inst.player_num > 0 then
        TrySpawnGuardSaplings(inst)
    end
end


--玩家远离
local function OnFar(inst, player)
    inst.player_num = inst.player_num - 1
    player:RemoveTag("under_origin_tree")
    if player.canopytrees then   
        player.canopytrees = player.canopytrees - 1
        player:PushEvent("onchangecanopyzone", player.canopytrees > 0)
    end
    inst.players[player] = nil
end
--玩家靠近
local function OnNear(inst,player)
    inst.player_num = inst.player_num + 1--统计范围内玩家数量
    inst.players[player] = true
    StartSpawnPlant(inst)--开始生成本源植物
    player:AddTag("under_origin_tree")--处于本源之树下

    player.canopytrees = (player.canopytrees or 0) + 1

    player:PushEvent("onchangecanopyzone", player.canopytrees > 0)
end

--掉落单个道具
local function DropItem(inst)
    if inst.items_to_drop and #inst.items_to_drop > 0 then
        local ind = math.random(1, #inst.items_to_drop)
        local item_to_spawn = inst.items_to_drop[ind]

        local x, _, z = inst.Transform:GetWorldPosition()

        local item = SpawnPrefab(item_to_spawn)

        local dist = DROP_ITEMS_DIST_MIN + DROP_ITEMS_DIST_VARIANCE * math.random()
        local theta = math.random() * TWOPI

        local spawn_x, spawn_z

        spawn_x, spawn_z = x + math.cos(theta) * dist, z + math.sin(theta) * dist

        item.Transform:SetPosition(spawn_x, DROPPED_ITEMS_SPAWN_HEIGHT, spawn_z)
        table.remove(inst.items_to_drop, ind)
    end
end

--产生掉落物
local function DropItems(inst)
    DropItem(inst)
    DropItem(inst)

    if #inst.items_to_drop <= 1 then
        inst.items_to_drop = nil
        if inst.drop_items_task then
            inst.drop_items_task:Cancel()
        end
        inst.drop_items_task = nil
        if inst.removeme then
            inst.itemsdone = true  
            if inst.falldone then
                inst:Remove() 
            end                        
        end
    else
        -- inst:DoTaskInTime(0.1, DropItems)
        inst.drop_items_task = inst:DoTaskInTime(0.1, function() DropItems(inst) end)
    end
end
--生成掉落物列表
local function generate_items_to_drop(inst)
    inst.items_to_drop = {}
    local num_small_items = math.random(NUM_DROP_SMALL_ITEMS_MIN, NUM_DROP_SMALL_ITEMS_MAX)
    for i = 1, num_small_items do
        table.insert(inst.items_to_drop, small_ram_products[math.random(1, #small_ram_products)])
    end
end

--计算当前阶段
local function CalcPhase(inst,health)
    health = health or (inst.components.workable and inst.components.workable:GetWorkLeft()) or TUNING_MEDAL.MEDAL_ORIGIN_TREE_HEALTH
    return math.clamp(5 - math.ceil(health/3000), 1, 4)
end
--尝试换阶段
local function TryChangePhase(inst,new_phase)
    local old_phase = inst.phase or CalcPhase(inst)
    if new_phase == old_phase then return end
    inst.phase = new_phase
    --阶段上升
    if new_phase > old_phase then
        SpawnFlowers(inst)--立即生成一波本源之花
        TrySpawnGuardSaplings(inst)--立即生成本源守卫幼苗
    end
end

---------------------------------------------------------------------------------------------------
--砍树
local function chop_tree(inst, chopper, chopsleft, numchops)
    --声音表现
    if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound(
            chopper ~= nil and chopper:HasTag("beaver") and
            "dontstarve/characters/woodie/beaver_chop_tree" or
            chopper ~= nil and chopper:HasTag("boat") and
            "dontstarve/characters/woodie/beaver_chop_tree" or
            "dontstarve/wilson/use_axe_tree"
        )
    end
    if not inst.is_monster then
        --非魔化状态快砍倒时播放断裂的声音
        if inst.components.workable.workleft / inst.components.workable.maxwork == 0.2 then 
            inst.SoundEmitter:PlaySound("waterlogged2/common/watertree_pillar/cracking")
        elseif inst.components.workable.workleft / inst.components.workable.maxwork == 0.12 then 
            inst.SoundEmitter:PlaySound("waterlogged2/common/watertree_pillar/cracking")
        end
    end
    --动画表现
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle")
    ShakeAllCameras(CAMERASHAKE.FULL, 0.25, 0.03, 0.2, inst, 6)--摇晃镜头
    --每次砍伐概率掉落叶
    if math.random() < 0.58 then
        local theta = math.random() * TWOPI
        local offset = LEAF_FALL_FX_OFFSET_MIN + math.random() * LEAF_FALL_FX_OFFSET_VARIANCE
        local x, _, z = inst.Transform:GetWorldPosition()
        SpawnPrefab("oceantree_leaf_fx_fall").Transform:SetPosition(x + math.cos(theta) * offset, 10, z + math.sin(theta) * offset)
    end
    
    --魔化状态
    if inst.is_monster and chopper ~= nil and chopsleft > 0 then
		--阶段变化
        TryChangePhase(inst,CalcPhase(inst, chopsleft))
        --生成根鞭
        local x,y,z = chopper.Transform:GetWorldPosition()
		local root = SpawnPrefab("medal_origin_tree_root")
		if root then
			root.target = chopper
            root.Transform:SetPosition(x,y,z)
		end
        -- local root = SpawnPrefab("medal_origin_tree_root")
        -- if root ~= nil then
        --     local targdist = TUNING.DECID_MONSTER_TARGET_DIST
        --     local x, y, z = inst.Transform:GetWorldPosition()
        --     local mx, my, mz = chopper.Transform:GetWorldPosition()
        --     local mdistsq = distsq(x, z, mx, mz)
        --     local targdistsq = targdist * targdist
        --     local rootpos = Vector3(mx, 0, mz)
        --     local angle = inst:GetAngleToPoint(rootpos) * DEGREES
        --     if mdistsq > targdistsq then
        --         rootpos.x = x + math.cos(angle) * targdist
        --         rootpos.z = z - math.sin(angle) * targdist
        --     end

        --     root.Transform:SetPosition(x + 1.75 * math.cos(angle), 0, z - 1.75 * math.sin(angle))
        --     root:PushEvent("givetarget", { target = chopper, targetpos = rootpos, targetangle = angle, owner = inst })
        -- end
	end
    --同步血量显示
    if chopsleft ~= nil and inst.components.health then
        inst.components.health:SetVal(chopsleft, nil, chopper)
    end
end

-- local function spawnwaves(inst, numWaves, totalAngle, waveSpeed, wavePrefab, initialOffset, idleTime, instantActivate, random_angle)
--     SpawnAttackWaves(
--         inst:GetPosition(),
--         (not random_angle and inst.Transform:GetRotation()) or nil,
--         initialOffset or (inst.Physics and inst.Physics:GetRadius()) or nil,
--         numWaves,
--         totalAngle,
--         waveSpeed,
--         wavePrefab,
--         idleTime,
--         instantActivate
--     )
-- end
--生成落叶实体
local function Dropleafitems(inst)
    local x, _, z = inst.Transform:GetWorldPosition()
    local item = SpawnPrefab("medal_origin_tree_leaves")
    local dist = DROP_ITEMS_DIST_MIN + DROP_ITEMS_DIST_VARIANCE * math.random()
    local theta = math.random() * TWOPI
    local spawn_x, spawn_z
    spawn_x, spawn_z = x + math.cos(theta) * dist, z + math.sin(theta) * dist
    item.Transform:SetPosition(spawn_x, 0, spawn_z)
end
--落叶
local function Dropleaves(inst)
    if not inst.leafcounter then
        inst.leafcounter = 0
    end
    Dropleafitems(inst)
    Dropleafitems(inst)
    Dropleafitems(inst)
    inst.leafcounter = inst.leafcounter + 0.05

    if inst.leafcounter > 1 then
        inst.dropleaftask:Cancel()
        inst.dropleaftask = nil
    end
end
--掉落树冠
local function dropcanopy(inst, dropleaves)    
    DropItems(inst)--生成掉落物
    if dropleaves then 
        inst.dropleaftask = inst:DoPeriodicTask(0.05, function() Dropleaves(inst)  end)--生成落叶
    end
end
--掉落树冠及掉落物
local function dropcanopystuff(inst,num, dropleaves)
    if not inst.items_to_drop or num > #inst.items_to_drop then
        inst.items_to_drop = {}
        generate_items_to_drop(inst, num)
    end
    dropcanopy(inst,dropleaves)
end
--成功砍倒
local function chop_down_tree(inst, chopper)
    -- inst:OnRemoveEntity()
    --移除阴影
    if inst.components.canopyshadows ~= nil then
        inst:RemoveComponent("canopyshadows")
    end
    --声音
    inst.SoundEmitter:PlaySound("waterlogged2/common/watertree_pillar/fall")
    --动画结束后移除
    inst:ListenForEvent("animover", function() 
        inst.falldone = true  
        if inst.itemsdone then
            inst:Remove() 
        end
    end)
    --切换动画
    inst.AnimState:SetBank("oceantree_pillar_small")
    inst.AnimState:SetBuild("oceantree_pillar_small_build1")
    inst.AnimState:AddOverrideBuild("oceantree_pillar_small_build2")
    inst.AnimState:PlayAnimation("fall")

    -- inst:DoTaskInTime(7*FRAMES,function() inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/medium")  end)
    -- inst:DoTaskInTime(28*FRAMES,function() 
    --     inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/large")  
    --     spawnwaves(inst, 6, 360, 4, nil, 2, 2, nil, true)
    -- end)
    -- inst:DoTaskInTime(38*FRAMES,function() inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/medium")  end)
    -- inst:DoTaskInTime(51*FRAMES,function() inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/medium")  end)
    -- inst:DoTaskInTime(56*FRAMES,function() inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/medium")  end)
    -- inst:DoTaskInTime(60*FRAMES,function() inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/medium")  end)
    -- inst:DoTaskInTime(63*FRAMES,function() inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/medium")  end)
    -- inst:DoTaskInTime(68*FRAMES,function() inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/medium")  end)
    -- inst:DoTaskInTime(75*FRAMES,function() inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/medium")  end)
    -- inst:DoTaskInTime(94*FRAMES,function() 
    --     inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/large")
    --     spawnwaves(inst, 6, 360, 4, nil, 2, 2, nil, true)
    -- end)

    -- local pt = inst:GetPosition()
    -- inst.components.lootdropper:DropLoot(pt)
    inst.removeme = true
    inst.persists = false
    dropcanopystuff(inst, math.random(NUM_DROP_SMALL_ITEMS_MIN,NUM_DROP_SMALL_ITEMS_MAX), true )--树冠掉落,生成掉落物
    -- inst.logs = 15
    -- DropLogs(inst)

    inst:DoTaskInTime(.5, function() ShakeAllCameras(CAMERASHAKE.FULL, 0.25, 0.03, 0.6, inst, 6) end)

    --统计死亡次数
    if inst.is_monster and TheWorld and TheWorld.components.medal_infosave then
        TheWorld.components.medal_infosave:CountChaosCreatureDeathTimes(inst)
    end
end
---------------------------------------------------------------------------------------------------
--成长动画
local function OnSprout(inst)
    inst.AnimState:SetBank("oceantree_pillar_small")
    inst.AnimState:SetBuild("oceantree_pillar_small_build1")
    inst.AnimState:SetScale(1.5, 1.5)
    -- inst.AnimState:AddOverrideBuild("oceantree_pillar_small_build2")
    inst.AnimState:PlayAnimation("grow_tall_to_pillar")
    
    -- inst.AnimState:PushAnimation("idle", true)
end
--掉落雷劈掉落物
local function DropLightningItems(inst, items)
    local x, _, z = inst.Transform:GetWorldPosition()
    local num_items = #items

    for i, item_prefab in ipairs(items) do
        local dist = DROP_ITEMS_DIST_MIN + DROP_ITEMS_DIST_VARIANCE * math.random()
        local theta = TWOPI * math.random()

        inst:DoTaskInTime(i * 5 * FRAMES, function(inst2)
            local item = SpawnPrefab(item_prefab)
            item.Transform:SetPosition(x + dist * math.cos(theta), 20, z + dist * math.sin(theta))

            if i == num_items then
                inst._lightning_drop_task:Cancel()
                inst._lightning_drop_task = nil
            end 
        end)
    end
end
--遭雷劈
local function OnLightningStrike(inst)
    if inst._lightning_drop_task ~= nil then
        return
    end

    local num_small_items = math.random(NUM_DROP_SMALL_ITEMS_MIN, NUM_DROP_SMALL_ITEMS_MAX)
    local items_to_drop = {}

    for i = 1, num_small_items do
        table.insert(items_to_drop, small_ram_products[math.random(1, #small_ram_products)])
    end

    inst._lightning_drop_task = inst:DoTaskInTime(20*FRAMES, DropLightningItems, items_to_drop)
end

--魔化
local function BecomeMonster(inst,health)
    inst.is_monster = true
    inst.components.workable:SetMaxWork(TUNING_MEDAL.MEDAL_ORIGIN_TREE_HEALTH)
    inst.components.workable:SetWorkLeft(health or TUNING_MEDAL.MEDAL_ORIGIN_TREE_HEALTH)
    inst.components.workable:SetRequiresToughWork(true)--需要高强度工作
    inst.components.health:SetMaxHealth(TUNING_MEDAL.MEDAL_ORIGIN_TREE_HEALTH)
    if health ~= nil then
        inst.components.health:SetCurrentHealth(health)
    end
    inst.phase = CalcPhase(inst)--计算当前所处阶段
    --登记魔化本源之树，方便被回血，世界上只能有一棵魔化本源之树
    if TheWorld and TheWorld.medal_origin_tree == nil then
        TheWorld.medal_origin_tree = inst
    end
    StartSpawnPlant(inst)--开始生成本源植物
    --切换贴图
end

--回血
local function DoRecovery(inst,value)
	if inst.components.workable == nil or not inst.is_monster then return end--非魔化状态不能回血
    local health = math.min(inst.components.workable:GetWorkLeft() + (value or 5), TUNING_MEDAL.MEDAL_ORIGIN_TREE_HEALTH)
    inst.components.workable:SetWorkLeft(health)
    if inst.components.health ~= nil then
        inst.components.health:SetCurrentHealth(health)
    end
    TryChangePhase(inst,CalcPhase(inst,health))--阶段变化
end

local function OnSave(inst, data)
    data.is_monster = inst.is_monster--魔化状态
    if inst.components.workable ~= nil then
        data.current_health = inst.components.workable:GetWorkLeft()--剩余血量(伐木次数)
    end
end

local function OnLoad(inst, data)
    if data then
        if data.is_monster then
            inst.is_monster = true
            BecomeMonster(inst,data.current_health)
        end
    end
end

local function OnRemoveEntity(inst)
    -- if inst.roots then
    --     inst.roots:Remove()
    -- end

    -- if inst._ripples then
    --     inst._ripples:Remove()
    -- end

    for player in pairs(inst.players) do
        if player:IsValid() then
            if player.canopytrees then
                player.canopytrees = player.canopytrees - 1
                player:PushEvent("onchangecanopyzone", player.canopytrees > 0)
            end
        end
    end
    --取消本源之树登记
    if inst.is_monster and TheWorld and TheWorld.medal_origin_tree == inst  then
        TheWorld.medal_origin_tree = nil
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeWaterObstaclePhysics(inst, 4, 2, 0.75)

    inst:SetDeployExtraSpacing(4)

    -- HACK: this should really be in the c side checking the maximum size of the anim or the _current_ size of the anim instead
    -- of frame 0
    inst.entity:SetAABB(60, 20)

    -- inst:AddTag("cocoon_home")
    inst:AddTag("shadecanopy")
    inst:AddTag("ignorewalkableplatforms")
    inst:AddTag("cantdestroy")--不可破坏

    inst.MiniMapEntity:SetIcon("oceantree_pillar.png")

    inst.AnimState:SetBank("oceantree_pillar")
    inst.AnimState:SetBuild("oceantree_pillar_build1")
    inst.AnimState:PlayAnimation("idle", true)

    inst.AnimState:AddOverrideBuild("oceantree_pillar_build2")

    if not TheNet:IsDedicated() then
        inst:AddComponent("distancefade")
        inst.components.distancefade:Setup(15,25)

        inst:AddComponent("canopyshadows")--树冠阴影
        inst.components.canopyshadows.range = math.floor(TUNING_MEDAL.MEDAL_ORIGIN_TREE_SHADE_CANOPY_RANGE/4)
    end

    -- inst.scrapbook_specialinfo = "WATERTREEPILLAR"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.sproutfn = OnSprout--成长动画
    inst:ListenForEvent("animover", function()--播完成长动画切回当前贴图
		if inst.AnimState:IsCurrentAnimation("grow_tall_to_pillar") then
			inst.AnimState:SetBank("oceantree_pillar")
            inst.AnimState:SetBuild("oceantree_pillar_build1")
            inst.AnimState:SetScale(1, 1)
            inst.AnimState:PlayAnimation("idle", true)
		end
	end)

    -- inst.scrapbook_adddeps = { "oceanvine" }

    inst.phase = 1--当前阶段
    inst.items_to_drop = nil
    inst.drop_items_task = nil
    inst.origin_guards = {}--本源守卫

    -------------------
    --光照
    inst:AddComponent("canopylightrays")
    inst.components.canopylightrays.range = math.floor(TUNING_MEDAL.MEDAL_ORIGIN_TREE_SHADE_CANOPY_RANGE/4)

    -------------------
    --血量上限(仅显示用)
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING_MEDAL.MEDAL_ORIGIN_TREE_WORKLEFT)
    inst.components.health.invincible = true
    inst.components.health.nofadeout = true
    
    -------------------

    --玩家靠近
    inst.players = {}
    inst.player_num = 0
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetTargetMode(inst.components.playerprox.TargetModes.AllPlayers)
    inst.components.playerprox:SetDist(TUNING_MEDAL.MEDAL_ORIGIN_TREE_SHADE_CANOPY_RANGE, TUNING_MEDAL.MEDAL_ORIGIN_TREE_SHADE_CANOPY_RANGE + 1)
    inst.components.playerprox:SetOnPlayerFar(OnFar)
    inst.components.playerprox:SetOnPlayerNear(OnNear)

    -------------------

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetMaxWork(TUNING_MEDAL.MEDAL_ORIGIN_TREE_WORKLEFT)
    inst.components.workable:SetWorkLeft(TUNING_MEDAL.MEDAL_ORIGIN_TREE_WORKLEFT)
    inst.components.workable:SetOnWorkCallback(chop_tree)
    inst.components.workable:SetOnFinishCallback(chop_down_tree)
    inst.components.workable:SetWorkMultiplierFn(chop_multiplierfn)
    inst.components.workable.medal_work_limit = TUNING_MEDAL.MEDAL_ORIGIN_TREE_WORK_LIMIT--单次工作上限,防秒杀

    --------------------
    inst:AddComponent("inspectable")

    --------------------
    inst:AddComponent("timer")

    --------------------
    inst:AddComponent("lightningblocker")--闪电防护
    inst.components.lightningblocker:SetBlockRange(TUNING_MEDAL.MEDAL_ORIGIN_TREE_SHADE_CANOPY_RANGE)
    inst.components.lightningblocker:SetOnLightningStrike(OnLightningStrike)

    --涟漪
    -- inst._ripples = SpawnPrefab("watertree_pillar_ripples")
    -- inst._ripples.entity:SetParent(inst.entity)
    --树根的阴影
    -- inst.roots = SpawnPrefab("watertree_pillar_roots")
    -- inst.roots.entity:SetParent(inst.entity)

    inst.BecomeMonster = BecomeMonster--变成怪物
	inst.DoRecovery = DoRecovery--回血
    inst.AddGuard = AddGuard--添加守卫
    inst.RemoveGuard = RemoveGuard--移除守卫
    inst.ChangeGuard = ChangeGuard--替换守卫
    inst.SpawnGuardSapling = SpawnGuardSapling

    inst.OnSave = OnSave
    -- inst.OnPreLoad = OnPreLoad
    inst.OnLoad = OnLoad
    inst.OnRemoveEntity = OnRemoveEntity

    return inst
end
--落叶
local function leaves_fn(data)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.AnimState:SetBank("oceantree_pillar_small")
    inst.AnimState:SetBuild("medal_oceantree_pillar_small_build1")
    inst.AnimState:PlayAnimation("leaf_fall_ground", false)
    inst.AnimState:AddOverrideBuild("medal_oceantree_pillar_small_build2")
    
    inst:ListenForEvent("animover", function() inst:Remove() end)

    inst:DoTaskInTime(0, function()  
            local point = Vector3(inst.Transform:GetWorldPosition())
            if not TheWorld.Map:IsVisualGroundAtPoint(point.x,point.y,point.z) then
                inst.AnimState:PlayAnimation("leaf_fall_water", false)     
                -- inst:DoTaskInTime(11*FRAMES, function() 
                --     inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/medium")
                -- end)
            end

        end)
    
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

-- local function ripples_fn()
--     local inst = CreateEntity()

--     inst.entity:AddTransform()
--     inst.entity:AddAnimState()
--     inst.entity:AddNetwork()

--     inst:AddTag("FX")
--     inst:AddTag("NOCLICK")

--     inst.AnimState:SetBank("oceantree_pillar")
--     inst.AnimState:SetBuild("oceantree_pillar_build1")
--     inst.AnimState:PlayAnimation("root_ripple", true)

--     inst.AnimState:AddOverrideBuild("oceantree_pillar_build2")

--     inst.AnimState:SetOceanBlendParams(TUNING.OCEAN_SHADER.EFFECT_TINT_AMOUNT)

--     inst.entity:SetPristine()
--     if not TheWorld.ismastersim then
--         return inst
--     end

--     inst.persists = false

--     return inst
-- end

-- local function roots_fn(data)
--     local inst = CreateEntity()

--     inst.entity:AddTransform()
--     inst.entity:AddAnimState()
--     inst.entity:AddNetwork()

--     inst:AddTag("FX")
--     inst:AddTag("NOCLICK")

--     inst.AnimState:SetBank("oceantree_pillar")
--     inst.AnimState:SetBuild("oceantree_pillar_build1")
--     inst.AnimState:PlayAnimation("root_shadow", false)

--     inst.AnimState:AddOverrideBuild("oceantree_pillar_build2")
    
--     inst.AnimState:SetSortOrder(ANIM_SORT_ORDER_BELOW_GROUND.UNDERWATER)
--     inst.AnimState:SetLayer(LAYER_WIP_BELOW_OCEAN)

--     inst.entity:SetPristine()
--     if not TheWorld.ismastersim then
--         return inst
--     end

--     inst.persists = false

--     return inst
-- end

return Prefab("medal_origin_tree", fn, assets, prefabs),
    Prefab("medal_origin_tree_leaves", leaves_fn, assets)

-- return Prefab("watertree_pillar", fn, assets, prefabs),
--     Prefab("watertree_pillar_ripples", ripples_fn, assets),
--     Prefab("watertree_pillar_roots", roots_fn, assets)
