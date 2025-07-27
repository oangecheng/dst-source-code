local function MakeBook(def)
	local assets =
	{
	    Asset("ANIM", "anim/medal_books.zip"),
		Asset("ATLAS", "images/"..def.name..".xml"),
		Asset("ATLAS_BUILD", "images/"..def.name..".xml",256),
	}
	
	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)

		inst.AnimState:SetBank("medal_books")
		inst.AnimState:SetBuild("medal_books")
		inst.AnimState:PlayAnimation(def.anim)

		MakeInventoryFloatable(inst, "med", nil, 0.75)
		
		if def.radius then
			inst.medal_show_radius = def.radius
		end
		--添加功能标签
		if def.taglist and #def.taglist>0 then
			for _,v in ipairs(def.taglist) do
				inst:AddTag(v)
			end
		end
		-- inst:AddTag("book")--在书架上可恢复耐久(做梦！)
		inst:AddTag("bookcabinet_item")--可放入书架
		
		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		-----------------------------------

		inst:AddComponent("inspectable")
		inst:AddComponent("lootdropper")
		inst:AddComponent("book")
		inst.components.book:SetOnRead(def.readfn)
        inst.components.book:SetOnPeruse(def.perusefn)
        inst.components.book:SetReadSanity(def.read_sanity)
        inst.components.book:SetPeruseSanity(def.peruse_sanity)

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = def.name
		inst.components.inventoryitem.atlasname = "images/"..def.name..".xml"

		inst:AddComponent("finiteuses")
		inst.components.finiteuses:SetMaxUses(def.uses)
		inst.components.finiteuses:SetUses(def.uses)
		inst.components.finiteuses:SetOnFinished(inst.Remove)
		
		inst:AddComponent("fuel")
		inst.components.fuel.fuelvalue = TUNING.MED_FUEL

		MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
		MakeSmallPropagator(inst)

		MakeHauntableLaunch(inst)

		inst.ProphesyFn = def.prophesyfn--预言函数

		--主机额外扩展函数
		if def.extrafn then
			def.extrafn(inst)
		end

		return inst
	end
	return Prefab(def.name, fn, assets)
end

local books = {}
for i, v in ipairs(require("medal_defs/medal_book_defs")) do
    if not v.hide then
		table.insert(books, MakeBook(v))
	end
end
return unpack(books)

