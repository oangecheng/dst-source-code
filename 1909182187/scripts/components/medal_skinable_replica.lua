local medal_skins=require("medal_defs/medal_skin_defs")

local medal_skinable = Class(function(self, inst)
    self.inst = inst
	self._skinid=net_smallbyte(inst.GUID,"_skinid")
end)
--获取皮肤ID
function medal_skinable:GetSkinId()
	return self._skinid:value()
end
--获取Placer
function medal_skinable:GetPlacerName()
	local skinid = self._skinid:value() or 0
	if skinid>0 then
		if medal_skins and medal_skins[self.inst.prefab] then
			local skin_info=medal_skins[self.inst.prefab].skin_info
			if skin_info and skin_info[skinid] then
				return skin_info[skinid].placer
			end
		end
	end
end

return medal_skinable