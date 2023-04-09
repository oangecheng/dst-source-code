local prefs = {}

--------------------------------------------------------------------------
--[[ 通用 ]]
--------------------------------------------------------------------------

local function setberries(inst, pct)    --设置果实的贴图
    if inst._setberriesonanimover then
        inst._setberriesonanimover = nil
        inst:RemoveEventCallback("animover", setberries)
    end

    local berries =
        (pct == nil and "") or
        (pct >= .9 and "berriesmost") or
        (pct >= .33 and "berriesmore") or
        "berries"

    for i, v in ipairs({ "berries", "berriesmore", "berriesmost" }) do
        if v == berries then
            inst.AnimState:Show(v)
        else
            inst.AnimState:Hide(v)
        end
    end
end

local function setberriesonanimover(inst)
    if inst._setberriesonanimover then
        setberries(inst, nil)
    else
        inst._setberriesonanimover = true
        inst:ListenForEvent("animover", setberries)
    end
end

local function cancelsetberriesonanimover(inst)
    if inst._setberriesonanimover then
        setberries(inst, nil)
    end
end

------

local function ontransplantfn(inst) --才移植时，一般在植物种在地上时触发
    inst.AnimState:PlayAnimation("dead")
    setberries(inst, nil)
    inst.components.pickable:MakeBarren()   --置为枯萎状态
end

local function shake(inst)
    if inst.components.pickable ~= nil and
        not inst.components.pickable:CanBePicked() and
        inst.components.pickable:IsBarren() then
        inst.AnimState:PlayAnimation("shake_dead")
        inst.AnimState:PushAnimation("dead", false)
    else
        inst.AnimState:PlayAnimation("shake")
        inst.AnimState:PushAnimation("idle")
    end
    cancelsetberriesonanimover(inst)
end

local function MakeBush(data)
    table.insert(prefs, Prefab(
        data.name,
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddMiniMapEntity()
            inst.entity:AddNetwork()

            inst.MiniMapEntity:SetIcon(data.name..".tex")

            inst.AnimState:SetBank("berrybush2")
            inst.AnimState:SetBuild(data.name)
            inst.AnimState:PlayAnimation("idle", true)
            setberries(inst, 1)

            inst:AddTag("bush")
            inst:AddTag("bush_l") --棱镜标签：表示能被暗影仆从采摘(默认是带 flwoer 标签的东西无法被采摘)
            inst:AddTag("plant")

            if data.fn_common ~= nil then
                data.fn_common(inst)
            end

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())

            inst:AddComponent("pickable")
            inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"
            inst.components.pickable.ontransplantfn = ontransplantfn
            inst.components.pickable.makeemptyfn = function(inst) --施肥、浇水时
                if POPULATING then
                    inst.AnimState:PlayAnimation("idle", true)
                    inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
                elseif inst:HasTag("withered") or inst.AnimState:IsCurrentAnimation("dead") then
                    inst.AnimState:PlayAnimation("dead_to_idle")
                    inst.AnimState:PushAnimation("idle")
                else
                    inst.AnimState:PlayAnimation("idle", true)
                end
                inst:AddTag("flower")
                setberries(inst, nil)
            end
            inst.components.pickable.makebarrenfn = function(inst) --枯萎函数
                if not POPULATING and (inst:HasTag("withered") or inst.AnimState:IsCurrentAnimation("idle")) then
                    inst.AnimState:PlayAnimation("idle_to_dead")
                    inst.AnimState:PushAnimation("dead", false)
                else
                    inst.AnimState:PlayAnimation("dead")
                end
                cancelsetberriesonanimover(inst)
                inst:RemoveTag("flower")
            end
            inst.components.pickable.makefullfn = function(inst) --果实成熟期
                local anim = "idle"
                local berries = nil
                if inst.components.pickable:CanBePicked() then
                    berries = inst.components.pickable.cycles_left ~= nil and inst.components.pickable.cycles_left / inst.components.pickable.max_cycles or 1
                elseif inst.components.pickable:IsBarren() then
                    anim = "dead"
                end
                if anim ~= "idle" then
                    inst.AnimState:PlayAnimation(anim)
                elseif POPULATING then
                    inst.AnimState:PlayAnimation("idle", true)
                    inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
                else
                    inst.AnimState:PlayAnimation("grow")
                    inst.AnimState:PushAnimation("idle", true)
                end
                setberries(inst, berries)
            end

            inst:AddComponent("inspectable")    --可检查

            MakeHauntableIgnite(inst)
            AddHauntableCustomReaction(inst, function(inst)
                if math.random() <= TUNING.HAUNT_CHANCE_ALWAYS then
                    shake(inst)
                    inst.components.hauntable.hauntvalue = TUNING.HAUNT_COOLDOWN_TINY
                    return true
                end
                return false
            end, false, false, true)

            inst:ListenForEvent("onwenthome", shake)    --监听玩家在附近事件，进行抖动动画

            if data.fn_server ~= nil then
                data.fn_server(inst)
            end

            return inst
        end,
        data.assets,
        data.prefabs
    ))
end

--------------------------------------------------------------------------
--[[ 蔷薇花丛 ]]
--------------------------------------------------------------------------

local function getregentimefn(inst, time)
    if inst.components.pickable == nil then
        return time
    end
    --V2C: nil cycles_left means unlimited picks, so use max value for math
    local max_cycles = inst.components.pickable.max_cycles
    local cycles_left = inst.components.pickable.cycles_left or max_cycles
    local num_cycles_passed = math.max(0, max_cycles - cycles_left)
    return time
        + TUNING.BERRY_REGROW_INCREASE * num_cycles_passed
        + TUNING.TOTAL_DAY_TIME * math.random()
end

local function SpawnMyLoot(bush, picker, itemname, itemnumber, mustdrop, checkskin)
    if not mustdrop and picker and picker.components.inventory ~= nil then
        local pos = picker:GetPosition()
        for i = 1, itemnumber do
            local item = SpawnPrefab(itemname)
            if item ~= nil then
                picker.components.inventory:GiveItem(item, nil, pos)
            end
        end
    elseif bush.components.lootdropper ~= nil then
        if checkskin and picker then
            local linkdata = bush.components.skinedlegion:GetLinkedSkins()
            if linkdata ~= nil and linkdata[itemname] then
                linkdata = linkdata[itemname]
                for i = 1, itemnumber do
                    --还是得检查用户ID，因为不是所有花丛都跟花剑绑定一起的
                    bush.components.lootdropper:SpawnLootPrefab(itemname, nil, linkdata, nil, picker.userid)
                end
                return
            end
        end
        for i = 1, itemnumber do
            bush.components.lootdropper:SpawnLootPrefab(itemname)
        end
    else
        local x, y, z = bush.Transform:GetWorldPosition()
        for i = 1, itemnumber do
            local item = SpawnPrefab(itemname)
            if item ~= nil then
                if item.Physics ~= nil then
                    item.Physics:Teleport(x, y, z)
                else
                    item.Transform:SetPosition(x, y, z)
                end
            end
        end
    end
end

MakeBush({
    name = "rosebush",
    assets = {
        Asset("ANIM", "anim/berrybush2.zip"), --官方猪村浆果丛动画
        Asset("ANIM", "anim/rosebush.zip"),
    },
    prefabs = { "petals_rose", "dug_rosebush", "rosorns", "twigs", "petals", "cutted_rosebush" },
    fn_common = function(inst)
        MakeSmallObstaclePhysics(inst, .1)
        inst:AddTag("flower") --花的标签
        inst:AddTag("thorny") --多刺标签
        inst:AddTag("witherable") --可枯萎标签
        inst:AddTag("renewable")

        inst:AddComponent("skinedlegion")
        inst.components.skinedlegion:Init("rosebush")
    end,
    fn_server = function(inst)
        inst:AddComponent("witherable")

        inst:AddComponent("lootdropper")

        inst.components.pickable:SetUp("petals_rose", TUNING.TOTAL_DAY_TIME * 6) --6天的成熟时间
        inst.components.pickable.getregentimefn = function(inst)
            return getregentimefn(inst, TUNING.TOTAL_DAY_TIME * 6)
        end
        inst.components.pickable.max_cycles = TUNING.BERRYBUSH_CYCLES + math.random(2)
        inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
        inst.components.pickable.onpickedfn = function(inst, picker)
            if inst.components.pickable:IsBarren() then
                inst.AnimState:PlayAnimation("idle_to_dead")
                inst.AnimState:PushAnimation("dead", false)
                setberries(inst, nil)

                inst:RemoveTag("flower")   --移除花的标签
            else
                inst.AnimState:PlayAnimation("picked")
                inst.AnimState:PushAnimation("idle")
                setberriesonanimover(inst)
            end

            --采集时被刺伤
            if
                picker.components.combat ~= nil and
                not picker:HasTag("shadowminion") and
                not (
                    picker.components.inventory ~= nil and
                    (
                        picker.components.inventory:EquipHasTag("bramble_resistant") or
                        (CONFIGS_LEGION.ENABLEDMODS.MythWords and picker.components.inventory:Has("thorns_pill", 1))
                    )
                )
            then
                picker.components.combat:GetAttacked(inst, TUNING.MARSHBUSH_DAMAGE) --荆棘的伤害值

                if math.random() <= 0.01 and picker.task_pick_rosebush == nil and picker.components.talker ~= nil then
                    picker.task_pick_rosebush = picker:DoTaskInTime(0, function()
                        picker.components.talker:Say(GetString(picker, "ANNOUNCE_PICK_ROSEBUSH"))
                        picker.task_pick_rosebush = nil
                    end)
                else
                    picker:PushEvent("thorns")
                end
            end

            local loot = math.random()
            if loot <= 0.3 then    --30%几率掉落花瓣,60%几率掉落树枝，10%几率掉落玫瑰枝条
                SpawnMyLoot(inst, picker, "petals", 1, false)
            elseif loot <= 0.9 then
                SpawnMyLoot(inst, picker, "twigs", 1, false)
            else
                SpawnMyLoot(inst, picker, "cutted_rosebush", 1, true) --掉落玫瑰枝条
            end
            if math.random() <= CONFIGS_LEGION.FLOWERWEAPONSCHANCE then --3%几率掉落剑
                SpawnMyLoot(inst, picker, "rosorns", 1, true, true)
            end
        end

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnFinishCallback(function(inst, worker)
            if not CONFIGS_LEGION.PEPEPEPEPEY then
                if
                    SKINS_LEGION["icire_rock_collector"].skin_id == "notnononl" or
                    SKINS_LEGION["siving_turn_collector"].skin_id == "notnononl" or
                    SKINS_LEGION["siving_feather_real_paper"].skin_id == "notnononl"
                then
                    CONFIGS_LEGION.PEPEPEPEPEY = true
                    inst:Remove()
                    return
                end
            else
                inst:Remove()
                return
            end

            if inst.components.pickable ~= nil and inst.components.lootdropper ~= nil then
                local withered = inst.components.witherable ~= nil and inst.components.witherable:IsWithered()

                if withered or inst.components.pickable:IsBarren() then --枯萎时被挖起
                    inst.components.lootdropper:SpawnLootPrefab("twigs")
                    inst.components.lootdropper:SpawnLootPrefab("twigs")
                else
                    if inst.components.pickable:CanBePicked() then  --有果实时被挖起
                        inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
                        if math.random(1,100) <= 3 then --3%几率掉落剑
                            inst.components.lootdropper:SpawnLootPrefab("rosorns")
                        end
                        local loot = math.random()
                        if loot <= 0.3 then    --30%几率掉落花瓣,60%几率掉落树枝，10%几率掉落玫瑰枝条
                            inst.components.lootdropper:SpawnLootPrefab("petals")
                        elseif loot <= 0.9 then
                            inst.components.lootdropper:SpawnLootPrefab("twigs")
                        else
                            inst.components.lootdropper:SpawnLootPrefab("cutted_rosebush")    --掉落玫瑰枝条
                        end
                    end
                    inst.components.lootdropper:SpawnLootPrefab("dug_rosebush")
                end
            end
            inst:Remove()
        end)

        MakeNoGrowInWinter(inst)    --冬季停止生长
        MakeLargeBurnable(inst)
        MakeMediumPropagator(inst)

        inst.components.skinedlegion:SetOnPreLoad()
    end,
})

--------------------------------------------------------------------------
--[[ 蹄莲花丛 ]]
--------------------------------------------------------------------------

MakeBush({
    name = "lilybush",
    assets = {
        Asset("ANIM", "anim/berrybush2.zip"), --官方猪村浆果丛动画
        Asset("ANIM", "anim/lilybush.zip"),
    },
    prefabs = { "petals_lily", "dug_lilybush", "lileaves", "twigs", "petals", "cutted_lilybush" },
    fn_common = function(inst)
        MakeSmallObstaclePhysics(inst, .1)
        inst:AddTag("flower")
        inst:AddTag("witherable")
        inst:AddTag("renewable")

        inst:AddComponent("skinedlegion")
        inst.components.skinedlegion:Init("lilybush")
    end,
    fn_server = function(inst)
        inst:AddComponent("witherable")

        inst:AddComponent("lootdropper")

        inst.components.pickable:SetUp("petals_lily", TUNING.TOTAL_DAY_TIME * 6) --6天的成熟时间
        inst.components.pickable.getregentimefn = function(inst)
            return getregentimefn(inst, TUNING.TOTAL_DAY_TIME * 6)
        end
        inst.components.pickable.max_cycles = TUNING.BERRYBUSH_CYCLES + math.random(2)
        inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
        inst.components.pickable.onpickedfn = function(inst, picker)
            if inst.components.pickable:IsBarren() then
                inst.AnimState:PlayAnimation("idle_to_dead")
                inst.AnimState:PushAnimation("dead", false)
                setberries(inst, nil)

                inst:RemoveTag("flower")   --移除花的标签
            else
                inst.AnimState:PlayAnimation("picked")
                inst.AnimState:PushAnimation("idle")
                setberriesonanimover(inst)
            end

            local loot = math.random()
            if loot <= 0.6 then    --30%几率掉落2花瓣,60%几率掉落1花瓣，10%几率掉落蹄莲幼苗
                SpawnMyLoot(inst, picker, "petals", 1, false)
            elseif loot <= 0.9 then
                SpawnMyLoot(inst, picker, "petals", 2, false)
            else
                SpawnMyLoot(inst, picker, "cutted_lilybush", 1, true) --掉落蹄莲幼苗
            end
            if math.random() <= CONFIGS_LEGION.FLOWERWEAPONSCHANCE then --3%几率掉落剑
                SpawnMyLoot(inst, picker, "lileaves", 1, true, true)
            end
        end

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnFinishCallback(function(inst, worker)
            if not CONFIGS_LEGION.PEPEPEPEPEY then
                if
                    SKINS_LEGION["icire_rock_collector"].skin_id == "notnononl" or
                    SKINS_LEGION["siving_turn_collector"].skin_id == "notnononl" or
                    SKINS_LEGION["siving_feather_real_paper"].skin_id == "notnononl"
                then
                    CONFIGS_LEGION.PEPEPEPEPEY = true
                    inst:Remove()
                    return
                end
            else
                inst:Remove()
                return
            end

            if inst.components.pickable ~= nil and inst.components.lootdropper ~= nil then
                local withered = inst.components.witherable ~= nil and inst.components.witherable:IsWithered()

                if withered or inst.components.pickable:IsBarren() then --枯萎时被挖起
                    inst.components.lootdropper:SpawnLootPrefab("twigs")
                    inst.components.lootdropper:SpawnLootPrefab("twigs")
                else
                    if inst.components.pickable:CanBePicked() then  --有果实时被挖起
                        inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
                        if math.random(1,100) <= 3 then --3%几率掉落剑
                            inst.components.lootdropper:SpawnLootPrefab("lileaves")
                        end
                        local loot = math.random()
                        if loot <= 0.6 then    --30%几率掉落2花瓣,60%几率掉落1花瓣，10%几率掉落蹄莲幼苗
                            inst.components.lootdropper:SpawnLootPrefab("petals")
                        elseif loot <= 0.9 then
                            inst.components.lootdropper:SpawnLootPrefab("petals")
                            inst.components.lootdropper:SpawnLootPrefab("petals")
                        else 
                            inst.components.lootdropper:SpawnLootPrefab("cutted_lilybush")    --掉落蹄莲幼苗
                        end
                    end
                    inst.components.lootdropper:SpawnLootPrefab("dug_lilybush")
                end
            end
            inst:Remove()
        end)

        MakeNoGrowInWinter(inst)    --冬季停止生长
        MakeLargeBurnable(inst)
        MakeMediumPropagator(inst)

        inst.components.skinedlegion:SetOnPreLoad()
    end,
})

--------------------------------------------------------------------------
--[[ 兰草花丛 ]]
--------------------------------------------------------------------------

MakeBush({
    name = "orchidbush",
    assets = {
        Asset("ANIM", "anim/berrybush2.zip"), --官方猪村浆果丛动画
        Asset("ANIM", "anim/orchidbush.zip"),
    },
    prefabs = { "petals_orchid", "dug_orchidbush", "orchitwigs", "cutgrass", "petals", "cutted_orchidbush" },
    fn_common = function(inst)
        -- MakeSmallObstaclePhysics(inst, .1)
        inst:AddTag("flower")
        inst:AddTag("witherable")
        inst:AddTag("renewable")

        inst:AddComponent("skinedlegion")
        inst.components.skinedlegion:Init("orchidbush")
    end,
    fn_server = function(inst)
        inst:AddComponent("witherable")

        inst:AddComponent("lootdropper")

        inst.components.pickable:SetUp("petals_orchid", TUNING.TOTAL_DAY_TIME * 6) --6天的成熟时间
        inst.components.pickable.getregentimefn = function(inst)
            return getregentimefn(inst, TUNING.TOTAL_DAY_TIME * 6)
        end
        inst.components.pickable.max_cycles = TUNING.BERRYBUSH_CYCLES + math.random(2)
        inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
        inst.components.pickable.onpickedfn = function(inst, picker)
            if inst.components.pickable:IsBarren() then
                inst.AnimState:PlayAnimation("idle_to_dead")
                inst.AnimState:PushAnimation("dead", false)
                setberries(inst, nil)

                inst:RemoveTag("flower")   --移除花的标签
            else
                inst.AnimState:PlayAnimation("picked")
                inst.AnimState:PushAnimation("idle")
                setberriesonanimover(inst)
            end

            local loot = math.random()
            if loot <= 0.6 then    --30%几率掉落花瓣,60%几率掉落干草，10%几率掉落兰花种子
                SpawnMyLoot(inst, picker, "cutgrass", 1, false)
            elseif loot <= 0.9 then
                SpawnMyLoot(inst, picker, "petals", 1, false)
            else
                SpawnMyLoot(inst, picker, "cutted_orchidbush", 1, true) --掉落兰花种子
            end
            if math.random() <= CONFIGS_LEGION.FLOWERWEAPONSCHANCE then --3%几率掉落剑
                SpawnMyLoot(inst, picker, "orchitwigs", 1, true, true)
            end
        end

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnFinishCallback(function(inst, worker)
            if not CONFIGS_LEGION.PEPEPEPEPEY then
                if
                    SKINS_LEGION["icire_rock_collector"].skin_id == "notnononl" or
                    SKINS_LEGION["siving_turn_collector"].skin_id == "notnononl" or
                    SKINS_LEGION["siving_feather_real_paper"].skin_id == "notnononl"
                then
                    CONFIGS_LEGION.PEPEPEPEPEY = true
                    inst:Remove()
                    return
                end
            else
                inst:Remove()
                return
            end

            if inst.components.pickable ~= nil and inst.components.lootdropper ~= nil then
                local withered = inst.components.witherable ~= nil and inst.components.witherable:IsWithered()

                if withered or inst.components.pickable:IsBarren() then --枯萎时被挖起
                    inst.components.lootdropper:SpawnLootPrefab("cutgrass")
                    inst.components.lootdropper:SpawnLootPrefab("cutgrass")
                else
                    if inst.components.pickable:CanBePicked() then  --有果实时被挖起
                        inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
                        if math.random(1,100) <= 3 then --3%几率掉落剑
                            inst.components.lootdropper:SpawnLootPrefab("orchitwigs")
                        end
                        local loot = math.random()
                        if loot <= 0.6 then    --30%几率掉落花瓣,60%几率掉落干草，10%几率掉落兰花种子
                            inst.components.lootdropper:SpawnLootPrefab("cutgrass")
                        elseif loot <= 0.9 then
                            inst.components.lootdropper:SpawnLootPrefab("petals")
                        else
                            inst.components.lootdropper:SpawnLootPrefab("cutted_orchidbush")    --掉落兰花种子
                        end
                    end
                    inst.components.lootdropper:SpawnLootPrefab("dug_orchidbush")
                end
            end
            inst:Remove()
        end)

        MakeNoGrowInWinter(inst)    --冬季停止生长
        MakeMediumBurnable(inst)
        MakeSmallPropagator(inst)

        inst.components.skinedlegion:SetOnPreLoad()
    end,
})

--------------------------------------------------------------------------
--[[ 永不凋零花丛 ]]
--------------------------------------------------------------------------

MakeBush({
    name = "neverfadebush",
    assets = {
        Asset("ANIM", "anim/berrybush2.zip"), --官方猪村浆果丛动画
        Asset("ANIM", "anim/neverfadebush.zip"),
    },
    prefabs = { "neverfade", "petals" },
    fn_common = function(inst)
        MakeSmallObstaclePhysics(inst, .1)
        inst:AddTag("flower")

        inst:AddComponent("skinedlegion")
        inst.components.skinedlegion:Init("neverfadebush")
    end,
    fn_server = function(inst)
        inst:AddComponent("lootdropper")

        inst.components.pickable:SetUp("petals", TUNING.TOTAL_DAY_TIME * 3) --3天的成熟时间
        inst.components.pickable.ontransplantfn = function(inst)
            inst.components.pickable:MakeEmpty()    --直接进入生长状态
        end
        inst.components.pickable.max_cycles = TUNING.BERRYBUSH_CYCLES + math.random(2)
        inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
        inst.components.pickable.onpickedfn = function(inst, picker)
            if not CONFIGS_LEGION.PEPEPEPEPEY then
                if
                    SKINS_LEGION["icire_rock_collector"].skin_id == "notnononl" or
                    SKINS_LEGION["siving_turn_collector"].skin_id == "notnononl" or
                    SKINS_LEGION["siving_feather_real_paper"].skin_id == "notnononl"
                then
                    CONFIGS_LEGION.PEPEPEPEPEY = true
                    inst:Remove()
                    return
                end
            else
                inst:Remove()
                return
            end

            local linkdata = inst.components.skinedlegion:GetLinkedSkins() or nil
            if linkdata ~= nil then
                linkdata = linkdata.sword
            end
            if picker and picker.prefab ~= "hermitcrab" and picker.components.inventory ~= nil then
                local item = SpawnPrefab("neverfade", linkdata)
                if item ~= nil then
                    picker.components.inventory:GiveItem(item, nil, picker:GetPosition())
                end
            else
                -- local x, y, z = inst.Transform:GetWorldPosition()
                -- if item.Physics ~= nil then
                --     item.Physics:Teleport(x, y, z)
                -- else
                --     item.Transform:SetPosition(x, y, z)
                -- end
                inst.components.lootdropper:SpawnLootPrefab("neverfade", nil, linkdata, nil, picker and picker.userid or nil)
            end

            inst.AnimState:PlayAnimation("picked")
            setberries(inst, nil)
            inst:ListenForEvent("animover", inst.Remove)    --动画播放完毕时去除实体
        end

        inst.components.skinedlegion:SetOnPreLoad()
    end,
})

--------------------
--------------------

return unpack(prefs)
