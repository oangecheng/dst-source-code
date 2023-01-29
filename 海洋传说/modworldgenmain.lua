GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

AddRoomPreInit("MoonbaseOne",function(self)
	if self.contents and self.contents.distributeprefabs then
		self.contents.distributeprefabs.lg_litichi_tree = .05
	end
end)

AddRoomPreInit("BGLightningBluff",function(self)
	if self.contents and self.contents.distributeprefabs then
		self.contents.distributeprefabs.lg_lemon_tree = .05
	end
end)
AddRoomPreInit("LightningBluffAntlion",function(self)
	if self.contents and self.contents.distributeprefabs then
		self.contents.distributeprefabs.lg_lemon_tree = .05
	end
end)
AddRoomPreInit("LightningBluffOasis",function(self)
	if self.contents and self.contents.distributeprefabs then
		self.contents.distributeprefabs.lg_lemon_tree = .05
	end
end)
AddRoomPreInit("LightningBluffLightning",function(self)
	if self.contents and self.contents.distributeprefabs then
		self.contents.distributeprefabs.lg_lemon_tree = .05
	end
end)

local water = {
	--这个是浅海
	OceanCoastal = 0,
	--下面三个应该是深海或者 交界的
	OceanRough = 0.1,
	OceanHazardous = 0.5,
	OceanSwell = 0.5,
}
for k, v in pairs(water) do
	AddRoomPreInit(k,function(self)
		if self.contents and self.contents.distributeprefabs then
			self.contents.distributeprefabs.lg_actinine_plant = v
		end
	end)
end
