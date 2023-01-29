GLOBAL.setmetatable(env, {__index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end})

--[[
    local x,y,z = GetPlayer().Transform:GetWorldPosition() local ents = TheSim:FindEntities(x,y,z, 4) for i,v in ipairs(ents) do print(v.prefab) end
    print(DebugSpawn"我的物品":GetDebugString())
    TheWorld > sim > game > player
    ThePlayer.Physics:Teleport(0,0,0)
]]

PrefabFiles = {
    "ndnr_milk",
    "ndnr_ice_milk",
    "ndnr_magma_milk",
    "ndnr_obsidian",
    "ndnr_obsidianfirepit",
    "ndnr_obsidianfirefire",
    "ndnr_cutlass",
    "ndnr_dead_swordfish",
    "ndnr_godtoken",
    "ndnr_weatherpole",
    "ndnr_weatherpoleactive",
    "ndnr_armorobsidian",
    "ndnr_dragoonheart",
    "ndnr_obsidianaxe",
    "ndnr_spear_obsidian",
    "ndnr_snakeoil",
    "ndnr_snake",
    "ndnr_buffs",
    "ndnr_sporeseed",
    "ndnr_venomgland",
    "ndnr_antivenom",
    "ndnr_bigtooth",
    "ndnr_rock_ice",
    "ndnr_alloy",
    "ndnr_smelter",
    "ndnr_city_lamp",
    "ndnr_wall_ruins",
    "ndnr_weed_seeds",
    "ndnr_waterdrop",
    "ndnr_floweroflife",
    "ndnr_coffeebeans",
    "ndnr_coffeebush",
    "ndnr_corruptionstaff",
    "ndnr_energy_core",
    "ndnr_antibiotic",
    "ndnr_pagodasugar",
    "ndnr_mandrakehouse",
    "ndnr_mandrakeman",
    "ndnr_shark_teethhat",
    "ndnr_waterballoon",
    -- "ndnr_waterballoon_splash",
    "ndnr_tentacleblood",
    "ndnr_preparedfoods",
    "ndnr_palmtrees",
    "ndnr_palmleaf",
    "ndnr_coconut",
    "ndnr_fxs",
    "ndnr_sharkfin",
    "ndnr_aerodynamichat",
    "ndnr_rock_iron",
    "ndnr_iron",
    "ndnr_alloyspear",
    "ndnr_alloyaxe",
    "ndnr_alloypickaxe",
    "ndnr_alloyshovel",
    "ndnr_alloyhammer",
    "ndnr_palmleaf_umbrella",
    "ndnr_palmleaf_hut",
    "ndnr_thatchpack",
    "ndnr_spices",
    "ndnr_armor_vortex_cloak",
    "ndnr_bounty",
    "ndnr_catpoop",
    "ndnr_scallop",
    "ndnr_nightmarecreature",
    "ndnr_roughrock",
    "ndnr_treeguard",
    "ndnr_treeguard_coconut",
    "ndnr_fishfarm",
    "ndnr_roe",
    "ndnr_toadstoolchest",
    "ndnr_amulet",
    "ndnr_nightmarefissure",
    "ndnr_wormhole",
    "ndnr_hambat",
    "ndnr_treasurechest",
    "ndnr_placer",
    "ndnr_farm_plants",
    "ndnr_veggies",
    "ndnr_sprinkler",
    "ndnr_water_pipe",
    "ndnr_water_spray",
    "ndnr_raindrop",
    "ndnr_stinkytofu",
    "ndnr_soybeanmeal",
    "ndnr_iceball",
    "ndnr_tar_pool",
    "ndnr_tar_extractor",
    "ndnr_tar",
    "ndnr_quackendrill",
    "ndnr_quackenbeak",
    "ndnr_turfs",
    "ndnr_snakeskin",
    "ndnr_snakeskin_jacket",
    "ndnr_hats",
    "ndnr_alloyhoe",
}

AddReplicableComponent("ndnr_bufftime")
AddReplicableComponent("ndnr_pluckable")
AddReplicableComponent("ndnr_bountytask")
AddReplicableComponent("ndnr_harvestfish")
AddReplicableComponent("ndnr_hoverer")
-- AddReplicableComponent("ndnr_emo")

Assets = {
    Asset("SOUNDPACKAGE", "sound/ndnr.fev"),
    Asset("SOUND", "sound/ndnr_bank00.fsb"),
    Asset("SOUNDPACKAGE", "sound/ndnr_forging.fev"),
    Asset("SOUND", "sound/ndnr_forging_bank00.fsb"),
    Asset("SOUNDPACKAGE", "sound/ndnr_swordfish.fev"),
    Asset("SOUND", "sound/ndnr_swordfish_bank00.fsb"),

    Asset("ANIM", "anim/wound_pig_king.zip"),
    Asset("ANIM", "anim/wound_rhino.zip"),
    Asset("ANIM", "anim/wound_warg.zip"),
    Asset("ANIM", "anim/nohornlightninggoat.zip"),
    Asset("ANIM", "anim/deerclops_noeye.zip"),
    Asset("ANIM", "anim/deerclops_noeye_yule.zip"),
    Asset("ANIM", "anim/badstomach.zip"),
    Asset("ANIM", "anim/swap_worm.zip"),
    Asset("ANIM", "anim/ndnr_goldnugget.zip"),
    Asset("ANIM", "anim/ndnr_eye_shield.zip"),
    Asset("ANIM", "anim/ndnr_eyemaskhat.zip"),
    Asset("ANIM", "anim/ndnr_lucky_goldnugget.zip"),
    Asset("ANIM", "anim/dish_medicinalliquor.zip"),
    Asset("ANIM", "anim/ndnr_bee_angry_build.zip"),
    Asset("ANIM", "anim/ndnr_messagebottleempty.zip"),
    Asset("ANIM", "anim/ndnr_hat_ruins.zip"),
    Asset("ANIM", "anim/ndnr_ruins_bat.zip"),
    
    -- Asset("ANIM", "anim/status_emo.zip"),
    -- Asset("ANIM", "anim/ndnr_nobody_build.zip"),

    Asset("ATLAS", "images/ndnr_houndmound.xml"),
    Asset("IMAGE", "images/ndnr_houndmound.tex"),

    Asset("ATLAS", "images/ndnr_tallbirdnest.xml"),
    Asset("IMAGE", "images/ndnr_tallbirdnest.tex"),

    Asset("ATLAS", "images/ndnr_pigtorch.xml"),
    Asset("IMAGE", "images/ndnr_pigtorch.tex"),

    Asset("ATLAS", "images/ndnr_slurtlehole.xml"),
    Asset("IMAGE", "images/ndnr_slurtlehole.tex"),

    Asset("ATLAS", "images/ndnr_monkeybarrel.xml"),
    Asset("IMAGE", "images/ndnr_monkeybarrel.tex"),

    Asset("ATLAS", "images/ndnr_wobster_den.xml"),
    Asset("IMAGE", "images/ndnr_wobster_den.tex"),

    Asset("ATLAS", "images/ndnr_wobster_moonglass_land.xml"),
    Asset("IMAGE", "images/ndnr_wobster_moonglass_land.tex"),

    Asset("ATLAS", "images/ndnr_catcoonden.xml"),
    Asset("IMAGE", "images/ndnr_catcoonden.tex"),

    Asset("ATLAS", "images/ndnr_ancient_altar.xml"),
    Asset("IMAGE", "images/ndnr_ancient_altar.tex"),

    Asset("ATLAS", "images/ndnr_meatrack_hermit.xml"),
    Asset("IMAGE", "images/ndnr_meatrack_hermit.tex"),

    Asset("ATLAS", "images/ndnr_beebox_hermit.xml"),
    Asset("IMAGE", "images/ndnr_beebox_hermit.tex"),

    Asset("ATLAS", "images/ndnr_roe.xml"),
    Asset("IMAGE", "images/ndnr_roe.tex"),

    Asset("ATLAS", "images/ndnr_archive_cookpot.xml"),
    Asset("IMAGE", "images/ndnr_archive_cookpot.tex"),

    Asset("ATLAS", "images/turf_ndnr_asphalt.xml"),
    Asset("IMAGE", "images/turf_ndnr_asphalt.tex"),

    Asset("ATLAS", "images/turf_ndnr_snakeskinfloor.xml"),
    Asset("IMAGE", "images/turf_ndnr_snakeskinfloor.tex"),

    Asset("ATLAS", "images/ndnr_smallbird.xml"),
    Asset("IMAGE", "images/ndnr_smallbird.tex"),

    Asset("ATLAS", "images/jingzhe.xml"),
    Asset("IMAGE", "images/jingzhe.tex"),
    Asset("ATLAS", "images/qingming.xml"),
    Asset("IMAGE", "images/qingming.tex"),
    Asset("ATLAS", "images/zhongyuan.xml"),
    Asset("IMAGE", "images/zhongyuan.tex"),
    Asset("ATLAS", "images/qixi.xml"),
    Asset("IMAGE", "images/qixi.tex"),
    Asset("ATLAS", "images/dongzhi.xml"),
    Asset("IMAGE", "images/dongzhi.tex"),
    Asset("ATLAS", "images/chunjie.xml"),
    Asset("IMAGE", "images/chunjie.tex"),
}

------------------------------LANG----------------------------

local language = GetModConfigData("language") or "zhs"
modimport("lang/" .. language)

TUNING.NDNR_LANGUAGE = language
TUNING.NDNR_ACTIVE = true -- 判断是否开启了富贵险中求
TUNING.LEGION_ACTIVE = CONFIGS_LEGION ~= nil -- 判断是否开启了棱镜

TUNING.NDNR_MUCHMORECOMFORTABLE = MUCHMORECOMFORTABLE
TUNING.NDNR_POISONHEADACHE = POISONHEADACHE
TUNING.NDNR_CATATTACKBLOODOVER = CATATTACKBLOODOVER
TUNING.NDNR_BEEATTACKBLOODOVER = BEEATTACKBLOODOVER
TUNING.NDNR_GOOD_DRINK = GOOD_DRINK
TUNING.NDNR_GODTOKEN_CARRIER = GODTOKEN_CARRIER
TUNING.NDNR_STRONGFROMDRAGONHEART = STRONGFROMDRAGONHEART
TUNING.NDNR_STRONGOVERFROMDRAGONHEART = STRONGOVERFROMDRAGONHEART
TUNING.NDNR_STRONGFROMDRAGONHEARTLAVAE = STRONGFROMDRAGONHEARTLAVAE
TUNING.NDNR_STRONGOVERFROMDRAGONHEARTLAVAE = STRONGOVERFROMDRAGONHEARTLAVAE
TUNING.NDNR_MONSTERPOISONHEADACHE = MONSTERPOISONHEADACHE
TUNING.NDNR_INFECTIONPOISONFROMMONSTER = INFECTIONPOISONFROMMONSTER
TUNING.NDNR_BAD_MILK = NDNR_BAD_MILK
TUNING.NDNR_PLAGUE = NDNR_PLAGUE
TUNING.NDNR_PIGHOUSE_SLEEPING_DIRTY = PIGHOUSE_SLEEPING_DIRTY
TUNING.NDNR_PIGHOUSE_SLEEPING_COMFORTABLE = PIGHOUSE_SLEEPING_COMFORTABLE
TUNING.NDNR_HERMITHOUSE_SLEEPING_COMFORTABLE = HERMITHOUSE_SLEEPING_COMFORTABLE
TUNING.NDNR_EXPERIMENT_SUCCESS = EXPERIMENT_SUCCESS
TUNING.NDNR_EXPERIMENT_WANDA_SUCCESS = EXPERIMENT_WANDA_SUCCESS
TUNING.NDNR_EXPERIMENT_FAILURE = EXPERIMENT_FAILURE
TUNING.NDNR_MASSAGE_TALKER = MASSAGE_TALKER
TUNING.NDNR_SMEAR_SNAKEOIL = SMEAR_SNAKEOIL
TUNING.NDNR_SMEAR_BUTTER = SMEAR_BUTTER

TUNING.NDNR_NAME_PREFIX_POISONOUS = NAME_PREFIX_POISONOUS
TUNING.NDNR_NAME_PREFIX_POISONED = NAME_PREFIX_POISONED
TUNING.NDNR_NAME_PREFIX_REFINE = NAME_PREFIX_REFINE
TUNING.NDNR_NAME_PREFIX_FOREVER_ICEBOX = NAME_PREFIX_FOREVER_ICEBOX
TUNING.NDNR_NAME_PREFIX_SHADOW_POWER = NAME_PREFIX_SHADOW_POWER

TUNING.NDNR_OBSIDIAN_TOOL_MAXCHARGES = 75
TUNING.NDNR_OBSIDIAN_TOOL_MAXHEAT = 60
TUNING.NDNR_OBSIDIAN_WEAPON_MAXCHARGES = 30
TUNING.NDNR_OBSIDIAN_SPEAR_DAMAGE = TUNING.SPEAR_DAMAGE * 1.5
TUNING.NDNR_OBSIDIANTOOLFACTOR = 2.5

TUNING.NDNR_CHARACTER_HIM = CHARACTER_HIM
TUNING.NDNR_CHARACTER_HER = CHARACTER_HER
TUNING.NDNR_CHARACTER_IT = CHARACTER_IT

TUNING.NDNR_HERMITCRAB_GOT_PEARL_EX = HERMITCRAB_GOT_PEARL_EX
TUNING.NDNR_INFECTED_PLAGUE = NDNR_INFECTED_PLAGUE
TUNING.NDNR_INFECTED_PLAGUE_SERIOUS = NDNR_INFECTED_PLAGUE_SERIOUS
TUNING.NDNR_PARASITE_EAT_FOODS = NDNR_PARASITE_EAT_FOODS
TUNING.NDNR_PARASITE_GONE = NDNR_PARASITE_GONE
TUNING.NDNR_NOPARASITE_EATPAGODASUGAR = NDNR_NOPARASITE_EATPAGODASUGAR
TUNING.NDNR_DISH_MEDICINALLIQUOR_DRUNK = NDNR_DISH_MEDICINALLIQUOR_DRUNK
TUNING.NDNR_REPAIRGRAVE = NDNR_REPAIRGRAVE
TUNING.NDNR_BOUNTY_CONTENT = NDNR_BOUNTY_CONTENT
TUNING.NDNR_BOUNTYTASK_DELIVERYWORDS = NDNR_BOUNTYTASK_DELIVERYWORDS
TUNING.NDNR_BOUNTYTASK_DELIVERYREFUSE = NDNR_BOUNTYTASK_DELIVERYREFUSE
TUNING.NDNR_BOUNTYTASK_DELIVERYFINISH = NDNR_BOUNTYTASK_DELIVERYFINISH
TUNING.NDNR_BOUNTYTASK_TIMEOUT = NDNR_BOUNTYTASK_TIMEOUT
TUNING.NDNR_BOUNTYHUNTER = NDNR_BOUNTYHUNTER

TUNING.NDNR_MANDRAKEMAN_DEFEND_DIST = 30
TUNING.NDNR_MANDRAKEMAN_TARGET_DIST = 10
TUNING.NDNR_MANDRAKEMAN_DAMAGE = 40
TUNING.NDNR_MANDRAKEMAN_HEALTH = 200
TUNING.NDNR_MANDRAKEMAN_ATTACK_PERIOD = 2
TUNING.NDNR_MANDRAKEMAN_RUN_SPEED = 6
TUNING.NDNR_MANDRAKEMAN_WALK_SPEED = 3
TUNING.NDNR_MANDRAKEMAN_PANIC_THRESH = .333
TUNING.NDNR_MANDRAKEMAN_HEALTH_REGEN_PERIOD = 5
TUNING.NDNR_MANDRAKEMAN_HEALTH_REGEN_AMOUNT = (200/120)*5
TUNING.NDNR_MANDRAKEMAN_SEE_MANDRAKE_DIST = 8

TUNING.NDNR_PALMTREEGUARD_MELEE = 5

TUNING.NDNR_PALMTREEGUARD_REAWAKEN_RADIUS = 20
TUNING.NDNR_PALMTREE_COCONUT_CHANCE = 0.01

TUNING.SPICE_MULTIPLIERS.NDNR_SPICE_SMELLY = { HUNGER = 0.5, SANITY = -0.25 }
TUNING.NDNR_FISHFARM_REGROW =
{
    {base=1*TUNING.TOTAL_DAY_TIME, random=TUNING.TOTAL_DAY_TIME/2},
    {base=2*TUNING.TOTAL_DAY_TIME, random=TUNING.TOTAL_DAY_TIME/2},
    {base=3*TUNING.TOTAL_DAY_TIME, random=TUNING.TOTAL_DAY_TIME/2},
    {base=3*TUNING.TOTAL_DAY_TIME, random=TUNING.TOTAL_DAY_TIME/2},
}
TUNING.NDNR_WORMHOLE_WORDS = NDNR_WORMHOLE_WORDS

TUNING.NDNR_ALBUMENPOWDER_START = NDNR_ALBUMENPOWDER_START
TUNING.NDNR_ALBUMENPOWDER_END = NDNR_ALBUMENPOWDER_END

TUNING.NDNR_EPITAPH = NDNR_EPITAPH

TUNING.NDNR_MOISTURE_SPRINKLER_PERCENT_INCREASE_PER_SPRAY = 0.5
--------------------------------------------------------------

modimport("main/const.lua")
modimport("main/utils.lua")
modimport("main/cmphook.lua")
modimport("main/loadingtips.lua")
modimport("main/forest_network.lua")
modimport("main/talker.lua")
modimport("main/op_object.lua")
modimport("main/gestalt.lua")
modimport("main/archive_centipede.lua")
-- modimport("main/moonrockseed.lua")
modimport("main/dragonfly.lua")
modimport("main/playerhud.lua")
modimport("main/player.lua")
modimport("main/frog.lua")
modimport("main/marshbush.lua")
-- modimport("main/sporecloud.lua")
modimport("main/toadstool.lua")
modimport("main/rpc.lua")
modimport("main/houndmound.lua")
modimport("main/poisonmonster.lua")
modimport("main/foodrecipes.lua")
modimport("main/saltrock.lua")
modimport("main/deerclops.lua")
-- modimport("main/hermitcrab.lua")
modimport("main/hats.lua")
modimport("main/minotaur.lua")
modimport("main/hound.lua")
modimport("main/weeds.lua")
modimport("main/papyrus.lua")
modimport("main/blueprint.lua")
modimport("main/tallbirdnest.lua")
modimport("main/dragonflychest.lua")
modimport("main/bufftime.lua")
modimport("main/perd.lua")
modimport("main/spore.lua")
modimport("main/pond.lua")
modimport("main/sewing_tape.lua")
modimport("main/trees.lua")
modimport("main/terraria.lua")
modimport("main/smelteringredient.lua")
modimport("main/housesleep.lua")
-- modimport("main/hermithouse.lua")
modimport("main/recipes.lua")
modimport("main/alterguardian_phase.lua")
modimport("main/icebox.lua")
modimport("main/backpack.lua")
modimport("main/shadowheart.lua")
modimport("main/hambat.lua")
modimport("main/shadowboss.lua")
modimport("main/lucky_goldnugget.lua")
modimport("main/minisign.lua")
modimport("main/parasite.lua")
-- modimport("main/skeletonhat.lua")
-- modimport("main/slurtlehole.lua")
modimport("main/oceantree_pillar.lua")
modimport("main/world.lua")
modimport("main/trident.lua")
-- modimport("main/oasislake.lua")
modimport("main/rubbing_building.lua")
modimport("main/monkeybarrel.lua")
modimport("main/staff.lua")
modimport("main/kelp.lua")
modimport("main/gnarwail_horn.lua")
modimport("main/walrus_camp.lua")
modimport("main/mound.lua")
modimport("main/waterplant.lua")
modimport("main/pigman.lua")
modimport("main/bee.lua")
modimport("main/butter.lua")
modimport("main/character.lua")
modimport("main/forgetmelots.lua")
modimport("main/skeleton.lua")
modimport("main/glommer.lua")
modimport("main/goatmilk.lua")
modimport("main/clockwork.lua")
modimport("main/catcoon.lua")
modimport("main/singingshell.lua")
modimport("main/winona_battery.lua")
modimport("main/hoverer.lua")
modimport("main/wagstaff_npc.lua")
modimport("main/oceanfish.lua")
modimport("main/beebox.lua")
modimport("main/meatrack.lua")
modimport("main/adapter.lua")
modimport("main/krampus_sack.lua")
modimport("main/ash.lua")
modimport("main/gravestone.lua")
modimport("main/cookpot.lua")
modimport("main/farm_plants.lua")
modimport("main/friendlyfruitfly.lua")
modimport("main/waterballoon.lua")
modimport("main/crabking.lua")
-- modimport("main/player_classified.lua")
-- modimport("main/physics.lua")
modimport("main/mushroom_farm.lua")
modimport("main/tallbird.lua")
modimport("main/smallbird.lua")

------------------------------ACTION----------------------------
modimport("main/actions.lua")
----------------------------------------------------------------

















