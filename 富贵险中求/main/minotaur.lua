
local function OnHitOther(inst, other)
    if inst:HasTag("woundedminotaur") then
        other:PushEvent("knockback", {
            knocker = inst, -- 攻击者
            radius = 70, -- 击飞范围
            strengthmult = 1 -- 力量倍率
        })
    end
end

AddPrefabPostInit("minotaur", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    if inst.components.combat ~= nil then
        inst.components.combat.onhitotherfn = OnHitOther
    end
end)