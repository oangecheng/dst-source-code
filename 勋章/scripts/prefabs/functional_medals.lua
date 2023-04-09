local medal_defs=require("medal_defs/functional_medal_defs").MEDAL_DEFS

local function MakeCertificate(def)
	local assets={
		Asset("ANIM", "anim/functional_medals.zip"),
		Asset("ATLAS", "images/"..def.name..".xml"),
		Asset("ATLAS_BUILD", "images/"..def.name..".xml",256),
	}
	--存储函数
	local function onsavefn(inst,data)
		--勋章等级保存
		if inst.medal_level then
			data.medal_level=inst.medal_level
		end
		--扩展存储函数
		if def.onsavefn then
			def.onsavefn(inst,data)
		end
	end
	--加载函数
	local function onloadfn(inst,data)
		--勋章等级读取(这边因为历史原因用了表格,为了不被原数据炸档需要做这个判断)
		if data and data.medal_level then
			inst.medal_level = type(data.medal_level)=="table" and (data.medal_level[inst.prefab] or 1) or data.medal_level
			if medal_defs[inst.prefab] and medal_defs[inst.prefab].maxlevel then
				inst.medal_level=math.min(inst.medal_level,medal_defs[inst.prefab].maxlevel)
			else
				inst.medal_level=nil--这里用来清除被移除了等级机制的勋章等级
			end
			if inst.medal_level and inst.medal_level>1 and inst.changemedallevelname then
				inst.changemedallevelname:set(inst.medal_level)
			end
		end
		--扩展加载函数
		if def.onloadfn then
			def.onloadfn(inst,data)
		end
	end
	
	--初始化
	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		if def.hassound then inst.entity:AddSoundEmitter() end
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)

		inst.AnimState:SetBank("functional_medals")
		inst.AnimState:SetBuild("functional_medals")
		inst.AnimState:PlayAnimation(def.animname)
		
		inst:AddTag("medal")
		inst:AddTag(def.name)
		--添加功能标签
		if def.taglist and #def.taglist>0 then
			for _,v in ipairs(def.taglist) do
				inst:AddTag(v)
			end
		end
		--勋章组,相同勋章组的勋章不能同时装备
		if def.grouptag then
			inst:AddTag(def.grouptag)
			inst.grouptag=def.grouptag
		else
			inst.grouptag=def.name
		end
		--可升级
		if def.upgradable then
			inst.medal_level=1--初始等级
			inst.medal_level_max=def.maxlevel or 2
			inst.changemedallevelname = net_shortint(inst.GUID, "changemedallevelname", "changemedallevelnamedirty")
			inst:ListenForEvent("changemedallevelnamedirty", function(inst)
				if inst.changemedallevelname:value() then
					inst.displaynamefn = function(aaa)
						return subfmt(STRINGS.NAMES["SHOW_MEDAL_LEVEL"], { level=inst.changemedallevelname:value(),medal = STRINGS.NAMES[string.upper(inst.prefab)] })
					end
				end
			end)
		end
		
		inst.medal_repair_loot=def.medal_repair_loot--修补材料列表(fuel)
		inst.medal_addexp_loot=def.medal_addexp_loot--增加熟练度材料列表
		inst.medal_repair_common=def.medal_repair_common--修补材料列表(finiteuses)
		
		--客机额外扩展函数
		if def.client_extrafn then
			def.client_extrafn(inst)
		end
		
		inst.foleysound = "dontstarve/movement/foley/jewlery"
		
		MakeInventoryFloatable(inst,"med",0.1,0.65)

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst:AddComponent("inspectable")

		inst:AddComponent("equippable")
		inst.components.equippable.equipslot = EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY
		
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = def.name
		inst.components.inventoryitem.atlasname = "images/"..def.name..".xml"
		
		--添加燃料消耗组件
		if def.fuellevel then
			inst:AddComponent("fueled")
			inst.components.fueled:InitializeFuelLevel(def.fuellevel)
			if def.deletefn then
				inst.components.fueled:SetDepletedFn(def.deletefn)
			else
				inst.components.fueled:SetDepletedFn(inst.Remove)
			end
			if def.fueltype then
				inst.components.fueled.fueltype = def.fueltype --燃料修复
				inst.components.fueled.accepting = true
			end
		end
		
		--添加使用次数耐久组件
		if def.maxuses then
			inst:AddComponent("finiteuses")
			inst.components.finiteuses:SetMaxUses(def.maxuses)
			inst.components.finiteuses:SetUses(def.maxuses)
			if def.onfinishedfn then
				inst.components.finiteuses:SetOnFinished(def.onfinishedfn)
			else
				inst.components.finiteuses:SetOnFinished(inst.Remove)
			end
		end
		--装备、卸下函数
		inst.components.equippable:SetOnEquip(def.onequipfn)
		inst.components.equippable:SetOnUnequip(def.onunequipfn)
		inst.onequipwithrhfn=def.onequipwithrhfn
		inst.onunequipwithrhfn=def.onunequipwithrhfn
		
		--主机额外扩展函数
		if def.extrafn then
			def.extrafn(inst)
		end
		
		inst.OnSave = onsavefn
		inst.OnLoad = onloadfn

		MakeHauntableLaunch(inst)

		return inst
	end
	
	return Prefab(def.name, fn, assets)
end

local certificates={}
for i, v in pairs(medal_defs) do
    table.insert(certificates, MakeCertificate(v))
	if v.placer then
		table.insert(certificates,MakePlacer(v.placer.name, v.placer.bank_placer, v.placer.build_placer, v.placer.anim_placer))
	end
end
return unpack(certificates)

