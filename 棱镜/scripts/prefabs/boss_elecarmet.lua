local assets = {
	--正常状态的贴图
    Asset("ANIM", "anim/elecarmet_normal1.zip"),
    Asset("ANIM", "anim/elecarmet_normal2.zip"),
    Asset("ANIM", "anim/elecarmet_normal3.zip"),
    --Asset("ANIM", "anim/elecarmet_normal4.zip"),	--这部分是完全没修改过的贴图，不需要重新导入

    --激怒状态的贴图
    Asset("ANIM", "anim/elecarmet_irritated1.zip"),
    Asset("ANIM", "anim/elecarmet_irritated2.zip"),
    Asset("ANIM", "anim/elecarmet_irritated3.zip"),
    --Asset("ANIM", "anim/elecarmet_irritated4.zip"),	--不必要的贴图

    Asset("ANIM", "anim/lavaarena_boarrior_basic.zip"),	--必须注册这个官方的boss动画压缩包才行
}
local prefabs = {
	"fimbul_axe",
    "elecourmaline",
    "tourmalinecore",
    "rocks",
    "flint",

	"fimbul_lightning",
	-- "fimbul_cracklebase_fx",
	"fimbul_static_fx",
    -- "fimbul_attack_fx",
    "fimbul_teleport_fx",
    "fimbul_explode_fx",
    "shock_fx",
    "ground_chunks_breaking",

    -- "dualwrench_blueprint",
    -- "hat_cowboy_blueprint",
    -- "icire_rock_blueprint",
}

local brain = require "brains/elecarmetbrain"

SetSharedLootTable('elecarmet', {
	{"fimbul_axe",       1.00},
    {"fimbul_axe",       0.33},
    {"tourmalinecore",   0.10},
    {'rocks',   1.0},
    {'rocks',   1.0},
    {'rocks',   1.0},
    {'rocks',   0.5},
    {'flint',   1.0},
    {'flint',   1.0},
    {'flint',   0.5},
})

local function AddSpecialLoot(inst)
    inst.components.lootdropper:SetChanceLootTable('elecarmet')

    if CONFIGS_LEGION.TECHUNLOCK ~= "lootdropper" then
        return
    end

    local drops = {
        "tripleshovelaxe_blueprint",
        "triplegoldenshovelaxe_blueprint",
        "dualwrench_blueprint",
        "hat_cowboy_blueprint",
        "icire_rock_blueprint",
        "guitar_miguel_blueprint",
        "web_hump_item_blueprint",
        "saddle_baggage_blueprint",
        "hat_albicans_mushroom_blueprint",
        "soul_contracts_blueprint",
        "explodingfruitcake_blueprint",
        "fishhomingtool_awesome_blueprint",
        "siving_mask_gold_blueprint",
        "siving_ctlall_item_blueprint",
        "hat_elepheetle_blueprint",
        "armor_elepheetle_blueprint"
    }
    inst.components.lootdropper:AddChanceLoot(table.remove(drops, math.random(#drops)), 1)
    inst.components.lootdropper:AddChanceLoot(table.remove(drops, math.random(#drops)), 1)
    inst.components.lootdropper:AddChanceLoot(table.remove(drops, math.random(#drops)), 1)
    inst.components.lootdropper:AddChanceLoot(table.remove(drops, math.random(#drops)), 1)
    inst.components.lootdropper:AddChanceLoot(table.remove(drops, math.random(#drops)), 1)
end

local function OverrideSymbols(inst, isirritated)   --修改一系列贴图等
    if isirritated then
        inst.AnimState:OverrideSymbol("arm", "elecarmet_irritated1", "arm")
        inst.AnimState:OverrideSymbol("chest", "elecarmet_irritated1", "chest")

        inst.AnimState:OverrideSymbol("eyes", "elecarmet_irritated2", "eyes")
        inst.AnimState:OverrideSymbol("rock2", "elecarmet_irritated2", "rock2")
        inst.AnimState:OverrideSymbol("shoulder", "elecarmet_irritated2", "shoulder")
        inst.AnimState:OverrideSymbol("swap_weapon", "elecarmet_irritated2", "swap_weapon")

        inst.AnimState:OverrideSymbol("hand", "elecarmet_irritated3", "hand")
        inst.AnimState:OverrideSymbol("head", "elecarmet_irritated3", "head")
        inst.AnimState:OverrideSymbol("mouth", "elecarmet_irritated3", "mouth")
        inst.AnimState:OverrideSymbol("nose", "elecarmet_irritated3", "nose")
        inst.AnimState:OverrideSymbol("pelvis", "elecarmet_irritated3", "pelvis")
        inst.AnimState:OverrideSymbol("rock", "elecarmet_irritated3", "rock")
        inst.AnimState:OverrideSymbol("swap_weapon_spin", "elecarmet_irritated3", "swap_weapon_spin")

        inst.Light:Enable(true)
        inst.hasirritatedskin = true
    else
        inst.AnimState:OverrideSymbol("arm", "elecarmet_normal1", "arm")
        inst.AnimState:OverrideSymbol("chest", "elecarmet_normal1", "chest")

        inst.AnimState:OverrideSymbol("eyes", "elecarmet_normal2", "eyes")
        inst.AnimState:OverrideSymbol("rock2", "elecarmet_normal2", "rock2")
        inst.AnimState:OverrideSymbol("shoulder", "elecarmet_normal2", "shoulder")
        inst.AnimState:OverrideSymbol("swap_weapon", "elecarmet_normal2", "swap_weapon")

        inst.AnimState:OverrideSymbol("hand", "elecarmet_normal3", "hand")
        inst.AnimState:OverrideSymbol("head", "elecarmet_normal3", "head")
        inst.AnimState:OverrideSymbol("mouth", "elecarmet_normal3", "mouth")
        inst.AnimState:OverrideSymbol("nose", "elecarmet_normal3", "nose")
        inst.AnimState:OverrideSymbol("pelvis", "elecarmet_normal3", "pelvis")
        inst.AnimState:OverrideSymbol("rock", "elecarmet_normal3", "rock")
        inst.AnimState:OverrideSymbol("swap_weapon_spin", "elecarmet_normal3", "swap_weapon_spin")

        --inst.AnimState:OverrideSymbol("spark", "elecarmet_normal4", "spark")
        --inst.AnimState:OverrideSymbol("splash", "elecarmet_normal4", "splash")
        --inst.AnimState:OverrideSymbol("swipes", "elecarmet_normal4", "swipes")
    end
end

----------------------------------------------------
--技能--雷电招来：随机地点产生闪电和静电地雷
----------------------------------------------------

local function GetDamage(inst, damage)
    if inst.deathcounter ~= nil and inst.deathcounter > 0 then
        return damage + inst.deathcounter * 2
    end
    return damage
end
local function GetSpawnPoint(pos, radius)
    -- local x, y, z = inst.Transform:GetWorldPosition()
    local rad = radius or math.random(1, 20)
    local angle = math.random() * 2 * PI

    return pos.x + rad * math.cos(angle), pos.y, pos.z - rad * math.sin(angle)
end

local function SpawnLightning(x, y, z)
    local closest_generic = nil
    local closest_rod = nil
    local closest_blocker = nil

    local ents = TheSim:FindEntities(x, y, z, 40, nil, { "playerghost", "INLIMBO", "electrified" }, { "lightningrod", "lightningtarget", "lightningblocker" })
    local blockers = nil
    for _, v in pairs(ents) do
        -- Track any blockers we find, since we redirect the strike position later,
        -- and might redirect it into their block range.
        local is_blocker = v.components.lightningblocker ~= nil
        if is_blocker then
            if blockers == nil then
                blockers = {v}
            else
                table.insert(blockers, v)
            end
        end

        if
            closest_blocker == nil and is_blocker
            and (v.components.lightningblocker.block_rsq + 0.0001) > v:GetDistanceSqToPoint(x, y, z)
        then
            closest_blocker = v
        elseif closest_rod == nil and v:HasTag("lightningrod") then
            closest_rod = v
        elseif closest_generic == nil then
            if
                (v.components.health == nil or not v.components.health:IsInvincible())
                and not is_blocker -- If we're out of range of the first branch, ignore blocker objects.
                and (
                    v.components.playerlightningtarget == nil or
                    math.random() <= v.components.playerlightningtarget:GetHitChance()
                )
            then
                closest_generic = v
            end
        end
    end

    local strike_position = Vector3(x,y,z)
    local prefab_type = "fimbul_lightning"

    if closest_blocker ~= nil then
        closest_blocker.components.lightningblocker:DoLightningStrike(strike_position)
        prefab_type = "thunder"
    elseif closest_rod ~= nil then
        strike_position = closest_rod:GetPosition()

        -- Check if we just redirected into a lightning blocker's range.
        if blockers ~= nil then
            for _, blocker in ipairs(blockers) do
                if blocker:GetDistanceSqToPoint(strike_position:Get()) < (blocker.components.lightningblocker.block_rsq + 0.0001) then
                    prefab_type = "thunder"
                    blocker.components.lightningblocker:DoLightningStrike(strike_position)
                    break
                end
            end
        end

        -- If we didn't get blocked, push the event that does all the fx and behaviour.
        if prefab_type == "fimbul_lightning" then
            closest_rod:PushEvent("lightningstrike")
        end
    else
        if closest_generic ~= nil then
            strike_position = closest_generic:GetPosition()

            -- Check if we just redirected into a lightning blocker's range.
            if blockers ~= nil then
                for _, blocker in ipairs(blockers) do
                    if blocker:GetDistanceSqToPoint(strike_position:Get()) < (blocker.components.lightningblocker.block_rsq + 0.0001) then
                        prefab_type = "thunder"
                        blocker.components.lightningblocker:DoLightningStrike(strike_position)
                        break
                    end
                end
            end

            -- If we didn't redirect, strike the playerlightningtarget if there is one.
            if prefab_type == "fimbul_lightning" then
                if closest_generic.components.playerlightningtarget ~= nil then
                    closest_generic.components.playerlightningtarget:DoStrike()
                end
            end
        end

        -- If we're doing lightning, light nearby unprotected objects on fire.
        if prefab_type == "fimbul_lightning" then
            ents = TheSim:FindEntities(strike_position.x, strike_position.y, strike_position.z, 3, nil, { "player", "INLIMBO", "electrified" })
            for _, v in pairs(ents) do
                if v.components.burnable ~= nil then
                    v.components.burnable:Ignite()
                end
            end
        end
    end

    SpawnPrefab(prefab_type).Transform:SetPosition(strike_position:Get())
end

local function mine_test_fn(dude, inst)
    return dude.components.health ~= nil and not dude.components.health:IsDead()
        and dude.components.combat ~= nil and dude.components.combat:CanBeAttacked(inst)
end
local function SpawnStatic(x, y, z)
	local static = SpawnPrefab("fimbul_static_fx")
	static.AnimState:PlayAnimation("crackle_pst", true)
	static.Transform:SetPosition(x, y, z)
	static.findtask = static:DoPeriodicTask(0.5, function(inst)
        local target = FindEntity(inst, 1.6, mine_test_fn, {"shockable"}, {"ghost", "playerghost", "INLIMBO"}, nil)
        if target ~= nil then
        	target.components.shockable:Shock(8)

        	if inst.findtask ~= nil then
        	    inst.findtask:Cancel()
        	    inst.findtask = nil
        	end
        	inst:DoRemove()
        end
    end)
    static.quittask = static:DoTaskInTime(60+math.random()*120, function(inst)
        if inst.findtask ~= nil then
            inst.findtask:Cancel()
            inst.findtask = nil
        end
        inst:DoRemove()
    end)
end

local function CallForLightning(inst)
    local pos = inst:GetPosition()

    local x1, y1, z1 = GetSpawnPoint(pos)
    SpawnLightning(x1, y1, z1)

    x1, y1, z1 = GetSpawnPoint(pos)
    if TheWorld.Map:IsAboveGroundAtPoint(x1, y1, z1) then   --只有有效地面上生成
        SpawnStatic(x1, y1, z1)
    end
end

----------------------------------------------------
--技能--闪电旋风：范围性伤害与击退，产生一圈闪电
----------------------------------------------------

local knockback_item_speed = 5 	--地面物品的击飞速度
local knockback_item_speed_heavy = knockback_item_speed/2  --地面重型物品的击飞速度
local flashwhirl_radius = 9 	--旋风生效半径
local flashwhirl_damage = 45 	--旋风伤害
local flashwhirl_knockback_radius = 8 	--旋风击退半径

local function Knockback(inst, target, k_damage, k_radius)
    if target.components.workable ~= nil then
        target.components.workable:Destroy(inst)
    elseif target.components.combat ~= nil and target.components.health ~= nil and not target.components.health:IsDead() then
        --先受伤害，再进行击退
        target.components.combat:GetAttacked(inst.attackowner or inst,
            GetDamage(inst, target:HasTag("player") and k_damage or k_damage*3))
        target:PushEvent("knockback", {knocker = inst, radius = k_radius}) --其实只有少部分生物有击退sg
    end
end

local function FlashWhirl(inst)
	local x1, y1, z1 = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x1, y1, z1, flashwhirl_radius,
        nil, { "DECOR", "NOCLICK", "FX", "shadow", "playerghost", "INLIMBO" })

	for i, ent in pairs(ents) do
		if ent ~= inst and ent.entity:IsVisible() and ent.Physics ~= nil then
			local x2, y2, z2 = ent.Transform:GetWorldPosition()

			if ent.components.inventoryitem ~= nil and ent.components.locomotor == nil then	--物品栏物品，非生物
				local speed = ent:HasTag("heavy") and knockback_item_speed_heavy or knockback_item_speed
				local vec = Vector3(x2 - x1, y2 - y1, z2 - z1):Normalize()

				ent.Physics:Teleport(x2, 0.5, z2)
				ent.Physics:SetVel(vec.x * speed, speed, vec.z * speed)
			elseif --击飞生物，或摧毁可以锤、砍、凿的物体
                ent.components.locomotor ~= nil or
                (ent.components.workable ~= nil and not ent:HasTag("DIG_workable"))
            then
				Knockback(inst, ent, flashwhirl_damage, flashwhirl_knockback_radius)
			end
		end
	end

	for i = 1, 3 do
		SpawnLightning(GetSpawnPoint({x = x1, y = y1, z = z1}, flashwhirl_radius))
	end
end

----------------------------------------------------
--技能--战吼自爆：以自己为中心爆炸
----------------------------------------------------

local battlecry_radius = 7 		--战吼爆炸生效半径
local battlecry_damage = 100 	--战吼爆炸伤害
local battlecry_knockback_radius = 6 	--战吼爆炸击退半径

local function BattleCry(inst)
	local pos = inst:GetPosition()

	for i = 1, 3 do
		local x1, y1, z1 = GetSpawnPoint(pos, math.random(2, 4))
        local splash = SpawnPrefab("fimbul_explode_fx")
		splash.Transform:SetPosition(x1, y1, z1)
	end

	local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, battlecry_radius, nil, { "DECOR", "NOCLICK", "FX", "shadow", "playerghost", "INLIMBO" })
	for k, v in pairs(ents) do
        if v ~= inst then
            Knockback(inst, v, battlecry_damage, battlecry_knockback_radius)
        end
	end
end

----------------------------------------------------
--技能--电飞溅：远程攻击，定点爆炸
----------------------------------------------------

local rangesplash_radius_max = 25      --飞溅最大生效半径
local rangesplash_radius_min = 12      --飞溅最小生效半径
local rangesplash_damage = 20 	--飞溅伤害
local rangesplash_knockback_radius = 2 	--飞溅击退半径

local function RangeSplash(inst, target)
    local splash = SpawnPrefab("fimbul_teleport_fx")
    splash.attackowner = inst
	splash.Transform:SetPosition(GetSpawnPoint(target:GetPosition(), 1))
	Knockback(splash, target, rangesplash_damage, rangesplash_knockback_radius)
end

----------------------------------------------------
--技能--挥击：最普通的攻击
----------------------------------------------------

local axewave_damage = 40 	--普通攻击伤害
local axewave_range = 6 	--发起攻击操作的有效距离
local hit_range = 6 	 --打出普通伤害的有效距离
local axewave_period = 3 --攻击间隔时间

-- local function AxeWave(inst, target)
--     target.components.combat:GetAttacked(inst, axewave_damage)
-- end

----------------------------------------------------
--技能--斧头上挥：击退当前敌人
----------------------------------------------------

local axeuppercut_damage = 30 	--上挥伤害
local axeuppercut_knockback_radius = 15 --上挥击退半径

local function AxeUppercut(inst, target)
	Knockback(inst, target, axeuppercut_damage, axeuppercut_knockback_radius)
end

----------------------------------------------------
--技能--双斧重锤：中程攻击，几率麻痹敌人，现已改为直线冲刺
----------------------------------------------------

local heavyhack_radius = 6 		--重锤伤害的判断距离
local heavyhack_damage = 20 	--重锤伤害
local heavyhack_shocktime = 8 	--重锤麻痹时间

local function juzhen(angle, cd, kd, s1, vp)    --这个函数来自于熔炉mod，感谢！
    local s3 = Vector3(s1.x + math.cos(0) * cd, 0, s1.z + math.sin(0) * cd)
    local minx = s1.x + 0
    local maxx = s3.x + cd
    local minz = s3.z - kd/2
    local maxz = s3.z + kd/2
    local xdjd = math.deg(math.atan2( s1.z - vp.z, vp.x - s1.x ))
    local ysjl = (s1 - vp):Length()
    local Xangle = -angle
    local xvp = Vector3(s1.x + math.cos(math.rad(xdjd + Xangle)) * ysjl, 0, s1.z + math.sin(math.rad(xdjd + Xangle)) * ysjl)
    return minx <= xvp.x and xvp.x <= maxx and minz <= xvp.z and xvp.z <= maxz
end
local function HeavyHack(inst, angle)
    local pos = inst:GetPosition()
    local ents = TheSim:FindEntities(pos.x, 0, pos.z, 10, nil, {"DECOR", "NOCLICK", "FX", "shadow", "playerghost", "INLIMBO"})
    for k, v in ipairs(ents) do
        if v ~= inst then
            local vp = v:GetPosition()
            if juzhen(angle, 10, 4, Vector3(pos.x, pos.y, pos.z), vp) then
                if v.components.workable ~= nil and not v:HasTag("DIG_workable") then    --摧毁对象
                    v.components.workable:Destroy(inst)
                elseif v.components.health ~= nil and not v.components.health:IsDead() then   --攻击并麻痹
                    if v.components.combat ~= nil then
                        v.components.combat:GetAttacked(inst,
                            GetDamage(inst, v:HasTag("player") and heavyhack_damage or heavyhack_damage*3))
                    end
                    if v.components.shockable ~= nil and not v.components.shockable:IsShocked() then
                        v.components.shockable:Shock(heavyhack_shocktime)
                    end
                end
            end
        end
    end
end

local heavyhack_step = 0.8 --每次瞬移的间隔

local function DashStep(inst, angle)
    local pos = inst:GetPosition()
    local rad = heavyhack_step

    pos.x = pos.x + rad * math.cos(angle)
    -- pos.y = 0
    pos.z = pos.z - rad * math.sin(angle)

    if TheWorld.Map:IsAboveGroundAtPoint(pos.x, pos.y, pos.z) then   --只在有效地面上生成
        inst.Physics:Teleport(pos.x, pos.y, pos.z)
    end
end

----------------------------------------------------
----------------------------------------------------

local function GetHealthTrigger(inst)
    local finaltrigger = 0.4 + inst.deathcounter * 0.03
    if finaltrigger > 0.85 then
        finaltrigger = 0.85
    end
    return finaltrigger
end

local function BeIrritated(inst)
	if inst.components.health:GetPercent() <= GetHealthTrigger(inst) then
		inst.irritated = true
        inst.wantstotaunt = true
    else
        inst.irritated = false
        inst.wantstotaunt = false
	end
end

local function OnIrritated(inst)
    OverrideSymbols(inst, true)

    --生成暴怒状态的特效等
    -- inst.fx_irritated = SpawnPrefab("shock_fx")
    -- inst.fx_irritated.entity:SetParent(inst.entity)
    -- inst.fx_irritated.entity:AddFollower()
    -- inst.fx_irritated.Follower:FollowSymbol(inst.GUID, "chest", 0, 0, 0)
end

local function UpdateDeathCounter(inst)
    if inst._deathcountertask ~= nil then
        inst._deathcountertask:Cancel()
    end
    inst._deathcountertask = inst:DoTaskInTime(0, function()
        inst._deathcountertask = nil

        if inst.components.combat ~= nil then
            inst.components.combat:SetDefaultDamage(GetDamage(inst, axewave_damage))
        end
        if inst.components.health ~= nil then
            inst.components.health:SetMaxHealth(12000 + inst.deathcounter * 4500)
            if inst.healthPercent ~= nil then
                inst.components.health:SetPercent(inst.healthPercent)
            end
        end
        if inst.components.healthtrigger ~= nil then
            inst.components.healthtrigger:AddTrigger(GetHealthTrigger(inst), BeIrritated)
        end
    end)
end

local function KeepTargetFn(inst, target)
    local landing = inst.components.knownlocations:GetLocation("spawnpoint") or inst:GetPosition()

    --与敌人之间距离不能大于25，敌人与生成点之间距离不能大于35
    return inst.components.combat:CanTarget(target) 
    and inst:GetPosition():Dist(target:GetPosition()) <= 25
    and target:GetPosition():Dist(landing) <= 35
end
local function RetargetFn(inst)
    return FindEntity(
        inst,
        25,
        function(guy)
            -- return guy.components.combat.target == inst and inst.components.combat:CanTarget(guy)
            return inst.components.combat:CanTarget(guy)
        end,
        { "_combat" },
        { "playerghost", "smallcreature", "animal", "largecreature", "INLIMBO" }
    )
end

local function OnAttacked(inst, data)
	if data ~= nil and data.attacker ~= nil then
		if not inst.components.combat:HasTarget() then	--如果这样设置，会盯准某个攻击者一直打
			inst.components.combat:SetTarget(data.attacker)
        end

        if inst.irritated then --暴怒状态时，被攻击会电击
            if data.attacker.components.health ~= nil and not data.attacker.components.health:IsDead() and
                (data.weapon == nil or ((data.weapon.components.weapon == nil or data.weapon.components.weapon.projectile == nil) and data.weapon.components.projectile == nil)) and
                not (data.attacker.components.inventory ~= nil and data.attacker.components.inventory:IsInsulated()) then

                data.attacker.components.health:DoDelta(-15, nil, inst.prefab, nil, inst)
                if data.attacker:HasTag("player") and not data.attacker.sg:HasStateTag("dead") then
                    data.attacker.sg:GoToState("electrocute")
                end
            end
        end
    end
end

local function ShouldSleep(inst)
    -- return not inst.irritated
    return false
end
local function ShouldWake(inst)
    return true
end

local function OnSave(inst, data)
    if inst.deathcounter > 0 then
        data.deathcounter = inst.deathcounter
        if inst.components.health ~= nil then
            data.healthPercent = inst.components.health:GetPercent()
        end
    end
end
local function OnLoad(inst, data)
    if data ~= nil then
        if data.deathcounter ~= nil then
            inst.deathcounter = data.deathcounter
        end
        if data.healthPercent ~= nil then
            inst.healthPercent = data.healthPercent
        end
    end
    UpdateDeathCounter(inst)
    inst:DoTaskInTime(0.2, function(inst)
        BeIrritated(inst)
        OverrideSymbols(inst, inst.irritated)
    end)
end

local function OnDeath(inst)
    -- if inst.fx_irritated ~= nil then
    --     inst.fx_irritated:Remove()
    --     inst.fx_irritated = nil
    -- end

    local rocks = SpawnPrefab("elecourmaline")
    rocks.ActivateRocks(rocks)
    rocks.deathcounter = inst.deathcounter + 1
    rocks.Transform:SetPosition(inst.Transform:GetWorldPosition())
end

----------------------------------------------------
----------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    inst.Transform:SetFourFaced()
    inst.Transform:SetScale(1.3, 1.3, 1)  --x,y决定缩放比例，z和x,y的比例则决定实体在左右和上下两个方向上的速度，一般是相同的
    -- inst.Physics:SetCapsule(2, 2)
    inst.DynamicShadow:SetSize(4, 2)
    -- inst:SetPhysicsRadiusOverride(2)
    -- MakeGiantCharacterPhysics(inst, 1000, 1.2)
    MakeFlyingGiantCharacterPhysics(inst, 1000, 1.3)    --参数2为质量，参数3为碰撞半径

    inst.AnimState:SetBank("boarrior")
    inst.AnimState:SetBuild("lavaarena_boarrior_basic")
    inst.AnimState:PlayAnimation("idle_loop", true)
    OverrideSymbols(inst, false)

    inst.Light:Enable(false)
    inst.Light:SetRadius(4)
    inst.Light:SetFalloff(2)
    inst.Light:SetIntensity(.6) --光强
    inst.Light:SetColour(15 / 255, 160 / 255, 180 / 255)

    -------------

    inst:AddTag("hostile")	--敌对标签
    inst:AddTag("scarytoprey")	--吓跑小动物标签
    inst:AddTag("largecreature")
    inst:AddTag("epic")
    inst:AddTag("flying")
    inst:AddTag("electrified")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("knownlocations")

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(12000)
    inst.components.health.destroytime = 6 --延长死亡后遗体消失的时间

	inst:AddComponent("lootdropper")
    AddSpecialLoot(inst)

	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(axewave_damage)
	inst.components.combat:SetAttackPeriod(axewave_period)
	inst.components.combat:SetRange(axewave_range, hit_range)	--设置攻击发出距离与攻击生效距离
	inst.components.combat.battlecryenabled = false
	inst.components.combat.hiteffectsymbol = "pelvis"
	inst.components.combat:SetKeepTargetFunction(KeepTargetFn)	--保持对敌人的仇恨？
	inst.components.combat:SetRetargetFunction(2, RetargetFn)	--主动搜索可攻击的敌人
	inst:ListenForEvent("attacked", OnAttacked)

	inst:AddComponent("sleeper")
	inst.components.sleeper:SetResistance(4)
	inst.components.sleeper:SetSleepTest(ShouldSleep)
	inst.components.sleeper:SetWakeTest(ShouldWake)
    inst.components.sleeper.diminishingreturns = true

    inst:AddComponent("inspectable")

    inst:AddComponent("timer")
    -- inst:ListenForEvent("timerdone", OnTimerDone)

    inst:AddComponent("healthtrigger")

    inst:ListenForEvent("death", OnDeath)

    -- MakeMediumFreezableCharacter(inst, "pelvis")
    -- MakeMediumBurnableCharacter(inst, "body")

	------------

	inst.irritated = false          --标志boss是否处于暴怒状态
    inst.hasirritatedskin = false   --标志是否换上了暴怒状态的贴图
    inst.wantstotaunt = true        --标志是否需要自爆，默认为true，使其在产生时先自爆一次
    inst.fx_irritated = nil         --暴怒状态下的特效
    inst.deathcounter = 0            --死亡计数器
    inst._deathcountertask = nil
    inst.UpdateDeathCounter = UpdateDeathCounter
    inst.healthPercent = nil

    inst.callforlightning_cd = 120
    inst.flashwhirl_cd = 60
    inst.axeuppercut_cd = 12
    inst.heavyhack_cd = 12
    inst.rangesplash_cd = 5

    inst.flashwhirl_radius = flashwhirl_radius
    inst.rangesplash_radius_max = rangesplash_radius_max
    inst.rangesplash_radius_min = rangesplash_radius_min
    inst.rangesplash_radius_max_sq = rangesplash_radius_max*rangesplash_radius_max
    inst.rangesplash_radius_min_sq = rangesplash_radius_min*rangesplash_radius_min
    inst.heavyhack_radius = heavyhack_radius
    inst.heavyhack_radius_sq = heavyhack_radius*heavyhack_radius
    inst.hit_range = hit_range
    inst.hit_range_sq = hit_range*hit_range

    inst.last_skilltest = GetTime()

    if not inst.components.timer:TimerExists("axeuppercut_cd") then
        inst.components.timer:StartTimer("axeuppercut_cd", inst.axeuppercut_cd)
    end
    if not inst.components.timer:TimerExists("flashwhirl_cd") then
        inst.components.timer:StartTimer("flashwhirl_cd", inst.flashwhirl_cd)
    end
    if not inst.components.timer:TimerExists("callforlightning_cd") then
        inst.components.timer:StartTimer("callforlightning_cd", inst.callforlightning_cd)
    end
    if not inst.components.timer:TimerExists("heavyhack_cd") then
        inst.components.timer:StartTimer("heavyhack_cd", inst.heavyhack_cd)
    end
    if not inst.components.timer:TimerExists("rangesplash_cd") then
        inst.components.timer:StartTimer("rangesplash_cd", inst.rangesplash_cd)
    end

	inst.CallForLightning = CallForLightning
	inst.FlashWhirl = FlashWhirl
	inst.BattleCry = BattleCry
	inst.RangeSplash = RangeSplash
	inst.AxeUppercut = AxeUppercut
	inst.HeavyHack = HeavyHack
    inst.DashStep = DashStep

    inst.OnIrritated = OnIrritated

	------------

	inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
	inst.components.locomotor:EnableGroundSpeedMultiplier(false)
	inst.components.locomotor.runspeed = 6
	inst.components.locomotor.walkspeed = 4

	inst:SetStateGraph("SGelecarmet")	--这里是sg的文件名
    inst:SetBrain(brain)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    ------------

	-- inst:AddComponent("sanityaura")
	-- inst:AddComponent("explosiveresist")

    return inst
end

return Prefab("elecarmet", fn, assets, prefabs)
