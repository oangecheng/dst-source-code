
local function addfoodbuff(inst, eater,buff)
    if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
        not (eater.components.health ~= nil and eater.components.health:IsDead()) and
        not eater:HasTag("playerghost") then
        eater.components.debuffable:AddDebuff(buff, buff)
    end
end
local function OnTick(inst, target)
    if target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
        target.components.health:DoDelta(0.5, true)
        if target.components.sanity then
            target.components.sanity:DoDelta(0.5, true)
        end
        inst.components.fueled:DoDelta(-1)
    end
end

local  foods = {
    ice_litchi  = {
        test = function(cooker, names, tags)
            return tags.frozen and tags.frozen >= 2 and names.lg_litichi and names.lg_litichi >= 2
        end,
        priority = 115,
        weight = 1,
        foodtype = FOODTYPE.VEGGIE,
        health = 18,
        hunger = 25,
        perishtime = TUNING.LICHEN_REGROW_TIME,
        sanity = 45,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_LONG,
        cooktime = 3/4,
        oneat_desc = "珍馐美馔",

    },

    sashimi  = {
        test = function(cooker, names, tags)
            return tags.fish and tags.fish >= 2 and tags.frozen and tags.frozen >= 1 and names.lg_lemon and names.lg_lemon >= 1
        end,
        priority = 115,
        weight = 1,
        foodtype = FOODTYPE.MEAT,
        health = 15,
        hunger = 60,
        perishtime = TUNING.HAWAIIANSHIRT_PERISHTIME,
        sanity = -5,
        cooktime = 3/4,
        oneat_desc = "珍馐美馔",
        oneatenfn = function(inst, eater)
            addfoodbuff(inst, eater,"sashimi_buff")
        end
    },

    hot_fish  = {
        test = function(cooker, names, tags)
            return tags.fish and tags.fish >= 2 and names.pepper and names.pepper >= 2
        end,
        priority = 115,
        weight = 1,
        foodtype = FOODTYPE.MEAT,
        health = 20,
        hunger = 30,
        perishtime = TUNING.RAINHAT_PERISHTIME,
        sanity = -5,
        cooktime = 6/4,
        oneat_desc = "珍馐美馔",
        oneatenfn = function(inst, eater)
            if eater and eater.components.moisture then
                local per = eater.components.moisture:GetMoisturePercent()
                if per >= 0.99 then
                    if eater.components.hunger then
                        eater.components.hunger:DoDelta(50)
                    end
                elseif per >= 0.75 then
                    if eater.components.hunger then
                        eater.components.hunger:DoDelta(40)
                    end
                elseif per >= 0.50 then
                    if eater.components.hunger then
                        eater.components.hunger:DoDelta(30)
                    end
                elseif per >= 0.25 then
                    if eater.components.hunger then
                        eater.components.hunger:DoDelta(20)
                    end
                end
                eater.components.moisture:SetPercent(0)
            end
            addfoodbuff(inst, eater,"hot_fish_buff")
        end
    },

    lg_rice  = {
        test = function(cooker, names, tags)
            return tags.veggie and tags.veggie >= 3 and names.corn and names.corn >= 2 and not tags.meat and not tags.inedible
        end,
        priority = 115,
        weight = 1,
        foodtype = FOODTYPE.VEGGIE,
        health = 5,
        hunger = 50,
        perishtime = TUNING.UMBRELLA_PERISHTIME,
        sanity = 10,
        cooktime = 6/4,
        oneat_desc = "珍馐美馔",
        oneatenfn = function(inst, eater)
            addfoodbuff(inst, eater,"lg_rice_buff")
        end
    },
    honey_cake  = {
        test = function(cooker, names, tags)
            return names.honey and names.honey >= 1 and names.durian and names.durian >= 2 and names.tallbirdegg and names.tallbirdegg >= 1
        end,
        priority = 115,
        weight = 1,
        foodtype = FOODTYPE.VEGGIE,
        health = -5,
        hunger = 55,
        perishtime = TUNING.UMBRELLA_PERISHTIME*2,
        sanity = 45,
        cooktime = 6/4,
        oneat_desc = "珍馐美馔",
        oneatenfn = function(inst, eater)
            addfoodbuff(inst, eater,"honey_cake_buff")
        end
    },
    lg_fishcake  = {
        test = function(cooker, names, tags)
            return tags.fish and tags.fish >= 3 and tags.magic and tags.magic >= 1
        end,
        priority = 115,
        weight = 1,
        foodtype = FOODTYPE.MEAT,
        health = 60,
        hunger = 120,
        perishtime = TUNING.UMBRELLA_PERISHTIME*2,
        sanity = 40,
        cooktime = 6/4,
        oneat_desc = "珍馐美馔",
        oneatenfn = function(inst, eater)
            addfoodbuff(inst, eater,"lg_fishcake_buff")
        end,
        serverfn = function(inst)
            local eatfunctions = {"GetHunger","GetSanity","GetHealth"}
            for i,v in ipairs(eatfunctions) do
                local old = inst.components.edible[v]
                inst.components.edible[v] = function(self,eater)
                    local old = old(self,eater)
                    if eater and eater.components.debuffable and eater.components.debuffable:HasDebuff("lg_fishcake_buff") then
                        old =  0.2 * old
                    end
                    return old
                end
            end
        end      
    },
    lg_bigmilk  = {
        test = function(cooker, names, tags)
            return names.royal_jelly and names.honey and names.honey == 2 and names.ice
        end,
        priority = 115,
        weight = 1,
        cooktime = 90/20,
        notfood = true,
        nostack = true,
        EQUIPSLOTS = EQUIPSLOTS.NECK or EQUIPSLOTS.BODY,
        onequip = function(inst,owner)
            if not inst.task then
                inst.task = inst:DoPeriodicTask(1, OnTick, nil, owner)
            end
        end,
        onunequip = function(inst,owner)
            if inst.task then
                inst.task:Cancel()
                inst.task = nil
            end         
        end,
        serverfn = function(inst)
            inst:AddComponent("fueled")
            inst.components.fueled:InitializeFuelLevel(240)
            inst.components.fueled:SetDepletedFn(inst.Remove)
            inst.components.equippable.equipslot = EQUIPSLOTS.NECK or EQUIPSLOTS.BODY

        end
    },

    lg_jelly  = {
        test = function(cooker, names, tags)
            return names.mint_l and names.shyerry and names.shyerry == 1 and names.lg_actinine and names.honey
        end,
        priority = 115,
        weight = 1,
        foodtype = FOODTYPE.VEGGIE,
        health = 120,
        hunger = 60,
        perishtime = 8*TUNING.PERISH_ONE_DAY,
        sanity = 100,
        cooktime = 90/20,
        oneatenfn = function(inst, eater)
            if eater.components.grogginess ~= nil and
			not (eater.components.health ~= nil and eater.components.health:IsDead()) and
			not eater:HasTag("playerghost") then
				eater.components.grogginess:ResetGrogginess()
            end

			eater:AddDebuff("shroomsleepresist", "buff_sleepresistance")
        end,
    },

    lg_lemon_jelly  = {
        test = function(cooker, names, tags)
            return names.lg_lemon and names.honey and names.honey == 2 and names.ice
        end,
        priority = 115,
        weight = 1,
        foodtype = FOODTYPE.VEGGIE,
        health = 10,
        hunger = 20,
        perishtime = 10*TUNING.PERISH_ONE_DAY,
        sanity = 60,
        cooktime = 60/20,
    },
    lg_soup  = {
        test = function(cooker, names, tags)
            return  tags.veggie and tags.veggie >= 1 and names.lg_actinine and names.lg_actinine == 2 and names.ice
        end,
        priority = 115,
        weight = 1,
        foodtype = FOODTYPE.VEGGIE,
        health = 30,
        hunger = 75,
        perishtime = 6*TUNING.PERISH_ONE_DAY,
        sanity = 30,
        cooktime = 2,
    },
    lg_dogcake  = {
        test = function(cooker, names, tags)
            return  tags.veggie and tags.veggie >= 1 and tags.meat and tags.meat >= 2 and names.batwing
        end,
        priority = 115,
        weight = 1,
        foodtype = FOODTYPE.MEAT,
        health = 1,
        hunger = 52,
        perishtime = 6*TUNING.PERISH_ONE_DAY,
        sanity = 1,
        cooktime = 4/6,
        oneat_desc = "七夕限定",
        oneatenfn = function(inst, eater)
            addfoodbuff(inst, eater,"lg_dogcake_buff")
        end
    },
}


for k, v in pairs(foods) do
    v.name = k
    v.weight = v.weight or 1
    v.priority = v.priority or 0
    v.cookbook_category = "cookpot"
    v.oneat_desc = v.oneat_desc or nil
end
local spicedfoods = {}
local function oneaten_garlic(inst, eater)
    if
        eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
            not (eater.components.health ~= nil and eater.components.health:IsDead()) and
            not eater:HasTag("playerghost")
     then
        eater.components.debuffable:AddDebuff("buff_playerabsorption", "buff_playerabsorption")
    end
end

local function oneaten_sugar(inst, eater)
    if
        eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
            not (eater.components.health ~= nil and eater.components.health:IsDead()) and
            not eater:HasTag("playerghost")
     then
        eater.components.debuffable:AddDebuff("buff_workeffectiveness", "buff_workeffectiveness")
    end
end

local function oneaten_chili(inst, eater)
    if
        eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
            not (eater.components.health ~= nil and eater.components.health:IsDead()) and
            not eater:HasTag("playerghost")
     then
        eater.components.debuffable:AddDebuff("buff_attack", "buff_attack")
    end
end

local SPICES = {
    SPICE_GARLIC = {oneatenfn = oneaten_garlic, prefabs = {"buff_playerabsorption"}},
    SPICE_SUGAR = {oneatenfn = oneaten_sugar, prefabs = {"buff_workeffectiveness"}},
    SPICE_CHILI = {oneatenfn = oneaten_chili, prefabs = {"buff_attack"}},
    SPICE_SALT = {}
}

local function GenerateSpicedFoods(foods, spicedfoods)
    for foodname, fooddata in pairs(foods) do
        for spicenameupper, spicedata in pairs(SPICES) do
            local newdata = shallowcopy(fooddata)
            local spicename = string.lower(spicenameupper)
            if foodname == "wetgoop" then
                newdata.test = function(cooker, names, tags)
                    return names[spicename]
                end
                newdata.priority = -10
            else
                newdata.test = function(cooker, names, tags)
                    return names[foodname] and names[spicename]
                end
                newdata.priority = 100
            end
            newdata.cooktime = .12
            newdata.stacksize = nil
            newdata.spice = spicenameupper
            newdata.basename = foodname
            newdata.name = foodname .. "_" .. spicename
            spicedfoods[newdata.name] = newdata

            if spicename == "spice_chili" then
                if newdata.temperature == nil then
                    --Add permanent "heat" to regular food
                    newdata.temperature = TUNING.HOT_FOOD_BONUS_TEMP
                    newdata.temperatureduration = TUNING.FOOD_TEMP_LONG
                    newdata.nochill = true
                elseif newdata.temperature > 0 then
                    --Upgarde "hot" food to permanent heat
                    newdata.temperatureduration = math.max(newdata.temperatureduration, TUNING.FOOD_TEMP_LONG)
                    newdata.nochill = true
                end
            end

            if spicedata.prefabs ~= nil then
                newdata.prefabs =
                    newdata.prefabs ~= nil and ArrayUnion(newdata.prefabs, spicedata.prefabs) or spicedata.prefabs
            end

            if spicedata.oneatenfn ~= nil then
                if newdata.oneatenfn ~= nil then
                    local oneatenfn_old = newdata.oneatenfn
                    newdata.oneatenfn = function(inst, eater)
                        spicedata.oneatenfn(inst, eater)
                        oneatenfn_old(inst, eater)
                    end
                else
                    newdata.oneatenfn = spicedata.oneatenfn
                end
            end
        end
    end
end
GenerateSpicedFoods(foods, spicedfoods)

GLOBAL.YUZAI_PREPARED_FOODS = foods
GLOBAL.YUZAI_SPICED_FOODS = spicedfoods
for k, recipe in pairs(foods) do
    if recipe.cookpot then
        AddCookerRecipe(recipe.cookpot, recipe)
    else
        AddCookerRecipe("cookpot", recipe)
        AddCookerRecipe("portablecookpot", recipe)
    end
    recipe.cookbook_tex = "cookbook_" .. k .. ".tex"
    recipe.cookbook_atlas = "images/cookbook/cookbook_" .. k .. ".xml"
    RegisterInventoryItemAtlas("images/inventoryimages/"..k..".xml", k..".tex")
end
for k, recipe in pairs(spicedfoods) do
    AddCookerRecipe("portablespicer", recipe)
end

local laterfn = {}
function AddLaterFn(fn)
	if fn and type(fn) == "function" then
		table.insert(laterfn,fn)
	end
end
local function trytofuckcookpot() --大哥你要是不会获取路径的话 我自己来 绕那么多圈子干嘛 有毒毒
	if softresolvefilepath("scripts/cookingpots.lua") then 
		if softresolvefilepath("scripts/widgets/fooditem.lua") then
			local info = require("widgets/fooditem")
            local old_DefineAssetData  = info.DefineAssetData
			info.DefineAssetData = function(self)
                if self.prefab and foods[self.prefab] then
                    self.item_tex, self.atlas, self.localized_name = self.prefab..".tex","images/inventoryimages/"..self.prefab..".xml",STRINGS.NAMES[string.upper(self.prefab)] or self.prefab
                    return
                end
				return old_DefineAssetData(self)	
			end
		end
	end
end
AddLaterFn(trytofuckcookpot)
local oldTranslateStringTable = GLOBAL.TranslateStringTable
GLOBAL.TranslateStringTable = function(...)
	for k,v in pairs(laterfn) do
		if v  and type(v) == "function" then
			v()
		end
	end
	return oldTranslateStringTable(...)
end
AddIngredientValues({"lg_litichi"}, {fruit=1},true)
AddIngredientValues({"lg_lemon"}, {fruit=1},true)
AddIngredientValues({"lg_actinine"},{fish=0.5,meat=0.5},true)
for k,v in pairs(TUNING.LG_FRUIT_CANDRIED) do
    if string.find(k,"dried") then
        AddIngredientValues({k}, {fruit=0.5}) 
    end
end