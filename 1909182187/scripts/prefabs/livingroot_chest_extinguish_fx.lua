local assets =
{
    Asset("ANIM", "anim/stagehand.zip"),
    Asset("ANIM", "anim/livingroot_chest_extinguish_fx.zip"),
}

local function MakeBookFX(anim)
    return function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.Transform:SetFourFaced()

        inst:AddTag("FX")

        inst.Transform:SetFourFaced()

        inst.AnimState:SetBank("stagehand")
        inst.AnimState:SetBuild("livingroot_chest_extinguish_fx")
        inst.AnimState:PlayAnimation(anim)
        --inst.AnimState:SetScale(1.5, 1, 1)
        inst.AnimState:SetFinalOffset(-1)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false

        --Anim is padded with extra blank frames at the end
        inst:ListenForEvent("animover", inst.Remove)

        return inst
    end
end

return Prefab("livingroot_chest_extinguish_fx", MakeBookFX("extinguish"), assets)
