require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/medal_livingroot_chest.zip"),
    Asset("ANIM", "anim/ui_chest_3x3.zip"),
	Asset("ATLAS", "images/medal_livingroot_chest.xml"),
	Asset("IMAGE", "images/medal_livingroot_chest.tex"),
	Asset("ATLAS", "minimap/medal_livingroot_chest.xml"),
}

local prefabs =
{
    "collapse_small",
}

--保鲜效率
local function PerishRateFn(inst, item)
	--有生命时可减缓小动物死亡
	if inst.isalive then
		return (item ~= nil and (item:HasTag("fish") or item.components.health~=nil)) and 0.5 or nil
	end
	return 2--没生命则加速腐化
end

--获取箱子形状等级
local function getChesterState(inst)
	if inst.fertilizerNum then
		if inst.fertilizerNum>=TUNING_MEDAL.LIVINGROOT_CHEST_BIG_NEED then
			return 4
		elseif inst.fertilizerNum>=TUNING_MEDAL.LIVINGROOT_CHEST_MID_NEED then
			return 3
		elseif inst.fertilizerNum>=TUNING_MEDAL.LIVINGROOT_CHEST_SMALL_NEED then
			return 2
		end
	end
	return 1
end

--设置标签
local function setChestTag(inst)
	if inst:HasTag("notalive") then
		inst:RemoveTag("notalive")
	end
	if inst:HasTag("needfertilize") then
		inst:RemoveTag("needfertilize")
	end
	if inst:HasTag("wildfirepriority") then
		inst:RemoveTag("wildfirepriority")
	end
	--有生命
	if inst.isalive then
		inst:AddTag("wildfirepriority")--优先自燃
		--肥料数量没溢出，则添加可施肥标签
		if inst.fertilizerNum and inst.fertilizerNum<TUNING_MEDAL.LIVINGROOT_CHEST_BIG_NEED then
			inst:AddTag("needfertilize")
		end
	else--如果没有生命，则添加可复苏标签
		inst:AddTag("notalive")
	end
end

--设置箱子容器的replica
local function setReplicaContainer(inst)
	local stateNum=inst.rootcheststate:value()
	if stateNum>0 then
		inst.replica.container:WidgetSetup("livingroot_chest"..stateNum)
	end
end

--设置箱子形状、容器大小
local function setChesterState(inst)
	local stateNum=getChesterState(inst)
	if stateNum>1 then
		--设置容器大小
		if inst.components.container then
			inst.components.container:Close()
			inst.components.container:WidgetSetup("livingroot_chest"..stateNum)
			-- inst.replica.container:WidgetSetup("livingroot_chest"..stateNum)
			inst.rootcheststate:set(stateNum)
		end
	end
	--设置箱子外观动画
	inst.AnimState:PushAnimation("idle"..stateNum, not inst:HasTag("notalive"))
	--更新不朽状态标签
	if inst.components.medal_immortal ~= nil then
		inst.components.medal_immortal:UpdateTag()
	end
end

--打开箱子
local function onopen(inst)
    local stateNum=getChesterState(inst)--获取箱子形状等级
	inst.AnimState:PlayAnimation("open"..stateNum)--设置打开动画
    inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/livingtree_hit")
end

--关闭箱子
local function onclose(inst)
    local stateNum=getChesterState(inst)--获取箱子形状等级
	inst.AnimState:PlayAnimation("close"..stateNum)
	-- inst.AnimState:PushAnimation("idle"..stateNum, true)
	inst.AnimState:PushAnimation("idle"..stateNum, not inst:HasTag("notalive"))
    inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/livingtree_hit")
end

--分解箱子
local function ondeconstruct(inst,caster)
	--掉落全部肥料包
	if inst.fertilizerNum and inst.fertilizerNum>0 then
		local dropnum=inst.fertilizerNum
		for i=1,dropnum do
			inst.components.lootdropper:SpawnLootPrefab("compostwrap")
		end
	end
end

--锤爆箱子
local function onhammered(inst, worker)
    --掉落一半的肥料包
	if inst.fertilizerNum and inst.fertilizerNum>1 then
		local dropnum=math.floor(inst.fertilizerNum/2)
		for i=1,dropnum do
			inst.components.lootdropper:SpawnLootPrefab("compostwrap")
		end
	end
	inst.components.lootdropper:DropLoot()
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

--锤箱子
local function onhit(inst, worker)
    local stateNum=getChesterState(inst)--获取箱子形状等级
	inst.AnimState:PlayAnimation("hit"..stateNum)
    -- inst.AnimState:PushAnimation("idle"..stateNum, true)
    inst.AnimState:PushAnimation("idle"..stateNum, not inst:HasTag("notalive"))
	inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/livingtree_hit")
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end
end

--建造箱子
local function onbuilt(inst)
    inst.AnimState:PlayAnimation("grow_chest")
    -- inst.AnimState:PushAnimation("idle1", true)
    inst.AnimState:PushAnimation("idle1", not inst:HasTag("notalive"))
    inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl4_place")
	if inst.components.writeable then
		if inst.components.writeable:IsBeingWritten() then
			inst.components.writeable:EndWriting()
		end
		inst.components.writeable:SetText(STRINGS.DELIVERYSPEECH.NONAMECHEST)
	end
end

--燃烧
local function onburnt(inst)
	inst:DoTaskInTime(1, function(inst)
		SpawnPrefab("livingroot_chest_extinguish_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
	end)
end

--升级所需肥料值
local fertilizer_loot={
	TUNING_MEDAL.LIVINGROOT_CHEST_SMALL_NEED,
	TUNING_MEDAL.LIVINGROOT_CHEST_MID_NEED,
	TUNING_MEDAL.LIVINGROOT_CHEST_BIG_NEED,
}

--升级函数(预置物,肥料,肥料值)
local function levelUp(inst,fertilizer,fertilizervalue)
	if inst.fertilizerNum and (fertilizer or fertilizervalue) then
		local oldStateNum=getChesterState(inst)
		if oldStateNum < 4 then
			--如果有肥料值就跳过肥料的消耗了(主要为gm服务)
			if fertilizervalue then
				inst.fertilizerNum = inst.fertilizerNum + fertilizervalue
			else--正常消耗肥料
				local neednum = fertilizer_loot[oldStateNum] - inst.fertilizerNum
				local addnum = TUNING_MEDAL.LIVINGROOT_CHEST_ADDNUM * (fertilizer.prefab=="spice_poop" and 0.5 or 1)--秘制酱料效益为肥料包的一半
				local hasnum = fertilizer.components.stackable and fertilizer.components.stackable:StackSize() or 1
				neednum = math.ceil(neednum / addnum)
				if neednum >= hasnum then
					inst.fertilizerNum = inst.fertilizerNum + addnum * hasnum
					fertilizer:Remove()
				else
					inst.fertilizerNum = inst.fertilizerNum + addnum * neednum
					fertilizer.components.stackable:Get(neednum):Remove()
				end
			end
			inst.AnimState:PlayAnimation("fertilize"..oldStateNum)--施肥
			inst.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/spawn", nil, .5)
		end
		local newStateNum=getChesterState(inst)
		--如果形状发生了变化，则播放升级动画并设置新形状
		if newStateNum>oldStateNum then
			if newStateNum>=4 then
				inst.AnimState:PlayAnimation("grow_3_to_4")--3升4
				inst.SoundEmitter:PlaySound("dontstarve/halloween_2018/living_tree/grow_3")
			elseif newStateNum>=3 then
				inst.AnimState:PlayAnimation("grow_2_to_3")--2升3
				inst.SoundEmitter:PlaySound("dontstarve/halloween_2018/living_tree/grow_3")
			else
				inst.AnimState:PlayAnimation("grow_1_to_2")--1升2
				inst.SoundEmitter:PlaySound("dontstarve/halloween_2018/living_tree/grow_3")
			end
			setChestTag(inst)--设置标签
			setChesterState(inst)--设置新形状和容器
		end
		--被肥料污染过就不能用于复活了
		if inst.fertilizerNum>0 and inst.components.hauntable then
			inst.components.hauntable.hauntvalue=nil
		end
	end
end

--生命复苏
local function givelife(inst)
	if inst.isalive~=nil and not inst.isalive then
		inst.isalive=true
		local stateNum=getChesterState(inst)--获取箱子形状等级
		inst.AnimState:PlayAnimation("fertilize"..stateNum)
		inst.AnimState:PushAnimation("idle"..stateNum, true)
		inst.SoundEmitter:PlaySound("dontstarve/halloween_2018/living_tree/grow_2")
		setChestTag(inst)
		--可用于复活
		if inst.components.hauntable then
			inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
		end
	end
end
--延迟执行函数
local function OnTimeout(inst)
    inst._task = nil
    --移除复活功能
	if inst.components.hauntable then
		inst.components.hauntable.hauntvalue=nil
	end
end

--作祟函数
local function OnHaunt(inst, haunter)
	--被肥料污染过，不能用于复活
	if inst.fertilizerNum>0 then
		return true
	end
	if inst.isalive and inst._task==nil then
		
		local stateNum=getChesterState(inst)--获取箱子形状等级
		inst.AnimState:PlayAnimation("hit"..stateNum)
		inst.AnimState:PushAnimation("idle1",false)
		inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/livingtree_hit")
		if inst.components.container ~= nil then
			inst.components.container:DropEverything()
			inst.components.container:Close()
		end
		--掉落一半的肥料包
		if inst.fertilizerNum and inst.fertilizerNum>1 then
			local dropnum=math.floor(inst.fertilizerNum/2)
			for i=1,dropnum do
				inst.components.lootdropper:SpawnLootPrefab("compostwrap")
			end
		end
		inst.fertilizerNum = 0--肥料归零
		inst.isalive=false--失去生命
		
		if haunter then
			SpawnPrefab("lavaarena_player_revive_from_corpse_fx").Transform:SetPosition(haunter.Transform:GetWorldPosition())
		end
		
		--重新设置容器组件
		if inst.components.container then
			inst:RemoveComponent("container")
		end
		inst:AddComponent("container")
		inst.components.container:WidgetSetup("livingroot_chest1")--默认容器大小
		inst.components.container.onopenfn = onopen
		inst.components.container.onclosefn = onclose
		inst.rootcheststate:set(1)
		setChestTag(inst)--设置标签
		-- setChesterState(inst)--设置新形状和容器
		inst._task = inst:DoTaskInTime(1, OnTimeout)--延迟移除可复活标签
		return true
	end
end

--保存
local function OnSave(inst, data)
    data.fertilizerNum = inst.fertilizerNum
	data.isalive = inst.isalive
	data.spacechangename = inst:HasTag("isspacechest")--inst.spacechangename:value()
end
--预加载
local function OnPreLoad(inst, data)
    if data == nil then
        return
    else
		if data.fertilizerNum then
			inst.fertilizerNum=data.fertilizerNum
		end
		if data.isalive then
			inst.isalive = data.isalive
			--可用于复活(没被肥料污染过)
			if inst.components.hauntable and inst.fertilizerNum<=0 then
				inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
			end
		end
		setChestTag(inst)--设置标签
		setChesterState(inst)--设置新形状和容器
		if data.spacechangename and inst.AddSpacePos then
			inst:AddSpacePos()
		end
    end
end

--添加时空锚点
local function addSpacePos(inst)
	if not inst:HasTag("isspacechest") then
		inst:AddTag("isspacechest")--时空宝箱标签
		-- inst:RemoveTag("addspaceposable")
		TheWorld:PushEvent("ms_medal_registerhyperspacechest", inst)--注册
		return true
	end
end

--移除时空锚点
local function removeSpacePos(inst)
	if inst:HasTag("isspacechest") then
		inst:RemoveTag("isspacechest")
		inst:PushEvent("removespacepos",inst)--注销
		return true
	end
end

--名字展示
local function displaynamefn(inst)
	if inst:HasTag("isspacechest") then
		return subfmt(STRINGS.NAMES.HYPERSPACE_CHEST, { chest = STRINGS.NAMES[string.upper(inst.prefab)] })
	end
	return STRINGS.NAMES.MEDAL_LIVINGROOT_CHEST
end

--不朽前置条件
local function preimmortalfn(inst)
	return getChesterState(inst) >= 4--只有满级树根宝箱可以不朽
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("medal_livingroot_chest.tex")

    inst.AnimState:SetBank("medal_livingroot_chest")
    inst.AnimState:SetBuild("medal_livingroot_chest")
    -- inst.AnimState:PlayAnimation("idle1",true)
    inst.AnimState:PlayAnimation("idle1",false)

    inst:AddTag("structure")
    inst:AddTag("chest")
	inst:AddTag("notalive")--没有生命
	inst:AddTag("_writeable")
	-- inst:AddTag("addspaceposable")--可添加时空锚点
	inst:AddTag("medal_skinable")--可换皮肤
	
	inst.fertilizerNum = 0--肥料数量
	inst.isalive=false--是否有生命
	
	inst.rootcheststate = net_tinybyte(inst.GUID, "rootcheststate", "rootcheststatedirty")--容器形状，网络变量

	inst.displaynamefn = displaynamefn

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		-- inst._clientrootcheststate=1--客户端记录的树根宝箱级别
		inst:ListenForEvent("rootcheststatedirty", setReplicaContainer)
		
		inst.OnEntityReplicated = function(inst) 
			inst.replica.container:WidgetSetup("livingroot_chest1") 
		end
		return inst
    end

	inst:RemoveTag("_writeable")

	inst:AddComponent("inspectable")
	inst:AddComponent("writeable")--可书写组件

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("livingroot_chest1")--默认容器大小
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
	--给容器的classified添加target，防止升级导致崩溃
	inst:DoTaskInTime(0,function(inst)
		if inst.replica.container and inst.replica.container.classified then
			inst.replica.container.classified.Network:SetClassifiedTarget(inst)
		end
		if inst.components.writeable~=nil and not inst.components.writeable:IsWritten() then
			inst.components.writeable:SetText(STRINGS.DELIVERYSPEECH.NONAMECHEST)
		end
	end)
	
	--可燃烧
	inst:AddComponent("burnable")
    inst.components.burnable:SetFXLevel(2)
    inst.components.burnable:SetBurnTime(1.5)
    inst.components.burnable:AddBurnFX("campfirefire", Vector3(0, 0.5, 0), nil,true)
	
	--存储器组件
	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(PerishRateFn)
	
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)--需要锤多少下
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:ListenForEvent("onbuilt", onbuilt)--建造
	inst:ListenForEvent("onignite", onburnt)--灭火
	inst:ListenForEvent("ondeconstructstructure", ondeconstruct)--分解
    MakeSnowCovered(inst)

	inst.levelUpFn=levelUp
	inst.givelifeFn=givelife
	inst.OnSave = OnSave
    inst.OnPreLoad = OnPreLoad
	
	inst:AddComponent("hauntable")
    -- inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)--作祟可复活
    inst.components.hauntable:SetOnHauntFn(OnHaunt)

	inst.AddSpacePos=addSpacePos
	inst.RemoveSpacePos=removeSpacePos
	inst:AddComponent("medal_skinable")

	inst:AddComponent("medal_immortal")--不朽组件
    inst.components.medal_immortal:SetMaxLevel(2)--最大不朽等级
	inst.components.medal_immortal:SetConsumeMult(5)--不朽宝石消耗倍率
	inst.components.medal_immortal:SetPreImmortalFn(preimmortalfn)--不朽前置条件
	
	--兼容智能木牌
	if TUNING.SMART_SIGN_DRAW_ENABLE then
		SMART_SIGN_DRAW(inst)
	end
	-- AddHauntableDropItemOrWork(inst)

    return inst
end

return Prefab("medal_livingroot_chest", fn, assets),
    MakePlacer("medal_livingroot_chest_placer", "medal_livingroot_chest", "medal_livingroot_chest", "idle1")
