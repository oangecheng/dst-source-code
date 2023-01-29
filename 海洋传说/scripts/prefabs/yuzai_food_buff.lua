local function OnTimer(inst, data)
    if data.name == "bufftimeover" then
        inst.components.debuff:Stop()
    end	
end

local function OnStart(inst, target) 
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
    if inst.startfn then
        inst.startfn(inst, target)
    end
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnExtended(inst, target)
    if inst.extendedfn then
        inst.extendedfn(inst, target)
    end
    if inst.components.timer then
        inst.components.timer:StopTimer("bufftimeover")
        inst.components.timer:StartTimer("bufftimeover",inst.bufftime)
    end
end

local function OnDeath(inst,target)
    if inst.deathfn then
        inst.deathfn(inst, target)
    end
	inst:Remove()
end
--=====================================
local function makebuffs(name,data)
	local function fn()
        local inst = CreateEntity()
        if not TheWorld.ismastersim then
            inst:DoTaskInTime(0, inst.Remove)
            return inst
        end
        inst.entity:AddTransform()
        inst.entity:Hide()
        inst.persists = false
        inst:AddTag("CLASSIFIED")

        for k, v in pairs(data) do
            inst[k] = v
        end
        inst:AddComponent("debuff")
        inst.components.debuff:SetAttachedFn(OnStart)
        inst.components.debuff:SetDetachedFn(OnDeath)
        inst.components.debuff:SetExtendedFn(OnExtended)
        inst.components.debuff.keepondespawn = true

        if  data.bufftime ~= nil then
		    inst:AddComponent("timer")
		    inst.components.timer:StartTimer("bufftimeover", data.bufftime)
            inst:ListenForEvent("timerdone", OnTimer)
        end

		return inst
	end
	return Prefab(name, fn)
end

local function OnHealthTick(inst, target)
    if target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
        target.components.health:DoDelta(1, nil)
    else
        inst.components.debuff:Stop()
    end
end

return 
    makebuffs("sashimi_buff",
        {   
            bufftime = 240,
            startfn = function(inst,target)
                inst.task = inst:DoPeriodicTask(16, OnHealthTick, nil, target)
                if target.components.health ~= nil then
                    target.components.health.externalabsorbmodifiers:SetModifier(inst, 0.40)
                end
            end, 
            extendedfn = function(inst,target)
                inst.task:Cancel()
                inst.task = inst:DoPeriodicTask(16, OnHealthTick, nil, target)
            end,
            deathfn = function(inst,target)
                if target.components.health ~= nil then
                    target.components.health.externalabsorbmodifiers:RemoveModifier(inst)
                end
            end,
        }
    ),
    makebuffs("hot_fish_buff",
        {   
            bufftime = 720,
            startfn = function(inst,target)
                if target.components.temperature ~= nil then
                    target.components.temperature.hot_fish_insulation = 480
                end
            end, 
            extendedfn = nil,
            deathfn = function(inst,target)
                if target.components.temperature ~= nil then
                    target.components.temperature.hot_fish_insulation = 0
                end
            end,
        }
    ),
    makebuffs("lg_rice_buff",
        {   
            bufftime = 480,
            startfn = function(inst,target)
                if target.components.hunger ~= nil then
                    target.components.hunger.burnratemodifiers:SetModifier("lg_rice_buff", 3/5)
                end
            end, 
            extendedfn = nil,
            deathfn = function(inst,target)
                if target.components.hunger ~= nil then
                    target.components.hunger.burnratemodifiers:RemoveModifier("lg_rice_buff")
                end
            end,
        }
    ),
    makebuffs("honey_cake_buff",
        {   
            bufftime = 180,
            startfn = function(inst,target)
                if target.components.locomotor ~= nil then
                    target.components.locomotor:SetExternalSpeedMultiplier(target, "honey_cake_buff", 1.25)
                end
            end, 
            extendedfn = nil,
            deathfn = function(inst,target)
                if target.components.locomotor ~= nil then
                    target.components.locomotor:RemoveExternalSpeedMultiplier(target, "honey_cake_buff")
                end
            end,
        }
    ),
    makebuffs("lg_fishcake_buff",
        {   
            bufftime = 240,
            deathfn = function(inst,target)
                if target.components.health ~= nil and not target.components.health:IsDead() then
                    target.components.health:DoDelta(-40,false,"lg_fishcake")
                    if target.components.hunger then
                        target.components.hunger:DoDelta(-75)
                    end
                    if target.components.sanity then
                        target.components.sanity:DoDelta(-35)
                    end
                end
            end,
        }
    ) 