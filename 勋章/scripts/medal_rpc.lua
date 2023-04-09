------------------------传送相关RPC---------------------------
AddModRPCHandler(
	"Functional_medal",
	"Delivery",--传送
	function(player, inst, index)
		local medal_delivery = inst.components.medal_delivery
		if medal_delivery ~= nil then
			medal_delivery:Delivery(player, index)
		end
	end
)

AddModRPCHandler(
	"Functional_medal",
	"RemoveMarkPos",--移除标记点
	function(player, inst, index)
		local medal_delivery = inst.components.medal_delivery
		if medal_delivery ~= nil then
			medal_delivery:RemoveMarkPos(index)
		end
	end
)

AddModRPCHandler(
	"Functional_medal",
	"SetTarget",--切换传送目标
	function(player, inst, index)
		local medal_delivery = inst.components.medal_delivery
		if medal_delivery ~= nil then
			medal_delivery:SetTarget(index)
		end
	end
)

AddModRPCHandler(
	"Functional_medal",
	"CloseScreen",--关闭界面
	function(player, inst)
		local medal_delivery = inst.components.medal_delivery
		if medal_delivery ~= nil then
			medal_delivery:CloseScreen()
		end
	end
)

--获取物品信息RPC
AddModRPCHandler(
	"Functional_medal",
	"Showinfo",
	function(player, guid, item)
	if player.player_classified == nil or player.player_classified.net_medal_info==nil then
		return
	end
	if item ~= nil and item.components ~= nil then
		local str=""
		--剩余可钓的鱼数量
		if item:HasTag("fishable") then
			if item.components.fishable then
				if item.components.fishable.bait_force then
					str=str.."\n"..STRINGS.MEDAL_INFO.BAIT_FORCE..item.components.fishable.bait_force
				end
				str=str.."\n"..STRINGS.MEDAL_INFO.FRONT..item.components.fishable.fishleft..STRINGS.MEDAL_INFO.AFTER
			end
		end
		--显示勋章特殊信息
		if item.getMedalInfo then
			local medal_info = item:getMedalInfo()
			if medal_info then
				str = str .."\n".. medal_info
			end
		end
		if str and str ~= "" then
			player.player_classified.net_medal_info:set(guid..";"..str)
		else
			player.player_classified.net_medal_info:set("")
		end
	end
end)

--存储玩家摄像头方向RPC
AddModRPCHandler(
	"Functional_medal",
	"SetCameraHeading",
	function(player, camera_heading)
		-- TheNet:Announce("当前视角:"..camera_heading)
		if player and player.player_classified and player.player_classified.medalcameraheading then
			player.player_classified.medalcameraheading:set(camera_heading)
		end
	end
)

--购买皮肤RPC
AddModRPCHandler(
	"Functional_medal",
	"BuySkin",
	function(player, inst, skinname, skinid, price)
		if inst.buy_skin then
			inst:buy_skin(skinname,skinid,price)
		end
	end
)

--答题RPC
AddModRPCHandler(
	"Functional_medal",
	"MakeChoice",
	function(player, inst, answer)
		if inst.components.medal_examable then
			inst.components.medal_examable:MakeChoice(answer,player)
		end
	end
)