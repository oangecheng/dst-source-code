GLOBAL.setmetatable(
    env,
    {
        __index = function(t, k)
            return GLOBAL.rawget(GLOBAL, k)
        end
    }
)

PrefabFiles = {
    "wing_backpack"
}

Assets = {
    Asset("IMAGE", "images/inventoryimages/cbdz0.tex"),
    Asset("ATLAS", "images/inventoryimages/cbdz0.xml"),
    Asset("IMAGE", "images/inventoryimages/cbdz1.tex"),
    Asset("ATLAS", "images/inventoryimages/cbdz1.xml"),
    Asset("IMAGE", "images/inventoryimages/cbdz2.tex"),
    Asset("ATLAS", "images/inventoryimages/cbdz2.xml"),
    Asset("IMAGE", "images/inventoryimages/cbdz3.tex"),
    Asset("ATLAS", "images/inventoryimages/cbdz3.xml"),
    Asset("IMAGE", "images/inventoryimages/cbdz4.tex"),
    Asset("ATLAS", "images/inventoryimages/cbdz4.xml"),
    Asset("IMAGE", "images/inventoryimages/cbdz5.tex"),
    Asset("ATLAS", "images/inventoryimages/cbdz5.xml"),
    Asset("IMAGE", "images/inventoryimages/cbdz6.tex"),
    Asset("ATLAS", "images/inventoryimages/cbdz6.xml"),
    Asset("IMAGE", "images/inventoryimages/cbdz7.tex"),
    Asset("ATLAS", "images/inventoryimages/cbdz7.xml"),
    Asset("IMAGE", "images/inventoryimages/cbdz8.tex"),
    Asset("ATLAS", "images/inventoryimages/cbdz8.xml")
}

STRINGS.NAMES.CBDZ0 = "恶魔之翼"
STRINGS.RECIPE_DESC.CBDZ0 = "来自地狱的访问"
STRINGS.NAMES.CBDZ1 = "信仰之翼"
STRINGS.RECIPE_DESC.CBDZ1 = "历经朴素和时光"
STRINGS.NAMES.CBDZ2 = "炎热之火"
STRINGS.RECIPE_DESC.CBDZ2 = "如岩浆一样沸腾"
STRINGS.NAMES.CBDZ3 = "电光飞驰"
STRINGS.RECIPE_DESC.CBDZ3 = "紫色的闪电"
STRINGS.NAMES.CBDZ4 = "湛蓝天空"
STRINGS.RECIPE_DESC.CBDZ4 = "美的就像蓝天白云"
STRINGS.NAMES.CBDZ5 = "炎魔之翼"
STRINGS.RECIPE_DESC.CBDZ5 = "这是属于炎魔的翅膀"
STRINGS.NAMES.CBDZ6 = "魅惑之光"
STRINGS.RECIPE_DESC.CBDZ6 = "闪耀着，吸引着人们"
STRINGS.NAMES.CBDZ7 = "阿波罗"
STRINGS.RECIPE_DESC.CBDZ7 = "太阳神的翅膀"
STRINGS.NAMES.CBDZ8 = "紫蝶"
STRINGS.RECIPE_DESC.CBDZ8 = "他是蝴蝶翅膀的形状"

for i = 0, 8 do
    --注册背包prefab的图片对应
    RegisterInventoryItemAtlas(("images/inventoryimages/cbdz%d.xml"):format(i), ("cbdz%d.tex"):format(i))
end

local containers = require "containers"
local params = containers.params

local sack_slotpos = {}
for y = 0, 6 do
    table.insert(sack_slotpos, Vector3(-108 - 75, -75 * y + 226, 0))
    table.insert(sack_slotpos, Vector3(-108, -75 * y + 226, 0))
    table.insert(sack_slotpos, Vector3(-108 + 75, -75 * y + 226, 0))
end

local function MakeSack(name)
    local container = {
        widget = {
            slotpos = sack_slotpos,
            animbank = "ui_krampusbag_2x8",
            animbuild = "ui_cbdz" .. name,
            pos = Vector3(-30, -100, 0)
        },
        issidewidget = true,
        type = "pack",
        openlimit = 1
    }
    return container
end

for i = 0, 8 do
    local p = "cbdz" .. i
    params[p] = MakeSack(i)
end

for _, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end
