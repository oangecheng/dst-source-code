require "prefabutil"

local function make_plantable(data)
    local assets =
    {
        Asset("ANIM", "anim/medal_plantables.zip"),
        Asset("ATLAS", "images/"..data.name..".xml"),
		Asset("ATLAS_BUILD", "images/"..data.name..".xml",256),
    }

    local function ondeploy(inst, pt, deployer)
        local tree = SpawnPrefab(data.plantname)
        if tree ~= nil then
            tree.Transform:SetPosition(pt:Get())
            inst.components.stackable:Get():Remove()
            if tree.components.pickable ~= nil then
                tree.components.pickable:OnTransplant()--执行移植函数
				tree.components.pickable:MakeEmpty()
            end
            if deployer ~= nil and deployer.SoundEmitter ~= nil then
                deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
            end
        end
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        --inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst:AddTag("deployedplant")

		inst.AnimState:SetBank("medal_plantables")
        inst.AnimState:SetBuild("medal_plantables")
        inst.AnimState:PlayAnimation(data.anim)

        if data.floater ~= nil then
            MakeInventoryFloatable(inst, data.floater[1], data.floater[2], data.floater[3])
        else
            MakeInventoryFloatable(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

        inst:AddComponent("inspectable")
		
        inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = data.name
		inst.components.inventoryitem.atlasname = "images/"..data.name..".xml"

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

        MakeMediumBurnable(inst, TUNING.LARGE_BURNTIME)
        MakeSmallPropagator(inst)

        MakeHauntableLaunchAndIgnite(inst)

		if not data.cantplant then
			inst:AddComponent("deployable")
			inst.components.deployable.ondeploy = ondeploy
			inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
			if data.mediumspacing then
				inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)
			end
		end

        ---------------------
        return inst
    end

    return Prefab(data.name, fn, assets)
end

local prefabs = {}
for i, v in pairs(require("medal_defs/medal_plantable_defs")) do
    table.insert(prefabs, make_plantable(v))
	if not v.cantplant then
		table.insert(prefabs, MakePlacer(v.name.."_placer", v.bank_placer, v.build_placer, v.anim_placer))
	end
end

return unpack(prefabs)
