local assets =
{
    Asset("ANIM", "anim/xinhua_dictionary.zip"),
	Asset("ATLAS", "images/xinhua_dictionary.xml"),
	Asset("ATLAS_BUILD", "images/xinhua_dictionary.xml",256),
}

--装备新华字典
local function onequip_dictionary(inst, owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
    owner:AddTag("medal_canstudy")--可以读无字天书
end

--卸下新华字典
local function onunequip_dictionary(inst, owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
    owner:RemoveTag("medal_canstudy")
end

--初始化
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("xinhua_dictionary")
    inst.AnimState:SetBuild("xinhua_dictionary")
    inst.AnimState:PlayAnimation("xinhua_dictionary")
	
	-- inst:AddTag("xinhua_dictionary")
	-- inst:AddTag("book")--在书架上可恢复耐久(做梦！)
	inst:AddTag("bookcabinet_item")--可放入书架
	
    inst.foleysound = "dontstarve/movement/foley/jewlery"

    MakeInventoryFloatable(inst, "med", nil, 0.75)
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    -- inst.components.equippable.equipslot = EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "xinhua_dictionary"
	inst.components.inventoryitem.atlasname = "images/xinhua_dictionary.xml"
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetMaxUses(TUNING_MEDAL.BOOK_MAXUSES.DICTIONARY)
    inst.components.finiteuses:SetUses(TUNING_MEDAL.BOOK_MAXUSES.DICTIONARY)
	
	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.MED_FUEL
	
	inst.components.equippable:SetOnEquip(onequip_dictionary)
    inst.components.equippable:SetOnUnequip(onunequip_dictionary)
	
	MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
	MakeSmallPropagator(inst)
    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("xinhua_dictionary", fn, assets)
