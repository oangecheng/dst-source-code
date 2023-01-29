local Widget = require "widgets/widget"
local Image = require "widgets/image"

local ChineseFestival =  Class(Widget, function(self, owner)
    self.owner = owner
    Widget._ctor(self, "ChineseFestival")

    self.jingzhe = self:AddChild(Image("images/jingzhe.xml", "jingzhe.tex"))
    self.jingzhe:SetVRegPoint(ANCHOR_MIDDLE)
    self.jingzhe:SetHRegPoint(ANCHOR_RIGHT)
    self.jingzhe:SetVAnchor(ANCHOR_MIDDLE)
    self.jingzhe:SetHAnchor(ANCHOR_RIGHT)
    self.jingzhe:Hide()

    self.qingming = self:AddChild(Image("images/qingming.xml", "qingming.tex"))
    self.qingming:SetVRegPoint(ANCHOR_MIDDLE)
    self.qingming:SetHRegPoint(ANCHOR_RIGHT)
    self.qingming:SetVAnchor(ANCHOR_MIDDLE)
    self.qingming:SetHAnchor(ANCHOR_RIGHT)
    self.qingming:Hide()

    self.zhongyuan = self:AddChild(Image("images/zhongyuan.xml", "zhongyuan.tex"))
    self.zhongyuan:SetVRegPoint(ANCHOR_MIDDLE)
    self.zhongyuan:SetHRegPoint(ANCHOR_RIGHT)
    self.zhongyuan:SetVAnchor(ANCHOR_MIDDLE)
    self.zhongyuan:SetHAnchor(ANCHOR_RIGHT)
    self.zhongyuan:Hide()

    self.qixi = self:AddChild(Image("images/qixi.xml", "qixi.tex"))
    self.qixi:SetVRegPoint(ANCHOR_MIDDLE)
    self.qixi:SetHRegPoint(ANCHOR_RIGHT)
    self.qixi:SetVAnchor(ANCHOR_MIDDLE)
    self.qixi:SetHAnchor(ANCHOR_RIGHT)
    self.qixi:Hide()

    self.dongzhi = self:AddChild(Image("images/dongzhi.xml", "dongzhi.tex"))
    self.dongzhi:SetVRegPoint(ANCHOR_MIDDLE)
    self.dongzhi:SetHRegPoint(ANCHOR_RIGHT)
    self.dongzhi:SetVAnchor(ANCHOR_MIDDLE)
    self.dongzhi:SetHAnchor(ANCHOR_RIGHT)
    self.dongzhi:Hide()

    self.chunjie = self:AddChild(Image("images/chunjie.xml", "chunjie.tex"))
    self.chunjie:SetVRegPoint(ANCHOR_MIDDLE)
    self.chunjie:SetHRegPoint(ANCHOR_RIGHT)
    self.chunjie:SetVAnchor(ANCHOR_MIDDLE)
    self.chunjie:SetHAnchor(ANCHOR_RIGHT)
    self.chunjie:Hide()

    self.inst:ListenForEvent("startchinesefestival", function(inst, data)
        if self.owner == data.target then
            local festival = data.festival;
            if festival == "jingzhe" then
                self.jingzhe:Show()
            elseif festival == "qingming" then
                self.qingming:Show()
            elseif festival == "zhongyuan" then
                self.zhongyuan:Show()
            elseif festival == "qixi" then
                self.qixi:Show()
            elseif festival == "dongzhi" then
                self.dongzhi:Show()
            elseif festival == "chunjie" then
                self.chunjie:Show()
            end
        end
    end, owner)
    self.inst:ListenForEvent("stopchinesefestival", function(inst, data)
        if self.owner == data.target then
            local festival = data.festival;
            if festival == "jingzhe" then
                self.jingzhe:Hide()
            elseif festival == "qingming" then
                self.qingming:Hide()
            elseif festival == "zhongyuan" then
                self.zhongyuan:Hide()
            elseif festival == "qixi" then
                self.qixi:Hide()
            elseif festival == "dongzhi" then
                self.dongzhi:Hide()
            elseif festival == "chunjie" then
                self.chunjie:Hide()
            end
        end
    end, owner)
    self.inst:DoTaskInTime(0, function()
        -- self.jingzhe:Show()
        -- self.qingming:Show()
        -- self.zhongyuan:Show()
        -- self.qixi:Show()
        -- self.dongzhi:Show()
        -- self.chunjie:Show()
    end)

    self.jingzhe:SetPosition(-170, 80)
    self.qingming:SetPosition(-170, 80)
    self.zhongyuan:SetPosition(-170, 80)
    self.qixi:SetPosition(-170, 80)
    self.dongzhi:SetPosition(-170, 80)
    self.chunjie:SetPosition(-170, 80)
end)

return ChineseFestival
