local plantables =
{
    {
        --芦苇
		name = "medaldug_reeds",--植株名
		plantname = "reeds",--植物名
        anim = "medaldug_reeds",--动画
		bank_placer = "grass",
		build_placer = "reeds",
		anim_placer = "idle",--种植预览动画
		mediumspacing = true,--近距离种植
        floater = {"large", 0.1, 0.55},
    },
	{
		--单果荧光草
        name = "medaldug_flower_cave",
		plantname = "flower_cave",
        anim = "medaldug_flower_cave",
		bank_placer = "bulb_plant_single",
		build_placer = "bulb_plant_single",
		anim_placer = "off",
		mediumspacing = true,
        floater = {"large", 0.1, 0.55},
    },
	{
		--双果荧光草
        name = "medaldug_flower_cave_double",
		plantname = "flower_cave_double",
        anim = "medaldug_flower_cave_double",
		bank_placer = "bulb_plant_double",
		build_placer = "bulb_plant_double",
		anim_placer = "off",
		mediumspacing = true,
        floater = {"large", 0.1, 0.55},
    },
	{
		--三果荧光草
        name = "medaldug_flower_cave_triple",
		plantname = "flower_cave_triple",
        anim = "medaldug_flower_cave_triple",
		bank_placer = "bulb_plant_triple",
		build_placer = "bulb_plant_triple",
		anim_placer = "off",
		mediumspacing = true,
        floater = {"large", 0.1, 0.55},
    },
	--[[
	{
		--洞穴香蕉
        name = "medaldug_cave_banana_tree",
		plantname = "cave_banana_tree",
        anim = "medaldug_cave_banana",
		bank_placer = "cave_banana_tree",
		build_placer = "cave_banana_tree",
		anim_placer = "idle_loop",
		mediumspacing = false,
        floater = {"large", 0.1, 0.55},
    },
	{
		--洞穴香蕉根，不可种植
        name = "medaldug_cave_banana_stump",
        anim = "medaldug_cave_banana_stump",
		cantplant = true,--不可种植
		floater = {"large", 0.1, 0.55},
		-- plantname = "medal_fruit_tree_stump",
		-- bank_placer = "medal_fruit_tree_pomegranate",
		-- build_placer = "medal_fruit_tree_pomegranate",
		-- anim_placer = "idle_stump",
		-- mediumspacing = false,
		-- floater = {"large", 0.1, 0.55},
    },
    ]]
	{
		--仙人掌
        name = "medaldug_cactus",
		plantname = "cactus",
        anim = "medaldug_cactus",
		bank_placer = "cactus",
		build_placer = "cactus",
		anim_placer = "idle",
		mediumspacing = false,
        floater = {"large", 0.1, 0.55},
    },
	{
		--绿洲仙人掌
        name = "medaldug_oasis_cactus",
		plantname = "oasis_cactus",
        anim = "medaldug_oasis_cactus",
		bank_placer = "oasis_cactus",
		build_placer = "oasis_cactus",
		anim_placer = "idle",
		mediumspacing = false,
        floater = {"large", 0.1, 0.55},
    },
	{
		--发光浆果
        name = "medaldug_wormlight_plant",
		plantname = "wormlight_plant",
        anim = "medaldug_wormlight_plant",
		bank_placer = "worm",
		build_placer = "worm",
		anim_placer = "berry_idle",
		mediumspacing = false,
        floater = {"large", 0.1, 0.55},
    },
	{
		--活木苗
        name = "medaldug_livingtree_root",
		plantname = "livingtree_sapling",
        anim = "medaldug_livingtree_root",
		bank_placer = "livingtree_root",
		build_placer = "livingtree_root",
		anim_placer = "placer",
		mediumspacing = true,
        floater = {"large", 0.1, 0.55},
    },
	{
		--洞穴苔藓
        name = "medaldug_lichen",
		plantname = "lichen",
        anim = "medaldug_lichen",
		bank_placer = "algae_bush",
		build_placer = "algae_bush",
		anim_placer = "idle",
		mediumspacing = true,
        floater = {"large", 0.1, 0.55},
    },
	{
		--砧木树桩
        name = "medaldug_fruit_tree_stump",
        anim = "medaldug_fruit_tree_stump",
		plantname = "medal_fruit_tree_stump",
		bank_placer = "medal_fruit_tree_pomegranate",
		build_placer = "medal_fruit_tree_pomegranate",
		anim_placer = "idle_stump",
		mediumspacing = false,
		floater = {"large", 0.1, 0.55},
    },
	{
		--荧光虫草
        name = "medaldug_lightflier_flower",
		plantname = "lightflier_flower",
        anim = "medaldug_lightflier_flower",
		bank_placer = "bulb_plant_springy",
		build_placer = "bulb_plant_springy",
		anim_placer = "off",
		mediumspacing = true,
        floater = {"large", 0.1, 0.55},
    },
}

return plantables
