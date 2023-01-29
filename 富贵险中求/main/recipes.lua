-- 辅助定义制作方式的函数
local function CheckTile(pt, tile)
    local ground_tile = TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
	return ground_tile and ground_tile == tile
end

AddRecipe2(
    "ndnr_obsidianfirepit",
    {Ingredient("log", 3), Ingredient("ndnr_obsidian", 8, "images/ndnr_obsidian.xml")},
    TECH.SCIENCE_TWO,
    {
        placer="ndnr_obsidianfirepit_placer",
        atlas="images/ndnr_obsidianfirepit.xml",
        image="ndnr_obsidianfirepit.tex",
    },
    {"LIGHT", "WINTER", "COOKING"}
)
AddRecipe2(
    "ndnr_cutlass",
    {Ingredient("ndnr_dead_swordfish", 1, "images/ndnr_dead_swordfish.xml"), Ingredient("goldnugget", 2), Ingredient("twigs", 1)},
    TECH.SCIENCE_TWO,
    {
        atlas="images/ndnr_cutlass.xml",
        image="ndnr_cutlass.tex",
    },
    {"WEAPONS"}
)
AddRecipe2(
    "ndnr_armorobsidian",
    {Ingredient("ndnr_obsidian", 5, "images/ndnr_obsidian.xml"), Ingredient("armorwood", 1), Ingredient("ndnr_dragoonheart", 1, "images/ndnr_dragoonheart.xml")},
    TECH.SCIENCE_TWO,
    {
        atlas="images/ndnr_armorobsidian.xml",
        image="ndnr_armorobsidian.tex",
    },
    {"ARMOUR"}
)
AddRecipe2(
    "ndnr_obsidianaxe",
    {Ingredient("ndnr_obsidian", 2, "images/ndnr_obsidian.xml"), Ingredient("axe", 1), Ingredient("ndnr_dragoonheart", 1, "images/ndnr_dragoonheart.xml")},
    TECH.SCIENCE_TWO,
    {
        atlas="images/ndnr_obsidianaxe.xml",
        image="ndnr_obsidianaxe.tex",
    },
    {"TOOLS"}
)
AddRecipe2(
    "ndnr_spear_obsidian",
    {Ingredient("ndnr_obsidian", 3, "images/ndnr_obsidian.xml"), Ingredient("spear", 1), Ingredient("ndnr_dragoonheart", 1, "images/ndnr_dragoonheart.xml")},
    TECH.SCIENCE_TWO,
    {
        atlas="images/ndnr_spear_obsidian.xml",
        image="ndnr_spear_obsidian.tex",
    },
    {"WEAPONS"}
)
AddRecipe2(
    "ndnr_antivenom",
    {Ingredient("ndnr_venomgland", 1, "images/ndnr_venomgland.xml"), Ingredient("kelp", 3), Ingredient("slurtle_shellpieces", 2)},
    TECH.SCIENCE_ONE,
    {
        atlas="images/ndnr_antivenom.xml",
        image="ndnr_antivenom.tex",
    },
    {"RESTORATION"}
)
AddRecipe2(
    "houndmound",
    {Ingredient("ndnr_bigtooth", 2, "images/ndnr_bigtooth.xml"), Ingredient("houndstooth", 6), Ingredient("boneshard", 4)},
    TECH.LOST,
    {
        placer="ndnr_houndmound_placer",
        atlas="images/ndnr_houndmound.xml",
        image="ndnr_houndmound.tex",
    },
    {"STRUCTURES"}
)
AddRecipe2(
    "ndnr_city_lamp",
    {Ingredient("ndnr_alloy", 1, "images/ndnr_alloy.xml"), Ingredient("transistor", 1), Ingredient("lantern", 1)},
    TECH.SCIENCE_TWO,
    {
        placer="ndnr_city_lamp_placer",
        atlas="images/ndnr_city_lamp.xml",
        image="ndnr_city_lamp.tex",
        min_spacing=0,
    },
    {"LIGHT", "STRUCTURES"}
)
AddRecipe2(
    "tallbirdnest",
    {Ingredient("twigs", 10), Ingredient("cutgrass", 10), Ingredient("smallbird", 1, "images/ndnr_smallbird.xml")},
    TECH.LOST,
    {
        placer="ndnr_tallbirdnest_placer",
        atlas="images/ndnr_tallbirdnest.xml",
        image="ndnr_tallbirdnest.tex",
        testfn = function (pt)
            local CanPlace = CheckTile(pt, WORLD_TILES.ROCKY) or CheckTile(pt, WORLD_TILES.DIRT)
            return CanPlace
        end
    },
    {"STRUCTURES"}
)
AddRecipe2(
    "ndnr_corruptionstaff",
    {Ingredient("shroom_skin", 1), Ingredient("greenstaff", 1), Ingredient("goldnugget", 6)},
    TECH.LOST,
    {
        atlas="images/ndnr_corruptionstaff.xml",
        image="ndnr_corruptionstaff.tex",
    },
    {"MAGIC"}
)
AddRecipe2(
    "pigtorch",
    {Ingredient("log", 6), Ingredient("poop", 2)},
    TECH.LOST,
    {
        placer="ndnr_pigtorch_placer",
        atlas="images/ndnr_pigtorch.xml",
        image="ndnr_pigtorch.tex",
    },
    {"STRUCTURES"}
)
-- AddRecipe(
--     "ndnr_antibiotic",
--     {Ingredient("foliage", 3), Ingredient("cutlichen", 2), Ingredient("stinger", 1)},
--     RECIPETABS.SURVIVAL,
--     TECH.SCIENCE_TWO,
--     nil, nil, nil, nil, nil,
--     "images/ndnr_antibiotic.xml",
--     "ndnr_antibiotic.tex"
-- )
AddRecipe2(
    "ndnr_pagodasugar",
    {Ingredient("petals_evil", 3), Ingredient("honey", 1)},
    TECH.SCIENCE_TWO,
    {
        atlas="images/ndnr_pagodasugar.xml",
        image="ndnr_pagodasugar.tex",
    },
    {"RESTORATION"}
)
AddRecipe2(
    "slurtlehole",
    {Ingredient("slurtleslime", 6), Ingredient("slurtle_shellpieces", 2)},
    TECH.LOST,
    {
        placer="ndnr_slurtlehole_placer",
        atlas="images/ndnr_slurtlehole.xml",
        image="ndnr_slurtlehole.tex",
    },
    {"STRUCTURES"}
)
AddRecipe2(
    "ndnr_mandrakehouse",
    {Ingredient("boards", 4), Ingredient("mandrake", 2), Ingredient("livinglog", 6)},
    TECH.SCIENCE_TWO,
    {
        placer="ndnr_mandrakehouse_placer",
        atlas="images/ndnr_mandrakehouse.xml",
        image="ndnr_mandrakehouse.tex",
    },
    {"STRUCTURES"}
)
AddRecipe2(
    "ndnr_shark_teethhat",
    {Ingredient("ndnr_bigtooth", 1, "images/ndnr_bigtooth.xml"), Ingredient("goldnugget", 1), Ingredient("houndstooth", 5)},
    TECH.SCIENCE_TWO,
    {
        atlas="images/ndnr_shark_teethhat.xml",
        image="ndnr_shark_teethhat.tex",
    },
    {"CLOTHING"}
)
AddRecipe2(
    "ndnr_waterballoon",
    {Ingredient("ndnr_waterdrop", 1, "images/ndnr_waterdrop.xml"), Ingredient("mosquitosack", 2)},
    TECH.SCIENCE_TWO,
    {
        atlas="images/ndnr_waterballoon.xml",
        image="ndnr_waterballoon.tex",
    },
    {"SUMMER", "WEAPONS"}
)
AddRecipe2(
    "ndnr_aerodynamichat",
    {Ingredient("ndnr_sharkfin", 1, "images/ndnr_sharkfin.xml"), Ingredient("manrabbit_tail", 2), Ingredient("silk", 3)},
    TECH.SCIENCE_TWO,
    {
        atlas="images/ndnr_aerodynamichat.xml",
        image="ndnr_aerodynamichat.tex",
    },
    {"CLOTHING"}
)
AddRecipe2(
    "ndnr_alloyaxe",
    {Ingredient("ndnr_alloy", 2, "images/ndnr_alloy.xml"), Ingredient("log", 2)},
    TECH.SCIENCE_TWO,
    {
        atlas="images/ndnr_alloyaxe.xml",
        image="ndnr_alloyaxe.tex",
    },
    {"TOOLS"}
)
AddRecipe2(
    "ndnr_alloypickaxe",
    {Ingredient("ndnr_alloy", 2, "images/ndnr_alloy.xml"), Ingredient("log", 2)},
    TECH.SCIENCE_TWO,
    {
        atlas="images/ndnr_alloypickaxe.xml",
        image="ndnr_alloypickaxe.tex",
    },
    {"TOOLS"}
)
AddRecipe2(
    "ndnr_alloyshovel",
    {Ingredient("ndnr_alloy", 2, "images/ndnr_alloy.xml"), Ingredient("log", 2)},
    TECH.SCIENCE_TWO,
    {
        atlas="images/ndnr_alloyshovel.xml",
        image="ndnr_alloyshovel.tex",
    },
    {"TOOLS"}
)
AddRecipe2(
    "ndnr_alloyhammer",
    {Ingredient("ndnr_alloy", 2, "images/ndnr_alloy.xml"), Ingredient("log", 2), Ingredient("cutgrass", 6)},
    TECH.SCIENCE_TWO,
    {
        atlas="images/ndnr_alloyhammer.xml",
        image="ndnr_alloyhammer.tex",
    },
    {"TOOLS"}
)
AddRecipe2(
    "ndnr_alloyhoe",
    {Ingredient("ndnr_alloy", 2, "images/ndnr_alloy.xml"), Ingredient("log", 2)},
    TECH.SCIENCE_TWO,
    {
        atlas="images/ndnr_alloyhoe.xml",
        image="ndnr_alloyhoe.tex",
    },
    {"TOOLS"}
)
AddRecipe2(
    "ndnr_alloyspear",
    {Ingredient("ndnr_alloy", 2, "images/ndnr_alloy.xml"), Ingredient("goldnugget", 2), Ingredient("log", 2)},
    TECH.SCIENCE_TWO,
    {
        atlas="images/ndnr_alloyspear.xml",
        image="ndnr_alloyspear.tex",
    },
    {"WEAPONS"}
)
AddRecipe2(
    "ndnr_palmleaf_umbrella",
    {Ingredient("ndnr_palmleaf", 3, "images/ndnr_palmleaf.xml"), Ingredient("twigs", 4), Ingredient("petals", 6)},
    TECH.NONE,
    {
        atlas="images/ndnr_palmleaf_umbrella.xml",
        image="ndnr_palmleaf_umbrella.tex",
    },
    {"CLOTHING", "SUMMER", "RAIN"}
)
AddRecipe2(
    "ndnr_palmleaf_hut",
    {Ingredient("ndnr_palmleaf", 4, "images/ndnr_palmleaf.xml"), Ingredient("twigs", 4), Ingredient("rope", 3)},
    TECH.SCIENCE_TWO,
    {
        placer="ndnr_palmleaf_hut_placer",
        atlas="images/ndnr_palmleaf_hut.xml",
        image="ndnr_palmleaf_hut.tex",
    },
    {"STRUCTURES", "SUMMER", "RAIN"}
)
AddRecipe2(
    "monkeybarrel",
    {Ingredient("poop", 4), Ingredient("cave_banana", 4), Ingredient("boards", 3)},
    TECH.LOST,
    {
        placer="ndnr_monkeybarrel_placer",
        atlas="images/ndnr_monkeybarrel.xml",
        image="ndnr_monkeybarrel.tex",
    },
    {"STRUCTURES"}
)
AddRecipe2(
    "wobster_den",
    {Ingredient("wobster_sheller_land", 2), Ingredient("rocks", 10), Ingredient("kelp", 10)},
    TECH.LOST,
    {
        placer="ndnr_wobster_den_placer",
        atlas="images/ndnr_wobster_den.xml",
        image="ndnr_wobster_den.tex",
        build_mode=BUILDMODE.WATER
    },
    {"STRUCTURES"}
)
AddRecipe2(
    "moonglass_wobster_den",
    {Ingredient("wobster_moonglass_land", 2), Ingredient("rocks", 10), Ingredient("kelp", 10)},
    TECH.LOST,
    {
        placer="ndnr_wobster_moonglass_land_placer",
        atlas="images/ndnr_wobster_moonglass_land.xml",
        image="ndnr_wobster_moonglass_land.tex",
        build_mode=BUILDMODE.WATER
    },
    {"STRUCTURES"}
)
AddRecipe2(
    "ndnr_thatchpack",
    {Ingredient("ndnr_palmleaf", 4, "images/ndnr_palmleaf.xml")},
    TECH.NONE,
    {
        atlas="images/ndnr_thatchpack.xml",
        image="ndnr_thatchpack.tex",
    },
    {"CONTAINERS"}
)
AddRecipe2(
    "ndnr_spice_smelly",
    {Ingredient("durian", 3)},
    TECH.FOODPROCESSING_ONE,
    {
        atlas="images/ndnr_spice_smelly.xml",
        image="ndnr_spice_smelly.tex",
        nounlock=true,
        numtogive=2,
        builder_tag="professionalchef",
    },
    {"CRAFTING_STATION"}
)
AddRecipe2(
    "ndnr_soybeanmeal",
    {Ingredient("ndnr_soybean", 3)},
    TECH.FOODPROCESSING_ONE,
    {
        atlas="images/ndnr_soybeanmeal.xml",
        image="ndnr_soybeanmeal.tex",
        nounlock=true,
        numtogive=2,
        builder_tag="professionalchef",
    },
    {"CRAFTING_STATION"}
)
AddRecipe2(
    "catcoonden",
    {Ingredient("log", 4), Ingredient("twigs", 4), Ingredient("coontail", 1)},
    TECH.LOST,
    {
        placer="ndnr_catcoonden_placer",
        atlas="images/ndnr_catcoonden.xml",
        image="ndnr_catcoonden.tex",
        testfn = function (pt)
            local CanPlace = CheckTile(pt, WORLD_TILES.DECIDUOUS)
            return CanPlace
        end
    },
    {"STRUCTURES"}
)
AddRecipe2(
    "ndnr_toadstoolchest",
    {Ingredient("shroom_skin", 1), Ingredient("boards", 4), Ingredient("goldnugget", 10)},
    TECH.SCIENCE_TWO,
    {
        placer="ndnr_toadstoolchest_placer",
        atlas="images/ndnr_toadstoolchest.xml",
        image="ndnr_toadstoolchest.tex",
        min_spacing=1.5,
    },
    {"CONTAINERS"}
)
AddRecipe2(
    "ancient_altar",
    {Ingredient("thulecite", 10), Ingredient("purplegem", 2), Ingredient("gears", 4)},
    TECH.LOST,
    {
        placer="ndnr_ancient_altar_placer",
        atlas="images/ndnr_ancient_altar.xml",
        image="ndnr_ancient_altar.tex",
    },
    {"PROTOTYPERS"}
)
AddRecipe2(
    "meatrack_hermit",
    {Ingredient("twigs", 3),Ingredient("charcoal", 2), Ingredient("rope", 3)},
    TECH.LOST,
    {
        placer="ndnr_meatrack_hermit_placer",
        atlas="images/ndnr_meatrack_hermit.xml",
        image="ndnr_meatrack_hermit.tex",
    },
    {"COOKING"}
)
AddRecipe2(
    "beebox_hermit",
    {Ingredient("boards", 2),Ingredient("honeycomb", 1),Ingredient("bee", 4)},
    TECH.LOST,
    {
        placer="ndnr_beebox_hermit_placer",
        atlas="images/ndnr_beebox_hermit.xml",
        image="ndnr_beebox_hermit.tex",
    },
    {"GARDENING"}
)
AddRecipe2(
    "ndnr_smelter",
    {Ingredient("cutstone", 6), Ingredient("boards", 4), Ingredient("redgem", 1)},
    TECH.LOST,
    {
        placer="ndnr_smelter_placer",
        atlas="images/ndnr_smelter.xml",
        image="ndnr_smelter.tex",
    },
    {"STRUCTURES", "PROTOTYPERS"}
)
AddRecipe2(
    "ndnr_fishfarm",
    {Ingredient("rope", 2), Ingredient("silk", 2), Ingredient("ndnr_coconut", 4)},
    TECH.LOST,
    {
        placer="ndnr_fishfarm_placer",
        atlas="images/ndnr_fishfarm.xml",
        image="ndnr_fishfarm.tex",
        build_mode=BUILDMODE.WATER,
        min_spacing=5.2,
    },
    {"COOKING", "FISHING"}
)
AddRecipe2(
    "ndnr_hermitshop_meatrack_hermit_blueprint",
    {Ingredient("messagebottleempty", 2)},
    TECH.HERMITCRABSHOP_THREE,
    {
        sg_state="give",
        nounlock=true,
        image="blueprint_rare.tex",
        product="meatrack_hermit_blueprint",
    },
    {"CRAFTING_STATION"}
)
AddRecipe2(
    "ndnr_hermitshop_beebox_hermit_blueprint",
    {Ingredient("messagebottleempty", 2)},
    TECH.HERMITCRABSHOP_THREE,
    {
        sg_state="give",
        nounlock=true,
        image="blueprint_rare.tex",
        product="beebox_hermit_blueprint",
    },
    {"CRAFTING_STATION"}
)
AddRecipe2(
    "ndnr_hermitshop_smelter_blueprint",
    {Ingredient("messagebottleempty", 4)},
    TECH.HERMITCRABSHOP_FIVE,
    {
        sg_state="give",
        nounlock=true,
        image="blueprint_rare.tex",
        product="ndnr_smelter_blueprint",
    },
    {"CRAFTING_STATION"}
)

AddRecipe2(
    "ndnr_hermitshop_fishfarm_blueprint",
    {Ingredient("messagebottleempty", 4)},
    TECH.HERMITCRABSHOP_SEVEN,
    {
        sg_state="give",
        nounlock=true,
        image="blueprint_rare.tex",
        product="ndnr_fishfarm_blueprint",
    },
    {"CRAFTING_STATION"}
)
AddRecipe2(
    "ndnr_opalpreciousamulet",
    {Ingredient("opalpreciousgem", 1), Ingredient("thulecite", 2), Ingredient("nightmarefuel", 4)},
    TECH.LOST,
    {
        atlas="images/ndnr_opalpreciousamulet.xml",
        image="ndnr_opalpreciousamulet.tex",
    },
    {"MAGIC"}
)
AddRecipe2(
    "ndnr_treasurechest_root",
    {Ingredient("lureplantbulb", 1), Ingredient("greengem", 1), Ingredient("boards", 3)},
    TECH.MAGIC_TWO,
    {
        builder_tag="plantkin",
        placer="ndnr_treasurechest_root_placer",
        atlas="images/ndnr_treasurechest_root.xml",
        image="ndnr_treasurechest_root.tex",
        min_spacing=1,
        testfn=function(pt) return not TheWorld.Map:IsOceanAtPoint(pt.x, 0, pt.z, true) end
    },
    {"CHARACTER"}
)
AddRecipe2(
    "archive_cookpot",
    {Ingredient("thulecite", 1), Ingredient("charcoal", 6), Ingredient("twigs", 6)},
    TECH.LOST,
    {
        placer="ndnr_archive_cookpot_placer",
        atlas="images/ndnr_archive_cookpot.xml",
        image="ndnr_archive_cookpot.tex",
    },
    {"COOKING"}
)
AddRecipe2(
    "ndnr_sprinkler",
    {Ingredient("ndnr_alloy", 2, "images/ndnr_alloy.xml"), Ingredient("bluegem", 1), Ingredient("ice", 6)},
    TECH.SCIENCE_TWO,
    {
        placer="ndnr_sprinkler_placer",
        atlas="images/ndnr_sprinkler.xml",
        image="ndnr_sprinkler.tex",
        testfn=function(pt)
            -- 这检测打开在放置时会特别卡

            -- local range = 20

            -- local min_sq_dist = 999999999999
            -- local best_point = nil

            -- for x = pt.x - range, pt.x + range, 1 do
            --     for z = pt.z - range, pt.z + range, 1 do
            --         local tile = TheWorld.Map:GetTileAtPoint(x, 0, z)

            --         if IsOceanTile(tile) then
            --             local cur_point = Vector3(x, 0, z)
            --             local cur_sq_dist = cur_point:DistSq(pt)

            --             if cur_sq_dist < min_sq_dist then
            --                 min_sq_dist = cur_sq_dist
            --                 best_point = cur_point
            --             end
            --         end
            --     end
            -- end

            return not TheWorld.Map:IsOceanAtPoint(pt.x, 0, pt.z, true) --and best_point ~= nil
        end
    },
    {"GARDENING", "SUMMER", "STRUCTURES"}
)
AddRecipe2(
    "ndnr_tar_extractor",
    {Ingredient("ndnr_coconut", 2), Ingredient("transistor", 4), Ingredient("cutstone", 4)},
    TECH.SCIENCE_TWO,
    {
        placer="ndnr_tar_extractor_placer",
        atlas="images/ndnr_tar_extractor.xml",
        image="ndnr_tar_extractor.tex",
        min_spacing=0,
        build_mode=BUILDMODE.WATER,
        testfn = function(pt)
            local ents = TheWorld.Map:GetEntitiesOnTileAtPoint(pt.x, 0, pt.z)
            for _, v in ipairs(ents) do
                if v:HasTag("ndnr_tar_source") then
                    return true
                end
            end
            return false
        end
    },
    {"STRUCTURES"}
)
AddRecipe2(
    "ndnr_quackendrill_item",
    {Ingredient("ndnr_quackenbeak", 1, "images/ndnr_quackenbeak.xml"), Ingredient("gears", 1), Ingredient("transistor", 2)},
    TECH.SCIENCE_TWO,
    {
        atlas="images/ndnr_quackendrill_item.xml",
        image="ndnr_quackendrill_item.tex",
    },
    {"TOOLS"}
)
AddRecipe2(
    "turf_ndnr_asphalt",
    {Ingredient("ndnr_tar", 1, "images/ndnr_tar.xml"), Ingredient("rocks", 3)},
    TECH.SCIENCE_TWO,
    {
        numtogive=4,
        atlas="images/turf_ndnr_asphalt.xml",
        image="turf_ndnr_asphalt.tex",
    },
    {"DECOR"}
)
AddRecipe2(
    "turf_ndnr_snakeskinfloor",
    {Ingredient("ndnr_snakeskin", 2, "images/ndnr_snakeskin.xml"), Ingredient("beefalowool", 1)},
    TECH.SCIENCE_TWO,
    {
        numtogive=4,
        atlas="images/turf_ndnr_snakeskinfloor.xml",
        image="turf_ndnr_snakeskinfloor.tex",
    },
    {"DECOR"}
)
AddRecipe2(
    "ndnr_snakeskinhat",
    {Ingredient("ndnr_snakeskin", 1, "images/ndnr_snakeskin.xml"), Ingredient("strawhat", 1), Ingredient("boneshard", 1)},
    TECH.SCIENCE_TWO,
    {
        atlas="images/ndnr_snakeskinhat.xml",
        image="ndnr_snakeskinhat.tex",
    },
    {"CLOTHING", "RAIN"}
)
AddRecipe2(
    "ndnr_armor_snakeskin",
    {Ingredient("ndnr_snakeskin", 2, "images/ndnr_snakeskin.xml"), Ingredient("rope", 2), Ingredient("boneshard", 2)},
    TECH.SCIENCE_TWO,
    {
        atlas="images/ndnr_armor_snakeskin.xml",
        image="ndnr_armor_snakeskin.tex",
    },
    {"CLOTHING", "RAIN"}
)


