local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local Text = require "widgets/text"
local UIAnim = require "widgets/uianim"
local Widget = require "widgets/widget"
local TEMPLATES = require "widgets/redux/templates"
local Spinner = require "widgets/spinner"
local PopupDialogScreen = require "screens/redux/popupdialog"

local MEDAL_SKINS=require("medal_defs/medal_skin_defs")

local MedalSkinPage = Class(Widget, function(self, parent_widget,owner,staff)
    Widget._ctor(self, "MedalSkinPage")

    self.parent_widget = parent_widget
	self.staff=staff
	if staff and staff.skin_str then
		local skin_str=staff.skin_str:value()
		self.skin_data = json.decode(skin_str)--法杖皮肤数据解包
	end

	self.root = self:AddChild(Widget("root"))

	--皮肤面板
	self.skin_grid = self.root:AddChild(self:BuildSkinScrollGrid())
	self.skin_grid:SetPosition(-15, -12)--腾点位置给货币

	--当前货币数量
	self.skin_money = self.root:AddChild(Text(CODEFONT, 24))
	self.skin_money:SetPosition(-345, 242)
	self.skin_money:SetRegionSize( 70, 24 )
	self.skin_money:SetHAlign( ANCHOR_LEFT)--ANCHOR_MIDDLE )
	self.skin_money:SetString(staff and staff.skin_money and staff.skin_money:value() or "888")
	self.skin_money:SetColour(UICOLOURS.GOLD)
	--货币图标
	self.money_icon = self.root:AddChild(Image("images/medal_skin_money.xml", "medal_skin_money.tex"))
	-- self.money_icon:ScaleToSize(20, 20)
	self.money_icon:SetSize(18, 18)
	self.money_icon:SetPosition(-390, 243)

	--已解锁皮肤数量(文字)
	self.skin_num = self.root:AddChild(Text(CODEFONT, 24))
	self.skin_num:SetPosition(-250, 243)
	self.skin_num:SetRegionSize( 150, 24 )
	self.skin_num:SetHAlign( ANCHOR_LEFT)--ANCHOR_MIDDLE )
	self.skin_num:SetString("已拥有:5/20")
	self.skin_num:SetColour(UICOLOURS.GOLD)

	--提示文字
	self.skin_help = self.root:AddChild(Text(CODEFONT, 24))
	self.skin_help:SetPosition(0, 243)
	self.skin_help:SetRegionSize( 250, 24 )
	self.skin_help:SetHAlign( ANCHOR_LEFT)--ANCHOR_MIDDLE )
	self.skin_help:SetString(STRINGS.MEDAL_UI.SKIN_HELP)
	self.skin_help:SetColour(UICOLOURS.GOLD)


	local skin_grid_data = {}--皮肤数据
	self.all_skin_num=0--皮肤总数量
	for i,v in pairs(MEDAL_SKINS) do--遍历皮肤数据表
		if not v.hide then
			table.insert(skin_grid_data,{sort_num=v.sort_num,name=i,skin_info=v.skin_info,currentid=1})
			if v.skin_info then
				self.all_skin_num=self.all_skin_num+#v.skin_info
			end
		end
	end
	table.sort(skin_grid_data, function(a,b) return a.sort_num < b.sort_num end)--排序(免得pairs打乱了)
	self.skin_grid:SetItemsData(skin_grid_data)

	self.parent_default_focus = self.skin_grid
	self:SetSkinNumText()
end)

local textures = {
	arrow_left_normal = "arrow2_left.tex",
	arrow_left_over = "arrow2_left_over.tex",
	arrow_left_disabled = "arrow_left_disabled.tex",
	arrow_left_down = "arrow2_left_down.tex",
	arrow_right_normal = "arrow2_right.tex",
	arrow_right_over = "arrow2_right_over.tex",
	arrow_right_disabled = "arrow_right_disabled.tex",
	arrow_right_down = "arrow2_right_down.tex",
	bg_middle = "blank.tex",
	bg_middle_focus = "blank.tex",
	bg_middle_changing = "blank.tex",
	bg_end = "blank.tex",
	bg_end_focus = "blank.tex",
	bg_end_changing = "blank.tex",
	bg_modified = "option_highlight.tex",
}
--构造皮肤列表
function MedalSkinPage:BuildSkinScrollGrid()
    local row_w = 160
    local row_h = 230
	local row_spacing = 2

	local width_spinner = 135
	local width_label = 135
	local height = 25

	local font = HEADERFONT
	local font_size = 20

	local function ScrollWidgetsCtor(context, index)
		-- local w = Widget("plant-cell-".. index)
		local root=self
		local w = Widget("skin-cell-".. index)
		w.cell_root = w:AddChild(ImageButton("images/plantregistry.xml", "plant_entry.tex", "plant_entry_focus.tex"))

		w.focus_forward = w.cell_root

		w.cell_root.ongainfocusfn = function()
			self.skin_grid:OnWidgetFocus(w)
		end
		--外框
		w.skin_seperator = w.cell_root:AddChild(Image("images/plantregistry.xml", "plant_entry_seperator.tex"))
		w.skin_seperator:SetPosition(0, 88)
		--皮肤贴图
		w.skin_img = w.cell_root:AddChild(Image())
		w.skin_img:SetPosition(0, 0)
		w.skin_img:SetScale(0.8, 0.8)
		--皮肤预制物名称
		w.skin_label = w.cell_root:AddChild(Text(font, font_size))
		w.skin_label:SetPosition(0, 100)
		w.skin_label:SetRegionSize( width_label, height )
		w.skin_label:SetHAlign( ANCHOR_MIDDLE )
		--皮肤预制物名称
		w.skin_name = w.cell_root:AddChild(Text(font, font_size))
		w.skin_name:SetPosition(0, 78)
		w.skin_name:SetRegionSize( width_label, height )
		w.skin_name:SetHAlign( ANCHOR_MIDDLE )
		w.skin_name:SetColour(PLANTREGISTRYUICOLOURS.UNLOCKEDBROWN)
		--货币图标
		w.money_icon = w.cell_root:AddChild(Image("images/medal_skin_money.xml", "medal_skin_money.tex"))
		-- w.money_icon:ScaleToSize(20, 20)
		w.money_icon:SetSize(16, 16)
		w.money_icon:SetPosition(-15, -72)
		
		--已购买文字显示
		w.bought_label = w.cell_root:AddChild(Text(font, font_size))
		w.bought_label:SetPosition(0, -95)
		w.bought_label:SetRegionSize( width_label, height )
		w.bought_label:SetHAlign( ANCHOR_MIDDLE )
		w.bought_label:SetString(STRINGS.MEDAL_UI.SKIN_BOUGHT)
		w.bought_label:SetColour(PLANTREGISTRYUICOLOURS.UNLOCKEDBROWN)
		

		local lean = true
		--皮肤切换箭头
		w.skin_spinner = w.cell_root:AddChild(Spinner({}, width_spinner, height, {font = font, size = font_size}, nil, "images/plantregistry.xml", textures, lean))

		w.skin_spinner:SetPosition(0, -85)
		w.skin_spinner:SetTextColour(PLANTREGISTRYUICOLOURS.UNLOCKEDBROWN)
		w.skin_spinner.text:SetPosition(8, 12)

		--购买按钮
		w.buy_button = w.cell_root:AddChild(
			TEMPLATES.StandardButton(
				nil,
				STRINGS.MEDAL_UI.SKIN_BUY_BUTTON,--按钮文字
				{60, 30}--按钮尺寸
			)
		)
		w.buy_button:SetTextSize(18)
		w.buy_button:SetPosition(0, -95, 0)
		
		--皮肤展示卡
		function w:SetSkinPage(name, skinid)
			local data=w.data
			if not data then return end
			data.currentid = skinid
			if data.skin_info and data.skin_info[skinid] then
				local money = root.staff and root.staff.skin_money and root.staff.skin_money:value()--当前拥有的钱
				local price = data.skin_info[skinid].price--价格
				if data.skin_info[skinid].image then
					w.skin_img:SetTexture("images/medal_skins.xml", data.skin_info[skinid].image..".tex")
				end
				if data.skin_info[skinid].name then
					w.skin_name:SetString(data.skin_info[skinid].name)
				end
				if price then
					--已拥有皮肤
					if root.skin_data and root.skin_data[name] and table.contains(root.skin_data[name],skinid) then
						w.buy_button:Hide()
						w.bought_label:Show()
						w.bought_label:SetString(STRINGS.MEDAL_UI.SKIN_BOUGHT)
						w.bought_label:SetColour(PLANTREGISTRYUICOLOURS.UNLOCKEDBROWN)
					elseif price<=0 then--需要用皮肤券解锁
						w.buy_button:Hide()
						w.bought_label:Show()
						w.bought_label:SetString(STRINGS.MEDAL_UI.SKIN_NEED_COUPON)
						w.bought_label:SetColour({ 247 / 255, 227 / 255, 165 / 255, 1 })
					else
						if money and money >= price then
							w.buy_button:SetOnClick(function()
								-- print(money,name,skinid,price)
								local popup
								-- popup = PopupDialogScreen(STRINGS.MEDAL_UI.DELETEPOS_TITLE, STRINGS.MEDAL_UI.DELETEPOS_INFO,
								popup = PopupDialogScreen(STRINGS.MEDAL_UI.SKIN_TIP_TITLE, STRINGS.MEDAL_UI.SKIN_TIP_INFO1..price..STRINGS.MEDAL_UI.SKIN_TIP_INFO2,
									{
										{text=STRINGS.MEDAL_UI.DELETEPOS_YES, cb = function()
											if root.staff and root.staff.buy_skin_client then
												root.staff:buy_skin_client(name,skinid,price)
											end
											-- root:OnUpdateInfo()--更新数据
											root.inst:DoSimTaskInTime(.2,function()
												root:OnUpdateInfo()--更新数据
											end)
											TheFrontEnd:PopScreen(popup)
										end},
										{text=STRINGS.MEDAL_UI.DELETEPOS_NO, cb = function()
											TheFrontEnd:PopScreen(popup)
										end},
									}
								)
								TheFrontEnd:PushScreen(popup)
							end)
							w.buy_button:Enable()
						else--钱不够不让点购买
							w.buy_button:Disable()
						end
						w.bought_label:Hide()
						w.buy_button:Show()
					end
				end
			end
		end

		local _OnControl = w.cell_root.OnControl
		w.cell_root.OnControl = function(_, control, down)
			if w.skin_spinner.focus or (control == CONTROL_PREVVALUE or control == CONTROL_NEXTVALUE) then if w.skin_spinner:IsVisible() then w.skin_spinner:OnControl(control, down) end return true end
			if w.buy_button.focus or (control == CONTROL_PREVVALUE or control == CONTROL_NEXTVALUE) then if w.buy_button:IsVisible() then w.buy_button:OnControl(control, down) end return true end
			return _OnControl(_, control, down)
		end

		local _OnGainFocus = w.cell_root.OnGainFocus
		function w.cell_root.OnGainFocus()
			_OnGainFocus(w.cell_root)
			w.skin_seperator:SetTexture("images/plantregistry.xml", "plant_entry_seperator_focus.tex")
			w.skin_label:SetColour(PLANTREGISTRYUICOLOURS.LOCKEDBROWN)
			w.skin_spinner:SetTextColour(PLANTREGISTRYUICOLOURS.LOCKEDBROWN)
		end
		local _OnLoseFocus = w.cell_root.OnLoseFocus
		function w.cell_root.OnLoseFocus()
			_OnLoseFocus(w.cell_root)
			if not w.data then return end
			if ThePlantRegistry:IsAnyPlantStageKnown(w.data.plant) then
				w.skin_seperator:SetTexture("images/plantregistry.xml", "plant_entry_seperator_active.tex")
			else
				w.skin_seperator:SetTexture("images/plantregistry.xml", "plant_entry_seperator.tex")
			end
			if w.skin_label:GetString() == STRINGS.UI.PLANTREGISTRY.MYSTERY_PLANT then
				w.skin_label:SetColour(PLANTREGISTRYUICOLOURS.LOCKEDBROWN)
			else
				w.skin_label:SetColour(PLANTREGISTRYUICOLOURS.UNLOCKEDBROWN)
			end
			w.skin_spinner:SetTextColour(PLANTREGISTRYUICOLOURS.UNLOCKEDBROWN)
		end

		function w.cell_root:GetHelpText()
			if not w.skin_spinner.focus and w.skin_spinner:IsVisible() then
				return w.skin_spinner:GetHelpText()
			end
		end
		--点击打开面板(现在没啥卵用)
		-- w.cell_root:SetOnClick(function()
		-- 	if not w.data then return end
		-- 	local widgetpath
		-- 	if ThePlantRegistry:IsAnyPlantStageKnown(w.data.plant) then
		-- 		widgetpath = w.data and w.data.plant_def.plantregistrywidget or nil
		-- 	else
		-- 		widgetpath = w.data and w.data.plant_def.unknownwidget or "widgets/redux/unknownplantpage"
		-- 	end
		-- 	if widgetpath then
		-- 		self:OpenPageWidget(widgetpath, w.data, w)
		-- 	end
		-- end)

		return w
	end
	--设定皮肤数据
	local function ScrollWidgetSetData(context, widget, data, index)
		if data == nil then
			widget.cell_root:Hide()
			return
		else
			widget.cell_root:Show()
		end
		-- if widget.data ~= data then
			widget.data = data
			widget:SetSkinPage(data.name, data.currentid)
			--设定预制物名
			local prefab_name_str = STRINGS.NAMES[string.upper(data.name)] or data.name
			widget.skin_label:SetString(prefab_name_str)

			local spinner_options = {}--皮肤选项卡数据
			for i, v in ipairs(data.skin_info) do--遍历数据表，加入到选项卡里
				table.insert(spinner_options,{text=v.price or 1,data=i})
			end

			widget.cell_root:SetTextures("images/plantregistry.xml", "plant_entry_active.tex", "plant_entry_focus.tex")
			widget.skin_seperator:SetTexture("images/plantregistry.xml", "plant_entry_seperator_active.tex")
			widget.skin_spinner:SetOptions(spinner_options)
			widget.skin_spinner:SetOnChangedFn(function(spinner_data)
				widget:SetSkinPage(data.name, spinner_data)
			end)
			widget.skin_spinner:SetSelected(data.currentid)

			
		-- end
    end

    local grid = TEMPLATES.ScrollingGrid(
        {},
        {
            context = {},
            widget_width  = row_w+row_spacing,
            widget_height = row_h+row_spacing,
			force_peek    = true,
            num_visible_rows = 2,
            num_columns      = 5,
            item_ctor_fn = ScrollWidgetsCtor,
            apply_fn     = ScrollWidgetSetData,
            scrollbar_offset = 15,
			scrollbar_height_offset = -60,
			peek_percent = 30/(row_h+row_spacing),
			end_offset = math.abs(1 - 5/(row_h+row_spacing)),
		})

	--滚动条设定
	grid.up_button:SetTextures("images/plantregistry.xml", "plantregistry_recipe_scroll_arrow.tex")
	grid.up_button:SetScale(0.5)

	grid.down_button:SetTextures("images/plantregistry.xml", "plantregistry_recipe_scroll_arrow.tex")
	grid.down_button:SetScale(-0.5)

	grid.scroll_bar_line:SetTexture("images/plantregistry.xml", "plantregistry_recipe_scroll_bar.tex")
	grid.scroll_bar_line:SetScale(.8)

	grid.position_marker:SetTextures("images/plantregistry.xml", "plantregistry_recipe_scroll_handle.tex")
	grid.position_marker.image:SetTexture("images/plantregistry.xml", "plantregistry_recipe_scroll_handle.tex")
	grid.position_marker:SetScale(.6)

    return grid
end

-- function MedalSkinPage:OpenPageWidget(plantregistrywidgetpath, data, currentwidget)
-- 	self.currentwidget = currentwidget
-- 	local plantregistrywidget = require(plantregistrywidgetpath)
-- 	self.plantregistrywidget = self.root:AddChild(plantregistrywidget(self, data))
-- 	self.plantregistrywidget:SetFocus(true)
-- 	self.parent_default_focus = self.plantregistrywidget
-- 	self.plant_grid:Hide()
-- 	self.plantregistrywidget:SetFocus()
-- 	if self.parent_widget then
-- 		self.parent_widget.tab_root:Hide()
-- 		if self.plantregistrywidget:HideBackdrop() then
-- 			self.parent_widget.backdrop:Hide()
-- 		end
-- 	end
-- end

-- function MedalSkinPage:ClosePageWidget()
-- 	if self.plantregistrywidget then
-- 		self.root:RemoveChild(self.plantregistrywidget)
-- 		self.plantregistrywidget:Kill()
-- 		self.plantregistrywidget = nil
-- 	end
-- 	self.parent_default_focus = self.plant_grid
-- 	self.plant_grid:Show()
-- 	if self.parent_widget then
-- 		self.parent_widget.tab_root:Show()
-- 		self.parent_widget.backdrop:Show()
-- 	end
-- 	if self.currentwidget then
-- 		self.currentwidget:SetFocus(true)
-- 		self.currentwidget = nil
-- 	else
-- 		self.plant_grid:SetFocus(true)
-- 	end
-- end

function MedalSkinPage:OnControl(control, down)
	if self.plantregistrywidget then
		self.plantregistrywidget:OnControl(control, down)
		return true
	end
	return MedalSkinPage._base.OnControl(self, control, down)
end

--更新数据
function MedalSkinPage:OnUpdateInfo()
	if self.staff then
		if self.staff.skin_str then
			local skin_str = self.staff.skin_str:value()
			self.skin_data = json.decode(skin_str)--法杖皮肤数据解包
		end
		if self.staff.skin_money then
			self.skin_money:SetString(self.staff.skin_money and self.staff.skin_money:value() or "888")
		end
	end

	self:SetSkinNumText()
	self.skin_grid:RefreshView()--更新数据
end

--设置已解锁皮肤的文字
function MedalSkinPage:SetSkinNumText()
	local all_num=self.all_skin_num or 0
	local has_num=0
	
	if self.skin_data then
		for k, v in pairs(self.skin_data) do
			has_num=has_num+#v
		end
	end

	self.skin_num:SetString(STRINGS.MEDAL_UI.SKIN_BOUGHT..":"..has_num.."/"..all_num.."")
end

return MedalSkinPage
