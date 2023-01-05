local assets =
{
    Asset("ANIM", "anim/armor_medal_obsidian.zip"),
	Asset("ATLAS", "images/armor_medal_obsidian.xml"),
	Asset("ATLAS_BUILD", "images/armor_medal_obsidian.xml",256),
}
--燃烧
local function OnBlocked(owner, data)
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_scalemail")
    --概率燃烧
	if math.random() < TUNING_MEDAL.ARMOR_MEDAL_OBSIDIAN_BURN_RATE then
		if data.attacker ~= nil and
			not (data.attacker.components.health ~= nil and data.attacker.components.health:IsDead()) and
			(data.weapon == nil or ((data.weapon.components.weapon == nil or data.weapon.components.weapon.projectile == nil) and data.weapon.components.projectile == nil)) and
			data.attacker.components.burnable ~= nil and
			not data.redirected and
			not data.attacker:HasTag("thorny") then
			data.attacker.components.burnable:Ignite()
		end
	end
end
--装备
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "armor_medal_obsidian", "swap_body")
	--防火
	if owner.components.health ~= nil then
        owner.components.health.externalfiredamagemultipliers:SetModifier(inst, 0)
    end
	--监听被攻击事件
	inst:ListenForEvent("blocked", OnBlocked, owner)
    inst:ListenForEvent("attacked", OnBlocked, owner)
end
--卸下
local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
	if owner.components.health ~= nil then
        owner.components.health.externalfiredamagemultipliers:RemoveModifier(inst)
    end
	inst:RemoveEventCallback("blocked", OnBlocked, owner)
    inst:RemoveEventCallback("attacked", OnBlocked, owner)
end

local function create_common()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("armor_medal_obsidian")
    inst.AnimState:SetBuild("armor_medal_obsidian")
    inst.AnimState:PlayAnimation("anim")

    inst.foleysound = "dontstarve/movement/foley/trunksuit"

    MakeInventoryFloatable(inst, "small", 0.1, 0.8)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "armor_medal_obsidian"
	inst.components.inventoryitem.atlasname = "images/armor_medal_obsidian.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
	
	inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	
	inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING_MEDAL.ARMOR_MEDAL_OBSIDIAN, TUNING_MEDAL.ARMOR_MEDAL_OBSIDIAN_ABSORPTION)--护甲值

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("armor_medal_obsidian", create_common, assets)
