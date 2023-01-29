

local legend_regrowplants = Class(function(self, inst)
    self.inst = inst
    self.prefab = nil
	self.already = true
	self:CreatItem()
end)

function legend_regrowplants:AddPlantData(plant)
	self.prefab = plant[1]
	self.rad = plant[2]
	self.max = plant[3]
end

function legend_regrowplants:CreatItem()
	self.inst:DoTaskInTime(0.1, function()
		if	self.already and self.prefab ~= nil then
			self.already = false
			local has = GetClosestInstWithTag(self.prefab, self.inst, self.rad)
			if has ~= nil then
				return
			end
			local spawned = 0
			local x, y, z = self.inst.Transform:GetWorldPosition()
			for k = 1, 20 do
				local map = TheWorld.Map
				local pt = Vector3(0, 0, 0)
				local offset = FindValidPositionByFan(math.random() * 2 * PI,4+math.random() * self.rad,8,
					function(offset)
						pt.x = x + offset.x
						pt.z = z + offset.z
						return map:CanPlantAtPoint(pt.x, 0, pt.z)
							and map:IsDeployPointClear(pt, nil, .5)
							and not map:IsPointNearHole(pt, .4)
					end
				)
				if offset ~= nil then
					local plant = SpawnPrefab(self.prefab)
					plant.Transform:SetPosition(x + offset.x, 0, z + offset.z)
					spawned = spawned + 1 
					if spawned >= self.max then
						break
					end
				end
			end		
		end
	end)
end

function legend_regrowplants:OnSave()
    return { already = self.already }
end

function legend_regrowplants:OnLoad(data)
    if data.already ~= nil  then
        self.already = data.already
    end
end

return legend_regrowplants
