require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/trap_bramble.zip"),
	Asset("ANIM", "anim/trap_bat.zip"),
	Asset("ATLAS", "images/trap_bat.xml"),
	Asset("ATLAS", "minimap/trap_bat.xml" ),
	Asset("ATLAS_BUILD", "images/trap_bat.xml",256),
}

local function OnExplode(inst, target)
    inst.AnimState:PlayAnimation("trap")
    if target then
        inst.SoundEmitter:PlaySound("dontstarve/common/trap_teeth_trigger")
        if target.prefab=="bat" then
			target.components.combat:GetAttacked(inst, TUNING_MEDAL.TRAP_BAT_COMBAT)--蝙蝠一击必杀
		else
			target.components.combat:GetAttacked(inst, TUNING_MEDAL.TRAP_BAT_COMBAT_OTHER)
		end
    end
	
	if inst:HasTag("autoTrap") then
		--在水里不自动重置
		local x,y,z=inst.Transform:GetWorldPosition()
		if not TheWorld.Map:IsOceanAtPoint(x, y, z) then
			if inst.auto_task then
				inst.auto_task:Cancel()
				inst.auto_task=nil
			end
			inst.auto_task = inst:DoTaskInTime(TUNING_MEDAL.AUTOTRAP_RESET_TIME, function(inst)
				if inst.components.mine and inst.components.mine.issprung then
					inst.components.mine:Reset()
				end
				inst.auto_task=nil
			end)
		end
	end
end

local function OnResetMax(inst)
    if inst.components.inventoryitem ~= nil then
        inst.components.inventoryitem.nobounce = true
    end
	if not inst:IsInLimbo() then
        inst.MiniMapEntity:SetEnabled(true)
    end
    if not inst.AnimState:IsCurrentAnimation("idle") then
        inst.SoundEmitter:PlaySound("dontstarve/common/trap_teeth_reset")
        inst.AnimState:PlayAnimation("reset")
        inst.AnimState:PushAnimation("idle", false)
        -- inst.AnimState:PlayAnimation("idle")
    end
end

local function SetSprung(inst)
    if inst.components.inventoryitem ~= nil then
        inst.components.inventoryitem.nobounce = true
    end
    if not inst:IsInLimbo() then
        inst.MiniMapEntity:SetEnabled(true)
    end
    inst.AnimState:PlayAnimation("trap_idle")
end

local function SetInactive(inst)
    if inst.components.inventoryitem ~= nil then
        inst.components.inventoryitem.nobounce = false
    end
    inst.MiniMapEntity:SetEnabled(false)
    inst.AnimState:PlayAnimation("inactive")
	-- inst.AnimState:PlayAnimation("trap_idle")
end

local function OnDropped(inst)
    inst.components.mine:Deactivate()
end

local function ondeploy(inst, pt, deployer)
    inst.components.mine:Reset()
    inst.Physics:Stop()
    inst.Physics:Teleport(pt:Get())
end

local function OnHaunt(inst, haunter)
    if inst.components.mine == nil or inst.components.mine.inactive then
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_TINY
        Launch(inst, haunter, TUNING.LAUNCH_SPEED_SMALL)
        return true
    elseif not inst.components.mine.issprung then
        return false
    elseif math.random() <= TUNING.HAUNT_CHANCE_OFTEN then
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
        inst.components.mine:Reset()
        return true
    end
    return false
end

--升级成自动陷阱
local function setAutoTrap(inst)
	inst:AddTag("autoTrap")
    --如果处于触发后状态，则直接重置
	if inst.components.mine and inst.components.mine.issprung then
		inst.components.mine:Reset()
	end
	inst.medaltrapchangename:set(true)--名字加前缀
end

local function onsavefn(inst,data)
	if inst:HasTag("autoTrap") then
		data.autovalue=true
	end
end

local function onloadfn(inst,data)
	if data~=nil and data.autovalue then
		setAutoTrap(inst)
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.MiniMapEntity:SetIcon("trap_bat.tex")

    inst.AnimState:SetBank("trap_bramble")
    inst.AnimState:SetBuild("trap_bat")
    inst.AnimState:PlayAnimation("idle")
	
	inst.medaltrapchangename = net_bool(inst.GUID, "medaltrapchangename", "medaltrapchangenamedirty")
	inst:ListenForEvent("medaltrapchangenamedirty", function(inst)
		if inst:HasTag("autoTrap") and inst.medaltrapchangename:value() then
			inst.displaynamefn = function(aaa)
				return subfmt(STRINGS.NAMES["MEDAL_AUTO_TRAP"], { trap = STRINGS.NAMES[string.upper(inst.prefab)] })
			end
		end
	end)

    inst:AddTag("trap")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.setAutoTrap=setAutoTrap--升级为智能陷阱函数

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
	inst.components.inventoryitem.imagename = "trap_bat"
	inst.components.inventoryitem.atlasname = "images/trap_bat.xml"

    inst:AddComponent("mine")
    inst.components.mine:SetRadius(TUNING_MEDAL.TRAP_BAT_RADIUS)
    inst.components.mine:SetAlignment("player")
    inst.components.mine:SetOnExplodeFn(OnExplode)
    inst.components.mine:SetOnResetFn(OnResetMax)
    inst.components.mine:SetOnSprungFn(SetSprung)
    inst.components.mine:SetOnDeactivateFn(SetInactive)

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.LESS)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetOnHauntFn(OnHaunt)
	
	inst.components.mine:Reset()
	
	inst.OnSave = onsavefn
	inst.OnLoad = onloadfn

    return inst
end

return Prefab("trap_bat", fn, assets),
    MakePlacer("trap_bat_placer", "trap_bramble", "trap_bat", "idle")
