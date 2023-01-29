local NdnrRepair = Class(function(self, inst)
    self.inst = inst
    self.dofn = nil
    self.amount = 1/3
end, nil, {})

function NdnrRepair:SetDoFn(dofn)
    self.dofn = dofn
end

function NdnrRepair:SetAmount(amount)
    self.amount = amount
end

function NdnrRepair:Do(doer, target)
    if target.components.finiteuses then
        local current = target.components.finiteuses:GetUses()
        local total = target.components.finiteuses.total
        target.components.finiteuses:SetUses(math.min(total, current+math.floor(total * self.amount)))
        if self.inst.components.stackable then
            self.inst.components.stackable:Get(1):Remove()
        else
            self.inst:Remove()
        end
        if self.dofn then self.dofn(self.inst, doer, target) end
        return true
    elseif target.components.armor then
        local condition = target.components.armor.condition
        local maxcondition = target.components.armor.maxcondition
        target.components.armor:SetCondition(math.min(maxcondition, condition+math.floor(maxcondition * self.amount)))
        if self.inst.components.stackable then
            self.inst.components.stackable:Get(1):Remove()
        else
            self.inst:Remove()
        end
        if self.dofn then self.dofn(self, doer, target) end
        return true
    end
    return false
end

return NdnrRepair
