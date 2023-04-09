AddRoom("TourmalineField",
{
	colour={r=.66,g=.66,b=.66,a=.50},
	value = GROUND.ROCKY,	--岩石地皮
	contents =
	{
		countstaticlayouts={["TourmalineBase"] = 1}, -- using a static layout because this can force it to be in the center of the room
		distributepercent = 0.2,
		distributeprefabs =	--物品的数量分布比例
		{
			rocks = 0.2,
            rock1 = 1.2,
            rock2 = 1,
            rock_ice = 0.1,
            rock_flintless = 0.5,
            rock_flintless_med = 0.1,
            rock_flintless_low = 0.1,
            -- rock_petrified_tree_old = 0.3,
            tallbirdnest = 0.01,
		},
	}
})
