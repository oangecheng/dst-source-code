--获取有效生成点
local function getVisualPos(target)
    if target ~= nil then
        local pt = Vector3(target.Transform:GetWorldPosition())
        if TheWorld.Map:IsVisualGroundAtPoint(pt.x,pt.y,pt.z) then
            return pt
        end
    end
end

local WARNING_RADIUS = 3.5--警告范围
--开始警告(玩家,警告目标点)
local function DoTargetWarning(target)
    local targetpos = getVisualPos(target)
    if targetpos ~= nil then--目标坐标点不为空，那就开始了噢
		--Handle locally摇晃起来
		ShakeAllCameras(CAMERASHAKE.SIDE, TUNING.ANTLION_SINKHOLE.WARNING_DELAY, .04, .05, targetpos, 6)
		--大地颤抖的特效,生成量=(13-警告次数)/3.2向上取整,也就是每警告3次特效次数就多1
		for i = 1, 3 do
			local fxpt = targetpos + Vector3((math.random() * (WARNING_RADIUS*2)) - WARNING_RADIUS, 0, (math.random() * (WARNING_RADIUS*2)) - WARNING_RADIUS)
			local rocks = SpawnPrefab("sinkhole_warn_fx_"..math.random(3)).Transform:SetPosition(fxpt:Get())
		end
		--玩家发表感叹词
		if target ~= nil and target:IsValid() then
			target.medal_warning_times=target.medal_warning_times or 0
            if target.medal_warning_times==0 then
                MedalSay(target,STRINGS.DELIVERYSPEECH.COMING)
            end
            target.medal_warning_times = (target.medal_warning_times+1)%4
		end
	end
end

local SINKHOLD_BLOCKER_TAGS = { "antlion_sinkhole_blocker" }
--生成地陷
local function SpawnSinkhole(target,data)
    local targetpos = getVisualPos(target)
    if targetpos ~= nil then--目标坐标点不为空，那就开始了噢
        local x = GetRandomWithVariance(targetpos.x, TUNING.ANTLION_SINKHOLE.RADIUS)--x坐标(在小范围内随机偏移)
        local z = GetRandomWithVariance(targetpos.z, TUNING.ANTLION_SINKHOLE.RADIUS)--z坐标(在小范围内随机偏移)
        if target then target.medal_warning_times=nil end
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
            local teleportpos = (data and data.x and data.z) and Vector3(data.x,0,data.z) or nil
            local worldid = data and data.worldid or nil
            sinkhole:PushEvent("startcollapse",{pos=teleportpos,worldid=worldid})--开始塌陷
        end
    end
end

return {
    DoTargetWarning = DoTargetWarning,
    SpawnSinkhole = SpawnSinkhole,
}
