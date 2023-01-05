-- local assets =
-- {
--     Asset("ANIM", "anim/flare.zip"),
--     Asset("ANIM", "anim/medal_rain_bomb.zip"),
--     Asset("ANIM", "anim/medal_clear_up_bomb.zip"),
--     Asset("ANIM", "anim/flare_water.zip"),
--     Asset("INV_IMAGE", "miniflare"),
-- 	Asset("ATLAS", "images/medal_rain_bomb.xml"),
-- 	Asset("ATLAS", "images/medal_clear_up_bomb.xml"),
-- 	Asset("ATLAS_BUILD", "images/medal_rain_bomb.xml",256),
-- 	Asset("ATLAS_BUILD", "images/medal_clear_up_bomb.xml",256),
-- }

local prefabs =
{
    "miniflare_minimap",
}

local function on_ignite_over(inst)
    if inst.ignitefn then
        inst:ignitefn()
    end
	
	local fx, fy, fz = inst.Transform:GetWorldPosition()

    local random_angle = math.pi * 2 * math.random()
    local random_radius = -(TUNING.MINIFLARE.OFFSHOOT_RADIUS) + (math.random() * 2 * TUNING.MINIFLARE.OFFSHOOT_RADIUS)

    fx = fx + (random_radius * math.cos(random_angle))
    fz = fz + (random_radius * math.sin(random_angle))

    -------------------------------------------------------------
    --生成小地图图标
    local minimap = SpawnPrefab("miniflare_minimap")
    minimap.Transform:SetPosition(fx, fy, fz)
    minimap:DoTaskInTime(TUNING.MINIFLARE.TIME, function()
        minimap:Remove()
    end)

    inst:Remove()
end
--燃放
local function on_ignite(inst)
    --发射后实体就不应该存在了
    inst.persists = false
    inst.entity:SetCanSleep(false)

    inst.AnimState:PlayAnimation("fire")
    inst:ListenForEvent("animover", on_ignite_over)

    inst.SoundEmitter:PlaySound("turnoftides/common/together/miniflare/launch")
end

local function on_dropped(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", false)
end

local function MakeBomb(def)
    local assets =
    {
        Asset("ANIM", "anim/flare.zip"),
        Asset("ANIM", "anim/flare_water.zip"),
        Asset("INV_IMAGE", "miniflare"),
        Asset("ANIM", "anim/"..def.build..".zip"),
        Asset("ATLAS", "images/"..def.image..".xml"),
        Asset("ATLAS_BUILD", "images/"..def.image..".xml",256),
    }
    local function fn()
        local inst = CreateEntity()
    
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
    
        MakeInventoryPhysics(inst)
    
        inst.AnimState:SetBank("flare")
        inst.AnimState:SetBuild(def.build)
        inst.AnimState:PlayAnimation("idle")
    
        MakeInventoryFloatable(inst, "large", nil, {0.65, 0.4, 0.65})
    
        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.ignitefn = def.ignitefn--燃放回调
    
        inst:AddComponent("tradable")
    
        inst:AddComponent("inspectable")
    
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = def.image
        inst.components.inventoryitem.atlasname = "images/"..def.image..".xml"
    
        inst:AddComponent("burnable")
        inst.components.burnable:SetOnIgniteFn(on_ignite)
    
        MakeSmallPropagator(inst)
        inst.components.propagator.heatoutput = 0
        inst.components.propagator.damages = false
    
        MakeHauntableLaunch(inst)
    
        inst:ListenForEvent("ondropped", on_dropped)
        inst:ListenForEvent("floater_startfloating", function(inst) inst.AnimState:PlayAnimation("float") end)
        inst:ListenForEvent("floater_stopfloating", function(inst) inst.AnimState:PlayAnimation("idle") end)
    
        return inst
    end
    return Prefab(def.name, fn, assets, prefabs)
end

local bomb_defs={
    {
        name="medal_rain_bomb",--催雨弹
        image="medal_rain_bomb",
        build="medal_rain_bomb",
        ignitefn=function(inst)--燃放回调函数
            TheWorld:PushEvent("ms_forceprecipitation", true)
        end,
    },
    {
        name="medal_clear_up_bomb",--放晴弹
        image="medal_clear_up_bomb",
        build="medal_clear_up_bomb",
        ignitefn=function(inst)--燃放回调函数
            TheWorld:PushEvent("ms_forceprecipitation", false)
        end,
    },
    {
        name="medal_spacetime_bomb",--时空弹
        image="medal_spacetime_bomb",
        build="medal_spacetime_bomb",
        ignitefn=function(inst)--燃放回调函数
            local pt=inst:GetPosition()
            if TheWorld and TheWorld.net.components.medal_spacetimestorms ~= nil and TheWorld.net.components.medal_spacetimestorms:IsPointInSpacetimestorm(pt) then
                TheWorld.components.medal_spacetimestormmanager:StopCurrentSpacetimestorm()
            end
        end,
    },
}

local bombs={}
for k, v in ipairs(bomb_defs) do
    table.insert(bombs, MakeBomb(v))
end
return unpack(bombs)