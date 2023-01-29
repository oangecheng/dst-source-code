local GodToken = Class(function(self, inst)
    self.inst = inst
    self.protectfn = nil
    self.protecttask = nil
end, nil, {})

function GodToken:OnProtect(fn)
    self.protectfn = fn
end

function GodToken:StartProtect()
    if self.protecttask == nil and self.protectfn and self.inst.components.inventoryitem.owner then
        self.protecttask = self.inst:DoPeriodicTask(3, function()
            self.protectfn(self.inst)
        end)
    end
end

function GodToken:StopProtect()
    if self.protecttask then
        self.protecttask:Cancel()
        self.protecttask = nil
    end
end

return GodToken