local assets =
{
    Asset("ANIM", "anim/ndnr_hambat.zip"),
    Asset("ANIM", "anim/swap_ndnr_hambat.zip"),

    Asset("ANIM", "anim/ndnr_hambat_together.zip"),

    Asset("IMAGE", "images/ndnr_hambat.tex"),
    Asset("ATLAS", "images/ndnr_hambat.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_hambat.xml", 256),

    Asset("ATLAS", "images/ndnr_hambat_betogether.xml"),
    Asset("IMAGE", "images/ndnr_hambat_betogether.tex"),
}

local legion_foliageath_data_assets =   -- 兼容棱镜的青枝绿叶
{
    -- 物品栏贴图
    atlas = "images/ndnr_hambat_betogether.xml",
    image = "ndnr_hambat_betogether",
    -- 地面物品贴图
    bank = "ndnr_hambat_together",
    build = "ndnr_hambat_together",
    anim = "idle_cover",
    isloop = false,
    -- 每两秒回复一秒的耐久
    --[[
    fn_recover = function (inst, dt)
        if inst.components.finiteuses:GetPercent() >= 1 then
            return
        end
    
        local value = dt * 250/(TUNING.TOTAL_DAY_TIME*3) --后面一截是每秒该恢复多少耐久
        if value >= 1 then
            value = math.floor(value)
        else
            return
        end
    
        local newvalue = inst.components.finiteuses:GetUses() + value
        newvalue = math.min(250, newvalue)
        inst.components.finiteuses:SetUses(newvalue)
    
        if inst.hasSetBroken then
            inst.hasSetBroken = false
    
            inst.components.weapon:SetDamage(55)
            inst.components.weapon:SetOnAttack(onattack)
    
            ChangeInvImg(inst, inst.components.skinedlegion:GetSkinedData())
        end
    end
    ]]
}

local function UpdateDamage(inst)
    local perishremainingtime = inst.components.perishable.perishremainingtime
    local perishtime = inst.components.perishable.perishtime
    inst.components.perishable.perishremainingtime = math.min(perishremainingtime + 2, perishtime)

    if inst.components.perishable and inst.components.weapon then
        local dmg = TUNING.NIGHTSWORD_DAMAGE * inst.components.perishable:GetPercent()
        dmg = Remap(dmg, 0, TUNING.NIGHTSWORD_DAMAGE, TUNING.HAMBAT_MIN_DAMAGE_MODIFIER*TUNING.NIGHTSWORD_DAMAGE, TUNING.NIGHTSWORD_DAMAGE)
        inst.components.weapon:SetDamage(dmg)
    end
end

local function OnLoad(inst, data)
    UpdateDamage(inst)
end

local function onequip(inst, owner)
    UpdateDamage(inst)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_ndnr_hambat", inst.GUID, "swap_ndnr_hambat")
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_ndnr_hambat", "swap_ndnr_hambat")
    end

    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    UpdateDamage(inst)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
end

local function cancelexperimenttask(inst)
    if inst.ndnr_experimenttask ~= nil then
        inst.ndnr_experimenttask:Cancel()
        inst.ndnr_experimenttask = nil
    end
end

local function shadowhambattask(inst)
    local owner = inst.components.inventoryitem.owner
    local owner_owner = owner and owner.components.inventoryitem and owner.components.inventoryitem.owner or nil

    local _owner = nil
    if owner ~= nil and owner:HasTag("player") and not owner:HasTag("playerghost") then
        _owner = owner
    elseif owner_owner ~= nil and owner_owner:HasTag("player") and not owner_owner:HasTag("playerghost") then
        _owner = owner_owner
    end

    if _owner ~= nil then
        if inst.ndnr_owner ~= nil and _owner ~= inst.ndnr_owner then cancelexperimenttask(inst) end
        inst.ndnr_owner = _owner
        if inst.ndnr_experimenttask == nil then
            if _owner.components.health ~= nil then
                inst.ndnr_experimenttask = inst:DoPeriodicTask(2, function(inst)
                    if inst.components.perishable ~= nil and inst.ndnr_hungry == true then
                        if _owner.prefab == "wanda" then
                            _owner.components.health:DoDelta(-1*_owner.resurrect_multiplier, nil, "ndnr_hambat", nil, nil, true)
                        else
                            _owner.components.health:DoDelta(-1, nil, "ndnr_hambat", nil, nil, true)
                        end
                        if inst.components.perishable:GetPercent() >= 1 then
                            inst.ndnr_hungry = false
                        end
                        local perishremainingtime = inst.components.perishable.perishremainingtime
                        inst.components.perishable.perishremainingtime = perishremainingtime + 12 --2正好持平 12大约需要50血恢复满新鲜度
                    end
                end)
            end
        end
    else
        cancelexperimenttask(inst)
    end
end

local function topocket(inst)
    shadowhambattask(inst)
end

-- 仅对扔地上有效
local function toground(inst)
    cancelexperimenttask(inst)
end

local function onperishchange(inst, data)
    if inst.ndnr_hungry == nil then inst.ndnr_hungry = false end
    if data.percent < 0.9 then -- 每次到需要吸血时，需要大约160血才能喂饱
        inst.ndnr_hungry = true
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("ndnr_hambat")
    inst.AnimState:SetBuild("ndnr_hambat")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("show_spoilage")
    inst:AddTag("icebox_valid")
    inst:AddTag("shadow_item")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.foliageath_data = legion_foliageath_data_assets

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.NIGHTSWORD_DAMAGE)
    inst.components.weapon:SetOnAttack(UpdateDamage)

    inst:AddComponent("forcecompostable")
    inst.components.forcecompostable.green = true

    inst.OnLoad = OnLoad

    -------
    --[[
    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.healthvalue = -TUNING.HEALING_MEDSMALL
    inst.components.edible.hungervalue = TUNING.CALORIES_MED
    inst.components.edible.sanityvalue = -TUNING.SANITY_MED
    --]]

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/ndnr_hambat.xml"

    MakeHauntableLaunchAndPerish(inst)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.dapperness = TUNING.CRAZINESS_MED
    inst.components.equippable.is_magic_dapperness = true

    inst:ListenForEvent("perishchange", onperishchange)
    inst:ListenForEvent("onputininventory", topocket)
    inst:ListenForEvent("ondropped", toground)

    inst:DoTaskInTime(FRAMES, shadowhambattask)

    return inst
end

return Prefab( "ndnr_hambat", fn, assets)