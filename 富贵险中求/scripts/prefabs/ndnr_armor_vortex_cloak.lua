local assets=
{
	Asset("ANIM", "anim/ndnr_armor_vortex_cloak.zip"),
    Asset("ANIM", "anim/cloak_fx.zip"),
    Asset("IMAGE", "images/ndnr_armorvortexcloak.tex"),
    Asset("ATLAS", "images/ndnr_armorvortexcloak.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_armorvortexcloak.xml", 256),
    -- Asset("MINIMAP_IMAGE", "armor_vortex_cloak"),
}

local function setsoundparam(inst)
    local param = Remap(inst.components.armor.condition, 0, inst.components.armor.maxcondition,0, 1 )
    inst.SoundEmitter:SetParameter( "vortex", "intensity", param )
end

local function spawnwisp(owner)
    local wisp = SpawnPrefab("ndnr_armorvortexcloak_fx")
    local x,y,z = owner.Transform:GetWorldPosition()
    -- wisp.Transform:SetPosition(x+math.random()*0.25 -0.25/2,y,z+math.random()*0.25 -0.25/2)
    wisp.Transform:SetPosition(x,y,z)
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "ndnr_armor_vortex_cloak", "swap_body")
    -- owner.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/vortex_armour/equip_off")
    local function OnBlocked(inst, damage_amount)
        if inst.components.armor.condition and inst.components.armor.condition > 0 then
            owner:AddChild(SpawnPrefab("ndnr_vortex_cloak_fx"))
        end
        if owner.components.sanity then
            local sanitydamage = math.max(damage_amount * 0.3, 1)
            owner.components.sanity:DoDelta(-sanitydamage)
        end
        setsoundparam(inst)
    end
    inst.OnBlocked = OnBlocked

  --  inst:ListenForEvent("blocked", inst.OnBlocked, owner) -- function(inst,data) OnBlocked(owner,inst) end
  --  inst:ListenForEvent("attacked", inst.OnBlocked, owner)      -- function(inst,data) OnBlocked(owner,inst) end
    inst:ListenForEvent("armordamaged", inst.OnBlocked)

    owner:AddTag("not_hit_stunned")
    -- owner.components.inventory:SetOverflow(inst)
    inst.components.container:Open(owner)
    inst.wisptask = inst:DoPeriodicTask(0.1,function() spawnwisp(owner) end)

    -- inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/vortex_armour/LP","vortex")
    setsoundparam(inst)

    if inst.components.fueled then
        inst.components.fueled.accepting = true
    end
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    -- owner.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/vortex_armour/equip_on")
 --   inst:RemoveEventCallback("blocked", inst.OnBlocked, owner)
 --   inst:RemoveEventCallback("attacked", inst.OnBlocked, owner)
    inst:RemoveEventCallback("armordamaged", inst.OnBlocked)
    owner:RemoveTag("not_hit_stunned")
    -- owner.components.inventory:SetOverflow(nil)
    inst.components.container:Close(owner)
    if inst.wisptask then
        inst.wisptask:Cancel()
        inst.wisptask= nil
    end

    -- inst.SoundEmitter:KillSound("vortex")

    if inst.components.fueled then
        inst.components.fueled.accepting = false
    end
end

local function nofuel(inst)

end

local function ontakefuel(inst)
    if inst.components.armor.condition and inst.components.armor.condition < 0 then
        inst.components.armor:SetCondition(0)
    end
    inst.components.armor:SetCondition( math.min( inst.components.armor.condition + (inst.components.armor.maxcondition/20), inst.components.armor.maxcondition) )
    local owner = inst.components.inventoryitem.owner
    if owner then
        owner.components.sanity:DoDelta(-TUNING.SANITY_TINY)
    end
    -- GetPlayer().SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/vortex_armour/add_fuel")
end

local function fn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("ndnr_armorvortexcloak.tex")

    inst:AddTag("vortex_cloak")
    inst:AddTag("ndnr_refine")

    inst.AnimState:SetBank("ndnr_armor_vortex_cloak")
    inst.AnimState:SetBuild("ndnr_armor_vortex_cloak")
    inst.AnimState:PlayAnimation("anim")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("krampus_sack") end
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false
    inst.components.inventoryitem.atlasname = "images/ndnr_armorvortexcloak.xml"
    -- inst.components.inventoryitem.foleysound = "dontstarve_DLC003/common/crafted/vortex_armour/foley"
	--inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/marblearmour"

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("krampus_sack")
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.NIGHTMARE
    inst.components.fueled:InitializeFuelLevel(4 * TUNING.LARGE_FUEL)
    inst.components.fueled.ontakefuelfn = ontakefuel
    inst.components.fueled.accepting = false

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    --inst.components.equippable.dapperness = TUNING.CRAZINESS_MED

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.WILSON_HEALTH*3, 1)
    inst.components.armor.ndnr_immunetags = {"shadow", "shadowchesspiece"}
    -- inst.components.armor.dontremove = true
    -- inst.components.armor:SetImmuneTags({"shadow"})
    -- inst.components.armor.bonussanitydamage = 0.3

    return inst
end

local function fxfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("cloakfx")
    inst.AnimState:SetBuild("cloak_fx")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("fx")

    for i=1,14 do
        inst.AnimState:Hide("fx"..i)
    end
    inst.AnimState:Show("fx"..math.random(1,14))

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst:ListenForEvent("animover", function() inst:Remove() end)

    return inst
end

return Prefab("ndnr_armorvortexcloak", fn, assets),
        Prefab("ndnr_armorvortexcloak_fx", fxfn, assets)
