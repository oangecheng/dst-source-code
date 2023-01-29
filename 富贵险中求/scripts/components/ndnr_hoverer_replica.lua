local function OnContentDirty(self, inst)
    self.content = self._content:value()
end

local Hoverer = Class(function(self, inst)
    self.inst = inst

    self._content = net_string(inst.GUID, "ndnr_hoverer._content", "ndnr_hoverercontentdirty")
    inst:ListenForEvent("ndnr_hoverercontentdirty", function(inst) OnContentDirty(self, inst) end)
end, nil, {})

function Hoverer:GetContent(content)
    return self.content
end

function Hoverer:SetContent(content)
    self._content:set_local(content)
    self._content:set(content)
end

return Hoverer