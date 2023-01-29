local assets =
{
    Asset("ANIM", "anim/lg_fishgirl.zip"),
}

local prefabs =
{
}
local function spawnwaves(inst, numWaves, totalAngle, waveSpeed, wavePrefab, initialOffset, idleTime, instantActivate, random_angle)
    SpawnAttackWaves(
        inst:GetPosition(),
        (not random_angle and inst.Transform:GetRotation()) or nil,
        initialOffset or (inst.Physics and inst.Physics:GetRadius()) or nil,
        numWaves,
        totalAngle,
        waveSpeed,
        wavePrefab,
        idleTime,
        instantActivate
    )
end
local function OnTimerDone(inst, data)
    spawnwaves(inst, 6, 360, 6, nil, nil, 1, nil, true)
    inst:Remove()
end

local diaoluo = {
    rain_flower_stone = {
        oceanfish_medium_8_inv = 2,
        oceanfish_small_8_inv = 2,
        oceanfish_small_6_inv = 2,
        oceanfish_small_7_inv = 2,
        royal_jelly = 1,
        lightninggoatborn = 3,
        goatmilk = 2,
        butter = 2,
        mandrake = 2,
        tallbirdegg = 3,
        phlegm = 1,
        minotaurhorn = 1,
        deerclops_eyeball = 1,
        bearger_fur = 1,
        dragon_scales = 1,
        treegrowthsolution = 4,
        goose_feather = 6,
        malbatross_feather = 4,
        oceanfishinglure_hermit_drowsy = 2,
        oceanfishinglure_hermit_heavy = 2,
        oceanfishinglure_hermit_rain = 2,
        oceanfishinglure_hermit_snow = 2,
        bluegem = 100,
        redgem = 95,
        yellowgem = 10,
        greengem = 10,
        orangegem = 10,
        purplegem = 90,
        thulecite = 8,
        thulecite_pieces = 10,
        opalepreciousgem = 1,    --彩虹宝石权重 
        lucky_goldnugget = 80    
    },
    lg_actinine = {
        ice = 100,
        froglegs = 8,
        fish = 7,
        eel = 6,
        oceanfish_medium_1_inv = 5,
        oceanfish_medium_2_inv = 5,
        oceanfish_medium_3_inv = 5,
        oceanfish_medium_4_inv = 5,
        oceanfish_medium_5_inv = 5,
        oceanfish_medium_6_inv = 5,
        oceanfish_medium_7_inv = 5,
        oceanfish_small_1_inv = 5,
        oceanfish_small_2_inv = 5,
        oceanfish_small_3_inv = 5,
        oceanfish_small_4_inv = 5,
        oceanfish_small_5_inv = 5,
        oceanfish_small_9_inv = 5,
        barnacle = 6,
        wobster_sheller_dead = 6,
        fig = 5,
        kelp = 9,
        waterplant_bomb = 6,
        lucky_goldnugget = 80
        
    },
    
siving_rocks = {
    albicans_cap  = 10,               --  素白菇
    mat_whitewood_item = 20,   -- 白木地垫
    dug_lilybush=15,--  蹄莲花丛  
    monstrain_leaf=40,    -- 雨竹叶  
    cutted_lilybush  =15,-- 蹄莲亚术
    cutted_rosebush  =15,-- 蔷薇折枝
    mint_l  =10, -- 猫薄荷  
    orchitwigs = 4 ,  --兰花剑  
    petals_lily = 100 ,  --蹄莲花瓣
    squamousfruit =60 ,  --零果
    merm_scales =30, -- 鱼之息
    foliageath =2 , -- 青枝绿叶
    ahandfulofwings =10,  --一捧翅膀
    sachet =25 ,--香包  
    dug_rosebush =15 ,--蔷薇花丛 
    petals_orchit  =100,-- 兰草花瓣
    rosorns = 4 , --蔷薇剑 
    dug_orchitbush =15 , -- 兰草花丛  
    petals_rose  =100,--  蔷薇花瓣
    siving_derivant_item  =10,  --一型岩  
    shyerrylog =50 , -- 宽大的木墩
    cattenball  =25, -- 毛线球
    shyerry  = 25,--  颤栗果  
    pineananas_seeds  =60 ,-- 菠萝种子 
    cutted_orchidbush  =15  ,-- 兰草种子
    lileaves   =4 ,--蹄莲剑   
    }
    
}

local function ShouldAcceptItem(inst, item)
    return  diaoluo[item.prefab] ~= nil
end

local function launchitem(item, angle)
    local speed = math.random() * 4 + 2
    angle = (angle + math.random() * 60 - 30) * DEGREES
    item.Physics:SetVel(speed * math.cos(angle), math.random() * 2 + 8, speed * math.sin(angle))
end
local function OnGetItemFromPlayer(inst, giver, item)
    if diaoluo[item.prefab] ~= nil then
        local choice = weighted_random_choice(diaoluo[item.prefab])
        if choice then
            local new = SpawnPrefab(choice)
            if new then
                if giver and giver.components.inventory then
                    giver.components.inventory:GiveItem(new,nil,inst:GetPosition())
                else
                    local x, y, z = inst.Transform:GetWorldPosition()
                    local angle
                    if giver ~= nil and giver:IsValid() then
                        angle = 180 - giver:GetAngleToPoint(x, 0, z)
                    else
                        local down = TheCamera:GetDownVec()
                        angle = math.atan2(down.z, down.x) / DEGREES
                        giver = nil
                    end
                    new.Transform:SetPosition(x, y, z)
                    launchitem(new, angle)
                end
            end
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("lg_fishgirl.tex")

    inst.AnimState:SetBuild("lg_fishgirl")
    inst.AnimState:SetBank("lg_fishgirl")
    inst.AnimState:PlayAnimation("idle", true)

    MakeInventoryFloatable(inst, "med", 0.1, {2.0, 0.9, 1.1})
    inst.components.floater.bob_percent = 0

    local land_time = (POPULATING and math.random()*5*FRAMES) or 0
    inst:DoTaskInTime(land_time, function(inst)
        inst.components.floater:OnLandedServer()
    end)
    MakeWaterObstaclePhysics(inst, 1.2, 2, 0.75)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")
    inst:AddComponent("timer")
    inst.components.timer:StartTimer("Leave", 6 * TUNING.PERISH_ONE_DAY)
    inst:ListenForEvent("timerdone", OnTimerDone)

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    return inst
end

return Prefab("lg_fishgirl", fn, assets, prefabs)