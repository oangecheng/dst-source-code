GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

--Auto Aligning
local yuyuyu = {[0] = 0.667,[1] = 0.667,[2] = 2,[3] = 3.333}

if TUNING.FARM_TILL_SPACING ~= nil then
	local auto_aligning = GetModConfigData("to_auto_aligning")
	if auto_aligning ~= false then
		AddComponentPostInit("farmtiller", function(self)
			local old_Till = self.Till
			function self:Till(pt, doer,...)
				if auto_aligning == "4*4" then
					pt.x = math.floor(pt.x/4)*4 + (math.floor(pt.x)%4)*1.333
					pt.z = math.floor(pt.z/4)*4 + (math.floor(pt.z)%4)*1.333
				else
					--3*3
					--pt.x = math.floor(pt.x/4)*4 + yuyuyu[(math.floor(pt.x+0.5)%4)]
					--pt.z = math.floor(pt.z/4)*4 + yuyuyu[(math.floor(pt.z+0.5)%4)]
					--3*3
					local pt1 = Point( TheWorld.Map:GetTileCenterPoint(pt:Get()) )
					local p2 = pt1 - pt
					local p3 = Point( (p2.x + 0.5) - (p2.x + 0.5)%1.333, 0, (p2.z + 0.5) - (p2.z + 0.5)%1.333 )
					pt = pt1 - p3	
					--顶点3*3				
					--local xx = pt.x%2
					--local zz = pt.z%2
					--local x = (xx == 1 and -0.95) or (xx < 1 and  0 ) or 0.95
					--local z = (zz == 1 and -0.95) or (zz < 1 and  0 ) or 0.95
					--pt.x = 	math.floor(pt.x)+x pt.z = math.floor(pt.z)+z
				end
				--print(pt)
				return old_Till(self,pt, doer,...)
			end
		end)
	end
end

AddComponentPostInit("growable", function(self)
	--To Oversize
	if GetModConfigData("to_oversize") == true then
		self.inst:DoTaskInTime(0,function()
			if not(self.stages ~= nil and type(self.stages)  =="table") then return end
			for i, v in ipairs(self.stages) do
				if v and v.name ~= nil and v.name == "full" and
					v.pregrowfn ~= nil then
					local old = v.pregrowfn
					v.pregrowfn = function(inst)
						old(inst)
						inst.is_oversized = true
					end
				end
			end
		end)
	end

	--No Rotten
	if GetModConfigData("no_rotten") == true then
		local old_StartGrowing = self.StartGrowing
		function self:StartGrowing(time)
			if self.stages and self.stages[self.stage] and self.stages[self.stage].name ~= nil and 
				self.stages[self.stage].name == "full" then
				self:StopGrowing()
				return
			end
			return old_StartGrowing(self,time)
		end
		self.inst:DoTaskInTime(0,function()
			if self.stages ~= nil and self.stages[self.stage] and self.stages[self.stage].name ~= nil and self.stages[self.stage].name == "full" then
				self:StopGrowing()
			end	
		end)
	end
end)

--Quick plant
if GetModConfigData("quick_plant") == true then
	AddStategraphPostInit("wilson", function(sg)
		local plant = ACTIONS.PLANTSOIL ~= nil and sg.actionhandlers[ACTIONS.PLANTSOIL].deststate or nil
		if plant then
			sg.actionhandlers[ACTIONS.PLANTSOIL].deststate = function(inst, action)
				return "doshortaction"
			end
		end
	end)
end