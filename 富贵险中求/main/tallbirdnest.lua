local function onbuilt(inst)
    inst.components.pickable:MakeEmpty()
end

AddPrefabPostInit("tallbirdnest", function(inst)
    if not TheWorld.ismastersim then return inst end

    inst:ListenForEvent("onbuilt", onbuilt)
end)