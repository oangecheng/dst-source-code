local medal_infosave = Class(function(self, inst)
    self.inst = inst
	self.pytrade_data={--py交易数据
		medal_statue_marble_gugugu={},--鸽子py交易列表,格式{玩家1uid=交易日期,玩家2uid=交易日期}
		medal_statue_marble_saltfish={},--咸鱼py交易列表
		medal_statue_marble_stupidcat={},--猫猫py交易列表
	}
	self.medal_delay_damage_data={}--时之伤数据,格式{玩家1uid=时之伤,玩家2uid=时之伤}
	self.call_times_data={}--召唤淘气坎普斯次数,格式={玩家1uid=次数,玩家2uid=次数}
	--监听玩家换人
	inst:ListenForEvent("ms_newplayerspawned",function(src,player)
		if player and player.userid and player.components.health ~= nil then
			if player.components.health.medal_delay_damage ~= nil then
				player.components.health.medal_delay_damage = math.max(self.medal_delay_damage_data[player.userid] or 0,player.components.health.medal_delay_damage)
			else
				player.components.health.medal_delay_damage = self.medal_delay_damage_data[player.userid] or 0
			end
		end
	end)
	--监听玩家加入游戏
	inst:ListenForEvent("ms_playerjoined", function(src, player)
		--加入游戏的时候把时之伤同步一下
		if player and player.userid and player.components.health ~= nil then
			if player.components.health.medal_delay_damage ~= nil then
				self.medal_delay_damage_data[player.userid] = player.components.health.medal_delay_damage
			end
		end
	end)
end)

--和雕像进行py交易
function medal_infosave:DoPyTrade(statue,player)
	if player and player.userid and statue and statue.pyTradeFn and self.pytrade_data[statue.prefab] then
		local thefirst = GetTableSize(self.pytrade_data[statue.prefab]) == 0--是否为第一个交易的人
		local pydate = self.pytrade_data[statue.prefab][player.userid]--上一次Py的日期
		--5天内最多交易1次
		local cycles = TheWorld and TheWorld.state.cycles or 1
		if pydate==nil or cycles >= (pydate+5) then
			self.pytrade_data[statue.prefab][player.userid] = cycles
			if statue.pyTradeFn then
				statue:pyTradeFn(thefirst, pydate == nil, player)
			end
			return true
		end
	end
	return false
end

--召唤淘气坎普斯计数
function medal_infosave:AddCallTimes(player)
	if player and player.userid then
		local oldtimes = self.call_times_data[player.userid] or 0
		self.call_times_data[player.userid] = oldtimes+1
		return oldtimes--返回原来的计数
	end
	return 0
end

function medal_infosave:OnSave() 
	return  {
		pytrade_data=deepcopy(self.pytrade_data),
		medal_delay_damage_data=shallowcopy(self.medal_delay_damage_data),
		call_times_data=shallowcopy(self.call_times_data),
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
		if data.call_times_data then
			self.call_times_data=shallowcopy(data.call_times_data)
		end
	end
end

return medal_infosave