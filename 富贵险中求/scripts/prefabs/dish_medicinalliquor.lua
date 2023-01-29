local assets = {
    Asset("ANIM", "anim/cook_pot_food.zip"),
    Asset("ANIM", "anim/ndnr_cook_pot_food.zip"),
    Asset("ANIM", "anim/dish_medicinalliquor.zip"),
    Asset("ATLAS", "images/dish_medicinalliquor.xml"),
    Asset("IMAGE", "images/dish_medicinalliquor.tex"),
    Asset("ATLAS_BUILD", "images/dish_medicinalliquor.xml", 256),
}

local function item_oneaten(inst, eater)
    if eater:HasTag("player") then
        --说醉酒话
        if eater.components.talker ~= nil then
            eater.components.talker:Say(TUNING.NDNR_DISH_MEDICINALLIQUOR_DRUNK)
        end

        --加强攻击力
        if eater.components.combat ~= nil then --这个buff需要攻击组件
            eater.components.debuffable:AddDebuff("buff_strengthenhancerdebuff", "buff_strengthenhancerdebuff")
        end

        local drunkmap = {
            wathgrithr = 0,
            wolfgang = 0,
            wendy = 1,
            webber = 1,
            willow = 1,
            wes = 1,
            wormwood = 1,
            wurt = 1,
            walter = 1,
            yangjian = 0,
            yama_commissioners = 0,
            myth_yutu = 1,
        }
        if drunkmap[eater.prefab] == 0 then --没有任何事
            return
        elseif drunkmap[eater.prefab] == 1 then --直接睡着8-12秒
            eater:PushEvent("yawn", { grogginess = 5, knockoutduration = 8+math.random()*4 })
        else --20-28秒内减速
            if eater.groggy_time ~= nil then
                eater.groggy_time:Cancel()
                eater.groggy_time = nil
            end
            if eater.components.locomotor ~= nil then
                eater:AddTag("groggy")  --添加标签，走路会摇摇晃晃
                eater.components.locomotor:SetExternalSpeedMultiplier(eater, "grogginess", 0.4)

                eater.groggy_time = eater:DoTaskInTime(20+math.random()*8, function()
                    if eater ~= nil and eater.components.locomotor ~= nil then
                        eater:RemoveTag("groggy")
                        eater.components.locomotor:RemoveExternalSpeedMultiplier(eater, "grogginess")
                        eater.groggy_time = nil
                    end
                end)
            end
        end
    elseif eater.components.sleeper ~= nil then
        eater.components.sleeper:AddSleepiness(5, 12+math.random()*4)
    elseif eater.components.grogginess ~= nil then
        eater.components.grogginess:AddGrogginess(5, 12+math.random()*4)
    else
        eater:PushEvent("knockedout")
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("cook_pot_food")
    inst.AnimState:SetBank("cook_pot_food")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:OverrideSymbol("swap_food", "ndnr_cook_pot_food", "dish_medicinalliquor")

    inst:AddTag("preparedfood")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 8
    inst.components.edible.hungervalue = 9.375
    inst.components.edible.sanityvalue = 10
    inst.components.edible.foodtype = FOODTYPE.GOODIES
    inst.components.edible:SetOnEatenFn(item_oneaten)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/dish_medicinalliquor.xml"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndPerish(inst)

    inst:AddComponent("bait")
    inst:AddComponent("tradable")

    return inst
end

return Prefab("dish_medicinalliquor", fn, assets)