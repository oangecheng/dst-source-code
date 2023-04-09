local prefs = {}

--------------------------------------------------------------------------
--[[ 通用函数 ]]
--------------------------------------------------------------------------

local function MakeCarpet(data)
    local name_base = "carpet_"..data.name
    local name_prefab = data.size == 2 and name_base.."_big" or name_base
    table.insert(prefs, Prefab(
        name_prefab,
		function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddNetwork()

            inst.AnimState:SetBank(name_base)
            inst.AnimState:SetBuild(name_base)
            inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
            inst.AnimState:SetLayer(LAYER_BACKGROUND)
            inst.AnimState:SetFinalOffset(1)

            inst:AddTag("DECOR")
            inst:AddTag("NOCLICK")
            inst:AddTag("NOBLOCK")
            inst:AddTag("carpet_l")
            if data.size == 2 then
                inst:AddTag("carpet_big")
                inst.AnimState:PlayAnimation("idle_big")
            else
                inst.AnimState:PlayAnimation("idle")
            end

            if data.fn_common ~= nil then
                data.fn_common(inst)
            end

            inst:AddComponent("skinedlegion")
            inst.components.skinedlegion:Init(name_prefab)

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            -- inst:AddComponent("inspectable")

            inst:AddComponent("lootdropper")

            inst:AddComponent("savedrotation")

            if data.fn_server ~= nil then
                data.fn_server(inst)
            end

            -- inst.components.skinedlegion:SetOnPreLoad()

            return inst
		end,
		data.assets,
		data.prefabs
	))

    table.insert(prefs, MakePlacer(
        name_prefab.."_placer",
        name_base, name_base, data.size == 2 and "idle_big" or "idle", true,
        nil, nil, nil, 90, nil, Skined_SetBuildPlacer_legion
    ))
end

local function MakeCarpets(data)
    local assets = {
        Asset("ANIM", "anim/carpet_"..data.name..".zip")
    }

    MakeCarpet({ --小的
        name = data.name,
        size = 1,
        fn_common = data.fn_common1, fn_server = data.fn_server1,
        assets = assets, prefabs = data.prefabs
    })
	MakeCarpet({ --大的
        name = data.name,
        size = 2,
        fn_common = data.fn_common2, fn_server = data.fn_server2,
        assets = assets, prefabs = data.prefabs
    })
end

--------------------------------------------------------------------------
--[[ 信标(用来让其绑定物被摧毁) ]]
--------------------------------------------------------------------------

-- table.insert(prefs, Prefab(
--     "beacon_work_l",
--     function()
--         local inst = CreateEntity()

--         inst.entity:AddTransform()
--         inst.entity:AddNetwork()

--         inst:AddTag("NOBLOCK")

--         inst.entity:SetPristine()
--         if not TheWorld.ismastersim then
--             return inst
--         end

--         inst.persists = false

--         inst:AddComponent("workable")
--         inst.components.workable:SetWorkAction(ACTIONS.HAMMER)

--         return inst
--     end,
--     nil,
--     nil
-- ))

--------------------------------------------------------------------------
--[[ 白木地垫、地毯 ]]
--------------------------------------------------------------------------

local function OnRemove_wood(inst, doer)
    inst.components.lootdropper:DropLoot()

    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
end
local function OnSet_wood(inst)
    inst.OnCarpetRemove = OnRemove_wood
end

MakeCarpets({
    name = "whitewood", fn_server1 = OnSet_wood, fn_server2 = OnSet_wood
})

--------------------------------------------------------------------------
--[[ 线绒地垫、地毯 ]]
--------------------------------------------------------------------------

MakeCarpets({
    name = "plush", fn_server1 = OnSet_wood, fn_server2 = OnSet_wood
})

--------------------
--------------------

return unpack(prefs)
