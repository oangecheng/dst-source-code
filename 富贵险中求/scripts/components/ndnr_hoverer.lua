local Hoverer = Class(function(self, inst)
    self.inst = inst
    self.content = nil
end, nil, {})

function Hoverer:SetContent(content)
    self.content = content
    self:SyncContent()
end

function Hoverer:SyncContent()
    if self.inst.replica.ndnr_hoverer then
        self.inst.replica.ndnr_hoverer:SetContent(self.content)
    end
end

function Hoverer:OnSave()
    return {
        content = self.content,
    }
end

function Hoverer:OnLoad(data)
    if data then
        self.content = data.content
    end
    self:SyncContent()
end

return Hoverer