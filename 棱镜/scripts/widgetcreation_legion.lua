local _G = GLOBAL
local containers = require("containers")

--------------------------------------------------------------------------
--[[ 容器数据设定 ]]
--------------------------------------------------------------------------

local showmeneed = {
    "backcub", "beefalo", "giantsfoot",
    "hiddenmoonlight", "revolvedmoonlight", "revolvedmoonlight_pro",
    "boltwingout", "plant_nepenthes_l"
}
local params = {}

local function TestContainer_base(container, item, slot)
    return not (item:HasTag("irreplaceable") or item:HasTag("nobundling"))
        and (
            item:HasTag("unwrappable") or not (
                item:HasTag("_container") or item:HasTag("bundle")
            )
        )
end

------
--靠背熊
------

local function MakeBackcub(name, animbuild)
    params[name] = {
        widget = {
            slotpos = {},
            animbank = "ui_piggyback_2x6",
            animbuild = animbuild,
            pos = Vector3(-5, -50, 0)
        },
        issidewidget = true,
        type = "pack",
        openlimit = 1
    }
    for y = 0, 5 do
        table.insert(params[name].widget.slotpos, Vector3(-162, -75 * y + 170, 0))
        table.insert(params[name].widget.slotpos, Vector3(-162 + 75, -75 * y + 170, 0))
    end
end
MakeBackcub("backcub", "ui_piggyback_2x6")
MakeBackcub("backcub_fans2", "ui_backcub_fans2_2x6")

------
--驮运鞍具
------

params.beefalo = {
    widget =
    {
        slotpos = {},
        animbank = "ui_chester_shadow_3x4",
        animbuild = "ui_chester_shadow_3x4",
        pos = Vector3(0, 220, 0),
        side_align_tip = 160,
    },
    type = "chest",
    openlimit = 1,
}
for y = 2.5, -0.5, -1 do
    for x = 0, 2 do
        table.insert(params.beefalo.widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
    end
end

params.beefalo.itemtestfn = TestContainer_base

------
--巨人之脚
------

params.giantsfoot = {
    widget =
    {
        slotpos = {},
        animbank = "ui_backpack_2x4",
        animbuild = "ui_backpack_2x4",
        pos = Vector3(-5, -70, 0),
    },
    issidewidget = true,
    type = "pack",
    openlimit = 1,
    priorityfn = function(container, item, slot)
        return item.prefab == "cane" or item.prefab == "ruins_bat" or item:HasTag("weapon")
    end
}
for y = 0, 3 do
    table.insert(params.giantsfoot.widget.slotpos, Vector3(-162, -75 * y + 114, 0))
    table.insert(params.giantsfoot.widget.slotpos, Vector3(-162 + 75, -75 * y + 114, 0))
end

------
--月藏宝匣
------

params.hiddenmoonlight = {
    widget = {
        slotpos = {},
        animbank = "ui_chest_3x3",
        animbuild = "ui_hiddenmoonlight_4x4",
        pos = Vector3(0, 200, 0),
        side_align_tip = 160,
    },
    type = "chest",
}
for y = 3, 0, -1 do
    for x = 0, 3 do
        table.insert(params.hiddenmoonlight.widget.slotpos, Vector3(80 * (x - 2) + 40, 80 * (y - 2) + 40, 0))
    end
end

local cooking = require("cooking")
function params.hiddenmoonlight.itemtestfn(container, item, slot)
    if item:HasTag("icebox_valid") then
        return true
    end

    if cooking.IsCookingIngredient(item.prefab) then --只要是烹饪食材，就能放入
        return true
    end

    if item:HasTag("smallcreature") then
        return true
    end
    if not (item:HasTag("fresh") or item:HasTag("stale") or item:HasTag("spoiled")) then
        return false
    end
    for k, v in pairs(FOODTYPE) do
        if item:HasTag("edible_"..v) then
            return true
        end
    end

    return false
end

------
--月轮宝盘
------

params.revolvedmoonlight = {
    widget = {
        slotpos = {},
        animbank = "ui_chest_3x3",
        animbuild = "ui_revolvedmoonlight_4x3",
        pos = Vector3(0, -150, 0),
        side_align_tip = 160,
    },
    type = "chest_l",
    lowpriorityselection = true
}
for y = 2, 1, -1 do
    for x = 0, 2 do
        table.insert(params.revolvedmoonlight.widget.slotpos, Vector3(80*x - 80*2 + 72, 80*y - 80*2 + 47, 0))
    end
end
params.revolvedmoonlight.itemtestfn = TestContainer_base

params.revolvedmoonlight_pro = {
    widget = {
        slotpos = {},
        animbank = "ui_chest_3x3",
        animbuild = "ui_revolvedmoonlight_4x3",
        pos = Vector3(0, -150, 0),
        side_align_tip = 160,
    },
    type = "chest_l",
    lowpriorityselection = true
}
for y = 0, 2 do --                                                    x轴基础               y轴基础
    table.insert(params.revolvedmoonlight_pro.widget.slotpos, Vector3(-122      , (-77*y) + 80 - (y*2), 0))
    table.insert(params.revolvedmoonlight_pro.widget.slotpos, Vector3(-122 + 75 , (-77*y) + 80 - (y*2), 0))
    table.insert(params.revolvedmoonlight_pro.widget.slotpos, Vector3(-122 + 150, (-77*y) + 80 - (y*2), 0))
    table.insert(params.revolvedmoonlight_pro.widget.slotpos, Vector3(-122 + 225, (-77*y) + 80 - (y*2), 0))
end
params.revolvedmoonlight_pro.itemtestfn = TestContainer_base

--月轮宝盘皮肤
local function MakeSkin_revolvedmoonlight(data)
    local name = "revolvedmoonlight_"..data.skin
    local animbuild = "ui_"..name.."_4x3"
    params[name] = {
        widget = {
            slotpos = {},
            animbank = "ui_chest_3x3",
            animbuild = animbuild,
            pos = Vector3(0, -150, 0),
            side_align_tip = 160
        },
        type = "chest_l",
        lowpriorityselection = true
    }
    for y = 2, 1, -1 do
        for x = 0, 2 do
            table.insert(params[name].widget.slotpos, Vector3(80*x - 80*2 + 72, 80*y - 80*2 + 47, 0))
        end
    end
    params[name].itemtestfn = TestContainer_base
    table.insert(showmeneed, name)

    name = "revolvedmoonlight_pro_"..data.skin
    params[name] = {
        widget = {
            slotpos = {},
            animbank = "ui_chest_3x3",
            animbuild = animbuild,
            pos = Vector3(0, -150, 0),
            side_align_tip = 160
        },
        type = "chest_l",
        lowpriorityselection = true
    }
    for y = 0, 2 do --                                    x轴基础               y轴基础
        table.insert(params[name].widget.slotpos, Vector3(-122      , (-77*y) + 80 - (y*2), 0))
        table.insert(params[name].widget.slotpos, Vector3(-122 + 75 , (-77*y) + 80 - (y*2), 0))
        table.insert(params[name].widget.slotpos, Vector3(-122 + 150, (-77*y) + 80 - (y*2), 0))
        table.insert(params[name].widget.slotpos, Vector3(-122 + 225, (-77*y) + 80 - (y*2), 0))
    end
    params[name].itemtestfn = TestContainer_base
    table.insert(showmeneed, name)
end
MakeSkin_revolvedmoonlight({ skin = "taste" })
MakeSkin_revolvedmoonlight({ skin = "taste2" })
MakeSkin_revolvedmoonlight({ skin = "taste3" })
MakeSkin_revolvedmoonlight({ skin = "taste4" })

------
--脱壳之翅
------

params.boltwingout = {
    widget = {
        slotpos = {},
        animbank = "ui_piggyback_2x6",
        animbuild = "ui_piggyback_2x6",
        pos = Vector3(-5, -50, 0)
    },
    issidewidget = true,
    type = "pack",
    openlimit = 1,
    priorityfn = function(container, item, slot)
        local costs = {
            stinger = 3,            --蜂刺
            honey = 5,              --蜂蜜
            royal_jelly = 0.1,      --蜂王浆
            honeycomb = 0.25,       --蜂巢
            beeswax = 0.2,          --蜂蜡
            bee = 0.5,              --蜜蜂
            killerbee = 0.45,       --杀人蜂

            mosquitosack = 1,       --蚊子血袋
            mosquito = 0.45,        --蚊子

            glommerwings = 0.25,    --格罗姆翅膀
            glommerfuel = 0.5,      --格罗姆黏液

            butterflywings = 3,     --蝴蝶翅膀
            butter = 0.1,           --黄油
            butterfly = 0.6,        --蝴蝶

            wormlight = 0.25,       --神秘浆果
            wormlight_lesser = 1,   --神秘小浆果

            moonbutterflywings = 1, --月蛾翅膀
            moonbutterfly = 0.3,    --月蛾

            ahandfulofwings = 0.25, --虫翅碎片
            insectshell_l = 0.25,   --虫甲碎片
            raindonate = 0.45,      --雨蝇
            fireflies = 0.45,       --萤火虫

            dragon_scales = 0.1,    --龙鳞
            lavae_egg = 0.06,       --岩浆虫卵
            lavae_egg_cracked = 0.06,--岩浆虫卵(孵化中)
            lavae_cocoon = 0.03,    --冷冻虫卵
        }
        return costs[item.prefab] ~= nil or item:HasTag("yes_boltout")
    end
}
for y = 0, 5 do
    table.insert(params.boltwingout.widget.slotpos, Vector3(-162, -75 * y + 170, 0))
    table.insert(params.boltwingout.widget.slotpos, Vector3(-162 + 75, -75 * y + 170, 0))
end

------
--打窝饵制作器
------

params.fishhomingtool = {
    widget = {
        slotpos = {
            Vector3(-37.5, 32 + 4, 0),
            Vector3(37.5, 32 + 4, 0),
            Vector3(-37.5, -(32 + 4), 0),
            Vector3(37.5, -(32 + 4), 0),
        },
        animbank = "ui_bundle_2x2",
        animbuild = "ui_bundle_2x2",
        pos = Vector3(200, 0, 0),
        side_align_tip = 120,
        buttoninfo = {
            text = STRINGS.ACTIONS_LEGION.MAKE,
            position = Vector3(0, -100, 0)
        }
    },
    type = "cooker"
}
function params.fishhomingtool.itemtestfn(container, item, slot)
    if
        FISHHOMING_INGREDIENTS_L[item.prefab] ~= nil or
        item:HasTag("edible_MEAT") or item:HasTag("edible_VEGGIE") or item:HasTag("edible_MONSTER") or
        item:HasTag("edible_SEEDS") or item:HasTag("winter_ornament")
    then
        return true
    end
    return false
end
function params.fishhomingtool.widget.buttoninfo.fn(inst, doer)
    if inst.components.container ~= nil then
        BufferedAction(doer, inst, ACTIONS.WRAPBUNDLE):Do()
    elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
        SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.WRAPBUNDLE.code, inst, ACTIONS.WRAPBUNDLE.mod_name)
    end
end
function params.fishhomingtool.widget.buttoninfo.validfn(inst)
    return inst.replica.container ~= nil and not inst.replica.container:IsEmpty()
end

------
--胡萝卜长枪
------

local function IsCarrot(container, item, slot)
    return item.prefab == "carrot" or item.prefab == "carrot_cooked"
end

params.lance_carrot_l = {
    widget = {
        slotpos = {
            Vector3(0,   32 + 4,  0),
            Vector3(0, -(32 + 4), 0)
        },
        animbank = "ui_cookpot_1x2",
        animbuild = "ui_cookpot_1x2",
        pos = Vector3(0, 60, 0)
    },
    type = "hand_inv",
    excludefromcrafting = true,
    priorityfn = IsCarrot
}
function params.lance_carrot_l.itemtestfn(container, item, slot)
    return IsCarrot(container, item, slot) or item.prefab == "spoiled_food"
end

------
--巨食草
------

params.plant_nepenthes_l = {
    widget = {
        slotpos = {},
        slotbg = {},
        animbank = "ui_chest_3x3",
        animbuild = "ui_nepenthes_l_4x4",
        pos = Vector3(0, 200, 0),
        side_align_tip = 160,
    },
    type = "chest"
}
for y = 3, 0, -1 do
    for x = 0, 3 do
        table.insert(params.plant_nepenthes_l.widget.slotpos, Vector3(80 * (x - 2) + 40, 80 * (y - 2) + 40, 0))
        table.insert(params.plant_nepenthes_l.widget.slotbg, { image = "slot_juice_l.tex", atlas = "images/slot_juice_l.xml" })
    end
end
function params.plant_nepenthes_l.itemtestfn(container, item, slot)
    if item.prefab == "fruitflyfruit" then
        return not item:HasTag("fruitflyfruit") --没有 fruitflyfruit 就代表是枯萎了
    elseif item.prefab == "glommerflower" then
		return not item:HasTag("glommerflower") --没有 glommerflower 就代表是枯萎了
    end
    return not (item:HasTag("irreplaceable") or item:HasTag("nobundling") or item:HasTag("nodigest_l"))
end

--------------------------------------------------------------------------
--[[ 修改容器注册函数 ]]
--------------------------------------------------------------------------

for k, v in pairs(params) do
    containers.params[k] = v

    --更新容器格子数量的最大值
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end
params = nil

--加入mod的容器（已经过时了，不要用这里的逻辑）
-- local widgetsetup_old = containers.widgetsetup
-- function containers.widgetsetup(container, prefab, data)
--     local t = params[prefab or container.inst.prefab]
--     if t ~= nil then   --是mod里用到的格子就注册，否则就返回官方的格子注册函数
--         for k, v in pairs(t) do
--             container[k] = v
--         end
--         container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
--     else
--         return widgetsetup_old(container, prefab, data)
--     end
-- end

--------------------------------------------------------------------------
--mod兼容：Show Me (中文)
--------------------------------------------------------------------------

------以下代码参考自风铃草大佬的穹妹------
--showme优先级如果比本mod高，那么这部分代码会生效
for k, mod in pairs(ModManager.mods) do
    if mod and _G.rawget(mod, "SHOWME_STRINGS") then --showme特有的全局变量
        if
            mod.postinitfns and mod.postinitfns.PrefabPostInit and
            mod.postinitfns.PrefabPostInit.treasurechest
        then
            for _,v in ipairs(showmeneed) do
				mod.postinitfns.PrefabPostInit[v] = mod.postinitfns.PrefabPostInit.treasurechest
			end
        end
        break --及时跳出来循环？
    end
end

--showme优先级如果比本mod低，那么这部分代码会生效
TUNING.MONITOR_CHESTS = TUNING.MONITOR_CHESTS or {}
for _, v in ipairs(showmeneed) do
	TUNING.MONITOR_CHESTS[v] = true
end
