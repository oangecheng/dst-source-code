local function onstaying(self)
    if self.staying then
        self.inst:AddTag("bookstaying")
    else
        self.inst:RemoveTag("bookstaying")
    end
end

local SoulContracts = Class(function(self, inst)
    self.inst = inst
    self.staying = true

    self.inst.components.follower.OnChangedLeader = function(inst, new_leader, prev_leader)
        if new_leader == nil then
            self.staying = true
        else
            self.staying = false
        end
    end
end,
nil,
{
    staying = onstaying
})

function SoulContracts:ReturnSouls(doer)
    if
        doer.components.inventory ~= nil and doer.components.inventory.isopen and
        self.inst.components.finiteuses ~= nil and self.inst.components.finiteuses:GetUses() > 0
    then
        local souls = doer.components.inventory:FindItems(function(item)
            return item.prefab == "wortox_soul"
        end)
        local soulscount = 0
        for i, v in ipairs(souls) do
            soulscount = soulscount +
                (v.components.stackable ~= nil and v.components.stackable:StackSize() or 1)
        end

        if soulscount >= TUNING.WORTOX_MAX_SOULS then --携带灵魂已达到上限，直接释放这个灵魂
            if self.inst._SoulHealing ~= nil then
                self.inst._SoulHealing(doer)
                self.inst.components.finiteuses:Use(1)
            end
        else
            soulscount = TUNING.WORTOX_MAX_SOULS - soulscount
            soulscount = math.ceil( math.min(soulscount, self.inst.components.finiteuses:GetUses()) )
            local soul = SpawnPrefab("wortox_soul")
            if soul ~= nil then
                if soulscount > 1 and soul.components.stackable ~= nil then
                    soul.components.stackable:SetStackSize(soulscount)
                end
            end
            doer.components.inventory:GiveItem(soul, nil, doer:GetPosition())
            self.inst.components.finiteuses:Use(soulscount)
        end
    end

    return true
end

local function SetSoulFx(inst)
    local fx = SpawnPrefab(inst._dd and inst._dd.fx or "wortox_soul_in_fx")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:Setup(inst)
end
local function FindItemWithoutContainer(inst, fn)
    local inventory = inst.components.inventory

    for k,v in pairs(inventory.itemslots) do
        if v and fn(v) then
            return v
        end
    end
    if inventory.activeitem and fn(inventory.activeitem) then
        return inventory.activeitem
    end
end
function SoulContracts:TriggerStaying(trystay, doer)
    if trystay then
        if --只有它的跟随对象才有权让它停止跟随
            doer ~= nil and
            self.inst.components.follower:GetLeader() ~= nil and
            self.inst.components.follower:GetLeader() ~= doer
        then
            return false, "NORIGHT"
        end

        self.staying = true
        self.inst.components.follower:StopFollowing()
        self.inst.components.locomotor:StopMoving()
    elseif doer ~= nil then --要跟随，肯定得有一个跟随对象
        if --它有跟随对象时，无法切换跟随
            self.inst.components.follower:GetLeader() ~= nil and
            self.inst.components.follower:GetLeader() ~= doer
        then
            return false, "NORIGHT"
        end

        if doer.components.inventory ~= nil then
            --寻找包里的其他契约书
            local otherbook = FindItemWithoutContainer(doer, function(item)
                if item:HasTag("soulcontracts") and item ~= self.inst then
                    return true
                end
                return false
            end)
            --每个玩家最多拥有1本契约书
            if otherbook ~= nil then
                return false, "ONLYONE"
            end
        end

        self.staying = false
        if doer.components.leader ~= nil then
            doer.components.leader:RemoveFollowersByTag("soulcontracts") --清除其他所有契约的跟随
            doer.components.leader:AddFollower(self.inst)
        else
            self.inst.components.follower:SetLeader(doer)
        end
    end

    SetSoulFx(self.inst)

    return true
end

function SoulContracts:PickUp(doer)
    if --只有当前跟随对象才有权捡起它
        self.inst.components.follower:GetLeader() ~= nil and
        self.inst.components.follower:GetLeader() ~= doer
    then
        return false, "NORIGHT"
    end

    --反正进入物品栏时就要检查一遍，这里虽然提前检查更好，但是物品栏里的检查更通用
    -- --寻找包里的其他契约书
    -- local otherbook = FindItemWithoutContainer(doer, function(item)
    --     if item:HasTag("soulcontracts") and item ~= self.inst then
    --         return true
    --     end
    --     return false
    -- end)
    -- --每个玩家最多拥有1本契约书
    -- if otherbook ~= nil then
    --     return false, "ONLYONE"
    -- end

    doer:PushEvent("onpickupitem", { item = self.inst })
    doer.components.inventory:GiveItem(self.inst, nil, self.inst:GetPosition())
    return true
end

function SoulContracts:GiveSoul(doer, soul)
    if self.inst.components.finiteuses ~= nil then
        if self.inst.components.finiteuses:GetPercent() >= 1 then --已经满了，直接释放一个灵魂
            if self.inst._SoulHealing ~= nil then
                self.inst._SoulHealing(doer or self.inst)
            end
        else --没有满，灵魂+1
            self.inst.components.finiteuses:SetUses(self.inst.components.finiteuses:GetUses() + 1)
        end
    end
    SetSoulFx(self.inst)

    if soul.components.stackable ~= nil then
        soul.components.stackable:Get(1):Remove()
    else
        soul:Remove()
    end

    return true
end

return SoulContracts
