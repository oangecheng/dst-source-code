local ShouldAcceptItem = function(inst, item)
    return item:HasTag("drink")
end

local OnGetItemFromPlayer = function(inst, giver, item)
    if item:HasTag("mushroom_wine") then
        if not inst:HasTag("drunk") then
            inst:AddTag("drunk")
            inst.components.timer:StartTimer("toadstooldrunk", TUNING.TOTAL_DAY_TIME)
        else
            inst.components.timer:SetTimeLeft("toadstooldrunk", TUNING.TOTAL_DAY_TIME)
        end
        inst.components.talker:Say(TUNING.NDNR_GOOD_DRINK)
        inst.sg:GoToState("roar")
    end
end

local toadstools = {"toadstool", "toadstool_dark"}
for k, v in pairs(toadstools) do
    AddPrefabPostInit(v, function(inst)
        if not inst.components.talker then
            inst:AddComponent("talker")
            inst.components.talker.fontsize = 40
            inst.components.talker.font = TALKINGFONT
            inst.components.talker.colour = Vector3(238 / 255, 69 / 255, 105 / 255)
            inst.components.talker.offset = Vector3(0, -700, 0)
            inst.components.talker.symbol = "fossil_chest"
            inst.components.talker:MakeChatter()
        end

        if not TheWorld.ismastersim then
            return inst
        end

        if not inst.components.trader then
            inst:AddTag("trader")
            inst:AddComponent("trader")
            inst.components.trader:SetAcceptTest(ShouldAcceptItem)
            inst.components.trader.onaccept = OnGetItemFromPlayer
            inst.components.trader.deleteitemonaccept = true
        end

        local _DoMushroomSprout = inst.DoMushroomSprout
        inst.DoMushroomSprout = function(inst, angles)
            if not inst:HasTag("drunk") then
                _DoMushroomSprout(inst, angles)
            end
        end

        inst:ListenForEvent("timerdone", function(data)
            if data.name == "toadstooldrunk" then
                inst:RemoveTag("drunk")
            end
        end)

        if v == "toadstool_dark" then
            if inst.components.lootdropper then
                inst.components.lootdropper:AddChanceLoot("ndnr_corruptionstaff_blueprint", 1)
            end
        end
    end)
end