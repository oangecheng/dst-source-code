--------------------------------------------------------------------------
--[[ Shard_MedalSinkholes ]]
--------------------------------------------------------------------------

return Class(function(self, inst)

assert(TheWorld.ismastersim, "Shard_MedalSinkholes不应该出现在客户端上")

--------------------------------------------------------------------------
--[[ Constants ]]
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--[[ Member variables ]]
--------------------------------------------------------------------------

--Public
self.inst = inst

--Private
local _world = TheWorld
local _ismastershard = _world.ismastershard

--Network
local _worldid = net_int(inst.GUID, "shard_medalsinkholes._worldid", "medalsinkholesdirty")--世界ID,它是string类型的,划重点,要考的！
local _posx = net_shortint(inst.GUID, "shard_medalsinkholes._posx", "medalsinkholesdirty")--坐标x
local _posz = net_shortint(inst.GUID, "shard_medalsinkholes._posz", "medalsinkholesdirty")--坐标z
local _state = net_tinybyte(inst.GUID, "shard_medalsinkholes._state", "medalsinkholesdirty")--攻击状态,0无,1警告,2攻击

--------------------------------------------------------------------------
--[[ Private event listeners ]]
--------------------------------------------------------------------------

local OnSinkholesUpdate = _ismastershard and function(src, data)
    -- print(data.worldid,data.x,data.z,data.warn,data.attack)
    if _worldid:value() ~= data.worldid then
        _worldid:set(tonumber(data.worldid))
    end

    if data.x and _posx:value() ~= data.x then
        _posx:set(math.ceil(data.x))
    end

    if data.z and _posz:value() ~= data.z then
        _posz:set(math.ceil(data.z))
    end

    if data.warn then
        _state:set_local(1)
        _state:set(1)
    elseif data.attack then
        _state:set(2)
    elseif _state:value() ~= 1 then
        _state:set(0)
    end
end or nil

local OnSinkholesDirty = not _ismastershard and function()
    local data = {
        worldid = _worldid:value(),
        x = _posx:value(),
        z = _posz:value(),
        warn = _state:value() == 1 or nil,
        attack = _state:value() == 2 or nil,
    }
    -- print(data.worldid,data.x,data.z,data.warn,data.attack)
    _world:PushEvent("secondary_medalsinkholesupdate", data)
end or nil

--------------------------------------------------------------------------
--[[ Initialization ]]
--------------------------------------------------------------------------

if _ismastershard then
    --监听主世界的世界推送
    inst:ListenForEvent("master_medalsinkholesupdate", OnSinkholesUpdate, _world)
else
    --监听网络变量变动
    inst:ListenForEvent("medalsinkholesdirty", OnSinkholesDirty)
end

--------------------------------------------------------------------------
--[[ End ]]
--------------------------------------------------------------------------

end)
