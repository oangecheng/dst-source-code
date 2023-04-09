local assets =
{
    Asset("ANIM", "anim/lavaeel.zip"),
    -- Asset("ANIM", "anim/lavaeel01.zip"),
	-- Asset("ANIM", "anim/eel01.zip"),
    Asset("ANIM", "anim/eel.zip"),
	Asset("ATLAS", "images/lavaeel.xml"),
	Asset("ATLAS_BUILD", "images/lavaeel.xml",256),
}

local lavaeel_prefabs =
{
	"eel",
	"medal_blue_obsidian",
}

local function CalcNewSize()
	local p = 2 * math.random() - 1
	return (p*p*p + 1) * 0.5
end

local function flop(inst)
	local num = math.random(2)
	for i = 1, num do
		inst.AnimState:PushAnimation("idle", false)
	end

	inst.flop_task = inst:DoTaskInTime(math.random() * 2 + num * 2, flop)
end

local function ondropped(inst)
    if inst.flop_task ~= nil then
        inst.flop_task:Cancel()
    end
	inst.AnimState:PlayAnimation("idle", false)
    inst.flop_task = inst:DoTaskInTime(math.random() * 3, flop)
end

local function ondroppedasloot(inst, data)
	if data ~= nil and data.dropper ~= nil then
		inst.components.weighable.prefab_override_owner = data.dropper.prefab
	end
end

local function onpickup(inst)
    if inst.flop_task ~= nil then
        inst.flop_task:Cancel()
        inst.flop_task = nil
    end
end

--直接吃会被点燃
local function OnEatenFn(inst, eater)
	if eater.components.burnable then
		eater.components.burnable:Ignite(true)
	end
end

local function commonfn(bank, build, char_anim_build, data)
    local inst = CreateEntity()

	data = data or {}

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("idle", false)

	--小范围发光
	inst.Light:SetFalloff(1)
	inst.Light:SetIntensity(.5)
	inst.Light:SetRadius(0.6)
	inst.Light:SetColour(235 / 255, 165 / 255, 12 / 255)
	inst.Light:Enable(true)
	
	inst:AddTag("fish")
	inst:AddTag("pondfish")
    inst:AddTag("meat")
    inst:AddTag("catfood")
	inst:AddTag("smallcreature")
	if data.cooldownable then
		inst:AddTag("cooldownable")--可冷却
	end

	if data.weight_min ~= nil and data.weight_max ~= nil then
		--weighable_fish (from weighable component) added to pristine state for optimization
		inst:AddTag("weighable_fish")
	end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.build = char_anim_build --This is used within SGwilson, sent from an event in fishingrod.lua

    inst:AddComponent("bait")

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(data.perish_time)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = data.perish_product

    -- inst:AddComponent("cookable")
    -- inst.components.cookable.product = data.cookable_product

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnDroppedFn(ondropped)
    inst.components.inventoryitem:SetOnPutInInventoryFn(onpickup)
	inst.components.inventoryitem:SetSinks(true)
	inst.components.inventoryitem.imagename = "lavaeel"
	inst.components.inventoryitem.atlasname = "images/lavaeel.xml"

	inst:AddComponent("murderable")

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot(data.loot)

    inst:AddComponent("edible")
    inst.components.edible.ismeat = true
	inst.components.edible.healthvalue = data.healthvalue
	inst.components.edible.hungervalue = data.hungervalue
	inst.components.edible.sanityvalue = 0
    inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible:SetOnEatenFn(OnEatenFn)

    MakeHauntableLaunchAndPerish(inst)

    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = data.goldvalue or TUNING.GOLD_VALUES.MEAT
    inst.data = {}--
	
	--发热
	inst:AddComponent("heater")
	inst.components.heater.heat = 100
	inst.components.heater.carriedheat = 100
	inst.components.heater.carriedheatmultiplier = 5

	if data.weight_min ~= nil and data.weight_max ~= nil then
		inst:AddComponent("weighable")
		inst.components.weighable.type = TROPHYSCALE_TYPES.FISH
		inst.components.weighable:SetWeight(Lerp(data.weight_min, data.weight_max, CalcNewSize()))
	end

	inst:ListenForEvent("on_loot_dropped", ondroppedasloot)

	inst.flop_task = inst:DoTaskInTime(math.random() * 2 + 1, flop)

    return inst
end

local lavaeel_data =
{
    weight_min = 165.16,
    weight_max = 212.12,
    perish_product = "medal_obsidian",--自然死亡后产物
    loot = { "eel" },--杀死后产物
    -- cookable_product = "eel_cooked",
    healthvalue = TUNING_MEDAL.LAVAEEL_HEALTHVALUE,--健康值
    hungervalue = TUNING.CALORIES_TINY,--饱食度
    perish_time = TUNING_MEDAL.MEDAL_PERISH_SUPERFAST,--存活时间
	goldvalue = TUNING.GOLD_VALUES.RAREMEAT,--金子价值
	cooldownable = true,--是否可冷却
}
local function pondeelfn()
	return commonfn("eel", "lavaeel", "lavaeel", lavaeel_data)
end

return Prefab("lavaeel", pondeelfn, assets, lavaeel_prefabs)