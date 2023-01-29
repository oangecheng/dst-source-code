local function onmax(self, max)
    self.inst.replica.ndnr_emo:SetMax(max)
end

local function oncurrent(self, current)
    self.inst.replica.ndnr_emo:SetCurrent(current)
end

local function OnTaskTick(inst, self, period)
    self:DoDec(period)

    for k, v in pairs(self.hello) do
        if GetTime() - v > TUNING.TOTAL_DAY_TIME then
            self.hello[k] = nil
        end
    end
end

local Emo = Class(function(self, inst)
    self.inst = inst
    self.current = 100
    self.max = 100
    self.emorate = {}
    self.rate = -1
    self.base = 100 / (10 * TUNING.TOTAL_DAY_TIME)

    self.hello = {}

    local period = 1
    self.inst:DoPeriodicTask(period, OnTaskTick, nil, self, period)
end, nil, {
    max = onmax,
    current = oncurrent
})

--[[
    RATE_SCALE =
{
    NEUTRAL = 0,
    INCREASE_HIGH = 1,
    INCREASE_MED = 2,
    INCREASE_LOW = 3,
    DECREASE_HIGH = 4,
    DECREASE_MED = 5,
    DECREASE_LOW = 6,
}
]]
function Emo:GetRateScale()
    local rate = -1
    for _, v in pairs(self.emorate) do
        rate = rate + v
    end

    local days_survived = self.inst.components.age ~= nil and self.inst.components.age:GetAgeInDays() or TheWorld.state.cycles
    if days_survived <= 3 then
        return RATE_SCALE.NEUTRAL
    end

    return (rate >= 1 and RATE_SCALE.INCREASE_HIGH) or
        (rate >= 0.5 and RATE_SCALE.INCREASE_MED) or
        (rate > 0 and RATE_SCALE.INCREASE_LOW) or
        (rate <= -2 and RATE_SCALE.DECREASE_HIGH) or
        (rate <= -1.5 and RATE_SCALE.DECREASE_MED) or
        (rate < 0 and RATE_SCALE.DECREASE_LOW) or
        RATE_SCALE.NEUTRAL
end

function Emo:OnSave()
    return {
        current = self.current,
        emorate = self.emorate
    }
end

function Emo:OnLoad(data)
    if data.current ~= nil and self.current ~= data.current then
        self.current = data.current
    end
    if data.emorate ~= nil then
        self.emorate = data.emorate
    end
    self:DoDelta(0)
end

function Emo:LongUpdate(dt)
    self:DoDec(dt, true)
end

function Emo:DoDelta(delta, overtime, ignore_invincible)
    local days_survived = self.inst.components.age ~= nil and self.inst.components.age:GetAgeInDays() or TheWorld.state.cycles
    if not ignore_invincible and self.inst.components.health and self.inst.components.health:IsInvincible() or
        self.inst.is_teleporting or days_survived <= 3 or self.inst:HasTag("playerghost") then -- 前三天处于新鲜感，不会孤独
        return
    end

    local old = self.current
    self.current = math.clamp(self.current + delta, 0, self.max)

    self.inst:PushEvent("emodelta", {
        oldpercent = old / self.max,
        newpercent = self.current / self.max,
        overtime = overtime,
        delta = self.current - old
    })
end

function Emo:Calc(dt)
    local rate = -1
    for k, v in pairs(self.emorate) do
        rate = rate + v
    end
    return self.base * rate * dt
end

function Emo:DoDec(dt, ignore_damage)
    -- for k, v in pairs(self.emorate) do
    --     print("emo", k,v, self.inst)
    -- end
    -- print("-------------------------------")
    self:DoDelta(self:Calc(dt), true)
end

function Emo:GetPercent()
    return self.current / self.max
end

function Emo:SetPercent(p, overtime)
    local old = self.current
    self.current = p * self.max
    self.inst:PushEvent("emodelta", {
        oldpercent = old / self.max,
        newpercent = p,
        overtime = overtime
    })
end

function Emo:AddEmorate(name, rate)
    if not self.inst:HasTag("playerghost") then
        self.emorate[name] = rate
    end
end

function Emo:RemoveEmorate(name)
    if self.emorate[name] ~= nil then
        self.emorate[name] = nil
    end
end

function Emo:RemoveAllEmorate(name)
    self.emorate = {}
end

function Emo:SetHello(uid)
    self.hello[uid] = GetTime()
end

return Emo

