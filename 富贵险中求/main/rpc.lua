--[[
    官方的RPC介绍帖子：https://forums.kleientertainment.com/forums/topic/122473-new-modding-rpcs-api/
]]

--[[
    ShardRPC用法
    -- 声明
    AddShardModRPCHandler("ndnr", "cusrpcid", function(shard_id, data)
        -- do staff
    end)

    -- 触发
    SendModRPCToShard(GetShardModRPC("ndnr", "cusrpcid"), nil, "data")
]]

--[[
    获取所有shard的id
    local connected_shards = Shard_GetConnectedShards()
    That returns a table where each key is the shard ID, and the value contains a bit of info about the connected world,
    for information about what data is in the table, you can view scripts/shardnetworking.lua.
]]