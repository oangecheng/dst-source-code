local L = locale ~= "zh" and locale ~= "zhr" --true-英文; false-中文

--另一种写法
-- name = ChooseTranslationTable({
--     [1] = "[DST] Legion",
--     zh = "[DST] 棱镜",
-- })

name = L and "[DST] Legion" or "[DST] 棱镜"
author = "ti_Tout"
version = "7.2.2" --每次更新时为了上传必须更改
description =
    L and "Thanks for using this mod!\n                                           [version]"..version.."  [file]1392778117\n\n*As you can see, this mod includes much of the imagination of the mod makers. I really want to make this mod like a DLC, can we wait until it happens?\n\nSpecial thanks：半夏微暖半夏凉(Code consultant)、羽中就是他(Guest artist)、风铃草(Functional supporter)、白饭(Wiki editor)"
    or "感谢订阅本mod！                                    [版本]"..version.."  [文件]1392778117\n\n*如你所见，本mod包括了作者的很多的脑洞，我也很想把这个mod做成像DLC一样的规模，敬请期待吧。\n*本mod为个人爱好所做，禁止任何个人或组织转载、除自用外的修改、发布或其他形式的侵犯本mod权益的行为！\n\n特别感谢：半夏微暖半夏凉(代码指导)、羽中就是他(客串画佬)、风铃草(特功支持)、白饭(百科编辑)"

--个人网址，即使没有也必须留空
forumthread = L and "" or "https://www.zybuluo.com/Tout/note/1509031"

--lua版本，单机写6，联机写10
api_version = 10

--mod加载的优先级，不写就默认为0，越大越优先加载
priority = -345

-- Compatible with Don't Starve Together
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false

--These let clients know if they need to get the mod from the Steam Workshop to join the game, Character mods need this set to true
all_clients_require_mod = true

--This determines whether it causes a server to be marked as modded (and shows in the mod list)
client_only_mod = false

--mod的图标
icon_atlas = "modicon.xml"
icon = "modicon.tex"

-- The mod's tags displayed on the server list
server_filter_tags = L and { "LEGION", } or { "棱镜", }

--mod设置
configuration_options = {
    {name = "Title", label = L and "Language" or "语言", options = {{description = "", data = ""},}, default = "",},
    L and {
        name = "Language",
        label = "Set Language",
        hover = "Choose your language", --这个是鼠标指向选项时会显示更详细的信息
        options =
        {
            -- {description = "Auto", data = "auto"},
            {description = "English", data = "english"},
            {description = "Chinese", data = "chinese"},
        },
        default = "english",
    } or {
        name = "Language",
        label = "设置语言",
        hover = "设置mod语言。亲，你的英语四六级过了吗？",
        options =
        {
            -- {description = "自动", data = "auto"},
            {description = "英文", data = "english"},
            {description = "中文", data = "chinese"},
        },
        default = "chinese",
    },

    -----

    -- {name = "Title", label = "", options = {{description = "", data = ""},}, default = "",},
    -- {
    --     name = "Title",
    --     label = "NewFaces",
    --     options = {{description = "", data = ""},},
    --     default = "",
    -- },
    -- {
    --     name = "NewFaceWarly",
    --     label = "Warly",
    --     hover = "Allow new character-Warly to be added/允许添加新人物-沃利",
    --     options = 
    --     {
    --         {description = "Yes", data = true},
    --         {description = "No", data = false},
    --     },
    --     default = true,
    -- },

    -----

    {name = "Title", label = "", options = {{description = "", data = ""},}, default = "",},
    {
        name = "Title",
        label = L and "ThePowerOfFlowers" or "花香四溢",
        options = {{description = "", data = ""},},
        default = "",
    },
    L and {
        name = "FlowerWeaponsChance",
        label = "Flower Weapons Chance",
        hover = "Set the chance to get flower weapons.",
        options =
        {
            {description = "0%", data = -0.10},
            {description = "1%", data = 0.01},
            {description = "3%(default)", data = 0.03},
            {description = "5%", data = 0.05},
            {description = "7%", data = 0.07},
            {description = "10%", data = 0.10},
            {description = "15%", data = 0.15},
            {description = "20%", data = 0.20},
            {description = "30%", data = 0.30},
            {description = "50%", data = 0.50},
            {description = "100%", data = 1.00},
        },
        default = 0.03,
    } or {
        name = "FlowerWeaponsChance",
        label = "花之武器掉落几率",
        hover = "设置花之武器的获取几率。有幸能做一位花中剑客。",
        options =
        {
            {description = "0%", data = -0.10},
            {description = "1%", data = 0.01},
            {description = "3%(默认)", data = 0.03},
            {description = "5%", data = 0.05},
            {description = "7%", data = 0.07},
            {description = "10%", data = 0.10},
            {description = "15%", data = 0.15},
            {description = "20%", data = 0.20},
            {description = "30%", data = 0.30},
            {description = "50%", data = 0.50},
            {description = "100%", data = 1.00},
        },
        default = 0.03,
    },
    L and {
        name = "FoliageathChance",
        label = "Foliageath Chance",
        hover = "Set the chance to get Foliageath.",
        options =
        {
            {description = "0%", data = 0},
            {description = "0.1%", data = 0.001},
            {description = "0.5%(default)", data = 0.005},
            {description = "1%", data = 0.01},
            {description = "3%", data = 0.03},
            {description = "5%", data = 0.05},
            {description = "10%", data = 0.1},
            {description = "25%", data = 0.25},
            {description = "50%", data = 0.5},
            {description = "100%", data = 1.0},
        },
        default = 0.005,
    } or {
        name = "FoliageathChance",
        label = "青枝绿叶掉落几率",
        hover = "设置青枝绿叶的掉落几率。枯叶之下，藏多少情话。",
        options =
        {
            {description = "0%", data = 0},
            {description = "0.1%", data = 0.001},
            {description = "0.5%(默认)", data = 0.005},
            {description = "1%", data = 0.01},
            {description = "3%", data = 0.03},
            {description = "5%", data = 0.05},
            {description = "10%", data = 0.1},
            {description = "25%", data = 0.25},
            {description = "50%", data = 0.5},
            {description = "100%", data = 1.0},
        },
        default = 0.005,
    },

    -----

    {name = "Title", label = "", options = {{description = "", data = ""},}, default = "",},
    {
        name = "Title",
        label = L and "SuperbCuisine" or "美味佳肴",
        options = {{description = "", data = ""},},
        default = "",
    },
    L and {
        name = "FestivalRecipes",
        label = "Festival Recipes",
        hover = "Open Festival recipes.",
        options =
        {
            {description = "Yes", data = true},
            {description = "No(default)", data = false},
        },
        default = false,
    } or {
        name = "FestivalRecipes",
        label = "解禁节日料理",
        hover = "开放节日特供的食谱。让你能随时随地烹饪节日料理，享受吧！",
        options =
        {
            {description = "是", data = true},
            {description = "否(默认)", data = false},
        },
        default = false,
    },
    L and {
        name = "BetterCookBook",
        label = "Better CookBook",
        hover = "Players in English environment please ignore this setting.",
        options =
        {
            -- {description = "Yes", data = true},
            {description = "No(default)", data = false},
        },
        default = false,
    } or {
        name = "BetterCookBook",
        label = "优化食谱介绍",
        hover = "优化食谱的介绍界面和信息展示（仅支持中文环境）。这面甜得掉牙了，大叔。",
        options =
        {
            {description = "是(默认)", data = true},
            {description = "否", data = false},
        },
        default = true,
    },

    -----

    {name = "Title", label = "", options = {{description = "", data = ""},}, default = "",},
    {
        name = "Title",
        label = L and "TheSacrificeOfRain" or "祈雨祭",
        options = {{description = "", data = ""},},
        default = "",
    },
    L and {
        name = "BookRecipetabs",
        label = "Book Recipetabs",
        hover = "Set recipetabs of Changing Clouds.",
        options =
        {
            {description = "Book(default)", data = "bookbuilder"},
            {description = "Magic", data = "magic"},
        },
        default = "bookbuilder",
    } or {
        name = "BookRecipetabs",
        label = "《多变的云》制作方式",
        hover = "设置《多变的云》的制作栏。决定一本巨著的沉沦或现世。",
        options =
        {
            {description = "书籍栏(默认)", data = "bookbuilder"},
            {description = "魔法栏", data = "magic"},
        },
        default = "bookbuilder",
    },
    L and {
        name = "HiddenUpdateTimes",
        label = "Max Upgrade Times of Hidden Moonlight",
        hover = "Set the maximum upgrade times of Hidden Moonlight.",
        options = {
            { description = "14 times", data = 14 },
            { description = "28 times", data = 28 },
            { description = "42 times", data = 42 },
            { description = "56 times(default)", data = 56 },
            { description = "70 times", data = 70 },
            { description = "84 times", data = 84 },
            { description = "98 times", data = 98 }
        },
        default = 56
    } or {
        name = "HiddenUpdateTimes",
        label = "月藏宝匣最大升级次数",
        hover = "设置月藏宝匣的升级次数的最大值。",
        options = {
            { description = "14次", data = 14 },
            { description = "28次", data = 28 },
            { description = "42次", data = 42 },
            { description = "56次(默认)", data = 56 },
            { description = "70次", data = 70 },
            { description = "84次", data = 84 },
            { description = "98次", data = 98 }
        },
        default = 56
    },
    L and {
        name = "RevolvedUpdateTimes",
        label = "Max Upgrade Times of Revolved Moonlight",
        hover = "Set the maximum upgrade times of Revolved Moonlight.",
        options = {
            { description = "4 times", data = 4 },
            { description = "8 times", data = 8 },
            { description = "12 times", data = 12 },
            { description = "16 times", data = 16 },
            { description = "20 times(default)", data = 20 },
            { description = "24 times", data = 24 },
            { description = "30 times", data = 30 },
            { description = "40 times", data = 40 }
        },
        default = 20
    } or {
        name = "RevolvedUpdateTimes",
        label = "月轮宝盘最大升级次数",
        hover = "设置月轮宝盘的升级次数的最大值。",
        options = {
            { description = "4次", data = 4 },
            { description = "8次", data = 8 },
            { description = "12次", data = 12 },
            { description = "16次", data = 16 },
            { description = "20次(默认)", data = 20 },
            { description = "24次", data = 24 },
            { description = "30次", data = 30 },
            { description = "40次", data = 40 }
        },
        default = 20
    },

    -----

    {name = "Title", label = "", options = {{description = "", data = ""},}, default = "",},
    {
        name = "Title",
        label = L and "LegendOfFall" or "丰饶传说",
        options = {{description = "", data = ""},},
        default = "",
    },
    -- L and {
    --     name = "GrowthRate",
    --     label = "Growth rate",
    --     hover = "Setting growth rate of Crops.",
    --     options =
    --     {
    --         {description = "0.7x", data = 0.7},
    --         {description = "1x(default)", data = 1},
    --         {description = "1.5x", data = 1.5},
    --         {description = "2x", data = 2},
    --     },
    --     default = 1,
    -- } or {
    --     name = "GrowthRate",
    --     label = "农作物生长速度",
    --     hover = "设置农作物的生长速度。长得这么慢，绝对没打激素！",
    --     options =
    --     {
    --         {description = "0.7倍", data = 0.7},
    --         {description = "1倍(默认)", data = 1},
    --         {description = "1.5倍", data = 1.5},
    --         {description = "2倍", data = 2},
    --     },
    --     default = 1,
    -- },
    -- L and {
    --     name = "CropYields",
    --     label = "Crop Yields",
    --     hover = "Setting crop yields.",
    --     options =
    --     {
    --         {description = "random(default)", data = 0},
    --         {description = "at least 1", data = 1},
    --         {description = "at least 2", data = 2},
    --         {description = "at least 3", data = 3},
    --     },
    --     default = 0,
    -- } or {
    --     name = "CropYields",
    --     label = "农作物产量",
    --     hover = "设置农作物的产量。你啥货色，它就给你啥脸色。",
    --     options =
    --     {
    --         {description = "随机(默认)", data = 0},
    --         {description = "至少1个", data = 1},
    --         {description = "至少2个", data = 2},
    --         {description = "至少3个", data = 3},
    --     },
    --     default = 0,
    -- },
    L and {
        name = "OverripeTime",
        label = "Overripe Time",
        hover = "Set overripe time of X-crops.",
        options =
        {
            {description = "1x(default)", data = 1},
            {description = "2x", data = 2},
            {description = "3x", data = 3},
            {description = "Never", data = 0},
        },
        default = 1,
    } or {
        name = "OverripeTime",
        label = "异种作物过熟时间",
        hover = "设置异种作物过熟的时间。果子熟透了就要掉地上，自然规律真奇妙。",
        options =
        {
            {description = "1倍(默认)", data = 1},
            {description = "2倍", data = 2},
            {description = "3倍", data = 3},
            {description = "不过熟", data = 0},
        },
        default = 1,
    },
    L and {
        name = "PestRisk",
        label = "Pest Risk",
        hover = "Set the chance of pest infestation about X-crops.",
        options =
        {
            {description = "Never", data = 0},
            {description = "0.07%", data = 0.0007},
            {description = "0.2%", data = 0.002},
            {description = "0.7%(default)", data = 0.007},
            {description = "1.2%", data = 0.012},
            {description = "2.0%", data = 0.020},
            {description = "10.0%", data = 0.100},
            {description = "Always", data = 1.000},
        },
        default = 0.007,
    } or {
        name = "PestRisk",
        label = "异种作物虫害率",
        hover = "设置异种作物害虫产生几率。种好你的田，管好你的地！",
        options =
        {
            {description = "不产生", data = 0},
            {description = "0.07%", data = 0.0007},
            {description = "0.2%", data = 0.002},
            {description = "0.7%(默认)", data = 0.007},
            {description = "1.2%", data = 0.012},
            {description = "2.0%", data = 0.020},
            {description = "10.0%", data = 0.100},
            {description = "总是产生", data = 1.000},
        },
        default = 0.007,
    },
    L and {
        name = "PhoenixRebirthCycle",
        label = "Phoenix Rebirth Cycle",
        hover = "Set the time for rebirth about Siving Phoenix.",
        options = {
            {description = "5 sec", data = 5},
            {description = "1 day", data = 480},
            {description = "5 day", data = 2400},
            {description = "10 day", data = 4800},
            {description = "15 day(default)", data = 7200},
            {description = "20 day", data = 9600},
            {description = "25 day", data = 12000},
            {description = "30 day", data = 14400},
        },
        default = 7200
    } or {
        name = "PhoenixRebirthCycle",
        label = "玄鸟重生周期",
        hover = "设置子圭玄鸟再生的所需时间。生死是个循环！",
        options = {
            {description = "5秒", data = 5},
            {description = "1天", data = 480},
            {description = "5天", data = 2400},
            {description = "10天", data = 4800},
            {description = "15天(默认)", data = 7200},
            {description = "20天", data = 9600},
            {description = "25天", data = 12000},
            {description = "30天", data = 14400},
        },
        default = 7200
    },
    L and {
        name = "PhoenixBattleDifficulty",
        label = "Phoenix Battle Difficulty",
        hover = "Set the difficulty of BOSS battle with Siving Phoenix.",
        options = {
            {description = "Effortlessly", data = 1},
            {description = "Methodically(default)", data = 2},
            {description = "Anxiously", data = 3}
        },
        default = 2
    } or {
        name = "PhoenixBattleDifficulty",
        label = "玄鸟战斗难度",
        hover = "设置子圭玄鸟BOSS战的难度。谁是战斗之王，我是手残之王。",
        options = {
            {description = "小菜一碟", data = 1},
            {description = "普普通通(默认)", data = 2},
            {description = "步履艰难", data = 3}
        },
        default = 2
    },
    L and {
        name = "SivingRootTex",
        label = "Siving Root Texture",
        hover = "Set the texture of Siving Root to avoid intensive phobia.",
        options = {
            {description = "Mod(default)", data = 1},
            {description = "Official", data = 2}
        },
        default = 1
    } or {
        name = "SivingRootTex",
        label = "子圭突触贴图",
        hover = "设置子圭突触的贴图。你要是对它密集恐惧症犯了就换成官方的图吧。",
        options = {
            {description = "mod贴图(默认)", data = 1},
            {description = "官方图", data = 2}
        },
        default = 1
    },
    L and {
        name = "SivFeaStrength",
        label = "Siving-Plume Strength",
        hover = "Set damage and HP loss of Siving-Plume.",
        options = {
            {description = "17/-0.5", data = 1}, --0.5
            {description = "23.8/-1", data = 2}, --0.7
            {description = "34/-2(default)", data = 3}, --1
            {description = "42.5/-2.5", data = 4}, --1.25
            {description = "51/-3", data = 5}, --1.5
            {description = "61.2/-4", data = 6}, --1.8
            {description = "68/-4.5", data = 7} --2
        },
        default = 3
    } or {
        name = "SivFeaStrength",
        label = "子圭·翰强度",
        hover = "设置子圭·翰的攻击力和耗血。变态，还是不变态，你自己界定！",
        options = {
            {description = "17/-0.5", data = 1}, --0.5
            {description = "23.8/-1", data = 2}, --0.7
            {description = "34/-2(默认)", data = 3}, --1
            {description = "42.5/-2.5", data = 4}, --1.25
            {description = "51/-3", data = 5}, --1.5
            {description = "61.2/-4", data = 6}, --1.8
            {description = "68/-4.5", data = 7} --2
        },
        default = 3
    },
    L and {
        name = "DigestedItemMsg",
        label = "Digested-message of Vase Herb",
        hover = "Send a server message when Vase Herb digest items.",
        options = {
            {description = "On(default)", data = true},
            {description = "Off", data = false}
        },
        default = true
    } or {
        name = "DigestedItemMsg",
        label = "巨食草消化提醒",
        hover = "在巨食草消化物品时发送全服消息。毕竟它什么都吃，安全起见。",
        options = {
            {description = "开启(默认)", data = true},
            {description = "关闭", data = false}
        },
        default = true
    },

    -----

    {name = "Title", label = "", options = {{description = "", data = ""},}, default = "",},
    {
        name = "Title",
        label = L and "FlashAndCrush" or "电闪雷鸣",
        options = {{description = "", data = ""},},
        default = "",
    },
    L and {
        name = "TechUnlock",
        label = "Tech Unlock",
        hover = "Set up ways to unlock new techs.",
        options =
        {
            {description = "Lootdropper", data = "lootdropper"},            --蓝图掉落模式
            {description = "Prototyper(default)", data = "prototyper"},     --科技解锁模式：这个模式是我推荐的，但因为会修改很多地方，兼容性可能不太好，所以才有了这个设置
        },
        default = "prototyper",
    } or {
        name = "TechUnlock",
        label = "[重铸科技]解锁方式",
        hover = "设置解锁重铸科技的方式。请偷偷的告诉我，你怎么学会的。",
        options =
        {
            {description = "Boss掉落蓝图", data = "lootdropper"},
            {description = "电气重铸台(默认)", data = "prototyper"},
        },
        default = "prototyper",
    },

    -----

    {name = "Title", label = "", options = {{description = "", data = ""},}, default = "",},
    {
        name = "Title",
        label = L and "DesertSecret" or "尘市蜃楼",
        options = {{description = "", data = ""},},
        default = "",
    },
    L and {
        name = "DressUp",
        label = "Enable Facade",
        hover = "Enable facade function.",
        options =
        {
            {description = "Yes", data = true},
            {description = "No", data = false},
        },
        default = true,
    } or {
        name = "DressUp",
        label = "启用幻化机制",
        hover = "是否启用幻化机制。沉迷幻想是件好事吗。",
        options =
        {
            {description = "是", data = true},
            {description = "否", data = false},
        },
        default = true,
    },

    -----

    {name = "Title", label = "", options = {{description = "", data = ""},}, default = "",},
    {
        name = "Title",
        label = L and "Other" or "其他",
        options = {{description = "", data = ""},},
        default = "",
    },
    L and {
        name = "CleaningUpStench",
        label = "Cleaning Up Stench",
        hover = "Auto-cleaning-up smelly things on the ground.",
        options =
        {
            {description = "Yes", data = true},
            {description = "No(default)", data = false},
        },
        default = false,
    } or {
        name = "CleaningUpStench",
        label = "臭臭自动清理",
        hover = "自动清除掉在地上的臭东西(大便、鸟粪、腐烂物)。化作春泥更护花。",
        options =
        {
            {description = "是", data = true},
            {description = "否(默认)", data = false},
        },
        default = false,
    },
    L and {
        name = "BackCubChance",
        label = "Back Cub Chance",
        hover = "Set the chance to get Back Cub.",
        options =
        {
            {description = "100%", data = 1},
            {description = "85%", data = 0.85},
            {description = "70%(default)", data = 0.7},
            {description = "55%", data = 0.55},
            {description = "40%", data = 0.4},
            {description = "25%", data = 0.25},
            {description = "10%", data = 0.1},
            {description = "0%", data = 0},
        },
        default = 0.7,
    } or {
        name = "BackCubChance",
        label = "靠背熊掉落几率",
        hover = "设置靠背熊的掉落几率。又萌又懒又喜欢吃的小宠物谁不爱呢？",
        options =
        {
            {description = "总是掉落", data = 1},
            {description = "85%", data = 0.85},
            {description = "70%(默认)", data = 0.7},
            {description = "55%", data = 0.55},
            {description = "40%", data = 0.4},
            {description = "25%", data = 0.25},
            {description = "10%", data = 0.1},
            {description = "不会掉落", data = 0},
        },
        default = 0.7,
    },
}