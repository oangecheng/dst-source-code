---------------------------------------------------------------------------------------------------------
-------------------------------------------ICON、状态徽章------------------------------------------------
---------------------------------------------------------------------------------------------------------

--勋章说明页
if TUNING.HAS_MEDAL_PAGE_ICON then
	local medalPage = require("widgets/medalPage")
	AddClassPostConstruct("widgets/controls", function(self)
		self.medalPage = self:AddChild(medalPage())--说明页图标
	end)
	-- AddClassPostConstruct("widgets/statusdisplays", function(self)
end

--饱食下降箭头动画
local function hungerDownAnim(self)
	local oldOnUpdate=self.OnUpdate
	self.OnUpdate = function(dt)
		local anim = "neutral"
		local hungerrate = 1--饱食下降速度
		if self.owner and self.owner.medal_hungerrate then
			if self.owner.medal_hungerrate:value() then
				hungerrate = self.owner.medal_hungerrate:value()
			end
		end
		if hungerrate>1 then
			if hungerrate>=3 then--大箭头下降
				anim = "arrow_loop_decrease_most" 
			elseif hungerrate>=2 then
				anim = "arrow_loop_decrease_more" 
			elseif hungerrate>1 then
				anim = "arrow_loop_decrease"
			end
			if self.arrowdir ~= anim then
				self.arrowdir = anim
				self.hungerarrow:GetAnimState():PlayAnimation(anim, true)
			end
		elseif oldOnUpdate then
			oldOnUpdate(self)
		end
	end
end
AddClassPostConstruct( "widgets/hungerbadge", hungerDownAnim)

--特殊界面效果
AddClassPostConstruct("screens/playerhud",function(inst)
	local MedalInjured = require("widgets/medal_injured")--蜂毒伤害效果
	local Medal_SpacetimestormOver = require "widgets/medal_spacetimestormover"--时空风暴效果
	local Medal_SpacetimeDustOver = require "widgets/medal_spacetimedustover"
	local oldCreateOverlays =inst.CreateOverlays
	function inst:CreateOverlays(owner)
		oldCreateOverlays(self, owner)
		self.medal_injured = self.overlayroot:AddChild(MedalInjured(owner))
		self.medal_spacetimedustover = self.storm_overlays:AddChild(Medal_SpacetimeDustOver(owner))
		self.medal_spacetimestormover = self.overlayroot:AddChild(Medal_SpacetimestormOver(owner, self.medal_spacetimedustover))
	end
end)

--buff信息面板
AddClassPostConstruct("widgets/redux/craftingmenu_hud", function(self)
	local medalBuffPanel = require("widgets/medal_buff_panel")
	self.medalBuffPanel = self:AddChild(medalBuffPanel(self.owner))--buff信息面板
	local oldOpen=self.Open
	self.Open = function(self)
		oldOpen(self)
		self.medalBuffPanel:Hide()
	end

	local oldClose=self.Close
	self.Close = function(self)
		oldClose(self)
		self.medalBuffPanel:Show()
	end
end)

---------------------------------------------------------------------------------------------------------
-----------------------------------------------勋章栏----------------------------------------------------
---------------------------------------------------------------------------------------------------------
--加入勋章栏
if TUNING.ADD_MEDAL_EQUIPSLOTS then
	local Widget = require "widgets/widget"

	if GLOBAL.EQUIPSLOTS then
		GLOBAL.EQUIPSLOTS["MEDAL"]="medal"
	else
		GLOBAL.EQUIPSLOTS=
		{
			HANDS = "hands",
			HEAD = "head",
			BODY = "body",
			MEDAL = "medal",
		}
	end
	GLOBAL.EQUIPSLOT_IDS = {}
	local slot = 0--装备栏格子数量
	local noslot = {--屏蔽元素反应模组的额外装备栏，防止装备栏UI异常增长
		CIRCLET = true,	
		SANDS = true,
		GOBLET = true,
		FLOWER = true,
		PLUME = true,
	}
	for k, v in pairs(GLOBAL.EQUIPSLOTS) do
		slot = slot + (noslot[k] and 0 or 1)
		GLOBAL.EQUIPSLOT_IDS[v] = slot
	end

	local W = 68
	local SEP = 12
	local INTERSEP = 28
	AddClassPostConstruct("widgets/inventorybar",function(self, owner)
		--勋章栏
		self:AddEquipSlot(GLOBAL.EQUIPSLOTS.MEDAL, "images/medal_equipslots.xml", "medal_equipslots.tex")
		--融合勋章栏
		self.medal_inv=self.root:AddChild(Widget("medal_inv"))
		self.medal_inv:SetScale(1.5, 1.5)
		--调整人物检查按钮位置
		if self.inspectcontrol then
			local total_w, x = self:getTotalW()
			self.inspectcontrol.icon:SetPosition(-4, 6)
			self.inspectcontrol:SetPosition((total_w - W) * .5 + 3, -6, 0)
		end

		--获取total_w
		self.getTotalW = function(self)
			local inventory = self.owner.replica.inventory
			local num_slots = inventory:GetNumSlots()
			local num_equip = #self.equipslotinfo
			local num_buttons = self.controller_build and 0 or 1
			local num_slotintersep = math.ceil(num_slots / 5)
			local num_equipintersep = num_buttons > 0 and 1 or 0
			local total_w = (num_slots + num_equip + num_buttons) * W + (num_slots + num_equip + num_buttons - num_slotintersep - num_equipintersep - 1) * SEP + (num_slotintersep + num_equipintersep) * INTERSEP
			local x=(W - total_w) * .5 + num_slots * W + (num_slots - num_slotintersep) * SEP + num_slotintersep * INTERSEP
			return total_w,x
		end
		--更新融合勋章栏位置
		self.RefreshMedalInvPos = function(self)
			local total_w, x = self:getTotalW()
			local overflow = self.owner.replica.inventory and self.owner.replica.inventory:GetOverflowContainer()--获取玩家的背包
			--判断是否有背包并且出入融合模式,有的话位置要上移一点
			local medal_inv_y = overflow and overflow:IsOpenedBy(self.owner) and self.integrated_backpack and 80 or 40
			for k, v in ipairs(self.equipslotinfo) do
				if v.slot == EQUIPSLOTS.MEDAL then
					self.medal_inv:SetPosition(x, medal_inv_y, 0)
				end
				x = x + W + SEP
			end
		end
		--更新物品栏背景长度
		self.RefreshBgSize = function(self)
			self.bg:SetScale(1.3+(slot-4)*0.05,1,1.25)--根据格子数量缩放装备栏
			self.bgcover:SetScale(1.3+(slot-4)*0.05,1,1.25)
		end

		local oldRefresh = self.Refresh
		local oldRebuild = self.Rebuild

		self.Refresh = function(self)
			if oldRefresh then
				oldRefresh(self)
			end
			self:RefreshBgSize()
		end
		
		self.Rebuild = function(self)
			if oldRebuild then
				oldRebuild(self)
			end
			self:RefreshBgSize()
			self:RefreshMedalInvPos()
		end
	end)
end

---------------------------------------------------------------------------------------------------------
---------------------------------------------容器整理功能-------------------------------------------------
---------------------------------------------------------------------------------------------------------
--这边感谢B站小伙伴“@不肯吸水的偏铝酸钠”提供的排序代码优化,原本用的是table.sort排序并且没对道具类型做区分，会比较混乱
local function compareStr(str1, str2)
    if (str1 == str2) then
        return 0
    end
    if (str1 < str2) then
        return -1
    end
    if (str1 > str2) then
        return 1
    end
end
--是否是勋章
local function IsMedal(ent)
	return ent and ent:HasTag("medal")
end

--按字母排序
local function cmp(a, b)
    if a and b then
        --尝试按照 prefab 名字排序
        local prefab_a = tostring(a.prefab)
        local prefab_b = tostring(b.prefab)

        --勋章强制优先
        if IsMedal(a) and not IsMedal(b) then
            return -1
        end
        if IsMedal(b) and not IsMedal(a) then
            return 1
        end

        if IsMedal(a) and IsMedal(b) then
            local grouptag_a = a.grouptag
            local grouptag_b = b.grouptag

            if (grouptag_a and grouptag_b) then
                if(grouptag_a==grouptag_b)then
                    --同类勋章空白勋章后置
                    if(prefab_a=="blank_certificate" and prefab_b ~= "blank_certificate")then
                        return 1
                    end
                    if(prefab_a~="blank_certificate" and prefab_b == "blank_certificate")then
                        return -1
                    end
                end
                return compareStr(grouptag_a, grouptag_b)
            end
        end

        return compareStr(prefab_a, prefab_b)
    end
end
--插入法排序函数
local function insert_sort(list, comp)
    for i = 2, #list do
        local v = list[i]
        local j = i - 1
        while (j>0 and (comp(list[j], v) > 0)) do
            list[j+1]=list[j]
            j=j-1
        end
        list[j+1]=v
    end
end
--容器排序
local function slotsSort(inst)
    if inst and inst.components.container then
        --取出容器中的所有物品
        local items = {}
        for k, v in pairs(inst.components.container.slots) do
            local item = inst.components.container:RemoveItemBySlot(k)
            if (item) then
                table.insert(items, item)
            end
        end

        insert_sort(items, cmp)

        for i = 1, #items do
            inst.components.container:GiveItem(items[i])
        end
    end
end

-----------------------------------------------------------------------------------------
--整理按钮点击函数
local function slotsSortFn(inst, doer)
	if inst.components.container ~= nil then
		slotsSort(inst)
	elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
		SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
	end
end
--整理按钮亮起规则
local function slotsSortValidFn(inst)
	return inst.replica.container ~= nil and not inst.replica.container:IsEmpty()--容器不为空
end

---------------------------------------------------------------------------------------------------------
---------------------------------------------智能分配功能-------------------------------------------------
---------------------------------------------------------------------------------------------------------
--智能分配
local function autoDistribution(inst)
	if inst and inst.components.container then
		local container=inst.components.container
		local numslots=container:GetNumSlots()--容器格子数
		local item_loot={}--预置物统计表，子表格式:{prefab="xx",first=起始格子,end=终止格子,num=总数量}
		local item_with_num={}--最终效果对照表，子表格式:{prefab="xx",num=该格子拥有数量}
		local prefabname=nil
		
		for i=1,numslots do
			if container.slots[i] then
				--获取堆叠数量
				local stacksize = container.slots[i].components.stackable and container.slots[i].components.stackable:StackSize() or 1
				--预置物名不相等，则进行登记
				if container.slots[i].prefab~=prefabname then
					--上一条数据不为空，则添加终止标记
					if item_loot[#item_loot] then
						item_loot[#item_loot].last=i-1
					end
					prefabname=container.slots[i].prefab
					item_loot[#item_loot+1]={prefab=prefabname,first=i,num=stacksize}--登记
				--预置物名相等，数量相加
				elseif item_loot[#item_loot] then
					item_loot[#item_loot].num=item_loot[#item_loot].num+stacksize
				end
			end
			--最后一个格子自身就是last
			if i>=numslots then
				if item_loot[#item_loot] then
					item_loot[#item_loot].last=i
				end
			end
		end
		--无论如何都从第一个格子算起(这样玩家的自由度反而会降低)
		--[[
		if #item_loot>0 then
			item_loot[1].first=1
		end
		]]
		--根据预置物统计表对预置物进行再分配
		for _,v in ipairs(item_loot) do
			local slotnum=v.last-v.first+1--该预置物所占格子数
			local extra=v.num%slotnum--取余获得多余的种子，依次分发给格子
			for i=v.first,v.last do
				item_with_num[i]={prefab=v.prefab,num=math.floor(v.num/slotnum)+(extra>0 and 1 or 0)}
				extra=extra-1
			end
		end
		
		local all_items=container:RemoveAllItems()--把容器里的预置物都掏出来
		
		for _,v in ipairs(all_items) do
			for i=1,numslots do
				if item_with_num[i] and v.prefab==item_with_num[i].prefab and item_with_num[i].num>0 then
					local stacksize=v.components.stackable and v.components.stackable:StackSize() or 1
					if stacksize>1 and stacksize>item_with_num[i].num then
						local item = v.components.stackable:Get(item_with_num[i].num)
						if item then
							container:GiveItem(item,i)
							item_with_num[i].num=0
						end
					else
						container:GiveItem(v,i)
						item_with_num[i].num=item_with_num[i].num-stacksize
						break
					end
				end
			end
		end
	end
end

--一键分配按钮点击函数
local function autoDistributionFn(inst, doer)
	if inst.components.container ~= nil then
		autoDistribution(inst)
	elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
		SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
	end
end
--一键分配按钮亮起规则
local function autoDistributionValidFn(inst)
	return inst.replica.container ~= nil and not inst.replica.container:IsEmpty()--容器不为空
end

---------------------------------------------------------------------------------------------------------
-----------------------------------------------新容器----------------------------------------------------
---------------------------------------------------------------------------------------------------------

--容器默认坐标
local default_pos={
	bearger_chest = Vector3(0, 220, 0),--熊皮宝箱
	medal_toy_chest = Vector3(0, 220, 0),--玩具箱
	medal_childishness_chest = Vector3(0, 280, 0),--童心箱
	medal_krampus_chest = Vector3(0, 220, 0),--坎普斯之匣
	medal_krampus_chest_item = Vector3(-275, -50, 0),--坎普斯之匣
	medal_ice_machine = Vector3(200, 0, 0),--制冰机
	livingroot_chest1 = Vector3(0, 200, 0),--树根宝箱第1阶段
	livingroot_chest2 = Vector3(0, 200, 0),--树根宝箱第2阶段
	livingroot_chest3 = Vector3(0, 200, 0),--树根宝箱第3阶段
	livingroot_chest4 = Vector3(0, 200, 0),--树根宝箱第4阶段
	medal_box = Vector3(-140, -120, 0),--勋章盒2*6
	spices_box = Vector3(0, 220, 0),--调料盒2*6
	medal_ammo_box = Vector3(-275, -120, 0),--弹药盒2*6
	medal_farm_plow = Vector3(0, 200, 0),--高效耕地机
	medal_spacetime_chest = Vector3(0, 200, 0),--时空宝箱
	medal_resonator = Vector3(0, 160, 0),--宝藏探测仪
	medal_fishingrod = Vector3(0, 15, 0),--玻璃钓竿
	multivariate_certificate = TUNING.MEDAL_INV_SWITCH and Vector3(0, 60, 0) or Vector3(400, -280, 0),--融合勋章
	medium_multivariate_certificate = TUNING.MEDAL_INV_SWITCH and Vector3(0, 80, 0) or Vector3(400, -280, 0),--中级融合勋章
	large_multivariate_certificate = TUNING.MEDAL_INV_SWITCH and Vector3(0, 80, 0) or Vector3(400, -280, 0),--高级融合勋章
}
--熊皮宝箱
local params = {}
params.bearger_chest = {
	widget =
	{
		slotpos = {},
		animbank = "ui_chester_shadow_3x4",
		animbuild = "ui_chester_shadow_3x4",
		pos = default_pos.bearger_chest,
		side_align_tip = 160,
	},
	type = "chest",
}

for y = 2.5, -0.5, -1 do
	for x = 0, 2 do
		table.insert(params.bearger_chest.widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
	end
end

--玩具箱
params.medal_toy_chest = {
	widget =
	{
		slotpos = {},
		animbank = "ui_chester_shadow_3x4",
		animbuild = "ui_chester_shadow_3x4",
		pos = default_pos.medal_toy_chest,
		side_align_tip = 160,
	},
	acceptsstacks = false,
	type = "chest",
}

for y = 2.5, -0.5, -1 do
    for x = 0, 2 do
        table.insert(params.medal_toy_chest.widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
    end
end
--玩具黑名单(节日玩具不可入箱)
local toy_blacklist={}
if HALLOWEDNIGHTS_TINKET_START and HALLOWEDNIGHTS_TINKET_END then
	for i=HALLOWEDNIGHTS_TINKET_START,HALLOWEDNIGHTS_TINKET_END do
		table.insert(toy_blacklist,"trinket_"..i)
	end
end

function params.medal_toy_chest.itemtestfn(container, item, slot)
    return (item.prefab=="antliontrinket" or string.sub(item.prefab,1,8)=="trinket_") and not table.contains(toy_blacklist,item.prefab) and not container:Has(item.prefab,1)
end

--童心箱
params.medal_childishness_chest = {
	widget =
	{
		slotpos = {},
		animbank = "ui_tacklecontainer_3x5",
		animbuild = "ui_tacklecontainer_3x5",
		pos = default_pos.medal_childishness_chest,
		side_align_tip = 160,
		buttoninfo =
		{
			text = STRINGS.MEDAL_UI.EXCHANGEGIFT,
			position = Vector3(0, -280, 0),
		}
	},
	type = "chest",
}

for y = 1, -2, -1 do
    for x = 0, 2 do
        table.insert(params.medal_childishness_chest.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 45, 0))
    end
end

--点击按钮
function params.medal_childishness_chest.widget.buttoninfo.fn(inst, doer)
	if inst.components.container ~= nil then
		if inst.components.container:IsFull() then
			if inst.exchangeGift then
				inst.exchangeGift(inst,doer)
			end
		end
	elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
		SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
	end
end

function params.medal_childishness_chest.widget.buttoninfo.validfn(inst)
	return inst.replica.container ~= nil and inst.replica.container:IsFull()--容器必须被填满
end

--时空宝箱
params.medal_spacetime_chest = {
	widget =
	{
		slotpos = {},
		animbank = "ui_chest_3x3",
		animbuild = "ui_chest_3x3",
		pos = default_pos.medal_spacetime_chest,
		side_align_tip = 160,
		buttoninfo={
			text = STRINGS.MEDAL_UI.EXCHANGEGIFT,
			position = Vector3(0, -140, 0),
		}
	},
	type = "chest",
}

for y = 2, 0, -1 do
	for x = 0, 2 do
		table.insert(params.medal_spacetime_chest.widget.slotpos, Vector3(80 * (x - 2) + 80, 80 * (y - 2) + 80, 0))
	end
end

--点击按钮
function params.medal_spacetime_chest.widget.buttoninfo.fn(inst, doer)
	if inst.components.container ~= nil then
		if inst.components.container:IsFull() then
			if inst.exchangeGift then
				inst.exchangeGift(inst,doer)
			end
		end
	elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
		SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
	end
end

function params.medal_spacetime_chest.widget.buttoninfo.validfn(inst)
	return inst.replica.container ~= nil and inst.replica.container:IsFull()--容器必须被填满
end

--坎普斯宝匣白名单
local krampus_chest_white_list={
	"multivariate_certificate",--融合勋章
	"medium_multivariate_certificate",--中级融合勋章
	"large_multivariate_certificate",--高级融合勋章
	"medal_fishingrod",--玻璃钓竿
	"oceanfishingrod",--海钓竿
	"slingshot",--弹弓
	"medal_resonator_item",--宝藏探测仪
	"alterguardianhat",--启迪之冠
	"alterguardianhatshard",--启迪之冠碎片
}

--坎普斯宝匣
params.medal_krampus_chest = {
	widget =
	{
		slotpos = {},
		animbank = "ui_chester_shadow_3x4",
		animbuild = "ui_chester_shadow_3x4",
		pos = default_pos.medal_krampus_chest,
		side_align_tip = 160,
		dragtype="medal_krampus_chest",--拖拽标签，有则可拖拽
	},
	type = "medal_krampus_chest",
}
--3*4
for y = 2.5, -0.5, -1 do
	for x = 0, 2 do
		table.insert(params.medal_krampus_chest.widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
	end
end

function params.medal_krampus_chest.itemtestfn(container, item, slot)
    return table.contains(krampus_chest_white_list,item.prefab) or not (item:HasTag("irreplaceable") or item:HasTag("_container"))
end

params.medal_krampus_chest_item = {
	widget =
	{
		slotpos = {},
		-- animbank = "ui_chester_shadow_3x4",
		-- animbuild = "ui_chester_shadow_3x4",
		animbank = "ui_piggyback_2x6",
		animbuild = "ui_piggyback_2x6",
		pos = default_pos.medal_krampus_chest_item,
		-- side_align_tip = 160,
		dragtype="medal_krampus_chest_item",--拖拽标签，有则可拖拽
	},
	issidewidget = true,
	type = "medal_krampus_chest",
}
--2*6
for y = 0, 5 do
	table.insert(params.medal_krampus_chest_item.widget.slotpos, Vector3(-162, -75 * y + 170, 0))
	table.insert(params.medal_krampus_chest_item.widget.slotpos, Vector3(-162 + 75, -75 * y + 170, 0))
end

function params.medal_krampus_chest_item.itemtestfn(container, item, slot)
    return table.contains(krampus_chest_white_list,item.prefab) or not (item:HasTag("irreplaceable") or item:HasTag("_container"))
end

--蓝曜石制冰机
params.medal_ice_machine = {
	widget =
	{
		slotpos = {
			Vector3(-37.5, 32 + 4, 0),
			Vector3(37.5, 32 + 4, 0),
			Vector3(-37.5, -(32 + 4), 0),
			Vector3(37.5, -(32 + 4), 0),
		},
		animbank = "ui_chest_2x2",
		animbuild = "ui_chest_2x2",
		pos = default_pos.medal_ice_machine,
		side_align_tip = 160,
		-- dragtype="medal_ice_machine",--拖拽标签，有则可拖拽
	},
	type = "chest",
}
--只能放冰
function params.medal_ice_machine.itemtestfn(container, item, slot)
    return item:HasTag("frozen")
end

--树根宝箱第1阶段
params.livingroot_chest1 = {
	widget =
	{
		slotpos = {},
		animbank = "ui_chest_3x3",
		animbuild = "ui_chest_3x3",
		pos = default_pos.livingroot_chest1,
		side_align_tip = 160,
	},
	type = "chest",
}

for y = 2, 0, -1 do
	for x = 0, 2 do
		table.insert(params.livingroot_chest1.widget.slotpos, Vector3(80 * (x - 2) + 80, 80 * (y - 2) + 80, 0))
	end
end

--树根宝箱第2阶段
params.livingroot_chest2 = {
	widget =
	{
		slotpos = {},
		animbank = "ui_medalcontainer_4x4",
		animbuild = "ui_medalcontainer_4x4",
		pos = default_pos.livingroot_chest2,
		side_align_tip = 160,
		buttoninfo={
			text = STRINGS.MEDAL_UI.SLOTSSORT,
			position = Vector3(0, -190, 0),
			fn=slotsSortFn,
			validfn=slotsSortValidFn,
		}
	},
	type = "chest",
}

for y = 3, 0, -1 do
	for x = 0, 3 do
		table.insert(params.livingroot_chest2.widget.slotpos, Vector3(80 * (x - 2) + 40, 80 * (y - 2) + 40, 0))
	end
end

--树根宝箱第3阶段
params.livingroot_chest3 = {
	widget =
	{
		slotpos = {},
		animbank = "ui_medalcontainer_5x5",
		animbuild = "ui_medalcontainer_5x5",
		pos = default_pos.livingroot_chest3,
		side_align_tip = 160,
		buttoninfo={
			text = STRINGS.MEDAL_UI.SLOTSSORT,
			position = Vector3(0, -230, 0),
			fn=slotsSortFn,
			validfn=slotsSortValidFn,
		}
	},
	type = "chest",
}

for y = 4, 0, -1 do
	for x = 0, 4 do
		table.insert(params.livingroot_chest3.widget.slotpos, Vector3(80 * (x - 3) + 80, 80 * (y - 3) + 80, 0))
	end
end

--树根宝箱第4阶段
params.livingroot_chest4 = {
	widget =
	{
		slotpos = {},
		animbank = "ui_medalcontainer_5x10",
		animbuild = "ui_medalcontainer_5x10",
		pos = default_pos.livingroot_chest4,
		side_align_tip = 160,
		buttoninfo={
			text = STRINGS.MEDAL_UI.SLOTSSORT,
			position = Vector3(0, -230, 0),
			fn=slotsSortFn,
			validfn=slotsSortValidFn,
		}
	},
	type = "chest",
}

for y = 4, 0, -1 do
	for x = 0, 9 do
		local offsetX = x<=4 and -20 or 10
		table.insert(params.livingroot_chest4.widget.slotpos, Vector3(80 * (x - 5) + 40+offsetX, 80 * (y - 3) + 80, 0))
	end
end

--勋章盒
params.medal_box = {
	widget =
	{
		slotpos = {},
        animbank = "ui_krampusbag_2x8",
        animbuild = "ui_krampusbag_2x8",
		pos = default_pos.medal_box,
		-- side_align_tip = 160,
		dragtype="medal_box",--拖拽标签，有则可拖拽
	},
	issidewidget = true,
	type = "medal_box",
}

for y = 0, 6 do
	table.insert(params.medal_box.widget.slotpos, Vector3(-162, -75 * y + 240, 0))
	table.insert(params.medal_box.widget.slotpos, Vector3(-162 + 75, -75 * y + 240, 0))
end

function params.medal_box.itemtestfn(container, item, slot)
    return item:HasTag("medal")
end
params.medal_box.priorityfn = params.medal_box.itemtestfn
-- function params.medal_box.priorityfn(container, item, slot)
--     return item:HasTag("medal")
-- end
--调料盒
params.spices_box = {
	widget =
	{
		slotpos = {},
		animbank = "ui_chester_shadow_3x4",
		animbuild = "ui_chester_shadow_3x4",
		pos = default_pos.spices_box,
		side_align_tip = 160,
		-- dragtype="spices_box",--拖拽标签，有则可拖拽
	},
	-- issidewidget = true,
	type = "chest",
}

--3*4
for y = 2.5, -0.5, -1 do
	for x = 0, 2 do
		table.insert(params.spices_box.widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
	end
end

function params.spices_box.itemtestfn(container, item, slot)
    return item:HasTag("spice")
end

--弹药盒
params.medal_ammo_box = {
	widget =
	{
		slotpos = {},
		animbank = "ui_krampusbag_2x8",
        animbuild = "ui_krampusbag_2x8",
		pos = default_pos.medal_ammo_box,
		-- side_align_tip = 160,
		dragtype="medal_krampus_chest_item",--"medal_box",--拖拽标签，有则可拖拽
	},
	issidewidget = true,
	type = "medal_krampus_chest",--"medal_box",
}

for y = 0, 6 do
	table.insert(params.medal_ammo_box.widget.slotpos, Vector3(-162, -75 * y + 240, 0))
	table.insert(params.medal_ammo_box.widget.slotpos, Vector3(-162 + 75, -75 * y + 240, 0))
end

function params.medal_ammo_box.itemtestfn(container, item, slot)
    return item:HasTag("slingshotammo")
end

--高效耕地机
params.medal_farm_plow = {
	widget =
	{
		slotpos = {},
		animbank = "ui_chest_3x3",
		animbuild = "ui_chest_3x3",
		pos = default_pos.medal_farm_plow,
		side_align_tip = 160,
		buttoninfo={
			text = STRINGS.MEDAL_UI.DISTRIBUTION,
			position = Vector3(0, -140, 0),
			fn=autoDistributionFn,
			validfn=autoDistributionValidFn,
		}
	},
	type = "chest",
}

for y = 2, 0, -1 do
	for x = 0, 2 do
		table.insert(params.medal_farm_plow.widget.slotpos, Vector3(80 * (x - 2) + 80, 80 * (y - 2) + 80, 0))
	end
end

function params.medal_farm_plow.itemtestfn(container, item, slot)
    return item:HasTag("deployedfarmplant")
end

--宝藏探测仪
params.medal_resonator =
{
    widget =
    {
        slotpos = {
            Vector3(-2, 18, 0),
        },
		animbank = "ui_alterguardianhat_1x1",
		animbuild = "ui_medalcontainer_1x1",
		pos = default_pos.medal_resonator,
    },
    acceptsstacks = false,
    type = "chest",
}

function params.medal_resonator.itemtestfn(container, item, slot)
    return item:HasTag("medal_treasure_map")--只能放藏宝图
end
--玻璃钓竿
params.medal_fishingrod =
{
	widget =
	{
		slotpos =
		{
			Vector3(0,   32 + 4,  0),
		},
		slotbg =
		{
			{ image = "fishing_slot_lure.tex" },
		},
		animbank = "ui_cookpot_1x2",
		animbuild = "ui_cookpot_1x2",
		pos = default_pos.medal_fishingrod,
	},
	usespecificslotsforitems = true,
	type = "hand_inv",
}

function params.medal_fishingrod.itemtestfn(container, item, slot)
	return item:HasTag("oceanfishing_lure")
end


--融合勋章
params.multivariate_certificate = {
	widget =
	{
		slotpos =
        {
            Vector3(-(64 + 12), 0, 0), 
            Vector3(0, 0, 0),
            Vector3(64 + 12, 0, 0), 
        },
		slotbg =
        {
            { atlas="images/medal_equip_slot.xml",image = "medal_equip_slot.tex" },
            { atlas="images/medal_equip_slot.xml",image = "medal_equip_slot.tex" },
			{ atlas="images/medal_equip_slot.xml",image = "medal_equip_slot.tex" },
        },
		animbank = "ui_chest_3x1",
		animbuild = "ui_chest_3x1",
		pos = default_pos.multivariate_certificate,
		-- pos = Vector3(0, 60, 0),
		-- side_align_tip = 160,
		hanchor=0,--锚点，0中1左2右
		vanchor=2,--锚点，0中1上2下
		dragtype="multivariate_certificate",--拖拽标签，有则可拖拽
	},
	-- issidewidget = true,
	usespecificslotsforitems = true,--使用特定插槽
	type = "multivariate_certificate",
	excludefromcrafting = true,--里面的道具不能直接用于制作
	-- type = "hand_inv",
}

--检测可放入融合勋章的物品
function params.multivariate_certificate.itemtestfn(container, item, slot)
	--可放入融合勋章并且没有相同的勋章组标签
	return item:HasTag("addfunctional") and not (item.grouptag and container.inst:HasTag(item.grouptag))
end

--中级融合勋章
params.medium_multivariate_certificate = {
	widget =
	{
		slotpos = {
			Vector3(-37.5, 32 + 4, 0),
			Vector3(37.5, 32 + 4, 0),
			Vector3(-37.5, -(32 + 4), 0), 
			Vector3(37.5, -(32 + 4), 0),
		},
		slotbg = {
			{ atlas="images/medal_equip_slot.xml",image = "medal_equip_slot.tex" },
			{ atlas="images/medal_equip_slot.xml",image = "medal_equip_slot.tex" },
			{ atlas="images/medal_equip_slot.xml",image = "medal_equip_slot.tex" },
			{ atlas="images/medal_equip_slot.xml",image = "medal_equip_slot.tex" },
		},
		animbank = "ui_chest_2x2",
		animbuild = "ui_chest_2x2",
		pos = default_pos.medium_multivariate_certificate,
		hanchor=0,--锚点，0中1左2右
		vanchor=2,--锚点，0中1上2下
		dragtype="medium_multivariate_certificate",--拖拽标签，有则可拖拽
	},
	usespecificslotsforitems = true,--使用特定插槽
	type = "multivariate_certificate",
	excludefromcrafting = true,--里面的道具不能直接用于制作
}

-- for y = 1, 0, -1 do
--     for x = 0, 2 do
--         table.insert(params.medium_multivariate_certificate.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 120, 0))
--         table.insert(params.medium_multivariate_certificate.widget.slotbg, { atlas="images/medal_equip_slot.xml",image = "medal_equip_slot.tex" })
--     end
-- end

--检测可放入融合勋章的物品
function params.medium_multivariate_certificate.itemtestfn(container, item, slot)
	--可放入融合勋章并且没有相同的勋章组标签
	return item:HasTag("addfunctional") and not (item.grouptag and container.inst:HasTag(item.grouptag))
end

--高级融合勋章
params.large_multivariate_certificate = {
	widget =
	{
		slotpos = {},
		slotbg = {},
		animbank = "ui_chest_3x2",
		animbuild = "ui_chest_3x2",
		pos = default_pos.large_multivariate_certificate,
		hanchor=0,--锚点，0中1左2右
		vanchor=2,--锚点，0中1上2下
		dragtype="large_multivariate_certificate",--拖拽标签，有则可拖拽
	},
	usespecificslotsforitems = true,--使用特定插槽
	type = "multivariate_certificate",
	excludefromcrafting = true,--里面的道具不能直接用于制作
}

for y = 1, 0, -1 do
    for x = 0, 2 do
        table.insert(params.large_multivariate_certificate.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 120, 0))
        table.insert(params.large_multivariate_certificate.widget.slotbg, { atlas="images/medal_equip_slot.xml",image = "medal_equip_slot.tex" })
    end
end

--检测可放入融合勋章的物品
function params.large_multivariate_certificate.itemtestfn(container, item, slot)
	--可放入融合勋章并且没有相同的勋章组标签
	return item:HasTag("addfunctional") and not (item.grouptag and container.inst:HasTag(item.grouptag))
end

params.medal_cookpot =
{
    widget =
    {
        slotpos =
        {
            Vector3(0, 64 + 32 + 8 + 4, 0),
            Vector3(0, 32 + 4, 0),
            Vector3(0, -(32 + 4), 0),
            Vector3(0, -(64 + 32 + 8 + 4), 0),
        },
        animbank = "ui_cookpot_1x4",
        animbuild = "ui_cookpot_1x4",
        pos = Vector3(200, 0, 0),
        side_align_tip = 100,
        buttoninfo =
        {
            text = STRINGS.ACTIONS.COOK,
            position = Vector3(0, -165, 0),
        }
    },
    acceptsstacks = false,
    type = "cooker",
}

local cooking = require("cooking")

function params.medal_cookpot.itemtestfn(container, item, slot)
    return cooking.IsCookingIngredient(item.prefab) and not container.inst:HasTag("burnt")
end

function params.medal_cookpot.widget.buttoninfo.fn(inst,doer)
    if inst.components.container ~= nil then
        BufferedAction(doer, inst, ACTIONS.COOK):Do()
    elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
        SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.COOK.code, inst, ACTIONS.COOK.mod_name)
    end
end

function params.medal_cookpot.widget.buttoninfo.validfn(inst)
    return inst.replica.container ~= nil and inst.replica.container:IsFull()
end

--加入容器
local containers = require "containers"
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end

local containers_widgetsetup = containers.widgetsetup

function containers.widgetsetup(container, prefab, data)
    local t = data or params[prefab or container.inst.prefab]
    if t~=nil then
        for k, v in pairs(t) do
			container[k] = v
		end
		container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
    else
        return containers_widgetsetup(container, prefab, data)
    end
end

---------------------------------------------------------------------------------------------------------
----------------------------------------------容器拖拽---------------------------------------------------
---------------------------------------------------------------------------------------------------------
--给容器添加拖拽功能
if TUNING.MEDAL_CONTAINERDRAG_SETTING>0 then
	AddClassPostConstruct("widgets/containerwidget", function(self)
		local oldOpen = self.Open
		self.Open = function(self,...)
			oldOpen(self,...)
			if self.container and self.container.replica.container then
				local widget = self.container.replica.container:GetWidget()
				if widget then	
					--拖拽坐标标签，有则用标签，无则用容器名
					local dragname=widget.dragtype or (TUNING.MEDAL_CONTAINERDRAG_SETTING>1 and self.container and self.container.prefab)
					if dragname then
						--设置可拖拽
						if not self.candrag then
							MakeMedalDragableUI(self,self.bganim,dragname,{drag_offset=0.6})
						end
						--设置容器坐标(可装备的容器第一次打开做个延迟，不然加载游戏进来位置读不到)
						local newpos=GetMedalDragPos(dragname) or default_pos[dragname]
						if newpos then
							if self.container:HasTag("_equippable") and not self.container.isopended then
								self.container:DoTaskInTime(0, function()
									self:SetPosition(newpos)
								end)
								self.container.isopended=true
							else
								self:SetPosition(newpos)
							end
						end
					end
				end
			end
		end
	end)
end

---------------------------------------------------------------------------------------------------------
----------------------------------------------新界面---------------------------------------------------
---------------------------------------------------------------------------------------------------------
local MedalTownportalScreen = require "screens/medaltownportalscreen"--传送界面
local MedalSkinPopupScreen = require "screens/medalskinpopupscreen"--皮肤界面
local MedalSettingsScreen = require "screens/medalsettingsscreen"--设置界面
local MedalExamScreen = require "screens/medalexamscreen"--考试界面

AddClassPostConstruct("screens/playerhud",function(self, anim, owner)
	--添加传送界面
	self.ShowMedalTownportalScreen = function(_, attach)
		if attach == nil then
			return
		else
			self.medaltownportalscreen = MedalTownportalScreen(self.owner, attach)
			self:OpenScreenUnderPause(self.medaltownportalscreen)
			return self.medaltownportalscreen
		end
	end

	self.CloseMedalTownportalScreen = function(_)
		if self.medaltownportalscreen then
			self.medaltownportalscreen:Close()
			self.medaltownportalscreen = nil
		end
	end
	--添加皮肤界面
	self.ShowMedalSkinScreen = function(_, attach)
		if attach==nil then
			return
		end
		self.medalskinpopupscreen = MedalSkinPopupScreen(self.owner, attach)
        self:OpenScreenUnderPause(self.medalskinpopupscreen)
        return self.medalskinpopupscreen
	end

	self.CloseMedalSkinScreen = function(_)
		if self.medalskinpopupscreen ~= nil then
            if self.medalskinpopupscreen.inst:IsValid() then
                TheFrontEnd:PopScreen(self.medalskinpopupscreen)
            end
            self.medalskinpopupscreen = nil
        end
	end
	--添加设置界面
	self.ShowMedalSettingsScreen = function(_, attach)
		self.medalsettingsscreen = MedalSettingsScreen(self.owner)
		self:OpenScreenUnderPause(self.medalsettingsscreen)
		return self.medalsettingsscreen
	end

	self.CloseMedalSettingsScreen = function(_)
		if self.medalsettingsscreen then
			self.medalsettingsscreen:Close()
			self.medalsettingsscreen = nil
		end
	end
	--添加考试界面
	self.ShowMedalExamScreen = function(_, attach, hasdictionary)
		if attach==nil then
			return
		end
		self.medalexamscreen = MedalExamScreen(self.owner, attach, hasdictionary)
		self:OpenScreenUnderPause(self.medalexamscreen)
		return self.medalexamscreen
	end

	self.CloseMedalExamScreen = function(_)
		if self.medalexamscreen then
			self.medalexamscreen:Close()
			self.medalexamscreen = nil
		end
	end
end)

AddPopup("MEDALSKIN")
POPUPS.MEDALSKIN.fn = function(inst, show, staff)
    if inst.HUD then
        if not show then
            inst.HUD:CloseMedalSkinScreen()
        elseif not inst.HUD:ShowMedalSkinScreen(staff) then
            POPUPS.MEDALSKIN:Close(inst)
        end
    end
end

AddPopup("MEDALEXAM")
POPUPS.MEDALEXAM.fn = function(inst, show, attach, hasdictionary)
    if inst.HUD then
        if not show then
            inst.HUD:CloseMedalExamScreen()
        elseif not inst.HUD:ShowMedalExamScreen(attach, hasdictionary) then
            POPUPS.MEDALEXAM:Close(inst)
        end
    end
end

---------------------------------------------------------------------------------------------------------
----------------------------------------------书写界面---------------------------------------------------
---------------------------------------------------------------------------------------------------------
local writeables = require "writeables"
local SignGenerator = require"signgenerator"
local kinds = {}
kinds["townportal"] = {--传送塔
    prompt = STRINGS.SIGNS.MENU.PROMPT,
    animbank = "ui_board_5x3",
    animbuild = "ui_board_5x3",
    menuoffset = Vector3(6, -70, 0),

    cancelbtn = { text = STRINGS.SIGNS.MENU.CANCEL, cb = nil, control = CONTROL_CANCEL },
    middlebtn = { text = STRINGS.SIGNS.MENU.RANDOM, cb = function(inst, doer, widget)
            widget:OverrideText( SignGenerator(inst, doer) )
        end, control = CONTROL_MENU_MISC_2 },
    acceptbtn = { text = STRINGS.SIGNS.MENU.ACCEPT, cb = nil, control = CONTROL_ACCEPT },
}
kinds["space_time_certificate"] = kinds["townportal"]--时空勋章
kinds["medal_livingroot_chest"] = kinds["townportal"]--树根宝箱

local writeables_makescreen = writeables.makescreen
local writeables_GetLayout = writeables.GetLayout

function writeables.makescreen(inst, doer)
    local data = kinds[inst.prefab]
	if data then
		if doer and doer.HUD then
			return doer.HUD:ShowWriteableWidget(inst, data)
		end
	else
		return writeables_makescreen(inst, doer)
	end
end

function writeables.GetLayout(name)
    if name and kinds[name] then
		return kinds[name]
	else
		return writeables_GetLayout(name)
	end
end

--------兼容show me的绿色索引，代码参考自风铃草大佬的穹妹--------
local medal_containers={--需要兼容的容器列表
	"bearger_chest",--熊皮宝箱
	"medal_krampus_chest",--坎普斯宝匣
	"medal_krampus_chest_item",--坎普斯宝匣(物品状态)
	"medal_childishness_chest",--童心箱
	"medal_box",--勋章盒
	"spices_box",--调料盒
	"medal_ammo_box",--弹药盒
	"medal_livingroot_chest",--树根宝箱
	"medal_farm_plow_item",--高效耕地机
}
--如果他优先级比我高 这一段生效
for k,mod in pairs(ModManager.mods) do      --遍历已开启的mod
	if mod and mod.SHOWME_STRINGS then      --因为showme的modmain的全局变量里有 SHOWME_STRINGS 所以有这个变量的应该就是showme
		if mod.postinitfns and mod.postinitfns.PrefabPostInit and mod.postinitfns.PrefabPostInit.treasurechest then     --是的 箱子的寻物已经加上去了
			for _, v in ipairs(medal_containers) do
				mod.postinitfns.PrefabPostInit[v] = mod.postinitfns.PrefabPostInit.treasurechest
			end
		end
	end
end
--如果他优先级比我低 那下面这一段生效
TUNING.MONITOR_CHESTS = TUNING.MONITOR_CHESTS or {}
for _, v in ipairs(medal_containers) do
	TUNING.MONITOR_CHESTS[v] = true
end

---------------------------------------------------------------------------------------------------------
----------------------------------------------食谱书标记--------------------------------------------------
---------------------------------------------------------------------------------------------------------
local Image = require "widgets/image"
AddClassPostConstruct("widgets/redux/cookbookpage_crockpot", function(self)
	local base_size = 128
	local cell_size = 73
	local icon_size = 20 / (cell_size/base_size)
	if self.recipe_grid then
		--添加标记
		local splist=self.recipe_grid:GetListWidgets()
		if splist and #splist>0 then
			for k,v in pairs(splist) do
				-- v.medal_icon = v.recipie_root:AddChild(Image("images/quagmire_recipebook.xml", "cookbook_unknown_icon.tex"))
				v.medal_icon = v.recipie_root:AddChild(Image("images/quagmire_recipebook.xml", "coin1.tex"))
				v.medal_icon:ScaleToSize(icon_size, icon_size)
				v.medal_icon:SetPosition(-base_size/2 + 105, base_size/2 -25)
				-- v.medal_icon:Show()
			end
		end
		--获取玩家料理列表
		local food_list--料理列表
		if ThePlayer and ThePlayer.medal_food_list then
			local foodstr=ThePlayer.medal_food_list:value()
			if foodstr and #foodstr>0 then
				food_list = string.split(foodstr, ",")--所有坐标
			end
		end
		--hook数据应用函数
		local oldupdate_fn=self.recipe_grid.update_fn
		self.recipe_grid.update_fn=function(context, widget, data, index)
			if oldupdate_fn then
				oldupdate_fn(context, widget, data, index)
			end
			local showmedal=false--是否显示勋章标记
			--这里可以拿到料理数据了，根据勋章数据决定是否显示
			if widget and widget.data and widget.data.prefab then
				-- print(widget.data.prefab)
				if food_list and #food_list>0 then
					if table.contains(food_list,widget.data.prefab) then
						showmedal=true
					end
				end
			end
			if widget and widget.medal_icon then
				if showmedal then
					widget.medal_icon:Show()
				else
					widget.medal_icon:Hide()
				end
			end
		end
		self.recipe_grid:RefreshView()--打开的时候更新一下数据
	end
end)



---------------------------------------------------------------------------------------------------------
-------------------------------------------人物检查栏装备显示----------------------------------------------
---------------------------------------------------------------------------------------------------------
local EquipSlot = require("equipslotutil")
local TEXT_WIDTH = 100
local DEFAULT_IMAGES =
{
    hands = "unknown_hand.tex",
    head = "unknown_head.tex",
    body = "unknown_body.tex",
}
local MedalEquipWidgetLoot={
	"marbleaxe",--大理石斧头
	"marblepickaxe",--大理石镐
	"xinhua_dictionary",--新华字典
	"medal_moonglass_shovel",--月光玻璃铲
	"medal_moonglass_hammer",--月光玻璃锤
	"medal_moonglass_bugnet",--月光玻璃网
	"lureplant_rod",--食人花手杖
	"medal_goathat",--羊角帽
	"immortal_staff",--不朽法杖
	"down_filled_coat",--羽绒服
	"hat_blue_crystal",--蓝晶帽
	"medal_tentaclespike",--活性触手尖刺
	"sanityrock_mace",--方尖锏
	"meteor_staff",--流星法杖
	"armor_medal_obsidian",--红晶甲
	"armor_blue_crystal",--蓝晶甲
	"medal_fishingrod",--玻璃钓竿
	"devour_staff",--吞噬法杖
	"medal_space_staff",--时空法杖
	"medal_skin_staff",--风花雪月
}
AddClassPostConstruct("widgets/playeravatarpopup", function(self)
	local oldUpdateEquipWidgetForSlot = self.UpdateEquipWidgetForSlot
	self.UpdateEquipWidgetForSlot = function(self,image_group, slot, equipdata)
		local name = equipdata ~= nil and equipdata[EquipSlot.ToID(slot)] or nil
		name = name ~= nil and #name > 0 and name or "none"
		if table.contains(MedalEquipWidgetLoot,name) then
			local namestr = STRINGS.NAMES[string.upper(name)] or GetSkinName(name)
			image_group._text:SetColour(unpack(GetColorForItem(name)))
			image_group._text:SetMultilineTruncatedString(namestr, 2, TEXT_WIDTH, 25, true, true)

			local atlas = ""
			local default = DEFAULT_IMAGES[slot] or "trinket_5.tex"

			if resolvefilepath_soft("images/"..name..".xml") ~= nil then
				atlas = "images/"..name..".xml"
			elseif resolvefilepath_soft("images/inventoryimages/"..name..".xml") ~= nil then
				atlas = "images/inventoryimages/"..name..".xml"
			else
				atlas = GetInventoryItemAtlas(name..".tex")
			end
			-- print(name,atlas)

			image_group._image:SetTexture(atlas, name..".tex", default)
		elseif oldUpdateEquipWidgetForSlot then
			oldUpdateEquipWidgetForSlot(self,image_group, slot, equipdata)
		end
	end
end)
