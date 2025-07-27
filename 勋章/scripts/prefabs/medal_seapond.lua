local FISH_DATA = require("prefabs/oceanfishdef")
local assets =
{
    Asset("ANIM", "anim/medal_seapond.zip"),
    Asset("ANIM", "anim/crater_pool.zip"),
	Asset("ATLAS", "images/medal_seapond.xml"),
	Asset("IMAGE", "images/medal_seapond.tex"),
}

local fish_loot={
	"wobster_sheller_land",--龙虾
	"wobster_moonglass_land",--月光龙虾
}
for k,v in pairs(FISH_DATA.fish) do
	if k~="oceanfish_small_7" and k~="oceanfish_small_8" and k~="oceanfish_small_6" and k~="oceanfish_medium_8" then
		table.insert(fish_loot,k.."_inv")
	end
end

--根据鱼的数量来获取不同的检查语句
local function getstatus(inst)
   
   if inst.components.fishable then
		-- print("还剩"..inst.components.fishable:GetFishPercent())
		if inst.components.fishable:GetFishPercent() <= 0 then
			return "NOTHING"
		end
		if inst.components.fishable:GetFishPercent() <= 0.5 then
			return "LESS"
		end
		return "MANY"
	end
	return "NOTHING"
end

--钓鱼概率
local function GetFish(inst)
	return GetRandomItem(fish_loot)
end
--删除船中心的可燃点
local function findBurnableLocator(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	-- print("坐标"..x..","..y..","..z)
	local ents = TheSim:FindEntities(x, y, z, 1 ,nil , {"INLIMBO"},{"NOBLOCK"})
	-- SpawnPrefab(scalefx).Transform:SetPosition(x,y,z)
	if #ents>0 then
		for i,v in ipairs(ents) do
			-- print(v.prefab)
			if v.prefab=="burnable_locator_medium" then
				-- SpawnPrefab("spawn_fx_tiny").Transform:SetPosition(v.Transform:GetWorldPosition())
				v:Remove()
			end
		end
	end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("refill")
    inst.AnimState:PushAnimation("idle", true)
end
--载体没了我也不活了
local function OnSink(inst)
	if inst:GetCurrentPlatform() == nil and not TheWorld.Map:IsDockAtPoint(inst.Transform:GetWorldPosition()) then
		inst:Remove()
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
    MakeSmallObstaclePhysics(inst, 1.2)
	-- MakeObstaclePhysics(inst, 1.95)
	
    inst.AnimState:SetBank("crater_pool")
    inst.AnimState:SetBuild("medal_seapond")
    inst.AnimState:PlayAnimation("idle",true)
	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
	inst.AnimState:SetScale(1.2, 1.2)

	inst:AddTag("medal_skinable")--可换皮肤
	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = getstatus
	
	inst:AddComponent("fishable")
	inst.components.fishable:SetRespawnTime(TUNING_MEDAL.SEAPOND_FISH_RESPAWN_TIME)--重生时间
	inst.components.fishable.bait_force=0--初始饵力值为0
	inst.components.fishable:SetGetFishFn(GetFish)
	
	inst.components.fishable.maxfish=TUNING_MEDAL.SEAPOND_MAX_NUM--设置最大容量
	inst.components.fishable.fishleft=TUNING_MEDAL.SEAPOND_MAX_NUM--设置初始数量
	
	inst:ListenForEvent("onbuilt", onbuilt)
	inst:ListenForEvent("onsink", OnSink)
	
	-- addOceanFish(inst)
	inst:DoTaskInTime(0.1, function(inst)
		findBurnableLocator(inst)--删除船中心的可燃点
	end)

	inst:AddComponent("medal_skinable")
	

    return inst
end

return Prefab( "medal_seapond", fn, assets),
    MakePlacer("medal_seapond_placer", "medal_seapond", "medal_seapond", "idle")

