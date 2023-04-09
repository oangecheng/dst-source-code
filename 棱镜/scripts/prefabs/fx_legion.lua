--------------------------------------------------------------------------
--[[ 无需网络组建功能的特效创建通用函数 ]]
--------------------------------------------------------------------------

local prefs = {}

local function MakeFx(data)
	table.insert(prefs, Prefab(
		data.name,
		function()
			local inst = CreateEntity()

			inst.entity:AddTransform()
			inst.entity:AddNetwork()

			--Dedicated server does not need to spawn the local fx
			if not TheNet:IsDedicated() then
				--Delay one frame so that we are positioned properly before starting the effect
				--or in case we are about to be removed
				inst:DoTaskInTime(0, function(proxy)
					local inst2 = CreateEntity()

					--[[Non-networked entity]]

					inst2.entity:AddTransform()
					inst2.entity:AddAnimState()
					inst2.entity:SetCanSleep(false)
					inst2.persists = false

                    inst2:AddTag("FX")

					local parent = proxy.entity:GetParent()
					if parent ~= nil then
						inst2.entity:SetParent(parent.entity)
					end
					inst2.Transform:SetFromProxy(proxy.GUID)

					if data.fn_anim ~= nil then
						data.fn_anim(inst2)
					end

                    if data.fn_remove ~= nil then
						data.fn_remove(inst2)
                    else
                        inst2:ListenForEvent("animover", inst2.Remove)
					end
				end)
			end

            inst:AddTag("FX")

            if data.fn_common ~= nil then
				data.fn_common(inst)
			end

			inst.entity:SetPristine()
			if not TheWorld.ismastersim then
				return inst
			end

			inst.persists = false
			inst:DoTaskInTime(1, inst.Remove)

			return inst
		end,
		data.assets,
		data.prefabs
	))
end

---------------
---------------

-- MakeFx({ --盾击：护盾图标
--     name = "shield_protect_l_fx",
--     assets = {
--         Asset("ANIM", "anim/lavaarena_sunder_armor.zip"), --官方的熔炉破甲buff特效动画
--     },
--     prefabs = nil,
--     fn_common = nil,
--     fn_anim = function(inst)
--         inst.AnimState:SetBank("lavaarena_sunder_armor")
--         inst.AnimState:SetBuild("lavaarena_sunder_armor")
--         inst.AnimState:PlayAnimation("pre")
--         inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
--         inst.AnimState:SetFinalOffset(3)
--         inst.AnimState:SetScale(0.7, 0.7)
--     end,
--     fn_remove = nil,
-- })
MakeFx({ --盾击：盾反成功特效
    name = "shield_attack_l_fx",
    assets = {
        Asset("ANIM", "anim/lavaarena_beetletaur_fx.zip"), --官方的熔炉甲虫猪防御特效动画
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("lavaarena_beetletaur_fx")
        inst.AnimState:SetBuild("lavaarena_beetletaur_fx")
        inst.AnimState:PlayAnimation("defend_fx")
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetFinalOffset(3)
        inst.AnimState:SetScale(0.6, 0.6)
    end,
    fn_remove = nil,
})

MakeFx({ --玫瑰酥：零散的气氛烘托特效
    name = "dish_lovingrosecake1_fx",
    assets = {
        Asset("ANIM", "anim/winters_feast_fx.zip"),  --官方节日餐桌气氛动画模板
        Asset("ANIM", "anim/dish_lovingrosecake_fx.zip")
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("winters_feast_fx")
        inst.AnimState:SetBuild("dish_lovingrosecake_fx")
        inst.AnimState:PlayAnimation(math.random(1, 10), false)
        inst.AnimState:SetMultColour(255/255, 154/255, 200/255, 1)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetLightOverride(1)
    end,
    fn_remove = nil
})
-- MakeFx({ --玫瑰酥：非常多的气氛烘托特效
--     name = "dish_lovingrosecake_s1_fx",
--     assets = {
--         Asset("ANIM", "anim/winters_feast_table_fx.zip"),  --官方节日餐桌食物消失动画模板
--         Asset("ANIM", "anim/dish_lovingrosecake_fx.zip")
--     },
--     prefabs = nil,
--     fn_common = nil,
--     fn_anim = function(inst)
--         inst.AnimState:SetBank("winters_feast_table_fx")
--         inst.AnimState:SetBuild("dish_lovingrosecake_fx")
--         inst.AnimState:PlayAnimation("burst", false)
--         inst.AnimState:SetMultColour(255/255, 154/255, 200/255, 1)
--         inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
--         inst.AnimState:SetScale(1.2, 1.2)
--         inst.AnimState:SetLightOverride(1)
--         inst.AnimState:SetFinalOffset(2)
--     end,
--     fn_remove = nil
-- })
MakeFx({ --玫瑰酥：零散的气氛烘托特效(特殊)
    name = "dish_lovingrosecake2_fx",
    assets = {
        Asset("ANIM", "anim/winters_feast_fx.zip"),  --官方节日餐桌气氛动画模板
        Asset("ANIM", "anim/dish_lovingrosecake2_fx.zip")
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("winters_feast_fx")
        inst.AnimState:SetBuild("dish_lovingrosecake2_fx")
        inst.AnimState:PlayAnimation(math.random(1, 10), false)
        inst.AnimState:SetMultColour(255/255, 68/255, 46/255, 1)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetLightOverride(1)
    end,
    fn_remove = nil
})
MakeFx({ --玫瑰酥：非常多的气氛烘托特效(特殊)
    name = "dish_lovingrosecake_s2_fx",
    assets = {
        Asset("ANIM", "anim/winters_feast_table_fx.zip"),  --官方节日餐桌食物消失动画模板
        Asset("ANIM", "anim/dish_lovingrosecake2_fx.zip")
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("winters_feast_table_fx")
        inst.AnimState:SetBuild("dish_lovingrosecake2_fx")
        inst.AnimState:PlayAnimation("burst", false)
        inst.AnimState:SetMultColour(255/255, 68/255, 46/255, 1)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetScale(1.2, 1.2)
        inst.AnimState:SetLightOverride(1)
        inst.AnimState:SetFinalOffset(2)
    end,
    fn_remove = nil
})

------
--花香四溢
------

MakeFx({ --兰草花剑：飞溅花瓣
    name = "impact_orchid_fx",
    assets = {
        Asset("ANIM", "anim/impact_orchid.zip"),
        Asset("ANIM", "anim/impact.zip"), --官方击中特效动画模板
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("impact")
        inst.AnimState:SetBuild("impact_orchid")
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:SetFinalOffset(1)
    end,
    fn_remove = nil,
})
MakeFx({ --粉色追猎：飞溅花瓣
    name = "impact_orchid_fx_disguiser",
    assets = {
        Asset("ANIM", "anim/lavaarena_heal_projectile.zip"), --官方的熔炉奶杖击中特效动画
        Asset("ANIM", "anim/skin/impact_orchid_fx_disguiser.zip"),
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("lavaarena_heal_projectile")
        inst.AnimState:SetBuild("impact_orchid_fx_disguiser")
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:SetFinalOffset(1)
    end,
    fn_remove = nil,
})
MakeFx({ --铁艺兰珊：飞溅花瓣
    name = "impact_orchid_fx_marble",
    assets = {
        Asset("ANIM", "anim/lavaarena_heal_projectile.zip"), --官方的熔炉奶杖击中特效动画
        Asset("ANIM", "anim/skin/impact_orchid_fx_marble.zip"),
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("lavaarena_heal_projectile")
        inst.AnimState:SetBuild("impact_orchid_fx_marble")
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:SetFinalOffset(1)
    end,
    fn_remove = nil,
})
MakeFx({ --永不凋零：损坏自己庇佑玩家的特效
    name = "neverfade_shield",
    assets = {
        Asset("ANIM", "anim/stalker_shield.zip"), --官方影织者护盾动画模板
        Asset("ANIM", "anim/neverfade_shield.zip"),
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.entity:AddSoundEmitter()
        inst:DoTaskInTime(0, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/together/stalker/shield")
        end)

        inst.AnimState:SetBank("stalker_shield")
        inst.AnimState:SetBuild("neverfade_shield")
        -- inst.AnimState:PlayAnimation("idle"..tostring(math.random(1, 3)))
        inst.AnimState:PlayAnimation("idle1")   --原图太大了，所以我去除了多余的贴图，只用了这个动画里的贴图
        -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        -- inst.AnimState:SetSortOrder(1)
        -- inst.AnimState:SetScale(1.5, 1.5)
        -- inst.AnimState:SetMultColour(140/255, 239/255, 255/255, 1)
        inst.AnimState:SetScale(Vector3(-1, 1, 1):Get())
        inst.AnimState:SetFinalOffset(2)
    end,
    fn_remove = nil,
})
-- MakeFx({ --施咒蔷薇：火花爆炸
--     name = "rosorns_spell_fx",
--     assets = {
--         Asset("ANIM", "anim/lavaarena_firebomb.zip"), --官方熔炉燃烧瓶特效动画模板
--     },
--     prefabs = nil,
--     fn_common = nil,
--     fn_anim = function(inst)
--         inst.AnimState:SetBank("lavaarena_firebomb")
--         inst.AnimState:SetBuild("lavaarena_firebomb")
--         inst.AnimState:PlayAnimation("hitfx")
--         inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
--         inst.AnimState:SetFinalOffset(1)
--         inst.AnimState:SetScale(0.7, 0.7)
--     end,
--     fn_remove = nil,
-- })
-- MakeFx({ --施咒蔷薇：火花爆炸2
--     name = "rosorns_spell_fx",
--     assets = {
--         Asset("ANIM", "anim/lavaarena_heal_projectile.zip"), --官方的熔炉奶杖击中特效动画
--     },
--     prefabs = nil,
--     fn_common = nil,
--     fn_anim = function(inst)
--         inst.AnimState:SetBank("lavaarena_heal_projectile")
--         inst.AnimState:SetBuild("lavaarena_heal_projectile")
--         inst.AnimState:PlayAnimation("hit")
--         inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
--         inst.AnimState:SetFinalOffset(1)
--         -- inst.AnimState:SetScale(0.7, 0.7)
--     end,
--     fn_remove = nil,
-- })
MakeFx({ --贯星剑：闪光炸裂
    name = "rosorns_collector_fx",
    assets = {
        Asset("ANIM", "anim/lavaarena_heal_projectile.zip"), --官方的熔炉奶杖击中特效动画
        Asset("ANIM", "anim/skin/rosorns_collector_fx.zip"),
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("lavaarena_heal_projectile")
        inst.AnimState:SetBuild("rosorns_collector_fx")
        inst.AnimState:PlayAnimation("cast")
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetFinalOffset(1)
    end,
    fn_remove = nil,
})
MakeFx({ --落薇剪：一剪没
    name = "rosorns_marble_fx",
    assets = {
        Asset("ANIM", "anim/boomerang.zip"), --官方的回旋镖动画
        Asset("ANIM", "anim/skin/rosorns_marble_fx.zip"),
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("boomerang")
        inst.AnimState:SetBuild("rosorns_marble_fx")
        inst.AnimState:PlayAnimation("used")
        inst.AnimState:SetFinalOffset(1)
    end,
    fn_remove = nil,
})

------
--祈雨祭
------

MakeFx({ --艾力冈的剑：燃血
    name = "agronssword_fx",
    assets = {
        Asset("ANIM", "anim/lavaarena_boarrior_fx.zip"), --需要官方的动画模板
        Asset("ANIM", "anim/agronssword_fx.zip"),
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("lavaarena_boarrior_fx")
        inst.AnimState:SetBuild("agronssword_fx")
        inst.AnimState:PlayAnimation("ground_hit_1")
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetFinalOffset(1)
    end,
    fn_remove = nil,
})
MakeFx({ --糖霜法棍：燃血
    name = "agronssword_fx_taste",
    assets = {
        Asset("ANIM", "anim/lavaarena_boarrior_fx.zip"), --需要官方的动画模板
        Asset("ANIM", "anim/skin/agronssword_fx_taste.zip")
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("lavaarena_boarrior_fx")
        inst.AnimState:SetBuild("agronssword_fx_taste")
        inst.AnimState:PlayAnimation("ground_hit_1")
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetFinalOffset(1)
    end,
    fn_remove = nil,
})

MakeFx({ --月折宝剑：凝血
    name = "refractedmoonlight_fx",
    assets = {
        Asset("ANIM", "anim/lavaarena_boarrior_fx.zip"),    --需要官方的动画模板
        Asset("ANIM", "anim/refractedmoonlight_fx.zip"),
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("lavaarena_boarrior_fx")
        inst.AnimState:SetBuild("refractedmoonlight_fx")
        inst.AnimState:PlayAnimation("ground_hit_1")
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetFinalOffset(1)
    end,
    fn_remove = nil,
})
MakeFx({ --月轮宝盘：光韵特效
    name = "revolvedmoonlight_fx",
    assets = {
        Asset("ANIM", "anim/terrariumchest_fx.zip"), --官方盒中泰拉箱子的特效
        Asset("ANIM", "anim/revolvedmoonlight_fx.zip")
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("terrariumchest_fx")
        inst.AnimState:SetBuild("revolvedmoonlight_fx")
        inst.AnimState:PlayAnimation("idle_front")
        if math.random() < 0.65 then
            inst.AnimState:SetMultColour(255/255, 249/255, 67/255, 0.9)
        else
            inst.AnimState:SetMultColour(1/255, 251/255, 255/255, 0.6)
        end
        inst.AnimState:SetScale(1.2, 1.2)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetFinalOffset(3)
    end,
    fn_remove = nil,
})

------
--电闪雷鸣
------

MakeFx({ --素白蘑菇帽：作物疾病的治愈时，消散的细菌
    name = "escapinggerms_fx",
    assets = {
        Asset("ANIM", "anim/lavaarena_boarrior_fx.zip"),    --需要官方的动画模板
        Asset("ANIM", "anim/agronssword_fx.zip"),           --套用已有的贴图
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("lavaarena_boarrior_fx")
        inst.AnimState:SetBuild("agronssword_fx")
        inst.AnimState:PlayAnimation("ground_hit_1")
        inst.AnimState:SetFinalOffset(1)
        inst.AnimState:SetMultColour(40/255, 40/255, 40/255, 1)
    end,
    fn_remove = nil,
})
MakeFx({ --素白蘑菇帽：玩家身上不断冒出的孢子
    name = "residualspores_fx",
    assets = {
        Asset("ANIM", "anim/wormwood_pollen_fx.zip"),    --需要官方的动画模板
        Asset("ANIM", "anim/residualspores_fx.zip"),
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("wormwood_pollen_fx")
        inst.AnimState:SetBuild("residualspores_fx")
        inst.AnimState:PlayAnimation("pollen"..math.random(1, 5))
        inst.AnimState:SetFinalOffset(2)

        local rand = math.random()
        if rand < 0.1 then
            inst.AnimState:SetMultColour(237/255, 170/255, 165/255, 1)
        elseif rand < 0.2 then
            inst.AnimState:SetMultColour(172/255, 237/255, 165/255, 1)
        elseif rand < 0.3 then
            inst.AnimState:SetMultColour(165/255, 187/255, 237/255, 1)
        end
    end,
    fn_remove = nil,
})

MakeFx({ --芬布尔斧：击中时贴地扩散的闪电
    name = "fimbul_cracklebase_fx",
    assets = {
        Asset("ANIM", "anim/fimbul_static_fx.zip"),
        Asset("ANIM", "anim/lavaarena_hammer_attack_fx.zip"), --官方熔炉锤子大招特效动画模板
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("lavaarena_hammer_attack_fx")
        inst.AnimState:SetBuild("fimbul_static_fx")
        inst.AnimState:PlayAnimation("crackle_projection")
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        inst.AnimState:SetSortOrder(3)
        inst.AnimState:SetScale(1.3, 1.3)
        inst.AnimState:SetMultColour(140/255, 239/255, 255/255, 1)
    end,
    fn_remove = nil,
})
MakeFx({ --跃星杖：飘散的星星
    name = "fimbul_axe_collector_fx",
    assets = {
        Asset("ANIM", "anim/skin/fimbul_axe_collector.zip"),
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("fimbul_axe_collector")
        inst.AnimState:SetBuild("fimbul_axe_collector")
        inst.AnimState:PlayAnimation("star"..tostring(math.random(4)))
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetFinalOffset(1)
    end,
    fn_remove = nil,
})
MakeFx({ --跃星杖：炸落的星星
    name = "fimbul_axe_collector2_fx",
    assets = {
        Asset("ANIM", "anim/explode.zip"), --官方爆炸特效动画模板
        Asset("ANIM", "anim/skin/fimbul_axe_collector2_fx.zip"),
    },
    prefabs = nil,
    fn_common = function(inst)
        inst.Transform:SetFourFaced()
    end,
    fn_anim = function(inst)
        inst.AnimState:SetBank("explode")
        inst.AnimState:SetBuild("fimbul_axe_collector2_fx")
        inst.AnimState:PlayAnimation("small_firecrackers")
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetLightOverride(1)
        inst.AnimState:SetScale(1.65, 1.65, 1.65)
    end,
    fn_remove = nil,
})
MakeFx({ --跃星杖：扩大的星星
    name = "fimbul_axe_collector3_fx",
    assets = {
        Asset("ANIM", "anim/skin/fimbul_axe_collector3_fx.zip"),
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("fimbul_axe_collector3_fx")
        inst.AnimState:SetBuild("fimbul_axe_collector3_fx")
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:SetScale(1.6, 1.6)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetFinalOffset(1)

        inst.entity:AddSoundEmitter()
        inst.SoundEmitter:PlaySound("dontstarve/common/together/celestial_orb/active")
    end,
    fn_remove = nil,
})
-- MakeFx({ --芬布尔斧：重锤技能电光
--     name = "fimbul_attack_fx",
--     assets = {
--         Asset("ANIM", "anim/fimbul_attack_fx.zip"),
--         Asset("ANIM", "anim/lavaarena_hammer_attack_fx.zip"), --官方熔炉锤子大招特效动画模板
--     },
--     prefabs = nil,
--     fn_common = nil,
--     fn_anim = function(inst)
--         inst.AnimState:SetBank("lavaarena_hammer_attack_fx")
--         inst.AnimState:SetBuild("fimbul_attack_fx")
--         inst.AnimState:PlayAnimation("crackle_hit")
--         inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
--         inst.AnimState:SetSortOrder(1)
--         inst.AnimState:SetScale(1.8, 1.8)
--     end,
--     fn_remove = nil,
-- })
MakeFx({ --重铸boss：远程飞溅攻击特效
    name = "fimbul_teleport_fx",
    assets = {
        Asset("ANIM", "anim/fimbul_teleport_fx.zip"),
        Asset("ANIM", "anim/lavaarena_creature_teleport.zip"), --官方熔炉敌人出场特效动画模板
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("lavaarena_creature_teleport")
        inst.AnimState:SetBuild("fimbul_teleport_fx")
        inst.AnimState:PlayAnimation("spawn_medium")
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetSortOrder(1)

        inst.entity:AddSoundEmitter()
        inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/spark")
        inst.SoundEmitter:PlaySound("dontstarve/common/lava_arena/portal_player")
    end,
    fn_remove = nil,
})
MakeFx({ --重铸boss：战吼时的爆炸
    name = "fimbul_explode_fx",
    assets = {
        Asset("ANIM", "anim/fimbul_explode_fx.zip"),
        Asset("ANIM", "anim/explode.zip"), --官方爆炸特效动画模板
    },
    prefabs = nil,
    fn_common = function(inst)
        inst.Transform:SetFourFaced()
    end,
    fn_anim = function(inst)
        inst.AnimState:SetBank("explode")
        inst.AnimState:SetBuild("fimbul_explode_fx")
        inst.AnimState:PlayAnimation("small")
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetLightOverride(1)
        inst.AnimState:SetScale(3, 3, 3)

        inst.entity:AddSoundEmitter()
        inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo")
    end,
    fn_remove = nil,
})

MakeFx({ --米格尔吉他：飘散的万寿菊花瓣
    name = "guitar_miguel_float_fx",
    assets = {
        Asset("ANIM", "anim/pine_needles.zip"), --官方砍树掉落松针特效
        Asset("ANIM", "anim/guitar_miguel_fx.zip"),
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("pine_needles")
        inst.AnimState:SetBuild("pine_needles")
        inst.AnimState:PlayAnimation(math.random() < 0.5 and "fall" or "chop")
        inst.AnimState:SetSortOrder(1)
        inst.Transform:SetScale(0.6, 0.6, 0.6)
        inst.AnimState:OverrideSymbol("needle", "guitar_miguel_fx", "needle")
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    end,
    fn_remove = nil,
})

MakeFx({ --爆炸水果蛋糕：爆炸特效
    name = "explode_fruitcake",
    assets = {
        Asset("ANIM", "anim/explode.zip"), --官方爆炸特效动画模板
    },
    prefabs = nil,
    fn_common = function(inst)
        inst.Transform:SetFourFaced()
    end,
    fn_anim = function(inst)
        inst.AnimState:SetBank("explode")
        inst.AnimState:SetBuild("explode")
        inst.AnimState:PlayAnimation("small_firecrackers")
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetLightOverride(1)
        inst.AnimState:SetScale(1.4, 1.4, 1.4)

        inst.entity:AddSoundEmitter()
        inst.SoundEmitter:PlaySoundWithParams("dontstarve/common/together/fire_cracker", { start = math.random() })
        inst.SoundEmitter:PlaySound("dontstarve/creatures/slurtle/mound_explode")
    end,
    fn_remove = nil,
})

table.insert(prefs, Prefab(
    "icire_rock_fx_day",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        inst.entity:AddFollower()

        inst.AnimState:SetBank("wintersfeastfuel")
        inst.AnimState:SetBuild("icire_rock_day")
        inst.AnimState:PlayAnimation("idle_loop", true)
        inst.AnimState:SetFinalOffset(-1) --Tip: 1最上层，0中间层，-1最下层

        local sc = 1.2
        inst.AnimState:SetScale(sc, sc, sc)

        inst:AddTag("FX")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false

        return inst
    end,
    {
        Asset("ANIM", "anim/wintersfeastfuel.zip") --官方节日欢愉动画
    },
    nil
))

------
--尘世蜃楼
------

MakeFx({ --白木吉他：弹奏时的飘动音符
    name = "guitar_whitewood_doing_fx",
    assets = {
        Asset("ANIM", "anim/guitar_whitewood_doing_fx.zip"),
        Asset("ANIM", "anim/fx_wathgrithr_buff.zip"), --官方战歌特效动画模板
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        local anims =
        {
            "fx_durability",
            "fx_fireresistance",
            "fx_healthgain",
            "fx_sanitygain",
        }
        inst.AnimState:SetBank("fx_wathgrithr_buff")
        inst.AnimState:SetBuild("fx_wathgrithr_buff")
        inst.AnimState:PlayAnimation(anims[math.random(#anims)])
        inst.AnimState:OverrideSymbol("fx_icon", "guitar_whitewood_doing_fx", "fx_icon")
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    end,
    fn_remove = nil,
})
table.insert(prefs, Prefab( --幻象法杖：电光(音速起子12)
    "pinkstaff_fx_tvplay",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.AnimState:SetBank("pinkstaff_fx_tvplay")
        inst.AnimState:SetBuild("pinkstaff_fx_tvplay")
        inst.AnimState:PlayAnimation("idle", true)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetMultColour(115/255, 217/255, 255/255, 0.6)
        inst.AnimState:SetFinalOffset(1)

        inst:AddTag("FX")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false

        return inst
    end,
    {
        Asset("ANIM", "anim/skin/pinkstaff_fx_tvplay.zip")
    },
    nil
))

------
--丰饶传说
------

MakeFx({ --脱壳之翅：逃脱时的茸毛特效
    name = "boltwingout_fx",
    assets = {
        Asset("ANIM", "anim/lavaarena_heal_projectile.zip"), --官方的熔炉奶杖击中特效动画
        Asset("ANIM", "anim/boltwingout_fx.zip"),
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("lavaarena_heal_projectile")
        inst.AnimState:SetBuild("boltwingout_fx")
        inst.AnimState:SetFinalOffset(-1)
        inst.AnimState:PlayAnimation("hit")
    end,
    fn_remove = nil,
})
MakeFx({ --脱壳之翅：逃脱时的茸毛特效（枯叶飞舞）
    name = "boltwingout_fx_disguiser",
    assets = {
        Asset("ANIM", "anim/lavaarena_heal_projectile.zip"), --官方的熔炉奶杖击中特效动画
        Asset("ANIM", "anim/skin/boltwingout_fx_disguiser.zip"),
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("lavaarena_heal_projectile")
        inst.AnimState:SetBuild("boltwingout_fx_disguiser")
        inst.AnimState:SetFinalOffset(-1)
        inst.AnimState:PlayAnimation("hit")
    end,
    fn_remove = nil,
})
MakeFx({ --子圭·歃：生命转移特效
    name = "life_trans_fx",
    assets = {
        Asset("ANIM", "anim/life_trans_fx.zip"),
        Asset("ANIM", "anim/cursed_fx.zip"), --官方猴子诅咒特效动画模板
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("cursed_fx")
        inst.AnimState:SetBuild("life_trans_fx")
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:OverrideSymbol("monkey_fx_parts", "life_trans_fx", "fx_fur_part") --不想显示这部分
        inst.AnimState:SetFinalOffset(3)
        inst.AnimState:SetScale(0.65, 0.65)
    end,
    fn_remove = nil,
})
MakeFx({ --子圭寄生花：消失特效
    name = "siving_boss_flower_fx",
    assets = {
        Asset("ANIM", "anim/lavaarena_boarrior_fx.zip"), --官方的动画
        Asset("ANIM", "anim/siving_boss_flower_fx.zip"),
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("lavaarena_boarrior_fx")
        inst.AnimState:SetBuild("siving_boss_flower_fx")
        inst.AnimState:PlayAnimation("ground_hit_"..tostring(math.random(3)))
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetFinalOffset(1)
        inst.AnimState:SetMultColour(1/255, 248/255, 255/255, 1)
    end,
    fn_remove = nil,
})
MakeFx({ --魔音绕梁：音波特效
    name = "siving_boss_taunt_fx",
    assets = {
        Asset("ANIM", "anim/bearger_ring_fx.zip"), --官方的动画
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("bearger_ring_fx")
        inst.AnimState:SetBuild("bearger_ring_fx")
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetScale(0.5, 0.5)
        inst.AnimState:SetFinalOffset(3)
        inst.AnimState:SetSortOrder(3)
        inst.AnimState:SetMultColour(111/255, 255/255, 2/255, 0.25)
    end,
    fn_remove = nil,
})
MakeFx({ --花寄语：音波特效
    name = "siving_boss_caw_fx",
    assets = {
        Asset("ANIM", "anim/alterguardian_meteor.zip"), --官方的动画
        Asset("ANIM", "anim/siving_boss_caw_fx.zip")
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("alterguardian_meteor")
        inst.AnimState:SetBuild("siving_boss_caw_fx")
        inst.AnimState:PlayAnimation("meteorground_loop")
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetScale(0.5, 0.5)
        inst.AnimState:SetFinalOffset(3)
        inst.AnimState:SetSortOrder(3)
        inst.AnimState:SetMultColour(1/255, 248/255, 255/255, 0.4)
    end,
    fn_remove = function(inst)
        inst:DoTaskInTime(0.8, function()
            inst:Remove()
        end)
    end,
})
MakeFx({ --子圭石子：碎掉特效
    name = "siving_egg_hatched_fx",
    assets = {
        Asset("ANIM", "anim/siving_egg.zip"),
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("siving_egg")
        inst.AnimState:SetBuild("siving_egg")
        inst.AnimState:PlayAnimation("break")
        inst.AnimState:OverrideSymbol("eggbase", "siving_egg", "egg4")
        inst.AnimState:SetFinalOffset(3)
    end,
    fn_remove = nil,
})
MakeFx({ --子圭·育：基因解锁时的花火特效(蓝绿色)
    name = "siving_turn_unlock_fx",
    assets = {
        Asset("ANIM", "anim/table_winters_feast.zip")  --官方节日餐桌动画模板
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("table_winters_feast")
        inst.AnimState:SetBuild("siving_boss_flower_fx")
        inst.AnimState:PlayAnimation("place", false)
        inst.AnimState:OverrideSymbol("glow_2", "table_winters_feast", "glow_2")
        inst.AnimState:OverrideSymbol("sprks", "table_winters_feast", "sprks")
        inst.AnimState:SetMultColour(40/255, 255/255, 175/255, 1)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetLightOverride(1)
        inst.AnimState:SetScale(1.2, 1.2)
        inst.AnimState:SetFinalOffset(4) --子圭·育果实实体的是 3，所以这里得比3大
    end,
    fn_remove = nil
})
MakeFx({ --转星移：基因解锁时的花火特效(金色)
    name = "siving_turn_collector_unlock_fx",
    assets = {
        Asset("ANIM", "anim/table_winters_feast.zip")  --官方节日餐桌动画模板
    },
    prefabs = nil,
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("table_winters_feast")
        inst.AnimState:SetBuild("siving_boss_flower_fx")
        inst.AnimState:PlayAnimation("place", false)
        inst.AnimState:OverrideSymbol("glow_2", "table_winters_feast", "glow_2")
        inst.AnimState:OverrideSymbol("sprks", "table_winters_feast", "sprks")
        inst.AnimState:SetMultColour(255/255, 234/255, 40/255, 1)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetLightOverride(1)
        inst.AnimState:SetScale(1.2, 1.2)
        inst.AnimState:SetFinalOffset(4)
    end,
    fn_remove = nil
})

---------------
---------------

return unpack(prefs)
