local Screen = require "widgets/screen"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"
local PopupDialogScreen = require "screens/redux/popupdialog"

local TEMPLATES = require "widgets/redux/templates"
local ScrollableList = require "widgets/scrollablelist"

local medal_exams=require("medal_defs/"..(TUNING.MEDAL_LANGUAGE =="ch" and "medal_exam_defs" or "medal_exam_defs_en"))
local LINE_MAX = TUNING.MEDAL_LANGUAGE =="ch" and 18 or 50--单行文本长度上限

local MedalExamScreen =
    Class(
    Screen,
    function(self, owner, attach, hasdictionary)
        Screen._ctor(self, "MedalExamScreens")

        self.owner = owner
        self.attach = attach
        -- self.hasdictionary = hasdictionary--是否拥有字典

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
        self.title = self.destspanel:AddChild(Text(BODYTEXTFONT, 35))
        self.title:SetPosition(0, 200, 0)--坐标
        self.title:SetRegionSize(250, 50)--设置区域大小
        self.title:SetHAlign(ANCHOR_MIDDLE)
		self.title:SetString(STRINGS.MEDAL_UI.LISTEN_QUESTION)
        self.title:SetColour(1, 1, 1, 1)--默认颜色

        --题目内容
        self.content = self.destspanel:AddChild(Text(BODYTEXTFONT, 24))
        self.content:SetPosition(0, 150, 0)--坐标
        self.content:SetRegionSize(250, 150)--设置区域大小
        self.content:SetHAlign(ANCHOR_LEFT)
        self.content:SetMultilineTruncatedString("\t锟斤拷烫烫烫，金々昆⊙斥△手※考∪汤≌火∝汤♀火￡汤★火？", 6, 250, 18, true, true)
        self.content:SetColour(1, 1, 1, 1)--默认颜色

        self:InitButton()
        if hasdictionary then
            self:LoadExamData()
        end

        self:Show()--显示
        self.isopen = true--开启

        SetAutopaused(true)
    end
)
--按钮信息
local button_data={
    {--选项A
        name="option_btn1",
        text="A.!@$^@#@#@%",--"A.阿巴阿巴",--STRINGS.MEDAL_SETTING_UI.MEDAL_PAGE,
        fn=function(self)
            self:MakeChoice(1)
        end
    },
    {--选项B
        name="option_btn2",
        text="B.@!@#@&@%",--"B.三短一长选最长",--STRINGS.MEDAL_SETTING_UI.RESET_UI,
        fn=function(self)
            self:MakeChoice(2)
        end
    },
    {--选项C
        name="option_btn3",
        text="C.*%%)$##(-*%!!@#$!%",--"C.选C！",--STRINGS.MEDAL_SETTING_UI.CLOSE,
        fn=function(self)
            self:MakeChoice(3)
        end
    },
    {--选项D
        name="option_btn4",
        text="D.*-*-!%*&#",--"D.钝角",--STRINGS.MEDAL_SETTING_UI.CLOSE,
        fn=function(self)
            self:MakeChoice(4)
        end
    },
}

--初始化选项按钮
function MedalExamScreen:InitButton()
	for i, v in ipairs(button_data) do
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
        self[v.name]:SetPosition(0, 50-40*i)
    end
end

--加载题目数据
function MedalExamScreen:LoadExamData()
	local medal_examable = self.attach and self.attach.replica.medal_examable
    if medal_examable then
        local exam_id = medal_examable:GetExamId() or 0
        local examdata = medal_exams and medal_exams[exam_id]
        if examdata then
            self.content:SetMultilineTruncatedString(examdata.content, 6, 250, LINE_MAX, true, true)
            for i = 1, 4 do
                self["option_btn"..i]:SetText(examdata.options[i])
            end
        end
    end
end

--做出选择
function MedalExamScreen:MakeChoice(answer)
    if self.attach and self.attach.MakeChoice then
        self.attach:MakeChoice(answer,self.owner)
    end
    self:OnCancel()
end

--关闭
function MedalExamScreen:OnCancel()
	if not self.isopen then
        return
    end
	--关闭界面
    self.owner.HUD:CloseMedalExamScreen()
end

--其他控制
function MedalExamScreen:OnControl(control, down)
    if MedalExamScreen._base.OnControl(self, control, down) then
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
function MedalExamScreen:Close()
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

return MedalExamScreen
