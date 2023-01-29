local function onhammered(inst, worker)
    if inst.components.spawner ~= nil and inst.components.spawner:IsOccupied() then
        inst.components.spawner:ReleaseChild()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("rock")
    inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle")
end

AddPrefabPostInit("houndmound", function(inst)
    if not TheWorld.ismastersim then return inst end

    if inst.components.health then
        inst:RemoveComponent("health")
    end
    if not inst.components.workable then
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(4)
        inst.components.workable:SetOnFinishCallback(onhammered)
        inst.components.workable:SetOnWorkCallback(onhit)
    end

    if inst.components.lootdropper then
        inst:RemoveComponent("lootdropper")
        inst:AddComponent("lootdropper")
    end

    -- 感谢《元素反应》的作者提供的修复
    local old_SpawnAllGuards = nil
    local old_OnHaunt = nil
    if inst.components.combat then
        old_SpawnAllGuards = inst.components.combat.onhitfn
    end
    if inst.components.hauntable then
        old_OnHaunt = inst.components.hauntable.onhaunt
    end

    if old_SpawnAllGuards == nil or old_OnHaunt == nil then
        return
    end

    local function SpawnAllGuards(inst, attacker)
        if inst.components.health == nil then
            return
        end
        old_SpawnAllGuards(inst, attacker)
    end

    local function OnHaunt(inst, haunter)
        if inst.components.health == nil then
            return
        end
        old_OnHaunt(inst, haunter)
    end

    if inst.components.combat then
        inst.components.combat:SetOnHit(SpawnAllGuards)
    end
    if inst.components.hauntable then
        inst.components.hauntable:SetOnHauntFn(OnHaunt)
    end

end)