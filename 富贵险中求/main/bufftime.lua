

local BuffTime = require "widgets/ndnr_bufftime"
AddClassPostConstruct("widgets/controls", function(self, owner)

    local scale = TheFrontEnd:GetHUDScale()
    self.ndnr_bufftime = self:AddChild(BuffTime(self.owner))
    self.ndnr_bufftime:SetScaleMode(SCALEMODE_PROPORTIONAL)
    self.ndnr_bufftime:SetHAnchor(ANCHOR_LEFT)
    self.ndnr_bufftime:SetVAnchor(ANCHOR_BOTTOM)
    self.ndnr_bufftime:SetMaxPropUpscale(MAX_HUD_SCALE)
    self.ndnr_bufftime:SetPosition(50*scale, 210*scale)

    local _SetHUDSize = self.SetHUDSize
    function self:SetHUDSize()
        if self.ndnr_bufftime then
            local scale = TheFrontEnd:GetHUDScale()
            self.ndnr_bufftime:SetScale(scale)
            self.ndnr_bufftime:SetPosition(50*scale, 210*scale)
        end
        _SetHUDSize(self)
    end

end)