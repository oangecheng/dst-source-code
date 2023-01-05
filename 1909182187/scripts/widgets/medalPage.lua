local Widget = require "widgets/widget" 
local ImageButton = require "widgets/imagebutton"

local medalPage = Class(Widget, function(self)
	Widget._ctor(self, "medalPage")
	self.root = self:AddChild(Widget("ROOT"))		
	self.pageIcon = self.root:AddChild(ImageButton("images/medal_page_icon.xml", "medal_page_icon.tex", nil, nil, nil, nil, {1,1}, {0,0}))
	self.pageIcon:SetScale(0.6, 0.6, 0.6)
	self.pageIcon:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
	self.pageIcon:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
	self.pageIcon:SetPosition(26,26,0)
	self.pageIcon:SetTooltip(STRINGS.MEDAL_UI.MEDALPAGETIPS)--tips
	self.pageIcon:SetOnClick(function()
		-- VisitURL("https://www.guanziheng.com/", false)
		if ThePlayer and ThePlayer.HUD then
			ThePlayer.HUD:ShowMedalSettingsScreen()
		end
	end)
end)

return medalPage