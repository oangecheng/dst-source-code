local prefs = {}

--------------------------------------------------------------------------
--[[ 通用函数 ]]
--------------------------------------------------------------------------

local function Counterattack_base(inst, doer, attacker, data, range, atk)
    local snap = SpawnPrefab("impact")
    local x, y, z = doer.Transform:GetWorldPosition()
    snap.Transform:SetScale(2, 2, 2)

    if inst.components.shieldlegion:Counterattack(doer, attacker, data, range, atk) then
        local x1, y1, z1 = attacker.Transform:GetWorldPosition()
        local angle = -math.atan2(z1 - z, x1 - x)
        snap.Transform:SetRotation(angle * RADIANS)
        snap.Transform:SetPosition(x1, y1, z1)
        return true
    else
        snap.Transform:SetPosition(x, y, z)
        return false
    end
end

local function OnEquipFn(inst, owner)
    if inst.components.skinedlegion ~= nil then
        local skindata = inst.components.skinedlegion:GetSkinedData()
        if skindata ~= nil and skindata.equip ~= nil then
            owner.AnimState:OverrideSymbol("lantern_overlay", skindata.equip.build, skindata.equip.file)
        else
            owner.AnimState:OverrideSymbol("lantern_overlay", inst.prefab, "swap_shield")
        end
    else
        owner.AnimState:OverrideSymbol("lantern_overlay", inst.prefab, "swap_shield")
    end

    owner.AnimState:HideSymbol("swap_object")

    --本来是想让这个和书本的攻击一样来低频率高伤害的方式攻击，但是由于会导致读书时也用本武器来显示动画，所以干脆去除了
    --owner.AnimState:OverrideSymbol("book_open", "swap_book_elemental", "book_open")
    --owner.AnimState:OverrideSymbol("book_closed", "swap_desertdefense_combat", "book_closed")    --替换book_closed就能正确显示特殊攻击动画
    --owner.AnimState:OverrideSymbol("book_open_pages", "swap_book_elemental", "book_open_pages")

    owner.AnimState:Show("ARM_carry") --显示持物手
    owner.AnimState:Hide("ARM_normal") --隐藏普通的手
    owner.AnimState:Show("LANTERN_OVERLAY")

    -- if owner:HasTag("equipmentmodel") then --假人！
    --     return
    -- end
end
local function OnUnequipFn(inst, owner)
    --owner.AnimState:ClearOverrideSymbol("book_closed")

    owner.AnimState:Hide("ARM_carry") --隐藏持物手
    owner.AnimState:Show("ARM_normal") --显示普通的手
    owner.AnimState:ClearOverrideSymbol("lantern_overlay")
    owner.AnimState:Hide("LANTERN_OVERLAY")
    owner.AnimState:ShowSymbol("swap_object")
end

local function SetNoBrokenArmor(inst, exfn)
    inst.components.armor.SetCondition = function(self, amount)
        if self.indestructible then
            return
        end

        local amountold = self.condition
        self.condition = math.min(amount, self.maxcondition)
        local _brokenshield = inst._brokenshield

        if self.condition <= 0 then
            self.condition = 0
            -- ProfileStatsSet("armor_broke_"..self.inst.prefab, true)
            -- ProfileStatsSet("armor", self.inst.prefab)
            -- if self.onfinished ~= nil then
            --     self.onfinished()
            -- end
            -- self.inst:Remove()
            inst._brokenshield = true
            inst.components.shieldlegion.canatk = false
        else
            inst._brokenshield = false
            inst.components.shieldlegion.canatk = true
        end

        if amountold ~= self.condition then
            self.inst:PushEvent("percentusedchange", { percent = self:GetPercent() })
            exfn(self, _brokenshield)
        end
    end
end

local function MakeShield(data)
	table.insert(prefs, Prefab(
		data.name,
		function()
            local inst = CreateEntity()
            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddNetwork()

            MakeInventoryPhysics(inst)

            inst.AnimState:SetBank(data.name)
            inst.AnimState:SetBuild(data.name)
            inst.AnimState:PlayAnimation("idle")

            inst:AddTag("allow_action_on_impassable")
            inst:AddTag("shield_l")

            --weapon (from weapon component) added to pristine state for optimization
            inst:AddTag("weapon")

            if data.fn_common ~= nil then
                data.fn_common(inst)
            end

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst:AddComponent("inspectable")

            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem.imagename = data.name
            inst.components.inventoryitem.atlasname = "images/inventoryimages/"..data.name..".xml"

            inst:AddComponent("shieldlegion")

            inst:AddComponent("equippable")
            inst.components.equippable.equipslot = EQUIPSLOTS.HANDS

            inst:AddComponent("weapon")

            inst:AddComponent("armor")

            MakeHauntableLaunch(inst)

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
--[[ 砂之抵御 ]]
--------------------------------------------------------------------------

local damage_sandstorms = 42.5  --34*1.25
local damage_normal = 30.6      --34*0.9
local damage_raining = 17       --34*0.5
local damage_broken = 3.4       --34*0.1

local absorb_sandstorms = 0.9
local absorb_normal = 0.75
local absorb_raining = 0.4
local absorb_broken = 0.1

local mult_success_sandstorms = 0.1
local mult_success_normal = 0.2
local mult_success_raining = 0.5

local function OnBlocked(owner, data)
    -- owner.SoundEmitter:PlaySound("dontstarve/common/together/teleport_sand/out")    --被攻击时播放像沙的声音
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_scalemail")

    if not TheWorld.state.israining then    --没下雨时被攻击就释放法术
        if
            data.attacker ~= nil and
            data.attacker.components.combat ~= nil and --攻击者有战斗组件
            data.attacker.components.health ~= nil and --攻击者有生命组件
            not data.attacker.components.health:IsDead() and --攻击者没死亡
            (data.weapon == nil or ((data.weapon.components.weapon == nil or data.weapon.components.weapon.projectile == nil) and data.weapon.components.projectile == nil)) and --不是远程武器
            not data.redirected
        then
            local map = TheWorld.Map
            local x, y, z = data.attacker.Transform:GetWorldPosition()
            if not map:IsVisualGroundAtPoint(x, 0, z) then --攻击者在水中，被动无效
                return
            end

            local num = 1
            local plus = 1.2
            if (owner.components.areaaware ~= nil and owner.components.areaaware:CurrentlyInTag("sandstorm"))
                and (not TheWorld:HasTag("cave") and TheWorld.state.issummer)
            then
                plus = 2.4
                num = math.random(3, 6)
            else
                num = math.random(1, 2)
            end

            for i = 1, num do
                local rad = math.random() * plus
                local angle = math.random() * 2 * PI
                local xxx = x + rad * math.cos(angle)
                local zzz = z - rad * math.sin(angle)

                if map:IsVisualGroundAtPoint(xxx, 0, zzz) then --不在水中
                    local sspike = SpawnPrefab("sandspike_legion")
                    if sspike ~= nil then
                        sspike.iscounterattack = true
                        sspike.Transform:SetPosition(xxx, 0, zzz)
                    end
                end
            end
        end
    end
end
local function onsandstorm(owner, area, weapon) --沙尘暴中属性上升
    local shield = nil
    if weapon ~= nil and weapon.prefab == "shield_l_sand" then
        shield = weapon
    else
        shield = owner ~= nil and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
        if shield == nil or shield.prefab ~= "shield_l_sand" then
            return
        end
    end

    if shield._brokenshield then
        shield.components.weapon:SetDamage(damage_broken)
        shield.components.armor:SetAbsorption(absorb_broken)
        return
    end

    --if TheWorld.components.sandstorms ~= nil and TheWorld.components.sandstorms:IsSandstormActive() then
    if not TheWorld:HasTag("cave") and TheWorld.state.issummer then
        --处于沙暴之中时
        if owner ~= nil and owner.components.areaaware ~= nil and owner.components.areaaware:CurrentlyInTag("sandstorm") then
            shield.components.weapon:SetDamage(damage_sandstorms)
            shield.components.armor:SetAbsorption(absorb_sandstorms)
            shield.components.shieldlegion.armormult_success = mult_success_sandstorms
            return
        end
    end
    shield.components.weapon:SetDamage(damage_normal)
    shield.components.armor:SetAbsorption(absorb_normal)
    shield.components.shieldlegion.armormult_success = mult_success_normal
end
local function onisraining(inst) --下雨时属性降低
    local owner = inst.components.inventoryitem.owner

    if TheWorld.state.israining then
        if owner ~= nil then owner:RemoveEventCallback("changearea", onsandstorm) end
        if inst._brokenshield then
            inst.components.weapon:SetDamage(damage_broken)
            inst.components.armor:SetAbsorption(absorb_broken)
        else
            inst.components.weapon:SetDamage(damage_raining)
            inst.components.armor:SetAbsorption(absorb_raining)
            inst.components.shieldlegion.armormult_success = mult_success_raining
        end
    else
        if inst._brokenshield then
            inst.components.weapon:SetDamage(damage_broken)
            inst.components.armor:SetAbsorption(absorb_broken)
        else
            onsandstorm(owner, nil, inst)   --不下雨时就刷新一次
        end
        if not TheWorld:HasTag("cave") and TheWorld.state.issummer then --不是在洞穴里，并且夏天时才会开始沙尘暴的监听
            if owner ~= nil then
                owner:ListenForEvent("changearea", onsandstorm) --因为这个消息由玩家发出，所以只好由玩家来监听了
            end
        end
    end
end

local function OnEquip_sand(inst, owner)
    OnEquipFn(inst, owner)
    if owner:HasTag("equipmentmodel") then --假人！
        return
    end

    onisraining(inst)   --装备时先更新一次

    inst:ListenForEvent("blocked", OnBlocked, owner)
    inst:ListenForEvent("attacked", OnBlocked, owner)

    inst:WatchWorldState("israining", onisraining)
    inst:WatchWorldState("issummer", onisraining)

    --能在沙暴中不减速行走
    if owner.components.locomotor ~= nil then
        if owner._runinsandstorm == nil then
            local oldfn = owner.components.locomotor.SetExternalSpeedMultiplier
            owner.components.locomotor.SetExternalSpeedMultiplier = function(self, source, key, m)
                if self.inst._runinsandstorm and key == "sandstorm" then
                    self:RemoveExternalSpeedMultiplier(self.inst, "sandstorm")
                    return
                end
                oldfn(self, source, key, m)
            end
        end
        -- owner.components.locomotor:RemoveExternalSpeedMultiplier(owner, "sandstorm") --切换装备时，下一帧会自动更新移速
        owner._runinsandstorm = true
    end
end
local function OnUnequip_sand(inst, owner)
    OnUnequipFn(inst, owner)
    if owner:HasTag("equipmentmodel") then --假人！
        return
    end

    inst:RemoveEventCallback("blocked", OnBlocked, owner)
    inst:RemoveEventCallback("attacked", OnBlocked, owner)

    owner:RemoveEventCallback("changearea", onsandstorm)
    inst:StopWatchingWorldState("israining", onisraining)
    inst:StopWatchingWorldState("issummer", onisraining)

    if owner.components.locomotor ~= nil then
        owner._runinsandstorm = false
    end
end
local function ShieldAtk_sand(inst, doer, attacker, data)
    OnBlocked(doer, { attacker = attacker })
    Counterattack_base(inst, doer, attacker, data, 8, 3)
end
local function ShieldAtkStay_sand(inst, doer, attacker, data)
    inst.components.shieldlegion:Counterattack(doer, attacker, data, 8, 1.5)
end

MakeShield({
    name = "shield_l_sand",
    assets = {
        Asset("ANIM", "anim/shield_l_sand.zip"),
        Asset("ATLAS", "images/inventoryimages/shield_l_sand.xml"),
        Asset("IMAGE", "images/inventoryimages/shield_l_sand.tex"),
    },
    prefabs = {
        "sandspike_legion",    --对玩家友好的沙之咬
        "shield_attack_l_fx",
    },
    fn_common = function(inst)
        inst:AddComponent("skinedlegion")
        inst.components.skinedlegion:Init("shield_l_sand")
    end,
    fn_server = function(inst)
        inst.components.inventoryitem:SetSinks(true) --它是石头做的，不可漂浮

        inst.components.equippable:SetOnEquip(OnEquip_sand)
        inst.components.equippable:SetOnUnequip(OnUnequip_sand)
        inst.components.equippable.insulated = true --设为true，就能防电

        inst.hurtsoundoverride = "dontstarve/creatures/together/antlion/sfx/break"
        inst.components.shieldlegion.armormult_success = mult_success_normal
        inst.components.shieldlegion.atkfn = ShieldAtk_sand
        inst.components.shieldlegion.atkstayingfn = ShieldAtkStay_sand
        -- inst.components.shieldlegion.atkfailfn = function(inst, doer, attacker, data) end

        inst.components.weapon:SetDamage(damage_normal)

        inst.components.armor:InitCondition(1050, absorb_normal) --150*10*0.7= 1050防具耐久
        SetNoBrokenArmor(inst, function(armorcpt, isbrokenbefore)
            if armorcpt.condition <= 0 then
                inst:AddTag("rp_sand_l")
                inst.components.equippable.insulated = false
                inst.components.weapon:SetDamage(damage_broken)
                inst.components.armor:SetAbsorption(absorb_broken)
            else
                if armorcpt.condition >= armorcpt.maxcondition then
                    inst:RemoveTag("rp_sand_l")
                else
                    inst:AddTag("rp_sand_l")
                end
                if isbrokenbefore then --说明是刚从损坏状态变成修复状态
                    inst.components.equippable.insulated = true
                    onisraining(inst)
                end
            end
        end)

        inst.components.skinedlegion:SetOnPreLoad()
    end,
})

--------------------------------------------------------------------------
--[[ 木盾 ]]
--------------------------------------------------------------------------

MakeShield({
    name = "shield_l_log",
    assets = {
        Asset("ANIM", "anim/shield_l_log.zip"),
        Asset("ATLAS", "images/inventoryimages/shield_l_log.xml"),
        Asset("IMAGE", "images/inventoryimages/shield_l_log.tex"),
    },
    prefabs = { "shield_attack_l_fx" },
    fn_common = function(inst)
        inst:AddComponent("skinedlegion")
        inst.components.skinedlegion:InitWithFloater("shield_l_log")
    end,
    fn_server = function(inst)
        inst.components.equippable:SetOnEquip(OnEquipFn)
        inst.components.equippable:SetOnUnequip(OnUnequipFn)

        inst.hurtsoundoverride = "dontstarve/wilson/hit_armour"
        inst.components.shieldlegion.armormult_success = 0.4
        inst.components.shieldlegion.atkfn = function(inst, doer, attacker, data)
            Counterattack_base(inst, doer, attacker, data, 6, 2.5)
        end
        inst.components.shieldlegion.atkstayingfn = function(inst, doer, attacker, data)
            inst.components.shieldlegion:Counterattack(doer, attacker, data, 6, 0.8)
        end
        -- inst.components.shieldlegion.atkfailfn = function(inst, doer, attacker, data) end

        inst.components.weapon:SetDamage(27.2) --34*0.8

        inst.components.armor:InitCondition(525, 0.6) --150*5*0.7= 525防具耐久
        inst.components.armor:AddWeakness("beaver", TUNING.BEAVER_WOOD_DAMAGE)

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

        MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
        MakeSmallPropagator(inst)

        inst.components.skinedlegion:SetOnPreLoad()
    end,
})

--------------------------------------------------------------------------
--[[ 恐怖盾牌的机械火焰 ]]
--------------------------------------------------------------------------

table.insert(prefs, Prefab("shieldterror_fire", function()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("coldfire_fire")
    inst.AnimState:SetBuild("coldfire_fire")
    inst.AnimState:PlayAnimation("level1", true)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetScale(0.6, 0.6, 0.6)
    -- inst.AnimState:SetFinalOffset(3)

    inst.Light:Enable(true)
    inst.Light:SetRadius(0.3)
    inst.Light:SetFalloff(0.3)
    inst.Light:SetIntensity(.3)
    if math.random() < 0.5 then
        inst.Light:SetColour(99/255, 226/255, 11/255)
        inst.AnimState:SetMultColour(99/255, 226/255, 11/255, 0.8)
    else
        inst.Light:SetColour(13/255, 226/255, 141/255)
        inst.AnimState:SetMultColour(13/255, 226/255, 141/255, 0.8)
    end

    inst:AddTag("FX")

    --HASHEATER (from heater component) added to pristine state for optimization
    inst:AddTag("HASHEATER")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst._belly = nil

    inst._taskfire = inst:DoPeriodicTask(2, function(inst)
        local number = 0
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 2,
            { "_combat", "_health" }, { "NOCLICK", "INLIMBO", "balloon", "structure", "wall", "player" })
        for _,v in ipairs(ents) do
            if
                v.entity:IsVisible() and (
                    v.components.combat ~= nil and v.components.combat.target ~= nil
                    and v.components.combat.target:HasTag("player")
                ) and v.components.health ~= nil and not v.components.health:IsDead()
            then
                v.components.health:DoDelta(-5, nil, "NIL", true, nil, true)
                number = number + 4
            end
        end

        if number > 0 and inst._belly ~= nil then
            if inst._belly:IsValid() then
                if inst._belly.components.armor ~= nil and inst._belly.components.armor:GetPercent() < 1 then
                    inst._belly.components.armor:Repair(number)
                end
            else
                inst._belly = nil
            end
        end

        if math.random() < 0.2 then
            inst._taskfire:Cancel()
            inst._taskfire = nil
            inst:Remove()
        end
    end, 0)

    return inst
end, {
    Asset("ANIM", "anim/coldfire_fire.zip")
}, nil))

--------------------------------------------------------------------------
--[[ 艾力冈的剑 ]]
--------------------------------------------------------------------------

local damage_shield = 85 --34*2.5
local damage_sword = 136 --34*4
local absorb_shield = 0.1
local absorb_sword = 0.3

local function DeathCallForRain(owner)
    TheWorld:PushEvent("ms_forceprecipitation", true)
end
local function OnAttack_agron(inst, owner, target)
    if
        owner.components.health ~= nil and owner.components.health:GetPercent() > 0.3
    then
        local fx = SpawnPrefab(inst._dd.fx or "agronssword_fx") --燃血特效
        fx.Transform:SetPosition(owner.Transform:GetWorldPosition())
        owner.components.health:DoDelta(-1.5, true, "agronssword")
    end
end
local function TrySetOwnerSymbol(inst, doer, revolt)
    if doer == nil then --因为此时有可能不再是装备状态，doer 发生了改变
        doer = inst.components.inventoryitem:GetGrandOwner()
    end
    if doer then
        if doer:HasTag("player") then
            if doer.components.health and doer.components.inventory then
                if inst == doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                    doer.AnimState:OverrideSymbol("lantern_overlay", inst._dd.build, revolt and "swap2" or "swap1")
                    inst.fn_onHealthDelta(doer, nil)
                end
            end
        elseif doer:HasTag("equipmentmodel") then
            doer.AnimState:OverrideSymbol("lantern_overlay", inst._dd.build, revolt and "swap2" or "swap1")
        end
    end
    if revolt then
        inst.components.inventoryitem.atlasname = inst._dd.img_atlas2
        inst.components.inventoryitem:ChangeImageName(inst._dd.img_tex2)
        inst.AnimState:PlayAnimation("idle2")
    else
        inst.components.inventoryitem.atlasname = inst._dd.img_atlas
        inst.components.inventoryitem:ChangeImageName(inst._dd.img_tex)
        inst.AnimState:PlayAnimation("idle")
    end
end
local function DoRevolt(inst, doer)
    if inst._task_fx == nil then
        inst._basedamage = damage_sword
        inst.components.weapon:SetDamage(damage_sword)
        inst.components.armor:SetAbsorption(absorb_sword)

        TrySetOwnerSymbol(inst, doer, true)

        inst._task_fx = inst:DoPeriodicTask(0.21, function(inst)
            local fx = SpawnPrefab(inst._dd.fx or "agronssword_fx")
            fx.Transform:SetPosition((inst.components.inventoryitem:GetGrandOwner() or inst).Transform:GetWorldPosition())
        end, 0)
    end
end
local function OnLoad_agron(inst, data)
    if inst.components.timer:TimerExists("revolt") then
        DoRevolt(inst, nil)
    end
end
local function TimerDone_agron(inst, data)
    if data.name == "revolt" then
        inst._basedamage = damage_shield
        inst.components.weapon:SetDamage(damage_shield)
        inst.components.armor:SetAbsorption(absorb_shield)

        TrySetOwnerSymbol(inst, nil, false)

        if inst._task_fx ~= nil then
            inst._task_fx:Cancel()
            inst._task_fx = nil
        end
    end
end

local function OnEquip_agron(inst, owner)
    owner.AnimState:OverrideSymbol("lantern_overlay", inst._dd.build,
        inst.components.timer:TimerExists("revolt") and "swap2" or "swap1")
    owner.AnimState:HideSymbol("swap_object")
    owner.AnimState:Show("ARM_carry") --显示持物手
    owner.AnimState:Hide("ARM_normal") --隐藏普通的手
    owner.AnimState:Show("LANTERN_OVERLAY")

    if owner:HasTag("equipmentmodel") then --假人！
        return
    end

    if owner.components.health ~= nil then
        owner:ListenForEvent("death", DeathCallForRain)
        owner:ListenForEvent("healthdelta", inst.fn_onHealthDelta)
        inst.fn_onHealthDelta(owner, nil)
    end
end
local function OnUnequip_agron(inst, owner)
    owner:RemoveEventCallback("death", DeathCallForRain)
    owner:RemoveEventCallback("healthdelta", inst.fn_onHealthDelta)
    inst.components.weapon:SetDamage(inst._basedamage) --卸下时，恢复攻击力，为了让巨人之脚识别到

    OnUnequipFn(inst, owner)
end
local function ShieldAtk_agron(inst, doer, attacker, data)
    --先加攻击力，这样输出高一点
    local timeleft = inst.components.timer:GetTimeLeft("revolt") or 0
    inst.components.timer:StopTimer("revolt")
    inst.components.timer:StartTimer("revolt", math.min(120, timeleft+10))
    DoRevolt(inst, doer)

    Counterattack_base(inst, doer, attacker, data, 8, 1.3)

    --后回血，这样输出高一点
    local percent = doer.components.health:GetPercent()
    if percent > 0 and percent <= 0.3 then
        percent = data.damage and data.damage*0.08 or 0.8
        doer.components.health:DoDelta(percent, true, "debug_key", true, nil, true) --对旺达的回血只有特定原因才能成功
    end
end
local function ShieldAtkStay_agron(inst, doer, attacker, data)
    inst.components.shieldlegion:Counterattack(doer, attacker, data, 8, 1)
end

MakeShield({
    name = "agronssword",
    assets = {
        Asset("ANIM", "anim/agronssword.zip"),
        Asset("ATLAS", "images/inventoryimages/agronssword.xml"),
        Asset("IMAGE", "images/inventoryimages/agronssword.tex"),
        Asset("ATLAS", "images/inventoryimages/agronssword2.xml"),
        Asset("IMAGE", "images/inventoryimages/agronssword2.tex")
    },
    prefabs = { "agronssword_fx" },
    fn_common = function(inst)
        inst.entity:AddMiniMapEntity()
        inst.MiniMapEntity:SetIcon("agronssword.tex")

        inst:AddTag("sharp") --武器的标签跟攻击方式跟攻击音效有关 没有特殊的话就用这两个
        inst:AddTag("pointy")
        inst:AddTag("irreplaceable") --防止被猴子、食人花、坎普斯等拿走，防止被流星破坏，并使其下线时会自动掉落
        inst:AddTag("nonpotatable") --这个貌似是？
        inst:AddTag("hide_percentage")  --这个标签能让护甲耐久比例不显示出来
        inst:AddTag("NORATCHECK") --mod兼容：永不妥协。该道具不算鼠潮分

        inst:AddComponent("skinedlegion")
        inst.components.skinedlegion:Init("agronssword")
    end,
    fn_server = function(inst)
        inst._dd = {
            img_tex = "agronssword", img_atlas = "images/inventoryimages/agronssword.xml",
            img_tex2 = "agronssword2", img_atlas2 = "images/inventoryimages/agronssword2.xml",
            build = "agronssword", fx = "agronssword_fx"
        }
        inst._task_fx = nil
        inst._basedamage = damage_shield
        inst.fn_onHealthDelta = function(owner, data)
            local percent = 1.0
            if data and data.newpercent then
                percent = data.newpercent
            else
                percent = owner.components.health:GetPercent()
            end
            inst.components.weapon:SetDamage(math.floor( inst._basedamage*(1.2-percent) ))
        end

        inst.components.inventoryitem:SetSinks(true) --落水时会下沉，但是因为标签的关系会回到附近岸边

        inst.components.weapon:SetDamage(damage_shield)
        inst.components.weapon:SetOnAttack(OnAttack_agron)

        inst.components.armor:InitCondition(100, absorb_shield)
        inst.components.armor.indestructible = true --无敌的护甲

        inst.components.equippable:SetOnEquip(OnEquip_agron)
        inst.components.equippable:SetOnUnequip(OnUnequip_agron)

        inst:AddComponent("timer")
        inst:ListenForEvent("timerdone", TimerDone_agron)

        inst.hurtsoundoverride = "dontstarve/wilson/hit_armour"
        inst.components.shieldlegion.armormult_success = 0
        inst.components.shieldlegion.atkfn = ShieldAtk_agron
        inst.components.shieldlegion.atkstayingfn = ShieldAtkStay_agron
        -- inst.components.shieldlegion.atkfailfn = function(inst, doer, attacker, data) end

        inst.OnLoad = OnLoad_agron

        inst.components.skinedlegion:SetOnPreLoad()
    end,
})

--------------------
--------------------

return unpack(prefs)
