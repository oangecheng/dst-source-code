local STRINGS = GLOBAL.STRINGS


--图鉴相关的 都在这里
STRINGS.MYTH_BOOINFO = {

    DUIHUAN = "兑换列表",
    GEIYU = "可给予",
    HUODE = "可获得",
    NOPLAYER = "人物传记已丢失，启用角色mod方能找回残页",
    FILTER_ALL = "全部",
    YONGJIU = "永久",
    LONGER = "很长",
    HUOQU = "获取方式",

    --神仙
    SHENXIAN = {
        laozi = {
            title = "道德天尊，太上道祖\n燃烧急急如律令来召唤老君，可将珍贵材料或道具跟其换丹药或法宝。兑换次数有限，每次召唤后需要三日冷却。\n老君不与妖孽交易!",
        },
        ghg = {
            title = "广寒宫的主人,深居月宫数千年。\n非常欢迎且期待来到广寒宫的客人，\n夜晚嫦娥要歇息,只会在白天招待客人。\n可以赠与嫦娥珍贵的宝石或仙种大蟠桃\n增加好感,嫦娥也许会用月饼来回赠客人。",
        },
        tudi = {
            title = "居于地下唯一的土地爷。\n建造土地庙供上贡品，土地公便会出现照顾与保护农田土地。身小能干,保佑土地连年丰收。法力微薄遇到危险会遁地逃离。\n喜好拾取地上的石类物品。",
            text1 = "照顾范围",
            text2 = "以土地庙为中心\n半径为4地皮的圆",
            text3 = "贡品类型",
            text4 = "肉料理,素料理，零食料理",
            text5 = "土地出现的时间",
            text6 = "放置贡品后的5天\n白天与黄昏",
        },
        ylw = {
            title = "统领阴间十八层地狱的冥王。\n使用酆都路引召唤阎罗王虚影，阎罗王可以镇压范围内善恶魂的暴动，也可以交付善恶魂来回复三维。",
        },
        mp = {
            title = "掌管将生魂抹去记忆的阴使。\n使用酆都路引召唤孟婆虚影，孟婆会吸收范围内善恶魂，也可以给予孟婆善恶魂，孟婆收满一定数量的善恶魂后会留给玩家一碗忘却前世的茶汤—孟婆汤。",
        },
        cj = {
            title = "冥府阴律司判官。\n使用酆都路引召唤崔珏虚影，崔珏会吸收范围内善恶魂，也可以给予崔珏善恶魂，崔珏收到大量的善恶魂后会留给玩家一本掌控生死的鬼书—生死簿。",
        },
        lzd = {
            title = "冥府察查司判官。\n使用酆都路引召唤陆之道虚影，陆之道会对范围内吸进无常官帽的魂魄进行善与恶的转换，也可以交付魂魄进行善与恶的转换。",
        },
        zk = {
            title = "冥府罚恶司判官。\n使用酆都路引召唤钟馗虚影，钟馗可以镇压范围内恶魂的暴动，镇压后能够提供范围内的玩家三维回复，也可以交付恶魂来回复三维。",
        },
        wz = {
            title = "冥府赏善司判官。\n使用酆都路引召唤魏征虚影，魏征可以镇压范围内善魂的暴动，镇压后能够短暂提高范围内的玩家的攻击，也可以交付善魂来回复三维。",
        },
    },
    --妖怪
    YAOGUAI = {
        blackbearger = {
            title = "偷窃袈裟的熊罴怪,一身黑，力大无穷。\n一掌便能撼地成山,还能化作黑风席卷。\n喜好蜂蜜 袈裟与丹药,随身携带丹药葫芦。",
            text1 = "生成方式",
            text2 = "在混合地形会生成蜜罐,蜜罐可填充蜂蜜\n或蜂王浆,填满后会吸引黑风大王袭来。",
            text3 = "注意事项",
            text4 = "黑风大王力大无比伤害奇高且会击飞武器!\n如果长时间脱战,黑风大王将化风离场。\n刷新时间:20天",
            text5 = "战利品",
        },
        sxn = {
            title = "辟寒辟暑辟尘三大王,每年元宵都趁人们\n观灯猜谜时偷吃灯油。莫要小瞧这三兄弟。\n打起架来可是毫不留情,法力高强还仗着\n人多势众。",
            text1 = "生成方式",
            text2 = "海上的青竹洲会刷\n出一座破旧的供台,\n在春夜献上蟠桃并\n点燃烛火便可招来\n犀牛三大王。",
            text3 = "注意事项",
            text4 = "三犀牛各个都有擅长的法术,并且很有战斗头脑\n擅长互相分工轮流作战，当场面对他们有利时\n容易放松警惕。场面不利时拼起老命可是万分\n恐怖!当对手逃远或逃至海上他们便会脱战离去。\n刷新时间:下一年春季",
            text5 = "战利品",
        },
        myth_goldfrog = {
            title = "深居月亮的聚宝金蟾，终日藏于地下，\n守着自己无穷无尽的财宝。\n据说其里有可以源源不断生产财宝的聚宝盆\n与摇钱树",
            text1 = "生成方式",
            text2 = "月宫外围寒冷的土地上\n立着一座闪闪发光的\n元宝雕像。\n试图偷采财宝的玩家会\n吵醒愤怒的聚宝金蟾",
            text3 = "注意事项",
            text4 = "聚宝金蟾皮厚肉硬,还会大量挥洒财宝召唤\n小金蟾攻击贪婪的玩家。面对多人时会大口吞下\n玩家来直接腐蚀掉玩家的护甲!\n面对唯唯诺诺的玩家容易脱战,直接遁地离去。\n刷新时间:20天",
            text5 = "战利品",      
        },
        zgxn = {
            title = "身着一层富含生命能量金属的天生玄鸟，\n喜食莲花，传闻其曾经居住并守护着\n一座被生命金属覆盖的岛屿。歌声洪亮\n仅一声鸣啸便能让起坏心思的人们丢盔弃甲",
            text1 = "生成方式",
            text2 = "极其罕见的玄鸟\n会被盛开的莲花吸引\n落凡。在盛开的莲池\n旁小几率现身。\n",
            text3 = "注意事项",
            text4 = "性格温顺，食用完莲花不久便会离去。\n切忌将其激怒。\n激怒后冷却时间：10天",
            text5 = "玄鸟的馈赠",     
            text6 = "子圭石\n一种具有生命的稀少金属矿石。",     
        },
        nian = {
            title = "传说中会带来灾厄的年兽，\n头长犄角，尖牙利齿，目光凶狠，\n生性残暴，长年深居海底，每到除夕会上岸\n入侵小镇，吞噬牲畜，伤人害命。",
            text1 = "生成方式",
            text2 = "在冬天倒数第二天的傍晚，\n灾厄年兽会入侵\n建有小市的青竹洲，\n出现在供台附近。\n",
            text3 = "注意事项",
            text4 = "年兽喜欢吞噬弱小的生物来滋补自己，\n会传染厄运使玩家变得虚弱，受伤严重时会进行自我回复，\n比较害怕鞭炮和火焰，进入春季便会离去。\n没有成功驱逐，青竹洲小市会丢失货物\n并停止进货五天(成功驱逐三犀牛会提前结束)。\n刷新时间：下一年冬天倒数第二天的傍晚",
            text5 = "战利品",     
            text6 = "小镇\n贺年", 
            text7 = "成功驱逐年兽，青竹洲小市打折五天，\n天黑不闭市至春季结束(三犀牛入侵会提前结束)。",     
        },
    },

    --地形
    DIXING = {
        taoyuan = {
            title = "地图上会在随机位置生成一座与与世隔绝的桃花源,桃花源内的野生蟠桃树会自行再生。玩家通过采集可获得蟠桃另外有较小几率获得大蟠桃，玩家可将大蟠桃种在地上培育蟠桃树。蟠桃树生长周期较慢，不可催熟，但在冬天依旧可以生长。毁坏桃树会招来坎普斯。击杀坎普斯有几率掉落少量蟠桃。",
            text1 = "灵台方寸山",
            text2 = "世外桃源 孤僻仙山\n妙法破禁 四方灯开\n方能进入须菩提故居\n可习得飞行术等技能", 
            text3 = "蟠桃树", 
            text4 = "蟠桃树，桃源的特有植物\n可以收获蟠桃和大蟠桃\n毁坏桃林会发生不详的事情",      
        },
        yuegong = {
            title = "在地图上靠外围随机位置会生成一片纯洁的月亮“碎片”。终年飘雪寒冷无比。在这片碎片上中心有一座高雅的宫殿。在其外围的寒冷土地上,还立着一座奇怪的金元宝雕像。",
            text1 = "广寒宫",
            text2 = "月宫中心的一座宫殿内\n居住着嫦娥仙子\n只能在白天进入\n且得在夜晚前离开", 
            text3 = "金元宝", 
            text4 = "聚宝金蟾在此冬眠。打扰它休息的人\n会受到严厉惩罚!若周围再无威胁,\n金蟾会无心恋战,立刻逃脱。\n20天后才会再次现身。",           
        },
        zhulin = {
            title = "在地图靠外围随机位置会生成一片被青竹林覆盖的洲屿。洲屿一角的小镇里住着一群抱德炀和的居民。另一角原为居民供奉先祖的场所，据说如今已被妖怪占去并设下供台，要求居民每年春天上供求和。",
            text1 = "莲花",
            text2 = "莲花生长在池塘里，春生秋熟，夏荣冬灭。用剃刀可以收获莲叶。莲花盛开会吸引罕见的子圭玄鸟降世，玄鸟会留下象征生命力量的子圭石作为馈赠。供奉莲花给玄鸟以佑平安，可以获得更多的子圭石。可远观而不可亵玩。",     
            text3 = "破旧的供桌", 
            text4 = "犀牛三大王占领了青竹洲居民祭祀先祖的场所\n设下供台，每年春天上元佳节，便前来索要贡品。\n在春夜献上蟠桃点亮烛火便可招来犀牛三大王",
            text5 = "竹子", 
            text6 = "生长在青竹洲的竹子修长挺拔，四季青翠，喜欢成片生长，在雨水充沛的春季繁殖速度极快，是极好的造纸材料。竹子有多个生长阶段，鲜嫩的竹笋可口美味，使用竹子烹饪的食物更是别有一番风味，成竹有可能会继续生长成坚硬苍竹。使用苍竹搭建房子是个不错的选择。",    
            text7 = "青竹小镇", 
            text8 = "守护者雕像",
        },
        renshenguo = {
            title = "在算命小铺中购买的藏宝线索有可能寻得一颗被推倒的枯树根，被推倒的枯树根在井中经过玉净瓶中甘露水的滋润、日月精华的熏陶、玩家的悉心照料会长成参天的人参果树，人参果树每隔七七四十九天会长出传闻食用后可长生不老的人参果。",
            text1 = "人参果树",
            text2 = "高耸入云的人参果树提供大范围的树荫，树荫之下不怕风吹雨淋，不怕烈阳暴晒，不怕电闪雷鸣。结出的果子遇金而落，遇木而枯，遇水而化，遇火而焦，遇土而入。人参果树极难被破坏，唯火焰可烧毁之。",
        },
    },

    ITEM_TYPE = { --类型
        renwu  = "人物",
        dixing = "地形",
        lianzhi = "炼制",
        shenhua = "神话",
        shenxian = "神仙",
        yaoguai = "妖怪",

        xiandan = "仙丹",
        fabao = "法宝",
        cailiao = "材料",
        zhuangbei = "装备",
        jianzhu = "建筑",
        gongju = "工具",
        shiwu = "食物",
        jineng = "技能",
        feixingshu = "飞行术",
    },

    ITEM_DES = {--物界面描述
        heat_resistant_pill = "免疫火焰，免疫高温过热！",
		cold_resistant_pill = "免疫潮湿，免疫低温过冷！",
		dust_resistant_pill = "免疫沙尘风暴的影响！",
		fly_pill = "获得风驰电掣般的速度提升！\n使用之后改变飞行术的配方",
		bloodthirsty_pill = "获得恐怖的吸血能力，小心反噬！",
		armor_pill = "获得防御加持，受到伤害减半！",
		condensed_pill = "战斗力提升，攻击力翻倍",
        thorns_pill = "可免疫植物的伤害并保护你！",
		movemountain_pill = "获得神力身负重物依然健步如飞！",
		bananafan_big = "阴阳双生，一扇便荡尽火焰！ ",
		laozi_sp = "将符咒放在地上点燃召唤老君！",
		mk_huoyuan = "锁子黄金甲炼制材料",
		mk_longpi = "锁子黄金甲炼制材料",
		mk_hualing = "凤翅紫金冠炼制材料！",
		purple_gourd = "吸入选定区域内的地面物品和小生物！",
		myth_yjp = "浇灌施肥，复活作物，吸收雨水！",
		myth_passcard_jie = "有教无类，\n妖精持此令可与太上老君交易！",
		laozi_bell = "太上老君为青牛铸造的铃铛！",
		saddle_qingniu = "太上老君为青牛铸造的牛鞍！",
		myth_weapon_syf = "攻击附带冰冻，\n可施展技能寒冰横扫！",
		myth_weapon_syd = "攻击次数越多伤害越高，\n可施展技能炙热重斩！",
		myth_weapon_gtt = "攻击具有范围伤害，\n可施展技能蓄力重锤",
		
		siving_stone = "七星剑、子圭装备炼制材料！",
		myth_qxj = "秒杀暗影生物，但无掉落物，\n可施展技能一尺寒光！",
		siving_hat = "减伤恢复精神，\n降低装备耐久消耗！",
		armorsiving = "减伤恢复精神，\n阳光下自我修复耐久！",
		myth_fuchen = "增加移速，消除生物仇恨，\n可以施展技能隔空取物！",
		
		yangjian_armor = "抵挡八成半伤害，提高移动速度，\n具有防水抗冻效果！",
		yangjian_hair = "降低技能消耗，缩短技能冷却，\n击杀怪物恢复理智！",
		golden_armor_mk = "抵挡八成半伤害，提高两成攻击，\n具有霸体效果！",
		golden_hat_mk = "降低技能消耗，提升技能威力，\n击杀怪物恢复理智！",
		
		book_myth = "东方神话之书，解锁神话科技，\n点燃后成为天书图鉴！",
		alchmy_fur = "放入正确材料可炼制丹药或道具，\n放入错误后果不堪设想！",
		myth_cash_tree_ground = "源源不断生财的宝贝，\n每两天会掉落一份财宝！",
		cassock = "提供精神恢复，减少食物渴望！",
		kam_lan_cassock = "预防影怪，缓慢恢复精神，\n减少饱食度消耗！",
		mk_battle_flag = "提升攻击力，增加移速，\n可缓慢恢复精神！",
		xzhat_mk = "保暖，缓慢恢复精神！",
		pill_bottle_gourd = "可储存8格丹药，\n丹药在葫芦中不起作用不消耗耐久！",
		wine_bottle_gourd = "直接饮用恢复三维，\n可使用蟠桃素酒补充耐久！",
		myth_zongzi = "可手持，丢入海中吸引鱼类，\n打开后食用可恢复三维！",
		myth_redlantern = "照明，易燃，易被破坏，\n可手持，亦可悬挂在灯笼架上！",
		myth_bbn = "需在月圆之夜吸收月光充能，\n使用后将额外拥有9格空间！",
		myth_fence = "好看的大屏风！",
		myth_interiors_ghg_flower = "好看的盆景！",
		myth_interiors_ghg_groundlight = "好看的宫灯，提供照明！",
		myth_interiors_ghg_he_left = "美丽的仙鹤摆饰！",
		myth_interiors_ghg_he_right = "美丽的仙鹤摆饰！",
		myth_interiors_ghg_lu = "好看的香炉！",
		myth_redlantern_ground = "可以悬挂两个灯笼！",
		myth_ruyi = "易碎，快速采摘桃树，\n提升大蟠桃掉率！",
		myth_yylp = "靠近解锁天体科技，夜间发光照明，\n仅有一个，不可带下线！",
		myth_mooncake_ice = "食用后锁定精神值一天，\n不可叠加！",
		myth_mooncake_lotus = "食用后不挑食一天，且无减益效果，\n不可叠加！",
		myth_mooncake_nuts = "食用后锁定饱食度一天，\n不可叠加！",
		
		lotus_flower = "可以作为食材，\n可以补充混天绫耐久！",
	    lotus_seeds = "可以直接食用或作为食材！，\n种在池塘里，长出莲花！",
		lotus_seeds_cooked = "可以直接食用或作为食材！",
        lotus_root = "可以直接食用或作为食材！",
        lotus_root_cooked = "可以直接食用或作为食材！",
        myth_lotusleaf = "可以作为食材\n可直接手持当伞！",
		
        myth_bamboo = "基础材料，可作为食材入锅！",
		myth_greenbamboo = "珍贵材料！",
		myth_bamboo_shoots = "可以直接食用或作为食材，\n可以播种在地长成竹子！",
		myth_bamboo_shoots_cooked = "可以直接食用或作为食材！",
		bigpeach = "好吃的不得了！",
		peach = "可直接食用，\n可作为食材，可以在火堆烹饪！",
		peach_cooked = "可直接食用，\n可作为食材！",
		gourd = "农作物，适合秋季生长！",
		gourd_cooked = "可直接食用，\n可作为食材！",
		myth_banana_leaf = "可用于制作蕉叶包裹，\n可作为食材！",
		myth_bundle = "一次性打包袋！",
		myth_cash_tree = "摇钱树制作材料，仅有一棵！",
		myth_coin = "可作为商店的货币使用！",
		myth_food_table = "可以摆放八种料理食物，永久保鲜！",
		myth_granary = "可以长时间存放蔬菜以及种子，易燃！",
		myth_toy = "放置在地面提升年味度，\n与猪王换取元宝！",
		myth_tudi_shrines = "供奉荤食、素食、零食料理，\n召唤土地照料作物5天！",
		myth_well = "冬天不结冰，不可钓鱼，\n可扑灭闷烧、水壶接水！",
		myth_banana_tree = "可以收获香蕉以及芭蕉叶！",
		bananafan = "炼制芭蕉宝扇的材料，\n呼风唤雨！",
		myth_rhino_blueheart = "炼制辟寒丹、霜钺斧的材料！",
		myth_rhino_redheart = "炼制辟暑丹、暑熤刀的材料！",
		myth_rhino_yellowheart = "炼制辟尘丹、扢挞藤的材料！",
		siving_rocks = "炼制子圭青金的材料！",
		krampussack_sealed = "炼制紫金葫芦的材料！",
		myth_huanhundan = "喂食灵魂出窍队友身躯，\n可召回队友灵体！ ",
		myth_coin_box = "一大串铜钱！",
	    myth_mooncake_box = "装上美味的月饼！",

		myth_flyskill = "飞起来了，小心别摔着！",

		myth_flyskill_mk = "这一个筋斗就是十万八千里，快哉！",
		mk_dsf = "定住全屏范围内对自己有仇恨的生物！",
		mk_jgb = "孙悟空专属武器，攻击距离长，\n可用于施展技能身外身法！",

		nz_lance = "哪吒专属武器，火属性伤害加倍，\n可用于施展技能三头六臂！",
    	nz_ring = "哪吒专属武器，远程，\n可反弹多个目标！",
	    nz_damask = "哪吒专属装备，增加移速，\n免疫伤害，使用莲花补充耐久！",
	    myth_flyskill_nz = "脚下炽焰灼灼，抵御火焰！",
	    
	    bone_blade = "攻击自带吸血，\n使用骨片修复耐久！",
	    bone_wand = "召唤骨刺控制敌人并造成伤害，\n使用骨片修复耐久！",
	    bone_whip =  "范围伤害，攻击自带吸血，\n使用骨片修复耐久！",
	    wb_heart = "白骨夫人使用后进入鬼魂状态，留下骨架！",
	    myth_flyskill_wb =  "隐入阴风中，无法被察觉，无法攻击！",

		pigsy_hat = "保暖，提高防御力，\n防雨，缓慢恢复精神！",
	    pigsy_rake = "八戒专属武器，\n可用于格挡伤害以及耕地！",
	    pigsy_sleepbed = "八戒的小窝，随时随地睡觉，\n消耗饱食度，恢复精神以及生命！",
	    myth_flyskill_pg = "软绵绵节省脚力不那么担心饿肚子了！",
	    myth_pigsyskill_bookinfo = "变身获得缓慢回血能力和极高的防御，\n能嘲讽敌人，能下海游泳！",

	    yj_spear = "杨戬专属武器，召唤天雷，\n可用于施展技能驱雷掣电！",
	    myth_flyskill_yj = "此云雷电缠绕，犯我者必有苦头！",
	    yangjian_track = "可直接飞至特殊标记点或队友身边！",
        
	    medicine_pestle_myth = "玉兔专属武器，\n可用于捣药！",
	    guitar_jadehare = "学会琵琶曲后弹奏可产生BUFF音符，\n玩家触摸音符可获得该BUFF加持！",
	    myth_bamboo_basket = "装上满满当当的药材！",
	    myth_flyskill_yt = "冰冰凉的云朵，散发着沁人心脾的药香！",

	    bone_mirror = "换上瑰丽的披风，\n获得极致的能力！",

	    --白骨披风
	    wb_armorbone = "以不再吸血为代价获得防御之力！",
	    wb_armorblood = "吸血能力加强，是更多鲜血的味道！",
	    wb_armorlight = "轻盈如风，提高移动速度！",
	    wb_armorgreed = "获得额外物品概率增加，\n小骷髅、尸体停留时间增加！",
	    wb_armorstorage = "额外携带8格物品，\n会自动拾取格子内已有的物品！",
	    wb_armorfog = "迷雾之中各项能力大幅提升，\n同时骨刃获得技能【雾隐】！",

	    hat_commissioner_white = "用于吸收和储存善魂与恶魂，\n具有一定防雨效果！",
	    bell_commissioner = "消耗善魂催眠周围生物，\n并短暂降低生物攻击力和移速！",
	    token_commissioner= "消耗恶魂让附近生物进入惊恐状态！",
	    pennant_commissioner= "消耗善魂召唤恩魂战斗！",
	    whip_commissioner= "身上恶魂越多，攻击力越高，攻速越低！",
	    soul_specter= "善良的魂魄，\n数量过多造成小范围生物催眠！",
	    soul_ghast= "罪恶的魂魄，\n数量过多会变成怨魂暴动！",
	    myth_yama_statue1 = "交付魂魄获得三维恢复，缩短魂魄重聚时间，\n等级越高能力越强，食物收益越少！",
	    myth_cqf = "使用后原地留下躯体，进入灵魂出窍状态！",
	    myth_higanbana_item = "队友死亡时会盛开，\n可将死亡队友的鬼魂传送回身边！",
	    myth_bahy = "盛开的彼岸花，接引附近的亡魂再次回到世间！",

	    myth_flyskill_ya = "鬼火萦绕，移形换影，无法攻击，无法被攻击！",

	    powder_m_becomestar = "较长时间的发光，玉兔捣药为群体效果，\n给予嫦娥发光浆果解锁配方！",
		powder_m_charged = "短时间攻击带电，玉兔捣药为群体效果，\n给予嫦娥电羊角解锁配方！",
		powder_m_coldeye = "短时间攻击附带冰冻，玉兔捣药为群体效果，\n给予嫦娥巨鹿眼球解锁配方！",
		powder_m_hypnoticherb = "回复大量血量且催眠周围生物，\n玉兔捣药为群体效果，\n给予嫦娥曼德拉草解锁配方！",
		powder_m_improvehealth = "回复部分血量后且短时间缓慢回血，\n玉兔捣药为群体效果，\n给予嫦娥蜂王浆解锁配方！",
		powder_m_lifeelixir = "满状态复活队友，玉兔捣药为群体复活，\n给予嫦娥守护者之角解锁配方！",
		powder_m_takeiteasy = "回复部分精神后且短时间缓慢回复精神，\n玉兔捣药为群体效果，\n给予嫦娥舒缓茶解锁配方！",

		song_m_workup = "弹奏产生buff音符，\n拾取音符后工作效率暂时提升",
		song_m_insomnia = "弹奏产生buff音符，\n拾取音符后暂时不会被催眠！",
		song_m_fireimmune = "弹奏产生buff音符，\n拾取音符后暂时免疫火焰伤害！",
		song_m_iceimmune = "弹奏产生buff音符，\n拾取音符后暂时免疫冰冻封印！",
		song_m_iceshield = "弹奏产生buff音符，拾取音符后\n短时间内受到攻击时可使敌人叠加冰冻！",
		song_m_nocure = "弹奏使附近敌人暂时失去自愈能力！",
		song_m_weakattack = "弹奏使附近敌人的攻击力暂时降低！",
		song_m_weakdefense = "弹奏使附近敌人的防御力暂时降低！",
		song_m_nolove = "弹奏使附近牛群暂时不会发情！",
		song_m_sweetdream = "弹奏使附近敌人进入睡眠！",

	    madameweb_stinger = "一次性的远程武器！",
	    madameweb_poisonstinger = "淬上致命毒素的蜂针！",
		madameweb_armor = "减少蛛丝值的消耗，拥有2格专属物品格子，\n可保暖，可使用蛛丝回复耐久！",
		madameweb_poisonbeemine = "每日孕育一毒蛛，可用肉召唤毒蛛出来，\n也可将毒蛛放回巢中休养！",
		madameweb_beemine = "触发后会飞出毒蜂攻击敌人！",
		madameweb_detoxify = "解除中毒状态！",
		madameweb_net = "可以安置在地上，会往外扩张蛛网地皮！",
		madameweb_pitfall = "将靠近的生物束缚成茧，茧破裂后会使生物中毒！",
		madameweb_feisheng = "适合在地洞以及树荫下穿梭！",
		madameweb_silkcocoon = "打包萤火虫悬挂于树荫和地洞照明！",
		hua_internet_node_item = "放置地上变成盘丝标点,\n使用蛛丝连接标点进行滑行！",
		hua_internet_node_sea_item = "放置海上变成盘丝标点,\n使用蛛丝连接标点进行滑行！",
		hua_fake_spider_shoe = "携带即可在盘丝滑索上滑行，\n快速行走于蛛网之上",

		myth_stool = "坐在小凳子上休息会！",
		myth_coldessense = "培育人参果树的材料！",
		myth_fireessense = "培育人参果树的材料！",
		nian_bell = "喂饱后摇响铃铛可召唤年兽坐骑！",
		cane_peach = "提高移动速度，右键【弃杖化林】\n可化作小片桃林！",
		myth_gold_staff = "用于采摘人参果和蟠桃，\n也会提高大蟠桃掉率！",
		myth_nianhat = "七成防御，进食有概率\n不消耗食物且获得双倍收益！",
		infantree_carpet = "华丽的人参果地毯！",
		wall_dwelling_item = "古朴的白墙黑瓦！",
		fence_bamboo_item = "精美的竹制栅栏！",
		fence_gate_bamboo_item = "精美的竹制门！",
		myth_rocktips = "在地上摆上精致的鹅卵石装饰！",
		myth_nian_fur = "制造年兽面具的材料！",
		myth_iron_broadsword = "精铁铸造的长刀，拥有51点伤害！",
		myth_iron_battlegear = "精铁铸造的甲胄，拥有八成的防御！",
		myth_iron_helmet = "精铁铸造的头盔，拥有八成的防御！",
		myth_house_bamboo = "古色古香的竹林瓦屋！",
		miniflare_myth = "绚丽的烟花增添一些年味儿！",
		firecrackers_myth = "燃放爆竹增添一些年味儿，\n还可以协助驱逐灾厄年兽！",
		myth_infant_fruit = "食用后获得生命持续回复至生命少于三分之一，\n遇金而落，遇木而枯，遇水而化，遇火而焦，遇土而入！",
		pass_commissioner = "传信接引地府神仙的虚影！",
		commissioner_mpt = "饮用后身化彼岸花直接原地转世重生，\n重生时物品将保留在彼岸花中！",
		commissioner_book = "查询全体玩家的状态并选择复活逝去玩家，\n也可复活残存魂魄虚影的生物！",


    },
	
	ITEM_RECIPE_DES = { --物品获取方式/配方描述
	    myth_yylp = "与嫦娥好感度达到最高时，嫦娥赠予！",
		myth_mooncake = "给予嫦娥仙子宝石、大蟠桃等有几率获得！",
		
		lotus_flower = "哪吒剔骨削肉获得，\n用剃刀采摘开花阶段莲花珠获得！",
	    lotus_seeds = "剥开莲花，收获莲子！",
		lotus_seeds_cooked = "在火堆烹饪莲子获得！",
		lotus_root = "采摘枯萎阶段莲花株获得！",
		lotus_root_cooked = "在火堆烹饪莲藕获得！",
		myth_lotusleaf = "用剃刀采摘开花阶段莲花株获得！",
		
		myth_bamboo = "砍伐成竹、苍竹可以获得！",
		myth_greenbamboo = "砍伐苍竹可以获得！",
		myth_bamboo_shoots = "下雨后，成竹附近有几率长出竹笋！",
		myth_bamboo_shoots_cooked = "竹笋在火堆烹饪获得！",
		bigpeach = "采集桃树有几率掉落\n击败克劳斯也能获得一个！",
		peach = "采摘桃树",
		peach_cooked = "蟠桃在火堆烹饪获得",
		gourd = "种植种子获得，\n克劳斯包裹获得！",
		gourd_cooked = "葫芦在火堆烹饪获得",
		myth_banana_leaf = "采集芭蕉树掉落\n拆开蕉叶包裹也能获得一个！",
		myth_cash_tree = "第一次击退聚宝金蟾获得",
		myth_coin = "神话玩具与猪王交易可获得，\n击杀特定怪物获得，\n摇钱树掉落！",
		myth_toy = "与土地交易获得，\n击杀克劳斯获得，\n聚宝盆有几率获得！",
		bananafan = "使用羽毛扇和太上老君换取！",
		myth_rhino_blueheart = "辟寒大王掉落！",
		myth_rhino_redheart = "辟暑大王掉落！",
		myth_rhino_yellowheart = "辟尘大王掉落！",
		siving_rocks = "子圭玄鸟偷吃莲花株的莲花后遗落，\n给予子圭玄鸟莲花有几率获得！",
		krampussack_sealed = "使用急急如律令封印坎普斯背包！",
		myth_coin_box = "使用绳子串起40个铜钱！",

		myth_huanhundan = "使用救赎之心和太上老君换取\n聚宝盆有几率获得！",
	    soul_specter= "中立生物掉落",
	    soul_ghast= "邪恶生物与boss掉落！",
		
		mk_jgb = "孙悟空出生自带",
		nz_zhuangbei_recipe = "哪吒出生自带",--哪吒三武器同一获取方式描述
		pigsy_rake = "八戒出生自带",
		yj_spear = "杨戬出生自带",
		medicine_pestle_myth = "玉兔出生自带",
		hat_commissioner_white = "黑白无常出生自带",
	    zhuangbei_commissioner_w = "白无常出生自带",
	    zhuangbei_commissioner_b= "黑无常出生自带",


		wb_armorfog = "白骨妖镜顶级自动解锁",
		fcs_learn = "方寸山学习解锁",

		song_m_workup = "给予嫦娥仙子蜂王冠可学会该曲谱！",
		song_m_insomnia = "给予嫦娥仙子独奏乐器可学会该曲谱！",
		song_m_fireimmune = "给予嫦娥仙子龙鳞皮可学会该曲谱！",
		song_m_iceimmune = "给予嫦娥仙子滚烫的热石可学会该曲谱！",
		song_m_iceshield = "给予嫦娥仙子冰鲷鱼可学会该曲谱！",
		song_m_nocure = "给予嫦娥仙子蜘蛛卵可学会该曲谱！",
		song_m_weakattack = "给予嫦娥仙子羽毛扇可学会该曲谱！",
		song_m_weakdefense = "给予嫦娥仙子熊皮可学会该曲谱！",
		song_m_nolove = "给予嫦娥仙子牛角帽可学会该曲谱！",
		song_m_sweetdream = "给予嫦娥仙子排箫可学会该曲谱！",

		myth_coldessense = "使用紫金葫芦单独吸取极光获得！",
		myth_fireessense = "使用紫金葫芦单独吸取矮星获得！",
		nian_bell = "首次成功驱逐年兽获得！",
		cane_peach = "聚宝盆有几率获得\n在桃源也能获得一根！",
		myth_nian_fur = "灾厄年兽掉落！",
		pandaman_rareitem_sale = "珍奇小铺出售！",
		pandaman_weapons_sale = "铸匠小铺出售！",
		myth_infant_fruit = "使用金击子采摘获得！",
		commissioner_mpt = "孟婆虚影收善恶魂各20个获得！",
		commissioner_book = "崔珏虚影收善恶魂各99个获得！",
		
	},

	ITEM_TIME = {
		tian = "天",
		naijiuzhi = "耐久值",
		mk = "孙悟空",
		nz = "哪吒",
		bg = "白骨夫人",
		bj = "猪八戒",
		yj = "杨戬",
		yt = "玉兔",
		hb = "黑白无常",
		hwc = "黑无常",
		bwc = "白无常",
		etc = "其他角色",
		melody = "琵琶曲",
		zzj = "盘丝娘娘",

	},

	ITEM_SKIN = {--皮肤
		monkey_king1 = "出海学艺",
		monkey_king2 = "火眼金睛",
		monkey_king3 = "戏中行者",
		monkey_king4 = "六耳猕猴",
        monkey_king5 = "弼马温",
        monkey_king6 = "白面醉翁",

		neza1 = "青莲白藕",
		neza2 = "圣婴大王",
        neza3 = "持缨少年",
        neza4 = "风火唱将",

		white_bone1 = "梨园画皮",
		white_bone2 = "西凉女王",

		pigsy1 = "八戒娶亲",
        pigsy2 = "黄牙老象",
        pigsy3 = "室火星宿",

		yangjian1 = "墨影素鬓",
		yangjian2 = "妙道清源",
		yangjian3 = "鎏金虎将",
		yangjian4 = "金翅大鹏",

		yutu1 = "蟾宫玉膳",
		yutu2 = "寒月暖冬",
		yutu3 = "杏花仙子",
		yutu4 = "月桂酒香",
		yutu5 = "悦耳甜音",

		yama1 = "莲花洞主",

		madameweb1 = "烛香白鼠",

		myth_he_left = "左仙鹤",
		myth_he_right = "右仙鹤",

		bone_mirror1 = "一级妖镜",
		bone_mirror2 = "二级妖镜",
		bone_mirror3 = "顶级妖镜",

		myth_yama_statue1 = "阎罗石像",
		myth_yama_statue2 = "阎罗神像",
		myth_yama_statue3 = "阎罗神龛",
		myth_yama_statue4 = "阎罗神祠",

		myth_redlantern_ground1 = "枯枝",

		myth_stool1 = "七星",
		myth_stool2 = "墨玉",
		myth_stool3 = "玄冥",
		myth_stool4 = "卧熊",
		myth_stool5 = "虎啸",
        myth_stool6 = "凤台",

		mk_battle_flag1 = "燎原",

		fence_bamboo_item1 = "枯竹",
	},

	ITEM_XIAOGUO = {
		naijiu = "耐久",
		suoshu = "所属",
        yaoxiao = "药效",
        xiaoguo = "效果",
        lztime = "炼制时间",
        peifang = "配方",
	},
}




--------------------------------------------------------------------------
--[[ 杂七杂八 ]]
--------------------------------------------------------------------------
STRINGS.NAMES.MYTH_DOOR_EXIT = "Door"
STRINGS.NAMES.MYTH_DOOR_EXIT_1 = "Door"
STRINGS.NAMES.MYTH_DOOR_EXIT_2 = "Door"
STRINGS.NAMES.MYTH_DOOR_EXIT_3 = "Door"
STRINGS.MYTH_WEIGHDOWN = "Weigh Down"

STRINGS.NAMES.MYTH_DOOR_ENTER = "Door"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_DOOR_ENTER = "Spirit resides in an inch of square, but I find my true heart there."

STRINGS.NAMES.MYTH_SMALLLIGHT = "Stoneware Light"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_SMALLLIGHT = "Lights will shine in four quarters, with the conundrum cracked by the smarter."

STRINGS.OLDMYTH_INTERIORS = "Dusty"

STRINGS.READ_FLY_BOOK = "Read"
STRINGS.MYTH_CLEAR = "Clear Up"
STRINGS.MYTHNOFLYINROOM = "I can't use it here."

STRINGS.NAMES.BOOK_FLY_MYTH = "Myth Words"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_FLY_MYTH = "A forgotten book about the mystery of flying!"

STRINGS.NAMES.MYTH_INTERIORS_LIGHT = "Lamp"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_LIGHT = "An oil lamplight."

STRINGS.NAMES.MYTH_INTERIORS_BED = "Sitting Bed"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_BED = "Sip a cup of Chinese tea, and discuss the etiquette of seat."

STRINGS.NAMES.MYTH_INTERIORS_GZ = "Jar"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GZ = "Some old dusty scrolls inside..."

STRINGS.NAMES.MYTH_INTERIORS_GH = "Hanging Picture"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GH = "Born clean with a pure start, to dispel ignorance must comprehend an empty heart."

STRINGS.NAMES.MYTH_INTERIORS_GH_SMALL = "Painting"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GH_SMALL = "Marvelous view!"

STRINGS.NAMES.MYTH_INTERIORS_PF = "Folding Screen"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_PF = "This is not a common furniture."

STRINGS.NAMES.MYTH_INTERIORS_XL = "Incense Burner"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_XL = "Use a few drops of volatile oil to bring a pleasant scent."

STRINGS.NAMES.MYTH_INTERIORS_ZZ = "Desk"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_ZZ = "A book and a half-done manuscript on it."

STRINGS.NAMES.MYTH_FOOD_ZPD = "Pigskin Jelly"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_ZPD = "It takes great courage to even stare at it."	

STRINGS.NAMES.MYTH_FOOD_NX = "Banana Milk Shake"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_NX = "Daisy time of the tea break!"	

STRINGS.NAMES.MYTH_FOOD_LXQ = "Plantain Lobster Ball"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_LXQ = "Premium-level food ingredients only need the plainest cooking procedure..."	

STRINGS.NAMES.MYTH_FOOD_FHY = "Wobster Feast"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_FHY = "A real delicacy on earth!"	

STRINGS.NAMES.MYTH_FOOD_HYMZ = "Floral Moon Cheese"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_HYMZ = "It’s too beautiful to be a food."	

STRINGS.NAMES.MYTH_BANANA_LEAF = "Banana Leaf"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_BANANA_LEAF = "What an enormous leaf!"

STRINGS.NAMES.MYTH_BUNDLE = "Banana Wrap"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_BUNDLE = "Bundle by banana leafs."	

STRINGS.NAMES.MYTH_BUNDLEWRAP = "Banana Bundle"
STRINGS.RECIPE_DESC.MYTH_BUNDLEWRAP = "Pack your bundle, with a pleasant smell!" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_BUNDLEWRAP = "What's inside? Could I look?"

STRINGS.NAMES.MYTH_BANANA_TREE = "Banana Tree"
STRINGS.RECIPE_DESC.MYTH_BANANA_TREE = "Plant a towering banana tree." 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_BANANA_TREE = "You look so much better than your brothers underground."

STRINGS.NAMES.MYTH_ZONGZI1 = "Sweet Rice"
STRINGS.RECIPE_DESC.MYTH_ZONGZI1 = "Make a Veggie Riceball?" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_ZONGZI1 = "Waxy rice and red date, combined like carnelian of taste."

STRINGS.NAMES.MYTH_ZONGZI2 = "Salty Rice"
STRINGS.RECIPE_DESC.MYTH_ZONGZI2 = "Or a Meat Riceball?" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_ZONGZI2 = "Salty is the meat, and softly does the smell so sweet."

STRINGS.NAMES.MYTH_ZONGZI_ITEM1 = "Sweet Rice"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_ZONGZI_ITEM1 = "Wow! I can smell its sweetness!"

STRINGS.NAMES.MYTH_ZONGZI_ITEM2 = "Salty Rice" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_ZONGZI_ITEM2 = "It makes me start to salivate right at sight!"

STRINGS.NAMES.MYTH_FLYSKILL = "Propitious Cloud"
STRINGS.RECIPE_DESC.MYTH_FLYSKILL = "Flying spell that lets you command clouds!" 

STRINGS.NAMES.MYTH_FLYSKILL_MK = "Somersault Cloud"
STRINGS.RECIPE_DESC.MYTH_FLYSKILL_MK = "One somersault by me, 54,000 kilometers breaks free!" 

STRINGS.NAMES.MYTH_FLYSKILL_NZ = "Fire Wheels"
STRINGS.RECIPE_DESC.MYTH_FLYSKILL_NZ = "Fire and wind around the wheels!" 

STRINGS.NAMES.MYTH_FLYSKILL_WB = "Ghostly Wind"
STRINGS.RECIPE_DESC.MYTH_FLYSKILL_WB = "Just a gust of wind passed, Oh, No need to Fuss…" 

STRINGS.NAMES.MYTH_FLYSKILL_PG = "Cotton Cloud"
STRINGS.RECIPE_DESC.MYTH_FLYSKILL_PG = "So soft and comfy, makes Pigsy the Great sleepy……" 

STRINGS.NAMES.MYTH_FLYSKILL_YJ = "Thunder Cloud"
STRINGS.RECIPE_DESC.MYTH_FLYSKILL_YJ = "With lightning flashed, the thunder crashed!" 


STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.FUR_COOK ={
	INUSE = 'I should wait until my turn.',
}
STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.NZ_PLANT={
	HASONE = "I can't plant it here",
}

STRINGS.NAMES.HEAT_RESISTANT_PILL = "Heat Resistant Pill"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEAT_RESISTANT_PILL = "Hahaha! The fire and sun are scorching no more!"

STRINGS.NAMES.COLD_RESISTANT_PILL = "Cold Resistant Pill"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.COLD_RESISTANT_PILL = "An invisible shield that reflects rain and stores warmth."

STRINGS.NAMES.DUST_RESISTANT_PILL = "Dust Resistant Pill"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DUST_RESISTANT_PILL = "Oh! This is how that old Rhino stays from sandstorm and poison pollen!"

STRINGS.NAMES.FLY_PILL = "Fly Pill"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FLY_PILL = "I can fly too! For real?"

STRINGS.NAMES.BLOODTHIRSTY_PILL = "Bloodthirsty Pill"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BLOODTHIRSTY_PILL = "So crazy like a bat!"

STRINGS.NAMES.CONDENSED_PILL = "Condensed Pill"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CONDENSED_PILL = "Taking this enables me to concentrate all my power together!"

STRINGS.NAMES.PEACH = "Peach"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACH = "This is not a normal peach!"
STRINGS.NAMES.PEACH_COOKED = "Roasted Peach" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACH_COOKED = "With its fairy breath burnt, it gets ordinary now."
STRINGS.NAMES.PEACH_BANQUET = "Peach Banquet" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACH_BANQUET = "The simple fruit platter is imbued with magic from this peach!" 
STRINGS.NAMES.PEACH_WINE = "Peach Wine" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACH_WINE = "It smells so~ special......" 

STRINGS.NAMES.MK_BATTLE_FLAG = "War Banner"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MK_BATTLE_FLAG = "I can write my name, proudly on it!!!" 
STRINGS.NAMES.MK_BATTLE_FLAG_ITEM = "War Banner"
STRINGS.RECIPE_DESC.MK_BATTLE_FLAG_ITEM = "This is a very honor of a battle."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MK_BATTLE_FLAG_ITEM = "I can write my name, proudly on it!!!" 

STRINGS.NAMES.HONEY_PIE = "Honey Pie"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HONEY_PIE = "The coarse food was sweetened with honey." 

STRINGS.NAMES.VEGETARIAN_FOOD = "Vegetarian Food"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.VEGETARIAN_FOOD = "A pleasant mild taste." 

STRINGS.NAMES.CASSOCK = "Cassock"
STRINGS.RECIPE_DESC.CASSOCK = "Shelters me far from dust."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CASSOCK = "I can feel calmness, inner peace." 

STRINGS.NAMES.KAM_LAN_CASSOCK = "Kam Lan Cassock"
STRINGS.RECIPE_DESC.KAM_LAN_CASSOCK = "Protects me away from shadow's invasion!"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KAM_LAN_CASSOCK = "It's so shiny! Now I get why the Black Bear wanna steal it."

STRINGS.NAMES.GOLDEN_HAT_MK = "Phoenix Tail Crown"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOLDEN_HAT_MK = "What a magnificent crown!"

STRINGS.NAMES.GOLDEN_ARMOR_MK = "Golden Hauberk"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOLDEN_ARMOR_MK = "The great invincible armor, from the legend!"

STRINGS.NAMES.XZHAT_MK = "Traveler Cap"
STRINGS.RECIPE_DESC.XZHAT_MK = "Ever think about being a traveler to the West?"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.XZHAT_MK = "What a comfy hat!"

STRINGS.NAMES.MK_HUALING = "Phoenix Plume"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MK_HUALING = "What a beautiful plume! "

STRINGS.NAMES.MK_HUOYUAN = "Stone Heart"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MK_HUOYUAN = "A stone heart that BURNS！"

STRINGS.NAMES.MK_LONGPI = "Dragon Scale Satin"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MK_LONGPI = "Hot and thick satin dyed with magic, it seems."

STRINGS.NAMES.BIGPEACH = "Big Peach"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BIGPEACH = "This peach is bigger than all the others!"

STRINGS.NAMES.LOTUS_FLOWER = "Lotus Flower"
STRINGS.RECIPE_DESC.LOTUS_FLOWER = "I shall return my flesh to Mom, my bones to Dad."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LOTUS_FLOWER = "A lovely pink flower."

STRINGS.NAMES.LOTUS_FLOWER_COOKED ="Cooked Lotus Root"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LOTUS_FLOWER_COOKED = "A delicacy in China."

STRINGS.NAMES.GOURD = "Gourd"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOURD = "It's a special vegetable."

STRINGS.NAMES.GOURD_COOKED = "Cooked Gourd"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOURD_COOKED = "More fragrant than it was."

STRINGS.NAMES.GOURD_SEEDS = "Gourd Seeds"

STRINGS.NAMES.GOURD_SOUP = "Gourd Soup"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOURD_SOUP = "Tasty!"

STRINGS.NAMES.GOURD_OMELET = "Gourd Omelette"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOURD_OMELET = "It's a delicious little dish."

STRINGS.NAMES.PILL_BOTTLE_GOURD = "Pill Gourd"
STRINGS.RECIPE_DESC.PILL_BOTTLE_GOURD = "Store the pills in the gourd, to keep its scent from leaking."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PILL_BOTTLE_GOURD = "A resting abode for the pills."

STRINGS.NAMES.WINE_BOTTLE_GOURD = "Wine Gourd"
STRINGS.RECIPE_DESC.WINE_BOTTLE_GOURD = "Good wine must have a good gourd!"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WINE_BOTTLE_GOURD = "Just a simple smell dizzies my mind..."

STRINGS.NAMES.THORNS_PILL = "Bramble Pill"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.THORNS_PILL = "Thou protect me, Thorns!"

STRINGS.NAMES.ARMOR_PILL = "Bone Strengthening Pill"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMOR_PILL = "To keep my bone density!"

STRINGS.NAMES.DETOXIC_PILL = "Anti-Toxin Pill"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DETOXIC_PILL = "Able to detoxify anything poisonous."

STRINGS.NAMES.LAOZI_SP = "Spell Card"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAOZI_SP = "Lord Laozi's personal subpoena."

STRINGS.NAMES.LAOZI = "Lord Lao Zi"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAOZI = "This is an elderly god of the Orients!！"

STRINGS.NAMES.BANANAFAN = "Palm Leaf Fan"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BANANAFAN = "This gorgeous fan is something special."

STRINGS.NAMES.BANANAFAN_BIG = "Deluxe Palm Leaf Fan"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BANANAFAN_BIG = "This precious fan contains a formidable power!"

STRINGS.NAMES.ALCHMY_FUR = "Alchemy Furnace"
STRINGS.RECIPE_DESC.ALCHMY_FUR = "Only this stove can control the Samadhi Fire"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ALCHMY_FUR =  {
	EMPTY = "The legendary furnace of alchemy in Chinese tales？",
	GENERIC = "Oh my! The heat of the flames is just unimaginable!",
	DONE = "What would happen to the pill in the furnace?",
}

STRINGS.MKRECIPE = "Myth"

STRINGS.LAOZI =
{
    A = "Are you kidding me?",
    B = "Rude!",
    C = "How dare you!",
    D = "How could you be so insatiable!",
    E = 'Don\'t push your luck.',
    F = "Once carried through Hangu Gate by it, Now I shall rely on thee to take good care of it.",
}

STRINGS.NAMES.PEACHSPROUT_MYTH = "Peach Sprout" --蟠桃树芽
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACHSPROUT_MYTH = "I hope it will grow up soon!"

STRINGS.NAMES.PEACHSAPLING_MYTH = "Peach Sapling" --蟠桃树苗
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACHSAPLING_MYTH = "I hope it will get mature soon!"

STRINGS.NAMES.PEACHSTUMP_MYTH = "Peach Stump" --蟠桃树桩
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACHSTUMP_MYTH = "What a pity!"

STRINGS.NAMES.PEACHTREEBURNT_MYTH = "Burnt Peach Tree" --烧焦的蟠桃树
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACHTREEBURNT_MYTH = "It's incorrigibly ruined."


STRINGS.NAMES.PEACHTREE_MYTH = "Peach Tree" --蟠桃树
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACHTREE_MYTH = {
	GENERIC = "According to legend, it takes 3 thousand years each for the tree to blossom and bear fruit.",
    BURNING = "No! Spare this valueable tree, please!",
    BLOOM = "It seem to have waited three thousand years, just for this fabulous scene!",
    FRUIT = "I've been waiting all my life for this moment!"
}

STRINGS.NAMES.FANGCUNHILL = "Strange Hill" --灵台方寸山
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FANGCUNHILL = "The hill looks unusually uninhabited."

STRINGS.NAMES.BOOK_MYTH = "Myth Words"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_MYTH = "Wisdom and sorcery, all reside in no word at all..."
STRINGS.NAMES.BOOK_MYTH_YJ = "Myth Words"
STRINGS.RECIPE_DESC.BOOK_MYTH_YJ = "Wisdom and sorcery, all reside in no word at all..."

STRINGS.NAMES.PURPLE_GOURD = "Purple Gourd"
STRINGS.NAMES.PURPLE_GOURD_MALE = "Purple Gourd - Male"
STRINGS.NAMES.PURPLE_GOURD_FEMALE = "Purple Gourd - Female"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PURPLE_GOURD = "With a brisk and shiny splendor!"


--以前的内容集成
STRINGS.FUR_HARVEST = "Harvest"
STRINGS.FUR_COOK = "Alchemy"
STRINGS.MYTH_USE_INVENTORY = "Use"
STRINGS.USE_GOURD = "Drink"
STRINGS.RHI_PLACEITEM = 'Place Tributes'
STRINGS.MYTH_RED_GIVE = "Hang Lamp"
STRINGS.MYTH_RED_TACK = "Pick Lamp"
STRINGS.MKFLYLAND = "Land"
STRINGS.NAMES.MYTH_RHINO_DESK = 'Shabby Altar'
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_RHINO_DESK = "Should I place a tribute, piously?"


------------------------月宫系列
STRINGS.MKCERECIPE = "Moon Palace"


----嫦娥说的话
STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.MYTH_ENTER_HOUSE = { 
	BANNED = "I should come apologize later, after doing so much offence.",
	FLY = "It's considered inappropriate to fly inside.",
	NOTIME = "I can't do this", --白天不可以进
}

--[[
STRINGS.CHARACTERS.MONKEY_KING.ACTIONFAIL.MYTH_ENTER_HOUSE ={
	BANNED = "(Scratch head)Ok, Sun shall wait for a few more days.",
	FLY = "It's so rude to fly inside.",
	NOTIME = "I can't do this!", --白天不可以进
}
STRINGS.CHARACTERS.NEZA.ACTIONFAIL.MYTH_ENTER_HOUSE.BANNED = {
	BANNED = "I'll visit Chang'e sister again when she's chilled down.",
	FLY = "It's so rude to fly inside.",
	NOTIME = "I can't do this!", --白天不可以进
}
STRINGS.CHARACTERS.YANGJIAN.ACTIONFAIL.MYTH_ENTER_HOUSE.BANNED = {
	BANNED = "Fairy, don't be offended. Yang will visit another day.",
	FLY = "It's so rude to fly inside.",
	NOTIME = "I can't do this!", --白天不可以进
}
STRINGS.CHARACTERS.PIGSY.ACTIONFAIL.MYTH_ENTER_HOUSE.BANNED = {
	BANNED = "Look how stupid my pigsy is...messed up relationship once again...",
	FLY = "It's so rude to fly inside.",
	NOTIME = "I can't do this!", --白天不可以进
}
STRINGS.CHARACTERS.WHITE_BONE.ACTIONFAIL.MYTH_ENTER_HOUSE.BANNED = {
	BANNED = "The WhiteBone lost her courtesy. May the fairy excuse her.",
	FLY = "It's so rude to fly inside.",
	NOTIME = "I can't do this!", --白天不可以进
}
]]

STRINGS.MYTHGHG_ISNIGHT = { --被赶出
	MONKEY_KING = "Damn! How could I forget the time!",
	NEZA = "Opps! Neza probably annoyed Sis Chang'e...",
	WHITE_BONE = "The world grand as such, and nowhere accommodates the miserable me?",
	PIGSY = "Was Pigsy infatuated again of drunk...dunno...",
	YANGJIAN = "I shall make an apology next time...",
	GENERIC = "I shouldn't be so insolent...",
}

STRINGS.MYTHCEHAOGANDU = { --好感度 20 50 100 150
	[2] = {
		MONKEY_KING = "Appreciated, Monkey King.",
		NEZA = "Appreciated, Third Prince.",
		WHITE_BONE = "I appreciated your kindness.",
		PIGSY = "Appreciated, Marshal.",
		YANGJIAN = "Appreciated, noble Sir.",
		MYTH_YUTU = "I really like your little gifts~",	
		GENERIC = "Much appreciated.",	
	},
	[4] = {
		MONKEY_KING = "Thank you so much for your gifts, Monkey King!",
		NEZA = "Thank you so much for your gifts, little Third Prince!",
		WHITE_BONE = "You don't really have to do this.",
		PIGSY = "Does Marshal Canopy have a request to me?",
		YANGJIAN = "Does the Heaven have a mission for me, noble Sir?",
		MYTH_YUTU = "You are rather good at making me happy!",	
		GENERIC = "Thank you so much for your gifts!",	
	},
	[6] = {
		MONKEY_KING = "Monkey King makes me speechlessly grateful!",
		NEZA = "If you have time, you are always welcome here!",
		WHITE_BONE = "Well, if you have trouble later, you can take shelter here.",
		PIGSY = "Past is past. Marshal needs not fuss with those.",
		YANGJIAN = "In fact the Noble sir isn't like what's said out there, I reckon.",
		MYTH_YUTU = "Alright alright, I'll spare your pounding assignment today.",	
		GENERIC = "Sending too much benevolence here isn't really necessay...",	
	},
	[7] = {
		MONKEY_KING = "Just some plain cakes. Good luck Monkey King on your journey to the West.",
		NEZA = "Nezha's heart, is as lovely and fragrant, as the beautiful lotus flower.",
		WHITE_BONE = "Do a daily good thing, reflect on your daily faults, and no misfortune shall take place.",
		PIGSY = "Hope Marshal could fulfill your job, and one day restore your position.",
		YANGJIAN = "If anything in need, sir, Chang'e shall definitely endeavor her best.",
		MYTH_YUTU = "Don't be afraid outside. I will always ensure your safety here.",	
		GENERIC = "The karma between us, is far beyond this.",	
	},
}

STRINGS.MYTHGHG_NOCURRENTITEM = {  --物品不对
	MONKEY_KING = "Don't make more jokes with me, Monkey King.",
	NEZA = "You can keep this with you, Third Prince.",
	WHITE_BONE = "Don't you dare to think you are the queen here!",
	PIGSY = "Behave yourself, please, Marshal.",
	YANGJIAN = "Are you here to entertain me, noble Sir?",
	MYTH_YUTU = "Hahaha! But I know you mean well.",	
	GENERIC = "Never take me as a begger by street!",
}

--问候
STRINGS.MYTHGHG_RCWH = {
	MONKEY_KING ={"Why aren't you with your Master to the West?","What a great legend it was once the Monkey King unsettled the whole Heaven!","Be reminded, my snacks are not comparable with Jade Pool's peaches."},
	NEZA ={"You may take some mooncakes with you, if you like them.","You are indeed the First Great One's favorite, to have such powerful relics!","Eat slower, and take a nip of tea~"},
	WHITE_BONE ={"Good and evil will be repaid in kind, just not in time.","May you do more benevolence, to wash away your evils.","There is always comradeship among the world. Maybe you can find your way out."},
	PIGSY ={"Marshal was exiled to the mundane. How could you end up in a piggy?","Damn wine could mess up everything. Don't drink too much.","Don't be too stressed. Help yourself with snack."},
	YANGJIAN ={"Do you have anything on your mind today, noble Sir?","Some plain tea, that could soothe your mind.","Wheeze Dog gets so chubby! So lovely! Hahaha!"},
	MYTH_YUTU ={"Tell me about your stories today! I'm so interested.","Did you finish your pounding work today? Don't cut corners!","If you had enough fun here, come with me back to the heaven, then?"},
	GENERIC ={"Taste how different my tea is with yours.","Come taste some mooncakes if you are hungry.","It's our karma to meet at this place."},
}

--见面
STRINGS.MYTHGHG_JMWH = {
	MONKEY_KING ="Wasn't aware of your coming, Monkey King. Come have a cup of tea!",
	NEZA ="Greetings, Prince Nezha. How's your father doing these days?",
	WHITE_BONE ="You can't evade from any disasters here at Moon Palace. Okok, come sit and have some tea.",
	PIGSY ="Haven't seen you for a while, Marshal Canopy. How're you doing recently?",
	YANGJIAN ="Noble Sir manages law and commands water. As busy as you, why do you have leisure to visit me?",
	MYTH_YUTU ="You naughty girl, where did you go this time?",
	GENERIC ="How happy I am, to have friends from afar.",
}

--嫦娥
STRINGS.MKCETALK_TOLEAVE = "It's late outside. Excuse me, everybody returns home please." --时间到了
STRINGS.MKCETALK_TOMANYPEOLE = "Moon Palace hasn't been so crowded for a really long time."  --人多


STRINGS.SIT_ON_MYTH = "Sit" --坐在垫子上

--玉兔重做tip：玉兔给予嫦娥道具触发的台词
STRINGS.MKCETALK_YUTU = {
    POWDER_M_HYPNOTICHERB = { --草参药粉
        GENERIC = "这草药中的极品，研磨时可得拿捏好了。", --教玉兔时
        LEARNED = "珍稀草药，哪来这么多呢。", --玉兔已经学过了
        WRONGSTATE = nil, --没有达到特殊条件
    },
    POWDER_M_LIFEELIXIR = { --犀茸药粉
        GENERIC = "孩子，你怎么有这个，没得罪谁吧？",
        LEARNED = "孩子，停手吧。",
        WRONGSTATE = nil,
    },
    POWDER_M_CHARGED = { --惊厥药粉
        GENERIC = "研磨和装袋时很容易触电，万万要小心。",
        LEARNED = "惊讶，我都教过你了，你忘啦。",
        WRONGSTATE = nil,
    },
    POWDER_M_IMPROVEHEALTH = { --活血药粉
        GENERIC = "这本身很粘稠，需要辅以佐料，听到了吗。",
        LEARNED = "我可忘不掉这甜美的气味。",
        WRONGSTATE = nil,
    },
    POWDER_M_COLDEYE = { --寒眸药粉
        GENERIC = "取自妖邪之物，往往用于以毒攻毒。",
        LEARNED = "怪不得我一阵寒意，快拿走。",
        WRONGSTATE = nil,
    },
    POWDER_M_BECOMESTAR = { --夜明药粉
        GENERIC = "捣烂后与香粉混合，涂于肌肤便能容光焕发，懂了吧。",
        LEARNED = "我不缺这个，孩子，你自己用吧。",
        WRONGSTATE = nil,
    },
    POWDER_M_TAKEITEASY = { --排郁药粉
        GENERIC = "百无聊赖的时候，希望孩子你能多出去转转，散散心。",
        LEARNED = "谢谢，有你陪伴我可开心多了。",
        WRONGSTATE = nil,
    },

    SONG_M_WORKUP = { --《田中乐》
        GENERIC = "蜂群辛勤劳作，孩子你得学学它们，切记不可游手好闲。",
        LEARNED = "别玩了，今天的药粉做好了吗？",
        WRONGSTATE = nil,
    },
    SONG_M_INSOMNIA = { --《春光曲》
        GENERIC = "想念的滋味可不好受，辗转反侧，夜不能寐。",
        LEARNED = "孩子，别想太多，注意休息。",
        WRONGSTATE = nil,
    },
    SONG_M_FIREIMMUNE = { --《浴火奏》
        GENERIC = "浴火重生，犹似凤凰。",
        LEARNED = "我不需要了，你自己拿着吧。",
        WRONGSTATE = nil,
    },
    SONG_M_ICEIMMUNE = { --《寒风调》
        GENERIC = "寒风瑟瑟，冰冻九重。",
        LEARNED = "这暖心的温度，总让我忽然想起这蟾宫的冷清。",
        WRONGSTATE = "蟾宫并不缺这普通的石头。",
    },
    SONG_M_ICESHIELD = { --《梦飞霜》
        GENERIC = "好奇特的鱼，冰鳞冰心，我倒想养一只试试。",
        LEARNED = "孩子你自己要吧，我已经有一条了。",
        WRONGSTATE = nil,
    },

    SONG_M_NOCURE = { --《怨缠身》
        GENERIC = "怨别人，怨自己，怨这怨那，悔不当初。",
        LEARNED = "蟾宫里容不得怪物常驻，快丢外面去。",
        WRONGSTATE = nil,
    },
    SONG_M_WEAKATTACK = { --《春风化雨》
        GENERIC = "以怜悯心待万事万物，方能春风化雨，百里屠苏。",
        LEARNED = "倘若有人一错再错，你可记得不要仁慈。",
        WRONGSTATE = nil,
    },
    SONG_M_WEAKDEFENSE = { --《霸王卸甲》
        GENERIC = "往日盼他卸甲归田，可如今我落得此般境地。",
        LEARNED = "现在你是我唯一的依靠，我已不再需要盼着谁。",
        WRONGSTATE = nil,
    },
    SONG_M_NOLOVE = { --《流水无情》
        GENERIC = "昔日伊人耳边话，已和潮声向东流。",
        LEARNED = "你走吧，我想一个人待一会。",
        WRONGSTATE = nil,
    },
    SONG_M_SWEETDREAM = { --《夜阑谣》
        GENERIC = "甚好，若哪天夜深难寐，便可吹奏一曲解寂寥。",
        LEARNED = "宫中平日只有你我二人，我要这多一个有何用。",
        WRONGSTATE = nil,
    },
}

--玉兔重做tip：buff名字全部挪到这里了
STRINGS.NAMES.BUFF_M_LOCO_UP = "疾行"
STRINGS.NAMES.BUFF_M_BLOODSUCK = "嗜血"
STRINGS.NAMES.BUFF_M_ATK_UP = "强健"
STRINGS.NAMES.BUFF_M_DEF_UP = "坚固"
STRINGS.NAMES.BUFF_M_UNDEAD = "不死"
STRINGS.NAMES.BUFF_M_ATK_ICE = "凝霜"
STRINGS.NAMES.BUFF_M_HUNGER_STAY = "饱腹"
STRINGS.NAMES.BUFF_M_SANITY_STAY = "凝神"
STRINGS.NAMES.BUFF_M_HUNGER_STRONG = "饕餮"
STRINGS.NAMES.BUFF_M_STRENGTH_UP = "移山"
STRINGS.NAMES.BUFF_M_IMMUNE_FIRE = "避火"
STRINGS.NAMES.BUFF_M_IMMUNE_WATER = "避水"
STRINGS.NAMES.BUFF_M_WARM = "避寒"
STRINGS.NAMES.BUFF_M_COOL = "避暑"
STRINGS.NAMES.BUFF_M_DUST = "避尘"
STRINGS.NAMES.BUFF_M_DEATHHEART = "黑心"
STRINGS.NAMES.BUFF_M_ICESHIELD = "霜甲"
STRINGS.NAMES.BUFF_M_IMMUNE_ICE = "抗冻"
STRINGS.NAMES.BUFF_M_INSOMNIA = "难眠"
STRINGS.NAMES.BUFF_M_PROMOTE_HEALTH = "营养"
STRINGS.NAMES.BUFF_M_PROMOTE_HUNGER = "开胃"
STRINGS.NAMES.BUFF_M_PROMOTE_SANITY = "美味"
STRINGS.NAMES.BUFF_M_STENCH = "芬芳"
STRINGS.NAMES.BUFF_M_THORNS = "荆棘"
STRINGS.NAMES.BUFF_M_BEEFALO = "牛息"
STRINGS.NAMES.BUFF_M_FU = "福"
STRINGS.NAMES.BUFF_M_LU = "禄"
STRINGS.NAMES.BUFF_M_SHOU = "寿"
STRINGS.NAMES.BUFF_M_INFANT = "长生不老"

---------------------------------------------------------------------

STRINGS.NAMES.MYTH_GHG = "The Moon Palace" --广寒宫名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_GHG = "The real spirit of the moon!"--广寒宫检查

STRINGS.NAMES.MYTH_CHANG_E = "Chang'e" --嫦娥名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_CHANG_E = "A fairy maiden over the ripples!"--嫦娥检查

STRINGS.NAMES.MYTH_INTERIORS_GHG_LU = "Censer" --广寒宫的炉子
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GHG_LU = "A censer."--广寒宫的炉子检查
STRINGS.NAMES.MYTH_INTERIORS_GHG_LIGHT = "Palace Lamp" --广寒宫的灯
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GHG_LIGHT = "A lamp of palace."--广寒宫的灯检查
STRINGS.NAMES.MYTH_INTERIORS_GHG_FLOWER = "Moon Flower" --广寒宫的月花
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GHG_FLOWER = "A moon flower."--广寒宫的月花检查
STRINGS.NAMES.MYTH_INTERIORS_GHG_HE_RIGHT = "Fairy Crane" --广寒宫的仙鹤
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GHG_HE_RIGHT = "A fairy crane!"--广寒宫的仙鹤检查
STRINGS.NAMES.MYTH_INTERIORS_GHG_HE_LEFT = "Fairy Crane" --广寒宫的仙鹤
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GHG_HE_LEFT = "A fairy crane!"--广寒宫的仙鹤检查

STRINGS.NAMES.MYTH_REDLANTERN = "Lamp" --灯笼名字
STRINGS.RECIPE_DESC.MYTH_REDLANTERN = "A traditional Chinese lamp."--灯笼配方描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_REDLANTERN = "A soft stroke within the darkness."--灯笼检查

STRINGS.NAMES.MYTH_REDLANTERN_GROUND = "Lamp Frame" --灯笼架子名字
STRINGS.RECIPE_DESC.MYTH_REDLANTERN_GROUND = "To place your lovely lamps!"--灯笼架子配方描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_REDLANTERN_GROUND = "Yeah, a rather convenient way."--灯笼架子检查

STRINGS.NAMES.MYTH_RUYI = "Jade Ruyi." --如意名字
STRINGS.RECIPE_DESC.MYTH_RUYI = "Soft hit as you wish, and peaches fall on dish."--如意配方描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_RUYI = "Ruyi Ruyi, all at my wish!"--如意检查

STRINGS.NAMES.MYTH_FENCE = "Screen" --屏风名字
STRINGS.RECIPE_DESC.MYTH_FENCE = "A traditional Chinese family decoration."--屏风配方描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FENCE = "A furnature used specifically to obstruct vision."--屏风检查

STRINGS.NAMES.MYTH_BBN = "Moon Sachet" --百宝囊名字
STRINGS.RECIPE_DESC.MYTH_BBN = "And it needs some light to really be a moon."--百宝囊配方描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_BBN = "Remember to supply it with energy in time."--百宝囊检查

STRINGS.NAMES.MYTH_YYLP = "Moon Wheel" --莹月轮盘名字
STRINGS.RECIPE_DESC.MYTH_YYLP = "Very handy."--莹月轮盘配方描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_YYLP = "Is this the real moon falling into the mundane?"--莹月轮盘检查

STRINGS.NAMES.MYTH_MOONCAKE_ICE = "Snowy Mooncake" --冰月饼名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_MOONCAKE_ICE = "Refreshes your mind."--冰月饼检查

STRINGS.NAMES.MYTH_MOONCAKE_NUTS = "Five-Nut Mooncake" --五仁月饼名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_MOONCAKE_NUTS = "Fills your stomach with one enough."--五仁月饼检查

STRINGS.NAMES.MYTH_MOONCAKE_LOTUS= "Lotus-Paste Mooncake" --莲蓉月饼名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_MOONCAKE_LOTUS = "Opens up my appetite. I'm ready to start a gluttony, for real!"--莲蓉月饼检查

STRINGS.NAMES.MYTH_FLYSKILL_YT = "Frost Cloud" --霜玉云
STRINGS.RECIPE_DESC.MYTH_FLYSKILL_YT = "Frost rises with fog, fly together as indigo cloud.寒霜雾起，足踏青云" --霜玉云配方描述

STRINGS.NAMES.MYTH_CHANG_E_FURNITURE = "Cushion" --嫦娥旁边的垫子名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_CHANG_E_FURNITURE = "Could rest a bit there."--垫子检查

STRINGS.NAMES.MYTH_CASH_TREE_GROUND = "Goldtree" --摇钱树名字
STRINGS.RECIPE_DESC.MYTH_CASH_TREE_GROUND = "You have infinite treasures!"--百宝囊配方描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_CASH_TREE_GROUND = "The Goldtree in Oriental mythology."--摇钱树检查
STRINGS.NAMES.MYTH_CASH_TREE_GROUND_RECIPE = STRINGS.NAMES.MYTH_CASH_TREE_GROUND

STRINGS.NAMES.MYTH_CASH_TREE = "Goldtree Sapling" --摇钱树树苗名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_CASH_TREE = "Has not reached its maturity."--摇钱树树苗检查

STRINGS.NAMES.MYTH_TREASURE_BOWL = "Treasure Bowl" --聚宝盆名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_TREASURE_BOWL = "This is much more awesome than serendipity!"--聚宝盆检查

STRINGS.NAMES.MYTH_SMALL_GOLDFROG = "Golden Frog" --小金蟾名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_SMALL_GOLDFROG = "A minion of that big toad."--小金蟾检查

STRINGS.NAMES.MYTH_GOLDFROG_BASE = "Ingot Statue" --元宝雕像名字 挖boss 用的
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_GOLDFROG_BASE = "Better be careful here..."--元宝雕像检查

STRINGS.NAMES.MYTH_GOLDFROG = "Treasure Toad" --大蛤蟆名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_GOLDFROG = "It got so many treasures on its body!"--大蛤蟆检查

STRINGS.NAMES.MYTH_COIN = "Copper Coin" --铜钱名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_COIN = "Sky round and ground square, money and fame will come in pair!"--铜钱检查

STRINGS.NAMES.MYTH_FENCE_ITEM = STRINGS.NAMES.MYTH_FENCE
STRINGS.RECIPE_DESC.MYTH_FENCE_ITEM = STRINGS.RECIPE_DESC.MYTH_FENCE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FENCE_ITEM = STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FENCE

STRINGS.NAMES.MYTH_FENCE_ITEM_BLUEPRINT = STRINGS.NAMES.MYTH_FENCE .. STRINGS.NAMES.BLUEPRINT
STRINGS.RECIPE_DESC.MYTH_FENCE_ITEM_BLUEPRINT = STRINGS.RECIPE_DESC.MYTH_FENCE

STRINGS.NAMES.MYTH_REDLANTERN_GROUND_BLUEPRINT = STRINGS.NAMES.MYTH_REDLANTERN_GROUND .. STRINGS.NAMES.BLUEPRINT
STRINGS.RECIPE_DESC.MYTH_REDLANTERN_GROUND_BLUEPRINT = STRINGS.RECIPE_DESC.MYTH_REDLANTERN_GROUND

STRINGS.NAMES.MYTH_REDLANTERN_BLUEPRINT = STRINGS.NAMES.MYTH_REDLANTERN .. STRINGS.NAMES.BLUEPRINT
STRINGS.RECIPE_DESC.MYTH_REDLANTERN_BLUEPRINT = STRINGS.RECIPE_DESC.MYTH_REDLANTERN

STRINGS.RECIPE_DESC.MYTH_INTERIORS_GHG_LIGHT = STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GHG_LIGHT
STRINGS.NAMES.MYTH_INTERIORS_GHG_LIGHT_BLUEPRINT = STRINGS.NAMES.MYTH_INTERIORS_GHG_LIGHT .. STRINGS.NAMES.BLUEPRINT
STRINGS.RECIPE_DESC.MYTH_INTERIORS_GHG_LIGHT_BLUEPRINT = STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GHG_LIGHT

STRINGS.NAMES.MYTH_INTERIORS_GHG_GROUNDLIGHT = STRINGS.NAMES.MYTH_INTERIORS_GHG_LIGHT
STRINGS.RECIPE_DESC.MYTH_INTERIORS_GHG_GROUNDLIGHT = STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GHG_LIGHT
STRINGS.NAMES.MYTH_INTERIORS_GHG_GROUNDLIGHT_BLUEPRINT = STRINGS.NAMES.MYTH_INTERIORS_GHG_LIGHT .. STRINGS.NAMES.BLUEPRINT
STRINGS.RECIPE_DESCMYTH_INTERIORS_GHG_GROUNDLIGHT_BLUEPRINT = STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GHG_LIGHT

STRINGS.RECIPE_DESC.MYTH_INTERIORS_GHG_FLOWER = STRINGS.NAMES.MYTH_INTERIORS_GHG_FLOWER
STRINGS.NAMES.MYTH_INTERIORS_GHG_FLOWER_BLUEPRINT = STRINGS.NAMES.MYTH_INTERIORS_GHG_FLOWER .. STRINGS.NAMES.BLUEPRINT
STRINGS.RECIPE_DESC.MYTH_INTERIORS_GHG_FLOWER_BLUEPRINT = STRINGS.NAMES.MYTH_INTERIORS_GHG_FLOWER

STRINGS.RECIPE_DESC.MYTH_INTERIORS_GHG_HE_LEFT = STRINGS.NAMES.MYTH_INTERIORS_GHG_HE_LEFT
STRINGS.NAMES.MYTH_INTERIORS_GHG_HE_LEFT_BLUEPRINT = STRINGS.NAMES.MYTH_INTERIORS_GHG_HE_LEFT .. STRINGS.NAMES.BLUEPRINT
STRINGS.RECIPE_DESC.MYTH_INTERIORS_GHG_HE_LEFT_BLUEPRINT = STRINGS.NAMES.MYTH_INTERIORS_GHG_HE_LEFT

STRINGS.RECIPE_DESC.MYTH_INTERIORS_GHG_HE_RIGHT = STRINGS.NAMES.MYTH_INTERIORS_GHG_HE_RIGHT
STRINGS.NAMES.MYTH_INTERIORS_GHG_HE_RIGHT_BLUEPRINT = STRINGS.NAMES.MYTH_INTERIORS_GHG_HE_RIGHT .. STRINGS.NAMES.BLUEPRINT
STRINGS.RECIPE_DESC.MYTH_INTERIORS_GHG_HE_RIGHT_BLUEPRINT = STRINGS.NAMES.MYTH_INTERIORS_GHG_HE_RIGHT

STRINGS.RECIPE_DESC.MYTH_INTERIORS_GHG_LU = STRINGS.NAMES.MYTH_INTERIORS_GHG_LU
STRINGS.NAMES.MYTH_INTERIORS_GHG_LU_BLUEPRINT = STRINGS.NAMES.MYTH_INTERIORS_GHG_LU .. STRINGS.NAMES.BLUEPRINT
STRINGS.RECIPE_DESC.MYTH_INTERIORS_GHG_LU_BLUEPRINT =STRINGS.NAMES.MYTH_INTERIORS_GHG_LU

STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_DOOR_EXIT_2 = "I should pay attention to the departure time."

STRINGS.MYTH_SKIN_ALCHMY_FUR_COPPER = "Eight-Trigram Furnace"
STRINGS.MYTH_SKIN_ALCHMY_FUR_RUINS = "Shadow Transformer"

STRINGS.MYTH_SKIN_REDLANTERN_MYTH_B = "Lotus Cup"
STRINGS.MYTH_SKIN_REDLANTERN_MYTH_C = "Spring Cadenza"
STRINGS.MYTH_SKIN_REDLANTERN_MYTH_D = "Merry-Go-Around"
STRINGS.MYTH_SKIN_REDLANTERN_MYTH_E = "Plenilune"
STRINGS.MYTH_SKIN_REDLANTERN_MYTH_F = "枯骨寒"
STRINGS.MYTH_SKIN_REDLANTERN_MYTH_G = "蛛丝缠"
STRINGS.MYTH_SKIN_REDLANTERN_MYTH_H = "引魄灯"
STRINGS.MYTH_SKIN_REDLANTERN_MYTH_I = "明玕照"


STRINGS.NAMES.FARM_PLANT_GOURD = "Gourd Vines"
STRINGS.NAMES.GOURD_OVERSIZED = "Giant Gourd"
STRINGS.NAMES.GOURD_OVERSIZED_ROTTEN = "Rotton Giant Gourd"
STRINGS.UI.PLANTREGISTRY.DESCRIPTIONS.GOURD = "Water Water！"
STRINGS.NAMES.KNOWN_GOURD_SEEDS = "Gourd Seeds"

STRINGS.NAMES.MYTH_YJP = "White Jade Vase"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_YJP = "A vase smells so lively!"


STRINGS.NAMES.MYTH_GRANARY = "Barn"
STRINGS.RECIPE_DESC.MYTH_GRANARY = "Celebrate your bumper harvest!"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_GRANARY = "Spring ploughs and Summer weeds, Autumn saves for Winter feeds."

STRINGS.NAMES.MYTH_TUDI_SHRINES = "Landlord Monastery"
STRINGS.RECIPE_DESC.MYTH_TUDI_SHRINES = "Where there are people living, there are people tributing."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_TUDI_SHRINES = "Yellow wine or wheat wine, along with fat chicken and that’s fine."

STRINGS.NAMES.MYTH_WELL = "Water Well"
STRINGS.RECIPE_DESC.MYTH_WELL = "Clear and sweet, warms up in winter and chills in heat~"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_WELL = "What a well source of well water!"

STRINGS.NAMES.MOVEMOUNTAIN_PILL = "Yu Gong Pill"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MOVEMOUNTAIN_PILL = "Take it and even Wolfgang will be no match for me!"


STRINGS.NAMES.MYTH_TUDI = "Grandpa Landlord"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_TUDI = "Are you also a fairy god"

STRINGS.MYTH_TUDI_TRADE = "Courtesy stands on reciprocation on both sides."
STRINGS.MYTH_TUDI_ALREADYTRADE = "Though I take prebend, but without avarice!"
STRINGS.MYTH_TUDI_TIRED = {"The hoe seedling the day be noon, Sweat drenches the earth ground soon~","Ouch! My waist!","Grains look small but still very hard, Don’t take them without regard!"}

STRINGS.MYTH_TUDI_ROTTEN_SPEAK = {"No land has been lying fallow, Starving farmers still take it hallow.","Grains look small but still very hard, Don’t take them without regard!"}
STRINGS.MYTH_TUDI_RUNAWAY = "My demigod has very little power, so I…eh…goodbye!"

STRINGS.MYTH_TUDI_PLAYER_SPEAK = {
	common = {"Much gratitude for donor’s tributes!","May it be ladies and gentlemen have weathers to your like, and happiness to your wish."},
	monkey_king = {"Was not informed your King’s visit. May you pardon me for not welcoming you from afar!","Any instruction from Monkey King？"},
	neza =  {"I shall just obey whatsoever Third Prince’s order is.","Was there an issue from Third Prince for my mortal body?"},
	white_bone =  {"A demon’s approaching…I, I…Grandpa is leaving now!"},
	pigsy =  {"Mr. Marshal Canopy, my monastery is humble in tributes. Please do me a favor.","If Marshal wanna have protection fee, might as well change another place."},
	myth_yutu =  {"Little rabbit, sneaking and hanging out again?","Fairy lady Chang’e will take thee back shortly afterwards."},
	yangjian=  {"Was there a legal enforcement for my operation, Monsieur?","Monsieur’s visit, really brightened my little humble house!"},
}


STRINGS.NAMES.MYTH_TOY_FEATHERBUNDLE = " Shuttlecock Bird"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_TOY_FEATHERBUNDLE = "Flowers fly around my tiptoe, rising over the clouds to the brink of the sky."

STRINGS.NAMES.MYTH_TOY_TIGERDOLL = "Cloth Tiger"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_TOY_TIGERDOLL = "Dignified and energetic, so and very cute!"

STRINGS.NAMES.MYTH_TOY_TUMBLER = "Landlord Roly-Poly"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_TOY_TUMBLER = "The Roly-Poly with the appearance of Grandpa Landlord, of perfect workmanship."

STRINGS.NAMES.MYTH_TOY_TWIRLDRUM = "Rattle Drum"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_TOY_TWIRLDRUM = "Goo-dong! Goo-dong!"

STRINGS.NAMES.MYTH_TOY_CHINESEKNOT = "Chinese Knot"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_TOY_CHINESEKNOT = "Blessings intertwines, for years and years long."

STRINGS.NAMES.MYTH_FOOD_TABLE = "Rosewood Dinner Table"
STRINGS.RECIPE_DESC.MYTH_FOOD_TABLE = "Glowing red dining table, emits the blissful smell of a happy new year!"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_TABLE = "Reunion and united, days and years long all together!"

STRINGS.NAMES.MYTH_FOOD_SJ = "Dumplings"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_SJ = "New Year should be spent with dumplings, to fill your teeth with delicate flavor."

STRINGS.NAMES.MYTH_FOOD_BZ = "Big Meat Baozi"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_BZ = "A perfect morning, starts with a Big Meat Baozi."

STRINGS.NAMES.MYTH_FOOD_XJDMG = "Stewed Mushroom With Chicken"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_XJDMG = "Alohomora! Stewed Mushroom With Chicken!"

STRINGS.NAMES.MYTH_FOOD_HSY = "Spicy Braised Fish"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_HSY = "Warms my body up, and my heart."

STRINGS.NAMES.MYTH_FOOD_BBF = "Eight Treasure Rice Pudding"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_BBF = "Sweet but not cloy, much boon to enjoy."

STRINGS.NAMES.MYTH_FOOD_CJ = "Moon-Fold Spring Roll"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_CJ  = "Fold one piece of moonlight, and sent it to your heart."

STRINGS.NAMES.MYTH_FOOD_HLBZ = "Carrot Ade"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_HLBZ = "Nurtures eyes and face, dedicated for fair maidens."

STRINGS.NAMES.MYTH_FOOD_LWHZ = "Winter Flavor Compilation"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_LWHZ  = "Thin but not dry, sweet but not cloy. Winter flavor among teeth, fume fragrance to enjoy!"

STRINGS.NAMES.MYTH_FOOD_TSJ = "Tusu Wine"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_TSJ = "Tusu comes along the New Year, warming up wind in the Spring."

STRINGS.NAMES.MYTH_FOOD_TR = "Wukong Sugar Man"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_TR = "He is always the big hero in mythology."

STRINGS.TUDI_SHRINES_NEEDGOODFOOD = "Tributes to the Landlord, gotta go throught dishboard."
STRINGS.TUDI_SHRINES_NEEDOTHERFOOD = "Three plates, suppose for three sorts we are all au fait."
STRINGS.TUDI_SHRINES_REFUSEFOOD = "Huge gratitude for your concern which flattered me into shyness."

STRINGS.NAMES.BOOKINFO_MYTH = "Sealed Book"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOKINFO_MYTH = "This reminds me of the magic diary that once talked to Harry and Ginny…"

STRINGS.NAMES.MYTH_HONEYPOT = "Honey Jar"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_HONEYPOT = "Surprises come out of its filling."

STRINGS.NAMES.LAOZI_BELL = "Tusita Cowbell"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAOZI_BELL = "Lord Laozi casted this bell for his cyan cattle."

STRINGS.NAMES.LAOZI_BELL_BROKEN = "Broken Cowbell"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAOZI_BELL_BROKEN = "Broken into pieces, but likely reparable through Alchemy Furnace."

STRINGS.NAMES.SADDLE_QINGNIU = "Tusita Saddle"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SADDLE_QINGNIU = "One of Lord Laozi’s treasured relics."

STRINGS.NAMES.LAOZI_QINGNIU = "Slab-Horn Cyan Cattle"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAOZI_QINGNIU = "\"Si,\" the fortunate beast of ancient times, has now revealed itself in the flourishing age."

STRINGS.ACTIONS.CASTAOE.MYTH_QXJ = "Flash of Blade Light"
STRINGS.ACTIONS.CASTAOE.MYTH_WEAPON_SYF = "Frosty Sweep"
STRINGS.ACTIONS.CASTAOE.MYTH_WEAPON_GTT = "Bull Power Hammerblow"
STRINGS.ACTIONS.CASTAOE.MYTH_WEAPON_SYD = "Scorching Slash"
STRINGS.ACTIONS.CASTAOE.CANE_PEACH = "弃杖化林"

STRINGS.MYTH_SKIN_GROUNDLIGHT_STD = "Pagoda Light"
STRINGS.MYTH_SKIN_GROUNDLIGHT_RYX = "Heaven Pillar"
STRINGS.MYTH_SKIN_GROUNDLIGHT_QZH = "Bamboo Luster"
STRINGS.MYTH_SKIN_GROUNDLIGHT_LLT = "Leng-Gong Tower"
STRINGS.MYTH_SKIN_GROUNDLIGHT_BGZ = "White Bone Twigs"
STRINGS.MYTH_SKIN_GROUNDLIGHT_BLZ = "Lotus Lantern"
STRINGS.MYTH_SKIN_GROUNDLIGHT_GXY = "桂香盈"
STRINGS.MYTH_SKIN_GROUNDLIGHT_YHY = "幽魂引"
STRINGS.MYTH_SKIN_GROUNDLIGHT_CXH = "翠镶红"
STRINGS.MYTH_SKIN_GROUNDLIGHT_ZSZ = "蛛设织"

STRINGS.NAMES.MYTH_SIVING_BOSS = "Zigui Magic Bird"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_SIVING_BOSS = "A mountain in northern sea is called the Ghost Town. At the source of its black water resides this magical bird."

STRINGS.NAMES.SIVING_ROCKS = "Zigui Stone"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SIVING_ROCKS = "A lively power is roaming about its inside."

STRINGS.NAMES.SIVING_STONE = "Zigui Cyan Gold"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SIVING_STONE = "Buddhist won’t tell his fame and Taoist won’t tell age. The forever cyan gold is a book with endless page."

STRINGS.NAMES.ARMORSIVING = "Zigui Armor"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMORSIVING = "Facing clouds of enemy waves, soldiers charge courageously nonetheless."

STRINGS.NAMES.SIVING_HAT = "Zigui Helmet"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMORSIVING = "A passed soldier shall have his or her soul in heaven."

STRINGS.NAMES.MYTH_PLANT_LOTUS = "Lotus Cluster"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_LOTUS = "Slim lotus leaf not yet unfurled, Dragonflies alight on its tip as if impearled." --待修改
--这句检查台词单指是"发芽"状态下，需补充成株、开花、枯萎状态下的检查代码，文本均已准备好！--

STRINGS.NAMES.MYTH_LOTUS_FLOWER = "Lotus Flower"
STRINGS.RECIPE_DESC.MYTH_LOTUS_FLOWER = "I shall return my flesh to Mom, my bones to Dad."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_LOTUS_FLOWER = "The aroma diffuses more and more limpid, and the lotus stands straight and cleanly."

STRINGS.NAMES.LOTUS_ROOT = "Lotus Roots"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LOTUS_ROOT = "Crispy and dainty!"

STRINGS.NAMES.LOTUS_ROOT_COOKED = "Grilled Lotus Root"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LOTUS_ROOT_COOKED = "Moderately crisp and gluttonous. Not as refreshing as eating it raw."

STRINGS.NAMES.LOTUS_SEEDS = "Lotus Nuts"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LOTUS_SEEDS = "Sweet in taste and mild in nature, wholesome to spleen and stomach."

STRINGS.NAMES.LOTUS_SEEDS_COOKED = "Roasted Lotus Nuts"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LOTUS_SEEDS_COOKED = "Soft ricy sweet and scented, warms my inside and makes me contented."

STRINGS.NAMES.MYTH_LOTUSLEAF = "Lotus Leaf"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_LOTUSLEAF = "Downpour as it goes, I shall not be smudged anyhow."

STRINGS.NAMES.MYTH_LOTUSLEAF_HAT = "Lotus Leaf Canopy"
STRINGS.RECIPE_DESC.MYTH_LOTUSLEAF_HAT = "Breeze strokes across lotus, brings waves of clean aroma."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_LOTUSLEAF_HAT = "Pedestrians laughs at it, but all the kiddos treasures it."--????

STRINGS.NAMES.MYTH_FOOD_LZG = "Crystal Seeds Soup"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_LZG = "Tonic to the spleen and stomach, soothing to both the inside and outside."

STRINGS.NAMES.MYTH_FOOD_ZYOH = "Moon-Fold Lotus Box"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_ZYOH = "Seeping aroma tops up the box, and the moonlight spills over the brim."

STRINGS.NAMES.MYTH_FOOD_PGT = "Stewed Lotus Root with Ribs"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_PGT = "Let me see…I need 2 portions of ribs and 1 portion of…Nezha?"

STRINGS.NAMES.MYTH_FOOD_HBJ = "Pouch Chicken"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_HBJ = "This strong and compelling wisp!!! Love it!"

STRINGS.NAMES.MYTH_WEAPON_SYF = "Frosty Broadax"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_WEAPON_SYF = "Forged with the soul of the water, and feels bitterly frigid. Mind its power may backfire!"

STRINGS.NAMES.MYTH_WEAPON_SYD = "Flaming Broadsword"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_WEAPON_SYD = "Forged with the soul of the fire. Its scorching heat burns everything within its proximity."

STRINGS.NAMES.MYTH_WEAPON_GTT = "Whipping Rattan"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_WEAPON_GTT = "Forged with the soul of the wind. Can wield the power of sand and stones."

STRINGS.NAMES.MYTH_QXJ = "Hepta-Star Sword"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_QXJ = "Six armors and a textured horn combined, borns a sword with seven star shined."

STRINGS.NAMES.MYTH_RHINO_BLUEHEART = "Heart of Glacier"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_RHINO_BLUEHEART = "A heart surging through billows."

STRINGS.NAMES.MYTH_RHINO_REDHEART = "Heart of Flame"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_RHINO_REDHEART = "A heart raging with fire."

STRINGS.NAMES.MYTH_RHINO_YELLOWHEART = "Heart of Zephyr"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_RHINO_YELLOWHEART = "A heart reigning the power of tornadoes."

STRINGS.NAMES.TURF_MYTH_ZHU = "Meadow Turf"
STRINGS.RECIPE_DESC.TURF_MYTH_ZHU = "Meadow Turf"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TURF_MYTH_ZHU = "Meadow-y turf."

STRINGS.NAMES.TURF_QUAGMIRE_PARKFIELD = "桃园地皮"
STRINGS.RECIPE_DESC.TURF_QUAGMIRE_PARKFIELD = "烂漫桃花尽入泥"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TURF_QUAGMIRE_PARKFIELD = "芳草鲜美，落英缤纷"

STRINGS.NAMES.MYTH_PLANT_BAMBOO = "Bamboo"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO = "Verdant Bamboo rises to the firmament with a strong and spirited power!"

STRINGS.NAMES.MYTH_BAMBOO = "Bamboo"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_BAMBOO = "Verdant for all seasons loudly, struts across snow and frost proudly."

STRINGS.NAMES.MYTH_GREENBAMBOO = "Cyan Bamboo"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_GREENBAMBOO = "Without downpour, how can a real bamboo rise up?"

STRINGS.NAMES.MYTH_BAMBOO_SHOOTS = "Bamboo Shoots"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_BAMBOO_SHOOTS = "An abode without bamboo can’t stay; a meal without bamboo shoots can’t enjoy."

STRINGS.NAMES.MYTH_BAMBOO_SHOOTS_COOKED = "Roasted Bamboo Shoots"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_BAMBOO_SHOOTS_COOKED = "Shoots’ fragrance gotta be retained by roasting, otherwise it might easily \"shoot\" far away."

STRINGS.NAMES.MYTH_FOOD_ZTF = "Rice in Bamboo"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_ZTF = "Fragrant smell rushes into noses, makes kiddos salivate endlessly."

STRINGS.NAMES.MYTH_FOOD_ZSCR = "Sautéed Meat Bamboo Shoots"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_ZSCR = "If you wanna invite a friend to a meal, bear in mind to order this!"

STRINGS.NAMES.MYTH_FUCHEN = "Horsetail Whisk"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FUCHEN = "Whisk from time to time, don’t have it tainted by grime."

STRINGS.LZOZI_QINGNIU_EATPILL = {
    SX = "Not even worthy as much as Lord Laozi’s furnace ash!",
    TY = "Mount the clouds and ride on the mists.",
    ZG = "Firm as the mountain.",
    NS = "Breath held and focus heightened.",
}

STRINGS.MYTH_LAOZIPACK = "Seal"

STRINGS.NAMES.KRAMPUSSACK_SEALED = "Supressed Krampus Sack"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KRAMPUSSACK_SEALED = "Magic folded its space, necessay for forging a Purple Gourd."

STRINGS.NAMES.MYTH_STATUE_PANDAMAN = "Statue of Legend Mystery"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_STATUE_PANDAMAN = "A mysterious hero's statue."

STRINGS.NAMES.MYTH_STORE = "Closed Store"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_STORE = "The store's past its closing time."

STRINGS.NAMES.MYTH_STORE_CONSTRUCTION = "Store Under Construction"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_STORE_CONSTRUCTION = "A store that hasn't finished construction yet."


STRINGS.NAMES.MYTH_PASSCARD_JIE = "通天敕令"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PASSCARD_JIE = "‘有教无类’，三清之一通天教主的令牌。"

STRINGS.USE_MIRROR = "更衣"

STRINGS.NAMES.MYTH_PLANT_BAMBOO_0 = "种下的竹笋"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO_0 = "长吧，长吧。"
STRINGS.NAMES.MYTH_PLANT_BAMBOO_1 = "青竹芽"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO_1 = "长吧，长吧。"
STRINGS.NAMES.MYTH_PLANT_BAMBOO_2 = "青竹苗"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO_2 = "长吧，长吧。"
STRINGS.NAMES.MYTH_PLANT_BAMBOO_3 = "青竹"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO_3 = "四青青碧竹，盎然新发。"
STRINGS.NAMES.MYTH_PLANT_BAMBOO_4 = "青竹"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO_4 = "四青青碧竹，盎然新发。"
STRINGS.NAMES.MYTH_PLANT_BAMBOO_5 = "苍竹"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO_5 = "枯槎尚倚春风力，苍竹从来自岁寒。"
STRINGS.NAMES.MYTH_PLANT_BAMBOO_STUMP = "竹桩"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO_STUMP = "粉骨碎身全不怕。"
STRINGS.NAMES.MYTH_PLANT_BAMBOO_BURNT = "烧焦的竹"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO_BURNT = "要留清白在人间。"

STRINGS.NAMES.MYTH_HUANHUNDAN = "还魂丹"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_HUANHUNDAN = "还魂丹，起死人而肉白骨"

--特殊新加
STRINGS.NAMES.MYTH_TOY_BOOKINFO = "神话玩具" --玩具的名字
STRINGS.NAMES.MYTH_PIGSYSKILL_BOOKINFO = "刚鬣本相" --八戒的技能

STRINGS.NAMES.MYTH_FLYSKILL_YA = "幽冥身"
STRINGS.RECIPE_DESC.MYTH_FLYSKILL_YA = "幽冥身配方描述"

STRINGS.NAMES.MYTH_FLYSKILL_YA = "幽冥身"
STRINGS.RECIPE_DESC.MYTH_FLYSKILL_YA = "红尘滚滚，入世拘魂"

STRINGS.USE_MYTH_SKELETON = "掩埋"
STRINGS.NAMES.MYTH_MOONCAKE_BOX = "月饼盒"
STRINGS.RECIPE_DESC.MYTH_MOONCAKE_BOX = "月儿弯弯，满载欣欢"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_MOONCAKE_BOX = "精致美妙的月饼盒子"

STRINGS.NAMES.MYTH_COIN_BOX = "铜钱串"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_COIN_BOX = "一大串铜钱"

STRINGS.USE_MYTH_COIN = "串一串"
STRINGS.USE_MYTH_ASTRAL = "回魂"
STRINGS.USE_MYTH_PLAYER = "缠身"
STRINGS.USE_MYTH_ABSORB = "吸取"
STRINGS.USE_MYTH_DRINK = "喝"

--BUFF
STRINGS.NAMES.BUFF_M_LOCO_UP = "疾行"
STRINGS.NAMES.BUFF_M_BLOODSUCK = "嗜血"
STRINGS.NAMES.BUFF_M_ATK_UP = "强健" --增加攻击力
STRINGS.NAMES.BUFF_M_DEF_UP = "坚固" --增加防御力
STRINGS.NAMES.BUFF_M_UNDEAD = "不死"
STRINGS.NAMES.BUFF_M_ATK_ICE = "凝霜" --攻击带冰
STRINGS.NAMES.BUFF_M_ATK_ELEC = "驭电" --攻击带电
STRINGS.NAMES.BUFF_M_CHARGED = "感电" --杨戬的
STRINGS.NAMES.BUFF_M_HUNGER_STAY = "饱腹"
STRINGS.NAMES.BUFF_M_SANITY_STAY = "凝神"
STRINGS.NAMES.BUFF_M_HUNGER_STRONG = "饕餮"
STRINGS.NAMES.BUFF_M_STRENGTH_UP = "移山"
STRINGS.NAMES.BUFF_M_IMMUNE_FIRE = "避火"
STRINGS.NAMES.BUFF_M_IMMUNE_WATER = "避水"
STRINGS.NAMES.BUFF_M_WARM = "避寒"
STRINGS.NAMES.BUFF_M_COOL = "避暑"
STRINGS.NAMES.BUFF_M_DUST = "避尘"
STRINGS.NAMES.BUFF_M_DEATHHEART = "黑心" --白骨夫人的
STRINGS.NAMES.BUFF_M_ICESHIELD = "霜甲" --被攻击冻结敌人（单体）
STRINGS.NAMES.BUFF_M_IMMUNE_ICE = "抗冻" --免疫冰冻
STRINGS.NAMES.BUFF_M_INSOMNIA = "难眠" --免疫催眠
STRINGS.NAMES.BUFF_M_THORNS = "荆棘"
STRINGS.NAMES.BUFF_M_WORKUP = "高效" --工作效率提高
STRINGS.NAMES.BUFF_M_HEALTH_REGEN = "治疗"
STRINGS.NAMES.BUFF_M_SANITY_REGEN = "回神"
STRINGS.NAMES.BUFF_M_HUNGER_REGEN = "果腹"
STRINGS.NAMES.BUFF_M_GLOW = "闪耀"
--以下都是熊猫人铺子的
STRINGS.NAMES.BUFF_M_PROMOTE_HEALTH = "营养"
STRINGS.NAMES.BUFF_M_PROMOTE_HUNGER = "开胃"
STRINGS.NAMES.BUFF_M_PROMOTE_SANITY = "美味"
STRINGS.NAMES.BUFF_M_STENCH = "芬芳"

--------------------------------------------------------------------------
--[[ 青竹洲店铺 ]]
--------------------------------------------------------------------------

STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.TRADE_BBSHOP_M = {
    CLOSED = "啊哦，居然打烊了。",
    OCCUPIED = "排队可是个好习惯！",
}
STRINGS.ACTIONS.TRADE_BBSHOP_M = "进去瞧瞧"

STRINGS.NAMES.MYTH_SHOP_RAREITEM = "珍奇小摊"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_SHOP_RAREITEM = "这店主贼喜欢些稀奇古怪的玩意儿。"

STRINGS.NAMES.MYTH_SHOP_INGREDIENT = "菜市小铺"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_SHOP_INGREDIENT = "这里卖的瓜果肉蛋，保熟吗？"

STRINGS.NAMES.MYTH_SHOP_ANIMALS = "花鸟小铺"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_SHOP_ANIMALS = "是家有趣的可爱小动物交易铺。"

STRINGS.NAMES.MYTH_SHOP_PLANTS = "禾种小铺"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_SHOP_PLANTS = "真不知道他们也不种田，怎么搞到这么多种子。"

STRINGS.NAMES.MYTH_SHOP_FOODS = "茶肴小铺"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_SHOP_FOODS = "真是个打打牙祭的好去处！"

STRINGS.NAMES.MYTH_SHOP_WEAPONS = "铸匠小铺"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_SHOP_WEAPONS = "这铺的师傅打造修理，样样精通。"

STRINGS.NAMES.MYTH_SHOP_NUMEROLOGY = "算命小铺"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_SHOP_NUMEROLOGY = "骗人的，我从不迷信。"

STRINGS.NAMES.MYTH_SHOP_CONSTRUCT = "材瓦小铺"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_SHOP_CONSTRUCT = "啊，好怀念这种逛家具店的感觉。"

STRINGS.NAMES.MYTH_IRON_BROADSWORD = "铸铁大刀"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_IRON_BROADSWORD = "大刀，向敌人们滴头上砍去。"

STRINGS.NAMES.MYTH_IRON_HELMET = "铸铁头盔"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_IRON_HELMET = "戴上它我就头铁了。"

STRINGS.NAMES.MYTH_IRON_BATTLEGEAR = "铸铁战甲"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_IRON_BATTLEGEAR = "穿上它我就是铁公鸡了。"

STRINGS.NAMES.MINIFLARE_MYTH = "窜天猴"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MINIFLARE_MYTH = "爆竹声中一岁除"

STRINGS.NAMES.FIRECRACKERS_MYTH = "爆竹"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FIRECRACKERS_MYTH = "一飞冲天，春到人间"

STRINGS.NAMES.TREASURE_SHOW_MYTH = "很正常的土堆"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TREASURE_SHOW_MYTH = "我觉得，牌子上写得对。"

STRINGS.BBSHOP = {
    BUTTON_FATE = "算卦",
    BUTTON_DO_FATE = "占一卦",
    BUTTON_TREA = "藏宝图卷轴",
    BUTTON_DO_TREA = "买一张",
    BUTTON_SEASONSEEDS = "季节种子包",
    BUTTON_DO_BUY = "购买",
    BUTTON_DO_BUYALL = "购买全部",
    BUTTON_DO_SELL = "出售",
    BUTTON_DO_SELLALL = "出售全部",
    BUTTON_DO_FIX = "修理",
    DESC = {
        FATE = "三言两语中，望你自悟天机。",
        TREA = "乾之下，坤之上，有一宝，无异相。",
        SEASONSEEDS = "随机给你一些最适合当季种植的种子。",
        FIX = "磨损严重，不如让我修缮修缮。",
        FIXED = "完好如初，暂时不需要修缮了。",
        BUY = "要买吗？",
        BUY_NONE = "已经卖光了。",
        SELL = "最近我在收购这个，你有吗？",
        SELL_NONE = "我不需要了。",
        myth_iron_broadsword = "精铁铸造的上好武器。",
        myth_iron_helmet = "精铁铸造的上好头盔。",
        myth_iron_battlegear = "精铁铸造的上好护甲。",
    },
    WORDS = {
        rareitem = {
            say_welcom = { "欢迎光临！", "欢迎欢迎！", },
            say_refuse = { "客官请别这样。", "别戏弄我啦。", },
            say_buy = { "放心吧，我可不会卖假货。", "客官真是好眼光。", "谢谢惠顾。", },
            say_buy_nocoin = { "你的钱哪去了？", "客官真会说笑。", "这点钱，很难替你办事啊。", "我得戳醒你，你钱不够。", },
            say_buy_nocount = { "抱歉，已经卖光啦。", "卖光了，再看看别的吧。", },
            say_sell = { "这个东西我就收下啦。", "客官的货可真是上好佳。", "这东西也不值钱，我就勉为其难收了。", },
            say_sell_nocount = { "客官是在开玩笑吧。", "东西呢？", },
            say_sell_noneed = { "抱歉，我不收了。", "这东西暂时不需要了。", },
        },
        ingredient = {
            say_welcom = { "欢迎，要买点啥啊？", "请随便看看。", },
            say_refuse = { "去摆弄蔬菜吧。", "别摸我啦。", },
            say_buy = { "放心吧，都是很新鲜的。", "要是坏的，包赔。", "谢谢惠顾。", "再买点呗，够吃吗。", },
            say_buy_nocoin = { "钱不够哦。", "你开玩笑的吧。", "这点钱，很难替你办事啊。", "这里概不赊账。", },
            say_buy_nocount = { "抱歉，已经卖完啦。", "卖完了，再看看别的吧。", "卖得好火，都卖光了。", },
            say_sell = { "辛苦了。", "客官的货可真是上好佳。", "这东西不太新鲜了，不过我就勉为其难收了。", },
            say_sell_nocount = { "你的货呢？", "东西呢？", "这点数量我也卖不出去。", },
            say_sell_noneed = { "抱歉，太多了我也卖不完呢。", "这菜暂时不需要了。", "够了够了，我这也没冰箱。" },
        },
        animals = {
            say_welcom = { "欢迎，一屋子小可爱等着你呢。", "建议你别乱碰，有些小可爱脾气大。", },
            say_refuse = { "我有什么好玩的。", "你也有个有趣的灵魂？", "客官还是看看别的吧。", },
            say_buy = { "要好好照顾小可爱哟。", "啊，真是好眼光。", "它也该换新主人了。", "以后就交给你了。", },
            say_buy_nocoin = { "钱不够啊。", "客官真会说笑。", "啊哦，荷包空空。", "这么可爱的动物你舍得白嫖吗？！", },
            say_buy_nocount = { "我的小可爱们已经卖光啦。", "卖光了，再看看别的小可爱吧。", },
            say_sell = { "暂时由我当它的主人啦。", "太可爱了！", "你好小家伙，别怕。", },
            say_sell_nocount = { "客官是在开玩笑吧。", "你的小可爱呢？", },
            say_sell_noneed = { "就这么大点地，装不下了。", "拥挤的环境可不适合它们。", },
        },
        plants = {
            say_welcom = { "想种点什么？", "需要什么给我说。", },
            say_refuse = { "小心点。", "别看我这个样子就好欺负。", "你找茬是吧！", },
            say_buy = { "都是今年的新种。", "既然你买了，你应该知道怎么种吧。", "每颗种子都是辛劳获取，要珍惜。", },
            say_buy_nocoin = { "这里概不赊账。", "你开玩笑的吧", },
            say_buy_nocount = { "已经卖光了。", "种点别的吧。", },
            say_sell = { "好嘞，你的辛苦没有白费。", "真大真饱满。", "我都种不出来这么好的。", "佩服你的栽种能力。", },
            say_sell_nocount = { "你在骗我吗？", "东西呢？", "我看着像傻子吗？", },
            say_sell_noneed = { "留着你自己吃吧。", "我不要了。", "你说你辛苦，我就不辛苦了？", },
        },
        foods = {
            say_welcom = { "欢迎！客官您请坐。", "想吃点啥。", "什么风把您吹来啦。", },
            say_refuse = { "客官不可以。", "别弄我啦，看菜单吧。", },
            say_buy = { "好嘞，菜马上就好！", "上菜！", "再点一些吧，还有招牌菜呢！", },
            say_buy_nocoin = { "我这不能赊账。", "客官真会说笑。", "再看看别的吧，这个你吃不起。", "你钱不够吧。", },
            say_buy_nocount = { "抱歉，已经卖完了。", "实在抱歉，卖光了。", "要不您再点些别的？", },
            say_sell = { "真是美味佳肴！", "客官的厨艺果然上乘。", "啧啧，太香了。", "我都不会这做法。", "您的厨艺可不一般。", },
            say_sell_nocount = { "巧妇难为无米之炊。", "只见客官不见菜呀。", },
            say_sell_noneed = { "抱歉，再收就是在做亏本生意了。", "暂时不需要了，明天早点来吧。", },
        },
        weapons = {
            say_welcom = { "你要打造什么？", "想订点啥？", "修缮之类的活可以放心交给我。", },
            say_refuse = { "别碰我。", "你想干什么。", "站远点，这边危险。", },
            say_buy = { "我的得意之作。", "我打造的刀剑是最锋利的。", "我打造的装甲是最坚固的。", },
            say_buy_nocoin = { "概不赊账。", "没钱就去别的地玩吧。", "再看看别的吧，这个你买不起。", "别烦我了。", },
            say_buy_nocount = { "卖完了。", "一把好剑可没那么容易锻造出来。", "看看别的吧，没库存了。", },
            say_sell = {},
            say_sell_nocount = {},
            say_sell_noneed = {},
            say_fix = { "很快的，等我一下。", "这东西好修。", "挺精致的，要修得花点时间。", "等吧，我尽量快点。",
                "真是少见的武器，我得琢磨琢磨。", "要善用武器，不然坏得很快。", "磨损严重，你等会吧。", },
        },
        numerology = {
            say_welcom = { "天算不如人算。", "要我为你占一卦吗？", "请坐吧，想算卦吗？", },
            say_refuse = { "我是瞎子，但是不是傻子。", "天机不可泄露。", },
            say_buy = { "这可是货真价实的狗皮膏药。", "我这可不是地摊货。", "东西都买了，要算卦吗？", },
            say_buy_nocoin = { "我算出你没钱了。", "不给钱会遭天谴。", "我算算，你最近手头很紧对不对？", "没钱就不可知命。", },
            say_buy_nocount = { "卖光咯。", "别买啦，要不让我给你算一卦吧。", "命里无时莫强求。", },
            say_sell = {},
            say_sell_nocount = {},
            say_sell_noneed = {},
            say_treasure = { "凑近点，我告诉你一个小秘密...", "我这有一张藏宝图，给你看看吧。", "别担心，这独家秘密绝没有第三人知道。",
                "客官出手真是阔绰，我就把秘密告诉你吧。", },
            say_treasure_error = { "命里有时终须有，命里无时莫强求。", "不好意思，我弄丢了。", "你等下，我找找看。",
                "有些累，让我歇会。", "别急，我马上就能找到。", },
            say_fate = {
                "这一卦太过凶险，不可述之。", "你没吃早饭吧，还是要对胃好点。", "你有倾心的对象吗。", "今日不宜出远门。",
                "今日宜说\"棒\"！", "小时候我不小心掉进河里，磕到脑袋，从此能识天命知歧路。", "最近你有桃花运哦。",
            },
            say_fate_dog = { "狂犬之袭，{time}天之期！", "疯狗要来了，约{time}天后。", },
            say_fate_bearger = { "尖嘴獠牙，狂兽将于{time}天至！", "巨熊之灾，{time}天之期！", },
            say_fate_deerclops = { "{time}天后，独眼怪物要来了。", "万万小心，{time}天后，鹿角怪将来大肆破坏。", },
            say_fate_season = { "时间过得真快呀，还有{time}天就要换季了。", "美好的季节还剩{time}天咯。", },
            say_fate_moon = { "今晚{time}。", "满盈玉盘还是无月之夜，是{time}。", "月满月亏月乾坤，月缺月盈月阴阳，是为{time}。", },
            say_fate_rain = {
                "万里无云，心情如天气一样晴朗。", "即使多云也不会影响我们的心情。", "阴天，房间要点灯。",
                "乌云密布，记得收衣服。", "山雨欲来风满楼。",
            },
        },
        construct = {
            say_welcom = { "欢迎，搞家装吗？", "欢迎啊，要建点什么？", },
            say_refuse = { "你在做什么！", "别看我呀。", },
            say_buy = { "写得很详细，傻子都能学会。", "都是我熬夜绘制的。", "每一种建筑都有我独到的见解。", "谢谢你的肯定。", },
            say_buy_nocoin = { "一分钱一分货。", "你是不把我放在眼里吗！", "我自己都缺钱。", "生意难做啊。", },
            say_buy_nocount = { "卖光了，只剩我脑子里还有了。", "没了，别催我做新的。", "有印刷术提高我制图效率就好了。", },
            say_sell = {},
            say_sell_nocount = {},
            say_sell_noneed = {},
        },
    },
    MOONSTATE = {
        new           = "新月",
        quarter       = "峨眉月",
        half          = "弦月",
        threequarter  = "凸月",
        full          = "满月",
    },
    CLUE = { "在{address}的地点，{time}时，{weather}，会找到你想要的东西。" },
    CLUEADDRESS = {
        multiplayer_portal = "一元初始",
        pigking = "蛮夷之王所在",
        lava_pond = "烈火熔融",
        oasislake = "风沙掩盖",
        pond = "隔水听蛙",
        pond_mos = "泽国多蚊",
        moonbase = "承接月华",
        critterlab = "精灵顽动",
        beequeenhive = "诸蜂守卫",
        moonland = "月影徘徊",
        myth_ghg = "太阴宫所居",
        fangcunhill = "桃花烂漫",
        hermithouse = "隐士隐居",
        peachtree_myth = "桃花烂漫",
        myth_plant_bamboo = "竹影婆娑",
        myth_shop = "竹影婆娑",
        walrus_camp = "猎牙捕兽",
        wormhole = "颠倒乾坤",
        beefalo = "牦牛舐犊",
        lightninggoat = "膻根群聚",
        deer = "袋匙源头",
        koalefant = "合眼摸象",
        gravestone = "枯骨长眠",
    },
    CLUETIME = {
        "日正当午", --1：白天
        "夕阳渐坠", --2：黄昏
        "夜静阑珊", --3：夜晚
        "满月盈天", --4：满月
        "朔月隐晦", --5：新月
    },
    CLUEWEATHER = {
        "万里无云", --1：晴天
        "阴雨绵绵", --2：雨雪天
    },
    NIANWEIDU = {
        "毫无氛围可言，与平日并无不同",
        "稀疏平常的年味，也许可以称作年吧",
        "已经许久，没有这样热闹的气氛啦",
        "岁岁有今日，年年有今朝",
        "欢天喜地吉祥日，风风火火过大年",
    },
    TAOQIZHI = 
    { "地天泰，小往大来，通泰吉祥", "前方祸福不定，莫要浑浑噩噩", "我观你印堂发黑，怕是要有血光之灾", },
}

STRINGS.USE_MYTH_DELIVER = "传信"

STRINGS.NAMES.PASS_COMMISSIONER = "酆都路引"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PASS_COMMISSIONER = "娑婆苦，死无常，何人敢放荡"

STRINGS.NAMES.PASS_COMMISSIONER_YLW = "酆都路引·阎罗王"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PASS_COMMISSIONER_YLW = "娑婆苦，死无常，何人敢放荡"

STRINGS.NAMES.PASS_COMMISSIONER_WZ = "酆都路引·魏征"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PASS_COMMISSIONER_WZ = "善果，当赏之"

STRINGS.NAMES.PASS_COMMISSIONER_ZK = "酆都路引·钟馗"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PASS_COMMISSIONER_ZK = "恶果，自食之"

STRINGS.NAMES.PASS_COMMISSIONER_CJ = "酆都路引·崔珏"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PASS_COMMISSIONER_CJ = "律令之下，功过自有判"

STRINGS.NAMES.MYTH_HIGANBANA_REBORN = "曼珠沙华"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_HIGANBANA_REBORN = "黄泉边岸多少事？一碗孟婆送白头。"

STRINGS.NAMES.PASS_COMMISSIONER_LZD = "酆都路引·陆之道"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PASS_COMMISSIONER_LZD = {
    GENERIC = "查鉴功过，善恶不可欺",
    INACTIVE = "得先传个口信。", --无常给非激活的路引时触发
    ONLYYAMA = "这不是我能用的。", --非无常角色给予时触发
    NOTSOUL = "这位大人只要善恶魂魄。", --无常给非善恶魂时触发
}

STRINGS.NAMES.PASS_COMMISSIONER_MP = "酆都路引·孟婆"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PASS_COMMISSIONER_MP = "浑浑噩噩，饮汤一碗"

STRINGS.NAMES.MYTH_HOUSE_BAMBOO = "苍竹瓦屋"
STRINGS.RECIPE_DESC.MYTH_HOUSE_BAMBOO = "苍竹碧瓦归何处"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_HOUSE_BAMBOO = "黛瓦碧竹，江南流水"

STRINGS.NAMES.WALL_DWELLING_ITEM = "黑瓦白墙"
STRINGS.RECIPE_DESC.WALL_DWELLING_ITEM = "青瓦人已荒，苍烟起白墙"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WALL_DWELLING_ITEM = "青瓦人已荒，苍烟起白墙"

STRINGS.NAMES.WALL_DWELLING = "黑瓦白墙"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WALL_DWELLING = "青瓦人已荒，苍烟起白墙"

STRINGS.NAMES.FENCE_BAMBOO_ITEM = "竹栅栏"
STRINGS.RECIPE_DESC.FENCE_BAMBOO_ITEM = "竹香悠悠"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FENCE_BAMBOO_ITEM = "小院庭芜绿，凭栏忆往昔"

STRINGS.NAMES.FENCE_BAMBOO = "竹栅栏"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FENCE_BAMBOO = "小院庭芜绿，凭栏忆往昔"

STRINGS.NAMES.FENCE_GATE_BAMBOO_ITEM = "竹门"
STRINGS.RECIPE_DESC.FENCE_GATE_BAMBOO_ITEM = "半掩门扉"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FENCE_GATE_BAMBOO_ITEM = "竹门何设护此身"

STRINGS.NAMES.FENCE_GATE_BAMBOO = "竹门"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FENCE_GATE_BAMBOO = "竹门何设护此身"

STRINGS.NAMES.MYTH_ROCKTIPS = "鹅卵石"
STRINGS.RECIPE_DESC.MYTH_ROCKTIPS = "也许没那么膈脚"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_ROCKTIPS = "崎岖的小路上布满了鹅卵石"

STRINGS.NAMES.MYTH_STOOL = "木凳子"
STRINGS.RECIPE_DESC.MYTH_STOOL = "坐下休息吧"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_STOOL = "可得要好好休息一阵"

STRINGS.NAMES.MYTH_NIAN_FUR = "年兽鬃毛"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_NIAN_FUR = "除夕午夜，扰乱人间"

STRINGS.NAMES.MYTH_NIAN = "年兽"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_NIAN = "金灿如阳的鬃毛"

STRINGS.NAMES.NIAN_MOUNT = "年兽"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NIAN_MOUNT = "你现在温顺多了 "

STRINGS.NAMES.MYTH_NIANHAT = "年兽面具"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_NIANHAT = "兽面遮羞，莫惹烦愁"

STRINGS.NAMES.NIAN_BELL = "年兽铃铛"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NIAN_BELL = "好似有东西在打呼噜"

STRINGS.NAMES.MINIFLARE_MYTH = "窜天猴"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MINIFLARE_MYTH = "爆竹声中一岁除"

STRINGS.NAMES.FIRECRACKERS_MYTH = "爆竹"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FIRECRACKERS_MYTH = "一飞冲天，春到人间"

STRINGS.NAMES.MYTH_FIREESSENSE = "日之精华"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FIREESSENSE = "至刚至阳，凝为此物"

STRINGS.NAMES.MYTH_COLDESSENSE = "月之精华"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_COLDESSENSE = "至柔至阴，化为此形"

STRINGS.NAMES.CANE_PEACH = "桃木手杖"
STRINGS.CHARACTERS.GENERIC.CANE_PEACH = "弃其杖，化为邓林"

STRINGS.NAMES.MYTH_PLANT_INFANTREE_TRUNK = "被推倒的树根"
STRINGS.CHARACTERS.GENERIC.MYTH_PLANT_INFANTREE_TRUNK= "一截枯朽的树根，怕是仙神难救"

STRINGS.NAMES.MYTH_PLANT_INFANTREE_MEDIUM = "复苏仙树"
STRINGS.CHARACTERS.GENERIC.MYTH_PLANT_INFANTREE_MEDIUM = "日月凝聚，枯木逢春"

STRINGS.NAMES.MYTH_PLANT_INFANTREE = "人参果树"
STRINGS.CHARACTERS.GENERIC.MYTH_PLANT_INFANTREE = "仙山松鹤，天开地辟一灵根"

STRINGS.NAMES.MYTH_PLANT_INFANT_FRUIT = "人参果"
STRINGS.CHARACTERS.GENERIC.MYTH_PLANT_INFANT_FRUIT = "如婴似娃，食之长生"

STRINGS.NAMES.MYTH_INFANT_FRUIT = "人参果"
STRINGS.CHARACTERS.GENERIC.MYTH_INFANT_FRUIT = "如婴似娃，食之长生"

STRINGS.NAMES.MYTH_GOLD_STAFF = "金击子"
STRINGS.CHARACTERS.GENERIC.MYTH_GOLD_STAFF = "一条赤金，二尺长短"

STRINGS.NAMES.INFANTREE_CARPET = "人参果地毯"
STRINGS.RECIPE_DESC.INFANTREE_CARPET = "缠根青苔绿"
STRINGS.CHARACTERS.GENERIC.INFANTREE_CARPET = "叶落纷纷，融入此身"

STRINGS.NAMES.COMMISSIONER_BOOK = "判官笔·生死簿"
STRINGS.CHARACTERS.GENERIC.COMMISSIONER_BOOK = "钦定生死，何敢不从？"

STRINGS.NAMES.COMMISSIONER_FLYBOOK = "生死簿"
STRINGS.CHARACTERS.GENERIC.COMMISSIONER_FLYBOOK = "钦定生死，何敢不从？"

STRINGS.NAMES.COMMISSIONER_MPT = "孟婆汤"
STRINGS.CHARACTERS.GENERIC.COMMISSIONER_MPT = "沧浪之水涤清浊"

STRINGS.NAMES.MYTH_PLAYERREDPOUCH_NORMAL = "红包"
STRINGS.CHARACTERS.GENERIC.MYTH_PLAYERREDPOUCH_NORMAL = "喜悦情义最深重，钱财寡少皆喝彩！"

STRINGS.NAMES.MYTH_PLAYERREDPOUCH_SUPER = "好运红包"
STRINGS.CHARACTERS.GENERIC.MYTH_PLAYERREDPOUCH_SUPER = "彩绳穿线过，编织做龙形"

STRINGS.MYTH_YJP_NEEDMAX = "长春虽妙，甘露枯涸"

STRINGS.MYTH_INFANT_FRUIT_ONDROP = {
    GENERIC = "这果子还能被泥巴吃了吗？",
    monkey_king = "俺老孙一时糊涂，忘了这果子习性",
    pigsy = "不会是那泼猴又在耍俺吧",
    neza = "哎，哪吒摘的人参果哪去了",
    white_bone = "这滔天的机缘我是无福可享了",
    yangjian = "师傅曾提过此事 罢了",
    myth_yutu = "啊，我又办砸了，这可怎么办呀",
    yama_commissioners = "这下可坏事了",
    madameweb="糟糕 妾身忘记织网了",
    myth_tudi = "大圣，这可不关小老儿的事",
}

STRINGS.NAMES.PANDAMAN_MYTH = "熊猫村民"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PANDAMAN_MYTH = "流离失所的熊猫村民在重建他们的家园"

STRINGS.NAMES.MYTH_FOOD_THL = "糖葫芦"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_THL = "闻一闻都要流口水了"

STRINGS.NAMES.MYTH_FOOD_NRLM = "牛肉拉面"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_NRLM = "牛味十足，汤香四溢 "

STRINGS.NAMES.MYTH_FOOD_DJYT = "豆浆油条"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_DJYT = "每天都要按时吃早餐哦"

STRINGS.NAMES.MYTH_FOOD_CDF = "臭豆腐"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_CDF = "太香了，只有一点点臭味罢了"

STRINGS.NAMES.MYTH_FOOD_LRHS = "驴肉火烧"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_LRHS = "一个不过，两个太撑 "

STRINGS.NAMES.MYTH_FOOD_LHYX = "莲花血鸭"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_LHYX = "辣到我心坎了"

STRINGS.NAMES.MYTH_FOOD_GQMX = "过桥米线"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_GQMX = "鲜香适宜，我舌头都要咬掉了"

STRINGS.NAMES.MYTH_FOOD_XCMT = "咸菜馒头"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_XCMT = "没有比这更下饭的了"

STRINGS.NAMES.TREASURE_PAPER_MYTH = "线索纸"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TREASURE_PAPER_MYTH = ""

STRINGS.PANDAMAN_MYTH_TALKS = {
    "你能帮我修缮一下店铺吗",
    "村庄重建后欢迎你前来做客",
    "村庄被怪物侵袭后很久都没有来客了",
    "你能帮我寻一些建材吗",
    "若是能帮我们重建家园那实在是万分感谢 ",
}

STRINGS.UI.CRAFTING["NEEDSMYTH_TECH_INFANTREE"] = "靠近人参果树制造一个原型！"
STRINGS.UI.CRAFTING["NEEDSMYTH_TECH"] = "使用天书制造一个原型！"
STRINGS.UI.CRAFTING["NEEDSMYTH_TECH_CHANGE_FOUR"] = "需要嫦娥满级好感度制造一个原型！"
