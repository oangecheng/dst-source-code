local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"

local function formattime(time)
    return os.date("%M:%S", time)
end

local BuffTime = Class(Widget, function(self, owner)
    Widget._ctor(self, "BuffTime")
    self.owner = owner
    self.buffwidget = self:AddChild(Widget())
    self.buffwidget:Hide()

    self.tmp = 0
	self:StartUpdating()

    self.owner:DoTaskInTime(2, function()
        self.buffwidget:Show()
    end)
end)

function BuffTime:UpdateUI()
    if self.owner.replica.ndnr_bufftime == nil then return end
    local hudscale = TheFrontEnd:GetHUDScale()
    local i = 0
    local items = self.owner.replica.ndnr_bufftime:GetItems()
    for k, vv in pairs(items) do
        local v = TUNING.NDNR_BUFFTIMES[vv.buffname]
        if self["root"..v.name] == nil then
            self["root"..v.name] = self.buffwidget:AddChild(Widget())

            self["bg"..v.name] = self["root"..v.name]:AddChild(UIAnim())
            self["bg"..v.name]:GetAnimState():SetBank(v.bank)
            self["bg"..v.name]:GetAnimState():SetBuild(v.build)
            self["bg"..v.name]:GetAnimState():PlayAnimation(v.animation, v.loop)
            if v.symbol ~= nil or v.overridebuild ~= nil or v.overridesymbol ~= nil then
                self["bg"..v.name]:GetAnimState():OverrideSymbol(v.symbol or "swap_food", v.overridebuild or v.build, v.overridesymbol)
            end
            self["bg"..v.name]:SetPosition(v.offset.x, v.offset.y)
            self["bg"..v.name]:SetScale(v.scale * hudscale*0.8)

            self["time"..v.name] = self["root"..v.name]:AddChild(Text(NUMBERFONT, 24*hudscale, formattime(vv.time)))
            self["time"..v.name]:SetPosition(0, -30*hudscale)
            i = i + 1
        else
            if vv.show == false then
                self["root"..v.name]:Hide()
            else
                if not self["root"..v.name]:IsVisible() then self["root"..v.name]:Show() end
                self["time"..v.name]:SetSize(24*hudscale)
                self["time"..v.name]:SetString(formattime(vv.time))
                self["time"..v.name]:SetPosition(0, -30*hudscale)
                self["bg"..v.name]:SetPosition(v.offset.x, v.offset.y)
                self["bg"..v.name]:SetScale(v.scale * hudscale*0.8)

                i = i + 1
            end
        end
        self["root"..v.name]:SetPosition(i * 55*hudscale, 0)
    end
end

function BuffTime:OnUpdate(dt)
    self.tmp = self.tmp + dt
    if self.tmp >= 1 then
        self.tmp = 0
        if not ThePlayer.HUD:IsPauseScreenOpen() then
            self:UpdateUI()
        end
    end
end

return BuffTime