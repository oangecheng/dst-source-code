local prefabs = {}

local function GetPlacerAnim(anims)
    if type(anims) == 'table' then
        return anims[ #anims ]
    else
        return anims
    end
end

local function MakePlantable(name, data)
    local imgname = data.overrideimage or name
    local assets = {
        Asset("ANIM", "anim/"..data.animstate.build..".zip"),
        Asset("ATLAS", "images/inventoryimages/"..imgname..".xml"),
        Asset("IMAGE", "images/inventoryimages/"..imgname..".tex")
    }
    if data.animstate.build ~= data.animstate.bank then
        table.insert(assets, Asset("ANIM", "anim/"..data.animstate.bank..".zip"))
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(data.animstate.bank)
        inst.AnimState:SetBuild(data.animstate.build)
        inst.AnimState:PlayAnimation(data.animstate.anim)

        if data.floater ~= nil then
            MakeInventoryFloatable(inst, data.floater[2], data.floater[3], data.floater[4])
            if data.floater[1] ~= nil then
                local OnLandedClient_old = inst.components.floater.OnLandedClient
                inst.components.floater.OnLandedClient = function(self)
                    OnLandedClient_old(self)
                    self.inst.AnimState:SetFloatParams(data.floater[1], 1, self.bob_percent)
                end
            end
        end

        if data.fn_common ~= nil then
            data.fn_common(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = imgname
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..imgname..".xml"
        if data.floater == nil then
            inst.components.inventoryitem:SetSinks(true)
        end

        if data.stacksize ~= nil then
            inst:AddComponent("stackable")
            inst.components.stackable.maxsize = data.stacksize
        end

        if data.fuelvalue ~= nil then
            inst:AddComponent("fuel")
            inst.components.fuel.fuelvalue = data.fuelvalue
        end

        if data.burnable ~= nil then
            if data.burnable.fxsize == "small" then
                MakeSmallBurnable(inst, data.burnable.time)
            elseif data.burnable.fxsize == "medium" then
                MakeMediumBurnable(inst, data.burnable.time)
            else
                MakeLargeBurnable(inst, data.burnable.time)
            end

            if data.burnable.lightedsize == "small" then
                MakeSmallPropagator(inst)
            elseif data.burnable.lightedsize == "medium" then
                MakeMediumPropagator(inst)
            else
                MakeLargePropagator(inst)
            end
        end

        MakeHauntableLaunchAndIgnite(inst)

        inst:AddComponent("deployable")
        inst.components.deployable.ondeploy = function(inst, pt, deployer)
            local skinname = nil
            local tree = nil
            if deployer and deployer.userid and SKINS_CACHE_EX_L[deployer.userid] ~= nil then
                local data = SKINS_CACHE_EX_L[deployer.userid]
                if data[name] ~= nil then
                    skinname = data[name].name
                end
            end
            if skinname == nil then
                tree = SpawnPrefab(data.deployable.prefab)
            else
                tree = SpawnPrefab(data.deployable.prefab, skinname, nil, deployer.userid)
            end

            if tree ~= nil then
                tree.Transform:SetPosition(pt:Get())

                if inst.components.stackable ~= nil then
                    inst.components.stackable:Get():Remove()
                else
                    inst:Remove()
                end

                if tree.components.pickable ~= nil then
                    tree.components.pickable:OnTransplant()
                end

                if deployer ~= nil and deployer.SoundEmitter ~= nil then
                    deployer.SoundEmitter:PlaySound(data.deployable.sound or "dontstarve/common/plant")
                end

                if tree.fn_planted then
                    tree.fn_planted(tree, pt)
                end
            end
        end
        if data.deployable.mode ~= nil then
            inst.components.deployable:SetDeployMode(data.deployable.mode)
        end
        if data.deployable.spacing ~= nil then
            inst.components.deployable:SetDeploySpacing(data.deployable.spacing)
        end

        if data.fn_server ~= nil then
            data.fn_server(inst)
        end

        return inst
    end

    return Prefab(name, fn, assets)
end

--------------------
--------------------

local plantables = {
    ------
    --花香四溢
    ------
    dug_rosebush = {
        animstate = { bank = "berrybush2", build = "rosebush", anim = "dropped", anim_palcer = "dead", },
        floater = {0.03, "large", 0.2, {0.65, 0.5, 0.65}},  --漂浮参数（底部切割比例, 波纹动画, 波纹所处位置比例, 波纹大小）
        stacksize = TUNING.STACK_SIZE_LARGEITEM,            --最大堆叠数
        fuelvalue = TUNING.LARGE_FUEL,                      --燃料值
        burnable = {
            time = TUNING.LARGE_BURNTIME,   --燃烧时间
            fxsize = "medium",              --火焰特效大小
            lightedsize = "small",          --引燃范围大小
        },
        deployable = {
            prefab = "rosebush",        --种植出的prefab名
            mode = DEPLOYMODE.PLANT,    --种植类型
            spacing = nil,              --种植间隔
        },
        fn_common = function(inst)
            inst:AddTag("deployedplant") --植株种植标签，植物人种下时能恢复精神等
        end,
        fn_server = nil,
    },
    dug_lilybush = {
        animstate = { bank = "berrybush2", build = "lilybush", anim = "dropped", anim_palcer = "dead", },
        floater = {0.03, "large", 0.2, {0.65, 0.5, 0.65}},
        stacksize = TUNING.STACK_SIZE_LARGEITEM,
        fuelvalue = TUNING.LARGE_FUEL,
        burnable = {
            time = TUNING.LARGE_BURNTIME,
            fxsize = "medium",
            lightedsize = "small",
        },
        deployable = {
            prefab = "lilybush",
            mode = DEPLOYMODE.PLANT,
            spacing = nil,
        },
        fn_common = function(inst)
            inst:AddTag("deployedplant")
        end,
        fn_server = nil,
    },
    dug_orchidbush = {
        animstate = { bank = "berrybush2", build = "orchidbush", anim = "dropped", anim_palcer = "dead", },
        floater = {nil, "large", 0.1, {0.65, 0.5, 0.65}},
        stacksize = TUNING.STACK_SIZE_LARGEITEM,
        fuelvalue = TUNING.LARGE_FUEL,
        burnable = {
            time = TUNING.LARGE_BURNTIME,
            fxsize = "medium",
            lightedsize = "small",
        },
        deployable = {
            prefab = "orchidbush",
            mode = DEPLOYMODE.PLANT,
            spacing = DEPLOYSPACING.MEDIUM,
        },
        fn_common = function(inst)
            inst:AddTag("deployedplant")
        end,
        fn_server = nil,
    },
    cutted_rosebush = {
        animstate = { bank = "rosebush", build = "rosebush", anim = "cutted", anim_palcer = "dead", },
        floater = {nil, "large", 0.1, 0.55},
        stacksize = TUNING.STACK_SIZE_SMALLITEM,
        fuelvalue = TUNING.SMALL_FUEL,
        burnable = {
            time = TUNING.SMALL_BURNTIME,
            fxsize = "small",
            lightedsize = "small",
        },
        deployable = {
            prefab = "rosebush",
            mode = DEPLOYMODE.PLANT,
            spacing = nil,
        },
        fn_common = function(inst)
            inst:AddTag("deployedplant")
            inst:AddTag("treeseed") --能使其放入种子袋
        end,
        fn_server = nil,
    },
    cutted_lilybush = {
        animstate = { bank = "lilybush", build = "lilybush", anim = "cutted", anim_palcer = "dead", },
        floater = {nil, "large", 0.1, 0.55},
        stacksize = TUNING.STACK_SIZE_SMALLITEM,
        fuelvalue = TUNING.SMALL_FUEL,
        burnable = {
            time = TUNING.SMALL_BURNTIME,
            fxsize = "small",
            lightedsize = "small",
        },
        deployable = {
            prefab = "lilybush",
            mode = DEPLOYMODE.PLANT,
            spacing = nil,
        },
        fn_common = function(inst)
            inst:AddTag("deployedplant")
            inst:AddTag("treeseed") --能使其放入种子袋
        end,
        fn_server = nil,
    },
    cutted_orchidbush = {
        animstate = { bank = "orchidbush", build = "orchidbush", anim = "cutted", anim_palcer = "dead", },
        floater = {nil, "large", 0.1, 0.55},
        stacksize = TUNING.STACK_SIZE_SMALLITEM,
        fuelvalue = TUNING.SMALL_FUEL,
        burnable = {
            time = TUNING.SMALL_BURNTIME,
            fxsize = "small",
            lightedsize = "small",
        },
        deployable = {
            prefab = "orchidbush",
            mode = DEPLOYMODE.PLANT, spacing = DEPLOYSPACING.MEDIUM
        },
        fn_common = function(inst)
            inst:AddTag("deployedplant")
            inst:AddTag("treeseed") --能使其放入种子袋
        end,
        fn_server = nil
    },
    ------
    --丰饶传说
    ------
    siving_derivant_item = { --子圭一型岩(物品)
        animstate = { bank = "siving_derivants", build = "siving_derivants", anim = "item", anim_palcer = "lvl0", },
        floater = nil,
        stacksize = TUNING.STACK_SIZE_LARGEITEM,
        fuelvalue = nil,
        burnable = nil,
        deployable = {
            prefab = "siving_derivant_lvl0",
            mode = nil,
            spacing = nil,
        },
        fn_common = function(inst)
            inst.entity:AddLight()

            inst.Light:Enable(false)
            inst.Light:SetRadius(0.3)
            inst.Light:SetFalloff(1)
            inst.Light:SetIntensity(.6)
            inst.Light:SetColour(15/255, 180/255, 132/255)

            inst:AddTag("siving_derivant")
        end,
        fn_server = function(inst)
            inst:AddComponent("bloomer")

            inst.treeState = 0
            inst.OnTreeLive = function(inst, state)
                inst.treeState = state
                if state == 2 then
                    inst.AnimState:PlayAnimation("item_live")
                    inst.components.bloomer:PushBloom("activetree", "shaders/anim.ksh", 1)
                    inst.Light:SetRadius(0.6)
                    inst.Light:Enable(true)
                elseif state == 1 then
                    inst.AnimState:PlayAnimation("item")
                    inst.components.bloomer:PushBloom("activetree", "shaders/anim.ksh", 1)
                    inst.Light:SetRadius(0.3)
                    inst.Light:Enable(true)
                else
                    inst.AnimState:PlayAnimation("item")
                    inst.components.bloomer:PopBloom("activetree")
                    inst.Light:Enable(false)
                end
            end

            inst.components.inventoryitem:SetOnDroppedFn(function(inst)
				inst.OnTreeLive(inst, 0) --不知道为啥捡起时已经关闭光源了，但还是发了光，所以这里丢弃时再次关闭光源
			end)
            inst.components.inventoryitem:SetOnPickupFn(function(inst)
				inst.OnTreeLive(inst, nil)
			end)
        end,
    },
    ------
    --祈雨祭
    ------
    dug_monstrain = {
        animstate = { bank = "monstrain", build = "monstrain", anim = "dropped", anim_palcer = nil, },
        floater = {nil, "small", 0.2, 1.2},
        stacksize = TUNING.STACK_SIZE_LARGEITEM,
        fuelvalue = TUNING.SMALL_FUEL,
        burnable = {
            time = TUNING.SMALL_BURNTIME,
            fxsize = "small",
            lightedsize = "small",
        },
        deployable = {
            prefab = "monstrain_wizen",
            mode = DEPLOYMODE.PLANT,
            spacing = nil,
        },
        fn_common = function(inst)
            inst:AddTag("deployedplant")
        end,
        fn_server = nil,
    }
}

--异种
for k,v in pairs(CROPS_DATA_LEGION) do
    local seedsprefab = "seeds_"..k.."_l"
    local cropprefab = "plant_"..k.."_l"
    plantables[seedsprefab] = {
        animstate = { bank = "seeds_crop_l", build = "seeds_crop_l", anim = "idle", anim_palcer = nil },
        overrideimage = "seeds_crop_l2",
        floater = {nil, "small", 0.2, 1.2},
        stacksize = TUNING.STACK_SIZE_SMALLITEM,
        fuelvalue = TUNING.SMALL_FUEL,
        burnable = {
            time = TUNING.SMALL_BURNTIME,
            fxsize = "small",
            lightedsize = "small"
        },
        deployable = {
            prefab = cropprefab,
            mode = DEPLOYMODE.PLANT, spacing = DEPLOYSPACING.MEDIUM,
            sound = "dontstarve/wilson/plant_seeds"
        },
        fn_common = function(inst)
            inst:AddTag("deployedplant")
            inst:AddTag("treeseed") --能使其放入种子袋
            -- inst.overridedeployplacername = seedsprefab.."_placer" --这个可以让placer换成另一个

            if v.image ~= nil then
                inst.inv_image_bg = { image = v.image.name, atlas = v.image.atlas }
            else
                inst.inv_image_bg = {}
            end
            if inst.inv_image_bg.image == nil then
                inst.inv_image_bg.image = k..".tex"
            end
            if inst.inv_image_bg.atlas == nil then
                inst.inv_image_bg.atlas = GetInventoryItemAtlas(inst.inv_image_bg.image)
            end

            inst.displaynamefn = function(inst)
                return STRINGS.NAMES[string.upper(cropprefab)]..STRINGS.PLANT_CROP_L["SEEDS"]
            end
        end,
        fn_server = function(inst)
            inst.sivbird_l_food = 0.5 --能给予玄鸟换取子圭石

            inst.components.inspectable.nameoverride = "SEEDS_CROP_L"

            inst:AddComponent("plantablelegion")
            inst.components.plantablelegion.plant = cropprefab
            inst.components.plantablelegion.plant2 = v.plant2 --同一个异种种子可能能升级第二种对象
        end
    }
    table.insert(prefabs, MakePlacer(
        seedsprefab.."_placer", v.bank, v.build, GetPlacerAnim(v.leveldata[1].anim),
        nil, nil, nil, nil, nil, nil, function(inst)
            inst.AnimState:Pause() --不想让placer动起来
            inst.AnimState:OverrideSymbol("soil", "crop_soil_legion", "soil")
            if v.cluster_size ~= nil then
                inst.AnimState:SetScale(v.cluster_size[1], v.cluster_size[1], v.cluster_size[1])
            end
        end
    ))
end

--雨竹块茎placer
table.insert(prefabs, MakePlacer(
    "dug_monstrain_placer", "monstrain", "monstrain", "idle_summer",
    nil, nil, nil, nil, nil, nil, function(inst)
        inst.AnimState:Pause()
        inst.Transform:SetScale(1.4, 1.4, 1.4)
    end
))

--------------------
--------------------

for i, v in pairs(plantables) do
    table.insert(prefabs, MakePlantable(i, v))
    if v.animstate.anim_palcer ~= nil then
        table.insert(prefabs, MakePlacer(i.."_placer", v.animstate.bank, v.animstate.build, v.animstate.anim_palcer))
    end
end

return unpack(prefabs)
