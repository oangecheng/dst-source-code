--更新网络变量
local function onlevel(self,level)
	if self.inst.replica.medal_immortal then
		self.inst.replica.medal_immortal._level:set(level)
	end
	if level > 0 then
		self.inst:AddTag("isimmortal")
	end
	if self.UpdateTag then
		self:UpdateTag()
	end
end

local medal_immortal = Class(function(self, inst)
    self.inst = inst
	self.maxlevel=1--最大不朽等级
	self.level=0--不朽等级
	self.gem_consume_mult=1--不朽宝石消耗倍数
end,
nil,
{
    level = onlevel,
})

--设定最大不朽等级
function medal_immortal:SetMaxLevel(num)
	self.maxlevel = num or 1
end

--获取不朽等级
function medal_immortal:GetLevel()
	return self.level
end

--更新标签
function medal_immortal:UpdateTag()
	if self:CanAddImmortal() then
		self.inst:AddTag("immortalable")
	else
		self.inst:RemoveTag("immortalable")
	end
end

--已满级
function medal_immortal:IsFull()
	return self.level >= self.maxlevel
end

--不朽的前置条件回调
function medal_immortal:SetPreImmortalFn(fn)
	self.preimmortal = fn
end

--是否可不朽
function medal_immortal:CanAddImmortal()
	return (self.preimmortal==nil or self.preimmortal(self.inst)) and not self:IsFull()
end

--不朽宝石消耗倍数
function medal_immortal:SetConsumeMult(num)
	self.gem_consume_mult = num or 1
end

--计算提升不朽等级所需消耗的不朽宝石数量
function medal_immortal:CountConsume()
	return self:IsFull() and 0 or (self.level + 1) * self.gem_consume_mult
end

--添加不朽之力时的回调
function medal_immortal:SetOnImmortal(fn)
	self.onimmortal = fn
end

--添加不朽之力(不朽等级,是否是增加不朽等级)
function medal_immortal:SetImmortal(level,isadd)
	if level then
		self.level = math.min(level,self.maxlevel)
	end
	--给容器添加不朽之力
	if self.inst.components.container ~= nil and self.level>0 then
		if self.inst.components.preserver == nil then
			self.inst:AddComponent("preserver")
		end
		if self.old_perish_rate_multiplier == nil then--这边要获取一下原来的倍率，没有的话也要强行给个1，不然会有函数嵌套导致堆栈溢出
			self.old_perish_rate_multiplier = self.inst.components.preserver.perish_rate_multiplier or 1
		end
		self.inst.components.preserver:SetPerishRateMultiplier(function(inst, item)
			--1级不朽对生物无效，超过1级则全不朽
			if self.level>1 or (item ~= nil and not (item:HasTag("fish") or item.components.health~=nil)) then
				return 0
			end
			if self.old_perish_rate_multiplier ~= nil then
				return type(self.old_perish_rate_multiplier) == "number" and self.old_perish_rate_multiplier
					or self.old_perish_rate_multiplier(self.inst, item)
					or 1
			end
		end)
	end

	--回调
	if self.level>0 and self.onimmortal ~= nil then
		self.onimmortal(self.inst, self.level, isadd)
	end
end

--获取堆叠数量
local function GetStackSize(item)
    return item.components.stackable ~= nil and item.components.stackable:StackSize() or 1
end
--移除预制物(预制物,数量)
local function removeItem(item,num)
	if item.components.stackable then
		item.components.stackable:Get(num):Remove()
	else
		item:Remove()
	end
end

--增加不朽之力
function medal_immortal:AddImmortal(gem,player)
	--不朽之力满了
	if self:IsFull() then
		return false, STRINGS.IMMORTALSPEECH.ISMAX
	end
	--不满足前置条件
	if not self:CanAddImmortal() then
		return false, STRINGS.IMMORTALSPEECH.CANTADD
	end
	--不朽宝石不够
	local gem_consume = self:CountConsume()
	if gem == nil or GetStackSize(gem) < gem_consume then
		return false, subfmt(STRINGS.IMMORTALSPEECH.NOGEM, {consume = gem_consume})
	end
	
	--无不朽之力的容器需要消耗不朽精华
	if self.level==0 and self.inst.components.container ~= nil then
		local numslots = self.inst.components.container.numslots or 0
		local essences_consume = math.ceil((math.floor(numslots/10)*0.5+1)*numslots)
		if essences_consume > 0 then
			--获取玩家身上的不朽精华
			local essences = player and player.components.inventory:FindItems(function(item) return item.prefab == "immortal_essence" end)
			local essences_count = 0--不朽精华数量
			for i, v in ipairs(essences) do
				essences_count = essences_count + GetStackSize(v)
			end
			if essences_count >= essences_consume then
				player.components.inventory:ConsumeByName("immortal_essence",essences_consume)--消耗不朽精华
			else--不朽精华不足
				return false, subfmt(STRINGS.IMMORTALSPEECH.NOTENOUGH, {consume = essences_consume})
			end
		end
	end

	removeItem(gem,gem_consume)
	self:SetImmortal(self.level + 1, true)
	return true, STRINGS.IMMORTALSPEECH.SUCCESS
end

--同步不朽之力
function medal_immortal:SyncImmortal(target)
	if self.level > 0 and target ~= nil and target.components.medal_immortal ~= nil then
		target.components.medal_immortal:SetImmortal(self.level)
	end
end

function medal_immortal:OnSave() 
	return  {level = self.level}
end

function medal_immortal:OnLoad(data)       
	if data and data.level then
        self.level = data.level
		if self.level > 0 then
			self:SetImmortal()
		end
	end
end

return medal_immortal