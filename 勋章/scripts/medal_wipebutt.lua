local cooking = require("cooking")
local upvaluehelper = require "medal_upvaluehelper"--出自 风铃草大佬
------------------------------------------------------------------------------------------------------
-------------------------------------------修改Mod料理相关函数-----------------------------------------------
------------------------------------------------------------------------------------------------------
--修改是否是Mod食谱函数(只是加了个锅凭啥算Mod料理！)
local oldIsModCookingProductfn = GLOBAL.IsModCookingProduct
GLOBAL.IsModCookingProduct=function(cooker, name)
	if cooker == "medal_cookpot" then return false end
	if oldIsModCookingProductfn then
		return oldIsModCookingProductfn(cooker,name)
	end
    return false
end

------------------------------------------------------------------------------------------------------
---------------------------------------修复调味锅的贴图显示-------------------------------------------
------------------------------------------------------------------------------------------------------
local medal_spices=require("medal_defs/medal_spice_defs")
--展示料理
local function newShowProduct(inst)
    if not inst:HasTag("burnt") then
        local product = inst.components.stewer.product
        local recipe = cooking.GetRecipe(inst.prefab, product)
        if recipe ~= nil then
			product = recipe.basename or product
            if recipe.spice ~= nil then
                inst.AnimState:OverrideSymbol("swap_plate", "plate_food", "plate")
                --如果是新调料则显示新调料的贴图
				if medal_spices[string.lower(recipe.spice)] then
					inst.AnimState:OverrideSymbol("swap_garnish", "medal_spices", string.lower(recipe.spice))
				else
					inst.AnimState:OverrideSymbol("swap_garnish", "spices", string.lower(recipe.spice))
				end
            else
                inst.AnimState:ClearOverrideSymbol("swap_plate")
                inst.AnimState:ClearOverrideSymbol("swap_garnish")
            end
        else
            inst.AnimState:ClearOverrideSymbol("swap_plate")
            inst.AnimState:ClearOverrideSymbol("swap_garnish")
        end
		
		-- local symbol_override_build = (recipe ~= nil and recipe.overridebuild) or "cook_pot_food"
		-- --如果是游戏原生的基础料理则用基础料理的贴图显示方法,这里是因为新调味料理算Mod料理,但是实际上贴图还是需要用到原生料理贴图
		-- if IsNativeCookingProduct(product) then
		-- 	inst.AnimState:OverrideSymbol("swap_cooked", symbol_override_build, product)
		-- elseif IsModCookingProduct(inst.prefab, inst.components.stewer.product) then
		-- 	inst.AnimState:OverrideSymbol("swap_cooked", product, product)
        -- else
        --     inst.AnimState:OverrideSymbol("swap_cooked", symbol_override_build, product)
        -- end

		local build =
            (recipe ~= nil and recipe.overridebuild) or
            (IsModCookingProduct(inst.prefab, product) and product) or
            "cook_pot_food"
        local overridesymbol = recipe ~= nil and recipe.overridesymbolname or product
        inst.AnimState:OverrideSymbol("swap_cooked", build, overridesymbol)
    end
end

local function donecookfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("cooking_pst")
        inst.AnimState:PushAnimation("idle_full", false)
        newShowProduct(inst)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/together/portable/spicer/cooking_pst")
    end
end

local function continuedonefn(inst)
    if not inst:HasTag("burnt") then 
        inst.AnimState:PlayAnimation("idle_full")
        newShowProduct(inst)
    end
end
--调整调味锅的贴图显示，防止出现空贴图的情况
AddPrefabPostInit("portablespicer",function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.stewer then
			inst.components.stewer.oncontinuedone = continuedonefn
			inst.components.stewer.ondonecooking = donecookfn
		end
	end
end)

------------------------------------------------------------------------------------------------------
---------------------------------------------鱼人面具-------------------------------------------------
------------------------------------------------------------------------------------------------------
--修改鱼人面具的穿脱函数,防止和勋章冲突
AddPrefabPostInit("mermhat",function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.equippable then
			local oldonequipfn=inst.components.equippable.onequipfn
			local oldonunequipfn=inst.components.equippable.onunequipfn
			if oldonequipfn and oldonunequipfn then
				local opentop_onequip=MedalGetLocalFn(oldonequipfn,"opentop_onequip")
				inst.components.equippable:SetOnEquip(function(inst,owner)
					if opentop_onequip then
						opentop_onequip(inst,owner)
					end
					if owner.components.leader then
						owner.components.leader:RemoveFollowersByTag("pig")
					end
					owner:AddTag("mermdisguise")--伪装鱼人标签，如果有就不能收买鱼人守卫
					AddMedalTag(owner,"merm")--鱼人
					if owner:HasTag("monster") then
						owner.mermhat_wasmonster = true
						owner:RemoveTag("monster")
					end
				end)

				local _onunequip=MedalGetLocalFn(oldonunequipfn,"_onunequip")
				inst.components.equippable:SetOnUnequip(function(inst,owner)
					if _onunequip then
						_onunequip(inst,owner)
					end
					if owner.mermhat_wasmonster then
						owner:AddTag("monster")
						owner.mermhat_wasmonster = nil
					end
					owner:RemoveTag("mermdisguise")
					RemoveMedalTag(owner,"merm")--鱼人
				end)
			end
		end
	end
end)

------------------------------------------------------------------------------------------------------
---------------------------------------------弹弓弹药-------------------------------------------------
------------------------------------------------------------------------------------------------------
--有问题的弹药列表(不想遍历所有预置物了，干脆列一下得了)
local ammo_list={
	"slingshotammo_rock",--鹅卵石
	"slingshotammo_gold",--黄金弹药
	"slingshotammo_marble",--大理石弹
	"slingshotammo_thulecite",--诅咒弹药
	"slingshotammo_freeze",--冰冻弹药
	"slingshotammo_slow",--减速弹药
	"slingshotammo_poop",--便便弹
	"trinket_1",--融化的大理石
}
--弹弓的临时仇恨系统，目标在打其他玩家或生物时，使用弹弓攻击不会吸引走目标的仇恨
local function no_aggro(attacker, target)
	if target and attacker then
		local targets_target = target.components.combat ~= nil and target.components.combat.target or nil
		return targets_target ~= nil and targets_target:IsValid() and targets_target ~= attacker and attacker:IsValid()
				and (GetTime() - target.components.combat.lastwasattackedbytargettime) < 4
				and (targets_target.components.health ~= nil and not targets_target.components.health:IsDead())
	end
end
--修正弹药的预打击函数，防止吸引仇恨
for k,v in ipairs(ammo_list) do
	AddPrefabPostInit(v.."_proj",function(inst)
		if GLOBAL.TheWorld.ismastersim then
			if inst.components.projectile then
				inst.components.projectile.onprehit=function(inst, attacker, target)
					if target.components.combat then
						target.components.combat.temp_disable_aggro = no_aggro(attacker, target)
					end
				end
			end
		end
	end)
end
--弹弓延迟添加专属标签，防止切世界或重载后脱落
AddPrefabPostInit("slingshot",function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.equippable and inst.components.equippable.restrictedtag ~= nil then
			inst.components.equippable.restrictedtag = nil
		end
		inst:DoTaskInTime(0,function(inst)
			if inst.components.equippable then
				inst.components.equippable.restrictedtag = "slingshot_sharpshooter"
			end
		end)
	end
end)

------------------------------------------------------------------------------------------------------
-------------------------------------------大力士弹弓崩溃----------------------------------------------
------------------------------------------------------------------------------------------------------
AddPrefabPostInit("wolfgang",function(inst)
	local OnHitOther = upvaluehelper.GetEventHandle(inst,"onhitother","prefabs/wolfgang")
	if OnHitOther then
		inst:RemoveEventCallback("onhitother",OnHitOther)
		inst:ListenForEvent("onhitother", function(inst,data)
			local target = data.target
			--用弹弓不加力量,也不至于崩
			if not (data.weapon ~= nil and data.weapon.components.inventoryitem==nil) then
				OnHitOther(inst,data)
			end
		end)
	end
end)

------------------------------------------------------------------------------------------------------
----------------------------------戴罗杰帽无法正常生成罗杰导致的崩溃-------------------------------------
------------------------------------------------------------------------------------------------------
AddPrefabPostInit("polly_rogershat",function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.spawner then
			local oldoverridespawnlocation = inst.components.spawner.overridespawnlocation
			inst.components.spawner.overridespawnlocation = function(inst)
				local x,y,z
				if oldoverridespawnlocation then
					x,y,z = oldoverridespawnlocation(inst)
				end
				--找不到坐标的话就在脚底下生成吧
				if x==nil then
					local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner or inst
					x,y,z = owner.Transform:GetWorldPosition()
				end
				return x or 0,15,z or 0
			end
		end
	end
end)

------------------------------------------------------------------------------------------------------
-------------------------------------------月亮风暴观测者----------------------------------------------
------------------------------------------------------------------------------------------------------
AddComponentPostInit("moonstormwatcher", function(self)
	local oldToggleMoonstorms = self.ToggleMoonstorms
	if oldToggleMoonstorms then
		self.ToggleMoonstorms=function(self,data)
			--增加风暴种类的判断，免得被其他风暴影响到
			if data.stormtype==nil or data.stormtype == STORM_TYPES.MOONSTORM then
				oldToggleMoonstorms(self,data)
			end
		end
	end
end)

------------------------------------------------------------------------------------------------------
-------------------------------------------滤镜防神话刷帧----------------------------------------------
------------------------------------------------------------------------------------------------------
AddComponentPostInit("playervision", function(self)
	local oldForceGoggleVision = self.ForceGoggleVision
	if oldForceGoggleVision then
		self.ForceGoggleVision=function(self,force)
			local isequipped = self.inst and self.inst.medalnightvision and self.inst.medalnightvision:value()
			force = force or isequipped
			if oldForceGoggleVision then
				oldForceGoggleVision(self,force)
			end
		end
	end
	local oldForceNightVision = self.ForceNightVision
	if oldForceNightVision then
		self.ForceNightVision=function(self,force)
			local isequipped = self.inst and self.inst.medalnightvision and self.inst.medalnightvision:value()
			force = force or isequipped
			if oldForceNightVision then
				oldForceNightVision(self,force)
			end
		end
	end
end)

------------------------------------------------------------------------------------------------------
--------------------------------------only_used_by_xxx问题处理-----------------------------------------
------------------------------------------------------------------------------------------------------
local playerlist={
	"GENERIC",--威屌(默认角色)
	"WILLOW",--火女
	"WOLFGANG",--大力士
	"WENDY",--温蒂
	"WX78",--机器人
	"WICKERBOTTOM",--奶奶
	"WOODIE",--伍迪
	"WAXWELL",--老麦
	"WATHGRITHR",--女武神
	"WEBBER",--韦伯
	"WINONA",--女工
	"WARLY",--沃利
	"WORTOX",--小恶魔
	"WORMWOOD",--植物人
	"WURT",--小鱼妹
	"WALTER",--沃尔特
	"WANDA",--旺达
}

--修正动作错误时的对话提示(待添加的错误提示,动作名,被模仿者(就是对话来源))
local function RepairActionFailSpeech(add_loot,actionname,imitator)
	for _, v in ipairs(add_loot) do
		for _, k in ipairs(playerlist) do
			if k ~= imitator then
				--通用模板没有这个对话的话,也要强制加上,这样其他角色没定义的情况下就可以直接调用了
				if k=="GENERIC" and STRINGS.CHARACTERS[k].ACTIONFAIL[actionname]==nil then
					STRINGS.CHARACTERS[k].ACTIONFAIL[actionname] = {}
				end
				--只需要修改有这个动作提示的角色,没有这个动作提示的默认调用通用模板
				if STRINGS.CHARACTERS[k] and STRINGS.CHARACTERS[k].ACTIONFAIL[actionname] then
					if STRINGS.CHARACTERS[k].ACTIONFAIL[actionname][v]==nil or string.match(STRINGS.CHARACTERS[k].ACTIONFAIL[actionname][v],"only_used") ~= nil then
						STRINGS.CHARACTERS[k].ACTIONFAIL[actionname][v] = STRINGS.MEDAL_ACTIONFAIL_SPEECH[actionname] and STRINGS.MEDAL_ACTIONFAIL_SPEECH[actionname][v] or
						STRINGS.CHARACTERS[imitator].ACTIONFAIL[actionname][v]
					end
				end
			end
		end
	end
end

--待修复、补充的动作失败提示
local action_loot={
	READ={--阅读失败提示
		imitator="WICKERBOTTOM",--被模仿者
		tiploot={--待添加的提示
			--原版
			"GENERIC", "NOBIRDS", "NOWATERNEARBY", "TOOMANYBIRDS", "WAYTOOMANYBIRDS", "NOFIRES", "NOSILVICULTURE", "NOHORTICULTURE", 
			"NOTENTACLEGROUND", "NOSLEEPTARGETS", "TOOMANYBEES", "NOMOONINCAVES", "ALREADYFULLMOON",	
			--勋章添加的
			"TOOCOMPLEX","NOWISDOMVALUE","MUSTLAND",
		},
	},
	TELLSTORY={--讲故事
		imitator="WALTER",
		tiploot={"GENERIC","NOT_NIGHT","NO_FIRE"},
	},
}

local announce_loot={
	WICKERBOTTOM={"ANNOUNCE_TOOMANYBIRDS","ANNOUNCE_WAYTOOMANYBIRDS","ANNOUNCE_NOWATERNEARBY","ANNOUNCE_BOOK_MOON_DAYTIME"},--读书提示
	WALTER={"ANNOUNCE_SLINGHSOT_OUT_OF_AMMO","ANNOUNCE_STORYTELLING_ABORT_FIREWENTOUT","ANNOUNCE_STORYTELLING_ABORT_NOT_NIGHT"},--弹弓提示
}

local oldRegisterPrefabs = GLOBAL.ModManager.RegisterPrefabs 

GLOBAL.ModManager.RegisterPrefabs = function(self,...)
    --这个时候 PrefabFiles文件还没有被加载
	for k, v in pairs(action_loot) do
		RepairActionFailSpeech(v.tiploot,k,v.imitator)
	end

	for k, v in pairs(announce_loot) do
		for _, announce in ipairs(v) do
			STRINGS.CHARACTERS.GENERIC[announce] = STRINGS.CHARACTERS[k][announce]
		end
	end
	--灵魂检查
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.WORTOX_SOUL = STRINGS.CHARACTERS.WORTOX.DESCRIBE.WORTOX_SOUL

    oldRegisterPrefabs(self,...)
end