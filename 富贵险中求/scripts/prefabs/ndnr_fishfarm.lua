local assets = {
    Asset("ANIM", "anim/ndnr_fish_farm.zip"),
    Asset("IMAGE", "images/ndnr_fishfarm.tex"),
    Asset("ATLAS", "images/ndnr_fishfarm.xml"),
}

for i = 1, 9 do
    table.insert(assets, Asset("ANIM", "anim/swap_ndnr_fishfarm_oceanfish_medium_"..i..".zip"))
    table.insert(assets, Asset("ANIM", "anim/swap_ndnr_fishfarm_oceanfish_small_"..i..".zip"))
end

local function onhammered(inst, worker)
	-- if inst:HasTag("fire") and inst.components.burnable then
	-- 	inst.components.burnable:Extinguish()
	-- end
	-- if inst.components.breeder then inst.components.breeder:Reset() end
    if inst.components.lootdropper then
	    inst.components.lootdropper:DropLoot()
    end
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
	-- inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
end

local function onhit(inst, worker)

end

local function set_stage1(inst)
    -- inst.AnimState:Hide("mouseover")
    inst.AnimState:Hide("sign")

    inst.AnimState:Hide("fish_1")
    inst.AnimState:Hide("fish_2")
    inst.AnimState:Hide("fish_3")

    inst.AnimState:Hide("fish_4")
    inst.AnimState:Hide("fish_5")
    inst.AnimState:Hide("fish_6")

    inst.AnimState:Hide("fish_7")
    inst.AnimState:Hide("fish_8")
    inst.AnimState:Hide("fish_9")

    -- inst:AddTag("ndnr_fishfarm_empty")
end

local function set_stage2(inst)
    inst.AnimState:Show("sign")

    inst.AnimState:Show("fish_1")
    inst.AnimState:Show("fish_2")
    inst.AnimState:Show("fish_3")

    inst.AnimState:Hide("fish_4")
    inst.AnimState:Hide("fish_5")
    inst.AnimState:Hide("fish_6")

    inst.AnimState:Hide("fish_7")
    inst.AnimState:Hide("fish_8")
    inst.AnimState:Hide("fish_9")

    inst:RemoveTag("ndnr_fishfarm_empty")
end

local function set_stage3(inst)
    inst.AnimState:Show("sign")

    inst.AnimState:Show("fish_1")
    inst.AnimState:Show("fish_2")
    inst.AnimState:Show("fish_3")

    inst.AnimState:Show("fish_4")
    inst.AnimState:Show("fish_5")
    inst.AnimState:Show("fish_6")

    inst.AnimState:Hide("fish_7")
    inst.AnimState:Hide("fish_8")
    inst.AnimState:Hide("fish_9")

    inst:RemoveTag("ndnr_fishfarm_empty")
end

local function set_stage4(inst)
    inst.AnimState:Show("sign")

    inst.AnimState:Show("fish_1")
    inst.AnimState:Show("fish_2")
    inst.AnimState:Show("fish_3")

    inst.AnimState:Show("fish_4")
    inst.AnimState:Show("fish_5")
    inst.AnimState:Show("fish_6")

    inst.AnimState:Show("fish_7")
    inst.AnimState:Show("fish_8")
    inst.AnimState:Show("fish_9")

    inst:RemoveTag("ndnr_fishfarm_empty")
    inst.components.growable:StopGrowing()
end

local function grow_to_stage1(inst)
    set_stage1(inst)
end

local function grow_to_stage2(inst)
    set_stage2(inst)
end

local function grow_to_stage3(inst)
    set_stage3(inst)
end

local function grow_to_stage4(inst)
    set_stage4(inst)
end

local growth_stages =
{
    {
        name = "fishfarmstage1",
        time = function(inst) return GetRandomWithVariance(TUNING.NDNR_FISHFARM_REGROW[1].base, TUNING.NDNR_FISHFARM_REGROW[1].random) end,
        fn = set_stage1,
        growfn = grow_to_stage1,
        count = 0,
    },
    {
        name = "fishfarmstage2",
        time = function(inst) return GetRandomWithVariance(TUNING.NDNR_FISHFARM_REGROW[2].base, TUNING.NDNR_FISHFARM_REGROW[2].random) end,
        fn = set_stage2,
        growfn = grow_to_stage2,
        count = 0,
    },
    {
        name = "fishfarmstage3",
        time = function(inst) return GetRandomWithVariance(TUNING.NDNR_FISHFARM_REGROW[3].base, TUNING.NDNR_FISHFARM_REGROW[3].random) end,
        fn = set_stage3,
        growfn = grow_to_stage3,
        count = 1,
    },
    {
        name = "fishfarmstage4",
        time = function(inst) return GetRandomWithVariance(TUNING.NDNR_FISHFARM_REGROW[4].base, TUNING.NDNR_FISHFARM_REGROW[4].random) end,
        fn = set_stage4,
        growfn = grow_to_stage4,
        count = 2,
    },
}

local function OnHarvest(inst, doer)
    local product = nil
    if inst.components.ndnr_harvestfish then
        product = inst.components.ndnr_harvestfish:GetProduct()
    end
    if product and inst.components.growable then
        local stage = inst.components.growable:GetStage()
        if stage <= 2 then return false, "NOFISH" end

        local count = growth_stages[stage].count
        for i = 1, count do
            local fish = SpawnPrefab(product .. "_inv")
            doer.components.inventory:GiveItem(fish, nil, inst:GetPosition())
        end
        inst.components.growable:SetStage(stage - 1)
        if stage == 4 then
            inst.components.growable:StartGrowing()
        end
        return true
    end
end

local function init(inst)
    if inst.components.ndnr_harvestfish then
        local product = inst.components.ndnr_harvestfish:GetProduct()
        if product then
            inst.AnimState:ClearOverrideSymbol("sign")
            inst.AnimState:OverrideSymbol("sign", "swap_ndnr_fishfarm_"..product, "ndnr_fishfarm_sign_"..product)
        end
    end
end

local function raisefn(inst, roe, doer)
    inst:RemoveTag("ndnr_fishfarm_empty")
    if inst.components.growable then
        inst.components.growable:StartGrowing()
        inst.components.growable:DoGrowth()
    end
    if inst.components.ndnr_harvestfish then
        local fishname = string.gsub(roe.prefab, "ndnr_roe_", "")
        inst.components.ndnr_harvestfish:SetProduct(fishname)

        init(inst)
    end
end

local function DisplayNameFn(inst)
    if inst.replica.ndnr_harvestfish then
        local product = inst.replica.ndnr_harvestfish:GetProduct()
        if product then
            return STRINGS.NAMES[string.upper(product)] .. STRINGS.NAMES.NDNR_FISHFARM
        else
            return STRINGS.NAMES.NDNR_FISHFARM
        end
    end
end

local function OnCollide(inst, data)
    local boat_physics = data.other.components.boatphysics
    if boat_physics ~= nil then
        local damage_scale = 0.5
        local hit_velocity = math.floor(math.abs(boat_physics:GetVelocity() * data.hit_dot_velocity) * damage_scale / boat_physics.max_velocity + 0.5)
		if hit_velocity > 0 then
			inst.components.workable:WorkedBy(data.other, hit_velocity * 4)
		end
    end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("ndnr_fishfarm.tex")

    MakeWaterObstaclePhysics(inst, 2, 1, 0.75)

    inst.AnimState:SetBank("fish_farm")
    inst.AnimState:SetBuild("ndnr_fish_farm")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("ndnr_fishfarm_empty")
    inst:AddTag("ndnr_fishfarm")
    inst:AddTag("ignorewalkableplatforms")

    inst.displaynamefn = DisplayNameFn

    inst.entity:SetPristine()

    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("growable")
    inst.components.growable.stages = growth_stages
    inst.components.growable:SetStage(1)
    inst.components.growable.loopstages = false
    inst.components.growable.springgrowth = true
    inst.components.growable:StopGrowing()

    inst:AddComponent("ndnr_harvestfish")
    inst.components.ndnr_harvestfish:OnHarvest(OnHarvest)
    -------

    inst:AddComponent("inspectable")

    inst:DoTaskInTime(FRAMES, init)
    inst:ListenForEvent("on_collide", OnCollide)
    inst.raisefn = raisefn

    -- MakeMediumBurnable(inst, nil, nil, true)
	-- MakeSmallPropagator(inst)

    return inst
end

return Prefab("ndnr_fishfarm", fn, assets),
    MakePlacer("ndnr_fishfarm_placer", "fish_farm", "ndnr_fish_farm", "idle")
