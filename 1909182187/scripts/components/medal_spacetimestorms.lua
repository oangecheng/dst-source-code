--------------------------------------------------------------------------
--[[ Spacetimestorms class definition ]]
--------------------------------------------------------------------------
--时空风暴组件
return Class(function(self, inst)

--assert(TheWorld.ismastersim, "Spacetimestorms should not exist on client")

--------------------------------------------------------------------------
--[[ Member variables ]]
--------------------------------------------------------------------------

--Public
self.inst = inst

--Private

local _active_spacetimestorm_nodes = {}--激活状态的时空风暴节点记录表
local _mapmarkers = {}--地图标记记录表
--网络变量(时空风暴节点)
self._spacetimestorm_nodes = net_bytearray(inst.GUID, "spacetimestorm.spacetimestorm_nodes", "spacetimestorm_nodes_dirty")
--风暴节点发生变更，推送对应的传播事件(主要用来控制时空风暴中电流组件的开关)
self.inst:ListenForEvent("spacetimestorm_nodes_dirty", function(w,data)
    TheWorld:PushEvent("spacetimestorm_nodes_dirty_relay",data)
end)

--------------------------------------------------------------------------
--[[ Private member functions ]]
--------------------------------------------------------------------------
--数据转换，把{aa=true,bb=true}的表转成{"aa","bb"}格式
local function convertlist(data)
    local newdat = {}
    for i,entry in pairs(data)do
        if entry== true then
            table.insert(newdat,i)
        end
    end
    return newdat
end
self.convertlist = convertlist
--------------------------------------------------------------------------
--[[ Private event handlers ]]
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--[[ Initialization ]]
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--[[ Public member functions ]]
--------------------------------------------------------------------------

-- assumes pos is within node_index. The caller must ensure this!
--计算风暴标记节点深度(坐标点,节点索引)
local function CalcTaggedNodeDepthSq(pos, node_index)
    pos = { x = pos.x, y = pos.z }

    local depth = math.huge
    local node_edges = TheWorld.topology.nodes[node_index].validedges--节点边界
    for _, edge_index in ipairs(node_edges) do
        local edge_nodes = TheWorld.topology.edgeToNodes[edge_index]
        local other_node_index = edge_nodes[1] ~= node_index and edge_nodes[1] or edge_nodes[2]
        if not _active_spacetimestorm_nodes[other_node_index] then
            local point_indices = TheWorld.topology.flattenedEdges[edge_index]
            local node1 = { x = TheWorld.topology.flattenedPoints[point_indices[1]][1], y = TheWorld.topology.flattenedPoints[point_indices[1]][2] }
            local node2 = { x = TheWorld.topology.flattenedPoints[point_indices[2]][1], y = TheWorld.topology.flattenedPoints[point_indices[2]][2] }

            depth = math.min(depth, DistPointToSegmentXYSq(pos, node1, node2))
        end
    end

    return depth
end

--计算时空风暴等级
function self:CalcSpacetimestormLevel(ent)
    return ent ~= nil
        and not TheWorld.Map:IsOceanAtPoint(ent:GetPosition():Get())
        and ent.components.areaaware ~= nil
        and math.min(math.sqrt(CalcTaggedNodeDepthSq(ent.components.areaaware.lastpt, ent.components.areaaware.current_area)), TUNING.SANDSTORM_FULLY_ENTERED_DEPTH) / TUNING.SANDSTORM_FULLY_ENTERED_DEPTH
        or 0
end
--在时空风暴中
function self:IsInSpacetimestorm(ent)
    return next(_active_spacetimestorm_nodes) ~= nil
        and ent.components.areaaware ~= nil
        and _active_spacetimestorm_nodes[ent.components.areaaware.current_area]
end
--当前坐标是否处于时空风暴中
function self:IsPointInSpacetimestorm(pt)
	local node_index = TheWorld.Map:GetNodeIdAtPoint(pt.x, 0, pt.z)
    return node_index ~= nil
        and _active_spacetimestorm_nodes[node_index]
        or false
end
--获取时空风暴等级
function self:GetSpacetimestormLevel(ent)
    if self:IsInSpacetimestorm(ent) then
        return math.clamp(self:CalcSpacetimestormLevel(ent), 0, 1)
    end
    return 0
end
--添加时空风暴节点(节点索引,初始节点)
function self:AddSpacetimestormNodes(node_indices, firstnode)
    -- if type(node_indices) ~= "table" then
    --     node_indice = { node_indices }--这里包起来却不用，有点意义不明
    -- end
    --遍历节点索引表
    for _, v in ipairs(node_indices) do
        _active_spacetimestorm_nodes[v] = true--把节点添加到记录表中

        -- local marker = SpawnPrefab("spacetimestormmarker_big")--生成时空风暴地图标记
        -- local marker = SpawnPrefab("moonstormmarker_big")--生成月亮风暴地图标记
        local marker = SpawnPrefab("medal_spacetimestormmarker")--生成时空风暴地图标记
     --   local center = TheWorld.topology.nodes[firstnode].cent
        local center = TheWorld.topology.nodes[v].cent
        marker.Transform:SetPosition(center[1], 0, center[2])
        table.insert(_mapmarkers, marker)--记录地图标记

    end

    self._spacetimestorm_nodes:set(convertlist(_active_spacetimestorm_nodes))--网络变量同步变更
    TheWorld:PushEvent("ms_stormchanged",{stormtype=STORM_TYPES.MEDAL_SPACETIMESTORM, setting=true})--推送风暴变更事件
    -- TheWorld:PushEvent("ms_spacetimestormwindowover")--推送事件，主要是控制天体装置状态的
end
--停止时空风暴(是否是迁移状态)
function self:StopSpacetimestorm(is_relocating)
    self:ClearSpacetimestormNodes()--清除时空风暴节点
    TheWorld:PushEvent("ms_stormchanged",{stormtype=STORM_TYPES.MEDAL_SPACETIMESTORM, setting=is_relocating == true})
end
--清除时空风暴节点
function self:ClearSpacetimestormNodes()
    _active_spacetimestorm_nodes = {}
    self._spacetimestorm_nodes:set(convertlist(_active_spacetimestorm_nodes))
    for i = #_mapmarkers, 1, -1 do
        _mapmarkers[i]:Remove()--移除地图标记
    end
    _mapmarkers = {}
end
--获取时空风暴节点
function self:GetSpacetimestormNodes()
    return _active_spacetimestorm_nodes
end
--获取时空风暴中心
function self:GetSpacetimestormCenter()
    local num_nodes = 0
    local x, y = 0, 0
    for k, v in pairs(_active_spacetimestorm_nodes) do
        local center = TheWorld.topology.nodes[k].cent

        x, y = x + center[1], y + center[2]
        num_nodes = num_nodes + 1
    end
    --所有的风暴节点的中心坐标加起来除以节点数量
    return num_nodes > 0 and Point(x / num_nodes, 0, y / num_nodes) or nil
end

--------------------------------------------------------------------------
--[[ End ]]
--------------------------------------------------------------------------

end)
