--------------------------------------------------------------------------
--[[ 基础材料 ]]
--------------------------------------------------------------------------

local assets_wing = {
    Asset("ANIM", "anim/insectthings_l.zip"),
    Asset("ATLAS", "images/inventoryimages/ahandfulofwings.xml"),
    Asset("IMAGE", "images/inventoryimages/ahandfulofwings.tex")
}
local assets_shell = {
    Asset("ANIM", "anim/insectthings_l.zip"),
    Asset("ATLAS", "images/inventoryimages/insectshell_l.xml"),
    Asset("IMAGE", "images/inventoryimages/insectshell_l.tex")
}

local function FnServer(inst)
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("tradable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunchAndIgnite(inst)
end
local function Fn_wing()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("insectthings_l")
    inst.AnimState:SetBuild("insectthings_l")
    inst.AnimState:PlayAnimation("wing", false)

    MakeInventoryFloatable(inst, "small", 0.1, 1.2)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    FnServer(inst)

    inst.components.inventoryitem.imagename = "ahandfulofwings"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/ahandfulofwings.xml"

    return inst
end
local function Fn_shell()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("insectthings_l")
    inst.AnimState:SetBuild("insectthings_l")
    inst.AnimState:PlayAnimation("shell", false)

    MakeInventoryFloatable(inst, "small", 0.1, 1.1)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    FnServer(inst)

    inst.components.inventoryitem.imagename = "insectshell_l"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/insectshell_l.xml"

    inst:AddComponent("repairerlegion")

    return inst
end

--------------------------------------------------------------------------
--[[ 脱壳之翅 ]]
--------------------------------------------------------------------------

local assets_boltout = {
    Asset("ANIM", "anim/swap_boltwingout.zip"),
    Asset("ATLAS", "images/inventoryimages/boltwingout.xml"),
    Asset("IMAGE", "images/inventoryimages/boltwingout.tex"),
    Asset("ANIM", "anim/ui_piggyback_2x6.zip")
}
local prefabs_boltout = {
    "boltwingout_fx",
    "boltwingout_shuck"
}
local BOLTCOST = {
    stinger = 3,            --蜂刺
    honey = 5,              --蜂蜜
    royal_jelly = 0.1,      --蜂王浆
    honeycomb = 0.25,       --蜂巢
    beeswax = 0.2,          --蜂蜡
    bee = 0.5,              --蜜蜂
    killerbee = 0.45,       --杀人蜂

    mosquitosack = 1,       --蚊子血袋
    mosquito = 0.45,        --蚊子

    glommerwings = 0.25,    --格罗姆翅膀
    glommerfuel = 0.5,      --格罗姆黏液

    butterflywings = 3,     --蝴蝶翅膀
    butter = 0.1,           --黄油
    butterfly = 0.6,        --蝴蝶

    wormlight = 0.25,       --神秘浆果
    wormlight_lesser = 1,   --神秘小浆果

    moonbutterflywings = 1, --月蛾翅膀
    moonbutterfly = 0.3,    --月蛾

    ahandfulofwings = 0.25, --虫翅碎片
    insectshell_l = 0.25,   --虫甲碎片
    raindonate = 0.45,      --雨蝇
    fireflies = 0.45,       --萤火虫

    dragon_scales = 0.1,    --龙鳞
    lavae_egg = 0.06,       --岩浆虫卵
    lavae_egg_cracked = 0.06,--岩浆虫卵(孵化中)
    lavae_cocoon = 0.03,    --冷冻虫卵
}

local function OnEquip_boltout(inst, owner)
    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.equip ~= nil then
        owner.AnimState:OverrideSymbol(skindata.equip.symbol, skindata.equip.build, skindata.equip.file)
        owner.bolt_skin_l = skindata.boltdata
    else
        owner.AnimState:OverrideSymbol("swap_body", "swap_boltwingout", "swap_body")
        owner.bolt_skin_l = nil
    end

    if owner:HasTag("equipmentmodel") then --假人！
        return
    end

    if inst.components.container ~= nil then
        inst.components.container:Open(owner)
    end

    if owner.components.combat ~= nil and owner.set_l_bolt == nil then
        owner.GetAttacked_l_bolt = owner.components.combat.GetAttacked
        owner.components.combat.GetAttacked = function(self, attacker, damage, weapon, stimuli)
            if
                not self.inst.set_l_bolt
                or (self.inst.components.health == nil or self.inst.components.health:IsDead())
            then
                return self.inst.GetAttacked_l_bolt(self, attacker, damage, weapon, stimuli)
            end

            local backpack = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BACK or EQUIPSLOTS.BODY) or nil
            if backpack == nil or backpack.components.container == nil then
                return self.inst.GetAttacked_l_bolt(self, attacker, damage, weapon, stimuli)
            end

            local attackerinfact = weapon or attacker --武器写在前面是为了优先躲避远程武器
            if
                (self.inst.components.rider ~= nil and self.inst.components.rider:IsRiding()) --在骑牛
                or self.inst.sg:HasStateTag("busy") --在做特殊动作，攻击sg不会带这个标签
                or stimuli == "darkness" --黑暗攻击
                or attackerinfact == nil --无实物的攻击
                or damage <= 0
            then
                return self.inst.GetAttacked_l_bolt(self, attacker, damage, weapon, stimuli)
            end

            --识别特定数量的材料来触发金蝉脱壳效果
            local finalitem = backpack.components.container:FindItem(function(item)
                local value = item.bolt_l_value or BOLTCOST[item.prefab]
                if
                    value ~= nil and
                    value <= (item.components.stackable ~= nil and item.components.stackable:StackSize() or 1)
                then
                    return true
                end
                return false
            end)

            if finalitem ~= nil then
                local value = finalitem.bolt_l_value or BOLTCOST[finalitem.prefab]
                if value ~= nil then --删除对应数量的材料
                    if value >= 1 then
                        if finalitem.components.stackable ~= nil then
                            finalitem.components.stackable:Get(value):Remove()
                        else
                            finalitem:Remove()
                        end
                    elseif math.random() < value then
                        if finalitem.components.stackable ~= nil then
                            finalitem.components.stackable:Get():Remove()
                        else
                            finalitem:Remove()
                        end
                    end
                end

                --金蝉脱壳
                self.inst:PushEvent("boltout", { escapepos = attackerinfact:GetPosition() })
                --若是远程攻击的敌人，“壳”可能因为距离太远吸引不到敌人，所以这里主动先让敌人丢失仇恨
                if attacker ~= nil and attacker.components.combat ~= nil then
                    attacker.components.combat:SetTarget(nil)
                end
                return false
            else
                return self.inst.GetAttacked_l_bolt(self, attacker, damage, weapon, stimuli)
            end
        end
    end
    owner.set_l_bolt = true
end
local function OnUnequip_boltout(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.bolt_skin_l = nil

    if inst.components.container ~= nil then
        inst.components.container:Close(owner)
    end

    owner.set_l_bolt = false
end

local function OnBurnt_boltout(inst)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end
    SpawnPrefab("ash").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end
local function OnIgnite_boltout(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = false
    end
end
local function OnExtinguish_boltout(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = true
    end
end

local function Fn_boltout()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("swap_boltwingout")
    inst.AnimState:SetBuild("swap_boltwingout")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("backpack")

    inst.foleysound = "legion/foleysound/insect"

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("boltwingout")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("boltwingout") end
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "boltwingout"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/boltwingout.xml"
    inst.components.inventoryitem.cangoincontainer = false

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(OnEquip_boltout)
    inst.components.equippable:SetOnUnequip(OnUnequip_boltout)
    inst.components.equippable.walkspeedmult = 1.1

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("boltwingout")

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    inst.components.burnable:SetOnBurntFn(OnBurnt_boltout)
    inst.components.burnable:SetOnIgniteFn(OnIgnite_boltout)
    inst.components.burnable:SetOnExtinguishFn(OnExtinguish_boltout)

    MakeHauntableLaunchAndDropFirstItem(inst)

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

--------------------------------------------------------------------------
--[[ 羽化后的壳 ]]
--------------------------------------------------------------------------

local assets_shuck = {
  Asset("ANIM", "anim/spider_cocoon.zip"), --官方蜘蛛巢动画
  Asset("ANIM", "anim/boltwingout_shuck.zip")
}

local function AttractEnemies_shuck(inst)
    local pos = inst:GetPosition()
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 8, { "_combat" }, { "NOCLICK", "INLIMBO" })
    for k, v in pairs(ents) do
        if v ~= inst and v.components.combat ~= nil and v.components.combat:CanTarget(inst) then
            v.components.combat:SetTarget(inst)
        end
    end
end
local function OnInit_shuck(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_grow")

    inst.AnimState:PlayAnimation("grow_sac_to_small")
    inst.AnimState:PushAnimation("cocoon_small", true)

    AttractEnemies_shuck(inst)
end

local function OnFreeze_shuck(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/freezecreature")
    inst.AnimState:PlayAnimation("frozen_small", true)
    inst.AnimState:OverrideSymbol("swap_frozen", "frozen", "frozen")
end
local function OnThaw_shuck(inst) --快要解冻时的抖动
    inst.AnimState:PlayAnimation("frozen_loop_pst_small", true)
    inst.SoundEmitter:PlaySound("dontstarve/common/freezethaw", "thawing")
    inst.AnimState:OverrideSymbol("swap_frozen", "frozen", "frozen")
end
local function OnUnFreeze_shuck(inst)
    inst.AnimState:PlayAnimation("cocoon_small", true)
    inst.SoundEmitter:KillSound("thawing")
    inst.AnimState:ClearOverrideSymbol("swap_frozen")
end

local function OnHit_shuck(inst, attacker)
    if not inst.components.health:IsDead() then
        inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_hit")
        inst.AnimState:PlayAnimation("cocoon_small_hit")
        inst.AnimState:PushAnimation("cocoon_small", true)
    end
end
local function OnKilled_shuck(inst)
    inst.AnimState:PlayAnimation("cocoon_dead")

    inst.SoundEmitter:KillSound("loop")
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_destroy")

    if inst.task_remove ~= nil then
        inst.task_remove:Cancel()
        inst.task_remove = nil
    end
end

local function OnEntityWake_shuck(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spidernest_LP", "loop")
end
local function OnEntitySleep_shuck(inst)
    inst.SoundEmitter:KillSound("loop")
    if inst.task_remove ~= nil then
        inst.task_remove:Cancel()
        inst.task_remove = nil
    end

    inst:Remove()
end

local function OnHaunt_shuck(inst)
    if math.random() <= TUNING.HAUNT_CHANCE_ALWAYS then
        OnHit_shuck(inst)
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_COOLDOWN_MEDIUM

        if inst.task_remove ~= nil then
            AttractEnemies_shuck(inst) --再次吸引敌人，应该有特殊的作用吧
        end
        return true
    end
    return false
end

local function Fn_shuck()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    -- MakeObstaclePhysics(inst, .5) --为了防止用来卡海，设置为无物理体积

    inst.AnimState:SetBank("spider_cocoon")
    inst.AnimState:SetBuild("boltwingout_shuck")
    inst.AnimState:PlayAnimation("cocoon_small", true)

    inst:AddTag("chewable") -- by werebeaver
    inst:AddTag("companion") --加companion和character标签是为了让大多数怪物能主动攻击自己，并且玩家攻击时不会主动以自己为目标
    -- inst:AddTag("character") --暗影触手会识别这个标签。而暗影触手的 retargetfn 里不对sg提前做判断，导致崩溃
    inst:AddTag("notraptrigger") --不会触发狗牙陷阱
    inst:AddTag("soulless") --为了不产生灵魂

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(20)

    MakeMediumBurnable(inst)
    MakeMediumPropagator(inst)

    MakeMediumFreezableCharacter(inst)
    inst:ListenForEvent("freeze", OnFreeze_shuck)
    inst:ListenForEvent("onthaw", OnThaw_shuck)
    inst:ListenForEvent("unfreeze", OnUnFreeze_shuck)

    inst:AddComponent("combat")
    inst.components.combat:SetOnHit(OnHit_shuck)
    inst:ListenForEvent("death", OnKilled_shuck)

    inst:AddComponent("inspectable")

    inst:AddComponent("hauntable")
    inst.components.hauntable.cooldown = TUNING.HAUNT_COOLDOWN_MEDIUM
    inst.components.hauntable:SetOnHauntFn(OnHaunt_shuck)

    MakeSnowCovered(inst)

    inst:DoTaskInTime(0, OnInit_shuck)
    inst.task_remove = inst:DoTaskInTime(15+math.random()*3, function(inst)
        inst.task_remove = nil
        inst.components.health:Kill() --该函数自带当前生命的判断
    end)

    inst.persists = false

    inst.OnEntitySleep = OnEntitySleep_shuck
    inst.OnEntityWake = OnEntityWake_shuck

    return inst
end

--------------------------------------------------------------------------
--[[ 犀金胄甲 ]]
--------------------------------------------------------------------------

local assets_beetlehat = {
    Asset("ANIM", "anim/hat_elepheetle.zip"),
    Asset("ATLAS", "images/inventoryimages/hat_elepheetle.xml"),
    Asset("IMAGE", "images/inventoryimages/hat_elepheetle.tex")
}

local function OnEquip_beetlehat(inst, owner)
    -- local skindata = inst.components.skinedlegion:GetSkinedData()
    -- if skindata ~= nil and skindata.equip ~= nil then
    --     HAT_L_ON(inst, owner, skindata.equip.build, skindata.equip.file)
    -- else
        HAT_L_ON(inst, owner, "hat_elepheetle", "swap_hat")
    -- end

    if owner:HasTag("equipmentmodel") then --假人！
        return
    end

    --工作效率
    if owner.components.workmultiplier == nil then
        owner:AddComponent("workmultiplier")
    end
    owner.components.workmultiplier:AddMultiplier(ACTIONS.CHOP,   1.5, inst)
    owner.components.workmultiplier:AddMultiplier(ACTIONS.MINE,   1.5, inst)
    owner.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER, 1.5, inst)
    --攻击力
    if owner.components.combat ~= nil then
        owner.components.combat.externaldamagemultipliers:SetModifier(inst, 1.1)
    end
    --健身值
    if owner.components.mightiness ~= nil then
        owner.components.mightiness.ratemodifiers:SetModifier(inst, 0.3)
    end

    AddTag_legion(owner, "burden_ignor_l", inst.prefab) --免疫装备减速 棱镜tag
end
local function OnUnequip_beetlehat(inst, owner)
    HAT_L_OFF(inst, owner)

    if owner:HasTag("equipmentmodel") then --假人！
        return
    end

    if owner.components.workmultiplier ~= nil then
        owner.components.workmultiplier:RemoveMultiplier(ACTIONS.CHOP,   inst)
        owner.components.workmultiplier:RemoveMultiplier(ACTIONS.MINE,   inst)
        owner.components.workmultiplier:RemoveMultiplier(ACTIONS.HAMMER, inst)
    end
    if owner.components.combat ~= nil then
        owner.components.combat.externaldamagemultipliers:RemoveModifier(inst)
    end
    if owner.components.mightiness ~= nil then
        owner.components.mightiness.ratemodifiers:RemoveModifier(inst)
    end
    RemoveTag_legion(owner, "burden_ignor_l", inst.prefab)
end

local function Fn_beetlehat()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hat_elepheetle")
    inst.AnimState:SetBuild("hat_elepheetle")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("hat")
    inst:AddTag("waterproofer")
    inst:AddTag("burden_l")
    inst:AddTag("rp_bugshell_l")

    -- inst:AddComponent("skinedlegion")
    -- inst.components.skinedlegion:InitWithFloater("hat_elepheetle")

    MakeInventoryFloatable(inst, "small", 0.2, 1.35)
    -- local OnLandedClient_old = inst.components.floater.OnLandedClient
    -- inst.components.floater.OnLandedClient = function(self)
    --     OnLandedClient_old(self)
    --     self.inst.AnimState:SetFloatParams(0.15, 1, self.bob_percent)
    -- end

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("tradable")
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "hat_elepheetle"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hat_elepheetle.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(OnEquip_beetlehat)
    inst.components.equippable:SetOnUnequip(OnUnequip_beetlehat)
    inst.components.equippable.walkspeedmult = 0.85

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(945, 0.8)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

    MakeHauntableLaunch(inst)

    -- inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

--------------------------------------------------------------------------
--[[ 犀金护甲 ]]
--------------------------------------------------------------------------

local assets_beetlearmor = {
    Asset("ANIM", "anim/armor_elepheetle.zip"),
    Asset("ATLAS", "images/inventoryimages/armor_elepheetle.xml"),
    Asset("IMAGE", "images/inventoryimages/armor_elepheetle.tex")
}

local function OnEquip_beetlearmor(inst, owner)
    -- local skindata = inst.components.skinedlegion:GetSkinedData()
    -- if skindata ~= nil and skindata.equip ~= nil then
    --     owner.AnimState:OverrideSymbol("swap_body", skindata.equip.build, skindata.equip.file)
    -- else
        owner.AnimState:OverrideSymbol("swap_body", "armor_elepheetle", "swap_body")
    -- end

    if owner:HasTag("equipmentmodel") then --假人！
        return
    end

    AddTag_legion(owner, "stable_l", inst.prefab) --无硬直 棱镜tag
    AddTag_legion(owner, "sedate_l", inst.prefab) --免疫麻痹 棱镜tag
end
local function OnUnequip_beetlearmor(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")

    if owner:HasTag("equipmentmodel") then --假人！
        return
    end

    RemoveTag_legion(owner, "stable_l", inst.prefab)
    RemoveTag_legion(owner, "sedate_l", inst.prefab)
end

local function Fn_beetlearmor()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("armor_elepheetle")
    inst.AnimState:SetBuild("armor_elepheetle")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("heavyarmor") --减轻击退效果 官方tag
    inst:AddTag("rp_bugshell_l")

    -- inst:AddComponent("skinedlegion")
    -- inst.components.skinedlegion:InitWithFloater("armor_elepheetle")

    MakeInventoryFloatable(inst, "small", 0.4, 0.95)
    local OnLandedClient_old = inst.components.floater.OnLandedClient
    inst.components.floater.OnLandedClient = function(self)
        OnLandedClient_old(self)
        self.inst.AnimState:SetFloatParams(0.15, 1, self.bob_percent)
    end

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("tradable")
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "armor_elepheetle"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/armor_elepheetle.xml"

    inst:AddComponent("equippable")
    -- inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(OnEquip_beetlearmor)
    inst.components.equippable:SetOnUnequip(OnUnequip_beetlearmor)
    inst.components.equippable.insulated = true --防电
    inst.components.equippable.walkspeedmult = 0.15

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(1050, 0.9)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

    MakeHauntableLaunch(inst)

    -- inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

----------

return Prefab("ahandfulofwings", Fn_wing, assets_wing),
    Prefab("insectshell_l", Fn_shell, assets_shell),
    Prefab("boltwingout", Fn_boltout, assets_boltout, prefabs_boltout),
    Prefab("boltwingout_shuck", Fn_shuck, assets_shuck),
    Prefab("hat_elepheetle", Fn_beetlehat, assets_beetlehat),
    Prefab("armor_elepheetle", Fn_beetlearmor, assets_beetlearmor)
