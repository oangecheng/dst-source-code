local NdnrRepairGrave = Class(function(self, inst)
    self.inst = inst
    self.dofn = nil
end, nil, {})

function NdnrRepairGrave:SetDoFn(dofn)
    self.dofn = dofn
end

function NdnrRepairGrave:Do(doer, target)
    if self.inst:HasTag("ndnr_sacrifice") and target:HasTag("skeleton") then
        if self.inst and self.inst.components.stackable then

            local shovel = doer.components.inventory:FindItem(function(item)
                return item.prefab == "shovel" or item.prefab == "goldenshovel" or item.prefab == "ndnr_alloyshovel"
            end)
            if shovel == nil then
                return false, "NOSHOVEL"
            end

            local cutstone = doer.components.inventory:FindItem(function(item)
                return item.prefab == "cutstone"
            end)

            if cutstone == nil or (cutstone.components.stackable and cutstone.components.stackable:StackSize() < 4) then
                return false, "NOTENOUGHCUTSTONE"
            end

            local marble = doer.components.inventory:FindItem(function(item)
                return item.prefab == "marble"
            end)

            local count = self.inst.components.stackable:StackSize()
            if count < 9 then
                return false, "NOTENOUGHFLOWER"
            end

            local shovelitem = doer.components.inventory:RemoveItem(shovel)
            if shovelitem then shovelitem:Remove() end

            local cutstoneitem = doer.components.inventory:RemoveItem(cutstone, true)
            if cutstoneitem then cutstoneitem:Remove() end

            if self.dofn ~= nil then
                self.dofn(doer, target, marble)
            end

            self.inst:Remove()
            target:Remove()

            return true

        end
    end
    return false
end

return NdnrRepairGrave
