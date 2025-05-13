--[[
--@author: 绯世行
--欢迎其他开发者直接使用，但是强烈谴责搬用代码后对搬用代码加密的行为！

每个皮肤要做的：
1. 有名字，描述可要可不要，注意名字要小写，皮肤命名一般是预制件后追加皮肤名
-- 示例：
-- STRINGS.SKIN_NAMES.mami_calidaumbra_flower = "灯花的伞"
-- STRINGS.SKIN_DESCRIPTIONS.mami_calidaumbra_flower = "上等的好皮肤啊。"

2. 有64*64贴图，用于制作栏或物品栏；动画zip文件，虽然可要可不要，但我想每个皮肤应该都一个独立的动画包吧，贴图和动画默认都和皮肤名一致

3. 每个皮肤有自己的预制件，虽然我们自己的不生成，但一定得有，储存皮肤的一些信息和初始化操作，我把皮肤的基本信息和初始化操作
写在xxx_skinutils.lua里，把皮肤预制件写在xxx_skinprefabs.lua里

4. 一般流程是皮肤的初始化操作写在init_fn，移除皮肤操作写在clear_fn，当换上或移除皮肤时更新一下外观或者其他属性，也就是说重要逻辑都在xxx_skinutils.lua里

]]

local PRE = "tt_" --你自己的mod前缀

local SkinUtils = require(PRE .. "skinutils")

table.insert(PrefabFiles, PRE .. "skinprefabs")

for prefab, skins in pairs(SkinUtils.GetAllSkins()) do
    local d = PREFAB_SKINS[prefab]
    if not d then
        d = {}
        PREFAB_SKINS[prefab] = d
    end
    for name, _ in pairs(skins) do
        --用于制作栏或者物品栏的皮肤图片
        -- GLOBAL.XLog("resgistSkin 2", prefab, name)
        table.insert(Assets, Asset("ATLAS", "images/inventoryimages/" .. name .. ".xml"))
        env.RegisterInventoryItemAtlas("images/inventoryimages/" .. name .. ".xml", name .. ".tex")
        table.insert(Assets, Asset("ANIM", "anim/" .. name .. ".zip")) --动画，应该都有对应的动画文件吧

        print("orangeLog register".."  "..tostring(name).. "  p="..tostring(prefab))

        table.insert(d, name)

        assert(STRINGS.SKIN_NAMES[name], "你应该为每个皮肤设置一个名字，皮肤 " .. name .. " 没有名字")
    end
end

-- 重新设置一遍索引
for prefab, skins in pairs(PREFAB_SKINS) do
    PREFAB_SKINS_IDS[prefab] = {}
    for k, v in pairs(skins) do
        PREFAB_SKINS_IDS[prefab][v] = k
    end

end

local OldCheckOwnershipGetLatest = getmetatable(TheInventory).__index["CheckOwnershipGetLatest"]
getmetatable(TheInventory).__index["CheckOwnershipGetLatest"] = function(self, item_type, ...)
    if SkinUtils.GetSkinData(item_type) then
        return true, 0 --第二个参数可能和皮肤的获取时间有关，还不清楚具体效果
    end

    return OldCheckOwnershipGetLatest(self, item_type, ...)
end

local OldCheckClientOwnership = getmetatable(TheInventory).__index["CheckClientOwnership"]
getmetatable(TheInventory).__index["CheckClientOwnership"] = function(self, user_id, skin, ...)
    print("orangeLog  CheckClientOwnership 1".. tostring(skin))
    if SkinUtils.GetSkinData(skin) then
        print("orangeLog  CheckClientOwnership 2 ".. tostring(skin))
        return true
    end
    return OldCheckClientOwnership(self, user_id, skin, ...)
end

--- 自己的皮肤科雷不管，只能自己初始化了
local function InitSkin(ent, skin, skin_id)
    
    local id = skin_id or PREFAB_SKINS_IDS[ent.prefab] and PREFAB_SKINS_IDS[ent.prefab][skin]
    ent.skinname = skin
    ent.skin_id = id
    local d = SkinUtils.GetSkinData(skin)
    if d then
        if d.init_fn then
            d.init_fn(ent)
        end
    end

end

local OldSpawnPrefab = SpawnPrefab
GLOBAL.SpawnPrefab = function(name, skin, skin_id, ...)
    local ent = OldSpawnPrefab(name, skin, skin_id, ...)
    if ent then
        InitSkin(ent, skin, skin_id)
    end
    return ent
end



-- 清洁扫把扫皮肤后
local OldReskinEntity = getmetatable(TheSim).__index["ReskinEntity"]
getmetatable(TheSim).__index["ReskinEntity"] = function(self, guid, skinname, linked_skinname, skin_id, userid, ...)
    local inst = Ents[guid]
    if inst and skinname ~= linked_skinname then
        local d = SkinUtils.GetSkinData(skinname)
        if d and d.clear_fn then
            d.clear_fn(inst)
        end
        InitSkin(inst, linked_skinname, skin_id)
    end

    OldReskinEntity(self, guid, skinname, linked_skinname, skin_id, userid, ...)
    inst.skinname = linked_skinname
end
