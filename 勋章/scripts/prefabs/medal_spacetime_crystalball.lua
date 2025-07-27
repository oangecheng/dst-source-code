local assets =
{
	Asset("ANIM", "anim/medal_spacetime_crystalball.zip"),
	Asset("ATLAS", "images/medal_spacetime_crystalball.xml"),
	Asset("ATLAS_BUILD", "images/medal_spacetime_crystalball.xml",256),
}

--预言(inst,操作者,目标)
local function DoProphesy(inst,doer,target)
	if target == nil or doer == nil or inst.components.finiteuses == nil or inst.components.finiteuses:GetUses() <= 0 then return end
	local uses = inst.components.finiteuses:GetUses()
	--宝藏
	if target.getTreasurePoint and uses>=TUNING_MEDAL.MEDAL_SPACETIME_CRYSTALBALL_USE2  then
		local treasure_data = target:getTreasurePoint()--获取藏宝点信息
		if treasure_data then
			-- print("宝藏世界ID为"..treasure_data.worldid..",坐标为:"..treasure_data.x..","..treasure_data.z)
			--不在一个世界
			if treasure_data.worldid ~= TheShard:GetShardId() then
				MedalSay(doer,STRINGS.READMEDALTREASUREMAP_SPEECH.OTHERWORLD)
			--在很近的范围内，挖掘(1格地皮距离是4)
			elseif doer:GetDistanceSqToPoint(treasure_data.x,0,treasure_data.z) < 6*6 then
				MedalSay(doer,STRINGS.READMEDALTREASUREMAP_SPEECH.NEARBY)
			else--比较远，指路
				SpawnPrefab("medal_treasure_sign").Transform:SetPosition(treasure_data.x,0,treasure_data.z)
				if doer.player_classified ~= nil then
					doer.player_classified.revealmapspot_worldx:set(treasure_data.x)
					doer.player_classified.revealmapspot_worldz:set(treasure_data.z)
					doer:DoTaskInTime(4*FRAMES, function()
						doer.player_classified.revealmapspotevent:push()
						doer.player_classified.MapExplorer:RevealArea(treasure_data.x, 0, treasure_data.z)
					end)
					--宝藏标记移除了之后要更新一下玩家地图信息
					doer:DoTaskInTime(TUNING_MEDAL.MEDAL_TREASURE_SIGN_TIME + 1,function()
						doer.player_classified.MapExplorer:RevealArea(treasure_data.x, 0, treasure_data.z)
					end)
				end

				MedalSay(doer,STRINGS.READMEDALTREASUREMAP_SPEECH.LOCATION)
			end
			if target.ProphesyFn then
				target:ProphesyFn()
			end
			inst.components.finiteuses:Use(TUNING_MEDAL.MEDAL_SPACETIME_CRYSTALBALL_USE2)
			return true
		end
	--奉纳盒
	elseif target.tribute_answer ~= nil and uses>=TUNING_MEDAL.MEDAL_SPACETIME_CRYSTALBALL_USE2 and target.ProphesyFn ~= nil then
		target:ProphesyFn(doer)
		inst.components.finiteuses:Use(TUNING_MEDAL.MEDAL_SPACETIME_CRYSTALBALL_USE2)
		return true
	elseif uses >= TUNING_MEDAL.MEDAL_SPACETIME_CRYSTALBALL_USE1 then
		local code = nil
		--三种书
		if target.ProphesyFn then
			code = target:ProphesyFn(doer)
		--不朽果实
		elseif target.prefab=="immortal_fruit_oversized" then
			code = GetMedalRandomItem(TUNING_MEDAL.IMMORTAL_FRUIT_VARIATION_ROOT, target)--返回权重增值后的随机key
		end
		if code then
			local str = STRINGS.PROPHESYSPEECH[string.upper(code)]
			if str then
				MedalSay(doer,str)
			else
				str = STRINGS.NAMES[string.upper(code)] or STRINGS.PROPHESYNAMESPEECH[string.upper(code)] or code
				MedalSay(doer,STRINGS.PROPHESYSPEECH.PREFIX..str)
			end
			inst.components.finiteuses:Use(TUNING_MEDAL.MEDAL_SPACETIME_CRYSTALBALL_USE1)
			return true
		end
	end
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("medal_spacetime_crystalball")
	inst.AnimState:SetBuild("medal_spacetime_crystalball")
	inst.AnimState:PlayAnimation("idle")

	inst.medal_repair_common={--可补充耐久
		medal_spacetime_lingshi=TUNING_MEDAL.MEDAL_SPACETIME_LINGSHI_ADDUSE,--时空灵石
		medal_time_slider=TUNING_MEDAL.MEDAL_TIME_SLIDER_ADDUSE,--时空碎片
	}
	
	MakeInventoryFloatable(inst, "med", nil, 0.75)
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "medal_spacetime_crystalball"
	inst.components.inventoryitem.atlasname = "images/medal_spacetime_crystalball.xml"
	
	-- inst.OnPlayedBellFn=OnPlayed
    
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING_MEDAL.MEDAL_SPACETIME_CRYSTALBALL_MAXUSES)
    inst.components.finiteuses:SetUses(TUNING_MEDAL.MEDAL_SPACETIME_CRYSTALBALL_MAXUSES)
    -- inst.components.finiteuses:SetOnFinished(inst.Remove)
	-- inst.components.finiteuses:SetOnFinished(OnFinished)

	inst.DoProphesy=DoProphesy
	
	MakeHauntableLaunch(inst)
	return inst
end

return Prefab("medal_spacetime_crystalball", fn, assets)