local function HasGodToken(inst)
    local inventory = inst.components.inventory
    if inventory then
        local godtoken = inventory:FindItem(function(item)
            return item:HasTag("godprotected")
        end)
        return godtoken
    end
end

AddPrefabPostInit("archive_centipede", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    if inst.components.combat then
        local _targetfn = inst.components.combat.targetfn
        inst.components.combat:SetRetargetFunction(3, function(inst)
            local target = _targetfn(inst)
            if target and target:HasTag("player") then
                local godtoken = HasGodToken(target)
                if godtoken ~= nil then
                    return nil
                else
                    return target
                end
            end
            return nil
        end)
    end
end)
