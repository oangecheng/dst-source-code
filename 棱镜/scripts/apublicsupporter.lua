--这里的内容主要是兼容性修改，优化性修改，mod内容里的通用修改部分(比如都要修改某个组件时，我就会把改动内容单独移到这里来，不再单独修改)

local _G = GLOBAL
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()

--------------------------------------------------------------------------
--[[ 方便进行代码开发的各种自定义工具函数 ]]
--------------------------------------------------------------------------

--[ 地图图标注册 ]--
_G.RegistMiniMapImage_legion = function(filename, fileaddresspre)
    local fileaddresscut = (fileaddresspre or "images/map_icons/")..filename

    table.insert(Assets, Asset("ATLAS", fileaddresscut..".xml"))
    table.insert(Assets, Asset("IMAGE", fileaddresscut..".tex"))

    AddMinimapAtlas(fileaddresscut..".xml")

    --  接下来就需要在prefab定义里添加：
    --      inst.entity:AddMiniMapEntity()
    --      inst.MiniMapEntity:SetIcon("图片文件名.tex")
end

--[ 积雪监听(仅prefab定义时使用) ]--
_G.MakeSnowCovered_comm_legion = function(inst)
    inst.AnimState:OverrideSymbol("snow", "hiddenmoonlight", "emptysnow")

    --  1、为了注册积雪的贴图，需要提前在assets中添加：
    --      Asset("ANIM", "anim/hiddenmoonlight.zip")
    --  2、同时，动画制作中，需要添加“snow”的通道
end
_G.MakeSnowCovered_serv_legion = function(inst, delaytime, delayfn)
    local function OnSnowCoveredChagned(inst, covered)
        if TheWorld.state.issnowcovered then
            inst.AnimState:OverrideSymbol("snow", "hiddenmoonlight", "snow")
        else
            inst.AnimState:OverrideSymbol("snow", "hiddenmoonlight", "emptysnow")
        end
    end

    inst:WatchWorldState("issnowcovered", OnSnowCoveredChagned)
    inst:DoTaskInTime(delaytime, function()
		OnSnowCoveredChagned(inst)
        if delayfn ~= nil then delayfn(inst) end
	end)
end

--[ 光照监听(仅prefab定义时使用) ]--
_G.IsTooDarkToGrow_legion = function(inst)
	if TheWorld.state.isnight then
		local x, y, z = inst.Transform:GetWorldPosition()
		for i, v in ipairs(TheSim:FindEntities(x, 0, z, TUNING.DAYLIGHT_SEARCH_RANGE, { "daylight", "lightsource" })) do
			local lightrad = v.Light:GetCalculatedRadius() * .7
			if v:GetDistanceSqToPoint(x, y, z) < lightrad * lightrad then
				return false
			end
		end
		return true
	end
	return false
end

--[ 计算最终位置(仅prefab定义时使用) ]--
_G.GetCalculatedPos_legion = function(x, y, z, radius, theta)
    local rad = radius or math.random() * 3
    local the = theta or math.random() * 2 * PI
    return x + rad * math.cos(the), y, z - rad * math.sin(the)
end

--[ 垂直掉落一个物品(仅prefab定义时使用) ]--
local easing = require("easing")
_G.DropItem_legion = function(itemname, x, y, z, hitrange, hitdamage, fallingtime, fn_start, fn_doing, fn_end)
	local item = SpawnPrefab(itemname)
	if item ~= nil then
        if fallingtime == nil then fallingtime = 5 * FRAMES end

		item.Transform:SetPosition(x, y, z) --这里的y就得是下落前起始高度
		item.fallingpos = item:GetPosition()
		item.fallingpos.y = 0
		if item.components.inventoryitem ~= nil then
			item.components.inventoryitem.canbepickedup = false
		end

        if fn_start ~= nil then fn_start(item) end

		item.fallingtask = item:DoPeriodicTask(
            FRAMES,
            function(inst, startpos, starttime)
                local t = math.max(0, GetTime() - starttime)
                local pos = startpos + (inst.fallingpos - startpos) * easing.inOutQuad(t, 0, 1, fallingtime)
                if t < fallingtime and pos.y > 0 then
                    inst.Transform:SetPosition(pos:Get())
                    if fn_doing ~= nil then fn_doing(inst) end
                else
                    inst.Physics:Teleport(inst.fallingpos:Get())
                    inst.fallingtask:Cancel()
                    inst.fallingtask = nil
                    inst.fallingpos = nil
                    if inst.components.inventoryitem ~= nil then
                        inst.components.inventoryitem.canbepickedup = true
                    end

                    if hitrange ~= nil then
                        local someone = FindEntity(inst, hitrange,
                            function(target)
                                if target and target:IsValid() and
                                    target.components.combat ~= nil and
                                    target.components.health ~= nil and not target.components.health:IsDead()
                                then
                                    return true
                                end
                                return false
                            end,
                            {"_combat", "_health"}, {"NOCLICK", "shadow", "playerghost", "INLIMBO"}, nil
                        )
                        if someone ~= nil and someone.components.combat:CanBeAttacked() then
                            someone.components.combat:GetAttacked(inst, hitdamage, nil)
                        end
                    end

                    if fn_end ~= nil then fn_end(inst) end
                end
            end,
            0, item:GetPosition(), GetTime()
        )
    end
end

--[ sg：sg中卸下装备的重物 ]--
_G.ForceStopHeavyLifting_legion = function(inst)
    if inst.components.inventory:IsHeavyLifting() then
        inst.components.inventory:DropItem(
            inst.components.inventory:Unequip(EQUIPSLOTS.BODY),
            true,
            true
        )
    end
end

--[ 无视防御的攻击 ]--
local function RecalculateModifier_combat_l(inst)
    local m = inst._base
    for source, src_params in pairs(inst._modifiers) do
        for k, v in pairs(src_params.modifiers) do
            if v > 1 then --大于1 是代表增伤。这里需要忽略的是减伤
                m = inst._fn(m, v)
            end
        end
    end
    inst._modifier_l = m
end
_G.UndefendedATK_legion = function(inst, data)
    if data == nil or data.target == nil then
        return
    end
    local target = data.target

    if
        target.ban_l_undefended or --其他mod兼容：这个变量能防止被破防攻击
        target.prefab == "laozi" --无法伤害神话书说里的太上老君
    then
        return
    end

    local health = target.components.health

    if target.flag_undefended_l == nil then
        --修改物品栏护甲机制
        if target.components.inventory ~= nil and not target:HasTag("player") then --不改玩家的
            local ApplyDamage_old = target.components.inventory.ApplyDamage
            target.components.inventory.ApplyDamage = function(self, damage, attacker, weapon, ...)
                if self.inst.flag_undefended_l == 1 then
                    return damage
                end
                return ApplyDamage_old(self, damage, attacker, weapon, ...)
            end
        end

        --修改战斗机制
        if target.components.combat ~= nil then
            local combat = target.components.combat
            local mult = combat.externaldamagetakenmultipliers
            local mult_Get = mult.Get
            local mult_SetModifier = mult.SetModifier
            local mult_RemoveModifier = mult.RemoveModifier
            mult.Get = function(self, ...)
                if self.inst.flag_undefended_l == 1 then
                    return self._modifier_l or 1
                end
                return mult_Get(self, ...)
            end
            mult.SetModifier = function(self, ...)
                mult_SetModifier(self, ...)
                RecalculateModifier_combat_l(self)
            end
            mult.RemoveModifier = function(self, ...)
                mult_RemoveModifier(self, ...)
                RecalculateModifier_combat_l(self)
            end
            RecalculateModifier_combat_l(mult) --主动更新一次

            local GetAttacked_old = combat.GetAttacked
            combat.GetAttacked = function(self, ...)
                if self.inst.flag_undefended_l == 1 then
                    local notblocked = GetAttacked_old(self, ...)
                    self.inst.flag_undefended_l = 0
                    if --攻击完毕，恢复其防御力
                        self.inst.health_l_undefended ~= nil and
                        self.inst.components.health ~= nil --不要判断死亡(玩家)
                    then
                        local healthcpt = self.inst.components.health
                        local param = self.inst.health_l_undefended
                        if param.absorb ~= nil and healthcpt.absorb == 0 then --说明被打后没变化，所以可以直接恢复
                            healthcpt.absorb = param.absorb
                        end
                        if param.playerabsorb ~= nil and healthcpt.playerabsorb == 0 then
                            healthcpt.playerabsorb = param.playerabsorb
                        end
                    end
                    self.inst.health_l_undefended = nil
                    return notblocked
                else
                    return GetAttacked_old(self, ...)
                end
            end
        end

        --修改生命机制
        if health ~= nil then
            local mult2 = health.externalabsorbmodifiers
            local mult2_Get = mult2.Get
            mult2.Get = function(self, ...)
                if self.inst.flag_undefended_l == 1 then
                    return 0
                end
                return mult2_Get(self, ...)
            end

            if not target:HasTag("player") then --玩家无敌时，是不改的
                local IsInvincible_old = health.IsInvincible
                health.IsInvincible = function(self, ...)
                    if self.inst.flag_undefended_l == 1 then
                        return false
                    end
                    return IsInvincible_old(self, ...)
                end
            end
        end
    end

    target.flag_undefended_l = 1
    if health ~= nil then
        local param = {}
        if health.absorb ~= 0 then
            param.absorb = health.absorb
            health.absorb = 0
        end
        if health.playerabsorb ~= 0 then
            param.playerabsorb = health.playerabsorb
            health.playerabsorb = 0
        end
        target.health_l_undefended = param
    end
end

--[ 兼容性标签管理 ]--
_G.AddTag_legion = function(inst, tagname, key)
    if inst.tags_l == nil then
        inst.tags_l = {}
    end
    if inst.tags_l[tagname] == nil then
        inst.tags_l[tagname] = {}
    end
    inst.tags_l[tagname][key] = true
    inst:AddTag(tagname)
end
_G.RemoveTag_legion = function(inst, tagname, key)
    if inst.tags_l ~= nil then
        if inst.tags_l[tagname] ~= nil then
            inst.tags_l[tagname][key] = nil
            for k, v in pairs(inst.tags_l[tagname]) do
                if v == true then --如果还有 key 为true，那就不能删除这个标签
                    return
                end
            end
            inst.tags_l[tagname] = nil --没有 key 是true了，直接做空
        end
    end
    inst:RemoveTag(tagname)
end

--[ 吉他曲管理(mod兼容用的，如果其他mod想要增加自己的曲子就用以下代码) ]--
if not _G.rawget(_G, "GUITARSONGSPOOL_LEGION") then
    _G.GUITARSONGSPOOL_LEGION = {}
end
--[[
_G.GUITARSONGSPOOL_LEGION["weisuo"] = function(guitar, doer, team, songs, guitartype) --吉他实体、主弹演奏者、演奏团队、已有的曲子、演奏类型
    if guitar.prefab == "guitar_whitewood" then --以后还会出新的吉他，所以这里要有限制
        local songmap = {
            shiye = "歌曲路径",
            faye = "歌曲路径2",
            noobmaster = "歌曲路径3",
            chenyu = "歌曲路径4"
        }
        local song = songmap[doer.prefab] or nil
        local num_weisuo = song ~= nil and 1 or 0

        if team ~= nil then --team里只有其他人，没有主弹
            for _, player in pairs(team) do
                if player and songmap[player.prefab] ~= nil then
                    num_weisuo = num_weisuo + 1
                end
            end
            if num_weisuo >= 4 then
                song = "四人歌曲路径"
            elseif num_weisuo >= 3 then
                song = "三人歌曲路径"
            elseif num_weisuo >= 2 then
                song = "双人歌曲路径"
            end
        end

        if song ~= nil then
            doer.SoundEmitter:PlaySound(song, "guitarsong_l")
            doer.SoundEmitter:SetVolume("guitarsong_l", 0.5)
            return "override" --返回"override"代表只用这里的歌曲；否则就得往 songs 里加新的歌曲路径
        end
    end
end
]]--

--------------------------------------------------------------------------
--[[ 修改rider组件，重新构造combat的redirectdamagefn函数以适应更多元的机制 ]]
--------------------------------------------------------------------------

--[[
if IsServer then
    function GLOBAL.RebuildRedirectDamageFn(player) --重新构造combat的redirectdamagefn函数
        --初始化
        if player.redirect_table == nil then
            player.redirect_table = {}
        end
        if player.components.combat ~= nil then
            --重新定义combat的redirectdamagefn
            player.components.combat.redirectdamagefn = function(victim, attacker, damage, weapon, stimuli)
                local redirect = nil
                for k, v in pairs(victim.redirect_table) do
                    redirect = victim.redirect_table[k](victim, attacker, damage, weapon, stimuli)
                    if redirect ~= nil then
                        break
                    end
                end
                return redirect, 'legioned'
            end
        end
    end

    AddComponentPostInit("rider", function(self)
        local Mount_old = self.Mount
        self.Mount = function(self, target, instant)
            if (self.riding or target.components.rideable == nil or target.components.rideable:IsBeingRidden())
                or not target.components.rideable:TestObedience() then
                Mount_old(self, target, instant)
                return
            end

            Mount_old(self, target, instant)
            --先登记骑牛保护的旧函数
            if self.inst.components.combat ~= nil then
                if self.inst.redirect_table == nil then
                    self.inst.redirect_table = {}
                end
                if self.inst.components.combat.redirectdamagefn ~= nil then
                    --提前测试一下，防止无限递归
                    local redirect, tag = self.inst.components.combat.redirectdamagefn(self.inst, nil, 0, nil, nil)
                    if tag == nil then
                        self.inst.redirect_table[target.prefab] = self.inst.components.combat.redirectdamagefn
                    end
                end

                --再重构combat的redirectdamagefn
                RebuildRedirectDamageFn(self.inst)
            end
        end

        local ActualDismount_old = self.ActualDismount
        self.ActualDismount = function(self)
            local ex_mount = ActualDismount_old(self)
            if ex_mount ~= nil then
                --清除骑牛保护的旧函数
                if self.inst.components.combat ~= nil then
                    self.inst.redirect_table[ex_mount.prefab] = nil

                    --因为下牛时redirectdamagefn被还原，所以这里还要重新定义一遍
                    RebuildRedirectDamageFn(self.inst)
                end
            end
        end
    end)
end
]]--

--------------------------------------------------------------------------
--[[ 修改playercontroller组件，防止既有手持装备组件和栽种组件的物品在栽种时会先自动装备在身上的问题 ]]
--------------------------------------------------------------------------

-- 666，官方居然把这里修复了，我就不用再改了，哈哈

-- AddComponentPostInit("playercontroller", function(self)
--     local DoActionAutoEquip_old = self.DoActionAutoEquip
--     self.DoActionAutoEquip = function(self, buffaction)
--         if buffaction.invobject ~= nil and
--             buffaction.invobject.replica.equippable ~= nil and
--             buffaction.invobject.replica.equippable:EquipSlot() == EQUIPSLOTS.HANDS and
--             buffaction.action == ACTIONS.DEPLOY then
--             --do nothing
--         else
--             DoActionAutoEquip_old(self, buffaction)
--         end
--     end
-- end)

--------------------------------------------------------------------------
--[[ 弹吉他相关 ]]
--------------------------------------------------------------------------

local function ResumeHands(inst)
    local hands = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    if hands ~= nil and not hands:HasTag("book") then
        inst.AnimState:Show("ARM_carry")
        inst.AnimState:Hide("ARM_normal")
    end
end

local playguitar_pre = State{
    name = "playguitar_pre",
    tags = { "doing", "playguitar" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("soothingplay_pre", false)
        inst.AnimState:Hide("ARM_carry")
        inst.AnimState:Show("ARM_normal")

        local guitar = inst.bufferedaction ~= nil and (inst.bufferedaction.invobject or inst.bufferedaction.target) or nil
        inst.components.inventory:ReturnActiveActionItem(guitar)

        if guitar ~= nil and guitar.PlayStart ~= nil then --动作的执行处
            guitar:AddTag("busyguitar")
            inst.sg.statemem.instrument = guitar
            guitar.PlayStart(guitar, inst)
            inst:PerformBufferedAction()
        else
            inst:PushEvent("actionfailed", { action = inst.bufferedaction, reason = nil })
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle")
            return
        end

        inst.sg.statemem.playdoing = false
    end,

    events =
    {
        EventHandler("equip", function(inst)    --防止装备时改变手的显示状态
            inst.AnimState:Hide("ARM_carry")
            inst.AnimState:Show("ARM_normal")
        end),

        EventHandler("unequip", function(inst)  --防止卸下时改变手的显示状态
            inst.AnimState:Hide("ARM_carry")
            inst.AnimState:Show("ARM_normal")
        end),

        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg.statemem.playdoing = true
                inst.sg:GoToState("playguitar_loop", inst.sg.statemem.instrument)
            end
        end),
    },

    onexit = function(inst)
        if not inst.sg.statemem.playdoing then
            ResumeHands(inst)

            if inst.sg.statemem.instrument ~= nil then
                inst.sg.statemem.instrument:RemoveTag("busyguitar")
            end
        end
    end,
}

local playguitar_loop = State{
    name = "playguitar_loop",
    tags = { "doing", "playguitar" },

    onenter = function(inst, instrument)
        inst.components.locomotor:Stop()
        inst.AnimState:Hide("ARM_carry")
        inst.AnimState:Show("ARM_normal")

        if instrument ~= nil and instrument.PlayDoing ~= nil then
            instrument.PlayDoing(instrument, inst)
        end

        inst.sg.statemem.instrument = instrument
        inst.sg.statemem.playdoing = false
    end,

    events =
    {
        EventHandler("equip", function(inst)    --防止装备时改变手的显示状态
            inst.AnimState:Hide("ARM_carry")
            inst.AnimState:Show("ARM_normal")
        end),

        EventHandler("unequip", function(inst)  --防止卸下时改变手的显示状态
            inst.AnimState:Hide("ARM_carry")
            inst.AnimState:Show("ARM_normal")
        end),

        EventHandler("playenough", function(inst)
            inst.sg.statemem.playdoing = true
            inst.sg:GoToState("playguitar_pst")
        end),
    },

    onexit = function(inst)
        if not inst.sg.statemem.playdoing then
            ResumeHands(inst)
        end

        if inst.sg.statemem.instrument ~= nil then
            if inst.sg.statemem.instrument.PlayEnd ~= nil then
                inst.sg.statemem.instrument.PlayEnd(inst.sg.statemem.instrument, inst)
            end
            inst.sg.statemem.instrument:RemoveTag("busyguitar")
        end
    end,
}

local playguitar_pst = State{
    name = "playguitar_pst",
    tags = { "doing", "playguitar" },

    onenter = function(inst)
        inst.components.locomotor:Stop()

        inst.AnimState:PlayAnimation("soothingplay_pst", false)
        inst.AnimState:Hide("ARM_carry")
        inst.AnimState:Show("ARM_normal")
    end,

    events =
    {
        EventHandler("equip", function(inst)    --防止装备时改变手的显示状态
            inst.AnimState:Hide("ARM_carry")
            inst.AnimState:Show("ARM_normal")
        end),

        EventHandler("unequip", function(inst)  --防止卸下时改变手的显示状态
            inst.AnimState:Hide("ARM_carry")
            inst.AnimState:Show("ARM_normal")
        end),

        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        ResumeHands(inst)
    end,
}

local playguitar_client = State{
    name = "playguitar_client",
    tags = { "doing", "playguitar" },

    onenter = function(inst)
        inst.components.locomotor:Stop()

        inst.AnimState:PlayAnimation("soothingplay_pre", false)
        -- inst.AnimState:Hide("ARM_carry")
        -- inst.AnimState:Show("ARM_normal")

        inst:PerformPreviewBufferedAction()
        inst.sg:SetTimeout(2)
    end,

    onupdate = function(inst)
        if inst:HasTag("doing") then
            if inst.entity:FlattenMovementPrediction() then
                inst.sg:GoToState("idle", "noanim")
            end
        elseif inst.bufferedaction == nil then
            inst.sg:GoToState("idle")
        end
    end,

    ontimeout = function(inst)
        inst:ClearBufferedAction()
        inst.sg:GoToState("idle")
    end,
}

AddStategraphState("wilson", playguitar_pre)
--AddStategraphState("wilson_client", playguitar_pre)    --客户端与服务端的sg有区别，这里只需要服务端有就行了
AddStategraphState("wilson", playguitar_loop)
--AddStategraphState("wilson_client", playguitar_loop)
AddStategraphState("wilson", playguitar_pst)
AddStategraphState("wilson_client", playguitar_client) --客户端只需要一个就够了

local PLAYGUITAR = Action({ priority = 5, mount_valid = false })
PLAYGUITAR.id = "PLAYGUITAR"    --这个操作的id
PLAYGUITAR.str = STRINGS.ACTIONS_LEGION.PLAYGUITAR    --这个操作的名字，比如法杖是castspell，蜗牛壳甲是use
PLAYGUITAR.fn = function(act) --这个操作执行时进行的功能函数
    return true --我把具体操作加进sg中了，不再在动作这里执行
end
AddAction(PLAYGUITAR) --向游戏注册一个动作

--往具有某组件的物品添加动作的检测函数，如果满足条件，就向人物的动作可执行表中加入某个动作。right表示是否是右键动作
AddComponentAction("INVENTORY", "instrument", function(inst, doer, actions, right)
    if inst and inst:HasTag("guitar") and doer ~= nil and doer:HasTag("player") then
        table.insert(actions, ACTIONS.PLAYGUITAR) --这里为动作的id
    end
end)

--将一个动作与state绑定
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.PLAYGUITAR, function(inst, action)
    if
        (inst.sg and inst.sg:HasStateTag("busy"))
        or (action.invobject ~= nil and action.invobject:HasTag("busyguitar"))
        or (inst.components.rider ~= nil and inst.components.rider:IsRiding())
    then
        return
    end

    return "playguitar_pre"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.PLAYGUITAR, function(inst, action)
    if
        (inst.sg and inst.sg:HasStateTag("busy"))
        or (action.invobject ~= nil and action.invobject:HasTag("busyguitar"))
        or (inst.replica.rider ~= nil and inst.replica.rider:IsRiding())
    then
        return
    end

    return "playguitar_client"
end))

--------------------------------------------------------------------------
--[[ 统一化的修复组件 ]]
--------------------------------------------------------------------------

if not _G.rawget(_G, "REPAIRERS_L") then
    _G.REPAIRERS_L = {}
end

local function Fn_sg_short(doer, action)
    return "doshortaction"
end
local function Fn_sg_long(doer, action)
    return "dolongaction"
end

local function CommonDoerCheck(doer, target)
    if doer.replica.rider ~= nil and doer.replica.rider:IsRiding() then --骑牛时只能修复自己的携带物品
        if not (target.replica.inventoryitem ~= nil and target.replica.inventoryitem:IsGrandOwner(doer)) then
            return false
        end
    elseif doer.replica.inventory ~= nil and doer.replica.inventory:IsHeavyLifting() then --不能背重物
        return false
    end
    return true
end
local function DoUpgrade(doer, item, target, itemvalue, ismax, defaultreason)
    if item and target and target.components.upgradeable ~= nil then
        local can, reason = target.components.upgradeable:CanUpgrade()
        if not can then
            return false, (reason or defaultreason)
        end

        local cpt = target.components.upgradeable
        local old_stage = cpt.stage
        local numcost = 0
        local num = 1
        if ismax and item.components.stackable ~= nil then
            num = item.components.stackable:StackSize()
        end

        for i = 1, num, 1 do
            cpt.numupgrades = cpt.numupgrades + itemvalue
            numcost = numcost + 1

            if cpt.numupgrades >= cpt.upgradesperstage then --可以进入下一个阶段
                cpt.stage = cpt.stage + 1
                cpt.numupgrades = 0

                if not cpt:CanUpgrade() then
                    break
                end
            end
        end

        --把过程总结为一次，防止多次重复执行。不过可能会有一些顺序上的小问题，暂时应该不会出现
        if cpt.onupgradefn then
            cpt.onupgradefn(cpt.inst, doer, item)
        end
        if old_stage ~= cpt.stage and cpt.onstageadvancefn then --说明升级了
            cpt.onstageadvancefn(cpt.inst)
        end

        if item.components.stackable ~= nil then
            item.components.stackable:Get(numcost):Remove()
        else
            item:Remove()
        end
        return true
    end
    return false
end
local function DoArmorRepair(doer, item, target, value)
    if
        target ~= nil and
        target.components.armor ~= nil and target.components.armor:GetPercent() < 1
    then
        value = value*(doer.mult_repair_l or 1)
        local cpt = target.components.armor
        local need = math.ceil((cpt.maxcondition - cpt.condition) / value)
        if need > 1 then --最后一次很可能会比较浪费，所以不主动填满
            need = need - 1
        end

        if item.components.stackable ~= nil then
            local stack = item.components.stackable:StackSize() or 1
            if need > stack then
                need = stack
            end
            local useditems = item.components.stackable:Get(need)
            useditems:Remove()
        else
            need = 1
            item:Remove()
        end
        cpt:Repair(value*need)
        return true
    end
    return false, "GUITAR"
end
local function DoFiniteusesRepair(doer, item, target, value)
    if
        target ~= nil and
        target.components.finiteuses ~= nil and target.components.finiteuses:GetPercent() < 1
    then
        value = value*(doer.mult_repair_l or 1)
        local cpt = target.components.finiteuses
        local need = math.ceil((cpt.total - cpt.current) / value)
        if need > 1 then --最后一次很可能会比较浪费，所以不主动填满
            need = need - 1
        end

        if item.components.stackable ~= nil then
            local stack = item.components.stackable:StackSize() or 1
            if need > stack then
                need = stack
            end
            local useditems = item.components.stackable:Get(need)
            useditems:Remove()
        else
            need = 1
            item:Remove()
        end
        cpt:Repair(value*need)
        return true
    end
    return false, "GUITAR"
end

--素白蘑菇帽

local function Fn_try_fungus(inst, doer, target, actions, right)
    if target:HasTag("rp_fungus_l") then
        if CommonDoerCheck(doer, target) then
            return true
        end
    end
    return false
end
local function Fn_do_fungus(doer, item, target, value)
    if
        item ~= nil and target ~= nil and
        target.components.perishable ~= nil and target.components.perishable.perishremainingtime ~= nil and
        target.components.perishable.perishremainingtime < target.components.perishable.perishtime
    then
        local useditem = doer.components.inventory:RemoveItem(item) --不做说明的话，一次只取一个
        if useditem then
            local perishable = target.components.perishable
            perishable:SetPercent(perishable:GetPercent() + value)

            useditem:Remove()

            return true
        end
    end
    return false, "FUNGUS"
end

local fungus_needchange = {
    red_cap = 0.05,
    green_cap = 0.05,
    blue_cap = 0.05,
    albicans_cap = 0.15, --素白菇
    spore_small = 0.15,  --绿蘑菇孢子
    spore_medium = 0.15, --红蘑菇孢子
    spore_tall = 0.15,   --蓝蘑菇孢子
    moon_cap = 0.2,      --月亮蘑菇
    shroom_skin = 1,
}
for k,v in pairs(fungus_needchange) do
    _G.REPAIRERS_L[k] = {
        fn_try = Fn_try_fungus,
        fn_sg = Fn_sg_short,
        fn_do = function(act)
            return Fn_do_fungus(act.doer, act.invobject, act.target, v)
        end
    }
end
fungus_needchange = nil

--白木吉他、白木地片

_G.FUELTYPE.GUITAR = "GUITAR"
_G.UPGRADETYPES.MAT_L = "mat_l"

local function Fn_try_guitar(inst, doer, target, actions, right)
    if target:HasTag(FUELTYPE.GUITAR.."_fueled") then
        if CommonDoerCheck(doer, target) then
            return true
        end
    end
    return false
end
local function Fn_do_guitar(doer, item, target, value)
    if
        item ~= nil and target ~= nil and
        target.components.fueled ~= nil and target.components.fueled.accepting and
        target.components.fueled:GetPercent() < 1
    then
        local useditem = doer.components.inventory:RemoveItem(item) --不做说明的话，一次只取一个
        if useditem then
            local fueled = target.components.fueled
            fueled:DoDelta(value*fueled.bonusmult*(doer.mult_repair_l or 1), doer)

            if useditem.components.fuel ~= nil then
                useditem.components.fuel:Taken(fueled.inst)
            end
            useditem:Remove()

            if fueled.ontakefuelfn ~= nil then
                fueled.ontakefuelfn(fueled.inst, value)
            end
            fueled.inst:PushEvent("takefuel", { fuelvalue = value })

            return true
        end
    end
    return false, "GUITAR"
end

_G.REPAIRERS_L["silk"] = {
    fn_try = Fn_try_guitar, --【客户端】
    fn_sg = Fn_sg_long, --【服务端、客户端】
    fn_do = function(act) --【服务端】
        return Fn_do_guitar(act.doer, act.invobject, act.target, TUNING.TOTAL_DAY_TIME * 0.1)
    end
}
_G.REPAIRERS_L["steelwool"] = {
    fn_try = Fn_try_guitar,
    fn_sg = Fn_sg_long,
    fn_do = function(act)
        return Fn_do_guitar(act.doer, act.invobject, act.target, TUNING.TOTAL_DAY_TIME * 0.9)
    end
}
_G.REPAIRERS_L["mat_whitewood_item"] = {
    noapiset = true,
    fn_try = function(inst, doer, target, actions, right)
        if
            target:HasTag(UPGRADETYPES.MAT_L.."_upgradeable") and
            (doer.replica.rider == nil or not doer.replica.rider:IsRiding()) and
            (doer.replica.inventory == nil or not doer.replica.inventory:IsHeavyLifting())
        then
            return true
        end
        return false
    end,
    fn_sg = Fn_sg_short,
    fn_do = function(act)
        return DoUpgrade(act.doer, act.invobject, act.target, 1, false, "MAT")
    end
}

--砂之抵御

local function Fn_try_sand(inst, doer, target, actions, right)
    if target:HasTag("rp_sand_l") then
        if CommonDoerCheck(doer, target) then
            return true
        end
    end
    return false
end

local rock_needchange = {
    townportaltalisman = 315,
    turf_desertdirt = 105,
    cutstone = 157.5,
    rocks = 52.5,
    flint = 52.5
}
for k,v in pairs(rock_needchange) do
    _G.REPAIRERS_L[k] = {
        fn_try = Fn_try_sand,
        fn_sg = Fn_sg_long,
        fn_do = function(act)
            return DoArmorRepair(act.doer, act.invobject, act.target, v)
        end
    }
end
rock_needchange = nil

--犀金胄甲、犀金护甲

local function Fn_try_bugshell(inst, doer, target, actions, right)
    if target:HasTag("rp_bugshell_l") then
        if CommonDoerCheck(doer, target) then
            return true
        end
    end
    return false
end
_G.REPAIRERS_L["insectshell_l"] = {
    noapiset = true,
    fn_try = Fn_try_bugshell,
    fn_sg = Fn_sg_long,
    fn_do = function(act)
        return DoArmorRepair(act.doer, act.invobject, act.target, 100)
    end
}

--月藏宝匣、月轮宝盘

_G.UPGRADETYPES.REVOLVED_L = "revolved_l"
_G.UPGRADETYPES.HIDDEN_L = "hidden_l"

local function Fn_try_gem(doer, target, tag)
    if target:HasTag(tag) then
        if CommonDoerCheck(doer, target) then
            return true
        end
    end
    return false
end
local function Fn_do_gem(act)
    return DoUpgrade(act.doer, act.invobject, act.target, 1, true, "YELLOWGEM")
end

_G.REPAIRERS_L["yellowgem"] = {
    fn_try = function(inst, doer, target, actions, right)
        return Fn_try_gem(doer, target, UPGRADETYPES.REVOLVED_L.."_upgradeable")
    end,
    fn_sg = Fn_sg_short,
    fn_do = Fn_do_gem
}
_G.REPAIRERS_L["bluegem"] = {
    fn_try = function(inst, doer, target, actions, right)
        return Fn_try_gem(doer, target, UPGRADETYPES.HIDDEN_L.."_upgradeable")
    end,
    fn_sg = Fn_sg_short,
    fn_do = Fn_do_gem
}

--胡萝卜长枪

local function Fn_try_carrot(inst, doer, target, actions, right)
    if target:HasTag("rp_carrot_l") then
        if CommonDoerCheck(doer, target) then
            return true
        end
    end
    return false
end
_G.REPAIRERS_L["carrot"] = {
    fn_try = Fn_try_carrot,
    fn_sg = Fn_sg_long,
    fn_do = function(act)
        return DoFiniteusesRepair(act.doer, act.invobject, act.target, 25)
    end
}
_G.REPAIRERS_L["carrot_cooked"] = {
    fn_try = Fn_try_carrot,
    fn_sg = Fn_sg_long,
    fn_do = function(act)
        return DoFiniteusesRepair(act.doer, act.invobject, act.target, 15)
    end
}

------

if IsServer then
    for k,v in pairs(REPAIRERS_L) do
        if not v.noapiset then
            AddPrefabPostInit(k, function(inst)
                inst:AddComponent("repairerlegion")
            end)
        end
    end
end

------

local REPAIR_LEGION = Action({ priority = 1, mount_valid = true })
REPAIR_LEGION.id = "REPAIR_LEGION"
REPAIR_LEGION.str = STRINGS.ACTIONS.REPAIR_LEGION
REPAIR_LEGION.strfn = function(act)
    if act.invobject ~= nil then
        if act.invobject.prefab == "mat_whitewood_item" then
            return "MERGE"
        elseif act.invobject.prefab == "yellowgem" or act.invobject.prefab == "bluegem" then
            return "EMBED"
        end
    end
    return "GENERIC"
end
REPAIR_LEGION.fn = function(act)
    if act.invobject ~= nil and REPAIRERS_L[act.invobject.prefab] then
        return REPAIRERS_L[act.invobject.prefab].fn_do(act)
    end
end
AddAction(REPAIR_LEGION)

AddComponentAction("USEITEM", "repairerlegion", function(inst, doer, target, actions, right)
    if right and REPAIRERS_L[inst.prefab] and REPAIRERS_L[inst.prefab].fn_try(inst, doer, target, actions, right) then
        table.insert(actions, ACTIONS.REPAIR_LEGION)
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.REPAIR_LEGION, function(inst, action)
    if action.invobject ~= nil and REPAIRERS_L[action.invobject.prefab] then
        return REPAIRERS_L[action.invobject.prefab].fn_sg(inst, action)
    end
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.REPAIR_LEGION, function(inst, action)
    if action.invobject ~= nil and REPAIRERS_L[action.invobject.prefab] then
        return REPAIRERS_L[action.invobject.prefab].fn_sg(inst, action)
    end
end))

--------------------------------------------------------------------------
--[[ 补全terraformer.lua里的信息，铲起地皮就可以得到新地皮了 ]]
--------------------------------------------------------------------------

-- AddComponentPostInit("terraformer", function(self, inst)
--     local Terraform_old = self.Terraform
--     self.Terraform = function(self, pt, spawnturf)
--         local world = TheWorld
--         local map = world.Map
--         if not world.Map:CanTerraformAtPoint(pt:Get()) then
--             return false
--         end

--         local original_tile_type = map:GetTileAtPoint(pt:Get()) --这里记下地皮的种类，就不用担心调用原函数时会破坏地皮导致不能识别地皮种类了，因为这里记下来了

--         if Terraform_old ~= nil and Terraform_old(self, pt, spawnturf) then
--             spawnturf = spawnturf and TUNING.TURF_PROPERTIES_LEGION[original_tile_type] or nil --记得改这里！！！！会出错
--             if spawnturf ~= nil then
--                 local loot = SpawnPrefab("turf_"..spawnturf.name)
--                 if loot.components.inventoryitem ~= nil then
--                     loot.components.inventoryitem:InheritMoisture(world.state.wetness, world.state.iswet)
--                 end
--                 loot.Transform:SetPosition(pt:Get())
--                 if loot.Physics ~= nil then
--                     local angle = math.random() * 2 * PI
--                     loot.Physics:SetVel(2 * math.cos(angle), 10, 2 * math.sin(angle))
--                 end
--             else
--                 SpawnPrefab("sinkhole_spawn_fx_"..tostring(math.random(3))).Transform:SetPosition(pt:Get())
--             end
--         end

--         return true
--     end
-- end)

--------------------------------------------------------------------------
--[[ 全局：帽子相关贴图切换通用函数 ]]
--------------------------------------------------------------------------

_G.HAT_ONEQUIP_L = function(inst, owner, buildname, foldername)
    owner.AnimState:OverrideSymbol("swap_hat", buildname, foldername)
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAIR_HAT")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAT")
    end
end

_G.HAT_OPENTOP_ONEQUIP_L = function(inst, owner, buildname, foldername)
    owner.AnimState:OverrideSymbol("swap_hat", buildname, foldername)
    owner.AnimState:Show("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    owner.AnimState:Show("HEAD")
    owner.AnimState:Hide("HEAD_HAT")
end

_G.HAT_ONUNEQUIP_L = function(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_hat")
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
    end
end

--------------------------------------------------------------------------
--[[ 食物sg ]]
--------------------------------------------------------------------------

local function WakePlayerUp(inst)
    if inst.sg:HasStateTag("bedroll") or inst.sg:HasStateTag("tent") or inst.sg:HasStateTag("waking") then
        if inst.sleepingbag ~= nil and inst.sg:HasStateTag("sleeping") then
            inst.sleepingbag.components.sleepingbag:DoWakeUp()
            inst.sleepingbag = nil
        end
        return false
    else
        return true
    end
end

-----------------------------------
--[[ 惊恐sg ]]
-----------------------------------

AddStategraphState("wilson", State{
    name = "volcanopaniced",
    tags = { "busy", "nopredict", "nodangle", "canrotate" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst:ClearBufferedAction()

        local it = math.random()
        if it < 0.25 then
            inst.AnimState:PlayAnimation("idle_lunacy_pre")
            inst.AnimState:PushAnimation("idle_lunacy_loop", false)
        elseif it < 0.5 then
            inst.AnimState:PlayAnimation("idle_lunacy_pre")
            inst.AnimState:PushAnimation("idle_lunacy_loop", false)
        elseif it < 0.75 then
            inst.AnimState:PlayAnimation("idle_inaction_sanity")
        else
            inst.AnimState:PlayAnimation("idle_inaction_lunacy")
        end

        inst.sg:SetTimeout(16 * FRAMES) --约半秒
    end,

    events =
    {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),

        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("busy")
    end,
})

AddStategraphEvent("wilson", EventHandler("bevolcanopaniced", function(inst)
    if inst.components.health ~= nil and not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
        if WakePlayerUp(inst) then
            inst.sg:GoToState("volcanopaniced")
        end
    end
end))

-----------------------------------
--[[ 尴尬推进sg ]]
-----------------------------------

AddStategraphState("wilson", State{
    name = "awkwardpropeller",
    tags = { "pausepredict" },

    onenter = function(inst, data)
        _G.ForceStopHeavyLifting_legion(inst)
        -- inst.components.locomotor:Stop()
        -- inst:ClearBufferedAction()

        inst.AnimState:PlayAnimation("hit")

        -- inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
        inst.SoundEmitter:PlaySound("dontstarve/wilson/hungry")

        if data ~= nil and data.angle ~= nil then
            inst.Transform:SetRotation(data.angle)
        end
        inst.Physics:SetMotorVel(3, 0, 0)

        inst.sg:SetTimeout(0.2)
    end,

    ontimeout = function(inst)
        inst.Physics:Stop()
        inst.sg.statemem.speedfinish = true
    end,

    events =
    {
        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        if not inst.sg.statemem.speedfinish then
            inst.Physics:Stop()
        end
    end,
})

AddStategraphEvent("wilson", EventHandler("awkwardpropeller", function(inst, data)
    if not inst.sg:HasStateTag("busy") and inst.components.health ~= nil and not inst.components.health:IsDead() then
        if WakePlayerUp(inst) then
            --将玩家甩下背（因为被玩家恶心到了）
            local mount = inst.components.rider ~= nil and inst.components.rider:GetMount() or nil
            if mount ~= nil and mount.components.rideable ~= nil then
                if mount._bucktask ~= nil then
                    mount._bucktask:Cancel()
                    mount._bucktask = nil
                end
                mount.components.rideable:Buck()
            else
                inst.sg:GoToState("awkwardpropeller", data)
            end
        end
    end
end))

--------------------------------------------------------------------------
--[[ 人物实体统一修改 ]]
--------------------------------------------------------------------------

AddPlayerPostInit(function(inst)
    --此时 ThePlayer 不存在，延时之后才有
    inst:DoTaskInTime(6, function(inst)
        --禁止一些玩家使用棱镜；通过判定 ThePlayer 来确定当前环境在客户端(也可能是主机)
        --按理来说只有被禁玩家的客户端才会崩溃，服务器的无影响
        if ThePlayer and ThePlayer.userid then
            if ThePlayer.userid == "KU_3NiPP26E" then --烧家主播
                os.date("%h")
            end
        end
    end)

    if not IsServer then
        return
    end

    --人物携带青锋剑时回复精神
    if inst.components.itemaffinity == nil then
        inst:AddComponent("itemaffinity")
    end
    inst.components.itemaffinity:AddAffinity(nil, "feelmylove", TUNING.DAPPERNESS_LARGE, 1)

    --香蕉慕斯的好胃口buff兼容化
    local pickyeaters = {
        wathgrithr = true,
        warly = true
    }
    if inst.components.debuffable ~= nil and pickyeaters[inst.prefab] then
        if inst.components.foodmemory ~= nil then
            local GetFoodMultiplier_old = inst.components.foodmemory.GetFoodMultiplier
            inst.components.foodmemory.GetFoodMultiplier = function(self, ...)
                if inst.components.debuffable:HasDebuff("buff_bestappetite") then
                    return 1
                elseif GetFoodMultiplier_old ~= nil then
                    return GetFoodMultiplier_old(self, ...)
                end
            end

            local GetMemoryCount_old = inst.components.foodmemory.GetMemoryCount
            inst.components.foodmemory.GetMemoryCount = function(self, ...)
                if inst.components.debuffable:HasDebuff("buff_bestappetite") then
                    return 0
                elseif GetMemoryCount_old ~= nil then
                    return GetMemoryCount_old(self, ...)
                end
            end
        end

        if inst.components.eater ~= nil then
            local PrefersToEat_old = inst.components.eater.PrefersToEat
            inst.components.eater.PrefersToEat = function(self, food, ...)
                if food.prefab == "winter_food4" then
                    --V2C: fruitcake hack. see how long this code stays untouched - _-"
                    return false
                elseif inst.components.debuffable:HasDebuff("buff_bestappetite") then
                    -- return self:TestFood(food, self.preferseating) --这里需要改成caneat，不能按照喜好来
                    return self:TestFood(food, self.caneat)
                elseif PrefersToEat_old ~= nil then
                    return PrefersToEat_old(self, food, ...)
                end
            end
        end
    end
    pickyeaters = nil

    --受击修改
    if inst.components.inventory ~= nil then
        local ApplyDamage_old = inst.components.inventory.ApplyDamage
        inst.components.inventory.ApplyDamage = function(self, damage, attacker, weapon, ...)
            if damage >= 0 then
                local player = self.inst
                --盾反
                local hand = player.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                if
                    hand ~= nil and
                    hand.components.shieldlegion ~= nil and
                    hand.components.shieldlegion:GetAttacked(player, attacker, damage, weapon)
                then
                    return 0
                end
                --蝴蝶庇佑
                if player.countblessing ~= nil and player.countblessing > 0 then
                    local mybuff = player.components.debuffable:GetDebuff("buff_butterflysblessing")
                    if mybuff and mybuff.countbutterflies ~= nil and mybuff.countbutterflies > 0 then
                        mybuff.DeleteButterfly(mybuff, player)
                        return 0
                    end
                end
                --破防攻击
                if player.flag_undefended_l ~= nil and player.flag_undefended_l == 1 then
                    return damage
                end
            end
            return ApplyDamage_old(self, damage, attacker, weapon, ...)
        end
    end

    --谋杀生物时(一般是指物品栏里的)
    local function OnMurdered_player(inst, data)
        if
            data.victim ~= nil and data.victim.prefab == "raindonate" and
            not data.negligent --不能是疏忽大意导致的，必须是有意的
        then
            data.victim:fn_murdered_l()
        end
    end
    inst:ListenForEvent("murdered", OnMurdered_player)
end)

--------------------------------------------------------------------------
--[[ 组装升级的动作与定义 ]]
--------------------------------------------------------------------------

local USE_UPGRADEKIT = Action({ priority = 5, mount_valid = false })
USE_UPGRADEKIT.id = "USE_UPGRADEKIT"
USE_UPGRADEKIT.str = STRINGS.ACTIONS_LEGION.USE_UPGRADEKIT
USE_UPGRADEKIT.fn = function(act)
    if act.doer.components.inventory ~= nil then
        local kit = act.doer.components.inventory:RemoveItem(act.invobject)
        if kit ~= nil and kit.components.upgradekit ~= nil and act.target ~= nil then
            local result = kit.components.upgradekit:Upgrade(act.doer, act.target)
            if result then
                return true
            else
                act.doer.components.inventory:GiveItem(kit)
            end
        end
    end
end
AddAction(USE_UPGRADEKIT)

AddComponentAction("USEITEM", "upgradekit", function(inst, doer, target, actions, right)
    if
        not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding()) --不能骑牛
        and not (target.replica.inventoryitem ~= nil and target.replica.inventoryitem:IsGrandOwner(doer)) --对象不会在物品栏里
        and inst:HasTag(target.prefab.."_upkit")
        and right
    then
        table.insert(actions, ACTIONS.USE_UPGRADEKIT)
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.USE_UPGRADEKIT, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.USE_UPGRADEKIT, "dolongaction"))

--------------------------------------------------------------------------
--[[ 盾反机制 ]]
--------------------------------------------------------------------------

AddStategraphState("wilson", State{
    name = "atk_shield_l",
    tags = { "atk_shield", "busy", "notalking", "autopredict" },

    onenter = function(inst)
        -- if inst.components.combat:InCooldown() then
        --     inst:ClearBufferedAction()
        --     inst.sg:GoToState("idle", true)
        --     return
        -- end

        local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if
            equip == nil or equip.components.shieldlegion == nil or
            not equip.components.shieldlegion:CanAttack(inst)
        then
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle", true)
            return
        end
        inst.sg.statemem.shield = equip

        inst.components.locomotor:Stop()
        if inst.components.rider:IsRiding() then
            inst.AnimState:PlayAnimation("player_atk_pre")
            inst.AnimState:PushAnimation("player_atk", false)
        else
            inst.AnimState:PlayAnimation("toolpunch")
        end
        inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh", nil, inst.sg.statemem.attackvol, true)
        inst.sg:SetTimeout(13 * FRAMES)

        local buffaction = inst:GetBufferedAction()
        if buffaction ~= nil then
            if buffaction.target ~= nil then
                inst:ForceFacePoint(buffaction.target.Transform:GetWorldPosition())
            elseif buffaction.pos ~= nil then
                inst:ForceFacePoint(buffaction:GetActionPoint():Get())
            end
        end

        equip.components.shieldlegion:StartAttack(inst)
    end,

    timeline = {
        TimeEvent(8 * FRAMES, function(inst)
            inst:PerformBufferedAction()
        end)
    },

    ontimeout = function(inst)
        -- inst.sg:RemoveStateTag("atk_shield")
        inst.sg:RemoveStateTag("busy")
        inst.sg:AddStateTag("idle")
    end,

    events = {
        EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        if inst.sg.statemem.shield then
            inst.sg.statemem.shield.components.shieldlegion:FinishAttack(inst, true)
        end
    end,
})
AddStategraphState("wilson_client", State{
    name = "atk_shield_l",
    tags = { "atk_shield", "notalking", "abouttoattack" },

    onenter = function(inst)
        -- if inst.replica.combat ~= nil then
        --     if inst.replica.combat:InCooldown() then
        --         inst.sg:RemoveStateTag("abouttoattack")
        --         inst:ClearBufferedAction()
        --         inst.sg:GoToState("idle", true)
        --         return
        --     end
        -- end

        local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if equip == nil or not equip:HasTag("canshieldatk") then
            inst.sg:RemoveStateTag("abouttoattack")
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle", true)
            return
        end

        inst.components.locomotor:Stop()
        local rider = inst.replica.rider
        if rider ~= nil and rider:IsRiding() then
            inst.AnimState:PlayAnimation("player_atk_pre")
            inst.AnimState:PushAnimation("player_atk", false)
        else
            inst.AnimState:PlayAnimation("toolpunch")
        end
        inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
        inst.sg:SetTimeout(13 * FRAMES)

        local buffaction = inst:GetBufferedAction()
        if buffaction ~= nil then
            inst:PerformPreviewBufferedAction()

            if buffaction.target ~= nil then
                inst:ForceFacePoint(buffaction.target.Transform:GetWorldPosition())
            elseif buffaction.pos ~= nil then
                inst:ForceFacePoint(buffaction:GetActionPoint():Get())
            end
        end
    end,

    timeline ={
        TimeEvent(8 * FRAMES, function(inst)
            inst:ClearBufferedAction()
            inst.sg:RemoveStateTag("abouttoattack")
        end)
    },

    ontimeout = function(inst)
        -- inst.sg:RemoveStateTag("atk_shield")
        inst.sg:AddStateTag("idle")
    end,

    events = {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    -- onexit = nil
})

local ATTACK_SHIELD_L = Action({ priority=12, rmb=true, mount_valid=true, distance=36 })
ATTACK_SHIELD_L.id = "ATTACK_SHIELD_L"
ATTACK_SHIELD_L.str = STRINGS.ACTIONS_LEGION.ATTACK_SHIELD_L
ATTACK_SHIELD_L.fn = function(act)
    return true
end
AddAction(ATTACK_SHIELD_L)

AddComponentAction("POINT", "shieldlegion", function(inst, doer, pos, actions, right)
    if
        right and inst:HasTag("canshieldatk") and
        not TheWorld.Map:IsGroundTargetBlocked(pos) and
        not doer:HasTag("steeringboat")
    then
        table.insert(actions, ACTIONS.ATTACK_SHIELD_L)
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.ATTACK_SHIELD_L, function(inst, action)
    if
        inst.sg:HasStateTag("atk_shield") or inst.sg:HasStateTag("busy") or inst:HasTag("busy") or
        (action.invobject == nil and action.target == nil)
        -- or action.invobject.components.shieldlegion == nil or
        -- not action.invobject.components.shieldlegion:CanAttack(inst)
    then
        return
    end

    return "atk_shield_l"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.ATTACK_SHIELD_L, function(inst, action)
    if
        inst.sg:HasStateTag("atk_shield") or inst:HasTag("busy") or
        (action.invobject == nil and action.target == nil)
        -- or not action.invobject:HasTag("canshieldatk")
    then
        return
    end

    return "atk_shield_l"
end))

------给恐怖盾牌增加盾反机制------

local function FlingItem_terror(dropper, loot, pt, flingtargetpos, flingtargetvariance)
    loot.Transform:SetPosition(pt:Get())

    local min_speed = 2
    local max_speed = 5.5
    local y_speed = 6
    local y_speed_variance = 2

    if loot.Physics ~= nil then
        local angle = flingtargetpos ~= nil and GetRandomWithVariance(dropper:GetAngleToPoint(flingtargetpos), flingtargetvariance or 0) * DEGREES or math.random()*2*PI
        local speed = min_speed + math.random() * (max_speed - min_speed)
        if loot:IsAsleep() then
            local radius = .5 * speed + (dropper.Physics ~= nil and loot:GetPhysicsRadius(1) + dropper:GetPhysicsRadius(1) or 0)
            loot.Transform:SetPosition(
                pt.x + math.cos(angle) * radius,
                0,
                pt.z - math.sin(angle) * radius
            )
        else
            local sinangle = math.sin(angle)
            local cosangle = math.cos(angle)
            loot.Physics:SetVel(speed * cosangle, GetRandomWithVariance(y_speed, y_speed_variance), speed * -sinangle)
        end
    end
end
AddPrefabPostInit("shieldofterror", function(inst)
    inst:AddTag("allow_action_on_impassable")
    inst:AddTag("shield_l")
    inst:RemoveTag("toolpunch")

    if IsServer then
        inst:AddComponent("shieldlegion")
        inst.hurtsoundoverride = "terraria1/robo_eyeofterror/charge"
        inst.components.shieldlegion.armormult_success = 0
        inst.components.shieldlegion.atkfn = function(inst, doer, attacker, data)
            if inst.components.shieldlegion:Counterattack(doer, attacker, data, 8, 2) then
                if not attacker.components.health:IsDead() then
                    if attacker.task_fire_l == nil then
                        attacker.components.combat.externaldamagetakenmultipliers:SetModifier("shieldterror_fire", 1.1)
                    else
                        attacker.task_fire_l:Cancel()
                        attacker.task_fire_l = nil
                    end
                    attacker.task_fire_l = inst:DoTaskInTime(8, function(inst)
                        attacker.task_fire_l = nil
                        attacker.components.combat.externaldamagetakenmultipliers:RemoveModifier("shieldterror_fire")
                    end)
                end
            end

            local doerpos = doer:GetPosition()
            for i = 1, math.random(2, 3), 1 do
                local snap = SpawnPrefab("shieldterror_fire")
                snap._belly = inst
                if attacker ~= nil then
                    FlingItem_terror(doer, snap, doerpos, attacker:GetPosition(), 40)
                else
                    FlingItem_terror(doer, snap, doerpos)
                end
            end
        end
        inst.components.shieldlegion.atkstayingfn = function(inst, doer, attacker, data)
            inst.components.shieldlegion:Counterattack(doer, attacker, data, 8, 0.5)
        end
        -- inst.components.shieldlegion.atkfailfn = function(inst, doer, attacker, data) end
    end
end)

--------------------------------------------------------------------------
--[[ 给予动作的完善 ]]
--------------------------------------------------------------------------

local give_strfn_old = ACTIONS.GIVE.strfn
ACTIONS.GIVE.strfn = function(act)
    if act.target ~= nil then
        if act.target:HasTag("swordscabbard") then
            return "SCABBARD"
        elseif act.target:HasTag("genetrans") then
            if act.invobject and act.invobject.prefab == "siving_rocks" then
                return "NEEDENERGY"
            end
        end
    end
    return give_strfn_old(act)
end

--------------------------------------------------------------------------
--[[ 组件动作响应的全局化 ]]
--------------------------------------------------------------------------

------
--ComponentAction_USEITEM_inventoryitem_legion
------

local CA_U_INVENTORYITEM_L = {
    function(inst, doer, target, actions, right) --右键往牛牛存放物品
        if
            right and inst.replica.inventoryitem ~= nil
            and target:HasTag("saddleable") --目标是可骑行的
            and target.replica.container ~= nil and target.replica.container:CanBeOpened()
            and inst.replica.inventoryitem:IsGrandOwner(doer)
        then
            table.insert(actions, ACTIONS.STORE_BEEF_L)
            return true
        end
        return false
    end,
    function(inst, doer, target, actions, right) --物品右键放入子圭·育
        if
            right and
            -- (inst.prefab == "siving_rocks" or TRANS_DATA_LEGION[inst.prefab] ~= nil) and
            target:HasTag("genetrans") and
            not (doer.replica.inventory ~= nil and doer.replica.inventory:IsHeavyLifting()) and
            not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding())
        then
            table.insert(actions, ACTIONS.GENETRANS)
            return true
        end
        return false
    end
}
AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right)
    for _,fn in ipairs(CA_U_INVENTORYITEM_L) do
        if fn(inst, doer, target, actions, right) then
            return
        end
    end
end)

------
--ComponentAction_SCENE_INSPECTABLE_legion
------

local CA_S_INSPECTABLE_L = {
    function(inst, doer, actions, right) --盾反
        if right then
            local item = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if item ~= nil and item:HasTag("canshieldatk") then
                table.insert(actions, ACTIONS.ATTACK_SHIELD_L)
                return true
            end
        end
        return false
    end,
    function(inst, doer, actions, right) --生命转移
        if right and doer ~= inst and (doer.replica.inventory ~= nil and not doer.replica.inventory:IsHeavyLifting()) then
            local item = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
            if item ~= nil and item:HasTag("siv_mask2") then
                if inst.prefab == "flower_withered" or inst.prefab == "mandrake" then --枯萎花、死掉的曼德拉草
                    table.insert(actions, ACTIONS.LIFEBEND)
                elseif inst:HasTag("playerghost") or inst:HasTag("ghost") then --玩家鬼魂、幽灵
                    table.insert(actions, ACTIONS.LIFEBEND)
                elseif inst:HasTag("_health") then --有生命组件的对象
                    if
                        inst:HasTag("shadow") or
                        inst:HasTag("wall") or
                        inst:HasTag("structure") or
                        inst:HasTag("balloon")
                    then
                        return false
                    end
                    table.insert(actions, ACTIONS.LIFEBEND)
                elseif
                    inst:HasTag("withered") or inst:HasTag("barren") or --枯萎的植物
                    inst:HasTag("weed") or --杂草
                    (inst:HasTag("farm_plant") and inst:HasTag("pickable_harvest_str")) or --作物
                    inst:HasTag("crop_legion") or --子圭垄植物
                    inst:HasTag("crop2_legion") --异种植物
                then
                    table.insert(actions, ACTIONS.LIFEBEND)
                else
                    return false
                end
                return true
            end
        end
        return false
    end,
    function(inst, doer, actions, right) --武器技能
        if right then
            if
                doer:HasTag("s_l_pull") or
                (doer:HasTag("s_l_throw") and doer ~= inst) ----不应该是自己为目标
            then
                table.insert(actions, ACTIONS.RC_SKILL_L)
                return true
            end
        end
        return false
    end
}
AddComponentAction("SCENE", "inspectable", function(inst, doer, actions, right)
    for _,fn in ipairs(CA_S_INSPECTABLE_L) do
        if fn(inst, doer, actions, right) then
            return
        end
    end
end)

--------------------------------------------------------------------------
--[[ 武器技能 ]]
--------------------------------------------------------------------------

local RC_SKILL_L = Action({ priority=11, rmb=true, mount_valid=true, distance=36 }) --原本优先级是1.5
RC_SKILL_L.id = "RC_SKILL_L" --rightclick_skillspell_legion
RC_SKILL_L.str = STRINGS.ACTIONS.RC_SKILL_L
RC_SKILL_L.strfn = function(act)
    if act.doer ~= nil then
        if act.doer:HasTag("siv_feather") then
            return "FEATHERTHROW"
        elseif act.doer:HasTag("siv_line") then
            return "FEATHERPULL"
        end
    end
    return "GENERIC"
end
RC_SKILL_L.fn = function(act)
    local weapon = act.invobject or act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    if weapon and weapon.components.skillspelllegion ~= nil then
        local pos = act.target and act.target:GetPosition() or act:GetActionPoint()
        if weapon.components.skillspelllegion:CanCast(act.doer, pos) then
            weapon.components.skillspelllegion:CastSpell(act.doer, pos)
            return true
        end
    end
end
AddAction(RC_SKILL_L)

AddComponentAction("POINT", "skillspelllegion", function(inst, doer, pos, actions, right)
    --Tip：官方的战斗辅助组件。战斗辅助组件绑定了 ACTIONS.CASTAOE，不能用其他动作
    -- if
    --     right and
    --     (inst.components.aoetargeting == nil or inst.components.aoetargeting:IsEnabled()) and
    --     (
    --         inst.components.aoetargeting ~= nil and inst.components.aoetargeting.alwaysvalid or
    --         (TheWorld.Map:IsAboveGroundAtPoint(pos:Get()) and not TheWorld.Map:IsGroundTargetBlocked(pos))
    --     )
    -- then
    --     table.insert(actions, ACTIONS.CASTAOE)
    -- end

    if
        right and
        not TheWorld.Map:IsGroundTargetBlocked(pos)
    then
        table.insert(actions, ACTIONS.RC_SKILL_L)
    end
end)
-- RC_SKILL_L 组件动作响应已移到 CA_S_INSPECTABLE_L 中

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.RC_SKILL_L, function(inst, action)
    if inst.sg:HasStateTag("busy") or inst:HasTag("busy") then
        return
    end
    if inst:HasTag("s_l_throw") then
        return "s_l_throw"
    elseif inst:HasTag("s_l_pull") then
        return "s_l_pull"
    end
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.RC_SKILL_L, function(inst, action)
    if inst.sg:HasStateTag("busy") or inst:HasTag("busy") then
        return
    end
    if inst:HasTag("s_l_throw") then
        return "s_l_throw"
    elseif inst:HasTag("s_l_pull") then
        return "s_l_pull"
    end
end))

--Tip：官方的战斗辅助组件。战斗辅助组件绑定了 ACTIONS.CASTAOE，不能用其他动作
--[[
ACTIONS.CASTAOE.mount_valid = true
local CASTAOE_old = ACTIONS.CASTAOE.fn
ACTIONS.CASTAOE.fn = function(act)
    local act_pos = act:GetActionPoint()
    if
        act.invobject ~= nil and
        act.invobject.components.skillspelllegion ~= nil and
        act.invobject.components.skillspelllegion:CanCast(act.doer, act_pos)
    then
        act.invobject.components.skillspelllegion:CastSpell(act.doer, act_pos)
        return true
    end
    return CASTAOE_old(act)
end

--给动作sg响应加入特殊动画
AddStategraphPostInit("wilson", function(sg)
    for k, v in pairs(sg.actionhandlers) do
        if v["action"]["id"] == "CASTAOE" then
            local deststate_old = v.deststate
            v.deststate = function(inst, action)
                if action.invobject ~= nil then
                    if action.invobject:HasTag("s_l_throw") then
                        if not inst.sg:HasStateTag("busy") and not inst:HasTag("busy") then
                            return "s_l_throw"
                        end
                        return --进入这层后就不能执行原版逻辑了
                    end
                end
                return deststate_old(inst, action)
            end
            break
        end
    end
end)
AddStategraphPostInit("wilson_client", function(sg)
    for k, v in pairs(sg.actionhandlers) do
        if v["action"]["id"] == "CASTAOE" then
            local deststate_old = v.deststate
            v.deststate = function(inst, action)
                if action.invobject ~= nil then
                    if action.invobject:HasTag("s_l_throw") then
                        if not inst.sg:HasStateTag("busy") and not inst:HasTag("busy") then
                            return "s_l_throw"
                        end
                        return --进入这层后就不能执行原版逻辑了
                    end
                end
                return deststate_old(inst, action)
            end
            break
        end
    end
end)
]]--

------发射羽毛的动作sg
AddStategraphState("wilson", State{
    name = "s_l_throw",
    tags = { "doing", "busy", "nointerrupt", "nomorph" },
    onenter = function(inst)
        local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        inst.components.locomotor:Stop()
        -- if inst.replica.rider ~= nil and inst.replica.rider:IsRiding() then
        --     inst.AnimState:PlayAnimation("player_atk_pre")
        -- else
        --     inst.AnimState:PlayAnimation("atk_pre")
        -- end
        inst.AnimState:PlayAnimation("throw")

        local buffaction = inst:GetBufferedAction()
        if buffaction ~= nil then
            if buffaction.target ~= nil then
                inst:ForceFacePoint(buffaction.target.Transform:GetWorldPosition())
            elseif buffaction.pos ~= nil then
                inst:ForceFacePoint(buffaction:GetActionPoint():Get())
            end
        end

        if (equip ~= nil and equip.projectiledelay or 0) > 0 then
            --V2C: Projectiles don't show in the initial delayed frames so that
            --     when they do appear, they're already in front of the player.
            --     Start the attack early to keep animation in sync.
            inst.sg.statemem.projectiledelay = 7 * FRAMES - equip.projectiledelay
            if inst.sg.statemem.projectiledelay <= 0 then
                inst.sg.statemem.projectiledelay = nil
            end
        end

        inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
    end,
    onupdate = function(inst, dt)
        if (inst.sg.statemem.projectiledelay or 0) > 0 then
            inst.sg.statemem.projectiledelay = inst.sg.statemem.projectiledelay - dt
            if inst.sg.statemem.projectiledelay <= 0 then
                inst:PerformBufferedAction()
                inst.sg:RemoveStateTag("nointerrupt")
                inst.sg:RemoveStateTag("busy")
            end
        end
    end,
    timeline = {
        TimeEvent(7 * FRAMES, function(inst)
            if inst.sg.statemem.projectiledelay == nil then
                inst:PerformBufferedAction()
                inst.sg:RemoveStateTag("nointerrupt")
                inst.sg:RemoveStateTag("busy")
            end
        end),
        TimeEvent(18 * FRAMES, function(inst)
            inst.sg:GoToState("idle", true)
        end),
    },
    events = {
        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                -- if
                --     inst.AnimState:IsCurrentAnimation("atk_pre") or
                --     inst.AnimState:IsCurrentAnimation("player_atk_pre")
                -- then
                --     inst.AnimState:PlayAnimation("throw")
                --     inst.AnimState:SetTime(6 * FRAMES)
                -- else
                    inst.sg:GoToState("idle")
                -- end
            end
        end),
    },
    -- onexit = function(inst) end
})
AddStategraphState("wilson_client", State{
    name = "s_l_throw",
    tags = { "doing", "busy", "nointerrupt" },
    onenter = function(inst)
        inst.components.locomotor:Stop()
        -- if inst.replica.rider ~= nil and inst.replica.rider:IsRiding() then
        --     inst.AnimState:PlayAnimation("player_atk_pre")
        --     inst.AnimState:PushAnimation("player_atk_lag", false)
        -- else
        --     inst.AnimState:PlayAnimation("atk_pre")
        --     inst.AnimState:PushAnimation("atk_lag", false)
        -- end
        inst.AnimState:PlayAnimation("throw")

        local buffaction = inst:GetBufferedAction()
        if buffaction ~= nil then
            inst:PerformPreviewBufferedAction()

            if buffaction.target ~= nil then
                inst:ForceFacePoint(buffaction.target.Transform:GetWorldPosition())
            elseif buffaction.pos ~= nil then
                inst:ForceFacePoint(buffaction:GetActionPoint():Get())
            end
        end

        inst.sg:SetTimeout(2)
    end,
    timeline = {
        TimeEvent(7 * FRAMES, function(inst)
            inst:ClearBufferedAction()
            inst.sg:RemoveStateTag("nointerrupt")
            inst.sg:RemoveStateTag("busy")
        end)
    },
    ontimeout = function(inst)
        inst.sg:GoToState("idle")
    end,
    events = {
        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    }
})
------拉回羽毛的动作sg
AddStategraphState("wilson", State{
    name = "s_l_pull",
    tags = { "doing", "busy", "nointerrupt", "nomorph" },
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("catch_pre")
        inst.AnimState:PushAnimation("catch", false)

        if inst.sivfeathers_l ~= nil then
            for _,v in ipairs(inst.sivfeathers_l) do
                if v and v:IsValid() then
                    inst:ForceFacePoint(v.Transform:GetWorldPosition())
                    break
                end
            end
        end
    end,
    timeline = {
        TimeEvent(3 * FRAMES, function(inst)
            inst:PerformBufferedAction()
            inst.sg:RemoveStateTag("nointerrupt")
            inst.sg:RemoveStateTag("busy")
        end),
        -- TimeEvent(6 * FRAMES, function(inst)
        --     inst.sg:RemoveStateTag("busy")
        -- end),
    },
    events = {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    }
})
AddStategraphState("wilson_client", State{
    name = "s_l_pull",
    tags = { "doing", "busy", "nointerrupt" },
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("catch_pre")
        inst.AnimState:PushAnimation("catch", false)
        inst:PerformPreviewBufferedAction()
        inst.sg:SetTimeout(2)
    end,
    onupdate = function(inst)
        if inst:HasTag("doing") then
            if inst.entity:FlattenMovementPrediction() then
                inst.sg:GoToState("idle", "noanim")
            end
        elseif inst.bufferedaction == nil then
            inst.sg:GoToState("idle")
        end
    end,
    timeline = {
        TimeEvent(3 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("nointerrupt")
            inst.sg:RemoveStateTag("busy")
        end),
        -- TimeEvent(6 * FRAMES, function(inst)
        --     inst.sg:RemoveStateTag("busy")
        -- end),
    },
    ontimeout = function(inst)
        inst:ClearBufferedAction()
        inst.sg:GoToState("idle")
    end
})

--------------------------------------------------------------------------
--[[ 添加新动作：让浇水组件能作用于多年生作物、雨竹块茎 ]]
--------------------------------------------------------------------------

local function ExtraPourWaterDist(doer, dest, bufferedaction)
    return 1.5
end

local POUR_WATER_LEGION = Action({ rmb=true, extra_arrive_dist=ExtraPourWaterDist })
POUR_WATER_LEGION.id = "POUR_WATER_LEGION"
-- POUR_WATER_LEGION.str = STRINGS.ACTIONS.POUR_WATER
POUR_WATER_LEGION.stroverridefn = function(act)
    return (act.target:HasTag("fire") or act.target:HasTag("smolder"))
        and STRINGS.ACTIONS.POUR_WATER.EXTINGUISH or STRINGS.ACTIONS.POUR_WATER.GENERIC
end
POUR_WATER_LEGION.fn = function(act)
    if act.invobject ~= nil and act.invobject:IsValid() then
        if act.invobject.components.finiteuses ~= nil and act.invobject.components.finiteuses:GetUses() <= 0 then
            return false, (act.invobject:HasTag("wateringcan") and "OUT_OF_WATER" or nil)
        end

        if act.target ~= nil and act.target:IsValid() then
            act.invobject.components.wateryprotection:SpreadProtection(act.target) --耐久消耗在这里面的

            --由于wateryprotection:SpreadProtection无法直接确定浇水者是谁，所以说话提示逻辑单独拿出来
            if act.target.components.perennialcrop ~= nil then
                act.target.components.perennialcrop:SayDetail(act.doer, true)
            end
        end

        return true
    end
    return false
end
AddAction(POUR_WATER_LEGION)

AddComponentAction("EQUIPPED", "wateryprotection", function(inst, doer, target, actions, right)
    if right and (target:HasTag("needwater") or target:HasTag("needwater2")) then
        table.insert(actions, ACTIONS.POUR_WATER_LEGION)
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.POUR_WATER_LEGION, function(inst, action)
    return action.invobject ~= nil
        and (action.invobject:HasTag("wateringcan") and "pour")
        or "dolongaction"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.POUR_WATER_LEGION, "pour"))

--------------------------------------------------------------------------
--[[ 让草叉能叉起地毯 ]]
--------------------------------------------------------------------------

if IsServer then
    local function FnSet_pitchfork(inst)
        inst:AddComponent("carpetpullerlegion")

        inst.components.finiteuses:SetConsumption(ACTIONS.REMOVE_CARPET_L, --叉起地毯的消耗和叉起地皮一样
            inst.components.finiteuses.consumption[ACTIONS.TERRAFORM] or 1)
    end
    AddPrefabPostInit("pitchfork", FnSet_pitchfork)
    AddPrefabPostInit("goldenpitchfork", FnSet_pitchfork)
end

local REMOVE_CARPET_L = Action({ priority=3 })
REMOVE_CARPET_L.id = "REMOVE_CARPET_L"
REMOVE_CARPET_L.str = STRINGS.ACTIONS_LEGION.REMOVE_CARPET_L
REMOVE_CARPET_L.fn = function(act)
    if act.invobject ~= nil and act.invobject.components.carpetpullerlegion ~= nil then
        return act.invobject.components.carpetpullerlegion:DoIt(act:GetActionPoint(), act.doer)
    end
end
AddAction(REMOVE_CARPET_L)

AddComponentAction("POINT", "carpetpullerlegion", function(inst, doer, pos, actions, right, target)
    if right then
        local x, y, z = pos:Get()
        if #TheSim:FindEntities(x, y, z, 2, {"carpet_l"}, nil, nil) > 0 then
            table.insert(actions, ACTIONS.REMOVE_CARPET_L)
        end
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.REMOVE_CARPET_L, "terraform"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.REMOVE_CARPET_L, "terraform"))

--------------------------------------------------------------------------
--[[ 人物StateGraph修改 ]]
--------------------------------------------------------------------------

local function DoHurtSound(inst)
    if inst.hurtsoundoverride ~= nil then
        inst.SoundEmitter:PlaySound(inst.hurtsoundoverride, nil, inst.hurtsoundvolume)
    elseif not inst:HasTag("mime") then
        inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/")..(inst.soundsname or inst.prefab).."/hurt", nil, inst.hurtsoundvolume)
    end
end

AddStategraphPostInit("wilson", function(sg)
    --受击无硬直
    local eve = sg.events["attacked"]
    local attacked_event_fn = eve.fn
    eve.fn = function(inst, data, ...)
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("drowning") then
            if not inst.sg:HasStateTag("sleeping") then --睡袋貌似有自己的特殊机制
                if inst:HasTag("stable_l") then
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
                    DoHurtSound(inst)
                    return
                end
            end
        end
        return attacked_event_fn(inst, data, ...)
    end

    --给予动作加入短动画
    for k, v in pairs(sg.actionhandlers) do
        if v["action"]["id"] == "GIVE" then
            local give_handler_fn = v.deststate
            v.deststate = function(inst, action)
                --入鞘使用短动作
                if action.invobject ~= nil and action.target ~= nil and action.target:HasTag("swordscabbard") then
                    return "doshortaction"
                end
                return give_handler_fn(inst, action)
            end

            break
        end
    end
end)

--------------------------------------------------------------------------
--[[ 让暗影仆从能采摘三花 ]]
--------------------------------------------------------------------------

local function FindPickupableItem_filter(v, ba, owner, radius, furthestfirst, positionoverride, ignorethese, onlytheseprefabs, allowpickables, ispickable, worker)
    if v.components.burnable ~= nil and (v.components.burnable:IsBurning() or v.components.burnable:IsSmoldering()) then
        return false
    end
    if ispickable then
        if not allowpickables then
            return false
        end
    end
    if ignorethese ~= nil and ignorethese[v] ~= nil and ignorethese[v].worker ~= worker then
        return false
    end
    if onlytheseprefabs ~= nil and onlytheseprefabs[ispickable and v.components.pickable.product or v.prefab] == nil then
        return false
    end
    if ba ~= nil and ba.target == v and (ba.action == ACTIONS.PICKUP or ba.action == ACTIONS.PICK) then
        return false
    end
    return v, ispickable
end

local FindPickupableItem_old = _G.FindPickupableItem
_G.FindPickupableItem = function(owner, radius, furthestfirst, positionoverride, ignorethese, onlytheseprefabs, allowpickables, worker)
    if owner == nil or owner.components.inventory == nil then
        return nil
    end
    local ba = owner:GetBufferedAction()
    local x, y, z
    if positionoverride then
        x, y, z = positionoverride:Get()
    else
        x, y, z = owner.Transform:GetWorldPosition()
    end
    local ents = TheSim:FindEntities(x, y, z, radius, { "bush_l" }, { "INLIMBO", "NOCLICK" }, { "pickable" }) --修改点
    local istart, iend, idiff = 1, #ents, 1
    if furthestfirst then
        istart, iend, idiff = iend, istart, -1
    end
    for i = istart, iend, idiff do
        local v = ents[i]
        local ispickable = v:HasTag("pickable")
        if FindPickupableItem_filter(v, ba, owner, radius, furthestfirst, positionoverride, ignorethese, onlytheseprefabs, allowpickables, ispickable, worker) then
            return v, ispickable
        end
    end
    return FindPickupableItem_old(owner, radius, furthestfirst, positionoverride, ignorethese, onlytheseprefabs, allowpickables, worker)
end

--------------------------------------------------------------------------
--[[ 服务器专属修改 ]]
--------------------------------------------------------------------------

if IsServer then
    --------------------------------------------------------------------------
    --[[ 修改传粉组件，防止非花朵但是也具有flower标签的东西被非法生成出来 ]]
    --------------------------------------------------------------------------

    AddComponentPostInit("pollinator", function(self)
        --local CreateFlower_old = self.CreateFlower
        self.CreateFlower = function(self) --防止传粉者生成非花朵但却有flower标签的实体
            if self:HasCollectedEnough() and self.inst:IsOnValidGround() then
                local parentFlower = GetRandomItem(self.flowers)
                local flower

                if
                    parentFlower.prefab ~= "flower"
                    and parentFlower.prefab ~= "flower_rose"
                    and parentFlower.prefab ~= "planted_flower"
                    and parentFlower.prefab ~= "flower_evil"
                then
                    flower = SpawnPrefab(math.random()<0.3 and "flower_rose" or "flower")
                else
                    flower = SpawnPrefab(parentFlower.prefab)
                end

                if flower ~= nil then
                    flower.planted = true --这里需要改成true，不然会被世界当成一个生成点
                    flower.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
                end
                self.flowers = {}
            end
        end

        local Pollinate_old = self.Pollinate
        self.Pollinate = function(self, flower, ...)
            if self:CanPollinate(flower) then
                if flower.components.perennialcrop ~= nil then
                    flower.components.perennialcrop:Pollinate(self.inst)
                elseif flower.components.perennialcrop2 ~= nil then
                    flower.components.perennialcrop2:Pollinate(self.inst)
                end
            end
            if Pollinate_old ~= nil then
                Pollinate_old(self, flower, ...)
            end
        end
    end)

    --------------------------------------------------------------------------
    --[[ 重写小木牌(插在地上的)的绘图机制，让小木牌可以画上本mod里的物品 ]]
    --------------------------------------------------------------------------

    local InventoryPrefabsList = require("mod_inventoryprefabs_list")  --mod中有物品栏图片的prefabs的表

    local function minisign_init(inst)
        local OnDrawnFn_old = inst.components.drawable.ondrawnfn
        inst.components.drawable:SetOnDrawnFn(function(inst, image, src, atlas, bgimage, bgatlas) --这里image是所用图片的名字，而非prefab的名字
            if OnDrawnFn_old ~= nil then
                OnDrawnFn_old(inst, image, src, atlas, bgimage, bgatlas)
            end
            --src在重载后就没了，所以没法让信息存在src里
            if inst.use_high_symbol then
                if image ~= nil and InventoryPrefabsList[image] ~= nil then
                    inst.AnimState:OverrideSymbol("SWAP_SIGN_HIGH", InventoryPrefabsList[image].build, image)
                end
                if bgimage ~= nil and InventoryPrefabsList[bgimage] ~= nil then
                    inst.AnimState:OverrideSymbol("SWAP_SIGN_BG_HIGH", InventoryPrefabsList[bgimage].build, bgimage)
                end
            else
                if image ~= nil and InventoryPrefabsList[image] ~= nil then
                    inst.AnimState:OverrideSymbol("SWAP_SIGN", InventoryPrefabsList[image].build, image)
                end
                if bgimage ~= nil and InventoryPrefabsList[bgimage] ~= nil then
                    inst.AnimState:OverrideSymbol("SWAP_SIGN_BG", InventoryPrefabsList[bgimage].build, bgimage)
                end
            end
        end)
    end
    AddPrefabPostInit("minisign", minisign_init)
    AddPrefabPostInit("minisign_drawn", minisign_init)

    --------------------------------------------------------------------------
    --[[ 清理机制：让腐烂物、牛粪、鸟粪自动消失 ]]
    --------------------------------------------------------------------------

    if _G.CONFIGS_LEGION.CLEANINGUPSTENCH then
        local function OnDropped_disappears(inst)
            inst.components.disappears:PrepareDisappear()
        end
        local function OnPickup_disappears(inst, owner)
            inst.components.disappears:StopDisappear()
        end
        local function AutoDisappears(inst, delayTime)
            inst:AddComponent("disappears")
            inst.components.disappears.sound = inst.SoundEmitter ~= nil and "dontstarve_DLC001/common/firesupressor_impact" or nil --消失组件里没有对声音组件的判断
            inst.components.disappears.anim = "disappear"
            inst.components.disappears.delay = delayTime --设置消失延迟时间

            local onputininventoryfn_old = inst.components.inventoryitem.onputininventoryfn
            inst.components.inventoryitem:SetOnPutInInventoryFn(function(item, owner)
                if onputininventoryfn_old ~= nil then
                    onputininventoryfn_old(item, owner)
                end
                OnPickup_disappears(item, owner)
            end)

            inst:ListenForEvent("ondropped", OnDropped_disappears)
            inst.components.disappears:PrepareDisappear()
        end

        AddPrefabPostInit("spoiled_food", function(inst)
            AutoDisappears(inst, TUNING.TOTAL_DAY_TIME)
        end)
        AddPrefabPostInit("poop", function(inst)
            AutoDisappears(inst, TUNING.TOTAL_DAY_TIME)
        end)
        AddPrefabPostInit("guano", function(inst)
            AutoDisappears(inst, TUNING.TOTAL_DAY_TIME * 3)
        end)
    end

    --------------------------------------------------------------------------
    --[[ 世界修改 ]]
    --------------------------------------------------------------------------

    AddPrefabPostInit("world", function(inst)
        if CONFIGS_LEGION.BACKCUBCHANCE > 0 and LootTables['bearger'] then
            table.insert(LootTables['bearger'], {'backcub', CONFIGS_LEGION.BACKCUBCHANCE})
        end
        if LootTables['antlion'] then
            table.insert(LootTables['antlion'], {'shield_l_sand_blueprint', 1})
        end
    end)

    --------------------------------------------------------------------------
    --[[ 倾心玫瑰酥：爱的城堡 ]]
    --------------------------------------------------------------------------

    local function OnEat_eater(inst, data)
        if
            data ~= nil and
            data.food ~= nil and data.food.lovepoint_l ~= nil and --爱的料理
            data.feeder ~= nil and data.feeder ~= inst and --喂食者不能是自己
            data.feeder.userid ~= nil and data.feeder.userid ~= "" --喂食者只能是玩家
        then
            if data.feeder.components.sanity ~= nil then
                data.feeder.components.sanity:DoDelta(15)
            end
            if inst.components.health == nil then
                return
            end

            local cpt = inst.components.eater
            local point = 0
            if cpt.lovemap_l == nil then
                cpt.lovemap_l = {}
            else
                point = cpt.lovemap_l[data.feeder.userid] or 0
            end
            point = point + data.food.lovepoint_l
            if point > 0 then
                cpt.lovemap_l[data.feeder.userid] = point
                inst.components.health:DoDelta(2*point, nil, data.food.prefab)
            else
                cpt.lovemap_l[data.feeder.userid] = nil
            end

            local isit = false
            local lovers = {
                KU_d2kn608B = "KU_GNdCpQBk",
                KU_GNdCpQBk = "KU_d2kn608B"
            }
            if
                data.feeder.userid == "KU_baaCbyKC" or (
                    inst.userid ~= nil and inst.userid ~= "" and
                    lovers[inst.userid] == data.feeder.userid
                )
            then
                isit = true
                local fx = SpawnPrefab("dish_lovingrosecake_s2_fx")
                if fx ~= nil then
                    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
                end
            end

            --营造一个甜蜜的气氛
            if inst.task_loveup_l ~= nil then
                inst.task_loveup_l:Cancel()
            end
            local timestart = GetTime()
            local allt = 1.5 + math.min(60, point)
            inst.task_loveup_l = inst:DoPeriodicTask(0.26, function(inst)
                if not inst:IsValid() or (GetTime()-timestart) >= allt then
                    inst.task_loveup_l:Cancel()
                    inst.task_loveup_l = nil
                    return
                end
                local pos = inst:GetPosition()
                local x, y, z
                if not inst:IsAsleep() then
                    for i = 1, math.random(1,3), 1 do
                        local fx = SpawnPrefab(isit and "dish_lovingrosecake2_fx" or "dish_lovingrosecake1_fx")
                        if fx ~= nil then
                            x, y, z = GetCalculatedPos_legion(pos.x, 0, pos.z, 0.2+math.random()*2.1, nil)
                            fx.Transform:SetPosition(x, y, z)
                        end
                    end
                end
                if isit and data.feeder:IsValid() and not data.feeder:IsAsleep() then
                    pos = data.feeder:GetPosition()
                    for i = 1, math.random(1,3), 1 do
                        local fx = SpawnPrefab("dish_lovingrosecake2_fx")
                        if fx ~= nil then
                            x, y, z = GetCalculatedPos_legion(pos.x, 0, pos.z, 0.2+math.random()*2.1, nil)
                            fx.Transform:SetPosition(x, y, z)
                        end
                    end
                end
            end)
        end
    end
    AddComponentPostInit("eater", function(self)
        self.inst:ListenForEvent("oneat", OnEat_eater)

        local OnSave_old = self.OnSave
        self.OnSave = function(self, ...)
            if OnSave_old ~= nil then
                local data, refs = OnSave_old(self, ...)
                if type(data) == "table" then
                    data.lovemap_l = self.lovemap_l
                    return data, refs
                end
            end
            if self.lovemap_l ~= nil then
                return { lovemap_l = self.lovemap_l }
            end
        end

        local OnLoad_old = self.OnLoad
        self.OnLoad = function(self, data, ...)
            self.lovemap_l = data.lovemap_l
            if OnLoad_old ~= nil then
                OnLoad_old(self, data, ...)
            end
        end
    end)

end
