-- key为弹药预置物名
-- switch--开关，控制是否加入这种弹药
-- damage--弹药伤害
-- symbol--贴图名
-- onhit--击中时触发的函数
-- tags--标签列表
-- onloadammo--装载函数，装载弹药时触发
-- onunloadammo--卸载函数，卸下弹药时触发
-- hit_sound--命中声音
-- fuelvalue--燃料值，弹药可用来填燃料
-- no_inv_item--为true则不生成对应的预制物，只生成子弹
-- extrafn--额外扩展函数


--命中特效
local function ImpactFx(inst, attacker, target)
    if target ~= nil and target:IsValid() then
		local impactfx = SpawnPrefab(inst.ammo_def.impactfx)
		impactfx.Transform:SetPosition(target.Transform:GetWorldPosition())
				
		if inst.ammo_def.hit_sound ~= nil then
			inst.SoundEmitter:PlaySound(inst.ammo_def.hit_sound)
		end
    end
end
--弹弓的临时仇恨系统，目标在打其他玩家或生物时，使用弹弓攻击不会吸引走目标的仇恨
local function no_aggro(attacker, target)
	local targets_target = target.components.combat ~= nil and target.components.combat.target or nil
	return targets_target ~= nil and targets_target:IsValid() and targets_target ~= attacker and attacker:IsValid()
			and (GetTime() - target.components.combat.lastwasattackedbytargettime) < 4
			and (targets_target.components.health ~= nil and not targets_target.components.health:IsDead())
end

--子弹列表
local ammo_defs={}

-------------------------------------方尖弹-------------------------------------------------
ammo_defs.medalslingshotammo_sanityrock={
	switch = true,
	symbol = "sanityrock",
	onhit = function(inst, attacker, target)
		ImpactFx(inst, attacker, target)
		target:AddDebuff("buff_medal_bleed", "buff_medal_bleed",{extend_duration=TUNING_MEDAL.MEDAL_BUFF_BLEED_DURATION, max_duration_mult=4,has_origin = HasOriginMedal(attacker,"senior_childishness")})
		inst:Remove()
	end,
	damage = TUNING_MEDAL.MEDALSLINGSHOTAMMO_SANITYROCK_DAMAGE,
	hit_sound = "dontstarve/characters/walter/slingshot/trinket",
}

-------------------------------------沙刺弹-------------------------------------------------
ammo_defs.medalslingshotammo_sandspike={
	switch = true,
	symbol = "sandspike",
	onhit = function(inst, attacker, target)
		ImpactFx(inst, attacker, target)
		if target ~= nil and target:IsValid() then
			local spike
			local pt = target:GetPosition()
			--佩戴时空勋章攻击无视地形生成时空之刃
			if attacker and attacker:HasTag("spacetime_medal") then
				spike = HasOriginMedal(attacker,"senior_childishness") and "medal_spike_med" or "medal_spike_short"--本源童真提升时空之刃尺寸
			elseif pt and TheWorld.Map:GetTileAtPoint(pt.x, 0, pt.z) == GROUND.DESERT_DIRT and target.components.locomotor~=nil then
				spike="sandspike"
			end
			
			if pt and spike then
				local sandspike = SpawnPrefab(spike)
				if sandspike ~= nil then
					sandspike.Transform:SetPosition(pt.x, 0, pt.z)
					sandspike.fromplayer = true--是玩家召唤的
				end
			end
		end
		inst:Remove()
	end,
	damage = TUNING_MEDAL.MEDALSLINGSHOTAMMO_SANDSPIKE_DAMAGE,
	hit_sound = "dontstarve/characters/walter/slingshot/gold",
}

-------------------------------------落水弹-------------------------------------------------
local can_extinguish_list={
	stafflight = true,--矮星
	staffcoldlight = true,--冷星
	emberlight = true,--火女火球
}
ammo_defs.medalslingshotammo_water={
	switch = true,
	-- impactfx = "waterballoon_splash",
	symbol = "water",
	onhit = function(inst, attacker, target)
		ImpactFx(inst, attacker, target)
		if target.components.combat then
			--如果目标睡着了，直接叫醒
			if target.components.sleeper ~= nil and target.components.sleeper:IsAsleep() then
				target.components.sleeper:WakeUp()
			end
			--给目标加潮湿度(远古织影者除外)
			if target.components.moisture == nil and target.prefab ~= "stalker_atrium" then
				target:AddComponent("moisture")
			end
			--防水比例
			local waterproofness = target.components.inventory and math.min(target.components.inventory:GetWaterproofness(),1) or 0
			--打湿目标
			if target.components.moisture then
				target.components.moisture:DoDelta(TUNING_MEDAL.MEDALSLINGSHOTAMMO_WATER_MOISTURE[HasOriginMedal(attacker,"senior_childishness") and 2 or 1] * (1 - waterproofness))
			end
			--吸引仇恨
			if not no_aggro(attacker, target) then
				target.components.combat:SuggestTarget(attacker)
			end
		end
		--灭火
		if target.components.burnable ~= nil then
			if target.components.burnable:IsBurning() then
				target.components.burnable:Extinguish()
			elseif target.components.burnable:IsSmoldering() then
				target.components.burnable:SmotherSmolder()
			end
		end
		--矮星照样灭
		if can_extinguish_list[target.prefab] and target.components.hauntable and target.components.hauntable.onhaunt then
			target.components.hauntable.onhaunt(target)
		end

		inst:Remove()
	end,
	tags = { "extinguisher","stafflight_killer" },
	onloadammo = function(inst, data)
		-- print("onloadammo_ice", inst, data ~= nil and data.slingshot)
		--装载时给弹弓添加灭火器标签
		if data ~= nil and data.slingshot then
			data.slingshot:AddTag("extinguisher")
			data.slingshot:AddTag("stafflight_killer")--矮星杀手
		end
	end,
	onunloadammo = function(inst, data)
		-- print("onunloadammo_ice", inst, data ~= nil and data.slingshot)
		--卸载时给弹弓卸载灭火器标签
		if data ~= nil and data.slingshot then
			data.slingshot:RemoveTag("extinguisher")
			data.slingshot:RemoveTag("stafflight_killer")
		end
	end,
	damage = nil,
	-- hit_sound = "dontstarve/characters/walter/slingshot/frozen",
	hit_sound = "dontstarve/creatures/pengull/splash",
}

-------------------------------------噬魂弹-------------------------------------------------
ammo_defs.medalslingshotammo_devoursoul={
	switch = true,
	symbol = "devoursoul",
	onhit = function(inst, attacker, target)
		ImpactFx(inst, attacker, target)
		if target ~= nil and target:IsValid() and target.components.health ~= nil and not target.components.health:IsDead() and not target:HasTag("playerghost") then
			local idx = HasOriginMedal(attacker,"senior_childishness") and 2 or 1--本源增强
			local max_damage = TUNING_MEDAL.MEDALSLINGSHOTAMMO_DEVOURSOUL_DAMAGE_MAX[idx]--伤害上限
			local damame_mult = TUNING_MEDAL.MEDALSLINGSHOTAMMO_DEVOURSOUL_DAMAGE_MULT[idx]--伤害比例
			local damage = math.min( target.components.health.maxhealth * damame_mult, target.components.health.currenthealth - 1, max_damage)
			target.components.health:DoDelta(-damage, nil, "medalslingshotammo_devoursoul",nil,nil,true)--无视防御
		end
		--吸引仇恨
		if not no_aggro(attacker, target) and target.components.combat ~= nil then
			target.components.combat:SuggestTarget(attacker)
		end
		
		inst:Remove()
	end,
	damage = nil,
	hit_sound = "dontstarve/characters/walter/slingshot/trinket",
}

-------------------------------------痰蛋弹-------------------------------------------------
ammo_defs.medalslingshotammo_taunt={
	switch = true,
	symbol = "taunt",
	onhit = function(inst, attacker, target)
		ImpactFx(inst, attacker, target)
		--给目标添加debuff
		target:AddDebuff("buff_medal_weak", "buff_medal_weak",{has_origin = HasOriginMedal(attacker,"senior_childishness")})
		--吸引仇恨
		if not no_aggro(attacker, target) and target.components.combat ~= nil then
			target.components.combat:SuggestTarget(attacker)
		end
		
		inst:Remove()
	end,
	damage = nil,
	hit_sound = "dontstarve/characters/walter/slingshot/poop",
}

-------------------------------------尖刺弹-------------------------------------------------
local BOMB_MUSTHAVE_TAGS = { "_combat" }
local function do_bomb(inst, thrower, target, no_hit_tags, damage)
    local bx, by, bz = inst.Transform:GetWorldPosition()

    --寻找子弹周围可命中的目标
    local entities = TheSim:FindEntities(bx, by, bz, TUNING_MEDAL.MEDALSLINGSHOTAMMO_SPINES_AOE_RANGE, BOMB_MUSTHAVE_TAGS, no_hit_tags)

    --aoe造成的伤害要记到玩家头上的话，要把伤害暂时设定为无视攻击距离
    if thrower ~= nil and thrower.components.combat ~= nil and thrower:IsValid() then
        thrower.components.combat.ignorehitrange = true
    else
        thrower = nil
    end
	
    for i, v in ipairs(entities) do
        if v:IsValid() and v.entity:IsVisible() and inst.components.combat:CanTarget(v) then
			--如果目标没有攻击目标，则使目标受到玩家伤害(拉仇恨)
            if thrower ~= nil then
                v.components.combat:GetAttacked(thrower, damage, inst)
            else--否则直接对目标进行攻击
                inst.components.combat:DoAttack(v)
            end
        end
    end

    if thrower ~= nil then
        thrower.components.combat.ignorehitrange = false
    end
end

local NO_TAGS_PLAYER =  { "INLIMBO", "ghost", "playerghost", "FX", "NOCLICK", "DECOR", "notarget", "companion", "shadowminion", "player" }
local NO_TAGS_PVP =     { "INLIMBO", "ghost", "playerghost", "FX", "NOCLICK", "DECOR", "notarget", "companion", "shadowminion" }

ammo_defs.medalslingshotammo_spines={
	switch = true,
	symbol = "spines",
	onhit = function(inst, attacker, target)
		ImpactFx(inst, attacker, target)
		local idx = HasOriginMedal(attacker,"senior_childishness") and 2 or 1--本源增强
		--PVP模式可以伤害到玩家
		if TheNet:GetPVPEnabled() then
		    do_bomb(inst, attacker, target, NO_TAGS_PVP, TUNING_MEDAL.MEDALSLINGSHOTAMMO_SPINES_AOE_DAMAGE[idx])
		else
		    do_bomb(inst, attacker, target, NO_TAGS_PLAYER, TUNING_MEDAL.MEDALSLINGSHOTAMMO_SPINES_AOE_DAMAGE[idx])
		end
		
		inst:Remove()
	end,
	damage = nil,
	hit_sound = "dontstarve/characters/walter/slingshot/slow",
	extrafn = function(inst)
		inst:AddComponent("combat")
		inst.components.combat:SetDefaultDamage(TUNING_MEDAL.MEDALSLINGSHOTAMMO_SPINES_AOE_DAMAGE[1])
		inst.components.combat:SetRange(TUNING_MEDAL.MEDALSLINGSHOTAMMO_SPINES_AOE_RANGE)--范围
		inst.components.combat:SetKeepTargetFunction(function(i) return false end)
	end,
}

-------------------------------------曼德拉果-------------------------------------------------
ammo_defs.mandrakeberry={
	switch = true,
	symbol = "mandrakeberry",
	no_inv_item = true,
	onhit = function(inst, attacker, target)
		ImpactFx(inst, attacker, target)
		local mult = HasOriginMedal(attacker,"senior_childishness") and 2 or 1--本源增强
		--添加睡眠值
		if target.components.grogginess ~= nil then 
			target.components.grogginess:AddGrogginess(2 * mult, 15)
		elseif target.components.sleeper ~= nil then
			target.components.sleeper:AddSleepiness(2 * mult, 15)
		end

		local mandark_chance = TUNING_MEDAL.MANDRAKEBERRY_SEED_CHANCE.MANDRAKE_LESS
		local weed_chance = TUNING_MEDAL.MANDRAKEBERRY_SEED_CHANCE.WEED_LESS + mandark_chance
		local prefabname = nil
		local rand = math.random()
		--蔓草种子
		if rand<mandark_chance then
			prefabname = "mandrake_seeds"
		--杂草种子
		elseif rand<weed_chance then
			prefabname = "medal_weed_seeds"
		end
		if prefabname ~= nil and inst.components.lootdropper then
			inst.components.lootdropper:SpawnLootPrefab(prefabname)
		end
		inst:Remove()
	end,
	damage = nil,
	hit_sound = "dontstarve/characters/walter/slingshot/poop",
	extrafn = function(inst)
		inst:AddComponent("lootdropper")
	end,
}

return ammo_defs