AddPrefabPostInit("frog", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    if inst.components.combat then
        local _onhitotherfn = inst.components.combat.onhitotherfn
        inst.components.combat.onhitotherfn = function(inst, other, damage)
            _onhitotherfn(inst, other, damage)
            if other:HasTag("poisonresist") then
                inst.components.health:Kill()
            end
        end
    end
end)