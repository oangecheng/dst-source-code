require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/dragonfly_chest.zip"),
	Asset("ANIM", "anim/bearger_chest.zip"),
    Asset("ANIM", "anim/ui_chester_shadow_3x4.zip"),
	Asset("ATLAS", "minimap/bearger_chest.xml" ),
	Asset("ATLAS", "images/bearger_chest.xml"),
	Asset("IMAGE", "images/bearger_chest.tex"),
    Asset("ANIM", "anim/bearger_chest_upgraded.zip"),
    Asset("ANIM", "anim/dragonfly_chest_upgraded.zip"),
    Asset("ANIM", "anim/ui_chester_upgraded_3x4.zip"),
}

local prefabs =
{
    "collapse_small",
    "chestupgrade_stacksize_taller_fx",
    "medal_time_slider",
	"collapsed_bearger_chest",
}

--是否应该进入倒塌状态(防止同时溢出的东西过多)
local function ShouldCollapse(inst)
	if inst.components.container and inst.components.container.infinitestacksize then
		--NOTE: should already have called DropEverything(nil, true) (worked or deconstructed)
		--      so everything remaining counts as an "overstack"
		local overstacks = 0
		for k, v in pairs(inst.components.container.slots) do
			local stackable = v.components.stackable
			if stackable then
				overstacks = overstacks + math.ceil(stackable:StackSize() / (stackable.originalmaxsize or stackable.maxsize))
				if overstacks >= TUNING.COLLAPSED_CHEST_EXCESS_STACKS_THRESHOLD then
					return true
				end
			end
		end
	end
	return false
end

--进入倒塌状态(防止同时溢出的东西过多)
local function ConvertToCollapsed(inst, droploot)
	local x, y, z = inst.Transform:GetWorldPosition()
	if droploot then
		local fx = SpawnPrefab("collapse_small")
		fx.Transform:SetPosition(x, y, z)
		fx:SetMaterial("wood")
		inst.components.lootdropper.min_speed = 2.25
		inst.components.lootdropper.max_speed = 2.75
		inst.components.lootdropper:DropLoot()
		inst.components.lootdropper.min_speed = nil
		inst.components.lootdropper.max_speed = nil
	end

	inst.components.container:Close()
	inst.components.workable:SetWorkLeft(2)

	local pile = SpawnPrefab("collapsed_bearger_chest")
	pile.Transform:SetPosition(x, y, z)
	pile:SetChest(inst)
end

local function onopen(inst)
    inst.AnimState:PlayAnimation("open")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
end

local function onclose(inst)
    inst.AnimState:PlayAnimation("closed")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
end
--破坏
local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end
--锤击
local function onhit(inst, worker)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("closed", false)
end

--升级后被破坏
local function upgrade_onhammered(inst, worker)
	if ShouldCollapse(inst) then
		if TheWorld.Map:IsPassableAtPoint(inst.Transform:GetWorldPosition()) then
			inst.components.container:DropEverythingUpToMaxStacks(TUNING.COLLAPSED_CHEST_MAX_EXCESS_STACKS_DROPS)
			if not inst.components.container:IsEmpty() then
				ConvertToCollapsed(inst, true)
				return
			end
		else
			--sunk, drops more, but will lose the remainder
			inst.components.lootdropper:DropLoot()
			inst.components.container:DropEverythingUpToMaxStacks(TUNING.COLLAPSED_CHEST_EXCESS_STACKS_THRESHOLD)
			local fx = SpawnPrefab("collapse_small")
			fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
			fx:SetMaterial("wood")
			inst:Remove()
			return
		end
	end

	--fallback to default
	onhammered(inst, worker)
end
--升级后被锤击
local function upgrade_onhit(inst, worker)
	if inst.components.container ~= nil then
		inst.components.container:DropEverything(nil, true)
		inst.components.container:Close()
	end
	inst.AnimState:PlayAnimation("hit")
	inst.AnimState:PushAnimation("closed", false)
end
--从倒塌状态重建
local function OnRestoredFromCollapsed(inst)
	inst.AnimState:PlayAnimation("place")--("rebuild")
	inst.AnimState:PushAnimation("closed", false)
	inst.SoundEmitter:PlaySound("dontstarve/common/dragonfly_chest_craft")
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("closed", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/dragonfly_chest_craft")
end

--物品保鲜效率
local function itemPreserverRate(inst, item)
	--除了生物和鱼其他都永鲜
    return (item ~= nil and not (item:HasTag("fish") or item.components.health~=nil)) and 0 or nil
end

--状态提示
local function getstatus(inst, viewer)
	return inst._chestupgrade_stacksize and "UPGRADED_STACKSIZE" or nil
end
--同步升级后贴图
local function DoUpgradeVisuals(inst)
    -- local skin_name = (inst.AnimState:GetSkinBuild() or ""):gsub("dragonflychest_", "")
    --有皮肤则保持皮肤贴图，否则切换新贴图
    if inst.components.medal_skinable and inst.components.medal_skinable:GetSkinId() == 0 then
        inst.AnimState:SetBank("dragonfly_chest_upgraded")
        inst.AnimState:SetBuild("bearger_chest_upgraded")
    end
    
    -- if skin_name ~= "" then
    --     skin_name = "dragonflychest_upgraded_" .. skin_name
    --     inst.AnimState:SetSkin(skin_name, "dragonfly_chest_upgraded")
    -- end
end
--升级
local function OnUpgrade(inst, performer, upgraded_from_item)
    local numupgrades = inst.components.upgradeable.numupgrades
    if numupgrades == 1 then
        inst._chestupgrade_stacksize = true
        if inst.components.container ~= nil then
            inst.components.container:Close()
            inst.components.container:EnableInfiniteStackSize(true)
            inst.components.inspectable.getstatus = getstatus
        end
        --升级时需要有动画表现
        if upgraded_from_item then
            local x, y, z = inst.Transform:GetWorldPosition()
            local fx = SpawnPrefab("chestupgrade_stacksize_taller_fx")
            fx.Transform:SetPosition(x, y, z)
            -- local total_hide_frames = 6
            -- inst:DoTaskInTime(total_hide_frames * FRAMES, DoUpgradeVisuals)
        -- else
            -- DoUpgradeVisuals(inst)
        end
    end
    inst.components.upgradeable.upgradetype = nil

    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:SetLoot({ "medal_time_slider" })
    end
	inst.components.workable:SetOnWorkCallback(upgrade_onhit)
	inst.components.workable:SetOnFinishCallback(upgrade_onhammered)
	inst:ListenForEvent("restoredfromcollapsed", OnRestoredFromCollapsed)
end

--加载时同步升级后效果
local function OnLoad(inst, data, newents)
    if inst.components.upgradeable ~= nil and inst.components.upgradeable.numupgrades > 0 then
        OnUpgrade(inst)
    end
end

--分解
local function OnDecontructStructure(inst, caster)
    --升级过则分解出时空碎片(返还时空宝石是不可能的)
    if inst.components.upgradeable ~= nil and inst.components.upgradeable.numupgrades > 0 then
        if inst.components.lootdropper ~= nil then
            inst.components.lootdropper:SpawnLootPrefab("medal_time_slider")
        end
    end
    --变成倒塌状态并掉落部分道具
	if ShouldCollapse(inst) then
		inst.components.container:DropEverythingUpToMaxStacks(TUNING.COLLAPSED_CHEST_MAX_EXCESS_STACKS_DROPS)
		if not inst.components.container:IsEmpty() then
			ConvertToCollapsed(inst, false)
			inst.no_delete_on_deconstruct = true
			return
		end
	end

	--fallback to default
	inst.no_delete_on_deconstruct = nil
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("bearger_chest.tex")

    inst.AnimState:SetBank("dragonfly_chest")--用龙鳞箱的bank
    inst.AnimState:SetBuild("bearger_chest")
    inst.AnimState:PlayAnimation("closed",true)

    inst:AddTag("structure")
    inst:AddTag("chest")
	inst:AddTag("medal_skinable")--可换皮肤

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("bearger_chest")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
	
	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(itemPreserverRate)--保鲜

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:ListenForEvent("onbuilt", onbuilt)
    inst:ListenForEvent("ondeconstructstructure", OnDecontructStructure)

    MakeSnowCovered(inst)
	
	AddHauntableDropItemOrWork(inst)

    inst:AddComponent("medal_skinable")

    local upgradeable = inst:AddComponent("upgradeable")
    upgradeable.upgradetype = UPGRADETYPES.MEDAL_CHEST
    upgradeable:SetOnUpgradeFn(OnUpgrade)
	inst.OnLoad = OnLoad

    --兼容智能木牌
	if TUNING.SMART_SIGN_DRAW_ENABLE then
		SMART_SIGN_DRAW(inst)
	end

    return inst
end

return Prefab("bearger_chest", fn, assets, prefabs),
    MakePlacer("bearger_chest_placer", "dragonfly_chest", "bearger_chest", "closed")
