local Widget = require "widgets/widget" 
local ImageButton = require "widgets/imagebutton"
local Image = require "widgets/image"
local Text = require "widgets/text"

local medalBuffPanel = Class(Widget, function(self,owner)
	Widget._ctor(self, "medalBuffPanel")
	self.owner = owner
	self.root = self:AddChild(Widget("ROOT"))
	self.root:Hide()
	
	--顶栏
	self.bar = self.root:AddChild(Image("images/medal_buff_ui.xml", "medal_buff_bar.tex"))
	self.bar:SetSize(260,50)
	self.bar:SetPosition(1,-1,0)
	--展开按钮
	self.open_button = self.root:AddChild(ImageButton("images/medal_buff_ui.xml", "medal_buff_open.tex", "medal_buff_open.tex"))
	self.open_button:SetPosition(-2,-10,0)
	self.open_button:SetTooltip(STRINGS.MEDAL_UI.BUFF_OPEN_TIP)
	self.open_button:SetOnClick(function()
		TUNING.MEDAL_BUFF_SHOW_NUM=false--解除显示数量限制
		SaveMedalSettingData()
		self.close_button:Show()
		self.open_button:Hide()
	end)
	--收起按钮
	self.close_button = self.root:AddChild(ImageButton("images/medal_buff_ui.xml", "medal_buff_close.tex", "medal_buff_close.tex"))
	self.close_button:SetPosition(-2,-9,0)
	self.close_button:SetTooltip(STRINGS.MEDAL_UI.BUFF_CLOSE_TIP)
	self.close_button:SetOnClick(function()
		TUNING.MEDAL_BUFF_SHOW_NUM=2--单次最多显示2个
		SaveMedalSettingData()
		self.close_button:Hide()
		self.open_button:Show()
	end)
	if TUNING.MEDAL_BUFF_SHOW_NUM then
		self.close_button:Hide()
	else
		self.open_button:Hide()
	end

	self.maxbuffnum=15--最多可显示多少条buff

	self:InitBuffLoot()
	self:StartUpdating()
	self:SetPosition(200,300,0)
	self:SetScale(0.8)
	MakeMedalDragableUI(self,self.root,"medal_buff_pos",{drag_offset=0.8})
	local defpos = GetMedalDragPos("medal_buff_pos")
	if defpos then
		self:SetPosition(defpos)
	end

	self.isopen=true

	SendModRPCToServer(MOD_RPC.functional_medal.ToggleBuffTask, TUNING.MEDAL_BUFF_SETTING)--同步下Buff面板设置
end)

--构造单个buff卡
function medalBuffPanel:BuffCard()
	local widget = Widget()--生成选项卡，编号不同
	widget.bg = widget:AddChild(Image("images/global.xml", "square.tex"))
	widget.bg:SetSize(224,32)
	widget.bg:SetTint(0, 0, 0, 0.3)
	
	--buff时长
	widget.buff_time = widget:AddChild(Text(BODYTEXTFONT, 32))
	widget.buff_time:SetPosition(-86, 0)
	widget.buff_time:SetRegionSize( 56, 32 )
	widget.buff_time:SetHAlign( ANCHOR_MIDDLE )--ANCHOR_RIGHT)
	widget.buff_time:SetString("60s")
	widget.buff_time:SetColour(1, 1, 1, 1)

	--buff名
	widget.buff_name = widget:AddChild(Text(BODYTEXTFONT, 32))
	widget.buff_name:SetPosition(37, 0)
	widget.buff_name:SetRegionSize( 190, 32 )
	widget.buff_name:SetHAlign( ANCHOR_LEFT)
	widget.buff_name:SetString("buff名")
	widget.buff_name:SetColour(1, 1, 1, 1)

	return widget
end

function medalBuffPanel:InitBuffLoot()
	for i=1,self.maxbuffnum do
		self["buff_card_"..i] = self.root:AddChild(self:BuffCard())
		self["buff_card_"..i]:SetPosition(0, 0-32*i)--40*i)
		self["buff_card_"..i]:Hide()--默认隐藏
	end
end

local function formattime(time)
    if time < 0 then return "--:--" end
	local min = math.floor(time/60)
    local sec = math.floor(time%60)
    if min < 10 then min = "0"..min end
    if sec < 10 then sec = "0"..sec end
    return min .. ":" .. sec
end

--Hello,如果你是mod作者,欢迎自行兼容,兼容方法很简单,给你的buff添加一个STRINGS.NAMES就可以了
--例如风滚草的保运符buff的prefab是buff_keep_lucky,只需要参考下面这条格式添加buff名即可
--STRINGS.NAMES.BUFF_KEEP_LUCKY="保运符"
--buff名可以是你对这个Buff的命名,也可以是这个buff的获取方式,随你喜欢~

--兼容其他模组用(只能尽量兼容一些常用的,如果有遗漏或者命名不准确的,欢迎自行兼容~兼容方法参考上方~)
--ps：我的English非常poor,所以只能给到中文命名了,英文名或者其他语言的命名也请自行兼容~
local other_mod_buff={
	buff_keep_lucky = TUNING.MEDAL_LANGUAGE =="ch" and "保运符" or "Keep Lucky Symbol",--风滚草是私生子,所以有英文名很合理吧
	--神话
	fly_pill_buff = "腾云丹",
	bloodthirsty_pill_buff = "嗜血丹",
	condensed_pill_buff = "凝味丹",
	armor_pill_buff = "壮骨丹",
	movemountain_pill_buff = "移山丹",
	wb_shadowheart_buff = "暗影心脏",
	myth_zpd_buff = "猪皮冻",
	myth_freezebuff = "冰冻(神话)",
	myth_mooncake_nutsbuff = "五仁月饼",
	myth_mooncake_icebuff = "冰皮月饼",
	myth_mooncake_lotusbuff = "莲蓉月饼",
	myth_food_tsj_buff = "屠苏酒",
	myth_food_bz_buff = "大肉包子",
	myth_flyerfx_wheel_buff = "避火",
	myth_food_fhy_buff = "覆海宴",
	qingniufly_buff = "青牛",
	myth_rhino_redbuff = "辟暑心脏",
	myth_rhino_bluebuff = "辟寒心脏",
	myth_rhino_yellowbuff = "辟尘心脏",
	--棱镜
	buff_batdisguise="蝙蝠伪装",
	buff_bestappetite="好胃口",
	buff_butterflysblessing="蝴蝶庇佑",
	buff_healthstorage="血库",
	buff_hungerretarder="消化不良",
	buff_sporeresistance="孢子抵抗力",
	buff_strengthenhancer="药酒",
	debuff_panicvolcano="惊吓",
	buff_oilflow="腹得流油",
	--富贵险中求
	ndnr_poisondebuff = "中毒",
	ndnr_bloodoverdebuff = "流血",
	ndnr_dragoonpowerdebuff = "龙心灌蛋后遗症",
	ndnr_monsterpoisondebuff = "蛇毒",
	ndnr_coffeedebuff = "咖啡",
	ndnr_dragoonheartdebuff = "龙心",
	ndnr_dragoonheartlavaeggdebuff = "龙心灌蛋",
	ndnr_snakeoildebuff = "蛇油",
	ndnr_badmilkdebuff = "拉肚子",
	ndnr_tentacleblooddebuff = "触手血",
	ndnr_snakewinedebuff = "蛇酒",
	ndnr_beepoisondebuff = "蜂毒(富贵)",
}

function medalBuffPanel:SetBuffInfo()
	local player=self.owner or ThePlayer
	local buff_data
	if player and player.replica.medal_showbufftime then
		local buffstr=player.replica.medal_showbufftime:GetBuffInfo()
		buff_data = buffstr and buffstr~="" and json.decode(buffstr)--buff列表解包
	end

	if buff_data then
		local count=0--buff计数
		for k, v in ipairs(buff_data) do
			local buff_str = STRINGS.NAMES[string.upper(v.buffname)] or other_mod_buff[v.buffname]
			if TUNING.MEDAL_BUFF_SETTING > 1 and buff_str == nil then
				buff_str = v.buffname
			end
			if buff_str ~= nil then
				count=count+1
				if v.bufflayer then
					buff_str=buff_str.."("..v.bufflayer..")"
				end
				self["buff_card_"..count].buff_name:SetString(buff_str)
				self["buff_card_"..count].buff_time:SetString(formattime(v.bufftime))
				self["buff_card_"..count]:Show()
			end 
			--超量了就不显示了
			if (TUNING.MEDAL_BUFF_SHOW_NUM and count>=TUNING.MEDAL_BUFF_SHOW_NUM) or count>=self.maxbuffnum then
				break
			end
		end

		if count>0 then
			self.root:Show()
		end

		for i=count+1,self.maxbuffnum do
			self["buff_card_"..i]:Hide()
		end
	else
		self.root:Hide()
	end
end

function medalBuffPanel:OnUpdate(dt)
	if TheNet:IsServerPaused() then return end
	if self.isopen and TUNING.MEDAL_BUFF_SETTING>0 then
		self.time = (self.time or 0) + dt
		if self.time > 1 then
			-- print("生成面板资源"..self.time)
			self:SetBuffInfo()
			self.time = self.time - 1
		end
    end

	if TUNING.MEDAL_BUFF_SETTING>0 and not self.isopen then
		self.isopen=true
		self:SetBuffInfo()
	elseif self.isopen and TUNING.MEDAL_BUFF_SETTING==0 then
		self.isopen=nil
		self.root:Hide()
	end

end

return medalBuffPanel