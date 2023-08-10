local prefs = {}

--------------------------------------------------------------------------
--[[ 通用函数 ]]
--------------------------------------------------------------------------

local function StartTimer_attach(buff, target, timekey, timedefault)
    --因为是新加buff，不需要考虑buff时间问题
    if timekey == nil or target[timekey] == nil then
        if not buff.components.timer:TimerExists("buffover") then --因为onsave比这里先加载，所以不能替换先加载的
            buff.components.timer:StartTimer("buffover", timedefault)
        end
    else
        if not buff.components.timer:TimerExists("buffover") then
            local times = target[timekey]
            if times.add ~= nil then
                times = times.add
            elseif times.replace ~= nil then
                times = times.replace
            elseif times.replace_min ~= nil then
                times = times.replace_min
            else
                buff:DoTaskInTime(0, function()
                    buff.components.debuff:Stop()
                end)
                target[timekey] = nil
                return
            end
            buff.components.timer:StartTimer("buffover", times)
        end
        target[timekey] = nil
    end
end

local function StartTimer_extend(buff, target, timekey, timedefault)
    --因为是续加buff，需要考虑buff时间的更新方式
    if timekey == nil or target[timekey] == nil then
        buff.components.timer:StopTimer("buffover")
        buff.components.timer:StartTimer("buffover", timedefault)
    else
        local times = target[timekey]
        target[timekey] = nil
        if times.add ~= nil then --增加型：在已有时间上增加，可设置最大时间限制
            local timeleft = buff.components.timer:GetTimeLeft("buffover") or 0
            timeleft = timeleft + times.add

            if times.max ~= nil and timeleft > times.max then
                timeleft = times.max
            end
            buff.components.timer:StopTimer("buffover")
            buff.components.timer:StartTimer("buffover", timeleft)
        elseif times.replace ~= nil then --替换型：不管已有时间，直接设置
            buff.components.timer:StopTimer("buffover")
            buff.components.timer:StartTimer("buffover", times.replace)
        elseif times.replace_min ~= nil then --最小替换型：若已有时间<该时间时才设置新时间（比较建议的类型）
            local timeleft = buff.components.timer:GetTimeLeft("buffover") or 0
            if timeleft < times.replace_min then
                buff.components.timer:StopTimer("buffover")
                buff.components.timer:StartTimer("buffover", times.replace_min)
            end
        end
    end
end

local function InitTimerBuff(inst, data)
    inst.components.debuff:SetAttachedFn(function(inst, target, ...)
        inst.entity:SetParent(target.entity)
        inst.Transform:SetPosition(0, 0, 0) --in case of loading
        inst:ListenForEvent("death", function()
            inst.components.debuff:Stop()
        end, target)

        StartTimer_attach(inst, target, data.time_key, data.time_default)

        if data.fn_start ~= nil then
            data.fn_start(inst, target, ...)
        end
    end)
    inst.components.debuff:SetDetachedFn(function(inst, target)
        if data.fn_end ~= nil then
            data.fn_end(inst, target)
        end
        inst:Remove()
    end)
    inst.components.debuff:SetExtendedFn(function(inst, target, ...)
        StartTimer_extend(inst, target, data.time_key, data.time_default)

        if data.fn_again ~= nil then
            data.fn_again(inst, target, ...)
        end
    end)

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", function(inst, data)
        if data.name == "buffover" then
            inst.components.debuff:Stop()
        end
    end)
end

local function InitNoTimerBuff(inst, data)
    inst.components.debuff:SetAttachedFn(function(inst, target, ...)
        inst.entity:SetParent(target.entity)
        inst.Transform:SetPosition(0, 0, 0) --in case of loading
        inst:ListenForEvent("death", function()
            inst.components.debuff:Stop()
        end, target)

        if data.fn_start ~= nil then
            data.fn_start(inst, target, ...)
        end
    end)
    inst.components.debuff:SetDetachedFn(function(inst, target)
        if data.fn_end ~= nil then
            data.fn_end(inst, target)
        end
        inst:Remove()
    end)
    inst.components.debuff:SetExtendedFn(function(inst, target, ...)
        if data.fn_again ~= nil then
            data.fn_again(inst, target, ...)
        end
    end)
end

local function MakeBuff(data)
	table.insert(prefs, Prefab(
		data.name,
		function()
            local inst = CreateEntity()

            if data.addnetwork then --带有网络组件
                inst.entity:AddTransform()
                inst.entity:AddNetwork()
                -- inst.entity:Hide()
                inst.persists = false

                -- inst:AddTag("CLASSIFIED")
                inst:AddTag("NOCLICK")
                inst:AddTag("NOBLOCK")

                if data.fn_common ~= nil then
                    data.fn_common(inst)
                end

                inst.entity:SetPristine()
                if not TheWorld.ismastersim then
                    return inst
                end
            else --无网络组件
                if not TheWorld.ismastersim then
                    --Not meant for client!
                    inst:DoTaskInTime(0, inst.Remove)
                    return inst
                end
                inst.entity:AddTransform()
                --Non-networked entity
                inst.entity:Hide()
                inst.persists = false
                inst:AddTag("CLASSIFIED")
            end

            inst:AddComponent("debuff")
            inst.components.debuff.keepondespawn = true
            if data.notimer then
                InitNoTimerBuff(inst, data)
            else
                InitTimerBuff(inst, data)
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

-----

local function BuffTalk_start(target, buff)
    target:PushEvent("foodbuffattached", { buff = "ANNOUNCE_ATTACH_"..string.upper(buff.prefab), priority = 1 })
end
local function BuffTalk_end(target, buff)
    target:PushEvent("foodbuffdetached", { buff = "ANNOUNCE_DETACH_"..string.upper(buff.prefab), priority = 1 })
end

local function IsAlive(inst)
    return inst.components.health ~= nil and not inst.components.health:IsDead() and not inst:HasTag("playerghost")
end

--------------------------------------------------------------------------
--[[ 蝙蝠伪装：不会被蝙蝠攻击 ]]
--------------------------------------------------------------------------

MakeBuff({
    name = "buff_batdisguise",
    assets = nil,
    prefabs = nil,
    time_key = "time_l_batdisguise",
    time_default = TUNING.SEG_TIME*8, --SEG_TIME = 30秒 = 0.5分钟
    notimer = nil,
    fn_start = function(buff, target)
        BuffTalk_start(target, buff)
        target:AddTag("bat") --添加蝙蝠标签，蝙蝠不会攻击有该标签的生物
    end,
    fn_again = function(buff, target)
        BuffTalk_start(target, buff)
        target:AddTag("bat")
    end,
    fn_end = function(buff, target)
        BuffTalk_end(target, buff)
        target:RemoveTag("bat") --移除蝙蝠标签
    end,
    fn_server = nil,
})

--------------------------------------------------------------------------
--[[ 好胃口：能够吃自己不喜欢的食物，但仍然无法吃生理上无法食用的食物 ]]
--------------------------------------------------------------------------

MakeBuff({
    name = "buff_bestappetite",
    assets = nil,
    prefabs = nil,
    time_key = "time_l_bestappetite",
    time_default = TUNING.SEG_TIME*2, --1分钟
    notimer = nil,
    fn_start = function(buff, target)
        BuffTalk_start(target, buff)
        --此处并没有任何操作，因为已经修改全局食性组件了，有这个buff就会启用
    end,
    fn_again = function(buff, target)
        BuffTalk_start(target, buff)
    end,
    fn_end = function(buff, target)
        BuffTalk_end(target, buff)
    end,
    fn_server = nil,
})

--------------------------------------------------------------------------
--[[ 蝴蝶庇佑：100%抵挡一次任何攻击 ]]
--------------------------------------------------------------------------

local function GetSkin(buff, player)
    if player.butterfly_skin_l ~= nil then
        return player.butterfly_skin_l
    elseif buff.flyskins ~= nil then
        local kk = nil
        local vv = nil
        for k,v in pairs(buff.flyskins) do
            if v ~= nil then
                vv = v
                kk = k
            end
        end
        if kk == nil then
            buff.flyskins = nil
        else
            buff.flyskins[kk] = nil
        end
        return vv
    end
end
local function SpawnButterfly(buff, target)
    local butterfly = SpawnPrefab("neverfade_butterfly")
    if target.components.leader ~= nil then
        target.components.leader:AddFollower(butterfly)

        local skin = GetSkin(buff, target)
        if skin ~= nil and skin.bank ~= nil and skin.build ~= nil then
            butterfly.AnimState:SetBank(skin.bank)
            butterfly.AnimState:SetBuild(skin.build)
            butterfly.skin_l = skin
        end

        local x, y, z = target.Transform:GetWorldPosition()
        local x2, y2, z2 = GetCalculatedPos_legion(x, y, z, 1+math.random()*2, nil)
        butterfly.Transform:SetPosition(x2, y2, z2)

        return butterfly
    end
    return nil
end
local function AddButterfly(buff, player)
    buff.countbutterflies = buff.countbutterflies + 1
    buff.blessingbutterflies[buff.countbutterflies] = SpawnButterfly(buff, player)
    player.countblessing = buff.countbutterflies --更新玩家的数据
end
local function DeleteButterfly(buff, player)
    if buff.blessingbutterflies[buff.countbutterflies] ~= nil then
        buff.blessingbutterflies[buff.countbutterflies].dead = true
        buff.blessingbutterflies[buff.countbutterflies] = nil
    end
    buff.countbutterflies = buff.countbutterflies - 1
    player.countblessing = buff.countbutterflies --更新玩家的数据

    if buff.countbutterflies <= 0 then
        buff.components.debuff:Stop()
    end
end

-- local function SetBuff_butterflysblessing(buff, target)
--     if target.flag_l_bfbless ~= nil or target.components.inventory == nil or target.components.debuffable == nil then
--         return
--     end
--     target.flag_l_bfbless = true
--     local ApplyDamage_old = target.components.inventory.ApplyDamage
--     target.components.inventory.ApplyDamage = function(self, damage, ...)
--         if damage >= 0 and self.inst.countblessing ~= nil and self.inst.countblessing > 0 then
--             local mybuff = self.inst.components.debuffable:GetDebuff("buff_butterflysblessing")
--             if mybuff and mybuff.countbutterflies ~= nil and mybuff.countbutterflies > 0 then
--                 DeleteButterfly(mybuff, self.inst)
--                 return 0
--             end
--         end
--         return ApplyDamage_old(self, damage, ...)
--     end
-- end

MakeBuff({
    name = "buff_butterflysblessing",
    assets = nil,
    prefabs = nil,
    time_key = nil,
    time_default = nil,
    notimer = true,
    fn_start = function(buff, target)
        if buff.precount ~= nil then
            for i = 1, buff.precount do
                AddButterfly(buff, target)
            end
            buff.precount = nil
        else
            AddButterfly(buff, target)
        end
        -- SetBuff_butterflysblessing(buff, target)
    end,
    fn_again = function(buff, target)
        AddButterfly(buff, target) --在这里并不限制增加的数量，是否要增加数量只在生成方那边判断，不在这边的响应方进行
    end,
    fn_end = function(buff, target)
        --清除buff所有的数据
        for k, v in pairs(buff.blessingbutterflies) do
            v.dead = true
        end
        buff.countbutterflies = 0
        buff.blessingbutterflies = {}
        target.countblessing = 0 --一般触发这里都是因为玩家死亡，此时应该清除玩家的数据
    end,
    fn_server = function(buff)
        buff.precount = nil --记录保存下的数量（OnLoad()比OnAttached()先执行）
        buff.countbutterflies = 0 --记录蝴蝶的数量，并作为下标
        buff.blessingbutterflies = {} --记录了每只蝴蝶的数据
        buff.flyskins = nil
        buff.DeleteButterfly = DeleteButterfly

        buff.OnSave = function(inst, data)
            if inst.countbutterflies >= 2 then --只保存大于1数量的数量，因为初始化时本身肯定就有1只蝴蝶
                data.countbutterflies = inst.countbutterflies
            end

            local flyskins = nil
            for k,v in pairs(inst.blessingbutterflies) do
                if v and not v.dead and v.skin_l ~= nil then
                    if flyskins == nil then
                        flyskins = {}
                    end
                    table.insert(flyskins, v.skin_l)
                end
            end
            if flyskins ~= nil then
                data.flyskins = flyskins
            end
        end
        buff.OnLoad = function(inst, data)
            if data ~= nil then
                inst.precount = data.countbutterflies
                inst.flyskins = data.flyskins
            end
        end
    end,
})

--------------------------------------------------------------------------
--[[ 血库：按需提供生命值恢复 ]]
--------------------------------------------------------------------------

local function OnTick_healthstorage(inst, target)
    if IsAlive(target) then
        if target.components.health:IsHurt() then --需要加血
            target.components.health:DoDelta(2, nil, "shyerry")
            inst.times = inst.times - 1
            if inst.times <= 0 then
                inst.components.debuff:Stop()
            end
        end
    else
        inst.components.debuff:Stop()
    end
end

MakeBuff({
    name = "buff_healthstorage",
    assets = nil,
    prefabs = nil,
    time_key = nil,
    time_default = nil,
    notimer = true,
    fn_start = function(buff, target)
        if target.buff_healthstorage_times ~= nil then
            buff.times = buff.times + target.buff_healthstorage_times
            target.buff_healthstorage_times = nil
        end
        if buff.times > 0 then
            buff.task = buff:DoPeriodicTask(2, OnTick_healthstorage, nil, target)
        end
    end,
    fn_again = function(buff, target)
        if target.buff_healthstorage_times ~= nil then --buff次数可以无限叠加
            buff.times = buff.times + target.buff_healthstorage_times
            target.buff_healthstorage_times = nil
        end

        if buff.task ~= nil then
            buff.task:Cancel()
        end
        if buff.times > 0 then
            buff.task = buff:DoPeriodicTask(TUNING.JELLYBEAN_TICK_RATE, OnTick_healthstorage, nil, target)
        end
    end,
    fn_end = function(buff, target)
        if buff.task ~= nil then
            buff.task:Cancel()
            buff.task = nil
        end
    end,
    fn_server = function(buff)
        buff.times = 0

        buff.OnSave = function(inst, data)
            if inst.times ~= nil and inst.times > 0 then
                data.times = inst.times
            end
        end
        buff.OnLoad = function(inst, data) --这个比OnAttached更早执行
            if data ~= nil and data.times ~= nil and data.times > 0 then
                inst.times = data.times
            end
        end
    end,
})

--------------------------------------------------------------------------
--[[ 消化不良：减少饱食度下降速度 ]]
--------------------------------------------------------------------------

MakeBuff({
    name = "buff_hungerretarder",
    assets = nil,
    prefabs = nil,
    time_key = "time_l_hungerretarder",
    time_default = TUNING.SEG_TIME*6, --3分钟
    notimer = nil,
    fn_start = function(buff, target)
        BuffTalk_start(target, buff)
        if target.components.hunger ~= nil then
            target.components.hunger.burnratemodifiers:SetModifier(buff, 0.1) --饥饿值消耗速度降为0.1倍
        end
    end,
    fn_again = function(buff, target)
        BuffTalk_start(target, buff)
    end,
    fn_end = function(buff, target)
        BuffTalk_end(target, buff)
        if target.components.hunger ~= nil then
            target.components.hunger.burnratemodifiers:RemoveModifier(buff)
        end
    end,
    fn_server = nil,
})

--------------------------------------------------------------------------
--[[ 孢子抵抗力：减少25%受到的伤害（进行防具抵扣之后的值） ]]
--------------------------------------------------------------------------

MakeBuff({
    name = "buff_sporeresistance",
    assets = nil,
    prefabs = nil,
    time_key = "time_l_sporeresistance",
    time_default = TUNING.SEG_TIME*6, --3分钟
    notimer = nil,
    fn_start = function(buff, target)
        if buff.task == nil then
            buff.task = buff:DoPeriodicTask(0.7, function()
                buff:DoTaskInTime(math.random()*0.6, function()
                    if
                        not (
                            target.components.health == nil or target.components.health:IsDead() or
                            target.sg:HasStateTag("nomorph") or
                            target.sg:HasStateTag("silentmorph") or
                            target.sg:HasStateTag("ghostbuild")
                        ) and target.entity:IsVisible()
                    then
                        SpawnPrefab("residualspores_fx").Transform:SetPosition(target.Transform:GetWorldPosition())
                    end
                end)
            end)
            if target.components.health ~= nil then
                target.components.health.externalabsorbmodifiers:SetModifier(buff, 0.25)
            end
        end
    end,
    fn_again = nil,
    fn_end = function(buff, target)
        if target.components.health ~= nil then
            target.components.health.externalabsorbmodifiers:RemoveModifier(buff)
        end
        if buff.task ~= nil then
            buff.task:Cancel()
            buff.task = nil
        end
    end,
    fn_server = nil,
})

--------------------------------------------------------------------------
--[[ 蛮力：增加攻击力 ]]
--------------------------------------------------------------------------

MakeBuff({
    name = "buff_strengthenhancer",
    assets = nil,
    prefabs = nil,
    time_key = "time_l_strengthenhancer",
    time_default = TUNING.SEG_TIME*16, --8分钟
    notimer = nil,
    fn_start = function(buff, target)
        if target.components.combat ~= nil then
            target.components.combat.externaldamagemultipliers:SetModifier(buff, 1.5) --攻击力系数乘以1.5倍
        end
    end,
    fn_again = nil,
    fn_end = function(buff, target)
        BuffTalk_end(target, buff)
        if target.components.combat ~= nil then
            target.components.combat.externaldamagemultipliers:RemoveModifier(buff)
        end
    end,
    fn_server = nil,
})

--------------------------------------------------------------------------
--[[ 惊吓：进入被惊吓sg ]]
--------------------------------------------------------------------------

local function AlignToTarget(inst, target)
    inst.Transform:SetRotation(target.Transform:GetRotation())
end
local function OnChangeFollowSymbol(inst, target, followsymbol, followoffset)
    if followsymbol ~= nil and followoffset ~= nil then
        inst.Follower:FollowSymbol(target.GUID, followsymbol, followoffset.x, followoffset.y, followoffset.z)
    end
end

MakeBuff({
    name = "debuff_panicvolcano",
    assets = {
        Asset("ANIM", "anim/debuff_panicvolcano.zip"),
    },
    prefabs = nil,
    time_key = nil,
    time_default = nil,
    notimer = true,
    addnetwork = true,
    fn_start = function(buff, target, followsymbol, followoffset)
        buff.entity:SetParent(target.entity)
        OnChangeFollowSymbol(buff, target, followsymbol, followoffset)
        if buff._followtask ~= nil then
            buff._followtask:Cancel()
        end
        buff._followtask = buff:DoPeriodicTask(0, AlignToTarget, nil, target)
        AlignToTarget(buff, target)

        target:PushEvent("bevolcanopaniced")
    end,
    fn_again = nil,
    fn_end = function(buff, target)
        local player = buff.entity:GetParent()
        if player ~= nil and player.components.talker ~= nil then
            player.components.talker:Say(GetString(player, "DESCRIBE", { "DISH_SUGARLESSTRICKMAKERCUPCAKES", "TRICKED" }))
        end
        if buff._followtask ~= nil then
            buff._followtask:Cancel()
            buff._followtask = nil
        end
    end,
    fn_common = function(buff)
        buff.entity:AddFollower()
        buff.entity:AddAnimState()

        buff:AddTag("FX")

        buff.Transform:SetFourFaced()

        buff.AnimState:SetBank("debuff_panicvolcano")
        buff.AnimState:SetBuild("debuff_panicvolcano")
        buff.AnimState:PlayAnimation("anim")
        buff.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        buff.AnimState:SetFinalOffset(3)
    end,
    fn_server = function(buff)
        buff.components.debuff:SetChangeFollowSymbolFn(OnChangeFollowSymbol)

        buff:ListenForEvent("animover", function(fx)
            fx.components.debuff:Stop()
        end)
    end,
})

--------------------------------------------------------------------------
--[[ 腹得流油：不断拉粑粑（主要是鱼的油脂） ]]
--------------------------------------------------------------------------

local function StartOilFlowing(buff, inst)
    if buff.task ~= nil then
        buff.task:Cancel()
    end
    buff.task = inst:DoPeriodicTask(1.5, function(inst)
        if IsAlive(inst) and inst.components.hunger ~= nil and not inst.components.hunger:IsStarving() then
            if math.random() < 0.6 then
                local poop = SpawnPrefab(math.random() < 0.005 and "beeswax" or "poop")
                if poop ~= nil then
                    ------让粑粑飞
                    local x1, y1, z1 = inst.Transform:GetWorldPosition()
                    local angle = inst.Transform:GetRotation() + 20 - math.random()*40
                    local theta = (angle+180)*DEGREES
                    poop.Transform:SetPosition(x1, y1+0.5, z1)
                    --Tip：SetMotorVel()会一直给加速度，SetVel()则会受到摩擦阻力和重力影响
                    poop.Physics:SetVel(2.5*math.cos(theta), 2, -2.5*math.sin(theta))

                    if inst:HasTag("player") then
                        ------说尴尬的话
                        if inst.components.talker ~= nil and not inst:HasTag("mime") and math.random() < 0.4 then
                            local words = STRINGS.CHARACTERS[string.upper(inst.prefab)]
                            if words ~= nil and words.BUFF_OILFLOW ~= nil then
                                words = words.BUFF_OILFLOW
                            else
                                words = STRINGS.CHARACTERS.GENERIC.BUFF_OILFLOW
                            end
                            inst.components.talker:Say(GetRandomItem(words))
                        end

                        ------让玩家向前推进
                        inst:PushEvent("awkwardpropeller", { angle = angle })
                    elseif inst.Physics ~= nil then
                        ------让对象向前推进
                        inst.Transform:SetRotation(angle)
                        inst.Physics:SetMotorVel(5, 0, 0) --这里没设置停下来，不会一直飞吧，应该有摩擦阻力以及自我行走打断才对
                    end

                    ------增加潮湿度
                    if inst.components.moisture ~= nil then
                        inst.components.moisture:DoDelta(0.5)
                    end

                    ------饥饿值消耗
                    inst.components.hunger:DoDelta(-3.5)
                    if inst.components.hunger:IsStarving() then
                        buff.components.debuff:Stop()
                    end
                    inst:PushEvent("on_poop", { doer = buff, hungerdelta = -3.5, item = poop })
                end
            end
            return
        end
        buff.components.debuff:Stop()
    end, 3)
end

MakeBuff({
    name = "buff_oilflow",
    assets = nil,
    prefabs = { "poop", "beeswax" },
    time_key = "time_l_oilflow",
    time_default = TUNING.SEG_TIME*16, --8分钟
    notimer = nil,
    fn_start = function(buff, target)
        BuffTalk_start(target, buff)
        StartOilFlowing(buff, target)
    end,
    fn_again = function(buff, target)
        BuffTalk_start(target, buff)
        StartOilFlowing(buff, target)
    end,
    fn_end = function(buff, target)
        BuffTalk_end(target, buff)
        if buff.task ~= nil then
            buff.task:Cancel()
            buff.task = nil
        end
    end,
    fn_server = nil,
})

--------------------------------------------------------------------------
--[[ 魔音绕耳：不断卸下装备 ]]
--------------------------------------------------------------------------

MakeBuff({
    name = "debuff_magicwarble",
    assets = nil,
    prefabs = nil,
    time_key = "time_l_magicwarble",
    time_default = TUNING.SEG_TIME, --0.5分钟
    notimer = nil,
    fn_start = function(buff, target)
        if target.task_l_magicwarble ~= nil then
            target.task_l_magicwarble:Cancel()
            target.task_l_magicwarble = nil
        end
        if target.components.inventory ~= nil then
            target.task_l_magicwarble = target:DoPeriodicTask(0.9, function(v)
                if v.components.inventory ~= nil then
                    if v.components.health == nil or not v.components.health:IsDead() then
                        -- v.components.inventory:DropEquipped(false)
                        local inv = v.components.inventory
                        for slot, item in pairs(inv.equipslots) do
                            if slot ~= EQUIPSLOTS.BEARD then --可不能把威尔逊的“胡子”给吼下来了
                                inv:DropItem(item, true, true)
                            end
                        end
                    end
                end
            end, 1)
        end
    end,
    fn_again = nil,
    fn_end = function(buff, target)
        if target.task_l_magicwarble ~= nil then
            target.task_l_magicwarble:Cancel()
            target.task_l_magicwarble = nil
        end
    end,
    fn_server = nil,
})

--------------------------------------------------------------------------
--[[ 神木光辉：增加防御力 ]]
--------------------------------------------------------------------------

local function OnChangeFollowSymbol_tree(inst, target, followsymbol, followoffset)
    if target:HasTag("siving_boss") then --这个buff特效我想让它的位置在玄鸟头部
        followsymbol = "buzzard_head"
        followoffset = { x = 0, y = -20, z = 0 }
    end
    if followsymbol ~= nil and followoffset ~= nil then
        inst.Follower:FollowSymbol(target.GUID, followsymbol, followoffset.x, followoffset.y, followoffset.z)
    end
end
local function SetStateSymbol(buff, state)
    if state == 1 then
        buff.AnimState:OverrideSymbol("insidetooth2", "siving_treehalo_fx", "insidetooth2")
    elseif state == 2 then
        buff.AnimState:OverrideSymbol("insidetooth2", "siving_treehalo_fx", "base2")
    else
        buff.AnimState:OverrideSymbol("insidetooth2", "siving_treehalo_fx", "base3")
    end
end
local function BuffSet_tree(buff, target)
    local state = target.sign_l_treehalo --不要清除这个变量，我还要管理呢
    if state == nil then --很可能是加载时
        state = buff.state_l
        buff.state_l = 0 --这样就可以把逻辑走完了
        target.sign_l_treehalo = state
    end

    if state == 0 then
        buff.state_l = 0
        if buff:IsAsleep() then
            buff:DoTaskInTime(0, function(fx) --下一帧再执行，不然加buff的函数里移除buff可能会崩
                fx.components.debuff:Stop()
            end)
        else
            buff.AnimState:PlayAnimation("pst")
            buff:ListenForEvent("animover", function(fx)
                fx.components.debuff:Stop()
            end)
        end
        return
    end

    if buff.state_l ~= state then
        if buff.state_l > 0 then
            buff.AnimState:PlayAnimation("exchange")
            if buff.task_ex ~= nil then
                buff.task_ex:Cancel()
            end
            buff.task_ex = buff:DoTaskInTime(0.3, function(buff)
                buff.task_ex = nil
                SetStateSymbol(buff, buff.state_l)
            end)
        else
            SetStateSymbol(buff, state)
            buff.AnimState:PlayAnimation("pre")
        end
        buff.AnimState:PushAnimation("loop", true)
        buff.state_l = state
        if target.components.combat ~= nil then
            if state == 3 then
                target.components.combat.externaldamagetakenmultipliers:SetModifier(buff, 0.01)
            elseif state == 2 then
                target.components.combat.externaldamagetakenmultipliers:SetModifier(buff, 0.34)
            elseif state == 1 then
                target.components.combat.externaldamagetakenmultipliers:SetModifier(buff, 0.67)
            end
        end
    end
end

MakeBuff({
    name = "buff_treehalo",
    assets = {
        Asset("ANIM", "anim/siving_treehalo_fx.zip"),
    },
    prefabs = nil,
    time_key = nil,
    time_default = nil,
    notimer = true,
    addnetwork = true,
    fn_start = function(buff, target, followsymbol, followoffset)
        buff.entity:SetParent(target.entity)
        OnChangeFollowSymbol_tree(buff, target, followsymbol, followoffset)
        BuffSet_tree(buff, target)
    end,
    fn_again = function(buff, target, followsymbol, followoffset)
        if buff.state_l > 0 then --结束动画有一阵子，期间再来就不算了
            BuffSet_tree(buff, target)
        end
    end,
    fn_end = function(buff, target)
        if buff.task_ex ~= nil then
            buff.task_ex:Cancel()
            buff.task_ex = nil
        end
        if target:IsValid() and target.components.combat ~= nil then
            target.components.combat.externaldamagetakenmultipliers:RemoveModifier(buff)
        end
    end,
    fn_common = function(buff)
        buff.entity:AddFollower()
        buff.entity:AddAnimState()

        buff:AddTag("FX")

        buff.AnimState:SetBank("siving_treehalo_fx")
        buff.AnimState:SetBuild("siving_treehalo_fx")
        buff.AnimState:PlayAnimation("loop", true)
        buff.AnimState:SetScale(0.35, 0.35)
        buff.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        buff.AnimState:SetFinalOffset(-3) --让这个动画位于父体层级底部
    end,
    fn_server = function(buff)
        buff.components.debuff:SetChangeFollowSymbolFn(OnChangeFollowSymbol_tree)

        buff.state_l = 0
        buff.OnSave = function(inst, data)
            if inst.state_l > 0 then
                data.state_l = inst.state_l
            end
        end
        buff.OnLoad = function(inst, data) --这个比OnAttached更早执行
            if data ~= nil and data.state_l ~= nil then
                inst.state_l = data.state_l
            end
        end
    end,
})

--------------------
--------------------

return unpack(prefs)
