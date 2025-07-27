local assets =
{
    Asset("ANIM", "anim/bottled_moonlight.zip"),
    Asset("ATLAS", "images/bottled_moonlight.xml"),
	Asset("ATLAS_BUILD", "images/bottled_moonlight.xml",256),
}

local prefabs =
{
    "bottled_moonlight_light",
}

-----------------------------------------------------------------------
--食用函数(inst,食用者)
local function onEatenfFn(inst, eater)
    if eater.components.inventory then
		--概率返还瓶子，否则破碎成玻璃碎片
		if math.random()<TUNING_MEDAL.BOTTLED_RETURN_RATE then
			local newitem=SpawnPrefab("messagebottleempty")
			if newitem then
				eater.components.inventory:GiveItem(newitem)
			end
		else
			local newitem=SpawnPrefab("moonglass")
			if newitem then
				eater.components.inventory:GiveItem(newitem)
			end
		end
	end
	--添加移植者buff
    eater:AddDebuff("buff_medal_transplantable", "buff_medal_transplantable")
	--如果玩家已经绑定了相同的wormlight，则重新开始计时;如果是不同的wormlight，则取消原来的
	if eater.wormlight ~= nil then
        if eater.wormlight.prefab == "bottled_moonlight_light" then
            eater.wormlight.components.spell.lifetime = 0
            eater.wormlight.components.spell:ResumeSpell()
            return
        else
            eater.wormlight.components.spell:OnFinish()
        end
    end
	--生成月光并绑定
    local light = SpawnPrefab("bottled_moonlight_light")
    light.components.spell:SetTarget(eater)
    if light:IsValid() then
        if light.components.spell.target == nil then
            light:Remove()
        else
            light.components.spell:StartSpell()
        end
    end
end
--定义道具
local function itemfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("bottled_moonlight")
    inst.AnimState:SetBuild("bottled_moonlight")
    inst.AnimState:PlayAnimation("bottled_moonlight")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	
	inst:AddTag("pre-preparedfood")--加工品，可以让沃利食用

    MakeInventoryPhysics(inst)

    inst.Light:SetFalloff(0.7)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(0.5)
    inst.Light:SetColour(169/255, 231/255, 245/255)
    inst.Light:Enable(true)
	
    MakeInventoryFloatable(inst, "small", 0.1, 0.9)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("edible")
	inst.components.edible.foodtype = FOODTYPE.GOODIES--好东西分类，可以给所有角色吃
	inst.components.edible.healthvalue = TUNING_MEDAL.BOTTLED_MOONLIGHT_HEALTHVALUE
	inst.components.edible.sanityvalue = TUNING_MEDAL.BOTTLED_MOONLIGHT_SANITYVALUE
    -- inst.components.edible.hungervalue = TUNING_MEDAL.BOTTLED_SOUL_HUNGERVALUE
	inst.components.edible:SetOnEatenFn(onEatenfFn)
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "bottled_moonlight"
    inst.components.inventoryitem.atlasname = "images/bottled_moonlight.xml"

    return inst
end

-----------------------------------------------------------------------

local lightprefabs =
{
    "bottled_moonlight_light_fx",
}
--光照继续
local function light_resume(inst, time)
    inst.fx:setprogress(1 - time / inst.components.spell.duration)
end
--光照开始
local function light_start(inst)
    inst.fx:setprogress(0)
end

local function pushbloom(inst, target)
    if target.components.bloomer ~= nil then
        target.components.bloomer:PushBloom(inst, "shaders/anim.ksh", -1)
    else
        target.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    end
end

local function popbloom(inst, target)
    if target.components.bloomer ~= nil then
        target.components.bloomer:PopBloom(inst)
    else
        target.AnimState:ClearBloomEffectHandle()
    end
end
--设定光照目标函数
local function light_ontarget(inst, target)
    if target == nil or target:HasTag("playerghost") or target:HasTag("overcharge") then
        inst:Remove()
        return
    end
	
    --状态移除
	local function forceremove()
        inst.components.spell:OnFinish()
    end

    target.wormlight = inst--和目标绑定
    --FollowSymbol position still works on blank symbol, just
    --won't be visible, but we are an invisible proxy anyway.
    inst.Follower:FollowSymbol(target.GUID, "", 0, 0, 0)--跟随目标，不可见的
    inst:ListenForEvent("onremove", forceremove, target)--监听目标被移除，移除直接结束状态
    inst:ListenForEvent("death", function() inst.fx:setdead() end, target)--监听目标死亡，死亡即执行光线死亡函数

    if target:HasTag("player") then
        inst:ListenForEvent("ms_becameghost", forceremove, target)--如果目标是玩家，变成鬼的时候也移除状态
        if target:HasTag("electricdamageimmune") then
            inst:ListenForEvent("ms_overcharge", forceremove, target)--目标是机器人，过载的时移除状态
        end
        inst.persists = false
    else
        inst.persists = not target:HasTag("critter")
    end

    pushbloom(inst, target)

    if target.components.rideable ~= nil then
        local rider = target.components.rideable:GetRider()
        if rider ~= nil then
            pushbloom(inst, rider)
            inst.fx.entity:SetParent(rider.entity)
        else
            inst.fx.entity:SetParent(target.entity)
        end

        inst:ListenForEvent("riderchanged", function(target, data)
            if data.oldrider ~= nil then
                popbloom(inst, data.oldrider)
                inst.fx.entity:SetParent(target.entity)
            end
            if data.newrider ~= nil then
                pushbloom(inst, data.newrider)
                inst.fx.entity:SetParent(data.newrider.entity)
            end
        end, target)
    else
        inst.fx.entity:SetParent(target.entity)
    end
end
--光照结束
local function light_onfinish(inst)
    local target = inst.components.spell.target
    if target ~= nil then
        target.wormlight = nil--清除目标绑定的wormlight

        popbloom(inst, target)

        if target.components.rideable ~= nil then
            local rider = target.components.rideable:GetRider()
            if rider ~= nil then
                popbloom(inst, rider)
            end
        end
    end
end

local function light_onremove(inst)
    inst.fx:Remove()
end
--定义灯光
local function lightfn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddFollower()
    inst:Hide()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    --[[Non-networked entity]]

    inst:AddComponent("spell")--持续状态组件
    inst.components.spell.spellname = "bottled_moonlight"--状态名
    inst.components.spell.duration = TUNING_MEDAL.MEDAL_BUFF_TRANSPLANTABLE_DURATION--持续时间
    inst.components.spell.ontargetfn = light_ontarget--设定目标函数
    inst.components.spell.onstartfn = light_start--状态开始
    inst.components.spell.onfinishfn = light_onfinish--状态结束
    inst.components.spell.resumefn = light_resume--状态继续
    inst.components.spell.removeonfinish = true--结束后移除

    inst.persists = false --until we get a target
    inst.fx = SpawnPrefab("bottled_moonlight_light_fx")
    inst.OnRemoveEntity = light_onremove

    return inst
end
-----------------------------------------------------------------------
--更新灯光(inst,帧数变化量)
local function OnUpdateLight(inst, dframes)
    --定义变化后帧数
	local frame =
        inst._lightdead:value() and--若光照结束，则
        math.ceil(inst._lightframe:value() * .9 + inst._lightmaxframe * .1) or--变化后帧数=(当前帧*0.9+最大帧数*0.1)向上取整
        (inst._lightframe:value() + dframes)--否则，变化后帧数=当前帧+帧数变化量
	--更新当前帧，如果变化后帧数>最大帧数，则取消光照定时器
    if frame >= inst._lightmaxframe then
        inst._lightframe:set_local(inst._lightmaxframe)
        inst._lighttask:Cancel()
        inst._lighttask = nil
    else
        inst._lightframe:set_local(frame)
    end
	--更新光照范围=最大半径*(1-当前帧/最大帧数)
    -- inst.Light:SetRadius(TUNING.WORMLIGHT_RADIUS * (1 - inst._lightframe:value() / inst._lightmaxframe))
    inst.Light:SetRadius(math.max(10 * (1 - inst._lightframe:value() / inst._lightmaxframe),3))
end
--光照变化函数
local function OnLightDirty(inst)
    if inst._lighttask == nil then
        --如果光照定时器为空，则定义为每帧(即每1/30秒执行一次更新光照的函数)
		inst._lighttask = inst:DoPeriodicTask(FRAMES, OnUpdateLight, nil, 1)
    end
    OnUpdateLight(inst, 0)--做一次无变帧更新
end
--设置光照进度
local function setprogress(inst, percent)
    --光照帧=max(0,min(最大帧数,(百分比*最大帧数)四舍五入))
	inst._lightframe:set(math.max(0, math.min(inst._lightmaxframe, math.floor(percent * inst._lightmaxframe + .5))))
    OnLightDirty(inst)--执行光照变化函数
end
--设置光照结束(玩家死亡时执行)
local function setdead(inst)
    inst._lightdead:set(true)--将结束状态标记为true
    inst._lightframe:set(inst._lightframe:value())
end
--定义灯光fx
local function lightfxfn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.Light:SetRadius(0)
    -- inst.Light:SetRadius(5)
    inst.Light:SetIntensity(.95)--光强
    -- inst.Light:SetIntensity(1)
    inst.Light:SetFalloff(.1)--光照衰减
    inst.Light:SetColour(20 / 255, 20 / 255, 255 / 255)--光照颜色，模拟月光
    inst.Light:Enable(true)
    inst.Light:EnableClientModulation(true)--启用客户端调制
	--最大帧数=(持续时间*30)四舍五入
    inst._lightmaxframe = math.floor(TUNING_MEDAL.MEDAL_BUFF_TRANSPLANTABLE_DURATION / FRAMES + .5)
    inst._lightframe = net_ushortint(inst.GUID, "bottled_moonlight_light_fx._lightframe", "moonlightdirty")--当前光照帧
    inst._lightframe:set(inst._lightmaxframe)--光照帧初始化为最大帧
    inst._lightdead = net_bool(inst.GUID, "bottled_moonlight_light_fx._lightdead")--光照结束，布尔值，设定为true后光照将进行一个由快到缓的曲线形快速缩小的动画
    inst._lighttask = nil--光照定时器

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("moonlightdirty", OnLightDirty)--监听光照帧变化

        return inst
    end

    inst.setprogress = setprogress--设置光照进度函数
    inst.setdead = setdead--设置光照结束函数
    inst.persists = false

    return inst
end

return  Prefab("bottled_moonlight", itemfn, assets, prefabs),
        Prefab("bottled_moonlight_light", lightfn, nil, lightprefabs),
        Prefab("bottled_moonlight_light_fx", lightfxfn)
