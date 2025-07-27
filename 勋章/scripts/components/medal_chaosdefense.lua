local SourceModifierList = require("util/sourcemodifierlist")

local Medal_ChaosDefense = Class(function(self, inst)
	self.inst = inst
	self.basedefense = 0
	self.externalmultipliers = SourceModifierList(inst)
	self.externalbonuses = SourceModifierList(inst, 0, SourceModifierList.additive)
end)

function Medal_ChaosDefense:SetBaseDefense(defense)
	self.basedefense = defense
end

function Medal_ChaosDefense:GetBaseDefense()
	return self.basedefense
end

function Medal_ChaosDefense:GetDefense()
	return self.basedefense * self.externalmultipliers:Get() + self.externalbonuses:Get()
end

--------------------------------------------------------------------------

function Medal_ChaosDefense:AddMultiplier(src, mult, key)
	self.externalmultipliers:SetModifier(src, mult, key)
end

function Medal_ChaosDefense:RemoveMultiplier(src, key)
	self.externalmultipliers:RemoveModifier(src, key)
end

function Medal_ChaosDefense:GetMultiplier()
	return self.externalmultipliers:Get()
end

--------------------------------------------------------------------------

function Medal_ChaosDefense:AddBonus(src, bonus, key)
	self.externalbonuses:SetModifier(src, bonus, key)
end

function Medal_ChaosDefense:RemoveBonus(src, key)
	self.externalbonuses:RemoveModifier(src, key)
end

function Medal_ChaosDefense:GetBonus()
	return self.externalbonuses:Get()
end

--------------------------------------------------------------------------

function Medal_ChaosDefense:GetDebugString()
	return string.format("Defense=%.2f [%.2fx%.2f+%.2f]", self:GetDefense(), self:GetBaseDefense(), self:GetMultiplier(), self:GetBonus())
end

return Medal_ChaosDefense
