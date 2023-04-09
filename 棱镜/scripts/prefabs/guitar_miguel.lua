local assets = {
    Asset("ANIM", "anim/guitar_miguel.zip"),
    Asset("ANIM", "anim/swap_guitar_miguel.zip"),
    Asset("ATLAS", "images/inventoryimages/guitar_miguel.xml"),
    Asset("IMAGE", "images/inventoryimages/guitar_miguel.tex"),

    Asset("ANIM", "anim/ghost_pig_build.zip"),
    Asset("ANIM", "anim/ghost_pirate_build.zip"),
}

local prefabs = {
    "ghost",
    "guitar_miguel_ground_fx",
    "guitar_miguel_float_fx",
}

local ghost_builds = {
    "ghost_pig_build",
    "ghost_pirate_build",
    "ghost_wes_build",
    "ghost_wolfgang_build",
    "ghost_wendy_build",
    "ghost_wx78_build",
    "ghost_willow_build",
    "ghost_wilson_build",
    "ghost_winona_build",
    "ghost_wickerbottom_build",
    "ghost_webber_build",
    "ghost_wathgrithr_build",
    "ghost_abigail_build",
    "ghost_waxwell_build",
    "ghost_werebeaver_build",
    "ghost_woodie_build",
}

------

local theta1 = 0
local theta2 = 2 * PI / 3
local theta3 = theta2 * 2
local theta =
{
    theta1,
    theta2,
    theta3,
}

local function PlayStart(inst, owner)
    owner.AnimState:OverrideSymbol("swap_guitar","swap_guitar_miguel","swap_guitar_miguel")
end

local function PlayDoing(inst, owner)
    owner.AnimState:PlayAnimation("soothingplay_loop", true)
    -- if owner.components.playervision ~= nil then
    --     owner.components.playervision:ForceNightVision(true)    --夜视开启！
    -- end

    if inst.playtask ~= nil then
        inst.playtask:Cancel()
        inst.playtask = nil
    end

    if inst.fxtask ~= nil then
        inst.fxtask:Cancel()
        inst.fxtask = nil
    end

    inst.taskcount = 0
    inst.ghostfriends = {}

    inst.playtask = inst:DoPeriodicTask(5, function()
        local x, y, z = owner.Transform:GetWorldPosition()
        if inst.basefx == nil then
            inst.basefx = SpawnPrefab("guitar_miguel_ground_fx")
            inst.basefx.Transform:SetPosition(x, y, z)
        else
            if inst.basefx:GetDistanceSqToPoint(x, y, z) > 0.25 then
                inst.basefx.DoRemove(inst.basefx)
                inst.basefx = SpawnPrefab("guitar_miguel_ground_fx")
                inst.basefx.Transform:SetPosition(x, y, z)
            end
        end

        inst.taskcount = inst.taskcount + 1

        if inst.taskcount % 3 == 0 then --每15秒，复活1个周围的玩家
            local player = FindEntity(owner, 25, nil, {"playerghost"}, {"INLIMBO"}, nil)
            if player ~= nil then
                player:PushEvent("respawnfromghost", { source = inst, user = owner })
                inst.components.finiteuses:Use(1)

                local xp, yp, zp = player.Transform:GetWorldPosition()
                SpawnPrefab("guitar_miguel_float_fx").Transform:SetPosition(xp, 0.8 + math.random(), zp)
                SpawnPrefab("guitar_miguel_float_fx").Transform:SetPosition(xp, 0.8 + math.random(), zp)

                owner:DoTaskInTime(1, function()    --这里由使用者来操作，防止琴坏掉时这里不运行了
                    local ground = SpawnPrefab("guitar_miguel_ground_fx")
                    ground.AnimState:PlayAnimation("idle_ground_small", false)
                    ground.Transform:SetPosition(xp, 0, zp)
                    ground.DoRemove(ground)

                    if player:IsValid() then
                        if player.components.health ~= nil and not player.components.health:IsDead() then
                            player.components.health:SetPercent(1)

                            if player.components.hunger ~= nil then
                                player.components.hunger:SetPercent(1)
                            end

                            if player.components.sanity ~= nil then
                                player.components.sanity:SetPercent(1)
                            end
                        end
                    end
                end)
            end
        end

        if inst.taskcount <= 3 then --逐渐生成3个鬼魂
            local ghost = SpawnPrefab("ghost")

            ghost.AnimState:SetBuild(ghost_builds[math.random(#ghost_builds)])

            ghost.components.aura:Enable(false)
            table.insert(ghost.components.aura.auraexcludetags, "_combat") --不让鬼魂具有攻击性
            ghost:RemoveTag("hostile")  --不让鬼魂具有敌对性
            ghost:RemoveTag("monster")

            -- if ghost.brain then
            --     ghost.brain.followtarget = owner
            -- end
            ghost.persists = false

            local rad = math.random(3, 15)
            local angle = math.random() * 2 * PI
            ghost.Transform:SetPosition(x + rad * math.cos(angle), y, z - rad * math.sin(angle))

            table.insert(inst.ghostfriends, ghost)
        end

        local ents = TheSim:FindEntities(x, y, z, 25, { "tendable_farmplant" }, { "INLIMBO" })
        for _,v in ipairs(ents) do
            if v.components.farmplanttendable ~= nil then
                v.components.farmplanttendable:TendTo(owner)
            end
        end
    end, 2)

    inst.posindex = 1
    inst.fxtask = inst:DoPeriodicTask(0.8, function()
        local x, y, z = owner.Transform:GetWorldPosition()
        local the = theta[inst.posindex]
        SpawnPrefab("guitar_miguel_float_fx").Transform:SetPosition(x + 1 * math.cos(the), 0.8 + math.random(), z - 1 * math.sin(the))

        inst.posindex = inst.posindex + 1
        if inst.posindex > 3 then
            inst.posindex = 1
        end
    end)

    owner.SoundEmitter:PlaySound("legion/guitar_songs/remember_me", "song")
    owner.SoundEmitter:SetVolume("song",0.5)
    -- owner.SoundEmitter:PlaySound("legion/guitar_songs/flower", "song")
    -- owner.SoundEmitter:PlaySound("legion/guitar_songs/break_riff")  --这音乐只播放一次，有11秒
end

local function PlayEnd(inst, owner)
    if inst.playtask ~= nil then
        inst.playtask:Cancel()
        inst.playtask = nil
        inst.taskcount = nil
    end

    if inst.fxtask ~= nil then
        inst.fxtask:Cancel()
        inst.fxtask = nil
        inst.posindex = nil
    end

    if inst.ghostfriends ~= nil then
        for i, v in ipairs(inst.ghostfriends) do
            if v:IsValid() then
                local x, y, z = v.Transform:GetWorldPosition()
                SpawnPrefab("guitar_miguel_float_fx").Transform:SetPosition(x, 0.8 + math.random(), z)
                v:Remove()
            end
        end

        inst.ghostfriends = nil
    end

    if inst.basefx ~= nil then
        inst.basefx.DoRemove(inst.basefx)
        inst.basefx = nil
    end

    -- if owner.components.playervision ~= nil then
    --     owner.components.playervision:ForceNightVision(false)    --夜视关闭！
    -- end

    owner.SoundEmitter:KillSound("song")

    if inst.broken then
        inst:Remove()
    end
end

local function OnFinished(inst)
    local owner = inst.components.inventoryitem:GetGrandOwner()
    if owner ~= nil then
        owner:PushEvent("playenough")
    end
    inst.broken = true
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst:AddTag("guitar")

    inst.AnimState:SetBank("guitar_miguel")
    inst.AnimState:SetBuild("guitar_miguel")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "med", 0.3, 0.8)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("instrument")

    inst.PlayStart = PlayStart
    inst.PlayDoing = PlayDoing
    inst.PlayEnd = PlayEnd

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(5)
    inst.components.finiteuses:SetUses(5)
    inst.components.finiteuses:SetOnFinished(OnFinished)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "guitar_miguel"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/guitar_miguel.xml"

    MakeHauntableLaunch(inst)

    return inst
end

----------
----------

local assets_ground =
{
    Asset("ANIM", "anim/guitar_miguel_fx.zip"),
}

local prefabs_ground =
{
    "guitar_miguel_dirt_fx",
}

local function OnGroundRemove(inst)
    inst:DoTaskInTime(45, function()
        if inst.dirtfx ~= nil then
            for i, v in ipairs(inst.dirtfx) do
                if v:IsValid() then
                    v:Remove()
                end
            end

            inst.dirtfx = nil
        end

        inst:Remove()
    end)
end

local function fn_ground()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("guitar_miguel_fx")
    inst.AnimState:SetBuild("guitar_miguel_fx")
    inst.AnimState:PlayAnimation("idle_ground", false)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetFinalOffset(-1)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    -- inst.Transform:SetScale(1.5, 1.5, 1.5)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
      return inst
    end

    inst.dirtfx = {}
    inst:DoTaskInTime(1, function()
        local x, y, z = inst.Transform:GetWorldPosition()

        for k, v in pairs(theta) do
            local fx = SpawnPrefab("guitar_miguel_dirt_fx")
            fx.Transform:SetPosition(x + 0.5 * math.cos(v), y + 0.1, z - 0.5 * math.sin(v))
            table.insert(inst.dirtfx, fx)
        end

        local fx = SpawnPrefab("guitar_miguel_dirt_fx")
        fx.Transform:SetPosition(x, y + 0.1, z)
        table.insert(inst.dirtfx, fx)
    end)

    inst.DoRemove = OnGroundRemove

    inst.persists = false

    return inst
end

----------
----------

local function fn_dirt()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("guitar_miguel_fx")
    inst.AnimState:SetBuild("guitar_miguel_fx")
    inst.AnimState:PlayAnimation("idle"..tostring(math.random(1, 3)))
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    -- inst.AnimState:SetSortOrder(3)
    -- inst.AnimState:SetFinalOffset(-1)
    -- inst.Transform:SetScale(1.5, 1.5, 1.5)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
      return inst
    end

    inst.persists = false

    return inst
end

return Prefab("guitar_miguel", fn, assets, prefabs),
        Prefab("guitar_miguel_ground_fx", fn_ground, assets_ground, prefabs_ground),
        Prefab("guitar_miguel_dirt_fx", fn_dirt, assets_ground)
