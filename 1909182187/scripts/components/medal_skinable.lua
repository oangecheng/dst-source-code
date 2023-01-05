local medal_skins=require("medal_defs/medal_skin_defs")

--更新网络变量
local function onskinid(self,skinid)
	if self.inst.replica.medal_skinable then
		self.inst.replica.medal_skinable._skinid:set(skinid)
	end
end

--生成特效
local function spawnFx(inst,offset)
	local fx = SpawnPrefab("explode_reskin")
	local x,y,z=inst.Transform:GetWorldPosition()
	local offset_y = offset and offset.y or 0
	local scale = offset and offset.scale or 1
	if fx then
		fx.Transform:SetScale(scale, scale, scale)
		fx.Transform:SetPosition(x,y+offset_y,z)
	end
end

local medal_skinable = Class(function(self, inst)
    self.inst = inst
	self.skinid=0--当前所用皮肤ID,无皮肤则为0
end,
nil,
{
    skinid = onskinid
})

--获取皮肤ID
function medal_skinable:GetSkinId()
	return self.inst.replica.medal_skinable and self.inst.replica.medal_skinable._skinid:value() or self.skinid
end

--换皮肤(法杖)
function medal_skinable:ChangeSkin(staff)
	if medal_skins and medal_skins[self.inst.prefab] then
		local skin_info=medal_skins[self.inst.prefab].skin_info
		if skin_info and #skin_info>0 then
			local new_id =self.skinid--新皮肤ID
			local skin_key=medal_skins[self.inst.prefab].skin_key or self.inst.prefab
			if staff and staff.skin_data then
				local save_data=staff.skin_data[skin_key]--获取皮肤法杖存储的数据
				if save_data and #save_data>0 then
					local memory=nil--皮肤记忆
					if staff.lastskin and staff.lastskin.key==skin_key and staff.lastskin.id~=new_id then
						if staff.lastskin.id==0 or table.contains(save_data,staff.lastskin.id) then
							new_id=staff.lastskin.id
							memory=true
						end
					end
					
					if not memory then
						if self.skinid>=#skin_info then--已经是最后一个皮了，换回原皮
							new_id=0
						else
							for i=self.skinid+1,#skin_info do
								if table.contains(save_data,i) then
									new_id=i
									break
								end
								if i==#skin_info then
									new_id=0
								end
							end
						end
					end
				end
			end
			--新ID不等于原ID,则换皮
			if new_id~=self.skinid then
				self.skinid=new_id
				if staff then
					staff.lastskin={key=skin_key,id=new_id}
				end
				if new_id>0 then
					--换新皮
					if skin_info[new_id] and skin_info[new_id].reskin_fn then
						skin_info[new_id].reskin_fn(self.inst)
						--播放特效、消耗法杖耐久(消耗可以放在法杖那边执行)
						spawnFx(self.inst,medal_skins[self.inst.prefab].fx_data)
						return true
					end
				elseif medal_skins[self.inst.prefab].initskin_fn then
					--换成初始皮
					medal_skins[self.inst.prefab].initskin_fn(self.inst)
					--播放特效、消耗法杖耐久(消耗可以放在法杖那边执行)
					spawnFx(self.inst,medal_skins[self.inst.prefab].fx_data)
					return true
				end
			end
		end
	end
end
--设置皮肤(皮肤ID(可不填))
function medal_skinable:SetSkin(skinid)
	local skin_id = skinid or self.skinid
	if medal_skins and medal_skins[self.inst.prefab] then
		local skin_info=medal_skins[self.inst.prefab].skin_info
		if skin_info and skin_info[skin_id] and skin_info[skin_id].reskin_fn then
			skin_info[skin_id].reskin_fn(self.inst)
			if self.skinid~=skin_id  then
				self.skinid=skin_id
			end
		end
	end
end
--获取皮肤数据(皮肤ID(非必须))
function medal_skinable:GetSkinData(skin_id)
	local skinid = skin_id or self.skinid
	if skinid>0 then
		if medal_skins and medal_skins[self.inst.prefab] then
			local skin_info=medal_skins[self.inst.prefab].skin_info
			if skin_info and skin_info[skinid] then
				return skin_info[skinid]
			end
		end
	end
end
--获取Placer
function medal_skinable:GetPlacerName()
	local skinid = self.skinid
	if skinid>0 then
		if medal_skins and medal_skins[self.inst.prefab] then
			local skin_info=medal_skins[self.inst.prefab].skin_info
			if skin_info and skin_info[skinid] then
				return skin_info[skinid].placer
			end
		end
	end
end

function medal_skinable:OnSave() 
	return  {skinid=self.skinid}
end

function medal_skinable:OnLoad(data)       
	if data and data.skinid then
        self.skinid = data.skinid
		self:SetSkin()
	end
end

return medal_skinable