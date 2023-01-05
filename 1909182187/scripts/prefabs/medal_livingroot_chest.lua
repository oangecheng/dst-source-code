require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/medal_livingroot_chest.zip"),
	Asset("ANIM", "anim/medal_livingroot_chest_skin1.zip"),
    Asset("ANIM", "anim/ui_chest_3x3.zip"),
	Asset("ATLAS", "images/medal_livingroot_chest.xml"),
	Asset("IMAGE", "images/medal_livingroot_chest.tex"),
	Asset("ATLAS", "minimap/medal_livingroot_chest.xml"),
}

local prefabs =
{
    "collapse_small",
}

--没有生命时保鲜效率
local function deathPreserverRate(inst, item)
	return 2
end

--有生命时保鲜效率(减缓小动物死亡速度)
local function livingPreserverRate(inst, item)
	return (item ~= nil and (item:HasTag("fish") or item.components.health~=nil)) and 0.1 or nil
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
		else
			return 1
		end
	else
		return 1
	end
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
	--如果没有生命，则添加可复苏标签
	--[[
	if inst.isalive~=nil and not inst.isalive then
		inst:AddTag("notalive")
	end
	--如果有生命，并且肥料数量没溢出，则添加可施肥标签
	if inst.fertilizerNum and inst.fertilizerNum<TUNING_MEDAL.LIVINGROOT_CHEST_BIG_NEED and inst.isalive then
		inst:AddTag("needfertilize")
	end
	]]
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
	
	--设置存储器函数
	if inst.components.preserver then
		--活树根宝箱可延缓生物死亡，否则加速死亡和腐烂
		if inst.isalive then
			inst.components.preserver:SetPerishRateMultiplier(livingPreserverRate)
		else
			inst.components.preserver:SetPerishRateMultiplier(deathPreserverRate)
		end
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
	data.spacechangename = inst.spacechangename:value()
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
	if inst.spacechangename and not inst.spacechangename:value() then
		inst.spacechangename:set(true)
		TheWorld:PushEvent("ms_medal_registerhyperspacechest", inst)--注册
		return true
	end
end

--移除时空锚点
local function removeSpacePos(inst)
	if inst.spacechangename and inst.spacechangename:value() then
		inst.spacechangename:set(false)
		inst:PushEvent("removespacepos",inst)--注销
		return true
	end
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
	inst:AddTag("addspaceposable")--可添加时空锚点
	inst:AddTag("medal_skinable")--可换皮肤
	
	inst.fertilizerNum = 0--肥料数量
	inst.isalive=false--是否有生命
	
	inst.rootcheststate = net_tinybyte(inst.GUID, "rootcheststate", "rootcheststatedirty")--容器形状，网络变量
	inst.spacechangename = net_bool(inst.GUID, "spacechangename", "spacechangenamedirty")
	inst:ListenForEvent("spacechangenamedirty", function(inst)
		if inst.spacechangename:value() then
			--加上超时空前缀
			inst.displaynamefn = function(aaa)
				return subfmt(STRINGS.NAMES["HYPERSPACE_CHEST"], { chest = STRINGS.NAMES[string.upper(inst.prefab)] })
			end
			inst:RemoveTag("addspaceposable")
		else
			inst.displaynamefn = nil
			inst:AddTag("addspaceposable")
		end
	end)

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
    -- inst.components.container:WidgetSetup("medal_livingroot_chest")--默认容器大小
    inst.components.container:WidgetSetup("livingroot_chest1")--默认容器大小
	-- inst.replica.container:WidgetSetup("livingroot_chest1")
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
	inst.components.preserver:SetPerishRateMultiplier(deathPreserverRate)
	
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
	
	--兼容智能木牌
	if TUNING.SMART_SIGN_DRAW_ENABLE then
		SMART_SIGN_DRAW(inst)
	end
	-- AddHauntableDropItemOrWork(inst)

    return inst
end

return Prefab("medal_livingroot_chest", fn, assets),
    MakePlacer("medal_livingroot_chest_placer", "medal_livingroot_chest", "medal_livingroot_chest", "idle1")
