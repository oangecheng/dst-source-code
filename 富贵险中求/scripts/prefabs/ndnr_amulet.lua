local assets =
{
    -- Asset("ANIM", "anim/amulets.zip"),
    -- Asset("ANIM", "anim/torso_amulets.zip"),
    Asset("ANIM", "anim/ndnr_torso_amulets.zip"),
    Asset("ANIM", "anim/ndnr_amulets.zip"),

    Asset("IMAGE", "images/ndnr_opalpreciousamulet.tex"),
    Asset("ATLAS", "images/ndnr_opalpreciousamulet.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_opalpreciousamulet.xml", 256),
}

local function healowner(inst, owner)
    if (owner.components.health and owner.components.health:IsHurt() and not owner.components.oldager)
    and (owner.components.hunger and owner.components.hunger.current > 5 )then
        owner.components.health:DoDelta(TUNING.REDAMULET_CONVERSION,false,"ndnr_opalpreciousamulet")
        owner.components.hunger:DoDelta(-TUNING.REDAMULET_CONVERSION)
        -- inst.components.finiteuses:Use(1)
        inst.components.fueled:DoDelta(-9.6, owner) -- 2%
    end
end

local function onequip_red(inst, owner)
    -- local skin_build = inst:GetSkinBuild()
    -- if skin_build ~= nil then
    --     owner:PushEvent("equipskinneditem", inst:GetSkinName())
    --     owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "torso_amulets")
    -- else
    --     owner.AnimState:OverrideSymbol("swap_body", "torso_amulets", "redamulet")
    -- end

    inst.redtask = inst:DoPeriodicTask(30, healowner, nil, owner)
end

local function onunequip_red(inst, owner)
    -- if owner.sg == nil or owner.sg.currentstate.name ~= "amulet_rebirth" then
    --     owner.AnimState:ClearOverrideSymbol("swap_body")
    -- end

    -- local skin_build = inst:GetSkinBuild()
    -- if skin_build ~= nil then
    --     owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    -- end

    if inst.redtask ~= nil then
        inst.redtask:Cancel()
        inst.redtask = nil
    end
end

---GREEN

local function onequip_green(inst, owner)
    -- owner.AnimState:OverrideSymbol("swap_body", "torso_amulets", "greenamulet")
    owner.components.builder.ingredientmod = TUNING.GREENAMULET_INGREDIENTMOD
    inst.onitembuild = function()
        -- inst.components.finiteuses:Use(1)
        inst.components.fueled:DoDelta(-96, owner) -- 20%
    end
    inst:ListenForEvent("consumeingredients", inst.onitembuild, owner)
end

local function onunequip_green(inst, owner)
    -- owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.components.builder.ingredientmod = 1
    inst:RemoveEventCallback("consumeingredients", inst.onitembuild, owner)
end

---ORANGE
local ORANGE_PICKUP_MUST_TAGS = { "_inventoryitem" }
local ORANGE_PICKUP_CANT_TAGS = { "INLIMBO", "NOCLICK", "knockbackdelayinteraction", "catchable", "fire", "minesprung", "mineactive", "spider" }
local function pickup(inst, owner)
    if owner == nil or owner.components.inventory == nil then
        return
    end
    local x, y, z = owner.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, TUNING.ORANGEAMULET_RANGE, ORANGE_PICKUP_MUST_TAGS, ORANGE_PICKUP_CANT_TAGS)
    local ba = owner:GetBufferedAction()
    for i, v in ipairs(ents) do
        if v.components.inventoryitem ~= nil and
            v.components.inventoryitem.canbepickedup and
            v.components.inventoryitem.cangoincontainer and
            not v.components.inventoryitem:IsHeld() and
            owner.components.inventory:CanAcceptCount(v, 1) > 0 and
            (ba == nil or ba.action ~= ACTIONS.PICKUP or ba.target ~= v) then

            if owner.components.minigame_participator ~= nil then
                local minigame = owner.components.minigame_participator:GetMinigame()
                if minigame ~= nil then
                    minigame:PushEvent("pickupcheat", { cheater = owner, item = v })
                end
            end

            --Amulet will only ever pick up items one at a time. Even from stacks.
            SpawnPrefab("sand_puff").Transform:SetPosition(v.Transform:GetWorldPosition())

            -- inst.components.finiteuses:Use(1)
            inst.components.fueled:DoDelta(-9.6, owner) -- 2%

            local v_pos = v:GetPosition()
            -- if v.components.stackable ~= nil then
            --     v = v.components.stackable:Get()
            -- end

            if v.components.trap ~= nil and v.components.trap:IsSprung() then
                v.components.trap:Harvest(owner)
            else
                owner.components.inventory:GiveItem(v, nil, v_pos)
            end
            return
        end
    end
end

local function onequip_orange(inst, owner)
    -- owner.AnimState:OverrideSymbol("swap_body", "torso_amulets", "orangeamulet")
    inst.orangetask = inst:DoPeriodicTask(TUNING.ORANGEAMULET_ICD, pickup, nil, owner)
end

local function onunequip_orange(inst, owner)
    -- owner.AnimState:ClearOverrideSymbol("swap_body")
    if inst.orangetask ~= nil then
        inst.orangetask:Cancel()
        inst.orangetask = nil
    end
end

---YELLOW
local function onequip_yellow(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "ndnr_torso_amulets", "yellowamulet")

    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end

    if inst._light == nil or not inst._light:IsValid() then
        inst._light = SpawnPrefab("yellowamuletlight")
    end
    inst._light.entity:SetParent(owner.entity)

    if owner.components.bloomer ~= nil then
        owner.components.bloomer:PushBloom(inst, "shaders/anim.ksh", 1)
    else
        owner.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    end
    onequip_red(inst, owner)
    -- onequip_green(inst, owner)
    -- onequip_orange(inst, owner)

    owner:AddTag("fastpicker")
    owner:AddTag("quagmire_fasthands")
end

local function turnoff_yellow(inst, owner)
    if inst._light ~= nil then
        if inst._light:IsValid() then
            inst._light:Remove()
        end
        inst._light = nil
    end
end

local function onunequip_yellow(inst, owner)
    if owner.components.bloomer ~= nil then
        owner.components.bloomer:PopBloom(inst)
    else
        owner.AnimState:ClearBloomEffectHandle()
    end

    owner.AnimState:ClearOverrideSymbol("swap_body")

    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end

    turnoff_yellow(inst)

    onunequip_red(inst, owner)
    -- onunequip_green(inst, owner)
    -- onunequip_orange(inst, owner)

    owner:RemoveTag("fastpicker")
    owner:RemoveTag("quagmire_fasthands")
end

local function onfuelchanged_yellow(inst, data)
    if data and data.percent and data.oldpercent and data.percent > data.oldpercent then
        inst.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
    end
end

---COMMON FUNCTIONS
--[[
local function unimplementeditem(inst)
    local player = ThePlayer
    player.components.talker:Say(GetString(player, "ANNOUNCE_UNIMPLEMENTED"))
    if player.components.health.currenthealth > 1 then
        player.components.health:DoDelta(-0.5 * player.components.health.currenthealth)
    end

    if inst.components.useableitem then
        inst.components.useableitem:StopUsingItem()
    end
end
--]]

local function commonfn(anim, tag, should_sink)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("ndnr_amulets")
    inst.AnimState:SetBuild("ndnr_amulets")
    inst.AnimState:PlayAnimation(anim)

    if tag ~= nil then
        inst:AddTag(tag)
    end

    inst.foleysound = "dontstarve/movement/foley/jewlery"

    if not should_sink then
        MakeInventoryFloatable(inst, "med", nil, 0.6)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.NECK or EQUIPSLOTS.BODY
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
    inst.components.equippable.is_magic_dapperness = true

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_"..anim..".xml"
    inst.components.inventoryitem.imagename = "ndnr_"..anim
    if should_sink then
        inst.components.inventoryitem:SetSinks(true)
    end

    return inst
end

local function opalprecious()
    local inst = commonfn("opalpreciousamulet")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.equippable:SetOnEquip(onequip_yellow)
    inst.components.equippable:SetOnUnequip(onunequip_yellow)
    inst.components.equippable.walkspeedmult = 1.2
    inst.components.inventoryitem:SetOnDroppedFn(turnoff_yellow)

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.NIGHTMARE
    inst.components.fueled.bonusmult = 1/2
    inst.components.fueled:InitializeFuelLevel(TUNING.YELLOWAMULET_FUEL)
    inst.components.fueled:SetDepletedFn(inst.Remove)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
    inst.components.fueled.accepting = true
    inst:ListenForEvent("percentusedchange", onfuelchanged_yellow)

    MakeHauntableLaunch(inst)

    inst._light = nil
    inst.OnRemoveEntity = turnoff_yellow

    return inst
end

local function yellowlightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetRadius(2)
    inst.Light:SetFalloff(.7)
    inst.Light:SetIntensity(.65)
    inst.Light:SetColour(223 / 255, 208 / 255, 69 / 255)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

return Prefab("ndnr_opalpreciousamulet", opalprecious, assets, { "yellowamuletlight" })
