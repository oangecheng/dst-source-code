local assets =
{
    Asset("ANIM", "anim/forest_ferns.zip"),
}

local prefabs =
{
    "medal_origin_petals",
}

--枯萎
local function KillPlant(inst)
    inst.is_killed = true--标记为已枯萎,防止被重复调用
    inst.Declining = nil
    inst:RemoveTag("origin_pollinationable")
    if inst._decaytask ~= nil then
        inst._decaytask:Cancel()
        inst._decaytask = nil
    end
    
    if inst.decayfn ~= nil then
        inst:decayfn()
    end
    inst.components.pickable.caninteractwith = false
    inst:ListenForEvent("animover", inst.Remove)
    inst.AnimState:PlayAnimation("wilt"..inst.variation)
end
--衰败
local function Declining(inst,value)
    if inst.is_killed then return end
    inst.decay_value = (inst.decay_value or TUNING_MEDAL.MEDAL_ORIGIN_FLOWER_DECAY[TheWorld and TheWorld.medal_origin_tree and TheWorld.medal_origin_tree.phase or 1]) - (value or 1)
    if inst.decay_value <= 0 then
        KillPlant(inst)
    end
end

--盛开
local function OnBloomed(inst)
    inst:RemoveEventCallback("animover", OnBloomed)
    inst.AnimState:PlayAnimation("idle"..inst.variation, true)
    inst.components.pickable.caninteractwith = true
    --盛开之后就是衰败了
    inst._decaytask = inst:DoPeriodicTask(1,Declining)
end
--采到坏花的效果
local function PickBadFlower(inst,picker)
    --生成果蝇或果妖
    local rand = math.random()
    local item = SpawnPrefab(rand<.05 and "medal_sporecloud" or rand<.5 and "medal_origin_elf" or "medal_origin_fruitfly")
    if item ~= nil then
        item.Transform:SetPosition(inst.Transform:GetWorldPosition())
    end
end
--采集
local function OnPicked(inst, picker,badpick)--, loot)
    --采到坏花了,或者不在本源之树下采的,就会产生坏花的效果
    if badpick or not picker:HasTag("under_origin_tree") then
        PickBadFlower(inst,picker)
    end
    
    if inst._decaytask ~= nil then
        inst._decaytask:Cancel()
        inst._decaytask = nil
    end
    inst:RemoveEventCallback("animover", OnBloomed)
    inst:ListenForEvent("animover", inst.Remove)
    inst.AnimState:PlayAnimation("picked"..inst.variation)
end


local function MackFlower(def)
	local function fn()
        local inst = CreateEntity()
    
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
    
        inst.AnimState:SetBank("forest_fern")
        inst.AnimState:SetBuild("forest_ferns")
        inst.AnimState:PlayAnimation("bloom"..def.variation)
    
        inst:AddTag("origin_pollinationable")--可授粉
    
        inst:SetPrefabNameOverride("medal_origin_flower")
    
        inst.entity:SetPristine()
    
        if not TheWorld.ismastersim then
            return inst
        end
    
        inst.SoundEmitter:PlaySound("dontstarve/creatures/together/stalker/flowergrow")
    
        inst.variation = def.variation
        inst.decayfn = def.decayfn

        inst.Declining = Declining
    
        inst:AddComponent("pickable")
        inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
        inst.components.pickable.onpickedfn = def.pickfn
        -- inst.components.pickable.quickpick = true
        inst.components.pickable.caninteractwith = false
        inst.components.pickable.use_lootdropper_for_product = true
        inst.components.pickable:SetUp(nil)
        inst.components.pickable:Pause()
    
        inst:AddComponent("inspectable")
        inst:AddComponent("lootdropper")
        inst.components.lootdropper:AddChanceLoot("medal_origin_petals", .2)--采摘概率给本源花瓣
    
        inst:ListenForEvent("animover", OnBloomed)
    
        ---------------------
        -- MakeSmallBurnable(inst)
        -- MakeSmallPropagator(inst)
        -- inst.components.burnable:SetOnIgniteFn(nil)
        -- inst.components.burnable:SetOnExtinguishFn(nil)
        ---------------------
    
        -- MakeHauntableIgnite(inst)
    
        inst.persists = false
    
        return inst
    end
	
	return Prefab(def.name, fn, assets, prefabs)
end

local flowers_loot={
	{
		name="medal_origin_flower1",--预置物名
        variation = "",--动画编号
        pickfn = function(inst, picker)--采摘
            OnPicked(inst, picker)
        end,
        decayfn = function(inst)--枯萎
            --生成孢子云
            local item = SpawnPrefab("medal_sporecloud")
            if item ~= nil then
                item.Transform:SetPosition(inst.Transform:GetWorldPosition())
            end
        end,
	},
    {
		name="medal_origin_flower2",
        variation = "2",
        pickfn = function(inst, picker)
            OnPicked(inst, picker)
        end,
        decayfn = function(inst)
            --生成本源果蝇
            local item = SpawnPrefab("medal_origin_fruitfly")
            if item ~= nil then
                item.Transform:SetPosition(inst.Transform:GetWorldPosition())
            end
        end,
	},
    {
		name="medal_origin_flower3",
        variation = "3",
        pickfn = function(inst, picker)
            OnPicked(inst, picker)
        end,
        decayfn = function(inst)
            --生成果妖
            local item = SpawnPrefab("medal_origin_elf")
            if item ~= nil then
                item.Transform:SetPosition(inst.Transform:GetWorldPosition())
            end
        end,
	},
    {
		name="medal_origin_flower4",
        variation = "4",
        pickfn = function(inst, picker)
            OnPicked(inst, picker,true)
        end,
	},
    {
		name="medal_origin_flower5",
        variation = "4",
        pickfn = function(inst, picker)
            OnPicked(inst, picker)
        end,
	},
}

local flowers = {}
for i, v in ipairs(flowers_loot) do
    table.insert(flowers, MackFlower(v))
end
return unpack(flowers)
