local assets1 =
{
    Asset("ANIM", "anim/chang_e_myth.zip"),
}

local prefabs =
{
    -- "float_fx_front",
    -- "float_fx_back",
}

local function fn1()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    -- inst.Transform:SetScale(0.5, 0.5, 0.5)   --一旦这里改变动画大小，会导致火焰燃烧特效也跟着变化

    inst.AnimState:SetBank("chang_e_myth")
    inst.AnimState:SetBuild("chang_e_myth")
    inst.AnimState:PlayAnimation("idle", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")

    return inst
end

------

local assets2 =
{
    Asset("ANIM", "anim/chang_e_myth.zip"),
    -- Asset("ANIM", "anim/python.zip"),
}

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    -- inst.Transform:SetScale(0.5, 0.5, 0.5)   --一旦这里改变动画大小，会导致火焰燃烧特效也跟着变化

    inst.AnimState:SetBank("chang_e_myth")
    inst.AnimState:SetBuild("chang_e_myth")
    inst.AnimState:PlayAnimation("talk_long", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")

    return inst
end

-----

local function fn3()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    -- inst.Transform:SetScale(0.5, 0.5, 0.5)   --一旦这里改变动画大小，会导致火焰燃烧特效也跟着变化

    inst.AnimState:SetBank("chang_e_myth")
    inst.AnimState:SetBuild("chang_e_myth")
    inst.AnimState:PlayAnimation("refuse")
    inst.AnimState:PushAnimation("talk", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")

    return inst
end

local function fn4()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    -- inst.Transform:SetScale(0.5, 0.5, 0.5)   --一旦这里改变动画大小，会导致火焰燃烧特效也跟着变化

    inst.AnimState:SetBank("chang_e_myth")
    inst.AnimState:SetBuild("chang_e_myth")
    inst.AnimState:PlayAnimation("spell")
    inst.AnimState:PushAnimation("idle_blink", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")

    return inst
end

return Prefab("bugzapper", fn1, assets1, prefabs),
        Prefab("bugzapper2", fn2, assets2, prefabs),
        Prefab("bugzapper3", fn3, assets1, prefabs),
        Prefab("bugzapper4", fn4, assets1, prefabs)
