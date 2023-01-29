--local cooking = require("smelting")
local function ondone(self, done)
    if done then
        self.inst:AddTag("donecooking")
    else
        self.inst:RemoveTag("donecooking")
    end
end

local NDNR_Melter = Class(function(self, inst)
    self.inst = inst
    self.cooking = false
    self.done = false

    self.product = nil
    self.product_spoilage = nil
    self.recipes = nil
    self.default_recipe = nil
    self.spoiledproduct = nil
    self.overridebuild = nil
    self.overridesymbol = nil
	self.product_skinname = nil
    self.maketastyfood = nil

    self.min_num_for_cook = 4
    self.max_num_for_cook = 4

    self.cookername = nil

    -- stuff to make warly's special recipes possible
    self.specialcookername = nil	-- a special cookername to check first before falling back to cookername default
    self.productcooker = nil		-- hold on to the cookername that is cooking the current product

    -- self.inst:AddTag("stewer")
end, nil, {
	done = ondone
})

-- local recipes = {
-- 	ndnr_alloy = {recipes = {steelwool = 1, charcoal = 3}, overridebuild = "alloy", overridesymbol = "alloy01"},
-- 	lucky_goldnugget = {recipes = {goldnugget = 2, charcoal = 2}, overridebuild = "ndnr_goldnugget", overridesymbol = "lucky_goldnugget", count = 2},
-- 	shieldofterror = {recipes = {shieldofterror = 1, ndnr_alloy = 2, thulecite = 1}, overridebuild = "ndnr_eye_shield", overridesymbol = "ndnr_eye_shield"},
-- 	eyemaskhat = {recipes = {eyemaskhat = 1, ndnr_alloy = 2, thulecite = 1}, overridebuild = "ndnr_eyemaskhat", overridesymbol = "ndnr_eyemaskhat"},
-- }

function NDNR_Melter:OnRemoveFromEntity()
    self.inst:RemoveTag("stewer")
    self.inst:RemoveTag("donecooking")
    self.inst:RemoveTag("readytocook")
end

local function dospoil(inst)
	if inst.components.ndnr_melter and inst.components.ndnr_melter.onspoil then
		inst.components.ndnr_melter.onspoil(inst)
	end

    if inst.components.ndnr_melter.spoiltask then
        inst.components.ndnr_melter.spoiltask:Cancel()
        inst.components.ndnr_melter.spoiltask = nil
        inst.components.ndnr_melter.spoiltargettime = nil
    end
end

local function dostew(inst)
	local stewercmp = inst.components.ndnr_melter
	stewercmp.task = nil

	if stewercmp.ondonecooking then
		stewercmp.ondonecooking(inst)
	end
--[[
	if stewercmp.product ~= nil then
		local cooker = stewercmp.productcooker or (stewercmp.cookername or stewercmp.inst.prefab)
		local prep_perishtime = (cooking.recipes and cooking.recipes[cooker] and cooking.recipes[cooker][stewercmp.product] and cooking.recipes[cooker][stewercmp.product].perishtime) and cooking.recipes[cooker][stewercmp.product].perishtime or TUNING.PERISH_SUPERFAST
		local prod_spoil = stewercmp.product_spoilage or 1
		stewercmp.spoiltime = prep_perishtime * prod_spoil
		stewercmp.spoiltargettime =  GetTime() + stewercmp.spoiltime
		stewercmp.spoiltask = stewercmp.inst:DoTaskInTime(stewercmp.spoiltime, function(inst)
			if inst.components.ndnr_melter and inst.components.ndnr_melter.onspoil then
				inst.components.ndnr_melter.onspoil(inst)
			end
		end)
	end
	]]
	stewercmp.done = true
	stewercmp.cooking = nil
end

local function CheckStackSize(inst, product_stacksize)
	local container = inst.components.container
	local x,y,z = inst.Transform:GetWorldPosition()
	for k,v in pairs (container.slots) do
		local stacksize = v.components.stackable ~= nil and v.components.stackable:StackSize() or 1
		local remainder = stacksize - product_stacksize
		if remainder > 0 then
			if v.components.stackable ~= nil then
                v.components.stackable:SetStackSize(math.min(remainder, v.components.stackable.maxsize))
            end
			v.components.inventoryitem:RemoveFromOwner(true)
            v.components.inventoryitem:DoDropPhysics(x, y, z, true)
		else
			v:Remove()
		end
	end
end

local function FindMinStackSizeInContainer(inst)
	local container = inst.components.container
	local stacksize = container.slots[1].components.stackable and container.slots[1].components.stackable.stacksize or 1
	for k,v in pairs (container.slots) do
		if v.components.stackable then
			stacksize = math.min(stacksize, v.components.stackable.stacksize)
		else
			stacksize = 1
			break
		end
	end
	return stacksize
end

function NDNR_Melter:SetCookerName(_name)
	self.cookername = _name
end

function NDNR_Melter:GetTimeToCook()
	if self.cooking then
		return self.targettime - GetTime()
	end
	return 0
end

function NDNR_Melter:CanCook()
	return self.inst.components.container ~= nil and self.inst.components.container:IsFull()
end

function NDNR_Melter:GetProduct()
	local container_recipes = {}

	local product = "ash"
	local overridebuild = "ash"
	local overridesymbol = "ashes01"
	local stacksize = FindMinStackSizeInContainer(self.inst)
	local skinname, skin_overridebuild, skin_overridesymbol = nil, nil, nil

	for k,v in pairs (self.inst.components.container.slots) do
		if container_recipes[v.prefab] == nil then
			container_recipes[v.prefab] = 1
		else
			container_recipes[v.prefab] = container_recipes[v.prefab] + 1
		end

		if v.components.equippable then
			skinname = v.skinname
			skin_overridebuild = v.overridebuild
			skin_overridesymbol = v.overridesymbol
		end
	end

	for k,v in pairs(TUNING.NDNR_SMELTER_RECIPES) do
		local b = true
		for k1, v1 in pairs(v.recipes) do
			if container_recipes[k1] == nil or container_recipes[k1] ~= v1 then
				b = false
				if skinname then
					skinname = nil
				end
				break
			end
		end
		if b == true then
			product = k
			overridebuild = skin_overridebuild or v.overridebuild
			overridesymbol = skin_overridesymbol or v.overridesymbol
			break
		end
	end
	return product,stacksize,overridebuild,overridesymbol,skinname
end

function NDNR_Melter:StartCooking()
	if not self.done and not self.cooking then
		if self.inst.components.container then

			self.done = nil
			self.cooking = true

			if self.onstartcooking then
				self.onstartcooking(self.inst)
			end

			local product, stacksize, overridebuild, overridesymbol, skinname = self:GetProduct()
			self.product = product
			self.product_stacksize = stacksize
			self.spoiledproduct = product
			self.overridebuild = overridebuild
			self.overridesymbol = overridesymbol
			self.product_skinname = skinname
			local cooktime = TUNING.NDNR_SMELTER_RECIPES[product] and TUNING.NDNR_SMELTER_RECIPES[product].cooktime or 0.2
			self.productcooker = self.inst.prefab

			local grow_time = TUNING.BASE_COOK_TIME * cooktime * self.product_stacksize
			self.targettime = GetTime() + grow_time
			self.task = self.inst:DoTaskInTime(grow_time, dostew, "stew")

			self.inst.components.container:Close()
			-- self.inst.components.container:DestroyContents()
			self.inst.components.container.canbeopened = false

			CheckStackSize(self.inst, self.product_stacksize)
		end

	end
end

function NDNR_Melter:OnSave()
    local time = GetTime()
    if self.cooking then
		local data = {}
		data.cooking = true
		data.product = self.product
		data.product_stacksize = self.product_stacksize or 1
		data.overridebuild = self.overridebuild
		data.overridesymbol = self.overridesymbol

		data.productcooker = self.productcooker
		data.product_spoilage = self.product_spoilage
		if self.targettime and self.targettime > time then
			data.time = self.targettime - time
		end
		return data
    elseif self.done then
		local data = {}
		data.product = self.product
		data.product_stacksize = self.product_stacksize or 1
		data.overridebuild = self.overridebuild
		data.overridesymbol = self.overridesymbol
		data.product_skinname = self.product_skinname
		data.productcooker = self.productcooker
		data.product_spoilage = self.product_spoilage
		if self.spoiltargettime and self.spoiltargettime > time then
			data.spoiltime = self.spoiltargettime - time
		end
		data.timesincefinish = -(GetTime() - (self.targettime or 0))
		data.done = true
		return data
    end
end

function NDNR_Melter:OnLoad(data)
    --self.produce = data.produce
    if data.cooking then
		self.product = data.product
		self.product_stacksize = data.product_stacksize or 1
		self.overridebuild = data.overridebuild
		self.overridesymbol = data.overridesymbol
		self.productcooker = data.productcooker or (self.cookername or self.inst.prefab)
		if self.oncontinuecooking then
			local time = data.time or 1
			self.product_spoilage = data.product_spoilage or 1
			self.oncontinuecooking(self.inst)
			self.cooking = true
			self.targettime = GetTime() + time
			self.task = self.inst:DoTaskInTime(time, dostew, "stew")

			if self.inst.components.container then
				self.inst.components.container.canbeopened = false
			end

		end
    elseif data.done then
		self.product_spoilage = data.product_spoilage or 1
		self.done = true
		self.targettime = data.timesincefinish
		self.product = data.product
		self.product_stacksize = data.product_stacksize or 1
		self.overridebuild = data.overridebuild
		self.overridesymbol = data.overridesymbol
		self.product_skinname = data.product_skinname
		self.productcooker = data.productcooker or (self.cookername or self.inst.prefab)
		if self.oncontinuedone then
			self.oncontinuedone(self.inst)
		end
		self.spoiltargettime = data.spoiltime and GetTime() + data.spoiltime or nil
		if self.spoiltargettime then
			self.spoiltask = self.inst:DoTaskInTime(data.spoiltime, function(inst)
				if inst.components.ndnr_melter and inst.components.ndnr_melter.onspoil then
					inst.components.ndnr_melter.onspoil(inst)
				end
			end)
		end
		if self.inst.components.container then
			self.inst.components.container.canbeopened = false
		end

    end
end

function NDNR_Melter:GetDebugString()
    local str = nil

	if self.cooking then
		str = "COOKING"
	elseif self.done then
		str = "FULL"
	else
		str = "EMPTY"
	end
    if self.targettime then
        str = str.." ("..tostring(self.targettime - GetTime())..")"
    end

    if self.product then
		str = str.. " ".. self.product
    end

    if self.product_spoilage then
		str = str.."("..self.product_spoilage..")"
    end

	return str
end

function NDNR_Melter:IsDone()
	return self.done
end

function NDNR_Melter:StopCooking(reason)
	if self.task then
		self.task:Cancel()
		self.task = nil
	end
	if self.spoiltask then
		self.spoiltask:Cancel()
		self.spoiltask = nil
	end
	if self.product and reason and reason == "fire" then
		local prod = SpawnPrefab(self.product)
		if prod then
			prod.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
			prod:DoTaskInTime(0, function(prod) prod.Physics:Stop() end)
		end
	end
	self.product = nil
	self.targettime = nil
end


function NDNR_Melter:Harvest( harvester )
	if self.done then
		if self.onharvest then
			self.onharvest(self.inst)
		end
		self.done = nil
		if self.product then
			if harvester and harvester.components.inventory then
				local loot = nil
				loot = SpawnPrefab(self.product)

				if loot then
					if loot.components.stackable ~= nil then
						loot.components.stackable:SetStackSize((TUNING.NDNR_SMELTER_RECIPES[self.product] and TUNING.NDNR_SMELTER_RECIPES[self.product].count or 1) * (self.product_stacksize or 1))
					end
					if self.product_skinname and TheInventory:CheckClientOwnership(harvester.userid, self.product_skinname) then
						TheSim:ReskinEntity(loot.GUID, loot.skinname, self.product_skinname, nil, harvester.userid )
					end
					if self.product == "shieldofterror" or self.product == "eyemaskhat" then
						if loot.ndnrrefine ~= nil then
							loot.ndnr_refine_status = true
						end
					end
					harvester.components.inventory:GiveItem(loot, nil, harvester:GetPosition())
				end
			end
			self.product = nil
			self.spoiltargettime = nil

			if self.spoiltask then
				self.spoiltask:Cancel()
				self.spoiltask = nil
			end
		end

		if self.inst.components.container and not self.inst:HasTag("flooded") then
			self.inst.components.container.canbeopened = true
		end

		return true
	end
end

function NDNR_Melter:LongUpdate(dt)
    if not self.paused and self.targettime ~= nil then
		if self.task ~= nil then
			self.task:Cancel()
			self.task = nil
		end

        self.targettime = self.targettime - dt

        if self.cooking then
            local time_to_wait = self.targettime - GetTime()
            if time_to_wait < 0 then
                dostew(self.inst)
            else
                self.task = self.inst:DoTaskInTime(time_to_wait, dostew, "stew")
            end
        end
    end

	if self.spoiltask ~= nil then
		self.spoiltask:Cancel()
		self.spoiltask = nil
        self.spoiltargettime = self.spoiltargettime - dt
		local time_to_wait = self.spoiltargettime - GetTime()
		if time_to_wait <= 0 then
			dospoil(self.inst)
		else
			self.spoiltask = self.inst:DoTaskInTime(time_to_wait, dospoil)
		end
	end
end

return NDNR_Melter
