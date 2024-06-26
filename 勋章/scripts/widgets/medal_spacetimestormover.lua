local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"

-- local BGCOLOR = { 156/255, 132/255, 75/255, 255/255 }
-- local BGCOLOR = { 95/255, 0/255, 167/255, 255/255 }
local BGCOLOR = { 0/255, 0/255, 0/255, 255/255 }

local function CreateLetterbox()
    local root = Widget("letterbox_root")
    root:SetVAnchor(ANCHOR_MIDDLE)
    root:SetHAnchor(ANCHOR_MIDDLE)
    root:SetScaleMode(SCALEMODE_PROPORTIONAL)

    local _scrnw, _scrnh
    local aspect = RESOLUTION_X / RESOLUTION_Y
    local span = 3 --covers 3 screens in either dimension before needing letterbox
    local maxw = RESOLUTION_X * span * MAX_FE_SCALE
    local maxh = RESOLUTION_Y * span * MAX_FE_SCALE
    local tint = { unpack(BGCOLOR) }

    root.SetMultColour = function(root, r, g, b, a)
        tint[1] = r
        tint[2] = g
        tint[3] = b
        tint[4] = a
        if root.left ~= nil then
            root.left:SetTint(r, g, b, a)
        end
        if root.right ~= nil then
            root.right:SetTint(r, g, b, a)
        end
        if root.top ~= nil then
            root.top:SetTint(r, g, b, a)
        end
        if root.bottom ~= nil then
            root.bottom:SetTint(r, g, b, a)
        end
    end

    root.OnShow = function()
        root:StartUpdating()
        root:OnUpdate()
    end

    root.OnHide = root.StopUpdating

    root.OnUpdate = function()
        local scrnw, scrnh = TheSim:GetScreenSize()
        if _scrnw == scrnw and _scrnh == scrnh then
            return
        end

        _scrnw = scrnw
        _scrnh = scrnh

        local scrnaspect = scrnw / scrnh
        local hbars = scrnw > maxw or scrnaspect > aspect * span
        local vbars = scrnh > maxh or scrnaspect * span < aspect

        if hbars then
            if root.left == nil then
                root.left = root:AddChild(Image("images/global.xml", "square.tex"))
                root.left:SetTint(unpack(tint))
                root.left:SetVRegPoint(ANCHOR_MIDDLE)
                root.left:SetHRegPoint(ANCHOR_RIGHT)
                root.left:SetPosition(-.5 * RESOLUTION_X * span, 0)
            end
            if root.right == nil then
                root.right = root:AddChild(Image("images/global.xml", "square.tex"))
                root.right:SetTint(unpack(tint))
                root.right:SetVRegPoint(ANCHOR_MIDDLE)
                root.right:SetHRegPoint(ANCHOR_LEFT)
                root.right:SetPosition(.5 * RESOLUTION_X * span, 0)
            end
        else
            if root.left ~= nil then
                root.left:Kill()
                root.left = nil
            end
            if root.right ~= nil then
                root.right:Kill()
                root.right = nil
            end
        end
        if vbars then
            if root.top == nil then
                root.top = root:AddChild(Image("images/global.xml", "square.tex"))
                root.top:SetTint(unpack(tint))
                root.top:SetVRegPoint(ANCHOR_BOTTOM)
                root.top:SetHRegPoint(ANCHOR_MIDDLE)
                root.top:SetPosition(0, .5 * RESOLUTION_Y * span)
            end
            if root.bottom == nil then
                root.bottom = root:AddChild(Image("images/global.xml", "square.tex"))
                root.bottom:SetTint(unpack(tint))
                root.bottom:SetVRegPoint(ANCHOR_TOP)
                root.bottom:SetHRegPoint(ANCHOR_MIDDLE)
                root.bottom:SetPosition(0, -.5 * RESOLUTION_Y * span)
            end
        else
            if root.top ~= nil then
                root.top:Kill()
                root.top = nil
            end
            if root.bottom ~= nil then
                root.bottom:Kill()
                root.bottom = nil
            end
        end

        if hbars and vbars then
            local w, h = root.left:GetSize()
            local scalex = (scrnw - maxw) / (maxw * 2) * RESOLUTION_X * span / w
            local scaley = scrnh / maxh * RESOLUTION_Y * span / h
            root.left:SetScale(scalex, scaley)
            root.right:SetScale(scalex, scaley)
            scalex = RESOLUTION_X * span / w
            scaley = (scrnh - maxh) / (maxh * 2) * RESOLUTION_Y * span / h
            root.top:SetScale(scalex, scaley)
            root.bottom:SetScale(scalex, scaley)
        elseif hbars then
            local w, h = root.left:GetSize()
            local scalex = (scrnw / (scrnh * aspect * span) - 1) * .5 * RESOLUTION_X * span / w
            local scaley = RESOLUTION_Y / h
            root.left:SetScale(scalex, scaley)
            root.right:SetScale(scalex, scaley)
        elseif vbars then
            local w, h = root.top:GetSize()
            local scalex = RESOLUTION_X / w
            local scaley = (scrnh * aspect / (scrnw * span) - 1) * .5 * RESOLUTION_Y * span / h
            root.top:SetScale(scalex, scaley)
            root.bottom:SetScale(scalex, scaley)
        end
    end

    return root
end

local Medal_SpacetimestormOver = Class(Widget, function(self, owner, dustlayer)
    self.owner = owner
    Widget._ctor(self, "Medal_SpacetimestormOver")
    self:UpdateWhilePaused(false)

    self:SetClickable(false)

    self.minscale = .9 --min scale supported by art size
    self.maxscale = 1.20625 --defaults to 1 based on camera [15, 50] (default 30)

    self.bg = self:AddChild(Widget("blind_root"))
    self.bg:SetHAnchor(ANCHOR_MIDDLE)
    self.bg:SetVAnchor(ANCHOR_MIDDLE)
    self.bg:SetScaleMode(SCALEMODE_PROPORTIONAL)
    self.bg = self.bg:AddChild(UIAnim())
    self.bg:GetAnimState():SetBank("sand_over")
    self.bg:GetAnimState():SetBuild("medal_spacetimestorm_over")
    self.bg:GetAnimState():PlayAnimation("blind_loop")--, true)
    self.bg:GetAnimState():AnimateWhilePaused(false)

    self.letterbox = self:AddChild(CreateLetterbox())

    self.dust = dustlayer
    self.dust:Hide()

    self.ambientlighting = TheWorld.components.ambientlighting
    self.camera = TheCamera
    self.brightness = 1

    self.blind = 1
    self.blindto = 1
    self.blindtime = .2

    self.fade = 0
    self.fadeto = 0
    self.fadetime = 3

    self.alpha = 0

    self:Hide()

    if owner ~= nil then
        self.inst:ListenForEvent("gogglevision", function(owner, data) self:BlindTo(data.enabled and 0 or 1, TheFrontEnd:GetFadeLevel() >= 1) end, owner)
        self.inst:ListenForEvent("stormlevel", function(owner, data)
            if data.stormtype == STORM_TYPES.MEDAL_SPACETIMESTORM then
                self:FadeTo(data.level, TheFrontEnd:GetFadeLevel() >= 1)
            else
                self:FadeTo(0, TheFrontEnd:GetFadeLevel() >= 1)
            end
        end, owner)
        if owner.components.playervision ~= nil and
            owner.components.playervision:HasGoggleVision() then
            self:BlindTo(0, true)
        end
        if owner.GetStormLevel ~= nil then
            self:FadeTo(owner:GetStormLevel(), true)
        end
    end
end)

function Medal_SpacetimestormOver:BlindTo(blindto, instant)
    blindto = math.clamp(blindto, 0, 1)
    if self.blindto ~= blindto then
        self.blindto = blindto
        if self.fade <= 0 and self.fadeto <= 0 then
            self.blind = blindto
        elseif instant and self.blind ~= blindto then
            self.blind = blindto
            self:ApplyLevels()
        end
        if self.dust.shown then
            -- TheFocalPoint.SoundEmitter:SetParameter("sandstorm", "intensity", blindto < 1 and 0 or .5)
            TheFocalPoint.SoundEmitter:SetParameter("moonstorm", "intensity", blindto < 1 and 0 or .5)
        end
    end
end

function Medal_SpacetimestormOver:FadeTo(fadeto, instant)
    if self.owner and self.owner:GetStormLevel() == 0 then
        fadeto = 0
    end

    fadeto = math.clamp(fadeto, 0, 1)
    if self.fadeto ~= fadeto then
        if self.fadeto <= 0 then
            self:StartUpdating()
        elseif fadeto <= 0 and self.fade <= 0 then
            self:StopUpdating()
        end
        self.fadeto = fadeto
    end
    if instant and (fadeto > 0 or self.fade > 0) then
        self:OnUpdate(math.huge)
    end
end

function Medal_SpacetimestormOver:ApplyLevels()
    self.alpha = math.max(0, self.fade * 1.5 - .5) * self.blind
    if self.alpha > 0 then
        local c = 0--self.brightness--这里把饱和度拉满
        self.bg:GetAnimState():SetMultColour(c, c, c, self.alpha)
        self.letterbox:SetMultColour(BGCOLOR[1] * c, BGCOLOR[2] * c, BGCOLOR[3] * c, BGCOLOR[4] * self.alpha)
        if not self.shown then
            self:Show()
        end
    elseif self.shown then
        self:Hide()
    end

    if self.fade > 0 then
        local k = Lerp(1, .7, self.brightness)
        local f = self.alpha * (1 - k) + math.min(1, self.fade * 1.5) * k
        local c = .15 + .85 * self.brightness
        self.dust:GetAnimState():SetMultColour(c, c, c, f)
        if not self.dust.shown then
            self.dust:Show()
            -- TheFocalPoint.SoundEmitter:PlaySound("dontstarve/common/together/sandstorm", "sandstorm", self.fade)
            -- TheFocalPoint.SoundEmitter:SetParameter("sandstorm", "intensity", self.blindto < 1 and 0 or .5)
            TheMixer:PushMix("moonstorm")
            TheFocalPoint.SoundEmitter:PlaySound("moonstorm/common/moonstorm/LP", "moonstorm", self.fade)
            TheFocalPoint.SoundEmitter:SetParameter("moonstorm", "intensity", self.blindto < 1 and 0 or .5)
        else
            -- TheFocalPoint.SoundEmitter:SetVolume("sandstorm", self.fade)
            TheFocalPoint.SoundEmitter:SetVolume("moonstorm", self.fade)
        end
    elseif self.dust.shown then
        self.dust:Hide()
        -- TheFocalPoint.SoundEmitter:KillSound("sandstorm")
        TheMixer:PopMix("moonstorm")
        TheFocalPoint.SoundEmitter:KillSound("moonstorm")
    end
end

function Medal_SpacetimestormOver:OnUpdate(dt)
    if TheNet:IsServerPaused() then return end

    local dirty = false

    if self.blindto < self.blind then
        self.blind = math.max(self.blindto, self.blind - dt / self.blindtime)
        dirty = true
    elseif self.blindto > self.blind then
        self.blind = math.min(self.blindto, self.blind + dt / self.blindtime)
        dirty = true
    end

    if self.fadeto < self.fade then
        self.fade = math.max(self.fadeto, self.fade - dt / self.fadetime)
        dirty = true
    elseif self.fadeto > self.fade then
        self.fade = math.min(self.fadeto, self.fade + dt / self.fadetime)
        dirty = true
    end

    if self.ambientlighting ~= nil then
        local brightness = math.clamp(self.ambientlighting:GetVisualAmbientValue() * 1.4, 0, 1)
        if brightness < self.brightness then
            self.brightness = math.max(brightness, self.brightness - dt)
            dirty = true
        elseif brightness > self.brightness then
            self.brightness = math.min(brightness, self.brightness + dt)
            dirty = true
        end
    end

    if dirty then
        self:ApplyLevels()
    end

    if self.shown then
        local s = 1
        if self.camera ~= nil then
            s = Remap(math.clamp(self.camera:GetDistance(), self.camera.mindist, self.camera.maxdist), self.camera.mindist, self.camera.maxdist, 1, 0)
            s = self.minscale + (self.maxscale - self.minscale) * s * s
        end
        s = s * (3 - self.alpha * 2)
        self.bg:SetScale(s, s, s)
    end

    if self.fade <= 0 and self.fadeto <= 0 then
        self.blind = self.blindto
        self:StopUpdating()
    end
end

return Medal_SpacetimestormOver
