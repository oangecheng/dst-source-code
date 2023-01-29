
--BUFF 来自富贵险中求
local BuffTime = require "widgets/legend_bufftime"
AddClassPostConstruct("widgets/controls", function(self, owner)

    local scale = TheFrontEnd:GetHUDScale()
    self.legend_bufftime = self:AddChild(BuffTime(self.owner))
    self.legend_bufftime:SetScaleMode(SCALEMODE_PROPORTIONAL)
    self.legend_bufftime:SetHAnchor(ANCHOR_LEFT)
    self.legend_bufftime:SetVAnchor(ANCHOR_BOTTOM)
    self.legend_bufftime:SetMaxPropUpscale(MAX_HUD_SCALE)
    self.legend_bufftime:SetPosition(50*scale, 210*scale)

    local _SetHUDSize = self.SetHUDSize
    function self:SetHUDSize()
        if self.legend_bufftime then
            local scale = TheFrontEnd:GetHUDScale()
            self.legend_bufftime:SetScale(scale)
            self.legend_bufftime:SetPosition(50*scale, 210*scale)
        end
        _SetHUDSize(self)
    end

end)
TUNING.LEGEND_BUFFTIMES = {
    buff_workeffectiveness = {name = "workeffectiveness", symbol = "swap_spice", overridebuild = "spices", overridesymbol = "spice_sugar", bank = "spices", build = "spices", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = 0}, time = TUNING.BUFF_WORKEFFECTIVENESS_DURATION},
    buff_attack = {name = "attack", symbol = "swap_spice", overridebuild = "spices", overridesymbol = "spice_chili", bank = "spices", build = "spices", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = 5}, time = TUNING.BUFF_ATTACK_DURATION},
    buff_playerabsorption = {name = "playerabsorption", symbol = "swap_spice", overridebuild = "spices", overridesymbol = "spice_garlic", bank = "spices", build = "spices", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = 0}, time = TUNING.BUFF_PLAYERABSORPTION_DURATION},
    buff_moistureimmunity = {name = "moistureimmunity", overridesymbol = "frogfishbowl", bank = "cook_pot_food", build = "cook_pot_food", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = 0}, time = TUNING.BUFF_MOISTUREIMMUNITY_DURATION},
    buff_electricattack = {name = "electricattack", overridesymbol = "voltgoatjelly", bank = "cook_pot_food", build = "cook_pot_food", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = 3}, time = TUNING.BUFF_ELECTRICATTACK_DURATION},
    shroomsleepresist = {name = "shroomsleepresist", overridesymbol = "shroomcake", overridebuild = "cook_pot_food6", bank = "cook_pot_food", build = "cook_pot_food", animation = "idle", loop = false, scale = 0.2, offset = {x = 0, y = 0}, time = TUNING.SLEEPRESISTBUFF_TIME},
    ndnr_poisondebuff = {name = "snake", bank = "snake", build = "snake_yellow_build", animation = "idle", loop = true, scale = 0.2, offset = {x = 0, y = 0}, time = TUNING.TOTAL_DAY_TIME * 3},
    ndnr_coffeedebuff = {name = "coffee", bank = "cook_pot_food", build = "ndnr_cook_pot_food", overridesymbol = "ndnr_coffee", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = 0}, time = TUNING.TOTAL_DAY_TIME/2},
    ndnr_dragoonheartdebuff = {name = "dragoonheart", bank = "dragoon_heart", build = "dragoon_heart", animation = "idle", loop = true, scale = 0.3, offset = {x = 0, y = 0}, time = TUNING.TOTAL_DAY_TIME/2},
    ndnr_dragoonheartlavaeggdebuff = {name = "dragoonheartlavaeegg", bank = "cook_pot_food", build = "ndnr_cook_pot_food", overridesymbol = "ndnr_dragoonheartlavaeegg", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = 0}, time = TUNING.TOTAL_DAY_TIME/2},
    ndnr_snakeoildebuff = {name = "snakeoil", bank = "snakeoil", build = "snakeoil", animation = "idle", loop = false, scale = 0.4, offset = {x = 0, y = -8}, time = TUNING.TOTAL_DAY_TIME},
    ndnr_badmilkdebuff = {name = "badmilk", bank = "badstomach", build = "badstomach", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = -8}, time = TUNING.TOTAL_DAY_TIME},
    ndnr_tentacleblooddebuff = {name = "ndnr_tentacleblood", bank = "ndnr_tentacleblood", build = "ndnr_tentacleblood", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = 9}, time = TUNING.TOTAL_DAY_TIME},
    buff_strengthenhancerdebuff = {name = "ndnr_buff_strengthenhancer", bank = "dish_medicinalliquor", build = "dish_medicinalliquor", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = -6}, time = TUNING.TOTAL_DAY_TIME},
    buff_strengthenhancer = {name = "buff_strengthenhancer", bank = "dish_medicinalliquor", build = "dish_medicinalliquor", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = -6}, time = TUNING.TOTAL_DAY_TIME},
    ndnr_snakewinedebuff = {name = "ndnr_snakewine", bank = "cook_pot_food", build = "ndnr_cook_pot_food", overridesymbol = "ndnr_snakewine", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = -3}, time = TUNING.TOTAL_DAY_TIME/2},
    ndnr_bloodoverdebuff = {name = "ndnr_bloodover", bank = "catcoon", build = "catcoon_build", animation = "idle_loop", loop = true, scale = 0.2, offset = {x = 10, y = -6}, time = 40},
    ndnr_beepoisondebuff = {name = "ndnr_beepoison", bank = "ndnr_bee", build = "ndnr_bee_angry_build", animation = "idle", loop = true, scale = 0.4, offset = {x = 7, y = -20}, time = 40},
    ndnr_butterdebuff = {name = "ndnr_butter", bank = "butter", build = "butter", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = 5}, time = TUNING.TOTAL_DAY_TIME},
    ndnr_albumenpowderdebuff = {name = "albumenpowder", bank = "cook_pot_food", build = "ndnr_cook_pot_food", overridesymbol = "ndnr_albumenpowder", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = 0}, time = TUNING.TOTAL_DAY_TIME/2},
    
    sashimi_buff =  {name = "sashimi_buff", bank = "sashimi", build = "sashimi", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = 0}, time = 240},
    hot_fish_buff =  {name = "hot_fish_buff", bank = "hot_fish", build = "hot_fish", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = 0}, time = 720},
    lg_rice_buff =  {name = "lg_rice_buff", bank = "lg_rice", build = "lg_rice", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = 0}, time = 480},
    honey_cake_buff =  {name = "honey_cake_buff", bank = "honey_cake", build = "honey_cake", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = 0}, time = 180},
    lg_fishcake_buff =  {name = "honey_cake_buff", bank = "lg_fishcake", build = "lg_fishcake", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = -2}, time = 240},
    lg_icefish_buff =  {name = "lg_icefish_buff", bank = "lg_icefish", build = "lg_icefish", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = -2}, time = 960},
    lg_springfish_buff =  {name = "lg_springfish_buff", bank = "lg_springfish", build = "lg_springfish", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = -2}, time = 960},
    lg_dogcake_buff =  {name = "lg_dogcake_buff", bank = "lg_dogcake", build = "lg_dogcake", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = -2}, time = 120},
}

AddClassPostConstruct("components/debuffable", function(self, inst)
    local _AddDebuff = self.AddDebuff
    function self:AddDebuff(name, prefab, data)
        local buff = _AddDebuff(self, name, prefab, data)
        if self.inst.components.legend_bufftime then
            if TUNING.LEGEND_BUFFTIMES[name] ~= nil then
                local bufftime = shallowcopy(TUNING.LEGEND_BUFFTIMES[name])
                bufftime.buffname = name
                self.inst.components.legend_bufftime:SetItem(bufftime)
            end
        end
        return buff
    end
    local _RemoveDebuff = self.RemoveDebuff
    function self:RemoveDebuff(name)
        _RemoveDebuff(self, name)
        if self.inst.components.legend_bufftime then
            if TUNING.LEGEND_BUFFTIMES[name] ~= nil then
                self.inst.components.legend_bufftime:RemoveItem(TUNING.LEGEND_BUFFTIMES[name].name)
            end
        end
    end
end)
AddReplicableComponent("legend_bufftime")
AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then
        return
    end
	if not inst.components.legend_bufftime then
		inst:AddComponent("legend_bufftime")
	end
    if not inst.components.legend_girlfishspawn then
        inst:AddComponent("legend_girlfishspawn")
    end
    inst.components.legend_girlfishspawn:SetPlayer()
end)