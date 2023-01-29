local ndnr_items = {
    "ndnr_milk",
    "ndnr_ice_milk",
    "ndnr_magma_milk",
    "ndnr_obsidian",
    "ndnr_cutlass",
    "ndnr_dead_swordfish",
    "ndnr_godtoken",
    "ndnr_weatherpole",
    "ndnr_purpleweatherpole",
    "ndnr_redweatherpole",
    "ndnr_blueweatherpole",
    "ndnr_armorobsidian",
    "ndnr_dragoonheart",
    "ndnr_obsidianaxe",
    "ndnr_spear_obsidian",
    "ndnr_snakeoil",
    "ndnr_mushroom_wine",
    "ndnr_venomgland",
    "ndnr_antivenom",
    "ndnr_bigtooth",
    "ndnr_dragoonheartlavaeegg",
    "ndnr_alloy",
    "ndnr_firenettle_seed",
    "ndnr_forgetmelots_seed",
    "ndnr_tillweed_seed",
    "ndnr_waterdrop",
    "ndnr_coffeebean",
    "dug_ndnr_coffeebush",
    "ndnr_coffee",
    "ndnr_coffeebean_cooked",
    "ndnr_yogurt",
    "ndnr_corruptionstaff",
    "ndnr_energy_core",
    "ndnr_antibiotic",
    "ndnr_pagodasugar",
    "ndnr_shark_teethhat",
    "ndnr_waterballoon",
    "ndnr_tentacleblood",
    "dish_medicinalliquor",
    "ndnr_snakewine",
    "ndnr_chinesefood",
    "ndnr_palmleaf",
    "ndnr_coconut",
    "ndnr_coconut_cooked",
    "ndnr_coconut_halved",
    "ndnr_coconutjuice",
    "ndnr_sharkfin",
    "ndnr_aerodynamichat",
    "ndnr_iron",
    "ndnr_alloyspear",
    "ndnr_alloyaxe",
    "ndnr_alloypickaxe",
    "ndnr_alloyshovel",
    "ndnr_alloyhammer",
    "ndnr_snake",
    "ndnr_palmleaf_umbrella",
    "ndnr_thatchpack",
    "ndnr_spice_smelly",
    "ndnr_tomato_egg",
    "ndnr_shrimppullegg",
    "ndnr_bounty",
    "ndnr_dongpopork",
    "ndnr_icecream",
    "ndnr_haagendazs",
    "ndnr_figpudding",
    "ndnr_kopiluwak",
    "ndnr_steamedporkdumplings",
    "ndnr_wonton",
    "ndnr_catpoop",
    "ndnr_pineapplebun",
    "ndnr_puff",
    "ndnr_creamballsoup",
    "ndnr_scallop",
    "ndnr_scallop_cooked",
    "ndnr_scallopsoup",
    "ndnr_coconutchicken",
    "ndnr_balut",
    "ndnr_stewedmushroom",
    "ndnr_seatreasure",
    "ndnr_roughrock",
    "ndnr_roe",
    "ndnr_roe_cooked",
    "ndnr_opalpreciousamulet",
    "ndnr_hambat",
    "ndnr_soybean",
    "ndnr_soybean_seeds",
    "ndnr_tofu",
    "ndnr_stinkytofu",
    "ndnr_soybeanmeal",
    "ndnr_soybeanmilk1",
    "ndnr_soybeanmilk2",
    "ndnr_iceball",
    "ndnr_tar",
    "ndnr_quackendrill_item",
    "ndnr_quackenbeak",
    "turf_ndnr_asphalt",
    "ndnr_snakeskin",
    "turf_ndnr_snakeskinfloor",
    "ndnr_armor_snakeskin",
    "hat_ndnr_snakeskin",
    "ndnr_alloyhoe",
}

local function draw(inst)
    if not TheWorld.ismastersim then return inst end

	if inst.components.drawable then
		local oldondrawnfn = inst.components.drawable.ondrawnfn or nil
		inst.components.drawable.ondrawnfn = function(inst, image, src, atlas, bgimage, bgatlas)
            if oldondrawnfn ~= nil then
                oldondrawnfn(inst, image, src, atlas, bgimage, bgatlas)
            end
            if image ~= nil and table.contains(ndnr_items, image) then
                inst.AnimState:OverrideSymbol("SWAP_SIGN", resolvefilepath(atlas), image..".tex")
            end
        end
	end
end
AddPrefabPostInit("minisign", draw)
AddPrefabPostInit("minisign_drawn", draw)

---------------------------------------------------------------------------------------------------

local minimap_items = {
    "ndnr_mandrakehouse",
    "ndnr_coffeebush",
    "ndnr_smelter",
    "ndnr_city_lamp",
    "ndnr_obsidianfirepit",
    "ndnr_palmtree",
    "ndnr_rock_iron",
    "ndnr_palmleaf_hut",
    "ndnr_thatchpack",
    "ndnr_armorvortexcloak",
    "ndnr_fishfarm",
    "ndnr_wormhole",
    "ndnr_lifeplant",
    "ndnr_treasurechest_root",
    "ndnr_sprinkler",
    "ndnr_tar_pool",
    "ndnr_tar_extractor",
}

for i, v in ipairs(minimap_items) do
    AddMinimapAtlas("images/"..v..".xml")
end