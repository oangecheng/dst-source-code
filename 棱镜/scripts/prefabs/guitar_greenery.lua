local assets_guitar =
{
    Asset("ANIM", "anim/guitar_greenery.zip"),
    Asset("ANIM", "anim/swap_guitar_greenery.zip"),
    Asset("ATLAS", "images/inventoryimages/guitar_greenery.xml"),
    Asset("IMAGE", "images/inventoryimages/guitar_greenery.tex"),
}

local prefabs_guitar =
{
    "guitar_greenery_water_fx",
    "guitar_greenery_desert_fx",
    "guitar_greenery_forest_fx",
    "guitar_greenery_spore_fx",
    "guitar_greenery_cave_fx",
}

------

local BUFFRADIUS = 20

local function GetRandomPoint(x, y, z, radius, forceradius)
    local rad = forceradius or math.random() * (radius or 1)
    local angle = math.random() * 2 * PI

    return x + rad * math.cos(angle), y, z - rad * math.sin(angle)
end

local function SetGuitarBuff(target, buffcenter)
    --精神值恢复
    if target.components.sanity ~= nil then
        target.components.sanity.externalmodifiers:SetModifier(buffcenter, TUNING.DAPPERNESS_HUGE) --8分钟加100精神
    end

    --人物贴图变色
    target.AnimState:SetMultColour(0.7, 1, 0.8, 1)

    local healthnum = 1

    target.guitar_greenery_buff_task = target:DoPeriodicTask(0.5, function()
        --buff源不在了，或者自己死掉了，就去除buff
        if FindEntity(target, BUFFRADIUS, nil, { "greenerycenter" }, nil, nil) == nil or (target.components.health ~= nil and target.components.health:IsDead()) then
            if target.guitar_greenery_buff_task ~= nil then
                target.guitar_greenery_buff_task:Cancel()
                target.guitar_greenery_buff_task = nil
            end

            --去除精神值恢复效果
            if target.components.sanity ~= nil then
                target.components.sanity.externalmodifiers:RemoveModifier(buffcenter)
            end

            --恢复原色，会让原本有颜色的对象失去颜色，比如猪人、树人等自带颜色的对象
            target.AnimState:SetMultColour(1, 1, 1, 1)

            return
        end

        --加血，不想用health组件的StartRegen()，因为反正这里都是一个周期函数，为啥还要多加一个周期函数来加血呢
        if target.components.health ~= nil and target.components.health:IsHurt() then
            healthnum = healthnum + 1
            if healthnum > 4 then --不是每次执行都要加血，不然状态栏会鬼畜
                healthnum = 1
                target.components.health:DoDelta(2, nil, buffcenter.prefab)
            end
        end

        --生成特效，植物人用自己的特效贴图，陆地、水中、船上、洞穴陆地分别有不同的贴图
        local x, y, z = target.Transform:GetWorldPosition()
        -- local map = TheWorld.Map
        if #TheSim:FindEntities(x, y, z, 2, { "guitar_greenery_fx" }) <= 9 then
            local x1, y1, z1 = GetRandomPoint(x, y, z)

            if TheWorld.Map:IsPassableAtPoint(x1, 0, z1) then
                SpawnPrefab("guitar_greenery_desert_fx").Transform:SetPosition(x1, 0, z1)
            end
        end
    end, 1)
end

----------

local function PlayStart(inst, owner)
    owner.AnimState:OverrideSymbol("swap_guitar","swap_guitar_greenery","swap_guitar_greenery")
end

local function PlayDoing(inst, owner)
    owner.AnimState:PlayAnimation("soothingplay_loop", true)
    -- owner.SoundEmitter:SetVolume("ragtime",1)
    -- owner.SoundEmitter:PlaySound("legion/guitar_songs/remember_me", "song")
    owner.SoundEmitter:PlaySound("legion/guitar_songs/flower", "song")
    -- owner.SoundEmitter:PlaySound("legion/guitar_songs/break_riff")  --这音乐只播放一次，有11秒
    inst.components.fueled:StartConsuming() --开始损坏

    if inst.bufftask ~= nil then
        inst.bufftask:Cancel()
        inst.bufftask = nil
    end

    owner:AddTag("greenerycenter")

    --精神值消耗
    if owner.components.sanity ~= nil then
        --这里用的吉他的prefab名字，而不是吉他本身，是为了区分开自己的buff和别人的buff
        owner.components.sanity.externalmodifiers:SetModifier(inst.prefab, -TUNING.DAPPERNESS_SUPERHUGE) --8分钟减-200精神
    end

    local healthnum = 1

    inst.bufftask = inst:DoPeriodicTask(0.5, function()
        local x, y, z = owner.Transform:GetWorldPosition() --实时更新位置，写在外面也可以，但是玩家可能会被挤走，位置会发生偏移

        --给自己加血
        if owner.components.health ~= nil and not owner.components.health:IsDead() and owner.components.health:IsHurt() then
            healthnum = healthnum + 1
            if healthnum > 4 then --不是每次执行都要加血，不然状态栏会鬼畜
                healthnum = 1
                owner.components.health:DoDelta(2, nil, inst.prefab)
            end
        end

        --自身周围生成特效，有数量限制
        -- local map = TheWorld.Map
        if #TheSim:FindEntities(x, y, z, 1, { "guitar_greenery_fx" }) <= 12 then
            local x1, y1, z1 = GetRandomPoint(x, y, z, 3)

            --判断地皮，在水里和陆地会分别生成对应的特效
            if TheWorld.Map:IsPassableAtPoint(x1, 0, z1) then
                SpawnPrefab("guitar_greenery_desert_fx").Transform:SetPosition(x1, 0, z1)
            end
        end

        --小范围生成特效，无数量限制
        local x2, y2, z2 = GetRandomPoint(x, y, z, nil, math.random() * 2 + 1.1) --故意在特效检测范围之外

        --判断地皮，在水里和陆地会分别生成对应的特效
        if TheWorld.Map:IsPassableAtPoint(x2, 0, z2) then
            SpawnPrefab("guitar_greenery_desert_fx").Transform:SetPosition(x2, 0, z2)
        end

        --给其他对象加buff
        local ents = TheSim:FindEntities(x, y, z, BUFFRADIUS, { "_combat", "_health" }, { "INLIMBO", "NOCLICK", "ghost", "shadowminion" }) --buff不对鬼魂和暗影随从生效
        for i, ent in ipairs(ents) do
            --如果对方buff没有消失，就加上
            if ent ~= owner and ent.guitar_greenery_buff_task == nil and ent.components.health ~= nil and not ent.components.health:IsDead() then
                --玩家或者跟随玩家的对象，没死，就能享有buff
                if ent:HasTag("player") or
                    (ent.components.follower ~= nil and ent.components.follower:GetLeader() ~= nil and (ent.components.follower:GetLeader()):HasTag("player"))
                then
                    SetGuitarBuff(ent, inst)
                end
            end
        end
    end, 2)
end

local function PlayEnd(inst, owner)
    if inst.bufftask ~= nil then
        inst.bufftask:Cancel()
        inst.bufftask = nil
    end

    owner:RemoveTag("greenerycenter")

    if owner.components.sanity ~= nil then
        owner.components.sanity.externalmodifiers:RemoveModifier(inst.prefab)
    end

    owner.SoundEmitter:KillSound("song")
    if inst.broken then --损坏了，消失
        inst:Remove()
    else                --还没坏，停止损坏
        inst.components.fueled:StopConsuming()
    end
end

local function OnFinished(inst)
    local owner = inst.components.inventoryitem:GetGrandOwner()
    if owner ~= nil then
        owner:PushEvent("playenough")
    end
    inst.broken = true
end

local function fn_guitar()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst:AddTag("guitar")

    inst.AnimState:SetBank("guitar_greenery")
    inst.AnimState:SetBuild("guitar_greenery")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("instrument")

    inst.PlayStart = PlayStart
    inst.PlayDoing = PlayDoing
    inst.PlayEnd = PlayEnd

    -- inst:AddComponent("finiteuses")
    -- inst.components.finiteuses:SetMaxUses(5)
    -- inst.components.finiteuses:SetUses(5)
    -- inst.components.finiteuses:SetOnFinished(OnFinished)

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.MAGIC --这种类型代表不可被修复
    inst.components.fueled:InitializeFuelLevel(TUNING.TOTAL_DAY_TIME * 2) --16分钟的使用时间
    inst.components.fueled:SetDepletedFn(OnFinished)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "guitar_greenery"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/guitar_greenery.xml"

    MakeHauntableLaunch(inst)

    return inst
end

----------
----------

local function MakeGreeneryFx(name, build)
    local assets_greenery_fx =
    {
        -- Asset("ANIM", "anim/wormwood_plant_fx.zip"),
        Asset("ANIM", "anim/"..build..".zip"),
    }

    local function PlayAnim_greenery(proxy)
        local inst = CreateEntity()

        inst:AddTag("FX")
        inst:AddTag("NOCLICK")
        inst:AddTag("guitar_greenery_fx") --这个特效用来便于搜索机制控制特效数量
        --[[Non-networked entity]]
        inst.entity:SetCanSleep(false)
        inst.persists = false

        inst.entity:AddTransform()
        inst.entity:AddAnimState()

        --如果想让特效能设置父实体，则需要这一截代码
        local parent = proxy.entity:GetParent()
        if parent ~= nil then
            inst.entity:SetParent(parent.entity)
        end

        inst.Transform:SetFromProxy(proxy.GUID)

        inst.animname = math.random(1,4) --随机设置为某种花，共四种

        inst.AnimState:SetBank("wormwood_plant_fx")
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("grow_"..inst.animname)

        -- inst.AnimState:SetSortOrder(1)
        -- inst.Transform:SetScale(0.6, 0.6, 0.6)
        -- inst.AnimState:OverrideSymbol("needle", "guitar_miguel_fx", "needle")
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

        inst:ListenForEvent("animover", function()
            if inst.ending then
                 inst:Remove()
            else
                --查找周围的玩家，如果有则一直不消失，如果没有，则随机会消失
                if FindEntity(inst, 1, nil, { "player" }, { "notarget", "INLIMBO", "playerghost" }, nil) == nil and math.random() < 0.2 then
                    inst.ending = true
                    inst.AnimState:PlayAnimation("ungrow_"..inst.animname)
                else
                    inst.AnimState:PlayAnimation("idle_"..inst.animname)
                end
            end
        end)
    end

    local function fn_greenery()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddNetwork()

        --Dedicated server does not need to spawn the local fx
        if not TheNet:IsDedicated() then
            --Delay one frame so that we are positioned properly before starting the effect
            --or in case we are about to be removed
            inst:DoTaskInTime(0, PlayAnim_greenery, inst)
        end

        inst:AddTag("FX")
        
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false
        inst:DoTaskInTime(1, inst.Remove)

        return inst
    end

    return Prefab(name, fn_greenery, assets_greenery_fx)
end

return Prefab("guitar_greenery", fn_guitar, assets_guitar, prefabs_guitar),
        MakeGreeneryFx("guitar_greenery_water_fx", "guitar_greenery_water_fx"),
        MakeGreeneryFx("guitar_greenery_desert_fx", "guitar_greenery_desert_fx"),
        MakeGreeneryFx("guitar_greenery_forest_fx", "guitar_greenery_forest_fx"),
        MakeGreeneryFx("guitar_greenery_spore_fx", "guitar_greenery_spore_fx"),
        MakeGreeneryFx("guitar_greenery_cave_fx", "guitar_greenery_cave_fx")
