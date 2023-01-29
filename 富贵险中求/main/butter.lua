local function ondofn(inst, doer)
    if doer.components.debuffable then
        doer.components.debuffable:AddDebuff("ndnr_butterdebuff", "ndnr_butterdebuff")
    end
    if doer.components.talker ~= nil then
        doer.components.talker:Say(TUNING.NDNR_SMEAR_BUTTER)
    end
end

AddPrefabPostInit("butter", function(inst)
    inst:AddTag("ndnr_addoil")

    if not TheWorld.ismastersim then
        return
    end

    if inst.components.ndnr_smearable == nil then
        inst:AddComponent("ndnr_smearable")
    end
    inst.components.ndnr_smearable:OnDo(ondofn)
end)