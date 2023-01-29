local BALLOONS = require "prefabs/balloons_common"

local function MakeHat(name)
    local fname = "hat_ndnr_"..name
    local symname = name.."hat"
    local prefabname = "ndnr_"..symname

    --If you want to use generic_perish to do more, it's still
    --commented in all the relevant places below in this file.
    --[[local function generic_perish(inst)
        inst:Remove()
    end]]

    local swap_data = { bank = symname, anim = "anim" }

	-- do not pass this function to equippable:SetOnEquip as it has different a parameter listing
    local function _onequip(inst, owner, symbol_override)

        local skin_build = inst:GetSkinBuild()
        if skin_build ~= nil then
            owner:PushEvent("equipskinneditem", inst:GetSkinName())
            owner.AnimState:OverrideItemSkinSymbol("swap_hat", skin_build, symbol_override or "swap_hat", inst.GUID, fname)
        else
            owner.AnimState:OverrideSymbol("swap_hat", fname, symbol_override or "swap_hat")
        end
        owner.AnimState:Show("HAT")
        owner.AnimState:Show("HAIR_HAT")
        owner.AnimState:Hide("HAIR_NOHAT")
        owner.AnimState:Hide("HAIR")

        if owner:HasTag("player") then
            owner.AnimState:Hide("HEAD")
            owner.AnimState:Show("HEAD_HAT")
        end

        if inst.components.fueled ~= nil then
            inst.components.fueled:StartConsuming()
        end
    end

    local function _onunequip(inst, owner)
        local skin_build = inst:GetSkinBuild()
        if skin_build ~= nil then
            owner:PushEvent("unequipskinneditem", inst:GetSkinName())
        end

        owner.AnimState:ClearOverrideSymbol("swap_hat")
        owner.AnimState:Hide("HAT")
        owner.AnimState:Hide("HAIR_HAT")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")

        if owner:HasTag("player") then
            owner.AnimState:Show("HEAD")
            owner.AnimState:Hide("HEAD_HAT")
        end

        if inst.components.fueled ~= nil then
            inst.components.fueled:StopConsuming()
        end
    end

    local function generic_perish(inst)
		inst:Remove()
	end

	local function simple_onequip(inst, owner, from_ground)
		_onequip(inst, owner)
	end

	local function simple_onunequip(inst, owner, from_ground)
		_onunequip(inst, owner)
	end
    local function opentop_onequip(inst, owner)

        local skin_build = inst:GetSkinBuild()
        if skin_build ~= nil then
            owner:PushEvent("equipskinneditem", inst:GetSkinName())
            owner.AnimState:OverrideItemSkinSymbol("swap_hat", skin_build, "swap_hat", inst.GUID, fname)
        else
            owner.AnimState:OverrideSymbol("swap_hat", fname, "swap_hat")
        end

        owner.AnimState:Show("HAT")
        owner.AnimState:Hide("HAIR_HAT")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")

        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")

        if inst.components.fueled ~= nil then
            inst.components.fueled:StartConsuming()
        end
    end

    local function simple(custom_init)
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(symname)
        inst.AnimState:SetBuild(fname)
        inst.AnimState:PlayAnimation("anim")

        inst:AddTag("hat")

        if custom_init ~= nil then
            custom_init(inst)
        end

        MakeInventoryFloatable(inst)
        inst.components.floater:SetBankSwapOnFloat(false, nil, swap_data) --Hats default animation is not "idle", so even though we don't swap banks, we need to specify the swap_data for re-skinning to reset properly when floating

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/"..prefabname..".xml"

        inst:AddComponent("inspectable")

        inst:AddComponent("tradable")

        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
        inst.components.equippable:SetOnEquip(simple_onequip)
        inst.components.equippable:SetOnUnequip(simple_onunequip)

        MakeHauntableLaunch(inst)

        return inst
    end

    local function default()
        return simple()
    end

    local function snakeskin_onequip(inst, owner)
        simple_onequip(inst, owner)
		owner:AddTag("ndnr_snakefriend")
		owner:AddTag("ndnr_snakeprotect")
    end

    local function snakeskin_onunequip(inst, owner)
        simple_onunequip(inst, owner)
		owner:RemoveTag("ndnr_snakefriend")
		owner:RemoveTag("ndnr_snakeprotect")
    end

    local function snakeskin_custom_init(inst)
        --waterproofer (from waterproofer component) added to pristine state for optimization
        inst:AddTag("waterproofer")
    end

    local function snakeskin()
        local inst = simple(snakeskin_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable:SetOnEquip(snakeskin_onequip)
        inst.components.equippable:SetOnUnequip(snakeskin_onunequip)
        inst.components.equippable.insulated = true

        inst:AddComponent("fueled")
		inst.components.fueled.fueltype = "USAGE"
		inst.components.fueled:InitializeFuelLevel(TUNING.TOTAL_DAY_TIME*8)
		inst.components.fueled:SetDepletedFn(generic_perish)

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_LARGE)

        return inst
    end

    local fn = nil
    local assets = {
        Asset("ANIM", "anim/"..fname..".zip"),
        Asset("IMAGE", "images/"..prefabname..".tex"),
        Asset("ATLAS", "images/"..prefabname..".xml"),
        Asset("ATLAS_BUILD", "images/"..prefabname..".xml", 256),
    }
    local prefabs = nil

    if name == "snakeskin" then
        fn = snakeskin
    end

    return Prefab(prefabname, fn or default, assets, prefabs)
end

return MakeHat("snakeskin")
