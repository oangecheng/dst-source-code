local medal_examable = Class(function(self, inst)
    self.inst = inst
	self._examid=net_byte(inst.GUID,"medal_examable._examid")
end)
--获取皮肤ID
function medal_examable:GetExamId()
	return self._examid:value()
end

return medal_examable