--时空风暴观察者
local Medal_SpacetimestormWatcher = Class(function(self, inst)
    self.inst = inst

    self.spacetimestormlevel = 0
    self.spacetimestormspeedmult = TUNING_MEDAL.SPACETIMESTORM_SPEED_MOD--在时空风暴中的移速倍率(默认0.4倍)
    self.delay = nil

    if TheWorld.net.components.medal_spacetimestorms ~= nil then
        inst:ListenForEvent("ms_stormchanged", function(src, data) self:ToggleSpacetimestorms(data) end, TheWorld)
        self:ToggleSpacetimestorms({setting=false})
    end
    
end)

local function UpdateSpacetimestormWalkSpeed(inst)
    inst.components.medal_spacetimestormwatcher:UpdateSpacetimestormWalkSpeed()
end
--添加事件监听
local function AddSpacetimestormWalkSpeedListeners(inst)
    inst:ListenForEvent("gogglevision", UpdateSpacetimestormWalkSpeed)--眼镜滤镜(各种护目措施)
    inst:ListenForEvent("ghostvision", UpdateSpacetimestormWalkSpeed)--鬼魂滤镜(玩家GG)
    inst:ListenForEvent("mounted", UpdateSpacetimestormWalkSpeed)--开始骑行
    inst:ListenForEvent("dismounted", UpdateSpacetimestormWalkSpeed)--停止骑行
end
--移除事件监听
local function RemoveSpacetimestormWalkSpeedListeners(inst)
    inst:RemoveEventCallback("gogglevision", UpdateSpacetimestormWalkSpeed)
    inst:RemoveEventCallback("ghostvision", UpdateSpacetimestormWalkSpeed)
    inst:RemoveEventCallback("mounted", UpdateSpacetimestormWalkSpeed)
    inst:RemoveEventCallback("dismounted", UpdateSpacetimestormWalkSpeed)
    inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "spacetimestorm")
end

function Medal_SpacetimestormWatcher:OnRemoveFromEntity()
    self:ToggleSpacetimestorms({setting=false})
end
--同步玩家在时空风暴中的状态
function Medal_SpacetimestormWatcher:ToggleSpacetimestorms(data)
    if data.stormtype==nil or data.stormtype == STORM_TYPES.MEDAL_SPACETIMESTORM then
        if data.setting then
            if self.spacetimestormspeedmult < 1 then
                AddSpacetimestormWalkSpeedListeners(self.inst)
            end
            self:UpdateSpacetimestormLevel()
        else
            if self.spacetimestormspeedmult < 1 then
                RemoveSpacetimestormWalkSpeedListeners(self.inst)
            end
        end
    end
end
--设定玩家在风暴中的移动倍率,比如像伍迪变身后就不会受风暴影响了
function Medal_SpacetimestormWatcher:SetSpacetimestormSpeedMultiplier(mult)
    mult = math.clamp(mult, 0, 1)
    if self.spacetimestormspeedmult ~= mult then
        if mult < 1 then
            if self.spacetimestormspeedmult >= 1 then
                AddSpacetimestormWalkSpeedListeners(self.inst)
            end
            self.spacetimestormspeedmult = mult
            self:UpdateSpacetimestormWalkSpeed()
        else
            self.spacetimestormspeedmult = 1
            RemoveSpacetimestormWalkSpeedListeners(self.inst)
        end
    end
end
--更新风暴级别
function Medal_SpacetimestormWatcher:UpdateSpacetimestormLevel()
    self:UpdateSpacetimestormWalkSpeed()
end
--更新玩家在时空风暴中的移动速度
function Medal_SpacetimestormWatcher:UpdateSpacetimestormWalkSpeed()
    local level = self:GetSpacetimeStormLevel()--获取风暴级别
    if level and self.spacetimestormspeedmult < 1 then

        if level < TUNING.SANDSTORM_FULL_LEVEL or--级别低于0.7 或
            self.inst.components.playervision:HasGoggleVision() or--玩家有眼镜滤镜 或
            self.inst.components.playervision:HasGhostVision() or--玩家有鬼魂滤镜 或
            self.inst.components.rider:IsRiding() then--玩家骑着牛
            self.inst.components.locomotor:RemoveExternalSpeedMultiplier(self.inst, "spacetimestorm")--不减速
        else--否则减速
            self.inst.components.locomotor:SetExternalSpeedMultiplier(self.inst, "spacetimestorm", self.spacetimestormspeedmult)
        end
    end
    self.inst:PushEvent("spacetimestormlevel",{level = level})--目前好像没啥卵用
end
--获取风暴级别
function Medal_SpacetimestormWatcher:GetSpacetimeStormLevel()
    if self.inst.components.stormwatcher then
        return self.inst.components.stormwatcher.stormlevel
    end
    return nil
end

return Medal_SpacetimestormWatcher