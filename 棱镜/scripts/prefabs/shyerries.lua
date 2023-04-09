local SpawnRadius = 2.5 --生成与检测的间隔距离

local function Disappear(inst, delay)
    RemovePhysicsColliders(inst)
    if delay then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("wither", false)
    else
        inst.AnimState:PlayAnimation("wither", false)
    end
    inst:ListenForEvent("animover", function(inst)
        if inst.AnimState:AnimDone() then
            inst:Remove()
        end
    end)
end

local function IsValidTile(x, z)
    -- local tile = TheWorld.Map:GetTileAtPoint(x, 0, z)
    -- return tile ~= nil and tile ~= GROUND.IMPASSABLE
    return TheWorld.Map:IsAboveGroundAtPoint(x, 0, z)
end

local function CanSpawnHere(x, z, pre, pst) --0代表可以生成，1代表不能生成但可以判断生成下一棵，-1代表被完全挡住
    --检测地皮，可能会被完全挡住
    local tile = TheWorld.Map:GetTileAtPoint(x, 0, z)
    if tile == nil or 
        (tile == GROUND.IMPASSABLE or tile == GROUND.ROAD or tile == GROUND.WOODFLOOR or tile == GROUND.SCALE or
         tile == GROUND.CARPET or tile == GROUND.CHECKER or tile == GROUND.ROCKY) or
        not TheWorld.Map:IsAboveGroundAtPoint(x, 0, z)
    then
        return -1
    end

    --检测周围的实体
    local ents = TheSim:FindEntities(x, 0, z, SpawnRadius + 1, nil, {"NOBLOCK", "FX", "palyer", "INLIMBO", "DECOR"}, nil)
    for i, v in ipairs(ents) do
        if v ~= pre and v ~= pst and v.entity:IsVisible() then
            if v:GetDistanceSqToPoint(x, 0, z) <= 1 or (v:HasTag("blocker") and v:GetPhysicsRadius(0) > 0.7) then
                return 1
            end
        end
    end

    return 0
end

--------------------------------------------------------------------------
--[[ 野生的颤栗树与颤栗花的生长管理器 ]]
--------------------------------------------------------------------------

local prefabs_manager = 
{
    "shyerrytree1",
    "shyerrytree2",
    "shyerrytree3",
    "shyerrytree4",
    "shyerryflower",
}

local Lines = 6         --生成线路总数
local LineMembers = 12  --线路成员总数

local function InitSpawnPostions(inst)
    local x1, y1, z1 = inst.Transform:GetWorldPosition()
    inst.positions = {}

    local twopi = 2 * PI
    local offsettheta = twopi / 4 --90度
    local startangle = math.random() * twopi

    for i = 1, Lines do
        inst.positions[i] = {}

        local theta = startangle + twopi / Lines * i + twopi / 12 * (math.random() - 0.5) --在-15到15之间随机偏移
        if theta > twopi then
            theta = theta - twopi
        end

        --首先，确定出发点
        local pos = {x = x1 + SpawnRadius * math.cos(theta), z = z1 - SpawnRadius * math.sin(theta), prefab = nil}
        if IsValidTile(pos.x, pos.z) then --这里只进行是否在大陆内地皮的判断，更深层次的判断在生成时进行
            inst.positions[i][1] = pos

            --然后，确定衍生点集
            for j = 2, LineMembers do
                local lastpos = inst.positions[i][j - 1]
                theta = theta + offsettheta * (math.random() - 0.5) --在-45到45之间随机偏移

                local posi = {x = lastpos.x + SpawnRadius * math.cos(theta), z = lastpos.z - SpawnRadius * math.sin(theta), prefab = nil}
                if IsValidTile(posi.x, posi.z) then --这里只进行是否在大陆内地皮的判断，更深层次的判断在生成时进行
                    inst.positions[i][j] = posi
                else
                    break --一旦一个点不能进行生长，就放弃接下来的点
                end
            end
        else
            inst.positions[i] = nil
        end
    end
end

local function OnIsDusk(inst, isdusk)
    if isdusk and inst.positions ~= nil then
        local count = math.random(5, 10)
        local offset = math.random(1, Lines) --偏移量，用来避免每次都从线路1开始修复

        for i = 1, Lines do
            local index = (offset + i) % Lines + 1
            if inst.positions[index] == nil then break end 

            for j = 1, LineMembers do 
                local spot = 1

                if inst.positions[index][j] == nil then
                    spot = -1
                elseif inst.positions[index][j].prefab == nil or not inst.positions[index][j].prefab:IsValid() then
                    local pre = j - 1 >= 1 and inst.positions[index][j - 1] or nil
                    local pst = j + 1 <= LineMembers and inst.positions[index][j + 1] or nil
                    pre = pre ~= nil and pre.prefab or nil
                    pst = pst ~= nil and pst.prefab or nil

                    spot = CanSpawnHere(inst.positions[index][j].x, inst.positions[index][j].z, pre, pst)
                end

                if spot == 0 then
                    local namebig = {"shyerrytree1", "shyerrytree3"}
                    local namesmall = {"shyerrytree2", "shyerrytree4"}
                    local name = namebig
                    if math.random() < 0.02 then --极低几率产生花
                        name = {"shyerryflower"}
                    elseif j == 1 then
                        name = namebig
                    elseif j < LineMembers / 3 then
                        if math.random() < 0.1 then name = namesmall end
                    elseif j < LineMembers / 3 * 2 then
                        if math.random() < 0.3 then name = namesmall end
                    else
                        if math.random() < 0.8 then name = namesmall end
                    end

                    local tree = SpawnPrefab(name[math.random(#name)])
                    tree.Transform:SetPosition(inst.positions[index][j].x, 0, inst.positions[index][j].z)
                    inst.positions[index][j].prefab = tree

                    count = count - 1
                    if count <= 0 then return end --每次只修复固定数量的树

                    if math.random() < 0.6 then break end --防止一条路上就修复完了
                elseif spot == -1 then
                    break --一旦被完全挡住，退出循环，开始下一个线路
                end
            end
        end
    end
end

local function OnSeasonChange(inst, season)
    InitSpawnPostions(inst) 
end

local function fn_manager()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.positions = nil

    inst:DoTaskInTime(1, function() InitSpawnPostions(inst) end)

    inst:WatchWorldState("isdusk", OnIsDusk)
    inst:WatchWorldState("season", OnSeasonChange)

    return inst
end

--------------------------------------------------------------------------
--[[ 颤栗树 ]]
--------------------------------------------------------------------------

SetSharedLootTable('shyerrytree_large',
{
    {'shyerrylog', 0.5},
    {'log', 1},
})

SetSharedLootTable('shyerrytree_medium',
{
    {'shyerrylog', 0.1},
    {'log', 0.5},
})

local function Burnt_tree(inst)
    Disappear(inst)
    inst.components.lootdropper:SpawnLootPrefab("charcoal")
end

local function Chop_tree(inst, chopper, chopsleft, numchops)
    if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound(
            chopper ~= nil and chopper:HasTag("beaver") and
            "dontstarve/characters/woodie/beaver_chop_tree" or
            "dontstarve/wilson/use_axe_tree"
        )
    end

    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", true)
end

local function ChopDown_tree(inst, chopper)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
    if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound(
            chopper ~= nil and chopper:HasTag("beaver") and
            "dontstarve/characters/woodie/beaver_chop_tree" or
            "dontstarve/wilson/use_axe_tree"
        )
    end

    Disappear(inst)
    inst.components.lootdropper:DropLoot()
end

local function OnIsDusk_tree(inst, isdusk)
    local x1, y1, z1 = inst.Transform:GetWorldPosition()
    local radius = SpawnRadius * (math.random() * 3 + 1)  --2.5~10
    local angle = math.random() * 2 * PI

    x1 = x1 + radius * math.cos(angle)
    z1 = z1 - radius * math.sin(angle)

    if CanSpawnHere(x1, z1, inst, nil) ~= 0 then
        return
    end

    local name = {"shyerrytree2", "shyerrytree4"}
    if math.random() < 0.05 then --极低几率产生花
        name = {"shyerryflower"}
    end

    local tree = SpawnPrefab(name[math.random(#name)])
    tree.Transform:SetPosition(x1, 0, z1)
end

local function Inspect_tree(inst)
    return (inst.components.burnable ~= nil and inst.components.burnable:IsBurning() and "BURNING") or nil
end

local function createtree(name, buildname, iswild, workleft, physicsize, scalesize, loot)
    local assets_tree =
    {
        Asset("ANIM", "anim/"..buildname..".zip"),
        Asset("ANIM", "anim/shyerrybush.zip"),
    }

    local prefabs_tree = 
    {
        "shyerrylog",
        "log",
        "charcoal",
    }

    if not iswild then
        table.insert(prefabs_tree, "shyerrytree2")
        table.insert(prefabs_tree, "shyerrytree4")
        table.insert(prefabs_tree, "shyerryflower")
    end

    local function fn_tree()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()

        MakeObstaclePhysics(inst, physicsize)

        inst.MiniMapEntity:SetIcon("shyerrytree.tex")
        inst.MiniMapEntity:SetPriority(-1)

        inst.AnimState:SetBank("bramble_core")
        inst.AnimState:SetBuild(buildname)
        -- inst.AnimState:PlayAnimation("idle", true)

        if scalesize ~= nil then
            inst.Transform:SetScale(scalesize, scalesize, scalesize)
        end

        inst:AddTag("shyerry")
        inst:AddTag("plant") --植物标签，和植物人相关的
        -- inst:AddTag("tree") --不能有这个标签，会让农场书报错
        inst:AddTag("boulder") --使巨鹿、熊獾的移动能撞烂自己

        inst:SetPrefabNameOverride(iswild and "shyerrytree" or "shyerrytree_planted")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:DoTaskInTime(0, function()
            inst.AnimState:PlayAnimation("grow")
            inst.AnimState:PushAnimation("idle", true)
        end)

        local color = 0.5 + math.random() * 0.5
        inst.AnimState:SetMultColour(color, color, color, 1)
        inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())

        inst:AddComponent("inspectable")
        inst.components.inspectable.getstatus = Inspect_tree

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetChanceLootTable(loot)

        MakeLargeBurnable(inst, TUNING.TREE_BURN_TIME)
        inst.components.burnable:SetFXLevel(5)
        inst.components.burnable:SetOnBurntFn(Burnt_tree)
        MakeMediumPropagator(inst)

        inst:AddComponent("workable")
        if not iswild then
            if TheWorld:HasTag("cave") then
                inst:WatchWorldState("iscavedusk", OnIsDusk_tree)
            else
                inst:WatchWorldState("isdusk", OnIsDusk_tree)
            end

            inst.components.workable:SetWorkAction(ACTIONS.DIG) --栽种的可挖掘，这样可以防止栽种的被老麦影子砍掉
            inst.components.workable:SetWorkLeft(workleft)
            inst.components.workable:SetOnFinishCallback(function(inst, worker)
                inst.components.lootdropper:DropLoot()
                Disappear(inst, true)
            end)
        else
            inst.components.workable:SetWorkAction(ACTIONS.CHOP) --野生的可砍伐
            inst.components.workable:SetOnWorkCallback(Chop_tree)
            inst.components.workable:SetOnFinishCallback(ChopDown_tree)
            inst.components.workable:SetWorkLeft(workleft)
        end

        MakeHauntableIgnite(inst)

        return inst
    end

    return Prefab(name, fn_tree, assets_tree, prefabs_tree)
end

--------------------------------------------------------------------------
--[[ 颤栗花 ]]
--------------------------------------------------------------------------

local assets_flower =
{
    Asset("ANIM", "anim/shyerrybush.zip"),
    -- Asset("ANIM", "anim/bramble_core.zip"), --荆棘花的动画模板
}

local prefabs_flower = 
{
    "shyerry",
    "shyerry_cooked",
}

local function OnHaunt_flower(inst)
    if math.random() <= TUNING.HAUNT_CHANCE_ALWAYS then
        if math.random() <= 0.33 then
            if inst.components.pickable ~= nil then --已经要掉落果实了，不再能采集
                inst.components.pickable.caninteractwith = false
            end
            if inst.components.pickable.product ~= nil then
                inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
            end
            Disappear(inst, true)
        else
            inst.AnimState:PlayAnimation("hit")
            inst.AnimState:PushAnimation("idle", true)
        end
        
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_COOLDOWN_TINY
        return true
    end
    return false
end

local function EndShy(inst)
    if inst.shytask ~= nil then
        inst.shytask:Cancel()
        inst.shytask = nil
    end
end

local function StartShy(inst)
    if inst.shytask == nil then
        inst.shytask = inst:DoPeriodicTask(1.5, function()
            --"shadowminion"暗影随从，"plantkin"植物人，"swampwhisperer"沼泽低语者，不会吓到颤栗花
            if FindEntity(inst, 10, nil, nil, {"NOCLICK", "FX", "INLIMBO", "DECOR", "shadowminion", "plantkin", "swampwhisperer"}, {"scarytoprey"}) ~= nil then
                if inst.components.pickable ~= nil then
                    inst.components.pickable.caninteractwith = false
                end
                -- inst.components.pickable.canbepicked = false
                EndShy(inst)
                Disappear(inst)
            end
        end)
    end
end

local function OnPickedFn_flower(inst, picker) --被采集时
    EndShy(inst)
    Disappear(inst, true)
end

local function Burnt_flower(inst)
    if inst.components.pickable ~= nil then
        inst.components.pickable.caninteractwith = false
    end
    -- inst.components.pickable.canbepicked = false
    inst.components.lootdropper:SpawnLootPrefab("shyerry_cooked")
    EndShy(inst)
    Disappear(inst)
end

local function fn_flower()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeSmallObstaclePhysics(inst, .1)

    inst.AnimState:SetBank("bramble_core")
    inst.AnimState:SetBuild("shyerrybush")
    -- inst.AnimState:PlayAnimation("idle", true)

    inst.Transform:SetScale(0.6, 0.6, 0.6)  --设置相对大小

    inst:AddTag("shyerry")
    inst:AddTag("plant")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.shytask = nil
    inst:DoTaskInTime(0, function()
        inst.AnimState:PlayAnimation("grow")
        inst.AnimState:PushAnimation("idle", true)
    end)

    inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"
    inst.components.pickable:SetUp("shyerry", 10)
    inst.components.pickable.onpickedfn = OnPickedFn_flower

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = Inspect_tree

    inst:AddComponent("lootdropper")

    MakeHauntableIgnite(inst)
    AddHauntableCustomReaction(inst, OnHaunt_flower, false, false, true)

    MakeMediumBurnable(inst)
    inst.components.burnable:SetFXLevel(5)
    inst.components.burnable:SetOnBurntFn(Burnt_flower)
    MakeLargePropagator(inst)

    inst.OnEntitySleep = EndShy
    inst.OnEntityWake = StartShy

    return inst
end

--------------------------------------------------------------------------
--[[ 宽大的木墩 ]]
--------------------------------------------------------------------------

local assets_log =
{
    Asset("ANIM", "anim/shyerrylog.zip"),
    Asset("ATLAS", "images/inventoryimages/shyerrylog.xml"),
    Asset("IMAGE", "images/inventoryimages/shyerrylog.tex"),
}

local function fn_log()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("shyerrylog")
    inst.AnimState:SetBuild("shyerrylog")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "med", 0.2, 0.8)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "shyerrylog"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/shyerrylog.xml"

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.WOOD
    -- inst.components.edible.woodiness = 25
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 0

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    inst:AddComponent("repairer")
    inst.components.repairer.repairmaterial = MATERIALS.WOOD
    inst.components.repairer.healthrepairvalue = TUNING.REPAIR_BOARDS_HEALTH

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    MakeSmallBurnable(inst, TUNING.LARGE_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunchAndIgnite(inst)

    return inst
end

return Prefab("shyerrymanager", fn_manager, nil, prefabs_manager),
        createtree("shyerrytree1", "shyerrytree1", true, 10, 1, nil, 'shyerrytree_large'),
        createtree("shyerrytree2", "shyerrytree2", true, 6, 0.8, 0.8, 'shyerrytree_medium'),
        createtree("shyerrytree3", "shyerrytree3", true, 10, 1, nil, 'shyerrytree_large'),
        createtree("shyerrytree4", "shyerrytree4", true, 6, 0.45, 0.8, 'shyerrytree_medium'),
        Prefab("shyerryflower", fn_flower, assets_flower, prefabs_flower),
        Prefab("shyerrylog", fn_log, assets_log),
        createtree("shyerrytree1_planted", "shyerrytree1", false, 1, 1, nil, 'shyerrytree_large'),
        createtree("shyerrytree3_planted", "shyerrytree3", false, 1, 1, nil, 'shyerrytree_large')