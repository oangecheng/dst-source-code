local assets =
{
    Asset("ANIM", "anim/lg_fruit_rack.zip"),
	Asset("ATLAS", "images/inventoryimages/lg_fruit_rack.xml"),
    Asset("IMAGE", "images/inventoryimages/lg_fruit_rack.tex")
}

local function onopen(inst)
    if not inst:HasTag("burnt") then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
    end
end

local function setdring(inst,drying)
    if drying then
        inst.components.container.canbeopened = false
        inst.components.preserver:SetPerishRateMultiplier(0) 
    else
        inst.components.container.canbeopened = true
        inst.components.preserver:SetPerishRateMultiplier(1)        
    end
end
--TUNING.PERISH_ONE_DAY
local mintime,maxtime = 1*TUNING.PERISH_ONE_DAY,6*TUNING.PERISH_ONE_DAY

local function onclose(inst)
    if not inst:HasTag("burnt") then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")

        local needtodried = false
        local container = inst.components.container
		for i = 1, container:GetNumSlots() do
            local item = container:GetItemInSlot(i)
            if item and not string.find(item.prefab,"dried") then
                needtodried = true
                break
            end
		end
        if needtodried then
            local time = 0
            local maxsize = 0
            for i = 1, container.numslots do
                local item = container.slots[i]
                if item ~= nil then
                    if  string.find(item.prefab,"dried") then
                        container:DropItemBySlot(i)
                    else
                        local stackable = item.components.stackable and item.components.stackable.stacksize or 1
                        time = math.max(time,stackable/item.components.stackable.maxsize * maxtime)
                        maxsize = math.max(maxsize,item.components.stackable.maxsize)
                    end
                end
            end
            time = Remap(time, 1/maxsize*maxtime, maxtime, mintime, maxtime)
            inst.components.timer:StartTimer("Dried",time)
            setdring(inst,true)
            inst.AnimState:PlayAnimation("idle")
        elseif not container:IsEmpty() then
            inst.AnimState:PlayAnimation("full")
        else
            inst.AnimState:PlayAnimation("empty")
        end
    end
end

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    inst.components.container:DropEverything()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)
    inst.components.container:DropEverything()
    setdring(inst,false)
    inst.AnimState:PlayAnimation("empty")
    if inst.components.timer:TimerExists("Dried") then
        inst.components.timer:StopTimer("Dried")
    end
end

local function OnTimerDone(inst, data)
    if data.name == "Dried" then
        local container = inst.components.container
		for i = 1, container:GetNumSlots() do
	        local item = container:GetItemInSlot(i)
	     	if item then 
                local stacksize = item.components.stackable ~= nil and item.components.stackable:StackSize() or 1
                local product = SpawnPrefab(string.find(item.prefab,"lg") and item.prefab.."_dried" or "lg_"..item.prefab.."_dried")
                item:Remove()
                if product then
                    if product.components.stackable then 
                        product.components.stackable:SetStackSize(stacksize)
                    end          
                end
                container:GiveItem(product, i)
		    end
		end   
        setdring(inst,false)
        if not container:IsEmpty() then
            inst.AnimState:PlayAnimation("full")
        else
            inst.AnimState:PlayAnimation("empty")
        end
    end
end
local function OnLoad(inst, data)
    if inst.components.timer:TimerExists("Dried") then
        setdring(inst,true)
        inst.AnimState:PlayAnimation("idle")   
    elseif not inst.components.container:IsEmpty() then
        inst.AnimState:PlayAnimation("full")
    else
        inst.AnimState:PlayAnimation("empty")
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("lg_fruit_rack")
    inst.AnimState:SetBuild("lg_fruit_rack")
    inst.AnimState:PlayAnimation("empty")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("tradable")

    inst:AddComponent("timer")

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("lg_fruit_rack")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(1)

    inst:ListenForEvent("timerdone", OnTimerDone)

    inst.OnLoad = OnLoad

    return inst
end

return Prefab("lg_fruit_rack", fn, assets),
    MakePlacer("lg_fruit_rack_placer", "lg_fruit_rack", "lg_fruit_rack", "empty")
