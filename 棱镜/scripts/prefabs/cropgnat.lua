local assets = {
    Asset("ANIM", "anim/gnat.zip"), --官方单机哈姆雷特虫群动画模板
    Asset("ANIM", "anim/swap_cropgnat_fly.zip")
}

local prefabs = {
    "ahandfulofwings"
}

local brain = require("brains/cropgnatbrain")
local brain_infester = require("brains/cropgnat_infesterbrain")

local sounds = {
    attack = "legion/gnat/attack",
    buzz = "legion/gnat/loop",
    hit = "legion/gnat/hit",
    death = "legion/gnat/die",
}

--[[
SetSharedLootTable('raindonate',
{
    {'mosquitosack', .5},
})
--]]

-- local function OnWorked(inst, worker)
--     local owner = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
--     if owner ~= nil and owner.components.childspawner ~= nil then   --通知“home”,自己被抓/死了
--         owner.components.childspawner:OnChildKilled(inst)
--     end
--     if worker.components.inventory ~= nil then
--         worker.components.inventory:GiveItem(inst, nil, inst:GetPosition())
--     end
-- end

local function StartBuzz(inst)  --玩家靠近时开始扇翅膀声
    inst.SoundEmitter:PlaySound(inst.sounds.buzz, "buzz")
end

local function StopBuzz(inst)   --玩家离开时停止扇翅膀声
    inst.SoundEmitter:KillSound("buzz")
end

local function MakeGnat(name, isinfester)
    local function Fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddLightWatcher()
        inst.entity:AddDynamicShadow()
        inst.entity:AddNetwork()

        MakeFlyingCharacterPhysics(inst, 1, 0.25)
        inst.DynamicShadow:SetSize(2, 0.6)
        inst.Transform:SetFourFaced()

        inst:AddTag("insect")   --昆虫标签
        inst:AddTag("flying")
        inst:AddTag("smallcreature")
        inst:AddTag("hostile")
        -- inst:AddTag("no_durability_loss_on_hit") --单机版才有的标签，被打之后不会减少武器耐久
        inst:AddTag("ignorewalkableplatformdrowning")
        inst:AddTag("gnat_l")

        inst.AnimState:SetBank("gnat")
        inst.AnimState:SetBuild("gnat")
        inst.AnimState:PlayAnimation("idle_loop", true)
        inst.AnimState:SetRayTestOnBB(true) --可点击范围变大？

        if isinfester then
            inst.AnimState:OverrideSymbol("fly_01", "swap_cropgnat_fly", "infester")
            inst.AnimState:SetMultColour(1, 0.85, 0.79, 1)
        else
            inst.AnimState:OverrideSymbol("fly_01", "swap_cropgnat_fly", "normal")
            -- inst.AnimState:SetMultColour(0.7, 1, 0.8, 1) --本身就是偏绿色的，不用再加绿色滤镜了
        end

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("locomotor") --速度组件一定要写在sg声明之前
        inst.components.locomotor:EnableGroundSpeedMultiplier(false)
        inst.components.locomotor:SetTriggersCreep(false)
        inst.components.locomotor.walkspeed = 2    --苍蝇是8
        inst.components.locomotor.runspeed = 6 --苍蝇是12

        inst:SetStateGraph("SGcropgnat")

        ------------------

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot({"ahandfulofwings"})

        ------------------

        -- inst:AddComponent("workable")
        -- inst.components.workable:SetWorkAction(ACTIONS.NET) --用网捕捉
        -- inst.components.workable:SetWorkLeft(1)
        -- inst.components.workable:SetOnFinishCallback(OnWorked) --能在刚好处于攻击状态时或者被冻住时被捕捉到

        ------------------

        inst:AddComponent("health")
        inst.components.health:SetInvincible(true)  --无敌的！只有特定方式才能杀死它

        ------------------

        inst:AddComponent("combat")
        inst.components.combat.hiteffectsymbol = "fx_puff"
        inst.components.combat:SetDefaultDamage(5) --苍蝇是3
        inst.components.combat:SetRange(0.8)  --苍蝇是1.75
        inst.components.combat:SetAttackPeriod(16)
        inst.components.combat.noimpactsound = true --被攻击没有挨打声音，因为设定上是没有打中
        -- inst.components.combat:SetPlayerStunlock(PLAYERSTUNLOCK.RARELY)

        ------------------

        inst:AddComponent("sanityaura")
        inst.components.sanityaura.aura = -TUNING.SANITYAURA_SMALL

        ------------------

        -- inst:AddComponent("sleeper") --本身并没有睡觉组件，睡觉机制由brain和sg控制
        inst:AddComponent("knownlocations")
        inst:AddComponent("inspectable")

         -- MakeSmallBurnableCharacter(inst, "body", Vector3(0, -1, 1)) --不会着火
        MakeTinyFreezableCharacter(inst, "fx_puff")
        MakeHauntablePanic(inst)

        inst.sounds = sounds
        inst.OnEntityWake = StartBuzz
        inst.OnEntitySleep = StopBuzz

        inst:ListenForEvent("freeze", function()
            if inst.components.freezable then
                inst.components.health.invincible = false
                inst.components.combat.noimpactsound = nil
                inst.SoundEmitter:KillSound("buzz")
            end
        end)

        inst:ListenForEvent("unfreeze", function()
            if inst.components.freezable then
                inst.components.health.invincible = true
                inst.components.combat.noimpactsound = true
                inst.SoundEmitter:PlaySound(inst.sounds.buzz, "buzz")
            end
        end)

        inst:WatchWorldState("startcaveday", function(inst)
            if inst.brain ~= nil then --因不明原因脑子在天亮时会被停掉，所以这里强制继续，为了避免脑子停转但会一直追逐玩家的情况
                inst.brain:Start()
            end
        end)

        inst:ListenForEvent("death", function()
            if inst.infesttarget ~= nil then
                inst.infesttarget.infester = nil --清除以前的标记
                inst.infesttarget = nil
            end
            inst.lighttarget = nil
        end)

        if isinfester then
            inst:SetBrain(brain_infester)

            inst.components.health:SetMaxHealth(350)    --苍蝇是100

            inst.components.combat:SetKeepTargetFunction(function(inst, target)
                return inst.components.combat:CanTarget(target)
            end)
            -- inst.components.combat:SetRetargetFunction(10, function(inst) end) --这里并不会主动攻击，会在brain里设置攻击对象
        else
            inst:SetBrain(brain)

            inst.components.health:SetMaxHealth(150)

            inst.components.combat:SetKeepTargetFunction(function(inst, target) return false end) --用来在有target时不睡觉
            -- inst.components.combat:SetRetargetFunction(10, function(inst) end)

            inst:AddComponent("timer")
            inst.OnInfestPlant = function(inst, plant)
                if plant.components.perennialcrop ~= nil then
                    if not plant.components.perennialcrop:Infest(inst, 1) then
                        plant.infester = nil
                        inst.infesttarget = nil
                    end
                elseif plant.components.perennialcrop2 ~= nil then
                    if not plant.components.perennialcrop2:Infest(inst, 1) then
                        plant.infester = nil
                        inst.infesttarget = nil
                    end
                elseif plant.components.pickable ~= nil then
                    if plant.components.pickable:CanBeFertilized() then --已经枯萎/贫瘠了
                        plant.infest_l_times = nil
                        plant.infester = nil
                        inst.infesttarget = nil
                    else
                        if plant.infest_l_times == nil then
                            plant.infest_l_times = 1
                        else
                            plant.infest_l_times = plant.infest_l_times + 1
                            if plant.infest_l_times >= 6 then --达到了侵害次数（侵害次数懒得做保存机制了）
                                plant.components.pickable:MakeBarren()
                                plant.infest_l_times = nil
                                plant.infester = nil
                                inst.infesttarget = nil
                            end
                        end
                    end
                end
                inst.components.timer:StartTimer("infest_cd", TUNING.SEG_TIME * 2) --重新开始侵扰计时
            end
        end

        return inst
    end

    return Prefab(name, Fn, assets, prefabs)
end

return MakeGnat("cropgnat", false),             --只叮咬作物的类型
        MakeGnat("cropgnat_infester", true)     --只侵扰生物的类型
