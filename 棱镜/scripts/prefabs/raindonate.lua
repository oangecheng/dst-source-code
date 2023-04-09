local assets = {
    Asset("ANIM", "anim/raindonate.zip"),
    Asset("ATLAS", "images/inventoryimages/raindonate.xml"),
    Asset("IMAGE", "images/inventoryimages/raindonate.tex"),
    Asset("ANIM", "anim/mosquito.zip") --官方蚊子动画模板
}
local prefabs = {
    "ahandfulofwings"
}
local brain = require("brains/raindonatebrain")
local sounds = {
    takeoff = "dontstarve_DLC001/creatures/dragonfly/fly",
    --attack = "dontstarve_DLC001/creatures/dragonfly/fly",
    buzz = "dontstarve_DLC001/creatures/dragonfly/fly", --飞行时的配音，龙蝇扇翅膀的声音
    --hit = "dontstarve/creatures/mosquito/mosquito_hurt",
    --death = "dontstarve/creatures/mosquito/mosquito_death",
    --explode = "dontstarve/creatures/mosquito/mosquito_explo",
}

SetSharedLootTable('raindonate', {
    {'ahandfulofwings', 0.33},
})

local function OnWorked(inst, worker)
    local owner = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    if owner ~= nil and owner.components.childspawner ~= nil then   --通知“home”,自己被抓/死了
        owner.components.childspawner:OnChildKilled(inst)
    end

    if worker.components.inventory ~= nil then
        worker.components.inventory:GiveItem(inst, nil, inst:GetPosition())
    end
end

local function StartBuzz(inst)  --醒来时开始扇翅膀声
    if not inst.components.inventoryitem:IsHeld() then
        inst.SoundEmitter:PlaySound(inst.sounds.buzz, "buzz")
    end
end

local function StopBuzz(inst)   --睡觉时停止扇翅膀声
    inst.SoundEmitter:KillSound("buzz")
end

local function OnDropped(inst)  --被丢在地上时
    inst.sg:GoToState("idle")

    if inst.components.workable ~= nil then
        inst.components.workable:SetWorkLeft(1)
    end
    if inst.brain ~= nil then
        inst.brain:Start()
    end
    if inst.sg ~= nil then
        inst.sg:Start()
    end

    if inst.components.knownlocations ~= nil then --被丢弃时重新标记家的位置
        inst.components.knownlocations:RememberLocation("home", inst:GetPosition())
    end
end

local function OnPickedUp(inst)
    inst.SoundEmitter:KillSound("buzz")
    if inst.components.homeseeker then
        inst.components.homeseeker:SetHome(nil)
        inst:RemoveComponent("homeseeker")
    end
end

local function KillerRetarget(inst) --主动寻找生物来攻击
    return FindEntity(inst, SpringCombatMod(20),
        function(guy)
            return inst.components.combat:CanTarget(guy)
        end,
        { "_combat", "_health", "smallcreature" },   --必须有的标签
        { "INLIMBO", "raindonate" },    --不能有的标签
        { "insect" })   --必须有至少其中一个的标签
end

local function SwapBelly(inst, size)    --换身体部分的贴图
    for i = 1, 4 do
        if i == size then
            inst.AnimState:Show("body_"..tostring(i))
        else
            inst.AnimState:Hide("body_"..tostring(i))
        end
    end
end

local function HuntingBug(inst, data) --攻击时,直接杀死小型昆虫
    if data.target:HasTag("smallcreature") and data.target:HasTag("insect") then
        if data.target.components.health ~= nil and not data.target.components.health:IsDead() then
            data.target.components.health:DoDelta(-data.target.components.health.currenthealth, nil, inst.prefab, true, nil, true)
        end

        if inst.components.health ~= nil and inst.components.health:GetPercent() < 1 then
            inst.components.health:DoDelta(150, false, "hunting")
        end
    end
end

-- local function OnAttacked(inst, data)   --被攻击时，记仇
--     inst.components.combat:SetTarget(data.attacker)
-- end

-- local function OnHealthDelta(inst, old_percent, percent)   --血量变化时
--     if inst.components.health and inst.components.health:IsDead() then   
--         if math.random() <= 0.33 then --33%几率下雨/雪
--             TheWorld:PushEvent("ms_forceprecipitation", true)
--         end
--     end
-- end

local function OnDeath(inst)
    if math.random() < 0.33 then --33%几率下雨/雪
        TheWorld:PushEvent("ms_forceprecipitation", true)
    end
end

local function raindonate()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLightWatcher()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeFlyingCharacterPhysics(inst, 1, .5)

    inst.DynamicShadow:SetSize(.8, .5)
    inst.Transform:SetFourFaced()

    inst:AddTag("raindonate")
    inst:AddTag("insect")   --昆虫标签
    inst:AddTag("flying")
    inst:AddTag("smallcreature")
    inst:AddTag("cattoyairborne")
    inst:AddTag("ignorewalkableplatformdrowning")

    inst.AnimState:SetBank("mosquito")  --使用官方的动画模板，因为反编译出来的动画模板有很多问题
    inst.AnimState:SetBuild("raindonate")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetRayTestOnBB(true) --可点击范围变大？

    MakeInventoryFloatable(inst)
    MakeFeedableSmallLivestockPristine(inst) --可以在背包里被喂食

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:SetBrain(brain)

    inst:AddComponent("locomotor") --速度组件一定要写在sg声明之前
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.walkspeed = 12    --苍蝇是8
    inst.components.locomotor.runspeed = 18 --苍蝇是12

    inst:SetStateGraph("SGraindonate")

    inst.sounds = sounds

    inst.OnEntityWake = StartBuzz
    inst.OnEntitySleep = StopBuzz

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem.canbepickedupalive = true
    inst.components.inventoryitem.pushlandedevents = false
    inst.components.inventoryitem.imagename = "raindonate"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/raindonate.xml"

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('raindonate')

    -- inst:AddComponent("stackable")

    inst:AddComponent("tradable")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.NET) --用网捕捉
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(OnWorked)

    MakeSmallBurnableCharacter(inst, "body", Vector3(0, -1, 1))
    MakeTinyFreezableCharacter(inst, "body", Vector3(0, -1, 1))

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(150) --苍蝇是100
    -- inst.components.health.ondelta = OnHealthDelta

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "body"
    inst.components.combat:SetDefaultDamage(10) --苍蝇是3
    inst.components.combat:SetRange(2.5)  --苍蝇是1.75
    inst.components.combat:SetAttackPeriod(TUNING.MOSQUITO_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(2, KillerRetarget)
    -- inst.components.combat:SetPlayerStunlock(PLAYERSTUNLOCK.RARELY)

    inst:ListenForEvent("onattackother", HuntingBug)
    SwapBelly(inst, 1)

    MakeHauntablePanic(inst)

    inst:AddComponent("sleeper")
    inst.components.sleeper.watchlight = true

    inst:AddComponent("knownlocations")

    inst:AddComponent("inspectable")

    -- inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("death", OnDeath)
    inst.fn_murdered_l = OnDeath

    MakeFeedableSmallLivestock(inst, TUNING.TOTAL_DAY_TIME * 2, OnPickedUp, OnDropped)

    return inst
end

return Prefab("raindonate", raindonate, assets, prefabs)
