-- name--buff名
-- onattachedfn--添加buff函数
-- onextendedfn--延长buff函数
-- ondetachedfn--解除buff函数
-- duration--buff持续时间
-- priority--buff对话优先级(说优先级高的感叹词),不填则不提示
-- prefabs--prefabs列表


--Buff列表
local buff_defs={}

-------------------------------------蓄电buff-------------------------------------------------
buff_defs.buff_medal_electricattack={
	name="buff_medal_electricattack",
	duration=TUNING_MEDAL.MEDAL_BUFF_ELECTRICATTACK_DURATION,
	priority=2,
	prefabs={ "electrichitsparks", "electricchargedfx" },
	onattachedfn=function(inst, target)
		if target.components.electricattacks == nil then
			target:AddComponent("electricattacks")
		end
		target.components.electricattacks:AddSource(inst)
		if inst._onattackother == nil then
			inst._onattackother = function(attacker, data)
				if data.weapon ~= nil then
					if data.projectile == nil then
						--投掷类武器不加特效
						if data.weapon.components.projectile ~= nil then
							return
						elseif data.weapon.components.complexprojectile ~= nil then
							return
						elseif data.weapon.components.weapon:CanRangedAttack() then
							return
						end
					end
					if data.weapon.components.weapon ~= nil and data.weapon.components.weapon.stimuli == "electric" then
						--武器自身已经有电特效了，也不需要加特效
						return
					end
				end
				if data.target ~= nil and data.target:IsValid() and attacker:IsValid() then
					SpawnPrefab("electrichitsparks"):AlignToTarget(data.target, data.projectile ~= nil and data.projectile:IsValid() and data.projectile or attacker, true)
				end
			end
			inst:ListenForEvent("onattackother", inst._onattackother, target)
		end
		SpawnPrefab("electricchargedfx"):SetTarget(target)
		if target.components.locomotor ~= nil then
			target.components.locomotor:SetExternalSpeedMultiplier(inst, "medal_goathat", TUNING_MEDAL.GOATHAT_SPEED_MULTIPLE)
		end
	end,
	onextendedfn=function(inst, target)
		SpawnPrefab("electricchargedfx"):SetTarget(target)
	end,
	ondetachedfn=function(inst, target)
		if target.components.electricattacks ~= nil then
			target.components.electricattacks:RemoveSource(inst)
		end
		--移除时判断玩家有木有戴羊角帽，没有并且非月圆则电击
		if target.components.playerlightningtarget and not target:HasTag("lightninggoat_friend") then
			if target.components.playercontroller~=nil and target.components.playercontroller.classified~=nil and not TheWorld.state.isfullmoon then
				target.components.playerlightningtarget:DoStrike()
			end
		end
		target:PushEvent("stop_buff_medal_electricattack")
		if inst._onattackother ~= nil then
			inst:RemoveEventCallback("onattackother", inst._onattackother, target)
			inst._onattackother = nil
		end
		if target.components.locomotor ~= nil then
			target.components.locomotor:RemoveExternalSpeedMultiplier(inst, "medal_goathat")
		end
	end,
}

-------------------------------------加速buff-------------------------------------------------
buff_defs.buff_medal_quicklocomotor={
	name="buff_medal_quicklocomotor",
	duration=TUNING_MEDAL.MEDAL_BUFF_QUICKLOCOMOTOR_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		if target.components.locomotor ~= nil then
			target.components.locomotor:SetExternalSpeedMultiplier(inst, "spice_cactus_flower", TUNING_MEDAL.QUICKLOCOMOTOR_MULTIPLE)
		end
	end,
	ondetachedfn=function(inst, target)
		if target.components.locomotor ~= nil then
			target.components.locomotor:RemoveExternalSpeedMultiplier(inst, "spice_cactus_flower")
		end
	end,
}

-------------------------------------san值保护buff-------------------------------------------------
buff_defs.buff_medal_sanityregen={
	name="buff_medal_sanityregen",
	duration=TUNING_MEDAL.MEDAL_BUFF_SANITYREGEN_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		if target and target.components.sanity then
			target.components.sanity.yueshubuff=true--san值保护标记
		end
	end,
	ondetachedfn=function(inst, target)
		if target and target.components.sanity and target.components.sanity.yueshubuff then
			target.components.sanity.yueshubuff=nil
		end
	end,
}
	
-------------------------------------黑暗血糖buff-------------------------------------------------
buff_defs.buff_medal_suckingblood={
	name="buff_medal_suckingblood",
	duration=TUNING_MEDAL.MEDAL_BUFF_SUCKINGBLOOD_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		target.medal_dark_ningxue = true--黑暗凝血buff标记
	end,
	ondetachedfn=function(inst, target)
		target.medal_dark_ningxue = nil--移除黑暗凝血buff标记
	end,
}

-------------------------------------血糖buff-------------------------------------------------
buff_defs.buff_medal_bloodsucking={
	name="buff_medal_bloodsucking",
	duration=TUNING_MEDAL.MEDAL_BUFF_BLOODSUCKING_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		target.medal_ningxue = true--凝血标记
	end,
	ondetachedfn=function(inst, target)
		target.medal_ningxue = nil--去除凝血标记
	end,
}

-------------------------------------灵魂跳跃buff-------------------------------------------------
buff_defs.buff_medal_freeblink={
	name="buff_medal_freeblink",
	duration=TUNING_MEDAL.MEDAL_BUFF_FREEBLINK_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		if not target:HasTag("freeblinker") then
			target:AddTag("freeblinker")
		end
		--伍迪变身回来玩家跳跃函数会被挪掉，需要重设
		if target.prefab=="woodie" and target.medalblinkable then
			if target.medalblinkable:value() then
				target.medalblinkable:set_local(false)
				target.medalblinkable:set(true)
			else
				target.medalblinkable:set(true)
			end
		end
	end,
	ondetachedfn=function(inst, target)
		if target:HasTag("freeblinker") then
			target:RemoveTag("freeblinker")
		end
	end,
}

-------------------------------------移植buff-------------------------------------------------
buff_defs.buff_medal_transplantable={
	name="buff_medal_transplantable",
	duration=TUNING_MEDAL.MEDAL_BUFF_TRANSPLANTABLE_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		if not target:HasTag("inmoonlight") then
			target:AddTag("inmoonlight")
			target:PushEvent("change_medal_moonlinght")
		end
	end,
	ondetachedfn=function(inst, target)
		if target:HasTag("inmoonlight") then
			target:RemoveTag("inmoonlight")
			target:PushEvent("change_medal_moonlinght")
		end
	end,
}
	
-------------------------------------饱腹buff-------------------------------------------------
buff_defs.buff_medal_assuagehunger={
	name="buff_medal_assuagehunger",
	duration=TUNING_MEDAL.MEDAL_BUFF_ASSUAGEHUNGER_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		if target.components.hunger ~= nil then
		    target.components.hunger.burnratemodifiers:SetModifier(inst, TUNING_MEDAL.ASSUAGEHUNGER_MULTIPLE,"assuagehunger_buff")
		end
	end,
	ondetachedfn=function(inst, target)
		if target.components.hunger ~= nil then
		    target.components.hunger.burnratemodifiers:RemoveModifier(inst,"assuagehunger_buff")
		end
	end,
}

-------------------------------------吃屎buff-------------------------------------------------
buff_defs.buff_medal_poopfood={
	name="buff_medal_poopfood",
	duration=TUNING_MEDAL.MEDAL_BUFF_POOPFOOD_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		if target.components.eater ~= nil then
		    target.components.eater:SetAbsorptionModifiers(1, 1, 1)
		end
	end,
	ondetachedfn=function(inst, target)
		if target.components.eater ~= nil then
		    target.components.eater:SetAbsorptionModifiers(0, 1, 1)
		end
	end,
}
	
-------------------------------------开胃buff-------------------------------------------------
buff_defs.buff_medal_upappetite={
	name="buff_medal_upappetite",
	duration=TUNING_MEDAL.MEDAL_BUFF_UPAPPETITE_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		--铁胃,吃东西不受新鲜度影响
		if target.components.eater ~= nil then
			if not target.components.eater.ignoresspoilage then
				target.components.eater.ignoresspoilage = true
				target.isupappetite=true
			end
			--啥都吃！
			if target.components.eater.caneat then
				target.medal_caneat_loot = {}--把原本的饮食习惯记录下来
				for i, v in ipairs(target.components.eater.caneat) do
					table.insert(target.medal_caneat_loot,v.name or v)
				end
			end
			if target.components.eater.preferseating then
				target.medal_preferseating_loot = {}
				for i, v in ipairs(target.components.eater.preferseating) do
					table.insert(target.medal_preferseating_loot,v.name or v)
				end
			end
			target.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI })
		end
	end,
	ondetachedfn=function(inst, target)
		--移除铁胃标签
		if target.components.eater then
			if target.isupappetite then
				target.isupappetite=nil
				if target.components.eater.ignoresspoilage then
					target.components.eater.ignoresspoilage = false
				end
			end
			--恢复原状！
			local caneat = {}
			local preferseating = {}
			if target.medal_caneat_loot and #target.medal_caneat_loot > 0 then
				for k, v in ipairs(target.medal_caneat_loot) do
					table.insert(caneat,FOODTYPE[v] or FOODGROUP[v])
				end
			else
				caneat = { FOODGROUP.OMNI }
			end
			if target.medal_preferseating_loot and #target.medal_preferseating_loot > 0 then
				for k, v in ipairs(target.medal_preferseating_loot) do
					table.insert(preferseating,FOODTYPE[v] or FOODGROUP[v])
				end
			else
				preferseating = { FOODGROUP.OMNI }
			end
			target.components.eater:SetDiet(caneat, preferseating)
		end
	end,
}
	
-------------------------------------霸体buff(免疫僵直)-------------------------------------------------
buff_defs.buff_medal_nostiff={
	name="buff_medal_nostiff",
	duration=TUNING_MEDAL.MEDAL_BUFF_NOSTIFF_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		if not target:HasTag("nostiff") then
			target:AddTag("nostiff")
		end
	end,
	ondetachedfn=function(inst, target)
		if target:HasTag("nostiff") then
			target:RemoveTag("nostiff")
		end
	end,
}

-------------------------------------强壮buff(搬重物不减速)-------------------------------------------------
buff_defs.buff_medal_strong={
	name="buff_medal_strong",
	duration=TUNING_MEDAL.MEDAL_BUFF_STRONG_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		if not target:HasTag("medal_strong") then
			target:AddTag("medal_strong")
		end
	end,
	ondetachedfn=function(inst, target)
		if target:HasTag("medal_strong") then
			target:RemoveTag("medal_strong")
		end
	end,
}

-------------------------------------群伤buff-------------------------------------------------
--是否是有效攻击对象
local function IsValidVictim(victim)
    return victim ~= nil
        and not ((victim:HasTag("prey") and not victim:HasTag("hostile")) or
                victim:HasTag("veggie") or
                victim:HasTag("structure") or
                victim:HasTag("wall") or
                victim:HasTag("balloon") or
                victim:HasTag("groundspike") or
                victim:HasTag("smashable") or
                victim:HasTag("abigail") or
                victim:HasTag("shadowminion") or
                victim:HasTag("companion"))
        and victim.components.health ~= nil
        and victim.components.combat ~= nil
end

local function medal_aoecombat_onattack(inst, data)
	--远程射击武器会推两次消息，以第一次消耗为准
	if data.projectile==nil then
		local distance=math.sqrt(inst:GetDistanceSqToInst(data.target))--距离
		local consume = math.ceil(math.max(distance-3,0)/3) + 1--消耗
		--根据命中距离消耗层数
		if inst.medal_aoecombat_value then
			inst.medal_aoecombat_value = inst.medal_aoecombat_value - consume
		end
	end
	if inst.medal_aoecombat_value==nil or inst.medal_aoecombat_value<=0 then
		inst:RemoveDebuff("buff_medal_aoecombat")--取消Buff
	end
end

buff_defs.buff_medal_aoecombat={
	name="buff_medal_aoecombat",
	duration=TUNING_MEDAL.MEDAL_BUFF_AOECOMBAT_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		if target.medal_aoecombat_value==nil or target.medal_aoecombat_value<=0 then
			target:ListenForEvent("onattackother", medal_aoecombat_onattack)
		end
		if target and target.components.combat then
			target.components.combat.externaldamagemultipliers:SetModifier("buff_medal_aoecombat", TUNING_MEDAL.MEDAL_BUFF_AOECOMBAT_DAMAGE_MULT)--降低伤害系数
			--设置AOE伤害
			if target.components.combat.areahitrange==nil then
				target.components.combat:SetAreaDamage(TUNING_MEDAL.BEE_KING_MEDAL.AOE_DIST,1,function(victim,player)
					if IsValidVictim(victim) then
						-- SpawnPrefab("disease_puff").Transform:SetPosition(victim.Transform:GetWorldPosition())
						return true
					end
				end)
				target.medal_aoecombat_value = TUNING_MEDAL.MEDAL_BUFF_AOECOMBAT_VALUE--aoe伤害层数
			end
		end
	end,
	ondetachedfn=function(inst, target)
		if target and target.components.combat then
			target.components.combat.externaldamagemultipliers:RemoveModifier("buff_medal_aoecombat")--伤害系数恢复正常
		end
		--取消aoe伤害
		if target and target.medal_aoecombat_value then
			target.medal_aoecombat_value=nil
			if target.components.combat then
				target.components.combat:SetAreaDamage(nil)
			end
		end
		target:RemoveEventCallback("onattackother", medal_aoecombat_onattack)
	end,
}

-------------------------------------蜂毒debuff-------------------------------------------------
local function OnTickInjured(inst,target)
	if target.components.health ~= nil and
	    not target.components.health:IsDead() and
	    not target:HasTag("playerghost") then
		target.components.health:DoDelta((target.injured_damage or 1)*TUNING_MEDAL.MEDAL_BUFF_INJURED_DAMAGE, nil, "buff_medal_injured",nil,nil,true)--无视防御
		--中毒效果界面
		if target.player_classified and target.player_classified.medal_injured then
			target.player_classified.medal_injured:set_local(false)
			target.player_classified.medal_injured:set(true)
		end
	else
		 inst.components.debuff:Stop()
	end
end

--叠毒
local function AddInjured(inst, target)
	if inst.injured_task then
		inst.injured_task:Cancel()
		inst.injured_task = nil
	end
	if target ~= nil and target:IsValid() and target.components.health ~= nil then
		if not target.components.health:IsDead() then
			target.injured_damage = math.min(target.injured_damage and target.injured_damage+1 or 1,TUNING_MEDAL.MEDAL_BUFF_INJURED_MAX)--叠毒
			inst.injured_task = inst:DoPeriodicTask(1, OnTickInjured, nil, target)
		end
	end
end

buff_defs.buff_medal_injured={
	name="buff_medal_injured",
	duration=TUNING_MEDAL.MEDAL_BUFF_INJURED_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		AddInjured(inst, target)
	end,
	onextendedfn=function(inst, target)
		AddInjured(inst, target)
	end,
	ondetachedfn=function(inst, target)
		if inst.injured_task then
			inst.injured_task:Cancel()
			inst.injured_task = nil
		end
		target.injured_damage = nil--毒性移除
	end,
}

-------------------------------------流血debuff-------------------------------------------------
local function OnTickBleed(inst,target,has_origin)
	if target:IsValid() and target.components.health ~= nil and not target.components.health:IsDead() and not target:HasTag("playerghost") then
		local idx = has_origin and 2 or 1
		target.components.health:DoDelta(-1 * TUNING_MEDAL.MEDAL_BUFF_BLEED_DAMAGE[idx], nil, "buff_medal_bleed",nil,nil,true)--无视防御
	else
		 inst.components.debuff:Stop()
	end
end

local function DoBleed(inst, target, data)
	if inst.bleed_task then
		inst.bleed_task:Cancel()
		inst.bleed_task = nil
	end
	if target ~= nil and target:IsValid() and target.components.health ~= nil and not target.components.health:IsDead() then
		inst.bleed_task = inst:DoPeriodicTask(1, OnTickBleed, nil, target, data and data.has_origin)
	end
end

buff_defs.buff_medal_bleed={
	name="buff_medal_bleed",
	duration=TUNING_MEDAL.MEDAL_BUFF_BLEED_DURATION,
	priority=2,
	onattachedfn=function(inst, target, data)
		DoBleed(inst, target, data)
	end,
	onextendedfn=function(inst, target, data)
		DoBleed(inst, target ,data)
	end,
	ondetachedfn=function(inst, target)
		if inst.bleed_task then
			inst.bleed_task:Cancel()
			inst.bleed_task = nil
		end
	end,
}

----------------------------------------血蜜标记-------------------------------------------------
buff_defs.buff_medal_bloodhoneymark={
	name="buff_medal_bloodhoneymark",
	duration=TUNING_MEDAL.MEDAL_BUFF_BLOODHONEYMARK_DURATION,
	onattachedfn=function(inst, target)
		if target ~= nil and target:IsValid() and target.components.health ~= nil then
			if not target.components.health:IsDead() then
				target.blood_honey_mark = math.min(target.blood_honey_mark and target.blood_honey_mark+1 or 1,TUNING_MEDAL.MEDAL_BUFF_BLOODHONEYMARK_MAX)--叠加层数
			end
		end
	end,
	onextendedfn=function(inst, target)
		if target ~= nil and target:IsValid() and target.components.health ~= nil then
			if not target.components.health:IsDead() then
				target.blood_honey_mark = math.min(target.blood_honey_mark and target.blood_honey_mark+1 or 1,TUNING_MEDAL.MEDAL_BUFF_BLOODHONEYMARK_MAX)--叠加层数
			end
		end
	end,
	ondetachedfn=function(inst, target)
		target.blood_honey_mark = nil--移除血蜜标记
	end,
}

-------------------------------------易伤debuff(受到的伤害增加)-------------------------------------------------
--苍蝇特效
local function OnTick(inst, target)
    if target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
        SpawnPrefab("disease_puff").Transform:SetPosition(target.Transform:GetWorldPosition())
    elseif target.medal_weak_task ~= nil then
		target.medal_weak_task:Cancel()
		target.medal_weak_task = nil
    end
end

buff_defs.buff_medal_weak={
	name="buff_medal_weak",
	duration=TUNING_MEDAL.MEDAL_BUFF_WEAK_DURATION,
	onattachedfn=function(inst, target, data)
		if target ~= nil and target:IsValid() and not target.inlimbo and target.components.combat ~= nil and not IsEntityDeadOrGhost(target) then
			local idx = data and data.has_origin and 2 or 1--本源增强
			target.components.combat.externaldamagetakenmultipliers:SetModifier("buff_medal_weak", TUNING_MEDAL.MEDAL_BUFF_WEAK_MULTIPLE[idx])
			target.medal_weak_task = target:DoPeriodicTask(1, OnTick, nil, target)
		end
	end,
	onextendedfn=function(inst, target, data)
		if target ~= nil and target:IsValid() and not target.inlimbo and target.components.combat ~= nil and not IsEntityDeadOrGhost(target) then
			local idx = data and data.has_origin and 2 or 1--本源增强
			target.components.combat.externaldamagetakenmultipliers:SetModifier("buff_medal_weak", TUNING_MEDAL.MEDAL_BUFF_WEAK_MULTIPLE[idx])
		end
	end,
	ondetachedfn=function(inst, target)
		if target ~= nil and target:IsValid() and target.components.combat ~= nil then
			target.components.combat.externaldamagetakenmultipliers:RemoveModifier("buff_medal_weak")
		end
		if target.medal_weak_task ~= nil then
			target.medal_weak_task:Cancel()
			target.medal_weak_task = nil
		end
	end,
}

-------------------------------------萎靡debuff(伤害降低)-------------------------------------------------
buff_defs.buff_medal_malaise={
	name="buff_medal_malaise",
	duration=TUNING_MEDAL.MEDAL_BUFF_MALAISE_DURATION,
	onattachedfn=function(inst, target)
		if target ~= nil and target:IsValid() and not target.inlimbo and target.components.combat ~= nil and target.components.health ~= nil and not target.components.health:IsDead() then
			target.components.combat.externaldamagemultipliers:SetModifier("buff_medal_malaise", TUNING_MEDAL.MEDAL_BUFF_MALAISE_MULTIPLE)
		end
	end,
	ondetachedfn=function(inst, target)
		if target ~= nil and target:IsValid() and target.components.combat ~= nil then
			target.components.combat.externaldamagemultipliers:RemoveModifier("buff_medal_malaise")
		end
	end,
}

----------------------------------------毒伤标记-------------------------------------------------
local function AddPoisonMark(target,marknum)
	if target ~= nil and target:IsValid() and target.components.health ~= nil then
		if not target.components.health:IsDead() then
			marknum = marknum or 1
			target.medal_poison_mark = math.min(target.medal_poison_mark and target.medal_poison_mark + marknum or marknum, TUNING_MEDAL.MEDAL_BUFF_POISONMARK_MAX)--叠加层数
		end
	end
end

buff_defs.buff_medal_poisonmark={
	name="buff_medal_poisonmark",
	duration=TUNING_MEDAL.MEDAL_BUFF_POISONMARK_DURATION,
	onattachedfn=function(inst, target, data)
		AddPoisonMark(target, data and data.marknum)
	end,
	onextendedfn=function(inst, target, data)
		AddPoisonMark(target, data and data.marknum)
	end,
	ondetachedfn=function(inst, target)
		target.medal_poison_mark = nil--移除毒伤标记
	end,
}

----------------------------------------鱼人诅咒-------------------------------------------------
local function AddMermCurse(target,curse)
	if target ~= nil and target:IsValid() and target.components.health ~= nil then
		if not target.components.health:IsDead() then
			curse = curse or 1
			target.medal_merm_curse = math.min(target.medal_merm_curse and target.medal_merm_curse + curse or curse,TUNING_MEDAL.MEDAL_BUFF_MERMCURSE_MAX)--叠加层数
			if target.medal_merm_curse >= TUNING_MEDAL.MEDAL_BUFF_MERMCURSE_MAX then
				target:PushEvent("medal_transfrom_merm")--推送变身事件
			end
		end
	end
end

buff_defs.buff_medal_mermcurse={
	name="buff_medal_mermcurse",
	duration=TUNING_MEDAL.BUFF_MEDAL_MERMCURSE_DURATION,
	onattachedfn=function(inst, target, data)
		AddMermCurse(target,data and data.curse)
	end,
	onextendedfn=function(inst, target, data)
		AddMermCurse(target,data and data.curse)
	end,
	ondetachedfn=function(inst, target)
		target.medal_merm_curse = nil--移除鱼人标记
	end,
}

----------------------------------------迷糊标记(捞月)-------------------------------------------------
local function AddConfusedMark(target)
	if target ~= nil and target:IsValid() and target.components.health ~= nil then
		if not target.components.health:IsDead() then
			target.medal_confused_mark = math.min(target.medal_confused_mark and target.medal_confused_mark+1 or 1,TUNING_MEDAL.MEDAL_BUFF_CONFUSED_MAX)--叠加层数
		end
	end
end

buff_defs.buff_medal_confused={
	name="buff_medal_confused",
	duration=TUNING_MEDAL.MEDAL_BUFF_CONFUSED_DURATION,
	onattachedfn=function(inst, target)
		AddConfusedMark(target)
	end,
	onextendedfn=function(inst, target)
		AddConfusedMark(target)
	end,
	ondetachedfn=function(inst, target)
		target.medal_confused_mark = nil--移除迷糊标记
	end,
}

----------------------------------------红晶标记-------------------------------------------------
local NO_TAGS_NO_PLAYERS =	{ "bramble_resistant", "INLIMBO", "notarget", "noattack", "flight", "invisible", "wall", "player", "companion" , "noredattack" , "shadowminion" }
local COMBAT_TARGET_TAGS = { "_combat" }
local ATTACKRANGE = 3
--引爆红晶标记
local function DoRedAttack(target)
	if target:IsValid() and target.components.health ~= nil and not target.components.health:IsDead() then
		local marks = target.medal_red_mark or 1
		local x, y, z = target.Transform:GetWorldPosition()
		local mult = target.medal_red_mark_mult or 1--本源伤害加成倍数
		if marks >= 5 then
			SpawnMedalFX("firesplash_fx",target)
            for i, v in ipairs(TheSim:FindEntities(x, y, z, ATTACKRANGE, COMBAT_TARGET_TAGS, NO_TAGS_NO_PLAYERS)) do
                if v ~= target and v:IsValid() and v.components.health ~= nil and not v.components.health:IsDead() then
                    v.components.health:DoDelta(math.asin(1*.2)*-68*mult, nil, "buff_medal_redmark")
					v:AddDebuff("buff_medal_redmark","buff_medal_redmark",{noredattack=true})--添加红晶标记
                end
            end
		end
		SpawnMedalFX("willow_throw_flame",target)
		target.components.health:DoDelta(math.asin(marks*.2)*-68*mult, nil, "buff_medal_redmark")
	end
	target:RemoveTag("noredattack")
	target.medal_red_mark = nil--移除红晶标记
	target.medal_red_mark_mult = nil--移除红晶标记伤害加成
end

--添加红晶标记
local function AddRedMark(target, data)
	if target ~= nil and target:IsValid() and target.components.health ~= nil and not target.components.health:IsDead() then
		SpawnMedalFX("halloween_firepuff_2",target)
		if data and data.noredattack then
			target:AddTag("noredattack")
		else
			target:RemoveTag("noredattack")
		end
		if data and data.has_origin then
			target.medal_red_mark_mult = 1.5--本源伤害加成倍数
		end
		target.medal_red_mark = math.min(target.medal_red_mark and target.medal_red_mark+1 or 1,TUNING_MEDAL.MEDAL_BUFF_REDMARK_MAX)--叠加层数
		--满5层了直接爆
		if target.medal_red_mark >= TUNING_MEDAL.MEDAL_BUFF_REDMARK_MAX then
			target:DoTaskInTime(0,function(target)--做个延迟，防止过早移除buff导致报错
				target:RemoveDebuff("buff_medal_redmark")
			end)
		end
	end
end

buff_defs.buff_medal_redmark={
	name="buff_medal_redmark",
	duration=TUNING_MEDAL.MEDAL_BUFF_REDMARK_DURATION,
	onattachedfn=function(inst, target, data)
		AddRedMark(target, data)
	end,
	onextendedfn=function(inst, target, data)
		AddRedMark(target, data)
	end,
	ondetachedfn=function(inst, target)
		DoRedAttack(target)
	end,
}

----------------------------------------蓝晶标记-------------------------------------------------
--添加蓝晶标记
local function AddBlueMark(inst, target, data)
	if target ~= nil and target:IsValid() and target.components.health ~= nil and not target.components.health:IsDead() 
		and (target.components.freezable==nil or not target.components.freezable:IsFrozen()) then
		SpawnMedalFX("halloween_firepuff_cold_2",target)
		local marknum = data and data.marknum or 1
		target.medal_blue_mark = math.min(target.medal_blue_mark and target.medal_blue_mark + marknum or marknum,TUNING_MEDAL.MEDAL_BUFF_BLUEMARK_MAX)--叠加层数
		--满5层了直接冰冻
		if target.medal_blue_mark >= TUNING_MEDAL.MEDAL_BUFF_BLUEMARK_MAX and target.components.freezable and not target.components.freezable:IsFrozen()
			and target.components.combat and target.components.combat.losetargetcallback~=nil then
				target.components.freezable:AddColdness(6,TUNING_MEDAL.MEDAL_BUFF_BLUEMARK_FROZEN_TIME)
				target.components.freezable:SpawnShatterFX()
				target.components.combat.externaldamagetakenmultipliers:SetModifier("buff_medal_bluemark", data and data.has_origin and 2 or 1.75)--易伤
				target:DoTaskInTime(0,function(target)--做个延迟，防止过早移除buff导致报错
					target:RemoveDebuff("buff_medal_bluemark")
				end)
		--否则就减速
		elseif target.components.locomotor ~= nil then
			target.components.locomotor:SetExternalSpeedMultiplier(inst, "buff_medal_bluemark", 1 - target.medal_blue_mark * TUNING_MEDAL.MEDAL_BUFF_BLUEMARK_SPEED_MULT)
		end
	end
end

buff_defs.buff_medal_bluemark={
	name="buff_medal_bluemark",
	duration=TUNING_MEDAL.MEDAL_BUFF_BLUEMARK_DURATION,
	onattachedfn=function(inst, target, data)
		AddBlueMark(inst, target, data)
	end,
	onextendedfn=function(inst, target, data)
		AddBlueMark(inst, target, data)
	end,
	ondetachedfn=function(inst, target)
		target.medal_blue_mark = nil--移除蓝晶标记
		if target.components.locomotor ~= nil then
			target.components.locomotor:RemoveExternalSpeedMultiplier(inst, "buff_medal_bluemark")
		end
	end,
}

-------------------------------------混乱buff(反向操作)-------------------------------------------------
buff_defs.buff_medal_confusion={
	name="buff_medal_confusion",
	duration=TUNING_MEDAL.MEDAL_BUFF_CONFUSION_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		target:AddTag("medal_confusion")
	end,
	ondetachedfn=function(inst, target)
		target:RemoveTag("medal_confusion")
	end,
}

return buff_defs