-- 遗失塑料袋
local medal_losswetpouch = {
    medal_losswetpouch1 = { -- 池塘
        loottable = { -- 默认掉落表
            {key="medal_treasure_map_scraps1",weight=25},-- 藏宝图碎片·日出
            {key="trinket_1",weight=14},-- 熔化的弹珠
            {key="trinket_8",weight=14},-- 硬化橡胶塞
            {key="spoiled_fish_small",weight=10},-- 腐烂的小鱼
            {key="driftwood_log",weight=5},-- 浮木
            {key="seeds",weight=5},-- 种子
            {key="froglegs",weight=7},-- 蛙腿
            {key="goose_feather",weight=4},-- 鸭毛
            {key="silk",weight=10},-- 蜘蛛丝
            {key="beefalowool",weight=5},-- 牛毛
            {key="lureplantbulb",weight=1},-- 食人花种子
        }
    },
    medal_losswetpouch2 = { -- 沼泽
        loottable = { -- 默认掉落表
            {key="medal_treasure_map_scraps2",weight=25},-- 藏宝图碎片·黄昏
            {key="trinket_1",weight=14},-- 熔化的弹珠
            {key="trinket_12",weight=14},-- 干瘪的触手
            {key="spoiled_fish_small",weight=10},-- 腐烂的小鱼
            {key="driftwood_log",weight=5},-- 浮木
            {key="seeds",weight=5},-- 种子
            {key="mosquitosack",weight=7},-- 蚊子血囊
            {key="tentaclespots",weight=4},-- 触手皮
            {key="silk",weight=10},-- 蜘蛛丝
            {key="beefalowool",weight=5},-- 牛毛
            {key="spice_blood_sugar",weight=1},-- 血糖
        }
    },
    medal_losswetpouch3 = { -- 洞穴
        loottable = { -- 默认掉落表
            {key="medal_treasure_map_scraps3",weight=25},-- 藏宝图碎片·夜晚
            {key="trinket_1",weight=14},-- 熔化的弹珠
            {key="trinket_6",weight=14},-- 烂电线
            {key="spoiled_fish",weight=10},-- 腐烂的鱼
            {key="driftwood_log",weight=5},-- 浮木
            {key="seeds",weight=5},-- 种子
            {key="thulecite_pieces",weight=6},-- 铥矿碎片
            {key="manrabbit_tail",weight=4},-- 兔毛
            {key="silk",weight=10},-- 蜘蛛丝
            {key="batwing",weight=5},-- 蝙蝠翅膀
            {key="fossil_piece",weight=2},-- 化石碎片
        }
    },
    medal_losswetpouch4 = { -- 海洋
        loottable = { -- 默认掉落表
            {key="medal_treasure_map_scraps1",weight=10},-- 藏宝图碎片·日出
            {key="medal_treasure_map_scraps2",weight=10},-- 藏宝图碎片·黄昏
            {key="medal_treasure_map_scraps3",weight=10},-- 藏宝图碎片·夜晚
            {key="messagebottleempty",weight=12},-- 空瓶子
            {key="medal_fishbones",weight=20},-- 鱼骨
            {key="trinket_17",weight=10},-- 弯曲的叉子
            {key="moonglass",weight=15},-- 月光玻璃
            {key="waterplant_bomb",weight=8},-- 种壳
            {key="cookiecuttershell",weight=4.9},-- 饼干切割机壳
            {key="dug_trap_starfish",weight=0.1},-- 海星陷阱
        },
        printtable = { -- 蓝图掉落表
            {key="medal_coldfirepit_obsidian",weight=10},-- 蓝曜石火坑
            {key="armor_blue_crystal",weight=5},-- 蓝曜石甲
        }
    },
    medal_losswetpouch5 = { -- 岩浆
        loottable = { -- 默认掉落表
            {key="charcoal",weight=18},-- 木炭
            {key="trinket_1",weight=15},-- 熔化的弹珠
            {key="rocks",weight=15},-- 石头
            {key="goldnugget",weight=15},-- 金块
            {key="nitre",weight=10},-- 硝石
            {key="moonrocknugget",weight=10},-- 月石
            {key="redgem",weight=5},-- 红宝石
            {key="bluegem",weight=5},-- 蓝宝石
            {key="purplegem",weight=2.5},-- 紫宝石
            {key="orangegem",weight=1.5},-- 橙宝石
            {key="yellowgem",weight=1.5},-- 黄宝石
            {key="greengem",weight=1},-- 绿宝石
            {key="opalpreciousgem",weight=0.5},-- 彩虹宝石
        },
        printtable = { -- 蓝图掉落表
            {key="armor_medal_obsidian",weight=10},-- 黑曜石甲
            {key="medal_firepit_obsidian",weight=10},-- 黑曜石火坑
        },
        unburnable = true,--不可燃
    },
    medal_losswetpouch6 = { -- 湖泊
        loottable = { -- 默认掉落表
            {key="medal_treasure_map",weight=10},-- 藏宝图
            {key="trinket_17",weight=10},-- 弯曲的叉子
            {key="townportaltalisman",weight=15},-- 沙之石
            {key="spoiled_fish",weight=15},-- 腐烂的鱼
            {key="driftwood_log",weight=15},-- 浮木
            {key="seeds",weight=15},-- 种子
            {key="boneshard",weight=10},-- 骨片
            {key="houndstooth",weight=5},-- 狗牙
            {key="lightninggoathorn",weight=5},-- 羊角
        }
    },
    medal_losswetpouch7 = { -- 空间
        loottable = { -- 默认掉落表
            {key="medal_treasure_map",weight=15},-- 藏宝图
            {key="townportaltalisman",weight=10},-- 沙之石
            {key="medal_spacetime_lingshi",weight=25},-- 时空灵石
            {key="medal_time_slider",weight=5},-- 时空碎片
            {key="medal_gestalt",weight=10},-- 时空虚影
            {key="medal_spacetime_potion",weight=10},-- 改命药水
            {key="medal_spacetime_runes",weight=10},-- 时空符文
            {key="medal_spacetime_snacks_packet",weight=15},-- 零食包装袋
        },
    }
}

return medal_losswetpouch
