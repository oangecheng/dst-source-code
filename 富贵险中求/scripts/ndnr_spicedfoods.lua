require("tuning")

local spicedfoods = {}

local function oneaten_garlic(inst, eater)
    eater:AddDebuff("buff_playerabsorption", "buff_playerabsorption")
end

local function oneaten_sugar(inst, eater)
    eater:AddDebuff("buff_workeffectiveness", "buff_workeffectiveness")
end

local function oneaten_chili(inst, eater)
    eater:AddDebuff("buff_attack", "buff_attack")
end

local SPICES =
{
    SPICE_GARLIC = { oneatenfn = oneaten_garlic, prefabs = { "buff_playerabsorption" } },
    SPICE_SUGAR  = { oneatenfn = oneaten_sugar, prefabs = { "buff_workeffectiveness" } },
    SPICE_CHILI  = { oneatenfn = oneaten_chili, prefabs = { "buff_attack" } },
    SPICE_SALT   = {},
    ----------------------------------------------------------
    --[[
        扩展调味
        命名：
            必须要以 NDNR_ 开头
        需要准备的素材：
            官方的 spices.zip 解包，处理两张贴图
            在背包里的一张贴图(ndnr_spice_smelly.tex)
            以及与食物一起展示的贴图(ndnr_spice_smelly_over.tex)
    ]]
    NDNR_SPICE_SMELLY   = {},
}

function GenerateSpicedFoods(foods)
    for foodname, fooddata in pairs(foods) do
        if fooddata.notinitprefab == nil then
            for spicenameupper, spicedata in pairs(SPICES) do
                local spicename = string.lower(spicenameupper)
                local ndnr_spice = string.sub(spicename, 1, 4) == "ndnr" and true or false
                if (fooddata.ndnr_food == nil and ndnr_spice) or fooddata.ndnr_food then
                    local newdata = shallowcopy(fooddata)
                    if foodname == "wetgoop" then
                        newdata.test = function(cooker, names, tags) return names[spicename] end
                        newdata.priority = -10
                    else
                        newdata.test = function(cooker, names, tags) return names[foodname] and names[spicename] end
                        newdata.priority = 100
                    end
                    newdata.cooktime = .12
                    newdata.stacksize = nil
                    newdata.spice = spicenameupper
                    newdata.basename = foodname
                    newdata.name = foodname.."_"..spicename
                    newdata.floater = {"med", nil, {0.85, 0.7, 0.85}}
                    newdata.official = not ndnr_spice
                    newdata.cookbook_category = fooddata.cookbook_category ~= nil and ("spiced_"..fooddata.cookbook_category) or nil
                    --富贵中的调味品特殊处理
                    newdata.ndnrspiceoverridebuildname = ndnr_spice and "ndnr_spices" or nil
                    ----------------------
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
                        --make a copy (via ArrayUnion) if there are dependencies from the original food
                        newdata.prefabs = newdata.prefabs ~= nil and ArrayUnion(newdata.prefabs, spicedata.prefabs) or spicedata.prefabs
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
    end
end

GenerateSpicedFoods(require("preparedfoods"))
GenerateSpicedFoods(require("preparedfoods_warly"))
GenerateSpicedFoods(require("ndnr_preparedfoods"))

return spicedfoods
