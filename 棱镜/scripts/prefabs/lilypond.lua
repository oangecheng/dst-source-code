-- name = "splash_water",
-- bank = "splash_water",
--   393:      build = "splash_water",
--   394       anim = "idle",
local PI25 = 0.25 * PI
local PI50 = 0.5 * PI
local TILE_SCALE50 = 0.5 * TILE_SCALE

local assets_shore =
{
    Asset("ANIM", "anim/lilypond_shore_fx.zip"),
}

local function IsValidTile(tile)
    return tile ~= nil and tile ~= GROUND.IMPASSABLE
end

local function IsPondTile(tile)
    return tile ~= nil and GROUND["LILYPOND_DEEP"] and tile == GROUND["LILYPOND_DEEP"]
end

local function SetAnim(inst)
    local ex, ey, ez = inst.Transform:GetWorldPosition()
    local bearing = -(inst.Transform:GetRotation() + 90) * DEGREES
    ey = 0

    local map = TheWorld.Map
    local tr45 = map:GetTileAtPoint(ex + math.cos(bearing - PI25), ey, ez + math.sin(bearing - PI25))
    local tr90 = map:GetTileAtPoint(ex + math.cos(bearing - PI50), ey, ez + math.sin(bearing - PI50))
    local tl45 = map:GetTileAtPoint(ex + math.cos(bearing + PI25), ey, ez + math.sin(bearing + PI25))
    local tl90 = map:GetTileAtPoint(ex + math.cos(bearing + PI50), ey, ez + math.sin(bearing + PI50))

    local left = IsValidTile(tl45) and IsPondTile(tl90)
    local right = IsValidTile(tr45) and IsPondTile(tr90)

    if left and right then
        inst.AnimState:PlayAnimation("idle_big", false)
    elseif left then
        inst.Transform:SetPosition(ex - TILE_SCALE50 * math.cos(bearing - PI50), ey, ez - TILE_SCALE50 * math.sin(bearing - PI50))
        inst.AnimState:PlayAnimation("idle_med", false)
    elseif right then
        inst.Transform:SetPosition(ex + TILE_SCALE50 * math.cos(bearing - PI50), ey, ez + TILE_SCALE50 * math.sin(bearing - PI50))
        inst.AnimState:PlayAnimation("idle_med", false)
    else
        local small = {"idle_small", "idle_small2", "idle_small3", "idle_small4"}
        inst.AnimState:PlayAnimation(small[math.random(1, #small)], false)
    end
end

local function OnEntitySleep_shore(inst)
    if not POPULATING then
        inst:Remove()
    end
end

local function fn_shore()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("wave_shore")
    inst.AnimState:SetBuild("lilypond_shore_fx")
    inst.AnimState:PlayAnimation("idle_small", false)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    -- inst.AnimState:SetFinalOffset(-1)
    -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    -- inst.Transform:SetScale(1.5, 1.5, 1.5)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
      return inst
    end

    inst:ListenForEvent("animover", inst.Remove)

    inst.SetAnim = SetAnim

    inst.OnEntitySleep = OnEntitySleep_shore

    inst.persists = false

    return inst
end

----------
----------

-- local assets =
-- {
--     -- Asset("ANIM", "anim/guitar_miguel.zip"),
-- }

local prefabs =
{
    "lilypond_shore_fx",
    "lilypond_ripple_fx",
    -- "guitar_miguel_float_fx",
}

local function GetRandomPoint(inst, radius)
    local x, y, z = inst.Transform:GetWorldPosition()
    local rad = radius or 12 * math.random()
    local angle = math.random() * 2 * PI

    return x + rad * math.cos(angle), y, z - rad * math.sin(angle)
end

local function GetWaveBearing(ex, ey, ez)
    local offs =
    {
        {-2,-2}, {-1,-2}, {0,-2}, {1,-2}, {2,-2},
        {-2,-1}, {-1,-1}, {0,-1}, {1,-1}, {2,-1},
        {-2, 0}, {-1, 0},         {1, 0}, {2, 0},
        {-2, 1}, {-1, 1}, {0, 1}, {1, 1}, {2, 1},
        {-2, 2}, {-1, 2}, {0, 2}, {1, 2}, {2, 2}
    }

    local map = TheWorld.Map
    local width, height = map:GetSize()
    local halfw, halfh = 0.5 * width, 0.5 * height

    local x, y = map:GetTileCoordsAtPoint(ex, 0, ez)
    local xtotal, ztotal, n = 0, 0, 0
    for i = 1, #offs, 1 do
        local ground = map:GetTile( x + offs[i][1], y + offs[i][2] )
        if not IsPondTile(ground) or not IsValidTile(ground) then
            xtotal = xtotal + ((x + offs[i][1] - halfw) * TILE_SCALE)
            ztotal = ztotal + ((y + offs[i][2] - halfh) * TILE_SCALE)
            n = n + 1
        end
    end

    local bearing = nil
    if n > 0 then
        local a = math.atan2(ztotal/n - ez, xtotal/n - ex)
        bearing = -a/DEGREES - 90
    end

    return bearing
end

local function Waving(inst)
    local x, y, z = GetRandomPoint(inst)

    if IsPondTile(TheWorld.Map:GetTileAtPoint(x, 0, z)) then
        local bearing = GetWaveBearing(x, y, z)
        if bearing then
            local wave = SpawnPrefab("lilypond_shore_fx")
            wave.Transform:SetPosition(x, y, z)
            wave.Transform:SetRotation(bearing)
            wave:SetAnim()
        end
    end

    local player = FindEntity(inst, 20, nil, nil, {"NOCLICK", "FX", "INLIMBO"}, {"player"})
    if player ~= nil and player.wavefx == nil then
        local plant = SpawnPrefab("lilypond_ripple_fx")
        if plant ~= nil then
            plant.entity:SetParent(player.entity)
            plant.Transform:SetPosition(0, 0.25, 0)
            plant.Transform:SetScale(0.6, 0.6, 0.6)
            plant.persists = false
            player.wavefx = plant
            -- table.insert(inst.plant_ents, plant)
        end
    end
end

local function StartWaving(inst)
    if inst.wavetask == nil then
        inst.wavetask = inst:DoPeriodicTask(1.5, function()
            Waving(inst)
        end, 2)
    end
end

local function StopWaving(inst)
    if inst.wavetask ~= nil then
        inst.wavetask:Cancel()
        inst.wavetask = nil
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.OnEntitySleep = StopWaving
    inst.OnEntityWake = StartWaving

    inst:DoTaskInTime(1, function()
        if FindEntity(inst, 30, nil, nil, {"NOCLICK", "FX", "INLIMBO"}, {"player", "playerghost"}) then
            StartWaving(inst)
        end
    end)

    return inst
end

----------
----------

local assets_ripple =
{
    Asset("ANIM", "anim/lilypond_ripple_fx.zip"),
    Asset("ANIM", "anim/ripple_build.zip"),
}

local function fn_ripple()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("spear_poison")
    inst.AnimState:SetBuild("ripple_build")
    inst.AnimState:PlayAnimation("idle_water", true)
    inst.AnimState:OverrideSymbol("water_shadow", "lilypond_ripple_fx", "water_shadow")
    -- inst.AnimState:OverrideSymbol("water_ripple", "lilypond_ripple_fx", "water_ripple")

    -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    -- inst.AnimState:SetSortOrder(1)
    -- inst.AnimState:SetFinalOffset(-1)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
      return inst
    end

    inst.persists = false

    return inst
end

return Prefab("lilypond_shore_fx", fn_shore, assets_shore),
        Prefab("lilypond_manager", fn, nil, prefabs),
        Prefab("lilypond_ripple_fx", fn_ripple, assets_ripple)
