local prefabs =
{
    "marble",
    "rock_break_fx",
}

--通用敲矿回调函数
local function onworkfn_common(inst, worker, workleft)
	if workleft <= 0 then
		local pos = inst:GetPosition()
		SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
		inst.components.lootdropper:DropLoot(pos)
		inst:Remove()
	else
		inst.AnimState:PlayAnimation(
			(workleft < TUNING.MARBLEPILLAR_MINE / 3 and "low") or
			(workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 and "med") or
			"full"
		)
	end
end

local function MakeStatue(def)
	local function fn()
		local inst = CreateEntity()
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddMiniMapEntity()
		inst.entity:AddNetwork()
		
		if not def.nophysics then
			MakeObstaclePhysics(inst, 0.66)
		end
		
		inst.entity:AddTag("statue")
		
		inst.AnimState:SetBank(def.bank)
		inst.AnimState:SetBuild(def.build)
		if def.symbol then
			inst.AnimState:OverrideSymbol("swap_statue", def.symbol, "swap_statue")
		end
		inst.AnimState:PlayAnimation(def.anim)
		if def.minimap then
			inst.MiniMapEntity:SetIcon(def.minimap)
		end
		inst:AddTag("dustable")--可被尘蛾互动
		inst:AddTag("event_trigger")--防止被暗影仆从镐击了
		inst:AddTag("structure")--建筑,防投石机
		inst:AddTag("sculpture")--雕刻,防投石机
		--特定标签
		if def.taglist then
			for _,v in ipairs(def.taglist) do
				inst:AddTag(v)
			end
		end
		
		inst.entity:SetPristine()
		
		if not TheWorld.ismastersim then
		    return inst
		end
		
		inst:AddComponent("lootdropper")
		
		inst:AddComponent("inspectable")
		-- inst.components.inspectable:SetDescription(STRINGS.CHARACTERS.GENERIC.DESCRIBE.MEDAL_STATUE_MARBLE_MUSE1)
		if def.getstatus then inst.components.inspectable.getstatus = def.getstatus end
		
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.MINE)
		inst.components.workable:SetWorkLeft(def.workleft or TUNING.MARBLEPILLAR_MINE)
		inst.components.workable:SetOnWorkCallback(def.onworkfn or onworkfn_common)
		inst.components.workable.savestate = true
		inst.components.workable:SetOnLoadFn(function(inst)
			if def.onworkfn then
				def.onworkfn(inst, nil, inst.components.workable.workleft)
			else
				onworkfn_common(inst, nil, inst.components.workable.workleft)
			end
		end)
		
		MakeHauntableWork(inst)

		--主机额外扩展函数
		if def.masterfn then
			def.masterfn(inst)
		end
		
		return inst
	end
	return Prefab(def.name, fn, def.assets, prefabs)
end

local statues = {}
for i, v in ipairs(require("medal_defs/medal_statue_defs")) do
    table.insert(statues, MakeStatue(v))
	table.insert(statues,MakePlacer(v.name.."_placer", v.bank, v.symbol or v.build, v.anim))
end
return unpack(statues)