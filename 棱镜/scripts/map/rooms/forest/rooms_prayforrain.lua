AddRoom("MonsteraPatch",
{
	colour = {r=.8,g=1,b=.8,a=.50}, 
	value = GROUND.MARSH,	--沼泽地皮
	contents =  
	{
		countprefabs =	--必定会出现对应数量的物品的表
		{
			monstrain = function () return 2 + math.random(4) end,
			pond_mos = 1,
		},
		distributepercent = 0.2,	--distributeprefabs中物品的区域密集程度
		distributeprefabs =	--物品的数量分布比例
		{
            fireflies = 0.2,
			flower = 0.1,
			mermhouse = 0.03,
			pond_mos = 0.2,
			reeds = .02,
			tentacle = 0.1,
		},
	}
})

AddRoom("MoonDungeonPosition",
{
	colour={r=0.3,g=0.2,b=0.1,a=0.3},
	value = GROUND.METEORMINE_NOISE,
	contents =
	{
		countstaticlayouts = {["MoonDungeon"] = 1}, -- using a static layout because this can force it to be in the center of the room
		distributepercent = 0.12,
		distributeprefabs =
		{
			rock_ice = 2,
			moonglass_rock = 0.2, 	--月晶矿
			rock_moon = 0.2,		--月石矿
			moon_fissure = 1.5,
			moonglass = 0.2,
		},
	}
})
