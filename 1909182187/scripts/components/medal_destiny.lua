local DESTINY_MAX = 50--最多可存储多少宿命
--宿命
local medal_destiny = Class(function(self, inst)
    self.inst = inst
	self.destiny_seed_loot = {}--宿命种子
	self:InitDestiny()
end)

--宿命初始化
function medal_destiny:InitDestiny()
	for i=1,DESTINY_MAX do 
		self.destiny_seed_loot[i] = math.random()
	end
end
--读取宿命
function medal_destiny:GetDestiny()
	local destiny_num = table.remove(self.destiny_seed_loot,1)
	self.destiny_seed_loot[#self.destiny_seed_loot+1] = math.random()
	return destiny_num
end

function medal_destiny:OnSave() 
	return  {
		destiny_seed_loot = shallowcopy(self.destiny_seed_loot),
	}
end

function medal_destiny:OnLoad(data)       
	if data and data.destiny_seed_loot and #data.destiny_seed_loot>0 then
        -- self.destiny_seed_loot = shallowcopy(data.destiny_seed_loot)
		for i, v in ipairs(data.destiny_seed_loot) do
			self.destiny_seed_loot[i] = v
		end
	else
		self:InitDestiny()
	end
end

function medal_destiny:Debug()
	print("宿命："..#self.destiny_seed_loot)
	for i,v in ipairs(self.destiny_seed_loot) do
		print(i,v)
	end
end

return medal_destiny