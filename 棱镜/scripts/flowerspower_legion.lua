local prefabFiles = {
    "bush_flowers",             --花的灌木丛
    "rosorns",                  --玫瑰刺
    "lileaves",                 --蹄莲叶
    "orchitwigs",               --兰花絮
    "neverfade",                --永不凋零
    "sachet",                   --香包
    "neverfade_butterfly",      --永不凋零的蝴蝶
}

if GLOBAL.CONFIGS_LEGION.FOLIAGEATHCHANCE > 0 then
    table.insert(PrefabFiles, "foliageath")  --青枝绿叶相关
end

for k,v in pairs(prefabFiles) do
    table.insert(PrefabFiles, v)
end

-----

local assets = {
    Asset("ATLAS", "images/inventoryimages/lileaves.xml"),
    Asset("IMAGE", "images/inventoryimages/lileaves.tex"),
    Asset("ATLAS", "images/inventoryimages/orchitwigs.xml"),
    Asset("IMAGE", "images/inventoryimages/orchitwigs.tex"),
    Asset("ATLAS", "images/inventoryimages/neverfade.xml"),
    Asset("IMAGE", "images/inventoryimages/neverfade.tex"),
    Asset("ATLAS", "images/inventoryimages/sachet.xml"), --预加载，给科技栏用的
    Asset("IMAGE", "images/inventoryimages/sachet.tex"),
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

_G.RegistMiniMapImage_legion("rosebush")
_G.RegistMiniMapImage_legion("lilybush")
_G.RegistMiniMapImage_legion("orchidbush")
_G.RegistMiniMapImage_legion("neverfadebush")

AddRecipe2(
    "neverfade", {
        Ingredient("rosorns", 1, "images/inventoryimages/rosorns.xml"),
        Ingredient("lileaves", 1, "images/inventoryimages/lileaves.xml"),
        Ingredient("orchitwigs", 1, "images/inventoryimages/orchitwigs.xml"),
    }, TECH.MAGIC_THREE, {
        atlas = "images/inventoryimages/neverfade.xml", image = "neverfade.tex"
    }, { "WEAPONS", "MAGIC" }
)

AddRecipe2(
    "sachet", {
        Ingredient("petals_rose", 3, "images/inventoryimages/petals_rose.xml"),
        Ingredient("petals_lily", 3, "images/inventoryimages/petals_lily.xml"),
        Ingredient("petals_orchid", 3, "images/inventoryimages/petals_orchid.xml"),
    }, TECH.NONE, {
        atlas = "images/inventoryimages/sachet.xml", image = "sachet.tex"
    }, { "CLOTHING" }
)

--------------------------------------------------------------------------
--[[ 给三种花丛增加自然再生方式，防止绝种 ]]
--------------------------------------------------------------------------

if IsServer then
    local function onisraining(inst, israining) --每次下雨时尝试生成花丛
        if israining then
            local hasBush = false
            local flower = nil
            local x, y, z = inst.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x, y, z, 8, nil, { "NOCLICK", "FX", "INLIMBO" }) --检测周围物体

            for i, ent in ipairs(ents) do
                if ent.prefab == inst.bushCreater.name then
                    hasBush = true
                    break
                elseif ent.prefab == "flower" or ent.prefab == "flower_evil" or ent.prefab == "flower_rose" then
                    flower = ent   --获取花的实体
                end
            end

            if not hasBush and flower ~= nil then --周围没有花丛+有花，有几率把花变成花丛
                if math.random() < inst.bushCreater.chance then
                    local pos = flower:GetPosition()
                    local flowerbush = SpawnPrefab(inst.bushCreater.name)

                    if flowerbush ~= nil then
                        flower:Remove()
                        flowerbush.Transform:SetPosition(pos:Get())
                        --flowerbush.components.pickable:OnTransplant() --这样生成的是枯萎状态的
                    end
                end
            end
        end
    end

    AddPrefabPostInit("stagehand", function(inst)    --通过api重写桌之手的功能
        inst.bushCreater =
        {
            name = "rosebush",
            chance = 0.1,
        }

        inst:WatchWorldState("israining", onisraining)  --监听天气状态，刚下雨时、雨停时都会触发函数，就是说总共会触发两次
        onisraining(inst, TheWorld.state.israining)  --只有这两个参数，不能多加，多加没用
    end)

    AddPrefabPostInit("gravestone", function(inst)    --通过api重写墓碑的功能
        inst.bushCreater =
        {
            name = "orchidbush",
            chance = 0.01,
        }

        inst:WatchWorldState("israining", onisraining)
        onisraining(inst, TheWorld.state.israining)
    end)

    AddPrefabPostInit("pond", function(inst)    --通过api重写青蛙池塘的功能
        inst.bushCreater =
        {
            name = "lilybush",
            chance = 0.03,
        }

        inst:WatchWorldState("israining", onisraining)
        onisraining(inst, TheWorld.state.israining)
    end)
end

--------------------------------------------------------------------------
--[[ 青枝绿叶的修改 ]]
--------------------------------------------------------------------------

--------出鞘action
local PULLOUTSWORD = Action({ priority = 2, mount_valid = true })
PULLOUTSWORD.id = "PULLOUTSWORD"
PULLOUTSWORD.str = STRINGS.ACTIONS_LEGION.PULLOUTSWORD
PULLOUTSWORD.fn = function(act)
    local obj = act.target or act.invobject

    if obj ~= nil and obj.components.swordscabbard ~= nil and act.doer ~= nil then
        obj.components.swordscabbard:BreakUp(act.doer)
        return true
    end
end
AddAction(PULLOUTSWORD)

--往具有某组件的物品添加动作的检测函数，如果满足条件，就向人物的动作可执行表中加入某个动作。right表示是否是右键动作
AddComponentAction("INVENTORY", "swordscabbard", function(inst, doer, actions, right)
    table.insert(actions, ACTIONS.PULLOUTSWORD)
end)
AddComponentAction("SCENE", "swordscabbard", function(inst, doer, actions, right)
    if right then
        table.insert(actions, ACTIONS.PULLOUTSWORD)
    end
end)

--将一个动作与state绑定
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.PULLOUTSWORD, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.PULLOUTSWORD, "doshortaction"))

--------右键剑鞘直接尝试入鞘
local INTOSHEATH_L = Action({ priority = 2, mount_valid = true })
INTOSHEATH_L.id = "INTOSHEATH_L"
INTOSHEATH_L.str = STRINGS.ACTIONS.GIVE.SCABBARD
INTOSHEATH_L.fn = function(act)
    local obj = act.target or act.invobject
    if
        obj ~= nil and
        obj.components.emptyscabbard ~= nil and obj.components.trader ~= nil and
        act.doer.components.inventory ~= nil
    then
        local sword = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        local able, reason = obj.components.trader:AbleToAccept(sword, act.doer)
        if not able then
            return false, reason
        end

        obj.components.trader:AcceptGift(act.doer, sword)
        return true
    end
end
AddAction(INTOSHEATH_L)

AddComponentAction("INVENTORY", "emptyscabbard", function(inst, doer, actions, right)
    table.insert(actions, ACTIONS.INTOSHEATH_L)
end)
AddComponentAction("SCENE", "emptyscabbard", function(inst, doer, actions, right)
    if right then
        table.insert(actions, ACTIONS.INTOSHEATH_L)
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.INTOSHEATH_L, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.INTOSHEATH_L, "doshortaction"))

--------掉落物设定
if IsServer then
    if CONFIGS_LEGION.FOLIAGEATHCHANCE > 0 then
        --砍粗壮常青树有几率掉青枝绿叶
        local trees = {
            "evergreen_sparse",
            "evergreen_sparse_normal",
            "evergreen_sparse_tall",
            "evergreen_sparse_short"
        }
        local function FnSet_evergreen(inst)
            if inst.components.workable ~= nil then
                local onfinish_old = inst.components.workable.onfinish
                inst.components.workable:SetOnFinishCallback(function(inst, chopper)
                    if inst.components.lootdropper ~= nil then
                        if math.random() < CONFIGS_LEGION.FOLIAGEATHCHANCE then
                            inst.components.lootdropper:SpawnLootPrefab("foliageath")
                        end
                    end
                    if onfinish_old ~= nil then
                        onfinish_old(inst, chopper)
                    end
                end)
            end
        end
        for _,v in pairs(trees) do
            AddPrefabPostInit(v, FnSet_evergreen)
        end
        trees = nil

        --粗壮常青树的树精有几率掉青枝绿叶
        AddPrefabPostInit("leif_sparse", function(inst)
            inst:ListenForEvent("death", function(inst, data)
                if inst.components.lootdropper ~= nil then
                    if math.random() < 10*CONFIGS_LEGION.FOLIAGEATHCHANCE then
                        inst.components.lootdropper:SpawnLootPrefab("foliageath")
                    end
                end
            end)
        end)
    end
end
