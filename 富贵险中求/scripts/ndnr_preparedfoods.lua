local foods = {
    ndnr_dragoonheartlavaeegg = {
        test = function(cooker, names, tags)
            return names.lavae_egg and names.ndnr_dragoonheart and not tags.inedible
        end,
        priority = 100,
        foodtype = FOODTYPE.MEAT,
        health = 20,
        hunger = 75,
        sanity = 5,
        perishtime = TUNING.PERISH_MED,
        temperature = TUNING.HOT_FOOD_WARMING_THRESHOLD,
        temperatureduration = TUNING.FOOD_TEMP_LONG,
        cooktime = 1, -- 在普通锅里1为20s，2为40s，依此类推。厨师锅做饭是普通锅耗时的0.8倍，如果用厨师锅，1为18s，2为36s，依此类推。
        floater = {"med", nil, 0.55},
        ndnr_light = {radius=1,color={255/255, 215/255, 68/255},intensity=0.8,falloff=0.6},
        oneat_desc = STRINGS.UI.COOKBOOK.NDNR_DRAGOONHEARTLAVAEEGG,
        oneatenfn = function(inst, eater)
            if eater:HasTag("player") and eater.components.debuffable then
                if eater.components.debuffable:HasDebuff("ndnr_dragoonheartdebuff") then
                    eater.components.debuffable:RemoveDebuff("ndnr_dragoonheartdebuff")
                end
                eater.components.debuffable:AddDebuff("ndnr_dragoonheartlavaeggdebuff", "ndnr_dragoonheartlavaeggdebuff")
            end

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
        end
    },
    ndnr_coffee = {
		test = function(cooker, names, tags)
			return names.ndnr_coffeebeans_cooked and (names.ndnr_coffeebeans_cooked == 4 or (names.ndnr_coffeebeans_cooked == 3 and (tags.dairy or tags.sweetener)))
		end,
		priority = 30,
		-- foodtype = FOODTYPE.VEGGIE,
		health = TUNING.HEALING_SMALL,
		hunger = TUNING.CALORIES_TINY,
		perishtime = TUNING.PERISH_MED,
		sanity = -TUNING.SANITY_TINY,
		cooktime = 0.5,
        oneat_desc = STRINGS.UI.COOKBOOK.NDNR_COFFEE,
        oneatenfn = function(inst, eater)
            if eater:HasTag("player") and eater.components.debuffable then
                eater.components.debuffable:AddDebuff("ndnr_coffeedebuff", "ndnr_coffeedebuff")
            end
        end
	},
    ndnr_yogurt = {
		test = function(cooker, names, tags) return tags.dairy and tags.dairy == 2 and tags.sweetener and tags.fruit end,
		priority = 50,
		foodtype = FOODTYPE.GOODIES,
		health = TUNING.HEALING_LARGE,
		hunger = TUNING.CALORIES_MED,
		sanity = TUNING.SANITY_HUGE,
		perishtime = TUNING.PERISH_FAST,
        oneat_desc = STRINGS.UI.COOKBOOK.NDNR_YOGURT,
		cooktime = 2,
	},
    butter = {
		test = function(cooker, names, tags) return tags.dairy and tags.dairy == 4 end,
		priority = 50,
		foodtype = FOODTYPE.GENERIC,
		health = TUNING.HEALING_LARGE,
		hunger = TUNING.CALORIES_MED,
		sanity = 0,
		perishtime = TUNING.PERISH_SUPERSLOW,
		cooktime = 4,
        notinitprefab = true,
        oneat_desc = STRINGS.UI.COOKBOOK.BUTTER,
	},
    ndnr_mushroom_wine = {
		test = function(cooker, names, tags) return names.red_cap_cooked and names.green_cap_cooked and names.blue_cap_cooked and names.moon_cap_cooked end,
		priority = 100,
		foodtype = FOODTYPE.GOODIES,
		health = 0,
		hunger = 0,
		sanity = -50,
		perishtime = nil,
        tags = {"drink", "mushroom_wine"},
		cooktime = 3,
        oneat_desc = STRINGS.UI.COOKBOOK.NDNR_MUSHROOM_WINE,
        oneatenfn = function(inst, eater)
            if eater:HasTag("player") and not eater:HasTag("playerghost") then
                if eater.components.grogginess then
                    eater.components.grogginess:AddGrogginess(5)
                end
            end
        end
	},
	ndnr_snakewine = {
        test = function(cooker, names, tags)
            return names.ndnr_snake and tags.frozen and not tags.meat and not tags.sweetener
                and not tags.egg and (tags.inedible and tags.inedible <= 1)
        end,
        priority = 100,
        foodtype = FOODTYPE.GOODIES,
        health = 8,
        hunger = 9.375,
        sanity = 10,
        perishtime = nil,
        tags = {"drink"},
        cooktime = 3,
        oneat_desc = STRINGS.UI.COOKBOOK.NDNR_SNAKEWINE,
        oneatenfn = function(inst, eater)
            if eater:HasTag("player") and not eater:HasTag("playerghost") then
                if eater.components.debuffable then
                    eater.components.debuffable:AddDebuff("ndnr_snakewinedebuff", "ndnr_snakewinedebuff")
                end
                if eater.components.grogginess then
                    eater.components.grogginess:AddGrogginess(5)
                end
            end
        end
    },
	ndnr_chinesefood = {
        test = function(cooker, names, tags)
            return (tags.meat and tags.meat >= 1) and tags.egg and tags.dairy and (tags.veggie and tags.veggie >= 1)
        end,
        priority = 100,
        foodtype = FOODTYPE.GOODIES,
        health = 5,
        hunger = 110,
        sanity = 30,
        tags = {"chinesefood"},
        perishtime = TUNING.PERISH_SLOW,
        temperature = TUNING.HOT_FOOD_BONUS_TEMP,
        temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
        oneat_desc = STRINGS.UI.COOKBOOK.NDNR_CHINESEFOOD,
        cooktime = 1,
    },
	ndnr_coconutjuice = {
        test = function(cooker, names, tags)
            return tags.frozen and names.honey and names.ndnr_coconut and names.cutreeds
        end,
        priority = 20,
        foodtype = FOODTYPE.GOODIES,
        health = TUNING.HEALING_TINY,
        hunger = 0,
        sanity = TUNING.SANITY_MEDLARGE,
        perishtime = TUNING.PERISH_FAST,
        temperature = TUNING.COLD_FOOD_BONUS_TEMP,
        temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
        cooktime = 1,
    },
	ndnr_tomato_egg = {
        test = function(cooker, names, tags)
            return tags.egg and tags.egg >= 2 and ((names.tomato and names.tomato >= 2) or (names.tomato_cooked and names.tomato_cooked >= 2) or (names.tomato and names.tomato_cooked))
        end,
        priority = 50,
        foodtype = FOODTYPE.VEGGIE,
        health = TUNING.HEALING_LARGE,
        hunger = TUNING.CALORIES_HUGE,
        sanity = TUNING.SANITY_TINY,
        perishtime = TUNING.PERISH_FASTISH,
        cooktime = 1,
    },
	ndnr_shrimppullegg = {
        test = function(cooker, names, tags)
            return tags.egg and tags.egg >= 2 and (names.wobster_moonglass_land or names.wobster_sheller_land)
        end,
        priority = 50,
        foodtype = FOODTYPE.MEAT,
        health = TUNING.HEALING_HUGE,
        hunger = TUNING.CALORIES_LARGE,
        sanity = TUNING.SANITY_LARGE,
        perishtime = TUNING.PERISH_FAST,
        oneat_desc = STRINGS.UI.COOKBOOK.NDNR_SHRIMPPULLEGG,
        cooktime = 1,
    },
	ndnr_dongpopork = {
        test = function(cooker, names, tags)
            return names.meat and names.meat >= 2 and tags.sweetener and names.cutreeds and not tags.monster and not tags.fish
        end,
        priority = 50,
        foodtype = FOODTYPE.MEAT,
        health = TUNING.HEALING_MEDSMALL,
        hunger = TUNING.CALORIES_HUGE,
        sanity = TUNING.SANITY_LARGE,
        perishtime = TUNING.PERISH_SLOW,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
        cooktime = 2,
    },
	ndnr_icecream = {
        test = function(cooker, names, tags)
            return tags.dairy and tags.egg and tags.frozen and tags.sweetener
        end,
        priority = 50,
        foodtype = FOODTYPE.GOODIES,
        health = TUNING.HEALING_MEDSMALL,
        hunger = TUNING.CALORIES_SMALL,
        sanity = TUNING.SANITY_MED,  --15san
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_LONG,
        perishtime = TUNING.PERISH_ONE_DAY,
        cooktime = .5,
        stacksize = 2,
        oneatenfn = function(inst, eater)
            if eater.components.freezable then
                eater.components.freezable:AddColdness(3)
            end
        end,
    },
	ndnr_haagendazs = {
        test = function(cooker, names, tags)
            return tags.dairy and tags.dairy >= 2 and tags.frozen and names.royal_jelly and names.butter
        end,
        tags = {"frozen"},
        priority = 50,
        foodtype = FOODTYPE.GOODIES,
        health = TUNING.HEALING_SUPERHUGE,
        hunger = TUNING.CALORIES_SMALL,
        sanity = TUNING.SANITY_HUGE,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_LONG,
        perishtime = TUNING.PERISH_TWO_DAY,
        prefabs = { "sweettea_buff" },
        cooktime = .5,
        oneatenfn = function(inst, eater)
            if eater:HasTag("player") and not eater:HasTag("playerghost") then
                eater:AddDebuff("sweettea_buff", "sweettea_buff")
            else
                if eater.components.freezable then
                    eater.components.freezable:AddColdness(5)
                end
            end
        end,
    },
	ndnr_figpudding = {
        test = function(cooker, names, tags)
            return names.fig and tags.dairy and tags.dairy >= 2 and tags.sweetener
        end,
        priority = 60,
        foodtype = FOODTYPE.GOODIES,
        health = TUNING.HEALING_LARGE,
        hunger = TUNING.CALORIES_MED,
        sanity = TUNING.SANITY_MED,
        perishtime = TUNING.PERISH_FAST,
        cooktime = 1,
        oneat_desc = STRINGS.UI.COOKBOOK.NDNR_FIGPUDDING,
        oneatenfn = function(inst, eater)
			eater:AddDebuff("sweettea_buff", "sweettea_buff")
        end,
    },
	ndnr_kopiluwak = {
        test = function(cooker, names, tags)
			return names.ndnr_catpoop and (names.ndnr_catpoop == 4 or (names.ndnr_catpoop == 3 and (tags.dairy or tags.sweetener)))
		end,
		priority = 50,
		foodtype = FOODTYPE.VEGGIE,
		health = 0,
		hunger = 0,
		perishtime = TUNING.PERISH_MED,
		sanity = -TUNING.SANITY_MED,
		cooktime = 0.5,
        oneat_desc = STRINGS.UI.COOKBOOK.NDNR_KOPILUWAK,
        oneatenfn = function(inst, eater)
            if eater:HasTag("player") and eater.components.debuffable then
                eater.components.debuffable:AddDebuff("ndnr_coffeedebuff", "ndnr_coffeedebuff")
            end
            if eater.components.grogginess ~= nil and
                    not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                    not eater:HasTag("playerghost") then
                eater.components.grogginess:ResetGrogginess()
            end
            eater:AddDebuff("shroomsleepresist", "buff_sleepresistance")
        end
    },
	ndnr_steamedporkdumplings = {
        test = function(cooker, names, tags)
			return (names.carrot or names.carrot_cooked) and tags.egg and tags.meat and names.corn
		end,
		priority = 50,
		foodtype = FOODTYPE.MEAT,
		health = TUNING.HEALING_SMALL,
		hunger = TUNING.CALORIES_LARGE,
		sanity = TUNING.SANITY_TINY,
		perishtime = TUNING.PERISH_FAST,
        stacksize = 2,
		cooktime = 2,
    },
	ndnr_wonton = {
        test = function(cooker, names, tags)
			return tags.meat and tags.frozen and names.kelp_dried and tags.egg
		end,
		priority = 50,
		foodtype = FOODTYPE.MEAT,
		health = TUNING.HEALING_LARGE,
		hunger = TUNING.CALORIES_LARGE,
		sanity = TUNING.SANITY_LARGE,
		perishtime = TUNING.PERISH_SLOW,
		cooktime = 1,
    },
	ndnr_pineapplebun = {
        test = function(cooker, names, tags)
			return names.butter and tags.egg and tags.egg >= 2 and tags.dairy and tags.dairy >= 2
		end,
		priority = 50,
		foodtype = FOODTYPE.GOODIES,
		health = TUNING.HEALING_LARGE,
		hunger = TUNING.CALORIES_LARGE,
		sanity = TUNING.SANITY_TINY,
		perishtime = TUNING.PERISH_PRESERVED,
		cooktime = 1,
    },
	ndnr_puff = {
        test = function(cooker, names, tags)
			return tags.sweetener and tags.egg and tags.dairy and tags.dairy >= 2
		end,
		priority = 50,
		foodtype = FOODTYPE.GOODIES,
		health = TUNING.HEALING_LARGE,
		hunger = TUNING.CALORIES_LARGE,
		sanity = TUNING.SANITY_LARGE,
		perishtime = TUNING.PERISH_FAST,
		cooktime = 1,
    },
	ndnr_creamballsoup = {
        test = function(cooker, names, tags)
			return tags.meat and tags.dairy and not tags.inedible
		end,
		priority = 20,
		foodtype = FOODTYPE.MEAT,
		health = TUNING.HEALING_MED,
		hunger = TUNING.CALORIES_LARGE,
		sanity = TUNING.SANITY_MED,
		perishtime = TUNING.PERISH_MED,
        temperature = TUNING.HOT_FOOD_BONUS_TEMP,
        temperatureduration = TUNING.FOOD_TEMP_BRIEF,
		cooktime = 0.5,
    },
	ndnr_scallopsoup = {
        test = function(cooker, names, tags)
			return tags.frozen and tags.dairy and names.ndnr_scallop and names.ndnr_scallop >= 2
		end,
		priority = 60,
		foodtype = FOODTYPE.MEAT,
		health = TUNING.HEALING_LARGE,
		hunger = TUNING.CALORIES_LARGE,
		sanity = -TUNING.SANITY_TINY,
		perishtime = TUNING.PERISH_MED,
        oneat_desc = STRINGS.UI.COOKBOOK.NDNR_SCALLOPSOUP,
		cooktime = 2,
        oneatenfn = function(inst, eater)
            eater:AddDebuff("buff_moistureimmunity", "buff_moistureimmunity")
       	end,
    },
	ndnr_coconutchicken = {
        test = function(cooker, names, tags)
			return names.ndnr_coconut_halved and names.drumstick and names.drumstick >= 2 and tags.veggie
		end,
		priority = 50,
		foodtype = FOODTYPE.MEAT,
		health = TUNING.HEALING_MED,
		hunger = 60,
		sanity = TUNING.SANITY_TINY,
		perishtime = TUNING.PERISH_FAST,
		cooktime = 2,
    },
	ndnr_balut = {
        test = function(cooker, names, tags)
			return names.tallbirdegg_cracked and names.cutreeds and names.cutreeds >= 3
		end,
        tags = {"ndnr_darkcuisine"},
		priority = 50,
		foodtype = FOODTYPE.MEAT,
		health = TUNING.HEALING_MEDSMALL,
		hunger = TUNING.CALORIES_MED,
		sanity = -TUNING.SANITY_MED,
		perishtime = TUNING.PERISH_PRESERVED,
        oneat_desc = STRINGS.UI.COOKBOOK.NDNR_BALUT,
		cooktime = 1,
    },
	ndnr_stewedmushroom = {
        test = function(cooker, names, tags)
			return names.red_cap and names.red_cap >= 3 and tags.meat
		end,
		priority = 50,
		foodtype = FOODTYPE.MEAT,
		health = -TUNING.HEALING_LARGE,
		hunger = TUNING.CALORIES_LARGE,
		sanity = -TUNING.SANITY_MED,
		perishtime = TUNING.PERISH_MED,
		cooktime = 1,
        oneat_desc = STRINGS.UI.COOKBOOK.NDNR_STEWEDMUSHROOM,
        oneatenfn = function(inst, eater)
            if eater:HasTag("player") and not eater:HasTag("playerghost") then
                if eater.components.sanity ~= nil then
                    eater.components.sanity:SetInducedInsanity("ndnr_stewedmushroom", true)

                    if eater.components.timer then
                        eater.components.timer:StartTimer("ndnr_stewedmushroom", TUNING.TOTAL_DAY_TIME/2)
                    end
                end
            end
       	end,
    },
	ndnr_seatreasure = {
        test = function(cooker, names, tags)
			return (names.wobster_moonglass_land or names.wobster_sheller_land) and tags.fish and tags.fish >= 1 and ((names.ndnr_scallop and names.ndnr_scallop >= 2) or (names.ndnr_scallop_cooked and names.ndnr_scallop_cooked >= 2) or (names.ndnr_scallop and names.ndnr_scallop_cooked))
		end,
		priority = 50,
		foodtype = FOODTYPE.MEAT,
		health = TUNING.HEALING_SUPERHUGE,
		hunger = TUNING.CALORIES_HUGE,
		sanity = TUNING.SANITY_HUGE,
		perishtime = TUNING.PERISH_FAST,
		cooktime = 1,
        oneat_desc = STRINGS.UI.COOKBOOK.NDNR_SEATREASURE,
        oneatenfn = function(inst, eater)

       	end,
    },
	ndnr_caviar =
	{
		test = function(cooker, names, tags) return (tags.ndnr_roe and tags.ndnr_roe >= 3) and tags.veggie end,
		priority = 20,
		foodtype = FOODTYPE.MEAT,
		health = TUNING.HEALING_SMALL,
		hunger = TUNING.CALORIES_SMALL,
		perishtime = TUNING.PERISH_MED,
		sanity = TUNING.SANITY_LARGE,
		cooktime = 2,
	},
	ndnr_albumenpowder =
	{
		test = function(cooker, names, tags) return names.drumstick and names.drumstick >= 4 end,
		priority = 50,
		foodtype = FOODTYPE.GOODIES,
		health = TUNING.HEALING_SMALL,
		hunger = TUNING.CALORIES_LARGE,
		perishtime = nil,
		sanity = TUNING.SANITY_TINY,
		cooktime = 1,
        stacksize = 2,
        oneat_desc = STRINGS.UI.COOKBOOK.NDNR_ALBUMENPOWDER,
        oneatenfn = function(inst, eater)
            if eater.components.mightiness then
                eater:AddDebuff("ndnr_albumenpowderdebuff", "ndnr_albumenpowderdebuff")
            end
        end,
	},
	ndnr_tofu =
	{
		test = function(cooker, names, tags) return names.ash and names.ice and tags.ndnr_soybean and tags.ndnr_soybean == 2 end,
		priority = 50,
		foodtype = FOODTYPE.VEGGIE,
		health = TUNING.HEALING_MEDSMALL,
		hunger = TUNING.CALORIES_LARGE,
		perishtime = TUNING.PERISH_FAST,
		sanity = TUNING.SANITY_TINY,
		cooktime = 1,
		perishreplacement = "ndnr_stinkytofu",
	},
    -- 豆浆
	ndnr_soybeanmilk1 =
	{
		test = function(cooker, names, tags) return names.ndnr_soybeanmeal and names.ice and names.ice == 2 and tags.sweetener end,
		priority = 50,
		foodtype = FOODTYPE.VEGGIE,
		health = TUNING.HEALING_LARGE,
		hunger = TUNING.CALORIES_LARGE,
		perishtime = TUNING.PERISH_FAST,
		sanity = TUNING.SANITY_MEDLARGE,
		cooktime = 0.5,
	},
    -- 豆奶
	ndnr_soybeanmilk2 =
	{
		test = function(cooker, names, tags) return names.ndnr_soybeanmeal and names.ice and tags.sweetener and tags.dairy end,
		priority = 50,
		foodtype = FOODTYPE.VEGGIE,
		health = TUNING.HEALING_LARGE,
		hunger = TUNING.CALORIES_LARGE,
		perishtime = TUNING.PERISH_FAST,
		sanity = TUNING.SANITY_HUGE,
		cooktime = 0.5,
	},
}

local othermodfoods = {
	dish_medicinalliquor = {
        test = function(cooker, names, tags)
            return names.furtuft and tags.frozen and not tags.meat and not tags.sweetener
                and not tags.egg and (tags.inedible and tags.inedible <= 1)
        end,
        priority = 20,
        foodtype = FOODTYPE.GOODIES,
        health = 8,
        hunger = 9.375,
        sanity = 10,
        perishtime = nil,
        tags = {"drink"},
        cooktime = 3,
        oneat_desc = STRINGS.UI.COOKBOOK.DISH_MEDICINALLIQUOR,
        oneatenfn = function(inst, eater)
            if eater:HasTag("player") then
                --说醉酒话
                if eater.components.talker ~= nil then
                    eater.components.talker:Say(TUNING.NDNR_DISH_MEDICINALLIQUOR_DRUNK)
                end

                --加强攻击力
                if eater.components.combat ~= nil then --这个buff需要攻击组件
                    eater.components.debuffable:AddDebuff("buff_strengthenhancerdebuff", "buff_strengthenhancerdebuff")
                end

                local drunkmap = {
                    wathgrithr = 0,
                    wolfgang = 0,
                    wendy = 1,
                    webber = 1,
                    willow = 1,
                    wes = 1,
                    wormwood = 1,
                    wurt = 1,
                    walter = 1,
                    yangjian = 0,
                    yama_commissioners = 0,
                    myth_yutu = 1,
                }
                if drunkmap[eater.prefab] == 0 then --没有任何事
                    return
                elseif drunkmap[eater.prefab] == 1 then --直接睡着8-12秒
                    eater:PushEvent("yawn", { grogginess = 5, knockoutduration = 8+math.random()*4 })
                else --20-28秒内减速
                    if eater.groggy_time ~= nil then
                        eater.groggy_time:Cancel()
                        eater.groggy_time = nil
                    end
                    if eater.components.locomotor ~= nil then
                        eater:AddTag("groggy")  --添加标签，走路会摇摇晃晃
                        eater.components.locomotor:SetExternalSpeedMultiplier(eater, "grogginess", 0.4)

                        eater.groggy_time = eater:DoTaskInTime(20+math.random()*8, function()
                            if eater ~= nil and eater.components.locomotor ~= nil then
                                eater:RemoveTag("groggy")
                                eater.components.locomotor:RemoveExternalSpeedMultiplier(eater, "grogginess")
                                eater.groggy_time = nil
                            end
                        end)
                    end
                end
            elseif eater.components.sleeper ~= nil then
                eater.components.sleeper:AddSleepiness(5, 12+math.random()*4)
            elseif eater.components.grogginess ~= nil then
                eater.components.grogginess:AddGrogginess(5, 12+math.random()*4)
            else
                eater:PushEvent("knockedout")
            end
        end
    },
}

if not TUNING.LEGION_ACTIVE then
    for k, v in pairs(othermodfoods) do
        foods[k] = v
    end
end

for k, v in pairs(foods) do
    v.name = k
    v.weight = v.weight or 1
    v.priority = v.priority or 0

	v.cookbook_category = "cookpot"

    v.potlevel = "low"
    v.overridebuild = "ndnr_cook_pot_food"
    v.ndnr_food = true
end

return foods