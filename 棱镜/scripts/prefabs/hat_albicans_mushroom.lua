local assets =
{
    Asset("ANIM", "anim/hat_albicans_mushroom.zip"),
	Asset("ATLAS", "images/inventoryimages/hat_albicans_mushroom.xml"),   --物品栏图片
    Asset("IMAGE", "images/inventoryimages/hat_albicans_mushroom.tex"),
}

local prefabs =
{
    "escapinggerms_fx",
    "residualspores_fx",
    "buff_sporeresistance",
    "albicanscloud_fx",
    "albicans_cap",
    "spore_small",
    "spore_medium",
    "spore_tall",
}

local function onequip(inst, owner)
    HAT_L_ON(inst, owner, "hat_albicans_mushroom", "swap_hat")

    inst.components.periodicspawner:Start()

    if owner:HasTag("equipmentmodel") then --假人！
        return
    end

    if owner.components.hunger ~= nil then
        owner.components.hunger.burnratemodifiers:SetModifier(inst, TUNING.ARMORSLURPER_SLOW_HUNGER) --0.6的饥饿速度
    end
end
local function onunequip(inst, owner)
    HAT_L_OFF(inst, owner)

    inst.components.periodicspawner:Stop()

    if owner.components.hunger ~= nil then
        owner.components.hunger.burnratemodifiers:RemoveModifier(inst)
    end
end

local function onuse(inst)
    local owner = inst.components.inventoryitem.owner
    if owner ~= nil then
    	if owner.components.hunger ~= nil and owner.components.hunger.current < 30 then
    		if owner.components.talker ~= nil then
                owner.components.talker:Say(GetString(owner, "DESCRIBE", { "HAT_ALBICANS_MUSHROOM", "HUNGER" }))
            end
            -- inst.components.useableitem:StopUsingItem() --此时已经是使用中了，需要还原使用状态
            return false --onuse()如果返回false的话，就能还原使用状态
    	end

        owner.sg:GoToState("release_spores", inst)
    end
end

local function ReleaseSporesEffect(inst, owner)
    local x, y, z = owner.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 3.5,
        nil,
        { "DECOR", "NOCLICK", "FX", "shadow", "playerghost", "INLIMBO" },
        { "player", "lamp", "mushroom_farm", "crop_legion", "crop2_legion" }
    )

    for i, ent in pairs(ents) do
        if ent ~= nil and ent:IsValid() and ent.entity:IsVisible() then
            if ent:HasTag("player") then
                ent.time_l_sporeresistance = { add = TUNING.SEG_TIME*6, max = TUNING.SEG_TIME*30 }
                ent:AddDebuff("buff_sporeresistance", "buff_sporeresistance")
            elseif ent.prefab == "mushroom_light2" then
                if ent.components.container ~= nil then
                    local numitems = ent.components.container:NumItems()
                    local numslots = ent.components.container:GetNumSlots()
                    if numitems < numslots then
                        local num = numslots - numitems
                        for i = 1, num do
                            local spore = SpawnPrefab(GetRandomItem({
                                "spore_small",
                                "spore_medium",
                                "spore_tall",
                            }))
                            if spore ~= nil then
                                ent.components.container:GiveItem(spore)
                            end
                        end
                    end
                end
            elseif ent.prefab == "mushroom_farm" then
                if ent.components.trader ~= nil and ent.components.trader.enabled and ent.remainingharvests ~= 0 then
                    local item = SpawnPrefab(GetRandomItem({
                        "spore_small",
                        "spore_medium",
                        "spore_tall",
                        "albicans_cap",
                    }))
                    if item ~= nil then
                        local result = ent.components.trader:AcceptGift(owner, item)
                        if not result and item:IsValid() then
                            item:Remove()
                        end
                    end
                end
            elseif ent.components.perennialcrop ~= nil then
                ent.components.perennialcrop:Cure(owner)
            elseif ent.components.perennialcrop2 ~= nil then
                ent.components.perennialcrop2:Cure(owner)
            end
    	end
    end

    if owner.components.hunger ~= nil then
        owner.components.hunger:DoDelta(-30)
    end

    if owner.components.lootdropper ~= nil then
        local num = math.random(2, 5)
        for i = 1, num do
            owner.components.lootdropper:SpawnLootPrefab(GetRandomItem({
                "spore_small",
                "spore_medium",
                "spore_tall",
            }))
        end
    end
end

-----------------------------------

local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hat_albicans_mushroom")
    inst.AnimState:SetBuild("hat_albicans_mushroom")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("hat")
    inst:AddTag("show_spoilage")
    inst:AddTag("icebox_valid")
    inst:AddTag("rp_fungus_l")

    --waterproofer (from waterproofer component) added to pristine state for optimization
    inst:AddTag("waterproofer")

    MakeInventoryFloatable(inst, "med", 0.25, 0.8)
    local OnLandedClient_old = inst.components.floater.OnLandedClient
    inst.components.floater.OnLandedClient = function(self)
        OnLandedClient_old(self)
        self.inst.AnimState:SetFloatParams(0.045, 1, self.bob_percent)
    end

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.releasedfn = ReleaseSporesEffect --存下来，在sg中调用
    inst.fxcolour = {255/255, 255/255, 255/255}
    inst.castsound = "dontstarve/pig/mini_game/cointoss"

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "hat_albicans_mushroom"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hat_albicans_mushroom.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("tradable")

    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(TUNING.INSULATION_SMALL) --凉爽60s
    inst.components.insulator:SetSummer()

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW) --15天新鲜度
    inst.components.perishable:StartPerishing()
    inst.components.perishable:SetOnPerishFn(inst.Remove)

    inst:AddComponent("useableitem")
    inst.components.useableitem:SetOnUseFn(onuse)
    -- inst.components.useableitem:SetOnStopUseFn(onstopuse)

    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetPrefab(function(inst)
        local spores =
        {
            "spore_tall",
            "spore_medium",
            "spore_small"
        }
        return spores[math.random(1, 3)]
    end)
    inst.components.periodicspawner:SetRandomTimes(TUNING.SEG_TIME * 2 / 3, 1, true)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab( "hat_albicans_mushroom", fn, assets, prefabs)
