local a = GLOBAL
local b = TheNet:GetIsServer() or TheNet:IsDedicated()
local c = a.CONFIGS_LEGION.LANGUAGES == "chinese"
table.insert(Assets, Asset("ATLAS", "images/icon_skinbar_shadow_l.xml"))
table.insert(Assets, Asset("IMAGE", "images/icon_skinbar_shadow_l.tex"))
table.insert(Assets, Asset("ANIM", "anim/images_minisign_skins1.zip"))
table.insert(Assets, Asset("ANIM", "anim/images_minisign_skins2.zip"))
table.insert(PrefabFiles, "fx_ranimbowspark")
table.insert(PrefabFiles, "skinprefabs_legion")
local d = { "shadowtrail" }
local function e(f)
	local g = f.components.inventoryitem:GetGrandOwner() or f
	if not g.entity:IsVisible() then
		return
	end
	local h, i, j = g.Transform:GetWorldPosition()
	if g.sg ~= nil and g.sg:HasStateTag("moving") then
		local k = -g.Transform:GetRotation() * DEGREES
		local l = g.components.locomotor:GetRunSpeed() * 0.1
		h = h + l * math.cos(k)
		j = j + l * math.sin(k)
	end
	local m = g.components.rider ~= nil and g.components.rider:IsRiding()
	local n = TheWorld.Map
	local o = FindValidPositionByFan(math.random() * 2 * PI, (m and 1 or 0.5) + math.random() * 0.5, 4, function(o)
		local p = Vector3(h + o.x, 0, j + o.z)
		return n:IsPassableAtPoint(p:Get())
			and not n:IsPointNearHole(p)
			and #TheSim:FindEntities(p.x, 0, p.z, 0.7, d) <= 0
	end)
	if o ~= nil then
		SpawnPrefab(f.trail_fx).Transform:SetPosition(h + o.x, 0, j + o.z)
	end
end
local function q(f, r)
	if f.vfx_fx ~= nil then
		if f._vfx_fx_inst == nil then
			f._vfx_fx_inst = SpawnPrefab(f.vfx_fx)
			f._vfx_fx_inst.entity:AddFollower()
		end
		f._vfx_fx_inst.entity:SetParent(r.owner.entity)
		f._vfx_fx_inst.Follower:FollowSymbol(r.owner.GUID, "swap_object", 0, f.vfx_fx_offset or 0, 0)
	end
	if f.trail_fx ~= nil and f._trailtask == nil then
		f._trailtask = f:DoPeriodicTask(6 * FRAMES, e, 2 * FRAMES)
	end
end
local function s(f, g)
	if f._vfx_fx_inst ~= nil then
		f._vfx_fx_inst:Remove()
		f._vfx_fx_inst = nil
	end
	if f._trailtask ~= nil then
		f._trailtask:Cancel()
		f._trailtask = nil
	end
end
local function t(f, r, u)
	f.vfx_fx = r[1] ~= nil and r[1]:len() > 0 and r[1] or nil
	f.trail_fx = r[2]
	if f.vfx_fx ~= nil or f.trail_fx ~= nil then
		f:ListenForEvent("equipped", q)
		f:ListenForEvent("unequipped", s)
		if f.vfx_fx ~= nil then
			f.vfx_fx_offset = u or -105
			f:ListenForEvent("onremove", s)
		end
	end
end
local function v(f)
	f:RemoveEventCallback("equipped", q)
	f:RemoveEventCallback("unequipped", s)
	f:RemoveEventCallback("onremove", s)
end
local function w(f)
	if f.skin_l_anims then
		f.AnimState:PlayAnimation(f.skin_l_anims[math.random(#f.skin_l_anims)], false)
	end
end
local function x(f, y)
	if f.skin_l_anims == nil then
		f:ListenForEvent("animover", w)
	end
	f.skin_l_anims = y
	w(f)
end
local function z(f)
	f.skin_l_anims = nil
	f:RemoveEventCallback("animover", w)
end
local function A(B, C)
	local D = math.random() * 2 * PI
	return B.x + C * math.cos(D), B.y, B.z - C * math.sin(D)
end
local function E(F, G)
	if F.fx ~= nil then
		F.fx.AnimState:SetBank(G)
		F.fx.AnimState:SetBuild(G)
	end
	F.fxdata.skinname = G
end
local function H(f, G, I)
	f.AnimState:SetBank(G)
	f.AnimState:SetBuild(G)
	if f.components.genetrans ~= nil then
		if f.components.genetrans.fxdata.skinname ~= G then
			E(f.components.genetrans, G)
		end
		f.components.genetrans.fxdata.bloom = I
	end
	if I then
		if f.Light:IsEnabled() then
			f.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
		end
	else
		f.AnimState:ClearBloomEffectHandle()
	end
end
local function J(f)
	f.AnimState:SetBank(f._dd.build)
	f.AnimState:SetBuild(f._dd.build)
	if f.components.timer:TimerExists("revolt") then
		f.components.inventoryitem.atlasname = f._dd.img_atlas2
		f.components.inventoryitem:ChangeImageName(f._dd.img_tex2)
	else
		f.components.inventoryitem.atlasname = f._dd.img_atlas
		f.components.inventoryitem:ChangeImageName(f._dd.img_tex)
	end
end
local function K(f, L)
	local M = f._dd_fx
	if M == nil or not M:IsValid() then
		M = SpawnPrefab("icire_rock_fx_day")
	end
	if M ~= nil then
		if L == 1 then
			M.AnimState:OverrideSymbol(
				"snowflake",
				"icire_rock_day",
				math.random() < 0.5 and "flake_crystal" or "flake_snow"
			)
		elseif L == 2 then
			M.AnimState:OverrideSymbol("snowflake", "icire_rock_day", "flake_snow")
		elseif L == 4 then
			M.AnimState:OverrideSymbol(
				"snowflake",
				"icire_rock_day",
				math.random() < 0.5 and "flake_leaf" or "flake_leaf2"
			)
		elseif L == 5 then
			M.AnimState:OverrideSymbol(
				"snowflake",
				"icire_rock_day",
				math.random() < 0.5 and "flake_dust" or "flake_ash"
			)
		else
			M.AnimState:ClearOverrideSymbol("snowflake")
		end
		f:AddChild(M)
		M.Follower:FollowSymbol(f.GUID, "base", 0, -30, 0)
		f._dd_fx = M
	end
end
local function N(f)
	for O, P in ipairs({ "berries", "berriesmore", "berriesmost" }) do
		f.AnimState:Hide(P)
	end
	f.AnimState:Pause()
end
local function Q(f, g, R, S, h, i)
	local M = SpawnPrefab(R)
	if M ~= nil then
		M.entity:SetParent(g.entity)
		M.entity:AddFollower()
		M.Follower:FollowSymbol(g.GUID, S or "swap_object", h or 0, i or 0, 0)
		f.fx_s_l = M
	end
end
local function T(f, g)
	if f.fx_s_l ~= nil then
		f.fx_s_l:Remove()
		f.fx_s_l = nil
	end
end
local U = "ProofOfPurchase"
local V = "Distinguished"
local W = "HeirloomElegant"
a.SKIN_PREFABS_LEGION = {
	rosebush = {
		assets = nil,
		fn_start = function(f)
			f.AnimState:SetBank("berrybush2")
			f.AnimState:SetBuild("rosebush")
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
	},
	lilybush = {
		assets = nil,
		fn_start = function(f)
			f.AnimState:SetBank("berrybush2")
			f.AnimState:SetBuild("lilybush")
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
	},
	orchidbush = {
		assets = nil,
		fn_start = function(f)
			f.AnimState:SetBank("berrybush2")
			f.AnimState:SetBuild("orchidbush")
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
	},
	rosorns = {
		assets = nil,
		image = { name = nil, atlas = nil, setable = true },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "swap_object", build = "swap_rosorns", file = "swap_rosorns" },
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = 0.15, size = "small", offset_y = 0.4, scale = 0.5, nofx = nil },
	},
	lileaves = {
		assets = nil,
		image = { name = nil, atlas = nil, setable = true },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "swap_object", build = "swap_lileaves", file = "swap_lileaves" },
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = 0.15, size = "small", offset_y = 0.4, scale = 0.5, nofx = nil },
	},
	orchitwigs = {
		assets = nil,
		image = { name = nil, atlas = nil, setable = true },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "swap_object", build = "swap_orchitwigs", file = "swap_orchitwigs", atkfx = "impact_orchid_fx" },
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = 0.15, size = "small", offset_y = 0.4, scale = 0.5, nofx = nil },
	},
	neverfade = {
		image = { name = nil, atlas = nil, setable = false },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		fn_start = function(f)
			if f.hasSetBroken then
				f.components.inventoryitem.atlasname = "images/inventoryimages/neverfade_broken.xml"
				f.components.inventoryitem:ChangeImageName("neverfade_broken")
			else
				f.components.inventoryitem.atlasname = "images/inventoryimages/neverfade.xml"
				f.components.inventoryitem:ChangeImageName("neverfade")
			end
		end,
		equip = {
			symbol = "swap_object",
			build = "swap_neverfade",
			file = "swap_neverfade",
			build_broken = "swap_neverfade_broken",
			file_broken = "swap_neverfade_broken",
		},
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = 0.12, size = "med", offset_y = 0.4, scale = 0.5, nofx = nil },
	},
	neverfadebush = {
		fn_start = function(f)
			f.AnimState:SetBank("berrybush2")
			f.AnimState:SetBuild("neverfadebush")
		end,
		exchangefx = { prefab = nil, offset_y = 0.9, scale = nil },
	},
	hat_lichen = {
		assets = nil,
		image = { name = nil, atlas = nil, setable = true },
		anim = { bank = nil, build = nil, anim = "anim", isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "swap_hat", build = "hat_lichen", file = "swap_hat", isopenhat = true },
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = 0.03, size = "med", offset_y = 0.2, scale = 0.5, nofx = nil },
	},
	hat_cowboy = {
		assets = nil,
		image = { name = nil, atlas = nil, setable = true },
		anim = { bank = nil, build = nil, anim = "anim", isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "swap_hat", build = "hat_cowboy", file = "swap_hat" },
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = 0.03, size = "med", offset_y = 0.2, scale = 0.8, nofx = nil },
	},
	pinkstaff = {
		assets = nil,
		image = { name = nil, atlas = nil, setable = true },
		anim = { bank = nil, build = nil, anim = "anim", isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		fn_start = function(f)
			f.fxcolour = { 255 / 255, 80 / 255, 173 / 255 }
		end,
		equip = { symbol = "swap_object", build = "swap_pinkstaff", file = "swap_pinkstaff" },
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = 0.15, size = "small", offset_y = 0.35, scale = 0.5, nofx = nil },
	},
	boltwingout = {
		assets = nil,
		image = { name = nil, atlas = nil, setable = true },
		anim = {
			bank = "swap_boltwingout",
			build = "swap_boltwingout",
			anim = "idle",
			isloop_anim = nil,
			animpush = nil,
			isloop_animpush = nil,
			setable = true,
		},
		equip = { symbol = "swap_body", build = "swap_boltwingout", file = "swap_body" },
		boltdata = { fx = "boltwingout_fx", build = nil },
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = 0.09, size = "small", offset_y = 0.2, scale = 0.45, nofx = nil },
	},
	fishhomingtool_awesome = {
		assets = nil,
		image = { name = nil, atlas = nil, setable = true },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		fn_start = function(f)
			f.components.bundlemaker:SetSkinData()
		end,
		equip = { symbol = "swap_object", build = "fishhomingtool_awesome", file = "swap" },
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
	},
	fishhomingtool_normal = {
		assets = nil,
		image = { name = nil, atlas = nil, setable = true },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		fn_start = function(f)
			f.components.bundlemaker:SetSkinData()
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
	},
	fishhomingbait = {
		fn_start = function(f)
			f.baitimgs_l = {
				dusty = {
					img = "fishhomingbait1",
					atlas = "images/inventoryimages/fishhomingbait1.xml",
					anim = "idle1",
					swap = "swap1",
					symbol = "base1",
					build = "fishhomingbait",
				},
				pasty = {
					img = "fishhomingbait2",
					atlas = "images/inventoryimages/fishhomingbait2.xml",
					anim = "idle2",
					swap = "swap2",
					symbol = "base2",
					build = "fishhomingbait",
				},
				hardy = {
					img = "fishhomingbait3",
					atlas = "images/inventoryimages/fishhomingbait3.xml",
					anim = "idle3",
					swap = "swap3",
					symbol = "base3",
					build = "fishhomingbait",
				},
			}
			f.AnimState:SetBank("fishhomingbait")
			f.AnimState:SetBuild("fishhomingbait")
			if f.components.fishhomingbait and f.components.fishhomingbait.oninitfn then
				f.components.fishhomingbait.oninitfn(f)
			end
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
	},
	icire_rock = {
		fn_start = function(f)
			f.AnimState:SetBank("heat_rock")
			f.AnimState:SetBuild("heat_rock")
			f.AnimState:OverrideSymbol("rock", "icire_rock", "rock")
			f.AnimState:OverrideSymbol("shadow", "icire_rock", "shadow")
			f._dd = nil
			f.fn_temp(f)
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
	},
	shield_l_log = {
		assets = nil,
		image = { name = nil, atlas = nil, setable = true },
		anim = {
			bank = "shield_l_log",
			build = "shield_l_log",
			anim = "idle",
			isloop_anim = nil,
			animpush = nil,
			isloop_animpush = nil,
			setable = true,
		},
		equip = { symbol = nil, build = "shield_l_log", file = "swap_shield" },
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.7 },
		floater = { cut = nil, size = "small", offset_y = 0.2, scale = 0.9, nofx = nil },
	},
	shield_l_sand = {
		assets = nil,
		image = { name = nil, atlas = nil, setable = true },
		anim = {
			bank = "shield_l_sand",
			build = "shield_l_sand",
			anim = "idle",
			isloop_anim = nil,
			animpush = nil,
			isloop_animpush = nil,
			setable = true,
		},
		equip = { symbol = nil, build = "shield_l_sand", file = "swap_shield" },
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
	},
	agronssword = {
		fn_start = function(f)
			f._dd = {
				img_tex = "agronssword",
				img_atlas = "images/inventoryimages/agronssword.xml",
				img_tex2 = "agronssword2",
				img_atlas2 = "images/inventoryimages/agronssword2.xml",
				build = "agronssword",
				fx = "agronssword_fx",
			}
			J(f)
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
	},
	tripleshovelaxe = {
		assets = nil,
		image = { name = nil, atlas = nil, setable = true },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "swap_object", build = "tripleshovelaxe", file = "swap" },
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = nil, size = "med", offset_y = 0.15, scale = 0.4, nofx = nil },
	},
	triplegoldenshovelaxe = {
		assets = nil,
		image = { name = nil, atlas = nil, setable = true },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "swap_object", build = "triplegoldenshovelaxe", file = "swap" },
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = nil, size = "med", offset_y = 0.15, scale = 0.4, nofx = nil },
	},
	backcub = {
		assets = nil,
		image = { name = nil, atlas = nil, setable = true },
		anim = {
			bank = "backcub",
			build = "backcub",
			anim = "anim",
			isloop_anim = true,
			animpush = nil,
			isloop_animpush = nil,
			setable = true,
		},
		equip = { symbol = "swap_body", build = "swap_backcub", file = "swap_body" },
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = {
			cut = nil,
			size = nil,
			offset_y = nil,
			scale = nil,
			nofx = true,
			anim = {
				bank = "backcub",
				build = "backcub",
				anim = "anim_water",
				isloop_anim = true,
				animpush = nil,
				isloop_animpush = nil,
			},
		},
	},
	fimbul_axe = {
		assets = nil,
		image = { name = nil, atlas = nil, setable = true },
		anim = { bank = "boomerang", build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "swap_object", build = "fimbul_axe", file = "swap_base" },
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.5, nofx = nil },
	},
	siving_derivant_lvl0 = {
		assets = nil,
		fn_start = function(f)
			f.AnimState:SetBank("siving_derivants")
			f.AnimState:SetBuild("siving_derivants")
			f.AnimState:SetScale(1.3, 1.3)
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
	},
	siving_derivant_lvl1 = {
		assets = nil,
		fn_start = function(f)
			f.AnimState:SetBank("siving_derivants")
			f.AnimState:SetBuild("siving_derivants")
			f.AnimState:SetScale(1.3, 1.3)
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
	},
	siving_derivant_lvl2 = {
		assets = nil,
		fn_start = function(f)
			f.AnimState:SetBank("siving_derivants")
			f.AnimState:SetBuild("siving_derivants")
			f.AnimState:SetScale(1.3, 1.3)
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
	},
	siving_derivant_lvl3 = {
		assets = nil,
		fn_start = function(f)
			f.AnimState:SetBank("siving_derivants")
			f.AnimState:SetBuild("siving_derivants")
			f.AnimState:SetScale(1.3, 1.3)
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
	},
	siving_turn = {
		fn_start = function(f)
			H(f, "siving_turn", true)
			f.components.genetrans.fxdata.unlockfx = "siving_turn_unlock_fx"
		end,
		fn_fruit = function(F)
			E(F, "siving_turn")
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
	},
	carpet_whitewood = {
		anim = {
			bank = "carpet_whitewood",
			build = "carpet_whitewood",
			anim = "idle",
			isloop_anim = nil,
			animpush = nil,
			isloop_animpush = nil,
			setable = true,
		},
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
	},
	carpet_whitewood_big = {
		anim = {
			bank = "carpet_whitewood",
			build = "carpet_whitewood",
			anim = "idle_big",
			isloop_anim = nil,
			animpush = nil,
			isloop_animpush = nil,
			setable = true,
		},
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
	},
	soul_contracts = {
		image = { name = nil, atlas = nil, setable = true },
		fn_start = function(f)
			f.AnimState:SetBank("book_maxwell")
			f.AnimState:SetBuild("soul_contracts")
			f._dd = { fx = "l_soul_fx" }
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
	},
	siving_feather_real = {
		image = { name = nil, atlas = nil, setable = true },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "swap_object", build = "siving_feather_real", file = "swap" },
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
		floater = { cut = 0.04, size = "small", offset_y = 0.2, scale = 0.5, nofx = nil },
	},
	siving_feather_fake = {
		image = { name = nil, atlas = nil, setable = true },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "swap_object", build = "siving_feather_fake", file = "swap" },
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
		floater = { cut = 0.04, size = "small", offset_y = 0.2, scale = 0.5, nofx = nil },
	},
	revolvedmoonlight_item = {
		image = { name = nil, atlas = nil, setable = true },
		anim = {
			bank = "revolvedmoonlight",
			build = "revolvedmoonlight",
			anim = "idle_item",
			isloop_anim = nil,
			animpush = nil,
			isloop_animpush = nil,
			setable = true,
		},
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
		floater = { cut = 0.18, size = "small", offset_y = 0.4, scale = 0.55, nofx = nil },
	},
	revolvedmoonlight = {
		image = { name = nil, atlas = nil, setable = true },
		fn_start = function(f)
			f.AnimState:SetBank("revolvedmoonlight")
			f.AnimState:SetBuild("revolvedmoonlight")
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
		floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil },
	},
	revolvedmoonlight_pro = {
		image = { name = nil, atlas = nil, setable = true },
		fn_start = function(f)
			f.AnimState:SetBank("revolvedmoonlight")
			f.AnimState:SetBuild("revolvedmoonlight")
			f.AnimState:OverrideSymbol("decorate", "revolvedmoonlight", "decoratepro")
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
		floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.45, nofx = nil },
	},
}
a.SKINS_LEGION = {
	rosebush_marble = {
		base_prefab = "rosebush",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "619108a04c724c6f40e77bd4",
		assets = { Asset("ANIM", "anim/berrybush.zip"), Asset("ANIM", "anim/skin/rosebush_marble.zip") },
		string = c and { name = "理盛赤蔷" } or { name = "Rose Marble Pot" },
		fn_start = function(f)
			f.AnimState:SetBank("berrybush")
			f.AnimState:SetBuild("rosebush_marble")
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
		linkedskins = { rosorns = "rosorns_marble" },
		placer = {
			name = nil,
			bank = "berrybush",
			build = "rosebush_marble",
			anim = "dead",
			prefabs = { "dug_rosebush", "cutted_rosebush" },
		},
	},
	rosorns_marble = {
		base_prefab = "rosorns",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "62e639928c2f781db2f79b3d",
		onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/rosorns_marble.zip"),
			Asset("ATLAS", "images/inventoryimages_skin/foliageath_rosorns_marble.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/foliageath_rosorns_marble.tex"),
		},
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "落薇剪" } or { name = "Falling Petals Scissors" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = true, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "swap_object", build = "rosorns_marble", file = "swap_object" },
		fn_onAttack = function(f, g, X)
			local M = SpawnPrefab("rosorns_marble_fx")
			if M ~= nil then
				M.Transform:SetPosition(X.Transform:GetWorldPosition())
			end
		end,
		scabbard = {
			anim = "idle_cover",
			isloop = true,
			bank = "rosorns_marble",
			build = "rosorns_marble",
			image = "foliageath_rosorns_marble",
			atlas = "images/inventoryimages_skin/foliageath_rosorns_marble.xml",
		},
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = 0.15, size = "small", offset_y = 0.4, scale = 0.5, nofx = nil },
	},
	lilybush_marble = {
		base_prefab = "lilybush",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "619116c74c724c6f40e77c40",
		assets = { Asset("ANIM", "anim/berrybush.zip"), Asset("ANIM", "anim/skin/lilybush_marble.zip") },
		string = c and { name = "理盛截莲" } or { name = "Lily Marble Pot" },
		fn_start = function(f)
			f.AnimState:SetBank("berrybush")
			f.AnimState:SetBuild("lilybush_marble")
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		linkedskins = { lileaves = "lileaves_marble" },
		placer = {
			name = nil,
			bank = "berrybush",
			build = "lilybush_marble",
			anim = "dead",
			prefabs = { "dug_lilybush", "cutted_lilybush" },
		},
	},
	lileaves_marble = {
		base_prefab = "lileaves",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "62e535bd8c2f781db2f79ae7",
		onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/lileaves_marble.zip"),
			Asset("ATLAS", "images/inventoryimages_skin/foliageath_lileaves_marble.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/foliageath_lileaves_marble.tex"),
		},
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "石莲长枪" } or { name = "Marble Lilance" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "swap_object", build = "lileaves_marble", file = "swap_object" },
		scabbard = {
			anim = "idle_cover",
			isloop = nil,
			bank = "lileaves_marble",
			build = "lileaves_marble",
			image = "foliageath_lileaves_marble",
			atlas = "images/inventoryimages_skin/foliageath_lileaves_marble.xml",
		},
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = 0.15, size = "small", offset_y = 0.4, scale = 0.6, nofx = nil },
	},
	orchidbush_marble = {
		base_prefab = "orchidbush",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "6191d0514c724c6f40e77eb9",
		assets = { Asset("ANIM", "anim/berrybush.zip"), Asset("ANIM", "anim/skin/orchidbush_marble.zip") },
		string = c and { name = "理盛瀑兰" } or { name = "Orchid Marble Pot" },
		fn_start = function(f)
			f.AnimState:SetBank("berrybush")
			f.AnimState:SetBuild("orchidbush_marble")
		end,
		exchangefx = { prefab = nil, offset_y = 1.3, scale = nil },
		linkedskins = { orchitwigs = "orchitwigs_marble" },
		placer = {
			name = nil,
			bank = "berrybush",
			build = "orchidbush_marble",
			anim = "dead",
			prefabs = { "dug_orchidbush", "cutted_orchidbush" },
		},
	},
	orchitwigs_marble = {
		base_prefab = "orchitwigs",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "62e61d158c2f781db2f79b1e",
		onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/orchitwigs_marble.zip"),
			Asset("ATLAS", "images/inventoryimages_skin/foliageath_orchitwigs_marble.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/foliageath_orchitwigs_marble.tex"),
		},
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "铁艺兰珊" } or { name = "Ironchid" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "swap_object", build = "orchitwigs_marble", file = "swap_object", atkfx = "impact_orchid_fx_marble" },
		scabbard = {
			anim = "idle_cover",
			isloop = nil,
			bank = "orchitwigs_marble",
			build = "orchitwigs_marble",
			image = "foliageath_orchitwigs_marble",
			atlas = "images/inventoryimages_skin/foliageath_orchitwigs_marble.xml",
		},
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = 0.05, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil },
	},
	orchidbush_disguiser = {
		base_prefab = "orchidbush",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "626029b9c340bf24ab31057a",
		onlyownedshow = true,
		assets = { Asset("ANIM", "anim/berrybush2.zip"), Asset("ANIM", "anim/skin/orchidbush_disguiser.zip") },
		string = c and { name = "粉色猎园" } or { name = "Pink Orchid Bush" },
		fn_start = function(f)
			f.AnimState:SetBank("berrybush2")
			f.AnimState:SetBuild("orchidbush_disguiser")
		end,
		exchangefx = { prefab = nil, offset_y = 1.3, scale = nil },
		linkedskins = { orchitwigs = "orchitwigs_disguiser" },
		placer = {
			name = nil,
			bank = "berrybush2",
			build = "orchidbush_disguiser",
			anim = "dead",
			prefabs = { "dug_orchidbush", "cutted_orchidbush" },
		},
	},
	orchitwigs_disguiser = {
		base_prefab = "orchitwigs",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = V,
		skin_id = "notnononl",
		assets = {
			Asset("ANIM", "anim/skin/orchitwigs_disguiser.zip"),
			Asset("ATLAS", "images/inventoryimages_skin/foliageath_orchitwigs_disguiser.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/foliageath_orchitwigs_disguiser.tex"),
		},
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "粉色追猎" } or { name = "Pink Orchitwigs" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = {
			symbol = "swap_object",
			build = "orchitwigs_disguiser",
			file = "swap_object",
			atkfx = "impact_orchid_fx_disguiser",
		},
		scabbard = {
			anim = "idle_cover",
			isloop = nil,
			bank = "orchitwigs_disguiser",
			build = "orchitwigs_disguiser",
			image = "foliageath_orchitwigs_disguiser",
			atlas = "images/inventoryimages_skin/foliageath_orchitwigs_disguiser.xml",
		},
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = 0.05, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil },
	},
	neverfade_thanks = {
		base_prefab = "neverfade",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = W,
		skin_id = "6191d8f74c724c6f40e77ed0",
		onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/neverfade_thanks.zip"),
			Asset("ANIM", "anim/skin/neverfade_butterfly_thanks.zip"),
			Asset("ATLAS", "images/inventoryimages_skin/neverfade_thanks_broken.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/neverfade_thanks_broken.tex"),
			Asset("ATLAS", "images/inventoryimages_skin/foliageath_neverfade_thanks.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/foliageath_neverfade_thanks.tex"),
		},
		image = { name = nil, atlas = nil, setable = false },
		string = c and { name = "扶伤" } or { name = "FuShang" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		fn_start = function(f)
			if f.hasSetBroken then
				f.components.inventoryitem.atlasname = "images/inventoryimages_skin/neverfade_thanks_broken.xml"
				f.components.inventoryitem:ChangeImageName("neverfade_thanks_broken")
			else
				f.components.inventoryitem.atlasname = "images/inventoryimages_skin/neverfade_thanks.xml"
				f.components.inventoryitem:ChangeImageName("neverfade_thanks")
			end
		end,
		equip = {
			symbol = "swap_object",
			build = "neverfade_thanks",
			file = "normal_swap",
			build_broken = "neverfade_thanks",
			file_broken = "broken_swap",
		},
		scabbard = {
			anim = "idle_cover",
			isloop = nil,
			bank = "neverfade_thanks",
			build = "neverfade_thanks",
			image = "foliageath_neverfade_thanks",
			atlas = "images/inventoryimages_skin/foliageath_neverfade_thanks.xml",
		},
		butterfly = { bank = "butterfly", build = "neverfade_butterfly_thanks" },
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = 0.05, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil },
		linkedskins = { bush = "neverfadebush_thanks" },
		placer = { name = nil, bank = "neverfadebush_thanks", build = "neverfadebush_thanks", anim = "dead", prefabs = nil },
	},
	neverfadebush_thanks = {
		base_prefab = "neverfadebush",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = W,
		skin_id = "6191d8f74c724c6f40e77ed0",
		noshopshow = true,
		assets = { Asset("ANIM", "anim/skin/neverfadebush_thanks.zip") },
		string = { name = c and "扶伤剑冢" or "FuShang Tomb" },
		fn_start = function(f)
			f.AnimState:SetBank("neverfadebush_thanks")
			f.AnimState:SetBuild("neverfadebush_thanks")
		end,
		exchangefx = { prefab = nil, offset_y = 1.2, scale = nil },
		linkedskins = { sword = "neverfade_thanks" },
	},
	neverfade_paper = {
		base_prefab = "neverfade",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = W,
		skin_id = "638362b68c2f781db2f7f524",
		onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/neverfade_paper.zip"),
			Asset("ANIM", "anim/skin/neverfade_butterfly_paper.zip"),
			Asset("ATLAS", "images/inventoryimages_skin/neverfade_paper_broken.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/neverfade_paper_broken.tex"),
			Asset("ATLAS", "images/inventoryimages_skin/foliageath_neverfade_paper.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/foliageath_neverfade_paper.tex"),
		},
		image = { name = nil, atlas = nil, setable = false },
		string = c and { name = "青蝶纸剑" } or { name = "Paper-fly Sword" },
		fn_anim = function(f)
			f.AnimState:SetBank("neverfade_paper")
			f.AnimState:SetBuild("neverfade_paper")
		end,
		fn_start = function(f)
			if f.hasSetBroken then
				f.components.inventoryitem.atlasname = "images/inventoryimages_skin/neverfade_paper_broken.xml"
				f.components.inventoryitem:ChangeImageName("neverfade_paper_broken")
				f.AnimState:PlayAnimation("idle_broken")
			else
				f.components.inventoryitem.atlasname = "images/inventoryimages_skin/neverfade_paper.xml"
				f.components.inventoryitem:ChangeImageName("neverfade_paper")
				f.AnimState:PlayAnimation("idle")
			end
		end,
		equip = {
			symbol = "swap_object",
			build = "neverfade_paper",
			file = "normal_swap",
			build_broken = "neverfade_paper",
			file_broken = "broken_swap",
		},
		scabbard = {
			anim = "idle_cover",
			isloop = nil,
			bank = "neverfade_paper",
			build = "neverfade_paper",
			image = "foliageath_neverfade_paper",
			atlas = "images/inventoryimages_skin/foliageath_neverfade_paper.xml",
		},
		butterfly = { bank = "butterfly", build = "neverfade_butterfly_paper" },
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = 0.05, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil },
		linkedskins = { bush = "neverfadebush_paper" },
		placer = { name = nil, bank = "berrybush2", build = "neverfadebush_paper", anim = "idle", prefabs = nil, fn_init = N },
	},
	neverfadebush_paper = {
		base_prefab = "neverfadebush",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = W,
		skin_id = "638362b68c2f781db2f7f524",
		noshopshow = true,
		assets = { Asset("ANIM", "anim/skin/neverfadebush_paper.zip") },
		string = { name = c and "青蝶纸扇" or "Paper-fly Fan" },
		fn_start = function(f)
			f.AnimState:SetBank("berrybush2")
			f.AnimState:SetBuild("neverfadebush_paper")
		end,
		exchangefx = { prefab = nil, offset_y = 1.2, scale = nil },
		linkedskins = { sword = "neverfade_paper" },
	},
	neverfade_paper2 = {
		base_prefab = "neverfade",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = W,
		skin_id = "638362b68c2f781db2f7f524",
		onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/neverfade_paper2.zip"),
			Asset("ANIM", "anim/skin/neverfade_butterfly_paper2.zip"),
			Asset("ATLAS", "images/inventoryimages_skin/neverfade_paper2_broken.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/neverfade_paper2_broken.tex"),
			Asset("ATLAS", "images/inventoryimages_skin/foliageath_neverfade_paper2.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/foliageath_neverfade_paper2.tex"),
		},
		image = { name = nil, atlas = nil, setable = false },
		string = c and { name = "绀蝶纸剑" } or { name = "Violet Paper-fly Sword" },
		fn_anim = function(f)
			f.AnimState:SetBank("neverfade_paper2")
			f.AnimState:SetBuild("neverfade_paper2")
		end,
		fn_start = function(f)
			if f.hasSetBroken then
				f.components.inventoryitem.atlasname = "images/inventoryimages_skin/neverfade_paper2_broken.xml"
				f.components.inventoryitem:ChangeImageName("neverfade_paper2_broken")
				f.AnimState:PlayAnimation("idle_broken")
			else
				f.components.inventoryitem.atlasname = "images/inventoryimages_skin/neverfade_paper2.xml"
				f.components.inventoryitem:ChangeImageName("neverfade_paper2")
				f.AnimState:PlayAnimation("idle")
			end
		end,
		equip = {
			symbol = "swap_object",
			build = "neverfade_paper2",
			file = "normal_swap",
			build_broken = "neverfade_paper2",
			file_broken = "broken_swap",
		},
		scabbard = {
			anim = "idle_cover",
			isloop = nil,
			bank = "neverfade_paper2",
			build = "neverfade_paper2",
			image = "foliageath_neverfade_paper2",
			atlas = "images/inventoryimages_skin/foliageath_neverfade_paper2.xml",
		},
		butterfly = { bank = "butterfly", build = "neverfade_butterfly_paper2" },
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = 0.05, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil },
		linkedskins = { bush = "neverfadebush_paper2" },
		placer = { name = nil, bank = "berrybush2", build = "neverfadebush_paper2", anim = "idle", prefabs = nil, fn_init = N },
	},
	neverfadebush_paper2 = {
		base_prefab = "neverfadebush",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = W,
		skin_id = "638362b68c2f781db2f7f524",
		noshopshow = true,
		assets = { Asset("ANIM", "anim/skin/neverfadebush_paper2.zip") },
		string = { name = c and "绀蝶纸扇" or "Violet Paper-fly Fan" },
		fn_start = function(f)
			f.AnimState:SetBank("berrybush2")
			f.AnimState:SetBuild("neverfadebush_paper2")
		end,
		exchangefx = { prefab = nil, offset_y = 1.2, scale = nil },
		linkedskins = { sword = "neverfade_paper2" },
	},
	hat_lichen_emo_que = {
		base_prefab = "hat_lichen",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "61909c584c724c6f40e779fa",
		assets = { Asset("ANIM", "anim/skin/hat_lichen_emo_que.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = '"困惑"发卡' } or { name = "Question Hairpin" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "swap_hat", build = "hat_lichen_emo_que", file = "swap_hat", isopenhat = true },
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = 0.03, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil },
	},
	hat_lichen_disguiser = {
		base_prefab = "hat_lichen",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = V,
		skin_id = "notnononl",
		assets = { Asset("ANIM", "anim/skin/hat_lichen_disguiser.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "深渊的星" } or { name = "Abyss Star Hairpin" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = {
			symbol = "swap_hat",
			build = "hat_lichen_disguiser",
			file = "swap_hat",
			isopenhat = false,
			lightcolor = { r = 0, g = 1, b = 1 },
		},
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = 0.03, size = "med", offset_y = 0.2, scale = 0.7, nofx = nil },
	},
	hat_cowboy_tvplay = {
		base_prefab = "hat_cowboy",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = V,
		skin_id = "notnononl",
		assets = { Asset("ANIM", "anim/skin/hat_cowboy_tvplay.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "卡尔的警帽，永远" } or { name = "Carl's Forever Police Cap" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "swap_hat", build = "hat_cowboy_tvplay", file = "swap_hat" },
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = 0.03, size = "med", offset_y = 0.2, scale = 0.8, nofx = nil },
	},
	pinkstaff_tvplay = {
		base_prefab = "pinkstaff",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = V,
		skin_id = "notnononl",
		assets = { Asset("ANIM", "anim/skin/pinkstaff_tvplay.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "音速起子12" } or { name = "Sonic Screwdriver 12" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		fn_start = function(f)
			f.fxcolour = { 115 / 255, 217 / 255, 255 / 255 }
		end,
		equip = { symbol = "swap_object", build = "pinkstaff_tvplay", file = "swap_object" },
		equipfx = {
			start = function(f, g)
				Q(f, g, "pinkstaff_fx_tvplay", "swap_object", 0, -140)
			end,
			stop = T,
		},
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = 0.15, size = "small", offset_y = 0.35, scale = 0.5, nofx = nil },
	},
	boltwingout_disguiser = {
		base_prefab = "boltwingout",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "61c57daadb102b0b8a50ae95",
		assets = {
			Asset("ANIM", "anim/skin/boltwingout_disguiser.zip"),
			Asset("ANIM", "anim/skin/boltwingout_shuck_disguiser.zip"),
		},
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "枯叶飞舞" } or { name = "Fallen Dance" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "swap_body", build = "boltwingout_disguiser", file = "swap_body" },
		boltdata = { fx = "boltwingout_fx_disguiser", build = "boltwingout_shuck_disguiser" },
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = nil, size = "med", offset_y = 0.1, scale = 0.8, nofx = nil },
	},
	fishhomingtool_awesome_thanks = {
		base_prefab = "fishhomingtool_awesome",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = W,
		skin_id = "627f66c0c340bf24ab311783",
		onlyownedshow = true,
		assets = { Asset("ANIM", "anim/skin/fishhomingtool_awesome_thanks.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "云烟" } or { name = "YunYan" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		fn_start = function(f)
			f.components.bundlemaker:SetSkinData("fishhomingbait_thanks", nil)
		end,
		equip = { symbol = "swap_object", build = "fishhomingtool_awesome_thanks", file = "swap" },
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
	},
	fishhomingtool_normal_thanks = {
		base_prefab = "fishhomingtool_normal",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = W,
		skin_id = "627f66c0c340bf24ab311783",
		noshopshow = true,
		assets = { Asset("ANIM", "anim/skin/fishhomingtool_normal_thanks.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = { name = c and "云烟草" or "YunYan Cigarette" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		fn_start = function(f)
			f.components.bundlemaker:SetSkinData("fishhomingbait_thanks", nil)
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
	},
	fishhomingbait_thanks = {
		base_prefab = "fishhomingbait",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = W,
		skin_id = "627f66c0c340bf24ab311783",
		noshopshow = true,
		assets = {
			Asset("ANIM", "anim/pollen_chum.zip"),
			Asset("ANIM", "anim/skin/fishhomingbait_thanks.zip"),
			Asset("ATLAS", "images/inventoryimages_skin/fishhomingbait1_thanks.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/fishhomingbait1_thanks.tex"),
			Asset("ATLAS", "images/inventoryimages_skin/fishhomingbait2_thanks.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/fishhomingbait2_thanks.tex"),
			Asset("ATLAS", "images/inventoryimages_skin/fishhomingbait3_thanks.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/fishhomingbait3_thanks.tex"),
		},
		image = { name = nil, atlas = nil, setable = false },
		string = { name = c and "云烟瓶" or "YunYan Bottle" },
		fn_start = function(f)
			f.baitimgs_l = {
				dusty = {
					img = "fishhomingbait1_thanks",
					atlas = "images/inventoryimages_skin/fishhomingbait1_thanks.xml",
					anim = "idle1",
					swap = "swap1",
					symbol = "base1",
					build = "fishhomingbait_thanks",
				},
				pasty = {
					img = "fishhomingbait2_thanks",
					atlas = "images/inventoryimages_skin/fishhomingbait2_thanks.xml",
					anim = "idle2",
					swap = "swap2",
					symbol = "base2",
					build = "fishhomingbait_thanks",
				},
				hardy = {
					img = "fishhomingbait3_thanks",
					atlas = "images/inventoryimages_skin/fishhomingbait3_thanks.xml",
					anim = "idle3",
					swap = "swap3",
					symbol = "base3",
					build = "fishhomingbait_thanks",
				},
			}
			f.AnimState:SetBank("fishhomingbait_thanks")
			f.AnimState:SetBuild("fishhomingbait_thanks")
			if f.components.fishhomingbait and f.components.fishhomingbait.oninitfn then
				f.components.fishhomingbait.oninitfn(f)
			end
		end,
		baiting = { bank = "pollen_chum", build = "pollen_chum" },
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
	},
	shield_l_log_emo_pride = {
		base_prefab = "shield_l_log",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = V,
		skin_id = "notnononl",
		assets = { Asset("ANIM", "anim/skin/shield_l_log_emo_pride.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "爱上彩虹" } or { name = "Love Rainbow" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "lantern_overlay", build = "shield_l_log_emo_pride", file = "swap_shield" },
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.7 },
		floater = { cut = nil, size = "small", offset_y = 0.2, scale = 0.9, nofx = nil },
		fn_start = function(f)
			t(f, { "fx_ranimbowspark" }, -10)
		end,
		fn_end = v,
	},
	shield_l_log_emo_fist = {
		base_prefab = "shield_l_log",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "629b0d278c2f781db2f77ef8",
		onlyownedshow = true,
		assets = { Asset("ANIM", "anim/skin/shield_l_log_emo_fist.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "重拳出击" } or { name = "Punch Quest" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "lantern_overlay", build = "shield_l_log_emo_fist", file = "swap_shield" },
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.6 },
		floater = { cut = nil, size = "small", offset_y = 0.2, scale = 0.8, nofx = nil },
	},
	shield_l_log_era = {
		base_prefab = "shield_l_log",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "629b0d088c2f781db2f77ef4",
		onlyownedshow = true,
		assets = { Asset("ANIM", "anim/skin/shield_l_log_era.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "洋流之下匍匐" } or { name = "Under Current Crawl" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "lantern_overlay", build = "shield_l_log_era", file = "swap_shield" },
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.7 },
		floater = { cut = nil, size = "small", offset_y = 0.2, scale = 0.8, nofx = nil },
	},
	shield_l_sand_era = {
		base_prefab = "shield_l_sand",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "62845917c340bf24ab311969",
		onlyownedshow = true,
		assets = { Asset("ANIM", "anim/skin/shield_l_sand_era.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "坚硬头骨低鸣" } or { name = "Squealing Skull" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "lantern_overlay", build = "shield_l_sand_era", file = "swap_shield" },
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
	},
	shield_l_sand_op = {
		base_prefab = "shield_l_sand",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = V,
		skin_id = "notnononl",
		assets = { Asset("ANIM", "anim/skin/shield_l_sand_op.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "旧稿" } or { name = "Old Art" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "lantern_overlay", build = "shield_l_sand_op", file = "swap_shield" },
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
	},
	agronssword_taste = {
		base_prefab = "agronssword",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "637f66d88c2f781db2f7f2d0",
		onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/agronssword_taste.zip"),
			Asset("ATLAS", "images/inventoryimages_skin/agronssword_taste.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/agronssword_taste.tex"),
			Asset("ATLAS", "images/inventoryimages_skin/agronssword_taste2.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/agronssword_taste2.tex"),
		},
		string = c and { name = "糖霜法棍" } or { name = "Frosting Baguette" },
		fn_start = function(f)
			f._dd = {
				img_tex = "agronssword_taste",
				img_atlas = "images/inventoryimages_skin/agronssword_taste.xml",
				img_tex2 = "agronssword_taste2",
				img_atlas2 = "images/inventoryimages_skin/agronssword_taste2.xml",
				build = "agronssword_taste",
				fx = "agronssword_fx_taste",
			}
			J(f)
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
	},
	icire_rock_era = {
		base_prefab = "icire_rock",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "6280d4f2c340bf24ab3118b1",
		onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/icire_rock_era.zip"),
			Asset("ATLAS", "images/inventoryimages_skin/icire_rock1_era.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/icire_rock1_era.tex"),
			Asset("ATLAS", "images/inventoryimages_skin/icire_rock2_era.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/icire_rock2_era.tex"),
			Asset("ATLAS", "images/inventoryimages_skin/icire_rock3_era.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/icire_rock3_era.tex"),
			Asset("ATLAS", "images/inventoryimages_skin/icire_rock4_era.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/icire_rock4_era.tex"),
			Asset("ATLAS", "images/inventoryimages_skin/icire_rock5_era.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/icire_rock5_era.tex"),
		},
		image = { name = nil, atlas = nil, setable = false },
		string = c and { name = "被封存的窸窣" } or { name = "Sealed Rustle" },
		fn_start = function(f)
			f.AnimState:SetBank("heat_rock")
			f.AnimState:SetBuild("heat_rock")
			f.AnimState:OverrideSymbol("rock", "icire_rock_era", "rock")
			f.AnimState:OverrideSymbol("shadow", "icire_rock_era", "shadow")
			f._dd = { img_pst = "_era", canbloom = true }
			f.fn_temp(f)
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
	},
	icire_rock_collector = {
		base_prefab = "icire_rock",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = W,
		skin_id = "62df65b58c2f781db2f7998a",
		onlyownedshow = true,
		mustonwedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/icire_rock_collector.zip"),
			Asset("ATLAS", "images/inventoryimages_skin/icire_rock1_collector.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/icire_rock1_collector.tex"),
			Asset("ATLAS", "images/inventoryimages_skin/icire_rock2_collector.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/icire_rock2_collector.tex"),
			Asset("ATLAS", "images/inventoryimages_skin/icire_rock3_collector.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/icire_rock3_collector.tex"),
			Asset("ATLAS", "images/inventoryimages_skin/icire_rock4_collector.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/icire_rock4_collector.tex"),
			Asset("ATLAS", "images/inventoryimages_skin/icire_rock5_collector.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/icire_rock5_collector.tex"),
		},
		image = { name = nil, atlas = nil, setable = false },
		string = c and { name = "占星石" } or { name = "Astrological Stone" },
		fn_start = function(f)
			f.AnimState:SetBank("icire_rock_collector")
			f.AnimState:SetBuild("icire_rock_collector")
			f.AnimState:ClearOverrideSymbol("rock")
			f.AnimState:ClearOverrideSymbol("shadow")
			f._dd = { img_pst = "_collector", canbloom = true }
			f.fn_temp(f)
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
	},
	icire_rock_day = {
		base_prefab = "icire_rock",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "6380cbb88c2f781db2f7f400",
		onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/icire_rock_day.zip"),
			Asset("ATLAS", "images/inventoryimages_skin/icire_rock1_day.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/icire_rock1_day.tex"),
			Asset("ATLAS", "images/inventoryimages_skin/icire_rock2_day.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/icire_rock2_day.tex"),
			Asset("ATLAS", "images/inventoryimages_skin/icire_rock3_day.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/icire_rock3_day.tex"),
			Asset("ATLAS", "images/inventoryimages_skin/icire_rock4_day.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/icire_rock4_day.tex"),
			Asset("ATLAS", "images/inventoryimages_skin/icire_rock5_day.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/icire_rock5_day.tex"),
		},
		image = { name = nil, atlas = nil, setable = false },
		string = c and { name = "风景球" } or { name = "Landscape Ball" },
		fn_start = function(f)
			f.AnimState:SetBank("icire_rock_day")
			f.AnimState:SetBuild("icire_rock_day")
			f.AnimState:ClearOverrideSymbol("rock")
			f.AnimState:ClearOverrideSymbol("shadow")
			f._dd = { img_pst = "_day", canbloom = false, fn_temp = K }
			f.fn_temp(f)
		end,
		fn_end = function(f)
			if f._dd_fx then
				if f._dd_fx:IsValid() then
					f._dd_fx:Remove()
				end
				f._dd_fx = nil
			end
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
	},
	lilybush_era = {
		base_prefab = "lilybush",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "629b0d5f8c2f781db2f77f0d",
		onlyownedshow = true,
		assets = { Asset("ANIM", "anim/berrybush2.zip"), Asset("ANIM", "anim/skin/lilybush_era.zip") },
		string = c and { name = "满布大地婆娑" } or { name = "Platycerium Bush" },
		fn_start = function(f)
			f.AnimState:SetBank("berrybush2")
			f.AnimState:SetBuild("lilybush_era")
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
		linkedskins = { lileaves = "lileaves_era" },
		placer = {
			name = nil,
			bank = "berrybush2",
			build = "lilybush_era",
			anim = "dead",
			prefabs = { "dug_lilybush", "cutted_lilybush" },
		},
	},
	lileaves_era = {
		base_prefab = "lileaves",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "629b0d5f8c2f781db2f77f0d",
		noshopshow = true,
		assets = {
			Asset("ANIM", "anim/skin/lileaves_era.zip"),
			Asset("ATLAS", "images/inventoryimages_skin/foliageath_lileaves_era.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/foliageath_lileaves_era.tex"),
		},
		image = { name = nil, atlas = nil, setable = true },
		string = { name = c and "花叶婆娑" or "Platycerium Leaves" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "swap_object", build = "lileaves_era", file = "swap_object" },
		scabbard = {
			anim = "idle_cover",
			isloop = nil,
			bank = "lileaves_era",
			build = "lileaves_era",
			image = "foliageath_lileaves_era",
			atlas = "images/inventoryimages_skin/foliageath_lileaves_era.xml",
		},
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = 0.05, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil },
	},
	triplegoldenshovelaxe_era = {
		base_prefab = "triplegoldenshovelaxe",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "629b0d848c2f781db2f77f11",
		onlyownedshow = true,
		assets = { Asset("ANIM", "anim/skin/triplegoldenshovelaxe_era.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "长河探索叮咚" } or { name = "Era River Explorer" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "swap_object", build = "triplegoldenshovelaxe_era", file = "swap" },
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = nil, size = "med", offset_y = 0.15, scale = 0.4, nofx = nil },
	},
	tripleshovelaxe_era = {
		base_prefab = "tripleshovelaxe",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "629b0d848c2f781db2f77f11",
		noshopshow = true,
		assets = { Asset("ANIM", "anim/skin/tripleshovelaxe_era.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = { name = c and "谷地发现叮咚" or "Era Valley Explorer" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "swap_object", build = "tripleshovelaxe_era", file = "swap" },
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = nil, size = "med", offset_y = 0.15, scale = 0.4, nofx = nil },
	},
	backcub_fans = {
		base_prefab = "backcub",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = V,
		skin_id = "629cca398c2f781db2f78092",
		onlyownedshow = true,
		mustonwedshow = true,
		assets = { Asset("ANIM", "anim/skin/backcub_fans.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "饭仔" } or { name = "Kid Fan" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "swap_body", build = "backcub_fans", file = "swap_body" },
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = nil, size = "med", offset_y = 0.1, scale = 1.1, nofx = nil },
	},
	backcub_thanks = {
		base_prefab = "backcub",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = W,
		skin_id = "62f235928c2f781db2f7a2dd",
		onlyownedshow = true,
		assets = { Asset("ANIM", "anim/skin/backcub_thanks.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "浮生儿" } or { name = "Foosen" },
		fn_anim = function(f)
			x(f, { "idle1", "idle1", "idle1", "idle2", "idle3", "idle3", "idle4", "idle5" })
		end,
		fn_start = function(f)
			f.AnimState:SetBank("backcub_thanks")
			f.AnimState:SetBuild("backcub_thanks")
		end,
		fn_end = function(f)
			z(f)
		end,
		equip = { symbol = "swap_body", build = "backcub_thanks", file = "swap_body" },
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = {
			cut = nil,
			size = "med",
			offset_y = 0.1,
			scale = 0.9,
			nofx = nil,
			fn_anim = function(f)
				x(
					f,
					{
						"idle1_water",
						"idle1_water",
						"idle1_water",
						"idle2_water",
						"idle3_water",
						"idle3_water",
						"idle4_water",
						"idle5_water",
					}
				)
			end,
		},
	},
	backcub_fans2 = {
		base_prefab = "backcub",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = V,
		skin_id = "6309c6e88c2f781db2f7ae20",
		onlyownedshow = true,
		mustonwedshow = true,
		assets = { Asset("ANIM", "anim/skin/backcub_fans2.zip"), Asset("ANIM", "anim/skin/ui_backcub_fans2_2x6.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "饭豆子" } or { name = "Bean Fan" },
		fn_start = function(f)
			f.AnimState:SetBank("backcub_fans2")
			f.AnimState:SetBuild("backcub_fans2")
			f.components.container:Close()
			f.components.container:WidgetSetup("backcub_fans2")
		end,
		fn_end = function(f)
			z(f)
			f.components.container:Close()
			f.components.container:WidgetSetup("backcub")
		end,
		fn_start_c = function(f)
			f.replica.container:Close()
			f.replica.container:WidgetSetup("backcub_fans2")
		end,
		fn_end_c = function(f)
			f.replica.container:Close()
			f.replica.container:WidgetSetup("backcub")
		end,
		fn_anim = function(f)
			x(f, { "idle1", "idle1", "idle1", "idle1", "idle2", "idle3", "idle3" })
		end,
		equip = { symbol = "swap_body", build = "backcub_fans2", file = "swap_body" },
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = {
			cut = nil,
			size = "med",
			offset_y = 0.1,
			scale = 0.9,
			nofx = nil,
			fn_anim = function(f)
				x(f, { "idle1_water", "idle1_water", "idle1_water", "idle2_water" })
			end,
		},
	},
	rosebush_collector = {
		base_prefab = "rosebush",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = W,
		skin_id = "62e3c3a98c2f781db2f79abc",
		onlyownedshow = true,
		assets = { Asset("ANIM", "anim/berrybush.zip"), Asset("ANIM", "anim/skin/rosebush_collector.zip") },
		string = c and { name = "朽星棘" } or { name = "Star Blighted Thorns" },
		fn_start = function(f)
			f.AnimState:SetBank("berrybush")
			f.AnimState:SetBuild("rosebush_collector")
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
		linkedskins = { rosorns = "rosorns_collector" },
		placer = {
			name = nil,
			bank = "berrybush",
			build = "rosebush_collector",
			anim = "dead",
			prefabs = { "dug_rosebush", "cutted_rosebush" },
		},
	},
	rosorns_collector = {
		base_prefab = "rosorns",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = W,
		skin_id = "62e3c3a98c2f781db2f79abc",
		noshopshow = true,
		assets = {
			Asset("ANIM", "anim/skin/rosorns_collector.zip"),
			Asset("ATLAS", "images/inventoryimages_skin/foliageath_rosorns_collector.xml"),
			Asset("IMAGE", "images/inventoryimages_skin/foliageath_rosorns_collector.tex"),
		},
		image = { name = nil, atlas = nil, setable = true },
		string = { name = c and "贯星剑" or "Star Pierced Sword" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = true, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "swap_object", build = "rosorns_collector", file = "swap_object" },
		fn_onAttack = function(f, g, X)
			local M = SpawnPrefab("rosorns_collector_fx")
			if M ~= nil then
				M.Transform:SetPosition(X.Transform:GetWorldPosition())
			end
		end,
		scabbard = {
			anim = "idle_cover",
			isloop = true,
			bank = "rosorns_collector",
			build = "rosorns_collector",
			image = "foliageath_rosorns_collector",
			atlas = "images/inventoryimages_skin/foliageath_rosorns_collector.xml",
		},
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { nofx = true },
	},
	fimbul_axe_collector = {
		base_prefab = "fimbul_axe",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = W,
		skin_id = "62e775148c2f781db2f79ba1",
		onlyownedshow = true,
		assets = { Asset("ANIM", "anim/skin/fimbul_axe_collector.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "跃星杖" } or { name = "Star Leaping Staff" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = true, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "swap_object", build = "fimbul_axe_collector", file = "swap_base" },
		fn_onThrown = function(f, g, X)
			if g:HasTag("player") then
				g.AnimState:OverrideSymbol("swap_object", "fimbul_axe_collector", "swap_throw")
				g.AnimState:Show("ARM_carry")
				g.AnimState:Hide("ARM_normal")
			end
			if f.task_skinfx ~= nil then
				f.task_skinfx:Cancel()
			end
			f.task_skinfx = f:DoPeriodicTask(0.08, function()
				local M = SpawnPrefab("fimbul_axe_collector_fx")
				if M ~= nil then
					M.Transform:SetPosition(A(f:GetPosition(), 0.2 + math.random() * 1.5))
				end
			end, 0)
		end,
		fn_onLightning = function(f, g, X)
			local h, i, j = X.Transform:GetWorldPosition()
			local M = SpawnPrefab("fimbul_axe_collector2_fx")
			if M ~= nil then
				M.Transform:SetPosition(h, i, j)
			end
			M = SpawnPrefab("fimbul_axe_collector3_fx")
			if M ~= nil then
				M.Transform:SetPosition(h, i, j)
			end
		end,
		fn_onThrownEnd = function(f)
			if f.task_skinfx ~= nil then
				f.task_skinfx:Cancel()
				f.task_skinfx = nil
			end
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.4, nofx = nil },
	},
	siving_turn_collector = {
		base_prefab = "siving_turn",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = W,
		skin_id = "62eb8b9e8c2f781db2f79d21",
		onlyownedshow = true,
		mustonwedshow = true,
		assets = { Asset("ANIM", "anim/skin/siving_turn_collector.zip") },
		image = { name = nil, atlas = nil, setable = false },
		string = c and { name = "转星移" } or { name = "Revolving Star" },
		fn_start = function(f)
			H(f, "siving_turn_collector", false)
			f.components.genetrans.fxdata.unlockfx = "siving_turn_collector_unlock_fx"
		end,
		fn_fruit = function(F)
			E(F, "siving_turn_collector")
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
		fn_setBuildPlacer = function(f)
			f.AnimState:SetBank("siving_turn_collector")
			f.AnimState:SetBuild("siving_turn_collector")
		end,
	},
	siving_derivant_lvl0_thanks = {
		base_prefab = "siving_derivant_lvl0",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = W,
		skin_id = "62eb6e0e8c2f781db2f79cc2",
		onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/siving_derivants_thanks.zip"),
			Asset("ANIM", "anim/skin/siving_derivant_lvl0_thanks.zip"),
		},
		string = c and { name = "梨花开" } or { name = "Snowflake Pine" },
		fn_start = function(f)
			f.AnimState:SetBank("siving_derivants_thanks")
			f.AnimState:SetBuild("siving_derivants_thanks")
			f.AnimState:SetScale(1.3, 1.3)
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
		linkedskins = { down = nil, up = "siving_derivant_lvl1_thanks" },
		placer = {
			name = nil,
			bank = "siving_derivants_thanks",
			build = "siving_derivants_thanks",
			anim = "lvl0",
			prefabs = { "siving_derivant_item" },
		},
	},
	siving_derivant_lvl1_thanks = {
		base_prefab = "siving_derivant_lvl1",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = W,
		skin_id = "62eb6e0e8c2f781db2f79cc2",
		noshopshow = true,
		assets = { Asset("ANIM", "anim/skin/siving_derivants_thanks.zip") },
		string = { name = c and "梨花开" or "Snowflake Pine" },
		fn_start = function(f)
			f.AnimState:SetBank("siving_derivants_thanks")
			f.AnimState:SetBuild("siving_derivants_thanks")
			f.AnimState:SetScale(1.3, 1.3)
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
		linkedskins = { down = "siving_derivant_lvl0_thanks", up = "siving_derivant_lvl2_thanks" },
	},
	siving_derivant_lvl2_thanks = {
		base_prefab = "siving_derivant_lvl2",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = W,
		skin_id = "62eb6e0e8c2f781db2f79cc2",
		noshopshow = true,
		assets = { Asset("ANIM", "anim/skin/siving_derivants_thanks.zip") },
		string = { name = c and "梨花开" or "Snowflake Pine" },
		fn_start = function(f)
			f.AnimState:SetBank("siving_derivants_thanks")
			f.AnimState:SetBuild("siving_derivants_thanks")
			f.AnimState:SetScale(1.3, 1.3)
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
		linkedskins = { down = "siving_derivant_lvl1_thanks", up = "siving_derivant_lvl3_thanks" },
	},
	siving_derivant_lvl3_thanks = {
		base_prefab = "siving_derivant_lvl3",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = W,
		skin_id = "62eb6e0e8c2f781db2f79cc2",
		noshopshow = true,
		assets = { Asset("ANIM", "anim/skin/siving_derivants_thanks.zip") },
		string = { name = c and "梨花开" or "Snowflake Pine" },
		fn_start = function(f)
			f.AnimState:SetBank("siving_derivants_thanks")
			f.AnimState:SetBuild("siving_derivants_thanks")
			f.AnimState:SetScale(1.3, 1.3)
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
		linkedskins = { down = "siving_derivant_lvl2_thanks", up = nil },
	},
	siving_derivant_lvl0_thanks2 = {
		base_prefab = "siving_derivant_lvl0",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = W,
		skin_id = "62eb6e0e8c2f781db2f79cc2",
		noshopshow = true,
		assets = { Asset("ANIM", "anim/skin/siving_derivants_thanks2.zip") },
		string = { name = c and "梨带雨" or "Snowflake Prayer Pine" },
		fn_start = function(f)
			f.AnimState:SetBank("siving_derivants_thanks2")
			f.AnimState:SetBuild("siving_derivants_thanks2")
			f.AnimState:SetScale(1.3, 1.3)
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
		linkedskins = { down = nil, up = "siving_derivant_lvl1_thanks2" },
		placer = {
			name = nil,
			bank = "siving_derivants_thanks2",
			build = "siving_derivants_thanks2",
			anim = "lvl0",
			prefabs = { "siving_derivant_item" },
		},
	},
	siving_derivant_lvl1_thanks2 = {
		base_prefab = "siving_derivant_lvl1",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = W,
		skin_id = "62eb6e0e8c2f781db2f79cc2",
		noshopshow = true,
		assets = { Asset("ANIM", "anim/skin/siving_derivants_thanks2.zip") },
		string = { name = c and "梨带雨" or "Snowflake Prayer Pine" },
		fn_start = function(f)
			f.AnimState:SetBank("siving_derivants_thanks2")
			f.AnimState:SetBuild("siving_derivants_thanks2")
			f.AnimState:SetScale(1.3, 1.3)
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
		linkedskins = { down = "siving_derivant_lvl0_thanks2", up = "siving_derivant_lvl2_thanks2" },
	},
	siving_derivant_lvl2_thanks2 = {
		base_prefab = "siving_derivant_lvl2",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = W,
		skin_id = "62eb6e0e8c2f781db2f79cc2",
		noshopshow = true,
		assets = { Asset("ANIM", "anim/skin/siving_derivants_thanks2.zip") },
		string = { name = c and "梨带雨" or "Snowflake Prayer Pine" },
		fn_start = function(f)
			f.AnimState:SetBank("siving_derivants_thanks2")
			f.AnimState:SetBuild("siving_derivants_thanks2")
			f.AnimState:SetScale(1.3, 1.3)
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
		linkedskins = { down = "siving_derivant_lvl1_thanks2", up = "siving_derivant_lvl3_thanks2" },
	},
	siving_derivant_lvl3_thanks2 = {
		base_prefab = "siving_derivant_lvl3",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = W,
		skin_id = "62eb6e0e8c2f781db2f79cc2",
		noshopshow = true,
		assets = { Asset("ANIM", "anim/skin/siving_derivants_thanks2.zip") },
		string = { name = c and "梨带雨" or "Snowflake Prayer Pine" },
		fn_start = function(f)
			f.AnimState:SetBank("siving_derivants_thanks2")
			f.AnimState:SetBuild("siving_derivants_thanks2")
			f.AnimState:SetScale(1.3, 1.3)
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
		linkedskins = { down = "siving_derivant_lvl2_thanks2", up = nil },
	},
	carpet_whitewood_law = {
		base_prefab = "carpet_whitewood",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "63805cf58c2f781db2f7f34b",
		onlyownedshow = true,
		assets = { Asset("ANIM", "anim/skin/carpet_whitewood_law.zip") },
		image = { name = nil, atlas = nil, setable = false },
		string = c and { name = "小西洋棋棋盘" } or { name = "Quarter Chessboard" },
		anim = {
			bank = "carpet_whitewood_law",
			build = "carpet_whitewood_law",
			anim = "idle",
			isloop_anim = nil,
			animpush = nil,
			isloop_animpush = nil,
			setable = true,
		},
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		fn_setBuildPlacer = function(f)
			f.AnimState:SetBank("carpet_whitewood_law")
			f.AnimState:SetBuild("carpet_whitewood_law")
		end,
	},
	carpet_whitewood_big_law = {
		base_prefab = "carpet_whitewood_big",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "63805cf58c2f781db2f7f34b",
		noshopshow = true,
		assets = { Asset("ANIM", "anim/skin/carpet_whitewood_law.zip") },
		image = { name = nil, atlas = nil, setable = false },
		string = c and { name = "西洋棋棋盘" } or { name = "Chessboard" },
		anim = {
			bank = "carpet_whitewood_law",
			build = "carpet_whitewood_law",
			anim = "idle_big",
			isloop_anim = nil,
			animpush = nil,
			isloop_animpush = nil,
			setable = true,
		},
		fn_start = function(f)
			f.AnimState:SetScale(1.08, 1.08, 1.08)
		end,
		fn_end = function(f)
			f.AnimState:SetScale(1, 1, 1)
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		fn_setBuildPlacer = function(f)
			f.AnimState:SetBank("carpet_whitewood_law")
			f.AnimState:SetBuild("carpet_whitewood_law")
			f.AnimState:SetScale(1.08, 1.08, 1.08)
		end,
	},
	carpet_whitewood_law2 = {
		base_prefab = "carpet_whitewood",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "63805d098c2f781db2f7f34f",
		onlyownedshow = true,
		assets = { Asset("ANIM", "anim/skin/carpet_whitewood_law2.zip") },
		image = { name = nil, atlas = nil, setable = false },
		string = c and { name = "小西洋棋黑棋盘" } or { name = "Quarter Black Chessboard" },
		anim = {
			bank = "carpet_whitewood_law2",
			build = "carpet_whitewood_law2",
			anim = "idle",
			isloop_anim = nil,
			animpush = nil,
			isloop_animpush = nil,
			setable = true,
		},
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		fn_setBuildPlacer = function(f)
			f.AnimState:SetBank("carpet_whitewood_law2")
			f.AnimState:SetBuild("carpet_whitewood_law2")
		end,
	},
	carpet_whitewood_big_law2 = {
		base_prefab = "carpet_whitewood_big",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "63805d098c2f781db2f7f34f",
		noshopshow = true,
		assets = { Asset("ANIM", "anim/skin/carpet_whitewood_law2.zip") },
		image = { name = nil, atlas = nil, setable = false },
		string = c and { name = "西洋棋黑棋盘" } or { name = "Black Chessboard" },
		anim = {
			bank = "carpet_whitewood_law2",
			build = "carpet_whitewood_law2",
			anim = "idle_big",
			isloop_anim = nil,
			animpush = nil,
			isloop_animpush = nil,
			setable = true,
		},
		fn_start = function(f)
			f.AnimState:SetScale(1.08, 1.08, 1.08)
		end,
		fn_end = function(f)
			f.AnimState:SetScale(1, 1, 1)
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
		fn_setBuildPlacer = function(f)
			f.AnimState:SetBank("carpet_whitewood_law2")
			f.AnimState:SetBuild("carpet_whitewood_law2")
			f.AnimState:SetScale(1.08, 1.08, 1.08)
		end,
	},
	soul_contracts_taste = {
		base_prefab = "soul_contracts",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "638074368c2f781db2f7f374",
		onlyownedshow = true,
		assets = { Asset("ANIM", "anim/skin/soul_contracts_taste.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "芝士三明治" } or { name = "Cheese Sandwich" },
		fn_start = function(f)
			f.AnimState:SetBank("book_maxwell")
			f.AnimState:SetBuild("soul_contracts_taste")
			f._dd = { fx = "l_soul_fx_taste" }
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = nil },
	},
	siving_feather_real_paper = {
		base_prefab = "siving_feather_real",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "6387156a8c2f781db2f7f670",
		onlyownedshow = true,
		assets = { Asset("ANIM", "anim/skin/siving_feather_real_paper.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "十字纸镖" } or { name = "Cross Paper Dart" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "lantern_overlay", build = "siving_feather_real_paper", file = "swap", isshield = true },
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
		floater = { cut = 0.04, size = "small", offset_y = 0.2, scale = 0.5, nofx = nil },
	},
	siving_feather_fake_paper = {
		base_prefab = "siving_feather_fake",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "6387156a8c2f781db2f7f670",
		noshopshow = true,
		assets = { Asset("ANIM", "anim/skin/siving_feather_fake_paper.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "四方纸镖" } or { name = "Square Paper Dart" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		equip = { symbol = "lantern_overlay", build = "siving_feather_fake_paper", file = "swap", isshield = true },
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
		floater = { cut = 0.04, size = "small", offset_y = 0.2, scale = 0.5, nofx = nil },
	},
	revolvedmoonlight_item_taste = {
		base_prefab = "revolvedmoonlight_item",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "63889eaf8c2f781db2f7f763",
		onlyownedshow = true,
		assets = { Asset("ANIM", "anim/skin/revolvedmoonlight_item_taste.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "芒果甜筒" } or { name = "Mango Cone" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
		linkedskins = { item = "revolvedmoonlight_taste", item_pro = "revolvedmoonlight_pro_taste" },
		floater = { cut = 0.18, size = "small", offset_y = 0.4, scale = 0.55, nofx = nil },
	},
	revolvedmoonlight_taste = {
		base_prefab = "revolvedmoonlight",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "63889eaf8c2f781db2f7f763",
		noshopshow = true,
		assets = {
			Asset("ANIM", "anim/skin/revolvedmoonlight_taste.zip"),
			Asset("ANIM", "anim/skin/ui_revolvedmoonlight_taste_4x3.zip"),
		},
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "芒果冰" } or { name = "Mango Ice Cream" },
		fn_start = function(f)
			f.AnimState:SetScale(0.85, 0.85, 0.85)
			f.AnimState:SetBank("revolvedmoonlight_taste")
			f.AnimState:SetBuild("revolvedmoonlight_taste")
			f.components.container:Close()
			f.components.container:WidgetSetup("revolvedmoonlight_taste")
		end,
		fn_end = function(f)
			f.AnimState:SetScale(1, 1, 1)
			f.components.container:Close()
			f.components.container:WidgetSetup("revolvedmoonlight")
		end,
		fn_start_c = function(f)
			f.replica.container:Close()
			f.replica.container:WidgetSetup("revolvedmoonlight_taste")
		end,
		fn_end_c = function(f)
			f.replica.container:Close()
			f.replica.container:WidgetSetup("revolvedmoonlight")
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
		linkedskins = { item = "revolvedmoonlight_item_taste" },
		floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil },
	},
	revolvedmoonlight_pro_taste = {
		base_prefab = "revolvedmoonlight_pro",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "63889eaf8c2f781db2f7f763",
		noshopshow = true,
		assets = { Asset("ANIM", "anim/skin/revolvedmoonlight_pro_taste.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "黄桃芒芒" } or { name = "Mango Sundae" },
		fn_start = function(f)
			f.AnimState:SetScale(0.85, 0.85, 0.85)
			f.AnimState:SetBank("revolvedmoonlight_pro_taste")
			f.AnimState:SetBuild("revolvedmoonlight_taste")
			f.components.container:Close()
			f.components.container:WidgetSetup("revolvedmoonlight_pro_taste")
		end,
		fn_end = function(f)
			f.AnimState:SetScale(1, 1, 1)
			f.components.container:Close()
			f.components.container:WidgetSetup("revolvedmoonlight_pro")
		end,
		fn_start_c = function(f)
			f.replica.container:Close()
			f.replica.container:WidgetSetup("revolvedmoonlight_pro_taste")
		end,
		fn_end_c = function(f)
			f.replica.container:Close()
			f.replica.container:WidgetSetup("revolvedmoonlight_pro")
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
		linkedskins = { item = "revolvedmoonlight_item_taste" },
		floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil },
	},
	revolvedmoonlight_item_taste2 = {
		base_prefab = "revolvedmoonlight_item",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "63889ecd8c2f781db2f7f768",
		onlyownedshow = true,
		assets = { Asset("ANIM", "anim/skin/revolvedmoonlight_item_taste2.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "草莓甜筒" } or { name = "Strawberry Cone" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
		linkedskins = { item = "revolvedmoonlight_taste2", item_pro = "revolvedmoonlight_pro_taste2" },
		floater = { cut = 0.18, size = "small", offset_y = 0.4, scale = 0.55, nofx = nil },
	},
	revolvedmoonlight_taste2 = {
		base_prefab = "revolvedmoonlight",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "63889ecd8c2f781db2f7f768",
		noshopshow = true,
		assets = {
			Asset("ANIM", "anim/skin/revolvedmoonlight_taste2.zip"),
			Asset("ANIM", "anim/skin/ui_revolvedmoonlight_taste2_4x3.zip"),
		},
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "草莓冰" } or { name = "Strawberry Ice Cream" },
		fn_start = function(f)
			f.AnimState:SetScale(0.85, 0.85, 0.85)
			f.AnimState:SetBank("revolvedmoonlight_taste2")
			f.AnimState:SetBuild("revolvedmoonlight_taste")
			f.components.container:Close()
			f.components.container:WidgetSetup("revolvedmoonlight_taste2")
		end,
		fn_end = function(f)
			f.AnimState:SetScale(1, 1, 1)
			f.components.container:Close()
			f.components.container:WidgetSetup("revolvedmoonlight")
		end,
		fn_start_c = function(f)
			f.replica.container:Close()
			f.replica.container:WidgetSetup("revolvedmoonlight_taste2")
		end,
		fn_end_c = function(f)
			f.replica.container:Close()
			f.replica.container:WidgetSetup("revolvedmoonlight")
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
		linkedskins = { item = "revolvedmoonlight_item_taste2" },
		floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil },
	},
	revolvedmoonlight_pro_taste2 = {
		base_prefab = "revolvedmoonlight_pro",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "63889ecd8c2f781db2f7f768",
		noshopshow = true,
		assets = { Asset("ANIM", "anim/skin/revolvedmoonlight_pro_taste2.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "巧遇莓莓" } or { name = "Strawberry Sundae" },
		fn_start = function(f)
			f.AnimState:SetScale(0.85, 0.85, 0.85)
			f.AnimState:SetBank("revolvedmoonlight_pro_taste2")
			f.AnimState:SetBuild("revolvedmoonlight_taste")
			f.components.container:Close()
			f.components.container:WidgetSetup("revolvedmoonlight_pro_taste2")
		end,
		fn_end = function(f)
			f.AnimState:SetScale(1, 1, 1)
			f.components.container:Close()
			f.components.container:WidgetSetup("revolvedmoonlight_pro")
		end,
		fn_start_c = function(f)
			f.replica.container:Close()
			f.replica.container:WidgetSetup("revolvedmoonlight_pro_taste2")
		end,
		fn_end_c = function(f)
			f.replica.container:Close()
			f.replica.container:WidgetSetup("revolvedmoonlight_pro")
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
		linkedskins = { item = "revolvedmoonlight_item_taste2" },
		floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil },
	},
	revolvedmoonlight_item_taste3 = {
		base_prefab = "revolvedmoonlight_item",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "63889eef8c2f781db2f7f76c",
		onlyownedshow = true,
		assets = { Asset("ANIM", "anim/skin/revolvedmoonlight_item_taste3.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "柠檬甜筒" } or { name = "Lemon Cone" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
		linkedskins = { item = "revolvedmoonlight_taste3", item_pro = "revolvedmoonlight_pro_taste3" },
		floater = { cut = 0.18, size = "small", offset_y = 0.4, scale = 0.55, nofx = nil },
	},
	revolvedmoonlight_taste3 = {
		base_prefab = "revolvedmoonlight",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "63889eef8c2f781db2f7f76c",
		noshopshow = true,
		assets = {
			Asset("ANIM", "anim/skin/revolvedmoonlight_taste3.zip"),
			Asset("ANIM", "anim/skin/ui_revolvedmoonlight_taste3_4x3.zip"),
		},
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "柠檬冰" } or { name = "Lemon Ice Cream" },
		fn_start = function(f)
			f.AnimState:SetScale(0.85, 0.85, 0.85)
			f.AnimState:SetBank("revolvedmoonlight_taste3")
			f.AnimState:SetBuild("revolvedmoonlight_taste")
			f.components.container:Close()
			f.components.container:WidgetSetup("revolvedmoonlight_taste3")
		end,
		fn_end = function(f)
			f.AnimState:SetScale(1, 1, 1)
			f.components.container:Close()
			f.components.container:WidgetSetup("revolvedmoonlight")
		end,
		fn_start_c = function(f)
			f.replica.container:Close()
			f.replica.container:WidgetSetup("revolvedmoonlight_taste3")
		end,
		fn_end_c = function(f)
			f.replica.container:Close()
			f.replica.container:WidgetSetup("revolvedmoonlight")
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
		linkedskins = { item = "revolvedmoonlight_item_taste3" },
		floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil },
	},
	revolvedmoonlight_pro_taste3 = {
		base_prefab = "revolvedmoonlight_pro",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "63889eef8c2f781db2f7f76c",
		noshopshow = true,
		assets = { Asset("ANIM", "anim/skin/revolvedmoonlight_pro_taste3.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "奇异柠檬" } or { name = "Lemon Sundae" },
		fn_start = function(f)
			f.AnimState:SetScale(0.85, 0.85, 0.85)
			f.AnimState:SetBank("revolvedmoonlight_pro_taste3")
			f.AnimState:SetBuild("revolvedmoonlight_taste")
			f.components.container:Close()
			f.components.container:WidgetSetup("revolvedmoonlight_pro_taste3")
		end,
		fn_end = function(f)
			f.AnimState:SetScale(1, 1, 1)
			f.components.container:Close()
			f.components.container:WidgetSetup("revolvedmoonlight_pro")
		end,
		fn_start_c = function(f)
			f.replica.container:Close()
			f.replica.container:WidgetSetup("revolvedmoonlight_pro_taste3")
		end,
		fn_end_c = function(f)
			f.replica.container:Close()
			f.replica.container:WidgetSetup("revolvedmoonlight_pro")
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
		linkedskins = { item = "revolvedmoonlight_item_taste3" },
		floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil },
	},
	revolvedmoonlight_item_taste4 = {
		base_prefab = "revolvedmoonlight_item",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "63889f4b8c2f781db2f7f770",
		onlyownedshow = true,
		assets = { Asset("ANIM", "anim/skin/revolvedmoonlight_item_taste4.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "黑巧甜筒" } or { name = "Choccy Cone" },
		anim = { bank = nil, build = nil, anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil, setable = true },
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
		linkedskins = { item = "revolvedmoonlight_taste4", item_pro = "revolvedmoonlight_pro_taste4" },
		floater = { cut = 0.18, size = "small", offset_y = 0.4, scale = 0.55, nofx = nil },
	},
	revolvedmoonlight_taste4 = {
		base_prefab = "revolvedmoonlight",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "63889f4b8c2f781db2f7f770",
		noshopshow = true,
		assets = {
			Asset("ANIM", "anim/skin/revolvedmoonlight_taste4.zip"),
			Asset("ANIM", "anim/skin/ui_revolvedmoonlight_taste4_4x3.zip"),
		},
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "黑巧冰" } or { name = "Choccy Ice Cream" },
		fn_start = function(f)
			f.AnimState:SetScale(0.85, 0.85, 0.85)
			f.AnimState:SetBank("revolvedmoonlight_taste4")
			f.AnimState:SetBuild("revolvedmoonlight_taste")
			f.components.container:Close()
			f.components.container:WidgetSetup("revolvedmoonlight_taste4")
		end,
		fn_end = function(f)
			f.AnimState:SetScale(1, 1, 1)
			f.components.container:Close()
			f.components.container:WidgetSetup("revolvedmoonlight")
		end,
		fn_start_c = function(f)
			f.replica.container:Close()
			f.replica.container:WidgetSetup("revolvedmoonlight_taste4")
		end,
		fn_end_c = function(f)
			f.replica.container:Close()
			f.replica.container:WidgetSetup("revolvedmoonlight")
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
		linkedskins = { item = "revolvedmoonlight_item_taste4" },
		floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil },
	},
	revolvedmoonlight_pro_taste4 = {
		base_prefab = "revolvedmoonlight_pro",
		type = "item",
		skin_tags = {},
		release_group = 555,
		rarity = U,
		skin_id = "63889f4b8c2f781db2f7f770",
		noshopshow = true,
		assets = { Asset("ANIM", "anim/skin/revolvedmoonlight_pro_taste4.zip") },
		image = { name = nil, atlas = nil, setable = true },
		string = c and { name = "黑色旋涡" } or { name = "Choccy Sundae" },
		fn_start = function(f)
			f.AnimState:SetScale(0.85, 0.85, 0.85)
			f.AnimState:SetBank("revolvedmoonlight_pro_taste4")
			f.AnimState:SetBuild("revolvedmoonlight_taste")
			f.components.container:Close()
			f.components.container:WidgetSetup("revolvedmoonlight_pro_taste4")
		end,
		fn_end = function(f)
			f.AnimState:SetScale(1, 1, 1)
			f.components.container:Close()
			f.components.container:WidgetSetup("revolvedmoonlight_pro")
		end,
		fn_start_c = function(f)
			f.replica.container:Close()
			f.replica.container:WidgetSetup("revolvedmoonlight_pro_taste4")
		end,
		fn_end_c = function(f)
			f.replica.container:Close()
			f.replica.container:WidgetSetup("revolvedmoonlight_pro")
		end,
		exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
		linkedskins = { item = "revolvedmoonlight_item_taste4" },
		floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil },
	},
}
a.SKIN_IDS_LEGION = {
	["notnononl"] = {},
	["6278c409c340bf24ab311522"] = {
		siving_derivant_lvl0_thanks = true,
		siving_derivant_lvl1_thanks = true,
		siving_derivant_lvl2_thanks = true,
		siving_derivant_lvl3_thanks = true,
		siving_derivant_lvl0_thanks2 = true,
		siving_derivant_lvl1_thanks2 = true,
		siving_derivant_lvl2_thanks2 = true,
		siving_derivant_lvl3_thanks2 = true,
		neverfade_thanks = true,
		neverfadebush_thanks = true,
		backcub_thanks = true,
		fishhomingtool_awesome_thanks = true,
		fishhomingtool_normal_thanks = true,
		fishhomingbait_thanks = true,
		triplegoldenshovelaxe_era = true,
		tripleshovelaxe_era = true,
		lilybush_era = true,
		lileaves_era = true,
		icire_rock_era = true,
		shield_l_log_era = true,
		shield_l_sand_era = true,
		orchidbush_disguiser = true,
		boltwingout_disguiser = true,
		rosebush_marble = true,
		lilybush_marble = true,
		orchidbush_marble = true,
		rosorns_marble = true,
		lileaves_marble = true,
		orchitwigs_marble = true,
		shield_l_log_emo_fist = true,
		hat_lichen_emo_que = true,
		rosebush_collector = true,
		rosorns_collector = true,
		fimbul_axe_collector = true,
		siving_turn_collector = true,
		backcub_fans2 = true,
		agronssword_taste = true,
		soul_contracts_taste = true,
		revolvedmoonlight_item_taste = true,
		revolvedmoonlight_taste = true,
		revolvedmoonlight_pro_taste = true,
		revolvedmoonlight_item_taste2 = true,
		revolvedmoonlight_taste2 = true,
		revolvedmoonlight_pro_taste2 = true,
		revolvedmoonlight_item_taste3 = true,
		revolvedmoonlight_taste3 = true,
		revolvedmoonlight_pro_taste3 = true,
		revolvedmoonlight_item_taste4 = true,
		revolvedmoonlight_taste4 = true,
		revolvedmoonlight_pro_taste4 = true,
		carpet_whitewood_law = true,
		carpet_whitewood_big_law = true,
		carpet_whitewood_law2 = true,
		carpet_whitewood_big_law2 = true,
		icire_rock_day = true,
		neverfade_paper = true,
		neverfadebush_paper = true,
		neverfade_paper2 = true,
		neverfadebush_paper2 = true,
		siving_feather_real_paper = true,
		siving_feather_fake_paper = true,
	},
	["6278c450c340bf24ab311528"] = {
		boltwingout_disguiser = true,
		rosebush_marble = true,
		lilybush_marble = true,
		orchidbush_marble = true,
		hat_lichen_emo_que = true,
	},
	["62eb7b148c2f781db2f79cf8"] = {
		rosebush_marble = true,
		lilybush_marble = true,
		orchidbush_marble = true,
		rosorns_marble = true,
		lileaves_marble = true,
		orchitwigs_marble = true,
		rosebush_collector = true,
		rosorns_collector = true,
		lilybush_era = true,
		lileaves_era = true,
		orchidbush_disguiser = true,
		shield_l_log_era = true,
	},
	["6278c487c340bf24ab31152c"] = {
		neverfade_thanks = true,
		neverfadebush_thanks = true,
		orchidbush_disguiser = true,
		boltwingout_disguiser = true,
		rosebush_marble = true,
		lilybush_marble = true,
		orchidbush_marble = true,
		hat_lichen_emo_que = true,
	},
	["6278c4acc340bf24ab311530"] = {
		fishhomingtool_awesome_thanks = true,
		fishhomingtool_normal_thanks = true,
		fishhomingbait_thanks = true,
		triplegoldenshovelaxe_era = true,
		tripleshovelaxe_era = true,
		lilybush_era = true,
		lileaves_era = true,
		icire_rock_era = true,
		shield_l_log_era = true,
		shield_l_sand_era = true,
		shield_l_log_emo_fist = true,
		carpet_whitewood_law = true,
		carpet_whitewood_big_law = true,
	},
	["6278c4eec340bf24ab311534"] = {
		rosebush_collector = true,
		rosorns_collector = true,
		fimbul_axe_collector = true,
		rosorns_marble = true,
		lileaves_marble = true,
		orchitwigs_marble = true,
		backcub_thanks = true,
		siving_derivant_lvl0_thanks = true,
		siving_derivant_lvl1_thanks = true,
		siving_derivant_lvl2_thanks = true,
		siving_derivant_lvl3_thanks = true,
		siving_derivant_lvl0_thanks2 = true,
		siving_derivant_lvl1_thanks2 = true,
		siving_derivant_lvl2_thanks2 = true,
		siving_derivant_lvl3_thanks2 = true,
		revolvedmoonlight_item_taste = true,
		revolvedmoonlight_taste = true,
		revolvedmoonlight_pro_taste = true,
		revolvedmoonlight_item_taste2 = true,
		revolvedmoonlight_taste2 = true,
		revolvedmoonlight_pro_taste2 = true,
	},
	["637f07a28c2f781db2f7f1e8"] = {
		agronssword_taste = true,
		soul_contracts_taste = true,
		revolvedmoonlight_item_taste3 = true,
		revolvedmoonlight_taste3 = true,
		revolvedmoonlight_pro_taste3 = true,
		revolvedmoonlight_item_taste4 = true,
		revolvedmoonlight_taste4 = true,
		revolvedmoonlight_pro_taste4 = true,
		carpet_whitewood_law2 = true,
		carpet_whitewood_big_law2 = true,
		icire_rock_day = true,
		neverfade_paper = true,
		neverfadebush_paper = true,
		neverfade_paper2 = true,
		neverfadebush_paper2 = true,
		siving_feather_real_paper = true,
		siving_feather_fake_paper = true,
	},
	["642c14d9f2b67d287a35d439"] = {},
}
a.SKIN_IDX_LEGION = {}
local function Y(Z, _, a0)
	if Z.bank == nil then
		Z.bank = _
	end
	if Z.build == nil then
		Z.build = a0
	end
	if Z.anim == nil then
		Z.anim = "idle"
	end
	if Z.animpush ~= nil then
		Z.isloop_anim = nil
		if Z.isloop_animpush ~= true then
			Z.isloop_animpush = false
		end
	else
		Z.isloop_animpush = nil
		if Z.isloop_anim ~= true then
			Z.isloop_anim = false
		end
	end
end
local a1 = {
	"neverfade_thanks",
	"neverfadebush_thanks",
	"siving_derivant_lvl0_thanks",
	"siving_derivant_lvl1_thanks",
	"siving_derivant_lvl2_thanks",
	"siving_derivant_lvl3_thanks",
	"siving_derivant_lvl0_thanks2",
	"siving_derivant_lvl1_thanks2",
	"siving_derivant_lvl2_thanks2",
	"siving_derivant_lvl3_thanks2",
	"backcub_thanks",
	"fishhomingtool_awesome_thanks",
	"fishhomingtool_normal_thanks",
	"fishhomingbait_thanks",
	"siving_turn_collector",
	"icire_rock_collector",
	"fimbul_axe_collector",
	"rosebush_collector",
	"rosorns_collector",
	"neverfade_paper",
	"neverfadebush_paper",
	"neverfade_paper2",
	"neverfadebush_paper2",
	"siving_feather_real_paper",
	"siving_feather_fake_paper",
	"icire_rock_day",
	"carpet_whitewood_law",
	"carpet_whitewood_big_law",
	"carpet_whitewood_law2",
	"carpet_whitewood_big_law2",
	"agronssword_taste",
	"soul_contracts_taste",
	"revolvedmoonlight_item_taste",
	"revolvedmoonlight_taste",
	"revolvedmoonlight_pro_taste",
	"revolvedmoonlight_item_taste2",
	"revolvedmoonlight_taste2",
	"revolvedmoonlight_pro_taste2",
	"revolvedmoonlight_item_taste3",
	"revolvedmoonlight_taste3",
	"revolvedmoonlight_pro_taste3",
	"revolvedmoonlight_item_taste4",
	"revolvedmoonlight_taste4",
	"revolvedmoonlight_pro_taste4",
	"triplegoldenshovelaxe_era",
	"tripleshovelaxe_era",
	"lilybush_era",
	"lileaves_era",
	"shield_l_log_era",
	"icire_rock_era",
	"shield_l_sand_era",
	"orchidbush_disguiser",
	"boltwingout_disguiser",
	"rosebush_marble",
	"rosorns_marble",
	"lilybush_marble",
	"lileaves_marble",
	"orchidbush_marble",
	"orchitwigs_marble",
	"shield_l_log_emo_fist",
	"hat_lichen_emo_que",
	"backcub_fans2",
	"backcub_fans",
	"shield_l_log_emo_pride",
	"shield_l_sand_op",
	"pinkstaff_tvplay",
	"hat_cowboy_tvplay",
	"hat_lichen_disguiser",
	"orchitwigs_disguiser",
}
for a2, G in pairs(a1) do
	a.SKIN_IDX_LEGION[a2] = G
	a.SKINS_LEGION[G].skin_idx = a2
end
for G, P in pairs(a.SKINS_LEGION) do
	if a.SKIN_IDS_LEGION[P.skin_id] == nil then
		a.SKIN_IDS_LEGION[P.skin_id] = {}
	end
	a.SKIN_IDS_LEGION[P.skin_id][G] = true
	if P.image ~= nil then
		if P.image.name == nil then
			P.image.name = G
		end
		if P.image.atlas == nil then
			P.image.atlas = "images/inventoryimages_skin/" .. G .. ".xml"
		end
		if P.image.setable ~= false then
			P.image.setable = true
		end
		table.insert(Assets, Asset("ATLAS", P.image.atlas))
		table.insert(Assets, Asset("IMAGE", "images/inventoryimages_skin/" .. P.image.name .. ".tex"))
		RegisterInventoryItemAtlas(P.image.atlas, P.image.name .. ".tex")
	end
	if P.anim ~= nil then
		Y(P.anim, G, G)
		if P.anim.setable ~= false then
			P.anim.setable = true
		end
	end
	if P.floater ~= nil and P.floater.anim ~= nil then
		Y(P.floater.anim, P.anim.bank, P.anim.bank.build)
	end
	if P.build_name_override == nil then
		P.build_name_override = G
	end
	if P.assets ~= nil then
		for a3, a4 in pairs(P.assets) do
			table.insert(Assets, a4)
		end
	end
	if P.placer ~= nil then
		if P.placer.name == nil then
			P.placer.name = G .. "_placer"
		end
		if P.anim ~= nil then
			if P.placer.bank == nil then
				P.placer.bank = P.anim.bank
			end
			if P.placer.build == nil then
				P.placer.build = P.anim.build
			end
			if P.placer.anim == nil then
				P.placer.anim = P.anim.anim
			end
		else
			if P.placer.bank == nil then
				P.placer.bank = G
			end
			if P.placer.build == nil then
				P.placer.build = G
			end
			if P.placer.anim == nil then
				P.placer.anim = "idle"
			end
		end
	end
	table.insert(P.skin_tags, string.upper(G))
	table.insert(P.skin_tags, "CRAFTABLE")
	STRINGS.SKIN_NAMES[G] = P.string.name
	if P.base_prefab ~= nil then
		if a.PREFAB_SKINS[P.base_prefab] == nil then
			a.PREFAB_SKINS[P.base_prefab] = { G }
		else
			table.insert(a.PREFAB_SKINS[P.base_prefab], G)
		end
	end
end
for a5, P in pairs(a.SKIN_PREFABS_LEGION) do
	if P.anim ~= nil then
		Y(P.anim, a5, a5)
		if P.anim.setable ~= false then
			P.anim.setable = true
		end
	end
	if P.floater ~= nil and P.floater.anim ~= nil then
		Y(P.floater.anim, P.anim.bank, P.anim.bank.build)
	end
	if P.image ~= nil then
		if P.image.name == nil then
			P.image.name = a5
		end
		if P.image.atlas == nil then
			P.image.atlas = "images/inventoryimages/" .. a5 .. ".xml"
		end
		if P.image.setable ~= false then
			P.image.setable = true
		end
		table.insert(Assets, Asset("ATLAS", P.image.atlas))
		table.insert(Assets, Asset("IMAGE", "images/inventoryimages/" .. P.image.name .. ".tex"))
		RegisterInventoryItemAtlas(P.image.atlas, P.image.name .. ".tex")
	end
	if P.assets ~= nil then
		for a3, a4 in pairs(P.assets) do
			table.insert(Assets, a4)
		end
	end
	a[a5 .. "_clear_fn"] = function(f) end
end
c = nil
RegisterInventoryItemAtlas("images/inventoryimages_skin/agronssword_taste.xml", "agronssword_taste.tex")
RegisterInventoryItemAtlas("images/inventoryimages_skin/agronssword_taste2.xml", "agronssword_taste2.tex")
a.PREFAB_SKINS_IDS = {}
for a6, a7 in pairs(a.PREFAB_SKINS) do
	a.PREFAB_SKINS_IDS[a6] = {}
	for a8, P in pairs(a7) do
		a.PREFAB_SKINS_IDS[a6][P] = a8
	end
end
local a9 = a.ValidateRecipeSkinRequest
a.ValidateRecipeSkinRequest = function(aa, ab, ac, ...)
	local ad = nil
	if ac ~= nil and ac ~= "" and SKINS_LEGION[ac] ~= nil then
		if table.contains(a.PREFAB_SKINS[ab], ac) then
			ad = ac
		end
	else
		ad = a9(aa, ab, ac, ...)
	end
	return ad
end
local function ae(G, af)
	if SKIN_IDS_LEGION.notnononl[G] then
		return true
	elseif af ~= nil and SKINS_CACHE_L[af] ~= nil and SKINS_CACHE_L[af][G] then
		return true
	end
	return false
end
AddClassPostConstruct("widgets/redux/craftingmenu_skinselector", function(self, ag, g, ah)
	if self.recipe and SKIN_PREFABS_LEGION[self.recipe.product] then
		local ai = self.GetSkinsList
		self.GetSkinsList = function(self, ...)
			if PREFAB_SKINS[self.recipe.product] then
				if not self.timestamp then
					self.timestamp = -10000
				end
				local aj = {}
				for O, G in pairs(PREFAB_SKINS[self.recipe.product]) do
					if ae(G, self.owner.userid) then
						local r = { type = type, item = G, timestamp = -10000 }
						table.insert(aj, r)
						if r.timestamp > self.timestamp then
							self.timestamp = r.timestamp
						end
					end
				end
				return aj
			else
				return ai(self, ...)
			end
		end
		self.skins_list = self:GetSkinsList()
		self.skins_options = self:GetSkinOptions()
		if #self.skins_options == 1 then
			self.spinner.fgimage:SetPosition(0, 0)
			self.spinner.fgimage:SetScale(1.2)
			self.spinner.text:Hide()
		else
			self.spinner.fgimage:SetPosition(0, 15)
			self.spinner.fgimage:SetScale(1)
			self.spinner.text:Show()
		end
		self.spinner:SetWrapEnabled(#self.skins_options > 1)
		self.spinner:SetOptions(self.skins_options)
		self.spinner:SetSelectedIndex(ah == nil and 1 or self:GetIndexForSkin(ah) or 1)
	end
end)
a.SKINS_NET_L = {}
a.SKINS_NET_CDK_L = {}
a.SKINS_CACHE_L = {}
a.SKINS_CACHE_EX_L = {}
local function ak(af, ah, al, am)
	if af == nil then
		return
	end
	local an = SKINS_CACHE_EX_L[af]
	if an == nil then
		SKINS_CACHE_EX_L[af] = {}
		an = SKINS_CACHE_EX_L[af]
	else
		if am ~= nil and am.placer ~= nil and am.placer.prefabs ~= nil then
			for O, P in pairs(am.placer.prefabs) do
				an[P] = nil
			end
		end
	end
	if ah ~= nil and al ~= nil and al.placer ~= nil and al.placer.prefabs ~= nil then
		for O, P in pairs(al.placer.prefabs) do
			an[P] = { name = ah, placer = al.placer.name }
		end
	end
end
local ao = nil
local ap = nil
if b then
	local function aq(a7)
		if a7 == nil then
			return
		end
		if not a7["carpet_whitewood_law"] then
			if
				(a7["lilybush_era"] and 0.5 or 0)
					+ (a7["icire_rock_era"] and 0.5 or 0)
					+ (a7["shield_l_sand_era"] and 0.5 or 0)
				>= 1
			then
				a7["carpet_whitewood_law"] = true
				a7["carpet_whitewood_big_law"] = true
			end
		end
		if not a7["revolvedmoonlight_item_taste"] or not a7["revolvedmoonlight_item_taste2"] then
			local ar = (a7["rosebush_collector"] and 0.5 or 0)
				+ (a7["lileaves_marble"] and 0.5 or 0)
				+ (a7["orchitwigs_marble"] and 0.5 or 0)
				+ (a7["fimbul_axe_collector"] and 1.5 or 0)
				+ (a7["siving_derivant_lvl0_thanks"] and 0.5 or 0)
				+ (a7["backcub_thanks"] and 2 or 0)
			if ar >= 3 then
				a7["revolvedmoonlight_item_taste"] = true
				a7["revolvedmoonlight_taste"] = true
				a7["revolvedmoonlight_pro_taste"] = true
				a7["revolvedmoonlight_item_taste2"] = true
				a7["revolvedmoonlight_taste2"] = true
				a7["revolvedmoonlight_pro_taste2"] = true
			elseif ar >= 1 then
				if a7["revolvedmoonlight_item_taste"] then
					a7["revolvedmoonlight_item_taste2"] = true
					a7["revolvedmoonlight_taste2"] = true
					a7["revolvedmoonlight_pro_taste2"] = true
				else
					a7["revolvedmoonlight_item_taste"] = true
					a7["revolvedmoonlight_taste"] = true
					a7["revolvedmoonlight_pro_taste"] = true
				end
			end
		end
		if not a7["backcub_fans2"] then
			for G, O in pairs(SKIN_IDS_LEGION["6278c487c340bf24ab31152c"]) do
				if not a7[G] then
					return
				end
			end
			for G, O in pairs(SKIN_IDS_LEGION["6278c4acc340bf24ab311530"]) do
				if not a7[G] then
					return
				end
			end
			for G, O in pairs(SKIN_IDS_LEGION["6278c4eec340bf24ab311534"]) do
				if not a7[G] then
					return
				end
			end
			a7["backcub_fans2"] = true
		end
	end
	local function as(af, at, r)
		if r == nil then
			r = {}
		end
		local au, av = pcall(json.encode, r)
		if au then
			SendModRPCToClient(GetClientModRPC("LegionSkined", "SkinHandle"), af, at, av)
		end
	end
	local function aw(ax)
		if ax.task ~= nil then
			ax.task:Cancel()
			ax.task = nil
		end
		ax.errcount = 0
	end
	local function ay(az, aA, af, aB, aC, aD, aE)
		if TheWorld == nil then
			return
		end
		local aa = aA ~= nil and aA.userid or af
		if aa == nil or aa == "" then
			return
		end
		local aF = os.time() or 0
		local aG = az[aa]
		if aG == nil then
			aG = { errcount = 0, loadtag = nil, task = nil, lastquerytime = aF }
			az[aa] = aG
		else
			if aG.lastquerytime == nil then
				aG.lastquerytime = aF
			elseif aD.force ~= nil then
				if aF - aG.lastquerytime < aD.force then
					aE.err(aG, aa, 1)
					return
				end
			elseif aF - aG.lastquerytime < aD.cut then
				aE.err(aG, aa, 2)
				return
			end
			if aG.task ~= nil then
				if aG.loadtag == 0 then
					return
				else
					aG.task:Cancel()
					aG.task = nil
				end
			end
			aG.loadtag = nil
		end
		aG.task = TheWorld:DoPeriodicTask(3, function()
			if aG.loadtag == 0 then
				return
			elseif aG.loadtag == -1 then
				if aG.errcount >= 1 then
					aw(aG)
					aE.err(aG, aa, 3)
					return
				else
					aG.errcount = aG.errcount + 1
				end
			elseif aG.loadtag == 1 then
				aw(aG)
				return
			end
			aG.loadtag = 0
			aG.lastquerytime = os.time() or 0
			local aH = aE.urlparams(aG, aa)
			if aH == nil then
				aw(aG)
				aE.err(aG, aa, 4)
				return
			end
			TheSim:QueryServer(aH, function(aI, aJ, aK)
				if aJ and string.len(aI) > 1 and aK == 200 then
					local aL, r = pcall(function()
						return json.decode(aI)
					end)
					if not aL then
						print("[" .. aB .. "] Faild to parse quest json for " .. tostring(aa) .. "! ", tostring(aL))
						aG.loadtag = -1
					else
						aE.handle(aG, aa, r)
					end
				else
					aG.loadtag = -1
				end
			end, aC and "GET" or "POST", not aC and aE.params(aG, aa) or nil)
		end, aD.delay)
	end
	ao = function(aA, af, aM, aN)
		ay(SKINS_NET_L, aA, af, "GetLegionSkins", true, { force = aN and 5 or nil, cut = 180, delay = aM }, {
			urlparams = function(aG, aa)
				return "https://fireleaves.cn/account/locakedSkin?mid=6041a52be3a3fb1f530b550a&id=" .. aa
			end,
			handle = function(aG, aa, r)
				local a7 = nil
				if r ~= nil then
					if r.lockedSkin ~= nil and type(r.lockedSkin) == "table" then
						for a3, aO in pairs(r.lockedSkin) do
							local aP = SKIN_IDS_LEGION[aO]
							if aP ~= nil then
								if a7 == nil then
									a7 = {}
								end
								for G, aQ in pairs(aP) do
									if SKINS_LEGION[G] ~= nil then
										a7[G] = true
									end
								end
							end
						end
						aq(a7)
					end
				end
				if a7 ~= nil then
					SKINS_CACHE_L[aa] = a7
				end
				aG.loadtag = 1
				aw(aG)
				if aA ~= nil and aA:IsValid() then
					as(aa, 1, SKINS_CACHE_L[aa])
				end
			end,
			err = function(aG, aa, aR) end,
		})
	end
	ap = function(aA, af, aS)
		ay(SKINS_NET_CDK_L, aA, af, "DoLegionCdk", false, { force = nil, cut = 5, delay = 0 }, {
			urlparams = function(aG, aa)
				return "https://fireleaves.cn/cdk/use"
			end,
			params = function(aG, aa)
				return json.encode({ cdkStr = aS, id = aa })
			end,
			handle = function(aG, aa, r)
				local ax = -1
				if r ~= nil and r.code == 0 then
					ax = 1
					aG.loadtag = 1
					ao(aA, af, 0, true)
				else
					aG.loadtag = -1
				end
				aw(aG)
				if aA ~= nil and aA:IsValid() then
					as(aa, 2, { state = ax, pop = -1 })
				end
			end,
			err = function(aG, aa, aR)
				if aA ~= nil and aA:IsValid() then
					local aT = -1
					if aR == 1 or aR == 2 then
						aT = 2
					elseif aR == 3 then
						aT = 3
					elseif aR == 4 then
						aT = 4
					end
					as(aa, 2, { state = -1, pop = aT })
				end
			end,
		})
	end
	local aU = a.SpawnPrefab
	a.SpawnPrefab = function(aV, ac, aW, aX)
		if ac ~= nil and SKINS_LEGION[ac] ~= nil then
			local a6 = aU(aV, nil, nil, aX)
			if a6 ~= nil then
				if a6.components.skinedlegion ~= nil then
					if aX == nil or ae(ac, aX) then
						a6.components.skinedlegion:SetSkin(ac)
					end
				end
			end
			return a6
		else
			return aU(aV, ac, aW, aX)
		end
	end
	AddPrefabPostInit("reskin_tool", function(f)
		if f.components.spellcaster ~= nil then
			local aY = f.components.spellcaster.can_cast_fn
			f.components.spellcaster:SetCanCastFn(function(aZ, X, B, ...)
				if X.components.skinedlegion ~= nil then
					return true
				end
				if aY ~= nil then
					return aY(aZ, X, B, ...)
				end
			end)
			local a_ = f.components.spellcaster.spell
			f.components.spellcaster:SetSpellFn(function(b0, X, B, ...)
				if X ~= nil and X.components.skinedlegion ~= nil then
					b0:DoTaskInTime(0, function()
						local aZ = b0.components.inventoryitem.owner
						local a7 = PREFAB_SKINS[X.prefab]
						local am = X.components.skinedlegion:GetSkinedData()
						local b1 = nil
						local b2 = nil
						local b3 = X.components.skinedlegion:GetSkin()
						local b4 = 0
						if b3 ~= nil and SKINS_LEGION[b3] ~= nil then
							b4 = SKINS_LEGION[b3].skin_idx
						end
						if a7 ~= nil then
							for O, G in pairs(a7) do
								if ae(G, aZ.userid) then
									if SKINS_LEGION[G] ~= nil then
										local b5 = SKINS_LEGION[G].skin_idx
										if b5 > b4 then
											if b2 == nil or b2 > b5 then
												b2 = b5
												b1 = G
											end
										end
									end
								end
							end
						end
						if b1 ~= b3 then
							X.components.skinedlegion:SetSkin(b1)
							local ah = X.components.skinedlegion:GetSkin()
							ak(aZ.userid, ah, X.components.skinedlegion:GetSkinedData(), am)
							as(aZ.userid, 4, { new = ah, old = b3 })
						end
						X.components.skinedlegion:SpawnSkinExchangeFx(nil, b0)
					end)
					return
				end
				if a_ ~= nil then
					return a_(b0, X, B, ...)
				end
			end)
		end
	end)
	AddPlayerPostInit(function(f)
		local b6 = f.OnSave
		local b7 = f.OnLoad
		f.OnSave = function(f, r)
			if b6 ~= nil then
				b6(f, r)
			end
			if SKINS_CACHE_L[f.userid] ~= nil then
				local a7 = nil
				for G, P in pairs(SKINS_CACHE_L[f.userid]) do
					if a7 == nil then
						a7 = {}
					end
					a7[G] = true
				end
				if a7 ~= nil then
					r.skins_legion = a7
				end
			end
			if SKINS_CACHE_EX_L[f.userid] ~= nil then
				local a7 = nil
				for b8, P in pairs(SKINS_CACHE_EX_L[f.userid]) do
					if P.name ~= nil and P.placer ~= nil then
						if a7 == nil then
							a7 = {}
						end
						a7[b8] = { name = P.name, placer = P.placer }
					end
				end
				if a7 ~= nil then
					r.skins_ex_legion = a7
				end
			end
		end
		f.OnLoad = function(f, r)
			if b7 ~= nil then
				b7(f, r)
			end
			if r ~= nil then
				if r.skins_legion ~= nil then
					SKINS_CACHE_L[f.userid] = r.skins_legion
				end
				if r.skins_ex_legion ~= nil then
					local b9 = {}
					for b8, P in pairs(r.skins_ex_legion) do
						if P.name ~= nil and SKINS_LEGION[P.name] ~= nil then
							b9[b8] = P
						end
					end
					SKINS_CACHE_EX_L[f.userid] = b9
				end
			end
		end
		f.task_skin_l = f:DoTaskInTime(1.1, function()
			f.task_skin_l = nil
			ao(f, f.userid, 0.5, false)
			if f.userid ~= nil then
				if SKINS_CACHE_L[f.userid] ~= nil then
					as(f.userid, 1, SKINS_CACHE_L[f.userid])
				end
				if SKINS_CACHE_EX_L[f.userid] ~= nil then
					as(f.userid, 3, SKINS_CACHE_EX_L[f.userid])
				end
			end
		end)
	end)
end
local function ba()
	if ThePlayer and ThePlayer.HUD and ThePlayer.HUD.controls then
		return ThePlayer.HUD.controls.right_root
	end
	return nil
end
AddClientModRPCHandler("LegionSkined", "SkinHandle", function(at, r, ...)
	if at and type(at) == "number" then
		if at == 1 then
			if r and type(r) == "string" then
				local au, av = pcall(json.decode, r)
				if av and ThePlayer and ThePlayer.userid then
					SKINS_CACHE_L[ThePlayer.userid] = av
					local bb = ba()
					if bb ~= nil and bb.skinshop_l then
						bb.skinshop_l:ResetItems()
					end
				end
			end
		elseif at == 2 then
			if r and type(r) == "string" then
				local au, av = pcall(json.decode, r)
				if av then
					local bb = ba()
					if bb ~= nil and bb.skinshop_l then
						bb.skinshop_l:SetCdkState(av.state, av.pop)
					end
				end
			end
		elseif at == 3 then
			if r and type(r) == "string" then
				local au, av = pcall(json.decode, r)
				if av and ThePlayer and ThePlayer.userid then
					SKINS_CACHE_EX_L[ThePlayer.userid] = av
				end
			end
		elseif at == 4 then
			if r and type(r) == "string" then
				local au, av = pcall(json.decode, r)
				if av and ThePlayer and ThePlayer.userid then
					if av.new ~= nil or av.old ~= nil then
						local al = av.new ~= nil and SKINS_LEGION[av.new] or nil
						local am = av.old ~= nil and SKINS_LEGION[av.old] or nil
						ak(ThePlayer.userid, av.new, al, am)
					end
				end
			end
		end
	end
end)
AddModRPCHandler("LegionSkined", "BarHandle", function(aA, at, r, ...)
	if at and type(at) == "number" then
		if at == 1 then
			if aA and ao ~= nil then
				ao(aA, aA.userid, 0, true)
			end
		elseif at == 2 then
			if aA and r and ap ~= nil and type(r) == "string" then
				local au, av = pcall(json.decode, r)
				if av and av.cdk ~= nil and av.cdk ~= "" and av.cdk:utf8len() > 6 then
					ap(aA, aA.userid, av.cdk)
				end
			end
		end
	end
end)
if not TheNet:IsDedicated() then
	if TheNet:IsOnlineMode() and a.CONFIGS_LEGION.LANGUAGES == "chinese" then
		local bc = require("screens/playerinfopopupscreen")
		local bd = require("widgets/templates")
		local be = require("widgets/skinlegiondialog")
		local bf = bc.MakeBG
		bc.MakeBG = function(self, ...)
			bf(self, ...)
			local bb = ba()
			if bb == nil then
				return
			end
			if bb.skinshop_l then
				bb.skinshop_l:Kill()
				bb.skinshop_l = nil
			end
			self.skinshop_l_button = self.root:AddChild(
				bd.IconButton(
					"images/icon_skinbar_shadow_l.xml",
					"icon_skinbar_shadow_l.tex",
					"棱镜鸡毛铺",
					false,
					false,
					function()
						if bb.skinshop_l then
							bb.skinshop_l:Kill()
						end
						bb.skinshop_l = bb:AddChild(be(self.owner))
						bb.skinshop_l:SetPosition(-380, 0)
						TheFrontEnd:PopScreen()
					end,
					nil,
					"self_inspect_mod.tex"
				)
			)
			self.skinshop_l_button.icon:SetScale(0.6)
			self.skinshop_l_button.icon:SetPosition(-4, 6)
			self.skinshop_l_button:SetScale(0.65)
			self.skinshop_l_button:SetPosition(246, -260)
		end
	end
end
local bg = require("components/inventoryitem_replica")
local bh = bg.GetDeployPlacerName
bg.GetDeployPlacerName = function(self, ...)
	local bi = bh(self, ...)
	if bi == "gridplacer" then
		return bi
	end
	if ThePlayer and ThePlayer.userid and SKINS_CACHE_EX_L[ThePlayer.userid] ~= nil then
		local r = SKINS_CACHE_EX_L[ThePlayer.userid]
		if r[self.inst.prefab] ~= nil then
			return r[self.inst.prefab].placer or bi
		end
	end
	return bi
end
a.Skined_SetBuildPlacer_legion = function(f)
	if f.components.placer ~= nil then
		local bj = f.components.placer.SetBuilder
		f.components.placer.SetBuilder = function(self, ...)
			bj(self, ...)
			if self.builder and self.builder.components.playercontroller ~= nil then
				local ac = self.builder.components.playercontroller.placer_recipe_skin
				if ac and SKINS_LEGION[ac] and SKINS_LEGION[ac].fn_setBuildPlacer then
					SKINS_LEGION[ac].fn_setBuildPlacer(self.inst)
				end
			end
		end
	end
end
