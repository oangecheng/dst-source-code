local prefabFiles = {
    -- "lilypond",             --荷花池相关特效
    "shyerries",            --颤栗树相关
    "sand_spike_legion",    --对玩家友好的沙之咬
    "whitewoods",           --白木相关
}

for k,v in pairs(prefabFiles) do
    table.insert(PrefabFiles, v)
end
if CONFIGS_LEGION.DRESSUP then
    table.insert(PrefabFiles, "pinkstaff") --幻象法杖
    table.insert(PrefabFiles, "theemperorsnewclothes") --国王的新衣
end

-----

local assets = {
    Asset("ATLAS", "images/inventoryimages/shyerrylog.xml"), --预加载，给科技栏用的
    Asset("IMAGE", "images/inventoryimages/shyerrylog.tex"),
    Asset("ATLAS", "images/inventoryimages/shield_l_sand.xml"),
    Asset("IMAGE", "images/inventoryimages/shield_l_sand.tex"),
    Asset("ATLAS", "images/inventoryimages/guitar_whitewood.xml"),
    Asset("IMAGE", "images/inventoryimages/guitar_whitewood.tex"),
    Asset("ATLAS", "images/inventoryimages/pinkstaff.xml"),
    Asset("IMAGE", "images/inventoryimages/pinkstaff.tex"),
    Asset("ATLAS", "images/inventoryimages/theemperorscrown.xml"),
    Asset("IMAGE", "images/inventoryimages/theemperorscrown.tex"),
    Asset("ATLAS", "images/inventoryimages/theemperorsmantle.xml"),
    Asset("IMAGE", "images/inventoryimages/theemperorsmantle.tex"),
    Asset("ATLAS", "images/inventoryimages/theemperorsscepter.xml"),
    Asset("IMAGE", "images/inventoryimages/theemperorsscepter.tex"),
    Asset("ATLAS", "images/inventoryimages/theemperorspendant.xml"),
    Asset("IMAGE", "images/inventoryimages/theemperorspendant.tex"),
    Asset("ATLAS", "images/inventoryimages/mat_whitewood_item.xml"),
    Asset("IMAGE", "images/inventoryimages/mat_whitewood_item.tex"),
    Asset("ATLAS", "images/inventoryimages/carpet_whitewood_big.xml"),
    Asset("IMAGE", "images/inventoryimages/carpet_whitewood_big.tex"),
    Asset("ATLAS", "images/inventoryimages/carpet_whitewood.xml"),
    Asset("IMAGE", "images/inventoryimages/carpet_whitewood.tex"),
}

for k,v in pairs(assets) do
    table.insert(Assets, v)
end

-----

local _G = GLOBAL
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()

--------------------------------------------------------------------------
--[[ 基础 ]]
--------------------------------------------------------------------------

_G.RegistMiniMapImage_legion("shyerrytree")

--------------------------------------------------------------------------
--[[ 新地皮相关 ]]
--------------------------------------------------------------------------

-- AddComponentPostInit("locomotor", function(self, inst, world_offset)
--     local UpdateGroundSpeedMultiplier_old = self.UpdateGroundSpeedMultiplier
--     self.UpdateGroundSpeedMultiplier = function(self)
--         if not self.inst:HasTag("swimming") then
--             local map = TheWorld.Map
--             local original_tile_type = map:GetTileAtPoint(self.inst.Transform:GetWorldPosition())

--             if original_tile_type ~= nil then
--                 if original_tile_type == GROUND["LILYPOND_DEEP"] then
--                     -- self.groundspeedmultiplier = self.slowmultiplier
--                     self.groundspeedmultiplier = 0.5
--                     self.wasoncreep = false
--                 else
--                     UpdateGroundSpeedMultiplier_old(self)
--                 end
--             else
--                 UpdateGroundSpeedMultiplier_old(self)
--             end
--         else
--             UpdateGroundSpeedMultiplier_old(self)
--         end
--     end
-- end)

--------------------------------------------------------------------------
--[[ 沙之抵御技能相关 ]]
--------------------------------------------------------------------------

-- local function ToggleOffPhysics(inst)
--     inst.sg.statemem.isphysicstoggle = true
--     inst.Physics:ClearCollisionMask()
--     inst.Physics:CollidesWith(COLLISION.GROUND)
-- end

-- local function ToggleOnPhysics(inst)
--     inst.sg.statemem.isphysicstoggle = nil
--     inst.Physics:ClearCollisionMask()
--     inst.Physics:CollidesWith(COLLISION.WORLD)
--     inst.Physics:CollidesWith(COLLISION.OBSTACLES)
--     inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
--     inst.Physics:CollidesWith(COLLISION.CHARACTERS)
--     inst.Physics:CollidesWith(COLLISION.GIANTS)
-- end

-- local sanddefense_enter = GLOBAL.State{
--     name = "sanddefense_enter",
--     tags = { "doing", "hiding", "sanddefense", "nomorph", "busy", "nopredict", "canrotate", "noattack" },

--     onenter = function(inst)
--         inst.components.locomotor:Stop()
--         if inst.components.playercontroller ~= nil then --玩家不能操控
--             inst.components.playercontroller:EnableMapControls(false)
--             inst.components.playercontroller:Enable(false)
--         end
--         inst.components.inventory:Hide()    --物品栏消失
--         inst:ShowActions(false) --鼠标指示活动消失

--         inst.AnimState:PlayAnimation("staff_pre")
--         inst.AnimState:PushAnimation("staff", false)    --播放法杖施法的动画

--         inst.sg:SetTimeout(150 * FRAMES)
--     end,

--     timeline =
--     {
--         TimeEvent(6 * FRAMES, function(inst)
--             inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_nightsword")   --影刀的攻击声音   
--         end),

--         TimeEvent(22 * FRAMES, function(inst)
--             ToggleOffPhysics(inst)
--             inst.Physics:Stop()

--             inst.sg.statemem.fx = GLOBAL.SpawnPrefab("townportalsandcoffin_fx")
--             inst.sg.statemem.fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
--             if inst.sg.statemem.fx.killtask ~= nil then --取消掉传送沙特效的自删除任务
--                 inst.sg.statemem.fx.killtask:Cancel()
--                 inst.sg.statemem.fx.killtask = nil
--             end

--             inst.DynamicShadow:Enable(false)    --去除影子？？？
--         end),

--         TimeEvent(42 * FRAMES, function(inst)
--             inst:Hide()
--         end),
--     },

--     ontimeout = function(inst)
--         inst.sg:GoToState("sanddefense_exit")
--     end,

--     onexit = function(inst)
--         if inst.sg.statemem.fx ~= nil then
--             inst.sg.statemem.fx.Physics:SetActive(false)
--             inst.sg.statemem.fx.SoundEmitter:PlaySound("dontstarve/common/together/teleport_sand/out")
--             inst.sg.statemem.fx.AnimState:PlayAnimation("portal_out")
--             inst.sg.statemem.fx:DoTaskInTime(inst.sg.statemem.fx.AnimState:GetCurrentAnimationLength() + .5, inst.sg.statemem.fx.Remove)
--         end

--         if inst.components.playercontroller ~= nil then
--             inst.components.playercontroller:EnableMapControls(true)
--             inst.components.playercontroller:Enable(true)
--         end
--         inst.components.inventory:Show()
--         inst:ShowActions(true)
--         inst:Show()
--         inst.DynamicShadow:Enable(true)
--     end,
-- }

-- local sanddefense_exit = GLOBAL.State{
--     name = "sanddefense_exit",
--     tags = { "hiding", "sanddefense", "nomorph", "busy", "nopredict", "canrotate" },

--     onenter = function(inst)
--         ToggleOffPhysics(inst)
--         inst.components.locomotor:Stop()
--         inst.AnimState:PlayAnimation("townportal_exit_pst")
--     end,

--     timeline =
--     {
--         TimeEvent(18 * FRAMES, function(inst)
--             if inst.sg.statemem.isphysicstoggle then
--                 ToggleOnPhysics(inst)
--             end
--         end),
--         TimeEvent(26 * FRAMES, function(inst)
--             inst.sg:RemoveStateTag("busy")
--             inst.sg:RemoveStateTag("nopredict")
--         end),
--     },

--     events =
--     {
--         EventHandler("animover", function(inst)
--             if inst.AnimState:AnimDone() then
--                 inst.sg:GoToState("idle")
--             end
--         end),
--     },
-- }

-- AddStategraphState("wilson", sanddefense_enter)
-- --AddStategraphState("wilson_client", sanddefense_enter)    --客户端与服务端的sg有区别，这里只需要服务端有就行了

-- AddStategraphState("wilson", sanddefense_exit)
-- --AddStategraphState("wilson_client", sanddefense_exit)

--------------------------------------------------------------------------
--[[ 新制作物 ]]
--------------------------------------------------------------------------

local function PlacerTest_carpet(pt, rot, tests) --地毯涉及区域得全是地面，不能悬在海上
    if tests == nil then tests = { -1.5, 1.5 } end

    for _, k1 in ipairs(tests) do
        for _, k2 in ipairs(tests) do
            if not TheWorld.Map:IsAboveGroundAtPoint(pt.x+k1, 0, pt.z+k2) then
                return false
            end
        end
    end
	return true
end
local function PlacerTest_carpet2(pt, rot)
	return PlacerTest_carpet(pt, rot, { -3.1, 0, 3.1 })
end

AddRecipe2(
    "carpet_whitewood", {
        Ingredient("shyerrylog", 1, "images/inventoryimages/shyerrylog.xml")
    }, TECH.NONE, {
        placer = "carpet_whitewood_placer", min_spacing = 0,
        atlas = "images/inventoryimages/carpet_whitewood.xml", image = "carpet_whitewood.tex",
        testfn = PlacerTest_carpet
    }, { "DECOR" }
)
AddRecipe2(
    "carpet_whitewood_big", {
        Ingredient("shyerrylog", 4, "images/inventoryimages/shyerrylog.xml")
    }, TECH.SCIENCE_ONE, {
        placer = "carpet_whitewood_big_placer", min_spacing = 0,
        atlas = "images/inventoryimages/carpet_whitewood_big.xml", image = "carpet_whitewood_big.tex",
        testfn = PlacerTest_carpet2
    }, { "DECOR" }
)
AddRecipe2(
    "carpet_plush", {
        Ingredient("cattenball", 1, "images/inventoryimages/cattenball.xml"),
        Ingredient("beefalowool", 1),
        Ingredient("beardhair", 1)
    }, TECH.NONE, {
        placer = "carpet_plush_placer", min_spacing = 0,
        atlas = "images/inventoryimages/carpet_plush.xml", image = "carpet_plush.tex",
        testfn = PlacerTest_carpet
    }, { "DECOR" }
)
AddRecipe2(
    "carpet_plush_big", {
        Ingredient("cattenball", 2, "images/inventoryimages/cattenball.xml"),
        Ingredient("beefalowool", 4),
        Ingredient("beardhair", 2)
    }, TECH.SCIENCE_ONE, {
        placer = "carpet_plush_big_placer", min_spacing = 0,
        atlas = "images/inventoryimages/carpet_plush_big.xml", image = "carpet_plush_big.tex",
        testfn = PlacerTest_carpet2
    }, { "DECOR" }
)

------

AddRecipe2(
    "shield_l_sand", {
        Ingredient("townportaltalisman", 6),
        Ingredient("shield_l_log", 1, "images/inventoryimages/shield_l_log.xml"),
        Ingredient("turf_desertdirt", 3),
    }, TECH.LOST, {
        atlas = "images/inventoryimages/shield_l_sand.xml", image = "shield_l_sand.tex"
    }, { "WEAPONS", "ARMOUR" }
)
AddRecipe2(
    "guitar_whitewood", {
        Ingredient("shyerrylog", 1, "images/inventoryimages/shyerrylog.xml"),
        Ingredient("steelwool", 1),
    }, TECH.SCIENCE_ONE, {
        atlas = "images/inventoryimages/guitar_whitewood.xml", image = "guitar_whitewood.tex"
    }, { "GARDENING", "TOOLS" }
)
AddRecipe2(
    "mat_whitewood_item", {
        Ingredient("shyerrylog", 1, "images/inventoryimages/shyerrylog.xml"),
    }, TECH.NONE, {
        numtogive = 6,
        atlas = "images/inventoryimages/mat_whitewood_item.xml", image = "mat_whitewood_item.tex"
    }, { "DECOR" }
)

if CONFIGS_LEGION.DRESSUP then
    AddRecipe2(
        "pinkstaff", {
            Ingredient("glommerwings", 1),
            Ingredient("livinglog", 1),
            Ingredient("glommerfuel", 1),
        }, TECH.MAGIC_TWO, {
            atlas = "images/inventoryimages/pinkstaff.xml", image = "pinkstaff.tex"
        }, { "MAGIC", "DECOR" }
    )
    AddRecipe2(
        "theemperorscrown", {
            Ingredient("nightmarefuel", 1),
            Ingredient("rocks", 1),
        }, TECH.NONE, {
            atlas = "images/inventoryimages/theemperorscrown.xml", image = "theemperorscrown.tex"
        }, { "CLOTHING", "DECOR" }
    )
    AddRecipe2(
        "theemperorsmantle", {
            Ingredient("nightmarefuel", 1),
            Ingredient("cutgrass", 1),
        }, TECH.NONE, {
            atlas = "images/inventoryimages/theemperorsmantle.xml", image = "theemperorsmantle.tex"
        }, { "CLOTHING", "DECOR" }
    )
    AddRecipe2(
        "theemperorsscepter", {
            Ingredient("nightmarefuel", 1),
            Ingredient("twigs", 1),
        }, TECH.NONE, {
            atlas = "images/inventoryimages/theemperorsscepter.xml", image = "theemperorsscepter.tex"
        }, { "CLOTHING", "DECOR" }
    )
    AddRecipe2(
        "theemperorspendant", {
            Ingredient("nightmarefuel", 1),
            Ingredient("flint", 1),
        }, TECH.NONE, {
            atlas = "images/inventoryimages/theemperorspendant.xml", image = "theemperorspendant.tex"
        }, { "CLOTHING", "DECOR" }
    )
end

--------------------------------------------------------------------------
--[[ 让地毯类建筑能摆更远 ]]
--------------------------------------------------------------------------

local build_dist_old = ACTIONS.BUILD.extra_arrive_dist
ACTIONS.BUILD.extra_arrive_dist = function(doer, dest, bufferedaction)
    if bufferedaction and bufferedaction.recipe then
        if
            string.len(bufferedaction.recipe) > 7 and
            string.sub(bufferedaction.recipe, 1, 7) == "carpet_"
        then
            return 4
        end
    end
    return build_dist_old and build_dist_old(doer, dest, bufferedaction) or 0
end

--------------------------------------------------------------------------
--[[ 玩具彩蛋生成 ]]
--------------------------------------------------------------------------

-- if IsServer then
--     local function OnEntityWake_toywe(inst, toyprefab, physicsradius)
--         if inst.lasttoytime == nil then
--             inst.lasttoytime = -9590 --这样初始化是为了服务器重启时能初次判断一次。GetTime()是获取服务器已开启时间
--         end

--         if TheWorld.state.issummer and GetTime() - inst.lasttoytime >= 9600 then --每20天的夏季
--             local thetoy = FindEntity(
--                 inst,
--                 8,
--                 function(item)
--                     return item:IsValid() and item.entity:IsVisible() and item.prefab == toyprefab
--                 end,
--                 { "cattoy" },
--                 { "NOCLICK", "FX", "INLIMBO" },
--                 nil
--             )

--             if thetoy == nil then
--                 if inst.task_toywe ~= nil then
--                     inst.task_toywe:Cancel()
--                 end

--                 inst.task_toywe = inst:DoTaskInTime(5 + 55 * math.random(), function()
--                     local x, y, z = inst.Transform:GetWorldPosition()
--                     local rad = math.random(physicsradius, physicsradius + 3)
--                     local angle = math.random() * 2 * PI
--                     SpawnPrefab(toyprefab).Transform:SetPosition(x + rad * math.cos(angle), y, z - rad * math.sin(angle))

--                     inst.lasttoytime = GetTime()
--                     inst.task_toywe = nil
--                 end)
--             end
--         end
--     end

--     local hermithouse_needchange =
--     {
--         "hermithouse",
--         "hermithouse_construction1",
--         "hermithouse_construction2",
--         "hermithouse_construction3",
--     }
--     for k,v in pairs(hermithouse_needchange) do
--         AddPrefabPostInit(v, function(inst)
--             local OnEntityWake_old = inst.OnEntityWake
--             inst.OnEntityWake = function(myself)
--                 if OnEntityWake_old ~= nil then
--                     OnEntityWake_old(myself)
--                 end
--                 OnEntityWake_toywe(inst, "toy_spongebob", 2)
--             end
--         end)
--     end

--     AddPrefabPostInit("oasislake", function(inst)
--         local OnEntityWake_old = inst.OnEntityWake
--         inst.OnEntityWake = function(myself)
--             if OnEntityWake_old ~= nil then
--                 OnEntityWake_old(myself)
--             end
--             OnEntityWake_toywe(inst, "toy_patrickstar", 6.5)
--         end
--     end)
-- end
