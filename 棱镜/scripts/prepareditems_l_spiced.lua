require("tuning")

local foods_spiced = {}

local SPICES = {
    SPICE_GARLIC = true,
    SPICE_SUGAR  = true,
    SPICE_CHILI  = true,
    SPICE_SALT   = true,

    --兼容勋章的香料
    SPICE_VOLTJELLY = true,
    SPICE_PHOSPHOR = true,
    SPICE_CACTUS_FLOWER = true,
    SPICE_RAGE_BLOOD_SUGAR = true,
    SPICE_POTATO_STARCH = true
}

local function GenerateSpicedFoods(foods)
    for foodname, fooddata in pairs(foods) do
        for spicenameupper, spicedata in pairs(SPICES) do
            local newdata = shallowcopy(fooddata)
            local spicename = string.lower(spicenameupper)
            newdata.test = function(cooker, names, tags) return names[foodname] and names[spicename] end
            newdata.priority = 100
            newdata.cooktime = .12
            newdata.stacksize = nil
            newdata.spice = spicenameupper
            newdata.basename = foodname
            newdata.name = foodname.."_"..spicename

            --这两个设置应该没用吧
            -- newdata.official = true
			-- newdata.cookbook_category = fooddata.cookbook_category ~= nil and ("spiced_"..fooddata.cookbook_category) or nil

            ------------

            if newdata.float ~= nil then --原本就会沉的料理，即使加了调料一样会沉
                newdata.float = {nil, "med", 0.05, {0.8, 0.7, 0.8}}
            end
            foods_spiced[newdata.name] = newdata
        end
    end
end

GenerateSpicedFoods(require("prepareditems_legion"))

return foods_spiced
