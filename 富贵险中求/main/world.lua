local upvaluehelper = require "components/ndnr_upvaluehelper"
local cooking = require("cooking")
local clockwork_common = require("prefabs/clockwork_common")
AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim then return inst end

    inst:DoTaskInTime(FRAMES, function(inst)
        if GLOBAL.Prefabs.tentacle and GLOBAL.Prefabs.tentacle.fn then
            local RETARGET_CANT_TAGS = upvaluehelper.Get(GLOBAL.Prefabs.tentacle.fn, "RETARGET_CANT_TAGS")
            if RETARGET_CANT_TAGS then
                table.insert(RETARGET_CANT_TAGS, "ndnr_tentacleking")
            end
        end
        if GLOBAL.Prefabs.bat and GLOBAL.Prefabs.bat.fn then
            local RETARGET_CANT_TAGS = upvaluehelper.Get(GLOBAL.Prefabs.bat.fn, "RETARGET_CANT_TAGS")
            if RETARGET_CANT_TAGS then
                table.insert(RETARGET_CANT_TAGS, "catcoonhatprotect")
            end
        end
        if GLOBAL.Prefabs.bee and GLOBAL.Prefabs.bee.fn then
            local RETARGET_CANT_TAGS = upvaluehelper.Get(GLOBAL.Prefabs.bee.fn, "RETARGET_CANT_TAGS")
            if RETARGET_CANT_TAGS then
                table.insert(RETARGET_CANT_TAGS, "hivehatprotect")
            end
        end
        if GLOBAL.Prefabs.killerbee and GLOBAL.Prefabs.killerbee.fn then
            local RETARGET_CANT_TAGS = upvaluehelper.Get(GLOBAL.Prefabs.killerbee.fn, "RETARGET_CANT_TAGS")
            if RETARGET_CANT_TAGS then
                table.insert(RETARGET_CANT_TAGS, "hivehatprotect")
            end
        end
        if GLOBAL.Prefabs.frog and GLOBAL.Prefabs.frog.fn then
            local RETARGET_CANT_TAGS = upvaluehelper.Get(GLOBAL.Prefabs.frog.fn, "RETARGET_CANT_TAGS")
            if RETARGET_CANT_TAGS then
                table.insert(RETARGET_CANT_TAGS, "ndnr_snakeprotect")
            end
        end
        if GLOBAL.Prefabs.sporecloud and GLOBAL.Prefabs.sporecloud.fn then
            local SPOIL_CANT_TAGS = upvaluehelper.Get(GLOBAL.Prefabs.sporecloud.fn, "SPOIL_CANT_TAGS")
            if SPOIL_CANT_TAGS then
                table.insert(SPOIL_CANT_TAGS, "poisonresist")
            end
            local AURA_EXCLUDE_TAGS = upvaluehelper.Get(GLOBAL.Prefabs.sporecloud.fn, "AURA_EXCLUDE_TAGS")
            if AURA_EXCLUDE_TAGS then
                table.insert(AURA_EXCLUDE_TAGS, "poisonresist")
            end
            local TryPerish = upvaluehelper.Get(GLOBAL.Prefabs.sporecloud.fn, "TryPerish")
            if TryPerish then
                local function _TryPerish(item)
                    if item:IsInLimbo() then
                        local owner = item.components.inventoryitem ~= nil and item.components.inventoryitem.owner or nil
                        if owner == nil or (owner ~= nil and owner:HasTag("poisonresist")) or
                            (owner.components.container ~= nil and not owner.components.container:IsOpen() and owner:HasTag("structure")) or
                            (owner.components.container ~= nil and owner.ndnr_forever_fresh) then
                            return
                        end
                    end
                    TryPerish(item)
                end
                upvaluehelper.Set(GLOBAL.Prefabs.sporecloud.fn, "TryPerish", _TryPerish)
            end
        end
    end)
    if GLOBAL.Prefabs.portablespicer and GLOBAL.Prefabs.portablespicer.fn then
        local _ShowProduct = upvaluehelper.Get(GLOBAL.Prefabs.portablespicer.fn, "ShowProduct")
        if _ShowProduct then
            local function newShowProduct(inst)
                _ShowProduct(inst)
                if not inst:HasTag("burnt") then
                    local product = inst.components.stewer.product
                    local recipe = cooking.GetRecipe(inst.prefab, product)
                    if recipe ~= nil then
                        product = recipe.basename or product
                        if recipe.spice ~= nil and string.sub(recipe.spice, 1, 4) == "NDNR" then
                            inst.AnimState:ClearOverrideSymbol("swap_garnish")
                            inst.AnimState:OverrideSymbol("swap_garnish", "ndnr_spices", string.lower(recipe.spice))
                        end
                    end
                end
            end
            upvaluehelper.Set(GLOBAL.Prefabs.portablespicer.fn, "ShowProduct", newShowProduct)
        end
    end
    local function pondOnSnowLevel(inst, snowlevel)
        if inst.frozen then
            if not inst.components.lootdropper then
                inst:AddComponent("lootdropper")
            end
            if not inst.components.workable then
                inst:AddComponent("workable")
                inst.components.workable:SetWorkAction(ACTIONS.MINE)
                inst.components.workable:SetWorkLeft(TUNING.ICE_MINE*3)
                -- inst.components.workable:SetOnWorkCallback(function(inst, worker, workleft, numworks) end)
                inst.components.workable:SetOnFinishCallback(function(inst, worker)
                    if inst.components.lootdropper then
                        inst.components.lootdropper:SpawnLootPrefab("ice", inst:GetPosition())
                        inst.components.lootdropper:SpawnLootPrefab("ice", inst:GetPosition())
                        inst.components.lootdropper:SpawnLootPrefab("ice", inst:GetPosition())
                    end

                    inst.frozen = false
                    inst.AnimState:PlayAnimation("idle"..inst.pondtype, true)
                    -- inst.components.childspawner:StartSpawning()
                    inst.components.fishable:Unfreeze()

                    inst.Physics:SetCollisionGroup(COLLISION.LAND_OCEAN_LIMITS)
                    inst.Physics:ClearCollisionMask()
                    inst.Physics:CollidesWith(COLLISION.WORLD)
                    inst.Physics:CollidesWith(COLLISION.ITEMS)
                    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
                    inst.Physics:CollidesWith(COLLISION.GIANTS)

                    -- SpawnPlants(inst)

                    inst.components.watersource.available = true

                    if inst.components.timer then
                        inst.components.timer:StartTimer("ndnr_mineicetimer", TUNING.TOTAL_DAY_TIME)
                    end
                end)
            end

        else
            if inst.components.lootdropper then
                inst:RemoveComponent("lootdropper")
            end
            if inst.components.workable then
                inst:RemoveComponent("workable")
            end
        end
    end
    if GLOBAL.Prefabs.pond and GLOBAL.Prefabs.pond.fn then
        local _OnSnowLevel = upvaluehelper.Get(GLOBAL.Prefabs.pond.fn, "OnSnowLevel")
        if _OnSnowLevel then
            local function newOnSnowLevel(inst, snowlevel)
                if snowlevel > 0.02 then
                    local ndnr_mineice = inst.components.timer and inst.components.timer:TimerExists("ndnr_mineicetimer")
                    snowlevel = ndnr_mineice and 0 or snowlevel
                end
                _OnSnowLevel(inst, snowlevel)
                pondOnSnowLevel(inst, snowlevel)
            end
            upvaluehelper.Set(GLOBAL.Prefabs.pond.fn, "OnSnowLevel", newOnSnowLevel)
        end
    end
    if GLOBAL.Prefabs.pond_mos and GLOBAL.Prefabs.pond_mos.fn then
        local _OnMosSnowLevel = upvaluehelper.Get(GLOBAL.Prefabs.pond_mos.fn, "OnSnowLevel")
        if _OnMosSnowLevel then
            local function newOnMosSnowLevel(inst, snowlevel)
                if snowlevel > 0.02 then
                    local ndnr_mineice = inst.components.timer and inst.components.timer:TimerExists("ndnr_mineicetimer")
                    snowlevel = ndnr_mineice and 0 or snowlevel
                end
                _OnMosSnowLevel(inst, snowlevel)
                pondOnSnowLevel(inst, snowlevel)
            end
            upvaluehelper.Set(GLOBAL.Prefabs.pond_mos.fn, "OnSnowLevel", newOnMosSnowLevel)
        end
    end
    if clockwork_common and clockwork_common.Retarget then
        local RETARGET_CANT_TAGS = upvaluehelper.Get(clockwork_common.Retarget, "RETARGET_CANT_TAGS")
        if RETARGET_CANT_TAGS then
            table.insert(RETARGET_CANT_TAGS, "ndnr_robot")
        end
    end
    if GLOBAL.Prefabs.oasislake and GLOBAL.Prefabs.oasislake.fn then
        local _SpawnSucculents = upvaluehelper.Get(GLOBAL.Prefabs.oasislake.fn, "SpawnSucculents")
        if _SpawnSucculents then
            local function NewSpawnSucculents(inst)
                -- 生成多肉
                _SpawnSucculents(inst)

                -- 生成椰树
                local pt = inst:GetPosition()
                local function noentcheckfn(offset)
                    return #TheSim:FindEntities(offset.x, offset.y, offset.z, 3.2, nil, { "FX", "INLIMBO" }) == 0
                end
                local succulents_to_spawn = 12 - #TheSim:FindEntities(pt.x, pt.y, pt.z, 20, {"ndnr_palmtree", "ndnr_coconut_sapling"})
                for i = 1, succulents_to_spawn do
                    local offset = FindWalkableOffset(pt, math.random() * 2 * PI, GetRandomMinMax(8, 20), 8, false, false, noentcheckfn)
                    if offset ~= nil then
                        local plant = SpawnPrefab("ndnr_coconut_sapling")
                        plant.Transform:SetPosition((pt + offset):Get())
                        plant.AnimState:PlayAnimation("planted")
                    end
                end
            end
            upvaluehelper.Set(GLOBAL.Prefabs.oasislake.fn, "SpawnSucculents", NewSpawnSucculents)
        end
    end
end)






















