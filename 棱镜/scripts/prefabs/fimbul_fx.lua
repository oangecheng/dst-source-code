--------------------------------------------------------------------------
--[[ 蓝色闪电特效：和官方的区别就是颜色不同而已 ]]
--------------------------------------------------------------------------

local assets_lightning = {
    Asset("ANIM", "anim/lightning.zip"), --官方闪电动画模板
}

local LIGHTNING_MAX_DIST_SQ = 140*140

local function PlayThunderSound(lighting)
	if not lighting:IsValid() or TheFocalPoint == nil then
		return
	end

    local pos = Vector3(lighting.Transform:GetWorldPosition())
    local pos0 = Vector3(TheFocalPoint.Transform:GetWorldPosition())
   	local diff = pos - pos0
    local distsq = diff:LengthSq()

	local k = math.max(0, math.min(1, distsq / LIGHTNING_MAX_DIST_SQ))
	local intensity = math.min(1, k * 1.1 * (k - 2) + 1.1)
	if intensity <= 0 then
		return
	end

    local minsounddist = 10
    local normpos = pos
   	if distsq > minsounddist * minsounddist then
       	--Sound needs to be played closer to us if lightning is too far from player
        local normdiff = diff * (minsounddist / math.sqrt(distsq))
   	    normpos = pos0 + normdiff
    end

    local inst = CreateEntity()

    --[[Non-networked entity]]

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()

    inst.Transform:SetPosition(normpos:Get())
    inst.SoundEmitter:PlaySound("dontstarve/rain/thunder_close", nil, intensity, true)

    inst:Remove()
end

local function StartLightningFX(inst)
	for i, v in ipairs(AllPlayers) do
		local distSq = v:GetDistanceSqToInst(inst)
		local k = math.max(0, math.min(1, distSq / LIGHTNING_MAX_DIST_SQ))
		local intensity = -(k-1)*(k-1)*(k-1)				--k * 0.8 * (k - 2) + 0.8

		if intensity > 0 then
			v:ScreenFlash(intensity <= 0.05 and 0.05 or intensity)
			v:ShakeCamera(CAMERASHAKE.FULL, .7, .02, intensity / 3)
		end
	end
end

local function fn_lightning()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst.Transform:SetScale(2, 2, 2)

    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetLightOverride(1)
    inst.AnimState:SetBank("lightning")
    inst.AnimState:SetBuild("lightning")
    inst.AnimState:PlayAnimation("anim")
    inst.AnimState:SetMultColour(0/255, 159/255, 234/255, 1)    --前三个是颜色值，第四个是透明度

    inst.SoundEmitter:PlaySound("dontstarve/rain/thunder_close", nil, nil, true)

    inst:AddTag("FX")

    --Dedicated server does not need to spawn the local sfx
    if not TheNet:IsDedicated() then
		inst:DoTaskInTime(0, PlayThunderSound)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:DoTaskInTime(0, StartLightningFX) -- so we can use the position to affect the screen flash

    inst.entity:SetCanSleep(false)
    inst.persists = false
    inst:DoTaskInTime(.5, inst.Remove)

    return inst
end

--------------------------------------------------------------------------
--[[ 静电陷阱特效 ]]
--------------------------------------------------------------------------

local assets_static = {
    Asset("ANIM", "anim/fimbul_static_fx.zip"),
    Asset("ANIM", "anim/lavaarena_hammer_attack_fx.zip") --官方熔炉锤子大招特效动画模板
}

local function OnStaticRemove(inst)
    if inst:IsAsleep() then
        inst:Remove()
    else
        inst.AnimState:PlayAnimation("crackle_pst", false)
        inst:ListenForEvent("animover", inst.Remove)
    end
end

local function fn_static()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("lavaarena_hammer_attack_fx")
    inst.AnimState:SetBuild("fimbul_static_fx")
    inst.AnimState:PlayAnimation("crackle_loop", true)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetFinalOffset(1)
    -- inst.AnimState:SetScale(1.5, 1.5)
    inst.AnimState:SetMultColour(140/255, 239/255, 255/255, 1)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
      return inst
    end

    inst.DoRemove = OnStaticRemove

    inst.persists = false

    return inst
end

return Prefab("fimbul_lightning", fn_lightning, assets_lightning),
        Prefab("fimbul_static_fx", fn_static, assets_static)
