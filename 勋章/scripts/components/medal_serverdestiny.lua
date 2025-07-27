local DESTINY_MAX = 50--最多可存储多少宿命

--宿命
local medal_serverdestiny = Class(function(self, inst)
    self.inst = inst
	self.destiny_common_loot = {}--通用宿命池
	self.destiny_key_loot = {}--特定key宿命池
	self:InitDestiny()
end)

--宿命初始化
function medal_serverdestiny:InitDestiny()
	self.inst:DoTaskInTime(0,function(inst)
		for i=1,DESTINY_MAX do 
			if self.destiny_common_loot[i] == nil then
				self.destiny_common_loot[i] = math.random()
			end
		end
	end)
end

--特定key宿命池初始化
function medal_serverdestiny:InitDestinyKey(key)
	--原本没有这个key的宿命池就初始化一波
	if key and self.destiny_key_loot[key] == nil then
		self.destiny_key_loot[key] = {}
		for i=1,DESTINY_MAX do 
			self.destiny_key_loot[key][i] = math.random()
		end
	end
end

--读取通用宿命
function medal_serverdestiny:GetDestiny()
	local destiny_num = table.remove(self.destiny_common_loot,1)
	table.insert(self.destiny_common_loot,math.random())
	return destiny_num or math.random()--防止特殊情况下读不到宿命
end

--通过key读取宿命
function medal_serverdestiny:GetDestinyByKey(key)
	--原本没有这个key的宿命池就初始化一波
	if self.destiny_key_loot[key] == nil then
		self.destiny_key_loot[key] = {}
		for i=1,DESTINY_MAX do 
			self.destiny_key_loot[key][i] = math.random()
		end
		return self:GetDestiny()--初始化的时候从通用宿命池拿宿命,能不用新生成的就不用新生成的
	end
	local destiny_num = table.remove(self.destiny_key_loot[key],1)
	table.insert(self.destiny_key_loot[key],math.random())
	return destiny_num
end

function medal_serverdestiny:OnSave() 
	return  {
		destiny_common_loot = shallowcopy(self.destiny_common_loot),
		destiny_key_loot = deepcopy(self.destiny_key_loot),
	}
end

function medal_serverdestiny:OnLoad(data)       
	if data ~= nil then
		if data.destiny_common_loot ~= nil then
			self.destiny_common_loot = shallowcopy(data.destiny_common_loot)
		end
		
		if data.destiny_key_loot ~= nil then
			self.destiny_key_loot = deepcopy(data.destiny_key_loot)
		end
	end
end

function medal_serverdestiny:Debug(key)
	if key  then
		print(key.."的宿命池：")
		if self.destiny_key_loot[key] ~= nil then
			for i,v in ipairs(self.destiny_key_loot[key]) do
				print(i,v)
			end
		else
			print("该宿命池为空")
		end
	else
		print("通用宿命池：")
		for i,v in ipairs(self.destiny_common_loot) do
			print(i,v)
		end
	end
end

return medal_serverdestiny