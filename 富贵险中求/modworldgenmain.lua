GLOBAL.setmetatable(env, {__index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end})

-- local StaticLayout = require("map/static_layout")
-- local Layouts = require("map/layouts").Layouts

-- if Layouts["Oasis"] ~= nil then
--     Layouts["Oasis"] = StaticLayout.Get("map/static_layouts/ndnr_oasis",
-- 	{
-- 		start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
-- 		fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
-- 		layout_position = LAYOUT_POSITION.CENTER,
-- 		disable_transform = true
-- 	})
-- end

-- AddRoomPreInit("LightningBluffOasis", function(room)
-- 	-- room.contents.countprefabs = {
-- 	-- 	ndnr_palmtree = 12,
-- 	-- }
-- 	room.contents.distributeprefabs.ndnr_palmtree = 0.2
-- end)

-- AddRoomPreInit("BGLightningBluff", function(room)
-- 	-- room.contents.countprefabs = {
-- 	-- 	ndnr_palmtree = 12,
-- 	-- }
-- 	room.contents.distributeprefabs.ndnr_palmtree = 10
-- end)

--[[
    地皮相关代码借鉴【抄】的永不妥协

    官方留给mod的地皮ID 70-109
    富贵用了77，78
    樱花林用了95，96，97，98
    永不妥协用了102，110
    神话用了29
    Hamlet Turfs用了81，82，83，84，85，86，87，88，89
    -----------------------------------------------------------------------------------------------
    Not Enough Turfs用了 60，61，62，63，64，65，67，68，69，70，71，72，73，74，75，76，77，78，79，80，
                        81，82，83，84，85，86，87，90，91，92，93，94，99，100，101，102，103，104，105，
                        106，107，108，109，110，111，112，113，114，115，116，117，118，119
    可以看到仅去掉了樱花林的地皮编号，且占用了官方留给mod的所有地皮编号，所以富贵与之不兼容
    -----------------------------------------------------------------------------------------------
]]

local GROUND_OCEAN_COLOR = -- Color for the main island ground tiles 
{ 
    primary_color =         {  0,   0,   0,  25 }, 
    secondary_color =       { 0,  20,  33,  0 }, 
    secondary_color_dusk =  { 0,  20,  33,  80 }, 
    minimap_color =         { 46,  32,  18,  64 },
}

if CurrentRelease.GreaterOrEqualTo("R22_PIRATEMONKEYS") then
	AddTile(
		"NDNR_ASPHALT", --tile_name 1
		"LAND", --tile_range 2
		{ --tile_data 3
			ground_name = "ndnr_asphalt",
			old_static_id = 77,
		}, 
		{ --ground_tile_def 4
			name = "ndnr_asphalt.tex", 
			atlas = "ndnr_asphalt.xml", 
			noise_texture = "ndnr_asphalt_noise.tex",
			runsound = "dontstarve/movement/walk_grass",
			walksound = "dontstarve/movement/walk_grass",
			snowsound = "dontstarve/movement/run_snow",
			mudsound = "dontstarve/movement/run_mud",
			colors = GROUND_OCEAN_COLOR
		},
		{ --minimap_tile_def 5
			name = "map_edge",
			-- atlas = "ndnr_asphalt.xml",
			noise_texture = "ndnr_asphalt_noise.tex"
		},
		{ --turf_def 6
			name = "ndnr_asphalt",
			anim = "asphalt",
			bank_build = "ndnr_turf"
		}
	)

	AddTile(
		"NDNR_SNAKESKIN", 
		"LAND", 
		{
			ground_name = "ndnr_snakeskinfloor",
			old_static_id = 78,
		}, 
		{ 
			name = "ndnr_snakeskinfloor.tex", 
			atlas = "ndnr_snakeskinfloor.xml", 
			noise_texture = "ndnr_noise_snakeskinfloor.tex",
			runsound = "dontstarve/movement/walk_grass",
			walksound = "dontstarve/movement/walk_grass",
			snowsound = "dontstarve/movement/run_snow",
			mudsound = "dontstarve/movement/run_mud",
			colors = GROUND_OCEAN_COLOR
		},
		{
			name = "map_edge.tex",
			-- atlas = "ndnr_snakeskinfloor.xml",
			noise_texture = "ndnr_noise_snakeskinfloor.tex"
		},
		{
			name = "ndnr_snakeskinfloor",
			anim = "snakeskin",
			bank_build = "ndnr_turf"
		}
	)

	ChangeTileRenderOrder(WORLD_TILES.NDNR_ASPHALT, WORLD_TILES.ROAD)
	ChangeTileRenderOrder(WORLD_TILES.NDNR_SNAKESKIN, WORLD_TILES.CARPET)

	ChangeMiniMapTileRenderOrder(WORLD_TILES.NDNR_ASPHALT, WORLD_TILES.ROAD)
	ChangeMiniMapTileRenderOrder(WORLD_TILES.NDNR_SNAKESKIN, WORLD_TILES.CARPET)
else
    ------Turf Using Tile Adder From ADM's Turf Mod
    modimport("tile_adder.lua")
    local GROUND_OCEAN_COLOR = -- Color for the main island ground tiles
    {
        primary_color =         {  0,   0,   0,  25 },
        secondary_color =       { 0,  20,  33,  0 },
        secondary_color_dusk =  { 0,  20,  33,  80 },
        minimap_color =         { 46,  32,  18,  64 },
    }
    AddTile(
        "NDNR_ASPHALT",
        77,
        "ndnr_asphalt",
        {
            noise_texture = "levels/textures/ndnr_asphalt_noise.tex",
            runsound = "dontstarve/movement/run_dirt",
            walksound = "dontstarve/movement/walk_dirt",
            snowsound = "dontstarve/movement/run_ice",
            mudsound = "dontstarve/movement/run_mud",
            colors = GROUND_OCEAN_COLOR,
        },
        {noise_texture = "levels/textures/ndnr_asphalt_noise.tex"}
    )
    AddTile(
        "NDNR_SNAKESKIN",
        78,
        "ndnr_snakeskinfloor",
        {
            noise_texture = "levels/textures/ndnr_noise_snakeskinfloor.tex",
            runsound = "dontstarve/movement/run_carpet",
            walksound = "dontstarve/movement/walk_carpet",
            snowsound = "dontstarve/movement/run_snow",
            mudsound = "dontstarve/movement/run_mud",
            colors = GROUND_OCEAN_COLOR,
        },
        {noise_texture = "levels/textures/ndnr_noise_snakeskinfloor.tex"}
    )


	local worldtiledefs = require 'worldtiledefs'

	local MOD_TURF_PROPERTIES =
	{
		[GROUND.NDNR_ASPHALT] = { name = "ndnr_asphalt",            anim = "asphalt"           ,   bank_build = "ndnr_turf" },
		[GROUND.NDNR_SNAKESKIN] = { name = "ndnr_snakeskinfloor",		 anim = "snakeskin"           ,   bank_build = "ndnr_turf"	},
	}

	for k, v in pairs(MOD_TURF_PROPERTIES) do
		worldtiledefs.turf[k] = MOD_TURF_PROPERTIES[k]
	end

	ChangeTileTypeRenderOrder(GLOBAL.GROUND.NDNR_ASPHALT, GLOBAL.GROUND.ROAD)
	ChangeTileTypeRenderOrder(GLOBAL.GROUND.NDNR_SNAKESKIN, GLOBAL.GROUND.CARPET)
end





