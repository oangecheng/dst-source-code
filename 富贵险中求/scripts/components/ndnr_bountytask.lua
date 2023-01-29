local BountyTask = Class(function(self, inst)
    self.inst = inst
    self.content = nil
    self.list = nil
    self.reward = nil

    self.inst:DoTaskInTime(1, function(inst)
        if self.content and self.list and self.reward then return end
        local bountytask = TUNING.NDNR_BOUNTYTASKS[math.random(#TUNING.NDNR_BOUNTYTASKS)]
        if bountytask then
            self:SetContent(bountytask.content[TUNING.NDNR_LANGUAGE])
            self:SetList(bountytask.list)
            self:SetReward(bountytask.reward)

            self:SyncContent()
        end
    end)
end, nil, {})

function BountyTask:DeliveryTask(fn)
    self.deliverytask = fn
end

function BountyTask:Do(doer)
    if self.deliverytask then
        self.inst:AddTag("ndnr_summoned")
        self.deliverytask(self.inst, doer)
    end
end

function BountyTask:SetContent(content)
    self.content = content
end

function BountyTask:SetList(list)
    self.list = list
end

function BountyTask:GetList()
    return self.list
end

function BountyTask:SetReward(reward)
    self.reward = reward
end

function BountyTask:GetReward()
    return self.reward
end

function BountyTask:SyncContent()
    if self.inst.replica.ndnr_bountytask then
        self.inst.replica.ndnr_bountytask:SetContent(self.content)
    end
end

function BountyTask:OnSave()
    return {
        content = self.content,
        list = self.list,
        reward = self.reward,
    }
end

function BountyTask:OnLoad(data)
    if data then
        self.content = data.content
        self.list = data.list
        self.reward = data.reward
    end
    self:SyncContent()
end

return BountyTask