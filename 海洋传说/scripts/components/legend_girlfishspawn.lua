local function DoTickTask(self, inst)
    if not (IsSimPaused() or TheWorld.components.legend_girlfishspawn.targettime ~= nil) then
        self.time  = self.time + 1
        if self.time > 4 then
            self:Check()
            self.time = 0
        end
    end
end
local legend_girlfishspawn = Class(function(self, inst)
    self.inst = inst
    self.time = 0
    self.targettime = nil
    self.task = nil
    self.cdtime = 7 * TUNING.PERISH_ONE_DAY
end)

function legend_girlfishspawn:SetPlayer()
    if not TheWorld.has_ocean then 
        return
    end
    if TheWorld.components.legend_girlfishspawn.targettime ~= nil then
        return
    end
    if not self.time_task then
        self.time_task = self.inst:DoPeriodicTask(1, function(inst) DoTickTask(self, inst) end)
    end
end

function legend_girlfishspawn:StopPlayer()
    if self.time_task then
        self.time_task:Cancel()
        self.time_task = nil
    end
end

function legend_girlfishspawn:Check(item)
    local x,y,z = self.inst.Transform:GetWorldPosition()
	for k1 = -5,5 do
		for k2 = -5,5 do
            local tile = TheWorld.Map:GetTileAtPoint(x+k1*4, 0, z+k2*4)
            if not TileGroupManager:IsOceanTile(tile) then
                return
            end
        end
    end
    if math.random() < 0.1 then --10%概率
        TheWorld.components.legend_girlfishspawn:TryToSpawn(x, y, z)
    end
end

local function NoHoles(pt)
    return not TheWorld.Map:IsPointNearHole(pt)
end

local function spawnwaves(inst, numWaves, totalAngle, waveSpeed, wavePrefab, initialOffset, idleTime, instantActivate, random_angle)
    SpawnAttackWaves(
        inst:GetPosition(),
        (not random_angle and inst.Transform:GetRotation()) or nil,
        initialOffset or (inst.Physics and inst.Physics:GetRadius()) or nil,
        numWaves,
        totalAngle,
        waveSpeed,
        wavePrefab,
        idleTime,
        instantActivate
    )
end

local function done(inst, self)
    self.task = nil
    self.targettime = nil

    for i,v in ipairs(AllPlayers) do
        if v.components.legend_girlfishspawn then
            v.components.legend_girlfishspawn:SetPlayer()
        end
    end
end

function legend_girlfishspawn:TryToSpawn(x, y, z)
    local pt = Vector3(x, y, z)
    local offset = FindSwimmableOffset(pt, math.random() * 2 * PI, math.random(25,30), 20, false, true, NoHoles)
    if offset then
        local girl = SpawnPrefab("lg_fishgirl")
        girl.Transform:SetPosition(x+offset.x,0,z+offset.z)
        spawnwaves(girl, 6, 360, 6, nil, nil, 1, nil, true)
        for i,v in ipairs(AllPlayers) do
            if v.components.legend_girlfishspawn then
                v.components.legend_girlfishspawn:StopPlayer()
            end
        end
        --girl.SoundEmitter:PlaySound("TZ_MOD/TZKJ/zhizuo")
        self.targettime =  GetTime() + self.cdtime
        self.task = self.inst:DoTaskInTime(self.cdtime, done, self)
    end
end

function legend_girlfishspawn:OnSave()
    local remainingtime = self.targettime ~= nil and self.targettime - GetTime() or 0
    return
    {
        remainingtime = remainingtime > 0 and remainingtime or nil,
    }
end

function legend_girlfishspawn:OnLoad(data)
    if data.remainingtime ~= nil then
        self.targettime = GetTime() + math.max(0, data.remainingtime)
        self.task = self.inst:DoTaskInTime(data.remainingtime, done, self)
    end
end
function legend_girlfishspawn:LongUpdate(dt)
    if dt > 0 and self.targettime ~= nil then
        if self.task ~= nil then
            self.task:Cancel()
        end
        if self.targettime - dt > GetTime() then
            self.targettime = self.targettime - dt
            self.task = self.inst:DoTaskInTime(self.targettime - GetTime(), done, self)
        else
            done(self.inst, self)
        end
    end
end

return legend_girlfishspawn