require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/multivariate_certificate.zip"),
	Asset("ATLAS", "images/multivariate_certificate.xml"),
	Asset("ATLAS", "images/medium_multivariate_certificate.xml"),
	Asset("ATLAS", "images/large_multivariate_certificate.xml"),
	Asset("ATLAS_BUILD", "images/multivariate_certificate.xml",256),
	Asset("ATLAS_BUILD", "images/medium_multivariate_certificate.xml",256),
	Asset("ATLAS_BUILD", "images/large_multivariate_certificate.xml",256),
}
--初始化融合勋章栏
local function medal_list_init(num)
	local medal_list={}--镶嵌位
	local slotnum = num or 3--格子数
	for i=1,slotnum do
		medal_list[i]={item=nil}
	end
	return medal_list
end
--读取容器内道具
local function getMedalList(inst)
	local items=nil
	if inst.components.container then
		items=inst.components.container:FindItems(function(canshu) return true end)
	end
	return items
end
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
--移除标签
local function removeTagfromList(inst,tagdata)
	if inst:HasTag(tagdata) then
		inst:RemoveTag(tagdata)
	end
	for i,v in ipairs(inst.tag_list) do
		if tagdata == v then
			table.remove(inst.tag_list,i)
			break
		end
	end
end
--添加标签
local function addTagToList(inst,tagdata)
	inst:AddTag(tagdata)
	table.insert(inst.tag_list,tagdata)
end
--取出道具
local function itemloseFn(inst,data)
	if data~=nil then
		if inst.medal_list[data.slot].item ~=nil then
			--移除勋章组标签
			if inst.medal_list[data.slot].item.grouptag~=nil then 
				removeTagfromList(inst,inst.medal_list[data.slot].item.grouptag)
			else
				removeTagfromList(inst,inst.medal_list[data.slot].item.prefab)
			end
		end
		if inst.components.equippable:IsEquipped() then
			local owner=inst.components.inventoryitem.owner
			if owner ~= nil then
				doMedalListOnUnequipFn(inst,inst.medal_list[data.slot].item,owner)
			end
		end
		inst.medal_list[data.slot].item=nil
	end
end
--存入道具
local function gotnewitemFn(inst,data)
	if data~= nil then
		inst.medal_list[data.slot].item=data.item
		--添加勋章组标签
		if data.item.grouptag~=nil then
			addTagToList(inst,data.item.grouptag)
		else
			addTagToList(inst,data.item.prefab)
		end
		if inst.components.equippable:IsEquipped() then
			local owner=inst.components.inventoryitem.owner
			if owner ~= nil then
				doMedalListOnEquipFn(inst,inst.medal_list[data.slot].item,owner)
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
	local items=nil
	local itemSlot=1
	inst.medal_list=medal_list_init(inst.slotnum)--初始化镶嵌位
	items=getMedalList(inst)
	
	if items~=nil then
		--第一次装备的时候挂个延迟，免得加载后部分数据不能及时生效
		if not inst.isfirstequip then
			inst:DoTaskInTime(0.3, function()
				for i, v in ipairs(items) do
					itemSlot=inst.components.container:GetItemSlot(v)
					inst.medal_list[itemSlot].item=v
					doMedalListOnEquipFn(inst,v,owner)
				end
			end)
			inst.isfirstequip=true
		else
			for i, v in ipairs(items) do
				itemSlot=inst.components.container:GetItemSlot(v)
				inst.medal_list[itemSlot].item=v
				doMedalListOnEquipFn(inst,v,owner)
			end
		end
	end
end
--卸下
local function onunequipfn(inst,owner)
	inst.components.container:Close()
	if #inst.medal_list >0 then
		for i, v in ipairs(inst.medal_list) do
			if v.item~=nil then
				doMedalListOnUnequipFn(inst,v.item,owner)
			end
		end
	end
end
--保存
local function onsavefn(inst,data)
	data.tagsList={}
	if #inst.tag_list>0 then
		for i, v in ipairs(inst.tag_list) do
			table.insert(data.tagsList, v)
		end
	end
end

--加载
local function onloadfn(inst,data)
	inst.tag_list={}
	if data~=nil and data.tagsList~=nil then
		for i, v in ipairs(data.tagsList) do
			table.insert(inst.tag_list, v)
			inst:AddTag(v)
		end
	end
end

--显示融合勋章内勋章
local function getMedalInfo(inst)
	if inst.components.container then
		local numslots=inst.components.container:GetNumSlots()
		local medalstr=""
		if numslots and numslots>0 then
			local medalcount=0
			for i=1,numslots do--遍历格子
				local medal=inst.components.container:GetItemInSlot(i)--获取对应格子上的勋章
				if medal then
					local prefabname=medal:GetDisplayName() or medal.prefab--获取勋章名字
					if medalcount>0 and medalcount%3==0 then
						medalstr=medalstr.."\n"
					end
					medalstr=medalstr..prefabname.."|"
					medalcount=medalcount+1
				end
			end
		end
		return medalstr~="" and string.sub(medalstr,1,-2) or STRINGS.MEDAL_INFO.BLANK
	end
end

--定义融合勋章(预制物名,格子数量)
local function MakeMultivariateMedal(name,slotnum)
	local function fn()
	    local inst = CreateEntity()
	
	    inst.entity:AddTransform()
	    inst.entity:AddAnimState()
	    inst.entity:AddSoundEmitter()
	    inst.entity:AddNetwork()
		
		MakeInventoryPhysics(inst)
	    
		inst.tag_list={}--Tag列表，标记相同勋章用
		inst.medal_list=medal_list_init(slotnum)--初始化镶嵌位
		inst.slotnum=slotnum--记录格子数量
		
	    inst.AnimState:SetBank("multivariate_certificate")
	    inst.AnimState:SetBuild("multivariate_certificate")
	    inst.AnimState:PlayAnimation(name)
		
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

return MakeMultivariateMedal("multivariate_certificate",3),
	MakeMultivariateMedal("medium_multivariate_certificate",4),
	MakeMultivariateMedal("large_multivariate_certificate",6)

