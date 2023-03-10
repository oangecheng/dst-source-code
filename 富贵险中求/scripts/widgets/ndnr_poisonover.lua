local Widget = require "widgets/widget"
local Image = require "widgets/image"

local PoisonOver =  Class(Widget, function(self, owner)
    self.owner = owner
    Widget._ctor(self, "PoisonOver")

    self:SetClickable(false)

    self.bg = self:AddChild(Image("images/fx2.xml", "fume_over.tex"))
    self.bg:SetVRegPoint(ANCHOR_MIDDLE)
    self.bg:SetHRegPoint(ANCHOR_MIDDLE)
    self.bg:SetVAnchor(ANCHOR_MIDDLE)
    self.bg:SetHAnchor(ANCHOR_MIDDLE)
    self.bg:SetScaleMode(SCALEMODE_FILLSCREEN)

    self:Hide()
    self.base_level = 0
    self.level = 0
    self.k = 1
    --self:UpdateState()
    self.time_since_pulse = 0
    self.pulse_period = 1

    self.inst:ListenForEvent("startpoisonover", function(inst, data)
        if self.owner == data.target then
            self:TurnOn()
        end
    end, self.owner)
    self.inst:ListenForEvent("stoppoisonover", function(inst, data)
        if self.owner == data.target then
            self:TurnOff()
        end
    end, self.owner)
    self.inst:DoTaskInTime(0, function(inst, data) self:TurnOff() end)
end)

function PoisonOver:TurnOn()
    --TheInputProxy:AddVibration(VIBRATION_BLOOD_FLASH, .2, .7, true)
    self:StartUpdating()
    self.base_level = .5
    self.k = 5
    self.time_since_pulse = 0
end

function PoisonOver:TurnOff()
    self.base_level = 0
    self.k = 5
    --self:OnUpdate(0)
end

function PoisonOver:OnUpdate(dt)
    -- ignore 0 interval
    -- ignore abnormally large intervals as they will destabilize the math in here
    if dt <= 0 or dt > 0.1 then
        return
    end

    local delta = self.base_level - self.level

    if math.abs(delta) < .025 then
        self.level = self.base_level
    else
        self.level = self.level + delta * dt * self.k
    end

    if self.base_level > 0 and not IsSimPaused() then
        self.time_since_pulse = self.time_since_pulse + dt
        if self.time_since_pulse > self.pulse_period then
            self.time_since_pulse = 0

            if not self.owner.replica.health:IsDead() then
                TheInputProxy:AddVibration(VIBRATION_BLOOD_OVER, .2, .3, false)
            end
        end
    end

    if self.level > 0 then
        self:Show()
        self.bg:SetTint(1, 1, 1, self.level)
    else
        self:StopUpdating()
        self:Hide()
    end
end

function PoisonOver:Flash()
    TheInputProxy:AddVibration(VIBRATION_BLOOD_FLASH, .2, .7, false)
    self:StartUpdating()
    self.level = 1
    self.k = 1.33
end

return PoisonOver
