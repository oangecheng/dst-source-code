local minisign_show_list = {
	"multivariate_certificate",--融合勋章
	"medium_multivariate_certificate",--中级融合勋章
	"large_multivariate_certificate",--高级融合勋章
	"medal_box",--勋章盒(关闭)
	"medal_box_open",--勋章盒(打开)
	"spices_box",--调料盒(关闭)
	"spices_box_open",--调料盒(打开)
	"medal_ammo_box",--弹药盒
	"medal_fishbones",--鱼骨
	"marbleaxe",--大理石斧头
	"marblepickaxe",--大理石镐子
	"medal_farm_plow_item",--高效耕地机
	"medal_waterpump_item",--深井泵套件
	"medal_rain_bomb",--催雨弹
	"medal_clear_up_bomb",--放晴弹
	"toil_money",--血汗钱
	"mandrake_seeds",--曼德拉种子(曼德拉果在弹药里已添加)
	"medal_moonglass_bugnet",--月光玻璃网
	"medal_moonglass_hammer",--月光玻璃锤
	"medal_moonglass_shovel",--月光玻璃铲
	"medal_moonglass_potion",--月光药水
	"bottled_moonlight",--瓶装月光
	"bottled_soul",--瓶装灵魂
	"lureplant_rod",--食人花手杖
	"medal_goathat",--羊角帽
	"xinhua_dictionary",--新华字典
	"immortal_essence",--不朽精华
	"immortal_fruit",--不朽果实
	"immortal_gem",--不朽宝石
	"devour_staff",--吞噬法杖
	"immortal_staff",--不朽法杖
	"meteor_staff",--流星法杖
	"medal_krampus_chest_item",--坎普斯宝匣(关闭)
	"medal_krampus_chest_item_open",--坎普斯宝匣(打开)
	"medal_monster_essence",--怪物精华
	"medal_naughtybell",--淘气铃铛
	"down_filled_coat",--羽绒服
	"hat_blue_crystal",--蓝晶帽
	"medal_tentaclespike",--活性触手尖刺
	"trap_bat",--蝙蝠陷阱
	"sanityrock_mace",--方尖锏
	"sanityrock_fragment",--方尖碑碎片
	"lavaeel",--熔岩鳗鱼
	"medal_obsidian",--黑曜石
	"medal_blue_obsidian",--蓝曜石
	"armor_medal_obsidian",--黑曜石甲
	"armor_blue_crystal",--蓝曜石甲
	"medal_treasure_map",--藏宝图
	"medal_withered_heart",--凋零之心
	"medal_bee_larva",--育王蜂种
	"medal_resonator_item",--宝藏探测仪
	"medal_treasure_map_scraps1",--藏宝图碎片·日出
	"medal_treasure_map_scraps2",--藏宝图碎片·黄昏
	"medal_treasure_map_scraps3",--藏宝图碎片·夜晚
	"medal_fishingrod",--玻璃钓竿
	"medal_time_slider",--时空碎片
	"medal_space_gem",--时空宝石
	"immortal_fruit_oversized",--巨型不朽果实
	"immortal_fruit_seed",--不朽种子
	"medal_skin_staff",--风花雪月
	"medal_space_staff",--时空法杖
	"medal_space_staff_bind",--时空法杖(绑定)
	"medal_spacetime_lingshi",--时空灵石
	"medal_spacetime_snacks",--时空零食
	"medal_spacetime_snacks_packet",--零食包装袋
	"medal_spacetime_potion",--改命药水
	"medal_spacetime_runes",--时空符文
	"medal_chum",--特制鱼食
	"medal_glassblock",--不朽晶柱
	"medal_spacetime_crystalball",--预言水晶球
	"medal_gift_fruit_seed",--包果种子
	"medal_gift_fruit",--包果
	"medal_gift_fruit_oversized",--巨型包果
	"medal_tribute_symbol",--奉纳符
	"mission_certificate",--使命勋章
	"medal_glommer_essence",--格罗姆精华
	"medal_loss_treasure_map_scraps",--遗失藏宝图碎片
	"medal_loss_treasure_map",--遗失藏宝图
	"medal_plant_book",--植物图鉴
	"medal_dustmothden_base",--尘蛾巢台
	"medal_dustmeringue",--琥珀灵石
	"medal_withered_royaljelly",--凋零蜂王浆
	"spice_withered_royal_jelly",--凋零蜂王浆酱
	"medal_ivy",--旋花藤
	"medal_weed_seeds",--杂草种子
	"medal_skin_coupon",--皮肤券
	"medal_diligence_token",--酬勤令
	"medal_monster_symbol",--暗影挑战符
	"medal_shadow_magic_stone",--暗影魔法石
	"medal_moonlight_staff",--月光法杖
	"medal_inherit_page",--传承书页
	--暗影工具
	"medal_shadow_axe",
	"medal_shadow_pickaxe",
	"medal_shadow_pitchfork",
	"medal_shadow_hammer",
	"medal_shadow_shovel",
	"medal_shadow_oar",
	"medal_shadow_farm_hoe",
	"medal_shadow_fishingrod",
	"medal_shadow_bugnet",
	--皮肤
	"lureplant_rod_skin1",--食人花手杖(霸王之花)
	"medal_naughtybell_skin1",--淘气铃铛(冰雪格罗姆)
	"medal_naughtybell_skin2",--淘气铃铛(虎年吉祥)
	"sanityrock_mace_skin1",--方尖锏(锦依玉石)
	"devour_staff_skin1",--吞噬法杖(贪吃蛇)
	"medal_krampus_chest_item_skin1",--坎普斯宝匣(招财进宝,关闭)
	"medal_krampus_chest_item_skin1_open",--坎普斯宝匣(招财进宝,打开)
	"medal_krampus_chest_item_skin2",--坎普斯宝匣(镂冰雕琼,关闭)
	"medal_krampus_chest_item_skin2_open",--坎普斯宝匣(镂冰雕琼,打开)
	"medal_goathat_skin1",--羊角帽(财运亨通)
	"medal_fishingrod_skin1",--玻璃钓竿(红梅报喜)
	"medal_box_skin1",--勋章盒(金钗钿合,关闭)
	"medal_box_skin1_open",--勋章盒(金钗钿合,打开)
	"spices_box_skin1",--调料盒(五味俱全,关闭)
	"spices_box_skin1_open",--调料盒(五味俱全,打开)
	"meteor_staff_skin1",--流星法杖(北斗七星)
	"medal_space_staff_skin1",--时空法杖(小鸟时钟)
	"medal_space_staff_skin1_bind",--时空法杖绑定(小鸟时钟)
	"down_filled_coat_skin1",--羽绒服(加绒唐装)
	"medal_skin_staff_skin1",--风花雪月(雪花谣)
}
--勋章
for k, v in pairs(require("medal_defs/functional_medal_defs").MEDAL_DEFS) do
	table.insert(minisign_show_list, k)
	table.insert(minisign_show_list, "copy_"..k)--拷贝的勋章
end
--接穗
for k, v in pairs(require("medal_defs/medal_fruit_tree_defs").MEDAL_FRUIT_TREE_DEFS) do
	if v.switch then
		table.insert(minisign_show_list, v.name.."_scion")
	end
end
--调料
for k, v in pairs(require("medal_defs/medal_spice_defs")) do
	table.insert(minisign_show_list, k)
end
--非原生移植植株
for k, v in pairs(require("medal_defs/medal_plantable_defs")) do
	table.insert(minisign_show_list, v.name)
end
--弹药
for k, v in pairs(require("medal_defs/medal_slingshotammo_defs")) do
	if v.switch then
		table.insert(minisign_show_list, k)
	end
end
--勋章书籍
for k, v in pairs(require("medal_defs/medal_book_defs")) do
	if not v.hide then
		table.insert(minisign_show_list, v.name)
	end
end


--兼容小木牌显示
local function draw(inst)
	if inst.components.drawable then
		local oldondrawnfn = inst.components.drawable.ondrawnfn or nil
		inst.components.drawable.ondrawnfn = function(inst, image, src, atlas, ...)
			if oldondrawnfn ~= nil then
				oldondrawnfn(inst, image, src, atlas, ...)
			end
			print(image,atlas)
			if image ~= nil and table.contains(minisign_show_list,image) then --是我的物品
				if atlas==nil then
					atlas="images/"..image..".xml"
				end
				local atlas_path=resolvefilepath_soft(atlas)
				if atlas_path then
					inst.AnimState:OverrideSymbol("SWAP_SIGN", atlas_path, image..".tex")
				end
			end
		end
	end
end

AddPrefabPostInit("minisign", draw)
AddPrefabPostInit("minisign_drawn", draw)
AddPrefabPostInit("decor_pictureframe", draw)