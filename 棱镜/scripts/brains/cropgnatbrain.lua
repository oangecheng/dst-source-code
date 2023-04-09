require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/standstill"
-- require "behaviours/findlight"
require "behaviours/follow"

local function GetValid(target)
    if target ~= nil and target:IsValid() then
        return target
    end
    return nil
end

local function GetLightTarget(inst)
    if TheWorld.state.isday or TheWorld.state.isfullmoon then --白天或月圆夜，肯定不需要寻求光源
        inst.lighttarget = nil
    elseif
        inst.lighttarget == nil or --非白天，必定需要找光源
        not inst.lighttarget:IsValid() or --无效的
        not inst.lighttarget.entity:IsVisible() or --不可见的
        inst.lighttarget:IsInLimbo() or --被装起来的
        not (inst.lighttarget:HasTag("daylight") or inst.lighttarget:HasTag("lightsource")) --不再是光源
    then
        inst.lighttarget = FindEntity(inst, 16, nil, nil, { "INLIMBO" }, { "daylight", "lightsource" })
    end

    return inst.lighttarget
end

local function GetInfestTarget(inst)
    if
        inst.infesttarget == nil or --没有侵扰对象
        not inst.infesttarget:IsValid() or --无效的
        not inst.infesttarget.entity:IsVisible() or --不可见的
        inst.infesttarget:IsInLimbo() or --被装起来的
        inst.infesttarget:HasTag("nognatinfest") or --已经不能被侵扰了
        inst.infesttarget:HasTag("withered") or --枯萎了
        inst.infesttarget:HasTag("barren") or --贫瘠了
        inst:GetDistanceSqToInst(inst.infesttarget) > 1225 --距离超过35*35
    then
        if inst.infesttarget ~= nil then
            inst.infesttarget.infester = nil --清除以前的标记
        end

        inst.infesttarget = FindEntity(inst, 16, function(guy)
                if GetValid(guy.infester) == nil then --还未被虫群认领
                    return guy.components.perennialcrop ~= nil --多年生作物
                            or guy.components.perennialcrop2 ~= nil --异种植物
                            or guy.components.pickable ~= nil --可采摘植物
                end
                return false
            end,
            nil, { "FX", "INLIMBO", "nognatinfest", "withered", "barren" },
            { "crop_legion", "crop2_legion", "witherable" }
        )

        if inst.infesttarget ~= nil then
            inst.infesttarget.infester = inst --做个标记，一个虫群只能认领一个侵扰对象
        end
    end

    return inst.lighttarget == nil and inst.infesttarget or nil
end

------------

--把对农作物的侵扰判断与执行操作放到脑子里，是因为脑子运行是周期性的，然后在远离玩家时也会自动停止运行
--刚好符合侵扰机制的所有要求
local function TryToInfest(inst)
    --timer计时结束，可以进行侵扰判断
    if inst.components.timer ~= nil and not inst.components.timer:TimerExists("infest_cd") then
        --与侵扰作物距离很近，可以进行侵扰操作
        if GetValid(inst.infesttarget) ~= nil and inst:GetDistanceSqToInst(inst.infesttarget) <= 0.25 then
            inst:PushEvent("doinfest") --向sg发出侵扰事件
        end
    end
end

------------

local function StandStart(inst)
    --这里是一次脑子运转总的数据更新操作，其他函数就只判断数据了，不再重复进行更新操作
    GetLightTarget(inst)
    GetInfestTarget(inst)

    if inst.sg and inst.sg:HasStateTag("landing") and not (inst.components.hauntable and inst.components.hauntable.panic) then
        return true
    else
        TryToInfest(inst) --只有没睡觉时才会试着侵扰
        return false
    end
end

local function StandKeep(inst)
    --睡觉中也要不断刷新数据，因为StandStart只在第一次执行就不会再执行
    GetLightTarget(inst)
    GetInfestTarget(inst)

    return inst.sg and inst.sg:HasStateTag("landing") and not (inst.components.hauntable and inst.components.hauntable.panic)
end

local function GetFollowTarget(inst) --跟随光源对象，或者侵扰对象
    return GetValid(inst.lighttarget) or GetValid(inst.infesttarget)
end

------------

local function CanWanderWithLight(inst) --有光源对象，没攻击对象时，离光源对象够近时才开始徘徊
    return GetValid(inst.lighttarget) ~= nil
            and inst:GetDistanceSqToInst(inst.lighttarget) <= 0.64 --GetDistanceSqToInst会判断参数和自身的实体有效性，无效的话会崩溃
end

local function GetLightPos(inst)
    return GetValid(inst.lighttarget) ~= nil and Vector3(inst.lighttarget.Transform:GetWorldPosition()) or nil
end

local function GetLightRadius(inst)
    return (GetValid(inst.lighttarget) ~= nil and inst.lighttarget.Light ~= nil) and inst.lighttarget.Light:GetCalculatedRadius() or 1
end

-- local function SafeLightDist(inst, target)
--     if inst.lighttarget ~= target then
--         inst.lighttarget = target
--     end

--     return 0.2
-- end

---------------------------------------------------------

local CropGnatBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function CropGnatBrain:OnStart()
    local root =
        PriorityNode(
        {
            WhileNode(function() return self.inst.components.hauntable and self.inst.components.hauntable.panic end, "PanicHaunted", Panic(self.inst)),          
            -- WhileNode(function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),

            --睡觉ing
            StandStill(self.inst, StandStart, StandKeep),

            --在光源附近徘徊
            WhileNode(function() return CanWanderWithLight(self.inst) end, "WanderAroundLight",
                Wander(self.inst, GetLightPos, GetLightRadius)
            ),
            -- IfNode(function() return self.inst.lighttarget ~= nil end, "FindALight",
            --     FindLight(self.inst, 16, SafeLightDist)
            -- ),

            --跟随侵扰对象，不过，也要优先跟随光源对象
            Follow(self.inst, function() return GetFollowTarget(self.inst) end, 0, 0.2, 0.2),

            --没有侵扰对象时才会徘徊
            IfNode(function() return GetValid(self.inst.infesttarget) == nil end, "WanderAroundHome",
                Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, 20)
            )
        }, 1)

    self.bt = BT(self.inst, root)
end

function CropGnatBrain:OnInitializationComplete()
    self.inst.components.knownlocations:RememberLocation("home", Point(self.inst.Transform:GetWorldPosition()))
end

return CropGnatBrain
