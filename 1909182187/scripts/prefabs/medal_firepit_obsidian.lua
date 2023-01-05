require "prefabutil"



local function onhammered(inst, worker)
    local x, y, z = inst.Transform:GetWorldPosition()
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("ash").Transform:SetPosition(x, y, z)
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(x, y, z)
    fx:SetMaterial("stone")
    inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle")
end

local function onextinguish(inst)
    if inst.components.fueled ~= nil then
        inst.components.fueled:InitializeFuelLevel(0)
    end
end

local function ontakefuel(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
end

local function updatefuelrate(inst)
    inst.components.fueled.rate = TheWorld.state.israining and 1 + TUNING_MEDAL.OBSIDIANFIREPIT_RAIN_RATE * TheWorld.state.precipitationrate or 1
end

local function onupdatefueled(inst)
    if inst.components.burnable ~= nil and inst.components.fueled ~= nil then
        updatefuelrate(inst)
        inst.components.burnable:SetFXLevel(inst.components.fueled:GetCurrentSection(), inst.components.fueled:GetSectionPercent())
    end
end

local function onfuelchange(newsection, oldsection, inst)
    if newsection <= 0 then
        inst.components.burnable:Extinguish()
    else
        if not inst.components.burnable:IsBurning() then
            updatefuelrate(inst)
            inst.components.burnable:Ignite()
        end
        inst.components.burnable:SetFXLevel(newsection, inst.components.fueled:GetSectionPercent())
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
end

local SECTION_STATUS =
{
    [0] = "OUT",
    [1] = "EMBERS",
    [2] = "LOW",
    [3] = "NORMAL",
    [4] = "HIGH",
}
local function getstatus(inst)
    return SECTION_STATUS[inst.components.fueled:GetCurrentSection()]
end

local function OnHaunt(inst, haunter)
    if math.random() <= TUNING.HAUNT_CHANCE_RARE and
        inst.components.fueled ~= nil and
        not inst.components.fueled:IsEmpty() then
        inst.components.fueled:DoDelta(TUNING.MED_FUEL)
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
        return true
    end
    return false
end

local function OnInit(inst)
    if inst.components.burnable ~= nil then
        inst.components.burnable:FixFX()
    end
end

local function OnSave(inst, data)
	data._has_debuffable = inst.components.debuffable ~= nil 
end

local function OnPreLoad(inst, data)
	if data ~= nil and data._has_debuffable then
		inst:AddComponent("debuffable")
	end
end
--生成黑曜石火坑(火坑名，是否为冰火)
local function MakeMedalFirepit(name,iscold)
	local assets =
	{
		Asset("ANIM", "anim/"..name..".zip"),
		Asset("ATLAS", "minimap/"..name..".xml"),
		Asset("ATLAS", "images/"..name..".xml"),
		Asset("IMAGE", "images/"..name..".tex"),
	}

	local prefabs =
	{
		"medal_obsidianfirefire",
		"medal_obsidiancoldfirefire",
		"collapse_small",
		"ash",
	}
	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddMiniMapEntity()
		inst.entity:AddNetwork()

		inst.MiniMapEntity:SetIcon(name..".tex")
		inst.MiniMapEntity:SetPriority(1)

		-- inst.AnimState:SetBank(name)
		inst.AnimState:SetBank("coldfirepit")
		inst.AnimState:SetBuild(name)
		inst.AnimState:PlayAnimation("idle", false)

		inst:AddTag("campfire")
		inst:AddTag("structure")
		inst:AddTag("wildfireprotected")
		inst:AddTag("storytellingprop")
		inst:AddTag("medal_campfire")--勋章篝火标识，用来防止被灭火器灭了
		-- inst:AddTag("burnt")--烧焦(用来防止被灭火器灭了)
		if iscold then
			inst:AddTag("blueflame")
		end

		MakeObstaclePhysics(inst, .3)

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		-----------------------
		inst:AddComponent("burnable")
		--inst.components.burnable:SetFXLevel(2)
		if iscold then
			inst.components.burnable:AddBurnFX("medal_obsidiancoldfirefire", Vector3(0, .05, 0), nil, true)
		else
			inst.components.burnable:AddBurnFX("medal_obsidianfirefire", Vector3(0, .55, 0), nil, true)
		end
		inst:ListenForEvent("onextinguish", onextinguish)

		-------------------------
		inst:AddComponent("lootdropper")
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetWorkLeft(4)
		inst.components.workable:SetOnFinishCallback(onhammered)
		inst.components.workable:SetOnWorkCallback(onhit)

		if not iscold then
			inst:AddComponent("cooker")
		end
		
		-------------------------
		inst:AddComponent("fueled")
		inst.components.fueled.maxfuel = TUNING_MEDAL.OBSIDIANFIREPIT_FUEL_MAX
		inst.components.fueled.accepting = true
		if iscold then
			inst.components.fueled.secondaryfueltype = FUELTYPE.CHEMICAL
		end
		inst.components.fueled:SetSections(4)
		inst.components.fueled.bonusmult = TUNING_MEDAL.OBSIDIANFIREPIT_BONUS_MULT
		inst.components.fueled:SetTakeFuelFn(ontakefuel)
		inst.components.fueled:SetUpdateFn(onupdatefueled)
		inst.components.fueled:SetSectionCallback(onfuelchange)
		inst.components.fueled:InitializeFuelLevel(TUNING_MEDAL.OBSIDIANFIREPIT_FUEL_START)

		-----------------------------
		inst:AddComponent("storytellingprop")

		inst:AddComponent("inspectable")
		inst.components.inspectable.getstatus = getstatus

		inst:AddComponent("hauntable")
		inst.components.hauntable.cooldown = TUNING.HAUNT_COOLDOWN_HUGE
		inst.components.hauntable:SetOnHauntFn(OnHaunt)

		inst:ListenForEvent("onbuilt", onbuilt)

		inst:DoTaskInTime(0, OnInit)

		inst.OnSave = OnSave
		inst.OnPreLoad = OnPreLoad

		return inst
	end

	return Prefab(name, fn, assets, prefabs)

end

return MakeMedalFirepit("medal_firepit_obsidian",false),
	MakeMedalFirepit("medal_coldfirepit_obsidian",true),
	MakePlacer("medal_firepit_obsidian_placer", "coldfirepit", "medal_firepit_obsidian", "preview"),
	MakePlacer("medal_coldfirepit_obsidian_placer", "coldfirepit", "medal_coldfirepit_obsidian", "preview")
