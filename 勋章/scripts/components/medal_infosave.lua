local medal_infosave = Class(function(self, inst)
    self.inst = inst
	self.pytrade_data={--py交易数据
		medal_statue_marble_gugugu={},--鸽子py交易列表,格式{玩家1uid=交易日期,玩家2uid=交易日期}
		medal_statue_marble_saltfish={},--咸鱼py交易列表
		medal_statue_marble_stupidcat={},--猫猫py交易列表
	}
	self.medal_delay_damage_data={}--时之伤数据,格式{玩家1uid=时之伤,玩家2uid=时之伤}
	self.medal_parasitic_value_data={}--寄生值,格式{玩家1uid=寄生值,玩家2uid=寄生值}
	self.call_times_data={}--召唤淘气坎普斯次数,格式={玩家1uid=次数,玩家2uid=次数}
	self.lucky_damage_number_data={}--打混沌拳击袋88点伤害计数,格式={玩家1uid=次数,玩家2uid=次数}
	self.chaos_creature_death_count_data={}--混沌生物死亡次数统计,格式={生物prefab=次数}
	self.easter_eggs_data={}--触发彩蛋日期统计表{玩家1uid=触发日期,玩家2uid=交易日期}--目前也就奉纳盒用,以后有多个地方用了再另外扩展
	self.guaranteed_count_data={}--保底计数{玩家1uid={key1=计数1,key2=计数2}}
	--监听玩家换人
	inst:ListenForEvent("ms_newplayerspawned",function(src,player)
		if player and player.userid and player.components.health ~= nil then
			--同步时之伤
			if player.components.health.medal_delay_damage ~= nil then
				player.components.health.medal_delay_damage = math.max(self.medal_delay_damage_data[player.userid] or 0,player.components.health.medal_delay_damage)
			else
				player.components.health.medal_delay_damage = self.medal_delay_damage_data[player.userid] or 0
			end
			--同步寄生值
			if player.components.health.medal_parasitic_value ~= nil then
				player.components.health.medal_parasitic_value = math.max(self.medal_parasitic_value_data[player.userid] or 0,player.components.health.medal_parasitic_value)
			else
				player.components.health.medal_parasitic_value = self.medal_parasitic_value_data[player.userid] or 0
			end
		end
	end)
	--监听玩家加入游戏
	inst:ListenForEvent("ms_playerjoined", function(src, player)
		--加入游戏的时候把数据同步一下
		if player and player.userid and player.components.health ~= nil then
			--时之伤
			if player.components.health.medal_delay_damage ~= nil then
				self.medal_delay_damage_data[player.userid] = player.components.health.medal_delay_damage
			end
			--寄生值
			if player.components.health.medal_parasitic_value ~= nil then
				self.medal_parasitic_value_data[player.userid] = player.components.health.medal_parasitic_value
			end
		end
	end)
end)

--和雕像进行py交易
function medal_infosave:DoPyTrade(statue,player)
	if player and player.userid and statue and statue.pyTradeFn and self.pytrade_data[statue.prefab] then
		local thefirst = GetTableSize(self.pytrade_data[statue.prefab]) == 0--是否为第一个交易的人
		local pydate = self.pytrade_data[statue.prefab][player.userid]--上一次Py的日期
		--10天内最多交易1次
		local cycles = TheWorld and TheWorld.state.cycles or 1
		if pydate==nil or cycles >= (pydate+10) then
			self.pytrade_data[statue.prefab][player.userid] = cycles
			if statue.pyTradeFn then
				statue:pyTradeFn(thefirst, pydate == nil, player)
			end
			return true
		end
	end
	return false
end

--召唤淘气坎普斯计数(召唤者,计数)
function medal_infosave:AddCallTimes(player,times)
	if player and player.userid then
		local oldtimes = self.call_times_data[player.userid] or 0
		self.call_times_data[player.userid] = oldtimes+(times or 1)
		return oldtimes--返回原来的计数
	end
	return 0
end

--打混沌拳击袋88点伤害计数
function medal_infosave:CountLuckyNumberTimes(player)
	if player and player.userid then
		self.lucky_damage_number_data[player.userid] = (self.lucky_damage_number_data[player.userid] or 0) + 1
		return self.lucky_damage_number_data[player.userid]
	end
	return 0
end

--统计混沌生物死亡次数
function medal_infosave:CountChaosCreatureDeathTimes(victim)
	if victim ~= nil then
		self.chaos_creature_death_count_data[victim.prefab] = (self.chaos_creature_death_count_data[victim.prefab] or 0) + 1
	end
end
--获取混沌生物死亡次数
function medal_infosave:GetChaosCreatureDeathTimes(target)
	if target ~= nil then
		local newkey = target.ChaosDeathTimesKey or target.prefab or "null"
		return self.chaos_creature_death_count_data[newkey] or 0
	end
	return 0
end

--触发彩蛋并记录日期
function medal_infosave:TriggerEasterEggs(player)
	if player and player.userid then
		local lastdate = self.easter_eggs_data[player.userid]--上一次触发的日期
		local cycles = TheWorld and TheWorld.state.cycles or 1
		--3天内最多触发1次
		if lastdate==nil or cycles >= (lastdate+3) then
			self.easter_eggs_data[player.userid] = cycles
			return true
		end
	end
	return false
end

--保底计数
function medal_infosave:DoGuaranteedCount(player,key)
	if player and player.userid and key then
		self.guaranteed_count_data[player.userid] = self.guaranteed_count_data[player.userid] or {}
		self.guaranteed_count_data[player.userid][key] = (self.guaranteed_count_data[player.userid][key] or 0) + 1
	end
end

--读取保底计数
function medal_infosave:GetGuaranteedNum(player,key)
	if player and player.userid and key then
		return self.guaranteed_count_data[player.userid] and self.guaranteed_count_data[player.userid][key] or 0
	end
	return 0
end

--清空保底计数
function medal_infosave:ClearGuaranteedCount(player,key)
	if player and player.userid and key and self.guaranteed_count_data[player.userid] and self.guaranteed_count_data[player.userid][key] then
		self.guaranteed_count_data[player.userid][key] = nil
	end
end

function medal_infosave:OnSave() 
	return  {
		pytrade_data=deepcopy(self.pytrade_data),
		medal_delay_damage_data=shallowcopy(self.medal_delay_damage_data),
		medal_parasitic_value_data=shallowcopy(self.medal_parasitic_value_data),
		call_times_data=shallowcopy(self.call_times_data),
		chaos_creature_death_count_data=shallowcopy(self.chaos_creature_death_count_data),
		lucky_damage_number_data=shallowcopy(self.lucky_damage_number_data),
		easter_eggs_data=shallowcopy(self.easter_eggs_data),
		guaranteed_count_data=deepcopy(self.guaranteed_count_data),
	}
end

function medal_infosave:OnLoad(data)       
	if data then
        if data.pytrade_data then
			self.pytrade_data = deepcopy(data.pytrade_data)
		end
		if data.medal_delay_damage_data then
			self.medal_delay_damage_data=shallowcopy(data.medal_delay_damage_data)
		end
		if data.medal_parasitic_value_data then
			self.medal_parasitic_value_data=shallowcopy(data.medal_parasitic_value_data)
		end
		if data.call_times_data then
			self.call_times_data=shallowcopy(data.call_times_data)
		end
		if data.chaos_creature_death_count_data then
			self.chaos_creature_death_count_data=shallowcopy(data.chaos_creature_death_count_data)
		end
		if data.lucky_damage_number_data then
			self.lucky_damage_number_data=shallowcopy(data.lucky_damage_number_data)
		end
		if data.easter_eggs_data then
			self.easter_eggs_data=shallowcopy(data.easter_eggs_data)
		end
		if data.guaranteed_count_data then
			self.guaranteed_count_data = deepcopy(data.guaranteed_count_data)
		end
	end
end

return medal_infosave