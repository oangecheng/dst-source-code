--更新网络变量
local function onbuffinfo(self,buffinfo)
	if self.inst.replica.medal_showbufftime then
		self.inst.replica.medal_showbufftime._buffinfo:set(buffinfo)
	end
end

local medal_showbufftime = Class(function(self, inst)
    self.inst = inst
	self.buffinfo=""--当前buff数据
	self:Start()
end,
nil,
{
    buffinfo = onbuffinfo
})


--停止buff信息同步
function medal_showbufftime:Cancel()
	if self.inst and self.inst.medal_buff_info_task ~= nil then
		self.inst.medal_buff_info_task:Cancel()
		self.inst.medal_buff_info_task = nil
	end
end
--开始同步buff信息
function medal_showbufftime:Start()
	self:Cancel()
	self.inst.medal_buff_info_task = self.inst:DoPeriodicTask(1, function()
		self:SetBuffInfo()
	end)
end


--获取Buff时长
function medal_showbufftime:getBuffTime(inst)
	if self.getbufftimefn ~= nil then
		local time = self.getbufftimefn(inst)
		if time and time>0 then
			return time
		end
	end
	return inst.components.timer:GetTimeLeft("buffover") or inst.components.timer:GetTimeLeft("regenover") or -1
end

--设置buff信息
function medal_showbufftime:SetBuffInfo()
	local buff_info={}
	local buffstr=""
	if self.inst and self.inst.components.debuffable and self.inst.components.debuffable.debuffs then
		for _, v in pairs(self.inst.components.debuffable.debuffs) do
			if v.inst and v.inst.components.timer then
				local buffdata={
					buffname=v.inst.nameoverride or v.inst.prefab,
					bufftime=math.floor(self:getBuffTime(v.inst)),
				}
				--蜂毒层数
				if v.inst.prefab=="buff_medal_injured" then
					buffdata.bufflayer=self.inst.injured_damage or 1
				--血蜜标记层数
				elseif v.inst.prefab=="buff_medal_bloodhoneymark" then
					buffdata.bufflayer=self.inst.blood_honey_mark or 1
				--群伤层数
				elseif v.inst.prefab=="buff_medal_aoecombat" then
					buffdata.bufflayer=self.inst.medal_aoecombat_value or 1
				--鱼人诅咒
				elseif v.inst.prefab=="buff_medal_mermcurse" then
					buffdata.bufflayer=self.inst.medal_merm_curse or 1
				--迷迷糊糊
				elseif v.inst.prefab=="buff_medal_confused" then
					buffdata.bufflayer=self.inst.medal_confused_mark or 1
				end
				table.insert(buff_info,buffdata)
			--有的buff比较特殊,不是用timer而是用task做的
			elseif v.inst and v.inst.task then
				local buffdata={
					buffname=v.inst.prefab,
					bufftime=math.floor(GetTaskRemaining(v.inst.task)),
				}
				table.insert(buff_info,buffdata)
			end
		end
	end
	--保温、降温
	if self.inst and self.inst.components.temperature and self.inst.components.temperature.bellytemperaturedelta ~= nil then
		local buffdata={
			buffname=self.inst.components.temperature.bellytemperaturedelta>0 and "medal_temperature_up" or "medal_temperature_down",
			bufftime=self.inst.components.temperature and (self.inst.components.temperature.bellytime-GetTime()) or -1,
		}
		table.insert(buff_info,buffdata)
	end
	--发光
	if self.inst and self.inst.wormlight ~= nil and self.inst.wormlight.components.spell then
		local duration=self.inst.wormlight.components.spell.duration
		local lifetime=self.inst.wormlight.components.spell.lifetime
		if duration and lifetime then
			local buffdata={
				buffname="medal_wormlight",
				bufftime=duration-lifetime,
			}
			table.insert(buff_info,buffdata)
		end
	end
	--时之伤
	if self.inst and self.inst.components.health and self.inst.components.health.medal_delay_damage and self.inst.components.health.medal_delay_damage>0 then
		local buffdata={
			buffname="medal_delay_damage",
			bufftime=-1,
			bufflayer=self.inst.components.health.medal_delay_damage,
		}
		table.insert(buff_info,buffdata)
	end
	--寄生值
	if self.inst and self.inst.components.health and self.inst.components.health.medal_parasitic_value and self.inst.components.health.medal_parasitic_value>0 then
		local buffdata={
			buffname="medal_parasitic_value",
			bufftime=-1,
			bufflayer=self.inst.components.health.medal_parasitic_value,
		}
		table.insert(buff_info,buffdata)
	end
	--天道酬勤
	if self.inst and self.inst.medal_rewardtoiler_mark and self.inst.medal_rewardtoiler_mark>0 then
		local buffdata={
			buffname="medal_rewardtoiler_mark",
			bufftime=-1,
			bufflayer=self.inst.medal_rewardtoiler_mark,
		}
		table.insert(buff_info,buffdata)
	end
	--爆发值
	if self.inst and self.inst.medal_silence_damage and self.inst.medal_silence_damage > 0 then
		local buffdata={
			buffname="medal_silence_damage",
			bufftime=-1,
			bufflayer=math.floor(self.inst.medal_silence_damage*10)*.1,
		}
		table.insert(buff_info,buffdata)
	end
	--正义值
	-- if self.inst and self.inst:HasTag("addjustice") then
	-- 	local medal = self.inst.components.inventory and self.inst.components.inventory:EquipMedalWithName("justice_certificate")
	-- 	if medal and medal.components.finiteuses then
	-- 		local buffdata={
	-- 			buffname="medal_justice_value",
	-- 			bufftime=-1,
	-- 			bufflayer=medal.components.finiteuses:GetUses(),
	-- 		}
	-- 		table.insert(buff_info,buffdata)
	-- 	end
	-- end
	--红蓝晶充能
	if self.inst and self.inst.has_charging_armor then
		local armor = self.inst.components.inventory and self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)--获取穿戴中的甲
    	if armor and armor.medal_charging and armor.medal_charging > 0 then
			--红晶甲
			if armor.prefab == "armor_medal_obsidian" then
				local buffdata={
					buffname="medal_red_charging",
					bufftime=-1,
					bufflayer=armor.medal_charging,
				}
				table.insert(buff_info,buffdata)
			--蓝晶甲
			elseif armor.prefab == "armor_blue_crystal" then
				local buffdata={
					buffname="medal_blue_charging",
					bufftime=-1,
					bufflayer=armor.medal_charging,
				}
				table.insert(buff_info,buffdata)
			end
		end
	end
	--自定义方法,可以自己定义buff信息的获取方式,把获取到的数据插入buff_info表里
	if self.getbuffinfofn ~= nil then
		self.getbuffinfofn(self.inst,buff_info)
	end
	--排序、转码
	if #buff_info>0 then
		table.sort(buff_info, function(a,b) return a.bufftime < b.bufftime end)--排序(免得pairs打乱了)
		buffstr=json.encode(buff_info)
	end
	if self.buffinfo~=buffstr then
		self.buffinfo=buffstr
	end
end
--获取Buff信息
function medal_showbufftime:GetBuffInfo()
	return self.buffinfo
end
--自定义buff信息读取方案
function medal_showbufftime:SetGetBuffInfoFn(fn)
	self.getbuffinfofn=fn
end
--自定义时间读取方案
function medal_showbufftime:SetGetBuffTimeFn(fn)
	self.getbufftimefn=fn
end

return medal_showbufftime