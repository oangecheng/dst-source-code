assets =
{
    Asset("ANIM", "anim/medal_goathat.zip"),
    Asset("ATLAS", "images/medal_goathat.xml"),
	Asset("ATLAS_BUILD", "images/medal_goathat.xml",256),
}
prefabs =
{
}
--生成闪电特效
local function spawnElectricLight(owner)
	SpawnPrefab("electricchargedfx"):SetTarget(owner)
end
--清除原定时器
local function removeElectricLightTask(owner)
	if owner.electriclighttask ~= nil then
		owner.electriclighttask:Cancel()
		owner.electriclighttask = nil
	end
end
--获取堆叠数量
local function GetStackSize(item)
    return item.components.stackable ~= nil and item.components.stackable:StackSize() or 1
end
--果冻粉充电
local function jellyPowderCharge(player)
	if player.components.inventory then
		local spice_jellys = player.components.inventory:FindItems(function(item) return item.prefab == "spice_jelly" end)
		local spice_jelly_num = 0
		for i, v in ipairs(spice_jellys) do
			spice_jelly_num = spice_jelly_num + GetStackSize(v)
		end
		if spice_jelly_num >= TUNING_MEDAL.JELLY_POWDER_CHARGE_NUM then
			for i = 1, TUNING_MEDAL.JELLY_POWDER_CHARGE_NUM do
				-- local item = player.components.inventory:RemoveItem(k, false, true)
				local item = player.components.inventory:FindItem(function(item) return item.prefab == "spice_jelly" end)
				player.components.inventory:RemoveItem(item, false, true):Remove()
			end
			player.components.inventory:GiveItem(SpawnPrefab("spice_voltjelly"))
		end
	end
end
--闪电劈中函数
local function onlightingstrike(inst)
	if inst.components.health ~= nil and not (inst.components.health:IsDead() or inst.components.health:IsInvincible()) then
		--绝缘
		if inst.components.inventory:IsInsulated() then
			inst:PushEvent("lightningdamageavoided")
		else
			jellyPowderCharge(inst)
			inst.sg:GoToState("electrocute")
			local health_change=math.random(TUNING_MEDAL.GOATHAT_HEALTH_RECOVERY)
			inst.components.health:DoDelta(health_change)--回血
			if inst.components.sanity then
				inst.components.sanity:DoDelta(-health_change)--掉san
			end
			inst:AddDebuff("buff_medal_electricattack", "buff_medal_electricattack",{extend_duration=TUNING_MEDAL.MEDAL_BUFF_ELECTRICATTACK_DURATION},nil,function()
				removeElectricLightTask(inst)
				--特效定时器
				inst.electriclighttask = inst:DoPeriodicTask(2, spawnElectricLight)
			end)
        end
    end
end
--变身函数
local function transfromMermFn(inst,owner)
	--鱼人诅咒层数达到上限
	if owner.medal_merm_curse and owner.medal_merm_curse>=TUNING_MEDAL.MEDAL_BUFF_MERMCURSE_MAX then
		--骑牛你就歇歇吧
		if not (owner.components.rider and owner.components.rider:IsRiding()) 
			and not owner:HasTag("merm") then--佩戴鱼人勋章也不能变身
			inst:DoTaskInTime(0.5, function(inst)
				owner:RemoveDebuff("buff_medal_mermcurse")--移除鱼人诅咒
				owner.components.inventory:DropEquipped()
				-- inst.components.lootdropper:SpawnLootPrefab("merm_certificate")
				inst:Remove()
				if owner and owner.sg then
					owner.sg:GoToState("medal_transform_merm")
				end
			end)
		end
	end
end

local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_hat", GetMedalSkinData(inst,"medal_goathat"), "swap_hat")
	owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAIR_HAT")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")
	
	if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAT")
    end

	if owner:HasTag("equipmentmodel") then return end--假人就不往下走了

	if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end
	owner:AddTag("lightningrod")--避雷针标签
	owner.lightninggoat_friend=true--电羊之友
	AddMedalTag(owner,"stronggrip")--工具不脱手标签
	--游戏加载时生成闪电效果
	if owner.components.debuffable then
		inst:DoTaskInTime(0.1, function(inst)
			if owner.components.debuffable:HasDebuff("buff_medal_electricattack") then
				removeElectricLightTask(owner)
				owner.electriclighttask = owner:DoPeriodicTask(2, spawnElectricLight)
			end 
		end)
	end
	inst.lightningstrikefn=function(self,data)
		onlightingstrike(self)
		if inst.components.fueled then
			inst.components.fueled:DoDelta(TUNING_MEDAL.GOATHAT_CONSUME)
		end
	end
	
	--监听雷击
	owner:ListenForEvent("lightningstrike", inst.lightningstrikefn)
	--失去BUFF
	owner:ListenForEvent("stop_buff_medal_electricattack", removeElectricLightTask)

	inst.onTransfromMermFn=function(self,data)
		transfromMermFn(inst,owner)
	end
	owner:ListenForEvent("medal_transfrom_merm", inst.onTransfromMermFn)

	transfromMermFn(inst,owner)
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
	
	if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
	
	owner:RemoveTag("lightningrod")
	owner.lightninggoat_friend=nil--电羊之友
	RemoveMedalTag(owner,"stronggrip")
	
	--取消监听月圆事件
	owner:RemoveEventCallback("lightningstrike", inst.lightningstrikefn)
	owner:RemoveEventCallback("medal_transfrom_merm", inst.onTransfromMermFn)
	owner:RemoveEventCallback("stop_buff_medal_electricattack", removeElectricLightTask)
	owner:RemoveDebuff("buff_medal_electricattack")--移除BUFF
	removeElectricLightTask(owner)
end

local function fn()
    local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("medal_goathat")
    inst.AnimState:SetBuild("medal_goathat")
    inst.AnimState:PlayAnimation("anim")
	
	inst.inmigrate="mztsj"
	
	inst:AddTag("hat")
	inst:AddTag("medal_skinable")--可换皮肤
	inst.medal_repair_common = {transistor=TUNING_MEDAL.GOATHAT_ADDUSE}--可用电子元件修复
	-- inst:AddTag("medal_goathat")
	
	MakeInventoryFloatable(inst,"med",0.1,0.65)

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "medal_goathat"
    inst.components.inventoryitem.atlasname = "images/medal_goathat.xml"
	
	
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

	--保暖120秒
    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(120)
	
	--耐久
	inst:AddComponent("fueled")
    -- inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING_MEDAL.GOATHAT_PERISHTIME)
    inst.components.fueled:SetDepletedFn(inst.Remove)
	
	inst:AddComponent("medal_skinable")
	
	MakeHauntableLaunch(inst)
    return inst
end


return Prefab( "medal_goathat", fn, assets, prefabs)