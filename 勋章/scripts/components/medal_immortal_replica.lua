local medal_immortal = Class(function(self, inst)
    self.inst = inst
	self._level = net_smallbyte(inst.GUID,"medal_immortal._level","immortalleveldirty")
	-- self._maxlevel=net_smallbyte(inst.GUID,"medal_immortal._maxlevel")
	inst.medal_olddisplaynamefn = inst.displaynamefn
	inst.displaynamefn = function(inst)
		local itemstr = GetMedalDisplayName(inst,inst.medal_olddisplaynamefn)
		-- local itemstr = inst.medal_olddisplaynamefn and inst.medal_olddisplaynamefn(inst) or STRINGS.NAMES[string.upper(inst.prefab)]
		local level = self._level and self._level:value() or 0
		if level>1 then
			return subfmt(STRINGS.NAMES.IMMORTAL_ITEM_LEVEL, {level = level, item = itemstr})
		elseif level>0 then
			return subfmt(STRINGS.NAMES.IMMORTAL_ITEM, {item = itemstr})
		else
			return itemstr
		end
	end
end)

return medal_immortal