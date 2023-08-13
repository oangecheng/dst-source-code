local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local Widget = require "widgets/widget"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local AnimButton = require "widgets/animbutton"
local HoverText = require "widgets/hoverer"
require "AllAchiv/allachivbalance"

local uiachievement = Class(Widget, function(self, owner)
	Widget._ctor(self, "uiachievement")
	self.owner = owner
	self.mainui = self:AddChild(Widget("mainui"))

	self.mainui.allachiv = self.mainui:AddChild(Widget("allachiv"))
	self.mainui.allachiv:SetPosition(0, 460, 0)
	self.mainui.allachiv:Hide()

	self.mainui.allcoin = self.mainui:AddChild(Widget("allcoin"))
	self.mainui.allcoin:SetPosition(0, 460, 0)
	self.mainui.allcoin:Hide()

	self.mainui.bigtitle = self.mainui:AddChild(Image("images/hud/bigtitle_"..TUNING.AllAchivLan..".xml", "bigtitle_"..TUNING.AllAchivLan..".tex"))
	self.mainui.bigtitle:SetPosition(0, 420, 0)
	self.mainui.bigtitle:SetTint(1,1,1,0.95)
	self.mainui.bigtitle:SetScale(.9,.9,1)
	self.mainui.bigtitle:MoveToFront()
	self.mainui.bigtitle:Hide()

	self.mainui.coinamount = self.mainui:AddChild(Text(NEWFONT_OUTLINE, 40, self.owner.currentcoinamount:value()))
	self.mainui.coinamount:SetPosition(85, 400, 0)
	self.mainui.coinamount:Hide()

	self.mainbutton = self:AddChild(Widget("mainbutton"))
	self.mainbutton:SetPosition(-850, 460, 0)
	self.mainbutton:SetScale(1,1,1)

	self.mainbutton.checkbuttonglow = self.mainbutton:AddChild(Image("images/button/checkbuttonglow.xml", "checkbuttonglow.tex"))
    self.mainbutton.checkbuttonglow:SetClickable(false)
    self.mainbutton.checkbuttonglow:Hide()

    self.mainbutton.checkbutton = self.mainbutton:AddChild(ImageButton("images/button/checkbutton.xml", "checkbutton.tex"))
    self.mainbutton.checkbutton:MoveToFront()
    self.mainbutton.checkbutton:SetHoverText(STRINGS.ALLACHIVCURRENCY[7])

	self.mainbutton.checkbutton:SetOnGainFocus(function() self.mainbutton.checkbuttonglow:Show() end)
	self.mainbutton.checkbutton:SetOnLoseFocus(function() self.mainbutton.checkbuttonglow:Hide() end)
	self.mainbutton.checkbutton:SetOnClick(function()
		if self.mainui.allachiv.shown then
			self.mainui.allachiv:Hide()
			self.mainui.bigtitle:Hide()
			self.mainui.coinamount:Hide()
			self.mainui.infobutton:Hide()
		else
			self.mainui.allachiv:Show()
			self.mainui.bigtitle:Show()
			self.mainui.coinamount:Show()
			self.mainui.infobutton:Show()
			self.mainui.allcoin:Hide()
		end
		self.maxnumpage = math.ceil(#self.achivlist/14)
		if self.numpage == 1 then
			self.mainui.infobutton.last:SetTextures("images/button/last_dact.xml", "last_dact.tex")
		else
			self.mainui.infobutton.last:SetTextures("images/button/last_act.xml", "last_act.tex")
		end
		if self.numpage >= self.maxnumpage then
			self.mainui.infobutton.next:SetTextures("images/button/next_dact.xml", "next_dact.tex")
		else
			self.mainui.infobutton.next:SetTextures("images/button/next_act.xml", "next_act.tex")
		end
	end)

	self.mainbutton.coinbuttonglow = self.mainbutton:AddChild(Image("images/button/coinbuttonglow.xml", "coinbuttonglow.tex"))
    self.mainbutton.coinbuttonglow:SetClickable(false)
    self.mainbutton.coinbuttonglow:Hide()
    self.mainbutton.coinbuttonglow:SetPosition(55, -2, 0)
    self.mainbutton.coinbuttonglow:SetScale(1,1,1)

    self.mainbutton.coinbutton = self.mainbutton:AddChild(ImageButton("images/button/coinbutton.xml", "coinbutton.tex"))
    self.mainbutton.coinbutton:MoveToFront()
    self.mainbutton.coinbutton:SetPosition(55, -2, 0)
    self.mainbutton.coinbutton:SetScale(1,1,1)
    self.mainbutton.coinbutton:SetHoverText(STRINGS.ALLACHIVCURRENCY[8])

	self.mainbutton.coinbutton:SetOnGainFocus(function() self.mainbutton.coinbuttonglow:Show() end)
	self.mainbutton.coinbutton:SetOnLoseFocus(function() self.mainbutton.coinbuttonglow:Hide() end)
	self.mainbutton.coinbutton:SetOnClick(function()
		if self.mainui.allcoin.shown then
			self.mainui.allcoin:Hide()
			self.mainui.bigtitle:Hide()
			self.mainui.coinamount:Hide()
			self.mainui.infobutton:Hide()
		else
			self.mainui.allcoin:Show()
			self.mainui.bigtitle:Show()
			self.mainui.coinamount:Show()
			self.mainui.infobutton:Show()
			self.mainui.allachiv:Hide()
		end
		self.mainui.infobutton.last:SetTextures("images/button/last_dact.xml", "last_dact.tex")
		self.mainui.infobutton.next:SetTextures("images/button/next_dact.xml", "next_dact.tex")
	end)

	self.mainbutton.configbg = self.mainbutton:AddChild(Image("images/button/config_bg.xml", "config_bg.tex"))
	self.mainbutton.configbg:SetPosition(193, -5, 0)
	self.mainbutton.configbg:SetClickable(false)
	self.mainbutton.configbg:Hide()

	self.mainbutton.configact = self.mainbutton:AddChild(ImageButton("images/button/config_dact.xml", "config_dact.tex"))
	self.mainbutton.configact:SetPosition(115, -5, 0)
	self.mainbutton.configact:SetNormalScale(1,1,1)
	self.mainbutton.configact:SetFocusScale(1.1,1.1,1)
	self.mainbutton.configact:SetHoverText(STRINGS.ALLACHIVCURRENCY[15])
	self.mainbutton.configact:SetOnClick(function()
		if self.mainbutton.configbg.shown then
			self.mainbutton.configact:SetTextures("images/button/config_dact.xml", "config_dact.tex")
			self.mainbutton.configbg:Hide()
			self.mainbutton.configbigger:Hide()
			self.mainbutton.configsmaller:Hide()
			self.mainbutton.configremove:Hide()
		else
			self.mainbutton.configact:SetTextures("images/button/config_act.xml", "config_act.tex")
			self.mainbutton.configbg:Show()
			self.mainbutton.configbigger:Show()
			self.mainbutton.configsmaller:Show()
			self.mainbutton.configremove:Show()
		end
		self.mainbutton.removeinfo:Hide()
		self.mainbutton.removeyes:Hide()
		self.mainbutton.removeno:Hide()
	end)

	self.size = 1
	self.mainbutton.configbigger = self.mainbutton:AddChild(ImageButton("images/button/config_bigger.xml", "config_bigger.tex"))
	self.mainbutton.configbigger:SetPosition(167, -5, 0)
	self.mainbutton.configbigger:Hide()
	self.mainbutton.configbigger:SetNormalScale(1,1,1)
	self.mainbutton.configbigger:SetFocusScale(1.1,1.1,1)
	self.mainbutton.configbigger:SetHoverText(STRINGS.ALLACHIVCURRENCY[16])
	self.mainbutton.configbigger:SetOnClick(function()
		if not self.mainui.allachiv.shown and not self.mainui.allcoin.shown then
			self.mainui.allachiv:Show()
			self.mainui.bigtitle:Show()
			self.mainui.coinamount:Show()
			self.mainui.infobutton:Show()
		end
		self.size = self.size + .02
		self.mainui:SetScale(self.size, self.size, 1)
	end)

	self.mainbutton.configsmaller = self.mainbutton:AddChild(ImageButton("images/button/config_smaller.xml", "config_smaller.tex"))
	self.mainbutton.configsmaller:SetPosition(219, -5, 0)
	self.mainbutton.configsmaller:Hide()
	self.mainbutton.configsmaller:SetNormalScale(1,1,1)
	self.mainbutton.configsmaller:SetFocusScale(1.1,1.1,1)
	self.mainbutton.configsmaller:SetHoverText(STRINGS.ALLACHIVCURRENCY[17])
	self.mainbutton.configsmaller:SetOnClick(function()
		if not self.mainui.allachiv.shown and not self.mainui.allcoin.shown then
			self.mainui.allachiv:Show()
			self.mainui.bigtitle:Show()
			self.mainui.coinamount:Show()
			self.mainui.infobutton:Show()
		end
		if self.size > .02 then
			self.size = self.size - .02
		end
		self.mainui:SetScale(self.size, self.size, 1)
	end)

	self.mainbutton.configremove = self.mainbutton:AddChild(ImageButton("images/button/config_remove.xml", "config_remove.tex"))
	self.mainbutton.configremove:SetPosition(271, -5, 0)
	self.mainbutton.configremove:Hide()
	self.mainbutton.configremove:SetNormalScale(1,1,1)
	self.mainbutton.configremove:SetFocusScale(1.1,1.1,1)
	self.mainbutton.configremove:SetHoverText(STRINGS.ALLACHIVCURRENCY[18])
	self.mainbutton.configremove:SetOnClick(function()
		self.mainbutton.removeinfo:Show()
		self.mainbutton.removeyes:Show()
		self.mainbutton.removeno:Show()
	end)

	self.mainbutton.removeinfo = self.mainbutton:AddChild(Image("images/button/remove_info_"..TUNING.AllAchivLan..".xml", "remove_info_"..TUNING.AllAchivLan..".tex"))
	self.mainbutton.removeinfo:SetPosition(137, -105, 0)
	self.mainbutton.removeinfo:SetScale(.95,.95,1)
	self.mainbutton.removeinfo:Hide()

	self.mainbutton.removeyes = self.mainbutton:AddChild(ImageButton("images/button/remove_yes.xml", "remove_yes.tex"))
	self.mainbutton.removeyes:SetPosition(17, -77, 0)
	self.mainbutton.removeyes:Hide()
	self.mainbutton.removeyes:SetNormalScale(1,1,1)
	self.mainbutton.removeyes:SetFocusScale(1.1,1.1,1)
	self.mainbutton.removeyes:SetOnClick(function()
		SendModRPCToServer(MOD_RPC["DSTAchievement"]["removecoin"])
		self.owner:DoTaskInTime(.35, function()
			self:loadcoinlist()
			self:coinbuild()
		end)
		self.mainbutton.removeinfo:Hide()
		self.mainbutton.removeyes:Hide()
		self.mainbutton.removeno:Hide()
		self.mainui.allcoin:Hide()
		self.mainui.bigtitle:Hide()
		self.mainui.coinamount:Hide()
		self.mainui.infobutton:Hide()
		self.mainui.allachiv:Hide()
	end)

	self.mainbutton.removeno = self.mainbutton:AddChild(ImageButton("images/button/remove_no.xml", "remove_no.tex"))
	self.mainbutton.removeno:SetPosition(257, -77, 0)
	self.mainbutton.removeno:Hide()
	self.mainbutton.removeno:SetNormalScale(1,1,1)
	self.mainbutton.removeno:SetFocusScale(1.1,1.1,1)
	self.mainbutton.removeno:SetOnClick(function()
		self.mainbutton.removeinfo:Hide()
		self.mainbutton.removeyes:Hide()
		self.mainbutton.removeno:Hide()
	end)

	--self.mainbutton.configdrag = self.mainbutton:AddChild(Image("images/button/config_drag.xml", "config_drag.tex"))
	--self.mainbutton.configdrag:SetPosition(271, -5, 0)
	--self.mainbutton.configdrag:Hide()
	--self.mainbutton.configdrag:SetHoverText("拖动")
	--self.mainbutton.configdrag:SetOnGainFocus(function() self.mainbutton.dragcheck = true end)
	--self.mainbutton.configdrag:SetOnLoseFocus(function() self.mainbutton.dragcheck = false end)

	--self.mainbutton.oldOnControl = self.mainbutton.OnControl
	--function self.mainbutton:OnControl (control, down)
	--	if control == CONTROL_ACCEPT and self.dragcheck == true then
	--		if down then
	--			self:StartDrag()
	--		else
	--			self:EndDrag()
	--		end
	--	end
	--	self:oldOnControl(control, down)
	--end

	--function self.mainbutton:SetDragPosition(x, y, z)
	--	local pos
	--	if type(x) == "number" then
	--		pos = Vector3(x, y, z)
	--	else
	--		pos = x
	--	end
	--	local p = pos + self.dragPosDiff
	--	self:SetPosition(p)
	--end
	--function self.mainbutton:StartDrag()
	--	if not self.followhandler then
	--		local mousepos = TheInput:GetScreenPosition()/self.hudscale.x/.72
	--		self.dragPosDiff = self:GetPosition()/self.hudscale.x/.72 - mousepos
	--		self.followhandler = TheInput:AddMoveHandler(function(x,y) self:SetDragPosition(x/self.hudscale.y/.72,y/self.hudscale.y/.72) end)
			--self:SetDragPosition(mousepos)
	--	end
	--end

	--function self.mainbutton:EndDrag()
	--	if self.followhandler then
	--		self.followhandler:Remove()
	--	end
	--	self.followhandler = nil
	--	self.dragPosDiff = nil
	--end

	self.mainui.infobutton = self.mainui:AddChild(Widget("infobutton"))
	self.mainui.infobutton:SetPosition(240, -30, 0)
	self.mainui.infobutton:Hide()

	self.mainui.infobutton.info = self.mainui.infobutton:AddChild(Image("images/button/info_"..TUNING.AllAchivLan..".xml", "info_"..TUNING.AllAchivLan..".tex"))
	self.mainui.infobutton.info:Hide()

	self.mainui.infobutton.question = self.mainui.infobutton:AddChild(ImageButton("images/button/infobutton.xml", "infobutton.tex"))
	self.mainui.infobutton.question:SetPosition(40, -370, 0)
	self.mainui.infobutton.question:SetOnClick(function()
		if self.mainui.infobutton.info.shown then
			self.mainui.infobutton.info:Hide()
		else
			self.mainui.infobutton.info:Show()
		end
	end)

	self.mainui.infobutton.last = self.mainui.infobutton:AddChild(ImageButton("images/button/last_dact.xml", "last_dact.tex"))
	self.mainui.infobutton.last:SetPosition(98, -370, 0)
	self.mainui.infobutton.last:SetOnClick(function()
		if self.numpage > 1 and self.mainui.allachiv.shown then
			self.numpage = self.numpage - 1
			self:build()
			self.mainui.infobutton.next:SetTextures("images/button/next_act.xml", "next_act.tex")
		end
		if self.numpage == 1 then
			self.mainui.infobutton.last:SetTextures("images/button/last_dact.xml", "last_dact.tex")
		end
	end)

	self.mainui.infobutton.next = self.mainui.infobutton:AddChild(ImageButton("images/button/next_act.xml", "next_act.tex"))
	self.mainui.infobutton.next:SetPosition(161, -370, 0)
	self.mainui.infobutton.next:SetOnClick(function()
		if self.numpage < self.maxnumpage and self.mainui.allachiv.shown then
			self.numpage = self.numpage + 1
			self:build()
			self.mainui.infobutton.last:SetTextures("images/button/last_act.xml", "last_act.tex")
		end
		if self.numpage == self.maxnumpage then
			self.mainui.infobutton.next:SetTextures("images/button/next_dact.xml", "next_dact.tex")
		end
	end)

	self.mainui.infobutton.close = self.mainui.infobutton:AddChild(ImageButton("images/button/close.xml", "close.tex"))
	self.mainui.infobutton.close:SetPosition(220, -370, 0)
	self.mainui.infobutton.close:SetOnClick(function()
		self.mainui.allachiv:Hide()
		self.mainui.allcoin:Hide()
		self.mainui.bigtitle:Hide()
		self.mainui.coinamount:Hide()
		self.mainui.infobutton:Hide()
	end)

	self.inst:DoTaskInTime(.2, function()
		self.numpage = 1
		self:loadlist()
		self:loadcoinlist()
		self.maxnumpage = math.ceil(#self.achivlist/14)
		self.achivlistbg = {}
		self.achivlisttile = {}
		self.coinlistbutton = {}
		self:build()
		self:coinbuild()
		self:StartUpdating()
	end)
end)

function uiachievement:OnUpdate(dt)
	self.mainui.coinamount:SetString(self.owner.currentcoinamount:value())

	self:loadlist()
	for i = 1+14*(self.numpage-1), math.min(#self.achivlist, 14*(1+self.numpage-1)) do
		local check = "dact"
    	if self.achivlist[i].check == 1 then check = "act" end
		self.achivlistbg[i]:SetTexture("images/hud/achivbg_"..check..".xml", "achivbg_"..check..".tex")

    	self.achivlisttile[i]:SetTexture("images/hud/achivtile_"..check.."_"..TUNING.AllAchivLan.."_"..self.achivlist[i].name..".xml", "achivtile_"..check.."_"..TUNING.AllAchivLan.."_"..self.achivlist[i].name..".tex")
    	if allachiv_eventdata[self.achivlist[i].name] ~= nil and self.achivlist[i].name ~= "king" and self.achivlist[i].name ~= "all" then
    		self.achivlisttile[i]:SetHoverText(STRINGS.ALLACHIVCURRENCY[9]..self.achivlist[i].current.."/"..allachiv_eventdata[self.achivlist[i].name])
    	else
    		self.achivlisttile[i]:SetHoverText(STRINGS.ALLACHIVCURRENCY[9]..self.achivlist[i].check.."/1")
    	end
    	if self.achivlist[i].name == "king" then
    		self.achivlisttile[i]:SetHoverText(STRINGS.ALLACHIVCURRENCY[9]..STRINGS.ALLACHIVCURRENCY[11]..self.achivlist[i].current1.."  "..STRINGS.ALLACHIVCURRENCY[12]..self.achivlist[i].current2.."  "..STRINGS.ALLACHIVCURRENCY[13]..self.achivlist[i].current3.."  "..STRINGS.ALLACHIVCURRENCY[14]..self.achivlist[i].current4)
    	end
    	if self.achivlist[i].name == "all" then
    		self.achivlisttile[i]:SetHoverText(STRINGS.ALLACHIVCURRENCY[9]..self.achivlist[i].current.."/"..(#self.achivlist-1))
    	end
	end
end

function uiachievement:build()
	self.mainui.allachiv:KillAllChildren()
	local x = 240
	local y = -97.5
	for i = 1+14*(self.numpage-1), math.min(#self.achivlist, 14*(1+self.numpage-1)) do
		if math.ceil(i/2) ~= i/2 then x = -240 else x = 240 end
		if math.ceil(i/2) ~= i/2 then y = y-97.5 end

		local check = "dact"
    	if self.achivlist[i].check == 1 then check = "act" end
		self.achivlistbg[i] = self.mainui.allachiv:AddChild(Image("images/hud/achivbg_"..check..".xml", "achivbg_"..check..".tex"))
		self.achivlistbg[i]:SetPosition(x, y, 0)
    	self.achivlistbg[i]:SetTint(1,1,1,0.95)

    	self.achivlisttile[i] = self.mainui.allachiv:AddChild(Image("images/hud/achivtile_"..check.."_"..TUNING.AllAchivLan.."_"..self.achivlist[i].name..".xml", "achivtile_"..check.."_"..TUNING.AllAchivLan.."_"..self.achivlist[i].name..".tex"))
		self.achivlisttile[i]:SetPosition(x, y, 0)
    	self.achivlisttile[i]:SetTint(1,1,1,0.95)
    	if allachiv_eventdata[self.achivlist[i].name] ~= nil and self.achivlist[i].name ~= "king" and self.achivlist[i].name ~= "all" then
    		self.achivlisttile[i]:SetHoverText(STRINGS.ALLACHIVCURRENCY[9]..self.achivlist[i].current.."/"..allachiv_eventdata[self.achivlist[i].name])
    	else
    		self.achivlisttile[i]:SetHoverText(STRINGS.ALLACHIVCURRENCY[9]..self.achivlist[i].check.."/1")
    	end
    	if self.achivlist[i].name == "king" then
    		self.achivlisttile[i]:SetHoverText(STRINGS.ALLACHIVCURRENCY[9]..STRINGS.ALLACHIVCURRENCY[11]..self.achivlist[i].current1.."  "..STRINGS.ALLACHIVCURRENCY[12]..self.achivlist[i].current2.."  "..STRINGS.ALLACHIVCURRENCY[13]..self.achivlist[i].current3.."  "..STRINGS.ALLACHIVCURRENCY[14]..self.achivlist[i].current4)
    	end
    	if self.achivlist[i].name == "all" then
    		self.achivlisttile[i]:SetHoverText(STRINGS.ALLACHIVCURRENCY[9]..self.achivlist[i].current.."/"..(#self.achivlist-1))
    	end
	end
end

function uiachievement:coinbuild()
	self.mainui.allcoin:KillAllChildren()
	local x = -360
	local y = -192.5
	for i = 1, #self.coinlist do
		if math.ceil(i/4) ~= math.ceil((i-1)/4) then x = -360 else x = x + 360*2/3 end
		y = -192.5-96*(math.ceil(i/4)-1)

		self.coinlistbutton[i] = self.mainui.allcoin:AddChild(ImageButton("images/coin_"..TUNING.AllAchivLan.."/"..self.coinlist[i].name..".xml", self.coinlist[i].name..".tex"))
		self.coinlistbutton[i]:SetPosition(x, y, 0)
    	self.coinlistbutton[i]:SetImageNormalColour(1,1,1,0.95)
    	self.coinlistbutton[i]:SetOnClick(function()
    		SendModRPCToServer(MOD_RPC["DSTAchievement"][self.coinlist[i].name])
    		self.owner:DoTaskInTime(.3, function()
    			self:loadcoinlist()
    			self.coinlistbutton[i]:SetHoverText(STRINGS.ALLACHIVCURRENCY[10]..self.coinlist[i].current)
			end)
		end)
		self.coinlistbutton[i]:SetNormalScale(1,1,1)
    	self.coinlistbutton[i]:SetFocusScale(1.02,1.02,1)
		self.coinlistbutton[i]:SetHoverText(STRINGS.ALLACHIVCURRENCY[10]..self.coinlist[i].current)
	end
end

function uiachievement:loadlist()
	self.achivlist = {
		{
			name = "intogame",
			check = self.owner.checkintogame:value(),
			current = nil,
		},
		{
			name = "firsteat",
			check = self.owner.checkfirsteat:value(),
			current = nil,
		},
		{
			name = "supereat",
			check = self.owner.checksupereat:value(),
			current = self.owner.currenteatamount:value(),
		},
		{
			name = "danding",
			check = self.owner.checkdanding:value(),
			current = self.owner.currenteatmonsterlasagna:value(),
		},
		{
			name = "messiah",
			check = self.owner.checkmessiah:value(),
			current = self.owner.currentrespawnamount:value(),
		},
		{
			name = "walkalot",
			check = self.owner.checkwalkalot:value(),
			current = self.owner.currentwalktime:value(),
		},
		{
			name = "stopalot",
			check = self.owner.checkstopalot:value(),
			current = self.owner.currentstoptime:value(),
		},
		{
			name = "tooyoung",
			check = self.owner.checktooyoung:value(),
			current = nil,
		},
		{
			name = "evil",
			check = self.owner.checkevil:value(),
			current = self.owner.currentevilamount:value(),
		},
		{
			name = "snake",
			check = self.owner.checksnake:value(),
			current = self.owner.currentsnakeamount:value(),
		},
		{
			name = "deathalot",
			check = self.owner.checkdeathalot:value(),
			current = self.owner.currentdeathamouth:value(),
		},
		{
			name = "nosanity",
			check = self.owner.checknosanity:value(),
			current = self.owner.currentnosanitytime:value(),
		},
		{
			name = "sick",
			check = self.owner.checksick:value(),
			current = nil,
		},
		{
			name = "coldblood",
			check = self.owner.checkcoldblood:value(),
			current = nil,
		},
		{
			name = "burn",
			check = self.owner.checkburn:value(),
			current = nil,
		},
		{
			name = "freeze",
			check = self.owner.checkfreeze:value(),
			current = nil,
		},
		{
			name = "goodman",
			check = self.owner.checkgoodman:value(),
			current = self.owner.currentfriendpig:value(),
		},
		{
			name = "brother",
			check = self.owner.checkbrother:value(),
			current = self.owner.currentfriendbunny:value(),
		},
		{
			name = "fishmaster",
			check = self.owner.checkfishmaster:value(),
			current = self.owner.currentfishamount:value(),
		},
		{
			name = "pickmaster",
			check = self.owner.checkpickmaster:value(),
			current = self.owner.currentpickamount:value(),
		},
		{
			name = "chopmaster",
			check = self.owner.checkchopmaster:value(),
			current = self.owner.currentchopamount:value(),
		},
		{
			name = "cookmaster",
			check = self.owner.checkcookmaster:value(),
			current = self.owner.currentcookamount:value(),
		},
		{
			name = "buildmaster",
			check = self.owner.checkbuildmaster:value(),
			current = self.owner.currentbuildamount:value(),
		},
		{
			name = "longage",
			check = self.owner.checklongage:value(),
			current = self.owner.currentage:value(),
		},
		{
			name = "noob",
			check = self.owner.checknoob:value(),
			current = nil,
		},
		{
			name = "luck",
			check = self.owner.checkluck:value(),
			current = nil,
		},
		{
			name = "black",
			check = self.owner.checkblack:value(),
			current = nil,
		},
		{
			name = "tank",
			check = self.owner.checktank:value(),
			current = self.owner.currentattackeddamage:value(),
		},
		{
			name = "angry",
			check = self.owner.checkangry:value(),
			current = self.owner.currentonhitdamage:value(),
		},
		{
			name = "icebody",
			check = self.owner.checkicebody:value(),
			current = self.owner.currenticetime:value(),
		},
		{
			name = "firebody",
			check = self.owner.checkfirebody:value(),
			current = self.owner.currentfiretime:value(),
		},
		{
			name = "moistbody",
			check = self.owner.checkmoistbody:value(),
			current = self.owner.currentmoisttime:value(),
		},
		{
			name = "rigid",
			check = self.owner.checkrigid:value(),
			current = nil,
		},
		{
			name = "ancient",
			check = self.owner.checkancient:value(),
			current = nil,
		},
		{
			name = "queen",
			check = self.owner.checkqueen:value(),
			current = nil,
		},
		{
			name = "king",
			check = self.owner.checkking:value(),
			current1 = self.owner.checkbossspring:value(),
			current2 = self.owner.checkbossdragonfly:value(),
			current3 = self.owner.checkbossautumn:value(),
			current4 = self.owner.checkbosswinter:value(),
		},
		{
			name = "all",
			check = self.owner.checkall:value(),
			current = 0,
		},
	}

	local achivvalue = 0
	for i=1, #self.achivlist do
		if self.achivlist[i].name ~= "all" then
			achivvalue = achivvalue + self.achivlist[i].check
		else
			self.achivlist[i].current = achivvalue
		end
	end
end

function uiachievement:loadcoinlist()
	self.coinlist = {
		{
			name = "hungerup",
			current = self.owner.currenthungerup:value(),
		},
		{
			name = "sanityup",
			current = self.owner.currentsanityup:value(),
		},
		{
			name = "healthup",
			current = self.owner.currenthealthup:value(),
		},
		{
			name = "hungerrateup",
			current = self.owner.currenthungerrateup:value(),
		},
		{
			name = "healthregen",
			current = self.owner.currenthealthregen:value(),
		},
		{
			name = "sanityregen",
			current = self.owner.currentsanityregen:value(),
		},
		{
			name = "speedup",
			current = self.owner.currentspeedup:value(),
		},
		{
			name = "absorbup",
			current = self.owner.currentabsorbup:value(),
		},
		{
			name = "damageup",
			current = self.owner.currentdamageup:value(),
		},
		{
			name = "crit",
			current = self.owner.currentcrit:value(),
		},
		{
			name = "fireflylight",
			current = self.owner.currentfireflylight:value(),
		},
		{
			name = "goodman",
			current = self.owner.currentgoodman:value(),
		},
		{
			name = "fishmaster",
			current = self.owner.currentfishmaster:value(),
		},
		{
			name = "chopmaster",
			current = self.owner.currentchopmaster:value(),
		},
		{
			name = "cookmaster",
			current = self.owner.currentcookmaster:value(),
		},
		{
			name = "pickmaster",
			current = self.owner.currentpickmaster:value(),
		},
		{
			name = "nomoist",
			current = self.owner.currentnomoist:value(),
		},
		{
			name = "icebody",
			current = self.owner.currenticebody:value(),
		},
		{
			name = "firebody",
			current = self.owner.currentfirebody:value(),
		},
		{
			name = "doubledrop",
			current = self.owner.currentdoubledrop:value(),
		},
		{
			name = "buildmaster",
			current = self.owner.currentbuildmaster:value(),
		},
		{
			name = "refresh",
			current = self.owner.currentrefresh:value(),
		},
		{
			name = "reader",
			current = self.owner.currentreader:value(),
		},
		{
			name = "supply",
			current = self.owner.currentsupply:value(),
		},
	}
end

return uiachievement