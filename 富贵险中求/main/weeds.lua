local weeds = {"forgetmelots", "firenettle", "tillweed"}

local function stageupdate(inst, stage)
    if stage == 3 then
        if inst.components.pickable~=nil then
            local _oldpickedfn = inst.components.pickable.onpickedfn
            inst.components.pickable.onpickedfn = function(inst, doer)
                _oldpickedfn(inst, doer)
                if math.random() < .5 then
                    local weedname = Split(inst.prefab, "_")
                    local seed = SpawnPrefab("ndnr_" .. weedname[2] .. "_seeds")
                    if seed and doer and doer.components.inventory then doer.components.inventory:GiveItem(seed, nil, doer:GetPosition()) end
                end
            end
        end
    end
end

for k, v in ipairs(weeds) do
    AddPrefabPostInit("weed_"..v, function(inst)
        if not TheWorld.ismastersim then return inst end

        if inst.components.growable then
            inst.components.growable.stageupdatefn = stageupdate
        end
    end)
end