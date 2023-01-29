local PoisonOver = require "widgets/ndnr_poisonover"
local UIAnim = require "widgets/uianim"
local ChineseFestival = require "widgets/ndnr_chinese_festival"
-- local EmoBadge = require "widgets/ndnr_emobadge"

AddClassPostConstruct("screens/playerhud", function(self)
    local _CreateOverlays = self.CreateOverlays
    function self:CreateOverlays(owner)
        _CreateOverlays(self, owner)
        self.poisonover = self.overlayroot:AddChild(PoisonOver(owner))
        self.chinesefestival = self.overlayroot:AddChild(ChineseFestival(owner))
    end
end)

AddClassPostConstruct("widgets/bloodover", function(self, owner)
    local function _StartBloodover(inst, data)
        if self.owner == data.target then
            self:TurnOn()
        end
    end
    local function _StopBloodover(inst, data)
        if self.owner == data.target then
            self:TurnOff()
        end
    end
    self.inst:ListenForEvent("startbloodover_cat", _StartBloodover, self.owner)
    self.inst:ListenForEvent("stopbloodover_cat", _StopBloodover, self.owner)
end)

--[[
AddClassPostConstruct("widgets/statusdisplays", function(self, owner)

    if table.contains(TUNING.NDNR_NO_EMOSTATUS_PLAYER, owner.prefab) then return end

    local function OnSetPlayerEmoMode(inst, self)
        if self.onemodelta == nil then
            self.onemodelta = function(owner, data) self:EmoDelta(data) end
            self.inst:ListenForEvent("emodelta", self.onemodelta, self.owner)
            self:SetEmoPercent(self.owner.replica.ndnr_emo:GetPercent())
        end
    end

    local function OnSetGhostEmoMode(inst, self)
        if self.onemodelta ~= nil then
            self.inst:RemoveEventCallback("emodelta", self.onemodelta, self.owner)
            self.onemodelta = nil
        end
    end

    local emo_ptx = -120
    local emo_pty = 20
    if owner.prefab == "musha" then -- musha
        emo_ptx = -120
        emo_pty = 70
    elseif owner.prefab == "homura_1" then --晓美焰
        emo_ptx = -120
        emo_pty = -30
    elseif owner.prefab == "wolfgang" then
        emo_ptx = -80
        emo_pty = -50
    end
    if KnownModIndex:IsModEnabledAny("workshop-376333686") then
        emo_ptx = -125
        emo_pty = 35
        if owner.prefab == "musha" then -- musha
            emo_ptx = -120
            emo_pty = 70
        end
    else
        if owner.prefab == "musha" then -- musha
            emo_ptx = -100
            emo_pty = 55
        -- elseif owner.prefab == "homura_1" then --晓美焰
        --     emo_ptx = -120
        --     emo_pty = -30
        elseif owner.prefab == "wolfgang" then
            emo_ptx = -80
            emo_pty = -50
        end
    end
    self.ndnr_emo = self:AddChild(EmoBadge(owner))
    self.ndnr_emo:SetPosition(emo_ptx, emo_pty, 0)

    local _ShowStatusNumbers = self.ShowStatusNumbers
    function self:ShowStatusNumbers()
        _ShowStatusNumbers(self)
        self.ndnr_emo.num:Show()
    end
    local _HideStatusNumbers = self.HideStatusNumbers
    function self:HideStatusNumbers()
        _HideStatusNumbers(self)
        self.ndnr_emo.num:Hide()
    end
    local _SetGhostMode = self.SetGhostMode
    function self:SetGhostMode(ghostmode)
        _SetGhostMode(self, ghostmode)
        if ghostmode then
            self.ndnr_emo:Hide()
            self.ndnr_emo:StopWarning()
        else
            self.ndnr_emo:Show()
        end

        if self.emomodetask ~= nil then
            self.emomodetask:Cancel()
        end
        self.emomodetask = self.inst:DoStaticTaskInTime(0, ghostmode and OnSetGhostEmoMode or OnSetPlayerEmoMode, self)
    end

    function self:SetEmoPercent(pct)
        self.ndnr_emo:SetPercent(pct, self.owner.replica.ndnr_emo:Max())

        if pct >= 0.1 then
            self.ndnr_emo:StopWarning()
        else
            self.ndnr_emo:StartWarning()
        end
    end

    function self:EmoDelta(data)
        self:SetEmoPercent(data.newpercent)
        if self.ndnr_emo ~= nil and self.ndnr_emo.EmoDelta then
            self.ndnr_emo:EmoDelta(data)
        else
            if not data.overtime then
                if data.newpercent > data.oldpercent then
                    self.ndnr_emo:PulseRed()
                    TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/hunger_up")
                elseif data.newpercent < data.oldpercent then
                    TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/hunger_down")
                    self.ndnr_emo:PulseGreen()
                end
            end
        end
    end
end)
]]