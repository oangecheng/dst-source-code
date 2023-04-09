---
--- @author zsh in 2023/2/16 17:28
---

---
--- @author zsh in 2023/2/14 16:25
---
local L = (locale == "zh" or locale == "zht" or locale == "zhr") and true or false;

local __name = L and "便携大箱子" or "Large portable case";
local __author = "心悦卿兮";
local __version = "1.0.4.2";

local fns = {};

function fns.description(folder_name, author, version, start_time, content)
    content = content or "";
    return (L and "                                                  感谢你的订阅！\n"
            .. content .. "\n"
            .. "                                                【模组】：" .. folder_name .. "\n"
            .. "                                                【作者】：" .. author .. "\n"
            .. "                                                【版本】：" .. version .. "\n"
            .. "                                                【时间】：" .. start_time .. "\n"
            or "                                                Thanks for subscribing!\n"
            .. content .. "\n"
            .. "                                                【mod    】：" .. folder_name .. "\n"
            .. "                                                【author 】：" .. author .. "\n"
            .. "                                                【version】：" .. version .. "\n"
            .. "                                                【release】：" .. start_time .. "\n"
    );
end

local start_time = "2023-01-11";
local folder_name = folder_name or "";
local content = "";

name = __name;
author = __author;
version = __version;
description = fns.description(folder_name, author, version, start_time, content);

server_filter_tags = { "便携大箱子", "Large portable case" }

client_only_mod = false;
all_clients_require_mod = true;

icon = "modicon.tex";
icon_atlas = "modicon.xml";

forumthread = "";
api_version = 10;
priority = -2 ^ 63;

dont_starve_compatible = false;
reign_of_giants_compatible = false;
dst_compatible = true;

function fns.option(description, data, hover)
    return {
        description = description or "",
        data = data,
        hover = hover or ""
    };
end

local vars = {
    OPEN = L and "开启" or "Open";
    CLOSE = L and "关闭" or "Close";
};

function fns.largeLabel(label)
    return {
        name = "",
        label = label or "",
        hover = "",
        options = {
            fns.option("", 0)
        },
        default = 0
    }
end

function fns.general_option(name, label, hover)
    return {
        name = name;
        label = label or "";
        hover = hover or "";
        options = {
            fns.option(vars.OPEN, true),
            fns.option(vars.CLOSE, false),
        },
        default = false
    }
end

function fns.blank()
    return {
        name = "";
        label = "";
        hover = "";
        options = {
            fns.option("", 0)
        },
        default = 0
    }
end

configuration_options = {
--[[    {
        name = "capacity",
        label = L and "容量设置" or "Capacity setting",
        hover = L and "警告：万万不可和同类功能的模组一起开启！！！" or "Warning: Never open a module with similar functionality!!",
        options = {
            fns.option("120", true),
            fns.option("80", 80),
            fns.option("60", 60),
            fns.option("40", 40),
        },
        default = true
    },]]
    {
        name = "SET_PRESERVER_VALUE",
        label = L and "设置保鲜效果" or "Set fresh-keeping effect",
        hover = "",
        options = {
            fns.option(L and "关闭" or "Close", -1, ""),
            fns.option("0.5", 0.5, L and "冰箱的保鲜效果" or "The preservation effect of refrigerator"),
            fns.option("0.25", 0.25, L and "盐盒的保鲜效果" or "The preservation effect of salt box"),
            fns.option("0.1", 0.1, L and "冰箱保鲜效果的5倍" or "Five times as effective as a refrigerator"),
            fns.option("0", 0, L and "永久保鲜" or "Permanent preservation"),
            fns.option("-0.5", -0.5, L and "返鲜。参考：锡鱼罐返鲜效果为-0.333" or "Return fresh. Reference: Fresh return effect of tin fish can is -0.333"),
            fns.option("-4", -4, L and "返鲜。参考：锡鱼罐返鲜效果为-0.333" or "Return fresh. Reference: Fresh return effect of tin fish can is -0.333"),
            fns.option("-16", -16, L and "返鲜。参考：锡鱼罐返鲜效果为-0.333" or "Return fresh. Reference: Fresh return effect of tin fish can is -0.333"),
        },
        default = -1
    },
    {
        name = "container_removable",
        label = L and "容器 UI 可以移动" or "The container UI can be moved",
        hover = L and "警告：万万不可和同类功能的模组一起开启！！！" or "Warning: Never open a module with similar functionality!!",
        options = {
            fns.option(L and "开启" or "Open", true, ""),
            fns.option(L and "关闭" or "Close", false, ""),
        },
        default = false
    },
    {
        name = "smart_sign_draw",
        label = L and "兼容智能小木牌模组" or "Compatible with smart small wooden brand module",
        hover = "",
        options = {
            fns.option(L and "开启" or "Open", true, ""),
            fns.option(L and "关闭" or "Close", false, ""),
        },
        default = false
    },
    {
        name = "go_into_container",
        label = L and "关闭状态物品能直接进入" or "Closed state items can be entered directly",
        hover = "将便携大箱子放在你的物品栏，捡起物品时，如果容器内部有同类物品，会直接进入！\nPS:已知如果是不可堆叠的物品，进不去。我无法理解为什么会出现这个情况。",
        options = {
            fns.option(L and "开启" or "Open", true, ""),
            fns.option(L and "关闭" or "Close", false, ""),
        },
        default = true
    },
    {
        name = "direct_consumption",
        label = L and "不打开就能直接消耗内部材料制作物品" or "directly consuming the material inside to make items",
        hover = "检索物品栏全部便携大箱子，不需要打开就能消耗材料制作物品\nPS：该功能开启洞穴后无效，这是饥荒联机版的固有问题。如果一个人玩可以开独行长路模组。",
        options = {
            fns.option(L and "开启" or "Open", true,"严重警告：千万不要和同样功能的模组一起使用。"),
            fns.option(L and "关闭" or "Close", false,"严重警告：千万不要和同样功能的模组一起使用。"),
        },
        default = true
    },
}
