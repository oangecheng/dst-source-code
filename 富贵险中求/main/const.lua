--[[
    增加其它生物可中毒：table.insert(TUNING.NDNR_SMEARPOISON_MONSTERS, "生物的prefab名")
]]
TUNING.NDNR_SMEARPOISON_MONSTERS = {
    -- monster
    "tentacle",
    "beefalo",
    "pigman",
    "bunnyman",
    "hound",
    "icehound",
    "firehound",
    "walrus",
    "buzzard",
    "tallbird",
    "koalefant_summer",
    "koalefant_winter",
    "lightninggoat",
    "krampus",
    "worm",
    "rocky",
    "deer",
    "deer_red",
    "deer_blue",
    "snurtle",
    "snurtle",
    "slurtle",
    "monkey",
    "merm",
    "spider",
    "spider_warrior",
    "spider_hider",
    "spider_spitter",
    "spider_dropper",
    "spider_moon",
    -- boss
    "moose",
    "antlion",
    "bearger",
    "deerclops",
    "dragonfly",
    "malbatross",
    "beequeen",
    "klaus",
    "minotaur",
    "leif",
    "leif_sparse",
    "lordfruitfly",
    "spiderqueen",
    "warg",
    "warglet",
    "spat",
}

--[[
    增加其它武器可被抹毒：table.insert(TUNING.NDNR_SMEARPOISON_WEAPONS, "武器的prefab名")
]]
TUNING.NDNR_SMEARPOISON_WEAPONS = {
    "ndnr_hambat",
    "hambat",
    "whip",
    "nightstick",
    "boomerang",
    "trident",
    "cutlass",
    "spear",
    "spear_wathgrithr",
    "spear_obsidian",
    "nightsword",
    "ruins_bat",
    "ndnr_alloyspear"
}

-- 不能睡觉的角色
TUNING.NDNR_NOSLEEPER = {
    "wickerbottom", "webber", "wurt", "wortox"
}

-- 可使用如下方式支持其它模组里的背包使其也能使用能量核升级成永恒背包
-- table.insert(TUNING.NDNR_CANUPGRADE_BACKPACKS, "你想增加的背包的名字")
TUNING.NDNR_CANUPGRADE_BACKPACKS = {"backpack", "piggyback", "icepack", "krampus_sack", "seedpouch", "ndnr_armorvortexcloak"}

-- 可使用如下方式支持其它模组里的箱子或者冰箱等使其也能使用能量核升级成永恒
-- table.insert(TUNING.NDNR_CANUPGRADE_BOXES, "你想增加的箱子的名字")
TUNING.NDNR_CANUPGRADE_BOXES = {"saltbox", "icebox", "treasurechest", "dragonflychest", "sisturn"}

--[[
    可使用如下方式对其它模组里的buff显示在屏幕上进行扩展
    -- buffprefab: 游戏内buff名
    -- name: bufftime里取的名
    -- bank: sp里动画的父节点名
    -- build: zip包名
    -- animation: 动画名
    -- loop: 是否循环播放
    -- scale: 动画的缩放比例
    -- offset: 动画的偏移量
    -- time: buff持续时间
    TUNING.NDNR_BUFF_DISPLAY["buffprefab"] = {name = "workeffectiveness", buffname = name, bank = "spices", build = "spices", animation = "idle", loop = false, scale = 0.4, offset = {x = 0, y = 0}, time = TUNING.TOTAL_DAY_TIME/2}
]]
TUNING.NDNR_BUFFTIMES = {
    buff_workeffectiveness = {name = "workeffectiveness", symbol = "swap_spice", overridebuild = "spices", overridesymbol = "spice_sugar", bank = "spices", build = "spices", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = 0}, time = TUNING.BUFF_WORKEFFECTIVENESS_DURATION},
    buff_attack = {name = "attack", symbol = "swap_spice", overridebuild = "spices", overridesymbol = "spice_chili", bank = "spices", build = "spices", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = 5}, time = TUNING.BUFF_ATTACK_DURATION},
    buff_playerabsorption = {name = "playerabsorption", symbol = "swap_spice", overridebuild = "spices", overridesymbol = "spice_garlic", bank = "spices", build = "spices", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = 0}, time = TUNING.BUFF_PLAYERABSORPTION_DURATION},
    buff_moistureimmunity = {name = "moistureimmunity", overridesymbol = "frogfishbowl", bank = "cook_pot_food", build = "cook_pot_food", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = 0}, time = TUNING.BUFF_MOISTUREIMMUNITY_DURATION},
    buff_electricattack = {name = "electricattack", overridesymbol = "voltgoatjelly", bank = "cook_pot_food", build = "cook_pot_food", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = 3}, time = TUNING.BUFF_ELECTRICATTACK_DURATION},
    shroomsleepresist = {name = "shroomsleepresist", overridesymbol = "shroomcake", overridebuild = "cook_pot_food6", bank = "cook_pot_food", build = "cook_pot_food", animation = "idle", loop = false, scale = 0.2, offset = {x = 0, y = 0}, time = TUNING.SLEEPRESISTBUFF_TIME},
    ndnr_poisondebuff = {name = "snake", bank = "snake", build = "snake_yellow_build", animation = "idle", loop = true, scale = 0.2, offset = {x = 0, y = 0}, time = TUNING.TOTAL_DAY_TIME * 3},
    ndnr_coffeedebuff = {name = "coffee", bank = "cook_pot_food", build = "ndnr_cook_pot_food", overridesymbol = "ndnr_coffee", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = 0}, time = TUNING.TOTAL_DAY_TIME/2},
    ndnr_dragoonheartdebuff = {name = "dragoonheart", bank = "dragoon_heart", build = "dragoon_heart", animation = "idle", loop = true, scale = 0.3, offset = {x = 0, y = 0}, time = TUNING.TOTAL_DAY_TIME/2},
    ndnr_dragoonheartlavaeggdebuff = {name = "dragoonheartlavaeegg", bank = "cook_pot_food", build = "ndnr_cook_pot_food", overridesymbol = "ndnr_dragoonheartlavaeegg", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = 0}, time = TUNING.TOTAL_DAY_TIME/2},
    ndnr_snakeoildebuff = {name = "snakeoil", bank = "snakeoil", build = "snakeoil", animation = "idle", loop = false, scale = 0.4, offset = {x = 0, y = -8}, time = TUNING.TOTAL_DAY_TIME},
    ndnr_badmilkdebuff = {name = "badmilk", bank = "badstomach", build = "badstomach", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = -8}, time = TUNING.TOTAL_DAY_TIME},
    ndnr_tentacleblooddebuff = {name = "ndnr_tentacleblood", bank = "ndnr_tentacleblood", build = "ndnr_tentacleblood", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = 9}, time = TUNING.TOTAL_DAY_TIME},
    buff_strengthenhancerdebuff = {name = "ndnr_buff_strengthenhancer", bank = "dish_medicinalliquor", build = "dish_medicinalliquor", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = -6}, time = TUNING.TOTAL_DAY_TIME},
    buff_strengthenhancer = {name = "buff_strengthenhancer", bank = "dish_medicinalliquor", build = "dish_medicinalliquor", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = -6}, time = TUNING.TOTAL_DAY_TIME},
    ndnr_snakewinedebuff = {name = "ndnr_snakewine", bank = "cook_pot_food", build = "ndnr_cook_pot_food", overridesymbol = "ndnr_snakewine", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = -3}, time = TUNING.TOTAL_DAY_TIME/2},
    ndnr_bloodoverdebuff = {name = "ndnr_bloodover", bank = "catcoon", build = "catcoon_build", animation = "idle_loop", loop = true, scale = 0.2, offset = {x = 10, y = -6}, time = 40},
    ndnr_beepoisondebuff = {name = "ndnr_beepoison", bank = "ndnr_bee", build = "ndnr_bee_angry_build", animation = "idle", loop = true, scale = 0.4, offset = {x = 7, y = -20}, time = 40},
    ndnr_butterdebuff = {name = "ndnr_butter", bank = "butter", build = "butter", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = 5}, time = TUNING.TOTAL_DAY_TIME},
    ndnr_albumenpowderdebuff = {name = "albumenpowder", bank = "cook_pot_food", build = "ndnr_cook_pot_food", overridesymbol = "ndnr_albumenpowder", animation = "idle", loop = false, scale = 0.3, offset = {x = 0, y = 0}, time = TUNING.TOTAL_DAY_TIME/2},
}

-- 自定义燃料类型
TUNING.NDNR_FUELTYPE = {SPORE = "spore"}

-- 炼钢炉里可放的物品
TUNING.NDNR_SMELTER_INGREDIENT = {
    "ndnr_iron", "charcoal", "goldnugget", "thulecite", "shieldofterror", "eyemaskhat", "alloy", "moonglass", "armorruins", "nightmarefuel", "ruinshat", "ruins_bat", "livinglog"
}

-- 炼钢炉可炼制的配方
--[[
使用以下方法添加额外配方
-- recipes：配方
-- overridebuild：炼制好之后的贴图
-- overridesymbol：炼制好之后的贴图
-- count：产物的数量
-- cooktime: 冶炼一份的时间
TUNING.NDNR_SMELTER_RECIPES["产物"] = {recipes = {steelwool = 1, charcoal = 3}, overridebuild = "alloy", overridesymbol = "alloy01", count = 2}
]]
TUNING.NDNR_SMELTER_RECIPES = {
	ndnr_alloy = {recipes = {ndnr_iron = 4}, overridebuild = "alloy", overridesymbol = "alloy01", cooktime = 0.2},
	lucky_goldnugget = {recipes = {goldnugget = 2, charcoal = 2}, overridebuild = "ndnr_goldnugget", overridesymbol = "lucky_goldnugget", count = 2, cooktime = 0.5},
	shieldofterror = {recipes = {shieldofterror = 1, ndnr_alloy = 2, thulecite = 1}, overridebuild = "ndnr_eye_shield", overridesymbol = "ndnr_eye_shield", cooktime = 24},
	eyemaskhat = {recipes = {eyemaskhat = 1, ndnr_alloy = 2, thulecite = 1}, overridebuild = "ndnr_eyemaskhat", overridesymbol = "ndnr_eyemaskhat", cooktime = 24},
	messagebottleempty = {recipes = {moonglass = 4}, overridebuild = "ndnr_messagebottleempty", overridesymbol = "ndnr_messagebottleempty", cooktime = 0.5},
	armorruins = {recipes = {armorruins = 1, thulecite = 2, nightmarefuel = 1}, overridebuild = "armor_ruins", overridesymbol = "swap_body", cooktime = 12},
	ruinshat = {recipes = {ruinshat = 1, thulecite = 2, nightmarefuel = 1}, overridebuild = "ndnr_hat_ruins", overridesymbol = "ndnr_hat_ruins", cooktime = 12},
	ruins_bat = {recipes = {ruins_bat = 1, thulecite = 1, nightmarefuel = 1, livinglog = 1}, overridebuild = "ndnr_ruins_bat", overridesymbol = "ndnr_ruins_bat", cooktime = 12},
}

-- 会感染寄生虫的食物
--[[
使用以下方法添加会感染蛔虫的食物
table.insert(TUNING.NDNR_PARASITEFOODS, "食物名")
]]
TUNING.NDNR_PARASITEFOODS = {
    "meat", "monstermeat", "smallmeat", "batwing", "fishmeat_small", "fishmeat", "humanmeat", "ndnr_sharkfin", "drumstick", "fish", "eel", "wobster_sheller_dead",
    "barnacle", "froglegs", "trunk_summer", "trunk_winter", "plantmeat", "batnose", "ndnr_scallop"
}

for k, v in pairs(require("prefabs/oceanfishdef").fish) do
    table.insert(TUNING.NDNR_PARASITEFOODS, "ndnr_roe_"..v.prefab)
end

-- 不会感染寄生虫的人物
--[[
使用以下方法添加会免疫的人物名
table.insert(TUNING.NDNR_NOT_PARASITEPLAYERS, "人物名")
]]
TUNING.NDNR_NOT_PARASITEPLAYERS = {
    "wx78", "webber", "wortox"
}

-- 可被拓印出蓝图的建筑
--[[
使用以下方法添加可拓印的建筑
table.insert(TUNING.CANBERUBBING_BUILDS, "建筑名")
]]
TUNING.CANBERUBBING_BUILDS = {
    "slurtlehole", "pigtorch", "tallbirdnest", "houndmound", "monkeybarrel", "wobster_den", "moonglass_wobster_den","catcoonden",
    --"catcoonden", --官方对猫窝做了防灭绝处理，富贵里就不制作了    -- 我又加回来了，嘿嘿
    "archive_cookpot"
}

-- 可被生命水球生根的树种子
--[[
使用以下方法添加可被生命水球触发生根的种子
table.insert(TUNING.CANBESPROUTING_SEEDS, "种子名")
]]
TUNING.CANBESPROUTING_SEEDS = {
    "acorn", "pinecone", "twiggy_nut", "palmcone_seed", "ndnr_coconut"
}

-- 开启节日事件
TUNING.NDNR_CHINESEFESTIVAL = true

-- 不会中蜂毒的人物
--[[
使用以下方法添加会免疫的人物名
table.insert(TUNING.NDNR_NOT_BEEPOISONPLAYERS, "人物名")
]]
TUNING.NDNR_NOT_BEEPOISONPLAYERS = {
    "wx78", "wormwood"
}

-- 不会痛风的人物
TUNING.NDNR_NOT_GOUT_PLAYER = {
    "wx78", "wurt"
}

-- 会引起痛风的食物
TUNING.NDNR_GOUT_FOODS = {
    ndnr_seatreasure = 26,
    ndnr_shrimppullegg = 12,
    ndnr_scallopsoup = 8,
    unagi = 4,
    frogfishbowl = 8,
    lobsterdinner = 10,
    lobsterbisque = 6,
    seafoodgumbo = 12,
    surfnturf = 16,
    moqueca = 22,
}

-- 罪恶触发值
TUNING.NDNR_EVILVALUEDAMAGE = {
    [10] = 0.01,
    [30] = 0.09,
    [60] = 0.36,
    [100] = 1.00
}

TUNING.NDNR_NO_EMOSTATUS_PLAYER = {
    "wx78"
}

-- 赏金任务
TUNING.NDNR_BOUNTYTASKS = {
    {
        content = {
            zhs = "我在尝试制造一种名为渔网的新型捕鱼工具，需要很多蛛丝\n蛛丝*40",
            en = "I'm trying to make a new fishing tool called fishing net, which needs a lot of spider\nSilk*40",
        },
        list = {silk = 40},
        reward = {ndnr_roughrock = 5},
    }, {
        content = {
            zhs = "我的商店需要购置一批活木来制造新的法杖\n活木*40",
            en = "My shop needs to buy a batch of live wood to make a new staff.\nLiving Log*40",
        },
        list = {livinglog = 40},
        reward = {ndnr_roughrock = 5},
    }, {
        content = {
            zhs = "听说东方有种美食，红得透亮，色如玛瑙，软而不烂，肥而不腻。\n东坡肉*3",
            en = "It is said that there is a kind of delicious food in the East \nIt is bright red, like agate, soft but not rotten, fat but not greasy.\nDongpo Pork*3",
        },
        list = {ndnr_dongpopork = 3},
        reward = {ndnr_roughrock = 3},
    }, {
        content = {
            zhs = "又到了雨季了，关节疼的厉害，能给我弄点药酒吗？\n药酒*1",
            en = "It's rainy season again. My joints ache badly. Can you get me some medicinal wine?\nMedicinal Liquor*1",
        },
        list = {dish_medicinalliquor = 1},
        reward = {ndnr_roughrock = 3},
    }, {
        content = {
            zhs = "昨天做梦梦到了多年前珍珠做的瑶柱汤，那味道至今难忘。\n瑶柱汤*3",
            en = "Yesterday I dreamed of the scallop soup made by Pearl many years ago. The taste is unforgettable.\nScallop Soup*3",
        },
        list = {ndnr_scallopsoup = 3},
        reward = {ndnr_roughrock = 3},
    }, {
        content = {
            zhs = "我想改造一下WX-78，发现没有黄油了。\n黄油*5",
            en = "I want to modify the wx-78 and find that there is no butter.\nButter*5",
        },
        list = {butter = 5},
        reward = {ndnr_roughrock = 5},
    }, {
        content = {
            zhs = "听说珍珠又发明了一道新菜，快带来我尝尝（别让那只硬螃蟹知道了）\n大海捞珍*3",
            en = "It's said that pearl has invented another new dish. Please bring it to me to try it (don't let that hard crab know).\nSea Treasure*3",
        },
        list = {ndnr_seatreasure = 3},
        reward = {ndnr_roughrock = 6},
    }, {
        content = {
            zhs = "吃了珍珠的大海捞珍这几晚痛风发作疼的不行，快给我带点酸奶来缓解一下。\n酸奶*5",
            en = "After eating pearl Sea Treasure has a gout attack these nights. It's so hurt.\nplease bring me some yogurt to relieve the pain\nYogurt*5",
        },
        list = {ndnr_yogurt = 5},
        reward = {ndnr_roughrock = 5},
    }, {
        content = {
            zhs = "我有个朋友，想尝尝毛蛋是什么味道（你别多想，真是我的朋友）\n毛蛋*3",
            en = "I have a friend who wants to taste the taste of balut\nBalut*3",
        },
        list = {ndnr_balut = 3},
        reward = {ndnr_roughrock = 3},
    }, {
        content = {
            zhs = "出来冲浪结果碰上了台风，万幸还活着，只是被困在了个不知道什么名字的岛上。\n船*1，指南针*1，南瓜饼干*10",
            en = "When I came out to surf, I ran into a typhoon. \nFortunatelyI was still alive, but I was trapped on an island with no name.\nBoat Kit*1, Compass*1, Pumpkin Cookies*10",
        },
        list = {boat_item = 1, compass = 1, pumpkincookie = 10},
        reward = {ndnr_roughrock = 5},
    }, {
        content = {
            zhs = "近期要办一个帽子展会，你那有多余的帽子吗？\n西瓜帽*1，冰块帽*1，猫帽*1，花环*1，海花环*1，饼干帽*1，羽毛帽*1",
            en = "There will be a hat exhibition in the near future. Do you have any extra hats?\nFashion Melon*1, Ice Cube*1, Cat Cap*1, Feather Hat*1\nCookie Cutter Cap*1, Garland*1, Seawreath*1",
        },
        list = {watermelonhat = 1, icehat = 1, catcoonhat = 1, featherhat = 1, cookiecutterhat = 1, flowerhat = 1, kelphat = 1},
        reward = {ndnr_roughrock = 7},
    }, {
        content = {
            zhs = "我们一家人准备出门野营，能给我准备点野营用品吗？\n草席卷*1，毛皮铺盖*1，帐篷卷*1",
            en = "Our family is going camping. Can you prepare some camping supplies for me?\nStraw Roll*1, Fur Roll*1, Tent Roll*1",
        },
        list = {bedroll_straw = 1, bedroll_furry = 1, portabletent_item = 1},
        reward = {ndnr_roughrock = 3},
    }, {
        content = {
            zhs = "薇诺娜找你还没回来，我需要点针线包来修补衣服\n针线包*3",
            en = "Winona hasn't come back yet. I need some sewing bags to mend my clothes\nSewing Kit*3",
        },
        list = {sewing_kit = 3},
        reward = {ndnr_roughrock = 3},
    }, {
        content = {
            zhs = "夏天太热了，如果有羽毛扇就好了。\n羽毛扇*2",
            en = "It's too hot in summer. If only there were feather fans.\nLuxury Fan*2",
        },
        list = {featherfan = 2},
        reward = {ndnr_roughrock = 4},
    }, {
        content = {
            zhs = "买椟还珠，你想试试自己的手气吗？\n彩虹宝石*1",
            en = "Do you want to try your luck?\nIridescent Gem*1",
        },
        list = {opalpreciousgem = 1},
        reward = {ndnr_roughrock = 10},
    }, {
        content = {
            zhs = "我想研究一下水中木，能否给我带来一些树果酱。\n树果酱*6",
            en = "I'd like to study whether a piece of wood in the water can bring me some tree jam.\nTree Jam*6",
        },
        list = {treegrowthsolution = 6},
        reward = {ndnr_roughrock = 6},
    }, {
        content = {
            zhs = "每天都忙着研究，都没时间照顾孩子了，要是有玩具就好了\n假卡祖笛*1，机器人玩偶*1，玩具木马*1，失衡陀螺*1，玩具眼镜蛇*1，鳄鱼玩具*1",
            en = "I'm busy with research every day. I don't have time to take care of my children.\nFake Kazoo*1, Lying Robot*1, Toy Trojan Horse*1\nUnbalanced Top*1, Toy Cobra*1, Crocodile Toy*1",
        },
        list = {trinket_2 = 1, trinket_11 = 1, trinket_18 = 1, trinket_19 = 1, trinket_42 = 1, trinket_43 = 1},
        reward = {ndnr_roughrock = 6},
    }, {
        content = {
            zhs = "找到了年轻时写的一首曲子，我想把它谱出来。\n低音贝壳钟*7，中音贝壳钟*7，高音贝壳钟*7",
            en = "I found a song written when I was young. I want to compose it.\nBaritone Shell Bell*7, Alto Shell Bell*7, Soprano Shell Bell*7",
        },
        list = {singingshell_octave3 = 7, singingshell_octave4 = 7, singingshell_octave5 = 7},
        reward = {ndnr_roughrock = 7},
    }, {
        content = {
            zhs = "查理，你好! 要弄明白暗影力量，我可能需要一些材料。\n铥矿*20，噩梦燃料*40，能量核*3，胡子*40，暗影心房*1",
            en = "Hello, Charlie! To understand shadow power, I may need some materials.\nThulecite*20, Nightmare Fuel*40, Energy Core*3, Beard Hair*40, Shadow Atrium*1",
        },
        list = {thulecite = 20, nightmarefuel = 40, ndnr_energy_core = 3, beardhair = 40, shadowheart = 1},
        reward = {ancient_altar_blueprint = 1},
    }, {
        content = {
            zhs = "新年到了，放点烟花爆竹庆祝一下。\n信号弹*5，红鞭炮*5",
            en = "The new year is coming. Let off some fireworks to celebrate.\nRed Firecrackers*5, Flare*5",
        },
        list = {firecrackers = 5, miniflare = 5},
        reward = {ndnr_roughrock = 5},
    }, {
        content = {
            zhs = "查理，你好！你让我研究旧神们的科技还缺点材料，麻烦帮我收集一下。\n彩虹宝石*1，铥矿*5，噩梦燃料*20",
            en = "Hello, Charlie! You asked me to study the technology of the old gods. \nThere are still some shortcomings. Please help me collect them.\nIridescent Gem*1, Thulecite*5, Nightmare Fuel*20",
        },
        list = {opalpreciousgem = 1, nightmarefuel = 20, thulecite = 5},
        reward = {ndnr_opalpreciousamulet_blueprint = 1},
    }
}

TUNING.NDNR_LOADINGTIPS = {
    {
        id = "NDNR_TIP_ACORN",
        tipstring = {
            zhs = "\"没有吃的了？摘点桦栗果烤烤吃。\" - 富贵",
            en = "\"No food? Pick some acorn and roast it.\" - DR",
        }
    },
    {
        id = "NDNR_TIP_DEERCLOPS",
        tipstring = {
            zhs = "\"巨鹿来了不要急着杀，养起来有大用。\" - 富贵",
            en = "\"Don't hurry to kill the giant deer when deerclops come. It's of great use to raise them.\" - DR",
        }
    },
    {
        id = "NDNR_TIP_ICEMILK",
        tipstring = {
            zhs = "\"鹿奶最初是从巨鹿身上挤的，所以现在它还有冰属性设定。\" - 富贵",
            en = "\"Deer milk was originally squeezed from giant deer, so now it has ice attribute setting.\" - DR",
        }
    },
    {
        id = "NDNR_TIP_MAGMA",
        tipstring = {
            zhs = "\"岩浆不止能升温照明，还能用来烤食物。\" - 富贵",
            en = "\"Magma can not only heat up and illuminate, but also be used to roast food.\" - DR",
        }
    },
    {
        id = "NDNR_TIP_MAGMA2",
        tipstring = {
            zhs = "\"雨露值太高又没有火堆，试试把岩浆扔在脚下。\" - 富贵",
            en = "\"The rain value is too high and there is no fire. Try throwing the magma under your feet.\" - DR",
        }
    },
    {
        id = "NDNR_TIP_GLOMMER",
        tipstring = {
            zhs = "\"格罗姆很喜欢喝奶，但它的肠胃有点不好。\" - 富贵",
            en = "\"Glommer likes milk very much, but his stomach is a little bad.\" - DR",
        }
    },
    {
        id = "NDNR_TIP_MILK",
        tipstring = {
            zhs = "\"牛奶很有营养，小心乳糖不耐受哦！\" - 富贵",
            en = "\"Milk is very nutritious. Beware of lactose intolerance!\" - DR",
        }
    },
    {
        id = "NDNR_TIP_PARASITE",
        tipstring = {
            zhs = "\"肉一定要烤熟了再吃，这样才不容易感染寄生虫。\" - 富贵",
            en = "\"Meat must be roasted before eating, so it is not easy to infect parasites.\" - DR",
        }
    },
    {
        id = "NDNR_TIP_GOUT",
        tipstring = {
            zhs = "\"在食谱里可以查看哪些料理会增加痛风风险。\" - 富贵",
            en = "\"In the cookbook, you can see which dishes will increase the risk of gout.\" - DR",
        }
    },
    {
        id = "NDNR_TIP_BOUNTY",
        tipstring = {
            zhs = "\"你在永恒大陆上的所作所为查理都知道，小心点。\" - 富贵",
            en = "\"Charlie knows what you've done on the eternal continent. Be careful.\" - DR",
        }
    },
    {
        id = "NDNR_TIP_WX78",
        tipstring = {
            zhs = "\"发条生物似乎将WX-78视为同类。\" - 富贵",
            en = "\"Clockwork creatures seem to regard wx-78 as similar.\" - DR",
        }
    },
    {
        id = "NDNR_TIP_WEATHERPOLE",
        tipstring = {
            zhs = "\"问蚁狮《借》的第一根天候棒你会给它什么宝石激活？我会先给蓝宝石\" - 火鸡",
            en = "\"<borrow> the first weather pole from antlion. What gem will you give it to activate? I'll give bluegem first - PY",
        }
    },
    {
        id = "NDNR_TIP_POND",
        tipstring = {
            zhs = "\"冬天种地没水怎么办？可以拿镐子把池塘上的冰刨开！\" - 富贵",
            en = "\"What if there is no water for farming in winter? You can use a pickaxe to scrape the ice off the pond!\" - DR",
        }
    },
    {
        id = "NDNR_TIP_TREEHOLE",
        tipstring = {
            zhs = "\"不想要的东西都可以给水中木。\" - 富贵",
            en = "\"Anything you don't want can be given oceantree.\" - DR",
        }
    },
    {
        id = "NDNR_TIP_PIGDRINK",
        tipstring = {
            zhs = "\"猪人酒品不好，轻易不要跟猪人喝酒。\" - 富贵",
            en = "\"Pigman wine is not good. Don't drink with pigman easily.\" - DR",
        }
    },
    {
        id = "NDNR_TIP_HIVEHAT",
        tipstring = {
            zhs = "\"戴上蜂王冠，你就是蜂后。\" - 富贵",
            en = "\"Put on the bee crown, you are the bee queen.\" - DR",
        }
    },
    {
        id = "NDNR_TIP_PALMTREE",
        tipstring = {
            zhs = "\"绿洲有水的时候，椰子树也会发芽。\" - 富贵",
            en = "\"Coconut trees sprout when there is water in the oasis.\" - DR",
        }
    },
    {
        id = "NDNR_TIP_SNAKEOIL",
        tipstring = {
            zhs = "\"蛇油对青蛙来说，有剧毒。\" - 富贵",
            en = "\"Snake oil is highly toxic to frogs.\" - DR",
        }
    },
    {
        id = "NDNR_TIP_TOADTOOL",
        tipstring = {
            zhs = "\"蘑菇酒对于毒菌蟾蜍来说简直就是洞穴美味，以至于都忘了种树来保护自己。\" - 富贵",
            en = "\"Mushroom wine is so delicious for toads that they forget to plant trees to protect themselves.\" - DR",
        }
    },
    {
        id = "NDNR_TIP_SEAFOOD",
        tipstring = {
            zhs = "\"海鲜吃多了夜间痛风犯了怎么办？喝杯酸奶缓解一下。\" - 富贵",
            en = "\"How to do if you have too much seafood and gout at night? Drink a cup of yogurt to relieve it.\" - DR",
        }
    },
    {
        id = "NDNR_TIP_WX78_2",
        tipstring = {
            zhs = "\"机器人由于身体结构的不同，使得他能免疫各种毒素。\" - 富贵",
            en = "\"Due to the different body structure of wx78, it can be immune to various toxins.\" - DR",
        }
    },
    {
        id = "NDNR_TIP_WEBBER",
        tipstring = {
            zhs = "\"韦伯由于一些众所周知的原因，似乎能与寄生虫共生。\" - 富贵",
            en = "\"Webber seems to be symbiotic with parasites for some well-known reasons.\" - DR",
        }
    },
    {
        id = "NDNR_TIP_WAGSTAFF",
        tipstring = {
            zhs = "\"大科学家似乎与查理在私下进行着不可告人的交易。\" - 富贵",
            en = "\"The wagstaff seems to have a secret deal with charlie in private.\" - DR",
        }
    },
    {
        id = "NDNR_TIP_CHARLIE_GUARD",
        tipstring = {
            zhs = "\"走夜路时是不是总感觉背后有什么\"东西\"，可能是查理守卫正在做任务。\" - 富贵",
            en = "\"When walking at night, do you always feel that there is something behind you? It may be that charlie guard is doing a task.\" - DR",
        }
    },
    {
        id = "NDNR_TIP_SHADOWHEART",
        tipstring = {
            zhs = "\"暗影心房能赋予某些东西生命，比如拼好的骨架，火腿棒，坎普斯背包等。\" - 富贵",
            en = "\"Shadow Heart can give life to some stuff, such as assembled skeleton, hambat, krampus sack and so on.\" - DR",
        }
    },
}


























