local PoisonHealer = Class(function(self, inst)
    self.inst = inst
    self.health = 0
end)

function PoisonHealer:SetHealthAmount(health)
    self.health = health
end

function PoisonHealer:Cure(target)
    if target.components.health ~= nil then
        if self.health ~= 0 then
            target.components.health:DoDelta(self.health, false, self.inst.prefab)
        end

		if self.onpoisonhealfn ~= nil then
			self.onpoisonhealfn(self.inst, target)
		end
        if self.inst.components.stackable ~= nil and self.inst.components.stackable:IsStack() then
            self.inst.components.stackable:Get():Remove()
        else
            self.inst:Remove()
        end
        return true
    end
end

return PoisonHealer
