local assets =
{
    Asset("ANIM", "anim/lg_actinine_plant.zip"),
}

local prefabs =
{
}

local function onpickedfn(inst, picker)
    inst.AnimState:PlayAnimation("empty"..(inst.animname or 1),true)
end

local function onregenfn(inst)
    inst.AnimState:PlayAnimation("full"..(inst.animname or 1),true)
end

local function makeemptyfn(inst)
    inst.AnimState:PlayAnimation("empty"..(inst.animname or 1),true)
end

local function OnSave(inst, data)
    data.animname = inst.animname
end

local size = {
    1.2,
    1.2,
    0.8,
}

local function OnLoad(inst, data)
    if data and data.animname ~= nil then
        inst.animname = data.animname
        if inst.components.pickable.canbepicked then
            onregenfn(inst)
        else
            makeemptyfn(inst)
        end
        if size[inst.animname]  then
            inst.AnimState:SetScale(size[inst.animname],size[inst.animname],size[inst.animname])
        end
        inst.anim_size:set(inst.animname)
    end
end

local function setflowertype(inst, name)
    if inst.animname == nil then
        inst.animname = math.random(3)
        inst.AnimState:PlayAnimation("full"..inst.animname,true)
        inst.AnimState:SetTime(math.random() * 2)
        if size[inst.animname]  then
            inst.AnimState:SetScale(size[inst.animname],size[inst.animname],size[inst.animname])
        end
        inst.anim_size:set(inst.animname)
    end
end

local function OnDirty(inst)
    local size = inst.anim_size:value()
    if size == 3 and inst.components.floater then
        inst.components.floater:SetScale({1.6, 0.9, 1.1})
    end
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("lg_actinine_plant.tex")

    inst.AnimState:SetBuild("lg_actinine_plant")
    inst.AnimState:SetBank("lg_actinine_plant")
    inst.AnimState:PlayAnimation("full1", true)
    inst.AnimState:HideSymbol("shuiwen")

    MakeInventoryFloatable(inst, "med", 0.1, {1.1, 0.9, 1.1})
    inst.components.floater.bob_percent = 0

    local land_time = (POPULATING and math.random()*5*FRAMES) or 0
    inst:DoTaskInTime(land_time, function(inst)
        inst.components.floater:OnLandedServer()
    end)
    inst.anim_size = net_tinybyte(inst.GUID, "lg_actinine_plant", "actinine_plantdirty")

    inst:ListenForEvent("actinine_plantdirty", OnDirty)
    MakeWaterObstaclePhysics(inst, 0.80, 2, 0.75)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_sticks"

    inst.components.pickable:SetUp("lg_actinine", 2*480,2) --10s一次 ,一次得到3个？
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn

    inst:AddComponent("inspectable")

    --if not POPULATING then
        setflowertype(inst)
    --end
    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("lg_actinine_plant", fn, assets, prefabs)