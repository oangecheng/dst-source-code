local isCh = locale == "zh" or locale == "zhr"--是否为中文
name = isCh and "能力勋章" or "Functional Medal"
description = isCh and [[当前版本1.6.0.3
能力勋章是一个以“成长”为主题的扩展类Mod，在原本游戏的基础上增加了一种新类型的道具——勋章。
不同的勋章代表着不同的能力，有的勋章能让你拥有其他角色的能力，有的勋章则能大大提高你的工作效率，有的勋章更能给你带来扭转乾坤的力量。
勋章所带来的能力虽然强大，但是获取起来也并非易事，你要在永恒大陆经历各种各样的冒险，尝尽孤岛生存带来的酸甜苦辣后，方能获得你应有的成长。
除此之外，还有更多你从未见过的扩展内容等你来体验~
灵魂救赎，凋零之蜂；
轮回宿命，穿梭时空；
移花接木，融会贯通；
人生百味，尽在其中！
详细的mod介绍可以去www.guanziheng.com查看哦~
遇到问题可以先查阅介绍页的常见问题，如果问题还是不能解决，欢迎加群反馈~
群号:967226714]] or "Addition of the Medal System, you can use the cartographer's desk to make various medals."
author = "恒子、|白日(画师)|BCI(动画)"

version = "1.6.0.3"--整体.大章节.小章节.优化、修Bug

api_version = 10

dont_starve_compatible = true
reign_of_giants_compatible = true
dst_compatible = true
restart_required = false
all_clients_require_mod = true
icon = "modicon.tex"
icon_atlas = "modicon.xml"
server_filter_tags = {"medal","能力勋章"}

forumthread = "https://www.guanziheng.com"
priority = -9999--优先级调高

local function Subtitle(name)
	return {
		name = name,
		label = name,
		options = { {description = "", data = false}, },
		default = false,
	}
end

configuration_options = isCh and
{
	Subtitle("基础设置"),
	{
		name = "language_switch",
		label = "选择语言",
		hover = "选择你的常用语言",
		options =
		{
			{description = "中文", data = "ch", hover = "中文"},
			{description = "English", data = "eng", hover = "English"},
		},
		default = "ch",
	},
	{
		name = "difficulty_switch",
		label = "难度选择",
		hover = "选择道具的制作成本",
		options =
		{
			{description = "简易", data = true, hover = "低成本"},
			{description = "默认", data = false, hover = "默认成本"},
		},
		default = false,
	},
	Subtitle("UI相关"),
	{
		name = "medalequipslots_switch",
		label = "勋章栏",
		hover = "额外独立出来的勋章栏，方便装备勋章",
		options =
		{
			{description = "开启", data = true, hover = "开启勋章栏"},
			{description = "关闭", data = false, hover = "关闭勋章栏"},
		},
		default = true,
	},
	{
		name = "medal_inv_switch",
		label = "勋章栏自动贴边",
		hover = "融合勋章栏是否自动贴边，贴边显示更舒适，如果开了45格等不能正常兼容的Mod可关闭该选项",
		options =
		{
			{description = "开启", data = true, hover = "自动贴边"},
			{description = "关闭", data = false, hover = "不自动贴边"},
		},
		default = true,
	},
	{
		name = "containerdrag_setting",
		label = "容器拖拽",
		hover = "开启后可按住鼠标右键拖动融合勋章栏、勋章盒等UI",
		options =
		{
			{description = "关闭", data = 0, hover = "关闭容器拖拽功能"},
			{description = "仅勋章容器", data = 1, hover = "可拖拽融合勋章栏、勋章盒等勋章特有的容器格子"},
			{description = "所有容器", data = 2, hover = "可拖拽游戏内所有容器的格子"},
		},
		default = 2,
	},
	{
		name = "medalpage_switch",
		label = "勋章设置按钮",
		hover = "游戏内左下角显示的图标，点击可打开设置面板",
		options =
		{
			{description = "显示", data = true, hover = "显示勋章设置按钮"},
			{description = "隐藏", data = false, hover = "隐藏勋章设置按钮"},
		},
		default = true,
	},
	Subtitle("信息展示"),
	{
		name = "show_medal_fx",
		label = "特效",
		hover = "可选择是否开启吞噬法杖、读功能性书籍等地方会播放的特效，怕卡可关闭",
		options =
		{
			{description = "开启", data = true, hover = "开启特效"},
			{description = "关闭", data = false, hover = "关闭特效"},
		},
		default = true,
	},
	{
		name = "medal_tips_switch",
		label = "飘字提示",
		hover = "可选择是否开启弹幕提示，开启时部分勋章消耗耐久时会飘字提示",
		options =
		{
			{description = "关闭", data = false, hover = "关闭飘字提示"},
			{description = "开启", data = true, hover = "开启飘字提示"},
		},
		default = true,
	},
	Subtitle("世界设置"),
	{
		name = "medal_shardskinholes_switch",
		label = "跨服时空塌陷",
		hover = "若不希望时空吞噬者跨世界释放时空塌陷，或影响到了多层世界时间同步，可选择关闭",
		options =
		{
			{description = "开启", data = true, hover = "开启跨服时空塌陷"},
			{description = "关闭", data = false, hover = "关闭跨服时空塌陷"},
		},
		default = true,
	},
	Subtitle("其他模组相关"),
	{
		name = "transplant_switch",
		label = "移植功能",
		hover = "若不想开启移植功能或者已经开启其他同类型mod，可选择关闭",
		options =
		{
			{description = "开启", data = true, hover = "开启移植功能"},
			{description = "关闭", data = false, hover = "关闭移植功能"},
		},
		default = true,
	},
	{
		name = "medal_goodmid_resources_multiple",
		label = "高级风滚草资源",
		hover = "和花样风滚草联动，可在风滚草内加入移植作物等高级资源",
		options =
		{
			{description = "关闭", data = 0, hover = "关闭该资源"},
			{description = "开启", data = 1, hover = "加入该资源"},
			{description = "×2", data = 2, hover = "两倍掉落率"},
			{description = "×5", data = 5, hover = "五倍掉落率"},
			{description = "×10", data = 10, hover = "十倍掉落率"},
			{description = "×20", data = 20, hover = "二十倍掉落率"},
			{description = "×50", data = 50, hover = "五十倍掉落率"},
			{description = "×100", data = 100, hover = "一百倍掉落率"},
		},
		default = 1,
	},
	{
		name = "medal_goodmax_resources_multiple",
		label = "稀有风滚草资源",
		hover = "和花样风滚草联动，可在风滚草内加入勋章等稀有资源",
		options =
		{
			{description = "关闭", data = 0, hover = "关闭该资源"},
			{description = "开启", data = 1, hover = "加入该资源"},
			{description = "×2", data = 2, hover = "两倍掉落率"},
			{description = "×5", data = 5, hover = "五倍掉落率"},
			{description = "×10", data = 10, hover = "十倍掉落率"},
			{description = "×20", data = 20, hover = "二十倍掉落率"},
			{description = "×50", data = 50, hover = "五十倍掉落率"},
			{description = "×100", data = 100, hover = "一百倍掉落率"},
		},
		default = 0,
	},
	{
		name = "medal_tech_lock",
		label = "基础科技依赖",
		hover = "关闭后制作一些勋章的内容不再需要科学1~3本和魔法1~2本才能解锁\n主要为了玩无科技蓝图模式的玩家增加的设置，普通玩家无视即可。",
		options =
		{
			{description = "开启", data = false, hover = "制作本模组内容仍然需要科学本和魔法本来解锁"},
			{description = "关闭", data = true, hover = "制作本模组内容不再需要科学本和魔法本来解锁"},
		},
		default = false,
	}
} or
{
	Subtitle("Basic Settings"),
	{--选择语言
		name = "language_switch",
		label = "Language",
		hover = "Choose your common language",
		options =
		{
			{description = "中文", data = "ch", hover = "中文"},
			{description = "English", data = "eng", hover = "English"},
		},
		default = "eng",
	},
	{--难度选择
		name = "difficulty_switch",
		label = "Selection Level",
		hover = "Production cost of choosing props.",
		options =
		{
			{description = "Easy", data = true, hover = "Low cost"},
			{description = "Default", data = false, hover = "Default cost"},
		},
		default = false,
	},
	Subtitle("UI Settings"),
	{--勋章栏
		name = "medalequipslots_switch",
		label = "Medal Equip Slots",
		hover = "Extra independent Medal Equip Slots.",
		options =
		{
			{description = "Open", data = true, hover = "Open Medal Equip Slots"},
			{description = "Closed", data = false, hover = "Closed Medal Equip Slots"},
		},
		default = true,
	},
	{--勋章栏自动贴边
		name = "medal_inv_switch",
		label = "Automatic Trimming of Medal Equip Slots",
		hover = "If the Medal Equip Slots cannot be displayed normally, you can choose to turn it off for compatibility",
		options =
		{
			{description = "Open", data = true, hover = "Open"},
			{description = "Closed", data = false, hover = "Closed"},
		},
		default = true,
	},
	{--容器拖拽
		name = "containerdrag_setting",
		label = "Drag Container",
		hover = "Drag container setting.",
		options =
		{
			{description = "Closed", data = 0, hover = "Closed Drag Container"},
			{description = "Just Medal Containers", data = 1, hover = "Right click to drag medal containers"},
			{description = "All Containers", data = 2, hover = "Right click to drag all containers"},
		},
		default = 2,
	},
	{--勋章设置界面
		name = "medalpage_switch",
		label = "Mod Setting Button",
		hover = "Mod setting button.",
		options =
		{
			{description = "Show", data = true, hover = "Show setting icon"},
			{description = "Hide", data = false, hover = "Hide setting icon"},
		},
		default = true,
	},
	Subtitle("Information Display"),
	{--显示特效
		name = "show_medal_fx",
		label = "Show FX",
		hover = "You can choose to show or hide FX",
		options =
		{
			{description = "Open", data = true, hover = "Show"},
			{description = "Close", data = false, hover = "Hide"},
		},
		default = true,
	},
	{--飘字提示
		name = "medal_tips_switch",
		label = "Floating Tips",
		hover = "After opening,When some medals consume durability, they will be prompted with floating words",
		options =
		{
			{description = "Close", data = false, hover = "Close"},
			{description = "Open", data = true, hover = "Open"},
		},
		default = true,
	},
	Subtitle("World Settings"),
	{--跨服时空塌陷
		name = "medal_shardskinholes_switch",
		label = "Cross World Sinkhole",
		hover = "If you do not want the space-time devourer to release the space-time collapse across the world, \nyou can choose to close it",
		options =
		{
			{description = "Open", data = true, hover = "Open"},
			{description = "Close", data = false, hover = "Close"},
		},
		default = true,
	},
	Subtitle("Other Mods"),
	{--移植功能
		name = "transplant_switch",
		label = "Transplant Function",
		hover = "If you have another transplant Mod,you can closed this button.",
		options =
		{
			{description = "Open", data = true, hover = "Open"},
			{description = "Close", data = false, hover = "Close"},
		},
		default = true,
	},
	{--高级风滚草资源
		name = "medal_goodmid_resources_multiple",
		label = "Advanced Tumbleweed Resources",
		hover = "Advanced resources such as transplanting crops can be added to the Tumbleweed",
		options =
		{
			{description = "Close", data = 0, hover = "Close the resource"},
			{description = "Open", data = 1, hover = "Join the resource"},
			{description = "×2", data = 2, hover = "2 times probability"},
			{description = "×5", data = 5, hover = "5 times probability"},
			{description = "×10", data = 10, hover = "10 times probability"},
			{description = "×20", data = 20, hover = "20 times probability"},
			{description = "×50", data = 50, hover = "50 times probability"},
			{description = "×100", data = 100, hover = "100 times probability"},
		},
		default = 1,
	},
	{--稀有风滚草资源
		name = "medal_goodmax_resources_multiple",
		label = "Rare Tumbleweed Resources",
		hover = "Rare resources such as Medal can be added to the Tumbleweed",
		options =
		{
			{description = "Close", data = 0, hover = "Close the resource"},
			{description = "Open", data = 1, hover = "Join the resource"},
			{description = "×2", data = 2, hover = "2 times probability"},
			{description = "×5", data = 5, hover = "5 times probability"},
			{description = "×10", data = 10, hover = "10 times probability"},
			{description = "×20", data = 20, hover = "20 times probability"},
			{description = "×50", data = 50, hover = "50 times probability"},
			{description = "×100", data = 100, hover = "100 times probability"},
		},
		default = 0,
	},
	{--基础科技依赖
		name = "medal_tech_lock",
		label = "Technology Dependence",
		hover = "After closing, the content of making some medals no longer needs science and magic to unlock. \nIt is mainly to the settings added by players in no technology mode. Ordinary players can ignore this option.",
		options =
		{
			{description = "Open", data = false, hover = "Making the content of this mod still needs to unlock the science and magic."},
			{description = "Close", data = true, hover = "Making the content of this mod no longer needs to unlock the science and magic."},
		},
		default = false,
	}
}