local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

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
--添加临时标签
function AddMedalTag(owner,tag)
	--标签计数
	owner.medal_tag=owner.medal_tag or {}
	owner.medal_tag[tag]=owner.medal_tag[tag] and owner.medal_tag[tag]+1 or 1
	if not owner:HasTag(tag) then
		owner:AddTag(tag)
		--临时标签组
		owner.medal_t_tag=owner.medal_t_tag or {}
		owner.medal_t_tag[tag]=true
	end
end
--移除临时标签
function RemoveMedalTag(owner,tag)
	if owner.medal_tag and owner.medal_tag[tag] then
		owner.medal_tag[tag]=owner.medal_tag[tag]>1 and owner.medal_tag[tag]-1 or nil
		if not owner.medal_tag[tag] and owner.medal_t_tag and owner.medal_t_tag[tag] then
			owner:RemoveTag(tag)
			owner.medal_t_tag[tag]=nil
		end
	end
end
--添加临时组件
function AddMedalComponent(owner,com)
	--组件计数
	owner.medal_com=owner.medal_com or {}
	owner.medal_com[com]=owner.medal_com[com] and owner.medal_com[com]+1 or 1
	if not owner.components[com] then
		owner:AddComponent(com)
		--临时组件组
		owner.medal_t_com=owner.medal_t_com or {}
		owner.medal_t_com[com]=true
	end
end
--移除临时组件
function RemoveMedalComponent(owner,com)
	if owner.medal_com and owner.medal_com[com] then
		owner.medal_com[com]=owner.medal_com[com]>1 and owner.medal_com[com]-1 or nil
		if not owner.medal_com[com] and owner.medal_t_com and owner.medal_t_com[com] then
			owner:RemoveComponent(com)
			owner.medal_t_com[com]=nil
		end
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

--获取皮肤替换文件名(inst,默认名,部位类型)
function GetMedalSkinData(inst,build,build_type)
	local new_build=build
	local buildtype=build_type or "build"
	if inst.components.medal_skinable then
		local skin_info=inst.components.medal_skinable:GetSkinData()
		if skin_info and skin_info[buildtype] then
			new_build=skin_info[buildtype]
		end
	end
	return new_build
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

--根据权重获取随机物品(权重表,随机值)--表格式{{key="a",weight=1,num=2},{key="b",weight=1}}
function GetMedalRandomItem(loot,rand)
	local function weighted_total(loot)
		local total = 0
		for i, v in ipairs(loot) do
			total = total + v.weight
		end
		return total
	end
	local random_num=rand or math.random()
	local threshold = random_num * weighted_total(loot)

	local last_choice, last_num
	for i, v in ipairs(loot) do
		threshold = threshold - v.weight
		if threshold <= 0 then return v.key, v.num or 1 end
		last_choice = v.key
		last_num = v.num or 1
	end

	return last_choice, last_num
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

function SpawnNaughtyKrampus(player,num)
	local call_times = TheWorld and TheWorld.components.medal_infosave and TheWorld.components.medal_infosave:AddCallTimes(player)
	for i = 1, num or 0 do
		local kramp = MakeANaughtyKrampusForPlayer(player,call_times)
		if kramp ~= nil and kramp.components.combat ~= nil then
			kramp.components.combat:SetTarget(player)
		end
	end	
end

----------------------------------------------生成遗失包裹-------------------------------------------
--特殊掉落
local bundle_loot1={
	immortal_book = 8,--不朽之谜
	monster_book = 6,--怪物图鉴
	unsolved_book = 11,--未解之谜
	medal_moonglass_potion = 11,--月光药水
	medal_skin_coupon = 4,--皮肤券
}
--普通掉落
local bundle_loot2={
	thulecite=6,----铥矿
	thulecite_pieces=8,--铥矿碎片
	fossil_piece=2,--化石碎片
	livinglog=8,--活木
	nitre=10,--硝石
	glommerfuel=12,--格罗姆黏液
	medal_glommer_essence=6,--格罗姆精华
	townportaltalisman=8,--砂之石
	moonrocknugget=10,--月岩
	mosquitosack=8,--蚊子血囊
	moonglass=10,--玻璃碎片
	medaldug_livingtree_root=6,--活木树种
	saltrock=6,--盐晶
}
--惊喜掉落
local surprise_loot={
	"butterfly",--蝴蝶
	"killerbee",--杀人蜂
	"bee",--蜜蜂
	"fireflies",--萤火虫
	"moonbutterfly",--月蛾
}
--掉落遗失包裹(掉落目标,玩家,生成坐标点)
function DropBundle(target,player,pos)
	local bundleitems = {}
	--惊喜掉落(招蜂引蝶、采花大盗)
	if math.random()<=TUNING_MEDAL.SURPRISE_DROP_RATE then
		local petals=math.random()<.5 and "petals" or nil
		for i=1,4 do
			local surpriseItem=SpawnPrefab(petals and petals or GetRandomItem(surprise_loot))
			if surpriseItem.components.stackable then
				surpriseItem.components.stackable.stacksize = math.random(20)
			end
			table.insert(bundleitems, surpriseItem)
		end
	else--普通掉落
		if math.random() < TUNING_MEDAL.LOST_BAG_GOOD_DROP_RATE then
			local blankchance= player and player:HasTag("traditionalbearer3") and 0 or 0.5--空白勋章掉率
			local copy_bundle_loot1=shallowcopy(bundle_loot1)--浅拷贝一份，方便调整概率
			--新月未解之谜权重翻倍
			if TheWorld.state.isnewmoon and copy_bundle_loot1.unsolved_book then
				copy_bundle_loot1.unsolved_book=copy_bundle_loot1.unsolved_book*2
			end
			--玩家没学过怪物精华蓝图则加入怪物精华蓝图
			if player and player.components.builder and not player.components.builder:KnowsRecipe("medal_monster_essence") then
				--获取玩家身上的正义勋章
				local medal = player.components.inventory and player.components.inventory:EquipMedalWithName("justice_certificate")
				local weighting = 0--加权
				if medal and medal.medal_honor and medal.medal_honor[3] then
					weighting=weighting+medal.medal_honor[3]*2--根据正义勋章记录的包裹数量来加权
				end
				copy_bundle_loot1["medal_monster_essence_blueprint"]=10+weighting
			end
			table.insert(bundleitems, SpawnPrefab(math.random()<blankchance and "blank_certificate" or weighted_random_choice(copy_bundle_loot1)))
		end
		for i = 1, math.random(1, 3-#bundleitems) do
			table.insert(bundleitems, SpawnPrefab(weighted_random_choice(bundle_loot2)))
		end
		for i=#bundleitems,3 do
			table.insert(bundleitems, SpawnPrefab("goldnugget"))
		end
	end
    local bundle = SpawnPrefab(math.random()<0.33 and "bundle" or "gift")
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
--天道酬勤奖励价值
local tiandao_rewards = {
	medal_tribute_symbol = 1,--奉纳符
	mission_certificate = 1,--使命勋章
	medal_gift_fruit_seed = 1,--包果种子
	medal_gift_fruit = 1,--包果
}
--掉落天道酬勤道具(触发者,概率)
function RewardToiler(player,chance)
	chance = chance or TUNING_MEDAL.REWARD_TOILER_CHANCE--不填则用默认概率
	-- print("天道酬勤",chance)
	if player and (player.rewardtoiler_mark==nil or player.rewardtoiler_mark < TUNING_MEDAL.MEDAL_BUFF_REWARDTOILER_MARK_MAX) and math.random()<chance then
		local reward = SpawnPrefab(weighted_random_choice(tiandao_rewards))
		if reward then
			if reward.prefab=="mission_certificate" and reward.InitMission then
				reward:InitMission(nil,nil,player)
			end
			if player.components.lootdropper then
				player.components.lootdropper:FlingItem(reward)
			else
				reward.Transform:SetPosition(player.Transform:GetWorldPosition())
				if reward.components.inventoryitem ~= nil then
					reward.components.inventoryitem:OnDropped(true, .5)
				end
			end
			player:AddDebuff("buff_medal_rewardtoiler_mark","buff_medal_rewardtoiler_mark")
			SpawnMedalTips(player,1,17)--弹幕提示
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
		dragtarget.OnControl = function (self,control, down)
			local parentwidget=self:GetParent()--控制它爹的坐标,而不是它自己
			--按下右键可拖动
			if parentwidget and parentwidget.Passive_OnControl then
				parentwidget:Passive_OnControl(control, down)
			end
			return oldOnControl and oldOnControl(self,control,down)
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

GLOBAL.MedalSay=MedalSay--说话(演讲者,台词)
GLOBAL.IsNativeCookingProduct=IsNativeCookingProduct--是否是游戏原生基础料理,参数(料理名,是否是大厨料理)
GLOBAL.AddMedalTag=AddMedalTag--添加临时标签,参数(目标对象,标签)
GLOBAL.RemoveMedalTag=RemoveMedalTag--移除临时标签,参数(目标对象,标签)
GLOBAL.AddMedalComponent=AddMedalComponent--添加临时组件,参数(目标对象,组件名)
GLOBAL.RemoveMedalComponent=RemoveMedalComponent--移除临时组件,参数(目标对象,组件名)
GLOBAL.SpawnMedalTips=SpawnMedalTips--生成弹幕提示,参数(玩家,数值,提示类型)
GLOBAL.MakeRageKrampusForPlayer=MakeRageKrampusForPlayer--给玩家生成一个暗夜坎普斯,参数(目标玩家)
GLOBAL.SpawnNaughtyKrampus=SpawnNaughtyKrampus--给玩家生成n个淘气坎普斯并记录召唤次数,参数(目标玩家,生成数量)
GLOBAL.DropBundle=DropBundle--生成遗失包裹,参数(掉落目标,玩家,生成坐标点)
GLOBAL.DropLossBundle=DropLossBundle--掉落遗失包裹,参数(掉落目标,玩家,要掉落的数量)
GLOBAL.MedalGetLocalFn=MedalGetLocalFn--获取局部变量、函数,参数(引用了该函数的函数,想获取的函数/变量名,非函数)
GLOBAL.GetMedalRandomItem=GetMedalRandomItem--根据权重获取随机物品,参数(权重表,随机值)--表格式{{key="a",weight=1,num=2},{key="b",weight=1}}
GLOBAL.GetMedalSkinData=GetMedalSkinData--获取皮肤替换文件名,参数(inst,默认名,部位类型)
GLOBAL.MakeMedalDragableUI=MakeMedalDragableUI--设置UI可拖拽,参数(self,拖拽目标,拖拽标签,拖拽信息)
GLOBAL.GetMedalDragPos=GetMedalDragPos--获取拖拽坐标,参数(拖拽标签)
GLOBAL.ResetMedalUIPos=ResetMedalUIPos--重置拖拽坐标
GLOBAL.SaveMedalSettingData=SaveMedalSettingData--存储勋章设置
GLOBAL.LoadMedalSettingData=LoadMedalSettingData--加载勋章设置信息
GLOBAL.RewardToiler=RewardToiler--天道酬勤,参数(玩家,概率)--不填则用默认概率