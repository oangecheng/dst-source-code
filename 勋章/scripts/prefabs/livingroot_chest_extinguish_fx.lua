local assets =
{
    Asset("ANIM", "anim/stagehand.zip"),
    -- Asset("ANIM", "anim/mossling_build.zip"),
    -- Asset("ANIM", "anim/mossling_actions.zip"),
}

local function fn(anim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.AnimState:SetBank("stagehand")
    inst.AnimState:SetBuild("stagehand")
    inst.AnimState:PlayAnimation("extinguish")
    inst.AnimState:HideSymbol("swap_flower")
    inst.AnimState:HideSymbol("stagehand_base")
    inst.AnimState:HideSymbol("stagehand_rope")
    inst.AnimState:HideSymbol("swap_vase")
    inst.AnimState:HideSymbol("stagehand_top")
    inst.AnimState:SetFinalOffset(3)

    -- inst.AnimState:SetBank("mossling")
    -- inst.AnimState:SetBuild("mossling_build")
    -- inst.AnimState:PlayAnimation("spin_pst_loop",true)
    -- inst.AnimState:HideSymbol("mossling_wing")
    -- inst.AnimState:HideSymbol("mossling_leg")
    -- inst.AnimState:HideSymbol("mossling_body")
    -- inst.AnimState:HideSymbol("mossling_head")
    -- inst.AnimState:HideSymbol("mossling_neck")
    -- inst.AnimState:SetFinalOffset(-1)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    
    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

return Prefab("livingroot_chest_extinguish_fx", fn, assets)
