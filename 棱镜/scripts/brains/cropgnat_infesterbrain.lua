require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/chaseandattack"
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
        (inst.infesttarget.components.health == nil or inst.infesttarget.components.health:IsDead()) or --已经死掉
        inst:GetDistanceSqToInst(inst.infesttarget) > 1225 --距离超过35*35
    then
        if inst.infesttarget ~= nil then
            inst.infesttarget.infester = nil --清除以前的标记
        end

        inst.infesttarget = FindEntity(inst, 16, function(guy)
            return GetValid(guy.infester) == nil and inst.components.combat:CanTarget(guy)
        end, {"character", "_combat", "_health"}, {"NOCLICK", "INLIMBO", "playerghost", "largecreature", "nognatinfest"}, nil)

        if inst.infesttarget ~= nil then
            inst.infesttarget.infester = inst --做个标记，一个虫群只能认领一个侵扰对象
        end
    end

    return inst.lighttarget == nil and inst.infesttarget or nil
end

local function GetCombatTarget(inst)
    --光源对象优先进行判断
    if inst.lighttarget ~= nil then
        --光源对象就是侵扰对象，或者光源对象可攻击，并且攻击对象只能是有"character"标签的才能攻击
        if
            inst.infesttarget == inst.lighttarget or
            (inst.lighttarget:HasTag("character") and inst.components.combat:CanTarget(inst.lighttarget))
        then
            inst.components.combat:SetTarget(inst.lighttarget)
            --一般来说光源是附着在其他对象上的，这里需要进一步判断
        else
            --先判断实体的附主
            local grandowner = inst.lighttarget.entity ~= nil and inst.lighttarget.entity:GetParent()
            --再判断物品的所有者
            if grandowner == nil and inst.lighttarget.components.inventoryitem ~= nil then
                grandowner = inst.lighttarget.components.inventoryitem:GetGrandOwner()
            end

            if grandowner ~= nil and grandowner:HasTag("character") and inst.components.combat:CanTarget(grandowner) then
                inst.components.combat:SetTarget(grandowner)
            else
                --光源对象完全不符合攻击条件，但是又有光源对象，那就不攻击了，老老实实待在光源附近吧
                inst.components.combat:SetTarget(nil)
            end
        end
    --没有光源对象时才能攻击侵扰对象
    else
        inst.components.combat:SetTarget(inst.infesttarget)
    end
    return inst.components.combat.target
end

------------

local function StandStart(inst)
    --这里是一次脑子运转总的数据更新操作，其他函数就只判断数据了，不再重复进行更新操作
    GetLightTarget(inst)
    GetInfestTarget(inst)
    GetCombatTarget(inst)

    return inst.sg and inst.sg:HasStateTag("landing") and not (inst.components.hauntable and inst.components.hauntable.panic)
end

local function StandKeep(inst)
    --睡觉中也要不断刷新数据，因为StandStart只在第一次执行就不会再执行
    GetLightTarget(inst)
    GetInfestTarget(inst)
    GetCombatTarget(inst)

    return inst.sg and inst.sg:HasStateTag("landing") and not (inst.components.hauntable and inst.components.hauntable.panic)
end

local function CanChaseAttack(inst) --攻击冷却已经过，有攻击对象时才可以追着打
    return inst.components.combat.target ~= nil and not inst.components.combat:InCooldown()
end

local function GetFollowTarget(inst) --跟随光源对象，或者侵扰对象
    return GetValid(inst.lighttarget) or GetValid(inst.infesttarget)
end

------------

local function CanWanderWithLight(inst) --有光源对象，没攻击对象时，离光源对象够近时才开始徘徊
    return inst.components.combat.target == nil and GetValid(inst.lighttarget) ~= nil
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

local CropGnat_InfesterBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function CropGnat_InfesterBrain:OnStart()
    local root =
        PriorityNode(
        {
            WhileNode(function() return self.inst.components.hauntable and self.inst.components.hauntable.panic end, "PanicHaunted", Panic(self.inst)),
            -- WhileNode(function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),

            --睡觉ing
            StandStill(self.inst, StandStart, StandKeep),

            --不能让攻击占主导行为
            IfNode(function() return CanChaseAttack(self.inst) end, "ChaseAndAttack",
                ChaseAndAttack(self.inst, SpringCombatMod(120), 35, 1) --最多攻击次数为1，表示攻击1次之后就从该节点出来，让其他节点也能发挥作用
            ),

            --在光源附近徘徊
            WhileNode(function() return CanWanderWithLight(self.inst) end, "WanderAroundLight",
                Wander(self.inst, GetLightPos, GetLightRadius)
            ),
            -- IfNode(function() return self.inst.lighttarget ~= nil and self.inst.components.combat.target == nil end, "FindALight",
            --     FindLight(self.inst, 16, SafeLightDist)
            -- ),

            --跟随侵扰对象，不过，也要优先跟随光源对象
            Follow(self.inst, function() return GetFollowTarget(self.inst) end, 0, 0.2, 0.2),

            --没有侵扰对象时才会徘徊
            IfNode(function() return GetValid(self.inst.infesttarget) == nil end, "WanderAroundHome",
                Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, 20)
            )
        }, 0.5)

    self.bt = BT(self.inst, root)
end

function CropGnat_InfesterBrain:OnInitializationComplete()
    self.inst.components.knownlocations:RememberLocation("home", Point(self.inst.Transform:GetWorldPosition()))
end

return CropGnat_InfesterBrain
