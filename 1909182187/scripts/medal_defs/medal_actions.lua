--[[
-----actions-----自定义动作
{
	id,--动作ID
	str,--动作显示名字
	fn,--动作执行函数
	actiondata,--其他动作数据，诸如strfn、mindistance等，可参考actions.lua
	state,--关联SGstate,可以是字符串或者函数
	canqueuer,--兼容排队论 allclick为默认，rightclick为右键动作
}
-----component_actions-----动作和组件绑定
{
	type,--动作类型
		*SCENE--点击物品栏物品或世界上的物品时执行,比如采集
		*USEITEM--拿起某物品放到另一个物品上点击后执行，比如添加燃料
		*POINT--装备某手持武器或鼠标拎起某一物品时对地面执行，比如植物人种田
		*EQUIPPED--装备某物品时激活，比如装备火把点火
		*INVENTORY--物品栏右键执行，比如吃东西
	component,--绑定的组件
	tests,--尝试显示动作，可写多个绑定在同一个组件上的动作及尝试函数
}
-----old_actions-----修改老动作
{
	switch,--开关，用于确定是否需要修改
	id,--动作ID
	actiondata,--需要修改的动作数据，诸如strfn、fn等，可不写
	state,--关联SGstate,可以是字符串或者函数
}
--]]

local MEDAL_FRUIT_TREE_SCION_LOOT = require("medal_defs/medal_fruit_tree_defs").MEDAL_FRUIT_TREE_SCION_LOOT--获取接穗掉率表

--使用工具工作
local function DoToolWork(act, workaction)
    if act.target.components.workable ~= nil and
        act.target.components.workable:CanBeWorked() and
        act.target.components.workable:GetWorkAction() == workaction then
        act.target.components.workable:WorkedBy(
            act.doer,
            (   (   act.invobject ~= nil and
                act.invobject.components.tool ~= nil and
                act.invobject.components.tool:GetEffectiveness(workaction)
            ) or
            (   act.doer ~= nil and
                act.doer.components.worker ~= nil and
                act.doer.components.worker:GetEffectiveness(workaction)
            ) or
            1
            ) *
            (   act.doer.components.workmultiplier ~= nil and
                act.doer.components.workmultiplier:GetMultiplier(workaction) or
                1
        )
        )
        return true
    end
    return false
end

--补充耐久(材料,目标,单个材料可增加的耐久)
local function addUseFn(inst,target,adduse)
	local uses = target.components.finiteuses and target.components.finiteuses:GetUses()--当前耐久
	local total = target.components.finiteuses and target.components.finiteuses.total--耐久上限
	if uses==nil then return end
	adduse=adduse or 1
	--填充物有耐久的话，按耐久损耗比例换算补充
	if inst.components.finiteuses then
		adduse = math.ceil(adduse * inst.components.finiteuses:GetPercent())
	end
	if adduse>0 then
		if uses>=total then
			return--耐久达上限了
		end
	elseif adduse<0 then
		total=0--减耐久的话就用0作为上限来计算了
	else
		return
	end
	
	local neednum=math.max(math.floor((total-uses)/adduse),1)--需要消耗的材料数量
	local fuelnum = inst.components.stackable and inst.components.stackable.stacksize or 1--材料数量
	--消耗材料变更耐久
	if fuelnum>neednum then
		inst.components.stackable:SetStackSize(fuelnum-neednum)
		target.components.finiteuses:SetUses(math.min(uses+neednum*adduse,target.components.finiteuses.total))
		if target.addusefn then--扩展回调
			target:addusefn(inst,neednum)
		end
	else
		target.components.finiteuses:SetUses(math.min(uses+fuelnum*adduse,target.components.finiteuses.total))
		if target.addusefn then--扩展回调
			target:addusefn(inst,fuelnum)
		end
		inst:Remove()
	end
	return true
end

--获取堆叠数量
local function GetStackSize(item)
    return item.components.stackable ~= nil and item.components.stackable:StackSize() or 1
end
--移除预制物(预制物,数量)
local function removeItem(item,num)
	if item.components.stackable then
		item.components.stackable:Get(num):Remove()
	else
		item:Remove()
	end
end
--获取可融合勋章升级对象(勋章1,勋章2,玩家)
local function getMultivariateTarget(inst,target,doer)
	local newmedal_loot={
		blank_certificate={
			target="multivariate_certificate",
			tag="traditionalbearer1",
		},
		multivariate_certificate={
			target="medium_multivariate_certificate",
			tag="traditionalbearer2",
		},
		medium_multivariate_certificate={
			target="large_multivariate_certificate",
			tag="traditionalbearer3",
		},
	}
	if inst.prefab ~= target.prefab then
		return
	end
	if newmedal_loot[inst.prefab] and doer:HasTag(newmedal_loot[inst.prefab].tag) then
		return newmedal_loot[inst.prefab].target
	end
end

--自定义动作
local actions = {
	----------------------------INVENTORY道具栏右键----------------------------
	{
		id = "WEARMEDAL",--佩戴勋章
		str = STRINGS.MEDAL_NEWACTION.WEARMEDAL,
		fn = function(act)
			local equipped = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY)--获取玩家勋章栏的勋章
			--勋章不存在、勋章栏没勋章、勋章栏的勋章没容器组件则返回false
			if act.invobject == nil or equipped == nil or equipped.components.container == nil or not equipped:HasTag("multivariate_certificate") then
				return false
			end
			
			--获取融合勋章内可装备勋章的格子
			local targetslot = equipped.components.container:GetSpecificMedalSlotForItem(act.invobject)
			if targetslot == nil then
				return false
			end
			--获取融合勋章栏对应格子内的勋章
			local cur_item = equipped.components.container:GetItemInSlot(targetslot)
			--融合勋章格子里没其他勋章
			if cur_item == nil then
				--把勋章放入融合勋章内
				local item = act.invobject.components.inventoryitem:RemoveFromOwner(equipped.components.container.acceptsstacks)
				equipped.components.container:GiveItem(item, targetslot, nil, false)
				-- act.doer:PushEvent("equip", { item = item, eslot = EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY })
			--融合勋章栏里勋章满了并且最后一格和想放进去的勋章不一样
			-- elseif act.invobject.prefab ~= cur_item.prefab then
			else
				--把勋章放入融合勋章内,并把原来的勋章还给玩家
				local item = act.invobject.components.inventoryitem:RemoveFromOwner(equipped.components.container.acceptsstacks)
				local old_item = equipped.components.container:RemoveItemBySlot(targetslot)
				if not equipped.components.container:GiveItem(item, targetslot, nil, false) then
					act.doer.components.inventory:GiveItem(item)--, nil, equipped:GetPosition())
				end
				if old_item ~= nil then 
					-- act.doer.components.inventory:GiveItem(old_item)--, nil, equipped:GetPosition())
					--切换勋章的时候把勋章放回原位
					if item.prevcontainer ~= nil then
						item.prevcontainer.inst.components.container:GiveItem(old_item, item.prevslot)
					else
						act.doer.components.inventory:GiveItem(old_item, item.prevslot)
					end
				end
				-- act.doer:PushEvent("equip", { item = item, eslot = EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY })
				return true
			end
			return false
		end,
		actiondata = {
			priority=7,
			rmb=true,
			instant=true,
			mount_valid=true,--骑牛
			encumbered_valid=true,
		},
	},
	{
		id = "TAKEOFFMEDAL",--摘下勋章
		str = STRINGS.MEDAL_NEWACTION.TAKEOFFMEDAL,
		fn = function(act)
			local equipped = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY)--获取玩家勋章栏的勋章
			--勋章不存在、勋章栏没勋章、勋章栏的勋章没容器组件则返回false
			if act.invobject == nil or equipped == nil or equipped.components.container == nil or not equipped:HasTag("multivariate_certificate") then
				return false
			end
			
			--如果勋章在融合勋章里，则执行摘下勋章的操作
			if act.invobject.components.inventoryitem:IsHeldBy(equipped) then
				local item = equipped.components.container:RemoveItem(act.invobject)--移除融合勋章中的勋章
				if item ~= nil then
					item.prevcontainer = nil
					item.prevslot = nil
					--勋章还给玩家
					local medal_box=act.doer.components.inventory:FindItem(function(inst)
						if inst:HasTag("medal_box") then
							if inst.components.container and not inst.components.container:IsFull() and inst.replica.container:IsOpenedBy(act.doer) then
								return true
							end
						end
						return false
					end)
					if medal_box then
						medal_box.components.container:GiveItem(item)
					else
						act.doer.components.inventory:GiveItem(item)--, nil, equipped:GetPosition())
					end
					-- act.doer:PushEvent("unequip", { item = item, eslot = EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY})
					return true
				end
			end
			return false
		end,
		actiondata = {
			priority=7,
			rmb=true,
			instant=true,
			mount_valid=true,
			encumbered_valid=true,
		},
	},
	{
		id = "RELEASEMEDALSOUL", --释放勋章灵魂
		str = STRINGS.MEDAL_NEWACTION.RELEASEMEDALSOUL,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("medal_blinker") and act.invobject ~= nil and act.invobject.prefab == "devour_soul_certificate" and not act.invobject:HasTag("usesdepleted") then
				local fuses = act.invobject.components.finiteuses
				if fuses and fuses:GetUses() > 0 then
					local soul=SpawnPrefab("wortox_soul")
					local x,y,z=act.doer.Transform:GetWorldPosition()
					if soul then
						soul.Transform:SetPosition(x, y, z)
						soul.Physics:Teleport(x, y, z)
						soul.components.inventoryitem:OnDropped(true)
						fuses:Use(1)
					end
					return true
				end
			end
		end,
		state = "give",
		actiondata = {
			priority=8,
			mount_valid=true,
		},
	},
	{
		id = "BACKTOMEDALTOWER", --回城
		str = STRINGS.MEDAL_NEWACTION.BACKTOMEDALTOWER,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("space_medal") and act.invobject ~= nil and act.invobject:HasTag("canbacktotower") then
				local fuses = act.invobject.components.finiteuses
				local needuses = TUNING_MEDAL.SPEED_MEDAL.ADDUSES*TUNING_MEDAL.SPEED_MEDAL.CONSUME_MULT--需要消耗耐久
				if fuses and fuses:GetUses() > needuses then
					local target = act.invobject.targetTeleporter--传送目标
					if target and target:IsValid() then
						act.invobject.components.finiteuses:Use(needuses)--扣除耐久
						--执行传送sg
						act.doer.sg:GoToState("medal_entertownportal", { teleporter = target,target=target })
						return true
					else--目标传送点已失效
						act.invobject.targetTeleporter=nil
						act.invobject:RemoveTag("canbacktotower")
						MedalSay(act.doer,STRINGS.DELIVERYSPEECH.CANTFINDTARGET)
						return true
					end
				end
			end
		end,
		state = "give",
		actiondata = {
			priority=8,
		},
	},
	{
		id = "MEDALCOOKBOOK", --阅读食谱书
		str = STRINGS.MEDAL_NEWACTION.MEDALCOOKBOOK,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject:HasTag("medal_cookbook") then
				act.doer:ShowPopUp(POPUPS.COOKBOOK, true)
				return true
			end
		end,
		state = "give",
		actiondata = {
			priority=8,
			mount_valid=true,
		},
	},
	{
		id = "RELEASEBEEKINGPOWER", --切换蜂王勋章攻击模式
		str = STRINGS.MEDAL_NEWACTION.RELEASEBEEKINGPOWER,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("is_bee_king") and act.invobject ~= nil and act.invobject.prefab == "bee_king_certificate" and not act.invobject:HasTag("usesdepleted") then
				local fuses = act.invobject.components.finiteuses
				if fuses and fuses:GetUses() > 0 then
					--切换勋章攻击模式
					if act.invobject.changeState then
						act.invobject:changeState(not act.invobject.isaoe)
						SpawnPrefab("bee_poof_big").Transform:SetPosition(act.doer.Transform:GetWorldPosition())
						return true
					end
				end
			end
		end,
		state = "give",
		actiondata = {
			priority=8,
			mount_valid=true,
		},
	},
	{
		id = "TOUCHSPACEMEDAL", --摸时空勋章
		str = STRINGS.MEDAL_NEWACTION.TOUCHMEDALTOWER,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject:HasTag("medal_delivery") and act.invobject:HasTag("candelivery") then
				local medal = act.doer.components.inventory and act.doer.components.inventory:EquipMedalWithTag("candelivery")
				if medal then
					if act.invobject.components.medal_delivery then
						act.invobject.components.medal_delivery:OpenScreen(act.doer)
					end
				else
					MedalSay(act.doer,STRINGS.DELIVERYSPEECH.FALSEMEDAL)
				end
				return true
			end
		end,
		state = "give",
		actiondata = {
			priority=10,
		},
	},
	{
		id = "STROKEMEDAL", --摸虫木勋章、植物勋章
		str = STRINGS.MEDAL_NEWACTION.STROKEMEDAL,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject:HasTag("canstrokemedal") then
				if act.invobject.strokeFn then
					act.invobject:strokeFn(act.doer)
					return true
				end
			end
		end,
		state = "give",
		actiondata = {
			priority=10,
			mount_valid=true,
		},
	},
	{
		id = "ADDJUSTICE", --快速补充正义值
		str = STRINGS.MEDAL_NEWACTION.ADDJUSTICEVALUE,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("addjustice") and act.invobject ~= nil and act.invobject.prefab=="medal_monster_essence" then
				local medal = act.doer.components.inventory and act.doer.components.inventory:EquipMedalWithName("justice_certificate")
				if medal and medal.medal_repair_common and medal.medal_repair_common.medal_monster_essence then
					return addUseFn(act.invobject,medal,medal.medal_repair_common.medal_monster_essence)
				end
			end
		end,
		state = "give",
		actiondata = {
			priority=10,
			mount_valid=true,
		},
	},
	{
		id = "TOUCHSPACESTAFF", --摸时空法杖
		str = STRINGS.MEDAL_NEWACTION.TOUCHSPACESTAFF,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject:HasTag("medal_delivery") and act.invobject:HasTag("changespacetarget") then
				if act.invobject.components.medal_delivery then
					act.invobject.components.medal_delivery:OpenScreen(act.doer)
				end
				return true
			end
		end,
		state = "give",
		actiondata = {
			priority=10,
		},
	},
	{
		id = "TOUCHSKINSTAFF", --摸皮肤法杖
		str = STRINGS.MEDAL_NEWACTION.TOUCHSKINSTAFF,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="medal_skin_staff" and act.invobject:HasTag("openskinpage") then
				act.doer:ShowPopUp(POPUPS.MEDALSKIN, true ,act.invobject)
				return true
			end
		end,
		state = "give",
		actiondata = {
			priority=10,
			mount_valid=true,
		},
	},
	{
		id = "TOUCHSPACETIMERUNES", --摸时空符文
		str = STRINGS.MEDAL_NEWACTION.TOUCHMEDALTOWER,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="medal_spacetime_runes" and act.invobject:HasTag("medal_delivery") and act.invobject:HasTag("INLIMBO") then
				local owner = act.invobject.components.inventoryitem and act.invobject.components.inventoryitem:GetGrandOwner()
				if act.doer == owner then
					if act.invobject.components.medal_delivery then
						act.invobject.components.medal_delivery:OpenScreen(act.doer)
					end
				else
					MedalSay(act.doer,STRINGS.DELIVERYSPEECH.NEEDCARRY)
				end
				return true
			end
		end,
		state = "give",
	},
	{
		id = "UNWRAPSNACKS", --拆开时空零食
		str = STRINGS.MEDAL_NEWACTION.UNWRAPSNACKS,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="medal_spacetime_snacks" then
				-- local owner = act.invobject.components.inventoryitem and act.invobject.components.inventoryitem:GetGrandOwner()
				local container = act.invobject.components.inventoryitem ~= nil and act.invobject.components.inventoryitem:GetContainer() or nil--目标所在容器
				local spawn_at = (container ~= nil and container.inst) or act.invobject or act.doer--生成点目标
				local lingshi = SpawnPrefab("medal_spacetime_lingshi")
				local packet = SpawnPrefab("medal_spacetime_snacks_packet")
				if lingshi and packet then
					lingshi.components.stackable:SetStackSize(5)
					lingshi.Transform:SetPosition(spawn_at.Transform:GetWorldPosition())
					packet.Transform:SetPosition(spawn_at.Transform:GetWorldPosition())
					--目标在容器里，则返还给容器
					if container ~= nil then
						container:GiveItem(lingshi, nil, lingshi:GetPosition())
						container:GiveItem(packet, nil, packet:GetPosition())
					end
					removeItem(act.invobject)
					return true
				end
			end
		end,
		state = "domediumaction",
		actiondata = {
			mount_valid=true,
		},
	},
	{
		id = "TOUCHWISDOMTEST", --摸蒙昧勋章
		str = STRINGS.MEDAL_NEWACTION.TOUCHWISDOMTEST,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="wisdom_test_certificate" and act.invobject:HasTag("examable") then
				local item = act.doer.components.inventory and act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
				local hasdictionary 
				if item and item.prefab=="xinhua_dictionary" then
					if item.components.finiteuses then
						item.components.finiteuses:Use(1)
						hasdictionary = true
					end
				end
				act.doer:ShowPopUp(POPUPS.MEDALEXAM, true, act.invobject, hasdictionary)--打开答题界面
				return true
			end
		end,
		state = "give",
		actiondata = {
			priority=10,
			mount_valid=true,
		},
	},
	{
		id = "CALLTRIBUTEBOX", --召唤奉纳盒
		str = STRINGS.MEDAL_NEWACTION.CALLTRIBUTEBOX,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="medal_tribute_symbol" then
				local x,y,z = act.doer.Transform:GetWorldPosition()
				if TheWorld.Map:IsDeployPointClear(Vector3(x, y, z), nil, 2) then
					act.invobject:DoTaskInTime(1,function(inst)
						local box = SpawnPrefab("medal_pay_tribute_box")
						if box then
							box.Transform:SetPosition(x, y, z)
							if box.SetTributeId then
								box:SetTributeId(nil,act.doer)
							end
							SpawnPrefab("round_puff_fx_lg").Transform:SetPosition(x, y, z)
							removeItem(inst)
						end
					end)
					return true
				end
				return false,"TOOCROWDED"
			end
		end,
		state = "commune_with_abigail",
	},
	{
		id = "UNWRAPGIFTFRUIT", --拆开包果
		str = STRINGS.MEDAL_NEWACTION.UNWRAPSNACKS,
		fn = function(act)
			local target = act.target or act.invobject
			if act.doer ~= nil and target ~= nil and target.prefab=="medal_gift_fruit" then
				local container = target.components.inventoryitem ~= nil and target.components.inventoryitem:GetContainer() or nil--目标所在容器
				local spawn_at = (container ~= nil and container.inst) or target or act.doer--生成点目标
				local gift = SpawnPrefab(target.GetGift and target:GetGift(act.doer) or "goldnugget")
				if gift then
					gift.Transform:SetPosition(spawn_at.Transform:GetWorldPosition())
					if gift.components.inventoryitem ~= nil then
						gift.components.inventoryitem:OnDropped(true, .5)
					end
					--目标在容器里，则返还给容器
					-- if container ~= nil then
					-- 	container:GiveItem(gift, nil, gift:GetPosition())
					-- end
					removeItem(target)
					return true
				end
			end
		end,
		state = function(inst, action)
            return inst:HasTag("has_handy_medal") and "domediumaction" or "dolongaction"
        end,
		actiondata = {
			priority=2,
			mount_valid=true,
		},
		canqueuer = "rightclick",--兼容排队论
	},
	
	----------------------------USEITEM拿起某物品放到另一个物品上点击后执行----------------------------
	{
		id = "GIVEIMMORTAL", --赋予不朽之力
		str = STRINGS.MEDAL_NEWACTION.GIVEIMMORTAL,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab == "immortal_gem" and act.target:HasTag("canbeimmortal") and not act.target:HasTag("keepfresh") then
				--吞噬法杖升级成不朽法杖
				if act.target.prefab=="devour_staff" then
					local container = act.target.components.inventoryitem ~= nil and act.target.components.inventoryitem:GetContainer() or nil--目标所在容器
					local spawn_at = (container ~= nil and container.inst) or act.target or act.doer--生成点目标
					local newitem = SpawnPrefab("immortal_staff")
					if newitem then
						newitem.Transform:SetPosition(spawn_at.Transform:GetWorldPosition())
						--目标在容器里，则返还给容器
						if container ~= nil then
							container:GiveItem(newitem, nil, newitem:GetPosition())
						end
						act.invobject:Remove()
						act.target:Remove()
						return true
					end
				end

				--获取玩家身上的不朽精华
				local essences = act.doer.components.inventory:FindItems(function(item)
						return item.prefab == "immortal_essence" 
					end)
				local essences_count = 0--不朽精华数量
				for i, v in ipairs(essences) do
					essences_count = essences_count + GetStackSize(v)
				end
				local numslots=act.target.components.container and act.target.components.container.numslots--容器格子数量
				local need_consume=numslots and math.ceil((math.floor(numslots/10)*0.5+1)*numslots)
				if need_consume then
					--玩家身上的不朽精华数量不能少于格子数量(部分容器可跳过该判断)
					if act.target.no_consume_essences or need_consume<=essences_count then
						if act.target.setImmortal then
							act.target.setImmortal(act.target)
							removeItem(act.invobject)
							--部分容器可不消耗
							if not act.target.no_consume_essences then
								--消耗不朽精华
								act.doer.components.inventory:ConsumeByName("immortal_essence",need_consume)
							end
							MedalSay(act.doer,STRINGS.IMMORTALSPEECH.SUCCESS)
						end
					else
						MedalSay(act.doer,STRINGS.IMMORTALSPEECH.NOTENOUGH..need_consume..STRINGS.IMMORTALSPEECH.NOTENOUGH2)
					end
					return true
				end
			end
		end,
		state = "give",
		actiondata = {
			priority=10,--99999,
			mount_valid=true,
		},
	},
	{
		id = "GIVESPACEGEM", --赋予空间之力
		str = STRINGS.MEDAL_NEWACTION.GIVESPACEGEM,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab == "medal_space_gem" and (act.target.prefab=="krampus_sack" or act.target:HasTag("cangivespacegem")) then
				local container = act.target.components.inventoryitem ~= nil and act.target.components.inventoryitem:GetContainer() or nil--目标所在容器
				--不能在融合勋章内赋予空间之力
				if container and container.inst:HasTag("multivariate_certificate") then
					MedalSay(act.doer,STRINGS.IMMORTALSPEECH.ISEQUIPPED)
					return true
				end
				if act.target.components.equippable and not act.target.components.equippable:IsEquipped() then
					local spawn_loot={
						krampus_sack="medal_krampus_chest_item",--坎普斯背包-坎普斯宝匣
						space_certificate="space_time_certificate",--空间勋章-时空勋章
						devour_staff="medal_space_staff",--吞噬法杖-时空法杖
					}
					local spawn_at = (container ~= nil and container.inst) or act.target or act.doer--生成点目标
					local newitem = SpawnPrefab(spawn_loot[act.target.prefab])
					if newitem then
						newitem.Transform:SetPosition(spawn_at.Transform:GetWorldPosition())
						--转移资源
						if act.target.prefab=="krampus_sack" then
							-- transferEverything(target,newitem)
							--继承不朽之力
							if act.target:HasTag("keepfresh") and newitem.setImmortal then
								newitem:setImmortal()
							end
							--转移资源
							if act.target.components.container and not act.target.components.container:IsEmpty() then
								if newitem.components.container then
									local allitems=act.target.components.container:RemoveAllItemsWithSlot()
									if allitems then
										for k,v in pairs(allitems) do
											newitem.components.container:GiveItem(v,k)
										end
									end
								end
							end
						end
						--目标在容器里，则返还给容器
						if container ~= nil then
							container:GiveItem(newitem, nil, newitem:GetPosition())
						end
						act.invobject:Remove()
						act.target:Remove()
						return true
					end
				else--不能在装备时赋予空间之力
					MedalSay(act.doer,STRINGS.IMMORTALSPEECH.ISEQUIPPED)
					return true
				end
			end
		end,
		state = "give",
		actiondata = {
			priority=10,--99999,
			mount_valid=true,
		},
	},
	{
		id = "CHEFFLAVOUR",--调味
		str = STRINGS.MEDAL_NEWACTION.CHEFFLAVOUR,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("seasoningchef") and act.invobject ~= nil and act.invobject:HasTag("spice") and act.target:HasTag("preparedfood") and not act.target:HasTag("spicedfood") then
				local owner = act.target.components.inventoryitem and act.target.components.inventoryitem.owner or nil
				local container = nil--目标料理所在容器组件
				if owner then
					container = owner.components.inventory or owner.components.container
				end
				
				local newfood=SpawnPrefab(act.target.prefab.."_"..act.invobject.prefab)
				local perishablePercent=nil
				if act.target.components.perishable then
					perishablePercent=act.target.components.perishable:GetPercent()
				end
				if newfood then
					if newfood.components.perishable and perishablePercent ~= nil then
						newfood.components.perishable:SetPercent(perishablePercent)
					end
					if not (container and container:GiveItem(newfood)) then
						act.doer.components.inventory:GiveItem(newfood)
					end
					removeItem(act.invobject)
					removeItem(act.target)
				else
					MedalSay(act.doer,STRINGS.CHEFFLAVOURSPEECH.FAILFLAVOUR)
				end
				return true
			end
		end,
		state = "domediumaction",
		actiondata = {
			mount_valid=true,
		},
		canqueuer = "allclick",--兼容排队论
	},
	{
		id = "POWERPRINT",--能力印刻
		str = STRINGS.MEDAL_NEWACTION.POWERPRINT,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and ((act.invobject:HasTag("copyfunctional") and act.target.prefab=="blank_certificate") or (act.invobject.prefab=="blank_certificate" and act.target:HasTag("copyfunctional"))) then
				local blankmedal = act.target.prefab=="blank_certificate" and act.target or act.invobject--空白勋章
				local targetmedal = act.target.prefab=="blank_certificate" and act.invobject or act.target--目标勋章
				local medalname = targetmedal.prefab
				local owner = blankmedal.components.inventoryitem and blankmedal.components.inventoryitem.owner or nil
				if blankmedal.components.equippable and not blankmedal.components.equippable:IsEquipped() then
					--不能在融合勋章内印刻
					if owner and owner:HasTag("multivariate_certificate") then
						MedalSay(act.doer,STRINGS.POWERPRINTSPEECH.ISEQUIPPED)
						return true
					end
					--等级继承
					if targetmedal.medal_level then
						medalname=medalname.."&"..targetmedal.medal_level
					end
					--如果需要印刻的勋章和空白勋章已有的能力不同，则进行印刻
					local oldname = blankmedal.blankmedalchangename:value() or "blank_certificate"
					if oldname ~= medalname then
						blankmedal.blankmedalchangename:set(medalname)--换名
						MedalSay(act.doer,STRINGS.POWERPRINTSPEECH.SUCCESS)
					else
						MedalSay(act.doer,STRINGS.POWERPRINTSPEECH.ALREADY)
					end
				else
					MedalSay(act.doer,STRINGS.POWERPRINTSPEECH.ISEQUIPPED)
				end
				return true
			end
		end,
		state = "domediumaction",
		actiondata = {
			mount_valid=true,
		},
	},
	{
		id = "POWERABSORB",--能力吸收
		str = STRINGS.MEDAL_NEWACTION.POWERABSORB,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and act.invobject ~= nil and act.invobject:HasTag("blank_certificate") and (act.target.prefab=="statueglommer" or act.target:HasTag("powerabsorbable")) then
				local medal_loot={
					rage_krampus_soul="devour_soul_certificate",--暴怒之灵→噬灵勋章
					amulet="bathingfire_certificate",--重生护符→浴火勋章
					medal_withered_heart="bee_king_certificate",--凋零之心→蜂王勋章
				}
				
				if act.target:HasTag("powerabsorbable") then
					--羽绒服、蓝晶帽
					if act.target.prefab=="down_filled_coat" or act.target.prefab=="hat_blue_crystal" then
						local iscoat=act.target.prefab=="down_filled_coat"
						local newmedal=SpawnPrefab(iscoat and "down_filled_coat_certificate" or "blue_crystal_certificate")
						if newmedal then
							act.doer.components.inventory:GiveItem(newmedal)
							if act.target.components.fueled then
								act.target.components.fueled:DoDelta(-(iscoat and TUNING_MEDAL.DOWN_FILLED_COAT_MEDAL_PERISHTIME or TUNING_MEDAL.HAT_BLUE_CRYSTAL_MEDAL_PERISHTIME))
							end
							removeItem(act.invobject)
							return true
						end
					elseif medal_loot[act.target.prefab] then
						local newmedal=SpawnPrefab(medal_loot[act.target.prefab])
						if newmedal then
							act.doer.components.inventory:GiveItem(newmedal)
							removeItem(act.target)
							removeItem(act.invobject)
							return true
						end
					end
				else--格罗姆雕像
					if act.invobject.blankmedalchangename:value() ~= "naughty_certificate" then
						act.invobject.blankmedalchangename:set("naughty_certificate")
						MedalSay(act.doer,STRINGS.BLANKMEDALSPEECH.GETNAUGHTY)
						return true
					else--重复吸收则直接变成正品
						local newmedal=SpawnPrefab("naughty_certificate")
						if newmedal then
							act.doer.components.inventory:GiveItem(newmedal)
							removeItem(act.invobject)
							return true
						end
					end
				end
			end
		end,
		state = "domediumaction",
		actiondata = {
			mount_valid=true,
		},
	},
	{
		id = "MEDALUPGRADE",--勋章升级
		str = STRINGS.MEDAL_NEWACTION.MEDALUPGRADE,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject:HasTag("upgradablemedal") and act.target:HasTag("upgradablemedal") then
				--同种勋章才能融合升级
				if act.invobject.prefab == act.target.prefab then 
					local owner = act.target.components.inventoryitem and act.target.components.inventoryitem.owner or nil
					--不能在融合勋章内融合
					if owner and owner:HasTag("multivariate_certificate") then
						MedalSay(act.doer,STRINGS.MEDALUPGRADESPEECH.ISEQUIPPED)
						return true
					end
					if act.target.components.equippable and not act.target.components.equippable:IsEquipped() then
						local maxLevel=math.max(act.invobject.medal_level,act.target.medal_level)--取两个勋章的最大等级
						--勋章等级不能超过最大等级
						if maxLevel<act.invobject.medal_level_max then
							local newLevel=math.min(act.invobject.medal_level_max,act.invobject.medal_level+act.target.medal_level)
							act.target.medal_level=newLevel--等级继承
							act.target.changemedallevelname:set(newLevel)--名字变更
							--如果有耐久则融合耐久
							local medal_use1=act.invobject.components.finiteuses and act.invobject.components.finiteuses:GetUses()
							local medal_use2=act.target.components.finiteuses and act.target.components.finiteuses:GetUses()
							if medal_use1 and medal_use2 then
								act.target.components.finiteuses:SetMaxUses(TUNING_MEDAL.SPEED_MEDAL.MAXUSES*newLevel)
								act.target.components.finiteuses:SetUses(medal_use1+medal_use2)
							end
							removeItem(act.invobject)
							MedalSay(act.doer,STRINGS.MEDALUPGRADESPEECH.SUCCESS)
						else
							MedalSay(act.doer,STRINGS.MEDALUPGRADESPEECH.ISMAX)
						end
					else
						MedalSay(act.doer,STRINGS.MEDALUPGRADESPEECH.ISEQUIPPED)
					end
				else
					MedalSay(act.doer,STRINGS.MEDALUPGRADESPEECH.UNLIKE)
				end
				return true
			end
		end,
		state = "domediumaction",
		actiondata = {
			mount_valid=true,
		},
	},
	{
		id = "REPAIRCOMMON",--通用补充耐久(finiteuses组件)
		str = STRINGS.MEDAL_NEWACTION.REPAIRCOMMON,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.target~=nil and act.target.medal_repair_common and act.target.medal_repair_common[act.invobject.prefab]~=nil then
				if act.invobject.prefab~="glommerflower" or act.invobject:HasTag("show_spoilage") then
					return addUseFn(act.invobject,act.target,act.target.medal_repair_common[act.invobject.prefab])
				end
			end
		end,
		state = "give",
		actiondata = {
			priority=10,
			mount_valid=true,
		},
	},
	{
		id = "REPAIRDEVOURSTAFF",--补充吞噬法杖、时空法杖能量(喂食)
		str = STRINGS.MEDAL_NEWACTION.MEDALEATFOOD,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.target~=nil and act.target:HasTag("medal_eatfood") and act.invobject:HasTag("preparedfood") then
				local edible=act.invobject.components.edible
				if edible and edible.foodtype ~= FOODTYPE.ROUGHAGE then
					local addUse=edible.hungervalue*TUNING_MEDAL.DEVOUR_STAFF_HUNGER_RATE+edible.sanityvalue*TUNING_MEDAL.DEVOUR_STAFF_SANITY_RATE+edible.healthvalue*TUNING_MEDAL.DEVOUR_STAFF_HEALTH_RATE
					if addUse>0 then
						return addUseFn(act.invobject,act.target,addUse)
					end
				end
			end
		end,
		state = "give",
		actiondata = {
			priority=10,
			mount_valid=true,
		},
	},
	{
		id = "MAKECOOLDOWN",--强制冷却
		str = STRINGS.MEDAL_NEWACTION.MAKECOOLDOWN,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject:HasTag("cooldownable") and ((act.target:HasTag("blueflame") and act.target:HasTag("fire")) or act.target.prefab=="staffcoldlight") then
				local newitem=SpawnPrefab(act.invobject.prefab=="lavaeel" and "medal_obsidian" or "medal_blue_obsidian")
				if newitem then
					act.doer.components.inventory:GiveItem(newitem)
					removeItem(act.invobject)
					return true
				end
			end
		end,
		state = "domediumaction",
		canqueuer = "allclick",--兼容排队论
		actiondata = {
			mount_valid=true,
		},
	},
	{
		id = "BOTTLESSOUL",--灵魂装瓶
		str = STRINGS.MEDAL_NEWACTION.BOTTLESSOUL,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and act.invobject ~= nil and act.invobject.prefab=="messagebottleempty" and act.target.prefab=="krampus_soul" then
				local newitem=SpawnPrefab("bottled_soul")
				if newitem~=nil then
					act.doer.components.inventory:GiveItem(newitem)
					act.target:Remove()
					removeItem(act.invobject)
					return true
				end
			end
		end,
		state = "domediumaction",
		actiondata = {
			mount_valid=true,
		},
	},
	{
		id = "PLACECHUM",--投放鱼食
		str = STRINGS.MEDAL_NEWACTION.PLACECHUM,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and act.invobject ~= nil and act.invobject.prefab=="barnacle" and act.target.prefab=="medal_seapond" then
				local fishable = act.target.components.fishable
				if fishable then
					--饵力值没满
					if fishable.bait_force and fishable.bait_force<10 then
						--增加饵力值
						fishable.bait_force=math.min(fishable.bait_force+math.random(2,3),TUNING_MEDAL.SEAPOND_MAX_NUM)
						fishable:SetRespawnTime(TUNING_MEDAL.SEAPOND_FISH_RESPAWN_TIME)--设定重生时间
						--鱼不满时开始刷新
						if fishable:GetFishPercent()<1 and not fishable.respawntask then
							fishable:RefreshFish()
						end
						SpawnPrefab("weregoose_splash_less2").entity:SetParent(act.target.entity)
						removeItem(act.invobject)
						MedalSay(act.doer,STRINGS.PLACECHUMSPEECH.SUCCESS)
						return true
					else
						MedalSay(act.doer,STRINGS.PLACECHUMSPEECH.ENOUGH)
						return true
					end
				end
			end
		end,
		state = "give",
	},
	{
		id = "DOINGOLD",--增加勋章熟练度
		str = STRINGS.MEDAL_NEWACTION.DOINGOLD,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and act.target.medal_addexp_loot and act.invobject ~= nil and act.target.medal_addexp_loot[act.invobject.prefab]~=nil then
				return addUseFn(act.invobject,act.target,act.target.medal_addexp_loot[act.invobject.prefab])
			end
		end,
		state = "give",
		actiondata = {
			mount_valid=true,
		},
	},
	{
		id = "MEDALTRANSPLANT",--月光移植
		str = STRINGS.MEDAL_NEWACTION.MEDALTRANSPLANT,
		fn = function(act)
			DoToolWork(act, ACTIONS.MEDALTRANSPLANT)
			return true
		end,
		state=function(inst)
			return not inst.sg:HasStateTag("predig")
                and (inst.sg:HasStateTag("digging") and
                    "dig" or
                    "dig_start")
                or nil
		end,
		actiondata = {
			rmb=true,
		},
		canqueuer = "rightclick",--兼容排队论
	},
	{
		id = "MEDALNORMALTRANSPLANT",--普通移植
		str = STRINGS.MEDAL_NEWACTION.MEDALTRANSPLANT,
		fn = function(act)
			DoToolWork(act, ACTIONS.MEDALNORMALTRANSPLANT)
			return true
		end,
		state=function(inst)
			return not inst.sg:HasStateTag("predig")
                and (inst.sg:HasStateTag("digging") and
                    "dig" or
                    "dig_start")
                or nil
		end,
		actiondata = {
			rmb=true,
		},
		canqueuer = "rightclick",--兼容排队论
	},
	{
		id = "MEDALHAMMER",--月光锤锤东西
		str = STRINGS.MEDAL_NEWACTION.MEDALHAMMER,
		fn = function(act)
			DoToolWork(act, ACTIONS.MEDALHAMMER)
			return true
		end,
		state=function(inst)
			return not inst.sg:HasStateTag("prehammer")
                and (inst.sg:HasStateTag("hammering") and
                    "hammer" or
                    "hammer_start")
                or nil
		end,
		actiondata = {
			rmb=true,
		},
		canqueuer = "rightclick",--兼容排队论
	},
	{
		id = "ROOTCHESTLEVELUP",--施肥(树根宝箱、虫木勋章)
		str = STRINGS.MEDAL_NEWACTION.ROOTCHESTLEVELUP,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and act.invobject ~= nil and (act.invobject.prefab=="compostwrap" or act.invobject.prefab=="spice_poop") and act.target:HasTag("needfertilize") then
				local mult = act.invobject.prefab=="spice_poop" and 0.5 or 1--秘制酱料效益为肥料包的一半
				--升级树根宝箱
				if act.target.levelUpFn then
					act.target:levelUpFn(act.invobject)
					-- act.target:levelUpFn(TUNING_MEDAL.LIVINGROOT_CHEST_ADDNUM*mult)
					-- removeItem(act.invobject)
					return true
				--虫木勋章、植物勋章、虫木花施肥
				elseif act.target.prefab=="plant_certificate" or act.target.prefab=="transplant_certificate" or act.target.prefab=="medal_wormwood_flower" then
					local addnum=TUNING_MEDAL.PLANT_MEDAL.FERTILITY*mult
					act.target.medal_fertility=math.min(act.target.medal_fertility and act.target.medal_fertility+addnum or addnum,TUNING_MEDAL.PLANT_MEDAL.FERTILITY)
					removeItem(act.invobject)
					return true
				--移植作物施肥
				elseif act.target:HasTag("medal_transplant") then
					if act.target.AddFertilizeFn then
						act.target:AddFertilizeFn()
						removeItem(act.invobject)
						return true
					end
				end
			end
		end,
		state = "give",
		actiondata = {
			priority=10,
		},
		canqueuer = "allclick",--兼容排队论
	},
	{
		id = "GIVEROOTCHESTLIFE",--树根宝箱复苏
		str = STRINGS.MEDAL_NEWACTION.GIVEROOTCHESTLIFE,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("has_plant_medal") and act.invobject ~= nil and act.invobject.prefab=="reviver" and act.target.prefab=="medal_livingroot_chest" and act.target:HasTag("notalive") then
				if act.target.givelifeFn then
					act.target.givelifeFn(act.target)
					removeItem(act.invobject)
					return true
				end
			end
		end,
		state = "domediumaction",
		actiondata = {
			priority=10,
		},
	},
	{
		id = "FISHMOONINWATER",--水中捞月
		str = STRINGS.MEDAL_NEWACTION.FISHMOONINWATER,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("groggy") and TheWorld.state.isfullmoon and act.doer.replica.sanity:IsLunacyMode() and act.invobject ~= nil and act.invobject.prefab=="messagebottleempty" and act.target:HasTag("cansalvage") then
				local newitem=SpawnPrefab("bottled_moonlight")
				if newitem~=nil then
					act.doer.components.inventory:GiveItem(newitem)
					removeItem(act.invobject)
					
					act.target.AnimState:OverrideSymbol("reflection_quarter", "moondial_waning_build", "reflection_quarter")
					act.target.AnimState:OverrideSymbol("reflection_half", "moondial_waning_build", "reflection_half")
					act.target.AnimState:OverrideSymbol("reflection_threequarter", "moondial_waning_build", "reflection_threequarter")
					act.target.AnimState:SetLightOverride(0.00)
					act.target.AnimState:PlayAnimation("wane_to_new")--播放水变没的动画
					act.target.Light:Enable(false)--取消光的显示
					act.target.Light:SetRadius(0.00)--设置光半径为0
					act.target:RemoveTag("cansalvage")--取消可打捞标记
					act.target.SoundEmitter:KillSound("loop")--清除声音
					-- act.target.sg:GoToState("next")
					return true
				end
			end
		end,
		state = "domediumaction",
		canqueuer = "allclick",--兼容排队论
	},
	{
		id = "WASHFUNCTIONAL",--能力清洗
		str = STRINGS.MEDAL_NEWACTION.WASHFUNCTIONAL,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and act.invobject ~= nil and act.invobject.prefab=="bottled_moonlight" and act.target:HasTag("washfunctionalable") then
				local container = act.target.components.inventoryitem ~= nil and act.target.components.inventoryitem:GetContainer() or nil--目标所在容器
				local spawn_at = (container ~= nil and container.inst) or act.target or act.doer--生成点目标
				local blankmedal = SpawnPrefab("blank_certificate")
				if blankmedal then
					blankmedal.Transform:SetPosition(spawn_at.Transform:GetWorldPosition())
					local oldmedal = act.target.components.inventoryitem:RemoveFromOwner(false)--需要被洗的勋章
					--目标在容器里，则返还给容器
					if container ~= nil and not container:GiveItem(blankmedal, oldmedal and oldmedal.prevslot, blankmedal:GetPosition()) then
						act.doer.components.inventory:GiveItem(blankmedal, nil, blankmedal:GetPosition())
					end
					if act.doer.components.inventory then
						--概率返还瓶子，否则破碎成玻璃碎片
						local returnitem = SpawnPrefab(math.random()<TUNING_MEDAL.BOTTLED_RETURN_RATE and "messagebottleempty" or "moonglass")
						returnitem.Transform:SetPosition(spawn_at.Transform:GetWorldPosition())
						act.doer.components.inventory:GiveItem(returnitem, nil, returnitem:GetPosition())
					end
					removeItem(act.invobject)
					if oldmedal then
						oldmedal:Remove()
					else
						removeItem(act.target)
					end
					return true
				end
			end
		end,
		state = "domediumaction",
		actiondata = {
			mount_valid=true,
		},
	},
	{
		id = "MAKEMUSHTREE",--变成蘑菇树
		str = STRINGS.MEDAL_NEWACTION.MAKEMUSHTREE,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("has_transplant_medal") and (TheWorld.state.isfullmoon or act.doer:HasTag("inmoonlight")) and act.invobject ~= nil and (act.invobject:HasTag("spore") or act.invobject:HasTag("medal_spore")) and act.target:HasTag("stump") and (act.target.prefab=="livingtree" or act.target.prefab=="livingtree_halloween") then
				local mushtree_spore_list={
					spore_tall="mushtree_tall",
					spore_medium="mushtree_medium",
					spore_small="mushtree_small",
					medal_spore_moon="mushtree_moon"
				}
				if mushtree_spore_list[act.invobject.prefab] then
					local newtree=SpawnPrefab(mushtree_spore_list[act.invobject.prefab])
					if newtree then
						newtree.Transform:SetPosition(act.target.Transform:GetWorldPosition())
						newtree.AnimState:PlayAnimation("change")
						newtree.SoundEmitter:PlaySound("dontstarve/cave/mushtree_tall_grow_1")
						newtree.AnimState:PushAnimation("idle_loop", true)
						newtree:DoTaskInTime(14 * FRAMES, function(inst)
							if not inst:HasTag("stump") and inst.components.growable then
								inst.components.growable:SetStage(inst.components.growable:GetNextStage())
							end
						end)
						removeItem(act.invobject)
						act.target:Remove()
						return true
					end
				end
			end
		end,
		state = "domediumaction",
		canqueuer = "allclick",--兼容排队论
	},
	{
		id = "MODIFYTOWERTEXT",--修改传送塔文字
		str = STRINGS.MEDAL_NEWACTION.MODIFYTOWERTEXT,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and act.invobject ~= nil and act.invobject.prefab=="featherpencil" and (act.target.prefab=="townportal" or act.target.prefab=="medal_livingroot_chest") then
				if act.target.components.writeable then
					if act.target.components.writeable:IsBeingWritten() then
						return false, "INUSE"
					end
					if CanEntitySeeTarget(act.doer, act.target) then
						act.target.components.writeable:BeginWriting(act.doer)
						removeItem(act.invobject)
						return true
					end
				end
			end
		end,
		state = "domediumaction",
		actiondata = {
			priority=10,
		},
	},
	{
		id = "REPAIRDELIVERYPOWER",--补充空间之力
		str = STRINGS.MEDAL_NEWACTION.REPAIRDELIVERYPOWER,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="townportaltalisman" and act.target.prefab=="medal_space_staff" then
				if act.target.addSpaceValue then
					return act.target:addSpaceValue(act.invobject)
				end
			end
		end,
		state = "give",
		actiondata = {
			priority=10,
			mount_valid=true,
		},
	},
	{
		id = "MAKEMANDARKPLANT",--曼德拉草种植
		str = STRINGS.MEDAL_NEWACTION.MAKEMANDARKPLANT,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("has_transplant_medal") and (TheWorld.state.isfullmoon or act.doer:HasTag("inmoonlight")) and act.invobject ~= nil and (act.invobject.prefab=="mandrake" or act.invobject.prefab=="mandrake_seeds") and act.target.prefab=="mound" and not act.target:HasTag("DIG_workable") then
				local mandrake_planted=SpawnPrefab("mandrake_planted")
				if mandrake_planted then
					mandrake_planted.Transform:SetPosition(act.target.Transform:GetWorldPosition())
					removeItem(act.invobject)
					--移除墓碑的子对象，防止墓碑被破坏时报错
					local gravestone=act.target.entity:GetParent()
					if gravestone and gravestone.mound then
						gravestone.mound=nil
					end
					act.target:Remove()
					return true
				end
			end
		end,
		state = "dolongaction",
	},
	{
		id = "GRAFTING_TREE",--嫁接
		str = STRINGS.MEDAL_NEWACTION.GRAFTING_TREE,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("has_transplant_medal") and act.invobject ~= nil and act.invobject:HasTag("graftingscion") and act.target.prefab=="medal_fruit_tree_stump" then
				local newtree=SpawnPrefab(act.invobject.treename or string.sub(act.invobject.prefab,0,-7))
				if newtree then
					newtree.Transform:SetPosition(act.target.Transform:GetWorldPosition())
					if newtree.components.pickable then
						newtree.components.pickable:MakeEmpty()
					end
					newtree.AnimState:PlayAnimation("change")
					newtree.AnimState:PushAnimation("idle", true)
					act.target:Remove()
					removeItem(act.invobject)
					return true
				end
			end
		end,
		state = "domediumaction",
		canqueuer = "allclick",--兼容排队论
	},
	{
		id = "PUT_IN_THE_SEEDS",--塞入种子
		str = STRINGS.MEDAL_NEWACTION.PUT_IN_THE_SEEDS,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("has_transplant_medal") and act.invobject ~= nil and act.invobject:HasTag("deployedfarmplant") and act.target.prefab=="livinglog" then
				local def=MEDAL_FRUIT_TREE_SCION_LOOT[act.invobject.prefab]--接穗信息表
				local scionprefab=nil--接穗代码
				if def then
					local season = TheWorld.state.season--当前季节
					local chance = def.seasonlist and def.seasonlist[season] and def.season_chance_put or def.chance--接穗掉落概率
					local randomnum = math.random()
					--一切都是宿命啊
					if def.hasdestiny and act.doer.components.medal_destiny then
						randomnum = act.doer.components.medal_destiny:GetDestiny() or randomnum
					end
					--获得接穗代码
					if chance and randomnum < chance then
						scionprefab=def.product
					end
				else
					scionprefab = math.random()<TUNING_MEDAL.SCION_BANANA_CHANCE and "medal_fruit_tree_banana_scion" or nil
				end
				
				--如果有接穗代码，则生成接穗，必定消耗活木和种子
				if scionprefab then
					local scion=SpawnPrefab(scionprefab)
					if scion then
						act.doer.components.inventory:GiveItem(scion)
						removeItem(act.target)--移除活木
						removeItem(act.invobject)--移除种子
						if act.doer.SoundEmitter ~= nil then--播放活木的惨叫声
							act.doer.SoundEmitter:PlaySound("dontstarve/creatures/leif/livinglog_burn")
						end
						return true
					end
				--失败时有概率失去活木
				elseif math.random()<TUNING_MEDAL.SCION_LOSE_LIVINGLOG_CHANCE then
					removeItem(act.target)--移除活木
					removeItem(act.invobject)--移除种子
					if act.doer.SoundEmitter ~= nil then--播放活木的惨叫声
						act.doer.SoundEmitter:PlaySound("dontstarve/creatures/leif/livinglog_burn")
					end
					return true
				end
				
				removeItem(act.invobject)--移除种子
				return true
			end
		end,
		state = "domediumaction",
		canqueuer = "allclick",--兼容排队论
	},
	{
		id = "GREENGEMPLANT",--埋下绿宝石
		str = STRINGS.MEDAL_NEWACTION.MAKEMANDARKPLANT,--共用文字
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and act.invobject ~= nil and act.invobject.prefab=="greengem" and act.target.prefab=="mound" and not act.target:HasTag("DIG_workable") then
				local medal_buried_greengem=SpawnPrefab("medal_buried_greengem")
				if medal_buried_greengem then
					medal_buried_greengem.Transform:SetPosition(act.target.Transform:GetWorldPosition())
					removeItem(act.invobject)
					--移除墓碑的子对象，防止墓碑被破坏时报错
					local gravestone=act.target.entity:GetParent()
					if gravestone and gravestone.mound then
						gravestone.mound=nil
					end
					act.target:Remove()
					return true
				end
			end
		end,
		state = "dolongaction",
	},
	{
		id = "WORMWOODFLOWERPLANT",--种植虫木花
		str = STRINGS.MEDAL_NEWACTION.WORMWOODFLOWERPLANT,--共用文字
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and TheWorld.state.isfullmoon and act.invobject ~= nil and act.invobject.prefab=="medal_ivy" and act.target.prefab=="medal_buried_greengem" then
				local ivy_num = GetStackSize(act.invobject)
				if ivy_num >= 3 then
					local medal_wormwood_flower=SpawnPrefab("medal_wormwood_flower")
					if medal_wormwood_flower then
						medal_wormwood_flower.Transform:SetPosition(act.target.Transform:GetWorldPosition())
						removeItem(act.invobject,3)
						act.target:Remove()
						return true
					end
				end
				return false,"NOTENOUGH"
			end
		end,
		state = "dolongaction",
	},
	{
		id = "MEDALSPIKEFUSE",--活性触手尖刺融合
		str = STRINGS.MEDAL_NEWACTION.MEDALUPGRADE,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("tentaclemedal") and act.invobject ~= nil and act.invobject.prefab=="medal_tentaclespike" and act.target.prefab=="medal_tentaclespike" then
				local spike_use1=act.invobject.components.finiteuses and act.invobject.components.finiteuses:GetUses()
				local spike_use2=act.target.components.finiteuses and act.target.components.finiteuses:GetUses()
				if spike_use1 and spike_use2 and spike_use2<TUNING_MEDAL.MEDAL_TENTACLESPIKE.MAXUSES then
					act.target.components.finiteuses:SetUses(math.min(spike_use1+spike_use2,TUNING_MEDAL.MEDAL_TENTACLESPIKE.MAXUSES))
					removeItem(act.invobject)
					return true
				end
			end
		end,
		state = "domediumaction",
		actiondata = {
			mount_valid=true,
		},
	},
	{
		id = "MEDALMAKEVARIATION",--使用变异药水
		str = STRINGS.MEDAL_NEWACTION.MEDALMAKEVARIATION,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="medal_moonglass_potion" and not act.target:HasTag("DECOR") then
				if act.target == nil
					or (not act.target:HasTag("flying") and not TheWorld.Map:IsPassableAtPoint(act.target.Transform:GetWorldPosition()))
					or (act.target.components.burnable ~= nil and (act.target.components.burnable:IsBurning() or act.target.components.burnable:IsSmoldering()))
					or (act.target.components.freezable ~= nil and act.target.components.freezable:IsFrozen())
					or (act.target.components.equippable ~= nil and act.target.components.equippable:IsEquipped()) then
					return false
				end
				if act.invobject.makeVariation then
					return act.invobject.makeVariation(act.invobject,act.target,act.doer)
				end
				return false
			end
		end,
		state = "give",
		canqueuer = "allclick",--兼容排队论
	},
	{
		id = "MULTIVARIATEUPGRADE",--融合勋章升级
		str = STRINGS.MEDAL_NEWACTION.MEDALUPGRADE,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.target ~= nil and getMultivariateTarget(act.invobject,act.target,act.doer) ~= nil then
				if act.invobject.components.container==nil or (act.invobject.components.container:IsEmpty() and act.target.components.container:IsEmpty()) then
					if act.target.components.equippable and not act.target.components.equippable:IsEquipped() then
						local owner = act.target.components.inventoryitem and act.target.components.inventoryitem.owner or nil--获取容器
						--不能在融合勋章内融合
						if owner and owner:HasTag("multivariate_certificate") then
							MedalSay(act.doer,STRINGS.MEDALUPGRADESPEECH.ISEQUIPPED)
							return true
						end
						local newmedal=SpawnPrefab(getMultivariateTarget(act.invobject,act.target,act.doer))
						if newmedal then
							if act.target.prevcontainer ~= nil then
								act.target.prevcontainer.inst.components.container:GiveItem(newmedal, act.target.prevslot)
							else
								act.doer.components.inventory:GiveItem(newmedal, act.target.prevslot)
							end
							act.invobject:Remove()
							act.target:Remove()
							MedalSay(act.doer,STRINGS.MEDALUPGRADESPEECH.SUCCESS)
						end
					else
						MedalSay(act.doer,STRINGS.MEDALUPGRADESPEECH.ISEQUIPPED)
					end
				else
					--里面有东西不能融合
					MedalSay(act.doer,STRINGS.MEDALUPGRADESPEECH.NEEDEMPTY)
				end
				return true
			end
		end,
		state = "domediumaction",
		actiondata = {
			priority=10,--99999,
			mount_valid=true,
		},
	},
	{
		id = "MEDALPYTREDE",--py交易
		str = STRINGS.MEDAL_NEWACTION.MEDALPYTREDE,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject:HasTag("medal_tradeable") and act.target:HasTag("medal_trade") then
				--新月才能Py
				if TheWorld and  not TheWorld.state.isnewmoon then
					return false,"NOTNEWMOON"
				end
				if act.invobject.prefab ~= "toil_money" and act.target.recyclingJunk then
					if act.target:recyclingJunk(act.invobject) then
						removeItem(act.invobject)
						return true
					end
				end
				if TheWorld and TheWorld.components.medal_infosave then
					--py成功
					if TheWorld.components.medal_infosave:DoPyTrade(act.target,act.doer) then
						MedalSay(act.doer,STRINGS.EXCHANGEGIFT_SPEECH.TRADE)
						removeItem(act.invobject)
						return true
					else--短期内不能多次py
						return false,"TOOOFTEN"
					end
				end
			end
		end,
		state = "give",
	},
	{
		id = "MEDALREMOULD",--改造
		str = STRINGS.MEDAL_NEWACTION.MEDALREMOULD,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="medal_waterpump_item" and act.target.prefab=="waterpump" then
				local x, y, z = act.target.Transform:GetWorldPosition()
				if TheWorld.Map:IsVisualGroundAtPoint(x,y,z) then
					local newwaterpump = SpawnPrefab("medal_waterpump")
					if newwaterpump then
						newwaterpump.Transform:SetPosition(x, y, z)
						newwaterpump:PushEvent("onbuilt")
						act.target:Remove()
						act.invobject:Remove()
					end
				else--不能在非陆地上改造
					MedalSay(act.doer,STRINGS.MEDALREMOULD_SPEECH.FAIL)
				end
				return true
			end
		end,
		state = "dolongaction",
	},
	{
		id = "MEDALEADDPOWER",--增加女武神之力
		str = STRINGS.MEDAL_NEWACTION.MEDALEADDPOWER,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and act.invobject ~= nil and act.invobject:HasTag("sketch") and act.target.prefab=="valkyrie_certificate" then
				local sketchLoot={
					"chesspiece_deerclops_sketch",--巨鹿
					"chesspiece_bearger_sketch",--熊大
					"chesspiece_moosegoose_sketch",--鸭子
					"chesspiece_dragonfly_sketch",--龙蝇
					"chesspiece_malbatross_sketch",--邪天翁
					"chesspiece_crabking_sketch",--帝王蟹
					"chesspiece_toadstool_sketch",--蛤蟆
					"chesspiece_stalker_sketch",--暗影编织者
					"chesspiece_klaus_sketch",--克劳斯
					"chesspiece_beequeen_sketch",--蜂后
					"chesspiece_antlion_sketch",--蚁狮
					"chesspiece_minotaur_sketch",--犀牛
					"chesspiece_guardianphase3_sketch",--天体英雄
					"chesspiece_eyeofterror_sketch",--恐怖之眼
					"chesspiece_twinsofterror_sketch",--双子魔眼
				}
				if act.target.valkyrie_power and act.target.valkyrie_power<TUNING_MEDAL.VALKYRIE_MEDAL.MAX_POWER then
					local sketchname=act.invobject.GetSpecificSketchPrefab and act.invobject:GetSpecificSketchPrefab() or nil
					if sketchname and table.contains(sketchLoot, sketchname) then
						act.target.valkyrie_power=act.target.valkyrie_power+1
						act.target:PushEvent("collectsketch")
						act.invobject:Remove()
						MedalSay(act.doer,STRINGS.MEDALEADDPOWER_SPEECH.SUCCESS)
					else--图纸不符合条件
						MedalSay(act.doer,STRINGS.MEDALEADDPOWER_SPEECH.FAIL)
					end
				else--不能再加了
					MedalSay(act.doer,STRINGS.MEDALEADDPOWER_SPEECH.ENOUGH)
				end
				return true
			end
		end,
		state = "give",
		actiondata = {
			mount_valid=true,
		},
	},
	{
		id = "REPAIRFARMPLOW",--打磨犁地机
		str = STRINGS.MEDAL_NEWACTION.REPAIRFARMPLOW,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="flint" and act.target.prefab=="medal_farm_plow_item" then
				return addUseFn(act.invobject,act.target,TUNING_MEDAL.MEDAL_FARM_PLOW_ADDUSE)
			end
		end,
		state = "give",
		actiondata = {
			priority=10,--99999,
			mount_valid=true,
		},
	},
	{
		id = "BINDINGTOWER",--速度勋章绑定传送塔
		str = STRINGS.MEDAL_NEWACTION.BINDINGTOWER,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="space_certificate" and act.target.prefab=="townportal" then
				--原本就已经绑定这个传送塔了
				if act.invobject.targetTeleporter and act.invobject.targetTeleporter == act.target then
					MedalSay(act.doer,STRINGS.DELIVERYSPEECH.ALREADYBOUND)
				else
					act.invobject.targetTeleporter = act.target--绑定传送塔
					act.invobject:AddTag("canbacktotower")
					MedalSay(act.doer,STRINGS.DELIVERYSPEECH.SUCCESS)
				end
				return true
			end
		end,
		state = "domediumaction",
	},
	{
		id = "FEEDGLOMMER",--给格罗姆喂食
		str = STRINGS.MEDAL_NEWACTION.MEDALEATFOOD,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="bananapop_spice_mandrake_jam" and act.target.prefab=="glommer" then
				if not act.target.is_diarrhea then
					act.target.is_diarrhea=true--标记为腹泻状态
					if act.target.sg then
						act.target.sg:GoToState("bored")
					end
					removeItem(act.invobject)
					MedalSay(act.doer,STRINGS.FEEDGLOMMER_SPEECH.SUCCESS)
				else
					MedalSay(act.doer,STRINGS.FEEDGLOMMER_SPEECH.ENOUGH)
				end
				return true
			end
		end,
		state = "give",
		actiondata = {
			mount_valid=true,
			priority=10,
		},
	},
	{
		id = "MEDALREPAIR",--填充修复耐久(fuel组件)
		str = STRINGS.MEDAL_NEWACTION.MEDALREPAIR,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and act.target.medal_repair_loot and act.invobject ~= nil and act.target.medal_repair_loot[act.invobject.prefab]~=nil then
				if act.target.components.fueled and act.target.components.fueled:GetPercent()<1 then
					local currentfuel=act.target.components.fueled.currentfuel--当前耐久
					local maxfuel=act.target.components.fueled.maxfuel--耐久上限
					local addfuel=act.target.medal_repair_loot[act.invobject.prefab]--单个材料可增加的耐久
					local neednum=math.max(math.floor((maxfuel-currentfuel)/addfuel),1)--需要消耗的材料数量
					local fuelnum = act.invobject.components.stackable and act.invobject.components.stackable.stacksize or 1--材料数量
					-- print(currentfuel,maxfuel,addfuel,neednum,fuelnum)
					--消耗材料变更耐久
					if fuelnum>neednum then
						act.invobject.components.stackable:SetStackSize(fuelnum-neednum)
						act.target.components.fueled:DoDelta(neednum*addfuel)
					else
						act.target.components.fueled:DoDelta(fuelnum*addfuel)
						act.invobject:Remove()
					end
					act.target:PushEvent("medal_repair")
					return true
				end
			end
		end,
		state = "give",
		actiondata = {
			mount_valid=true,
		},
	},
	{
		id = "MEDALBEEBOXREGEN",--给育王蜂箱补充育王蜂
		str = STRINGS.MEDAL_NEWACTION.MEDALBEEBOXREGEN,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="medal_bee_larva" and act.target.prefab=="medal_beebox" then
				if act.target.components.childspawner then
					if not act.target.components.childspawner:IsFull() then
						act.target.components.childspawner:AddChildrenInside(1)
						removeItem(act.invobject)
						MedalSay(act.doer,STRINGS.MEDAL_BEEBOX_SPEECH.NEW)
						return true
					else--装满了
						MedalSay(act.doer,STRINGS.MEDAL_BEEBOX_SPEECH.FULL)
					end
				end
			end
		end,
		state = "give",
	},
	{
		id = "MEDALPOLLUTE",--污染血糖
		str = STRINGS.MEDAL_NEWACTION.MEDALPOLLUTE,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("seasoningchef") and act.invobject ~= nil and act.invobject.prefab=="spice_blood_sugar" and act.target.prefab=="rage_krampus_soul" then
				local newspice=SpawnPrefab("spice_rage_blood_sugar")
				if newspice then
					act.doer.components.inventory:GiveItem(newspice)
					removeItem(act.invobject)
					return true
				end
			end
		end,
		state = "medal_dolongestaction",
		canqueuer = "allclick",--兼容排队论
		actiondata = {
			mount_valid=true,
		},
	},
	{
		id = "MEDALMARKPOS",--时空勋章标记坐标点
		str = STRINGS.MEDAL_NEWACTION.MEDALMARKPOS,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and (act.invobject.prefab=="medal_time_slider" or act.invobject.prefab=="medal_spacetime_lingshi") and act.target.prefab=="space_time_certificate" then
				local x,y,z=act.doer.Transform:GetWorldPosition()
				if not TheWorld.Map:IsAboveGroundAtPoint(x, y, z, false) then
					MedalSay(act.doer,STRINGS.DELIVERYSPEECH.ERRORPOS)
					return true
				end
				if act.target.components.medal_delivery then
					if act.target.components.writeable then
						if act.target.components.writeable:IsBeingWritten() then
							return false, "INUSE"
						end
						act.target.islingshi = act.invobject.prefab == "medal_spacetime_lingshi"--是否是灵石
						act.target.components.writeable:BeginWriting(act.doer)
					end
					removeItem(act.invobject)
					return true
				end
			end
		end,
		state = "give",
		actiondata = {
			mount_valid=true,
		},
	},
	{
		id = "MEDALGIVEFIREFLIES",--给藏宝点加萤火虫
		str = STRINGS.MEDAL_NEWACTION.MEDALGIVEFIREFLIES,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="fireflies" and act.target.prefab=="medal_treasure" then
				if act.target.addFireflies and not act.target.ischild then
					act.target:addFireflies()
					removeItem(act.invobject)
					MedalSay(act.doer,STRINGS.EXCHANGEGIFT_SPEECH.ADDFIREFLIES)
				else
					MedalSay(act.doer,STRINGS.EXCHANGEGIFT_SPEECH.ADDFIREFLIESFAIL)
				end
				return true
			end
		end,
		state = "give",
	},
	{
		id = "MEDALCHANGEDESTINY",--改命
		str = STRINGS.MEDAL_NEWACTION.MEDALCHANGEDESTINY,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="medal_spacetime_potion" and act.target:HasTag("fate_rewriteable") then
				SpawnPrefab("medal_spacetime_puff_small").Transform:SetPosition(act.target.Transform:GetWorldPosition())
				local randomnum = math.random()
				--一切都是宿命啊
				if act.doer.components.medal_destiny then
					randomnum = act.doer.components.medal_destiny:GetDestiny() or randomnum
				end
				act.target.medal_destiny_num = randomnum
				removeItem(act.invobject)
				MedalSay(act.doer,STRINGS.CHANGEDESTINYSPEECH.SUCCESS)
				return true
			end
		end,
		state = "give",
		actiondata = {
			mount_valid=true,
		},
	},
	{
		id = "MEDALRECHARGE",--充值
		str = STRINGS.MEDAL_NEWACTION.MEDALRECHARGE,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="toil_money" and act.target.prefab=="medal_skin_staff" then
				return addUseFn(act.invobject,act.target,TUNING_MEDAL.MEDAL_SKIN_STAFF_ADDUSE)
			end
		end,
		state = "give",
		actiondata = {
			mount_valid=true,
		},
	},
	{
		id = "GIVEROOTCHESTSPACEPOS",--给树根宝箱添加时空锚点
		str = STRINGS.MEDAL_NEWACTION.MEDALMARKPOS,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="medal_time_slider" and act.target:HasTag("addspaceposable") then
				if act.target.AddSpacePos and act.target:AddSpacePos() then
					removeItem(act.invobject)
					if act.target.components.writeable then
						if not act.target.components.writeable:IsBeingWritten() then
							act.target.components.writeable:BeginWriting(act.doer)
						end
					end
					return true
				end
			end
		end,
		state = "give",
		actiondata = {
			priority=10,
		},
	},
	{
		id = "GIVEITEMTOSPACESTAFF",--把东西放到时空法杖上传送
		str = STRINGS.MEDAL_NEWACTION.GIVEITEMTOSPACESTAFF,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject:HasTag("_inventoryitem") and act.target.prefab=="medal_space_staff" then
				if act.target.spacevalue and act.target.spacevalue>0 then
					if act.target.space_target and act.target.space_target:IsValid() and act.target.space_target.components.container then
						--这里用掉落来移除手上的东西，防止出现贴图消失的问题，看似离谱但是有效！
						local item=act.doer.components.inventory:DropItem(act.invobject,true)
						if item then
							act.target.space_target.components.container:GiveItem(item)
							act.target.spacevalue=act.target.spacevalue-1--消耗空间之力
						end
					else--目标已失效
						if act.target.changeTarget then
							act.target:changeTarget(nil)--清除绑定目标
						end
						MedalSay(act.doer,STRINGS.DELIVERYSPEECH.CANTFINDTARGET)
					end
				else--空间之力不足
					MedalSay(act.doer,STRINGS.DELIVERYSPEECH.NOCONSUME)
				end
				return true
			end
		end,
		state = "give",
		actiondata = {
			mount_valid=true,
		},
	},
	{
		id = "PACKINGSNACKS",--包装零食
		str = STRINGS.MEDAL_NEWACTION.PACKINGSNACKS,
		fn = function(act)
			if act.doer ~= nil and (act.invobject.prefab == "medal_spacetime_snacks_packet" and act.target.prefab == "medal_spacetime_lingshi") or 
				(act.target.prefab == "medal_spacetime_snacks_packet" and act.invobject.prefab == "medal_spacetime_lingshi") then
				local owner = act.target.components.inventoryitem and act.target.components.inventoryitem.owner or nil
				local container = nil--目标料理所在容器组件
				if owner then
					container = owner.components.inventory or owner.components.container
				end
				local packet = act.invobject.prefab == "medal_spacetime_snacks_packet" and act.invobject or act.target
				local lingshi = act.invobject.prefab == "medal_spacetime_snacks_packet" and act.target or act.invobject

				if lingshi and lingshi.components.stackable and lingshi.components.stackable.stacksize >= 5 then
					local newfood = SpawnPrefab("medal_spacetime_snacks")
					if newfood then
						if not (container and container:GiveItem(newfood)) then
							act.doer.components.inventory:GiveItem(newfood)
						end
						removeItem(packet)
						removeItem(lingshi,5)
					end
				else--材料不够
					MedalSay(act.doer,STRINGS.PACKINGSNACKSSPEECH.NOTENOUGH)
				end
				return true
			end
		end,
		state = "domediumaction",
		canqueuer = "allclick",--兼容排队论
		actiondata = {
			mount_valid=true,
		},
	},
	{
		id = "DOPROPHESY",--预测未来
		str = STRINGS.MEDAL_NEWACTION.DOPROPHESY,
		fn = function(act)
			if act.doer ~= nil and act.invobject.prefab == "medal_spacetime_crystalball" and act.target:HasTag("medal_predictable") then
				if not (act.invobject.DoProphesy and act.invobject:DoProphesy(act.doer,act.target)) then
					--失灵了
					MedalSay(act.doer,STRINGS.PROPHESYSPEECH.NOTENOUGH)
				end
				return true
			end
		end,
		state = "domediumaction",
		actiondata = {
			mount_valid=true,
		},
	},
	{
		id = "PLACEMEDALCHUM",--投放特制鱼食
		str = STRINGS.MEDAL_NEWACTION.PLACECHUM,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and act.invobject ~= nil and act.invobject.prefab=="medal_chum" and act.target:HasTag("fishable") then
				local fishable = act.target.components.fishable
				if fishable then
					if fishable:GetFishPercent() < 1 then
						local fishnum = act.target.prefab=="lava_pond" and 5 or 10
						fishable.fishleft = math.clamp(fishable.fishleft + fishnum,0,fishable.maxfish)
						--鱼满了则清空再生计时器
						if fishable:GetFishPercent() >= 1 and fishable.respawntask then
							fishable.respawntask:Cancel()
							fishable.respawntask=nil
						end
						removeItem(act.invobject)
						MedalSay(act.doer,STRINGS.PLACECHUMSPEECH.SUCCESS)
						return true
					else--鱼是满的
						MedalSay(act.doer,STRINGS.PLACECHUMSPEECH.FULL)
						return true
					end
				end
			end
		end,
		state = "give",
	},
	{
		id = "REMOVEROOTCHESTSPACEPOS",--移除树根宝箱时空锚点
		str = STRINGS.MEDAL_NEWACTION.WASHFUNCTIONAL,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="bottled_moonlight" and act.target.prefab=="medal_livingroot_chest" and not act.target:HasTag("addspaceposable") then
				if act.target.RemoveSpacePos and act.target:RemoveSpacePos() then
					removeItem(act.invobject)
					return true
				end
			end
		end,
		state = "give",
		actiondata = {
			priority=10,
		},
	},
	{
		id = "MEDALUSESKINCOUPON",--使用皮肤券
		str = STRINGS.MEDAL_NEWACTION.MEDALUSESKINCOUPON,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="medal_skin_coupon" and act.target.prefab=="medal_skin_staff" then
				if act.target.buy_skin and act.invobject.skin_name and act.invobject.skin_id then
					--兑换成功就正常消耗皮肤券
					if act.target:buy_skin(act.invobject.skin_name,act.invobject.skin_id,0) then
						removeItem(act.invobject)
						MedalSay(act.doer,STRINGS.MEDALSKINSTAFFSPEECH.EXCHANGE)
						return true
					else--兑换失败则填充耐久
						MedalSay(act.doer,STRINGS.MEDALSKINSTAFFSPEECH.ALREADY)
						return addUseFn(act.invobject,act.target,TUNING_MEDAL.MEDAL_SKIN_STAFF_ADDUSE_COUPON)
					end
				end
				
			end
		end,
		state = "give",
		actiondata = {
			mount_valid=true,
		},
	},
	{
		id = "MEDALDELIVERYTREASURE",--时空符文快速寻踪
		str = STRINGS.MEDAL_NEWACTION.BACKTOMEDALTOWER,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="medal_spacetime_runes" and act.invobject.quickdelivery and act.invobject.quickdelivery[act.target.prefab] then
				--根据藏宝图找藏宝点
				if act.target.getTreasurePoint then
					local treasure_data = act.target:getTreasurePoint()--获取藏宝点信息
					if treasure_data and act.doer.sg then
						removeItem(act.invobject)
						act.doer.sg:GoToState("pocketwatch_warpback",{warpback={dest_worldid = treasure_data.worldid, dest_x = treasure_data.x, dest_y = 0, dest_z = treasure_data.z}})
						if treasure_data.worldid == TheShard:GetShardId() then--在一个世界的话就感叹一下，跨世界就免了
							MedalSay(act.doer,STRINGS.DELIVERYSPEECH.FOUND)
						end
					end
				else--其他
					local next = c_findnext(act.invobject.quickdelivery[act.target.prefab])
					if next ~= nil and next.Transform ~= nil and act.doer.sg then
						local x,y,z = next.Transform:GetWorldPosition()
						removeItem(act.invobject)
						act.doer.sg:GoToState("pocketwatch_warpback",{warpback={dest_x = x, dest_y = 0, dest_z = z}})
						MedalSay(act.doer,STRINGS.DELIVERYSPEECH.FOUND)
					else
						MedalSay(act.doer,STRINGS.DELIVERYSPEECH.CANTFINDTARGET)
					end
				end
				return true
			end
		end,
		state = "give",
	},
	----------------------------SCENE点击物品----------------------------
	{
		id = "TOUCHMEDALTOWER", --摸塔
		str = STRINGS.MEDAL_NEWACTION.TOUCHMEDALTOWER,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("space_medal") and act.target ~= nil and act.target:HasTag("medal_delivery") then
				local medal = act.doer.components.inventory and act.doer.components.inventory:EquipMedalWithTag("candelivery")
				if medal then
					if act.target.components.medal_delivery then
						act.target.components.medal_delivery:OpenScreen(act.doer)
					end
				else
					MedalSay(act.doer,STRINGS.DELIVERYSPEECH.FALSEMEDAL)
				end
				return true
			end
		end,
		state = "give",
		actiondata = {
			distance=2.1,
			priority=10,--99999,
		},
	},
	{
		id = "MEDALDISMANTLE", --拆除坎普斯宝匣
		str = STRINGS.MEDAL_NEWACTION.MEDALDISMANTLE,
		fn = function(act)
			if act.doer ~= nil and act.target ~= nil and act.target.prefab=="medal_krampus_chest" then
				if act.target.dismantle then
					act.target.dismantle(act.target,act.doer)
				end
				return true
			end
		end,
		state = "domediumaction",
	},
	{
		id = "MEDALSTROKE", --抚摸虫木花
		str = STRINGS.MEDAL_NEWACTION.STROKEMEDAL,
		fn = function(act)
			if act.doer ~= nil and act.target ~= nil and act.target.prefab=="medal_wormwood_flower" then
				if act.target.strokeFn then
					act.target:strokeFn(act.doer)
					return true
				end
			end
		end,
		state = "doshortaction",
	},
	----------------------------EQUIPPED装备物品激活----------------------------
	{
		id = "MEDALPOURWATER", --加水
		str = STRINGS.MEDAL_NEWACTION.MEDALPOURWATER,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject:HasTag("wateringcan") and act.target ~= nil and act.target:HasTag("canpourwater") then
				if act.invobject.components.finiteuses ~= nil then
					if act.invobject.components.finiteuses:GetUses() <= 0 then
						return false, (act.invobject:HasTag("wateringcan") and "OUT_OF_WATER" or nil)
					else
						act.invobject.components.finiteuses:Use()
					end
				end
				if act.target.prefab=="medal_waterpump" then
					if not act.target.candrewwater then
						act.target.candrewwater=true
						act.target.AnimState:PlayAnimation("use_pst")
					end
				elseif act.target.prefab=="medal_ice_machine" then
					if act.target.AddWater then
						act.target:AddWater(2)
					end
				end
				return true
			end
		end,
		state = "pour",
		actiondata = {
			distance=1.5,
		},
	},
	{
		id = "MEDALSTAFFDEVOUR", --法杖快速左键施法
		str = STRINGS.MEDAL_NEWACTION.MEDALSTAFFDEVOUR,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject:HasTag("medalquickcastleft") and act.target ~= nil then
				local staff = act.invobject or act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
				local act_pos = act:GetActionPoint()
				if staff and staff.components.spellcaster and staff.components.spellcaster:CanCast(act.doer, act.target, act_pos) then
					-- staff.components.spellcaster:CastSpell(act.target, act_pos)
					if staff.components.spellcaster.spell~=nil then
						staff.components.spellcaster.spell(staff,act.target, act_pos, act.doer, true)
					end
					return true
				end
			end
		end,
		state = "quickcastspell",
		actiondata = {
			distance=20,
		},
	},
	{
		id = "MEDALSPECIALHAMMER",--月光锤锤特殊的东西
		str = STRINGS.MEDAL_NEWACTION.MEDALHAMMER,
		fn = function(act)
			-- DoToolWork(act, ACTIONS.MEDALHAMMER)
			--原本破坏了能拿到什么东西，这里也不能落下
			if act.target.components.workable ~= nil and
				act.target.components.workable:CanBeWorked() then
				act.target.components.workable:WorkedBy(act.doer,10)
			end
			--产生额外掉落
			local loot = act.invobject.special_hammer_loot and act.invobject.special_hammer_loot[act.target.prefab]
			if act.target.components.lootdropper and loot then
				if #loot > 0 then
					for i, v in ipairs(loot) do
						act.target.components.lootdropper:SpawnLootPrefab(v)
					end
				else
					act.target.components.lootdropper:DropLoot()
				end
			end
			--消耗耐久
			if act.invobject.components.finiteuses ~= nil then
				act.invobject.components.finiteuses:Use()
			end
			act.target:Remove()
			return true
		end,
		state=function(inst)
			return not inst.sg:HasStateTag("prehammer")
                and (inst.sg:HasStateTag("hammering") and
                    "hammer" or
                    "hammer_start")
                or nil
		end,
		actiondata = {
			rmb=true,
		},
		canqueuer = "rightclick",--兼容排队论
	},
}

--动作与组件绑定
local component_actions = {
	{
		type = "INVENTORY",
		component = "inventoryitem",
		tests = {
			{
				action = "WEARMEDAL",--佩戴勋章
				testfn = function(inst,doer,actions,right)
					--如果玩家有库存组件
					if doer.replica.inventory ~= nil then
						local medal_item = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY)--获取玩家勋章栏道具
						--如果勋章栏有勋章，并且勋章有容器，并且容器是由玩家打开的
						if medal_item ~= nil and medal_item:HasTag("multivariate_certificate") and medal_item.replica.container ~= nil and medal_item.replica.container:IsOpenedBy(doer) then
							--如果这个容器可以装勋章
							if medal_item.replica.container:CanTakeItemInSlot(inst) then
								return true
							end
							--如果融合勋章和需要放入的勋章有同样勋章组的标签
							if inst.grouptag~=nil and medal_item:HasTag(inst.grouptag) then
								return true
							end
						end
					end
					return false
				end,
			},
			{
				action = "TAKEOFFMEDAL",--摘下勋章
				testfn = function(inst,doer,actions,right)
					local equipped = (inst ~= nil and doer.replica.inventory ~= nil) and doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY) or nil
					if equipped ~= nil and equipped:HasTag("multivariate_certificate") and equipped.replica.container ~= nil and equipped.replica.container:IsHolding(inst) then
						return true
					end
					return false
				end,
			},
			{
				action = "RELEASEMEDALSOUL",--释放勋章灵魂
				testfn = function(inst,doer,actions,right)
					return doer:HasTag("medal_blinker") and inst.prefab == "devour_soul_certificate" and not inst:HasTag("usesdepleted")
				end,
			},
			{
				action = "BACKTOMEDALTOWER",--回城
				testfn = function(inst,doer,actions,right)
					return doer:HasTag("space_medal") and inst:HasTag("canbacktotower")
				end,
			},
			{
				action = "MEDALCOOKBOOK",--阅读食谱书
				testfn = function(inst,doer,actions,right)
					return doer:HasTag("player") and inst:HasTag("medal_cookbook")
				end,
			},
			{
				action = "RELEASEBEEKINGPOWER",--切换蜂王勋章攻击模式
				testfn = function(inst,doer,actions,right)
					return doer:HasTag("is_bee_king") and inst.prefab == "bee_king_certificate" and not inst:HasTag("usesdepleted")
				end,
			},
			{
				action = "TOUCHSPACEMEDAL",--摸时空勋章
				testfn = function(inst,doer,actions,right)
					return inst:HasTag("medal_delivery") and inst:HasTag("candelivery")
				end,
			},
			{
				action = "STROKEMEDAL",--摸虫木勋章、植物勋章
				testfn = function(inst,doer,actions,right)
					return inst:HasTag("canstrokemedal")
				end,
			},
			{
				action = "ADDJUSTICE",--快速补充正义值
				testfn = function(inst,doer,actions,right)
					-- return doer and doer:HasTag("addjustice") and inst:HasTag("addjustice")
					return doer and doer:HasTag("addjustice") and inst.prefab=="medal_monster_essence"
				end,
			},
			{
				action = "TOUCHSPACESTAFF",--摸时空法杖
				testfn = function(inst,doer,actions,right)
					return doer and inst:HasTag("medal_delivery") and inst:HasTag("changespacetarget")
				end,
			},
			{
				action = "TOUCHSKINSTAFF",--摸皮肤法杖
				testfn = function(inst,doer,actions,right)
					return doer and inst.prefab=="medal_skin_staff" and inst:HasTag("openskinpage")
				end,
			},
			{
				action = "TOUCHSPACETIMERUNES",--摸时空符文
				testfn = function(inst,doer,actions,right)
					return inst.prefab=="medal_spacetime_runes" and inst:HasTag("medal_delivery") and inst:HasTag("INLIMBO")
				end,
			},
			{
				action = "UNWRAPSNACKS",--拆开时空零食
				testfn = function(inst,doer,actions,right)
					return inst.prefab=="medal_spacetime_snacks"
				end,
			},
			{
				action = "TOUCHWISDOMTEST",--摸蒙昧勋章
				testfn = function(inst,doer,actions,right)
					return doer and inst.prefab=="wisdom_test_certificate" and inst:HasTag("examable")
				end,
			},
			{
				action = "CALLTRIBUTEBOX",--召唤奉纳盒
				testfn = function(inst,doer,actions,right)
					return doer:HasTag("player") and inst.prefab=="medal_tribute_symbol"
				end,
			},
			{
				action = "UNWRAPGIFTFRUIT",--拆开包果
				testfn = function(inst,doer,actions,right)
					return inst.prefab=="medal_gift_fruit"
				end,
			},
		},
	},
	{
		type = "USEITEM",
		component = "inventoryitem",
		tests = {
			{
				action = "GIVEIMMORTAL",--赋予不朽之力
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab == "immortal_gem" and target:HasTag("canbeimmortal") and not target:HasTag("keepfresh")
				end,
			},
			{
				action = "GIVESPACEGEM",--赋予空间之力
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab == "medal_space_gem" and (target.prefab=="krampus_sack" or target:HasTag("cangivespacegem"))
				end,
			},
			{
				action = "CHEFFLAVOUR",--调味
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("seasoningchef") and inst:HasTag("spice") and target:HasTag("preparedfood") and not target:HasTag("spicedfood")
				end,
			},
			{
				action = "POWERPRINT",--能力印刻
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and ((inst:HasTag("copyfunctional") and target.prefab=="blank_certificate") or (inst.prefab=="blank_certificate" and target:HasTag("copyfunctional")))
				end,
			},
			{
				action = "POWERABSORB",--能力吸收
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst:HasTag("blank_certificate") and (target.prefab=="statueglommer" or target:HasTag("powerabsorbable"))
				end,
			},
			{
				action = "MEDALUPGRADE",--勋章升级
				testfn = function(inst, doer, target, actions, right)
					return inst:HasTag("upgradablemedal") and target:HasTag("upgradablemedal")
				end,
			},
			{
				action = "REPAIRCOMMON",--通用补充耐久(finiteuses组件)
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and target.medal_repair_common and target.medal_repair_common[inst.prefab]~=nil
				end,
			},
			{
				action = "REPAIRDEVOURSTAFF",--补充吞噬法杖、时空法杖能量
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and target:HasTag("medal_eatfood") and inst:HasTag("preparedfood")
				end,
			},
			{
				action = "MAKECOOLDOWN",--强制冷却
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("expertchef") and inst:HasTag("cooldownable") and ((target:HasTag("blueflame") and target:HasTag("fire")) or target.prefab=="staffcoldlight")
				end,
			},
			{
				action = "BOTTLESSOUL",--灵魂装瓶
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="messagebottleempty" and target.prefab=="krampus_soul"
				end,
			},
			{
				action = "PLACECHUM",--投放鱼食
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="barnacle" and target.prefab=="medal_seapond"
				end,
			},
			{
				action = "DOINGOLD",--增加勋章熟练度
				testfn = function(inst, doer, target, actions, right)
					return target.medal_addexp_loot and target.medal_addexp_loot[inst.prefab]~=nil
				end,
			},
			{
				action = "ROOTCHESTLEVELUP",--施肥(树根宝箱、虫木勋章)
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and (inst.prefab=="compostwrap" or inst.prefab=="spice_poop") and target:HasTag("needfertilize")
				end,
			},
			{
				action = "GIVEROOTCHESTLIFE",--树根宝箱复苏
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("has_plant_medal") and inst.prefab=="reviver" and target.prefab=="medal_livingroot_chest" and target:HasTag("notalive")
				end,
			},
			{
				action = "FISHMOONINWATER",--水中捞月
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("groggy") and TheWorld.state.isfullmoon and doer.replica.sanity:IsLunacyMode() and inst.prefab=="messagebottleempty" and target:HasTag("cansalvage")
				end,
			},
			{
				action = "WASHFUNCTIONAL",--能力清洗
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="bottled_moonlight" and target:HasTag("washfunctionalable")
				end,
			},
			{
				action = "MAKEMUSHTREE",--变成蘑菇树
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("has_transplant_medal") and (TheWorld.state.isfullmoon or doer:HasTag("inmoonlight")) and (inst:HasTag("spore") or inst:HasTag("medal_spore")) and target:HasTag("stump") and  (target.prefab=="livingtree" or target.prefab=="livingtree_halloween")
				end,
			},
			{
				action = "MODIFYTOWERTEXT",--修改传送塔文字
				testfn = function(inst, doer, target, actions, right)
					return right and doer:HasTag("player") and inst.prefab=="featherpencil"  and (target.prefab=="townportal" or target.prefab=="medal_livingroot_chest")
				end,
			},
			{
				action = "REPAIRDELIVERYPOWER",--补充空间之力
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="townportaltalisman" and target.prefab=="medal_space_staff"
				end,
			},
			{
				action = "MAKEMANDARKPLANT",--曼德拉草种植
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("has_transplant_medal") and (TheWorld.state.isfullmoon or doer:HasTag("inmoonlight")) and (inst.prefab=="mandrake" or inst.prefab=="mandrake_seeds") and target.prefab=="mound" and not target:HasTag("DIG_workable")
				end,
			},
			{
				action = "GRAFTING_TREE",--嫁接
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("has_transplant_medal") and inst:HasTag("graftingscion") and target.prefab=="medal_fruit_tree_stump"
				end,
			},
			{
				action = "PUT_IN_THE_SEEDS",--塞入种子
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("has_transplant_medal") and inst:HasTag("deployedfarmplant") and target.prefab=="livinglog"
				end,
			},
			{
				action = "GREENGEMPLANT",--埋下绿宝石
				testfn = function(inst, doer, target, actions, right)
					return inst.prefab=="greengem" and target.prefab=="mound" and not target:HasTag("DIG_workable")
				end,
			},
			{
				action = "WORMWOODFLOWERPLANT",--种植虫木花
				testfn = function(inst, doer, target, actions, right)
					return TheWorld.state.isfullmoon and inst.prefab=="medal_ivy" and target.prefab=="medal_buried_greengem"
				end,
			},
			{
				action = "MEDALSPIKEFUSE",--活性触手尖刺融合
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("tentaclemedal") and inst.prefab=="medal_tentaclespike" and target.prefab=="medal_tentaclespike"
				end,
			},
			{
				action = "MEDALMAKEVARIATION",--使用变异药水
				testfn = function(inst, doer, target, actions, right)
					return inst.prefab=="medal_moonglass_potion" and not target:HasTag("DECOR")
				end,
			},
			{
				action = "MULTIVARIATEUPGRADE",--融合勋章升级
				testfn = function(inst, doer, target, actions, right)
					return getMultivariateTarget(inst,target,doer) ~= nil
				end,
			},
			{
				action = "MEDALPYTREDE",--py交易
				testfn = function(inst, doer, target, actions, right)
					return inst:HasTag("medal_tradeable") and target:HasTag("medal_trade")
				end,
			},
			{
				action = "MEDALREMOULD",--改造
				testfn = function(inst, doer, target, actions, right)
					return inst.prefab=="medal_waterpump_item" and target.prefab=="waterpump"
				end,
			},
			{
				action = "MEDALEADDPOWER",--增加女武神之力
				testfn = function(inst, doer, target, actions, right)
					return inst:HasTag("sketch") and target.prefab=="valkyrie_certificate"
				end,
			},
			{
				action = "REPAIRFARMPLOW",--打磨犁地机
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="flint" and target.prefab=="medal_farm_plow_item"
				end,
			},
			{
				action = "BINDINGTOWER",--空间勋章绑定传送塔
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="space_certificate" and target.prefab=="townportal"
				end,
			},
			{
				action = "FEEDGLOMMER",--给格罗姆喂食
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="bananapop_spice_mandrake_jam" and target.prefab=="glommer"
				end,
			},
			{
				action = "MEDALREPAIR",--填充修复耐久(fuel组件)
				testfn = function(inst, doer, target, actions, right)
					return target.medal_repair_loot and target.medal_repair_loot[inst.prefab]~=nil
				end,
			},
			{
				action = "MEDALBEEBOXREGEN",--给育王蜂箱补充育王蜂
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="medal_bee_larva" and target.prefab=="medal_beebox"
				end,
			},
			{
				action = "MEDALPOLLUTE",--污染血糖
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("seasoningchef") and inst.prefab=="spice_blood_sugar" and target.prefab=="rage_krampus_soul"
				end,
			},
			{
				action = "MEDALMARKPOS",--时空勋章标记坐标点
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and (inst.prefab=="medal_time_slider" or inst.prefab=="medal_spacetime_lingshi") and target.prefab=="space_time_certificate"
				end,
			},
			{
				action = "MEDALGIVEFIREFLIES",--给藏宝点加萤火虫
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="fireflies" and target.prefab=="medal_treasure"
				end,
			},
			{
				action = "MEDALCHANGEDESTINY",--改命
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="medal_spacetime_potion" and target:HasTag("fate_rewriteable")
				end,
			},
			{
				action = "MEDALRECHARGE",--充值
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="toil_money" and target.prefab=="medal_skin_staff"
				end,
			},
			{
				action = "GIVEROOTCHESTSPACEPOS",--给树根宝箱添加时空锚点
				testfn = function(inst, doer, target, actions, right)
					return right and doer:HasTag("player") and inst.prefab=="medal_time_slider" and target:HasTag("addspaceposable")
				end,
			},
			{
				action = "GIVEITEMTOSPACESTAFF",--把东西放到时空法杖上传送
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst:HasTag("_inventoryitem") and target.prefab=="medal_space_staff"
				end,
			},
			{
				action = "PACKINGSNACKS",--包装零食
				testfn = function(inst, doer, target, actions, right)
					return (inst.prefab == "medal_spacetime_snacks_packet" and target.prefab == "medal_spacetime_lingshi") or 
						(target.prefab == "medal_spacetime_snacks_packet" and inst.prefab == "medal_spacetime_lingshi")
				end,
			},
			{
				action = "DOPROPHESY",--预测未来
				testfn = function(inst, doer, target, actions, right)
					return inst.prefab == "medal_spacetime_crystalball" and target:HasTag("medal_predictable")
				end,
			},
			{
				action = "PLACEMEDALCHUM",--投放特制鱼食
				testfn = function(inst, doer, target, actions, right)
					return inst.prefab=="medal_chum" and target:HasTag("fishable")
				end,
			},
			{
				action = "REMOVEROOTCHESTSPACEPOS",--移除树根宝箱时空锚点
				testfn = function(inst, doer, target, actions, right)
					return right and inst.prefab=="bottled_moonlight" and target.prefab=="medal_livingroot_chest" and not target:HasTag("addspaceposable")
				end,
			},
			{
				action = "MEDALUSESKINCOUPON",--使用皮肤券
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="medal_skin_coupon" and target.prefab=="medal_skin_staff"
				end,
			},
			{
				action = "MEDALDELIVERYTREASURE",--传送到藏宝点
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="medal_spacetime_runes" and inst.quickdelivery and inst.quickdelivery[target.prefab]
				end,
			},
		},
	},
	{
		type = "SCENE",
		component = "workable",
		tests = {
			{
				action = "TOUCHMEDALTOWER",--摸塔
				testfn = function(inst,doer,actions,right)
					return right and doer:HasTag("player") and doer:HasTag("space_medal") and inst:HasTag("medal_delivery")
				end,
			},
			{
				action = "MEDALDISMANTLE",--拆除坎普斯宝匣
				testfn = function(inst,doer,actions,right)
					return right and doer:HasTag("player") and inst ~= nil and inst.prefab=="medal_krampus_chest"
				end,
			},
		},
	},
	{
		type = "SCENE",
		component = "pickable",
		tests = {
			{
				action = "MEDALSTROKE",--抚摸虫木花
				testfn = function(inst,doer,actions,right)
					return right and doer:HasTag("player") and inst ~= nil and inst.prefab=="medal_wormwood_flower"
				end,
			},
		},
	},
	{
		type = "SCENE",
		component = "inventoryitem",
		tests = {
			{
				action = "UNWRAPGIFTFRUIT",--拆开包果
				testfn = function(inst,doer,actions,right)
					return right and inst.prefab=="medal_gift_fruit"
				end,
			},
		},
	},
	{
		type = "EQUIPPED",
		component = "wateryprotection",
		tests = {
			{
				action = "MEDALPOURWATER",--加水
				testfn = function(inst, doer, target, actions, right)
					return right and doer:HasTag("player") and target:HasTag("canpourwater")
				end,
			},
		},
	},
	{
		type = "EQUIPPED",
		component = "spellcaster",
		tests = {
			{
				action = "MEDALSTAFFDEVOUR",--法杖快速左键施法
				testfn = function(inst, doer, target, actions, right)
					return not right and doer:HasTag("player") and inst:HasTag("medalquickcastleft") and not target:HasTag("_container")
				end,
			},
		},
	},
	{
		type = "EQUIPPED",
		component = "tool",
		tests = {
			{
				action = "MEDALSPECIALHAMMER",--月光玻璃锤锤特殊东西
				testfn = function(inst, doer, target, actions, right)
					return right and doer:HasTag("player") and (TheWorld.state.isfullmoon or doer:HasTag("inmoonlight")) and inst.prefab=="medal_moonglass_hammer" and inst.special_hammer_loot and inst.special_hammer_loot[target.prefab]~=nil
				end,
			},
		},
	},
}

local old_blink_fn=ACTIONS.BLINK.fn
local old_makeballoon_fn=ACTIONS.MAKEBALLOON.fn
local old_cook_fn=ACTIONS.COOK.fn
local old_fish_fn=ACTIONS.FISH.fn
local old_net_fn=ACTIONS.NET.fn

--修改老动作
local old_actions = {
	--采集
	{
		switch = true,--开关
		id = "PICK",
		state = {
			--动作劫持判断(判断是否需特殊处理执行新动作)
			testfn=function(inst, action)
				return inst:HasTag("fastpicker")
			end,
			--根据判断返回具体动作
			deststate=function(inst,action)
				return inst:HasTag("lureplant_rod") and "attack" or "doshortaction"
			end,
		},
	},
	--收获
	{
		switch = true,
		id = "HARVEST",
		state = {
			--动作劫持判断(判断是否需特殊处理执行新动作)
			testfn=function(inst, action)
				return inst:HasTag("fastpicker")
			end,
			--根据判断返回具体动作
			deststate=function(inst,action)
				return inst:HasTag("lureplant_rod") and "attack" or "doshortaction"
			end,
		},
	},
	--拿东西(从眼球草上拿东西)
	{
		switch = true,
		id = "TAKEITEM",
		state = {
			testfn=function(inst, action)
				return inst:HasTag("fastpicker") and action.target~=nil
			end,
			deststate=function(inst,action)
				return inst:HasTag("lureplant_rod") and "attack" or "doshortaction"
			end,
		},
	},
	--种田
	{
		switch = true,
		id = "PLANTSOIL",
		state = {
			testfn=function(inst, action)
				return inst:HasTag("plantkin") 
			end,
			deststate=function(inst,action)
				return "doshortaction"
			end,
		},
	},
	--施法
	{
		switch = true,
		id = "CASTSPELL",
		state = {
			testfn=function(inst, action)
				return action.invobject ~= nil and (
					(action.invobject:HasTag("medalquickcast") and action.target ~= nil) 
					or (action.invobject:HasTag("medalposquickcast") and action:GetActionPoint() ~= nil) 
					or (action.invobject.prefab=="medal_space_staff" and action.target == inst)
				)
			end,
			deststate=function(inst,action)
				return "quickcastspell"
			end,
		},
	},
	--谋杀
	{
		switch = true,
		id = "MURDER",
		state = {
			testfn=function(inst, action)
				--大厨快速杀一切；渔夫快速杀鱼
				return inst:HasTag("masterchef") or (inst:HasTag("fast_kill_fish") and action.invobject ~= nil and action.invobject:HasTag("fish"))
			end,
			deststate=function(inst,action)
				return "domediumaction"
			end,
		},
	},
	--拆包
	{
		switch = true,
		id = "UNWRAP",
		state = {
			testfn=function(inst, action)
				return inst:HasTag("has_handy_medal")--巧手勋章快速拆包
			end,
			deststate=function(inst,action)
				return "domediumaction"
			end,
		},
	},
	--吹气球
	--[[
	{
		switch = false,
		id = "MAKEBALLOON",
		actiondata = {
			fn = function(act)
				if act.doer ~= nil and
					act.doer:HasTag("has_silence_certificate") and
					act.invobject ~= nil and
					act.invobject.components.balloonmaker ~= nil and
					act.doer:HasTag("balloonomancer") then
					local balloon_type=1--气球类别，0普通，1沉默气球、2暗影气球
					local sanityLoss=3--精神消耗
					if act.doer.components.sanity ~= nil then
						--精神值低于精神消耗的时候，则制作暗影气球
						if act.doer.components.sanity.current < sanityLoss then
							balloon_type=2
						end
						act.doer.components.sanity:DoDelta(-sanityLoss)
					end
					--Spawn it to either side of doer's current facing with some variance
					local x, y, z = act.doer.Transform:GetWorldPosition()
					local angle = act.doer.Transform:GetRotation()
					local angle_offset = GetRandomMinMax(-10, 10)
					angle_offset = angle_offset + (angle_offset < 0 and -65 or 65)
					angle = (angle + angle_offset) * DEGREES
					act.invobject.components.balloonmaker:MakeMedalBalloon(
						x + .5 * math.cos(angle),
						0,
						z - .5 * math.sin(angle),
						balloon_type>1
					)
					return true
				end
				return old_makeballoon_fn(act)
			end,
		},
		state = {
			testfn=function(inst, action)
				return inst:HasTag("has_silence_certificate")
			end,
			deststate=function(inst,action)
				return inst.replica.sanity:IsCrazy() and "doshortaction" or "domediumaction"
			end,
		},
	},
	]]
	--灵魂跳跃
	{
		switch = true,
		id = "BLINK",
		actiondata = {
			strfn = function(act)
				return act.invobject == nil and act.doer ~= nil and (act.doer:HasTag("soulstealer") or act.doer:HasTag("temporaryblinker") or act.doer:HasTag("freeblinker") or act.doer:HasTag("medal_blinker")) and "SOUL" or nil
			end,
			fn = function(act)
				local act_pos = act:GetActionPoint()
				if act.invobject ~= nil then
					if act.invobject.components.blinkstaff ~= nil then
						return act.invobject.components.blinkstaff:Blink(act_pos, act.doer)
					end
				--临时穿梭者
				elseif act.doer ~= nil
					and act.doer:HasTag("temporaryblinker")
					and act.doer.sg ~= nil
					and act.doer.sg.currentstate.name == "portal_jumpin_pre"
					and act_pos ~= nil then
					act.doer:RemoveTag("temporaryblinker")
					act.doer.sg:GoToState("portal_jumpin", {dest = act_pos,})
					return true
				--自由穿梭者
				elseif act.doer ~= nil
					and act.doer:HasTag("freeblinker")
					and act.doer.sg ~= nil
					and act.doer.sg.currentstate.name == "portal_jumpin_pre"
					and act_pos ~= nil then
					act.doer.sg:GoToState("portal_jumpin", {dest = act_pos,})
					return true
				--勋章穿梭者
				elseif act.doer ~= nil
					and act.doer:HasTag("medal_blinker")
					and act.doer.sg ~= nil
					and act.doer.sg.currentstate.name == "portal_jumpin_pre"
					and act_pos ~= nil then
					act.doer.sg:GoToState("portal_jumpin", {dest = act_pos,})
					act.doer:PushEvent("medal_blink")
					return true
				end
				return old_blink_fn(act)
			end,
		},
		state = {
			testfn=function(inst, action)
				return action.invobject == nil and (inst:HasTag("temporaryblinker") or inst:HasTag("freeblinker") or inst:HasTag("medal_blinker"))
			end,
			deststate=function(inst,action)
				return "portal_jumpin_pre"
			end,
		},
	},
	--烹饪
	{
		switch = true,
		id = "COOK",
		actiondata = {
			fn = function(act)
				if act.doer and act.doer:HasTag("seasoningchef") and act.target.components.cooker then
					local stacksize=act.invobject.components.stackable and act.invobject.components.stackable:StackSize() or 1
					local cook_pos = act.target:GetPosition()
					local cooknum=0
					for i=1,stacksize do
						if act.target and act.target:IsValid() then
							local ingredient = act.doer.components.inventory:RemoveItem(act.invobject)
							ingredient.Transform:SetPosition(cook_pos:Get())

							if not act.target.components.cooker:CanCook(ingredient, act.doer) then
								act.doer.components.inventory:GiveItem(ingredient, nil, cook_pos)
							end

							if ingredient.components.health ~= nil and ingredient.components.combat ~= nil then
								act.doer:PushEvent("killed", { victim = ingredient })
							end

							local product = act.target.components.cooker:CookItem(ingredient, act.doer)
							if product ~= nil then
								act.doer.components.inventory:GiveItem(product, nil, cook_pos)
								cooknum=cooknum+1
							elseif ingredient:IsValid() then
								act.doer.components.inventory:GiveItem(ingredient, nil, cook_pos)
							end
						end
					end
					return cooknum>0
				end
				return old_cook_fn(act)
			end,
		},
	},
	--攻击(修改弹弓射击动作)
	{
		switch = true,
		id = "ATTACK",
		state = {
			testfn=function(inst, action)
				if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or (inst.components.health and inst.components.health:IsDead())) then
					local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil
					return inst:HasTag("senior_childishness") and weapon and weapon:HasTag("slingshot")
				end
			end,
			--客机动作劫持
			client_testfn=function(inst, action)
				if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or (inst.replica.health and inst.replica.health:IsDead()))  then
					local weapon = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
					return inst:HasTag("senior_childishness") and weapon and weapon:HasTag("slingshot")
				end
			end,
			deststate=function(inst,action)
				inst.sg.mem.localchainattack = not action.forced or nil
				return "medal_slingshot_shoot"
			end,
		},
	},
	--钓鱼
	{
		switch = true,
		id = "FISH",
		actiondata = {
			fn = function(act)
				if act.target.prefab=="lava_pond" and act.invobject.prefab~="medal_fishingrod" then
					return false
				end
				if old_fish_fn then
					return old_fish_fn(act)
				end
			end,
		},
		state = {
			testfn=function(inst, action)
				return action.target.prefab=="lava_pond"
			end,
			deststate=function(inst,action)
				--不是玻璃钓竿不让钓
				if not inst:HasTag("medal_fishingrod") then
					MedalSay(inst,STRINGS.FISHINGMEDALSPEECH.CANTFISH)
				end
				return inst:HasTag("medal_fishingrod") and "fishing_pre" or "idle"
			end,
		},
	},
	--捕虫网捕捉(提高效率还要自己hook，有点离谱)
	{
		switch = true,
		id = "NET",
		actiondata = {
			fn = function(act)
				if act.invobject.prefab=="medal_moonglass_bugnet" then
					if act.target ~= nil and not (act.target.components.health ~= nil and act.target.components.health:IsDead()) then
						DoToolWork(act, ACTIONS.NET)
						return true
					end
				end
				if old_net_fn then
					return old_net_fn(act)
				end
			end,
		},
	},
}

return {
	actions = actions,
	component_actions = component_actions,
	old_actions = old_actions,
}