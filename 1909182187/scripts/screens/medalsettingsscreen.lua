local Screen = require "widgets/screen"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"
local PopupDialogScreen = require "screens/redux/popupdialog"

local TEMPLATES = require "widgets/redux/templates"
local ScrollableList = require "widgets/scrollablelist"

local MedalSettingsScreen =
    Class(
    Screen,
    function(self, owner, attach)
        Screen._ctor(self, "MedalSettingsScreens")

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
        -- self.destspanel = self.root:AddChild(TEMPLATES.RectangleWindow(350, 550))
        self.destspanel = self.root:AddChild(TEMPLATES.CurlyWindow(200, 320))
        self.destspanel:SetPosition(0, 25)
		--标题
        self.current = self.destspanel:AddChild(Text(BODYTEXTFONT, 35))
        self.current:SetPosition(0, 200, 0)--坐标
        self.current:SetRegionSize(250, 50)--设置区域大小
        self.current:SetHAlign(ANCHOR_MIDDLE)
		self.current:SetString(STRINGS.MEDAL_SETTING_UI.TITLE)
        self.current:SetColour(1, 1, 1, 1)--默认颜色

        self:LoadButton()

        self:Show()--显示
        self.isopen = true--开启

        SetAutopaused(true)
    end
)
--按钮信息
local button_data={
    {--显示物品代码
        name="look_prefab_btn",
        text=STRINGS.MEDAL_SETTING_UI.LOOK_PREFAB,
        spinner_data={
            spinnerdata={
                {text=STRINGS.MEDAL_SETTING_UI.CLOSE,data=false},
                {text=STRINGS.MEDAL_SETTING_UI.OPEN,data=true},
            },
            onchanged_fn=function(spinner_data)
                TUNING.MEDAL_TEST_SWITCH=spinner_data
                SaveMedalSettingData()
            end,
            font_size=22,
            width_label=120,
            width_spinner=120,
            selected_fn=function(spinner)
                spinner:SetSelected(TUNING.MEDAL_TEST_SWITCH)
            end,
        },
    },
    {--调整坎普斯宝匣容器优先级
        name="krampus_chest_btn",
        text=STRINGS.MEDAL_SETTING_UI.KRAMPUS_CHEST,
        spinner_data={
            spinnerdata={
                {text=STRINGS.MEDAL_SETTING_UI.HIGHER,data=0},
                {text=STRINGS.MEDAL_SETTING_UI.MEDIUM,data=1},
                {text=STRINGS.MEDAL_SETTING_UI.LOWEST,data=2},
            },
            onchanged_fn=function(spinner_data)
                TUNING.MEDAL_KRAMPUS_CHEST_PRIORITY=spinner_data
                SaveMedalSettingData()
            end,
            font_size=22,
            width_label=120,
            width_spinner=120,
            selected_fn=function(spinner)
                spinner:SetSelected(TUNING.MEDAL_KRAMPUS_CHEST_PRIORITY)
            end,
        },
    },
    {--BUFF倒计时面板
        name="show_buff_btn",
        text=STRINGS.MEDAL_SETTING_UI.SHOW_BUFF,
        spinner_data={
            spinnerdata={
                {text=STRINGS.MEDAL_SETTING_UI.CLOSE,data=0},
                {text=STRINGS.MEDAL_SETTING_UI.OPEN,data=1},
                {text=STRINGS.MEDAL_SETTING_UI.SHOWALL,data=2},
            },
            onchanged_fn=function(spinner_data)
                TUNING.MEDAL_BUFF_SETTING=spinner_data
                SaveMedalSettingData()
            end,
            font_size=22,
            width_label=120,
            width_spinner=120,
            selected_fn=function(spinner)
                spinner:SetSelected(TUNING.MEDAL_BUFF_SETTING)
            end,
        },
    },
    {--调整勋章tips信息显示
        name="show_medal_info_btn",
        text=STRINGS.MEDAL_SETTING_UI.SHOW_MEDAL_INFO,
        spinner_data={
            spinnerdata={
                {text=STRINGS.MEDAL_SETTING_UI.CLOSE,data=0},
                {text=STRINGS.MEDAL_SETTING_UI.MUST,data=1},
                {text=STRINGS.MEDAL_SETTING_UI.SHOWALL,data=2},
            },
            onchanged_fn=function(spinner_data)
                TUNING.MEDAL_SHOW_INFO=spinner_data
                SaveMedalSettingData()
            end,
            font_size=22,
            width_label=120,
            width_spinner=120,
            selected_fn=function(spinner)
                spinner:SetSelected(TUNING.MEDAL_SHOW_INFO)
            end,
        },
    },
    {--访问介绍页
        name="medal_page_btn",
        text=STRINGS.MEDAL_SETTING_UI.MEDAL_PAGE,
        fn=function()
            VisitURL("https://www.guanziheng.com/", false)
        end
    },
    {--重置拖拽坐标
        name="reset_ui_btn",
        text=STRINGS.MEDAL_SETTING_UI.RESET_UI,
        fn=function()
            ResetMedalUIPos()
        end
    },
    {--关闭按钮
        name="close_btn",
        text=STRINGS.MEDAL_SETTING_UI.CLOSE,
        fn=function(self)
            self:OnCancel()
        end
    },
}

--加载设置按钮
function MedalSettingsScreen:LoadButton()
	for i, v in ipairs(button_data) do
        if v.spinner_data then
            self[v.name] = self.destspanel:AddChild(
                TEMPLATES.LabelSpinner(
                v.text,
                v.spinner_data.spinnerdata,
                v.spinner_data.width_label,
                v.spinner_data.width_spinner,
                v.spinner_data.height,
                v.spinner_data.spacing,
                v.spinner_data.font,
                v.spinner_data.font_size,
                v.spinner_data.horiz_offset,
                v.spinner_data.onchanged_fn,
                v.spinner_data.colour,
                v.spinner_data.tooltip_text
                )
            )
            if v.spinner_data.selected_fn then
                v.spinner_data.selected_fn(self[v.name].spinner)
            end
        else
            self[v.name] = self.destspanel:AddChild(
                TEMPLATES.StandardButton(
                    --点击按钮执行的函数
                    function()
                        v.fn(self)
                    end,
                    v.text,--按钮文字
                    {200, 40}--按钮尺寸
                )
            )
        end
        self[v.name]:SetPosition(0, 180-40*i)
    end
end

--关闭
function MedalSettingsScreen:OnCancel()
	if not self.isopen then
        return
    end
	--关闭界面
    self.owner.HUD:CloseMedalSettingsScreen()
end

--其他控制
function MedalSettingsScreen:OnControl(control, down)
    if MedalSettingsScreen._base.OnControl(self, control, down) then
        return true
    end

    if not down and (control == CONTROL_MAP or control == CONTROL_CANCEL) then
		TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
        TheFrontEnd:PopScreen()
        SetAutopaused(false)
        return true
    end
	return false
end
--关闭
function MedalSettingsScreen:Close()
	if self.isopen then
        self.black:Kill()
        self.isopen = false

        self.inst:DoTaskInTime(
            .2,
            function()
                TheFrontEnd:PopScreen(self)
            end
        )
    end
    SetAutopaused(false)
end

return MedalSettingsScreen
