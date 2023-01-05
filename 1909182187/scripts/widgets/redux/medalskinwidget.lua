local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local Widget = require "widgets/widget"
local Text = require "widgets/text"

local MedalSkinPage = require "widgets/redux/medalskinpage"

require("util")

-------------------------------------------------------------------------------------------------------
local MedalSkinWidget = Class(Widget, function(self, owner, staff)
    Widget._ctor(self, "MedalSkinWidget")
    self.root = self:AddChild(Widget("root"))

	self.tab_root = self.root:AddChild(Widget("tab_root"))

	self.backdrop = self.root:AddChild(Image("images/plantregistry.xml", "backdrop.tex"))

	-- if not ThePlantRegistry:ApplyOnlineProfileData() then
	-- 	local msg = (TheFrontEnd ~= nil and TheFrontEnd:GetIsOfflineMode() or not TheNet:IsOnlineMode()) and STRINGS.UI.PLANTREGISTRY.ONLINE_DATA_USER_OFFLINE or STRINGS.UI.PLANTREGISTRY.ONLINE_DATA_DOWNLOAD_FAILED
	-- 	self.sync_status = self.root:AddChild(Text(HEADERFONT, 18, msg, UICOLOURS.GREY))
	-- 	self.sync_status:SetPosition(0, -285)
	-- end

	local base_size = .7

	local button_data = {
		-- {text = STRINGS.UI.PLANTREGISTRY.TAB_TITLE_PLANTS, build_panel_fn = function() return PlantsPage(self) end},
		{text = STRINGS.MEDAL_UI.SKIN_TITLE, build_panel_fn = function() return MedalSkinPage(self,owner,staff) end},
	}

	local function MakeTab(data, index)
        local tab = ImageButton("images/plantregistry.xml", "plant_tab_inactive.tex", nil, nil, nil, "plant_tab_active.tex")

		tab:SetFocusScale(base_size, base_size)
		tab:SetNormalScale(base_size, base_size)
		tab:SetText(data.text)
		tab:SetTextSize(22)
		tab:SetFont(HEADERFONT)
		tab:SetTextColour(UICOLOURS.GOLD)
		tab:SetTextFocusColour(UICOLOURS.GOLD)
		tab:SetTextSelectedColour(UICOLOURS.GOLD)
		tab.text:SetPosition(0, -4)
		tab.clickoffset = Vector3(0,5,0)
		tab:SetOnClick(function()
	        self.last_selected:Unselect()
	        self.last_selected = tab
			tab:Select()
			tab:MoveToFront()
			if self.panel ~= nil then
				self.panel:Kill()
			end
			self.panel = self.root:AddChild(data.build_panel_fn())

		    if TheInput:ControllerAttached() then
				self.panel.parent_default_focus:SetFocus()
			end

			ThePlantRegistry:SetFilter("tab", index)
		end)
		tab._tabindex = index - 1

		return tab
	end

	self.tabs = {}
	for i = 1, #button_data do
		table.insert(self.tabs, self.tab_root:AddChild(MakeTab(button_data[i], i)))
		self.tabs[#self.tabs]:MoveToBack()
	end
	self:_PositionTabs(self.tabs, 200, 285)

	-----
	local starting_tab = ThePlantRegistry:GetFilter("tab")
	if self.tabs[starting_tab] == nil then
		starting_tab = 1
	end
	self.last_selected = self.tabs[starting_tab]
	self.last_selected:Select()
	self.last_selected:MoveToFront()
	self.panel = self.root:AddChild(button_data[starting_tab].build_panel_fn())

	self.focus_forward = function() return self.panel.parent_default_focus end
end)

function MedalSkinWidget:Kill()
	ThePlantRegistry:Save() -- for saving filter settings

	MedalSkinWidget._base.Kill(self)
end

function MedalSkinWidget:_PositionTabs(tabs, w, y)
	local offset = #self.tabs / 2
	for i = 1, #self.tabs do
		local x = (i - offset - 0.5) * w
		tabs[i]:SetPosition(x, y)
	end
end

function MedalSkinWidget:OnControlTabs(control, down)
	if control == CONTROL_OPEN_CRAFTING then
		local tab = self.tabs[((self.last_selected._tabindex - 1) % #self.tabs) + 1]
		if not down then
			tab.onclick()
			return true
		end
	elseif control == CONTROL_OPEN_INVENTORY then
		local tab = self.tabs[((self.last_selected._tabindex + 1) % #self.tabs) + 1]
		if not down then
			tab.onclick()
			return true
		end
	end

end

function MedalSkinWidget:OnControl(control, down)
    if MedalSkinWidget._base.OnControl(self, control, down) then return true end

	if #self.tabs > 1 then
		return self:OnControlTabs(control, down)
	end
end

function MedalSkinWidget:GetHelpText()
    local controller_id = TheInput:GetControllerID()
    local t = {}

	if #self.tabs > 1 then
		table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_OPEN_CRAFTING).."/"..TheInput:GetLocalizedControl(controller_id, CONTROL_OPEN_INVENTORY).. " " .. STRINGS.UI.HELP.CHANGE_TAB)
	end

    return table.concat(t, "  ")
end


return MedalSkinWidget