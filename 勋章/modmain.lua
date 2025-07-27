GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
GLOBAL.MedalAPI = env

TUNING.FUNCTIONAL_MEDAL_IS_OPEN=true--勋章Mod已开启，方便其他Mod读取
TUNING.MEDAL_LANGUAGE=GetModConfigData("language_switch")--语言
TUNING.IS_LOW_COST=GetModConfigData("difficulty_switch")--是否为简易模式
TUNING.TRANSPLANT_OPEN=GetModConfigData("transplant_switch")--移植功能开关
TUNING.ADD_MEDAL_EQUIPSLOTS=GetModConfigData("medalequipslots_switch")--是否加入勋章栏
TUNING.MEDAL_INV_SWITCH=GetModConfigData("medal_inv_switch")--融合勋章栏是否自动贴边
TUNING.MEDAL_CONTAINERDRAG_SETTING=GetModConfigData("containerdrag_setting")--容器拖拽设置
TUNING.HAS_MEDAL_PAGE_ICON=GetModConfigData("medalpage_switch")--勋章介绍页显示
TUNING.SHOW_MEDAL_FX=GetModConfigData("show_medal_fx")--是否显示特效
TUNING.MEDAL_TIPS_SWITCH=GetModConfigData("medal_tips_switch")--飘字提示
TUNING.MEDAL_GOODMID_RESOURCES_MULTIPLE=GetModConfigData("medal_goodmid_resources_multiple")--高级风滚草资源倍率
TUNING.MEDAL_GOODMAX_RESOURCES_MULTIPLE=GetModConfigData("medal_goodmax_resources_multiple")--稀有风滚草资源倍率
TUNING.MEDAL_TECH_LOCK=GetModConfigData("medal_tech_lock")--科技依赖
TUNING.MEDAL_SHARDSKINHOLES_SWITCH=GetModConfigData("medal_shardskinholes_switch")--是否开启跨服时空塌陷
TUNING.MEDAL_RECIPE_FILTER_SWITCH=GetModConfigData("medal_recipe_filter_switch")--是否显示勋章制作栏
TUNING.MEDAL_TAG_OPTIMIZATION=GetModConfigData("medal_tag_optimization")--是否开启标签优化

TUNING.MEDAL_KRAMPUS_CHEST_PRIORITY = 1--坎普斯宝匣优先级(0最高,1中等[高于背包和物品栏],2最低)
TUNING.MEDAL_BUFF_SWITCH = true--buff面板开关
TUNING.MEDAL_BUFF_SETTING = 1--buff面板开关(0关闭,1开启,2全部buff[包括不兼容的])
TUNING.MEDAL_TEST_SWITCH = false--显示预制物代码
TUNING.MEDAL_BUFF_SHOW_NUM = false--buff显示条数
TUNING.MEDAL_SHOW_INFO = 2--显示勋章信息(0关闭,1必要信息,2全部信息)
TUNING.MEDAL_CLIENT_DRAG_SWITCH = true--容器拖拽客户端开关
TUNING.MEDAL_LOCK_TARGET_RANGE_MULT = 1.5--弹弓锁敌范围倍数(0关闭,1,1.25,1.5,1.75,2,2.25,2.5)

require("tuning_medal")

PrefabFiles = {
	"bearger_chest",--熊皮宝箱
	"lureplant_rod",--食人花手杖
	"marbleaxe",--大理石斧头
	"marblepickaxe",--大理石镐
	"xinhua_dictionary",--新华字典
	"medal_fruit",--勋章特有作物
	"functional_medals",--能力勋章
	"down_filled_coat",--羽绒服
	"medal_plantables",--可种植植株
	"medal_box",--勋章盒等各种盒子
	"medal_books",--书籍
	"trap_bat",--蝙蝠陷阱
	"medal_goathat",--羊角帽
	"medal_buffs",--闪电buff
	"multivariate_certificate",--融合勋章
	"medal_naughtybell",--淘气铃铛
	"medal_spices",--主厨调料
	"medal_preparedfoods",--主厨调味料理
	"medal_reticule",--范围显示
	"medal_obsidianfirefire",--红晶火
	"medal_firepit_obsidian",--红晶火坑
	"medal_fish",--勋章的鱼(熔岩鳗鱼)
	-- "medal_balloon",--气球
	"krampus_soul",--坎普斯之灵
	"bottled_soul",--瓶装灵魂
	"medal_seapond",--船上钓鱼池
	"hat_blue_crystal",--蓝晶帽
	"armor_medal_obsidian",--红晶甲/蓝晶甲
	"medal_losswetpouch",--遗失塑料袋
	"medal_livingroot_chest",--树根宝箱
	"livingroot_chest_extinguish_fx",--暗影之手灭火特效
	"medal_moonglass_shovel",--月光玻璃铲
	"bottled_moonlight",--瓶装月光
	"medal_rage_krampus",--暗夜坎普斯
	"medal_delivery_classified",--传送塔classified
	"medal_moonglass_hammer",--月光玻璃锤
	"mandrake_berry",--曼德拉果植株
	"mandrakeberry",--曼德拉果
	"medal_staff",--各种法杖
	"medal_statues",--各种雕像
	"medal_fruit_tree",--各种果树
	"sanityrock_mace",--方尖锏
	"medal_moonglass_bugnet",--月光玻璃网、月亮孢子
	"medal_cookpot",--远古锅
	"medal_wormwood_flower",--虫木花、埋着的绿宝石
	"medal_farm_plow",--高效耕地机
	"medal_rain_bomb",--天气弹
	"medal_tips",--飘字
	"medal_toy_chest",--玩具箱
	"medal_treasure_map",--藏宝图
	"medal_tentaclespike",--活性触手尖刺
	"medal_slingshotammo",--勋章特制弹药
	"medal_fx",--勋章新增特效
	"medal_moonglass_potion",--月亮药水
	"medal_waterpump",--手摇深井泵
	"medal_krampus_chest",--坎普斯之匣
	"medal_ice_machine",--蓝曜石制冰机
	"medal_show_range",--范围圈
	"medal_beequeen",--凋零之蜂
	"medal_honey_trail",--毒蜜小径
	"medal_beeguard",--凋零守卫
	"medal_withered_heart",--凋零之心
	"medal_rose_terrace",--蔷薇花台
	"medal_beequeenhive",--凋零蜂巢
	"medal_nitrify_tree",--硝化树
	"medal_beebox",--育王蜂箱
	"medal_bee",--育王蜂
	"medal_resonator",--宝藏探测仪
	"medal_fishingrod",--玻璃钓竿
	"medal_common_items",--常规预置物
	"medal_krampus_soul_spawn",--黯淡灵魂
	"medal_spacetime_devourer",--时空吞噬者
	"medal_spike",--时空之刃
	"medal_glassblock",--时空晶柱
	"medal_spacetime_spark",--时空乱流
	"medal_sinkhole",--时空塌陷
	"medal_gestalt",--时空虚影
	"medal_spacetime_lightning",--时空裂隙(闪电)
	"medal_spacetime_glass",--时空晶矿
	"medal_spacetime_crystalball",--预言水晶球
	"medal_spacetimestormmarker",--时空风暴地图图标
	"medal_spacetime_chest",--时空宝箱
	"medal_skin_coupon",--皮肤券
	"medal_withered_royaljelly",--凋零蜂王浆
	"medal_dustmoth",--时空尘蛾
	"medal_dustmothden",--时空尘蛾窝
	"medal_weed_seeds",--杂草种子
	"medal_pay_tribute_box",--奉纳盒
	"medal_naughty_krampus",--复仇坎普斯
	"medal_spacetime_pond",--虚空钓鱼池
	"medal_monster_symbol",--怪物召唤符
	"medal_shadowthrall_screamer",--驱光遗骸
	"medal_shadowthrall_projectile_fx",--驱光遗骸子弹
	"medal_red_tornado",--红色龙卷风
	"medal_shadowthrall_arrow",--虚空箭
	"punchingbag_chaos",--混沌拳击袋
	"medal_shadow_tool",--暗影工具
	"medal_more_placers",--原版建筑placer
	"medal_collapsedchest",--箱子废墟
	"medal_treasure_chest",--藏宝洞
	-- "medal_origin_tree",--本源之树
	-- "medal_origin_small_tree",--本源小树
	-- "medal_origin_tree_root",--本源树根
	-- "medal_origin_flowers",--本源之花
	-- "medal_sporecloud",--本源孢子云
	-- "medal_origin_fruitfly",--本源果蝇
	-- "medal_origin_elf",--本源果妖
	-- "medal_origin_tree_guard",--本源守卫
	-- "medal_origin_mosquito",--本源血蚊
}

Assets =
{
	Asset("SOUND", "sound/quagmire.fsb"),
	Asset("ATLAS", "images/medal_equip_slot.xml"),
	Asset("IMAGE", "images/medal_equip_slot.tex"),
    Asset("ANIM", "anim/player_transform_merm.zip"),
	Asset("IMAGE", "images/medal_equipslots.tex"),
    Asset("ATLAS", "images/medal_equipslots.xml"),
    Asset("IMAGE", "images/medal_page_icon.tex"),
    Asset("ATLAS", "images/medal_page_icon.xml"),
    Asset("ANIM", "anim/ui_medalcontainer_4x4.zip"),
    Asset("ANIM", "anim/ui_medalcontainer_5x5.zip"),
    Asset("ANIM", "anim/ui_medalcontainer_5x10.zip"),
    Asset("ANIM", "anim/ui_medalcontainer_1x1.zip"),
    Asset("ANIM", "anim/medal_blood_honey_goo.zip"),
	Asset("IMAGE", "images/medal_injured.tex"),
	Asset("ATLAS", "images/medal_injured.xml"),
	Asset("ANIM", "anim/player_spooked.zip"),
	-- Asset("ATLAS", "images/medal_skin_money.xml"),
	-- Asset("IMAGE", "images/medal_skin_money.tex"),
	-- Asset("ATLAS", "images/medal_skins.xml"),
	-- Asset("IMAGE", "images/medal_skins.tex"),
	Asset("ATLAS", "images/medal_buff_ui.xml"),
	Asset("IMAGE", "images/medal_buff_ui.tex"),
    Asset("ANIM", "anim/medal_spacetimestorm_over.zip"),

    Asset("ANIM", "anim/medal_leaves_canopy.zip"),
    -- Asset("ANIM", "anim/medal_oceantree_pillar_small_build1.zip"),
    -- Asset("ANIM", "anim/medal_oceantree_pillar_small_build2.zip"),
}

AddMinimapAtlas("minimap/bearger_chest.xml")
AddMinimapAtlas("minimap/trap_bat.xml")
AddMinimapAtlas("minimap/medal_firepit_obsidian.xml")
AddMinimapAtlas("minimap/medal_coldfirepit_obsidian.xml")
AddMinimapAtlas("minimap/medal_livingroot_chest.xml")
AddMinimapAtlas("minimap/medal_fruit_tree.xml")
AddMinimapAtlas("minimap/medal_childishness_chest.xml")
AddMinimapAtlas("minimap/medal_cookpot.xml")
AddMinimapAtlas("minimap/medal_krampus_chest_item.xml")
AddMinimapAtlas("minimap/medal_ice_machine.xml")
AddMinimapAtlas("minimap/medal_beebox.xml")
AddMinimapAtlas("minimap/medal_beequeenhivegrown.xml")
AddMinimapAtlas("minimap/medal_beequeenhive.xml")
AddMinimapAtlas("minimap/medal_rose_terrace.xml")
AddMinimapAtlas("minimap/medal_nitrify_tree.xml")
AddMinimapAtlas("minimap/medal_spacetime_devourer.xml")
AddMinimapAtlas("minimap/medal_spacetimestormmarker.xml")
AddMinimapAtlas("minimap/medal_spacetime_chest.xml")
AddMinimapAtlas("minimap/medal_pay_tribute_box.xml")
AddMinimapAtlas("minimap/medal_dustmothden.xml")
AddMinimapAtlas("minimap/punchingbag_chaos.xml")

RegisterInventoryItemAtlas("images/immortal_fruit.xml", "immortal_fruit.tex")
RegisterInventoryItemAtlas("images/immortal_fruit_seed.xml","immortal_fruit_seed.tex")
RegisterInventoryItemAtlas("images/medal_gift_fruit.xml", "medal_gift_fruit.tex")
RegisterInventoryItemAtlas("images/medal_gift_fruit_seed.xml","medal_gift_fruit_seed.tex")

--语言
if TUNING.MEDAL_LANGUAGE =="ch" then 
	require "lang/medal_strings_ch"
else
	require "lang/medal_strings_eng"
end

AddReplicableComponent("medal_delivery")--添加传送组件的replica
AddReplicableComponent("medal_skinable")--添加皮肤组件的replica
AddReplicableComponent("medal_showbufftime")--添加buff时长显示组件的replica
AddReplicableComponent("medal_examable")--添加答题组件的replica
AddReplicableComponent("medal_immortal")--添加不朽组件的replica

modimport("scripts/medal_globaldata.lua")--全局信息补充
modimport("scripts/medal_farm_plant_defs.lua")--勋章特有作物
modimport("scripts/medal_moretags.lua")--降低标签溢出的可能性
modimport("scripts/medal_rpc.lua")--RPC
modimport("scripts/medal_globalfn.lua")--全局函数
modimport("scripts/medal_modframework.lua")--框架，集成合成栏、动作等
modimport("scripts/medal_mysterious.lua")
modimport("scripts/medal_hook.lua")--机制修改
modimport("scripts/medal_ui.lua")--UI、容器等
modimport("scripts/medal_sg.lua")--新增、修改sg
modimport("scripts/medal_brain.lua")--修改大脑/行为树
modimport("scripts/medal_wipebutt.lua")--帮官方擦屁股系列
modimport("scripts/medal_minisign.lua")--兼容小木牌

require("medal_debugcommands")--调试用指令