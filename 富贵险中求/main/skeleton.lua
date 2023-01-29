local skeletons = {"skeleton", "skeleton_player"}

for i, v in pairs(skeletons) do
    AddPrefabPostInit(v, function(inst)

        inst:AddTag("skeleton")

        if not TheWorld.ismastersim then
            return inst
        end

    end)
end