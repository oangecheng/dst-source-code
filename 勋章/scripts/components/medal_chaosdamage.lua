local SourceModifierList = require("util/sourcemodifierlist")

local Medal_ChaosDamage = Class(function(self, inst)
	self.inst = inst
	self.basedamage = 0
	self.externalmultipliers = SourceModifierList(inst)
	self.externalbonuses = SourceModifierList(inst, 0, SourceModifierList.additive)
	self.calcdamagefns = {}--额外混沌伤害计算函数列表
end)

------------------------------------基础混沌伤害--------------------------------------

function Medal_ChaosDamage:SetBaseDamage(damage)
	self.basedamage = damage
end

function Medal_ChaosDamage:GetBaseDamage()
	return self.basedamage
end

function Medal_ChaosDamage:GetDamage()
	return self.basedamage * self.externalmultipliers:Get() + self.externalbonuses:Get()
end

------------------------------------混沌伤害倍数--------------------------------------

function Medal_ChaosDamage:AddMultiplier(src, mult, key)
	self.externalmultipliers:SetModifier(src, mult, key)
end

function Medal_ChaosDamage:RemoveMultiplier(src, key)
	self.externalmultipliers:RemoveModifier(src, key)
end

function Medal_ChaosDamage:GetMultiplier()
	return self.externalmultipliers:Get()
end

------------------------------------混沌伤害奖励--------------------------------------

function Medal_ChaosDamage:AddBonus(src, bonus, key)
	self.externalbonuses:SetModifier(src, bonus, key)
end

function Medal_ChaosDamage:RemoveBonus(src, key)
	self.externalbonuses:RemoveModifier(src, key)
end

function Medal_ChaosDamage:GetBonus()
	return self.externalbonuses:Get()
end

-------------------------------------额外混沌伤害计算-------------------------------------

function Medal_ChaosDamage:SetCalcBonusDamageFn(fn,key)
	key = key or "defalut"
	self.calcdamagefns[key] = fn
end

function Medal_ChaosDamage:CalcBonusChaosDamage(target, damage, spdamage)
	local chaos_damage = 0
	for k, v in pairs(self.calcdamagefns) do
		chaos_damage = chaos_damage + v(self.inst, target)
	end
	if chaos_damage > 0 then
		spdamage = spdamage or {}
    	spdamage["medal_chaos"] = (spdamage["medal_chaos"] or 0) + chaos_damage
	end
	return damage, spdamage
end

--------------------------------------------------------------------------

function Medal_ChaosDamage:GetDebugString()
	return string.format("Damage=%.2f [%.2fx%.2f+%.2f]", self:GetDamage(), self:GetBaseDamage(), self:GetMultiplier(), self:GetBonus())
end

return Medal_ChaosDamage
