local function DoTickTask(self, inst)
    if not IsSimPaused() then
        for k, v in pairs(self.items) do
            local time = v.time - 1
            if time <= 0 then
                self.items[k].show = false
            else
                v.time = time
            end
        end
    end
end

local function GetAllData(self)
    local _items = ""
    for k, v in pairs(self.items) do
        _items = _items .. (_items == "" and "" or ";") .. v.name .. "," .. v.buffname .. "," .. v.time .. "," .. tostring(v.show)
    end
    return _items
end

local BuffTime = Class(function(self, inst)
    self.inst = inst
    self.items = {}

    self.inst:DoPeriodicTask(1, function(inst) DoTickTask(self, inst) end)

    self.inst:ListenForEvent("ms_becameghost", function(inst)
        for k, v in pairs(self.items) do
            v.time = 0
        end
    end)
end, nil, {})

function BuffTime:SetItem(item)
    self.items[item.name] = item
    self.items[item.name].show = true

    -- self:SyncData(item.name, item.buffname, item.time, true)
    self:SyncAllData()
end

function BuffTime:RemoveItem(name)
    if self.items[name] then
        self.items[name].time = 0
        self.items[name].show = false

        self:SyncAllData()
    end
end

-- 只同步一个buff的话，当吃一个料理同时拥有两个buff效果，就会只同步过去一个，具体原因不明，可能是同一时间同步的数据引擎做“优化”了
function BuffTime:SyncData(name, buffname, time, visible)
    if self.inst.replica.legend_bufftime then
        self.inst.replica.legend_bufftime:SyncData(name ..";"..buffname..";"..tostring(time)..";"..tostring(visible))
    end
end

function BuffTime:SyncAllData()
    if self.inst.replica.legend_bufftime then
        self.inst.replica.legend_bufftime:SyncAllData(GetAllData(self))
    end
end

function BuffTime:OnSave()
    return {
        items = self.items
    }
end

function BuffTime:OnLoad(data)
    if data.items then
        self.items = data.items
    end
    self:SyncAllData()
end

return BuffTime