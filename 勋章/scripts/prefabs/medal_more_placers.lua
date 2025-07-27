local medal_skins=require("medal_defs/medal_skin_defs")

local placer_loot = {
	{--尘蛾窝
		name = "medal_dustmothden_copy_placer",
		bank = "dustmothden",
		-- build = "dustmothden",
		anim = "idle",
	},
	{--奶奶的晾肉架
		name = "medal_meatrack_hermit_copy_placer",
		bank = "meatrack_hermit",
		anim = "idle_empty",
	},
	{--奶奶的蜂箱
		name = "medal_beebox_hermit_copy_placer",
		bank = "bee_box_hermitcrab",
		anim = "idle",
	},
	{--正向方尖碑
		name = "medal_insanityrock_copy_placer",
		bank = "blocker_sanity",
		anim = "idle_active",
	},
	{--反向方尖碑
		name = "medal_sanityrock_copy_placer",
		bank = "blocker_sanity",
		anim = "idle_active",
	},
	{--远古锅
		name = "medal_archive_cookpot_copy_placer",
		bank = "cook_pot",
		build = "cookpot_archive",
		anim = "idle_empty",
	},
}

for k,v in pairs(medal_skins) do
	if v.special_placer then
		if v.skin_info then
			for i, skin in ipairs(v.skin_info) do
				if skin.placer_info then
					table.insert(placer_loot,skin.placer_info)
				end
			end
		end
	end
end

local placers = {}
for i, v in ipairs(placer_loot) do
    table.insert(placers, MakePlacer(v.name,v.bank,v.build or v.bank,v.anim or "idle"))
end
return unpack(placers)