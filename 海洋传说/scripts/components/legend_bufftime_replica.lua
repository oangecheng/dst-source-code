local function OnItemDirty(self, inst)
    if self.items == nil then
        self.items = {}
    end
    local data = self._itemdata:value()
    local t1 = string.split(data, ";")
    for i1, v1 in pairs(t1) do
        local t2 = string.split(v1, ",")
        if #t2 == 4 then
            local name = t2[1]
            local buffname = t2[2]
            local time = tonumber(t2[3])
            local show = t2[4] == "true"
            self.items[name] = {name = name, buffname = buffname, time = time, show = show}
        end
    end
    self.pause = false
end
local function OnItemDirty1(self, inst)
    if self.items == nil then
        self.items = {}
    end
    local data = self._itemdata1:value()
    local t1 = string.split(data, ";")
    local name = t1[1]
    local buffname = t1[2]
    local time = tonumber(t1[3])
    local show = t1[4] == "true"
    if self.items[name] == nil then
        self.items[name] = {name = name, buffname = buffname, time = time, show = show}
    else
        self.items[name].time = time
        self.items[name].show = show
    end
    self.pause = false
end

local function DoTickTask(self, inst)
    if self.items == nil then
        return
    end
    if not IsSimPaused() then
        for k, v in pairs(self.items) do
            if self.pause then
                break
            end
            local time = math.max(v.time - 1, 0)
            if time <= 0 then
                self.items[k].show = false
            else
                v.time = time
            end
        end
    end
end

local BuffTime = Class(function(self, inst)
    self.inst = inst

    self.pause = true

    self._itemdata = net_string(inst.GUID, "legend_bufftime._itemdata", "legend_itemdirty")
    self._itemdata1 = net_string(inst.GUID, "legend_bufftime._itemdata1", "legend_itemdirty1")
    inst:ListenForEvent("legend_itemdirty", function(inst) OnItemDirty(self, inst) end)
    inst:ListenForEvent("legend_itemdirty1", function(inst) OnItemDirty1(self, inst) end)

    inst:DoPeriodicTask(1, function(inst) DoTickTask(self, inst) end)

end, nil, {})

function BuffTime:GetItems()
    return self.items or {}
end

function BuffTime:SyncAllData(data)
    self._itemdata:set_local(data)
    self._itemdata:set(data)
end

function BuffTime:SyncData(data)
    self.pause = true
    self._itemdata1:set_local(data)
    self._itemdata1:set(data)
end

return BuffTime