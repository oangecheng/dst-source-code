local medal_skins=require("medal_defs/medal_skin_defs")
local assets =
{
    Asset("ANIM", "anim/medal_skin_coupon.zip"),
    Asset("ATLAS", "images/medal_skin_coupon.xml"),
	Asset("ATLAS_BUILD", "images/medal_skin_coupon.xml",256),
}

--记录皮肤数据
local function setSkinData(inst,skin_name,skin_id)
    print(skin_name,skin_id)
    inst.skin_name = skin_name
    inst.skin_id = skin_id
end
--皮肤列表
local skin_loot={
    {
        -- {name="medal_statue_marble_gugugu",id=1},--参考格式
    },--便宜皮肤(0,88)
    {},--中等皮肤[88,168]
    {},--高价皮肤(168,1000]
}
--初始化皮肤列表，把各种皮肤根据价格进行分类
if medal_skins then
    for k, v in pairs(medal_skins) do
        for _, i in ipairs(v.skin_info) do
            if i.price>168 then
                table.insert(skin_loot[3],{name=k,id=i.id})
            elseif i.price>=88 then
                table.insert(skin_loot[2],{name=k,id=i.id})
            elseif i.price>0 then
                table.insert(skin_loot[1],{name=k,id=i.id})
            end
        end
    end
end

--设置随机皮肤(inst,皮肤品级)
local function setRandomSkin(inst,level)
    local index = level or 1
    local data = GetRandomItem(skin_loot[index])
    if data then
        setSkinData(inst,data.name,data.id)
    end
end

--获取皮肤数据
local function getSkinInfo(inst)
    if medal_skins and inst.skin_name and inst.skin_id then
        local skindata = medal_skins[inst.skin_name]
        if skindata then
            local skininfo = skindata.skin_info[inst.skin_id]
            if skininfo then
                return (STRINGS.NAMES[string.upper(inst.skin_name)] or inst.skin_name) .."-".. skininfo.name
            end
        end
    end
    return STRINGS.MEDAL_SKIN_NAME.UNDEFINED
end

local function savefn(inst,data)
	--保存皮肤对应的预制物名
	if inst.skin_name then
		data.skin_name = inst.skin_name
	end
	--保存对应的皮肤ID
	if inst.skin_id then
		data.skin_id = inst.skin_id
	end
end

local function loadfn(inst,data)
	--读取皮肤信息
	if data then
		if data.skin_name then
			inst.skin_name = data.skin_name
		end
		if data.skin_id then
			inst.skin_id = data.skin_id
		end
	end
end

--初始化
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("medal_skin_coupon")
    inst.AnimState:SetBuild("medal_skin_coupon")
    inst.AnimState:PlayAnimation("medal_skin_coupon")

    inst:AddTag("showmedalinfo")--显示详细信息

    MakeInventoryFloatable(inst,"med",nil, 0.75)
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "medal_skin_coupon"
    inst.components.inventoryitem.atlasname = "images/medal_skin_coupon.xml"
	
	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.MED_FUEL
	
	MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
	MakeSmallPropagator(inst)
    MakeHauntableLaunch(inst)

    inst.setSkinData = setSkinData
    inst.setRandomSkin = setRandomSkin
    inst.getMedalInfo =  getSkinInfo
    setRandomSkin(inst)

    inst.OnSave = savefn
	inst.OnLoad = loadfn

    return inst
end

return Prefab("medal_skin_coupon", fn, assets)
