require "prefabutil"

local containers = require "containers"
local params = containers.params

params.ndnr_treasurechest_root =
{
    widget =
    {
        slotpos = {},
        slotbg = {},
    },
	itemtestfn = function()return false end,
    type = "special for shared inventory",
}
params.ndnr_treasurechest_root_child = params.shadowchester

local SUNKEN_PHYSICS_RADIUS = .45

local function onopen(inst, data)
    if not inst:HasTag("burnt") then
        if TheWorld.components.ndnr_rootchestinventory.trunk and
            TheWorld.components.ndnr_rootchestinventory.trunk.components.container and
            not TheWorld.components.ndnr_rootchestinventory.trunk.components.container:IsOpen() then
			TheWorld.components.ndnr_rootchestinventory.trunk.Transform:SetPosition(data.doer.Transform:GetWorldPosition())
			TheWorld.components.ndnr_rootchestinventory.trunk.components.container:Open(data.doer)
		end

        inst.AnimState:PlayAnimation("open")
        inst.SoundEmitter:PlaySound("dontstarve/creatures/chester/open")
    end
end

local function onclose(inst, data)
    if not inst:HasTag("burnt") then
        if TheWorld.components.ndnr_rootchestinventory.trunk then
			TheWorld.components.ndnr_rootchestinventory.trunk.components.container:Close(data.doer)
		end

        inst.AnimState:PlayAnimation("close")
        inst.AnimState:PushAnimation("closed", false)
        inst.SoundEmitter:PlaySound("dontstarve/creatures/chester/close")
    end
end

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("closed", false)
        -- if inst.components.container ~= nil then
        --     inst.components.container:DropEverything()
        --     inst.components.container:Close()
        -- end
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("closed", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/chest_craft")
end

local function onsave(inst, data)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() or inst:HasTag("burnt") then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data ~= nil and data.burnt and inst.components.burnable ~= nil then
        inst.components.burnable.onburnt(inst)
    end
end

local function MakeChest(name, bank, build, indestructible, master_postinit, prefabs, assets, common_postinit, force_non_burnable)
    local default_assets =
    {
        Asset("ANIM", "anim/"..build..".zip"),
        Asset("ANIM", "anim/ui_chest_3x2.zip"),
    }
    if name ~= "ndnr_treasurechest_root_child" then
        table.insert(default_assets, Asset("IMAGE", "images/"..name..".tex"))
        table.insert(default_assets, Asset("ATLAS", "images/"..name..".xml"))
        table.insert(default_assets, Asset("ATLAS_BUILD", "images/"..name..".xml", 256))
    end
    assets = assets ~= nil and JoinArrays(assets, default_assets) or default_assets

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()

        if name == "ndnr_treasurechest_root" then
            inst.MiniMapEntity:SetIcon(name..".tex")
        end

        inst:AddTag("structure")
        inst:AddTag("chest")

        if name ~= "ndnr_treasurechest_root_child" then
            inst.AnimState:SetBank(bank)
            inst.AnimState:SetBuild(build)
            inst.AnimState:PlayAnimation("closed")
        else
            inst:AddTag("NOBLOCK")
        end

		MakeSnowCoveredPristine(inst)

        if common_postinit ~= nil then
            common_postinit(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            -- inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup(name) end
            return inst
        end

        inst:AddComponent("inspectable")
        inst:AddComponent("container")
        inst.components.container:WidgetSetup(name)
        if name ~= "ndnr_treasurechest_root_child" then
            inst.components.container.onopenfn = onopen
            inst.components.container.onclosefn = onclose
        end
        inst.components.container.skipclosesnd = true
        inst.components.container.skipopensnd = true


        if not indestructible then
            inst:AddComponent("lootdropper")
            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
            inst.components.workable:SetWorkLeft(2)
            inst.components.workable:SetOnFinishCallback(onhammered)
            inst.components.workable:SetOnWorkCallback(onhit)

            if not force_non_burnable then
                MakeSmallBurnable(inst, nil, nil, true)
                MakeMediumPropagator(inst)
            end
        end

        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

        inst:ListenForEvent("onbuilt", onbuilt)
        MakeSnowCovered(inst)

		-- Save / load is extended by some prefab variants
        inst.OnSave = onsave
        inst.OnLoad = onload

        if master_postinit ~= nil then
            master_postinit(inst)
        end

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

return MakeChest("ndnr_treasurechest_root", "roottrunk", "ndnr_treasure_chest_roottrunk", false, nil, { "collapse_small" }),
    MakeChest("ndnr_treasurechest_root_child", "roottrunk", "ndnr_treasure_chest_roottrunk", true, nil, { "collapse_small" }),
    MakePlacer("ndnr_treasurechest_root_placer", "roottrunk", "ndnr_treasure_chest_roottrunk", "closed")
