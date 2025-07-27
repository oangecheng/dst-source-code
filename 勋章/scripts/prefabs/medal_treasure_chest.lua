local assets = {
    Asset("ANIM", "anim/rabbitkinghorn_chest.zip"),
    Asset("SOUND", "sound/rifts4.fsb"),
}

local function DoQuietDown(inst, shouldemerge)
    inst.rabbitkinghorn_quietdowntask = nil
    inst.SoundEmitter:KillSound("move")
end
local function QuietDown(inst, timeline)
    if inst.rabbitkinghorn_quietdowntask ~= nil then
        inst.rabbitkinghorn_quietdowntask:Cancel()
        inst.rabbitkinghorn_quietdowntask = nil
    end
    inst.rabbitkinghorn_quietdowntask = inst:DoTaskInTime(timeline, DoQuietDown)
end

local function DoPlayEmerge(inst)
    inst.rabbitkinghorn_emergetask = nil
    inst.SoundEmitter:PlaySound("rifts4/storage_den/open_pst")
end
local function StopEmerge(inst)
    if inst.rabbitkinghorn_emergetask ~= nil then
        inst.rabbitkinghorn_emergetask:Cancel()
        inst.rabbitkinghorn_emergetask = nil
    end
end
local function PlayEmerge(inst, timeline)
    StopEmerge(inst)
    inst.rabbitkinghorn_emergetask = inst:DoTaskInTime(timeline, DoPlayEmerge)
end

--打开
local function onopen(inst)
    inst.AnimState:PlayAnimation("open")
    inst.AnimState:PushAnimation("open_idle", false)
    if not inst.SoundEmitter:PlayingSound("move") then
        inst.SoundEmitter:PlaySound("rifts4/storage_den/open", "move")
    end
    QuietDown(inst, 23 * FRAMES)
    PlayEmerge(inst, 14 * FRAMES)
end
--关闭时掉落所有物品并移除
local function onclose(inst)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    inst.persists = false
    inst.SoundEmitter:PlaySound("rifts4/storage_den/close")
    inst.AnimState:PlayAnimation("despawn")
    inst:ListenForEvent("animover", inst.Remove)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("rabbitkinghorn_chest")
    inst.AnimState:SetBuild("rabbitkinghorn_chest")
    inst.AnimState:PlayAnimation("spawn_pre")
    inst.AnimState:PushAnimation("close_idle", false)
    inst.AnimState:SetScale(1.3, 1.3)

    -- inst:AddComponent("container_proxy")

    if not TheNet:IsDedicated() then
        inst.SoundEmitter:PlaySound("rifts4/storage_den/open_pst")
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst) 
			inst.replica.container:WidgetSetup("rabbitkinghorn_container") 
		end
        return inst
    end

    inst.scrapbook_anim = "close_idle"

    inst:AddComponent("inspectable")

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("rabbitkinghorn_container")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    

    -- inst.components.container_proxy:SetOnOpenFn(OnOpen)
    -- inst.components.container_proxy:SetOnCloseFn(OnClose)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    -- inst:AddComponent("timer")
    -- inst:ListenForEvent("timerdone", ontimerdone)
    -- inst.components.timer:StartTimer("despawn", TUNING.RABBITKINGHORN_DURATION)

    -- inst.OnLoadPostPass = AttachPocketContainer

    -- if not POPULATING then
    --     AttachPocketContainer(inst)
    -- end

    return inst
end

return Prefab("medal_treasure_chest", fn, assets)
