local StopBleedinig = Class(function(self, inst)
    self.inst = inst
end, nil, {})

function StopBleedinig:Do(invobj, target)
    if target:HasTag("attacked_bleeding") then
        target.components.debuffable:RemoveDebuff("ndnr_bloodoverdebuff")
        if invobj.components.stackable then
            invobj.components.stackable:Get():Remove()
        else
            invobj:Remove()
        end
        return true
    end
    return false
end

return StopBleedinig
