local FN = {}

local SKIN_IDS = {}
local SKINS = {}

local function AddSkin(prefab, skin, data)
    SKINS[prefab] = SKINS[prefab] or {}
    SKINS[prefab][skin] = data
    -- GLOBAL.XLog("AddSkin", prefab, skin)
end

----------------------------------------------------------------------------------------------------

AddSkin("tt_spear", "tt_spear_flower", {
    type = "base",                                         --类型，base就行
    rarity = "Elegant",                                    --稀有度，会给皮肤字体加不同颜色
    init_fn = function(inst)                               --皮肤初始化函数
        inst.components.inventoryitem.atlasname = "images/inventoryimages/tt_spear_flower.xml"
        basic_init_fn(inst, "tt_spear_flower", "tt_spear") --prefabskin.lua提供的函数，还挺简便的
    end,
    sort_num = 1,
    clear_fn = function(inst)                              --不再使用该皮肤时
        inst.components.inventoryitem.atlasname = nil
        basic_clear_fn(inst, "tt_spear")
    end

    -- 下面的都是主界面展示用的，不需要
    -- rarity_modifier = "Woven",
    -- skin_tags = { "YULE", "BASE", "WX78", },
    -- bigportrait_anim = { build = "bigportraits/wx78_yule.xml", symbol = "wx78_yule_oval.tex" },
    -- skins = { ghost_skin = "ghost_wx78_build", normal_skin = "wx78_yule", },
    -- feet_cuff_size = { wx78_yule = 3, },
    -- release_group = 82,
})

AddSkin("tt_spear", "tt_spear_black", {
    type = "base",                                         --类型，base就行
    rarity = "Elegant",                                    --稀有度，会给皮肤字体加不同颜色
    sort_num = 2,
    init_fn = function(inst)                               --皮肤初始化函数
        inst.components.inventoryitem.atlasname = "images/inventoryimages/tt_spear_black.xml"
        basic_init_fn(inst, "tt_spear_black", "tt_spear") --prefabskin.lua提供的函数，还挺简便的
        
    end,
    clear_fn = function(inst)                              --不再使用该皮肤时
        inst.components.inventoryitem.atlasname = nil
        basic_clear_fn(inst, "tt_spear")
    end

    -- 下面的都是主界面展示用的，不需要
    -- rarity_modifier = "Woven",
    -- skin_tags = { "YULE", "BASE", "WX78", },
    -- bigportrait_anim = { build = "bigportraits/wx78_yule.xml", symbol = "wx78_yule_oval.tex" },
    -- skins = { ghost_skin = "ghost_wx78_build", normal_skin = "wx78_yule", },
    -- feet_cuff_size = { wx78_yule = 3, },
    -- release_group = 82,
})

----------------------------------------------------------------------------------------------------

for _, skins in pairs(SKINS) do
    for id, data in pairs(skins) do
        SKIN_IDS[id] = data
    end
end

function FN.GetAllSkins()
    return SKINS
end

---是否是自己定义的皮肤
---@param id string
function FN.GetSkinData(id)
    return id and SKIN_IDS[id]
end

return FN
