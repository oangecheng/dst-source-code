
local function ndnr_experimentfn(inst, doer)
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())

    local shadowhambet = SpawnPrefab("ndnr_hambat")
    shadowhambet.Transform:SetPosition(inst.Transform:GetWorldPosition())

    inst:Remove()
    return true
end

AddPrefabPostInit("hambat", function(inst)
    inst:AddTag("ndnr_canexperiment")
    if not TheWorld.ismastersim then
        return inst
    end

    inst.ndnr_experimentfn = ndnr_experimentfn

end)