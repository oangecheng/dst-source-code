local pigs = {"pigman", "pigguard"}

for i, v in ipairs(pigs) do
    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then return inst end

        if inst.components.eater then
            local _oneater = inst.components.eater.oneatfn
            inst.components.eater.oneatfn = function(inst, food)
                _oneater(inst, food)
                if (food:HasTag("drink") or food:HasTag("ndnr_darkcuisine")) and inst.components.werebeast then
                    inst.components.werebeast:SetWere()
                end
            end
        end
    end)
end