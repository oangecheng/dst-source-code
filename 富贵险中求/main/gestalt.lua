local function HasGodToken(inst)
    if inst.tracking_target then
        local inventory = inst.tracking_target.components.inventory
        if inventory then
            local godtoken = inventory:FindItem(function(item)
                return item:HasTag("godprotected")
            end)
            return godtoken
        end
    else
        return nil
    end
end

AddPrefabPostInit("gestalt", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    if inst.components.combat then
        local _targetfn = inst.components.combat.targetfn
        inst.components.combat:SetRetargetFunction(1, function(inst)
            local godtoken = HasGodToken(inst)
            if godtoken ~= nil then
                return nil
            end
            return _targetfn(inst)
        end)
    end
end)
