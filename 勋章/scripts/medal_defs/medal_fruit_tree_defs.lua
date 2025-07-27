--接穗掉率(普通概率,季节加成塞入概率)
local common_loot={TUNING_MEDAL.SCION_COMMON_CHANCE,TUNING_MEDAL.SCION_COMMON_CHANCE_SEASON_PUT}--常见
local uncommon_loot={TUNING_MEDAL.SCION_UNCOMMON_CHANCE,TUNING_MEDAL.SCION_UNCOMMON_CHANCE_SEASON_PUT}--不常见
local rare_loot={TUNING_MEDAL.SCION_RARE_CHANCE,TUNING_MEDAL.SCION_RARE_CHANCE_SEASON_PUT}--稀有
--产出数量概率表(key为产出数量,value为概率)
local common_productlist={0.05,0.15,0.55,0.25}--常见
local uncommon_productlist={0.1,0.2,0.5,0.2}--不常见
local rare_productlist={0.2,0.3,0.4,0.1}--稀有
local banana_productlist={0.2,0.6,0.2}--香蕉
local immortal_productlist={0.55,0.33,0.1,0.02}--不朽果实

--定义果树数据
local MEDAL_FRUIT_TREE_DEFS={
	{--胡萝卜
		switch=true,--开关，控制是否加入
		name="medal_fruit_tree_carrot",--预制物名
		build="medal_fruit_tree_carrot",--动画
		product="carrot",--果实
		productlist=common_productlist,--收获数量概率表,key为数量,value为概率
		growtime=TUNING.CAVE_BANANA_GROW_TIME,--生长时间
		seasonlist={autumn = true,	winter = true,	spring = true				 },--生长季节
		scion_chance=common_loot,--接穗掉率表
	},
	{--石榴
		switch=true,
		name="medal_fruit_tree_pomegranate",
		build="medal_fruit_tree_pomegranate",
		product="pomegranate",
		productlist=rare_productlist,
		growtime=TUNING.CAVE_BANANA_GROW_TIME,
		seasonlist={								spring = true,	summer = true},
		scion_chance=rare_loot,
	},
	{--辣椒
		switch=true,
		name="medal_fruit_tree_pepper",
		build="medal_fruit_tree_pepper",
		product="pepper",
		productlist=rare_productlist,
		growtime=TUNING.CAVE_BANANA_GROW_TIME,
		seasonlist={autumn = true,									summer = true},
		scion_chance=rare_loot,
	},
	{--大蒜
		switch=true,
		name="medal_fruit_tree_garlic",
		build="medal_fruit_tree_garlic",
		product="garlic",
		productlist=rare_productlist,
		growtime=TUNING.CAVE_BANANA_GROW_TIME,
		seasonlist={autumn = true,	winter = true,	spring = true,	summer = true},
		scion_chance=rare_loot,
	},
	{--火龙果
		switch=true,
		name="medal_fruit_tree_dragonfruit",
		build="medal_fruit_tree_dragonfruit",
		product="dragonfruit",
		productlist=rare_productlist,
		growtime=TUNING.CAVE_BANANA_GROW_TIME,
		seasonlist={								spring = true,	summer = true},
		scion_chance=rare_loot,
	},
	{--香蕉
		switch=true,
		name="medal_fruit_tree_banana",
		build="medal_fruit_tree_banana",
		product="cave_banana",
		productlist=banana_productlist,
		growtime=TUNING.CAVE_BANANA_GROW_TIME,
		seasonlist={autumn = true,					spring = true,	summer = true},
	},
	{--芦笋
		switch=true,
		name="medal_fruit_tree_asparagus",
		build="medal_fruit_tree_asparagus",
		product="asparagus",
		productlist=uncommon_productlist,
		growtime=TUNING.CAVE_BANANA_GROW_TIME,
		seasonlist={				winter = true,	spring = true				 },
		scion_chance=uncommon_loot,
	},
	{--土豆
		switch=true,
		name="medal_fruit_tree_potato",
		build="medal_fruit_tree_potato",
		product="potato",
		productlist=common_productlist,
		growtime=TUNING.CAVE_BANANA_GROW_TIME,
		seasonlist={autumn = true,	winter = true,	spring = true				},
		scion_chance=common_loot,
	},
	{--洋葱
		switch=true,
		name="medal_fruit_tree_onion",
		build="medal_fruit_tree_onion",
		product="onion",
		productlist=rare_productlist,
		growtime=TUNING.CAVE_BANANA_GROW_TIME,
		seasonlist={autumn = true,					spring = true,	summer = true},
		scion_chance=rare_loot,
	},
	{--番茄
		switch=true,
		name="medal_fruit_tree_tomato",
		build="medal_fruit_tree_tomato",
		product="tomato",
		productlist=common_productlist,
		growtime=TUNING.CAVE_BANANA_GROW_TIME,
		seasonlist={autumn = true,					spring = true,	summer = true},
		scion_chance=common_loot,
	},
	{--西瓜
		switch=true,
		name="medal_fruit_tree_watermelon",
		build="medal_fruit_tree_watermelon",
		product="watermelon",
		productlist=uncommon_productlist,
		growtime=TUNING.CAVE_BANANA_GROW_TIME,
		seasonlist={								spring = true,	summer = true},
		scion_chance=uncommon_loot,
	},
	{--南瓜
		switch=true,
		name="medal_fruit_tree_pumpkin",
		build="medal_fruit_tree_pumpkin",
		product="pumpkin",
		productlist=uncommon_productlist,
		growtime=TUNING.CAVE_BANANA_GROW_TIME,
		seasonlist={autumn = true,	winter = true,								 },
		scion_chance=uncommon_loot,
	},
	{--茄子
		switch=true,
		name="medal_fruit_tree_eggplant",
		build="medal_fruit_tree_eggplant",
		product="eggplant",
		productlist=uncommon_productlist,
		growtime=TUNING.CAVE_BANANA_GROW_TIME,
		seasonlist={autumn = true,					spring = true				 },
		scion_chance=uncommon_loot,
	},
	{--玉米
		switch=true,
		name="medal_fruit_tree_corn",
		build="medal_fruit_tree_corn",
		product="corn",
		productlist=common_productlist,
		growtime=TUNING.CAVE_BANANA_GROW_TIME,
		seasonlist={autumn = true,					spring = true,	summer = true},
		scion_chance=common_loot,
	},
	{--榴莲
		switch=true,
		name="medal_fruit_tree_durian",
		build="medal_fruit_tree_durian",
		product="durian",
		productlist=rare_productlist,
		growtime=TUNING.CAVE_BANANA_GROW_TIME,
		seasonlist={								spring = true				 },
		scion_chance=rare_loot,
	},
	{--不朽果实
		switch=true,
		name="medal_fruit_tree_immortal_fruit",
		bank="medal_fruit_tree_immortal_fruit",
		build="medal_fruit_tree_immortal_fruit",
		product="immortal_fruit",
		productlist=immortal_productlist,
		growtime=3*TUNING.CAVE_BANANA_GROW_TIME,--3倍成长周期
		seasonlist={				winter = true,								},
		scion_chance=rare_loot,
		seed="immortal_fruit_seed",--种子名(比较特殊，没有s)
		nomagic=true,--不可催熟
		noburnt=true,--不可燃
		growinwinter=true,--冬季可生长
		skinable=true,--可换皮
		hasdestiny=true,--拥有宿命(塞种子成功率)
	},
	{--幸运果实
		switch=TUNING.LUCKY_TUMBLEWEED_IS_OPEN,
		name="medal_fruit_tree_lucky_fruit",
		build="medal_fruit_tree_lucky_fruit",
		product="lucky_fruit",
		productlist=rare_productlist,
		growtime=TUNING.CAVE_BANANA_GROW_TIME,
		seasonlist={autumn = true,					spring = true				 },
		scion_chance=rare_loot,
	},
}

--接穗掉率表
local MEDAL_FRUIT_TREE_SCION_LOOT={}

for _,v in ipairs(MEDAL_FRUIT_TREE_DEFS) do
	--屏蔽动画还没做好的果树
	--[[
	if v.name~=v.build then
		v.switch=nil
	end
	]]
	--加入接穗掉率表(key种子名)
	if v.switch and v.scion_chance then
		MEDAL_FRUIT_TREE_SCION_LOOT[v.seed or (v.product.."_seeds")]={
			chance=v.scion_chance[1],--默认塞入概率
			product=v.name.."_scion",--对应接穗
			seasonlist=v.seasonlist,--季节列表
			season_chance_put=v.scion_chance[2],--应季塞入概率
			hasdestiny=v.hasdestiny,--宿命
		}
	end
end

return {MEDAL_FRUIT_TREE_DEFS = MEDAL_FRUIT_TREE_DEFS, MEDAL_FRUIT_TREE_SCION_LOOT = MEDAL_FRUIT_TREE_SCION_LOOT}