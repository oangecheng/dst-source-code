require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/dragonfly_chest.zip"),
	Asset("ANIM", "anim/medal_krampus_chest.zip"),
	Asset("ANIM", "anim/medal_krampus_chest_skin1.zip"),
	Asset("ANIM", "anim/medal_krampus_chest_skin2.zip"),
    Asset("ANIM", "anim/ui_chester_shadow_3x4.zip"),
	Asset("ATLAS", "minimap/medal_krampus_chest_item.xml" ),
}

local assets_item =
{
    Asset("ANIM", "anim/medal_krampus_chest_item.zip"),
    Asset("ANIM", "anim/medal_krampus_chest_item_skin1.zip"),
    Asset("ANIM", "anim/medal_krampus_chest_item_skin2.zip"),
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
			-- local skinid=inst.components.medal_skinable.skinid
			newitem.components.medal_skinable:SetSkin(inst.components.medal_skinable.skinid)
			-- local skin_info=newitem.components.medal_skinable:GetSkinData(skinid)
			-- if skin_info and skin_info.reskin_fn then
			-- 	skin_info.reskin_fn(newitem)
			-- end
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
	if inst:HasTag("keepfresh") then
		if obj.setImmortal then
			obj.setImmortal(obj)
		end
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

--物品保鲜效率
local function itemPreserverRate(inst, item)
	return (item ~= nil and not (item:HasTag("fish") or item.components.health~=nil)) and 0 or nil
end

--赋予不朽之力
local function setImmortal(inst)
	inst:AddTag("keepfresh")
	if inst.components.preserver==nil then
		inst:AddComponent("preserver")
	end
	inst.components.preserver:SetPerishRateMultiplier(function(inst, item)
		return (item ~= nil and not (item:HasTag("fish") or item.components.health~=nil)) and 0 or nil
	end)
	inst.immortalchangename:set(true)--修改名字
end

--名字加上不朽前缀
local function setNewName(inst)
	inst.immortalchangename = net_bool(inst.GUID, "immortalchangename", "immortalchangenamedirty")
	inst:ListenForEvent("immortalchangenamedirty", function(inst)
		if inst:HasTag("keepfresh") then
			if inst.immortalchangename:value() then
				--加上不朽前缀
				inst.displaynamefn = function(aaa)
					return subfmt(STRINGS.NAMES["IMMORTAL_BACKPACK"], { backpack = STRINGS.NAMES[string.upper(inst.prefab)] })
				end
			end
		end
	end)
end

--保存函数
local function onsave(inst,data)
	if inst:HasTag("keepfresh") then
		data.immortal=true
	end
end
--加载函数
local function onload(inst,data)
	if data~=nil and data.immortal then
		if inst.setImmortal then
			inst.setImmortal(inst)
		end
	end
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
    inst:AddTag("canbeimmortal")--可以被赋予不朽之力
	inst:AddTag("medal_skinable")--可换皮肤
	
	setNewName(inst)

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		return inst
    end
	
	--赋予不朽之力
	inst.setImmortal=setImmortal
	-- inst.no_consume_essences=true--不消耗不朽精华 

    inst:AddComponent("inspectable")
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("medal_krampus_chest")
    -- inst.components.container:WidgetSetup("dragonflychest")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
	
	-- inst:AddComponent("preserver")
	-- inst.components.preserver:SetPerishRateMultiplier(itemPreserverRate)--保鲜

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst.dismantle=onhammered--拆卸

    inst:ListenForEvent("onbuilt", onbuilt)

	inst:AddComponent("medal_skinable")
	
	inst.OnSave = onsave
	inst.OnLoad = onload
	
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
	inst:AddTag("canbeimmortal")--可以被赋予不朽之力
	inst:AddTag("medal_skinable")--可换皮肤
	
	setNewName(inst)

    MakeInventoryFloatable(inst, "med")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	--赋予不朽之力
	inst.setImmortal=setImmortal
	-- inst.no_consume_essences=true--不消耗不朽精华 

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
	
	inst.OnSave = onsave
	inst.OnLoad = onload

    -- MakeMediumBurnable(inst)
    -- MakeSmallPropagator(inst)

    return inst
end

return Prefab("medal_krampus_chest", fn, assets,prefabs),
    MakePlacer("medal_krampus_chest_item_placer", "dragonfly_chest", "medal_krampus_chest", "closed"),
    MakePlacer("medal_krampus_chest_item_skin1_placer", "dragonfly_chest", "medal_krampus_chest_skin1", "closed"),
    MakePlacer("medal_krampus_chest_item_skin2_placer", "dragonfly_chest", "medal_krampus_chest_skin2", "closed"),
    Prefab("medal_krampus_chest_item", itemfn, assets_item, prefabs_item)
