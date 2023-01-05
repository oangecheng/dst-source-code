local Screen = require "widgets/screen"
local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"
local TEMPLATES = require "widgets/redux/templates"
local MedalSkinWidget = require "widgets/redux/medalskinwidget"

local MedalSkinPopupScreen = Class(Screen, function(self, owner, staff)
    self.owner = owner
    Screen._ctor(self, "MedalSkinPopupScreen")

    local black = self:AddChild(ImageButton("images/global.xml", "square.tex"))
    black.image:SetVRegPoint(ANCHOR_MIDDLE)
    black.image:SetHRegPoint(ANCHOR_MIDDLE)
    black.image:SetVAnchor(ANCHOR_MIDDLE)
    black.image:SetHAnchor(ANCHOR_MIDDLE)
    black.image:SetScaleMode(SCALEMODE_FILLSCREEN)
    black.image:SetTint(0,0,0,.5)
    black:SetOnClick(function() TheFrontEnd:PopScreen() end)
    black:SetHelpTextMessage("")

	local root = self:AddChild(Widget("root"))
	root:SetScaleMode(SCALEMODE_PROPORTIONAL)
    root:SetHAnchor(ANCHOR_MIDDLE)
    root:SetVAnchor(ANCHOR_MIDDLE)
	root:SetPosition(0, -25)

	self.medalskin = root:AddChild(MedalSkinWidget(owner,staff))

	self.default_focus = self.medalskin

    -- SetAutopaused(true)
end)

function MedalSkinPopupScreen:OnDestroy()
    -- SetAutopaused(false)

    POPUPS.MEDALSKIN:Close(self.owner)

	MedalSkinPopupScreen._base.OnDestroy(self)
end

function MedalSkinPopupScreen:OnBecomeInactive()
    MedalSkinPopupScreen._base.OnBecomeInactive(self)
end

function MedalSkinPopupScreen:OnBecomeActive()
    MedalSkinPopupScreen._base.OnBecomeActive(self)
end

function MedalSkinPopupScreen:OnControl(control, down)
    if MedalSkinPopupScreen._base.OnControl(self, control, down) then return true end

    if not down and (control == CONTROL_MAP or control == CONTROL_CANCEL) then
		TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
        TheFrontEnd:PopScreen()
        return true
    end

	return false
end

function MedalSkinPopupScreen:GetHelpText()
    local controller_id = TheInput:GetControllerID()
    local t = {}

    table.insert(t,  TheInput:GetLocalizedControl(controller_id, CONTROL_CANCEL) .. " " .. STRINGS.UI.HELP.BACK)

    return table.concat(t, "  ")
end

return MedalSkinPopupScreen
