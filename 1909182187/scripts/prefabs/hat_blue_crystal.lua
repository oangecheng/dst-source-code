assets =
{
	Asset("ANIM", "anim/hat_blue_crystal.zip"),
    Asset("ATLAS", "images/hat_blue_crystal.xml"),
	Asset("ATLAS_BUILD", "images/hat_blue_crystal.xml",256),
}
prefabs =
{
}

local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_hat", "hat_blue_crystal", "swap_hat")
	
	owner.AnimState:Show("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")
    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
    end

    if owner:HasTag("equipmentmodel") then return end--假人就不往下走了
	inst.components.fueled:StartConsuming()
	if owner.components.health ~= nil then
        owner.components.health.externalfiredamagemultipliers:SetModifier(inst, 0)
    end
    if owner.components.temperature then
        local current=owner.components.temperature:GetCurrent()
        if current>64 then--当前体温高于64度时，额外消耗耐久降温，消耗量=温差*每度消耗
            owner.components.temperature:SetTemperature(64)
            inst.components.fueled:DoDelta(-math.ceil(TUNING_MEDAL.HAT_BLUE_CRYSTAL_CONSUME*(current-64)))
        end
    end
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_hat")
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")
	if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
    end
    if owner:HasTag("equipmentmodel") then return end--假人就不往下走了
	inst.components.fueled:StopConsuming()
	if owner.components.health ~= nil then
        owner.components.health.externalfiredamagemultipliers:RemoveModifier(inst)
    end
end

local function fn()
    local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("balloonhat")
	-- inst.AnimState:SetBank("hat_blue_crystal")
    inst.AnimState:SetBuild("hat_blue_crystal")
    inst.AnimState:PlayAnimation("anim")
	
	inst.inmigrate="mztsj"
	
	inst:AddTag("hat")
	inst:AddTag("powerabsorbable")--可吸收能力
	inst:AddTag("nooverheat")--不会过热
	inst.medal_repair_loot = {medal_blue_obsidian=TUNING_MEDAL.HAT_BLUE_CRYSTAL_ADDUSE}--可用蓝曜石修复
	
	MakeInventoryFloatable(inst,"med",0.1,0.65)

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "hat_blue_crystal"
    inst.components.inventoryitem.atlasname = "images/hat_blue_crystal.xml"
	
	inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
	
	inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("insulator")
	inst.components.insulator:SetInsulation(TUNING_MEDAL.HAT_BLUE_CRYSTAL_INSULATION)
	inst.components.insulator:SetSummer()

    inst:AddComponent("fueled")
    inst.components.fueled:InitializeFuelLevel(TUNING_MEDAL.HAT_BLUE_CRYSTAL_PERISHTIME)
    inst.components.fueled:SetDepletedFn(inst.Remove)
	
	MakeHauntableLaunch(inst)
    return inst
end


return Prefab( "hat_blue_crystal", fn, assets, prefabs)