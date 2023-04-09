local UIAnim = require "widgets/uianim"

local Medal_SpacetimeDustOver = Class(UIAnim, function(self, owner)
    self.owner = owner
    UIAnim._ctor(self)

    self:SetClickable(false)

    self:SetHAnchor(ANCHOR_MIDDLE)
    self:SetVAnchor(ANCHOR_MIDDLE)
    -- self:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)
    self:SetScaleMode(SCALEMODE_FIXEDPROPORTIONAL)


    self:GetAnimState():SetBank("sand_over")
    self:GetAnimState():SetBuild("medal_spacetimestorm_over")
    self:GetAnimState():PlayAnimation("dust_loop")--, true)
    self:GetAnimState():AnimateWhilePaused(false)
end)

return Medal_SpacetimeDustOver
