function TableHasValue(tabl, value)
    for i, v in pairs(tabl) do
        if v == value then return true end
    end
    return false
end

function GetGender(prefab)
    for gender, characters in pairs(CHARACTER_GENDERS) do
        if TableHasValue(characters, prefab) then
            return gender
        end
    end
    return "NEUTRAL"
end

function Split(s, p)
    local rt = {}
    string.gsub(s, '[^'..p..']+', function(w) table.insert(rt, w) end)
    return rt
end

function SpawnCreature(prefabname, radius, num, pot, timeout, target, sg)
    local random_angle = 360*math.random()
    for i = 1, num do
        local xr = pot.x + math.floor(radius*math.cos(math.rad(i*math.floor(360/num) + random_angle)))
        local zr = pot.z + math.floor(radius*math.sin(math.rad(i*math.floor(360/num) + random_angle)))
        local ent = SpawnPrefab(prefabname)
        ent.Transform:SetPosition(xr, pot.y, zr)

        if timeout then ent:DoTaskInTime(timeout, ent.Remove) end
        if target then ent.components.combat:SetTarget(target) end
        if sg then ent.sg:GoToState("attack") end
    end
end

function _FindEntity(fn)
    local _ents = {}
    for k,v in pairs(Ents) do
        if fn(v) then
            table.insert(_ents, v)
        end
    end
    return _ents
end

function GetUUID()
    local seed={'e','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'}
    local tb={}
    for i=1,32 do
        table.insert(tb,seed[math.random(1,16)])
    end
    local sid=table.concat(tb)
    return string.format('%s-%s-%s-%s-%s',
        string.sub(sid,1,8),
        string.sub(sid,9,12),
        string.sub(sid,13,16),
        string.sub(sid,17,20),
        string.sub(sid,21,32)
    )
end