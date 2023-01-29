local regrowplants = {
	moonbase = {"lg_litichi_tree",20,4},
	oasislake = {"lg_lemon_tree",40,4},
}

for k,v in pairs(regrowplants) do
	AddPrefabPostInit(k, function(inst)
		if	TheWorld.ismastersim then
			inst:AddComponent("legend_regrowplants")
			inst.components.legend_regrowplants:AddPlantData(v)
		end
	end)
end