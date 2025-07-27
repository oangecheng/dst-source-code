local assets =
{
    Asset("ANIM", "anim/axe.zip"),
    Asset("ANIM", "anim/swap_axe.zip"),
	Asset("ANIM", "anim/pickaxe.zip"),
    Asset("ANIM", "anim/swap_pickaxe.zip"),
	Asset("ANIM", "anim/shovel.zip"),
    Asset("ANIM", "anim/swap_shovel.zip"),
	Asset("ANIM", "anim/hammer.zip"),
    Asset("ANIM", "anim/swap_hammer.zip"),
	Asset("ANIM", "anim/bugnet.zip"),
    Asset("ANIM", "anim/swap_bugnet.zip"),
	Asset("ANIM", "anim/quagmire_hoe.zip"),
    Asset("ANIM", "anim/swap_goldenhoe.zip"),
	Asset("ANIM", "anim/pitchfork.zip"),
    Asset("ANIM", "anim/swap_pitchfork.zip"),
	Asset("ANIM", "anim/oar.zip"),
    Asset("ANIM", "anim/swap_oar.zip"),
	
    Asset("ANIM", "anim/floating_items.zip"),
	Asset("ATLAS", "images/medal_shadow_tool.xml"),
	Asset("ATLAS", "images/medal_shadow_tool_icons.xml"),
	Asset("ATLAS_BUILD", "images/medal_shadow_tool.xml",256),
}

--判断是否已吸收对应工具
local function IsSorb(inst,idx)
	idx = idx or inst.tool_idx
	return inst.sorb_record[idx] ~= nil and inst.sorb_record[idx]>0 or false
end

local TOOL_DATA = {
	{--斧头
		id = 1,--唯一标识,方便区分
		str=STRINGS.MEDAL_SHADOW_TOOL_UI.AXE,
		action=ACTIONS.CHOP,--动作
		-- effectiveness=1,--效率
		-- actiontype=1,--动作类型,1工具(默认)、2特殊工具
		image="medal_shadow_axe",--物品栏贴图名
		bank="axe",
		build="axe",
		anim="idle",
		swapbuild="swap_axe",--手持build
		swapsymbol="swap_axe",--手持symbol
		showimg="axe.tex",--选项贴图
	},
	{--鹤嘴锄
		id = 2,
		str=STRINGS.MEDAL_SHADOW_TOOL_UI.PICKAXE,
		action=ACTIONS.MINE,
		image="medal_shadow_pickaxe",
		bank="pickaxe",
		build="pickaxe",
		anim="idle",
		swapbuild="swap_pickaxe",
		swapsymbol="swap_pickaxe",
		showimg="pickaxe.tex",
	},
	{--铲子
		id = 3,
		str=STRINGS.MEDAL_SHADOW_TOOL_UI.SHOVEL,
		action=ACTIONS.DIG,
		image="medal_shadow_shovel",
		bank="shovel",
		build="shovel",
		anim="idle",
		swapbuild="swap_shovel",
		swapsymbol="swap_shovel",
		showimg="shovel.tex",
	},
	{--锤子
		id = 4,
		str=STRINGS.MEDAL_SHADOW_TOOL_UI.HAMMER,
		action=ACTIONS.HAMMER,
		image="medal_shadow_hammer",
		bank="hammer",
		build="swap_hammer",
		anim="idle",
		swapbuild="swap_hammer",
		swapsymbol="swap_hammer",
		showimg="hammer.tex",
	},
	{--捕虫网
		id = 5,
		str=STRINGS.MEDAL_SHADOW_TOOL_UI.BUGNET,
		action=ACTIONS.NET,
		image="medal_shadow_bugnet",
		bank="bugnet",
		build="swap_bugnet",
		anim="idle",
		swapbuild="swap_bugnet",
		swapsymbol="swap_bugnet",
		showimg="bugnet.tex",
	},
	{--锄头
		id = 6,
		str=STRINGS.MEDAL_SHADOW_TOOL_UI.FARM_HOE,
		action=ACTIONS.TILL,
		actiontype=2,
		image="medal_shadow_farm_hoe",
		bank="quagmire_hoe",
		build="quagmire_hoe",
		anim="idle",
		swapbuild="quagmire_hoe",
		swapsymbol="swap_quagmire_hoe",
		showimg="farm_hoe.tex",
		fn=function(inst)
			inst:AddInherentAction(ACTIONS.TILL)
			if inst.components.farmtiller == nil then
				inst:AddComponent("farmtiller")
			end
		end,
		clearfn=function(inst,newaction)--清除工具信息
			--清除锄头动作
			if newaction ~= ACTIONS.TILL and inst:CanDoAction(ACTIONS.TILL) then
				inst:RemoveInherentAction(ACTIONS.TILL)
				if inst.components.farmtiller ~= nil then
					inst:RemoveComponent("farmtiller")
				end
			end
		end,
	},
	{--干草叉
		id = 7,
		str=STRINGS.MEDAL_SHADOW_TOOL_UI.PITCHFORK,
		action=ACTIONS.TERRAFORM,
		actiontype=2,
		image="medal_shadow_pitchfork",
		bank="pitchfork",
		build="pitchfork",
		anim="idle",
		swapbuild="swap_pitchfork",
		swapsymbol="swap_pitchfork",
		showimg="pitchfork.tex",
		fn=function(inst)
			inst:AddInherentAction(ACTIONS.TERRAFORM)
			if inst.components.terraformer == nil then
				inst:AddComponent("terraformer")
			end
		end,
		clearfn=function(inst,newaction)--清除工具信息
			--清除草叉动作
			if newaction ~= ACTIONS.TERRAFORM and inst:CanDoAction(ACTIONS.TERRAFORM) then
				inst:RemoveInherentAction(ACTIONS.TERRAFORM)
				if inst.components.terraformer ~= nil then
					inst:RemoveComponent("terraformer")
				end
			end
		end,
	},
	{--桨
		id = 8,
		str=STRINGS.MEDAL_SHADOW_TOOL_UI.OAR,
		action=ACTIONS.ROW,
		actiontype=2,
		image="medal_shadow_oar",
		bank="oar",
		build="oar",
		anim="idle",
		swapbuild="swap_oar",
		swapsymbol="swap_oar",
		showimg="oar.tex",
		fn=function(inst)
			inst:AddTag("allow_action_on_impassable")
			if inst.components.oar == nil then
				inst:AddComponent("oar")
				inst.components.oar.force = 0.5
    			inst.components.oar.max_velocity = 3.5
			end
			if inst.components.finiteuses then
				inst.components.finiteuses:SetConsumption(ACTIONS.ROW_CONTROLLER, 1)
				inst.components.finiteuses:SetConsumption(ACTIONS.ROW_FAIL, 2)
			end	
		end,
		clearfn=function(inst,newaction)--清除工具信息
			if newaction ~= ACTIONS.ROW then
				inst:RemoveTag("allow_action_on_impassable")
				if inst.components.oar ~= nil then
					inst:RemoveComponent("oar")
				end
			end
		end,
	},
}

--切换移植状态标签
local function changeTransplantTag(inst,owner)
	if TheWorld.state.isfullmoon or owner:HasTag("inmoonlight") then
		inst:AddTag("MEDALTRANSPLANT_tool")--移植工具标签
		owner.medal_transplantman = true--月光移植者(可铲出砧木桩)
	else
		inst:RemoveTag("MEDALTRANSPLANT_tool")
		owner.medal_transplantman = nil
	end
end
--切换月光破坏状态标签
local function changeHammerTag(inst,owner)
	if TheWorld.state.isfullmoon or owner:HasTag("inmoonlight") then
		inst:AddTag("MEDALHAMMER_tool")--破坏工具标签
	else
		inst:RemoveTag("MEDALHAMMER_tool")
	end
end

local SORB_TOOL_DATA = {
	{--大理石斧头
		id = 11,
		action=ACTIONS.CHOP,--动作
		effectiveness=TUNING_MEDAL.MARBLEAXE.EFFICIENCY,--效率
		image="medal_shadow_axe",--物品栏贴图名
		bank="marbleaxe",
		build="marbleaxe",
		anim="idle",
		swapbuild="swap_marbleaxe",--手持build
		swapsymbol="swap_marbleaxe",--手持symbol
	},
	{--大理石镐子
		id = 12,
		action=ACTIONS.MINE,
		effectiveness=TUNING_MEDAL.MARBLEPICKAXE.EFFICIENCY,
		image="medal_shadow_pickaxe",
		bank="marblepickaxe",
		build="marblepickaxe",
		anim="marblepickaxe",
		swapbuild="marblepickaxe",
		swapsymbol="swap_marblepickaxe",
	},
	{--月光玻璃铲
		id = 13,
		action=ACTIONS.DIG,
		effectiveness=TUNING_MEDAL.MOONGLASS_TOOL.EFFICIENCY,
		image="medal_shadow_shovel",
		bank="shovel",
		build="medal_moonglass_shovel",
		anim="idle",
		swapbuild="swap_medal_moonglass_shovel",
		swapsymbol="swap_shovel",
		fn=function(inst)
			if inst.components.tool then
				inst.components.tool:SetAction(ACTIONS.MEDALTRANSPLANT, 1)--设置月光移植动作
				inst.components.tool:SetAction(ACTIONS.MEDALNORMALTRANSPLANT, 1)--设置普通移植动作
				inst:RemoveTag("MEDALTRANSPLANT_tool")--清除移植工具标签
			end
			if inst.components.finiteuses then
				inst.components.finiteuses:SetConsumption(ACTIONS.MEDALTRANSPLANT, 1)
				inst.components.finiteuses:SetConsumption(ACTIONS.MEDALNORMALTRANSPLANT, 1)
			end		
		end,
		equipfn=function(inst,owner)
			owner.medal_has_moon_shovel = true--手持月光玻璃铲
			inst.changetooltag = function(source,isfullmoon)
				changeTransplantTag(inst,owner)
			end
			inst:WatchWorldState("isfullmoon", inst.changetooltag)--监听月圆
			inst:ListenForEvent("change_medal_moonlinght", inst.changetooltag, owner)--监听玩家月光环境变化
			
			changeTransplantTag(inst,owner)
		end,
		unequipfn=function(inst,owner)
			owner.medal_has_moon_shovel = nil
			inst:StopWatchingWorldState("isfullmoon", inst.changetooltag)--取消监听月圆事件
			inst:RemoveEventCallback("change_medal_moonlinght", inst.changetooltag,owner)
			inst.changetooltag = nil
			inst:RemoveTag("MEDALTRANSPLANT_tool")--清除移植工具标签
			owner.medal_transplantman = nil--清除移植者标签
		end,
	},
	{--月光玻璃锤
		id = 14,
		action=ACTIONS.HAMMER,
		effectiveness=TUNING_MEDAL.MOONGLASS_TOOL.EFFICIENCY,
		image="medal_shadow_hammer",
		bank="medal_moonglass_hammer",
		build="medal_moonglass_hammer",
		anim="idle",
		swapbuild="swap_medal_moonglass_hammer",
		swapsymbol="swap_hammer",
		fn=function(inst)
			if inst.components.tool then
				inst.components.tool:SetAction(ACTIONS.MEDALHAMMER, 1)--设置破坏动作
				inst:RemoveTag("MEDALHAMMER_tool")--清除月光破坏工具标签
			end
			if inst.components.finiteuses then
				inst.components.finiteuses:SetConsumption(ACTIONS.MEDALHAMMER, 1)
			end	
		end,
		equipfn=function(inst,owner)
			owner.medal_has_moon_hammer = true--手持月光玻璃锤
			inst.changehammertag = function(source,isfullmoon)
				changeHammerTag(inst,owner)
			end
			inst:WatchWorldState("isfullmoon", inst.changehammertag)--监听月圆
			inst:ListenForEvent("change_medal_moonlinght", inst.changehammertag, owner)--监听玩家月光环境变化
			
			changeHammerTag(inst,owner)
		end,
		unequipfn=function(inst,owner)
			owner.medal_has_moon_hammer = nil
			inst:StopWatchingWorldState("isfullmoon", inst.changehammertag)--取消监听月圆事件
			inst:RemoveEventCallback("change_medal_moonlinght", inst.changehammertag,owner)--取消监听玩家状态
			inst.changehammertag = nil
			inst:RemoveTag("MEDALHAMMER_tool")--清除月光破坏工具标签
		end,
	},
	{--月光玻璃网
		id = 15,
		action=ACTIONS.NET,
		effectiveness=TUNING_MEDAL.MOONGLASS_TOOL.EFFICIENCY,
		image="medal_shadow_bugnet",
		bank="bugnet",
		build="swap_medal_moonglass_bugnet",
		anim="idle",
		swapbuild="swap_medal_moonglass_bugnet",
		swapsymbol="swap_bugnet",
		equipfn=function(inst,owner)
			owner.spore_moon_catcher = true--月亮孢子捕手
		end,
		unequipfn=function(inst,owner)
			owner.spore_moon_catcher = nil--月亮孢子捕手
		end,
	},
}

--五合一工具
table.insert(TOOL_DATA,{
	id = 9,
	str=STRINGS.MEDAL_SHADOW_TOOL_UI.MULTI_USE,
	action=ACTIONS.CHOP,
	image="medal_shadow_axe",
	bank="axe",
	build="axe",
	anim="idle",
	swapbuild="swap_axe",
	swapsymbol="swap_axe",
	showimg="multi_use.tex",
	is_multi_tool = true,--五合一标记
	fn=function(inst)
		--同时拥有多种功能
		for i, v in ipairs(SORB_TOOL_DATA) do
			local tool_info = IsSorb(inst, i) and v or TOOL_DATA[i]
			if inst.components.tool then
				inst.components.tool:SetAction(tool_info.action, tool_info.effectiveness or 1)
			end
			if inst.components.finiteuses then
				inst.components.finiteuses:SetConsumption(tool_info.action, tool_info.consume or 1)
			end
			if tool_info.fn then
				tool_info.fn(inst)
			end
		end
	end,
	equipfn=function(inst,owner)
		owner.medal_multi_use_tool = true--多用工具
		for i, v in ipairs(SORB_TOOL_DATA) do
			local tool_info = IsSorb(inst, i) and v or TOOL_DATA[i]
			if tool_info.equipfn then
				tool_info.equipfn(inst,owner)
			end
		end
	end,
	unequipfn=function(inst,owner)
		owner.medal_multi_use_tool = nil--多用工具
		for i, v in ipairs(SORB_TOOL_DATA) do
			local tool_info = IsSorb(inst, i) and v or TOOL_DATA[i]
			if tool_info.unequipfn then
				tool_info.unequipfn(inst,owner)
			end
		end
	end,
})

local TOOL_CLEAR_FNS = {}--特殊工具形态清理列表

local ICON_SCALE = .6
local ICON_RADIUS = 50
local SPELLBOOK_RADIUS = 100
local SPELLBOOK_FOCUS_RADIUS = SPELLBOOK_RADIUS + 2
local SPELLS ={}

for i, v in ipairs(TOOL_DATA) do
	--加入动作轮盘
	table.insert(SPELLS,{
		label = v.str,
		execute = function(inst)
			SendModRPCToServer(MOD_RPC.functional_medal.ShadowToolSwitch, inst, i)
		end,
		atlas = "images/medal_shadow_tool_icons.xml",
		normal = v.showimg,
		widget_scale = ICON_SCALE,
		hit_radius = ICON_RADIUS,
	})
	--加入工具形态清理列表
	if v.clearfn ~= nil then
		table.insert(TOOL_CLEAR_FNS,v.clearfn)
	end
end

--是否为五合一工具
local function IsMultiTool(inst)
	return inst.tool_idx and TOOL_DATA[inst.tool_idx] and TOOL_DATA[inst.tool_idx].is_multi_tool
end

--重置工具状态(inst)
local function ResetToolAction(inst)--,newaction,act_type)
	local tool_info = IsSorb(inst) and SORB_TOOL_DATA[inst.tool_idx] or TOOL_DATA[inst.tool_idx] or {}
	local act_type = tool_info.actiontype or 1--1工具、2特殊工具
	local newaction = tool_info.action or ACTIONS.CHOP
	local effectiveness = tool_info.effectiveness or 1--工作效率
	local consume = tool_info.consume or 1--耐久消耗
	--清除特殊工具状态
	for _, v in ipairs(TOOL_CLEAR_FNS) do
		v(inst,newaction)
	end

	--重新绑定动作
	if inst.components.tool then
		for k, v in pairs(inst.components.tool.actions) do
			inst:RemoveTag(k.id.."_tool")
		end
		inst.components.tool.actions = {}
		if act_type==1 then
			inst.components.tool:SetAction(newaction, effectiveness)
		end
	end

	--重置动作消耗
	if inst.components.finiteuses then
		inst.components.finiteuses.consumption = {}
		inst.components.finiteuses:SetConsumption(newaction, consume)
	end

	if tool_info.fn then
		tool_info.fn(inst)
	end
	--已经处于装备状态需要执行equipfn方法
	if tool_info.equipfn and inst.components.equippable and inst.components.equippable:IsEquipped() then
		local owner = inst.components.inventoryitem and inst.components.inventoryitem:GetGrandOwner()
		if owner ~= nil then
			tool_info.equipfn(inst,owner)
		end
	end
end

--重置工具场景动画
local function ResetToolAnim(inst, idx)
	idx = idx or (IsMultiTool(inst) and 1 or inst.tool_idx)
	local tool_info = IsSorb(inst, idx) and SORB_TOOL_DATA[idx] or TOOL_DATA[idx] or {}
	if inst.tool_id == tool_info.id then return end--重复ID就没必要切贴图了
	inst.tool_id = tool_info.id--记录下ID防止重复切换贴图
	inst.components.inventoryitem:ChangeImageName(tool_info.image or "axe")
	inst.AnimState:SetBank(tool_info.bank or "axe")
    inst.AnimState:SetBuild(tool_info.build or "axe")
    inst.AnimState:PlayAnimation(tool_info.anim or "idle")
	if IsSorb(inst, idx) then
		inst.AnimState:SetMultColour(1, 1, 1, 1)
	else
		inst.AnimState:SetMultColour(0, 0, 0, .5)
	end
	if inst.components.equippable and inst.components.equippable:IsEquipped() then
		local owner = inst.components.inventoryitem and inst.components.inventoryitem:GetGrandOwner()
		if owner ~= nil and owner.AnimState ~= nil then
			SpawnMedalFX("explode_reskin",owner)
			owner.AnimState:SetSymbolMultColour("swap_object",inst.symbol_mult[1] or 1,inst.symbol_mult[2] or 1,inst.symbol_mult[3] or 1,inst.symbol_mult[4] or 1)
			owner.AnimState:OverrideSymbol("swap_object",tool_info.swapbuild or "swap_axe", tool_info.swapsymbol or "swap_axe")
			--未吸收的黑化
			if not IsSorb(inst, idx)then
				inst.symbol_mult[1],inst.symbol_mult[2],inst.symbol_mult[3],inst.symbol_mult[4]=owner.AnimState:GetSymbolMultColour("swap_object")
				owner.AnimState:SetSymbolMultColour("swap_object", 0, 0, 0, .5)
			end
		end
	end
end

--移除上一种工具的特殊效果
local function DoOldUnEquipFn(inst)
	local tool_info = IsSorb(inst) and SORB_TOOL_DATA[inst.tool_idx] or TOOL_DATA[inst.tool_idx] or {}
	--已经处于装备状态需要执行unequipfn方法
	if tool_info.unequipfn and inst.components.equippable and inst.components.equippable:IsEquipped() then
		local owner = inst.components.inventoryitem and inst.components.inventoryitem:GetGrandOwner()
		if owner ~= nil then
			tool_info.unequipfn(inst,owner)
		end
	end
end

--切换工具
local function SwitchTool(inst,idx)
	if idx == inst.tool_idx then return end--编号重复了就不用切换了
	if idx and TOOL_DATA[idx] then
		-- if inst:CanDoAction(TOOL_DATA[idx].action) then return end
		DoOldUnEquipFn(inst)--移除上一种装备的效果,要在索引改变之前执行
		inst.tool_idx = idx
		ResetToolAnim(inst)
		ResetToolAction(inst)
	end
end

--装备
local function onequip(inst, owner)
	local tool_info = IsSorb(inst) and SORB_TOOL_DATA[inst.tool_idx] or TOOL_DATA[inst.tool_idx] or {}
	--五合一形态
	if IsMultiTool(inst) then
		local idx = inst.tool_id and (inst.tool_id % 10) or 1
		local is_sorb = IsSorb(inst,idx)
		local symbol_info = is_sorb and SORB_TOOL_DATA[idx] or TOOL_DATA[idx] or {}
		owner.AnimState:OverrideSymbol("swap_object", symbol_info.swapbuild or "swap_axe", symbol_info.swapsymbol or "swap_axe")
		--未吸收的黑化
		if not is_sorb then
			inst.symbol_mult[1],inst.symbol_mult[2],inst.symbol_mult[3],inst.symbol_mult[4]=owner.AnimState:GetSymbolMultColour("swap_object")
			owner.AnimState:SetSymbolMultColour("swap_object", 0, 0, 0, .5)
		end
	else
		owner.AnimState:OverrideSymbol("swap_object",tool_info.swapbuild or "swap_axe", tool_info.swapsymbol or "swap_axe")
		--未吸收的黑化
		if not IsSorb(inst) then
			inst.symbol_mult[1],inst.symbol_mult[2],inst.symbol_mult[3],inst.symbol_mult[4]=owner.AnimState:GetSymbolMultColour("swap_object")
			owner.AnimState:SetSymbolMultColour("swap_object", 0, 0, 0, .5)
		end
	end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	if tool_info.equipfn then
		tool_info.equipfn(inst,owner)
	end
end
--卸下
local function onunequip(inst, owner)
	local tool_info = IsSorb(inst) and SORB_TOOL_DATA[inst.tool_idx] or TOOL_DATA[inst.tool_idx] or {}
	owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	owner.AnimState:SetSymbolMultColour("swap_object",inst.symbol_mult[1] or 1,inst.symbol_mult[2] or 1,inst.symbol_mult[3] or 1,inst.symbol_mult[4] or 1)
	if tool_info.unequipfn then
		tool_info.unequipfn(inst,owner)
	end
end

--添加可装备组件相关内容
local function SetupEquippable(inst)
	inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
end

--不朽工具自定义方法
local function onImmortalToolFn(inst,level,isadd)
	inst:AddTag("cansorbtool")--可吸收工具能力
end

--可吸收工具列表
local TOOL_LIST = {
	marbleaxe = 1,
	marblepickaxe = 2,
	medal_moonglass_shovel = 3,
	medal_moonglass_hammer = 4,
	medal_moonglass_bugnet = 5,
}

--工具能力吸收
local function SorbToolFn(inst,tool,owner)
	local idx = tool ~= nil and TOOL_LIST[tool.prefab]
	if idx == nil or inst.sorb_record[idx] == nil then return false,"UNSUPPORTED" end--不在可吸收列表里
	if inst.sorb_record[idx] > 0 then
		return false,"ALREADY"--早吸收过了
	end
	if inst.tool_idx == idx then
		DoOldUnEquipFn(inst)
	end
	inst.sorb_record[idx] = 1

	if inst.tool_idx == idx or IsMultiTool(inst) then--吸收当前对应的工具或者是五合一工具,则需要重置下效果
		ResetToolAnim(inst)
		ResetToolAction(inst)
	end
	
	tool:Remove()
	MedalSay(owner,STRINGS.MEDALUPGRADESPEECH.SUCCESS)
	
	return true
end

local function onSaveFn(inst,data)
	data.sorb_record = json.encode(inst.sorb_record)
	data.tool_idx = inst.tool_idx
end

local function onLoadFn(inst,data)
	if data then
		if data.sorb_record then
			inst.sorb_record = json.decode(data.sorb_record)
		end
		inst.tool_idx = data.tool_idx or 1
	end
	ResetToolAnim(inst)
	ResetToolAction(inst)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("axe")
    inst.AnimState:SetBuild("axe")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetMultColour(0, 0, 0, .5)

    inst:AddTag("sharp")

    --tool (from tool component) added to pristine state for optimization
    inst:AddTag("tool")

    if TheNet:GetServerGameMode() ~= "quagmire" then
        --weapon (from weapon component) added to pristine state for optimization
        inst:AddTag("weapon")
    end

	inst.medal_repair_common = {--修补列表
		nightmarefuel = TUNING_MEDAL.MEDAL_SHADOW_TOOL.ADDUSE,--噩梦燃料
    }

	inst.medal_repair_immortal = {--修补列表
		immortal_essence = TUNING_MEDAL.MEDAL_SHADOW_TOOL.MAXUSES*.5,--不朽精华
		immortal_fruit = TUNING_MEDAL.MEDAL_SHADOW_TOOL.MAXUSES,--不朽果实
	}

    MakeInventoryFloatable(inst, "small", 0.05, {1.2, 0.75, 1.2})

	inst:AddComponent("spellbook")
	-- inst.components.spellbook:SetRequiredTag("medal_shadow_tool_user")
	inst.components.spellbook:SetRadius(SPELLBOOK_RADIUS)
	inst.components.spellbook:SetFocusRadius(SPELLBOOK_FOCUS_RADIUS)
	inst.components.spellbook:SetItems(SPELLS)
	inst.components.spellbook.opensound = "dontstarve/HUD/craft_open"
	inst.components.spellbook.closesound = "dontstarve/HUD/craft_close"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.tool_idx = 1--状态索引

	inst.symbol_mult = {1,1,1,1}--颜色通道数据
	inst.sorb_record = {0,0,0,0,0}--吸收记录,0未吸收,1已吸收,下标和TOOL_DATA对应

    inst:AddComponent("inventoryitem")
	-- inst.components.inventoryitem.imagename = "axe"
	inst.components.inventoryitem.imagename = "medal_shadow_axe"
	inst.components.inventoryitem.atlasname = "images/medal_shadow_tool.xml"
    -----
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 1)

	-------
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING_MEDAL.MEDAL_SHADOW_TOOL.MAXUSES)
	inst.components.finiteuses:SetUses(TUNING_MEDAL.MEDAL_SHADOW_TOOL.MAXUSES)
	inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)--伐木

	-------
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(TUNING.AXE_DAMAGE)

    inst:AddComponent("inspectable")

    MakeHauntableLaunch(inst)
	
	-- inst.components.floater:SetBankSwapOnFloat(true, -11, {sym_build = "swap_marbleaxe"})

	inst.SorbToolFn = SorbToolFn
	inst.SwitchTool = SwitchTool
	inst.ResetToolAnim = ResetToolAnim

	inst.OnSave = onSaveFn
	inst.OnLoad = onLoadFn

	inst.onImmortalToolFn = onImmortalToolFn

	SetImmortalTool(inst,SetupEquippable,TUNING_MEDAL.MEDAL_SHADOW_TOOL.MAXUSES)

    return inst
end

return Prefab("medal_shadow_tool", fn, assets)