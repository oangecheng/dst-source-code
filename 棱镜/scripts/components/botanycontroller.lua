local BotanyController = Class(function(self, inst)
    self.inst = inst

    self.type = 1 --1水、2土、3水土
    self.moisture = 0
    self.nutrients = { 0, 0, 0 }
    self.onbarchange = nil

    self.moisture_max = 2000
    self.nutrient_max = 800
end)

function BotanyController:SetBars()
    if self.onbarchange ~= nil then
        self.onbarchange(self)
    end
end

local function ComputValue(valuenow, value, valuemax, isadd, plus)
    if isadd then
        value = valuenow + value*plus
    else
        -- value = value*plus --替换时，不应用数值加成
    end
    value = math.clamp(value, 0, valuemax)
    return value
end
function BotanyController:SetValue(moisture, nutrients, isadd)
    local changed = false
    if moisture ~= nil and (self.type == 1 or self.type == 3) then --水分获取简单，无数值加成
        self.moisture = ComputValue(self.moisture, moisture, self.moisture_max, isadd, 1)
        changed = true
    end
    if nutrients ~= nil and (self.type == 2 or self.type == 3) then --肥料提供30%数值加成
        if nutrients[1] ~= nil then
            self.nutrients[1] = ComputValue(self.nutrients[1], nutrients[1], self.nutrient_max, isadd, 1.3)
        end
        if nutrients[2] ~= nil then
            self.nutrients[2] = ComputValue(self.nutrients[2], nutrients[2], self.nutrient_max, isadd, 1.3)
        end
        if nutrients[3] ~= nil then
            self.nutrients[3] = ComputValue(self.nutrients[3], nutrients[3], self.nutrient_max, isadd, 1.3)
        end
        changed = true
    end
    if changed then
        self:SetBars()
    end
end

function BotanyController:TriggerPlant(isadd)
    local x, y, z = self.inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 20,
        nil,
        { "NOCLICK", "FX", "INLIMBO" },
        { "crop_legion", "crop2_legion" }
    )
    for _,v in pairs(ents) do
        if v.components.perennialcrop ~= nil then
            v.components.perennialcrop:TriggerController(self.inst, isadd)
        elseif v.components.perennialcrop2 ~= nil then
            v.components.perennialcrop2:TriggerController(self.inst, isadd)
        end
    end
end

local function SetReleaseFx(x, y, z)
    local fx = SpawnPrefab("farm_plant_happy")
    if fx ~= nil then
        fx.Transform:SetPosition(x, y, z)
    end
end
local function isEmptyNutrients(self)
    return self.nutrients[1] <= 0 and self.nutrients[2] <= 0 and self.nutrients[3] <= 0
end
local function ComputNutrient(self, idx, _n)
    _n = 100 - _n
    if _n > 50 then --缺肥超过50%才开始加肥，这样也许能减少搭配种植时肥料的消耗
        local n_now = self.nutrients[idx]
        if n_now > _n then
            self.nutrients[idx] = n_now - _n
            return _n
        else
            self.nutrients[idx] = 0
            return n_now
        end
    end
    return 0
end
local function ComputNutrients(self, x, y, z)
    local tile_x, tile_z = TheWorld.Map:GetTileCoordsAtPoint(x, y, z)
    local _n1, _n2, _n3 = TheWorld.components.farming_manager:GetTileNutrients(tile_x, tile_z)
    _n1 = ComputNutrient(self, 1, _n1)
    _n2 = ComputNutrient(self, 2, _n2)
    _n3 = ComputNutrient(self, 3, _n3)
    if _n1 > 0 or _n2 > 0 or _n3 > 0 then
        TheWorld.components.farming_manager:AddTileNutrients(tile_x, tile_z, _n1, _n2, _n3)
        return true
    end
end
local function ComputMoisture(self, x, y, z)
    if self.moisture > 0 then
        TheWorld.components.farming_manager:AddSoilMoistureAtPoint(x, y, z, 100)
        self.moisture = math.max(0, self.moisture-2.5) --由于没法知道耕地里的具体水分，只能这样直接加水了
        return true
    end
end
local function WitherComputMoisture(self, v)
    if self.type == 3 then
        if self.moisture <= 0 then
            return false
        end
    end

    if v.components.witherable ~= nil then
        if
            not v.components.witherable:IsProtected() and
            (
                v.components.witherable:CanWither() or --快要枯萎，提前浇水
                v.components.witherable:CanRejuvenate() --已经缺水性枯萎
            )
        then
            v.components.witherable:Protect(TUNING.FIRESUPPRESSOR_PROTECTION_TIME)
            self.moisture = math.max(0, self.moisture-2.5)
            return true
        end
    elseif v.components.perennialcrop2 ~= nil then
        if v.components.perennialcrop2:PourWater(nil, self.inst, 1) then
            self.moisture = math.max(0, self.moisture-2.5)
            return true
        end
    elseif v.components.moisture ~= nil then
        local moicpt = v.components.moisture
        local need = math.min(moicpt:GetMaxMoisture() - moicpt:GetMoisture(), self.moisture)
        if need > 0 then
            moicpt:DoDelta(need, true)
            self.moisture = math.max(0, self.moisture-need)
            return true
        end
    elseif v.fn_l_needwater ~= nil then --兼容其他mod
        return v.fn_l_needwater(v, self)
    end
end
local function WitherComputNutrients(self, v)
    if self.type == 3 then
        if isEmptyNutrients(self) then
            return false
        end
    end

    if v.components.perennialcrop2 ~= nil then
        local cpt = v.components.perennialcrop2
        if cpt.isrotten or cpt.donenutrient or cpt.stage == cpt.stage_max then
            return false
        end

        local idx = nil
        if self.nutrients[3] > 0 then
            idx = 3
        elseif self.nutrients[2] > 0 then
            idx = 2
        elseif self.nutrients[1] > 0 then
            idx = 1
        else
            return false --按理来说不应该能运行到这里
        end

        local poop = SpawnPrefab("poop")
        if poop ~= nil then
            cpt:Fertilize(poop, self.inst)
            poop:Remove()
            self.nutrients[idx] = math.max(0, self.nutrients[idx] - 3)
            return true
        end
    elseif
        v.components.pickable ~= nil and
        v.components.pickable:CanBeFertilized() --贫瘠或缺水枯萎
    then
        local idx = nil
        if self.nutrients[3] > 0 then
            idx = 3
        elseif self.nutrients[2] > 0 then
            idx = 2
        elseif self.nutrients[1] > 0 then
            idx = 1
        else
            return false --按理来说不应该能运行到这里
        end

        local poop = SpawnPrefab("poop")
        if poop ~= nil then
            v.components.pickable:Fertilize(poop, nil)
            poop:Remove()
            self.nutrients[idx] = math.max(0, self.nutrients[idx] - 3)
            return true
        end
    elseif v.fn_l_neednutrient ~= nil then --兼容其他mod
        return v.fn_l_neednutrient(v, self)
    end
end
local function ComputSoils(self, fn_tile, fn_wither, fn_check, fn_tend, tags)
    if fn_check(self) then
        return
    end

    local isasleep = self.inst:IsAsleep()
    local x, y, z = self.inst.Transform:GetWorldPosition()

    if fn_tend ~= nil then
        fn_tend(self, x, y, z)
    end

    for k1 = -20,20,4 do
        for k2 = -20,20,4 do
            local tile = TheWorld.Map:GetTileAtPoint(x+k1, 0, z+k2)
            if tile == GROUND.FARMING_SOIL then
                if fn_tile(self, x+k1, 0, z+k2) and fn_check(self) then
                    self:SetBars()
                    if not isasleep then --睡眠状态就不释放特效
                        SetReleaseFx(x, y, z)
                    end
                    return
                end
            end
        end
    end

    --特效
    SetReleaseFx(x, y, z)

    if isasleep then --睡眠状态就不查找枯萎作物
        self:SetBars()
        return
    end

    --不需要考虑子圭作物，因为机制已经有了
    local ents = TheSim:FindEntities(x, y, z, 20, nil, { "NOCLICK", "INLIMBO" }, tags)
    for _,v in pairs(ents) do
        if v:IsValid() then
            if fn_wither(self, v) and fn_check(self) then
                self:SetBars()
                return
            end
        end
    end
    self:SetBars()
end
function BotanyController:DoAreaFunction()
    if self.type == 1 then
        ComputSoils(self,
            ComputMoisture,
            WitherComputMoisture,
            function(self)
                return self.moisture <= 0
            end,
            nil,
            { "witherable", "barren", "crop2_legion", "needwater2" }
        )
    elseif self.type == 2 then
        ComputSoils(self,
            ComputNutrients,
            WitherComputNutrients,
            isEmptyNutrients,
            nil,
            { "witherable", "barren", "crop2_legion", "neednutrient2" }
        )
    else
        ComputSoils(self,
            function(self, x, y, z)
                local res_m = ComputMoisture(self, x, y, z)
                local res_n = ComputNutrients(self, x, y, z)
                return res_m or res_n
            end,
            function(self, v)
                local res_m = WitherComputMoisture(self, v)
                local res_n = WitherComputNutrients(self, v)
                return res_m or res_n
            end,
            function(self)
                return self.moisture <= 0 and isEmptyNutrients(self)
            end,
            function(self, x, y, z)
                local ents = TheSim:FindEntities(x, y, z, 20, { "tendable_farmplant" }, { "INLIMBO" })
                for _,v in ipairs(ents) do
                    if v.components.farmplanttendable ~= nil then
                        v.components.farmplanttendable:TendTo(self.inst)
                    end
                end
            end,
            { "witherable", "barren", "crop2_legion", "needwater2", "neednutrient2" }
        )
    end
end

function BotanyController:OnSave()
    local data = nil
    if self.type == 1 then
        if self.moisture > 0 then
            data = { mo = self.moisture }
        end
    elseif self.type == 2 then
        if self.nutrients[1] > 0 or self.nutrients[2] > 0 or self.nutrients[3] > 0 then
            data = {}
            if self.nutrients[1] > 0 then data.n1 = self.nutrients[1] end
            if self.nutrients[2] > 0 then data.n2 = self.nutrients[2] end
            if self.nutrients[3] > 0 then data.n3 = self.nutrients[3] end
        end
    else
        if self.moisture > 0 or self.nutrients[1] > 0 or self.nutrients[2] > 0 or self.nutrients[3] > 0 then
            data = {}
            if self.moisture > 0 then data.mo = self.moisture end
            if self.nutrients[1] > 0 then data.n1 = self.nutrients[1] end
            if self.nutrients[2] > 0 then data.n2 = self.nutrients[2] end
            if self.nutrients[3] > 0 then data.n3 = self.nutrients[3] end
        end
    end

    return data
end

function BotanyController:OnLoad(data)
    if data == nil then
        return
    end

    if self.type == 1 then
        self:SetValue(data.mo, nil, false)
    elseif self.type == 2 then
        self:SetValue(nil, { data.n1, data.n2, data.n3 }, false)
    else
        self:SetValue(data.mo, { data.n1, data.n2, data.n3 }, false)
    end
end

local function DecimalPointTruncation(value, plus) --截取小数点
	value = math.floor(value*plus)
	return value/plus
end
local function GetDetailString(self, doer, type)
	local data = {
		n1 = tostring(DecimalPointTruncation(self.nutrients[1], 10)),
        n2 = tostring(DecimalPointTruncation(self.nutrients[2], 10)),
        n3 = tostring(DecimalPointTruncation(self.nutrients[3], 10)),
        mo = tostring(DecimalPointTruncation(self.moisture, 10))
	}

	if type == 2 then
		data.nu_max = tostring(self.nutrient_max)
		data.mo_max = tostring(self.moisture_max)
		return subfmt(STRINGS.PLANT_CROP_L["CTL2_"..tostring(self.type)], data)
	else
		return subfmt(STRINGS.PLANT_CROP_L["CTL1_"..tostring(self.type)], data)
	end
end
function BotanyController:SayDetail(doer, dotalk) --介绍细节
	if doer == nil or doer:HasTag("mime") then
		return
	end

	local str = nil

	if doer:HasTag("sharpeye") then
		str = GetDetailString(self, doer, 2)
	else
		local hat = doer.components.inventory and doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil
		if hat == nil then
			-- if doer:HasTag("plantkin") then
			-- 	str = GetDetailString(self, doer, 1)
			-- end
			return str
		elseif hat:HasTag("detailedplanthappiness") then
			str = GetDetailString(self, doer, 2)
		elseif hat:HasTag("plantinspector") then
			str = GetDetailString(self, doer, 1)
		end
	end

	if dotalk and str ~= nil and doer.components.talker ~= nil then
		doer.components.talker:Say(str)
	end

	return str
end

return BotanyController
