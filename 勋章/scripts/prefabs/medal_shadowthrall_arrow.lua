local assets =
{
    Asset("ANIM", "anim/blow_dart.zip"),
    Asset("ANIM", "anim/medal_shadowthrall_arrow.zip"),
}

local projectile_prefabs =
{
    "hitsparks_piercing_fx",
}

----------------------------------------------------------------------------------------------------------------------------

local WEIGHTED_TAIL_FXS =
{
    ["tail_5_8"] = 1,
    ["tail_5_9"] = .5,
}

local LAUNCH_OFFSET_Y = 0.75

----------------------------------------------------------------------------------------------------------------------------
--尾部fx
local function Projectile_CreateTailFx(inst)
    local inst = CreateEntity()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.AnimState:SetBank("lavaarena_blowdart_attacks")
    inst.AnimState:SetBuild("lavaarena_blowdart_attacks")
    inst.AnimState:PlayAnimation(weighted_random_choice(WEIGHTED_TAIL_FXS))
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)

    inst.AnimState:SetLightOverride(0.3)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    -- inst.AnimState:SetAddColour(0, 0, 0, 0)--(170/255, 37/255, 33/255, 0)
    -- inst.AnimState:SetMultColour(0/255, 0/255, 0/255, 0.75)

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end
--更新尾部位置
local function Projectile_UpdateTail(inst)
    local c = (not inst.entity:IsVisible() and 0) or 1
    local target = inst._target:value()

    -- Does not spawn the tail if it is close to the target (visual bug).
    if c > 0 and not (target ~= nil and target:IsValid() and inst:IsNear(target, 1.5)) then
        local tail = inst:CreateTailFx()
        if inst.prefab == "medal_shadowthrall_arrow" then
            tail.AnimState:SetMultColour(0/255, 0/255, 0/255, 0.75)
        else
            tail.AnimState:SetAddColour(255/255, 0/255, 0/255, 0)
        end
        tail.Transform:SetPosition(inst.Transform:GetWorldPosition())
        tail.Transform:SetRotation(inst.Transform:GetRotation())
        if c < 1 then
            tail.AnimState:SetTime(c * tail.AnimState:GetCurrentAnimationLength())
        end

        return tail -- Mods.
    end
end
--射击过程
local function Projectile_OnThrown(inst, owner, target, attacker)
    inst._target:set(target)
end
--射击特效
local function Projectile_SpawnImpactFx(inst, attacker, target)
    if target ~= nil and attacker ~= nil and target:IsValid() and attacker:IsValid() then
        local impactfx = SpawnPrefab("hitsparks_piercing_fx")
        impactfx:Setup(attacker, target, inst, nil, true, LAUNCH_OFFSET_Y)

        return impactfx -- Mods.
    end
end

--射中前函数
local function Projectile_OnPreHit(inst, attacker, target)
    if  target ~= nil      and
        target:IsValid()   and
        attacker ~= nil    and
        attacker:IsValid() and
        (target.components.health == nil or not target.components.health:IsDead())
    then
        inst:SpawnImpactFx(attacker, target)
    end
end

----------------------------------------------------------------------------------------------------------------------------

local function ProjectileFn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddLight()

    inst.Light:SetFalloff(0.6)
    inst.Light:SetIntensity(.6)
    inst.Light:SetRadius(0.4)
    inst.Light:SetColour(170/255, 37/255, 33/255)
    inst.Light:Enable(true)

    MakeProjectilePhysics(inst)

    inst.AnimState:SetBank("blow_dart")
    inst.AnimState:SetBuild("medal_shadowthrall_arrow")
    inst.AnimState:PlayAnimation("dart_houndstooth", true)

    inst.AnimState:SetLightOverride(0.2)

    inst.AnimState:SetSymbolBloom("flametail")
    inst.AnimState:SetSymbolLightOverride("flametail", 0.5)

    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)

    --weapon (from weapon component) added to pristine state for optimization.
    inst:AddTag("weapon")

    --projectile (from projectile component) added to pristine state for optimization.
    inst:AddTag("projectile")

    inst:AddTag("NOCLICK")
    inst:AddTag("NOBLOCK")

    if not TheNet:IsDedicated() then
        inst.CreateTailFx  = Projectile_CreateTailFx
        inst.UpdateTail    = Projectile_UpdateTail

        inst:DoPeriodicTask(0, inst.UpdateTail)
    end

    inst._target = net_entity(inst.GUID, "houndstooth_proj._target")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst.SpawnImpactFx = Projectile_SpawnImpactFx

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING_MEDAL.MEDAL_SHADOWTHRALL_ARROW_DAMAGE)

    inst:AddComponent("medal_chaosdamage")--混沌伤害
	inst.components.medal_chaosdamage:SetBaseDamage(TUNING_MEDAL.MEDAL_SHADOWTHRALL_ARROW_CHAOS_DAMAGE)

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(TUNING_MEDAL.MEDAL_SHADOWTHRALL_ARROW_SPEED)
    inst.components.projectile:SetHoming(false)
    inst.components.projectile:SetOnThrownFn(Projectile_OnThrown)
    inst.components.projectile:SetOnPreHitFn(Projectile_OnPreHit)
    inst.components.projectile:SetOnHitFn(inst.Remove)
    inst.components.projectile:SetHitDist(1.5)
    inst.components.projectile:SetLaunchOffset(Vector3(2.5, LAUNCH_OFFSET_Y, 2.5))
    inst.components.projectile:SetOnMissFn(inst.Remove)
    inst.components.projectile.range = 30
    inst.components.projectile.has_damage_set = true

    return inst
end

return Prefab("medal_shadowthrall_arrow",     ProjectileFn, assets, projectile_prefabs),
    Prefab("medal_shadowthrall_arrow_blood",     ProjectileFn, assets, projectile_prefabs)