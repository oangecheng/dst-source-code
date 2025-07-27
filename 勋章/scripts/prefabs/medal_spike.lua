local assets =
{
    Asset("ANIM", "anim/sand_spike.zip"),
    Asset("ANIM", "anim/medal_spike.zip"),
    Asset("ANIM", "anim/sand_splash_fx.zip"),
    Asset("ANIM", "anim/medal_spacetime_splash_fx.zip"),
}

local block_assets =
{
    Asset("ANIM", "anim/sand_block.zip"),
    Asset("ANIM", "anim/medal_block.zip"),
    Asset("ANIM", "anim/sand_splash_fx.zip"),
    Asset("ANIM", "anim/medal_spacetime_splash_fx.zip"),
}

local SPIKE_SIZES =
{
    "short",
    "med",
    "tall",
}

local RADIUS =
{
    ["short"] = .2,
    ["med"] = .4,
    ["tall"] = .6,
    ["block"] = 1.1,
}

local DAMAGE_RADIUS_PADDING = .5
local GLASS_TIME = 24 * FRAMES

local function KeepTargetFn()
    return false
end

local function OnHit(inst)
    inst.AnimState:PlayAnimation(inst.animname.."_hit")
end

local function ChangeToObstacle(inst)
    inst:RemoveEventCallback("animover", ChangeToObstacle)
    local x, y, z = inst.Transform:GetWorldPosition()
    inst.Physics:Stop()
    inst.Physics:SetMass(0)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.ITEMS)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
    inst.Physics:Teleport(x, 0, z)
end

local function SpikeLaunch(inst, launcher, basespeed, startheight, startradius)
    local x0, y0, z0 = launcher.Transform:GetWorldPosition()
    local x1, y1, z1 = inst.Transform:GetWorldPosition()
    local dx, dz = x1 - x0, z1 - z0
    local dsq = dx * dx + dz * dz
    local angle
    if dsq > 0 then
        local dist = math.sqrt(dsq)
        angle = math.atan2(dz / dist, dx / dist) + (math.random() * 20 - 10) * DEGREES
    else
        angle = 2 * PI * math.random()
    end
    local sina, cosa = math.sin(angle), math.cos(angle)
    local speed = basespeed + math.random()
    inst.Physics:Teleport(x0 + startradius * cosa, startheight, z0 + startradius * sina)
    inst.Physics:SetVel(cosa * speed, speed * 5 + math.random() * 2, sina * speed)
end

local COLLAPSIBLE_WORK_ACTIONS =
{
    CHOP = true,
    DIG = true,
    HAMMER = true,
    MINE = true,
}
local COLLAPSIBLE_TAGS = { "_combat", "pickable", "NPC_workable" }
for k, v in pairs(COLLAPSIBLE_WORK_ACTIONS) do
    table.insert(COLLAPSIBLE_TAGS, k.."_workable")
end
-- local NON_COLLAPSIBLE_TAGS = { "medal_spacetime_devourer", "groundspike", "shadow", "ghost", "playerghost", "FX", "NOCLICK", "DECOR", "INLIMBO" }
local NON_COLLAPSIBLE_TAGS = { "medal_spacetime_devourer", "groundspike", "flying", "shadow", "ghost", "playerghost", "FX", "NOCLICK", "DECOR", "INLIMBO" }
local TOSSITEM_MUST_TAGS = { "_inventoryitem" }
local TOSSITEM_CANT_TAGS = { "locomotor", "INLIMBO" }

local function no_aggro(attacker, target)
	if target and attacker then
		local targets_target = target.components.combat ~= nil and target.components.combat.target or nil
		return targets_target ~= nil and targets_target:IsValid() and targets_target ~= attacker and attacker:IsValid()
				and (GetTime() - target.components.combat.lastwasattackedbytargettime) < 4
				and (targets_target.components.health ~= nil and not targets_target.components.health:IsDead())
	end
end

local function DoBreak(inst)
    inst.task = nil
    inst.components.health:Kill()
end

local function DoDamage(inst)
    inst.task = inst:DoTaskInTime(GetRandomMinMax(unpack(TUNING_MEDAL.MEDAL_SANDSPIKE.LIFETIME[string.upper(inst.animname)])), DoBreak)
    inst:RemoveTag("notarget")
    inst.Physics:SetActive(true)
    inst:AddComponent("inspectable")
    inst.components.health:SetInvincible(false)
    inst.components.combat:SetOnHit(OnHit)

    local isblock = inst.animname == "block"
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, 0, z, inst.spikeradius + DAMAGE_RADIUS_PADDING, nil, NON_COLLAPSIBLE_TAGS, COLLAPSIBLE_TAGS)
    for i, v in ipairs(ents) do
        if v:IsValid() then
            local isworkable = false
            if v.components.workable ~= nil then
                local work_action = v.components.workable:GetWorkAction()
                --V2C: nil action for NPC_workable (e.g. campfires)
                --     allow digging spawners (e.g. rabbithole)
                isworkable = (
                    (work_action == nil and v:HasTag("NPC_workable")) or
                    (v.components.workable:CanBeWorked() and work_action ~= nil and COLLAPSIBLE_WORK_ACTIONS[work_action.id])
                )
            end
            if isworkable then
                v.components.workable:Destroy(inst)
                if v:IsValid() and v:HasTag("stump") then
                    v:Remove()
                end
            elseif v.components.pickable ~= nil
                and v.components.pickable:CanBePicked()
                and not v:HasTag("intense") then
                local num = v.components.pickable.numtoharvest or 1
                local product = v.components.pickable.product
                local x1, y1, z1 = v.Transform:GetWorldPosition()
                v.components.pickable:Pick(inst) -- only calling this to trigger callbacks on the object
                if product ~= nil and num > 0 then
                    for i = 1, num do
                        SpawnPrefab(product).Transform:SetPosition(x1, 0, z1)
                    end
                end
            elseif v.components.combat ~= nil
                and v.components.health ~= nil
                and not v.components.health:IsDead() then
                -- if v.components.locomotor == nil then
                --     v.components.health:Kill()--不会移动又怎么了，凭啥秒人家
                -- elseif not isblock
                if not isblock and inst.components.combat:IsValidTarget(v) then
                    v.components.combat.temp_disable_aggro = no_aggro(inst, v)--不引起仇恨
                    inst.components.combat:DoAttack(v)
                    --打完后解除不引起仇恨的临时标记
                    if v ~= nil and v:IsValid() and v.components.combat ~= nil then
                        v.components.combat.temp_disable_aggro = false
                    end
                end
            end
        end
    end

    local totoss = TheSim:FindEntities(x, 0, z, inst.spikeradius + DAMAGE_RADIUS_PADDING, TOSSITEM_MUST_TAGS, TOSSITEM_CANT_TAGS)
    for i, v in ipairs(totoss) do
        if v.components.mine ~= nil then
            v.components.mine:Deactivate()
        end
        if not v.components.inventoryitem.nobounce and v.Physics ~= nil and v.Physics:IsActive() then
            if isblock then
                SpikeLaunch(v, inst, 1.2, .6, inst.spikeradius + v:GetPhysicsRadius(0))
            else
                SpikeLaunch(v, inst, .8 + inst.spikeradius, inst.spikeradius * .4, inst.spikeradius + v:GetPhysicsRadius(0))
            end
        end
    end

    if inst.fromplayer then
        DoBreak(inst)--是玩家召唤的就马上自毁，不要放在那碍事
    end
end
--变成玻璃
local function ChangeToGlass(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    inst:Remove()
    local glass = SpawnPrefab("medal_glassblock")
    glass.Transform:SetPosition(x, y, z)
    glass:Sparkle()
end
--播放玻璃特效
local function PlayGlassFX(inst)
    inst.task = nil
    SpawnPrefab("medal_spacetime_puff_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
end
--被不朽化
local function OnImmortal(inst)
    if inst.task ~= nil then
        inst.task:Cancel()
    end
    inst.task = inst:DoTaskInTime(GLASS_TIME - 2 * FRAMES, PlayGlassFX)
    inst:AddTag("NOCLICK")
    inst.components.health:SetInvincible(true)
    inst.components.combat:SetOnHit(nil)
    inst:RemoveEventCallback("animover", ChangeToObstacle)
    inst:ListenForEvent("animover", ChangeToGlass)
    inst.AnimState:PlayAnimation(inst.animname.."_transform")
end

local function StartSpikeAnim(inst)
    inst.task = inst:DoTaskInTime(2 * FRAMES, DoDamage)
    inst:RemoveEventCallback("animover", StartSpikeAnim)
    inst:ListenForEvent("animover", ChangeToObstacle)
    inst.AnimState:SetLayer(LAYER_WORLD)
    inst.AnimState:SetSortOrder(0)
    inst.AnimState:PlayAnimation(inst.animname.."_pst")
    inst.SoundEmitter:PlaySound(
        "dontstarve/creatures/together/antlion/sfx/break",
        nil,
        (inst.spikesize == "short" and .6) or
        (inst.spikesize == "med" and .8) or
        nil
    )
end

local function OnDeath(inst)
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
    inst:AddTag("NOCLICK")
    inst.Physics:SetActive(false)
    inst.components.combat:SetOnHit(nil)
    inst:RemoveEventCallback("animover", StartSpikeAnim)
    inst:RemoveEventCallback("animover", ChangeToObstacle)
    inst:RemoveEventCallback("animover", ChangeToGlass)
    inst:ListenForEvent("animover", inst.Remove)
    inst.AnimState:PlayAnimation(inst.animname.."_break")
    inst.SoundEmitter:PlaySound(
        "dontstarve/creatures/together/antlion/sfx/break_spike",
        nil,
        (inst.spikesize == "short" and .6) or
        (inst.spikesize == "med" and .8) or
        nil
    )
end

--攻击到生物时执行函数
local function OnHitOther(inst, other, damage)
	if other.components.health ~= nil and not other.components.health:IsDead() then
        --击飞
        if other:HasTag("player") then
            other:PushEvent("knockback", {knocker = inst, radius = (inst.spikeradius or 0.4)*15})
        end
        --时之伤
        if inst.animname then
            other.components.health:DoDeltaMedalDelayDamage(TUNING_MEDAL.MEDAL_SANDSPIKE.DELAY_DAMAGE[string.upper(inst.animname)])
        end
    end
    DoBreak(inst)--攻击到后自毁
end

local function PlayBlockSound(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/block")
end

local function MakeSpikeFn(shape, size)
    return function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddPhysics()
        inst.entity:AddNetwork()

        if shape == "spike" then
            inst.spikesize = size or SPIKE_SIZES[math.random(#SPIKE_SIZES)]
            inst.animname = inst.spikesize
            if size == nil then
                inst:SetPrefabName("sandspike_"..inst.spikesize)
            end
            inst:SetPrefabNameOverride("medal_spike")
        else
            inst.animname = "block"
        end
        inst.spikeradius = RADIUS[inst.animname]

        inst.AnimState:SetBank("sand_"..shape)
        inst.AnimState:SetBuild("medal_"..shape)
        inst.AnimState:OverrideSymbol("sand_splash", "medal_spacetime_splash_fx", "sand_splash")
        inst.AnimState:PlayAnimation(inst.animname.."_pre")
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        inst.AnimState:SetSortOrder(3)

        inst.Physics:SetMass(999999)
        inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.ITEMS)
        inst.Physics:CollidesWith(COLLISION.CHARACTERS)
        inst.Physics:CollidesWith(COLLISION.GIANTS)
        inst.Physics:CollidesWith(COLLISION.WORLD)
        inst.Physics:SetActive(false)
        inst.Physics:SetCapsule(inst.spikeradius, 2)

        inst:AddTag("notarget")
        inst:AddTag("hostile")
        inst:AddTag("groundspike")

        --For impact sound
        inst:AddTag("object")
        inst:AddTag("stone")
        if shape == "block" then
            inst:AddTag("canbeglass")--可以被变成玻璃
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(TUNING_MEDAL.MEDAL_SANDSPIKE.HEALTH[string.upper(inst.animname)])
        inst.components.health:SetInvincible(true)
        inst.components.health.fire_damage_scale = 0
        inst.components.health.canheal = false
        inst.components.health.nofadeout = true

        inst:AddComponent("combat")
        inst.components.combat:SetDefaultDamage(TUNING_MEDAL.MEDAL_SANDSPIKE.DAMAGE[string.upper(inst.animname)])
        inst.components.combat.playerdamagepercent = .5
        inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
        inst.components.combat.onhitotherfn = OnHitOther--攻击到生物时执行函数
        
	    inst:AddComponent("medal_chaosdamage")--混沌伤害
	    inst.components.medal_chaosdamage:SetBaseDamage(TUNING_MEDAL.MEDAL_SANDSPIKE.CHAOS_DAMAGE[string.upper(inst.animname)])

        inst:ListenForEvent("animover", StartSpikeAnim)
        inst:ListenForEvent("death", OnDeath)

        if shape == "block" then
            inst:DoTaskInTime(0, PlayBlockSound)
            inst.OnImmortal = OnImmortal
        end

        inst.persists = false--不持续存在(重载后消失)

        return inst
    end
end

--For searching: sandspike_short, sandspike_med, sandspike_tall
local prefabs = {}
local ret = {}
for i, v in ipairs(SPIKE_SIZES) do
    local name = "medal_spike_"..v
    table.insert(prefabs, name)
    table.insert(ret, Prefab(name, MakeSpikeFn("spike", v), assets, { "glass_fx", "glassspike_"..v }))
    -- table.insert(ret, Prefab(name, MakeSpikeFn("spike", v), assets, { "glass_fx", "glassspike_"..v }))
end
table.insert(ret, Prefab("medal_spike", MakeSpikeFn("spike"), assets, prefabs))
prefabs = nil

table.insert(ret, Prefab("medal_block", MakeSpikeFn("block"), block_assets, { "glass_fx", "glassblock" }))

return unpack(ret)
