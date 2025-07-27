local assets =
{
    Asset("ANIM", "anim/bottled_soul.zip"),
    Asset("ATLAS", "images/bottled_soul.xml"),
	Asset("ATLAS_BUILD", "images/bottled_soul.xml",256),
}

--食用函数
local function onEatenfFn(inst, eater)
	if eater.components.inventory then
		--概率返还瓶子，否则破碎成玻璃碎片
		if math.random()<TUNING_MEDAL.BOTTLED_RETURN_RATE then
			local newitem=SpawnPrefab("messagebottleempty")
			if newitem then
				eater.components.inventory:GiveItem(newitem)
			end
		else
			local newitem=SpawnPrefab("moonglass")
			if newitem then
				eater.components.inventory:GiveItem(newitem)
			end
		end
	end
	eater:AddDebuff("buff_medal_freeblink", "buff_medal_freeblink")--添加buff
	--晚上和洞穴里概率召唤暗夜坎普斯
	local rage_krampus_chance_mult=TheWorld.state.isnewmoon and 2.5 or 1--新月概率提升至50%
	if (TheWorld.state.isnight or TheWorld:HasTag("cave")) and math.random()<TUNING_MEDAL.RAGE_KRAMPUS_CALL_RATE*rage_krampus_chance_mult then
		local kramp = MakeRageKrampusForPlayer(eater)
		if kramp ~= nil and kramp.components.combat ~= nil then
			kramp.components.combat:SetTarget(eater)
		end
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)
	
    inst.AnimState:SetBank("bottled_soul")
    inst.AnimState:SetBuild("bottled_soul")
    inst.AnimState:PlayAnimation("bottled_soul")
	
	inst:AddTag("pre-preparedfood")--加工品，可以让沃利食用
	inst:AddTag("callragekrampus")--召唤暗夜坎普斯
	
	MakeInventoryFloatable(inst,"med",0.3,0.65)
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("edible")
	inst.components.edible.foodtype = FOODTYPE.GOODIES--好东西分类，可以给所有角色吃
	inst.components.edible.healthvalue = TUNING_MEDAL.BOTTLED_SOUL_HEALTHVALUE
	inst.components.edible.sanityvalue = TUNING_MEDAL.BOTTLED_SOUL_SANITYVALUE
    -- inst.components.edible.hungervalue = TUNING_MEDAL.BOTTLED_SOUL_HUNGERVALUE
	inst.components.edible:SetOnEatenFn(onEatenfFn)

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "bottled_soul"
    inst.components.inventoryitem.atlasname = "images/bottled_soul.xml"

    return inst
end

return Prefab( "bottled_soul", fn, assets)

