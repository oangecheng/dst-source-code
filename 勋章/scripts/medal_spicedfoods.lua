require("tuning")

local spicedfoods = {}

local SPICES=require("medal_defs/medal_spice_defs")

--获取新的调味料理配方
local function MedalGetNewRecipes()
    return spicedfoods
end

--生成勋章调味食物
local function MedalGenerateSpicedFoods(foods)
	for foodname, fooddata in pairs(foods) do
        --如果已经调过味了，就跳过(特殊过滤不生成预置物的料理,比如富贵险中求的黄油)
		if not (fooddata.spice or fooddata.notinitprefab) then
            --调料名，调料数据
            for spicename, spicedata in pairs(SPICES) do
                local newdata = shallowcopy(fooddata)--浅拷贝一份料理数据
                -- local spicename = string.lower(spicenameupper)--调料名，变成小写
                local spicenameupper = string.upper(spicename)--调料名，转成大写
                if foodname == "wetgoop" then
                    newdata.test = function(cooker, names, tags) return names[spicename] end
                    newdata.priority = -10
                else
                    newdata.test = function(cooker, names, tags) return names[foodname] and names[spicename] end
                    newdata.priority = 100
                end
                newdata.cooktime = .12--烹饪时间
                newdata.stacksize = nil
                newdata.spice = spicenameupper--调料
                newdata.basename = foodname--基础料理名
                newdata.name = foodname.."_"..spicename--调味后料理名
                newdata.floater = {"med", nil, {0.85, 0.7, 0.85}}--漂浮动画数据
                --修改食物标签
                if spicedata.foodtype then
                    newdata.foodtype = spicedata.foodtype
                end
                spicedfoods[newdata.name] = newdata--表中存入新数据

                if spicedata.prefabs ~= nil then
                    --如果原料理和调料都有Buff，则把buff数组合并，同时拥有两个Buff
                    newdata.prefabs = newdata.prefabs ~= nil and ArrayUnion(newdata.prefabs, spicedata.prefabs) or spicedata.prefabs
                end

                --添加吃料理的函数，如果原料理已经有函数，则合并，如果没有则直接添加
                if spicedata.oneatenfn ~= nil then
                    if newdata.oneatenfn ~= nil then
                        local oneatenfn_old = newdata.oneatenfn
                        newdata.oneatenfn = function(inst, eater, ...)
                            spicedata.oneatenfn(inst, eater, ...)
                            oneatenfn_old(inst, eater, ...)
                        end
                    else
                        newdata.oneatenfn = spicedata.oneatenfn
                    end
                end
            end
        end
    end
end

return {
    spicedfoods = spicedfoods,
    MedalGetNewRecipes = MedalGetNewRecipes,
    MedalGenerateSpicedFoods = MedalGenerateSpicedFoods,
}
