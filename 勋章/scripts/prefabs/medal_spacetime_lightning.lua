local assets =
{
    Asset("ANIM", "anim/moonstorm_lightningstrike.zip"),
    Asset("ANIM", "anim/medal_spacetime_lightningstrike.zip"),
}

local LIGHTNING_MAX_DIST_SQ = 140*140
--打雷音效
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
--闪电光效
local function StartFX(inst)
	for i, v in ipairs(AllPlayers) do
		local distSq = v:GetDistanceSqToInst(inst)
		local k = math.max(0, math.min(1, distSq / LIGHTNING_MAX_DIST_SQ))
		local intensity = -(k-1)*(k-1)*(k-1)				--k * 0.8 * (k - 2) + 0.8

		--print("StartFX", k, intensity)
		if intensity > 0 then
			v:ScreenFlash(intensity <= 0.05 and 0.05 or intensity)
			v:ShakeCamera(CAMERASHAKE.FULL, .7, .02, intensity / 3)
		end
	end
end
--生成一圈虚影
local function SpawnGestalts(inst, count, dist)
    if count > 0 then
        local pos = Vector3(inst.Transform:GetWorldPosition())
        local dtheta = PI * 2 / count
        local thetaoffset = math.random() * PI * 2
        for theta = math.random() * dtheta, PI * 2, dtheta do
            local offset = FindWalkableOffset(pos, theta + thetaoffset, dist or 3, 5, false, true)
            if offset ~= nil then
                SpawnPrefab("medal_gestalt").Transform:SetPosition(pos.x + offset.x, 0, pos.z + offset.z)
            end
        end
    end
end

--生成时空晶矿、时空虚影
local function spawnglass(inst)
    local glass = SpawnPrefab("medal_spacetime_glass")
    glass.spawnin(glass)
    glass.Transform:SetPosition(inst.Transform:GetWorldPosition())

    SpawnGestalts(inst,3,3)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetLightOverride(1)
    inst.AnimState:SetBank("Moonstorm_LightningStrike")
    inst.AnimState:SetBuild("medal_spacetime_lightningstrike")
    inst.AnimState:PlayAnimation("strike")

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

	inst:DoTaskInTime(0, StartFX) -- so we can use the position to affect the screen flash

    inst.entity:SetCanSleep(false)
    inst.persists = false
    inst:DoTaskInTime(.5, inst.Remove)

    inst:DoTaskInTime(0,function() spawnglass(inst) end)

    return inst
end

return Prefab("medal_spacetime_lightning", fn, assets)