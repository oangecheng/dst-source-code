-- local function onhammered(inst, worker)
--     if inst.components.spawner ~= nil and inst.components.spawner:IsOccupied() then
--         inst.components.spawner:ReleaseChild()
--     end
--     inst.components.lootdropper:DropLoot()
--     local fx = SpawnPrefab("collapse_big")
--     fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
--     fx:SetMaterial("rock")
--     inst:Remove()
-- end

-- local function onhit(inst, worker)
--     inst.AnimState:PlayAnimation("hit")
--     inst.AnimState:PushAnimation("idle")
-- end

-- AddPrefabPostInit("slurtlehole", function(inst)
--     if not TheWorld.ismastersim then return inst end

--     if inst.components.health then
--         inst:RemoveComponent("health")
--     end
--     if not inst.components.workable then
--         inst:AddComponent("workable")
--         inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
--         inst.components.workable:SetWorkLeft(4)
--         inst.components.workable:SetOnFinishCallback(onhammered)
--         inst.components.workable:SetOnWorkCallback(onhit)
--     end

--     if inst.components.lootdropper then
--         inst:RemoveComponent("lootdropper")
--         inst:AddComponent("lootdropper")
--     end
-- end)

-- local slurtles = {"slurtle", "snurtle"}
-- for i, v in ipairs(slurtles) do
--     AddPrefabPostInit(v, function(inst)
--         if not TheWorld.ismastersim then return inst end

--         if inst.components.lootdropper then
--             inst.components.lootdropper:AddChanceLoot("slurtlehole_blueprint", 0.1)
--         end
--     end)
-- end