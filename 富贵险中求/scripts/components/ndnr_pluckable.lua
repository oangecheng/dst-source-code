local Pluckable = Class(function(self, inst)
    self.inst = inst
    self.product = nil
    self.count = 1
    self.maxhair = 1
    self.hairleft = 1
    self.chance = 1
    self.evil = 1
    self.spawncountonce = 1
    self.actionfailfn = nil
    self.hairrespawntime = nil
    self.timername = nil
    self.onpluckedfn = nil
    self.actcondition = true
    self.sound = nil
    self.soundname = nil
    self.sgtimeout = 1
end, nil, {})

function Pluckable:OnRemoveFromEntity()
    self.inst:RemoveTag("pluckable")
end

function Pluckable:GetDebugString()
    local str = string.format("hairleft: %d", self.hairleft)
    return str
end

function Pluckable:SyncData()
    if self.inst.replica.ndnr_pluckable then
        self.inst.replica.ndnr_pluckable:SyncData({
            sound = self.sound,
            soundname = self.soundname,
            sgtimeout = self.sound,
        })
    end
end

function Pluckable:SetUp(product, count, actcondition, sound, soundname, sgtimeout)
    self.product = type(product) == "function" and product() or product
    self.count = count
    self.actcondition = actcondition
    self.sound = sound
    self.soundname = soundname
    self.sgtimeout = sgtimeout or 1

    self:SyncData({sound = self.sound, soundname = self.soundname, sgtimeout = self.sgtimeout})
end

function Pluckable:SetSpawnCountOnce(spawncountonce)
    self.spawncountonce = spawncountonce
end

function Pluckable:SetHairLeft(hairleft)
    self.hairleft = hairleft
end

function Pluckable:SetMaxHair(maxhair)
    self.maxhair = maxhair
end

function Pluckable:SetRespawnTime(time)
    self.hairrespawntime = time
end

function Pluckable:SetTimerName(timername)
    self.timername = timername
end

function Pluckable:SetChance(chance)
    self.chance = chance
end

function Pluckable:SetActionFail(fn)
    self.actionfailfn = fn
end

function Pluckable:OnPlucked(fn)
    self.onpluckedfn = fn
end

function Pluckable:SetActCondition(actcondition)
    self.actcondition = actcondition
end

function Pluckable:GetSound()
    return self.sound
end

function Pluckable:GetSoundName()
    return self.soundname
end

function Pluckable:GetSGTimeout()
    return self.sgtimeout
end

function Pluckable:RespawnHair()
    local pluckable = self.inst.components.ndnr_pluckable
    if pluckable then
        if pluckable.hairleft < pluckable.maxhair then
            pluckable.hairleft = math.min(pluckable.hairleft + pluckable.spawncountonce, pluckable.maxhair)
            if pluckable.hairleft >= pluckable.count then
                if self.actcondition == true then
                    self.inst:AddTag("pluckable")
                end
            end
            if pluckable.hairleft < pluckable.maxhair then
                pluckable:RefreshHair()
            end
        end
    end
end

function Pluckable:ReduceHair(count, doer, product)
    if self.hairleft > 0 then
        self.hairleft = self.hairleft - count
        self:RefreshHair()
        if self.hairleft <= 0 then
            self.inst:RemoveTag("pluckable")
        end
        if self.onpluckedfn ~= nil then
            self.onpluckedfn(self.inst, doer, product)
        end
    end
end

function Pluckable:GetFail(inst, doer, count)
    if self.actionfailfn then
        self.actionfailfn(inst, doer)
    end
    if self.hairleft > 0 then
        self.hairleft = self.hairleft - count
        self:RefreshHair()
        if self.hairleft <= 0 then
            self.inst:RemoveTag("pluckable")
        end
    end
end

function Pluckable:RefreshHair()
    if not self.inst.components.timer:TimerExists(self.timername) then
        self.inst.components.timer:StartTimer(self.timername, self.hairrespawntime)
    end
end

function Pluckable:GetHairPercent()
    return self.hairleft / self.maxhair
end

function Pluckable:ActionEnable()
    if self.hairleft < self.count then
        self.inst:RemoveTag("pluckable")
    else
        if self.actcondition == true then
            self.inst:AddTag("pluckable")
        else
            self.inst:RemoveTag("pluckable")
        end
    end
end

function Pluckable:OnSave()
    if self.hairleft < self.maxhair then
        return {
            hair = self.hairleft,
            count = self.count,
            spawncountonce = self.spawncountonce,
        }
    end
end

function Pluckable:OnLoad(data)
    if data.hair then
        self.hairleft = data.hair
    end
    if data.count then
        self.count = data.count
    end
    if data.spawncountonce then
        self.spawncountonce = data.spawncountonce
    end
    self:RefreshHair()
    self:SyncData()
end

return Pluckable
