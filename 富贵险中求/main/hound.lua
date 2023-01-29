
local function oneaten(inst, food)
    if food.prefab == "ndnr_dragoonheart" then
        local warg = SpawnPrefab("warg")
        warg.Transform:SetPosition(inst.Transform:GetWorldPosition())

        local fx = SpawnPrefab("collapse_big")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())

        warg.sg:GoToState("howl")
        inst:Remove()
    end
end

AddPrefabPostInit("hound", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    if inst.components.eater ~= nil then
        inst.components.eater:SetOnEatFn(oneaten)
    end
end)