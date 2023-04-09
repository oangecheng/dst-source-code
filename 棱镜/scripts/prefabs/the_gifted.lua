--------------------------------------------------------------------------
--[[ 韦伯 ]]
--------------------------------------------------------------------------

local assets_creep_item =
{
    Asset("ANIM", "anim/web_hump.zip"),
    Asset("ATLAS", "images/inventoryimages/web_hump_item.xml"),
    Asset("IMAGE", "images/inventoryimages/web_hump_item.tex"),
}

local prefabs_creep_item =
{
    "web_hump",
}

local function OnDeploy_creep_item(inst, pt, deployer)
    local tree = SpawnPrefab("web_hump")
    if tree ~= nil then
        tree.Transform:SetPosition(pt:Get())
        inst.components.stackable:Get():Remove()

        if deployer ~= nil and deployer.SoundEmitter ~= nil then
            deployer.SoundEmitter:PlaySound("dontstarve/creatures/spider/spider_egg_sack")
        end
    end
end

local function fn_creep_item()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    -- inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("web_hump")
    inst.AnimState:SetBuild("web_hump")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("cattoy")

    MakeInventoryFloatable(inst, "med", 0.3, 0.65)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "web_hump_item"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/web_hump_item.xml"
    -- inst.components.inventoryitem:SetOnPickupFn(function(inst)
    --     inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spider_egg_sack")
    -- end)

    inst:AddComponent("tradable")

    inst:AddComponent("deployable")
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.NONE)
    inst.components.deployable.ondeploy = OnDeploy_creep_item

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndIgnite(inst)

    return inst
end

----------
----------

local assets_creep =
{
    Asset("ANIM", "anim/web_hump.zip"),
}

local prefabs_creep =
{
    "web_hump_item",
    "silk",
}

local function OnWork_creep(inst, worker)
    if worker.components.talker ~= nil then
        worker.components.talker:Say(GetString(worker, "DESCRIBE", { "WEB_HUMP", "TRYDIGUP" }))
    end

    if worker:HasTag("spiderwhisperer") then    --只有蜘蛛人可以挖起
        inst.components.workable.workleft = 0
    else
        inst.components.workable:SetWorkLeft(10)    --恢复工作量，永远都破坏不了
    end
end

local function OnDigUp_creep(inst, worker)
    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:SpawnLootPrefab("web_hump_item")

        if inst.components.upgradeable ~= nil and inst.components.upgradeable.stage > 1 then
            for k = 1, inst.components.upgradeable.stage do
                inst.components.lootdropper:SpawnLootPrefab("silk")
            end
        end
    end
    inst:Remove()
end

local function FindSpiderdens(inst)
    inst.spiderdens = {}
    inst.lasttesttime = GetTime()
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 25, nil, { "DECOR", "NOCLICK", "FX", "INLIMBO" })
    for i, ent in pairs(ents) do
        if ent ~= inst then
            if ent:HasTag("spiderden") or ent.prefab == "spiderhole" then
                table.insert(inst.spiderdens, ent)
            end
        end
    end
end

local function Warning(inst, data)
    if data == nil or data.target == nil or inst.testlock then
        return
    end

    inst.testlock = true

    if GetTime() - inst.lasttesttime >= 180 then --每3分钟才更新能响应的蜘蛛巢
        FindSpiderdens(inst)
    end

    if inst.spiderdens ~= nil then
        for i, ent in pairs(inst.spiderdens) do
            if ent ~= nil and ent:IsValid() then
                ent:PushEvent("creepactivate", { target = data.target })
            end
        end
    end

    inst.testlock = false
end

local function OnStageAdvance_creep(inst)
    if inst.components.upgradeable ~= nil then
        local creep_size =
        {
            5, 8, 10, 12, 13,
        }

        inst.GroundCreepEntity:SetRadius(creep_size[inst.components.upgradeable.stage] or 3)
    end
end

local function OnLoad_creep(inst, data)
    OnStageAdvance_creep(inst)
end

local function fn_creep()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddGroundCreepEntity()
    inst.entity:AddNetwork()

    inst:AddTag("NOBLOCK")  --不妨碍玩家摆放建筑物，即使没有添加物理组件也需要这个标签

    inst.AnimState:SetBank("web_hump")
    inst.AnimState:SetBuild("web_hump")
    inst.AnimState:PlayAnimation("anim")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.spiderdens = {}
    inst.lasttesttime = 0

    inst:DoTaskInTime(0, FindSpiderdens)

    inst.GroundCreepEntity:SetRadius(5)

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(10)
    inst.components.workable:SetOnWorkCallback(OnWork_creep)
    inst.components.workable:SetOnFinishCallback(OnDigUp_creep)

    inst:AddComponent("upgradeable")
    inst.components.upgradeable.upgradetype = UPGRADETYPES.SPIDER
    -- inst.components.upgradeable.onupgradefn = OnUpgrade --升级时的函数
    inst.components.upgradeable.onstageadvancefn = OnStageAdvance_creep --到下一阶段时的函数
    inst.components.upgradeable.numstages = 5 --总阶段数
    inst.components.upgradeable.upgradesperstage = 2 --到下一阶段的升级次数

    inst:ListenForEvent("creepactivate", Warning)

    MakeHauntableLaunch(inst)

    inst.OnLoad = OnLoad_creep

    return inst
end

--------------------------------------------------------------------------
--[[ 沃托克斯 ]]
--------------------------------------------------------------------------

local wortox_soul_common = require("prefabs/wortox_soul_common")
local brain_contracts = require("brains/soul_contractsbrain")

local assets_contracts = {
    Asset("ANIM", "anim/book_maxwell.zip"), --官方暗影秘典动画模板
    Asset("ANIM", "anim/soul_contracts.zip"),
    Asset("ATLAS", "images/inventoryimages/soul_contracts.xml"),
    Asset("IMAGE", "images/inventoryimages/soul_contracts.tex"),
    Asset("SOUND", "sound/together.fsb"),   --官方音效包
    Asset("SCRIPT", "scripts/prefabs/wortox_soul_common.lua"), --官方灵魂通用功能函数文件
}
local prefabs_contracts = {
    "wortox_soul_heal_fx",
    "wortox_soul",          --物品栏里的灵魂
    -- "wortox_soul_spawn",    --地面的灵魂
    -- "wortox_eat_soul_fx",
    "l_soul_fx",    --灵魂被吸收时的特效
}

-----

local function ContractsDoHeal(inst)
    wortox_soul_common.DoHeal(inst)
end

local function UpadateHealTag(inst)
    local shouldheal = false
    local x, y, z = inst.Transform:GetWorldPosition()
    for _,v in ipairs(AllPlayers) do
        if
            v.entity:IsVisible() and
            not v:HasTag("health_as_oldage") and --旺达没法被加血，所以不管她了
            not (v.components.health:IsDead() or v:HasTag("playerghost") or v.components.health.invincible) and
            (v.components.health:GetMaxWithPenalty() - v.components.health.currenthealth) >= 10 and
            v:GetDistanceSqToPoint(x, y, z) < TUNING.WORTOX_SOULHEAL_RANGE * TUNING.WORTOX_SOULHEAL_RANGE --64
        then
            shouldheal = true
            break
        end
    end
    if shouldheal then
        inst._needheal = true
    else
        inst._needheal = false
    end
end

local function StartUpadateHealTag(inst)
    if inst._taskheal == nil then
        inst._needheal = false
        inst._taskheal = inst:DoPeriodicTask(0.6, UpadateHealTag, 1)
    end
end

local function StopUpadateHealTag(inst)
    if inst._taskheal ~= nil then
        inst._taskheal:Cancel()
        inst._taskheal = nil
    end
    inst._needheal = false
end

-----

local function FindItemWithoutContainer(inst, fn)
    local inventory = inst.components.inventory

    for k,v in pairs(inventory.itemslots) do
        if v and fn(v) then
            return v
        end
    end
    if inventory.activeitem and fn(inventory.activeitem) then
        return inventory.activeitem
    end
end
local function OnWortoxGetContracts(inst, owner)
    --寻找包里的其他契约书
    local otherbook = FindItemWithoutContainer(owner, function(item)
        if item:HasTag("soulcontracts") and item ~= inst then
            return true
        end
        return false
    end)

    --每个玩家最多拥有1本契约书
    if otherbook ~= nil then
        owner:DoTaskInTime(0.2, function()
            owner.components.inventory:DropItem(inst)
            if owner.components.talker ~= nil then
                owner.components.talker:Say(GetString(owner, "DESCRIBE", { "SOUL_CONTRACTS", "ONLYONE" }))
            end
        end)

        return
    end

    --实现契约丢地上时自动跟随玩家
    if owner.components.leader ~= nil then
        owner.components.leader:RemoveFollowersByTag("soulcontracts") --清除已有跟随的契约书
        owner.components.leader:AddFollower(inst) --提前设定跟随者，因为丢弃时已经获取不到owner了
    else
        inst.components.follower:SetLeader(owner)
    end
end

local function OnPutInInventory_contracts(inst) --放进物品栏时(在鼠标和格子相互切换时也会触发)
    StopUpadateHealTag(inst)

    --因为契约书只能放进物品栏，不存在多级owner情况(物品->包裹->背包->玩家)，所以这里可以直接获取玩家
    local owner = inst.components.inventoryitem.owner
    if owner ~= nil and owner:HasTag("player") then
        OnWortoxGetContracts(inst, owner)
    end
end

-- local function setDropPostion(inst, time)
--     inst:DoTaskInTime(time, function ()
--         if inst.components.follower:GetLeader() ~= nil and inst.Physics ~= nil then
--             -- inst.Transform:SetPosition(inst.components.follower:GetLeader().Transform:GetWorldPosition())
--             inst.Physics:Teleport(inst.components.follower:GetLeader().Transform:GetWorldPosition())
--         end
--     end)
-- end

local function OnDropped_contracts(inst) --丢在地上时
    if inst.sg ~= nil then
        inst.sg:GoToState("powerdown")
    end

    if inst.components.finiteuses:GetUses() > 0 then
        StartUpadateHealTag(inst)
    else
        StopUpadateHealTag(inst)
    end

    -- if inst.components.follower:GetLeader() ~= nil then --当初为啥要重新设定一遍位置呢，难道是跟随组件的问题？
    --     setDropPostion(inst, FRAMES * 6)
    -- end
end

-----

local function OnHaunt_contracts(inst, haunter) --被作祟时
    if math.random() <= 0.2 and inst.components.finiteuses:GetPercent() < 1 then
        inst.components.finiteuses:SetUses(inst.components.finiteuses:GetUses() + 1)
    elseif inst.components.finiteuses:GetUses() > 0 then
        inst._needheal = true
    end
    inst.components.hauntable.hauntvalue = TUNING.HAUNT_TINY
    return true
end

-----

local function SoulLeaking(inst, posInst) --释放全部灵魂
    if inst.components.finiteuses:GetUses() <= 0 then
        return
    end

    local x, y, z = posInst.Transform:GetWorldPosition()
    for k = 1, inst.components.finiteuses:GetUses() do
        local soul = SpawnPrefab("wortox_soul")
        soul.Transform:SetPosition(x, y, z)
        if soul.components.inventoryitem ~= nil then
            soul.components.inventoryitem:OnDropped(true) --传true是为了随机位置掉落
        end
    end
end

local function FuelTaken_contracts(inst, taker) --被当作燃料消耗时
    SoulLeaking(inst, taker)
    StopUpadateHealTag(inst)
end

-----

local function PercentChanged_contracts(inst, data) --耐久变化时
    if data ~= nil and data.percent ~= nil then
        if data.percent <= 0 then --耐久用光
            if not inst:HasTag("nosoulleft") then
                inst:AddTag("nosoulleft")
            end

            StopUpadateHealTag(inst)
        else --还有耐久
            if inst:HasTag("nosoulleft") then
                inst:RemoveTag("nosoulleft")
            end

            if inst.components.inventoryitem.owner == nil then --不在背包里时
                StartUpadateHealTag(inst)
            end
        end
    end
end

local function fn_contracts()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeFlyingCharacterPhysics(inst, 1, .5)

    inst.AnimState:SetBank("book_maxwell")
    inst.AnimState:SetBuild("soul_contracts")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("soulcontracts")
    inst:AddTag("ignorewalkableplatformdrowning")
    inst:AddTag("NOBLOCK")
    inst:AddTag("flying")
    inst:AddTag("bookstaying")
    inst:AddTag("meteor_protection") --防止被流星破坏
    inst:AddTag("NORATCHECK") --mod兼容：永不妥协。该道具不算鼠潮分

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:Init("soul_contracts")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst._needheal = false
    inst._taskheal = nil
    StartUpadateHealTag(inst)
    inst._dd = { fx = "l_soul_fx" }

    inst._SoulHealing = ContractsDoHeal

    inst:AddComponent("inspectable")

    inst:AddComponent("follower")
    inst.components.follower.keepdeadleader = true
    inst.components.follower.keepleaderduringminigame = true

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.canonlygoinpocket = true --只能放进物品栏中，不能放进箱子、背包等容器内
    inst.components.inventoryitem.imagename = "soul_contracts"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/soul_contracts.xml"
    inst.components.inventoryitem.pushlandedevents = false
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem.canbepickedup = false

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(40)
    inst.components.finiteuses:SetUses(40)
    inst:ListenForEvent("percentusedchange", PercentChanged_contracts)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL
    inst.components.fuel:SetOnTakenFn(FuelTaken_contracts)

    inst:AddComponent("hauntable")
    inst.components.hauntable.cooldown = TUNING.HAUNT_COOLDOWN_SMALL
    inst.components.hauntable:SetOnHauntFn(OnHaunt_contracts)

    inst:AddComponent("soulcontracts")

    inst:ListenForEvent("onputininventory", OnPutInInventory_contracts)
    inst:ListenForEvent("ondropped", OnDropped_contracts)

    inst:SetBrain(brain_contracts)
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor.pathcaps = { ignorewalls = true, allowocean = true } --能直接穿墙移动
    inst.components.locomotor.walkspeed = 8
    inst.components.locomotor.runspeed = 8
    inst:SetStateGraph("SGsoul_contracts")

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

--------------------------------------------------------------------------
--[[ 威尔逊 ]]
--------------------------------------------------------------------------

local assets_elecrazor =
{
    -- Asset("ANIM", "anim/elecrazor.zip"),
    -- Asset("ATLAS", "images/inventoryimages/elecrazor.xml"),
    -- Asset("IMAGE", "images/inventoryimages/elecrazor.tex"),
    Asset("ANIM", "anim/razor.zip"),
    Asset("ANIM", "anim/swap_razor.zip"),
}

-- local prefabs_elecrazor =
-- {
-- }

local function fn_elecrazor()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    -- inst.AnimState:SetBank("elecrazor")
    -- inst.AnimState:SetBuild("elecrazor")
    inst.AnimState:SetBank("razor")
    inst.AnimState:SetBuild("razor")
    inst.AnimState:PlayAnimation("idle")

    -- inst:AddTag("soulcontracts")

    -- MakeInventoryFloatable(inst, "small", 0.1, 0.75)
    -- MakeInventoryFloatable(inst, "med", 0.3, 0.65)
    MakeInventoryFloatable(inst, "small", 0.08, {0.9, 0.7, 0.9}, true, -2, {sym_build = "swap_razor"})

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem.imagename = "elecrazor"
    -- inst.components.inventoryitem.atlasname = "images/inventoryimages/elecrazor.xml"

    -- inst:AddComponent("finiteuses")
    -- inst.components.finiteuses:SetMaxUses(20)
    -- inst.components.finiteuses:SetUses(20)
    -- inst:ListenForEvent("percentusedchange", PercentChanged_contracts)

    -- inst:AddComponent("shaver")

    --除了玩家，都得是睡眠状态才能剃毛；玩家之间互相剃毛会额外增加双方精神值
    --对于没有Beard组件的男性玩家，添加Beard组件，只有1个胡须的收获量，但是会恢复精神值额，gay gay的
    --普通动物【添加Shaveable组件，刮一次之后删除Shaveable组件】：普通兔子-胡须；怪物兔子-2胡须；雪兔-兔毛；啜食者-啜食者皮；小鹅-鹅毛；各种鸟-对应羽毛；兔人-兔毛
    --自带可刮毛机制的【增加收获数量】：牛；藤壶花；威尔逊/韦伯-精细到下个阶段
    --大型生物【添加Beard组件】：蜘蛛女王-2~5蜘蛛网，0.1几率蜘蛛巢；熊獾-4~8皮屑，0.01几率熊皮；鹿鹅-2~5鹅毛

    MakeHauntableLaunch(inst)

    return inst
end

--------------------------------------------------------------------------
--[[ 薇诺娜 ]]
--------------------------------------------------------------------------

--全息组件

--------------------------------------------------------------------------
--[[ 沃姆伍德 ]]
--------------------------------------------------------------------------

--花园铲

--------------------------------------------------------------------------
--[[ 沃利 ]]
--------------------------------------------------------------------------

--便携式烧烤架

-----
-----

return Prefab("web_hump_item", fn_creep_item, assets_creep_item, prefabs_creep_item),
        MakePlacer("web_hump_item_placer", "web_hump", "web_hump", "anim"),
        Prefab("web_hump", fn_creep, assets_creep, prefabs_creep),
        Prefab("soul_contracts", fn_contracts, assets_contracts, prefabs_contracts)
        -- Prefab("elecrazor", fn_elecrazor, assets_elecrazor, nil)
