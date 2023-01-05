local assets =
{
	Asset("ANIM", "anim/medal_naughtybell.zip"),
	Asset("ANIM", "anim/medal_naughtybell_skin1.zip"),
	Asset("ANIM", "anim/medal_naughtybell_skin2.zip"),
	Asset("ATLAS", "images/medal_naughtybell.xml"),
	Asset("ATLAS_BUILD", "images/medal_naughtybell.xml",256),
}

--召唤小偷(玩家,是否是摇铃铛者)
local function CallKrampus(player,ismusician)
	local thiefNum=math.random(ismusician and TUNING_MEDAL.BELL_THIEFNUM_NOMAL or TUNING_MEDAL.BELL_THIEFNUM_LESS)--小偷数量
	local sanityLoss=TUNING_MEDAL.BELL_SANITYLOSS_NORMAL--精神损失
	local needSay=STRINGS.NAUGHTYBELLSPEECH.ONPLAYED--感叹词
	
	--装备淘气铃铛小偷数量加成
	if player:HasTag("naughtymedal") then
		--小概率惹怒小偷
		if ismusician and math.random() < TUNING_MEDAL.BELL_PROVOKE_THIEF_CHANCE then
			thiefNum=TUNING_MEDAL.BELL_THIEFNUM_MAX
			sanityLoss=TUNING_MEDAL.BELL_SANITYLOSS_MAX
			needSay=STRINGS.NAUGHTYBELLSPEECH.MAKETROUBLE
		else
			thiefNum=thiefNum+TUNING_MEDAL.BELL_THIEFNUM_MEDAL_ADDITION
			sanityLoss=TUNING_MEDAL.BELL_SANITYLOSS_MORE
		end
	end
	
	if player and player.components.sanity then
		--启蒙值模式就加启蒙值，否则扣精神
		if player.components.sanity:IsLunacyMode() then
			sanityLoss = -sanityLoss
			needSay=STRINGS.NAUGHTYBELLSPEECH.ONLUNARISLAND
		end
		player.components.sanity:DoDelta(thiefNum*sanityLoss)
		
		--如果精神值为空或者启蒙值为满，都会额外扣除一定血量
		if (player.components.sanity:IsLunacyMode() and player.components.sanity:GetPercent()>=1) or (player.components.sanity:IsInsanityMode() and player.components.sanity:GetPercent()<=0) then
			player.components.health:DoDelta(TUNING_MEDAL.NAUGHTYBELL_HEALTH_LOSE*thiefNum)
		end
	end
	MedalSay(player,ismusician and needSay or STRINGS.NAUGHTYBELLSPEECH.LISTENER)--感叹词
	SpawnNaughtyKrampus(player,thiefNum)--召唤小偷
end

--演奏
local function OnPlayed(inst, musician)
	local x,y,z = musician.Transform:GetWorldPosition()
	local players = FindPlayersInRange(x, y, z, 10, true)

	local count = 0
	for i, v in ipairs(players) do
		if v==musician then--演奏者必定能招
			CallKrampus(v,true)
		elseif count<4 then--最多有4个聆听者能生效
			count = count + 1
			CallKrampus(v)
		end
	end
	if count <= 0 then
		local ents = TheSim:FindEntities(x, y, z, 10, {"equipmentmodel"})
		for i, v in ipairs(ents) do
			if v.prefab=="sewing_mannequin" then
				SpawnNaughtyKrampus(musician,1)--召唤小偷
				break
			end
		end
	end
end
--闪光
local function shine(inst)
    inst.task = nil
    inst.AnimState:PlayAnimation("sparkle")
    inst.AnimState:PushAnimation("idle")
    inst.task = inst:DoTaskInTime(4+math.random()*5, function() shine(inst) end)
end
--被小偷和鼹鼠偷走时如果附近有玩家则召唤一只暗夜坎普斯
local function OnPutInInv(inst, owner)
    if owner.prefab == "mole" or owner.prefab == "krampus" then
        --有耐久才触发彩蛋
		if inst.components.finiteuses and inst.components.finiteuses:GetUses()>0 then
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/glommer_bell")
			local x, y, z = owner.Transform:GetWorldPosition()
			local players = FindPlayersInRange(x, y, z, 10, true)
			local closestplayer = FindClosestPlayerInRange(x,y,z,10,true)
			for i, v in ipairs(players) do
				--最近的玩家有概率直接召唤一只暗夜坎普斯
				if v==closestplayer and math.random()<.1 then
					MakeRageKrampusForPlayer(closestplayer)
				else
					CallKrampus(v)
				end
			end
			inst:Remove()
		end
    end
end
--耐久用完
local function OnFinished(inst)
	if inst.components.instrument~=nil then
		inst:RemoveComponent("instrument")
	end
end
--添加演奏组件
local function setInstrument(inst)
	inst:AddComponent("instrument")
	inst.components.instrument:SetOnPlayedFn(OnPlayed)
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("medal_naughtybell")
	inst.AnimState:SetBuild("medal_naughtybell")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("bell")
	inst:AddTag("molebait")--鼹鼠诱饵
	inst:AddTag("medal_skinable")--可换皮肤

	inst.medal_repair_common={--可补充耐久
		-- glommerfuel = 1,--格罗姆黏液
		-- glommerwings = 1,--格罗姆翅膀
		-- glommerflower = 1,--格罗姆之花
		medal_glommer_essence = 1,--格罗姆精华
	}
	
	MakeInventoryFloatable(inst, "med", nil, 0.75)
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "medal_naughtybell"
	inst.components.inventoryitem.atlasname = "images/medal_naughtybell.xml"
    --被偷走
    inst:ListenForEvent( "onstolen", function(inst, data) 
        if data.thief.components.inventory then
            data.thief.components.inventory:GiveItem(inst)
        end 
    end)
    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInv)
    
    setInstrument(inst)
	
	-- inst.OnPlayedBellFn=OnPlayed

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.PLAY)
    
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING_MEDAL.NAUGHTYBELL_MAX_USETIME)
    inst.components.finiteuses:SetUses(TUNING_MEDAL.NAUGHTYBELL_MAX_USETIME)
    -- inst.components.finiteuses:SetOnFinished(inst.Remove)
	inst.components.finiteuses:SetOnFinished(OnFinished)
    inst.components.finiteuses:SetConsumption(ACTIONS.PLAY, 1)
	inst:ListenForEvent("percentusedchange", function(inst,data)
		if data and data.percent then
			--耐久用完后补充耐久
			if data.percent>0 and inst.components.instrument==nil then
				setInstrument(inst)
			end
		end
	end)
    shine(inst)

	inst:AddComponent("medal_skinable")
	
	MakeHauntableLaunch(inst)
	return inst
end

return Prefab("medal_naughtybell", fn, assets)