--宿命
local medal_itemdestiny = Class(function(self, inst)
    self.inst = inst
	self.destiny_num = 0--宿命
	self:InitDestiny()
end)

--宿命初始化
function medal_itemdestiny:InitDestiny()
	if self.inst:HasTag("_stackable") then return end--可堆叠物品可不能加宿命
	self.inst:DoTaskInTime(0,function(inst)
		if self.destiny_num == 0 then
			if TheWorld and TheWorld.components.medal_serverdestiny ~= nil then
				self.destiny_num = TheWorld.components.medal_serverdestiny:GetDestinyByKey(self.destiny_key or self.inst.prefab)
			else
				self.destiny_num = math.random()
			end
		end
	end)
end

--设定宿命池key(部分道具的宿命池可以共用)
function medal_itemdestiny:SetDestinyKey(key)
	self.destiny_key = key or self.inst.prefab
end

--读取宿命(是否需要用新的宿命)
function medal_itemdestiny:GetDestiny(neednew)
	--原本有宿命了就用宿命
	if self.destiny_num ~= 0 and not neednew then
		return self.destiny_num
	end
	--没宿命说明是可堆叠物品,要现取现用;也可能是改命,改命需要拿一条新的宿命出来
	if TheWorld and TheWorld.components.medal_serverdestiny ~= nil then
		return TheWorld.components.medal_serverdestiny:GetDestinyByKey(self.destiny_key or self.inst.prefab)
	end
	return math.random()
end

--继承宿命
function medal_itemdestiny:InheritDestiny(target,destiny_num)
	self.destiny_num = destiny_num 
		or (target ~= nil and target.components.medal_itemdestiny and target.components.medal_itemdestiny:GetDestiny()) 
		or self:GetDestiny(true)
end

function medal_itemdestiny:OnSave() 
	if self.destiny_num ~= 0 then
        return { destiny_num = self.destiny_num }
    end
end

function medal_itemdestiny:OnLoad(data)       
	if data and data.destiny_num then
		self.destiny_num = data.destiny_num
	end
end

function medal_itemdestiny:Debug()
	print("宿命："..self:GetDestiny())
end

return medal_itemdestiny