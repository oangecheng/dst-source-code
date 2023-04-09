local assets = {
    Asset("ANIM", "anim/book_weather.zip"),
    Asset("ATLAS", "images/inventoryimages/book_weather.xml"),
    Asset("IMAGE", "images/inventoryimages/book_weather.tex"),
}

local prefabs = {
    "waterballoon_splash", "fx_book_rain"
}

local function FixSymbol(owner, data) --因为书籍的攻击贴图会因为读书而被替换，所以这里重新覆盖一次
    if data and data.statename == "attack" then
        -- owner.AnimState:OverrideSymbol("book_open", "book_weather", "book_open")
        owner.AnimState:OverrideSymbol("book_closed", "book_weather", "book_closed") --书籍攻击贴图在这里面
    end
end

local function OnEquip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")  --清除上一把武器的贴图效果，因为一般武器卸下时都不清除贴图

    owner.AnimState:OverrideSymbol("book_open", "book_weather", "book_open")
    owner.AnimState:OverrideSymbol("book_closed", "book_weather", "book_closed")
    -- owner.AnimState:OverrideSymbol("book_open_pages", "book_weather", "book_open_pages")

    if owner:HasTag("equipmentmodel") then --假人！
        return
    end

    owner:AddTag("ignorewet")
    inst:ListenForEvent("newstate", FixSymbol, owner)
end

local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    --还原书的贴图
    owner.AnimState:OverrideSymbol("book_open", "player_actions_uniqueitem", "book_open")
    owner.AnimState:OverrideSymbol("book_closed", "player_actions_uniqueitem", "book_closed")
    -- owner.AnimState:OverrideSymbol("book_open_pages", "player_actions_uniqueitem", "book_open_pages")

    owner:RemoveTag("ignorewet")
    inst:RemoveEventCallback("newstate", FixSymbol, owner)
end

local function onattack(inst, owner, target)
    if target ~= nil and target:IsValid() then
        SpawnPrefab("waterballoon_splash").Transform:SetPosition(target.Transform:GetWorldPosition())

        inst.components.wateryprotection:SpreadProtection(target) --潮湿度组件增加潮湿

        if
            target.components.health ~= nil and not target.components.health:IsDead() and
            not target:HasTag("likewateroffducksback")
        then
            if target.components.inventoryitem ~= nil then --物品组件增加潮湿
                target.components.inventoryitem:AddMoisture(TUNING.OCEAN_WETNESS)
                return
            end

            if target.task_l_iswet == nil then
                if target:HasTag("wet") then
                    return
                end
                target:AddTag("wet") --标签方式增加潮湿
            else
                target.task_l_iswet:Cancel()
            end
            target.task_l_iswet = target:DoTaskInTime(15, function()
                target:RemoveTag("wet")
                target.task_l_iswet = nil
            end)
        end
    end
end

local function OnRead(inst, reader)
    -- if TheWorld.state.israining or TheWorld.state.issnowing then
    --     TheWorld:PushEvent("ms_forceprecipitation", false)
    -- else
    --     TheWorld:PushEvent("ms_forceprecipitation", true)
    -- end
    if TheWorld.state.precipitation ~= "none" then
        TheWorld:PushEvent("ms_forceprecipitation", false)
    else
        TheWorld:PushEvent("ms_forceprecipitation", true)
    end

    local x, y, z = reader.Transform:GetWorldPosition()
    local size = TILE_SCALE

    for i = x-size, x+size do
        for j = z-size, z+size do
            if TheWorld.Map:GetTileAtPoint(i, 0, j) == WORLD_TILES.FARMING_SOIL then
                TheWorld.components.farming_manager:AddSoilMoistureAtPoint(i, y, j, 100)
            end
        end
    end

    return true
end

local function OnPeruse(inst, reader)
    if reader.prefab == "wurt" then
        if TheWorld.state.israining or TheWorld.state.issnowing then --雨雪天时，书中全是关于放晴的字眼，沃特不喜欢
            inst.components.book:SetPeruseSanity(-TUNING.SANITY_LARGE)
            reader.components.talker:Say(GetString(reader, "ANNOUNCE_READ_BOOK","BOOK_WEATHER_SUNNY"))
        else --晴天时，书中全是关于下雨的字眼，沃特好喜欢
            inst.components.book:SetPeruseSanity(TUNING.SANITY_LARGE)
            reader.components.talker:Say(GetString(reader, "ANNOUNCE_READ_BOOK","BOOK_WEATHER_RAINY"))
        end
    else
        if reader.peruse_weather ~= nil then
            reader.peruse_weather(reader)
        end
        if reader.components.talker ~= nil then
            reader.components.talker:Say(GetString(reader, "ANNOUNCE_READ_BOOK","BOOK_WEATHER"))
        end
    end

    return true
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("book_weather")
    inst.AnimState:SetBuild("book_weather")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("book") --加入book标签就能使攻击时使用人物的书本攻击的动画
    inst:AddTag("bookcabinet_item") --能放入书柜的标签

    MakeInventoryFloatable(inst, "med", 0.1, 0.75)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    -- inst.def = def
    inst.swap_build = "book_weather"
    inst.swap_prefix = "book"

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "book_weather"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/book_weather.xml"

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(50)
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("wateryprotection")
    inst.components.wateryprotection.extinguishheatpercent = TUNING.WATERBALLOON_EXTINGUISH_HEAT_PERCENT
    inst.components.wateryprotection.temperaturereduction = TUNING.WATERBALLOON_TEMP_REDUCTION
    inst.components.wateryprotection.witherprotectiontime = TUNING.WATERBALLOON_PROTECTION_TIME
    inst.components.wateryprotection.addwetness = TUNING.WATERBALLOON_ADD_WETNESS
    if TheNet:GetPVPEnabled() then
        inst.components.wateryprotection:AddIgnoreTag("ignorewet")  --PVP，防止使用者被打湿
    else
        inst.components.wateryprotection:AddIgnoreTag("player")  --PVE，防止所有玩家被打湿
    end
    inst.components.wateryprotection.onspreadprotectionfn = function(inst)
        inst.components.finiteuses:Use(1)
    end

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(300)
    inst.components.finiteuses:SetUses(300)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("book")
    inst.components.book:SetOnRead(OnRead)
    inst.components.book:SetOnPeruse(OnPeruse)
    inst.components.book:SetReadSanity(-TUNING.SANITY_LARGE) --读书的精神消耗
    -- inst.components.book:SetPeruseSanity() --阅读的精神消耗/增益
    inst.components.book:SetFx("fx_book_rain")
    inst.components.book.ConsumeUse = function(self)
        self.inst.components.finiteuses:Use(20) --可以使用15次
    end

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("book_weather", fn, assets, prefabs)
