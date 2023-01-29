local sporeseed_tree = {
    ndnr_blue_sporeseed = "mushtree_tall",
    ndnr_red_sporeseed = "mushtree_medium",
    ndnr_green_sporeseed = "mushtree_small",
}

AddPrefabPostInit("mushroom_farm", function(inst)
    if not TheWorld.ismastersim then return end

    local old_accepttest = inst.components.trader.abletoaccepttest
    inst.components.trader:SetAbleToAcceptTest(function(inst, item)
        if item ~= nil and item:HasTag("ndnr_sporeseed") then
            return true
        end
        return old_accepttest(inst, item)
    end)

    local old_onacceptitem = inst.components.trader.onaccept
    inst.components.trader.onaccept = function(inst, giver, item)
        if inst.remainingharvests ~= 0 and item:HasTag("ndnr_sporeseed") then
            print(1, inst.remainingharvests, item:HasTag("ndnr_sporeseed"))
            if inst.components.harvestable ~= nil then
                local x, y, z = inst.Transform:GetWorldPosition()

                local mushroom_tree = SpawnPrefab(sporeseed_tree[item.prefab])
                mushroom_tree.Transform:SetPosition(x, y, z)

                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/mushtree_grow")
                
                -- 毒菌蟾蜍的蘑菇炸弹
                local bomb = SpawnPrefab("mushroombomb")
                bomb.Transform:SetPosition(x, y, z)

                inst:Remove()
            end
        else
            old_onacceptitem(inst, giver, item)
        end
    end
end)