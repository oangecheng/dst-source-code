local NDNRInjection = Class(function(self, inst)
    self.inst = inst
    self.injectionfn = nil
end, nil, {})

function NDNRInjection:Do(invobj, target)
    local result = false
    if self.injectionfn ~= nil then
        result = self.injectionfn(self.inst, invobj, target)
    end
    if result == true then
        if invobj.components.stackable then
            invobj.components.stackable:Get():Remove()
        else
            invobj:Remove()
        end
    end
    return result
end

function NDNRInjection:Injection(fn)
    self.injectionfn = fn
end

return NDNRInjection
