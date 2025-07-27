local assets =
{
    Asset("ANIM", "anim/medal_moonglass_bugnet.zip"),
    Asset("ANIM", "anim/swap_medal_moonglass_bugnet.zip"),
    Asset("ANIM", "anim/floating_items.zip"),
	Asset("ATLAS", "images/medal_moonglass_bugnet.xml"),
	Asset("ATLAS", "images/medal_spore_moon.xml"),
	Asset("ATLAS_BUILD", "images/medal_moonglass_bugnet.xml",256),
}

local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_medal_moonglass_bugnet", "swap_bugnet")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    owner.spore_moon_catcher = true--月亮孢子捕手
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    owner.spore_moon_catcher = nil--月亮孢子捕手
end

--添加可装备组件相关内容
local function SetupEquippable(inst)
	inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("bugnet")
    inst.AnimState:SetBuild("swap_medal_moonglass_bugnet")
    inst.AnimState:PlayAnimation("idle")

    --tool (from tool component) added to pristine state for optimization
    inst:AddTag("tool")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
	-- inst:AddTag("moon_bugnet")--月光捕虫网标签，可捕捉月亮孢子

    inst.medal_repair_immortal = {--修补列表
        moonglass = TUNING_MEDAL.MOONGLASS_TOOL.ADDUSE_LESS,--月光玻璃
        immortal_essence = TUNING_MEDAL.MOONGLASS_TOOL.MAXUSES_LESS,--不朽精华
        immortal_fruit = TUNING_MEDAL.MOONGLASS_TOOL.MAXUSES_LESS,--不朽果实
	}


    local swap_data = {sym_build = "swap_medal_moonglass_bugnet",sym_name = "swap_bugnet"}
    MakeInventoryFloatable(inst, "med", 0.09, {0.9, 0.4, 0.9}, true, -14.5, swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.BUGNET_DAMAGE)
    inst.components.weapon.attackwear = 3

    -----
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.NET,TUNING_MEDAL.MOONGLASS_TOOL.EFFICIENCY)--这个效率还需要hook net动作后才能提升
    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING_MEDAL.MOONGLASS_TOOL.MAXUSES_LESS)
    inst.components.finiteuses:SetUses(TUNING_MEDAL.MOONGLASS_TOOL.MAXUSES_LESS)
    inst.components.finiteuses:SetConsumption(ACTIONS.NET, 2)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "medal_moonglass_bugnet"
	inst.components.inventoryitem.atlasname = "images/medal_moonglass_bugnet.xml"

    MakeHauntableLaunch(inst)

	SetImmortalTool(inst,SetupEquippable,TUNING_MEDAL.MOONGLASS_TOOL.MAXUSES_LESS,true)

    return inst
end

--掉地上变成普通的月光孢子
local function OnDropped(inst)
	if inst.components.stackable ~= nil and inst.components.stackable:IsStack() then
	    for i=1,inst.components.stackable:StackSize() do
			SpawnPrefab("spore_moon").Transform:SetPosition(inst.Transform:GetWorldPosition())
		end
	else
		SpawnPrefab("spore_moon").Transform:SetPosition(inst.Transform:GetWorldPosition())
	end
	inst:Remove()
end

local function spore_fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
		
	inst.AnimState:SetBank("bugnet")
	inst.AnimState:SetBuild("swap_medal_moonglass_bugnet")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("show_spoilage")
	inst:AddTag("medal_spore")
	
	inst:SetPrefabNameOverride("spore_moon")
	
	inst.entity:SetPristine()
		
	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("stackable")
    inst.components.stackable.forcedropsingle = true
	
	-- inst:AddComponent("lootdropper")
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "medal_spore_moon"
	inst.components.inventoryitem.atlasname = "images/medal_spore_moon.xml"
	inst.components.inventoryitem.canbepickedup = false
    -- inst.components.inventoryitem.canonlygoinpocket = true
    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.TOTAL_DAY_TIME*15)
	inst.components.perishable:StartPerishing()
	inst.components.perishable:SetOnPerishFn(inst.Remove)
		
	inst:AddComponent("inspectable")
	
	-- inst:ListenForEvent("ondropped", OnDropped)
		
	MakeHauntableLaunchAndSmash(inst)

	return inst
end

return Prefab("medal_moonglass_bugnet", fn, assets),--月光网
	Prefab("medal_spore_moon", spore_fn, assets)--月亮孢子