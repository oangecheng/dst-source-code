local function OnContentDirty(self, inst)
    self.content = self._content:value()
end

local BountyTask = Class(function(self, inst)
    self.inst = inst

    self._content = net_string(inst.GUID, "ndnr_bountytask._content", "ndnr_contentdirty")
    inst:ListenForEvent("ndnr_contentdirty", function(inst) OnContentDirty(self, inst) end)
end, nil, {})

function BountyTask:GetContent(content)
    return self.content
end

function BountyTask:SetContent(content)
    self._content:set_local(content)
    self._content:set(content)
end

return BountyTask