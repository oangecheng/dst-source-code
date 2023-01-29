-----人物描述部分
local function setrwms(yuyan)
    if yuyan == "chs" then
        STRINGS.MYTH_RENWUMIAOSHU = {
            MK = {
                "齐天大圣美猴王，身手敏捷脚步快。不善水性\n讨厌潮湿。好食瓜果素菜。出家人不沾荤，酒肉穿肠过，食用荤菜收益大减。",
                "当悟空对同一目标累计攻击6次，将触发分身，在目标四方召唤悟空分身对目标分别造成一次伤害。",
                "当年悟空大闹天宫，天庭纵火烧山，使花果山生灵涂炭，悟空靠近点燃的植物和烧焦的树木将触景生情，带来的精神伤害。",
                "H键开启火眼金睛，夜视，驱散雾，将会快速消耗饥饿与理智。在花粉与风沙天气下无法使用。",
                "如意金箍棒，重三万六千斤，其他兵器悟空不顺手，五成几率会脱手。悟空手持金箍棒不会被震脱手。右键技能【身外身法】消耗饥饿值瞬移至目标处，并在原地留下一个分身吸引仇恨。",
                "定海神针称心如意，在神话栏中可释放此技能，金箍棒变大并从天而降造成大范围破坏，威力极大，定要谨慎使用。",
                "空手右键自己，悟空将使用障眼法，变化作土地庙宇以此躲避靠近的愚蠢敌人，定要忍住莫要发声。"
            },
            NZ = {
                "哪吒是灵珠子转世，天生神童，降妖伏魔，无所不能无所不惧，面对怪物的噩梦光环减半。",
                "莲藕之躯，喜好潮湿，可在潮湿度较高时能缓慢自愈伤口，亦可自损身躯制做莲花，可将莲花种在水池中。潮湿状态下武器不滑落。",
                "顽童之心与神职之命碰撞，哪吒击杀邪恶生物将会获得理智奖励。如果伤害非邪恶生物将会受到少许理智惩罚。",
                "此枪识得主人，对着火目标或火属性目标造成双倍伤害。右键技能【三头六臂】，短暂无敌窜天后俯冲造成3次范围伤害。",
                "可远远地掷向目标，在多个目标间进行弹射，当乾坤圈返回时需要用手接住。乾坤圈识得主人。他人难以接着。",
                "此绫只护主，可为哪吒抵挡十次伤害，耐久可用莲花修复,披挂后还有小幅度提升行走速度。"
            },
            WB = {
                "是妖精，死后化作鬼魂，作祟生效概率高。只能通过骨架复活，复活恢复至巅峰。药膏腺体无法治疗伤口，血袋滋润效果更佳。暗影生物的伤害只会消耗夫人的饥饿值。夫人无法制作救赎之心。",
                "夫人拥有专属白骨制作栏可制造和使用白骨妖术，如骨质武器，阴森之心，骨架。骨质武器可用骨片修复。",
                "夫人好食精血，可以食用噩梦燃料，心脏。食用生肉无惩罚并有额外收益，其他荤类收益降低，素类收益更低。食用暗影之心有奇效。",
                "亲手杀死大型生物会遗留下尸体，左键可剖尸直接获得战利品和概率额外骨片，右键化尸将战利品融化成同等数量的噩梦燃料。可用噩梦燃料复活骨架作喽喽，喽喽会减少夫人从食物中获得收益。",
                "空手右键自己【化雾】，消耗少量饱食度，在自身附近召唤妖雾,在雾中行动更为敏捷，不会被生物发现并使有仇恨生物快速丢失仇恨。妖雾只在原地停留一段时间，当妖雾散去才可再次召唤。",
                "H键可切换面孔，白骨面孔更敏捷，脚步快，无法装备衣帽，美人面孔下可装备衣帽，受伤会让中立生物怜悯。变成白骨会惊动周围，当主动攻击生物或处于饥饿时将无法维持美人面孔。"
            },
            PG = {
                "触犯天条被贬下界投胎为猪，死亡后可以通过作祟猪屋投胎，投胎复活后会将此猪屋摧毁。",
                "猪人视八戒为同胞，不会拒绝八戒给予的食物，八戒可用素食收买猪人，在八戒受到危险时会出手相助。八戒面对猪王油嘴滑舌，有机会获得额外金子。",
                "八戒善农活，空手时收集浆果草树枝以及作物等会快速完成。施肥会获得理智奖励。手笨不善工，制作速度略慢。",
                "饿得快不挑食，吃任何食物都没有理智惩罚，不吃荤，吃荤食收益低。饥饿时攻击力减弱，甚至无力走路。可在生存栏消耗草制作【草垛】随时随地睡觉。",
                "吃得越饱皮越厚，饥饿值越高防御越高，饱腹时体型变大。",
                "八戒永远是人群中最欠揍的那一个。八戒的攻击会优先吸引仇恨，并且并不那么容易脱离仇恨。",
                "这耙子被八戒用来干农活，右键农田可以犁地，刨好的土堆可以播种作物。手持钉耙右键使用可以进行格挡数秒。格挡抵消大量伤害，剩余伤害将转换消耗八戒的饥饿值。"
            },
            YJ = {
                "天眼洞察黑暗，使杨戬能看穿暗影力量的本质，并在暗影力量面前能保持极度理智。杨戬排斥暗影力量，不屑于制作魔法道具。",
                "右键哮天犬原地待命，空手右键自己吹口哨召唤哮天犬。哮天犬会主动狩猎兔子，搜寻杨戬给予它的物品。月圆给月石可变身。",
                "附雷的三尖刀右键技能【驱雷掣电】朝选择区域发动瞬移突袭，并引数道天雷劈向附近目标，使目标会进入感电状态，受到的伤害增加。",
                "H键开启天眼，夜视，驱散雾，洞察黑暗，将会持续快速消耗饥饿。风沙天气下无法使用。",
                "待杨戬习得飞行术后，可变化雄鹰展翅，万里追踪，探开周围地图，并可选择一个目标直飞至其身边。亦可召唤傲天鹰，为队友运送补给。",
                "三尖刀是雷电属性的武器，会对潮湿目标造成额外雷电伤害右键技能【驱雷掣电】会吸引一道闪电，若闪电击中三尖刀便会给三尖刀附雷。累计攻击同一目标6次会引天雷劈向目标。"
            },
            YU = {
                "可以为兔子建造洞穴，也可以从兔子洞穴中找到收获。右键自己，可以遁入地下。遁地期间饥饿值和理智值消耗提高，夜视无法受到攻击和仇恨。饥饿状态，紫金葫芦和地震类技能会打断遁地。",
                "自带捣药杵，在神话栏使用技能【捣药】，最多同时捣2份药材，每个槽位的药材单独计算， 3秒后药材会消耗转化为药粉散开，药效会影响附近玩家。只有新鲜的素菜和特制药粉可以入药。",
                "是只兔子，素食者，与兔人友好。不那么惧怕黄昏黑夜。兔子不会躲避玉兔，且玉兔可将兔子直接拾起，玉兔不会伤害兔子。物品栏或背包中有兔子时会获得理智恢复，附近有兔子死亡都会让玉兔伤心、玉兔很喜爱胡萝卜相关的食物。",
                "神话栏召唤一只月蛾，月蛾会朝着广寒宫的方向飞舞，不可捕捉。",
                "月岛上不会有启蒙值负面效果，在月岛地皮上有移速加成,进入广寒宫不受时间限制且不会因天黑被嫦娥驱逐。与嫦娥互动时获得额外的好感度，嫦娥回馈月饼的概率翻倍。"
            },
            YA = {
                "黑白无常虽双生一体，属性却各不相同，可以主动切换在人世的形象。",
                "作为阴司正神，没有生命值，只有魂魄值。黑白无常不会死亡，当两位无常都魂飞魄散时变成一缕漂泊的魂魄，一段时间后再次临世。",
                "作为在世阴司，在黑白无常附近死去的生物的魂魄会被黑白无常收取，存放在无常官帽之中。",
                "黑白无常可以建造阎罗像，不断接引阴间幽冥的力量加诸己身。",
                "白无常持招魂幡，摄魂铃，黑无常持勾魂锁，镇魂令。招魂幡消耗善魂召唤灵体战斗，摄魂铃消耗善魂催眠。镇魂令消耗恶魂恐吓，勾魂锁的伤害取决于恶魂的数量。",
                "黑白无常可以引渡魂类生物、使逝去生命的躯体得到安息来获取善魂。"
            },
            ZZ = {
                "盘丝娘娘本是蜘蛛修炼成精，是一个妖精，拥有蛛丝值。不惧黑夜，善于用毒，蜘蛛视她为同类，其他生物视她为妖怪。",
                "可变回蜘蛛原形，拥有夜视，拥有较高范围攻击，可使敌人中毒，可用蛛丝化甲，抵御伤害。",
                "蜘蛛形态可以布网。人类形态可使用薄丝飞吻。",
                "盘丝娘娘可以直接捡起蜘蛛。可直接控制蛛丝，使蜘蛛卵降级或升级。薄如蝉翼的蛛丝害怕火焰，着火会使盘丝娘娘失去大量蛛丝值。",
                "盘丝娘娘善于用毒，攻击可以在敌人身上积累毒素。",
                "盘丝娘娘可以在地下或者树荫下盘丝而上，可以跨越地形。"
            },

        }
    elseif yuyan == "ja" then
        ---日语
        STRINGS.MYTH_RENWUMIAOSHU = {
            MK = {
                "足が速い。水が苦手で、湿気が嫌い。果物や野菜が好き。\n出家者は生臭物を食べない。酒肉穿腸過。生臭物を食べると収益が激減する。",
                "悟空が同じ目標に対して累積攻撃を6回行い、分身を触発し、目標の四角いところに悟空の分身を召喚して、分身は目標にそれぞれ1回ずつダメージを与える。",
                "当年、悟空は大鬧天宮して、天庭は山を焼き払った、花果山の生霊を塗炭させ、もし悟空が火をつけた植物や焦げた木に近づくと、景況に触れば、多くの精神的ダメージを受ける。",
                "Hボタンは火眼金睛を開けて、夜間視力を使って、霧を追い払って、急速に飽食度と理知値を消耗する。花粉や砂ぼこりでは使えない。",
                "如意金箍棒の重さは三万六千斤。他の兵器は悟空には似合わず、半分の確率で手が離せます。悟空が金箍棒を装備している時、右ボタンスキル：「身外身法」は飽食度を消耗して瞬時に目標に移動し、その場に分身を残して恨みをそそる。",
                "定海神針は悟空の意のままになれる、神話の柵の中でこの技能を釈放することができて、金箍棒は大きくなって、そして天から降ってきて広い範囲の破壊になって、威力はきわめて大きくて、きっと注意して使います。",
                "素手の状態で自分に向かって右ボタンを押して、悟空は障眼法を使って、土地廟に変えて、近づいてくる愚かな敵を避けれる、ぜひ我慢して、声を出さないで。"
            },
            NZ = {
                "「哪吒」は霊珠子の転生で、天生の神童、妖魔を落とす。何でもできる、何でも怖くない。モンスターに対しては理性に減少する効果が半減する。",
                "蓮根の体は湿気が好きで、湿気が高い時に自分でゆっくりと傷を癒すことができます。また自分の体を壊して蓮の花を作れる、蓮の花を池に植えることができる。濡れた状態で武器は手を離せこともない。",
                "子供の心は神職の命と共にある。邪悪な生物を撃ったら理性値の奨励がある。もし非邪悪な生物を傷つけるなら、少しの理性値の処罰を受ける。",
                "この銃は持ち主を識別できる、燃えている目標や火属性の目標に対して2倍のダメージを与える。右ボタンの技能三头六臂は短くて無敵で、空に昇った後に急降下して3回の範囲の傷害をもたらす。",
                "はるかに目標に投げ、複数の目標の間で弾射し、乾坤圏が戻ったら手で受け止める。乾坤圏が主を見分けがつく。他人のためには使えない。",
                "この綾は主人だけを保護しで、「哪吒」のために10回のダメージを完全に防ぐことができる。耐久性は蓮の花で修復できる。着用後も小幅な速度が向上する。"
            },
            WB = {
                "妖怪です。死後は死霊となり、祟りの効率が高い。骨組みだけを通して復活し、復活してピークの状態に戻る。軟膏と腺体は傷口を治療できない、血液袋の栄養補給効果がより良い。影の生物の傷害は奥さんの飽食度を消耗するだけ。夫人は救いの心を作れない。",
                "夫人は専門の白骨の製作欄を持っていて、白骨の妖術を製造して使うことができて、例えば骨の武器、陰森の心、骨組み。骨の武器は骨片で修復できる。",
                "夫人は精血が好きだ。悪夢燃料と心臓を食べられる。生肉を食べたら罰がなく、しかも、より多くの収益がある。他の肉類の収益は低く、素類の収益はもっと低いです。暗影の心を食べるには奇効がある。",
                "大型生物を手で殺すと死体が残る。左ボタンで直接に戦利品と確率を得て骨片を獲得します。右ボタンで死体は戦利品を溶かします。戦利品の量と同量の悪夢の燃料を受け取ることができる。悪夢の燃料を使って骨格を復活させることができる。白骨の随従は夫人が食べ物から得た収益を減らせる。",
                "空手の状態、右ボタンは自分で「霧作」の技能を使用して、少量の飽食度を使って、自身の近くで妖霧を召喚して、霧の中で行動するのは更に敏捷で、生物に発見されることはできなくて、そして憎しみの生物について急速に恨みをなくさせる。妖霧はしばらくその場に留まり、妖霧が消える後にまた再び召喚できる。",
                "Hボタンは顔を切り換えることができる。白骨の顔はもっと速くて、足取りが速くて、服と防具を装備できない。美人の顔の下には服と防具を装備できる。傷を受けると中立生物に同情を感じさせる。白骨になると周りを驚かせる。生物を積極的に攻撃したり、飢餓状態になったり、美人の顔を維持できなくなる。"
            },
            PG = {
                "天条に触れて、けなさせた、世の中に来た、豚に転生した、死后は救いの心や、猪屋に生まれ変わることを通じて生まれ変わるしかない。",
                "豚は八戒を同胞として、八戒からの食べ物を拒否しない。八戒は菜食で豚を買い入れることができる。八戒は危険を受けると助けになる。八戒は猪王に向かって口先がうまくと、より多くの金子を獲得する機会がある。",
                "八戒は農作業が得意で、素手でベリー、草、枝、作物を集めると早く完成できる。肥料をやると理知値の奨励を受ける。手が不器用で、作るのが苦手。制作スピードがちょっと遅い。",
                "お腹が空いているのが速くて、好き嫌いがなくて、いかなる食品を食べても理知値の罰がなくて、生臭物を食べて収益が低い。空腹の時は攻撃力が弱まり、歩く力さえない。生存欄で草を消費し、草積むを作って、いつでもどこでも寝られる。",
                "お腹がいっぱいになるほど、皮が厚くなり、飽食度が高くなるほど防御が高まり、お腹がいっぱいになると体が大きくなる。",
                "八戒はいつも人の群れの中で一番見慣れない。八戒の攻撃は憎しみを優先的に惹きつけ、恨みから離れにくい。",
                "この熊手は八戒によって農作業に使われ、右ボタンの空き田は鋤で耕し、掘った土の山は作物を植えることができる。熊手を持って、生物について右ボタンを押す、生物に数秒の間ブロックができる。ブロックは大量の傷害を相殺することができて、残りのダメージは八戒の飽食度に変換されて消耗する。"
            },
            YJ = {
                "天眼は闇を見抜き、影の力の本質を見抜き、影の力を前にして極度の理知を保つことができる。楊戬は影の力を排斥して、魔法の道具を作ることを潔しとしない。",
                "右ボタンの哮天犬はその場で待機して、素手の右ボタンは自分で口笛を吹いて、哮天犬を呼べる。「哮天犬」は自発的にウサギを狩猟できて、楊戬からあげた物品も探せる。満月の時に月の石を与えたら、変身できる。",
                "三尖刀は雷の属性を持つ武器で、濡れたターゲットには追加の雷電ダメージを与えます。右ボタンの技能「駆雷掣电」は稲妻を引きつける。もし稲妻が三尖刀に当たると雷の効果が付加できる。雷の効果がある時に、同じ目標に累積攻撃の回数は6回になったら、天雷を相手に撃てることができる。",
                "Hボタンは天眼を使い、夜間視力、霧を追い払い、暗闇を洞察し、飽食度を急速に消耗し続ける。砂ぼこりの時は使えない。",
                "楊戬が飛行術を習得したら、雄鷹の羽ばたきを変えて、万里の追跡をできて、周囲の地図を探せる。そして、チームメートを選んで直接に彼のそばに飛ぶことができる。孤天鷹を召喚できて、チームメイトに補給を送れる。",
                "雷の効果の下の三尖刀の右ボタンの技能「駆雷掣电」は選択したエリアに向かって瞬間的に移動して突撃し、複数の雷を誘発して近くの目標に割り、ターゲットを感電状態にして、受けるダメージが増加する。"
            },
            YU = {
                "ウサギのために穴を作ることもできるし、ウサギの穴から何かを収穫することもできる。マウスの右ボタンは自分で地下に逃げ込むことができる。地下では、夜視に似た効果があり、攻撃や他の生物からの憎しみを受けないが、満腹度や理知値をより速く消費し、空腹、「紫金葫蘆」や地震技能などは技能の効果を断つことがある。",
                "薬棒を持っていて、攻撃距離が短い。神話欄で技能を使って、薬草を2つ置くことができる。2つの薬草は単独で計算する。3秒後、薬草は消耗し、薬粉に変えて散布する。薬効は近くのプレーヤーに影響する。",
                "ウサギだから、ベジタリアンだ。暗があまり怖くない、ウサギ人との関係はとても友好的だ。ウサギは彼女を避けることはやらない。彼女はウサギを直接拾ってもいいだ。彼女はウサギを傷つけることはない。物品欄やリュックサックの中にウサギがいる時、彼女はずっと理知を回復できる。近くにウサギが死んだら彼女を悲しませる。彼女はニンジンに関する食べ物が好きだ。",
                "神話欄で花弁を一つ使って月蛾を召喚して、月蛾は「広寒宮」の方向に飛んでいく、捕獲できない。",
                "月島では啓蒙値の負の効果はなく、月島地皮でより速い移動速度が得られる。「広寒宮」に入ると時間の制限を受けず、「嫦娥」に追い立てられない。「嫦娥」の好感度を上げる過程で、月餅を獲得する確率が倍になり、「嫦娥」とのふれあいの時に好感度のアップはより速くなる。"
            },
            YA = {
                "黒と白の無常は、双人が一体でありながら、異なる属性を持ち、人間界でイメージを切り替えることができる。",
                "冥界の神として、命の値はなく、代わりに魂の値がある。無常は死なず、魂が散ったときに彷徨える霊となり、しばらくして再びこの世に現す。",
                "冥界の神として、黒白の近くで死んだ生き物の魂は黒白に集められ、無常官帽の中に保管される。",
                "黑白は、閻王の像を建て、冥界の力を自分に注ぎ込むことができる。",
                "白無常が招魂幡と撮魂鈴を持っている、黒無常が勾魂鎖と鎮魂令を持っている。招魂幡は善魂を使って幽霊を召喚して戦わせ、撮魂鈴は善魂を使って催眠術をかける。鎮魂令は悪魂を使って威嚇するもので、勾魂鎖のダメージは悪魂の数によって変化する。",
                "黒白無常は、魂のような生き物を引き渡せる、亡くなった人の体を休ませて、善魂を手に入れることができる。"
            },
            ZZ = {
                "盤絲娘娘は元々クモだ、クモの糸の値を持ってある。 夜を恐れず、毒を使うのが得意で、クモからは同類とみなされ、他の生物からは妖怪とみなされる。",
                "元のクモの姿に戻ることができて、夜間視力を持ち、高い範囲の攻撃を持ち、敵を毒殺することができて、クモの糸で鎧に変化してダメージから守ることができる。",
                "クモ型は巣を作れる。 人型は投げキッスが使える。",
                "彼女は直接にクモを拾える。クモの糸を直接操作して、クモの卵をダウングレードしたり、アップグレードしたりすることができる。 クモの糸は炎を怖がり、火をつけるとは大量のクモの糸の値を失ってしまいる。",
                "毒を使うのが得意で、彼女の攻撃は敵に毒を蓄積させることができる。",
                "盤絲娘娘は地下や木陰で糸を巻いて上に飛ぶことができ、地形を越えることができる。"
            },
        }

    elseif yuyan == "vi" then
        STRINGS.MYTH_RENWUMIAOSHU = {
            MK = {
                "Hầu Vương Tại Thế. Tề Thiên Đại Thánh Mỹ Hầu Vương, thân thủ nhanh nhẹn. Ghét ẩm ướt. Rất thích ăn hoa quả và các món chay. Người xuất gia không tham đồ mặn, ăn đồ mặn sẽ bị giảm lợi ích.",
                "Lông Mao Cứu Mạng. Khi Ngộ Không tấn công cùng một mục tiêu 6 lần, sẽ gọi ra 4 phân thân. Mỗi phân thân sẽ gây sát thương một lần cho mục tiêu.",
                "Ray Rứt Không Yên. Năm đó Tôn Ngộ Không đại náo thiên cung, thiên đình phóng hỏa đốt núi, khiến hoa quả sơn sinh linh đồ thán. Ngộ Không đứng gần cây cối sinh vật bị thiêu đốt cảm thấy bất nhẫn. Từ đó mỗi lần thấy cây cháy sẽ bị giảm tinh thần.",
                "Hỏa Nhãn Kim Tinh. Nhấn phím H bật hỏa nhãn kim tinh, nhìn được ban đêm, nhìn xuyên sương mù, nhưng gây tiêu hao nhanh chóng độ đói và tinh thần. Không thể sử dụng trong bão cát.",
                "Kim Cô Bổng. Như Ý Kim Cô Bổng, nặng 3 vạn 6 nghìn cân. Mọi món vũ khác đều không thuận tay, có tỷ lệ tuột khỏi tay 50%. Ngộ Không cầm Kim Cô Bổng không bị văng khỏi tay. Thêm kỹ năng Thân Ngoại Thân Pháp, tiêu hao độ đói để dịch chuyển tức thời đến vị trí chỉ định, để lại một phân thân để thu hút kẻ địch.",
                "Nhất Trụ Kình Thiên. Khi không cầm trên tay có thể tiêu hao tinh thần để thi triển kỹ năng Nhất Trụ Kình Thiên, Kim Cô Bổng sẽ phóng to ra và giáng xuống từ trời để phá nát một vùng lớn và gây sát thương đến kẻ thù trong vùng.",
                "Chướng Nhãn Pháp. Tay không bấm chuột phải vào bản thân sẽ khiến Ngộ Không dùng chướng nhãn pháp để biến thành Miếu Thổ Địa, tránh kẻ địch ở gần. Phải im lặng chớ gây tiếng động."
            },
            NZ = {
                "Linh Châu Chuyển Thế. Na Tra là Linh Châu Tử chuyển thế, kỳ tài trời sinh, hàng yêu phục ma, không sợ cái thằng nào. Đối mặt với quái vật, tinh thần chỉ bị giảm phân nửa.",
                "Thân Sen Thành Thánh. Thân củ sen, thích ẩm ướt, khi độ ướt tăng cao sẽ từ từ hồi máu. Có thể cắt thân tạo hoa sen, hạt sen đó có thể trồng trên hồ. Vũ khí ẩm ướt không bị tuột khỏi tay.",
                "Thần Tướng Ngoan Đồng. Tính cách nghịch ngợm lại phải làm tướng trên thiên đình. Na Tra giết quái vật sẽ tăng tinh thần. Nhưng sát hại sinh linh vô tội sẽ bị giảm một ít tinh thần.",
                "Hỏa Tiêm Thương. Cây thương này chỉ nhận Na Tra làm chủ. Nó sẽ gây sát thương gấp bội đối với những mục tiêu hệ hỏa. Kỹ năng chuột phải: Ba Đầu Sáu Tay. Na Tra giáng xuống từ trời gây sát thương diện rộng liên tiếp ba lần.",
                "Càn Khôn Quyện. Có thể tấn công liên hoàn nhiều mục tiêu từ xa, cần bắt lấy khi bay trở về. Càn Khôn Quyện chỉ quen biết chủ nhân là Na Tra. Những người khác khó mà bắt lấy được nó.",
                " Hỗn Thiên Lăng. Chỉ bảo vệ Na Tra. Có thể chặn 10 lần sát thương. Dùng hoa sen phục hồi độ bền. Ngoài ra nó còn giúp tăng tốc độ di chuyển."
            },
            WB = {
                "Thi Ma Thành Tinh. Là yêu tinh. Khi là hồn ma rất quậy phá. Chỉ có thể hồi sinh bằng Hài Cốt. Sau khi hồi sinh đạt trạng thái tối đa. Thuốc hồi máu không có tác dụng, nhưng Túi Muỗi hiệu quả hơn. Sinh Vật Ảo Ảnh tấn công chỉ làm Phu Nhân đói hơn. Phu Nhân không thể tạo Tim Mách Lẻo.",
                "Bạch Cốt Yêu Thuật. Phu Nhân có một mục chế tác riêng biệt gọi là Bạch Cốt, dùng để chế tạo bằng yêu thuật Bạch Cốt, như vũ khí bằng xương, Skeleton, hoặc Âm Sâm Chi Tâm. Vũ khí xương có thể sửa được bằng Mảnh Xương.",
                "Thích uống máu tươi. Phu Nhân thích uống máu tươi, có thể ăn Tim Mách Lẻo và Nhiên Liệu Ác Mộng. Ăn thịt tươi không bị trừng phạt mà còn tăng cao trạng thái. Các món mặn khác nhận ít hiệu quả hơn bình thường. Món chay có hiệu quả cực thấp. Ăn Tâm Nhĩ Hắc Ám có hiệu quả thần kỳ.",
                "Thao túng xương cốt. Tự tay giết chết sinh vật lớn sẽ lưu lại thi thể. Chuột trái phanh thây lấy chiến lợi phẩm, có thể nhận được Mảnh Xương. Chuột phải phân rã thành Nhiên Liệu Ác Mộng. Có thể dùng Nhiên Liệu Ác Mộng để hồi sinh Hài Cốt làm Lâu La. Lâu La làm giảm hiệu quả thức ăn của Phu Nhân.",
                "Xuất quỷ nhập thần. Tay không chuột phải vào bản thân sẽ tạo ra sương mù. Trong sương mù di chuyển nhanh hơn, không bị phát hiện, kẻ địch cũng từ bỏ truy đuổi nhanh hơn. Sương mù chỉ tồn tại tại chỗ trong một khoảng thời gian. Sau khi sương mù tan biến rồi mới có thể gọi thêm lần nữa.",
                "Kẻ hai mặt. Bấm phím H có thể luân phiên thay đổi giữa 2 khuôn mặt. Bạch Cốt Diện nhanh nhẹn, linh hoạt hơn, nhưng không thể mang áo mũ. Mỹ nhân diện có thể mang áo mũ, khi bị thương sẽ khiến sinh vật trung lập thương cảm. Biến Bạch Cốt Diện sẽ kinh động xung quanh. Chủ dộng tấn công hoặc bị đói sẽ không thể duy trì Mỹ Nhân Diện."
            },
            PG = {
                "Đầu thai làm heo. Vì phạm thiên quy bị giáng xuống trần đầu thai làm heo, sau khi chết chỉ có thể hồi sinh bằng cách ám vào nhà heo. Nhà heo sẽ bị phá hủy sau khi Bát Giới hồi sinh.",
                "Chơi thân với heo. Heo nhìn thấy Bát Giới sẽ chạy theo, không bao giờ từ chối món ăn mà Bát Giới đưa. Bát Giới có thể dùng món chay để mua chuộc heo. Khi Bát Giới gặp nguy sẽ ra tay giúp đỡ. Bát Giới có thể dẻo miệng với vua heo nên có cơ hội nhận thêm vàng/tiền khi đổi đồ.",
                "Giỏi nông dốt công. Bát Giới giỏi làm nông, tay không thu thập cây cỏ nông sản sẽ nhanh hơn. Bón phân sẽ giúp tăng tinh thần. Nhưng tốc độ chế tạo chậm hơn.",
                "Ham ăn mê ngủ. Không kén ăn, không bị hiệu ứng tiêu cực từ đồ ăn. Chê đồ mặn. Ăn mặn nhận được ít lợi ích hơn. Khi đói, sức tấn công bị giảm thảm hại, thậm chí không còn sức di chuyển. Trong thẻ Sinh Tồn có thể tạo ra ổ rơm để lăn ra ngủ bất kỳ lúc nào.",
                "Da thô thịt dày. Ăn càng no da càng dày, càng no phòng ngự càng cao.",
                "Nhìn mặt thấy ghét. Bát giới là nhân vật lì đòn nhất nhóm, cũng là xấu xí khó ưa nhất nhóm. Quái sẽ ưu tiên đánh Bát Giới trước mọi nhân vật khác, và sẽ không dễ dàng tha cho Bát Giới.",
                "Cửu Xỉ Đinh Ba. Cửu Xỉ Đinh Ba được Bát Giới dùng làm nông. Chuột phải vào mặt ruộng có thể xới đất. Tay cầm đinh ba chuột phải có thể đỡ được phần lớn sát thương trong vài giây. Phần còn lại sẽ tiêu hao độ đói của Bát Giới.",
            },
            YJ = {
                "Động sát hắc ám. Có thể nhìn thấy bản chất sức mạnh của bóng tối, và có thể giữ lý trí cực cao trước sức mạnh bóng tối. Dưỡng Tiễn bài xích sức mạnh bóng tối, xem thường những món đồ ma thuật.",
                "Thần khuyển là bạn. Tay không chuột phải vào Hao Thiên Khuyển để nó đứng tại chỗ chờ lệnh, tay không chuột phải vào bản thân để huýt sáo gọi Hao Thiên Khuyển. Hao Thiên Khuyển sẽ chủ động bắt thỏ, tìm kiếm món vật mà Dương Tiễn cho ngửi. Vào đêm trăng tròn, cho Hao Thiên Khuyển đá mặt trăng sẽ biến hình.",
                "Khu Lôi Xiết Điện. Kỹ năng chuột phải Tam Tiêm Kích dịch chuyển tức thời đến vùng đã chọn và tạo ra một số tia sét đánh vào quanh mục tiêu, khiến mục tiêu rơi vào trạng thái nhiễm điện, chịu thêm sát thương.",
                "Tam Nhãn Thần Mục. Bấm H mở thiên nhãn, nhìn ban đêm, xua tan sương mù, dò thám hang động, sẽ tiêu hao độ đói liên tục. Không thể sử dụng trong bão cát.",
                "Thần Ưng Tương Tùy. Sau khi học được Phi Hành Thuật, thì có thể biến thành chim ưng tung cánh, đi vạn dặm, dò thám quanh bản đồ, và có thể chọn 1 đồng đội hay 1 vật đánh dấu để bay đến bên cạnh. Có thể triệu hồi Ngạo Thiên Ưng, vận chuyển tiếp tế cho đồng đội.",
                "Tam Tiêm Lưỡng Nhận Đao. Là vũ khí lôi thuộc tính, sẽ gây thêm sát thương cho mục tiêu ẩm ướt, kỹ năng chuột phải \"Khu Lôi Xiết Điện\" sẽ gây ra một tia sét, nếu tia sét đánh trúng Tam Tiêm Đao thì Tam Tiêm Đao sẽ có thêm sét. Đánh 6 lần vào một mục tiêu sẽ kêu sét từ trời đánh vào mục tiêu."
            },
            YU = {
                "Giảo thố tam quật. Có thể tạo hang thỏ, cũng có thể nhặt đồ trong hang. Chuột phải vào bản thân để độn thổ. Thời gian ở độn thổ sẽ tiêu hao rất nhiều độ đói và tinh thần. Có thể nhìn được ban đêm, cũng không thể bị tấn công và bị truy kích khi đang độn thổ. Kỹ năng gây động đất, tử kim hồ lô, và đói sẽ khiến Ngọc Thố phải chui lên khỏi mặt đất.",
                " Đảo dược vi chức. Bản thân có một cái chày nghiền thuốc. Trong cột Myth, tiêu hao 5 no để nghiền thuốc. Có thể nghiền tối đa 2 nguyên liệu, mỗi nguyên liệu. Sau 30s, nguyên liệu sẽ chuyển hóa thành bột thuốc rơi ra ngoài, gây hiệu quả ảnh hưởng đến người chơi xung quanh. Chỉ có món chay còn tươi và nguyên liệu quý mới có thể làm thuốc.",
                "Linh lung tiên thố. Là một con thỏ, ăn chay, làm bạn với thỏ. Không sợ hoàng hôn, không sợ ban đêm. Thỏ sẽ không sợ Ngọc Thố, và Ngọc Thố có thể trực tiếp bắt thỏ mà không gây thương tổn. Khi hành trang hoặc túi có thỏ sẽ giúp Ngọc Thố phục hồi tinh thần. Nếu có thỏ chết gần đó sẽ khiến ngọc thố đau lòng và tuột tinh thần. Ngọc Thố cực kỳ thích các món ăn liên quan tới cà rốt.",
                "Nguyệt nga dẫn lối. Triệu hồi một con bướm tên Nguyệt Nga trong Thẻ Thần Thoại. Nguyệt Nga sẽ bay về hướng Quảng Hàn cung, không thể bắt được.",
                "Trường cư Nguyệt cung. Không bị hiệu ứng nghịch đảo tinh thần khi ở trên mặt trăng. Tăng tốc độ di chuyển khi đứng trên nền mặt trăng. Không bị giới hạn thời gian khi vào Quảng Hàn Cung, và sẽ không bị Hằng Nga đuổi ra ngoài ban đêm. Khi tặng quà cho Hằng Nga sẽ đạt được độ hảo cảm nhiều hơn. Có thể nhận thêm bánh trung thu từ Hằng Nga."
            },
            YA = {
                "Hắc Bạch Vô Thường dù hai người một xác, thuộc tính lại khác nhau. Có thể chủ động chuyển đổi giữa hai người.",
                "Là âm ti chính thần, không có chỉ số máu, chỉ có chỉ số hồn. Hắc Bạch Vô Thường không thể chết, nếu cả hai hồn phi phách tán thì biến thành 2 hồn phách phiêu bạt, một thời gian ngắn sau có thể trở lại",
                "Làm âm ti tại thế, Sinh vật chung quanh Hắc Bạch Vô Thường chết sẽ rơi hồn, hồn bị Vô Thường Quan Mão thu lại.",
                "Hắc Bạch Vô Thường có thể tạo Tượng Diêm La, đưa hồn phách xuống âm phủ sẽ giúp phục hồi chỉ số.",
                "Bạch Vô Thường cầm Chiêu Hồn Phiên, Nhiếp Hồn Linh, Hắc Vô Thường cầm Câu Hồn Tỏa, Trấn Hồn Lệnh. Chiêu Hồn Phiên tiêu hao Thiện Hồn để gọi Ân Hồn chiến đấu, Nhiếp Hồn Linh tiêu hao Thiện Hồn để ru ngủ, Trấn Hồn Lệnh tiêu hao ác hồn để đe dọa, Câu Hồn Tỏa gia tăng sát thương theo số lượng Ác Hồn",
                "Hắc Bạch Vô Thường có thể siêu độ Âm hồn, siêu độ thành công nhận được Thiện Hồn"
            },
            ZZ = {
                "盘丝娘娘本是蜘蛛修炼成精，是一个妖精，拥有蛛丝值。不惧黑夜，善于用毒，蜘蛛视她为同类，其他生物视她为妖怪。",
                "可变回蜘蛛原形，拥有夜视，拥有较高范围攻击，可使敌人中毒，可用蛛丝化甲，抵御伤害。",
                "蜘蛛形态可以布网。人类形态可使用薄丝飞吻。",
                "盘丝娘娘可以直接捡起蜘蛛。可直接控制蛛丝，使蜘蛛卵降级或升级。薄如蝉翼的蛛丝害怕火焰，着火会使盘丝娘娘失去大量蛛丝值。",
                "盘丝娘娘善于用毒，攻击可以在敌人身上积累毒素。",
                "盘丝娘娘可以在地下或者树荫下盘丝而上，可以跨越地形。"
            },
        }
    else
        --英文
        STRINGS.MYTH_RENWUMIAOSHU = {
            MK = {
                "Monkey King. Run speed 10% faster. Likes fruits and hate meats.\nGets double sanity drain while equipping wet objects.",
                "After MK attacks ONE target 6 times, 4 monkeys spawn around, each dealing 50 damage to that target.",
                "Hometown FlowerFruit Mountain was burned due to his fault. Burning plants and charred trees evoke reminiscence of that disaster, draining his sanity.",
                "Press Face Button(H) to activate night vision, and drain hunger and sanity fast. Can’t use in sandstorm or pollen.",
                "Character-specific item. Can’t be knocked out of his hands by boss. Other weapons have a 50% chance of slipping out of hands while attacking. Right-click while equipping to activate “Reborn Clone”: MK flashes away, leaves behind a decoy with Crushing Blow.",
                "Special Ability in Myth Tag. Summon the Golden Cudgel from the sky, in its original form. Dealing 400 damage AOE to nearby creatures and buildings, chopping down tress. Costs 50 sanity.",
                "Proficient in camouflage. Right-click himself with empty hand slot to disguise him.Transform into a temple to delude nearby enemies."
            },
            NZ = {
                "Nezha is a divine Orb’s afterlife, a sacred child of little fear.Monsters’ sanity drain aura is halved on Nezha.",
                "Nezha’s body is lotus root. He won’t be negatively affected by wetness. Gains a health regeneration when wetness is high enough. Can craft Lotus Flower and plant lotus in ponds.",
                "With impishness and divinity, Nezha slightly loses sanity when killing passive creatures, and restores sanity when slaying monsters.",
                "Character-specific weapon. Deal double damage to FIRE targets.Right-click to activate “Triple Attack”: Nezha soars up and dives onto the chosen area, dealing three AOE to nearby targets.",
                "Character-specific weapon. Ranged attack on clustered targets.Dealing 34 damage one by one. Need to catch it on its way back.",
                "The Red Damask is Nezha’s defensive talisman. Absorbs damage completely for 10 times, and can be mended with Lotus Flowers. Increases speed slightly."
            },
            WB = {
                "Shadow creatures’ attack drains her hunger instead of her health. Because WB has no real skins, salve or gland can’t heal her, except the blood sac. After death, her monster ghost has a high chance of haunting, and can only be revived through skeleton.",
                "WB has her own witchcrafting tab. She can craft Bone Sword, Bone Whip, Bond Staff, Skeleton, and Heart of Witch. The first three can be amended with bone shards.",
                "WB can eat nightmarefuels and hearts. She likes raw meats the most, other meats less, veggies the least. Eating Shadow Hearts excites her, increasing her damage and restoring her sanity.",
                "As a monster, WB uses nightmarefuels, and her hunger, to control skeletons.Left-click to Dissect dead creatures, looting extra bone shards; right-click to Corpsify dead creatures, turning all loots to equal amount of nightmarefuels.",
                "Right-click herself with empty hands to spawn fog. While in fog, her speed is increased, and she shrouds from other creatures. Only those that are attacked by her can detect her.",
                "WB has two faces: Bone’s and Maiden’s Face. Bone’s face has a damage resistance and walks faster, but body or head slots are filled. Maiden’s face, if under attack, is pitied by passive creatures. Maiden’s face automatically breaks when hungry or attacking actively."
            },
            PG = {
                "Pigsy was exiled from God’s world for harassing Chang’e, a goddess on the moon. He could be resurrected only by haunting a pighouse or the amulet.",
                "Pigsy is a pigman, a relative to other pigmen. They never reject food from Pigsy and even would help him when he’s in danger. The Pig King sometimes would give Pigsy extra gold nuggets.",
                "Pigsy is good at farm work. Picks things faster when empty-handed. He also gains sanity when fertilizing plants. But his crafting speed is slower.",
                "Pigsy is not picky about food, except meats. Weak and slow when he starves.He could use 3 cutgrass to set a disposable hay-bed from Survive Tab.",
                "Damage resistance increases with hunger, so does his size.",
                "Pigsy is always the most annoying and mocking of all. His targets will prioritize to attack him among others, and their hostility won’t be distracted easily.",
                "Character-specific weapon. Pigsy does farm work with his Nine-nail Rake. Right-click to till farm plots on the ground for seeds. Right-click the rake while holding it, to block all incoming damage for a while, draining hunger."
            },
            YJ = {
                "YJ’s Skyeye enables him to see through shadow’s nature, so shadow power can never affect his mind. He disdains using Magic Tab.",
                "An alway loyal dog. YJ right-clicks himself with empty hands to summon it or to have it stay where it is. Wheeze would go around and loot rabbits and anything YJ lets it smell.Wheeze needs feeding. YJ loses 50 maximum sanity when Wheeze dies. Can be resurrected by triggering Tooth Necklace with resurrection items.",
                "With Forkspear charged, right-click to activate “Ruling Thunders”: YJ rushes to the chosen area and shocks nearby targets, dealing three large-ranged AOE, and inflicting all targets with a 10% vulnerability to any damage.",
                "Press Face Button(H) to activate night vision, and drain hunger and sanity fast. Can’t use in sandstorm or pollen.",
                "Special Ability in Myth Tab. Transform into an eagle and explore the region around. Then choose one spot in this region, or another player in this world, to land.",
                "Character-specific electrical weapons. Deals more damage to wet targets. Right-click to have the spear absorb a lightning. After YJ attacks ONE targets 6 times, shoot a lighting to the target and deals more damage."
            },
            YU = {
                "Can craft burrows for rabbits, and loot something from rabbit caves.Can drain hunger and sanity to activate Underground Walk (with night vision), during which Yutu can’t attack or be detected. Underground Walk automatically breaks when hungry, under the effect of Copper Gourd, or experiencing earthquakes.",
                "Yutu has a job as a pounder. Has a character-specific Jade Pestle. Can use “Pounding” at Myth Tab, to create 2 distinct slots for medicine ingredients. Pounded powder affects nearby players after 3 seconds. Works only with fresh herbs or rare materials.",
                "Yutu is a fairy Jade Hare. Vegetarian. Not much afraid of dusk and night.As a fairy hare, Yutu is a friend of all rabbits. Rabbits won’t run from her, and are willing stay in her pockets to make her happy. Yutu would never hurt rabbits, and any dead rabbits nearby makes her sad. Yutu likes carrot-related food.",
                "Costs a petal to summon a moon moth. It will exist for only 5 seconds, and show you the direction of the Moon Palace. Can’t be captured.",
                "Yutu grew up in Moon Palace. Enlightenment doesn’t affect her negatively. Moves faster on moon turf. Has no time limit in the Moon Palace, nor would she be expelled during night. Offering Chang’e gifts gives extra goodwill. Chance of getting a mooncake doubled."
            },
            YA = {
                "黑白无常虽双生一体，属性却各不相同，可以主动切换在人世的形象。",
                "作为阴司正神，没有生命值，只有魂魄值。黑白无常不会死亡，当两位无常都魂飞魄散时变成一缕漂泊的魂魄，一段时间后再次临世。",
                "作为在世阴司，在黑白无常附近死去的生物的魂魄会被黑白无常收取，存放在无常官帽之中。",
                "黑白无常可以建造阎罗像，不断接引阴间幽冥的力量加诸己身。",
                "白无常持招魂幡，摄魂铃，黑无常持勾魂锁，镇魂令。招魂幡消耗善魂召唤灵体战斗，摄魂铃消耗善魂催眠。镇魂令消耗恶魂恐吓，勾魂锁的伤害取决于恶魂的数量。",
                "黑白无常可以引渡魂类生物、使逝去生命的躯体得到安息来获取善魂。"
            },
            ZZ = {
                "盘丝娘娘本是蜘蛛修炼成精，是一个妖精，拥有蛛丝值。不惧黑夜，善于用毒，蜘蛛视她为同类，其他生物视她为妖怪。",
                "可变回蜘蛛原形，拥有夜视，拥有较高范围攻击，可使敌人中毒，可用蛛丝化甲，抵御伤害。",
                "蜘蛛形态可以布网。人类形态可使用薄丝飞吻。",
                "盘丝娘娘可以直接捡起蜘蛛。可直接控制蛛丝，使蜘蛛卵降级或升级。薄如蝉翼的蛛丝害怕火焰，着火会使盘丝娘娘失去大量蛛丝值。",
                "盘丝娘娘善于用毒，攻击可以在敌人身上积累毒素。",
                "盘丝娘娘可以在地下或者树荫下盘丝而上，可以跨越地形。"
            },
        }
    end
end

return setrwms
