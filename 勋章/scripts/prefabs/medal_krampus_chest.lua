require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/dragonfly_chest.zip"),
	Asset("ANIM", "anim/medal_krampus_chest.zip"),
    Asset("ANIM", "anim/ui_chester_shadow_3x4.zip"),
	Asset("ATLAS", "minimap/medal_krampus_chest_item.xml" ),
}

local assets_item =
{
    Asset("ANIM", "anim/medal_krampus_chest_item.zip"),
	Asset("ATLAS", "images/medal_krampus_chest_item.xml"),
	Asset("IMAGE", "images/medal_krampus_chest_item.tex"),
	Asset("ATLAS_BUILD", "images/medal_krampus_chest_item.xml",256),
}

local prefabs =
{
    "medal_krampus_chest_item",
}

local prefabs_item =
{
    "medal_krampus_chest",
}

local function onopen(inst)
    inst.AnimState:PlayAnimation("open")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
	if inst.components.inventoryitem then
		inst.components.inventoryitem:ChangeImageName(GetMedalSkinData(inst,"medal_krampus_chest_item","image").."_open")
	end
end

local function onclose(inst)
    inst.AnimState:PlayAnimation("closed")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
	if inst.components.inventoryitem then
		inst.components.inventoryitem:ChangeImageName(GetMedalSkinData(inst,"medal_krampus_chest_item","image"))
	end
end
--继承皮肤
local function inheritSkin(inst,newitem)
	--设定皮肤
	if inst.components.medal_skinable and inst.components.medal_skinable.skinid>0 then
		if newitem.components.medal_skinable then
			newitem.components.medal_skinable:SetSkin(inst.components.medal_skinable.skinid)
		end
	end
end

--转移容器内物品(原容器,新容器)
local function transferEverything(inst,obj)
	if inst.components.container and not inst.components.container:IsEmpty() then
		if obj.components.container then
			local allitems=inst.components.container:RemoveAllItemsWithSlot()
			if allitems then
				for k,v in pairs(allitems) do
					obj.components.container:GiveItem(v,k)
				end
			end
		end
	end
	--同步不朽之力
	if inst.components.medal_immortal ~= nil then
		inst.components.medal_immortal:SyncImmortal(obj)
	end
end
--锤了
local function onhammered(inst, worker)
	local item = inst.components.lootdropper:SpawnLootPrefab("medal_krampus_chest_item")
	inheritSkin(inst,item)--继承皮肤
	transferEverything(inst,item)
    inst:Remove()
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("closed", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/dragonfly_chest_craft")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("medal_krampus_chest_item.tex")

    inst.AnimState:SetBank("dragonfly_chest")--用龙鳞箱的bank
    inst.AnimState:SetBuild("medal_krampus_chest")
    inst.AnimState:PlayAnimation("closed",true)

    inst:AddTag("structure")
    inst:AddTag("chest")
	inst:AddTag("medal_skinable")--可换皮肤

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("medal_krampus_chest")
    -- inst.components.container:WidgetSetup("dragonflychest")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst.dismantle=onhammered--拆卸

    inst:ListenForEvent("onbuilt", onbuilt)

	inst:AddComponent("medal_skinable")

	inst:AddComponent("medal_immortal")--不朽组件
	inst.components.medal_immortal:SetMaxLevel(2)

    inst.transferEverything = transferEverything
	
    MakeSnowCovered(inst)
	--兼容智能木牌
	if TUNING.SMART_SIGN_DRAW_ENABLE then
		SMART_SIGN_DRAW(inst)
	end
	
	AddHauntableDropItemOrWork(inst)

    return inst
end

local function ondeploy(inst, pt, deployer)
    local chest = SpawnPrefab("medal_krampus_chest")
    if chest ~= nil then
        inheritSkin(inst,chest)--继承皮肤
		chest.Transform:SetPosition(pt.x,pt.y,pt.z)
		chest.AnimState:PlayAnimation("place")
        chest.AnimState:PushAnimation("closed", false)
        chest.SoundEmitter:PlaySound("dontstarve/common/dragonfly_chest_craft")
		transferEverything(inst,chest)
        inst:Remove()
    end
end
--掉落自动关闭
local function ondropped(inst)
    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
end

local function itemfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("medal_krampus_chest_item")
    inst.AnimState:SetBuild("medal_krampus_chest_item")
    inst.AnimState:PlayAnimation("closed",false)

    inst:AddTag("portableitem")
	inst:AddTag("medal_skinable")--可换皮肤
    inst:AddTag("nosteal")--不可偷

    MakeInventoryFloatable(inst, "med")

    -- inst.overridedeployplacername = "medal_krampus_chest_placer"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "medal_krampus_chest_item"
	inst.components.inventoryitem.atlasname = "images/medal_krampus_chest_item.xml"
	inst.components.inventoryitem.canonlygoinpocket = true--只能放在身上
	inst.components.inventoryitem:SetOnDroppedFn(ondropped)

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
	inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.DEFAULT)
	-- inst.components.deployable:SetDeploySpacing(1.5)
	
	inst:AddComponent("container")
	inst.components.container:WidgetSetup("medal_krampus_chest_item")
	inst.components.container.onopenfn = onopen
	inst.components.container.onclosefn = onclose

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	inst:AddComponent("medal_skinable")

	inst:AddComponent("medal_immortal")--不朽组件
	inst.components.medal_immortal:SetMaxLevel(2)

    inst.transferEverything = transferEverything

    SetAutoOpenContainer(inst)

    return inst
end

return Prefab("medal_krampus_chest", fn, assets,prefabs),
    MakePlacer("medal_krampus_chest_item_placer", "dragonfly_chest", "medal_krampus_chest", "closed"),
    Prefab("medal_krampus_chest_item", itemfn, assets_item, prefabs_item)
