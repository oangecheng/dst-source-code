local assets = {
    Asset("ANIM", "anim/explodingfruitcake.zip"),
    Asset("ATLAS", "images/inventoryimages/explodingfruitcake.xml"),
    Asset("IMAGE", "images/inventoryimages/explodingfruitcake.tex")
}

local prefabs = {
    "explode_fruitcake"
}

local function OnIgniteFn(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_fuse_LP", "hiss")
    DefaultBurnFn(inst)
end
local function OnExtinguishFn(inst)
    inst.SoundEmitter:KillSound("hiss")
    DefaultExtinguishFn(inst)
end
local function OnExplodeFn(inst)
    inst.SoundEmitter:KillSound("hiss")
    local fx = SpawnPrefab("explode_fruitcake")
    if fx ~= nil then
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    end
end

local function OnPutInInv(inst, owner)
    if owner.prefab == "mole" then
        inst.components.explosive:OnBurnt()
    end
end

local function OnEaten(inst, eater) --注意：该函数执行后，才会执行食物的删除操作
    --如果是一次性吃完类型的对象，直接爆炸吧，反正都要整体删除了
    if eater.components.eater and eater.components.eater.eatwholestack then
        inst.components.explosive:OnBurnt()
        return
    end

    --由于食用时会主动消耗一个，而爆炸会消耗全部，为了达到一次吃只炸一个的效果，新生成一个完成爆炸效果
    eater:DoTaskInTime(1.5+math.random(), function()
        if eater:IsValid() and not eater:IsInLimbo() then
            local cake = SpawnPrefab("explodingfruitcake")
            cake.Transform:SetPosition(eater.Transform:GetWorldPosition())
            cake.components.explosive:OnBurnt()
        end
    end)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("explodingfruitcake")
    inst.AnimState:SetBuild("explodingfruitcake")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("molebait")
    inst:AddTag("explosive")
    inst:AddTag("pre-preparedfood")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("inspectable")

    MakeSmallBurnable(inst, 3 + math.random() * 3)
    MakeSmallPropagator(inst)
    --V2C: Remove default OnBurnt handler, as it conflicts with
    --explosive component's OnBurnt handler for removing itself
    inst.components.burnable:SetOnBurntFn(nil)
    inst.components.burnable:SetOnIgniteFn(OnIgniteFn)
    inst.components.burnable:SetOnExtinguishFn(OnExtinguishFn)

    inst:AddComponent("explosive")
    inst.components.explosive:SetOnExplodeFn(OnExplodeFn)
    inst.components.explosive.explosivedamage = 500 --火药伤害200
    inst.components.explosive.lightonexplode = false --不会点燃被炸者
    inst.components.explosive.explosiverange = 3.5

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "explodingfruitcake"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/explodingfruitcake.xml"
    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInv)
    inst.components.inventoryitem:SetSinks(true)

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 1
    inst.components.edible.hungervalue = 150
    inst.components.edible.sanityvalue = 5
    inst.components.edible.foodtype = FOODTYPE.GOODIES
    inst.components.edible.secondaryfoodtype = FOODTYPE.VEGGIE
    inst.components.edible:SetOnEatenFn(OnEaten)

    inst:AddComponent("bait")

    inst:AddComponent("tradable")

    MakeHauntableLaunchAndIgnite(inst)

    return inst
end

return Prefab("explodingfruitcake", fn, assets, prefabs)
