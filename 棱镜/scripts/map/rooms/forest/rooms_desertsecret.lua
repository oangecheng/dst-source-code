require "map/room_functions"

AddRoom("ShyerryForest",
{
	colour = {r=.8,g=1,b=.8,a=.50},
	value = GROUND.DIRT_NOISE,	--荒漠地皮
	tags = {"RoadPoison", "sandstorm"}, --sandstorm这个标签不加的话会导致无法生成沙暴
	contents =
	{
		countprefabs =	--必定会出现对应数量的物品的表
		{
			shyerrymanager = 1,
		},
		distributepercent = 0.01,	--distributeprefabs中物品的区域密集程度
		distributeprefabs =	--物品的数量分布比例
		{
			oasis_cactus = 0.001,
		},
	}
})

AddRoom("HelperSquare",
{
	colour={r=0.3,g=0.2,b=0.1,a=0.3},
	value = GROUND.FOREST,	--森林地皮
	tags = {"Hutch_Fishbowl", "Mist"},
    type = NODE_TYPE.Room,
	contents =
	{
		countstaticlayouts={["HelperCemetery"] = 1}, -- using a static layout because this can force it to be in the center of the room
		distributepercent = 0.2,
		distributeprefabs =	--物品的数量分布比例
		{
			rocks = 0.1,
            rock1 = 0.2,
            rock_flintless = 0.2,
            rock_flintless_med = 0.2,
            rock_flintless_low = 0.2,
			marsh_tree = 1.5,
			marsh_bush = 0.2,
            livingtree = 0.01,
		},
	}
})
