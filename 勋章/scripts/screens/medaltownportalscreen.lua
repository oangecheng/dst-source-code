local Screen = require "widgets/screen"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"
local PopupDialogScreen = require "screens/redux/popupdialog"

local TEMPLATES = require "widgets/redux/templates"
local ScrollableList = require "widgets/scrollablelist"

local MedalTownportalScreen =
    Class(
    Screen,
    function(self, owner, attach)
        Screen._ctor(self, "MedalTownportalScreens")

        self.owner = owner
        self.attach = attach

        self.isopen = false

        self._scrnw, self._scrnh = TheSim:GetScreenSize()--屏幕宽高

        self:SetScaleMode(SCALEMODE_PROPORTIONAL)--等比缩放模式
        self:SetMaxPropUpscale(MAX_HUD_SCALE)--设置界面最大比例上限
        self:SetPosition(0, 0, 0)--设置坐标
        self:SetVAnchor(ANCHOR_MIDDLE)
        self:SetHAnchor(ANCHOR_MIDDLE)

        self.scalingroot = self:AddChild(Widget("medaldeliveryscalingroot"))
        self.scalingroot:SetScale(TheFrontEnd:GetHUDScale())
		--监听从暂停状态恢复到继续状态，更新尺寸
        self.inst:ListenForEvent(
            "continuefrompause",
            function()
                if self.isopen then
                    self.scalingroot:SetScale(TheFrontEnd:GetHUDScale())
                end
            end,
            TheWorld
        )
		--监听界面尺寸变化，更新尺寸
        self.inst:ListenForEvent(
            "refreshhudsize",
            function(hud, scale)
                if self.isopen then
                    self.scalingroot:SetScale(scale)
                end
            end,
            owner.HUD.inst
        )

        self.root = self.scalingroot:AddChild(TEMPLATES.ScreenRoot("root"))

        -- secretly this thing is a modal Screen, it just LOOKS like a widget
        --全屏全透明背景板，点了直接关闭界面
		self.black = self.root:AddChild(Image("images/global.xml", "square.tex"))
        self.black:SetVRegPoint(ANCHOR_MIDDLE)
        self.black:SetHRegPoint(ANCHOR_MIDDLE)
        self.black:SetVAnchor(ANCHOR_MIDDLE)
        self.black:SetHAnchor(ANCHOR_MIDDLE)
        self.black:SetScaleMode(SCALEMODE_FILLSCREEN)
        self.black:SetTint(0, 0, 0, 0)
        self.black.OnMouseButton = function()
            self:OnCancel()
        end
		--总界面
        self.destspanel = self.root:AddChild(TEMPLATES.RectangleWindow(350, 550))
        self.destspanel:SetPosition(0, 25)
		--当前站点的文字（界面最上方文字）
        self.current = self.destspanel:AddChild(Text(BODYTEXTFONT, 35))
        self.current:SetPosition(0, 250, 0)--坐标
        self.current:SetRegionSize(350, 50)--设置区域大小
        self.current:SetHAlign(ANCHOR_MIDDLE)
		self.current:SetString(STRINGS.DELIVERYSPEECH.NOTARGET)--默认文字内容(暂无目标)
        self.current:SetColour(1, 0, 0, 0.6)--默认颜色
		--界面下方关闭按钮
        self.cancelbutton =
            self.destspanel:AddChild(
            TEMPLATES.StandardButton(
                --点击按钮执行的函数
				function()
                    self:OnCancel()
                end,
                STRINGS.DELIVERYSPEECH.CLOSEBUTTON,--按钮文字
                {120, 40}--按钮尺寸
            )
        )
        self.cancelbutton:SetPosition(0, -250)


        self:LoadDests()--加载目的地列表
        self:Show()--显示
        self.isopen = true--开启
    end
)
--加载目的地列表
function MedalTownportalScreen:LoadDests()
	local info_str = self.attach and self.attach.deliverylist and self.attach.deliverylist:value()--获取信息字符串
	local info_data = info_str and info_str~="" and json.decode(info_str)--目的地列表解包
	self.dest_infos = {}--总信息表
	--设置界面标题
	if info_data and info_data.title then
		--设置界面标题
		if info_data.title then
			self.current:SetString(info_data.title ~= "" and info_data.title or STRINGS.DELIVERYSPEECH.NONAME)
			self.current:SetColour(1, 1, 1, 1)
		end
		--设置传送塔信息
		if info_data.towninfo then
			for i, v in ipairs(info_data.towninfo) do
				--如果信息的序号和key能对上，则继续，否则关闭面板
				if v.index and v.index == i then
					--信息表
					local info = {
						index=v.index,--索引(序号)
						title=v.title or STRINGS.DELIVERYSPEECH.NONAME,--标题
						consume=v.consume,--消耗
                        ischest=v.ischest,--是否是宝箱
						ispos=v.ispos,--是否是坐标点
                        isplayer=v.isplayer,--是否是玩家
                        islingshi=v.islingshi,--是否是临时传送点(一次性)
					}
					if v.otherworld then
						info.consume=info.consume..STRINGS.DELIVERYSPEECH.OTHERWORLD
					end
					table.insert(self.dest_infos, info)--插入总信息表
				else
					print("数据错误:\n", info_str)
					self.isopen = true
					self:OnCancel()
					return
				end
			end
		end
	end

    self:RefreshDests()--更新目的地列表
end
--更新目的地列表
function MedalTownportalScreen:RefreshDests()
    self.destwidgets = {}--目的地选项卡总表
	--遍历总信息表，将信息一一插入选项卡总表
    for i, v in ipairs(self.dest_infos) do
        local data = {
            index = i,
            info = v
        }

        table.insert(self.destwidgets, data)
    end
	--滚动选项卡构造函数
    local function ScrollWidgetsCtor(context, index)
        local widget = Widget("widget-" .. index)--生成选项卡，编号不同

        widget:SetOnGainFocus(
            function()
                self.dests_scroll_list:OnWidgetFocus(widget)
            end
        )
		--添加选项卡内容
        widget.destitem = widget:AddChild(self:DestListItem())
        local dest = widget.destitem

        widget.focus_forward = dest

        return widget
    end
	--应用数据函数
    local function ApplyDataToWidget(context, widget, data, index)
        widget.data = data
        widget.destitem:Hide()
        if not data then
            widget.focus_forward = nil
            return
        end

        widget.focus_forward = widget.destitem
        widget.destitem:Show()

        local dest = widget.destitem

        dest:SetInfo(data.info)--设置选项卡文字信息
    end
	--如果没有滚动选项卡列表，则创建
    if not self.dests_scroll_list then
        self.dests_scroll_list =
            self.destspanel:AddChild(
            TEMPLATES.ScrollingGrid(
                self.destwidgets,
                {
                    context = {},
                    widget_width = 175,--选项卡宽度
                    widget_height = 90,--高度
                    num_visible_rows = 5,--可见行数
                    num_columns = 2,--列数
                    item_ctor_fn = ScrollWidgetsCtor,--构造滚动选项卡
                    apply_fn = ApplyDataToWidget,--应用数据
                    scrollbar_offset = 10,--滚动条横向偏移值
                    scrollbar_height_offset = -60,--滚动条纵向偏移值
                    peek_percent = 0, --在底部可以看到多少行，相当于拉到底了还能往上拉多少
                    allow_bottom_empty_row = true --是否允许底部有空行
                }
            )
        )

        self.dests_scroll_list:SetPosition(0, 0)
        self.destspanel.focus_forward = self.dests_scroll_list--设置焦点

        self.dests_scroll_list:SetFocusChangeDir(MOVE_DOWN, self.cancelbutton)
        self.cancelbutton:SetFocusChangeDir(MOVE_UP, self.dests_scroll_list)
    end
end
--定义目的地选项卡
function MedalTownportalScreen:DestListItem()
    local dest = Widget("destination")--定义选项卡

    local item_width, item_height = 170, 90--宽、高
    --设置选项卡背景
	dest.backing =
        dest:AddChild(
        TEMPLATES.ListItemBackground(
            item_width,
            item_height,
            function()
            end
        )
    )
    dest.backing.move_on_click = true--可点击
	--选项卡标题
    dest.title = dest:AddChild(Text(BODYTEXTFONT, 28))
    dest.title:SetVAlign(ANCHOR_MIDDLE)
    dest.title:SetHAlign(ANCHOR_LEFT)
    dest.title:SetPosition(0, 20, 0)
    dest.title:SetRegionSize(130, 40)
	
	--耐久消耗
    dest.consume = dest:AddChild(Text(UIFONT, 24))
    dest.consume:SetVAlign(ANCHOR_MIDDLE)
    dest.consume:SetHAlign(ANCHOR_LEFT)
    dest.consume:SetPosition(0, -10, 0)
    dest.consume:SetRegionSize(130, 30)

    --移除坐标点按钮
    dest.deletebutton = dest:AddChild(ImageButton("images/global_redux.xml", "close.tex"))
    -- dest.deletebutton:SetOnClick(function() self:OnCancel() end)
    dest.deletebutton:SetNormalScale(.50)
    dest.deletebutton:SetFocusScale(.50)
    dest.deletebutton:SetImageNormalColour(UICOLOURS.GREY)
    dest.deletebutton:SetImageFocusColour(UICOLOURS.WHITE)
    dest.deletebutton:SetPosition(65, 30)
    dest.deletebutton:SetHoverText(STRINGS.MEDAL_UI.DELETEPOS)

    --设置信息
	dest.SetInfo = function(_, info)
		local colornum = info.islingshi and 0 or 1
        --设置选项卡标题文字
		if info.title and info.title ~= "" then
            dest.title:SetString(info.title)
            dest.title:SetColour(1, colornum, colornum, 1)
        else
            dest.title:SetString(STRINGS.DELIVERYSPEECH.NONAME)--无名之塔
            dest.title:SetColour(1, colornum, colornum, 1)
        end
		--耐久消耗文字
        if info.consume then
            dest.consume:SetString(STRINGS.DELIVERYSPEECH.CONSUME .. info.consume)
            dest.consume:SetColour(1, colornum, colornum, 0.8)
            dest.consume:Show()--显示
        elseif info.isplayer then
            dest.consume:SetString(STRINGS.DELIVERYSPEECH.PARTNER)
            dest.consume:SetColour(1, colornum, colornum, 0.8)
            dest.consume:Show()--显示
        else
            dest.consume:Hide()--隐藏
        end

		--传送按钮
		dest.backing:SetOnClick(
			function()
				if info.ischest then
                    self:SetTarget(info.index)
                else
                    self:Travel(info.index)
                end
			end
		)
        
        --移除坐标点按钮
		if info.ispos then
            dest.deletebutton:SetOnClick(
				function()
                    local popup
                    popup = PopupDialogScreen(STRINGS.MEDAL_UI.DELETEPOS_TITLE, STRINGS.MEDAL_UI.DELETEPOS_INFO,
                        {
                            {text=STRINGS.MEDAL_UI.DELETEPOS_YES, cb = function()
                                dest:Kill()
                                self:RemovePos(info.index)
                                TheFrontEnd:PopScreen(popup)
                            end},
                            {text=STRINGS.MEDAL_UI.DELETEPOS_NO, cb = function()
                                TheFrontEnd:PopScreen(popup)
                            end},
                        }
                    )
                    TheFrontEnd:PushScreen(popup)
				end
			)
			dest.deletebutton:Show()--显示
		else
			dest.deletebutton:Hide()--隐藏
		end
		
    end

    dest.focus_forward = dest.backing
    return dest
end
--移除传送点
function MedalTownportalScreen:RemovePos(index)
    --面板没打开直接返回
	if not self.isopen then
        return
    end
	--传送组件
    local medal_delivery = self.attach and self.attach.replica.medal_delivery
    if medal_delivery then
        medal_delivery:RemoveMarkPos(index)
    end
end
--进行旅行
function MedalTownportalScreen:Travel(index)
    --面板没打开直接返回
	if not self.isopen then
        return
    end
	--传送组件
    local medal_delivery = self.attach and self.attach.replica.medal_delivery
    if medal_delivery then
        medal_delivery:Delivery(self.owner, index)
    end
	--关闭界面
    self.owner.HUD:CloseMedalTownportalScreen()
end
--取消
function MedalTownportalScreen:OnCancel()
	if not self.isopen then
        return
    end
	--传空值，用于清空传送塔身上记录的玩家
	local medal_delivery = self.attach and self.attach.replica.medal_delivery
	if medal_delivery then
        -- medal_delivery:Delivery(self.owner, nil)
        medal_delivery:CloseScreen()--清空传送塔身上记录的玩家
    end
	--关闭界面
    self.owner.HUD:CloseMedalTownportalScreen()
end
--更改法杖目标
function MedalTownportalScreen:SetTarget(index)
    --面板没打开直接返回
	if not self.isopen then
        return
    end
	--传送组件
    local medal_delivery = self.attach and self.attach.replica.medal_delivery
    if medal_delivery then
        medal_delivery:SetTarget(index)
    end
	--关闭界面
    self.owner.HUD:CloseMedalTownportalScreen()
end


--其他控制方式
function MedalTownportalScreen:OnControl(control, down)
    if MedalTownportalScreen._base.OnControl(self, control, down) then
        return true
    end

    if not down then
        if control == CONTROL_OPEN_DEBUG_CONSOLE then
            return true
        elseif control == CONTROL_CANCEL then
            self:OnCancel()
        end
    end
end
--关闭
function MedalTownportalScreen:Close()
	if self.isopen then
        self.attach = nil
        self.black:Kill()
        self.isopen = false

        self.inst:DoTaskInTime(
            .2,
            function()
                TheFrontEnd:PopScreen(self)
            end
        )
    end
end

return MedalTownportalScreen
