local containers = require "containers"
local cooking = require("cooking")
local params = containers.params

params.lg_granary =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_fish_box_3x4",
        animbuild = "ui_lg_granary_4x4",
        pos = Vector3(0, 220, 0),
        side_align_tip = 160,
    },
    type = "chest",
}

for y = 2.5, -0.5, -1 do
    for x = -0.5, 2.5 do
        table.insert(params.lg_granary.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
    end
end

function params.lg_granary.itemtestfn(container, item, slot)
    return  cooking.ingredients[item.prefab] ~= nil and 
        (cooking.ingredients[item.prefab].tags["veggie"] ~= nil or 
        cooking.ingredients[item.prefab].tags["fruit"] ~= nil)
end


TUNING.LG_FRUIT_DRIED = { --可以做成果干的物品 三维和保质期也在这里
    --饥饿 脑残 血量 保质期
    lg_lemon = { -- 柠檬
    8, 10, 10, 45 * TUNING.PERISH_ONE_DAY},
    lg_litichi = { -- 荔枝
    9.4, 10, 10, 45 * TUNING.PERISH_ONE_DAY},
    dragonfruit = { -- 火龙果
    15, 10, 10, 45 * TUNING.PERISH_ONE_DAY},
    pomegranate = { -- 石榴
    12.5, 10, 10, 45 * TUNING.PERISH_ONE_DAY},
    durian = { -- 榴莲
    28.8, 10, 10, 45 * TUNING.PERISH_ONE_DAY},
    watermelon = { -- 西瓜
    15, 10, 10, 45 * TUNING.PERISH_ONE_DAY},
    cave_banana = { -- 香蕉
    15, 10, 10, 45 * TUNING.PERISH_ONE_DAY},
    berries = { -- 浆果
    15, 10, 10, 45 * TUNING.PERISH_ONE_DAY}
    --[[
    corn = { -- 玉米
    },
    onion = { -- 洋葱
    },

    garlic = { -- 大蒜
    },
    tomato = { -- 番茄
    },
    pumpkin = { -- 南瓜
    },
    pepper = { -- 辣椒
    },
    carrot = { -- 胡萝卜
    },
    eggplant = { -- 茄子
    },
    asparagus = { -- 芦笋
    },
    potato = { -- 土豆
    },]]--
}
TUNING.LG_FRUIT_CANDRIED = {}
for k, v in pairs(TUNING.LG_FRUIT_DRIED) do
    TUNING.LG_FRUIT_CANDRIED[k] = true
    TUNING.LG_FRUIT_CANDRIED[string.find(k,"lg") and k.."_dried" or "lg_"..k.."_dried"] = true
end
params.lg_fruit_rack =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_chest_3x3",
        animbuild = "ui_chest_3x3",
        pos = Vector3(0, 200, 0),
        side_align_tip = 160,
    },
    type = "chest",
}

for y = 2, 0, -1 do
    for x = 0, 2 do
        table.insert(params.lg_fruit_rack.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
    end
end

function params.lg_fruit_rack.itemtestfn(container, item, slot)
    return  TUNING.LG_FRUIT_CANDRIED[item.prefab]
end

for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end