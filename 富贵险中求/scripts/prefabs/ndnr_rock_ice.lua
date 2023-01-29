local rock_ice_assets =
{
    Asset("ANIM", "anim/ice_boulder.zip"),
    Asset("MINIMAP_IMAGE", "iceboulder"),
}

local prefabs =
{
    "ice",
    "rocks",
    "flint",
    "ice_puddle",
    "ice_splash",
}

local STAGES = {
    {
        name = "dryup",
        animation = "dryup",
        showrock = false,
        work = -1,
        isdriedup = true,
    },
    {
        name = "empty",
        animation = "melted",
        showrock = false,
        work = -1,
    },
    {
        name = "short",
        animation = "low",
        showrock = true,
        work = TUNING.ICE_MINE,
        icecount = 2,
    },
    {
        name = "medium",
        animation = "med",
        showrock = true,
        work = TUNING.ICE_MINE*0.67,
        icecount = 2,
    },
    {
        name = "tall",
        animation = "full",
        showrock = true,
        work = TUNING.ICE_MINE*0.67,
        icecount = 3,
    },
}

local STAGE_INDICES = {}
for i, v in ipairs(STAGES) do
    STAGE_INDICES[v.name] = i
end

local DRYUP_CANT_FLAGS = {"locomotor", "FX"}
local function SetStage(inst, stage, source, snap_to_stage)
    if stage == inst.stage then
        return
    end

    local currentstage = STAGE_INDICES[inst.stage]
    local targetstage = STAGE_INDICES[stage]

    -- otherwise just set the stage to the target!
    inst.stage = STAGES[targetstage].name

	if STAGES[targetstage].isdriedup then
		if inst.remove_on_dryup then
			inst.persists = false
			if inst:IsAsleep() then
				inst:Remove()
			else
				inst:DoTaskInTime(2, inst.Remove)
			end
		end

		inst:AddTag("CLASSIFIED")
	elseif currentstage ~= nil and STAGES[currentstage].isdriedup then
		inst:RemoveTag("CLASSIFIED")
	end

    if STAGES[targetstage].showrock then
        inst.AnimState:PlayAnimation(STAGES[targetstage].animation)

        inst.AnimState:Show("rock")
        if TheWorld.state.snowlevel >= SNOW_THRESH then
            inst.AnimState:Show("snow")
        end
        inst.MiniMapEntity:SetEnabled(true)
        ChangeToObstaclePhysics(inst)
    else
        inst.AnimState:Hide("rock")
        inst.AnimState:Hide("snow")
        inst.MiniMapEntity:SetEnabled(false)
        RemovePhysicsColliders(inst)
    end
end

local function rock_ice_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("ice_boulder")
    inst.AnimState:SetBuild("ice_boulder")

    MakeObstaclePhysics(inst, 1)

    inst.MiniMapEntity:SetIcon("iceboulder.png")

    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("frozen")
    inst:AddTag("FX")
    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- Make sure we start at a good height for starting in a season when it shouldn't start as full
    inst:DoTaskInTime(0, function()
        SetStage(inst, "tall")
    end)
    inst:DoTaskInTime(7, inst.Remove)

    MakeSnowCovered(inst)

    MakeHauntableWork(inst)

    return inst
end

return Prefab("ndnr_rock_ice", rock_ice_fn, rock_ice_assets, prefabs)
