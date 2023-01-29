local function OnDirty(self, inst, type)
    if type == "sound" then
        self.sound = self._sound:value()
    elseif type == "soundname" then
        self.soundname = self._soundname:value()
    elseif type == "sgtimeout" then
        self.sgtimeout = self._sgtimeout:value() or 1
    end
end

local Pluckable = Class(function(self, inst)
    self.inst = inst

    self._sound = net_string(inst.GUID, "ndnr_pluckable._sounddirty", "ndnr_sounddirty")
    self._soundname = net_string(inst.GUID, "ndnr_pluckable._soundnamedirty", "ndnr_soundnamedirty")
    self._sgtimeout = net_float(inst.GUID, "ndnr_pluckable._sgtimeoutdirty", "ndnr_sgtimeoutdirty")

    inst:ListenForEvent("ndnr_sounddirty", function(inst) OnDirty(self, inst, "sound") end)
    inst:ListenForEvent("ndnr_soundnamedirty", function(inst) OnDirty(self, inst, "soundname") end)
    inst:ListenForEvent("ndnr_sgtimeoutdirty", function(inst) OnDirty(self, inst, "sgtimeout") end)

end, nil, {})

function Pluckable:SyncData(data)
    if TheWorld.ismastersim then
        if data.sound ~= nil then
            self._sound:set(data.sound)
        elseif data.soundname ~= nil then
            self._soundname:set(data.soundname)
        elseif data.sgtimeout ~= nil then
            self._sgtimeout:set(data.sgtimeout)
        end
    end
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

return Pluckable
