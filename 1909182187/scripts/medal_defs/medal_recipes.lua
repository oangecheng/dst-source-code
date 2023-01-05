--[[
{
	name,--配方名，一般情况下和需要合成的道具同名
	ingredients,--配方，这边为了区分不同难度的配方，做了嵌套{{正常难度},{简易难度}}，只填一个视为不做难度区分
	tab,--合成栏(已废弃)
	level,--解锁科技
	--placer,--建筑类科技放置时显示的贴图、占位等/也可以配List用于添加更多额外参数，比如不可分解{no_deconstruction = true}
	min_spacing,--最小间距，不填默认为3.2
	nounlock,--不解锁配方，只能在满足科技条件的情况下制作(分类默认都算专属科技站,不需要额外添加了)
	numtogive,--一次性制作的数量，不填默认为1
	builder_tag,--制作者需要拥有的标签
	atlas,--需要用到的图集文件(.xml)，不填默认用images/name.xml
	image,--物品贴图(.tex)，不填默认用name.tex
	testfn,--尝试放下物品时的函数，可用于判断坐标点是否符合预期
	product,--实际合成道具，不填默认取name
	build_mode,--建造模式,水上还是陆地(默认为陆地BUILDMODE.LAND,水上为BUILDMODE.WATER)
	build_distance,--建造距离(玩家距离建造点的距离)
	filters,--制作栏分类列表，格式参考{"SPECIAL_EVENT","CHARACTER"}
	
	--扩展字段
	placer,--建筑类科技放置时显示的贴图、占位等
	filter,--制作栏分类
	description,--覆盖原来的配方描述
	canbuild,--制作物品是否满足条件的回调函数,支持参数(recipe, self.inst, pt, rotation),return 结果,原因
	sg_state,--自定义制作物品的动作(比如吹气球就可以调用吹的动作)
	no_deconstruction,--填true则不可分解(也可以用function)
	require_special_event,--特殊活动(比如冬季盛宴限定之类的)
	dropitem,--制作后直接掉落物品
	actionstr,--把"制作"改成其他的文字
	manufactured,--填true则表示是用制作站制作的，而不是用builder组件来制作(比如万圣节的药水台就是用这个)

	--勋章自定义
	needHidden,--简易模式隐藏
	noatlas,--不需要图集文件,用原版物品的时候就不需要自定义贴图了
	noimage,--不需要贴图,用原版物品的时候就不需要自定义贴图了
}
--]]
-----------分类------------
--FAVORITES--收藏
--CRAFTING_STATION--科技站专属
--SPECIAL_EVENT--特殊节日
--MODS--模组物品(所有非科技站解锁的mod物品会自动添加这个标签)
	
--CHARACTER--人物专属
--TOOLS--工具
--LIGHT--光源
--PROTOTYPERS--科技
--REFINE--精炼
--WEAPONS--武器
--ARMOUR--盔甲
--CLOTHING--服装
--RESTORATION--治疗
--MAGIC--魔法
--DECOR--装饰

--STRUCTURES--建筑
--CONTAINERS--容器
--COOKING--烹饪
--GARDENING--食物、种植
--FISHING--钓鱼
--SEAFARING--航海
--RIDING--骑乘
--WINTER--保暖道具
--SUMMER--避暑道具
--RAIN--雨具
--EVERYTHING--所有

--自定义成分构建函数(主要是偷懒不想写atlas路径)
--目前只有勋章特有的物品用的这个函数，实际上所有的成分都能直接替换成这个，只不过怕浪费多余的性能所以没替换(其实就是懒，用不了多少)
local function MedalIngredient(ingredienttype,amount)
	local atlas=resolvefilepath_soft("images/"..ingredienttype..".xml")
	return Ingredient(ingredienttype,amount,atlas)
end


local Recipes = {
	--------------------------------------------------------------------
	------------------------------原生配方------------------------------
	--------------------------------------------------------------------
	
	------------------------------植物人------------------------------
	--活木
    {
        name = "livinglog",
        ingredients = {
			{
				Ingredient(CHARACTER_INGREDIENT.HEALTH, 20),
			},
        },
        level = TECH.NONE,
		builder_tag = "livinglogbuilder",
		noatlas = true,
		noimage = true,
		filters={"CHARACTER"},
    },
	------------------------------非原生气球------------------------------
	--[[
	--沉默气球
	{
	    name = "medal_balloon",
	    ingredients = {
			{
				Ingredient("balloons_empty", 0), Ingredient(CHARACTER_INGREDIENT.SANITY, 5),
			},
	    },
	    tab = CUSTOM_RECIPETABS.BALLOONOMANCY,
	    level = TECH.NONE,
		builder_tag = "balloonomancer",
		placer={dropitem = true, buildingstate = "makeballoon"},--制作后直接掉落；使用吹气球动作
	},
	--暗影气球
	{
	    name = "shadow_balloon",
	    ingredients = {
			{
				Ingredient("balloons_empty", 0), Ingredient(CHARACTER_INGREDIENT.SANITY, 5),
			},
	    },
	    tab = CUSTOM_RECIPETABS.BALLOONOMANCY,
	    level = TECH.NONE,
		builder_tag = "balloonomancer",
		placer={dropitem = true, buildingstate = "makeballoon"},--制作后直接掉落；使用吹气球动作
	},
	]]
	
	--------------------------------------------------------------------
	------------------------------新增配方------------------------------
	--------------------------------------------------------------------
	--勋章盒
    {
        name = "medal_box",
        ingredients = {
			{
				Ingredient("purplegem", 1),Ingredient("driftwood_log", 4),Ingredient("turf_carpetfloor", 2),
			},
        },
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
		image = "medal_box.tex",
		filters={"CONTAINERS"},
    },
	--调料盒
    {
        name = "spices_box",
        ingredients = {
			{
				Ingredient("trinket_17", 1),Ingredient("boards", 8),
			},
			{
				Ingredient("boards", 8),
			},
        },
        level = TECH.CARTOGRAPHY_TWO,
		builder_tag = "seasoningchef",
		filters={"COOKING","CONTAINERS"},
    },
	------------------------------大厨勋章------------------------------
    --烹调勋章
    {
        name = "cook_certificate",
        ingredients = {
            {
            	Ingredient("cookbook", 1),MedalIngredient("toil_money", 6),
            },
    		--简易配方
			{
				Ingredient("cookbook", 1),MedalIngredient("toil_money", 3),
			},
        },
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
    },
	--黑曜石锅
	{
	    name = "medal_cookpot",
	    ingredients = {
	        {
				MedalIngredient("medal_obsidian", 6),Ingredient("charcoal", 6),
			},
	    },
        level = TECH.LOST,
		placer = "medal_cookpot_placer",
		min_spacing = 2,
		filters={"COOKING"},
	},
	------------------------------专属调料------------------------------
	--果冻粉
    {
        name = "spice_jelly",
        ingredients = {
            {
				MedalIngredient("medal_fishbones", 2),
			},
        },
        level = TECH.FOODPROCESSING_ONE,
        nounlock = true,
		-- numtogive = 2,
		builder_tag = "seasoningchef",
    },
	--荧光粉
    {
        name = "spice_phosphor",
        ingredients = {
            {
				Ingredient("moonbutterflywings", 2),
			},
        },
        level = TECH.FOODPROCESSING_ONE,
        nounlock = true,
		numtogive = 1,
		builder_tag = "seasoningchef",
    },
	--月树花粉
    {
        name = "spice_moontree_blossom",
        ingredients = {
            {
				Ingredient("moon_tree_blossom", 3),
			},
        },
        level = TECH.FOODPROCESSING_ONE,
        nounlock = true,
		-- numtogive = 2,
		builder_tag = "seasoningchef",
    },
	--仙人掌花粉
    {
        name = "spice_cactus_flower",
        ingredients = {
            {
				Ingredient("cactus_flower", 3),
			},
        },
        level = TECH.FOODPROCESSING_ONE,
        nounlock = true,
		numtogive = 2,
		builder_tag = "seasoningchef",
    },
	--血糖
    {
        name = "spice_blood_sugar",
        ingredients = {
            {
				Ingredient("mosquitosack", 3),
			},
        },
        level = TECH.FOODPROCESSING_ONE,
        nounlock = true,
		numtogive = 2,
		builder_tag = "seasoningchef",
    },
	--灵魂佐料
    {
        name = "spice_soul",
        ingredients = {
            {
				Ingredient("wortox_soul", 1),
			},
        },
        level = TECH.FOODPROCESSING_ONE,
        nounlock = true,
		numtogive = 1,
		builder_tag = "seasoningchef",
    },
	--土豆淀粉
    {
        name = "spice_potato_starch",
        ingredients = {
            {
				Ingredient("potato", 3),
			},
        },
        level = TECH.FOODPROCESSING_ONE,
        nounlock = true,
		numtogive = 2,
		builder_tag = "seasoningchef",
    },
	--秘制酱料
    {
        name = "spice_poop",
        ingredients = {
            {
				Ingredient("compostwrap", 2),
			},
        },
        level = TECH.FOODPROCESSING_ONE,
        nounlock = true,
		numtogive = 5,
		builder_tag = "seasoningchef",
    },
	--叶肉酱
    {
        name = "spice_plantmeat",
        ingredients = {
            {
				Ingredient("plantmeat", 2),MedalIngredient("mandrakeberry", 3),
			},
        },
        level = TECH.FOODPROCESSING_ONE,
        nounlock = true,
		numtogive = 2,
		builder_tag = "seasoningchef",
    },
	--曼德拉果酱
    {
        name = "spice_mandrake_jam",
        ingredients = {
            {
				MedalIngredient("mandrakeberry", 5),
			},
        },
        level = TECH.FOODPROCESSING_ONE,
        nounlock = true,
		numtogive = 1,
		builder_tag = "seasoningchef",
    },
	--山力叶酱
    {
        name = "spice_pomegranate",
        ingredients = {
            {
				Ingredient("pomegranate", 3),
			},
        },
        level = TECH.FOODPROCESSING_ONE,
        nounlock = true,
		numtogive = 1,
		builder_tag = "seasoningchef",
    },
	--凋零蜂王浆酱
    {
        name = "spice_withered_royal_jelly",
        ingredients = {
            {
				MedalIngredient("medal_withered_royaljelly", 1), Ingredient("royal_jelly", 2), Ingredient("honey", 3),
			},
        },
        level = TECH.FOODPROCESSING_ONE,
        nounlock = true,
		numtogive = 1,
		builder_tag = "seasoningchef",
    },
	------------------------------智慧勋章------------------------------
	--蒙昧勋章
	{
	    name = "wisdom_test_certificate",
	    ingredients = {
	        {
				MedalIngredient("toil_money", 4),
			},
			{
				MedalIngredient("toil_money", 2),
			},
	    },
	    level = TECH.CARTOGRAPHY_TWO,
	    nounlock = true,
	},
	--不朽精华
    {
        name = "immortal_essence",
        ingredients = {
            {
				Ingredient("spoiled_food", 20), Ingredient("saltrock", 3),
			},
			{
				Ingredient("spoiled_food", 10),
			},
        },
        level = TECH.SCIENCE_TWO,
        -- nounlock = true,
		filters = {"REFINE"},
    },
	--血汗钱
    {
        name = "toil_money",
        ingredients = {
            {
				Ingredient("goldnugget", 2),Ingredient(CHARACTER_INGREDIENT.HEALTH, 25),
			},
        },
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
		filters = {"REFINE"},
    },
	--血汗钱
    {
        name = "toil_money_copy",
		product = "toil_money",
        ingredients = {
            {
				Ingredient("goldnugget", 2),Ingredient("spidergland", 4),
			},
        },
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
		filters = {"REFINE"},
    },
	--新华字典
	{
        name = "xinhua_dictionary",
        ingredients = {
            {
				MedalIngredient("toil_money", 10),
			},
			{
				MedalIngredient("toil_money", 5),
			},
        },
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
		filters = {"CHARACTER"},
    },
	------------------------------巧手勋章------------------------------
	--巧手考验勋章
	{
        name = "handy_test_certificate",
        ingredients = {
            {
				MedalIngredient("toil_money", 6),
			},
			{
				MedalIngredient("toil_money", 3),
			},
        },
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
    },
	--催雨弹
	{
	    name = "medal_rain_bomb",
	    ingredients = {
	        {
				Ingredient("miniflare", 1),Ingredient("saltrock", 1),Ingredient("gunpowder", 1),
			},
	    },
	    level = TECH.SCIENCE_TWO,
		builder_tag="has_handy_medal",
		filters = {"RAIN"},
	},
	--放晴弹
	{
	    name = "medal_clear_up_bomb",
	    ingredients = {
	        {
				Ingredient("miniflare", 1),Ingredient("lightbulb", 1),Ingredient("gunpowder", 1),
			},
	    },
	    level = TECH.SCIENCE_TWO,
		builder_tag="has_handy_medal",
		filters = {"RAIN"},
	},
	--时空弹
	{
	    name = "medal_spacetime_bomb",
	    ingredients = {
	        {
				Ingredient("miniflare", 1),MedalIngredient("medal_spacetime_lingshi", 5),Ingredient("gunpowder", 1),
			},
	    },
	    level = TECH.SCIENCE_TWO,
		builder_tag="has_handy_medal",
		filters = {"RAIN"},
	},
	--手摇深井泵改造装置
	{
        name = "medal_waterpump_item",
        ingredients = {
            {
				Ingredient("cane", 1),Ingredient("gears", 2),Ingredient("transistor", 2),
			},
        },
        level = TECH.SCIENCE_TWO,
		builder_tag = "has_handy_medal",
		filters = {"TOOLS","GARDENING"},
    },
	--藏宝图
	{
	    name = "medal_treasure_map",
	    ingredients = {
	        {
				MedalIngredient("medal_treasure_map_scraps1", 1),
				MedalIngredient("medal_treasure_map_scraps2", 1),
				MedalIngredient("medal_treasure_map_scraps3", 1),
				Ingredient("sewing_tape", 1),
			},
	    },
	    level = TECH.SCIENCE_TWO,
		filters = {"REFINE"},
	},
	--遗失藏宝图
	{
	    name = "medal_loss_treasure_map",
	    ingredients = {
	        {
				MedalIngredient("medal_loss_treasure_map_scraps", 5),
				Ingredient("sewing_tape", 1),
			},
	    },
	    level = TECH.SCIENCE_TWO,
		no_deconstruction = true,
		filters = {"REFINE"},
	},
	--宝藏探测仪
	{
	    name = "medal_resonator_item",
	    ingredients = {
	        {
				Ingredient("compass", 1),Ingredient("gears", 1),Ingredient("transistor", 1),
			},
	    },
	    level = TECH.SCIENCE_TWO,
		builder_tag = "has_handy_medal",
		filters = {"TOOLS"},
	},
	--缪斯雕像1
	{
        name = "medal_statue_marble_muse1",
        ingredients = {
            {
				Ingredient("marble", 3),
			},
        },
        level = TECH.NONE,
		placer = "medal_statue_marble_muse1_placer",
		builder_tag="has_handy_medal",
		min_spacing = 1.5,
		filters = {"DECOR"},
    },
	--缪斯雕像2
	{
        name = "medal_statue_marble_muse2",
        ingredients = {
            {
				Ingredient("marble", 3),
			},
        },
        level = TECH.NONE,
		placer = "medal_statue_marble_muse2_placer",
		builder_tag="has_handy_medal",
		min_spacing = 1.5,
		filters = {"DECOR"},
    },
	--瓷瓶雕像
	{
        name = "medal_statue_marble_urn",
        ingredients = {
            {
				Ingredient("marble", 3),
			},
        },
        level = TECH.NONE,
		placer = "medal_statue_marble_urn_placer",
		builder_tag="has_handy_medal",
		min_spacing = 1.5,
		filters = {"DECOR"},
    },
	--士卒雕像
	{
        name = "medal_statue_marble_pawn",
        ingredients = {
            {
				Ingredient("marble", 3),
			},
        },
        level = TECH.NONE,
		placer = "medal_statue_marble_pawn_placer",
		builder_tag="has_handy_medal",
		min_spacing = 1.5,
		filters = {"DECOR"},
    },
	--丘比特雕像
	{
        name = "medal_statue_marble_harp",
        ingredients = {
            {
				Ingredient("marble", 3),
			},
        },
        level = TECH.NONE,
		placer = "medal_statue_marble_harp_placer",
		builder_tag="has_handy_medal",
		min_spacing = 1.5,
		filters = {"DECOR"},
    },
	--格罗姆雕像
	{
        name = "medal_statue_marble_glommer",
        ingredients = {
            {
				Ingredient("marble", 3),
			},
        },
        level = TECH.NONE,
		placer = "medal_statue_marble_glommer_placer",
		builder_tag="has_handy_medal",
		min_spacing = 1.5,
		filters = {"DECOR"},
    },
	--老麦雕像
	{
        name = "medal_statue_marble_maxwell",
        ingredients = {
            {
				Ingredient("marble", 5),
			},
        },
        level = TECH.NONE,
		placer = "medal_statue_marble_maxwell_placer",
		builder_tag="has_handy_medal",
		min_spacing = 2.5,
		filters = {"DECOR"},
    },
	--鸽子雕像
	{
        name = "medal_statue_marble_gugugu",
        ingredients = {
            {
				Ingredient("marble", 3),
			},
        },
        level = TECH.NONE,
		placer = "medal_statue_marble_gugugu_placer",
		builder_tag="has_handy_medal",
		min_spacing = 1.5,
		filters = {"DECOR"},
    },
	--咸鱼雕像
	{
        name = "medal_statue_marble_saltfish",
        ingredients = {
            {
				Ingredient("marble", 3),
			},
        },
        level = TECH.NONE,
		placer = "medal_statue_marble_saltfish_placer",
		builder_tag="has_handy_medal",
		min_spacing = 1.5,
		filters = {"DECOR"},
    },
	--猫猫雕像
	{
        name = "medal_statue_marble_stupidcat",
        ingredients = {
            {
				Ingredient("marble", 3),
			},
        },
        level = TECH.NONE,
		placer = "medal_statue_marble_stupidcat_placer",
		builder_tag="has_handy_medal",
		min_spacing = 1.5,
		filters = {"DECOR"},
    },
	--大黑蛋雕像
	{
        name = "medal_statue_marble_blackegg",
        ingredients = {
            {
				Ingredient("marble", 3),Ingredient("charcoal", 2),
			},
        },
        level = TECH.NONE,
		placer = "medal_statue_marble_blackegg_placer",
		builder_tag="has_handy_medal",
		min_spacing = 1.5,
		filters = {"DECOR"},
    },
	--百变雕像
	{
        name = "medal_statue_marble_changeable",
        ingredients = {
            {
				Ingredient("marble", 3),
			},
        },
        level = TECH.NONE,
		placer = "medal_statue_marble_changeable_placer",
		builder_tag="has_handy_medal",
		min_spacing = 1.5,
		filters = {"DECOR"},
    },
	--大理石盆栽
	{
        name = "medal_statue_marble_potting",
        ingredients = {
            {
				Ingredient("marble", 3),Ingredient("seeds", 1),MedalIngredient("spice_poop", 1),
			},
        },
        level = TECH.NONE,
		placer = "medal_statue_marble_potting_placer",
		builder_tag="has_handy_medal",
		min_spacing = 1.5,
		filters = {"DECOR"},
    },
	------------------------------伐木勋章------------------------------
	--初级伐木勋章
	{
        name = "smallchop_certificate",
        ingredients = {
            {
            	Ingredient("log", 20),
			},
			{
				Ingredient("log", 10),
            },
        },
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
    },
	------------------------------矿工勋章------------------------------
	--初级矿工勋章
	{
        name = "smallminer_certificate",
        ingredients = {
            {
            	Ingredient("flint", 8),Ingredient("rocks", 8),Ingredient("nitre", 4),
			},
			{
				Ingredient("flint", 4),Ingredient("rocks", 4),Ingredient("nitre", 2),
            },
        },
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
    },
	------------------------------植物勋章------------------------------
	--月光铲
	{
        name = "medal_moonglass_shovel",
        ingredients = {
			{
				Ingredient("livinglog", 1),Ingredient("moonglass", 3),Ingredient("kelp", 2),
			},
        },
        level = TECH.CELESTIAL_THREE,
        nounlock = true,
		builder_tag = "has_transplant_medal",
    },
	--月光锤
	{
        name = "medal_moonglass_hammer",
        ingredients = {
			{
				Ingredient("livinglog", 1),Ingredient("moonglass", 3),Ingredient("kelp", 2),
			},
        },
        level = TECH.CELESTIAL_THREE,
        nounlock = true,
		builder_tag = "has_transplant_medal",
    },
	--月光网
	{
        name = "medal_moonglass_bugnet",
        ingredients = {
			{
				Ingredient("livinglog", 1),Ingredient("silk", 2),Ingredient("moonglass", 4),Ingredient("kelp", 2),	
			},
        },
        level = TECH.CELESTIAL_THREE,
        nounlock = true,
		builder_tag = "has_transplant_medal",
    },
	--月光药水
	{
        name = "medal_moonglass_potion",
        ingredients = {
			{	
				Ingredient("moonbutterflywings", 1),Ingredient("moonglass", 3),Ingredient("moon_tree_blossom", 2),
			},
        },
        level = TECH.CELESTIAL_THREE,
		numtogive = 2,
        nounlock = true,
		builder_tag = "has_transplant_medal",
    },
	--玻璃钓竿
	{
        name = "medal_fishingrod_new",
		product = "medal_fishingrod",
        ingredients = {
            {
				Ingredient("moonglass", 6),Ingredient("silk", 5),Ingredient("kelp", 2),	
			},
        },
		level = TECH.CELESTIAL_THREE,
		nounlock = true,
    },
	--活木树苗
	{
        name = "medaldug_livingtree_root",
        ingredients = {
			{
				Ingredient("livinglog", 1), Ingredient(CHARACTER_INGREDIENT.HEALTH, 20),
			},
			{
				Ingredient("livinglog", 1), Ingredient(CHARACTER_INGREDIENT.HEALTH, 10),
			},
        },
        level = TECH.MAGIC_THREE,
		builder_tag = "plantkin",
		filters = {"MAGIC","GARDENING","CHARACTER"},
    },
	------------------------------新增书籍------------------------------
	--无字天书
	-- {
    --     name = "closed_book",
    --     ingredients = {
    --         {
	-- 			Ingredient("papyrus", 2),
	-- 		},
    --     },
    --     level = TECH.CARTOGRAPHY_TWO,
    --     nounlock = true,
	-- 	filters = {"CHARACTER"},
    -- },
	--不朽之谜
		{
		name = "immortal_book",
		ingredients = {
			{
				Ingredient("papyrus", 2),Ingredient("waxpaper", 1),MedalIngredient("immortal_essence", 3),
			},
		},
		level = TECH.NONE,
		builder_tag = "is_bee_king",
		filters = {"CHARACTER"},
	},
    
	--陷阱重置册
	{
        name = "trapreset_book",
        ingredients = {
            {
				Ingredient("papyrus", 2),Ingredient("sewing_tape", 4),
			},
        },
        level = TECH.NONE,
		builder_tag = "wisdombuilder",
		filters = {"CHARACTER"},
    },
	------------------------------正义勋章------------------------------
	--逮捕勋章
	{
        name = "arrest_certificate",
        ingredients = {
            {
				Ingredient("killerbee", 20),
			},
			{
				Ingredient("killerbee", 10),
			},
        },
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
    },
	--怪物精华
    {
        name = "medal_monster_essence",
        ingredients = {
            {
				Ingredient("durian", 2), Ingredient("charcoal", 6), Ingredient("monstermeat", 4),
			},
			{
				Ingredient("durian", 1), Ingredient("charcoal", 3), Ingredient("monstermeat", 2),
			},
        },
        level = TECH.LOST,
		filters = {"REFINE"},
    },
	------------------------------钓鱼勋章------------------------------
	--钓鱼勋章
	{
        name = "smallfishing_certificate",
        ingredients = {
            {
            	MedalIngredient("toil_money", 4),
            },
            {
            	MedalIngredient("toil_money", 2),
            },
        },
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
    },
	------------------------------时空勋章------------------------------
	--时空宝石
	{
        name = "medal_space_gem",
        ingredients = {
            {
				MedalIngredient("medal_time_slider", 5),MedalIngredient("medal_spacetime_lingshi", 10),Ingredient("opalpreciousgem", 1),
			},
        },
		level = TECH.NONE,
		no_deconstruction = true,
		builder_tag = "spacetime_medal",
		-- canbuild = function(inst,builder)--佩戴时空勋章才能制作(测试用)
		-- 	return builder and builder.components.inventory and builder.components.inventory:EquipMedalWithName("space_time_certificate"),"NOSPACETIMEMEDAL"
		-- end,
		filters = {"REFINE"},
    },
	--预言水晶球
	{
        name = "medal_spacetime_crystalball",
        ingredients = {
            {
				MedalIngredient("medal_space_gem", 1),MedalIngredient("medal_spacetime_lingshi", 5),MedalIngredient("immortal_fruit", 1),
			},
        },
		level = TECH.NONE,
		no_deconstruction = true,
		builder_tag = "spacetime_medal",
		filters = {"TOOLS","MAGIC"},
    },
	--改命药水
	{
        name = "medal_spacetime_potion",
        ingredients = {
            {
				MedalIngredient("medal_time_slider", 1),MedalIngredient("medal_spacetime_lingshi", 5),MedalIngredient("bottled_moonlight", 1),
			},
        },
		level = TECH.NONE,
		numtogive = 10,
		no_deconstruction = true,
		builder_tag = "spacetime_medal",
		filters = {"REFINE"},
    },
	--时空符文
	{
        name = "medal_spacetime_runes",
        ingredients = {
            {
				MedalIngredient("medal_time_slider", 1),MedalIngredient("medal_spacetime_lingshi", 10),Ingredient("townportaltalisman", 10),
			},
        },
		level = TECH.NONE,
		numtogive = 10,
		no_deconstruction = true,
		builder_tag = "spacetime_medal",
		filters = {"REFINE"},
    },
	--琥珀灵石
	{
        name = "medal_dustmeringue",
        ingredients = {
            {
				MedalIngredient("medal_spacetime_lingshi", 2),Ingredient("dustmeringue", 1),
			},
        },
		level = TECH.NONE,
		no_deconstruction = true,
		builder_tag = "spacetime_medal",
		filters = {"REFINE","GARDENING"},
    },
	--尘蛾窝
	{
        name = "dustmothden_copy",
		product = "dustmothden",
        ingredients = {
            {
				MedalIngredient("medal_dustmothden_base", 1),Ingredient("moonrocknugget", 4), Ingredient("thulecite", 4)
			},
        },
        level = TECH.NONE,
		placer = "dustmothden_placer", 
		no_deconstruction = true,
		builder_tag = "spacetime_medal",
		min_spacing = 1.5,
		filters = {"STRUCTURES"},
		atlas = "minimap/minimap_data.xml",
		image = "dustmothden.png",
    },
	--时空尘蛾窝
	{
        name = "medal_dustmothden",
        ingredients = {
            {
				MedalIngredient("medal_dustmothden_base", 1),MedalIngredient("medal_space_gem", 1),Ingredient("moonrocknugget", 10), Ingredient("thulecite", 10)
			},
        },
        level = TECH.NONE,
		placer = "medal_dustmothden_placer", 
		no_deconstruction = true,
		builder_tag = "spacetime_medal",
		min_spacing = 1.5,
		filters = {"STRUCTURES"},
    },
	------------------------------其他勋章------------------------------
	--友善勋章
	{
        name = "friendly_certificate",
        ingredients = {
            {
				MedalIngredient("toil_money", 6),
			},
			{
				MedalIngredient("toil_money", 3),
			},
        },
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
		builder_tag = "monster",
    },
	--女武神的检验
	{
        name = "valkyrie_examine_certificate",
        ingredients = {
            {
				MedalIngredient("toil_money", 6),
			},
			{
				MedalIngredient("toil_money", 3),
			},
        },
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
    },
	------------------------------其他道具------------------------------
	--熊皮宝箱
	{
        name = "bearger_chest",
        ingredients = {
            {
				Ingredient("bearger_fur", 1), Ingredient("boards", 5),Ingredient("bundlewrap", 8),MedalIngredient("immortal_essence", 6),
			},
			{
				Ingredient("bearger_fur", 1), Ingredient("boards", 3),Ingredient("bundlewrap", 4),MedalIngredient("immortal_essence", 3),
			},
        },
        level = TECH.LOST,
		placer = "bearger_chest_placer", 
		no_deconstruction = true,
		min_spacing = 1.5,
		filters = {"STRUCTURES","CONTAINERS"},
    },
	--童心箱
	{
	    name = "medal_childishness_chest",
	    ingredients = {
	        {
				Ingredient("boards", 5), Ingredient("rope", 1),Ingredient("trinket_1", 1),
			},
	    },
	    level = TECH.NONE,
		placer = "medal_childishness_chest_placer",
		builder_tag = "has_childishness",
		min_spacing = 1.5,
		filters = {"STRUCTURES","CONTAINERS"},
	},
	--食人花手杖
	{
        name = "lureplant_rod",
        ingredients = {
            {
				Ingredient("lureplantbulb", 1), Ingredient("nightmarefuel", 5),Ingredient("livinglog", 2),
			},
			{
				Ingredient("lureplantbulb", 1), Ingredient("nightmarefuel", 3),Ingredient("livinglog", 1),
			},
        },
        level = TECH.MAGIC_THREE,
		builder_tag = "has_plant_medal",
		filters = {"MAGIC","TOOLS"},
    },
	--大理石斧
	{
        name = "marbleaxe",
        ingredients = {
            {
				Ingredient("marble", 3), Ingredient("twigs", 2), Ingredient("goldnugget", 2),
			},
        },
        level = TECH.SCIENCE_TWO,
		filters = {"TOOLS"},
    },
	--大理石镐
	{
        name = "marblepickaxe",
        ingredients = {
            {
				Ingredient("marble", 3), Ingredient("twigs", 2), Ingredient("goldnugget", 2),
			},
        },
        level = TECH.SCIENCE_TWO,
		filters = {"TOOLS"},
    },
	--不朽宝石
	{
        name = "immortal_gem",
        ingredients = {
            {
				MedalIngredient("immortal_fruit", 5),Ingredient("opalpreciousgem", 1),
			},
        },
        level = TECH.LOST,
		no_deconstruction = true,
		filters = {"REFINE"},
    },
	--蝙蝠陷阱
	{
        name = "trap_bat",
        ingredients = {
            {
				Ingredient("goldnugget", 2),Ingredient("stinger", 1),Ingredient("silk", 1),
			},
        },
        level = TECH.LOST,
		filters = {"WEAPONS"},
    },
	--羊角帽
	{
        name = "medal_goathat",
        ingredients = {
			{
				Ingredient("lightninggoathorn", 2),Ingredient("beefalowool", 8),Ingredient("transistor", 5),
			},
			{
				Ingredient("lightninggoathorn", 1),Ingredient("beefalowool", 4),Ingredient("transistor", 2),
			},
        },
        level = TECH.LOST,
		filters = {"CLOTHING","WINTER"},
    },
	--格罗姆精华
    {
        name = "medal_glommer_essence",
        ingredients = {
            {
				Ingredient("glommerwings", 1),Ingredient("glommerflower", 1),Ingredient("glommerfuel", 2),
			},
        },
        level = TECH.MAGIC_THREE,
		filters = {"MAGIC","REFINE"},
    },
	--格罗姆精华
    {
        name = "medal_glommer_essence_copy",
		product = "medal_glommer_essence",
        ingredients = {
            {
				Ingredient("glommerfuel", 4),
			},
        },
        level = TECH.MAGIC_THREE,
		filters = {"MAGIC","REFINE"},
    },
	--淘气铃铛
	{
        name = "medal_naughtybell",
        ingredients = {
			{
				Ingredient("glommerwings", 1),Ingredient("glommerflower", 1),MedalIngredient("medal_glommer_essence", 3),
			},
        },
        level = TECH.MAGIC_THREE,
		-- builder_tag = "naughtymedal",
		no_deconstruction = true,
		filters = {"MAGIC"},
    },
	--黑曜石火坑
	{
        name = "medal_firepit_obsidian",
        ingredients = {
			{
				MedalIngredient("medal_obsidian", 8),Ingredient("charcoal", 6),Ingredient("cutgrass", 6),
			},
			{
				MedalIngredient("medal_obsidian", 4),Ingredient("charcoal", 3),Ingredient("cutgrass", 3),
			},
        },
        level = TECH.LOST,
		placer = "medal_firepit_obsidian_placer",
		min_spacing = 2,
		filters = {"LIGHT","COOKING"},
    },
	--蓝曜石火坑
	{
        name = "medal_coldfirepit_obsidian",
        ingredients = {
			{
				MedalIngredient("medal_blue_obsidian", 8),Ingredient("nitre", 6),Ingredient("transistor", 3),
			},
			{
				MedalIngredient("medal_blue_obsidian", 4),Ingredient("nitre", 3),Ingredient("transistor", 2),
			},
        },
        level = TECH.LOST,
		placer = "medal_coldfirepit_obsidian_placer",
		min_spacing = 2,
		filters = {"LIGHT"},
    },
	--船上钓鱼池
	{
        name = "medal_seapond",
        ingredients = {
            {
				Ingredient("boards", 4), Ingredient("rope", 4),Ingredient("chum", 1),
			},
			{
				Ingredient("boards", 4), Ingredient("rope", 4),Ingredient("barnacle", 4),
			},
        },
        level = TECH.LOST,
		placer = "medal_seapond_placer", 
		no_deconstruction = true,
		min_spacing = 3,
		testfn=function(pt)
		   return TheWorld.Map:GetPlatformAtPoint(pt.x, 0, pt.z,  -3) ~= nil or TheWorld.Map:IsDockAtPoint(pt.x, 0, pt.z)
		end,
		filters = {"FISHING","SEAFARING"},
    },
	--触手尖刺
    {
        name = "tentaclespike_medal",
		product = "tentaclespike",
        -- name = "tentaclespike",
        ingredients = {
			{
				Ingredient("houndstooth", 3),Ingredient("livinglog", 1),
			},
			{
				Ingredient("houndstooth", 2),Ingredient("log", 2),
			},
        },
        level = TECH.MAGIC_THREE,
		builder_tag = "tentaclemedal",
		noatlas = true,
		noimage = true,
		filters = {"WEAPONS","MAGIC"},
    },
	--活性触手尖刺
	{
        name = "medal_tentaclespike",
        ingredients = {
			{
				Ingredient("houndstooth", 4),Ingredient("tentaclespike", 1),
			},
			{
				Ingredient("houndstooth", 2),Ingredient("tentaclespike", 1),
			},
        },
        level = TECH.MAGIC_THREE,
		builder_tag = "tentaclemedal",
		filters = {"WEAPONS","MAGIC"},
    },
	--树根宝箱
	{
        name = "medal_livingroot_chest",
        ingredients = {
            {
				Ingredient("livinglog", 6), Ingredient("nightmarefuel", 6),
			},
			{
				Ingredient("livinglog", 3), Ingredient("nightmarefuel", 3),
			},
        },
        level = TECH.MAGIC_THREE,
		placer = "medal_livingroot_chest_placer",
		min_spacing = 1.5,
		filters = {"STRUCTURES","MAGIC","CONTAINERS"},
    },
	--空瓶子
    {
        name = "messagebottleempty_medal",
		product = "messagebottleempty",
        -- name = "messagebottleempty",
        ingredients = {
			{
				Ingredient("moonglass", 4),
			},
			{
				Ingredient("moonglass", 2),
			},
        },
        level = TECH.NONE,
		builder_tag = "has_bathfire_medal",
		noatlas = true,
		noimage = true,
		filters = {"REFINE"},
    },
	--高效耕地机
	{
        name = "medal_farm_plow_item",
        ingredients = {
            {
				Ingredient("farm_plow_item", 1),Ingredient("golden_farm_hoe", 2),Ingredient("tillweed", 2),
			},
			{
				Ingredient("farm_plow_item", 1),Ingredient("golden_farm_hoe", 2),Ingredient("boards", 3),
			},
        },
        level = TECH.SCIENCE_TWO,
		filters = {"GARDENING"},
    },
	--黑曜石甲
	{
        name = "armor_medal_obsidian",
        ingredients = {
            {
				MedalIngredient("medal_obsidian", 3),Ingredient("sewing_tape", 1),
			},
        },
        level = TECH.LOST,
		filters = {"ARMOUR"},
    },
	--蓝曜石甲
	{
        name = "armor_blue_crystal",
        ingredients = {
            {
				MedalIngredient("medal_blue_obsidian", 3),Ingredient("sewing_tape", 1),
			},
        },
        level = TECH.LOST,
		filters = {"ARMOUR"},
    },
	--蓝曜石制冰机
	{
        name = "medal_ice_machine",
        ingredients = {
			{
				MedalIngredient("medal_blue_obsidian", 4),Ingredient("gears", 1),Ingredient("transistor", 1),Ingredient("trinket_6", 1),
			},
        },
        level = TECH.LOST,
		placer = "medal_ice_machine_placer",
		min_spacing = 1.5,
		filters = {"COOKING","CONTAINERS"},
    },
	--育王蜂箱
	{
        name = "medal_beebox",
        ingredients = {
			{
				MedalIngredient("medal_withered_heart", 1),Ingredient("beeswax", 3),Ingredient("driftwood_log", 6),
			},
        },
        level = TECH.NONE,
		builder_tag = "is_bee_king",
		placer = "medal_beebox_placer",
		-- min_spacing = 1.5,
		filters = {"GARDENING"},
    },
	------------------------------专属弹药------------------------------
	--方尖弹
    {
        name = "medalslingshotammo_sanityrock",
        ingredients = {
            {
				MedalIngredient("sanityrock_fragment", 1),Ingredient("thulecite", 2),
			},
        },
        level = TECH.NONE,
		numtogive = 10,
		builder_tag = "senior_childishness",
		no_deconstruction = true,
		filters = {"CHARACTER","WEAPONS"},
    },
	--沙刺弹
	{
	    name = "medalslingshotammo_sandspike",
	    ingredients = {
	        {
				Ingredient("townportaltalisman", 2),
			},
	    },
	    level = TECH.NONE,
		numtogive = 5,
		builder_tag = "senior_childishness",
		no_deconstruction = true,
		filters = {"CHARACTER","WEAPONS"},
	},
	--落水弹
	{
	    name = "medalslingshotammo_water",
	    ingredients = {
	        {
				Ingredient("mosquitosack", 2),Ingredient("ice", 2),
			},
	    },
	    level = TECH.NONE,
		numtogive = 5,
		builder_tag = "senior_childishness",
		no_deconstruction = true,
		filters = {"CHARACTER","WEAPONS"},
	},
	--痰蛋弹
	{
	    name = "medalslingshotammo_taunt",
	    ingredients = {
	        {
				Ingredient("phlegm", 1),Ingredient("rottenegg", 2),
			},
	    },
	    level = TECH.NONE,
		numtogive = 5,
		builder_tag = "senior_childishness",
		no_deconstruction = true,
		filters = {"CHARACTER","WEAPONS"},
	},
	--尖刺弹
	{
	    name = "medalslingshotammo_spines",
	    ingredients = {
	        {
				Ingredient("waterplant_bomb", 1),Ingredient("stinger", 10),
			},
	    },
	    level = TECH.NONE,
		numtogive = 10,
		builder_tag = "senior_childishness",
		no_deconstruction = true,
		filters = {"CHARACTER","WEAPONS"},
	},
	--弹药盒
	{
	    name = "medal_ammo_box",
	    ingredients = {
	        {
				Ingredient("pigskin", 2),Ingredient("driftwood_log", 12),Ingredient("rope", 1),
			},
	    },
	    level = TECH.NONE,
		builder_tag = "senior_childishness",
		filters = {"CHARACTER","CONTAINERS"},
	},
	------------------------------传承勋章------------------------------
	--羽绒服
	{
        name = "down_filled_coat",
        ingredients = {
            {
				Ingredient("goose_feather", 20),Ingredient("tentaclespots", 2),Ingredient("sewing_kit", 1),
			},
			{
				Ingredient("goose_feather", 10),Ingredient("tentaclespots", 1),Ingredient("sewing_kit", 1),
			},
        },
        level = TECH.SCIENCE_TWO,
		builder_tag = "traditionalbearer1",
		filters = {"CLOTHING","WINTER"},
    },
	--蓝晶帽
	{
        name = "hat_blue_crystal",
        ingredients = {
            {
				MedalIngredient("medal_blue_obsidian", 12),Ingredient("sewing_tape", 6),
			},
			{
				MedalIngredient("medal_blue_obsidian", 6),Ingredient("sewing_tape", 3),
			},
        },
        level = TECH.SCIENCE_TWO,
		builder_tag = "traditionalbearer1",
		filters = {"CLOTHING","SUMMER"},
    },
	--复眼勋章
	{
        name = "ommateum_certificate",
        ingredients = {
            {
				MedalIngredient("blank_certificate", 1),Ingredient("deerclops_eyeball", 1),Ingredient("yellowmooneye", 1),
			},
        },
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
		builder_tag = "traditionalbearer2",
    },
	--速度勋章
	{
        name = "speed_certificate",
        ingredients = {
            {
				MedalIngredient("blank_certificate", 1),Ingredient("walrus_tusk", 1),Ingredient("townportaltalisman", 10),
			},
			{
				MedalIngredient("blank_certificate", 1),Ingredient("walrus_tusk", 1),Ingredient("townportaltalisman", 5),
			},
        },
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
		builder_tag = "traditionalbearer2",
    },
	--空间勋章
	{
        name = "space_certificate",
        ingredients = {
            {
				MedalIngredient("speed_certificate", 1),MedalIngredient("medal_spacetime_lingshi", 10),Ingredient("townportaltalisman", 10),
			},
			{
				MedalIngredient("speed_certificate", 1),MedalIngredient("medal_spacetime_lingshi", 5),Ingredient("townportaltalisman", 5),
			},
        },
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
		builder_tag = "traditionalbearer3",
		no_deconstruction = true,
    },
	--智能陷阱制作手册
	{
        name = "autotrap_book",
        ingredients = {
            {
				MedalIngredient("trapreset_book", 1),MedalIngredient("medal_ivy", 3),Ingredient("sewing_tape", 4),
			},
        },
        level = TECH.NONE,
		builder_tag = "traditionalbearer3",
		filters = {"CHARACTER"},
    },
	--方尖锏
	{
        name = "sanityrock_mace",
        ingredients = {
            {
				MedalIngredient("sanityrock_fragment", 9),Ingredient("moonglass", 5),Ingredient("nightmarefuel", 3),
			},
        },
        level = TECH.MAGIC_THREE,
		builder_tag = "traditionalbearer3",
		no_deconstruction = true,
		filters = {"WEAPONS","MAGIC"},
    },
	--踏水勋章
	{
        name = "treadwater_certificate",
        ingredients = {
            {
				MedalIngredient("blank_certificate", 1),Ingredient("malbatross_feathered_weave", 4),Ingredient("cookiecuttershell", 8),
			},
			{
				MedalIngredient("blank_certificate", 1),Ingredient("malbatross_feather", 6),Ingredient("cookiecuttershell", 4),
			},
        },
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
		builder_tag = "traditionalbearer3",
    },
	-- 皮肤法杖
    {
        name = "medal_skin_staff",
        ingredients = {
            {
            	MedalIngredient("toil_money", 6),
            },
        },
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
		filters = {"DECOR","TOOLS"},
    },
}
--分解配方
local DeconstructRecipes = {
	--手摇深井泵
	{
        name = "medal_waterpump",
        ingredients = {
            Ingredient("cane", 1),
			Ingredient("gears", 2),
			Ingredient("transistor", 2),
			Ingredient("boards", 2),
			Ingredient("oceanfish_small_9_inv", 1)
        },
    },
	--融合勋章
	{
        name = "multivariate_certificate",
        ingredients = {
            Ingredient("blank_certificate", 2),
        },
    },
	--中级融合勋章
	{
        name = "medium_multivariate_certificate",
        ingredients = {
            Ingredient("blank_certificate", 4),
        },
    },
	--高级融合勋章
	{
        name = "large_multivariate_certificate",
        ingredients = {
            Ingredient("blank_certificate", 8),
        },
    },
}

return {
	Recipes = Recipes,
	DeconstructRecipes = DeconstructRecipes,
}