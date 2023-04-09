local prefs = {}

--------------------------------------------------------------------------
--[[ 通用函数 ]]
--------------------------------------------------------------------------

local function MakeToy(sets)
    table.insert(prefs, Prefab(sets.name, function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("toy_legion")
        inst.AnimState:SetBuild("toy_legion")
        inst.AnimState:PlayAnimation("toy_"..sets.name)

        if sets.floatable ~= nil then
            MakeInventoryFloatable(inst, sets.floatable[2], sets.floatable[3], sets.floatable[4])
            if sets.floatable[1] ~= nil then
                local OnLandedClient_old = inst.components.floater.OnLandedClient
                inst.components.floater.OnLandedClient = function(self)
                    OnLandedClient_old(self)
                    self.inst.AnimState:SetFloatParams(sets.floatable[1], 1, self.bob_percent)
                end
            end
        end

        if sets.fn_common ~= nil then
            sets.fn_common(inst)
        end

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = sets.name
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..sets.name..".xml"

        if sets.stackable ~= nil then
            inst:AddComponent("stackable")
            inst.components.stackable.maxsize = sets.stackable
        end

        if sets.tradable ~= nil then
            inst:AddComponent("tradable")
            inst.components.tradable.goldvalue = sets.tradable
        end

        if sets.fuel ~= nil then
            inst:AddComponent("fuel")
            inst.components.fuel.fuelvalue = sets.fuel
        end

        MakeHauntableLaunch(inst)

        if sets.fn_server ~= nil then
            sets.fn_server(inst)
        end

        return inst
    end, sets.assets, sets.prefabs))
end

--------------------------------------------------------------------------
--[[ 猫线球 ]]
--------------------------------------------------------------------------

MakeToy({
    name = "cattenball",
    assets = {
        Asset("ANIM", "anim/toy_legion.zip"),
        Asset("ATLAS", "images/inventoryimages/cattenball.xml"),
        Asset("IMAGE", "images/inventoryimages/cattenball.tex"),
    },
    prefabs = nil,
    floatable = { 0.08, "med", 0.25, 0.5 },
    stackable = TUNING.STACK_SIZE_MEDITEM,
    tradable = 9,
    fuel = TUNING.SMALL_FUEL,
    fn_common = function(inst)
        inst:AddTag("cattoy") --能给浣猫
    end,
    fn_server = function(inst)
        MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
        MakeSmallPropagator(inst)
    end
})

--------------------------------------------------------------------------
--[[ 玩具小海绵与玩具小海星 ]]
--------------------------------------------------------------------------

-- local function MakeToyWe(name)
--     local assets_toywe =
--     {
--         Asset("ANIM", "anim/toy_legion.zip"),
--         Asset("ATLAS", "images/inventoryimages/"..name..".xml"),
--         Asset("IMAGE", "images/inventoryimages/"..name..".tex"),
--     }

--     local function Fn_toywe()
--         local inst = CreateEntity()

--         inst.entity:AddTransform()
--         inst.entity:AddAnimState()
--         inst.entity:AddNetwork()

--         MakeInventoryPhysics(inst)

--         inst.AnimState:SetBank("toy_legion")
--         inst.AnimState:SetBuild("toy_legion")
--         inst.AnimState:PlayAnimation(name)

--         inst:AddTag("cattoy") --能给浣猫

--         MakeInventoryFloatable(inst, "med", 0.3, 0.6)
--         local OnLandedClient_old = inst.components.floater.OnLandedClient
--         inst.components.floater.OnLandedClient = function(self)
--             OnLandedClient_old(self)
--             self.inst.AnimState:SetFloatParams(0.06, 1, self.bob_percent)
--         end

--         inst.entity:SetPristine()

--         if not TheWorld.ismastersim then
--             return inst
--         end

--         inst:AddComponent("inspectable")

--         --独一无二！
--         -- inst:AddComponent("stackable")
--         -- inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

--         inst:AddComponent("inventoryitem")
--         inst.components.inventoryitem.imagename = name
--         inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

--         inst:AddComponent("tradable")
--         inst.components.tradable.goldvalue = 1 --每四个月记得来加1

--         inst:AddComponent("fuel")
--         inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

--         MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
--         MakeSmallPropagator(inst)
--         MakeHauntableLaunchAndIgnite(inst)

--         return inst
--     end

--     return Prefab(name, Fn_toywe, assets_toywe)
-- end

-- table.insert(prefabs, MakeToyWe("toy_spongebob"))
-- table.insert(prefabs, MakeToyWe("toy_patrickstar"))

--------------------
--------------------

return unpack(prefs)
