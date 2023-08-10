--------------------------------------------------------------------------
--[[ 无需网络组建功能的特效创建通用函数 ]]
--------------------------------------------------------------------------

local prefs = {}

local function MakeFx(data) --不需要网络功能
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
		nil
	))
end
local function MakeFx2(data) --需要网络功能
    table.insert(prefs, Prefab(
        data.name,
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddNetwork()

            inst:AddTag("FX")

            if data.fn_common ~= nil then
				data.fn_common(inst)
			end

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst.persists = false

            if data.fn_server ~= nil then
				data.fn_server(inst)
			end

            return inst
        end,
        data.assets,
        nil
    ))
end

------

local function OnRemove_followfx(inst)
	for i, v in ipairs(inst.fx) do
		v:Remove()
	end
end
local function CreateNonNetInst(v)
    local inst = CreateEntity()

	--[[Non-networked entity]]
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddFollower()

	inst:AddTag("FX")

	inst.persists = false

    inst:AddComponent("highlightchild") --这个组件是为了同步主体的高亮，达到一致性

    v.fn_anim(inst, v)

	return inst
end
local function SpawnFollowFxForOwner(inst, owner, fxdd)
    inst.fx = {}
    local frame
    for _, v in ipairs(fxdd) do
        local fx = CreateNonNetInst(v)
        if v.randomanim then
            frame = frame or math.random(fx.AnimState:GetCurrentAnimationNumFrames()) - 1
        end
        fx.entity:SetParent(owner.entity)
        fx.Follower:FollowSymbol(owner.GUID, v.symbol, v.x, v.y, v.z, true, nil, v.idx, v.idx2)
        if frame ~= nil then
            fx.AnimState:SetFrame(frame)
        end
        fx.components.highlightchild:SetOwner(owner)
        table.insert(inst.fx, fx)
    end
	inst.OnRemoveEntity = OnRemove_followfx
end
local function MakeFxFollow(data) --绑定式特效
    local function OnEntityReplicated(inst)
		local owner = inst.entity:GetParent()
		if owner ~= nil then
			SpawnFollowFxForOwner(inst, owner, data.fx)
		end
	end
	local function AttachToOwner(inst, owner)
		inst.entity:SetParent(owner.entity)
		--Dedicated server does not need to spawn the local fx
		if not TheNet:IsDedicated() then
			SpawnFollowFxForOwner(inst, owner, data.fx)
		end
	end

    table.insert(prefs, Prefab(
        data.name,
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
		    inst.entity:AddNetwork()

            inst:AddTag("FX")

            if data.fn_common ~= nil then
				data.fn_common(inst)
			end

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                inst.OnEntityReplicated = OnEntityReplicated
                return inst
            end

            inst.persists = false
            inst.AttachToOwner = AttachToOwner

            if data.fn_server ~= nil then
				data.fn_server(inst)
			end

            return inst
        end,
        data.assets,
        nil
    ))
end

---------------
---------------

-- MakeFx({ --盾击：护盾图标
--     name = "shield_protect_l_fx",
--     assets = {
--         Asset("ANIM", "anim/lavaarena_sunder_armor.zip"), --官方的熔炉破甲buff特效动画
--     },
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
        Asset("ANIM", "anim/explode.zip") --官方爆炸特效动画模板
    },
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
MakeFx2({ --风景球：落雪
    name = "icire_rock_fx_day",
    assets = {
        Asset("ANIM", "anim/wintersfeastfuel.zip") --官方节日欢愉动画
    },
    fn_common = function(inst)
        inst.entity:AddFollower()

        inst.AnimState:SetBank("wintersfeastfuel")
        inst.AnimState:SetBuild("icire_rock_day")
        inst.AnimState:PlayAnimation("idle_loop", true)
        inst.AnimState:SetFinalOffset(-1) --Tip: 1最上层，0中间层，-1最下层

        local sc = 1.2
        inst.AnimState:SetScale(sc, sc, sc)
    end,
    -- fn_server = function(inst)end
})

------
--尘世蜃楼
------

MakeFx({ --白木吉他：弹奏时的飘动音符
    name = "guitar_whitewood_doing_fx",
    assets = {
        Asset("ANIM", "anim/guitar_whitewood_doing_fx.zip"),
        Asset("ANIM", "anim/fx_wathgrithr_buff.zip"), --官方战歌特效动画模板
    },
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
MakeFx2({ --幻象法杖：电光(音速起子12)
    name = "pinkstaff_fx_tvplay",
    assets = {
        Asset("ANIM", "anim/skin/pinkstaff_fx_tvplay.zip")
    },
    fn_common = function(inst)
        inst.entity:AddFollower()
        inst.AnimState:SetBank("pinkstaff_fx_tvplay")
        inst.AnimState:SetBuild("pinkstaff_fx_tvplay")
        inst.AnimState:PlayAnimation("idle", true)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetMultColour(115/255, 217/255, 255/255, 0.6)
        inst.AnimState:SetFinalOffset(1)
    end,
    -- fn_server = function(inst)end
})

------
--丰饶传说
------

MakeFx({ --脱壳之翅：逃脱时的茸毛特效
    name = "boltwingout_fx",
    assets = {
        Asset("ANIM", "anim/lavaarena_heal_projectile.zip"), --官方的熔炉奶杖击中特效动画
        Asset("ANIM", "anim/boltwingout_fx.zip"),
    },
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("lavaarena_heal_projectile")
        inst.AnimState:SetBuild("boltwingout_fx")
        inst.AnimState:SetFinalOffset(-1)
        inst.AnimState:PlayAnimation("hit")
    end,
    fn_remove = nil,
})
MakeFx({ --枯叶飞舞：逃脱时的茸毛特效
    name = "boltwingout_fx_disguiser",
    assets = {
        Asset("ANIM", "anim/lavaarena_heal_projectile.zip"), --官方的熔炉奶杖击中特效动画
        Asset("ANIM", "anim/skin/boltwingout_fx_disguiser.zip"),
    },
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
MakeFx({ --爱汪基因诱变舱：基因解锁时的花火特效(橘色)
    name = "siving_turn_future_unlock_fx",
    assets = {
        Asset("ANIM", "anim/table_winters_feast.zip")  --官方节日餐桌动画模板
    },
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("table_winters_feast")
        inst.AnimState:SetBuild("siving_boss_flower_fx")
        inst.AnimState:PlayAnimation("place", false)
        inst.AnimState:OverrideSymbol("glow_2", "table_winters_feast", "glow_2")
        inst.AnimState:OverrideSymbol("sprks", "table_winters_feast", "sprks")
        inst.AnimState:SetMultColour(255/255, 179/255, 109/255, 1)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetLightOverride(1)
        inst.AnimState:SetScale(1.2, 1.2)
        inst.AnimState:SetFinalOffset(4)
    end,
    fn_remove = nil
})
MakeFx({ --爱喵基因诱变舱：基因解锁时的花火特效(淡粉色)
    name = "siving_turn_future2_unlock_fx",
    assets = {
        Asset("ANIM", "anim/table_winters_feast.zip")  --官方节日餐桌动画模板
    },
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("table_winters_feast")
        inst.AnimState:SetBuild("siving_boss_flower_fx")
        inst.AnimState:PlayAnimation("place", false)
        inst.AnimState:OverrideSymbol("glow_2", "table_winters_feast", "glow_2")
        inst.AnimState:OverrideSymbol("sprks", "table_winters_feast", "sprks")
        inst.AnimState:SetMultColour(255/255, 160/255, 221/255, 1)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetLightOverride(1)
        inst.AnimState:SetScale(1.2, 1.2)
        inst.AnimState:SetFinalOffset(4)
    end,
    fn_remove = nil
})
MakeFx({ --旅星猫：投射路径特效
    name = "siving_feather_real_collector_flyfx",
    assets = {
        Asset("ANIM", "anim/gold_nugget.zip"), --官方金块动画
        Asset("ANIM", "anim/skin/siving_feather_collector_fx.zip")
    },
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("goldnugget")
        inst.AnimState:SetBuild("siving_feather_collector_fx")
        inst.AnimState:PlayAnimation("sparkle")
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetFinalOffset(1)
        inst.AnimState:SetFrame(math.random( math.floor(inst.AnimState:GetCurrentAnimationNumFrames()/2) ) - 1)

        if math.random() < 0.4 then
            inst.AnimState:OverrideSymbol("sparkle", "siving_feather_collector_fx", "star2")
        end

        local rand = math.random()
        if rand < 0.2 then
            inst.AnimState:SetMultColour(82/255, 243/255, 255/255, 1)
        elseif rand < 0.4 then
            inst.AnimState:SetMultColour(81/255, 105/255, 165/255, 1)
        end
    end,
    fn_remove = nil
})
MakeFx({ --流星猫：投射路径特效
    name = "siving_feather_fake_collector_flyfx",
    assets = {
        Asset("ANIM", "anim/gold_nugget.zip"), --官方金块动画
        Asset("ANIM", "anim/skin/siving_feather_collector_fx.zip")
    },
    fn_common = nil,
    fn_anim = function(inst)
        inst.AnimState:SetBank("goldnugget")
        inst.AnimState:SetBuild("siving_feather_collector_fx")
        inst.AnimState:PlayAnimation("sparkle")
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetFinalOffset(1)
        inst.AnimState:SetFrame(math.random( math.floor(inst.AnimState:GetCurrentAnimationNumFrames()/2) ) - 1)

        if math.random() < 0.6 then
            inst.AnimState:OverrideSymbol("sparkle", "siving_feather_collector_fx", "star2")
        end

        local rand = math.random()
        if rand < 0.2 then
            inst.AnimState:SetMultColour(255/255, 213/255, 85/255, 1)
        elseif rand < 0.4 then
            inst.AnimState:SetMultColour(141/255, 125/255, 66/255, 1)
        end
    end,
    fn_remove = nil
})

------

local anims_kitcoon = {
    "idle_loop", "idle_loop", "idle_loop", "idle_loop", "idle_loop",
    "idle_loop", "idle_loop", "idle_loop", "idle_loop", "idle_loop",
    "idle_loop", "idle_loop", "idle_loop", "idle_loop", "idle_loop",
    "idle_loop", "idle_loop", "idle_loop", "idle_loop", "idle_loop",
    { "sleep_pre", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_pst" },
    { "sleep_pre", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_loop",  "sleep_pst" },
    { "sleep_pre", "sleep_loop", "sleep_loop", "sleep_pst" },
    "emote_lick", "emote_lick", "emote_lick", "distress", "emote_stretch", "emote_stretch", "emote_stretch",
    { "walk_pre", "walk_pst" },
    { "jump_pre", "jump_loop", "jump_pst" },
    { "jump_pre", "jump_loop", "jump_loop", "jump_pst" },
    "idle_loop", "idle_loop", "idle_loop", "idle_loop", "idle_loop",
    "idle_loop", "idle_loop", "idle_loop", "idle_loop", "idle_loop"
}
local anims_bird = {
    "idle", "idle", "idle", "idle", "idle", "idle", "idle",
    "caw", { "caw", "caw" }, { "caw", "caw", "caw" },
    "peck", { "peck", "peck" }, { "peck", "peck", "peck" },
    "idle", "idle", "idle", "idle", "idle", "idle", "idle",
    { "flap_pre", "flap_loop", "flap_post" },
    { "flap_pre", "flap_loop", "flap_loop", "flap_post" },
    { "flap_pre", "flap_loop", "flap_loop", "flap_loop", "flap_loop", "flap_post" },
    "hop", "hop", "hop", "hop", "hop", "switch", "switch", "switch", "switch",
    "idle", "idle", "idle", "idle", "idle", "idle", "idle",
    { "idle", "idle", "idle" },
    { "idle", "idle", "idle" },
    { "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle", "idle" },
    { "sleep_pre", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_pst" },
    { "sleep_pre", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_loop",  "sleep_pst" },
    { "sleep_pre", "sleep_loop", "sleep_loop", "sleep_pst" },
    "idle", "idle", "idle", "idle", "idle", "idle", "idle"
}
local anims_bird2 = {
    "idle", "idle", "idle", "idle", "idle", "idle", "idle",
    "caw", { "caw", "caw" }, { "caw", "caw", "caw" },
    { "flap_pre", "flap_loop", "flap_post" },
    { "flap_pre", "flap_loop", "flap_loop", "flap_post" },
    { "flap_pre", "flap_loop", "flap_loop", "flap_loop", "flap_loop", "flap_post" },
    "idle", "idle", "idle", "idle", "idle", "idle", "idle",
    "hop", "hop", "hop", "hop", "hop", "switch", "switch", "switch", "switch",
    "hit", "hit", "hit", "attack", "attack", "attack", "attack", "attack",
    "idle", "idle", "idle", "idle", "idle", "idle", "idle",
    { "idle", "idle", "idle" },
    { "idle", "idle", "idle" },
    { "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle", "idle" },
    { "sleep_pre", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_pst" },
    { "sleep_pre", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_loop",  "sleep_pst" },
    { "sleep_pre", "sleep_loop", "sleep_loop", "sleep_pst" },
    "idle", "idle", "idle", "idle", "idle", "idle", "idle"
}
local anims_buzzard = {
    "idle", "idle", "idle", "idle", "idle", "idle", "idle",
    "caw", { "caw", "caw" }, { "caw", "caw", "caw" },
    "peck", { "peck", "peck" }, { "peck", "peck", "peck" },
    { "flap_pre", "flap_loop", "flap_pst" },
    { "flap_pre", "flap_loop", "flap_loop", "flap_pst" },
    { "flap_pre", "flap_loop", "flap_loop", "flap_loop", "flap_loop", "flap_pst" },
    "idle", "idle", "idle", "idle", "idle", "idle", "idle",
    "hop", "hop", "hop", "hop", "hop", "taunt", "taunt", "taunt", "taunt", "taunt",
    "hit", "hit", "hit", "atk", "atk", "atk", "atk", "atk",
    "idle", "idle", "idle", "idle", "idle", "idle", "idle",
    { "idle", "idle", "idle" },
    { "idle", "idle", "idle" },
    { "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle", "idle" },
    { "sleep_pre", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_pst" },
    { "sleep_pre", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_loop",  "sleep_pst" },
    { "sleep_pre", "sleep_loop", "sleep_loop", "sleep_pst" },
    "idle", "idle", "idle", "idle", "idle", "idle", "idle"
}
local anims_smallbird = {
    "idle", "idle", "idle", "idle", "idle", "idle", "idle",
    "idle_blink", "idle_blink", "idle_blink", "idle_blink", "idle_blink", "idle_blink", "idle_blink",
    "atk", "atk", "atk",
    "eat", "eat", "eat", "eat", "eat",
    "call", { "call", "call" }, { "call", "call" },
    "meep", { "meep", "meep" }, { "meep", "meep" },
    "hit", { "hit", "hit" }, { "hit", "hit", "hit" }, { "hit", "hit", "hit", "hit" },
    "idle", "idle", "idle", "idle", "idle", "idle", "idle",
    { "sleep_pre", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_pst" },
    { "sleep_pre", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_loop",  "sleep_pst" },
    { "sleep_pre", "sleep_loop", "sleep_loop", "sleep_pst" },
    "idle", "idle", "idle", "idle", "idle", "idle", "idle",
    { "idle", "idle", "idle" },
    { "idle", "idle", "idle" },
    { "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle", "idle" },
    { "idle", "idle", "idle", "idle", "idle" },
    { "idle", "idle_blink", "idle_blink", "idle" },
    { "idle", "idle_blink", "idle_blink", "idle" },
    { "idle", "idle_blink", "idle_blink", "idle" },
    { "idle", "idle_blink", "idle_blink", "idle" },
    { "walk_pre", "walk_loop", "walk_pst" },
    { "walk_pre", "walk_loop", "walk_loop", "walk_pst" },
    { "walk_pre", "walk_loop", "walk_loop", "walk_pst" },
    { "walk_pre", "walk_loop", "walk_loop", "walk_pst" },
    { "walk_pre", "walk_loop", "walk_loop", "walk_loop", "walk_pst" },
    "idle", "idle", "idle", "idle", "idle", "idle", "idle"
}

------随机仿sg的动画
local function DoSgAnim(inst)
    if inst.skin_l_anims then
        local anim = nil
        local keys = inst.skin_l_keys or {}

        if keys.x == nil then
            keys.x = math.random(#inst.skin_l_anims)
        end
        anim = inst.skin_l_anims[keys.x]
        if type(anim) == "table" then
            if keys.y == nil then
                keys.y = 1
            else
                keys.y = keys.y + 1
            end
            anim = anim[keys.y]
            if anim == nil then
                inst.skin_l_keys = {}
                DoSgAnim(inst)
                return
            end
        else
            keys = {}
        end
        inst.skin_l_keys = keys
        inst.AnimState:PlayAnimation(anim, false)
    end
end
local function SetSgSkinAnim(inst, anims)
    if inst.skin_l_anims == nil then
        inst:ListenForEvent("animover", DoSgAnim) --看起来被装备后，动画会自动暂停。所以我也不用主动关闭监听了
    end
    inst.skin_l_anims = anims
    -- DoSgAnim(inst)
end
-- local function CancelSgSkinAnim(inst)
--     inst.skin_l_anims = nil
--     inst.skin_l_keys = nil
--     inst:RemoveEventCallback("animover", DoSgAnim)
-- end

local function SetAnim_base(inst, data)
    inst.AnimState:SetBank(data.bank or data.build)
    inst.AnimState:SetBuild(data.build)
    if data.animpush ~= nil then
        inst.AnimState:PlayAnimation(data.anim)
        inst.AnimState:PushAnimation(data.animpush, data.isloop)
    else
        inst.AnimState:PlayAnimation(data.anim, data.isloop)
    end
end
local function SetAnim_cat(inst, data)
    inst.Transform:SetSixFaced()
    inst.AnimState:SetBank("kitcoon")
    inst.AnimState:SetBuild(data.build)
    inst.AnimState:PlayAnimation("idle_loop")
    SetSgSkinAnim(inst, anims_kitcoon)
end
local function SetAnim_bird(inst, data)
    inst.entity:AddFollower()
    if data.face == 4 then
        inst.Transform:SetFourFaced()
    else
        inst.Transform:SetTwoFaced()
    end
    inst.AnimState:SetBank(data.bank or "crow")
    inst.AnimState:SetBuild(data.build)
    inst.AnimState:PlayAnimation(data.anim or "land")
    SetSgSkinAnim(inst, data.sg or anims_bird)
end
local function SetAnim_tallbirdegg(inst, data)
    inst.AnimState:SetBank("egg")
    inst.AnimState:SetBuild("tallbird_egg")
    inst.AnimState:PlayAnimation(data.anim, true)
    inst.AnimState:HideSymbol("shdw")
end

MakeFxFollow({ --旅星猫：蓝色猫猫
    name = "sivfea_real_collector_fofx",
    assets = {
        Asset("ANIM", "anim/skin/siving_feather_real_collector.zip"),
        Asset("ANIM", "anim/kitcoon_basic.zip"),  --官方猫咪动画模板
        Asset("ANIM", "anim/kitcoon_emotes.zip"),
        Asset("ANIM", "anim/kitcoon_jump.zip")
    },
    fx = { {
        fn_anim = SetAnim_cat, symbol = "lantern_overlay", x = 18, y = -12, z = 0, randomanim = nil,
        build = "siving_feather_real_collector"
    } }
})
MakeFxFollow({ --流星猫：棕色猫猫
    name = "sivfea_fake_collector_fofx",
    assets = {
        Asset("ANIM", "anim/skin/siving_feather_fake_collector.zip"),
        Asset("ANIM", "anim/kitcoon_basic.zip"),  --官方猫咪动画模板
        Asset("ANIM", "anim/kitcoon_emotes.zip"),
        Asset("ANIM", "anim/kitcoon_jump.zip")
    },
    fx = { {
        fn_anim = SetAnim_cat, symbol = "lantern_overlay", x = 18, y = -12, z = 0, randomanim = nil,
        build = "siving_feather_fake_collector"
    } }
})
MakeFxFollow({ --巫酋血骨面
    name = "sivmask_era_fofx",
    assets = {
        Asset("ANIM", "anim/skin/siving_mask_gold_era.zip")
    },
    fx = {
        {
            fn_anim = SetAnim_base, symbol = "swap_hat", idx = 0,
            build = "siving_mask_gold_era", anim = "idle1", isloop = true
        },
        {
            fn_anim = SetAnim_base, symbol = "swap_hat", idx = 1,
            build = "siving_mask_gold_era", anim = "idle2", isloop = true
        },
        {
            fn_anim = SetAnim_base, symbol = "swap_hat", idx = 2,
            build = "siving_mask_gold_era", anim = "idle3", isloop = true
        }
    }
})
MakeFxFollow({ --巫酋毒骨面
    name = "sivmask_era2_fofx",
    assets = {
        Asset("ANIM", "anim/skin/siving_mask_gold_era2.zip")
    },
    fx = {
        {
            fn_anim = SetAnim_base, symbol = "swap_hat", idx = 0,
            build = "siving_mask_gold_era2", anim = "idle1", isloop = true
        },
        {
            fn_anim = SetAnim_base, symbol = "swap_hat", idx = 1,
            build = "siving_mask_gold_era2", anim = "idle2", isloop = true
        },
        {
            fn_anim = SetAnim_base, symbol = "swap_hat", idx = 2,
            build = "siving_mask_gold_era2", anim = "idle3", isloop = true
        }
    }
})

--各种普通小猫咪
local cats = {
    "kitcoon_forest", "kitcoon_savanna", "kitcoon_deciduous",
    "kitcoon_marsh", "kitcoon_grass", "kitcoon_rocky",
    "kitcoon_desert", "kitcoon_moon", "kitcoon_yot"
}
for _,v in pairs(cats) do
    MakeFxFollow({
        name = v.."_l_fofx",
        assets = {
            Asset("ANIM", "anim/"..v.."_build.zip"),
            Asset("ANIM", "anim/kitcoon_basic.zip"),  --官方猫咪动画模板
            Asset("ANIM", "anim/kitcoon_emotes.zip"),
            Asset("ANIM", "anim/kitcoon_jump.zip")
        },
        fx = { { fn_anim = SetAnim_cat, x = -10, y = -148, z = 0, randomanim = nil, build = v.."_build", symbol = "swap_hat" } }
    })
end
cats = nil

MakeFxFollow({ --乌鸦
    name = "crow_l_fofx",
    assets = {
        Asset("ANIM", "anim/crow.zip"),
        Asset("ANIM", "anim/crow_build.zip")
    },
    fx = { { build = "crow_build", x = -20, y = -148, z = 0, fn_anim = SetAnim_bird, symbol = "swap_hat" } }
})
MakeFxFollow({ --红雀
    name = "robin_l_fofx",
    assets = {
        Asset("ANIM", "anim/crow.zip"),
        Asset("ANIM", "anim/robin_build.zip")
    },
    fx = { { build = "robin_build", x = -20, y = -148, z = 0, fn_anim = SetAnim_bird, symbol = "swap_hat" } }
})
MakeFxFollow({ --雪雀
    name = "robin_winter_l_fofx",
    assets = {
        Asset("ANIM", "anim/crow.zip"),
        Asset("ANIM", "anim/robin_winter_build.zip")
    },
    fx = { { build = "robin_winter_build", x = -20, y = -148, z = 0, fn_anim = SetAnim_bird, symbol = "swap_hat" } }
})
MakeFxFollow({ --金丝雀
    name = "canary_l_fofx",
    assets = {
        Asset("ANIM", "anim/crow.zip"),
        Asset("ANIM", "anim/canary_build.zip")
    },
    fx = { { build = "canary_build", x = -20, y = -148, z = 0, fn_anim = SetAnim_bird, symbol = "swap_hat" } }
})
MakeFxFollow({ --鸽子
    name = "quagmire_pigeon_l_fofx",
    assets = {
        Asset("ANIM", "anim/crow.zip"),
        Asset("ANIM", "anim/quagmire_pigeon_build.zip")
    },
    fx = { { build = "quagmire_pigeon_build", x = -20, y = -148, z = 0, fn_anim = SetAnim_bird, symbol = "swap_hat" } }
})
MakeFxFollow({ --海鹦鹉
    name = "puffin_l_fofx",
    assets = {
        Asset("ANIM", "anim/crow.zip"),
        Asset("ANIM", "anim/puffin_build.zip")
    },
    fx = { { build = "puffin_build", x = -20, y = -148, z = 0, fn_anim = SetAnim_bird, symbol = "swap_hat" } }
})
MakeFxFollow({ --月盲乌鸦
    name = "bird_mutant_l_fofx",
    assets = {
        Asset("ANIM", "anim/mutated_crow.zip"),
        Asset("ANIM", "anim/bird_mutant_build.zip")
    },
    fx = { {
        bank = "mutated_crow", build = "bird_mutant_build", face = 4, sg = anims_bird2,
        x = -20, y = -148, z = 0, fn_anim = SetAnim_bird, symbol = "swap_hat"
    } }
})
MakeFxFollow({ --奇形鸟
    name = "bird_mutant_spitter_l_fofx",
    assets = {
        Asset("ANIM", "anim/mutated_robin.zip"),
        Asset("ANIM", "anim/bird_mutant_spitter_build.zip")
    },
    fx = { {
        bank = "mutated_robin", build = "bird_mutant_spitter_build", face = 4, sg = anims_bird2,
        x = -20, y = -148, z = 0, fn_anim = SetAnim_bird, symbol = "swap_hat"
    } }
})
MakeFxFollow({ --秃鹫
    name = "buzzard_l_fofx",
    assets = {
        Asset("ANIM", "anim/buzzard_build.zip"),
        Asset("ANIM", "anim/buzzard_basic.zip")
    },
    fx = { {
        bank = "buzzard", build = "buzzard_build", face = 4, sg = anims_buzzard,
        x = -10, y = -143, z = 0, fn_anim = SetAnim_bird, symbol = "swap_hat"
    } }
})
MakeFxFollow({ --小高脚鸟
    name = "smallbird_l_fofx",
    assets = {
        Asset("ANIM", "anim/smallbird_basic.zip")
    },
    fx = { {
        bank = "smallbird", build = "smallbird_basic", face = 4, sg = anims_smallbird, anim = "hatch",
        x = -10, y = -138, z = 0, fn_anim = SetAnim_bird, symbol = "swap_hat"
    } }
})
MakeFxFollow({ --便便
    name = "poop_l_fofx",
    assets = {
        Asset("ANIM", "anim/poop.zip"),
        Asset("ANIM", "anim/flies.zip")
    },
    fx = {
        {
            fn_anim = SetAnim_base, symbol = "swap_hat", idx = 0, x = -10, y = -130, z = 0,
            build = "poop", anim = "dump", animpush = "idle", isloop = nil
        },
        {
            fn_anim = SetAnim_base, symbol = "swap_hat", idx = 1, x = -20, y = -130, z = 0,
            build = "poop", anim = "dump", animpush = "idle", isloop = nil
        },
        {
            fn_anim = SetAnim_base, symbol = "swap_hat", idx = 2, x = -15, y = -130, z = 0,
            build = "poop", anim = "dump", animpush = "idle", isloop = nil
        },
        {
            fn_anim = SetAnim_base, symbol = "swap_hat", x = -10, y = -60, z = 0,
            build = "flies", anim = "swarm_pre", animpush = "swarm_loop", isloop = true
        }
    }
})
MakeFxFollow({ --鸟粪
    name = "guano_l_fofx",
    assets = {
        Asset("ANIM", "anim/guano.zip"),
        Asset("ANIM", "anim/flies.zip")
    },
    fx = {
        {
            fn_anim = SetAnim_base, symbol = "swap_hat", idx = 0, x = -10, y = -130, z = 0,
            build = "guano", anim = "dump", animpush = "idle", isloop = nil
        },
        {
            fn_anim = SetAnim_base, symbol = "swap_hat", idx = 1, x = -20, y = -130, z = 0,
            build = "guano", anim = "dump", animpush = "idle", isloop = nil
        },
        {
            fn_anim = SetAnim_base, symbol = "swap_hat", idx = 2, x = -15, y = -130, z = 0,
            build = "guano", anim = "dump", animpush = "idle", isloop = nil
        },
        {
            fn_anim = SetAnim_base, symbol = "swap_hat", x = -10, y = -60, z = 0,
            build = "flies", anim = "swarm_pre", animpush = "swarm_loop", isloop = true
        }
    }
})
MakeFxFollow({ --腐烂物
    name = "spoiled_food_l_fofx",
    assets = {
        Asset("ANIM", "anim/spoiled_food.zip")
    },
    fx = {
        {
            fn_anim = SetAnim_base, symbol = "swap_hat", idx = 0, x = 0, y = -140, z = 0,
            bank = "spoiled", build = "spoiled_food", anim = "idle", isloop = nil
        },
        {
            fn_anim = SetAnim_base, symbol = "swap_hat", idx = 1, x = -10, y = -140, z = 0,
            bank = "spoiled", build = "spoiled_food", anim = "idle", isloop = nil
        },
        {
            fn_anim = SetAnim_base, symbol = "swap_hat", idx = 2, x = -10, y = -140, z = 0,
            bank = "spoiled", build = "spoiled_food", anim = "idle", isloop = nil
        }
    }
})
MakeFxFollow({ --高脚鸟蛋
    name = "tallbirdegg1_l_fofx",
    assets = {
        Asset("ANIM", "anim/tallbird_egg.zip")
    },
    fx = {
        { anim = "idle_happy", fn_anim = SetAnim_tallbirdegg, symbol = "swap_hat", idx = 0, x = -10, y = -145, z = 0 },
        { anim = "idle_happy", fn_anim = SetAnim_tallbirdegg, symbol = "swap_hat", idx = 1, x = -20, y = -145, z = 0 },
        { anim = "idle_happy", fn_anim = SetAnim_tallbirdegg, symbol = "swap_hat", idx = 2, x = -20, y = -145, z = 0 }
    }
})
MakeFxFollow({ --高脚鸟蛋（热）
    name = "tallbirdegg2_l_fofx",
    assets = {
        Asset("ANIM", "anim/tallbird_egg.zip")
    },
    fx = {
        { anim = "idle_hot", fn_anim = SetAnim_tallbirdegg, symbol = "swap_hat", idx = 0, x = -10, y = -145, z = 0 },
        { anim = "idle_hot", fn_anim = SetAnim_tallbirdegg, symbol = "swap_hat", idx = 1, x = -20, y = -145, z = 0 },
        { anim = "idle_hot", fn_anim = SetAnim_tallbirdegg, symbol = "swap_hat", idx = 2, x = -20, y = -145, z = 0 }
    }
})
MakeFxFollow({ --高脚鸟蛋（冷）
    name = "tallbirdegg3_l_fofx",
    assets = {
        Asset("ANIM", "anim/tallbird_egg.zip")
    },
    fx = {
        { anim = "idle_cold", fn_anim = SetAnim_tallbirdegg, symbol = "swap_hat", idx = 0, x = -10, y = -145, z = 0 },
        { anim = "idle_cold", fn_anim = SetAnim_tallbirdegg, symbol = "swap_hat", idx = 1, x = -20, y = -145, z = 0 },
        { anim = "idle_cold", fn_anim = SetAnim_tallbirdegg, symbol = "swap_hat", idx = 2, x = -20, y = -145, z = 0 }
    }
})

---------------
---------------

return unpack(prefs)
