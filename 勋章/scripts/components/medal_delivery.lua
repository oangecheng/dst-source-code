local function ondeliverier(self, deliverier)
    self.inst.replica.medal_delivery:SetDeliverier(deliverier)
end

local function NoHoles(pt)
    return not TheWorld.Map:IsPointNearHole(pt)
end

local function NoPlayersOrHoles(pt)
    return not (IsAnyPlayerInRange(pt.x, 0, pt.z, 2) or TheWorld.Map:IsPointNearHole(pt))
end
--获取目标传送点
local function GetTeleportPt(obj,target,pos)
	local target_x, target_y, target_z
    local offset = pos~=nil and 0 or 2--坐标偏移值
	if target~=nil then
		target_x, target_y, target_z = target.Transform:GetWorldPosition()
	elseif pos~=nil then
		target_x, target_y, target_z = pos.x, pos.y, pos.z
	else
		return
	end
	
	--是否是水生生物
	local is_aquatic = obj.components.locomotor ~= nil and obj.components.locomotor:IsAquatic()
	
	if offset ~= 0 then
	    local pt = Vector3(target_x, target_y, target_z)
	    local angle = math.random() * 2 * PI
	
	    if not is_aquatic then
	        offset =
	            FindWalkableOffset(pt, angle, offset, 8, true, false, NoPlayersOrHoles) or
	            FindWalkableOffset(pt, angle, offset * .5, 6, true, false, NoPlayersOrHoles) or
	            FindWalkableOffset(pt, angle, offset, 8, true, false, NoHoles) or
	            FindWalkableOffset(pt, angle, offset * .5, 6, true, false, NoHoles)
	    else
	        offset =
	            FindSwimmableOffset(pt, angle, offset, 8, true, false, NoPlayersOrHoles) or
	            FindSwimmableOffset(pt, angle, offset * .5, 6, true, false, NoPlayersOrHoles) or
	            FindSwimmableOffset(pt, angle, offset, 8, true, false, NoHoles) or
	            FindSwimmableOffset(pt, angle, offset * .5, 6, true, false, NoHoles)
	    end
	
	    if offset ~= nil then
	        target_x = target_x + offset.x
	        target_z = target_z + offset.z
	    end
	end
	
	local ocean_at_point = TheWorld.Map:IsOceanAtPoint(target_x, target_y, target_z, false)
	if ocean_at_point then
	    local terrestrial = obj.components.locomotor ~= nil and obj.components.locomotor:IsTerrestrial()
	    if terrestrial then
	        -- print("旱鸭子别下海")
			return
	    end
	else
	    if is_aquatic then
	        -- print("水猴子就别上岸了")
			return
	    end
	end

	return target_x, target_y, target_z
end
--传送至目标点(传送对象,传送目标物,传送坐标点)
local function Teleport(obj,target,pos)
    local target_x, target_y, target_z = GetTeleportPt(obj,target,pos)
	if target_x ~= nil then
		if obj.Physics ~= nil then
			obj.Physics:Teleport(target_x, target_y, target_z)
			return true
		elseif obj.Transform ~= nil then
			obj.Transform:SetPosition(target_x, target_y, target_z)
			return true
		end
	end
end
--格式化传送点列表
local function initMarkList(oldtable)
	local maxnum=0
	local newtable={}
	for k,v in pairs(oldtable) do
		maxnum=math.max(k,maxnum)
	end
	if maxnum>0 then
		for i=1,maxnum do
			if oldtable[i] then
				newtable[#newtable+1]=oldtable[i]
			end
		end
	end
	return newtable
end

local Medal_Delivery =Class(function(self, inst)
	self.inst = inst
	self.inst:AddTag("medal_delivery")
	self.townportals_list={}--传送点列表
	self.mark_list={}--标记点,子表格式--{title="0点",x=0,y=0,z=0,worldid=0}
	--获取传送塔列表
	self.getTownportals=function(inst,townportals)
		self.townportals_list={}--清空传送塔列表
		if (townportals and #townportals>0) or (self.mark_list and #self.mark_list>0) or (inst.prefab=="medal_spacetime_runes" and #AllPlayers>1) then
			local index_num=0--传送塔编号
			local info_list={--传送塔信息表，用于界面显示
				title = inst.prefab=="townportal" and inst.components.writeable and inst.components.writeable:GetText() or inst:GetDisplayName() or STRINGS.DELIVERYSPEECH.NONAME,--标题
				towninfo={}--传送塔信息
			}
			local isrunes = inst.prefab == "medal_spacetime_runes"
			--时空符文要遍历玩家列表
			if isrunes then
				local owner = inst.components.inventoryitem and inst.components.inventoryitem:GetGrandOwner()
				for i, v in ipairs(AllPlayers) do
					if v ~= owner then
						index_num=index_num+1
						local title = v:GetDisplayName() or v.prefab or STRINGS.DELIVERYSPEECH.NONAMECHEST--标题
						if title =="" then
							title=STRINGS.DELIVERYSPEECH.NONAMECHEST
						end
							
						--将各个玩家信息录入表内
						self.townportals_list[index_num]={
							title=title,--目标名字
							item=v,--目标
						}
						--将传送塔信息录入传送塔信息表
						info_list.towninfo[index_num]={
							index=index_num,--索引
							title=title,--传送塔标题
							isplayer=true,--是否是玩家目标
						}
					end
				end
			end
			--遍历传送塔列表
			for i, v in ipairs(townportals) do
				if v ~= inst then
					local distance=v:GetDistanceSqToInst(inst)--距离
					local consume = (not isrunes) and math.floor(math.clamp(math.floor(math.sqrt(distance)/20), 10, 40)*TUNING_MEDAL.SPEED_MEDAL.CONSUME_MULT)--消耗
					local title=v.components.writeable and v.components.writeable:GetText() or STRINGS.DELIVERYSPEECH.NONAME--标题
					if title =="" then
						title=STRINGS.DELIVERYSPEECH.NONAME
					end
					if title ~= "Hide" and title ~= "隐藏" then 
						index_num=index_num+1
						--将各个传送塔信息录入表内
						self.townportals_list[index_num]={
							title=title,--传送塔标题
							item=v,--目标传送塔
							consume=consume--消耗
						}
						--将传送塔信息录入传送塔信息表
						info_list.towninfo[index_num]={
							index=index_num,--索引
							title=title,--传送塔标题
							consume=consume--消耗
						}
					end
				end
			end
			--遍历标记点列表
			for i, v in ipairs(self.mark_list) do
				index_num=index_num+1
				local distance=inst:GetDistanceSqToPoint(v.x or 0, v.y or 0, v.z or 0)--距离
				local consume = v.worldid~=TheShard:GetShardId() and 40 or math.clamp(math.floor(math.sqrt(distance)/20), 10, 40)--消耗(跨服传送消耗拉满)
				consume = math.floor(consume*TUNING_MEDAL.SPEED_MEDAL.CONSUME_MULT)--根据难度调整总消耗
				local title=v.title or STRINGS.DELIVERYSPEECH.NONAMEPOS--标题
				if title =="" then
					title=STRINGS.DELIVERYSPEECH.NONAMEPOS
				end
				--将传送点信息录入表内
				self.townportals_list[index_num]={
					mark_index=i,--坐标索引
					title=title,--传送点标题
					pos={x = v.x or 0, y = v.y or 0, z = v.z or 0, worldid = v.worldid},--目标传送点
					consume=consume,--消耗
					islingshi=v.islingshi,--是否是临时传送点(一次性)
				}
				--将传送点信息录入信息表
				info_list.towninfo[index_num]={
					index=index_num,--索引
					title=title,--传送点标题
					consume=consume,--消耗
					ispos=true,--是否是坐标点
					islingshi=v.islingshi,--是否是临时传送点(一次性)
					otherworld=v.worldid~=TheShard:GetShardId(),--是否是跨世界传送
				}
			end
			
			local info_str=json.encode(info_list)
			inst.deliverylist:set(info_str)
		else
			inst.deliverylist:set("")--清空字符串
		end
	end
	self.inst:ListenForEvent("get_medal_townportals", self.getTownportals)

	self.hyperspace_chests_list={}--超时空宝箱列表
	--获取超时空宝箱列表
	self.getHyperspaceChests=function(inst,hyperspacechests)
		self.hyperspace_chests_list={--初始化目标列表
			{--无目标
				title=STRINGS.DELIVERYSPEECH.CANCLEBIND,
				item=nil,
			},
		}
		if hyperspacechests and #hyperspacechests>0 then
			local index_num=1--编号
			local info_list={--宝箱信息表，用于界面显示
				title = STRINGS.DELIVERYSPEECH.CHOOSETARGET,--标题
				towninfo={
					{
						index=index_num,--索引
						title=STRINGS.DELIVERYSPEECH.CANCLEBIND,--传送塔标题
						ischest=true,--是宝箱
					},
				}--宝箱信息
			}
			
			for i, v in ipairs(hyperspacechests) do
				index_num=index_num+1
				local title=v.components.writeable and v.components.writeable:GetText() or STRINGS.DELIVERYSPEECH.NONAMECHEST--标题
				if title =="" then
					title=STRINGS.DELIVERYSPEECH.NONAMECHEST
				end
					
				--将各个宝箱信息录入表内
				self.hyperspace_chests_list[index_num]={
					title=title,--宝箱标题
					item=v,--目标宝箱
				}
				--将传送塔信息录入传送塔信息表
				info_list.towninfo[index_num]={
					index=index_num,--索引
					title=title,--传送塔标题
					ischest=true,--是宝箱
				}
			end
			
			local info_str=json.encode(info_list)
			inst.deliverylist:set(info_str)
		else
			inst.deliverylist:set("")--清空字符串
		end
	end
	self.inst:ListenForEvent("get_medal_hyperspacechests", self.getHyperspaceChests)
	
	self.deliverier = nil
    self.screen = nil
	self.onclosepopups = function(doer) -- yay closures ~gj -- yay ~v2c
        if doer == self.deliverier then
            self:CloseScreen()
        end
    end
end,
nil,
{
    deliverier = ondeliverier,
})

--开始传送
function Medal_Delivery:Delivery(deliverier,index)
	local talker=self.inst and self.inst.components.talker or deliverier.components.talker--对话组件
	if #self.townportals_list > 0 then
		if self.townportals_list[index] then
			local pos=self.townportals_list[index].pos--读取目标点
			local target=self.townportals_list[index].item--读取目标
			local consume=self.townportals_list[index].consume--读取消耗
			local medal = deliverier.components.inventory and deliverier.components.inventory:EquipMedalWithTag("candelivery")
			if self.inst.prefab=="medal_spacetime_runes" then
				--时空符文传送不消耗时空之力
				local x,y,z = GetTeleportPt(deliverier,target)
				if x and z then
					deliverier.sg:GoToState("pocketwatch_warpback",{warpback={dest_x = x, dest_y = 0, dest_z = z}})
					if self.inst.components.stackable then
						self.inst.components.stackable:Get():Remove()
					else
						self.inst:Remove()
					end
				elseif talker then
					talker:Say(STRINGS.DELIVERYSPEECH.ERRORPOS)
				end
			elseif consume and medal then
				if medal.components.finiteuses then
					local uses=medal.components.finiteuses:GetUses()
					if uses >= consume then
						self.consume=consume--记录消耗
						if target then
							--执行传送sg
							deliverier.sg:GoToState("medal_entertownportal", { teleporter = self.inst,target=target })
						elseif pos then
							medal.components.finiteuses:Use(self.consume)--扣除耐久
							deliverier.sg:GoToState("pocketwatch_warpback",{warpback={dest_worldid = pos.worldid, dest_x = pos.x, dest_y = 0, dest_z = pos.z}})
							--是临时传送点的话,传完就把锚点删了(不生成虫洞)
							if self.townportals_list[index].islingshi then
								self:RemoveMarkPos(index,true)
							end
						end
					else--耐久不足
						if talker then
							talker:Say(STRINGS.DELIVERYSPEECH.NOCONSUME)
						end
					end
				end
			end
		else--目标传送塔不存在
			if talker and index then
				talker:Say(STRINGS.DELIVERYSPEECH.CANTFINDTARGET)
			end
		end
	else--暂无可传送传送塔
		if talker then
			talker:Say(STRINGS.DELIVERYSPEECH.NOTARGET)
		end
	end
	self:CloseScreen()
end

--是否应该传送追随者
local function ShouldTeleportFollower(follower)
    if follower.components.follower and follower.components.follower.noleashing then
        return false
    end

    if follower.components.inventoryitem and follower.components.inventoryitem:IsHeld() then
        return false
    end

    return true
end

--执行传送
function Medal_Delivery:Activate(deliverier,target)
	if self.inst and deliverier and target and target:IsValid() then
		--目标传送塔传送人数+1,如果有被激活函数则执行对应函数
		if target.components.teleporter ~= nil then
			if target.components.teleporter.onActivateByOther ~= nil then
				target.components.teleporter.onActivateByOther(target, self.inst, deliverier)
			end
			target.components.teleporter.numteleporting = target.components.teleporter.numteleporting + 1
		end
		--对传送者进行传送
		Teleport(deliverier,target)
		--进行耐久消耗
		local medal = deliverier.components.inventory and deliverier.components.inventory:EquipMedalWithTag("candelivery")
		if medal and medal.components.finiteuses and self.consume then
			medal.components.finiteuses:Use(self.consume)--扣除耐久
		end
		self.consume=nil
		--目标传送塔执行接收操作
		if target.components.teleporter ~= nil then
			if deliverier:HasTag("player") then
				target.components.teleporter:ReceivePlayer(deliverier)
			elseif deliverier.components.inventoryitem ~= nil then
				target.components.teleporter:ReceiveItem(deliverier)
			end
		end
		--如果传送者有跟随者也一起传送走
		if deliverier.components.leader ~= nil then
			for follower, v in pairs(deliverier.components.leader.followers) do
				if ShouldTeleportFollower(follower) then
					Teleport(follower,target)
				end
			end
		end


		--如果传送者身上的道具有跟随者，也一并传走(眼骨、格罗姆花等)
		if deliverier.components.inventory ~= nil then
			for k, item in pairs(deliverier.components.inventory.itemslots) do
				if item.components.leader ~= nil then
					for follower, v in pairs(item.components.leader.followers) do
						if ShouldTeleportFollower(follower) then
							Teleport(follower,target)
						end
					end
				end
			end
			for k, equipped in pairs(deliverier.components.inventory.equipslots) do
				if equipped.components.container ~= nil then
					for j, item in pairs(equipped.components.container.slots) do
						if item.components.leader ~= nil then
							for follower, v in pairs(item.components.leader.followers) do
								if ShouldTeleportFollower(follower) then
									Teleport(follower,target)
								end
							end
						end
					end
				end
			end
		end
	end
end

--弹出界面
function Medal_Delivery:OpenScreen(doer)
    if self.deliverier == nil then
        TheWorld:PushEvent("medal_touchdelivery", self.inst)--推送
		self.inst:StartUpdatingComponent(self)
        self.deliverier = doer
        self.inst:ListenForEvent("ms_closepopups", self.onclosepopups, doer)
        self.inst:ListenForEvent("onremove", self.onclosepopups, doer)

        if doer.HUD ~= nil then
            self.screen = doer.HUD:ShowMedalTownportalScreen(self.inst)--显示目的地界面
        end
	else--使用中
		MedalSay(self.inst,STRINGS.DELIVERYSPEECH.INUSE)
	end
end
--关闭界面
function Medal_Delivery:CloseScreen()
    if self.deliverier ~= nil then
        self.inst:StopUpdatingComponent(self)

        if self.screen ~= nil then
            self.deliverier.HUD:CloseMedalTownportalScreen()
            self.screen = nil
        end

        self.inst:RemoveEventCallback("ms_closepopups", self.onclosepopups, self.deliverier)
        self.inst:RemoveEventCallback("onremove", self.onclosepopups, self.deliverier)

		if IsXB1() then
			if self.deliverier:HasTag("player") and self.deliverier:GetDisplayName() then
				local ClientObjs = TheNet:GetClientTable()
				if ClientObjs ~= nil and #ClientObjs > 0 then
					for i, v in ipairs(ClientObjs) do
						if self.deliverier:GetDisplayName() == v.name then
							self.netid = v.netid
							break
						end
					end
				end
			end
		end

        self.deliverier = nil
    elseif self.screen ~= nil then
        --Should not have screen and no deliverier, but just in case...
        if self.screen.inst:IsValid() then
            self.screen:Kill()
        end
        self.screen = nil
    end
	self.mark_list = initMarkList(self.mark_list)
end

--添加标记点
function Medal_Delivery:AddMarkPos()
	local x,y,z=self.inst.Transform:GetWorldPosition()--坐标
	local txt=self.inst.components.writeable and self.inst.components.writeable:GetText() or (STRINGS.DELIVERYSPEECH.POS..(#self.mark_list+1))
	self.mark_list[#self.mark_list+1]={title=txt,x=x,y=0,z=z,worldid=TheShard:GetShardId(),islingshi=self.inst.islingshi}
	self.inst.islingshi=nil--清除临时标记
	SpawnPrefab("pocketwatch_heal_fx").Transform:SetPosition(x,y,z)
end

--移除标记点(索引,不生成虫洞)
function Medal_Delivery:RemoveMarkPos(index,nospawn)
	if index==nil then return end
	if self.townportals_list and self.townportals_list[index] then
		local mark_index=self.townportals_list[index].mark_index
		if mark_index and  self.mark_list and self.mark_list[mark_index] then
			-- if not self.mark_list[mark_index].islingshi then
			if not nospawn then
				local pt = self.inst:GetPosition()
				local offset = FindWalkableOffset(pt, math.random() * 2 * PI, 1 + math.random(), 16, false, true, NoHoles, true, true)
								or FindWalkableOffset(pt, math.random() * 2 * PI, 3 + math.random(), 16, false, true, NoHoles, true, true)
								or FindWalkableOffset(pt, math.random() * 2 * PI, 5 + math.random(), 16, false, true, NoHoles, true, true)
				if offset ~= nil then
					pt = pt + offset
				end
				local portal = SpawnPrefab("pocketwatch_portal_entrance")
				portal.Transform:SetPosition(pt:Get())
				portal:SpawnExit(self.mark_list[mark_index].worldid, self.mark_list[mark_index].x, self.mark_list[mark_index].y, self.mark_list[mark_index].z)
			end
			-- inst.SoundEmitter:PlaySound("wanda1/wanda/portal_entrance_pre")
			-- table.remove(self.mark_list,mark_index)
			self.mark_list[mark_index]=nil
		end
	end
end

--切换传送目标
function Medal_Delivery:SetTarget(index)
	if index==nil then return end
	if self.hyperspace_chests_list and self.hyperspace_chests_list[index] then
		if self.inst.changeTarget then
			self.inst:changeTarget(self.hyperspace_chests_list[index].item)
		end
		self:CloseScreen()
	end
end

function Medal_Delivery:OnSave() 
	return  {mark_list=deepcopy(self.mark_list)}
end

function Medal_Delivery:OnLoad(data)       
	if data and data.mark_list then
        self.mark_list = deepcopy(data.mark_list)
	end
end

--------------------------------------------------------------------------
--检查自动关闭的条件
--------------------------------------------------------------------------

function Medal_Delivery:OnUpdate(dt)
	if self.deliverier == nil then
        self.inst:StopUpdatingComponent(self)
    elseif (self.deliverier.components.rider ~= nil and
            self.deliverier.components.rider:IsRiding())
        or not (self.deliverier:IsNear(self.inst, 3) and
                CanEntitySeeTarget(self.deliverier, self.inst)) then
        self:CloseScreen()
    end
end

--------------------------------------------------------------------------

function Medal_Delivery:OnRemoveFromEntity()
    self:CloseScreen()
end

Medal_Delivery.OnRemoveEntity = Medal_Delivery.CloseScreen

return Medal_Delivery
