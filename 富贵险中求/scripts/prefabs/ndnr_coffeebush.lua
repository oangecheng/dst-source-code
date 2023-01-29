
local assets =
{
    Asset("ANIM", "anim/berrybush.zip"),
    Asset("ANIM", "anim/coffeebush.zip"),

    Asset("ATLAS", "images/ndnr_coffeebush.xml"),
    Asset("IMAGE", "images/ndnr_coffeebush.tex"),

    Asset("IMAGE", "images/dug_ndnr_coffeebush.tex"),
    Asset("ATLAS", "images/dug_ndnr_coffeebush.xml"),
    Asset("ATLAS_BUILD", "images/dug_ndnr_coffeebush.xml", 256),
}

local function setberries(inst, pct)
    if inst._setberriesonanimover then
        inst._setberriesonanimover = nil
        inst:RemoveEventCallback("animover", setberries)
    end

    local berries =
        (pct == nil and "") or
        (pct >= .9 and "berriesmost") or
        (pct >= .33 and "berriesmore") or
        "berries"

    for i, v in ipairs({ "berries", "berriesmore", "berriesmost" }) do
        if v == berries then
            inst.AnimState:Show(v)
        else
            inst.AnimState:Hide(v)
        end
    end
end

local function setberriesonanimover(inst)
    if inst._setberriesonanimover then
        setberries(inst, nil)
    else
        inst._setberriesonanimover = true
        inst:ListenForEvent("animover", setberries)
    end
end

local function cancelsetberriesonanimover(inst)
    if inst._setberriesonanimover then
        setberries(inst, nil)
    end
end

local function makeemptyfn(inst)
    if POPULATING then
        inst.AnimState:PlayAnimation("idle", true)
        inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
    elseif inst:HasTag("withered") or inst.AnimState:IsCurrentAnimation("dead") then
        --inst.SoundEmitter:PlaySound("dontstarve/common/bush_fertilize")
        inst.AnimState:PlayAnimation("dead_to_idle")
        inst.AnimState:PushAnimation("idle")
    else
        inst.AnimState:PlayAnimation("idle", true)
    end
    setberries(inst, nil)
end

local function makebarrenfn(inst)--, wasempty)
    if not POPULATING and (inst:HasTag("withered") or inst.AnimState:IsCurrentAnimation("idle")) then
        inst.AnimState:PlayAnimation("idle_to_dead")
        inst.AnimState:PushAnimation("dead", false)
    else
        inst.AnimState:PlayAnimation("dead")
    end
    cancelsetberriesonanimover(inst)
end

-- local function shake(inst)
--     if inst.components.pickable ~= nil and
--         not inst.components.pickable:CanBePicked() and
--         inst.components.pickable:IsBarren() then
--         inst.AnimState:PlayAnimation("shake_dead")
--         inst.AnimState:PushAnimation("dead", false)
--     else
--         inst.AnimState:PlayAnimation("shake")
--         inst.AnimState:PushAnimation("idle")
--     end
--     cancelsetberriesonanimover(inst)
-- end

-- local function spawnperd(inst)
--     if inst:IsValid() then
--         local perd = SpawnPrefab("perd")
--         local x, y, z = inst.Transform:GetWorldPosition()
--         local angle = math.random() * 2 * PI
--         perd.Transform:SetPosition(x + math.cos(angle), 0, z + math.sin(angle))
--         perd.sg:GoToState("appear")
--         perd.components.homeseeker:SetHome(inst)
--         shake(inst)
--     end
-- end

local function onpickedfn(inst, picker)
    if inst.components.pickable ~= nil then
        --V2C: nil cycles_left means unlimited picks, so use max value for math
        --local old_percent = inst.components.pickable.cycles_left ~= nil and (inst.components.pickable.cycles_left + 1) / inst.components.pickable.max_cycles or 1
        --setberries(inst, old_percent)
        if inst.components.pickable:IsBarren() then
            inst.AnimState:PlayAnimation("idle_to_dead")
            inst.AnimState:PushAnimation("dead", false)
            setberries(inst, nil)
        else
            inst.AnimState:PlayAnimation("picked")
            inst.AnimState:PushAnimation("idle")
            setberriesonanimover(inst)
        end
    end

    -- if not (picker:HasTag("berrythief") or inst._noperd) and math.random() < (IsSpecialEventActive(SPECIAL_EVENTS.YOTG) and TUNING.YOTG_PERD_SPAWNCHANCE or TUNING.PERD_SPAWNCHANCE) then
    --     inst:DoTaskInTime(3 + math.random() * 3, spawnperd)
    -- end
end

local function getregentimefn_normal(inst)
    if inst.components.pickable == nil then
        return TUNING.BERRY_REGROW_TIME
    end
    --V2C: nil cycles_left means unlimited picks, so use max value for math
    local max_cycles = inst.components.pickable.max_cycles
    local cycles_left = inst.components.pickable.cycles_left or max_cycles
    local num_cycles_passed = math.max(0, max_cycles - cycles_left)
    return TUNING.BERRY_REGROW_TIME
        + TUNING.BERRY_REGROW_INCREASE * num_cycles_passed
        + TUNING.BERRY_REGROW_VARIANCE * math.random()
end

local function getregentimefn_juicy(inst)
    if inst.components.pickable == nil then
        return TUNING.BERRY_JUICY_REGROW_TIME
    end
    --V2C: nil cycles_left means unlimited picks, so use max value for math
    local max_cycles = inst.components.pickable.max_cycles
    local cycles_left = inst.components.pickable.cycles_left or max_cycles
    local num_cycles_passed = math.max(0, max_cycles - cycles_left)
    return TUNING.BERRY_JUICY_REGROW_TIME
        + TUNING.BERRY_JUICY_REGROW_INCREASE * num_cycles_passed
        + TUNING.BERRY_JUICY_REGROW_VARIANCE * math.random()
end

local function makefullfn(inst)
    local anim = "idle"
    local berries = nil
    if inst.components.pickable ~= nil then
        if inst.components.pickable:CanBePicked() then
            berries = inst.components.pickable.cycles_left ~= nil and inst.components.pickable.cycles_left / inst.components.pickable.max_cycles or 1
        elseif inst.components.pickable:IsBarren() then
            anim = "dead"
        end
    end
    if anim ~= "idle" then
        inst.AnimState:PlayAnimation(anim)
    elseif POPULATING then
        inst.AnimState:PlayAnimation("idle", true)
        inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
    else
        inst.AnimState:PlayAnimation("grow")
        inst.AnimState:PushAnimation("idle", true)
    end
    setberries(inst, berries)
end

local function onworked_juicy(inst, worker, workleft)
    --This is possible when beaver is gnaw-digging the bush,
    --and the expected behaviour should be same as jostling.
    if workleft > 0 and
        inst.components.lootdropper ~= nil and
        inst.components.pickable ~= nil and
        inst.components.pickable.droppicked and
        inst.components.pickable:CanBePicked() then
        inst.components.pickable:Pick(worker)
    end
end

local function dig_up_common(inst, worker, numberries)
    if inst.components.pickable ~= nil and inst.components.lootdropper ~= nil then
        local withered = inst.components.witherable ~= nil and inst.components.witherable:IsWithered()

        if withered or inst.components.pickable:IsBarren() then
            inst.components.lootdropper:SpawnLootPrefab("twigs")
            inst.components.lootdropper:SpawnLootPrefab("twigs")
        else
            if inst.components.pickable:CanBePicked() then
                local pt = inst:GetPosition()
                pt.y = pt.y + (inst.components.pickable.dropheight or 0)
                for i = 1, numberries do
                    inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product, pt)
                end
            end
            inst.components.lootdropper:SpawnLootPrefab("dug_"..inst.prefab)
        end
    end
    inst:Remove()
end

local function dig_up_normal(inst, worker)
    dig_up_common(inst, worker, 1)
end

local function ontransplantfn(inst)
    inst.AnimState:PlayAnimation("dead")
    setberries(inst, nil)
    inst.components.pickable:MakeBarren()
end

local function OnHaunt(inst)
    -- if math.random() <= TUNING.HAUNT_CHANCE_ALWAYS then
    --     shake(inst)
    --     inst.components.hauntable.hauntvalue = TUNING.HAUNT_COOLDOWN_TINY
    --     return true
    -- end
    return false
end

-- local function createbush(name, inspectname, berryname, master_postinit)
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("ndnr_coffeebush.tex")

    MakeSmallObstaclePhysics(inst, .1)

    inst:AddTag("bush")
    inst:AddTag("plant")
    inst:AddTag("renewable")

    --witherable (from witherable component) added to pristine state for optimization
    inst:AddTag("witherable")

    if TheNet:GetServerGameMode() == "quagmire" then
        -- for stats tracking
        inst:AddTag("quagmire_wildplant")
    end

	inst.AnimState:SetBank("berrybush")
	inst.AnimState:SetBuild("berrybush")
    inst.AnimState:PlayAnimation("idle", true)

    inst.AnimState:OverrideSymbol("berries", "coffeebush", "beans")
    inst.AnimState:OverrideSymbol("bush_berry_build", "coffeebush", "bush_berry_build")

    setberries(inst, 1)

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())

    inst:AddComponent("pickable")
    inst.components.pickable:SetUp("ndnr_coffeebeans", TUNING.BERRY_REGROW_TIME)
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn
    inst.components.pickable.makebarrenfn = makebarrenfn
    inst.components.pickable.makefullfn = makefullfn
    inst.components.pickable.ontransplantfn = ontransplantfn
    inst.components.pickable.getregentimefn = getregentimefn_normal
    inst.components.pickable.max_cycles = TUNING.BERRYBUSH_CYCLES + math.random(2)
    inst.components.pickable.cycles_left = inst.components.pickable.max_cycles

    inst:AddComponent("witherable")
    inst.components.witherable.wither_temp = 110 -- max world temperature is 95  屁，最高温度能达到103度！！

    MakeLargeBurnable(inst)
    MakeMediumPropagator(inst)

    MakeHauntableIgnite(inst)
    AddHauntableCustomReaction(inst, OnHaunt, false, false, true)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(dig_up_normal)

    inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")

    MakeSnowCovered(inst)
    MakeNoGrowInWinter(inst)

    return inst
end

local function ondeploy(inst, pt, deployer)
    local tree = SpawnPrefab("ndnr_coffeebush")
    if tree ~= nil then
        tree.Transform:SetPosition(pt:Get())
        inst.components.stackable:Get():Remove()
        if tree.components.pickable ~= nil then
            tree.components.pickable:OnTransplant()
        end
        if deployer ~= nil and deployer.SoundEmitter ~= nil then
            --V2C: WHY?!! because many of the plantables don't
            --     have SoundEmitter, and we don't want to add
            --     one just for this sound!
            deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
        end
    end
end

local function fn_dug()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    --inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst:AddTag("deployedplant")

    inst.AnimState:SetBank("coffeebush")
    inst.AnimState:SetBuild("coffeebush")
    inst.AnimState:PlayAnimation("dropped")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/dug_ndnr_coffeebush.xml"

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    MakeMediumBurnable(inst, TUNING.LARGE_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunchAndIgnite(inst)

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)

    ---------------------
    return inst
end

return Prefab("ndnr_coffeebush", fn, assets),
    Prefab("dug_ndnr_coffeebush", fn_dug, assets),
    MakePlacer("dug_ndnr_coffeebush_placer", "coffeebush", "coffeebush", "idle")