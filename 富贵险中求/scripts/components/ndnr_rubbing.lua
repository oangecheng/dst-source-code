local Rubbing = Class(function(self, inst)
    self.inst = inst
end, nil, {})

function Rubbing:Do(doer, invobj, target)
    local featherpencil = doer.components.inventory:FindItem(function(item)
        return item.prefab == "featherpencil"
    end)
    if featherpencil then
        if invobj.components.stackable then
            invobj.components.stackable:Get(1):Remove()
        else
            invobj:Remove()
        end
        local removefeatherpencil = doer.components.inventory:RemoveItem(featherpencil)
        if removefeatherpencil then removefeatherpencil:Remove() end

        local item = SpawnPrefab(target.prefab .. "_blueprint")
        doer.components.inventory:GiveItem(item, nil, doer:GetPosition())
        return true
    else
        return false, "NOFEATHERPENCIL"
    end
end

return Rubbing
