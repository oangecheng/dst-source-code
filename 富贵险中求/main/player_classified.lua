AddPrefabPostInit("player_classified", function(inst)

    local function OnPyEmoDirty(inst)
        if inst._parent ~= nil then
            local oldpercent = inst._oldemopercent
            local percent = inst.currentemo:value() / inst.maxemo:value()
            local data =
            {
                oldpercent = oldpercent,
                newpercent = percent,
                overtime =
                    not (inst.isemopulseup:value() and percent > oldpercent) and
                    not (inst.isemopulsedown:value() and percent < oldpercent),
            }
            inst._oldemopercent = percent
            inst.isemopulseup:set_local(false)
            inst.isemopulsedown:set_local(false)
            inst._parent:PushEvent("emodelta", data)
            if oldpercent > 0 then
                if percent <= 0 then
                    inst._parent:PushEvent("startemo")
                end
            elseif percent > 0 then
                inst._parent:PushEvent("stopemo")
            end
        else
            inst._oldemopercent = 1
            inst.isemopulseup:set_local(false)
            inst.isemopulsedown:set_local(false)
        end
    end

    local function OnPyEmoDelta(parent, data)
        if data.overtime then
            --V2C: Don't clear: it's redundant as player_classified shouldn't
            --     get constructed remotely more than once, and this would've
            --     also resulted in lost pulses if network hasn't ticked yet.
            --parent.player_classified.ishungerpulseup:set_local(false)
            --parent.player_classified.ishungerpulsedown:set_local(false)
        elseif data.newpercent > data.oldpercent then
            --Force dirty, we just want to trigger an event on the client
            parent.player_classified.isemopulseup:set_local(true)
            parent.player_classified.isemopulseup:set(true)
        elseif data.newpercent < data.oldpercent then
            --Force dirty, we just want to trigger an event on the client
            parent.player_classified.isemopulsedown:set_local(true)
            parent.player_classified.isemopulsedown:set(true)
        end
    end

    inst._oldemopercent = 0
    inst.currentemo = net_ushortint(inst.GUID, "ndnr_emo.current", "ndnr_emodirty")
    inst.maxemo = net_ushortint(inst.GUID, "ndnr_emo.max", "ndnr_emodirty")
    inst.isemopulseup = net_bool(inst.GUID, "ndnr_emo.dodeltaovertime(up)", "ndnr_emodirty")
    inst.isemopulsedown = net_bool(inst.GUID, "ndnr_emo.dodeltaovertime(down)", "ndnr_emodirty")
    inst.currentemo:set(100)
    inst.maxemo:set(100)

    if TheWorld.ismastersim then
        inst:ListenForEvent("emodelta", OnPyEmoDelta, inst._parent)
    else
        inst:ListenForEvent("ndnr_emodirty", OnPyEmoDirty)
    end

end)
