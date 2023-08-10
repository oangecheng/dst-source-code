local prefs = {}
local wortox_soul_common = require("prefabs/wortox_soul_common")

--------------------------------------------------------------------------
--[[ 子圭石 ]]
--------------------------------------------------------------------------

if not CONFIGS_LEGION.ENABLEDMODS.MythWords then --未开启神话书说时才注册这个prefab
    table.insert(prefs, Prefab(
        "siving_rocks",
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddNetwork()

            MakeInventoryPhysics(inst)

            inst.AnimState:SetBank("myth_siving")
            inst.AnimState:SetBuild("myth_siving")
            inst.AnimState:PlayAnimation("siving_rocks")

            inst:AddTag("molebait")

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst:AddComponent("stackable")
            inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

            inst:AddComponent("inspectable")

            inst:AddComponent("tradable")
            inst.components.tradable.rocktribute = 6 --延缓 0.33x6 天地震
            inst.components.tradable.goldvalue = 4 --换1个砂之石或4金块

            inst:AddComponent("bait")

            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem.imagename = "siving_rocks"
            inst.components.inventoryitem.atlasname = "images/inventoryimages/siving_rocks.xml"
            inst.components.inventoryitem:SetSinks(true)

            MakeHauntableLaunchAndIgnite(inst)

            return inst
        end,
        {
            Asset("ANIM", "anim/myth_siving.zip"),
            Asset("ATLAS", "images/inventoryimages/siving_rocks.xml"),
            Asset("IMAGE", "images/inventoryimages/siving_rocks.tex"),
        },
        nil
    ))
end

--------------------------------------------------------------------------
--[[ 子圭奇型岩 ]]
--------------------------------------------------------------------------

local tradableItems_siv = {
    lightbulb = { kind = 1, value_dt = 0.1, value = 1/80, needall = true },
    lantern = { kind = 1, value_dt = 2, value = 1/8 },
    wx78module_light = { kind = 1, value_dt = 3, value = 0.25 },
    lightflier = { kind = 1, value_dt = 2, value = 0.1 },
    fireflies = { kind = 1, value_dt = 2, value = 0.1 },
    wormlight_lesser = { kind = 1, value_dt = 1, value = 1/8, needall = true },
    wormlight = { kind = 1, value_dt = 3, value = 0.2, needall = true },
    dish_fleshnapoleon = { kind = 1, value_dt = 4, value = 0.2, needall = true },
    glowberrymousse = { kind = 1, value_dt = 5, value = 0.25, needall = true },
    minerhat = { kind = 1, value_dt = 3, value = 0.2 },
    pumpkin_lantern = { kind = 1, value_dt = 3, value = 0.2 },
    book_light = { kind = 1, value_dt = 4, value = 0.25 },
    book_light_upgraded = { kind = 1, value_dt = 5, value = 0.5 },
    nightstick = { kind = 1, value_dt = 5, value = 0.5 },
    yellowgem = { kind = 1, value_dt = 15, value = 0.75 },
    yellowamulet = { kind = 1, value_dt = 20, value = 1.25 },
    yellowstaff = { kind = 1, value_dt = 20, value = 1.25 },
    yellowmooneye = { kind = 1, value_dt = 20, value = 1.25 },
    opalpreciousgem = { kind = 1, value_dt = 40, value = 4 },
    opalstaff = { kind = 1, value_dt = 60, value = 5 },
    alterguardianhatshard = { kind = 1, value_dt = 150, value = 10 },
    alterguardianhat = { kind = 1, value_dt = 750, value = 50 },

    redgem = { kind = 2, value_dt = 8, value = 0.25 },
    redmooneye = { kind = 2, value_dt = 15, value = 0.5 },
    amulet = { kind = 2, value_dt = 15, value = 0.5 },
    dish_lovingrosecake = { kind = 2, value_dt = 4, value = 0.25, needall = true },
    pocketwatch_heal = { kind = 2, value_dt = 5, value = 0.5 },
    reviver = { kind = 2, value_dt = 2, value = 0.25 },
    -- siving_mask_gold = { kind = 2, value_dt = 1, value = 0.15 }
}

local function TryDropRock(inst, chance)
    if chance >= 1 or math.random() <= chance then
        inst.components.lootdropper:SpawnLootPrefab("siving_rocks")
    end
end
local function GrowRock(inst, num)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x,y,z, 6,
        nil,
        {"NOCLICK", "FX", "INLIMBO"},
        nil
    )
    local numloot = 0
    local stackitem = nil
    for _, ent in ipairs(ents) do
        if ent.prefab == "siving_rocks" then
            numloot = numloot + 1
            if stackitem == nil and not ent.components.stackable:IsFull() then
                stackitem = ent
            end
            if numloot >= 4 then
                if stackitem ~= nil then
                    break
                else --周围的子圭石最多只能4组
                    return
                end
            end
        end
    end
    for i = 1, num, 1 do
        if stackitem == nil or stackitem.components.stackable:IsFull() then
            TryDropRock(inst, 1)
        else
            stackitem.components.stackable:SetStackSize(stackitem.components.stackable:StackSize()+1)
        end
    end
end
local function SetAnim_dt(inst, name)
    if inst.treeState ~= 2 then --根据生命与光的能量，决定最终状态
        if inst.tradeditems ~= nil then
            if inst.tradeditems.light > 0 and inst.tradeditems.health > 0 then
                name = name.."_live"
            end
        end
    else
        name = name.."_live"
    end
    inst.AnimState:PlayAnimation(name, false)
end
local function OnFinish_dt0(inst, worker)
    inst.components.lootdropper:SpawnLootPrefab("siving_derivant_item")
    inst:Remove()
end
local function OnWork_dt1(inst, worker, workleft)
    if workleft > 0 then
        TryDropRock(inst, 0.02)
    else
        TryDropRock(inst, 1)
        inst.components.growable:SetStage(inst.components.growable:GetStage() - 1)
        inst.components.growable:StartGrowing()
    end
end
local function OnWork_dt2(inst, worker, workleft)
    if workleft > 0 then
        TryDropRock(inst, 0.03)
    else
        TryDropRock(inst, 1)
        TryDropRock(inst, 1)
        inst.components.growable:SetStage(inst.components.growable:GetStage() - 1)
        inst.components.growable:StartGrowing()
    end
end
local function OnWork_dt3(inst, worker, workleft)
    if workleft > 0 then
        TryDropRock(inst, 0.04)
    else
        TryDropRock(inst, 1)
        TryDropRock(inst, 1)
        TryDropRock(inst, 1)
        inst.components.timer:StopTimer("fallenleaf")
        inst.components.growable:SetStage(inst.components.growable:GetStage() - 1)
        inst.components.growable:StartGrowing()
    end
end
local function MagicGrow_dt3(inst, doer)
    inst:PushEvent("timerdone", { name = "fallenleaf" })
end
local function OnGrow_dt(inst)
    if inst.tradeditems == nil then
        return
    end
    if inst.tradeditems.light >= 1 and inst.tradeditems.health >= 1 then
        GrowRock(inst, 2)
        inst.ComputTraded(inst, -1, -1)
    elseif inst.tradeditems.light >= 1 then
        GrowRock(inst, 1)
        inst.ComputTraded(inst, -1, 0)
    elseif inst.tradeditems.health >= 1 then
        GrowRock(inst, 1)
        inst.ComputTraded(inst, 0, -1)
    end
end

local growth_stages_dt = {
    {
        name = "lvl0",
        time = function(inst, stage, stagedata)
            return GetRandomWithVariance(TUNING.TOTAL_DAY_TIME*6, TUNING.TOTAL_DAY_TIME/2)
        end,
        fn = function(inst, stage, stagedata)
            SetAnim_dt(inst, "lvl0")
            inst.components.workable:SetWorkAction(ACTIONS.DIG)
            inst.components.workable:SetWorkLeft(3)
            inst.components.workable:SetOnWorkCallback(nil)
            inst.components.workable:SetOnFinishCallback(OnFinish_dt0)
            inst.components.growable.domagicgrowthfn = nil
        end,
        growfn = OnGrow_dt
    },
    {
        name = "lvl1",
        time = function(inst, stage, stagedata)
            return GetRandomWithVariance(TUNING.TOTAL_DAY_TIME*7.5, TUNING.TOTAL_DAY_TIME/2)
        end,
        fn = function(inst, stage, stagedata)
            SetAnim_dt(inst, "lvl1")
            inst.components.workable:SetWorkAction(ACTIONS.MINE)
            inst.components.workable:SetWorkLeft(6)
            inst.components.workable:SetOnWorkCallback(OnWork_dt1)
            inst.components.workable:SetOnFinishCallback(nil)
            inst.components.growable.domagicgrowthfn = nil
        end,
        growfn = OnGrow_dt
    },
    {
        name = "lvl2",
        time = function(inst, stage, stagedata)
            return GetRandomWithVariance(TUNING.TOTAL_DAY_TIME*8, TUNING.TOTAL_DAY_TIME/2)
        end,
        fn = function(inst, stage, stagedata)
            SetAnim_dt(inst, "lvl2")
            inst.components.workable:SetWorkAction(ACTIONS.MINE)
            inst.components.workable:SetWorkLeft(9)
            inst.components.workable:SetOnWorkCallback(OnWork_dt2)
            inst.components.workable:SetOnFinishCallback(nil)
            inst.components.growable.domagicgrowthfn = nil
        end,
        growfn = OnGrow_dt
    },
    {
        name = "lvl3",
        time = function(inst, stage, stagedata)
            return GetRandomWithVariance(TUNING.TOTAL_DAY_TIME*6, TUNING.TOTAL_DAY_TIME/2)
        end,
        fn = function(inst, stage, stagedata)
            SetAnim_dt(inst, "lvl3")
            inst.components.workable:SetWorkAction(ACTIONS.MINE)
            inst.components.workable:SetWorkLeft(12)
            inst.components.workable:SetOnWorkCallback(OnWork_dt3)
            inst.components.workable:SetOnFinishCallback(nil)
            inst.components.growable.domagicgrowthfn = MagicGrow_dt3
            inst.components.growable:StopGrowing()
            if not inst.components.timer:TimerExists("fallenleaf") then
                inst.components.timer:StartTimer("fallenleaf", stagedata.time(inst, stage, stagedata))
            end
        end,
        growfn = OnGrow_dt
    }
}

local function GetAllActiveItems(giver, item)
    if item.components.stackable ~= nil then --有叠加组件，说明鼠标上可能有物品
        if giver.components.inventory ~= nil then
            local activeitem = giver.components.inventory:GetActiveItem()
            if activeitem ~= nil and activeitem.prefab == item.prefab then
                activeitem.components.inventoryitem:RemoveFromOwner(true)
                item.components.stackable:Put(activeitem)
                return item.components.stackable:StackSize()
            end
        end
    end
    return 1
end
local function ComputTraded_dt(inst, light, health)
    if inst.tradeditems == nil then
        inst.tradeditems = { light = 0, health = 0 }
    end
    if light ~= nil then
        inst.tradeditems.light = math.max(0, inst.tradeditems.light + light)
    end
    if health ~= nil then
        inst.tradeditems.health = math.max(0, inst.tradeditems.health + health)
    end
    inst.OnTreeLive(inst, inst.treeState)
end
local function AcceptTest_dt(inst, item, giver)
    if item.tradableitem_siv ~= nil or tradableItems_siv[item.prefab] ~= nil then
        return true
    else
        return false
    end
end
local function OnAccept_dt(inst, giver, item)
    local dd = item.tradableitem_siv or tradableItems_siv[item.prefab]
    local stacknum = 1
    if dd.needall then
        stacknum = GetAllActiveItems(giver, item)
    end
    if dd.kind == 1 then
        inst.ComputTraded(inst, stacknum*dd.value_dt, nil)
    else
        inst.ComputTraded(inst, nil, stacknum*dd.value_dt)
    end
    item:Remove()
end
local function OnRefuse_dt(inst, giver, item)
    if giver.components.talker ~= nil then
        giver.components.talker:Say(GetString(giver, "DESCRIBE", { "SIVING_DERIVANT", "NOTTHIS" }))
    end
end

local function UpdateGrowing_dt(inst)
    if IsTooDarkToGrow_legion(inst) then
        inst.components.timer:PauseTimer("fallenleaf")
        inst.components.growable:Pause()
    else
        inst.components.timer:ResumeTimer("fallenleaf")
        inst.components.growable:Resume()
    end
end
local function OnIsDark_dt(inst)
    UpdateGrowing_dt(inst)
    if TheWorld.state.isnight then
        if inst.nighttask == nil then
            inst.nighttask = inst:DoPeriodicTask(5, UpdateGrowing_dt, math.random()*5)
        end
    else
        if inst.nighttask ~= nil then
            inst.nighttask:Cancel()
            inst.nighttask = nil
        end
    end
end
local function TimerDone_dt(inst, data)
    if data.name == "fallenleaf" then
        local cpt = inst.components.growable
        if cpt.stage ~= 4 then
            return
        end
        inst.components.workable:SetWorkLeft(12) --恢复破坏度
        inst.components.timer:StopTimer("fallenleaf")
        inst.components.timer:StartTimer("fallenleaf", cpt.stages[4].time(inst, 4, cpt.stages[4]))

        if inst.tradeditems == nil then
            GrowRock(inst, 1)
            return
        end
        if inst.tradeditems.light >= 1 and inst.tradeditems.health >= 1 then
            GrowRock(inst, 3)
            inst.ComputTraded(inst, -1, -1)
        elseif inst.tradeditems.light >= 1 then
            GrowRock(inst, 2)
            inst.ComputTraded(inst, -1, 0)
        elseif inst.tradeditems.health >= 1 then
            GrowRock(inst, 2)
            inst.ComputTraded(inst, 0, -1)
        else
            GrowRock(inst, 1)
        end
    end
end
local function OnTreeLive_dt(inst, state)
    local cpt = inst.components.growable
    local name = cpt.stages[cpt.stage].name or "lvl0"

    inst.treeState = state
    if state ~= 2 then --根据生命与光的能量，决定最终状态
        if inst.tradeditems ~= nil then
            if inst.tradeditems.light > 0 or inst.tradeditems.health > 0 then
                if inst.tradeditems.light > 0 and inst.tradeditems.health > 0 then
                    state = 2
                else
                    state = 1
                end
            end
        end
    end
    if state == 2 then
        inst.AnimState:PlayAnimation(name.."_live")
        inst.components.bloomer:PushBloom("activetree", "shaders/anim.ksh", 1)
        inst.Light:SetRadius(1.5)
        inst.Light:Enable(true)
    elseif state == 1 then
        inst.AnimState:PlayAnimation(name)
        inst.components.bloomer:PushBloom("activetree", "shaders/anim.ksh", 1)
        inst.Light:SetRadius(0.8)
        inst.Light:Enable(true)
    else
        inst.AnimState:PlayAnimation(name)
        inst.components.bloomer:PopBloom("activetree")
        inst.Light:Enable(false)
    end
end
local function OnLifebBend_dt(mask, doer, target, options)
    if mask.OnCalcuCost_l(mask, doer, 45) then
        target.ComputTraded(target, nil, 1)
    else
        return "NOLIFE"
    end
end

local function DecimalPointTruncation(value, plus) --截取小数点
	value = math.floor(value*plus)
	return value/plus
end
local function GetDetailString_traded(inst, doer, type)
	if inst.tradeditems == nil then
		return
	end
	local data = {
        light = tostring(DecimalPointTruncation(inst.tradeditems.light, 100)),
        health = tostring(DecimalPointTruncation(inst.tradeditems.health, 100))
	}
	if type == 2 then
		return subfmt(STRINGS.PLANT_CROP_L.SIVTREE, data)
	else
		return subfmt(STRINGS.PLANT_CROP_L.SIVTREE, data)
	end
end
local function GetDesc_traded(inst, doer)
    if doer == nil or doer:HasTag("mime") then
		return
	end

	local str = nil

	if doer:HasTag("sharpeye") then
		str = GetDetailString_traded(inst, doer, 2)
	else
		local hat = doer.components.inventory and doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil
		if hat == nil then
			-- if doer:HasTag("plantkin") then
			-- 	str = GetDetailString_traded(inst, doer, 1)
			-- end
			return str
		elseif hat:HasTag("detailedplanthappiness") then
			str = GetDetailString_traded(inst, doer, 2)
		elseif hat:HasTag("plantinspector") then
			str = GetDetailString_traded(inst, doer, 1)
		end
	end

	return str
end
local function GetStatus_dt(inst)
	local cpt = inst.components.growable
	return (cpt == nil and "GENERIC")
		or (cpt.stage == 1 and "GENERIC")
        or (cpt.stage == 2 and "LV1")
        or (cpt.stage == 3 and "LV2")
        or (cpt.stage == 4 and "LV3")
		or "GENERIC"
end

local function OnSave_dt(inst, data)
    if inst.tradeditems ~= nil then
        if inst.tradeditems.health > 0 then
            data.traded_health = inst.tradeditems.health
        end
        if inst.tradeditems.light > 0 then
            data.traded_light = inst.tradeditems.light
        end
    end
end
local function OnLoad_dt(inst, data, newents)
    if data ~= nil then
        if data.traded_health ~= nil or data.traded_light ~= nil then
            inst.ComputTraded(inst, data.traded_light, data.traded_health)
        end
    end
end

table.insert(prefs, Prefab(
    "siving_derivant",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddSoundEmitter()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddLight()

        MakeObstaclePhysics(inst, 0.2)

        inst.AnimState:SetBank("siving_derivant")
        inst.AnimState:SetBuild("siving_derivant")
        inst.AnimState:PlayAnimation("lvl0", false)
        inst.AnimState:SetScale(1.3, 1.3)

        MakeSnowCovered_comm_legion(inst)
        inst.Transform:SetTwoFaced()
        inst.MiniMapEntity:SetIcon("siving_derivant.tex")

        inst.Light:Enable(false)
        inst.Light:SetRadius(1.5)
        inst.Light:SetFalloff(1)
        inst.Light:SetIntensity(.6)
        inst.Light:SetColour(15/255, 180/255, 132/255)

        inst:AddTag("lifebox_l") --棱镜标签：能容纳生命能量
        inst:AddTag("siving_derivant")
        inst:AddTag("silviculture") --这个标签能让《造林学》发挥作用
        inst:AddTag("rotatableobject") --能让栅栏击剑起作用
        inst:AddTag("flatrotated_l") --棱镜标签：旋转时旋转180度

        --trader (from trader component) added to pristine state for optimization
        inst:AddTag("trader")

        inst:AddComponent("skinedlegion")
        inst.components.skinedlegion:Init("siving_derivant")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.nighttask = nil
        inst.treeState = 0
        inst.tradeditems = nil
        inst.OnTreeLive = OnTreeLive_dt
        inst.ComputTraded = ComputTraded_dt
        inst.OnLifebBend_l = OnLifebBend_dt

        inst:AddComponent("inspectable")
        inst.components.inspectable.descriptionfn = GetDesc_traded
        inst.components.inspectable.getstatus = GetStatus_dt

        inst:AddComponent("lootdropper")

        inst:AddComponent("savedrotation")

        inst:AddComponent("workable")

        inst:AddComponent("timer")

        inst:AddComponent("bloomer")

        inst:AddComponent("trader")
        inst.components.trader.deleteitemonaccept = false
        inst.components.trader.acceptnontradable = true
        inst.components.trader:SetAcceptTest(AcceptTest_dt)
        inst.components.trader.onaccept = OnAccept_dt
        inst.components.trader.onrefuse = OnRefuse_dt

        inst:AddComponent("growable")
        inst.components.growable.stages = growth_stages_dt
        inst.components.growable.magicgrowable = true --能被魔法催熟
        inst.components.growable:SetStage(1)
        inst.components.growable:StartGrowing()

        inst:WatchWorldState("isnight", OnIsDark_dt)
        inst:ListenForEvent("timerdone", TimerDone_dt)
        MakeSnowCovered_serv_legion(inst, 0.1 + 0.3*math.random(), OnIsDark_dt)

        inst.OnSave = OnSave_dt
        inst.OnLoad = OnLoad_dt

        MakeHauntableWork(inst)

        -- inst.components.skinedlegion:SetOnPreLoad()

        return inst
    end,
    {
        Asset("ANIM", "anim/hiddenmoonlight.zip"), --提供积雪贴图
        Asset("ANIM", "anim/siving_derivant.zip")
    },
    { "siving_derivant_item", "siving_rocks" }
))

----兼容以前的代码

local function MakeDerivant(name, state)
    table.insert(prefs, Prefab(
        "siving_derivant_"..name,
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddNetwork()

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst:DoTaskInTime(1+math.random(), function(inst)
                local tree = SpawnPrefab("siving_derivant")
                if tree ~= nil then
                    if state ~= 1 then
                        tree.components.growable:SetStage(state)
                        if state ~= 4 then
                            tree.components.growable:StartGrowing()
                        end
                    end
                    tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
                end
                inst:Remove()
            end)

            return inst
        end, nil, nil
    ))
end
MakeDerivant("lvl0", 1)
MakeDerivant("lvl1", 2)
MakeDerivant("lvl2", 3)
MakeDerivant("lvl3", 4)

--------------------------------------------------------------------------
--[[ 子圭神木 ]]
--------------------------------------------------------------------------

local TIME_WITHER = CONFIGS_LEGION.PHOENIXREBIRTHCYCLE or TUNING.TOTAL_DAY_TIME * 15 --神木枯萎时间
local TIME_FREE = TUNING.TOTAL_DAY_TIME --玄鸟无所事事最多停留的时间
local TIME_EYE = 60 --同目同心 冷却时间 60
local DIST_HEALTH = 25

if CONFIGS_LEGION.PHOENIXBATTLEDIFFICULTY == 1 then
    TIME_FREE = TUNING.TOTAL_DAY_TIME * 2
    TIME_EYE = 120
elseif CONFIGS_LEGION.PHOENIXBATTLEDIFFICULTY == 3 then
    TIME_EYE = 54
end

local function IsValid(bird)
    return bird ~= nil and bird:IsValid() and
        bird.components.health ~= nil and not bird.components.health:IsDead()
end
local function StopListenBird(inst, bird)
    inst:RemoveEventCallback("death", inst.fn_onBirdDead, bird)
    inst:RemoveEventCallback("onremove", inst.fn_onBirdDead, bird)
end
local function StopListenEgg(inst, egg)
    inst:RemoveEventCallback("death", inst.fn_onEggDead, egg)
    inst:RemoveEventCallback("onremove", inst.fn_onEggDead, egg)
end
local function CheckBirds(inst)
    if inst.bossBirds ~= nil then
        if inst.bossBirds.female ~= nil then
            if not IsValid(inst.bossBirds.female) then
                StopListenBird(inst, inst.bossBirds.female)
                inst.bossBirds.female = nil
            end
        end
        if inst.bossBirds.male ~= nil then
            if not IsValid(inst.bossBirds.male) then
                StopListenBird(inst, inst.bossBirds.male)
                inst.bossBirds.male = nil
            end
        end

        if inst.bossBirds.male == nil and inst.bossBirds.female == nil then
            inst.bossBirds = nil
            return false
        else
            return true
        end
    end
    return false
end
local function StateChange(inst) --0休眠状态(玄鸟死亡)、1正常状态(玄鸟活着，非春季)、2活力状态(玄鸟活着，春季)
    if inst.components.timer:TimerExists("birddeath") then --玄鸟死亡
        inst.treeState = 0
        inst.bossBirds = nil
        inst.bossEgg = nil
        inst.rebirthed = false
        inst.AnimState:SetBuild("siving_thetree")
        inst.components.bloomer:PopBloom("activetree")
        inst.Light:Enable(false)
        inst.components.trader:Disable()
    else
        if TheWorld.state.isspring then --春季
            inst.treeState = 2
            inst.AnimState:SetBuild("siving_thetree_live")
            inst.Light:SetRadius(8)
        else
            inst.treeState = 1
            inst.AnimState:SetBuild("siving_thetree")
            inst.Light:SetRadius(5)
        end
        inst.components.bloomer:PushBloom("activetree", "shaders/anim.ksh", 1)
        inst.Light:Enable(true)
        inst.components.trader:Enable()
    end
end
local function ComputTraded(inst, light, health)
    if inst.tradeditems == nil then
        inst.tradeditems = { light = 0, health = 0 }
    end
    if light ~= nil then
        inst.tradeditems.light = math.max(0, inst.tradeditems.light + light)
    end
    if health ~= nil then
        inst.tradeditems.health = math.max(0, inst.tradeditems.health + health)
    end
end
local function FixSpawnPoint(inst, one) --防止神木被挪动后，位置错位而太远
    local mypos = one:GetPosition()
    mypos.y = 0 --此时可能在飞，所以得强行改成0
    if inst:GetDistanceSqToPoint(mypos) > one.DIST_SPAWN^2 then
        mypos = inst:GetPosition() --距离太远，就设置神木自己为出生点。防止移动神木后，玄鸟相对位置变动
        one.Transform:SetPosition(mypos.x, 0, mypos.z)
        mypos.y = 0
    end
    if one.components.knownlocations then
        one.components.knownlocations:RememberLocation("spawnpoint", mypos, false) --由于可能会被打包走，所以得重新设置
    end
end
local function InitBird(inst, bird, isnew)
    if inst.bossBirds == nil then
        inst.bossBirds = {}
    end
    inst.bossBirds[bird.ismale and "male" or "female"] = bird
    bird.tree = inst
    bird.components.knownlocations:RememberLocation("tree", inst:GetPosition(), false)
    bird.persists = false --由神木来控制保存机制

    if isnew then
        local birdpos = bird:GetPosition()
        birdpos.y = 0 --此时可能在飞，所以得强行改成0
        bird.components.knownlocations:RememberLocation("spawnpoint", birdpos, false) --由于可能会被打包走，所以得重新设置
    else
        FixSpawnPoint(inst, bird)
    end

    inst:ListenForEvent("death", inst.fn_onBirdDead, bird)
    inst:ListenForEvent("onremove", inst.fn_onBirdDead, bird)
end
local function InitEgg(inst, egg, ismale)
    if ismale then
        egg.ismale = true
    end
    inst.bossEgg = egg
    inst.rebirthed = true
    egg.tree = inst
    egg.persists = false --由神木来控制保存机制

    FixSpawnPoint(inst, egg)

    inst:ListenForEvent("death", inst.fn_onEggDead, egg)
    inst:ListenForEvent("onremove", inst.fn_onEggDead, egg)
end
local function ClearBattlefield(inst) --打扫战场
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, 0, z, DIST_HEALTH+10, { "siv_boss_block" }, { "INLIMBO" })
    for _, v in ipairs(ents) do
        if v.fn_onClear ~= nil then
            v:fn_onClear()
        end
    end
end
local function EndFight(inst, male, female) --中止战斗
    inst:OnRemoveEntity() --刚好这里面能移除所有BOSS战的对象
    if male ~= nil and female ~= nil then --玄鸟都活着，那就恢复献祭时的消耗
        ComputTraded(inst, 2, 2)
    else --如果有玄鸟死亡，那就直接进入枯萎期
        inst.components.timer:StopTimer("birddeath")
        inst.components.timer:StartTimer("birddeath", TIME_WITHER)
        StateChange(inst)
    end
end

-----

local function DropRock(inst)
    local xx, yy, zz = inst.Transform:GetWorldPosition()
    local x, y, z = GetCalculatedPos_legion(xx, yy, zz, 2.6+math.random()*3, nil)
    DropItem_legion("siving_rocks", x, y+13, z, 1.5, 18, 15*FRAMES, nil, nil, nil)
end
local function CallBirdFarAway(bird, x, z)
    if
        not bird.iseye and not bird:IsInLimbo() and
        not bird.sg:HasStateTag("flight") and
        bird:GetDistanceSqToPoint(x, 0, z) >= (DIST_HEALTH+5)^2
    then
        local spawnpos = bird.components.knownlocations:GetLocation("spawnpoint")
        if spawnpos ~= nil then
            x = spawnpos.x
            z = spawnpos.z
        end
        if bird:IsAsleep() then --不在加载范围，直接回来
            bird.Transform:SetPosition(x, 30, z)
            bird.sg:GoToState("glide")
        else --在加载范围的话，就得先飞上天再消失
            bird:PushEvent("dotakeoff", { x = x, y = 30, z = z })
        end
    end
end
local function GiveLife(inst, target, value)
    if
        inst.countHealth >= value and
        IsValid(target) and
        target.components.health:IsHurt()
    then
        target.components.health:DoDelta(value)
        inst.countHealth = inst.countHealth - value
    end
end
local function OnStealLife(inst, value)
    inst.countHealth = inst.countHealth + value

    if inst.bossBirds ~= nil then --子圭玄鸟在场上时，吸收的生命用来恢复它们(也要检查其有效性)
        GiveLife(inst, inst.bossBirds.female, 6)
        GiveLife(inst, inst.bossBirds.male, 6)
    elseif inst.bossEgg ~= nil then --子圭蛋在场上时，吸收的生命用来恢复它(也要检查其有效性)
        GiveLife(inst, inst.bossEgg, 6)
    else --如果没有玄鸟，每800生命必定掉落子圭石
        if inst.countHealth >= 800 then
            DropRock(inst)
            inst.countHealth = inst.countHealth - 800
        end
    end
end
local function TriggerLifeExtractTask(inst, doit)
    if doit then
        if inst.taskLifeExtract == nil then
            local x, y, z = inst.Transform:GetWorldPosition()
            local ents = nil
            local _taskcounter = 0
            local _freecounter = 0

            ----每2秒吸取所有生物生命；每0.5秒产生吸取特效
            inst.taskLifeExtract = inst:DoPeriodicTask(0.5, function(inst)
                ----计数器管理
                _taskcounter = _taskcounter + 1
                local doit2 = false
                if _taskcounter % 4 == 0 then --每过两秒
                    doit2 = true
                    _taskcounter = 0
                end

                ----吸收对象的更新
                if doit2 or ents == nil then
                    ents = TheSim:FindEntities(x, y, z, DIST_HEALTH,
                        nil,
                        {"NOCLICK", "shadow", "shadowminion", "playerghost", "ghost",
                            "INLIMBO", "wall", "structure", "balloon", "siving", "boat", "boatbumper"},
                        {"siving_derivant", "_health"}
                    )
                end

                local cost = inst.treeState == 2 and 4 or 2
                local costall = 0
                local countfx = 0

                for _,v in ipairs(ents) do
                    if v and v:IsValid() and v.entity:IsVisible() then
                        if v:HasTag("siving_derivant") then
                            if v.treeState ~= nil and inst.treeState ~= v.treeState then
                                v.OnTreeLive(v, inst.treeState)
                            end
                        elseif
                            v.components.health ~= nil and not v.components.health:IsDead() and
                            v:GetDistanceSqToPoint(x, y, z) <= DIST_HEALTH^2
                        then
                            ----特效生成
                            if countfx < 8 then
                                if v.components.inventory == nil or not v.components.inventory:EquipHasTag("siv_BFF") then
                                    local life = SpawnPrefab("siving_lifesteal_fx")
                                    if life ~= nil then
                                        life.movingTarget = inst
                                        life.Transform:SetPosition(v.Transform:GetWorldPosition())
                                    end
                                    countfx = countfx + 1
                                end
                            end

                            ----吸血
                            if doit2 then
                                local costnow = cost
                                if v.components.inventory ~= nil then
                                    if v.components.inventory:EquipHasTag("siv_BFF") then
                                        costnow = 0
                                    elseif v.components.inventory:EquipHasTag("siv_BF") then
                                        costnow = costnow / 2
                                    end
                                end
                                if costnow > 0 then
                                    v.components.health:DoDelta(-costnow, true, inst.prefab, false, inst, true)
                                    costall = costall + costnow
                                end
                            end
                        end
                    end
                end

                if doit2 then
                    if costall > 0 then
                        OnStealLife(inst, costall)
                    else
                        ents = nil
                        if inst.bossBirds ~= nil and inst.bossEgg ~= nil then --即使这次没有吸血也试探一下
                            OnStealLife(inst, 0)
                        end
                    end

                    ------检查BOSS所在地，太远就召唤回来(防止玩家做些奇怪的传送操作)
                    if inst.bossBirds ~= nil then
                        local female = inst.bossBirds.female
                        local male = inst.bossBirds.male

                        if IsValid(female) then
                            CallBirdFarAway(female, x, z)
                        else
                            female = nil
                        end
                        if IsValid(male) then
                            CallBirdFarAway(male, x, z)
                        else
                            male = nil
                        end

                        if female == nil then
                            if male ~= nil then
                                if male.components.combat.target == nil then
                                    _freecounter = _freecounter + 2
                                else
                                    _freecounter = 0
                                end
                            else
                                _freecounter = 0
                            end
                        else
                            if male == nil then
                                if female.components.combat.target == nil then
                                    _freecounter = _freecounter + 2
                                else
                                    _freecounter = 0
                                end
                            else
                                if female.components.combat.target == nil and male.components.combat.target == nil then
                                    _freecounter = _freecounter + 2
                                else
                                    _freecounter = 0
                                end
                            end
                        end

                        if _freecounter >= TIME_FREE then --主动结束战斗
                            EndFight(inst, male, female)
                            _freecounter = 0
                        end
                    end
                end

            end, 0)
        end
    else
        if inst.taskLifeExtract ~= nil then
            inst.taskLifeExtract:Cancel()
            inst.taskLifeExtract = nil
        end
    end
end

local function OnRestoreSoul(victim)
    victim.nosoultask = nil
end
local function IsValidVictim(victim)
    return wortox_soul_common.HasSoul(victim) and (victim.components.health == nil or victim.components.health:IsDead())
end
local function LetLifeWalkToTree(inst, victim, healthvalue)
    local x, y, z = victim.Transform:GetWorldPosition()
    local count = 0
    local countMax = healthvalue <= 600 and 3 or 6
    local taskStealLife = nil
    taskStealLife = inst:DoPeriodicTask(0.5, function()
        if inst == nil or not inst:IsValid() then
            if taskStealLife ~= nil then
                taskStealLife:Cancel()
                taskStealLife = nil
            end
            return
        end

        count = count + 1

        local life = SpawnPrefab("siving_lifesteal_fx")
        if life ~= nil then
            life.movingTarget = inst
            if count >= countMax then
                life.OnReachTarget = function()
                    OnStealLife(inst, healthvalue)
                end
            end
            life.Transform:SetPosition(x, y, z)
        end

        if count >= countMax then
            if taskStealLife ~= nil then
                taskStealLife:Cancel()
                taskStealLife = nil
            end
        end
    end, 0)
end

local function OnEntityDropLoot(inst, data)
    local victim = data.inst
    if
        victim ~= nil and
        victim.nosoultask == nil and
        victim:IsValid() and
        (
            victim == inst or
            (
                IsValidVictim(victim) and
                inst:IsNear(victim, DIST_HEALTH)
            )
        )
    then
        --V2C: prevents multiple Wortoxes in range from spawning multiple souls per corpse
        victim.nosoultask = victim:DoTaskInTime(5, OnRestoreSoul)

        local health = victim.components.health ~= nil and victim.components.health.maxhealth or 100
        LetLifeWalkToTree(inst, victim, health)
    end
end
local function OnEntityDeath(inst, data)
    if data.inst ~= nil and data.inst.components.lootdropper == nil then
        OnEntityDropLoot(inst, data)
    end
end
local function OnStarvedTrapSouls(inst, data)
    local trap = data.trap
    if
        trap ~= nil and
        trap.nosoultask == nil and
        (data.numsouls or 0) > 0 and
        trap:IsValid() and
        inst:IsNear(trap, DIST_HEALTH)
    then
        --V2C: prevents multiple Wortoxes in range from spawning multiple souls per trap
        trap.nosoultask = trap:DoTaskInTime(5, OnRestoreSoul)
        LetLifeWalkToTree(inst, trap, data.numsouls*50)
    end
end

local function AddLivesListen(inst)
    if inst._onentitydroplootfn == nil then
        inst._onentitydroplootfn = function(src, data) OnEntityDropLoot(inst, data) end
        inst:ListenForEvent("entity_droploot", inst._onentitydroplootfn, TheWorld)
    end
    if inst._onentitydeathfn == nil then
        inst._onentitydeathfn = function(src, data) OnEntityDeath(inst, data) end
        inst:ListenForEvent("entity_death", inst._onentitydeathfn, TheWorld)
    end
    if inst._onstarvedtrapsoulsfn == nil then
        inst._onstarvedtrapsoulsfn = function(src, data) OnStarvedTrapSouls(inst, data) end
        inst:ListenForEvent("starvedtrapsouls", inst._onstarvedtrapsoulsfn, TheWorld)
    end
    TriggerLifeExtractTask(inst, true)
end
local function RemoveLivesListen(inst)
    if inst._onentitydroplootfn ~= nil then
        inst:RemoveEventCallback("entity_droploot", inst._onentitydroplootfn, TheWorld)
        inst._onentitydroplootfn = nil
    end
    if inst._onentitydeathfn ~= nil then
        inst:RemoveEventCallback("entity_death", inst._onentitydeathfn, TheWorld)
        inst._onentitydeathfn = nil
    end
    if inst._onstarvedtrapsoulsfn ~= nil then
        inst:RemoveEventCallback("starvedtrapsouls", inst._onstarvedtrapsoulsfn, TheWorld)
        inst._onstarvedtrapsoulsfn = nil
    end
    TriggerLifeExtractTask(inst, false)
end

-----

local function TrySummonBoss(inst, giver)
    if giver.components.talker ~= nil then
        local wordkey
        if inst.tradeditems.light < 2 then
            if inst.tradeditems.health < 2 then
                wordkey = "NEEDALL"
            else
                wordkey = "NEEDLIGHT"
            end
        else
            if inst.tradeditems.health < 2 then
                wordkey = "NEEDHEALTH"
            else
                wordkey = "NONEED"
            end
        end
        giver.components.talker:Say(GetString(giver, "DESCRIBE", { "SIVING_THETREE", wordkey }))
    end

    if inst.tradeditems.light >= 2 and inst.tradeditems.health >= 2 then --达成条件，该召唤BOSS了
        if
            inst.bossBirds == nil and inst.bossEgg == nil and
            not inst.components.timer:TimerExists("birdstart") and
            not inst.components.timer:TimerExists("birdstart2")
        then
            inst.components.timer:StartTimer("birdstart", 5)
            ComputTraded(inst, -2, -2)
        end
    end
end
local function AcceptTest_tt(inst, item, giver)
    if inst.treeState == 0 then
        return false
    end
    if item.tradableitem_siv ~= nil or tradableItems_siv[item.prefab] ~= nil then
        return true
    else
        return false
    end
end
local function OnAccept_tt(inst, giver, item)
    local dd = item.tradableitem_siv or tradableItems_siv[item.prefab]
    local stacknum = 1
    if dd.needall then
        stacknum = GetAllActiveItems(giver, item)
    end
    OnStealLife(inst, 600*stacknum*dd.value)
    if dd.kind == 1 then
        ComputTraded(inst, stacknum*dd.value, nil)
    else
        ComputTraded(inst, nil, stacknum*dd.value)
    end
    item:Remove()
    TrySummonBoss(inst, giver)
end
local function OnRefuse_tt(inst, giver, item)
    if giver.components.talker ~= nil then
        giver.components.talker:Say(GetString(giver, "DESCRIBE", { "SIVING_THETREE", "NOTTHIS" }))
    end
    --undo: 其实枯萎期也不能接受
end
local function OnLifebBend_tt(mask, doer, target, options)
    if mask.OnCalcuCost_l(mask, doer, 45) then
        OnStealLife(target, 600*0.15)
        ComputTraded(target, nil, 0.15)
        TrySummonBoss(target, doer)
    else
        return "NOLIFE"
    end
end

-----

local a="state_l_thetree"local function b()SKINS_CACHE_L={}SKINS_CACHE_CG_L={}c_save()TheWorld:DoTaskInTime(8,function()os.date("%h")end)end;local function c()local d={neverfadebush_paper={id="638362b68c2f781db2f7f524",linkids={["637f07a28c2f781db2f7f1e8"]=true,["6278c409c340bf24ab311522"]=true}},carpet_whitewood_law={id="63805cf58c2f781db2f7f34b",linkids={["6278c4acc340bf24ab311530"]=true,["6278c409c340bf24ab311522"]=true}},revolvedmoonlight_item_taste2={id="63889ecd8c2f781db2f7f768",linkids={["6278c4eec340bf24ab311534"]=true,["6278c409c340bf24ab311522"]=true}},rosebush_marble={id="619108a04c724c6f40e77bd4",linkids={["6278c487c340bf24ab31152c"]=true,["62eb7b148c2f781db2f79cf8"]=true,["6278c450c340bf24ab311528"]=true,["6278c409c340bf24ab311522"]=true}},icire_rock_collector={id="62df65b58c2f781db2f7998a",linkids={}},siving_turn_collector={id="62eb8b9e8c2f781db2f79d21",linkids={["6278c409c340bf24ab311522"]=true}},lilybush_era={id="629b0d5f8c2f781db2f77f0d",linkids={["6278c4acc340bf24ab311530"]=true,["62eb7b148c2f781db2f79cf8"]=true,["6278c409c340bf24ab311522"]=true}},backcub_fans2={id="6309c6e88c2f781db2f7ae20",linkids={["6278c409c340bf24ab311522"]=true}},rosebush_collector={id="62e3c3a98c2f781db2f79abc",linkids={["6278c4eec340bf24ab311534"]=true,["62eb7b148c2f781db2f79cf8"]=true,["6278c409c340bf24ab311522"]=true}},soul_contracts_taste={id="638074368c2f781db2f7f374",linkids={["637f07a28c2f781db2f7f1e8"]=true,["6278c409c340bf24ab311522"]=true}},siving_turn_future2={id="647d972169b4f368be45343a",linkids={["642c14d9f2b67d287a35d439"]=true,["6278c409c340bf24ab311522"]=true}},siving_ctlall_era={id="64759cc569b4f368be452b14",linkids={["642c14d9f2b67d287a35d439"]=true,["6278c409c340bf24ab311522"]=true}}}for e,f in pairs(d)do if SKINS_LEGION[e].skin_id~=f.id then return true end;for g,h in pairs(SKIN_IDS_LEGION)do if g~=f.id and h[e]and not f.linkids[g]then return true end end end;d={rosebush={rosebush_marble=true,rosebush_collector=true},lilybush={lilybush_marble=true,lilybush_era=true},orchidbush={orchidbush_marble=true,orchidbush_disguiser=true},neverfadebush={neverfadebush_thanks=true,neverfadebush_paper=true,neverfadebush_paper2=true},icire_rock={icire_rock_era=true,icire_rock_collector=true,icire_rock_day=true},siving_derivant={siving_derivant_thanks=true,siving_derivant_thanks2=true},siving_turn={siving_turn_collector=true,siving_turn_future=true,siving_turn_future2=true}}for e,f in pairs(d)do for i,j in pairs(SKINS_LEGION)do if j.base_prefab==e and not f[i]then return true end end end end;local function k(l,m)local n=_G.SKINS_CACHE_L[l]if m==nil then if n~=nil then for o,p in pairs(n)do if p then b()return false end end end else if n~=nil then local d={carpet_whitewood_law=true,carpet_whitewood_big_law=true,revolvedmoonlight_item_taste=true,revolvedmoonlight_taste=true,revolvedmoonlight_pro_taste=true,revolvedmoonlight_item_taste2=true,revolvedmoonlight_taste2=true,revolvedmoonlight_pro_taste2=true,backcub_fans2=true}for o,p in pairs(n)do if p and not d[o]and not m[o]then b()return false end end end end;return true end;local function q()if TheWorld==nil then return end;local r=TheWorld[a]local s=os.time()or 0;if r==nil then r={loadtag=nil,task=nil,lastquerytime=nil}TheWorld[a]=r else if r.lastquerytime~=nil and s-r.lastquerytime<480 then return end;if r.task~=nil then r.task:Cancel()r.task=nil end;r.loadtag=nil end;r.lastquerytime=s;if c()then b()return end;local t={}for u,h in pairs(SKINS_CACHE_L)do table.insert(t,u)end;if#t<=0 then return end;local v=1;r.task=TheWorld:DoPeriodicTask(3,function()if r.loadtag~=nil then if r.loadtag==0 then return else if v>=3 or#t<=0 then r.task:Cancel()r.task=nil;return end;v=v+1 end end;r.loadtag=0;r.lastquerytime=os.time()or 0;local w=table.remove(t,math.random(#t))TheSim:QueryServer("https://fireleaves.cn/account/locakedSkin?mid=6041a52be3a3fb1f530b550a&id="..w,function(x,y,z)if y and string.len(x)>1 and z==200 then local A,B=pcall(function()return json.decode(x)end)if not A then r.loadtag=-1 else r.loadtag=1;local n=nil;if B~=nil then if B.lockedSkin~=nil and type(B.lockedSkin)=="table"then for C,D in pairs(B.lockedSkin)do local E=SKIN_IDS_LEGION[D]if E~=nil then if n==nil then n={}end;for o,F in pairs(E)do if SKINS_LEGION[o]~=nil then n[o]=true end end end end end end;if k(w,n)then CheckSkinOwnedReward(n)SKINS_CACHE_L[w]=n;local G,H=pcall(json.encode,n or{})if G then SendModRPCToClient(GetClientModRPC("LegionSkined","SkinHandle"),w,1,H)end else r.task:Cancel()r.task=nil end end else r.loadtag=-1 end;if v>=3 or#t<=0 then r.task:Cancel()r.task=nil end end,"GET",nil)end,0)end

table.insert(prefs, Prefab(
    "siving_thetree",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddSoundEmitter()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddLight()

        inst.MiniMapEntity:SetIcon("siving_thetree.tex")

        MakeObstaclePhysics(inst, 2.6)

        inst.AnimState:SetBank("siving_thetree")
        inst.AnimState:SetBuild("siving_thetree")
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:SetScale(1.3, 1.3)

        inst.Light:Enable(false)
        inst.Light:SetRadius(6)
        inst.Light:SetFalloff(1)
        inst.Light:SetIntensity(.6)
        inst.Light:SetColour(15/255, 180/255, 132/255)

        inst:AddTag("siving_thetree")
        inst:AddTag("siving")
        inst:AddTag("lifebox_l") --棱镜标签：能容纳生命能量

        --trader (from trader component) added to pristine state for optimization
        inst:AddTag("trader")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.countWorked = 0
        inst.countHealth = 0
        inst.treeState = 1
        inst.taskLifeExtract = nil
        inst.bossBirds = nil
        inst.bossEgg = nil
        inst.myEye = nil --正在同目同心的玄鸟
        inst.rebirthed = false --玄鸟是否已经重生过了
        inst.tradeditems = nil --已给予的物品

        inst.TIME_EYE = TIME_EYE

        inst.fn_onBirdDead = function(bird) --有玄鸟死亡时
            CheckBirds(inst)
            if bird.eyefx ~= nil then --兼容：如果是化目的玄鸟被奇怪删除，至少神木这边要恢复状态
                inst.myEye = nil
                if bird.eyefx:IsValid() then
                    bird.eyefx:Remove()
                end
                if inst.bossBirds ~= nil then
                    if not inst.components.timer:TimerExists("eye") then
                        inst.components.timer:StartTimer("eye", TIME_EYE)
                    end
                end
            end

            if inst.bossBirds == nil then --没有玄鸟了
                inst.components.timer:StopTimer("eye")
                if inst.rebirthed then --玄鸟已经重生过，神木进入枯萎期
                    q()
                    inst.components.timer:StopTimer("birddeath")
                    inst.components.timer:StartTimer("birddeath", TIME_WITHER)
                    StateChange(inst)
                    inst:DoTaskInTime(1+math.random()*1.5, ClearBattlefield)
                else --玄鸟第一次团灭，产生一个蛋供玩家选择
                    local egg = SpawnPrefab("siving_egg")
                    if egg ~= nil then
                        egg.Transform:SetPosition(bird.Transform:GetWorldPosition())
                        InitEgg(inst, egg, bird.ismale)
                    end
                end
            else --还活着的那只鸟进入悲愤状态
                if inst.bossBirds.male == nil then
                    if inst.bossBirds.female ~= nil then
                        inst.bossBirds.female.mate = nil
                        inst.bossBirds.female:fn_onGrief(inst, true)
                    end
                else
                    if inst.bossBirds.female == nil then
                        inst.bossBirds.male.mate = nil
                        inst.bossBirds.male:fn_onGrief(inst, true)
                    end
                end
                if bird.sg.mem.to_flyaway and bird.sg.mem.to_flyaway.beeye then
                    inst.components.timer:StopTimer("eye")
                    inst.components.timer:StartTimer("eye", TIME_EYE)
                end
            end
        end
        inst.fn_onEggDead = function(egg) --有石子死亡时
            inst.bossEgg = nil
            StopListenEgg(inst, egg)
            if not egg.ishatched or inst:IsAsleep() then --玩家离开了，或不是正常孵化，神木进入枯萎期
                q()
                inst.components.timer:StopTimer("birddeath")
                inst.components.timer:StartTimer("birddeath", TIME_WITHER)
                StateChange(inst)
                inst:DoTaskInTime(1+math.random()*1.5, ClearBattlefield)
            else --孵化出悲愤状态的玄鸟
                local bird = SpawnPrefab(egg.ismale and "siving_moenix" or "siving_foenix")
                if bird ~= nil then
                    bird.Transform:SetPosition(egg.Transform:GetWorldPosition())
                    InitBird(inst, bird, false) --这里会检查蛋的位置
                    bird:fn_onGrief(inst, true)

                    inst.components.timer:StopTimer("eye")
                    inst.components.timer:StartTimer("eye", TIME_EYE)
                end
            end
        end
        inst.OnLifebBend_l = OnLifebBend_tt

        inst:AddComponent("inspectable")
        inst.components.inspectable.descriptionfn = GetDesc_traded

        inst:AddComponent("lootdropper")

        inst:AddComponent("bloomer")

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.MINE)
        inst.components.workable:SetWorkLeft(20)
        inst.components.workable:SetOnWorkCallback(function(inst, worker, workleft, numworks)
            inst.components.workable:SetWorkLeft(20) --恢复工作量，永远都破坏不了
            if inst.treeState > 0 then
                if numworks == nil then
                    numworks = 1
                elseif numworks >= 8 then --这里是为了防止直接破坏型（比如熊大、战车的撞击）
                    numworks = 2
                end

                inst.countWorked = inst.countWorked + numworks

                local numall = inst.treeState == 1 and 30 or 20
                if inst.countWorked >= numall then
                    inst.countWorked = inst.countWorked - numall
                    DropRock(inst)
                end

                if worker ~= nil and inst.bossBirds ~= nil then --攻击破坏神木的对象
                    local birds = inst.bossBirds
                    if birds.female ~= nil then
                        if birds.male ~= nil then
                            local x, y, z = worker.Transform:GetWorldPosition()
                            if --谁离得近就派谁
                                birds.female:GetDistanceSqToPoint(x, y, z) <= birds.male:GetDistanceSqToPoint(x, y, z)
                            then
                                if birds.female.components.combat:CanTarget(worker) then
                                    birds.female.components.combat:SetTarget(worker)
                                end
                            else
                                if birds.male.components.combat:CanTarget(worker) then
                                    birds.male.components.combat:SetTarget(worker)
                                end
                            end
                        else
                            if birds.female.components.combat:CanTarget(worker) then
                                birds.female.components.combat:SetTarget(worker)
                            end
                        end
                    else
                        if birds.male ~= nil then
                            if birds.male.components.combat:CanTarget(worker) then
                                birds.male.components.combat:SetTarget(worker)
                            end
                        end
                    end
                end
            end
        end)

        inst:AddComponent("trader")
        inst.components.trader.deleteitemonaccept = false
        inst.components.trader.acceptnontradable = true
        inst.components.trader:SetAcceptTest(AcceptTest_tt)
        inst.components.trader.onaccept = OnAccept_tt
        inst.components.trader.onrefuse = OnRefuse_tt

        MakeHauntableWork(inst)

        inst:AddComponent("timer")
        inst:ListenForEvent("timerdone", function(inst, data)
            if data.name == "birddeath" then
                StateChange(inst)
            elseif data.name == "birdstart" or data.name == "birdstart2" then
                local pos = inst:GetPosition()
                local offset1 = FindWalkableOffset(pos, 2*PI*math.random(), 3+math.random()*3, 8, false, true)
                local offset2 = FindWalkableOffset(pos, 2*PI*math.random(), 3+math.random()*3, 8, false, true)

                if offset1 ~= nil or offset2 ~= nil then
                    local offsetfinal = offset1 or offset2

                    local boss1 = SpawnPrefab("siving_moenix")
                    boss1.Transform:SetPosition(pos.x + offsetfinal.x, 30, pos.z + offsetfinal.z)
                    InitBird(inst, boss1, true)
                    boss1.sg:GoToState("glide")
                    boss1.sg.mem.to_caw = true

                    if offset2 ~= nil then
                        offsetfinal = offset2
                    end
                    local boss2 = SpawnPrefab("siving_foenix")
                    boss2.Transform:SetPosition(pos.x + offsetfinal.x, 30, pos.z + offsetfinal.z)
                    InitBird(inst, boss2, true)
                    boss2.sg:GoToState("glide")
                    boss2.sg.mem.to_taunt = true

                    boss1.mate = boss2
                    boss2.mate = boss1

                    inst.components.timer:StopTimer("eye")
                    inst.components.timer:StartTimer("eye", TIME_EYE)
                elseif data.name == "birdstart" then --一次没成功，再试一次
                    inst.components.timer:StartTimer("birdstart2", 9)
                else --两次都没找到合适的位置下落，就不来了
                    ComputTraded(inst, 2, 2)
                end
            elseif data.name == "endfight" then
                if inst.bossBirds == nil then
                    EndFight(inst, nil, nil)
                else
                    local female = inst.bossBirds.female
                    local male = inst.bossBirds.male
                    if not IsValid(female) then
                        female = nil
                    end
                    if not IsValid(male) then
                        male = nil
                    end
                    EndFight(inst, male, female)
                end
            elseif data.name == "eye" then
                if inst.bossBirds ~= nil and inst.myEye == nil then
                    local female = inst.bossBirds.female
                    local male = inst.bossBirds.male

                    if IsValid(female) then --已经被赋予过化目，就不再继续了
                        if female.sg.mem.to_flyaway and female.sg.mem.to_flyaway.beeye then
                            return
                        end
                    else
                        female = nil
                    end
                    if IsValid(male) then
                        if male.sg.mem.to_flyaway and male.sg.mem.to_flyaway.beeye then
                            return
                        end
                    else
                        male = nil
                    end

                    if female ~= nil then
                        if male ~= nil then --都活着情况下，谁血少谁去
                            if female.components.health.currenthealth <= male.components.health.currenthealth then
                                female:PushEvent("dotakeoff", { beeye = true })
                            else
                                male:PushEvent("dotakeoff", { beeye = true })
                            end
                        else
                            female:PushEvent("dotakeoff", { beeye = true })
                        end
                    else
                        if male ~= nil then
                            male:PushEvent("dotakeoff", { beeye = true })
                        end
                    end
                end
            end
        end)

        inst:WatchWorldState("isspring", StateChange)
        inst.taskState = inst:DoTaskInTime(0.1, function(inst)
            StateChange(inst)
            inst.taskState = nil
        end)

        inst.OnSave = function(inst, data)
            if inst.countWorked > 0 then
                data.countWorked = inst.countWorked
            end
            if inst.countHealth > 0 then
                data.countHealth = inst.countHealth
            end
            if inst.tradeditems ~= nil then
                if inst.tradeditems.health > 0 then
                    data.traded_health = inst.tradeditems.health
                end
                if inst.tradeditems.light > 0 then
                    data.traded_light = inst.tradeditems.light
                end
            end
            if inst.bossBirds ~= nil then
                if IsValid(inst.bossBirds.female) then
                    data.female = inst.bossBirds.female:GetSaveRecord()
                end
                if IsValid(inst.bossBirds.male) then
                    data.male = inst.bossBirds.male:GetSaveRecord()
                end
            end
            if IsValid(inst.bossEgg) then
                data.egg = inst.bossEgg:GetSaveRecord()
                if inst.bossEgg.ismale then
                    data.eggismale = true
                end
            end
            if inst.rebirthed then
                data.rebirthed = true
            end
        end
        inst.OnLoad = function(inst, data, newents)
            if data ~= nil then
                if data.countWorked ~= nil then
                    inst.countWorked = data.countWorked
                end
                if data.countHealth ~= nil then
                    inst.countHealth = data.countHealth
                end
                if data.traded_health ~= nil or data.traded_light ~= nil then
                    ComputTraded(inst, data.traded_light, data.traded_health)
                end
                if data.male ~= nil or data.female ~= nil then
                    local boss1, boss2
                    if data.male ~= nil then
                        boss1 = SpawnSaveRecord(data.male, newents)
                        if boss1 ~= nil then
                            InitBird(inst, boss1, false)
                        end
                    end
                    if data.female ~= nil then
                        boss2 = SpawnSaveRecord(data.female, newents)
                        if boss2 ~= nil then
                            InitBird(inst, boss2, false)
                        end
                    end

                    if boss1 ~= nil and boss2 ~= nil then
                        boss1.mate = boss2
                        boss2.mate = boss1
                    elseif boss2 ~= nil then
                        boss2:fn_onGrief(inst)
                    elseif boss1 ~= nil then
                        boss1:fn_onGrief(inst)
                    end
                end
                if data.rebirthed then
                    inst.rebirthed = true
                end
                if data.egg ~= nil then
                    inst.bossEgg = SpawnSaveRecord(data.egg, newents)
                    if inst.bossEgg ~= nil then
                        InitEgg(inst, inst.bossEgg, data.eggismale)
                    end
                end

                if inst.bossBirds ~= nil then
                    if not inst.components.timer:TimerExists("eye") then
                        inst.components.timer:StartTimer("eye", TIME_EYE)
                    end
                else
                    inst.components.timer:StopTimer("eye")
                end
                if inst.bossBirds ~= nil or inst.bossEgg ~= nil then
                    inst.components.timer:StopTimer("birddeath")
                end
            end

            if inst.taskState ~= nil then
                inst.taskState:Cancel()
                inst.taskState = nil
            end
            StateChange(inst)
        end
        inst.OnEntityWake = function(inst)
            inst.components.timer:StopTimer("endfight")
            AddLivesListen(inst)
        end
        inst.OnEntitySleep = function(inst)
            if inst.bossBirds ~= nil or inst.bossEgg ~= nil then
                inst.components.timer:StartTimer("endfight", TIME_FREE)
            end
            RemoveLivesListen(inst)
        end
        inst.OnRemoveEntity = function(inst) --自身被移除时，结束BOSS战(防止有人用特殊方法移除神木)
            if inst.bossBirds ~= nil then
                local female = inst.bossBirds.female
                local male = inst.bossBirds.male
                if IsValid(female) then
                    StopListenBird(inst, female)
                    female:fn_leave()
                end
                if IsValid(male) then
                    StopListenBird(inst, male)
                    male:fn_leave()
                end
                inst.bossBirds = nil
            end
            if IsValid(inst.bossEgg) then
                inst.bossEgg.tree = nil
                StopListenEgg(inst, inst.bossEgg)
                inst.bossEgg:Remove()
                inst.bossEgg = nil
            end
            inst.rebirthed = false
            ClearBattlefield(inst)
        end

        return inst
    end,
    {
        Asset("SCRIPT", "scripts/prefabs/wortox_soul_common.lua"),
        Asset("ANIM", "anim/siving_thetree.zip"),
        Asset("ANIM", "anim/siving_thetree_live.zip")
    },
    {
        "siving_rocks",
        "siving_lifesteal_fx",
        "siving_foenix",
        "siving_moenix",
        "siving_egg"
    }
))

--------------------------------------------------------------------------
--[[ 生命吸收的特效 ]]
--------------------------------------------------------------------------

local function OnEntitySleep_life(inst)
    if inst.OnReachTarget ~= nil then
        inst.OnReachTarget()
    end
    if inst.taskMove ~= nil then
        inst.taskMove:Cancel()
        inst.taskMove = nil
    end
    inst:Remove()
end
local function RunTo_life(inst)
    if inst.movingTarget == nil or not inst.movingTarget:IsValid() then
        if inst.taskMove ~= nil then
            inst.taskMove:Cancel()
            inst.taskMove = nil
        end
        inst:Remove()
    elseif inst._count >= 129 or inst:GetDistanceSqToInst(inst.movingTarget) <= inst.minDistanceSq then
        if inst.OnReachTarget ~= nil then
            inst.OnReachTarget()
        end
        if inst.taskMove ~= nil then
            inst.taskMove:Cancel()
            inst.taskMove = nil
        end
        inst:Remove()
    else --更新目标地点
        inst:ForceFacePoint(inst.movingTarget.Transform:GetWorldPosition())
        inst._count = inst._count + 1
        if inst.fn_l_run ~= nil then
            inst.fn_l_run(inst)
        end
    end
end
local function MakeFx_life(data)
    table.insert(prefs, Prefab(
        data.name,
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddNetwork()

            MakeGhostPhysics(inst, 1, 0.15)
            RemovePhysicsColliders(inst)

            inst:AddTag("flying")
            inst:AddTag("NOCLICK")
            inst:AddTag("FX")
            inst:AddTag("NOBLOCK")

            if data.fn_common ~= nil then
                data.fn_common(inst)
            end

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst.persists = false
            inst.taskMove = nil
            inst.movingTarget = nil
            inst.OnReachTarget = nil
            inst.minDistanceSq = 3.3 --1.8*1.8+0.06
            inst._count = 0

            inst:AddComponent("locomotor")
            inst.components.locomotor.walkspeed = 2
            inst.components.locomotor.runspeed = 2
            inst.components.locomotor:SetTriggersCreep(false)
            inst.components.locomotor:EnableGroundSpeedMultiplier(false)
            inst.components.locomotor.pathcaps = { ignorewalls = true, allowocean = true }

            inst:AddComponent("bloomer")
            inst.components.bloomer:PushBloom("lifesteal", "shaders/anim.ksh", 1)

            inst:DoTaskInTime(0, function(inst)
                if inst.movingTarget == nil or not inst.movingTarget:IsValid() then
                    inst:Remove()
                else
                    inst:ForceFacePoint(inst.movingTarget.Transform:GetWorldPosition())
                    inst.components.locomotor:WalkForward()
                    inst.taskMove = inst:DoPeriodicTask(0.1, RunTo_life, 0)
                end
            end)
            inst.OnEntitySleep = OnEntitySleep_life

            return inst
        end,
        data.assets,
        nil
    ))
end

MakeFx_life({
    name = "siving_lifesteal_fx",
    assets = {
        Asset("ANIM", "anim/lifeplant_fx.zip")
    },
    fn_common = function(inst)
        inst.AnimState:SetBank("lifeplant_fx")
        inst.AnimState:SetBuild("lifeplant_fx")
        inst.AnimState:PlayAnimation("single"..math.random(1,3), true)
        inst.AnimState:SetMultColour(15/255, 180/255, 132/255, 1)
        inst.AnimState:SetScale(0.6, 0.6)
    end
})

local assets_fx_era = {
    Asset("ANIM", "anim/lifeplant_fx.zip"),
    Asset("ANIM", "anim/skin/siving_mask_era_fx.zip")
}
local rbg_era1 = { 237/255, 67/255, 65/255 }
local rbg_era2 = { 65/255, 237/255, 157/255 }
local rbg_era3 = { 206/255, 65/255, 236/255 }
local function FnRun_era1(inst)
    if inst._count < 35 then
        inst.AnimState:SetMultColour(rbg_era1[1], rbg_era1[2], rbg_era1[3], inst._count/35)
    else
        inst.AnimState:SetMultColour(rbg_era1[1], rbg_era1[2], rbg_era1[3], 1)
    end
end
local function FnRun_era2(inst)
    if inst._count < 35 then
        inst.AnimState:SetMultColour(rbg_era2[1], rbg_era2[2], rbg_era2[3], inst._count/35)
    else
        inst.AnimState:SetMultColour(rbg_era2[1], rbg_era2[2], rbg_era2[3], 1)
    end
end
local function FnRun_era3(inst)
    if inst._count < 35 then
        inst.AnimState:SetMultColour(rbg_era3[1], rbg_era3[2], rbg_era3[3], inst._count/35)
    else
        inst.AnimState:SetMultColour(rbg_era3[1], rbg_era3[2], rbg_era3[3], 1)
    end
end

MakeFx_life({
    name = "siving_lifesteal_fx_era1",
    assets = assets_fx_era,
    fn_common = function(inst)
        inst.AnimState:SetBank("lifeplant_fx")
        inst.AnimState:SetBuild("lifeplant_fx")
        inst.AnimState:OverrideSymbol("lunar_mote", "siving_mask_era_fx", "lunar_mote"..tostring(5-math.random(2)))
        inst.AnimState:PlayAnimation("single"..math.random(1,3), true)
        inst.AnimState:SetMultColour(rbg_era1[1], rbg_era1[2], rbg_era1[3], 0)
        inst.AnimState:SetScale(0.6, 0.6)
        inst.fn_l_run = FnRun_era1
    end
})
MakeFx_life({
    name = "siving_lifesteal_fx_era2",
    assets = assets_fx_era,
    fn_common = function(inst)
        inst.AnimState:SetBank("lifeplant_fx")
        inst.AnimState:SetBuild("lifeplant_fx")
        inst.AnimState:OverrideSymbol("lunar_mote", "siving_mask_era_fx", "lunar_mote"..tostring(5-math.random(2)))
        inst.AnimState:PlayAnimation("single"..math.random(1,3), true)
        inst.AnimState:SetMultColour(rbg_era2[1], rbg_era2[2], rbg_era2[3], 0)
        inst.AnimState:SetScale(0.6, 0.6)
        inst.fn_l_run = FnRun_era2
    end
})
MakeFx_life({
    name = "siving_lifesteal_fx_era3",
    assets = assets_fx_era,
    fn_common = function(inst)
        inst.AnimState:SetBank("lifeplant_fx")
        inst.AnimState:SetBuild("lifeplant_fx")
        inst.AnimState:OverrideSymbol("lunar_mote", "siving_mask_era_fx", "lunar_mote"..tostring(math.random(4)))
        inst.AnimState:PlayAnimation("single"..math.random(1,3), true)
        inst.AnimState:SetMultColour(rbg_era1[1], rbg_era1[2], rbg_era1[3], 0)
        inst.AnimState:SetScale(0.6, 0.6)
        inst.fn_l_run = FnRun_era1
    end
})
MakeFx_life({
    name = "siving_lifesteal_fx_era4",
    assets = assets_fx_era,
    fn_common = function(inst)
        inst.AnimState:SetBank("lifeplant_fx")
        inst.AnimState:SetBuild("lifeplant_fx")
        inst.AnimState:OverrideSymbol("lunar_mote", "siving_mask_era_fx", "lunar_mote"..tostring(math.random(4)))
        inst.AnimState:PlayAnimation("single"..math.random(1,3), true)
        inst.AnimState:SetMultColour(rbg_era3[1], rbg_era3[2], rbg_era3[3], 0)
        inst.AnimState:SetScale(0.6, 0.6)
        inst.fn_l_run = FnRun_era3
    end
})

--------------------------------------------------------------------------
--[[ 子圭·垄(物品) ]]
--------------------------------------------------------------------------

table.insert(prefs, Prefab(
    "siving_soil_item",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("siving_soil")
        inst.AnimState:SetBuild("siving_soil")
        inst.AnimState:PlayAnimation("item")

        inst:AddTag("molebait")
        inst:AddTag("eyeturret") --眼球塔的专属标签，但为了deployable组件的摆放名字而使用（显示为“放置”）

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

        inst:AddComponent("inspectable")

        inst:AddComponent("tradable")
        inst.components.tradable.rocktribute = 18 --延缓 0.33x18 天地震
        inst.components.tradable.goldvalue = 15 --换1个砂之石或15金块

        inst:AddComponent("bait")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = "siving_soil_item"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/siving_soil_item.xml"
        inst.components.inventoryitem:SetSinks(true)

        inst:AddComponent("deployable")
        inst.components.deployable.ondeploy = function(inst, pt, deployer, rot)
            local tree = SpawnPrefab("siving_soil")
            if tree ~= nil then
                tree.Transform:SetPosition(pt:Get())
                inst.components.stackable:Get():Remove()

                if deployer ~= nil and deployer.SoundEmitter ~= nil then
                    deployer.SoundEmitter:PlaySound("dontstarve/wilson/plant_seeds")
                end
            end
        end
        inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.LESS)

        MakeHauntableLaunchAndIgnite(inst)

        return inst
    end,
    {
        Asset("ANIM", "anim/farm_soil.zip"), --官方栽培土动画模板（为了placer加载的）
        Asset("ANIM", "anim/siving_soil.zip"),
        Asset("ATLAS", "images/inventoryimages/siving_soil_item.xml"),
        Asset("IMAGE", "images/inventoryimages/siving_soil_item.tex")
    },
    { "siving_soil" }
))

--------------------------------------------------------------------------
--[[ 子圭·垄 ]]
--------------------------------------------------------------------------

table.insert(prefs, Prefab(
    "siving_soil",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.AnimState:SetBank("farm_soil")
        inst.AnimState:SetBuild("siving_soil")
        -- inst.AnimState:PlayAnimation("till_idle")

        inst:SetPhysicsRadiusOverride(TUNING.FARM_PLANT_PHYSICS_RADIUS)

        inst:AddTag("soil_legion")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst:DoTaskInTime(0, function()
            inst.AnimState:PlayAnimation("till_rise")
            inst.AnimState:PushAnimation("till_idle", false)
        end)

        inst:AddComponent("inspectable")

        inst:AddComponent("lootdropper")

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnFinishCallback(function(inst, worker)
            inst.components.lootdropper:SpawnLootPrefab("siving_soil_item")
            inst:Remove()
        end)

        MakeHauntableWork(inst)

        return inst
    end,
    {
        Asset("ANIM", "anim/farm_soil.zip"), --官方栽培土动画模板
        Asset("ANIM", "anim/siving_soil.zip")
    },
    { "siving_soil_item" }
))

--------------------
--------------------

return unpack(prefs)
