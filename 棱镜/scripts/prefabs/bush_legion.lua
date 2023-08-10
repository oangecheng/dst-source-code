local prefs = {}

--------------------------------------------------------------------------
--[[ 通用 ]]
--------------------------------------------------------------------------

local function setberries(inst, pct) --设置果实的贴图
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

local function TriggerFlowerTag(inst, isadd)
    if inst:HasTag("bush_l_f") then --只有花丛才需要，普通丛不需要
        if isadd then
            inst:AddTag("flower")
        else
            inst:RemoveTag("flower")
        end
    end
end
local function MakeEmpty(inst) --施肥、浇水时
    if POPULATING then
        inst.AnimState:PlayAnimation("idle", true)
        -- inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
        inst.AnimState:SetFrame(math.random(inst.AnimState:GetCurrentAnimationNumFrames()) - 1)
    elseif inst:HasTag("withered") or inst.AnimState:IsCurrentAnimation("dead") then
        inst.AnimState:PlayAnimation("dead_to_idle")
        inst.AnimState:PushAnimation("idle")
    else
        inst.AnimState:PlayAnimation("idle", true)
    end
    TriggerFlowerTag(inst, true)
    setberries(inst, nil)
end
local function MakeBarren(inst) --枯萎时
    if not POPULATING and (inst:HasTag("withered") or inst.AnimState:IsCurrentAnimation("idle")) then
        inst.AnimState:PlayAnimation("idle_to_dead")
        inst.AnimState:PushAnimation("dead", false)
    else
        inst.AnimState:PlayAnimation("dead")
    end
    cancelsetberriesonanimover(inst)
    TriggerFlowerTag(inst, false)
end
local function MakeFull(inst) --果实成熟时
    local anim = "idle"
    local berries = nil
    if inst.components.pickable ~= nil then
        if inst.components.pickable:CanBePicked() then
            berries = inst.components.pickable.cycles_left ~= nil and inst.components.pickable.cycles_left / inst.components.pickable.max_cycles or 1
        elseif inst.components.pickable:IsBarren() then
            anim = "dead"
        end
    end
    if anim ~= "idle" then
        inst.AnimState:PlayAnimation(anim)
    elseif POPULATING then
        inst.AnimState:PlayAnimation("idle", true)
        -- inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
        inst.AnimState:SetFrame(math.random(inst.AnimState:GetCurrentAnimationNumFrames()) - 1)
    else
        inst.AnimState:PlayAnimation("grow")
        inst.AnimState:PushAnimation("idle", true)
    end
    setberries(inst, berries)
end
local function OnTransplant(inst) --才移植时，一般在植物种在地上时触发
    inst.AnimState:PlayAnimation("dead")
    setberries(inst, nil)
    inst.components.pickable:MakeBarren()   --置为枯萎状态
end
local function ShakeBush(inst)
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
local function OnHaunt(inst)
    if math.random() <= TUNING.HAUNT_CHANCE_ALWAYS then
        ShakeBush(inst)
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_COOLDOWN_TINY
        return true
    end
    return false
end
local function OnPicked(inst, picker)
    if inst.components.pickable ~= nil then
        --V2C: nil cycles_left means unlimited picks, so use max value for math
        --local old_percent = inst.components.pickable.cycles_left ~= nil and (inst.components.pickable.cycles_left + 1) / inst.components.pickable.max_cycles or 1
        --setberries(inst, old_percent)
        if inst.components.pickable:IsBarren() then
            inst.AnimState:PlayAnimation("idle_to_dead")
            inst.AnimState:PushAnimation("dead", false)
            setberries(inst, nil)
            TriggerFlowerTag(inst, false)
        else
            inst.AnimState:PlayAnimation("picked")
            inst.AnimState:PushAnimation("idle")
            setberriesonanimover(inst)
        end
    end
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
            inst.Transform:SetTwoFaced() --两个面，这样就可以左右不同（再多貌似有问题）

            inst.AnimState:SetBank("berrybush2")
            inst.AnimState:SetBuild(data.name)
            inst.AnimState:PlayAnimation("idle", true)
            setberries(inst, 1)

            inst:AddTag("bush")
            inst:AddTag("plant")
            inst:AddTag("bush_l") --棱镜标签：暂无作用
            inst:AddTag("rotatableobject") --能让栅栏击剑起作用
            inst:AddTag("flatrotated_l") --棱镜标签：旋转时旋转180度

            -- MakeSnowCoveredPristine(inst) --由于某些花丛因体型原因，积雪效果有破绽，就不用了

            if data.fn_common ~= nil then
                data.fn_common(inst)
            end

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            -- inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
            inst.AnimState:SetFrame(math.random(inst.AnimState:GetCurrentAnimationNumFrames()) - 1)

            inst:AddComponent("inspectable")

            inst:AddComponent("savedrotation")

            inst:AddComponent("lootdropper")

            inst:AddComponent("pickable")
            inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"
            inst.components.pickable.ontransplantfn = OnTransplant
            inst.components.pickable.makeemptyfn = MakeEmpty
            inst.components.pickable.makebarrenfn = MakeBarren
            inst.components.pickable.makefullfn = MakeFull
            -- inst.components.pickable.onpickedfn = onpickedfn

            inst:ListenForEvent("onwenthome", ShakeBush) --监听生物回家事件，目前只有火鸡吧

            MakeHauntableIgnite(inst)
            AddHauntableCustomReaction(inst, OnHaunt, false, false, true)

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

local function GetRegenTime(inst, time)
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
local function GetRegenTime_base(inst)
    return GetRegenTime(inst, TUNING.TOTAL_DAY_TIME * 6)
end
local function SpawnStackDrop(name, num, bush, doer, mustdrop, checkskin, items)
    local item = SpawnPrefab(name)
	if item ~= nil then
        if checkskin and doer ~= nil and doer.userid ~= nil then --还是得检查用户ID，因为不是所有花丛都跟花剑绑定一起的
            bush.components.skinedlegion:SetLinkedSkin(item, "sword", doer)
        end

		if num > 1 and item.components.stackable ~= nil then
			local maxsize = item.components.stackable.maxsize
			if num <= maxsize then
				item.components.stackable:SetStackSize(num)
				num = 0
			else
				item.components.stackable:SetStackSize(maxsize)
				num = num - maxsize
			end
		else
			num = num - 1
        end

		-- if items ~= nil then
		-- 	table.insert(items, item)
		-- end
        local pos = bush:GetPosition()
        item.Transform:SetPosition(pos:Get())
        if item.components.inventoryitem ~= nil then
			if not mustdrop and doer ~= nil and doer.components.inventory ~= nil then
				doer.components.inventory:GiveItem(item, nil, pos)
			else
				-- if not item:HasTag("heavy") then --巨大作物不知道为啥不能弹射
					item.components.inventoryitem:OnDropped(true)
				-- end
			end
        end

		if num >= 1 then
			SpawnStackDrop(name, num, bush, doer, mustdrop, checkskin, items)
		end
	end
end

local function SpawnSpecialLoot_rose(inst, picker, mustdrop)
    local loot = math.random()
    if loot < 0.3 then --30%几率掉落花瓣，65%几率掉落树枝，5%几率掉落蔷薇折枝
        SpawnStackDrop("petals", 1, inst, picker, mustdrop, false)
    elseif loot < 0.95 then
        SpawnStackDrop("twigs", 1, inst, picker, mustdrop, false)
    else
        SpawnStackDrop("cutted_rosebush", 1, inst, picker, true, false)
    end
    if math.random() < CONFIGS_LEGION.FLOWERWEAPONSCHANCE then --3%几率掉落剑
        SpawnStackDrop("rosorns", 1, inst, picker, true, true)
    end
end
local function OnPicked_rose(inst, picker)
    OnPicked(inst, picker)
    SpawnSpecialLoot_rose(inst, picker, false)

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

        if math.random() < 0.01 and picker.task_pick_rosebush == nil and picker.components.talker ~= nil then
            picker.task_pick_rosebush = picker:DoTaskInTime(0, function()
                picker.components.talker:Say(GetString(picker, "ANNOUNCE_PICK_ROSEBUSH"))
                picker.task_pick_rosebush = nil
            end)
        else
            picker:PushEvent("thorns")
        end
    end
end
local function OnFinish_rose(inst, worker)
    if inst.components.pickable ~= nil then
        local withered = inst.components.witherable ~= nil and inst.components.witherable:IsWithered()
        if withered or inst.components.pickable:IsBarren() then --枯萎时被挖起
            SpawnStackDrop("twigs", 2, inst, worker, true, false)
        else
            if inst.components.pickable:CanBePicked() then --有果实时被挖起
                SpawnStackDrop(inst.components.pickable.product, 1, inst, worker, true, false)
                SpawnSpecialLoot_rose(inst, worker, true)
            end
            SpawnStackDrop("dug_rosebush", 1, inst, worker, true, false)
        end
    end
    inst:Remove()
end

MakeBush({
    name = "rosebush",
    assets = {
        Asset("ANIM", "anim/berrybush2.zip"), --官方猪村浆果丛动画
        Asset("ANIM", "anim/rosebush.zip")
    },
    prefabs = { "petals_rose", "dug_rosebush", "rosorns", "twigs", "petals", "cutted_rosebush" },
    fn_common = function(inst)
        -- MakeSmallObstaclePhysics(inst, .1)
        inst:SetPhysicsRadiusOverride(.5)
        inst:AddTag("flower") --花的标签
        inst:AddTag("thorny") --多刺标签
        inst:AddTag("witherable") --可枯萎标签
        inst:AddTag("renewable")
        inst:AddTag("bush_l_f") --棱镜标签：表示能被暗影仆从采摘(默认是带 flwoer 标签的东西无法被采摘)

        inst:AddComponent("skinedlegion")
        inst.components.skinedlegion:Init("rosebush")
    end,
    fn_server = function(inst)
        inst:AddComponent("witherable")

        inst.components.pickable:SetUp("petals_rose", TUNING.TOTAL_DAY_TIME * 6) --6天的成熟时间
        inst.components.pickable.getregentimefn = GetRegenTime_base
        inst.components.pickable.max_cycles = TUNING.BERRYBUSH_CYCLES + math.random(2)
        inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
        inst.components.pickable.onpickedfn = OnPicked_rose

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnFinishCallback(OnFinish_rose)

        MakeNoGrowInWinter(inst) --冬季停止生长
        MakeLargeBurnable(inst)
        MakeMediumPropagator(inst)

        -- inst.components.skinedlegion:SetOnPreLoad()
    end
})

--------------------------------------------------------------------------
--[[ 蹄莲花丛 ]]
--------------------------------------------------------------------------

local function SpawnSpecialLoot_lily(inst, picker, mustdrop)
    local loot = math.random()
    if loot < 0.3 then --30%几率掉落1花瓣，60%几率掉落2花瓣，10%几率掉落蹄莲芽束
        SpawnStackDrop("petals", 1, inst, picker, mustdrop, false)
    elseif loot < 0.9 then
        SpawnStackDrop("petals", 2, inst, picker, mustdrop, false)
    else
        SpawnStackDrop("cutted_lilybush", 1, inst, picker, true, false)
    end
    if math.random() < CONFIGS_LEGION.FLOWERWEAPONSCHANCE then --3%几率掉落剑
        SpawnStackDrop("lileaves", 1, inst, picker, true, true)
    end
end
local function OnPicked_lily(inst, picker)
    OnPicked(inst, picker)
    SpawnSpecialLoot_lily(inst, picker, false)
end
local function OnFinish_lily(inst, worker)
    if inst.components.pickable ~= nil then
        local withered = inst.components.witherable ~= nil and inst.components.witherable:IsWithered()
        if withered or inst.components.pickable:IsBarren() then --枯萎时被挖起
            SpawnStackDrop("twigs", 2, inst, worker, true, false)
        else
            if inst.components.pickable:CanBePicked() then --有果实时被挖起
                SpawnStackDrop(inst.components.pickable.product, 1, inst, worker, true, false)
                SpawnSpecialLoot_lily(inst, worker, true)
            end
            SpawnStackDrop("dug_lilybush", 1, inst, worker, true, false)
        end
    end
    inst:Remove()
end

MakeBush({
    name = "lilybush",
    assets = {
        Asset("ANIM", "anim/berrybush2.zip"), --官方猪村浆果丛动画
        Asset("ANIM", "anim/lilybush.zip")
    },
    prefabs = { "petals_lily", "dug_lilybush", "lileaves", "twigs", "petals", "cutted_lilybush" },
    fn_common = function(inst)
        -- MakeSmallObstaclePhysics(inst, .1)
        inst:SetPhysicsRadiusOverride(.5)
        inst:AddTag("flower")
        inst:AddTag("witherable")
        inst:AddTag("renewable")
        inst:AddTag("bush_l_f") --棱镜标签：表示能被暗影仆从采摘(默认是带 flwoer 标签的东西无法被采摘)

        inst:AddComponent("skinedlegion")
        inst.components.skinedlegion:Init("lilybush")
    end,
    fn_server = function(inst)
        inst:AddComponent("witherable")

        inst.components.pickable:SetUp("petals_lily", TUNING.TOTAL_DAY_TIME * 6) --6天的成熟时间
        inst.components.pickable.getregentimefn = GetRegenTime_base
        inst.components.pickable.max_cycles = TUNING.BERRYBUSH_CYCLES + math.random(2)
        inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
        inst.components.pickable.onpickedfn = OnPicked_lily

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnFinishCallback(OnFinish_lily)

        MakeNoGrowInWinter(inst) --冬季停止生长
        MakeLargeBurnable(inst)
        MakeMediumPropagator(inst)

        -- inst.components.skinedlegion:SetOnPreLoad()
    end,
})

--------------------------------------------------------------------------
--[[ 兰草花丛 ]]
--------------------------------------------------------------------------

local function SpawnSpecialLoot_orchid(inst, picker, mustdrop)
    local loot = math.random()
    if loot < 0.3 then --30%几率掉落花瓣，60%几率掉落干草，10%几率掉落兰草种籽
        SpawnStackDrop("petals", 1, inst, picker, mustdrop, false)
    elseif loot < 0.9 then
        SpawnStackDrop("cutgrass", 1, inst, picker, mustdrop, false)
    else
        SpawnStackDrop("cutted_orchidbush", 1, inst, picker, true, false)
    end
    if math.random() < CONFIGS_LEGION.FLOWERWEAPONSCHANCE then --3%几率掉落剑
        SpawnStackDrop("orchitwigs", 1, inst, picker, true, true)
    end
end
local function OnPicked_orchid(inst, picker)
    OnPicked(inst, picker)
    SpawnSpecialLoot_orchid(inst, picker, false)
end
local function OnFinish_orchid(inst, worker)
    if inst.components.pickable ~= nil then
        local withered = inst.components.witherable ~= nil and inst.components.witherable:IsWithered()
        if withered or inst.components.pickable:IsBarren() then --枯萎时被挖起
            SpawnStackDrop("cutgrass", 2, inst, worker, true, false)
        else
            if inst.components.pickable:CanBePicked() then --有果实时被挖起
                SpawnStackDrop(inst.components.pickable.product, 1, inst, worker, true, false)
                SpawnSpecialLoot_orchid(inst, worker, true)
            end
            SpawnStackDrop("dug_orchidbush", 1, inst, worker, true, false)
        end
    end
    inst:Remove()
end

MakeBush({
    name = "orchidbush",
    assets = {
        Asset("ANIM", "anim/berrybush2.zip"), --官方猪村浆果丛动画
        Asset("ANIM", "anim/orchidbush.zip")
    },
    prefabs = { "petals_orchid", "dug_orchidbush", "orchitwigs", "cutgrass", "petals", "cutted_orchidbush" },
    fn_common = function(inst)
        -- MakeSmallObstaclePhysics(inst, .1) --兰草的没有体积
        inst:SetPhysicsRadiusOverride(.5)
        inst:AddTag("flower")
        inst:AddTag("witherable")
        inst:AddTag("renewable")
        inst:AddTag("bush_l_f") --棱镜标签：表示能被暗影仆从采摘(默认是带 flwoer 标签的东西无法被采摘)

        inst:AddComponent("skinedlegion")
        inst.components.skinedlegion:Init("orchidbush")
    end,
    fn_server = function(inst)
        inst:AddComponent("witherable")

        inst.components.pickable:SetUp("petals_orchid", TUNING.TOTAL_DAY_TIME * 6) --6天的成熟时间
        inst.components.pickable.getregentimefn = GetRegenTime_base
        inst.components.pickable.max_cycles = TUNING.BERRYBUSH_CYCLES + math.random(2)
        inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
        inst.components.pickable.onpickedfn = OnPicked_orchid

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnFinishCallback(OnFinish_orchid)

        MakeNoGrowInWinter(inst) --冬季停止生长
        MakeMediumBurnable(inst)
        MakeSmallPropagator(inst)

        -- inst.components.skinedlegion:SetOnPreLoad()
    end,
})

--------------------------------------------------------------------------
--[[ 永不凋零花丛 ]]
--------------------------------------------------------------------------

local function OnTransplant_never(inst)
    inst.components.pickable:MakeEmpty() --直接进入生长状态
end
local function OnPicked_never(inst, picker)
    if picker and picker.prefab == "hermitcrab" then --螃蟹奶奶采集的，必需掉落，不然就被吃了
        SpawnStackDrop("neverfade", 1, inst, picker, true, true)
    else
        SpawnStackDrop("neverfade", 1, inst, picker, false, true)
    end
    inst.AnimState:PlayAnimation("picked")
    setberries(inst, nil)
    inst:ListenForEvent("animover", inst.Remove)
end

MakeBush({
    name = "neverfadebush",
    assets = {
        Asset("ANIM", "anim/berrybush2.zip"), --官方猪村浆果丛动画
        Asset("ANIM", "anim/neverfadebush.zip")
    },
    prefabs = { "neverfade", "petals" },
    fn_common = function(inst)
        -- MakeSmallObstaclePhysics(inst, .1)
        inst:SetPhysicsRadiusOverride(.5)
        inst:AddTag("flower")

        inst:AddComponent("skinedlegion")
        inst.components.skinedlegion:Init("neverfadebush")
    end,
    fn_server = function(inst)
        inst.components.pickable:SetUp("petals", TUNING.TOTAL_DAY_TIME * 3) --3天的成熟时间
        inst.components.pickable.ontransplantfn = OnTransplant_never
        inst.components.pickable.max_cycles = TUNING.BERRYBUSH_CYCLES + math.random(2)
        inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
        inst.components.pickable.onpickedfn = OnPicked_never

        -- inst.components.skinedlegion:SetOnPreLoad()
    end,
})

--------------------
--------------------

return unpack(prefs)
