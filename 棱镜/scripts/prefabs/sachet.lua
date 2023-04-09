local assets =
{
    Asset("ANIM", "anim/sachet.zip"),
	Asset("ATLAS", "images/inventoryimages/sachet.xml"),
    Asset("IMAGE", "images/inventoryimages/sachet.tex"),
}

local prefabs =
{
    "butterfly",
}

local function CreateSanityAura() --抄的大佬的代码
	local inst = CreateEntity()
	inst.entity:AddTransform()

    inst:AddTag("NOBLOCK")
    inst:AddTag("flower")

	inst:AddComponent('sanityaura')
	inst.components.sanityaura.aura = TUNING.SANITYAURA_SMALL --和猪人一样的精神光环

	inst.persists = false

	return inst
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "sachet", "swap_body")

    if owner:HasTag("equipmentmodel") then --假人！
        return
    end

    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end

    -- owner:AddComponent("sanityaura")
    if owner.ent_sanityaura_sachet == nil then
        owner.ent_sanityaura_sachet = CreateSanityAura()
	    owner.ent_sanityaura_sachet.entity:SetParent(owner.entity)
    end

    inst.updatetask = inst:DoPeriodicTask(5, function()
        if not TheWorld.state.iswinter and TheWorld.state.isday then
            if not owner:IsValid() then
                inst.updatetask:Cancel()
                inst.updatetask = nil
                return
            end
            local x,y,z = owner.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x,y,z, 6, {"flower"})
            for _,v in ipairs(ents) do
                if math.random() < 0.1 then
                    local fly = SpawnPrefab("butterfly")

                    if fly.components.pollinator ~= nil then
                        fly.components.pollinator:Pollinate(v)
                    end
                    fly.components.homeseeker:SetHome(owner)
                    -- KAJ: TODO: Butterflies can be despawned before getting to the rest of the logic if this is above the homeseeker
                    fly.Physics:Teleport(v.Transform:GetWorldPosition())
                end
            end
        end
    end, 1)

    owner:RemoveTag("scarytoprey")  --去除这个标签后，小生物不再会主动远离玩家
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")

    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end

    -- owner:RemoveComponent("sanityaura")
    if owner.ent_sanityaura_sachet ~= nil then
        owner.ent_sanityaura_sachet:Remove()
        owner.ent_sanityaura_sachet = nil
    end

    if inst.updatetask ~= nil then
        inst.updatetask:Cancel()
        inst.updatetask = nil
    end

    owner:AddTag("scarytoprey")
end

-----------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("sachet")
    inst.AnimState:SetBuild("sachet")
    inst.AnimState:PlayAnimation("anim")

    MakeInventoryFloatable(inst, "small", 0.2, 0.8)
    local OnLandedClient_old = inst.components.floater.OnLandedClient
    inst.components.floater.OnLandedClient = function(self)
        OnLandedClient_old(self)
        self.inst.AnimState:SetFloatParams(0.03, 1, self.bob_percent)
    end

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "sachet"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/sachet.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY --EQUIPSLOTS.NECK
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_HUGE /2 *1.5  -- +15精神/分钟
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.SPIDERHAT_PERISHTIME)    --2分钟的佩戴时间
    inst.components.fueled:SetDepletedFn(inst.Remove)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("sachet", fn, assets, prefabs)
