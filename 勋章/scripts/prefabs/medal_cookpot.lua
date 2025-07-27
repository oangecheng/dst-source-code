require "prefabutil"

local cooking = require("cooking")

local assets =
{
	Asset("ANIM", "anim/cook_pot.zip"),
	Asset("ANIM", "anim/medal_cookpot.zip"),
	Asset("ANIM", "anim/cook_pot_food.zip"),
	Asset("ANIM", "anim/cook_pot_food2.zip"),
	Asset("ANIM", "anim/cook_pot_food3.zip"),
	Asset("ANIM", "anim/cook_pot_food4.zip"),
	Asset("ANIM", "anim/cook_pot_food5.zip"),
	Asset("ANIM", "anim/cook_pot_food6.zip"),
	Asset("ANIM", "anim/ui_cookpot_1x4.zip"),
	Asset("ATLAS", "images/medal_cookpot.xml"),
	Asset("IMAGE", "images/medal_cookpot.tex"),
	Asset("ATLAS", "minimap/medal_cookpot.xml" ),
}

local prefabs =
{
    "collapse_small",
}

for k, v in pairs(cooking.recipes.cookpot) do
    table.insert(prefabs, v.name)

	if v.overridebuild then
        table.insert(assets, Asset("ANIM", "anim/"..v.overridebuild..".zip"))
	end
end

for k, v in pairs(cooking.recipes.portablecookpot) do
    table.insert(prefabs, v.name)

	if v.overridebuild then
        table.insert(assets, Asset("ANIM", "anim/"..v.overridebuild..".zip"))
	end
end

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    if not inst:HasTag("burnt") and inst.components.stewer.product ~= nil and inst.components.stewer:IsDone() then
        inst.components.stewer:Harvest()
    end
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        if inst.components.stewer:IsCooking() then
            inst.AnimState:PlayAnimation("hit_cooking")
            inst.AnimState:PushAnimation("cooking_loop", true)
            inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
        elseif inst.components.stewer:IsDone() then
            inst.AnimState:PlayAnimation("hit_full")
            inst.AnimState:PushAnimation("idle_full", false)
        else
            if inst.components.container ~= nil and inst.components.container:IsOpen() then
                inst.components.container:Close()
                --onclose will trigger sfx already
            else
                inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
            end
            inst.AnimState:PlayAnimation("hit_empty")
            inst.AnimState:PushAnimation("idle_empty", false)
        end
    end
end

--anim and sound callbacks

local function startcookfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("cooking_loop", true)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
        inst.Light:Enable(true)
    end
end

local function onopen(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("cooking_pre_loop")
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_open")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot", "snd")
    end
end

local function onclose(inst)
    if not inst:HasTag("burnt") then 
        if not inst.components.stewer:IsCooking() then
            inst.AnimState:PlayAnimation("idle_empty")
            inst.SoundEmitter:KillSound("snd")
        end
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
    end
end
--设置贴图
local function SetProductSymbol(inst, product, overridebuild)
    local recipe = cooking.GetRecipe(inst.prefab, product)
    local potlevel = recipe ~= nil and recipe.potlevel or nil
    -- local build = overridebuild or (recipe ~= nil and recipe.overridebuild) or "cook_pot_food"
    local build = (recipe ~= nil and recipe.overridebuild) or overridebuild or "cook_pot_food"
    local overridesymbol = (recipe ~= nil and recipe.overridesymbolname) or product
	-- print(overridebuild)
	-- print("build:"..build..",symbol:"..overridesymbol)

    if potlevel == "high" then
        inst.AnimState:Show("swap_high")
        inst.AnimState:Hide("swap_mid")
        inst.AnimState:Hide("swap_low")
    elseif potlevel == "low" then
        inst.AnimState:Hide("swap_high")
        inst.AnimState:Hide("swap_mid")
        inst.AnimState:Show("swap_low")
    else
        inst.AnimState:Hide("swap_high")
        inst.AnimState:Show("swap_mid")
        inst.AnimState:Hide("swap_low")
    end

    inst.AnimState:OverrideSymbol("swap_cooked", build, overridesymbol)
end

local function spoilfn(inst)
    if not inst:HasTag("burnt") then
        inst.components.stewer.product = inst.components.stewer.spoiledproduct
        SetProductSymbol(inst, inst.components.stewer.product)
    end
end
--展示料理
local function ShowProduct(inst)
    if not inst:HasTag("burnt") then
        local product = inst.components.stewer.product
        -- SetProductSymbol(inst, product, IsModCookingProduct(inst.prefab, product) and product or nil)
        SetProductSymbol(inst, product, not IsNativeCookingProduct(product) and product or nil)
    end
end

local function donecookfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("cooking_pst")
        inst.AnimState:PushAnimation("idle_full", false)
        ShowProduct(inst)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_finish")
        inst.Light:Enable(false)
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
        inst.AnimState:PlayAnimation("cooking_loop", true)
        inst.Light:Enable(true)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
    end
end

local function harvestfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("idle_empty")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
    end
end

local function getstatus(inst)
    return (inst:HasTag("burnt") and "BURNT")
        or (inst.components.stewer:IsDone() and "DONE")
        or (not inst.components.stewer:IsCooking() and "EMPTY")
        or (inst.components.stewer:GetTimeToCook() > 15 and "COOKING_LONG")
        or "COOKING_SHORT"
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle_empty", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/cook_pot_craft")
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
        inst.Light:Enable(false)
    end   
end

local function onloadpostpass(inst, newents, data)
    if data and data.additems and inst.components.container then
        for i, itemname in ipairs(data.additems)do
            local ent = SpawnPrefab(itemname)
            inst.components.container:GiveItem( ent )
        end
    end
end

local function cookpot_archive(inst)
    inst.AnimState:SetBank("cook_pot")
    inst.AnimState:SetBuild("medal_cookpot")
    inst.AnimState:PlayAnimation("idle_empty") 
	inst.MiniMapEntity:SetIcon("medal_cookpot.tex")
end

local function cookpot_archive_master(inst)
    inst.components.container:WidgetSetup("medal_cookpot")
end

local function MakeCookPot(name, common_postinit, master_postinit, assets, prefabs)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddLight()
        inst.entity:AddNetwork()

        MakeObstaclePhysics(inst, .5)

        inst.Light:Enable(false)
        inst.Light:SetRadius(.6)
        inst.Light:SetFalloff(1)
        inst.Light:SetIntensity(.5)
        inst.Light:SetColour(235/255,62/255,12/255)
        --inst.Light:SetColour(1,0,0)

        inst:AddTag("structure")

        --stewer (from stewer component) added to pristine state for optimization
        inst:AddTag("stewer")
        inst:AddTag("medal_skinable")--可换皮肤

        if common_postinit ~= nil then
            common_postinit(inst)
        end

        MakeSnowCoveredPristine(inst)
		
		-- inst:SetPrefabNameOverride("archive_cookpot")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stewer")
		inst.components.stewer.cooktimemult = TUNING_MEDAL.PORTABLE_COOK_POT_TIME_MULTIPLIER--烹饪时间为原来的0.6倍
        inst.components.stewer.onstartcooking = startcookfn
        inst.components.stewer.oncontinuecooking = continuecookfn
        inst.components.stewer.oncontinuedone = continuedonefn
        inst.components.stewer.ondonecooking = donecookfn
        inst.components.stewer.onharvest = harvestfn
        inst.components.stewer.onspoil = spoilfn

        inst:AddComponent("container")
        -- inst.components.container:WidgetSetup("cookpot")
        inst.components.container.onopenfn = onopen
        inst.components.container.onclosefn = onclose
        inst.components.container.skipclosesnd = true
        inst.components.container.skipopensnd = true

        inst:AddComponent("inspectable")
        inst.components.inspectable.getstatus = getstatus

        inst:AddComponent("lootdropper")
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(4)
        inst.components.workable:SetOnFinishCallback(onhammered)
        inst.components.workable:SetOnWorkCallback(onhit)

        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
        --inst.components.hauntable:SetOnHauntFn(OnHaunt)

        MakeSnowCovered(inst)
        inst:ListenForEvent("onbuilt", onbuilt)

        -- MakeMediumBurnable(inst, nil, nil, true)
        MakeSmallPropagator(inst)

        inst.OnSave = onsave 
        inst.OnLoad = onload
        inst.OnLoadPostPass = onloadpostpass

        if master_postinit ~= nil then
            master_postinit(inst)
        end

        inst:AddComponent("medal_skinable")

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end 

return MakeCookPot("medal_cookpot", cookpot_archive, cookpot_archive_master, assets, prefabs),
    MakePlacer("medal_cookpot_placer", "cook_pot", "medal_cookpot", "idle_empty")
