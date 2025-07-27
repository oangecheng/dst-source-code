require "prefabutil"

--执行勋章列表的装备函数
local function doMedalListOnEquipFn(inst,item,owner)
	if item and item.components.equippable then
		--对勋章自身生效
		local onequip=item.components.equippable.onequipfn
		if onequip~=nil then
			onequip(item,owner)
		end
		--对融合勋章生效
		if item.onequipwithrhfn then
			item.onequipwithrhfn(inst,item,owner)
		end
		
	end
end
--执行勋章列表的卸下函数
local function doMedalListOnUnequipFn(inst,item,owner)
	if item and item.components.equippable then
		--对勋章自身生效
		local onunequip=item.components.equippable.onunequipfn
		if onunequip~=nil then
			onunequip(item,owner)
		end
		--对融合勋章生效
		if item.onunequipwithrhfn then
			item.onunequipwithrhfn(inst,item,owner)
		end
	end
end
--取出道具
local function itemloseFn(inst,data)
	if data ~= nil and data.prev_item ~= nil then
		--移除勋章组标签
		inst:RemoveTag(data.prev_item.grouptag or data.prev_item.prefab)
		if inst.components.equippable:IsEquipped() then
			local owner=inst.components.inventoryitem:GetGrandOwner()
			if owner ~= nil then
				doMedalListOnUnequipFn(inst, data.prev_item, owner)
				--更新装备栏状态
				owner:PushEvent("equip", {item = inst, eslot = EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY})
			end
		end
	end
end
--存入道具
local function gotnewitemFn(inst,data)
	if data ~= nil and data.item ~= nil then
		--添加勋章组标签
		inst:AddTag(data.item.grouptag or data.item.prefab)
		if inst.components.equippable:IsEquipped() then
			local owner = inst.components.inventoryitem:GetGrandOwner()
			if owner ~= nil then
				doMedalListOnEquipFn(inst, data.item, owner)
				--更新装备栏状态
				owner:PushEvent("equip", { item = inst, eslot = EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY })
			end
		end
	end
end
--打开容器
local function onopen(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
end
--关闭容器
local function onclose(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
end
--掉落
local function ondropped(inst)
    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
end
--装备
local function onequipfn(inst,owner)
	inst.components.container:Open(owner)
	if inst.prefab == "origin_certificate" then
		owner:AddTag("has_origin_medal")
	end
	local items = inst.components.container and inst.components.container:GetAllItems()
	if items~=nil then
		for i, v in ipairs(items) do
			doMedalListOnEquipFn(inst,v,owner)
		end
	end
end
--卸下
local function onunequipfn(inst,owner)
	local items = inst.components.container and inst.components.container:GetAllItems()
	if items ~= nil then
		for i, v in ipairs(items) do
			doMedalListOnUnequipFn(inst,v,owner)
		end
	end
	--tag移除时间要晚于其他勋章卸下时间
	if inst.prefab == "origin_certificate" then
		owner:RemoveTag("has_origin_medal")
	end
	
	inst.components.container:Close()
end

--显示融合勋章内勋章
local function getMedalInfo(inst)
	if inst.components.container then
		local numslots=inst.components.container:GetNumSlots()
		local medalstr=""
		if numslots and numslots>0 then
			local medalcount = 0
			local colnum = numslots == 4 and 2 or 3--每行显示数量
			for i=1,numslots do--遍历格子
				local medal = inst.components.container:GetItemInSlot(i)--获取对应格子上的勋章
				local prefabname = medal and (medal:GetDisplayName() or medal.prefab) or "*"--获取勋章名字
				if medalcount > 0 and medalcount % colnum == 0 then
					medalstr = medalstr.."\n"
				end
				medalstr = medalstr..prefabname.."|"
				medalcount = medalcount + 1
			end
		end
		return medalstr~="" and string.sub(medalstr,1,-2) or STRINGS.MEDAL_INFO.BLANK
	end
end

--定义融合勋章(预制物名,格子数量)
local function MakeMultivariateMedal(name,anim)
	local assets =
	{
		Asset("ANIM", "anim/multivariate_certificate.zip"),
		Asset("ATLAS", "images/"..name..".xml"),
		Asset("ATLAS_BUILD", "images/"..name..".xml",256),
	}
	
	local function fn()
	    local inst = CreateEntity()
	
	    inst.entity:AddTransform()
	    inst.entity:AddAnimState()
	    inst.entity:AddSoundEmitter()
	    inst.entity:AddNetwork()
		
		MakeInventoryPhysics(inst)
		
	    inst.AnimState:SetBank("multivariate_certificate")
	    inst.AnimState:SetBuild("multivariate_certificate")
	    inst.AnimState:PlayAnimation(anim or name)
		
		inst:AddTag("medal")
		inst:AddTag("showmedalinfo")--显示详细信息
		inst:AddTag("multivariate_certificate")--融合勋章标签
		
		MakeInventoryFloatable(inst,"med",0.1,0.65)
		
	    inst.entity:SetPristine()
	
	    if not TheWorld.ismastersim then
	        return inst
	    end
	
	    inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = name
		inst.components.inventoryitem.atlasname = "images/"..name..".xml"
		
		inst.components.inventoryitem:SetOnDroppedFn(ondropped)
		
		inst:AddComponent("equippable")
		inst.components.equippable.equipslot = EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY
		inst.components.equippable:SetOnEquip(onequipfn)
		inst.components.equippable:SetOnUnequip(onunequipfn)
		
	    inst:AddComponent("container")
	    inst.components.container:WidgetSetup(name)
	    -- inst.components.container:WidgetSetup("multivariate_certificate")
		-- inst.components.container.canbeopened = false
	    inst.components.container.onopenfn = onopen
	    inst.components.container.onclosefn = onclose
		
		inst:ListenForEvent("itemlose", itemloseFn)
		inst:ListenForEvent("itemget",gotnewitemFn)

		inst.getMedalInfo = getMedalInfo
	
	    return inst
	end
	
	return Prefab(name, fn, assets)
end

return MakeMultivariateMedal("multivariate_certificate"),
	MakeMultivariateMedal("medium_multivariate_certificate"),
	MakeMultivariateMedal("large_multivariate_certificate"),
	MakeMultivariateMedal("origin_certificate","large_multivariate_certificate")

