local prefabFiles = {
    "raindonate",               --雨蝇
    "monstrain",                --雨竹
    "book_weather",             --气象之书
    "hat_mermbreathing",        --鱼之息
    "merm_scales",              --鱼鳞
    "giantsfoot",               --巨脚背包
    "refractedmoonlight",       --月折宝剑
    "moonlight_legion",         --月之宝器
    "moon_dungeon",             --月的地下城
}

for k,v in pairs(prefabFiles) do
    table.insert(PrefabFiles, v)
end

-----

local assets = {
    Asset("ANIM", "anim/ui_hiddenmoonlight_4x4.zip"),
    Asset("ANIM", "anim/ui_revolvedmoonlight_4x3.zip"),

    Asset("ATLAS", "images/inventoryimages/squamousfruit.xml"), --预加载，给科技栏用的
    Asset("IMAGE", "images/inventoryimages/squamousfruit.tex"),
    Asset("ATLAS", "images/inventoryimages/raindonate.xml"),
    Asset("IMAGE", "images/inventoryimages/raindonate.tex"),
    Asset("ATLAS", "images/inventoryimages/book_weather.xml"),
    Asset("IMAGE", "images/inventoryimages/book_weather.tex"),
    Asset("ATLAS", "images/inventoryimages/merm_scales.xml"),
    Asset("IMAGE", "images/inventoryimages/merm_scales.tex"),
    Asset("ATLAS", "images/inventoryimages/hat_mermbreathing.xml"),
    Asset("IMAGE", "images/inventoryimages/hat_mermbreathing.tex"),
    Asset("ATLAS", "images/inventoryimages/giantsfoot.xml"),
    Asset("IMAGE", "images/inventoryimages/giantsfoot.tex"),
    Asset("ATLAS", "images/inventoryimages/hiddenmoonlight_item.xml"),
    Asset("IMAGE", "images/inventoryimages/hiddenmoonlight_item.tex"),
    Asset("ATLAS", "images/inventoryimages/revolvedmoonlight_item.xml"),
    Asset("IMAGE", "images/inventoryimages/revolvedmoonlight_item.tex"),
}

for k,v in pairs(assets) do
    table.insert(Assets, v)
end

-----

local _G = GLOBAL

--------------------------------------------------------------------------
--[[ 基础 ]]
--------------------------------------------------------------------------

_G.RegistMiniMapImage_legion("monstrain")
_G.RegistMiniMapImage_legion("agronssword")
_G.RegistMiniMapImage_legion("giantsfoot")
_G.RegistMiniMapImage_legion("refractedmoonlight")
_G.RegistMiniMapImage_legion("moondungeon")
_G.RegistMiniMapImage_legion("hiddenmoonlight")

if _G.CONFIGS_LEGION.BOOKRECIPETABS == "magic" then
    AddRecipe2(
        "book_weather", {
            Ingredient("papyrus", 4),
            Ingredient("squamousfruit", 3, "images/inventoryimages/squamousfruit.xml"),
            Ingredient("raindonate", 3, "images/inventoryimages/raindonate.xml"),
        }, TECH.MAGIC_THREE, {
            atlas = "images/inventoryimages/book_weather.xml", image = "book_weather.tex"
        }, { "MAGIC", "WEAPONS", "RAIN" }
    )
else
    AddRecipe2(
        "book_weather", {
            Ingredient("book_rain", 1),
            Ingredient("squamousfruit", 2, "images/inventoryimages/squamousfruit.xml"),
            Ingredient("raindonate", 2, "images/inventoryimages/raindonate.xml"),
        }, TECH.MAGIC_THREE, {
            builder_tag = "bookbuilder",
            atlas = "images/inventoryimages/book_weather.xml", image = "book_weather.tex"
        }, { "MAGIC", "WEAPONS", "RAIN", "CHARACTER" }
    )
end

AddRecipe2(
    "hat_mermbreathing", {
        Ingredient("merm_scales", 3, "images/inventoryimages/merm_scales.xml"),
    }, TECH.SCIENCE_TWO, {
        atlas = "images/inventoryimages/hat_mermbreathing.xml", image = "hat_mermbreathing.tex"
    }, { "CLOTHING" }
)
AddRecipe2(
    "giantsfoot", {
        Ingredient("merm_scales", 3, "images/inventoryimages/merm_scales.xml"),
        Ingredient("pigskin", 3),
        Ingredient("manrabbit_tail", 3),
    }, TECH.SCIENCE_TWO, {
        atlas = "images/inventoryimages/giantsfoot.xml", image = "giantsfoot.tex"
    }, { "CLOTHING", "CONTAINERS" }
)
AddRecipe2(
    "hiddenmoonlight_item", {
        Ingredient("bluemooneye", 2),
        Ingredient("turf_shellbeach", 2),
    }, TECH.LOST, {
        atlas = "images/inventoryimages/hiddenmoonlight_item.xml", image = "hiddenmoonlight_item.tex"
    }, { "STRUCTURES", "CONTAINERS", "COOKING" }
)
AddRecipe2(
    "revolvedmoonlight_item", {
        Ingredient("yellowmooneye", 2),
        Ingredient("turf_meteor", 2),
    }, TECH.LOST, {
        atlas = "images/inventoryimages/revolvedmoonlight_item.xml", image = "revolvedmoonlight_item.tex"
    }, { "LIGHT", "CONTAINERS" }
)

--------------------------------------------------------------------------
--[[ 修改鱼人，使其可以掉落鱼鳞 ]]
--------------------------------------------------------------------------

AddPrefabPostInit("merm", function(inst)
    if TheWorld.ismastersim then
        inst.components.lootdropper:AddChanceLoot("merm_scales", 0.10)
    end
end)

--------------------------------------------------------------------------
--[[ 修改人物SG，行走与战斗时，需要切换道具时自动切换 ]]
--------------------------------------------------------------------------

local function EquipSpeedItem(inst)
    local backpack = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BACK or EQUIPSLOTS.BODY) or nil

    if backpack ~= nil and backpack.components.container ~= nil then
        local item1 = backpack.components.container:FindItem(function(item)
            return item.components.equippable ~= nil and item.components.equippable.walkspeedmult ~= nil and item.components.equippable.walkspeedmult > 1
        end)

        if item1 ~= nil then
            inst.components.inventory:Equip(item1)
        end
    end
end

local function EquipFightItem(inst)
    local backpack = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BACK or EQUIPSLOTS.BODY) or nil

    if backpack ~= nil and backpack.components.container ~= nil then
        local item1 = backpack.components.container:FindItem(function(item)
            if item.components.weapon ~= nil and not item:HasTag("projectile") then
                local dmg = item.components.weapon:GetDamage(inst, nil) or 0
                if dmg > 17 or dmg <= 0 then
                    return true
                end
            end
            return false
        end)

        if item1 ~= nil then
            inst.components.inventory:Equip(item1)
        end
    end
end

-- local SGWilson = require "stategraphs/SGwilson" --会使这个文件不再加载，后面新增的动作sg绑定也不会再更新到这里了
-- package.loaded["stategraphs/SGwilson"] = nil --恢复这个文件的加载状态，以便后面的更新

AddStategraphPostInit("wilson", function(sg)
    for k, v in pairs(sg.actionhandlers) do
        if v["action"]["id"] == "ATTACK" then
            local SGWilson_atk_handler_fn = v.deststate

            v.deststate = function(inst, action)
                if inst.needcombat then
                    inst.sg.mem.localchainattack = not action.forced or nil
                    if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or inst.components.health:IsDead()) then
                        EquipFightItem(inst)    --攻击之前先换攻击装备
                    end
                end
                return SGWilson_atk_handler_fn(inst, action)
            end

            break
        end
    end

    for k, v in pairs(sg.events) do
        if v["name"] == "locomote" then
            local SGWilson_loco_event_fn = v.fn

            v.fn = function(inst, data)
                if inst.needrun then
                    if inst.sg:HasStateTag("busy") then
                        return
                    end
                    local is_moving = inst.sg:HasStateTag("moving")
                    local should_move = inst.components.locomotor:WantsToMoveForward()

                    if not (inst.sg:HasStateTag("bedroll") or inst.sg:HasStateTag("tent") or inst.sg:HasStateTag("waking"))
                        and not (is_moving and not should_move) 
                        and (not is_moving and should_move) then
                        EquipSpeedItem(inst)    --行走之前先换加速装备
                    end
                end
                return SGWilson_loco_event_fn(inst, data)
            end

            break
        end
    end
end)

-- AddStategraphEvent("wilson", EventHandler("locomote",
--     function(inst, data)
--         if inst.sg:HasStateTag("busy") then
--             return
--         end
--         local is_moving = inst.sg:HasStateTag("moving")
--         local should_move = inst.components.locomotor:WantsToMoveForward()

--         if not (inst.sg:HasStateTag("bedroll") or inst.sg:HasStateTag("tent") or inst.sg:HasStateTag("waking")) 
--             and not (is_moving and not should_move) 
--             and (not is_moving and should_move) then
--             EquipSpeedItem(inst)    --行走之前先换加速装备
--         end

--         return SGWilson_loco_event_fn(inst, data)
--     end)
-- )

-- AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.ATTACK,
--     function(inst, action)
--         inst.sg.mem.localchainattack = not action.forced or nil
--         if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or inst.components.health:IsDead()) then
--             EquipFightItem(inst)    --攻击之前先换攻击装备
--             return SGWilson_atk_handler_fn(inst, action)
--         end
--     end)
-- )

-- AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.ATTACK,
--     function(inst, action)
--         if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or inst.replica.health:IsDead()) then
--             local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
--             if equip == nil then
--                 return "attack"
--             end
--             local inventoryitem = equip.replica.inventoryitem
--             return (not (inventoryitem ~= nil and inventoryitem:IsWeapon()) and "attack")
--                 or (equip:HasTag("blowdart") and "blowdart")
--                 or (equip:HasTag("thrown") and "throw")
--                 or (equip:HasTag("propweapon") and "attack_prop_pre")
--                 or "attack"
--         end
--     end)
-- )
