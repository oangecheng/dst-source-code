local medal_showbufftime = Class(function(self, inst)
    self.inst = inst
	self._buffinfo=net_string(inst.GUID,"_buffinfo")
end)
--获取Buff信息
function medal_showbufftime:GetBuffInfo()
	return self._buffinfo:value()
end

return medal_showbufftime