local STRINGS = GLOBAL.STRINGS



--图鉴相关的 都在这里
STRINGS.MYTH_BOOINFO = {

    DUIHUAN = "償還リスト",
    GEIYU = "与えられる",
    HUODE = "得られる",
    NOPLAYER = "キャラクター関連の情報が失われました。キャラクターMODを有効にして情報を取り戻してください。",
    FILTER_ALL = "全部",
    YONGJIU = "無限",
    LONGER = "ロング",
    HUOQU = "取得方法",

    --神仙
    SHENXIAN = {
        laozi = {
            title = "道徳天尊、太上道祖\n「急急如律令」を燃やして老君を召喚する、彼とは貴重な素材や道具を丹薬や法具と交換できます。スワップの回数には制限があり、召喚の3日後までは再召喚できません。\n老君は化け物と取り引かない!",
        },
        ghg = {
            title = "広寒宮の主、何千年もの間、月宮の奥深くに住んでいた。\n訪問者を歓迎し、期待している，\n嫦娥は夜間は休息し、日中だけゲストをもてなする。\n嫦娥の好感度を上げるために、宝石や大きな桃などを贈るといい。\n嫦娥は月餅を客に返すこともある。",
        },
        tudi = {
            title = "地下に住む唯一の土地公公。\n土地の神殿を建てて貢物を捧げれば、農地の世話をして守ってくれるために現れる。毎年で大地豊作を祝福することができる。力が弱く、危険な時には地上から逃げてしまう。\n岩類を集めるのが好き。",
            text1 = "祝福の範囲",
            text2 = "神殿の中心に\n半径4芝床の円",
            text3 = "貢物の種類",
            text4 = "肉料理、精進料理、軽食",
            text5 = "現れる時間",
            text6 = "5日\n昼と夕方",
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
            title = "袈裟を盗んだクマの妖怪、全身真黒、力が強い。\n山を作れる、黒風になって、吹き荒れます。\nハニー、袈裟と丹薬が好き、丹薬葫蘆を持ち歩く。",
            text1 = "召喚方法",
            text2 = "混合地形の中にハニーポットを作り、その中に蜂蜜などを入れる\nそれが満たされると、黒風大王が引き寄せられてくる。",
            text3 = "注意事項",
            text4 = "黒風大王は非常に高いダメージを与え、武器を飛ばせる!\n長時間戦いから離れていると、黒風大王は風となって去っていきます。\nリフレッシュタイム:20日",
            text5 = "戦利品",
        },
        sxn = {
            title = "辟寒辟暑辟塵の三大王、三大王は毎年の\n元宵は人が灯籠の謎解きをしている間に\n灯油を騙して食べます。彼らはいろいろ\nな手段を使えだけでなく、大勢の人数\nを頼むことができる！",
            text1 = "召喚方法",
            text2 = "老朽化した貢ぎ卓が\n地図上のランダムな\n場所に生成し、春の\n夜に桃を供えてロウ\nソクを灯せば、犀牛\n三大王を召喚できる。",
            text3 = "注意事項",
            text4 = "3頭のサイはそれぞれ良い呪文と優れた戦闘精\n神を持っているので、お互いの仕事をこなすこ\nとができる。自分に有利の時では油断しやすい\n 不利の時になると、死闘を始めます。 相手が遠\nくに逃げたり、海に逃げたりすると、戦闘から\n離脱します。リフレッシュタイム：来年の春",
            text5 = "戦利品",
        },
        myth_goldfrog = {
            title = "聚宝金蟾は月宮の近くに住み、終日地下に\n隠れて自分の財宝を見守っている。伝説に\nよると、この妖怪はお金を生む大きな鉢と\nお金が生える木を持っている！\n守着自己无穷无尽的财宝。",
            text1 = "召喚方法",
            text2 = "月宫の外周の土地に\n1基の巨大な黄金の元\n宝があります！鍬で掘\nり出すなら巨大なあの\n金色のガマに怒させる\nかもしれない...",
            text3 = "注意事項",
            text4 = "厚い皮膚と硬い肉、小金蟾蜍を召喚するために多くの宝物\nにもなってプレーヤーを攻撃する。複数のプレイヤーと対峙した際には、\nプレイヤーを飲み込んでプレイヤーの装甲を直接腐食させてしまう。\n臆病者を前にすると、戦闘から離脱してそのまま消えてしまう。\nリフレッシュタイム：20日",
            text5 = "戦利品",      
        },
        zgxn = {
            title = "生命金属を身にまとった生まれつきの\n玄鳥で、蓮の花を好んで食べ、生命金\n属で覆われた島に住んで守っていると\n噂されています。 大きな声で歌い\n鳴く一発で悪意のある人を混乱させる",
            text1 = "召喚方法",
            text2 = "非常に珍しい玄鳥は\n咲いている蓮を引か\nれることがある\n咲き誇る蓮の池の横\nに登場する可能性が\nあります。",
            text3 = "注意事項",
            text4 = "性格はおとなしく、蓮を食べた後はすぐに退散します。\n怒らせてはいけない。\nリフレッシュタイム：10日",
            text5 = "玄鳥の贈り",     
            text6 = "子圭石\n生命力を持つ希少金属鉱石。",     
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
            title = "地図上ではランダムな位置に桃源という隔絶された島が作られます。桃源内の野生の「蟠桃树」は自動的に成長します。採集することで、「蟠桃」を獲得することができます。また、「大蟠桃」を獲得する確率もあります。プレイヤーは「大蟠桃」を地面に植えて育てる「蟠桃树」を作ることができます。「蟠桃树」は成長周期が遅い、どのような方法で促成してもできませんですが、冬でも成長できます。「蟠桃树」を壊したらカンプスを呼びます。カンプスを撃ったら少量の「蟠桃」が得られます。",
            text1 = "霊台方寸山",
            text2 = "世外桃源 孤僻仙山\n妙法破禁 四方灯開\n須菩提の旧居に入れる\n飛行の術を身につける", 
            text3 = "蟠桃树", 
            text4 = "桃源特有の植物\n蟠桃と大蟠桃を収穫させる\n桃源を壊すと大変なことが起こる",      
        },
        yuegong = {
            title = "地図の周辺には無垢な「月のかけら」がランダムに出現します。年中雪が降っていて、寒い限りです。このかけらの中心には上品な宮殿があります。外周の寒冷な土地には変な元宝の像一つがあります......",
            text1 = "広寒宮",
            text2 = "月の宮殿の中心に「嫦娥\n仙子」が住んでいます\n広寒宮は昼間しか入れません\n夜が来る前に離れ\nなければなりません", 
            text3 = "金元宝", 
            text4 = "「聚宝金蟾」がここで冬眠します\n彼の休息を妨げる者は厳しく罰せられる\n 周りに脅威がなくなると逃げ出し\n20日後まで再び現れることはありません",           
        },
        zhulin = {
            title = "マップ外周のランダムな場所に、竹で覆われた島がある。 この島の片隅に住んでいる住民たちがいる。 もう一角は、元に住民が祖先を祀っていた場所だが、現在は妖怪に乗っ取られ、毎年春になると供物台を設置して住民に平和のための供物を求めるようになったと言われている。",
            text1 = "蓮",
            text2 = "蓮は池で育ち、春に成長し、秋に成熟し、夏に栄える、冬には枯れる。 蓮の葉はカミソリで刈り取れる。 蓮の花が咲くと、稀少な子圭玄鳥を引き寄せてこの世に降りてきますが、子圭玄鳥は生命力の象徴である子圭石を贈り物として残します。 蓮を玄鳥にあげて祝福と平和を願うと、より多くの子圭石を手に入れることができます。",     
            text3 = "使い古された供物台", 
            text4 = "青竹州の住民が祖先を祀っていた場所を、\nサイの三王が占拠したのだ。 彼らは、\n毎年春の上元節になると、供養台を設けて\n貢ぎ物を頼みに来た。春の夜に桃を供えて\nロウソクを灯し、サイの三王を招けます。",
            text5 = "竹", 
            text6 = "生长在青竹洲的竹子修长挺拔，四季青翠，喜欢成片生长，在雨水充沛的春季繁殖速度极快，是极好的造纸材料。竹子有多个生长阶段，鲜嫩的竹笋可口美味，使用竹子烹饪的食物更是别有一番风味，成竹有可能会继续生长成坚硬苍竹。使用苍竹搭建房子是个不错的选择。",    
            text7 = "竹の町", 
            text8 = "守護神の像",
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
        lianzhi = "錬製",
        shenhua = "神話",
        shenxian = "神仙",
        yaoguai = "妖怪",

        xiandan = "仙薬",
        fabao = "法具",
        cailiao = "材料",
        zhuangbei = "装備",
        jianzhu = "建築",
        gongju = "工具",
        shiwu = "食品",
        jineng = "技能",
        feixingshu = "飛びの術",
    },

    ITEM_DES = {--物界面描述
        heat_resistant_pill = "炎や熱に対する免疫！",
		cold_resistant_pill = "免疫潮湿，免疫低温过冷！",
		dust_resistant_pill = "砂塵と嵐に対する免疫！",
		fly_pill = "获得风驰电掣般的速度提升！\n使用之后改变飞行术的配方",
		bloodthirsty_pill = "恐ろしい吸血能力を得る、副作用にご注意！",
		armor_pill = "防御力が上がり、ダメージが半分になる！",
		condensed_pill = "戦闘力を上げ、攻撃力を2倍にする",
        thorns_pill = "植物からのダメージを受けず、体を守れる！",
		movemountain_pill = "重い荷物を持っても走れる力！",
		bananafan_big = "陰陽両生、ひと振ったら、全ての炎を消せる！ ",
		laozi_sp = "お札を地面に置いて火をつけたら、「太上老君」を召喚できる！",
		mk_huoyuan = "锁子黄金甲の製錬材料！",
		mk_longpi = "锁子黄金甲の製錬材料！",
		mk_hualing = "凤翅紫金冠の製錬材料！",
		purple_gourd = "選んだ区域に小型生物を吸入できる！",
		myth_yjp = "水や肥料を与え、作物を蘇らせ、雨を吸収する!",
		myth_passcard_jie = "教育には身分や地位はない\nこのトークンを持っている妖怪は、「太上老君」とトレードできます。！",
		laozi_bell = "「太上老君」が「青牛」のために鍛えた鈴！",
		saddle_qingniu = "「太上老君」が「青牛」のために鍛えた鞍！",
		myth_weapon_syf = "凍結効果のある攻撃\nスキル「アイススイープ」を使用可能！",
		myth_weapon_syd = "攻撃をすればするほど、ダメージが大きくなる\nスキル「炎の斬り」を使用可能！",
		myth_weapon_gtt = "攻撃には範囲指定のダメージがある\nスキル「全力一撃」を使用可能！",
		
		siving_stone = "七星剣、及び子圭装備の製錬材料！",
		myth_qxj = "影の生物を秒杀できるが、戦利品がない\nスキル「一尺寒光」を使用可能！",
		siving_hat = "傷を減らして精神を回復させる\n装備の耐久消耗を減らせる！",
		armorsiving = "傷を減らして精神を回復させる\n日光の下で自動的に修復できる部分の耐久性ができる！",
		myth_fuchen = "移速を増加して、生物の恨みを除去する\nスキル「隔空取物」を使用可能！",
		
		yangjian_armor = "8割のダメージを防ぎ、移動速度が上がる、\n耐水性、耐凍性がある！",
		yangjian_hair = "スキル消費量とスキルクールダウンを軽減す、\nモンスターを撃ち殺して理性を回復できる！",
		golden_armor_mk = "8割半のダメージを防ぎ、2割の攻撃を上げる、\n着てから誰も止められない！",
		golden_hat_mk = "スキル消費量とスキルクールダウンを軽減す、\nモンスターを撃ち殺して理性を回復できる！",
		
		book_myth = "东方古い神話の本、ロック解除神話技術\n火をつけて天書図鑑になる！",
		alchmy_fur = "正しい材料を加えて、丹薬や道具を作れる\n材料の取り違えにご注意！",
		myth_cash_tree_ground = "お金を生み出し続ける宝物\n2日に1回、お宝が落とす！",
		cassock = "精神を回復と食への欲求を軽減！",
		kam_lan_cassock = "悪夢の攻撃を防ぎ、精神を回復\n食への欲求を軽減！",
		mk_battle_flag = "範囲内、攻撃力アップ、移動速度アップ\n精神を回復できる！",
		xzhat_mk = "寒さを防ぐ、精神を回復できる！",
		pill_bottle_gourd = "丹薬のみ収納可能、8つの収納スペース\n瓢箪の中では丹薬が効かず、耐久性も消費されない！",
		wine_bottle_gourd = "直接飲用できるし，\n蟠桃素酒を使用して耐久性を補える！",
		myth_zongzi = "持てる、海に投げ込んで魚を誘える\n開封したらすぐに食べられる！",
		myth_redlantern = "照明、燃やすい、傷つきやすい\n持てる、灯籠架に吊るすことも可能！",
		myth_bbn = "満月に月光を吸収する必要がある\n使用後は9つの収納スペースがある！",
		myth_fence = "きれいな衝立！",
		myth_interiors_ghg_flower = "きれいな盆栽！",
		myth_interiors_ghg_groundlight = "きれいな宮灯、照明を提供できる！",
		myth_interiors_ghg_he_left = "きれいな仙鶴飾り！",
		myth_interiors_ghg_he_right = "きれいな仙鶴(右)飾り！",
		myth_interiors_ghg_lu = "きれいな香炉！",
		myth_redlantern_ground = "二つの灯籠を掲げられる！",
		myth_ruyi = "傷つきやすい、桃の摘み取り速い\n大蟠桃の掉率を上げる！",
		myth_yylp = "近くは天体の科学技術をロックできる、夜間照明\nただ一つ、線下を持ってはいけない！",
		myth_mooncake_ice = "食べた後は精神値を一日ロックする\n重畳不可！",
		myth_mooncake_lotus = "摂取後1日は偏食がなく、有害な影響も受けない\n重畳不可！",
		myth_mooncake_nuts = "食べた後は飽食値を一日ロックする\n重畳不可！",
		
		lotus_flower = "食材として使用可能\n「混天绫」の耐久性を補える！",
	    lotus_seeds = "そのまま食べても、食材として使ってもOK！\nそれを池に植えて蓮を育てる！",
		lotus_seeds_cooked = "そのまま食べても、食材として使ってもOK！",
        lotus_root = "そのまま食べても、食材として使ってもOK！",
        lotus_root_cooked = "そのまま食べても、食材として使ってもOK！",
        myth_lotusleaf = "食材として使用可能\n傘のように直接持てる！",
		
        myth_bamboo = "基礎材料、食材として使用可能！",
		myth_greenbamboo = "珍しい材料！",
		myth_bamboo_shoots = "そのまま食べても、食材として使ってもOK，\n地面に蒔いて竹に育てる！",
		myth_bamboo_shoots_cooked = "そのまま食べても、食材として使ってもOK！",
		bigpeach = "美味い！",
		peach = "そのまま食べても\n食材として使ってもOK、火で炙ける！",
		peach_cooked = "そのまま食べても\n食材として使ってもOK！",
		gourd = "农作物，适合秋季生长！",
		gourd_cooked = "そのまま食べても\n食材として使ってもOK！",
		myth_banana_leaf = "芭蕉の葉の包装の作成に使用可能\n食材として使える！",
		myth_bundle = "使い捨ての包装袋！",
		myth_cash_tree = "「摇钱树」の製造材料、全世界でただ一つ！",
		myth_coin = "「聚宝盆」でラッキーギフトの抽選に使える！",
		myth_food_table = "8つの料理が置ける、永久保存！",
		myth_granary = "野菜だけでなく、種も長期保存できる、燃えやすい！",
		myth_toy = "地面に置いてお正月の風情を高める、\nブタの王様と元宝を交換できる！",
		myth_tudi_shrines = "肉類、精進料理、軽食を提供すれば\n5日間、「土地公公」を召喚して作物の世話をする！",
		myth_well = "冬は氷がなく、釣りができない\nくすぶりを防ぐことができて、ヤカンで水を受ける！",
		myth_banana_tree = "バナナや芭蕉の葉が収穫できる！",
		bananafan = "芭蕉宝扇の製錬材料\n呼風喚雨！",
		myth_rhino_blueheart = "辟寒丹と霜鉞斧の製錬材料！",
		myth_rhino_redheart = "辟暑丹と暑熤刀の製錬材料！",
		myth_rhino_yellowheart = "辟塵丹と扢撻藤の製錬材料！",
		siving_rocks = "子圭青金の製錬材料！",
		krampussack_sealed = "紫金葫蘆の製錬材料！",
		myth_huanhundan = "魂が離れたチームメートの体を与えて、\nチームメートの魂を呼び戻すことができる！",
		myth_coin_box = "銅銭の大きなひも！",
	    myth_mooncake_box = "おいしい月餅をたっぷり！",

		myth_flyskill = "飛んでしまった、転ばないように気をつけて！",

		myth_flyskill_mk = "もんどり打てば十万八千里の外に行ける、速い！",
		mk_dsf = "敵意がある生き物を全画面に定着した！",
		mk_jgb = "孙悟空の専属武器、攻撃距離が長い\nスキル「身外身法」を使用可能！",

		nz_lance = "哪吒の専属武器、火属性ダメージ倍増\nスキル「三头六臂」を使用可能！",
    	nz_ring = "哪吒の専属武器、ロングレンジ ウェポン\n複数のターゲットを跳ね返せる！",
	    nz_damask = "哪吒の専属装備、移動速度を増加\n免疫ダメージ、蓮の花を使って耐久性を補う！",
	    myth_flyskill_nz = "足元で燃える炎、炎を抵抗できる！",
	    
	    bone_blade = "攻撃時に吸血効果がある\n骨の破片を使って修理できる！",
	    bone_wand = "骨の刺を召喚し、敵をコントロールしてダメージを与える\n骨の破片を使って修理できる！",
	    bone_whip =  "レンジダメージ\n骨の破片を使って修理できる！",
	    wb_heart = "使用後にゴースト状態になる\nスケルトンを残す！",
	    myth_flyskill_wb =  "陰風の中に隠されて、発見できない、攻撃できない！",

		pigsy_hat = "寒さを防ぐ、守備力アップ\n雨を防ぐ、精神を回復できる！",
	    pigsy_rake = "八戒の専属武器\n耕すだけでなく、ダメージをブロックするためにも使用可能！",
	    pigsy_sleepbed = "八戒のネスト、いつでも、どこでも眠れる\n飽食値を消耗して、精神値と生命値を回復できる！",
	    myth_flyskill_pg = "ふわふわしていて、力を節約できる。お腹が空きそうな心配はない！",
	    myth_pigsyskill_bookinfo = "変身が緩やかな回血能力と極めて高い防御を得る、\n敵を引き付けることができて、海に行って泳ぐこともできる！",
	       

	    yj_spear = "杨戬の専属武器、天雷を召喚できる\nスキル「驱雷掣电」を使用可能！",
	    myth_flyskill_yj = "この雲は雷に絡んでおり\n攻撃者に雷のダメージを与える！",
	    yangjian_track = "特別なマーカーポイントやチームメイトに直接飛べる！",
        
	    medicine_pestle_myth = "玉兔の専属武器\n粉薬を研磨のにも使える！",
	    guitar_jadehare = "琵琶の曲を覚えてから弾くとBUFF音符が生まれる、\nプレイヤーが音符をタッチすると、このBUFFを得る!",
	    myth_bamboo_basket = "薬をいっぱい入れろ！",
	    myth_flyskill_yt = "涼しい雲が、心にしみる薬の香りを放っている！",

	    bone_mirror = "美しいマントに着替え、究極の能力を得られる！",

	    --白骨披风
	    wb_armorbone = "血を吸わない代わりに防御の力を得る！",
	    wb_armorblood = "吸血能力が強化され、もっと血の味！",
	    wb_armorlight = "風のように軽く、移動速度アップ!",
	    wb_armorgreed = "余分な品物の入手確率アップ、\nスケルトン、死体滞留時間増加!",
	    wb_armorstorage = "8つのコンパートメントを追加で、\nすでにグリッドにある品物を自動的にピックアップしてくれる！",
	    wb_armorfog = "霧で能力が大幅にアップ、\n同時に骨刃がスキル「霧隠」を使用可能！",

	    hat_commissioner_white = "善魂と悪魂の吸収と貯蔵に用いる、\n一定の防雨効果がある！",
	    bell_commissioner = "善魂を消耗して周囲の生物を催眠し、\n攻撃力と移動速度を短く低下させる！",
	    token_commissioner= "悪魂を消耗して近くの生き物を恐怖状態にさせる！",
	    pennant_commissioner= "善魂を消耗して恩魂を召喚して戦う！",
	    whip_commissioner= "悪な魂が多いほど、攻撃力が高くなり、攻撃速度が低下になる!",
	    soul_specter= "善の魂、\n数が多すぎると狭い範囲にクリーチャー催眠がかかる！",
	    soul_ghast= "罪の魂、\n数が多すぎると怨霊暴動になる!",
	    myth_yama_statue1 = "魂を引き渡して属性回復を獲得し、魂の重聚時間を短縮する、\n等級が高ければ高いほど能力が強くなり、食べ物の収益が少なくなる！",
	    myth_cqf = "使用後はその場で体を残し、魂が出る状態に入る！",
	    myth_higanbana_item = "チームメイトが死ぬ時に満開し、\nその幽霊を自分の回りに送り返すことができる！",
	    myth_bahy = "満開の彼岸花は、近くの亡霊を引き連れて再び世に帰ろう!",

	    myth_flyskill_ya = "鬼火がつきまとって、形を変えて影を変えて、攻撃することができなくて、夜に攻撃されることもできない！",

	    powder_m_becomestar = "長時間発光BUFF、ウサギが薬をつき砕うのは集団の効果だ。\n嫦娥に蛍光ベリーを与えてレシピをアンロックする！",
		powder_m_charged = "短時間攻撃帯電BUFF、ウサギが薬をつき砕うのは集団の効果だ。\n嫦娥に電気ヤギの角を与えてレシピをアンロックする！",
		powder_m_coldeye = "短時間攻撃に凍結を伴うBUFF、ウサギが薬をつき砕うのは集団の効果だ。\n嫦娥にディアクロップスの眼球を与えてレシピをアンロックする！",
		powder_m_hypnoticherb = "大量のHPを回復し周囲の生物を催眠する、\ウサギが薬をつき砕うのは集団の効果だ。\n嫦娥にマンドレイクを与えてレシピをアンロックする！",
		powder_m_improvehealth = "一部のHPを回復した後、短時間でゆっくりとHPを回復する、\ウサギが薬をつき砕うのは集団の効果だ。\n嫦娥にローヤルゼリーを与えてレシピをアンロックする！",
		powder_m_lifeelixir = "満状態でチームメイトを復活させる、ウサギが薬をつき砕うのは集団の復活効果だ。\n嫦娥にガーディアンの角を与えてレシピをアンロックする！",
		powder_m_takeiteasy = "一部の精神を回復した後、短時間でゆっくりと精神を回復する、\ウサギが薬をつき砕うのは集団の効果だ。\n嫦娥にリラクシングティーを与えてレシピをアンロックする！",

		song_m_workup = "演奏してBUFF音符を出す、\n音符を拾った後の一時的な作業効率アップ",
		song_m_insomnia = "演奏してBUFF音符を出す、\n音符を拾った後の一時的に催眠にかからない！",
		song_m_fireimmune = "演奏してBUFF音符を出す、\n音符を拾った後の一時的に火属性ダメージに対する免疫！",
		song_m_iceimmune = "演奏してBUFF音符を出す、\n音符を拾った後の一時的に凍結防止シールへの耐性！",
		song_m_iceshield = "演奏してBUFF音符を出す、音符を拾った後の\n一時的に攻撃されたとき、敵に凍結を付与する！",
		song_m_nocure = "近くの敵を一時的に自分回復能力を中断する！",
		song_m_weakattack = "近くの敵の攻撃力を一時的に低下させる！",
		song_m_weakdefense = "近くの敵の防御力を一時的に低下させる！",
		song_m_nolove = "近くの牛の群れがしばらく発情しないようにさせる！",
		song_m_sweetdream = "近くの敵を眠らせる！",

	    madameweb_stinger = "使い捨ての遠距離武器！",
	    madameweb_poisonstinger = "致命的な毒素を塗った針！",
		madameweb_armor = "クモの糸の値の消耗を減らして、2格の専属物品のための格子を持つ、\n保温でき、クモの糸を使って耐久性を回復できる！",
		madameweb_poisonbeemine = "毎日毒蜘蛛を繁殖させ、肉で召還できるし、\n毒クモを巣に戻して休養することもできる！",
		madameweb_beemine = "触発すると毒蜂が敵を攻撃する！",
		madameweb_detoxify = "中毒状態を解消する！",
		madameweb_net = "地面に置くことができて、クモの巣の網を外に拡張する！",
		madameweb_pitfall = "近づいた生物を繭に縛り、繭が破裂すると生物中毒になる！",
		madameweb_feisheng = "洞窟や木陰をひっきりなしに行き来するのに適している！",
		madameweb_silkcocoon = "ホタルを入れて木陰や洞窟に吊り下げ、照明に使う！",
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
	    myth_yylp = "嫦娥仙子との好感度が最高に達したとき\n嫦娥仙子から贈る！",
		myth_mooncake = "嫦娥仙子に宝石や大きな桃などを与えることで、得るチャンスがある！",
		
		lotus_flower = "「哪吒」は骨を取り、肉を切って得られる\n開花期の蓮をカミソリで摘んで得られる！",
	    lotus_seeds = "蓮を剥き、種を収穫する！",
		lotus_seeds_cooked = "蓮の実が火で炊くことで得られる！",
		lotus_root = "枯れた蓮を収穫して得られる！",
		lotus_root_cooked = "蓮根が火で炊くことで得られる！",
		myth_lotusleaf = "開花期の蓮をカミソリで摘んで得られる！",
		
		myth_bamboo = "砍伐成竹、苍竹可以获得！",
		myth_greenbamboo = "蒼竹を伐採すると得られる！",
		myth_bamboo_shoots = "雨の後、成熟した竹の近くにタケノコが生える確率がある！",
		myth_bamboo_shoots_cooked = "筍が火で炊くことで得られる！",
		bigpeach = "桃の木から摘んで落ちる可能性がある\nクラウスを殺してゲット！",
		peach = "桃の木から摘む",
		peach_cooked = "蟠桃が火で炊くことで得られる",
		gourd = "種を植えることが手に入れる\n戦利品隠し部屋にゲット！",
		gourd_cooked = "瓢箪が火で炊くことで得られる",
		myth_banana_leaf = "芭蕉の木で集める\n芭蕉の葉の包みを解くことも一つ返せる！",
		myth_cash_tree = "聚宝金蟾を最初に撃退した時にゲット",
		myth_coin = "神話のおもちゃと豚王の取引で得る、\n特定モンスターを撃ち殺して獲得する、\n揺銭樹に落ちる確率がある！",
		myth_toy = "土地公公との取引で得る、\nクラウスを撃ち殺して獲得する、\n聚宝盆に得る確率がある！",
		bananafan = "ぜいたくな扇を太上老君と交換して得られる！",
		myth_rhino_blueheart = "辟寒大王から落ちる！",
		myth_rhino_redheart = "辟暑大王から落ちる！",
		myth_rhino_yellowheart = "辟塵大王から落ちる！",
		siving_rocks = "子圭玄鳥は蓮花を食べてから落ちるの\n蓮花をあげれば獲得のチャンスがある！",
		krampussack_sealed = "急急如律令でクランプスの袋を封印する！",
		myth_coin_box = "ひもで銅貨40枚を縛る！",

		myth_huanhundan = "裹切りの心臓で太上老君と交換して得る\n聚宝盆に得る確率がある！",
	    soul_specter= "中立生物が落ちる。",
	    soul_ghast= "悪の生物とボスが落ちる。",
		
		mk_jgb = "孙悟空を生まれた時から付いている",
		nz_zhuangbei_recipe = "哪吒を生まれた時から付いている",--哪吒三武器同一获取方式描述
		pigsy_rake = "八戒を生まれた時から付いている",
		yj_spear = "杨戬を生まれた時から付いている",
		medicine_pestle_myth = "玉兔を生まれた時から付いている",
		hat_commissioner_white = "黒白無常を生まれた時から付いている",
	    zhuangbei_commissioner_w = "白無常を生まれた時から付いている",
	    zhuangbei_commissioner_b= "黒無常を生まれた時から付いている",

		wb_armorfog = "他の5つのマントをそろえたら自動的にロックを解除する！",
		fcs_learn = "方寸山で習った後、ロックを解除する！",
		
		song_m_workup = "嫦娥に女王蜂の王冠を与えてこの曲譜を習得できる！",
		song_m_insomnia = "嫦娥に1人バンドを与えてこの曲譜を習得できる！",
		song_m_fireimmune = "嫦娥にウロコを与えてこの曲譜を習得できる！",
		song_m_iceimmune = "嫦娥に熱いヒートロックを与えてこの曲譜を習得できる！",
		song_m_iceshield = "嫦娥にアイスブリームを与えてこの曲譜を習得できる！",
		song_m_nocure = "嫦娥にクモの卵を与えてこの曲譜を習得できる！",
		song_m_weakattack = "嫦娥にぜんたくな扇を与えてこの曲譜を習得できる！",
		song_m_weakdefense = "嫦娥に分厚い毛皮を与えてこの曲譜を習得できる！",
		song_m_nolove = "嫦娥にビーファロハットを与えてこの曲譜を習得できる！",
		song_m_sweetdream = "嫦娥にパンフルートを与えてこの曲譜を習得できる！",

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
		tian = "日",
		naijiuzhi = "耐久性",
		mk = "孫悟空",
		nz = "哪吒",
		bg = "白骨夫人",
		bj = "猪八戒",
		yj = "楊戬",
		yt = "玉兔",
		hb = "黒白無常",
		hwc = "黒無常",
		bwc = "白無常",
		etc = "他のキャラクター",
		melody = "琵琶曲",
		zzj = "盤絲娘娘",


	},

	ITEM_SKIN = {--皮肤
		monkey_king1 = "出海学芸",
		monkey_king2 = "火眼金睛",
		monkey_king3 = "劇中行者",
		monkey_king4 = "六耳猕猴",
		monkey_king5 = "弼馬温",
		monkey_king6 = "白面醉翁",

		neza1 = "青蓮白藕",
		neza2 = "聖嬰大王",
		neza3 = "持纓少年",
		neza4 = "风火唱将",

		white_bone1 = "梨園画皮",
		white_bone2 = "西凉女王",

		pigsy1 = "八戒娶親",
		pigsy2 = "黄牙老象",
		pigsy3 = "室火星宿",

		yangjian1 = "墨影素鬢",
		yangjian2 = "妙道清源",
		yangjian3 = "金胄虎将",
		yangjian4 = "金翅大鹏",

		yutu1 = "蟾宮玉膳",
		yutu2 = "寒月暖冬",
		yutu3 = "杏花仙子",
		yutu4 = "月桂酒香",
		yutu5 = "悦耳甜音",

		yama1 = "蓮花洞主",

		madameweb1 = "烛香白鼠",

		myth_he_left = "左仙鹤",
		myth_he_right = "右仙鹤",

		bone_mirror1 = "一级妖镜",
		bone_mirror2 = "不完全な妖鏡",
		bone_mirror3 = "完全体の妖鏡",

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

		myth_food_table1 = "七星",
        myth_food_table2 = "墨玉",

		fence_bamboo_item1 = "枯竹",

	},

	ITEM_XIAOGUO = {
		naijiu = "耐久性",
		suoshu = "所属",
        yaoxiao = "buff時間",
        xiaoguo = "效果",
        lztime = "製錬時間",
        peifang = "処方",
	},
}


--------------------------------------------------------------------------
--[[ 杂七杂八 ]]
--------------------------------------------------------------------------
STRINGS.NAMES.MYTH_DOOR_EXIT = "ドア"
STRINGS.NAMES.MYTH_DOOR_EXIT_1 = "ドア"
STRINGS.NAMES.MYTH_DOOR_EXIT_2 = "ドア"
STRINGS.NAMES.MYTH_DOOR_EXIT_3 = "ドア"

STRINGS.NAMES.MYTH_DOOR_ENTER = "正門"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_DOOR_ENTER = "「灵台方寸山」へ，心を探しに行く。"

STRINGS.NAMES.MYTH_SMALLLIGHT = "石灯"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_SMALLLIGHT = "妙法は禁を破って、四方の明かりはつけます。"

STRINGS.MYTH_WEIGHDOWN = "踏む"

STRINGS.READ_FLY_BOOK = "読む"
STRINGS.MYTH_CLEAR = "掃除する"
STRINGS.MYTHNOFLYINROOM = "室内で、飛行術は使えません。"

STRINGS.OLDMYTH_INTERIORS = "ほこりまみれの"

STRINGS.NAMES.BOOK_FLY_MYTH = "本"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_FLY_MYTH = "残された「无字天书」"

STRINGS.NAMES.MYTH_INTERIORS_LIGHT = "ランプ"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_LIGHT = "ただ普通のランプ"

STRINGS.NAMES.MYTH_INTERIORS_BED = "ベッド"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_BED = "お茶を飲んで、座って道を論じます。"

STRINGS.NAMES.MYTH_INTERIORS_GZ = "缶"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GZ = "瓶缶"

STRINGS.NAMES.MYTH_INTERIORS_GH = "掛ける絵"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GH = "「鸿蒙初辟本无性，打破冥顽须悟空」"

STRINGS.NAMES.MYTH_INTERIORS_GH_SMALL = "掛ける絵"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GH_SMALL = "心"

STRINGS.NAMES.MYTH_INTERIORS_PF = "衝立"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_PF = "この家具はめったにないです。"

STRINGS.NAMES.MYTH_INTERIORS_XL = "香炉"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_XL = "特製の香辛料を入れると、タバコを焼くことができます。"

STRINGS.NAMES.MYTH_INTERIORS_ZZ = "机"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_ZZ = "机の上に本と未完の巻物が置いてあります。"

--新加食物
STRINGS.NAMES.MYTH_FOOD_ZPD = "豚の皮のゼリー"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_ZPD = "頭皮がしびれる"	

STRINGS.NAMES.MYTH_FOOD_NX = "バナナシェイク"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_NX = "アフタヌーンティーの楽しい時間"	

STRINGS.NAMES.MYTH_FOOD_LXQ = "ロブスターと芭蕉の葉の焼き"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_LXQ = "高級食材は往々にして最も質素な調理法を採用しなければならない..."	

STRINGS.NAMES.MYTH_FOOD_FHY = "「覆海宴」"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_FHY = "世の中の珍味"	

STRINGS.NAMES.MYTH_FOOD_HYMZ = "「花月满盏」"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_HYMZ = "それを食べるのは忍びません。"	

STRINGS.NAMES.MYTH_BANANA_LEAF = "芭蕉の葉"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_BANANA_LEAF = "この芭蕉の葉はデカい！"

STRINGS.NAMES.MYTH_BUNDLE = "芭蕉の葉の包み"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_BUNDLE = "芭蕉の葉の包み"	

STRINGS.NAMES.MYTH_BUNDLEWRAP = "芭蕉の葉の包装"
STRINGS.RECIPE_DESC.MYTH_BUNDLEWRAP = "あなたの荷物を包装できます！" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_BUNDLEWRAP = "中に何かが入っています。"

STRINGS.NAMES.MYTH_BANANA_TREE = "芭蕉の木"
STRINGS.RECIPE_DESC.MYTH_BANANA_TREE = "魔法はあなたに芭蕉の木を植えることができます。" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_BANANA_TREE = "これは地下のよりずっときれいです。"

STRINGS.NAMES.MYTH_ZONGZI1 = "甘いちまき"
STRINGS.RECIPE_DESC.MYTH_ZONGZI1 = "甘いちまきを作る" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_ZONGZI1 = "白いもち米に赤いナツメを加えて、めのうを入れたように見えます。"

STRINGS.NAMES.MYTH_ZONGZI2 = "塩味のちまき"
STRINGS.RECIPE_DESC.MYTH_ZONGZI2 = "塩味のちまきを作る" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_ZONGZI2 = "塩辛い肉，モチモチとした香りがします。"

STRINGS.NAMES.MYTH_ZONGZI_ITEM1 = "甘いちまき"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_ZONGZI_ITEM1 = "甘くて美味しいです。"

STRINGS.NAMES.MYTH_ZONGZI_ITEM2 = "塩味のちまき" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_ZONGZI_ITEM2 = "香りが強い、すぐ食べられます。"

STRINGS.NAMES.BANANAFAN_BIG = "「芭蕉宝扇」"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BANANAFAN_BIG = "真珠光沢は詳しく徹底している"
 
STRINGS.NAMES.MYTH_FLYSKILL = "白雲"
STRINGS.RECIPE_DESC.MYTH_FLYSKILL = "「华夏」からの古い秘術。" 

STRINGS.NAMES.MYTH_FLYSKILL_MK = "「筋斗云」"
STRINGS.RECIPE_DESC.MYTH_FLYSKILL_MK = "もんどり打てば十万八千里の外に行ける。" 

STRINGS.NAMES.MYTH_FLYSKILL_NZ = "「风火轮」"
STRINGS.RECIPE_DESC.MYTH_FLYSKILL_NZ = "またたく間に千里を行ける，またたく間に九州に至れる。" 

STRINGS.NAMES.MYTH_FLYSKILL_WB = "「阴风」"
STRINGS.RECIPE_DESC.MYTH_FLYSKILL_WB = "陰風が四方に吹いたら，跡を捜せない。" 

STRINGS.NAMES.MYTH_FLYSKILL_PG = "「棉花云」"
STRINGS.RECIPE_DESC.MYTH_FLYSKILL_PG = "ふわふわ，穏やかです。" 

STRINGS.NAMES.MYTH_FLYSKILL_YJ = "「雷云」"
STRINGS.RECIPE_DESC.MYTH_FLYSKILL_YJ = "雷のように四方を震動させて、稲妻のように速く飛びます。" 

STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.FUR_COOK ={
	INUSE = 'それは使われています',
}

STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.NZ_PLANT={
	HASONE = "ここに植えられません",
}

STRINGS.NAMES.HEAT_RESISTANT_PILL = "辟暑丹"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEAT_RESISTANT_PILL = "それがあって、私は炎と悪辣な太陽を感じられなくなりました！"

STRINGS.NAMES.COLD_RESISTANT_PILL = "辟寒丹"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.COLD_RESISTANT_PILL = "私は寒さを恐れない、雨にもぬれないです！"

STRINGS.NAMES.DUST_RESISTANT_PILL = "辟尘丹"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DUST_RESISTANT_PILL = "ほこりの邪魔はもう心配しないだ。！"

STRINGS.NAMES.FLY_PILL = "「腾云丹」"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FLY_PILL = "本当？私も飛べますか？" 

STRINGS.NAMES.BLOODTHIRSTY_PILL = "「嗜血丹」" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BLOODTHIRSTY_PILL = "こうもりのように狂おう！" 

STRINGS.NAMES.CONDENSED_PILL = "「凝味丹」" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CONDENSED_PILL = "食べたら集中させなければならない！" 

STRINGS.NAMES.PEACH = "「蟠桃」" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACH = "これは普通の桃じゃないよ！" 
STRINGS.NAMES.PEACH_COOKED = "焼き「蟠桃」" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACH_COOKED = "焼いたら普通になります。" 
STRINGS.NAMES.PEACH_BANQUET = "「蟠桃大会」" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACH_BANQUET = "この桃は簡単なフルーツ盛り合わせに魔力を与えたようです！" 
STRINGS.NAMES.PEACH_WINE = "「蟠桃素酒」" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACH_WINE = "この果物酒は普通ではないよ！" 

STRINGS.NAMES.MK_BATTLE_FLAG = "戦旗"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MK_BATTLE_FLAG = "これは1枚の戦旗で，字を書くことができる！" 
STRINGS.NAMES.MK_BATTLE_FLAG_ITEM = "戦旗"
STRINGS.RECIPE_DESC.MK_BATTLE_FLAG_ITEM = "戦闘のために旗を立たおう！"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MK_BATTLE_FLAG_ITEM = "これは1枚の戦旗で，字を書くことができる！"

STRINGS.NAMES.HONEY_PIE = "「蜂蜜素饼」"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HONEY_PIE = "粗い食べ物に蜜を少し入れました。" 

STRINGS.NAMES.VEGETARIAN_FOOD = "「素斋」"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.VEGETARIAN_FOOD = "すごくさっぱりした味だね！" 

STRINGS.NAMES.CASSOCK = "「袈裟」"
STRINGS.RECIPE_DESC.CASSOCK = "着いたら俗塵から遠ざかる"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CASSOCK = "俗塵から遠ざかる。" 

STRINGS.NAMES.KAM_LAN_CASSOCK = "「锦襕袈裟」"
STRINGS.RECIPE_DESC.KAM_LAN_CASSOCK = "着いたら魑魅魍魎から遠ざかる。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KAM_LAN_CASSOCK = "この袈裟はとても光る！"

STRINGS.NAMES.GOLDEN_HAT_MK = "「凤翅紫金冠」"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOLDEN_HAT_MK = "なんて威風堂々とした頭冠だな！"

STRINGS.NAMES.GOLDEN_ARMOR_MK = "「锁子黄金甲」"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOLDEN_ARMOR_MK = "無敵の鎧！"

STRINGS.NAMES.XZHAT_MK = "「行者帽」"
STRINGS.RECIPE_DESC.XZHAT_MK = "西へ行く旅人になる"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.XZHAT_MK = "とても快適な帽子!"

STRINGS.NAMES.BIGPEACH = "「大蟠桃」"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BIGPEACH = "この桃は他のより大きい！"

STRINGS.NAMES.MK_HUALING = "「花翎」"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MK_HUALING = "とても綺麗な「长翎」です！"

STRINGS.NAMES.MK_HUOYUAN = "「火猿石心」"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MK_HUOYUAN = "手をやけどる石心！"

STRINGS.NAMES.MK_LONGPI = "「龙皮绸缎」"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MK_LONGPI = "灼熱の絹織物！"

STRINGS.NAMES.LOTUS_FLOWER = "蓮の花"
STRINGS.RECIPE_DESC.LOTUS_FLOWER = "肉を切って母に返し，骨を削って父に返す。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LOTUS_FLOWER = "A lovely science flower."

STRINGS.NAMES.LOTUS_FLOWER_COOKED ="焼き蓮の実"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LOTUS_FLOWER_COOKED = "旨い。"

STRINGS.NAMES.GOURD = "ヒョウタン"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOURD = "いい野菜だな。"

STRINGS.NAMES.GOURD_COOKED = "焼きヒョウタン"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOURD_COOKED = "香りが増しました。"

STRINGS.NAMES.GOURD_SEEDS = "ヒョウタンの種"

STRINGS.NAMES.GOURD_SOUP = "ヒョウタンのスープ"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOURD_SOUP = "美味しい。"

STRINGS.NAMES.GOURD_OMELET = "「葫芦鸡蛋饼」"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOURD_OMELET = "美味しいおかずです。"

STRINGS.NAMES.PILL_BOTTLE_GOURD = "「丹药葫芦」"
STRINGS.RECIPE_DESC.PILL_BOTTLE_GOURD = "丹薬を瓢箪に入れる。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PILL_BOTTLE_GOURD = "丹薬を盛るに用いる。"

STRINGS.NAMES.WINE_BOTTLE_GOURD = "「酒葫芦」"
STRINGS.RECIPE_DESC.WINE_BOTTLE_GOURD = "いい酒、いい瓢箪だ！"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WINE_BOTTLE_GOURD = "お酒の香りがします。"

STRINGS.NAMES.THORNS_PILL = "「荆棘丹」"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.THORNS_PILL = "いばら、私を守れ！"

STRINGS.NAMES.ARMOR_PILL = "「壮骨丹」"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMOR_PILL = "体を鍛える。"

STRINGS.NAMES.DETOXIC_PILL = "「化毒丹」"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DETOXIC_PILL = "世の中の百毒を解くのに用いる。"

STRINGS.NAMES.LAOZI_SP = "「急急如律令」"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAOZI_SP = "「太上老君，急急如律令」！"

STRINGS.NAMES.LAOZI = "「太上老君」"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAOZI = "この方はは東方の神様ですよ！"

STRINGS.NAMES.BANANAFAN = "「芭蕉扇」"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BANANAFAN = "この扇子は普通ではない。"

STRINGS.NAMES.ALCHMY_FUR = "「八卦炉」" 
STRINGS.RECIPE_DESC.ALCHMY_FUR = "このストーブだけが「三昧真火」をコントロールできる。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ALCHMY_FUR =  {
	EMPTY = "東方神話の伝説の中の薬を練るストーブか？",
	GENERIC = "その炎の暑さは想像できません！",
	DONE = "この丹薬はこのストーブの中で何を経験しましたか？！",
}

STRINGS.MKRECIPE = "神話"

STRINGS.LAOZI =
{
    A = "冗談ですか...",
    B = "無礼!",
    C = "こんな無礼なことをするとは!",
    D = "貪欲を止めろ!",
    E = "妖精は寸進規を得てはやめとけ。",
    F = "函谷関から運んできてくれたので、大切に育てを望んでいます。",
}

STRINGS.NAMES.PEACHSPROUT_MYTH = "「蟠桃」の苗木"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACHSPROUT_MYTH = "早く成長してほしい！"

STRINGS.NAMES.PEACHSAPLING_MYTH = "「蟠桃」の苗木"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACHSAPLING_MYTH = "早く成長してほしい！"

STRINGS.NAMES.PEACHSTUMP_MYTH = "「蟠桃」の木の根"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACHSTUMP_MYTH = "切るのはもったいないです。"

STRINGS.NAMES.PEACHTREEBURNT_MYTH = "焼けこげた「蟠桃」の木"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACHTREEBURNT_MYTH = "完全に壊れた。"

STRINGS.NAMES.PEACHTREE_MYTH = "「蟠桃」の木"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACHTREE_MYTH = {
	GENERIC = "伝説の中でこの神の木は3千年に一回だけ花をつけて、また3千年はやっと一回の果実を結びます！",
    BURNING = "焼くな！こんなの珍しい木を焼くな！",
    BLOOM = "この情景は，まるですでに3千年を待っているかのようだ。",
    FRUIT = "生生世世の待つこと、この今のためだ。"
}

STRINGS.CHARACTERS.WENDY.DESCRIBE.PEACHTREE_MYTH = {
	GENERIC = "桃の巣に桃の花庵があります。桃花庵の下に桃の花仙人がいます。",
    BURNING = "世の中の人たちは私を狂人と笑い、私は彼らがあまりにも浅はかだと笑いました。",
    BLOOM = "桃の花の仙人は桃の木を植えて、また桃の花の枝を折って酒のお金に換える。",
    FRUIT = "生酔いの状態で一日また一日を過ごし、花が咲いて散る中で一年また一年を過ごします。"
}

STRINGS.NAMES.FANGCUNHILL = "「灵台方寸山」"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FANGCUNHILL = "ドアはぴったり閉じている。"

STRINGS.NAMES.BOOK_MYTH = "「无字天书」"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_MYTH = "妙意慧法は、全ては無言の中にある。"
STRINGS.NAMES.BOOK_MYTH_YJ = "「无字天书」"
STRINGS.RECIPE_DESC.BOOK_MYTH_YJ = "妙意慧法は、全ては無言の中にある。"

STRINGS.NAMES.PURPLE_GOURD = "「紫金葫芦」"
STRINGS.NAMES.PURPLE_GOURD_MALE = "「紫金葫芦·雄」"
STRINGS.NAMES.PURPLE_GOURD_FEMALE = "「紫金葫芦·雌」"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PURPLE_GOURD = "宝の気が満ちあふれている。"

GLOBAL.Myth_AddCachedStr(function()
    --蟠桃树芽
    STRINGS.CHARACTERS.MONKEY_KING.DESCRIBE.PEACHSPROUT_MYTH = "俺はこれにちゃんとお世話にします。"
    STRINGS.CHARACTERS.NEZA.DESCRIBE.PEACHSPROUT_MYTH = "この小さい木がやっと芽を出したとは意外にも仙気がある。"
    STRINGS.CHARACTERS.WHITE_BONE.DESCRIBE.PEACHSPROUT_MYTH = "無用な物。"
    STRINGS.CHARACTERS.PIGSY.DESCRIBE.PEACHSPROUT_MYTH = "どれぐらい待てば結果が出ますか？"

    --蟠桃树苗
    STRINGS.CHARACTERS.MONKEY_KING.DESCRIBE.PEACHSAPLING_MYTH = "早く長くして、新鮮なものを食べてみることを待ってるね。"
    STRINGS.CHARACTERS.NEZA.DESCRIBE.PEACHSAPLING_MYTH = "木は春には花が咲き、夏にはもっと強い活力が湧きます。"
    STRINGS.CHARACTERS.WHITE_BONE.DESCRIBE.PEACHSAPLING_MYTH = "仙木の花が実を結び、それを壊してしまうのはいいじゃないか。。"
    STRINGS.CHARACTERS.PIGSY.DESCRIBE.PEACHSAPLING_MYTH = "成長が遅すぎて、おしっこをして肥料をやったらどう？"

    --蟠桃树桩
    STRINGS.CHARACTERS.MONKEY_KING.DESCRIBE.PEACHSTUMP_MYTH = "残念です。"
    STRINGS.CHARACTERS.NEZA.DESCRIBE.PEACHSTUMP_MYTH = "どこの妖精はやったか、王母に知れたら、絶対に怒るだろう！"
    STRINGS.CHARACTERS.WHITE_BONE.DESCRIBE.PEACHSTUMP_MYTH = "君に草を刈るには根を抜くべきであるを勧め，後患を残さないようにする。"
    STRINGS.CHARACTERS.PIGSY.DESCRIBE.PEACHSTUMP_MYTH = "これは俺がやったのではない、兄弟子は俺を信じて。"

    --烧焦的蟠桃树
    STRINGS.CHARACTERS.MONKEY_KING.DESCRIBE.PEACHTREEBURNT_MYTH = "さてさて、「花果山」に返して！"
    STRINGS.CHARACTERS.NEZA.DESCRIBE.PEACHTREEBURNT_MYTH = "仙根ですが、木です。"
    STRINGS.CHARACTERS.WHITE_BONE.DESCRIBE.PEACHTREEBURNT_MYTH = "一度も持ってはいないから、いらなくてもいいです。"
    STRINGS.CHARACTERS.PIGSY.DESCRIBE.PEACHTREEBURNT_MYTH = "フン、仙の木も火に弱いですか。"

    --蟠桃树
    STRINGS.CHARACTERS.MONKEY_KING.DESCRIBE.PEACHTREE_MYTH = {
        GENERIC = "土地神はこの仙樹は三千年で花が咲き、また三千年で実がなると言っています。",
        BURNING = "ちぇっ！放火は好漢とは言えない！",
        BLOOM = "は、お尻と同じぐらい赤いです。",
        FRUIT = "この仙桃は俺にちゃんと味をみせましょう。"
    }
    STRINGS.CHARACTERS.NEZA.DESCRIBE.PEACHTREE_MYTH = {
        GENERIC = "瑶池の仙種は，どうして俗塵に落ちるか？",
        BURNING = "火徳真君はどうしてここに災いをもたらすことができようか？",
        BLOOM = "丹炉を動き始めようとしている、仙桃が赤くなり始めている。",
        FRUIT = "蟠桃の宴ではいくつか食べたことがありますが、今回は私を楽しませろう。"
    }
    STRINGS.CHARACTERS.WHITE_BONE.DESCRIBE.PEACHTREE_MYTH = {
        GENERIC = "この木は瑶池に生まれたので、妖怪達は聞ったことだけです。今日は私が会わせてくれた。",
        BURNING = "とても好きです！",
        BLOOM = "ちょうど私の紅おしろいを補充します。",
        FRUIT = "この木を壊したら、きっとあのクソ猿を怒らせます！"
    }
    STRINGS.CHARACTERS.PIGSY.DESCRIBE.PEACHTREE_MYTH = {
        GENERIC = "この木は僕と同じで、俗塵に落ちて志を得ません。",
        BURNING = "やれやれ、私はそんな愚かことをしていません！",
        BLOOM = "下で寝て、目が覚めたら桃が食べられるかもしれません。",
        FRUIT = "えへへ、俺は少し多く食べて、あの猿が知ることはありえない。"
    }

    --灵台方寸山
    STRINGS.CHARACTERS.MONKEY_KING.DESCRIBE.FANGCUNHILL = "七年の間に、ただ一つの長生の道を求めます。"
    STRINGS.CHARACTERS.NEZA.DESCRIBE.FANGCUNHILL = "どうな偉い人がここに住んでいますか？"
    STRINGS.CHARACTERS.WHITE_BONE.DESCRIBE.FANGCUNHILL = "仙府は茫漠としており，機運はまだ到来していない。"
    STRINGS.CHARACTERS.PIGSY.DESCRIBE.FANGCUNHILL = "あ...あの桃は美味しそう..."
    STRINGS.CHARACTERS.YANGJIAN.DESCRIBE.FANGCUNHILL = "ここは「桃山」よりどうですか？"

    --无字天书
    STRINGS.CHARACTERS.MONKEY_KING.DESCRIBE.BOOK_MYTH = "何のがらくたのようなものだ、嫌いだ、持って行こう！"
    STRINGS.CHARACTERS.NEZA.DESCRIBE.BOOK_MYTH = "「无字天书」は「姜子牙师叔」のところにあるのではないですか？"
    STRINGS.CHARACTERS.WHITE_BONE.DESCRIBE.BOOK_MYTH = "「道」は説明できないものです。。"
    STRINGS.CHARACTERS.PIGSY.DESCRIBE.BOOK_MYTH = "字があろうとなかろうと、俺は知りません。。"
    STRINGS.CHARACTERS.YANGJIAN.DESCRIBE.BOOK_MYTH = "この本に載っているものは，僕の法眼から逃れられない。"

    --紫金葫芦
    STRINGS.CHARACTERS.MONKEY_KING.DESCRIBE.PURPLE_GOURD = "ヒヒ，このヒョウタンは雄か雌か当ててみて。"
    STRINGS.CHARACTERS.NEZA.DESCRIBE.PURPLE_GOURD = "これは師伯祖の丹薬を入れるための宝瓢。"
    STRINGS.CHARACTERS.WHITE_BONE.DESCRIBE.PURPLE_GOURD = "一粒の仙丹を手に入れることができれば、数千年の苦労を省くことができます。"
    STRINGS.CHARACTERS.PIGSY.DESCRIBE.PURPLE_GOURD = "この中に何の美味しい物があるか？俺を見せて。。"
    STRINGS.CHARACTERS.YANGJIAN.DESCRIBE.PURPLE_GOURD = "掌の中のヒョウタンだけけど、実は乾坤浩大である。"
end)


--以前的内容集成
STRINGS.FUR_HARVEST = "取る"
STRINGS.FUR_COOK = "製錬する"
STRINGS.MYTH_USE_INVENTORY = "使う"
STRINGS.USE_GOURD = "飲む"
STRINGS.RHI_PLACEITEM = '貢ぎ物を置く'
STRINGS.MYTH_RED_GIVE = "ちょうちんをつる"
STRINGS.MYTH_RED_TACK = "ちょうちんを取る"
STRINGS.MKFLYLAND = "着陸する"
STRINGS.NAMES.MYTH_RHINO_DESK = '老朽化した供え物台'
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_RHINO_DESK = "私は敬虔に献上品を捧げるべきですか？"

------------------------月宫系列
STRINGS.MKCERECIPE = "月宮の贈り物"


----嫦娥说的话
STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.MYTH_ENTER_HOUSE = { 
	BANNED = "人の機嫌を損ねたばかりだから、数日後にまた来ましょう。",
	FLY = "飛行中はこのようにしてはいけません!",
	NOTIME = "このようにはできません!", --白天不可以进
}

--[[
STRINGS.CHARACTERS.MONKEY_KING.ACTIONFAIL.MYTH_ENTER_HOUSE ={
	BANNED = "何日間待ってからまた来ましょう。",
	FLY = "飛行中はこのようにしてはいけません!",
	NOTIME = "このようにはできません!", --白天不可以进
}
STRINGS.CHARACTERS.NEZA.ACTIONFAIL.MYTH_ENTER_HOUSE.BANNED = {
	BANNED = "「嫦娥」お姉さんの怒りがおさまったらまた行きましょう。",
	FLY = "飛行中はこのようにしてはいけません!",
	NOTIME = "このようにはできません!", --白天不可以进
}
STRINGS.CHARACTERS.YANGJIAN.ACTIONFAIL.MYTH_ENTER_HOUSE.BANNED = {
	BANNED = "仙子は怒らないで、「杨戬」は後日また来ます。",
	FLY = "飛行中はこのようにしてはいけません!",
	NOTIME = "このようにはできません!", --白天不可以进
}
STRINGS.CHARACTERS.PIGSY.ACTIONFAIL.MYTH_ENTER_HOUSE.BANNED = {
	BANNED = "俺のこのバカな頭は，本当に何をやってもだめだ。",
	FLY = "飛行中はこのようにしてはいけません!",
	NOTIME = "このようにはできません!", --白天不可以进
}
STRINGS.CHARACTERS.WHITE_BONE.ACTIONFAIL.MYTH_ENTER_HOUSE.BANNED = {
	BANNED = "白骨は失礼でしたが、仙子は私に大目に見てください。",
	FLY = "飛行中はこのようにしてはいけません!",
	NOTIME = "このようにはできません!", --白天不可以进
}
]]

STRINGS.MYTHGHG_ISNIGHT = { --被赶出
	MONKEY_KING = "ヤバイ！時間を忘れた！",
	NEZA = "ヤバイ、「哪吒」は「嫦娥」姉さんを怒らせたようだ。",
	WHITE_BONE = "天下の大きさはどこに私の居場所がある？",
	PIGSY = "まさか、俺は今日また酒に心を奪われたか？",
	YANGJIAN = "今度はまた仙子に謝りましょう。",
	GENERIC = "こんな無礼なことをするべきではないなのに。",
}

STRINGS.MYTHCEHAOGANDU = { --好感度 20 50 100 150
	[2] = {
		MONKEY_KING = "「大圣」、ご丁寧に。",
		NEZA = "「三太子」、ご丁寧に。",
		WHITE_BONE = "好意はありがたく受け取った。",
		PIGSY = "元帥、ご丁寧に。",
		YANGJIAN = "「真君」、ご丁寧に。",
		MYTH_YUTU = "プレゼントをありがとうね。",	
		GENERIC = "本当にご丁寧に。",	
	},
	[4] = {
		MONKEY_KING = "プレゼントをありがとうございます。",
		NEZA = "プレゼントをありがとうございます。",
		WHITE_BONE = "そうする必要はない……",
		PIGSY = "「天蓬」は用事があって、私にお願いのために来たのか？",
		YANGJIAN = "「真君」さんは何か私に依頼がありますか？",
		MYTH_YUTU = "あなたはいつもこれらの小さなものを使って笑わせてくれてね。",	
		GENERIC = "プレゼントをありがとう。",	
	},
	[6] = {
		MONKEY_KING = "「大圣」、そうすれば、ちょっと恥ずかしくなった。",
		NEZA = "時間があれば多く来て遊ぶよ。",
		WHITE_BONE = "もし災いがあれば、私のところに来てもいい......",
		PIGSY = "昔のことは煙のようだが，元帥はこれ以上心に留めることは必要がない。",
		YANGJIAN = "「真君」は伝説のようじゃないですね。",
		MYTH_YUTU = "まあまあ。今日の分の薬草は免除しますわ。",	
		GENERIC = "そうする必要はないだけど…ありがとう。",	
	},
	[7] = {
		MONKEY_KING = "いくらかの斎餅は，西行のために「大圣」に贈る。",
		NEZA = "「哪吒」の心は、蓮の香りがあるね。",
		WHITE_BONE = "日ごとに善事を行い，自分を静思すれば災いなし。",
		PIGSY = "元帥が早く正果になれる、本位に戻れてほしい。",
		YANGJIAN = "需要があれば、嫦娥はきっと全力を尽くして援助します。",
		MYTH_YUTU = "外で何かあったら慌てないで、きっとあなたを守りますから。",	
		GENERIC = "あなたと私の間の縁は，これらにぜんぜんとどまらない。",	
	},
}

STRINGS.MYTHGHG_NOCURRENTITEM = {  --物品不对
	MONKEY_KING = "「大圣」、冗談を言わないで。",
	NEZA = "この品物はやはり三太子が残してね。",
	WHITE_BONE = "あなたを動かす勇気がないと思うな。",
	PIGSY = "元帥自重。",
	YANGJIAN = "「真君」は私をからかうために来たのか？",
	MYTH_YUTU = "ハハ、気持ちは受け取った。",	
	GENERIC = "私は街角の乞食じゃない！",
}

--问候
STRINGS.MYTHGHG_RCWH = {
	MONKEY_KING ={"「大圣」はどうしてあなたの師匠を守って西へお経を取りに行きませんか？"," 昔の「大圣」の「大闹天宫」は本当に素晴らしい伝説だよね。","こちらのお菓子はあの瑶池蟠桃と比べないよ。"},
	NEZA ={"この月餅が好きなら、持って帰りましょう。","  太乙はあなたを可愛がっていたね、あなたにこんなの様々な法宝を与えてくれる。","ゆっくり食べて、お茶を飲んで、脂っこいを和らいで。"},
	WHITE_BONE ={"善悪は報いがあり、時機はまだ来ない。","多くの善行を望み，功徳をもって諸罪を洗い落とす。","大道に情があるから、あなたに一縷の望みを与えないとは限らない。"},
	PIGSY ={"元帥はただ凡人へけなされただけで、どうして間違って豚の胎に投げられました？","濁った酒は事を誤用するから、決して多く飲んではいけない。"," ご遠慮しないで、お菓子を食べてみてください。"},
	YANGJIAN ={"「真君」はここに来て何か心配事がありますか？","粗悪なお茶ですが、心を楽にしてほしい。","「哮天」はどうしてこんなに丸くなったの、フフ。"},
	MYTH_YUTU ={"今日は外で何を見ましたか？","今日の薬ができました？怠けてはいけませんよ。","若遊びが終わったら、私について天宮に帰りましょう。"},
	GENERIC ={"このお茶を食べてみて、このお茶はあなた達のとはどこに違うがあるか？"," お腹が空きましたら、月餅をいくつか食べてみてもいいよ。","ここで出会えたのは、私たちの縁です。"},
}

--见面
STRINGS.MYTHGHG_JMWH = {
	MONKEY_KING ="「大圣」が至ることは分からないから、失礼いたしまして、お茶を一杯いかがでしょうか？",
	NEZA ="「哪吒」太子さま、お父さんはいかがでしょうか？",
	WHITE_BONE ="この広寒宮に来ても三災六禍を避けられない。まあまあ、座ってお茶を飲みましょう。·",
	PIGSY ="「天蓬元帅」、お久しぶり、最近はどうでしょうか？",
	YANGJIAN ="「真君」は司法と水神の職務を担当している、公務が忙しいのに、まだここに来る暇がある？",
	MYTH_YUTU ="この遊びほうけている子！今度はまたどこに遊びに行いた？",
	GENERIC ="朋遠方より来たる有り、また楽しからずや。",
}

--嫦娥
STRINGS.MKCETALK_TOLEAVE = "もう遅いですから、皆さん、そろそろ帰る時間だね。" --时间到了
STRINGS.MKCETALK_TOMANYPEOLE = "広寒宮は久しぶりにこんなににぎやかにならなかった。"  --人多


STRINGS.SIT_ON_MYTH = "座る" --坐在垫子上

--玉兔重做tip：玉兔给予嫦娥道具触发的台词
STRINGS.MKCETALK_YUTU = {
    POWDER_M_HYPNOTICHERB = { --草参药粉
        GENERIC = "ハーブの中でも最高級品で、挽くときに注意が必要です。", --教玉兔时
        LEARNED = "これほど多くの希少なハーブはどこから来るのでしょう。", --玉兔已经学过了
        WRONGSTATE = nil, --没有达到特殊条件
    },
    POWDER_M_LIFEELIXIR = { --犀茸药粉
        GENERIC = "なぜ、こんなものがあるの？ 誰も怒らせてないだろう？",
        LEARNED = "もう、やめろ。",
        WRONGSTATE = nil,
    },
    POWDER_M_CHARGED = { --惊厥药粉
        GENERIC = "研磨や袋詰めの時は感電しやすいので、注意が必要です。",
        LEARNED = "あら、教えたのに忘れてるの？",
        WRONGSTATE = nil,
    },
    POWDER_M_IMPROVEHEALTH = { --活血药粉
        GENERIC = "これだけではベタなので、薬味で補う必要があるそうです。",
        LEARNED = "甘い香りが忘れないわ。",
        WRONGSTATE = nil,
    },
    POWDER_M_COLDEYE = { --寒眸药粉
        GENERIC = "妖邪から取られ、毒には毒で対抗するために使われることが多いです。",
        LEARNED = "寒気がするわけだ、取って行け。",
        WRONGSTATE = nil,
    },
    POWDER_M_BECOMESTAR = { --夜明药粉
        GENERIC = "それをつぶして香りのよいパウダーと混ぜ、肌に塗ると、輝くようなツヤが出ます。",
        LEARNED = "こちらに不足はない、自分で使っていいよ。",
        WRONGSTATE = nil,
    },
    POWDER_M_TAKEITEASY = { --排郁药粉
        GENERIC = "飽きたら、もっと外に出て、遊んでほしいですね。",
        LEARNED = "ありがとう。あなたがいてくれて、とても楽しかった。",
        WRONGSTATE = nil,
    },

    SONG_M_WORKUP = { --《田中乐》
        GENERIC = "蜂の群れは勤勉に働いているので,それらを学ぶはずです。",
        LEARNED = "遊んでは止めて。今日の薬粉はできましたか。",
        WRONGSTATE = nil,
    },
    SONG_M_INSOMNIA = { --《春光曲》
        GENERIC = "思念の味は耐えにくい、寝返りを打って、夜眠れない。",
        LEARNED = "あまり考えないで、休んで行こう。",
        WRONGSTATE = nil,
    },
    SONG_M_FIREIMMUNE = { --《浴火奏》
        GENERIC = "鳳凰のごとく火で生まれ変わる。",
        LEARNED = "もういらないから、自分で持っていっていいよ。",
        WRONGSTATE = nil,
    },
    SONG_M_ICEIMMUNE = { --《寒风调》
        GENERIC = "寒風吹雪、降霜九層。",
        LEARNED = "この暖かい心の温度、いつも私に突然この蟾宮の寂しさを思い出させます。",
        WRONGSTATE = "蟾宮にはこの普通の石が欠けない。",
    },
    SONG_M_ICESHIELD = { --《梦飞霜》
        GENERIC = "珍しい魚ですね。氷鱗氷心。私は飼ってみたい。",
        LEARNED = "自分で持っていいよ。私はもうあったから。",
        WRONGSTATE = nil,
    },

    SONG_M_NOCURE = { --《怨缠身》
        GENERIC = "人を恨んで、自分を恨んで、これもあれも恨んで、当初を後悔します。",
        LEARNED = "蟾宮には怪物が常駐してはいけません,早く外に捨てなさい！",
        WRONGSTATE = nil,
    },
    SONG_M_WEAKATTACK = { --《春风化雨》
        GENERIC = "哀れみの心で万事万物を待ってこそ、春風化雨、百里屠蘇。",
        LEARNED = "もし誰かが何度も間違っていたら、慈悲を与えないで。",
        WRONGSTATE = nil,
    },
    SONG_M_WEAKDEFENSE = { --《霸王卸甲》
        GENERIC = "彼が甲を脱いで畑に帰るのを待ち望んでいたが,今では私はこのような境地に落ちた。",
        LEARNED = "今あなたは私の唯一の頼りで、私はもう誰を待ち望む必要はありません。",
        WRONGSTATE = nil,
    },
    SONG_M_NOLOVE = { --《流水无情》
        GENERIC = "昔のあの人の耳元の話は,もう潮の音と東に流れている。",
        LEARNED = "行ってください、ちょっと一人でいたい。",
        WRONGSTATE = nil,
    },
    SONG_M_SWEETDREAM = { --《夜阑谣》
        GENERIC = "いい、いつか夜が更けて眠れなければ、寂しさを吹き飛ばすことができます。",
        LEARNED = "宮中には普段あなたと私二人しかいません。これ以上が何の役にも立たない。",
        WRONGSTATE = nil,
    },
}

--玉兔重做tip：buff名字全部挪到这里了
STRINGS.NAMES.BUFF_M_LOCO_UP = "疾走"
STRINGS.NAMES.BUFF_M_BLOODSUCK = "嗜血"
STRINGS.NAMES.BUFF_M_ATK_UP = "強健"
STRINGS.NAMES.BUFF_M_DEF_UP = "堅固"
STRINGS.NAMES.BUFF_M_UNDEAD = "不死"
STRINGS.NAMES.BUFF_M_ATK_ICE = "凝霜"
STRINGS.NAMES.BUFF_M_HUNGER_STAY = "飽腹"
STRINGS.NAMES.BUFF_M_SANITY_STAY = "凝神"
STRINGS.NAMES.BUFF_M_HUNGER_STRONG = "饕餮"
STRINGS.NAMES.BUFF_M_STRENGTH_UP = "移山"
STRINGS.NAMES.BUFF_M_IMMUNE_FIRE = "辟火"
STRINGS.NAMES.BUFF_M_IMMUNE_WATER = "辟水"
STRINGS.NAMES.BUFF_M_WARM = "辟寒"
STRINGS.NAMES.BUFF_M_COOL = "辟暑"
STRINGS.NAMES.BUFF_M_DUST = "辟塵"
STRINGS.NAMES.BUFF_M_DEATHHEART = "黒心"
STRINGS.NAMES.BUFF_M_ICESHIELD = "霜甲"
STRINGS.NAMES.BUFF_M_IMMUNE_ICE = "抗凍"
STRINGS.NAMES.BUFF_M_INSOMNIA = "難眠"
STRINGS.NAMES.BUFF_M_PROMOTE_HEALTH = "栄養"
STRINGS.NAMES.BUFF_M_PROMOTE_HUNGER = "胃動"
STRINGS.NAMES.BUFF_M_PROMOTE_SANITY = "美味"
STRINGS.NAMES.BUFF_M_STENCH = "芬芳"
STRINGS.NAMES.BUFF_M_THORNS = "荆棘"
STRINGS.NAMES.BUFF_M_BEEFALO = "牛息"
STRINGS.NAMES.BUFF_M_FU = "福"
STRINGS.NAMES.BUFF_M_LU = "禄"
STRINGS.NAMES.BUFF_M_SHOU = "寿"
STRINGS.NAMES.BUFF_M_INFANT = "长生不老"

---------------------------------------------------------------------

STRINGS.NAMES.MYTH_GHG = "広寒宮" --广寒宫名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_GHG = "明月の精魄"--广寒宫检查

STRINGS.NAMES.MYTH_CHANG_E = "「嫦娥」" --嫦娥名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_CHANG_E = "凌波仙子は偶然にも世の中にやって来た。"--嫦娥检查

STRINGS.NAMES.MYTH_INTERIORS_GHG_LU = "香炉" --广寒宫的炉子
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GHG_LU = "香炉"--广寒宫的炉子检查
STRINGS.NAMES.MYTH_INTERIORS_GHG_LIGHT = "宮灯" --广寒宫的灯
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GHG_LIGHT = "宮灯"--广寒宫的灯检查
STRINGS.NAMES.MYTH_INTERIORS_GHG_FLOWER = "梅" --广寒宫的月花
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GHG_FLOWER = "梅"--广寒宫的月花检查
STRINGS.NAMES.MYTH_INTERIORS_GHG_HE_RIGHT = "鶴" --广寒宫的仙鹤
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GHG_HE_RIGHT = "鶴"--广寒宫的仙鹤检查
STRINGS.NAMES.MYTH_INTERIORS_GHG_HE_LEFT = "鶴" --广寒宫的仙鹤
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GHG_HE_LEFT = "鶴"--广寒宫的仙鹤检查

STRINGS.NAMES.MYTH_REDLANTERN = "提灯" --灯笼名字
STRINGS.RECIPE_DESC.MYTH_REDLANTERN = "古風で質朴な中国式灯籠一つ。"--灯笼配方描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_REDLANTERN = "暗闇の中の優しさ"--灯笼检查

STRINGS.NAMES.MYTH_REDLANTERN_GROUND = "ちょうちん台" --灯笼架子名字
STRINGS.RECIPE_DESC.MYTH_REDLANTERN_GROUND = "あなたの提灯を置きます。"--灯笼架子配方描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_REDLANTERN_GROUND = "便利だね。"--灯笼架子检查

STRINGS.NAMES.MYTH_RUYI = "玉の如意" --如意名字
STRINGS.RECIPE_DESC.MYTH_RUYI = "如意で軽く打つと，桃の実が自然に落ちる。"--如意配方描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_RUYI = "如意、如意、わが意に沿う。"--如意检查

STRINGS.NAMES.MYTH_FENCE = "屏風" --屏风名字
STRINGS.RECIPE_DESC.MYTH_FENCE = "中国の伝統的な建て物"--屏风配方描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FENCE = "風を遮る。"--屏风检查

STRINGS.NAMES.MYTH_BBN = "「莹月百宝囊」" --百宝囊名字
STRINGS.RECIPE_DESC.MYTH_BBN = "まだ月華を注ぎ込むことが必要である。"--百宝囊配方描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_BBN = "適時にエネルギーを補充することが忘れないで。"--百宝囊检查

STRINGS.NAMES.MYTH_YYLP = "「莹月轮盘」" --莹月轮盘名字
STRINGS.RECIPE_DESC.MYTH_YYLP = "とても役に立ちます。"--莹月轮盘配方描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_YYLP = "天上の明月がこの世に落ちたように。"--莹月轮盘检查

STRINGS.NAMES.MYTH_MOONCAKE_ICE = "「冰皮月饼」" --冰月饼名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_MOONCAKE_ICE = "頭をはっきりさせる。"--冰月饼检查

STRINGS.NAMES.MYTH_MOONCAKE_NUTS = "「五仁月饼」" --五仁月饼名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_MOONCAKE_NUTS = "腹がいっぱいになれる。"--五仁月饼检查

STRINGS.NAMES.MYTH_MOONCAKE_LOTUS= "「莲蓉月饼」" --莲蓉月饼名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_MOONCAKE_LOTUS = "食欲をそそられて、何を食べさせてもいい！"--莲蓉月饼检查

STRINGS.NAMES.MYTH_FLYSKILL_YT = "「霜玉云」" --霜玉云
STRINGS.RECIPE_DESC.MYTH_FLYSKILL_YT = "霜や霧が立ちこめて，青雲を踏む。" --霜玉云配方描述

STRINGS.NAMES.MYTH_CHANG_E_FURNITURE = "座布団" --嫦娥旁边的垫子名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_CHANG_E_FURNITURE = "休憩に行ってもいい。"--垫子检查

STRINGS.NAMES.MYTH_CASH_TREE_GROUND = "摇銭樹" --摇钱树名字
STRINGS.RECIPE_DESC.MYTH_CASH_TREE_GROUND = "あなたは果てしない財宝を手に入れました。"--百宝囊配方描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_CASH_TREE_GROUND = "東方神話の「摇钱树」。"--摇钱树检查
STRINGS.NAMES.MYTH_CASH_TREE_GROUND_RECIPE = STRINGS.NAMES.MYTH_CASH_TREE_GROUND

STRINGS.NAMES.MYTH_CASH_TREE = "摇銭樹の苗木" --摇钱树树苗名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_CASH_TREE = "まだ大きくなかった。"--摇钱树树苗检查

STRINGS.NAMES.MYTH_TREASURE_BOWL = "「聚宝盆」" --聚宝盆名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_TREASURE_BOWL = "これは点金術よりずっとすごいだね。"--聚宝盆检查

STRINGS.NAMES.MYTH_SMALL_GOLDFROG = "小金ガマ" --小金蟾名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_SMALL_GOLDFROG = "大ヒキガエルの侍従。"--小金蟾检查

STRINGS.NAMES.MYTH_GOLDFROG_BASE = "元宝の彫像" --元宝雕像名字 挖boss 用的
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_GOLDFROG_BASE = "気をつけたほうがいい"--元宝雕像检查

STRINGS.NAMES.MYTH_GOLDFROG = "「聚宝金蟾」" --大蛤蟆名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_GOLDFROG = "あれは宝物がたくさんある！"--大蛤蟆检查

STRINGS.NAMES.MYTH_COIN = "銅貨" --铜钱名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_COIN = "天円地正、金を招き宝に入る。"--铜钱检查

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

STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_DOOR_EXIT_2 = "私は去る時刻に注意すべきです。"

STRINGS.MYTH_SKIN_ALCHMY_FUR_COPPER = "八卦炉"
STRINGS.MYTH_SKIN_ALCHMY_FUR_RUINS = "暗影転換炉"

STRINGS.MYTH_SKIN_REDLANTERN_MYTH_B = "蓮の燈"
STRINGS.MYTH_SKIN_REDLANTERN_MYTH_C = "春花彩"
STRINGS.MYTH_SKIN_REDLANTERN_MYTH_D = "走馬燈"
STRINGS.MYTH_SKIN_REDLANTERN_MYTH_E = "满月盈"
STRINGS.MYTH_SKIN_REDLANTERN_MYTH_F = "枯骨寒"
STRINGS.MYTH_SKIN_REDLANTERN_MYTH_G = "蛛丝缠"
STRINGS.MYTH_SKIN_REDLANTERN_MYTH_H = "引魄灯"
STRINGS.MYTH_SKIN_REDLANTERN_MYTH_I = "明玕照"


STRINGS.NAMES.FARM_PLANT_GOURD = "栽培したヒョウタン"
STRINGS.NAMES.GOURD_OVERSIZED = "巨型のヒョウタン"
STRINGS.UI.PLANTREGISTRY.DESCRIPTIONS.GOURD = "心をこめて世話をしてください！"
STRINGS.NAMES.KNOWN_GOURD_SEEDS = "ヒョウタンの種"

STRINGS.NAMES.MYTH_YJP = "玉净瓶"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_YJP = "生命に息吹が詰まった磁器の花瓶。"

STRINGS.NAMES.MYTH_GRANARY = "穀物倉"
STRINGS.RECIPE_DESC.MYTH_GRANARY = "大量の穀物を保管するために使用される専用の建物"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_GRANARY = "春耕夏勤，秋備冬備"

STRINGS.NAMES.MYTH_TUDI_SHRINES = "土地庙"
STRINGS.RECIPE_DESC.MYTH_TUDI_SHRINES = "人の住むところには、みんな祭るがある"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_TUDI_SHRINES = "黄酒と白酒を問わず、雄鶏と雌鶏は必ず太った鶏"

STRINGS.NAMES.MYTH_WELL = "井戸"
STRINGS.RECIPE_DESC.MYTH_WELL = "澄んで甘く，冬は暖かく，夏は涼しい"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_WELL = "とても清い井戸水"

STRINGS.NAMES.MOVEMOUNTAIN_PILL = "移山丹"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MOVEMOUNTAIN_PILL = "それを食べたら、ヴォフガンも私のライバルではない！"


STRINGS.NAMES.MYTH_TUDI = "土地公公"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_TUDI = "あなたも神様ですか？"

STRINGS.MYTH_TUDI_TRADE = "受けてもあげないのは，無礼である。"
STRINGS.MYTH_TUDI_ALREADYTRADE = "老児は禄を納めても，決して金に執着しない"
STRINGS.MYTH_TUDI_TIRED = {"正午、農民は畑で除草しており、汗が土地に落ちた","腰が…痛…たたたい"," いい天気だね、光り輝く水と山も美しい"}

STRINGS.MYTH_TUDI_ROTTEN_SPEAK = {"どこでも休耕田はないが、農民は餓死している","米粒は小さいが、やはり容易ではない,苦労を冗談にしてはいけない"}
STRINGS.MYTH_TUDI_RUNAWAY = "小神の法力は低く、一足先に…"

STRINGS.MYTH_TUDI_PLAYER_SPEAK = {
	common = {"施主さんありがとうございます。","あなたが幸せで順調に過ごしてください。"},
	monkey_king = {"大聖がここに来ることを知らず，お迎えすることがいないで，お許しください。","大聖は何か言い付けがありますか？"},
	neza =  {"三太子の言いつけを聞きます。","三太子には、おれになんを伝えたいことがありますか？"},
	white_bone =  {"お化けが近づいてきて、お先に失礼！"},
	pigsy =  {"天蓬元帥、このお寺はお捧げるが少ない、お手柔らかにしてください。","元帥がうまい汁を吸おうとするなら、他の家に変えましよう。"},
	myth_yutu =  {"このウサギは、またこっそり遊びに来ました。","後で嫦娥仙子にあなたを連れて帰ってもらいます。"},
	yangjian=  {"ここに来たのは何か私にやらせることがありますか？","ここにきてくれて、茅屋輝きをそえる"},
}

STRINGS.NAMES.MYTH_TOY_FEATHERBUNDLE = "毽子"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_TOY_FEATHERBUNDLE = "早く蹴って来て！ "

STRINGS.NAMES.MYTH_TOY_TIGERDOLL = "布老虎"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_TOY_TIGERDOLL = "可愛い！"

STRINGS.NAMES.MYTH_TOY_TUMBLER = "だるま"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_TOY_TUMBLER = "精良で神似な「土地公公」のだるま！"

STRINGS.NAMES.MYTH_TOY_TWIRLDRUM = "拨浪鼓"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_TOY_TWIRLDRUM = "ドンドンドンドンドン"

STRINGS.NAMES.MYTH_TOY_CHINESEKNOT = "中國結"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_TOY_CHINESEKNOT = "祝福に満ちた結び目で一年の幸せを祈る。"

STRINGS.NAMES.MYTH_FOOD_TABLE = "赤木の食卓"
STRINGS.RECIPE_DESC.MYTH_FOOD_TABLE = "真っ赤な食卓は、おめでたい年の味！"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_TABLE = "団々円々，歳々年々。"

STRINGS.NAMES.MYTH_FOOD_SJ = "水餃子"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_SJ = "お正月には麺と同じような食物を食べます。この中には様々な食材が含まれていて、この上なくうまい。"

STRINGS.NAMES.MYTH_FOOD_BZ = "大きい肉まん"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_BZ = "美しい朝は大きな肉まんから始まります。"

STRINGS.NAMES.MYTH_FOOD_XJDMG = "鶏とキノコの煮込み"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_XJDMG = "天の王は虎の上、鶏のきのこ煮込み"

STRINGS.NAMES.MYTH_FOOD_HSY = "麻辣紅焼魚"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_HSY = "心と胃を温める"

STRINGS.NAMES.MYTH_FOOD_BBF = "八宝飯"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_BBF = "甘くても飽きない，大いに役にたつ。"

STRINGS.NAMES.MYTH_FOOD_CJ = "折月春巻"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_CJ  = "月光の束を折って、あなたの心房を送ります。"

STRINGS.NAMES.MYTH_FOOD_HLBZ = "にんじんジュウス"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_HLBZ = "健康と顔をケアして、佳人に専属"

STRINGS.NAMES.MYTH_FOOD_LWHZ = "臘味合蒸"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_LWHZ  = "やせても硬くではないが、香ばしくて飽きない。香りが口いっぱいになり，薫りが鼻をつく。"

STRINGS.NAMES.MYTH_FOOD_TSJ = "屠蘇酒"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_TSJ = "祝日の屠蘇酒を飲みながら、暖かく春が来たと感じました。"

STRINGS.NAMES.MYTH_FOOD_TR = "糖人"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_TR = "彼は神話の中の英雄です。"

STRINGS.TUDI_SHRINES_NEEDGOODFOOD = "貢ぎ物は調理済みの美食が必要です。"
STRINGS.TUDI_SHRINES_NEEDOTHERFOOD = "もう同じ種類の食べ物がありました。"
STRINGS.TUDI_SHRINES_REFUSEFOOD = "ご心配をおかけして恐れ入ります。"

STRINGS.NAMES.BOOKINFO_MYTH = "天書"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOKINFO_MYTH = "これは数々の秘話があるの宝庫です。"

STRINGS.NAMES.MYTH_HONEYPOT = "蜜の缶"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_HONEYPOT = "ハチミツでいっぱい埋めるとサプライズがあります。"

STRINGS.NAMES.LAOZI_BELL = "兜率牛鈴"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAOZI_BELL = "これは「太上老君」が「青牛」のために鍛えた鈴です。"

STRINGS.NAMES.LAOZI_BELL_BROKEN = "壊れたカウベル"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAOZI_BELL_BROKEN = "ひどく壊れていたが、もしかして練丹炉で修理できるかもしれない。"

STRINGS.NAMES.SADDLE_QINGNIU = "兜率牛鞍"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SADDLE_QINGNIU = "この鞍には八卦の図があります。"

STRINGS.NAMES.LAOZI_QINGNIU = "板角青牛"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAOZI_QINGNIU = "上古瑞獣「兕」は、盛世にして現われた。"

STRINGS.ACTIONS.CASTAOE.MYTH_QXJ = "一尺寒光"
STRINGS.ACTIONS.CASTAOE.MYTH_WEAPON_SYF = "寒氷横掃"
STRINGS.ACTIONS.CASTAOE.MYTH_WEAPON_GTT = "蓄力重錘"
STRINGS.ACTIONS.CASTAOE.MYTH_WEAPON_SYD = "炙熱斬撃"
STRINGS.ACTIONS.CASTAOE.CANE_PEACH = "弃杖化林"

STRINGS.MYTH_SKIN_GROUNDLIGHT_STD = "石塔蹬"
STRINGS.MYTH_SKIN_GROUNDLIGHT_RYX = "如意霄"
STRINGS.MYTH_SKIN_GROUNDLIGHT_QZH = "青竹辉"
STRINGS.MYTH_SKIN_GROUNDLIGHT_LLT = "玲珑塔"
STRINGS.MYTH_SKIN_GROUNDLIGHT_BGZ = "白骨枝"
STRINGS.MYTH_SKIN_GROUNDLIGHT_BLZ = "宝莲盏"
STRINGS.MYTH_SKIN_GROUNDLIGHT_GXY = "桂香盈"
STRINGS.MYTH_SKIN_GROUNDLIGHT_YHY = "幽魂引"
STRINGS.MYTH_SKIN_GROUNDLIGHT_CXH = "翠镶红"
STRINGS.MYTH_SKIN_GROUNDLIGHT_ZSZ = "蛛设织"


STRINGS.NAMES.MYTH_SIVING_BOSS = "子圭玄鳥"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_SIVING_BOSS = "北海に山があって、その名は「幽都」。 そこから黒い水が出て、その上に玄鳥がある。"

STRINGS.NAMES.SIVING_ROCKS = "子圭石"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SIVING_ROCKS = "この中には強い生命力があることを感じます!"

STRINGS.NAMES.SIVING_STONE = "子圭青金"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SIVING_STONE = "仏者に名前を問わず、道者に長寿を問わず、この金だけは、不死不滅"

STRINGS.NAMES.ARMORSIVING = "子圭戦甲"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMORSIVING = "敵は雲のように多くだが、兵士たちはそれでも勇敢に前進してきた。"

STRINGS.NAMES.SIVING_HAT = "子圭戦盔"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMORSIVING = "戦士の肉体が死ぬと、その魂は神になる！"

STRINGS.NAMES.MYTH_PLANT_LOTUS = "蓮花株"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_LOTUS = "小さな蓮はやっと尖がりを現して、とっくにトンボが上に立っていた。" --待修改

STRINGS.NAMES.MYTH_LOTUS_FLOWER = "蓮花"
STRINGS.RECIPE_DESC.MYTH_LOTUS_FLOWER = "命をもって償う。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_LOTUS_FLOWER = "香遠益清、亭亭浄植。"

STRINGS.NAMES.LOTUS_ROOT = "蓮根"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LOTUS_ROOT = "さくさくして口当たりがいい"

STRINGS.NAMES.LOTUS_ROOT_COOKED = "焼き蓮根"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LOTUS_ROOT_COOKED = "モチモチとした歯ごたえがあって、生食のようにさっぱりしていません。"

STRINGS.NAMES.LOTUS_SEEDS = "蓮の実"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LOTUS_SEEDS = "味は甘くて薬の性質は穏やかで、脾胃に対して利益があります。"

STRINGS.NAMES.LOTUS_SEEDS_COOKED = "焼き蓮の実"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LOTUS_SEEDS_COOKED = "もちもちとした甘い蓮の実が、あなたの心を温めます。"

STRINGS.NAMES.MYTH_LOTUSLEAF = "蓮の葉"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_LOTUSLEAF = "一晩の風雨が過ぎたら，私は自分でほこりを染めなかった。"

STRINGS.NAMES.MYTH_LOTUSLEAF_HAT = "蓮の葉の帽子"
STRINGS.RECIPE_DESC.MYTH_LOTUSLEAF_HAT = "時々風が蓮の葉の香を吹く。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_LOTUSLEAF_HAT = "道行く人が笑うな，子供にとっては宝だ。"

STRINGS.NAMES.MYTH_FOOD_LZG = "氷糖蓮子羹"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_LZG = "脾胃を補い，心身を和らげる。"

STRINGS.NAMES.MYTH_FOOD_ZYOH = "折月藕盒"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_ZYOH = "香りが心にしみる"

STRINGS.NAMES.MYTH_FOOD_PGT = "レンコンリブスープ"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_PGT = "さて、材料は大きなリブが2本と... 「哪吒」?"

STRINGS.NAMES.MYTH_FOOD_HBJ = "鶏のハスの葉包み"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_HBJ = "香りが強くて、とても美味しい。"

STRINGS.NAMES.MYTH_WEAPON_SYF = "霜钺斧"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_WEAPON_SYF = "坎水のエッセンスから鍛えられており、非常に冷たいので使用する際に必ず注意しなきゃ…"

STRINGS.NAMES.MYTH_WEAPON_SYD = "暑熤刀"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_WEAPON_SYD = "離火のエッセンスから鍛えられており、火炎は近くにあるものを全て焼き尽くす。"

STRINGS.NAMES.MYTH_WEAPON_GTT = "扢挞藤"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_WEAPON_GTT = "巽風のエッセンスから鍛えられており、砂石の力を動員できる。"

STRINGS.NAMES.MYTH_QXJ = "七星剣"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_QXJ = "文犀六属鎧、宝剣七星光。"

STRINGS.NAMES.MYTH_RHINO_BLUEHEART = "辟寒心臓"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_RHINO_BLUEHEART = "「坎水」の力に満たされた心臓。"

STRINGS.NAMES.MYTH_RHINO_REDHEART = "辟暑心臓"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_RHINO_REDHEART = "「離火」の力に満たされた心臓。"

STRINGS.NAMES.MYTH_RHINO_YELLOWHEART = "辟塵心臓"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_RHINO_YELLOWHEART = "「巽風」の力に満たされた心臓。"

STRINGS.NAMES.TURF_MYTH_ZHU = "草の地皮"
STRINGS.RECIPE_DESC.TURF_MYTH_ZHU = "草の地皮"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TURF_MYTH_ZHU = "草の地皮。"

STRINGS.NAMES.TURF_QUAGMIRE_PARKFIELD = "桃園の地皮"
STRINGS.RECIPE_DESC.TURF_QUAGMIRE_PARKFIELD = "山野に広がる桃の花がこの土地に溶け込んでいる。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TURF_QUAGMIRE_PARKFIELD = "芳草が美しく,落花が咲き乱れている。"

STRINGS.NAMES.MYTH_PLANT_BAMBOO = "竹"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO = "四季は青々として、傲雪は霜をしのぐ。"

STRINGS.NAMES.MYTH_BAMBOO = "竹"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_BAMBOO = "四季は青々として、傲雪は霜をしのぐ。"

STRINGS.NAMES.MYTH_GREENBAMBOO = "蒼竹"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_GREENBAMBOO = "嵐を乗り越えなければ、蒼竹にはなれない"

STRINGS.NAMES.MYTH_BAMBOO_SHOOTS = "筍"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_BAMBOO_SHOOTS = "住所に竹がなくてはいけない。食物は筍がないともいけない。"

STRINGS.NAMES.MYTH_BAMBOO_SHOOTS_COOKED = "焼き筍"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_BAMBOO_SHOOTS_COOKED = "筍は日持ちしにくいので、日持ちさせるためには焼く必要がある"

STRINGS.NAMES.MYTH_FOOD_ZTF = "竹筒飯"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_ZTF = "涎が出させるの、エキゾチックな香り"

STRINGS.NAMES.MYTH_FOOD_ZSCR = "筍と肉の炒め"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_ZSCR = "筍と肉の炒めを奢ります？"

STRINGS.NAMES.MYTH_FUCHEN = "拂塵"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FUCHEN = "埃をかぶらないように，常にこれで拭いて"

STRINGS.LZOZI_QINGNIU_EATPILL = {
    SX = "これは老君の灰炉の灰にも及ばない",
    TY = "雲、霧に乗る",
    ZG = "動くない山のように",
    NS = "息を殺す",
}

STRINGS.MYTH_LAOZIPACK = "封印する"

STRINGS.NAMES.KRAMPUSSACK_SEALED = "封印させた袋"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KRAMPUSSACK_SEALED = "紫金葫蘆の製錬材料！"

STRINGS.NAMES.MYTH_STATUE_PANDAMAN = "謎の英雄の像"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_STATUE_PANDAMAN = "謎の英雄の像"

STRINGS.NAMES.MYTH_STORE = "クローズドショップ"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_STORE = "クローズドショップ"

STRINGS.NAMES.MYTH_STORE_CONSTRUCTION = "建設中のショップ"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_STORE_CONSTRUCTION = "建設中のショップ"

STRINGS.NAMES.MYTH_PASSCARD_JIE = "「通天敕令」"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PASSCARD_JIE = "教育には身分や地位はない"

STRINGS.USE_MIRROR = "着替える"

STRINGS.NAMES.MYTH_PLANT_BAMBOO_0 = "成長中の筍"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO_0 = "成長しよう、成長しよう！"
STRINGS.NAMES.MYTH_PLANT_BAMBOO_1 = "青竹の芽"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO_1 = "成長しよう、成長しよう！"
STRINGS.NAMES.MYTH_PLANT_BAMBOO_2 = "青竹の苗木"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO_2 = "成長しよう、成長しよう！"
STRINGS.NAMES.MYTH_PLANT_BAMBOO_3 = "青竹"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO_3 = "四季は常に青く、活気に満ちている。"
STRINGS.NAMES.MYTH_PLANT_BAMBOO_4 = "青竹"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO_4 = "四季は常に青く、活気に満ちている。"
STRINGS.NAMES.MYTH_PLANT_BAMBOO_5 = "蒼竹"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO_5 = "枯れ木はまだ春の風に寄りかかっていて、蒼竹はもう寒さから帰った。"
STRINGS.NAMES.MYTH_PLANT_BAMBOO_STUMP = "竹くい"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO_STUMP = "粉骨砕身は怖くない。"
STRINGS.NAMES.MYTH_PLANT_BAMBOO_BURNT = "焦げた竹"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO_BURNT = "世の中に潔白を残さねばならない。"

STRINGS.NAMES.MYTH_HUANHUNDAN = "還魂丹"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_HUANHUNDAN = "還魂丹、死人を起き上がらせ、白骨に肉を生やせ!"

--特殊新加
STRINGS.NAMES.MYTH_TOY_BOOKINFO = "神話おもちゃ" --玩具的名字
STRINGS.NAMES.MYTH_PIGSYSKILL_BOOKINFO = "剛鬣元身" --八戒的技能

STRINGS.NAMES.MYTH_FLYSKILL_YA = "幽冥身"
STRINGS.RECIPE_DESC.MYTH_FLYSKILL_YA = "紅塵がもうもうと立ちこめ,世に入って魂を拘捕する。"

STRINGS.USE_MYTH_SKELETON = "埋まる"

STRINGS.NAMES.MYTH_MOONCAKE_BOX = "月餅の箱"
STRINGS.RECIPE_DESC.MYTH_MOONCAKE_BOX = "月が曲がりくねっていて，喜びに満ちている。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_MOONCAKE_BOX = "精緻で美しい月餅の箱。"

STRINGS.NAMES.MYTH_COIN_BOX = "銅貨束"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_COIN_BOX = "銅貨一束"

STRINGS.USE_MYTH_COIN = "連なる"
STRINGS.USE_MYTH_ASTRAL = "還魂"
STRINGS.USE_MYTH_PLAYER = "附身"
STRINGS.USE_MYTH_ABSORB = "吸取"
STRINGS.USE_MYTH_DRINK = "喝"

--BUFF
STRINGS.NAMES.BUFF_M_LOCO_UP = "疾走"
STRINGS.NAMES.BUFF_M_BLOODSUCK = "嗜血"
STRINGS.NAMES.BUFF_M_ATK_UP = "強健" --增加攻击力
STRINGS.NAMES.BUFF_M_DEF_UP = "堅固" --增加防御力
STRINGS.NAMES.BUFF_M_UNDEAD = "不死"
STRINGS.NAMES.BUFF_M_ATK_ICE = "凝霜" --攻击带冰
STRINGS.NAMES.BUFF_M_ATK_ELEC = "馭電" --攻击带电
STRINGS.NAMES.BUFF_M_CHARGED = "感電" --杨戬的
STRINGS.NAMES.BUFF_M_HUNGER_STAY = "満腹"
STRINGS.NAMES.BUFF_M_SANITY_STAY = "凝神"
STRINGS.NAMES.BUFF_M_HUNGER_STRONG = "饕餮"
STRINGS.NAMES.BUFF_M_STRENGTH_UP = "移山"
STRINGS.NAMES.BUFF_M_IMMUNE_FIRE = "辟火"
STRINGS.NAMES.BUFF_M_IMMUNE_WATER = "辟水"
STRINGS.NAMES.BUFF_M_WARM = "辟寒"
STRINGS.NAMES.BUFF_M_COOL = "辟暑"
STRINGS.NAMES.BUFF_M_DUST = "辟塵"
STRINGS.NAMES.BUFF_M_DEATHHEART = "黒心" --白骨夫人的
STRINGS.NAMES.BUFF_M_ICESHIELD = "霜甲" --被攻击冻结敌人（单体）
STRINGS.NAMES.BUFF_M_IMMUNE_ICE = "抗凍" --免疫冰冻
STRINGS.NAMES.BUFF_M_INSOMNIA = "不眠" --免疫催眠
STRINGS.NAMES.BUFF_M_THORNS = "荊棘"
STRINGS.NAMES.BUFF_M_WORKUP = "高効" --工作效率提高
STRINGS.NAMES.BUFF_M_HEALTH_REGEN = "治療"
STRINGS.NAMES.BUFF_M_SANITY_REGEN = "回神"
STRINGS.NAMES.BUFF_M_HUNGER_REGEN = "果腹"
STRINGS.NAMES.BUFF_M_GLOW = "輝耀"
--以下都是熊猫人铺子的
STRINGS.NAMES.BUFF_M_PROMOTE_HEALTH = "栄養"
STRINGS.NAMES.BUFF_M_PROMOTE_HUNGER = "胃動"
STRINGS.NAMES.BUFF_M_PROMOTE_SANITY = "美味"
STRINGS.NAMES.BUFF_M_STENCH = "芬芬"

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