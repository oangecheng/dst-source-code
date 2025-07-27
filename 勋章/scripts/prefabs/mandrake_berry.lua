local assets =
{
    Asset("ANIM", "anim/mandark_berry.zip"),
}

local prefabs =
{
    "mandrakeberry",
}

local function KillPlant(inst)
    inst._killtask = nil
    inst.components.pickable.caninteractwith = false
    -- FadeOut(inst)
    inst:ListenForEvent("animover", inst.Remove)
    inst.AnimState:PlayAnimation("wilt")
end

local function OnBloomed(inst)
    inst:RemoveEventCallback("animover", OnBloomed)
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.components.pickable.caninteractwith = true
    inst._killtask = inst:DoTaskInTime(TUNING.STALKER_BLOOM_DECAY + math.random(), KillPlant)
end

local function OnPicked(inst, picker, loot)
    if inst._killtask ~= nil then
        inst._killtask:Cancel()
        inst._killtask = nil
    end
    -- FadeOut(inst, true)
    inst:RemoveEventCallback("animover", OnBloomed)
    inst:ListenForEvent("animover", inst.Remove)
    inst.AnimState:PlayAnimation("picked_wilt")
    if picker and picker:HasTag("has_plant_medal") then
        RewardToiler(picker, picker:HasTag("has_transplant_medal") and 0.02 or 0.01)--天道酬勤
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddPhysics()

    inst.AnimState:SetBank("forest_glowberry")
    inst.AnimState:SetBuild("mandark_berry")
    inst.AnimState:PlayAnimation("bloom")

    inst:AddTag("plant")
    inst:AddTag("mandarkbloom")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/stalker/flowergrow")

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
    inst.components.pickable.onpickedfn = OnPicked
    inst.components.pickable.caninteractwith = false
    inst.components.pickable:SetUp("mandrakeberry", 1000000)
    inst.components.pickable:Pause()

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")

    inst:ListenForEvent("animover", OnBloomed)

    ---------------------
    MakeMediumBurnable(inst)
    MakeSmallPropagator(inst)
    --Clear default handlers so we don't stomp our .persists flag
    inst.components.burnable:SetOnIgniteFn(nil)
    inst.components.burnable:SetOnExtinguishFn(nil)
    ---------------------

    MakeHauntableIgnite(inst)

    inst.persists = false

    return inst
end

return Prefab("mandrake_berry", fn, assets, prefabs)
