
local function makedried(name, data)

    local assets = {
        Asset("ANIM", "anim/lg_fruit_dried.zip"), 
        Asset("ATLAS", "images/inventoryimages/" .. name .. ".xml")
    }

    local function common()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        MakeInventoryPhysics(inst)
        inst.AnimState:SetBank("lg_fruit_dried")
        inst.AnimState:SetBuild("lg_fruit_dried")
        inst.AnimState:PlayAnimation(name)
        MakeInventoryFloatable(inst)
        local s  = 0.9
        inst.Transform:SetScale(s, s, s)
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("edible")
        inst.components.edible.foodtype = data[5] or FOODTYPE.VEGGIE
        inst.components.edible.healthvalue = data[3] or 0
        inst.components.edible.hungervalue = data[1] or 0
        inst.components.edible.sanityvalue = data[2] or 0

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/" .. name .. ".xml"

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("tradable")

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(data[4] or TUNING.PERISH_FAST)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food"

        MakeHauntableLaunchAndPerish(inst)
        return inst
    end

    return Prefab(name, common, assets)
end

local a = {}
for k, v in pairs(TUNING.LG_FRUIT_DRIED) do
    table.insert(a,makedried(string.find(k,"lg") and k.."_dried" or "lg_"..k.."_dried", v))
end
return unpack(a)
