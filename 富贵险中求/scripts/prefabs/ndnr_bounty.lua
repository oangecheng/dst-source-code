local assets =
{
	Asset("ANIM", "anim/ndnr_bounty.zip"),
    Asset("IMAGE", "images/ndnr_bounty.tex"),
    Asset("ATLAS", "images/ndnr_bounty.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_bounty.xml", 256),
}

local function OnDeliveryTask(inst, doer)
    local ipos = doer:GetPosition()
    local offset = FindWalkableOffset(ipos, 2*PI*math.random(), 2.5)
    if offset then
        ipos = ipos + offset
    end
    local npc = SpawnPrefab("wagstaff_npc_pstboss")
    npc.Transform:SetPosition(ipos:Get())
    npc.ndnr_bounty = inst
    npc.ndnr_bountytasklist = inst.components.ndnr_bountytask:GetList()
    npc.ndnr_bountytaskreward = inst.components.ndnr_bountytask:GetReward()

    if npc.components.talker then
        npc:StartThread(function()
            for k = 1, #TUNING.NDNR_BOUNTYTASK_DELIVERYWORDS do
                npc.components.talker:Say(TUNING.NDNR_BOUNTYTASK_DELIVERYWORDS[k])
                Sleep(2.5 + math.random() * .2)
            end
        end)
    end

    -- 2分钟不完成任务，连接超时，科学家与永恒大陆断开连接
    npc:DoTaskInTime(120, function(npc)
        inst:RemoveTag("ndnr_summoned")
        npc.components.talker:Say(TUNING.NDNR_BOUNTYTASK_TIMEOUT)
        npc:PushEvent("doerode", {
            time = 4.0,
            erodein = false,
            remove = true,
        })
    end)
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("ndnr_bounty")
    inst.AnimState:SetBuild("ndnr_bounty")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst:AddTag("ndnr_bounty")
    inst:AddTag("nobundling")

    inst.entity:SetPristine()
    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------

    -- inst:AddComponent("stackable")
	-- inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("ndnr_bountytask")
    inst.components.ndnr_bountytask:DeliveryTask(OnDeliveryTask)
    inst:AddComponent("inspectable")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

	MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_bounty.xml"

    inst:AddComponent("erasablepaper")
    inst.components.erasablepaper.erased_prefab = "waxpaper"

    return inst
end

return Prefab("ndnr_bounty", fn, assets)

