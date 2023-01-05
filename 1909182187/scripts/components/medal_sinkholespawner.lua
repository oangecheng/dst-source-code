local Medal_SinkholeSpawner = Class(function(self, inst)
    self.inst = inst
    self.targets = {}--目标登记表
    self.teleportpos = nil--传送点坐标
end)
--根据useid获取客户端玩家对应的主机数据
local function GetPlayerFromClientTable(c)
    for _, v in ipairs(AllPlayers) do
        if v.userid == c.userid then
            return v
        end
    end
end
--判断目标位置是否满足地陷生成条件
local function IsVisualPos(target)
    local pt = Vector3(target.Transform:GetWorldPosition())
    --坐标有效
    if TheWorld.Map:IsVisualGroundAtPoint(pt.x,pt.y,pt.z) then
        --并且不在时空风暴里
        if not (TheWorld.net.components.medal_spacetimestorms ~= nil and TheWorld.net.components.medal_spacetimestorms:IsPointInSpacetimestorm(pt)) then
            return true
        end
    end
    return false
end
--常规检查函数
local function customcheckfn(pt)
	--坐标点处于时空风暴中
	return TheWorld.net.components.medal_spacetimestorms ~= nil and TheWorld.net.components.medal_spacetimestorms:IsPointInSpacetimestorm(pt) or false
end

--更新传送坐标点
function Medal_SinkholeSpawner:UpdateTeleportPos()
    local dpos = Vector3(self.inst.Transform:GetWorldPosition())
    local pos = FindWalkableOffset(dpos, math.random()*2*PI, 10, 16, true, nil, customcheckfn)
    if pos then
        self.teleportpos=dpos+pos
    end
end

--开始地陷
function Medal_SinkholeSpawner:StartSinkholes()
    -- print("好戏开始咯")
    local target_players={}--玩家列表
    --遍历客户端玩家列表(包括不在一个服务器的玩家)
    for i, v in ipairs(TheNet:GetClientTable() or {}) do
		local player = GetPlayerFromClientTable(v)
        --确保本服的玩家所处的位置是有效的,非本服的先不管三七二十一加进来再说
        if #v.prefab > 0 and (player == nil or IsVisualPos(player)) then
            table.insert(target_players,v)
        end
    end

    if #target_players > 0 then
        self:UpdateTeleportPos()--更新传送坐标点
        --遍历天选之子列表
        for i, v in pairs(target_players) do
            --登记受害人信息
            local targetinfo =
            {
                client = v,--玩家客户端信息表
                -- userhash = smallhash(v.userid),--玩家ID的哈希串
                attacks = 1,--地陷数量
            }
            self:UpdateTarget(targetinfo)--更新目标信息
            if targetinfo.client ~= nil then
                table.insert(self.targets, targetinfo)--把新目标加进去
                self:DoTargetWarning(targetinfo)--开始警告了哦
            end
        end

        self:PushRemoteTargets()--推送跨服打击数据
        --目标数量大于0
        if #self.targets > 0 then
            self.inst:StartUpdatingComponent(self)--开始更新组件
			self.inst:PushEvent("onsinkholesstarted")--推送开始地陷的事件
        end
    end
end
--停止地陷
function Medal_SinkholeSpawner:StopSinkholes()
    while #self.targets > 0 do
        table.remove(self.targets)--移除所有的攻击目标
        self.inst:StopUpdatingComponent(self)--停止更新组件
    end

	self.inst:PushEvent("onsinkholesfinished")--推送停止地陷的事件
    self:PushRemoteTargets()--推送跨服打击数据
end
--更新目标信息
function Medal_SinkholeSpawner:UpdateTarget(targetinfo)
    --遍历本服的玩家列表
    for i1, v1 in ipairs(AllPlayers) do
        --如果玩家在当前服务器，则标记他的主机身份，并记录他的坐标
        if v1.userid == targetinfo.client.userid then
            targetinfo.player = v1
            targetinfo.pos = v1:GetPosition()
            return
        end
    end
    targetinfo.player = nil--不在当前服务器了，那数据就好删掉了
    --V2C: TheShard:IsMigrating(userid) only works on master shard
    --不在当前世界并且不处于跨服中的状态，pos也清掉吧
    if targetinfo.pos ~= nil and not TheShard:IsMigrating(targetinfo.client.userid) then
        targetinfo.pos = nil
    end
end

local WARNING_RADIUS = 3.5--警告范围
--开始警告
function Medal_SinkholeSpawner:DoTargetWarning(targetinfo)
    if targetinfo.warnings == nil then
        targetinfo.warnings = TUNING.ANTLION_SINKHOLE.NUM_WARNINGS--警告次数,12次(这么多的么)
        targetinfo.next_warning = math.random() * TUNING.ANTLION_SINKHOLE.WARNING_DELAY_VARIANCE--下一波警告的延迟时间偏差值
    elseif targetinfo.warnings >= 0 then
        if targetinfo.pos ~= nil then--目标坐标点不为空，那就开始了噢
            --Handle locally摇晃起来
            ShakeAllCameras(CAMERASHAKE.SIDE, TUNING.ANTLION_SINKHOLE.WARNING_DELAY, .04, .05, targetinfo.pos, 6)
            --大地颤抖的特效,生成量=(13-警告次数)/3.2向上取整,也就是每警告3次特效次数就多1
			for i = 1, math.ceil((TUNING.ANTLION_SINKHOLE.NUM_WARNINGS - (targetinfo.warnings or 0) + 1) / 3.2) do
				local fxpt = targetinfo.pos + Vector3((math.random() * (WARNING_RADIUS*2)) - WARNING_RADIUS, 0, (math.random() * (WARNING_RADIUS*2)) - WARNING_RADIUS)
				local rocks = SpawnPrefab("sinkhole_warn_fx_"..math.random(3)).Transform:SetPosition(fxpt:Get())
			end
            --警告次数是4的倍数的时候，玩家发表感叹词
            if ((targetinfo.warnings or 0) % 4 == 0) and targetinfo.player ~= nil and targetinfo.player:IsValid() then
                MedalSay(targetinfo.player,STRINGS.DELIVERYSPEECH.COMING)
            end
        end
        --警告次数-1
        targetinfo.warnings = targetinfo.warnings - 1
		--警告次数用完了
        if targetinfo.warnings <= 0 or targetinfo.client == nil then
            targetinfo.warnings = nil
            targetinfo.next_warning = nil
            targetinfo.next_attack = TUNING.ANTLION_SINKHOLE.WARNING_DELAY + math.random() * TUNING.ANTLION_SINKHOLE.WARNING_DELAY_VARIANCE--下一波就是攻击了噢
        else
            targetinfo.next_warning = TUNING.ANTLION_SINKHOLE.WARNING_DELAY + math.random() * TUNING.ANTLION_SINKHOLE.WARNING_DELAY_VARIANCE--下一波警告延迟
        end
    end
end
--攻击
function Medal_SinkholeSpawner:DoTargetAttack(targetinfo)
    --目标Pos不为空(说明确实是本世界的)
    if targetinfo.pos ~= nil then
        --Handle locally
        targetinfo.attacks = targetinfo.attacks - 1--消耗一次地陷数量
        --下个地陷坑的延迟=0.75+(0~1)
        targetinfo.next_attack = targetinfo.attacks > 0 and TUNING.ANTLION_SINKHOLE.WAVE_ATTACK_DELAY + math.random() * TUNING.ANTLION_SINKHOLE.WAVE_ATTACK_DELAY_VARIANCE or nil
        --两个玩家靠的太近了就只生成一个
        for i, v in ipairs(self.targets) do
            if v ~= targetinfo and v.pos ~= nil and v.pos:DistSq(targetinfo.pos) < TUNING.ANTLION_SINKHOLE.WAVE_MERGE_ATTACKS_DIST_SQ then
                --Skip attack
                return
            end
        end
        self:SpawnSinkhole(targetinfo.pos)--生成地陷
    else
        --Remote attacks only once
        targetinfo.attacks = 0--跨服打击没有地陷数量的说法
        targetinfo.next_attack = nil
    end
end

local SINKHOLD_BLOCKER_TAGS = { "antlion_sinkhole_blocker" }
--生成地陷
function Medal_SinkholeSpawner:SpawnSinkhole(spawnpt)
    local x = GetRandomWithVariance(spawnpt.x, TUNING.ANTLION_SINKHOLE.RADIUS)--x坐标(在小范围内随机偏移)
    local z = GetRandomWithVariance(spawnpt.z, TUNING.ANTLION_SINKHOLE.RADIUS)--z坐标(在小范围内随机偏移)
    --是有效的地陷生成点
    local function IsValidSinkholePosition(offset)
        local x1, z1 = x + offset.x, z + offset.z
        if #TheSim:FindEntities(x1, 0, z1, TUNING.ANTLION_SINKHOLE.RADIUS * 1.9, SINKHOLD_BLOCKER_TAGS) > 0 then
            return false
        end
        for dx = -1, 1 do
            for dz = -1, 1 do
                if not TheWorld.Map:IsPassableAtPoint(x1 + dx * TUNING.ANTLION_SINKHOLE.RADIUS, 0, z1 + dz * TUNING.ANTLION_SINKHOLE.RADIUS, false, true) then
                    return false
                end
            end
        end
        return true
    end

    local offset = Vector3(0, 0, 0)--坐标修正
    offset =--由近到远尝试找到有效的地陷生成点
        IsValidSinkholePosition(offset) and offset or
        FindValidPositionByFan(math.random() * 2 * PI, TUNING.ANTLION_SINKHOLE.RADIUS * 1.8 + math.random(), 9, IsValidSinkholePosition) or
        FindValidPositionByFan(math.random() * 2 * PI, TUNING.ANTLION_SINKHOLE.RADIUS * 2.9 + math.random(), 17, IsValidSinkholePosition) or
        FindValidPositionByFan(math.random() * 2 * PI, TUNING.ANTLION_SINKHOLE.RADIUS * 3.9 + math.random(), 17, IsValidSinkholePosition) or
        nil

    if offset ~= nil then
        local sinkhole = SpawnPrefab("medal_sinkhole")--生成地陷
        sinkhole.Transform:SetPosition(x + offset.x, 0, z + offset.z)
        self:UpdateTeleportPos()--更新传送坐标点
        sinkhole:PushEvent("startcollapse",{pos=self.teleportpos})--开始塌陷
    end
end
--推送跨服打击数据，犯我者，虽远必诛
function Medal_SinkholeSpawner:PushRemoteTargets()
    if self.teleportpos == nil then
        self:UpdateTeleportPos()--更新传送坐标点
    end
    local data = {}
    for i, v in ipairs(self.targets) do--遍历目标列表
        if v.pos == nil then--目标没有坐标点，说明目标不在当前世界
            local warn = v.next_warning ~= nil and v.next_warning <= 0--待警告
            local attack = not warn and v.next_attack ~= nil and v.next_attack <= 0--待攻击
            data.worldid = TheShard:GetShardId()--世界ID
            data.x = self.teleportpos and self.teleportpos.x or nil--传送坐标x
            data.z = self.teleportpos and self.teleportpos.z or nil--传送坐标z
            data.warn = warn or nil
            data.attack = attack or nil
            break--是的，跨服攻击共用警告和攻击时间
        end
    end
    if next(data) ~= nil then
        TheWorld:PushEvent("master_medalsinkholesupdate", data)--推送地陷事件(由shard_medalsinkholes来监听和分发)
    end
end
--更新
function Medal_SinkholeSpawner:OnUpdate(dt)
    local towarn = {}--待警告的目标列表
    local toattack = {}--待攻击的目标列表
    --遍历目标列表
    for i, v in ipairs(self.targets) do
        if v.client ~= nil then--客户端信息肯定是有的
            --是当前世界的玩家
            if v.player ~= nil and v.player:IsValid() then
				if not TheWorld.has_ocean or TheWorld.Map:IsVisualGroundAtPoint(v.player.Transform:GetWorldPosition()) then
	                v.pos.x, v.pos.y, v.pos.z = v.player.Transform:GetWorldPosition()--获取玩家坐标
				end
            else
                v.client = TheNet:GetClientTableForUser(v.client.userid)
                if v.client ~= nil and #v.client.prefab > 0 then
                    self:UpdateTarget(v)--更新目标信息
                else
                    v.client = nil
                    v.player = nil
                end
            end
        end
        if v.next_warning ~= nil then
            v.next_warning = v.next_warning - dt
            if v.next_warning <= 0 then
                table.insert(towarn, v)--刷新警告剩余时间，到时间了就准备警告了
            end
        elseif v.next_attack ~= nil then
            v.next_attack = v.next_attack - dt
            if v.next_attack <= 0 then
                table.insert(toattack, 1, { i, v })--刷新攻击剩余时间，到时间了就准备攻击了
            end
        end
    end

    self:PushRemoteTargets()--推送跨服打击数据
    --警告一波
    for i, v in ipairs(towarn) do
        self:DoTargetWarning(v)
    end
    --攻击了
    for i, v in ipairs(toattack) do
        self:DoTargetAttack(v[2])
        if v[2].attacks <= 0 then--地陷数量不够的话就算了
            table.remove(self.targets, v[1])
        end
    end
    --没目标了？
    if #self.targets <= 0 then
        self.inst:StopUpdatingComponent(self)--停止更新组件
        self.inst:PushEvent("onsinkholesfinished")
    end
end
--存储
function Medal_SinkholeSpawner:OnSave()
    if #self.targets > 0 then
        local data = {}
        for i, v in ipairs(self.targets) do
            if v.pos ~= nil then
                table.insert(data, {
                    x = v.pos.x,
                    z = v.pos.z,
                    attacks = v.attacks,
                    next_attack = v.next_attack ~= nil and math.floor(v.next_attack) or nil,
                    next_warning = v.next_warning ~= nil and math.floor(v.next_warning) or nil,
                })
            end
        end
        return #data > 0 and { targets = data } or nil
    end
end
--加载
function Medal_SinkholeSpawner:OnLoad(data)
    if data.targets ~= nil then
        for i, v in ipairs(data.targets) do
            if (v.attacks or 0) > 0 and v.x ~= nil and v.z ~= nil then
                local targetinfo =
                {
                    pos = Vector3(v.x, 0, v.z),
                    attacks = v.attacks,
                    next_attack = v.next_attack,
                    warnings = 0,
                    next_warning = v.next_warning,
                }
                table.insert(self.targets, targetinfo)
            end
        end

        self:PushRemoteTargets()--推送跨服打击数据

        if #self.targets > 0 then
            self.inst:StartUpdatingComponent(self)--开始更新组件
            self.inst:PushEvent("onsinkholesstarted")
        end
    end
end

function Medal_SinkholeSpawner:GetDebugString()
    local s
    for i, v in ipairs(self.targets) do
        if v.next_warning ~= nil then
            s = (s ~= nil and (s.."\n") or "")..string.format("  Warning %s (%d/%d) at (%.1f, %.1f) in %.2fs", tostring(v.player), TUNING.ANTLION_SINKHOLE.NUM_WARNINGS - v.warnings, TUNING.ANTLION_SINKHOLE.NUM_WARNINGS, v.pos ~= nil and v.pos.x or 0, v.pos ~= nil and v.pos.z or 0, v.next_warning)
        elseif v.next_attack ~= nil then
            s = (s ~= nil and (s.."\n") or "")..string.format("  Attacking %s (%d/%d) at (%.1f, %.1f) in %.2fs", tostring(v.player), TUNING.ANTLION_SINKHOLE.WAVE_MAX_ATTACKS - v.attacks, TUNING.ANTLION_SINKHOLE.WAVE_MAX_ATTACKS, v.pos ~= nil and v.pos.x or 0, v.pos ~= nil and v.pos.z or 0, v.next_attack)
        end
    end
    return s
end

return Medal_SinkholeSpawner
