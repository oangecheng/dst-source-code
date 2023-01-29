AddPrefabPostInit("forgetmelots", function(inst)
    inst:AddTag("ndnr_sacrifice")
    if not TheWorld.ismastersim then
        return inst
    end

    if not inst.components.ndnr_repairgrave then
        inst:AddComponent("ndnr_repairgrave")
    end
    inst.components.ndnr_repairgrave:SetDoFn(function(doer, target, marble)
        if doer and doer.components.debuffable then
            if marble then
                doer.components.debuffable:AddDebuff("ndnr_repairgravedebuff1", "ndnr_repairgravedebuff1")
            else
                doer.components.debuffable:AddDebuff("ndnr_repairgravedebuff2", "ndnr_repairgravedebuff2")
            end
        end

        if target then
            local pt = target:GetPosition()

            local grave = marble and "gravestone" or "mound"
            local gravestone = SpawnPrefab(grave)
            if gravestone then
                gravestone.Transform:SetPosition(pt:Get())

                if grave == "gravestone" and gravestone.components.ndnr_hoverer then
                    local name
                    if target.components.playeravatardata then
                        name = target.components.playeravatardata.hasdata
                            and target.components.playeravatardata.strings.name
                            and target.components.playeravatardata.strings.name:value()
                    end
                    if name and #name > 0 then
                        local content = string.format(TUNING.NDNR_EPITAPH, name, doer:GetDisplayName(), TheWorld.state.cycles)
                        gravestone.components.ndnr_hoverer:SetContent(content)
                    end
                end
            end

            if marble then
                local marbleitem = doer.components.inventory:RemoveItem(marble)
                if marbleitem then
                    marbleitem:Remove()
                end
            end

            local fx = SpawnPrefab("collapse_small")
            fx.Transform:SetPosition(pt:Get())
        end
    end)
end)