--添加buff
local function addBuff(eater,buff)
	eater:AddDebuff(buff,buff)
end

--各种调料
local medal_spices = {
	spice_jelly={--果冻粉
		prefabs = {"buff_moistureimmunity"},
		oneatenfn=function(inst, eater)
			addBuff(eater,"buff_moistureimmunity")--添加干燥buff
		end
	},
	spice_voltjelly={--带电果冻粉
		prefabs = {"buff_electricattack"},
		oneatenfn=function(inst, eater)
		    addBuff(eater,"buff_electricattack")--添加点击buff
		end
	},
	spice_phosphor={--荧光粉
		prefabs = {"wormlight_light_greater"},
		oneatenfn=function(inst, eater)
		    --设置光源
		    if eater.wormlight ~= nil then
		    	if eater.wormlight.prefab == "wormlight_light_greater" then
		    		eater.wormlight.components.spell.lifetime = 0
		    		eater.wormlight.components.spell:ResumeSpell()
		    		return
		    	else
		    		eater.wormlight.components.spell:OnFinish()
		    	end
		    end
		    
		    local light = SpawnPrefab("wormlight_light_greater")
		    light.components.spell:SetTarget(eater)
		    if light:IsValid() then
		    	if light.components.spell.target == nil then
		    		light:Remove()
		    	else
		    		light.components.spell:StartSpell()
		    	end
		    end
		end,
		client_fn=function(inst)--客机扩展函数
			inst.entity:AddLight()--发光组件
			inst.Light:SetFalloff(0.7)
			inst.Light:SetIntensity(.5)
			inst.Light:SetRadius(0.5)
			inst.Light:SetColour(237/255, 237/255, 209/255)
			inst.Light:Enable(true)
			inst:AddTag("lightbattery")
		end
	},
	spice_moontree_blossom={--月树花粉
		prefabs = {"buff_medal_sanityregen"},
		oneatenfn=function(inst, eater)
		    addBuff(eater,"buff_medal_sanityregen")--添加精神保护buff
		end
	},
	spice_cactus_flower={--仙人掌花粉
		prefabs = {"buff_medal_quicklocomotor"},
		oneatenfn=function(inst, eater)
			addBuff(eater,"buff_medal_quicklocomotor")--添加加速buff
		end
	},
	spice_blood_sugar={--血糖
		prefabs = {"buff_medal_bloodsucking"},
		oneatenfn=function(inst, eater)
			addBuff(eater,"buff_medal_bloodsucking")--添加凝血buff(掉血减半)
		end
	},
	spice_rage_blood_sugar={--黑暗血糖
		prefabs = {"buff_medal_suckingblood"},
		oneatenfn=function(inst, eater)
			addBuff(eater,"buff_medal_suckingblood")--添加吸血buff
		end
	},
	spice_soul={--灵魂佐料
		-- prefabs = {"wormlight_light_greater"},
		oneatenfn=function(inst, eater)
		    --小恶魔吃了可获得全部收益
		    if eater.prefab=="wortox" then
		    	if inst.components.edible then
		    		if eater.components.health ~= nil and not eater.components.health:IsDead() then
		    			local delta = inst.components.edible.healthvalue/2 or 0
		    			if delta > 0 then
		    				eater.components.health:DoDelta(delta, nil, inst.prefab)
		    			end
		    		end
		    
		    		if eater.components.hunger ~= nil then
		    			local delta = inst.components.edible.hungervalue/2 or 0
		    			if delta > 0 then
		    				eater.components.hunger:DoDelta(delta)
		    			end
		    		end
		    
		    		if eater.components.sanity ~= nil then
		    			local delta = inst.components.edible.sanityvalue/2 or 0
		    			if delta > 0 then
		    				eater.components.sanity:DoDelta(delta)
		    			end
		    		end
		    	end
		    else--其他角色吃了可获得一次性的灵魂跳跃能力
		    	if not eater:HasTag("temporaryblinker") then
		    		eater:AddTag("temporaryblinker")
		    	end
		    	--伍迪变身回来玩家跳跃函数会被挪掉，需要重设
		    	if eater.prefab=="woodie" and eater.medalblinkable then
		    		if eater.medalblinkable:value() then
						eater.medalblinkable:set_local(false)
						eater.medalblinkable:set(true)
		    		else
		    			eater.medalblinkable:set(true)
		    		end
		    	end
		    end
		end
	},
	spice_potato_starch={--土豆淀粉
		prefabs = {"buff_medal_assuagehunger"},
		oneatenfn=function(inst, eater)
		    addBuff(eater,"buff_medal_assuagehunger")--添加饱腹buff
		end
	},
	spice_poop={--秘制酱料
		prefabs = {"buff_medal_poopfood"},
		oneatenfn=function(inst, eater)
		    --植物人
		    if eater.prefab=="wormwood" then
		    	--吃料理正常回血
		    	if inst.components.edible then
		    		if eater.components.health ~= nil and not eater.components.health:IsDead() then
		    			local delta = inst.components.edible.healthvalue or 0
		    			if delta > 0 then
		    				eater.components.health:DoDelta(delta, nil, inst.prefab)
		    			end
		    		end
		    	end
				addBuff(eater,"buff_medal_poopfood")--添加吃屎buff
		    --其他人吃了扣san
		    elseif eater.components.sanity then
		    	eater.components.sanity:DoDelta(TUNING_MEDAL.POOPFOOD_SANITY_CONSUME)
		    	MedalSay(eater,STRINGS.EATPOOPSPEECH.NAUSEA)
		    end
		end,
		client_fn=function(inst)--客机扩展函数
			inst:AddTag("slowfertilize")
			inst:AddTag("heal_fertilize")
			inst:AddTag("fertilizerresearchable")
			MakeDeployableFertilizerPristine(inst)
			inst.GetFertilizerKey=function(inst)
				return inst.prefab
			end
		end,
		server_fn=function(inst)--主机扩展函数
			inst:AddComponent("fertilizerresearchable")
			inst.components.fertilizerresearchable:SetResearchFn(function(inst)
				return inst:GetFertilizerKey()
			end)
			inst:AddComponent("fertilizer")
			inst.components.fertilizer.fertilizervalue = TUNING.COMPOSTWRAP_FERTILIZE/3
			inst.components.fertilizer.soil_cycles = TUNING.COMPOSTWRAP_SOILCYCLES/2
			inst.components.fertilizer.withered_cycles = TUNING.COMPOSTWRAP_WITHEREDCYCLES/2
			inst.components.fertilizer:SetNutrients({8,16,8})
			MakeDeployableFertilizer(inst)
		end
	},
	spice_plantmeat={--叶肉酱
		prefabs = {"buff_medal_upappetite"},
		foodtype = FOODTYPE.GOODIES,--食物标签
		oneatenfn=function(inst, eater)
		    addBuff(eater,"buff_medal_upappetite")--添加开胃buff
			--降一定的饱食度
		    if eater.components.hunger then
		    	eater.components.hunger:DoDelta(TUNING_MEDAL.UPAPPETITE_HUNGER_CONSUME)
		    end
		end
	},
	spice_mandrake_jam={--曼德拉果酱
		prefabs = {"buff_medal_nostiff"},
		oneatenfn=function(inst, eater)
		    addBuff(eater,"buff_medal_nostiff")--添加霸体buff(免疫被打击时的僵直)
		end
	},
	spice_pomegranate={--山力叶酱(石榴)
		prefabs = {"buff_medal_strong"},
		oneatenfn=function(inst, eater)
		    addBuff(eater,"buff_medal_strong")--添加强壮buff(搬运重物不减速)
		end
	},
	spice_withered_royal_jelly={--凋零蜂王浆酱
		prefabs = {"buff_medal_aoecombat"},
		oneatenfn=function(inst, eater)
		    --如果佩戴了蜂王勋章并处于aoe模式，则直接增加蜂王勋章耐久
			if eater.medal_aoecombat then
				local medal = eater.components.inventory and eater.components.inventory:EquipMedalWithName("bee_king_certificate")
				if medal and medal.components.finiteuses then
					medal.components.finiteuses:SetUses(math.min(medal.components.finiteuses:GetUses()+TUNING_MEDAL.MEDAL_BUFF_AOECOMBAT_VALUE*.5,medal.components.finiteuses.total))
				end
			else--否则获得buff
				addBuff(eater,"buff_medal_aoecombat")--aoe范围伤害
			end
		end
	},
}

return medal_spices