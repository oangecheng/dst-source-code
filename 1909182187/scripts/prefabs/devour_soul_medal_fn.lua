local wortox_soul_common = require("prefabs/wortox_soul_common")
--是否是有效的受害者(有灵魂并且已经死了)
local function IsValidVictim(victim)
    return wortox_soul_common.HasSoul(victim) and victim.components.health and victim.components.health:IsDead()
end
--清除定时器
local function OnRestoreSoul(victim)
    victim.nosoultask = nil
end
--生成一个灵魂给目标
local function GiveSouls(inst, num, pos)
    local soul = SpawnPrefab("wortox_soul")
    if soul.components.stackable ~= nil then
        soul.components.stackable:SetStackSize(num)
    end
    inst.components.inventory:GiveItem(soul, nil, pos)
end
--生成单个灵魂(坐标,受害者,是否直接算作掉落,是否是万物之灵)
local function SpawnSoulAt(x, y, z, victim, drop, universe)
    if drop then
		local soul = SpawnPrefab("wortox_soul")
		soul.Transform:SetPosition(x, y, z)
		soul.components.inventoryitem:OnDropped(true)
	elseif universe then
        local fx = SpawnPrefab("medal_krampus_soul_spawn")
		fx.Transform:SetPosition(x, y, z)
		fx:Setup(victim)
    else
		local fx = SpawnPrefab("wortox_soul_spawn")
		fx.Transform:SetPosition(x, y, z)
		fx:Setup(victim)
	end
end
--生成多个灵魂(受害者,灵魂数量,是否直接算作掉落,是否是万物之灵)
local function SpawnSoulsAt(victim, numsouls, drop, universe)
    local x, y, z = victim.Transform:GetWorldPosition()
    if numsouls == 2 then
        local theta = math.random() * 2 * PI--角度
        local radius = .4 + math.random() * .1--半径
		SpawnSoulAt(x + math.cos(theta) * radius, 0, z - math.sin(theta) * radius, victim, drop, universe)
        theta = GetRandomWithVariance(theta + PI, PI / 15)
        SpawnSoulAt(x + math.cos(theta) * radius, 0, z - math.sin(theta) * radius, victim, drop, universe)
    else
        if numsouls > 0 then
            local theta0 = math.random() * 2 * PI
            local dtheta = 2 * PI / numsouls
            local thetavar = dtheta / 10
            local theta, radius
            for i = 1, numsouls do
                theta = GetRandomWithVariance(theta0 + dtheta * i, thetavar)
                radius = 1.6 + math.random() * .4
                SpawnSoulAt(x + math.cos(theta) * radius, 0, z - math.sin(theta) * radius, victim, drop, universe)
            end
        end
    end
end
--实体发生掉落时触发的函数
local function OnEntityDropLoot(inst, data)
    local victim = data.inst
    if victim ~= nil and 
		(inst:HasTag("soulstealer") or inst.prefab=="medal_rage_krampus") and--玩家有噬灵者标签
        victim.nosoultask == nil and--定时器为空
        victim:IsValid() and
        (   victim == inst or--受害者是玩家自己 或者
            (   not inst.components.health:IsDead() and--玩家没死 并且
                IsValidVictim(victim) and --是有效受害者 并且
                inst:IsNear(victim, TUNING.WORTOX_SOULEXTRACT_RANGE)--玩家在受害者附近
            )
        ) then
        --防止掉落时有多个可吞噬灵魂的玩家在场时产生多个灵魂
        victim.nosoultask = victim:DoTaskInTime(5, OnRestoreSoul)
        --生成对应数量的灵魂
		SpawnSoulsAt(victim, wortox_soul_common.GetNumSouls(victim))
    end
end
--实体死亡时触发的函数
local function OnEntityDeath(inst, data)
    if data.inst ~= nil and data.inst.components.lootdropper == nil and (inst:HasTag("soulstealer") or inst.prefab=="medal_rage_krampus") then
        OnEntityDropLoot(inst, data)
    end
end
--生物在陷阱内死亡或者在陷阱内被捡起时死亡触发的函数
local function OnStarvedTrapSouls(inst, data)
    local trap = data.trap
    if trap ~= nil and
		inst:HasTag("soulstealer") and--玩家有噬灵者标签
        trap.nosoultask == nil and--定时器为空 并且
        (data.numsouls or 0) > 0 and--灵魂数量大于0 并且
        trap:IsValid() and --陷阱有效 并且
        inst:IsNear(trap, TUNING.WORTOX_SOULEXTRACT_RANGE) then--玩家在陷阱附近
        --防止有多个可吞噬灵魂的玩家在场时产生多个灵魂
        trap.nosoultask = trap:DoTaskInTime(5, OnRestoreSoul)
        SpawnSoulsAt(trap, data.numsouls)
    end
end

-- local function OnHarvestTrapSouls(inst, data)
--     if (data.numsouls or 0) > 0 then
--         GiveSouls(inst, data.numsouls, data.pos or inst:GetPosition())
--     end
-- end
--是否是灵魂
local function IsSoul(item)
    return item.prefab == "wortox_soul"
end
--获取堆叠数量
local function GetStackSize(item)
    return item.components.stackable ~= nil and item.components.stackable:StackSize() or 1
end
--灵魂列表降序排序
local function SortByStackSize(l, r)
    return GetStackSize(l) < GetStackSize(r)
end
--使用灵魂(玩家,灵魂列表,消耗数量,是否掉落)
local function UseSoul(inst,souls,count,isdrop)
	if count>0 then
		table.sort(souls, SortByStackSize)
        local pos = inst:GetPosition()
        for i, v in ipairs(souls) do
            local vcount = GetStackSize(v)
            if vcount < count then
                if isdrop then
					inst.components.inventory:DropItem(v, true, true, pos)
				else
					v:Remove()
				end
                count = count - vcount
            else
                if vcount == count then
                    if isdrop then
						inst.components.inventory:DropItem(v, true, true, pos)
					else
						v:Remove()
					end
                else
                    v = v.components.stackable:Get(count)
					if isdrop then
						v.Transform:SetPosition(pos:Get())  
						v.components.inventoryitem:OnDropped(true)
					else
						v:Remove()
					end
                end
                break
            end
        end
	end
end
--检查灵魂增加
local function CheckSoulsAdded(inst,medal)
	inst._checksoulstask = nil
	local souls = inst.components.inventory:FindItems(IsSoul)--获取玩家身上灵魂
    local count = 0--灵魂数量
	local consume = 0--消耗数量
	for i, v in ipairs(souls) do
        count = count + GetStackSize(v)
    end
	--计算勋章耐久
	if count>0 and medal.components.finiteuses and medal.components.finiteuses:GetPercent()<1 then
		local uses=medal.components.finiteuses:GetUses()
		local difference=TUNING_MEDAL.DEVOUR_SOUL_MEDAL.MAXUSES-medal.components.finiteuses:GetUses()
		uses=math.min(uses+count,TUNING_MEDAL.DEVOUR_SOUL_MEDAL.MAXUSES)--当前耐久
		consume=math.min(count,difference)--计算消耗量
		count=math.max(count-difference,0)--剩余灵魂数量
		UseSoul(inst,souls,consume,false)
		medal.components.finiteuses:SetUses(uses)--设置耐久
	end
	--多余的灵魂直接掉落
	if count>0 then
		souls = inst.components.inventory:FindItems(IsSoul)--获取玩家身上灵魂
		UseSoul(inst,souls,count,true)
	end
end

--谋杀获得灵魂
local function OnMurdered(inst, data)
    local victim = data.victim
    if victim ~= nil and
		inst:HasTag("soulstealer") and--玩家有噬灵者标签
        victim.nosoultask == nil and
        victim:IsValid() and
        (   not inst.components.health:IsDead() and
            wortox_soul_common.HasSoul(victim)
        ) then
        victim.nosoultask = victim:DoTaskInTime(5, OnRestoreSoul)
		SpawnSoulsAt(inst, wortox_soul_common.GetNumSouls(victim)*(data.stackmult or 1))
        -- GiveSouls(inst, wortox_soul_common.GetNumSouls(victim) * (data.stackmult or 1), inst:GetPosition())
    end
end
--收获陷阱
local function OnHarvestTrapSouls(inst, data)
    if (data.numsouls or 0) > 0 then
        SpawnSoulsAt(inst, data.numsouls)
        -- GiveSouls(inst, data.numsouls, data.pos or inst:GetPosition())
    end
end

return {
    OnEntityDropLoot = OnEntityDropLoot,
    OnEntityDeath = OnEntityDeath,
    OnStarvedTrapSouls = OnStarvedTrapSouls,
	CheckSoulsAdded=CheckSoulsAdded,
	SpawnSoulsAt=SpawnSoulsAt,
	OnMurdered=OnMurdered,
    OnHarvestTrapSouls=OnHarvestTrapSouls,
}
