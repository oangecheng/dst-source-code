local SmearStaff = Class(function(self, inst)
    self.inst = inst
    self.dofn = nil
end, nil, {})

function SmearStaff:SetDoFn(dofn)
    self.dofn = dofn
end

function SmearStaff:Do(doer, target)
    if self.dofn then self.dofn(self, doer, target) end
end

return SmearStaff
