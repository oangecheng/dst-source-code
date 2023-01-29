local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"

local EmoBadge = Class(Badge, function(self, owner, art)
    Badge._ctor(self, nil, owner, { 255 / 255, 204 / 255, 51 / 255, 1 }, "status_emo", nil, nil, true)

    self.emoarrow = self.underNumber:AddChild(UIAnim())
    self.emoarrow:GetAnimState():SetBank("sanity_arrow")
    self.emoarrow:GetAnimState():SetBuild("sanity_arrow")
    self.emoarrow:GetAnimState():PlayAnimation("neutral")
    self.emoarrow:SetClickable(false)
    self.emoarrow:GetAnimState():AnimateWhilePaused(false)

    self:StartUpdating()
end)

local RATE_SCALE_ANIM =
{
    [RATE_SCALE.INCREASE_HIGH] = "arrow_loop_increase_most",
    [RATE_SCALE.INCREASE_MED] = "arrow_loop_increase_more",
    [RATE_SCALE.INCREASE_LOW] = "arrow_loop_increase",
    [RATE_SCALE.DECREASE_HIGH] = "arrow_loop_decrease_most",
    [RATE_SCALE.DECREASE_MED] = "arrow_loop_decrease_more",
    [RATE_SCALE.DECREASE_LOW] = "arrow_loop_decrease",
}
function EmoBadge:OnUpdate(dt)
    if TheNet:IsServerPaused() then return end

    local ndnr_emo = self.owner.replica.ndnr_emo
    local anim = "neutral"

    if ndnr_emo ~= nil then
        local ratescale = ndnr_emo:GetRateScale()
        if ratescale == RATE_SCALE.INCREASE_LOW or
            ratescale == RATE_SCALE.INCREASE_MED or
            ratescale == RATE_SCALE.INCREASE_HIGH or
            ratescale == RATE_SCALE.DECREASE_LOW or
            ratescale == RATE_SCALE.DECREASE_MED or
            ratescale == RATE_SCALE.DECREASE_HIGH then
            anim = RATE_SCALE_ANIM[ratescale]
        end
    end

    if anim ~= nil and self.arrowdir ~= anim then
        self.arrowdir = anim
        self.emoarrow:GetAnimState():PlayAnimation(anim, true)
    end
end

return EmoBadge
