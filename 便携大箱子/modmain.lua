---
--- @author zsh in 2023/1/11 3:27
---


GLOBAL.setmetatable(env, { __index = function(_, k)
    return GLOBAL.rawget(GLOBAL, k);
end });

local API = require("huge_box.API");

-- --[[ Show Me ]]
for _, mod in pairs(ModManager.mods) do
    if mod and mod.SHOWME_STRINGS then
        mod.postinitfns.PrefabPostInit._big_box = mod.postinitfns.PrefabPostInit.treasurechest
        mod.postinitfns.PrefabPostInit._big_box_chest = mod.postinitfns.PrefabPostInit.treasurechest
    end
end

TUNING.MONITOR_CHESTS = TUNING.MONITOR_CHESTS or {}
TUNING.MONITOR_CHESTS._big_box = true
TUNING.MONITOR_CHESTS._big_box_chest = true

PrefabFiles = {
    "huge_box"
}
Assets = {
    Asset("ANIM", "anim/big_box_ui_120.zip"),

    Asset("IMAGE", "images/DLC0002/inventoryimages.tex"),
    Asset("ATLAS", "images/DLC0002/inventoryimages.xml"),

    Asset("IMAGE", "images/inventoryitems/huge_box/open.tex"),
    Asset("ATLAS", "images/inventoryitems/huge_box/open.xml"),

    Asset("IMAGE", "images/inventoryitems/huge_box/close.tex"),
    Asset("ATLAS", "images/inventoryitems/huge_box/close.xml")
}

local minimap = {
    -- DLC0002
    "images/DLC0002/inventoryimages.xml"
}

for _, v in ipairs(minimap) do
    AddMinimapAtlas(v);
    table.insert(Assets, Asset("ATLAS", v));
end

TUNING.HUGE_BOX = {
    SET_PRESERVER_VALUE = env.GetModConfigData("SET_PRESERVER_VALUE");
    smart_sign_draw = env.GetModConfigData("smart_sign_draw");
};

local locale = LOC.GetLocaleCode();
local L = (locale == "zh" or locale == "zht" or locale == "zhr") and true or false;

-----------------------------------------------------------------------------------------
STRINGS.NAMES._BIG_BOX = L and "便携大箱子·建筑" or "Large portable case · Building";
STRINGS.CHARACTERS.GENERIC.DESCRIBE._BIG_BOX = "你家呢？哦，有我在你不需要家。";
STRINGS.RECIPE_DESC._BIG_BOX = L and "把家带在身上！" or "Take home with you!";

STRINGS.NAMES._BIG_BOX_CHEST = L and "便携大箱子" or "Large portable case";
STRINGS.CHARACTERS.GENERIC.DESCRIBE._BIG_BOX_CHEST = "你家呢？哦，有我在你不需要家。";
STRINGS.RECIPE_DESC._BIG_BOX_CHEST = L and "把家带在身上！" or "Take home with you!";

-----------------------------------------------------------------------------------------
local Recipes = {};

Recipes[#Recipes + 1] = {
    CanMake = true,
    name = "_big_box_chest",
    ingredients = {
        Ingredient("boards", 20), Ingredient("cutstone", 20), Ingredient("goldnugget", 20)
    },
    tech = TECH.NONE,
    config = {
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/DLC0002/inventoryimages.xml",
        image = "waterchest.tex"
    },
    filters = {
        "CONTAINERS"
    }
};

for _, v in pairs(Recipes) do
    if v.CanMake ~= false then
        env.AddRecipe2(v.name, v.ingredients, v.tech, v.config, v.filters);
    end
end

-----------------------------------------------------------------------------------------

local custom_actions = {
    ["HUGE_BOX_HAMMER"] = {
        execute = true,
        id = "HUGE_BOX_HAMMER",
        str = "徒手拆卸",
        fn = function(act)
            local target, doer = act.target, act.doer;
            if target and doer and target.onhammered then
                target.onhammered(target, doer);
                return true;
            end
        end,
        state = "domediumaction"
    }
}

local component_actions = {
    {
        actiontype = "SCENE",
        component = "huge_box_cmp",
        tests = {
            {
                execute = custom_actions["HUGE_BOX_HAMMER"].execute,
                id = "HUGE_BOX_HAMMER",
                testfn = function(inst, doer, actions, right)
                    return inst and inst:HasTag("huge_box") and right;
                end
            }
        }
    }
}

local old_actions = {}

API.addCustomActions(env, custom_actions, component_actions);
API.modifyOldActions(env, old_actions);

-----------------------------------------------------------------------------------------

if env.GetModConfigData("container_removable") then
    modimport("modmain/huge_box/AUXmods/container_removable.lua");
end

if env.GetModConfigData("go_into_container") then
    --env.AddComponentPostInit("inventory", function(self)
    --    local old_GiveItem = self.GiveItem;
    --    function self:GiveItem(inst, ...)
    --        if inst and (inst.components.inventoryitem == nil or not inst:IsValid()) then
    --            --print("Chang Warning: Can't give item because it's not an inventory item.")
    --            return
    --        end
    --        return old_GiveItem and old_GiveItem(self, inst, ...);
    --    end
    --end)
    -- 检索物品栏的全部处于关闭状态的便携大箱子
    local function onpickupitem2(inst, data)
        local item = data and data.item;
        if item == nil then
            return ;
        end

        local containers = {};
        for _, v in pairs(inst.components.inventory.itemslots) do
            if v and v.components.container then
                -- 限制成是关闭状态
                if not v.components.container:IsOpen() then
                    if v.prefab == "_big_box_chest" then
                        table.insert(containers, v);
                    end
                end
            end
        end
        for _, v in ipairs(containers) do
            local container = v.components.container;
            if container and container:Has(item.prefab, 1) then
                container:GiveItem(item); --, nil, item.GetPosition and item:GetPosition()); 没用
                break ;
            end
        end
    end
    env.AddPlayerPostInit(function(inst)
        if not TheWorld.ismastersim then
            return inst;
        end

        -- 只检索口袋里！
        inst:ListenForEvent("onpickupitem", onpickupitem2);
    end)
end

if env.GetModConfigData("direct_consumption") then
    -- 检索口袋里处于关闭状态的便携大箱子
    local function direct_consumption(self)
        local old_Has = self.Has;
        function self:Has(item, amount, checkallcontainers)
            local _, num_found = old_Has(self, item, amount, checkallcontainers);

            local containers = {};
            for _, v in pairs(self.itemslots) do
                if v and v.prefab == "_big_box_chest" then
                    if not v.components.container:IsOpen() then
                        table.insert(containers, v);
                    end
                end
            end
            for _, v in ipairs(containers) do
                local container = v.components.container;
                if container and not container.excludefromcrafting then
                    local iscrafting = checkallcontainers;
                    local container_enough, container_found = container:Has(item, amount, iscrafting)
                    num_found = num_found + container_found
                end
            end
            return num_found >= amount, num_found;
        end

        local old_GetCraftingIngredient = self.GetCraftingIngredient;
        function self:GetCraftingIngredient(item, amount)
            local crafting_items = old_GetCraftingIngredient(self, item, amount);

            local total_num_found = 0;
            local containers = {};
            for _, v in pairs(self.itemslots) do
                if v and v.prefab == "_big_box_chest" then
                    if not v.components.container:IsOpen() then
                        table.insert(containers, v);
                    end
                end
            end
            for _, container_inst in ipairs(containers) do
                local container = container_inst.components.container;
                if container and not container.excludefromcrafting then
                    for k, v in pairs(container:GetCraftingIngredient(item, amount - total_num_found, true)) do
                        crafting_items[k] = v
                        total_num_found = total_num_found + v
                    end
                end
                if total_num_found >= amount then
                    return crafting_items
                end
            end
            return crafting_items;
        end
    end
    env.AddComponentPostInit("inventory", direct_consumption);
end

