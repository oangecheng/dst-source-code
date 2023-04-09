local seg_time = TUNING.SEG_TIME--一格时间，默认30秒
local day_segs = TUNING.DAY_SEGS_DEFAULT--白天时间，10格，5分钟
local dusk_segs = TUNING.DUSK_SEGS_DEFAULT--傍晚时间，4格，2分钟
local night_segs = TUNING.NIGHT_SEGS_DEFAULT--夜晚时间，2格，1分钟
local total_day_time = TUNING.TOTAL_DAY_TIME--一天时间，16格，8分钟
local wilson_health=TUNING.WILSON_HEALTH--威吊血量，150
local multiplayer_armor_durability_modifier = 0.7--护甲基于血量的倍率
local multiplayer_armor_absorption_modifier = 1--护甲效果倍率
local day_time = seg_time * day_segs
local dusk_time = seg_time * dusk_segs
local night_time = seg_time * night_segs
local ise = TUNING.IS_LOW_COST--是否为简易模式
local chance_mult=ise and 2 or 1--权重倍率
local gain_mult=ise and 2 or 1--增益倍率
local condition_mult=ise and 0.5 or 1--条件倍率
local consume_mult=ise and 0.5 or 1--消耗倍率

TUNING_MEDAL ={
	------------------------------勋章---------------------------------
	COOK_MEDAL={--烹饪勋章
		MAXUSES = 200,--耐久
		CONSUME = 5*gain_mult,--解锁单个料理消耗耐久
	},
	CHEF_MEDAL={--大厨勋章
		MAXUSES = 100,--耐久
		CONSUME = 6*gain_mult,--解锁单个大厨料理消耗耐久
		SPICE_RATIO = 0.4,--需要调味料理的耐久比例
		SPICE_CONSUME = 1*gain_mult,--制作单个调味料理消耗耐久
	},
	CHOP_MEDAL={--伐木勋章
		SMALL_MAXUSES = 200,--初级伐木勋章耐久
		MEDIUM_MAXUSES = 800,--中级伐木勋章耐久
		CONSUME = -1*gain_mult,--单根木头消耗耐久
		CONSUME_MULT = gain_mult,--伐木熟练度增加倍率
	},
	MINER_MEDAL={--矿工勋章
		SMALL_MAXUSES = 100,--初级矿工勋章耐久
		MEDIUM_MAXUSES = 300,--中级矿工勋章耐久
		CONSUME = -1*gain_mult,--单个矿石消耗耐久
		CONSUME_MULT = gain_mult,--挖矿熟练度增加倍率
	},
	PLANT_MEDAL={--虫木勋章
		MAXUSES = 12,--*condition_mult,--耐久
		CONSUME = 1*gain_mult,--采摘单个巨大作物消耗耐久
		INTERACT_RANGE = 20,--照料范围
		FERTILITY = 20,--肥料包可提供的肥力(即照料次数)
	},
	VALKYRIE_TEST={--女武神的考验
		MAXUSES = 20,--耐久
		MAX_CONSUME_RATE = .5*chance_mult,--掉耐久的概率上限
		WARNING_THRESHOLD = 0.75,--警告阈值(做坏事时耐久不低于阈值会被警告,否则只会加满耐久)
		MUST_CONSUME_HEALTH = 2000,--必掉耐久的怪物血量
		DOUBLE_CONSUME_HEALTH = 4000,--双倍掉耐久的怪物血量
		CONSUME_MULT = gain_mult,--掉耐久的倍率
	},
	VALKYRIE_MEDAL={--女武神勋章
		COMBAT_ADDITION1=1.1,--默认攻击加成
		COMBAT_ADDITION2=1.4,--战斗长矛攻击加成
		MAX_POWER=10,--女武神之力上限
	},
	HANDY_TEST={--巧手考验
		MAXUSES = 300,--耐久
		CONSUME_MULT = gain_mult,--掉耐久的倍率
	},
	WISDOM_TEST={--蒙昧勋章
		MAXUSES = 200,--耐久
		CONSUME_MULT = gain_mult,--掉耐久的倍率
	},
	WISDOM_MEDAL={--智慧
		MAXUSES = 400,--耐久
		ADDUSES_TINY = 3*gain_mult,--血汗钱可补充耐久
		ADDUSES_LESS = 10*gain_mult,--血汗钱可补充耐久
		ADDUSES_MORE = 100,--新华字典可补充耐久
	},
	FISHING_MEDAL={--钓鱼勋章
		MAXUSES = 40,--钓鱼勋章耐久
		MEDIUM_MAXUSES = 100,--垂钓勋章耐久
		CONSUME_MULT = gain_mult,--掉耐久的倍率
		SMALL_TIME_MULT = 0.8,--钓鱼勋章咬钩时间倍率
		MEDAL_TIME_MULT = 0.4,--垂钓勋章咬钩时间倍率
		LARGE_TIME_MULT = 0.1,--渔翁勋章咬钩时间倍率
		MEDIUM_CHANCE_MULT = ise and 2 or 1.5,--垂钓勋章钓到遗失塑料袋的概率加成
		LARGE_CHANCE_MULT = ise and 3 or 2,--渔翁勋章钓到遗失塑料袋的概率加成
		MEDIUM_CONSUME_MULT = 0.8,--垂钓勋章钓到遗失塑料袋时消耗鱼饵的概率减免
		LARGE_CONSUME_MULT = 0.5,--渔翁勋章钓到遗失塑料袋时消耗鱼饵的概率减免
	},
	ARREST_MEDAL={--逮捕勋章
		MAXUSES = 10,--耐久
		CONSUME_MULT = gain_mult,--掉耐久的倍率
	},
	FRIENDLY_MEDAL={--友善勋章
		MAXUSES = 20,--耐久
		CONSUME_MULT = gain_mult,--掉耐久的倍率
	},
	CHILDISHNESS_MEDAL={--童心勋章
		MAXUSES = 500,--耐久
		CONSUME_MULT = gain_mult,--掉耐久的倍率
	},
	SPEED_MEDAL={--速度勋章
		MAXUSES = 200,--耐久
		MORE_MAXUSES = 400,--时空勋章耐久
		CONSUME_MULT = consume_mult,--耐久消耗倍率
		ADDUSES = 20*gain_mult,--单颗沙之石可补充的耐久
		SPEED_MULT = 1.2,--移速倍率
		FAST_SPEED_MULT = 1.25,--时空勋章移速倍率
	},
	TREADWATER_MEDAL={--踏水勋章
		PERISHTIME = total_day_time*5,--耐久
		ADDUSE = total_day_time*0.5*gain_mult,--单根邪天翁羽毛可补充的耐久
		CONSUME_MULT = consume_mult,--在海上攻击时耐久消耗倍率
		FAST_CONSUME_MULT = 5*consume_mult,--快速消耗耐久的倍率
		MAX_CONSUME = 0.04,--在海上攻击单次消耗耐久上限
		DAMAGE_MULT = consume_mult,--耐久耗光时的扣血量倍率
	},
	TENTACLE_MEDAL={--触手勋章
		DROP_CHANCE = 0.02*chance_mult,--触手勋章掉率
		MAX_LEVEL = 5,--最高等级
		CALL_CHANCE = ise and 0.15 or 0.1,--触手勋章每级召唤暗影触手增加的概率(活性触手棒)
		NORMAL_CHANCE = 0.025*chance_mult,--触手勋章每级召唤暗影触手增加的概率(其他武器)
		SENIOR_LEVEL =4*condition_mult,--解锁无视触手攻击功能的等级
	},
	INHERIT_MEDAL={--传承勋章
		MAX_LEVEL = 3,--最高等级
	},
	JUSTICE_MEDAL={--正义勋章
		MAX_VALUE = 100,--正义勋章耐久(即正义值初始上限)
		MAX_VALUE_MORE = 200,--正义值最大上限
		UPLEVEL_NEEDNUM = 4,--每多少个怪物精华可提升一次正义值上限
		UPLEVEL_VALUE = 10*gain_mult,--每一次可提升多少点正义值上限
	},
	OMMATEUM_MEDAL={--复眼勋章
		HUNGER_RATE = 1+consume_mult,--饥饿速度
	},
	DEVOUR_SOUL_MEDAL={--噬灵勋章
		MAXUSES = 20,--耐久
	},
	BEE_KING_MEDAL={--蜂王勋章
		MAXUSES = 300,--蜂王勋章耐久
		ADDUSE = 20*gain_mult,--单个蜂王浆补充的耐久
		ADDUSE_MORE = ise and 150 or 100,--单个凋零蜂王浆补充的耐久
		AOE_MULT = 0.75,--蜂王勋章群伤的伤害系数
		AOE_DIST = 3,--蜂王勋章AOE伤害范围
		POISON_DAMAGE = 3.4,--每层蜂毒标记可造成的额外伤害
		POISON_CD = 5,--蜂毒标记消失时间
		POISON_MAX = 20,--蜂毒标记层数上限
		POISON_MAX_NOCONSUME = 10,--无耐久时的蜂毒标记层数上限
	},
	MISSION_MEDAL={--使命勋章
		REWARD_NUM = 5,--默认奖励包果数量
	},
	
	------------------------------工具、武器---------------------------------
	LUREPLANT_ROD={--食人花手杖
		MAXUSES = 300,--耐久
		CONSUME_MULT = gain_mult,--掉耐久的倍率
		HUNGER_RATE = 1.5,--饥饿速度
		SANITY_AURA = -75*consume_mult/(day_time),--精神光环-15/min
	},
	MARBLEAXE={--大理石斧头
		MAXUSES = 200,--耐久
		EFFICIENCY = 2.5,--伐木效率
		--饥饿速度
		HUNGER_RATE = 3,--默认
		HUNGER_RATE_SMALL = 2,--初级伐木勋章
		HUNGER_RATE_MEDIUM = 1.5,--中级伐木勋章
		HUNGER_RATE_LARGE = 1,--高级伐木勋章
		--移动速度倍率
		SPEED_MULT = 0.7,--默认
		SPEED_MULT_SMALL = 0.8,--初级伐木勋章
		SPEED_MULT_MEDIUM = 1,--中级伐木勋章
		SPEED_MULT_LARGE = 1.1,--高级伐木勋章
	},
	MARBLEPICKAXE={--大理石镐子
		MAXUSES = 100,--耐久
		EFFICIENCY = 2,--挖矿效率
		--饥饿速度
		HUNGER_RATE = 3,--默认
		HUNGER_RATE_SMALL = 2,--初级伐木勋章
		HUNGER_RATE_MEDIUM = 1.5,--中级伐木勋章
		HUNGER_RATE_LARGE = 1,--高级伐木勋章
		--移动速度倍率
		SPEED_MULT = 0.7,--默认
		SPEED_MULT_SMALL = 0.8,--初级伐木勋章
		SPEED_MULT_MEDIUM = 1,--中级伐木勋章
		SPEED_MULT_LARGE = 1.1,--高级伐木勋章
	},
	MOONGLASS_TOOL={--月光玻璃工具
		MAXUSES = 25,--耐久(铲、锤)
		MAXUSES_LESS = 40,--耐久(网)
		EFFICIENCY = 10,--使用效率
	},
	MEDAL_TENTACLESPIKE={--活性触手尖刺
		MAXUSES = 1000,--耐久上限
		USES = 125,--初始耐久
		ACCTACK_RANGE = 1,--攻击距离
		ADD_ACCTACK_RANGE = 0.1,--每级攻击距离增值
	},
	MEDAL_FISHINGROD={--玻璃钓竿
		MAXUSES = 20,--耐久上限
		ADDUSE = 5*gain_mult,--单次补充耐久
	},
	
	AUTOTRAP_RESET_TIME = 20,--智能陷阱自动重置时间
	--蝙蝠陷阱
	TRAP_BAT_BLUEPRINT_RATE = .05*chance_mult,--蓝图掉率
	TRAP_BAT_RADIUS = 1.5,--作用范围
	TRAP_BAT_COMBAT = TUNING.BAT_HEALTH,--对蝙蝠杀伤力
	TRAP_BAT_COMBAT_OTHER = 1,--对其他生物杀伤力
	
	--淘气铃铛
	NAUGHTYBELL_MAX_USETIME = 3,--最大使用次数
	BELL_THIEFNUM_NOMAL = 3,--正常状态每次最高召唤小偷数量
	BELL_THIEFNUM_LESS = 2,--聆听者每次最高召唤小偷数量
	BELL_SANITYLOSS_NORMAL = -10*consume_mult,--正常状态每只小偷导致的精神损失
	BELL_SANITYLOSS_MORE = -15*consume_mult,--装备淘气勋章时每只小偷导致的精神损失
	BELL_SANITYLOSS_MAX = -20*consume_mult,--惹怒小偷时每只小偷导致的精神损失
	BELL_THIEFNUM_MAX = 10,--惹怒小偷时召唤小偷数量
	BELL_PROVOKE_THIEF_CHANCE = 0.05,--惹怒小偷的概率
	BELL_THIEFNUM_MEDAL_ADDITION = 1,--淘气勋章对单次召唤小偷的数量加成
	NAUGHTYBELL_HEALTH_LOSE = -5,--每只小偷额外扣除血量
	
	--高效耕地机
	MEDAL_FARM_PLOW_USES = 20,--耐久
	MEDAL_FARM_PLOW_ADDUSE = 3*gain_mult,--单次补充耐久
	--宝藏探测仪
	MEDAL_RESONATOR_USES = 12,--宝藏探测仪耐久
	MEDAL_RESONATOR_ADDUSE = 3*gain_mult,--宝藏探测仪单次补充耐久
	MEDAL_RESONATOR_BASE_TIME = night_time,--宝藏指示针持续时长,1分钟
	
	--方尖锏
	SANITYROCK_MACE_MAX_DAMAGE_MULT = 2.5,--方尖锏最高伤害倍率
	SANITYROCK_MACE_MIN_DAMAGE_MULT = 0.5,--方尖锏最低/默认伤害倍率
	SANITYROCK_MACE_MOON_DAMAGE_MULT = 1.25,--方尖锏月岛伤害倍率
	SANITYROCK_MACE_USES = 200,--耐久
	SANITYROCK_MACE_SANITYLOSS = 2*consume_mult,--每秒扣除精神
	SANITYROCK_MACE_ADDUSES = 1,--每秒恢复耐久
	
	--新弹药
	MEDALSLINGSHOTAMMO_SANITYROCK_DAMAGE = TUNING.SPEAR_DAMAGE,--方尖弹伤害34
	MEDALSLINGSHOTAMMO_SANITYROCK_TICK_DAMAGE = TUNING.SPEAR_DAMAGE,--方尖弹每秒真实伤害34
	MEDALSLINGSHOTAMMO_SANITYROCK_DURATION = 15,--方尖弹伤害持续时间
	MEDALSLINGSHOTAMMO_SANDSPIKE_DAMAGE = TUNING.SPEAR_DAMAGE,--沙刺弹伤害34
	MEDALSLINGSHOTAMMO_WATER_MOISTURE = 20,--落水弹增加潮湿度
	MEDALSLINGSHOTAMMO_DEVOURSOUL_DAMAGE_MULT = 0.02,--噬魂弹伤害(目标血量上限比例)
	MEDALSLINGSHOTAMMO_DEVOURSOUL_DAMAGE_MAX = 2000,--噬魂弹伤害上限
	MEDALSLINGSHOTAMMO_SPINES_AOE_DAMAGE = TUNING.SPEAR_DAMAGE,--尖刺弹范围伤害34
	MEDALSLINGSHOTAMMO_SPINES_AOE_RANGE = 3,--尖刺弹伤害范围
	
	------------------------------法杖---------------------------------
	--吞噬法杖
	DEVOUR_STAFF_USES = 500,--耐久
	DEVOUR_STAFF_RADIUS = 8,--吞噬范围
	DEVOUR_STAFF_SANITY_MULT = consume_mult,--每吞噬一个物品的消耗倍率
	DEVOUR_STAFF_SANITY_MAX = 100*consume_mult,--单次吞噬的饱食消耗上限
	DEVOUR_STAFF_HARVEST_COUNT = 1.5,--采收作物时的计数倍率
	DEVOUR_STAFF_HUNGER_RATE = 1,--饱食度→耐久转化率
	DEVOUR_STAFF_SANITY_RATE = 2,--精神值→耐久转化率
	DEVOUR_STAFF_HEALTH_RATE = 1.5,--健康值→耐久转化率
	--不朽法杖
	IMMORTAL_STAFF_RADIUS = 8,--施法范围
	IMMORTAL_STAFF_USES = 200,--耐久
	IMMORTAL_ESSENCE_ADDUSE = 20*gain_mult,--单次可补充耐久(不朽精华)
	IMMORTAL_FRUIT_ADDUSE = 50*gain_mult,--单次可补充耐久(不朽果实)
	--流星法杖
	METEOR_STAFF_RADIUS = 5,--流星雨范围
	METEOR_STAFF_USES = 200,--耐久
	METEOR_MEDAL_ADDUSE = 10*gain_mult,--单次可补充耐久
	METEOR_STAFF_CHANCE = 0.102191*chance_mult,--流星法杖生成概率
	--换肤法杖
	MEDAL_SKIN_STAFF_USES = 1000,--耐久(金额上限)
	MEDAL_SKIN_STAFF_ADDUSE = 10,--一个血汗钱可充值金额
	MEDAL_SKIN_STAFF_ADDUSE_COUPON = 30,--一张皮肤券可充值金额
	MEDAL_SKIN_STAFF_CD = 5,--换肤有效期CD(CD期间对绑定的目标免费换肤)
	MEDAL_SKIN_STAFF_DAMAGE = 88,--撒币伤害
	--时空法杖
	MEDAL_SPACE_STAFF_MAXUSES = 1000,--耐久(饱食度上限)
	MEDAL_SPACE_STAFF_MAXVALUE = 200,--空间之力上限
	MEDAL_SPACE_STAFF_ADDVALUE = 20*gain_mult,--单颗沙之石可补充的空间之力
	
	------------------------------书籍---------------------------------
	--书籍作用范围
	BOOK_SACRIFICE_RADIUS = 5,--献祭范围(未解之谜,怪物图鉴,植物图鉴)
	BOOK_NORMAL_RADIUS = 10,--作用范围(不朽之谜、陷阱重置册、智能陷阱制作手册)
	--书籍耐久
	BOOK_MAXUSES={
		CLOSED = 5,--无字天书
		IMMORTAL = 1,--不朽之谜
		MONSTER = 1,--怪物图鉴
		UNSOLVED = 1,--未解之谜
		TRAPRESET = 10*gain_mult,--陷阱重置册
		AUTOTRAP = 2,--智能陷阱制作手册
		DICTIONARY = 10,--新华字典
		PLANT = 1,--植物图鉴
	},
	UNSOLVED_ITEM_CHANCE_MULT = gain_mult,--未解之谜信物权重加成倍率
	XINHUA_DICTIONARY_HEALTH_LOSE = -20*consume_mult,--新华字典额外扣除血量
	--无字天书
	CLOSED_BOOK_SPECIAL_RATE = 0.02,--触发奇遇概率
	CLOSED_BOOK_GOLDNUGGET_NUM = 50,--生成黄金数量
	CLOSED_BOOK_SEEDS_NUM = 40,--生成种子数量
	
	------------------------------食物---------------------------------
	MEDAL_SAME_OLD_MULTIPLIERS={1},--食物记忆
	--不朽果实
	IMMORTAL_FRUIT_HEALTHVALUE = 100,--血量
	IMMORTAL_FRUIT_SANITYVALUE = 100,--精神
	IMMORTAL_FRUIT_HUNGERVALUE = 100,--饱食度
	IMMORTAL_FRUIT_DALAYDAMAGE_MULT = 1,--1血量抵抗多少时之伤
	IMMORTAL_FRUIT_VARIATION_ROOT = {--不朽果实变异权重表
		{key="medal_fruit_tree_immortal_fruit_scion",weight=1},--不朽果实接穗
		{key="immortal_fruit",weight=1},--不朽果实
		{key="immortal_fruit_seed",weight=6},--不朽种子
	},
	--曼德拉果
	MANDARK_BERRY_SPAWNER_TIME = 25,--曼德拉果生成时间
	MANDARK_BERRY_SPAWNER_TIME_VARIANCE = 10,--曼德拉果生成时间偏差
	MANDRAKEBERRY_HEALTHVALUE = -1,--血量
	MANDRAKEBERRY_SANITYVALUE = -5,--精神
	MANDRAKEBERRY_HUNGERVALUE = TUNING.CALORIES_TINY,--饱食度,和浆果一样75/8
	MANDRAKEBERRY_SEED_CHANCE ={--种子掉落概率
		MANDRAKE_CONMON = 0.05*chance_mult,--曼德拉,常规
		MANDRAKE_LESS = 0.02*chance_mult,--曼德拉,少
		WEED_CONMON = 0.2*chance_mult,--杂草,常规
		WEED_LESS = 0.05*chance_mult,--杂草,少
		WEED_TINY = 0.03*chance_mult,--杂草,稀少
	},
	--瓶装灵魂
	KRAMPUS_SOUL_DROP_RATE = .05*chance_mult,--坎普斯之灵掉率
	KRAMPUS_SOUL_LIFETIME = 20,--坎普斯之灵存在时间
	BOTTLED_SOUL_HEALTHVALUE = 30,--血量
	BOTTLED_SOUL_SANITYVALUE = -10,--精神
	--瓶装月光
	BOTTLED_MOONLIGHT_HEALTHVALUE = 10,--血量
	BOTTLED_MOONLIGHT_SANITYVALUE = 100,--精神
	BOTTLED_RETURN_RATE = 0.5,--空瓶子返还概率
	
	------------------------------衣物---------------------------------
	--羊角帽
	GOATHAT_HEALTH_RECOVERY = 10,--血量最大恢复量
	GOATHAT_PERISHTIME = total_day_time*5*gain_mult,--耐久
	GOATHAT_CONSUME = -total_day_time*0.15,--被劈一次消耗耐久
	GOATHAT_ADDUSE = total_day_time*gain_mult,--单次补充耐久
	JELLY_POWDER_CHARGE_NUM=3,--果冻粉单次充电消耗量
	GOATHAT_SPEED_MULTIPLE = 1.2,--电击BUFF加速倍数
	GOATHAT_BULEPRINT_CHANCE_NOMAL = 0.05*chance_mult,--羊角帽蓝图掉率(普通电羊)
	GOATHAT_BULEPRINT_CHANCE_CHARGED = 0.5*chance_mult,--羊角帽蓝图掉率(带电电羊)
	--羽绒服
	DOWN_FILLED_COAT_INSULATION = seg_time*9999,--保温效果
	DOWN_FILLED_COAT_PERISHTIME = total_day_time*20,--耐久
	DOWN_FILLED_COAT_MEDAL_PERISHTIME = total_day_time*5,--羽绒勋章耐久
	DOWN_FILLED_COAT_ADDUSE = total_day_time*2*gain_mult,--每根鸭毛可补充耐久
	DOWN_FILLED_COAT_CONSUME = 20,--每回1度额外消耗
	--蓝晶帽
	HAT_BLUE_CRYSTAL_INSULATION = seg_time*9999,--保温效果
	HAT_BLUE_CRYSTAL_PERISHTIME = total_day_time*20,--耐久
	HAT_BLUE_CRYSTAL_MEDAL_PERISHTIME = total_day_time*5,--蓝晶勋章耐久
	HAT_BLUE_CRYSTAL_ADDUSE = total_day_time*2*gain_mult,--每个蓝曜石可补充耐久
	HAT_BLUE_CRYSTAL_CONSUME = 20,--每回1度额外消耗
	--黑曜石甲
	ARMOR_MEDAL_OBSIDIAN = wilson_health * 9*multiplayer_armor_durability_modifier,--护甲值945
	ARMOR_MEDAL_OBSIDIAN_ABSORPTION = 0.85*multiplayer_armor_absorption_modifier,--护甲效果85%
	ARMOR_MEDAL_OBSIDIAN_BURN_RATE = 0.1,--被攻击时让对方燃烧的概率
	--蓝曜石甲
	ARMOR_BLUE_CRYSTAL = wilson_health * 15*multiplayer_armor_durability_modifier,--护甲值1575
	ARMOR_BLUE_CRYSTAL_ABSORPTION = 0.9*multiplayer_armor_absorption_modifier,--护甲效果90%
	ARMOR_BLUE_CRYSTAL_FREEZE_RATE = 0.1,--被攻击时冰冻对方的概率
	
	-----------------------------建筑---------------------------------
	--黑/蓝曜石火坑
	OBSIDIANFIREPIT_RAIN_RATE = 2,--下雨时的燃料消耗速度
	OBSIDIANFIREPIT_FUEL_MAX = (night_time+dusk_time)*3,--最大燃烧时长
	OBSIDIANFIREPIT_FUEL_START = night_time+dusk_time,--默认燃烧时长
	OBSIDIANFIREPIT_BONUS_MULT = 3,--添加燃料的效率
	--黑/蓝耀石火坑的照明半径
	OBSIDIANLIGHT_RADIUS_1 = 4,--第一档，普通火坑为2
	OBSIDIANLIGHT_RADIUS_2 = 8,--第二档，普通火坑为3
	OBSIDIANLIGHT_RADIUS_3 = 12,--第三档，普通火坑为4
	OBSIDIANLIGHT_RADIUS_4 = 14,--第四档，普通火坑为5
	--树根宝箱
	LIVINGROOT_CHEST_ADDNUM = 1*gain_mult,--单个肥料包可增加的肥料值
	LIVINGROOT_CHEST_BIG_NEED = 14,--升到50格所需肥料包数8
	LIVINGROOT_CHEST_MID_NEED = 6,--升到25格所需肥料包数4
	LIVINGROOT_CHEST_SMALL_NEED = 2,--升到16格所需肥料包数2
	--船上钓鱼池
	SEAPOND_BLUEPRINT_CHANCE = 0.05*chance_mult,--蓝图掉率
	SEAPOND_MAX_NUM = 10,--船上钓鱼池的最大容量
	SEAPOND_MAX_BAIT_FORCE = 10,--船上钓鱼池的最大饵力值
	SEAPOND_FISH_RESPAWN_TIME = seg_time*3*condition_mult,--船上钓鱼池刷新时长3个时段
	SEAPOND_SEASON_FISH_CHANCE = 0.05,--时令鱼概率
	--黑曜石锅
	PORTABLE_COOK_POT_TIME_MULTIPLIER = 0.6,--烹饪时间系数
	--育王蜂箱
	MEDAL_BEEBOX_BEES = 3,--育王蜂箱蜜蜂容量
	MEDAL_BEE_COLLECTCOUNT = 5,--育王蜂需要采摘的花朵数量(实际数量=这里的数量+1)
	--手摇深井泵
	WATERPUMP_WATERLOSS_TIME = day_time,--手摇深井泵水流失时间5分钟(多久不用就需要重新加水)
	--虚空钓鱼池
	SPACETIME_POND_MAX_NUM = 20,--最大容量
	SPACETIME_POND_EXISTENCE_TIME = total_day_time*2,--存在时间
	
	------------------------------礼物---------------------------------
	--遗失包裹
	LOST_BAG_DROP_RATE = 0.1*chance_mult, --遗失包裹掉率
	LOST_BAG_GOOD_DROP_RATE = .5*chance_mult,--稀有道具掉率
	SURPRISE_DROP_RATE = 0.01,--神秘礼物掉率
	--藏宝图
	MEDAL_TOY_CHEST_CHANCE = ise and 1/2 or 1/3,--藏宝图挖出玩具箱概率
	SURPRISE_TREASURE_CHANCE = 0.01,--神秘宝藏概率
	SURPRISE_TREASURE_BETTER_CHANCE = 0.005,--较好的神秘宝藏概率
	SURPRISE_TREASURE_BEST_CHANCE = 0.0025,--最好的神秘宝藏概率

	MEDAL_TREASURE_SIGN_TIME = 60,--宝藏标记持续时间
	
	BUNDLE_VALUE_DISCOUNT = ise and 1 or 0.9,--打包纸价值继承倍率
	
	-----------------------------BUFF---------------------------------
	--电击
	MEDAL_BUFF_ELECTRICATTACK_DURATION = day_time,--时长,5分钟
	--加速
	MEDAL_BUFF_QUICKLOCOMOTOR_DURATION = total_day_time,--8分钟
	QUICKLOCOMOTOR_MULTIPLE = 1.5,--加速倍数
	--精神保护
	MEDAL_BUFF_SANITYREGEN_DURATION = day_time,--5分钟
	MEDAL_BUFF_SANITYREGEN_ABSORB = 0.2,--精神保护效果比例
	--吸血
	MEDAL_BUFF_SUCKINGBLOOD_DURATION = day_time,--5分钟
	MEDAL_BUFF_SUCKINGBLOOD_GOO_CONSUME = 60,--抵御血蜜消耗时长
	MEDAL_BUFF_SUCKINGBLOOD_GESTALT_CONSUME = 30,--抵御时空虚影消耗时长
	--凝血
	MEDAL_BUFF_BLOODSUCKING_DURATION = day_time,--5分钟
	MEDAL_BUFF_BLOODSUCKING_ABSORB = 0.5,--减伤效果比例
	--灵魂跳跃
	MEDAL_BUFF_FREEBLINK_DURATION = day_time,--5分钟
	--月光
	MEDAL_BUFF_TRANSPLANTABLE_DURATION = night_time+dusk_time,--3分钟
	--饱腹
	MEDAL_BUFF_ASSUAGEHUNGER_DURATION = total_day_time,--8分钟
	ASSUAGEHUNGER_MULTIPLE = 0.2,--饥饿速度
	--吃屎
	MEDAL_BUFF_POOPFOOD_DURATION = day_time,--5分钟
	POOPFOOD_SANITY_CONSUME = -15,--吃屎扣san
	--开胃
	MEDAL_BUFF_UPAPPETITE_DURATION = day_time,--5分钟
	UPAPPETITE_HUNGER_CONSUME = -5,--吃开胃料理降饱食度
	--霸体
	MEDAL_BUFF_NOSTIFF_DURATION = total_day_time,--8分钟
	--强壮
	MEDAL_BUFF_STRONG_DURATION = day_time,--5分钟
	--虚弱(易伤)
	MEDAL_BUFF_WEAK_DURATION = 60,--1分钟
	MEDAL_BUFF_WEAK_MULTIPLE = 1.2,--虚弱效果伤害加成比例
	--群伤
	MEDAL_BUFF_AOECOMBAT_DURATION = day_time,--5分钟
	MEDAL_BUFF_AOECOMBAT_VALUE = 200,--群伤层数
	MEDAL_BUFF_AOECOMBAT_DAMAGE_MULT = .5,--群伤伤害系数
	--蜂毒(流血DEBUFF)
	MEDAL_BUFF_INJURED_DURATION = 60,--1分钟
	MEDAL_BUFF_INJURED_DAMAGE = -1,--每层蜂毒每秒造成的伤害
	MEDAL_BUFF_INJURED_MAX = 10*consume_mult,--蜂毒层数上限
	--血蜜标记
	MEDAL_BUFF_BLOODHONEYMARK_DURATION = 60,--1分钟
	MEDAL_BUFF_BLOODHONEYMARK_MAX = 20*consume_mult,--血蜜标记层数上限
	--萎靡
	MEDAL_BUFF_MALAISE_DURATION = 120,--2分钟
	MEDAL_BUFF_MALAISE_MULTIPLE = 0.8,--萎靡状态伤害比例
	--毒伤标记
	MEDAL_BUFF_POISONMARK_DURATION = 5,--5秒
	MEDAL_BUFF_POISONMARK_MAX = 20,--毒伤标记层数上限
	--鱼人诅咒
	BUFF_MEDAL_MERMCURSE_DURATION = total_day_time,--8分钟
	MEDAL_BUFF_MERMCURSE_MAX = 10,--毒伤标记层数上限
	--天道酬勤
	MEDAL_BUFF_REWARDTOILER_MARK_DURATION = total_day_time,--8分钟
	MEDAL_BUFF_REWARDTOILER_MARK_MAX = 3*gain_mult,--层数上限(相当于1天内触发3次天道酬勤的奖励)
	
	-----------------------------嫁接---------------------------------
	--接穗掉率
	SCION_BANANA_CHANCE = 0.25*chance_mult,--香蕉接穗概率
	SCION_COMMON_CHANCE = 1/10*chance_mult,--常见蔬果掉率
	SCION_UNCOMMON_CHANCE = 1/15*chance_mult,--不常见蔬果掉率
	SCION_RARE_CHANCE = 1/20*chance_mult,--稀有蔬果掉率
	SCION_COMMON_CHANCE_SEASON_PUT = 1/8*chance_mult,--常见蔬果应季掉率(塞种子)
	SCION_UNCOMMON_CHANCE_SEASON_PUT = 1/10*chance_mult,--不常见蔬果应季掉率(塞种子)
	SCION_RARE_CHANCE_SEASON_PUT = 1/15*chance_mult,--稀有蔬果应季掉率(塞种子)
	
	SCION_LOSE_LIVINGLOG_CHANCE = 0.2*consume_mult,--种子塞入活木失败时消耗活木的概率
	
	MEDALDUG_FRUIT_TREE_STUMP_CHANCE = 1/3*chance_mult,--月亮蘑菇挖出砧木桩概率
	
	-----------------------------生物---------------------------------
	--熔岩鳗鱼
	MEDAL_PERISH_SUPERFAST = 5*total_day_time,--存活时间
	LAVAEEL_HEALTHVALUE = 3,--直接吃的血量
	LAVAEEL_RESPAWN_TIME = 3*total_day_time,--重生时间
	LAVAEEL_MAX_NUM = 10,--岩浆池的最大容量
	
	--暗夜坎普斯
	MEDAL_RAGE_KRAMPUS_HEALTH = 6666,--血量
	MEDAL_RAGE_KRAMPUS_DAMAGE = 88,--50,--伤害
	MEDAL_RAGE_KRAMPUS_ATTACK_PERIOD = 1,--1.2,--攻击频率
	MEDAL_RAGE_KRAMPUS_SPEED = 9,--速度
	RAGE_KRAMPUS_SOUL_LIFETIME = 60,--暴怒之灵存在时间
	RAGE_KRAMPUS_CALL_RATE = 0.2,--暗夜坎普斯召唤概率

	--复仇坎普斯
	MEDAL_NAUGHTY_KRAMPUS={
		HEALTH = 300,--初始血量
		HEALTH_ADD = 5,--血量增量/单次
		HEALTH_MAX = 1000,--血量上限
		DAMAGE= 50,--初始伤害
		DAMAGE_ADD = 1,--伤害增量/5次
		DAMAGE_MAX = 100,--伤害上限
		ABSORPTION_ADD = 0.01,--减伤增量/10次
		ABSORPTION_MAX = 0.5,--减伤上限
		ATTACK_PERIOD = 1.2,--攻击频率
		SPEED = 8,--速度
	},
	
	--凋零之蜂
	MEDAL_BEEQUEEN_HEALTH = 23333,--血量
	MEDAL_BEEQUEEN_DAMAGE = 233,--伤害
	MEDAL_BEEQUEEN_ATTACK_PERIOD = 2,--攻击频率
	MEDAL_BEEQUEEN_SPEED = 5,--移速
	MEDAL_BEEQUEEN_FOCUSTARGET_CD = {0,24,16,8},--集火攻击目标的CD(等于0的时候不能集火，集火期间小蜂会炸毛)
	MEDAL_BEEQUEEN_SPAWNGUARDS_CD = {16,12,7,9},--生成蜜蜂守卫的CD
	MEDAL_BEEQUEEN_SPAWNGUARDS_CHAIN = {0,1,2,3},--可连续生成守卫的次数(为0的时候生成一波守卫就开始CD了，为1则可以生成两波才开始CD，以此类推)
	MEDAL_BEEQUEEN_TOTAL_GUARDS = 8,--守卫数量最小阈值
	MEDAL_BEEQUEEN_MIN_GUARDS_PER_SPAWN = 4,--单次最小生成守卫数量
	MEDAL_BEEQUEEN_MAX_GUARDS_PER_SPAWN = 10,--单次最大生成守卫数量
	MEDAL_BEEQUEEN_HIT_RECOVERY = 1,--攻击冷却时间
	MEDAL_BEEQUEEN_DODGE_SPEED = 7,--闪避速度
	MEDAL_BEEQUEEN_DODGE_HIT_RECOVERY = 2,--闪避时的攻击冷却时间
	MEDAL_BEEQUEEN_SCARE_JUSTICE_VALUE = 5,--嘶吼消耗正义值
	MEDAL_BEEQUEEN_EXTRA_DAMAGE_MULT = consume_mult,--额外伤害倍率
	MEDAL_HONEY_TRAIL_DAMAGE = -2*consume_mult,--血蜜小径每0.5造成的伤害
	--堕落之蜂
	MEDAL_BEEGUARD_HEALTH = ise and 233 or 666,--血量
	MEDAL_BEEGUARD_DAMAGE = 33,--伤害
	MEDAL_BEEGUARD_PUFFY_DAMAGE = 66,--炸毛后伤害
	MEDAL_BEEGUARD_SPEED = 4,--移速
	MEDAL_BEEGUARD_DASH_SPEED = 9,--冲刺速度(炸毛状态)
	MEDAL_BEEGUARD_ATTACK_PERIOD = 2,--攻击频率
	MEDAL_BEEGUARD_PUFFY_ATTACK_PERIOD = 1.5,--炸毛后攻击频率
	MEDAL_BEEGUARD_GUARD_RANGE = 4,--警戒距离
	MEDAL_BEEGUARD_ATTACK_RANGE = 1.5,--伤害范围
	MEDAL_BEEGUARD_EXTRA_DAMAGE_MULT = consume_mult,--额外伤害倍率
	MEDAL_BEEGUARD_DRINK_BLOOD_MULT = consume_mult,--吸血倍率
	MEDAL_BEEGUARD_MARK_CONSUME = ise and 5 or 3,--爆浆时把玩家黏住所需的血蜜标记层数

	--时空吞噬者
	MEDAL_SPACETIME_DEVOURER_HEALTH = 27182,--血量
	MEDAL_SPACETIME_DEVOURER_WALL_CD = 20,--召唤时空之塔的CD
	MEDAL_SPACETIME_DEVOURER_CALL_CD = 120,--召集玩家的CD
	MEDAL_SPACETIME_DEVOURER_CAST_RANGE = 30,--攻击距离
	MEDAL_SPACETIME_MAX_ATTACK_PERIOD = 3,--最慢攻速(初始攻速)
	MEDAL_SPACETIME_MIN_ATTACK_PERIOD = 1.5,--最快攻速
	MEDAL_SPACETIME_SPEED_UP = -.2,--攻速提升速度(攻击提速)
	MEDAL_SPACETIME_SLOW_DOWN = .1,--攻击降低速度(喂食降速，每50饱食度0.1)
	MEDAL_SPACETIME_DEVOURER_RAGE_TIME_INITIAL = 1*total_day_time,--初始生气时长(多久不喂食会生气)
	MEDAL_SPACETIME_DEVOURER_SPAWN_MAX = 10*gain_mult,--时空碎片产出上限
	MEDAL_SINKHOLE_DELAY_DAMAGE = 30*consume_mult,--时空塌陷的时之伤
	--时空灵石/零食
	MEDAL_SPACETIME_LINGSHI_HUNGER = ise and 1024 or 520,--时空灵石回复量
	MEDAL_SPACETIME_SNACKS_HUNGER = 2333*gain_mult,--时空零食回复量
	--时空乱流
	MEDAL_SPACETIME_SPARK_WORKLEFT = 5,--捕捉次数
	MEDAL_SPACETIME_SPARK_DAMAGE = 30,--伤害
	MEDAL_SPACETIME_SPARK_DELAY_DAMAGE = 30*consume_mult,--时之伤
	MEDAL_SPACETIME_SPARK_SPAWN_RANGE = 60,--生成范围(离时空吞噬者的距离)
	MEDAL_SPACETIME_SPARK_PERISH_TIME = total_day_time*0.5,--存在时间
	--时空虚影
	MEDAL_GESTALT_ATTACK_COOLDOWN = 3,--攻击频率
	MEDAL_GESTALT_ATTACK_RANGE = 5,--攻击距离
	MEDAL_GESTALT_DAMAGE = 24,--伤害
	MEDAL_GESTALT_DELAY_DAMAGE = 24*consume_mult,--时之伤
	MEDAL_GESTALT_ATTACK_HIT_RANGE_SQ = 2,--命中范围
	-- MEDAL_GESTALT_SPAWN_TIME = 5,--生成周期
	-- MEDAL_GESTALT_SPAWN_TIME_RAND = 10,--生成周期随机数(5~15秒)
	MEDAL_GESTALT_RELOCATED_FAR_DIST = 25,--离玩家的最远距离
	--时空晶矿
	MEDAL_SPACETIME_GLASS_MINE = 24,--挖掘次数
	MEDAL_SPACETIME_GLASS_TIME_MIN = 10,--最小存在时间(秒)
	MEDAL_SPACETIME_GLASS_TIME_MAX = 30,--最大存在时间(秒)
	MEDAL_SPACETIME_GLASS_DAMAGE = 30,--时空晶矿爆炸伤害
	MEDAL_SPACETIME_GLASS_DELAY_DAMAGE = 30*consume_mult,--时空晶矿爆炸时之伤
	--预言水晶球
	MEDAL_SPACETIME_CRYSTALBALL_MAXUSES = 100,--耐久上限
	MEDAL_SPACETIME_CRYSTALBALL_USE1 = 3,--普通预言消耗
	MEDAL_SPACETIME_CRYSTALBALL_USE2 = 5,--预言宝藏位置消耗
	MEDAL_SPACETIME_LINGSHI_ADDUSE = 10*gain_mult,--时空灵石可补充的耐久
	MEDAL_TIME_SLIDER_ADDUSE = 30*gain_mult,--时空碎片可补充的耐久
	--时空之刺
	MEDAL_SANDSPIKE = {
		HEALTH = {--生命
        	SHORT = 200,
        	MED = 300,
        	TALL = 400,
        	BLOCK = 1000,
    	},
    	DAMAGE = {--伤害
        	SHORT = 100,
        	MED = 150,
        	TALL = 200,
        	BLOCK = 0,
    	},
		DELAY_DAMAGE = {--时之伤
			SHORT = ise and 30 or 50,
        	MED = ise and 40 or 75,
        	TALL = ise and 50 or 100,
        	BLOCK = 0,
		},
    	LIFETIME = {--消失时间
        	SHORT = { 6, 7 },
        	MED = { 7, 8 },
        	TALL = { 8, 10 },
        	BLOCK = { 58, 59 },
    	},
	},
	--时空尘蛾
	MEDAL_DUSTMOTH={
		HEALTH = 200,--血量
        HEALTH_REGEN = 4,--每秒回血
        WALK_SPEED = 2.6,--移速
        DUSTABLE_RESET_TIME = seg_time * 2,--目标是否可打扫的时间间隔(远古档案馆里的乱七八糟的建筑都能被打扫，打扫后会暂时移除可打扫标签)
        DUSTABLE_RESET_TIME_VARIANCE = seg_time,--打扫间隔方差
        DUSTOFF_COOLDOWN = 4,--打扫CD
        DUSTOFF_COOLDOWN_VARIANCE = 6,--打扫CD方差
        SEARCH_ANIM_COOLDOWN = 12,--搜索动画CD
	},
	--时空尘蛾窝
	MEDAL_DUSTMOTHDEN_REPAIR_TIME = total_day_time * 0.75,--打扫完毕需要的时间
    MEDAL_DUSTMOTHDEN_REGEN_TIME = total_day_time * 10,--时空尘蛾复活周期
    MEDAL_DUSTMOTHDEN_RELEASE_TIME = seg_time,--出窝周期
    MEDAL_DUSTMOTHDEN_MAX_CHILDREN = 1,--每个窝最多可有多少只
    MEDAL_DUSTMOTHDEN_MAXWORK = 5,--镐击次数

	-----------------------------事件---------------------------------
	SPACETIMESTORM_SPEED_MOD = .4,--玩家在时空风暴中的移速
	MEDAL_DELAY_DAMAGE_MIN = 5,--时之伤单次伤害下限
	MEDAL_DELAY_DAMAGE_MAX = 30,--时之伤单次伤害上限
	REWARD_TOILER_CHANCE = 0.02,--触发天道酬勤事件的概率
}

--加入花样风滚草
TUNING.TUMBLEWEED_RESOURCES_EXPAND=TUNING.TUMBLEWEED_RESOURCES_EXPAND or {}
if TUNING.MEDAL_GOODMAX_RESOURCES_MULTIPLE > 0 then
	TUNING.TUMBLEWEED_RESOURCES_EXPAND.functional_medal_goodmax_resources={
		resourcesList={
			{chance=0.01,	item="spices_box",announce=true},--调料盒
			{chance=0.02,	item="medal_waterpump_item",announce=true},--深井泵套件
			{chance=0.03,	item="medal_farm_plow_item",announce=true},--高效耕地机
			{chance=0.01,	item="mandrake_seeds",announce=true},--曼德拉种子
			{chance=0.01,	item="bottled_moonlight",announce=true},--瓶装月光
			{chance=0.05,	item="medal_moonglass_shovel",announce=true},--月光铲
			{chance=0.05,	item="medal_moonglass_hammer",announce=true},--月光锤
			{chance=0.05,	item="medal_moonglass_bugnet",announce=true},--月光网
			{chance=0.05,	item="medal_moonglass_potion",announce=true},--月光药水
			{chance=0.02,	item="lureplant_rod",announce=true},--食人花手杖
			{chance=0.02,	item="immortal_book",announce=true},--不朽之谜
			{chance=0.005,	item="immortal_fruit_seed",announce=true},--不朽种子
			{chance=0.003,	item="immortal_fruit",announce=true},--不朽果实
			{chance=0.001,	item="immortal_fruit_oversized",announce=true},--巨型不朽果实
			{chance=0.0005,	item="immortal_gem",announce=true},--不朽宝石
			{chance=0.01,	item="medal_time_slider",announce=true},--时空碎片
			{chance=0.0005,	item="medal_space_gem",announce=true},--时空宝石
			{chance=0.0008,	item="devour_staff",announce=true},--吞噬法杖
			{chance=0.0004,	item="immortal_staff",announce=true},--不朽法杖
			{chance=0.0001,	item="medal_krampus_chest_item",announce=true},--坎普斯宝匣
			{chance=0.002,	item="medal_naughtybell",announce=true},--淘气铃铛
			{chance=0.008,	item="down_filled_coat",announce=true},--羽绒服
			{chance=0.008,	item="hat_blue_crystal",announce=true},--蓝晶帽
			{chance=0.01,	item="monster_book",announce=true},--怪物图鉴
			{chance=0.008,	item="unsolved_book",announce=true},--未解之谜
			{chance=0.008,	item="autotrap_book",announce=true},--智能陷阱制作手册
			{chance=0.05,	item="sanityrock_fragment",announce=true},--方尖碑碎片
			{chance=0.004,	item="sanityrock_mace",announce=true},--方尖锏
			{chance=0.0005,	item="meteor_staff",announce=true},--流星法杖
			{chance=0.03,	item="armor_blue_crystal",announce=true},--蓝曜石甲
			{chance=0.06,	item="armor_medal_obsidian",announce=true},--黑曜石甲
			{chance=0.06,	item="krampus_soul",announce=true},--坎普斯之灵
			{chance=0.02,	item="bottled_soul",announce=true},--瓶装灵魂
			{chance=0.005,	item="rage_krampus_soul",announce=true},--黑暗灵魂
			{chance=0.01,	item="medal_treasure_map",announce=true},--藏宝图
			{chance=0.05,	item="medal_treasure_map_scraps1",announce=true},--藏宝图碎片·日出
			{chance=0.05,	item="medal_treasure_map_scraps2",announce=true},--藏宝图碎片·黄昏
			{chance=0.05,	item="medal_treasure_map_scraps3",announce=true},--藏宝图碎片·夜晚
			{chance=0.02,	item="medal_ammo_box",announce=true},--弹药盒
			{chance=0.0001,	item="medal_withered_heart",announce=true},--凋零之心
			{chance=0.008,	item="medal_bee_larva",announce=true},--育王蜂种
			{chance=0.06,	item="medal_goathat",announce=true},--羊角帽
		},
		multiple=TUNING.MEDAL_GOODMAX_RESOURCES_MULTIPLE,
		weightClass="goodMax",
	}
	--接穗
	for k, v in pairs(require("medal_defs/medal_fruit_tree_defs").MEDAL_FRUIT_TREE_DEFS) do
		if v.switch then
			table.insert(TUNING.TUMBLEWEED_RESOURCES_EXPAND.functional_medal_goodmax_resources.resourcesList, {chance=0.01,item=v.name.."_scion",announce=true})
		end
	end
	--调料
	for k, v in pairs(require("medal_defs/medal_spice_defs")) do
		table.insert(TUNING.TUMBLEWEED_RESOURCES_EXPAND.functional_medal_goodmax_resources.resourcesList, {chance=0.1,item=k,announce=true})
	end
	--遗失塑料袋
	for k, v in pairs(require("medal_defs/medal_bundle_defs")) do
		table.insert(TUNING.TUMBLEWEED_RESOURCES_EXPAND.functional_medal_goodmax_resources.resourcesList, {chance=0.08,item=k,announce=true})
	end
	--弹药
	for k, v in pairs(require("medal_defs/medal_slingshotammo_defs")) do
		table.insert(TUNING.TUMBLEWEED_RESOURCES_EXPAND.functional_medal_goodmax_resources.resourcesList, {chance=0.08,item=k,announce=true})
	end
	--移植植株
	for k, v in pairs(require("medal_defs/medal_plantable_defs")) do
		table.insert(TUNING.TUMBLEWEED_RESOURCES_EXPAND.functional_medal_goodmax_resources.resourcesList, {chance=0.1,item=v.name,season=1,announce=true})
	end
	
	TUNING.TUMBLEWEED_RESOURCES_EXPAND.functional_medal_badmax_resources={
		resourcesList={
			{chance=0.008,	item="medal_rage_krampus",announce=true,aggro=true},--暗夜坎普斯
			{chance=0.001,	item="medal_beequeen",announce=true,aggro=true},--凋零之蜂
		},
		multiple=TUNING.MEDAL_GOODMAX_RESOURCES_MULTIPLE,
		weightClass="badMax",
	}
end

if TUNING.MEDAL_GOODMID_RESOURCES_MULTIPLE > 0 then
	TUNING.TUMBLEWEED_RESOURCES_EXPAND.functional_medal_goodmid_resources={
		resourcesList={
			{chance=0.3,	item="medal_fishbones"},--鱼骨
			{chance=0.1,	item="medal_box"},--勋章盒
			{chance=0.15,	item="marbleaxe"},--大理石斧头
			{chance=0.15,	item="marblepickaxe"},--大理石镐子
			{chance=0.08,	item="medal_rain_bomb"},--催雨弹
			{chance=0.08,	item="medal_clear_up_bomb"},--放晴弹
			{chance=0.3,	item="toil_money"},--血汗钱
			{chance=0.3,	item="mandrakeberry"},--曼德拉果
			{chance=0.05,	item="xinhua_dictionary"},--新华字典
			-- {chance=0.2,	item="closed_book"},--无字天书
			{chance=0.1,	item="trapreset_book"},--陷阱重置册
			{chance=0.1,	item="immortal_essence"},--不朽精华
			{chance=0.1,	item="medal_monster_essence"},--怪物精华
			{chance=0.1,	item="medal_tentaclespike"},--活性触手尖刺
			{chance=0.2,	item="trap_bat"},--蝙蝠陷阱
			{chance=0.15,	item="lavaeel"},--熔岩鳗鱼
			{chance=0.1,	item="medal_obsidian"},--黑曜石
			{chance=0.05,	item="medal_blue_obsidian"},--蓝曜石
			{chance=0.1,	item="medal_resonator_item"},--宝藏探测仪
			{chance=0.1,	item="medal_fishingrod"},--玻璃钓竿
		},
		multiple=TUNING.MEDAL_GOODMID_RESOURCES_MULTIPLE,
		weightClass="goodMid",
	}
end