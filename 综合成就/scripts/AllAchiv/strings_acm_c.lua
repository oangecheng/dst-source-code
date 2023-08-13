STRINGS.RECIPE_DESC.KLAUS_SACK = "内含四次元空间"

STRINGS.NAMES.DEER_ANTLER1 = "鹿之匙"
STRINGS.RECIPE_DESC.DEER_ANTLER1 = "无眼鹿角的形状"

STRINGS.NAMES.ACHIVBOOK_BIRDS = "世界上的鸟"
STRINGS.RECIPE_DESC.ACHIVBOOK_BIRDS = "1000个物种的生活习性、栖息地。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ACHIVBOOK_BIRDS = "里面有我最喜欢的裂空座。"

STRINGS.NAMES.ACHIVBOOK_GARDENING = "应用园艺学"
STRINGS.RECIPE_DESC.ACHIVBOOK_GARDENING = "照料喂养植物。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ACHIVBOOK_GARDENING = "能够帮助植物的生长。"

STRINGS.NAMES.ACHIVBOOK_SLEEP = "睡前的故事"
STRINGS.RECIPE_DESC.ACHIVBOOK_SLEEP = "安慰的传说送你去梦境。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ACHIVBOOK_SLEEP = "书籍形式的暖牛奶。"

STRINGS.NAMES.ACHIVBOOK_BRIMSTONE = "快要结束了！"
STRINGS.RECIPE_DESC.ACHIVBOOK_BRIMSTONE = "这个世界将在大火和苦难中终结！"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ACHIVBOOK_BRIMSTONE = "哪里会出问题呢"

STRINGS.NAMES.ACHIVBOOK_TENTACLES = "在触手上"
STRINGS.RECIPE_DESC.ACHIVBOOK_TENTACLES = "让我们了解一下我们地下的朋友！"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ACHIVBOOK_TENTACLES = "很难放下它，这本轻小说真厉害。"

STRINGS.ALLACHIVCURRENCY={
[1] = "获得成就【",
[2] = "】",
[3] = "   ",
[4] = "获得 ",
[5] = " 成就点数",
[6] = "【",
[7] = "查看成就",
[8] = "交换奖励",
[9] = "已完成：",
[10] = "已获得：x",
[11] = "春(鹿角鹅)",
[12] = "夏(龙蝇)",
[13] = "秋(熊灌)",
[14] = "冬(独眼巨鹿)",
[15] = "设置",
[16] = "放大",
[17] = "缩小",
[18] = "重置奖励",
}

STRINGS.ALLACHIVNAME={
["intogame"] = "新的开始",
["firsteat"] = "第一口",
["supereat"] = "美食家",
["danding"] = "我的内心毫无波动",
["messiah"] = "救世主",
["walkalot"] = "香港记者",
["stopalot"] = "咸鱼",
["tooyoung"] = "你对力量一无所知",
["evil"] = "森林的妖精",
["snake"] = "蛇皮走位",
["deathalot"] = "超鬼",
["nosanity"] = "人工智障",
["sick"] = "丧心病狂",
["coldblood"] = "冷血动物",
["burn"] = "火的传承人",
["freeze"] = "冻住不洗澡",
["goodman"] = "你是个好人",
["brother"] = "你对我就像哥哥一样",
["fishmaster"] = "钓鱼达人",
["pickmaster"] = "拾荒者",
["chopmaster"] = "蓝翔伐木机",
["cookmaster"] = "法国大厨",
["buildmaster"] = "巧夺天工",
["longage"] = "光阴似箭",
["noob"] = "萌新",
["luck"] = "欧皇",
["black"] = "我有特别的风骚技巧",
["tank"] = "人形坦克",
["angry"] = "超凶",
["icebody"] = "冰霜体质",
["firebody"] = "熔岩体质",
["moistbody"] = "湿身",
["rigid"] = "全身硬化",
["ancient"] = "征服远古",
["queen"] = "热身完毕",
["king"] = "无名王者",
["all"] = "我毕业了",
}

STRINGS.ALLACHIVINFO={
["intogame"] = "成功进入游戏",
["firsteat"] = "吃下第一个食物",
["supereat"] = "吃了"..allachiv_eventdata["supereat"].."个食物",
["danding"] = "吃下"..allachiv_eventdata["danding"].."个怪物千层饼",
["messiah"] = "救活别人"..allachiv_eventdata["messiah"].."次",
["walkalot"] = "走路超过"..(allachiv_eventdata["walkalot"]/60).."分钟",
["stopalot"] = "停止不动并活着"..(allachiv_eventdata["stopalot"]/60).."分钟",
["tooyoung"] = "死于石头",
["evil"] = "与"..allachiv_eventdata["evil"].."棵曼德拉草交朋友",
["snake"] = "击杀"..allachiv_eventdata["snake"].."只触手",
["deathalot"] = "死亡达"..allachiv_eventdata["deathalot"].."次",
["nosanity"] = "空脑残状态达"..allachiv_eventdata["nosanity"].."秒",
["sick"] = "打死格罗姆",
["coldblood"] = "打死切斯特",
["burn"] = "身上着火",
["freeze"] = "被冻住",
["goodman"] = "与猪人交朋友"..allachiv_eventdata["goodman"].."次",
["brother"] = "与兔人交朋友"..allachiv_eventdata["goodman"].."次",
["fishmaster"] = "成功钓鱼"..allachiv_eventdata["fishmaster"].."次",
["pickmaster"] = "采摘"..allachiv_eventdata["pickmaster"].."次",
["chopmaster"] = "砍倒树或挖树根"..allachiv_eventdata["chopmaster"].."次",
["cookmaster"] = "用锅煮了"..allachiv_eventdata["cookmaster"].."个食物",
["buildmaster"] = "制造超过"..allachiv_eventdata["buildmaster"].."次",
["longage"] = "存活超过"..allachiv_eventdata["longage"].."天",
["noob"] = "死于黑暗",
["luck"] = "击杀小偷掉落小偷包",
["black"] = "被雷劈死",
["tank"] = "受到伤害超过"..allachiv_eventdata["tank"],
["angry"] = "造成伤害超过"..allachiv_eventdata["angry"],
["icebody"] = "过冷状态达"..allachiv_eventdata["icebody"].."秒",
["firebody"] = "过热状态达"..allachiv_eventdata["firebody"].."秒",
["moistbody"] = "满潮湿达"..allachiv_eventdata["moistbody"].."秒",
["rigid"] = "击杀暗黑毒蕈",
["ancient"] = "击杀远古骨魔",
["queen"] = "击杀蜜蜂女王",
["king"] = "击杀过所有四季BOSS",
["all"] = "解开了所有成就",
["intogameafterall"] = "成功进入二周目",
["blackspat"] = "单杀钢羊",
}