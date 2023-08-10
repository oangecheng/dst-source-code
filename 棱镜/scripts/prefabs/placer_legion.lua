local prefs = {}

--------------------------------------------------------------------------
--[[ 通用 ]]
--------------------------------------------------------------------------

----建筑物placer兼容：建筑的皮肤placer请看playercontroller.StartBuildPlacementMode
local function Skined_build(inst)
    --之所以把皮肤修改写到 SetBuilder 里，是因为 Skined_build 执行时还没有皮肤数据
    local SetBuilder_old = inst.components.placer.SetBuilder
    inst.components.placer.SetBuilder = function(self, ...)
        SetBuilder_old(self, ...)
        if self.builder and self.builder.components.playercontroller ~= nil then
            local skin = self.builder.components.playercontroller.placer_recipe_skin
            if skin and SKINS_LEGION[skin] and SKINS_LEGION[skin].fn_placer then
                SKINS_LEGION[skin].fn_placer(self.inst)
            end
        end
    end
end

----放置物placer兼容：放置物的皮肤placer请看playercontroller.OnUpdate
local function Skined_deploy(inst, toskinprefab, skinfn)
    --之所以把皮肤修改写到 SetBuilder 里，是因为 Skined_build 执行时还没有皮肤数据
    local SetBuilder_old = inst.components.placer.SetBuilder
    inst.components.placer.SetBuilder = function(self, ...)
        SetBuilder_old(self, ...)

        local skin = nil
        if skinfn ~= nil then
            skin = skinfn(self)
        else
            if self.builder and self.builder.userid ~= nil and SKINS_CACHE_CG_L[self.builder.userid] ~= nil then
                skin = SKINS_CACHE_CG_L[self.builder.userid][toskinprefab]
            end
        end
        if skin and SKINS_LEGION[skin] and SKINS_LEGION[skin].fn_placer then
            SKINS_LEGION[skin].fn_placer(self.inst)
        end
    end
end

local function CreatePlacer(name, ...)
    table.insert(prefs, MakePlacer(name.."_placer", ...))
end

--------------------------------------------------------------------------
--[[ 花香四溢 ]]
--------------------------------------------------------------------------

local function GetSkin_base(placer)
    if placer.invobject == nil then
        return
    end
    return placer.invobject.components.skinedlegion:GetSkin()
end
local function Fn_bush(inst)
    inst.AnimState:Hide("berriesmost")
    inst.AnimState:Hide("berriesmore")
    inst.AnimState:Hide("berries")
    -- inst.AnimState:Pause() --Tip：使用这个函数会导致 placer 的动画面向固定为一个面，在视角旋转后没法响应面向变化
    if inst.AnimState:IsCurrentAnimation("idle") then
        inst.AnimState:SetPercent("idle", 0) --Tip：这个函数也能停止动画，但不会导致 Pause() 的问题
    else
        inst.AnimState:SetPercent("dead", 0)
    end
end
local function Fn_rosebush(inst)
    -- inst.components.placer.onupdatetransform = function(inst)
    --     inst.Transform:SetRotation(0)
    -- end
    Skined_deploy(inst, "rosebush")
    Fn_bush(inst)
end
local function Fn_lilybush(inst)
    Skined_deploy(inst, "lilybush")
    Fn_bush(inst)
end
local function Fn_orchidbush(inst)
    Skined_deploy(inst, "orchidbush")
    Fn_bush(inst)
end
local function Fn_neverfade(inst)
    Skined_deploy(inst, nil, GetSkin_base)
    Fn_bush(inst)
end

----折枝、芽束、种籽的：种成生长状态
CreatePlacer("cutted_rosebush", "berrybush2", "rosebush", "idle", nil, nil, nil, nil, nil, "two", Fn_rosebush)
CreatePlacer("cutted_lilybush", "berrybush2", "lilybush", "idle", nil, nil, nil, nil, nil, "two", Fn_lilybush)
CreatePlacer("cutted_orchidbush", "berrybush2", "orchidbush", "idle", nil, nil, nil, nil, nil, "two", Fn_orchidbush)

----挖起的花丛：种成枯萎状态
CreatePlacer("dug_rosebush", "berrybush2", "rosebush", "dead", nil, nil, nil, nil, nil, "two", Fn_rosebush)
CreatePlacer("dug_lilybush", "berrybush2", "lilybush", "dead", nil, nil, nil, nil, nil, "two", Fn_lilybush)
CreatePlacer("dug_orchidbush", "berrybush2", "orchidbush", "dead", nil, nil, nil, nil, nil, "two", Fn_orchidbush)

----永不凋零
CreatePlacer("neverfade", "berrybush2", "neverfadebush", "idle", nil, nil, nil, nil, nil, "two", Fn_neverfade)

--------------------------------------------------------------------------
--[[ 丰饶传说 ]]
--------------------------------------------------------------------------

local function Fn_derivant(inst)
    Skined_deploy(inst, "siving_derivant")
    inst.AnimState:SetScale(1.3, 1.3)
    inst.AnimState:SetPercent("lvl0", 0)
end

----子圭奇型岩
CreatePlacer("siving_derivant_item", "siving_derivant", "siving_derivant", "lvl0", nil, nil, nil, nil, nil, "two", Fn_derivant)

----子圭·垄
CreatePlacer("siving_soil_item", "farm_soil", "siving_soil", "till_idle")

----子圭·育
CreatePlacer("siving_turn", "siving_turn", "siving_turn", "idle", nil, nil, nil, nil, nil, nil, Skined_build)

----异种
local skinedplant = {
	cactus_meat = true
}
local function GetPlacerAnim(anims)
    if type(anims) == 'table' then
        return anims[ #anims ]
    else
        return anims
    end
end
local function Fn_xeeds(inst, v)
    inst.AnimState:SetPercent(GetPlacerAnim(v.leveldata[1].anim), 0)
    inst.AnimState:OverrideSymbol("soil", "crop_soil_legion", "soil")
    if v.cluster_size ~= nil then
        inst.AnimState:SetScale(v.cluster_size[1], v.cluster_size[1], v.cluster_size[1])
    end
end
for k,v in pairs(CROPS_DATA_LEGION) do
    CreatePlacer(
        "seeds_"..k.."_l", v.bank, v.build, GetPlacerAnim(v.leveldata[1].anim),
        nil, nil, nil, nil, nil, "two", function(inst)
            if skinedplant[k] then
                Skined_deploy(inst, "plant_"..k.."_l")
            end
            Fn_xeeds(inst, v)
        end
    )
end

----子圭·利川/益矩/崇溟
local PLACER_SCALE_CTL = 1.79 --这个大小就是20半径的
local ctls = { "water", "dirt", "all" }
local function Fn_ctl(inst, basename)
    local placer2 = CreateEntity()

    --[[Non-networked entity]]
    placer2.entity:SetCanSleep(false)
    placer2.persists = false

    placer2.entity:AddTransform()
    placer2.entity:AddAnimState()

    placer2:AddTag("CLASSIFIED")
    placer2:AddTag("NOCLICK")
    placer2:AddTag("placer")

    local s = 1 / PLACER_SCALE_CTL
    placer2.Transform:SetScale(s, s, s)

    placer2.AnimState:SetBank(basename)
    placer2.AnimState:SetBuild(basename)
    placer2.AnimState:PlayAnimation("idle")
    placer2.AnimState:SetLightOverride(1)

    placer2.entity:SetParent(inst.entity)

    inst.placerbase_l = placer2
    inst.components.placer:LinkEntity(placer2)
end
for _, pst in ipairs(ctls) do
    local basename = "siving_ctl"..pst
    CreatePlacer(
        basename.."_item", "firefighter_placement", "firefighter_placement", "idle",
        true, nil, nil, PLACER_SCALE_CTL, nil, nil, function(inst)
            Fn_ctl(inst, basename)
            Skined_deploy(inst, nil, GetSkin_base)
        end
    )
end
ctls = nil

--------------------------------------------------------------------------
--[[ 祈雨祭 ]]
--------------------------------------------------------------------------

----雨竹块茎
local function Fn_monstrain(inst)
    inst.AnimState:SetPercent("idle_summer", 0)
    inst.Transform:SetScale(1.4, 1.4, 1.4)
end
CreatePlacer("dug_monstrain", "monstrain", "monstrain", "idle_summer", nil, nil, nil, nil, nil, nil, Fn_monstrain)

--------------------------------------------------------------------------
--[[ 电闪雷鸣 ]]
--------------------------------------------------------------------------

----蛛网标记
CreatePlacer("web_hump_item", "web_hump", "web_hump", "anim")

--------------------------------------------------------------------------
--[[ 尘世蜃楼 ]]
--------------------------------------------------------------------------

----地垫、地毯
CreatePlacer("carpet_whitewood", "carpet_whitewood", "carpet_whitewood", "idle", true, nil, nil, nil, 90, nil, Skined_build)
CreatePlacer("carpet_whitewood_big", "carpet_whitewood", "carpet_whitewood", "idle_big", true, nil, nil, nil, 90, nil, Skined_build)
CreatePlacer("carpet_plush", "carpet_plush", "carpet_plush", "idle", true, nil, nil, nil, 90, nil, Skined_build)
CreatePlacer("carpet_plush_big", "carpet_plush", "carpet_plush", "idle_big", true, nil, nil, nil, 90, nil, Skined_build)

----颤栗果
CreatePlacer("shyerry", "shyerrytree1", "shyerrytree1", "placer")

----白木地片
CreatePlacer("mat_whitewood_item", "mat_whitewood", "mat_whitewood", "idle1", true)

--------------------
--------------------

return unpack(prefs)
