local ExperimentStaff = Class(function(self, inst)
    self.inst = inst
    self.dofn = nil
end, nil, {})

function ExperimentStaff:SetDoFn(dofn)
    self.dofn = dofn
end

function ExperimentStaff:Do(doer, target)
    if self.dofn == nil then return false end

    local a,b = self.dofn(self.inst, doer, target)

    if a then
        if self.inst.components.stackable then
            self.inst.components.stackable:Get(1):Remove()
        else
            self.inst:Remove()
        end
    end
    
    return a,b
end

return ExperimentStaff
