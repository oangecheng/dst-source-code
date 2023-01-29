
AddPrefabPostInit("hivehat", function(inst)
    if not TheWorld.ismastersim then return inst end

    if inst.components.equippable then
        local _onequipfn = inst.components.equippable.onequipfn
        local _onunequipfn = inst.components.equippable.onunequipfn
        inst.components.equippable.onequipfn = function(inst, owner)
            _onequipfn(inst, owner)
            owner:AddTag("hivehatprotect")
        end
        inst.components.equippable.onunequipfn = function(inst, owner)
            _onunequipfn(inst, owner)
            owner:RemoveTag("hivehatprotect")
        end
    end
end)

AddPrefabPostInit("catcoonhat", function(inst)
    if not TheWorld.ismastersim then return inst end

    if inst.components.equippable then
        local _onequipfn = inst.components.equippable.onequipfn
        local _onunequipfn = inst.components.equippable.onunequipfn
        inst.components.equippable.onequipfn = function(inst, owner)
            _onequipfn(inst, owner)
            owner:AddTag("catcoonhatprotect")
        end
        inst.components.equippable.onunequipfn = function(inst, owner)
            _onunequipfn(inst, owner)
            owner:RemoveTag("catcoonhatprotect")
        end
    end
end)

AddPrefabPostInit("beehat", function(inst)
    if not TheWorld.ismastersim then return inst end

    if inst.components.equippable then
        local _onequipfn = inst.components.equippable.onequipfn
        local _onunequipfn = inst.components.equippable.onunequipfn
        inst.components.equippable.onequipfn = function(inst, owner)
            _onequipfn(inst, owner)
            owner:AddTag("beehatprotect")
        end
        inst.components.equippable.onunequipfn = function(inst, owner)
            _onunequipfn(inst, owner)
            owner:RemoveTag("beehatprotect")
        end
    end
end)
