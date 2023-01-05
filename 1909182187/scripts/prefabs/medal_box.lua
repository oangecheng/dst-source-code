require "prefabutil"

local function onopen(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
end

local function onclose(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
end

local function ondropped(inst)
    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
end

--定义盒子
local function MakeBox(name,box_def)
	local assets =
	{
	    Asset("ANIM", "anim/"..box_def.build..".zip"),
		Asset("ATLAS", "images/"..box_def.atlas..".xml"),
		Asset("ATLAS_BUILD", "images/"..box_def.atlas..".xml",256),
	}
	if box_def.skinname then
		for i, v in ipairs(box_def.skinname) do
			table.insert(assets,Asset("ANIM", "anim/"..v..".zip"))
		end
	end
	
	local function fn()
	    local inst = CreateEntity()
	
	    inst.entity:AddTransform()
	    inst.entity:AddAnimState()
	    inst.entity:AddSoundEmitter()
	    inst.entity:AddNetwork()
		
		MakeInventoryPhysics(inst)
	    
	    inst.AnimState:SetBank(box_def.bank)
	    inst.AnimState:SetBuild(box_def.build)
	    inst.AnimState:PlayAnimation(box_def.anim)
		
		MakeInventoryFloatable(inst, "med", nil, 0.75)
		
		if box_def.taglist then
			for _, tag in pairs(box_def.taglist) do
				inst:AddTag(tag)
			end
		end
		
	    inst.entity:SetPristine()
	
	    if not TheWorld.ismastersim then
	        return inst
	    end
	
	    inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = box_def.image
		inst.components.inventoryitem.atlasname = "images/"..box_def.atlas..".xml"
		
		inst.components.inventoryitem:SetOnDroppedFn(ondropped)
		
	    inst:AddComponent("container")
	    inst.components.container:WidgetSetup(box_def.weight)
	    inst.components.container.onopenfn = box_def.onopenfn or onopen
	    inst.components.container.onclosefn = box_def.onclosefn or onclose

		--扩展函数
		if box_def.extrafn then
			box_def.extrafn(inst)
		end
	
	    return inst
	end
	
	return Prefab(name, fn, assets)
end

local box_defs={}--盒子列表
--勋章盒
box_defs.medal_box={
	bank="medal_box",
	build="medal_box",
	anim="closed",
	image="medal_box",
	atlas="medal_box",
	taglist={"medal_box","medal_skinable"},
	weight="medal_box",
	skinname={"medal_box_skin1","medal_box_skin2"},
	onopenfn=function(inst)
		inst.AnimState:PlayAnimation("open")
		inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
		if inst.components.inventoryitem then
			inst.components.inventoryitem:ChangeImageName(GetMedalSkinData(inst,"medal_box","image").."_open")
		end
	end,
	onclosefn=function(inst)
		inst.AnimState:PlayAnimation("closed")
		inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
		if inst.components.inventoryitem then
			inst.components.inventoryitem:ChangeImageName(GetMedalSkinData(inst,"medal_box","image"))
		end
	end,
	extrafn=function(inst)--扩展函数
		inst:AddComponent("medal_skinable")
	end,
}
--调料盒
box_defs.spices_box={
	bank="spices_box",
	build="spices_box",
	anim="closed",
	image="spices_box",
	atlas="spices_box",
	taglist={"medal_skinable"},
	weight="spices_box",
	skinname={"spices_box_skin1","spices_box_skin2","spices_box_skin3"},
	onopenfn=function(inst)
		inst.AnimState:PlayAnimation("open")
		inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
		if inst.components.inventoryitem then
			inst.components.inventoryitem:ChangeImageName(GetMedalSkinData(inst,"spices_box","image").."_open")
		end
	end,
	onclosefn=function(inst)
		inst.AnimState:PlayAnimation("closed")
		inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
		if inst.components.inventoryitem then
			inst.components.inventoryitem:ChangeImageName(GetMedalSkinData(inst,"spices_box","image"))
		end
	end,
	extrafn=function(inst)--扩展函数
		inst:AddComponent("medal_skinable")
	end,
}
--弹药盒
box_defs.medal_ammo_box={
	bank="medal_ammo_box",
	build="medal_ammo_box",
	anim="medal_ammo_box",
	image="medal_ammo_box",
	atlas="medal_ammo_box",
	weight="medal_ammo_box",
}

local boxs={}
for k, v in pairs(box_defs) do
    table.insert(boxs, MakeBox(k,v))
end
return unpack(boxs)

