local function SetAnim(inst, data)
	inst.AnimState:SetBank(data.bank)
	inst.AnimState:SetBuild(data.build)
	if data.animpush then
		inst.AnimState:PlayAnimation(data.anim)
		inst.AnimState:PushAnimation(data.animpush, data.isloop_animpush)
	else
		inst.AnimState:PlayAnimation(data.anim, data.isloop_anim)
	end
end

local function SetFloat(inst, skindata)
	--设置水面动画
	if skindata.floater ~= nil then
		if skindata.floater.fn_anim ~= nil then
			inst.components.floater.SwitchToFloatAnim = function(floater, ...)
				skindata.floater.fn_anim(floater.inst)
			end
		elseif skindata.floater.anim ~= nil then
			inst.components.floater.SwitchToFloatAnim = function(floater, ...)
				SetAnim(floater.inst, skindata.floater.anim)
			end
		else
			inst.components.floater.SwitchToFloatAnim = function(floater, ...)
			end
		end
	else
		inst.components.floater.SwitchToFloatAnim = function(floater, ...)
		end
	end

	--设置地面动画
	if skindata.fn_anim ~= nil then
		inst.components.floater.SwitchToDefaultAnim = function(floater, ...)
			skindata.fn_anim(floater.inst)
		end
	elseif skindata.anim ~= nil and skindata.anim.setable then
		inst.components.floater.SwitchToDefaultAnim = function(floater, ...)
			SetAnim(floater.inst, skindata.anim)
		end
	else
		inst.components.floater.SwitchToDefaultAnim = function(floater, ...)
		end
	end
end

local SkinedLegion = Class(function(self, inst)
	self.inst = inst

	self.isServe = TheNet:GetIsMasterSimulation()
	self.isClient = not TheNet:IsDedicated()
	self.skin = nil
	self._skindata = nil
	self._skin_idx = net_byte(inst.GUID, "skinedlegion._skin_idx", "skin_idx_l_dirty")
	self._floater_cut = nil
	self._floater_nofx = nil

	if not self.isServe and self.isClient then --玩家客户端世界和服务端世界可能是同一个
		--非主机【客户端】环境
        self.inst:ListenForEvent("skin_idx_l_dirty", function()
			local idx = self._skin_idx:value()
            if idx ~= nil and idx ~= 0 and SKIN_IDX_LEGION[idx] ~= nil then
                self.skin = SKIN_IDX_LEGION[idx]
				self.inst.skinname = self.skin --这个变量控制着“审视自我”、“审视他人”时的皮肤设置
			else
				self.skin = nil
				self.inst.skinname = nil
            end
			self:OnSetSkinClient(self:GetSkinData(self.skin), self._skindata)
        end)
    end
end)

------以下均为【服务端、客户端】环境

function SkinedLegion:GetSkin()
	return self.skin
end

function SkinedLegion:GetSkinData(skinname)
	return skinname == nil and SKIN_PREFABS_LEGION[self.inst.prefab] or SKINS_LEGION[skinname]
end

function SkinedLegion:GetSkinedData()
	return self._skindata
end

function SkinedLegion:GetLinkedSkins()
	if self._skindata ~= nil then
		return self._skindata.linkedskins
	else
		return nil
	end
end

function SkinedLegion:Init(prefab)
	self._skindata = SKIN_PREFABS_LEGION[prefab]
end

function SkinedLegion:InitWithFloater(prefab)
	local skindata = SKIN_PREFABS_LEGION[prefab]
	self._skindata = skindata
	if skindata ~= nil and skindata.floater ~= nil then
		local data = skindata.floater
		self.inst:AddComponent("floater")
		if not data.nofx then
			self.inst.components.floater:SetSize(data.size or "small")
			if data.offset_y ~= nil then
				self.inst.components.floater:SetVerticalOffset(data.offset_y)
			end
			if data.scale ~= nil then
				self.inst.components.floater:SetScale(data.scale)
			end
		end
		SetFloat(self.inst, skindata)
		self._floater_cut = data.cut
		self._floater_nofx = data.nofx
		local OnLandedClient_old = self.inst.components.floater.OnLandedClient
		self.inst.components.floater.OnLandedClient = function(floater, ...)
			if self._floater_nofx then
				floater.showing_effect = true
			else
				OnLandedClient_old(floater, ...)
				if self._floater_cut ~= nil then
					floater.inst.AnimState:SetFloatParams(self._floater_cut, 1, floater.bob_percent)
				end
			end
		end
	else
		MakeInventoryFloatable(self.inst)
	end
end

------以下均为【服务端】环境

function SkinedLegion:SetSkin(skinname)
	if not self.isServe or self.skin == skinname then
		return true
	end

	--undo：这里得判断无ID时，从在场所有玩家皮肤数据里判定是否有皮肤

	local skin_data = self:GetSkinData(skinname)
	if skin_data ~= nil then
		self:OnSetSkinServer(skin_data, self._skindata)

		if skinname == nil then --代表恢复原皮肤
			self._skin_idx:set(0)
			self.skin = nil
			self.inst.skinname = nil
		else
			self._skin_idx:set(skin_data.skin_idx)
			self.skin = skinname
			self.inst.skinname = skinname
		end
		self._skindata = skin_data

		return true
	end

	return false
end

function SkinedLegion:OnSave()
	if self.skin ~= nil then
		return { skin = self.skin }
	else
		return nil
	end
end

function SkinedLegion:OnLoad(data)
	if data == nil then
		return
	end

	if data.skin ~= nil then
		self.skin = nil --先还原为原皮肤，才能应用新皮肤
		self.inst.skinname = nil
		self._skindata = self:GetSkinData()
		self:SetSkin(data.skin)
	end
end

function SkinedLegion:SetOnPreLoad(onpreloadfn) --提前加载皮肤数据，好让其他组件应用
	self.inst.OnPreLoad = function(inst, data, ...)
		if data ~= nil then
			if data.skin ~= nil then
				self.skin = data.skin
				self.inst.skinname = data.skin
				self._skindata = self:GetSkinData(data.skin)
			end
		end
		if onpreloadfn ~= nil then
			onpreloadfn(inst, data, ...)
		end
	end
end

function SkinedLegion:SpawnSkinExchangeFx(skinname, tool)
	local skindata = skinname == nil and self._skindata or self:GetSkinData(skinname)
	if skindata ~= nil then
		if skindata.fn_spawnSkinExchangeFx ~= nil then
			skindata.fn_spawnSkinExchangeFx(self.inst)
		elseif skindata.exchangefx ~= nil then
			local fx = nil
			if skindata.exchangefx.prefab ~= nil then
				fx = SpawnPrefab(skindata.exchangefx.prefab)
			elseif tool ~= nil then
				fx = "explode_reskin"
				local skin_fx = SKIN_FX_PREFAB[tool:GetSkinName()]
				if skin_fx ~= nil and skin_fx[1] ~= nil then
					fx = skin_fx[1]
				end
				fx = SpawnPrefab(fx)
			end

			if fx ~= nil then
				if skindata.exchangefx.scale ~= nil then
					fx.Transform:SetScale(skindata.exchangefx.scale, skindata.exchangefx.scale, skindata.exchangefx.scale)
				end
				if skindata.exchangefx.offset_y ~= nil then
					local fx_pos_x, fx_pos_y, fx_pos_z = self.inst.Transform:GetWorldPosition()
					fx_pos_y = fx_pos_y + skindata.exchangefx.offset_y
					fx.Transform:SetPosition(fx_pos_x, fx_pos_y, fx_pos_z)
				else
					fx.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
				end
			end
		end
	end
end

function SkinedLegion:OnSetSkinServer(skindata, skindata_last)
	local inst = self.inst

	--取消前一个皮肤的效果
	if skindata_last ~= nil then
		if skindata_last.fn_end ~= nil then
			skindata_last.fn_end(inst)
		end
	end

	--应用新皮肤的效果
	if skindata ~= nil then
		--动画
		if skindata.fn_anim ~= nil or (skindata.anim ~= nil and skindata.anim.setable) then
			local hasset = false
			if inst.components.floater ~= nil then
				if inst.components.floater:IsFloating() then
					if skindata.floater ~= nil then
						if skindata.floater.fn_anim ~= nil then
							skindata.floater.fn_anim(inst)
							hasset = true
						elseif skindata.floater.anim ~= nil then
							SetAnim(inst, skindata.floater.anim)
							hasset = true
						end
					end
				end
			end
			if not hasset then
				if skindata.fn_anim ~= nil then
					skindata.fn_anim(inst)
				elseif skindata.anim ~= nil and skindata.anim.setable then
					SetAnim(inst, skindata.anim)
				end
			end
		end
		--物品栏图片
		if inst.components.inventoryitem ~= nil and skindata.image ~= nil and skindata.image.setable then
			inst.components.inventoryitem.atlasname = skindata.image.atlas
			inst.components.inventoryitem:ChangeImageName(skindata.image.name)
		end
		--漂浮
		if inst.components.floater ~= nil and skindata.floater ~= nil then
			if not skindata.floater.nofx then
				inst.components.floater:SetSize(skindata.floater.size or "small")
				inst.components.floater:SetVerticalOffset(skindata.floater.offset_y or 0)
				inst.components.floater:SetScale(skindata.floater.scale or 1)
			end
			SetFloat(inst, skindata)
			self._floater_cut = skindata.floater.cut
			self._floater_nofx = skindata.floater.nofx
			if self.isClient and inst.components.floater:IsFloating() then --由于特效已经生成，这里需要更新状态
				inst.components.floater:OnNoLongerLandedClient()
				inst.components.floater:OnLandedClient()
			end
		end
		--placer
		if skindata.placer ~= nil then
			inst.overridedeployplacername = skindata.placer.name
		else
			inst.overridedeployplacername = nil
		end

		if skindata.fn_start ~= nil then
			skindata.fn_start(inst)
		end
	end
end

------以下均为【客户端】环境

function SkinedLegion:OnSetSkinClient(skindata, skindata_last)
	self._skindata = skindata
	local inst = self.inst

	if skindata_last ~= nil then
		if skindata_last.fn_end_c ~= nil then
			skindata_last.fn_end_c(inst)
		end
	end

	if skindata ~= nil then
		--漂浮
		if inst.components.floater ~= nil and skindata.floater ~= nil then
			self._floater_cut = skindata.floater.cut
			self._floater_nofx = skindata.floater.nofx
			if not self._floater_nofx then
				inst.components.floater:SetSize(skindata.floater.size)
				inst.components.floater:SetVerticalOffset(skindata.floater.offset_y or 0)
				inst.components.floater:SetScale(skindata.floater.scale or 1)
			end
			if inst.components.floater:IsFloating() then --由于特效已经生成，这里需要更新状态
				inst.components.floater:OnNoLongerLandedClient()
				inst.components.floater:OnLandedClient()
			end
		end
		--placer
		if skindata.placer ~= nil then
			inst.overridedeployplacername = skindata.placer.name
		else
			inst.overridedeployplacername = nil
		end

		if skindata.fn_start_c ~= nil then
			skindata.fn_start_c(inst)
		end
	end
end

return SkinedLegion
