
local function ndnr_experimentfn(inst, doer)
    local x,y,z = inst.Transform:GetWorldPosition()

    -- local fx = SpawnPrefab("collapse_small")
    -- fx.Transform:SetPosition(x,y,z)

    if not TheWorld.Map:IsOceanAtPoint(x,y,z, false) then
        -- 使用铥矿雕像在洞穴暴动阶段转变时的声音和动画
        doer.SoundEmitter:PlaySound("dontstarve/common/ghost_spawn")
        local fx = SpawnPrefab("statue_transition_2")
        if fx ~= nil then
            fx.Transform:SetPosition(x, y, z)
            fx.Transform:SetScale(1, 2, 1)
        end
        fx = SpawnPrefab("statue_transition")
        if fx ~= nil then
            fx.Transform:SetPosition(x, y, z)
            fx.Transform:SetScale(1, 1.5, 1)
        end

        -- 生成虫洞
        local wormhole = SpawnPrefab("ndnr_wormhole")
        wormhole.Transform:SetPosition(x,y,z)

        -- 尝试配对
        local singlewormhole = _FindEntity(function(item)
            return item.prefab == "ndnr_wormhole" and item.components.teleporter.targetTeleporter == nil
        end)

        if #singlewormhole > 0 then -- 遍历所有未配对的虫洞，与找到的第一个非自身的虫洞配对
            for i = 1, #singlewormhole do
                if singlewormhole[i] ~= wormhole then
                    wormhole.components.teleporter.targetTeleporter = singlewormhole[i]
                    singlewormhole[i].components.teleporter.targetTeleporter = wormhole
                    break
                end
            end
        end

        inst:Remove()
        return true
    else
        return false, "WORMHOLE_CANT_ONWATER"
    end

end

AddPrefabPostInit("krampus_sack", function(inst)
    inst:AddTag("ndnr_canexperiment")
    if not TheWorld.ismastersim then return inst end

    inst.ndnr_experimentfn = ndnr_experimentfn

end)

--[[
local wormholes = {}
for k,v in pairs(Ents) do
    if v.prefab == "ndnr_wormhole" then
        table.insert(wormholes, v)
    end
end
c_announce(#wormholes)

-- c_announce
-- and item.components.teleporter.targetTeleporter == nil
]]