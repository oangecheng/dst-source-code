local assets =
{
    Asset("ANIM", "anim/reticuleaoe.zip"),
    --Asset("ANIM", "anim/reticuleaoebase.zip"),
}

local PAD_DURATION = .1
local FLASH_TIME = .3

local function SetRadius(inst, radius)
	local scale = radius and radius/3 or TUNING_MEDAL.IMMORTAL_STAFF_RADIUS/3
	inst.AnimState:SetScale(scale, scale)
end

local function UpdatePing(inst, s0, s1, t0, duration, multcolour, addcolour)
    if next(multcolour) == nil then
        multcolour[1], multcolour[2], multcolour[3], multcolour[4] = inst.AnimState:GetMultColour()
    end
    if next(addcolour) == nil then
        addcolour[1], addcolour[2], addcolour[3], addcolour[4] = inst.AnimState:GetAddColour()
    end
    local t = GetTime() - t0
    local k = 1 - math.max(0, t - PAD_DURATION) / duration
    k = 1 - k * k
    local s = Lerp(s0, s1, k)
    local c = Lerp(1, 0, k)
    inst.Transform:SetScale(s, s, s)
    inst.AnimState:SetMultColour(c * multcolour[1], c * multcolour[2], c * multcolour[3], c * multcolour[4])

    k = math.min(FLASH_TIME, t) / FLASH_TIME
    c = math.max(0, 1 - k * k)
    inst.AnimState:SetAddColour(c * addcolour[1], c * addcolour[2], c * addcolour[3], c * addcolour[4])
end

--名字，动画名，范围，范围提升程度
local function MakePing(name, anim, scale,scaleup)
    local function fn()
        local inst = CreateEntity()

        inst:AddTag("FX")
        inst:AddTag("NOCLICK")
        --[[Non-networked entity]]
		inst.entity:AddNetwork()
        inst.entity:SetCanSleep(false)
        inst.persists = false

        inst.entity:AddTransform()
        inst.entity:AddAnimState()

        inst.AnimState:SetBank("reticuleaoe")
        inst.AnimState:SetBuild("reticuleaoe")
        inst.AnimState:PlayAnimation(anim)
        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGroundFixed)
        inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
        inst.AnimState:SetSortOrder(3)
        -- inst.AnimState:SetScale(scale, scale)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

        inst.SetRadius = SetRadius
        SetRadius(inst)
		
		local duration = .5
        inst:DoPeriodicTask(0, UpdatePing, nil, 1, scaleup or 1.1, GetTime(), duration, {}, {})
        inst:DoTaskInTime(duration, inst.Remove)

        return inst
    end

    return Prefab(name, fn, assets)
end

return MakePing("medal_reticule_scale_fx", "idle_target")