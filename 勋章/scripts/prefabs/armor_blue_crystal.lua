local assets =
{
    Asset("ANIM", "anim/armor_blue_crystal.zip"),
	Asset("ATLAS", "images/armor_blue_crystal.xml"),
	Asset("ATLAS_BUILD", "images/armor_blue_crystal.xml",256),
}
--冰冻
local function OnFreeze(owner, data)
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_scalemail")
    --概率冰冻
	if math.random() < TUNING_MEDAL.ARMOR_BLUE_CRYSTAL_FREEZE_RATE then
		if data and data.attacker and data.attacker.components.freezable then
            --这里做个函数判断，免得有些生物连target都没set就直接remove事件了
            if data.attacker.components.combat and data.attacker.components.combat.losetargetcallback~=nil then
                data.attacker.components.freezable:AddColdness(6)
                data.attacker.components.freezable:SpawnShatterFX()
            end
        end 
	end
end

--装备
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "armor_blue_crystal", "swap_body")
	--防火
	if owner.components.health ~= nil then
        owner.components.health.externalfiredamagemultipliers:SetModifier(inst, 0)
    end
	--监听被攻击事件
	inst:ListenForEvent("blocked", OnFreeze, owner)
    inst:ListenForEvent("attacked", OnFreeze, owner)
end
--卸下
local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
	if owner.components.health ~= nil then
        owner.components.health.externalfiredamagemultipliers:RemoveModifier(inst)
    end
	inst:RemoveEventCallback("blocked", OnFreeze, owner)
    inst:RemoveEventCallback("attacked", OnFreeze, owner)
end

local function create_common()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("armor_blue_crystal")
    inst.AnimState:SetBuild("armor_blue_crystal")
    inst.AnimState:PlayAnimation("anim")

    inst.foleysound = "dontstarve/movement/foley/trunksuit"

    MakeInventoryFloatable(inst, "small", 0.1, 0.8)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "armor_blue_crystal"
	inst.components.inventoryitem.atlasname = "images/armor_blue_crystal.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
	
	inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	
	inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING_MEDAL.ARMOR_BLUE_CRYSTAL, TUNING_MEDAL.ARMOR_BLUE_CRYSTAL_ABSORPTION)--护甲值

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("armor_blue_crystal", create_common, assets)
