GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })


-- GLOBAL.XLog = function(msg, v1, v2, v3)
--     print("orangeLog:  " .. msg .. "  v1=" .. tostring(v1) .. "  v2=" .. tostring(v2) .. "  v3=" .. tostring(v3))
-- end


PrefabFiles = {
    "tt_spear"
}

Assets = {
}

STRINGS.NAMES.TT_SPEAR = "无敌大长矛"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TT_SPEAR = "无敌大长矛"
STRINGS.RECIPE_DESC.TT_SPEAR = "无敌大长矛"

STRINGS.SKIN_NAMES.tt_spear_flower = "闻风丧胆大长矛"
STRINGS.SKIN_NAMES.tt_spear_black = "牛逼的大长矛"

modimport("modmain/skin")

AddRecipe2("tt_spear", {}, TECH.NONE, {}, { "CHARACTER" })


-- GLOBAL["tt_spear_clear_fn"] = function (inst)
--     print("orangeLog clear spear func")
--     basic_clear_fn(inst, "tt_spear")
-- end


