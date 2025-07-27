local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local Text = require "widgets/text"
local UIAnim = require "widgets/uianim"
local Widget = require "widgets/widget"
local TEMPLATES = require "widgets/redux/templates"
local Spinner = require "widgets/spinner"
local PopupDialogScreen = require "screens/redux/popupdialog"

local MEDAL_SKINS=require("medal_defs/medal_skin_defs")

local isch = TUNING.MEDAL_LANGUAGE =="ch"
local TEXT_L = isch and 68 or 68
local TEXT_M = isch and 56 or 48
local TEXT_S = isch and 40 or 26

local function AddTip(root,idx,icon,txt)
	local tip_icon = root:AddChild(Image("images/quagmire_recipebook.xml", icon))
	tip_icon:ScaleToSize(32, 32)
	tip_icon:SetPosition(68, -73-33*(idx-1))
	local tip_str = root:AddChild(Text(HEADERFONT, TEXT_S, STRINGS.MEDAL_UI.PAY_TRIBUTE_TIPS[idx], PLANTREGISTRYUICOLOURS.LOCKEDBROWN))
	tip_str:SetPosition(320, -73-33*(idx-1))
	tip_str:SetRegionSize( 460, 40 )
	tip_str:SetHAlign( ANCHOR_LEFT )
end

local MedalPayTributePage = Class(Widget, function(self, tributebox)
    Widget._ctor(self, "MedalPayTributePage")

    self.tributebox=tributebox
	self:OnUpdateInfo()--同步数据
	self.guess_num = 0--当前结果条数
	self.root = self:AddChild(Widget("root"))
	--标题
	local big_title = self.root:AddChild(Text(HEADERFONT, TEXT_L, STRINGS.MEDAL_UI.PAY_TRIBUTE_TITLE, PLANTREGISTRYUICOLOURS.LOCKEDBROWN))
	big_title:SetPosition(0, 340)
	big_title:SetHAlign( ANCHOR_MIDDLE )
	--顶部装饰线
	local title_boarder = self.root:AddChild(Image("images/quagmire_recipebook.xml", "quagmire_recipe_line_break.tex"))
	title_boarder:SetScale(1, -1)
    title_boarder:SetPosition(0, 300)
	--备选蔬果栏
	local small_title = self.root:AddChild(Text(HEADERFONT, TEXT_M, STRINGS.MEDAL_UI.PAY_TRIBUTE_SMALL_TITLE1, PLANTREGISTRYUICOLOURS.LOCKEDBROWN))
	small_title:SetPosition(-280, 240)
	small_title:SetHAlign( ANCHOR_MIDDLE )
	self:SetVeggies()
	
	--奉纳记录
	local small_title = self.root:AddChild(Text(HEADERFONT, TEXT_M, STRINGS.MEDAL_UI.PAY_TRIBUTE_SMALL_TITLE2, PLANTREGISTRYUICOLOURS.LOCKEDBROWN))
	small_title:SetPosition(0, 180)
	small_title:SetHAlign( ANCHOR_MIDDLE )

	local grid_boarder = self.root:AddChild(Image("images/quagmire_recipebook.xml", "quagmire_recipe_line_long.tex"))
	grid_boarder:SetPosition(-3, 150)
	--底部装饰线
	local title_boarder = self.root:AddChild(Image("images/quagmire_recipebook.xml", "quagmire_recipe_line_break.tex"))
	title_boarder:SetPosition(0, -280)
	--说明信息
	AddTip(self.root,1,"cookbook_new.tex")
	AddTip(self.root,2,"coin4.tex")
	AddTip(self.root,3,"coin1.tex")
	AddTip(self.root,4,"cookbook_new.tex")
	AddTip(self.root,5,"cookbook_new.tex")

	--关闭按钮
    local close_button = self.root:AddChild(ImageButton("images/global_redux.xml", "close.tex"))
    close_button:SetOnClick(function() 
		--这样只能关面板不能关
		-- if self.GetParent then
		-- 	local parent_widget = self:GetParent()
		-- 	if parent_widget and parent_widget.Close then
		-- 		parent_widget:Close()
		-- 	end
		-- end
		--关闭容器
		if tributebox ~= nil then
			if tributebox.components.container ~= nil then
				tributebox.components.container:Close(ThePlayer)
			else
				SendModRPCToServer(MOD_RPC.functional_medal.CloseContainer, tributebox)
			end
		end
		
	end)
    close_button:SetNormalScale(1)
    close_button:SetFocusScale(1.2)
    close_button:SetImageNormalColour(UICOLOURS.GREY)
    close_button:SetImageFocusColour(UICOLOURS.WHITE)
    close_button:SetPosition(500, 310)
    close_button:SetHoverText(STRINGS.MEDAL_SETTING_UI.CLOSE)

	--初始化结果展示
	self:InitResults()
end)

local NumberMap = {"①","②","③","④","⑤","⑥","⑦","⑧"}

--构造单条结果展示卡
function MedalPayTributePage:ResultCard(indexnum)
	local widget = Widget()--生成选项卡，编号不同
	
	widget.index_num = widget:AddChild(Text(HEADERFONT, 56, NumberMap[indexnum or 1], PLANTREGISTRYUICOLOURS.LOCKEDBROWN))
	widget.index_num:SetPosition(-52, 0)
	widget.index_num:SetHAlign( ANCHOR_MIDDLE )
	
	local ingredient_size = 64
	local x_spacing = 10
	for i = 1, 4 do
		local backing = widget:AddChild(Image("images/quagmire_recipebook.xml", "ingredient_slot.tex"))
		backing:ScaleToSize(ingredient_size, ingredient_size)
		backing:SetPosition((i-1)*ingredient_size + (i-1)*x_spacing, 0)
		widget["guess"..i] = widget:AddChild(Image("images/quagmire_recipebook.xml", "cookbook_missing.tex"))
		widget["guess"..i]:ScaleToSize(ingredient_size, ingredient_size)
		widget["guess"..i]:SetPosition((i-1)*ingredient_size + (i-1)*x_spacing, 0)
	end
	
	local idx = 0
	for y = 1, 2 do
		for x = 1, 2 do
			idx = idx + 1
			widget["result"..idx] = widget:AddChild(Image("images/quagmire_recipebook.xml", "coin_unknown.tex"))
			widget["result"..idx]:ScaleToSize(32, 32)
			widget["result"..idx]:SetPosition(280 + (x-1)*33, 17 - (y-1)*33)
		end
	end

	return widget
end

--初始化结果展示
function MedalPayTributePage:InitResults()
	for x=0,1 do
		for y=1,4 do
			local idx = 4*x+y
			if idx <= 6 then
				self["result_card_"..idx] = self.root:AddChild(self:ResultCard(idx))
				self["result_card_"..idx]:SetPosition(-390 + 510*x, 170 - 90*y)--40*i)
				self:RefreshResultData(idx)--显示猜测结果
			end
		end
	end
end

--贴图纠正
local tex_correct_loot={
	tomato = "quagmire_tomato.tex",
	onion = "quagmire_onion.tex",
}

--根据蔬果ID获取蔬果贴图数据
local function GetVeggiesImg(veggie_id)
	if veggie_id~=nil then
		local veggie_name = GetPayTributeData(veggie_id)
		local veggie_tex = veggie_name and (tex_correct_loot[veggie_name] or veggie_name..".tex") or nil
		local veggie_atlas = veggie_tex and GetInventoryItemAtlas(veggie_tex, true) or nil
		return veggie_atlas,veggie_tex
	end
end

--显示可奉纳的蔬果
function MedalPayTributePage:SetVeggies()
	local veggies = self.tribute_data and self.tribute_data[1]--获取备选蔬果数据-- {1,3,5,7,9,11}
	local ingredient_size = 64
	local x_spacing = 10
	local x = -((6 + 1)*ingredient_size + (6-1)*x_spacing) / 2
	for i = 1, 6 do
		local backing = self.root:AddChild(Image("images/quagmire_recipebook.xml", "ingredient_slot.tex"))
		backing:ScaleToSize(ingredient_size, ingredient_size)
		backing:SetPosition(x + (i)*ingredient_size + (i-1)*x_spacing, 240)
		if veggies ~= nil then
			local veggie_atlas,veggie_tex = GetVeggiesImg(veggies[i])
			if veggie_atlas then
				local veggie_img = self.root:AddChild(Image(veggie_atlas, veggie_tex))
				veggie_img:ScaleToSize(ingredient_size, ingredient_size)
				veggie_img:SetPosition(x + (i)*ingredient_size + (i-1)*x_spacing, 240)
			end
		end
	end
end

--同步结果数据
function MedalPayTributePage:RefreshResultData(idx)
	-- if self.tribute_data and self.tribute_data[idx]
	local showdata = self.tribute_data and self.tribute_data[idx + 1]
	if showdata ~= nil and self["result_card_"..idx] ~= nil then
		self.guess_num = idx--当前结果条数
		--显示蔬果
		for i = 1, 4 do
			local veggie_atlas,veggie_tex = GetVeggiesImg(showdata[i])
			if veggie_atlas then
				self["result_card_"..idx]["guess"..i]:SetTexture(veggie_atlas, veggie_tex)
				self["result_card_"..idx]["guess"..i]:ScaleToSize(64, 64)
			end
		end
		local coin4_num = showdata[5]
		local coin1_num = showdata[6]
		--完全正确的图标
		for i = 1, coin4_num do
			self["result_card_"..idx]["result"..i]:SetTexture("images/quagmire_recipebook.xml", "coin4.tex")
		end
		--种类正确但位置不正确
		for i = 1, coin1_num do
			self["result_card_"..idx]["result"..(i+coin4_num)]:SetTexture("images/quagmire_recipebook.xml", "coin1.tex")
		end
	end
end

--同步最新一条数据
function MedalPayTributePage:RefreshNewData()
	self.inst:DoSimTaskInTime(.2,function()
		self:OnUpdateInfo()
		local datasize = self.tribute_data ~= nil and #self.tribute_data-1 or 0
		local shownum = self.guess_num or 0
		if datasize > shownum then
			for i = shownum+1, datasize do
				self:RefreshResultData(i)
			end
		end
	end)
end

--更新数据
function MedalPayTributePage:OnUpdateInfo()
	if self.tributebox then
		if self.tributebox.medal_tribute_str then
			local tribute_str = self.tributebox.medal_tribute_str:value()
			if tribute_str and tribute_str~="" then
				self.tribute_data = json.decode(tribute_str)--数据解包
			end
		end
	end
end

function MedalPayTributePage:OnControl(control, down)
	if self.plantregistrywidget then
		self.plantregistrywidget:OnControl(control, down)
		return true
	end
	return MedalPayTributePage._base.OnControl(self, control, down)
end

return MedalPayTributePage
