local upvaluehelper = require "components/ndnr_upvaluehelper"

AddClassPostConstruct("components/childspawner", function(self, inst)
    local _ReleaseAllChildren = self.ReleaseAllChildren
    function self:ReleaseAllChildren(target, prefab)
        if (self.inst.prefab == "beebox" or self.inst.prefab == "beebox_hermit" or self.inst.prefab == "wasphive") and target ~= nil and target:HasTag("hivehatprotect") then
            return {}
        else
            return _ReleaseAllChildren(self, target, prefab)
        end
    end
end)

AddClassPostConstruct("components/growable", function(self, inst)
    self.stageupdatefn = nil
    local _DoGrowth = self.DoGrowth
    function self:DoGrowth()
        local dogrowth_result = _DoGrowth(self)
        if self.stageupdatefn ~= nil then
            local stage = self:GetStage()
            self.stageupdatefn(self.inst, stage)
        end
        return dogrowth_result
    end
end)

AddClassPostConstruct("components/temperature", function(self, inst)
    local _OnUpdate = self.OnUpdate
    function self:OnUpdate(dt, applyhealthdelta)
        _OnUpdate(self, dt, applyhealthdelta)

        local mintemp = self.mintemp
        local maxtemp = self.maxtemp
        local ambient_temperature = TheWorld.state.temperature

        local owner = self.inst.components.inventoryitem ~= nil and self.inst.components.inventoryitem.owner or nil
        if owner ~= nil and owner:HasTag("ndnr_dragonflychest") then
            self.rate = TUNING.WARM_DEGREES_PER_SEC
            self:SetTemperature(math.clamp(self.current + self.rate * dt, mintemp, 60))
        end
    end
end)

AddClassPostConstruct("components/debuffable", function(self, inst)
    local _AddDebuff = self.AddDebuff
    function self:AddDebuff(name, prefab, data)
        local buff = _AddDebuff(self, name, prefab, data)
        if self.inst.components.ndnr_bufftime then
            if TUNING.NDNR_BUFFTIMES[name] ~= nil then
                local bufftime = shallowcopy(TUNING.NDNR_BUFFTIMES[name])
                bufftime.buffname = name
                self.inst.components.ndnr_bufftime:SetItem(bufftime)
            end
        end
        return buff
    end
    local _RemoveDebuff = self.RemoveDebuff
    function self:RemoveDebuff(name)
        _RemoveDebuff(self, name)
        if self.inst.components.ndnr_bufftime then
            if TUNING.NDNR_BUFFTIMES[name] ~= nil then
                self.inst.components.ndnr_bufftime:RemoveItem(TUNING.NDNR_BUFFTIMES[name].name)
            end
        end
    end
end)

AddClassPostConstruct("components/cooker", function(self, inst)
    local _CookItem = self.CookItem
    function self:CookItem(item, chef)
        if self.inst.prefab == "ndnr_magma_milk" then
            if self:CanCook(item, chef) and math.random() < 0.1 then
                local newitem = SpawnPrefab("ash")
                item:Remove()
                return newitem
            else
                return _CookItem(self, item, chef)
            end
        else
            return _CookItem(self, item, chef)
        end
    end
end)

AddClassPostConstruct("components/armor", function(self, inst)
    local _SetCondition = self.SetCondition
    function self:SetCondition(amount)
        if self.inst:HasTag("ndnr_refine") then
            if self.indestructible then
                return
            end

            self.condition = math.max(0, math.min(amount, self.maxcondition))
            self.inst:PushEvent("percentusedchange", { percent = self:GetPercent() })

            if self.condition <= 0 then
                self.condition = 0
                -- ProfileStatsSet("armor_broke_"..self.inst.prefab, true)
                -- ProfileStatsSet("armor", self.inst.prefab)

                if self.onfinished ~= nil then
                    self.onfinished()
                end
            end
        else
            _SetCondition(self, amount)
        end
    end

    local _CanResist = self.CanResist
    function self:CanResist(attacker, weapon)
        if self.inst:HasTag("ndnr_refine") and self.condition <= 0 then
            return false
        end
        if attacker and self.ndnr_immunetags then
            for k,v in pairs(self.ndnr_immunetags) do
                if attacker:HasTag(v) then
                    return false
                end
            end
        end
        return _CanResist(self, attacker, weapon)
    end

    local _OnSave = self.OnSave
    function self:OnSave()
        local onsave = _OnSave(self)
        if onsave ~= nil then
            onsave.maxcondition = self.maxcondition
        end
        return onsave
    end

    local _OnLoad = self.OnLoad
    function self:OnLoad(data)
        if data == nil then return end

        if data.condition ~= nil then
            self:SetCondition(data.condition)
        end
        if data.maxcondition ~= nil and data.condition ~= nil then
            self:SetPercent(data.condition/data.maxcondition)
        end
        _OnLoad(self, data)
    end
end)

AddClassPostConstruct("components/worldmeteorshower", function(self, inst)
    local _SpawnMeteorLoot = self.SpawnMeteorLoot
    function self:SpawnMeteorLoot(prefab)
        local ent = _SpawnMeteorLoot(self, prefab)
        if ent ~= nil and ent.prefab ~= "rock_moon_shell" then
            if math.random() < 0.5 then
                local _ent = nil
                if prefab == "rock_moon" or prefab == "rock_flintless" or prefab == "rock1" then
                    _ent = SpawnPrefab("ndnr_rock_iron")
                elseif prefab == "rocks" or prefab == "flint" or prefab == "moonrocknugget" then
                    _ent = SpawnPrefab("ndnr_iron")
                elseif prefab == "rock_flintless_med" then
                    _ent = SpawnPrefab("ndnr_rock_iron_med")
                elseif prefab == "rock_flintless_low" then
                    _ent = SpawnPrefab("ndnr_rock_iron_low")
                end
                ent:Remove()
                return _ent
            end
        end
        return ent
    end
end)

AddClassPostConstruct("components/birdspawner", function(self, inst)
    local _SpawnBird = self.SpawnBird
    function self:SpawnBird(spawnpoint, ignorebait)
        local _PickBird = upvaluehelper.Get(self.SpawnBird, "PickBird")
        if _PickBird ~= nil and TheWorld.net and TheWorld.net.mod_ndnr and TheWorld.net.mod_ndnr.isqixi then
            local newPickBird = function(spawnpoint) return "canary" end
            upvaluehelper.Set(self.SpawnBird, "PickBird", newPickBird)
        end
        local bird = _SpawnBird(self, spawnpoint, ignorebait)
        return bird
    end
end)

AddClassPostConstruct("components/edible", function(self, inst)
    local _GetHunger = self.GetHunger
    function self:GetHunger(eater)
        local result = _GetHunger(self, eater)

        local multiplier = 1
        if self.spice and TUNING.SPICE_MULTIPLIERS[self.spice] and TUNING.SPICE_MULTIPLIERS[self.spice].HUNGER then
            multiplier = multiplier + TUNING.SPICE_MULTIPLIERS[self.spice].HUNGER
        end

        return multiplier * result
    end
end)

AddClassPostConstruct("components/desolationspawner", function(self, inst)
    -- self:SetSpawningForType("ndnr_palmtree", "ndnr_coconut_sapling", TUNING.EVERGREEN_REGROWTH.DESOLATION_RESPAWN_TIME, {"ndnr_palmtree"}, function()
    --     return (TheWorld.state.issummer and TUNING.EVERGREEN_REGROWTH_TIME_MULT * 2) or (TheWorld.state.iswinter and 0) or TUNING.EVERGREEN_REGROWTH_TIME_MULT
    -- end)
    local _OnLoad = self.OnLoad
    function self:OnLoad(data)
        for area, areadata in pairs(data.areas) do
            if data.areas[area]["ndnr_palmtree"] then
                data.areas[area]["ndnr_palmtree"] = nil
            end
        end
        _OnLoad(self, data)
    end
end)

AddClassPostConstruct("components/mightiness", function(self, inst)
    local _DoDec = self.DoDec
    function self:DoDec(...)
        if self.inst:HasTag("ndnr_albumenpowder") then
            return
        end
        _DoDec(self, ...)
    end
end)

AddClassPostConstruct("components/locomotor", function(self, inst)
    local _UpdateGroundSpeedMultiplier = self.UpdateGroundSpeedMultiplier
    function self:UpdateGroundSpeedMultiplier(bottle, doer, is_not_from_hermit)

        _UpdateGroundSpeedMultiplier(self)

        local x, y, z = self.inst.Transform:GetWorldPosition()
        local current_ground_tile = TheWorld.Map:GetTileAtPoint(x, 0, z)
        -- local WORLD_TILES = ReleaseID.Current == "R22_PIRATEMONKEYS" and GLOBAL.WORLD_TILES or GROUND

        if CurrentRelease.GreaterOrEqualTo("R22_PIRATEMONKEYS") then
            if self:FasterOnRoad() and current_ground_tile == GLOBAL.WORLD_TILES.NDNR_ASPHALT then
                self.groundspeedmultiplier = 1.5
            end
        else
            if self:FasterOnRoad() and current_ground_tile == GROUND.NDNR_ASPHALT then
                self.groundspeedmultiplier = 1.5
            end
        end

    end
end)

AddComponentPostInit("farmtiller", function(self, inst)
    local _Till = self.Till
    -- 3x3耕地，代码来自musha
    function self:Till(pt, doer)
        if self.inst.prefab == "ndnr_alloyhoe" then
            local NewX, Newy, Newz = TheWorld.Map:GetTileCenterPoint(pt.x, pt.y, pt.z)

            local ents = TheWorld.Map:GetEntitiesOnTileAtPoint(NewX, 0, Newz)
            for _, ent in ipairs(ents) do
                if ent ~= inst and ent:HasTag("soil") then
                    ent:PushEvent("collapsesoil")
                elseif ent:HasTag("antlion_sinkhole") then -- 这段逻辑貌似没效
                    if ent.remainingrepairs then
                        for i = 1, ent.remainingrepairs do
                            ent:PushEvent("timerdone", {
                                name = "nextrepair"
                            })
                        end
                    else
                        ent.remainingrepairs = 1
                        ent:PushEvent("timerdone", { name = "nextrepair" })
                    end
                end
            end

            local TILLSOIL_IGNORE_TAGS = {"NOBLOCK", "player", "FX", "INLIMBO", "DECOR", "WALKABLEPLATFORM", "soil",
                                          "medal_farm_plow"}
            for i = 0, 2 do
                for k = 0, 2 do
                    local loction_x = NewX + 1.3 * i - 1.3
                    local loction_z = Newz + 1.3 * k - 1.3
                    if TheWorld.Map:IsDeployPointClear(Vector3(loction_x, 0, loction_z), nil, GetFarmTillSpacing(), nil,
                        nil, nil, TILLSOIL_IGNORE_TAGS) then
                        SpawnPrefab("farm_soil").Transform:SetPosition(loction_x, 0, loction_z)
                    end
                end
            end
            return true
        else
            return _Till(self, pt, doer)
        end
    end
end)

AddComponentPostInit("hunter", function(self, inst)
    local _beast_prefab_autumn = "beefalo"

    local _SpawnHuntedBeast = upvaluehelper.Get(self.OnDirtInvestigated, "SpawnHuntedBeast")
    local _GetSpawnPoint = upvaluehelper.Get(self.OnDirtInvestigated, "GetSpawnPoint")

    local SpawnHuntedBeast = function (hunt, pt)
        local spawn_pt = _GetSpawnPoint and _GetSpawnPoint(pt, TUNING.HUNT_SPAWN_DIST, hunt)
        if spawn_pt ~= nil then
            local spawn_x, spawn_y, spawn_z = spawn_pt:Get()
            
            -- 判断区域是否为皮弗娄牛草原
            local node, node_index = TheWorld.Map:FindVisualNodeAtPoint(spawn_x, spawn_y, spawn_z)
            local area_id = node_index~=nil and TheWorld.topology.ids[node_index] or nil
            local IsBeefalowPlain = area_id ~= nil and string.find(area_id, "Great Plains") or nil

            if not self:IsWargShrineActive() and TheWorld.state.isautumn and IsBeefalowPlain then
                local huntedbeast = SpawnPrefab(_beast_prefab_autumn)

                if huntedbeast ~= nil then
                    --print("Kill the Beast!")
                    huntedbeast.Physics:Teleport(spawn_x, spawn_y, spawn_z)
        
                    huntedbeast:PushEvent("spawnedforhunt")
                    return true
                end

            end
        end
        return _SpawnHuntedBeast and _SpawnHuntedBeast(hunt, pt)
    end

    upvaluehelper.Set(self.OnDirtInvestigated, "SpawnHuntedBeast", SpawnHuntedBeast)
end)

--[[
AddClassPostConstruct("components/inspectable", function(self)
    local _GetDescription = self.GetDescription
    function self:GetDescription(viewer)
        local desc, filter_context, author = _GetDescription(self, viewer)
        if viewer.components.ndnr_emo and
            self.inst.components.health and
            not self.inst:HasTag("monster") and
            not self.inst:HasTag("nightmarecreature") and
            (self.inst:HasTag("animal") or
                self.inst:HasTag("smallcreature") or
                self.inst:HasTag("largecreature") or
                self.inst:HasTag("character") or
                self.inst:HasTag("friendlyfruitfly") or
                self.inst:HasTag("glommer")) and
            viewer ~= nil then
                local delta = 0
                if self.inst:HasTag("playerghost") then
                    delta = -5
                elseif self.inst:HasTag("player") then
                    delta = 5
                else
                    delta = 2
                end
            if not viewer.components.ndnr_emo.hello[self.inst.GUID] then
                viewer.components.ndnr_emo:DoDelta(delta)
                viewer.components.ndnr_emo:SetHello(self.inst.GUID)
            end
        end
        return desc, filter_context, author
    end
end)

AddClassPostConstruct("components/sleepingbaguser", function(self)
    local _DoSleep = self.DoSleep
    function self:DoSleep(bed)
        _DoSleep(self, bed)

        if self.sleepemotask ~= nil then
            self.sleepemotask:Cancel()
        end
        self.sleepemotask = self.inst:DoPeriodicTask(self.bed.components.sleepingbag.tick_period, function()
            if self.bed.prefab == "hermithouse" and self.bed.components.spawner:IsOccupied() then
                if self.inst.components.ndnr_emo then
                    self.inst.components.ndnr_emo:DoDelta(0.5, nil, true)
                end
            end
        end)
    end

    local _DoWakeUp = self.DoWakeUp
    function self:DoWakeUp(nostatechange)
        _DoWakeUp(self, nostatechange)

        if self.sleepemotask ~= nil then
            self.sleepemotask:Cancel()
            self.sleepemotask = nil
        end
    end
end)
]]--

