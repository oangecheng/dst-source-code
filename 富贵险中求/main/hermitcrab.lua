--[[
    蟹奶奶商店科技增加至9级，不开洞穴正常，开洞穴就失效
]]

-- local TechTree = require("techtree")
-- TUNING.PROTOTYPER_TREES.HERMITCRABSHOP_L5 = TechTree.Create({
--     HERMITCRABSHOP = 9,
-- })

-- TECH.HERMITCRABSHOP_NINE = { HERMITCRABSHOP = 9 }

-- AddPrefabPostInit("hermitcrab", function(inst)
--     if not TheWorld.ismastersim then return inst end

--     if inst.components.trader ~= nil then
--         local old_test = inst.components.trader.test
--         inst.components.trader.test = function(inst, item, giver)
--             if item.prefab == "hermit_cracked_pearl" and inst._shop_level ~= 5 then
--                 return false
--             end
--             return old_test(inst, item, giver)
--         end
--     end

--     inst:ListenForEvent("itemget", function(world, data)
--         if data.item.prefab == "hermit_cracked_pearl" then
--             inst:DoTaskInTime(1, function(inst)

--                 local smelter_blueprint = SpawnPrefab("ndnr_smelter_blueprint")
--                 inst.components.inventory:GiveItem(smelter_blueprint)
--                 inst:DoTaskInTime(2, function(inst)
--                     inst.components.npc_talker:Say(TUNING.NDNR_HERMITCRAB_GOT_PEARL_EX)
--                     inst.components.inventory:DropItem(smelter_blueprint)

--                     inst.ndnr_shoplevel_nine = true
--                     inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES["HERMITCRABSHOP_L5"]

--                     inst.sg:GoToState("refuse")
--                 end)
--             end)
--         end
--     end)

--     inst:DoTaskInTime(FRAMES, function(inst)
--         if inst.ndnr_shoplevel_nine == true then
--             inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES["HERMITCRABSHOP_L5"]
--         end
--     end)

--     local onsave = inst.OnSave
--     inst.OnSave = function(inst, data)
--         if onsave then
--             onsave(inst, data)
--         end
--         data.ndnr_shoplevel_nine = inst.ndnr_shoplevel_nine
--     end

--     local onload = inst.OnLoad
--     inst.OnLoad = function(inst, data)
--         if onload then
--             onload(inst, data)
--         end
--         if data and data.ndnr_shoplevel_nine then
--             inst.ndnr_shoplevel_nine = data.ndnr_shoplevel_nine
--         end
--     end
-- end)