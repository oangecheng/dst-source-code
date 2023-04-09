local assets =
{
    Asset("ANIM", "anim/bloodpump.zip"),
    Asset("ANIM", "anim/medal_withered_heart.zip"),
	Asset("ATLAS", "images/medal_withered_heart.xml"),
	Asset("ATLAS_BUILD", "images/medal_withered_heart.xml",256),
}

local function PlayBeatAnimation(inst)
    inst.AnimState:PlayAnimation("idle")
end

local function beat(inst)
    inst:PlayBeatAnimation()
    inst.SoundEmitter:PlaySound("dontstarve/ghost/bloodpump")
    inst.beattask = inst:DoTaskInTime(.75 + math.random() * .75, beat)
end

local function startbeat(inst)
    if inst.beat_fx ~= nil then
        inst.beat_fx:Remove()
        inst.beat_fx = nil
    end
    if inst.reviver_beat_fx ~= nil then
        inst.beat_fx = SpawnPrefab(inst.reviver_beat_fx)
        inst.beat_fx.entity:SetParent(inst.entity)
        inst.beat_fx.entity:AddFollower()
        inst.beat_fx.Follower:FollowSymbol(inst.GUID, "bloodpump01", -5, -30, 0)
    end
    inst.beattask = inst:DoTaskInTime(.75 + math.random() * .75, beat)
end

local function ondropped(inst)
    if inst.beattask ~= nil then
        inst.beattask:Cancel()
    end
    inst.beattask = inst:DoTaskInTime(0, startbeat)
end

local function onpickup(inst)
    if inst.beattask ~= nil then
        inst.beattask:Cancel()
        inst.beattask = nil
    end
    if inst.beat_fx ~= nil then
        inst.beat_fx:Remove()
        inst.beat_fx = nil
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("bloodpump")
    inst.AnimState:SetBuild("medal_withered_heart")
    inst.AnimState:PlayAnimation("idle")
	
    inst:AddTag("powerabsorbable")--可被吸收能力

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "medal_withered_heart"
    inst.components.inventoryitem.atlasname = "images/medal_withered_heart.xml"
    inst.components.inventoryitem:SetOnDroppedFn(ondropped)
    inst.components.inventoryitem:SetOnPutInInventoryFn(onpickup)
    inst.components.inventoryitem:SetSinks(true)--可沉水

    inst:AddComponent("inspectable")
    -- inst:AddComponent("tradable")

    MakeHauntableLaunch(inst)

    inst.beattask = nil
    inst.skin_switched = ondropped
    ondropped(inst)

    inst.DefaultPlayBeatAnimation = PlayBeatAnimation --for resetting after reskin
    inst.PlayBeatAnimation = PlayBeatAnimation

    return inst
end

return Prefab("medal_withered_heart", fn, assets)
