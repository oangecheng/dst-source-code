local assets =
{
    Asset("ANIM", "anim/teleporter_worm.zip"),
    Asset("ANIM", "anim/teleporter_worm_build.zip"),
    Asset("ANIM", "anim/ndnr_teleporter_worm.zip"),
    Asset("SOUND", "sound/common.fsb"),

    Asset("IMAGE", "images/ndnr_wormhole.tex"),
    Asset("ATLAS", "images/ndnr_wormhole.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_wormhole.xml", 256),
}

local function GetStatus(inst)
    return inst.sg.currentstate.name ~= "idle" and "OPEN" or nil
end

local function OnRemove(inst)
    -- 原地生成一个小偷背包
    local x, y, z = inst.Transform:GetWorldPosition()
    local theifpack = SpawnPrefab("krampus_sack")
    theifpack.Transform:SetPosition(x, y, z)

    -- 如果有连接的虫洞，则取消相应虫洞的链接
    local mate = inst.components.teleporter.targetTeleporter
    if mate then
        mate.components.teleporter.targetTeleporter = nil

        --[[    _FindEntity为什么会没有声明？？？
        -- 尝试给落单的虫洞重新找一次对象
        local otherwormhole = _FindEntity(function(item)
            return item.prefab == "ndnr_wormhole" and item.components.teleporter.targetTeleporter == nil
        end)

        if #otherwormhole > 0 then
            mate.components.teleporter.targetTeleporter = otherwormhole[1]
            otherwormhole[1].components.teleporter.targetTeleporter = mate
        end
        ]]
    end

end

local function OnDoneTeleporting(inst, obj)
    if inst.closetask ~= nil then
        inst.closetask:Cancel()
    end
    inst.closetask = inst:DoTaskInTime(1.5, function()
        if not (inst.components.teleporter:IsBusy() or
                inst.components.playerprox:IsPlayerClose()) then
            inst.sg:GoToState("closing")
        end
    end)

    if obj ~= nil and obj:HasTag("player") then
        obj:DoTaskInTime(1, obj.PushEvent, "wormholespit") -- for wisecracker
    end
end

local function OnActivate(inst, doer)
    if doer:HasTag("player") then
        ProfileStatsSet("wormhole_used", true)
        AwardPlayerAchievement("wormhole_used", doer)

        local other = inst.components.teleporter.targetTeleporter
        if other ~= nil then
            DeleteCloseEntsWithTag({"WORM_DANGER"}, other, 15)
        end

        if doer.components.talker ~= nil then
            doer.components.talker:ShutUp()
        end
        if doer.components.sanity ~= nil and not doer:HasTag("nowormholesanityloss") and not inst.disable_sanity_drain then
            doer.components.sanity:DoDelta(-TUNING.SANITY_MED)
        end
        if doer.components.health ~= nil and not doer:HasTag("playerghost") then
            doer.components.health:DoDelta(-5, nil, "ndnr_wormhole", nil, nil, true)
        end

        --Sounds are triggered in player's stategraph
    elseif inst.SoundEmitter ~= nil then
        inst.SoundEmitter:PlaySound("dontstarve/common/teleportworm/swallow")
    end
end

local function OnActivateByOther(inst, source, doer)
    if not inst.sg:HasStateTag("open") then
        inst.sg:GoToState("opening")
    end
end

local function onnear(inst)
    if inst.components.teleporter:IsActive() and not inst.sg:HasStateTag("open") then
        inst.sg:GoToState("opening")
    end

    if inst.components.talker then
        if inst.components.teleporter.targetTeleporter == nil then
            inst.components.talker:Say(TUNING.NDNR_WORMHOLE_WORDS.ON_NEAR_NOOBJECT)
        else
            inst.components.talker:Say(TUNING.NDNR_WORMHOLE_WORDS.ON_NEAR)
        end
    end
end

local function onfar(inst)
    if not inst.components.teleporter:IsBusy() and inst.sg:HasStateTag("open") then
        inst.sg:GoToState("closing")
    end
    if inst.components.talker then
        if inst.components.teleporter.targetTeleporter == nil then
            inst.components.talker:Say(TUNING.NDNR_WORMHOLE_WORDS.ON_FAR_NOOBJECT)
        else
            inst.components.talker:Say(TUNING.NDNR_WORMHOLE_WORDS.ON_FAR)
        end
    end
end

local function onaccept(inst, giver, item)
    local rand = math.random()
    if item.prefab == "fossil_piece" and TheWorld.state.isnight and rand<1/16 then
        local stalker
        if not TheWorld:HasTag("cave") then
            stalker = SpawnPrefab("stalker_forest")
        elseif not giver.components.areaaware:CurrentlyInTag("Atrium") then
            stalker = SpawnPrefab("stalker")
        else
            local stargate = FindEntity(inst, ATRIUM_RANGE, ActiveStargate, STARGET_TAGS)
            if stargate ~= nil then
                stalker = SpawnPrefab("stalker_atrium")
                -- override the spawn point so stalker stays around the gate
                stalker.components.entitytracker:TrackEntity("stargate", stargate)
                stargate:TrackStalker(stalker)
            else
                --should not be possible
                stalker = SpawnPrefab("stalker")
            end
        end

        local x, y, z = inst.Transform:GetWorldPosition()

        inst:Remove()

        stalker.Transform:SetPosition(x, y, z)
        stalker.sg:GoToState("resurrect")

        giver.components.sanity:DoDelta(TUNING.REVIVE_SHADOW_SANITY_PENALTY)
    elseif item.prefab == "ndnr_waterdrop" then
        local x, y, z = inst.Transform:GetWorldPosition()

        if giver and giver.SoundEmitter then
            giver.SoundEmitter:PlaySound("dontstarve/common/ghost_spawn")
        end
        local fx = SpawnPrefab("statue_transition_2")
        if fx ~= nil then
            fx.Transform:SetPosition(x, y, z)
            fx.Transform:SetScale(1, 2, 1)
        end
        fx = SpawnPrefab("statue_transition")
        if fx ~= nil then
            fx.Transform:SetPosition(x, y, z)
            fx.Transform:SetScale(1, 1.5, 1)
        end

        inst:Remove()
    else
        inst.components.inventory:DropItem(item)
        inst.components.teleporter:Activate(item)
    end

end

local function StartTravelSound(inst, doer)
    inst.SoundEmitter:PlaySound("dontstarve/common/teleportworm/swallow")
    doer:PushEvent("wormholetravel", WORMHOLETYPE.WORM) --Event for playing local travel sound
end

local function OnSave(inst, data)
	if inst.disable_sanity_drain then
		data.disable_sanity_drain = true
	end
end

local function OnLoad(inst, data)
	if data ~= nil and data.disable_sanity_drain then
		inst.disable_sanity_drain = true
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.entity:AddPhysics() -- no collision, this is just for buffered actions
    inst.Physics:ClearCollisionMask()
    inst.Physics:SetSphere(1)

    inst.MiniMapEntity:SetIcon("ndnr_wormhole.tex")

    inst.AnimState:SetBank("teleporter_worm")
    inst.AnimState:SetBuild("teleporter_worm_build")
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    inst.AnimState:OverrideSymbol("worm_pieces", "ndnr_teleporter_worm", "worm_pieces")

    --trader, alltrader (from trader component) added to pristine state for optimization
    inst:AddTag("trader")
    inst:AddTag("alltrader")

    inst:AddTag("antlion_sinkhole_blocker")

    inst:AddComponent("talker")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:SetStateGraph("SGwormhole")

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus
    inst.components.inspectable:RecordViews()

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(4, 5)
    inst.components.playerprox.onnear = onnear
    inst.components.playerprox.onfar = onfar

    inst:AddComponent("teleporter")
    inst.components.teleporter.onActivate = OnActivate
    inst.components.teleporter.onActivateByOther = OnActivateByOther
    inst.components.teleporter.offset = 0
    inst:ListenForEvent("starttravelsound", StartTravelSound) -- triggered by player stategraph
    inst:ListenForEvent("doneteleporting", OnDoneTeleporting)
    inst:ListenForEvent("onremove", OnRemove)


    inst:AddComponent("inventory")

    inst:AddComponent("trader")
    inst.components.trader.acceptnontradable = true
    inst.components.trader.onaccept = onaccept
    inst.components.trader.deleteitemonaccept = false

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

    return inst
end

return Prefab("ndnr_wormhole", fn, assets)
