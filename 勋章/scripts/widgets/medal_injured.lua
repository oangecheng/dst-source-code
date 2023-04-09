local Widget = require "widgets/widget"
local Image = require "widgets/image"
local easing = require "easing"

local MedalInjured =  Class(Widget, function(self, owner)

	self.owner = owner
	Widget._ctor(self, "MedalInjured")
	
	self:SetClickable(false)

    -- self.bg = self:AddChild(Image("images/fx2.xml", "fume_over.tex"))
    self.bg = self:AddChild(Image("images/medal_injured.xml", "medal_injured.tex"))
    self.bg:SetVRegPoint(ANCHOR_MIDDLE)
    self.bg:SetHRegPoint(ANCHOR_MIDDLE)
    self.bg:SetVAnchor(ANCHOR_MIDDLE)
    self.bg:SetHAnchor(ANCHOR_MIDDLE)
    self.bg:SetScaleMode(SCALEMODE_FILLSCREEN)

    
    self:Hide()
    self.dir = 0
    self.base_level = 0
    self.level = 0
    self.target_level = 0
    self.fade_in_duration = .4
    self.fade_out_duration = .6
    self.flash_time = 0
    self.k = 1
    self:TurnOff()
    self.time_since_pulse = 0 
    self.pulse_period = 1

end)

function MedalInjured:TurnOn()
    
    self:StartUpdating()
    self.base_level = .5
    self.k = 5
    self.time_since_pulse = 0
end

function MedalInjured:TurnOff()
    self.base_level = 0    
    self.k = 5
    self:OnUpdate(0)
    self.flashing = false
end

function MedalInjured:OnUpdate(dt)
    
    if dt > 0.1 then return end
    
    local delta = self.target_level - self.base_level

    if math.abs(delta) < .025 then
        self.level = self.base_level
    else
        if self.dir > 0 then
            self.level = easing.inQuad(GetTime()-self.flash_time, 0, 1, self.fade_in_duration)
        else
            self.level = easing.inQuad(GetTime()-self.flash_time, 1, -1, self.fade_out_duration)
        end
    end

    if self.level > 1 then self.level = 1 end
    if self.level < 0 then self.level = 0 end

    if self.flashing and self.level >= 1 and self.dir > 0 then
        self.dir = -self.dir
        self.flash_time = GetTime()
    end

    if self.base_level > 0 and not IsSimPaused() then
        self.time_since_pulse = self.time_since_pulse + dt
        if self.time_since_pulse > self.pulse_period then
            self.time_since_pulse = 0
        end
    end

    if GetTime() - self.flash_time > self.fade_out_duration and self.dir < 0 then
        self:StopUpdating()
        self:Hide()
        self.flashing = false
    else
        self:Show()
        self.bg:SetTint(1,1,1,self.level)
    end
end
--开始闪烁
function MedalInjured:Flash()
    self:StartUpdating()    
    self.flashing = true
    self.base_level = 0
    self.level = 0
    self.target_level = 1
    self.k = .5
    self.dir = 1
    self.flash_time = GetTime()
end

return MedalInjured