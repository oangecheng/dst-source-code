local assets=
{
	Asset("ANIM", "anim/smelter.zip"),

	Asset("IMAGE", "images/ndnr_smelter.tex"),
    Asset("ATLAS", "images/ndnr_smelter.xml"),
}

local prefabs = {"collapse_small"}

local function onhammered(inst, worker)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	if not inst:HasTag("burnt") and inst.components.ndnr_melter and inst.components.ndnr_melter.product and inst.components.ndnr_melter.done then
		inst.components.lootdropper:AddChanceLoot(inst.components.ndnr_melter.product, 1)
	end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	-- inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onhit(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("hit_empty")

		if inst.components.ndnr_melter.cooking then
			inst.AnimState:PushAnimation("smelting_loop")
		elseif inst.components.ndnr_melter.done then
			inst.AnimState:PushAnimation("idle_full")
		else
			inst.AnimState:PushAnimation("idle_empty")
		end
	end
end

-- local function SetProductSymbol(inst, product, overridebuild)
    -- local recipe = cooking.GetRecipe(inst.prefab, product)
    -- local potlevel = recipe ~= nil and recipe.potlevel or nil
    -- local build = (recipe ~= nil and recipe.overridebuild) or overridebuild or "cook_pot_food"
    -- local overridesymbol = (recipe ~= nil and recipe.overridesymbolname) or product

    -- if potlevel == "high" then
    --     inst.AnimState:Show("swap_high")
    --     inst.AnimState:Hide("swap_mid")
    --     inst.AnimState:Hide("swap_low")
    -- elseif potlevel == "low" then
    --     inst.AnimState:Hide("swap_high")
    --     inst.AnimState:Hide("swap_mid")
    --     inst.AnimState:Show("swap_low")
    -- else
    --     inst.AnimState:Hide("swap_high")
    --     inst.AnimState:Show("swap_mid")
    --     inst.AnimState:Hide("swap_low")
    -- end

    -- inst.AnimState:OverrideSymbol("swap_cooked", build, overridesymbol)
-- end

--anim and sound callbacks

local function ShowProduct(inst)
	if not inst:HasTag("burnt") then
		-- local product = inst.components.ndnr_melter.product
		local overridebuild = inst.components.ndnr_melter.overridebuild
		local overridesymbol = inst.components.ndnr_melter.overridesymbol
		if overridebuild ~= nil and overridesymbol ~= nil then
			inst.AnimState:OverrideSymbol("swap_item", overridebuild, overridesymbol)
		end
	end
end

local function startcookfn(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("smelting_pre")
		-- inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/smelter/move_1")
		inst.AnimState:PushAnimation("smelting_loop", true)
		--play a looping sound
		inst.SoundEmitter:KillSound("snd")
		-- inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/smelt_LP", "snd")
		inst.Light:Enable(true)
	end
end


local function onopen(inst)
	if not inst:HasTag("burnt") then
	--	inst.AnimState:PlayAnimation("smelting_pre")
		-- inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/move_3", "open")
		-- inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot", "snd")
	end
end

local function onclose(inst)
	if not inst:HasTag("burnt") then
		if not inst.components.ndnr_melter.cooking then
			inst.AnimState:PlayAnimation("idle_empty")
			inst.SoundEmitter:KillSound("snd")
		end
		-- inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/move_3", "close")
	end
end

local function spoilfn(inst)
	if not inst:HasTag("burnt") then
		inst.components.ndnr_melter.product = inst.components.ndnr_melter.spoiledproduct
		ShowProduct(inst)
	end
end

local function donecookfn(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("smelting_pst")
		inst.AnimState:PushAnimation("idle_full")
		ShowProduct(inst)
		inst.SoundEmitter:KillSound("snd")
		inst.Light:Enable(false)
		-- inst:DoTaskInTime(1/30, function()
        --         if inst.AnimState:IsCurrentAnimation("smelting_pst") then
        --            inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/move_1")
        --        end
        --    end )
		-- inst:DoTaskInTime(8/30, function()
        --         if inst.AnimState:IsCurrentAnimation("smelting_pst") then
        --            inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/move_2")
        --        end
        --    end )
		-- inst:DoTaskInTime(14/30, function()
        --         if inst.AnimState:IsCurrentAnimation("smelting_pst") then
        --            inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/pour")
        --        end
        --    end )
		-- inst:DoTaskInTime(31/30, function()
        --         if inst.AnimState:IsCurrentAnimation("smelting_pst") then
        --            inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/steam")
        --        end
        --    end )
        -- inst:DoTaskInTime(36/30, function()
        --         if inst.AnimState:IsCurrentAnimation("smelting_pst") then
        --            inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/brick")
        --        end
        --    end )
        -- inst:DoTaskInTime(49/30, function()
        --         if inst.AnimState:IsCurrentAnimation("smelting_pst") then
        --            inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/move_2")
        --        end
        --    end )
        --    --play a one-off sound
	end
end

local function continuedonefn(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("idle_full")
		ShowProduct(inst)
	end
end

local function continuecookfn(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("smelting_loop", true)
		--play a looping sound
		inst.Light:Enable(true)

		-- inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/smelt_LP", "snd")
	end
end

local function harvestfn(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("idle_empty")
	end
end

local function getstatus(inst)
	if inst:HasTag("burnt") then
		return "BURNT"
	elseif inst.components.ndnr_melter.cooking and inst.components.ndnr_melter:GetTimeToCook() > 15 then
		return "COOKING_LONG"
	elseif inst.components.ndnr_melter.cooking then
		return "COOKING_SHORT"
	elseif inst.components.ndnr_melter.done then
		return "DONE"
	else
		return "EMPTY"
	end
end

local function onfar(inst)
	if inst.components.container then
		inst.components.container:Close()
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle_empty")
	-- inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/build")
	-- inst:DoTaskInTime(1/30, function()
    --             if inst.AnimState:IsCurrentAnimation("place") then
    --                inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/brick")
    --            end
    --        end )
	-- inst:DoTaskInTime(4/30, function()
    --             if inst.AnimState:IsCurrentAnimation("place") then
    --                inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/brick")
    --            end
    --        end )
	-- inst:DoTaskInTime(8/30, function()
    --             if inst.AnimState:IsCurrentAnimation("place") then
    --                inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/brick")
    --            end
    --        end )
	-- inst:DoTaskInTime(12/30, function()
    --             if inst.AnimState:IsCurrentAnimation("place") then
    --                inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/brick")
    --            end
    --        end )
	-- inst:DoTaskInTime(14/30, function()
    --             if inst.AnimState:IsCurrentAnimation("place") then
    --                inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/brick")
    --            end
    --        end )
end

local function onsave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
end

local function onload(inst, data)
	if data and data.burnt then
        inst.components.burnable.onburnt(inst)
        inst.Light:Enable(false)
    end
end

local containers = require("containers")
local params = containers.params
params.ndnr_smelter =
{
    widget =
    {
        slotpos =
        {
            Vector3(0, 64 + 32 + 8 + 4, 0),
            Vector3(0, 32 + 4, 0),
            Vector3(0, -(32 + 4), 0),
            Vector3(0, -(64 + 32 + 8 + 4), 0),
        },
        animbank = "ui_cookpot_1x4",
        animbuild = "ui_cookpot_1x4",
        pos = Vector3(200, 0, 0),
        side_align_tip = 100,
        buttoninfo =
        {
            text = STRINGS.ACTIONS.NDNR_SMELT,
            position = Vector3(0, -165, 0),
        }
    },
    -- acceptsstacks = false,
    type = "cooker",
}

function params.ndnr_smelter.itemtestfn(container, item, slot)
	if not container.inst:HasTag("burnt") then
		return item:HasTag("ndnr_canrefine")
	end
end

function params.ndnr_smelter.widget.buttoninfo.fn(inst, doer)
    if inst.components.container ~= nil then
        BufferedAction(doer, inst, ACTIONS.NDNR_MELTER):Do()
    elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
        SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.NDNR_MELTER.code, inst, ACTIONS.NDNR_MELTER.mod_name)
    end
end

function params.ndnr_smelter.widget.buttoninfo.validfn(inst)
    return inst.replica.container ~= nil and inst.replica.container:IsFull()
end

-- local function onFloodedStart(inst)
-- 	if inst.components.container then
-- 		inst.components.container.canbeopened = false
-- 	end
-- 	if inst.components.ndnr_melter then
-- 		if inst.components.ndnr_melter.cooking then
-- 			inst.components.ndnr_melter.product = "wetgoop"
-- 		end
-- 	end
-- end

-- local function onFloodedEnd(inst)
-- 	if inst.components.container then
-- 		inst.components.container.canbeopened = true
-- 	end
-- end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
	inst.MiniMapEntity:SetIcon("ndnr_smelter.tex")

    local light = inst.entity:AddLight()
    inst.Light:Enable(false)
	inst.Light:SetRadius(.6)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(235/255,62/255,12/255)
    --inst.Light:SetColour(1,0,0)

    inst:AddTag("structure")
    inst:AddTag("ndnr_smelter")
    MakeObstaclePhysics(inst, .5)

    inst.AnimState:SetBank("smelter")
    inst.AnimState:SetBuild("smelter")
    inst.AnimState:PlayAnimation("idle_empty")

    inst.entity:SetPristine()

	if not TheWorld.ismastersim then return inst end

    inst:AddComponent("ndnr_melter")
    inst.components.ndnr_melter.onstartcooking = startcookfn
    inst.components.ndnr_melter.oncontinuecooking = continuecookfn
    inst.components.ndnr_melter.oncontinuedone = continuedonefn
    inst.components.ndnr_melter.ondonecooking = donecookfn
    inst.components.ndnr_melter.onharvest = harvestfn
    inst.components.ndnr_melter.onspoil = spoilfn

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("ndnr_smelter")
	inst.components.container.onopenfn = onopen
	inst.components.container.onclosefn = onclose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true

    inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(3,5)
    inst.components.playerprox:SetOnPlayerFar(onfar)

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)

	inst:ListenForEvent( "onbuilt", onbuilt)

	MakeMediumBurnable(inst, nil, nil, true)
	MakeSmallPropagator(inst)

	inst.OnSave = onsave
   	inst.OnLoad = onload

    return inst
end

return Prefab("ndnr_smelter", fn, assets, prefabs),
	MakePlacer("ndnr_smelter_placer", "smelter", "smelter", "idle_empty")
