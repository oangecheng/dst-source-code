local UpgradeStaff = Class(function(self, inst)
    self.inst = inst
    self.dofn = nil
end, nil, {})

function UpgradeStaff:SetDoFn(dofn)
    self.dofn = dofn
end

function UpgradeStaff:Do(doer, target)
    target.ndnr_forever_fresh = true
    if self.inst.components.stackable then
        self.inst.components.stackable:Get(1):Remove()
    else
        self.inst:Remove()
    end
    if self.dofn then self.dofn(self.inst, doer, target) end
    return true
end

return UpgradeStaff
