local assets = {
    Asset("ANIM", "anim/wall.zip"),
    Asset("ANIM", "anim/wall_ruins.zip"),
}

local prefabs = {"collapse_small"}

local function onload(inst, data)
    if data and data.gridnudge then
        local function normalize(coord)

            local temp = coord % 0.5
            coord = coord + 0.5 - temp

            if coord % 1 == 0 then coord = coord - 0.5 end

            return coord
        end

        local pt = Vector3(inst.Transform:GetWorldPosition())
        pt.x = normalize(pt.x)
        pt.z = normalize(pt.z)
        inst.Transform:SetPosition(pt.x, pt.y, pt.z)
    end
end

local function wallremovefn(inst)
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetEightFaced()

    MakeObstaclePhysics(inst, .5)
    inst.Physics:SetDontRemoveOnSleep(true)

    inst:AddTag("FX")
    inst:AddTag("wall")
    inst:AddTag("noauradamage")
    inst:AddTag("ruins")
    inst:AddTag("stone")

    inst.AnimState:SetBank("wall")
    inst.AnimState:SetBuild("wall_ruins")
    inst.AnimState:PlayAnimation("half")

    MakeSnowCoveredPristine(inst)

    inst.Physics:SetActive(true)
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst.OnLoad = onload
    inst:DoTaskInTime(8, wallremovefn)

    MakeSnowCovered(inst)

    return inst
end

return Prefab("ndnr_wall_ruins", fn, assets, prefabs)
