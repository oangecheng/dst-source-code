local function MakeSpice(name,data)
    local assets =
    {
        Asset("ANIM", "anim/medal_spices.zip"),
        Asset("ATLAS", "images/"..name..".xml"),
		Asset("ATLAS_BUILD", "images/"..name..".xml",256),
    }
	local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("medal_spices")
        inst.AnimState:SetBuild("medal_spices")
        inst.AnimState:PlayAnimation(name)
        inst.AnimState:OverrideSymbol("swap_spice", "medal_spices", name)
		
        inst:AddTag("spice")
		--客机扩展函数
		if data.client_fn then
			data.client_fn(inst)
		end

        MakeInventoryFloatable(inst, "med", nil, 0.7)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = name
		inst.components.inventoryitem.atlasname = "images/"..name..".xml"
		--主机扩展函数
		if data.server_fn then
			data.server_fn(inst)
		end

        MakeHauntableLaunch(inst)

        return inst
    end

    return Prefab(name, fn, assets)
end

local medal_spices={}

for k, v in pairs(require("medal_defs/medal_spice_defs")) do
    table.insert(medal_spices, MakeSpice(k,v))
end

return unpack(medal_spices)
