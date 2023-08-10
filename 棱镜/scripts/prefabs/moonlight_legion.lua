local prefs = {}

--------------------------------------------------------------------------
--[[ 通用函数 ]]
--------------------------------------------------------------------------

local function MakeItem(sets)
    local basename = sets.name.."_item"
    table.insert(prefs, Prefab(basename, function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(sets.name)
        inst.AnimState:SetBuild(sets.name)
        inst.AnimState:PlayAnimation("idle_item")

        if sets.floatable ~= nil then
            MakeInventoryFloatable(inst, sets.floatable[2], sets.floatable[3], sets.floatable[4])
            if sets.floatable[1] ~= nil then
                local OnLandedClient_old = inst.components.floater.OnLandedClient
                inst.components.floater.OnLandedClient = function(self)
                    OnLandedClient_old(self)
                    self.inst.AnimState:SetFloatParams(sets.floatable[1], 1, self.bob_percent)
                end
            end
        end

        if sets.fn_common ~= nil then
            sets.fn_common(inst)
        end

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = basename
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..basename..".xml"
        -- if sets.floatable == nil then
        --     inst.components.inventoryitem:SetSinks(true)
        -- end

        inst:AddComponent("upgradekit")

        MakeHauntableLaunch(inst)

        if sets.fn_server ~= nil then
            sets.fn_server(inst)
        end

        return inst
    end, sets.assets, sets.prefabs))
end

local function SpawnStackDrop(name, num, pos)
	local item = SpawnPrefab(name)
	if item ~= nil then
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

        item.Transform:SetPosition(pos:Get())
        if item.components.inventoryitem ~= nil then
            item.components.inventoryitem:OnDropped(true)
        end

		if num >= 1 then
			SpawnStackDrop(name, num, pos)
		end
	end
end
local function DropGems(inst, gemname)
    local numgems = inst.components.upgradeable:GetStage() - 1
    if numgems > 0 then
        SpawnStackDrop(gemname, numgems, inst:GetPosition())
    end
end

local function OnUpgradeFn(inst, doer, item)
    inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
end

--------------------------------------------------------------------------
--[[ 月藏宝匣 ]]
--------------------------------------------------------------------------

local times_hidden = CONFIGS_LEGION.HIDDENUPDATETIMES or 56
local step_hidden = math.floor(times_hidden/14)

local function SetTarget_hidden(inst, targetprefab)
    inst.upgradetarget = targetprefab
    if targetprefab == "saltbox" then
        inst.AnimState:OverrideSymbol("base", "hiddenmoonlight", "saltbase")
    end
end

local function DoBenefit(inst)
    local items = inst.components.container:GetAllItems()
    local items_valid = {}
    for _,v in pairs(items) do
        if v ~= nil and v.components.perishable ~= nil then
            table.insert(items_valid, v)
        end
    end

    local benifitnum = #items_valid
    if benifitnum == 0 then
        return
    end

    local stagenow = inst.components.upgradeable:GetStage() - 1
    if stagenow > times_hidden then --在设置变换中，会出现当前等级大于最大等级的情况
        stagenow = times_hidden
    end
    stagenow = math.floor(stagenow/step_hidden) + 2 --默认2格

    if benifitnum > stagenow then
        for i = 1, stagenow do
            local benifititem = table.remove(items_valid, math.random(#items_valid))
            benifititem.components.perishable:SetPercent(1)
        end
    else
        for _,v in ipairs(items_valid) do
            v.components.perishable:SetPercent(1)
        end
    end

    if inst:IsAsleep() then --未加载状态就不产生特效了
        return
    end

    local fx = SpawnPrefab("chesterlight")
    if fx ~= nil then
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        fx:TurnOn()
        inst.SoundEmitter:PlaySound("dontstarve/creatures/chester/raise")
        fx:DoTaskInTime(2, function(fx)
            if fx:IsAsleep() then
                fx:Remove()
            else
                fx:TurnOff()
            end
        end)
    end
end
local function OnFullMoon_hidden(inst)
    if not TheWorld.state.isfullmoon then --月圆时进行
        return
    end

    if inst:IsAsleep() then
        DoBenefit(inst)
    else
        inst:DoTaskInTime(math.random() + 0.4, DoBenefit)
    end
end

local function OnUpgrade_hidden(item, doer, target, result)
    if result.SoundEmitter ~= nil then
        result.SoundEmitter:PlaySound("dontstarve/common/place_structure_straw")
    end
    SetTarget_hidden(result, target.prefab)

    --将原箱子中的物品转移到新箱子中
    if target.components.container ~= nil and result.components.container ~= nil then
        target.components.container:Close() --强制关闭使用中的箱子
        target.components.container.canbeopened = false
        local allitems = target.components.container:RemoveAllItems()
        for _,v in ipairs(allitems) do
            result.components.container:GiveItem(v)
        end
    end

    item:Remove() --该道具是一次性的
    OnFullMoon_hidden(result)
end

MakeItem({
    name = "hiddenmoonlight",
    assets = {
        Asset("ANIM", "anim/hiddenmoonlight.zip"),
        Asset("ATLAS", "images/inventoryimages/hiddenmoonlight_item.xml"),
        Asset("IMAGE", "images/inventoryimages/hiddenmoonlight_item.tex"),
    },
    prefabs = { "hiddenmoonlight" },
    floatable = { 0.1, "med", 0.3, 0.7 },
    -- fn_common = function(inst)end,
    fn_server = function(inst)
        inst.components.upgradekit:SetData({
            icebox = {
                prefabresult = "hiddenmoonlight",
                onupgradefn = OnUpgrade_hidden,
            },
            saltbox = {
                prefabresult = "hiddenmoonlight",
                onupgradefn = OnUpgrade_hidden,
            }
        })
    end
})

----------
----------

local function OnOpen(inst)
    if inst.AnimState:IsCurrentAnimation("opened") or inst.AnimState:IsCurrentAnimation("open") then
        return
    end
    inst.AnimState:PlayAnimation("open")
    inst.AnimState:PushAnimation("opened", true)

    if not inst.SoundEmitter:PlayingSound("idlesound1") then
        inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/spore_cloud_LP", "idlesound1", 0.7)
    end
    if not inst.SoundEmitter:PlayingSound("idlesound2") then
        inst.SoundEmitter:PlaySound("dontstarve/bee/bee_hive_LP", "idlesound2", 0.7)
    end
    inst.SoundEmitter:PlaySound("dontstarve/cave/mushtree_tall_spore_land", nil, 0.6)
end
local function OnClose(inst)
    if inst.AnimState:IsCurrentAnimation("close") or inst.AnimState:IsCurrentAnimation("closed") then
        return
    end
    inst.AnimState:PlayAnimation("close")
    inst.AnimState:PushAnimation("closed", true)

    inst.SoundEmitter:KillSound("idlesound1")
    inst.SoundEmitter:KillSound("idlesound2")
    inst.SoundEmitter:PlaySound("dontstarve/cave/mushtree_tall_spore_land", nil, 0.6)
end
local function SetPerishRate_hidden(inst, item)
    if item == nil then
        return 0.3
    end
    if item:HasTag("frozen") then
        return 0
    elseif inst.upgradetarget ~= nil then --盐箱是0.25，冰箱0.5。给盐盒就是0.15，给冰箱就是0.3
        if inst.upgradetarget == "saltbox" then
            return 0.15
        end
    end
    return 0.3
end

table.insert(prefs, Prefab("hiddenmoonlight", function()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("hiddenmoonlight.tex")

    inst:AddTag("structure")
    inst:AddTag("fridge") --加了该标签，就能给热能石降温啦
    inst:AddTag("meteor_protection") --防止被流星破坏

    inst.AnimState:SetBank("hiddenmoonlight")
    inst.AnimState:SetBuild("hiddenmoonlight")
    inst.AnimState:PlayAnimation("closed", true)
    MakeSnowCovered_comm_legion(inst)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("hiddenmoonlight") end
        return inst
    end

    inst.upgradetarget = "icebox"

    inst:AddComponent("inspectable")

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("hiddenmoonlight")
    inst.components.container.onopenfn = OnOpen
    inst.components.container.onclosefn = OnClose
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true

    inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(SetPerishRate_hidden)

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)
    inst.components.workable:SetOnWorkCallback(function(inst, worker, workleft, numworks)
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("closed", true)
        inst.components.container:Close()
        if worker == nil or not worker:HasTag("player") then
            inst.components.workable:SetWorkLeft(5) --不能被非玩家破坏
            return
        end
        inst.components.container:DropEverything()
    end)
    inst.components.workable:SetOnFinishCallback(function(inst, worker)
        inst.components.container:DropEverything()

        local x, y, z = inst.Transform:GetWorldPosition()
        if inst.upgradetarget ~= nil then
            local box = SpawnPrefab(inst.upgradetarget)
            if box ~= nil then
                box.Transform:SetPosition(x, y, z)
            end
        end

        --归还宝石
        DropGems(inst, "bluegem")

        inst.components.lootdropper:SpawnLootPrefab("hiddenmoonlight_item")

        local fx = SpawnPrefab("collapse_small")
        fx.Transform:SetPosition(x, y, z)
        fx:SetMaterial("stone")
        inst:Remove()
    end)

    inst:AddComponent("upgradeable")
    inst.components.upgradeable.upgradetype = UPGRADETYPES.HIDDEN_L
    inst.components.upgradeable.onupgradefn = OnUpgradeFn
    -- inst.components.upgradeable.onstageadvancefn = function(inst)end
    inst.components.upgradeable.numstages = times_hidden + 1
    inst.components.upgradeable.upgradesperstage = 1

    inst:WatchWorldState("isfullmoon", OnFullMoon_hidden)

    MakeHauntableLaunchAndDropFirstItem(inst)

    MakeSnowCovered_serv_legion(inst, 0.1 + 0.3*math.random(), function(inst)
        inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
    end)

    inst.OnSave = function(inst, data)
        if inst.upgradetarget ~= "icebox" then
            data.upgradetarget = inst.upgradetarget
        end
    end
    inst.OnLoad = function(inst, data)
        if data ~= nil then
            if data.upgradetarget ~= nil then
                SetTarget_hidden(inst, data.upgradetarget)
            end
        end
    end

    if TUNING.SMART_SIGN_DRAW_ENABLE then
		SMART_SIGN_DRAW(inst)
	end

    return inst
end, {
    Asset("ANIM", "anim/ui_chest_3x3.zip"), --官方的容器栏背景动画模板
    Asset("ANIM", "anim/ui_hiddenmoonlight_4x4.zip"),
    Asset("ANIM", "anim/hiddenmoonlight.zip")
}, {
    "collapse_small",
    "hiddenmoonlight_item",
    "chesterlight"
}))

--------------------------------------------------------------------------
--[[ 月轮宝盘 ]]
--------------------------------------------------------------------------

local function OnUpgrade_revolved(item, doer, target, result)
    if result.SoundEmitter ~= nil then
        result.SoundEmitter:PlaySound("dontstarve/common/place_structure_straw")
    end

    if target.components.container ~= nil then
        target.components.container:Close() --强制关闭使用中的箱子
        target.components.container.canbeopened = false
        target.components.container:DropEverything()
    end
    item.components.skinedlegion:SetLinkedSkin(result, target.prefab == "piggyback" and "item" or "item_pro", doer)
    item:Remove() --该道具是一次性的
end

MakeItem({
    name = "revolvedmoonlight",
    assets = {
        Asset("ANIM", "anim/revolvedmoonlight.zip"),
        Asset("ATLAS", "images/inventoryimages/revolvedmoonlight_item.xml"),
        Asset("IMAGE", "images/inventoryimages/revolvedmoonlight_item.tex")
    },
    prefabs = { "revolvedmoonlight", "revolvedmoonlight_pro" },
    -- floatable = { 0.18, "small", 0.4, 0.55 },
    fn_common = function(inst)
        inst:AddComponent("skinedlegion")
        inst.components.skinedlegion:InitWithFloater("revolvedmoonlight_item")
    end,
    fn_server = function(inst)
        inst.components.upgradekit:SetData({
            piggyback = {
                prefabresult = "revolvedmoonlight",
                onupgradefn = OnUpgrade_revolved,
            },
            krampus_sack = {
                prefabresult = "revolvedmoonlight_pro",
                onupgradefn = OnUpgrade_revolved,
            }
        })
        -- inst.components.skinedlegion:SetOnPreLoad() --它没有装备组件，不需要 OnPreLoad 吧
    end
})

----------
----------

local times_revolved_pro = CONFIGS_LEGION.REVOLVEDUPDATETIMES or 20
local value_revolved = 5/times_revolved_pro
local cool_revolved = TUNING.TOTAL_DAY_TIME/times_revolved_pro
local temp_revolved = 35/times_revolved_pro
local times_revolved = math.floor(times_revolved_pro/2) + 1
times_revolved_pro = times_revolved_pro + 1

local function OnOpen_revolved(inst)
    if inst.AnimState:IsCurrentAnimation("opened") or inst.AnimState:IsCurrentAnimation("open") then
        return
    end
    inst.AnimState:PlayAnimation("open")
    inst.AnimState:PushAnimation("opened", true)

    inst.SoundEmitter:PlaySound("dontstarve/cave/mushtree_tall_spore_land", nil, 0.6)

    local gowner = inst.components.inventoryitem:GetGrandOwner()
    if gowner ~= nil then --说明自己在容器里，就不要发出循环声音
        return
    end
    if not inst.SoundEmitter:PlayingSound("idlesound1") then
        inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/spore_cloud_LP", "idlesound1", 0.7)
    end
    if not inst.SoundEmitter:PlayingSound("idlesound2") then
        inst.SoundEmitter:PlaySound("dontstarve/bee/bee_hive_LP", "idlesound2", 0.7)
    end
end
local function OnClose_revolved(inst)
    if inst.AnimState:IsCurrentAnimation("close") or inst.AnimState:IsCurrentAnimation("closed") then
        return
    end
    inst.AnimState:PlayAnimation("close")
    inst.AnimState:PushAnimation("closed")

    inst.SoundEmitter:KillSound("idlesound1")
    inst.SoundEmitter:KillSound("idlesound2")
    inst.SoundEmitter:PlaySound("dontstarve/cave/mushtree_tall_spore_land", nil, 0.6)
end

local function UpdateLight_revolved(owner)
    if owner._revolves_light == nil or owner.prefab == "shadow_container" then
        return
    end

    local chosen = nil
    local range = 0
    for k,_ in pairs(owner._revolves_light) do
        if k:IsValid() then
            local stagenow = k.components.upgradeable:GetStage()
            if stagenow > range then
                range = stagenow
                chosen = k
            end
        end
    end
    if chosen ~= nil then
        for k,_ in pairs(owner._revolves_light) do
            if k:IsValid() then
                k._light.Light:Enable(k == chosen)
            end
        end
    end
end
local function RemoveLight_revolved(inst, owner)
    if owner ~= nil and owner:IsValid() and owner._revolves_light ~= nil then
        owner._revolves_light[inst] = nil
        local newlights = nil
        for k,_ in pairs(owner._revolves_light) do
            if k:IsValid() then
                if newlights == nil then
                    newlights = {}
                end
                newlights[k] = true
            end
        end
        owner._revolves_light = newlights
        UpdateLight_revolved(owner)
    end
end
local function ResetRadius(inst, grandowner)
    --先获取最上层携带者
    if grandowner == nil then
        grandowner = inst
        while grandowner.components.inventoryitem ~= nil do
            local nextowner = grandowner.components.inventoryitem.owner
            if nextowner == nil then
                break
            end
            grandowner = nextowner
        end
    end
    if grandowner == inst then
        grandowner = nil
    end

    --更新光照范围
    local stagenow = inst.components.upgradeable:GetStage()
    if stagenow > 1 then
        if stagenow > times_revolved_pro then --在设置变换中，会出现当前等级大于最大等级的情况
            stagenow = times_revolved_pro
        end
        local rad = 0.25 + (stagenow-1)*value_revolved
        if grandowner ~= nil then --被携带时，发光范围减半
            rad = rad / 2
            inst._light.Light:SetFalloff(0.65)
        else
            inst._light.Light:SetFalloff(0.7)
        end
        inst._light.Light:SetRadius(rad) --最大约2.75和5.25半径
    end

    local owner_last = inst._owner_light
    if grandowner == nil then --没有新主人，只取消原主人
        RemoveLight_revolved(inst, owner_last)
        inst._owner_light = nil
        inst._light.Light:Enable(true)
    else
        if grandowner._revolves_light == nil then
            grandowner._revolves_light = {}
        end
        if owner_last ~= grandowner then
            RemoveLight_revolved(inst, owner_last)
        end
        inst._owner_light = grandowner
        grandowner._revolves_light[inst] = true
        if grandowner.prefab == "shadow_container" then
            inst._light.Light:Enable(false)
        else
            UpdateLight_revolved(grandowner)
        end
    end
end
local function IsValid(one)
    return one:IsValid() and
        one.components.health ~= nil and not one.components.health:IsDead()
end
local function CancelTask_heat(inst)
    if inst.task_l_heat ~= nil then
        inst.task_l_heat:Cancel()
        inst.task_l_heat = nil
    end
end
local function OnTempDelta(owner, data)
    if data == nil then
        return
    end
    if owner._revolves == nil then
        owner:RemoveEventCallback("temperaturedelta", OnTempDelta)
        owner:RemoveEventCallback("death", OnTempDelta)
        return
    end
    if owner.components.health == nil or owner.components.health:IsDead() or owner.components.temperature == nil then
        CancelTask_heat(owner)
        owner:RemoveEventCallback("temperaturedelta", OnTempDelta)
        owner:RemoveEventCallback("death", OnTempDelta)
        owner._revolves = nil
        return
    end

    if data.new ~= nil then
        if data.new >= 6 then --低温特效出现前就执行
            return
        end
        if owner.task_l_heat ~= nil then --正在升温，就不继续
            return
        end

        local chosen = nil
        for k,_ in pairs(owner._revolves) do
            if k:IsValid() then
                if k.components.rechargeable:IsCharged() then --冷却完毕，可以用
                    chosen = k
                    break
                end
            end
        end
        if chosen == nil then
            return
        end

        local count = 1
        local stagenow = chosen.components.upgradeable:GetStage()
        if stagenow > times_revolved_pro then --在设置变换中，会出现当前等级大于最大等级的情况
            stagenow = times_revolved_pro
        end

        chosen.components.rechargeable:Discharge(3 + cool_revolved*(times_revolved_pro-stagenow))
        stagenow = 7 + temp_revolved*(stagenow-1) --7-42

        owner.task_l_heat = owner:DoPeriodicTask(0.5, function(owner)
            if
                owner.components.health == nil or owner.components.health:IsDead() or
                owner.components.temperature == nil
            then
                CancelTask_heat(owner)
                owner:RemoveEventCallback("temperaturedelta", OnTempDelta)
                owner:RemoveEventCallback("death", OnTempDelta)
                owner._revolves = nil
                return
            end

            local fx = SpawnPrefab("revolvedmoonlight_fx")
            if fx ~= nil then
                fx.Transform:SetPosition(owner.Transform:GetWorldPosition())
            end

            if count < 1 then
                count = 1
                return
            else
                count = 0
            end

            local temper = owner.components.temperature
            if (temper.current+8.5) < temper.overheattemp then --可不能让温度太高了
                temper:SetTemperature(temper.current + 3.5)
            else
                CancelTask_heat(owner)
                return
            end

            stagenow = stagenow - 3.5
            if stagenow <= 0 then
                CancelTask_heat(owner)
            end
        end, 0)
    end
end
local function TemperatureProtect(inst, owner)
    --先取消监听以前的对象
    if inst._owner_temp ~= nil then
        if inst._owner_temp == owner then --监听对象没有发生变化，就结束
            return
        end
        if inst._owner_temp._revolves ~= nil then
            local newrevolves = nil
            inst._owner_temp._revolves[inst] = nil
            for k,_ in pairs(inst._owner_temp._revolves) do
                if k:IsValid() then
                    if newrevolves == nil then
                        newrevolves = {}
                    end
                    newrevolves[k] = true
                end
            end
            if newrevolves == nil then
                inst._owner_temp:RemoveEventCallback("temperaturedelta", OnTempDelta)
                inst._owner_temp:RemoveEventCallback("death", OnTempDelta)
            end
            inst._owner_temp._revolves = newrevolves
        else
            inst._owner_temp:RemoveEventCallback("temperaturedelta", OnTempDelta)
            inst._owner_temp:RemoveEventCallback("death", OnTempDelta)
        end
        inst._owner_temp = nil
    end

    --再尝试监听目前的对象
    if
        owner and owner.components.temperature ~= nil and IsValid(owner)
    then
        if owner._revolves == nil then --第一次携带，把基础设定加上
            owner._revolves = {}
            owner:ListenForEvent("temperaturedelta", OnTempDelta)
            owner:ListenForEvent("death", OnTempDelta)
            --温度监听 触发非常频繁，所以应该不需要主动触发一次
            -- OnTempDelta(owner, { last = 0, new = owner.components.temperature:GetCurrent() })
        end
        owner._revolves[inst] = true
        inst._owner_temp = owner
    end
end
local function OnOwnerChange(inst)
    local newowners = {}
    local owner = inst
    while owner.components.inventoryitem ~= nil do
        newowners[owner] = true

        if inst._owners[owner] then
            inst._owners[owner] = nil
        else
            inst:ListenForEvent("onputininventory", inst._onownerchange, owner)
            inst:ListenForEvent("ondropped", inst._onownerchange, owner)
        end

        local nextowner = owner.components.inventoryitem.owner
        if nextowner == nil then
            break
        end

        owner = nextowner
    end

    inst._light.entity:SetParent(owner.entity)
    ResetRadius(inst, owner)
    TemperatureProtect(inst, owner)

    for k, v in pairs(inst._owners) do
        if k:IsValid() then
            inst:RemoveEventCallback("onputininventory", inst._onownerchange, k)
            inst:RemoveEventCallback("ondropped", inst._onownerchange, k)
        end
    end

    inst._owners = newowners

    --暗影容器里，打开时会自动掉地上，防止崩溃
    if owner and owner.prefab == "shadow_container" then
        inst.components.container.droponopen = true
    else
        inst.components.container.droponopen = nil
    end
end

local function MakeRevolved(sets)
    table.insert(prefs, Prefab(sets.name, function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("revolvedmoonlight")
        inst.AnimState:SetBuild("revolvedmoonlight")
        inst.AnimState:PlayAnimation("closed")

        if sets.ispro then
            inst.AnimState:OverrideSymbol("decorate", "revolvedmoonlight", "decoratepro")
            inst:SetPrefabNameOverride("revolvedmoonlight")
        end

        inst:AddTag("meteor_protection") --防止被流星破坏
        --因为有容器组件，所以不会被猴子、食人花、坎普斯等拿走
        inst:AddTag("nosteal") --防止被火药猴偷走
        inst:AddTag("NORATCHECK") --mod兼容：永不妥协。该道具不算鼠潮分

        inst:AddComponent("skinedlegion")
        inst.components.skinedlegion:InitWithFloater(sets.name)

        -- if sets.fn_common ~= nil then
        --     sets.fn_common(inst)
        -- end

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup(sets.name) end
            return inst
        end

        inst._owner_temp = nil
        inst._owner_light = nil

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = sets.name
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..sets.name..".xml"
        inst.components.inventoryitem:SetOnPutInInventoryFn(function(inst)
            inst.components.container:Close()
            inst.AnimState:PlayAnimation("closed")
        end)

        inst:AddComponent("container")
        inst.components.container:WidgetSetup(sets.name)
        inst.components.container.onopenfn = OnOpen_revolved
        inst.components.container.onclosefn = OnClose_revolved
        inst.components.container.skipclosesnd = true
        inst.components.container.skipopensnd = true
        -- inst.components.container.droponopen = true --去掉这个就能打开不掉落了

        inst:AddComponent("lootdropper")

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(5)
        inst.components.workable:SetOnWorkCallback(function(inst, worker, workleft, numworks)
            inst.AnimState:PlayAnimation("hit")
            inst.AnimState:PushAnimation("closed")
            inst.SoundEmitter:PlaySound("grotto/common/turf_crafting_station/hit")
            inst.components.container:Close()
            if worker == nil or not worker:HasTag("player") then
                inst.components.workable:SetWorkLeft(5) --不能被非玩家破坏
                return
            end
            inst.components.container:DropEverything()
        end)
        inst.components.workable:SetOnFinishCallback(function(inst, worker)
            inst.components.container:DropEverything()

            --归还背包
            local x, y, z = inst.Transform:GetWorldPosition()
            local back = SpawnPrefab(sets.ispro and "krampus_sack" or "piggyback")
            if back ~= nil then
                back.Transform:SetPosition(x, y, z)
            end

            --归还宝石
            DropGems(inst, "yellowgem")

            --归还套件
            inst.components.skinedlegion:SpawnLinkedSkinLoot("revolvedmoonlight_item", inst, "item", worker)

            --特效
            local fx = SpawnPrefab("collapse_small")
            fx.Transform:SetPosition(x, y, z)
            fx:SetMaterial("stone")
            inst:Remove()
        end)

        inst:AddComponent("upgradeable")
        inst.components.upgradeable.upgradetype = UPGRADETYPES.REVOLVED_L
        inst.components.upgradeable.onupgradefn = OnUpgradeFn
        inst.components.upgradeable.onstageadvancefn = function(inst)
            inst.components.rechargeable:SetPercent(1) --每次升级，重置冷却时间
            ResetRadius(inst, nil)
        end
        inst.components.upgradeable.numstages = sets.ispro and times_revolved_pro or times_revolved
        inst.components.upgradeable.upgradesperstage = 1

        inst:AddComponent("rechargeable")
        -- inst.components.rechargeable:SetOnChargedFn(function(inst)end)

        inst.OnLoad = function(inst, data) --由于 upgradeable 组件不会自己重新初始化，只能这里再初始化
            inst:DoTaskInTime(0.5, function(inst)
                ResetRadius(inst, nil)
            end)
        end

        --Create light
        inst._light = SpawnPrefab("heatrocklight")
        inst._light.Light:SetRadius(0.25)
        inst._light.Light:SetFalloff(0.7) --Tip：削弱系数：相同半径时，值越小会让光照范围越大
        inst._light.Light:SetColour(255/255, 242/255, 169/255)
        inst._light.Light:SetIntensity(0.75)
        inst._light.Light:Enable(true)
        inst._owners = {}
        inst._onownerchange = function() OnOwnerChange(inst) end
        OnOwnerChange(inst)
        inst.OnRemoveEntity = function(inst)
            inst._light:Remove()
        end

        -- if TUNING.SMART_SIGN_DRAW_ENABLE then --由于这个容器是便携的，不适合兼容【智能小木牌】
        --     SMART_SIGN_DRAW(inst)
        -- end

        -- inst.components.skinedlegion:SetOnPreLoad() --它没有装备组件，不需要 OnPreLoad 吧

        -- if sets.fn_server ~= nil then
        --     sets.fn_server(inst)
        -- end

        return inst
    end, {
        Asset("ANIM", "anim/ui_chest_3x3.zip"), --官方的容器栏背景动画模板
        Asset("ANIM", "anim/ui_revolvedmoonlight_4x3.zip"),
        Asset("ANIM", "anim/revolvedmoonlight.zip"),
        Asset("ATLAS", "images/inventoryimages/"..sets.name..".xml"),
        Asset("IMAGE", "images/inventoryimages/"..sets.name..".tex")
    }, {
        "revolvedmoonlight_item",
        "collapse_small",
        "yellowgem",
        "heatrocklight",
        "revolvedmoonlight_fx"
    }))
end

MakeRevolved({
    name = "revolvedmoonlight",
    -- floatable = { 0.1, "med", 0.3, 0.3 },
    ispro = nil,
    -- fn_common = function(inst)end,
    -- fn_server = function(inst)end
})
MakeRevolved({
    name = "revolvedmoonlight_pro",
    -- floatable = { 0.1, "med", 0.3, 0.45 },
    ispro = true,
    -- fn_common = function(inst)end,
    -- fn_server = function(inst)end
})

--------------------
--------------------

return unpack(prefs)
