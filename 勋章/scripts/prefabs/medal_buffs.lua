--定时器结束
local function OnTimerDone(inst, data)
    if data.name == "buffover" then
        inst.components.debuff:Stop()
    end
end

--生成buff
local function MakeBuff(defs)
    --附加Buff函数
	local function OnAttached(inst, target,followsymbol, followoffset, data)
        inst.entity:SetParent(target.entity)
        inst.Transform:SetPosition(0, 0, 0) --in case of loading
        inst:ListenForEvent("death", function()
            inst.components.debuff:Stop()
        end, target)
		--获得buff提示
		if defs.priority then
			target:PushEvent("foodbuffattached", { buff = "ANNOUNCE_ATTACH_"..string.upper(defs.name), priority = defs.priority })
		end
        if defs.onattachedfn ~= nil then
            defs.onattachedfn(inst, target,followsymbol, followoffset, data)
        end
    end

    --延长buff函数
	local function OnExtended(inst, target,followsymbol, followoffset, data)
        local extend_duration = defs.duration
        local timer_left=inst.components.timer:GetTimeLeft("buffover")--获取定时器剩余时间
		if data and timer_left then
			--延长时间而不是直接用原来的固定时间替换
            if data.extend_duration then
                extend_duration = data.extend_duration+timer_left/2
            --或者自定义一个计算函数？是增是减随便咯
            elseif data.extend_durationfn then
                extend_duration = data.extend_durationfn(timer_left)
            end
			-- print("剩余:"..extend_duration)
		end
		inst.components.timer:StopTimer("buffover")
        inst.components.timer:StartTimer("buffover", extend_duration)
        --延长的时候才执行以下内容,否则就是减少Buff时长
        if timer_left==nil or extend_duration > timer_left then
            --获得buff提示
            if defs.priority then
                target:PushEvent("foodbuffattached", { buff = "ANNOUNCE_ATTACH_"..string.upper(defs.name), priority = defs.priority })
            end
            if defs.onextendedfn ~= nil then
                defs.onextendedfn(inst, target,followsymbol, followoffset, data)
            end
        end
    end

    --解除buff函数
	local function OnDetached(inst, target)
        if defs.ondetachedfn ~= nil then
            defs.ondetachedfn(inst, target)
        end
		--失去buff提示
		if defs.priority then
			target:PushEvent("foodbuffdetached", { buff = "ANNOUNCE_DETACH_"..string.upper(defs.name), priority = defs.priority })
		end
        inst:Remove()
    end

    local function fn()
        local inst = CreateEntity()

        if not TheWorld.ismastersim then
            --Not meant for client!
            inst:DoTaskInTime(0, inst.Remove)
            return inst
        end

        inst.entity:AddTransform()

        --[[Non-networked entity]]
        --inst.entity:SetCanSleep(false)
        inst.entity:Hide()
        inst.persists = false

        inst:AddTag("CLASSIFIED")

        inst:AddComponent("debuff")
        inst.components.debuff:SetAttachedFn(OnAttached)--设置附加Buff时执行的函数
        inst.components.debuff:SetDetachedFn(OnDetached)--设置解除buff时执行的函数
        inst.components.debuff:SetExtendedFn(OnExtended)--设置延长buff时执行的函数
        inst.components.debuff.keepondespawn = true

        inst:AddComponent("timer")--添加定时器
        inst.components.timer:StartTimer("buffover", defs.duration)
        inst:ListenForEvent("timerdone", OnTimerDone)--监听定时器结束并触发结束

        return inst
    end

    return Prefab(defs.name, fn, nil, defs.prefabs)
end

local medal_buffs={}
for k, v in pairs(require("medal_defs/medal_buff_defs")) do
    table.insert(medal_buffs, MakeBuff(v))
end
return unpack(medal_buffs)
