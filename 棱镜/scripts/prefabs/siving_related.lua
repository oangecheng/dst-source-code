local prefs = {}

--------------------------------------------------------------------------
--[[ 通用 ]]
--------------------------------------------------------------------------

local ctlFuledItems = {
    ice = { moisture = 100, nutrients = nil },
    icehat = { moisture = 1000, nutrients = { 8, nil, 8 } },
    wintercooking_mulleddrink = { moisture = 100, nutrients = { 2, 2, 8 } },
    waterballoon = { moisture = 400, nutrients = { nil, 2, nil } },
    oceanfish_medium_8_inv = { moisture = 200, nutrients = { 16, nil, nil } }, --冰鲷鱼
    watermelonicle = { moisture = 200, nutrients = { 8, 8, 16 } },
    icecream = { moisture = 200, nutrients = { 24, 24, 24 } },
    cutted_rosebush = { moisture = nil, nutrients = { 5, 5, 8 } },
    cutted_lilybush = { moisture = nil, nutrients = { 5, 5, 8 } },
    cutted_orchidbush = { moisture = nil, nutrients = { 5, 5, 8 } },
    sachet = { moisture = nil, nutrients = { 8, 8, 8 } },
    rosorns = { moisture = nil, nutrients = { 12, 12, 48 } },
    lileaves = { moisture = nil, nutrients = { 12, 48, 12 } },
    orchitwigs = { moisture = nil, nutrients = { 48, 12, 12 } },
    lance_carrot_l = { moisture = nil, nutrients = { 24, 24, 24 } },
    tissue_l_cactus = { moisture = nil, nutrients = { 8, nil, 8 } },
    tissue_l_lureplant = { moisture = nil, nutrients = { 8, nil, 8 } },

    --【猥琐联盟】
    weisuo_coppery_kela = { moisture = nil, nutrients = { 2, 2, 2 } },
    weisuo_silvery_kela = { moisture = nil, nutrients = { 20, 20, 20 } },
    weisuo_golden_kela = { moisture = nil, nutrients = { 80, 80, 80 } },
}
local PLACER_SCALE_CTL = 1.79 --这个大小就是20半径的

local function MakeItem(data)
    local basename = "siving_ctl"..data.name
    table.insert(prefs, Prefab(
        basename.."_item",
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddNetwork()

            MakeInventoryPhysics(inst)

            inst.AnimState:SetBank(basename)
            inst.AnimState:SetBuild(basename)
            inst.AnimState:PlayAnimation("item")

            inst:AddTag("eyeturret") --眼球塔的专属标签，但为了deployable组件的摆放名字而使用（显示为“放置”）

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst.siv_moisture = nil
            inst.siv_nutrients = nil

            inst:AddComponent("inspectable")

            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem.imagename = basename.."_item"
            inst.components.inventoryitem.atlasname = "images/inventoryimages/"..basename.."_item.xml"
            inst.components.inventoryitem:SetSinks(true)

            inst:AddComponent("deployable")
            inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)
            inst.components.deployable.ondeploy = function(inst, pt, deployer)
                local tree = SpawnPrefab(basename)
                if tree ~= nil then
                    tree.components.botanycontroller:SetValue(inst.siv_moisture, inst.siv_nutrients, false)
                    tree.Transform:SetPosition(pt:Get())
                    if deployer ~= nil and deployer.SoundEmitter ~= nil then
                        deployer.SoundEmitter:PlaySound(data.sound)
                    end
                    inst:Remove()
                end
            end

            MakeHauntableLaunchAndIgnite(inst)

            inst.OnSave = function(inst, data)
                if inst.siv_moisture ~= nil then
                    data.siv_moisture = inst.siv_moisture
                end
                if inst.siv_nutrients ~= nil then
                    data.siv_nutrients = inst.siv_nutrients
                end
            end
            inst.OnLoad = function(inst, data)
                if data ~= nil then
                    if data.siv_moisture ~= nil then
                        inst.siv_moisture = data.siv_moisture
                    end
                    if data.siv_nutrients ~= nil then
                        inst.siv_nutrients = data.siv_nutrients
                    end
                end
            end

            return inst
        end,
        data.assets,
        data.prefabs
    ))
    table.insert(prefs, MakePlacer(basename.."_item_placer", "firefighter_placement", "firefighter_placement", "idle",
        true, nil, nil, PLACER_SCALE_CTL, nil, nil, function(inst)
            local placer2 = CreateEntity()

            --[[Non-networked entity]]
            placer2.entity:SetCanSleep(false)
            placer2.persists = false

            placer2.entity:AddTransform()
            placer2.entity:AddAnimState()

            placer2:AddTag("CLASSIFIED")
            placer2:AddTag("NOCLICK")
            placer2:AddTag("placer")

            local s = 1 / PLACER_SCALE_CTL
            placer2.Transform:SetScale(s, s, s)

            placer2.AnimState:SetBank(basename)
            placer2.AnimState:SetBuild(basename)
            placer2.AnimState:PlayAnimation("idle")
            placer2.AnimState:SetLightOverride(1)

            placer2.entity:SetParent(inst.entity)

            inst.components.placer:LinkEntity(placer2)
        end
    ))
end

local function MakeConstruct(data)
    local basename = "siving_ctl"..data.name

    local function OnEnableHelper_ctl(inst, enabled)
        if enabled then
            if inst.helper == nil then
                inst.helper = CreateEntity()

                --[[Non-networked entity]]
                inst.helper.entity:SetCanSleep(false)
                inst.helper.persists = false

                inst.helper.entity:AddTransform()
                inst.helper.entity:AddAnimState()

                inst.helper:AddTag("CLASSIFIED")
                inst.helper:AddTag("NOCLICK")
                inst.helper:AddTag("placer")

                inst.helper.Transform:SetScale(PLACER_SCALE_CTL, PLACER_SCALE_CTL, PLACER_SCALE_CTL)

                inst.helper.AnimState:SetBank("firefighter_placement")
                inst.helper.AnimState:SetBuild("firefighter_placement")
                inst.helper.AnimState:PlayAnimation("idle")
                inst.helper.AnimState:SetLightOverride(1)
                inst.helper.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
                inst.helper.AnimState:SetLayer(LAYER_BACKGROUND)
                inst.helper.AnimState:SetSortOrder(1)
                inst.helper.AnimState:SetAddColour(0, .5, .5, 0)

                inst.helper.entity:SetParent(inst.entity)
            end
        elseif inst.helper ~= nil then
            inst.helper:Remove()
            inst.helper = nil
        end
    end

    local function CanAcceptMoisture(botanyctl, test)
        if test ~= nil and (botanyctl.type == 1 or botanyctl.type == 3) then
            return botanyctl.moisture < botanyctl.moisture_max
        end
        return nil
    end
    local function CanAcceptNutrients(botanyctl, test)
        if test ~= nil and (botanyctl.type == 2 or botanyctl.type == 3) then
            if test[1] ~= nil and test[1] ~= 0 and botanyctl.nutrients[1] < botanyctl.nutrient_max then
                return true
            elseif test[2] ~= nil and test[2] ~= 0 and botanyctl.nutrients[2] < botanyctl.nutrient_max then
                return true
            elseif test[3] ~= nil and test[3] ~= 0 and botanyctl.nutrients[3] < botanyctl.nutrient_max then
                return true
            else
                return false
            end
        end
        return nil
    end
    local function GiveItemBack(inst, giver, item)
        if giver and giver.components.inventory ~= nil then
            -- item.prevslot = nil
            -- item.prevcontainer = nil
            giver.components.inventory:GiveItem(item, nil, giver:GetPosition() or nil)
        else
            item.Transform:SetPosition(inst.Transform:GetWorldPosition())
        end
    end
    local function GetAllActiveItems(giver, item, times)
        --需要限制获取时机，不可能每次循环都来合并一次
        if times == 1 and item.components.stackable ~= nil then --有叠加组件，说明鼠标上可能有物品
            if giver.components.inventory ~= nil then
                local activeitem = giver.components.inventory:GetActiveItem()
                if activeitem ~= nil and activeitem.prefab == item.prefab then
                    activeitem.components.inventoryitem:RemoveFromOwner(true)
                    item.components.stackable:Put(activeitem)
                end
            end
        end
    end

    local function AcceptTest(inst, item, giver)
        local botanyctl = inst.components.botanycontroller
        local acpt_m = nil --true接受、false已经满了、nil无法接受
        local acpt_n = nil
        if ctlFuledItems[item.prefab] ~= nil then
            acpt_m = CanAcceptMoisture(botanyctl, ctlFuledItems[item.prefab].moisture)
            acpt_n = CanAcceptNutrients(botanyctl, ctlFuledItems[item.prefab].nutrients)
        elseif item.siv_ctl_fueled ~= nil then --兼容其他mod
            acpt_m = CanAcceptMoisture(botanyctl, item.siv_ctl_fueled.moisture)
            acpt_n = CanAcceptNutrients(botanyctl, item.siv_ctl_fueled.nutrients)
        else
            acpt_m = CanAcceptMoisture(botanyctl, item.components.wateryprotection)
            if item.components.fertilizer ~= nil then
                acpt_n = CanAcceptNutrients(botanyctl, item.components.fertilizer.nutrients)
            end
        end

        if acpt_m or acpt_n then
            return true
        elseif giver ~= nil then
            if acpt_m == false or acpt_n == false then
                giver.siv_ctl_traded = "ISFULL"
            else
                giver.siv_ctl_traded = "REFUSE"
            end
        end

        return false
    end
    local function OnAccept(inst, giver, item, times)
        if not CONFIGS_LEGION.GGGGRREEANY then
            if
                SKINS_LEGION["icire_rock_collector"].skin_id == "notnononl" or
                SKINS_LEGION["siving_turn_collector"].skin_id == "notnononl" or
                SKINS_LEGION["revolvedmoonlight_item_taste3"].skin_id == "notnononl"
            then
                CONFIGS_LEGION.GGGGRREEANY = true
                item:Remove()
                return
            end
        else
            item:Remove()
            return
        end

        if times == nil then
            times = 1
        end

        local botanyctl = inst.components.botanycontroller
        if ctlFuledItems[item.prefab] ~= nil then
            GetAllActiveItems(giver, item, times)
            botanyctl:SetValue(ctlFuledItems[item.prefab].moisture, ctlFuledItems[item.prefab].nutrients, true)
        elseif item.siv_ctl_fueled ~= nil then
            botanyctl:SetValue(item.siv_ctl_fueled.moisture, item.siv_ctl_fueled.nutrients, true)
            if item.siv_ctl_fueled.fn_accept ~= nil then
                item.siv_ctl_fueled.fn_accept(inst, giver, item)
                return
            end
            GetAllActiveItems(giver, item, times)
        else
            GetAllActiveItems(giver, item, times)
            local waterypro = item.components.wateryprotection
            local value_m = nil
            if waterypro ~= nil then
                if waterypro.addwetness == nil or waterypro.addwetness == 0 then
                    value_m = 20
                else
                    value_m = waterypro.addwetness
                end
                if item.components.finiteuses ~= nil then
                    value_m = value_m * item.components.finiteuses:GetUses() --普通水壶是+1000
                else
                    value_m = value_m * 10
                end
            end

            botanyctl:SetValue(value_m,
                item.components.fertilizer ~= nil and item.components.fertilizer.nutrients or nil,
                true
            )

            if item.components.fertilizer ~= nil then
                item.components.fertilizer:OnApplied(giver, inst) --删除以及特殊机制就在其中
                if item:IsValid() then
                    if
                        (
                            (item.components.finiteuses ~= nil and item.components.finiteuses:GetUses() > 0)
                            or (item.components.stackable ~= nil and item.components.stackable:StackSize() >= 1)
                        )
                        and AcceptTest(inst, item, giver)
                    then
                        OnAccept(inst, giver, item, times+1)
                    else
                        GiveItemBack(inst, giver, item)
                    end
                    giver.siv_ctl_traded = nil
                end
                return
            elseif item.components.finiteuses ~= nil then
                if item.prefab == "wateringcan" or item.prefab == "premiumwateringcan" then
                    item.components.finiteuses:Use(1000)
                else
                    item.components.finiteuses:Use(1)
                end
                if item:IsValid() then
                    if item.components.finiteuses:GetUses() > 0 and AcceptTest(inst, item, giver) then
                        OnAccept(inst, giver, item, times+1)
                    else
                        GiveItemBack(inst, giver, item)
                    end
                    giver.siv_ctl_traded = nil
                end
                return
            end
        end

        if item.components.stackable ~= nil then
            if item.components.stackable:StackSize() > times and AcceptTest(inst, item, giver) then
                OnAccept(inst, giver, item, times+1)
            else
                item.components.stackable:Get(times):Remove()
                if item:IsValid() then
                    GiveItemBack(inst, giver, item)
                end
            end
        else
            item:Remove()
        end
    end

    local function DoFunction(inst, doit)
        if inst.task_function ~= nil then
            inst.task_function:Cancel()
            inst.task_function = nil
        end
        if not doit then
            return
        end

        local time = 210 + math.random()*10
        inst.task_function = inst:DoPeriodicTask(time, function()
            if TheWorld.state.israining or TheWorld.state.issnowing then --下雨时补充水分
                inst.components.botanycontroller:SetValue(800, nil, true)
            end
            inst.components.botanycontroller:DoAreaFunction()
        end, math.random()*2)
    end

    table.insert(prefs, Prefab(
        basename,
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddMiniMapEntity()
            inst.entity:AddNetwork()

            inst:SetPhysicsRadiusOverride(.16)
            MakeObstaclePhysics(inst, inst.physicsradiusoverride)

            inst.MiniMapEntity:SetIcon(basename..".tex")

            inst.AnimState:SetBank(basename)
            inst.AnimState:SetBuild(basename)
            inst.AnimState:PlayAnimation("idle")

            inst:AddTag("structure")
            inst:AddTag("siving_ctl")

            --Dedicated server does not need deployhelper
            if not TheNet:IsDedicated() then
                inst:AddComponent("deployhelper")
                inst.components.deployhelper.onenablehelper = OnEnableHelper_ctl
            end

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst:AddComponent("inspectable")

            inst:AddComponent("portablestructure")
            inst.components.portablestructure:SetOnDismantleFn(function(inst, doer)
                local item = SpawnPrefab(basename.."_item")
                if item ~= nil then
                    item.siv_moisture = inst.components.botanycontroller.moisture
                    item.siv_nutrients = inst.components.botanycontroller.nutrients
                    if doer ~= nil and doer.components.inventory ~= nil then
                        doer.components.inventory:GiveItem(item)
                        if doer.SoundEmitter ~= nil then
                            doer.SoundEmitter:PlaySound("dontstarve/common/together/succulent_craft")
                        end
                    else
                        item.Transform:SetPosition(inst.Transform:GetWorldPosition())
                    end
                    inst.components.botanycontroller:TriggerPlant(false)
                    DoFunction(inst, false)
                    inst:Remove()
                end
            end)

            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
            inst.components.workable:SetWorkLeft(1)
            inst.components.workable:SetOnFinishCallback(function(inst, worker)
                local x, y, z = inst.Transform:GetWorldPosition()
                local item = SpawnPrefab(basename.."_item")
                if item ~= nil then
                    item.siv_moisture = inst.components.botanycontroller.moisture
                    item.siv_nutrients = inst.components.botanycontroller.nutrients
                    item.Transform:SetPosition(x, y, z)
                end
                local fx = SpawnPrefab("collapse_small")
                fx.Transform:SetPosition(x, y, z)
                fx:SetMaterial("rock")
                inst.components.botanycontroller:TriggerPlant(false)
                DoFunction(inst, false)
                inst:Remove()
            end)

            inst:AddComponent("hauntable")
            inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)

            inst:AddComponent("trader")
            inst.components.trader:SetAcceptTest(AcceptTest)
            inst.components.trader.onaccept = OnAccept
            inst.components.trader.onrefuse = function(inst, giver, item)
                if giver ~= nil and giver.siv_ctl_traded ~= nil then
                    if giver.components.talker ~= nil then
                        giver.components.talker:Say(GetString(giver, "DESCRIBE", { string.upper(basename), giver.siv_ctl_traded }))
                    end
                    giver.siv_ctl_traded = nil
                end
            end
            inst.components.trader.deleteitemonaccept = false --收到物品不马上移除，根据具体物品决定
            inst.components.trader.acceptnontradable = true

            inst:AddComponent("botanycontroller")

            inst.task_function = nil
            inst:DoTaskInTime(0.1+math.random()*0.4, function()
                inst.components.botanycontroller:TriggerPlant(true)
                DoFunction(inst, true)
            end)

            if data.fn_server ~= nil then
                data.fn_server(inst)
            end

            return inst
        end,
        data.assets,
        data.prefabs
    ))
end

local function MakeMask(data)
    table.insert(prefs, Prefab(
        data.name,
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddNetwork()

            MakeInventoryPhysics(inst)

            inst:AddTag("hat")
            inst:AddTag("open_top_hat")

            inst.AnimState:SetBank(data.name)
            inst.AnimState:SetBuild(data.name)
            inst.AnimState:PlayAnimation("idle")

            if data.fn_common ~= nil then
                data.fn_common(inst)
            end

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst.healthcounter = 0
            inst.lifetarget = nil

            inst:AddComponent("inspectable")

            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem.imagename = data.name
            inst.components.inventoryitem.atlasname = "images/inventoryimages/"..data.name..".xml"
            inst.components.inventoryitem:SetSinks(true) --它是石头做的，不可漂浮

            inst:AddComponent("equippable")
            inst.components.equippable.equipslot = EQUIPSLOTS.HEAD

            inst:AddComponent("armor")

            inst:AddComponent("tradable")

            MakeHauntableLaunch(inst)

            inst.OnSave = function(inst, data)
                if inst.healthcounter > 0 then
                    data.healthcounter = inst.healthcounter
                end
            end
            inst.OnLoad = function(inst, data)
                if data ~= nil then
                    if data.healthcounter ~= nil then
                        inst.healthcounter = data.healthcounter
                    end
                end
            end

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
--[[ 子圭·利川 ]]
--------------------------------------------------------------------------

local function AddBar(inst, data)
    local fx = SpawnPrefab("siving_ctl_bar")
    if fx ~= nil then
        -- fx.Transform:SetNoFaced()

        fx.AnimState:SetBank(data.bank)
        fx.AnimState:SetBuild(data.build)
        -- fx.AnimState:PlayAnimation(data.anim)
        fx.AnimState:SetPercent(data.anim, 0)

        inst:AddChild(fx)
        fx.Follower:FollowSymbol(inst.GUID, "base", data.x, data.y, data.z)
        if data.scale ~= nil then
            fx.Transform:SetScale(data.scale, data.scale, data.scale)
        end

        inst[data.barkey] = fx
    end
end
local function SetBar(inst, barkey, anim, value, valuemax)
    if inst[barkey] ~= nil then
        if value <= 0 then
            inst[barkey].AnimState:SetPercent(anim, 0)
        elseif value < valuemax then
            inst[barkey].AnimState:SetPercent(anim, value/valuemax)
        else
            inst[barkey].AnimState:SetPercent(anim, 1)
        end
    end
end

MakeItem({
    name = "water",
    assets = {
        Asset("ANIM", "anim/siving_ctlwater.zip"),
        Asset("ATLAS", "images/inventoryimages/siving_ctlwater_item.xml"),
        Asset("IMAGE", "images/inventoryimages/siving_ctlwater_item.tex"),
        Asset("ANIM", "anim/firefighter_placement.zip"), --灭火器的placer圈
    },
    prefabs = { "siving_ctlwater" },
    sound = "dontstarve/common/rain_meter_craft",
})
MakeConstruct({
    name = "water",
    assets = {
        Asset("ANIM", "anim/siving_ctlwater.zip"),
        Asset("ANIM", "anim/firefighter_placement.zip"), --灭火器的placer圈
    },
    prefabs = { "siving_ctlwater_item", "siving_ctl_bar" },
    ctltype = 1,
    fn_server = function(inst)
        inst.components.botanycontroller.type = 1

        inst:WatchWorldState("israining", function(inst)
            inst.components.botanycontroller:SetValue(200, nil, true) --下雨/雪开始与结束时，直接恢复一定水分
        end)

        inst:DoTaskInTime(0, function()
            AddBar(inst, {
                barkey = "siv_bar",
                bank = "siving_ctlwater", build = "siving_ctlwater", anim = "bar",
                x = 0, y = -180, z = 0, scale = nil
            })
            inst.components.botanycontroller.onbarchange = function(botanyctl)
                SetBar(botanyctl.inst, "siv_bar", "bar", botanyctl.moisture, botanyctl.moisture_max)
            end

            inst:DoTaskInTime(0.5, function()
                inst.components.botanycontroller:onbarchange()
            end)
        end)
    end,
})

--------------------------------------------------------------------------
--[[ 子圭·益矩 ]]
--------------------------------------------------------------------------

MakeItem({
    name = "dirt",
    assets = {
        Asset("ANIM", "anim/siving_ctldirt.zip"),
        Asset("ATLAS", "images/inventoryimages/siving_ctldirt_item.xml"),
        Asset("IMAGE", "images/inventoryimages/siving_ctldirt_item.tex"),
        Asset("ANIM", "anim/firefighter_placement.zip"), --灭火器的placer圈
    },
    prefabs = { "siving_ctldirt" },
    sound = "dontstarve/common/winter_meter_craft",
})
MakeConstruct({
    name = "dirt",
    assets = {
        Asset("ANIM", "anim/siving_ctldirt.zip"),
        Asset("ANIM", "anim/firefighter_placement.zip"), --灭火器的placer圈
    },
    prefabs = { "siving_ctldirt_item", "siving_ctl_bar" },
    ctltype = 2,
    fn_server = function(inst)
        inst.components.botanycontroller.type = 2

        inst:DoTaskInTime(0, function()
            AddBar(inst, {
                barkey = "siv_bar1",
                bank = "siving_ctldirt", build = "siving_ctldirt", anim = "bar1",
                x = -48, y = -140, z = 0, scale = nil
            })
            AddBar(inst, {
                barkey = "siv_bar2",
                bank = "siving_ctldirt", build = "siving_ctldirt", anim = "bar2",
                x = -5, y = -140, z = 0, scale = nil
            })
            AddBar(inst, {
                barkey = "siv_bar3",
                bank = "siving_ctldirt", build = "siving_ctldirt", anim = "bar3",
                x = 39, y = -140, z = 0, scale = nil
            })
            inst.components.botanycontroller.onbarchange = function(botanyctl)
                SetBar(botanyctl.inst, "siv_bar1", "bar1", botanyctl.nutrients[1], botanyctl.nutrient_max)
                SetBar(botanyctl.inst, "siv_bar2", "bar2", botanyctl.nutrients[2], botanyctl.nutrient_max)
                SetBar(botanyctl.inst, "siv_bar3", "bar3", botanyctl.nutrients[3], botanyctl.nutrient_max)
            end

            inst:DoTaskInTime(0.5, function()
                inst.components.botanycontroller:onbarchange()
            end)
        end)
    end,
})

--------------------------------------------------------------------------
--[[ 子圭·崇溟 ]]
--------------------------------------------------------------------------

MakeItem({
    name = "all",
    assets = {
        Asset("ANIM", "anim/siving_ctlall.zip"),
        Asset("ATLAS", "images/inventoryimages/siving_ctlall_item.xml"),
        Asset("IMAGE", "images/inventoryimages/siving_ctlall_item.tex"),
        Asset("ANIM", "anim/firefighter_placement.zip"), --灭火器的placer圈
    },
    prefabs = { "siving_ctlall" },
    sound = "dontstarve/halloween_2018/madscience_machine/place",
})
MakeConstruct({
    name = "all",
    assets = {
        Asset("ANIM", "anim/siving_ctlall.zip"),
        Asset("ANIM", "anim/siving_ctlwater.zip"),
        Asset("ANIM", "anim/siving_ctldirt.zip"),
        Asset("ANIM", "anim/firefighter_placement.zip"), --灭火器的placer圈
    },
    prefabs = { "siving_ctlall_item", "siving_ctl_bar" },
    ctltype = 3,
    fn_server = function(inst)
        inst.components.botanycontroller.type = 3
        inst.components.botanycontroller.moisture_max = 6000
        inst.components.botanycontroller.nutrient_max = 2400

        inst:DoTaskInTime(0, function()
            AddBar(inst, {
                barkey = "siv_bar1",
                bank = "siving_ctldirt", build = "siving_ctldirt", anim = "bar1",
                x = -53, y = -335, z = 0, scale = nil
            })
            AddBar(inst, {
                barkey = "siv_bar2",
                bank = "siving_ctldirt", build = "siving_ctldirt", anim = "bar2",
                x = -10, y = -360, z = 0, scale = nil
            })
            AddBar(inst, {
                barkey = "siv_bar3",
                bank = "siving_ctldirt", build = "siving_ctldirt", anim = "bar3",
                x = 34, y = -335, z = 0, scale = nil
            })
            AddBar(inst, {
                barkey = "siv_bar4",
                bank = "siving_ctlwater", build = "siving_ctlwater", anim = "bar",
                x = -10, y = -297, z = 0, scale = nil
            })
            inst.components.botanycontroller.onbarchange = function(botanyctl)
                SetBar(botanyctl.inst, "siv_bar1", "bar1", botanyctl.nutrients[1], botanyctl.nutrient_max)
                SetBar(botanyctl.inst, "siv_bar2", "bar2", botanyctl.nutrients[2], botanyctl.nutrient_max)
                SetBar(botanyctl.inst, "siv_bar3", "bar3", botanyctl.nutrients[3], botanyctl.nutrient_max)
                SetBar(botanyctl.inst, "siv_bar4", "bar", botanyctl.moisture, botanyctl.moisture_max)
            end

            inst:DoTaskInTime(0.5, function()
                inst.components.botanycontroller:onbarchange()
            end)
        end)
    end,
})

--------------------------------------------------------------------------
--[[ 状态栏 ]]
--------------------------------------------------------------------------

table.insert(prefs, Prefab(
    "siving_ctl_bar",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        inst.entity:AddFollower()

        -- inst.AnimState:SetBank("siving_ctldirt")
        -- inst.AnimState:SetBuild("siving_ctldirt")
        -- inst.AnimState:PlayAnimation("bar2")

        inst:AddTag("FX")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false

        return inst
    end,
    nil,
    nil
))

--------------------------------------------------------------------------
--[[ 子圭·育 ]]
--------------------------------------------------------------------------

local function GetStatus_turn(inst)
    local cpt = inst.components.genetrans
    return (cpt == nil and "GENERIC")
        or (cpt.fruitnum > 0 and "DONE")
        or (cpt.energytime <= 0 and "NOENERGY")
        or (cpt.seed and "DOING")
        or "GENERIC"
end
local function OnWork_turn(inst, worker, workleft, numworks)
    local cpt = inst.components.genetrans
    if cpt.energytime > 0 and cpt.seed ~= nil then
        inst.AnimState:PlayAnimation("hit_on")
        inst.AnimState:PushAnimation("on", true)
    else
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle", false)
    end
end
local function OnBroken_turn(inst, needrecipe)
    inst.components.genetrans:DropLoot(needrecipe)
    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("rock")
    inst:Remove()
end
local function OnFinished_turn(inst)
    OnBroken_turn(inst, true)
end
local function OnDeconstruct_turn(inst, worker)
    OnBroken_turn(inst, false) --拆解机制自带建造材料的还原，所以这里不再还原材料
end

table.insert(prefs, Prefab(
    "siving_turn",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddLight()
        inst.entity:AddNetwork()

        MakeObstaclePhysics(inst, .35)

        inst.MiniMapEntity:SetIcon("siving_turn.tex")

        inst.Light:Enable(false)
        inst.Light:SetRadius(2)
        inst.Light:SetFalloff(1.5)
        inst.Light:SetIntensity(.5)
        inst.Light:SetColour(35/255, 167/255, 172/255)

        inst.AnimState:SetBank("siving_turn")
        inst.AnimState:SetBuild("siving_turn")
        inst.AnimState:PlayAnimation("idle")

        inst:AddTag("structure")
        inst:AddTag("genetrans")

        inst:AddComponent("skinedlegion")
        inst.components.skinedlegion:Init("siving_turn")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")
        inst.components.inspectable.getstatus = GetStatus_turn

        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

        inst:AddComponent("lootdropper")

        inst:AddComponent("genetrans") --实在不想做无谓的代码优化了，所以该组件与该实体的耦合性特别特别高

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(5)
        inst.components.workable:SetOnWorkCallback(OnWork_turn)
        inst.components.workable:SetOnFinishCallback(OnFinished_turn)

        inst:ListenForEvent("ondeconstructstructure", OnDeconstruct_turn)

        inst.components.skinedlegion:SetOnPreLoad()

        return inst
    end,
    { Asset("ANIM", "anim/siving_turn.zip") },
    { "siving_turn_fruit" }
))

table.insert(prefs, MakePlacer("siving_turn_placer", "siving_turn", "siving_turn", "idle",
    nil, nil, nil, nil, nil, nil, Skined_SetBuildPlacer_legion)
)

--------------------------------------------------------------------------
--[[ 子圭·育之果 ]]
--------------------------------------------------------------------------

table.insert(prefs, Prefab(
    "siving_turn_fruit",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        inst.entity:AddFollower()

        inst.AnimState:SetBank("siving_turn")
        inst.AnimState:SetBuild("siving_turn")
        inst.AnimState:SetPercent("fruit", 0)
        inst.AnimState:SetFinalOffset(3)

        inst:AddTag("FX")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false

        return inst
    end,
    nil,
    nil
))

--------------------------------------------------------------------------
--[[ 子圭·汲 ]]
--------------------------------------------------------------------------

local function CancelTask_life(inst, owner)
    if inst.task_life ~= nil then
        inst.task_life:Cancel()
        inst.task_life = nil
    end
    inst.lifetarget = nil
end
local function SpawnLifeFx(target, owner)
    local life = SpawnPrefab("siving_lifesteal_fx")
    if life ~= nil then
        life.movingTarget = owner
        life.minDistanceSq = 1.02
        life.Transform:SetPosition(target.Transform:GetWorldPosition())
    end
end

local function DrinkLife(mask, target, value)
    mask.healthcounter = math.min(mask.healthcounter_max, mask.healthcounter + value) --积累生命
    target.components.health:DoDelta(-value, true, mask.prefab, false, nil, true) --吸取生命
end
local function HealOwner(mask, owner)
    if
        owner.components.health ~= nil and
        not owner.components.health:IsDead() and owner.components.health:IsHurt()
    then
        owner.components.health:DoDelta(2, true, "debug_key", true, nil, true) --对旺达的回血只有特定原因才能成功
        mask.healthcounter = mask.healthcounter - 4
        return true
    end
    return false
end
local function HealArmor(mask)
    if
        mask.components.armor:GetPercent() < 1
        and mask.components.armor.Repair ~= nil --可能有些老mod改了 Repair 这个函数，导致出问题，这里预防一下
    then
        mask.components.armor:Repair(40)
        mask.healthcounter = mask.healthcounter - 20
        return true
    end
    return false
end

local function GetSwapSymbol(owner)
    local maps = {
        wolfgang = true,
        waxwell = true,
        wathgrithr = true,
        winona = true,
        wortox = true,
        wormwood = true,
        wurt = true,
        pigman = true,
        pigguard = true,
        moonpig = true,
        bunnyman = true,
        sewing_mannequin = true
    }
    if owner.sivmask_swapsymbol or maps[owner.prefab] then
        return "swap_other"
    else
        return "swap_hat"
    end
end

local function AddMaskHPCost(inst, owner, value)
    if owner.feather_l_reducer == nil then
        owner.feather_l_reducer = {}
    end
    owner.feather_l_reducer[inst.prefab] = value
end
local function DeleteMaskHPCost(inst, owner)
    if owner.feather_l_reducer == nil then
        return
    end
    owner.feather_l_reducer[inst.prefab] = nil
    for _,v in pairs(owner.feather_l_reducer) do
        if v then
            return
        end
    end
    owner.feather_l_reducer = nil
end

MakeMask({
    name = "siving_mask",
    assets = {
        Asset("ANIM", "anim/siving_mask.zip"),
        Asset("ATLAS", "images/inventoryimages/siving_mask.xml"),
        Asset("IMAGE", "images/inventoryimages/siving_mask.tex"),
    },
    prefabs = {
        "siving_lifesteal_fx"
    },
    fn_common = function(inst)
        inst:AddTag("siv_BF")
        inst:AddTag("siv_mask")
    end,
    fn_server = function(inst)
        inst.healthcounter_max = 80

        inst.components.equippable:SetOnEquip(function(inst, owner)
            HAT_OPENTOP_ONEQUIP_L(inst, owner, "siving_mask", GetSwapSymbol(owner))

            --假人兼容：这里不做截断，为了能开发一些新玩法

            AddMaskHPCost(inst, owner, 0.5)

            local notags = {
                "NOCLICK", "INLIMBO", "shadow", "shadowminion", "playerghost", "ghost", "wall",
                "balloon", "siving", "glommer", "friendlyfruitfly", "boat", "boatbumper", "structure"
            }
            if owner:HasTag("player") then --佩戴者是玩家时，不吸收其他玩家
                table.insert(notags, "player")
            end
            local _taskcounter = 0
            inst.task_life = inst:DoPeriodicTask(0.5, function(inst)
                if not owner:IsValid() then
                    CancelTask_life(inst, owner)
                    return
                end

                ----计数器管理
                _taskcounter = _taskcounter + 1
                local doit = false
                if _taskcounter % 4 == 0 then --每过两秒
                    doit = true
                    _taskcounter = 0
                end

                ----吸取对象的管理
                local x, y, z = owner.Transform:GetWorldPosition()
                local target = inst.lifetarget
                if --吸血对象失效了，重新找新对象
                    target == nil or not target:IsValid() or
                    target.components.health == nil or target.components.health:IsDead() or
                    target:GetDistanceSqToPoint(x, y, z) > 324 --18*18
                then
                    target = FindEntity(owner, 18, function(ent, finder)
                            if
                                ent.prefab ~= finder.prefab and --不吸收同类
                                ent.components.health ~= nil and not ent.components.health:IsDead()
                            then
                                return true
                            end
                        end,
                        {"_health"}, notags, nil
                    )
                    inst.lifetarget = target
                end

                ----积累的管理
                if target ~= nil then --有可吸收对象时
                    SpawnLifeFx(target, owner)
                    if doit then
                        DrinkLife(inst, target, 2)
                        if inst.healthcounter >= 4 then
                            if not HealOwner(inst, owner) then --优先为玩家恢复生命
                                if inst.healthcounter >= 20 then --其次才是恢复自己的耐久
                                    HealArmor(inst)
                                end
                            end
                        end
                    end
                else --不存在可吸收对象时
                    if doit then
                        if inst.components.armor:GetPercent() < 1 then --自己损坏了
                            if owner.components.health ~= nil and not owner.components.health:IsDead() then
                                DrinkLife(inst, owner, 2)
                            end
                            if inst.healthcounter >= 20 then
                                HealArmor(inst)
                            end
                        end
                    end
                end
            end, 1)
        end)
        inst.components.equippable:SetOnUnequip(function(inst, owner)
            HAT_ONUNEQUIP_L(inst, owner)
            DeleteMaskHPCost(inst, owner)
            CancelTask_life(inst, owner)
        end)

        inst.components.armor:InitCondition(315, 0.7)
    end
})

--------------------------------------------------------------------------
--[[ 子圭·歃 ]]
--------------------------------------------------------------------------

local function OnAttackOther(owner, data)
    if
        owner.components.inventory ~= nil and
        data.target ~= nil and data.target:IsValid() and
        data.target.components.health ~= nil and not data.target.components.health:IsDead() and
        not (
            data.target:HasTag("shadow") or
            data.target:HasTag("ghost") or
            data.target:HasTag("wall") or
            data.target:HasTag("structure") or
            data.target:HasTag("balloon")
        )
    then
        local mask = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
        if mask ~= nil and mask.prefab == "siving_mask_gold" then
            mask.lifetarget = data.target
        end
    end
end

local function CalcuCost(mask, doer, cost)
    if mask.healthcounter == nil then
        mask.healthcounter = 0
    elseif mask.healthcounter >= cost then
        mask.healthcounter = mask.healthcounter - cost
        return true
    else
        cost = cost - mask.healthcounter
    end

    if doer.components.health ~= nil then
        if doer.components.oldager ~= nil then --无语，还要考虑旺达
            if doer.components.health.currenthealth <= (cost*TUNING.OLDAGE_HEALTH_SCALE) then
                return false
            end
        elseif doer.components.health.currenthealth <= cost then
            return false
        end

        mask.healthcounter = 0
        doer.components.health:DoDelta(-cost, true, mask.prefab, false, nil, true)
        return true
    end

    return false
end

MakeMask({
    name = "siving_mask_gold",
    assets = {
        Asset("ANIM", "anim/siving_mask_gold.zip"),
        Asset("ATLAS", "images/inventoryimages/siving_mask_gold.xml"),
        Asset("IMAGE", "images/inventoryimages/siving_mask_gold.tex"),
    },
    prefabs = {
        "siving_lifesteal_fx",
        "life_trans_fx"
    },
    fn_common = function(inst)
        inst:AddTag("siv_BFF")
        inst:AddTag("siv_mask2")
    end,
    fn_server = function(inst)
        inst.healthcounter_max = 135

        inst.components.equippable:SetOnEquip(function(inst, owner)
            HAT_OPENTOP_ONEQUIP_L(inst, owner, "siving_mask_gold", GetSwapSymbol(owner))

            --假人兼容：这里不做截断，为了能开发一些新玩法

            AddMaskHPCost(inst, owner, 1)

            owner:ListenForEvent("onattackother", OnAttackOther)

            local notags = {
                "NOCLICK", "INLIMBO", "shadow", "shadowminion", "playerghost", "ghost", "wall",
                "balloon", "siving", "glommer", "friendlyfruitfly", "boat", "boatbumper", "structure"
            }
            if owner:HasTag("player") then --佩戴者是玩家时，不吸收其他玩家
                table.insert(notags, "player")
            end
            local _taskcounter = 0
            inst.task_life = inst:DoPeriodicTask(0.5, function(inst)
                if not owner:IsValid() then
                    CancelTask_life(inst, owner)
                    return
                end

                ----计数器管理
                _taskcounter = _taskcounter + 1
                local doit = false
                if _taskcounter % 4 == 0 then --每过两秒
                    doit = true
                    _taskcounter = 0
                end

                ----吸取对象的管理
                local x, y, z = owner.Transform:GetWorldPosition()
                local target = inst.lifetarget
                if --吸血对象失效了，重新找新对象
                    target == nil or not target:IsValid() or
                    target.components.health == nil or target.components.health:IsDead() or
                    target:GetDistanceSqToPoint(x, y, z) > 400 --20*20
                then
                    target = FindEntity(owner, 20, function(ent, finder)
                            if
                                ent.prefab ~= finder.prefab and --不吸收同类
                                ent.components.health ~= nil and not ent.components.health:IsDead() and (
                                    (ent.components.combat ~= nil and ent.components.combat.target == finder) or
                                    ( --不攻击驯化的对象、自己的跟随者
                                        (ent.components.domesticatable == nil or not ent.components.domesticatable:IsDomesticated()) and
                                        (finder.components.leader == nil or not finder.components.leader:IsFollower(ent))
                                    )
                                )
                            then
                                return true
                            end
                        end,
                        {"_health"}, notags, nil
                    )
                    inst.lifetarget = target
                end

                ----特效
                if target ~= nil then
                    SpawnLifeFx(target, owner)
                end

                ----积累的管理
                if doit then
                    if target ~= nil then
                        DrinkLife(inst, target, 4)
                    end
                    if inst.healthcounter >= 4 then
                        if not HealOwner(inst, owner) then --优先为玩家恢复生命
                            if inst.healthcounter >= 20 then --其次才是恢复自己的耐久
                                HealArmor(inst)
                            end
                        end
                    end
                end
            end, 1)
        end)
        inst.components.equippable:SetOnUnequip(function(inst, owner)
            HAT_ONUNEQUIP_L(inst, owner)
            DeleteMaskHPCost(inst, owner)
            CancelTask_life(inst, owner)
            owner:RemoveEventCallback("onattackother", OnAttackOther)
        end)

        inst.components.armor:InitCondition(735, 0.75)

        inst:AddComponent("lifebender") --御血神通！然而并不
        inst.components.lifebender.fn_bend = function(mask, doer, target, options)
            if target == nil or not target:IsValid() then
                return false
            end

            if target.prefab == "flower_withered" then --枯萎花
                if CalcuCost(mask, doer, 5) then
                    local flower = SpawnPrefab("planted_flower")
                    if flower ~= nil then
                        flower.Transform:SetPosition(target.Transform:GetWorldPosition())
                        target:Remove()
                        target = flower
                    end
                else
                    return false, "NOLIFE"
                end
            elseif target.prefab == "mandrake" then --死掉的曼德拉草
                if CalcuCost(mask, doer, 20) then
                    local flower = SpawnPrefab("mandrake_planted")
                    if flower ~= nil then
                        flower.Transform:SetPosition(target.Transform:GetWorldPosition())
                        flower:replant()
                        if target.components.stackable ~= nil then
                            target.components.stackable:Get():Remove()
                        else
                            target:Remove()
                        end
                        target = flower
                    end
                else
                    return false, "NOLIFE"
                end
            elseif target:HasTag("playerghost") then --玩家鬼魂
                if CalcuCost(mask, doer, 120) then
                    target:PushEvent("respawnfromghost", { source = mask, user = doer })
                    target.components.health:DeltaPenalty(TUNING.REVIVE_HEALTH_PENALTY)
                    target:DoTaskInTime(1, function()
                        local healthcpt = target.components.health
                        if healthcpt ~= nil and not healthcpt:IsDead() then
                            --旺达一样恢复10岁吧，因为她回血困难
                            healthcpt:SetVal(target.components.oldager == nil and 10 or 10/TUNING.OLDAGE_HEALTH_SCALE)
                            healthcpt:DoDelta(0, true, nil, true, nil, true)
                        end
                    end)
                else
                    return false, "NOLIFE"
                end
            elseif target:HasTag("ghost") then --幽灵
                return false, "GHOST"
            elseif target.components.health ~= nil then --有生命组件的对象
                if target.components.health:IsHurt() then
                    if CalcuCost(mask, doer, 20) then
                        target.components.health:DoDelta(15, true, mask.prefab, true, nil, true)
                    else
                        return false, "NOLIFE"
                    end
                else
                    return false, "NOTHURT"
                end
            elseif target:HasTag("weed") then --杂草
                if target.components.growable ~= nil then
                    local growable = target.components.growable
                    if
                        growable.stages and growable.stages[growable.stage] ~= nil and
                        growable.stages[growable.stage].name == "bolting"
                    then
                        if CalcuCost(mask, doer, 5) then
                            growable:SetStage(growable:GetStage() - 1) --回到上一个阶段
                            growable:StartGrowing()
                        else
                            return false, "NOLIFE"
                        end
                    else
                        return false, "NOWITHERED"
                    end
                else
                    return false, "NOWITHERED"
                end
            elseif target.components.farmplantstress ~= nil then --作物
                if
                    target.components.growable ~= nil and
                    target:HasTag("pickable_harvest_str") --这个标签代表作物腐烂了
                then
                    if CalcuCost(mask, doer, 5) then
                        local growable = target.components.growable
                        growable:SetStage(growable:GetStage() - 1) --回到上一个阶段
                        growable:StartGrowing()
                    else
                        return false, "NOLIFE"
                    end
                else
                    return false, "NOWITHERED"
                end
            elseif target.components.perennialcrop ~= nil then --子圭垄植物
                local cpt = target.components.perennialcrop
                if cpt.isrotten then
                    if CalcuCost(mask, doer, 5) then
                        cpt:SetStage(cpt.stage, cpt.ishuge, false, true, false)
                        if cpt.timedata.paused then
                            cpt.timedata.left = nil --不用管，StartGrowing()时会自动设置的
                            cpt.timedata.start = nil
                            cpt.timedata.all = nil
                        else
                            cpt:StartGrowing()
                        end
                    else
                        return false, "NOLIFE"
                    end
                else
                    return false, "NOWITHERED"
                end
            elseif target.components.perennialcrop2 ~= nil then --异种植物
                local cpt = target.components.perennialcrop2
                if cpt.isrotten then
                    if CalcuCost(mask, doer, 5) then
                        cpt:SetStage(cpt.stage, false, false)
                        cpt:StartGrowing()
                    else
                        return false, "NOLIFE"
                    end
                else
                    return false, "NOWITHERED"
                end
            elseif target.components.witherable ~= nil or target.components.pickable ~= nil then --普通植物
                if target.components.pickable ~= nil then
                    if target.components.pickable:CanBeFertilized() then --贫瘠或缺水枯萎
                        if CalcuCost(mask, doer, 5) then
                            local poop = SpawnPrefab("poop")
                            if poop ~= nil then
                                target.components.pickable:Fertilize(poop, nil)
                                poop:Remove()
                            end
                        else
                            return false, "NOLIFE"
                        end
                    else
                        return false, "NOWITHERED"
                    end
                else
                    if target.components.witherable:CanRejuvenate() then --缺水枯萎
                        if CalcuCost(mask, doer, 5) then
                            target.components.witherable:Protect(TUNING.FIRESUPPRESSOR_PROTECTION_TIME)
                        else
                            return false, "NOLIFE"
                        end
                    else
                        return false, "NOWITHERED"
                    end
                end
            end

            local fx = SpawnPrefab("life_trans_fx")
            if fx ~= nil then
                fx.Transform:SetPosition(target.Transform:GetWorldPosition())
            end
            if doer.SoundEmitter ~= nil then
                doer.SoundEmitter:PlaySound("monkeyisland/wonkycurse/curse_fx")
            end

            return true
        end
    end
})

--------------------
--------------------

return unpack(prefs)
