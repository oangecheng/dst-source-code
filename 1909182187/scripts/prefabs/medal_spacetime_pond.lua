local FISH_DATA = require("prefabs/oceanfishdef")
local assets =
{
    Asset("ANIM", "anim/medal_spacetime_pond.zip"),
	Asset("ANIM", "anim/pocketwatch_portal_fx.zip"),
}

local fish_loot={
	"wobster_sheller_land",--龙虾
	"wobster_moonglass_land",--月光龙虾
	"lavaeel",--熔岩鳗鱼
	"pondeel",--鳗鱼
	"pondfish",--淡水鱼
	"wetpouch",--塑料袋
}
for k,v in pairs(FISH_DATA.fish) do
	if k~="oceanfish_small_7" and k~="oceanfish_small_8" and k~="oceanfish_small_6" and k~="oceanfish_medium_8" then
		table.insert(fish_loot,k.."_inv")
	end
end

--钓鱼概率
local function GetFish(inst)
	return GetRandomItem(fish_loot)
end

--消失
local function Disappear(inst)
	inst.AnimState:PlayAnimation("portal_entrance_pst")
	inst.persists = false
	inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() + 1, inst.Remove)
end
--计时器结束
local function OnTimerDone(inst, data)
	if data and data.name == "disappear" then
		Disappear(inst)
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
    MakeSmallObstaclePhysics(inst, 1.2)
	inst.AnimState:SetBank("pocketwatch_portal_fx")
    -- inst.AnimState:SetBuild("pocketwatch_portal_fx")
    inst.AnimState:SetBuild("medal_spacetime_pond")
    inst.AnimState:PlayAnimation("portal_entrance_pre")
    inst.AnimState:PushAnimation("portal_entrance_loop", true)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetSortOrder(-1)
	inst.AnimState:Hide("front")
	inst.AnimState:Hide("water_shadow")
	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")

	inst:AddComponent("timer")
	inst.components.timer:StartTimer("disappear", TUNING_MEDAL.SPACETIME_POND_EXISTENCE_TIME)
	inst:ListenForEvent("timerdone", OnTimerDone)
	
	inst:AddComponent("fishable")
	-- inst.components.fishable:SetRespawnTime(TUNING_MEDAL.SEAPOND_FISH_RESPAWN_TIME)--重生时间
	-- inst.components.fishable.bait_force=0--初始饵力值为0
	inst.components.fishable:SetGetFishFn(GetFish)
	
	inst.components.fishable.maxfish=TUNING_MEDAL.SPACETIME_POND_MAX_NUM--设置最大容量
	inst.components.fishable.fishleft=TUNING_MEDAL.SPACETIME_POND_MAX_NUM--设置初始数量

	inst:ListenForEvent("medal_fishingcollect",function(inst,data)
		if inst.components.fishable and inst.components.fishable.fishleft<=0 then
			Disappear(inst)--鱼没了直接消失
		end
	end)
	

    return inst
end

return Prefab( "medal_spacetime_pond", fn, assets)

