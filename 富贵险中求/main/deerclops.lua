local function UpdateSymbol(inst, data)
    inst:DoTaskInTime(FRAMES, function(inst)
        if inst.components.timer:TimerExists("deerclopspluckabletimer") then
            inst.AnimState:OverrideSymbol("deerclops_head", IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) and "deerclops_noeye_yule" or "deerclops_noeye", inst:IsSated() and "deerclops_head_neutral" or "deerclops_head")
        else
            inst.AnimState:OverrideSymbol("deerclops_head", IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) and "deerclops_yule" or "deerclops_build", inst:IsSated() and "deerclops_head_neutral" or "deerclops_head")
        end
    end)
end

AddPrefabPostInit("deerclops", function(inst)
    if not TheWorld.ismastersim then return inst end

    inst:DoTaskInTime(FRAMES, function(inst)
        inst:StopWatchingWorldState("stopwinter")
        inst.WantsToLeave = function() return false end
    end)

    inst:ListenForEvent("working", UpdateSymbol)
    inst:ListenForEvent("attacked", UpdateSymbol)
    inst:ListenForEvent("newcombattarget", UpdateSymbol)
end)