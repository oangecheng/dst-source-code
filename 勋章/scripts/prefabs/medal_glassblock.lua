local block_assets =
{
    Asset("ANIM", "anim/sand_block.zip"),
    Asset("ANIM", "anim/medal_block.zip"),
    Asset("ANIM", "anim/swap_medal_glass_block.zip"),
    Asset("ATLAS", "images/medal_glassblock.xml"),
	Asset("ATLAS_BUILD", "images/medal_glassblock.xml",256),
}
local function onequipblock(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "swap_medal_glass_block", "swap_body")
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
end

local function onworked(inst)
    inst.AnimState:PlayAnimation("block_glass_hit")
end

local function onworkfinished(inst,worker)
    inst:AddTag("NOCLICK")
    inst.Physics:SetActive(false)
    inst.OnEntitySleep = nil
    inst.OnEntityWake = nil
    inst:ListenForEvent("animover", ErodeAway)
    inst.AnimState:PlayAnimation("block_glass_break")
    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/glass_break")
    --玩家敲的才算哦
    if worker and worker:HasTag("player") then
        local pt = inst:GetPosition()
        --只有在时空风暴中敲了才能出碎片
        if TheWorld.net.components.medal_spacetimestorms ~= nil and TheWorld.net.components.medal_spacetimestorms:IsPointInSpacetimestorm(pt) then
            local devourer = TheWorld and TheWorld.components.medal_spacetimestormmanager and TheWorld.components.medal_spacetimestormmanager.st_devourer
            --碎片产量不能超过上限,上限=时空吞噬者饱食上限+基础上限
            if devourer and devourer.slider_num and devourer.slider_num < ((devourer.max_hungerrate or 0) + TUNING_MEDAL.MEDAL_SPACETIME_DEVOURER_SPAWN_MAX) then
                local chance = devourer.components.hunger and devourer.components.hunger:GetPercent()*0.5 or 0
                -- print(chance)
                if math.random() < chance then
                    local item = SpawnPrefab("medal_time_slider")
                    if item then
                        devourer.slider_num = devourer.slider_num + 1
                        item.Transform:SetPosition(pt:Get())
                        item.components.inventoryitem:OnDropped(true, .5)
                    end
                end
            end
        end
    end
end
--闪光
local function Sparkle(inst)
    if inst.sparkletask ~= nil then
        inst.sparkletask:Cancel()
    end
    if inst:IsAsleep() or inst.components.workable.workleft <= 0 then
        inst.sparkletask = nil
    else
        inst.sparkletask = inst:DoTaskInTime(4 + math.random() * 5, Sparkle)
        inst.AnimState:PushAnimation("block_glass_sparkle"..tostring(math.random(3)), false)
    end
end

local function OnEntitySleep(inst)
    if inst.sparkletask ~= nil then
        inst.sparkletask:Cancel()
        inst.sparkletask = nil
    end
end

local function OnEntityWake(inst)
    if inst.sparkletask == nil then
        inst.sparkletask = inst:DoTaskInTime(4 + math.random() * 5, Sparkle)
    end
end

local function MakeSpikeFn(shape, size)
    return function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst.animname = "block"
        inst.spikeradius = .45

        inst.AnimState:SetBank("sand_block")
        inst.AnimState:SetBuild("medal_block")
        inst.AnimState:PlayAnimation("block_glass_idle")

        inst:AddTag("heavy")

        MakeHeavyObstaclePhysics(inst, inst.spikeradius)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("heavyobstaclephysics")
        inst.components.heavyobstaclephysics:SetRadius(inst.spikeradius)

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = "medal_glassblock"
        inst.components.inventoryitem.atlasname = "images/medal_glassblock.xml"
        inst.components.inventoryitem.cangoincontainer = false

        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.BODY
        inst.components.equippable:SetOnUnequip(onunequip)
        inst.components.equippable.walkspeedmult = TUNING.HEAVY_SPEED_MULT

        inst.components.equippable:SetOnEquip(onequipblock)

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(10)
        inst.components.workable:SetOnWorkCallback(onworked)
		inst.components.workable:SetOnFinishCallback(onworkfinished)

		inst:AddComponent("submersible")
		inst:AddComponent("symbolswapdata")
        inst.components.symbolswapdata:SetData("swap_medal_glass_block", "swap_body")

        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

        inst.sparkletask = nil

        inst.Sparkle = Sparkle
        inst.OnEntitySleep = OnEntitySleep
        inst.OnEntityWake = OnEntityWake

        return inst
    end
end

return Prefab("medal_glassblock", MakeSpikeFn("block"), block_assets, { "underwater_salvageable" })
