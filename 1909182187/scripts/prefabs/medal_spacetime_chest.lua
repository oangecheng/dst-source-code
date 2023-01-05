require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/dragonfly_chest.zip"),
	Asset("ANIM", "anim/medal_spacetime_chest.zip"),
	Asset("ANIM", "anim/ui_chest_3x3.zip"),
	Asset("ATLAS", "minimap/medal_spacetime_chest.xml" ),
}

local prefabs =
{
    "collapse_small",
	"medal_time_slider",
	"medal_spacetime_snacks_packet",
}

local function onopen(inst)
    inst.AnimState:PlayAnimation("open")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
end

local function onclose(inst)
    inst.AnimState:PlayAnimation("closed")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
end

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("closed", false)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end
end

--兑换礼物
local function exchangeGift(inst,player)
	local itemlist=inst.components.container:GetAllItems()
	local trinket_list={}--玩具种类表
	local halloween_toy_num=0--万圣节玩具数量
	local blank_medal_num=0--空白勋章数量
	local snacks_num = 0--零食数量
	for k,v in ipairs(itemlist) do
		--不能有堆叠的物品
		if v.components.stackable and v.components.stackable:IsStack() then
			MedalSay(player,STRINGS.EXCHANGEGIFT_SPEECH.FAIL1)
			return false
		--统计时空零食数量
		elseif v.prefab=="medal_spacetime_snacks" then
			snacks_num = snacks_num + 1
		else--不能有零食以外的东西
			MedalSay(player,STRINGS.EXCHANGEGIFT_SPEECH.JUSTSNACK)
			return false
		end
	end
	if snacks_num > 0 then
		--时空碎片
		local slider = SpawnPrefab("medal_time_slider")
		if slider then
			if slider.components.stackable then
				slider.components.stackable.stacksize = snacks_num
			end
			inst.components.lootdropper:FlingItem(slider)
		end
		--零食包装袋
		local packet = SpawnPrefab("medal_spacetime_snacks_packet")
		if packet then
			if packet.components.stackable then
				packet.components.stackable.stacksize = snacks_num
			end
			inst.components.lootdropper:FlingItem(packet)
		end
		--时空宝箱皮肤券
		local skin_coupon = SpawnPrefab("medal_skin_coupon")
		if skin_coupon then
			if skin_coupon.setSkinData then
				skin_coupon:setSkinData("bearger_chest",2)
			end
			inst.components.lootdropper:FlingItem(skin_coupon)
		end
		MedalSay(player,STRINGS.EXCHANGEGIFT_SPEECH.SPACETIMESUCCESS)
		inst.components.container:DestroyContents()--销毁里面的物品
		inst.components.container:Close()--关闭容器
		local fx = SpawnPrefab("collapse_small")
		fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		fx:SetMaterial("wood")
		inst:Remove()
	end
end

--定义箱子(预置物名,是否是玩具箱)
local function MakeChest(name)
	local function fn()
	    local inst = CreateEntity()
	
	    inst.entity:AddTransform()
	    inst.entity:AddAnimState()
	    inst.entity:AddSoundEmitter()
	    inst.entity:AddMiniMapEntity()
	    inst.entity:AddNetwork()
	
	    inst.MiniMapEntity:SetIcon("medal_spacetime_chest.tex")
	
	    inst.AnimState:SetBank("dragonfly_chest")--用龙鳞箱的bank
	    inst.AnimState:SetBuild("medal_spacetime_chest")
	    inst.AnimState:PlayAnimation("closed",true)
	
	    inst:AddTag("structure")
	    inst:AddTag("chest")
	
	    MakeSnowCoveredPristine(inst)
	
	    inst.entity:SetPristine()
	
	    if not TheWorld.ismastersim then
			return inst
	    end
	
	    inst:AddComponent("inspectable")
	    inst:AddComponent("container")
	    inst.components.container:WidgetSetup(name)
	    inst.components.container.onopenfn = onopen
	    inst.components.container.onclosefn = onclose
	
	    inst:AddComponent("lootdropper")
	    inst:AddComponent("workable")
	    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	    inst.components.workable:SetWorkLeft(10)
	    inst.components.workable:SetOnFinishCallback(onhammered)
	    inst.components.workable:SetOnWorkCallback(onhit)
		
	    MakeSnowCovered(inst)
		--兼容智能木牌
		if TUNING.SMART_SIGN_DRAW_ENABLE then
			SMART_SIGN_DRAW(inst)
		end

		inst.exchangeGift=exchangeGift--兑换礼物函数
		
		AddHauntableDropItemOrWork(inst)
	
	    return inst
	end
	
	return Prefab(name, fn, assets)
end

return MakeChest("medal_spacetime_chest")
