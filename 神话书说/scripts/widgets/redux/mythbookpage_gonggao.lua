local Widget = require "widgets/widget"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local Grid = require "widgets/grid"
local Spinner = require "widgets/spinner"

local TEMPLATES = require "widgets/redux/templates"

require("util")

local L = MK_MOD_LANGUAGE_SETTING
local IS_VI = L == "VI"

local FILTER_ALL = STRINGS.MYTH_BOOINFO.FILTER_ALL
local ITEM_TYPE = STRINGS.MYTH_BOOINFO.ITEM_TYPE
local cooking = require("cooking")

--线条哦
local function MakeDetailsLine(details_root, x, y, scale, image_override)
	local value_title_line = details_root:AddChild(Image("images/myth_bookinfo_bg.xml", image_override or "line_long.tex"))
	value_title_line:SetScale(scale, scale)
	value_title_line:SetPosition(x, y)
end

-------------------------------------------------------------------------------------------------------
local MythbookPagePill = Class(Widget, function(self, parent_screen, category)
    Widget._ctor(self, "MythbookPagePill")

    self.parent_screen = parent_screen
	self.category = category or "cookbook"

	self:CreateRecipeBook()

	--self:_DoFocusHookups()

	return self
end)

function MythbookPagePill:_DoFocusHookups()
	if not self.spinners then return end
	for i, v in ipairs(self.spinners) do
		v:ClearFocusDirs()

		if i > 1 then
			v:SetFocusChangeDir(MOVE_UP, self.spinners[i-1])
		end
		if i < #self.spinners then
			v:SetFocusChangeDir(MOVE_DOWN, self.spinners[i+1])
		end
	end
	
    local reset_default_focus = self.parent_default_focus ~= nil and self.parent_screen ~= nil and self.parent_screen.default_focus == self.parent_default_focus

	if self.recipe_grid.items ~= nil and #self.recipe_grid.items > 0 then
		self.spinners[#self.spinners]:SetFocusChangeDir(MOVE_DOWN, self.recipe_grid)
		self.recipe_grid:SetFocusChangeDir(MOVE_UP, self.spinners[#self.spinners])
	
		self.parent_default_focus = self.recipe_grid
	    self.focus_forward = self.recipe_grid
	else
		self.parent_default_focus = self.spinners[1]
	    self.focus_forward = self.spinners[1]
	end
end

local function RGB(r, g, b)
    return { r / 255, g / 255, b / 255, 1 }
end

function MythbookPagePill:CreateRecipeBook()

	--这是上半区
	local panel_root = self
	-----------
	self.gridroot = panel_root:AddChild(Widget("grid_root"))
    self.gridroot:SetPosition(-180, -35)

    self.recipe_grid = self.gridroot:AddChild( self:BuildRecipeBook() )
    self.recipe_grid:SetPosition(-45, 32)
	local grid_w, grid_h = self.recipe_grid:GetScrollRegionSize()

	--你在这里有
	local boarder_scale = 0.90
	local grid_boarder = self.gridroot:AddChild(Image("images/myth_bookinfo_bg.xml", "line_long.tex"))
	grid_boarder:SetScale(boarder_scale, boarder_scale)
    grid_boarder:SetPosition(-33, grid_h/2+33)
	grid_boarder = self.gridroot:AddChild(Image("images/myth_bookinfo_bg.xml", "line_long.tex"))
	grid_boarder:SetScale(boarder_scale, -boarder_scale)
    grid_boarder:SetPosition(-33, -grid_h/2+29)
    

	local title = self.gridroot:AddChild(Text(HEADERFONT, 50, "更新公告",RGB(0, 0, 0, 255)))
	title:SetPosition(-30, 220)

	title = self.gridroot:AddChild(Text(HEADERFONT, 30, "2月6日 更新说明：",RGB(0, 0, 0, 255)))
	title:SetPosition(-100, 160)
	title:SetHAlign(ANCHOR_LEFT)
	title:SetRegionSize(200, 100)

	title = self.gridroot:AddChild(Text(HEADERFONT, 24, [[
		1. 修复人参果树根燃烧崩溃的问题
		2. cdk兑换系统将于2月15日之后移除 
			    如果你有兑换码请尽早完成兑换
		3. 所有角色开局都会自带一本天书
	]],
	RGB(0, 0, 0, 255)))
	title:SetPosition(80, 110)
	title:SetHAlign(ANCHOR_LEFT)
	title:SetRegionSize(600, 400)

	title = self.gridroot:AddChild(Text(HEADERFONT, 30, "2月7日 更新说明：",RGB(0, 0, 0, 255)))
	title:SetPosition(-100, 40)
	title:SetHAlign(ANCHOR_LEFT)
	title:SetRegionSize(200, 100)


	title = self.gridroot:AddChild(Text(HEADERFONT, 24, [[
		1. 修复年兽坐骑跳世界崩溃的问题
		2. 修复战旗无法收回的问题
		3. 修复一柱擎天释放失败金箍棒消失的问题
		4. 优化八戒锄地逻辑
	]],
	RGB(0, 0, 0, 255)))
	title:SetPosition(80, -20)
	title:SetHAlign(ANCHOR_LEFT)
	title:SetRegionSize(600, 400)

	title = self.gridroot:AddChild(Text(HEADERFONT, 30, "2月15日 更新说明：",RGB(0, 0, 0, 255)))
	title:SetPosition(-100, -90)
	title:SetHAlign(ANCHOR_LEFT)
	title:SetRegionSize(200, 100)

	title = self.gridroot:AddChild(Text(HEADERFONT, 24, [[
		1. 移除cdk兑换
		2. 修复部分道具贴图不正确得问题
	]],
	RGB(0, 0, 0, 255)))
	title:SetPosition(80, -120)
	title:SetHAlign(ANCHOR_LEFT)
	title:SetRegionSize(600, 400)
	-----------
	--右边的内容
	local details_decor_root = panel_root:AddChild(Widget("details_root"))
	details_decor_root:SetPosition(grid_w/2 + 60, 10)

	local details_decor = details_decor_root:AddChild(Image("images/myth_bookinfo_bg.xml", "quagmire_recipe_menu_block.tex"))
    details_decor:ScaleToSize(360, 460)

	self.details_root = panel_root:AddChild(Widget("details_root"))
	self.details_root:SetPosition(details_decor_root:GetPosition())
	self.details_root.panel_width = 350
	self.details_root.panel_height = 500


	title = self.details_root:AddChild(Text(HEADERFONT, 40, "游戏小贴士",RGB(0, 0, 0, 255)))
	title:SetPosition(0, 200)

	title = self.details_root:AddChild(Text(HEADERFONT, 24, [[
		1.  部分角色的专属技能 需要到方寸山进行解锁

		2.  游戏里面的技能ui的操作方式是：
			   左键释放 右键拖曳  
			   alt+右键可以切换技能显示模式
	]],
	RGB(0, 0, 0, 255)))
	title:SetPosition(140, 120)
	title:SetHAlign(ANCHOR_LEFT)
	title:SetRegionSize(600, 400)

	title = self.details_root:AddChild(Text(HEADERFONT, 28, "如果您有bug反馈或者别的建议\n请加我们的反馈群：825709981",RGB(0, 0, 0, 255)))
	title:SetPosition(0, -200)
end

local ingredient_icon_remap = {}
ingredient_icon_remap.onion = "quagmire_onion"
ingredient_icon_remap.tomato = "quagmire_tomato"
ingredient_icon_remap.acorn = "acorn_cooked"

local ingredient_name_remap = {}
ingredient_name_remap.acorn = "acorn_cooked"

local teshu = {

}
function MythbookPagePill:_SetupRecipeIngredientDetails(recipes, parent, y)
	local ingredient_size = 40
	local x_spacing = 10

	local inv_backing_root = parent:AddChild(Widget("inv_backing_root"))
	local inv_item_root = parent:AddChild(Widget("inv_item_root"))
	local index = 1
	if #recipes <= 3 then
		for b = 1, #recipes do
			local items = recipes[index]
			local x = -((#items + 1)*ingredient_size + (#items-1)*x_spacing) / 2 
			for i = 1, #items do
				--这是配方！！
				local backing = inv_backing_root:AddChild(Image("images/quagmire_recipebook.xml", "ingredient_slot.tex"))
				backing:ScaleToSize(ingredient_size, ingredient_size)
				backing:SetPosition(x + (i)*ingredient_size + (i-1)*x_spacing, y - ingredient_size/2 - (b-1)*(ingredient_size+5))

				local img_name = teshu[items[i][1]] ~= nil and teshu[items[i][1]]..".tex"  or (ingredient_icon_remap[items[i][1]] or items[i][1])..".tex"
				local img_atlas = GetInventoryItemAtlas(img_name, true)
				local img = inv_item_root:AddChild(Image(img_atlas or "images/inventoryimages/"..items[i][1]..".xml", img_atlas ~= nil and img_name or items[i][1]..".tex"))
				if items[i][2] ~= 1 then 
					local num = img:AddChild(Text(NUMBERFONT, 35, tostring(items[i][2])))
					num:SetPosition(20, -20)
				end
				img:ScaleToSize(ingredient_size, ingredient_size)
				img:SetPosition(backing:GetPosition())
				img:SetHoverText(STRINGS.NAMES[string.upper(ingredient_name_remap[items[i][1]] or items[i][1])] or subfmt(STRINGS.UI.COOKBOOK.UNKNOWN_INGREDIENT_NAME, {ingredient = items[i][1]}))
			end
			index = index + 1
		end
	else
		local width = ((4)*ingredient_size + (4-1)*x_spacing)
		local column_spacing_offset = 5
		for b = 1, #recipes do
			local items = recipes[index]
			local x = (b%2 == 1) and (-width - ingredient_size + column_spacing_offset) or -column_spacing_offset
			for i = 1, #items do
				local backing = inv_backing_root:AddChild(Image("images/quagmire_recipebook.xml", "ingredient_slot.tex"))
				backing:ScaleToSize(ingredient_size, ingredient_size)
				backing:SetPosition(x + (i)*ingredient_size + (i-1)*x_spacing, y - ingredient_size/2 - math.floor((b-1)/2)*(ingredient_size+5))

				local img_name = (ingredient_icon_remap[items[i][1]] or items[i][1])..".tex"
				local img_atlas = GetInventoryItemAtlas(img_name, true)
				local img = inv_item_root:AddChild(Image(img_atlas or "images/inventoryimages/"..items[i][1]..".xml", img_atlas ~= nil and img_name or items[i][1]..".tex"))
				if items[i][2] ~= 1 then 
					local num = img:AddChild(Text(NUMBERFONT, 35, tostring(items[i][2])))
					num:SetPosition(20, -20)
				end
				img:ScaleToSize(ingredient_size, ingredient_size)
				img:SetPosition(backing:GetPosition())
				img:SetHoverText(STRINGS.NAMES[string.upper(items[i][1])] or subfmt(STRINGS.UI.COOKBOOK.UNKNOWN_INGREDIENT_NAME, {ingredient = items[i][1]}))
			end
			index = index + 1
		end
	end
end

function MythbookPagePill:_GetSpoilString(perishtime)
	return perishtime == nil and STRINGS.MYTH_BOOINFO.YONGJIU or perishtime
end

function MythbookPagePill:_GetCookingTimeString(cooktime)
	return cooktime == nil and STRINGS.MYTH_BOOINFO.LONGER  or cooktime.."s"
end

--效果
function MythbookPagePill:_GetSideEffectString(recipe_def)
	return  recipe_def.oneat_desc or STRINGS.UI.COOKBOOK.FOOD_EFFECTS_NONE
end


local function BuildSkinSpinners(self,skins,icon_size)
	local root = Widget("spinner_root")
	
	local top = 50
	local left = 0 -- -width/2 + 5

	local sort_options = {
	}

	for i, v in ipairs(skins) do
		table.insert(sort_options,{text = v[1],data = v[2]})
	end
	local function on_sort_fn(data)
		self:SetTexture(data[1], data[2])
		self:ScaleToSize(icon_size, icon_size)
	end

	local width_label = 120
	local width_spinner = 120
	local height = 25

	local function MakeSpinner(labeltext, spinnerdata, onchanged_fn, initial_data)
		local spacing = 5
		local font = HEADERFONT
		local font_size = 22

		local total_width = width_label + width_spinner + spacing
		local wdg = Widget("labelspinner")
		wdg.label = wdg:AddChild( Text(font, font_size, labeltext) )
		wdg.label:SetPosition( (-total_width/2)+(width_label/2), 12 )
		wdg.label:SetRegionSize( width_label, height )
		wdg.label:SetHAlign( ANCHOR_RIGHT )
		wdg.label:SetColour(UICOLOURS.BROWN_DARK)

		local lean = true
		wdg.spinner = wdg:AddChild(Spinner(spinnerdata, width_spinner, height, {font = font, size = font_size}, nil, "images/myth_bookinfo_bg.xml", nil, lean))
		wdg.spinner:SetTextColour(UICOLOURS.BROWN_DARK)
		wdg.spinner:SetOnChangedFn(onchanged_fn)
		wdg.spinner:SetPosition((total_width/2)-(width_spinner/2), 12)
		wdg.spinner:SetSelected(initial_data)

		return wdg
	end
	local items = {}
	--排序
	table.insert(items, MakeSpinner("", sort_options, on_sort_fn, sort_options[1]))
	
	self.spinners = {}
	for i, v in ipairs(items) do
		local w = root:AddChild(v)
		w:SetPosition(0, (#items - i + 1)*(height + 3))
		table.insert(self.spinners, w.spinner)
	end
	
	return root
end

function MythbookPagePill:PopulateRecipeDetailPanel(data)
	local top = self.details_root.panel_height/2
	local left = -self.details_root.panel_width / 2

	if data.recipe_def.custom_cookbook_details_fn ~= nil then
		-- Modders can define this on a preparedfoods definition table if they use this if they want to have their own custom display.
		return data.recipe_def.custom_cookbook_details_fn(data, self, top, left)
	end

	local details_root = Widget("details_root")

	local y = top - 11

	local image_size = 90

	local name_font_size = IS_VI and 30 or 34
	local title_font_size = IS_VI and 18 or 22 --22
	local body_font_size = IS_VI and 16 or 20 --18
	local value_title_font_size = IS_VI and 18 or 22
	local value_body_font_size = IS_VI and 16 or 20

	y = y - name_font_size/2 -30
	local title = details_root:AddChild(Text(HEADERFONT, name_font_size, data.unlocked and data.name or STRINGS.UI.RECIPE_BOOK.UNKNOWN_RECIPE, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y)
	y = y - name_font_size/2 - 4
	MakeDetailsLine(details_root, 0, y-10, -.75, "quagmire_recipe_line_break.tex")
	y = y - 30

	if not data.unlocked then
		local msg = details_root:AddChild(Text(HEADERFONT, body_font_size, "", UICOLOURS.BROWN_DARK))
		msg:SetMultilineTruncatedString(STRINGS.UI.COOKBOOK.LOCKED_RECIPE[self.category] or STRINGS.UI.COOKBOOK.LOCKED_RECIPE.COOKPOT, 20, 300)
		local _, msg_h = msg:GetRegionSize()
		y = y - msg_h/2
		msg:SetPosition(0, y)
		y = y - body_font_size/2 - 4

	else
		--三位哦
		local icon_size = image_size - 20

		local frame = details_root:AddChild(Image("images/myth_bookinfo_bg.xml", "cookbook_known.tex"))
		frame:ScaleToSize(image_size, image_size)
		y = y - image_size/2
		--frame:SetPosition(left + image_size/2 + 30, y)
		frame:SetPosition(data.recipe_def.sanwei ~= nil and left + image_size/2 + 30 or 0 , y)
		y = y - image_size/2

		local portrait_root = details_root:AddChild(Widget("portrait_root"))
		portrait_root:SetPosition(frame:GetPosition())

		local food_img = portrait_root:AddChild(Image(data.food_atlas, not data.unlocked and "cookbook_unknown.tex" or data.food_tex))
		food_img:ScaleToSize(icon_size, icon_size)

		if data.recipe_def.skins ~= nil then
			local spinner_skin = portrait_root:AddChild(BuildSkinSpinners(food_img,data.recipe_def.skins,icon_size))
			spinner_skin:SetPosition(-54, -94)
			spinner_skin:SetScale(0.9)
			y = y - 10
		end
		
		local details_x = 60

			local details_y = y + 85
			local status_scale = 0.7
			if	data.recipe_def.sanwei ~= nil then
			local health = data.recipe_def.sanwei[1] ~= nil and math.floor(10*data.recipe_def.sanwei[1])/10 or nil
			self.health_status = details_root:AddChild(TEMPLATES.MakeUIStatusBadge((health ~= nil and health >= 0) and "health" or "health"))
			self.health_status:SetPosition(details_x-60, details_y-20)
			self.health_status.status_value:SetString(health or "N/A")
			self.health_status:SetScale(status_scale)

			local hunger = data.recipe_def.sanwei[2] ~= nil and math.floor(10*data.recipe_def.sanwei[2])/10 or nil
			self.hunger_status = details_root:AddChild(TEMPLATES.MakeUIStatusBadge((hunger ~= nil and hunger >= 0) and "hunger" or "hunger"))
			self.hunger_status:SetPosition(details_x, details_y-20)
			self.hunger_status.status_value:SetString(hunger or "N/A")
			self.hunger_status:SetScale(status_scale)

			local sanity = data.recipe_def.sanwei[3] ~= nil and math.floor(10*data.recipe_def.sanwei[3])/10 or nil
			self.sanity_status = details_root:AddChild(TEMPLATES.MakeUIStatusBadge((sanity ~= nil and sanity >= 0) and "sanity" or "sanity"))
			self.sanity_status:SetPosition(details_x+60, details_y-20)
			self.sanity_status.status_value:SetString(sanity or "N/A")
			self.sanity_status:SetScale(status_scale)
			end
			details_y = details_y - 42

			--副作用啊
			local effects_str = self:_GetSideEffectString(data.recipe_def)
			if effects_str then
				details_y = details_y - value_title_font_size/2
				title = details_root:AddChild(Text(HEADERFONT, value_title_font_size, STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.xiaoguo, UICOLOURS.BROWN_DARK))
				title:SetPosition(details_x-60, details_y- 110)
				details_y = details_y - value_title_font_size/2
				MakeDetailsLine(details_root, details_x-60, details_y - 2- 110, .49)
				details_y = details_y - 8
				details_y = details_y - value_body_font_size/2
				local effects = details_root:AddChild(Text(HEADERFONT, value_body_font_size, "", UICOLOURS.BROWN_DARK))
				effects:SetMultilineTruncatedString(effects_str, 20, 180)
				local _, msg_h = effects:GetRegionSize()
				y = y - msg_h/2 + 8
				effects:SetPosition(details_x-60, details_y- 102 - msg_h/2)
				details_y = details_y - value_body_font_size/2 - 4
			end
		y = y - 12

		local row_start_y = y
		local column_offset_x = 80

		--食物类型
		local a,b  = 0,0
		y = y - title_font_size/2
		title = details_root:AddChild(Text(HEADERFONT, title_font_size, STRINGS.UI.COOKBOOK.FOOD_TYPE_TITLE, UICOLOURS.BROWN_DARK))
		title:SetPosition(-column_offset_x - 35 , y)
		a = -column_offset_x - 35
		b = y
		y = y - title_font_size/2
		MakeDetailsLine(details_root, -column_offset_x - 35, y - 2, .75, "line_veryshort.tex")
		y = y - 8
		y = y - body_font_size/2
		local str = data.recipe_def.foodtype  or "未知"
		local tags = details_root:AddChild(Text(HEADERFONT, body_font_size, str, UICOLOURS.BROWN_DARK))
		tags:SetPosition(-column_offset_x - 35, y)
		y = y - body_font_size/2 - 4

		y = row_start_y

		--腐烂时间
		y = y - title_font_size/2
		title = details_root:AddChild(Text(HEADERFONT, title_font_size, data.recipe_def.xiaoguo or STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.yaoxiao, UICOLOURS.BROWN_DARK))
		title:SetPosition(-a, b)
		y = y - title_font_size/2
		MakeDetailsLine(details_root, -a, b- title_font_size/2 - 2, .75, "line_veryshort.tex")
		y = y - 8
		y = y - body_font_size/2
		local str = self:_GetSpoilString(data.recipe_def.perishtime)
		local tags = details_root:AddChild(Text(HEADERFONT, body_font_size, str, UICOLOURS.BROWN_DARK))
		tags:SetPosition(-a, b- 8-body_font_size/2- body_font_size/2 )
		y = y - body_font_size/2 - 4

		y = y - (IS_VI and 26 or 10)

		--配方
		if data.recipes ~= nil and #data.recipes > 0 then
			-- 时间
			y = y - title_font_size/2
			title = details_root:AddChild(Text(HEADERFONT, title_font_size, STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.lztime, UICOLOURS.BROWN_DARK))
			title:SetPosition(0, b)
			y = y - title_font_size/2
			MakeDetailsLine(details_root, 0, b - title_font_size/2- 2, .75, "line_veryshort.tex")
			y = y - 8
			y = y - body_font_size/2 - 4
			local str = self:_GetCookingTimeString(data.recipes ~= nil and data.recipe_def.cooktime or nil)
			local tags = details_root:AddChild(Text(HEADERFONT, body_font_size, str, UICOLOURS.BROWN_DARK))
			tags:SetPosition(0, b- 8-body_font_size/2- body_font_size/2 )
			y = y - body_font_size/2 - 4

			--y = y - 10

			--配方
			y = y - title_font_size/2
			title = details_root:AddChild(Text(HEADERFONT, title_font_size, STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.peifang, UICOLOURS.BROWN_DARK))
			title:SetPosition(0, y+12)
			y = y - title_font_size/2
			MakeDetailsLine(details_root, 0, y - 2+12, .49)
			y = y - 10

			self:_SetupRecipeIngredientDetails(data.recipes, details_root, y+12)
		else
			y = y - title_font_size/2 - 50
			title = details_root:AddChild(Text(HEADERFONT, title_font_size, STRINGS.UI.COOKBOOK.NO_RECIPES_TITLE, UICOLOURS.BROWN_DARK))
			title:SetPosition(0, y)
			y = y - title_font_size/2
			MakeDetailsLine(details_root, 0, y - 2, .49)
			y = y - 10

			y = y - body_font_size/2

			local body = details_root:AddChild(Text(HEADERFONT, body_font_size, "", UICOLOURS.BROWN_DARK))
			body:SetMultilineTruncatedString(data.recipe_def.recipes_text or STRINGS.UI.COOKBOOK.NO_RECIPES_DESC, 20, 300)
			local _, msg_h = body:GetRegionSize()
			y = y - msg_h/2 + 8
			body:SetPosition(0, y)
		end
	end
	return details_root
end

function MythbookPagePill:BuildRecipeBook()
    local base_size = 128
    local cell_size = 73--73
    local row_w = 55
    local row_h = 55
    local reward_width = 80
    local row_spacing = 28
    
	local food_size = cell_size + 20
	local icon_size = 20 / (cell_size/base_size)

	--创建这个事物的图相关
    local function ScrollWidgetsCtor(context, index)
        local w = Widget("recipe-cell-".. index)
                
		----------------
		w.cell_root = w:AddChild(ImageButton("images/myth_bookinfo_bg.xml", "unknown.tex", "unknown_selected.tex"))
		w.cell_root:SetFocusScale(cell_size/base_size + .05, cell_size/base_size + .05)
		w.cell_root:SetNormalScale(cell_size/base_size, cell_size/base_size)

		w.focus_forward = w.cell_root

        w.cell_root.ongainfocusfn = function() self.recipe_grid:OnWidgetFocus(w) end

		----------------
		w.recipie_root = w.cell_root.image:AddChild(Widget("recipe_root"))

        w.food_img = w.recipie_root:AddChild(Image("images/global.xml", "square.tex"))

		w.cell_root:SetOnClick(function() --点击之后右边会创建这个东西的属性哦
			self.details_root:KillAllChildren()
			self.details_root:AddChild(self:PopulateRecipeDetailPanel(w.data))

			if MYTH_BOOKINFO_PAGES.selected == nil then
				MYTH_BOOKINFO_PAGES.selected = {}
			end
			MYTH_BOOKINFO_PAGES.selected[self.category] = w.data.index
		end)

		----------------
		return w

    end

    local function ScrollWidgetSetData(context, widget, data, index)
		widget.data = data
		if data ~= nil then
			widget.cell_root:Show()

			--如果不是解锁的
			if data.unlocked then
				--显示这个配方
				widget.recipie_root:Show()
				widget.cell_root:SetTextures("images/myth_bookinfo_bg.xml", "cookbook_known.tex", "cookbook_known_selected.tex")

				widget.food_img:SetTexture(data.food_atlas, not data.unlocked and "cookbook_unknown.tex" or data.food_tex)
				widget.food_img:ScaleToSize(food_size, food_size)
			else
				widget.recipie_root:Hide()
				widget.cell_root:SetTextures("images/myth_bookinfo_bg.xml", "cookbook_unknown.tex", "cookbook_unknown_selected.tex")
			end
			widget:Enable()
		else
			widget:Disable()
			widget.cell_root:Hide()
		end
	end
	--这里开始是关键了 就很有意思
	self.all_recipes = {}
	
	--过滤的配方
	self.filtered_recipes = {}
	--已经发现的菜谱
	self.num_recipes_discovered = 0
	--吃过的菜谱
	self.num_foods_eaten = 0

	--已知的十五是这个里面的
	local known_recipe_list = MYTH_PillRefining

	local cookbook_recipes = MYTH_PillRefining
	for prefab, recipe_def in pairs(cookbook_recipes) do
		local data = {
			prefab = prefab, 
			name = STRINGS.NAMES[string.upper(prefab)] or subfmt(STRINGS.UI.COOKBOOK.UNKNOWN_FOOD_NAME, {food = prefab or "SDF"}),
			recipe_def = recipe_def,
			defaultsortkey = hash(prefab),
			food_atlas = "images/myth_bookinfo_bg.xml",
			food_tex = "cookbook_unknown.tex",
		}

		local known_data = true--known_recipe_list[prefab]
		if known_data ~= nil then
			data.unlocked = true
			data.has_eaten = true --known_data.has_eaten
			data.recipes =  recipe_def.recipes --(known_data.recipes ~= nil and next(known_data.recipes) ~= nil) and known_data.recipes or nil

			local img_name = recipe_def.cookbook_tex or (prefab..".tex")
			local atlas = recipe_def.cookbook_atlas or GetInventoryItemAtlas(img_name, true)
			if atlas ~= nil then
				data.food_atlas = atlas
				data.food_tex = img_name
			else
				data.food_tex = "cookbook_missing.tex"
			end

			if data.has_eaten then
				self.num_foods_eaten = self.num_foods_eaten + 1
			end
			if data.recipes ~= nil then
				self.num_recipes_discovered = self.num_recipes_discovered + 1
			end
		end

		table.insert(self.all_recipes, data)
	end

	table.sort(self.all_recipes, function(a, b) return self:_sortfn_default(a, b) end)
	for i, data in ipairs(self.all_recipes) do
		data.index = i
	end

    local grid = TEMPLATES.ScrollingGrid(
        {},
        {
            context = {},
            widget_width  = row_w+row_spacing,
            widget_height = row_h+row_spacing,
			force_peek    = true,
            num_visible_rows = 4.8, --竖排
            num_columns      = 4, --横排
            item_ctor_fn = ScrollWidgetsCtor,
            apply_fn     = ScrollWidgetSetData,
            scrollbar_offset = 20,
            scrollbar_height_offset = -60
        })
	
	grid.up_button:SetTextures("images/quagmire_recipebook.xml", "quagmire_recipe_scroll_arrow_hover.tex")
    grid.up_button:SetScale(0.5)

	grid.down_button:SetTextures("images/quagmire_recipebook.xml", "quagmire_recipe_scroll_arrow_hover.tex")
    grid.down_button:SetScale(-0.5)

	grid.scroll_bar_line:SetTexture("images/quagmire_recipebook.xml", "quagmire_recipe_scroll_bar.tex")
	grid.scroll_bar_line:SetScale(.8)

	grid.position_marker:SetTextures("images/quagmire_recipebook.xml", "quagmire_recipe_scroll_handle.tex")
	grid.position_marker.image:SetTexture("images/quagmire_recipebook.xml", "quagmire_recipe_scroll_handle.tex")
    grid.position_marker:SetScale(.6)

    return grid
end

function MythbookPagePill:_sortfn_default(a, b)
	return a.recipe_def.priority > b.recipe_def.priority or (a.recipe_def.priority == b.recipe_def.priority and a.defaultsortkey > b.defaultsortkey)
end

function MythbookPagePill:_sortfn_sideeffects(a, b)
	local a_score = not a.unlocked and 0
				or not a.has_eaten and 1
				or (a.recipe_def.oneat_desc == nil and a.recipe_def.temperature == nil) and 2
				or 3

	local b_score = not b.unlocked and 0
				or not b.has_eaten and 1
				or (b.recipe_def.oneat_desc == nil and b.recipe_def.temperature == nil) and 2
				or 3

	if a_score == 3 and b_score == 3 then
		local a_effect = self:_GetSideEffectString(a.recipe_def)
		local b_effect = self:_GetSideEffectString(b.recipe_def)

		return a_effect < b_effect or (a_effect == b_effect and a.name < b.name)
	end

	return a_score > b_score or (a_score == b_score and a.name < b.name)
end

function MythbookPagePill:ApplySort()
	local sortby = MYTH_BOOKINFO_PAGES:GetFilter("sort")
	table.sort(self.filtered_recipes, 
			sortby == "alphabetical"	and function(a, b) return a.unlocked and not b.unlocked or (a.unlocked and b.unlocked and a.name < b.name) end
		or									function(a, b) return self:_sortfn_default(a, b) end
	)

    self.recipe_grid:SetItemsData(self.filtered_recipes)
	self:_DoFocusHookups()
end

--过滤排序
function MythbookPagePill:ApplyFilters()
	local filterby = MYTH_BOOKINFO_PAGES:GetFilter("filter")

	self.filtered_recipes = {}

	for i, item in ipairs(self.all_recipes) do
		local foodtype = item.recipe_def.foodtype or FOODTYPE.GENERIC
		if (filterby == FILTER_ALL)
			or (filterby == ITEM_TYPE.xiandan	and foodtype == ITEM_TYPE.xiandan)
			or (filterby == ITEM_TYPE.zhuangbei	and foodtype == ITEM_TYPE.zhuangbei)
			or (filterby == ITEM_TYPE.cailiao	and foodtype == ITEM_TYPE.cailiao)
			or (filterby == ITEM_TYPE.fabao	and foodtype == ITEM_TYPE.fabao)
			then

			table.insert(self.filtered_recipes, item)
		end
	end

	self:ApplySort()
end

--这部分都是 排序相关的和过滤相关的
function MythbookPagePill:BuildSpinners()
	local root = Widget("spinner_root")
	
	local top = 50
	local left = 0 -- -width/2 + 5

	local sort_options = {
		{text = STRINGS.UI.COOKBOOK.SORT_DEFAULT,		data = "default"},
		{text = STRINGS.UI.COOKBOOK.SORT_SIDE_EFFECTS,	data = "sideeffects"},
	}
	local function on_sort_fn( data )
		MYTH_BOOKINFO_PAGES:SetFilter("sort", data)
		self:ApplySort()
	end

	local filter_options = { --过滤器的全部
		{text = FILTER_ALL,			data = FILTER_ALL},
		{text = ITEM_TYPE.xiandan,	data = ITEM_TYPE.xiandan},
		{text = ITEM_TYPE.zhuangbei, data = ITEM_TYPE.zhuangbei}, 
		{text = ITEM_TYPE.cailiao,	data = ITEM_TYPE.cailiao},
		{text = ITEM_TYPE.fabao,	data = ITEM_TYPE.fabao}, 
	}
	local function on_filter_fn( data )
		MYTH_BOOKINFO_PAGES:SetFilter("filter", data)
		self:ApplyFilters()
	end

	local width_label = 150
	local width_spinner = 150
	local height = 30

	local function MakeSpinner(labeltext, spinnerdata, onchanged_fn, initial_data)
		local spacing = 5
		local font = HEADERFONT
		local font_size = 25

		local total_width = width_label + width_spinner + spacing
		local wdg = Widget("labelspinner")
		wdg.label = wdg:AddChild( Text(font, font_size, labeltext) )
		wdg.label:SetPosition( (-total_width/2)+(width_label/2), 12 )
		wdg.label:SetRegionSize( width_label, height )
		wdg.label:SetHAlign( ANCHOR_RIGHT )
		wdg.label:SetColour(UICOLOURS.BROWN_DARK)

		local lean = true
		wdg.spinner = wdg:AddChild(Spinner(spinnerdata, width_spinner, height, {font = font, size = font_size}, nil, "images/myth_bookinfo_bg.xml", nil, lean))
		wdg.spinner:SetTextColour(UICOLOURS.BROWN_DARK)
		wdg.spinner:SetOnChangedFn(onchanged_fn)
		wdg.spinner:SetPosition((total_width/2)-(width_spinner/2), 12)
		wdg.spinner:SetSelected(initial_data)

		return wdg
	end

	--初始化排序一次
	MYTH_BOOKINFO_PAGES:SetFilter("sort", MYTH_BOOKINFO_PAGES:GetFilter("sort") or "default")
	MYTH_BOOKINFO_PAGES:SetFilter("filter", MYTH_BOOKINFO_PAGES:GetFilter("filter") or FILTER_ALL)

	local items = {}
	--排序
	--table.insert(items, MakeSpinner(STRINGS.UI.COOKBOOK.SORT_SPINNERLABEL, sort_options, on_sort_fn, MYTH_BOOKINFO_PAGES:GetFilter("sort")))
	
	--删选条件
	table.insert(items, MakeSpinner(STRINGS.UI.COOKBOOK.FILTER_SPINNERLABEL, filter_options, on_filter_fn, MYTH_BOOKINFO_PAGES:GetFilter("filter")))
    
	self.spinners = {}
	for i, v in ipairs(items) do
		local w = root:AddChild(v)
		w:SetPosition(50, (#items - i + 1)*(height + 3))
		table.insert(self.spinners, w.spinner)
	end
	
	return root
end

return MythbookPagePill
