local function DoMoisture(inst, owner)
    if owner.components.moisture then
        if owner.components.drownable:IsOverWater() and not (owner and owner.components.inventory:IsWaterproof()) then
            local waterproofness = owner.components.inventory:GetWaterproofness() or 0
            inst.components.equippable.equippedmoisture = 0.5 * (1-waterproofness)
        else
            inst.components.equippable.equippedmoisture = 0
        end
    end
end

local function DoRipple(inst, owner)
    if owner.components.drownable ~= nil and owner.components.drownable:IsOverWater() then
        SpawnPrefab("weregoose_ripple"..tostring(math.random(2))).entity:SetParent(owner.entity)
        if inst.ndnr_walkonwatertime == nil then
            inst.ndnr_walkonwatertime = 0
        end
        inst.ndnr_walkonwatertime = inst.ndnr_walkonwatertime + 0.11
        if inst.ndnr_walkonwatertime >= 1.5 then
            inst.components.finiteuses:Use(1.5)
            inst.ndnr_walkonwatertime = 0
        end
    end
end

local function rippletask(inst, owner, enable)
    if enable then
        if owner.ndnr_rippletask == nil then
            owner.ndnr_rippletask = owner:DoPeriodicTask(.7, function(owner) DoRipple(inst, owner) end, FRAMES)
        end
        if owner.ndnr_moisturetask == nil then
            owner.ndnr_moisturetask = owner:DoPeriodicTask(.7, function(owner) DoMoisture(inst, owner) end, FRAMES)
        end
    else
        if owner.ndnr_rippletask ~= nil then
            owner.ndnr_rippletask:Cancel()
            owner.ndnr_rippletask = nil
        end
        if owner.ndnr_moisturetask ~= nil then
            owner.ndnr_moisturetask:Cancel()
            owner.ndnr_moisturetask = nil
        end
    end
end

local function becameking(inst, owner)
    if owner.components.drownable ~= nil then
        if owner.components.drownable.enabled == false then
            owner.Physics:ClearCollisionMask()
            owner.Physics:CollidesWith(COLLISION.GROUND)
            owner.Physics:CollidesWith(COLLISION.OBSTACLES)
            owner.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
            owner.Physics:CollidesWith(COLLISION.CHARACTERS)
            owner.Physics:CollidesWith(COLLISION.GIANTS)
        elseif owner.components.drownable.enabled == true then
            if not owner:HasTag("playerghost") then
                owner.Physics:ClearCollisionMask()
                owner.Physics:CollidesWith(COLLISION.WORLD)
                owner.Physics:CollidesWith(COLLISION.OBSTACLES)
                owner.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
                owner.Physics:CollidesWith(COLLISION.CHARACTERS)
                owner.Physics:CollidesWith(COLLISION.GIANTS)
            end
        end
    end
end

AddPrefabPostInit("trident", function(inst)
    inst:AddTag("canrepairbykelp")
    inst:AddTag("canrepairbygnarwail_horn")

    if not TheWorld.ismastersim then
        return inst
    end

    if inst.components.equippable then
        inst.components.equippable.maxequippedmoisture = 100
        local _onequip = inst.components.equippable.onequipfn
        inst.components.equippable:SetOnEquip(function(inst, owner)
            _onequip(inst, owner)

            inst.components.equippable.equippedmoisture = 0
            if owner and owner.components.drownable then
                owner.components.drownable.enabled = false
                becameking(inst, owner)
                rippletask(inst, owner, true)
            end
        end)

        local _onunequip = inst.components.equippable.onunequipfn
        inst.components.equippable:SetOnUnequip(function(inst, owner)
            _onunequip(inst, owner)

            inst.components.equippable.equippedmoisture = 0
            if owner and owner.components.drownable then
                owner.components.drownable.enabled = true
                becameking(inst, owner)
                rippletask(inst, owner, false)
            end
        end)
    end

    local onsave = inst.OnSave
    inst.OnSave = function(inst, data)
        if onsave then
            onsave(inst, data)
        end
        data.ndnr_walkonwatertime = inst.ndnr_walkonwatertime
    end

    local onload = inst.OnLoad
    inst.OnLoad = function(inst, data)
        if onload then
            onload(inst, data)
        end
        if data and data.ndnr_walkonwatertime then
            inst.ndnr_walkonwatertime = data.ndnr_walkonwatertime
        end
    end

end)
