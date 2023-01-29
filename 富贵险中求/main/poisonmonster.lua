for key, value in pairs(TUNING.NDNR_SMEARPOISON_MONSTERS) do
    AddPrefabPostInit(value, function(inst)
        if value ~= "worm" then
            if not inst.components.talker then inst:AddComponent("talker") end
        end

        if not TheWorld.ismastersim then return inst end

        if not inst.components.named then inst:AddComponent("named") end

        if inst.components.health then
            inst:ListenForEvent("attacked", function(inst, data)
                if data.weapon and data.weapon:HasTag("poison") then
                    inst:AddTag("ndnr_poisoning")

                    local name = STRINGS.NAMES[string.upper(inst.prefab)] or ""
                    inst.components.named:SetName(TUNING.NDNR_NAME_PREFIX_POISONED .. " " .. name)

                    if not inst.components.debuffable then inst:AddComponent("debuffable") end
                    inst.components.debuffable:AddDebuff("ndnr_monsterpoisondebuff", "ndnr_monsterpoisondebuff")
                end
            end)
        end

        if inst.components.combat then
            inst.components.combat.onhitotherfn = function (inst, target, damage)
                if inst:HasTag("ndnr_poisoning") and math.random() < 1/3 then
                    if target:HasTag("player") and not target:HasTag("playerghost") and target.prefab ~= "wx78" and not target:HasTag("ndnr_poisoning") and not target:HasTag("poisonresist") then
                        if target.components.debuffable then
                            target.components.debuffable:AddDebuff("ndnr_poisondebuff", "ndnr_poisondebuff")
                            target.components.talker:Say(TUNING.NDNR_INFECTIONPOISONFROMMONSTER)
                        end
                    end
                end
            end
        end
    end)
end

for index, value in ipairs(TUNING.NDNR_SMEARPOISON_WEAPONS) do
    AddPrefabPostInit(value, function(inst)
        if not TheWorld.ismastersim then return inst end

        if not inst.components.named then inst:AddComponent("named") end

        local old_OnSave = inst.OnSave
        inst.OnSave = function(inst, data)
            if old_OnSave then old_OnSave(inst, data) end
            if inst:HasTag("poison") then
                data.haspoisontag = true
            end
        end
        local old_OnLoad = inst.OnLoad
        inst.OnLoad = function (inst, data)
            if old_OnLoad then old_OnLoad(inst, data) end
            if data and data.haspoisontag then
                inst:AddTag("poison")

                local name = STRINGS.NAMES[string.upper(value)] or ""
                inst.components.named:SetName(TUNING.NDNR_NAME_PREFIX_POISONOUS .. " " .. name)
            end
        end
    end)
end
