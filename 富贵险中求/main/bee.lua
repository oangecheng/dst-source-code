
AddPrefabPostInit("killerbee", function(inst)
    if not TheWorld.ismastersim then return inst end

    inst:ListenForEvent("onattackother", function(inst, data)
        local target = data.target
        if target ~= nil then
            if not table.contains(TUNING.NDNR_NOT_BEEPOISONPLAYERS, target.prefab)
                and not target:HasTag("beehatprotect")
                and target:HasTag("player") and not target:HasTag("playerghost")
                and not (target.components.rider ~= nil and target.components.rider:IsRiding()) then
                if target.components.debuffable then
                    target.components.debuffable:AddDebuff("ndnr_beepoisondebuff", "ndnr_beepoisondebuff")

                    if inst.components.health ~= nil then
                        inst.components.health:Kill()
                    end
                end
            end
        end
    end)

end)