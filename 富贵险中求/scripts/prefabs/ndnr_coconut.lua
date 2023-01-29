local coconut_assets =
{
	Asset("ANIM", "anim/coconut.zip"),
    Asset("IMAGE", "images/ndnr_coconut.tex"),
    Asset("ATLAS", "images/ndnr_coconut.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_coconut.xml", 256),
}

local coconut_cooked_assets =
{
	Asset("ANIM", "anim/coconut.zip"),
    Asset("IMAGE", "images/ndnr_coconut_cooked.tex"),
    Asset("ATLAS", "images/ndnr_coconut_cooked.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_coconut_cooked.xml", 256),
}

local coconut_halved_assets =
{
	Asset("ANIM", "anim/coconut.zip"),
    Asset("IMAGE", "images/ndnr_coconut_halved.tex"),
    Asset("ATLAS", "images/ndnr_coconut_halved.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_coconut_halved.xml", 256),
}

local prefabs =
{
    "ndnr_coconut_cooked",
    "ndnr_coconut_halved"
}

local function growtree(inst)
    local tree = SpawnPrefab(inst.growprefab)
    if tree then
        tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
        tree:growfromseed()
        inst:Remove()
    end
end

local function stopgrowing(inst)
    inst.components.timer:StopTimer("grow")
end

local function plant(inst, growtime)
    local sapling = SpawnPrefab(inst._spawn_prefab or "ndnr_coconut_sapling")
    sapling:StartGrowing()
    sapling.Transform:SetPosition(inst.Transform:GetWorldPosition())
    sapling.SoundEmitter:PlaySound("dontstarve/wilson/plant_tree")
    inst:Remove()
end

local LEIF_TAGS = { "ndnr_treeguard" }
local function ondeploy(inst, pt, deployer)
    inst = inst.components.stackable:Get()
    inst.Physics:Teleport(pt:Get())
    local timeToGrow = GetRandomWithVariance(TUNING.PINECONE_GROWTIME.base, TUNING.PINECONE_GROWTIME.random)
    plant(inst, timeToGrow)

    --tell any nearby leifs to chill out
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, TUNING.LEIF_PINECONE_CHILL_RADIUS, LEIF_TAGS)

    local played_sound = false
    for i, v in ipairs(ents) do
        local chill_chance =
            v:GetDistanceSqToPoint(pt:Get()) < TUNING.LEIF_PINECONE_CHILL_CLOSE_RADIUS * TUNING.LEIF_PINECONE_CHILL_CLOSE_RADIUS and
            TUNING.LEIF_PINECONE_CHILL_CHANCE_CLOSE or
            TUNING.LEIF_PINECONE_CHILL_CHANCE_FAR

        if math.random() < chill_chance then
            if v.components.sleeper ~= nil then
                v.components.sleeper:GoToSleep(1000)
                AwardPlayerAchievement( "pacify_forest", deployer )
            end
        elseif not played_sound then
            v.SoundEmitter:PlaySound("dontstarve/creatures/leif/taunt_VO")
            played_sound = true
        end
    end
end

local function describe(inst)
    if inst.growtime then
        return "PLANTED"
    end
end

local function displaynamefn(inst)
    if inst.growtime then
        return STRINGS.NAMES.COCONUT_SAPLING
    end
    return STRINGS.NAMES.COCONUT
end

local function OnSave(inst, data)
    if inst.growtime then
        data.growtime = inst.growtime - GetTime()
    end
end

local function OnLoad(inst, data)
    if data and data.growtime then
        plant(inst, data.growtime)
    end
end

local function common()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)
    -- MakeBlowInHurricane(inst, TUNING.WINDBLOWN_SCALE_MIN.MEDIUM, TUNING.WINDBLOWN_SCALE_MAX.MEDIUM)

    inst.AnimState:SetBank("coconut")
    inst.AnimState:SetBuild("coconut")
    inst.AnimState:PlayAnimation("idle")

   -- inst:AddComponent("edible")
    --inst.components.edible.foodtype = "VEGGIE"
    inst:AddTag("coconut")
    inst:AddTag("deployedplant")
    inst:AddTag("cattoy")
    inst:AddTag("treeseed")

    inst.entity:SetPristine()
    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------

    inst:AddComponent("tradable")

    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = describe

    --inst:AddComponent("fuel")
    --inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

	MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.RAW

    inst:AddComponent("inventoryitem")

    --inst:AddComponent("bait")

    return inst
end

local function onhacked(inst)
    local nut = inst
    if inst.components.inventoryitem then
        local owner = inst.components.inventoryitem.owner
        if inst.components.stackable and inst.components.stackable.stacksize > 1 then
            nut = inst.components.stackable:Get()
            inst.components.workable:SetWorkLeft(1)
        end
        if owner then
            local hacked = SpawnPrefab("ndnr_coconut_halved")
            hacked.components.stackable.stacksize = 2
            if owner.components.inventory and not owner.components.inventory:IsFull() then
                owner.components.inventory:GiveItem(hacked)
            elseif owner.components.container and not owner.components.container:IsFull() then
                owner.components.container:GiveItem(hacked)
            -- else
            --     inst.components.lootdropper:DropLootPrefab(hacked)
            end
        else
            inst.components.lootdropper:SpawnLootPrefab("ndnr_coconut_halved")
            inst.components.lootdropper:SpawnLootPrefab("ndnr_coconut_halved")
        end
        -- inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/bamboo_hack")
    end
    nut:Remove()

end

local function raw()
    local inst = common()
    inst:AddTag("show_spoilage")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(onhacked)

    inst:AddComponent("lootdropper")

    inst:AddComponent("deployable")
    inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
    inst.components.deployable.ondeploy = ondeploy

    inst.displaynamefn = displaynamefn

    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY/2

    inst.components.inventoryitem.atlasname = "images/ndnr_coconut.xml"

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

local function cooked()
    local inst = common()

    inst.AnimState:PlayAnimation("cook")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.edible.hungervalue = TUNING.CALORIES_TINY
    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.edible.foodtype = FOODTYPE.SEEDS

    inst.components.inventoryitem.atlasname = "images/ndnr_coconut_cooked.xml"

    return inst
end

local function halved()
    local inst = common()
    inst.AnimState:PlayAnimation("chopped")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("cookable")
    inst.components.cookable.product = "ndnr_coconut_cooked"

    inst.components.edible.hungervalue = TUNING.CALORIES_TINY/2
    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.edible.foodtype = FOODTYPE.SEEDS

    inst.components.inventoryitem.atlasname = "images/ndnr_coconut_halved.xml"

    return inst
end

local function ontimerdone(inst, data)
    if data.name == "grow" then
        growtree(inst)
    end
end

local startgrowing = function(inst) -- this was forward declared
    if not inst.components.timer:TimerExists("grow") then
        local growtime = GetRandomWithVariance(TUNING.PINECONE_GROWTIME.base, TUNING.PINECONE_GROWTIME.random)
        inst.components.timer:StartTimer("grow", growtime)
    end
end

local function digup(inst, digger)
    inst.components.lootdropper:DropLoot()
    inst:Remove()
end

local function sapling_fn(build, anim, growprefab, tag, fireproof, overrideloot)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst.AnimState:SetBank(build)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation(anim)

        if not fireproof then
            inst:AddTag("plant")
        end

        if tag then
            for i, v in pairs(tag) do
                inst:AddTag(v)
            end
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.growprefab = growprefab
        inst.StartGrowing = startgrowing

        inst:AddComponent("timer")
        inst:ListenForEvent("timerdone", ontimerdone)
        startgrowing(inst)

        inst:AddComponent("inspectable")

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot(overrideloot or {"twigs"})

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetOnFinishCallback(digup)
        inst.components.workable:SetWorkLeft(1)

        if not fireproof then
            MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
            inst:ListenForEvent("onignite", stopgrowing)
            inst:ListenForEvent("onextinguish", startgrowing)
            MakeSmallPropagator(inst)

            MakeHauntableIgnite(inst)
        else
            MakeHauntableWork(inst)
        end

        return inst
    end
    return fn
end

return Prefab("ndnr_coconut", raw, coconut_assets, prefabs),
    Prefab("ndnr_coconut_cooked", cooked, coconut_cooked_assets),
    Prefab("ndnr_coconut_halved", halved, coconut_halved_assets),
    Prefab("ndnr_coconut_sapling", sapling_fn("coconut", "planted", "ndnr_palmtree_short", {"tree", "ndnr_coconut_sapling"}), coconut_assets),
    MakePlacer("ndnr_coconut_placer", "coconut", "coconut", "planted" )


