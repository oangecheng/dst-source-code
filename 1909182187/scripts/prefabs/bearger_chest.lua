require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/dragonfly_chest.zip"),
	Asset("ANIM", "anim/bearger_chest.zip"),
	Asset("ANIM", "anim/bearger_chest_skin1.zip"),
	Asset("ANIM", "anim/medal_spacetime_chest.zip"),
    Asset("ANIM", "anim/ui_chester_shadow_3x4.zip"),
	Asset("ATLAS", "minimap/bearger_chest.xml" ),
	Asset("ATLAS", "images/bearger_chest.xml"),
	Asset("IMAGE", "images/bearger_chest.tex"),
}

local prefabs =
{
    "collapse_small",
}

local function onopen(inst)
    inst.AnimState:PlayAnimation("open")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
end

local function onclose(inst)
    inst.AnimState:PlayAnimation("closed")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
end

local function onhammered(inst, worker)
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
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("closed", false)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("closed", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/dragonfly_chest_craft")
end

--物品保鲜效率
local function itemPreserverRate(inst, item)
	return (item ~= nil and not (item:HasTag("fish") or item.components.health~=nil)) and 0 or nil
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("bearger_chest.tex")

    inst.AnimState:SetBank("dragonfly_chest")--用龙鳞箱的bank
    inst.AnimState:SetBuild("bearger_chest")
    inst.AnimState:PlayAnimation("closed",true)

    inst:AddTag("structure")
    inst:AddTag("chest")
	inst:AddTag("keepfresh")
	inst:AddTag("medal_skinable")--可换皮肤

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		-- inst.OnEntityReplicated = function(inst) 
			-- inst.replica.container:WidgetSetup("dragonflychest") 
		-- end
		return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("bearger_chest")
    -- inst.components.container:WidgetSetup("dragonflychest")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
	
	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(itemPreserverRate)--保鲜

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:ListenForEvent("onbuilt", onbuilt)
    MakeSnowCovered(inst)
	--兼容智能木牌
	if TUNING.SMART_SIGN_DRAW_ENABLE then
		SMART_SIGN_DRAW(inst)
	end
	
	AddHauntableDropItemOrWork(inst)

    inst:AddComponent("medal_skinable")

    return inst
end

return Prefab("bearger_chest", fn, assets),
    MakePlacer("bearger_chest_placer", "dragonfly_chest", "bearger_chest", "closed")
