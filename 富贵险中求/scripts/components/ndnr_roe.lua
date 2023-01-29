local Roe = Class(function(self, inst)
    self.inst = inst
end, nil, {})

function Roe:Do(doer, target)
    if target.raisefn ~= nil then
        target.raisefn(target, self.inst, doer)
    end
    if self.inst.components.stackable then
        self.inst.components.stackable:Get(1):Remove()
    else
        self.inst:Remove()
    end
    return true
end

return Roe
