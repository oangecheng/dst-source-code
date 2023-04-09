local _G = GLOBAL
local require = _G.require

--------------------------------------------------------------------------
--[[ 全局选项设置 ]]
--------------------------------------------------------------------------

-- 这个文件运行在modmain之前

--语言设置
local isChinese = GetModConfigData("Language") == "chinese"

--------------------------------------------------------------------------
--[[ 新地皮相关 ]]
--------------------------------------------------------------------------

-- modimport("scripts/new_tile_legion.lua")

--------------------------------------------------------------------------
--[[ 新地形相关 ]]
--------------------------------------------------------------------------

-- require("constants")
require("map/tasks")
local LAYOUTS = require("map/layouts").Layouts
local STATICLAYOUT = require("map/static_layout")

-------------------------------
--static_layouts、rooms相关，主要是引用mod地形、向目前世界加入mod地形
-------------------------------

------
--花香四溢
------

LAYOUTS["RoseGarden"] = STATICLAYOUT.Get("map/static_layouts/rosegarden")   --引用一种固定格式的地形
LAYOUTS["OrchidGrave"] = STATICLAYOUT.Get("map/static_layouts/orchidgrave"..(isChinese and "_zh" or ""))
LAYOUTS["LilyPond"] = STATICLAYOUT.Get("map/static_layouts/lilypond")
LAYOUTS["OrchidForest"] = STATICLAYOUT.Get("map/static_layouts/orchidforest")

require("map/rooms/forest/rooms_flowerspower")   --引入一种room的文件，范围内随机分布

AddTaskPreInit("Speak to the king", function(task)  --将对应的room加入task中，出现这个task时就肯定有这个room出现
    task.room_choices["RosePatch"] = 1  --玫瑰花丛区域会出现在猪王村附近
end)
AddTaskPreInit("Speak to the king classic", function(task)  --玫瑰花丛区域会出现在猪王村附近
    task.room_choices["RosePatch"] = 1
end)
AddTaskPreInit("Forest hunters", function(task) --兰草花丛区域会出现在海象巢森林
    task.room_choices["OrchidPatch"] = 1
end)
AddTaskPreInit("Make a pick", function(task)    --蹄莲花丛区域会出现在出生门附近
    task.room_choices["LilyPatch"] = 1
end)

-- AddLevelPreInitAny(function(level)
--     if level.location ~= "forest" then
--         return
--     end
--     if not level.set_pieces then
--         level.set_pieces = {}
--     end
--     level.set_pieces["RoseGarden"] = {count = 1, tasks = {"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king", "Forest hunters", "Befriend the pigs", "For a nice walk", "Kill the spiders", "Killer bees!", "Make a Beehat", "The hunters", "Magic meadow", "Frogs and bugs", "Badlands"}}
--     level.set_pieces["OrchidGrave"] = {count = 1, tasks = {"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king", "Forest hunters", "Befriend the pigs", "For a nice walk", "Kill the spiders", "Killer bees!", "Make a Beehat", "The hunters", "Magic meadow", "Frogs and bugs", "Badlands"}}
--     level.set_pieces["LilyPond"] = {count = 1, tasks = {"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king", "Forest hunters", "Befriend the pigs", "For a nice walk", "Kill the spiders", "Killer bees!", "Make a Beehat", "The hunters", "Magic meadow", "Frogs and bugs", "Badlands"}}
--     level.set_pieces["OrchidForest"] = {count = 1, tasks = {"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king", "Forest hunters", "Befriend the pigs", "For a nice walk", "Kill the spiders", "Killer bees!", "Make a Beehat", "The hunters", "Magic meadow", "Frogs and bugs", "Badlands"}}
-- end)

------
--祈雨祭
------

LAYOUTS["SpartacussGrave"] = STATICLAYOUT.Get("map/static_layouts/spartacussgrave"..(isChinese and "_zh" or ""))
LAYOUTS["MoonDungeon"] = STATICLAYOUT.Get("map/static_layouts/moondungeon")

require("map/rooms/forest/rooms_prayforrain")

AddTaskPreInit("Squeltch", function(task)    --雨竹区域会出现在沼泽
    task.room_choices["MonsteraPatch"] = 1
end)
AddTaskPreInit("MoonIsland_Mine", function(task)    --月的地下城区域会出现在月岛矿区
    task.room_choices["MoonDungeonPosition"] = 1
end)

------
--电闪雷鸣
------

LAYOUTS["TourmalineBase"] = STATICLAYOUT.Get("map/static_layouts/tourmalinebase")

require("map/rooms/forest/rooms_flashandcrush")

AddTaskPreInit("Forest hunters", function(task)    --电气石矿区会出现在月石底座森林
    task.room_choices["TourmalineField"] = 1
end)

------
--尘世蜃楼
------

LAYOUTS["HelperCemetery"] = STATICLAYOUT.Get("map/static_layouts/helpercemetery"..(isChinese and "_zh" or ""), {
    start_mask = _G.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = _G.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    layout_position = _G.LAYOUT_POSITION.CENTER,
    disable_transform = true
})

require("map/rooms/forest/rooms_desertsecret")

AddTaskPreInit("Lightning Bluff", function(task)    --颤栗树森林会出现在蚁狮沙漠
    task.room_choices["ShyerryForest"] = 1
end)
AddTaskPreInit("BigBatCave", function(task)    --协助者墓园会出现在蝙蝠地形
    task.room_choices["HelperSquare"] = 1
end)

------
--丰饶传说
------

LAYOUTS["SivingCenter"] = STATICLAYOUT.Get("map/static_layouts/sivingcenter", {
    start_mask = _G.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = _G.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    layout_position = _G.LAYOUT_POSITION.CENTER,
    disable_transform = true
})

require("map/rooms/forest/rooms_legendoffall")

AddTaskPreInit("GreenForest", function(task)    --子圭之源会出现在绿蘑菇森林
    task.room_choices["SivingSource"] = 1
end)

-------------------------------
--taskset相关，主要是设置静态地形随机在世界产生
-------------------------------

AddTaskSetPreInit("default", function(taskset)
    local tasks_all = {"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king", "Forest hunters", "Befriend the pigs", "For a nice walk", "Kill the spiders", "Killer bees!", "Make a Beehat", "The hunters", "Magic meadow", "Frogs and bugs", "Badlands"}

    taskset.set_pieces["RoseGarden"] = {count = 1, tasks = tasks_all}
    taskset.set_pieces["OrchidGrave"] = {count = 1, tasks = tasks_all}
    taskset.set_pieces["LilyPond"] = {count = 1, tasks = tasks_all}
    taskset.set_pieces["OrchidForest"] = {count = 1, tasks = tasks_all}
end)

AddTaskSetPreInit("classic", function(taskset)
    local tasks_all = {"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king classic", "Forest hunters", "Befriend the pigs", "For a nice walk", "Kill the spiders", "Killer bees!", "Make a Beehat", "The hunters", "Magic meadow", "Frogs and bugs"}

    taskset.set_pieces["RoseGarden"] = {count = 1, tasks = tasks_all}
    taskset.set_pieces["OrchidGrave"] = {count = 1, tasks = tasks_all}
    taskset.set_pieces["LilyPond"] = {count = 1, tasks = tasks_all}
    taskset.set_pieces["OrchidForest"] = {count = 1, tasks = tasks_all}
end)

AddTaskSetPreInit("cave_default", function(taskset)
    taskset.set_pieces["SpartacussGrave"] = {count = 1, tasks = {"MudLights", "RedForest", "GreenForest", "BlueForest", "ToadStoolTask1", "ToadStoolTask2", "ToadStoolTask3"}}
end)
