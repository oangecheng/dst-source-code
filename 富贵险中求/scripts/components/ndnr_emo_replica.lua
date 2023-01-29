local Emo = Class(function(self, inst)
    self.inst = inst

    if TheWorld.ismastersim then
        self.classified = inst.player_classified
    elseif self.classified == nil and inst.player_classified ~= nil then
        self:AttachClassified(inst.player_classified)
    end
end)

--------------------------------------------------------------------------

function Emo:OnRemoveFromEntity()
    if self.classified ~= nil then
        if TheWorld.ismastersim then
            self.classified = nil
        else
            self.inst:RemoveEventCallback("onremove", self.ondetachclassified, self.classified)
            self:DetachClassified()
        end
    end
end

Emo.OnRemoveEntity = Emo.OnRemoveFromEntity

function Emo:AttachClassified(classified)
    self.classified = classified
    self.ondetachclassified = function() self:DetachClassified() end
    self.inst:ListenForEvent("onremove", self.ondetachclassified, classified)
end

function Emo:DetachClassified()
    self.classified = nil
    self.ondetachclassified = nil
end

--------------------------------------------------------------------------

function Emo:GetRateScale()
    if self.inst.components.ndnr_emo ~= nil then
        return self.inst.components.ndnr_emo:GetRateScale()
    else
        return RATE_SCALE.NEUTRAL
    end
end

function Emo:SetCurrent(current)
    if self.classified ~= nil then
        self.classified:SetValue("currentemo", current)
    end
end

function Emo:SetMax(max)
    if self.classified ~= nil then
        self.classified:SetValue("maxemo", max)
    end
end

function Emo:Max()
    if self.inst.components.ndnr_emo ~= nil then
        return self.inst.components.ndnr_emo.max
    elseif self.classified ~= nil then
        return self.classified.maxemo:value()
    else
        return 100
    end
end

function Emo:GetPercent()
    if self.inst.components.ndnr_emo ~= nil then
        return self.inst.components.ndnr_emo:GetPercent()
    elseif self.classified ~= nil then
        return self.classified.currentemo:value() / self.classified.maxemo:value()
    else
        return 0
    end
end

function Emo:GetCurrent()
    if self.inst.components.ndnr_emo ~= nil then
        return self.inst.components.ndnr_emo.current
    elseif self.classified ~= nil then
        return self.classified.currentemo:value()
    else
        return 100
    end
end

return Emo