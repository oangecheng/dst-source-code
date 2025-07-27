-----------------------------------公用函数---------------------------------
--说话(演讲者,台词)
function MedalSay(talker,str)
	if talker and str and talker.components.talker and not talker:HasTag("mime") then
		talker.components.talker:Say(str)
	end
end

--是否是游戏原生基础料理(料理名,是否是大厨料理)
function IsNativeCookingProduct(name,ismaster)
	--普通料理
	if not ismaster then
		for k, v in pairs(require("preparedfoods")) do
			if name==v.name then
				return true
			end
		end
	end
	--大厨料理
	for k, v in pairs(require("preparedfoods_warly")) do
		if name==v.name then
			return true
		end
	end
    return false
end


local trinkets_loot = {--玩具列表
	antliontrinket=1,--沙滩玩具
	cotl_trinket=1,--红眼冠
}
if NUM_TRINKETS and NUM_TRINKETS>0 then
	for k=1, NUM_TRINKETS do
		trinkets_loot["trinket_"..k]= k >= HALLOWEDNIGHTS_TINKET_START and k <= HALLOWEDNIGHTS_TINKET_END and 2 or 1
	end
end
--是否是玩具(道具名,是否是万圣节玩具)
function IsTrinket(name,is_hallowednights)
	return trinkets_loot[name] ~= nil and (not is_hallowednights or trinkets_loot[name]>1)
end

--添加临时标签
function AddMedalTag(owner,tag)
	owner.medal_tag = owner.medal_tag or {}
	--添加标签时进行计数,防止由于勋章、装备的穿脱导致角色身上原本拥有的标签被移除掉
	if owner:HasTag(tag) then
		owner.medal_tag[tag] = (owner.medal_tag[tag] or 1) + 1
	else
		owner.medal_tag[tag] = 1
		owner:AddTag(tag)
	end
end
--移除临时标签
function RemoveMedalTag(owner,tag)
	if owner.medal_tag and owner.medal_tag[tag] then
		owner.medal_tag[tag] = owner.medal_tag[tag] > 1 and owner.medal_tag[tag]-1 or nil
		if owner.medal_tag[tag] == nil then
			owner:RemoveTag(tag)
		end
	else
		owner:RemoveTag(tag)
	end
end
--是否是临时组件
function IsMedalTempCom(owner,com)
	return com ~= nil and owner.medal_t_com and owner.medal_t_com[com]
end
--添加临时组件
function AddMedalComponent(owner,com)
	owner.medal_com = owner.medal_com or {}
	--添加组件时进行计数,防止由于勋章、装备的穿脱导致角色身上原本拥有的组件被移除掉
	if owner.components[com] then
		owner.medal_com[com] = (owner.medal_com[com] or 1) + 1
	else
		owner.medal_com[com] = 1
		owner:AddComponent(com)
		--临时组件组
		owner.medal_t_com = owner.medal_t_com or {}
		owner.medal_t_com[com]=true
	end
end
--移除临时组件
function RemoveMedalComponent(owner,com)
	if owner.medal_com and owner.medal_com[com] then
		owner.medal_com[com] = owner.medal_com[com] > 1 and owner.medal_com[com]-1 or nil
		if owner.medal_com[com] == nil then
			owner:RemoveComponent(com)
			if IsMedalTempCom(owner,com) then
				owner.medal_t_com[com]=nil
			end
		end
	else
		owner:RemoveComponent(com)
	end
end

--生成弹幕提示(玩家,数值,提示类型)
function SpawnMedalTips(player,consume,tiptype)
	if TUNING.MEDAL_TIPS_SWITCH and consume and consume>0 and player then
		local medal_tips=SpawnPrefab("medal_tips")
		medal_tips.Transform:SetPosition(player.Transform:GetWorldPosition())
		if medal_tips.medal_d_value then
			medal_tips.medal_d_value:set(consume+1000*tiptype)
		end
	end
end

--生成勋章相关特效(特效代码,生成目标,生成目标点,范围)
function SpawnMedalFX(fxcode,target,pos,radius)
	--支持屏蔽减少性能消耗
	if TUNING.SHOW_MEDAL_FX then
		local spos = target and target:GetPosition() or pos
		if spos ~= nil then
			local fx = SpawnPrefab(fxcode)
			if fx then
				fx.Transform:SetPosition(spos.x, spos.y, spos.z)
				if fx.SetRadius and radius then
					fx:SetRadius(radius)
				end
			end
		end
	end
end

--获取局部变量(引用了该函数的函数,想获取的函数名,非函数)
function MedalGetLocalFn(fn,fname,nofn)
	local idx=1--索引
	local maxidx = 20--最大尝试次数
	while (idx>0 and idx<maxidx) do
		local name,val=debug.getupvalue(fn,idx)
		if name and name==fname then
			if val and (nofn or type(val)=="function") then
				return val
			end
			idx=-1
		end
		idx=idx+1
	end
end

--根据宿命生成随机整数(随机数,最大值,最小值)
function GetMedalRandomNum(rand,maxnum,minnum)
	rand = rand or math.random()
	maxnum = maxnum or 1
	minnum = minnum or 1
	return math.ceil(rand*(maxnum-minnum+1)) + minnum - 1
end

--获取宿命(inst,宿命池key)
function GetMedalDestiny(inst,key)
	if inst ~= nil then
		--有宿命组件优先返回组件记录的宿命
		if inst.components.medal_itemdestiny ~= nil then
			return inst.components.medal_itemdestiny:GetDestiny()
		--否则返回记录的宿命(某些特殊道具需要另外保存宿命)
		elseif inst.medal_destiny_num ~= nil then
			return inst.medal_destiny_num
		end
		key = key or inst.prefab
	end
	--以上均不符合则从宿命池里捞宿命
	if TheWorld and TheWorld.components.medal_serverdestiny ~= nil then
		if key ~= nil then
			return TheWorld.components.medal_serverdestiny:GetDestinyByKey(key)
		end
		return TheWorld.components.medal_serverdestiny:GetDestiny()
	end

	return math.random()
end

----------------------------------------------根据权重获取随机物品-------------------------------------------
local function weighted_total(loot,rweightloot)
	local total = 0
	for i, v in ipairs(loot) do
		total = total + (rweightloot and rweightloot[v.key] or v.weight)
	end
	return total
end
--根据权重获取随机物品(权重表,随机值,权重替换表)
--权重表格式{{key="a",weight=1},{key="b",weight=1}}--权重替换表格式{a=0,b=0}
--这种格式才能确保随机结果不会受到pairs迭代器的影响
function GetMedalRandomItem(loot,rand,rweightloot)
	local random_num
	if rand ~=nil then
		if type(rand) == "number" then
			random_num = rand
		else
			random_num = GetMedalDestiny(rand)--终究逃不过宿命
		end
	end
	random_num = random_num or math.random()
	
	local threshold = random_num * weighted_total(loot,rweightloot)
	local last_choice
	for i, v in ipairs(loot) do
		threshold = threshold - (rweightloot and rweightloot[v.key] or v.weight)
		if threshold <= 0 then return v.key end
		last_choice = v.key
	end

	return last_choice
end

----------------------------------------------按规律批量生成物品阵/圈-------------------------------------------
--生成各种怪圈(目标玩家,预置物列表,感叹词)
function MedalSpawnCircleItem(player,spawnLoot,talkstr)
	if player == nil then return end
	local px,py,pz = player.Transform:GetWorldPosition()--获取玩家坐标
	--遍历生成物列表
	for _,v in ipairs(spawnLoot) do
		--对玩家执行函数
		if v.playerfn then
			v.playerfn(player)
		end
		--有代码则生成对应预置物
		if v.item or v.randomlist then
			local num=v.num or 1--生成数量
			local specialnum=v.specialfn and math.random(num)-1 or nil--特殊道具
			--生成怪圈
			for i=0,num-1 do
				local code=v.item--预置物代码
				if v.randomlist then
					code = weighted_random_choice(v.randomlist)--从随机列表里取一种
				end
				local angle_offset=v.angle_offset or 0--角度偏移
				local angle = (i+angle_offset) * 2 * PI / (num)--根据数量计算角度
				local tries =v.offset and 5 or 1--尝试生成次数,有偏移值的情况下要多次尝试生成,避免少刷
				local canspawn=nil--是否可生成
				for j=1,tries do
					--有偏移值则用偏移值生成坐标，否则根据半径生成坐标，没半径则原地生成
					local ix=v.offset and (math.random()*2-1)*v.offset+px or v.radius and v.radius*math.cos(angle)+px or px
					local iy=0--py--别在天上生成了
					local iz=v.offset and (math.random()*2-1)*v.offset+pz or v.radius and v.radius*math.sin(angle)+pz or pz
					--水中奇遇则判断坐标点是不是在水里;canoverlap表示生成点可以有其他东西
					if v.iswater then
						canspawn = TheWorld.Map:IsOceanAtPoint(ix, iy, iz) and (v.canoverlap or TheWorld.Map:IsDeployPointClear(Vector3(ix, iy, iz), nil, 1))
					else
						canspawn = TheWorld.Map:IsPassableAtPoint(ix, iy, iz) and (v.canoverlap or TheWorld.Map:IsDeployPointClear(Vector3(ix, iy, iz), nil, 1))
					end
					--对坐标点进行有效性判断
					if canspawn and v.posvailfn then
						canspawn = v.posvailfn(ix,iz)
					end
					--坐标点可生成则生成，否则继续尝试
					if canspawn then
						local item = SpawnPrefab(code)
						if item then
							item.Transform:SetPosition(ix, iy, iz)
							--如果没有特意取消，那么开出来的生物默认仇恨玩家
							if item.components.combat and not v.noaggro then
								item.components.combat:SuggestTarget(player)
							end
							--有特殊函数则执行特殊函数
							if specialnum and i==specialnum then
								v.specialfn(item,player)
							elseif v.itemfn then--否则执行正常预置物函数
								v.itemfn(item,player)
							end
						end
						break
					end
				end
			end
		end
	end
	--发出感叹词
	if talkstr then
		MedalSay(player,talkstr)
	end
end

----------------------------------------------生成暗夜坎普斯-------------------------------------------
--获取生成点
local function GetSpawnPoint(pt)
    local SPAWN_DIST = 25--生成距离
	if not TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) then
        pt = FindNearbyLand(pt, 1) or pt
    end
    local offset = FindWalkableOffset(pt, math.random() * 2 * PI, SPAWN_DIST, 12, true, true, function(pt) return not TheWorld.Map:IsPointNearHole(pt) end)
    if offset ~= nil then
        offset.x = offset.x + pt.x
        offset.z = offset.z + pt.z
        return offset
    end
end

--给玩家生成一个暗夜坎普斯
function MakeRageKrampusForPlayer(player)
    local pt = player:GetPosition()
    local spawn_pt = GetSpawnPoint(pt)
    if spawn_pt ~= nil then
        
		local kramp = SpawnPrefab("medal_rage_krampus")
		--播放警告的声音
		SpawnPrefab("krampuswarning_lvl3").Transform:SetPosition(player.Transform:GetWorldPosition())
        kramp.Physics:Teleport(spawn_pt:Get())
        kramp:FacePoint(pt)
        kramp.spawnedforplayer = player
        kramp:ListenForEvent("onremove", function() kramp.spawnedforplayer = nil end, player)
		if kramp.components.combat then
			kramp.components.combat:SetTarget(player)
		end
        return kramp
    end
end

----------------------------------------------生成淘气坎普斯-------------------------------------------
local function MakeANaughtyKrampusForPlayer(player,call_times)
    local pt = player:GetPosition()
    local spawn_pt = GetSpawnPoint(pt)
    if spawn_pt ~= nil then
        local kramp = SpawnPrefab("medal_naughty_krampus")
		if call_times and call_times>0 and kramp.InitInfo then
			kramp.call_times = call_times--记录召唤次数
			kramp:InitInfo()--初始化各状态数据
		end
        kramp.Physics:Teleport(spawn_pt:Get())
        kramp:FacePoint(pt)
        kramp.spawnedforplayer = player
        kramp:ListenForEvent("onremove", function() kramp.spawnedforplayer = nil end, player)
        return kramp
    end
end
--生成淘气坎普斯(召唤者,召唤数量,是否不计数)
function SpawnNaughtyKrampus(player,num,nocount)
	local call_times = TheWorld and TheWorld.components.medal_infosave and TheWorld.components.medal_infosave:AddCallTimes(player,nocount and 0)
	local count = 0--成功生成数量计数
	for i = 1, num or 0 do
		local kramp = MakeANaughtyKrampusForPlayer(player,call_times)
		if kramp ~= nil and kramp.components.combat ~= nil then
			kramp.components.combat:SetTarget(player)
			count = count + 1
		end
	end
	return count
end

----------------------------------------------生成遗失包裹-------------------------------------------
--特殊掉落
local unsolved_book_weight = 11--未解之谜权重(单独拎出来是因为下面也有调用)
local bundle_special_loot={
	{key="immortal_book",weight=8},--不朽之谜
	{key="monster_book",weight=6},--怪物图鉴
	{key="unsolved_book",weight=unsolved_book_weight},--未解之谜
	{key="medal_moonglass_potion",weight=11},--月光药水
	{key="medal_skin_coupon",weight=4},--皮肤券
	{key="medal_monster_essence_blueprint",weight=0},--怪物精华蓝图
}
--普通掉落
local bundle_common_loot={
	{key="thulecite",weight=6},--铥矿
	{key="thulecite_pieces",weight=8},--铥矿碎片
	{key="fossil_piece",weight=5},--化石碎片
	{key="livinglog",weight=8},--活木
	{key="nitre",weight=7},--硝石
	{key="glommerfuel",weight=12},--格罗姆黏液
	{key="medal_glommer_essence",weight=6},--格罗姆精华
	{key="townportaltalisman",weight=8},--砂之石
	{key="moonrocknugget",weight=10},--月岩
	{key="mosquitosack",weight=8},--蚊子血囊
	{key="moonglass",weight=10},--玻璃碎片
	{key="medaldug_livingtree_root",weight=6},--活木树种
	{key="saltrock",weight=6},--盐晶
}
--惊喜掉落
local bundle_surprise_loot={
	{key="butterfly",weight=1},--蝴蝶
	{key="killerbee",weight=1},--杀人蜂
	{key="bee",weight=1},--蜜蜂
	{key="fireflies",weight=1},--萤火虫
	{key="moonbutterfly",weight=1},--月蛾
}

--掉落遗失包裹(掉落目标,玩家,生成坐标点)
function DropBundle(target,player,pos)
	local bundleitems = {}
	local destiny_num = GetMedalDestiny(nil,"loss_bundle")--宿命
	--惊喜掉落(招蜂引蝶、采花大盗)
	if destiny_num <= TUNING_MEDAL.SURPRISE_DROP_RATE then
		destiny_num = destiny_num*100%1
		local petals = destiny_num < .5 and "petals" or nil
		for i=1,4 do
			local itemcode = petals
			if itemcode == nil then
				destiny_num = destiny_num*10%1
				itemcode = GetMedalRandomItem(bundle_surprise_loot,destiny_num)
			end
			local surpriseItem = SpawnPrefab(itemcode)
			if surpriseItem.components.stackable then
				destiny_num = destiny_num*10%1
				surpriseItem.components.stackable.stacksize = GetMedalRandomNum(destiny_num,20)
			end
			table.insert(bundleitems, surpriseItem)
		end
	else--普通掉落
		local gift_count = 0
		--稀有道具
		destiny_num = destiny_num*100%1
		if destiny_num < TUNING_MEDAL.LOST_BAG_GOOD_DROP_RATE then
			local blankchance = player and player:HasTag("traditionalbearer3") and 0 or 0.5--空白勋章掉率
			destiny_num = destiny_num*10%1
			--掉落空白勋章
			if destiny_num < blankchance then
				table.insert(bundleitems, SpawnPrefab("blank_certificate"))
			else
				local rweightloot={}--权重替换表
				--新月未解之谜权重翻倍
				if TheWorld.state.isnewmoon then
					rweightloot["unsolved_book"] = unsolved_book_weight * 2
				end
				--玩家没学过怪物精华蓝图则加入怪物精华蓝图
				if player and player.components.builder and not player.components.builder:KnowsRecipe("medal_monster_essence") then
					--获取玩家身上的正义勋章
					local medal = player.components.inventory and player.components.inventory:EquipMedalWithName("justice_certificate")
					local weighting = 0--加权
					if medal and medal.medal_honor and medal.medal_honor[3] then
						weighting = weighting + medal.medal_honor[3] * 2--根据正义勋章记录的包裹数量来加权
					end
					rweightloot["medal_monster_essence_blueprint"] = 10 + weighting
				end
				destiny_num = destiny_num*10%1
				table.insert(bundleitems, SpawnPrefab(GetMedalRandomItem(bundle_special_loot,destiny_num,rweightloot)))
			end
			gift_count = gift_count + 1
		end
		--普通道具
		destiny_num = destiny_num*10%1
		for i = 1, GetMedalRandomNum(destiny_num,3 - gift_count) do
			destiny_num = destiny_num*10%1
			table.insert(bundleitems, SpawnPrefab(GetMedalRandomItem(bundle_common_loot,destiny_num)))
			gift_count = gift_count + 1
		end
		--填充物
		for i=gift_count,3 do
			table.insert(bundleitems, SpawnPrefab("goldnugget"))
		end
	end
	destiny_num = destiny_num*10%1
    local bundle = SpawnPrefab(destiny_num < 0.33 and "bundle" or "gift")
    bundle.components.unwrappable:WrapItems(bundleitems)
    for i, v in ipairs(bundleitems) do
        v:Remove()
    end
	if pos then
		bundle.Transform:SetPosition(pos:Get())
	elseif target then
		if target.components.lootdropper then
			target.components.lootdropper:FlingItem(bundle)
		else
			bundle.Transform:SetPosition(target.Transform:GetWorldPosition())
		end
	elseif player and player.components.inventory then
		player.components.inventory:GiveItem(bundle)
	end
end

--生成遗失包裹(掉落目标,玩家,要生成的数量)
function DropLossBundle(target,player,num)
	local spawnNum= num or 1
	for i=1,spawnNum do
		DropBundle(target,player)
	end
end

----------------------------------------------天道酬勤-------------------------------------------
--触发天道酬勤掉落(触发者,概率,触发物)
function RewardToiler(player,chance,item)
	chance = (chance or TUNING_MEDAL.REWARD_TOILER_CHANCE) * TUNING_MEDAL.REWARD_TOILER_CHANCE_MULT--不填则用默认概率
	-- print("天道酬勤",chance)
	if player and player.medal_rewardtoiler_mark and player.medal_rewardtoiler_mark >0 and math.random()<chance then
		local reward = SpawnPrefab("medal_diligence_token")
		if reward then
			if player.components.inventory then
				player.components.inventory:GiveItem(reward)
			elseif player.components.lootdropper then
				player.components.lootdropper:FlingItem(reward)
			else
				reward.Transform:SetPosition(player.Transform:GetWorldPosition())
				if reward.components.inventoryitem ~= nil then
					reward.components.inventoryitem:OnDropped(true, .5)
				end
			end
			player.medal_rewardtoiler_mark = player.medal_rewardtoiler_mark -1
			SpawnMedalTips(player,1,17)--弹幕提示
			--物品触发天道酬勤后调用
			if item and item.reward_toiler_fn then
				item:reward_toiler_fn()
			end
			return true--这里主要是为了让有飘字提示的地方给天道酬勤让步，防止两个飘字重叠了
		end
	end
end

----------------------------------------------容器拖拽-------------------------------------------
local uiloot={}--UI列表，方便重置
--拖拽坐标，局部变量存储，减少io操作
local dragpos={}
--更新同步拖拽坐标(如果容器没打开过，那么存储的坐标信息就没被赋值到dragpos里，这时候直接去存储就会导致之前存储的数据缺失，所以要主动取一下数据存到dragpos里)
local function loadDragPos()
	TheSim:GetPersistentString("medal_drag_pos", function(load_success, data)
		if load_success and data ~= nil then
            local success, allpos = RunInSandbox(data)
		    if success and allpos then
				for k, v in pairs(allpos) do
					if dragpos[k]==nil then
						dragpos[k]=Vector3(v.x or 0, v.y or 0, v.z or 0)
					end
				end
			end
		end
	end)
end
--存储拖拽后坐标
local function saveDragPos(dragtype,pos)
	if next(dragpos) then
		local str = DataDumper(dragpos, nil, true)
		TheSim:SetPersistentString("medal_drag_pos", str, false)
	end
end
--获取拖拽坐标
function GetMedalDragPos(dragtype)
	if dragpos[dragtype]==nil then
		loadDragPos()
	end
	return dragpos[dragtype]
end

--设置UI可拖拽(self,拖拽目标,拖拽标签,拖拽信息)
function MakeMedalDragableUI(self,dragtarget,dragtype,dragdata)
	self.candrag=true--可拖拽标识(防止重复添加拖拽功能)
	uiloot[self]=self:GetPosition()--存储UI默认坐标
	--给拖拽目标添加拖拽提示
	if dragtarget then
		dragtarget:SetTooltip(STRINGS.MEDAL_UI.DRAGABLETIPS)
		local oldOnControl=dragtarget.OnControl
		dragtarget.OnControl = function (self,control, down, ...)
			if TUNING.MEDAL_CLIENT_DRAG_SWITCH then
				local parentwidget=self:GetParent()--控制它爹的坐标,而不是它自己
				--按下右键可拖动
				if parentwidget and parentwidget.Passive_OnControl then
					parentwidget:Passive_OnControl(control, down)
				end
			end
			if oldOnControl then
				return oldOnControl(self,control,down, ...)
			end
		end
	end
	
	--被控制(控制状态，是否按下)
	function self:Passive_OnControl(control, down)
		if self.focus and control == CONTROL_SECONDARY then
			if down then
				self:StartDrag()
			else
				self:EndDrag()
			end
		end
	end
	--设置拖拽坐标
	function self:SetDragPosition(x, y, z)
		local pos
		if type(x) == "number" then
			pos = Vector3(x, y, z)
		else
			pos = x
		end
		
		local self_scale=self:GetScale()
		local offset=dragdata and dragdata.drag_offset or 1--偏移修正(容器是0.6)
		local newpos=self.p_startpos+(pos-self.m_startpos)/(self_scale.x/offset)--修正偏移值
		self:SetPosition(newpos)--设定新坐标
	end
	
	--开始拖动
	function self:StartDrag()
		if not self.followhandler then
			local mousepos = TheInput:GetScreenPosition()
			self.m_startpos = mousepos--鼠标初始坐标
			self.p_startpos = self:GetPosition()--面板初始坐标
			self.followhandler = TheInput:AddMoveHandler(function(x,y)
				self:SetDragPosition(x,y,0)
				if not Input:IsMouseDown(MOUSEBUTTON_RIGHT) then
					self:EndDrag()
				end
			end)
			self:SetDragPosition(mousepos)
		end
	end
	
	--停止拖动
	function self:EndDrag()
		if self.followhandler then
			self.followhandler:Remove()
		end
		self.followhandler = nil
		self.m_startpos = nil
		self.p_startpos = nil
		local newpos=self:GetPosition()
		if dragtype then
			dragpos[dragtype]=newpos--记录记录拖拽后坐标
		end
		saveDragPos()--存储坐标
	end
end

--重置拖拽坐标
function ResetMedalUIPos()
	dragpos={}
	TheSim:SetPersistentString("medal_drag_pos", "", false)
	for k, v in pairs(uiloot) do
		if k.inst and k.inst:IsValid() then
			k:SetPosition(v)--重置坐标
		else
			uiloot[k]=nil--失效了的就清掉吧
		end
	end
end

----------------------------------------------勋章设置-------------------------------------------
--需存储的设置信息
local setting_name={
	-- "MEDAL_BUFF_SWITCH",--buff面板开关
	"MEDAL_BUFF_SETTING",--buff面板开关
	"MEDAL_BUFF_SHOW_NUM",--buff显示条数
	"MEDAL_TEST_SWITCH",--显示预制物代码
	"MEDAL_KRAMPUS_CHEST_PRIORITY",--坎普斯宝匣优先级
	"MEDAL_SHOW_INFO",--显示勋章信息
	"MEDAL_CLIENT_DRAG_SWITCH",--容器拖拽客户端开关
	"MEDAL_LOCK_TARGET_RANGE_MULT",--弹弓锁敌范围倍数
}

--存储勋章设置
function SaveMedalSettingData()
	local setting_data={}
	for _, v in ipairs(setting_name) do
		setting_data[v]=TUNING[v]
	end
	local str = DataDumper(setting_data, nil, true)
	TheSim:SetPersistentString("medal_setting_data", str, false)
end
--加载勋章设置信息
function LoadMedalSettingData()
	TheSim:GetPersistentString("medal_setting_data", function(load_success, data)
		if load_success and data ~= nil then
            local success, setting_data = RunInSandbox(data)
		    if success and setting_data then
				for _, v in ipairs(setting_name) do
					if setting_data[v]~=nil then
						TUNING[v] = setting_data[v]
					end
				end
			end
		end
	end)
end
LoadMedalSettingData()--游戏开始直接调用一下

----------------------------------------------添加不朽组件-------------------------------------------
--添加不朽组件
function SetImmortalable(inst,maxlevel,immortalinfo)
	--客户端自定义方法
	if immortalinfo and immortalinfo.clientfn then
		immortalinfo.clientfn(inst)
	end
	if TheWorld.ismastersim then
		inst:AddComponent("medal_immortal")--不朽组件
		--最大不朽等级
		if maxlevel then
			inst.components.medal_immortal:SetMaxLevel(maxlevel)
		end
		--添加不朽之力后的自定义方法
		if immortalinfo and immortalinfo.immortalfn then
			inst.components.medal_immortal:SetOnImmortal(immortalinfo.immortalfn)
		end
		--防止旧存档的不朽之力失效
		local oldLoadFn=inst.OnLoad
		inst.OnLoad = function(inst,data)
			if oldLoadFn~=nil then
				oldLoadFn(inst,data)
			end
			if data~=nil and data.immortal then
				if inst.components.medal_immortal then
					inst.components.medal_immortal:SetImmortal(1)
				end
			end
		end
		--服务器自定义方法
		if immortalinfo and immortalinfo.serverfn then
			immortalinfo.serverfn(inst)
		end
	end
end
----------------------------------------------设为不朽工具-------------------------------------------
--耐久用完
local function onfinished(inst)
	inst:DoTaskInTime(0,function(inst)
		if inst:HasTag("isimmortal") then
            if inst.components.equippable ~= nil then
                if inst.components.equippable:IsEquipped() then
                    local owner = inst.components.inventoryitem.owner
                    if owner ~= nil and owner.components.inventory ~= nil then
                        local item = owner.components.inventory:Unequip(inst.components.equippable.equipslot)
                        if item ~= nil then
                            owner.components.inventory:GiveItem(item, nil, owner:GetPosition())
                        end
                    end
                end
                inst:RemoveComponent("equippable")
            end
        else
			inst:Remove()
		end
	end)
end

--修补耐久
local function OnRepaired(inst)
	if inst.components.equippable == nil and inst.SetupEquippable then
		inst:SetupEquippable()
	end
end

--设为不朽工具
local function onImmortalToolFn(inst,level,isadd)
	inst:AddTag("canbesorbtool")--可被吸收工具能力
end

--添加不朽之力
local function onimmortal(inst,level,isadd)
    if inst.components.finiteuses ~= nil then
		--不朽工具耐久翻倍
		inst.components.finiteuses.total = inst.medal_maxuse * 2
		if isadd then
			inst.components.finiteuses:SetPercent(1)--升级则直接加满耐久
			OnRepaired(inst)
		else
			inst.components.finiteuses:Use(0)--更新下耐久显示
		end
	end
	--可以执行高强度工作(挖裂隙晶体、裂开的柱子等)
	if inst.components.tool ~= nil then
		inst.components.tool:EnableToughWork(true)
	end
	if inst.onImmortalToolFn then--不朽工具
		inst:onImmortalToolFn(level,isadd)
	end
end

--设为不朽工具(inst,添加装备组件函数,初始耐久上限,能力是否可被吸收)
function SetImmortalTool(inst,SetupEquippable,maxuse,canbesorb)
	if inst.components.finiteuses ~= nil then
		inst.components.finiteuses:SetOnFinished(onfinished)
		inst.components.finiteuses:SetDoesNotStartFull(true)--防止满耐久数据不保存
	end
	if SetupEquippable ~= nil then
		inst.SetupEquippable = SetupEquippable
		SetupEquippable(inst)
	end
	inst.medal_onrepairfn = OnRepaired

	inst.medal_maxuse = maxuse or 100

	if canbesorb then--能力可被吸收的话加个可被吸收标签
		inst.onImmortalToolFn = onImmortalToolFn
	end

	inst:AddComponent("medal_immortal")--不朽组件
    inst.components.medal_immortal:SetOnImmortal(onimmortal)
end

----------------------------------------------消耗buff时长-------------------------------------------
--消耗buff时长(inst,buff名,消耗时长)
function ConsumeMedalBuff(inst,buffname,consume)
	if buffname == "buff_medal_suckingblood" then
		--暗影盾特效
		local fx=SpawnPrefab("medal_shield_player")
		if fx then fx.entity:SetParent(inst.entity) end
	end
	inst:AddDebuff(buffname, buffname,{consume_duration = consume})
end

----------------------------------------------加载时自动打开容器-------------------------------------------
function SetAutoOpenContainer(inst)
	if TheWorld.ismastersim then
		local oldonsave = inst.OnSave
		local oldonload = inst.OnLoad
		inst.OnSave = function(inst,data)
			if oldonsave ~= nil then
				oldonsave(inst,data)
			end
			--由于save和load都会执行两次，这里必须要通过中间变量来寄存这个打开状态
			data.medal_isopen = inst.medal_isopen or (inst.components.container ~= nil and inst.components.container:IsOpen())
		end
		inst.OnLoad = function(inst,data)
			if oldonload ~= nil then
				oldonload(inst,data)
			end
			if data ~= nil and data.medal_isopen then
				inst.medal_isopen = data.medal_isopen--使用中间变量来寄存这个打开状态
				inst:DoTaskInTime(0,function(inst)
					if inst.medal_isopen and inst.components.container ~= nil then
						local owner = inst.components.inventoryitem and inst.components.inventoryitem:GetGrandOwner()
						if owner ~= nil and owner:HasTag("player") then
							inst.components.container:Open(owner)
						end
						inst.medal_isopen = nil
					end
				end)
			end
		end
	end
end

----------------------------------------------获取展示名字-------------------------------------------
--由于displaynamefn优先级比named组件高，会覆盖掉原来的逻辑，所以需要特殊处理
function GetMedalDisplayName(inst,displaynamefn, ...)
	return (displaynamefn ~= nil and displaynamefn(inst, ...))
        or (inst.nameoverride ~= nil and STRINGS.NAMES[string.upper(inst.nameoverride)])
		or (inst.name_author_netid ~= nil and ApplyLocalWordFilter(inst.name, TEXT_FILTER_CTX_CHAT, inst.name_author_netid))
        or inst.name
end

----------------------------------------------奉纳盒数据转换-------------------------------------------
local veggies_to_num = {
	carrot = 1,
    corn = 2,
    pumpkin = 3,
    eggplant = 4,
    pomegranate = 5,
    dragonfruit = 6,
	watermelon = 7,
    asparagus = 8,
    onion = 9,
	tomato = 10,
    potato = 11,
    garlic = 12,
    pepper = 13,
    durian = 14,
	immortal_fruit = 15,
}
local num_to_veggies = {"carrot","corn","pumpkin","eggplant","pomegranate","dragonfruit","watermelon","asparagus","onion","tomato","potato","garlic","pepper","durian","immortal_fruit"}
function GetPayTributeData(key)
	return veggies_to_num[key] or num_to_veggies[key]
end

----------------------------------------------设定踏水碰撞体-------------------------------------------
function SetMedalTreadWaterCollides(player,canTread)
	if player ~= nil and player.Physics ~= nil and not player:HasTag("playerghost") then
		player.medal_canTread = canTread
		player.Physics:ClearCollisionMask()
		player.Physics:CollidesWith(canTread and COLLISION.GROUND or COLLISION.WORLD)
		player.Physics:CollidesWith(COLLISION.OBSTACLES)
		player.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
		player.Physics:CollidesWith(COLLISION.CHARACTERS)
		player.Physics:CollidesWith(COLLISION.GIANTS)
		player.Physics:Teleport(player.Transform:GetWorldPosition())
	end
end

----------------------------------------------有保底的随机-----------------------------------------------
--inst记录者,chance概率,key保底对象(预置物名或者一个自定义的key),是否存储保底数据
function GuaranteedRandom(inst,chance,key,needsave)
	needsave = true--目前先默认都存储吧
	local medal_infosave = TheWorld and TheWorld.components.medal_infosave or nil
	--需要存储保底计数
	if needsave and medal_infosave ~= nil and inst.userid ~= nil then
		--成功随机到掉落,清空保底计数
		if math.random() < chance then
			medal_infosave:ClearGuaranteedCount(inst, key)
			return true
		--触发保底
		elseif medal_infosave:GetGuaranteedNum(inst, key) >= math.ceil(1/chance*1.5) - 1 then
			medal_infosave:ClearGuaranteedCount(inst, key)
			SpawnMedalTips(inst,1,14)--弹幕提示
			return true
		end
		medal_infosave:DoGuaranteedCount(inst, key)--触发失败,保底计数+1
		return false
	else
		inst.medal_guaranteed_record = inst.medal_guaranteed_record or {}--保底数据记录表
		--成功随机到掉落,清空保底计数
		if math.random() < chance then
			inst.medal_guaranteed_record[key] = nil
			return true
		--触发保底
		elseif inst.medal_guaranteed_record[key] and inst.medal_guaranteed_record[key] >= math.ceil(1/chance*1.5) - 1 then
			inst.medal_guaranteed_record[key] = nil
			SpawnMedalTips(inst,1,14)--弹幕提示
			return true
		end
		--触发失败,保底计数+1
		inst.medal_guaranteed_record[key] = (inst.medal_guaranteed_record[key] or 0) + 1
		return false
	end
end

----------------------------------------------有本源勋章-----------------------------------------------
function HasOriginMedal(inst,tag,key)
	if inst ~= nil and (tag == nil or inst:HasTag(tag)) and (key == nil or inst[key]) then
		return inst:HasTag("has_origin_medal")
	end
end

GLOBAL.MedalSay=MedalSay--说话(演讲者,台词)
GLOBAL.IsNativeCookingProduct=IsNativeCookingProduct--是否是游戏原生基础料理,参数(料理名,是否是大厨料理)
GLOBAL.AddMedalTag=AddMedalTag--添加临时标签,参数(目标对象,标签)
GLOBAL.RemoveMedalTag=RemoveMedalTag--移除临时标签,参数(目标对象,标签)
GLOBAL.AddMedalComponent=AddMedalComponent--添加临时组件,参数(目标对象,组件名)
GLOBAL.RemoveMedalComponent=RemoveMedalComponent--移除临时组件,参数(目标对象,组件名)
GLOBAL.SpawnMedalTips=SpawnMedalTips--生成弹幕提示,参数(玩家,数值,提示类型)
GLOBAL.MakeRageKrampusForPlayer=MakeRageKrampusForPlayer--给玩家生成一个暗夜坎普斯,参数(目标玩家)
GLOBAL.SpawnNaughtyKrampus=SpawnNaughtyKrampus--给玩家生成n个淘气坎普斯并记录召唤次数,参数(目标玩家,生成数量,是否不计数)
GLOBAL.DropBundle=DropBundle--生成遗失包裹,参数(掉落目标,玩家,生成坐标点)
GLOBAL.DropLossBundle=DropLossBundle--掉落遗失包裹,参数(掉落目标,玩家,要掉落的数量)
GLOBAL.MedalGetLocalFn=MedalGetLocalFn--获取局部变量、函数,参数(引用了该函数的函数,想获取的函数/变量名,非函数)
GLOBAL.GetMedalRandomItem=GetMedalRandomItem--根据权重获取随机物品(权重表,随机值,权重替换表)--权重表格式{{key="a",weight=1},{key="b",weight=1}}--权重替换表格式{a=0,b=0}
GLOBAL.MedalSpawnCircleItem=MedalSpawnCircleItem--生成各种怪圈(目标玩家,预置物列表,感叹词)
GLOBAL.MakeMedalDragableUI=MakeMedalDragableUI--设置UI可拖拽,参数(self,拖拽目标,拖拽标签,拖拽信息)
GLOBAL.GetMedalDragPos=GetMedalDragPos--获取拖拽坐标,参数(拖拽标签)
GLOBAL.ResetMedalUIPos=ResetMedalUIPos--重置拖拽坐标
GLOBAL.SaveMedalSettingData=SaveMedalSettingData--存储勋章设置
GLOBAL.LoadMedalSettingData=LoadMedalSettingData--加载勋章设置信息
GLOBAL.RewardToiler=RewardToiler--天道酬勤,参数(玩家,概率,触发物)--不填则用默认概率;触发物非必填，一般用于触发自定义方法
GLOBAL.IsTrinket=IsTrinket--是否是玩具,参数(道具名,是否是万圣节玩具)
GLOBAL.SpawnMedalFX=SpawnMedalFX--生成勋章相关特效(特效代码,生成目标,生成目标点,范围)--目标和目标点2选1，范围只对范围圈类的生效
GLOBAL.SetImmortalable=SetImmortalable--添加不朽组件(inst,最大不朽等级,不朽相关信息)
GLOBAL.ConsumeMedalBuff=ConsumeMedalBuff--消耗buff时长(inst,buff名,消耗时长)
GLOBAL.SetImmortalTool=SetImmortalTool--设为不朽工具(inst,添加装备组件函数,初始耐久上限,能力是否可被吸收)
GLOBAL.GetMedalDestiny=GetMedalDestiny--获取宿命(inst,宿命池key)
GLOBAL.GetMedalRandomNum=GetMedalRandomNum--根据宿命生成随机整数(宿命值(就是随机数),最大值,最小值)
GLOBAL.SetAutoOpenContainer=SetAutoOpenContainer--设为加载时可自动打开的容器
GLOBAL.GetMedalDisplayName=GetMedalDisplayName--获取展示名字(inst,原来的displaynamefn)
GLOBAL.GetPayTributeData=GetPayTributeData--奉纳盒数据转化,代码转数字，数字转代码(key)
GLOBAL.SetMedalTreadWaterCollides=SetMedalTreadWaterCollides--设定踏水碰撞体(player,是否可踏水)
GLOBAL.GuaranteedRandom=GuaranteedRandom--有保底的随机(记录者,概率,保底对象)
GLOBAL.IsMedalTempCom=IsMedalTempCom--是否是临时组件(玩家,组件名)
GLOBAL.HasOriginMedal=HasOriginMedal--是否受到本源勋章加强(玩家,tag)--tag可不填