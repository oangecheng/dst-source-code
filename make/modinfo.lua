name = "Make"
description = "certain items can be manufactured"
author = "夜黑"
version = "3.3"

forumthread = ""

api_version = 10
dst_compatible = true

client_only_mod = false
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options =
{
	{
		name = "cave",
		label = "Cave Yes or No",
		hover = "有无洞穴",
		options =
	{
		{description = "No", data = "no", hover = "无"},
		{description = "Yes", data = "yes", hover = "有"},
	},
		default = "yes",
	},
	{
		name = "chestereyebone",
		label = "Eye Bone",
		hover = "切斯特眼骨",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "hutchfishbowl",
		label = "Star-sky",
		hover = "星-空",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "butter",
		label = "Butter",
		hover = "蝴蝶黄油",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "beardhair",
		label = "Beard Hair",
		hover = "胡须",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "disabled",
	},
	{
		name = "lureplantbulb",
		label = "Fleshy Bulb",
		hover = "多肉的球茎",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "spidereggsack",
		label = "Spider Eggs",
		hover = "蜘蛛卵",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "spiderhat",
		label = "Spiderhat",
		hover = "蜘蛛帽",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "gem",
		label = "Gems",
		hover = "宝石",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "walrushat",
		label = "Tam o' Shanter",
		hover = "贝雷帽",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "krampussack",
		label = "Krampus Sack",
		hover = "坎普斯背包",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "gears",
		label = "Gears",
		hover = "齿轮",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "steelwool",
		label = "Steel Wool",
		hover = "钢丝绒",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "moonrocknugget",
		label = "Moon Rock",
		hover = "月之石",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "thulecitepieces",
		label = "Thulecite Fragments",
		hover = "铥矿石碎片",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "minotaurhorn",
		label = "Guardian's Horn",
		hover = "守卫者的角",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "armorsnurtleshell",
		label = "Snurtle Shell Armor",
		hover = "黏糊虫壳甲",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "slurtlehat",
		label = "Shelmet",
		hover = "贝壳头盔",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "wormlight",
		label = "Glow Berry",
		hover = "发光浆果",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "goosefeather",
		label = "Down Feather",
		hover = "掉落的羽毛",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "furtuft",
		label = "Fur Tuft",
		hover = "毛簇",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "dragonscales",
		label = "Scales",
		hover = "鳞片",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "deerclopseyeball",
		label = "Deerclops Eyeball",
		hover = "巨鹿眼球",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "blueprint",
		label = "Blueprint",
		hover = "蓝图",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "livinglog",
		label = "Living Log",
		hover = "活木",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "mandrakesoup",
		label = "Mandrake Soup",
		hover = "曼德拉草汤",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "petalsevil",
		label = "Dark Petals",
		hover = "恶魔花瓣",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "marble",
		label = "Marble",
		hover = "大理石",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "rareblueprint",
		label = "Rare Blueprint",
		hover = "稀有蓝图",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "shroomskin",
		label = "Shroom Skin",
		hover = "蕈蟾酥",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "hivehat",
		label = "Bee Queen Crown",
		hover = "蜂王冠",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "royaljelly",
		label = "Royal Jelly",
		hover = "蜂王浆",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "humanmeat",
		label = "Long Pig",
		hover = "人肉",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "disabled",
	},
	{
		name = "opalstaff",
		label = "Moon Caller's Staff",
		hover = "呼月之杖",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "opalpreciousgem",
		label = "Iridescent Gem",
		hover = "彩色宝石",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "shadowheart",
		label = "Shadow Atrium",
		hover = "暗影之心",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "antlers",
		label = "Antler",
		hover = "鹿之匙",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "lavaeegg",
		label = "Lavae Egg",
		hover = "熔岩虫卵",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "manrabbittail",
		label = "Bunny Puff",
		hover = "兔毛",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "fossilpiece",
		label = "Fossil Fragment",
		hover = "化石碎片",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "atriumkey",
		label = "Ancient Key",
		hover = "古老的钥匙",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "thurible",
		label = "Shadow Thurible",
		hover = "暗影香炉",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "skeletonhat",
		label = "Bone Helm",
		hover = "骨头头盔",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "armorskeleton",
		label = "Bone Armor",
		hover = "骨质盔甲",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "sketch",
		label = "Sketch",
		hover = "图纸",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "honeycomb",
		label = "Honeycomb",
		hover = "蜂巢",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
-------------------------------------------------------------------------------------
	{
		name = "mandrake",
		label = "Mandrake",
		hover = "曼德拉草",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "catcoonden",
		label = "Hollow Stump",
		hover = "中空树桩",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "walruscamp",
		label = "Walrus Camp",
		hover = "海象巢穴",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "ancientaltar",
		label = "Ancient Pseudoscience Station",
		hover = "远古遗迹",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Altar broken", data = "altar broken", hover = "损坏的远古遗迹"},
		{description = "Ancient altar", data = "ancient altar", hover = "远古遗迹"},
	},
		default = "altar broken",
	},
	{
		name = "pond",
		label = "Pond",
		hover = "池塘",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "mermhouse",
		label = "Rundown House",
		hover = "鱼人房",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "disabled",
	},
	{
		name = "resurrectionstone",
		label = "Touch Stone",
		hover = "试金石",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "disabled",
	},
	{
		name = "beehive",
		label = "Beehive",
		hover = "蜂窝",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "disabled",
	},
	{
		name = "wasphive",
		label = "Killer Bee Hive",
		hover = "杀人蜂窝",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "disabled",
	},
	{
		name = "spiderhole",
		label = "Spilagmite",
		hover = "地下蜘蛛洞",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "disabled",
	},
	{
		name = "slurtlehole",
		label = "Slurtle Mound",
		hover = "蜗牛窝",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "disabled",
	},
	{
		name = "batcave",
		label = "Bat Cave",
		hover = "蝙蝠洞",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "disabled",
	},
	{
		name = "monkeybarrel",
		label = "Splumonkey Pod",
		hover = "猴子桶",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "disabled",
	},
	{
		name = "tallbirdnest",
		label = "Tallbird nest",
		hover = "高脚鸟窝",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "disabled",
	},
	{
		name = "houndmound",
		label = "Hound Mound",
		hover = "猎犬丘",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "disabled",
	},
	{
		name = "cavebananatree",
		label = "Cave Banana Tree",
		hover = "香蕉树",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "statueglommer",
		label = "Glommer's Statue",
		hover = "格罗姆雕像",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "disabled",
	},
	{
		name = "babybeefalo",
		label = "Baby Beefalo",
		hover = "牛宝宝",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "disabled",
	},
	{
		name = "sinkholesandstairs",
		label = "Sinkhole And Stairs",
		hover = "落水洞和楼梯",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "disabled",
	},
	{
		name = "wormlightplant",
		label = "Mysterious Plant",
		hover = "小发光浆果树",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "flowercave",
		label = "Light Flower",
		hover = "荧光草",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "cactus",
		label = "Cactus",
		hover = "仙人球",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "oasiscactus",
		label = "Oasis Cactus",
		hover = "仙人掌",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "reeds",
		label = "Reeds",
		hover = "芦苇",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "klaussack",
		label = "Loot Stash",
		hover = "精确补给",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "sacredchest",
		label = "Ancient Chest",
		hover = "远古箱子",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "rabbithole",
		label = "Rabbit Hole",
		hover = "兔子洞",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "pigtorch",
		label = "Pig Torch",
		hover = "猪人火炬",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
	{
		name = "oasislake",
		label = "Lake",
		hover = "湖泊",
		options =
	{
		{description = "Disabled", data = "disabled", hover = "关"},
		{description = "Enabled", data = "enabled", hover = "开"},
	},
		default = "enabled",
	},
}
