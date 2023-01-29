AddPrefabPostInit("forest_network", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    if not inst.components.ndnr_chinese_festival then
        inst:AddComponent("ndnr_chinese_festival")
    end

    inst:ListenForEvent("ndnr_moonboss_dismantled", function()
        if TheWorld.net.mod_ndnr == nil then TheWorld.net.mod_ndnr = {} end
        if TheWorld.net.mod_ndnr.moonboss_dismantled ~= true then
            TheWorld.net.mod_ndnr.moonboss_dismantled = true --天体被拆过
        end
    end, TheWorld)

    local onsave = inst.OnSave
    inst.OnSave = function(inst, data)
        if onsave then
            onsave(inst, data)
        end
        data.mod_ndnr = TheWorld.net.mod_ndnr
    end

    local onload = inst.OnLoad
    inst.OnLoad = function(inst, data)
        if onload then
            onload(inst, data)
        end
        if data and data.mod_ndnr then
            TheWorld.net.mod_ndnr = data.mod_ndnr

            TheWorld.net.mod_ndnr.isjingzhe = nil
            TheWorld.net.mod_ndnr.isqingming = nil
            TheWorld.net.mod_ndnr.isdongzhi = nil
            TheWorld.net.mod_ndnr.ischunjie = nil
            TheWorld.net.mod_ndnr.isqixi = nil
            TheWorld.net.mod_ndnr.iszhongyuan = nil
        end
    end

end)

AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    -- if not inst.components.ndnr_plague then
    --     inst:AddComponent("ndnr_plague")
    -- end

    if not inst.components.ndnr_lucky_goldnugget then
        inst:AddComponent("ndnr_lucky_goldnugget")
    end
    if not inst.components.ndnr_rootchestinventory then
        inst:AddComponent("ndnr_rootchestinventory")
    end

end)

AddPrefabPostInit("cave", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    if not inst.components.ndnr_rootchestinventory then
        inst:AddComponent("ndnr_rootchestinventory")
    end

end)