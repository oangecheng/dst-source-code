--充能冷却
local function OnCharged(inst)
	inst.medal_charging = 0--清空充能
end

--清空充能
local function ClearCharging(inst)
    if inst.components.rechargeable ~= nil and not inst.components.rechargeable:IsCharged() then
        inst.components.rechargeable:SetPercent(1)
    end
end

--充能发生变更
local function DoCharging(inst,num)
    inst.medal_charging = math.clamp(inst.medal_charging + num, 0, 10)
    if inst.components.rechargeable ~= nil then
        inst.components.rechargeable:Discharge(10)
    end
end

local NO_TAGS_NO_PLAYERS =	{ "bramble_resistant", "INLIMBO", "notarget", "noattack", "flight", "invisible", "wall", "player", "companion" }
local COMBAT_TARGET_TAGS = { "_combat", "_health" }
local ATTACKRANGE = 3

--挨打
local function OnBlocked(owner, data)
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_scalemail")
    if data == nil or data.attacker == nil then return end
    local armor = owner and owner.components.inventory and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)--获取穿戴中的甲
    --充能大于0可对目标进行反伤/减速
    if armor and armor.medal_charging and armor.medal_charging > 0 then
        local has_origin = HasOriginMedal(owner,"has_bathfire_medal")--本源+浴火
        local damage = math.asin(armor.medal_charging*.1)*68*(has_origin and 1.5 or 1)--本源浴火反伤加成倍数
        local marknum = math.clamp(armor.medal_charging + armor.components.medal_immortal.level - TUNING_MEDAL.MEDAL_BUFF_BLUEMARK_MAX, 1, TUNING_MEDAL.MEDAL_BUFF_BLUEMARK_MAX)
        --不朽可触发范围反伤/减速
        if armor:HasTag("isimmortal") then
            local x, y, z = owner.Transform:GetWorldPosition()
            SpawnMedalFX(armor.isbluearmor and "splash_snow_fx" or "firesplash_fx",owner)
            for i, v in ipairs(TheSim:FindEntities(x, y, z, ATTACKRANGE, COMBAT_TARGET_TAGS, NO_TAGS_NO_PLAYERS)) do
                if v ~= owner and v:IsValid() and v.components.health ~= nil and not v.components.health:IsDead() and v.components.combat:CanBeAttacked()
                and (v == data.attacker or v.components.combat.target == owner) then
                    if armor.isbluearmor then
                        v:AddDebuff("buff_medal_bluemark","buff_medal_bluemark",{marknum = marknum, has_origin = has_origin})--添加蓝晶标记
                    else
                        v.components.combat:GetAttacked(armor, damage)--反伤
                    end
                end
            end
        elseif data.attacker:IsValid()
            and data.attacker.components.health ~= nil and not data.attacker.components.health:IsDead()
            and data.attacker.components.combat ~= nil and data.attacker.components.combat:CanBeAttacked() 
            and armor:IsNear(data.attacker, ATTACKRANGE) then
                if armor.isbluearmor then
                    data.attacker:AddDebuff("buff_medal_bluemark","buff_medal_bluemark",{marknum = marknum, has_origin = has_origin})--添加蓝晶标记
                else
                    SpawnMedalFX("willow_throw_flame",data.attacker)
                    data.attacker.components.combat:GetAttacked(armor, damage)--反伤
                end
        end
        ClearCharging(armor)--清空充能
    end
end

--攻击目标
local function OnHitother(owner, data)
    if data == nil or data.target == nil or not data.target:IsValid() then return end
    local armor = owner and owner.components.inventory and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)--获取穿戴中的甲
    if armor and armor.medal_charging then
        local chance = 0--攻击目标给目标添加红蓝晶标记的概率
        local basechance = armor.isbluearmor and .04 or .05--基础概率
        if armor:HasTag("isimmortal") then--不朽触发概率=充能层数*基础概率*.5*(不朽等级+1)
            chance = armor.medal_charging * basechance * .5 * (armor.components.medal_immortal.level + 1)
        else--初始触发概率=math.max(充能层数-5,0)*基础概率
            chance = math.max(armor.medal_charging - 5, 0) * basechance
        end
        if math.random() < chance then
            local consume = true--是否消耗充能
            local buffname = armor.isbluearmor and "buff_medal_bluemark" or "buff_medal_redmark"
            local has_origin = HasOriginMedal(owner,"has_bathfire_medal")--本源+浴火
            --不朽可触发范围标记
            if armor:HasTag("isimmortal") then
                local count = 0--统计命中目标数量
                local x, y, z = owner.Transform:GetWorldPosition()
                for i, v in ipairs(TheSim:FindEntities(x, y, z, ATTACKRANGE, COMBAT_TARGET_TAGS, NO_TAGS_NO_PLAYERS)) do
                    if v ~= owner and v:IsValid() and v.components.health ~= nil and not v.components.health:IsDead() and (v == data.target or v.components.combat.target == owner) then
                        --处于冰冻状态就不加蓝晶标记了
                        if (v.components.freezable==nil or not v.components.freezable:IsFrozen()) or not armor.isbluearmor then
                            v:AddDebuff(buffname, buffname, {has_origin = has_origin})--添加红蓝晶标记
                            count = count + 1
                        end
                    end
                end
                consume = count > 1--数量不超过1不消耗耐久
            elseif armor:IsNear(data.target, ATTACKRANGE) then
                data.target:AddDebuff(buffname, buffname, {has_origin = has_origin})
            end
            DoCharging(armor, consume and -1 or 1)
        else
            DoCharging(armor, 1)
        end
    end
end

--装备
local function onequip(inst, owner)
    owner.has_charging_armor = true--穿了可充能的甲
    owner.AnimState:OverrideSymbol("swap_body", inst.prefab, "swap_body")
	--防火
	if owner.components.health ~= nil then
        owner.components.health.externalfiredamagemultipliers:SetModifier(inst, 0)
    end
    ClearCharging(inst)--清空充能
	inst:ListenForEvent("blocked", OnBlocked, owner)--被打死
    inst:ListenForEvent("attacked", OnBlocked, owner)--监听被攻击事件
    inst:ListenForEvent("onhitother", OnHitother, owner)--监听攻击目标
end
--卸下
local function onunequip(inst, owner)
    owner.has_charging_armor = nil--卸下
    owner.AnimState:ClearOverrideSymbol("swap_body")
	if owner.components.health ~= nil then
        owner.components.health.externalfiredamagemultipliers:RemoveModifier(inst)
    end
    ClearCharging(inst)--清空充能
	inst:RemoveEventCallback("blocked", OnBlocked, owner)
    inst:RemoveEventCallback("attacked", OnBlocked, owner)
    inst:RemoveEventCallback("onhitother", OnHitother, owner)
end
--添加可装备组件相关内容
local function SetupEquippable(inst)
	inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
	inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
end
--修补耐久
local function OnRepaired(inst)
	if inst.components.equippable == nil then
		SetupEquippable(inst)
	end
end

--耐久用完
local function onfinished(inst)
	inst:DoTaskInTime(0,function(inst)
		if inst:HasTag("isimmortal") then
            if inst.components.equippable ~= nil then
                if inst.components.equippable:IsEquipped() then
                    local owner = inst.components.inventoryitem.owner
                    if owner ~= nil and owner.components.inventory ~= nil then
                        local item = owner.components.inventory:Unequip(inst.components.equippable.equipslot)
                        if item ~= nil then
                            owner.components.inventory:GiveItem(item, nil, owner:GetPosition())
                        end
                    end
                end
                inst:RemoveComponent("equippable")
            end
        else
			inst:Remove()
		end
	end)
end

--添加不朽之力
local function onimmortal(inst,level,isadd)
    if inst.components.armor ~= nil then
        inst.components.armor.maxcondition = TUNING_MEDAL.ARMOR_MEDAL_OBSIDIAN_AMOUNT + TUNING_MEDAL.MEDAL_BASE_ARMOR * level * 2
        inst.components.armor:SetAbsorption(TUNING_MEDAL.ARMOR_MEDAL_OBSIDIAN_ABSORPTION + 0.02 * level)
        if isadd then
			inst.components.armor:SetPercent(1)--升级则直接加满耐久
            OnRepaired(inst)
		end
    end
    if inst.components.medal_chaosdefense ~= nil then
	    inst.components.medal_chaosdefense:SetBaseDefense(TUNING_MEDAL.ARMOR_MEDAL_OBSIDIAN_CHAOS_DEF*level)
    end
end

--存储函数
local function onsave(inst,data)
    --保存护甲耐久
    if inst.components.armor then
        data.armor_percent = inst.components.armor:GetPercent()
    end
end
--加载函数
local function onload(inst,data)
    --重设护甲耐久,防止加载导致的耐久出错
    if data and data.armor_percent and inst.components.armor then
        inst.components.armor:SetPercent(data.armor_percent)
    end
end

local function MakeArmor(def)
    local assets =
    {
        Asset("ANIM", "anim/"..def.name..".zip"),
        Asset("ATLAS", "images/"..def.name..".xml"),
        Asset("ATLAS_BUILD", "images/"..def.name..".xml",256),
    }
    
    local function create_common()
        local inst = CreateEntity()
    
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
    
        MakeInventoryPhysics(inst)
    
        inst.AnimState:SetBank(def.name)
        inst.AnimState:SetBuild(def.name)
        inst.AnimState:PlayAnimation("anim")
    
        inst.foleysound = "dontstarve/movement/foley/trunksuit"
    
        inst.medal_repair_immortal = {--修补列表
            immortal_essence = TUNING_MEDAL.ARMOR_MEDAL_OBSIDIAN_ADDUSE,--不朽精华
            immortal_fruit = function(inst)--不朽果实
                if inst.components.medal_immortal ~= nil then
                    local level = inst.components.medal_immortal.level or 1
                    return TUNING_MEDAL.ARMOR_MEDAL_OBSIDIAN_ADDUSE + TUNING_MEDAL.MEDAL_BASE_ARMOR * .5 * (level + 1)--补充量随不朽等级提升而提升
                end
                return TUNING_MEDAL.ARMOR_MEDAL_OBSIDIAN_ADDUSE
            end,
        }

        if def.clientfn then
            def.clientfn(inst)
        end
    
        MakeInventoryFloatable(inst, "small", 0.1, 0.8)
    
        inst.entity:SetPristine()
    
        if not TheWorld.ismastersim then
            return inst
        end

        inst.isbluearmor = def.name == "armor_blue_crystal"--是蓝晶甲
    
        inst.medal_charging = 0--充能
    
        inst:AddComponent("inspectable")
    
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = def.name
        inst.components.inventoryitem.atlasname = "images/"..def.name..".xml"
    
        inst:AddComponent("armor")
        inst.components.armor:InitCondition(TUNING_MEDAL.ARMOR_MEDAL_OBSIDIAN_AMOUNT, TUNING_MEDAL.ARMOR_MEDAL_OBSIDIAN_ABSORPTION)--护甲值
        inst.components.armor:SetKeepOnFinished(true)
        inst.components.armor:SetOnFinished(onfinished)
    
        inst:AddComponent("rechargeable")
        inst.components.rechargeable:SetOnChargedFn(OnCharged)--CD结束
    
        inst:AddComponent("medal_chaosdefense")--混沌防御
    
        SetupEquippable(inst)
        inst.medal_onrepairfn = OnRepaired
    
        inst:AddComponent("medal_immortal")--不朽组件
        inst.components.medal_immortal:SetMaxLevel(5)
        inst.components.medal_immortal:SetOnImmortal(onimmortal)

        inst.OnSave = onsave
		inst.OnLoad = onload
    
        MakeHauntableLaunch(inst)
    
        return inst
    end

    return Prefab(def.name, create_common, assets)
end

local armor_loot = {
    {--红晶甲
        name = "armor_medal_obsidian",
        clientfn = function(inst)
            inst.medal_repair_common = {--修补列表
                medal_obsidian = TUNING_MEDAL.ARMOR_MEDAL_OBSIDIAN_ADDUSE,--红晶
            }
        end,
    },
    {--蓝晶甲
        name = "armor_blue_crystal",
        clientfn = function(inst)
            inst.medal_repair_common = {--修补列表
                medal_blue_obsidian = TUNING_MEDAL.ARMOR_MEDAL_OBSIDIAN_ADDUSE,--蓝晶
            }
        end,
    },
}

local armors = {}
for i, v in ipairs(armor_loot) do
    table.insert(armors, MakeArmor(v))
end
return unpack(armors)

-- return Prefab("armor_medal_obsidian", create_common, assets)
