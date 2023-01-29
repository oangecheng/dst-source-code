
local upvaluehelper = require "components/ndnr_upvaluehelper"
local SGshadow_chesspieces = require("stategraphs/SGshadow_chesspieces")

local ndnr_actions = {
    PLUCK = {
        id = "PLUCK",
        strfn = function(act)
            local _actionstr = act.target._actionstr
            if _actionstr == nil then
                return "GENERIC"
            else
                if act.doer and act.doer.prefab == "wurt" and _actionstr == "PRINCE_FORCE_KING_ABDICATE" then
                    _actionstr = "CROWN_PRINCE_FORCE_KING_ABDICATE"
                end
                return _actionstr
            end
        end,
        fn = function(act)
            -- ban myth fly
            if act.doer.components.mk_flyer and act.doer.components.mk_flyer:IsFlying() then return false, "NEEDLAND" end
            if act.target.sg ~= nil and (act.target.sg:HasStateTag("nofreeze") or act.target.sg:HasStateTag("flight")) then return false, "TOOFAR" end

            local product = act.target.components.ndnr_pluckable.product
            if act.target ~= nil and act.target.components.ndnr_pluckable
                and act.target.components.ndnr_pluckable:GetHairPercent() > 0
                -- and (act.target.sg == nil or (act.target.sg ~= nil and not act.target.sg:HasStateTag("nofreeze")))
                and product then
                local count = act.target.components.ndnr_pluckable.count
                if act.target.components.ndnr_pluckable.count > act.target.components.ndnr_pluckable.hairleft then
                    count = act.target.components.ndnr_pluckable.hairleft
                end

                if (act.target.components.health and not act.target.components.health:IsDead()) or not act.target.components.health then
                    local chance = act.target.components.ndnr_pluckable.chance
                    if string.find(act.target.prefab, "alterguardian_phase") ~= nil and act.doer.prefab == "winona" then --女工拆天体概率翻倍
                        chance = chance * 2
                    end
                    if math.random() > chance then
                        act.target.components.ndnr_pluckable:GetFail(act.target, act.doer, count)
                    else
                        local item = SpawnPrefab(product[math.random(1, #product)])

                        if item ~= nil then
                            if item.components.stackable then
                                item.components.stackable:SetStackSize(count)
                            end
                            act.doer.components.inventory:GiveItem(item, nil, act.doer:GetPosition())
                            act.target.components.ndnr_pluckable:ReduceHair(count, act.doer, item)
                        end
                    end
                end
                act.doer:PushEvent("ndnr_plucked", { target = act.target, doer = act.doer })
                return true
            end
        end
    },
    NDNR_PLUCKPLANT = {
        id = "NDNR_PLUCKPLANT",
        priority = -1,
        strfn = function(act)
            return "GENERIC"
        end,
        fn = function(act)
            if act.target ~= nil then
                act.target.components.ndnr_pluckplant:Do(act.doer, act.target)
            end
            return true
        end
    },
    SMEAR = {
        id = "SMEAR",
        strfn = function(act)
            return act.doer._actionstr or "GENERIC"
        end,
        fn = function(act)
            if act.invobject ~= nil and act.invobject.components.ndnr_smearable ~= nil then
                act.invobject.components.ndnr_smearable:OnApplied(act.doer)
            end
            return true
        end
    },
    SMEARSTAFF = {
        id = "SMEARSTAFF",
        strfn = function(act)
            return act.invobject and act.invobject._actionstr or "GENERIC"
        end,
        fn = function(act)
            if act.invobject ~= nil and act.invobject.components.ndnr_smearstaff then
                act.invobject.components.ndnr_smearstaff:Do(act.doer, act.target)
            end
            return true
        end
    },
    RUBBING = {
        id = "RUBBING",
        priority = 2,
        strfn = function(act)
            return "GENERIC"
        end,
        fn = function(act)
            if act.invobject ~= nil and act.invobject.components.ndnr_rubbing then
                return act.invobject.components.ndnr_rubbing:Do(act.doer, act.invobject, act.target)
            end
            return false
        end
    },
    NDNR_CUREPOISON = {
        id = "NDNR_CUREPOISON",
        priority = 2,
        strfn = function(act)
            return "NDNR_CUREPOISON"
        end,
        fn = function(act)
            local target = act.target or act.doer
            if target ~= nil and act.invobject ~= nil and target.components.health ~= nil and not (target.components.health:IsDead() or target:HasTag("playerghost")) then
                if act.invobject.components.ndnr_poisonhealer ~= nil then
                    return act.invobject.components.ndnr_poisonhealer:Cure(target)
                end
            end
        end
    },
    NDNR_REPAIR = {
        id = "NDNR_REPAIR",
        strfn = function(act)
            return act.invobject and act.invobject._actionstr or "GENERIC"
        end,
        fn = function(act)
            local target = act.target
            if target ~= nil and act.invobject ~= nil then
                return act.invobject.components.ndnr_repair:Do(act.doer, target)
            end
        end
    },
    STOPBLEEDING = {
        id = "STOPBLEEDING",
        strfn = function(act)
            return "STOPBLEEDING"
        end,
        fn = function(act)
            local doer = act.doer
            if doer ~= nil and act.invobject ~= nil then
                return act.invobject.components.ndnr_stopbleeding:Do(act.invobject, doer)
            end
        end
    },
    NDNR_INJECTION = {
        id = "NDNR_INJECTION",
        strfn = function(act)
            return "NDNR_INJECTION"
        end,
        fn = function(act)
            local doer = act.doer
            if doer ~= nil and act.invobject ~= nil then
                return act.invobject.components.ndnr_injection:Do(act.invobject, doer)
            end
        end
    },
    NDNR_MELTER = {
        id = "NDNR_MELTER",
        strfn = function(act)
            return "NDNR_MELTER"
        end,
        fn = function(act)
            if act.target.components.ndnr_melter then
                act.target.components.ndnr_melter:StartCooking()
                return true
            end
        end
    },
    NDNR_UPGRADE = {
        id = "NDNR_UPGRADE",
        priority = 4,
        strfn = function(act)
            return "NDNR_UPGRADE"
        end,
        fn = function(act)
            local target = act.target
            if target ~= nil and act.invobject ~= nil then
                return act.invobject.components.ndnr_upgradestaff:Do(act.doer, target)
            end
        end
    },
    NDNR_EXPERIMENT = {
        id = "NDNR_EXPERIMENT",
        priority = 1,
        strfn = function(act)
            return "NDNR_EXPERIMENT"
        end,
        fn = function(act)
            local target = act.target
            if target ~= nil and act.invobject ~= nil then
                return act.invobject.components.ndnr_experimentstaff:Do(act.doer, target)
            end
        end
    },
    NDNR_REPAIRGRAVE = {
        id = "NDNR_REPAIRGRAVE",
        strfn = function(act)
            return "NDNR_REPAIRGRAVE"
        end,
        fn = function(act)
            local target = act.target
            if target ~= nil and act.invobject ~= nil then
                return act.invobject.components.ndnr_repairgrave:Do(act.doer, target)
            end
        end
    },
    NDNR_ROE = {
        id = "NDNR_ROE",
        strfn = function(act)
            return "NDNR_ROE"
        end,
        fn = function(act)
            local target = act.target
            if target ~= nil and act.invobject ~= nil then
                return act.invobject.components.ndnr_roe:Do(act.doer, target)
            end
        end
    },
    NDNR_HARVESTFISH = {
        id = "NDNR_HARVESTFISH",
        strfn = function(act)
            return "NDNR_HARVESTFISH"
        end,
        fn = function(act)
            local target = act.target
            if target ~= nil and target.components.ndnr_harvestfish then
                return target.components.ndnr_harvestfish:Do(act.doer)
            end
        end
    },
    NDNR_BOUNTYTASK = {
        id = "NDNR_BOUNTYTASK",
        strfn = function(act)
            return "NDNR_BOUNTYTASK"
        end,
        fn = function(act)
            local doer = act.doer
            if doer ~= nil and act.invobject ~= nil then
                act.invobject.components.ndnr_bountytask:Do(act.doer)
                return true
            end
        end
    },
    LAVASPIT = {
        id = "LAVASPIT",
        priority = 0,
        distance = 2,
        str = "Dragonfly Saliva",
        fn = function(act)
            if act.doer and act.target and act.doer.prefab == "dragonfly" then
                local spit = SpawnPrefab("lavaspit")
                local x, y, z = act.doer.Transform:GetWorldPosition()
                local downvec = TheCamera:GetDownVec()
                local offsetangle = math.atan2(downvec.z, downvec.x) * (180 / math.pi)
                if act.doer.AnimState:GetCurrentFacing() == 0 then -- Facing right
                    offsetangle = offsetangle + 70
                else -- Facing left
                    offsetangle = offsetangle - 70
                end
                while offsetangle > 180 do
                    offsetangle = offsetangle - 360
                end
                while offsetangle < -180 do
                    offsetangle = offsetangle + 360
                end
                local offsetvec = Vector3(math.cos(offsetangle * DEGREES), -.3, math.sin(offsetangle * DEGREES)) * 1.7
                spit.Transform:SetPosition(x + offsetvec.x, y + offsetvec.y, z + offsetvec.z)
                spit.Transform:SetRotation(act.doer.Transform:GetRotation())
            end
            if act.doer and act.target and act.doer.prefab == "dragoon" then
                local spit = SpawnPrefab("dragoonspit")
                local x, y, z = act.doer.Transform:GetWorldPosition()
                local downvec = TheCamera:GetDownVec()
                local offsetangle = math.atan2(downvec.z, downvec.x) * (180 / math.pi)

                while offsetangle > 180 do
                    offsetangle = offsetangle - 360
                end
                while offsetangle < -180 do
                    offsetangle = offsetangle + 360
                end
                local offsetvec = Vector3(math.cos(offsetangle * DEGREES), -.3, math.sin(offsetangle * DEGREES)) * 1.7
                spit.Transform:SetPosition(x + offsetvec.x, y + offsetvec.y, z + offsetvec.z)
                spit.Transform:SetRotation(act.doer.Transform:GetRotation())
            end
        end
    }
}

for k, v in pairs(ndnr_actions) do
    local _action = Action()
    _action.id = v.id
    _action.priority = v.priority or 0
    _action.fn = v.fn
    if v.strfn then
        _action.strfn = v.strfn
    end
    if v.str then
        _action.str = v.str
    end
    if v.distance then
        _action.distance = v.distance
    end
    AddAction(_action)
end

-----------------------------ACTIONS HOOK-----------------------------------------
local _storestrfn = ACTIONS.STORE.strfn
ACTIONS.STORE.strfn = function(act)
    if act.target ~= nil and act.target:HasTag("ndnr_smelter") then
        return "NDNR_MELTER"
    end
    return _storestrfn(act)
end

local _sleepinstrfn = ACTIONS.SLEEPIN.strfn
ACTIONS.SLEEPIN.strfn = function(act)
    if act.target ~= nil and act.target:HasTag("ndnr_sleepbuild_pig") then
        return "NDNR_SLEEPIN"
    end
    if act.target ~= nil and act.target:HasTag("ndnr_sleepbuild_fishman") then
        return "NDNR_SLEEPIN_FISHMAN"
    end
    return _sleepinstrfn and _sleepinstrfn(act) or "SLEEPIN"
end

local harvestfn = ACTIONS.HARVEST.fn
ACTIONS.HARVEST.fn = function(act)
    if act.target.components.ndnr_melter then
        return act.target.components.ndnr_melter:Harvest(act.doer)
    else
        return harvestfn(act)
    end
end

local _rummagestrfn = ACTIONS.RUMMAGE.strfn
ACTIONS.RUMMAGE.strfn = function(act)
    local targ = act.target or act.invobject
    local str = targ ~= nil
        and (   targ.replica.container ~= nil and
                targ.replica.container:IsOpenedBy(act.doer) and
                "CLOSE" or
                (act.target ~= nil and act.target:HasTag("ndnr_treehole") and "NDNR_TREEHOLE")
            )
        or nil
    if str == nil then str = _rummagestrfn(act) end
    return str
end

local _givefn = ACTIONS.GIVE.fn
ACTIONS.GIVE.fn = function(act)
    if act.target ~= nil and act.target.prefab == "wagstaff_npc_pstboss" and act.target.ndnr_bountytasklist then
        if act.target.components.trader ~= nil then
            local able, reason = act.target.components.trader:AbleToAccept(act.invobject, act.doer)
            if not able then
                return false, reason
            end
            local count = act.invobject.components.stackable ~= nil and act.invobject.components.stackable:StackSize() or 1
            act.target.components.trader:AcceptGift(act.doer, act.invobject, count)
            return true
        end
    end
    return _givefn(act)
end

local chopfn = ACTIONS.CHOP.fn
ACTIONS.CHOP.fn = function(act)
    if act.target.components.workable and act.target.components.workable.action == ACTIONS.CHOP then
        if act.invobject and act.invobject.components.ndnr_obsidiantool then
			act.invobject.components.ndnr_obsidiantool:Use(act.doer, act.target)
		end
    end
    return chopfn(act)
end

local _interact_withfn = ACTIONS.INTERACT_WITH.fn
ACTIONS.INTERACT_WITH.fn = function(act)
    if act.doer
        and act.doer.prefab == "friendlyfruitfly"
        and act.target ~= nil
        and act.doer.components.timer
        and act.doer.components.timer:TimerExists("ndnr_happyfriendlyfruitflytimer") then
        local x, y, z = act.target.Transform:GetWorldPosition()
        local ents = TheWorld.Map:GetEntitiesOnTileAtPoint(x, 0, z)
        for _, ent in ipairs(ents) do
            if ent.components.farmplanttendable ~= nil then
                ent.components.farmplanttendable:TendTo(act.doer)
            end
        end
        return true
    end
    return _interact_withfn(act)
end
----------------------------------------------------------------------

STRINGS.ACTIONS.PLUCK = {
    MILK = ACTIONS_PLUCK_MILK_STR,
    MAGMA = ACTIONS_PLUCK_MAGMA_STR,
    MILK_JELLY = ACTIONS_PLUCK_MILK_JELLY_STR,
    HAIR = ACTIONS_PLUCK_HAIR_STR,
    TOOTH = ACTIONS_PLUCK_TOOTH_STR,
    FISHOUT = ACTIONS_PLUCK_FISHOUT_STR,
    MASSAGE = ACTIONS_PLUCK_MASSAGE_STR,
    CUT = ACTIONS_PLUCK_CUT_STR,
    PRY = ACTIONS_PLUCK_PRY_STR,
    STEAL_BLUEPRINT = ACTIONS_PLUCK_STEAL_BLUEPRINT_STR,
    COPY = ACTIONS_PLUCK_COPY_STR,
    CUTHORN = ACTIONS_PLUCK_CUTHORN_STR,
    SAWN = ACTIONS_PLUCK_SAWN_STR,
    PEELSKIN = ACTIONS_PLUCK_PEELSKIN_STR,
    STEAL_BANANA = ACTIONS_PLUCK_STEAL_BANANA_STR,
    STEAL_GODTOKEN = ACTIONS_PLUCK_STEAL_GODTOKEN_STR,
    BORROW_WEATHER_POLE = ACTIONS_PLUCK_BORROW_WEATHER_POLE_STR,
    CAT_TAIL = ACTIONS_PLUCK_CAT_TAIL_STR,
    BREAK_GOAT_HORN = ACTIONS_PLUCK_BREAK_GOAT_HORN_STR,
    PICK_SPORE = ACTIONS_PLUCK_PICK_SPORE_STR,
    DIG_EYE = ACTIONS_DIG_EYE_STR,
    TURN_SEED = ACTIONS_TURN_SEED_STR,
    PICK = ACTIONS_PICK_STR,
    DIGOUT_TALLBIRD_NEST = ACTIONS_DIGOUT_TALLBIRD_NEST_STR,
    WANT_TONYS = ACTIONS_WANT_TONYS_STR,
    PICK_WORMLIGHT = ACTIONS_PICK_WORMLIGHT_STR,
    UNDRESS = ACTIONS_UNDRESS_STR,
    MOFISH = ACTIONS_MOFISH_STR,
    DIGOUT_CATCOONDEN = ACTIONS_DIGOUT_CATCOONDEN_STR,
    GIVEBACK_TOILMONEY = ACTIONS_GIVEBACK_TOILMONEY_STR,
    CATCH_WOBSTERDEN = ACTIONS_CATCH_WOBSTERDEN_STR,
    PICK_PINECONE = ACTIONS_PICK_PINECONE_STR,
    PICK_TWIGGY_NUT = ACTIONS_PICK_TWIGGY_NUT_STR,
    PICK_ACORN = ACTIONS_PICK_ACORN_STR,
    PICK_MOON_TREE_BLOSSOM = ACTIONS_PICK_MOON_TREE_BLOSSOM_STR,
    PICK_COCONUT = ACTIONS_PICK_COCONUT_STR,
    DISMANTLE_ENERGY_CORE = ACTIONS_DISMANTLE_ENERGY_CORE_STR,
    CUT_HAND = ACTIONS_CUT_HAND_STR,
    EXSANGUINATE = ACTIONS_EXSANGUINATE_STR,
    CROWN_PRINCE_FORCE_KING_ABDICATE = ACTIONS_CROWN_PRINCE_FORCE_KING_ABDICATE_STR,
    PRINCE_FORCE_KING_ABDICATE = ACTIONS_PRINCE_FORCE_KING_ABDICATE_STR,
    CUT_SHARKFIN = ACTIONS_CUT_SHARKFIN_STR,
    CAMP_RANSACK = ACTIONS_CAMP_RANSACK_STR,
    TOMB_ROBBING = ACTIONS_TOMB_ROBBING_STR,
    POUND_BEEHIVE = ACTIONS_POUND_BEEHIVE_STR,
    GENERIC = ACTIONS_PLUCK_STR,
}

STRINGS.ACTIONS.SMEAR = {
    GENERIC = ACTIONS_SMEAR_GENERIC_STR,
    SMEAR = ACTIONS_SMEAR_STR,
}

STRINGS.ACTIONS.SMEARSTAFF = {
    GENERIC = ACTIONS_SMEAR_STR,
    SMEARPOISON = ACTIONS_SMEARPOISON_STR,
    SMEARSALT = ACTIONS_SMEARSALT_STR,
}

STRINGS.ACTIONS.RUBBING = {
    GENERIC = ACTIONS_RUBBING_STR,
}

STRINGS.ACTIONS.NDNR_CUREPOISON = {
    GENERIC = ACTIONS_NDNR_CUREPOISON_GENERIC_STR,
    CUREPOISON = ACTIONS_NDNR_CUREPOISON_STR
}

STRINGS.ACTIONS.NDNR_REPAIR = {
    GENERIC = ACTIONS_NDNR_REPAIR_GENERIC_STR,
    FISH = ACTIONS_FISHREPAIR_STR,
    OBSIDIAN = ACTIONS_OBSIDIANREPAIR_STR,
    IRON = ACTIONS_IRONREPAIR_STR,
    KELP = ACTIONS_KELPREPAIR_STR,
    GNARWAIL_HORN = ACTIONS_GNARWAIL_HORNREPAIR_STR,
}

STRINGS.ACTIONS.STOPBLEEDING = {
    GENERIC = ACTIONS_STOPBLEEDING_GENERIC_STR,
    STOPBLEEDING = ACTIONS_STOPBLEEDING_STR
}

STRINGS.ACTIONS.NDNR_INJECTION = {
    GENERIC = ACTIONS_NDNR_INJECTION_GENERIC_STR,
    NDNR_INJECTION = ACTIONS_NDNR_INJECTION_STR
}

STRINGS.ACTIONS.NDNR_MELTER = {
    GENERIC = ACTIONS_NDNR_MELTER_GENERIC_STR,
    NDNR_MELTER = ACTIONS_NDNR_MELTER_STR
}

STRINGS.ACTIONS.NDNR_UPGRADE = {
    GENERIC = ACTIONS_NDNR_UPGRADE_GENERIC_STR,
    NDNR_UPGRADE = ACTIONS_NDNR_UPGRADE_STR
}

STRINGS.ACTIONS.NDNR_EXPERIMENT = {
    GENERIC = ACTIONS_NDNR_EXPERIMENT_GENERIC_STR,
    NDNR_EXPERIMENT = ACTIONS_NDNR_EXPERIMENT_STR
}

STRINGS.ACTIONS.NDNR_REPAIRGRAVE = {
    GENERIC = ACTIONS_NDNR_REPAIRGRAVE_GENERIC_STR,
    NDNR_REPAIRGRAVE = ACTIONS_NDNR_REPAIRGRAVE_STR
}

STRINGS.ACTIONS.NDNR_ROE = {
    GENERIC = ACTIONS_NDNR_ROE_GENERIC_STR,
    NDNR_ROE = ACTIONS_NDNR_ROE_STR
}

STRINGS.ACTIONS.NDNR_BOUNTYTASK = {
    GENERIC = ACTIONS_NDNR_BOUNTYTASK_GENERIC_STR,
    NDNR_BOUNTYTASK = ACTIONS_NDNR_BOUNTYTASK_STR
}

STRINGS.ACTIONS.NDNR_HARVESTFISH = {
    GENERIC = ACTIONS_NDNR_HARVESTFISH_GENERIC_STR,
    NDNR_HARVESTFISH = ACTIONS_NDNR_HARVESTFISH_STR
}

STRINGS.ACTIONS.NDNR_PLUCKPLANT = {
    GENERIC = ACTIONS_NDNR_PLUCKPLANT_GENERIC_STR,
    NDNR_PLUCKPLANT = ACTIONS_NDNR_PLUCKPLANT_STR
}

STRINGS.ACTIONS.STORE.NDNR_MELTER = ACTIONS_NDNR_MELTER_STR
STRINGS.ACTIONS.RUMMAGE.NDNR_TREEHOLE = ACTIONS_NDNR_TREEHOLE_STR

local _actionsleepinstr = STRINGS.ACTIONS.SLEEPIN
STRINGS.ACTIONS.SLEEPIN = {
    GENERIC = _actionsleepinstr,
    NDNR_SLEEPIN = ACTIONS_NDNR_SLEEPIN_STR,
    NDNR_SLEEPIN_FISHMAN = ACTIONS_NDNR_SLEEPIN_FISHMAN_STR,
}

--------------------------------------------------------------------------
--[[ ACTIONS FAIL MESSAGE ]]
STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.RUBBING = {
    NOFEATHERPENCIL = ACTIONFAIL_NOFEATHERPENCIL,
}
STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.PLUCK = {
    TOOFAR = ACTIONFAIL_TOOFAR,
    NEEDLAND = ACTIONFAIL_NEEDLAND,
}
STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.NDNR_REPAIRGRAVE = {
    NOSHOVEL = ACTIONFAIL_NOSHOVEL,
    NOTENOUGHFLOWER = ACTIONFAIL_NOTENOUGHFLOWER,
    NOTENOUGHCUTSTONE = ACTIONFAIL_NOTENOUGHCUTSTONE,
}
STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.NDNR_HARVESTFISH = {
    NOFISH = ACTIONFAIL_NOFISH,
}
STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.NDNR_EXPERIMENT = {
    WORMHOLE_CANT_ONWATER = ACTIONFAIL_WORMHOLE_CANT_ONWATER,
}
--------------------------------------------------------------------------

-- SCENE		using an object in the world
-- USEITEM		using an inventory item on an object in the world
-- POINT		using an inventory item on a point in the world
-- EQUIPPED		using an equiped item on yourself or a target object in the world
-- INVENTORY	using an inventory item
-- AddComponentAction("SCENE", "milkable", function(inst, doer, actions)
--     if not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding()) and inst:HasTag("milkable") then
--         table.insert(actions, ACTIONS.SQUEEZE)
--     end
-- end)
AddComponentAction("SCENE", "ndnr_pluckable", function(inst, doer, actions, right)
    if not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding())
        and inst:HasTag("pluckable") and ((not inst:HasTag("ndnr_rightaction")) or (inst:HasTag("ndnr_rightaction") and right)) then
        table.insert(actions, ACTIONS.PLUCK)
    end
end)
AddComponentAction("SCENE", "ndnr_pluckplant", function(inst, doer, actions, right)
    if not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding())
        and doer:HasTag("player") and not doer:HasTag("playerghost") and not doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        and inst:HasTag("ndnr_canpluckplant")
        and right then
        table.insert(actions, ACTIONS.NDNR_PLUCKPLANT)
    end
end)
AddComponentAction("INVENTORY", "ndnr_smearable", function(inst, doer, actions)
    if not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding())
        and (inst:HasTag("smearable") or (inst:HasTag("ndnr_addoil") and doer:HasTag("ndnr_machine")))
        and doer:HasTag("self_smearable") then
        table.insert(actions, ACTIONS.SMEAR)
    end
end)
AddComponentAction("USEITEM", "ndnr_smearstaff", function(inst, doer, target, actions, right)
    if not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding())
        and ((target:HasTag("weapon") and TableHasValue(TUNING.NDNR_SMEARPOISON_WEAPONS, target.prefab))
            or ((target.prefab == "slurtle" or target.prefab == "snurtle") and not target:HasTag("saltrock"))) then
        table.insert(actions, ACTIONS.SMEARSTAFF)
    end
end)
AddComponentAction("USEITEM", "ndnr_repair", function(inst, doer, target, actions, right)
    if not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding()) and
        target:HasTag("canrepairby"..inst.prefab) then
        table.insert(actions, ACTIONS.NDNR_REPAIR)
    end
end)
AddComponentAction("USEITEM", "ndnr_rubbing", function(inst, doer, target, actions, right)
    if not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding()) and target:HasTag("ndnr_canberubbing") then
        table.insert(actions, ACTIONS.RUBBING)
    end
end)
AddComponentAction("USEITEM", "ndnr_poisonhealer", function(inst, doer, target, actions, right)
    if target.replica.health ~= nil and target:HasTag("ndnr_poisoning") and target:HasTag("player") and not target:HasTag("playerghost") then
        table.insert(actions, ACTIONS.NDNR_CUREPOISON)
    end
end)
AddComponentAction("INVENTORY", "ndnr_poisonhealer", function(inst, doer, actions)
    if doer.replica.health ~= nil and doer:HasTag("ndnr_poisoning") and doer:HasTag("player") and not doer:HasTag("playerghost") then
        table.insert(actions, ACTIONS.NDNR_CUREPOISON)
    end
end)
AddComponentAction("INVENTORY", "ndnr_stopbleeding", function(inst, doer, actions)
    if not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding())
        and inst:HasTag("stopbleeding") and doer:HasTag("attacked_bleeding") then
        table.insert(actions, ACTIONS.STOPBLEEDING)
    end
end)
AddComponentAction("INVENTORY", "ndnr_injection", function(inst, doer, actions)
    if not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding())
        and inst:HasTag("ndnr_caninjection") and doer:HasTag("player") and not doer:HasTag("playerghost") then
        table.insert(actions, ACTIONS.NDNR_INJECTION)
    end
end)
AddComponentAction("SCENE", "ndnr_melter", function(inst, doer, actions, right)
    if not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding()) then
		if not inst:HasTag("burnt") then
		    if inst:HasTag("donecooking") then
		        table.insert(actions, ACTIONS.HARVEST)
		    elseif right and (inst.replica.container ~= nil and inst.replica.container:IsFull()) then
				table.insert(actions, ACTIONS.NDNR_MELTER)
		    end
		end
	end
end)
AddComponentAction("USEITEM", "ndnr_upgradestaff", function(inst, doer, target, actions, right)
    if not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding()) and target:HasTag("ndnr_canupgrade") and right then
        table.insert(actions, ACTIONS.NDNR_UPGRADE)
    end
end)
AddComponentAction("USEITEM", "ndnr_experimentstaff", function(inst, doer, target, actions, right)
    if not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding()) and target:HasTag("ndnr_canexperiment") and right then
        table.insert(actions, ACTIONS.NDNR_EXPERIMENT)
    end
end)
AddComponentAction("USEITEM", "ndnr_repairgrave", function(inst, doer, target, actions, right)
    if not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding()) and inst:HasTag("ndnr_sacrifice") and target:HasTag("skeleton") then
        table.insert(actions, ACTIONS.NDNR_REPAIRGRAVE)
    end
end)
AddComponentAction("USEITEM", "ndnr_roe", function(inst, doer, target, actions, right)
    if not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding()) and inst:HasTag("ndnr_roe") and target:HasTag("ndnr_fishfarm_empty") then
        table.insert(actions, ACTIONS.NDNR_ROE)
    end
end)
AddComponentAction("INVENTORY", "ndnr_bountytask", function(inst, doer, actions)
    if not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding())
        and inst:HasTag("ndnr_bounty") and not inst:HasTag("ndnr_summoned") and doer:HasTag("player") and not doer:HasTag("playerghost") then
        table.insert(actions, ACTIONS.NDNR_BOUNTYTASK)
    end
end)
AddComponentAction("SCENE", "ndnr_harvestfish", function(inst, doer, actions, right)
    if not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding())
        and not inst:HasTag("ndnr_fishfarm_empty") and doer:HasTag("player") and not doer:HasTag("playerghost") then
        table.insert(actions, ACTIONS.NDNR_HARVESTFISH)
    end
end)

local sgwilsons = {"wilson", "wilson_client"}
for i, v in ipairs(sgwilsons) do
    local _dolongactions = {
        -- ACTIONS.PLUCK,
        ACTIONS.NDNR_CUREPOISON,
        ACTIONS.SMEARSTAFF,
        ACTIONS.RUBBING,
        ACTIONS.STOPBLEEDING,
        ACTIONS.NDNR_INJECTION,
        ACTIONS.NDNR_REPAIR,
        ACTIONS.NDNR_EXPERIMENT,
        ACTIONS.NDNR_REPAIRGRAVE,
        ACTIONS.NDNR_BOUNTYTASK,
        ACTIONS.NDNR_ROE,
        ACTIONS.NDNR_HARVESTFISH,
        ACTIONS.NDNR_PLUCKPLANT,
    }
    for i1, v1 in ipairs(_dolongactions) do
        AddStategraphActionHandler(v, ActionHandler(v1, function(inst, action)
            return "dolongaction"
        end))
    end
    AddStategraphActionHandler(v, ActionHandler(ACTIONS.PLUCK, function(inst, action, state, condition)
        return "ndnr_pluck"
    end))
    AddStategraphActionHandler(v, ActionHandler(ACTIONS.SMEAR, function(inst, action)
        return "fertilize"
    end))
    AddStategraphActionHandler(v, ActionHandler(ACTIONS.NDNR_MELTER, function(inst, action)
        return "doshortaction"
    end))
    AddStategraphActionHandler(v, ActionHandler(ACTIONS.NDNR_UPGRADE, function(inst, action)
        return "ndnr_upgradestaff"
    end))
    --拔
    AddStategraphState(v, State {
        name = "ndnr_pluck",
        tags = {"doing", "busy"},

        onenter = function(inst, data)
            local bufferaction = inst:GetBufferedAction()
            local target = bufferaction ~= nil and bufferaction.target or nil

            local timeout = 1
            if target ~= nil and (target.components.ndnr_pluckable ~= nil or target.replica.ndnr_pluckable ~= nil) then
                timeout = target.components.ndnr_pluckable and target.components.ndnr_pluckable:GetSGTimeout() or target.replica.ndnr_pluckable:GetSGTimeout()
            end
            inst.sg:SetTimeout(timeout)
            inst.components.locomotor:Stop()

            if target ~= nil and (target.components.ndnr_pluckable ~= nil or target.replica.ndnr_pluckable ~= nil) then
                local sound = target.components.ndnr_pluckable and target.components.ndnr_pluckable:GetSound() or target.replica.ndnr_pluckable:GetSound()
                local soundname = target.components.ndnr_pluckable and target.components.ndnr_pluckable:GetSoundName() or target.replica.ndnr_pluckable:GetSound()
                if sound ~= nil and soundname ~= nil then
                    inst.sg.statemem.ndnr_sound = sound
                    inst.sg.statemem.ndnr_soundname = soundname
                    inst.SoundEmitter:PlaySound(inst.sg.statemem.ndnr_sound, inst.sg.statemem.ndnr_soundname)
                end
            end
            inst.AnimState:PlayAnimation("build_pre")
            inst.AnimState:PushAnimation("build_loop", true)
            if v == "wilson_client" then
                inst:PerformPreviewBufferedAction()
            end
        end,

        timeline = {TimeEvent(4 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("busy")
        end)},

        onupdate = function(inst)
            if v == "wilson_client" then
                if inst:HasTag("doing") then
                    if inst.entity:FlattenMovementPrediction() then
                        inst.sg:GoToState("idle", "noanim")
                    end
                elseif inst.bufferedaction == nil then
                    inst.AnimState:PlayAnimation("build_pst")
                    inst.sg:GoToState("idle", true)
                end
            end
        end,

        ontimeout = function(inst)
            if v == "wilson" then
                inst:PerformBufferedAction()
            elseif v == "wilson_client" then
                inst:ClearBufferedAction()
            end
            if inst.sg.statemem.ndnr_soundname ~= nil then
                inst.SoundEmitter:KillSound(inst.sg.statemem.ndnr_soundname)
            end
            inst.AnimState:PlayAnimation("build_pst")
        end,

        events = {EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end)},

        onexit = function(inst)
            if inst.sg.statemem.ndnr_soundname ~= nil then
                inst.SoundEmitter:KillSound(inst.sg.statemem.ndnr_soundname)
            end
            if v == "wilson" and inst.bufferedaction == inst.sg.statemem.action and
            (inst.components.playercontroller == nil or inst.components.playercontroller.lastheldaction ~= inst.bufferedaction) then
                inst:ClearBufferedAction()
            end
        end
    })
    --升级
    AddStategraphState(v, State {
        name = "ndnr_upgradestaff",
        tags = {"doing", "busy"},

        onenter = function(inst, data)
            local bufferaction = inst:GetBufferedAction()
            local target = bufferaction ~= nil and bufferaction.target or nil

            inst.components.locomotor:Stop()
            if target ~= nil and target:HasTag("ndnr_forgingsound") then
                inst.sg:SetTimeout(2)
                inst.SoundEmitter:PlaySound("ndnr_forging/mod_ndnr_music/ndnr_forging", "ndnr_forging")
            else
                inst.sg:SetTimeout(1)
            end

            inst.AnimState:PlayAnimation("build_pre")
            inst.AnimState:PushAnimation("build_loop", true)
            if v == "wilson_client" then
                inst:PerformPreviewBufferedAction()
            end
        end,

        timeline = {TimeEvent(4 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("busy")
        end)},

        onupdate = function(inst)
            if v == "wilson_client" then
                if inst:HasTag("doing") then
                    if inst.entity:FlattenMovementPrediction() then
                        inst.sg:GoToState("idle", "noanim")
                    end
                elseif inst.bufferedaction == nil then
                    inst.AnimState:PlayAnimation("build_pst")
                    inst.sg:GoToState("idle", true)
                end
            end
        end,

        ontimeout = function(inst)
            if v == "wilson" then
                inst:PerformBufferedAction()
            elseif v == "wilson_client" then
                inst:ClearBufferedAction()
            end
            inst.SoundEmitter:KillSound("ndnr_forging")
            inst.AnimState:PlayAnimation("build_pst")
        end,

        events = {EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end)},

        onexit = function(inst)
            if v == "wilson" then
                inst.SoundEmitter:KillSound("ndnr_forging")
            end
            if v == "wilson" and inst.bufferedaction == inst.sg.statemem.action and
            (inst.components.playercontroller == nil or inst.components.playercontroller.lastheldaction ~= inst.bufferedaction) then
                inst:ClearBufferedAction()
            end
        end
    })
end

AddStategraphPostInit("deerclops", function(sg)
    local events = {
        EventHandler("doattack", function(inst, data)
            if inst.components.health ~= nil and not inst.components.health:IsDead()
                and (not inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("hit")) then
                if not IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) or inst.components.timer:TimerExists("deerclopspluckabletimer") then
                    --normal deerclops has no laserbeam
                    inst.sg:GoToState("attack")
                else
                    local target = data ~= nil and data.target or inst.components.combat.target
                    local isfrozen, shouldfreeze = false, false
                    if target ~= nil then
                        if not target:IsValid() then
                            target = nil
                        elseif target.components.freezable ~= nil then
                            if target.components.freezable:IsFrozen() then
                                isfrozen = true
                            elseif target.components.freezable:ResolveResistance() - target.components.freezable.coldness <= 2 then
                                shouldfreeze = true
                            end
                        end
                    end
                    if isfrozen or not (shouldfreeze or inst.components.timer:TimerExists("laserbeam_cd")) then
                        inst.sg:GoToState("laserbeam", target)
                    else
                        inst.sg:GoToState("attack")
                    end
                end
            end
        end)
    }
    for k, v in pairs(events) do
        sg.events[v.name] = v
    end
end)

AddStategraphPostInit("shadow_rook", function(sg)
    local levelup_timeline = sg.states["levelup"].timeline
    table.remove(levelup_timeline, 2)
    table.insert(levelup_timeline, 2, TimeEvent(60 * FRAMES, function(inst)
        while inst:WantsToLevelUp() do
            inst:LevelUp()
        end
        if not inst.ndnr_copied then
            SGshadow_chesspieces.Functions.AwakenNearbyStatues(inst)
        end
        SGshadow_chesspieces.Functions.TriggerEpicScare(inst)
    end))

    local taunt_timeline = sg.states["taunt"].timeline
    table.remove(taunt_timeline, 2)
    table.insert(taunt_timeline, 2, TimeEvent(30 * FRAMES, function(inst)
        if not inst.ndnr_copied then
            SGshadow_chesspieces.Functions.AwakenNearbyStatues(inst)
        end
        SGshadow_chesspieces.Functions.TriggerEpicScare(inst)
    end))
end)

AddStategraphPostInit("shadow_bishop", function(sg)
    local levelup_timeline = sg.states["levelup"].timeline
    table.remove(levelup_timeline, 2)
    table.insert(levelup_timeline, 2, TimeEvent(58 * FRAMES, function(inst)
        while inst:WantsToLevelUp() do
            inst:LevelUp()
        end
        if not inst.ndnr_copied then
            SGshadow_chesspieces.Functions.AwakenNearbyStatues(inst)
        end
        SGshadow_chesspieces.Functions.TriggerEpicScare(inst)
    end))

    local taunt_timeline = sg.states["taunt"].timeline
    table.remove(taunt_timeline, 2)
    table.insert(taunt_timeline, 2, TimeEvent(12 * FRAMES, function(inst)
        if not inst.ndnr_copied then
            SGshadow_chesspieces.Functions.AwakenNearbyStatues(inst)
        end
        SGshadow_chesspieces.Functions.TriggerEpicScare(inst)
    end))
end)

AddStategraphPostInit("shadow_knight", function(sg)
    local levelup_timeline = sg.states["levelup"].timeline
    table.remove(levelup_timeline, 2)
    table.insert(levelup_timeline, 2, TimeEvent(61 * FRAMES, function(inst)
        while inst:WantsToLevelUp() do
            inst:LevelUp()
        end
        if not inst.ndnr_copied then
            SGshadow_chesspieces.Functions.AwakenNearbyStatues(inst)
        end
        SGshadow_chesspieces.Functions.TriggerEpicScare(inst)
    end))
end)

----------------------------------------------------------------------

AddStategraphPostInit("wilson", function(sg)
    local _onenter = sg.states["attack"].onenter
    sg.states["attack"].onenter = function(inst)
        _onenter(inst)
        local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if equip ~= nil and equip:HasTag("cutlass") then
            inst.SoundEmitter:PlaySound("ndnr_swordfish/ndnr_swordfish/swordfish")
        end
    end

    local _eatdeststate = sg.actionhandlers[ACTIONS.EAT].deststate
    if _eatdeststate ~= nil then
        sg.actionhandlers[ACTIONS.EAT].deststate = function(inst, action)
            local _eatstate = _eatdeststate(inst, action)
            if _eatstate == nil then return end
            local obj = action.target or action.invobject
            if obj ~= nil and obj:HasTag("chinesefood") then
                _eatstate = "eat"
            end
            return _eatstate
        end
    end
end)

-----修改原版动作的判定条件(代码来自神话)----------------------------------

local actions = upvaluehelper.Get(EntityScript.CollectActions, "COMPONENT_ACTIONS")
if actions and actions.POINT and actions.POINT.blinkstaff ~= nil then
    -- local old = actions.POINT.blinkstaff
    actions.POINT.blinkstaff = function(inst, doer, pos, actions, right)
        local x, y, z = pos:Get()
        if right and (TheWorld.Map:IsAboveGroundAtPoint(x, y, z) or TheWorld.Map:GetPlatformAtPoint(x, z) ~= nil) and
            not TheWorld.Map:IsGroundTargetBlocked(pos) and not doer:HasTag("steeringboat") and
            not doer:HasTag("poleoncooldown") then
            table.insert(actions, ACTIONS.BLINK)
        end
    end
end
if actions and actions.USEITEM and actions.USEITEM.fuel ~= nil then
    local old_fuel = actions.USEITEM.fuel
    actions.USEITEM.fuel = function(inst, doer, target, actions)
        local _actioncount = #actions
        old_fuel(inst, doer, target, actions)
        if #actions == _actioncount then --if _USEITEMfuel didn't add an action, we process the "secondaryfuel"
            if not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding())
                or (target.replica.inventoryitem ~= nil and target.replica.inventoryitem:IsGrandOwner(doer)) then
                if inst.prefab ~= "spoiled_food" and
                    inst:HasTag("quagmire_stewable") and
                    target:HasTag("quagmire_stewer") and
                    target.replica.container ~= nil and
                    target.replica.container:IsOpenedBy(doer) then
                    return
                end
                for k, v in pairs(FUELTYPE) do
                    if inst:HasTag(v.."_fuel") then
                        if target:HasTag(v.."_fueled") then
                            table.insert(actions, inst:GetIsWet() and ACTIONS.ADDWETFUEL or ACTIONS.ADDFUEL)
                        end
                        return
                    end
                end
                for k, v in pairs(TUNING.NDNR_FUELTYPE) do
                    if inst:HasTag(v.."_fuel") then
                        if target:HasTag(v.."_fueled") then
                            table.insert(actions, inst:GetIsWet() and ACTIONS.ADDWETFUEL or ACTIONS.ADDFUEL)
                        end
                        return
                    end
                end
            end
        end
    end
end
if actions and actions.EQUIPPED and actions.EQUIPPED.spellcaster ~= nil then
    local old_equipped_spellcaster = actions.EQUIPPED.spellcaster
    actions.EQUIPPED.spellcaster = function(inst, doer, target, actions, right)
        if not inst:HasTag("ndnr_nomagic") then
            old_equipped_spellcaster(inst, doer, target, actions, right)
        end
    end
end
if actions and actions.POINT and actions.POINT.spellcaster ~= nil then
    local old_point_spellcaster = actions.POINT.spellcaster
    actions.POINT.spellcaster = function(inst, doer, pos, actions, right)
        if right and not inst:HasTag("ndnr_nomagic") then
            old_point_spellcaster(inst, doer, pos, actions, right)
        end
    end
end
if actions and actions.SCENE and actions.SCENE.sleepingbag ~= nil then
    local old_scene_sleepingbag = actions.SCENE.sleepingbag
    actions.SCENE.sleepingbag = function(inst, doer, actions)
        if (inst:HasTag("ndnr_sleepbuild_pig") or inst:HasTag("ndnr_sleepbuild_fishman") or inst:HasTag("ndnr_sleepbuild_hermit")) then
            if (inst:HasTag("ndnr_sleepbuild_pig") and not doer:HasTag("ndnr_nosleeper"))
                or (inst:HasTag("ndnr_sleepbuild_fishman") and doer:HasTag("merm_builder"))
                or inst:HasTag("ndnr_sleepbuild_hermit") then
                table.insert(actions, ACTIONS.SLEEPIN)
            end
        else
            old_scene_sleepingbag(inst, doer, actions)
        end
    end
end
if actions and actions.USEITEM and actions.USEITEM.fertilizer ~= nil then
    local old_useitemfertilizer = actions.USEITEM.fertilizer
    actions.USEITEM.fertilizer = function(inst, doer, target, actions)
        if not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding()) and
            (   --[[crop]] (target:HasTag("notreadyforharvest") and not target:HasTag("withered")) or
                --[[grower]] target:HasTag("fertile") or target:HasTag("infertile") or
                --[[pickable]] target:HasTag("barren") or
                --[[quagmire_fertilizable]] target:HasTag("fertilizable")
            ) and (inst.prefab == "ash" and target.prefab == "ndnr_coffeebush") then
            table.insert(actions, ACTIONS.FERTILIZE)
        -- else
        --     -- 这里似乎有点问题，会导致灰烬无法给其他作物施肥？
        --     if (inst.prefab ~= "ash" and target.prefab == "ndnr_coffeebush") or (inst.prefab == "ash" and target.prefab ~= "ndnr_coffeebush") then
        --         return
        --     end
        --     old_useitemfertilizer(inst, doer, target, actions)
        end
        old_useitemfertilizer(inst, doer, target, actions)
    end
end
----------------------------------------------------------------------

-----挤奶动作兼容行为学(代码来自勋章)--------------------------------------
local actionqueuer_status, actionqueuer_data = pcall(require, "components/actionqueuer")
if actionqueuer_status then
	if AddActionQueuerAction then
    	AddActionQueuerAction("leftclick", "PLUCK", function(target) return target:HasTag("pluckable") end)
    	AddActionQueuerAction("rightclick", "PLUCK", function(target) return target:HasTag("pluckable") end)
    	AddActionQueuerAction("rightclick", "NDNR_PLUCKPLANT", function(target) return target:HasTag("ndnr_canpluckplant") end)
    end
end
----------------------------------------------------------------------