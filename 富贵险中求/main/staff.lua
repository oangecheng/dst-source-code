
local function _SpawnLootPrefab(inst, lootprefab)
    if lootprefab == nil then
        return
    end

    local loot = SpawnPrefab(lootprefab)
    if loot == nil then
        return
    end

    local x, y, z = inst.Transform:GetWorldPosition()

    if loot.Physics ~= nil then
        local angle = math.random() * 2 * PI
        loot.Physics:SetVel(2 * math.cos(angle), 10, 2 * math.sin(angle))

        if inst.Physics ~= nil then
            local len = loot:GetPhysicsRadius(0) + inst:GetPhysicsRadius(0)
            x = x + math.cos(angle) * len
            z = z + math.sin(angle) * len
        end

        loot:DoTaskInTime(1, CheckSpawnedLoot)
    end

    loot.Transform:SetPosition(x, y, z)

	loot:PushEvent("on_loot_dropped", {dropper = inst})

    return loot
end

AddPrefabPostInit("greenstaff", function(inst)
    if not TheWorld.ismastersim then return inst end

    if inst.components.spellcaster ~= nil then
        local _spell = inst.components.spellcaster.spell
        inst.components.spellcaster:SetSpellFn(function(staff, target)
            if table.contains({"ndnr_corruptionstaff", "ndnr_opalpreciousamulet"}, target.prefab) then -- 模组里的物品，特殊处理
                local recipe = AllRecipes[target.prefab]
                if recipe == nil or FunctionOrValue(recipe.no_deconstruction, target) then
                    --Action filters should prevent us from reaching here normally
                    return
                end

                local ingredient_percent =
                (   (target.components.finiteuses ~= nil and target.components.finiteuses:GetPercent()) or
                    (target.components.fueled ~= nil and target.components.inventoryitem ~= nil and target.components.fueled:GetPercent()) or
                    (target.components.armor ~= nil and target.components.inventoryitem ~= nil and target.components.armor:GetPercent()) or
                    1
                ) / recipe.numtogive

                --V2C: Can't play sounds on the staff, or nobody
                --     but the user and the host will hear them!
                local caster = staff.components.inventoryitem.owner

                for i, v in ipairs(recipe.ingredients) do
                    caster.SoundEmitter:PlaySound("dontstarve/common/destroy_magic")
                    if not table.contains({"greenstaff", "opalpreciousgem"}, v.type) then -- 不返还的材料
                        --V2C: always at least one in case ingredient_percent is 0%
                        local amt = v.amount == 0 and 0 or math.max(1, math.ceil(v.amount * ingredient_percent))
                        for n = 1, amt do
                            _SpawnLootPrefab(target, v.type)
                        end
                    end
                end

                if caster ~= nil then
                    caster.SoundEmitter:PlaySound("dontstarve/common/staff_dissassemble")

                    if caster.components.staffsanity then
                        caster.components.staffsanity:DoCastingDelta(-TUNING.SANITY_MEDLARGE)
                    elseif caster.components.sanity ~= nil then
                        caster.components.sanity:DoDelta(-TUNING.SANITY_MEDLARGE)
                    end
                end

                staff.components.finiteuses:Use(1)

                target:PushEvent("ondeconstructstructure", caster)

                if target.components.stackable ~= nil then
                    --if it's stackable we only want to destroy one of them.
                    target.components.stackable:Get():Remove()
                else
                    target:Remove()
                end
            else
                if table.contains(TUNING.NDNR_CANUPGRADE_BACKPACKS, target.prefab) or
                    table.contains(TUNING.NDNR_CANUPGRADE_BOXES, target.prefab) then
                    if target.ndnr_forever_fresh and target.ndnr_forever_fresh == true then
                        _SpawnLootPrefab(target, "ndnr_energy_core")
                    end
                end
                _spell(staff, target)
            end
        end)
    end
end)