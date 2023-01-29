
local function smearstaff_do(self, doer, target)
    target:AddTag("saltrock")

    if target.components.combat then
        target.components.combat:SetAttackPeriod(2)
        target:PushEvent("attacked", {attacker = doer, damage = 0})
    end
    if target._saltbufftask == nil then
        target._saltbufftask = target:DoPeriodicTask(1, function (inst)
            if inst.components.health then
                inst.components.health:DoDelta(-10, nil, "saltrock", nil, nil, true)
            end
        end)
    end
    if self.inst.components.stackable then
        local item = self.inst.components.stackable:Get()
        item:Remove()
    end
end

AddPrefabPostInit("saltrock", function(inst)
    inst._actionstr = "SMEARSALT"

    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("ndnr_smearstaff")
    inst.components.ndnr_smearstaff:SetDoFn(smearstaff_do)
end)